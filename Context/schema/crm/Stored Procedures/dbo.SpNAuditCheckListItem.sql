SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCheckListItem]
    @StampUser varchar (255),
    @Id int,
    @StampAction char(1)
AS

INSERT INTO TChecklistItemAudit 
( IndigoClientId, GroupId, Name, IsArchived, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy, CheckListItemId,
    StampAction,StampDateTime,StampUser)
Select IndigoClientId, GroupId, Name, IsArchived, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy, CheckListItemId,
    @StampAction, GetDate(), @StampUser
FROM TChecklistItem
WHERE ChecklistItemId = @Id

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)

GO