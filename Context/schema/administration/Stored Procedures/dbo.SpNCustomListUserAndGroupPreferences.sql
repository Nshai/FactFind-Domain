SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomListUserAndGroupPreferences]
	@UserId bigint
AS		
SELECT
	PreferenceName,
	PreferenceValue AS [Value]
FROM
	TUserPreference
WHERE
	UserId = @UserId

UNION ALL
SELECT
	PreferenceName,
	PreferenceValue
FROM
	TUser U	
	JOIN TLegalEntityPreference G ON G.GroupId = U.GroupId
WHERE
	U.UserId = @UserId			
GO
