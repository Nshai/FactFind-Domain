SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveBankDetailById]
@BankDetailId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.BankDetailId AS [BankDetail!1!BankDetailId], 
    T1.IndClientId AS [BankDetail!1!IndClientId], 
    T1.CRMOwnerId AS [BankDetail!1!CRMOwnerId], 
    T1.SortCode AS [BankDetail!1!SortCode], 
    T1.AccName AS [BankDetail!1!AccName], 
    T1.AccNumber AS [BankDetail!1!AccNumber], 
    ISNULL(T1.CorporateId, '') AS [BankDetail!1!CorporateId], 
    ISNULL(T1.CRMBranchId, '') AS [BankDetail!1!CRMBranchId], 
    ISNULL(T1.RefAccTypeId, '') AS [BankDetail!1!RefAccTypeId], 
    ISNULL(T1.RefAccUseId, '') AS [BankDetail!1!RefAccUseId], 
    ISNULL(CONVERT(varchar(12), T1.AccBalance), '') AS [BankDetail!1!AccBalance], 
    T1.ConcurrencyId AS [BankDetail!1!ConcurrencyId]
  FROM TBankDetail T1

  WHERE (T1.BankDetailId = @BankDetailId)

  ORDER BY [BankDetail!1!BankDetailId]

  FOR XML EXPLICIT

END
RETURN (0)









GO
