SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveAllRefCountriesCodes]
	@IndigoClientId bigint,
	@CRMContactId bigint,
	@CRMContactId2 bigint
AS
BEGIN

	SET NOCOUNT ON;

    -- Client details countries
	SELECT
		Country.CountryCode
	FROM
		CRM..TCRMContact C
		LEFT JOIN CRM..TPerson P ON P.PersonId = C.PersonId
		LEFT JOIN CRM..TVerification V ON V.CRMContactId = C.CRMContactId
		JOIN CRM..TRefCountry Country ON Country.CountryCode in (P.CountryCodeOfResidence, P.CountryCodeOfDomicile, V.CountryOfBirth)
	WHERE
		C.IndClientId = @IndigoClientId AND C.CRMContactId IN (@CRMContactId, @CRMContactId2)

	UNION

	-- Addresses countries   
	SELECT	
		Country.CountryCode
	FROM
		CRM..TAddress A
		JOIN CRM..TAddressStore AST ON A.AddressStoreId = AST.AddressStoreId
		JOIN CRM..TRefCountry Country ON Country.RefCountryId = AST.RefCountryId
	WHERE
		A.IndClientId = @IndigoClientId AND A.CRMContactId IN (@CRMContactId, @CRMContactId2)

	UNION

	-- EmploymentDetails countries 
	SELECT 
		Country.CountryCode
	FROM factfind..TEmploymentDetail E
		 JOIN CRM..TRefCountry Country ON Country.RefCountryId =  E.RefCountryId
	WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)

	UNION

	-- TPropertyDetail countries
	SELECT
		Country.CountryCode
	FROM factfind..TPropertyDetail pd
		 JOIN CRM..TRefCountry country on Country.RefCountryId = pd.RefCountryId
	WHERE
	(
		(pd.CRMContactId = @CRMContactId AND  pd.CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
		OR (pd.CRMContactId = @CRMContactId2 AND pd.CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
		OR (pd.CRMContactId = @CRMContactId AND  pd.CRMContactId2 IS NULL ) --single expenses for Cl1
		OR (pd.CRMContactId = @CRMContactId2 AND pd.CRMContactId2 IS NULL ) --single expenses for Cl2
	)

	UNION

	-- Bank details countries
	SELECT
		Country.CountryCode
	FROM CRM..TClientBankAccount as CBA
		 LEFT JOIN CRM..TCRMContact C ON CBA.CRMContactId = C.CRMContactId
		 JOIN CRM..TRefCountry Country ON Country.RefCountryId = CBA.RefCountryId
	WHERE
	(
		(CBA.CRMContactId = @CRMContactId AND  CBA.CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
		OR (CBA.CRMContactId = @CRMContactId2 AND CBA.CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
		OR (CBA.CRMContactId = @CRMContactId AND  CBA.CRMContactId2 IS NULL ) --single expenses for Cl1
		OR (CBA.CRMContactId = @CRMContactId2 AND CBA.CRMContactId2 IS NULL ) --single expenses for Cl2
	)

	UNION

	-- TSoletraderdetails countries
	SELECT
		Country.CountryCode
	FROM TSoletraderdetails S
		 JOIN CRM..TRefCountry Country ON Country.CountryCode = S.CountryCode
	WHERE CRMContactId = @CRMContactId

	UNION

	-- TPartnershipdetails countries
	SELECT 
		Country.CountryCode
	FROM TPartnershipdetails P
		 JOIN CRM..TRefCountry Country ON Country.CountryCode = P.CountryCode
	WHERE CRMContactId = @CRMContactId   
END
GO