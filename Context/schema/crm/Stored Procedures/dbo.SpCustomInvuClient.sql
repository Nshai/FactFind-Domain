SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomInvuClient]
	@Id bigint
AS
SELECT
	ISNULL(CorporateName, FirstName + ' ' + LastName) AS Client_Name,
	ISNULL(ExternalReference, '') AS Client_Primary_Ref,
	ISNULL(AdditionalRef, '') AS Secondary_Ref,
	ISNULL(MigrationRef, '') AS Migration_Ref,
	ISNULL(CurrentAdviserName, '') AS Servicing_Adviser
FROM		
	CRM..TCRMContact
WHERE
	CRMContactId = @Id
FOR XML RAW
GO
