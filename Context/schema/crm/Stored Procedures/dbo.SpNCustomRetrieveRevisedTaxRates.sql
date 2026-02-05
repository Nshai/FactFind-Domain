SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveRevisedTaxRates] 
@CRMContactId BIGINT
AS
DECLARE @createDate AS DATETIME;
SELECT @createDate = CreatedDate
FROM   CRM..TCRMContact
WHERE  CRMContactId = @CRMContactId;
IF (CONVERT(DATETIME,convert(varchar, @createDate, 23), 110) <= CONVERT(DATETIME,'20130331', 110))
    BEGIN
        SELECT   1 AS TAG,
                 NULL AS Parent,
                 A.RefTaxRateId AS [RevisedRefTaxRate!1!RefTaxRateId],
                 TRIM(REPLACE(CAST(A.TaxRate as varchar(5)), '.0', ' ')) AS [RevisedRefTaxRate!1!TaxRate]
        FROM     TRefTaxRate AS A
        WHERE    A.IsArchived = 0
        ORDER BY [RevisedRefTaxRate!1!TaxRate]
        FOR      XML EXPLICIT;
    END
ELSE
    BEGIN
        SELECT   1 AS TAG,
                 NULL AS Parent,
                 A.RefTaxRateId AS [RevisedRefTaxRate!1!RefTaxRateId],
                 TRIM(REPLACE(CAST(A.TaxRate as varchar(5)), '.0', ' ')) AS [RevisedRefTaxRate!1!TaxRate]
        FROM     TRefTaxRate AS A
        WHERE    A.IsArchived = 0
                 AND A.TaxRate <> 50
        ORDER BY [RevisedRefTaxRate!1!TaxRate]
        FOR      XML EXPLICIT;
    END
GO
