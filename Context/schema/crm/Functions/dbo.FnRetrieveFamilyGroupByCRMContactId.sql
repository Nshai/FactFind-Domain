SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  FUNCTION [dbo].[FnRetrieveFamilyGroupByCRMContactId]
(@CRMContactId INT, @TenantId INT)
RETURNS 
@Result TABLE 
(
CRMContactId INT, 
ClientName VARCHAR(255), 
IsHeadOfFamilyGroup BIT
)
AS
BEGIN
	DECLARE @FamilyGroupCreationDate DATETIME
	DECLARE @HeadOfFamilyGroupId INT

	DECLARE @FamilyGroupTemp TABLE (CRMContactId INT, ClientName VARCHAR(255), IsHeadOfFamilyGroup BIT, FamilyGroupCreationDate DATETIME)
	
	INSERT INTO @FamilyGroupTemp
	SELECT CRMContactId, 
	CASE WHEN FirstName IS NULL AND LastName IS NULL THEN CorporateName
	ELSE RTRIM(LTRIM(ISNULL(FirstName, '') + ' ' + ISNULL(LastName, ''))) END AS ClientName,
	IsHeadOfFamilyGroup, FamilyGroupCreationDate
	FROM dbo.TCRMContact
	WHERE CRMContactId = @CRMContactId AND IsHeadOfFamilyGroup = 1

    SELECT TOP 1 @HeadOfFamilyGroupId = B.CRMContactId, @FamilyGroupCreationDate = B.FamilyGroupCreationDate
	FROM CRM..TRelationship A
    JOIN TCRMContact B ON A.CRMContactToId=B.CRMContactId  AND B.IndClientId = @TenantId AND B.ArchiveFg = 0
    JOIN TRefRelationshipType C ON A.RefRelTypeId =C.RefRelationshipTypeId
    JOIN TRefRelationshipType D ON A.RefRelCorrespondTypeId=D.RefRelationshipTypeId
	WHERE A.IsFamilyFg = 1 AND ISNULL(C.ArchiveFg, 0) = 0 AND (A.CRMContactFromId = @CRMContactId or A.CRMContactToId = @CRMContactId) AND B.IsHeadOfFamilyGroup = 1
    ORDER BY B.FamilyGroupCreationDate ASC

	IF @HeadOfFamilyGroupId IS NULL AND NOT EXISTS(SELECT 1 FROM @FamilyGroupTemp)
		RETURN
	ELSE
	BEGIN
		IF @CRMContactId <> @HeadOfFamilyGroupId
		INSERT INTO @FamilyGroupTemp
		SELECT CRMContactId, 
		CASE WHEN FirstName IS NULL AND LastName IS NULL THEN CorporateName
		ELSE RTRIM(LTRIM(ISNULL(FirstName, '') + ' ' + ISNULL(LastName, ''))) END AS ClientName,
		IsHeadOfFamilyGroup, FamilyGroupCreationDate
		FROM dbo.TCRMContact
		WHERE CRMContactId = @HeadOfFamilyGroupId

		INSERT INTO @FamilyGroupTemp
	
		SELECT DISTINCT  CRMContactId,
		CASE WHEN FirstName IS NULL AND LastName IS NULL THEN CorporateName
		ELSE RTRIM(LTRIM(ISNULL(FirstName, '') + ' ' + ISNULL(LastName, ''))) END AS ClientName,
		 IsHeadOfFamilyGroup, FamilyGroupCreationDate
	
		FROM CRM..TRelationship A
		JOIN TCRMContact B ON A.CRMContactToId=B.CRMContactId  AND B.IndClientId = @TenantId AND B.ArchiveFg = 0
		JOIN TRefRelationshipType C ON A.RefRelTypeId =C.RefRelationshipTypeId
		JOIN TRefRelationshipType D ON A.RefRelCorrespondTypeId=D.RefRelationshipTypeId
	
		WHERE A.IsFamilyFg = 1 AND ISNULL(C.ArchiveFg, 0) = 0 AND (A.CRMContactFromId = @HeadOfFamilyGroupId)

		INSERT INTO @Result
		 SELECT DISTINCT CRMContactId,ClientName,IsHeadOfFamilyGroup 
			FROM @FamilyGroupTemp WHERE [dbo].[FnCustomCheckCRMContactIdInOtherFamilyGroup](CRMContactId, @FamilyGroupCreationDate, @TenantId) IS NOT NULL

	END	

RETURN 
END