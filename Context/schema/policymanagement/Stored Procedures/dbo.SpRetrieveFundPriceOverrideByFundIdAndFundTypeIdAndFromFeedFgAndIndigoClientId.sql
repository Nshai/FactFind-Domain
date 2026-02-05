SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveFundPriceOverrideByFundIdAndFundTypeIdAndFromFeedFgAndIndigoClientId]
@FundId bigint,
@FundTypeId bigint,
@FromFeedFg bit,
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.FundPriceOverrideId AS [FundPriceOverride!1!FundPriceOverrideId], 
    T1.IndigoClientId AS [FundPriceOverride!1!IndigoClientId], 
    T1.FundId AS [FundPriceOverride!1!FundId], 
    T1.FundTypeId AS [FundPriceOverride!1!FundTypeId], 
    T1.FromFeedFg AS [FundPriceOverride!1!FromFeedFg], 
    ISNULL(CONVERT(varchar(24), T1.PriceDate, 120),'') AS [FundPriceOverride!1!PriceDate], 
    ISNULL(T1.Price, '') AS [FundPriceOverride!1!Price], 
    ISNULL(T1.PriceUpdatedBy, '') AS [FundPriceOverride!1!PriceUpdatedBy], 
    T1.ConcurrencyId AS [FundPriceOverride!1!ConcurrencyId]
  FROM TFundPriceOverride T1

  WHERE (T1.FundId = @FundId) AND 
        (T1.FundTypeId = @FundTypeId) AND 
        (T1.FromFeedFg = @FromFeedFg) AND 
        (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [FundPriceOverride!1!FundPriceOverrideId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
