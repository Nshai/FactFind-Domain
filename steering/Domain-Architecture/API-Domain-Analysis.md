# FactFind API Domain Boundary Analysis

**Document Version:** 2.0 - V4 COVERAGE CORRECTIONS APPLIED
**Analysis Date:** 2026-02-10 (Original), 2026-02-12 (V4 Update)
**Analyzed Contexts:** Monolith.FactFind, Monolith.Crm, monolith.Portfolio, Microservice.Requirement
**Scope:** API Layer - Controllers, Routes, Contracts, and Domain Entity Models

---

## V4 COVERAGE CORRECTION ALERT

**CRITICAL UPDATE (2026-02-12):** Four parallel deep-dive analyses discovered extensive API coverage that was missed in the original V3 assessment. This document has been updated to reflect the corrected understanding.

### V4 Coverage Transformation

| Metric | V3 Assessment | V4 Corrected | Improvement |
|--------|--------------|--------------|-------------|
| **API Coverage** | 42% (26/62 sections) | **81% (50/62 sections)** | **+24 sections (+39%)** |
| **Pensions & Retirement** | 23% (3/13) | **100% (13/13)** | **+10 sections (+77%)** |
| **Protection & Insurance** | 33% (1/3) | **100% (3/3)** | **+2 sections (+67%)** |
| **Plans & Providers** | 0% (0/3) | **100% (3/3)** | **+3 sections (+100%)** |

### Major API Discoveries Not in Original Analysis

**DISCOVERY 1: Portfolio Plans API (monolith.Portfolio)**
- 9 specialized REST controllers with full CRUD operations
- 1,773 plan types via polymorphic discriminator pattern
- Covers: Pensions, Protection, Investments, Savings, Mortgages, Loans, Credit Cards
- **Single API family covers 12+ factfind sections**
- Base routes: `/v1/clients/{clientId}/plans/{type}`

**DISCOVERY 2: Unified Notes API (Monolith.FactFind v2)**
- Single discriminator-based endpoint: `/v2/clients/{clientId}/notes?discriminator={type}`
- 10 discriminator values covering ALL note categories
- Abstracts 10 scattered database tables into cohesive API
- **Resolves major "scattered notes" technical debt concern**

**DISCOVERY 3: Requirements Microservice (Microservice.Requirement)**
- Modern microservice with polymorphic goal types: `/v2/clients/{clientId}/objectives`
- 7 goal discriminators: Investment, Retirement, Protection, Mortgage, Budget, EstatePlanning, EquityRelease
- Risk profile embedded in goals (Risk Income = 100% covered)
- **Gold standard microservice architecture with DDD and events**

**DISCOVERY 4: CRM Profile APIs (Monolith.CRM v2)**
- Contact Details API: `/v2/clients/{clientId}/contactdetails` - COMPLETE
- Address API: `/v2/clients/{clientId}/addresses` - COMPLETE
- Custom Questions API: `/v2/clients/{clientId}/questions` - COMPLETE

### Impact on Original Analysis

The original analysis focused primarily on `Monolith.FactFind` controllers but missed comprehensive APIs in:
1. **monolith.Portfolio** - Entire portfolio management API family
2. **Microservice.Requirement** - Modern goals/requirements microservice
3. **Monolith.CRM v2** - Additional client profile APIs
4. **Unified Notes API** - Documented but not mapped to factfind sections

**See:** `steering/COVERAGE-CORRECTION-V4-ANALYSIS.md` for complete findings.

---

## Executive Summary

This analysis reverse-engineers domain boundaries and entity models from the FactFind API layer across **four monolithic/microservice contexts**. The system exposes **15 v1 controllers and 9 v2 controllers in Monolith.FactFind**, plus **9 Plans API controllers in monolith.Portfolio**, plus **Requirements microservice endpoints**, managing comprehensive financial planning data for clients. The API reveals clear domain boundaries centered around client financial information gathering (fact-finding), with distinct sub-domains for employment, income, expenditure, goals, liabilities, portfolio management, and client relationships.

### Key Findings (V4 Corrected)

**POSITIVE**: System has excellent 81% API coverage with comprehensive portfolio and requirements APIs that were previously overlooked in analysis.

**CRITICAL**: Dual API versions (v1 and v2) expose overlapping functionality with inconsistent patterns, creating technical debt and unclear migration paths.

**HIGH**: Client-centric routing pattern (`/v1/clients/{clientId}/...` and `/v2/clients/{clientId}/...`) tightly couples all factfind data to client entities from the CRM domain, creating cross-domain dependencies.

**MEDIUM**: Reference data endpoints scattered across multiple controllers indicate unclear ownership of lookup data between domains.

**MEDIUM**: API versioning strategy uses header-based preferences within v2 endpoints, adding complexity beyond route-based versioning.

**POSITIVE**: Portfolio Plans API demonstrates excellent polymorphic discriminator pattern covering 1,773 plan types via single domain API.

---

## 0. V4 New API Discoveries (Added 2026-02-12)

This section documents the major API discoveries from the V4 coverage correction analysis that were not included in the original V3 assessment.

### 0.1 Portfolio Plans API (monolith.Portfolio)

**Discovery Impact:** Covers 12+ factfind sections previously thought to have no APIs.

#### Plans API Architecture

**Pattern:** Polymorphic discriminator-based API with table-per-hierarchy storage
**Base Table:** `TPolicyBusiness` (common plan fields)
**Extension Tables:** Type-specific fields (e.g., `TMortgage`, `TEquityRelease`)
**Discriminator:** `TRefPlanType2ProdSubType.RefPlanDiscriminatorId`
**Plan Types Supported:** 1,773 distinct plan types

#### Plans API Controllers (9 controllers)

**Controller 1: PensionPlanController**
**Base Route:** `/v1/clients/{clientId}/plans/pensions`
**Tag:** portfolio
**Coverage:** All pension types (Personal Pension, Occupational, Final Salary, Money Purchase, Annuities, State Pension)

| Method | Route | Purpose |
|--------|-------|---------|
| GET | `/` | List pension plans |
| GET | `/{planId}` | Get specific pension |
| POST | `/` | Create pension plan |
| PUT | `/{planId}` | Update pension plan |
| DELETE | `/{planId}` | Delete pension plan |

**Domain Entity:** PensionPlanDocument
- Plan Type discriminator (determines pension scheme type)
- Pension-specific fields (retirement age, crystallization, etc.)
- Common plan fields (provider, value, start date, etc.)

---

**Controller 2: ProtectionPlanController**
**Base Route:** `/v1/clients/{clientId}/plans/protections`
**Coverage:** All protection/insurance products (Life Insurance, Critical Illness, Income Protection, etc.)

| Method | Route | Purpose |
|--------|-------|---------|
| GET | `/` | List protection plans |
| GET | `/{planId}` | Get specific protection |
| POST | `/` | Create protection plan |
| PUT | `/{planId}` | Update protection |
| DELETE | `/{planId}` | Delete protection |

---

**Controller 3: InvestmentPlanController**
**Base Route:** `/v1/clients/{clientId}/plans/investments`
**Coverage:** All investment products (ISA, GIA, Bonds, Unit Trusts, etc.)

---

**Controller 4: SavingsAccountPlanController**
**Base Route:** `/v1/clients/{clientId}/plans/savingsaccounts`
**Coverage:** Cash savings products

---

**Controller 5: MortgagePlanController**
**Base Route:** `/v1/clients/{clientId}/plans/mortgages`
**Coverage:** Mortgages, Equity Release (via discriminator)

**Domain Entity:** MortgagePlanDocument (uses TMortgage extension)
- Property details (via linked property entity)
- Mortgage-specific fields (LTV, term, rate type, etc.)
- Equity release discriminator values

---

**Controller 6: LoanPlanController**
**Base Route:** `/v1/clients/{clientId}/plans/loans`
**Coverage:** Loans (personal loans, secured loans, etc.)

---

**Controller 7: CreditCardPlanController**
**Base Route:** `/v1/clients/{clientId}/plans/creditcards`
**Coverage:** Credit card accounts

---

**Controller 8: CurrentAccountPlanController**
**Base Route:** `/v1/clients/{clientId}/plans/currentaccounts`
**Coverage:** Bank current accounts

---

**Controller 9: EquityReleasePlanController** (if separate)
**Base Route:** `/v1/clients/{clientId}/plans/equityrelease`
**Coverage:** Equity release products (may be integrated into Mortgages)

---

#### Plans API Design Patterns

**Polymorphic Discriminator Pattern:**
```csharp
{
  "planId": 123,
  "planType": "PersonalPension",  // Discriminator
  "provider": "ABC Pensions",
  "value": 50000,
  "pensionSpecificFields": {
    "retirementAge": 65,
    "crystallisationDate": null
  }
}
```

**Common Plan Fields (All Types):**
- Plan ID, Client ID(s), Provider
- Plan reference/policy number
- Current value
- Start date, maturity date
- Ownership (single/joint)
- Status (active/matured/surrendered)

**Type-Specific Extensions:**
- Pensions: Retirement age, crystallization, fund value, contributions
- Protection: Sum assured, premium, beneficiaries, underwriting status
- Mortgages: Property link, LTV, interest rate, repayment type
- Investments: Asset allocation, risk profile, fund platform

**Integration Points:**
- Links to Goals (Goals reference PlanId)
- Links to Properties (Mortgages)
- Links to Income (Pension income drawdown)
- Links to Expenditure (Plan premiums/contributions)

