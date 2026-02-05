SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomSaveOrUpdateFeeModelForActionPlan]  
 @StampUser varchar (255),  
 @ActionPlanId bigint,  
 @FeeModelId bigint = NULL,    
 @InitialFeeModelTemplateId bigint = NULL,   
 @InitialAdviseFeeChargingDetailsId bigint = NULL,
 @DiscountId bigint = NULL,   
 @OngoingFeeModelTemplateId bigint  = NULL,
 @OngoingAdviseFeeChargingDetailsId bigint  = NULL

AS  
  
SET NOCOUNT ON  
  
DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX  
  
BEGIN  
  
 DECLARE @ActionPlanFeeModelId bigint  
 
 SELECT @ActionPlanFeeModelId = ActionPlanFeeModelId FROM TActionPlanFeeModel
 WHERE ActionPlanId = @ActionPlanId  
 
 

IF @ActionPlanFeeModelId > 0 
	BEGIN
		-- AUDIT the Update First
		EXEC dbo.SpNAuditFeeModelForActionPlan @StampUser, @ActionPlanFeeModelId, 'U'
		
		-- Update The Main Table
		UPDATE TActionPlanFeeModel
		SET FeeModelId = @FeeModelId, 
		InitialFeeModelTemplateId = @InitialFeeModelTemplateId,
		InitialAdviseFeeChargingDetailsId = @InitialAdviseFeeChargingDetailsId,
		DiscountId = @DiscountId,
		OngoingFeeModelTemplateId = @OngoingFeeModelTemplateId,
		OngoingAdviseFeeChargingDetailsId = @OngoingAdviseFeeChargingDetailsId,
		ConcurrencyId = ConcurrencyId + 1
		WHERE ActionPlanFeeModelId = @ActionPlanFeeModelId
	END
ELSE
	-- Insert a new record for fee modelling
	BEGIN
		INSERT INTO TActionPlanFeeModel (  
		ActionPlanId
		,FeeModelId
		,InitialFeeModelTemplateId
		,InitialAdviseFeeChargingDetailsId
		,DiscountId
		,OngoingFeeModelTemplateId
		,OngoingAdviseFeeChargingDetailsId
		,ConcurrencyId)  

		VALUES(  
		@ActionPlanId
		,@FeeModelId
		,@InitialFeeModelTemplateId
		,@InitialAdviseFeeChargingDetailsId
		,@DiscountId
		,@OngoingFeeModelTemplateId 
		,@OngoingAdviseFeeChargingDetailsId 
		,1)  

		SELECT @ActionPlanFeeModelId = SCOPE_IDENTITY()  

		EXEC dbo.SpNAuditFeeModelForActionPlan @StampUser, @ActionPlanFeeModelId, 'C'
	END

IF @@ERROR != 0 GOTO errh  
IF @tx = 0 COMMIT TRANSACTION TX  
  
END  
RETURN (0)  
  
errh:  
  IF @tx = 0 ROLLBACK TRANSACTION TX  
  RETURN (100)  
GO
