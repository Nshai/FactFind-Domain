SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier            Issue           Description
----        ---------           -------         -------------
20240312    Nirmatt Gopal       SE-4780         Tax Code Field in Document Designer
20240103    Geethu N S          SE-3737         Add Portal vulnerability question to Document Designer.  
20230804    Shruthy C S         IOSE22-2278     Record Vulnerability dates within Document Designer.
*/
CREATE PROCEDURE [dbo].[SpNioCustomPartyByCustomerStatus]	
	 @CRMContactIds VARCHAR(8000) , @TenantId INT, @CRMContactStatusId INT
AS

SELECT
	pc.PractitionerId AS AdviserId,
	ct.CRMContactId AS PartyId,
	p.Title AS Title,
	p.FirstName AS FirstName,
	p.LastName AS LastName,
	p.MiddleName AS MiddleName,
	p.MaidenName AS MaidenName,
	p.GenderType AS Gender,
	p.Salutation AS Salutation,
	ISNULL(ct.DOB, p.DOB) AS Dob,
	ct.ExternalReference AS ReferenceNumber,
	p.NINumber AS NINumber,
	p.Salary AS Salary,
	p.MaritalStatus AS MaritalStatus,
	p.UKResident AS IsUkResident,
	p.UKDomicile AS IsUKDomicile,
	p.CountryCodeOfResidence AS CountryCodeOfResidence,
	p.CountryCodeOfDomicile AS CountryCodeOfDomicile,
	p.Expatriate AS IsExpatriate,
	p.IsInGoodHealth AS IsInGoodHealth,
	p.IsSmoker AS IsSmoker,
	p.HasSmokedInLast12Months AS HasSmokedInLast12Months,
	a.HasValidWill AS HasValidWill,
	a.IsWillUptoDate AS IsWillUptoDate,
	ISNULL(N.Name, '') AS Nationality,
	p.AttorneyName AS AttorneyName,
	p.IsPowerOfAttorneyGranted AS IsPowerOfAttorneyGranted,
	c.CorporateName AS CorporateName,
	c.BusinessType AS Business,
	CASE WHEN ISNULL(ct.CorporateId, ISNULL(t.TrustId, 0)) > 0THEN 1 ELSE 0 END AS [IsCorporate],
	ct.AdditionalRef AS SecondaryReference,
	t.TrustName AS TrustName,
	p.MaritalStatusSince AS MaritalStatusSince,
	pext.HealthNotes AS HealthNotes,
	pext.MedicalConditionNotes AS MedicalConditionNotes,
	a.HasBeenAdvisedToMakeWill AS HasBeenAdvisedToMakeWill,
	ss.ServiceStatusName AS ServiceStatus,
	cs.ClientSegmentName AS ClientSegment,
	COALESCE(c.LEI, t.LEI) AS LEI,
	COALESCE(c.LEIExpiryDate, t.LEIExpiryDate) AS LEIExpiryDate,
	dbo.FnGetPointOfContactForClient(ct.CRMContactId) AS PointOfContact,
	pext.HasOtherConsiderations AS OtherConsiderations,
	pext.OtherConsiderationsNotes AS ConsiderationNotes,
	cv.HasVulnerability AS HasVulnerability,
	cv.Type AS Type,
	cv.Categories AS Categories,
	cv.Notes AS Notes,
	cv.AssesedOn AS AssesedOn,
	cv.ReviewOn AS ReviewOn,
	cv.IsClientPortalSuitable As IsClientPortalSuitable,
	fp.TotalGrossAnnualIncome AS TotalGrossAnnualIncome,
	fp.TotalNetWorth AS TotalNetWorth,
	fp.TotalLiquidNetWorth AS TotalLiquidNetWorth,
	fp.HouseholdIncome AS HouseholdIncome,
	fp.HouseholdNetWorth AS HouseholdNetWorth,
	fp.HouseholdLiquidNetWorth AS HouseholdLiquidNetWorth,
	fp.TaxBracket AS TaxBracket,
	fp.IsSubjectToBackupWithholding AS IsSubjectToBackupWithholding,
	t.RegistrationNumber AS RegistrationNumber,
	t.RegistrationDate AS RegistrationDate,
	p.TaxCode AS TaxCode
FROM crm..TCRMContact ct
INNER JOIN policymanagement.dbo.FnSplit(@CRMContactIds, ',') parslist ON ct.CRMContactId = parslist.Value 
LEFT JOIN crm..TPractitioner pc on pc.CRMContactId = ct.CurrentAdviserCRMId
LEFT JOIN crm..TPerson p on ct.PersonId = p.PersonId
LEFT JOIN crm..TPersonExt pext on pext.PersonId = p.PersonId
LEFT JOIN crm..TCorporate c on c.CorporateId = ct.CorporateId
left JOIN crm..TTrust t on t.TrustId = ct.TrustId
LEFT JOIN factfind..TAdviceareas a on a.CRMContactId = ct.CRMContactId
left join crm..TRefNationality N ON P.RefNationalityId = N.RefNationalityId
LEFT JOIN crm..TRefServiceStatus ss ON ss.RefServiceStatusId = ct.RefServiceStatusId
LEFT JOIN crm..TRefClientSegment cs ON cs.RefClientSegmentId = ct.RefClientSegmentId
LEFT JOIN crm..TClientVulnerability cv ON cv.CRMContactId = ct.CRMContactId
LEFT JOIN crm..TFinancialProfile fp ON fp.CrmContactId = ct.CRMContactId

WHERE ct.IndClientId = @TenantId AND ct.RefCRMContactStatusId = @CRMContactStatusId
