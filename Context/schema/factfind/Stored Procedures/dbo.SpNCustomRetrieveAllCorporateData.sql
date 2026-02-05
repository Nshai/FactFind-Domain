SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAllCorporateData]
	@IndigoClientId int,    
	@UserId int,    
	@FactFindId int,
	@FrontPageAdviserCrmId int = 0 -- used by the pdf.
AS    
DECLARE @CRMContactId bigint, @AdviserId bigint, @AdviserCRMId bigint, @AdviserName varchar(255), @CRMContactType tinyint    

-- CRMContactIds
SELECT 
	@CRMContactId = CrmContactId1
FROM 
	TFactFind
WHERE 
	IndigoClientId = @IndigoClientId    
	AND FactFindId = @FactFindId    
        
-- Adviser    
SELECT     
	@AdviserId = A.PractitionerId,    
	@AdviserCRMId = A.CRMContactId,    
	@AdviserName = D.FirstName + ' ' + D.LastName    
FROM    
	CRM..TPractitioner A    
	JOIN CRM..TCRMContact C ON C.CurrentAdviserCRMId = A.CRMContactId -- The Client CRMContact record    
	JOIN CRM..TCRMContact D ON D.CRMContactId = A.CRMContactId   -- The Advisers CRMContact record    
WHERE    
	C.CRMContactId = @CRMContactId      
	AND C.IndClientId = @IndigoClientId      
	
-- Update the front page adviser details if one has not been provided.
IF @FrontPageAdviserCrmId = 0
	SET @FrontPageAdviserCrmId = @AdviserCRMId
	
-- Client Type    
SELECT @CRMContactType = CRMContactType FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId    

-- Retrieve fact find details    
SELECT * FROM TFactFind WHERE FactFindId=@FactFindId    

-- Client details    
SELECT      
	C.CRMContactId,    
	P.PersonId,    
	P.FirstName,    
	P.MiddleName,    
	P.LastName,    
	P.Salutation AS PreferredName,    
	CASE C.CRMContactType    
	WHEN 1 THEN P.FirstName + ' ' + P.LastName     
	ELSE C.CorporateName    
	END AS ClientName,    
	C.CRMContactType AS CRMContactType,    
	Corp.CorporateName AS CorporateName,    
	CGuid.Guid AS ClientGuid,    
	P.Title,    
	P.DoB AS DOB,    
	P.GenderType,    
	P.MaritalStatus,    
	P.MarriedOn AS MarriedOn,    
	P.UKResident,    
	P.Residency AS Residency,    
	P.UKDomicile,    
	P.Domicile AS Domicile,    
	P.Nationality,    
	P.IsSmoker Smoker,    
	P.NINumber,    
	P.TaxCode,    
	P.ConcurrencyId,    
	Rct.TypeName AS TypeName,    
	PExt.SharedFinances,     
	PExt.FinancialDependants, PExt.HasAssets, PExt.HasLiabilities,    
	Ed.EmploymentStatus,    
	Ed.Role As Occupation,    
	Ed.Employer,    
	Yt.PreferredRetirementAge,    
	H.GoodHealth    
FROM     
	CRM..TCRMContact C WITH(NOLOCK)    
	LEFT JOIN TDpGuid CGuid WITH(NOLOCK) ON CGuid.EntityId = C.CRMContactId AND CGuid.DpGuidTypeId = 2    
	LEFT JOIN CRM..TPerson P WITH(NOLOCK) ON P.PersonId = C.PersonId    
	LEFT JOIN FactFind..TPersonFFExt PExt WITH(NOLOCK) ON PExt.CRMContactId = C.CRMContactId    
	LEFT JOIN CRM..TCorporate Corp WITH(NOLOCK) ON Corp.CorporateId = C.CorporateId    
	LEFT Join CRM..TRefCorporateType Rct WITH(NOLOCK) ON Rct.RefCorporateTypeId = Corp.RefCorporateTypeId    
	LEFT JOIN FactFind..TEmploymentDetail Ed WITH(NOLOCK) ON Ed.CRMContactId = C.CRMContactId    
	LEFT JOIN FactFind..TYourRetirement Yt WITH(NOLOCK) ON Yt.CRMContactId = C.CRMContactId    
	LEFT JOIN FactFind..THealth H WITH(NOLOCK) ON H.CRMContactId = C.CRMContactId    
