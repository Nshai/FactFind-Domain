SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON;
GO

/* =====================================================================================

Modification History (most recent first)
Date        Modifier        Issue       Description
----        ---------       -------     -------------
20210420    Nick Fairway    SDA-155     Minor perfromance changes for partitioning
20250429    Nick Fairway    COPS-40359  Minor perfromance fix - force hash join
===================================================================================== */
CREATE PROCEDURE dbo.SpCustomBulkUpdateExternalApplicationAccess
    @TenantId INT,
    @StampUserId INT,
    @IsClient BIT = null,
    @IsLead BIT = null,
    @BatchSize INT = 10000000
AS
SET NOCOUNT ON;

DECLARE @MinLastUpdatedForOutlookTimeStamp DATETIME = DATEADD(WEEK, -1, GETDATE());

If ISNULL(@TenantId,0) = 0
BEGIN
    RAISERROR('Tenant cannot be null',16,1);
    RETURN;
END

If ISNULL(@IsClient,0) = 0 And ISNULL(@IsLead,0) = 0
BEGIN
    RAISERROR('IsClient And IsLead cannot both be null',16,1);
    RETURN;
END

If ISNULL(@IsClient,0) = 1 And ISNULL(@IsLead,0) = 1
BEGIN
    RAISERROR('IsClient And IsLead cannot both be set',16,1);
    RETURN;
END

----------------------------------------------------
-- Ignore tenants where the status is not active
If Not Exists (SELECT
                    1
                FROM administration..TIndigoClient
                WHERE Status = 'active'
                AND IndigoClientId = @TenantId)
BEGIN
    RETURN;
END

----------------------------------------------------
IF OBJECT_ID('tempdb..#TempUsers') IS NOT NULL
    DROP TABLE #TempUsers;

DECLARE @Sql NVARCHAR(MAX)
       ,@EntityId INT
       ,@EntityIdentifier VARCHAR(25);

SELECT
    @EntityIdentifier =
    CASE
        WHEN ISNULL(@IsClient, 0) = 1 THEN 'CRMContact'
        WHEN ISNULL(@IsLead, 0) = 1 THEN 'Lead'
        ELSE 'not set'
    END
SELECT
    @EntityId = EntityId
FROM administration..TEntity
WHERE Descriptor = @EntityIdentifier;

IF ISNULL(@EntityId, 0) = 0
BEGIN
    RAISERROR ('EntityId must be set', 16, 1);
    RETURN;
END

----------------------------------------------------
--  which users do implicict sync users have access to

-- List users that SuperUsers/SuperViewer can see
SELECT DISTINCT
    a.UserId AS LicensedUserId
   ,b.UserId AS AccessibleUserId
   ,0 AS ForDelete 
INTO #TempUsers
FROM administration..TUser a WITH (NOLOCK)
    CROSS JOIN administration..TUser b WITH (NOLOCK)
WHERE 1 = 1
    AND a.IndigoClientId = @TenantId
    AND b.IndigoClientId = @TenantId
    AND a.IndigoClientId = b.IndigoClientId
    AND a.IsOutLookExtensionUser = 1
    AND (a.SuperUser = 1 OR a.SuperViewer = 1)
    AND a.RefUserTypeId = 1
    AND b.RefUserTypeId = 1
    AND a.UserId <> b.UserId;

SELECT
    @Sql = '

-- Entity security (user level) e.g. TCrmContactKey or TLeadKey
Insert Into #TempUsers WITH(TABLOCKX) (LicensedUserId, AccessibleUserId, ForDelete) 
Select distinct a.UserId, a.CreatorId , 0 '
    + 'From ' + Db + '..T' + Descriptor + 'Key a with(nolock) '
    + ' Join administration..TUser b with(nolock) on a.UserId = b.UserId '
    + ' Where EntityId Is Null '
    + ' And b.IndigoClientId = @TenantId '
    + ' And b.RefUserTypeId = 1 '
    + '
    
