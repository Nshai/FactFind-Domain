SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomRetrieveBaseAtrTemplates]  @IndigoClientId bigint          
AS          
      
DECLARE @IndigoClientGuid uniqueidentifier          
          
SELECT           
 @IndigoClientGuid = [Guid]          
FROM          
 Administration..TIndigoClient          
WHERE          
 IndigoClientID = @IndigoClientId          
          
-- List of distinct template providers for this client          
SELECT distinct          
 A.Guid,        
 A.AtrTemplateId,        
 A.Identifier, -- + ' - ' + A.Identifier AS Identifier,          
 A.Descriptor,        
 A.Active,        
 A.HasModels,    
 A.HasFreeTextAnswers,   
 A.IndigoClientId,        
 A.IndigoClientGuid,      
 A.BaseAtrTemplate,  
 A.AtrRefPortfolioTypeId,  
 A.IsArchived,         
 A.ConcurrencyId        
         
FROM          
 Administration..TIndigoClientCombined I          
 JOIN TAtrTemplateCombined A ON A.IndigoClientGuid = I.Guid          
 JOIN Administration..TIndigoClientPreference P ON P.[Value] = I.Guid          
WHERE          
 I.IsAtrProvider = 1          
 AND P.IndigoClientGuid = @IndigoClientGuid          
 AND P.PreferenceName = 'AtrProfileProvider'          
ORDER BY          
 Identifier   
GO
