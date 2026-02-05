SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditFeeModelTemplateToAdvisePaymentType]
	@StampUser varchar (255),
	@FeeModelTemplateToAdvisePaymentTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TFeeModelTemplateToAdvisePaymentTypeAudit 
( FeeModelTemplateId, AdvisePaymentTypeId, TenantId, ConcurrencyId, 
		
	FeeModelTemplateToAdvisePaymentTypeId, StampAction, StampDateTime, StampUser) 
Select FeeModelTemplateId, AdvisePaymentTypeId, TenantId, ConcurrencyId, 
		
	FeeModelTemplateToAdvisePaymentTypeId, @StampAction, GetDate(), @StampUser
FROM TFeeModelTemplateToAdvisePaymentType
WHERE FeeModelTemplateToAdvisePaymentTypeId = @FeeModelTemplateToAdvisePaymentTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
