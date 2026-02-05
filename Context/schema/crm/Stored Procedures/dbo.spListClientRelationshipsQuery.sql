SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* =====================================================================================

Name       : spListClientRelationshipsQuery
Description: Get client relationships

Date        Issue        Who                   Description
----------  -----------  ---     -----------------------------
15/05/2020  ??			   ??		                 Original version
10/08/2021  ??          Kanstantsin Pavaliayeu ?? 
07/02/2022  AIOSEC-211  W Webb                  Addition of support for additional groups for users
===================================================================================== */
CREATE PROCEDURE [dbo].[spListClientRelationshipsQuery]
    @partyId INT,
    @tenantId INT,
    @top INT,
    @skip INT,
    @orderBy VARCHAR(30),
    @orderDescending BIT = 0,
    @isShowPersonalContact BIT = 0
AS
BEGIN
    DECLARE @FamilyGroupTemp TABLE (CRMContactId INT, ClientName VARCHAR(255), IsHeadOfFamilyGroup BIT)
    
	 INSERT INTO @FamilyGroupTemp
    

	 EXEC crm.[dbo].[SpRetrieveFamilyGroupByCRMContactId] @partyId, @tenantId

    DROP TABLE IF EXISTS #Relationships;
    CREATE TABLE #Relationships (RelationshipId INT, CRMContactFromId INT, CRMContactToId INT, RefRelTypeId INT, GivenAccessAt DATETIME, IsPartnerFg BIT, IsFamilyFg BIT, IsPointOfContactFg BIT, IsPersonalContact BIT, PersonalContactId INT)

    DROP TABLE IF EXISTS #PersonCntTemp;

    SELECT
        pc.CRMContactId,
        pc.PersonalContactId
    INTO #PersonCntTemp
    FROM TPersonalContact2Client pcc
    INNER JOIN TPersonalContact pc ON pc.PersonalContactId = pcc.PersonalContactId
    WHERE pcc.CRMContactId = @partyId

    IF @isShowPersonalContact = 1
    BEGIN
        INSERT INTO #Relationships (RelationshipId, CRMContactFromId, CRMContactToId, RefRelTypeId, GivenAccessAt, IsPartnerFg, IsFamilyFg, IsPointOfContactFg, IsPersonalContact, PersonalContactId)
        SELECT 
            relation.RelationshipId,
            relation.CRMContactFromId,
			relation.CRMContactToId AS CRMContactToId,
            relation.RefRelTypeId,
            relation.GivenAccessAt,
            relation.IsPartnerFg,
            relation.IsFamilyFg,
            relation.IsPointOfContactFg,
            IIF(persContact.CRMContactId IS NOT NULL, 1, 0) AS IsPersonalContact,
            persContact.PersonalContactId 
        FROM TRelationship relation
        LEFT JOIN #PersonCntTemp persContact ON persContact.CRMContactId = relation.CRMContactToId
        WHERE
            relation.CRMContactFromId = @partyId
    END
    ELSE
    BEGIN
        INSERT INTO #Relationships (RelationshipId, CRMContactFromId, CRMContactToId, RefRelTypeId, GivenAccessAt, IsPartnerFg, IsFamilyFg, IsPointOfContactFg, IsPersonalContact, PersonalContactId)
        SELECT 
            relation.RelationshipId,
            relation.CRMContactFromId,
            relation.CRMContactToId,
            relation.RefRelTypeId,
            relation.GivenAccessAt,
            relation.IsPartnerFg,
            relation.IsFamilyFg,
            relation.IsPointOfContactFg,
            0 AS IsPersonalContact,
            0
        FROM TRelationship relation
        LEFT JOIN TPersonalContact persContact ON persContact.CRMContactId = relation.CRMContactToId
        WHERE
            relation.CRMContactFromId = @partyId
            AND persContact.CRMContactId IS NULL
    END

    SELECT COUNT(relation.RelationshipId) AS 'Count'
    FROM #Relationships relation
        INNER JOIN TCRMContact contactFrom ON contactFrom.CRMContactId = relation.CRMContactFromId
        INNER JOIN TCRMContact contactTo ON relation.CRMContactToId = contactTo.CRMContactId
        INNER JOIN TRefRelationshipType relType ON relation.RefRelTypeId = relType.RefRelationshipTypeId
    WHERE 
        ISNULL(contactFrom.ArchiveFg, 0) = 0
        AND ISNULL(contactTo.ArchiveFg, 0) = 0
        AND ISNULL(contactFrom.IsDeleted, 0) = 0
        AND ISNULL(contactTo.IsDeleted, 0) = 0;

    DROP TABLE IF EXISTS #RelationshipsDetails;
    SELECT *
    INTO #RelationshipsDetails
    FROM
    (
        SELECT
            relation.RelationshipId AS Id,
            relation.CRMContactFromId AS RelationshipFromId,
            CASE
                WHEN contactFrom.CorporateName IS NULL
                    THEN (contactFrom.FirstName + N' ' + contactFrom.LastName)
                ELSE contactFrom.CorporateName
            END AS RelationshipFromName,
            IIF(relation.IsPersonalContact = 1, relation.PersonalContactId, relation.CRMContactToId) AS RelationshipToId,
            CASE
                WHEN contactTo.CorporateName IS NULL
                    THEN (contactTo.FirstName + N' ' + contactTo.LastName)
                ELSE contactTo.CorporateName
            END AS RelationshipToName,
            contactTo.CurrentAdviserName,
            contactTo.ExternalReference,
            relType.RelationshipTypeName,
            CAST(COALESCE(relation.GivenAccessAt, relationTo.IncludeInPfp, 0) AS BIT) AS IncludeInPfp,
            ISNULL(relation.IsPartnerFg, 0) AS IsPartner,
            ISNULL(relation.IsFamilyFg, 0) AS IsFamily,
            CASE
                WHEN familyGroup.CRMContactId IS NOT NULL AND familyGroup.IsHeadOfFamilyGroup = 1
                    THEN 1
                    ELSE 0
            END AS 'IsHeadOfFamilyGroup',
            ISNULL(relation.IsPointOfContactFg, 0) AS IsPointOfContact,
            CASE
                WHEN (account.AccountId IS NOT NULL)
                    THEN 1
                    ELSE 0
            END AS IsToOrFromAccount,
            relation.IsPersonalContact
        FROM #Relationships relation
            INNER JOIN TRefRelationshipType relType ON relation.RefRelTypeId = relType.RefRelationshipTypeId
            INNER JOIN TRelationship relationTo ON relation.CRMContactToId = relationTo.CRMContactFromId
                AND relation.CRMContactFromId = relationTo.CRMContactToId
                AND relType.RefRelationshipTypeId = relationTo.RefRelCorrespondTypeId
            INNER JOIN TCRMContact contactFrom ON contactFrom.CRMContactId = relation.CRMContactFromId
            INNER JOIN TCRMContact contactTo ON relation.CRMContactToId = contactTo.CRMContactId
            LEFT OUTER JOIN [administration].[dbo].[TUser] u ON u.CRMContactId = contactTo.CRMContactId
            LEFT OUTER JOIN VwCRMContactKeyByEntityId contactKey ON contactKey.EntityId = contactFrom.CRMContactId AND contactKey.UserId = u.UserId
            LEFT OUTER JOIN @FamilyGroupTemp familyGroup ON familyGroup.CRMContactId = contactTo.CRMContactId
            LEFT OUTER JOIN TAccount account ON account.CRMContactId = relation.CRMContactToId
        WHERE
            ISNULL(contactFrom.ArchiveFg, 0) = 0
            AND ISNULL(contactTo.ArchiveFg, 0) = 0
            AND ISNULL(contactFrom.IsDeleted, 0) = 0
            AND ISNULL(contactTo.IsDeleted, 0) = 0
    ) as r
    GROUP BY r.Id, r.RelationshipFromId, r.RelationshipToId, r.RelationshipFromName, r.RelationshipToName,
            r.CurrentAdviserName, r.ExternalReference, r.RelationshipTypeName, r.IncludeInPfp, r.IsPartner,
            r.IsFamily, r.IsHeadOfFamilyGroup, r.IsPointOfContact, r.IsToOrFromAccount, r.IsPersonalContact
    ORDER BY
        CASE WHEN @orderDescending = 1 THEN
            CASE
                WHEN @orderBy = 'RelationshipToName' THEN RelationshipToName
                WHEN @orderBy = 'RelationshipTypeName' THEN RelationshipTypeName
                WHEN @orderBy = 'CurrentAdviserName' THEN CurrentAdviserName
                WHEN @orderBy = 'ExternalReference' THEN ExternalReference
                WHEN @orderBy = 'IncludeInPfp' THEN CAST(IncludeInPfp AS VARCHAR(1))
                WHEN @orderBy = 'IsPartner' THEN CAST(IsPartner AS VARCHAR(1))
                WHEN @orderBy = 'IsFamily' THEN CAST(IsFamily AS VARCHAR(1))
                WHEN @orderBy = 'IsHeadOfFamilyGroup' THEN CAST(IsHeadOfFamilyGroup AS VARCHAR(1))
                WHEN @orderBy = 'IsPointOfContact' THEN CAST(IsPointOfContact AS VARCHAR(1))
                ELSE RelationshipToName
            END
        END DESC,
        CASE WHEN @orderDescending = 0 THEN
            CASE
                WHEN @orderBy = 'RelationshipToName' THEN RelationshipToName
                WHEN @orderBy = 'RelationshipTypeName' THEN RelationshipTypeName
                WHEN @orderBy = 'CurrentAdviserName' THEN CurrentAdviserName
                WHEN @orderBy = 'ExternalReference' THEN ExternalReference
                WHEN @orderBy = 'IncludeInPfp' THEN CAST(IncludeInPfp AS VARCHAR(1))
                WHEN @orderBy = 'IsPartner' THEN CAST(IsPartner AS VARCHAR(1))
                WHEN @orderBy = 'IsFamily' THEN CAST(IsFamily AS VARCHAR(1))
                WHEN @orderBy = 'IsHeadOfFamilyGroup' THEN CAST(IsHeadOfFamilyGroup AS VARCHAR(1))
                WHEN @orderBy = 'IsPointOfContact' THEN CAST(IsPointOfContact AS VARCHAR(1))
                ELSE RelationshipToName
            END
        END ASC

    OFFSET @skip ROWS
    FETCH NEXT @top ROWS ONLY;

    IF @isShowPersonalContact = 1
    BEGIN
        UPDATE relation SET relation.RelationshipToId = pcc.CRMContactId
        FROM #RelationshipsDetails relation
        INNER JOIN TPersonalContact pc ON relation.RelationshipToId = pc.CRMContactId
        INNER JOIN  TPersonalContact2Client pcc  ON pc.PersonalContactId = pcc.PersonalContactId
        WHERE
            relation.IsPersonalContact = 0
    END

    SELECT * FROM #RelationshipsDetails
END
GO
