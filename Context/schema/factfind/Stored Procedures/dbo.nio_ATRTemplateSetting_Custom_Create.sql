SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_ATRTemplateSetting_Custom_Create]  
	@ATRTemplate uniqueidentifier,  @AtrRefProfilePreference bigint,  @OverrideProfile int,  
	@LossAndGain int,  @AssetAllocation int,  @CostOfDelay int,  
	@Report int,  @AutoCreateOpportunities int          
AS    

DECLARE @ATrTemplateId bigint  
DECLARE @AtrTemplateSettingId bigint    

SET @AtrTemplateId=(SELECT AtrTemplateId FROM TAtrTemplateCombined WHERE Guid=@ATRTemplate)    

IF ISNULL(@AtrTemplateId,0)!=0    
BEGIN     
	INSERT TAtrTemplateSetting(   AtrTemplateId,   AtrRefProfilePreferenceId,   OverrideProfile,   LossAndGain,   
		AssetAllocation, CostOfDelay, Report, AutoCreateOpportunities, ConcurrencyId)     
	SELECT @AtrTemplateId, @AtrRefProfilePreference, @OverrideProfile, @LossAndGain, 
		@AssetAllocation, @CostOfDelay, @Report, @AutoCreateOpportunities, 1    
		
	SELECT @AtrTemplateSettingId=SCOPE_IDENTITY()    
END    

SELECT @AtrTemplateSettingId    


GO
