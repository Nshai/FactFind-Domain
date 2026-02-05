SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:        Alesia Buyalskaya
-- Create date:   22/05/2020
-- Description:   Stored procedure for getting user by partyId
-- =============================================
CREATE PROCEDURE [dbo].[spGetUserByPartyIdQuery]
    @partyId INT,
    @tenantId INT
AS
BEGIN
    SELECT
        TU.UserId AS Id,
        TU.CRMContactId AS PartyId,
        TU.Guid AS Subject,
        TU.IndigoClientId as TenantId,
        TU.Is2faEnabled,
        TU.SuperUser AS IsSuperUser,
        TU.GroupId AS GroupId,
        TGP.GroupingId AS GroupingId,
        TU.ActiveRole AS ActiveRoleId,
        TC.FirstName + ' ' + TC.LastName AS UserName
    FROM administration.dbo.TUser AS TU
    INNER JOIN administration.dbo.TGroup AS TG ON TU.GroupId = TG.GroupId
    INNER JOIN administration.dbo.TGrouping AS TGP ON TG.GroupingId = TGP.GroupingId
    INNER JOIN crm.dbo.TCRMContact AS TC on TU.CRMContactId = TC.CRMContactId
    WHERE TU.IndigoClientId = @tenantId AND TU.CRMContactId = @partyId
END
GO