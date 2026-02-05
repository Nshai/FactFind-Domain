SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[VAtrQuestionsWithRiskGroup]  
AS  
SELECT  
		T.Guid AS AtrTemplateGuid,
		Q.AtrQuestionSyncId,
		Q.AtrQuestionId,
		Q.Description AS QuestionText,
		Q.Ordinal,
		Q.Active,
		Q.AtrTemplateGuid As QuestionAtrTemplateGuid, --BaseTemplateId (if Template uses BaseTemplate)
		Q.IndigoClientId,
		Q.Guid,
		RG.Name AS RiskGroupName,
		RG.Description AS RiskGroupDescription,
		RG.Tolerance
	
FROM    
	dbo.TAtrTemplate T
	INNER JOIN  dbo.TAtrQuestion Q ON Q.AtrTemplateGuid = ISNULL(T.BaseAtrTemplate,T.Guid)
	LEFT JOIN  dbo.TAtrQuestionRiskGrouping QRG ON QRG.AtrQuestionGuid = Q.Guid and QRG.AtrTemplateGuid = T.Guid
	LEFT JOIN  dbo.TRiskGrouping RG ON RG.RiskGroupingId = QRG.RiskGroupingId
GO