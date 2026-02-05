SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefApplicationType]
	@StampUser varchar (255),
	@RefApplicationTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefApplicationTypeAudit 
( ApplicationTypeName, IsArchived, ConcurrencyId, 
	RefApplicationTypeId, StampAction, StampDateTime, StampUser) 
Select ApplicationTypeName, IsArchived, ConcurrencyId, 
	RefApplicationTypeId, @StampAction, GetDate(), @StampUser
FROM TRefApplicationType
WHERE RefApplicationTypeId = @RefApplicationTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
