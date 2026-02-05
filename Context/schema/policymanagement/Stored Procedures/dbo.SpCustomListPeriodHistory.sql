SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomListPeriodHistory]
AS
BEGIN 

	SELECT
		1 AS tag,
		NULL AS Parent,
		T1.PeriodComHistId AS [Period!1!PeriodId],
		DATENAME(mm, T1.StartDatetime) + ' ' + DATENAME(yyyy, T1.StartDatetime) AS [Period!1!PaymentMonth],
		T1.StartDatetime AS [Period!1!StartDate],
		ISNULL(T1.EndDatetime, getDate()) AS [Period!1!EndDate]
	FROM 
		Commissions..TPeriodComHist T1
	ORDER BY T1.StartDatetime ASC
	FOR XML EXPLICIT

END








GO
