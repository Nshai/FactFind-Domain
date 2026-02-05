SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditMember]
	@StampUser varchar (255),
	@MemberId bigint,
	@StampAction char(1)
AS

INSERT INTO TMemberAudit 
( PolicyBusinessId, CRMContactId, ConcurrencyId, 
	MemberId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, CRMContactId, ConcurrencyId, 
	MemberId, @StampAction, GetDate(), @StampUser
FROM TMember
WHERE MemberId = @MemberId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
