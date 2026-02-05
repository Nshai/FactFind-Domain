SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:        Siarhei Salokha
-- Create date:   31/05/2022
-- Description:   Stored procedure for getting list of groups by tenantId
-- =============================================
CREATE PROCEDURE [dbo].spListGroupsByTenantIdQuery
    @tenantId INT
AS
BEGIN
    SELECT
        GroupId,
        Identifier AS Identifier,
        IndigoClientId AS TenantId,
        CRMContactId AS PartyId
    FROM administration.dbo.TGroup
    WHERE IndigoClientId = @tenantId
    ORDER BY Identifier
END