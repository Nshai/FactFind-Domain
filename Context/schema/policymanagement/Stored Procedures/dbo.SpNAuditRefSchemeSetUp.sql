SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefSchemeSetUp]
	@StampUser varchar (255),
	@RefSchemeSetUpId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefSchemeSetUpAudit 
( Descriptor, ArchiveFG, DPMapping, IndigoClientId, 
		ConcurrencyId, 
	RefSchemeSetUpId, StampAction, StampDateTime, StampUser) 
Select Descriptor, ArchiveFG, DPMapping, IndigoClientId, 
		ConcurrencyId, 
	RefSchemeSetUpId, @StampAction, GetDate(), @StampUser
FROM TRefSchemeSetUp
WHERE RefSchemeSetUpId = @RefSchemeSetUpId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
