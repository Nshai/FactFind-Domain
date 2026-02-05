SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveBlankPdfData]
	@IndigoClientId bigint,
	@UserId bigint
AS

-- Get legal entity
EXEC Administration.[dbo].[SpNCustomRetrieveLegalEntityForUser] @UserId

-- Indigo Client
SELECT 
	I.*,
	Org.Guid OrganisationGuid,
	Prov.Guid ProviderGuid
FROM 
	Administration..TIndigoClient I WITH(NOLOCK)
	LEFT JOIN TDpGuid Org WITH(NOLOCK) ON Org.EntityId = I.IndigoClientId AND Org.DpGuidTypeId = 3
	LEFT JOIN TDpGuid Prov WITH(NOLOCK) ON Prov.EntityId = I.IndigoClientId AND Prov.DpGuidTypeId = 4
WHERE
	IndigoClientId = @IndigoClientId

-- Ref Expenditure Information
SELECT et.*, eg.Name AS ExpenditureGroupName
FROM TRefExpenditureType et
     INNER JOIN TRefExpenditureType2ExpenditureGroup et2eg ON et2eg.ExpenditureTypeId = et.RefExpenditureTypeId
	 INNER JOIN TRefExpenditureGroup eg ON eg.RefExpenditureGroupId = et2eg.ExpenditureGroupId AND eg.TenantId = @IndigoClientId
WHERE et.RefExpenditureTypeId NOT IN (4,5,23,26,36,37,38,39,21,22,9) and EG.Name != 'Expenditures'
ORDER BY Ordinal

SELECT *, eg.Name AS ExpenditureGroupName
FROM TRefExpenditureGroup eg
WHERE eg.TenantId = @IndigoClientId AND EG.Name != 'Expenditures'
ORDER BY Ordinal

-- Extra risk questions
SELECT RefRiskQuestionId, Ordinal, Question
FROM Administration..TRefRiskQuestion 
WHERE CreatedBy = @IndigoClientId AND IsArchived = 0
ORDER BY Ordinal

-- Data Protection
if(EXISTS(SELECT TOP 1 P.PolicyId
FROM dpa..TPolicy P
WHERE P.TenantId = @IndigoClientId AND P.IsDeleted = 0 AND P.PartyType = 'Person'
ORDER BY P.CreationDate DESC))
BEGIN
SELECT TOP 1 
    P.Statement1
   ,P.Statement2
   ,P.Statement3
   ,P.Statement4
   ,P.Statement5 
FROM dpa..TPolicy P
WHERE P.TenantId = @IndigoClientId AND P.IsDeleted = 0 AND P.PartyType = 'Person'
ORDER BY P.CreationDate DESC
END
ELSE
BEGIN
SELECT TOP 1 
    P.Statement1
   ,P.Statement2
   ,P.Statement3
   ,P.Statement4
   ,P.Statement5 
FROM dpa..TPolicy P
WHERE P.TenantId = @IndigoClientId AND P.IsDeleted = 0 AND P.PartyType IS NULL
ORDER BY P.CreationDate DESC
END


GO
