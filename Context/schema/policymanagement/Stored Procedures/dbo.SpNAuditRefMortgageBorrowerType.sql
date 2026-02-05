SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefMortgageBorrowerType]
	@StampUser varchar (255),
	@RefMortgageBorrowerTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefMortgageBorrowerTypeAudit 
( MortgageBorrowerType, ConcurrencyId, 
	RefMortgageBorrowerTypeId, StampAction, StampDateTime, StampUser) 
Select MortgageBorrowerType, ConcurrencyId, 
	RefMortgageBorrowerTypeId, @StampAction, GetDate(), @StampUser
FROM TRefMortgageBorrowerType
WHERE RefMortgageBorrowerTypeId = @RefMortgageBorrowerTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
