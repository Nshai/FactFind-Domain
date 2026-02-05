SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SpNCustomRetrieveAllPersonalData]
	 @IndigoClientId int,
	 @UserId int,
	 @FactFindId int,
	 @ExcludePlanPurposes BIT = 0,
	 @FrontPageAdviserCrmId int = 0, -- used by the pdf.
	 @CurrentUserDate datetime
AS
BEGIN
SET DATEFORMAT dmy
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
DECLARE
	@CRMContactId int, @CRMContactId2 int, @AdviserId int, @AdviserCRMId int, @AdviserName varchar(255),
	@PreExistingAdviserId bigint, @PreExistingAdviserName varchar(255), @PreExistingAdviserCRMId bigint,
	@NewId bigint, @TenantId int, @Now datetime = @CurrentUserDate, @Today datetime = DATEADD(d, DATEDIFF(d, 0, @CurrentUserDate), 0),
	@AdviserUserId int, @AdviserGroupId bigint, @IncomeReplacementRate smallint, @UserIncomeReplacementRate smallint,
	@UseLiabilitiesInExpenditure bit = 0, @ShowTopupsAsDistinctPlans bit, @BOND_ID bigint = 44, @RegionalCurrency nchar(3),
	@IsNewAtr bit = 0, @LastAtrInvestmentTemplateId bigint, @LastAtrRetirementTemplateId bigint, @Client2AgreesWithAnswers BIT;


DECLARE @MaxLevel tinyint, @Level int
DECLARE @crmcontact1PolicyId int
DECLARE @crmcontact2PolicyId int
DECLARE @AssetIdsString varchar(max);
DECLARE @TemplateGuid uniqueidentifier, @TemplateBaseGuid uniqueidentifier, @TemplateId bigint
DECLARE @FactFindShowNotAnsweredAdditionalRiskQuestions varchar(10)
DECLARE @IsAnyRetirementAnswers bit, @IsAnyInvestmentAnswers bit

DECLARE @AtrTemplateIds TABLE (AtrTemplateId bigint, AtrTemplateGuid UNIQUEIDENTIFIER, BaseAtrTemplateGuid UNIQUEIDENTIFIER, BaseAtrTemplateId bigint);

-- Table for plan list
DECLARE @PlanList TABLE (BusinessId bigint PRIMARY KEY, DetailId bigint)

-- Table for Plan Types Details
DECLARE @Plans TABLE
(
	[SortId] int IDENTITY(1,1),
	[PolicyBusinessId] bigint not null PRIMARY KEY,
	[PolicyDetailId] bigint not null,
	[CRMContactId] bigint not null,
	[CRMContactId2] bigint null,
	[Owner] varchar(16) not null,
	[OwnerCount] int not null,
	[RefPlanType2ProdSubTypeId] bigint not NULL,
	[PlanType] varchar(128) not null,
	[ProdSubType] varchar(128) null,
	[UnderlyingPlanType] varchar(128) not null,
	[RefProdProviderId] bigint not null,
	[Provider] varchar(128) not null,
	[PolicyNumber] varchar(64) null,
	[AgencyStatus] varchar(50) null,
	[PlanCurrency] varchar(3) null,
	[StartDate] datetime null,
	[MaturityDate] datetime null,
	[StatusDate] datetime null,
	[Term] tinyint null,
	[RegularPremium] money null,
	[TotalLumpSum] money null,
	[Frequency] varchar(32) null,
	[Valuation] money null,
	[CurrentValue] money null,
	[ValuationDate] datetime,
	[ProductName] varchar(255) null,
	[RefPlanTypeId] bigint,
	[SellingAdviserId] bigint,
	[SellingAdviserName] varchar(255),
	[PlanPurpose] varchar(255),
	[ExcludeValuation] bit,
	[ConcurrencyId] bigint null,
	[PlanStatus] varchar(50) null,
	[MortgageRepayPercentage] money null,
	[MortgageRepayAmount] money null,
	[IsGuaranteedToProtectOriginalInvestment] bit null,
	[ParentPolicyBusinessId] bigint,
	[LinkedToPolicyNumber] varchar(50),
	[LinkedToPlanTypeProvider] varchar(500),
	[TopupMasterPolicyBusinessId] bigint,
	[IncludeTopupPremiums] bit,
	[IsWrapper] bit,
	[EstatePlanningValue] money,
	[PlanValueTypeId] tinyint,
	[IsTopLevelBond] bit,
	[RegularPremiumWithTopups] money null,
	[TotalLumpSumWithTopups] money null,
	[FrequencyWithTopups] varchar(32) null,
	[AdditionalNotes] varchar(1000) null,
	INDEX IX_Plans_SortId NONCLUSTERED ([SortId]),
	INDEX ix_Plans_UnderlyingPlanType NONCLUSTERED ([UnderlyingPlanType]),
	INDEX ix_Plans_ParentPolicyBusinessId NONCLUSTERED ([ParentPolicyBusinessId])
)

DECLARE @AtrInvestmentGeneral TABLE (
	[AtrInvestmentGeneralSyncId] [int] NULL,
	[AtrInvestmentGeneralId] [int] NOT NULL,
	[CRMContactId] [int] NOT NULL,
	[Client2AgreesWithAnswers] [bit] NULL,
	[Client1AgreesWithProfile] [bit] NULL,
	[Client2AgreesWithProfile] [bit] NULL,
	[Client1ChosenProfileGuid] [uniqueidentifier] NULL,
	[Client2ChosenProfileGuid] [uniqueidentifier] NULL,
	[ConcurrencyId] [int] NOT NULL,
	[Client1Notes] [varchar] (5000) NULL,
	[Client2Notes] [varchar] (5000)  NULL,
	[InconsistencyNotes] [varchar] (5000) NULL,
	[CalculatedRiskProfile] [uniqueidentifier] NULL,
	[RiskDiscrepency] [int] NULL,
	[RiskProfileAdjustedDate] [datetime] NULL,
	[AdviserNotes] [varchar] (max) NULL,
	[DateOfRiskAssessment] [date] NULL,
	[WeightingSum] [int] NULL,
	[LowerBand] [int] NULL,
	[UpperBand] [int] NULL,
	[TemplateId] [int] NULL,
	[BaseAtrTemplateId] [int] NULL
)

DECLARE @AtrRetirementGeneral TABLE (
	[AtrRetirementGeneralSyncId] [int] NULL,
	[AtrRetirementGeneralId] [int] NOT NULL,
	[TAtrRetirementGeneralId] [int] NULL,
	[CRMContactId] [int] NOT NULL,
	[Client2AgreesWithAnswers] [bit] NULL,
	[Client1AgreesWithProfile] [bit] NULL,
	[Client2AgreesWithProfile] [bit] NULL,
	[Client1ChosenProfileGuid] [uniqueidentifier] NULL,
	[Client2ChosenProfileGuid] [uniqueidentifier] NULL,
	[ConcurrencyId] [int] NOT NULL,
	[Client1Notes] [varchar] (5000) NULL,
	[Client2Notes] [varchar] (5000) NULL,
	[InconsistencyNotes] [varchar] (5000) NULL,
	[CalculatedRiskProfile] [uniqueidentifier] NULL,
	[RiskDiscrepency] [int] NULL,
	[RiskProfileAdjustedDate] [datetime] NULL,
	[AdviserNotes] [varchar] (max) NULL,
	[DateOfRiskAssessment] [date] NULL,
	[WeightingSum] [int] NULL,
	[LowerBand] [int] NULL,
	[UpperBand] [int] NULL,
	[TemplateId] [int] NULL,
	[BaseAtrTemplateId] [int] NULL
)

DECLARE @Contributions TABLE (PolicyBusinessId bigint, TypeId int, ContributorTypeId int, Amount money, 
	RefFrequencyId int, FrequencyName varchar(50), StartDate datetime, StopDate datetime, FirstId bigint)

DECLARE @AssetCurrentValues TABLE(AssetId int, AssetValuationHistoryId int, Valuation money, ValuationDate DateTime);

DECLARE @Opps TABLE (Id bigint)

---------------------------------------------------------------------------------
-- Get some initial settings
---------------------------------------------------------------------------------

SET @TenantId = @IndigoClientId

SELECT @RegionalCurrency = administration.dbo.FnGetRegionalCurrency()

SELECT
	@PreExistingAdviserId = PractitionerId,
	@PreExistingAdviserName = PractitionerName
FROM
	Compliance..TPreExistingAdviser
WHERE
	IndigoClientId = @TenantId And isFactFind = 1

IF @PreExistingAdviserId IS NOT NULL
	SELECT @PreExistingAdviserCRMId = CRMContactId FROM CRM..TPractitioner WHERE PractitionerId = @PreExistingAdviserId

-- CRMContacts
SELECT
	@CRMContactId = CrmContactId1,
	@CRMContactId2 = CrmContactId2
FROM
	factfind.dbo.TFactFind
WHERE
	IndigoClientId = @TenantId AND FactFindId = @FactFindId

IF @CRMContactId2 = 0
	SET @CRMContactId2 = NULL

-- Get current servicing adviser details
SELECT
	@AdviserId = A.PractitionerId,
	@AdviserCRMId = A.CRMContactId,
	@AdviserName = C.CurrentAdviserName,
	@AdviserUserId = U.UserId,
	@AdviserGroupId = U.GroupId
FROM
	CRM..TCRMContact C -- The Client CRMContact record
	JOIN CRM..TPractitioner A ON A.CRMContactId = C.CurrentAdviserCRMId
	JOIN Administration..TUser U ON U.CRMContactId = A.CRMContactId
WHERE
	C.CRMContactId = @CRMContactId
	AND C.IndClientId = @TenantId

-- Update the front page adviser details if one has not been provided.
IF @FrontPageAdviserCrmId = 0
	SET @FrontPageAdviserCrmId = @AdviserCRMId

-- Get topup preference for the adviser's legal entity.
SET @ShowTopupsAsDistinctPlans = CAST(ISNULL(Administration.dbo.FnCustomGetGroupPreference(@AdviserGroupId, 'ShowTopupsInFactFind'), 0) AS bit)

SELECT @UseLiabilitiesInExpenditure = ISNULL(HasFactFindLiabilitiesImported, 0)
FROM factfind.dbo.TExpenditure
WHERE CRMContactId = @CRMContactId

-- Income replacement rate for user and group.
SET @IncomeReplacementRate = ISNULL(Administration.dbo.FnCustomGetGroupPreference(@AdviserGroupId, 'FactFindIncomeReplacementRate'), 10)
SET @UserIncomeReplacementRate = Administration.dbo.FnCustomGetUserPreference(@AdviserUserId, 'FactFindIncomeReplacementRate')

-- Allow user override?
IF Administration.dbo.FnCustomGetGroupPreference(@AdviserGroupId, 'FactFindAdviserOverride') = 'True' AND @UserIncomeReplacementRate IS NOT NULL
	SET @IncomeReplacementRate = @UserIncomeReplacementRate

---------------------------------------------------------------------------------
-- Start retrieving all data....
---------------------------------------------------------------------------------
SELECT
	*,
	ISNULL(Administration.dbo.FnCustomGetUserPreference(@UserId, 'FactFindSalutationEnabled'), 'False') AS UseSalutation,
	@UseLiabilitiesInExpenditure AS UseLiabilitiesInExpenditure,
	Administration.dbo.FnCustomTenantHasPreference(@IndigoClientId, 'UseNetAmountForIncomeReplacement', 'True') AS UseNetAmountInProtectionSummary
FROM
	TFactFind
WHERE
	FactFindId = @FactFindId

-- Client details
SELECT
	C.CRMContactId,
	P.PersonId,
	P.FirstName,
	P.MiddleName,
	P.LastName,
	CASE C.CRMContactType
		WHEN 1 THEN CONCAT(P.FirstName, ' ', P.LastName)
		ELSE C.CorporateName
	END AS ClientName,
	C.CRMContactType AS CRMContactType,
	Corp.CorporateName AS CorporateName,
	P.Title,
	P.DoB AS DOB,
	P.GenderType,
	P.MaidenName,
	P.MaritalStatus,
	P.MaritalStatusSince,
	P.NINumber,
	P.UKResident,
	P.Residency AS Residency,
	P.UKDomicile,
	P.Domicile AS Domicile,
	P.Expatriate,
	P.TaxCode,
	P.ConcurrencyId,
	CAST(CASE P.IsSmoker WHEN 'Yes' THEN 1 WHEN 'No' THEN 0 END AS bit) AS IsSmoker,
	P.IsInGoodHealth,
	P.HasSmokedInLast12Months,
	Rct.TypeName AS TypeName,
	PExt.SharedFinances,
	PExt.FinancialDependants, PExt.HasAssets, PExt.HasLiabilities,
	P.RefNationalityId,
	P.IsPowerOfAttorneyGranted,
	P.AttorneyName,
	P.Salutation,
	P.IsDisplayTitle,
	P.CountryCodeOfResidence,
	P.CountryCodeOfDomicile,
	PE.HealthNotes,
	PE.MedicalConditionNotes,
	PE.HasOtherConsiderations,
	PE.OtherConsiderationsNotes,
	V.CountryOfBirth,
	V.PlaceOfBirthOther,
	p.EverSmoked,
	p.HasVapedorUsedEcigarettesLast1Year,
	p.HaveUsedNicotineReplacementProductsLast1Year
FROM
	CRM..TCRMContact C
	LEFT JOIN CRM..TPerson P ON P.PersonId = C.PersonId
	LEFT JOIN CRM..TPersonExt PE ON PE.PersonId = P.PersonId
	LEFT JOIN FactFind..TPersonFFExt PExt ON PExt.CRMContactId = C.CRMContactId
	LEFT JOIN CRM..TCorporate Corp ON Corp.CorporateId = C.CorporateId
	LEFT JOIN CRM..TRefCorporateType Rct ON Rct.RefCorporateTypeId = Corp.RefCorporateTypeId
	LEFT JOIN CRM..TVerification V ON V.CRMContactId = C.CRMContactId
WHERE
	C.IndClientId = @TenantId AND C.CRMContactId IN (@CRMContactId, @CRMContactId2)
