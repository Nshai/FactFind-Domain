GO 
--@AssetIdsString - string that contains AssetIds separated with comma
CREATE FUNCTION [dbo].[FnRetrieveAssetCurrentValues] (@AssetIdsString varchar(max))
RETURNS @AssetValues TABLE(AssetId bigint, AssetValuationHistoryId bigint, Valuation money, ValuationDate datetime)
AS
BEGIN
	DECLARE @AssetIds TABLE(AssetId bigint);
	INSERT INTO @AssetIds 
		SELECT Id FROM dbo.FnGetIdsFromString(@AssetIdsString, ',')

	INSERT INTO @AssetValues
	SELECT valuationHistBorder.AssetId, 
			valuationHistBorder.AssetValuationHistoryId, 
			valuationHistBorder.Valuation,
			valuationHistBorder.ValuationDate
		FROM
			(
				SELECT 
					asset.AssetId, 
					valuationHistory.AssetValuationHistoryId,
					ROW_NUMBER() OVER(PARTITION BY asset.AssetId ORDER BY valuationHistory.ValuationDate DESC, valuationHistory.AssetValuationHistoryId DESC) AS RowId,
					valuationHistory.Valuation,
					valuationHistory.ValuationDate
				FROM @AssetIds asset 
				JOIN dbo.TAssetValuationHistory valuationHistory  with(nolock)
					ON valuationHistory.AssetId = asset.AssetId
				GROUP BY asset.AssetId, 
					valuationHistory.AssetValuationHistoryId, 
					valuationHistory.ValuationDate, 
					valuationHistory.Valuation
			) valuationHistBorder
		WHERE RowId = 1;
	RETURN
END