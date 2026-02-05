SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditTag]
	@StampUser varchar (255),
	@TagId bigint,
	@StampAction char(1)
AS

INSERT INTO TTagAudit 
(TagId,EntityType,EntityId,  Name,TenantId, CreatedTimeStamp, StampAction, StampDateTime, StampUser) 
SELECT 
TagId, EntityType, EntityId, Name,TenantId, CreatedTimeStamp, @StampAction, GetDate(), @StampUser
FROM TTag
WHERE TagId = @TagId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO

