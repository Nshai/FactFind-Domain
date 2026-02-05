SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveATRRiskDataForAuthor]
@CRMContactId bigint,
@Type int = 0 -- 0=risk profile / investment, 1=retirement

AS

BEGIN


	declare @ATRTemplateGuid uniqueidentifier
	declare @TenantGuid uniqueidentifier
	declare @AtrCategoryId bigint
	declare @cid1 bigint, @cid2 bigint, @cid1Name varchar(255), @cid2Name varchar(255)
	declare @TenantId bigint
	declare @HasFreeTextAnswers bit

--create temp table to hold questions/answers as we don't know if we need to use TATRInvestmentGeneral or TATRRetirementGeneral
	declare @ATRGeneral TABLE (
		AtrGeneralId bigint PRIMARY KEY, 
		CRMContactId bigint,
		ClientAgreesWithProfile bit NULL,
		ClientChosenProfileGuid uniqueidentifier NULL,
		ClientNotes varchar(max),
		CalculatedRiskProfile uniqueidentifier NULL,
		Client2AgreesWithClient1 bit
	)

-- get the client's tenant	
	set @TenantId = (
		select IndClientId 
		from CRM..TCRMContact 
		WHERE CRMContactId = @CRMContactId
	)
	
-- get the tenant guid
	set @TenantGuid = (	
		select Guid 
		from Administration..TIndigoClient 
		WHERE IndigoClientId = @TenantId	
	)

-- get the active ATRTemplate
	select 
		@AtrTemplateGuid = Guid,
		@HasFreeTextAnswers = HasFreeTextAnswers 
	from TAtrTemplate 
	WHERE IndigoClientId = @TenantId AND Active = 1

-- get the ATRCategory based on the @Type, choose Default if not specified
	IF @Type = 0 
		set @AtrCategoryId = (	select ATRCategoryId from TATRInvestmentCategory where CRMContactId = @cid1 )
	else
		set @AtrCategoryId = (	select ATRCategoryId from TATRRetirementCategory where CRMContactId = @cid1 )

	IF @ATRCategoryId IS NULL
		SET @ATRCategoryId = (	SELECT ATRCategoryId FROM TATRCategoryCombined WHERE Name = 'Default' AND TenantGuid = @TenantGuid	)

-- get the client details. Can't assume that the CRMContactId we pass in is client1 in the FF.
	SELECT 
		@cid1 = CRMContactId1, 
		@cid2 = CRMContactId2, 
		@cid1Name = isnull(c1.FirstName,'') + isnull(' ' + c1.LastName,'') + isnull(c1.CorporateName,''),
		@cid2Name = isnull(c2.FirstName,'') + isnull(' ' + c2.LastName,'') + isnull(c2.CorporateName,'')
	FROM TFactFind f
	LEFT JOIN CRM..TCRMContact c1 ON c1.CRMContactId = f.CRMContactId1
	LEFT JOIN CRM..TCRMContact c2 on c2.CRMContactId = f.CRMContactId2
	WHERE (CRMContactId1 = @CRMContactId OR CRMContactId2 = @CRMContactId)
	
-- get the question sets for the @Type (investment/profile or retirement)
	IF @Type = 0
	BEGIN
		INSERT INTO @ATRGeneral (AtrGeneralId, CRMContactId, ClientAgreesWithProfile, ClientChosenProfileGuid, ClientNotes, CalculatedRiskProfile, Client2AgreesWithClient1)
		SELECT AtrInvestmentGeneralId, CRMContactId, Client1AgreesWithProfile, Client1ChosenProfileGuid, Client1Notes, CalculatedRiskProfile, Client2AgreesWithAnswers
		FROM TATRInvestmentGeneral
		WHERE CRMContactId in (@cid1, @cid2)
	END
	ELSE
	BEGIN
		INSERT INTO @ATRGeneral (AtrGeneralId, CRMContactId, ClientAgreesWithProfile, ClientChosenProfileGuid, ClientNotes, CalculatedRiskProfile)
		SELECT AtrRetirementGeneralId, CRMContactId, Client1AgreesWithProfile, Client1ChosenProfileGuid, Client1Notes, CalculatedRiskProfile
		FROM TATRRetirementGeneral
		WHERE CRMContactId in (@cid1, @cid2)
	END

