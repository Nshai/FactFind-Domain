SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Description: Stored procedure for getting Relationship Types
-- =============================================================
CREATE PROCEDURE [dbo].[spListRelationshipTypesQuery]
    @accountId INT
AS
BEGIN
SELECT
    relTypeFrom.RefRelationshipTypeId
   ,relTypeFrom.RelationshipTypeName
   ,relTypeFrom.PersonFg AS IsPerson
   ,relTypeFrom.CorporateFg AS IsCorporate
   ,relTypeFrom.TrustFg AS IsTrust
   ,relTypeFrom.AccountFg AS IsAccount
   ,relTypeTo.RefRelationshipTypeId
   ,relTypeTo.RelationshipTypeName
   ,relTypeTo.PersonFg AS IsPerson
   ,relTypeTo.CorporateFg AS IsCorporate
   ,relTypeTo.TrustFg AS IsTrust
   ,relTypeTo.AccountFg AS IsAccount
FROM crm.dbo.TRefRelationshipTypeLink relTypeLink
    INNER JOIN crm.dbo.TRefRelationshipType relTypeFrom ON relTypeLink.RefRelTypeId = relTypeFrom.RefRelationshipTypeId
    INNER JOIN crm.dbo.TRefRelationshipType relTypeTo ON relTypeLink.RefRelCorrespondTypeId = relTypeTo.RefRelationshipTypeId
WHERE @accountId IS NULL
    AND relTypeFrom.ArchiveFg = 0
    AND relTypeTo.ArchiveFg = 0
    AND relTypeFrom.AccountFg = 0
    AND relTypeTo.AccountFg = 0
UNION ALL
SELECT
    relTypeFrom.RefRelationshipTypeId
   ,relTypeFrom.RelationshipTypeName
   ,relTypeFrom.PersonFg AS IsPerson
   ,relTypeFrom.CorporateFg AS IsCorporate
   ,relTypeFrom.TrustFg AS IsTrust
   ,relTypeFrom.AccountFg AS IsAccount
   ,relTypeTo.RefRelationshipTypeId
   ,relTypeTo.RelationshipTypeName
   ,relTypeTo.PersonFg AS IsPerson
   ,relTypeTo.CorporateFg AS IsCorporate
   ,relTypeTo.TrustFg AS IsTrust
   ,relTypeTo.AccountFg AS IsAccount
FROM crm.dbo.TRefRelationshipTypeLink relTypeLink
    INNER JOIN crm.dbo.TRefRelationshipType relTypeFrom ON relTypeLink.RefRelTypeId = relTypeFrom.RefRelationshipTypeId
    INNER JOIN crm.dbo.TRefRelationshipType relTypeTo ON relTypeLink.RefRelCorrespondTypeId = relTypeTo.RefRelationshipTypeId
    INNER JOIN crm..TAccountType accountType ON accountType.AccountTypeName = relTypeFrom.RelationshipTypeName
                                            AND relTypeFrom.AccountFg = 1
    INNER JOIN crm..TAccount account ON account.AccountTypeId = accountType.AccountTypeId
WHERE @accountId IS NOT NULL AND account.AccountId = @accountId
END
GO
