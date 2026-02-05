SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ==================================================
-- Description: Gets adviser by Id
-- ==================================================
CREATE PROCEDURE [dbo].[spGetAdviserQuery]
    @adviserId INT
AS

BEGIN
    SELECT tp.PractitionerId AS Id,
           (CASE WHEN tc.FirstName IS NULL THEN '' ELSE tc.FirstName  END
               + CASE WHEN tc.LastName IS NULL THEN '' ELSE + N' ' + tc.LastName  END) AS [AdviserName],
           tp.AuthorisedFG AS IsAuthorised,
           tp.ServicingAdministratorId,
           tp.ParaplannerUserId
    FROM 
        TPractitioner tp INNER JOIN 
        TCRMContact tc ON tp.CRMContactId = tc.CRMContactId
    WHERE tp.PractitionerId = @adviserId 
END
GO
