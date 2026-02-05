SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomUnmatchedReceipts] 
	@IndigoClientId int,
	@StartDate varchar(20), 
	@EndDate varchar(20), 
	@LowAmount  money, 
	@HighAmount money

AS

declare @MISSING_DATE datetime
select @MISSING_DATE = Convert(datetime, '01 Jan 1899') 

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
  END AS [UnmatchedReceipt!1!StartDate],
  CASE 
      WHEN @EndDate = @MISSING_DATE THEN 'Not Specified' 
      ELSE Convert(char(12), @EndDate) 
  END AS [UnmatchedReceipt!1!EndDate],
  CASE 
      WHEN @LowAmount = -99999999.00 THEN 'Not Specified' 
      ELSE CONVERT(Varchar(25),@LowAmount) 
  END AS [UnmatchedReceipt!1!LowAmount],
  CASE 
      WHEN @HighAmount = -99999999.00 THEN 'Not Specified' 
      ELSE CONVERT(Varchar(25),@HighAmount) 
  END AS [UnmatchedReceipt!1!HighAmount],
  T1.CashReceiptId AS [UnmatchedReceipt!1!CashReceiptId],
  T1.CashReceiptDate AS [UnmatchedReceipt!1!CashReceiptDate],
  T1.DescriptionUnmatched AS [UnmatchedReceipt!1!DescriptionUnmatched],	
  T1.Amount AS [UnmatchedReceipt!1!Amount]--,
--  T1.Notes AS [UnmatchedReceipt!1!Notes]
 FROM Commissions..TCashReceipt T1

 WHERE T1.MatchedFG = 0
  AND  (
  (@StartDate = @MISSING_DATE AND @EndDate = @MISSING_DATE AND @LowAmount <> -9999 AND @HighAmount <> -9999 AND (T1.Amount BETWEEN @LowAmount AND @HighAmount))
  OR
  (@StartDate <>@MISSING_DATE AND @EndDate <> @MISSING_DATE AND @LowAmount = -9999 AND @HighAmount = -9999 AND (T1.CashReceiptDate BETWEEN @StartDate AND @EndDate))
  OR
  (@StartDate <>@MISSING_DATE AND @EndDate <> @MISSING_DATE AND @LowAmount <> -9999 AND @HighAmount <> -9999 AND (T1.CashReceiptDate BETWEEN @StartDate AND @EndDate) AND (T1.Amount BETWEEN @LowAmount AND @HighAmount))
 	)
  AND T1.IndClientId = @IndigoClientId

  ORDER BY [UnmatchedReceipt!1!CashReceiptDate]

 FOR XML EXPLICIT

END
RETURN(0)





GO
