CREATE PROCEDURE [dbo].[spGetIndigoClientPreferenceByName]
@PreferenceName VARCHAR(50),
@TenantId INT
AS
SELECT [Value]
	FROM TIndigoClientPreference
	WHERE IndigoClientId = @TenantId
	AND PreferenceName = @PreferenceName