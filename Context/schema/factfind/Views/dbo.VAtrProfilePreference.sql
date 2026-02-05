SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[VAtrProfilePreference]  
AS  
SELECT  T.AtrTemplateId, P.Identifier 
FROM    
	dbo.TAtrTemplate T
	INNER JOIN  dbo.TAtrTemplateSetting S ON T.AtrTemplateId = S.AtrTemplateId  
	INNER JOIN  dbo.TAtrRefProfilePreference P ON S.AtrRefProfilePreferenceId = P.AtrRefProfilePreferenceId  
GO