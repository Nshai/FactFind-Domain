SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveAtrAnswerCombinedByQuestion]
	@AtrQuestionGuid uniqueidentifier
AS
	SELECT
		AtrAnswerId AS rowId,
		*
	FROM
		TAtrAnswerCombined
	WHERE
		AtrQuestionGuid = @AtrQuestionGuid
	FOR XML RAW
GO