-- All users can see client''s/lead''s where they are the servicing adviser
Insert Into #TempUsers WITH(TABLOCKX) (LicensedUserId, AccessibleUserId, ForDelete) 
Select distinct a._OwnerId, a._OwnerId, 0 '
    + 'From crm..TCRMContact a with(nolock) '
    + ' Join administration..TUser b with(nolock) on a._OwnerId = b.UserId '
    + ' Where 1=1 '
    + ' And a.IndClientId = @TenantId '
    + ' And b.IndigoClientId = @TenantId '
    + ' And b.RefUserTypeId = 1 '
    + ' And b.IsOutLookExtensionUser = 1 '
    +
    CASE
        WHEN @EntityIdentifier = 'CRMContact' THEN ' and a._OwnerId is not null and a.RefCRMContactStatusId = 1 '
        WHEN @EntityIdentifier = 'Lead' THEN ' and a.RefCRMContactStatusId = 2  '
        ELSE ''
    END
FROM administration..TEntity
WHERE EntityId = @EntityId;

EXEC sp_executesql @Sql
                  ,N'@TenantId INT'
                  ,@TenantId;

INSERT INTO #TempUsers WITH(TABLOCKX) (LicensedUserId, AccessibleUserId, ForDelete)
SELECT
     a.UserId
    ,a.UserId
    ,1
FROM administration..TUser a
    LEFT JOIN #TempUsers b ON a.UserId = b.LicensedUserId
WHERE 1 = 1
    AND IndigoClientId = @TenantId
    AND b.LicensedUserId IS NULL;

---------------------------------------------------------------------------------------------------
-- mark user as deleted for users whose status is denied, archived or retired 
-- we should still be able to see items where the creator's status is one of the above

UPDATE A WITH(TABLOCKX)
SET ForDelete = 1
FROM #TempUsers A
    JOIN administration..TUser B ON A.LicensedUserId = B.UserId
                                    AND B.IndigoClientId = @TenantId
WHERE ForDelete = 0
    AND (Status NOT LIKE 'Access Granted%'
    OR IsOutLookExtensionUser = 0);

SELECT
    @Sql = '
Update A
Set A.IsDeleted = 1, 
    A.LastUpdatedDateTime = Getdate(), 
    A.IsForDeleteSync = case when ValueSentToClient is null then 0 else 1 End,
    A.IsForNewSync = 0, 
    A.IsForUpdateSync = 0
OUTPUT 
    deleted.TenantId, 
    deleted.UserId, 
    deleted.PartyId, 
    deleted.CreatedDateTime, 
    deleted.LastUpdatedDateTime, 
    deleted.LastSynchronisedDateTime, 
    deleted.ValueSentToClient, 
    deleted.IsForNewSync,
    deleted.IsForUpdateSync, 
    deleted.IsForDeleteSync, 
    deleted.IsDeleted, 
    deleted.ExternalApplication' + @EntityIdentifier + 'Id, 
    ''U'',
    GETDATE(), 
    @StampUserId
Into TExternalApplication' + @EntityIdentifier + 'Audit
(
    TenantId, 
    UserId, 
    PartyId, 
    CreatedDateTime, 
    LastUpdatedDateTime, 
    LastSynchronisedDateTime, 
    ValueSentToClient, 
    IsForNewSync, 
    IsForUpdateSync, 
    IsForDeleteSync, 
    IsDeleted, 
    ExternalApplication' + @EntityIdentifier + 'Id, 
    StampAction, 
    StampDateTime, 
    StampUser
)
From TExternalApplication' + @EntityIdentifier + ' a
Join #TempUsers b on a.UserId = b.LicensedUserId 
Where b.ForDelete = 1 And A.IsDeleted <> 1 And a.TenantId = @TenantId;

PRINT CONCAT(@@rowcount, '' records updated (marked as deleted \ for delete sync)'');'

EXEC sp_executesql @Sql
                  ,N'@StampUserId INT, @TenantId INT'
                  ,@StampUserId
                  ,@TenantId;

IF OBJECT_ID('tempdb..#TempUsers2') IS NOT NULL
    DROP TABLE #TempUsers2;

SELECT
    LicensedUserId
   ,AccessibleUserId INTO #TempUsers2
FROM #TempUsers
WHERE ForDelete = 0;

TRUNCATE TABLE #TempUsers;

---------------------------------------------------------------------------------------------------
-- Client additions updates

IF OBJECT_ID('tempdb..#TempParties') IS NOT NULL
    DROP TABLE #TempParties;