ORDER BY (CASE WHEN C.CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

-- Get all of the address details for 1 and 2.
SELECT
	AST.AddressStoreId AS AddressId,
	A.CRMContactId,
	A.RefAddressTypeId,
	ISNULL(A.AddressTypeName, RAT.AddressTypeName) AS AddressTypeName,
	A.DefaultFg AS IsDefault,
	A.IsRegisteredOnElectoralRoll,
	AST.AddressLine1,
	AST.AddressLine2,
	AST.AddressLine3,
	AST.AddressLine4,
	AST.CityTown,
	AST.Postcode,
	AST.RefCountryId,
	AST.RefCountyId,
	A.RefAddressStatusId,
	CONVERT(date, ResidentFromDate) AS ResidentFromDate,
	CONVERT(date, ResidentToDate) AS ResidentToDate,
	AST.ConcurrencyId,
	A.ResidencyStatus,
	-- Only calculate time at address for CURRENT addresses.
	CASE
		WHEN A.RefAddressStatusId = 1 AND ResidentFromDate <= @Now
		THEN dbo.FnDifferenceTotalMonths(ResidentFromDate, @Now)
	END AS TimeAtAddress
FROM
	CRM..TAddress A
	JOIN CRM..TAddressStore AST ON A.AddressStoreId = AST.AddressStoreId
	LEFT JOIN CRM..TRefAddressType RAT ON RAT.RefAddressTypeId = A.RefAddressTypeId
WHERE
	A.IndClientId = @TenantId
	AND AST.AddressLine1 IS NOT NULL
	AND A.CRMContactId IN (@CRMContactId, @CRMContactId2)
	AND A.RefAddressTypeId <> 3
ORDER BY
	A.CRMContactId, ast.AddressStoreId

-- Contacts
SELECT
	C.ContactId ContactsId,
	C.CRMContactId,
	CASE CRMContactId
		WHEN @CRMContactId THEN 'Client 1'
		ELSE 'Client 2'
	END AS Owner,
	C.[RefContactType],
	C.[Value],
	C.[Description],
	C.DefaultFg,
	C.ConcurrencyId
FROM
	CRM..TContact C
WHERE
	C.IndClientId = @TenantId AND
	C.CrmContactId IN (@CRMContactId, @CRMContactId2)
ORDER BY Owner, ContactsId

-- DPA Agreement
IF EXISTS (SELECT 1 FROM dpa.dbo.TAgreement a WHERE a.TenantId = @TenantId AND CRMContactId = @CRMContactId)
BEGIN
	SET @crmcontact1PolicyId = (
		SELECT  TOP 1  a.PolicyId
		FROM dpa.dbo.TAgreement a
		WHERE a.TenantId = @TenantId AND a.CRMContactId = @CRMContactId
		ORDER  BY a.AgreementId DESC
	)
END
ELSE
BEGIN
	SET @crmcontact1PolicyId  = (SELECT  TOP 1  PolicyId
		FROM dpa..TPolicy P
		WHERE P.TenantId = @TenantId ANd P.IsDeleted = 0 AND P.PartyType = 'Person'
		ORDER BY CreationDate desc)
	IF(@crmcontact1PolicyId IS NULL)
	SET @crmcontact1PolicyId  = (SELECT  TOP 1  PolicyId
		FROM dpa..TPolicy P
		WHERE P.TenantId = @TenantId ANd P.IsDeleted = 0 AND P.PartyType IS NULL
		ORDER BY CreationDate desc)

END

-- Get Active Policy for Client 2
IF @crmcontactId2 is not null
BEGIN
	IF EXISTS (SELECT 1 FROM dpa.dbo.TAgreement a WHERE a.TenantId = @TenantId AND a.CRMContactId = @CRMContactId2)
	BEGIN
		SET  @crmcontact2PolicyId = (
			SELECT  TOP 1  a.PolicyId
			FROM dpa.dbo.TAgreement a
			WHERE a.TenantId = @TenantId AND a.CRMContactId = @CRMContactId2
			ORDER BY a.AgreementId DESC
		)
	END
	ELSE
	BEGIN
		SET @crmcontact2PolicyId  = (SELECT  TOP 1 PolicyId
		FROM dpa..TPolicy P
		WHERE P.TenantId = @TenantId ANd P.IsDeleted = 0 AND P.PartyType = 'Person'
		ORDER BY CreationDate desc)
	IF(@crmcontact2PolicyId IS NULL)
	SET @crmcontact2PolicyId  = (SELECT  TOP 1  PolicyId
		FROM dpa..TPolicy P
		WHERE P.TenantId = @TenantId ANd P.IsDeleted = 0 AND P.PartyType IS NULL
		ORDER BY CreationDate desc)
	END
END

SELECT a.AgreementId
    , a.Owner
    , a.CRMContactId
    , a.AgreementDate
    , a.Statement1
    , a.Statement2
    , a.Statement3
    , a.Statement4
    , a.Statement5
    , a.Statement1Answer
    , a.Statement2Answer
    , a.Statement3Answer
    , a.Statement4Answer
    , a.Statement5Answer
FROM (
    SELECT a.AgreementId
        , 'Client 1' AS Owner
        , @CRMContactId AS CrmContactId
        , a.AgreementDate
        , ISNULL(a.Statement1, p.Statement1) AS Statement1
        , ISNULL(a.Statement2, p.Statement2) AS Statement2
        , ISNULL(a.Statement3, p.Statement3) AS Statement3
        , ISNULL(a.Statement4, p.Statement4) AS Statement4
        , ISNULL(a.Statement5, p.Statement5) AS Statement5
        , a.Statement1Answer
        , a.Statement2Answer
        , a.Statement3Answer
        , a.Statement4Answer
        , a.Statement5Answer
        , ROW_NUMBER() OVER(PARTITION BY a.CrmContactid ORDER BY a.AgreementId DESC) AS RowNumber
    FROM  dpa.dbo.TPolicy p
    LEFT JOIN dpa.dbo.TAgreement A ON a.PolicyID = p.PolicyId AND a.TenantId = @IndigoClientId AND a.CrmContactId = @CRMContactId
    WHERE p.PolicyId = @crmcontact1PolicyId
    UNION
    SELECT a.AgreementId
        , 'Client 2' AS Owner
        , @CRMContactId2 AS CrmContactId
        , a.AgreementDate
        , ISNULL(a.Statement1, p.Statement1) AS Statement1
        , ISNULL(a.Statement2, p.Statement2) AS Statement2
        , ISNULL(a.Statement3, p.Statement3) AS Statement3
        , ISNULL(a.Statement4, p.Statement4) AS Statement4
        , ISNULL(a.Statement5, p.Statement5) AS Statement5
        , a.Statement1Answer
        , a.Statement2Answer
        , a.Statement3Answer
        , a.Statement4Answer
        , a.Statement5Answer
        , ROW_NUMBER() OVER(PARTITION BY a.CrmContactid ORDER BY a.AgreementId DESC) AS RowNumber
    FROM dpa.dbo.TPolicy p
    LEFT JOIN dpa.dbo.TAgreement A ON a.PolicyID = p.PolicyId AND a.TenantId = @IndigoClientId AND a.CrmContactId = @CRMContactId2
    WHERE p.PolicyId = @crmcontact2PolicyId
) AS a
WHERE a.RowNumber = 1
ORDER BY a.Owner, a.AgreementId;

-- Get a list of plan ids for these clients

INSERT INTO @PlanList
SELECT DISTINCT
	PB.PolicyBusinessId, PB.PolicyDetailId
FROM
	 PolicyManagement..TPolicyOwner PO
	 JOIN PolicyManagement..TPolicyBusiness PB ON PB.PolicyDetailId = PO.PolicyDetailId
WHERE
	CRMContactId IN (@CRMContactId, @CRMContactId2)

-- Basic Plan Details
INSERT INTO @Plans (
	PolicyBusinessId, PolicyDetailId, CRMContactId, CRMContactId2, [Owner], OwnerCount, RefPlanType2ProdSubTypeId, PlanType, ProdSubType,
	UnderlyingPlanType, RefProdProviderId, Provider, PolicyNumber, AgencyStatus, PlanCurrency, StartDate, MaturityDate, StatusDate, Term, RegularPremium, TotalLumpSum,
	Frequency, Valuation, CurrentValue, ValuationDate, ProductName, RefPlanTypeId, SellingAdviserId, SellingAdviserName, PlanPurpose,
	ExcludeValuation, ConcurrencyId, PlanStatus, MortgageRepayPercentage, MortgageRepayAmount, IsGuaranteedToProtectOriginalInvestment,
	ParentPolicyBusinessId, LinkedToPolicyNumber, LinkedToPlanTypeProvider, TopupMasterPolicyBusinessId, IncludeTopupPremiums, IsWrapper,
	EstatePlanningValue, PlanValueTypeId, IsTopLevelBond, RegularPremiumWithTopups, TotalLumpSumWithTopups, FrequencyWithTopups, AdditionalNotes)
SELECT
	Pb.PolicyBusinessId,
	Pd.PolicyDetailId,
	POWN2.CRMContactId,
	POWN2.CRMContactId2,
	CASE POWN2.OwnerCount
		WHEN 1 THEN
			CASE POWN2.CRMContactId
				WHEN @CRMContactId THEN 'Client 1'
				ELSE 'Client 2'
			END
		ELSE 'Joint'
	END AS [Owner],
	POWN2.OwnerCount,
	PlanToProd.RefPlanType2ProdSubTypeId,
	CASE
		WHEN LEN(ISNULL(Pst.ProdSubTypeName, '')) > 0 THEN CONCAT(PType.PlanTypeName, ' (', Pst.ProdSubTypeName, ')')
		ELSE PType.PlanTypeName
	END AS PlanTypeFullName,
	ISNULL(Pst.ProdSubTypeName, ''),
	PType.PlanTypeName,
	Rpp.RefProdProviderId,
	RppC.CorporateName AS ProviderName,
	Pb.PolicyNumber,
	PBE.AgencyStatus,
	Pb.BaseCurrency as Currency,
	Pb.PolicyStartDate,
	Pb.MaturityDate,
	Sh.DateOfChange,
	Pd.TermYears,
	ISNULL(pb.TotalRegularPremium,0),
	ISNULL(Pb.TotalLumpSum, 0),
	pb.PremiumType,
	-- Valuation
	Val.PlanValue,
	-- CurrentValue
	CASE
		WHEN Val.PlanValue IS NOT NULL THEN Val.PlanValue
		ELSE ISNULL(Fund.FundValue, 0)
	END,
	Val.PlanValueDate,
	pb.ProductName,
	pType.RefPlanTypeId,
	pb.PractitionerId,
	CONCAT(ISNULL(pracCRM.FirstName,''), ' ', ISNULL(pracCRM.LastName,'')),
	CASE @ExcludePlanPurposes
		WHEN 1 THEN ''
		ELSE ISNULL(MinPurpose.Descriptor,'')
	END,
	NULL, -- Exclude Valuation
	pb.ConcurrencyId,
	[Status].Name,
	PBE.MortgageRepayPercentage,
	PBE.MortgageRepayAmount,
	Pb.[IsGuaranteedToProtectOriginalInvestment],
	W.ParentPolicyBusinessId,
	NULL, NULL, -- linked to information.
	PB.TopupMasterPolicyBusinessId,
	0 AS [IncludeTopupPremiums],
	PType.IsWrapperFg,
	NULL AS EstatePlanningValue,
	ISNULL(PBVT.RefTotalPlanValuationTypeId, 2),
	0 AS IsTopLevelBond,
	ISNULL(pb.TotalRegularPremium,0),
	ISNULL(Pb.TotalLumpSum, 0),
	pb.PremiumType,
	PBE.AdditionalNotes
FROM
	PolicyManagement..TPolicyDetail Pd
	JOIN PolicyManagement..TPolicyBusiness Pb ON Pb.PolicyDetailId = Pd.PolicyDetailId
	LEFT JOIN PolicyManagement..TPolicyBusinessTotalPlanValuationType PBVT ON PBVT.PolicyBusinessId = Pb.PolicyBusinessId
	LEFT JOIN PolicyManagement..TPolicyBusinessExt PBE ON PBE.PolicyBusinessId = Pb.PolicyBusinessId
	JOIN PolicyManagement..TStatusHistory Sh On CurrentStatusFg = 1 AND Sh.PolicyBusinessId = Pb.PolicyBusinessId
	JOIN PolicyManagement..TStatus Status ON Status.IntelligentOfficeStatusType IN ('In Force', 'Paid Up') AND Status.StatusId = Sh.StatusId
	JOIN PolicyManagement..TPlanDescription PDesc ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId
	JOIN PolicyManagement..TRefPlanType2ProdSubType PlanToProd ON PlanToProd.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId
	LEFT JOIN PolicyManagement..TProdSubType Pst ON Pst.ProdSubTypeId = PlanToProd.ProdSubTypeId
	JOIN PolicyManagement..TRefPlanType PType ON PType.RefPlanTypeId = PlanToProd.RefPlanTypeId
	JOIN PolicyManagement..TRefProdProvider Rpp ON Rpp.RefProdProviderId = PDesc.RefProdProviderId
	JOIN [CRM]..TCRMContact RppC ON RppC.CRMContactId = Rpp.CRMContactId
	JOIN [CRM]..TPractitioner prac ON prac.PractitionerId = pb.PractitionerId
	JOIN [CRM]..TCRMContact pracCRM ON pracCRM.CRMContactId = prac.CRMContactId
	-- Owners
	JOIN (
		SELECT
			COUNT(PolicyOwnerId) AS OwnerCount,
			PolicyDetailId,
			MIN(CRMContactId) AS CRMContactId,
			CASE MAX(CRMContactId)
				WHEN MIN(CRMCOntactId) THEN NULL
				ELSE MAX(CRMCOntactId)
			END AS CRMContactId2
		FROM
			PolicyManagement..TPolicyOwner
		WHERE
			PolicyDetailId IN (SELECT DetailId FROM @PlanList)
		GROUP BY PolicyDetailId) AS POWN2 ON Pd.PolicyDetailId = POWN2.PolicyDetailId
	--Plan Purpose
	LEFT JOIN(
		SELECT
			PolicyBusinessId,
			MIN(PolicyBusinessPurposeId) AS PolicyBusinessPurposeId,
			MIN(B.Descriptor) AS Descriptor
		FROM
			PolicyManagement..TPolicyBusinessPurpose A
			JOIN PolicyManagement..TPlanPurpose B ON A.PlanPurposeId=B.PlanPurposeId
		WHERE
			PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)
		GROUP BY
			PolicyBusinessId) AS MinPurpose ON MinPurpose.PolicyBusinessId = Pb.PolicyBusinessId
	-- Latest valuation
	LEFT JOIN (
		SELECT
			BusinessId AS PolicyBusinessId,
			PolicyManagement.dbo.[FnCustomGetLatestPlanValuationIdByValuationDate](BusinessId) AS PlanValuationId
			FROM
			@PlanList
		) AS LastVal ON LastVal.PolicyBusinessId = PB.PolicyBusinessId
			-- Join back to plan valuation using the latest date
	LEFT JOIN PolicyManagement..TPlanValuation Val ON Val.PlanValuationId = LastVal.PlanValuationId
	-- Fund Price
	LEFT JOIN (
		SELECT
			PolicyBusinessId,
			MAX(LastPriceChangeDate) AS PriceChangeDate,
			SUM(ISNULL(CurrentPrice, 0) * ISNULL(CurrentUnitQuantity, 0)) AS FundValue
		FROM
			PolicyManagement..TPolicyBusinessFund
		WHERE
			PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)
		GROUP BY
			PolicyBusinessId) AS Fund ON Fund.PolicyBusinessId = Pb.PolicyBusinessId
	-- Identify wrappers
	LEFT JOIN
	(
		SELECT
			PolicyBusinessId, MAX(WrapperPolicyBusinessId) AS WrapperPolicyBusinessId
		FROM
			PolicyManagement..TWrapperPolicyBusiness
		WHERE 
			PolicyBusinessId IN (SELECT BusinessId FROM @PlanList) AND PolicyBusinessId != ParentPolicyBusinessId
		GROUP BY
			PolicyBusinessId
	) Wb ON Wb.PolicyBusinessId = Pb.PolicyBusinessId
	LEFT JOIN PolicyManagement..TWrapperPolicyBusiness W ON W.WrapperPolicyBusinessId = Wb.WrapperPolicyBusinessId
WHERE
	Pd.IndigoClientId = @TenantId
	AND PB.IndigoClientId = @TenantId
	AND Pd.PolicyDetailId IN (SELECT DetailId FROM @PlanList)
	AND PB.PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)
ORDER BY
	[Owner], [ProviderName], [PlanTypeFullName], [PolicyBusinessId]

---------------------------------------------------------------------------
-- Update topup information (for calculation of premiums)
---------------------------------------------------------------------------
-- find plans with topups
UPDATE MasterPlan
SET
	IncludeTopupPremiums = 1,
	RegularPremiumWithTopups = PolicyManagement.dbo.FnCustomCalculateContributionsWithTopup(
		@IndigoClientId, MasterPlan.PolicyBusinessId,'Self', 'Regular', Frequency, 1, @CurrentUserDate),
	TotalLumpSumWithTopups = PolicyManagement.dbo.FnCustomCalculateContributionsWithTopup(
		@IndigoClientId, MasterPlan.PolicyBusinessId, NULL ,'Lump Sum', Frequency, CASE WHEN PTS.Section = 'Pension Plans' THEN 0 ELSE 1 END, @CurrentUserDate)
FROM
	@Plans MasterPlan
	JOIN FactFind..TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = MasterPlan.RefPlanType2ProdSubTypeId
WHERE
	@ShowTopupsAsDistinctPlans = 0
	AND MasterPlan.PolicyBusinessId IN (SELECT TopupMasterPolicyBusinessId FROM @Plans)

UPDATE @Plans
SET FrequencyWithTopups = 'Monthly'
WHERE ISNULL(RegularPremiumWithTopups, 0) != 0 AND ISNULL(FrequencyWithTopups, '') = ''

UPDATE @Plans
SET FrequencyWithTopups = NULL
WHERE ISNULL(RegularPremiumWithTopups, 0) = 0

-- Delete any topup plans
DELETE
FROM @Plans
WHERE
	@ShowTopupsAsDistinctPlans = 0
	AND TopupMasterPolicyBusinessId IS NOT NULL

---------------------------------------------------------------------------
-- Horrible stuff for WRAP Plans...
---------------------------------------------------------------------------
-- Update linked information for child plans
UPDATE B
SET
	LinkedToPolicyNumber = A.PolicyNumber,
	LinkedToPlanTypeProvider = CONCAT(A.PlanType, '/', A.[Provider])
FROM
	-- The A's are the WRAPs
	@Plans A
	-- The B's are child plans who's parent also appears in our list.
	JOIN @Plans B ON B.ParentPolicyBusinessId = A.PolicyBusinessId;

-------------------------------------------------------------------
-- Work out the value for wrapper plans
-- Find hierarchy of plans, from top wrap to last sub plan i.e. WRAP > SIPP > Bond
-------------------------------------------------------------------
DROP TABLE IF EXISTS #WrapHierarchy;

WITH Wraps (PolicyBusinessId, ParentPolicyBusinessId, [Level], TopLevelPlanId, PlanValueTypeId, TotalValue)
AS
(
-- Anchor member definition, these are the top level wrap plans.
SELECT
	PolicyBusinessId,
	ParentPolicyBusinessId,
	0,
	PolicyBusinessId,
	PlanValueTypeId,
	Valuation
FROM @Plans
WHERE ParentPolicyBusinessId IS NULL AND IsWrapper = 1

UNION ALL
-- Recursive member definition
SELECT
	A.PolicyBusinessId,
	A.ParentPolicyBusinessId,
	[Level] + 1,
	B.TopLevelPlanId,
	A.PlanValueTypeId,
	A.Valuation
FROM
	@Plans A
	JOIN Wraps B ON B.PolicyBusinessId = A.ParentPolicyBusinessId
WHERE
	B.[Level] < 5 -- Limit recursion to 6 levels in total (0-5)
)
SELECT *, 0 AS ChildPlansHaveValue
INTO #WrapHierarchy
FROM Wraps

-- How deep does the hierarchy go.
SELECT @MaxLevel = MAX([Level]) FROM #WrapHierarchy

