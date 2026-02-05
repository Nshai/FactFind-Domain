SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[nio_ATRTemplate_Custom_Update]      
@AtrTemplateId bigint=null,      
@Identifier varchar(255),      
@Descriptor varchar(1000),      
@IsActive bit,      
@HasModels bit, 
@HasFreeTextAnswers bit,   
@TenantGuid uniqueidentifier,   
@IsArchived bit,     
@BaseAtrTemplate uniqueidentifier,   
@AtrRefPortfolioType bigint,      
@Tenant bigint,      
@Guid uniqueidentifier      
      
      
AS      
      
      
DECLARE @StampUser varchar(255)    
    
SELECT @StampUser='999999998'         
      
SET @AtrTemplateId=(SELECT AtrTemplateId FROM TATRTemplate WHERE Guid=@Guid)      
      
IF ISNULL(@AtrTemplateId,0)=0      
BEGIN      
      
--Create ATrTemplate record first      
INSERT TAtrTemplate(      
Identifier,      
Descriptor,      
Active,      
HasModels,
HasFreeTextAnswers,    
IsArchived,    
BaseAtrTemplate,   
AtrRefPortfolioTypeId,     
IndigoClientId,      
Guid,      
ConcurrencyId)      
      
SELECT @Identifier, @Descriptor, @IsActive, @HasModels, @HasFreeTextAnswers, @IsArchived, @BaseAtrTemplate,@AtrRefPortfolioType, @Tenant, @Guid, 1      
      
SELECT @AtrTemplateId=SCOPE_IDENTITY()      
    
EXEC FactFind..SpNAuditAtrTemplate @StampUser,@Guid,'C'    
      
--Create Combined Record      
INSERT TAtrTemplateCombined(      
Guid,      
AtrTemplateId,      
Identifier,      
Descriptor,      
Active,      
HasModels,
HasFreeTextAnswers,      
IsArchived,   
BaseAtrTemplate,     
AtrRefPortfolioTypeId,   
IndigoClientId,      
IndigoClientGuid,      
ConcurrencyId)      
      
SELECT Guid,AtrTemplateId, Identifier, Descriptor, Active, HasModels, HasFreeTextAnswers, IsArchived, BaseAtrTemplate,  AtrRefPortfolioTypeId  ,  
  IndigoClientId, @TenantGuid, 1      
FROM TAtrTemplate      
WHERE AtrTemplateId=@AtrTemplateId       
    
EXEC FactFind..SpNAuditAtrTemplateCombined @StampUser,@AtrTemplateId,'C'    
    
END      
      
ELSE      
      
BEGIN      
    
EXEC FactFind..SpNAuditAtrTemplateCombined @StampUser,@AtrTemplateId,'U'    
    
 UPDATE TAtrTemplateCombined      
 SET Identifier=@Identifier,      
  Descriptor=@Descriptor,      
  Active=@IsActive,      
  HasModels=@HasModels,    
  HasFreeTextAnswers = @HasFreeTextAnswers,
  BaseAtrTemplate=@BaseAtrTemplate,    
  AtrRefPortfolioTypeId=@AtrRefPortfolioType    
 WHERE Guid=@Guid      
      
 UPDATE TAtrTemplate      
 SET Identifier=@Identifier,      
  Descriptor=@Descriptor,      
  Active=@IsActive,      
  HasModels=@HasModels,  
  HasFreeTextAnswers = @HasFreeTextAnswers,
  BaseAtrTemplate=@BaseAtrTemplate,  
   AtrRefPortfolioTypeId=@AtrRefPortfolioType      
 WHERE Guid=@Guid      
END        
        
      
SELECT @AtrTemplateId 

GO
