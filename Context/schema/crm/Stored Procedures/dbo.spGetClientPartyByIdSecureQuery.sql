SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kanstantsin Pavaliayeu
-- Create date: 15/05/2020
-- Description:	Stored procedure for getting Client party by Id
-- =============================================
CREATE PROCEDURE [dbo].[spGetClientPartyByIdSecureQuery]
    @partyId INT,
    @userId INT,
    @tenantId INT
AS
BEGIN
    DECLARE @DatabaseEntityTypeName VARCHAR(12)
    DECLARE @DatabaseName VARCHAR(20)
    DECLARE @EditAccess INT
	DECLARE @ExecuteAccess INT

    SET @DatabaseEntityTypeName = N'CRMContact' --for Client Party
    SET @DatabaseName = N'CRM'
    SET @EditAccess = 2
	SET @ExecuteAccess = 8

    DECLARE @AccessRightsByEntityTypeTemp TABLE (EntityId INT, UserId INT, DatabaseEntityTypeName VARCHAR(12), RootDatabaseEntityName VARCHAR(20), RightMask INT)
    INSERT INTO @AccessRightsByEntityTypeTemp
    EXEC [administration].[dbo].[nio_spRetrieveAccessRightsByEntityTypeAndEntityIdAndUserId] @DatabaseName, @DatabaseEntityTypeName, @partyId, @userId

    SELECT
        contact.CRMContactId AS Id,
        contact.RefCRMContactStatusId AS CustomerType,
        CASE
            WHEN contact.CorporateId IS NOT NULL THEN 3 --Corporate
            WHEN contact.TrustId IS NOT NULL THEN 2 --Trust
            ELSE 1 --Person
        END as PartyType,
        NULL AS LeadId,
        (CASE
            WHEN ((accessRights.RightMask & @EditAccess) = @EditAccess OR
			(accessRights.RightMask & @ExecuteAccess) = @ExecuteAccess) --'bitwise AND' for checking write access
                THEN 1
            ELSE 0
        END) AS CanBeUpdated,
        NULL AS AccountId
    FROM TCRMContact contact
    INNER JOIN @AccessRightsByEntityTypeTemp accessRights ON accessRights.EntityId = contact.CRMContactId
    WHERE contact.CRMContactId = @partyId
    AND contact.RefCRMContactStatusId = 1
END
GO


