USE [administration]
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[spListGroupLineageByGroupIdQuery]
    @TenantId INT,
    @GroupId BIGINT

AS
BEGIN

    WITH GroupHierarchy (GroupId, Identifier, ParentId, IndigoClientId, DefaultClientGroupId, Sort) AS
    (
        SELECT
            GroupId,
            Identifier,
            ParentId,
            IndigoClientId,
            DefaultClientGroupId,
            1 AS [Sort]
        FROM administration.dbo.TGroup
        WHERE GroupId = @GroupId AND IndigoClientId = @TenantId
        UNION ALL
        SELECT
            grp.GroupId,
            grp.Identifier,
            grp.ParentId,
            grp.IndigoClientId,
            grp.DefaultClientGroupId,
            d.Sort + 1 AS [Sort]
        FROM administration.dbo.TGroup AS [grp]
        INNER JOIN GroupHierarchy AS [d] ON grp.GroupId = d.ParentId
    )
    SELECT
        GroupId,
        ParentId,
        DefaultClientGroupId
    FROM
        GroupHierarchy
    ORDER BY Sort DESC
    OPTION (MAXRECURSION 10)

END

GO