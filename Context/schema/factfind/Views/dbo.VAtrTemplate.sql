SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VAtrTemplate]
AS
SELECT  
 A.AtrTemplateId,
 A.Guid,
 A.BaseAtrTemplate,  
 CASE WHEN InUse.BaseAtrTemplate IS NULL THEN 0 ELSE 1 END AS [InUse],
 A.IndigoClientId,
 A.Active,
 A.AtrRefPortfolioTypeId
FROM  
 TAtrTemplate A  
 JOIN TAtrTemplateSetting S ON S.AtrTemplateId = A.AtrTemplateId  
 JOIN TAtrRefProfilePreference PP ON PP.AtrRefProfilePreferenceId = S.AtrRefProfilePreferenceId  
 LEFT JOIN TAtrTemplateCombined C ON C.Guid = A.BaseAtrTemplate -- the base template for this template  
 LEFT JOIN Administration..TIndigoClientCombined I ON I.Guid = C.IndigoClientGuid  
 LEFT JOIN ( -- to see if the template is in use  
  SELECT DISTINCT  
   BaseAtrTemplate  
  FROM  
   TAtrTemplateCombined  
  ) AS InUse ON InUse.BaseAtrTemplate = A.Guid       
GO
