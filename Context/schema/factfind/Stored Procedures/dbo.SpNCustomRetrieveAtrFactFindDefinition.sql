SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAtrFactFindDefinition]  
	@IndigoClientId bigint  
AS  
DECLARE   
	@Guid uniqueidentifier,  
	@BaseGuid uniqueidentifier,  
	@AtrTemplateId bigint,  
	@IndigoClientGuid uniqueidentifier ,
	@EValueGuid   uniqueidentifier
  
 --Get the IndigoClientGuid  
select @IndigoClientGuid = Guid from administration..TIndigoClient where Indigoclientid = @IndigoClientId  
select @EValueGuid = Guid from administration..TIndigoClientCombined where Identifier = 'Tillinghast'
  
-- Get the active template for this indigo client  
SELECT TOP(1)   
	@Guid = Guid,  
	@BaseGuid = BaseAtrTemplate,  
	@AtrTemplateId = AtrTemplateId  
FROM  
	TAtrTemplate  
WHERE   
	IndigoClientId = @IndigoClientId  
	AND Active = 1    
ORDER BY AtrTemplateId DESC

SELECT   
	a.*   ,
	case when b.guid is not null and b.indigoclientguid = @EValueGuid then 1 else 0 end as isEvalue
FROM   
	TAtrTemplate a
	left join TATRTemplateCombined b on b.guid = a.baseatrtemplate
WHERE  
	a.Guid = @Guid  
   
-- Get ATR questions and profiles  
EXEC SpNCustomRetrieveAtrQuestionDefinition @Guid, @IndigoClientGuid  
  
SELECT   
	*   
FROM  
	TAtrTemplateSetting  
WHERE  
	AtrTemplateId = @AtrTemplateId   
  
-- List all the atr question categories  
select *, case when [name] = 'Default' then 1 else 0 end as Chosen 
from TATRCategory 
where TenantGuid = @IndigoClientGuid and IsArchived = 0
GO
