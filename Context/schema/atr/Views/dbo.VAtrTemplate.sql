SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW dbo.VAtrTemplate
AS

SELECT
       [AtrTemplateId]
      ,[Name]
      ,[IndigoClientId]
      ,[GroupId]
      ,[IncludeSubGroups]
      ,[IsActive]
      ,[AppId]
      ,[AppName]
      ,[AtrAppTemplateId]
      ,[AtrQuestionAnswerJson]
      ,[AtrAssetModelId]
      ,[RiskGroupJson]
      ,[InconsistentAnswers]
      ,[RiskProfileJson]
      ,[CreatedAt]
      ,[UpdatedAt]
      ,[CreatedBy]
	  ,[MigrationRef]
	  ,(SELECT CASE WHEN EXISTS(SELECT NULL FROM atr..TAtr WHERE AtrTemplateId = T.AtrTemplateId)	  
			THEN CAST(1 AS BIT) 
			ELSE CAST(0 AS BIT) END 
	   ) as HasAnswers
      ,[RetakeInterval]
FROM
	atr..TAtrTemplate T
	WHERE IsArchived=0;
GO
