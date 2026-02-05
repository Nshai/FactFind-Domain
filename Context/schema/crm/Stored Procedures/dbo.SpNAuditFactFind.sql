SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFactFind]
	@StampUser varchar (255),
	@FactFindId bigint,
	@StampAction char(1)
AS

INSERT INTO TFactFindAudit 
( DocumentId, LatestDocVerId, VersionDate, CreatedByUserId, 
		ConcurrencyId, 
	FactFindId, StampAction, StampDateTime, StampUser) 
Select DocumentId, LatestDocVerId, VersionDate, CreatedByUserId, 
		ConcurrencyId, 
	FactFindId, @StampAction, GetDate(), @StampUser
FROM TFactFind
WHERE FactFindId = @FactFindId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
