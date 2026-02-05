SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrMatrix_Custom_Create]  
@IsImmediateIncome bit,  
@TenantGuid uniqueidentifier,  
@RiskProfile uniqueidentifier,  
@ATRTemplate  uniqueidentifier,  
@Tenant bigint,  
@AtrPortfolio uniqueidentifier,  
@AtrMatrixTerm uniqueidentifier,  
@Guid uniqueidentifier  
  
  
AS  
  
DECLARE @AtrMatrixId bigint  
DECLARE @StampUser varchar(255)

SELECT @StampUser='999999998'
  
  
  
BEGIN  
 INSERT TAtrMatrix  
  (ImmediateIncome,  
   IndigoClientId,  
   RiskProfileGuid,  
   AtrPortfolioGuid,  
   AtrTemplateGuid,  
   AtrMatrixTermGuid,  
   Guid,  
   ConcurrencyId)  
  
 SELECT @IsImmediateIncome,@Tenant,@RiskProfile,@AtrPortfolio,@ATRTemplate,@AtrMatrixTerm,@Guid,1  
  
  
 SELECT @AtrMatrixId=SCOPE_IDENTITY()  

 
  
--Audited by NIO
 INSERT TAtrMatrixCombined  
   (Guid,  
   AtrMatrixId,  
   ImmediateIncome,  
   IndigoClientId,  
   IndigoClientGuid,  
   RiskProfileGuid,  
   AtrPortfolioGuid,  
   AtrTemplateGuid,  
   AtrMatrixTermGuid,  
   ConcurrencyId)  
  
 SELECT @Guid,@AtrMatrixId,@IsImmediateIncome,@Tenant,@TenantGuid,@RiskProfile,@AtrPortfolio,@ATRTemplate,@AtrMatrixTerm,1  
   
  EXEC FactFind..SpNAuditAtrMatrixCombined @StampUser,@AtrMatrixId,'C'
  
END  
  
GO
