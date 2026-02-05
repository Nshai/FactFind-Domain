CREATE VIEW [dbo].[VwPractitionerWithGroups]
AS
SELECT
	A.IndigoClientId,
	A.PractitionerId,
	A.CRMContactId,
	A.PractitionerName,
	A.PractitionerTypeId,
	A.PractitionerType,
	A.TnCCoachId,
	AuthorisedFG,
	A._OwnerId,
	U.UserId,
	U.Reference AS UserReference,
	G1.Identifier AS PrimaryGroup,
	G2.Identifier AS SecondGroup,
	G1.GroupId AS Group1,
	G2.GroupId AS Group2,
	G3.GroupId AS Group3,
	G4.GroupId AS Group4,
	G4.ParentId AS Group5,
	Ging1.Identifier AS PrimaryGrouping,
	Ging2.Identifier AS SecondGrouping
FROM
	CRM..VwPractitioner A WITH(NOLOCK)
	JOIN Administration..TUser U WITH(NOLOCK) ON U.CRMContactId = A.CRMContactId
	JOIN Administration..TGroup G1 WITH(NOLOCK) ON G1.GroupId = U.GroupId
	LEFT JOIN Administration..TGroup G2 WITH(NOLOCK) ON G2.GroupId = G1.ParentId
	LEFT JOIN Administration..TGroup G3 WITH(NOLOCK) ON G3.GroupId = G2.ParentId
	LEFT JOIN Administration..TGroup G4 WITH(NOLOCK) ON G4.GroupId = G3.ParentId
	JOIN Administration..TGrouping Ging1 WITH(NOLOCK) ON Ging1.GroupingId = G1.GroupingId
	LEFT JOIN Administration..TGrouping Ging2 WITH(NOLOCK) ON Ging2.GroupingId = G2.GroupingId


GO

