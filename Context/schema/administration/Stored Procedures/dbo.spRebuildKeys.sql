/*
Created by Nick Fairway on 12 July 2023
Based on App_RebuildKeys which took approx 6 hours to run. Performance improvement - probably <10 mins to run
which called SpCustomRebuildAllKeys -> SpCustomApplyPolicy ->SpCustomApplyPolicyGetKeys

Runs in batches of a range of users
*/
CREATE PROCEDURE dbo.spRebuildKeys 
    @IndigoClientId int = NULL -- NULL for all
,   @StartAtUserid int=0 -- if you want to continue from a partial run
,   @EndAtUserid int= 9999999
,   @Batchsize int = 1000000 -- this is a measure of the size of the batch for all entities
,   @Debug tinyint = 1 -- level of logging 0 - none; 1 - just batch counts; 2 - statement stats; 3 - 2+dynamic SQL 
AS
SET NOCOUNT ON;

DECLARE @now datetime = getdate(), @BatchNow datetime =getdate(), @duration  int, @RoleId int,  @FromUserId int=0, @ToUserId int =0
, @RunningSum int = @Batchsize, @Rows bigint, @BatchRows int=0, @TotalRows bigint=0, @TranDuration int
DECLARE @SQL_Insert nvarchar(max)='', @SQL_Delete  nvarchar(max)='';

DROP TABLE IF EXISTS #CustomApplyPolicyKeys, #CustomApplyPolicyKeys_DELETE, #CustomApplyPolicyKeys_INSERT, #Users

CREATE TABLE #CustomApplyPolicyKeys (
CreatorId	INT, 
UserId	INT,
RightMask	INT,
AdvancedMask	INT,
RoleId	INT,
EntityId	INT,
PolicyId	INT,
IndigoClientId int)

CREATE UNIQUE CLUSTERED INDEX CIX_#CustomApplyPolicyKeys ON #CustomApplyPolicyKeys (EntityId, UserId, CreatorId, RightMask, AdvancedMask, RoleId, PolicyId);

CREATE TABLE #Users (
    id          int NOT NULL IDENTITY
,   UserId      int NOT NULL
,   ct          int NOT NULL
,   RunningSum  int NOT NULL
);

UPDATE  r 
SET RebuildKeys = 0
FROM TRunning r
JOIN TIndigoClient c on r.IndigoClientId = c.IndigoClientId
WHERE c.status ='active' AND 
r.IndigoClientId = isnull(@IndigoClientId,c.IndigoClientId);

WITH Tables as ( 
    SELECT [Table] = E.Db + '..T' + E.Identifier, E.EntityId 
    FROM TEntity E
)
SELECT @SQL_Insert = @SQL_Insert + N'
INSERT ' + T.[Table] + 'Key (CreatorId, UserId, RoleId, RightMask, AdvancedMask, ConcurrencyId)
SELECT i.CreatorId, i.UserId, i.RoleId, i.RightMask, i.AdvancedMask, 1
FROM #CustomApplyPolicyKeys i
LEFT JOIN ' + T.[Table] + 'Key x ON x.UserId=i.UserId AND x.CreatorId=i.CreatorId
AND x.RightMask=i.RightMask  AND x.AdvancedMask=i.AdvancedMask AND i.roleid = x.roleid
AND x.Userid BETWEEN @FromUserid and @ToUserid
WHERE x.Roleid is null
AND i.EntityId=' + cast(T.EntityId as varchar(3)) 
+ IIF(@IndigoClientId IS NOT NULL, ' AND IndigoClientId=' + CAST(@IndigoClientId AS VARCHAR(10)), '') + '
AND i.Userid BETWEEN @FromUserid and @ToUserid;

SELECT @Rows = @@rowcount, @Duration = datediff(s, @now, getdate()), @now=getdate() 
SET @BatchRows +=@Rows
'
+ IIF (@Debug > 1, 'RAISERROR  (''UserId %d to %d: INSERT ' + T.[Table] 
+ 'Key. %d rows in %ds'',0,0, @FromUserid, @ToUserId, @Rows, @Duration) WITH NOWAIT', '') + '
'
FROM Tables T;

SET @SQL_Insert = 'DECLARE @rows int, @Duration int, @now datetime = getdate() ' + @SQL_Insert
IF @Debug >2
    print @SQL_Insert

SET @SQL_Delete = '';

