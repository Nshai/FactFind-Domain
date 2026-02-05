SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VAtrTemplateSetting]  
AS  
SELECT  A.AtrTemplateSettingId, A.AtrTemplateId, B.Guid AS ATRTemplateGuid, A.AtrRefProfilePreferenceId, A.OverrideProfile,  
  A.LossAndGain, A.AssetAllocation, A.CostOfDelay, A.Report, A.AutoCreateOpportunities, A.ReportLabel,
  A.ConcurrencyId  
FROM    dbo.TAtrTemplateSetting A     
  JOIN TAtrTemplateCombined B ON A.AtrTemplateId = B.AtrTemplateId
GO
