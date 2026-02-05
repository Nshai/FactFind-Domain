SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAtrTemplateSetting]
	@StampUser varchar (255),
	@AtrTemplateSettingId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrTemplateSettingAudit 
( AtrTemplateId, AtrRefProfilePreferenceId, OverrideProfile, LossAndGain, 
		AssetAllocation, CostOfDelay, Report, AutoCreateOpportunities, ReportLabel,
		ConcurrencyId, 
	AtrTemplateSettingId, StampAction, StampDateTime, StampUser) 
Select AtrTemplateId, AtrRefProfilePreferenceId, OverrideProfile, LossAndGain, 
		AssetAllocation, CostOfDelay, Report, AutoCreateOpportunities, ReportLabel,
		ConcurrencyId, 
	AtrTemplateSettingId, @StampAction, GetDate(), @StampUser
FROM TAtrTemplateSetting
WHERE AtrTemplateSettingId = @AtrTemplateSettingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
