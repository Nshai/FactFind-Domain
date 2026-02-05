SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefMortgageSaleType]
	@StampUser varchar (255),
	@RefMortgageSaleTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefMortgageSaleTypeAudit 
( MortgageSaleType, ConcurrencyId, 
	RefMortgageSaleTypeId, StampAction, StampDateTime, StampUser) 
Select MortgageSaleType, ConcurrencyId, 
	RefMortgageSaleTypeId, @StampAction, GetDate(), @StampUser
FROM TRefMortgageSaleType
WHERE RefMortgageSaleTypeId = @RefMortgageSaleTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
