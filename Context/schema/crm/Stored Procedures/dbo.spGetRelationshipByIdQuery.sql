SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kanstantsin Pavaliayeu
-- Create date: 19/05/2020
-- Description:	Stored procedure for getting Relationship by Id
-- =============================================
CREATE PROCEDURE [dbo].[spGetRelationshipByIdQuery]
    @relationshipId INT
AS
BEGIN
    SELECT TOP 1
        relationFrom.RelationshipId,
        relationTo.RelationshipId AS CorrespondingRelationshipId,
        relationFrom.RefRelTypeId AS RefRelationshipTypeId,
        relType.RelationshipTypeName,
        relationFrom.RefRelCorrespondTypeId AS CorrespondingRefRelationshipTypeId,
        relCorrecpondType.RelationshipTypeName AS CorrespondingRelationshipTypeName,
        relationFrom.CRMContactFromId AS RelationshipFromId,
        relationFrom.CRMContactToId AS RelationshipToId,
        (CASE
            WHEN contactFrom.CorporateName IS NULL
                THEN (contactFrom.FirstName + N' ' + contactFrom.LastName)
            ELSE contactFrom.CorporateName
        END)
            AS RelationshipFromName,
        (CASE
            WHEN contactTo.CorporateName IS NULL
                THEN (contactTo.FirstName + N' ' + contactTo.LastName)
            ELSE contactTo.CorporateName
        END)
            AS RelationshipToName,
        contactFrom.IndClientId AS TenantId,
        ISNULL(contactFrom.IsHeadOfFamilyGroup, 0) AS RelationshipFromIsHeadOfFamilyGroup,
        ISNULL(contactTo.IsHeadOfFamilyGroup, 0) AS RelationshipToIsHeadOfFamilyGroup,
        ISNULL(relationFrom.IsFamilyFg, 0) AS IsFamily,
        ISNULL(relationFrom.IsPartnerFg, 0) AS IsPartner,
        ISNULL(relationTo.IncludeInPfp, 0) AS IncludeInPfpRelation,
        ISNULL(relationFrom.IncludeInPfp, 0) AS IncludeInPfpSubject,
        CAST(ISNULL(relationFrom.GivenAccessAt, 0) AS BIT) AS AccessToRelation,
        CAST(ISNULL(relationTo.GivenAccessAt, 0) AS BIT) AS AccessToSubject,
        ISNULL(relationFrom.IsPointOfContactFg, 0) AS IsPointOfContact,
        CASE
            WHEN account.AccountId IS NOT NULL THEN 1 ELSE 0
        END AS IsToAccount,
        CASE
            WHEN contactTo.PersonId IS NOT NULL THEN 1 ELSE 0
        END AS IsToPerson,
        CASE
            WHEN contactTo.CorporateId IS NOT NULL THEN 1 ELSE 0
        END AS IsToCorporate,
        CASE
            WHEN contactTo.TrustId IS NOT NULL THEN 1 ELSE 0
        END AS IsToTrust
    FROM TRelationship relationFrom
        INNER JOIN TRefRelationshipType relType ON relType.RefRelationshipTypeId = relationFrom.RefRelTypeId
        INNER JOIN TRefRelationshipType relCorrecpondType ON relCorrecpondType.RefRelationshipTypeId = relationFrom.RefRelCorrespondTypeId
        INNER JOIN TCRMContact contactFrom ON contactFrom.CRMContactId = relationFrom.CRMContactFromId
        INNER JOIN TCRMContact contactTo ON contactTo.CRMContactId = relationFrom.CRMContactToId
        INNER JOIN TRelationship relationTo ON relationFrom.CRMContactToId = relationTo.CRMContactFromId
                                            AND relationFrom.CRMContactFromId = relationTo.CRMContactToId
                                            AND relType.RefRelationshipTypeId = relationTo.RefRelCorrespondTypeId
        LEFT OUTER JOIN TAccount account ON account.CRMContactId = contactTo.CRMContactId
    WHERE relationFrom.RelationshipId = @relationshipId
        AND ISNULL(contactFrom.ArchiveFg, 0) = 0
        AND ISNULL(contactTo.ArchiveFg, 0) = 0
        AND ISNULL(contactFrom.IsDeleted, 0) = 0
        AND ISNULL(contactTo.IsDeleted, 0) = 0
END
GO
