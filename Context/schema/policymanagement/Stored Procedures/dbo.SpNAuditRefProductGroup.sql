SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefProductGroup]
	@StampUser varchar (255),
	@RefProductGroupId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefProductGroupAudit 
( ProductGroupName, IsArchived, ConcurrencyId, 
	RefProductGroupId, StampAction, StampDateTime, StampUser) 
Select ProductGroupName, IsArchived, ConcurrencyId, 
	RefProductGroupId, @StampAction, GetDate(), @StampUser
FROM TRefProductGroup
WHERE RefProductGroupId = @RefProductGroupId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
