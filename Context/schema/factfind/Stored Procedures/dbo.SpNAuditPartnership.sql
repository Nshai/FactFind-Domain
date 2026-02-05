SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPartnership]
	@StampUser varchar (255),
	@PartnershipId bigint,
	@StampAction char(1)
AS

INSERT INTO TPartnershipAudit 
( CRMContactId, OtherEmployeesToBeProtected, ConcurrencyId, 
	PartnershipId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, OtherEmployeesToBeProtected, ConcurrencyId, 
	PartnershipId, @StampAction, GetDate(), @StampUser
FROM TPartnership
WHERE PartnershipId = @PartnershipId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
