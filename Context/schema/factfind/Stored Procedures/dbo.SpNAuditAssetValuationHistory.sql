SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAssetValuationHistory]  
	@StampUser varchar (255),  
	@AssetValuationHistoryId bigint,  
	@StampAction char(1)  
AS  
INSERT INTO TAssetValuationHistoryAudit (
	AssetValuationHistoryId, ConcurrencyId, AssetId, TenantId, Valuation, ValuationDate, ValueUpdatedByUserId, StampAction, StampDateTime, StampUser)
SELECT
	AssetValuationHistoryId, ConcurrencyId, AssetId, TenantId, Valuation, ValuationDate, ValueUpdatedByUserId, @StampAction, GETDATE(), @StampUser
FROM 
	TAssetValuationHistory
WHERE 
	AssetValuationHistoryId = @AssetValuationHistoryId  
GO
