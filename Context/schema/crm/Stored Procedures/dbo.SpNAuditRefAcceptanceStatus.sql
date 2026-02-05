SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefAcceptanceStatus]
	@StampUser varchar (255),
	@RefAcceptanceStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefAcceptanceStatusAudit 
( Description, ShowTimeAs, ConcurrencyId, 
	RefAcceptanceStatusId, StampAction, StampDateTime, StampUser) 
Select Description, ShowTimeAs, ConcurrencyId, 
	RefAcceptanceStatusId, @StampAction, GetDate(), @StampUser
FROM TRefAcceptanceStatus
WHERE RefAcceptanceStatusId = @RefAcceptanceStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
