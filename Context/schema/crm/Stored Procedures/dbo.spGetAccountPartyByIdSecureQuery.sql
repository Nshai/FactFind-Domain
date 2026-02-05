SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kanstantsin Pavaliayeu
-- Create date: 15/05/2020
-- Description:	Stored procedure for getting Account party by Id
-- =============================================
CREATE PROCEDURE [dbo].[spGetAccountPartyByIdSecureQuery]
    @partyId INT,
    @userId INT,
    @tenantId INT
AS
BEGIN
    DECLARE @DatabaseEntityTypeName VARCHAR(12)
    DECLARE @DatabaseName VARCHAR(20)
    DECLARE @EditAccess INT
	DECLARE @ExecuteAccess INT

    SET @DatabaseEntityTypeName = N'Account' --for Account Party
    SET @DatabaseName = N'CRM'
    SET @EditAccess = 2
	SET @ExecuteAccess = 8

    DECLARE @AccessRightsByEntityTypeTemp TABLE (EntityId INT, UserId INT, DatabaseEntityTypeName VARCHAR(12), RootDatabaseEntityName VARCHAR(20), RightMask INT)
    INSERT INTO @AccessRightsByEntityTypeTemp
    EXEC [administration].[dbo].[nio_spRetrieveAccessRightsByEntityTypeAndEntityIdAndUserId] @DatabaseName, @DatabaseEntityTypeName, @partyId, @userId

    SELECT
        contact.CRMContactId AS Id,
        NULL AS CustomerType,
        CASE
            WHEN contact.PersonId IS NOT NULL THEN 1 --Person
            WHEN contact.CorporateId IS NOT NULL THEN 3 --Corporate
            ELSE 0 --Invalid; Account can't be Trust
        END as PartyType,
        NULL AS LeadId,
        (CASE
            WHEN ((accessRights.RightMask & @EditAccess) = @EditAccess OR
			(accessRights.RightMask & @ExecuteAccess) = @ExecuteAccess) --'bitwise AND' for checking write access
                THEN 1
            ELSE 0
        END) AS CanBeUpdated,
        account.AccountId,
        CASE WHEN contact.CorporateId IS NULL THEN 1 ELSE 0 END AS IsPerson
    FROM TCRMContact contact
    INNER JOIN @AccessRightsByEntityTypeTemp accessRights ON accessRights.EntityId = contact.CRMContactId
    INNER JOIN TAccount account ON account.CRMContactId = contact.CRMContactId
    WHERE contact.CRMContactId = @partyId
END
GO


