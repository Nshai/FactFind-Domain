USE CRM
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Modification History
Date        Modifier        Issue       Description
----        ---------       -------     -------------
20200127    Nick Fairway    IP-65509    Performance improvement.
20210611    Nick Fairway    SDA-126     Performance improvement.
20210613    KK				SDA-126     Add TenantId Parameter to improve the performance.
*/
CREATE PROCEDURE dbo.SpCustomDashboardRetrieveGroupTasks
@UserId     bigint,
@GroupId    bigint  = 0,
@CurrentUserDateTime datetime,
@TenantId	int
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @today              datetime    = null --'20191104' -- debug for dev only to mimic a particular day rather than using getdate()
DECLARE @Overdue            bigint,  
        @DueToday           bigint,  
        @DueFROMTomorrow    bigint  


-- Create DDL up front to reduce recompiles
CREATE TABLE #work0 (
    UserId              BIGINT
,   IndigoClientId      INT
)

CREATE TABLE #work1  (
    OverDue             CHAR(7)
,   DueToday            CHAR(8)
,   DueFROMTommorow     CHAR(15)
,   taskcount           INT
)

IF @today IS NULL SET @today = @CurrentUserDateTime

-- Basic security check  
IF NOT EXISTS
(  
	SELECT 1  
	FROM administration..TUser u  
	JOIN administration..TGroup g on g.IndigoClientId = u.IndigoClientId  
	WHERE u.UserId = @UserId AND g.GroupId = @GroupId  
)   
RETURN ;

-- Slightly faster than fnGetChildGroupsForGroup but should give same results as administration..fnGetChildGroupsForGroup(@GroupId,0)
WITH GroupTree AS (
	SELECT g.GroupId, g.IndigoClientId, g.ParentId, Level = 0
	FROM administration..TGroup        g
	WHERE g.GroupId = @GroupId

	UNION ALL

	SELECT g.GroupId, g.IndigoClientId, g.ParentId, Level = t.Level + 1
	FROM		administration..TGroup      g
	INNER JOIN	GroupTree					t
	ON g.ParentId = t.GroupId
 )
 
INSERT #work0   
SELECT  u.UserId, t.IndigoClientId 
FROM GroupTree t
JOIN administration..TUser u on t.GroupId = u.GroupId 
WHERE Level < 5

INSERT #work1
SELECT 
CASE WHEN T.DueDate< dateadd(ms, -3, datediff(d,0,@today))  
            THEN 'OverDue' ELSE NULL END                                    AS OverDue, 
CASE WHEN t.DueDate >= dateadd(ms, 0, datediff(d,0,@today)) AND DueDate <= dateadd(ms, -3, datediff(d,-1,@today))  
            THEN 'DueToday' ELSE NULL END                                   AS DueToday,
CASE WHEN t.DueDate >= dateadd(ms, 0, datediff(d,-1,@today)) THEN 'DueFROMTommorow' ELSE NULL END AS DueFROMTommorow,
COUNT(1)                                                                    AS taskcount
FROM    dbo.TTask t  
INNER JOIN  #work0      u  ON t.IndigoClientId = u.IndigoClientId and t.AssignedToUserId = u.UserId
INNER JOIN   TCRMContact c ON C.CRMContactId = t.CRMContactId  AND c.IndClientId = u.IndigoClientId -- was left join with this in where So make inner join NF
WHERE
t.IndigoClientId = @TenantId
AND ISNULL(RefTASkStatusId,0) != 2
AND     ISNULL(c.ArchiveFg, 0) = 0
GROUP BY        
CASE WHEN T.DueDate< dateadd(ms, -3, datediff(d,0,@today))                                                          THEN 'OverDue' ELSE NULL END, 
CASE WHEN t.DueDate >= dateadd(ms, 0, datediff(d,0,@today)) AND DueDate <= dateadd(ms, -3, datediff(d,-1,@today))   THEN 'DueToday' ELSE NULL END,
CASE WHEN t.DueDate >= dateadd(ms, 0, datediff(d,-1,@today)) THEN 'DueFROMTommorow'                                 ELSE NULL END

SELECT @DueFROMTomorrow = taskcount FROM #work1 WHERE DueFROMTommorow   = 'DueFROMTommorow'
SELECT @OverDue         = taskcount FROM #work1 WHERE OverDue           = 'OverDue'
SELECT @DueToday        = taskcount FROM #work1 WHERE DueToday          = 'DueToday'

SELECT 
    @OverDue            AS TotalOverdue
,   @DueToday           AS TotalDueToday
,   @DueFROMTomorrow    AS TotalDueFROMTomorrow
  
GO
