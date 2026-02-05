CREATE VIEW [dbo].[VwPractitioner]
AS
SELECT
	A.IndClientId AS IndigoClientId,
	A.PractitionerId,
	A.CRMContactId,
	Ac.FirstName + ' ' + Ac.LastName AS PractitionerName,
	Pt.PractitionerTypeId,
	Pt.[Description] AS PractitionerType,
	A.TnCCoachId,
	A.AuthorisedFG,
	A.AuthorisedDate,
	A._OwnerId
FROM
	-- Practitioner
	TPractitioner A WITH(NOLOCK) 
	JOIN TCRMContact Ac WITH(NOLOCK) ON Ac.CRMContactId = A.CRMContactId	
	LEFT JOIN TPractitionerType Pt WITH(NOLOCK) ON Pt.PractitionerTypeId = A.PractitionerTypeId
GO
