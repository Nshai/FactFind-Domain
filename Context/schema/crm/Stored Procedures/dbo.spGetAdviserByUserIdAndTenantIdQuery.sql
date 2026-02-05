SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ==================================================
-- Description: Gets adviser by PartyId and TenantId
-- ==================================================
CREATE PROCEDURE [dbo].[spGetAdviserByUserIdAndTenantIdQuery]
    @userId INT,
    @tenantId INT
AS

BEGIN
    SELECT tp.PractitionerId AS Id,
	       (CASE WHEN tc.FirstName IS NULL THEN '' ELSE tc.FirstName  END
           + CASE WHEN tc.LastName IS NULL THEN '' ELSE + N' ' + tc.LastName  END) AS [AdviserName],
           tp.AuthorisedFG AS IsAuthorised
    FROM TPractitioner tp
    INNER JOIN TCRMContact tc ON tp.CRMContactId = tc.CRMContactId
    WHERE tp._OwnerId = @userId and tp.IndClientId = @tenantId
END
GO
