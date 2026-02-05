SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefContactType]
	@StampUser varchar (255),
	@RefContactTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefContactTypeAudit 
( ContactTypeName, ArchiveFG, ConcurrencyId, 
	RefContactTypeId, StampAction, StampDateTime, StampUser) 
Select ContactTypeName, ArchiveFG, ConcurrencyId, 
	RefContactTypeId, @StampAction, GetDate(), @StampUser
FROM TRefContactType
WHERE RefContactTypeId = @RefContactTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
