SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW dbo.VCorporate
AS

SELECT
	CO.CorporateId,
	CO.IndClientId,
	CO.CorporateName,
	CO.ArchiveFg,
	CO.BusinessType,
	CO.RefCorporateTypeId,
	CO.CompanyRegNo,
	CO.EstIncorpDate,
	CO.YearEnd,
	CO.VatRegFg,
	CO.VatRegNo,
	CO.Extensible,
	CO.ConcurrencyId AS CorporateConcurrencyId,
	C.CRMContactId,
	CO.UpdatedOn,
	CO.CreatedOn,
	CO.CreatedByUserId,
	CO.UpdatedByUserId,
	CO.LEI,
	CO.LEIExpiryDate,
	CO.BusinessRegistrationNumber,
	CO.NINumber
FROM
	CRM..TCorporate CO
	JOIN CRM..TCRMContact C ON C.CorporateId = Co.CorporateId
GO