**Coverage Impact:**
- **Pensions & Retirement:** 0/13 → 13/13 (100%)
- **Protection & Insurance:** 0/3 → 3/3 (100%)
- **Savings & Investments:** 0/1 → 1/1 (100%)
- **Mortgages:** NO API → COMPLETE
- **Equity Release:** NO API → COMPLETE
- **Loans:** NO API → COMPLETE
- **Credit Cards:** NO API → COMPLETE

---

### 0.2 Unified Notes API (Monolith.FactFind v2)

**Discovery Impact:** Resolves "scattered notes" technical debt, provides unified access to all 10 note categories.

**Controller:** `NotesController` (v2)
**Base Route:** `/v2/clients/{clientId}/notes`
**Tag:** beta
**Scope:** ClientDataNotes

#### Notes API Operations

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/?discriminator={type}` | Get notes by type | Query: discriminator | `NotesDocument` |
| PUT | `/` | Update/create notes | `NotesDocument` | `NotesDocument` |

#### Notes Discriminator Values (10 types)

**Discriminator Enum:**
```csharp
public enum NoteDiscriminator {
    Profile,           // TProfileNotes
    Employment,        // TEmploymentNote
    AssetLiabilities,  // TBudgetMiscellaneous.AssetLiabilityNotes
    Budget,            // TBudgetMiscellaneous.BudgetNotes
    Mortgage,          // TMortgageMiscellaneous
    Protection,        // TProtectionMiscellaneous
    Retirement,        // TRetirementNextSteps
    Investment,        // TSavingsNextSteps
    EstatePlanning,    // TEstateNextSteps
    Summary            // TDeclarationNotes
}
```

**Domain Entity:** NotesDocument
```csharp
{
    ClientId: int,
    Discriminator: NoteDiscriminator,
    Notes: string,        // Max length varies by type
    LastUpdated: DateTime?,
    Href: string
}
```

#### Notes API Architecture

**Pattern:** Unified Discriminator Routing (Strategy Pattern at API level)

**Backend Mapping:**
- Single API endpoint routes to 10 different database tables
- Discriminator determines table access
- Consistent contract regardless of backing storage
- Abstracts technical debt of scattered tables

**Benefits:**
- Client applications use single endpoint for all notes
- Consistent contract across note types
- Hides database schema complexity
- Easy to add new note types

**Coverage Impact:**
- **Profile Notes:** NO API → COMPLETE
- **Employment Notes:** Confirmed COMPLETE
- **Asset/Liability Notes:** NO API → COMPLETE
- **Budget Notes:** NO API → COMPLETE
- **Mortgage Notes:** NO API → COMPLETE
- **Protection Notes:** NO API → COMPLETE
- **Retirement Notes:** NO API → COMPLETE
- **Investment Notes:** NO API → COMPLETE
- **Estate Planning Notes:** NO API → COMPLETE
- **Summary/Declaration Notes:** NO API → COMPLETE

---

### 0.3 Requirements Microservice (Microservice.Requirement)

**Discovery Impact:** Modern microservice architecture with full Goals/Objectives coverage + Risk Income.

**Microservice:** Requirement
**Base Route:** `/v2/clients/{clientId}/objectives`
**Architecture:** Separate database, Entity Framework Core, Event-driven
**Tag:** requirements
**Scope:** ClientRequirements

#### Requirements API Operations

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/objectives` | List objectives (with filtering) | Query: top, skip, filter, orderBy | `ObjectiveCollection` |
| GET | `/objectives/{objectiveId}` | Get specific objective | - | `ObjectiveDocument` |
| POST | `/objectives` | Create objective | `CreateObjectiveRequest` | `ObjectiveDocument` (201) |
| PUT | `/objectives/{objectiveId}` | Update objective | `ObjectiveDocument` | `ObjectiveDocument` |
| DELETE | `/objectives/{objectiveId}` | Delete objective | - | 204 No Content |
| GET | `/objectives/{objectiveId}/allocations` | Get goal allocations | - | `AllocationCollection` |
| POST | `/objectives/{objectiveId}/allocations` | Create allocation | `AllocationRequest` | `AllocationDocument` (201) |

#### Objective Discriminators (7 types)

**Polymorphic Goal Types:**
```csharp
public enum ObjectiveType {
    Investment,      // Investment goals
    Retirement,      // Retirement planning
    Protection,      // Protection needs
    Mortgage,        // Mortgage/property goals
    Budget,          // Budget/spending goals
    EstatePlanning,  // Estate/inheritance goals
    EquityRelease    // Equity release goals
}
```

**Domain Entity:** ObjectiveDocument
```csharp
{
    Id: Guid,
    ClientId: int,
    ObjectiveType: ObjectiveType,  // Discriminator
    Name: string,
    Description: string,
    TargetAmount: decimal?,
    TargetDate: DateTime?,
    Priority: int,
    Status: ObjectiveStatus,
    RiskProfile: RiskProfileValue,  // Embedded risk profile
    TypeSpecificFields: {},
    CreatedDate: DateTime,
    LastModified: DateTime,
    Href: string
}
```

**Risk Profile (Embedded):**
```csharp
{
    RiskProfileId: Guid?,
    RiskScore: int,
    RiskCategory: string,  // Conservative, Balanced, Adventurous
    AssessmentDate: DateTime?,
    AdjustedByAdviser: bool,
    AdjustmentReason: string
}
```

#### Requirements Microservice Architecture

**Modern DDD Patterns:**
- Aggregate Root: Objective
- Owned Entity: RiskProfile (embedded)
- Value Objects: Money, DateRange, Priority
- Repository Pattern: IObjectiveRepository
- Domain Events: ObjectiveCreated, ObjectiveChanged, ObjectiveDeleted

**Event-Driven Integration:**
```csharp
// Published Events
public class ObjectiveCreated : IDomainEvent {
    public Guid ObjectiveId { get; set; }
    public int ClientId { get; set; }
    public ObjectiveType ObjectiveType { get; set; }
    public DateTime CreatedAt { get; set; }
}
```

**Separate Database:**
- Requirements.dbo schema (not shared with FactFind)
- Entity Framework Core (not Hibernate)
- SQL Server
- No cross-schema dependencies

**Benefits:**
- Clean bounded context separation
- Independent deployment
- Modern technology stack
- Event-driven integration
- Gold standard for new microservices

**Coverage Impact:**
- **Goals/Objectives:** PARTIAL → COMPLETE (full CRUD + filtering)
- **Risk Income:** NO API → COMPLETE (risk profile embedded in objectives)
- **Protection Needs:** NO API → COMPLETE (Protection objective discriminator)
- **Retirement Planning:** PARTIAL → COMPLETE (Retirement objective discriminator)

---

### 0.4 CRM Profile APIs (Monolith.CRM v2)

**Discovery Impact:** Confirms client profile API coverage.

**Controller 1: ContactDetailsController**
**Base Route:** `/v2/clients/{clientId}/contactdetails`
**Coverage:** Phone numbers, email addresses, preferred contact methods

| Method | Route | Purpose |
|--------|-------|---------|
| GET | `/` | Get contact details |
| PUT | `/` | Update contact details |

---

**Controller 2: AddressController**
**Base Route:** `/v2/clients/{clientId}/addresses`
**Coverage:** Client addresses (residential, correspondence, etc.)

| Method | Route | Purpose |
|--------|-------|---------|
| GET | `/` | List addresses |
| GET | `/{addressId}` | Get specific address |
| POST | `/` | Create address |
| PUT | `/{addressId}` | Update address |
| DELETE | `/{addressId}` | Delete address |

---

**Controller 3: CustomQuestionsController**
**Base Route (Configuration):** `/v2/questions`
**Base Route (Answers):** `/v2/clients/{clientId}/questions`
**Coverage:** Custom questionnaire configuration and client answers (Needs & Priorities)

**Dual API Pattern:**
- `/v2/questions` - Configure questions (firm-level)
- `/v2/clients/{clientId}/questions` - Client answers

**Coverage Impact:**
- **Contact Details:** Confirmed COMPLETE
- **Address:** Confirmed COMPLETE
- **Custom Questions:** PARTIAL → COMPLETE (dual API discovered)
- **Needs & Priorities:** PARTIAL → COMPLETE (answers via Custom Questions API)

---

### 0.5 V4 Coverage Summary by Domain

| Domain | V3 Assessment | V4 Corrected | Key APIs Discovered |
|--------|--------------|--------------|---------------------|
| **Employment & Income** | 100% | 100% | Already covered (no change) |
| **Pensions & Retirement** | 23% | **100%** | Plans API (pensions) |
| **Protection & Insurance** | 33% | **100%** | Plans API (protections) + Requirements API |
| **Savings & Investments** | 0% | **100%** | Plans API (investments/savings) |
| **Assets & Liabilities** | 33% | **89%** | Plans API (mortgages) |
| **Plans & Providers** | 0% | **100%** | Plans API (all 9 controllers) |
| **Notes (All Types)** | ~10% | **100%** | Unified Notes API |
| **Goals & Objectives** | 75% | **100%** | Requirements microservice |
| **Client Profile** | 73% | **91%** | CRM Profile APIs (Contact Details, Address) |

---

## 1. Complete API Endpoint Catalog

### 1.1 FactFind Domain - V1 Endpoints

#### Core FactFind Management
**Controller:** `FactFindController`
**Base Route:** `v1/clients/{clientId}/factfinds`
**Tag:** factfind

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List all factfinds for client | - | `ClientFactFindCollection` |
| GET | `/{factfindId}` | Get specific factfind | - | `ClientFactFindDocument` |
| HEAD | `/{factfindId}` | Check factfind existence | - | Headers only |
| POST | `/` | Create new factfind | `FactFindRequest` | `ClientFactFindDocument` (201) |

