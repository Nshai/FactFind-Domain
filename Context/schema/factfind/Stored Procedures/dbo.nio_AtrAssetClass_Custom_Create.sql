SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrAssetClass_Custom_Create]  
@Identifier varchar(255),  
@Allocation decimal,  
@Ordering tinyint,  
@AtrRefAssetClass bigint,  
@AtrPortfolio uniqueidentifier,  
@Guid uniqueidentifier  
  
  
  
AS  
  
DECLARE @AtrAssetClassId bigint  
  
DECLARE @StampUser varchar(255)

SELECT @StampUser='999999998'     
  
  
BEGIN  
 INSERT TAtrAssetClass(   
 Identifier,  
 Allocation,  
 Ordering,  
 AtrRefAssetClassId,  
 AtrPortfolioGuid,  
 Guid,  
 ConcurrencyId)  
  
 SELECT @Identifier,@Allocation,@Ordering, @AtrRefAssetClass, @AtrPortfolio,@Guid, 1  
  
 SELECT @AtrAssetClassId=SCOPE_IDENTITY()  

 
  
 INSERT TAtrAssetClassCombined(  
 Guid,  
 AtrAssetClassId,  
 Identifier,  
 Allocation,  
 Ordering,  
 AtrRefAssetClassId,
 AtrPortfolioGuid,  
 ConcurrencyId)  
  
 SELECT @Guid,@AtrAssetClassId,@Identifier,@Allocation,@Ordering,@AtrRefAssetClass,@AtrPortfolio,1  
 
 EXEC FactFind..SpNAuditAtrAssetClassCombined @StampUser,@AtrAssetClassId,'C'
   
  
  
END  
  
SELECT @AtrAssetClassId  
  
GO
