SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditActivityCategoryParent]
	@StampUser varchar (255),
	@ActivityCategoryParentId bigint,
	@StampAction char(1)
AS
INSERT INTO TActivityCategoryParentAudit 
( Name, IndigoClientId, ConcurrencyId, 
	ActivityCategoryParentId, StampAction, StampDateTime, StampUser,IsArchived) 
Select Name, IndigoClientId, ConcurrencyId, 
	ActivityCategoryParentId, @StampAction, GetDate(), @StampUser,IsArchived
FROM TActivityCategoryParent
WHERE ActivityCategoryParentId = @ActivityCategoryParentId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