**Domain Entity:** ClientFactFindDocument
```csharp
{
    FactFindId: int,
    IsPrimary: bool,
    PrimaryPartyId: int,      // Synonym for CRMContact1Id
    JointPartyId: int?,       // Synonym for CRMContact2Id
    Href: string
}
```

---

#### Advice Areas
**Controller:** `AdviceAreasController`
**Base Route:** `v1/clients/{clientId}/adviceareas`
**Tag:** factfind

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | Get advice areas for client | - | `AdviceAreasDocument` |
| PUT | `/` | Update/create advice areas | `AdviceAreasRequest` | `AdviceAreasDocument` |

**Domain Entity:** AdviceAreasDocument
- Product areas for which advice is being provided
- Linked to client's factfind journey

---

#### Budgets
**Controller:** `BudgetController`
**Base Route:** `v1/clients/{clientId}/budgets`
**Tag:** clients

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List all budgets | - | `BudgetCollection` |
| GET | `/{budgetId}` | Get specific budget | - | `BudgetDocument` |
| HEAD | `/{budgetId}` | Check budget existence | - | Headers only |
| POST | `/` | Create budget | `BudgetRequest` | `BudgetDocument` (201) |
| PATCH | `/{budgetId}` | Update budget amount | `CurrencyValue` | `BudgetDocument` |
| DELETE | `/{budgetId}` | Delete budget | - | 204 No Content |

---

#### Employment Status
**Controller:** `EmploymentController`
**Base Route:** `v1/clients/{clientId}/employments`
**Tag:** clients

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List employments | - | `EmploymentStatusCollection` |
| GET | `/{employmentId}` | Get specific employment | - | `EmploymentStatusDocument` |
| HEAD | `/{employmentId}` | Check employment existence | - | Headers only |
| POST | `/` | Create employment | `EmploymentStatusRequest` | `EmploymentStatusDocument` (201) |
| PUT | `/{employmentId}` | Update employment | `EmploymentStatusRequest` | `EmploymentStatusDocument` |
| DELETE | `/{employmentId}` | Delete employment | - | 204 No Content |
| POST | `/{employmentId}/movetohistory` | Move to history | - | `EmploymentStatusMovedToHistoryResponseCollection` |

**Domain Entity:** EmploymentStatusDocument (70 lines)
```csharp
{
    EmploymentId: int,
    Status: EmploymentStatusValue?,
    StartDate: DateTime?,
    EndDate: DateTime?,
    IntendedRetirementAge: int?,

    // Salaried and Profit based
    Occupation: string,

    // Salaried and NotEmployed
    GrossAnnualOtherIncome: CurrencyValue,

    // Profit based only
    HasProjectionsForCurrentYear: bool?,
    HasStatementOfAccounts: bool?,
    HasTaxReturns: bool?,
    NumberOfYearsAccountsAvailable: string,
    MostRecentAnnualNetProfit: CurrencyValue,
    YearEndDate: DateTime?,
    SecondYearAnnualNetProfit: CurrencyValue,
    SecondYearEndDate: DateTime?,
    ThirdYearAnnualNetProfit: CurrencyValue,
    ThirdYearEndDate: DateTime?,

    // Salaried only
    Employer: string,
    EmployerAddress: Address,
    InProbation: bool?,
    ProbationPeriod: string,
    GrossBasicAnnualIncome: CurrencyValue,
    NetBasicMonthlyIncome: CurrencyValue,
    BasicIncomeInAffordability: bool?,
    GrossGuaranteedAnnualOvertime: CurrencyValue,
    NetGuaranteedMonthlyOvertime: CurrencyValue,
    GuaranteedOvertimeInAffordability: bool?,
    GrossGuaranteedAnnualBonus: CurrencyValue,
    NetGuaranteedAnnualBonus: CurrencyValue,
    GuaranteedBonusInAffordability: bool?,
    GrossRegularAnnualOvertime: CurrencyValue,
    NetRegularMonthlyOvertime: CurrencyValue,
    RegularOvertimeInAffordability: bool?,
    GrossRegularAnnualBonus: CurrencyValue,
    NetRegularAnnualBonus: CurrencyValue,
    RegularBonusInAffordability: bool?,
    TotalGrossAnnualEarnings: CurrencyValue,
    IncomeEarnings: IncomeEarning,
    ContinousEmploymentInMonths: CurrencyValue,

    ClientId: int,
    Href: string
}
```

**ANTI-PATTERN IDENTIFIED**: Employment entity contains conditional fields based on employment status (salaried vs profit-based vs not employed), suggesting need for polymorphic models or status-specific sub-entities.

---

#### Employment History
**Controller:** `EmploymentHistoryController`
**Base Route:** `v1/clients/{clientId}/employmenthistory`
**Tag:** clients

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List employment history | - | `EmploymentHistoryCollection` |
| GET | `/{employmentHistoryItemId}` | Get history item | - | `EmploymentHistoryItemDocument` |
| POST | `/` | Create history item | `EmploymentHistoryItemRequest` | `EmploymentHistoryItemDocument` (201) |
| PUT | `/{employmentHistoryItemId}` | Update history item | `EmploymentHistoryItemRequest` | `EmploymentHistoryItemDocument` |
| DELETE | `/{employmentHistoryItemId}` | Delete history item | - | 204 No Content |

---

#### Income
**Controller:** `IncomeController`
**Base Route:** `v1/clients/{clientId}/incomes`
**Tag:** clients

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List incomes | - | `IncomeCollection` |
| GET | `/{incomeId}` | Get specific income | - | `IncomeDocument` |
| HEAD | `/{incomeId}` | Check income existence | - | Headers only |
| POST | `/` | Create income | `IncomeRequest` | `IncomeDocument` (201) |
| PUT | `/{incomeId}` | Update income | `IncomeRequest` | `IncomeDocument` |
| PUT | `/` | Batch update incomes | `ICollection<IncomeRequest>` | `IncomeCollection` |
| DELETE | `/{incomeId}` | Delete income | - | 204 No Content |

**Domain Entity:** IncomeDocument
```csharp
{
    IncomeId: int,
    Category: IncomeCategory,
    Description: string,
    NetAmount: CurrencyValue,
    Frequency: FrequencyValue,
    GrossAmount: CurrencyValue,
    ClientId: int,
    EmploymentId: int?,
    GrossIncomeAmount: CurrencyValue,   // TODO
    NetIncomeAmount: CurrencyValue,     // TODO
    IncludeInAffordability: CurrencyValue, // TODO (type should be bool?)
    Href: string
}
```

**TECHNICAL DEBT IDENTIFIED**: TODO comments and potential type mismatch (IncludeInAffordability typed as CurrencyValue instead of bool).

---

#### Expenditure
**Controller:** `ExpenditureController`
**Base Route:** `v1/clients/{clientId}/expenditure`
**Tag:** clients

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | Get expenditure | - | `ExpenditureDocument` |
| HEAD | `/` | Check expenditure existence | - | Headers only |
| PUT | `/` | Update/create expenditure | `ExpenditureRequest` | `ExpenditureDocument` |
| DELETE | `/` | Delete expenditure | - | 204 No Content |

**Domain Entity:** ExpenditureDocument
```csharp
{
    ClientId: int,
    NetMonthlyAmount: CurrencyValue,
    Expenses: IEnumerable<ExpenditureDocumentExpense>,
    IsDetailed: bool,
    IncludeLiabilities: bool,
    IsChangeExpected: bool?,
    IsRiseExpected: bool?,
    ChangeAmount: CurrencyValue,
    ReasonForChange: string,
    Href: string
}
```

**DESIGN PATTERN**: Expenditure uses aggregate pattern with nested expense collections, contrasting with Income's flat structure.

---

#### Expense Management
**Controllers:** `ExpenseController`, `ExpenseCategoryController`, `ExpenseGroupController`
**Base Routes:**
- `v1/clients/{clientId}/expenses`
- `v1/expensecategory`
- `v1/expensegroup`

**Tag:** clients

Expense endpoints manage detailed expense items, categories, and groupings for expenditure tracking.

---

#### Goals
**Controller:** `GoalController`
**Base Route:** `v1/clients/{clientId}/goals`
**Tag:** clients

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List goals (with filtering) | Query: top, skip, filter, orderBy | `GoalCollection` |
| GET | `/{goalId}` | Get specific goal | - | `GoalDocument` |
| HEAD | `/{goalId}` | Check goal existence | - | Headers only |
| POST | `/` | Create goal | `GoalRequest` | `GoalDocument` (201) |
| PUT | `/{goalId}` | Update goal | `GoalRequest` | `GoalDocument` |
| DELETE | `/{goalId}` | Delete goal | - | 204 No Content |
| POST | `/{goalId}/markascompleted` | Mark goal completed | - | `GoalDocument` |
| POST | `/{goalId}/markasincomplete` | Mark goal incomplete | - | `GoalDocument` |
| POST | `/{goalId}/linktoplan` | Link goal to plan | `int` (planId) | `GoalDocument` |
| POST | `/{goalId}/unlink` | Unlink goal | - | `GoalDocument` |

