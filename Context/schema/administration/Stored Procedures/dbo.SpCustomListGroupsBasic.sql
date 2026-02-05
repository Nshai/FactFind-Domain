SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomListGroupsBasic]        
 @IndigoClientId bigint,    
@UserId bigint      
AS        
        
declare @UserGroupId bigint    
declare @SuperUser bigint    
    
SELECT @UserGroupId = GroupId, @SuperUser = (SuperUser|SuperViewer) FROM TUser WHERE UserId = @UserId    
        
Select [Group].GroupId , [Group].Identifier,  
case 
	when @SuperUser = 0 and [Group].GroupId = @UserGroupId then 0 --force this to be the top of the hierarchy
	else ISNULL([Group].ParentId, 0)
end as ParentId
From dbo.TGroup As [Group]    
LEFT JOIN TGroup g2 ON [Group].ParentId = g2.GroupId        
LEFT JOIN TGroup g3 ON g2.ParentId = g3.GroupId    
LEFT JOIN TGroup g4 ON g3.ParentId = g4.GroupId    
LEFT JOIN TGroup g5 ON g4.ParentId = g5.GroupId    
Where [Group].IndigoClientId = @IndigoClientId        
AND (@SuperUser = 1 OR ([Group].GroupId = @UserGroupId OR g2.GroupId = @UserGroupId OR g3.GroupId = @UserGroupId OR g4.GroupId = @UserGroupId OR g5.GroupId = @UserGroupId))    
Order By Identifier        
For Xml Auto     
GO
