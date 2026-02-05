SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefMortgageRepaymentMethod]
	@StampUser varchar (255),
	@RefMortgageRepaymentMethodId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefMortgageRepaymentMethodAudit 
( MortgageRepaymentMethod, IndigoClientId, ConcurrencyId, 
	RefMortgageRepaymentMethodId, StampAction, StampDateTime, StampUser) 
Select MortgageRepaymentMethod, IndigoClientId, ConcurrencyId, 
	RefMortgageRepaymentMethodId, @StampAction, GetDate(), @StampUser
FROM TRefMortgageRepaymentMethod
WHERE RefMortgageRepaymentMethodId = @RefMortgageRepaymentMethodId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
