SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCreateAtrCategoryCombined]
	@StampUser varchar(255),
	@Guid uniqueidentifier
AS	
-- Add record to combined table.
INSERT INTO TAtrCategoryCombined ([Guid], AtrCategoryId, TenantId, TenantGuid, Name, IsArchived, ConcurrencyId)
SELECT [Guid], AtrCategoryId, TenantId, TenantGuid, Name, IsArchived, ConcurrencyId
FROM TAtrCategory
WHERE [Guid] = @Guid

-- Audit 
INSERT INTO TAtrCategoryCombinedAudit ([Guid], AtrCategoryId, TenantId, TenantGuid, Name, IsArchived, ConcurrencyId, StampAction, StampDateTime, StampUser)
SELECT Guid, AtrCategoryId, TenantId, TenantGuid, Name, IsArchived, ConcurrencyId, 'C', GETDATE(), @StampUser
FROM TAtrCategory
WHERE [Guid] = @Guid
GO