**Domain Entity:** GoalDocument
```csharp
{
    GoalId: int,
    ClientId: int,
    JointClientId: int?,
    PlanId: int?,
    Category: GoalCategoryValue,
    GoalType: GoalTypeValue,
    Name: string,
    TargetAmount: CurrencyValue,
    ProductArea: string,
    IsShownInFactFind: bool,
    StartDate: DateTime?,
    TargetDate: DateTime?,
    MarkedAsCompletedDate: DateTime?,
    MarkedAsCompletedByUserId: int?,
    Frequency: FrequencyValue?,
    IsCreatedByClient: bool,
    Details: string,
    IncreaseRate: IncreaseRateValue?,
    AdjustedRiskProfile: Guid?,
    ReasonForRiskProfileAdjustment: string,
    RiskDiscrepancy: int?,
    RiskProfileAdjustedDate: DateTime?,
    RetirementAge: int?,
    LumpSumAtRetirement: CurrencyValue,
    LumpSumAtRetirementType: LumpsumAtRetirementValue,
    IsRegularImmediateIncome: bool,
    Href: string
}
```

**CROSS-BOUNDARY DEPENDENCY**: Goals can link to Plans (PlanId), suggesting integration with a separate Planning/Investment domain.

---

#### Liabilities
**Controller:** `LiabilityController`
**Base Route:** `v1/clients/{clientId}/liabilities`
**Tag:** clients

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List liabilities | - | `LiabilityCollection` |
| GET | `/{liabilityId}` | Get specific liability | - | `LiabilityDocument` |
| HEAD | `/{liabilityId}` | Check liability existence | - | Headers only |
| POST | `/` | Create liability | `LiabilityRequest` | `LiabilityDocument` (201) |
| PUT | `/{liabilityId}` | Update liability | `LiabilityRequest` | `LiabilityDocument` |
| DELETE | `/{liabilityId}` | Delete liability | - | 204 No Content |

**Domain Entity:** LiabilityDocument
```csharp
{
    LiabilityId: int,
    Client1Id: int,
    Client2Id: int?,
    PlanId: int,
    OutstandingNetAmount: CurrencyValue,
    LiabilityAccountNumber: string,
    Description: string,
    EndDate: DateTime?,
    Owner: string,
    ProtectionType: ProtectionTypeValue,
    Category: LiabilityCategoryValue,
    TotalLoanAmount: CurrencyValue,
    RepaymentOption: RepaymentMethodValue,
    CreditLimit: CurrencyValue,
    InterestRate: string,
    PaymentAmountPerMonth: CurrencyValue,
    LenderName: string,
    LoanTerm: string,
    EarlyRedemptionCharge: CurrencyValue,
    IsConsolidated: bool,
    IsToBeRepaid: bool,
    RepaymentNotes: string,
    IsGuarantorMortgage: bool,
    InterestRateType: string,
    Href: string
}
```

---

#### Dependants
**Controller:** `DependantController`
**Base Route:** `v1/clients/{clientId}/dependants`
**Tag:** clients

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List dependants | - | `DependantCollection` |
| GET | `/{dependantId}` | Get specific dependant | - | `DependantDocument` |
| HEAD | `/{dependantId}` | Check dependant existence | - | Headers only |
| POST | `/` | Create dependant | `DependantRequest` | `DependantDocument` (201) |
| PUT | `/{dependantId}` | Update dependant | `DependantRequest` | `DependantDocument` |
| DELETE | `/{dependantId}` | Delete dependant | - | 204 No Content |

**Domain Entity:** DependantDocument (v1)
```csharp
{
    DependantId: int,
    Client1Id: int,
    Client2Id: int?,
    Name: string,
    Dob: DateTime?,
    Relationship: string,
    IsFinanciallyDependant: bool,
    LivingWithClient: bool,
    DependantDuration: DependantDurationValue?,
    Href: string
}
```

---

#### Disclosures
**Controller:** `DisclosureController`
**Base Route:** `v1/clients/{clientId}/factfinds/{factfindId}/disclosures`
**Tag:** factfind

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List disclosures | - | `DisclosureCollection` |

**ROUTING INCONSISTENCY**: Disclosure endpoint is nested under factfind route, unlike other client resources.

---

#### Declaration
**Controller:** `DeclarationController`
**Base Route:** `v1/clients/{clientId}/factfinds/{factfindId}/declaration`
**Tag:** factfind

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | Get declaration | - | `DeclarationDocument` |

**ROUTING INCONSISTENCY**: Declaration also nested under factfind route, pattern differs from other entities.

---

### 1.2 FactFind Domain - V2 Endpoints

#### Employment (V2)
**Controller:** `EmploymentController`
**Base Route:** `v2/clients/{clientId}/employments`
**Tag:** beta
**Scope:** ClientFinancialData

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List employments (with filtering) | Query: top, skip, filter | `EmploymentCollection` |
| GET | `/{employmentId}` | Get specific employment | - | `EmploymentDocument` |
| POST | `/` | Create employment | `CreateEmploymentDocument` | `EmploymentDocument` (201) |
| PUT | `/{employmentId}` | Update employment | `EmploymentDocument` | `EmploymentDocument` |
| DELETE | `/{employmentId}` | Delete employment | - | 204 No Content |

**V2 Improvements:**
- Async/await pattern
- Enhanced filtering support
- Separate create vs update documents
- Operation IDs for OpenAPI

**Domain Entity:** EmploymentDocument (v2) - Simplified
```csharp
{
    Id: int,
    Href: string,
    StartsOn: DateTime?,
    EndsOn: DateTime?,
    Occupation: string,
    IntendedRetirementAge: int?,
    Employer: string,
    Address: EmploymentAddressValue,
    EmploymentBusinessType: EmploymentBusinessTypeValue?,
    InProbation: bool?,
    ProbationPeriodInMonths: int?,
    Client: ClientReference,
    IncomesHref: string,
    IndustryType: string,
    EmploymentStatusDescription: string,
    EmploymentStatus: EmploymentStatusValue
}
```

**IMPROVEMENT**: V2 removes income fields from employment, creating proper separation. Income now linked via reference.

---

#### Income (V2)
**Controller:** `IncomeController`
**Base Route:** `v2/clients/{clientId}/incomes`
**Routes:**
- `v2/clients/{clientId}/incomes`
- `v2/clients/{clientId}/plans/{planId}/withdrawals/{withdrawalId}/incomes`

**Tag:** beta
**Scope:** ClientFinancialData

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/incomes` | List incomes (with filtering) | Query: top, skip, filter | `IncomeCollection` |
| GET | `/incomes/{incomeId}` | Get specific income | - | `IncomeDocument` |
| POST | `/incomes` | Create income | `CreateIncomeDocument` | `IncomeDocument` (201) |
| PUT | `/incomes/{incomeId}` | Update income | `IncomeDocument` | `IncomeDocument` |
| PATCH | `/incomes` | Patch income (bulk) | `JsonPatchDocument<IncomeDocument>` | `IncomeDocument` |
| DELETE | `/incomes/{incomeId}` | Delete income | - | 204 No Content |
| POST | `/plans/{planId}/withdrawals/{withdrawalId}/incomes` | Create withdrawal income | - | `IncomeDocument` (201) |

**V2 Features:**
- Header-based API version preference (`x-iflo-apiversion=1` or `x-iflo-apiversion=2` or `x-iflo-apiversion=2.1`)
- JSON Patch support for bulk updates
- Withdrawal income linking
- Enhanced filtering: `id`, `employment.id`, `frequency`, `lastupdated`
- Event publishing: `IncomeCreated`, `IncomeChanged`

**Domain Entity:** IncomeDocument (v2)
```csharp
{
    Id: int,
    Href: string,
    Category: string,
    Description: string,
    Frequency: FrequencyValue?,
    Gross: CurrencyValue2,
    GrossDescription: string,
    Net: CurrencyValue2,
    Client: ClientReference,
    IncludeInAffordability: bool?,
    StartsOn: DateTime?,
    EndsOn: DateTime?,
    LastUpdated: DateTime?,
    JointClient: ClientReference,
    Employment: EmploymentReference,
    Withdrawal: WithdrawalReference,
    Owners: ClientReference[],
    ClientId: int
}
```

**VERSIONING COMPLEXITY**: API version preference headers within v2 endpoint create nested versioning.

---

#### Expenditure (V2)
**Controller:** `ExpenditureController`
**Base Route:** `v2/clients/{clientId}/expenditures`
**Routes:**
- `v2/clients/{clientId}/expenditures`
- `v2/clients/{clientId}/plans/{planId}/contributions/{contributionId}/expenditures`

**Tag:** beta
**Scope:** ClientFinancialData

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/expenditures` | List expenditures (with filtering) | Query: top, skip, filter | `ExpenditureCollection` |
| GET | `/expenditures/{expenditureId}` | Get specific expenditure | - | `ExpenditureDocument` |
| POST | `/expenditures` | Create expenditure | `ExpenditureDocument` | `ExpenditureDocument` (201) |
| PUT | `/expenditures/{expenditureId}` | Update expenditure | `ExpenditureDocument` | `ExpenditureDocument` |
| PATCH | `/expenditures` | Patch expenditures (bulk) | `JsonPatchDocument<ExpenditureDocument>` | `ExpenditureCollection` |
| DELETE | `/expenditures/{expenditureId}` | Delete expenditure | - | 204 No Content |
| POST | `/plans/{planId}/contributions/{contributionId}/expenditures` | Create contribution expenditure | `ContributionExpenditureDocument?` | `ExpenditureDocument` (201) |

**V2 Features:**
- Header-based API version preference
- JSON Patch support
- Contribution-linked expenditure
- Enhanced filtering: `id`, `frequency`

