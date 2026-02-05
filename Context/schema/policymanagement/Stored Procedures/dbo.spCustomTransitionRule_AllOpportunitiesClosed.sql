SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_AllOpportunitiesClosed]
  @PolicyBusinessId BIGINT,
  @ErrorMessage VARCHAR(512) OUTPUT
AS
    BEGIN

	--make sure that the most recent opportunity campaign type is not null
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
	
	-- get the relationships of those owners (omit archived clients)
	INSERT INTO @Clients (CRMContactId)
	SELECT r.CrmContactToId 
	FROM CRM..TRelationship r
	JOIN @Clients c ON c.CRMContactId = r.CRMContactFromId
	JOIN CRM..TCRMContact rc with(nolock) ON rc.CRMContactId = R.CrmContactToId 
	WHERE rc.ArchiveFg = 0	
		
	INSERT INTO @Opportunities
	SELECT Distinct o.OpportunityId, oc.PartyId, 
	ISNULL(d.CorporateName,'') + ISNULL(d.firstName,'') + ' ' + ISNULL(d.LastName, ''),
	o.SequentialRef
	FROM CRM..TOpportunity o
	INNER JOIN CRM..TOpportunityCustomer oc ON oc.Opportunityid = o.OpportunityId
	INNER JOIN @Clients c ON c.CRMContactId = oc.PartyId
	INNER JOIN CRM..TCRMContact d on C.CRMContactId = d.CRMContactId
	WHERE o.IsClosed = 0


	If(SELECT COUNT(1) FROM @Opportunities) > 0
	BEGIN
		
		DECLARE @Ids VARCHAR(max)  
		SELECT @Ids = COALESCE(@Ids + '&&', '') + 
			convert(varchar(50),PartyId) + '::'+  
			convert(varchar(50),OpportunityId)  + '::'+  
			convert(varchar(20),Name)  + '::'+  
			convert(varchar(20),SequentialRef) 
		FROM @Opportunities
				
		SELECT @ErrorMessage = 'OPPNOTCLOSED_' + @Ids
		
		
	END

END



GO
