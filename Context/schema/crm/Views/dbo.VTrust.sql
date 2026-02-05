SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW dbo.VTrust

AS

SELECT
	T.TrustId,
	T.RefTrustTypeId,
	T.IndClientId,
	T.TrustName,
	T.EstDate,
	T.ArchiveFG,
	T.Extensible,
	T.ConcurrencyId AS TrustConcurrencyId,
	C.CRMContactId,
	T.UpdatedOn,
	T.CreatedOn,
	T.CreatedByUserId,
	T.UpdatedByUserId,
	T.LEI,
	T.LEIExpiryDate,
	T.RegistrationNumber,
	T.RegistrationDate,
	T.Instrument,
	T.BusinessRegistrationNumber,
	T.NatureOfTrust,
	T.VatRegNo,
	T.EstablishmentCountryId,
	T.ResidenceCountryId
FROM
	CRM.dbo.TTrust T
	JOIN CRM..TCRMContact C ON C.TrustId = T.TrustId
GO
