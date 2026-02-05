SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnDifferenceTotalMonths] 
(
	@Start datetime,
	@End datetime
)
RETURNS int
AS
BEGIN
	SET @End = dateadd(day, 1, @End)
	DECLARE @months int = (year(@End) - year(@Start)) * 12 + (month(@End) - month(@Start))

	IF day(@End) < day(@Start)
		SET @months = @months - 1

	RETURN @months
END

GO


