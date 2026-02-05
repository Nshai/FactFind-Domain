SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW dbo.VIntroducer

AS

SELECT
	I.IntroducerId,
	I.IndClientId,
	I.CRMContactId,
	I.AgreementDate,
	I.RefIntroducerTypeId,
	I.PractitionerId,
	I.ArchiveFG,
	I.Identifier,
	I.UniqueIdentifier,
	I.ConcurrencyId,
	P.CRMContactId AS AdviserCRMContactId
FROM
	dbo.TIntroducer I
	LEFT JOIN CRM..TPractitioner P ON P.PractitionerId = I.PractitionerId
GO
