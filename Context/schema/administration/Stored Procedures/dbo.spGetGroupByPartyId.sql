SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:        Alesia Buyalskaya
-- Create date:   05/07/2021
-- Description:   Stored procedure for getting group by partyId
-- =============================================
CREATE PROCEDURE [dbo].[spGetGroupByPartyIdQuery]
    @partyId INT,
    @tenantId INT
AS
BEGIN
    SELECT
        TGroup.GroupId,
        TGroup.Identifier,
        TGroup.CRMContactId AS PartyId,
        TGroup.IndigoClientId as TenantId,
        TGroup.LegalEntity
    FROM administration.dbo.TGroup
    WHERE TGroup.CRMContactId = @partyId AND TGroup.IndigoClientId = @tenantId
END
GO
