SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAtrQuestionDefinition]  
	@AtrTemplateGuid uniqueidentifier,  -- this is the active template guid (NOT the base template though)
	@TenantGuid uniqueidentifier  
AS
DECLARE @BaseTemplate uniqueidentifier, @TemplateToUse uniqueidentifier

-- Does the template have a base definition?
SELECT @BaseTemplate = BaseAtrTemplate 
FROM TAtrTemplateCombined 
WHERE [Guid] = @AtrTemplateGuid

-- Use the base template to retrieve the questions (if base is available)
SELECT @TemplateToUse = ISNULL(@BaseTemplate, @AtrTemplateGuid)

-- Get full list of questions for the active template
DECLARE @Questions TABLE (AtrQuestionGuid uniqueidentifier, AtrTemplateGuid uniqueidentifier, AtrQuestionSyncId varchar(50))
-- Insert
INSERT @Questions (AtrQuestionGuid, AtrTemplateGuid, AtrQuestionSyncId)
SELECT aqc.[Guid], aqc.AtrTemplateGuid, aq.AtrQuestionSyncId
FROM TAtrQuestionCombined aqc
INNER JOIN TAtrQuestion aq ON aq.AtrQuestionId = aqc.AtrQuestionId
WHERE aqc.AtrTemplateGuid = @TemplateToUse AND aqc.Active=1

-- Retrieve list of questions and their associated categories.  
SELECT DISTINCT 
	c.[AtrQuestionId],c.[Guid], c.[Description], c.Ordinal, c.Investment, c.Retirement, cc.AtrCategoryId,
	rg.RiskGroupingId, rg.Tolerance, AtrQuestionSyncId
FROM 
	@Questions q 
	JOIN TATRCategoryQuestion a on a.AtrQuestionGuid = q.AtrQuestionGuid 
	JOIN TAtrCategoryCombined cc on a.AtrCategoryGuid = cc.[Guid]
	JOIN TAtrQuestionCombined c on q.AtrQuestionGuid = c.[Guid]
	LEFT JOIN TAtrQuestionRiskGrouping qrg on qrg.AtrQuestionGuid = q.AtrQuestionGuid and qrg.AtrTemplateGuid = @AtrTemplateGuid
	LEFT JOIN TRiskGrouping rg on rg.RiskGroupingId = qrg.RiskGroupingId
WHERE  
	a.AtrTemplateGuid = @AtrTemplateGuid       
	AND cc.TenantGuid = @TenantGuid
ORDER BY  
	cc.AtrCategoryId, Ordinal  

-- Retrieve list of answers
SELECT DISTINCT
	aco.[Guid],  
	aco.AtrAnswerId,  
	aco.[Description],  
	ac.Ordinal,  
	ac.Weighting,  
	aco.AtrQuestionGuid,
	cc.AtrCategoryId,
	aa.AtrAnswerSyncId
FROM
	@Questions q 
	JOIN TATRCategoryQuestion cq on cq.AtrQuestionGuid = q.AtrQuestionGuid 
	JOIN TATRCategoryCombined cc  on cq.AtrCategoryGuid = cc.[Guid]
	JOIN TATRAnswerCategory ac on cq.AtrCategoryQuestionId=ac.AtrCategoryQuestionId
	JOIN TAtrAnswerCombined aco on aco.[Guid] = ac.AtrAnswerGuid  
	INNER JOIN TAtrAnswer aa ON aa.AtrAnswerId = aco.AtrAnswerId
WHERE  
	cq.AtrTemplateGuid = @AtrTemplateGuid    
	AND cc.TenantGuid = @TenantGuid
ORDER BY 
	cc.AtrCategoryId, ac.Ordinal, ac.Weighting  
    
-- Retrieve all Risk Profiles.    
SELECT   
	*,
	CAST(RiskNumber as varchar(3)) + ' - ' + BriefDescription AS NumberAndDescription
FROM   
	PolicyManagement..TRiskProfileCombined  
WHERE  
	AtrTemplateGuid = @TemplateToUse  
ORDER BY  
	RiskNumber


GO
