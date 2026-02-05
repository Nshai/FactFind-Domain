SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveAtrTemplateByIndigoClientId]  
 @IndigoClientId bigint  
AS  
  
-- List of distinct template providers for this client  
SELECT  
 1 AS Tag,  
 NULL AS Parent,  
 A.AtrTemplateId AS [AtrTemplate!1!AtrTemplateId],  
 A.Guid AS [AtrTemplate!1!Guid],  
 A.BaseAtrTemplate AS [AtrTemplate!1!BaseAtrTemplate],  
A.BaseAtrTemplate AS [AtrTemplate!1!BaseATRTemplate],  
 A.Identifier AS [AtrTemplate!1!Identifier],  
 A.Descriptor AS [AtrTemplate!1!Descriptor],  
 A.Active AS  [AtrTemplate!1!Active],  
 A.HasModels AS [AtrTemplate!1!HasModels],  
 I.Identifier + ' - ' + C.Identifier AS [AtrTemplate!1!BaseTemplateName],  
 C.IndigoClientGuid AS [AtrTemplate!1!BaseTemplateProvider],  
 CASE WHEN InUse.BaseAtrTemplate IS NULL THEN 0 ELSE 1 END AS [AtrTemplate!1!InUse],  
 PP.AtrRefProfilePreferenceId AS [AtrTemplate!1!AtrRefProfilePreferenceId],  
 PP.Identifier AS [AtrTemplate!1!ProfilePreference],
 A.AtrRefPortfolioTypeId AS [AtrTemplate!1!AtrRefPortfolioTypeId]
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
WHERE  
 A.IndigoClientId = @IndigoClientId  
FOR  
 XML EXPLICIT

GO
