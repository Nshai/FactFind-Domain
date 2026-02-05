SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveRiskProfileCombinedByTemplate]
	@AtrTemplateGuid uniqueidentifier
AS
	SELECT
		RiskProfileId AS rowId,
		*
	FROM
		TRiskProfileCombined
	WHERE
		AtrTemplateGuid = @AtrTemplateGuid
	FOR XML RAW
GO
