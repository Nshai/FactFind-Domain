SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrAssetClass]  
 @StampUser varchar (255),  
 @Guid uniqueidentifier,  
 @StampAction char(1)  
AS  
  
INSERT INTO TAtrAssetClassAudit   
( Identifier, Allocation, Ordering, AtrRefAssetClassId,   
  AtrPortfolioGuid, Guid, ConcurrencyId,   
 AtrAssetClassId, StampAction, StampDateTime, StampUser)   
Select Identifier, Allocation, Ordering, AtrRefAssetClassId,   
  AtrPortfolioGuid, Guid, ConcurrencyId,   
 AtrAssetClassId, @StampAction, GetDate(), @StampUser  
FROM TAtrAssetClass  
WHERE [Guid] = @Guid
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)  
  
GO
