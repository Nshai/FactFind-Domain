SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnGetDefaultRiskProfileForObjective](@ObjectiveId bigint)
RETURNS @RiskProfile TABLE (ObjectiveId bigint, RiskNumber int, Descriptor varchar(5000))
AS
BEGIN

	declare @ATRTemplateGuid uniqueidentifier
	declare @TenantGuid uniqueidentifier
	declare @TenantId bigint
	declare @HasFreeTextAnswers bit
	declare @CRMContactId1 bigint
	declare @ObjectiveTypeId bigint
	declare @Score int
	
--create temp table to hold questions/answers as we don't know if we need to use TATRInvestmentGeneral or TATRRetirementGeneral
	declare @ATRGeneral TABLE (
		AtrGeneralId bigint PRIMARY KEY, 
		CRMContactId bigint,
		ClientAgreesWithProfile bit NULL,
		ClientChosenProfileGuid uniqueidentifier NULL,
		ClientNotes varchar(8000),
		CalculatedRiskProfile uniqueidentifier NULL,
		Client2AgreesWithClient1 bit
	)

-- get some data about the objective
	select @TenantId = c.IndClientId,
		@ObjectiveTypeId = o.ObjectiveTypeId,
		@CRMContactId1 = o.CRMContactId
		from CRM..TCRMContact c
		join TObjective o on o.CRMContactId = c.CRMContactId
		WHERE o.ObjectiveId = @ObjectiveId
	
	
-- get the tenant guid
	set @TenantGuid = (	
		select Guid 
		from Administration..TIndigoClient 
		WHERE IndigoClientId = @TenantId	
	)

-- get the active ATRTemplate
	select @AtrTemplateGuid = 
		case 
			when BaseATRTemplate is null then Guid 
			else BaseATRTemplate 
		end,
		@HasFreeTextAnswers = HasFreeTextAnswers 
	from TAtrTemplate 
	WHERE IndigoClientId = @TenantId AND Active = 1

-- get the question sets for the @Type (investment/profile or retirement)
	IF @ObjectiveTypeId = 1
	BEGIN
		INSERT INTO @ATRGeneral (AtrGeneralId, CRMContactId, ClientAgreesWithProfile, ClientChosenProfileGuid, ClientNotes, CalculatedRiskProfile, Client2AgreesWithClient1)
		SELECT AtrInvestmentGeneralId, CRMContactId, Client1AgreesWithProfile, Client1ChosenProfileGuid, Client1Notes, CalculatedRiskProfile, Client2AgreesWithAnswers
		FROM TATRInvestmentGeneral
		WHERE CRMContactId = @CRMContactId1
	END
	ELSE
	BEGIN
		INSERT INTO @ATRGeneral (AtrGeneralId, CRMContactId, ClientAgreesWithProfile, ClientChosenProfileGuid, ClientNotes, CalculatedRiskProfile)
		SELECT AtrRetirementGeneralId, CRMContactId, Client1AgreesWithProfile, Client1ChosenProfileGuid, Client1Notes, CalculatedRiskProfile
		FROM TATRRetirementGeneral
		WHERE CRMContactId = @CRMContactId1
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
	cid1CalculatedRiskBriefDescription varchar(1000)
	)
	
-- initialise the work table
	INSERT INTO @atr (cid1Id)
		select @CRMContactId1

-- create a temp table to hold the results of the generate sp		
	
	declare @GeneratedRisk table (
		Guid uniqueidentifier, 
		RiskNumber int, 
		Descriptor varchar(2000), 
		BriefDescription varchar(2000)
	)
	
	
	
 
if @HasFreeTextAnswers != 1
begin
	-- retrieve the generated risk profile for client1
	IF @ObjectiveTypeId = 1 -- Investment  
		SELECT  @Score = SUM(ISNULL(A.Weighting, 0))  
		FROM TAtrQuestionCombined Q  
		JOIN TAtrAnswerCombined A ON A.AtrQuestionGuid = Q.Guid  
		JOIN TAtrInvestment I ON I.AtrAnswerGuid = A.Guid  
		WHERE Q.AtrTemplateGuid = @AtrTemplateGuid  
		AND I.CRMContactId = @CRMContactId1  
	ELSE  
		SELECT @Score = SUM(ISNULL(A.Weighting, 0))  
		FROM TAtrQuestionCombined Q  
		JOIN TAtrAnswerCombined A ON A.AtrQuestionGuid = Q.Guid  
		JOIN TAtrRetirement R ON R.AtrAnswerGuid = A.Guid  
		WHERE Q.AtrTemplateGuid = @AtrTemplateGuid  
		AND R.CRMContactId = @CRMContactId1   
	  
	insert into @GeneratedRisk   
	SELECT Guid, RiskNumber, Descriptor, BriefDescription   
	FROM PolicyManagement..TRiskProfileCombined  
	WHERE AtrTemplateGuid = @AtrTemplateGuid  
	AND LowerBand <= @Score AND @Score <= UpperBand  
	 
		

	-- update the work table for client 1
		update @atr 
		set cid1GeneratedRiskNumber = RiskNumber, 
		cid1GeneratedRiskDescriptor = Descriptor, 
		cid1GeneratedRiskBriefDescription = BriefDescription
		FROM @GeneratedRisk

end

-- update the work table with the selected risk profile details
	update a
	set a.cid1ClientAgrees = g.ClientAgreesWithProfile,
	a.cid1ChosenRiskNumber = cho.RiskNumber,
	a.cid1ChosenRiskDescriptor = cho.Descriptor, 
	a.cid1ChosenRiskBriefDescription = cho.BriefDescription
	from @atr a
	join @Atrgeneral g on g.CRMContactId = a.cid1Id
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
end

INSERT INTO @RiskProfile (ObjectiveId, RiskNumber, Descriptor)
SELECT 
	@ObjectiveId, 
	CASE 
		when isnull(a.cid1ClientAgrees,1) = 1 then a.cid1GeneratedRiskNumber
		else a.cid1ChosenRiskNumber
	END,
	CASE 
		when isnull(a.cid1ClientAgrees,1) = 1 then a.cid1GeneratedRiskDescriptor
		else a.cid1ChosenRiskDescriptor
	END
FROM @Atr a

RETURN
END

GO
