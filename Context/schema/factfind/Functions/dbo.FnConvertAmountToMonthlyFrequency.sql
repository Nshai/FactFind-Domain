USE [factfind]
GO

/****** dbo.FnConvertAmountToMonthlyFrequency convert an amount to monthly frequency, Script Date: 29/10/2019 ******/
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION FnConvertAmountToMonthlyFrequency
(
    @amount MONEY,
    @frequency varchar(50)
)

RETURNS MONEY
AS
BEGIN
    DECLARE @result MONEY
    -- (@amount * number) convert an amount to annual amount and divide by 12 to bring to a monthly value
    SET @result =
       CASE
          WHEN @frequency = 'Weekly' THEN (@amount * 52) / 12
          WHEN @frequency = 'Fortnightly' THEN (@amount * 26) / 12
          WHEN @frequency = 'FourWeekly' OR @frequency = 'Four Weekly' THEN (@amount * 13) / 12
          WHEN @frequency = 'Quarterly' THEN (@amount * 4) / 12
          WHEN @frequency = 'HalfYearly' OR @frequency = 'Half Yearly' THEN (@amount * 2) / 12
          WHEN @frequency = 'Annually' THEN @amount / 12
          ELSE @amount
       END

    RETURN @result
END
GO