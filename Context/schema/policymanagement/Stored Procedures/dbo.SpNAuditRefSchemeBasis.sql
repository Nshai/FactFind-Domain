SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefSchemeBasis]
	@StampUser varchar (255),
	@RefSchemeBasisId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefSchemeBasisAudit 
( Descriptor, ArchiveFG, DPMapping, IndigoClientId, 
		ConcurrencyId, 
	RefSchemeBasisId, StampAction, StampDateTime, StampUser) 
Select Descriptor, ArchiveFG, DPMapping, IndigoClientId, 
		ConcurrencyId, 
	RefSchemeBasisId, @StampAction, GetDate(), @StampUser
FROM TRefSchemeBasis
WHERE RefSchemeBasisId = @RefSchemeBasisId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
