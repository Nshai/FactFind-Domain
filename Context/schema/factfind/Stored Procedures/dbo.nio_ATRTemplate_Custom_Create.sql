SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_ATRTemplate_Custom_Create]        
@Identifier varchar(255),        
@Descriptor varchar(1000),   
@HasFreeTextAnswers bit,     
@TenantGuid uniqueidentifier,        
@BaseAtrTemplate uniqueidentifier,        
@AtrRefPortfolioType bigint,    
@Tenant bigint,        
@Guid uniqueidentifier        
        
        
AS        
      
DECLARE @StampUser varchar(255)      
      
SELECT @StampUser='999999998'            
        
      
        
DECLARE @AtrTemplateId bigint        
        
--Create ATrTemplate record first        
INSERT TAtrTemplate(        
Identifier,        
Descriptor,  
HasFreeTextAnswers,      
Active,        
HasModels,        
BaseAtrTemplate,      
AtrRefPortfolioTypeId,      
IndigoClientId,        
Guid,        
IsArchived,    
ConcurrencyId)        
        
SELECT @Identifier, @Descriptor, @HasFreeTextAnswers, 0, 0, @BaseAtrTemplate,@AtrRefPortfolioType, @Tenant, @Guid,0, 1        
        
SELECT @AtrTemplateId=SCOPE_IDENTITY()        
        
--Create Combined Record        
INSERT TAtrTemplateCombined(        
Guid,        
AtrTemplateId,        
Identifier,        
Descriptor, 
HasFreeTextAnswers,       
Active,        
HasModels,        
BaseAtrTemplate,        
AtrRefPortfolioTypeId,    
IndigoClientId,        
IndigoClientGuid,        
IsArchived,    
ConcurrencyId)        
        
SELECT Guid,AtrTemplateId, Identifier, Descriptor,HasFreeTextAnswers, Active, HasModels, BaseAtrTemplate, AtrRefPortfolioTypeId,       
  IndigoClientId, @TenantGuid, IsArchived,1        
FROM TAtrTemplate        
WHERE AtrTemplateId=@AtrTemplateId         
      
EXEC FactFind..SpNAuditAtrTemplateCombined @StampUser,@AtrTemplateId,'C'

EXEC FactFind..SpNAuditAtrTemplate  @StampUser,@Guid,'C'    
        
SELECT @AtrTemplateId 

GO
