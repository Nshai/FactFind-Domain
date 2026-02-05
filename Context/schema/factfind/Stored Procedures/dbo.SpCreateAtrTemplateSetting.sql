SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateAtrTemplateSetting]
	@StampUser varchar (255),
	@AtrTemplateId bigint, 
	@AtrRefProfilePreferenceId bigint, 
	@OverrideProfile bigint = 1, 
	@LossAndGain bigint = 1, 
	@AssetAllocation bigint = 1, 
	@CostOfDelay bigint = 1, 
	@Report bigint = 1, 
	@AutoCreateOpportunities bigint = 1	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @AtrTemplateSettingId bigint
			
	
	INSERT INTO TAtrTemplateSetting (
		AtrTemplateId, 
		AtrRefProfilePreferenceId, 
		OverrideProfile, 
		LossAndGain, 
		AssetAllocation, 
		CostOfDelay, 
		Report, 
		AutoCreateOpportunities, 
		ConcurrencyId)
		
	VALUES(
		@AtrTemplateId, 
		@AtrRefProfilePreferenceId, 
		@OverrideProfile, 
		@LossAndGain, 
		@AssetAllocation, 
		@CostOfDelay, 
		@Report, 
		@AutoCreateOpportunities,
		1)

	SELECT @AtrTemplateSettingId = SCOPE_IDENTITY()
	
	INSERT INTO TAtrTemplateSettingAudit (
		AtrTemplateId, 
		AtrRefProfilePreferenceId, 
		OverrideProfile, 
		LossAndGain, 
		AssetAllocation, 
		CostOfDelay, 
		Report, 
		AutoCreateOpportunities, 
		ConcurrencyId,
		AtrTemplateSettingId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		AtrTemplateId, 
		AtrRefProfilePreferenceId, 
		OverrideProfile, 
		LossAndGain, 
		AssetAllocation, 
		CostOfDelay, 
		Report, 
		AutoCreateOpportunities, 
		ConcurrencyId,
		AtrTemplateSettingId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TAtrTemplateSetting
	WHERE AtrTemplateSettingId = @AtrTemplateSettingId
	EXEC SpRetrieveAtrTemplateSettingById @AtrTemplateSettingId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
