SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomListTenantAndLegalEntityPreferences]
	@TenantId bigint,
	@UserId bigint
AS		

DECLARE @GroupId AS INT

SET @GroupId = dbo.FnGetLegalEntityIdForUser(@UserId)

SELECT
	PreferenceName,
	[Value]
FROM
	TIndigoClientPreference
WHERE
	IndigoClientId = @TenantId

UNION ALL
SELECT
	PreferenceName,
	PreferenceValue
FROM
	TLegalEntityPreference
WHERE
	GroupId = @GroupId
			
GO
