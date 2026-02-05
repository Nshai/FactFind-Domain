SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningFeeModelForSession]
	@StampUser varchar (255),
	@FinancialPlanningFeeModelForSessionId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningFeeModelForSessionAudit
           (FinancialPlanningId,FeeModelId,InitialFeeModelTemplateId,InitialAdviseFeeChargingDetailsId,DiscountId,OngoingFeeModelTemplateId,OngoingAdviseFeeChargingDetailsId,ConcurrencyId
           ,FinancialPlanningFeeModelForSessionId,StampAction,StampDateTime,StampUser)
SELECT FinancialPlanningId,FeeModelId,InitialFeeModelTemplateId,InitialAdviseFeeChargingDetailsId,DiscountId,OngoingFeeModelTemplateId,OngoingAdviseFeeChargingDetailsId,ConcurrencyId
           ,FinancialPlanningFeeModelForSessionId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningFeeModelForSession
WHERE FinancialPlanningFeeModelForSessionId = @FinancialPlanningFeeModelForSessionId     


IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
