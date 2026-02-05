SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnCustomGetCalculatedRiskProfileGuid] (
	@ActiveTemplateGuid uniqueidentifier, -- this will normally be the active template (see FnAtrGetActiveTemplateDetails)
	@CRMContactId bigint,	
	@ObjectiveTypeId bigint = 1) -- Investment or retirement
RETURNS uniqueidentifier	
AS
BEGIN
DECLARE
	@Score int

-- Investment?
IF @ObjectiveTypeId = 1 -- Investment
	SELECT
		@Score = SUM(ISNULL(A.Weighting, 0))
	FROM
		TAtrQuestionCombined Q
		JOIN TAtrAnswerCombined A ON A.AtrQuestionGuid = Q.[Guid]
		JOIN TAtrInvestment I ON I.AtrAnswerGuid = A.[Guid]
	WHERE
		Q.AtrTemplateGuid = @ActiveTemplateGuid
		AND I.CRMContactId = @CRMContactId
ELSE
	SELECT
		@Score = SUM(ISNULL(A.Weighting, 0))
	FROM
		TAtrQuestionCombined Q
		JOIN TAtrAnswerCombined A ON A.AtrQuestionGuid = Q.[Guid]
		JOIN TAtrRetirement R ON R.AtrAnswerGuid = A.[Guid]
	WHERE
		Q.AtrTemplateGuid = @ActiveTemplateGuid
		AND R.CRMContactId = @CRMContactId			

RETURN (
	SELECT
		[Guid]
	FROM
		PolicyManagement..TRiskProfileCombined
	WHERE
		AtrTemplateGuid = @ActiveTemplateGuid
		AND @Score BETWEEN LowerBand AND UpperBand)
END
GO
