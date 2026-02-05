SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnCustomTenantHasPreference](
	@TenantId bigint,
	@PreferenceName varchar(255),
	@PreferenceValue varchar(255))
RETURNS bit
AS
BEGIN
	IF EXISTS (
		SELECT 1 
		FROM TIndigoClientPreference 
		WHERE 
			IndigoClientId = @TenantId
			AND PreferenceName = @PreferenceName
			AND Value = @PreferenceValue)
		RETURN 1;

	RETURN 0;
END
GO
