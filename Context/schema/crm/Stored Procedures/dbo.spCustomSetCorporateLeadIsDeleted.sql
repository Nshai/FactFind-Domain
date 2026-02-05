USE CRM
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue       Description
----        ---------       -------     -------------
20200702    Nick Fairway    IP-85397    Performance enhancements - use tempdb table so slow query only runs once.
*/
CREATE PROCEDURE dbo.spCustomSetCorporateTrustIsDeleted
	@TenantId int,
	@PartyId int,
	@StampUser int
AS
SET NOCOUNT ON;


IF NOT EXISTS (SELECT 1 FROM CRM..TCRMContact WHERE CRMContactId = @PartyId AND IndClientId = @TenantId AND IsDeleted = 0)
	RETURN;

-- Audit
EXEC dbo.SpNAuditCRMContact @StampUser, @PartyId, 'U'


-- Delete the Corp/Trust
UPDATE  
	dbo.TCRMContact
SET
	ExternalReference = 'DELETE_' + ExternalReference,
	IsDeleted = 1
WHERE	 
	 IndClientId = @TenantId
	 AND CRMContactId = @PartyId

	-- Delete Transform Engine Data
	IF OBJECT_ID('tempdb..#CorpTrustList') is not null drop table #CorpTrustList
	CREATE TABLE #CorpTrustList(CrmContactId int, TenantId int)
	create index IDX_CorpTrustList_CrmContactId on #CorpTrustList(CrmContactId)
	create index IDX_CorpTrustList_TenantId on #CorpTrustList(TenantId)
	create index IDX_CorpTrustList_TenantId_CrmContactId on #CorpTrustList(TenantId, CrmContactId)

    CREATE TABLE #ActivityCustomer  
    (   ActivityID          int NOT NULL PRIMARY KEY--INDEX IX@CorpTrustList_1
    ,   TenantId            int --INDEX IX@CorpTrustList_2
    ,   RelatedToLeadId     INT --INDEX IX@CorpTrustList_3
    ,   RelatedToId         INT
    ,   CrmContactId        INT --INDEX IX@CorpTrustList_4
    ,   ActivityCustomerId  INT --INDEX IX@CorpTrustList_5
    )

	INSERT INTO #CorpTrustList(CrmContactId, TenantId)
	SELECT a.CrmContactId, a.IndClientId 
	FROM CRM..TCRMContact a with (nolock)
	WHERE CRMContactId = @PartyId AND IndClientId = @TenantId

    -- use sdb
    INSERT #ActivityCustomer
    SELECT 
        A.ActivityID, B.TenantId, B.RelatedToLeadId, B.RelatedToId, C.CrmContactId, B.ActivityCustomerId
    FROM        SDB..Activity A -- 95967434     TenantId, ActivityId        
    INNER JOIN  SDB..ActivityCustomer B ON A.ActivityID = B.ActivityId -- 96182291       ActivityId    
	INNER JOIN  #CorpTrustList C ON B.TenantId = C.TenantId AND (B.RelatedToId = C.CrmContactId OR B.RelatedToLeadId = C.CrmContactId)


	-- SBD data, instead of TxE doing it
    
	-- Delete Activities for Obfuscated Clients
	Delete A
	from SDB..Activity A --
    INNER JOIN #ActivityCustomer B
    ON A.ActivityID = B.ActivityId
    AND B.RelatedToId = B.CrmContactId

	-- Delete Relationship between activies and  Obfuscated Clients use sdb
    DELETE B
	FROM        #ActivityCustomer       A
    INNER JOIN SDB..ActivityCustomer    B
    ON B.ActivityCustomerId = A.ActivityCustomerId
	INNER JOIN #CorpTrustList           C 
    ON A.TenantId = C.TenantId AND A.RelatedToId = C.CrmContactId

	-- Delete Activities for Obfuscated Leads
	DELETE A
	FROM SDB..Activity A
    INNER JOIN #ActivityCustomer B ON A.ActivityID = B.ActivityId AND B.RelatedToLeadId = B.CrmContactId

	-- Delete Relationship between activies and  Obfuscated leads
	Delete B
	from SDB..ActivityCustomer B
    INNER JOIN #ActivityCustomer A ON A.ActivityCustomerId = B.ActivityCustomerId 
    AND A.TenantId = B.TenantId
    INNER JOIN #CorpTrustList C ON B.TenantId = C.TenantId AND B.RelatedToLeadId = C.CrmContactId
    
    -- slow query
	-- ?? IGNORING DEPENDENTS
    	--Delete Objectives for Obfuscated Clients
	Delete A
	from SDB..Objective A
	INNER JOIN #CorpTrustList C ON A.TenantId = C.TenantId AND A.OwnerId = C.CrmContactId

	-- Delete Opportunities for Obfuscated Clients
	Delete A 
	from SDB..Opportunity A --
	INNER JOIN SDB..OpportunityCustomer B ON A.OpportunityId = B.ClientOpportunityId
	INNER JOIN #CorpTrustList C ON B.TenantId = C.TenantId AND B.ClientId = C.CrmContactId

	-- Delete Relationship between Opportunities and  Obfuscated Clients
	Delete B
	from SDB..OpportunityCustomer B
	INNER JOIN #CorpTrustList C ON B.TenantId = C.TenantId AND B.ClientOpportunityId = C.CrmContactId

	-- Delete Relationship between Quotes and  Obfuscated Clients
	Delete B
	from SDB..QuoteClient B
	INNER JOIN #CorpTrustList C ON B.TenantId = C.TenantId AND B.ClientPartyId = C.CrmContactId

	-- Delete Relationship between Fact Find and  Obfuscated Clients
	Delete B
	from SDB..FactFindQuestionAnswer B
	INNER JOIN #CorpTrustList C ON B.TenantId = C.TenantId AND B.ClientId = C.CrmContactId

	-- Delete Relationship between Client Share and  Obfuscated Clients
	Delete B 
	from SDB..ClientShare B
	INNER JOIN #CorpTrustList C ON B.TenantId = C.TenantId AND B.ClientId = C.CrmContactId

	-- Delete Relationship between Client Service History and  Obfuscated Clients
	Delete B
	from SDB..ClientServiceHistory B
	INNER JOIN #CorpTrustList C ON B.TenantId = C.TenantId AND B.ClientId = C.CrmContactId

	-- Delete Relationship between Client Service History and  Obfuscated Clients
	Delete B 
	from SDB..Client2 B
	INNER JOIN #CorpTrustList C ON B.TenantId = C.TenantId AND B.ClientId = C.CrmContactId

	-- Delete Relationship between Client Service History and  Obfuscated Clients
	Delete B
	from SDB..Tag B
	INNER JOIN #CorpTrustList C ON B.TenantId = C.TenantId AND B.EntityId = C.CrmContactId

	-- Client and Lead
	delete B
	from SDB..Client B
	inner join #CorpTrustList c on B.TenantId = C.TenantId AND B.ClientId = C.CrmContactId

	delete B
	from SDB..Lead B 
	inner join #CorpTrustList c on B.TenantId = C.TenantId AND B.LeadId = C.CrmContactId


	--Don't Drop Anonymous Temp Table and Indexes - leave them to the SQL runtime to do this where most efficient
	--if OBJECT_ID('tempdb..#CorpTrustList') is not null drop table #CorpTrustList
GO