SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VClient]

AS

SELECT
	A.CRMContactId,
	A.RefCRMContactStatusId,
	A.AdvisorRef,
	A.Postcode,
	A.OriginalAdviserCRMId,
	A.CurrentAdviserCRMId,
	A.CurrentAdviserName,
	A.IndClientId,
	A.RefServiceStatusId,
	A.ExternalReference,
	A.CampaignDataId,
	A.AdditionalRef,
	A.CRMContactId AS PartyCRMContactId,
	A._OwnerId,
	A.ConcurrencyId,
	NULL AS Salary--This is used as a dummy column for group scheme member imports.
FROM
	dbo.TCRMContact A
WHERE
	ISNULL(A.RefCRMContactStatusId,0) IN (0,1,2)
	AND ISNULL(A.InternalContactFG, 0) = 0
GO
