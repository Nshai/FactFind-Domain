SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_LatestOpportunityOutletId]
  @PolicyBusinessId bigint,
  @ErrorMessage varchar(512) output
AS

	--make sure that the most recent opportunity outletid is not null
	
	-- check across all policyowners and related clients
	declare @clients TABLE (CRMContactId bigint)
	declare @Opportunities TABLE (OpportunityId Bigint, PartyId bigint, Name Varchar(200), SequentialRef varchar(20))

	
	-- get the policyowners
	INSERT INTO @Clients (CRMContactId)
	SELECT c.CRMContactId
	FROM PolicyManagement..TPolicyOwner po
	JOIN PolicyManagement..TPolicyBusiness pb ON po.PolicyDetailId = pb.PolicyDetailId
	JOIN CRM..TCRMContact c ON c.CRMContactId = po.CRMContactId
	WHERE pb.PolicyBusinessId = @PolicyBusinessId
	
	-- get the relationships of those owners
	INSERT INTO @Clients (CRMContactId)
	SELECT r.CrmContactToId 
	FROM CRM..TRelationship r
	JOIN @Clients c ON c.CRMContactId = r.CRMContactFromId
	
	-- Get the Max Opportunity
	Declare @MaxOpportunity Bigint
	Declare @MaxOpportunityPartyId Bigint
	SELECT @MaxOpportunity = Max(o.OpportunityId), 
		   @MaxOpportunityPartyId = oc.PartyId
	FROM CRM..TOpportunity o
	INNER JOIN CRM..TOpportunityCustomer oc ON oc.Opportunityid = o.OpportunityId
	INNER JOIN @Clients c ON c.CRMContactId = oc.PartyId 
	GROUP BY oc.PartyId
	
	If(ISNULL(@MaxOpportunity,0) = 0)
	BEGIN					
		SELECT @ErrorMessage = 'OPPNOTEXISTS'
		RETURN	
	END
	
	-- got the CRMContactId, now get the opportunities
	DECLARE @OutletCode varchar(255), @IntroducerName varchar(255)
	DECLARE @OpportunityId Bigint

	INSERT INTO @Opportunities
	SELECT Distinct o.OpportunityId, oc.PartyId, 
	ISNULL(d.CorporateName,'') + ISNULL(d.firstName,'') + ' ' + ISNULL(d.LastName, '') as Name,
			o.SequentialRef
	FROM CRM..TOpportunity o
	INNER JOIN CRM..TOpportunityCustomer oc ON oc.Opportunityid = o.OpportunityId
	INNER JOIN @Clients c ON c.CRMContactId = oc.PartyId
	INNER JOIN CRM..TCRMContact d on C.CRMContactId = d.CRMContactId
	LEFT JOIN CRM..TIntroducer i ON i.IntroducerId = o.IntroducerId
    LEFT JOIN CRM..TCRMContact cr on cr.CRMContactId = i.CRMContactId    
	WHERE --(cr.FirstName + ' ' + cr.LastName) != 'Self Generated' AND ?
	(ISNULL(o.Identifier,'') = '')
	AND o.OpportunityId = @MaxOpportunity 
	
	
	If(SELECT COUNT(1) FROM @Opportunities) > 0
	BEGIN
		
		DECLARE @Ids VARCHAR(max)  
		SELECT @Ids = COALESCE(@Ids + '&&', '') + 
			convert(varchar(50),PartyId) + '::'+  
			convert(varchar(50),OpportunityId)  + '::'+  
			convert(varchar(20),Name)  + '::'+  
			convert(varchar(20),SequentialRef) 
		FROM @Opportunities
				
		SELECT @ErrorMessage = 'OPPINTRO_' + @Ids
		
		
	END




GO
