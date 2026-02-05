SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpAdminDeleteTenantPreference]
	@TenantId bigint,
	@PreferenceName varchar(255)	
AS
DECLARE @Guid uniqueidentifier, @Id bigint

-- Try to find existing preference
SELECT @Guid = [Guid], @Id = IndigoClientPreferenceId
FROM TIndigoClientPreference
WHERE IndigoClientId = @TenantId AND PreferenceName = @PreferenceName

-- If the preference has not been found then exit.
IF (@Guid IS NULL) 
	RETURN;

-- Audit and delete.	
EXEC SpNAuditIndigoClientPreference 0, @Id, 'D'
DELETE FROM TIndigoClientPreference WHERE [Guid] = @Guid
DELETE FROM TIndigoClientPreferenceCombined WHERE [Guid] = @Guid
GO
