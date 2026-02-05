SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrQuestion_Custom_Create]       
@Description varchar(500),    
@Ordinal int,    
@IsInvestment bit,    
@IsRetirement bit,    
@IsActive bit,
@ATRTemplate uniqueidentifier,       
@TenantGuid uniqueidentifier,     
@Guid uniqueidentifier    
    
    
    
AS    
    
DECLARE @StampUser varchar(255), @IndigoClientId bigint ,@AtrQuestionId bigint 
  
SELECT @StampUser='999999998'  
    
IF ISNULL(@AtrQuestionId,0)=0    
    
select @IndigoClientId = IndigoClientId from administration..TIndigoClientCombined where Guid = @TenantGuid  
  
BEGIN    
   
  
 INSERT TAtrQuestion(     
 Description,    
 Ordinal,    
 Investment,    
 Retirement,    
 Active,    
 AtrTemplateGuid,    
 IndigoClientId,    
 Guid,    
 ConcurrencyId)    
    
 SELECT @Description, @Ordinal, @IsInvestment, @IsRetirement, @IsActive,    
   @ATRTemplate, @IndigoClientId, @Guid, 1    
    
 SELECT @AtrQuestionId=SCOPE_IDENTITY()    
  
   
    
 INSERT TAtrQuestionCombined(     
 Guid,    
 AtrQuestionId,    
 Description,    
 Ordinal,    
 Investment,    
 Retirement,    
 Active,    
 AtrTemplateGuid,    
 IndigoClientId,    
 IndigoClientGuid,    
 ConcurrencyId)    
    
 SELECT @Guid,@AtrQuestionId,@Description, @Ordinal, @IsInvestment, @IsRetirement, @IsActive,    
   @ATRTemplate,@IndigoClientId,@TenantGuid,1    
  
 EXEC FactFind..SpNAuditAtrQuestionCombined @StampUser,@AtrQuestionId,'C'  
    
END    
    
SELECT @Guid AS Guid    
GO
