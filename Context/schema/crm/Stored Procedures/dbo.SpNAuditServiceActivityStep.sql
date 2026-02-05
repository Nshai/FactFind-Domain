SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditServiceActivityStep]
    @StampUser varchar (255),
    @Id int,
    @StampAction char(1)
AS

INSERT INTO TServiceActivityStepAudit 
(ServiceActivityId, Name, DisplayName, Href, Status, StartedAt, LastUpdatedAt, LastUpdatedBy, CompletedAt,CompletedBy,
StampAction, StampDateTime, StampUser)
Select ServiceActivityId, Name, DisplayName, Href, Status, StartedAt, LastUpdatedAt, LastUpdatedBy, CompletedAt,CompletedBy,
@StampAction, GetDate(), @StampUser
FROM TServiceActivityStep
WHERE Id = @Id

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)

GO