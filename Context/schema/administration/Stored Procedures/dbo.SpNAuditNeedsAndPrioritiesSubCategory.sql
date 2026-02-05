SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditNeedsAndPrioritiesSubCategory]
	@StampUser varchar (255),
	@NeedsAndPrioritiesSubCategoryId bigint,
	@StampAction char(1)
AS
INSERT INTO [TNeedsAndPrioritiesSubCategoryAudit] (
	ConcurrencyId, Name, TenantId, [Ordinal], NeedsAndPrioritiesSubCategoryId, StampAction, StampDateTime, StampUser)
SELECT
	ConcurrencyId, Name, TenantId, [Ordinal], NeedsAndPrioritiesSubCategoryId, @StampAction, GETDATE(), @StampUser
FROM 
	[TNeedsAndPrioritiesSubCategory]
WHERE 
	[NeedsAndPrioritiesSubCategoryId] = @NeedsAndPrioritiesSubCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