-------------------------------------------------------------------
-- Work out the total value of each wrap
-- Start with the plans at the lowest level
-------------------------------------------------------------------
SET @Level = @MaxLevel
WHILE @Level >= 0 BEGIN
	UPDATE A
	SET
		TotalValue =
			-- Value is dependent on type.
			CASE PlanValueTypeId
				-- Child value or value of WRAP if not.
				WHEN 1 THEN ISNULL(ChildPlans.Value, TotalValue)
				-- Total value of Wrap and its Sub Plans
				WHEN 2 THEN ISNULL(TotalValue, 0) + ISNULL(ChildPlans.Value, 0)
				-- Value of master plan only.
				WHEN 3 THEN TotalValue
			END,
		-- Do the child plans have a value?
		ChildPlansHaveValue = CASE WHEN ChildPlans.Value IS NOT NULL THEN 1 ELSE 0 END
	FROM
		-- Identify just wraps at a particular level in the hierarchy
		#WrapHierarchy A
		-- Find the sub plans for each wrap
		LEFT JOIN (
			SELECT
				ParentPolicyBusinessId AS WrapId,
				SUM(TotalValue) AS Value
			FROM
				-- These are the child plans of the wraps
				#WrapHierarchy
			WHERE
				[Level] = @Level + 1 AND TotalValue IS NOT NULL -- Make sure plan has a value
			GROUP BY
				ParentPolicyBusinessId) AS ChildPlans ON ChildPlans.WrapId = A.PolicyBusinessId
	WHERE
		A.[Level] = @Level

	-- Increment level (we're moving up hierarchy as zero is the top)
	SET @Level = @Level - 1
END

-- default wrap value to current plan value.
UPDATE @Plans SET EstatePlanningValue = CurrentValue WHERE UnderlyingPlanType != 'Wrap'

-- Update value for top level wrapper plans
UPDATE P
SET
	EstatePlanningValue = TotalValue
FROM
	@Plans P
	JOIN #WrapHierarchy WH On WH.PolicyBusinessId = P.PolicyBusinessId
WHERE
	P.UnderlyingPlanType != 'Wrap'

-- clear values for plans that are children of SIPP/Bonds (so that they are not double counted).
UPDATE CP
SET
	EstatePlanningValue = NULL
FROM
	@Plans P
	JOIN #WrapHierarchy WH ON WH.TopLevelPlanId = P.PolicyBusinessId
	JOIN @Plans CP ON CP.PolicyBusinessId = WH.PolicyBusinessId
WHERE
	P.PolicyBusinessId != CP.PolicyBusinessId
	AND P.UnderlyingPlanType != 'Wrap'

-- WRAP plan values should always be excluded (this might still required for offline functionality)
UPDATE A SET ExcludeValuation = 1
FROM @Plans A
WHERE A.UnderlyingPlanType = 'Wrap'

---------------------------------------------------------------------------
-- Contributions
---------------------------------------------------------------------------
-- Lump Sum amounts.
INSERT INTO @Contributions (PolicyBusinessId, TypeId, ContributorTypeId, Amount, FrequencyName, FirstId, StartDate)
SELECT PolicyBusinessId, RefContributionTypeId, RefContributorTypeId, SUM(Amount), 'Single', MIN(PolicyMoneyInId), MIN(StartDate)
FROM PolicyManagement..TPolicyMoneyIn
WHERE PolicyBusinessId IN (SELECT BusinessId FROM @PlanList) AND StartDate < @Now AND RefContributionTypeId != 1
GROUP BY PolicyBusinessId, RefContributionTypeId, RefContributorTypeId

-- Regular
INSERT INTO @Contributions (PolicyBusinessId, TypeId, ContributorTypeId, Amount, RefFrequencyId, FrequencyName, StartDate, StopDate)
SELECT PolicyBusinessId, 1, RefContributorTypeId, Amount, A.RefFrequencyId, RF.FrequencyName, StartDate, StopDate
FROM
	PolicyManagement..TPolicyMoneyIn A
	JOIN PolicyManagement..TRefFrequency RF ON RF.RefFrequencyId = A.RefFrequencyId
WHERE
	PolicyMoneyInId IN (
		SELECT MIN(PolicyMoneyInId)
		FROM PolicyManagement..TPolicyMoneyIn
		WHERE RefContributionTypeId = 1 AND PolicyBusinessId IN (SELECT BusinessId FROM @PlanList) 
			AND @Now BETWEEN StartDate AND ISNULL(StopDate, @Now)
		GROUP BY PolicyBusinessId, RefContributorTypeId)

-- Pension
SELECT
	PD.*,
	Pens.*,
	Rss.[Descriptor] SchemeSetup,
	Pens.AccrualRate,
	-- Employer contribution details
	ISNULL(EC.Amount, 0) AS EmployerContribution, EC.FrequencyName AS EmployerFrequency, EC.StartDate AS EmployerStart, EC.StopDate AS EmployerStop,
	-- Your contribution details
	ISNULL(YC.Amount, 0) AS YourContribution, YC.FrequencyName AS YourFrequency, YC.StartDate AS YourStart, Yc.StopDate AS YourStop,
	Pmo.PaymentStartDate AS DrawDownDate,
	Pmo.PaymentBasisPercentage AS DrawDownPercentage,
	pd.ConcurrencyId,
	pd.RefPlanType2ProdSubTypeId as RefPlanTypeId
FROM
	@Plans Pd
	JOIN PolicyManagement..TPensionInfo Pens ON Pens.PolicyBusinessId=Pd.PolicyBusinessId
	LEFT JOIN PolicyManagement..TRefSchemeSetup Rss ON Rss.RefSchemeSetupId = Pens.RefSchemeSetupId
	-- Employer Contribution
	LEFT JOIN @Contributions EC ON EC.TypeId = 1 AND EC.ContributorTypeId = 2 AND EC.PolicyBusinessId = Pd.PolicyBusinessId
	-- Your Contribution
	LEFT JOIN @Contributions YC ON YC.TypeId = 1 AND YC.ContributorTypeId = 1 AND YC.PolicyBusinessId = Pd.PolicyBusinessId
	-- Draw down
	LEFT JOIN Policymanagement..TPolicyMoneyOut Pmo ON Pmo.PolicyBusinessId=Pd.PolicyBusinessId
	LEFT JOIN Policymanagement..TRefWithdrawalType Rwt ON Rwt.WithdrawalName = '% Of Fund' AND Rwt.RefWithdrawalTypeId = Pmo.RefWithdrawalTypeId
ORDER BY
	[SortId]

-- Protection
SELECT DISTINCT
	Pd.SortId,
	Pd.PolicyBusinessId as ProtectionPlansId,
	Pd.PolicyBusinessId,
	Pd.CRMContactId,
	Pd.CRMContactId2,
	Pd.[Owner],
	pd.SellingAdviserId,
	pd.SellingAdviserName,
	Pd.RefProdProviderId,
	Pd.ProductName,
	Pd.PolicyNumber,
	Pd.AgencyStatus,
	Pd.PlanCurrency,
	Pd.RefPlanType2ProdSubTypeId,
	pd.RefPlanType2ProdSubTypeId as RefPlanTypeId,
	CASE @ExcludePlanPurposes
		WHEN 1 THEN ''
		ELSE ISNULL(Pd.PlanPurpose,'')
	END ProtectionPlanPurpose,
	Pd.PlanPurpose AS PlanPurposeText, -- needed for pdf.
	Pd.StartDate as ProtectionStartDate,
	Pd.MaturityDate,
	Pd.RegularPremium,
	ISNULL(Pd.Frequency, YC.FrequencyName) AS PremiumFrequency,
	GI.SumAssured,
	-- Just take majority of benefits from the 1st life (data should be the same for 2nd for the fields that FF cares about)
	B1.BenefitAmount,
	B1.RefFrequencyId AS BenefitFrequencyId,
	P.CriticalIllnessSumAssured as CriticalIllnessAmount,
	P.LifeCoverSumAssured AS LifeCoverAmount,
	CASE
		WHEN AL2.PartyId IS NOT NULL THEN 'Joint'
		WHEN AL1.PartyId = @CRMContactId2 THEN 'Client 2'
		ELSE 'Client 1'
	END AS LifeAssured,
	B1.BenefitDeferredPeriod,
	B1.DeferredPeriodIntervalId,
	B1.RefBenefitPeriodId,
	P.PaymentBasisId AS RefPaymentBasisId,
	P.InTrust AS AssignedInTrust,
	pd.ConcurrencyId,
	Pd.PlanStatus,
	P.IsForProtectionShortfallCalculation,
	CASE
		WHEN B1.RefBenefitPeriodId = 8 THEN B1.OtherBenefitPeriodText-- Other
		ELSE NULL
	END AS OtherBenefitPeriodText,
	B1.SplitBenefitAmount,
	B1.RefSplitFrequencyId,
	B1.SplitBenefitDeferredPeriod,
	B1.SplitDeferredPeriodIntervalId,
	TPI.GMPAmount AS GMPAmount
FROM
	@Plans Pd
	JOIN TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId
	-- Protection details should always be available but...
	LEFT JOIN PolicyManagement..TProtection P ON P.PolicyBusinessId = Pd.PolicyBusinessId
	LEFT JOIN PolicyManagement..TGeneralInsuranceDetail GI ON GI.RefInsuranceCoverCategoryId = 5 AND GI.ProtectionId = P.ProtectionId -- Payment Protection
	-- Life assured 1
	LEFT JOIN PolicyManagement..TAssuredLife AL1 ON AL1.OrderKey = 1 AND AL1.ProtectionId = P.ProtectionId
	LEFT JOIN PolicyManagement..TBenefit B1 ON B1.BenefitId = AL1.BenefitId
	-- Life assured 2.
	LEFT JOIN PolicyManagement..TAssuredLife AL2 ON AL2.OrderKey = 2 AND AL2.ProtectionId = P.ProtectionId
	-- Your Contribution
	LEFT JOIN @Contributions YC ON YC.TypeId = 1 AND YC.ContributorTypeId = 1 AND YC.PolicyBusinessId = Pd.PolicyBusinessId
	LEFT JOIN PolicyManagement..TPensionInfo TPI WITH(NOLOCK) ON TPI.PolicyBusinessId = Pd.PolicyBusinessId
WHERE
	PTS.Section = 'Protection'
ORDER BY
	[SortId]

-- Savings
SELECT
	Pd.PolicyBusinessId as SavingsPlansId,
	Pd.PolicyBusinessId,
	Pd.CRMContactId,
	Pd.CRMContactId2,
	Pd.Owner,
	pd.SellingAdviserId,
	pd.SellingAdviserName,
	Pd.RefPlanType2ProdSubTypeId,
	pd.RefPlanType2ProdSubTypeId as RefPlanTypeId,
	Pd.PlanType,
	Pd.Provider,
	CASE @ExcludePlanPurposes
		WHEN 1 THEN ''
		ELSE ISNULL(Pd.PlanPurpose,'')
	END SavingsPlanPurpose,
	Pd.PlanPurpose AS PlanPurposeText, -- need this for online pdf
	Pd.PolicyNumber,
	Pd.AgencyStatus,
	Pd.PlanCurrency,
	Pd.ProductName,
	Pd.CurrentValue,
	policymanagement.dbo.FnGetCurrencyRate(pd.PlanCurrency,@RegionalCurrency) * pd.CurrentValue as CurrentValueConverted,
	@RegionalCurrency as TotalCurrency,
	CASE WHEN pd.PlanCurrency = @RegionalCurrency THEN 0 ELSE 1 END AS IsExchangeRateMessageShown,
	Pd.StartDate as SavingsPlansStartDate,
	Pd.MaturityDate,
	PBE.InterestRate,
	pd.ConcurrencyId,
	pd.PlanStatus,
	pd.MortgageRepayPercentage,
	pd.MortgageRepayAmount,
	pd.RefProdProviderId,
	PD.LinkedToPolicyNumber,
	pd.CurrentValue AS Value,
	PD.LinkedToPlanTypeProvider
FROM
	@Plans pd
	JOIN factfind.dbo.TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId
	LEFT JOIN policymanagement..TPolicyBusinessExt PBE ON PBE.PolicyBusinessId = pd.PolicyBusinessId
WHERE
	PTS.Section = 'Savings'
ORDER BY
	[SortId]

-- Other investments
SELECT
	PD.PolicyBusinessId AS OtherInvestmentsPlansId,
	PD.PolicyBusinessId,
	PD.CRMContactId,
	PD.CRMContactId2,
	PD.[Owner],
	PD.SellingAdviserId,
	PD.SellingAdviserName,
	PD.Provider,
	pd.RefProdProviderId,
	PD.LinkedToPolicyNumber,
	PD.LinkedToPlanTypeProvider,
	PD.PolicyNumber,
	PD.AgencyStatus,
	PD.PlanCurrency,
	PD.ProductName,
	PD.PlanType,
	PD.RefPlanType2ProdSubTypeId AS RefPlanType2ProdSubTypeId,
	pd.RefPlanType2ProdSubTypeId as RefPlanTypeId,
	CASE @ExcludePlanPurposes
		WHEN 1 THEN ''
		ELSE ISNULL(PD.PlanPurpose,'')
	END AS OtherInvPlanPurpose,
	PD.PlanPurpose AS PlanPurposeText, -- need this for pdf.
	t.ContributionThisTaxYearFg,
	CASE
		WHEN ISNULL(PD.RegularPremium,0) > 0 THEN PD.RegularPremium
		ELSE ISNULL(PD.TotalLumpSum,0)
	END AS RegularContribution,
	CASE
		WHEN isnull(PD.RegularPremium,0) > 0 then PD.Frequency
		WHEN isnull(PD.TotalLumpSum,0) > 0 then 'Single'
	END AS Frequency,
	PD.CurrentValue,
	policymanagement.dbo.FnGetCurrencyRate(pd.PlanCurrency, @RegionalCurrency) * pd.CurrentValue as CurrentValueConverted,
	@RegionalCurrency as TotalCurrency,
	CASE WHEN pd.PlanCurrency = @RegionalCurrency THEN 0 ELSE 1 END AS IsExchangeRateMessageShown,
	PD.StartDate as OtherInvStartDate,
	PD.MaturityDate,
	T.MonthlyIncome,
	P.InTrust AS InTrustFg,
	P.ToWhom,
	PD.ExcludeValuation,
	PD.ConcurrencyId,
	PD.PlanStatus,
	PD.MortgageRepayPercentage,
	PD.MortgageRepayAmount,
	PD.[IsGuaranteedToProtectOriginalInvestment],
	PB.LowMaturityValue,
	PB.MediumMaturityValue,
	PB.HighMaturityValue,
	PB.ProjectionDetails,
	PD.RegularPremiumWithTopups AS ActualRegularContribution,
	PD.FrequencyWithTopups AS RegularContributionsFrequency,
	TotalLumpSumWithTopups AS TotalSingleContribution,
	PD.CurrentValue AS Value,
	EstatePlanningValue,
	policymanagement.dbo.FnGetCurrencyRate(pd.PlanCurrency,@RegionalCurrency) * EstatePlanningValue as EstatePlanningValueConverted,
	PD.ValuationDate,
	PD.TotalLumpSum as LumpsumContributionAmount,
	PBE.InterestRate
FROM
	@Plans PD
	JOIN PolicyManagement..TPolicyBusiness PB ON PB.PolicyBusinessId = PD.PolicyBusinessId
	LEFT JOIN policymanagement..TPolicyBusinessExt PBE ON PBE.PolicyBusinessId = PB.PolicyBusinessId
	JOIN factfind.dbo.TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId
	LEFT JOIN factfind.dbo.TOtherInvestmentsPlanFFExt T ON t.PolicyBusinessId = pd.PolicyBusinessId
	LEFT JOIN Policymanagement..TProtection P ON P.PolicyBusinessId = pd.PolicyBusinessId
WHERE
	PTS.Section = 'Other Investments'
ORDER BY
	[SortId]

-- final salary plans
SELECT
	Pd.PolicyBusinessId as FinalSalaryPensionPlansId,
	Pd.PolicyBusinessId,
	pd.CRMContactId,
	pd.CRMContactId2,
	pd.[Owner],
	pd.SellingAdviserId,
	pd.SellingAdviserName,
	pd.Provider,
	Pd.ProductName,
	Pd.AgencyStatus,
	Pd.PlanCurrency,
	ext.Employer,
	tpi.SRA as NormalSchemeRetirementAge,
	tpi.AccrualRate,
	tpi.AccrualRate AS AccrualRateText, -- appears to be used for online
	pd.StartDate as DateJoined,
	tpi.ExpectedYearsOfService,
	tpi.PensionableSalary,
	tpi.IsCurrent as Preserved,
	tpi.IsIndexed as Indexed,
	pd.ConcurrencyId,
	pd.PlanStatus,
	pd.MortgageRepayPercentage,
	pd.MortgageRepayAmount,
	PTS.RefPlanType2ProdSubTypeId as RefPlanTypeId,
	PTS.RefPlanType2ProdSubTypeId,
	pd.RefProdProviderId,
	pd.Provider,
	tpi.GMPAmount,
	tpi.ProspectiveLumpSumAtRetirement,
	tpi.ProspectivePensionAtRetirementLumpSumTaken,
	tpi.ProspectivePensionAtRetirement,
	tpi.EarlyRetirementFactorNotes,
	tpi.DependantBenefits,
	tpi.IndexationNotes,
	pd.AdditionalNotes,
	tpi.ServiceBenefitSpouseEntitled AS DeathInServiceSpousalBenefits,
	tpi.YearsPurchaseAvailability,
	tpi.YearsPurchaseAvailabilityDetails,
	tpi.AffinityContributionAvailability,
	tpi.AffinityContributionAvailabilityDetails,
	tpi.CashEquivalentTransferValue,
	tpi.TransferExpiryDate
FROM
	@Plans pd
	JOIN factfind.dbo.TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId
	LEFT JOIN PolicyManagement..TPensionInfo tpi ON tpi.PolicyBusinessId = pd.PolicyBusinessId
	LEFT JOIN TFinalSalaryPensionsPlanFFExt ext ON ext.PolicyBusinessId = pd.PolicyBusinessId
WHERE
	PTS.Section = 'Final Salary Schemes'
ORDER BY
	[SortId]

-- money purchase pension plans
SELECT
	Pd.PolicyBusinessId as MoneyPurchasePensionPlansId,
	pd.PolicyBusinessId,
	pd.PolicyDetailId,
	pd.CRMContactId,
	pd.CRMContactId2,
	pd.[Owner],
	pd.SellingAdviserId,
	pd.SellingAdviserName,
	pd.PlanType,
	pd.PlanType AS PlanTypeId, -- needed for pdf because of online meta changes.
	pd.RefPlanType2ProdSubTypeId,
	pd.RefPlanType2ProdSubTypeId as RefPlanTypeId,
	pd.RefProdProviderId,
	pd.Provider,
	Pd.LinkedToPolicyNumber,
	Pd.LinkedToPlanTypeProvider,
	pd.PolicyNumber,
	pd.AgencyStatus,
	pd.PlanCurrency,
	Pd.ProductName,
	ext.Employer,
	pd.StartDate as DateJoined,
	tpi.SRA as NormalSchemeRetirementAge,
	YC.Amount AS SelfContributionAmount,
	CASE
		WHEN PD.IncludeTopupPremiums = 0 THEN policymanagement.dbo.FnConvertFrequency(YC.FrequencyName, EC.FrequencyName, EC.Amount)
		ELSE policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, PD.PolicyBusinessId, 'Employer', 'Regular', YC.FrequencyName, 0, @CurrentUserDate)
	END AS EmployerContributionAmount,
	CASE
		WHEN PD.IncludeTopupPremiums = 0 THEN Pd.RegularPremium
		ELSE pd.RegularPremiumWithTopups
	END AS RegularContribution,
	CASE
		WHEN PD.IncludeTopupPremiums = 0 THEN LumpSum.Amount
		ELSE Pd.TotalLumpSumWithTopups
	END AS LumpsumContributionAmount,
	ISNULL(YC.FrequencyName, EC.FrequencyName) AS Frequency,
	pd.Valuation as Value,
	pd.ValuationDate,
	tpi.IsIndexed as Indexed,
	tpi.IsCurrent as Preserved,
	pd.ConcurrencyId,
	pd.PlanStatus,
	pd.MortgageRepayPercentage,
	pd.MortgageRepayAmount,
	ISNULL(YC.FrequencyName, EC.FrequencyName) AS RegularContributionsFrequency,
	tpi.GMPAmount,
	tpi.EnhancedTaxFreeCash,
	tpi.GuaranteedAnnuityRate,
	tpi.ApplicablePenalties,
	tpi.EfiLoyaltyTerminalBonus,
	tpi.GuaranteedGrowthRate,
	tpi.OptionsAvailableAtRetirement,
	tpi.OtherBenefitsAndMaterialFeatures,
	pd.AdditionalNotes,
	tpi.LifetimeAllowanceUsed,
	tpi.ServiceBenefitSpouseEntitled AS DeathInServiceSpousalBenefits,
	tpi.IsLifeStylingStrategy,
	tpi.LifeStylingStrategyDetail,
	tpi.EmployerContributionDetail
FROM
	@Plans pd
	JOIN FactFind..TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId
	LEFT JOIN PolicyManagement..TPensionInfo tpi ON tpi.PolicyBusinessId = pd.PolicyBusinessId
	LEFT JOIN factfind.dbo.TMoneyPurchasePensionPlanFFExt ext ON ext.PolicyBusinessId = pd.PolicyBusinessId
	-- Regular Contributions
	LEFT JOIN @Contributions EC ON EC.PolicyBusinessId = Pd.PolicyBusinessId AND EC.TypeId = 1 AND EC.ContributorTypeId = 2
	LEFT JOIN @Contributions YC ON YC.PolicyBusinessId = Pd.PolicyBusinessId AND YC.TypeId = 1 AND YC.ContributorTypeId = 1
	-- Lump Sum Contributions
	LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 2 GROUP BY PolicyBusinessId) AS LumpSum ON LumpSum.PolicyBusinessId = Pd.PolicyBusinessId
WHERE
	PTS.Section = 'Money Purchase Pension Schemes'
ORDER BY
	[SortId]

-- Personal Pension Plans
SELECT
	P.PolicyBusinessId as PersonalPensionPlanId,
	P.PolicyBusinessId,
	P.PolicyDetailId,
	P.CRMContactId,
	P.CRMContactId2,
	P.[Owner],
	P.SellingAdviserId,
	P.SellingAdviserName,
	P.RefPlanType2ProdSubTypeId AS RefPlanTypeId,
	P.RefPlanType2ProdSubTypeId,
	P.RefProdProviderId,
	P.LinkedToPolicyNumber,
	P.LinkedToPlanTypeProvider,
	P.PolicyNumber,
	P.AgencyStatus,
	P.PlanCurrency,
	P.ProductName,
	P.StartDate AS PolicyStartDate,
	TPI.SRA as RetirementAge,
	CASE
		WHEN P.IncludeTopupPremiums = 0 Then YC.Amount
		ELSE P.RegularPremiumWithTopups
	END AS SelfContributionAmount,
	CASE
		WHEN P.IncludeTopupPremiums = 0 Then policymanagement.dbo.FnConvertFrequency(ISNULL(YC.FrequencyName, EC.FrequencyName), EC.FrequencyName, EC.Amount)
		ELSE policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, P.PolicyBusinessId,'Employer', 'Regular', ISNULL(YC.FrequencyName, EC.FrequencyName), 0, @CurrentUserDate)
	END AS EmployerContributionAmount,
	ISNULL(YC.RefFrequencyId, EC.RefFrequencyId) AS RefContributionFrequencyId,
	CASE
		WHEN P.IncludeTopupPremiums = 0 THEN Trans.Amount
	ELSE policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, P.PolicyBusinessId, NULL, 'Transfer', YC.FrequencyName, 0, @CurrentUserDate)
	END AS TransferContribution,
	CASE
		WHEN P.IncludeTopupPremiums = 0 THEN LumpSum.Amount
		ELSE P.TotalLumpSumWithTopups
	END AS LumpSumContribution,
	P.Valuation as Valuation,
	P.ValuationDate,
	B.PensionCommencementLumpSum,
	B.PCLSPaidById,
	B.GADMaximumIncomeLimit,
	B.GuaranteedMinimumIncome,
	B.GADCalculationDate,
	PROT.ReviewDate AS NextReviewDate,
	B.IsCapitalValueProtected,
	B.CapitalValueProtectedAmount,
	TPI.IsIndexed as Indexed,
	TPI.IsCurrent as Preserved,
	B.LumpSumDeathBenefitAmount,
	PROT.InTrust,
	YC.Amount AS PremiumAmount,
	YC.RefFrequencyId PremiumFrequencyId,
	YC.StartDate AS PremiumStartDate,
	P.ConcurrencyId,
	P.MortgageRepayPercentage,
	P.MortgageRepayAmount,
	P.PlanStatus,
	P.PlanType,
	P.Provider,
	P.Valuation AS Value,
	TPI.GMPAmount,
	B.IsProtectedPCLS,
	tpi.EnhancedTaxFreeCash,
	tpi.GuaranteedAnnuityRate,
	tpi.ApplicablePenalties,
	tpi.EfiLoyaltyTerminalBonus,
	tpi.GuaranteedGrowthRate,
	tpi.OptionsAvailableAtRetirement,
	tpi.OtherBenefitsAndMaterialFeatures,
	P.AdditionalNotes,
	tpi.LifetimeAllowanceUsed,
	tpi.ServiceBenefitSpouseEntitled AS DeathInServiceSpousalBenefits,
	tpi.IsLifeStylingStrategy,
	tpi.LifeStylingStrategyDetail
FROM
	@Plans P
	-- need to link to parent plan type here so that child plans are kept with their parents
	JOIN FactFind..TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = P.RefPlanType2ProdSubTypeId
	LEFT JOIN PolicyManagement..TPensionInfo TPI ON TPI.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN PolicyManagement..TProtection PROT ON PROT.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN PolicyManagement..TAssuredLife AL ON AL.ProtectionId = PROT.ProtectionId AND AL.OrderKey = 1
	LEFT JOIN PolicyManagement..TBenefit B ON B.BenefitId = AL.BenefitId
	-- Regular Contributions
	LEFT JOIN @Contributions EC ON EC.PolicyBusinessId = P.PolicyBusinessId AND EC.TypeId = 1 AND EC.ContributorTypeId = 2
	LEFT JOIN @Contributions YC ON YC.PolicyBusinessId = P.PolicyBusinessId AND YC.TypeId = 1 AND YC.ContributorTypeId = 1
	-- Lump Sum Contributions
	LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 2 GROUP BY PolicyBusinessId) AS LumpSum ON LumpSum.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 3 GROUP BY PolicyBusinessId) AS Trans ON Trans.PolicyBusinessId = P.PolicyBusinessId
WHERE
	PTS.Section = 'Pension Plans'
ORDER BY
	[SortId]

-- Annuities
SELECT
	P.PolicyBusinessId as AnnuityPlanId,
	P.PolicyBusinessId,
	P.PolicyDetailId,
	P.CRMContactId,
	P.CRMContactId2,
	P.[Owner],
	P.SellingAdviserId,
	P.SellingAdviserName,
	P.RefPlanType2ProdSubTypeId AS RefPlanTypeId,
	P.RefPlanType2ProdSubTypeId,
	P.RefProdProviderId,
	P.PolicyNumber,
	P.AgencyStatus,
	P.PlanCurrency,
	P.ProductName,
	P.StartDate AS PolicyStartDate,
	P.LinkedToPolicyNumber,
	P.LinkedToPlanTypeProvider,
	LC.Amount AS TotalPurchaseAmount,
	LC.StartDate AS PremiumStartDate,
	PD.CapitalElement,
	PD.AssumedGrowthRatePercentage,
	PD.RefAnnuityPaymentTypeId,
	PMO.Amount AS IncomeAmount,
	PMO.RefFrequencyId AS IncomeFrequencyId,
	PMO.PaymentStartDate AS IncomeEffectiveDate,
	B.PensionCommencementLumpSum,
	B.PCLSPaidById,
	B.IsCapitalValueProtected,
	B.CapitalValueProtectedAmount,
	B.IsSpousesBenefit,
	B.SpousesOrDependentsPercentage,
	B.GuaranteedPeriod,
	B.IsOverlap,
	B.IsProportion,
	P.ConcurrencyId,
	P.MortgageRepayPercentage,
	P.MortgageRepayAmount,
	P.PlanStatus,
	P.AdditionalNotes,
	TPI.GMPAmount,
    IIF ( LEN(PST.ProdSubTypeName) > 0 ,  RPT.PlanTypeName + ' (' + PST.ProdSubTypeName + ')', RPT.PlanTypeName) AS PlanType
