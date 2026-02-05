SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditClub]
	@StampUser varchar (255),
	@ClubId bigint,
	@StampAction char(1)
AS

INSERT INTO TClubAudit 
( CRMContactId, OtherEmployeesToBeProtected, ConcurrencyId, 
	ClubId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, OtherEmployeesToBeProtected, ConcurrencyId, 
	ClubId, @StampAction, GetDate(), @StampUser
FROM TClub
WHERE ClubId = @ClubId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