WHERE     
	C.CRMContactId = @CRMContactId    
	AND C.IndClientId=@IndigoClientId    

-- Corporate    
SELECT      
	C.CRMContactId AS GeneralBusinessDetailsId,    
	C.CRMContactId,    
	C.CorporateName,      
	C.CRMContactType AS CRMContactType,    
	CGuid.Guid AS ClientGuid,    
	C.ConcurrencyId,    
	Rct.TypeName AS TypeName,    
	Rct.TypeName AS LdpTypeName,    
	Corp.BusinessType AS BusinessType,    
	CAA.DateOfFirstAppointment AS Date1stAppointment      
FROM     
	CRM..TCRMContact C WITH(NOLOCK)    
	LEFT JOIN TDpGuid CGuid WITH(NOLOCK) ON CGuid.EntityId = C.CRMContactId AND CGuid.DpGuidTypeId = 2    
	LEFT JOIN CRM..TCorporate Corp WITH(NOLOCK) ON Corp.CorporateId = C.CorporateId    
	LEFT Join CRM..TRefCorporateType Rct WITH(NOLOCK) ON Rct.RefCorporateTypeId = Corp.RefCorporateTypeId    
	LEFT Join FactFind..TCorporateAdviceAreas CAA WITH(NOLOCK) ON C.CRMContactId=CAA.CRMContactId    
WHERE     
	C.CRMContactId =@CRMContactId    
	AND C.IndClientId=@IndigoClientId    

-- Addresses    
SELECT    
	AST.AddressStoreId AS AddressId,    
	A.CRMContactId,    
	A.RefAddressTypeId AS CorpAddressTypeId,
	AST.AddressLine1,    
	AST.AddressLine2,    
	AST.AddressLine3,    
	AST.AddressLine4,    
	AST.CityTown,    
	AST.Postcode,    
	AST.RefCountyId,
	AST.RefCountryId,
	A.DefaultFg AS IsDefault
FROM     
	CRM..TAddress A     
	JOIN CRM..TAddressStore AST ON A.AddressStoreId = AST.AddressStoreId AND AST.AddressLine1 IS NOT NULL    		
WHERE    
	A.CRMContactId = @CRMContactId
	AND A.IndClientId = @IndigoClientId
 
-- Corporate Contacts    
SELECT    
	C.ContactId CorporateContactsId,    
	C.CRMContactId,    
	ISNULL(CC.[Name],'') As 'Name',    
	C.[RefContactType],    
	C.[Value],    
	C.DefaultFg,    
	C.ConcurrencyId    
FROM 
	CRM..TContact C WITH(NOLOCK)    
	LEFT JOIN FactFind..TCorporateContact CC ON C.ContactId=CC.ContactId    
WHERE 
	C.CrmContactId =@CRMContactId    
	AND C.IndClientId=@IndigoClientId    

-- Table for Plan Types Details    
DECLARE @PlanDescription TABLE  (    
	PolicyBusinessId bigint not null PRIMARY KEY,    
	PolicyDetailId bigint not null,    
	CRMContactId bigint not null,    
	CRMContactId2 bigint null,    
	[Owner] varchar(16) not null,    
	OwnerCount int not null,    
	RefPlanType2ProdSubTypeId bigint NOT NULL,
	PlanType varchar(128) not null,    
	--FactFindSearchType varchar(64) not null,    
	RefProdProviderId bigint,    
	Provider varchar(128) not null,    
	PolicyNumber varchar(64) null,
	AgencyStatus varchar(50) null,
	StartDate datetime null,    
	MaturityDate datetime null,    
	StatusDate datetime not null,    
	Term tinyint null,        
	RegularPremium money null,    
	ActualRegularPremium money null,    
	TotalLumpSum money null,    
	TotalPremium money null,    
	Frequency varchar(32) null,    
	Valuation money null,    
	CurrentValue money null,    
	ValuationDate datetime,    
	ProductName varchar(255) null,    
	RefPlanTypeId bigint,    
	SellingAdviserId bigint,    
	SellingAdviserName varchar(255),    
	ConcurrencyId bigint null,
	PlanStatus varchar(50) null    
)    
 
