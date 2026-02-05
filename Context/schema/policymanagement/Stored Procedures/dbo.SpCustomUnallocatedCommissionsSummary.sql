SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomUnallocatedCommissionsSummary]
	@IndigoClientId int,
	@ProviderId int,
	@StartDate varchar(20),
	@EndDate varchar(20),
	@LowAmount money,
	@HighAmount money
AS
 
-- declare @IndigoClientId int
-- declare @ProviderId int
-- declare @StartDate varchar(20)
-- declare @EndDate varchar(20)
-- declare @LowAmount money
-- declare @HighAmount money
-- 
-- select @ProviderId = 0
-- select @LowAmount = 100
-- select @HighAmount= 5000
-- select @StartDate = Convert(datetime, '01 Jan 1899') 
-- select @EndDate = Convert(datetime, '01 Jan 1899') 
 
declare @MISSING_DATE datetime
select @MISSING_DATE = Convert(datetime, '01 Jan 1899') 

declare @ProviderName varchar(255)
SELECT @ProviderName = T2.CorporateName
FROM PolicyManagement..TRefProdProvider T1
JOIN CRM..TCRMContact T2
ON T2.CRMContactId = T1.CRMContactId
WHERE T1.RefProdProviderId = @ProviderId

select @ProviderName = ISNULL(@ProviderName,'All')

select @StartDate = Convert(datetime, @StartDate)
select @EndDate = Convert(datetime, @EndDate)
select @LowAmount = Convert(money, @LowAmount)
select @HighAmount = Convert(money, @HighAmount)

BEGIN
 SELECT 
  1 AS Tag,
  NULL AS Parent,
  CASE 
      WHEN @StartDate = @MISSING_DATE THEN 'Not Specified' 
      ELSE Convert(char(12), @StartDate)
  END AS [UnallocatedSummary!1!StartDate],
  CASE 
      WHEN @EndDate = @MISSING_DATE THEN 'Not Specified' 
      ELSE Convert(char(12), @EndDate) 
  END AS [UnallocatedSummary!1!EndDate],
  CASE 
      WHEN @LowAmount = -99999999.00 THEN 'Not Specified' 
      ELSE CONVERT(Varchar(25),@LowAmount) 
  END AS [UnallocatedSummary!1!LowAmount],
  CASE 
      WHEN @HighAmount = -99999999.00 THEN 'Not Specified' 
      ELSE CONVERT(Varchar(25),@HighAmount) 
  END AS [UnallocatedSummary!1!HighAmount],
  @ProviderName AS [UnallocatedSummary!1!SearchProviderName],
  CASE WHEN sum(T2.Amount) > 0 THEN  
 	ISNULL(sum(T2.Amount),0) 
  	ELSE 0 
  END AS [UnallocatedSummary!1!PositiveAmountsTotal], 
  T1.Identifier AS [UnallocatedSummary!1!PositiveRange],
  CASE WHEN sum(T2.Amount) < 0 THEN  
 	ISNULL(sum(T2.Amount),0) 
  	ELSE 0 
  END AS [UnallocatedSummary!1!NegativeAmountsTotal],
  CASE WHEN T1.Identifier = '> ·100,000' THEN
	'< -·100,000'
  	ELSE '-' + Replace(T1.Identifier, 'To ·', 'To -·') 
  END AS [UnallocatedSummary!1!NegativeRange]

  FROM Commissions..TProvComState T3
  JOIN Commissions..TProvBreak T2
  ON T3.ProvComStateId = T2.ProvComStateId AND T3.MatchedFG = 1
  AND T3.IndClientId = T2.IndClientId
  RIGHT JOIN Reports..TRefAmountRange T1
  ON ((T2.Amount between T1.Minimum and T1.Maximum) OR (T2.Amount between (T1.Maximum - (2*T1.Maximum)) and (T1.Minimum - (2*T1.Minimum))))
	AND T2.IndClientId = 1 AND  T2.AnalyseFG = 0
 AND 	(
  (@StartDate <> @MISSING_DATE AND @EndDate <> @MISSING_DATE AND @LowAmount <> -99999999 AND @HighAmount <> -99999999 AND @ProviderId <> 0 AND((T2.Amount BETWEEN @LowAmount AND @HighAmount)AND(T3.StatementDate BETWEEN @StartDate AND @EndDate)AND T3.ProviderId = @ProviderId)) --All Parameters supplied
  OR
  (@StartDate = @MISSING_DATE AND @EndDate = @MISSING_DATE AND @LowAmount = -99999999 AND @HighAmount = -99999999 AND @ProviderId <> 0 AND(T3.ProviderId = @ProviderId)) --Provider Only
  OR
  (@StartDate <> @MISSING_DATE AND @EndDate <> @MISSING_DATE AND @LowAmount = -99999999 AND @HighAmount = -99999999 AND @ProviderId <> 0 AND((T3.StatementDate BETWEEN @StartDate AND @EndDate)AND T3.ProviderId = @ProviderId)) --Provider and Dates only
  OR
  (@StartDate = @MISSING_DATE AND @EndDate = @MISSING_DATE AND @LowAmount <> -99999999 AND @HighAmount <> -99999999 AND @ProviderId <> 0 AND((T2.Amount BETWEEN @LowAmount AND @HighAmount)AND T3.ProviderId = @ProviderId)) --Provider and Amounts only
  OR
  (@StartDate = @MISSING_DATE AND @EndDate = @MISSING_DATE AND @LowAmount <> -99999999 AND @HighAmount <> -99999999 AND @ProviderId = 0 AND(T2.Amount BETWEEN @LowAmount AND @HighAmount)) --Amounts only
  OR
  (@StartDate <>@MISSING_DATE AND @EndDate <> @MISSING_DATE AND @LowAmount = -99999999 AND @HighAmount = -99999999 AND @ProviderId = 0 AND(T3.StatementDate BETWEEN @StartDate AND @EndDate)) --Dates only
  OR
  (@StartDate <>@MISSING_DATE AND @EndDate <> @MISSING_DATE AND @LowAmount <> -99999999 AND @HighAmount <> -99999999 AND @ProviderId = 0 AND(T3.StatementDate BETWEEN @StartDate AND @EndDate) AND (T2.Amount BETWEEN @LowAmount AND @HighAmount)) --Dates and Amounts Only
  OR
  (@StartDate = @MISSING_DATE AND @EndDate = @MISSING_DATE AND @LowAmount = -99999999 AND @HighAmount = -99999999 AND @ProviderId = 0)
 	)
 GROUP BY T1.Identifier, T3.ProviderName, T1.RefAmountRangeId
 ORDER BY T1.RefAmountRangeId

 FOR XML EXPLICIT

END
RETURN(0)








GO
