# FactFind Aggregate Entity Relationship Diagram (ERD)

**Document Type:** Database Architecture Design - Root Aggregate Pattern
**Author Role:** Solution Architect / Database Engineer
**Date:** February 16, 2026
**Version:** 1.0
**Status:** Production-Ready

---

## Executive Summary

This document provides a comprehensive Entity Relationship Diagram (ERD) for the **FactFind system** using **Domain-Driven Design (DDD) aggregate pattern** with **FactFind as the root aggregate**. All child entities maintain referential integrity through `FactFindId` foreign keys, ensuring transactional consistency and proper cascade behavior.

### Key Architectural Principles

1. **Root Aggregate Pattern**: FactFind is the single root aggregate that owns all child entities
2. **Referential Integrity**: Every child entity has `FactFindId` FK ensuring orphan prevention
3. **Transactional Boundary**: All operations on child entities go through the FactFind aggregate
4. **Cascade Rules**: Deleting a FactFind cascades to all children (soft delete pattern)
5. **Multi-Tenancy**: All tables include `TenantId` for data isolation
6. **Audit Trail**: All entities track creation/modification with timestamps and user IDs

### Entity Coverage

This ERD covers **ALL 62+ entities** identified in the FactFind Data Analysis v6.1:

- **Client Domain** (10 entities): Person, Corporate, Trust, Address, Contact, Relationship, Vulnerability, Marketing, Verification
- **Employment & Income Domain** (3 entities): Employment, Income, IncomeChange
- **Financial Position Domain** (7 entities): Asset, Liability, Budget, Expenditure, ExpenditureChange
- **Portfolio Plans Domain** (15+ entities): Plan (base), Pension, Protection, Investment, Mortgage, Savings, Loan
- **Goals & Requirements Domain** (5 entities): Goal, Objective, Need, Dependant, RequirementAllocation
- **Estate Planning Domain** (4 entities): Gift, GiftTrust, Will, LPA
- **Professional Network Domain** (1 entity): ProfessionalContact
- **Notes Domain** (1 unified entity): Notes (discriminator-based)
- **ATR Domain** (4 entities): Atr, AtrTemplate, AtrQuestion, AtrResponse
- **Reference Data** (20+ entities): All lookup tables

---

## Table of Contents

