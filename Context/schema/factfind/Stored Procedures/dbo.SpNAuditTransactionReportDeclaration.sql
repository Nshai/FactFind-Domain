SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditTransactionReportDeclaration]
	@StampUser varchar (255),
	@TransactionReportDeclarationId bigint,
	@StampAction char(1)
AS

INSERT INTO TTransactionReportDeclarationAudit 
( TenantId, Declaration, 
	TransactionReportDeclarationId, StampAction, StampDateTime, StampUser) 
Select TenantId, Declaration, 
	TransactionReportDeclarationId, @StampAction, GetDate(), @StampUser
FROM TTransactionReportDeclaration
WHERE TransactionReportDeclarationId = @TransactionReportDeclarationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
