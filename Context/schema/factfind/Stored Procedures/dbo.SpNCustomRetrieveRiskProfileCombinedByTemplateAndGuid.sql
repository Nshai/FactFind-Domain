SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveRiskProfileCombinedByTemplateAndGuid]
	@AtrTemplateGuid uniqueidentifier,
	@RiskProfileGuid uniqueidentifier
AS
SELECT
	Guid,
	RiskNumber,
	Descriptor,
	BriefDescription	
FROM
	PolicyManagement..TRiskProfileCombined
WHERE
	AtrTemplateGuid = @AtrTemplateGuid
	AND Guid = @RiskProfileGuid
GO
