USE [factfind]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FnCustomGetMortgageRemainingTerm] 
( @start datetime, @end datetime, @maortgageTerm decimal(15,6) )
RETURNS varchar(10)
AS
BEGIN
	DECLARE @today DATE = GETUTCDATE()
	DECLARE @endDate DATE, @endYear INT, @endMonth INT, @remainingTerm VARCHAR(10)
	
	IF (@end is not null AND @end != '')
	BEGIN 
	    SET @endDate = @end 
	END
	ELSE IF (@start is not null AND @start != '' AND @maortgageTerm is not null)
	BEGIN
	  SET @endYear = FLOOR(@maortgageTerm)
	  SET @endMonth = CAST(ROUND((@maortgageTerm % 1) * 12, 0) AS INT)
	  SET @endDate = DATEADD(month, @endMonth, @start)
	  SET @endDate = DATEADD(year, @endYear, @endDate)
    END

	IF(@endDate is not null AND @endDate > @today)
	BEGIN
		DECLARE @years INT = DATEDIFF(yy, @today, @endDate)
		IF DATEADD(yy, -@years, @endDate) < @today 
			SELECT @years = @years-1
		SET @endDate = DATEADD(yy, -@years, @endDate)

		DECLARE @months INT = DATEDIFF(mm, @today, @endDate)
		IF DATEADD(mm, -@months, @endDate) < @today 
			SELECT @months = @months-1
		SET @endDate = DATEADD(mm, -@months, @endDate)

		IF DATEDIFF(dd, @today, @endDate) > 0
		BEGIN
			SET @months = @months + 1 
			IF @months = 12
			BEGIN
				SET @years = @years + 1
				SET @months = 0
			END 
		END
		SET @remainingTerm = CONVERT(VARCHAR(3), @years) + 'y ' + CONVERT(VARCHAR(3), @months) + 'm'
	END

	RETURN @remainingTerm
END
GO