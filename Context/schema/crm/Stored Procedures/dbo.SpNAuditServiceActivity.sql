SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditServiceActivity]
    @StampUser varchar (255),
    @Id int,
    @StampAction char(1)
AS

INSERT INTO TServiceActivityAudit 
( Name, CRMContactId, StartDate, DueDate, EndDate, CreatedDate, ChangedDate, TenantId, Id,
    StampAction, StampDateTime, StampUser,TypeSystemName,ActivityStatus,StateData)
Select Name, CRMContactId, StartDate, DueDate, EndDate, CreatedDate, ChangedDate, TenantId, Id,
    @StampAction, GetDate(), @StampUser,TypeSystemName,ActivityStatus,StateData
FROM TServiceActivity
WHERE Id = @Id

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)

GO