-- Basic Plan Details    
INSERT INTO @PlanDescription    
SELECT    
	Pb.PolicyBusinessId,    
	Pd.PolicyDetailId,    
	POwn.CRMContactId,    
	POwn.CRMContactId2,    
	CASE POwn.OwnerCount    
		WHEN 1 THEN    
			CASE POwn.CRMContactId    
				WHEN @CRMContactId THEN 'Client 1'    
				ELSE 'Client 2'    
			END    
		ELSE 'Joint'        
	END,    
	POwn.OwnerCount,    
	PlanToProd.RefPlanType2ProdSubTypeId,
	CASE     
		WHEN LEN(ISNULL(Pst.ProdSubTypeName, '')) > 0 THEN  PType.PlanTypeName + ' (' + Pst.ProdSubTypeName + ')'    
		ELSE PType.PlanTypeName    
	END,     
	Rpp.RefProdProviderId,
	RppC.CorporateName,    
	Pb.PolicyNumber,
	Pbe.AgencyStatus,
	Pb.PolicyStartDate,    
	Pb.MaturityDate,    
	Sh.DateOfChange,    
	Pd.TermYears,    
	-- This is a fudge for one of the add/edit plan screens    
	CASE ISNULL(Contributions.Number, 0)    
		WHEN 1 THEN ISNULL(Pb.TotalLumpSum, 0) + ISNULL(Pb.TotalRegularPremium, 0)    
		ELSE ISNULL(Pb.TotalRegularPremium, 0)    
	END,    
	ISNULL(Pb.TotalRegularPremium, 0), -- Actual regular premium    
	ISNULL(Pb.TotalLumpSum, 0),    
	ISNULL(Pb.TotalLumpSum, 0) + ISNULL(Pb.TotalRegularPremium, 0),    
	Pb.PremiumType,    
	-- Valuation    
	Val.PlanValue,    
	-- CurrentValue    
	CASE
		WHEN Val.PlanValue IS NOT NULL THEN Val.PlanValue
		WHEN Fund.FundValue IS NOT NULL THEN Fund.FundValue
		ELSE ISNULL(Pb.TotalLumpSum, 0)    
	END,
	Val.PlanValueDate,    
	pb.ProductName,    
	pType.RefPlanTypeId,    
	pb.PractitionerId,    
	isnull(pracCRM.FirstName,'') + ' ' + isnull(pracCRM.LastName,''),    
	pb.ConcurrencyId,
	[Status].Name
