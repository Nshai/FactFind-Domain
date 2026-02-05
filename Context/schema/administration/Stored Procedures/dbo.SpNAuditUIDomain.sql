SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditUIDomain]
	@StampUser varchar (255),
	@UIDomainId bigint,
	@StampAction char(1)
AS

INSERT INTO TUIDomainAudit
           (UIDomainId
           ,DomainName
           ,TenantId
           ,ConcurrencyId
           ,StampAction
           ,StampDateTime
           ,StampUser)
SELECT
           UIDomainId
           ,DomainName
           ,TenantId
           ,ConcurrencyId
           ,@StampAction, GetDate(), @StampUser
FROM TUIDomain
WHERE UIDomainId = @UIDomainId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