WITH Tables as ( 
    SELECT [Table] = E.Db + '..T' + E.Identifier, E.EntityId, PKid = E.Identifier + 'KeyId' 
    FROM Administration..TEntity E
)
SELECT @SQL_Delete = @SQL_Delete + N'
DELETE i
FROM ' + T.[Table] + 'Key i
LEFT JOIN #CustomApplyPolicyKeys x ON x.UserId=i.UserId AND x.CreatorId=i.CreatorId
AND x.RightMask=i.RightMask  AND x.AdvancedMask=i.AdvancedMask AND i.roleid = x.roleid 
AND x.Userid BETWEEN @FromUserid and @ToUserid
AND x.EntityId=' + cast(T.EntityId as varchar(3)) 
+ IIF(@IndigoClientId IS NOT NULL, ' AND x.IndigoClientId=' + CAST(@IndigoClientId AS VARCHAR(10)), '')
+ ' 
JOIN Administration..TPolicy p ON i.RoleId = p.RoleId AND p.Applied=''Yes''' -- only delete those that are applied
+ IIF(@IndigoClientId IS NOT NULL, 'AND p.IndigoClientId=' + CAST(@IndigoClientId AS VARCHAR(10))
, '') + ' AND p.EntityId=' + cast(T.EntityId as varchar(3)) + ' 
JOIN Administration..TRunning n ON n.IndigoClientId = p.IndigoClientId and RebuildKeys = 0
JOIN Administration..TIndigoClient T ON T.IndigoClientId = p.IndigoClientId AND T.status =''active''
WHERE x.Roleid is null
AND i.Userid BETWEEN @FromUserid and @ToUserid
AND i.CreatorId IS NOT NULL; -- EnitityIds for Creatorid = null rows relate to ' + T.[Table] +' etc.  

SELECT @Rowsaffected = @@rowcount, @Duration = datediff(s, @now, getdate()), @now=getdate()
SET @BatchRows +=@Rowsaffected
'
+ IIF (@Debug > 1, ' RAISERROR  (''UserId %d to %d: DELETE ' + T.[Table] 
+ 'Key. %d rows in %ds'',0,0, @FromUserid, @ToUserId, @Rowsaffected, @Duration) WITH NOWAIT', '')+ '
'
FROM Tables T

SET @SQL_Delete = 'DECLARE @Rowsaffected int, @Duration int, @now datetime = getdate() ' + @SQL_Delete

IF @Debug >2
    print @SQL_Delete

IF @IndigoClientId IS NULL
    INSERT INTO #Users (UserId, ct, RunningSum)
    SELECT p.UserId
    , ct= sum(ct), RunningSum = sum(sum(ct)) OVER (ORDER BY p.UserId)
    FROM dbo.vwPolicyUsers p
    WHERE p.UserId BETWEEN @StartAtUserid AND @EndAtUserid
    GROUP BY UserId
    ORDER BY p.UserId

ELSE

    INSERT INTO #Users (UserId, ct, RunningSum)
    SELECT p.UserId
    , ct= sum(ct), RunningSum = sum(sum(ct)) OVER (ORDER BY p.UserId)
    FROM dbo.vwPolicyUsers p
    WHERE p.UserId BETWEEN @StartAtUserid AND @EndAtUserid
    AND IndigoClientId=@IndigoClientId
    GROUP BY UserId
    ORDER BY p.UserId

SELECT @Rows = @@rowcount, @Duration = datediff(s, @now, getdate()), @now=getdate()
IF @Debug > 0 RAISERROR  ('Populate #Users, %I64d rows from vwPolicyUsers  in %ds',0,0,  @Rows, @Duration) WITH NOWAIT

CREATE UNIQUE CLUSTERED INDEX CIX_#Users ON #Users (Userid, RunningSum);

SELECT @FromUserId=min(Userid) FROM #Users;
SELECT @ToUserId = max(UserId)  FROM #Users WHERE RunningSum<@RunningSum and UserId >= @FromUserId;

WHILE @ToUserId IS NOT NULL 
BEGIN   
    TRUNCATE TABLE #CustomApplyPolicyKeys; -- just store the data for this user range
    
    IF @IndigoClientId IS NULL
        INSERT #CustomApplyPolicyKeys (CreatorId, UserId, RightMask, AdvancedMask, RoleId, EntityId, PolicyId, IndigoClientId)
        SELECT CreatorId, pk.UserId, RightMask, AdvancedMask, RoleId, EntityId, PolicyId, pk.IndigoClientId
        FROM Administration..vwCustomApplyPolicyGetKeysAll pk
        WHERE pk.UserId BETWEEN @FromUserid and @ToUserid
    ELSE
        INSERT #CustomApplyPolicyKeys (CreatorId, UserId, RightMask, AdvancedMask, RoleId, EntityId, PolicyId, IndigoClientId)
        SELECT CreatorId, pk.UserId, RightMask, AdvancedMask, RoleId, EntityId, PolicyId, pk.IndigoClientId
        FROM Administration..vwCustomApplyPolicyGetKeysAll pk
        WHERE pk.UserId BETWEEN @FromUserid and @ToUserid
        AND pk.IndigoClientId = @IndigoClientId

    SELECT @Rows = @@rowcount, @Duration = datediff(s, @now, getdate()), @now=getdate()
    IF @Debug > 1 RAISERROR  ('UserId %d to %d: INSERT #CustomApplyPolicyKeys from vwCustomApplyPolicyGetKeysAll %I64d in %ds',0,0, @FromUserid, @ToUserId, @Rows, @Duration) WITH NOWAIT;

    BEGIN TRANSACTION
    EXEC dbo.sp_executesql @SQL_Insert, N'@FromUserid int, @ToUserid int, @BatchRows int OUTPUT', @FromUserid, @ToUserid, @BatchRows OUTPUT;
    EXEC dbo.sp_executesql @SQL_Delete, N'@FromUserid int, @ToUserId int, @BatchRows int OUTPUT', @FromUserid, @ToUserId, @BatchRows OUTPUT;
    COMMIT

    SELECT @totalRows+=@BatchRows, @Duration = datediff(s, @BatchNow, getdate()), @TranDuration= datediff(s, @now, getdate()); --,@SQL_Insert='', @SQL_Delete='';
    IF @Debug > 0 RAISERROR  ('Processed Users %d to %d in %ds, Transaction duration = %ds. @RunningSum=%d, @BatchRows=%d, @totalRows=%I64d',0,0
        , @FromUserid, @ToUserId, @Duration, @TranDuration, @RunningSum, @BatchRows, @totalRows) WITH NOWAIT
    DELETE #Users WHERE Userid BETWEEN @FromUserid and @ToUserid;
    SELECT @FromUserId=@ToUserId+1, @ToUserId= NULL
    SELECT @RunningSum +=@Batchsize, @BatchNow = getdate(), @now=getdate(), @BatchRows=0;
    SELECT @ToUserId = max(UserId)  FROM #Users WHERE RunningSum<@RunningSum and UserId >= @FromUserId
END

GO