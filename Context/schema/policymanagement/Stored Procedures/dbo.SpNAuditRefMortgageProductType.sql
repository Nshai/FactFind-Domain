SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefMortgageProductType]
	@StampUser varchar (255),
	@RefMortgageProductTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefMortgageProductTypeAudit 
( MortgageProductType, IndigoClientId, ConcurrencyId, 
	RefMortgageProductTypeId, StampAction, StampDateTime, StampUser) 
Select MortgageProductType, IndigoClientId, ConcurrencyId, 
	RefMortgageProductTypeId, @StampAction, GetDate(), @StampUser
FROM TRefMortgageProductType
WHERE RefMortgageProductTypeId = @RefMortgageProductTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
