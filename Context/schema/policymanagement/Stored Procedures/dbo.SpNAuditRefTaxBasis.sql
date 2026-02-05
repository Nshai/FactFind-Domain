SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefTaxBasis]
	@StampUser varchar (255),
	@RefTaxBasisId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefTaxBasisAudit 
( RefTaxBasisName, RetireFg, ConcurrencyId, 
	RefTaxBasisId, StampAction, StampDateTime, StampUser) 
Select RefTaxBasisName, RetireFg, ConcurrencyId, 
	RefTaxBasisId, @StampAction, GetDate(), @StampUser
FROM TRefTaxBasis
WHERE RefTaxBasisId = @RefTaxBasisId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