FROM (    
	SELECT     
		COUNT(PolicyOwnerId) AS OwnerCount,
		PolicyDetailId,
		MIN(CRMCOntactId) AS CRMContactId,    
		CASE MAX(CRMContactId)    
			WHEN MIN(CRMContactId) THEN NULL    
			ELSE MAX(CRMContactId)    
		END AS CRMContactId2    
	FROM    
		PolicyManagement..TPolicyOwner WITH(NOLOCK)    
	WHERE    
		CRMContactId = @CRMContactId    
	GROUP BY    
		PolicyDetailId    
	) AS POwn
	JOIN PolicyManagement..TPolicyDetail Pd  WITH(NOLOCK) ON Pd.PolicyDetailId = POwn.PolicyDetailId    
	JOIN PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK)  ON Pb.PolicyDetailId = Pd.PolicyDetailId
	LEFT JOIN PolicyManagement..TPolicyBusinessExt Pbe WITH(NOLOCK) ON PBE.PolicyBusinessId = Pb.PolicyBusinessId
	JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1    
	JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType IN ('In Force', 'Paid Up')     
	JOIN PolicyManagement..TPlanDescription PDesc WITH(NOLOCK) ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId     
	JOIN PolicyManagement..TRefPlanType2ProdSubType PlanToProd WITH(NOLOCK) ON PlanToProd.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId     
	LEFT JOIN PolicyManagement..TProdSubType Pst WITH(NOLOCK) ON Pst.ProdSubTypeId = PlanToProd.ProdSubTypeId    
	JOIN PolicyManagement..TRefPlanType PType WITH(NOLOCK) ON PType.RefPlanTypeId = PlanToProd.RefPlanTypeId    
	JOIN PolicyManagement..TRefProdProvider Rpp WITH(NOLOCK) ON Rpp.RefProdProviderId = PDesc.RefProdProviderId     
	JOIN [CRM]..TCRMContact RppC WITH(NOLOCK) ON RppC.CRMContactId = Rpp.CRMContactId    
	JOIN [CRM]..TPractitioner prac WITH (NOLOCK) ON prac.PractitionerId = pb.PractitionerId    
	JOIN [CRM]..TCRMContact pracCRM WITH (NOLOCK) ON pracCRM.CRMContactId = prac.CRMContactId      
	-- Latest valuation    
	LEFT JOIN (    
		SELECT     
			PV.PolicyBusinessId, Max(PV.PlanValuationId) AS PlanValuationId    
		FROM     
			PolicyManagement..TPlanValuation PV
			JOIN @PlanDescription PD ON PD.PolicyBusinessId = PV.PolicyBusinessId
		GROUP BY     
			PV.PolicyBusinessId) AS LastVal ON LastVal.PolicyBusinessId = Pb.PolicyBusinessId      
	LEFT JOIN PolicyManagement..TPlanValuation Val ON Val.PlanValuationId = LastVal.PlanValuationId    
	-- Fund Price    
	LEFT JOIN (    
		SELECT       
			PBF.PolicyBusinessId,    
			SUM(ISNULL(CurrentPrice, 0) * ISNULL(CurrentUnitQuantity, 0)) AS FundValue    
		FROM    
			PolicyManagement..TPolicyBusinessFund PBF WITH(NOLOCK)     
			JOIN @PlanDescription PD ON PD.PolicyBusinessId = PBF.PolicyBusinessId
		GROUP BY PBF.PolicyBusinessId) AS Fund ON Fund.PolicyBusinessId = Pb.PolicyBusinessId    
	-- Look for single contribution    
	LEFT JOIN (    
		SELECT    
			PMI.PolicyBusinessId,    
			COUNT(*) AS Number    
		FROM    
			PolicyManagement..TPolicyMoneyIn PMI WITH(NOLOCK)        
			JOIN @PlanDescription PD ON PD.PolicyBusinessId = PMI.PolicyBusinessId
		GROUP BY    
			PMI.PolicyBusinessId) AS Contributions ON Contributions.PolicyBusinessId = Pb.PolicyBusinessId    

-- Protection                              
SELECT DISTINCT
	Pd.PolicyBusinessId as ProtectionPlansId,                              
	Pd.PolicyBusinessId,                                 	
	Pd.CRMContactId, 
	Pd.CRMContactId2,
	Pd.[Owner],  
	pd.SellingAdviserId,                        
	pd.SellingAdviserName,    
	Pd.RefProdProviderId,                              
	Pd.PolicyNumber,
	Pd.AgencyStatus,
	Pd.RefPlanType2ProdSubTypeId,                                
	Pd.StartDate as ProtectionStartDate,   
	Pd.MaturityDate,                              
	Pd.RegularPremium,                              
	ISNULL(Pd.Frequency, Yf.FrequencyName) AS PremiumFrequency,                        
	GI.SumAssured,
	-- Just take majority of benefits from the 1st life (data should be the same for 2nd for the fields that FF cares about)
	B1.BenefitAmount,                              
	B1.RefFrequencyId AS BenefitFrequencyId,                              	
	P.CriticalIllnessSumAssured as CriticalIllnessAmount,       
	P.LifeCoverSumAssured AS LifeCoverAmount,                       
	AL1.PartyId AS LifeAssuredId,                              
	B1.BenefitDeferredPeriod,                          
	B1.RefBenefitPeriodId,       
	P.PaymentBasisId AS RefPaymentBasisId,                     
	P.InTrust AS AssignedInTrust,
	pd.ConcurrencyId,
	Pd.PlanStatus                                                 	                          
