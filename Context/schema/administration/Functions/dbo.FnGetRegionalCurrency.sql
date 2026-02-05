SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yury Zakharov
-- Create date: 2020-03-02
-- Description:	This function returns the regional currency
-- When no base currency is found, hardcoded value (GBP) is returned.
-- =============================================
CREATE FUNCTION [dbo].[FnGetRegionalCurrency]()
RETURNS [NCHAR](3)
WITH SCHEMABINDING
AS
BEGIN
RETURN  (SELECT TOP 1 ISNULL((SELECT [CurrencyCode] FROM [dbo].[TRefRegionalCurrency] WITH(NOLOCK)),'GBP' ))
END;


