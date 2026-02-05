SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE SpCustomRetrieveAuthorPractitionerDataForClient
@ClientCRMContactID bigint

as

SELECT 
1 as tag,
NULL as parent,
p.PractitionerId as [Practitioner!1!PractitionerId],
ps.Title as [Practitioner!1!Title],
c.FirstName as [Practitioner!1!FirstName],
c.LastName as [Practitioner!1!LastName],
case 
	when email.contactid is null then u.email
	else email.Value
end as [Practitioner!1!Email],
tel.Value as [Practitioner!1!Telephone],
u.Reference as [Practitioner!1!Reference]
FROM TCRMContact client 
JOIN TPractitioner p on p.CRMContactId = client.CurrentAdviserCRMId
JOIN TCRMContact c on c.CRMContactId = p.CRMContactId
JOIN TPerson ps on ps.PersonId = c.PersonId
JOIN administration..TUser u on u.CRMContactId = p.CRMContactId
LEFT JOIN TContact email ON email.CRMContactId = p.CRMContactId AND email.DefaultFg = 1 and email.RefContactType like '%mail'
LEFT JOIN TContact tel ON tel.CRMContactId = p.CRMContactId AND tel.DefaultFg = 1 and tel.RefContactType = 'Telephone'
WHERE client.CRMContactId = @ClientCRMContactID

FOR XML EXPLICIT