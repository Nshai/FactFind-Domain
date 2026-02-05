SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VFeeRetainerOwner]
AS
SELECT 
	OWNR.FeeRetainerOwnerId
	, OWNR.FeeId
	, OWNR.RetainerId
	, OWNR.CRMContactId
	, OWNR.SecondaryOwnerId
	, OWNR.TnCCoachId
	, OWNR.PractitionerId
	, OWNR.BandingTemplateId
	, OWNR.IndigoClientId
	, OWNR.Extensible
	, OWNR.ConcurrencyId
	, CRMPRAC.CRMContactId AS [AdviserCRMId]
	, CRMTNC.CRMContactId AS [TnCCRMId]
	, CRMPRAC.FirstName + ' ' + CRMPRAC.LastName AS [AdviserName]
	, CRMTNC.FirstName + ' ' + CRMTNC.LastName AS [TnCCoachName]
FROM 
	TFeeRetainerOwner OWNR
	-- ADVISER JOINS
	INNER JOIN CRM..TPractitioner PRAC
		ON PRAC.practitionerid = OWNR.practitionerid
	INNER JOIN CRM..TCRMContact CRMPRAC
		ON CRMPRAC.CRMContactId = PRAC.CRMContactId 
	-- TnCCOACH JOINS
	LEFT JOIN Compliance..TTnCCoach TNCC 
		ON TNCC.TnCCoachid = OWNR.TnCCoachid
	LEFT JOIN Administration..TUser USR
		ON USR.Userid = TNCC.Userid
	LEFT JOIN CRM..TCRMContact CRMTNC
		ON USR.CRMContactId = CRMTNC.CRMContactId

GO