FROM                              
	@PlanDescription Pd                               
	JOIN TRefPlanTypeToSection PTS WITH(NOLOCK) ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId
	-- Protection details should always be available but...
	LEFT JOIN PolicyManagement..TProtection P WITH(NOLOCK) ON P.PolicyBusinessId = Pd.PolicyBusinessId                              
	LEFT JOIN PolicyManagement..TGeneralInsuranceDetail GI WITH(NOLOCK) ON GI.ProtectionId = P.ProtectionId AND GI.RefInsuranceCoverCategoryId = 5 -- Payment Protection
	-- Life assured 1
	LEFT JOIN PolicyManagement..TAssuredLife AL1 WITH(NOLOCK) ON AL1.ProtectionId = P.ProtectionId AND AL1.OrderKey = 1 
	LEFT JOIN PolicyManagement..TBenefit B1 WITH(NOLOCK) ON B1.BenefitId = AL1.BenefitId
	-- Your Contribution                              
	LEFT JOIN (      
		SELECT 
			MIN(A.PolicyMoneyInId) AS PolicyMoneyInId,
			A.PolicyBusinessId      
		FROM 
			Policymanagement..TPolicyMoneyIn A WITH(NOLOCK)      
			JOIN @PlanDescription Pd ON Pd.PolicyBusinessId=A.PolicyBusinessId      
		WHERE 
			A.RefContributorTypeId=1      
		GROUP BY 
			A.PolicyBusinessId) AS YcMin ON Pd.PolicyBusinessId=YcMin.PolicyBusinessId   
	LEFT JOIN Policymanagement..TPolicyMoneyIn Yc WITH(NOLOCK) ON Yc.PolicyMoneyInId=YcMin.PolicyMoneyInId      
	LEFT JOIN Policymanagement..TRefContributorType Yct WITH(NOLOCK) ON Yct.RefContributorTypeId = Yc.RefContributorTypeId AND Yct.RefContributorTypeName = 'Self'                              
	LEFT JOIN Policymanagement..TRefFrequency Yf WITH(NOLOCK) ON Yf.RefFrequencyId=Yc.RefFrequencyId                                                    
WHERE 
	PTS.Section = 'Protection'
	AND @CRMContactType = 3    
 
-- Adviser Details                              
EXEC [SpNCustomRetrieveAdviserDetails] @IndigoClientId, @FrontPageAdviserCrmId

-- Indigo Client    
SELECT     
	I.*
FROM     
	Administration..TIndigoClient I WITH(NOLOCK)    
WHERE    
	IndigoClientId = @IndigoClientId    

-- current user adviser data (for lookups)    
--MT: Changed so that if user is a portal User it will get user the portal Users Selling adviser    
SELECT       
	CASE u.RefUserTypeId     
	  WHEN 1 THEN ISNULL(p.PractitionerId, 0)    
	  ELSE @AdviserId    
	END AS SellingAdviserId,    

	CASE u.RefUserTypeId     
	  WHEN 1 THEN u.CRMContactId    
	  ELSE @AdviserCRMId    
	END AS SellingAdviserCRMId,    

	CASE u.RefUserTypeId     
	  WHEN 1 THEN isnull(c.FirstName,'') + ' ' + isnull(c.LastName ,'')    
	  ELSE @AdviserName    
	END AS SellingAdviserName      
FROM	
	Administration..TUser u     
	INNER JOIN CRM..TCRMContact c ON c.CRMContactId = u.CRMContactId    
	LEFT JOIN CRM..TPractitioner p ON p.CRMContactId = u.CRMContactId    
WHERE 
	u.UserId = @UserId    

SELECT * FROM Tauthorisedcompanyprofessionals WHERE CRMContactId = @CRMContactId    
SELECT * FROM TauthorisedcompanyprofessionalsNotes WHERE CRMContactId = @CRMContactId    
SELECT * FROM TBusinessAssets WHERE CRMContactId = @CRMContactId    
SELECT * FROM TBusinessInvestmentNeed WHERE CRMContactId = @CRMContactId    
SELECT * FROM TBusinessInvestmentNeedsNotes WHERE CRMContactId = @CRMContactId    
SELECT CorporateAdviceAreasId, CRMContactId, AdviceType, PA, RPA, SIA, DateOfFirstAppointment FROM TCorporateAdviceAreas WHERE CRMContactId = @CRMContactId    
SELECT * FROM TCorporateLiability WHERE CRMContactId = @CRMContactId    
SELECT * FROM TCorporateLiabilityNotes WHERE CRMContactId = @CRMContactId    
SELECT * FROM TCorporateProtection WHERE CRMContactId = @CRMContactId    

