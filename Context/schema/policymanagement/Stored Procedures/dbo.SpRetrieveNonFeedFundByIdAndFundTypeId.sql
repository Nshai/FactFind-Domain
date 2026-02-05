SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveNonFeedFundByIdAndFundTypeId]
@NonFeedFundId bigint,
@FundTypeId int
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.NonFeedFundId AS [NonFeedFund!1!NonFeedFundId], 
    T1.FundTypeId AS [NonFeedFund!1!FundTypeId], 
    T1.FundTypeName AS [NonFeedFund!1!FundTypeName], 
    T1.FundName AS [NonFeedFund!1!FundName], 
    ISNULL(T1.CompanyId, '') AS [NonFeedFund!1!CompanyId], 
    ISNULL(T1.CompanyName, '') AS [NonFeedFund!1!CompanyName], 
    ISNULL(T1.Sedol, '') AS [NonFeedFund!1!Sedol], 
    ISNULL(T1.MexId, '') AS [NonFeedFund!1!MexId], 
    T1.IndigoClientId AS [NonFeedFund!1!IndigoClientId], 
    ISNULL(T1.CurrentPrice, '') AS [NonFeedFund!1!CurrentPrice], 
    ISNULL(CONVERT(varchar(24), T1.PriceDate, 120),'') AS [NonFeedFund!1!PriceDate], 
    ISNULL(T1.PriceUpdatedByUser, '') AS [NonFeedFund!1!PriceUpdatedByUser], 
    T1.ConcurrencyId AS [NonFeedFund!1!ConcurrencyId]
  FROM TNonFeedFund T1

  WHERE (T1.NonFeedFundId = @NonFeedFundId) AND 
        (T1.FundTypeId = @FundTypeId)

  ORDER BY [NonFeedFund!1!NonFeedFundId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
