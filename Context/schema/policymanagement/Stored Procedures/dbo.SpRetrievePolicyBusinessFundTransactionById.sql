SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrievePolicyBusinessFundTransactionById]
@PolicyBusinessFundTransactionId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.PolicyBusinessFundTransactionId AS [PolicyBusinessFundTransaction!1!PolicyBusinessFundTransactionId], 
    T1.PolicyBusinessFundId AS [PolicyBusinessFundTransaction!1!PolicyBusinessFundId], 
    ISNULL(CONVERT(varchar(24), T1.TransactionDate, 120),'') AS [PolicyBusinessFundTransaction!1!TransactionDate], 
    ISNULL(T1.RefFundTransactionTypeId, '') AS [PolicyBusinessFundTransaction!1!RefFundTransactionTypeId], 
    T1.Gross AS [PolicyBusinessFundTransaction!1!Gross], 
    T1.Cost AS [PolicyBusinessFundTransaction!1!Cost], 
    ISNULL(CONVERT(varchar(24), T1.UnitPrice), '') AS [PolicyBusinessFundTransaction!1!UnitPrice], 
    ISNULL(CONVERT(varchar(24), T1.UnitQuantity), '') AS [PolicyBusinessFundTransaction!1!UnitQuantity], 
    ISNULL(T1.ConcurrencyId, '') AS [PolicyBusinessFundTransaction!1!ConcurrencyId]
  FROM TPolicyBusinessFundTransaction T1

  WHERE (T1.PolicyBusinessFundTransactionId = @PolicyBusinessFundTransactionId)

  ORDER BY [PolicyBusinessFundTransaction!1!PolicyBusinessFundTransactionId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
