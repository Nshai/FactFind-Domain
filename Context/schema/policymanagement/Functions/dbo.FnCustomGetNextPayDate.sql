-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters
-- command (Ctrl-Shift-M) to fill in the parameter
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:    Yauheni Kachan
-- Create date: 24/05/2021
-- Description:  Required for due date calculation in spCustomCalculateNextDueDateAndAmount
-- =============================================
CREATE FUNCTION [dbo].[FnCustomGetNextPayDate]
(
  @refFrequencyId int, @initialDate DATETIME, @curDate DATETIME
)
RETURNS DATETIME
AS
BEGIN
  DECLARE @nextDate DATETIME = @initialDate;

  WHILE @initialDate < @curDate
  BEGIN
    SET @nextDate = CASE @refFrequencyId
                      -- Weekly
                      WHEN 1 THEN DATEADD(WEEK, 1, @initialDate)
                      -- Fortnightly
                      WHEN 2 THEN DATEADD(WEEK, 2, @initialDate)
                      -- Four Weeks
                      WHEN 3 THEN DATEADD(WEEK, 4, @initialDate)
                      -- Monthly
                      WHEN 4 THEN DATEADD(MONTH, 1, @initialDate)
                      --Quarterly
                      WHEN 5 THEN DATEADD(MONTH, 3, @initialDate)
                      --Half Yearly
                      WHEN 7 THEN DATEADD(MONTH, 6, @initialDate)
                      --Annual
                      WHEN 8 THEN DATEADD(YEAR, 1, @initialDate)
                    END

    SET @initialDate = CASE WHEN @refFrequencyId IN(4,5,7) THEN
                          CASE
                            --If the DAY of the initial date IS the same as the DAY of teh END OF THE MONTH, then return the END OF THE MONTH of the next date
                            --Unless for Feb the last day could be leap year so just account for that too
                            WHEN MONTH(@initialDate) = 2 AND DAY(@initialDate) IN(28,29) THEN EOMONTH(@nextDate)
                            WHEN MONTH(@initialDate) != 2 AND DAY(@initialDate) = DAY(EOMONTH(@initialDate)) THEN EOMONTH(@nextDate)
                            WHEN MONTH(@nextDate) != 2 AND DAY(@initialDate) > DAY(@nextDate) THEN CAST(CAST(DAY(@initialDate) AS VARCHAR(5)) + ' ' + CONVERT(CHAR(3), @nextDate, 0) + ' ' + CAST(YEAR(@nextDate) AS VARCHAR(5)) AS DATE)

                            --Otherwise just reurn the next Date
                            ELSE @nextDate
                          END
                          ELSE @nextDate
                        END
  END
  RETURN @initialDate
END
