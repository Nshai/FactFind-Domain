SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomRetrievePlanCategoryWithPlanType]  
	@IndigoClientId bigint = 0
AS    
SELECT  
	1 AS Tag,  
	NULL AS Parent,  
	T1.PlanCategoryId AS [PlanCategory!1!PlanCategoryId],   
	T1.PlanCategoryName AS [PlanCategory!1!PlanCategoryName],   
	T1.RetireFg AS [PlanCategory!1!RetireFg],   
	T1.IndigoClientId AS [PlanCategory!1!IndigoClientId],   
	T1.ConcurrencyId AS [PlanCategory!1!ConcurrencyId],   
	NULL AS [RefPlanType!2!RefPlanType2ProdSubTypeId],   
	NULL AS [RefPlanType!2!PlanTypeName],   
	NULL AS [RefPlanType!2!WebPage],   
	NULL AS [RefPlanType!2!OrigoRef],   
	NULL AS [RefPlanType!2!QuoteRef],   
	NULL AS [RefPlanType!2!NBRef],   
	NULL AS [RefPlanType!2!RetireFg],   
	NULL AS [RefPlanType!2!RetireDate],   
	NULL AS [RefPlanType!2!FindFg],   
	NULL AS [RefPlanType!2!ConcurrencyId]  
FROM PolicyManagement..TPlanCategory T1  
WHERE @IndigoClientId = 0 OR T1.IndigoClientId = @IndigoClientId  
  
UNION ALL  
  
SELECT  
	2 AS Tag,  
	1 AS Parent,  
	T1.PlanCategoryId,   
	NULL,   
	NULL,   
	NULL,   
	NULL,   
	T4.RefPlanType2ProdSubTypeId,   
	T3.PlanTypeName + ISNULL(' (' + pst.ProdSubTypeName + ')',''),   
	ISNULL(T3.WebPage, ''),   
	ISNULL(T3.OrigoRef, ''),   
	ISNULL(T3.QuoteRef, ''),   
	ISNULL(T3.NBRef, ''),   
	ISNULL(T3.RetireFg, ''),   
	ISNULL(CONVERT(varchar(24), T3.RetireDate, 120),''),   
	ISNULL(T3.FindFg, ''),   
	T3.ConcurrencyId  
FROM PolicyManagement..TRefPlanType T3 
	JOIN  PolicyManagement..TRefPlanType2ProdSubType T4 ON T4.RefPlanTypeId = T3.RefPlanTypeId
	JOIN  PolicyManagement..TRefPlanType2ProdSubTypeCategory T5 ON T5.RefPlanType2ProdSubTypeId = T4.RefPlanType2ProdSubTypeId
	LEFT JOIN TProdSubType pst ON pst.ProdSubTypeId = T4.ProdSubTypeId
	INNER JOIN PolicyManagement..TPlanCategory T1 ON T5.PlanCategoryId = T1.PlanCategoryId  
WHERE 
	@IndigoClientId = 0 OR T1.IndigoClientId = @IndigoClientId  
	AND T3.PlanTypeName != 'Third Party Mortgage'
	AND NOT (T3.PlanTypeName = 'Mortgage' AND T4.IsArchived = 1)
ORDER BY 
	[PlanCategory!1!PlanCategoryId], [RefPlanType!2!PlanTypeName]
FOR XML EXPLICIT  
  
GO
