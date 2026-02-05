SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNGetCurrencyLookUp]
AS

SELECT
	CR.CurrencyCode
FROM
	administration.dbo.TCurrencyRate CR
	INNER JOIN administration.dbo.TRefCurrency RC ON RC.CurrencyCode = CR.CurrencyCode
WHERE 
	CR.IndigoClientId = 0
ORDER BY
	CurrencyCode
FOR XML RAW('Currency')
GO
