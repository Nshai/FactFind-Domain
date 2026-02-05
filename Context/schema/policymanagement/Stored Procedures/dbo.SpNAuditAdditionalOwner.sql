SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAdditionalOwner]
	@StampUser varchar (255),
	@AdditionalOwnerId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdditionalOwnerAudit 
( PolicyBusinessId, CRMContactId, ConcurrencyId, 
	AdditionalOwnerId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, CRMContactId, ConcurrencyId, 
	AdditionalOwnerId, @StampAction, GetDate(), @StampUser
FROM TAdditionalOwner
WHERE AdditionalOwnerId = @AdditionalOwnerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
