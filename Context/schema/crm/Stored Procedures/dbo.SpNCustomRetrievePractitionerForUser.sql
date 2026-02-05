SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePractitionerForUser] @UserId bigint
AS


SELECT B.FirstName + ' ' + B.LastName 'AdviserName',A.CRMContactId,C.PractitionerId
	
FROM Administration..TUser  A
JOIN CRM..TCRMContact B ON A.CRMContactId=B.CRMContactId
JOIN CRM..TPractitioner C ON B.CRMContactId=C.CRMContactId
WHERE A.USerId=@UserId

GO