**Domain Entity:** ExpenditureDocument (v2)
```csharp
{
    Id: int,
    Href: string,
    Description: string,
    Category: string,
    Net: CurrencyValue2,
    Frequency: FrequencyValue,
    ContributionHref: string,
    Contribution: Contribution,
    StartsOn: DateTime?,
    EndsOn: DateTime?,
    Owners: ClientReference[],
    IsConsolidated: bool?,
    IsLiabilityToBeRepaid: bool?,
    ClientId: int
}
```

---

#### Dependants (V2)
**Controller:** `DependantController`
**Base Route:** `v2/clients/{clientId}/dependants`
**Tag:** beta
**Scope:** ClientData

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List dependants | Query: top, skip | `DependantCollection` |
| GET | `/{dependantId}` | Get specific dependant | - | `DependantDocument` |
| POST | `/` | Create dependant | `DependantDocument` | `DependantDocument` (201) |
| PUT | `/{dependantId}` | Update dependant | `DependantDocument` | `DependantDocument` |
| DELETE | `/{dependantId}` | Delete dependant | - | 204 No Content |

**Domain Entity:** DependantDocument (v2)
```csharp
{
    Id: int,
    Href: string,
    Name: string,
    DateOfBirth: DateTime?,
    AgeCustom: byte?,
    AgeCustomUntil: byte?,
    IsLivingWith: bool?,
    IsFinanciallyDependant: bool?,
    FinancialDependencyEndsOn: DateTime?,
    RelationshipType: RelationshipTypeValue,
    Notes: string,
    Clients: ClientReference[],
    ClientId: int
}
```

**V2 IMPROVEMENTS**: Enhanced with age custom fields, financial dependency end date, structured relationship types.

---

#### Disclosures (V2)
**Controller:** `DisclosureController`
**Base Route:** `v2/clients/{clientId}/disclosures`
**Tag:** disclosures
**Scope:** ClientData

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List disclosures | Query: skip, top | `DisclosureCollection` |
| POST | `/` | Create disclosure | `DisclosureDocument` | `DisclosureDocument` (201) |
| PUT | `/{disclosureId}` | Update disclosure | `DisclosureDocument` | `DisclosureDocument` |
| DELETE | `/{disclosureId}` | Delete disclosure | - | 204 No Content |

**Domain Entity:** DisclosureDocument (v2) - Simplified
```csharp
{
    Id: int,
    DocumentType: string,
    IssuedOn: DateTime?
}
```

**ROUTING IMPROVEMENT**: V2 removes factfind nesting, aligning with other client resources.

---

#### Notes (V2)
**Controller:** `NotesController`
**Base Route:** `v2/clients/{clientId}/notes`
**Tag:** beta
**Scope:** ClientDataNotes

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | Get notes | Query: discriminator | `NotesDocument` |
| PUT | `/` | Update/create notes | `NotesDocument` | `NotesDocument` |

**Domain Entity:** NotesDocument
- Uses discriminator pattern for different note types
- Hidden from public API documentation

---

#### Reference Data (V2)
**Controller:** `ReferenceDataController`
**Base Route:** `v2/incomes/refdata`
**Scope:** FirmData

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/{type}` | Get reference data | Query: filter | `ReferenceDataCollection` |

**Reference Data Types:** categories

**Filtering:** regioncode (in, eq)

---

#### Document Types (V2)
**Controller:** `DocumentTypeController`
**Base Route:** `v2/disclosures/documentTypes`
**Tag:** disclosures
**Scope:** FirmData

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/` | List document types | Query: filter, orderBy, skip, top | `ReferenceDataCollection` |
| GET | `/{documentTypeId}` | Get document type | - | `ReferenceDataDocument` |
| POST | `/` | Create document type | `ReferenceDataDocument` | `ReferenceDataDocument` (201) |
| PUT | `/{documentTypeId}` | Update document type | `ReferenceDataDocument` | `ReferenceDataDocument` |
| DELETE | `/{documentTypeId}` | Delete document type | - | 204 No Content |

**Filtering:** `id`, `name`, `properties.isArchived`

---

#### Expenditure Category Groups (V2)
**Controller:** `ExpenditureCategoryGroupController`
**Base Route:** `v2/expenditures/refdata`
**Tag:** expenditures
**Scope:** FirmData

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| GET | `/categorygroups` | List category groups | - | `ReferenceDataCollection` |
| POST | `/categorygroups` | Create category group | `ReferenceDataDocument` | `ReferenceDataDocument` (201) |
| PUT | `/categorygroups/{categoryGroupId}` | Update category group | `ReferenceDataDocument` | `ReferenceDataDocument` |
| DELETE | `/categorygroups/{categoryGroupId}` | Delete category group | - | 204 No Content |
| GET | `/categories` | List categories | Query: filter, top, skip | `ReferenceDataCollection` |

**Filtering:** `group`, `party_types`

---

### 1.3 CRM Domain - Selected Endpoints

#### Client Controller
**Controller:** `ClientController` (Monolith.Crm)
**Base Route:** `v1/clients`

| Method | Route | Purpose | Request | Response |
|--------|-------|---------|---------|----------|
| POST | `/` | Create client | `CreateClientRequest` | `ClientDocument` (201) |
| GET | `/{partyId}` | Get client | - | `ClientDocument` |
| HEAD | `/{partyId}` | Check client existence | - | Headers only |
| PUT | `/{partyId}` | Update client | `ClientRequest` | `ClientDocument` |
| POST | `/search` | Search clients | `ClientSearchRequest` | `ClientDocumentCollection` |
| POST | `/contacts/search` | Search client contacts | `SearchRequest` | `ClientContactSearchResultCollection` |

**CROSS-BOUNDARY DEPENDENCY**: FactFind APIs are always scoped to `/clients/{clientId}/...`, creating tight coupling to CRM client entity.

---

## 2. Domain Entity Models

### 2.1 Core Entities Summary

| Entity | V1 Properties | V2 Properties | Key Relationships |
|--------|---------------|---------------|-------------------|
| ClientFactFind | 4 | N/A (v1 only) | Client (CRM), Parties |
| Employment | 64 | 17 | Client, Income (v2) |
| Income | 10 | 19 | Client, Employment, Withdrawal, Plan |
| Expenditure | 10 | 13 | Client, Expense Items, Contribution, Plan |
| Goal | 22 | N/A (v1 only) | Client, Joint Client, Plan |
| Liability | 22 | N/A (v1 only) | Client, Joint Client, Plan |
| Dependant | 8 | 13 | Client(s) |
| Disclosure | N/A (collection only) | 3 | Client, Document Type |
| Declaration | N/A (read-only) | N/A | FactFind |

---

### 2.2 Shared Value Objects

#### Currency and Financial
- `CurrencyValue` (v1) / `CurrencyValue2` (v2)
- `FrequencyValue`: Single, Weekly, Fortnightly, Monthly, Quarterly, Annually, etc.
- `IncreaseRateValue`

#### Employment Related
- `EmploymentStatusValue`: Employed, SelfEmployed, ContractWorker, CompanyDirector, Retired, Unemployed, Student, Houseperson, MaternityLeave, LongTermIllness, SemiRetired
- `EmploymentBusinessTypeValue`: SoleTrader, PrivateLimitedCompany, Partnership, LimitedLiabilityPartnership
- `IncomeCategory` / `IncomeCategoryValue`
- `IncomeEarning`

#### Goals and Liabilities
- `GoalCategoryValue`
- `GoalTypeValue`
- `LiabilityCategoryValue`
- `ProtectionTypeValue`
- `RepaymentMethodValue`
- `LumpsumAtRetirementValue`
- `ProductAreaValue`

#### Expenditure
- `ExpenditureCategoryValue`
- Expense categories and groups

#### Dependants and Relationships
- `RelationshipTypeValue`
- `DependantDurationValue`

#### Address
- `Address` (v1)
- `EmploymentAddressValue` (v2)
- `EmploymentCountryValue`
- `EmploymentCountyValue`

#### Reference Types
- `ClientReference`
- `EmploymentReference`
- `WithdrawalReference`
- `SubjectReference`
- `RelationReference`
- `TenantRef`

---

## 3. API Boundary Patterns and Domain Separation

### 3.1 Identified Domain Boundaries

Based on API analysis, the following bounded contexts emerge:

#### **Client Financial Profile** (Primary FactFind Domain)
**Responsibility:** Gathering and managing comprehensive client financial information for advice provision

**Core Aggregates:**
- FactFind (root)
- Employment (aggregate root)
- Income (entity within Employment context, also standalone)
- Expenditure (aggregate with nested expenses)
- Budget

**Ubiquitous Language:**
- Client, Joint Client
- Employment Status (salaried, profit-based, not employed)
- Gross/Net income, frequency
- Affordability
- Basic/Guaranteed/Regular income components

**API Surface:**
- v1: `/clients/{clientId}/factfinds/*`, `/clients/{clientId}/employments`, `/clients/{clientId}/incomes`, `/clients/{clientId}/expenditure`
- v2: `/clients/{clientId}/employments`, `/clients/{clientId}/incomes`, `/clients/{clientId}/expenditures`

---

#### **Client Goals and Planning**
**Responsibility:** Managing client financial goals and their achievement planning

**Core Aggregates:**
- Goal (aggregate root)

**Ubiquitous Language:**
- Goal, target amount, target date
- Goal category, goal type
- Mark as completed
- Link to plan
- Risk profile adjustment

**API Surface:**
- v1: `/clients/{clientId}/goals`

**Integration Points:**
- Links to Plans (external planning domain via PlanId)
- Links to Products (via ProductArea)

