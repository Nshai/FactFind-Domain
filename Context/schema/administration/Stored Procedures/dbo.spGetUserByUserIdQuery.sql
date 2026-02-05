SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:        Uladzimir Zaitsau
-- Create date:   10/06/2020
-- Description:   Stored procedure for getting user by userId
-- =============================================
CREATE PROCEDURE [dbo].[spGetUserByUserIdQuery]
    @userId INT,
    @tenantId INT
AS
BEGIN
    SELECT tuser.RefUserTypeId,
        tuser.CRMContactId,
        crmContact.FirstName,
        crmContact.LastName,
        tuser.ActiveRole,
        tuser.SuperUser
    FROM administration..TUser tuser
    JOIN crm..TCRMContact crmContact on tuser.CRMContactId = crmContact.CRMContactId
    WHERE TUser.UserId = @userId AND TUser.IndigoClientId = @tenantId
END
GO