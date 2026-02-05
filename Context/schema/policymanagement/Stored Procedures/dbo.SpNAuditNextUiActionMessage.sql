SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditNextUiActionMessage]
	@StampUser varchar (255),
	@NextUiActionMessageId uniqueidentifier,
	@StampAction char(1)
AS

INSERT INTO TNextUiActionMessageAudit 
( ErrorMsg, Success, IntegratedSystemId, CustomData, 
		ProductTypeId, SagaId, IntegratedSystemAccountId, ProductTypeCode, 
		IntegratedSystemCode, CreatedDate, 
	NextUiActionMessageId, StampAction, StampDateTime, StampUser) 
Select ErrorMsg, Success, IntegratedSystemId, CustomData, 
		ProductTypeId, SagaId, IntegratedSystemAccountId, ProductTypeCode, 
		IntegratedSystemCode, CreatedDate, 
	NextUiActionMessageId, @StampAction, GetDate(), @StampUser
FROM TNextUiActionMessage
WHERE NextUiActionMessageId = @NextUiActionMessageId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