CREATE TABLE #TempParties
(
    Id INT NOT NULL IDENTITY(1,1),
    PartyId INT,
    LicensedUserId INT,
    LastStampDateTime DATETIME
);


IF @IsClient = 1
BEGIN
	INSERT INTO #TempParties WITH(TABLOCKX) (PartyId, LicensedUserId, LastStampDateTime)
	SELECT DISTINCT
		b.CRMContactId AS PartyId
	   ,a.LicensedUserId
	   ,CASE
			WHEN c.LastUpdatedForOutlookTimeStamp > @MinLastUpdatedForOutlookTimeStamp THEN c.LastUpdatedForOutlookTimeStamp
			ELSE b.CreatedDate
		END AS LastStampDateTime
	FROM #TempUsers2 a
		JOIN dbo.TCRMContact b WITH(NOLOCK) on a.AccessibleUserId = b._OwnerId -- use sdb
		LEFT JOIN sdb.dbo.Client c WITH (NOLOCK) ON c.ClientId = b.CRMContactId AND c.TenantId = b.IndClientId
	WHERE b.IndClientId = @TenantId
		AND b.ArchiveFg = 0
		AND b.RefCRMContactStatusId = 1
		
	PRINT CONCAT('Processing ', @@rowcount, ' records in batches by ', @BatchSize);
END

IF @IsLead = 1
BEGIN
	INSERT INTO #TempParties WITH(TABLOCKX) (PartyId, LicensedUserId, LastStampDateTime)
	SELECT --DISTINCT 
		b.CRMContactId AS PartyId
	   ,a.LicensedUserId
	   ,CASE
			WHEN c.LastUpdatedForOutlookTimeStamp > @MinLastUpdatedForOutlookTimeStamp THEN c.LastUpdatedForOutlookTimeStamp
			ELSE b.CreatedDate
		END AS LastStampDateTime
	FROM #TempUsers2 a
		JOIN dbo.TCRMContact b WITH(NOLOCK) on a.AccessibleUserId = b._OwnerId
		LEFT JOIN sdb.dbo.Lead c WITH (NOLOCK) ON c.LeadId = b.CRMContactId AND c.TenantId = b.IndClientId
	WHERE @IsLead = 1
		AND b.IndClientId = @TenantId
		AND b.ArchiveFg = 0
		AND b.RefCRMContactStatusId = 2;
		
	PRINT CONCAT('Processing ', @@rowcount, ' records in batches by ', @BatchSize);
END

DROP INDEX IF EXISTS IX_#TempParties ON #TempParties
CREATE CLUSTERED INDEX IX_#TempParties ON #TempParties (Id, PartyId, LicensedUserId);

