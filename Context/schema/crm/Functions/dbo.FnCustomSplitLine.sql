SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Teodora Pilitis	
-- Create date: 03 Dec 2013
-- Description:	Split inline string into multi line pieces and return te result into table
-- =============================================
CREATE FUNCTION [dbo].[FnCustomSplitLine] 
(
	-- Add the parameters for the function here
	@line		VARCHAR(8000),
	@separator	VARCHAR(1)
)
RETURNS 
@SplittedLine TABLE 
(
	-- Add the column definitions for the TABLE variable here
	Position	int,
	TextLine	varchar(8000)
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	;WITH Pieces(pn, start, stop) AS (
				  SELECT 1, 1, CHARINDEX(@separator, @line)
				  UNION ALL
				  SELECT pn + 1, stop + 1, CHARINDEX(@separator, @line, stop + 1)
				  FROM Pieces
				  WHERE stop > 0
			)
			INSERT INTO
				@SplittedLine
			SELECT pn,
			  SUBSTRING(@line, start, CASE WHEN stop > 0 THEN stop-start ELSE 512 END) AS s
			FROM Pieces OPTION(MAXRECURSION 32767);
	RETURN
END
GO
