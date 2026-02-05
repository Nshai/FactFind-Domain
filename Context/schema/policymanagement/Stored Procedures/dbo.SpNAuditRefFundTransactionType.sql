SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefFundTransactionType]
	@StampUser varchar (255),
	@RefFundTransactionTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefFundTransactionTypeAudit 
( Description, ConcurrencyId, 
	RefFundTransactionTypeId, StampAction, StampDateTime, StampUser) 
Select Description, ConcurrencyId, 
	RefFundTransactionTypeId, @StampAction, GetDate(), @StampUser
FROM TRefFundTransactionType
WHERE RefFundTransactionTypeId = @RefFundTransactionTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