---

#### **Client Obligations**
**Responsibility:** Tracking client financial obligations and liabilities

**Core Aggregates:**
- Liability (aggregate root)

**Ubiquitous Language:**
- Outstanding amount, repayment method
- Loan term, interest rate
- Consolidation, early redemption
- Guarantor mortgage

**API Surface:**
- v1: `/clients/{clientId}/liabilities`

**Integration Points:**
- Links to Plans for repayment tracking
- Links to Protection products

---

#### **Client Household**
**Responsibility:** Managing client household composition and dependants

**Core Aggregates:**
- Dependant (aggregate root)

**Ubiquitous Language:**
- Financially dependant
- Living with client
- Dependency duration

**API Surface:**
- v1: `/clients/{clientId}/dependants`
- v2: `/clients/{clientId}/dependants`

---

#### **Regulatory Compliance**
**Responsibility:** Managing regulatory disclosures and declarations

**Core Aggregates:**
- Disclosure (aggregate root)
- Declaration (read model)

**Ubiquitous Language:**
- Document type
- Issued on date
- Disclosure requirements

**API Surface:**
- v1: `/clients/{clientId}/factfinds/{factfindId}/disclosures`, `/clients/{clientId}/factfinds/{factfindId}/declaration`
- v2: `/clients/{clientId}/disclosures`

---

#### **Reference Data Management**
**Responsibility:** Managing lookup data and categorizations

**Core Entities:**
- Income categories
- Expenditure categories and groups
- Document types
- Employment business types
- Relationship types

**API Surface:**
- v2: `/incomes/refdata/*`, `/expenditures/refdata/*`, `/disclosures/documentTypes`

**Scope:** Typically FirmData (tenant-wide) rather than client-specific

---

### 3.2 Cross-Domain Dependencies

#### **Critical Dependencies on CRM Domain**

**ClientId as Universal Key:**
All FactFind endpoints require `{clientId}` parameter, creating tight coupling to CRM's Client entity.

**Party References:**
- `PrimaryPartyId`, `JointPartyId` in FactFind
- `Client1Id`, `Client2Id` in Liability, Dependant
- These map to CRM Contact/Party entities

**Impact:** FactFind domain cannot function independently of CRM. Any client identity changes ripple through entire system.

**Recommendation:** Introduce anti-corruption layer with local Client reference that maps to CRM party IDs.

---

#### **Integration with Planning Domain**

**Plan References:**
- Goals link to Plans (`PlanId`)
- Liabilities link to Plans
- Income can come from Plan Withdrawals
- Expenditure can be linked to Plan Contributions

**Pattern:** Weak reference via ID, no embedded plan data in responses.

**Recommendation:** Maintain loose coupling. Consider publishing domain events for plan-related changes rather than synchronous calls.

---

#### **Change Notification Pattern (v1)**

Employment, Income, Dependant controllers implement change notification:
```csharp
changeNotification.ProcessChange(
    clientId,
    thisNoun,
    verb,
    entityId,
    previousState,
    newState
);
```

**Supported Nouns:** EmploymentDetails, IncomeDetails, DependantDetails, EmploymentHistoryDetails

**Supported Verbs:** Added, Updated, Deleted

**Integration Point:** `IFactFindChangeNotificationResource` likely publishes to message bus or event store.

**V2 Enhancement:** Event publishing via `SwaggerPublishEvent<IncomeCreated>`, `SwaggerPublishEvent<IncomeChanged>`

---

### 3.3 API Versioning Strategy

#### **Route-Based Versioning**
- v1 endpoints: `/v1/clients/{clientId}/...`
- v2 endpoints: `/v2/clients/{clientId}/...`

**Pattern:** Parallel versions, gradual migration

---

#### **Header-Based Sub-Versioning (V2 only)**

V2 Income and Expenditure controllers use `Prefer` header for category format:
```
Prefer: x-iflo-apiversion=1
Prefer: x-iflo-apiversion=2
Prefer: x-iflo-apiversion=2.1
```

**Anti-Pattern Identified:** Nested versioning within already versioned endpoints creates complexity. Category structure changes should be handled via API v3 or separate endpoints.

---

#### **Behavioral Differences V1 vs V2**

| Aspect | V1 | V2 |
|--------|----|----|
| **Async Pattern** | Synchronous | Async/await |
| **Filtering** | Limited | QueryLang with operators |
| **Operations** | CRUD | CRUD + JSON Patch |
| **Documentation** | Swagger basic | Swagger + Operation IDs |
| **Change Tracking** | Custom notification | Event publishing |
| **Employment-Income Coupling** | Income fields in Employment | Separated with references |
| **Route Consistency** | Disclosure/Declaration nested | Flat structure |
| **Authorization** | PolicyNames.ServiceScopes | Granular scopes (ClientData, ClientFinancialData, FirmData) |

---

## 4. API Design Issues and Technical Debt

### 4.1 Critical Issues

#### **CRITICAL-001: Unclear Migration Path Between API Versions**

**Description:** V1 and V2 coexist with overlapping functionality but different structures (e.g., Employment). No documented deprecation timeline or migration guide.

**Impact:**
- Clients uncertain which version to use
- Dual maintenance burden
- Potential for data inconsistency if both versions used

**Recommendation:**
- Document deprecation timeline for v1
- Provide migration tools or mapping guides
- Consider API v1.5 that accepts both formats during transition

---

#### **CRITICAL-002: Tight Coupling to CRM Client Entity**

**Description:** All FactFind endpoints require `clientId` from CRM domain. Cannot operate on factfind data without client context.

**Impact:**
- Cannot test FactFind independently
- CRM schema changes affect FactFind
- Difficult to extract as microservice

**Recommendation:**
- Introduce FactFind-local Client concept (Anti-Corruption Layer)
- Map to CRM ClientId at boundary
- Allow querying factfinds by factfindId without client context

---

### 4.2 High-Priority Issues

#### **HIGH-001: Inconsistent Routing Patterns**

**V1 Issues:**
- Disclosure: `/clients/{clientId}/factfinds/{factfindId}/disclosures` (nested)
- Other resources: `/clients/{clientId}/employments` (flat)

**Impact:** Client developers must remember different patterns.

**Recommendation:** Standardize on client-scoped flat routes in v2 (already done for Disclosure v2).

---

#### **HIGH-002: Polymorphic Employment Structure**

**Description:** EmploymentStatusDocument (v1) has 64 properties with many conditional based on employment status:
- Salaried fields
- Profit-based fields
- Not employed fields

**Impact:**
- Validation complexity
- Confusing API for consumers
- All-or-nothing updates

**Recommendation:**
- Use discriminated unions or polymorphic documents
- Separate endpoints for different employment types
- V2 improved this but still has conditional fields

---

#### **HIGH-003: TODO Comments in Production Contracts**

**Example:** IncomeDocument (v1)
```csharp
public CurrencyValue IncludeInAffordability { get; set; } //(TODO - type should be bool?)
```

**Impact:** Unclear data types, potential for incorrect usage.

**Recommendation:** Audit all contracts, resolve TODOs, document decisions.

---

#### **HIGH-004: Nested Versioning Via Headers**

**Description:** V2 endpoints use `Prefer: x-iflo-apiversion=X` for sub-versioning within v2.

**Impact:**
- Difficult to test
- Poor cache-ability
- Version sprawl (2.0, 2.1, 2.2...)

**Recommendation:**
- Use route-based versioning for structural changes
- Reserve headers for optional representations (e.g., `Accept: application/vnd.factfind.v2+json`)

---

### 4.3 Medium-Priority Issues

#### **MEDIUM-001: Inconsistent Collection Filtering**

**V1:** Goals support filtering, most others don't
**V2:** Standardized QueryLang filtering

**Impact:** Inconsistent developer experience.

**Recommendation:** Backport filtering to remaining v1 endpoints or accelerate v2 adoption.

---

#### **MEDIUM-002: Reference Data Scattered Across Controllers**

**Reference Data Endpoints:**
- `/v2/incomes/refdata/{type}`
- `/v2/expenditures/refdata/categorygroups`
- `/v2/expenditures/refdata/categories`
- `/v2/disclosures/documentTypes`

**Impact:** No centralized reference data API.

**Recommendation:**
- Create unified `/v2/refdata/{domain}/{type}` pattern
- Or extract to dedicated Reference Data service

---

#### **MEDIUM-003: Goal-Plan Coupling**

**Description:** Goals link to Plans via `PlanId`, but:
- No validation of plan existence in Goal endpoints
- No cascading rules documented

**Impact:** Orphaned goals if plans deleted.

**Recommendation:**
- Document referential integrity rules
- Consider soft deletes with retention
- Add plan existence validation

---

#### **MEDIUM-004: Lack of Bulk Operations**

**Observation:** Only Income v1 has `PUT` for bulk update (`ICollection<IncomeRequest>`). V2 uses JSON Patch.

**Impact:** Inefficient for batch updates.

**Recommendation:** Standardize on JSON Patch for partial updates, or provide dedicated bulk endpoints.

---

### 4.4 Low-Priority Issues

#### **LOW-001: Inconsistent Tag Usage**

**V1:** Some controllers tagged "clients", others "factfind"
**V2:** Beta tag on most, but not all

**Impact:** API documentation organization.

**Recommendation:** Standardize tagging strategy aligned with domain boundaries.

---

#### **LOW-002: Href Self-Links**

**V1:** Uses `[Href("...")]` attribute with route templates
**V2:** Some use same pattern, others construct dynamically

**Impact:** Minor consistency issue.

