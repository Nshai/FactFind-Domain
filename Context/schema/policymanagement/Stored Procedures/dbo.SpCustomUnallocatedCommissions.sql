SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomUnallocatedCommissions]
	@IndigoClientId int,
	@ProviderId int = 0,
	@StartDate varchar(20), 
	@EndDate varchar(20), 
	@LowAmount money = -99999999, 
	@HighAmount money = -99999999

AS

declare @TestDate datetime
select @TestDate = Convert(datetime, '01 Jan 1899')
select @StartDate = Convert(datetime, @StartDate)
select @EndDate = Convert(datetime, @EndDate)
select @LowAmount = Convert(money, @LowAmount)
select @HighAmount = Convert(money, @HighAmount)

BEGIN
 SELECT
  1 AS Tag,
  NULL AS Parent,
  T1.ProvBreakId AS [Unallocated!1!ProvBreakId],
  T1.ProvComStateId AS [Unallocated!1!ProvComStateId],
  T2.ProviderName AS [Unallocated!1!ProviderName],
  T1.ClientName AS [Unallocated!1!ClientName],
  T1.PolicyNo AS [Unallocated!1!PolicyNo],
  T2.StatementDate AS [Unallocated!1!StatementDate],
  T1.Amount AS [Unallocated!1!Amount]
 FROM Commissions..TProvBreak T1
 INNER JOIN Commissions..TProvComState T2
 ON T2.ProvComStateId = T1.ProvComStateId

 WHERE T1.IndClientId = @IndigoClientId
 AND T1.AnalyseFG = 0
 AND	(
  (@StartDate <> @TestDate AND @EndDate <> @TestDate AND @LowAmount <> -99999999 AND @HighAmount <> -99999999 AND @ProviderId <> 0 AND((T1.Amount BETWEEN @LowAmount AND @HighAmount)AND(T2.StatementDate BETWEEN @StartDate AND @EndDate)AND T2.ProviderId = @ProviderId)) --All Parameters supplied
  OR
  (@StartDate = @TestDate AND @EndDate = @TestDate AND @LowAmount = -99999999 AND @HighAmount = -99999999 AND @ProviderId <> 0 AND(T2.ProviderId = @ProviderId)) --Provider Only
  OR
  (@StartDate <> @TestDate AND @EndDate <> @TestDate AND @LowAmount = -99999999 AND @HighAmount = -99999999 AND @ProviderId <> 0 AND((T2.StatementDate BETWEEN @StartDate AND @EndDate)AND T2.ProviderId = @ProviderId)) --Provider and Dates only
  OR
  (@StartDate = @TestDate AND @EndDate = @TestDate AND @LowAmount <> -99999999 AND @HighAmount <> -99999999 AND @ProviderId <> 0 AND((T1.Amount BETWEEN @LowAmount AND @HighAmount)AND T2.ProviderId = @ProviderId)) --Provider and Amounts only
  OR
  (@StartDate = @TestDate AND @EndDate = @TestDate AND @LowAmount <> -99999999 AND @HighAmount <> -99999999 AND @ProviderId = 0 AND(T1.Amount BETWEEN @LowAmount AND @HighAmount)) --Amounts only
  OR
  (@StartDate <>@TestDate AND @EndDate <> @TestDate AND @LowAmount = -99999999 AND @HighAmount = -99999999 AND @ProviderId = 0 AND(T2.StatementDate BETWEEN @StartDate AND @EndDate)) --Dates only
  OR
  (@StartDate <>@TestDate AND @EndDate <> @TestDate AND @LowAmount <> -99999999 AND @HighAmount <> -99999999 AND @ProviderId = 0 AND(T2.StatementDate BETWEEN @StartDate AND @EndDate) AND (T1.Amount BETWEEN @LowAmount AND @HighAmount)) --Dates and Amounts Only
 	)

 FOR XML EXPLICIT

END
RETURN(0)







GO