FROM
@Plans P
	JOIN FactFind..TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = P.RefPlanType2ProdSubTypeId
	JOIN PolicyManagement..TRefPlanType2ProdSubType P2P ON PTS.RefPlanType2ProdSubTypeId = P2P.RefPlanType2ProdSubTypeId
	JOIN PolicyManagement..TRefPlanType RPT WITH(NOLOCK) ON P2P.RefPlanTypeId = RPT.RefPlanTypeId
	JOIN PolicyManagement..TPolicyDetail PD ON PD.PolicyDetailId = P.PolicyDetailId
	LEFT JOIN PolicyManagement..TProdSubType PST WITH(NOLOCK) ON PST.ProdSubTypeId = P2P.ProdSubTypeId
	LEFT JOIN PolicyManagement..TProtection PROT ON PROT.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN PolicyManagement..TAssuredLife AL ON AL.ProtectionId = PROT.ProtectionId AND AL.OrderKey = 1
	LEFT JOIN PolicyManagement..TBenefit B ON B.BenefitId = AL.BenefitId
	LEFT JOIN PolicyManagement..TPensionInfo TPI ON TPI.PolicyBusinessId = P.PolicyBusinessId
	-- Lump Sum Contributions (we need to include transfers and rebates to match core system)
	LEFT JOIN (
		SELECT PolicyBusinessId, SUM(Amount) AS Amount, MIN(StartDate) AS StartDate
		FROM @Contributions
		WHERE TypeId != 1
		GROUP BY PolicyBusinessId) AS LC ON LC.PolicyBusinessId = P.PolicyBusinessId
	-- Last current Regular Withdrawal
	LEFT JOIN (
		SELECT MAX(PolicyMoneyOutId) AS Id, PolicyBusinessId
		FROM PolicyManagement..TPolicyMoneyOut
		WHERE
			PolicyBusinessId IN (SELECT PolicyBusinessId FROM @PlanList)
			AND RefWithdrawalTypeId = 1 -- regular
			AND @Now BETWEEN PaymentStartDate AND ISNULL(PaymentStopDate, @Now) -- Current
		GROUP BY PolicyBusinessId
	) AS FirstOut ON FirstOut.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN PolicyManagement..TPolicyMoneyOut PMO ON PMO.PolicyMoneyOutId = FirstOut.Id
WHERE
	PTS.Section = 'Annuities'
ORDER BY
	[SortId]

-- Mortgages
SELECT
	Pd.PolicyBusinessId as ExistingMortgageId,
	Pd.PolicyBusinessId,
	Pd.CRMContactId,
	Pd.[Owner],
	pd.SellingAdviserId,
	pd.SellingAdviserName,
	Pd.Provider,
	Pd.RefProdProviderId,
	Pd.PolicyNumber,
	Pd.PlanCurrency,
	Pd.AgencyStatus,
	Pd.ProductName,
	M.RefMortgageRepaymentMethodId AS RepaymentMethod,
	M.RefMortgageBorrowerTypeId,
	M.LoanAmount,
	M.InterestRate,
	M.InterestOnlyAmount,
	M.RepaymentAmount,
	M.MortgageType,
	M.PropertyType,
	M.FeatureExpiryDate,
	IIF(M.MortgageTerm IS NOT NULL, CONCAT(FLOOR(M.MortgageTerm), 'y ', CAST(ROUND((M.MortgageTerm % 1) * 12, 0) AS INT), 'm' ), '' ) AS MortgageTermYearsPartPdf,
	pd.StartDate,
	pd.MaturityDate,
	dbo.FnCustomGetMortgageRemainingTerm(pd.StartDate, pd.MaturityDate, M.MortgageTerm) AS RemainingTermYearsPartPdf,
	Pd.Valuation * -1 AS CurrentBalance,
	M.MortgageRefNo AS AccountNumber,
	M.PenaltyFg AS RedemptionFg,
	M.RedemptionAmount,
	M.RedemptionTerms,
	M.PenaltyExpiryDate AS RedemptionEndDate,
	M.PortableFg,
	M.WillBeDischarged,
	M.AssetsId AS AssetId,
	CASE
		WHEN M.StatusFg = 1 THEN 'Full Status'
		WHEN M.SelfCertFg = 1 THEN 'Self Certified'
		WHEN M.NonStatusFg = 1 THEN 'Non Status'
	END AS IncomeStatus,
	Pd.ConcurrencyId,
	M.BaseRate,
	M.LenderFee,
	M.IsGuarantorMortgage,
	M.RatePeriodFromCompletionMonths,
    IIF(M.CapitalRepaymentTerm IS NOT NULL, CONCAT(FLOOR(M.CapitalRepaymentTerm), 'y ', CAST(ROUND((M.CapitalRepaymentTerm % 1) * 12, 0) AS INT), 'm'), '') AS RepaymentTermYearsPartPdf,
	IIF(M.InterestOnlyTerm IS NOT NULL, CONCAT(FLOOR(M.InterestOnlyTerm), 'y ', CAST(ROUND((M.InterestOnlyTerm % 1) * 12, 0) AS INT), 'm'), '') AS InterestOnlyTermYearsPartPdf,
	M.InterestOnlyRepaymentVehicle,
	CASE
		WHEN PM.Amount IS NOT NULL 
		THEN factfind.dbo.FnCustomGetMonthlyIncomeNetAmount(PM.Amount, RF.FrequencyName)
		ELSE 0
	END AS MonthlyRepaymentAmount,
	M.RepayDebtFg,
	Pd.RefPlanType2ProdSubTypeId,
	pd.RefPlanType2ProdSubTypeId as RefPlanTypeId,
	M.IsFirstTimeBuyer,
	TA.AddressLine1,
	M.ConsentToLetFg,
	M.ConsentToLetExpiryDate,
	M.RefEquityLoanSchemeId,
	M.EquitySchemeProvider,
	M.EquityRepaymentStartDate,
	M.EquityLoanPercentage,
	M.EquityLoanAmount,
	ISNULL(assets.Description, AC.CategoryName) AS AssetDescription,
	assets.Amount as AssetAmount,
	assets.CurrencyCode as CurrencyCode,
	M.IsToBeConsolidated as Consolidate,
	M.IsLiabilityToBeRepaid as IsToBeRepaid,
	M.LiabilityRepaymentDescription as LiabilityRepaymentDescription
FROM
	@Plans Pd
	LEFT JOIN PolicyManagement..TMortgage M ON M.PolicyBusinessId = Pd.PolicyBusinessId
	LEFT JOIN factfind..TAssets assets ON assets.AssetsId = M.AssetsId 
	LEFT JOIN TAssetCategory AC ON assets.AssetCategoryId = AC.AssetCategoryId
	LEFT JOIN crm..TAddress address ON M.AddressId = address.AddressId
	LEFT JOIN crm..TAddressStore TA ON address.AddressStoreId = TA.AddressStoreId
	LEFT JOIN Policymanagement..TPolicyMoneyIn PM ON PM.PolicyBusinessId = Pd.PolicyBusinessId
	LEFT JOIN PolicyManagement..TRefFrequency RF ON PM.RefFrequencyId = RF.RefFrequencyId
WHERE
	Pd.RefPlanTypeId IN (63, 1039) -- Mortgages.
	AND ((PM.RefContributionTypeId = 1 AND (PM.StopDate IS NULL OR PM.StopDate >= @CurrentUserDate) ) OR PM.RefContributionTypeId IS NULL)
ORDER BY
	[SortId]

-- Equity Release Plans
SELECT
	Pd.PolicyBusinessId as EquityReleaseId,
	Pd.CRMContactId,
	Pd.CRMContactId2,
	Pd.[Owner],
	pd.SellingAdviserId,
	pd.SellingAdviserName,
	Pd.Provider,
	Pd.RefProdProviderId,
	Pd.PolicyNumber,
	Pd.AgencyStatus,
	Pd.PlanCurrency,
	EQ.RefEquityReleaseTypeId,
	EQ.PercentageOwnershipSold,
	EQ.RateType,
	pd.StartDate,
	EQ.RefMortgageRepaymentMethodId AS RepaymentMethod,
	EQ.RepaymentAmount,
	EQ.InterestOnlyAmount,
	EQ.LoanAmount,
	EQ.InterestRatePercentage,
	EQ.LumpsumAmount,
	EQ.MonthlyIncomeAmount,
	EQ.AssetsId,
	EQ.InterestRate,
	AmountReleased.AttributeValue AS AmountReleasedValue,
	EQ.PenaltyFg AS RedemptionFg,
	EQ.RedemptionTerms,
	EQ.PenaltyExpiryDate AS RedemptionEndDate,
	pd.ProductName,
	Pd.Valuation * -1 AS CurrentBalance,
	CASE WHEN wrapper1.PolicyBusinessId IS NULL AND wrapper2.ParentPolicyBusinessId IS NULL
		THEN CONVERT(BIT,0)
		ELSE CONVERT(BIT,1)
	END AS IsWrapper,
	TA.AddressLine1,
	ISNULL(assets.Description, AC.CategoryName) AS AssetDescription,
	assets.Amount as AssetAmount,
	assets.CurrencyCode as CurrencyCode,
	EQ.IsToBeConsolidated as Consolidate,
	EQ.IsLiabilityToBeRepaid as IsToBeRepaid,
	EQ.LiabilityRepaymentDescription as LiabilityRepaymentDescription
FROM
	@Plans Pd
	LEFT JOIN PolicyManagement..TEquityRelease EQ ON EQ.PolicyBusinessId = Pd.PolicyBusinessId
	LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 ON wrapper1.PolicyBusinessId = Pd.PolicyBusinessId
	LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 ON wrapper2.ParentPolicyBusinessId = Pd.PolicyBusinessId
	-- Find amount released
	LEFT JOIN (
		SELECT PBA.PolicyBusinessId, PBA.AttributeValue
		FROM
			PolicyManagement..TPolicyBusinessAttribute PBA
			JOIN PolicyManagement..TAttributeList2Attribute ALA ON ALA.AttributeList2AttributeId = PBA.AttributeList2AttributeId
			JOIN PolicyManagement..TAttributelist AL ON AL.Name = 'Amount Released' AND ALA.AttributeListId = AL.AttributeListId
		WHERE
			PolicyBusinessId IN (SELECT PolicyBusinessId FROM @PlanList)
			AND ISNUMERIC(PBA.AttributeValue) = 1
	) AS AmountReleased ON AmountReleased.PolicyBusinessId = Pd.PolicyBusinessId
	LEFT JOIN crm..TAddress address ON EQ.AddressId = address.AddressId
	LEFT JOIN crm..TAddressStore TA ON address.AddressStoreId = TA.AddressStoreId
	LEFT JOIN factfind..TAssets assets ON assets.AssetsId = EQ.AssetsId 
	LEFT JOIN TAssetCategory AC ON assets.AssetCategoryId = AC.AssetCategoryId
WHERE
	Pd.RefPlanTypeId = 64
ORDER BY
	[SortId]

-- Adviser Details
EXEC factfind.dbo.[SpNCustomRetrieveAdviserDetails] @TenantId, @FrontPageAdviserCrmId

-- Indigo Client
SELECT
	I.*
FROM
	Administration..TIndigoClient I
WHERE
	IndigoClientId = @TenantId

-- current user adviser data (for lookups)
--MT: Changed so that if user is a portal User it will get user the portal Users Selling adviser 
--PW : FF and Portal will use preexisting adviser if it exists.
IF @PreExistingAdviserId != 0 AND @PreExistingAdviserCRMId != 0
	SELECT
		@PreExistingAdviserId AS SellingAdviserId,
		@PreExistingAdviserCRMId AS SellingAdviserCRMId,
		@PreExistingAdviserName AS SellingAdviserName
ELSE
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
			WHEN 1 THEN CONCAT(isnull(c.FirstName,''), ' ', isnull(c.LastName ,''))
			ELSE @AdviserName
		END AS SellingAdviserName
	FROM
		Administration..TUser u
		INNER JOIN CRM..TCRMContact c ON c.CRMContactId = u.CRMContactId
		LEFT JOIN CRM..TPractitioner p ON p.CRMContactId = u.CRMContactId
	WHERE
		u.UserId = @UserId

-- These are the selects from the PreSales tables
SELECT * FROM TAdviceareas WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)
SELECT * FROM TAffordability WHERE CRMContactId = @CRMContactId
SELECT * FROM TAssetNotes WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)

-- Updated 20/12/2007 - As part of Asset Spec CASE #9002. By Awad
DROP TABLE IF EXISTS #Assets;

SELECT
	A.AssetsId,
	A.CRMContactId,
	A.CRMContactId2,
	CASE
		WHEN A.CRMContactId = @CRMContactId2 AND (A.Owner = 'Client 1' OR A.Owner = 'Client 2') THEN 'Client 2'
		ELSE A.[Owner]
	END AS [Owner],
	A.[Description],
	A.[Description] AS DescriptionDropDownList,
	CAST(NULL AS MONEY) AS Amount,
	CAST(NULL AS DATETIME) AS ValuedOn,
	A.PriceUpdatedByUser,
	A.Type,
	PurchasePrice,
	PurchasedOn,
	A.PolicyBusinessId,
	A.AssetCategoryId,
	A.PercentOwnership,
	A.percentOwnershipCrmContact2 AS Owner2PercentOwnership,
	A.RelatedtoAddress,
	A.ConcurrencyId,
	b.AddressStoreId,
	A.CurrencyCode,
	-- IP-59228 Assets related to SIPP plans are not included in total Estate Planning assets calculation
	CASE
	  WHEN policymanagement.dbo.FnCustomGetPlanTypeWithSubPlanTypeForPlanDetailId(pb.PolicyDetailId) IN ('SIPP', 'Group SIPP') THEN 0
	  ELSE 1
	END AS IncludeInTotalCalculation,
	CASE
		WHEN A.IncomeId IS NOT NULL AND (I.EndDate IS NULL OR I.EndDate > @CurrentUserDate) THEN factfind.dbo.FnCustomGetMonthlyIncomeNetAmount(I.NetAmount, I.Frequency)
		ELSE NULL
	END as MonthlyAssetIncomeNetAmount
INTO #Assets
FROM
	TAssets A
	LEFT JOIN (
		SELECT
			A.CRMContactId,
			MIN(B.AddressStoreId) AS AddressStoreId,
			B.AddressLine1
		FROM
			CRM..TAddress A
			JOIN CRM..TAddressStore B ON A.AddressStoreId=B.AddressStoreId
		WHERE
			A.CRMContactId IN (@CRMContactId, @CRMContactId2)
		GROUP BY
			A.CRMContactId, B.AddressLine1
	) AS B ON A.RelatedtoAddress = B.AddressLine1 AND A.CRMContactId = B.CRMContactId
	LEFT JOIN policymanagement..TPolicyBusiness pb ON pb.PolicyBusinessId = A.PolicyBusinessId
	LEFT JOIN factfind..TDetailedincomebreakdown I on A.IncomeId = I.DetailedincomebreakdownId
WHERE
	(A.CRMContactId = @CRMContactId
	OR (A.CRMContactId = @CRMContactId2 AND @CRMContactId2 IS NOT NULL)
	OR A.CRMContactId2 = @CRMContactId)
	AND (I.EndDate is null or I.EndDate > @CurrentUserDate)
	AND A.IsHolding = 0 

SELECT @AssetIdsString = COALESCE(@AssetIdsString + ', ' + CAST(AssetsId as varchar(20)), CAST(AssetsId as varchar(20)))
	FROM #Assets;

INSERT INTO @AssetCurrentValues
SELECT AssetId, AssetValuationHistoryId, Valuation, ValuationDate
	FROM [FnRetrieveAssetCurrentValues] (@AssetIdsString);

UPDATE asset
SET ValuedOn = currentValue.ValuationDate,
	Amount = currentValue.Valuation
FROM #Assets asset
LEFT JOIN @AssetCurrentValues currentValue ON currentValue.AssetId = asset.AssetsId;

SELECT
	AssetsId,
	CRMContactId,
	CRMContactId2,
	[Owner],
	[Description],
	DescriptionDropDownList,
	Amount,
	policymanagement.dbo.FnGetCurrencyRate(CurrencyCode, @RegionalCurrency) * Amount as AmountConverted,
	CurrencyCode as AssetCurrency,
	CASE WHEN CurrencyCode = @RegionalCurrency THEN 0 ELSE 1 END AS IsExchangeRateMessageShown ,
	@RegionalCurrency as TotalCurrency,
	ValuedOn,
	PriceUpdatedByUser,
	[Type],
	PurchasePrice,
	PurchasedOn,
	PolicyBusinessId,
	AssetCategoryId,
	PercentOwnership as PercentOwnershipPdf,
	Owner2PercentOwnership as Owner2PercentOwnershipPdf,
	RelatedtoAddress,
	ConcurrencyId,
	AddressStoreId,
	IncludeInTotalCalculation,
	MonthlyAssetIncomeNetAmount
FROM #Assets

SELECT * FROM factfind.dbo.TCurrenteState WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TCurrentProtectionNotes WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TCurrentRetirementNotes WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)

DROP TABLE IF EXISTS #Dependants;

SELECT *
INTO #Dependants
FROM factfind.dbo.TDependants
WHERE CRMContactId = @CRMContactId OR (CRMContactId=@CRMContactId2 AND @CRMContactId2 IS NOT NULL) OR CRMContactId2=@CRMContactId

UPDATE #Dependants
SET Age = CASE WHEN MONTH(dob) < MONTH(@Now) OR (MONTH(dob) = MONTH(@Now) AND DAY(dob) <= DAY(@Now)) THEN DATEDIFF(YEAR, dob, @Now)
	ELSE DATEDIFF(YEAR, dob, @Now) - 1 END
WHERE DOB is not null

SELECT * FROM #Dependants ORDER BY DependantsId

SELECT * FROM TDependantsNotes WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
--Now a Custom entity to manage owner records-------------------------------------------------------------------

-- Getting income types having end-date only in the past and generated from the Employments
SELECT i.DetailedincomebreakdownId
    , i.CRMContactId
    , i.CRMContactId2
    , (CASE
        WHEN (i.CRMContactId IS NOT NULL AND i.CRMContactId2 IS NOT NULL) THEN 'Joint'
        WHEN (i.CRMContactId IS NOT NULL) THEN CONCAT(C.FirstName, ' ', c.LastName)
    END) AS Owner
    , ISNULL(
        i.[Description]
        -- Try to get description from employment record
        , CASE WHEN i.EmploymentDetailIdValue IS NOT NULL THEN
            CASE
                WHEN ed.EmploymentStatus IN ('Self-Employed', 'Contract Worker') THEN ed.EmploymentStatus + ISNULL(', ' + ed.[Role], '')
                WHEN LEN(ISNULL(ed.[Role], '')) > 0 AND LEN(ISNULL(ed.Employer, '')) > 0 THEN CONCAT(ed.[Role], ', ', ed.Employer)
                WHEN LEN(ISNULL(ed.[Role], '')) > 0 THEN ed.[Role]
                WHEN LEN(ISNULL(ed.[Employer], '')) > 0 THEN ed.Employer
                ELSE 'Employment Income'
            END
        END
    ) AS [Description]
    , i.Frequency
    , i.StartDate
    , i.EndDate
    , i.IncomeType
    , i.ConcurrencyId
    , i.HasIncludeInAffordability
    , i.EmploymentDetailIdValue
    , i.Amount
    , CASE WHEN i.IncomeType = 'Wage/Salary (net)' OR i.IncomeType = 'Mortgage Subsidy' OR i.IncomeType = 'Non-taxable Investment Income'
        THEN NULL
        ELSE i.Amount
    END AS GrossAmount
    , i.NetAmount
    , ed.EmploymentStatus
    , ed.EndDate AS EmploymentEndDate
    , i.LastUpdatedDate AS LastUpdated
FROM
    factfind.dbo.TDetailedincomebreakdown i
    LEFT JOIN factfind.dbo.TEmploymentDetail ed ON ed.EmploymentDetailId = i.EmploymentDetailIdValue
    LEFT JOIN (
        SELECT i.DetailedincomebreakdownId
        FROM factfind.dbo.TDetailedincomebreakdown i
        INNER JOIN (
            SELECT MAX(dib.EndDate) EndDateYear, dib.EmploymentDetailIdValue
            FROM factfind.dbo.TDetailedincomebreakdown dib
            GROUP BY dib.EmploymentDetailIdValue
        ) dibMax ON i.EmploymentDetailIdValue = dibMax.EmploymentDetailIdValue AND dibMax.EndDateYear = i.EndDate
        INNER JOIN factfind.dbo.TEmploymentDetail ed ON i.EmploymentDetailIdValue = ed.EmploymentDetailId
        WHERE ed.EmploymentStatus IN ('Self-Employed', 'Contract Worker')
    ) amount ON amount.DetailedincomebreakdownId = i.DetailedincomebreakdownId
    LEFT JOIN CRM.dbo.TCRMContact C ON i.CRMContactId = c.CRMContactId
