USE CRM
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue        Description
----        ---------       -------      -------------
20200423    Nick Fairway    IP-65551     Performance issue.
20250129  Soumya Satheesan  CRMPM-16481  Add new link hyperlink New Assinged Task in My Task Widget

*/
CREATE PROCEDURE dbo.SpCustomDashboardRetrieveMyTasks
	@UserId int,
	@CurrentUserDateTime datetime,
	@TenantId int
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON	
  
declare @AllOpenTasks table (DueDate DATE, AssignedToUserId INT, UpdatedByUserId INT) 
declare @Tasks table (Type varchar(255), NumberOfTasks int)  
  
INSERT INTO @AllOpenTasks  
 SELECT t.DueDate, t.AssignedToUserId, ta.UpdatedByUserId 
 FROM crm..TTask t WITH(NOLOCK)  
 LEFT JOIN TCRMContact c WITH(NOLOCK) ON c.CRMContactId = t.CRMContactId
 LEFT JOIN TOrganiserActivity ta WITH(NOLOCK) ON t.TaskId = ta.TaskId
 WHERE T.IndigoClientId = @TenantId
 AND AssignedToUserId = @UserID
 AND isnull(RefTaskStatusId,0) <> 2 --complete  
 AND ISNULL(C.IsDeleted, 0) = 0
 AND ISNULL(C.IsDeleted, 0) = 0
 
INSERT INTO @Tasks  
SELECT 'New Assigned Tasks', COUNT(1)   
FROM @AllOpenTasks
WHERE UpdatedByUserId IS NULL OR AssignedToUserId <> UpdatedByUserId 
INSERT INTO @Tasks  
SELECT 'Overdue', COUNT(1)   
FROM @AllOpenTasks   
WHERE DueDate < dateadd(ms, -3, datediff(d,0,@CurrentUserDateTime))  
INSERT INTO @Tasks  
SELECT 'Due Today', COUNT(1)   
FROM @AllOpenTasks   
WHERE  convert(varchar(10),DueDate,103) = convert(varchar(10),@CurrentUserDateTime,103)  


INSERT INTO @Tasks  
SELECT 'Due From Tomorrow', COUNT(1)   
FROM @AllOpenTasks   
WHERE   DueDate >= dateadd(day,1, convert(varchar(12),@CurrentUserDateTime,106))  

INSERT INTO @Tasks  
SELECT 'All Open', COUNT(1)   
FROM @AllOpenTasks   

SELECT * FROM @Tasks    
GO
