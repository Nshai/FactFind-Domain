SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSaveOrUpdateFeeModelForFPSession]  
 @StampUser varchar (255),  
 @FinancialPlanningId bigint,  
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
  
 DECLARE @FinancialPlanningFeeModelForSessionId bigint  
 
 SELECT @FinancialPlanningFeeModelForSessionId = FinancialPlanningFeeModelForSessionId FROM TFinancialPlanningFeeModelForSession
 WHERE FinancialPlanningId = @FinancialPlanningId  
 
 

IF @FinancialPlanningFeeModelForSessionId > 0 
	BEGIN
		-- AUDIT the Update First
		EXEC dbo.SpNAuditFinancialPlanningFeeModelForSession @StampUser, @FinancialPlanningFeeModelForSessionId, 'U'
		
		-- Update The Main Table
		UPDATE TFinancialPlanningFeeModelForSession
		SET FeeModelId = @FeeModelId, 
		InitialFeeModelTemplateId = @InitialFeeModelTemplateId,
		InitialAdviseFeeChargingDetailsId = @InitialAdviseFeeChargingDetailsId,
		DiscountId = @DiscountId,
		OngoingFeeModelTemplateId = @OngoingFeeModelTemplateId,
		OngoingAdviseFeeChargingDetailsId = @OngoingAdviseFeeChargingDetailsId,
		ConcurrencyId = ConcurrencyId + 1
		WHERE FinancialPlanningFeeModelForSessionId = @FinancialPlanningFeeModelForSessionId
	END
ELSE
	-- Insert a new record for fee modelling
	BEGIN
		INSERT INTO TFinancialPlanningFeeModelForSession (  
		FinancialPlanningId
		,FeeModelId
		,InitialFeeModelTemplateId
		,InitialAdviseFeeChargingDetailsId
		,DiscountId
		,OngoingFeeModelTemplateId
		,OngoingAdviseFeeChargingDetailsId
		,ConcurrencyId)  

		VALUES(  
		@FinancialPlanningId
		,@FeeModelId
		,@InitialFeeModelTemplateId
		,@InitialAdviseFeeChargingDetailsId
		,@DiscountId
		,@OngoingFeeModelTemplateId  
		,@OngoingAdviseFeeChargingDetailsId
		,1)  

		SELECT @FinancialPlanningFeeModelForSessionId = SCOPE_IDENTITY()  

		EXEC dbo.SpNAuditFinancialPlanningFeeModelForSession @StampUser, @FinancialPlanningFeeModelForSessionId, 'C'
	END

IF @@ERROR != 0 GOTO errh  
IF @tx = 0 COMMIT TRANSACTION TX  
  
END  
RETURN (0)  
  
errh:  
  IF @tx = 0 ROLLBACK TRANSACTION TX  
  RETURN (100)  
GO