DECLARE @BatchNumber INT = 1;
DECLARE @EndId INT = @BatchSize;
DECLARE @StartId INT = 0;
DECLARE @MaxId INT = (SELECT MAX(Id) FROM #TempParties);

-- Need to use batches to avoid transaction log growth
WHILE @StartId < @MaxId
BEGIN

    PRINT CONCAT('Batch #', @BatchNumber);

    -- Add new ones
    SELECT
        @Sql = '
    Insert Into TExternalApplication' + @EntityIdentifier + '
    (
        TenantId, 
        UserId, 
        PartyId, 
        CreatedDateTime, 
        LastUpdatedDateTime, 
        LastSynchronisedDateTime, 
        IsForNewSync
    )
    output 
        inserted.TenantId, 
        inserted.UserId, 
        inserted.PartyId, 
        inserted.CreatedDateTime, 
        inserted.LastUpdatedDateTime, 
        inserted.LastSynchronisedDateTime, 
        inserted.ValueSentToClient, 
        inserted.IsForNewSync,
        inserted.IsForUpdateSync, 
        inserted.IsForDeleteSync, 
        inserted.IsDeleted, 
        inserted.ExternalApplication' + @EntityIdentifier + 'Id, 
        ''C'',
        GETDATE(), 
        @StampUserId
    Into TExternalApplication' + @EntityIdentifier + 'Audit
    (
        TenantId, 
        UserId, 
        PartyId, 
        CreatedDateTime, 
        LastUpdatedDateTime, 
        LastSynchronisedDateTime, 
        ValueSentToClient, 
        IsForNewSync,
        IsForUpdateSync, 
        IsForDeleteSync, 
        IsDeleted, 
        ExternalApplication' + @EntityIdentifier + 'Id, 
        StampAction, 
        StampDateTime, 
        StampUser
    )
    Select 
        @TenantId, 
        a.LicensedUserId, 
        a.PartyId, 
        getdate(), 
        GETDATE(), 
        null, 
        1
    from #TempParties a
    LEFT HASH Join TExternalApplication' + @EntityIdentifier + ' c on a.LicensedUserId = c.UserId 
                                                    and a.PartyId = c.PartyId 
                                                    And TenantId = @TenantId
    Where a.Id <= @EndId 
        AND a.Id > @StartId 
        AND c.ExternalApplication' + @EntityIdentifier + 'Id is null;
    
    PRINT CONCAT(@@rowcount, '' new records inserted (for new sync)'');'


    EXEC sp_executesql @Sql
                      ,N'@StampUserId INT, @TenantId INT, @StartId int, @EndId int'
                      ,@StampUserId
                      ,@TenantId
                      ,@StartId
                      ,@EndId;

    ---------------------------------------------------------------------------------------------------
    -- Undelete existing ones
    SELECT
        @Sql = '
    Update A
    Set IsDeleted = 0, 
        LastUpdatedDateTime = Getdate(), 
        LastSynchronisedDateTime = null,
        IsForDeleteSync = 0, 
        IsForNewSync = 1, 
        IsForUpdateSync = 0
    OUTPUT
        deleted.TenantId, 
        deleted.UserId, 
        deleted.PartyId, 
        deleted.CreatedDateTime, 
        deleted.LastUpdatedDateTime, 
        deleted.LastSynchronisedDateTime, 
        deleted.ValueSentToClient, 
        deleted.IsForNewSync,
        deleted.IsForUpdateSync, 
        deleted.IsForDeleteSync, 
        deleted.IsDeleted, 
        deleted.ExternalApplication' + @EntityIdentifier + 'Id, 
        ''U'',
        GETDATE(), 
        @StampUserId
    Into TExternalApplication' + @EntityIdentifier + 'Audit
    (
        TenantId, 
        UserId, 
        PartyId, 
        CreatedDateTime, 
        LastUpdatedDateTime, 
        LastSynchronisedDateTime, 
        ValueSentToClient, 
        IsForNewSync,
        IsForUpdateSync, 
        IsForDeleteSync, 
        IsDeleted, 
        ExternalApplication' + @EntityIdentifier + 'Id, 
        StampAction, 
        StampDateTime, 
        StampUser
    )
    From TExternalApplication' + @EntityIdentifier + ' a
    Join #TempParties c on a.UserId = c.LicensedUserId and a.PartyId = c.PartyId 
    Where  c.Id <= @EndId 
        AND c.Id > @StartId 
        AND IsDeleted = 1 And TenantId = @TenantId;
    
    PRINT CONCAT(@@rowcount, '' records updated (for new sync)'');'

    EXEC sp_executesql @Sql
                      ,N'@StampUserId INT, @TenantId INT, @StartId int, @EndId int'
                      ,@StampUserId
                      ,@TenantId
                      ,@StartId
                      ,@EndId;

    ---------------------------------------------------------------------------------------------------
    -- Update existing ones
    SELECT
        @Sql = '
    Update A
    Set IsDeleted = 0, 
        LastUpdatedDateTime = Getdate(), 
        LastSynchronisedDateTime = null,
        IsForDeleteSync = 0, 
        IsForNewSync = 0, 
        IsForUpdateSync = 1
    OUTPUT
        deleted.TenantId, 
        deleted.UserId, 
        deleted.PartyId, 
        deleted.CreatedDateTime, 
        deleted.LastUpdatedDateTime, 
        deleted.LastSynchronisedDateTime, 
        deleted.ValueSentToClient, 
        deleted.IsForNewSync, 
        deleted.IsForUpdateSync, 
        deleted.IsForDeleteSync, 
        deleted.IsDeleted, 
        deleted.ExternalApplication' + @EntityIdentifier + 'Id, 
        ''U'',
        GETDATE(), 
        @StampUserId
    INTO TExternalApplication' + @EntityIdentifier + 'Audit
    (
        TenantId, 
        UserId, 
        PartyId, 
        CreatedDateTime, 
        LastUpdatedDateTime, 
        LastSynchronisedDateTime, 
        ValueSentToClient, 
        IsForNewSync,
        IsForUpdateSync, 
        IsForDeleteSync, 
        IsDeleted, 
        ExternalApplication' + @EntityIdentifier + 'Id, 
        StampAction, 
        StampDateTime, 
        StampUser
    )
    From TExternalApplication' + @EntityIdentifier + ' a
    Join #TempParties c on a.UserId = c.LicensedUserId and a.PartyId = c.PartyId 
    Where c.Id <= @EndId 
        AND c.Id > @StartId 
        And IsForNewSync = 0 And IsForUpdateSync = 0 And IsDeleted = 0
        And c.LastStampDateTime > a.LastUpdatedDateTime
        And TenantId = @TenantId;
        
    PRINT CONCAT(@@rowcount, '' records updated (for update sync)'');'

    EXEC sp_executesql @Sql
                      ,N'@StampUserId INT, @TenantId INT, @StartId int, @EndId int'
                      ,@StampUserId
                      ,@TenantId
                      ,@StartId
                      ,@EndId;

    ---------------------------------------------------------------------------------------------------
    -- Update new records where they have been updated before they were synced
    SELECT
        @Sql = '
    Update A
    Set LastUpdatedDateTime = GetDate()
    OUTPUT
        deleted.TenantId, 
        deleted.UserId, 
        deleted.PartyId, 
        deleted.CreatedDateTime, 
        deleted.LastUpdatedDateTime, 
        deleted.LastSynchronisedDateTime, 
        deleted.ValueSentToClient, 
        deleted.IsForNewSync,
        deleted.IsForUpdateSync, 
        deleted.IsForDeleteSync, 
        deleted.IsDeleted, 
        deleted.ExternalApplication' + @EntityIdentifier + 'Id, 
        ''U'',
        GETDATE(), 
        @StampUserId
    INTO TExternalApplication' + @EntityIdentifier + 'Audit
    (
        TenantId, 
        UserId, 
        PartyId, 
        CreatedDateTime, 
        LastUpdatedDateTime, 
        LastSynchronisedDateTime, 
        ValueSentToClient, 
        IsForNewSync,
        IsForUpdateSync, 
        IsForDeleteSync, 
        IsDeleted, 
        ExternalApplication' + @EntityIdentifier + 'Id, 
        StampAction, 
        StampDateTime, 
        StampUser
    )
    From TExternalApplication' + @EntityIdentifier + ' a
    Join #TempParties c on a.UserId = c.LicensedUserId and a.PartyId = c.PartyId 
    Where c.Id <= @EndId 
        AND c.Id > @StartId 
        AND IsForNewSync = 1 
        And IsForUpdateSync = 0 
        And IsDeleted = 0
        And c.LastStampDateTime > a.LastUpdatedDateTime
        And a.ValueSentToClient Is Null
        And TenantId = @TenantId;

    PRINT CONCAT(@@rowcount, '' records updated (for new sync)'');'

    EXEC sp_executesql @Sql
                      ,N'@StampUserId INT, @TenantId INT, @StartId int, @EndId int'
                      ,@StampUserId
                      ,@TenantId
                      ,@StartId
                      ,@EndId;

    ---------------------------------------------------------------------------------------------------
    -- delete previous ones

    SELECT
        @Sql = '
    Select ExternalApplication' + @EntityIdentifier + 'Id AS ExternalApplicationClientOrLeadId
    INTO #Ids
    From TExternalApplication' + @EntityIdentifier + ' a
    Join #TempParties c on a.UserId = c.LicensedUserId 
    Where c.Id <= @EndId 
        AND c.Id > @StartId 
        AND IsDeleted = 0 
        AND c.PartyId is null 
        AND TenantId = @TenantId
    UNION ALL
    Select ExternalApplication' + @EntityIdentifier + 'Id AS ExternalApplicationClientOrLeadId
    From TExternalApplication' + @EntityIdentifier + ' a
    Join #TempParties c on a.PartyId = c.PartyId 
    Where c.Id <= @EndId 
        AND c.Id > @StartId 
        AND IsDeleted = 0 
        AND c.LicensedUserId is null 
        AND TenantId = @TenantId

    Update A
    Set IsDeleted = 1, 
        LastUpdatedDateTime = Getdate(), 
        IsForDeleteSync = case when ValueSentToClient is null then 0 else 1 End,
        IsForNewSync = 0, 
        IsForUpdateSync = 0
    OUTPUT
        deleted.TenantId, 
        deleted.UserId, 
        deleted.PartyId, 
        deleted.CreatedDateTime, 
        deleted.LastUpdatedDateTime, 
        deleted.LastSynchronisedDateTime, 
        deleted.ValueSentToClient, 
        deleted.IsForNewSync,
        deleted.IsForUpdateSync, 
        deleted.IsForDeleteSync, 
        deleted.IsDeleted, 
        deleted.ExternalApplication' + @EntityIdentifier + 'Id, 
        ''U'',
        GETDATE(), 
        @StampUserId
    INTO TExternalApplication' + @EntityIdentifier + 'Audit
    (
        TenantId, 
        UserId, 
        PartyId, 
        CreatedDateTime, 
        LastUpdatedDateTime, 
        LastSynchronisedDateTime, 
        ValueSentToClient, 
        IsForNewSync,
        IsForUpdateSync, 
        IsForDeleteSync, 
        IsDeleted, 
        ExternalApplication' + @EntityIdentifier + 'Id, 
        StampAction, 
        StampDateTime, 
        StampUser
    )
    From TExternalApplication' + @EntityIdentifier + ' a
    Join #Ids b on a.ExternalApplication' + @EntityIdentifier + 'Id = b.ExternalApplicationClientOrLeadId 
    Where TenantId = @TenantId;

    PRINT CONCAT(@@rowcount, '' records updated (marked as deleted \ for delete sync)'');'

    EXEC sp_executesql @Sql
                      ,N'@StampUserId INT, @TenantId INT, @StartId int, @EndId int'
                      ,@StampUserId
                      ,@TenantId
                      ,@StartId
                      ,@EndId;

    SET @BatchNumber = @BatchNumber + 1;
    SET @StartId = @EndId;
    SET @EndId = @EndId + @BatchSize;

END

---------------------------------------------------------------------------------------------------
-- delete archived ones
-- I'm not sure what the above sql is up to but I'm too scared to change it, the
-- following statement makes sure that any archived items are marked for deletion.

SELECT
    @Sql = '
Update A
Set IsDeleted = 1, 
    LastUpdatedDateTime = Getdate(), 
    IsForDeleteSync = case when ValueSentToClient is null then 0 else 1 End,
    IsForNewSync = 0, 
    IsForUpdateSync = 0
OUTPUT
    deleted.TenantId, 
    deleted.UserId, 
    deleted.PartyId, 
    deleted.CreatedDateTime, 
    deleted.LastUpdatedDateTime, 
    deleted.LastSynchronisedDateTime, 
    deleted.ValueSentToClient, 
    deleted.IsForNewSync,
    deleted.IsForUpdateSync, 
    deleted.IsForDeleteSync, 
    deleted.IsDeleted, 
    deleted.ExternalApplication' + @EntityIdentifier + 'Id, 
    ''U'',
    GETDATE(), 
    @StampUserId
INTO TExternalApplication' + @EntityIdentifier + 'Audit
(
    TenantId, 
    UserId, 
    PartyId, 
    CreatedDateTime, 
    LastUpdatedDateTime, 
    LastSynchronisedDateTime, 
    ValueSentToClient, 
    IsForNewSync,
    IsForUpdateSync, 
    IsForDeleteSync, 
    IsDeleted, 
    ExternalApplication' + @EntityIdentifier + 'Id, 
    StampAction, 
    StampDateTime, 
    StampUser
)
From 
    TExternalApplication' + @EntityIdentifier + ' A
    Join TCRMContact C ON C.CRMContactId = A.PartyId
WHERE 
    A.TenantId = @TenantId AND C.IndClientId = @TenantId 
    AND A.IsDeleted = 0 AND C.ArchiveFg = 1;
        
PRINT CONCAT(@@rowcount, '' records updated (marked as deleted \ for delete sync)'');'

EXEC sp_executesql @Sql
                    ,N'@StampUserId INT, @TenantId INT'
                    ,@StampUserId
                    ,@TenantId;