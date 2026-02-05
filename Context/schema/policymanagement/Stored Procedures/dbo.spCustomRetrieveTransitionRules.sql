SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Procedure [dbo].[spCustomRetrieveTransitionRules]  
 @TenantId bigint  
AS   
   
SELECT 1 AS Tag,  
 Null AS parent,   
 LifeCycleTransitionRuleId AS [Rule!1!LifeCycleTransitionRuleId],  
 SpName AS [Rule!1!SpName],  
 Name AS [Rule!1!Name],  
 Code AS [Rule!1!Code],  
 [Description] AS [Rule!1!HelpText],  
 CASE WHEN TenantId IS NULL   
  THEN 0  
  ELSE 1  
 END  AS [Rule!1!IsTenantSpecificRule],
 RefLifecycleRuleCategoryId as [Rule!1!RefLifecycleRuleCategoryId]
   
 FROM TLifeCycleTransitionRule  
 WHERE (TenantId IS NULL) OR (TenantId = @TenantId)  
    
  ORDER BY [Rule!1!Name]  
    
 FOR XML EXPLICIT  
GO
