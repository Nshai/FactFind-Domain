SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW dbo.VPerson  
AS  
  
SELECT
	P.PersonId,
	P.Title,
	P.FirstName,
	P.MiddleName,
	P.LastName,
	P.MaidenName,
	P.DOB,
	P.GenderType,
	P.NINumber,
	P.IsSmoker,
	P.UKResident,
	P.ResidentIn,
	P.Salutation,
	P.RefSourceTypeId,
	P.IntroducerSource,
	P.MaritalStatus,
	P.MarriedOn,
	P.Residency,
	P.UKDomicile,
	P.Domicile,
	P.TaxCode,
	P.Nationality,
	P.ArchiveFG,
	P.IndClientId,
	P.Salary,
	P.RefNationalityId,
	P.ConcurrencyId AS PersonConcurrencyId,
	ISNULL(T.RefTitleId, 0) AS RefTitleId,
	P.Expatriate,
	P.HasSmokedInLast12Months,
	P.IsInGoodHealth,
	P.IsPowerOfAttorneyGranted,
	P.AttorneyName,
	P.IsDisplayTitle,
	P.MaritalStatusSince,
	C.CRMContactId,
	P.UpdatedOn
	, P.CreatedOn
	, P.CreatedByUserId
	, P.UpdatedByUserId
	, p.NationalClientIdentifier
	, p.CountryCodeOfResidence
	, p.CountryCodeOfDomicile
	, P.InvitationSendDate
	, P.EverSmoked
	, P.HasVapedorUsedEcigarettesLast1Year
	, P.HaveUsedNicotineReplacementProductsLast1Year

FROM
	CRM..TPerson P
	JOIN CRM..TCRMContact C ON C.PersonId = P.PersonId
	LEFT JOIN CRM..TRefTitle T ON T.TitleName = P.Title
GO
