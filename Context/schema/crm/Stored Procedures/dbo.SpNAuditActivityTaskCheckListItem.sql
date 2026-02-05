SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditActivityTaskCheckListItem]
    @StampUser varchar (255),
    @Id int,
    @StampAction char(1)
AS

INSERT INTO TActivityTaskCheckListItemAudit 
( ActivityTaskCheckListItemId, CheckListItemId, TaskId, ActivityCategoryId, IsCompleted,
    IndigoClientId, CompletedAt, CompletedBy, UpdatedAt, UpdatedBy,
    StampAction,StampDateTime,StampUser)
Select ActivityTaskCheckListItemId, CheckListItemId, TaskId, ActivityCategoryId, IsCompleted,
    IndigoClientId, CompletedAt, CompletedBy, UpdatedAt, UpdatedBy,
    @StampAction, GetDate(), @StampUser
FROM TActivityTaskCheckListItem
WHERE ActivityTaskCheckListItemId = @Id

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)

GO