CREATE PROCEDURE [dbo].[spListIncomeSettings] 
			@TenantId INT,
			@PreferencesNames VARCHAR(100)
AS

SELECT
	IndigoClientPreferenceId AS 'Id',
	IndigoClientId AS 'TenantId',
	PreferenceName,
	Value
FROM [dbo].[TIndigoClientPreference] WITH(NOLOCK)
WHERE
	IndigoClientId = @TenantId AND
	(@PreferencesNames IS NOT NULL AND PreferenceName IN (SELECT value FROM STRING_SPLIT(@PreferencesNames, ',')))
