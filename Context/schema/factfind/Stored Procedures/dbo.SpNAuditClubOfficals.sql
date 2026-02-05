SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditClubOfficals]
	@StampUser varchar (255),
	@ClubOfficalsId bigint,
	@StampAction char(1)
AS

INSERT INTO TClubOfficalsAudit 
( CRMContactId, ClubOfficialName, ClubOfficialRole, DOB, 
		SmokerYesNo, GoodHealth, ConcurrencyId, 
	ClubOfficalsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, ClubOfficialName, ClubOfficialRole, DOB, 
		SmokerYesNo, GoodHealth, ConcurrencyId, 
	ClubOfficalsId, @StampAction, GetDate(), @StampUser
FROM TClubOfficals
WHERE ClubOfficalsId = @ClubOfficalsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
