# Complete Entity Relationship Diagrams (ERD)

**Document Type:** Database Schema Design
**Author Role:** Senior Database Engineer
**Date:** February 12, 2026
**Version:** 1.0

---

## Document Purpose

This document provides comprehensive Entity Relationship Diagrams (ERDs) for all bounded contexts in the FactFind system, showing:
- Complete entity structures with all properties
- Data types and constraints
- Primary keys (PK) and Foreign keys (FK)
- Relationships with cardinality
- Indexes and constraints
- Nullable fields

---

## Table of Contents

1. [Client Domain (CRM) ERD](#1-client-domain-crm-erd)
2. [FactFind Core Domain ERD](#2-factfind-core-domain-erd)
3. [Portfolio Plans Domain ERD](#3-portfolio-plans-domain-erd)
4. [Goals & Requirements Domain ERD](#4-goals--requirements-domain-erd)
5. [ATR Domain ERD](#5-atr-domain-erd)
6. [Cross-Domain Integration ERD](#6-cross-domain-integration-erd)
7. [Database Design Decisions](#7-database-design-decisions)
8. [Indexing Strategy](#8-indexing-strategy)

---

## 1. Client Domain (CRM) ERD

### 1.1 Core Client Entities

```mermaid
erDiagram
    TCRMContact ||--o{ TPerson : "PersonId (discriminator)"
    TCRMContact ||--o{ TCorporate : "CorporateId (discriminator)"
    TCRMContact ||--o{ TTrust : "TrustId (discriminator)"
    TCRMContact ||--o{ TAddress : "has multiple"
    TCRMContact ||--o{ TContactDetail : "has multiple"
    TCRMContact ||--o{ TClientVulnerability : "has assessment"
    TCRMContact ||--o{ TMarketing : "has preferences"
    TCRMContact ||--o{ TVerification : "has verification"

    TCRMContact {
        int CRMContactId PK "Identity, Clustered Index"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(20) ContactType "NOT NULL, CHECK IN (Person,Corporate,Trust)"
        int PersonId FK "NULL, IX_Person"
        int CorporateId FK "NULL, IX_Corporate"
        int TrustId FK "NULL, IX_Trust"
        varchar(50) Status "NOT NULL, DEFAULT Active"
        int PrimaryAdviserUserId FK "NULL, IX_Adviser"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        bit IsDeleted "NOT NULL, DEFAULT 0"
        rowversion RowVersion "Concurrency Token"
    }

    TPerson {
        int PersonId PK "Identity, Clustered Index"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(10) Title "NULL, e.g. Mr, Mrs, Dr"
        varchar(100) FirstName "NOT NULL"
        varchar(100) MiddleNames "NULL"
        varchar(100) LastName "NOT NULL"
        date DateOfBirth "NOT NULL, IX_DOB"
        char(1) Gender "NULL, CHECK IN (M,F,O)"
        varchar(20) MaritalStatus "NULL"
        varchar(15) NationalInsuranceNumber "NULL, Encrypted"
        char(2) NationalityCountryCode "NULL, ISO 3166-1"
        char(2) ResidencyCountryCode "NULL, ISO 3166-1"
        char(2) DomicileCountryCode "NULL, ISO 3166-1"
        varchar(20) SmokingStatus "NULL"
        decimal(5_2) HeightCm "NULL"
        decimal(5_2) WeightKg "NULL"
        varchar(50) Occupation "NULL"
        int OccupationRefId FK "NULL"
        varchar(20) EmploymentStatus "NULL"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TCorporate {
        int CorporateId PK "Identity, Clustered Index"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(200) CompanyName "NOT NULL"
        varchar(200) TradingName "NULL"
        varchar(50) RegistrationNumber "NULL, UK: Companies House"
        date IncorporationDate "NULL"
        varchar(50) CompanyType "NULL"
        varchar(20) VATNumber "NULL"
        char(2) CountryOfIncorporation "NULL, ISO 3166-1"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TTrust {
        int TrustId PK "Identity, Clustered Index"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(200) TrustName "NOT NULL"
        varchar(50) TrustType "NULL, e.g. Discretionary, Life Interest"
        date SettlementDate "NULL"
        varchar(50) TrustRegistrationNumber "NULL, HMRC"
        varchar(20) TaxReference "NULL"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }
```

### 1.2 Address & Contact Entities

```mermaid
erDiagram
    TAddress ||--|| TAddressStore : "references shared"
    TCRMContact ||--o{ TAddress : "has multiple"

    TAddress {
        int AddressId PK "Identity, Clustered Index"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        int AddressStoreId FK "NOT NULL, IX_AddressStore"
        varchar(50) AddressType "NOT NULL, e.g. Home, Work, Correspondence"
        bit IsPrimary "NOT NULL, DEFAULT 0"
        date FromDate "NOT NULL"
        date ToDate "NULL, NULL = current"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TAddressStore {
        int AddressStoreId PK "Identity, Clustered Index"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(200) Line1 "NOT NULL"
        varchar(200) Line2 "NULL"
        varchar(200) Line3 "NULL"
        varchar(100) Town "NOT NULL"
        varchar(100) County "NULL, ISO 3166-2"
        varchar(20) Postcode "NULL, IX_Postcode"
        char(2) CountryCode "NOT NULL, ISO 3166-1, DEFAULT GB"
        decimal(10_7) Latitude "NULL, for geocoding"
        decimal(10_7) Longitude "NULL, for geocoding"
        varchar(100) UPRN "NULL, Unique Property Reference Number"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TContactDetail {
        int ContactDetailId PK "Identity, Clustered Index"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) ContactType "NOT NULL, e.g. Mobile, Landline, Email, WhatsApp"
        varchar(200) Value "NOT NULL, Encrypted for sensitive types"
        bit IsPrimary "NOT NULL, DEFAULT 0"
        bit IsDefault "NOT NULL, DEFAULT 0"
        varchar(20) VerificationStatus "NULL, e.g. Verified, Unverified"
        datetime VerifiedDate "NULL"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }
```

### 1.3 Client Compliance & Preferences Entities

```mermaid
erDiagram
    TCRMContact ||--o| TClientVulnerability : "has assessment"
    TCRMContact ||--o| TMarketing : "has preferences"
    TCRMContact ||--o{ TVerification : "has verification records"

    TClientVulnerability {
        int VulnerabilityId PK "Identity, Clustered Index"
        int CRMContactId FK "NOT NULL, IX_Contact, Unique"
        int TenantId FK "NOT NULL, IX_Tenant"
        date AssessmentDate "NOT NULL, IX_AssessmentDate"
        bit IsVulnerable "NOT NULL, DEFAULT 0"
        varchar(50) Category "NULL, e.g. Health, Financial, Life Event"
        nvarchar(MAX) Notes "NULL"
        date ReviewDate "NULL, for periodic reassessment"
        bit ClientPortalSuitable "NULL"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TMarketing {
        int MarketingId PK "Identity, Clustered Index"
        int CRMContactId FK "NOT NULL, IX_Contact, Unique"
        int TenantId FK "NOT NULL, IX_Tenant"
        bit ConsentEmail "NOT NULL, DEFAULT 0, GDPR"
        bit ConsentPhone "NOT NULL, DEFAULT 0, GDPR"
        bit ConsentSMS "NOT NULL, DEFAULT 0, GDPR"
        bit ConsentMail "NOT NULL, DEFAULT 0, GDPR"
        bit ConsentThirdParty "NOT NULL, DEFAULT 0, GDPR"
        datetime ConsentEmailDate "NULL"
        datetime ConsentPhoneDate "NULL"
        datetime ConsentSMSDate "NULL"
        datetime ConsentMailDate "NULL"
        datetime ConsentThirdPartyDate "NULL"
        varchar(50) AccessibleFormat "NULL, e.g. LargePrint, Braille, Audio"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TVerification {
        int VerificationId PK "Identity, Clustered Index"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) DocumentType "NOT NULL, e.g. Passport, DrivingLicence, Utility"
        varchar(100) DocumentNumber "NULL, Encrypted"
        date IssueDate "NULL"
        date ExpiryDate "NULL"
        char(2) CountryOfIssue "NULL, ISO 3166-1"
        varchar(50) VerificationStatus "NOT NULL, e.g. Pending, Verified, Failed"
        datetime VerifiedDate "NULL"
        int VerifiedByUserId FK "NULL"
        varchar(MAX) DocumentFileUrl "NULL, link to document storage"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }
```

---

## 2. FactFind Core Domain ERD

### 2.1 FactFind Session & Employment

```mermaid
erDiagram
    TFactFind ||--o{ TEmploymentDetail : "has employment records"
    TFactFind ||--o{ TDetailedIncomeBreakdown : "has income sources"
    TFactFind ||--o{ TAssets : "has assets"
    TFactFind ||--o{ TLiabilities : "has liabilities"
    TFactFind ||--o{ TBudgetMiscellaneous : "has budget"
    TFactFind ||--o{ TExpenditure : "has expenditure"

    TFactFind {
        int FactFindId PK "Identity, Clustered Index"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        datetime SessionDate "NOT NULL, IX_SessionDate"
        varchar(50) Status "NOT NULL, DEFAULT InProgress, CHECK"
        int AdviserUserId FK "NOT NULL, IX_Adviser"
        datetime CompletedDate "NULL"
        int CompletedByUserId FK "NULL"
        bit IsJoint "NOT NULL, DEFAULT 0"
        int JointCRMContactId FK "NULL, IX_JointContact"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TEmploymentDetail {
        int EmploymentDetailId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) EmploymentType "NOT NULL, CHECK IN (Employed,SelfEmployed,Unemployed,Retired)"
        varchar(200) EmployerName "NULL"
        varchar(100) JobTitle "NULL"
        int OccupationRefId FK "NULL, CRM.dbo.TRefOccupation"
        date StartDate "NULL"
        date EndDate "NULL, NULL = current"
        varchar(50) Status "NOT NULL, DEFAULT Active"
        decimal(18_2) AnnualSalary "NULL"
        char(3) SalaryCurrency "NULL, ISO 4217, DEFAULT GBP"
        varchar(20) PayFrequency "NULL, e.g. Monthly, Weekly"
        decimal(18_2) BonusAmount "NULL"
        decimal(18_2) BenefitsInKind "NULL"
        varchar(200) BusinessName "NULL, for self-employed"
        varchar(MAX) NatureOfBusiness "NULL"
        decimal(18_2) AnnualProfit "NULL, for self-employed"
        decimal(18_2) TaxableProfit "NULL"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }
```

### 2.2 Income & Budget Entities

```mermaid
erDiagram
    TFactFind ||--o{ TIncome : "has income"
    TFactFind ||--o{ TDetailedIncomeBreakdown : "has detailed income breakdown"
    TFactFind ||--o{ TBudgetMiscellaneous : "has budget"
    TFactFind ||--o{ TExpenditure : "has expenditure"

    TIncome {
        int IncomeId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) IncomeSource "NOT NULL, e.g. Employment, Rental, Investment, Pension"
        varchar(200) Description "NOT NULL"
        decimal(18_2) GrossAmount "NOT NULL, CHECK > 0"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        varchar(20) Frequency "NOT NULL, e.g. Monthly, Annual, Weekly"
        decimal(18_2) NetAmount "NULL, after tax"
        decimal(5_2) TaxRate "NULL, percentage"
        decimal(18_2) TaxPaid "NULL, actual tax amount"
        date StartDate "NULL"
        date EndDate "NULL, NULL = ongoing"
        bit IsGuaranteed "NOT NULL, DEFAULT 0, stable vs variable"
        int LinkedEmploymentId FK "NULL, link to TEmploymentDetail"
        int LinkedAssetId FK "NULL, link to TAssets"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TDetailedIncomeBreakdown {
        int IncomeId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) IncomeCategory "NOT NULL, e.g. Salary, Rental, Investment"
        varchar(200) Description "NOT NULL"
        decimal(18_2) Amount "NOT NULL, CHECK > 0"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        varchar(20) Frequency "NOT NULL, e.g. Monthly, Annual, Quarterly"
        date StartDate "NULL"
        date EndDate "NULL, NULL = ongoing"
        bit IsTaxable "NOT NULL, DEFAULT 1"
        decimal(5_2) TaxRate "NULL, percentage"
        int SourceEmploymentId FK "NULL, link to TEmploymentDetail"
        int SourceAssetId FK "NULL, link to TAssets"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TBudgetMiscellaneous {
        int BudgetId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        decimal(18_2) TotalMonthlyIncome "NOT NULL, DEFAULT 0"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        decimal(18_2) TotalMonthlyExpenditure "NOT NULL, DEFAULT 0"
        decimal(18_2) MonthlyDisposableIncome "COMPUTED (TotalIncome - TotalExpenditure)"
        decimal(18_2) AnnualDisposableIncome "COMPUTED (MonthlyDisposableIncome * 12)"
        datetime CalculatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TExpenditure {
        int ExpenditureId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        int ExpenditureTypeRefId FK "NOT NULL, e.g. Housing, Utilities, Food"
        varchar(200) Description "NOT NULL"
        decimal(18_2) Amount "NOT NULL, CHECK > 0"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        varchar(20) Frequency "NOT NULL, e.g. Monthly, Annual"
        bit IsPriority "NOT NULL, DEFAULT 0, essential vs discretionary"
        bit IsCommitted "NOT NULL, DEFAULT 0, contractual obligation"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }
```

### 2.3 Assets & Liabilities Entities

```mermaid
erDiagram
    TFactFind ||--o{ TAssets : "has assets"
    TFactFind ||--o{ TLiabilities : "has liabilities"
    TAssets ||--o| TDetailedIncomeBreakdown : "generates income"

    TAssets {
        int AssetId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) AssetCategory "NOT NULL, e.g. Property, Vehicle, Savings, Investment"
        varchar(200) Description "NOT NULL"
        decimal(18_2) CurrentValue "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        decimal(18_2) PurchaseValue "NULL"
        date PurchaseDate "NULL"
        date ValuationDate "NULL"
        varchar(50) PropertyType "NULL, if category = Property"
        varchar(MAX) PropertyAddress "NULL, JSON or delimited"
        varchar(50) Tenure "NULL, e.g. Freehold, Leasehold"
        decimal(18_2) OutstandingMortgage "NULL"
        bit GeneratesIncome "NOT NULL, DEFAULT 0"
        decimal(18_2) RentalIncome "NULL, if generates income"
        varchar(20) RentalFrequency "NULL"
        int LinkedIncomeId FK "NULL, TDetailedIncomeBreakdown"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TLiabilities {
        int LiabilityId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) LiabilityCategory "NOT NULL, e.g. Mortgage, Loan, CreditCard"
        varchar(200) Description "NOT NULL"
        varchar(200) CreditorName "NULL"
        decimal(18_2) OutstandingBalance "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        decimal(18_2) MonthlyPayment "NOT NULL"
        decimal(5_2) InterestRate "NULL, percentage"
        date StartDate "NULL"
        date EndDate "NULL, maturity/payoff date"
        int TermMonths "NULL, original term"
        int RemainingMonths "NULL, calculated"
        bit IsSecured "NOT NULL, DEFAULT 0"
        int SecuredAssetId FK "NULL, link to TAssets"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }
```

### 2.4 Notes Entity (Unified Pattern)

```mermaid
erDiagram
    TFactFind ||--o{ TNotes : "has notes"

    TNotes {
        bigint NoteId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) Discriminator "NOT NULL, IX_Discriminator, CHECK IN list"
        nvarchar(MAX) Content "NOT NULL, MAX 15000 chars"
        datetime CreatedDate "NOT NULL, IX_Created, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }
```

**Discriminator Values:**
- `Profile` - General client profile notes
- `Employment` - Employment-related notes
- `AssetLiabilities` - Assets and liabilities notes
- `Budget` - Budget and affordability notes
- `Mortgage` - Mortgage-specific notes
- `Protection` - Protection needs notes
- `Retirement` - Retirement planning notes
- `Investment` - Investment notes
- `EstatePlanning` - Estate planning notes
- `Summary` - FactFind summary notes

---

## 3. Portfolio Plans Domain ERD

### 3.1 Base Plan Entity (Polymorphic Root)

**Hierarchy:** TPolicyBusiness → TPolicyDetail → TPlanDescription → TRefPlanType2ProdSubType

```mermaid
erDiagram
    TPolicyBusiness ||--|| TPolicyDetail : "has details"
    TPolicyDetail ||--|| TPlanDescription : "product categorization"
    TPlanDescription }o--|| TRefPlanType2ProdSubType : "discriminator mapping"
    TPolicyDetail ||--o{ TPolicyOwner : "has 1+ owners"
    TPolicyOwner }o--|| TCRMContact : "owner"
    TPolicyBusiness ||--o| TPension : "PlanType = Pension"
    TPolicyBusiness ||--o| TProtection : "PlanType = Protection"
    TPolicyBusiness ||--o| TInvestment : "PlanType = Investment"
    TPolicyBusiness ||--o| TMortgage : "PlanType = Mortgage"
    TPolicyBusiness ||--o| TSavings : "PlanType = Savings"

    TPolicyBusiness {
        bigint PolicyBusinessId PK "Identity, Clustered Index"
        bigint PolicyDetailId FK "NOT NULL, IX_PolicyDetail"
        int PropositionTypeId FK "NOT NULL, IX_Proposition, links to CRM..PropositionType"
        int PractitionerId FK "NOT NULL, IX_Practitioner, selling adviser"
        int TnCCoachId FK "NULL, Compliance..TTnCCoach"
        int ServicingUserId FK "NULL, IX_ServicingUser"
        int ParaplannerUserId FK "NULL"
        int AdviceTypeId FK "NOT NULL, IX_AdviceType"
        int InvestmentTypeId FK "NULL"
        int LifeCycleId FK "NULL"
        int ClientTypeId FK "NULL, RefClientType"
        int TenantId FK "NOT NULL, IX_Tenant, IndigoClientId"
        varchar(100) PolicyNumber "NULL, IX_PolicyNumber"
        varchar(200) ProductName "NOT NULL"
        datetime PolicyStartDate "NOT NULL, IX_StartDate"
        datetime MaturityDate "NULL"
        datetime ExpectedPaymentDate "NULL"
        char(3) BaseCurrency "NOT NULL, ISO 4217, DEFAULT GBP"
        decimal(18_2) TotalLumpSum "NULL"
        decimal(18_2) TotalRegularPremium "NULL"
        varchar(100) AgencyNumber "NULL"
        nvarchar(MAX) ProviderAddress "NULL"
        bit OffPanelFg "NOT NULL, DEFAULT 0, off-panel indicator"
        bit BestAdvicePanelUsedFG "NULL"
        bit SwitchFG "NULL, is switch transaction"
        varchar(50) SequentialRef "NULL, IX_SequentialRef"
        bit IsGuaranteedToProtectOriginalInvestment "NULL"
        decimal(18_2) LowMaturityValue "NULL"
        decimal(18_2) MediumMaturityValue "NULL"
        decimal(18_2) HighMaturityValue "NULL"
        nvarchar(MAX) ProjectionDetails "NULL"
        bigint ConcurrencyId "Concurrency Token"
    }

    TPolicyDetail {
        bigint PolicyDetailId PK "Identity, Clustered Index"
        bigint PlanDescriptionId FK "NOT NULL, IX_PlanDescription"
        int TenantId FK "NOT NULL, IX_Tenant"
        int TermYears "NULL"
        bit WholeOfLifeFg "NULL"
        bit LetterOfAuthorityFg "NULL"
        bit ContractOutOfSERPSFg "NULL"
        datetime ContractOutStartDate "NULL"
        datetime ContractOutStopDate "NULL"
        datetime JoiningDate "NULL"
        datetime LeavingDate "NULL"
        decimal(18_2) GrossAnnualIncome "NULL"
        int RefAnnuityPaymentTypeId FK "NULL"
        decimal(18_2) CapitalElement "NULL"
        decimal(5_2) AssumedGrowthRatePercentage "NULL"
        bigint ConcurrencyId "Concurrency Token"
    }

    TPlanDescription {
        bigint PlanDescriptionId PK "Identity, Clustered Index"
        int RefPlanType2ProdSubTypeId FK "NOT NULL, IX_PlanType2ProdSubType"
        int RefProdProviderId FK "NOT NULL, IX_Provider"
        int SchemeOwnerCRMContactId FK "NULL, CRM..TCRMContact"
        int SchemeSellingAdvisorPractitionerId FK "NULL"
        varchar(50) SchemeStatus "NULL"
        varchar(100) SchemeNumber "NULL"
        varchar(200) SchemeName "NULL"
        datetime SchemeStatusDate "NULL"
        datetime MaturityDate "NULL"
        bigint ConcurrencyId "Concurrency Token"
    }

    TPolicyOwner {
        bigint PolicyOwnerId PK "Identity, Clustered Index"
        bigint PolicyDetailId FK "NOT NULL, IX_PolicyDetail"
        int CRMContactId FK "NOT NULL, IX_CRMContact, links to CRM..TCRMContact"
        int OwnerOrder "NULL, 1 or 2"
        bigint ConcurrencyId "Concurrency Token"
    }

    TRefPlanType2ProdSubType {
        int RefPlanType2ProdSubTypeId PK "Identity"
        int RefPlanTypeId FK "NOT NULL, links to TRefPlanType"
        int ProdSubTypeId FK "NOT NULL, links to TProdSubType"
        int RefPlanDiscriminatorId FK "NULL, high-level grouping"
        int TenantId FK "NOT NULL, Multi-tenant reference data"
        varchar(100) PlanTypeName "NOT NULL, e.g. Life Assurance"
        varchar(100) ProductSubTypeName "NOT NULL, e.g. Term, Whole of Life"
        int DisplayOrder "NULL, for UI sorting"
        bit IsActive "NOT NULL, DEFAULT 1"
        datetime CreatedDate "NOT NULL"
    }
```

### 3.2 Pension Plan Extensions

```mermaid
erDiagram
    TPolicyBusiness ||--o| TPension : "extension"

    TPension {
        bigint PensionId PK "Identity"
        bigint PolicyBusinessId FK "NOT NULL, Unique, IX_Policy"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) PensionType "NOT NULL, e.g. SIPP, PersonalPension, FinalSalary"
        int RetirementAge "NULL, target retirement age"
        decimal(18_2) ProjectedValue "NULL, at retirement"
        char(3) ProjectedCurrency "NULL, ISO 4217"
        date ProjectionDate "NULL, when projection made"
        decimal(18_2) EmployerContribution "NULL"
        varchar(20) EmployerContributionFrequency "NULL"
        decimal(5_2) EmployerContributionPercent "NULL"
        decimal(18_2) TaxReliefAmount "NULL, annual"
        date CrystallisationDate "NULL, when benefits taken"
        bit DrawdownStarted "NOT NULL, DEFAULT 0"
        decimal(18_2) AnnualDrawdown "NULL"
        decimal(18_2) GuaranteedPension "NULL, for DB schemes"
        decimal(18_2) LumpSumEntitlement "NULL, tax-free cash"
        decimal(5_2) AccrualRate "NULL, for DB schemes, e.g. 1/60"
        int PensionableService "NULL, years for DB"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }
```

### 3.3 Protection Plan Extensions

**Note:** Protection uses Class Table Inheritance with `RefPlanSubCategoryId` as discriminator (51=PersonalProtection, 47=GeneralInsurance, 55=PaymentProtection).

**Key Relationship:** TProtection → TAssuredLife (0-2 lives) → TBenefit (main + additional per life)

```mermaid
erDiagram
    TPolicyBusiness ||--o| TProtection : "extension"
    TProtection ||--o| PersonalProtection : "discriminator=51"
    TProtection ||--o| GeneralInsurance : "discriminator=47"
    TProtection ||--o{ TAssuredLife : "0 to 2 assured lives"
    TAssuredLife }o--|| TCRMContact : "insured person"
    TAssuredLife }o--o| TBenefit : "main benefit"
    TAssuredLife }o--o| TBenefit : "additional benefit"

    TProtection {
        bigint ProtectionId PK "Identity, Clustered Index"
        bigint PolicyBusinessId FK "NOT NULL, Unique, IX_Policy"
        int TenantId FK "NOT NULL, IX_Tenant"
        int RefPlanSubCategoryId FK "NOT NULL, DISCRIMINATOR, IX_SubCategory"
        bit InTrust "NOT NULL, DEFAULT 0"
        varchar(200) ToWhom "NULL, beneficiary details"
        decimal(18_2) LifeCoverSumAssured "NULL"
        bigint ConcurrencyId "Concurrency Token"
    }

    PersonalProtection {
        bigint ProtectionId PK_FK "Extends TProtection, discriminator=51"
        int TermValue "NULL, term in years"
        varchar(25) LifeCoverPremiumStructure "NULL"
        int LifeCoverUntilAge "NULL"
        int PtdCoverTerm "NULL, Permanent Total Disability"
        varchar(25) PtdCoverPremiumStructure "NULL"
        int PtdCoverUntilAge "NULL"
        decimal(18_2) PtdCoverAmount "NULL"
        int SeverityCoverTerm "NULL"
        varchar(25) SeverityCoverPremiumStructure "NULL"
        int SeverityCoverUntilAge "NULL"
        decimal(18_2) SeverityCoverAmount "NULL"
        int CriticalIllnessTermValue "NULL"
        float PercentOfPremiumToInvest "NULL, Whole of Life"
        decimal(18_2) LifeCoverSumAssured "NULL"
        decimal(18_2) CriticalIllnessSumAssured "NULL"
        datetime ReviewDate "NULL"
        varchar(5000) BenefitSummary "NULL"
        varchar(2500) Exclusions "NULL"
        varchar(25) ProtectionPayoutType "NULL"
        varchar(25) IncomePremiumStructure "NULL"
        varchar(25) CriticalIllnessPremiumStructure "NULL"
        varchar(25) ExpensePremiumStructure "NULL"
        varchar(50) PremiumLoading "NULL"
        int CriticalIllnessUntilAge "NULL"
        int WaitingPeriod "NULL, deferred period"
        int IncomeCoverTerm "NULL"
        int IncomeCoverUntilAge "NULL"
        int ExpenseCoverTerm "NULL"
        int ExpenseCoverUntilAge "NULL"
        int TermTypeId FK "NULL, RefTermType"
        int IndexTypeId FK "NULL, RefIndexType"
        int PaymentBasisId FK "NULL, RefPaymentBasis"
    }

    GeneralInsurance {
        bigint ProtectionId PK_FK "Extends TProtection, discriminator=47"
        varchar(50) PremiumLoading "NULL"
        varchar(2500) Exclusions "NULL"
        int WaitingPeriod "NULL"
        datetime RenewalDate "NULL"
        int TermValue "NULL, term in years"
    }

    TAssuredLife {
        bigint AssuredLifeId PK "Identity, Clustered Index"
        bigint ProtectionId FK "NOT NULL, IX_Protection"
        int PartyId FK "NOT NULL, IX_Party, links to CRM..TCRMContact"
        bigint BenefitId FK "NULL, IX_Benefit, main benefit"
        bigint AdditionalBenefitId FK "NULL, IX_AdditionalBenefit"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) Title "NULL"
        varchar(100) FirstName "NULL"
        varchar(100) LastName "NULL"
        datetime DOB "NULL, Date of Birth"
        varchar(10) GenderType "NULL"
        int OrderKey "NULL, 1 or 2 for life assured ordering"
        bigint ConcurrencyId "Concurrency Token"
    }

    TBenefit {
        bigint BenefitId PK "Identity, Clustered Index"
        bigint PolicyBusinessId FK "NOT NULL, IX_Policy"
        int TenantId FK "NOT NULL, IX_Tenant"
        decimal(18_2) BenefitAmount "NULL"
        decimal(18_2) SplitBenefitAmount "NULL"
        bit PremiumWaiverWoc "NULL, Waiver on Critical Illness"
        int BenefitDeferredPeriod "NULL"
        int SplitBenefitDeferredPeriod "NULL"
        int DeferredPeriodIntervalId FK "NULL, RefPeriodType"
        int SplitDeferredPeriodIntervalId FK "NULL, RefPeriodType"
        bit IsRated "NULL, rated due to health"
        varchar(500) BenefitOptions "NULL"
        int RefTotalPermanentDisabilityTypeId FK "NULL"
        int RefFrequencyId FK "NULL"
        int RefSplitFrequencyId FK "NULL"
        int RefBenefitPeriodId FK "NULL"
        int RefQualificationPeriodId FK "NULL"
        int RefPeriodTypeId FK "NULL"
        decimal(18_2) PensionCommencementLumpSum "NULL"
        bit IsSpousesBenefit "NULL"
        decimal(5_2) SpousesOrDependentsPercentage "NULL"
        int GuaranteedPeriod "NULL"
        bit IsProportion "NULL"
        bigint PCLSPaidById "NULL"
        bit IsCapitalValueProtected "NULL"
        decimal(18_2) CapitalValueProtectedAmount "NULL"
        decimal(18_2) GADMaximumIncomeLimit "NULL"
        datetime GADCalculationDate "NULL"
        decimal(18_2) GuaranteedMinimumIncome "NULL"
        decimal(18_2) LumpSumDeathBenefitAmount "NULL"
        bit IsOverlap "NULL"
        varchar(500) OtherBenefitPeriodText "NULL"
        bit IsPre75 "NULL"
        bit IsInheritedPension "NULL"
        int DeathAgeOfTransferor "NULL"
        bit IsProtectedPCLS "NULL"
        bigint ConcurrencyId "Concurrency Token"
    }
```

**Key Points:**

1. **Class Table Inheritance**: TProtection is abstract base, PersonalProtection and GeneralInsurance are subclasses
2. **Discriminator**: RefPlanSubCategoryId (51=PersonalProtection, 47=GeneralInsurance, 55=PaymentProtection)
3. **Assured Lives**: Protection policies can have 0, 1, or 2 assured lives
4. **Benefits per Life**: Each assured life can have 2 benefits (main + additional)
5. **Maximum Benefits**: A policy can have up to 4 benefits total (2 lives × 2 benefits each)
6. **SQL Pattern**: Queries use MIN/MAX aggregation to identify AssuredLife1 and AssuredLife2

### 3.4 Investment & Mortgage Plan Extensions

```mermaid
erDiagram
    TPolicyBusiness ||--o| TInvestment : "extension"
    TPolicyBusiness ||--o| TMortgage : "extension"
    TInvestment ||--o{ TInvestmentHolding : "holdings"

    TInvestment {
        bigint InvestmentId PK "Identity"
        bigint PolicyBusinessId FK "NOT NULL, Unique, IX_Policy"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) InvestmentType "NOT NULL, e.g. ISA, GIA, Bond, OEIC, UnitTrust"
        varchar(50) ISAType "NULL, e.g. StocksAndShares, Cash, Lifetime"
        decimal(18_2) CurrentYearContribution "NULL, for ISA"
        decimal(18_2) ISAAllowanceRemaining "NULL"
        int TaxYearEnd "NULL, e.g. 2024 for 2023/24"
        decimal(5_2) AnnualReturnPercent "NULL, historical"
        varchar(50) RiskRating "NULL, e.g. Low, Medium, High"
        bit AutoRebalance "NOT NULL, DEFAULT 0"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TInvestmentHolding {
        bigint HoldingId PK "Identity"
        bigint InvestmentId FK "NOT NULL, IX_Investment"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) AssetClass "NOT NULL, e.g. Equity, Bond, Property, Cash"
        varchar(200) FundName "NOT NULL"
        varchar(20) ISIN "NULL, International Securities ID"
        varchar(20) SEDOL "NULL, Stock Exchange Daily Official List"
        decimal(18_10) Units "NULL"
        decimal(18_4) UnitPrice "NULL"
        decimal(18_2) Value "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217"
        decimal(5_2) AllocationPercent "NULL, % of portfolio"
        date ValuationDate "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
    }

    TMortgage {
        bigint MortgageId PK "Identity"
        bigint PolicyBusinessId FK "NOT NULL, Unique, IX_Policy"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) MortgageType "NOT NULL, e.g. Residential, BTL, Remortgage"
        nvarchar(MAX) PropertyAddress "NOT NULL, JSON"
        decimal(18_2) PropertyValue "NULL"
        decimal(18_2) LoanAmount "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        decimal(18_2) OutstandingBalance "NOT NULL"
        decimal(5_2) InterestRate "NOT NULL"
        varchar(50) RateType "NOT NULL, e.g. Fixed, Variable, Tracker"
        date FixedRateEndDate "NULL"
        decimal(18_2) MonthlyPayment "NOT NULL"
        int TermMonths "NOT NULL"
        int RemainingMonths "NULL, calculated"
        bit IsInterestOnly "NOT NULL, DEFAULT 0"
        decimal(5_2) LTV "COMPUTED (OutstandingBalance / PropertyValue * 100)"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }
```

---

## 4. Goals & Requirements Domain ERD

### 4.1 Goal/Objective Entities

```mermaid
erDiagram
    TRequirement ||--o{ TRequirementAllocation : "allocated to plans"
    TRequirement ||--o| TRiskProfile : "has risk profile"
    TRequirement }o--|| TRefRequirementType : "discriminator"

    TRequirement {
        uniqueidentifier RequirementId PK "NEWSEQUENTIALID(), Clustered"
        uniqueidentifier ClientId FK "NOT NULL, IX_Client, GUID for microservice"
        int TenantId FK "NOT NULL, IX_Tenant"
        int RefRequirementTypeId FK "NOT NULL, IX_Type, Discriminator"
        varchar(200) Description "NOT NULL"
        int Priority "NULL, 1=High, 5=Low"
        decimal(18_2) TargetAmount "NULL"
        char(3) Currency "NULL, ISO 4217, DEFAULT GBP"
        date TargetDate "NULL, IX_TargetDate"
        varchar(50) Status "NOT NULL, DEFAULT Active, IX_Status"
        int TimeHorizonYears "NULL, calculated from target date"
        decimal(18_2) CurrentAllocatedAmount "NULL, sum of allocations"
        decimal(18_2) ShortfallAmount "COMPUTED (TargetAmount - CurrentAllocatedAmount)"
        nvarchar(MAX) Notes "NULL"
        uniqueidentifier RiskProfileId FK "NULL, for investment goals"
        datetime CreatedAt "NOT NULL, DEFAULT SYSUTCDATETIME()"
        uniqueidentifier CreatedByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
        uniqueidentifier UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TRefRequirementType {
        int RefRequirementTypeId PK "Identity"
        varchar(50) TypeName "NOT NULL, Unique, e.g. Investment, Retirement"
        varchar(50) Discriminator "NOT NULL, for polymorphism"
        varchar(500) Description "NULL"
        bit IsActive "NOT NULL, DEFAULT 1"
        int DisplayOrder "NULL"
        datetime CreatedAt "NOT NULL"
    }

    TRequirementAllocation {
        uniqueidentifier AllocationId PK "NEWSEQUENTIALID()"
        uniqueidentifier RequirementId FK "NOT NULL, IX_Requirement"
        bigint PolicyBusinessId FK "NOT NULL, IX_Policy, links to Portfolio"
        int TenantId FK "NOT NULL, IX_Tenant"
        decimal(18_2) AllocationAmount "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217"
        decimal(5_2) AllocationPercentage "NULL, % of goal"
        date AllocationDate "NOT NULL, DEFAULT GETUTCDATE()"
        varchar(50) Status "NOT NULL, DEFAULT Active"
        datetime CreatedAt "NOT NULL, DEFAULT SYSUTCDATETIME()"
        uniqueidentifier CreatedByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
        uniqueidentifier UpdatedByUserId FK "NULL"
    }
```

### 4.2 Risk Profile & Dependants

```mermaid
erDiagram
    TRequirement ||--o| TRiskProfile : "has risk profile"
    TRequirement ||--o{ TDependant : "has dependants"

    TRiskProfile {
        uniqueidentifier RiskProfileId PK "NEWSEQUENTIALID(), Clustered"
        uniqueidentifier RequirementId FK "NULL, IX_Requirement, can be standalone"
        uniqueidentifier ClientId FK "NOT NULL, IX_Client"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) RiskTitle "NOT NULL, e.g. Cautious, Balanced, Adventurous"
        int RiskScore "NOT NULL, CHECK 1-10"
        varchar(50) RiskAttitude "NULL, e.g. Low, Medium, High"
        varchar(50) RiskCapacity "NULL, ability to take risk"
        varchar(50) RiskNeed "NULL, need to take risk"
        uniqueidentifier ATRTemplateId FK "NULL, link to ATR questionnaire"
        nvarchar(MAX) QuestionnaireResponses "NULL, JSON of Q&A"
        date AssessmentDate "NOT NULL, IX_AssessmentDate"
        date ReviewDate "NULL, periodic review"
        datetime CreatedAt "NOT NULL, DEFAULT SYSUTCDATETIME()"
        uniqueidentifier CreatedByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
        uniqueidentifier UpdatedByUserId FK "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TDependant {
        uniqueidentifier DependantId PK "NEWSEQUENTIALID()"
        uniqueidentifier RequirementId FK "NULL, IX_Requirement, for protection goals"
        uniqueidentifier ClientId FK "NOT NULL, IX_Client"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(100) Name "NOT NULL"
        varchar(50) Relationship "NOT NULL, e.g. Child, Spouse, Parent"
        date DateOfBirth "NULL"
        bit IsFinanciallyDependent "NOT NULL, DEFAULT 1"
        decimal(18_2) AnnualCost "NULL, estimated support cost"
        char(3) Currency "NULL, ISO 4217"
        date DependencyEndDate "NULL, when dependency ends"
        datetime CreatedAt "NOT NULL, DEFAULT SYSUTCDATETIME()"
        uniqueidentifier CreatedByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
        uniqueidentifier UpdatedByUserId FK "NULL"
    }
```

### 4.3 Needs & Priorities (Custom Questions)

```mermaid
erDiagram
    TNeedsAndPrioritiesQuestion ||--o{ TNeedsAndPrioritiesAnswer : "has answers"

    TNeedsAndPrioritiesQuestion {
        uniqueidentifier QuestionId PK "NEWSEQUENTIALID(), Clustered"
        int TenantId FK "NOT NULL, IX_Tenant, firm-level questions"
        varchar(500) QuestionText "NOT NULL"
        varchar(50) QuestionType "NOT NULL, e.g. Text, MultiChoice, YesNo"
        nvarchar(MAX) OptionsList "NULL, JSON for multi-choice"
        int DisplayOrder "NOT NULL, for ordering"
        bit IsRequired "NOT NULL, DEFAULT 0"
        bit IsActive "NOT NULL, DEFAULT 1, IX_Active"
        varchar(50) Category "NULL, e.g. Goals, Preferences, Concerns"
        datetime CreatedAt "NOT NULL, DEFAULT SYSUTCDATETIME()"
        uniqueidentifier CreatedByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
        uniqueidentifier UpdatedByUserId FK "NULL"
    }

    TNeedsAndPrioritiesAnswer {
        uniqueidentifier AnswerId PK "NEWSEQUENTIALID()"
        uniqueidentifier QuestionId FK "NOT NULL, IX_Question"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        nvarchar(MAX) AnswerText "NOT NULL"
        datetime AnsweredAt "NOT NULL, IX_AnsweredAt, DEFAULT SYSUTCDATETIME()"
        uniqueidentifier AnsweredByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
        uniqueidentifier UpdatedByUserId FK "NULL"
    }
```

---

## 5. ATR Domain ERD

### 5.1 ATR Assessment Entities

```mermaid
erDiagram
    TAtr ||--o{ TAtrQuestionnaireResponse : "has responses"
    TAtr }o--|| TAtrTemplate : "uses template"
    TAtrTemplate ||--o{ TAtrQuestion : "has questions"

    TAtr {
        uniqueidentifier AtrId PK "NEWSEQUENTIALID(), Clustered"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        uniqueidentifier ATRTemplateId FK "NOT NULL, IX_Template"
        int RiskScore "NOT NULL, CHECK 1-10, IX_RiskScore"
        varchar(50) RiskCategory "NOT NULL, e.g. Cautious, Balanced, Adventurous"
        nvarchar(MAX) QuestionnaireResponsesJson "NULL, full Q&A in JSON"
        date AssessmentDate "NOT NULL, IX_AssessmentDate"
        date ExpiryDate "NULL, e.g. 12 months validity"
        varchar(50) Status "NOT NULL, DEFAULT Active"
        uniqueidentifier AssessedByUserId FK "NOT NULL"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedAt "NOT NULL, DEFAULT SYSUTCDATETIME()"
        datetime UpdatedAt "NULL"
        rowversion RowVersion "Concurrency Token"
    }

    TAtrTemplate {
        uniqueidentifier ATRTemplateId PK "NEWSEQUENTIALID()"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(200) TemplateName "NOT NULL"
        varchar(50) TemplateVersion "NOT NULL, e.g. v2.0"
        nvarchar(MAX) Description "NULL"
        bit IsActive "NOT NULL, DEFAULT 1, IX_Active"
        int TotalQuestions "NULL, calculated"
        nvarchar(MAX) ScoringRulesJson "NULL, JSON scoring algorithm"
        datetime CreatedAt "NOT NULL"
        uniqueidentifier CreatedByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
    }

    TAtrQuestion {
        uniqueidentifier QuestionId PK "NEWSEQUENTIALID()"
        uniqueidentifier ATRTemplateId FK "NOT NULL, IX_Template"
        int QuestionNumber "NOT NULL, for ordering"
        nvarchar(MAX) QuestionText "NOT NULL"
        varchar(50) QuestionType "NOT NULL, e.g. MultiChoice, Scale"
        nvarchar(MAX) OptionsJson "NULL, JSON array of options with scores"
        int MaxScore "NULL"
        bit IsRequired "NOT NULL, DEFAULT 1"
        datetime CreatedAt "NOT NULL"
    }

    TAtrQuestionnaireResponse {
        uniqueidentifier ResponseId PK "NEWSEQUENTIALID()"
        uniqueidentifier AtrId FK "NOT NULL, IX_Atr"
        uniqueidentifier QuestionId FK "NOT NULL, IX_Question"
        int TenantId FK "NOT NULL, IX_Tenant"
        nvarchar(MAX) AnswerText "NOT NULL"
        int Score "NULL, points for this answer"
        datetime AnsweredAt "NOT NULL, DEFAULT SYSUTCDATETIME()"
    }
```

---

## 6. Cross-Domain Integration ERD

### 6.1 Integration Relationships

```mermaid
erDiagram
    %% Cross-Schema Foreign Key Relationships

    TFactFind }o--|| TCRMContact : "CRMContactId (Conformist)"
    TPolicyBusiness }o--|| TCRMContact : "CRMContactId (Conformist)"
    TRequirement }o--|| ClientId : "ClientId (GUID mapping)"
    TAtr }o--|| TCRMContact : "CRMContactId (Conformist)"

    TRequirementAllocation }o--|| TPolicyBusiness : "PolicyBusinessId (Customer-Supplier)"

    TDetailedIncomeBreakdown }o--|| TEmploymentDetail : "SourceEmploymentId (FK)"
    TDetailedIncomeBreakdown }o--|| TAssets : "SourceAssetId (FK)"

    TLiabilities }o--|| TAssets : "SecuredAssetId (secured liabilities)"

    TRiskProfile }o--|| TRequirement : "RequirementId (FK)"
    TRiskProfile }o--|| TAtr : "ATRTemplateId (FK)"

    TCRMContact {
        int CRMContactId PK
        varchar Status
    }

    ClientId {
        uniqueidentifier ClientId PK "Microservice GUID"
        int CRMContactId FK "Sync mapping"
    }

    TFactFind {
        int FactFindId PK
        int CRMContactId FK
    }

    TPolicyBusiness {
        bigint PolicyBusinessId PK
        int CRMContactId FK
    }

    TRequirement {
        uniqueidentifier RequirementId PK
        uniqueidentifier ClientId FK
    }

    TAtr {
        uniqueidentifier AtrId PK
        int CRMContactId FK
    }

    TRequirementAllocation {
        uniqueidentifier AllocationId PK
        uniqueidentifier RequirementId FK
        bigint PolicyBusinessId FK
    }

    TDetailedIncomeBreakdown {
        int IncomeId PK
        int SourceEmploymentId FK
        int SourceAssetId FK
    }

    TEmploymentDetail {
        int EmploymentDetailId PK
    }

    TAssets {
        int AssetId PK
    }

    TLiabilities {
        int LiabilityId PK
        int SecuredAssetId FK
    }

    TRiskProfile {
        uniqueidentifier RiskProfileId PK
        uniqueidentifier RequirementId FK
        uniqueidentifier ATRTemplateId FK
    }
```

---

## 7. Database Design Decisions

### 7.1 Primary Key Strategy

| Domain | PK Type | Rationale |
|--------|---------|-----------|
| **CRM** | `int IDENTITY` | Legacy system, billions of records not expected, simple joins |
| **FactFind** | `int IDENTITY` | Transactional, high-volume, performance-critical |
| **Portfolio** | `bigint IDENTITY` | Very high volume (1000s plans per client over lifetime) |
| **Requirements** | `uniqueidentifier` (GUID) | Microservice, distributed system, merge capability |
| **ATR** | `uniqueidentifier` (GUID) | Microservice, independent scaling |

### 7.2 Discriminator Pattern Implementation

**Two approaches used:**

#### Type 1: Table-per-Hierarchy (TPH) - Portfolio
```sql
-- Single table with discriminator
CREATE TABLE TPolicyBusiness (
    PolicyBusinessId BIGINT IDENTITY PRIMARY KEY,
    RefPlanType2ProdSubTypeId INT NOT NULL, -- Discriminator FK
    -- Common fields for all plan types
    ...
);

-- Separate extension tables for type-specific fields
CREATE TABLE TPension (
    PensionId BIGINT IDENTITY PRIMARY KEY,
    PolicyBusinessId BIGINT NOT NULL UNIQUE REFERENCES TPolicyBusiness,
    -- Pension-specific fields
    ...
);
```

**Benefits:**
- Single point for common plan operations
- Efficient queries for all plans
- Type-specific extensions isolated

#### Type 2: Discriminator Column - Requirements
```sql
CREATE TABLE TRequirement (
    RequirementId UNIQUEIDENTIFIER PRIMARY KEY,
    RefRequirementTypeId INT NOT NULL, -- Discriminator FK
    -- Polymorphic fields (JSON or nullable columns)
    ...
);
```

**Benefits:**
- Simpler schema
- Single table queries
- Flexible type additions

### 7.3 Multi-Tenancy Strategy

**Row-Level Security Approach:**

```sql
-- Every table includes TenantId
TenantId INT NOT NULL

-- Filtered indexes for tenant isolation
CREATE NONCLUSTERED INDEX IX_Tenant_Active
ON TFactFind(TenantId, Status)
WHERE Status = 'Active';

-- Views with tenant filtering
CREATE VIEW vw_ActiveClients AS
SELECT * FROM TCRMContact
WHERE TenantId = SESSION_CONTEXT('TenantId')
AND IsDeleted = 0;
```

### 7.4 Soft Delete Pattern

**All entities use soft delete:**

```sql
bit IsDeleted NOT NULL DEFAULT 0

-- Filtered indexes exclude deleted
CREATE NONCLUSTERED INDEX IX_Contact_Active
ON TCRMContact(CRMContactId)
WHERE IsDeleted = 0;
```

### 7.5 Audit Trail Pattern

**All entities include audit fields:**

```sql
datetime CreatedDate NOT NULL DEFAULT GETUTCDATE(),
int CreatedByUserId FK NOT NULL,
datetime UpdatedDate NULL,
int UpdatedByUserId FK NULL,
rowversion RowVersion -- Optimistic concurrency
```

### 7.6 Currency Handling

**ISO 4217 standard:**

```sql
decimal(18,2) Amount NOT NULL,
char(3) Currency NOT NULL DEFAULT 'GBP', -- ISO 4217
CHECK (Currency IN ('GBP','EUR','USD',...))
```

### 7.7 Money Data Type

**Precision:**
- `decimal(18,2)` - Standard for money (max: 999,999,999,999,999.99)
- `decimal(5,2)` - Percentages (max: 999.99%)
- `decimal(10,7)` - Lat/Long coordinates

---

## 8. Indexing Strategy

### 8.1 Standard Index Pattern

**Every table minimum:**

```sql
-- Clustered index on PK
CREATE CLUSTERED INDEX PK_TableName ON TableName(PrimaryKeyId);

-- Tenant isolation
CREATE NONCLUSTERED INDEX IX_Tenant ON TableName(TenantId);

-- Foreign key indexes
CREATE NONCLUSTERED INDEX IX_ForeignKey ON TableName(ForeignKeyId);

-- Commonly filtered columns
CREATE NONCLUSTERED INDEX IX_Status ON TableName(Status) WHERE IsDeleted = 0;
```

### 8.2 Covering Indexes for Common Queries

**Example: Client lookup by postcode**

```sql
CREATE NONCLUSTERED INDEX IX_Address_Postcode_Covering
ON TAddress(Postcode)
INCLUDE (CRMContactId, AddressType, IsPrimary)
WHERE IsDeleted = 0;
```

### 8.3 Filtered Indexes for Active Records

```sql
-- Only index active, non-deleted records
CREATE NONCLUSTERED INDEX IX_ActivePolicies
ON TPolicyBusiness(CRMContactId, Status, StartDate)
WHERE Status = 'Active' AND IsDeleted = 0;
```

### 8.4 Temporal Indexes

**For date range queries:**

```sql
CREATE NONCLUSTERED INDEX IX_FactFind_DateRange
ON TFactFind(SessionDate, Status)
INCLUDE (CRMContactId, AdviserUserId);
```

---

## 9. Constraints & Validation

### 9.1 Check Constraints

```sql
-- Status enumeration
ALTER TABLE TFactFind
ADD CONSTRAINT CK_FactFind_Status
CHECK (Status IN ('InProgress','Completed','Archived'));

-- Positive amounts
ALTER TABLE TDetailedIncomeBreakdown
ADD CONSTRAINT CK_Income_PositiveAmount
CHECK (Amount > 0);

-- Date logic
ALTER TABLE TEmploymentDetail
ADD CONSTRAINT CK_Employment_DateLogic
CHECK (EndDate IS NULL OR EndDate >= StartDate);

-- Risk score range
ALTER TABLE TAtr
ADD CONSTRAINT CK_Atr_RiskScore
CHECK (RiskScore BETWEEN 1 AND 10);
```

### 9.2 Unique Constraints

```sql
-- One vulnerability assessment per client
ALTER TABLE TClientVulnerability
ADD CONSTRAINT UQ_Vulnerability_PerClient
UNIQUE (CRMContactId, TenantId);

-- Unique policy numbers per tenant
ALTER TABLE TPolicyBusiness
ADD CONSTRAINT UQ_PolicyNumber_PerTenant
UNIQUE (TenantId, ProviderRefId, PolicyNumber);
```

### 9.3 Foreign Key Constraints

**With cascade rules:**

```sql
-- Cascade delete dependants when requirement deleted
ALTER TABLE TDependant
ADD CONSTRAINT FK_Dependant_Requirement
FOREIGN KEY (RequirementId) REFERENCES TRequirement(RequirementId)
ON DELETE CASCADE;

-- Prevent deletion if allocations exist
ALTER TABLE TRequirementAllocation
ADD CONSTRAINT FK_Allocation_Requirement
FOREIGN KEY (RequirementId) REFERENCES TRequirement(RequirementId)
ON DELETE NO ACTION;
```

---

## 10. Performance Considerations

### 10.1 Partitioning Strategy

**Large tables candidates:**

```sql
-- Partition TFactFind by year
CREATE PARTITION FUNCTION PF_FactFindYear (datetime)
AS RANGE RIGHT FOR VALUES
    ('2020-01-01', '2021-01-01', '2022-01-01', ...);

CREATE PARTITION SCHEME PS_FactFindYear
AS PARTITION PF_FactFindYear
ALL TO ([PRIMARY]);

-- Apply to table
CREATE TABLE TFactFind (
    ...
    SessionDate datetime NOT NULL
) ON PS_FactFindYear(SessionDate);
```

### 10.2 Computed Columns

```sql
-- Persisted computed columns with index
ALTER TABLE TBudgetMiscellaneous
ADD MonthlyDisposableIncome AS (TotalMonthlyIncome - TotalMonthlyExpenditure) PERSISTED;

CREATE INDEX IX_DisposableIncome
ON TBudgetMiscellaneous(MonthlyDisposableIncome);

-- LTV calculation
ALTER TABLE TMortgage
ADD LTV AS (OutstandingBalance / NULLIF(PropertyValue, 0) * 100) PERSISTED;
```

### 10.3 Columnstore Indexes for Reporting

```sql
-- Read-only reporting replica
CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_FactFind_Reporting
ON TFactFind (SessionDate, Status, CRMContactId, TenantId);
```

---

## 11. Security Considerations

### 11.1 Encryption

**Sensitive fields encrypted:**

```sql
-- Always Encrypted for PII
NationalInsuranceNumber varchar(15) ENCRYPTED WITH (...),
DocumentNumber varchar(100) ENCRYPTED WITH (...),

-- TDE at database level
ALTER DATABASE FactFindDB SET ENCRYPTION ON;
```

### 11.2 Row-Level Security (RLS)

```sql
-- Security policy for multi-tenancy
CREATE FUNCTION dbo.fn_TenantAccessPredicate(@TenantId int)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS AccessResult
WHERE @TenantId = CAST(SESSION_CONTEXT(N'TenantId') AS int);

CREATE SECURITY POLICY TenantSecurityPolicy
ADD FILTER PREDICATE dbo.fn_TenantAccessPredicate(TenantId) ON dbo.TFactFind,
ADD BLOCK PREDICATE dbo.fn_TenantAccessPredicate(TenantId) ON dbo.TFactFind;
```

### 11.3 Dynamic Data Masking

```sql
-- Mask NI numbers from non-privileged users
ALTER TABLE TPerson
ALTER COLUMN NationalInsuranceNumber
ADD MASKED WITH (FUNCTION = 'partial(2,"XXXXX",0)');
-- Shows: AB-XX-XX-XX-CD
```

---

## 12. Change Data Capture (CDC)

### 12.1 CDC for Auditing

```sql
-- Enable CDC on critical tables
EXEC sys.sp_cdc_enable_table
    @source_schema = 'dbo',
    @source_name = 'TPolicyBusiness',
    @role_name = 'CDC_Reader';

-- Query changes
SELECT * FROM cdc.dbo_TPolicyBusiness_CT
WHERE __$operation = 2 -- Update
AND __$start_lsn > @last_sync_lsn;
```

---

## Summary Statistics

### Entity Count by Domain

| Domain | Tables | Columns (Avg) | Relationships |
|--------|--------|---------------|---------------|
| **Client (CRM)** | 10 | 18 | 14 |
| **FactFind Core** | 8 | 22 | 13 |
| **Portfolio Plans** | 13 | 28 | 24 |
| **Goals & Requirements** | 7 | 16 | 9 |
| **ATR** | 4 | 12 | 5 |
| **Total** | **42** | **~780** | **65** |

### Index Statistics

- **Clustered Indexes:** 42 (one per table)
- **Non-Clustered Indexes:** ~170 (avg 4 per table)
- **Filtered Indexes:** ~32 (for active records)
- **Covering Indexes:** ~22 (for common queries)

### Constraint Statistics

- **Primary Keys:** 42
- **Foreign Keys:** 65
- **Check Constraints:** ~48
- **Unique Constraints:** ~18
- **Default Constraints:** ~90

---

## References

- **Source Analysis:** steering/Domain-Architecture/Domain-Model-Analysis-V3-Coverage-Update.md
- **API Contracts:** API-Docs/Domain-Contracts/*.md
- **Coverage Matrix:** steering/V4-Analysis/FactFind-Coverage-Matrix.md
- **Architecture Patterns:** steering/Domain-Architecture/API-Architecture-Patterns.md

---

**Document Status:** Complete and production-ready
**Last Updated:** February 12, 2026
**Maintained By:** Database Engineering Team
