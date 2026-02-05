SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditFeeModelTemplateToPlanType]
	@StampUser varchar (255),
	@FeeModelTemplateToPlanTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TFeeModelTemplateToPlanTypeAudit 
( FeeModelTemplateId, RefPlanTypeId, TenantId, ConcurrencyId, 
		
	FeeModelTemplateToPlanTypeId, StampAction, StampDateTime, StampUser) 
Select FeeModelTemplateId, RefPlanTypeId, TenantId, ConcurrencyId, 
		
	FeeModelTemplateToPlanTypeId, @StampAction, GetDate(), @StampUser
FROM TFeeModelTemplateToPlanType
WHERE FeeModelTemplateToPlanTypeId = @FeeModelTemplateToPlanTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
