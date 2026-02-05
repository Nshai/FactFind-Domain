SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spCustomCreateActivityForNewTenant] @NewTenantId BIGINT ,@SourceIndigoClientId BIGINT
AS

BEGIN


Insert into CRM..TActivityCategoryParent (Name, IndigoClientId, ConcurrencyId)        
select DISTINCT a.Name, @NewTenantId, 1 from CRM..TActivityCategoryParent A        
Inner Join crm..tactivitycategory b on a.activitycategoryparentid=b.activitycategoryparentid        
where a.indigoclientid=@SourceIndigoClientId and b.ActivityEvent='Task'        

-- RUI 28/06/2019: IP-55689 - Add ActivityCategoryParent without ActivityCategory
Insert into CRM..TActivityCategoryParent (Name, IndigoClientId, ConcurrencyId)
select DISTINCT a.Name, @NewTenantId, 1 -- RUI 28/06/2019: IP-55689 - set ConcurrencyId to 1
from CRM..TActivityCategoryParent a
left Join crm..TActivityCategory b on b.activitycategoryparentid=a.activitycategoryparentid and b.indigoclientid = a.indigoclientid
where a.indigoclientid=@SourceIndigoClientId 
and b.activitycategoryparentid is null



-- now lets associate all of the activity categories to their parents        
        
DECLARE @ActivityCategoryParentId bigint, @ActivityCategoryParentIdentifier varchar(255)        
        
-- lets copy task configuration        
DECLARE activitycategory_cursor CURSOR        
FOR SELECT ActivityCategoryParentId, Name FROM CRM..TActivityCategoryParent        
 where indigoclientid=@NewTenantId        
 OPEN activitycategory_cursor        
        
 FETCH NEXT FROM activitycategory_cursor Into @ActivityCategoryParentId, @ActivityCategoryParentIdentifier         
        
 WHILE @@FETCH_STATUS = 0        
 BEGIN        
  Insert Into CRM..TActivityCategory (Name,ActivityCategoryParentId,LifeCycleTransitionId,IndigoClientId,ClientRelatedFG,        
   PlanRelatedFG,FeeRelatedFG,RetainerRelatedFG,OpportunityRelatedFG,AdviserRelatedFg,ActivityEvent,RefSystemEventId,ConcurrencyId, [Description]) -- RUI 28/06/2019: IP-55689 - Added Description
  Select A.Name,@ActivityCategoryParentId,LifeCycleTransitionId,@NewTenantID,ClientRelatedFG,        
   PlanRelatedFG,FeeRelatedFG,RetainerRelatedFG,OpportunityRelatedFG,AdviserRelatedFg,ActivityEvent,RefSystemEventId, 1, [Description] -- RUI 28/06/2019: IP-55689 - Added Description
  from CRM..TActivityCategory A        
  Inner join CRM..TActivityCategoryParent B on A.ActivityCategoryParentId=B.ActivityCategoryParentId        
  where B.Name=@ActivityCategoryParentIdentifier and B.IndigoClientId=@SourceIndigoClientId        
        
  FETCH NEXT FROM activitycategory_cursor Into @ActivityCategoryParentId, @ActivityCategoryParentIdentifier         
    END        
         
         
CLOSE activitycategory_cursor        
DEALLOCATE activitycategory_cursor        


END

GO
