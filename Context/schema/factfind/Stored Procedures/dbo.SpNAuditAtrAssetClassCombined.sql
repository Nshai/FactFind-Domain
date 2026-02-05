SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrAssetClassCombined]  
 @StampUser varchar (255),  
 @AtrAssetClassId bigint,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrAssetClassCombinedAudit   
(AtrAssetClassId,Identifier,Allocation,Ordering,AtrPortfolioGuid,ConcurrencyId,Guid,
	StampAction,StampDateTime,StampUser)   

Select AtrAssetClassId,Identifier,Allocation,Ordering,AtrPortfolioGuid,ConcurrencyId,Guid,
		@StampAction, GetDate(), @StampUser  
FROM TAtrAssetClassCombined  
WHERE AtrAssetClassId = @AtrAssetClassId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
