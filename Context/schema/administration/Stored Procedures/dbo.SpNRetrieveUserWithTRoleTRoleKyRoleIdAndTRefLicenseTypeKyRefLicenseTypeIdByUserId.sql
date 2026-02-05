SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveUserWithTRoleTRoleKyRoleIdAndTRefLicenseTypeKyRefLicenseTypeIdByUserId]
	@UserId bigint
AS

Select * 
From Administration.dbo.TUser As [User]
Inner Join Administration.dbo.TRole As [Role]
	On [User].ActiveRole = [Role].RoleId
Inner Join Administration.dbo.TRefLicenseType As [RefLicenseType]
	On [Role].RefLicenseTypeId = [RefLicenseType].RefLicenseTypeId
Where [User].UserId = @UserId
GO