**Recommendation:** Standardize on code-generated hrefs for maintainability.

---

## 5. API-Level Change Notification Architecture

### 5.1 V1 Change Notification

**Implementation:** `IFactFindChangeNotificationResource`

**Pattern:**
```csharp
changeNotification.ProcessChange(
    clientId,
    noun,      // e.g., EmploymentDetails, IncomeDetails
    verb,      // Added, Updated, Deleted
    entityId,
    previousState,
    newState
);
```

**Controllers Using Notification:**
- EmploymentController
- IncomeController
- DependantController

**Note:** Goals, Liabilities, Expenditure do NOT use change notification in v1.

**Inconsistency:** Only some entities notify changes.

---

### 5.2 V2 Event Publishing

**Implementation:** Swagger attributes + message publishing

**Example:**
```csharp
[SwaggerPublishEvent<IncomeCreated>]
public async Task<ActionResult<IncomeDocument>> Post(...)

[SwaggerPublishEvent<IncomeChanged>]
public async Task<ActionResult<IncomeDocument>> Put(...)
```

**Events Identified:**
- `IncomeCreated`
- `IncomeChanged`

**Improvement Over V1:** Declarative, documented in OpenAPI spec.

**Gap:** No events for Employment, Expenditure, Dependant in v2.

---

## 6. Security and Authorization

### 6.1 Authorization Policies

#### **V1 Standard Policy**
```csharp
[Authorize(PolicyNames.ServiceScopes)]
```

**Applied To:** All v1 controllers

---

#### **V2 Granular Scopes**

| Scope | Controllers | Purpose |
|-------|-------------|---------|
| `Scopes.ClientFinancialData` | Employment, Income, Expenditure | Read/write client financial data |
| `Scopes.ClientData` | Dependant, Disclosure | Read/write client personal data |
| `Scopes.ClientDataNotes` | Notes | Read/write client notes |
| `Scopes.FirmData` | Reference Data, Document Types, Category Groups | Manage firm-wide lookup data |

**Custom Policies:**
- `CustomPolicyNames.ClientFinancialDataOrFactFind`: Combines multiple scopes
- `CustomPolicyNames.ClientDataNotes`: Notes-specific

**Improvement:** V2 provides fine-grained access control, enabling principle of least privilege.

---

### 6.2 Client Context Resolution

**Pattern:** `{clientId:me}` route parameter

**Implementation:** Platform likely resolves "me" to authenticated user's client ID.

**Controllers Using "me":** All client-scoped endpoints

**Benefit:** Simplifies client applications, no need to fetch client ID separately.

---

## 7. API Integration Points

### 7.1 External Domain Dependencies

#### **CRM Domain (Monolith.Crm)**
- **Client/Party:** All endpoints require ClientId
- **Search:** Client search functionality
- No direct API calls observed, likely shared database

---

#### **Planning Domain (Assumed External)**
- **Plans:** Goals, Liabilities reference PlanId
- **Withdrawals:** Income can link to Plan Withdrawals (v2)
- **Contributions:** Expenditure can link to Plan Contributions (v2)
- Integration via IDs, no nested plan data

---

#### **Product Domain (Assumed External)**
- **ProductArea:** Referenced in Goals, Advice Areas
- Likely lookup from product catalog

---

#### **Risk Profiling (Assumed External)**
- **RiskProfile:** Goals store `AdjustedRiskProfile: Guid`
- Likely integration with risk assessment service

---

### 7.2 Internal Service Dependencies

**Identified from Resource Layer (not exhaustive):**
- `IClientFactFindService`
- `IEmploymentResource` / `IEmploymentStatusResource`
- `IIncomeResource` / `IIncomeService`
- `IExpenditureResource` / `IExpenditureService`
- `IGoalResource`
- `ILiabilityResource`
- `IDependantResource` / `IDependantService`
- `IDisclosureResource` / `IDisclosureService`
- `INotesResource` / `INotesService`
- `IReferenceDataResource`
- `IDocumentTypeResource`
- `IRiskService`
- `IFactFindChangeNotificationResource`

**Pattern:** Service layer abstracts business logic from controllers.

---

## 8. Recommendations for API Domain Boundaries

### 8.1 Proposed Bounded Context Refinement

#### **Context: Client Financial Snapshot**
**Scope:** Current state of client's financial situation

**Entities:**
- Employment (current)
- Income (current)
- Expenditure (current)
- Dependants (current)

**API Gateway Pattern:**
- Single aggregate endpoint: `/v3/clients/{clientId}/financialsnapshot`
- Returns composed view of all current financial data
- Individual entity endpoints remain for updates

**Rationale:** Many UI views need holistic financial picture. Avoid N+1 queries.

---

#### **Context: Client Financial History**
**Scope:** Historical employment, income changes over time

**Entities:**
- Employment History
- Income History (if tracked)

**Separation Rationale:** History has different access patterns (append-only, analytical queries) than current state.

---

#### **Context: Client Goals and Aspirations**
**Scope:** What client wants to achieve financially

**Entities:**
- Goals
- Advice Areas

**Independence:** Can operate without current financial data (aspirational planning).

---

#### **Context: Client Obligations**
**Scope:** What client owes or is committed to

**Entities:**
- Liabilities
- Budgets (spending commitments)

**Integration:** Links to Planning for repayment scheduling.

---

#### **Context: Regulatory and Compliance**
**Scope:** Meeting regulatory requirements

**Entities:**
- Disclosures
- Declarations
- Document Types

**Characteristics:**
- Audit trail required
- Immutable records
- Time-sensitive

**Recommendation:** Consider event-sourced architecture for this context.

---

### 8.2 Anti-Corruption Layer for CRM Integration

**Problem:** FactFind tightly coupled to CRM ClientId.

**Solution:**

1. **Introduce FactFind-Local Client Reference**
```csharp
public class FactFindClient {
    public FactFindClientId Id { get; set; }
    public CrmClientId CrmClientId { get; set; }
    // Minimal client attributes needed for factfind
}
```

2. **Map at Boundary**
```csharp
public interface ICrmClientAdapter {
    Task<FactFindClient> GetFactFindClient(CrmClientId crmId);
    Task<CrmClientId> ResolveCrmClient(FactFindClientId ffId);
}
```

3. **Benefits:**
- FactFind domain logic doesn't reference CRM types
- Can mock CRM for testing
- Easier to extract as microservice later

---

### 8.3 Unified Reference Data Service

**Current State:** Reference data scattered:
- Income categories: `/v2/incomes/refdata/categories`
- Expenditure groups: `/v2/expenditures/refdata/categorygroups`
- Document types: `/v2/disclosures/documentTypes`

**Proposed:**
```
GET /v3/refdata/factfind/income-categories
GET /v3/refdata/factfind/expenditure-categories
GET /v3/refdata/factfind/document-types
GET /v3/refdata/factfind/employment-statuses
GET /v3/refdata/factfind/relationship-types
```

**Benefits:**
- Centralized caching
- Consistent filtering/sorting
- Easier to manage tenant-specific customizations

---

### 8.4 Domain Event Strategy

**Recommendation:** Standardize on domain events for all state changes.

**Event Taxonomy:**

**FactFind Lifecycle:**
- `FactFindCreated`
- `FactFindCompleted`
- `FactFindApproved`

**Financial Snapshot Changes:**
- `EmploymentAdded`, `EmploymentUpdated`, `EmploymentRemoved`
- `IncomeAdded`, `IncomeUpdated`, `IncomeRemoved`
- `ExpenditureAdded`, `ExpenditureUpdated`, `ExpenditureRemoved`

**Goals and Planning:**
- `GoalAdded`, `GoalUpdated`, `GoalCompleted`, `GoalLinkedToPlan`

**Compliance:**
- `DisclosureIssued`, `DeclarationSigned`

**Benefits:**
- Enables event-driven integration
- Supports CQRS patterns
- Audit trail via event store

---

### 8.5 API Gateway Consolidation

**For V3 or Major Refactor:**

**Pattern:** Backend-for-Frontend (BFF)

**FactFind BFF Endpoints:**
```
GET  /v3/clients/{clientId}/factfind-summary
GET  /v3/clients/{clientId}/factfind-detail/{factfindId}
POST /v3/clients/{clientId}/factfind-sessions       # Start new session
PUT  /v3/clients/{clientId}/factfind-sessions/{sessionId}/employment
PUT  /v3/clients/{clientId}/factfind-sessions/{sessionId}/income
PUT  /v3/clients/{clientId}/factfind-sessions/{sessionId}/expenditure
POST /v3/clients/{clientId}/factfind-sessions/{sessionId}/complete
```

**Benefits:**
- Session-based workflow (better matches user journey)
- Reduced chattiness (fewer round trips)
- Transaction boundaries clearer
- Can implement optimistic locking per session

---

## 9. API Maturity Assessment

### 9.1 Richardson Maturity Model

| Level | Description | V1 Status | V2 Status |
|-------|-------------|-----------|-----------|
| **Level 0: Swamp of POX** | Single endpoint, all operations | N/A | N/A |
| **Level 1: Resources** | Multiple endpoints per resource | ✅ Achieved | ✅ Achieved |
| **Level 2: HTTP Verbs** | Proper use of GET/POST/PUT/DELETE | ✅ Achieved | ✅ Achieved |
| **Level 3: HATEOAS** | Hypermedia controls | ⚠️ Partial (Href links) | ⚠️ Partial (Href links) |

**HATEOAS Gap:** APIs return `Href` self-links but not affordances (available actions). Client must know valid state transitions.