SELECT DirectorSharesInfoId, CRMContactId, AgreementForSharesYesNo, AgreementForSharesType, PowerToPurchaseSharesYesNo, Notes, ConcurrencyId FROM TDirectorSharesInfo WHERE CRMContactId = @CRMContactId    
SELECT * FROM TEmployeeBenefit WHERE CRMContactId = @CRMContactId    
SELECT * FROM TEmployeeBenefitCont WHERE CRMContactId = @CRMContactId    
SELECT * FROM TEmployeeCategories WHERE CRMContactId = @CRMContactId    
SELECT EmployeeCategories2Id, CRMContactId, ComputerisedPayroll, TotalSalaryRoll, StaffingLevelsIncreasing, ReviewDate, EmployeesAffiliatedToTradeUnion, TradeUnionAgreementNeeded FROM TEmployeeCategories2 WHERE CRMContactId = @CRMContactId
SELECT EmployeeInformationId, CRMContactId, NumOfFTEmp, NumOfPTEmp, NumOfEmpBelow20, NumOfEmp20_29 AS NumOfEmpFrom20To29, NumOfEmp30_39 AS NumOfEmpFrom30To39, NumOfEmp40_49 AS NumOfEmpFrom40To49, NumOfEmp50_59 AS NumOfEmpFrom50To59, NumOfEmp60_over AS NumOfEmp60OrOver FROM TEmployeeInformation WHERE CRMContactId = @CRMContactId    
SELECT * FROM TFinancialSituation WHERE CRMContactId = @CRMContactId    
SELECT * FROM TFinancialSituationDetail WHERE CRMContactId = @CRMContactId    
SELECT * FROM TFundsAvailableFor WHERE CRMContactId = @CRMContactId    
SELECT * FROM TInvestmentRiskProfileCorporate WHERE CRMContactId = @CRMContactId    
SELECT * FROM TKeyEmployeesToBeProtected WHERE CRMContactId = @CRMContactId    
SELECT * FROM TLimitedCompanyDetailsCont WHERE CRMContactId = @CRMContactId    
SELECT * FROM Tlimitedcompanyshareholders WHERE CRMContactId = @CRMContactId    

SELECT     
	*     
FROM     
	CRM..TCorporate c1     
	INNER JOIN CRM..TCRMContact c2 ON c1.CorporateId = c2.CorporateId    
WHERE     
	c2.CRMContactId = @CRMContactId    


SELECT * FROM TNonOccupationalScheme WHERE CRMContactId = @CRMContactId    
SELECT * FROM TOccupationalScheme WHERE CRMContactId = @CRMContactId    
SELECT * FROM TOccupationNotes WHERE CRMContactId = @CRMContactId    
SELECT *, DOB as DateOfBirth FROM Tpartnershipdetails WHERE CRMContactId = @CRMContactId    
SELECT PartnershipdetailsgeneralId, CRMContactId, PartnershipYesNo, PartnershipDetailsGeneralYesNo, PartnershipDetailsGeneralType, PlansToIncorporateYesNo, Notes FROM Tpartnershipdetailsgeneral WHERE CRMContactId = @CRMContactId    
SELECT * FROM TPensionContributions WHERE CRMContactId = @CRMContactId    
SELECT * FROM TPensionContributionsDetails WHERE CRMContactId = @CRMContactId    
SELECT SoletraderdetailsId AS SoleTraderDetailsId, CRMContactId,Name,AddressLine1,AddressLine2,AddressLine3,AddressLine4,CityTown,
Postcode,CountryCode,CountyCode,Smoker,DOB AS DateOfBirth,HasFamilyMembers,FamilyMemberName,FamilyMemberRelationship,FamilyMemberDuties,
IncorporateYesNo,Value AS Notes,InGoodHealth,AnyoneNeedProtection,ConcurrencyId
FROM Tsoletraderdetails WHERE CRMContactId = @CRMContactId    
SELECT * FROM TSpecialProjects WHERE CRMContactId = @CRMContactId    
SELECT * FROM TYourCurrentPlanners WHERE CRMContactId = @CRMContactId    
SELECT * FROM CRM..TMarketing WHERE CRMContactId = @CRMContactId
SELECT * FROM TCorporateCurrentProtectionNotes WHERE CRMContactId IN (@CRMContactId)     
SELECT * FROM TGeneralBusinessDetailsNotes WHERE CRMContactId = @CRMContactId    

