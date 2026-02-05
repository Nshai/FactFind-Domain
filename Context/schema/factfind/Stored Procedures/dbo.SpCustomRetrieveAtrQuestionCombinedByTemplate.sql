SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveAtrQuestionCombinedByTemplate]
	@AtrTemplateGuid uniqueidentifier
AS
	SELECT
		AtrQuestionId AS rowId,
		*
	FROM
		TAtrQuestionCombined
	WHERE
		AtrTemplateGuid = @AtrTemplateGuid
	FOR XML RAW
GO
