SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDoesTenantGroupExist]
      @RefTenantGroupName VARCHAR(150),
      @TenantGroupExists BIT OUTPUT
AS
BEGIN

-- This script will tell us whether this is an L&G environment.
SET @TenantGroupExists = 0

If Exists( SELECT 1 FROM TRefTenantGroup WHERE TenantGroupName LIKE @RefTenantGroupName) 
	Begin
		SET @TenantGroupExists = 1
	End
			
END
      
      