SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditActivityCheckListItem]
    @StampUser varchar (255),
    @Id int,
    @StampAction char(1)
AS

INSERT INTO TActivityCheckListItemAudit 
( ActivityCheckListItemId, CheckListItemId, ActivityCategoryId, IndigoClientId, Ordinal, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy,
    StampAction,StampDateTime,StampUser)
Select ActivityCheckListItemId, CheckListItemId, ActivityCategoryId, IndigoClientId, Ordinal, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy,
    @StampAction, GetDate(), @StampUser
FROM TActivityCheckListItem
WHERE ActivityCheckListItemId = @Id

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)

GO  