SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRepossession]
	@StampUser varchar (255),
	@RepossessionId bigint,
	@StampAction char(1)
AS

INSERT INTO TRepossessionAudit 
( CRMContactId, repDate, repLenderName, repDebt, 
		repApp1, repApp2, ConcurrencyId, 
	RepossessionId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, repDate, repLenderName, repDebt, 
		repApp1, repApp2, ConcurrencyId, 
	RepossessionId, @StampAction, GetDate(), @StampUser
FROM TRepossession
WHERE RepossessionId = @RepossessionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
