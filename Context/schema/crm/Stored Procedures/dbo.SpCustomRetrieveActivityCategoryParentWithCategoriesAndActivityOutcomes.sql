SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveActivityCategoryParentWithCategoriesAndActivityOutcomes]    
 @IndigoClientId bigint,    
 @ActivityEvent VARCHAR(10) = NULL    
AS    
    
-- Change sort order    
    
BEGIN    
  SELECT    
     1 AS Tag,    
     NULL AS Parent,    
     T1.ActivityCategoryParentId AS [ActivityCategoryParent!1!ActivityCategoryParentId],     
     T1.Name AS [ActivityCategoryParent!1!Name],     
     T1.IndigoClientId AS [ActivityCategoryParent!1!IndigoClientId],     
     T1.ConcurrencyId AS [ActivityCategoryParent!1!ConcurrencyId],     
     NULL AS [ActivityCategory!2!ActivityCategoryId],     
     NULL AS [ActivityCategory!2!Name],     
     NULL AS [ActivityCategory!2!ActivityCategoryParentId],     
     NULL AS [ActivityCategory!2!LifeCycleTransitionId],     
     NULL AS [ActivityCategory!2!IndigoClientId],     
     NULL AS [ActivityCategory!2!ClientRelatedFG],     
     NULL AS [ActivityCategory!2!PlanRelatedFG],     
     NULL AS [ActivityCategory!2!FeeRelatedFG],     
     NULL AS [ActivityCategory!2!RetainerRelatedFG],     
     NULL AS [ActivityCategory!2!OpportunityRelatedFG],     
     NULL AS [ActivityCategory!2!AdviserRelatedFg], 
     NULL AS [ActivityCategory!2!ActivityEvent],     
     NULL AS [ActivityCategory!2!TemplateTypeId],  
     NULL AS [ActivityCategory!2!TemplateId],  
     NULL AS [ActivityCategory!2!ConcurrencyId],    
   NULL AS [ActivityOutcome!3!ActivityOutcomeId],    
   NULL AS [ActivityOutcome!3!ActivityOutcomeName]    
  FROM TActivityCategoryParent T1     
  JOIN      
-- Only return ActivityCategoryParents which have ActivityCategories for passed event type (task or diary.)    
 (SELECT DISTINCT TAC.ActivityCategoryParentId FROM  TActivityCategory TAC     
 WHERE TAC.ActivityEvent  = @ActivityEvent OR @ActivityEvent IS NULL AND TAC.GroupId IS NULL) AS ActCat    
 ON T1.ActivityCategoryParentId = ActCat.ActivityCategoryParentId    
    
  WHERE (T1.IndigoClientId = @IndigoClientId)    
    
  UNION ALL    
    
  SELECT    
     2 AS Tag,    
     1 AS Parent,    
     T1.ActivityCategoryParentId,     
     T1.Name,     
     T1.IndigoClientId,     
     T1.ConcurrencyId,     
     T2.ActivityCategoryId,     
     T2.Name,     
     ISNULL(T2.ActivityCategoryParentId, ''),     
     ISNULL(T2.LifeCycleTransitionId, ''),     
     T2.IndigoClientId,     
     T2.ClientRelatedFG,     
     T2.PlanRelatedFG,     
     T2.FeeRelatedFG,     
     T2.RetainerRelatedFG,     
     T2.OpportunityRelatedFG,  
     T2.AdviserRelatedFg,  
     ISNULL(T2.ActivityEvent, ''),     
     T2.TemplateTypeId,  
     T2.TemplateId,  
     T2.ConcurrencyId,    
   NULL,    
   NULL    
  FROM TActivityCategory T2    
  INNER JOIN TActivityCategoryParent T1    
  ON T2.ActivityCategoryParentId = T1.ActivityCategoryParentId    
    
  WHERE (T1.IndigoClientId = @IndigoClientId) AND (T2.ActivityEvent  = @ActivityEvent OR @ActivityEvent IS NULL) AND T2.GroupId IS NULL    
    
  UNION ALL    
    
  SELECT    
     3 AS Tag,    
     2 AS Parent,    
     T1.ActivityCategoryParentId,     
     T1.Name,     
     T1.IndigoClientId,     
     T1.ConcurrencyId,     
     T2.ActivityCategoryId,     
     T2.Name,     
     ISNULL(T2.ActivityCategoryParentId, ''),     
     ISNULL(T2.LifeCycleTransitionId, ''),     
     T2.IndigoClientId,     
     T2.ClientRelatedFG,     
     T2.PlanRelatedFG,     
     T2.FeeRelatedFG,     
     T2.RetainerRelatedFG,     
     T2.OpportunityRelatedFG, 
     T2.AdviserRelatedFg,    
     ISNULL(T2.ActivityEvent, ''),     
     T2.TemplateTypeId,  
     T2.TemplateId,  
     T2.ConcurrencyId,    
   T4.ActivityOutcomeId,    
   T4.ActivityOutcomeName    
 FROM TActivityOutcome T4    
 JOIN TActivityCategory2ActivityOutcome T3    
 ON T4.ActivityOutcomeId = T3.ActivityOutcomeId AND T4.ArchiveFG = 0    
 JOIN TActivityCategory T2    
 ON T2.ActivityCategoryId = T3.ActivityCategoryId    
  INNER JOIN TActivityCategoryParent T1    
  ON T2.ActivityCategoryParentId = T1.ActivityCategoryParentId    
     
  WHERE (T1.IndigoClientId = @IndigoClientId) AND (T2.ActivityEvent  = @ActivityEvent OR @ActivityEvent IS NULL) AND T2.GroupId IS NULL
  AND T4.GroupId IS NULL   
    
  ORDER BY [ActivityCategoryParent!1!ActivityCategoryParentId], [ActivityCategory!2!Name], [ActivityOutcome!3!ActivityOutcomeId]    
    
  FOR XML EXPLICIT    
    
END    
RETURN (0)
GO
