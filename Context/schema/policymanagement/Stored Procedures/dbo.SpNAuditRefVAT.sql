SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefVAT]
	@StampUser varchar (255),
	@RefVATId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefVATAudit 
( VATName, VATRate, IsDefault, IsArchived, 
		ConcurrencyId, 
	RefVATId, StampAction, StampDateTime, StampUser) 
Select VATName, VATRate, IsDefault, IsArchived, 
		ConcurrencyId, 
	RefVATId, @StampAction, GetDate(), @StampUser
FROM TRefVAT
WHERE RefVATId = @RefVATId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
