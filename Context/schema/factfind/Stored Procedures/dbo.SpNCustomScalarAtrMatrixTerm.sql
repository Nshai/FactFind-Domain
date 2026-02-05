SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomScalarAtrMatrixTerm]
	@AtrTemplateGuid uniqueidentifier,
	@NumberOfYears int
AS
-- Declaration
DECLARE @Lowest tinyint, @Highest tinyint

-- Get high and low values
SELECT 
	@Lowest = MIN(Starting),
	@Highest = MAX(Ending)
FROM
	TAtrMatrixTermCombined
WHERE
	AtrTemplateGuid = @AtrTemplateGuid

IF @NumberOfYears < @Lowest
	SET @NumberOfYears = @Lowest

IF @NumberOfYears > @Highest
	SET @NumberOfYears = @Highest

SELECT
	Guid
FROM
	TAtrMatrixTermCombined
WHERE
	AtrTemplateGuid = @AtrTemplateGuid
	AND @NumberOfYears BETWEEN Starting AND Ending
GO
