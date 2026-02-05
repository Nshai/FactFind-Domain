SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:        Siarhei Salokha
-- Create date:   31/05/2022
-- Description:   Stored procedure for getting of grouping by grouping id.
-- =============================================
CREATE PROCEDURE [dbo].spGetGroupingByIdQuery
    @groupingId INT,
    @tenantId INT
AS
BEGIN
    SELECT
        TGP.GroupingId AS Id,
        TGP.Identifier AS [Name],
        TGP.ParentId AS ParentId
    FROM administration.dbo.TGrouping AS TGP
    WHERE TGP.IndigoClientId = @tenantId AND TGP.GroupingId = @groupingId
END
GO