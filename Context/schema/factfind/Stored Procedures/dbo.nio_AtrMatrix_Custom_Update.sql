SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrMatrix_Custom_Update]  
@AtrMatrixId bigint=null,  
@IsImmediateIncome bit,  
@TenantGuid uniqueidentifier,  
@RiskProfile uniqueidentifier,  
@ATRTemplate  uniqueidentifier,  
@Tenant bigint,  
@AtrPortfolio uniqueidentifier,  
@AtrMatrixTerm uniqueidentifier,  
@Guid uniqueidentifier  
  
  
  
AS  

DECLARE @StampUser varchar(255)

SELECT @StampUser='999999998'  

IF ISNULL(@AtrMatrixId,0)=0
BEGIN
	SELECT @AtrMatrixId=AtrMatrixId FROM TAtrMatrix WHERE Guid=@Guid
END
  
BEGIN  
 

 Update TAtrMatrix   
 SET ImmediateIncome=@IsImmediateIncome,AtrPortfolioGuid=@AtrPortfolio,  
 AtrMatrixTermGuid=@AtrMatrixTerm  
  
 WHERE Guid=@Guid AND AtrMatrixId=@AtrMatrixId  

 EXEC FactFind..SpNAuditAtrMatrixCombined @StampUser,@AtrMatrixId,'U'
  
 Update TAtrMatrixCombined   
 SET ImmediateIncome=@IsImmediateIncome,AtrPortfolioGuid=@AtrPortfolio,  
 AtrMatrixTermGuid=@AtrMatrixTerm  
  
 WHERE Guid=@Guid AND AtrMatrixId=@AtrMatrixId  
  
  
  
END  
  
GO