WHERE
    (
        (i.CRMContactId = @CRMContactId AND i.CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
        OR (i.CRMContactId = @CRMContactId2 AND i.CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
        OR (i.CRMContactId = @CRMContactId AND (i.CRMContactId2 IS NULL OR @CRMContactId2 IS NULL)) --single expenses for Cl1
        OR (i.CRMContactId2 = @CRMContactId AND @CRMContactId2 IS NULL) --single expenses for Cl1
        OR (i.CRMContactId = @CRMContactId2 AND i.CRMContactId2 IS NULL) --single expenses for Cl2
    )
    AND (i.EndDate IS NULL OR i.EndDate > @Now)
UNION ALL
SELECT i.DetailedincomebreakdownId
    , i.CRMContactId
    , i.CRMContactId2
    , (CASE
        WHEN (i.CRMContactId IS NOT NULL AND i.CRMContactId2 IS NOT NULL) THEN 'Joint'
        WHEN (i.CRMContactId IS NOT NULL) THEN CONCAT(C.FirstName, ' ', c.LastName)
    END) AS Owner
    , ISNULL(
        i.[Description]
        -- Try to get description from employment record
        , CASE WHEN i.EmploymentDetailIdValue IS NOT NULL THEN
            CASE
                WHEN ed.EmploymentStatus IN ('Self-Employed', 'Contract Worker') THEN ed.EmploymentStatus + ISNULL(', ' + ed.[Role], '')
                WHEN LEN(ISNULL(ed.[Role], '')) > 0 AND LEN(ISNULL(ed.Employer, '')) > 0 THEN CONCAT(ed.[Role], ', ', ed.Employer)
                WHEN LEN(ISNULL(ed.[Role], '')) > 0 THEN ed.[Role]
                WHEN LEN(ISNULL(ed.[Employer], '')) > 0 THEN ed.Employer
                ELSE 'Employment Income'
            END
        END
    ) AS [Description]
    , i.Frequency
    , i.StartDate
    , i.EndDate
    , i.IncomeType
    , i.ConcurrencyId
    , i.HasIncludeInAffordability
    , i.EmploymentDetailIdValue
    , i.Amount
    , CASE WHEN i.IncomeType = 'Wage/Salary (net)' OR i.IncomeType = 'Mortgage Subsidy' OR i.IncomeType = 'Non-taxable Investment Income'
        THEN NULL
        ELSE i.Amount
    END AS GrossAmount
    , i.NetAmount
    , ed.EmploymentStatus
    , ed.EndDate AS EmploymentEndDate
    , i.LastUpdatedDate AS LastUpdated
FROM
    factfind.dbo.TDetailedincomebreakdown i
    LEFT JOIN factfind.dbo.TEmploymentDetail ed ON ed.EmploymentDetailId = i.EmploymentDetailIdValue
    LEFT JOIN (
        SELECT i.DetailedincomebreakdownId
        FROM factfind.dbo.TDetailedincomebreakdown i
        INNER JOIN (
            SELECT MAX(dib.EndDate) EndDateYear, dib.EmploymentDetailIdValue
            FROM factfind.dbo.TDetailedincomebreakdown dib
            GROUP BY dib.EmploymentDetailIdValue
        ) dibMax ON i.EmploymentDetailIdValue = dibMax.EmploymentDetailIdValue AND dibMax.EndDateYear = i.EndDate
        INNER JOIN factfind.dbo.TEmploymentDetail ed ON i.EmploymentDetailIdValue = ed.EmploymentDetailId
        WHERE ed.EmploymentStatus IN ('Self-Employed', 'Contract Worker')
    ) amount ON amount.DetailedincomebreakdownId = i.DetailedincomebreakdownId
    LEFT JOIN CRM.dbo.TCRMContact C ON i.CRMContactId = c.CRMContactId
WHERE
    (
        (i.CRMContactId = @CRMContactId AND i.CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
        OR (i.CRMContactId = @CRMContactId2 AND i.CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
        OR (i.CRMContactId = @CRMContactId AND (i.CRMContactId2 IS NULL OR @CRMContactId2 IS NULL)) --single expenses for Cl1
        OR (i.CRMContactId2 = @CRMContactId AND @CRMContactId2 IS NULL) --single expenses for Cl1
        OR (i.CRMContactId = @CRMContactId2 AND i.CRMContactId2 IS NULL) --single expenses for Cl2
    )
    AND (i.EndDate <= @Now AND amount.DetailedincomebreakdownId IS NOT NULL)
ORDER BY i.DetailedincomebreakdownId

----------------------------------------------------------------------------------------------------------------
DECLARE @TEmploymentDetail TABLE
(
	[EmploymentDetailId] [int] NOT NULL,
	[CRMContactId] [int] NOT NULL,
	[EmploymentStatus] [varchar](512) NULL,
	[Role] [varchar](512) NULL,
	[RefOccupationId] [int] NULL,
	[Employer] [varchar](512) NULL,
	[EmployerAddress] [varchar](1536) NULL,
	[Title] [varchar](512) NULL,
	[Share] [varchar](512) NULL,
	[StartDate] [datetime] NULL,
	[Packaging] [bit] NULL,
	[PackagingDetails] [varchar](1536) NULL,
	[ChangeEmployment] [bit] NULL,
	[Salary] [money] NULL,
	[ReviewDate] [datetime] NULL,
	[BenefitsInKind] [money] NULL,
	[Allowances] [money] NULL,
	[Commissions] [money] NULL,
	[Bonus] [money] NULL,
	[NonTaxableDetails] [varchar](1536) NULL,
	[OtherTaxable] [money] NULL,
	[OtherNonTaxable] [money] NULL,
	[Total] [money] NULL,
	[ExpectedIncomeChange] [bit] NULL,
	[ExpectedIncomeChangeAmount] [money] NULL,
	[ConcurrencyId] [int] NOT NULL,
	[IntendedRetirementAge] [tinyint] NULL,
	[GrossAnnualEarnings] [money] NULL,
	[InProbation] [bit] NULL,
	[ProbationPeriod] [varchar](16) NULL,
	[HasProjectionsForCurrentYear] [bit] NULL,
	[HasStatementOfAccounts] [bit] NULL,
	[HasTaxReturns] [bit] NULL,
	[NumberOfYearsAccountsAvailable] [varchar](16) NULL,
	[EmployerAddressLine1] [varchar](255) NULL,
	[EmployerAddressLine2] [varchar](255) NULL,
	[EmployerAddressLine3] [varchar](255) NULL,
	[EmployerAddressLine4] [varchar](255) NULL,
	[EmployerCityTown] [varchar](255) NULL,
	[RefCountyId] [int] NULL,
	[RefCountryId] [int] NULL,
	[EmployerPostcode] [varchar](255) NULL,
	[PreviousGrossProfitPdf] [money] NULL,
	[PreviousNetProfitPdf] [money] NULL,
	[PreviousGrossDividendPdf] [money] NULL,
	[PreviousNetDividendPdf] [money] NULL,
	[PreviousSalaryGrossPdf] [money] NULL,
	[PreviousSalaryPdf] [money] NULL,
	[PreviousShareOfCompanyProfitPdf] [money] NULL,
	[PreviousFinancialYearEndDatePdf] [datetime] NULL,
	[SecondPreviousNetProfitPdf] [money] NULL,
	[SecondPreviousGrossProfitPdf] [money] NULL,
	[SecondPreviousGrossDividendPdf] [money] NULL,
	[SecondPreviousNetDividendPdf] [money] NULL,
	[SecondPreviousSalaryPdf] [money] NULL,
	[SecondPreviousSalaryGrossPdf] [money] NULL,
	[SecondPreviousShareOfCompanyProfitPdf] [money] NULL,
	[SecondPreviousFinancialYearEndDatePdf] [datetime] NULL,
	[ThirdPreviousGrossProfitPdf] [money] NULL,
	[ThirdPreviousNetProfitPdf] [money] NULL,
	[ThirdPreviousNetDividendPdf] [money] NULL,
	[ThirdPreviousGrossDividendPdf] [money] NULL,
	[ThirdPreviousSalaryPdf] [money] NULL,
	[ThirdPreviousSalaryGrossPdf] [money] NULL,
	[ThirdPreviousShareOfCompanyProfitPdf] [money] NULL,
	[ThirdPreviousFinancialYearEndDatePdf] [datetime] NULL,
	[IsPastEmployment] [bit] NULL,
	[EmploymentHistoryId] [int] NULL,
	[EndDate] [datetime] NULL,
	[BasicAnnualIncome] [money] NULL,
	[GuaranteedOvertime] [money] NULL,
	[GuaranteedBonus] [money] NULL,
	[RegularOvertime] [money] NULL,
	[RegularBonus] [money] NULL,
	[MigrationRef] [varchar](255) NULL,
	[AnyOvertimeIncome] [bit] NULL,
	[AnyBonusIncome] [bit] NULL,
	[NetBasicMonthlyIncome] [money] NULL,
	[NetBasicMonthlyIncomeInAffordability] [bit] NULL,
	[NetGuaranteedOvertime] [money] NULL,
	[NetGuaranteedOvertimeInAffordability] [bit] NULL,
	[NetGuaranteedBonus] [money] NULL,
	[NetGuaranteedBonusInAffordability] [bit] NULL,
	[NetRegularOvertime] [money] NULL,
	[NetRegularOvertimeInAffordability] [bit] NULL,
	[NetRegularBonus] [money] NULL,
	[NetRegularBonusInAffordability] [bit] NULL,
	[OtherGrossIncome] [money] NULL,
	[RecentGrossPreTaxProfit] [money] NULL,
	[Class] [varchar](100) NOT NULL,
	[ProbationPeriodMonths] [tinyint] NULL,
	[AccountsAvailableYears] [tinyint] NULL,
	[EmploymentHistoryDuplicateId] [int] NULL,
	[EmploymentBusinessType] [varchar](50) NULL
)
INSERT INTO @TEmploymentDetail
SELECT 
	[EmploymentDetailId]
	,[CRMContactId]
	,[EmploymentStatus]
	,[Role]
	,[RefOccupationId]
	,[Employer]
	,[EmployerAddress]
	,[Title]
	,[Share]
	,[StartDate]
	,[Packaging]
	,[PackagingDetails]
	,[ChangeEmployment]
	,[Salary]
	,[ReviewDate]
	,[BenefitsInKind]
	,[Allowances]
	,[Commissions]
	,[Bonus]
	,[NonTaxableDetails]
	,[OtherTaxable]
	,[OtherNonTaxable]
	,[Total]
	,[ExpectedIncomeChange]
	,[ExpectedIncomeChangeAmount]
	,[ConcurrencyId]
	,[IntendedRetirementAge]
	,[GrossAnnualEarnings]
	,[InProbation]
	,[ProbationPeriod]
	,[HasProjectionsForCurrentYear]
	,[HasStatementOfAccounts]
	,[HasTaxReturns]
	,[NumberOfYearsAccountsAvailable]
	,[EmployerAddressLine1]
	,[EmployerAddressLine2]
	,[EmployerAddressLine3]
	,[EmployerAddressLine4]
	,[EmployerCityTown]
	,[RefCountyId]
	,[RefCountryId]
	,[EmployerPostcode]
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,[PreviousFinancialYearEndDate]
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,[SecondPreviousFinancialYearEndDate]
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,[ThirdPreviousFinancialYearEndDate]
	,[IsPastEmployment]
	,[EmploymentHistoryId]
	,[EndDate]
	,[BasicAnnualIncome]
	,[GuaranteedOvertime]
	,[GuaranteedBonus]
	,[RegularOvertime]
	,[RegularBonus]
	,[MigrationRef]
	,[AnyOvertimeIncome]
	,[AnyBonusIncome]
	,[NetBasicMonthlyIncome]
	,[NetBasicMonthlyIncomeInAffordability]
	,[NetGuaranteedOvertime]
	,[NetGuaranteedOvertimeInAffordability]
	,[NetGuaranteedBonus]
	,[NetGuaranteedBonusInAffordability]
	,[NetRegularOvertime]
	,[NetRegularOvertimeInAffordability]
	,[NetRegularBonus]
	,[NetRegularBonusInAffordability]
	,[OtherGrossIncome]
	,[RecentGrossPreTaxProfit]
	,[Class]
	,[ProbationPeriodMonths]
	,[AccountsAvailableYears]
	,[EmploymentHistoryDuplicateId]
	,[EmploymentBusinessType]
FROM factfind..TEmploymentDetail
WHERE CRMContactId IN (@CRMContactId,@CRMContactId2) AND (EndDate IS NULL OR EndDate >= @Today)

DECLARE @EmpIncomes TABLE
(
	[DetailedincomebreakdownId] [int] NOT NULL,
	[CRMContactId] [int] NOT NULL,
	[IncomeType] [varchar](255) NULL,
	[EmploymentDetailIdValue] [int] NULL,
	[NetAmount] [money] NULL,
	[GrossAmount] [money] NULL,
	[EndDate] [datetime] NULL
)
INSERT INTO @EmpIncomes
SELECT 
TD.DetailedincomebreakdownId,
TD.CRMContactId,
TD.IncomeType,
EmploymentDetailIdValue,
TD.NetAmount,
TD.Amount,
TD.EndDate
FROM factfind..TDetailedincomebreakdown TD
JOIN @TEmploymentDetail TE ON TE.CRMContactId = TD.CRMContactId AND TD.IncomeType in ('Income earned as a partner/sole proprietor','Wage/Salary (net)','Dividends','Basic Income','Share of Company Profit') AND TE.EmploymentDetailId = TD.EmploymentDetailIdValue

UPDATE @TEmploymentDetail SET PreviousGrossProfitPdf = EI.GrossAmount,
PreviousNetProfitPdf = EI.NetAmount
FROM @TEmploymentDetail TE
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE EI.IncomeType = 'Income earned as a partner/sole proprietor' AND TE.PreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET PreviousSalaryGrossPdf = EI.GrossAmount
FROM @TEmploymentDetail TE
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE EI.IncomeType = 'Basic Income' AND EI.GrossAmount <> 0 AND TE.PreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET PreviousSalaryPdf = EI.NetAmount
FROM @TEmploymentDetail TE
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE ((EmploymentStatus = 'Self-Employed' AND EI.IncomeType = 'Basic Income') OR EI.IncomeType = 'Wage/Salary (net)') AND EI.NetAmount <> 0 
	AND TE.PreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET PreviousNetDividendPdf = EI.NetAmount,
PreviousGrossDividendPdf = EI.GrossAmount
FROM @TEmploymentDetail TE
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE EI.IncomeType = 'Dividends' AND TE.PreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET PreviousShareOfCompanyProfitPdf = EI.GrossAmount
FROM @TEmploymentDetail TE 
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE EI.IncomeType = 'Share of Company Profit' AND TE.PreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET SecondPreviousNetProfitPdf = EI.NetAmount,
SecondPreviousGrossProfitPdf = EI.GrossAmount
FROM @TEmploymentDetail TE
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE EI.IncomeType = 'Income earned as a partner/sole proprietor' AND TE.SecondPreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET SecondPreviousSalaryPdf = EI.NetAmount
FROM @TEmploymentDetail TE
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE ((EmploymentStatus = 'Self-Employed' AND EI.IncomeType = 'Basic Income') OR EI.IncomeType = 'Wage/Salary (net)') AND EI.NetAmount <> 0 
	AND TE.SecondPreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET SecondPreviousSalaryGrossPdf = EI.GrossAmount
FROM @TEmploymentDetail TE
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE EI.IncomeType = 'Basic Income' AND EI.GrossAmount <> 0 AND TE.SecondPreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET SecondPreviousNetDividendPdf = EI.NetAmount,
SecondPreviousGrossDividendPdf = EI.GrossAmount
FROM @TEmploymentDetail TE
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE EI.IncomeType = 'Dividends' AND TE.SecondPreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET SecondPreviousShareOfCompanyProfitPdf = EI.GrossAmount
FROM @TEmploymentDetail TE 
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE EI.IncomeType = 'Share of Company Profit' AND TE.SecondPreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET ThirdPreviousNetProfitPdf = EI.NetAmount,
ThirdPreviousGrossProfitPdf = EI.GrossAmount
FROM @TEmploymentDetail TE
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE EI.IncomeType = 'Income earned as a partner/sole proprietor' AND TE.ThirdPreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET ThirdPreviousSalaryPdf = EI.NetAmount
FROM @TEmploymentDetail TE
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE ((EmploymentStatus = 'Self-Employed' AND EI.IncomeType = 'Basic Income') OR EI.IncomeType = 'Wage/Salary (net)') AND EI.NetAmount <> 0 
	AND TE.ThirdPreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET ThirdPreviousSalaryGrossPdf = EI.GrossAmount
FROM @TEmploymentDetail TE
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE EI.IncomeType = 'Basic Income' AND EI.GrossAmount <> 0 AND TE.ThirdPreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET ThirdPreviousNetDividendPdf = EI.NetAmount,
ThirdPreviousGrossDividendPdf = EI.GrossAmount
FROM @TEmploymentDetail TE
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE EI.IncomeType = 'Dividends' AND TE.ThirdPreviousFinancialYearEndDatePdf = EI.EndDate

UPDATE @TEmploymentDetail SET ThirdPreviousShareOfCompanyProfitPdf = EI.GrossAmount
FROM @TEmploymentDetail TE 
JOIN @EmpIncomes EI ON TE.EmploymentDetailId = EI.EmploymentDetailIdValue AND TE.CRMContactId = EI.CRMContactId
WHERE EI.IncomeType = 'Share of Company Profit' AND TE.ThirdPreviousFinancialYearEndDatePdf = EI.EndDate

SELECT *, RefCountyId AS RefEmployerCountyId, RefCountryId AS RefEmployerCountryId,
	case
		when StartDate is null OR (EndDate is NULL AND StartDate > @Now) then null
		when (EndDate is null OR EndDate > @Now) AND StartDate < @Now then dbo.FnDifferenceTotalMonths(StartDate, @Now)
		else dbo.FnDifferenceTotalMonths(StartDate, EndDate)end as ContinuousEmploymentMonths,
		Case when RefCountryId = 1 then EmployerPostcode
		else null end AS EmployerPostcodeUk,
		ISNULL(BasicAnnualIncome,0) +
		ISNULL(GuaranteedOvertime,0) +
		ISNULL(GuaranteedBonus,0) +
		ISNULL(RegularOvertime,0) +
		ISNULL(RegularBonus,0) +
		ISNULL(OtherGrossIncome,0) +
		ISNULL(PreviousNetProfitPdf,0) +
		ISNULL(PreviousNetDividendPdf,0) +
		ISNULL(PreviousSalaryPdf,0) as Earnings,
		ISNULL(NetBasicMonthlyIncomeInAffordability, 0) as BasicIncomeInAffordability,
		ISNULL(NetGuaranteedOvertimeInAffordability, 0) as GuaranteedOvertimeInAffordability,
		ISNULL(NetGuaranteedBonusInAffordability, 0) as GuaranteedBonusInAffordability,
		ISNULL(NetRegularOvertimeInAffordability, 0) as RegularOvertimeInAffordability,
		ISNULL(NetRegularBonusInAffordability, 0) as RegularBonusInAffordability
FROM @TEmploymentDetail  

SELECT * FROM factfind.dbo.Testateissuesactions WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.Testateneednotes WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.Testateneeds WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.TExpenditureNotes WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.Tincomenotes WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.Tinvestmentneednotes WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)

--Now a Custom entity to manage owner records-------------------------------------------------------------------
DROP TABLE IF EXISTS #Liabilities;

SELECT *, CASE WHEN ISNULL(EndDate, @Today) >= @Today THEN 1 ELSE 0 END AS IsActive
INTO #Liabilities
FROM factfind.dbo.Tliabilities
WHERE CRMContactId = @CRMContactId OR (CRMContactId=@CRMContactId2 AND @CRMContactId2 IS NOT NULL) OR CRMContactId2=@CRMContactId

SELECT *, InterestRate AS InterestRateValue FROM #Liabilities
----------------------------------------------------------------------------------------------------------------

SELECT * FROM factfind.dbo.TLiabilityNotes WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.TLifestyleGoals WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.TOccupationNotes WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.TProtectionNeeds WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.TRetirePlanningExisting WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.TYourRetirement WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.TPolicyFFExt WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.TPersonFFExt WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
SELECT * FROM factfind.dbo.TProfileNotes WHERE CRMContactId IN (@CRMContactId)
SELECT * FROM CRM..TDataProtectionAct WHERE CRMContactId IN (@CRMContactId,@CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)
SELECT * FROM CRM..TMarketing WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

SELECT BudgetMiscellaneousId, CRMContactId, TotalEarnings, Tax, AnyAssets, ISNULL( AssetsNonDisclosure, 'False') AS AssetsNonDisclosure,
AnyLiabilities, LiabilitiesRepayment, LiabilitiesWhyNot, RepaymentDetails, LiabilitiesNonDisclosure, BudgetNotes, ConcurrencyId, AssetLiabilityNotes, LiabilityNotes
FROM TBudgetMiscellaneous WHERE CRMContactId IN (@CRMContactId,@CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

SELECT * FROM factfind.dbo.TCashDepositFFExt WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TFinalSalaryFFExt WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TMoneyPurchaseFFExt WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TOtherInvestmentFFExt WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TRetirementFFExt WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TSavingsFFExt WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TProtectionGoalsNeeds WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TRetirementGoalsNeeds WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TSavingsGoalsNeeds WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TEstateGoalsNeeds WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TProtectionNextSteps WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TRetirementNextSteps WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)

SELECT * FROM factfind.dbo.TSavingsNextSteps WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TEstateNextSteps WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TEstateCurrentPosition WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)
SELECT * FROM factfind.dbo.TRetirementGoalsNeedsQuestion WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

SELECT * FROM factfind.dbo.TPreExistingCashDepositPlansQuestions WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)

SELECT * FROM factfind.dbo.TPreExistingFinalSalaryPensionPlansQuestions WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)
SELECT * FROM factfind.dbo.TPreExistingMoneyPurchasePlansQuestions WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)
SELECT * FROM factfind.dbo.TPreExistingOtherInvestmentPlansQuestions WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)
SELECT * FROM factfind.dbo.TPreExistingProtectionPlansQuestions WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

