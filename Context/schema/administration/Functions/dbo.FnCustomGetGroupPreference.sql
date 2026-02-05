SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnCustomGetGroupPreference](@GroupId bigint, @PreferenceName varchar(255))
RETURNS varchar(255)
AS
BEGIN
RETURN (
	SELECT 
		PreferenceValue 
	FROM 
		TLegalEntityPreference
	WHERE 
		GroupId = @GroupId 
		AND PreferenceName = @PreferenceName
)
END
GO
