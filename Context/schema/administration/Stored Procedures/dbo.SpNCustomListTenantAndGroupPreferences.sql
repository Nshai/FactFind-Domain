SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomListTenantAndGroupPreferences]
	@TenantId int,
	@UserId int,
	@ClientId int
AS

DECLARE @LegalEntityId int = dbo.FnGetLegalEntityIdForUser(@UserId)

--------------------------------------------
-- Get tenant preferences
--------------------------------------------
SELECT PreferenceName, [Value]
INTO #Prefs
FROM TIndigoClientPreference
WHERE IndigoClientId = @TenantId

--------------------------------------------
-- Get legal entity preferences (for the logged on user)
--------------------------------------------
INSERT INTO #Prefs
SELECT PreferenceName, PreferenceValue
FROM TLegalEntityPreference
WHERE GroupId = @LegalEntityId AND PreferenceName LIKE 'FactFindRemove%'

--------------------------------------------
-- Walk the group hierarchy to find any prefs
-- for the client's servicing adviser
--------------------------------------------
IF NOT EXISTS (SELECT 1 FROM #Prefs WHERE PreferenceName = 'FactFindUseGroupPreferences' AND Value = 'True') BEGIN
	SELECT * FROM #Prefs
	RETURN;
END

-- Find group id for the client's servicing adviser
DECLARE @GroupId int
SELECT @GroupId = U.GroupId 
FROM CRM..TCRMContact A JOIN TUser U ON U.CRMContactId = A.CurrentAdviserCRMId
WHERE A.CRMContactId = @ClientId AND A.IndClientId = @TenantId

;WITH Groups (GroupId, ParentId, [Level])
AS (
	SELECT GroupId, ParentId, 1 AS [Level]
	FROM TGroup
	WHERE GroupId = @GroupId

	UNION ALL
	SELECT Parent.GroupId, Parent.ParentId, [Level] + 1
	FROM 
		Groups Child
		JOIN TGroup Parent on Parent.GroupId = Child.ParentId
	WHERE [Level] < 10
)
INSERT INTO #Prefs
SELECT DISTINCT A.PreferenceName, A.PreferenceValue
FROM
	TLegalEntityPreference A
	JOIN Groups ON Groups.GroupId = A.GroupId
	LEFT JOIN #Prefs ON #Prefs.PreferenceName = A.PreferenceName
WHERE
	A.PreferenceName LIKE 'FactFindRemove%' -- just catering for hiding content right now
	AND #Prefs.PreferenceName IS NULL -- make sure the pref does not already exist in our list
	AND Groups.ParentId IS NOT NULL -- ignore top level (effectively that should be a tenant preference)

SELECT * FROM #Prefs
GO
