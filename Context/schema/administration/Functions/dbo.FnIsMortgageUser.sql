SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION FnIsMortgageUser(@UserId bigint)
RETURNS bit
AS
BEGIN
DECLARE @LicenseType tinyint, @IsMortgageUser bit
-- Assume not a mortgage user
SET @IsMortgageUser = 0

-- get license type for active role
SELECT @LicenseType = R.RefLicenseTypeId
FROM	
	Administration..TUser U
	JOIN Administration..TRole R ON R.RoleId = U.ActiveRole
WHERE
	U.UserId = @UserId

-- 2 = Mortgage
IF @LicenseType IN (2)
	SET @IsMortgageUser = 1

RETURN @IsMortgageUser	
END