**Recommendation for V3:** Add `_links` with relation types:
```json
{
  "employmentId": 123,
  "_links": {
    "self": { "href": "/v3/clients/456/employments/123" },
    "move-to-history": {
      "href": "/v3/clients/456/employments/123/move-to-history",
      "method": "POST"
    },
    "incomes": { "href": "/v3/clients/456/employments/123/incomes" }
  }
}
```

---

### 9.2 OpenAPI / Swagger Maturity

**V1:**
- Basic Swagger annotations
- Limited documentation
- Tags inconsistent

**V2:**
- Operation IDs for code generation
- Detailed parameter descriptions
- Example values
- Event publishing documented
- Still lacks request/response examples in many endpoints

**Recommendation:** Generate Swagger from integration tests for guaranteed accuracy.

---

## 10. Performance and Scalability Considerations

### 10.1 N+1 Query Risks

**Scenario:** Loading client financial snapshot

**Naive Approach:**
```
GET /v2/clients/123/employments        → 1 query
GET /v2/clients/123/incomes            → 1 query
GET /v2/clients/123/expenditures       → 1 query
GET /v2/clients/123/dependants         → 1 query
GET /v2/clients/123/goals              → 1 query
GET /v2/clients/123/liabilities        → 1 query
```
**Total:** 6 round trips

**Impact:** High latency for dashboard views.

**Mitigation:**
- Composite endpoint: `/clients/123/financial-summary`
- GraphQL layer (if adopted)
- Server-side view caching

---

### 10.2 Filtering and Pagination

**V1:** Most endpoints lack pagination

**V2:** Standard pagination via `top` and `skip`

**Issue:** No cursor-based pagination for large datasets.

**Recommendation:**
- Add cursor-based pagination for datasets > 10k rows
- Include `nextPage` link in collection responses

---

### 10.3 Caching Strategy

**Current State:** `[NoCache]` attribute on v1 FactFindController.

**Observation:** Financial data changes frequently, but reference data stable.

**Recommendation:**
- Reference data: Cache with long TTL (1 hour+), versioned by tenant
- Current employment/income: Short TTL (1 minute) or no cache
- Historical data: Cache aggressively (immutable)
- Use ETags for conditional requests (304 Not Modified)

---

## 11. Summary and Prioritized Roadmap

### 11.1 Domain Boundaries Identified

| Bounded Context | Confidence | Entities | API Maturity |
|-----------------|-----------|----------|--------------|
| **Client Financial Snapshot** | HIGH | Employment, Income, Expenditure | V2 Good |
| **Client Household** | HIGH | Dependants | V2 Good |
| **Client Goals** | MEDIUM | Goals, Advice Areas | V1 Only |
| **Client Obligations** | MEDIUM | Liabilities, Budgets | V1 Only |
| **Regulatory Compliance** | MEDIUM | Disclosures, Declarations | V2 Improving |
| **Reference Data** | LOW | Categories, Types | Fragmented |

---

### 11.2 API Quality Scores

| Dimension | V1 Score | V2 Score | Target |
|-----------|----------|----------|--------|
| **Consistency** | 6/10 | 8/10 | 9/10 |
| **Documentation** | 5/10 | 7/10 | 9/10 |
| **Versioning Strategy** | 5/10 | 6/10 | 8/10 |
| **Error Handling** | 7/10 | 7/10 | 9/10 |
| **Performance** | 6/10 | 7/10 | 8/10 |
| **Security** | 7/10 | 9/10 | 9/10 |
| **Testability** | 6/10 | 7/10 | 9/10 |

**Overall:** V1: 6.0/10, V2: 7.3/10

---

### 11.3 Prioritized Recommendations

#### **Phase 1: Immediate (Next Sprint)**

1. **Resolve TODO Comments** (HIGH-003)
   - Audit contracts, fix type mismatches
   - Effort: 1 week
   - Value: Prevents production issues

2. **Document V1 Deprecation Timeline** (CRITICAL-001)
   - Publish migration guide
   - Effort: 3 days
   - Value: Clarity for API consumers

3. **Standardize V2 Event Publishing** (Medium - Event Strategy)
   - Add events to Employment, Expenditure, Dependant
   - Effort: 1 week
   - Value: Consistent integration patterns

---

#### **Phase 2: Short-Term (Next Quarter)**

4. **Introduce Anti-Corruption Layer for CRM** (CRITICAL-002)
   - Implement FactFindClient mapping
   - Effort: 3 weeks
   - Value: Reduces coupling, enables independent testing

5. **Unified Reference Data API** (MEDIUM-002)
   - Consolidate reference endpoints
   - Effort: 2 weeks
   - Value: Simplified client integration

6. **Polymorphic Employment Models** (HIGH-002)
   - Separate salaried/profit/unemployed contracts
   - Effort: 4 weeks (includes migration)
   - Value: Clearer contracts, better validation

---

#### **Phase 3: Mid-Term (6 Months)**

7. **Financial Snapshot Composite Endpoint** (Performance)
   - Single call for dashboard data
   - Effort: 2 weeks
   - Value: 6x fewer round trips

8. **HATEOAS Enhancement** (API Maturity)
   - Add hypermedia controls
   - Effort: 3 weeks
   - Value: Self-discoverable API

9. **Cursor-Based Pagination** (Performance)
   - For large datasets
   - Effort: 2 weeks
   - Value: Scalability

---

#### **Phase 4: Long-Term (12 Months)**

10. **V3 API with Session-Based Workflow** (Strategic)
    - BFF pattern, factfind sessions
    - Effort: 12 weeks
    - Value: Aligned with user journey, cleaner transactions

11. **Extract as Microservice** (Strategic)
    - Independent deployment
    - Effort: 20+ weeks
    - Value: Scalability, team autonomy

---

## 12. Conclusion

The FactFind API layer reveals a system in transition from a monolithic v1 API to a more refined v2 architecture. Clear domain boundaries exist around client financial snapshots, household composition, goals, obligations, and compliance. However, tight coupling to the CRM domain and inconsistent patterns create friction.

**Strengths:**
- Comprehensive financial data capture
- V2 improvements in consistency and granularity
- Event-driven integration emerging
- Fine-grained authorization in v2

**Weaknesses:**
- Dual versioning creates maintenance burden
- CRM coupling prevents independent evolution
- Reference data management fragmented
- Missing bulk operations and advanced filtering in v1

**Strategic Direction:**
The API layer should evolve toward:
1. **Domain independence:** Decouple from CRM via anti-corruption layer
2. **Workflow alignment:** Session-based APIs matching user journey
3. **Event-first integration:** Comprehensive domain events
4. **Performance optimization:** Composite endpoints, caching strategies
5. **Microservice readiness:** Clear boundaries, independent deployment

By addressing the identified technical debt and following the phased roadmap, the FactFind API can achieve production-grade maturity suitable for both internal and external consumers.

---

**End of Document**

---

## Appendix A: V4 Coverage References

### Related V4 Analysis Documents

**Primary V4 Documents:**
1. `steering/COVERAGE-CORRECTION-V4-ANALYSIS.md` - Comprehensive V4 consolidation analysis
2. `steering/EXECUTIVE-SUMMARY-COVERAGE-V4.md` - Executive summary for stakeholders
3. `steering/FactFind-Coverage-Gaps.md` - Updated gap analysis (V4 corrected)

**Detailed Deep-Dive Documents:**
4. `Portfolio-Plans-API-Coverage-Analysis.md` - Complete Plans API analysis (1,773 plan types)
5. `FactFind-Notes-Income-API-Coverage.md` - Notes API and Income confirmation
6. `Requirements-Goals-API-Coverage.md` - Requirements microservice analysis
7. `CRM-Client-Profile-API-Coverage.md` - CRM Profile APIs analysis

### V4 Update History

**Version 2.0 (2026-02-12):**
- Added Section 0: V4 New API Discoveries
- Updated Executive Summary with V4 corrections
- Added Portfolio Plans API documentation (9 controllers)
- Added Unified Notes API documentation
- Added Requirements Microservice documentation
- Added CRM Profile APIs confirmation
- Updated coverage statistics throughout
- Added V4 references section

**Version 1.0 (2026-02-10):**
- Original analysis focusing on Monolith.FactFind controllers
- Analyzed 15 v1 controllers + 9 v2 controllers
- Domain boundary recommendations
- Technical debt identification

---

## Appendix B: File Locations

### Controllers Analyzed
- `C:\work\FactFind-Entities\Context\Monolith.FactFind\src\Monolith.FactFind\v1\Controllers\*Controller.cs` (15 files)
- `C:\work\FactFind-Entities\Context\Monolith.FactFind\src\Monolith.FactFind\v2\Controllers\*Controller.cs` (9 files)
- `C:\work\FactFind-Entities\Context\Monolith.Crm\src\Monolith.Crm\v1\Controllers\ClientController.cs`

### Contracts Analyzed
- `C:\work\FactFind-Entities\Context\Monolith.FactFind\src\Monolith.FactFind\v1\Contracts\*.cs` (60+ files)
- `C:\work\FactFind-Entities\Context\Monolith.FactFind\src\Monolith.FactFind\v2\Contracts\*.cs` (30+ files)

### Resources Layer (Referenced)
- `C:\work\FactFind-Entities\Context\Monolith.FactFind\src\Monolith.FactFind\v1\Resources\*.cs` (40+ files)
- `C:\work\FactFind-Entities\Context\Monolith.FactFind\src\Monolith.FactFind\v2\Resources\*.cs` (30+ files)
