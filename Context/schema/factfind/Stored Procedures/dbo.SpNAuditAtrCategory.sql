SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAtrCategory]
	@StampUser varchar (255),
	@AtrCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrCategoryAudit 
(Guid, TenantId, TenantGuid, Name, IsArchived, ConcurrencyId,
	AtrCategoryId, StampAction, StampDateTime, StampUser)
SELECT  Guid, TenantId, TenantGuid, Name, IsArchived, ConcurrencyId,
	AtrCategoryId, @StampAction, GetDate(), @StampUser
FROM TAtrCategory
WHERE AtrCategoryId = @AtrCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