-- create a work table to hold the results
declare @atr table (
	cid1Id bigint,
	cid1GeneratedRiskNumber int, 
	cid1GeneratedRiskDescriptor varchar(2000), 
	cid1GeneratedRiskBriefDescription varchar(1000),
	cid1ClientAgrees bit,
	cid1ChosenRiskNumber int,
	cid1ChosenRiskDescriptor varchar(2000), 
	cid1ChosenRiskBriefDescription varchar(1000),
	cid1CalculatedRiskNumber int,
	cid1CalculatedRiskDescriptor varchar(2000), 
	cid1CalculatedRiskBriefDescription varchar(1000),
	cid1Notes varchar(max),
	cid2AgreesWithCid1Answers bit,
	cid2Id bigint,
	cid2GeneratedRiskNumber int, 
	cid2GeneratedRiskDescriptor varchar(2000), 
	cid2GeneratedRiskBriefDescription varchar(1000),
	cid2ClientAgrees bit,
	cid2ChosenRiskNumber int,
	cid2ChosenRiskDescriptor varchar(2000), 
	cid2ChosenRiskBriefDescription varchar(1000),
	cid2CalculatedRiskNumber int,
	cid2CalculatedRiskDescriptor varchar(2000), 
	cid2CalculatedRiskBriefDescription varchar(1000),
	cid2Notes varchar(max)
	)
	
-- initialise the work table
	INSERT INTO @atr (cid1Id, cid2Id)
		select @cid1, @cid2	

-- create a temp table to hold the results of the generate sp		
	set @Type = @Type + 1 --translate to what the sp expects (1, 2 instead of 0, 1)
	
	declare @GeneratedRisk table (
		Guid uniqueidentifier, 
		RiskNumber int, 
		Descriptor varchar(2000), 
		BriefDescription varchar(2000)
	)

if @HasFreeTextAnswers != 1
begin
	-- retrieve the generated risk profile for client1
		insert @GeneratedRisk 
			EXEC SpNCustomAtrCalculateRiskProfile @ATRTemplateGuid, @cid1, @Type


	-- update the work table for client 1
		update @atr 
		set cid1GeneratedRiskNumber = RiskNumber, 
		cid1GeneratedRiskDescriptor = Descriptor, 
		cid1GeneratedRiskBriefDescription = BriefDescription
		FROM @GeneratedRisk

	if @cid2 > 0
	begin
		-- retrieve the generated risk profile for client2
		delete from @generatedRisk
		insert @GeneratedRisk 
			EXEC SpNCustomAtrCalculateRiskProfile @ATRTemplateGuid, @cid2, @Type

		-- update the work table for client 2
		update @atr 
		set cid2GeneratedRiskNumber = RiskNumber, 
		cid2GeneratedRiskDescriptor = Descriptor, 
		cid2GeneratedRiskBriefDescription = BriefDescription
		FROM @GeneratedRisk
	end
end

-- update the work table with the selected risk profile details
	update a
	set a.cid1ClientAgrees = g.ClientAgreesWithProfile,
	a.cid1Notes = g.ClientNotes,
	a.cid1ChosenRiskNumber = cho.RiskNumber,
	a.cid1ChosenRiskDescriptor = cho.Descriptor, 
	a.cid1ChosenRiskBriefDescription = cho.BriefDescription,
	a.cid2AgreesWithCid1Answers = g.Client2AgreesWithClient1
	from @atr a
	join @Atrgeneral g on g.CRMContactId = a.cid1Id
	LEFT JOIN PolicyManagement..TRiskProfileCombined cho on cho.Guid = g.ClientChosenProfileGuid
	


update a
	set a.cid2ClientAgrees = g.ClientAgreesWithProfile,
	a.cid2Notes = g.ClientNotes,
	a.cid2ChosenRiskNumber = cho.RiskNumber,
	a.cid2ChosenRiskDescriptor = cho.Descriptor, 
	a.cid2ChosenRiskBriefDescription = cho.BriefDescription
	from @atr a
	join @Atrgeneral g on g.CRMContactId = a.cid2Id
	LEFT JOIN PolicyManagement..TRiskProfileCombined cho on cho.Guid = g.ClientChosenProfileGuid
	
