SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnCustomGetUserPreference](@UserId bigint, @PreferenceName varchar(255))
RETURNS varchar(255)
AS
BEGIN
RETURN (
	SELECT 
		PreferenceValue 
	FROM 
		TUserPreference
	WHERE 
		UserId = @UserId 
		AND PreferenceName = @PreferenceName
)
END
GO
