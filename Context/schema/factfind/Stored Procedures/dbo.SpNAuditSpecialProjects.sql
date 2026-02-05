SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditSpecialProjects]
	@StampUser varchar (255),
	@SpecialProjectsId bigint,
	@StampAction char(1)
AS

INSERT INTO TSpecialProjectsAudit 
( CRMContactId, SpecialProjectsYesNo, FuturePlans, Notes, 
		ConcurrencyId, 
	SpecialProjectsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, SpecialProjectsYesNo, FuturePlans, Notes, 
		ConcurrencyId, 
	SpecialProjectsId, @StampAction, GetDate(), @StampUser
FROM TSpecialProjects
WHERE SpecialProjectsId = @SpecialProjectsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
