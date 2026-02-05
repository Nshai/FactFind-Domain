USE [factfind]
GO
/****** Object:  UserDefinedFunction [dbo].[FnCustomGetMonthlyIncomeNetAmount]    Script Date: 4/9/2020 2:14:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION  [dbo].FnCustomGetMonthlyIncomeNetAmount(@NetAmount money, @Frequency varchar(255))
RETURNS money  
AS  
BEGIN  
 DECLARE @MonthlyNetAmount money  
  
 select @MonthlyNetAmount =
    case 
        when @Frequency = 'Monthly' then @NetAmount
		when @Frequency = 'Weekly' then (@NetAmount * 52 / 12)
		when @Frequency = 'Fortnightly' then (@NetAmount * 26 / 12)
		when @Frequency = 'Four Weekly' then (@NetAmount * 13 / 12)
		when @Frequency = 'Quarterly' then (@NetAmount * 4 / 12)
		when @Frequency = 'Half Yearly' then (@NetAmount * 2 / 12)
		when @Frequency = 'Annually' then (@NetAmount / 12)
		else @NetAmount
    end
  
 RETURN (@MonthlyNetAmount)  
END
