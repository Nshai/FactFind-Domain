SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAtrCategoryCombined]
	@StampUser varchar (255),
	@AtrCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TAtrCategoryCombinedAudit 
(Guid, AtrCategoryId, TenantId, TenantGuid, Name, IsArchived, 
	ConcurrencyId,
	StampAction, StampDateTime, StampUser)
SELECT  Guid, AtrCategoryId, TenantId, TenantGuid, Name, IsArchived, 
	ConcurrencyId,
	 @StampAction, GetDate(), @StampUser
FROM TAtrCategoryCombined
WHERE AtrCategoryId = @AtrCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
