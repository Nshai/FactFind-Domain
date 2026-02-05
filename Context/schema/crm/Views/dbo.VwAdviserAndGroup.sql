SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VwAdviserAndGroup] 
AS

SELECT A.IndClientId as IndigoClientID,  A.PractitionerId, A.CRMContactId as AdviserCRMContactId, ISNULL(D.FirstName,'') + ' ' + ISNULL(D.LastName,'') as [AdviserName], B.UserId, C.GroupId, C.Identifier as GroupName

FROM CRM..TPractitioner A 
INNER JOIN CRM..TCRMContact D ON A.IndClientId = D.IndClientId AND A.CRMContactId = D.CRMContactID
INNER JOIN administration..TUser  B ON A.IndClientId = B.IndigoClientId AND A.CRMContactId = B.CRMContactId
INNER JOIN administration..TGroup C ON B.IndigoClientId = C.IndigoClientId AND B.GroupId = C.GroupId