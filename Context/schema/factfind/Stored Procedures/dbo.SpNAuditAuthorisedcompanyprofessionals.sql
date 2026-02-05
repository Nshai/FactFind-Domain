SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAuthorisedcompanyprofessionals]
	@StampUser varchar (255),
	@AuthorisedcompanyprofessionalsId bigint,
	@StampAction char(1)
AS

INSERT INTO TAuthorisedcompanyprofessionalsAudit 
( CRMContactId, Name, Position, ConcurrencyId, 
		
	AuthorisedcompanyprofessionalsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Name, Position, ConcurrencyId, 
		
	AuthorisedcompanyprofessionalsId, @StampAction, GetDate(), @StampUser
FROM TAuthorisedcompanyprofessionals
WHERE AuthorisedcompanyprofessionalsId = @AuthorisedcompanyprofessionalsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
