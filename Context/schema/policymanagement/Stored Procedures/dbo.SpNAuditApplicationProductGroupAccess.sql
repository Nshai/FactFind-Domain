SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditApplicationProductGroupAccess]
	@StampUser varchar (255),
	@ApplicationProductGroupAccessId bigint,
	@StampAction char(1)
AS

INSERT INTO TApplicationProductGroupAccessAudit 
( ApplicationLinkId, RefProductGroupId, AllowAccess, ConcurrencyId, 
		
	ApplicationProductGroupAccessId, StampAction, StampDateTime, StampUser) 
Select ApplicationLinkId, RefProductGroupId, AllowAccess, ConcurrencyId, 
		
	ApplicationProductGroupAccessId, @StampAction, GetDate(), @StampUser
FROM TApplicationProductGroupAccess
WHERE ApplicationProductGroupAccessId = @ApplicationProductGroupAccessId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