IF @HasFreeTextAnswers = 1
begin
	update a
	set
	a.cid1GeneratedRiskNumber = cal.RiskNumber,
	a.cid1GeneratedRiskDescriptor = cal.Descriptor,
	a.cid1GeneratedRiskBriefDescription = cal.BriefDescription
	from @atr a
	join @Atrgeneral g on g.CRMContactId = a.cid1Id
	LEFT JOIN PolicyManagement..TRiskProfileCombined cal on cal.Guid = g.CalculatedRiskProfile
	
	update a
	set
	a.cid2GeneratedRiskNumber = cal.RiskNumber,
	a.cid2GeneratedRiskDescriptor = cal.Descriptor,
	a.cid2GeneratedRiskBriefDescription = cal.BriefDescription
	from @atr a
	join @Atrgeneral g on g.CRMContactId = a.cid2Id
	LEFT JOIN PolicyManagement..TRiskProfileCombined cal on cal.Guid = g.CalculatedRiskProfile

end
	
-- return the results
	select 
	1 as tag,
	null as parent,
	@type-1 as [ATRGeneral!1!Type],
	cid1Id as [ATRGeneral!1!Client1Id],
	cid1GeneratedRiskNumber as [ATRGeneral!1!Client1GeneratedRiskNumber], 
	cid1GeneratedRiskDescriptor as [ATRGeneral!1!Client1GeneratedRiskDescriptor],
	cid1GeneratedRiskBriefDescription as [ATRGeneral!1!Client1GeneratedRiskBriefDescription],
	cid1ClientAgrees as [ATRGeneral!1!Client1ClientAgrees],
	cid1ChosenRiskNumber as [ATRGeneral!1!Client1ChosenRiskNumber],
	cid1ChosenRiskDescriptor as [ATRGeneral!1!Client1ChosenRiskDescriptor],
	cid1ChosenRiskBriefDescription as [ATRGeneral!1!Client1ChosenRiskBriefDescription],
	cid1CalculatedRiskNumber as [ATRGeneral!1!Client1CalculatedRiskNumber],
	cid1CalculatedRiskDescriptor as [ATRGeneral!1!Client1CalculatedRiskDescriptor],
	cid1CalculatedRiskBriefDescription as [ATRGeneral!1!Client1CalculatedRiskBriefDescription],
	cid1Notes as [ATRGeneral!1!Client1Notes],
	isnull(cid2AgreesWithCid1Answers,0) as [ATRGeneral!1!Client2AgreesWithClient1],
	cid2Id as [ATRGeneral!1!Client2Id],
	cid2GeneratedRiskNumber as [ATRGeneral!1!Client2GeneratedRiskNumber],
	cid2GeneratedRiskDescriptor as [ATRGeneral!1!Client2GeneratedRiskDescriptor],
	cid2GeneratedRiskBriefDescription as [ATRGeneral!1!Client2GeneratedRiskBriefDescription],
	cid2ClientAgrees as [ATRGeneral!1!Client2ClientAgrees],
	cid2ChosenRiskNumber as [ATRGeneral!1!Client2ChosenRiskNumber],
	cid2ChosenRiskDescriptor as [ATRGeneral!1!Client2ChosenRiskDescriptor],
	cid2ChosenRiskBriefDescription as [ATRGeneral!1!Client2ChosenRiskBriefDescription],
	cid2CalculatedRiskNumber as [ATRGeneral!1!Client2CalculatedRiskNumber],
	cid2CalculatedRiskDescriptor as [ATRGeneral!1!Client2CalculatedRiskDescriptor],
	cid2CalculatedRiskBriefDescription as [ATRGeneral!1!Client2CalculatedRiskBriefDescription],
	cid2Notes as [ATRGeneral!1!Client2Notes]
	from @atr
	FOR XML EXPLICIT
	

end


GO
