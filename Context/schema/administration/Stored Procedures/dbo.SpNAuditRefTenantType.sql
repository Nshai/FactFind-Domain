SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefTenantType]
	@StampUser varchar (255),
	@RefTenantTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefTenantTypeAudit 
( Name,
	RefTenantTypeId, StampAction, StampDateTime, StampUser) 
Select Name, 
	RefTenantTypeId, @StampAction, GetDate(), @StampUser
FROM TRefTenantType
WHERE RefTenantTypeId = @RefTenantTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO