SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomListCurrencies]
as

select 
1 as tag,
null as parent,
CurrencyCode as [RefCurrency!1!CurrencyCode], 
CurrencyCode + ' (' + Description + ')' AS [RefCurrency!1!Description],
Symbol as [RefCurrency!1!Symbol]
FROM TRefCurrency

FOR XML EXPLICIT
GO
