SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditActivityCategoryHidden]
	@StampUser varchar (255),
	@ActivityCategoryHiddenId bigint,
	@StampAction char(1)
AS

INSERT INTO TActivityCategoryHiddenAudit 
( ActivityCategoryId, GroupId, TenantId, ConcurrencyId, 
		
	ActivityCategoryHiddenId, StampAction, StampDateTime, StampUser) 
Select ActivityCategoryId, GroupId, TenantId, ConcurrencyId, 
		
	ActivityCategoryHiddenId, @StampAction, GetDate(), @StampUser
FROM TActivityCategoryHidden
WHERE ActivityCategoryHiddenId = @ActivityCategoryHiddenId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
