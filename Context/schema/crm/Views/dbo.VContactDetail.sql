SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VContactDetail]
AS

SELECT
	C.ContactId
	, C.IndClientId
	, C.CRMContactId
	, C.RefContactType
	, C.[Description]
	, C.Value
	, C.DefaultFg
	, C.Extensible
	, C.ConcurrencyId
	, C.MigrationRef
	, CT.RefContactTypeId
	, C.UpdatedOn
	, C.CreatedOn
	, C.CreatedByUserId
	, C.UpdatedByUserId
FROM
	CRM..TContact C
	JOIN CRM..TRefContactType CT ON CT.ContactTypeName = C.RefContactType
GO
