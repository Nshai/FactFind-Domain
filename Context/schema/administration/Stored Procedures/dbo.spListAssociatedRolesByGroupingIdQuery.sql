SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:        Siarhei Salokha
-- Create date:   31/05/2022
-- Description:   Stored procedure for getting list of associated roles by grouping id.
-- =============================================
CREATE PROCEDURE [dbo].[spListAssociatedRolesByGroupingIdQuery]
    @groupingId INT,
    @tenantId INT
AS
BEGIN
    SELECT
        TR.RoleId AS Id,
        TR.RefLicenseTypeId AS RefLicenseTypeId,
        TR.Identifier AS [Name]
    FROM administration.dbo.TRole AS TR
    WHERE TR.IndigoClientId = @tenantId AND TR.GroupingId = @groupingId
END
GO