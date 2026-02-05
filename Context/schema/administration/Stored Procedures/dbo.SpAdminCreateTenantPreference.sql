SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpAdminCreateTenantPreference]
	@TenantId bigint,
	@PreferenceName varchar(255),
	@PreferenceValue varchar(255)
AS
DECLARE @TenantGuid uniqueidentifier, @Guid uniqueidentifier, @NewId bigint
-- Get tenant GUID.
SELECT @TenantGuid = [Guid] FROM TIndigoClient WHERE IndigoClientId = @TenantId

-- Only create preference if tenant is found in this environement
IF (@TenantGuid IS NULL) 
	RETURN;
	
-- Make sure pref has not been setup already
IF EXISTS (SELECT 1 FROM TIndigoClientPreference WHERE IndigoClientId = @TenantId AND PreferenceName = @PreferenceName) 
	RETURN;
	
-- Add new preference	
SET @Guid = NEWID()

INSERT INTO TIndigoClientPreference (IndigoClientId, IndigoClientGuid, PreferenceName, Value, [Disabled], [Guid])
VALUES (@TenantId, @TenantGuid, @PreferenceName, @PreferenceValue, 0, @Guid)

SET @NewId = SCOPE_IDENTITY()
EXEC SpNAuditIndigoClientPreference 0, @NewId, 'C'

-- Add record to combined table
INSERT INTO TIndigoClientPreferenceCombined ([Guid], IndigoClientPreferenceId, IndigoClientId, IndigoClientGuid, PreferenceName, Value, [Disabled], ConcurrencyId)
VALUES (@Guid, @NewId, @TenantId, @TenantGuid, @PreferenceName, @PreferenceValue, 0, 1)
GO
