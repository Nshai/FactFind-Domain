SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveAtrTemplateSettingById]
	@AtrTemplateSettingId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.AtrTemplateSettingId AS [AtrTemplateSetting!1!AtrTemplateSettingId], 
	T1.AtrTemplateId AS [AtrTemplateSetting!1!AtrTemplateId], 
	T1.AtrRefProfilePreferenceId AS [AtrTemplateSetting!1!AtrRefProfilePreferenceId], 
	ISNULL(T1.OverrideProfile, '') AS [AtrTemplateSetting!1!OverrideProfile], 
	ISNULL(T1.LossAndGain, '') AS [AtrTemplateSetting!1!LossAndGain], 
	ISNULL(T1.AssetAllocation, '') AS [AtrTemplateSetting!1!AssetAllocation], 
	ISNULL(T1.CostOfDelay, '') AS [AtrTemplateSetting!1!CostOfDelay], 
	ISNULL(T1.Report, '') AS [AtrTemplateSetting!1!Report], 
	ISNULL(T1.AutoCreateOpportunities, '') AS [AtrTemplateSetting!1!AutoCreateOpportunities], 
	T1.ConcurrencyId AS [AtrTemplateSetting!1!ConcurrencyId]
	FROM TAtrTemplateSetting T1
	
	WHERE T1.AtrTemplateSettingId = @AtrTemplateSettingId
	ORDER BY [AtrTemplateSetting!1!AtrTemplateSettingId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
