SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomInvuTask]
	@Id bigint
AS
SELECT
	ISNULL(C.CorporateName, C.FirstName + ' ' + C.LastName) AS Client_Name,
	ISNULL(C.ExternalReference, '') AS Client_Primary_Ref,
	ISNULL(C.AdditionalRef, '') AS Secondary_Ref,
	ISNULL(C.MigrationRef, '') AS Migration_Ref,
	ISNULL(C.CurrentAdviserName, '') AS Servicing_Adviser,
	T.SequentialRef AS Task_Ref,
	ISNULL(T.Subject, '') AS Task_Name,
	ISNULL(TE.MigrationRef, '') AS Task_Migration_Ref
FROM		
	TTask T
	LEFT JOIN TTaskExtended TE ON TE.TaskId = T.TaskId
	JOIN CRM..TCRMContact C WITH(NOLOCK) ON C.CRMContactId = T.CRMContactId
WHERE
	T.TaskId = @Id
FOR XML RAW
GO