SELECT * FROM factfind.dbo.TPostExistingCashDepositPlansQuestions WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)
SELECT * FROM factfind.dbo.TPostExistingMoneyPurchasePlansQuestions WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)
SELECT * FROM factfind.dbo.TPostExistingOtherInvestmentPlansQuestions WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)
SELECT * FROM factfind.dbo.TPostExistingProtectionPlansQuestions WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)
SELECT * FROM factfind.dbo.TPostExistingFinalSalaryPensionPlansQuestions WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

-- ATR

SELECT @IsNewAtr = CASE WHEN t.Value = 'Yes' THEN 1 ELSE 0 END
FROM administration.dbo.TIndigoClientPreference t
WHERE t.IndigoClientId = @IndigoClientId and t.PreferenceName = 'Feature_HasNewAtr'

IF @IsNewAtr = 0
	BEGIN
		SELECT @TemplateGuid = T.Guid, @TemplateBaseGuid = T.BaseAtrTemplate, @TemplateId= T.AtrTemplateId
		FROM factfind.dbo.TAtrTemplate T
		WHERE T.IndigoClientId = @IndigoClientId AND T.Active = 1

		SELECT AR.*, AQC.AtrQuestionId, @TemplateId as AtrTemplateId, ACC.AtrCategoryId
		FROM factfind.dbo.TAtrInvestment AR
			JOIN TAtrQuestionCombined AQC ON AQC.[Guid] = AR.AtrQuestionGuid
			JOIN TAtrCategoryQuestion ACQ ON (ACQ.AtrQuestionGuid = AR.AtrQuestionGuid And ACQ.AtrTemplateGuid = @TemplateGuid)
			JOIN TAtrCategoryCombined ACC ON (ACQ.AtrCategoryGuid = ACC.[Guid])
		Where AQC.AtrTemplateGuid = ISNULL(@TemplateBaseGuid, @TemplateGuid)
		And AR.CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		SELECT AR.[AtrRetirementId],AR.[AtrQuestionGuid],AR.[AtrAnswerGuid],AR.[CRMContactId],AR.[ConcurrencyId],
			AR.[FreeTextAnswer],AQC.AtrQuestionId, @TemplateId as AtrTemplateId, ACC.AtrCategoryId
		FROM factfind.dbo.TAtrRetirement AR
			JOIN TAtrQuestionCombined AQC ON AQC.[Guid] = AR.AtrQuestionGuid
			JOIN TAtrCategoryQuestion ACQ ON (ACQ.AtrQuestionGuid = AR.AtrQuestionGuid And ACQ.AtrTemplateGuid = @TemplateGuid)
			JOIN TAtrCategoryCombined ACC ON (ACQ.AtrCategoryGuid = ACC.[Guid])
		Where AQC.AtrTemplateGuid = ISNULL(@TemplateBaseGuid, @TemplateGuid)
		And AR.CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		SELECT * FROM factfind.dbo.TAtrInvestmentGeneral WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		-- AtrInvestmentChosenProfile
		SELECT AtrInvestmentGeneralId, CRMContactId, Client1ChosenProfileGuid, CalculatedRiskProfile as SelectedRiskProfile
		FROM factfind.dbo.TAtrInvestmentGeneral WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		-- AtrInvestmentClient2Agrees
		SELECT AtrInvestmentGeneralId, CRMContactId, Client2AgreesWithAnswers
		FROM factfind.dbo.TAtrInvestmentGeneral WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		-- AtrInvestmentConsistency
		SELECT AtrInvestmentGeneralId, CRMContactId, InconsistencyNotes
		FROM factfind.dbo.TAtrInvestmentGeneral WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		-- AtrInvestmentReplayProfile
		SELECT AtrInvestmentGeneralId, CRMContactId, Client1AgreesWithProfile, Client1ChosenProfileGuid, Client1Notes, Client1Notes as ClientNotesOnAgree
		FROM factfind.dbo.TAtrInvestmentGeneral WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		SELECT *, Client1Notes as ClientNotesOnAgree FROM factfind.dbo.TAtrRetirementGeneral WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		-- AtrRetirementChosenProfile
		SELECT AtrRetirementGeneralId, CRMContactId, Client1ChosenProfileGuid, CalculatedRiskProfile as SelectedRiskProfile
		FROM factfind.dbo.TAtrRetirementGeneral WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		-- AtrRetirementClient2Agrees
		SELECT AtrRetirementGeneralId, CRMContactId, Client2AgreesWithAnswers
		FROM factfind.dbo.TAtrRetirementGeneral WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		-- AtrRetirementConsistency
		SELECT AtrRetirementGeneralId, CRMContactId, InconsistencyNotes
		FROM factfind.dbo.TAtrRetirementGeneral WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		-- AtrRetirementReplayProfile
		SELECT AtrRetirementGeneralId, CRMContactId, Client1AgreesWithProfile, Client1ChosenProfileGuid, Client1Notes, Client1Notes as ClientNotesOnAgree
		FROM factfind.dbo.TAtrRetirementGeneral WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)
	END
