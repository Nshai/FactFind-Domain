SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditFeeModelTemplateToDiscount]
	@StampUser varchar (255),
	@FeeModelTemplateToDiscountId bigint,
	@StampAction char(1)
AS

INSERT INTO TFeeModelTemplateToDiscountAudit 
( FeeModelTemplateId, DiscountId, TenantId, ConcurrencyId, 
		
	FeeModelTemplateToDiscountId, StampAction, StampDateTime, StampUser) 
Select FeeModelTemplateId, DiscountId, TenantId, ConcurrencyId, 
		
	FeeModelTemplateToDiscountId, @StampAction, GetDate(), @StampUser
FROM TFeeModelTemplateToDiscount
WHERE FeeModelTemplateToDiscountId = @FeeModelTemplateToDiscountId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
