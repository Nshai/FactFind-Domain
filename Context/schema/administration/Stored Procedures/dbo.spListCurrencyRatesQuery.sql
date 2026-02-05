SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spListCurrencyRatesQuery] 
AS

SELECT
    cr.CurrencyCode AS Currency,
	cr.Rate
FROM TCurrencyRate cr
INNER JOIN TRefCurrency RC ON RC.CurrencyCode = CR.CurrencyCode
WHERE cr.IndigoClientId = 0
ORDER BY cr.CurrencyCode

GO 