ELSE
	BEGIN
		INSERT INTO @AtrTemplateIds
		SELECT T.AtrTemplateId, T.Guid, T.BaseAtrTemplate, B.AtrTemplateId as BaseAtrTemplateId
		FROM factfind.dbo.TAtrTemplate T
		LEFT JOIN factfind.dbo.TAtrTemplate B on B.Guid = T.BaseAtrTemplate
		WHERE T.IndigoClientId = @IndigoClientId AND T.Active = 1

		SELECT TOP 1 @LastAtrInvestmentTemplateId = ISNULL(g.[TemplateId], t.AtrTemplateId)
		FROM factfind.dbo.TAtrInvestmentGeneral g
			LEFT JOIN policymanagement..TRiskProfile p ON p.[Guid] = g.CalculatedRiskProfile OR p.[Guid] = ISNULL(g.Client1ChosenProfileGuid, g.Client2ChosenProfileGuid)		
			LEFT JOIN factfind..TAtrInvestment i ON i.CRMContactId = g.CRMContactId
			LEFT JOIN factfind..TAtrQuestion q ON q.[Guid] = i.AtrQuestionGuid		
			LEFT JOIN factfind..TAtrTemplate t ON t.AtrTemplateId = g.TemplateId OR t.[Guid] = ISNULL(p.AtrTemplateGuid, q.AtrTemplateGuid)
			INNER JOIN @AtrTemplateIds a ON a.AtrTemplateId = ISNULL(g.TemplateId, t.AtrTemplateId) OR a.BaseAtrTemplateGuid = t.[Guid]
		WHERE g.CRMContactId IN (@CRMContactId, @CRMContactId2) 
			AND EXISTS(SELECT s.AtrTemplateId FROM factfind.dbo.TAtrTemplateSetting s WHERE t.AtrTemplateId = s.AtrTemplateId) 
		ORDER BY (CASE WHEN g.CRMContactId = @CRMContactId THEN 1 ELSE 2 END)	

		SELECT TOP 1 @LastAtrRetirementTemplateId = ISNULL(g.[TemplateId], t.AtrTemplateId)
		FROM factfind.dbo.TAtrRetirementGeneral g
			LEFT JOIN policymanagement..TRiskProfile p ON p.[Guid] = g.CalculatedRiskProfile OR p.[Guid] = ISNULL(g.Client1ChosenProfileGuid, g.Client2ChosenProfileGuid)		
			LEFT JOIN factfind..TAtrRetirement i ON i.CRMContactId = g.CRMContactId
			LEFT JOIN factfind..TAtrQuestion q ON q.[Guid] = i.AtrQuestionGuid		
			LEFT JOIN factfind..TAtrTemplate t ON t.[Guid] = ISNULL(p.AtrTemplateGuid, q.AtrTemplateGuid)
			INNER JOIN @AtrTemplateIds a ON a.AtrTemplateId = ISNULL(g.TemplateId, t.AtrTemplateId) OR a.BaseAtrTemplateGuid = t.[Guid]
		WHERE g.CRMContactId IN (@CRMContactId, @CRMContactId2)
		ORDER BY (CASE WHEN g.CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		SELECT AR.*, AQC.AtrQuestionId, a.AtrTemplateId, ACC.AtrCategoryId
		FROM factfind.dbo.TAtrInvestment AR
			JOIN TAtrQuestionCombined AQC ON AQC.[Guid] = AR.AtrQuestionGuid
			JOIN @AtrTemplateIds a ON AQC.AtrTemplateGuid = ISNULL(a.BaseAtrTemplateGuid, a.AtrTemplateGuid)
			JOIN TAtrCategoryQuestion ACQ ON (ACQ.AtrQuestionGuid = AR.AtrQuestionGuid And ACQ.AtrTemplateGuid = a.AtrTemplateGuid)
			JOIN TAtrCategoryCombined ACC ON (ACQ.AtrCategoryGuid = ACC.[Guid])
		WHERE AR.CRMContactId IN (@CRMContactId, @CRMContactId2) AND a.AtrTemplateId = @LastAtrInvestmentTemplateId
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		SELECT AR.[AtrRetirementId],AR.[AtrQuestionGuid],AR.[AtrAnswerGuid],AR.[CRMContactId],AR.[ConcurrencyId],
			AR.[FreeTextAnswer],AQC.AtrQuestionId, a.AtrTemplateId, ACC.AtrCategoryId
		FROM factfind.dbo.TAtrRetirement AR
			JOIN TAtrQuestionCombined AQC ON AQC.[Guid] = AR.AtrQuestionGuid
			JOIN @AtrTemplateIds a ON AQC.AtrTemplateGuid = ISNULL(a.BaseAtrTemplateGuid, a.AtrTemplateGuid)
			JOIN TAtrCategoryQuestion ACQ ON (ACQ.AtrQuestionGuid = AR.AtrQuestionGuid And ACQ.AtrTemplateGuid = a.AtrTemplateGuid)
			JOIN TAtrCategoryCombined ACC ON (ACQ.AtrCategoryGuid = ACC.[Guid])
		Where AR.CRMContactId IN (@CRMContactId, @CRMContactId2) AND a.AtrTemplateId = @LastAtrRetirementTemplateId
		ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		-- We need to get TemplateId that was used to submit answers (so that correct risk notes and risk profile data are displayed). 
		-- Currently data may be in at least 3 different states. Cases are as follows:
		-- TAtrInvestmentGeneral contains TemplatId (the simplest case) 
		-- TAtrInvestmentGeneral doesn't contain TemplateId, but does contain CalculatedRiskProfile or Client1ChosenProfileGuid (trying to get TemplateId via policymanagement..TRiskProfile)
		-- TAtrInvestment doesn't contain either TemplateId or CalculatedRiskProfile or Client1ChosenProfileGuid (trying to get TemplateId via factfind..TAtrInvestment)

		INSERT INTO @AtrInvestmentGeneral 
		SELECT a.*
		FROM (
			SELECT distinct g.[AtrInvestmentGeneralSyncId],
				g.[AtrInvestmentGeneralId],
				g.[CRMContactId],
				g.[Client2AgreesWithAnswers],
				g.[Client1AgreesWithProfile],
				g.[Client2AgreesWithProfile],
				g.[Client1ChosenProfileGuid],
				g.[Client2ChosenProfileGuid],
				g.[ConcurrencyId],
				g.[Client1Notes],
				g.[Client2Notes],
				g.[InconsistencyNotes],
				g.[CalculatedRiskProfile],
				g.[RiskDiscrepency],
				g.[RiskProfileAdjustedDate],
				g.[AdviserNotes],
				g.[DateOfRiskAssessment],
				g.[WeightingSum],
				g.[LowerBand],
				g.[UpperBand],
				ISNULL(g.[TemplateId], t.AtrTemplateId) AS TemplateId,
				a.BaseAtrTemplateId
			FROM factfind.dbo.TAtrInvestmentGeneral g
			LEFT JOIN policymanagement..TRiskProfile p ON p.[Guid] = g.CalculatedRiskProfile OR p.[Guid] = ISNULL(g.Client1ChosenProfileGuid, g.Client2ChosenProfileGuid)		
			LEFT JOIN factfind..TAtrInvestment i ON i.CRMContactId = g.CRMContactId
			LEFT JOIN factfind..TAtrQuestion q ON q.[Guid] = i.AtrQuestionGuid		
			LEFT JOIN factfind..TAtrTemplate t ON t.[Guid] = ISNULL(p.AtrTemplateGuid, q.AtrTemplateGuid) -- GUIDs will point at base template (not the one created off the base one) in case it was used to submit ATR answers
			INNER JOIN @AtrTemplateIds a ON a.AtrTemplateId = ISNULL(g.TemplateId, t.AtrTemplateId) OR a.BaseAtrTemplateGuid = t.[Guid] -- TAtrInvestmentGeneral may contain Calculated/Chosen risk profiles of a base template, so base templates are included in search
			WHERE g.CRMContactId IN (@CRMContactId, @CRMContactId2) 
				AND a.AtrTemplateId = @LastAtrInvestmentTemplateId) a 
		ORDER BY (CASE WHEN a.CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

		INSERT @AtrRetirementGeneral 
		SELECT ret.*
		FROM (
			SELECT distinct g.[AtrRetirementGeneralSyncId],
				g.[AtrRetirementGeneralId],
				g.[TAtrRetirementGeneralId],
				g.[CRMContactId],
				g.[Client2AgreesWithAnswers],
				g.[Client1AgreesWithProfile],
				g.[Client2AgreesWithProfile],
				g.[Client1ChosenProfileGuid],
				g.[Client2ChosenProfileGuid],
				g.[ConcurrencyId],
				g.[Client1Notes],
				g.[Client2Notes],
				g.[InconsistencyNotes],
				g.[CalculatedRiskProfile],
				g.[RiskDiscrepency],
				g.[RiskProfileAdjustedDate],
				g.[AdviserNotes],
				g.[DateOfRiskAssessment],
				g.[WeightingSum],
				g.[LowerBand],
				g.[UpperBand],
				ISNULL(g.[TemplateId], t.AtrTemplateId) AS TemplateId,
				a.BaseAtrTemplateId
			FROM factfind.dbo.TAtrRetirementGeneral g
			LEFT JOIN policymanagement..TRiskProfile p ON p.[Guid] = g.CalculatedRiskProfile OR p.[Guid] = ISNULL(g.Client1ChosenProfileGuid, g.Client2ChosenProfileGuid)		
			LEFT JOIN factfind..TAtrRetirement i ON i.CRMContactId = g.CRMContactId
			LEFT JOIN factfind..TAtrQuestion q ON q.[Guid] = i.AtrQuestionGuid		
			LEFT JOIN factfind..TAtrTemplate t ON t.[Guid] = ISNULL(p.AtrTemplateGuid, q.AtrTemplateGuid)
			INNER JOIN @AtrTemplateIds a ON a.AtrTemplateId = ISNULL(g.TemplateId, t.AtrTemplateId) OR a.BaseAtrTemplateGuid = t.[Guid]
			WHERE g.CRMContactId IN (@CRMContactId, @CRMContactId2) AND a.AtrTemplateId = @LastAtrRetirementTemplateId) ret
		ORDER BY (CASE WHEN ret.CRMContactId = @CRMContactId THEN 1 ELSE 2 END)		

		SET @Client2AgreesWithAnswers = CASE WHEN (
											SELECT TOP 1 AtrInvestmentGeneralId 
											FROM @AtrInvestmentGeneral 
											WHERE Client2AgreesWithAnswers IS NULL OR Client2AgreesWithAnswers = 0) 
										IS NOT NULL THEN 0 ELSE 1 END;

		SELECT [AtrInvestmentGeneralSyncId],
			[AtrInvestmentGeneralId],
			[CRMContactId],
			@Client2AgreesWithAnswers AS Client2AgreesWithAnswers,
			[Client1AgreesWithProfile],
			[Client2AgreesWithProfile],
			[Client1ChosenProfileGuid],
			[Client2ChosenProfileGuid],
			[ConcurrencyId],
			[Client1Notes],
			[Client2Notes],
			[InconsistencyNotes],
			[CalculatedRiskProfile],
			[RiskDiscrepency],
			[RiskProfileAdjustedDate],
			[AdviserNotes],
			[DateOfRiskAssessment],
			[WeightingSum],
			[LowerBand],
			[UpperBand],
			[TemplateId],
			[BaseAtrTemplateId]
		from @AtrInvestmentGeneral
		
		-- AtrInvestmentChosenProfile
		SELECT g.AtrInvestmentGeneralId, g.CRMContactId, g.Client1ChosenProfileGuid, g.CalculatedRiskProfile as SelectedRiskProfile
		from @AtrInvestmentGeneral g

		-- AtrInvestmentClient2Agrees
		SELECT g.AtrInvestmentGeneralId, g.CRMContactId, g.Client2AgreesWithAnswers
		from @AtrInvestmentGeneral g

		-- AtrInvestmentConsistency
		SELECT g.AtrInvestmentGeneralId, g.CRMContactId, g.InconsistencyNotes
		from @AtrInvestmentGeneral g

		-- AtrInvestmentReplayProfile
		SELECT g.AtrInvestmentGeneralId, g.CRMContactId, g.Client1AgreesWithProfile, g.Client1ChosenProfileGuid, g.Client1Notes, g.Client1Notes as ClientNotesOnAgree
		FROM @AtrInvestmentGeneral g

		SET @Client2AgreesWithAnswers = CASE WHEN (
											SELECT TOP 1 AtrRetirementGeneralId 
											FROM @AtrRetirementGeneral 
											WHERE Client2AgreesWithAnswers IS NULL OR Client2AgreesWithAnswers = 0) 
										IS NOT NULL THEN 0 ELSE 1 END;

		SELECT [AtrRetirementGeneralSyncId],
			[AtrRetirementGeneralId],
			[TAtrRetirementGeneralId],
			[CRMContactId],
			@Client2AgreesWithAnswers AS Client2AgreesWithAnswers,
			[Client1AgreesWithProfile],
			[Client2AgreesWithProfile],
			[Client1ChosenProfileGuid],
			[Client2ChosenProfileGuid],
			[ConcurrencyId],
			[Client1Notes],
			[Client2Notes],
			[InconsistencyNotes],
			[CalculatedRiskProfile],
			[RiskDiscrepency],
			[RiskProfileAdjustedDate],
			[AdviserNotes],
			[DateOfRiskAssessment],
			[WeightingSum],
			[LowerBand],
			[UpperBand],
			[TemplateId], 
			Client1Notes as ClientNotesOnAgree,
			[BaseAtrTemplateId]
		FROM @AtrRetirementGeneral		

		-- AtrRetirementChosenProfile
		SELECT AtrRetirementGeneralId, CRMContactId, Client1ChosenProfileGuid, CalculatedRiskProfile as SelectedRiskProfile
		FROM @AtrRetirementGeneral		

		-- AtrRetirementClient2Agrees
		SELECT AtrRetirementGeneralId, CRMContactId, @Client2AgreesWithAnswers AS Client2AgreesWithAnswers
		FROM @AtrRetirementGeneral		

		-- AtrRetirementConsistency
		SELECT AtrRetirementGeneralId, CRMContactId, InconsistencyNotes
		FROM @AtrRetirementGeneral		

		-- AtrRetirementReplayProfile
		SELECT AtrRetirementGeneralId, CRMContactId, Client1AgreesWithProfile, Client1ChosenProfileGuid, Client1Notes, Client1Notes as ClientNotesOnAgree
		FROM @AtrRetirementGeneral	
END

-- Investment objectives (ownership is worked out in code)
SELECT o.ObjectiveId AS InvestmentObjectiveId
    , o.RefGoalCategoryId AS RefGoalCatogoryId
    , o.ObjectiveId
    , o.Objective
    , o.TargetAmount
    , o.StartDate
    , o.TargetDate
    , o.RegularImmediateIncome
    , o.ReasonForChange
    , o.RiskProfileGuid
    , o.CRMContactId
    , o.ObjectiveTypeId
    , o.IsFactFind
    , o.Details
    , o.Frequency
    , o.RetirementAge
    , o.LumpSumAtRetirement
    , o.AnnualPensionIncome
    , o.ConcurrencyId
    , o.CRMContactId2
    , o.GoalType
    , o.RiskDiscrepency
    , o.RiskProfileAdjustedDate
    , o.RefLumpsumAtRetirementTypeId
    , o.RefGoalCategoryId
    , o.RefIncreaseRateId
    , o.MarkedAsCompletedDate
    , o.AccountId
    , o.PlanId
    , o.IsCreatedByClient
    , o.MarkedAsCompletedByUserId
    , o.IsAtRetirement
    , o.TermInYears
FROM factfind.dbo.TObjective o
WHERE o.ObjectiveTypeId = 1 AND o.IsFactFind = 1 AND o.CRMContactId IN (@CRMContactId, @CRMContactId2)
UNION
SELECT o.ObjectiveId AS InvestmentObjectiveId
    , o.RefGoalCategoryId AS RefGoalCatogoryId
    , o.ObjectiveId
    , o.Objective
    , o.TargetAmount
    , o.StartDate
    , o.TargetDate
    , o.RegularImmediateIncome
    , o.ReasonForChange
    , o.RiskProfileGuid
    , o.CRMContactId
    , o.ObjectiveTypeId
    , o.IsFactFind
    , o.Details
    , o.Frequency
    , o.RetirementAge
    , o.LumpSumAtRetirement
    , o.AnnualPensionIncome
    , o.ConcurrencyId
    , o.CRMContactId2
    , o.GoalType
    , o.RiskDiscrepency
    , o.RiskProfileAdjustedDate
    , o.RefLumpsumAtRetirementTypeId
    , o.RefGoalCategoryId
    , o.RefIncreaseRateId
    , o.MarkedAsCompletedDate
    , o.AccountId
    , o.PlanId
    , o.IsCreatedByClient
    , o.MarkedAsCompletedByUserId
    , o.IsAtRetirement
    , o.TermInYears
FROM factfind.dbo.TObjective o
WHERE o.ObjectiveTypeId = 1 AND o.IsFactFind = 1 AND o.CRMContactId2 = @CRMContactId;

-- Retirement objectives (ownership is worked out in code)
SELECT o.ObjectiveId AS RetirementObjectiveId
    , o.RefGoalCategoryId AS RefGoalCatogoryId
    , CASE
        WHEN RefLumpsumAtRetirementTypeId = 1 THEN CONVERT(VARCHAR, CAST(LumpSumAtRetirement AS MONEY))
        ELSE CONVERT(VARCHAR, CAST(LumpSumAtRetirement AS MONEY)) + '%'
    END AS LumpSumForGrid
    , o.ObjectiveId
    , o.Objective
    , o.TargetAmount
    , o.StartDate
    , o.TargetDate
    , o.RegularImmediateIncome
    , o.ReasonForChange
    , o.RiskProfileGuid
    , o.CRMContactId
    , o.ObjectiveTypeId
    , o.IsFactFind
    , o.Details
    , o.Frequency
    , o.RetirementAge
    , o.LumpSumAtRetirement
    , o.AnnualPensionIncome
    , o.ConcurrencyId
    , o.CRMContactId2
    , o.GoalType
    , o.RiskDiscrepency
    , o.RiskProfileAdjustedDate
    , o.RefLumpsumAtRetirementTypeId
    , o.RefGoalCategoryId
    , o.RefIncreaseRateId
    , o.MarkedAsCompletedDate
    , o.AccountId
    , o.PlanId
    , o.IsCreatedByClient
    , o.MarkedAsCompletedByUserId
    , o.IsAtRetirement
    , o.TermInYears
    , o.LumpSumAtRetirement AS LumpSumAtRetirementPercentage
FROM factfind.dbo.TObjective o
WHERE o.ObjectiveTypeId = 2 AND o.IsFactFind = 1 AND o.CRMContactId IN (@CRMContactId, @CRMContactId2)
UNION
SELECT o.ObjectiveId AS RetirementObjectiveId
    , o.RefGoalCategoryId AS RefGoalCatogoryId
    , CASE
        WHEN RefLumpsumAtRetirementTypeId = 1 THEN CONVERT(VARCHAR, CAST(LumpSumAtRetirement AS MONEY))
        ELSE CONVERT(VARCHAR, CAST(LumpSumAtRetirement AS MONEY)) + '%'
    END AS LumpSumForGrid
	, o.ObjectiveId
    , o.Objective
    , o.TargetAmount
    , o.StartDate
    , o.TargetDate
    , o.RegularImmediateIncome
    , o.ReasonForChange
    , o.RiskProfileGuid
    , o.CRMContactId
    , o.ObjectiveTypeId
    , o.IsFactFind
    , o.Details
    , o.Frequency
    , o.RetirementAge
    , o.LumpSumAtRetirement
    , o.AnnualPensionIncome
    , o.ConcurrencyId
    , o.CRMContactId2
    , o.GoalType
    , o.RiskDiscrepency
    , o.RiskProfileAdjustedDate
    , o.RefLumpsumAtRetirementTypeId
    , o.RefGoalCategoryId
    , o.RefIncreaseRateId
    , o.MarkedAsCompletedDate
    , o.AccountId
    , o.PlanId
    , o.IsCreatedByClient
    , o.MarkedAsCompletedByUserId
    , o.IsAtRetirement
    , o.TermInYears
    , o.LumpSumAtRetirement AS LumpSumAtRetirementPercentage
FROM factfind.dbo.TObjective o
WHERE o.ObjectiveTypeId = 2 AND o.IsFactFind = 1 AND o.CRMContactId2 = @CRMContactId;

-- Declaration + Disclosure
SELECT
	DeclarationId,
	CRMContactId,
	-- these fields are free text but users often store dates in them - format dates correctly but return everything else as text
	CASE
		WHEN CompletedDate IS NULL THEN FactFind.dbo.fn_GetCompletedDate (@CRMContactId,'Date Fact Find Completed', @TenantId)
		ELSE CompletedDate
	END AS CompletedDate,
	CASE
		WHEN IDCheckedDate IS NULL THEN FactFind.dbo.fn_GetCompletedDate (@CRMContactId,'Date ID and Money Laundering Checked', @TenantId)
		ELSE IdCheckedDate
	END AS IDCheckedDate,
	CASE
		WHEN DeclarationDate IS NULL THEN FactFind.dbo.fn_GetCompletedDate (@CRMContactId,'Date Declaration Signed', @TenantId)
		ELSE DeclarationDate
	END AS DeclarationDate,
	ConcurrencyId
FROM
	FactFind..TDeclaration a
WHERE
	CRMContactId IN (@CRMContactId,@CRMContactId2)
ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

SELECT * FROM TDeclarationNotes WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)
ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

-- Get org address details
EXEC Administration..[SpNCustomGetOrganisationNameAndAddressForReport] 'Fact Find', @FrontPageAdviserCrmId, 'Organisation', @TenantId 

SELECT * FROM
factfind.dbo.TProfessionalContact
WHERE CRMContactId IN (@CRMContactId,@CRMContactId2)

-- Find Opportunities for the FF clients
INSERT INTO @Opps
SELECT
	OpportunityId
FROM
	CRM..TOpportunityCustomer
WHERE
	PartyId IN (@CRMContactId, @CRMContactId2)

--Case 18213 Mortgages
SELECT
	M.MortgageOpportunityId AS MortgageRequirementsId,
	M.OpportunityId,
	O.SequentialRef,
	-- Get owners, these are then managed in c#
	OC1.PartyId AS CRMContactId,
	CASE WHEN OC2.PartyId != OC1.PartyId THEN OC2.PartyId END AS CRMContactId2,
	M.LoanPurpose,
	M.LoanAmount,
	M.LTV,
	M.RefMortgageBorrowerTypeId,
	IIF(M.Term IS NOT NULL, CONCAT(FLOOR(M.Term), 'y ', CAST(ROUND((M.Term % 1) * 12, 0) AS INT), 'm'), '') AS TermPdf,
	M.RefMortgageRepaymentMethodId AS RepaymentMethod,
	M.InterestOnly,
	M.Repayment,
	M.Price,
	M.Deposit,
	M.PlanPurpose,
	M.CurrentLender,
	M.CurrentLoanAmount,
	M.MonthlyRentalIncome,
	M.[Owner],
	M.RelationshipCRMContactId,
	OET.Name as EmploymentType,
	M.IncomeAmount,
	M.RepaymentAmountMonthly,
	M.StatusFg,
	M.SelfCertFg,
	M.NonStatusFg,
	M.ExPatFg,
	M.ForeignCitizenFg,
	M.TrueCostOverTerm,
	M.ConcurrencyId,
	M.SourceOfDeposit,
	M.InterestOnlyRepaymentVehicle,
	M.RelatedAddressStoreId,
	M.RepaymentOfExistingMortgage,
	M.HomeImprovements,
	M.DebtConsolidation,
	M.MortgageFees,
	M.Other AS MROther,
	M.GuarantorMortgageFg AS IsGuarantorMortgage,
	M.GuarantorText,
	M.DebtConsolidatedFg AS IsDebtConsolidated,
	M.DebtConsolidationText,
	IIF(M.RepaymentTerm IS NOT NULL, CONCAT(FLOOR(M.RepaymentTerm), 'y ', CAST(ROUND((M.RepaymentTerm % 1) * 12, 0) AS INT), 'm'), '') AS RepaymentTermPdf,
	IIF(M.InterestOnlyTerm IS NOT NULL, CONCAT(FLOOR(M.InterestOnlyTerm), 'y ', CAST(ROUND((M.InterestOnlyTerm % 1) * 12, 0) AS INT), 'm'), '') AS InterestOnlyTermPdf,
	M.Details,
	M.InterestDetails,
	M.RefMortgageSaleTypeId,
	M.IsHighNetWorthClient,
	M.IsMortgageForBusiness,
	M.IsProfessionalClient,
	M.IsRejectedAdvice,
	M.ExecutionOnlyDetails,
	CASE WHEN OT.OpportunityTypeName != 'Equity Release' THEN M.RefOpportunityType2ProdSubTypeId END AS RefOpportunityType2ProdSubTypeId,
	M.IsFirstTimeBuyer,
	CASE WHEN OT.OpportunityTypeName = 'Equity Release' THEN M.RefEquityReleaseTypeId END AS RefEquityReleaseTypeId,
	M.PercentageOwnershipSold,
	M.LumpsumAmount,
	M.MonthlyIncomeAmount,
	CAST(CASE WHEN OT.OpportunityTypeName = 'Equity Release' THEN 1 ELSE 0 END AS bit) AS IsEquityRelease,
	CASE
		WHEN OC1.PartyId = @CRMContactId AND FirstOwnerId = SecondOwnerId THEN
			(SELECT SUM(Amount) FROM #Liabilities WHERE (CRMContactId = @CRMContactId OR CRMContactId2 = @CRMContactId) AND IsConsolidated = 1)
		WHEN OC1.PartyId = @CRMContactId2 AND FirstOwnerId = SecondOwnerId THEN
			(SELECT SUM(Amount) FROM #Liabilities WHERE (CRMContactId = @CRMContactId2 OR CRMContactId2 = @CRMContactId2) AND IsConsolidated = 1)
		WHEN FirstOwnerId != SecondOwnerId THEN
			(SELECT SUM(Amount) FROM #Liabilities WHERE IsConsolidated = 1)
	END AS SumOfDebtConsolidation,
	M.RefMortgageRepaymentMethodId
FROM
	CRM..TMortgageOpportunity M
	JOIN CRM..TOpportunity O on O.OpportunityId = M.OpportunityId
	LEFT JOIN CRM..TOpportunityType OT on O.OpportunityTypeId = OT.OpportunityTypeId
	LEFT JOIN CRM..TRefOpportunityType2ProdSubType OT2PST ON OT2PST.RefOpportunityType2ProdSubTypeId = M.RefOpportunityType2ProdSubTypeId
	LEFT JOIN CRM..TRefOpportunityEmploymentType OET ON OET.RefOpportunityEmploymentTypeId = M.RefOpportunityEmploymentTypeId
	LEFT JOIN Policymanagement..TProdSubType PST ON PST.ProdSubTypeId = OT2PST.ProdSubTypeId
	JOIN (
		SELECT
			OpportunityId,
			MIN(OpportunityCustomerId) AS FirstOwnerId,
			MAX(OpportunityCustomerId) AS SecondOwnerId
		FROM
			CRM..TOpportunityCustomer OC
		WHERE
			OpportunityId IN (SELECT Id FROM @Opps)
		GROUP BY
			OpportunityId) AS Owners ON Owners.OpportunityId = O.OpportunityId
	JOIN CRM..TOpportunityCustomer OC1 ON OC1.OpportunityCustomerId = Owners.FirstOwnerId
	JOIN CRM..TOpportunityCustomer OC2 ON OC2.OpportunityCustomerId = Owners.SecondOwnerId
WHERE
	O.OpportunityId IN (SELECT Id FROM @Opps)
	AND ISNULL(O.IsClosed,0) = 0
ORDER BY
	SequentialRef desc

SELECT * FROM factfind.dbo.TMortgageRequireExt WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT MortgagePreferencesId, CRMContactId,
	LikelyToChange, IncomeTimescale, ExpenditureTimescale, RedeemFg, AvoidUncertainty, FixingPayments, UpperLimitEarly,
	MinPaymEarly, LendingChargeFg, Speed, AddFeeFg, VaryRepaym, VaryNoPenalty, OverpayNoPenalty, Underpay, PaymHoliday,
	LinkToAccount, FreeLegalFees, NoValFee, ValRefunded, BookingFeeFg, Cashback, PrefLenderFg, BorrowingsFg, AddBorrowingsFg,
	FreeLegalFeesImpFg, NotSteppedFg, OffsetFg, BorrowBack, CreditCard, Other, FeesRef, Portable, ConcurrencyId,
	LikelyToMove, ExpectedMoveDate, HighLendingCharge, DailyInterestRates, ClubFeeMortgageAdvance
FROM factfind.dbo.TMortgagePreferences WHERE CRMContactId = @CRMContactId
SELECT * FROM TMortgagePrefNotes WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
-- Credit History.
SELECT *,
	COALESCE(DateRegistered, DateDischarged, DateRepossessed) AS DateForGrid,
	COALESCE(AmountRegistered, AmountOutstanding) AS AmountForGrid
FROM factfind.dbo.TCreditHistory WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)

SELECT MortgageRiskId, CRMContactId, RiskInterestChange, RiskMortgRepaid, RiskInvestVehicle, RiskCharge, RiskOverhang, RiskMaxYears, ConcurrencyId
FROM factfind.dbo.TMortgageRisk WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)

SELECT MortgageRiskNotesId, CRMContactId, RiskComment, ConcurrencyId FROM factfind.dbo.TMortgageRiskNotes WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TChecklist T1 WHERE T1.CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)
SELECT * FROM factfind.dbo.TMortExProvAdNotes T1 WHERE T1.CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TAdditionalExpenses T1 WHERE T1.CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TMortgageRequireStatus T1 WHERE T1.CRMContactId IN (@CRMContactId, @CRMContactId2)

SELECT v.*, vt.VerificationDate
FROM CRM..TVerification v
LEFT JOIN (
	SELECT TOP 1 * FROM
	CRM..TVerificationHistory vt
	WHERE vt.CRMContactId = @CRMContactId
	ORDER BY (CASE WHEN vt.UpdatedOn IS NOT NULL THEN vt.UpdatedOn ELSE vt.CreatedOn END) DESC
	UNION
	SELECT TOP 1 * FROM
	CRM..TVerificationHistory vt
	WHERE vt.CRMContactId = @CRMContactId2
	ORDER BY (CASE WHEN vt.UpdatedOn IS NOT NULL THEN vt.UpdatedOn ELSE vt.CreatedOn END) DESC
) AS vt ON vt.CRMContactId = v.CRMContactId
WHERE v.CRMContactId IN (@CRMContactId, @CRMContactId2)
ORDER BY (CASE WHEN v.CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

-- BudgetIncome, was previously stored in TBudgetMiscellaneous but has now been moved to TPerson.
SELECT
	P.PersonId AS BudgetIncomeId,
	C.CRMContactId,
	P.ConcurrencyId,
	P.Salary
FROM
	CRM..TCRMContact C
	JOIN CRM..TPerson P ON P.PersonId = C.PersonId
WHERE
	C.CRMContactId IN (@CRMContactId, @CRMContactId2)
ORDER BY (CASE WHEN CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

SELECT * FROM factfind.dbo.TATRInvestmentCategory where CRMContactId = @CRMContactId
SELECT * FROM factfind.dbo.TATRRetirementCategory where CRMContactId = @CRMContactId

-- Mortgage R4 Additions.
SELECT EH.CRMContactId,
	EH.Employer,
	EH.StartDate,
	EH.EndDate,
	ISNULL(BasicAnnualIncome,0) +
	ISNULL(GuaranteedOvertime,0) +
	ISNULL(GuaranteedBonus,0) +
	ISNULL(RegularOvertime,0) +
	ISNULL(RegularBonus,0) +
	ISNULL(OtherGrossIncome,0) +
	ISNULL(PreviousFinancialYear,0) as GrossAnnualEarnings
FROM
	factfind.dbo.TEmploymentDetail EH
WHERE
	EH.CRMContactId IN (@CRMContactId, @CRMContactId2)
	AND (EndDate IS NOT NULL AND EndDate < @Today)

SELECT * FROM factfind.dbo.TIncome WHERE CRMContactId IN (@CRMContactId)
SELECT * FROM factfind.dbo.TExpenditure WHERE CRMContactId IN (@CRMContactId)
SELECT * FROM factfind.dbo.TMortgageMiscellaneous WHERE CRMContactId IN (@CRMContactId)
SELECT MortgageMiscellaneousId as MortgageMiscellaneousEqRelId, CRMContactId, HasEquityRelease FROM factfind.dbo.TMortgageMiscellaneous WHERE CRMContactId IN (@CRMContactId)

-- Protection
SELECT ProtectionMiscellaneousId, ConcurrencyId, CRMContactId, HasExistingProvision,
	NonDisclosure, Notes, ISNULL(IncomeReplacementRate, @IncomeReplacementRate) AS IncomeReplacementRate
FROM
	factfind.dbo.TProtectionMiscellaneous WHERE CRMContactId = @CRMContactId

SELECT *, Construction AS ConstructionType FROM factfind.dbo.TPropertyDetail WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)

SELECT pd.[PropertyDetailId]
    , pd.[HouseType]
    , pd.[PropertyType]
    , a.[TenureType]
    , pd.[LeaseholdEndsOn]
    , a.[PropertyStatus]
    , pd.[Construction]
    , pd.[NumberOfBedrooms]
    , pd.[YearBuilt]
    , pd.[ConstructionNotes]
    , pd.[RoofConstructionType]
    , pd.[RoofConstructionNotes]
    , pd.[IsNewBuild]
    , pd.[NHBCCertificateCovered]
    , pd.[OtherCertificateCovered]
    , pd.[CertificateNotes]
    , pd.[BuilderName]
    , pd.[RefAdditionalPropertyDetailId]
    , pd.[IsExLocalAuthority]
    , pd.[IsOutbuildings]
    , pd.[NumberOfOutbuildings]
    , pd.[Construction] AS ConstructionType
    , a.[AddressId] AS RelatedAddressId
    , a.[CRMContactId] AS OwnerId
    , [as].[AddressLine1]
    , [as].[AddressLine2]
    , [as].[AddressLine3]
    , [as].[AddressLine4]
    , [as].[CityTown]
    , county.[CountyCode] AS RefCountyCode
    , country.[CountryCode] AS RefCountryCode
    , [as].[Postcode]
    , a.RefAddressTypeId
    , a.AddressTypeName
    , a.RefAddressStatusId
    , a.ResidencyStatus
    , a.ResidentFromDate
    , a.ResidentToDate
    , a.DefaultFg AS IsDefault
    , a.IsRegisteredOnElectoralRoll
FROM crm.dbo.TAddress AS a
INNER JOIN crm.dbo.TAddressStore AS [as] ON [as].AddressLine1 IS NOT NULL AND a.AddressStoreId = [as].AddressStoreId
INNER JOIN crm.dbo.TRefCountry country ON country.RefCountryId = [as].RefCountryId
LEFT JOIN CRM.dbo.TRefCounty county ON county.RefCountyId = [as].RefCountyId
INNER JOIN factfind.dbo.TPropertyDetail pd ON a.AddressStoreId = pd.RelatedAddressStoreId
INNER JOIN (
    SELECT MIN(pd.PropertyDetailId) PropertyDetailId
    FROM factfind.dbo.TPropertyDetail pd
    GROUP BY pd.RelatedAddressStoreId
) pdMin ON pd.PropertyDetailId = pdMin.PropertyDetailId
WHERE a.CRMContactId IN (@CRMContactId, @CRMContactId2) AND a.IsPotentialMortgage = 1
ORDER BY pd.CRMContactId;

SELECT en.EmploymentNoteId, en.ConcurrencyId, en.CRMContactId, en.Note
FROM factfind.dbo.TEmploymentNote en
WHERE en.CRMContactId = @CRMContactId

-- Expenditure Grid, we may need to include liabilities here
DECLARE @LiabilityExpenditureGroupName varchar(50) = 'Liability Expenditure'
DECLARE @todayDate date = CONVERT (date, @CurrentUserDate)

DROP TABLE IF EXISTS #ExpenditureDetails;

SELECT
    ExpenditureDetailId, E.ConcurrencyId, E.CRMContactId, E.CRMContactId2, ET.RefExpenditureTypeId,
	EG.Name AS ExpenditureGroupName, ET.Name AS ExpenditureType, ET.Ordinal,
	dbo.FnConvertAmountToMonthlyFrequency(ISNULL(E.NetAmount, 0), E.Frequency) AS NetMonthlyAmount,
	E.NetAmount AS NetAmount,
	CASE
		WHEN E.NetAmount IS NULL THEN NULL
		ELSE
		CASE
			WHEN E.Frequency = 'FourWeekly' THEN 'Four Weekly'
			WHEN E.Frequency = 'HalfYearly' THEN 'Half Yearly'
			ELSE E.Frequency
		END
	END as Frequency,
	CASE WHEN EG.IsConsolidateEnabled = 1 THEN E.IsConsolidated ELSE NULL END AS IsConsolidated,
	CASE WHEN EG.IsConsolidateEnabled = 1 THEN E.IsLiabilityToBeRepaid ELSE NULL END AS IsLiabilityToBeRepaid,
	UserDescription,
	0 AS IsLiability,
	1 AS IsActive,
	(CASE WHEN (E.CRMContactId IS NOT NULL AND E.CRMContactId2 IS NOT NULL)
			THEN 'Joint'
		WHEN (E.CRMContactId IS NOT NULL)
			THEN CONCAT(C.FirstName, ' ', C.LastName)
	END) AS Owner
INTO #ExpenditureDetails
FROM
	factfind.dbo.TRefExpenditureType AS ET
	LEFT JOIN factfind.dbo.TExpenditureDetail E ON ET.RefExpenditureTypeId = E.RefExpenditureTypeId
		AND
		(
			(E.CRMContactId = @CRMContactId AND E.CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
			OR (E.CRMContactId = @CRMContactId2 AND E.CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
			OR (E.CRMContactId = @CRMContactId AND E.CRMContactId2 IS NULL ) --single expenses for Cl1
			OR (E.CRMContactId = @CRMContactId2 AND E.CRMContactId2 IS NULL ) --single expenses for Cl2
		) AND ISNULL(E.StartDate, @todayDate) <= @todayDate AND ISNULL(E.EndDate, @todayDate) >= @todayDate
	LEFT JOIN CRM..TCRMContact C ON E.CRMContactId = C.CRMContactId
	INNER JOIN factfind.dbo.TRefExpenditureType2ExpenditureGroup ET2EG ON ET2EG.ExpenditureTypeId = ET.RefExpenditureTypeId
	INNER JOIN factfind.dbo.TRefExpenditureGroup EG ON EG.RefExpenditureGroupId = ET2EG.ExpenditureGroupId AND EG.TenantId = @IndigoClientId
WHERE (ET.RefExpenditureTypeId NOT IN (4,5,23,26,36,37,38,39,21,22) OR IsNull(NetMonthlyAmount,0)!=0 OR ISNull(UserDescription,'')!='')
	--Don't include Monthly Liability Expenditure if client wants to see liabilities.
	AND NOT (@UseLiabilitiesInExpenditure = 1 AND EG.Name = @LiabilityExpenditureGroupName) AND EG.Name != 'Expenditures'
UNION ALL
SELECT
	NULL AS ExpenditureDetailId, L.ConcurrencyId, L.CRMContactId, CRMContactId2, NULL AS RefExpenditureTypeId,
	@LiabilityExpenditureGroupName AS ExpenditureGroupName, CommitedOutgoings AS ExpenditureType, 100000 AS Ordinal,
	PaymentAmountPerMonth AS NetMonthlyAmount,
	PaymentAmountPerMonth AS NetAmount, ISNULL(L.RepaymentFrequency,'Monthly') AS Frequency,
	IsConsolidated, IsToBeRepaid AS IsLiabilityToBeRepaid,
	[Description] AS UserDescription, 1 AS IsLiability,
	IsActive,
	(CASE WHEN (L.CRMContactId IS NOT NULL AND L.CRMContactId2 IS NOT NULL)
	 THEN 'Joint'
		WHEN (L.CRMContactId IS NOT NULL)
			THEN CONCAT(C.FirstName, ' ', C.LastName)
	 END) AS [Owner]
FROM
	#Liabilities AS L
	LEFT JOIN CRM..TCRMContact C ON L.CRMContactId = C.CRMContactId
WHERE
	@UseLiabilitiesInExpenditure = 1
ORDER BY Ordinal, ExpenditureType

SELECT * FROM #ExpenditureDetails WHERE IsActive = 1

-- Ref Expenditure Information
SELECT RefExpenditureTypeId, eg.Name AS ExpenditureGroupName, et.Name, et.Ordinal
FROM factfind.dbo.TRefExpenditureType et
     INNER JOIN factfind.dbo.TRefExpenditureType2ExpenditureGroup et2eg ON et2eg.ExpenditureTypeId = et.RefExpenditureTypeId
	 INNER JOIN factfind.dbo.TRefExpenditureGroup eg ON eg.RefExpenditureGroupId = et2eg.ExpenditureGroupId AND eg.TenantId = @IndigoClientId
WHERE NOT (@UseLiabilitiesInExpenditure=1 AND eg.Name=@LiabilityExpenditureGroupName)
ORDER BY Ordinal

SELECT *, eg.Name AS ExpenditureGroupName
FROM factfind.dbo.TRefExpenditureGroup eg
WHERE eg.TenantId = @IndigoClientId AND EG.Name != 'Expenditures'
ORDER BY Ordinal
-- Protection
SELECT * FROM factfind.dbo.TLifeCoverAndCic WHERE CRMContactId = @CRMContactId
SELECT * FROM factfind.dbo.TIncomeProtection WHERE CRMContactId = @CRMContactId
SELECT * FROM factfind.dbo.TBuildingAndContentsProtection WHERE CRMContactId = @CRMContactId

--extra risk questions
select *
from
	Administration..TRefRiskQuestion a
where
	createdby = @IndigoClientId
	and isarchived = 0
order by ordinal, question

--extra risk question answer
SELECT * FROM factfind.dbo.TExtraRiskQuestionAnswer WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)

-- GI Plans
-- Protection
SELECT DISTINCT
	Pd.PolicyBusinessId as GeneralInsurancePlanId,--Don't include Monthly Liability Expenditure if client wants to see liabilities. Pd.PolicyBusinessId,
	Pd.CRMContactId,
	Pd.CRMContactId2,
	Pd.[Owner],
	pd.SellingAdviserId,
	pd.SellingAdviserName,
	Pd.RefProdProviderId,
	Pd.RefPlanType2ProdSubTypeId,
	Pd.RefPlanType2ProdSubTypeId as RefPlanTypeId,
	Pd.RegularPremium,
	Pd.Frequency AS PremiumFrequency,
	Pd.StartDate,
	Pd.ProductName,
	Pd.AgencyStatus,
	Pd.PlanType AS PlanTypeText,
	P.PropertyInsuranceType,
	P.RenewalDate,
	B.SumAssured AS BuildingsSumInsured,
	B.ExcessAmount AS BuildingsExcess,
	B.InsuranceCoverOptions&1 AS BuildingsAccidentalDamage,
	C.SumAssured AS ContentsSumInsured,
	C.ExcessAmount AS ContentsExcess,
	C.InsuranceCoverOptions&1 AS ContentsAccidentalDamage,
	P.PremiumLoading,
	P.Exclusions,
	1 AS ConcurrencyId -- Not currently used.
FROM
	@Plans Pd
	JOIN factfind.dbo.TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId
	JOIN PolicyManagement..TProtection P ON P.PolicyBusinessId = Pd.PolicyBusinessId
	-- Buildings
	LEFT JOIN PolicyManagement..TGeneralInsuranceDetail B ON B.RefInsuranceCoverCategoryId = 1 AND B.ProtectionId = P.ProtectionId
	-- Contents
	LEFT JOIN PolicyManagement..TGeneralInsuranceDetail C ON C.RefInsuranceCoverCategoryId = 2 AND C.ProtectionId = P.ProtectionId
WHERE
	PTS.Section = 'Building and Contents Insurance'

SELECT * FROM factfind.dbo.TNeedsAndPrioritiesAnswer WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
SELECT * FROM factfind.dbo.TInvestmentGoalsNeedsQuestion WHERE CRMContactId = @CRMContactId
SELECT *, DocumentDisclosureTypeId AS DocumentDisclosureTypeIdForGrid FROM factfind.dbo.TDocumentDisclosure WHERE CRMContactId = @CRMContactId
SELECT * FROM factfind.dbo.TMortgageChecklistQuestionAnswer WHERE CRMContactId = @CRMContactId

-- Protection Needs.
SELECT *, 'Client 1' AS Client FROM TProtectionCoverNeed WHERE TenantId = @TenantId AND PartyId = @CRMContactId AND JointPartyId IS NULL
UNION ALL SELECT *, 'Client 2' AS Client FROM TProtectionCoverNeed WHERE TenantId = @TenantId AND PartyId = @CRMContactId2 AND JointPartyId IS NULL
UNION ALL SELECT *, 'Client 1 & Client 2' AS Client FROM TProtectionCoverNeed WHERE TenantId = @TenantId AND PartyId = @CRMContactId AND JointPartyId = @CRMContactId2
ORDER BY Client

-- All plans (required by Pdf to manage plans/sub plans)
SELECT
	P.PolicyBusinessId,
	P.ParentPolicyBusinessId,
	P.[Owner],
	P.SellingAdviserId,
	P.SellingAdviserName,
	P.RefPlanType2ProdSubTypeId AS RefPlanTypeId,
	P.RefPlanType2ProdSubTypeId,
	P.RefProdProviderId,
	P.LinkedToPolicyNumber,
	P.LinkedToPlanTypeProvider,
	P.PolicyNumber,
	p.AgencyStatus,
	P.PlanCurrency,
	P.ProductName,
	P.StartDate AS PolicyStartDate,
	TPI.SRA as RetirementAge,
	CASE
		WHEN P.IncludeTopupPremiums = 0 Then YC.Amount
		ELSE P.RegularPremiumWithTopups
	END AS SelfContributionAmount,
	CASE
		WHEN P.IncludeTopupPremiums = 0 Then policymanagement.dbo.FnConvertFrequency(ISNULL(YC.FrequencyName, EC.FrequencyName), EC.FrequencyName, EC.Amount)
		ELSE policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, P.PolicyBusinessId,'Employer', 'Regular', ISNULL(YC.FrequencyName, EC.FrequencyName), 0, @CurrentUserDate)
	END AS EmployerContributionAmount,
	ISNULL(YC.RefFrequencyId, EC.RefFrequencyId) AS RefContributionFrequencyId,
	CASE 
		WHEN P.IncludeTopupPremiums = 0 THEN Trans.Amount 
	ELSE policymanagement.dbo.FnCustomCalculateContributionsWithTopup(@IndigoClientId, P.PolicyBusinessId, NULL, 'Transfer', YC.FrequencyName, 0, @CurrentUserDate) 
	END AS TransferContribution,
	CASE
		WHEN P.IncludeTopupPremiums = 0 THEN LumpSum.Amount
		ELSE P.TotalLumpSumWithTopups
	END AS LumpSumContribution,
	P.Valuation as Valuation,
	P.ValuationDate,
	B.PensionCommencementLumpSum,
	B.PCLSPaidById,
	B.GADMaximumIncomeLimit,
	B.GuaranteedMinimumIncome,
	B.GADCalculationDate,
	PROT.ReviewDate AS NextReviewDate,
	B.IsCapitalValueProtected,
	B.CapitalValueProtectedAmount,
	TPI.IsIndexed as Indexed,
	TPI.IsCurrent as Preserved,
	B.LumpSumDeathBenefitAmount,
	PROT.InTrust,
	YC.Amount AS PremiumAmount,
	YC.RefFrequencyId PremiumFrequencyId,
	YC.StartDate AS PremiumStartDate,
	P.ConcurrencyId,
	P.MortgageRepayPercentage,
	P.MortgageRepayAmount,
	P.PlanStatus,
	P.PlanType,
	P.Provider,
	P.Valuation AS Value,
	TPI.GMPAmount,
	B.IsProtectedPCLS,
	PB.LowMaturityValue,
	PB.MediumMaturityValue,
	PB.HighMaturityValue,
	PB.ProjectionDetails
FROM
	@Plans P
	JOIN PolicyManagement..TPolicyBusiness PB ON PB.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN PolicyManagement..TPensionInfo TPI ON TPI.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN PolicyManagement..TProtection PROT ON PROT.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN PolicyManagement..TAssuredLife AL ON AL.OrderKey = 1 AND AL.ProtectionId = PROT.ProtectionId
	LEFT JOIN PolicyManagement..TBenefit B ON B.BenefitId = AL.BenefitId
	-- Regular Contributions
	LEFT JOIN @Contributions EC ON EC.TypeId = 1 AND EC.ContributorTypeId = 2 AND EC.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN @Contributions YC ON YC.TypeId = 1 AND YC.ContributorTypeId = 1 AND YC.PolicyBusinessId = P.PolicyBusinessId
	-- Lump Sum Contributions
	LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 2 GROUP BY PolicyBusinessId) AS LumpSum ON LumpSum.PolicyBusinessId = P.PolicyBusinessId
	LEFT JOIN (SELECT PolicyBusinessId, SUM(Amount) AS Amount FROM @Contributions WHERE TypeId = 3 GROUP BY PolicyBusinessId) AS Trans ON Trans.PolicyBusinessId = P.PolicyBusinessId
ORDER BY
	[SortId]

SELECT * FROM factfind.dbo.TStatePensionEntitlement WHERE CRMContactId IN (@CRMContactId, @CRMContactId2)
-- Additional Risk Questions + Responses

SELECT @FactFindShowNotAnsweredAdditionalRiskQuestions = [Value]
FROM administration..TIndigoClientPreference
WHERE IndigoClientId = @TenantId AND PreferenceName = 'FactFindShowNotAnsweredAdditionalRiskQuestions'

IF @FactFindShowNotAnsweredAdditionalRiskQuestions = 'True'
	SELECT *, cast(1 as bit) as IsShowRetirement, cast(1 as bit) as IsShowInvestment FROM TAdditionalRiskQuestion WHERE TenantId = @TenantId
	ORDER BY QuestionNumber
ELSE
BEGIN
	SELECT @IsAnyRetirementAnswers = COUNT(AdditionalRiskQuestionResponseId)
	FROM factfind.dbo.TAdditionalRiskQuestionResponse
	WHERE TenantId = @TenantId AND IsRetirement = 1 AND CRMContactId IN (@CRMContactId, @CRMContactId2)

	SELECT @IsAnyInvestmentAnswers = COUNT(AdditionalRiskQuestionResponseId)
	FROM factfind.dbo.TAdditionalRiskQuestionResponse
	WHERE TenantId = @TenantId AND IsRetirement = 0 AND CRMContactId IN (@CRMContactId, @CRMContactId2)

	SELECT *, @IsAnyRetirementAnswers as IsShowRetirement, @IsAnyInvestmentAnswers as IsShowInvestment
	FROM factfind.dbo.TAdditionalRiskQuestion
	WHERE TenantId = @TenantId AND (@IsAnyRetirementAnswers = 1 OR @IsAnyInvestmentAnswers = 1)
	ORDER BY QuestionNumber
END

SELECT * FROM factfind.dbo.TAdditionalRiskQuestionResponse
WHERE TenantId = @TenantId AND CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY QuestionNumber
-- Risk Question Inconsistencies
SELECT * FROM factfind.dbo.TRiskQuestionInconsistency WHERE CRMContactId IN (@CRMContactId, @CRMContactId2) ORDER BY IsAdviserNote, RiskQuestionInconsistencyId

SELECT
	IncomeChangeId, IsRise, Amount, Frequency, StartDate, [Description],
	CASE WHEN IsRise = 1 THEN 'Rise' ELSE 'Fall' END AS RiseOrFall,
	(CASE WHEN (IC.CRMContactId IS NOT NULL AND IC.CRMContactId2 IS NOT NULL AND IsOwnerSelected = 1)
			THEN 'Joint'
		WHEN (IC.CRMContactId IS NOT NULL AND IsOwnerSelected = 1)
			THEN CONCAT(C.FirstName, ' ', C.LastName) END) AS Owner
FROM factfind.dbo.TIncomeChange IC
LEFT JOIN CRM..TCRMContact C ON IC.CRMContactId = C.CRMContactId
WHERE
	(
		(IC.CRMContactId = @CRMContactId AND IC.CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
		OR (IC.CRMContactId = @CRMContactId2 AND IC.CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
		OR (IC.CRMContactId = @CRMContactId AND IC.CRMContactId2 IS NULL ) --single expenses for Cl1
		OR (IC.CRMContactId = @CRMContactId2 AND IC.CRMContactId2 IS NULL ) --single expenses for Cl2
	)

SELECT *, CASE WHEN IsRise = 1 THEN 'Rise' ELSE 'Fall' END AS RiseOrFall
FROM factfind.dbo.TExpenditureChange
WHERE CRMContactId = @CRMContactId OR (CRMContactId = @CRMContactId2 AND @CRMContactId2 IS NOT NULL)

------------------------------------------------------------------------------------------------------
IF (@CRMContactId2 IS NOT NULL)
BEGIN
	SELECT SUM(NetMonthlyAmount) as Amount
	FROM #ExpenditureDetails
	WHERE CRMContactId = @CRMContactId AND CRMContactId2 IS NULL AND IsActive = 1

	UNION ALL

	SELECT SUM(NetMonthlyAmount) as Amount
	FROM #ExpenditureDetails
	WHERE CRMContactId = @CRMContactId2 AND CRMContactId2 IS NULL AND IsActive = 1

	UNION ALL

	SELECT SUM(NetMonthlyAmount) as Amount
	FROM #ExpenditureDetails
	WHERE (CRMContactId = @CRMContactId AND CRMContactId2 = @CRMContactId2) OR (CRMContactId = @CRMContactId2 AND CRMContactId2 = @CRMContactId) AND IsActive = 1
END
ELSE
SELECT TOP 0 NULL AS Amount

-- BANK DETAILS
SELECT
	(CASE WHEN (CBA.CRMContactId IS NOT NULL AND CBA.CRMContactId2 IS NOT NULL)
		THEN 'Joint'
		WHEN (CBA.CRMContactId IS NOT NULL)
		THEN CONCAT(C.FirstName, ' ', C.LastName)
	END) AS Owner,
	CBA.BankName,
	CBA.AccountHolders,
	CBA.AddressLine1,
	CBA.AddressLine2,
	CBA.AddressLine3,
	CBA.AddressLine4,
	CBA.CityTown,
	COUNTRY.CountryCode as RefCountryCode,
	COUNTY.CountyCode as RefCountyCode,
	CBA.Postcode,
	CASE WHEN COUNTRY.RefCountryId = 1 THEN CBA.Postcode ELSE NULL END AS PostcodeUk,
	CBA.AccountNumber,
	CBA.SortCode,
	CBA.DefaultAccountFg as IsDefault
FROM crm..TClientBankAccount as CBA
LEFT JOIN CRM..TCRMContact C ON CBA.CRMContactId = C.CRMContactId
LEFT JOIN CRM..TRefCountry COUNTRY ON COUNTRY.RefCountryId = CBA.RefCountryId
LEFT JOIN CRM..TRefCounty COUNTY ON COUNTY.RefCountyId = CBA.RefCountyId
WHERE
	(
		(CBA.CRMContactId = @CRMContactId AND  CBA.CRMContactId2 = @CRMContactId2)  --joint expense with Owners combination Cl1 + Cl2
		OR (CBA.CRMContactId = @CRMContactId2 AND CBA.CRMContactId2 = @CRMContactId) --joint expense with Owners combination Cl2 + Cl1
		OR (CBA.CRMContactId = @CRMContactId AND  CBA.CRMContactId2 IS NULL ) --single expenses for Cl1
		OR (CBA.CRMContactId = @CRMContactId2 AND CBA.CRMContactId2 IS NULL ) --single expenses for Cl2
	)
ORDER BY CBA.ClientBankAccountId

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

END

GO
