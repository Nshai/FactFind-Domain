SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAtrTemplateSetting]   
	@IndigoClientId bigint  
AS  

-- Active AtrTemplate settings  
SELECT    TS.*  
FROM    TAtrTemplateSetting TS   
JOIN TAtrTemplate T ON T.AtrTemplateId = TS.AtrTemplateId  
WHERE    T.IndigoClientId = @IndigoClientId   AND T.Active = 1

GO
