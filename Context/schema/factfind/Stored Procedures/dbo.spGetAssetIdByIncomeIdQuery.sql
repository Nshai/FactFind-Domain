SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS ON
GO

-- =============================================================
-- Description: Stored procedure for getting AssetId by IncomeId
-- =============================================================
CREATE PROCEDURE [dbo].[spGetAssetIdByIncomeIdQuery] 
	@IncomeId BIGINT
AS

SELECT TOP (1)
	ta.AssetsId AS Id
FROM TAssets ta
WHERE ta.IncomeId = @IncomeId

GO