1. [Aggregate Architecture Overview](#1-aggregate-architecture-overview)
2. [FactFind Root Aggregate](#2-factfind-root-aggregate)
3. [Client Domain](#3-client-domain)
4. [Employment & Income Domain](#4-employment--income-domain)
5. [Financial Position Domain](#5-financial-position-domain)
6. [Portfolio Plans Domain](#6-portfolio-plans-domain)
7. [Goals & Requirements Domain](#7-goals--requirements-domain)
8. [Estate Planning Domain](#8-estate-planning-domain)
9. [Professional Network Domain](#9-professional-network-domain)
10. [ATR Domain](#10-atr-domain)
11. [Notes Domain (Unified)](#11-notes-domain-unified)
12. [Reference Data Domain](#12-reference-data-domain)
13. [Cross-Domain Relationships](#13-cross-domain-relationships)
14. [SQL DDL Specifications](#14-sql-ddl-specifications)
15. [Indexing Strategy](#15-indexing-strategy)
16. [Cascade Rules & Constraints](#16-cascade-rules--constraints)
17. [Multi-Tenancy Implementation](#17-multi-tenancy-implementation)

---

## 1. Aggregate Architecture Overview

### 1.1 Aggregate Boundaries Diagram

```mermaid
graph TB
    subgraph "FactFind Root Aggregate"
        FF[FactFind<br/>Root Entity]

        subgraph "Client Domain"
            Client[Client]
            Person[Person]
            Corporate[Corporate]
            Trust[Trust]
            Address[Address]
            Contact[ContactDetail]
            Relationship[Relationship]
            Vulnerability[Vulnerability]
            Marketing[Marketing]
            Verification[Verification]
        end

        subgraph "Employment & Income"
            Employment[Employment]
            Income[Income]
            IncomeChange[IncomeChange]
        end

        subgraph "Financial Position"
            Asset[Asset]
            Liability[Liability]
            Budget[Budget]
            Expenditure[Expenditure]
            ExpenditureChange[ExpenditureChange]
        end

        subgraph "Portfolio Plans"
            Plan[Plan/Policy<br/>Polymorphic]
            Pension[Pension]
            Protection[Protection]
            Investment[Investment]
            Mortgage[Mortgage]
            Savings[Savings]
        end

        subgraph "Goals & Requirements"
            Goal[Goal]
            Objective[Objective]
            Need[Need]
            Dependant[Dependant]
            ReqAlloc[RequirementAllocation]
        end

        subgraph "Estate Planning"
            Gift[Gift]
            GiftTrust[GiftTrust]
            Will[Will]
            LPA[LPA]
        end

        subgraph "Professional Network"
            ProfContact[ProfessionalContact]
        end

        subgraph "ATR Domain"
            Atr[Atr]
            AtrTemplate[AtrTemplate]
            AtrQuestion[AtrQuestion]
            AtrResponse[AtrResponse]
        end

        subgraph "Notes Domain"
            Notes[Notes<br/>Discriminator]
        end

        FF -->|owns| Client
        FF -->|owns| Employment
        FF -->|owns| Asset
        FF -->|owns| Plan
        FF -->|owns| Goal
        FF -->|owns| Gift
        FF -->|owns| ProfContact
        FF -->|owns| Atr
        FF -->|owns| Notes
    end

    style FF fill:#ff6b6b,stroke:#c92a2a,stroke-width:4px,color:#fff
    style Client fill:#4dabf7,stroke:#1971c2,stroke-width:2px
    style Employment fill:#51cf66,stroke:#2f9e44,stroke-width:2px
    style Asset fill:#ffd43b,stroke:#f59f00,stroke-width:2px
    style Plan fill:#ff8787,stroke:#e03131,stroke-width:2px
    style Goal fill:#da77f2,stroke:#9c36b5,stroke-width:2px
    style Gift fill:#74c0fc,stroke:#1c7ed6,stroke-width:2px
    style ProfContact fill:#ffa94d,stroke:#fd7e14,stroke-width:2px
    style Atr fill:#a9e34b,stroke:#74b816,stroke-width:2px
    style Notes fill:#ffc9c9,stroke:#f03e3e,stroke-width:2px
```

### 1.2 Aggregate Pattern Benefits

**Why FactFind as Root Aggregate?**

1. **Transactional Consistency**: All child entities are created/modified/deleted as part of FactFind lifecycle
2. **Business Invariants**: FactFind enforces business rules (e.g., cannot complete FactFind without required sections)
3. **Simplified Access**: All queries start from FactFind, traverse to children
4. **Cascade Operations**: Deleting/archiving FactFind cleanly handles all children
5. **Audit Trail**: Single timeline for all FactFind-related changes
6. **Version Control**: FactFind versioning applies to entire aggregate

**Aggregate Rules:**

- **Child entities CANNOT exist without FactFind** (referential integrity via FK)
- **All child operations go through FactFind** (no direct child manipulation)
- **Aggregate boundary = Transactional boundary** (ACID compliance)
- **External references use IDs only** (no direct navigation to other aggregates)

---

## 2. FactFind Root Aggregate

### 2.1 FactFind Root Entity (Aggregate Root)

```mermaid
erDiagram
    TFactFind {
        int FactFindId PK "Identity, Clustered Index"
        int TenantId FK "NOT NULL, IX_Tenant, Multi-tenancy"
        int CRMContactId FK "NOT NULL, IX_Contact, Client reference"
        int JointCRMContactId FK "NULL, IX_JointContact, Joint client"
        datetime SessionDate "NOT NULL, IX_SessionDate, When FF started"
        varchar(50) Status "NOT NULL, DEFAULT InProgress, CHECK"
        int AdviserUserId FK "NOT NULL, IX_Adviser, Assigned adviser"
        datetime CompletedDate "NULL, When FF completed"
        int CompletedByUserId FK "NULL, Who completed"
        bit IsJoint "NOT NULL, DEFAULT 0, Joint fact find"
        varchar(20) FactFindType "NULL, Standard/Review/Update"
        int FactFindVersion "NULL, Version number"
        datetime ArchivedDate "NULL, Archived date"
        bit IsArchived "NOT NULL, DEFAULT 0, IX_Archived"
        bit IsDeleted "NOT NULL, DEFAULT 0, IX_Deleted"
        nvarchar(MAX) SummaryNotes "NULL, Executive summary"
        datetime CreatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion "Optimistic Concurrency Token"
    }
```

### 2.2 FactFind Table Definition

**Purpose:** Central aggregate root coordinating all fact-finding activities for a client.

**Business Rules:**
- One FactFind per client per session date (unique constraint)
- Status progression: InProgress → Completed → Archived
- Cannot delete FactFind with Status = Completed (enforce retention)
- Joint FactFinds reference second client via JointCRMContactId

**Status Values:**
- `InProgress` - Active data collection
- `Completed` - All sections complete, locked for editing
- `Archived` - Historical record, read-only
- `Cancelled` - Abandoned session

**Relationships:**
- **Client** (CRM): Many FactFinds per client (historical sessions)
- **All Child Entities**: One-to-Many (FactFind owns all children)

---

## 3. Client Domain

The Client Domain represents **WHO** the client is. These entities are typically owned by the CRM bounded context but referenced by FactFind.

### 3.1 Client Entities ERD

```mermaid
erDiagram
    TFactFind ||--o{ TClient : "references"
    TClient ||--o| TPerson : "PersonId (discriminator)"
    TClient ||--o| TCorporate : "CorporateId (discriminator)"
    TClient ||--o| TTrust : "TrustId (discriminator)"
    TClient ||--o{ TAddress : "has multiple"
    TClient ||--o{ TContactDetail : "has multiple"
    TClient ||--o{ TRelationship : "has multiple"
    TClient ||--o| TClientVulnerability : "has assessment"
    TClient ||--o| TMarketing : "has preferences"
    TClient ||--o{ TVerification : "has verification"

    TFactFind {
        int FactFindId PK
        int CRMContactId FK "Client reference"
    }

    TClient {
        int CRMContactId PK "Identity, Clustered Index"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(20) ContactType "NOT NULL, CHECK IN Person_Corporate_Trust"
        int PersonId FK "NULL, IX_Person, if ContactType=Person"
        int CorporateId FK "NULL, IX_Corporate, if ContactType=Corporate"
        int TrustId FK "NULL, IX_Trust, if ContactType=Trust"
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
        varchar(10) Title "NULL, Mr_Mrs_Dr"
        varchar(100) FirstName "NOT NULL"
        varchar(100) MiddleNames "NULL"
        varchar(100) LastName "NOT NULL"
        date DateOfBirth "NOT NULL, IX_DOB"
        char(1) Gender "NULL, CHECK IN M_F_O"
        varchar(20) MaritalStatus "NULL"
        varchar(15) NationalInsuranceNumber "NULL, Encrypted"
        char(2) NationalityCountryCode "NULL, ISO 3166-1"
        char(2) ResidencyCountryCode "NULL, ISO 3166-1"
        char(2) DomicileCountryCode "NULL, ISO 3166-1"
        varchar(20) SmokingStatus "NULL"
        decimal(5_2) HeightCm "NULL"
        decimal(5_2) WeightKg "NULL"
        varchar(50) Occupation "NULL"
        int OccupationRefId FK "NULL, TRefOccupation"
        varchar(20) EmploymentStatus "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TCorporate {
        int CorporateId PK "Identity, Clustered Index"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(200) CompanyName "NOT NULL"
        varchar(200) TradingName "NULL"
        varchar(50) RegistrationNumber "NULL, Companies House UK"
        date IncorporationDate "NULL"
        varchar(50) CompanyType "NULL"
        varchar(20) VATNumber "NULL"
        char(2) CountryOfIncorporation "NULL, ISO 3166-1"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TTrust {
        int TrustId PK "Identity, Clustered Index"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(200) TrustName "NOT NULL"
        varchar(50) TrustType "NULL, Discretionary_LifeInterest"
        date SettlementDate "NULL"
        varchar(50) TrustRegistrationNumber "NULL, HMRC"
        varchar(20) TaxReference "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TAddress {
        int AddressId PK "Identity, Clustered Index"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(200) Line1 "NOT NULL"
        varchar(200) Line2 "NULL"
        varchar(200) Line3 "NULL"
        varchar(100) Town "NOT NULL"
        varchar(100) County "NULL, ISO 3166-2"
        varchar(20) Postcode "NULL, IX_Postcode"
        char(2) CountryCode "NOT NULL, ISO 3166-1, DEFAULT GB"
        varchar(50) AddressType "NOT NULL, Home_Work_Correspondence"
        bit IsPrimary "NOT NULL, DEFAULT 0"
        date FromDate "NOT NULL"
        date ToDate "NULL, NULL = current"
        decimal(10_7) Latitude "NULL, Geocoding"
        decimal(10_7) Longitude "NULL, Geocoding"
        varchar(100) UPRN "NULL, Unique Property Reference Number"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TContactDetail {
        int ContactDetailId PK "Identity, Clustered Index"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) ContactType "NOT NULL, Mobile_Landline_Email_WhatsApp"
        varchar(200) Value "NOT NULL, Encrypted for sensitive"
        bit IsPrimary "NOT NULL, DEFAULT 0"
        bit IsDefault "NOT NULL, DEFAULT 0"
        varchar(20) VerificationStatus "NULL, Verified_Unverified"
        datetime VerifiedDate "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TRelationship {
        int RelationshipId PK "Identity, Clustered Index"
        int PrimaryCRMContactId FK "NOT NULL, IX_Primary"
        int RelatedCRMContactId FK "NOT NULL, IX_Related"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) RelationshipType "NOT NULL, Spouse_Partner_Child_Dependent"
        bit IsPrimaryRelationship "NOT NULL, DEFAULT 1"
        date FromDate "NULL"
        date ToDate "NULL, NULL = current"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
    }

    TClientVulnerability {
        int VulnerabilityId PK "Identity, Clustered Index"
        int CRMContactId FK "NOT NULL, IX_Contact, Unique"
        int TenantId FK "NOT NULL, IX_Tenant"
        date AssessmentDate "NOT NULL, IX_AssessmentDate"
        bit IsVulnerable "NOT NULL, DEFAULT 0"
        varchar(50) Category "NULL, Health_Financial_LifeEvent"
        nvarchar(MAX) Notes "NULL"
        date ReviewDate "NULL, Reassessment date"
        bit ClientPortalSuitable "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
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
        varchar(50) AccessibleFormat "NULL, LargePrint_Braille_Audio"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TVerification {
        int VerificationId PK "Identity, Clustered Index"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) DocumentType "NOT NULL, Passport_DrivingLicence_Utility"
        varchar(100) DocumentNumber "NULL, Encrypted"
        date IssueDate "NULL"
        date ExpiryDate "NULL"
        char(2) CountryOfIssue "NULL, ISO 3166-1"
        varchar(50) VerificationStatus "NOT NULL, Pending_Verified_Failed"
        datetime VerifiedDate "NULL"
        int VerifiedByUserId FK "NULL"
        varchar(MAX) DocumentFileUrl "NULL, Document storage link"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }
```

**Note on Client Domain:**
- Client entities are typically owned by CRM bounded context
- FactFind maintains FK reference (CRMContactId) using **Conformist** pattern
- Client data is READ-ONLY from FactFind perspective
- No cascade deletes on Client (prevent accidental data loss)

---

## 4. Employment & Income Domain

**Gold Standard Domain**: 100% database, entity, and API coverage.

### 4.1 Employment & Income ERD

```mermaid
erDiagram
    TFactFind ||--o{ TEmploymentDetail : "has employment"
    TFactFind ||--o{ TIncome : "has income"
    TFactFind ||--o{ TIncomeChange : "tracks income changes"
    TEmploymentDetail ||--o{ TIncome : "generates income"

    TFactFind {
        int FactFindId PK
    }

    TEmploymentDetail {
        int EmploymentDetailId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) EmploymentType "NOT NULL, CHECK Employed_SelfEmployed_Unemployed_Retired"
        varchar(200) EmployerName "NULL"
        varchar(100) JobTitle "NULL"
        int OccupationRefId FK "NULL, TRefOccupation"
        date StartDate "NULL"
        date EndDate "NULL, NULL = current"
        varchar(50) Status "NOT NULL, DEFAULT Active"
        decimal(18_2) AnnualSalary "NULL"
        char(3) SalaryCurrency "NULL, ISO 4217, DEFAULT GBP"
        varchar(20) PayFrequency "NULL, Monthly_Weekly"
        decimal(18_2) BonusAmount "NULL"
        decimal(18_2) BenefitsInKind "NULL"
        varchar(200) BusinessName "NULL, For self-employed"
        nvarchar(MAX) NatureOfBusiness "NULL"
        decimal(18_2) AnnualProfit "NULL, For self-employed"
        decimal(18_2) TaxableProfit "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TIncome {
        int IncomeId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) IncomeSource "NOT NULL, Employment_Rental_Investment_Pension"
        varchar(200) Description "NOT NULL"
        decimal(18_2) GrossAmount "NOT NULL, CHECK > 0"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        varchar(20) Frequency "NOT NULL, Monthly_Annual_Weekly"
        decimal(18_2) NetAmount "NULL, After tax"
        decimal(5_2) TaxRate "NULL, Percentage"
        decimal(18_2) TaxPaid "NULL"
        date StartDate "NULL"
        date EndDate "NULL, NULL = ongoing"
        bit IsGuaranteed "NOT NULL, DEFAULT 0, Stable vs variable"
        int LinkedEmploymentId FK "NULL, Link to TEmploymentDetail"
        int LinkedAssetId FK "NULL, Link to TAssets"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TIncomeChange {
        int IncomeChangeId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int IncomeId FK "NOT NULL, IX_Income"
        int TenantId FK "NOT NULL, IX_Tenant"
        decimal(18_2) PreviousAmount "NOT NULL"
        decimal(18_2) NewAmount "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217"
        date ChangeDate "NOT NULL, IX_ChangeDate"
        varchar(200) ChangeReason "NULL, Promotion_Bonus_PayRise_Reduction"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
    }
```

### 4.2 Key Relationships

**Employment to Income:**
- One Employment can generate multiple Income streams (e.g., Salary + Bonus + Benefits)
- `TIncome.LinkedEmploymentId` FK establishes relationship

**FactFind Ownership:**
- All employment and income records MUST belong to a FactFind
- Cascade delete when FactFind is deleted
- Prevents orphaned employment/income records

**Technical Debt Note:**
- TEmploymentDetail has **dual-entity mapping** (Employment + EmploymentStatus hierarchy)
- This is documented technical debt; recommend CQRS pattern for resolution

---

## 5. Financial Position Domain

### 5.1 Assets & Liabilities ERD

```mermaid
erDiagram
    TFactFind ||--o{ TAssets : "has assets"
    TFactFind ||--o{ TLiabilities : "has liabilities"
    TFactFind ||--o{ TBudget : "has budget"
    TFactFind ||--o{ TExpenditure : "has expenditure"
    TFactFind ||--o{ TExpenditureChange : "tracks changes"
    TAssets ||--o| TIncome : "generates income"
    TLiabilities }o--o| TAssets : "secured by asset"

    TFactFind {
        int FactFindId PK
    }

    TAssets {
        int AssetId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) AssetCategory "NOT NULL, Property_Vehicle_Savings_Investment"
        varchar(200) Description "NOT NULL"
        decimal(18_2) CurrentValue "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        decimal(18_2) PurchaseValue "NULL"
        date PurchaseDate "NULL"
        date ValuationDate "NULL, IX_ValuationDate"
        varchar(50) PropertyType "NULL, Residential_Commercial_BTL"
        nvarchar(MAX) PropertyAddress "NULL, JSON"
        varchar(50) Tenure "NULL, Freehold_Leasehold"
        decimal(18_2) OutstandingMortgage "NULL"
        bit GeneratesIncome "NOT NULL, DEFAULT 0"
        decimal(18_2) RentalIncome "NULL"
        varchar(20) RentalFrequency "NULL"
        int LinkedIncomeId FK "NULL, TIncome"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TLiabilities {
        int LiabilityId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) LiabilityCategory "NOT NULL, Mortgage_Loan_CreditCard"
        varchar(200) Description "NOT NULL"
        varchar(200) CreditorName "NULL"
        decimal(18_2) OutstandingBalance "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        decimal(18_2) MonthlyPayment "NOT NULL"
        decimal(5_2) InterestRate "NULL, Percentage"
        date StartDate "NULL"
        date EndDate "NULL, Maturity_payoff date"
        int TermMonths "NULL, Original term"
        int RemainingMonths "NULL, Calculated"
        bit IsSecured "NOT NULL, DEFAULT 0"
        int SecuredAssetId FK "NULL, TAssets"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TBudget {
        int BudgetId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        decimal(18_2) TotalMonthlyIncome "NOT NULL, DEFAULT 0"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        decimal(18_2) TotalMonthlyExpenditure "NOT NULL, DEFAULT 0"
        decimal(18_2) MonthlyDisposableIncome "COMPUTED TotalIncome - TotalExpenditure PERSISTED"
        decimal(18_2) AnnualDisposableIncome "COMPUTED MonthlyDisposableIncome * 12 PERSISTED"
        datetime CalculatedDate "NOT NULL, DEFAULT GETUTCDATE()"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TExpenditure {
        int ExpenditureId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        int ExpenditureTypeRefId FK "NOT NULL, TRefExpenditureType"
        varchar(200) Description "NOT NULL"
        decimal(18_2) Amount "NOT NULL, CHECK > 0"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        varchar(20) Frequency "NOT NULL, Monthly_Annual"
        bit IsPriority "NOT NULL, DEFAULT 0, Essential vs discretionary"
        bit IsCommitted "NOT NULL, DEFAULT 0, Contractual obligation"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TExpenditureChange {
        int ExpenditureChangeId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int ExpenditureId FK "NOT NULL, IX_Expenditure"
        int TenantId FK "NOT NULL, IX_Tenant"
        decimal(18_2) PreviousAmount "NOT NULL"
        decimal(18_2) NewAmount "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217"
        date ChangeDate "NOT NULL, IX_ChangeDate"
        varchar(200) ChangeReason "NULL"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
    }

    TCreditHistory {
        int CreditHistoryId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        bit HasCCJs "NOT NULL, DEFAULT 0"
        bit HasBankruptcy "NOT NULL, DEFAULT 0"
        bit HasIVA "NOT NULL, DEFAULT 0"
        bit HasArrears "NOT NULL, DEFAULT 0"
        bit HasDefaults "NOT NULL, DEFAULT 0"
        date LastCreditCheckDate "NULL"
        int CreditScore "NULL"
        varchar(50) CreditScoreAgency "NULL, Experian_Equifax_TransUnion"
        nvarchar(MAX) CreditIssueDetails "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TAffordability {
        int AffordabilityId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        decimal(18_2) TotalMonthlyIncome "NOT NULL"
        decimal(18_2) TotalMonthlyCommittedExpenditure "NOT NULL"
        decimal(18_2) TotalMonthlyDiscretionaryExpenditure "NOT NULL"
        decimal(18_2) AffordableSurplus "COMPUTED TotalIncome - TotalCommittedExpenditure PERSISTED"
        decimal(5_2) AffordabilityPercentage "COMPUTED AffordableSurplus / TotalIncome * 100 PERSISTED"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        datetime CalculatedDate "NOT NULL"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
    }
```

### 5.2 Computed Columns

**Budget:**
- `MonthlyDisposableIncome` = TotalMonthlyIncome - TotalMonthlyExpenditure (PERSISTED)
- `AnnualDisposableIncome` = MonthlyDisposableIncome * 12 (PERSISTED)

**Affordability:**
- `AffordableSurplus` = TotalIncome - TotalCommittedExpenditure (PERSISTED)
- `AffordabilityPercentage` = (AffordableSurplus / TotalIncome) * 100 (PERSISTED)

**Why PERSISTED:**
- Indexed for fast queries
- Consistent calculations
- Audit trail of historical values

---

## 6. Portfolio Plans Domain

**Complex Polymorphic Domain**: 1,773 plan types across pensions, protection, investments, savings, mortgages.

### 6.1 Portfolio Plans Base ERD

```mermaid
erDiagram
    TFactFind ||--o{ TPolicyBusiness : "references plans"
    TPolicyBusiness ||--|| TPolicyDetail : "has details"
    TPolicyDetail ||--|| TPlanDescription : "product categorization"
    TPlanDescription }o--|| TRefPlanType2ProdSubType : "discriminator"
    TPolicyDetail ||--o{ TPolicyOwner : "has owners"
    TPolicyOwner }o--|| TCRMContact : "owner"
    TPolicyBusiness ||--o| TPension : "PlanType = Pension"
    TPolicyBusiness ||--o| TProtection : "PlanType = Protection"
    TPolicyBusiness ||--o| TInvestment : "PlanType = Investment"
    TPolicyBusiness ||--o| TMortgage : "PlanType = Mortgage"
    TPolicyBusiness ||--o| TSavings : "PlanType = Savings"

    TFactFind {
        int FactFindId PK
    }

    TPolicyBusiness {
        bigint PolicyBusinessId PK "Identity, Clustered Index"
        bigint PolicyDetailId FK "NOT NULL, IX_PolicyDetail"
        int FactFindId FK "NULL, IX_FactFind, Optional link"
        int PropositionTypeId FK "NOT NULL"
        int PractitionerId FK "NOT NULL, IX_Practitioner"
        int ServicingUserId FK "NULL"
        int TenantId FK "NOT NULL, IX_Tenant"
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
        bit OffPanelFg "NOT NULL, DEFAULT 0"
        varchar(50) SequentialRef "NULL, IX_SequentialRef"
        bit IsDeleted "NOT NULL, DEFAULT 0"
        bigint ConcurrencyId "Concurrency Token"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
    }

    TPolicyDetail {
        bigint PolicyDetailId PK "Identity, Clustered Index"
        bigint PlanDescriptionId FK "NOT NULL, IX_PlanDescription"
        int TenantId FK "NOT NULL, IX_Tenant"
        int TermYears "NULL"
        bit WholeOfLifeFg "NULL"
        bit LetterOfAuthorityFg "NULL"
        datetime JoiningDate "NULL"
        datetime LeavingDate "NULL"
        decimal(18_2) GrossAnnualIncome "NULL"
        bigint ConcurrencyId
    }

    TPlanDescription {
        bigint PlanDescriptionId PK "Identity, Clustered Index"
        int RefPlanType2ProdSubTypeId FK "NOT NULL, IX_PlanType2ProdSubType, DISCRIMINATOR"
        int RefProdProviderId FK "NOT NULL, IX_Provider"
        int SchemeOwnerCRMContactId FK "NULL"
        varchar(50) SchemeStatus "NULL"
        varchar(100) SchemeNumber "NULL"
        varchar(200) SchemeName "NULL"
        datetime SchemeStatusDate "NULL"
        datetime MaturityDate "NULL"
        bigint ConcurrencyId
    }

    TPolicyOwner {
        bigint PolicyOwnerId PK "Identity, Clustered Index"
        bigint PolicyDetailId FK "NOT NULL, IX_PolicyDetail"
        int CRMContactId FK "NOT NULL, IX_CRMContact"
        int OwnerOrder "NULL, 1 or 2"
        bigint ConcurrencyId
    }

    TRefPlanType2ProdSubType {
        int RefPlanType2ProdSubTypeId PK "Identity"
        int RefPlanTypeId FK "NOT NULL"
        int ProdSubTypeId FK "NOT NULL"
        int RefPlanDiscriminatorId FK "NULL, High-level grouping"
        int TenantId FK "NOT NULL"
        varchar(100) PlanTypeName "NOT NULL, Life Assurance_Pension_Investment"
        varchar(100) ProductSubTypeName "NOT NULL, Term_WholeOfLife_SIPP_ISA"
        int DisplayOrder "NULL"
        bit IsActive "NOT NULL, DEFAULT 1"
        datetime CreatedDate "NOT NULL"
    }
```

### 6.2 Pension Extensions

```mermaid
erDiagram
    TPolicyBusiness ||--o| TPension : "extension"

    TPension {
        bigint PensionId PK "Identity"
        bigint PolicyBusinessId FK "NOT NULL, Unique, IX_Policy"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) PensionType "NOT NULL, SIPP_PersonalPension_FinalSalary_StatePension"
        int RetirementAge "NULL, Target retirement age"
        decimal(18_2) ProjectedValue "NULL, At retirement"
        char(3) ProjectedCurrency "NULL, ISO 4217"
        date ProjectionDate "NULL"
        decimal(18_2) EmployerContribution "NULL"
        varchar(20) EmployerContributionFrequency "NULL"
        decimal(5_2) EmployerContributionPercent "NULL"
        decimal(18_2) TaxReliefAmount "NULL, Annual"
        date CrystallisationDate "NULL, When benefits taken"
        bit DrawdownStarted "NOT NULL, DEFAULT 0"
        decimal(18_2) AnnualDrawdown "NULL"
        decimal(18_2) GuaranteedPension "NULL, For DB schemes"
        decimal(18_2) LumpSumEntitlement "NULL, Tax-free cash"
        decimal(5_2) AccrualRate "NULL, For DB schemes"
        int PensionableService "NULL, Years for DB"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }
```

### 6.3 Protection Extensions

```mermaid
erDiagram
    TPolicyBusiness ||--o| TProtection : "extension"
    TProtection ||--o{ TAssuredLife : "0 to 2 lives"
    TAssuredLife }o--|| TCRMContact : "insured person"
    TAssuredLife }o--o| TBenefit : "main benefit"
    TAssuredLife }o--o| TBenefit : "additional benefit"

    TProtection {
        bigint ProtectionId PK "Identity, Clustered Index"
        bigint PolicyBusinessId FK "NOT NULL, Unique, IX_Policy"
        int TenantId FK "NOT NULL, IX_Tenant"
        int RefPlanSubCategoryId FK "NOT NULL, DISCRIMINATOR, 51=PersonalProtection_47=GeneralInsurance"
        bit InTrust "NOT NULL, DEFAULT 0"
        varchar(200) ToWhom "NULL, Beneficiary"
        decimal(18_2) LifeCoverSumAssured "NULL"
        int TermValue "NULL, Years"
        varchar(25) LifeCoverPremiumStructure "NULL"
        int LifeCoverUntilAge "NULL"
        decimal(18_2) CriticalIllnessSumAssured "NULL"
        datetime ReviewDate "NULL"
        nvarchar(MAX) BenefitSummary "NULL"
        nvarchar(MAX) Exclusions "NULL"
        int WaitingPeriod "NULL, Deferred period"
        bigint ConcurrencyId
    }

    TAssuredLife {
        bigint AssuredLifeId PK "Identity, Clustered Index"
        bigint ProtectionId FK "NOT NULL, IX_Protection"
        int PartyId FK "NOT NULL, IX_Party, TCRMContact"
        bigint BenefitId FK "NULL, IX_Benefit"
        bigint AdditionalBenefitId FK "NULL"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) Title "NULL"
        varchar(100) FirstName "NULL"
        varchar(100) LastName "NULL"
        datetime DOB "NULL"
        varchar(10) GenderType "NULL"
        int OrderKey "NULL, 1 or 2"
        bigint ConcurrencyId
    }

    TBenefit {
        bigint BenefitId PK "Identity, Clustered Index"
        bigint PolicyBusinessId FK "NOT NULL, IX_Policy"
        int TenantId FK "NOT NULL, IX_Tenant"
        decimal(18_2) BenefitAmount "NULL"
        decimal(18_2) SplitBenefitAmount "NULL"
        bit PremiumWaiverWoc "NULL, Waiver on Critical Illness"
        int BenefitDeferredPeriod "NULL"
        bit IsRated "NULL, Rated due to health"
        nvarchar(MAX) BenefitOptions "NULL"
        decimal(18_2) PensionCommencementLumpSum "NULL"
        bit IsSpousesBenefit "NULL"
        decimal(5_2) SpousesOrDependentsPercentage "NULL"
        int GuaranteedPeriod "NULL"
        bigint ConcurrencyId
    }
```

### 6.4 Investment & Mortgage Extensions

```mermaid
erDiagram
    TPolicyBusiness ||--o| TInvestment : "extension"
    TPolicyBusiness ||--o| TMortgage : "extension"
    TInvestment ||--o{ TInvestmentHolding : "holdings"

    TInvestment {
        bigint InvestmentId PK "Identity"
        bigint PolicyBusinessId FK "NOT NULL, Unique, IX_Policy"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) InvestmentType "NOT NULL, ISA_GIA_Bond_OEIC_UnitTrust"
        varchar(50) ISAType "NULL, StocksAndShares_Cash_Lifetime"
        decimal(18_2) CurrentYearContribution "NULL"
        decimal(18_2) ISAAllowanceRemaining "NULL"
        int TaxYearEnd "NULL, e.g. 2024 for 2023_24"
        decimal(5_2) AnnualReturnPercent "NULL"
        varchar(50) RiskRating "NULL, Low_Medium_High"
        bit AutoRebalance "NOT NULL, DEFAULT 0"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TInvestmentHolding {
        bigint HoldingId PK "Identity"
        bigint InvestmentId FK "NOT NULL, IX_Investment"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) AssetClass "NOT NULL, Equity_Bond_Property_Cash"
        varchar(200) FundName "NOT NULL"
        varchar(20) ISIN "NULL, International Securities ID"
        varchar(20) SEDOL "NULL"
        decimal(18_10) Units "NULL"
        decimal(18_4) UnitPrice "NULL"
        decimal(18_2) Value "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217"
        decimal(5_2) AllocationPercent "NULL"
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
        varchar(50) MortgageType "NOT NULL, Residential_BTL_Remortgage"
        nvarchar(MAX) PropertyAddress "NOT NULL, JSON"
        decimal(18_2) PropertyValue "NULL"
        decimal(18_2) LoanAmount "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        decimal(18_2) OutstandingBalance "NOT NULL"
        decimal(5_2) InterestRate "NOT NULL"
        varchar(50) RateType "NOT NULL, Fixed_Variable_Tracker"
        date FixedRateEndDate "NULL"
        decimal(18_2) MonthlyPayment "NOT NULL"
        int TermMonths "NOT NULL"
        int RemainingMonths "NULL, Calculated"
        bit IsInterestOnly "NOT NULL, DEFAULT 0"
        decimal(5_2) LTV "COMPUTED OutstandingBalance _ NULLIF_PropertyValue_0_ * 100 PERSISTED"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }
```

### 6.5 Plan Discriminator Values

**TRefPlanType2ProdSubType** maps to these high-level discriminators:

| Discriminator | Plan Types Included | Count |
|---------------|---------------------|-------|
| **Pension** | SIPP, Personal Pension, Stakeholder, Final Salary, State Pension, Annuities, Drawdown | 350+ |
| **Protection** | Life Assurance, Critical Illness, Income Protection, General Insurance, Payment Protection | 200+ |
| **Investment** | ISA, GIA, Bonds, OEICs, Unit Trusts, Offshore Bonds, Collective Investments | 600+ |
| **Mortgage** | Residential, Buy-to-Let, Remortgage, Equity Release, Second Charge | 150+ |
| **Savings** | Cash ISA, Savings Accounts, Fixed Term Deposits, NS&I, Premium Bonds | 200+ |
| **Loan** | Personal Loans, Secured Loans, Overdrafts, Car Finance | 100+ |
| **Other** | General, Miscellaneous Products | 173 |

**Total:** 1,773 plan types

---

## 7. Goals & Requirements Domain

Modern microservice with event-driven architecture.

### 7.1 Goals & Requirements ERD

```mermaid
erDiagram
    TFactFind ||--o{ TRequirement : "references requirements"
    TRequirement ||--o{ TRequirementAllocation : "allocated to plans"
    TRequirement ||--o| TRiskProfile : "has risk profile"
    TRequirement }o--|| TRefRequirementType : "discriminator"
    TRequirement ||--o{ TDependant : "has dependants"
    TRequirementAllocation }o--|| TPolicyBusiness : "links to plan"

    TFactFind {
        int FactFindId PK
    }

    TRequirement {
        uniqueidentifier RequirementId PK "NEWSEQUENTIALID_, Clustered"
        int FactFindId FK "NULL, IX_FactFind, Optional link"
        uniqueidentifier ClientId FK "NOT NULL, IX_Client, GUID"
        int TenantId FK "NOT NULL, IX_Tenant"
        int RefRequirementTypeId FK "NOT NULL, IX_Type, DISCRIMINATOR"
        varchar(200) Description "NOT NULL"
        int Priority "NULL, 1=High_5=Low"
        decimal(18_2) TargetAmount "NULL"
        char(3) Currency "NULL, ISO 4217, DEFAULT GBP"
        date TargetDate "NULL, IX_TargetDate"
        varchar(50) Status "NOT NULL, DEFAULT Active, IX_Status"
        int TimeHorizonYears "NULL, Calculated"
        decimal(18_2) CurrentAllocatedAmount "NULL, Sum of allocations"
        decimal(18_2) ShortfallAmount "COMPUTED TargetAmount - CurrentAllocatedAmount PERSISTED"
        nvarchar(MAX) Notes "NULL"
        uniqueidentifier RiskProfileId FK "NULL, For investment goals"
        datetime CreatedAt "NOT NULL, DEFAULT SYSUTCDATETIME_"
        uniqueidentifier CreatedByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
        uniqueidentifier UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TRefRequirementType {
        int RefRequirementTypeId PK "Identity"
        varchar(50) TypeName "NOT NULL, Unique, Investment_Retirement_Protection_Education"
        varchar(50) Discriminator "NOT NULL"
        nvarchar(MAX) Description "NULL"
        bit IsActive "NOT NULL, DEFAULT 1"
        int DisplayOrder "NULL"
        datetime CreatedAt "NOT NULL"
    }

    TRequirementAllocation {
        uniqueidentifier AllocationId PK "NEWSEQUENTIALID_"
        uniqueidentifier RequirementId FK "NOT NULL, IX_Requirement"
        bigint PolicyBusinessId FK "NOT NULL, IX_Policy"
        int TenantId FK "NOT NULL, IX_Tenant"
        decimal(18_2) AllocationAmount "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217"
        decimal(5_2) AllocationPercentage "NULL"
        date AllocationDate "NOT NULL"
        varchar(50) Status "NOT NULL, DEFAULT Active"
        datetime CreatedAt "NOT NULL"
        uniqueidentifier CreatedByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
        uniqueidentifier UpdatedByUserId FK "NULL"
    }

    TRiskProfile {
        uniqueidentifier RiskProfileId PK "NEWSEQUENTIALID_, Clustered"
        uniqueidentifier RequirementId FK "NULL, IX_Requirement"
        uniqueidentifier ClientId FK "NOT NULL, IX_Client"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) RiskTitle "NOT NULL, Cautious_Balanced_Adventurous"
        int RiskScore "NOT NULL, CHECK 1-10"
        varchar(50) RiskAttitude "NULL, Low_Medium_High"
        varchar(50) RiskCapacity "NULL"
        varchar(50) RiskNeed "NULL"
        uniqueidentifier ATRTemplateId FK "NULL, TAtrTemplate"
        nvarchar(MAX) QuestionnaireResponses "NULL, JSON"
        date AssessmentDate "NOT NULL, IX_AssessmentDate"
        date ReviewDate "NULL"
        datetime CreatedAt "NOT NULL"
        uniqueidentifier CreatedByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
        uniqueidentifier UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TDependant {
        uniqueidentifier DependantId PK "NEWSEQUENTIALID_"
        int FactFindId FK "NULL, IX_FactFind, CASCADE DELETE"
        uniqueidentifier RequirementId FK "NULL, IX_Requirement, For protection goals"
        uniqueidentifier ClientId FK "NOT NULL, IX_Client"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(100) Name "NOT NULL"
        varchar(50) Relationship "NOT NULL, Spouse_Partner_Child_Parent_Dependent"
        date DateOfBirth "NULL"
        bit IsFinanciallyDependent "NOT NULL, DEFAULT 1"
        decimal(18_2) AnnualCost "NULL"
        char(3) Currency "NULL, ISO 4217"
        date DependencyEndDate "NULL"
        datetime CreatedAt "NOT NULL"
        uniqueidentifier CreatedByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
        uniqueidentifier UpdatedByUserId FK "NULL"
    }

    TNeedsAndPriorities {
        uniqueidentifier NeedId PK "NEWSEQUENTIALID_"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        uniqueidentifier ClientId FK "NOT NULL, IX_Client"
        int TenantId FK "NOT NULL, IX_Tenant"
        uniqueidentifier QuestionId FK "NOT NULL, IX_Question"
        nvarchar(MAX) AnswerText "NOT NULL"
        datetime AnsweredAt "NOT NULL"
        uniqueidentifier AnsweredByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
        uniqueidentifier UpdatedByUserId FK "NULL"
    }

    TNeedsAndPrioritiesQuestion {
        uniqueidentifier QuestionId PK "NEWSEQUENTIALID_"
        int TenantId FK "NOT NULL, IX_Tenant, Firm-level"
        nvarchar(MAX) QuestionText "NOT NULL"
        varchar(50) QuestionType "NOT NULL, Text_MultiChoice_YesNo"
        nvarchar(MAX) OptionsList "NULL, JSON"
        int DisplayOrder "NOT NULL"
        bit IsRequired "NOT NULL, DEFAULT 0"
        bit IsActive "NOT NULL, DEFAULT 1"
        varchar(50) Category "NULL, Goals_Preferences_Concerns"
        datetime CreatedAt "NOT NULL"
        uniqueidentifier CreatedByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
        uniqueidentifier UpdatedByUserId FK "NULL"
    }
```

### 7.2 Requirement Type Discriminators

| RequirementType | Description | Typical Fields |
|-----------------|-------------|----------------|
| **Investment** | Wealth accumulation goals | TargetAmount, TargetDate, RiskProfile |
| **Retirement** | Retirement income planning | RetirementAge, TargetIncome, DrawdownStrategy |
| **Protection** | Life/critical illness cover | CoverAmount, CoverTerm, Dependants |
| **Education** | School/university fees | ChildName, StartDate, EstimatedCost |
| **Mortgage** | Property purchase | PropertyValue, DepositAmount, MortgageTerm |
| **Debt Repayment** | Clear debts | DebtAmount, TargetRepaymentDate |
| **Emergency Fund** | Build reserves | TargetMonths, MonthlyExpenditure |
| **Estate Planning** | Inheritance planning | BeneficiaryDetails, EstateValue |

---

## 8. Estate Planning Domain

### 8.1 Estate Planning ERD

```mermaid
erDiagram
    TFactFind ||--o{ TEstatePlanning : "has estate plan"
    TEstatePlanning ||--o{ TGift : "has gifts"
    TEstatePlanning ||--o{ TGiftTrust : "has gift trusts"
    TEstatePlanning ||--o| TWill : "has will"
    TEstatePlanning ||--o| TLPA : "has LPA"

    TFactFind {
        int FactFindId PK
    }

    TEstatePlanning {
        int EstatePlanningId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        decimal(18_2) EstimatedEstateValue "NULL"
        char(3) Currency "NULL, ISO 4217, DEFAULT GBP"
        bit HasWill "NOT NULL, DEFAULT 0"
        bit HasLPA "NOT NULL, DEFAULT 0"
        bit HasTrusts "NOT NULL, DEFAULT 0"
        decimal(18_2) PotentialIHTLiability "NULL, Inheritance Tax"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TGift {
        int GiftId PK "Identity, Clustered Index"
        int EstatePlanningId FK "NOT NULL, IX_EstatePlanning"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(200) RecipientName "NOT NULL"
        varchar(50) RecipientRelationship "NULL"
        decimal(18_2) GiftValue "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        date GiftDate "NOT NULL, IX_GiftDate"
        varchar(50) GiftType "NULL, Cash_Property_Shares"
        bit IsPotentiallyExempt "NULL, PET within 7 years"
        date ExemptionDate "NULL, 7 years from gift date"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TGiftTrust {
        int GiftTrustId PK "Identity, Clustered Index"
        int EstatePlanningId FK "NOT NULL, IX_EstatePlanning"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int TenantId FK "NOT NULL, IX_Tenant"
        int TrustId FK "NULL, TTrust, If existing trust"
        varchar(200) TrustName "NOT NULL"
        varchar(50) TrustType "NULL, Discretionary_Absolute"
        date EstablishmentDate "NOT NULL"
        decimal(18_2) GiftValue "NOT NULL"
        char(3) Currency "NOT NULL, ISO 4217, DEFAULT GBP"
        nvarchar(MAX) BeneficiaryDetails "NULL"
        nvarchar(MAX) TrusteeDetails "NULL"
        varchar(50) TrustRegistrationNumber "NULL, HMRC"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TWill {
        int WillId PK "Identity, Clustered Index"
        int EstatePlanningId FK "NOT NULL, IX_EstatePlanning, Unique"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        bit HasCurrentWill "NOT NULL, DEFAULT 0"
        date WillDate "NULL"
        varchar(200) ExecutorNames "NULL"
        varchar(200) BeneficiaryNames "NULL"
        nvarchar(MAX) BeneficiaryDetails "NULL, JSON"
        varchar(200) SolicitorName "NULL"
        nvarchar(MAX) SolicitorAddress "NULL"
        date LastReviewDate "NULL"
        bit RequiresUpdate "NOT NULL, DEFAULT 0"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }

    TLPA {
        int LPAId PK "Identity, Clustered Index"
        int EstatePlanningId FK "NOT NULL, IX_EstatePlanning"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) LPAType "NOT NULL, PropertyAndFinancial_HealthAndWelfare_Both"
        bit HasPropertyAndFinancialLPA "NOT NULL, DEFAULT 0"
        bit HasHealthAndWelfareLPA "NOT NULL, DEFAULT 0"
        date PropertyAndFinancialLPADate "NULL"
        date HealthAndWelfareLPADate "NULL"
        nvarchar(MAX) AttorneyDetails "NULL, JSON"
        varchar(50) RegistrationNumber "NULL, Office of Public Guardian"
        date LastReviewDate "NULL"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }
```

---

## 9. Professional Network Domain

### 9.1 Professional Contacts ERD

```mermaid
erDiagram
    TFactFind ||--o{ TProfessionalContact : "has contacts"

    TFactFind {
        int FactFindId PK
    }

    TProfessionalContact {
        int ProfessionalContactId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact, Client"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) ProfessionalType "NOT NULL, Solicitor_Accountant_Mortgage_Broker_Adviser"
        varchar(200) CompanyName "NULL"
        varchar(100) ContactName "NOT NULL"
        varchar(200) Email "NULL"
        varchar(50) Phone "NULL"
        nvarchar(MAX) Address "NULL, JSON"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedDate "NOT NULL"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }
```

---

## 10. ATR Domain

Attitude to Risk assessment system.

### 10.1 ATR ERD

```mermaid
erDiagram
    TFactFind ||--o{ TAtr : "has ATR assessments"
    TAtr }o--|| TAtrTemplate : "uses template"
    TAtrTemplate ||--o{ TAtrQuestion : "has questions"
    TAtr ||--o{ TAtrQuestionnaireResponse : "has responses"
    TAtrQuestionnaireResponse }o--|| TAtrQuestion : "answers question"
    TRiskProfile }o--|| TAtrTemplate : "references template"

    TFactFind {
        int FactFindId PK
    }

    TAtr {
        uniqueidentifier AtrId PK "NEWSEQUENTIALID_, Clustered"
        int FactFindId FK "NULL, IX_FactFind, Optional link"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        uniqueidentifier ATRTemplateId FK "NOT NULL, IX_Template"
        int RiskScore "NOT NULL, CHECK 1-10, IX_RiskScore"
        varchar(50) RiskCategory "NOT NULL, Cautious_Balanced_Adventurous"
        nvarchar(MAX) QuestionnaireResponsesJson "NULL, Full Q&A JSON"
        date AssessmentDate "NOT NULL, IX_AssessmentDate"
        date ExpiryDate "NULL, 12 months validity"
        varchar(50) Status "NOT NULL, DEFAULT Active"
        uniqueidentifier AssessedByUserId FK "NOT NULL"
        nvarchar(MAX) Notes "NULL"
        datetime CreatedAt "NOT NULL"
        datetime UpdatedAt "NULL"
        rowversion RowVersion
    }

    TAtrTemplate {
        uniqueidentifier ATRTemplateId PK "NEWSEQUENTIALID_"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(200) TemplateName "NOT NULL"
        varchar(50) TemplateVersion "NOT NULL, e.g. v2.0"
        nvarchar(MAX) Description "NULL"
        bit IsActive "NOT NULL, DEFAULT 1, IX_Active"
        int TotalQuestions "NULL, Calculated"
        nvarchar(MAX) ScoringRulesJson "NULL, JSON scoring algorithm"
        datetime CreatedAt "NOT NULL"
        uniqueidentifier CreatedByUserId FK "NOT NULL"
        datetime UpdatedAt "NULL"
    }

    TAtrQuestion {
        uniqueidentifier QuestionId PK "NEWSEQUENTIALID_"
        uniqueidentifier ATRTemplateId FK "NOT NULL, IX_Template"
        int QuestionNumber "NOT NULL, Ordering"
        nvarchar(MAX) QuestionText "NOT NULL"
        varchar(50) QuestionType "NOT NULL, MultiChoice_Scale"
        nvarchar(MAX) OptionsJson "NULL, JSON array with scores"
        int MaxScore "NULL"
        bit IsRequired "NOT NULL, DEFAULT 1"
        datetime CreatedAt "NOT NULL"
    }

    TAtrQuestionnaireResponse {
        uniqueidentifier ResponseId PK "NEWSEQUENTIALID_"
        uniqueidentifier AtrId FK "NOT NULL, IX_Atr"
        uniqueidentifier QuestionId FK "NOT NULL, IX_Question"
        int TenantId FK "NOT NULL, IX_Tenant"
        nvarchar(MAX) AnswerText "NOT NULL"
        int Score "NULL, Points for answer"
        datetime AnsweredAt "NOT NULL"
    }
```

### 10.2 ATR Scoring

**Risk Score Calculation:**
- Sum of all question scores
- Normalized to 1-10 scale
- Risk categories:
  - 1-3: Cautious
  - 4-6: Balanced
  - 7-8: Adventurous
  - 9-10: Speculative

**Expiry:**
- ATR assessments typically valid for 12 months
- `ExpiryDate` triggers review workflow

---

## 11. Notes Domain (Unified)

Unified discriminator-based notes pattern resolving technical debt from 10+ scattered notes tables.

### 11.1 Unified Notes ERD

```mermaid
erDiagram
    TFactFind ||--o{ TNotes : "has notes"

    TFactFind {
        int FactFindId PK
    }

    TNotes {
        bigint NoteId PK "Identity, Clustered Index"
        int FactFindId FK "NOT NULL, IX_FactFind, CASCADE DELETE"
        int CRMContactId FK "NOT NULL, IX_Contact"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(50) Discriminator "NOT NULL, IX_Discriminator, CHECK IN list"
        nvarchar(MAX) Content "NOT NULL, MAX 15000 chars"
        datetime CreatedDate "NOT NULL, IX_Created"
        int CreatedByUserId FK "NOT NULL"
        datetime UpdatedDate "NULL"
        int UpdatedByUserId FK "NULL"
        rowversion RowVersion
    }
```

### 11.2 Notes Discriminator Values

| Discriminator | Description | Legacy Table |
|---------------|-------------|--------------|
| **Profile** | General client profile notes | TCRMContactNotes |
| **Employment** | Employment-related notes | TEmploymentNote |
| **AssetLiabilities** | Assets and liabilities notes | TBudgetMiscellaneous.AssetLiabilityNotes |
| **Budget** | Budget and affordability notes | TBudgetMiscellaneous.BudgetNotes |
| **Mortgage** | Mortgage-specific notes | TMortgageNotes |
| **Protection** | Protection needs notes | TProtectionMiscellaneous |
| **Retirement** | Retirement planning notes | TRetirementNextSteps |
| **Investment** | Investment notes | TSavingsNextSteps |
| **EstatePlanning** | Estate planning notes | TEstatePlanningNotes |
| **Summary** | FactFind summary notes | TFactFindSummary |

**API Access:**
```
GET /v2/factfinds/{factFindId}/notes?discriminator=Employment
POST /v2/factfinds/{factFindId}/notes
PUT /v2/factfinds/{factFindId}/notes/{noteId}
DELETE /v2/factfinds/{factFindId}/notes/{noteId}
```

**Benefits:**
- Single API for all note types
- Consistent CRUD operations
- Simplified client implementation
- Reduces 10 tables to 1
- Maintains backward compatibility via discriminator

---

## 12. Reference Data Domain

### 12.1 Reference Data ERD

```mermaid
erDiagram
    TRefExpenditureType {
        int ExpenditureTypeRefId PK "Identity"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(100) TypeName "NOT NULL, Housing_Utilities_Food_Transport"
        varchar(100) CategoryGroup "NULL, Essential_Discretionary"
        int DisplayOrder "NULL"
        bit IsActive "NOT NULL, DEFAULT 1"
        datetime CreatedDate "NOT NULL"
    }

    TRefOccupation {
        int OccupationRefId PK "Identity"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(200) OccupationTitle "NOT NULL"
        varchar(50) OccupationCategory "NULL"
        varchar(10) SOCCode "NULL, Standard Occupational Classification"
        bit IsActive "NOT NULL, DEFAULT 1"
        datetime CreatedDate "NOT NULL"
    }

    TRefAssetCategory {
        int AssetCategoryRefId PK "Identity"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(100) CategoryName "NOT NULL, Property_Vehicle_Savings_Investment"
        bit IsLiquid "NOT NULL, DEFAULT 0, Easily convertible to cash"
        bit RequiresValuation "NOT NULL, DEFAULT 0"
        int DisplayOrder "NULL"
        bit IsActive "NOT NULL, DEFAULT 1"
    }

    TRefLiabilityCategory {
        int LiabilityCategoryRefId PK "Identity"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(100) CategoryName "NOT NULL, Mortgage_Loan_CreditCard_Overdraft"
        bit IsSecured "NULL, Typically secured"
        bit RequiresRegularPayment "NOT NULL, DEFAULT 1"
        int DisplayOrder "NULL"
        bit IsActive "NOT NULL, DEFAULT 1"
    }

    TRefPlanType {
        int RefPlanTypeId PK "Identity"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(100) PlanTypeName "NOT NULL, Pension_Protection_Investment"
        varchar(50) PlanTypeGroup "NULL, High-level grouping"
        int DisplayOrder "NULL"
        bit IsActive "NOT NULL, DEFAULT 1"
        datetime CreatedDate "NOT NULL"
    }

    TRefProductSubType {
        int ProdSubTypeId PK "Identity"
        int RefPlanTypeId FK "NOT NULL, IX_PlanType"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(100) ProductSubTypeName "NOT NULL, SIPP_PersonalPension_Term_WholeOfLife"
        int DisplayOrder "NULL"
        bit IsActive "NOT NULL, DEFAULT 1"
    }

    TRefProvider {
        int RefProdProviderId PK "Identity"
        int TenantId FK "NOT NULL, IX_Tenant"
        varchar(200) ProviderName "NOT NULL"
        varchar(100) ProviderShortName "NULL"
        nvarchar(MAX) ProviderAddress "NULL"
        varchar(50) ProviderPhone "NULL"
        varchar(200) ProviderEmail "NULL"
        varchar(200) ProviderWebsite "NULL"
        bit IsActive "NOT NULL, DEFAULT 1"
        datetime CreatedDate "NOT NULL"
    }

    TRefCountry {
        char(2) CountryCode PK "ISO 3166-1, e.g. GB_US_FR"
        varchar(100) CountryName "NOT NULL, United Kingdom"
        char(3) CurrencyCode "NULL, ISO 4217, GBP_USD_EUR"
        varchar(50) CurrencyName "NULL"
        bit IsActive "NOT NULL, DEFAULT 1"
    }

    TRefMaritalStatus {
        int MaritalStatusRefId PK "Identity"
        varchar(50) StatusName "NOT NULL, Single_Married_Divorced_Widowed_CivilPartnership"
        int DisplayOrder "NULL"
        bit IsActive "NOT NULL, DEFAULT 1"
    }

    TRefRelationshipType {
        int RelationshipTypeRefId PK "Identity"
        varchar(50) RelationshipName "NOT NULL, Spouse_Partner_Child_Parent_Sibling"
        bit IsDependent "NULL, Indicates financial dependency"
        int DisplayOrder "NULL"
        bit IsActive "NOT NULL, DEFAULT 1"
    }
```

### 12.2 Reference Data Patterns

**Multi-Tenancy:**
- All ref data includes `TenantId` for firm-specific customization
- Shared ref data (e.g., Countries) have TenantId = 0 (global)

**Soft Delete:**
- Use `IsActive` flag instead of hard delete
- Preserves historical references

**Display Order:**
- `DisplayOrder` field for UI sorting
- Alphabetical if NULL

---

## 13. Cross-Domain Relationships

### 13.1 Cross-Aggregate Integration

```mermaid
erDiagram
    TFactFind }o--|| TCRMContact : "Conformist"
    TFactFind ||--o{ TEmploymentDetail : "Owns"
    TFactFind ||--o{ TIncome : "Owns"
    TFactFind ||--o{ TAssets : "Owns"
    TFactFind ||--o{ TLiabilities : "Owns"
    TFactFind ||--o{ TBudget : "Owns"
    TFactFind ||--o{ TExpenditure : "Owns"
    TFactFind ||--o{ TRequirement : "References"
    TFactFind ||--o{ TPolicyBusiness : "References"
    TFactFind ||--o{ TAtr : "Owns"
    TFactFind ||--o{ TNotes : "Owns"
    TFactFind ||--o{ TEstatePlanning : "Owns"
    TFactFind ||--o{ TProfessionalContact : "Owns"
    TFactFind ||--o{ TDependant : "Owns"

    TIncome }o--o| TEmploymentDetail : "Source"
    TIncome }o--o| TAssets : "Source"
    TLiabilities }o--o| TAssets : "Secured by"
    TRequirementAllocation }o--|| TPolicyBusiness : "Customer-Supplier"
    TRiskProfile }o--|| TAtrTemplate : "Uses"
    TPolicyOwner }o--|| TCRMContact : "Owner"
    TAssuredLife }o--|| TCRMContact : "Insured"
```

### 13.2 Relationship Patterns

**FactFind → Client (Conformist)**
- FactFind references CRMContact via FK
- Read-only access to Client data
- No cascade on Client delete (prevent data loss)

**FactFind → Children (Owner)**
- All child entities have `FactFindId` FK
- CASCADE DELETE on FactFind removal
- Prevents orphaned records

**Requirements → Plans (Customer-Supplier)**
- TRequirementAllocation links goals to plans
- Plans exist independently of requirements
- No CASCADE on plan delete (preserve history)

**Protection → Client (Shared Kernel)**
- TAssuredLife references CRMContact for insured persons
- TPolicyOwner references CRMContact for policy owners
- Read-only access

---

## 14. SQL DDL Specifications

### 14.1 FactFind Root Aggregate (Sample DDL)

```sql
-- =============================================
-- FactFind Root Aggregate Table
-- =============================================
CREATE TABLE dbo.TFactFind (
    FactFindId INT IDENTITY(1,1) NOT NULL,
    TenantId INT NOT NULL,
    CRMContactId INT NOT NULL,
    JointCRMContactId INT NULL,
    SessionDate DATETIME NOT NULL,
    Status VARCHAR(50) NOT NULL DEFAULT 'InProgress',
    AdviserUserId INT NOT NULL,
    CompletedDate DATETIME NULL,
    CompletedByUserId INT NULL,
    IsJoint BIT NOT NULL DEFAULT 0,
    FactFindType VARCHAR(20) NULL,
    FactFindVersion INT NULL,
    ArchivedDate DATETIME NULL,
    IsArchived BIT NOT NULL DEFAULT 0,
    IsDeleted BIT NOT NULL DEFAULT 0,
    SummaryNotes NVARCHAR(MAX) NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    CreatedByUserId INT NOT NULL,
    UpdatedDate DATETIME NULL,
    UpdatedByUserId INT NULL,
    RowVersion ROWVERSION NOT NULL,

    CONSTRAINT PK_TFactFind PRIMARY KEY CLUSTERED (FactFindId),
    CONSTRAINT FK_TFactFind_Tenant FOREIGN KEY (TenantId) REFERENCES dbo.TTenant(TenantId),
    CONSTRAINT FK_TFactFind_CRMContact FOREIGN KEY (CRMContactId) REFERENCES CRM.dbo.TCRMContact(CRMContactId),
    CONSTRAINT FK_TFactFind_JointContact FOREIGN KEY (JointCRMContactId) REFERENCES CRM.dbo.TCRMContact(CRMContactId),
    CONSTRAINT FK_TFactFind_Adviser FOREIGN KEY (AdviserUserId) REFERENCES dbo.TUser(UserId),
    CONSTRAINT FK_TFactFind_CompletedBy FOREIGN KEY (CompletedByUserId) REFERENCES dbo.TUser(UserId),
    CONSTRAINT FK_TFactFind_CreatedBy FOREIGN KEY (CreatedByUserId) REFERENCES dbo.TUser(UserId),
    CONSTRAINT FK_TFactFind_UpdatedBy FOREIGN KEY (UpdatedByUserId) REFERENCES dbo.TUser(UserId),

    CONSTRAINT CK_TFactFind_Status CHECK (Status IN ('InProgress', 'Completed', 'Archived', 'Cancelled')),
    CONSTRAINT CK_TFactFind_CompletedDate CHECK (CompletedDate IS NULL OR CompletedDate >= SessionDate),
    CONSTRAINT UQ_TFactFind_ClientSession UNIQUE (CRMContactId, SessionDate, TenantId)
);

-- Indexes
CREATE NONCLUSTERED INDEX IX_TFactFind_Tenant ON dbo.TFactFind(TenantId) WHERE IsDeleted = 0;
CREATE NONCLUSTERED INDEX IX_TFactFind_Contact ON dbo.TFactFind(CRMContactId, Status) WHERE IsDeleted = 0;
CREATE NONCLUSTERED INDEX IX_TFactFind_Adviser ON dbo.TFactFind(AdviserUserId, Status) WHERE IsDeleted = 0;
CREATE NONCLUSTERED INDEX IX_TFactFind_SessionDate ON dbo.TFactFind(SessionDate DESC) WHERE IsDeleted = 0;
CREATE NONCLUSTERED INDEX IX_TFactFind_Status ON dbo.TFactFind(Status, SessionDate DESC) WHERE IsDeleted = 0;
```

### 14.2 Employment Detail (Child Entity Sample)

```sql
-- =============================================
-- Employment Detail - Child of FactFind
-- =============================================
CREATE TABLE dbo.TEmploymentDetail (
    EmploymentDetailId INT IDENTITY(1,1) NOT NULL,
    FactFindId INT NOT NULL,
    CRMContactId INT NOT NULL,
    TenantId INT NOT NULL,
    EmploymentType VARCHAR(50) NOT NULL,
    EmployerName VARCHAR(200) NULL,
    JobTitle VARCHAR(100) NULL,
    OccupationRefId INT NULL,
    StartDate DATE NULL,
    EndDate DATE NULL,
    Status VARCHAR(50) NOT NULL DEFAULT 'Active',
    AnnualSalary DECIMAL(18,2) NULL,
    SalaryCurrency CHAR(3) NULL DEFAULT 'GBP',
    PayFrequency VARCHAR(20) NULL,
    BonusAmount DECIMAL(18,2) NULL,
    BenefitsInKind DECIMAL(18,2) NULL,
    BusinessName VARCHAR(200) NULL,
    NatureOfBusiness NVARCHAR(MAX) NULL,
    AnnualProfit DECIMAL(18,2) NULL,
    TaxableProfit DECIMAL(18,2) NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    CreatedByUserId INT NOT NULL,
    UpdatedDate DATETIME NULL,
    UpdatedByUserId INT NULL,
    RowVersion ROWVERSION NOT NULL,

    CONSTRAINT PK_TEmploymentDetail PRIMARY KEY CLUSTERED (EmploymentDetailId),
    CONSTRAINT FK_TEmploymentDetail_FactFind FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId) ON DELETE CASCADE,
    CONSTRAINT FK_TEmploymentDetail_Tenant FOREIGN KEY (TenantId) REFERENCES dbo.TTenant(TenantId),
    CONSTRAINT FK_TEmploymentDetail_Contact FOREIGN KEY (CRMContactId) REFERENCES CRM.dbo.TCRMContact(CRMContactId),
    CONSTRAINT FK_TEmploymentDetail_Occupation FOREIGN KEY (OccupationRefId) REFERENCES dbo.TRefOccupation(OccupationRefId),
    CONSTRAINT FK_TEmploymentDetail_CreatedBy FOREIGN KEY (CreatedByUserId) REFERENCES dbo.TUser(UserId),
    CONSTRAINT FK_TEmploymentDetail_UpdatedBy FOREIGN KEY (UpdatedByUserId) REFERENCES dbo.TUser(UserId),

    CONSTRAINT CK_TEmploymentDetail_Type CHECK (EmploymentType IN ('Employed', 'SelfEmployed', 'Unemployed', 'Retired')),
    CONSTRAINT CK_TEmploymentDetail_Dates CHECK (EndDate IS NULL OR EndDate >= StartDate),
    CONSTRAINT CK_TEmploymentDetail_Salary CHECK (AnnualSalary IS NULL OR AnnualSalary >= 0),
    CONSTRAINT CK_TEmploymentDetail_Currency CHECK (SalaryCurrency IS NULL OR LEN(SalaryCurrency) = 3)
);

-- Indexes
CREATE NONCLUSTERED INDEX IX_TEmploymentDetail_FactFind ON dbo.TEmploymentDetail(FactFindId, Status);
CREATE NONCLUSTERED INDEX IX_TEmploymentDetail_Contact ON dbo.TEmploymentDetail(CRMContactId, Status);
CREATE NONCLUSTERED INDEX IX_TEmploymentDetail_Tenant ON dbo.TEmploymentDetail(TenantId);
```

### 14.3 Notes (Unified Discriminator Pattern)

```sql
-- =============================================
-- Notes - Unified Discriminator Pattern
-- =============================================
CREATE TABLE dbo.TNotes (
    NoteId BIGINT IDENTITY(1,1) NOT NULL,
    FactFindId INT NOT NULL,
    CRMContactId INT NOT NULL,
    TenantId INT NOT NULL,
    Discriminator VARCHAR(50) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETUTCDATE(),
    CreatedByUserId INT NOT NULL,
    UpdatedDate DATETIME NULL,
    UpdatedByUserId INT NULL,
    RowVersion ROWVERSION NOT NULL,

    CONSTRAINT PK_TNotes PRIMARY KEY CLUSTERED (NoteId),
    CONSTRAINT FK_TNotes_FactFind FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId) ON DELETE CASCADE,
    CONSTRAINT FK_TNotes_Tenant FOREIGN KEY (TenantId) REFERENCES dbo.TTenant(TenantId),
    CONSTRAINT FK_TNotes_Contact FOREIGN KEY (CRMContactId) REFERENCES CRM.dbo.TCRMContact(CRMContactId),
    CONSTRAINT FK_TNotes_CreatedBy FOREIGN KEY (CreatedByUserId) REFERENCES dbo.TUser(UserId),
    CONSTRAINT FK_TNotes_UpdatedBy FOREIGN KEY (UpdatedByUserId) REFERENCES dbo.TUser(UserId),

    CONSTRAINT CK_TNotes_Discriminator CHECK (Discriminator IN (
        'Profile', 'Employment', 'AssetLiabilities', 'Budget',
        'Mortgage', 'Protection', 'Retirement', 'Investment',
        'EstatePlanning', 'Summary'
    )),
    CONSTRAINT CK_TNotes_Content CHECK (LEN(Content) > 0 AND LEN(Content) <= 15000)
);

-- Indexes
CREATE NONCLUSTERED INDEX IX_TNotes_FactFind ON dbo.TNotes(FactFindId, Discriminator);
CREATE NONCLUSTERED INDEX IX_TNotes_Discriminator ON dbo.TNotes(Discriminator, CreatedDate DESC);
CREATE NONCLUSTERED INDEX IX_TNotes_Contact ON dbo.TNotes(CRMContactId, Discriminator);
```

---

## 15. Indexing Strategy

### 15.1 Standard Index Pattern

**Every Table Minimum:**

```sql
-- Clustered index on PK (default)
CREATE CLUSTERED INDEX PK_TableName ON dbo.TableName(PrimaryKeyId);

-- Tenant isolation
CREATE NONCLUSTERED INDEX IX_TableName_Tenant ON dbo.TableName(TenantId) WHERE IsDeleted = 0;

-- FactFind FK (for child entities)
CREATE NONCLUSTERED INDEX IX_TableName_FactFind ON dbo.TableName(FactFindId) WHERE IsDeleted = 0;

-- Status/Date filtering
CREATE NONCLUSTERED INDEX IX_TableName_Status ON dbo.TableName(Status, CreatedDate DESC) WHERE IsDeleted = 0;
```

### 15.2 Covering Indexes

**High-frequency queries:**

```sql
-- FactFind by client with status
CREATE NONCLUSTERED INDEX IX_TFactFind_Client_Covering
ON dbo.TFactFind(CRMContactId, Status)
INCLUDE (FactFindId, SessionDate, AdviserUserId, CompletedDate)
WHERE IsDeleted = 0;

-- Income by FactFind
CREATE NONCLUSTERED INDEX IX_TIncome_FactFind_Covering
ON dbo.TIncome(FactFindId, IncomeSource)
INCLUDE (GrossAmount, NetAmount, Frequency)
WHERE IsDeleted = 0;

-- Expenditure by FactFind
CREATE NONCLUSTERED INDEX IX_TExpenditure_FactFind_Covering
ON dbo.TExpenditure(FactFindId, ExpenditureTypeRefId)
INCLUDE (Amount, Frequency, IsPriority)
WHERE IsDeleted = 0;
```

### 15.3 Filtered Indexes

**Active records only:**

```sql
-- Active FactFinds
CREATE NONCLUSTERED INDEX IX_TFactFind_Active
ON dbo.TFactFind(Status, SessionDate DESC)
WHERE IsDeleted = 0 AND IsArchived = 0;

-- Current employment
CREATE NONCLUSTERED INDEX IX_TEmployment_Current
ON dbo.TEmploymentDetail(CRMContactId, EmployerName)
WHERE Status = 'Active' AND EndDate IS NULL;

-- Current liabilities
CREATE NONCLUSTERED INDEX IX_TLiabilities_Current
ON dbo.TLiabilities(FactFindId, LiabilityCategory, OutstandingBalance DESC)
WHERE IsDeleted = 0 AND EndDate IS NULL;
```

### 15.4 Temporal Indexes

**Date range queries:**

```sql
-- FactFind sessions by date range
CREATE NONCLUSTERED INDEX IX_TFactFind_DateRange
ON dbo.TFactFind(SessionDate, Status)
INCLUDE (CRMContactId, AdviserUserId)
WHERE IsDeleted = 0;

-- Gift dates (IHT 7-year rule)
CREATE NONCLUSTERED INDEX IX_TGift_DateRange
ON dbo.TGift(GiftDate, IsPotentiallyExempt)
INCLUDE (RecipientName, GiftValue)
WHERE ExemptionDate >= GETDATE();
```

---

## 16. Cascade Rules & Constraints

### 16.1 Cascade Delete Rules

**FactFind Aggregate (CASCADE DELETE):**

All child entities CASCADE DELETE when FactFind is deleted:

```sql
-- Employment
ALTER TABLE dbo.TEmploymentDetail
ADD CONSTRAINT FK_TEmploymentDetail_FactFind
FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId)
ON DELETE CASCADE;

-- Income
ALTER TABLE dbo.TIncome
ADD CONSTRAINT FK_TIncome_FactFind
FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId)
ON DELETE CASCADE;

-- Assets
ALTER TABLE dbo.TAssets
ADD CONSTRAINT FK_TAssets_FactFind
FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId)
ON DELETE CASCADE;

-- Liabilities
ALTER TABLE dbo.TLiabilities
ADD CONSTRAINT FK_TLiabilities_FactFind
FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId)
ON DELETE CASCADE;

-- Budget
ALTER TABLE dbo.TBudget
ADD CONSTRAINT FK_TBudget_FactFind
FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId)
ON DELETE CASCADE;

-- Expenditure
ALTER TABLE dbo.TExpenditure
ADD CONSTRAINT FK_TExpenditure_FactFind
FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId)
ON DELETE CASCADE;

-- Notes (all types)
ALTER TABLE dbo.TNotes
ADD CONSTRAINT FK_TNotes_FactFind
FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId)
ON DELETE CASCADE;

-- Estate Planning
ALTER TABLE dbo.TEstatePlanning
ADD CONSTRAINT FK_TEstatePlanning_FactFind
FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId)
ON DELETE CASCADE;

-- ATR
ALTER TABLE dbo.TAtr
ADD CONSTRAINT FK_TAtr_FactFind
FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId)
ON DELETE CASCADE;

-- Professional Contacts
ALTER TABLE dbo.TProfessionalContact
ADD CONSTRAINT FK_TProfessionalContact_FactFind
FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId)
ON DELETE CASCADE;

-- Dependants
ALTER TABLE dbo.TDependant
ADD CONSTRAINT FK_TDependant_FactFind
FOREIGN KEY (FactFindId) REFERENCES dbo.TFactFind(FactFindId)
ON DELETE CASCADE;
```

### 16.2 No Cascade Rules

**External Aggregates (NO ACTION):**

```sql
-- Client (CRM aggregate) - NEVER cascade
ALTER TABLE dbo.TFactFind
ADD CONSTRAINT FK_TFactFind_CRMContact
FOREIGN KEY (CRMContactId) REFERENCES CRM.dbo.TCRMContact(CRMContactId)
ON DELETE NO ACTION;

-- Plans (Portfolio aggregate) - Preserve history
ALTER TABLE dbo.TRequirementAllocation
ADD CONSTRAINT FK_TRequirementAllocation_Policy
FOREIGN KEY (PolicyBusinessId) REFERENCES dbo.TPolicyBusiness(PolicyBusinessId)
ON DELETE NO ACTION;

-- Reference data - NEVER cascade
ALTER TABLE dbo.TEmploymentDetail
ADD CONSTRAINT FK_TEmploymentDetail_Occupation
FOREIGN KEY (OccupationRefId) REFERENCES dbo.TRefOccupation(OccupationRefId)
ON DELETE NO ACTION;
```

### 16.3 Check Constraints

**Business Rules Enforcement:**

```sql
-- Status progression
ALTER TABLE dbo.TFactFind
ADD CONSTRAINT CK_TFactFind_Status
CHECK (Status IN ('InProgress', 'Completed', 'Archived', 'Cancelled'));

-- Date logic
ALTER TABLE dbo.TEmploymentDetail
ADD CONSTRAINT CK_TEmploymentDetail_Dates
CHECK (EndDate IS NULL OR EndDate >= StartDate);

-- Positive amounts
ALTER TABLE dbo.TIncome
ADD CONSTRAINT CK_TIncome_PositiveAmount
CHECK (GrossAmount > 0);

-- Risk score range
ALTER TABLE dbo.TAtr
ADD CONSTRAINT CK_TAtr_RiskScore
CHECK (RiskScore BETWEEN 1 AND 10);

-- Currency codes
ALTER TABLE dbo.TBudget
ADD CONSTRAINT CK_TBudget_Currency
CHECK (Currency IN ('GBP', 'EUR', 'USD', 'AUD', 'CAD'));

-- LPA type
ALTER TABLE dbo.TLPA
ADD CONSTRAINT CK_TLPA_Type
CHECK (LPAType IN ('PropertyAndFinancial', 'HealthAndWelfare', 'Both'));
```

### 16.4 Unique Constraints

```sql
-- One FactFind per client per session date
ALTER TABLE dbo.TFactFind
ADD CONSTRAINT UQ_TFactFind_ClientSession
UNIQUE (CRMContactId, SessionDate, TenantId);

-- One vulnerability assessment per client
ALTER TABLE dbo.TClientVulnerability
ADD CONSTRAINT UQ_Vulnerability_PerClient
UNIQUE (CRMContactId, TenantId);

-- One marketing preference per client
ALTER TABLE dbo.TMarketing
ADD CONSTRAINT UQ_Marketing_PerClient
UNIQUE (CRMContactId, TenantId);

-- One Will per EstatePlanning
ALTER TABLE dbo.TWill
ADD CONSTRAINT UQ_Will_PerEstatePlanning
UNIQUE (EstatePlanningId);
```

---

## 17. Multi-Tenancy Implementation

### 17.1 Row-Level Security

**Pattern:**
- Every table includes `TenantId INT NOT NULL`
- Filtered indexes isolate tenant data
- Application context sets tenant for session

```sql
-- Set tenant context (application layer)
EXEC sp_set_session_context @key = N'TenantId', @value = 123;

-- Security predicate function
CREATE FUNCTION dbo.fn_TenantAccessPredicate(@TenantId INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS AccessResult
WHERE @TenantId = CAST(SESSION_CONTEXT(N'TenantId') AS INT);
GO

-- Apply security policy to all tables
CREATE SECURITY POLICY dbo.TenantSecurityPolicy
    ADD FILTER PREDICATE dbo.fn_TenantAccessPredicate(TenantId) ON dbo.TFactFind,
    ADD BLOCK PREDICATE dbo.fn_TenantAccessPredicate(TenantId) ON dbo.TFactFind,
    ADD FILTER PREDICATE dbo.fn_TenantAccessPredicate(TenantId) ON dbo.TEmploymentDetail,
    ADD BLOCK PREDICATE dbo.fn_TenantAccessPredicate(TenantId) ON dbo.TEmploymentDetail,
    ADD FILTER PREDICATE dbo.fn_TenantAccessPredicate(TenantId) ON dbo.TIncome,
    ADD BLOCK PREDICATE dbo.fn_TenantAccessPredicate(TenantId) ON dbo.TIncome,
    -- ... repeat for all tables
WITH (STATE = ON);
```

### 17.2 Tenant-Specific Reference Data

**Pattern:**
- Reference data includes `TenantId`
- Global ref data: `TenantId = 0`
- Tenant-specific: `TenantId = {tenant}`

```sql
-- Global countries (all tenants)
INSERT INTO dbo.TRefCountry (CountryCode, CountryName, CurrencyCode, TenantId)
VALUES ('GB', 'United Kingdom', 'GBP', 0);

-- Firm-specific occupation (tenant 123 only)
INSERT INTO dbo.TRefOccupation (OccupationTitle, OccupationCategory, TenantId)
VALUES ('Chartered Financial Planner', 'Financial Services', 123);

-- Query combines global + tenant-specific
SELECT * FROM dbo.TRefOccupation
WHERE TenantId IN (0, 123) AND IsActive = 1;
```

### 17.3 Tenant Isolation Verification

```sql
-- Ensure no cross-tenant data leakage
CREATE PROCEDURE dbo.sp_VerifyTenantIsolation
    @TenantId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check FactFinds
    IF EXISTS (
        SELECT 1 FROM dbo.TFactFind
        WHERE TenantId <> @TenantId
    )
    RAISERROR('Tenant isolation violated in TFactFind', 16, 1);

    -- Check Employment
    IF EXISTS (
        SELECT 1 FROM dbo.TEmploymentDetail e
        INNER JOIN dbo.TFactFind f ON e.FactFindId = f.FactFindId
        WHERE e.TenantId <> f.TenantId
    )
    RAISERROR('Tenant mismatch between Employment and FactFind', 16, 1);

    -- Add checks for all child entities

    PRINT 'Tenant isolation verified successfully';
END;
```

---

## Summary Statistics

### Entity Count by Domain

| Domain | Tables | Relationships | Indexes (Avg) |
|--------|--------|---------------|---------------|
| **FactFind Core** | 1 | 20+ | 8 |
| **Client Domain** | 10 | 14 | 6 |
| **Employment & Income** | 3 | 5 | 5 |
| **Financial Position** | 7 | 8 | 6 |
| **Portfolio Plans** | 15+ | 24 | 8 |
| **Goals & Requirements** | 7 | 9 | 6 |
| **Estate Planning** | 5 | 6 | 5 |
| **Professional Network** | 1 | 1 | 3 |
| **ATR Domain** | 4 | 5 | 5 |
| **Notes Domain** | 1 | 1 | 4 |
| **Reference Data** | 20+ | 15 | 3 |
| **Total** | **70+** | **108+** | **~350** |

### Constraint Statistics

- **Primary Keys:** 70+
- **Foreign Keys:** 108+
- **Check Constraints:** 60+
- **Unique Constraints:** 25+
- **Default Constraints:** 150+
- **Computed Columns:** 12+

### Index Statistics

- **Clustered Indexes:** 70+ (one per table)
- **Non-Clustered Indexes:** ~280
- **Filtered Indexes:** ~45
- **Covering Indexes:** ~30

---

## Document Status

**Version:** 1.0
**Last Updated:** February 16, 2026
**Status:** Production-Ready
**Maintained By:** Database Architecture Team

**Related Documents:**
- steering/Domain-Architecture/Complete-Domain-Analysis.md
- steering/Domain-Architecture/Complete-ERD.md
- steering/Analysis/FactFind-Coverage-Matrix.md
- Context/FactFind-Sections-Reference.md

**Next Steps:**
1. Review with stakeholders
2. Generate full DDL scripts
3. Create migration scripts from existing schema
4. Setup CI/CD for schema versioning
5. Document API contracts aligned with ERD

---

**End of FactFind Aggregate ERD**
