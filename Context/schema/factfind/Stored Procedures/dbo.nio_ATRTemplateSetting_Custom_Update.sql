SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_ATRTemplateSetting_Custom_Update]  
	@ATRTemplate uniqueidentifier,  @AtrRefProfilePreference bigint,  @OverrideProfile bigint,  
	@LossAndGain bigint,  @AssetAllocation bigint,  @CostOfDelay bigint,  
	@Report bigint,  @AutoCreateOpportunities bigint,  @ReportLabel varchar(255), @AtrTemplateSettingId bigint
AS    

DECLARE @ATrTemplateId bigint    

SET @AtrTemplateId=(SELECT AtrTemplateId FROM TAtrTemplateCombined WHERE Guid=@ATRTemplate)        

IF ISNULL(@AtrTemplateSettingId,0)!=0    
BEGIN     
	UPDATE TAtrTemplateSetting   
	SET AtrTemplateId=@AtrTemplateId, 
		AtrRefProfilePreferenceId=@AtrRefProfilePreference,   
		OverrideProfile=@OverrideProfile,   
		LossAndGain=@LossAndGain,   
		AssetAllocation=@AssetAllocation,   
		CostOfDelay=@CostOfDelay,   
		Report=@Report,   
		AutoCreateOpportunities=@AutoCreateOpportunities,   
		ReportLabel=@ReportLabel,
		ConcurrencyId=ConcurrencyId + 1     
	WHERE AtrTemplateSettingId=@AtrTemplateSettingId    
END 
GO
