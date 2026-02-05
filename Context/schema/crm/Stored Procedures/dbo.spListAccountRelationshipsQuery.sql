SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kanstantsin Pavaliayeu
-- Create date: 15/05/2020
-- Update date: 03/12/2020
-- Description:	Get account relationships
-- =============================================
CREATE PROCEDURE [dbo].[spListAccountRelationshipsQuery]
    @partyId INT,
    @tenantId INT,
    @top INT,
    @skip INT,
    @orderBy VARCHAR(30),
    @orderDescending BIT = 0
AS
BEGIN
    SELECT COUNT(relation.RelationshipId) AS 'Count'
    FROM TRelationship relation
        INNER JOIN TCRMContact contactFrom ON contactFrom.CRMContactId = relation.CRMContactFromId
        INNER JOIN TCRMContact contactTo ON relation.CRMContactToId = contactTo.CRMContactId
        INNER JOIN TRefRelationshipType relType ON relation.RefRelTypeId = relType.RefRelationshipTypeId
    WHERE contactFrom.CRMContactId = @partyId
        AND ISNULL(contactFrom.ArchiveFg, 0) = 0
        AND ISNULL(contactTo.ArchiveFg, 0) = 0
        AND ISNULL(contactFrom.IsDeleted, 0) = 0
        AND ISNULL(contactTo.IsDeleted, 0) = 0;

    SELECT * FROM
    (
        SELECT
            relation.RelationshipId AS Id,
            relation.CRMContactFromId AS RelationshipFromId,
            CASE
                WHEN contactFrom.CorporateName IS NULL
                    THEN (contactFrom.FirstName + N' ' + contactFrom.LastName)
                ELSE contactFrom.CorporateName
            END AS RelationshipFromName,
            relation.CRMContactToId AS RelationshipToId,
            CASE
                WHEN contactTo.CorporateName IS NULL
                    THEN (contactTo.FirstName + N' ' + contactTo.LastName)
                ELSE contactTo.CorporateName
            END AS RelationshipToName,
            contactTo.CurrentAdviserName,
            contactTo.ExternalReference,
            relType.RelationshipTypeName,
            ISNULL(relation.IncludeInPfp, 0) AS IncludeInPfp,
            ISNULL(relation.IsPartnerFg, 0) AS IsPartner,
            ISNULL(relation.IsFamilyFg, 0) AS IsFamily,
            0 AS IsHeadOfFamilyGroup,
            ISNULL(relation.IsPointOfContactFg, 0) AS IsPointOfContact,
            1 AS IsToOrFromAccount
        FROM TRelationship relation
            INNER JOIN TCRMContact contactFrom ON contactFrom.CRMContactId = relation.CRMContactFromId
            INNER JOIN TCRMContact contactTo ON relation.CRMContactToId = contactTo.CRMContactId
            INNER JOIN TRefRelationshipType relType ON relation.RefRelTypeId = relType.RefRelationshipTypeId
        WHERE contactFrom.CRMContactId = @partyId
            AND ISNULL(contactFrom.ArchiveFg, 0) = 0
            AND ISNULL(contactTo.ArchiveFg, 0) = 0
            AND ISNULL(contactFrom.IsDeleted, 0) = 0
            AND ISNULL(contactTo.IsDeleted, 0) = 0
    ) as r
    GROUP BY r.Id, r.RelationshipFromId, r.RelationshipToId, r.RelationshipFromName, r.RelationshipToName,
            r.CurrentAdviserName, r.ExternalReference, r.RelationshipTypeName, r.IncludeInPfp, r.IsPartner,
            r.IsFamily, r.IsHeadOfFamilyGroup, r.IsPointOfContact, r.IsToOrFromAccount
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
END
GO
