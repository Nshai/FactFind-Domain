SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnGetIdsFromString](@Csv varchar(8000), @Separator varchar(10))
RETURNS @Ids TABLE ([Id] bigint)
AS
BEGIN
	DECLARE @Start int, @End int, @SeparatorLength int

	SELECT
		@Start = 0,		
		@SeparatorLength = LEN(@Separator),
		@End = CHARINDEX(@Separator, @Csv, @Start)	

	WHILE (@End > 0)
	BEGIN 		
		INSERT INTO @Ids VALUES (CAST(SUBSTRING(@Csv, @Start, @End-@Start) AS bigint))

		SELECT 
			@Start = @End + @SeparatorLength,
			@End = CHARINDEX(@Separator, @Csv, @Start)	
	END 

	IF LEN(@Csv) >= @Start
		INSERT INTO @Ids VALUES (CAST(SUBSTRING(@Csv, @Start, LEN(@Csv)-@Start+1) AS bigint))

	RETURN
END
GO
