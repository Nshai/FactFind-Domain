SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date    Modifier        Issue       Description
----    ---------       -------     -------------
20211020 Nick Fairway   SDA-77      Performance improvement with reduced indices
*/
CREATE PROCEDURE dbo.SpCustomDashboardRetrieveClientActivities
	@UserId int,    
	@cid int,
	@CurrentUserDateTime datetime,
	@TenantId int
AS 
DECLARE @Overdue bigint, @DueToday bigint, @NextSevenDays bigint , @DueFromTomorrow bigint,
        @CurrentUserDate date = @CurrentUserDateTime, @Tomorrow date = dateadd(day,1, @CurrentUserDateTime)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED -- speed over accuracty
-----------------------------------
-- Overdue tasks
-----------------------------------    
SET @Overdue = (    
	SELECT COUNT(1)     
	FROM TTask t    
	WHERE T.Indigoclientid = @TenantId and
	CRMContactId = @cid AND
	ISNULL(RefTaskStatusId,0) != 2
	AND DueDate < DATEADD(ms, -3, DATEDIFF(d,0,@CurrentUserDateTime))  
) 

-- where client is joint..
SET @Overdue = @Overdue + (    
	SELECT COUNT(1)     
	FROM 
		dbo.TTask t  
		LEFT JOIN dbo.TCRMContact c  ON t.CRMContactId = c.CRMContactId 
		JOIN dbo.TOrganiserActivity a ON a.TaskId = t.TaskId  
	WHERE T.Indigoclientid = @TenantId
	AND
		a.IndigoClientId = @TenantId
	AND
		a.JointCRMContactId = @cid AND ISNULL(t.RefTaskStatusId,0) != 2
	AND t.DueDate < DATEADD(ms, -3, DATEDIFF(d,0,@CurrentUserDateTime))
	AND ISNULL(c.IsDeleted, 0) = 0  
) 

-----------------------------------
-- Due today
-----------------------------------      
SET @DueToday = (    
	SELECT COUNT(1)     
	FROM TTask t    
	WHERE T.Indigoclientid = @TenantId
	AND	CRMContactId = @cid    
    AND ISNULL(RefTaskStatusId,0) <> 2 --complete
    AND t.DueDate >=@CurrentUserDate AND t.DueDate < @Tomorrow -- i.e. = date part of @CurrentUserDateTime
)    

-- where client is joint..
SET @DueToday = @DueToday + (    
	SELECT COUNT(1)     
	FROM 
		dbo.TTask t 
	LEFT JOIN dbo.TCRMContact c ON t.CRMContactId = c.CRMContactId 
	JOIN dbo.TOrganiserActivity a ON a.TaskId = t.TaskId  
	WHERE 
		T.Indigoclientid = @TenantId
	AND a.IndigoClientId = @TenantId
	AND a.JointCRMContactId = @cid    
	AND ISNULL(t.RefTaskStatusId,0) <> 2 --complete    
	AND t.DueDate >=@CurrentUserDate AND t.DueDate < @Tomorrow -- i.e. = date part of @CurrentUserDateTime
	AND ISNULL(c.IsDeleted, 0) = 0    
)    
    
-----------------------------------
-- Due in the next 7 days
-----------------------------------            
SET @NextSevenDays = (    
	SELECT COUNT(1)     
	FROM TTask t    
	WHERE T.Indigoclientid = @TenantId and
		CRMContactId = @cid    
		AND ISNULL(RefTaskStatusId, 0) != 2 --complete    
		AND DueDate BETWEEN @CurrentUserDateTime AND dateadd(day,7, @CurrentUserDateTime)    
)
  
SET @NextSevenDays = @NextSevenDays + (    
	SELECT COUNT(1)     
	FROM 
		TTask t
		LEFT JOIN TCRMContact c ON t.CRMContactId = c.CRMContactId  
		JOIN TOrganiserActivity a ON a.TaskId = t.TaskId  
	WHERE T.Indigoclientid = @TenantId and
		a.JointCRMContactId = @cid    
		AND ISNULL(RefTaskStatusId, 0) != 2 --complete    
		AND DueDate BETWEEN @CurrentUserDateTime AND dateadd(day,7, @CurrentUserDateTime) 
		AND ISNULL(c.IsDeleted, 0) = 0   
)
    
-----------------------------------
-- Due from tomorrow
-----------------------------------        
SET @DueFromTomorrow = (    
	SELECT COUNT(TaskId)     
	FROM TTask t    
	WHERE T.Indigoclientid = @TenantId and
		CRMContactId = @cid    
		AND isnull(RefTaskStatusId,0) <> 2 --complete    
		AND DueDate >= @Tomorrow 
)      
  
SET @DueFromTomorrow = @DueFromTomorrow + (    
	SELECT COUNT(1)     
	FROM 
		TTask t
		LEFT JOIN TCRMContact c ON t.CRMContactId = c.CRMContactId  
		JOIN TOrganiserActivity a ON a.TaskId = t.TaskId  
	WHERE a.Indigoclientid = @TenantId and
		t.Indigoclientid = @TenantId and
		a.JointCRMContactId = @cid
		AND isnull(RefTaskStatusId,0) <> 2 --complete    
		AND DueDate >= @Tomorrow
		AND ISNULL(c.IsDeleted, 0) = 0    
)      
    
-----------------------------------
-- Return all data for dashboard
-----------------------------------           
SELECT 
	@OverDue as TotalOverdue, 
	@DueToday as TotalDueToday, 
	@NextSevenDays as TotalNextSevenDays, 
	@DueFromTomorrow as DueFromTomorrow,    
	@cid as CrmContactId
GO