SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveNewAtrQuestionDefinition]  
	@AtrTemplateGuid1 uniqueidentifier,  -- this is the active template guid (NOT the base template though)
	@AtrTemplateGuid2 uniqueidentifier,
	@TenantGuid uniqueidentifier 
AS
DECLARE @BaseAtrTemplate1 uniqueidentifier, 
		@BaseAtrTemplate2 uniqueidentifier,
		@AtrTemplateToUse1 uniqueidentifier,
		@AtrTemplateToUse2 uniqueidentifier

-- Does the template have a base definition?
SELECT @BaseAtrTemplate1 = BaseAtrTemplate 
FROM TAtrTemplateCombined 
WHERE [Guid] = @AtrTemplateGuid1

SELECT @BaseAtrTemplate2 = BaseAtrTemplate 
FROM TAtrTemplateCombined 
WHERE [Guid] = @AtrTemplateGuid2

-- Use the base template to retrieve the questions (if base is available)
SELECT @AtrTemplateToUse1 = ISNULL(@BaseAtrTemplate1, @AtrTemplateGuid1);
SELECT @AtrTemplateToUse2 = ISNULL(@BaseAtrTemplate2, @AtrTemplateGuid2);

-- Get full list of questions for the active template
DECLARE @Questions TABLE (AtrQuestionGuid uniqueidentifier, AtrTemplateGuid uniqueidentifier, AtrTemplateId bigint, AtrQuestionSyncId varchar(50))
-- Insert
INSERT @Questions (AtrQuestionGuid, AtrTemplateGuid, AtrTemplateId, AtrQuestionSyncId)
SELECT a.[Guid], a.AtrTemplateGuid, t.AtrTemplateId, q.AtrQuestionSyncId
FROM TAtrQuestionCombined a
INNER JOIN TAtrQuestion q on q.AtrQuestionId = a.AtrQuestionId
INNER JOIN TAtrTemplate t on t.Guid = a.AtrTemplateGuid
WHERE a.AtrTemplateGuid IN (@AtrTemplateToUse1, @AtrTemplateToUse2) AND a.Active=1

-- Retrieve list of questions and their associated categories.  
SELECT DISTINCT 
	c.[AtrQuestionId], c.[Guid], c.[Description], c.Ordinal, c.Investment, c.Retirement, cc.AtrCategoryId,
	rg.RiskGroupingId, rg.Tolerance, q.AtrTemplateId, q.AtrQuestionSyncId
FROM 
	@Questions q 
	JOIN TATRCategoryQuestion a on a.AtrQuestionGuid = q.AtrQuestionGuid 
	JOIN TAtrCategoryCombined cc on a.AtrCategoryGuid = cc.[Guid]
	JOIN TAtrQuestionCombined c on q.AtrQuestionGuid = c.[Guid]
	LEFT JOIN TAtrQuestionRiskGrouping qrg on qrg.AtrQuestionGuid = q.AtrQuestionGuid and qrg.AtrTemplateGuid in (@AtrTemplateGuid1, @AtrTemplateGuid2)
	LEFT JOIN TRiskGrouping rg on rg.RiskGroupingId = qrg.RiskGroupingId
WHERE  
	a.AtrTemplateGuid in (@AtrTemplateGuid1, @AtrTemplateGuid2)       
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
	JOIN TAtrAnswer aa on aa.AtrAnswerId = aco.AtrAnswerId
WHERE  
	cq.AtrTemplateGuid in (@AtrTemplateGuid1, @AtrTemplateGuid2)   
	AND cc.TenantGuid = @TenantGuid
ORDER BY 
	cc.AtrCategoryId, ac.Ordinal, ac.Weighting  
    
-- Retrieve all Risk Profiles.    
SELECT DISTINCT r.*,
	CAST(r.RiskNumber as varchar(3)) + ' - ' + r.BriefDescription AS NumberAndDescription,
	t.AtrTemplateId
FROM   
	PolicyManagement..TRiskProfileCombined r INNER JOIN factfind..TAtrTemplate t ON r.AtrTemplateGuid = t.[Guid]  
WHERE  
	r.AtrTemplateGuid IN (@AtrTemplateToUse1, @AtrTemplateToUse2)
ORDER BY  
	RiskNumber


GO
