# Employment CRUD API - Analysis & Specification Document

**Document Version**: 2.0 (Revised)
**Date**: January 27, 2026
**Status**: Draft for Review

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Current State Analysis](#current-state-analysis)
3. [Database Schema Analysis](#database-schema-analysis)
4. [Requirements Analysis (Excel-Driven)](#requirements-analysis-excel-driven)
5. [Gap Analysis](#gap-analysis)
6. [Proposed API Contract Extensions](#proposed-api-contract-extensions)
7. [Database Modifications](#database-modifications)
8. [Income Data - Reference to Separate API](#income-data-reference-to-separate-api)
9. [Migration Strategy](#migration-strategy)
10. [Implementation Plan](#implementation-plan)

---

## 1. Executive Summary

### Objective
Extend the existing Employment CRUD API (`v2/clients/{id}/employments`) to support additional employment data points identified as gaps in the Fact Find Data Analysis v6.0 Excel document.

### Scope
This analysis focuses **only on gaps explicitly identified in the Excel requirements document** where:
- API Name is marked as `[N/A]` or `[Unknown]`
- Fields are documented as needed but not currently available in the Employment API

### Key Findings
- **Current v2 API Coverage**: 29 properties exposed (including address sub-object)
- **Excel-Identified Gaps**: 22 fields missing from Employment API
  - 4 classification fields (Employment Type, Occupation Type, etc.)
  - 16 self-employed accounts fields (3 years of financial data)
  - 2 pension-related fields (recommendation: move to Pension API scope)
- **Income Data**: Separate concern - should be managed via Income API using `TIncome` and `TDetailedincomebreakdown` tables
- **Database Changes Required**: 15 new columns for self-employed accounts and classification fields

### Key Principle
**This document does NOT propose exposing every column in `TEmploymentDetail` table.** It focuses only on validated requirements from the Excel analysis that represent actual business needs.

---

## 2. Current State Analysis

### 2.1 Existing v2 API Contract

**Endpoint**: `v2/clients/{clientId}/employments`

**Current EmploymentDocument Properties** (29 total, counting nested):
```json
{
  "id": 0,
  "href": "string",
  "startsOn": "date",
  "endsOn": "date",
  "occupation": "string",
  "intendedRetirementAge": 0,
  "employer": "string",
  "address": {
    "line1": "string",
    "line2": "string",
    "line3": "string",
    "line4": "string",
    "locality": "string",
    "postalCode": "string",
    "country": {
      "isoCode": "string",
      "name": "string"
    },
    "county": {
      "code": "string",
      "name": "string"
    }
  },
  "employmentBusinessType": "enum",
  "inProbation": true,
  "probationPeriodInMonths": 0,
  "client": {
    "id": 0,
    "href": "string"
  },
  "incomesHref": "string",
  "industryType": "string",
  "employmentStatusDescription": "string",
  "employmentStatus": "enum"
}
```

**Supported Operations**:
- GET `/v2/clients/{clientId}/employments/{employmentId}` - Retrieve single employment
- GET `/v2/clients/{clientId}/employments` - List employments with filtering
- POST `/v2/clients/{clientId}/employments` - Create employment
- PUT `/v2/clients/{clientId}/employments/{employmentId}` - Update employment
- DELETE `/v2/clients/{clientId}/employments/{employmentId}` - Delete employment

**Employment Status Enum** (14 values):
Unknown, SelfEmployed, CompanyDirector, Retired, Unemployed, Houseperson, Student, MaternityLeave, LongTermIllness, ContractWorker, Employed, CarerOfaChildUnder16, CarerOfaPersonOver16, Other

**Employment Business Type Enum** (4 values):
SoleTrader, PrivateLimitedCompany, Partnership, LimitedLiabilityPartnership

### 2.2 Implementation Architecture

**Controller**: `Monolith.FactFind.v2.Controllers.EmploymentController`
- Authorization: `CustomPolicyNames.ClientFinancialDataOrFactFind`
- Scope: `Scopes.ClientFinancialData`
- Exception Handling: BusinessException, ValidationException → 400, ResourceNotFoundException → 404

**Resource Layer**: `IEmploymentResource`
- Business logic and data transformation
- Filtering support: `id in (...)` syntax
- Pagination: default top=100, max=500

**Domain Entity**: `IntelliFlo.IO.Core.Domain.FactFind.EmploymentDetail`
- Maps to `TEmploymentDetail` table (80 columns)
- Uses NHibernate ORM

---

## 3. Database Schema Analysis

### 3.1 TEmploymentDetail Table - Current State

**Source**: `Context\schema\factfind\Tables\dbo.TEmploymentDetail.sql`

**Primary Key**: `EmploymentDetailId` (int, identity)
**Foreign Keys**:
- `CRMContactId` (int, NOT NULL) - Links to client/contact
- `RefOccupationId` (int, NULL) - Occupation reference
- `RefCountryId` (int, NULL) - Employer country
- `RefCountyId` (int, NULL) - Employer county/state

**Total Columns**: 80

**Relevant Existing Columns** (currently exposed in API):
- EmploymentStatus, EmploymentStatusDescription
- EmploymentBusinessType, Role (Occupation), Employer
- EmployerAddressLine1-4, EmployerCityTown, RefCountryId, RefCountyId, EmployerPostcode
- StartDate, EndDate
- IntendedRetirementAge
- InProbation, ProbationPeriodMonths
- IndustryType
- ConcurrencyId

**Relevant Existing Columns** (NOT currently in API, but exist for self-employed accounts):
- PreviousFinancialYear, PreviousFinancialYearEndDate
- SecondPreviousFinancialYear, SecondPreviousFinancialYearEndDate
- ThirdPreviousFinancialYear, ThirdPreviousFinancialYearEndDate

**Note**: Database has 80 columns including many legacy and specialized fields (packaging details, change employment flags, old salary fields, etc.). This analysis does NOT propose exposing all of them - only those identified as gaps in the Excel requirements.

### 3.2 Related Tables

#### TEmploymentHistory
```sql
- EmploymentHistoryId (PK)
- CRMContactId
- Employer, StartDate, EndDate
- GrossAnnualEarnings
- IsCurrentEmployment
- EmploymentDetailId (FK)
```
Purpose: Past employment history tracking - **Out of scope for this analysis**

#### TIncome & TDetailedincomebreakdown
```sql
-- TIncome: Basic income record
- IncomeId (PK), CRMContactId
- IsChangeExpected, IsRiseExpected, ChangeAmount, ChangeReason

-- TDetailedincomebreakdown: Detailed income components
- DetailedincomebreakdownId (PK), CRMContactId
- Description, Amount, NetAmount
- IncomeType, Frequency, GrossOrNet
- EmploymentDetailIdValue (FK to TEmploymentDetail)
- HasIncludeInAffordability
- StartDate, EndDate
```
Purpose: Income tracking linked to employment - **Should be exposed via separate Income API**, not embedded in Employment entity

**Recommendation**: Employment API should link to Income API via `incomesHref` property (already exists) rather than duplicating income data in employment entity.

---

## 4. Requirements Analysis (Excel-Driven)

### 4.1 Source: Fact Find Data Analysis v6.0

**Analysis Method**: Extracted employment-related fields from "Fact Finds" sheet (Rows 299-375) where:
- Entity = "Employment"
- Area = "Employments"

**Total Fields Analyzed**: 55 fields across employment-related sub-areas

### 4.2 Field Categorization

#### Already Implemented in v2 API (29 fields)
Fields with `API Name: Employments` and valid `API Property Name`:
- Owner (client)
- Employment Status
- Employment Status Description
- Occupation
- Employer Name
- Intended Retirement Age
- Start Date, End Date
- Address (Line 1-4, City, County, Country, PostCode)
- Business Type
- Industry Type
- In Probation
- Probation Period Months

**Status**: ✅ Complete - No action required

#### Gap Category 1: Employment Type Classifications (4 fields)
Excel indicates `API Name: [N/A]` - not currently available:

| Field | Excel Notes | Target Enum Values |
|-------|-------------|-------------------|
| **Employment Type** | Vision/Multiply: describes type of employment | Employed, Self-Employed, Sole Trader, Limited Company, Limited Partnership, Company Director |
| **Occupation Type** | Vision: used for insurance/protection | Manual, Skilled, Professional, Civil Servant, Director, Business Partner |
| **Employed Type** | Vision: full-time or part-time | Full Time, Part Time |
| **Employed Basis** | Vision: contract type | Agency, Contract, Permanent, Probationary, Temporary |

**Business Need**: Integration with Vision CFF/FFF and Multiply systems
**Database Status**: ❌ Columns do NOT exist - need to add
**Priority**: MEDIUM

#### Gap Category 2: Self-Employed Financial Accounts (16 fields)
Excel indicates `API Name: [Unknown]` - marked as missing:

**3 Years of Accounts** (Year 1 = Most Recent, Year 2, Year 3):
- Gross Profit
- Share of Company Profit (PLC only)
- Gross Salary (PLC directors)
- Gross Dividend
- Year End Date
- Include in Affordability (flag)

**Business Need**: Mortgage affordability assessment for self-employed/company directors
**Database Status**:
- ✅ GrossProfit columns exist (PreviousFinancialYear, Second, Third)
- ✅ Year End Date columns exist
- ❌ Share of Company Profit columns do NOT exist
- ❌ Gross Salary columns do NOT exist
- ❌ Gross Dividend columns do NOT exist
- ❌ Include in Affordability flags do NOT exist

**Priority**: HIGH (critical for mortgage applications)

#### Gap Category 3: Is Current Employment (1 field)
Excel indicates `API Property Name: "Derived from employments start and enddates?"`

**Current State**: Not explicitly exposed as a settable field
**Requirement**: Explicit boolean flag (PFP feature)
**Business Need**: User experience - explicit flag when dates are missing/unclear
**Database Status**: ❌ Column does NOT exist as explicit field
**Priority**: LOW (can be derived, but explicit flag improves UX)

#### Out of Scope: Pension Fields (2 fields)
- Is Member of Pension Scheme
- Has Pension Scheme

**Excel Note**: "Recorded under Pension Eligibility in Full FF"
**Recommendation**: These belong in **Pension API scope**, not Employment API

#### Out of Scope: Protection Fields (3 fields)
- Has Income Protection
- Income Protection For Weeks
- Income Protection Salary Percentage

**Excel Note**: "Recorded under Protection Plans in Full FF"
**Recommendation**: These belong in **Plans/Protection API scope**, not Employment API. Can be queried via Plans API filtered by employment.

#### Out of Scope: Calculated Field
- **Total Continuous Employment Months**: Can be calculated on-the-fly from StartsOn/EndsOn dates. May be exposed as readonly calculated property.

---

## 5. Gap Analysis

### 5.1 Summary of True Gaps

| Category | Fields | In API | In DB | New DB Columns | Priority |
|----------|--------|--------|-------|----------------|----------|
| Employment Classifications | 4 | ❌ | ❌ | 4 | MEDIUM |
| Self-Employed Accounts | 16 | ❌ | Partial | 10 | HIGH |
| Is Current Employment | 1 | ❌ | ❌ | 1 | LOW |
| **TOTAL** | **21** | **0** | **6** | **15** | - |

### 5.2 Detailed Gap Analysis

#### Gap 1: Employment Type Classifications
**Impact**: Cannot integrate with Vision/Multiply systems that use different employment type taxonomies
**Complexity**: LOW - simple enum additions
**Breaking Change**: NO - new optional fields

**Required API Properties**:
```csharp
public EmploymentTypeValue? EmploymentType { get; set; }
public OccupationTypeValue? OccupationType { get; set; }
public EmployedTypeValue? EmployedType { get; set; }
public EmployedBasisValue? EmployedBasis { get; set; }
```

**Database Changes**:
```sql
ALTER TABLE [dbo].[TEmploymentDetail]
ADD
    [EmploymentType] [varchar](50) NULL,
    [OccupationType] [varchar](50) NULL,
    [EmployedType] [varchar](20) NULL,
    [EmployedBasis] [varchar](50) NULL;
```

#### Gap 2: Self-Employed Financial Accounts
**Impact**: Cannot capture self-employed income for mortgage affordability calculations
**Complexity**: MEDIUM - requires structured data for 3 years
**Breaking Change**: NO - new optional nested object

**Required API Structure**:
```csharp
public SelfEmployedAccountsValue[] SelfEmployedAccounts { get; set; }

public class SelfEmployedAccountsValue
{
    public int YearNumber { get; set; }  // 1, 2, or 3
    public DateTime? YearEndDate { get; set; }
    public decimal? GrossProfit { get; set; }
    public decimal? ShareOfCompanyProfit { get; set; }
    public decimal? GrossSalary { get; set; }
    public decimal? GrossDividend { get; set; }
    public bool? IncludeInAffordability { get; set; }
}
```

**Database Changes** (10 new columns):
```sql
ALTER TABLE [dbo].[TEmploymentDetail]
ADD
    -- Year 1 (Most Recent)
    [PreviousShareOfCompanyProfit] [money] NULL,
    [PreviousGrossSalary] [money] NULL,
    [PreviousGrossDividend] [money] NULL,
    [PreviousIncludeInAffordability] [bit] NULL,

    -- Year 2
    [SecondPreviousShareOfCompanyProfit] [money] NULL,
    [SecondPreviousGrossSalary] [money] NULL,
    [SecondPreviousGrossDividend] [money] NULL,

    -- Year 3
    [ThirdPreviousShareOfCompanyProfit] [money] NULL,
    [ThirdPreviousGrossSalary] [money] NULL,
    [ThirdPreviousGrossDividend] [money] NULL;
```

**Note**: GrossProfit columns already exist (PreviousFinancialYear, Second, Third). Year End Date columns already exist.

#### Gap 3: Is Current Employment
**Impact**: Must derive from dates, cannot explicitly set flag
**Complexity**: LOW - simple boolean
**Breaking Change**: NO - optional field

**Required API Property**:
```csharp
public bool? IsCurrentEmployment { get; set; }
```

**Database Change**:
```sql
ALTER TABLE [dbo].[TEmploymentDetail]
ADD [IsCurrentEmployment] [bit] NULL;
```

**Business Rule**: Auto-populate from dates if not explicitly provided:
```
IsCurrentEmployment = (EndDate IS NULL OR EndDate > GETDATE())
```

### 5.3 What is NOT Included in This Analysis

**Explicitly Excluded** (not identified as gaps in Excel):
1. **Income Breakdown Fields** (BasicAnnualIncome, GuaranteedOvertime, Bonus, etc.)
   - These exist in `TEmploymentDetail` table (80 columns)
   - Excel does NOT identify them as missing
   - Should be managed via **Income API** using `TDetailedincomebreakdown` table
   - Employment API links to Income via existing `incomesHref` property

2. **Mortgage Documentation Flags** (HasTaxReturns, HasStatementOfAccounts, etc.)
   - Exist in database but not flagged as gaps in Excel
   - Not included in this scope

3. **Legacy Income Fields** (Salary, BenefitsInKind, Commissions, Allowances, etc.)
   - Exist in database as legacy fields
   - Not identified as requirements in Excel
   - Superseded by Income API approach

4. **Employment History**
   - Separate table (`TEmploymentHistory`)
   - Separate API concern

5. **Employment Notes**
   - Separate table (`TEmploymentNote`)
   - Separate API concern

**Reason for Exclusion**: This analysis follows the principle of **implementing only validated requirements**. Just because a database column exists doesn't mean it should be exposed in the API. We implement what the business needs, as documented in the Excel requirements.

---

## 6. Proposed API Contract Extensions

### 6.1 Extended EmploymentDocument (v2.1)

```csharp
[SwaggerDefinition("Employment")]
public class EmploymentDocument : BaseEmploymentDocument
{
    // ===== EXISTING PROPERTIES (v2) - NO CHANGES =====

    public int Id { get; set; }

    [Href("v2/clients/{Client.Id}/employments/{Id}")]
    public string Href { get; set; }

    [ReadOnly(true)]
    public EmploymentStatusValue EmploymentStatus { get; set; }

    [JsonConverter(typeof(DateOnly))]
    public DateTime? StartsOn { get; set; }

    [JsonConverter(typeof(DateOnly))]
    public DateTime? EndsOn { get; set; }

    [MaxLength(512)]
    public string Occupation { get; set; }

    [Range(0, 99)]
    public int? IntendedRetirementAge { get; set; }

    [MaxLength(512)]
    public string Employer { get; set; }

    public EmploymentAddressValue Address { get; set; }

    [ValidEnumValues(typeof(EmploymentBusinessTypeValue))]
    public EmploymentBusinessTypeValue? EmploymentBusinessType { get; set; }

    public bool? InProbation { get; set; }

    [Range(1, 99)]
    public int? ProbationPeriodInMonths { get; set; }

    [ReadOnly(true)]
    public ClientReference Client { get; set; }

    [Href("v2/clients/{Client.Id}/incomes?filter=employment.id eq {Id}")]
    public string IncomesHref { get; set; }

    [MaxLength(100)]
    public string IndustryType { get; set; }

    [MaxLength(1000)]
    public string EmploymentStatusDescription { get; set; }


    // ===== NEW PROPERTIES (v2.1) =====

    /// <summary>
    /// Whether this is the current employment (true) or past employment (false).
    /// Auto-derived from dates if not explicitly set.
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [DefaultValue(null)]
    public bool? IsCurrentEmployment { get; set; }

    /// <summary>
    /// Employment Type classification.
    /// Used by Vision/Multiply integrations.
    /// Values: Employed, SelfEmployed, SoleTrader, LimitedCompany, LimitedPartnership, CompanyDirector, TwentyPercentDirector
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [ValidEnumValues(typeof(EmploymentTypeValue))]
    [DefaultValue(null)]
    public EmploymentTypeValue? EmploymentType { get; set; }

    /// <summary>
    /// Occupation Type classification.
    /// Used for insurance/protection underwriting.
    /// Values: Manual, Skilled, Professional, CivilServant, Director, BusinessPartner
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [ValidEnumValues(typeof(OccupationTypeValue))]
    [DefaultValue(null)]
    public OccupationTypeValue? OccupationType { get; set; }

    /// <summary>
    /// Employment basis (for Employed status).
    /// Values: FullTime, PartTime
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [ValidEnumValues(typeof(EmployedTypeValue))]
    [DefaultValue(null)]
    public EmployedTypeValue? EmployedType { get; set; }

    /// <summary>
    /// Employment contract basis.
    /// Values: Agency, Contract, Permanent, Probationary, Temporary
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [ValidEnumValues(typeof(EmployedBasisValue))]
    [DefaultValue(null)]
    public EmployedBasisValue? EmployedBasis { get; set; }

    /// <summary>
    /// Continuous employment duration in months (calculated readonly).
    /// Calculated from StartsOn to EndsOn (or current date if no end date).
    /// </summary>
    [ReadOnly(true)]
    public int? ContinuousEmploymentMonths { get; set; }

    /// <summary>
    /// Self-employed financial accounts data (up to 3 years).
    /// Only applicable when EmploymentStatus = SelfEmployed, CompanyDirector
    /// or EmploymentBusinessType is set.
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [DefaultValue(null)]
    public SelfEmployedAccountsValue[] SelfEmployedAccounts { get; set; }
}
```

### 6.2 New Supporting Value Objects

#### SelfEmployedAccountsValue
```csharp
[SwaggerDefinition("SelfEmployedAccountsValue")]
public class SelfEmployedAccountsValue
{
    /// <summary>
    /// Account year number (1 = most recent, 2 = previous, 3 = two years prior).
    /// </summary>
    [Range(1, 3)]
    [Required]
    public int YearNumber { get; set; }

    /// <summary>
    /// Financial year end date.
    /// </summary>
    [JsonConverter(typeof(DateOnly))]
    public DateTime? YearEndDate { get; set; }

    /// <summary>
    /// Gross profit for sole trader/partnership.
    /// </summary>
    public decimal? GrossProfit { get; set; }

    /// <summary>
    /// Share of company profit (for PLC/Ltd companies).
    /// </summary>
    public decimal? ShareOfCompanyProfit { get; set; }

    /// <summary>
    /// Gross salary (for PLC/Ltd company directors).
    /// </summary>
    public decimal? GrossSalary { get; set; }

    /// <summary>
    /// Gross dividend (for PLC/Ltd shareholders).
    /// </summary>
    public decimal? GrossDividend { get; set; }

    /// <summary>
    /// Include this year in mortgage affordability calculation.
    /// </summary>
    public bool? IncludeInAffordability { get; set; }
}
```

#### New Enum Types

```csharp
public enum EmploymentTypeValue
{
    [StringValue("Employed")]
    Employed = 1,

    [StringValue("Self-Employed")]
    SelfEmployed = 2,

    [StringValue("Sole Trader")]
    SoleTrader = 3,

    [StringValue("Limited Company")]
    LimitedCompany = 4,

    [StringValue("Limited Partnership")]
    LimitedPartnership = 5,

    [StringValue("Company Director")]
    CompanyDirector = 6,

    [StringValue("20% Director")]
    TwentyPercentDirector = 7
}

public enum OccupationTypeValue
{
    [StringValue("Manual")]
    Manual = 1,

    [StringValue("Skilled")]
    Skilled = 2,

    [StringValue("Professional")]
    Professional = 3,

    [StringValue("Civil Servant")]
    CivilServant = 4,

    [StringValue("Director")]
    Director = 5,

    [StringValue("Business Partner")]
    BusinessPartner = 6
}

public enum EmployedTypeValue
{
    [StringValue("Full Time")]
    FullTime = 1,

    [StringValue("Part Time")]
    PartTime = 2
}

public enum EmployedBasisValue
{
    [StringValue("Agency")]
    Agency = 1,

    [StringValue("Contract")]
    Contract = 2,

    [StringValue("Permanent")]
    Permanent = 3,

    [StringValue("Probationary")]
    Probationary = 4,

    [StringValue("Temporary")]
    Temporary = 5
}
```

---

## 7. Database Modifications

### 7.1 TEmploymentDetail Table - New Columns Required

**Total New Columns**: 15

```sql
-- ============================================================================
-- SCRIPT: Add Employment API Gap Fields to TEmploymentDetail
-- VERSION: 1.0
-- DATE: 2026-01-27
-- DESCRIPTION: Adds columns for employment classifications and self-employed
--              financial accounts as identified in Fact Find Data Analysis v6.0
-- ============================================================================

USE [FactFind]
GO

-- Employment Type Classifications (4 columns)
ALTER TABLE [dbo].[TEmploymentDetail]
ADD
    [EmploymentType] [varchar](50) NULL,
    [OccupationType] [varchar](50) NULL,
    [EmployedType] [varchar](20) NULL,
    [EmployedBasis] [varchar](50) NULL;
GO

-- Current Employment Flag (1 column)
ALTER TABLE [dbo].[TEmploymentDetail]
ADD [IsCurrentEmployment] [bit] NULL;
GO

-- Self-Employed Accounts - Year 1 (Most Recent) (4 columns)
-- Note: PreviousFinancialYear and PreviousFinancialYearEndDate already exist
ALTER TABLE [dbo].[TEmploymentDetail]
ADD
    [PreviousShareOfCompanyProfit] [money] NULL,
    [PreviousGrossSalary] [money] NULL,
    [PreviousGrossDividend] [money] NULL,
    [PreviousIncludeInAffordability] [bit] NULL;
GO

-- Self-Employed Accounts - Year 2 (3 columns)
-- Note: SecondPreviousFinancialYear and SecondPreviousFinancialYearEndDate already exist
ALTER TABLE [dbo].[TEmploymentDetail]
ADD
    [SecondPreviousShareOfCompanyProfit] [money] NULL,
    [SecondPreviousGrossSalary] [money] NULL,
    [SecondPreviousGrossDividend] [money] NULL;
GO

-- Self-Employed Accounts - Year 3 (3 columns)
-- Note: ThirdPreviousFinancialYear and ThirdPreviousFinancialYearEndDate already exist
ALTER TABLE [dbo].[TEmploymentDetail]
ADD
    [ThirdPreviousShareOfCompanyProfit] [money] NULL,
    [ThirdPreviousGrossSalary] [money] NULL,
    [ThirdPreviousGrossDividend] [money] NULL;
GO

-- Add computed column for continuous employment months
ALTER TABLE [dbo].[TEmploymentDetail]
ADD [ContinuousEmploymentMonths] AS (
    CASE
        WHEN [StartDate] IS NULL THEN NULL
        WHEN [EndDate] IS NOT NULL THEN
            DATEDIFF(MONTH, [StartDate], [EndDate])
        ELSE
            DATEDIFF(MONTH, [StartDate], GETDATE())
    END
) PERSISTED;
GO

-- Create index on IsCurrentEmployment for filtering current employments
CREATE NONCLUSTERED INDEX [IX_TEmploymentDetail_IsCurrentEmployment]
ON [dbo].[TEmploymentDetail] ([IsCurrentEmployment], [CRMContactId])
WHERE [IsCurrentEmployment] = 1;
GO

PRINT 'Successfully added 15 new columns + 1 computed column to TEmploymentDetail'
GO
```

### 7.2 Data Migration Script

```sql
-- ============================================================================
-- SCRIPT: Populate IsCurrentEmployment for Existing Records
-- VERSION: 1.0
-- DATE: 2026-01-27
-- ============================================================================

USE [FactFind]
GO

-- Populate IsCurrentEmployment based on existing date logic
UPDATE [dbo].[TEmploymentDetail]
SET [IsCurrentEmployment] = CASE
    WHEN [EndDate] IS NULL OR [EndDate] > GETDATE() THEN 1
    ELSE 0
END
WHERE [IsCurrentEmployment] IS NULL;

PRINT 'Updated ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' employment records with IsCurrentEmployment flag'
GO

-- Optional: Populate EmploymentType based on EmploymentStatus (best-effort mapping)
UPDATE [dbo].[TEmploymentDetail]
SET [EmploymentType] = CASE [EmploymentStatus]
    WHEN 'Employed' THEN 'Employed'
    WHEN 'Self-Employed' THEN 'Self-Employed'
    WHEN 'Company Director' THEN 'Company Director'
    WHEN 'Contract Worker' THEN 'Employed'
    ELSE NULL
END
WHERE [EmploymentType] IS NULL
  AND [EmploymentStatus] IS NOT NULL;

PRINT 'Mapped ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' employment records to EmploymentType'
GO
```

### 7.3 Rollback Script

```sql
-- ============================================================================
-- ROLLBACK SCRIPT: Remove Added Columns
-- USE WITH CAUTION - Will drop all data in these columns
-- ============================================================================

USE [FactFind]
GO

-- Drop index first
DROP INDEX IF EXISTS [IX_TEmploymentDetail_IsCurrentEmployment]
ON [dbo].[TEmploymentDetail];
GO

-- Drop computed column
ALTER TABLE [dbo].[TEmploymentDetail]
DROP COLUMN IF EXISTS [ContinuousEmploymentMonths];
GO

-- Drop new columns
ALTER TABLE [dbo].[TEmploymentDetail]
DROP COLUMN IF EXISTS
    [EmploymentType],
    [OccupationType],
    [EmployedType],
    [EmployedBasis],
    [IsCurrentEmployment],
    [PreviousShareOfCompanyProfit],
    [PreviousGrossSalary],
    [PreviousGrossDividend],
    [PreviousIncludeInAffordability],
    [SecondPreviousShareOfCompanyProfit],
    [SecondPreviousGrossSalary],
    [SecondPreviousGrossDividend],
    [ThirdPreviousShareOfCompanyProfit],
    [ThirdPreviousGrossSalary],
    [ThirdPreviousGrossDividend];
GO

PRINT 'Rollback complete - 15 columns removed'
GO
```

---

## 8. Income Data - Reference to Separate API

### 8.1 Income is NOT Part of Employment Entity

The Excel analysis and database structure clearly indicate that **income data should be managed separately**:

**Evidence**:
1. Separate database tables exist:
   - `TIncome` - basic income records
   - `TDetailedincomebreakdown` - detailed income components with `EmploymentDetailIdValue` FK

2. Current v2 Employment API already provides link:
   ```json
   {
     "incomesHref": "v2/clients/{clientId}/incomes?filter=employment.id eq {employmentId}"
   }
   ```

3. Excel does NOT identify income breakdown fields as Employment gaps
   - Basic Annual Income, Overtime, Bonus, etc. not flagged as missing
   - These should be accessed via Income API

### 8.2 TDetailedincomebreakdown Table Structure

```sql
CREATE TABLE [dbo].[TDetailedincomebreakdown]
(
    [DetailedincomebreakdownId] [int] IDENTITY(1,1) NOT NULL,
    [CRMContactId] [int] NOT NULL,
    [EmploymentDetailIdValue] [int] NULL,  -- FK to TEmploymentDetail
    [Description] [varchar](512) NULL,
    [Amount] [money] NULL,
    [NetAmount] [money] NULL,
    [IncomeType] [varchar](255) NULL,      -- e.g., "Salary", "Bonus", "Overtime"
    [Frequency] [varchar](512) NULL,        -- e.g., "Monthly", "Annual"
    [GrossOrNet] [bit] NOT NULL,
    [HasIncludeInAffordability] [bit] NOT NULL,
    [StartDate] [datetime] NULL,
    [EndDate] [datetime] NULL,
    [GrossAmountDescription] [varchar](1000) NULL,
    [ConcurrencyId] [int] NOT NULL,
    CONSTRAINT [PK_TDetailedincomebreakdown] PRIMARY KEY ([DetailedincomebreakdownId])
)
```

### 8.3 Recommended Income API Operations

**Should be implemented as separate CRUD API**:
```
GET    /v2/clients/{clientId}/incomes
GET    /v2/clients/{clientId}/incomes/{incomeId}
POST   /v2/clients/{clientId}/incomes
PUT    /v2/clients/{clientId}/incomes/{incomeId}
DELETE /v2/clients/{clientId}/incomes/{incomeId}

Filter by employment:
GET /v2/clients/{clientId}/incomes?filter=employment.id eq {employmentId}
```

**Income Document Structure** (recommendation):
```json
{
  "id": 123,
  "client": { "id": 456, "href": "..." },
  "employment": { "id": 789, "href": "..." },  // Optional - links to employment
  "incomeType": "Salary",
  "description": "Basic Annual Salary",
  "amount": 75000.00,
  "netAmount": 4800.00,
  "frequency": "Monthly",
  "isGross": true,
  "includeInAffordability": true,
  "startsOn": "2023-01-01",
  "endsOn": null
}
```

### 8.4 Why Income Should Be Separate

**Architectural Benefits**:
1. **Single Responsibility**: Employment entity manages employment details; Income entity manages income details
2. **Flexibility**: Clients can have income not tied to employment (rental, investment, pension, etc.)
3. **Existing Pattern**: Current API already follows this separation with `incomesHref`
4. **Database Design**: Separate tables with FK relationship supports this
5. **Reusability**: Income API can be used independently for other contexts (pensions, investments, etc.)

**Example Query Flow**:
```
1. GET /v2/clients/123/employments/456
   -> Returns employment with incomesHref link

2. Follow link: GET /v2/clients/123/incomes?filter=employment.id eq 456
   -> Returns all income components for that employment
```

---

## 9. Migration Strategy

### 9.1 Versioning Approach

**Recommendation: v2.1 (Non-Breaking Extension)**

- Extend v2 contract with new optional fields
- Version as v2.1 (minor version increment)
- Fully backward compatible
- Existing v2 clients continue to work without changes
- New clients can opt-in to extended properties

**Reasons for v2.1 (not v3)**:
- All changes are additive (new optional fields)
- No existing fields are modified or removed
- No breaking changes to existing behavior
- Allows gradual adoption

### 9.2 Rollout Phases

#### Phase 1: Database Preparation (Week 1)
**Tasks**:
- Execute database migration script in DEV environment
- Run data population script for IsCurrentEmployment
- Validate database changes
- Update NHibernate mappings in `EmploymentDetail` domain entity
- Test database queries in isolation

**Validation**:
- All 15 new columns added successfully
- Computed column ContinuousEmploymentMonths calculates correctly
- Index on IsCurrentEmployment created
- Existing data integrity maintained

#### Phase 2: API Implementation - Classification Fields (Week 2)
**Tasks**:
- Create new enum types (EmploymentTypeValue, OccupationTypeValue, etc.)
- Extend `EmploymentDocument` contract with 4 classification fields + IsCurrentEmployment
- Update `EmploymentResource` mapping logic
- Add validation rules for new enums
- Update unit tests for new fields
- Deploy to DEV/TEST environments

**Validation**:
- Can POST/PUT employment with new classification fields
- GET returns new fields (null for existing records)
- Enums validate correctly
- Existing v2 clients not affected

#### Phase 3: API Implementation - Self-Employed Accounts (Week 3-4)
**Tasks**:
- Create `SelfEmployedAccountsValue` value object
- Update `EmploymentDocument` with SelfEmployedAccounts array property
- Implement Resource layer mapping: flatten array to DB columns (Year 1-3)
- Implement Resource layer mapping: DB columns to array structure
- Add validation: max 3 years, unique year numbers, only for self-employed
- Update unit and integration tests
- Deploy to TEST/STAGE environments

**Validation**:
- Can POST up to 3 years of accounts
- Array correctly flattens to DB columns
- GET correctly reconstructs array from DB
- Validation prevents invalid data (> 3 years, duplicate years)

#### Phase 4: Documentation & Production Release (Week 5)
**Tasks**:
- Update Swagger documentation
- Create API usage examples
- Update internal documentation
- Final UAT in STAGE environment
- Deploy to PROD
- Monitor API usage metrics and error rates

**Validation**:
- Swagger documentation accurate
- All examples work correctly
- Performance meets SLA
- Zero critical production issues

### 9.3 Backward Compatibility Testing

**Critical Test Scenarios**:

1. **Existing v2 Client - No Changes**
   - POST employment without new fields → Should succeed
   - GET employment → Should return v2 fields + new fields as null
   - PUT employment without new fields → Should succeed, preserve data

2. **New Client - Full Features**
   - POST employment with all new fields → Should succeed and persist
   - GET employment → Should receive all fields populated
   - PUT employment updating new fields only → Should work

3. **Mixed Scenario**
   - Old client creates employment (no new fields)
   - New client updates same employment (adds new fields)
   - Old client updates again (ignores new fields) → New fields preserved

4. **Invalid Data**
   - POST with invalid enum value → 400 Bad Request
   - POST with 4 self-employed accounts → 400 Bad Request
   - POST with duplicate year numbers → 400 Bad Request

---

## 10. Implementation Plan

### 10.1 Development Approach

**Total Estimated Effort**: 5 weeks

**Delivery Strategy**: Single release with all features

**Rationale**: Only 21 fields being added, tightly related features. Slice delivery would create incomplete functionality.

### 10.2 Summary Task List

| Phase | Tasks | Duration | Dependencies |
|-------|-------|----------|--------------|
| Phase 1: Database | DB scripts, NHibernate mapping, domain entity updates | 1 week | DBA approval |
| Phase 2: Classification Fields | Enums, API contract updates, simple field mapping | 1 week | Phase 1 complete |
| Phase 3: Self-Employed Accounts | Complex array↔flat mapping, validation | 2 weeks | Phase 2 complete |
| Phase 4: Release | Testing, documentation, deployment | 1 week | Phase 3 complete |

### 10.3 Success Criteria

**Technical**:
- ✅ 100% backward compatible
- ✅ API response time < 200ms (p95) for GET
- ✅ Code coverage > 80%
- ✅ Zero critical production incidents

**Business**:
- ✅ 21 new fields captured
- ✅ Self-employed accounts (3 years) available
- ✅ Vision/Multiply integration enabled

---

## 11. Appendix

### A. Field Mapping Matrix

| Excel Field | API Property | DB Column | Status |
|-------------|--------------|-----------|--------|
| Employment Type | employmentType | EmploymentType | ❌ New |
| Occupation Type | occupationType | OccupationType | ❌ New |
| Employed Type | employedType | EmployedType | ❌ New |
| Employed Basis | employedBasis | EmployedBasis | ❌ New |
| Is Current Employment | isCurrentEmployment | IsCurrentEmployment | ❌ New |
| Year 1 Gross Profit | selfEmployedAccounts[0].grossProfit | PreviousFinancialYear | ✅ Exists |
| Year 1 Share of Profit | selfEmployedAccounts[0].shareOfCompanyProfit | PreviousShareOfCompanyProfit | ❌ New |
| Year 1 Gross Salary | selfEmployedAccounts[0].grossSalary | PreviousGrossSalary | ❌ New |
| Year 1 Gross Dividend | selfEmployedAccounts[0].grossDividend | PreviousGrossDividend | ❌ New |
| Year 1 Year End | selfEmployedAccounts[0].yearEndDate | PreviousFinancialYearEndDate | ✅ Exists |
| Year 1 In Affordability | selfEmployedAccounts[0].includeInAffordability | PreviousIncludeInAffordability | ❌ New |

### B. Sample API Payload

```json
POST /v2/clients/12345/employments
{
  "employmentStatus": "SelfEmployed",
  "employmentType": "LimitedCompany",
  "employmentBusinessType": "PrivateLimitedCompany",
  "occupation": "Management Consultant",
  "occupationType": "Professional",
  "employer": "Smith Consulting Ltd",
  "startsOn": "2018-04-01",
  "isCurrentEmployment": true,
  "selfEmployedAccounts": [
    {
      "yearNumber": 1,
      "yearEndDate": "2024-03-31",
      "grossProfit": 120000.00,
      "shareOfCompanyProfit": 120000.00,
      "grossSalary": 12000.00,
      "grossDividend": 40000.00,
      "includeInAffordability": true
    },
    {
      "yearNumber": 2,
      "yearEndDate": "2023-03-31",
      "grossProfit": 110000.00,
      "shareOfCompanyProfit": 110000.00,
      "grossSalary": 12000.00,
      "grossDividend": 38000.00,
      "includeInAffordability": true
    },
    {
      "yearNumber": 3,
      "yearEndDate": "2022-03-31",
      "grossProfit": 95000.00,
      "shareOfCompanyProfit": 95000.00,
      "grossSalary": 12000.00,
      "grossDividend": 30000.00,
      "includeInAffordability": true
    }
  ]
}
```

---

## 12. References

### Code References
- **Controller**: `Context\Monolith.FactFind\src\Monolith.FactFind\v2\Controllers\EmploymentController.cs`
- **Contract**: `Context\Monolith.FactFind\src\Monolith.FactFind\v2\Contracts\EmploymentDocument.cs`
- **Domain**: `Context\IntelligentOffice\src\IntelliFlo.IO.Core\Domain\FactFind\EmploymentDetail.cs`
- **Schema**: `Context\schema\factfind\Tables\dbo.TEmploymentDetail.sql`
- **Income Schema**: `Context\schema\factfind\Tables\dbo.TDetailedincomebreakdown.sql`

### Documentation
- **Requirements**: `Requirements\Employment\Requirement.md`
- **Excel Analysis**: `Context\Fact Find Data Analysis v6.0.xlsx` (Sheet: "Fact Finds", Rows 299-375)
- **Gap Analysis Script**: `analyze_excel_gaps.py`

---

**END OF DOCUMENT**

*This document focuses exclusively on gaps identified in the Excel requirements. Income data should be managed via a separate Income API using the TDetailedincomebreakdown table structure.*
