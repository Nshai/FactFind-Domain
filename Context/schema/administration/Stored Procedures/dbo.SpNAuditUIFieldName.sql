SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditUIFieldName]
	@StampUser varchar (255),
	@UIFieldNameId bigint,
	@StampAction char(1)
AS

INSERT INTO TUIFieldNameAudit
           (UIFieldNameId
           ,UIDomainId
           ,FieldName
           ,TenantId
           ,ConcurrencyId
           ,StampAction
           ,StampDateTime
           ,StampUser)
SELECT
           UIFieldNameId
           ,UIDomainId
           ,FieldName
           ,TenantId
           ,ConcurrencyId
           ,@StampAction, GetDate(), @StampUser
FROM TUIFieldName
WHERE UIFieldNameId = @UIFieldNameId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
