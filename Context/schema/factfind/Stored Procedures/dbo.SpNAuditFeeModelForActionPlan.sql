SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFeeModelForActionPlan]
	@StampUser varchar (255),
	@ActionPlanFeeModelId bigint,
	@StampAction char(1)
AS

INSERT INTO TActionPlanFeeModelAudit
           (ActionPlanId,FeeModelId,InitialFeeModelTemplateId,InitialAdviseFeeChargingDetailsId,DiscountId,OngoingFeeModelTemplateId,OngoingAdviseFeeChargingDetailsId
           ,ConcurrencyId
           ,ActionPlanFeeModelId,StampAction,StampDateTime,StampUser)
SELECT ActionPlanId,FeeModelId,InitialFeeModelTemplateId,InitialAdviseFeeChargingDetailsId,DiscountId,OngoingFeeModelTemplateId,OngoingAdviseFeeChargingDetailsId,ConcurrencyId
           ,ActionPlanFeeModelId, @StampAction, GetDate(), @StampUser
FROM TActionPlanFeeModel
WHERE ActionPlanFeeModelId = @ActionPlanFeeModelId     


IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
