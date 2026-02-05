SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefCoverType]
	@StampUser varchar (255),
	@RefCoverTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefCoverTypeAudit 
( Descriptor, ArchiveFG, IndigoClientId, ConcurrencyId, 
		
	RefCoverTypeId, StampAction, StampDateTime, StampUser) 
Select Descriptor, ArchiveFG, IndigoClientId, ConcurrencyId, 
		
	RefCoverTypeId, @StampAction, GetDate(), @StampUser
FROM TRefCoverType
WHERE RefCoverTypeId = @RefCoverTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
