SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrAssetClass_Custom_Update]  
@Identifier varchar(255),  
@Allocation decimal(5,2), 
@Ordering tinyint,  
@AtrRefAssetClass bigint,  
@AtrPortfolio uniqueidentifier,  
@Guid uniqueidentifier    
  
AS  
  
DECLARE @AtrAssetClassId bigint  

DECLARE @StampUser varchar(255)

SELECT @StampUser='999999998'  
  
SET @AtrAssetClassId=(SELECT AtrAssetClassId FROM TAtrAssetClassCombined WHERE Guid=@Guid)  
  
IF ISNULL(@AtrAssetClassId,0)!=0  
  
  
BEGIN  
 Update TAtrAssetClass  
 SET Identifier=@Identifier,  
 Allocation=@Allocation,  
 Ordering=@Ordering,  
 AtrRefAssetClassId=@AtrRefAssetClass,  
 AtrPortfolioGuid=@AtrPortfolio,   
 ConcurrencyId=ConcurrencyId + 1  
  
 WHERE Guid=@Guid  

 EXEC FactFind..SpNAuditAtrAssetClassCombined @StampUser,@AtrAssetClassId,'U'
  
 Update TAtrAssetClassCombined  
 SET Identifier=@Identifier,  
 Allocation=@Allocation,  
 Ordering=@Ordering,   
 AtrRefAssetClassId=@AtrRefAssetClass,  
 AtrPortfolioGuid=@AtrPortfolio,   
 ConcurrencyId=ConcurrencyId + 1  
  
 WHERE Guid=@Guid  
  
END  
  
  
  
GO