--Corporate LDP Tables      
SELECT * FROM TCorporateProfileNotes WHERE CRMContactId =@CRMContactId      
SELECT * FROM TClub WHERE CRMContactId=@CRMCOntactId      
SELECT * FROM TFamilyMembers WHERE CRMContactId=@CRMCOntactId      
SELECT * FROM TPartnership WHERE CRMContactId=@CRMContactId    
SELECT * FROM TPartnershipKeyEmployees WHERE CRMContactId=@CRMContactId    
SELECT * FROM TLimitedCompany WHERE CRMContactId=@CRMContactId    
SELECT * FROM TClubOfficals WHERE CRMContactId=@CRMContactId    
SELECT * FROM TClientTypeNotes WHERE CRMContactId=@CRMContactId    
SELECT * FROM TFinancialNotes WHERE CRMContactId=@CRMContactId    
SELECT * FROM TLimitedCompanyKeyEmployees WHERE CRMContactId=@CRMContactId    
SELECT * FROM TCorporateOperationalAddress WHERE CRMContactId=@CRMContactId    

-- Atr 
SELECT * FROM TATRInvestmentCategory where CRMContactId = @CRMContactId
SELECT * FROM TAtrInvestment WHERE CRMContactId=@CRMContactId    
SELECT * FROM TAtrInvestmentGeneral WHERE CRMContactId=@CRMContactId    

-- Get org address details
EXEC Administration..[SpNCustomGetOrganisationNameAndAddressForReport] 'Fact Find', @FrontPageAdviserCrmId, 'Organisation', @IndigoClientId                                                      
 
--AJF #19025 - wasn't retrieving this but was saving it, and there are several instances of    
--multiple rows for crmcontacts, so this pulls the most recent one    
--to save removing the data in case we need to restore it    
SELECT top 1 
	* 
FROM 
	TRetirePlanningExisting     
WHERE 
	CRMContactId=@CRMContactId     
order by 
	RetirePlanningExistingId desc    
	
-- Needs and Priorities		
SELECT * FROM TNeedsAndPrioritiesAnswer WHERE CRMContactId = @CRMContactId

-- Declaration + Disclosure
SELECT
	DeclarationId,
	CRMContactId,
	-- these fields are free text but users often store dates in them - format dates correctly but return everything else as text
	CASE
		WHEN CompletedDate IS NULL THEN FactFind.dbo.fn_GetCompletedDate (@CRMContactId,'Date Fact Find Completed', @IndigoClientId)
		ELSE CompletedDate
	END AS CompletedDate,
	CASE
		WHEN DeclarationDate IS NULL THEN FactFind.dbo.fn_GetCompletedDate (@CRMContactId,'Date Declaration Signed', @IndigoClientId)
		ELSE DeclarationDate
	END AS DeclarationDate,
	ConcurrencyId
FROM
	FactFind..TDeclaration a
WHERE
	CRMContactId = @CRMContactId

SELECT * FROM TDeclarationNotes WHERE CRMContactId = @CRMContactId

-- Get credited group address
SELECT 
    CONCAT_WS(
        ', ',
		TRIM(NULLIF(addressstore.AddressLine1, '')),
		TRIM(NULLIF(addressstore.AddressLine2, '')),
		TRIM(NULLIF(addressstore.AddressLine3, '')),
		TRIM(NULLIF(addressstore.AddressLine4, '')),
		TRIM(NULLIF(addressstore.CityTown, '')),
		TRIM(NULLIF(county.CountyName, '')),
		TRIM(NULLIF(country.CountryName, '')),
		TRIM(NULLIF(addressstore.Postcode, ''))
    ) AS creditGroupAddress
FROM Crm..TCRMContact AS c
INNER JOIN Crm..TCRMContactExt AS crmExt ON crmExt.CrmContactId = c.CRMContactId
INNER JOIN Administration..TGroup AS groupData ON groupData.GroupId = crmExt.CreditedGroupId
INNER JOIN Crm..TAddress AS addr ON addr.CRMContactId = groupData.CRMContactId
INNER JOIN Crm..TAddressStore AS addressstore ON addressstore.AddressStoreId = addr.AddressStoreId
LEFT JOIN Crm..TRefCounty AS county ON addressstore.RefCountyId = county.RefCountyId
LEFT JOIN Crm..TRefCountry AS country ON addressstore.RefCountryId = country.RefCountryId
WHERE c.CrmContactId = @CRMContactId AND c.IndClientId = @IndigoClientId AND addr.DefaultFg = 1

GO
