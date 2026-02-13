# FactFind Sections Coverage Matrix

**Analysis Date:** 2026-02-12
**Purpose:** Comprehensive coverage analysis mapping all 62+ factfind sections to database schemas, domain entities, and API endpoints
**Status:** COMPLETE
**V4 CORRECTION:** Major coverage improvements discovered - See COVERAGE-CORRECTION-V4-ANALYSIS.md

---

## V4 CORRECTION ALERT - MASSIVE COVERAGE IMPROVEMENTS

**CRITICAL UPDATE:** Coverage analysis significantly understated API exposure. After deep-dive analyses, actual coverage is **81%**, not 42%.

**Key Discoveries:**
1. Portfolio Plans API covers 13+ sections (pensions, protection, investments, savings, mortgages)
2. Unified Notes API covers all 10 note categories
3. Requirements microservice covers Goals + Risk Income
4. CRM APIs cover Contact Details, Address, Custom Questions

**See:** `steering/COVERAGE-CORRECTION-V4-ANALYSIS.md` for complete analysis

---

## Executive Summary

### Coverage Statistics (V4 CORRECTED)

| Category | Total Sections | DB Coverage | Entity Coverage | V3 API (Old) | **V4 API (Corrected)** | Grade Change |
|----------|---------------|-------------|-----------------|--------------|----------------------|--------------|
| **Client Profile** | 11 | 11 (100%) | 11 (100%) | ~~8 (73%)~~ | **10 (91%)** | B → **A-** |
| **Goals & Objectives** | 4 | 4 (100%) | 4 (100%) | ~~3 (75%)~~ | **4 (100%)** | B → **A+** |
| **Assets & Liabilities** | 9 | 7 (78%) | 7 (78%) | ~~3 (33%)~~ | **8 (89%)** | D → **B+** |
| **Credit & Budget** | 5 | 5 (100%) | 5 (100%) | ~~4 (80%)~~ | **5 (100%)** | B+ → **A+** |
| **Employment & Income** | 5 | 5 (100%) | 5 (100%) | 5 (100%) | **5 (100%)** | **A+** (unchanged) |
| **Risk Assessment (ATR)** | 8 | 8 (100%) | 8 (100%) | ~~2 (25%)~~ | **5 (63%)** | F → **C+** |
| **Plans & Providers** | 3 | 2 (67%) | 2 (67%) | ~~0 (0%)~~ | **3 (100%)** | F → **A+** ⭐ |
| **Protection & Insurance** | 3 | 3 (100%) | 3 (100%) | ~~0 (0%)~~ | **3 (100%)** | F → **A+** ⭐ |
| **Pensions & Retirement** | 13 | 11 (85%) | 11 (85%) | ~~1 (8%)~~ | **13 (100%)** | F → **A+** ⭐ |
| **Savings & Investments** | 1 | 1 (100%) | 1 (100%) | ~~0 (0%)~~ | **1 (100%)** | F → **A+** ⭐ |
| **TOTAL** | **62** | **57 (92%)** | **57 (92%)** | ~~**26 (42%)**~~ | **50 (81%)** ⭐ | **+24 sections** |

### Key Findings (V4 CORRECTED)

**MAJOR SUCCESSES:**
- **Excellent API coverage**: 81% of sections have REST APIs (was thought to be 42%)
- **Plans domain complete**: Portfolio Plans API covers pensions, protection, investments, savings, mortgages (1,773 plan types)
- **Notes unified**: Single discriminator-based API covers all 10 note categories
- **Goals modern**: Requirements microservice provides gold-standard architecture
- **Employment & Income**: Remains 100% coverage gold standard

**REMAINING GAPS (ONLY 12 SECTIONS):**
- Credit History, Affordability, Risk Questionnaire, Risk Replay, Supplementary Questions APIs
- Direct Asset API (partial coverage via Plans API)
- Some calculated views

**REVISED ASSESSMENT:**
- Original: "System has critical 58% API exposure gap"
- Corrected: "System has excellent 81% API coverage with targeted gaps"
- Impact: V3 development reduced from 10+ months to 5 months

---

## Detailed Coverage Matrix

### 1. Client Profile Sections (CRM Domain)

These sections belong to the **Client Domain** (CRM-owned) managing WHO the client is.

| # | Section Name | DB Table(s) | Schema | Entity/Model | API Endpoint(s) | Coverage Status | Notes |
|---|--------------|-------------|--------|--------------|-----------------|-----------------|-------|
| 1 | **Vulnerability** | TCRMContact, TClientVulnerability | CRM | ClientVulnerability | WebClient: ClientController | **COMPLETE** | Vulnerability flags, assessment dates |
| 2 | **Data Protection** | TCRMContact, TDataProtectionAct, TCRMContactDpaQuestions | CRM | DataProtectionAct, CRMContact | WebClient: ClientController | **COMPLETE** | GDPR preferences, DPA questions |
| 3 | **Contact Details** | TAddress, TContactDetail, TEmail | CRM | Address, ContactDetail, Email | WebClient: ClientController | **COMPLETE** | Addresses, phones, emails |
| 4 | **Personal** | TPerson (PersonId via TCRMContact) | CRM | Person | WebClient: ClientController | **COMPLETE** | Name, DOB, NI Number, demographics |
| 5 | **Trust** | TTrust (TrustId via TCRMContact) | CRM | Trust | WebClient: ClientController | **COMPLETE** | Trust details, trust type |
| 6 | **Corporate** | TCorporate (CorporateId via TCRMContact) | CRM | Corporate | WebClient: ClientController | **COMPLETE** | Company registration, VAT |
| 7 | **Marketing** | TMarketing | CRM | Marketing | WebClient: ClientController | **COMPLETE** | Marketing preferences, campaign source |
| 8 | **ID Verification** | TVerification, TVerificationHistory | CRM | Verification | WebClient: ClientController | **COMPLETE** | ID checks, verification status |
| 9 | **Estate Planning** | TEstatePlanning | CRM | EstatePlanning | **MISSING API** | **PARTIAL** | Estate planning details exist in DB |
| 10 | **Tax Details** | TPerson (TaxCode, NI Number, Domicile, Residency) | CRM | Person | WebClient: ClientController | **COMPLETE** | Tax code, domicile, residency |
| 11 | **Current Position** | TCRMContact (Status, ServiceStatus, ServiceStatusStartDate) | CRM | CRMContact | WebClient: ClientController | **COMPLETE** | Client status, service status |

**Client Profile Coverage:** 8/11 complete (73%)

**Notes:**
- Estate Planning has DB table but no dedicated API endpoint
- Most client profile data accessible via WebClient ClientController
- Party hierarchy (Person/Corporate/Trust) uses discriminator pattern in TCRMContact

---

### 2. Goals & Objectives (FactFind Domain)

| # | Section Name | DB Table(s) | Schema | Entity/Model | API Endpoint(s) | Coverage Status | Notes |
|---|--------------|-------------|--------|--------------|-----------------|-----------------|-------|
| 12 | **Goals** | TObjective | FactFind | Goal | Monolith.FactFind v1: GoalController<br>WebClient: ObjectiveController | **COMPLETE** | Financial goals, target amounts, dates |
| 13 | **Needs & Priorities** | TNeedsAndPriorities, TNeedsAndPrioritiesAnswer, TNeedsAndPrioritiesQuestion | FactFind | NeedsAndPriorities | **MISSING API** | **PARTIAL** | Needs analysis questions exist in DB |
| 14 | **Custom Questions** | TNeedsAndPrioritiesQuestion (configurable) | FactFind | NeedsAndPrioritiesQuestion | **MISSING API** | **PARTIAL** | Configurable needs questions |
| 15 | **Dependants** | TDependants | FactFind | Dependant | Monolith.FactFind v1: DependantController<br>Monolith.FactFind v2: DependantController | **COMPLETE** | Financial dependants |

**Goals & Objectives Coverage:** 3/4 complete (75%)

**Notes:**
- Needs & Priorities and Custom Questions have DB schema but no API exposure
- These are configurable question frameworks for needs analysis
- Dependants has both v1 and v2 API versions

---

### 3. Assets & Liabilities (FactFind Domain)

| # | Section Name | DB Table(s) | Schema | Entity/Model | API Endpoint(s) | Coverage Status | Notes |
|---|--------------|-------------|--------|--------------|-----------------|-----------------|-------|
| 16 | **Asset** | TAssets, TAssetCategory | FactFind | Asset (not in Hibernate - may be NIO only) | **MISSING API** | **PARTIAL** | Property, savings, investments, vehicles |
| 17 | **Liability** | TLiabilities | FactFind | Liability | Monolith.FactFind v1: LiabilityController | **COMPLETE** | Debts, loans, mortgages, credit cards |
| 18 | **Credit History (A&L)** | TCreditHistory | FactFind | CreditHistory (not in Hibernate) | **MISSING API** | **PARTIAL** | Credit history within A&L context |
| 19 | **Asset/Liabilities** | TAssets + TLiabilities (Combined view) | FactFind | Combined view entity | **MISSING API** | **PARTIAL** | Net worth calculation view |
| 20 | **Property Details** | TPropertyDetail, TProperties | FactFind | PropertyDetail | **MISSING API** | **PARTIAL** | Property-specific attributes |
| 21 | **Mortgages (Under Property)** | TMortgages | FactFind | Mortgage (not in Hibernate) | **MISSING API** | **PARTIAL** | Property-specific mortgages |
| 22 | **Mortgages (Standalone)** | TMortgages | FactFind | Mortgage | **MISSING API** | **PARTIAL** | General mortgage tracking |
| 23 | **Equities** | TAssets (where AssetCategory = Equities) | FactFind | Asset filtered | **MISSING API** | **PARTIAL** | Equity holdings as asset type |
| 24 | **Notes (A&L section)** | TBudgetMiscellaneous (AssetLiabilityNotes column) | FactFind | AssetLiabilityNotes | **MISSING API** | **PARTIAL** | ISSUE: Shared table |

**Assets & Liabilities Coverage:** 3/9 complete (33%)

**Notes:**
- Only Liability has complete API coverage
- Asset, Property, Mortgage, Equities have DB tables but no dedicated APIs
- AssetLiabilityNotes shares TBudgetMiscellaneous table (technical debt)
- Many of these may be accessible via WebClient but not exposed via Monolith.FactFind APIs

---

### 4. Credit & Budget (FactFind Domain)

| # | Section Name | DB Table(s) | Schema | Entity/Model | API Endpoint(s) | Coverage Status | Notes |
|---|--------------|-------------|--------|--------------|-----------------|-----------------|-------|
| 25 | **Credit History** | TCreditHistory | FactFind | CreditHistory | **MISSING API** | **PARTIAL** | Bankruptcy, CCJs, IVAs |
| 26 | **Budget** | TBudget | FactFind | Budget | Monolith.FactFind v1: BudgetController | **COMPLETE** | Budget planning |
| 27 | **Expenditure** | TExpenditure, TExpenditureDetail | FactFind | Expenditure, Expense | Monolith.FactFind v1: ExpenditureController<br>Monolith.FactFind v2: ExpenditureController | **COMPLETE** | Monthly expenditure by category |
| 28 | **Income** | TDetailedIncomeBreakdown | FactFind | Income | Monolith.FactFind v1: IncomeController<br>Monolith.FactFind v2: IncomeController | **COMPLETE** | Income sources and amounts |
| 29 | **Affordability** | TAffordability | FactFind | Affordability (not in Hibernate) | **MISSING API** | **PARTIAL** | Affordability calculations |

**Credit & Budget Coverage:** 4/5 complete (80%)

**Notes:**
- Excellent coverage for Budget, Expenditure, Income (all have v1 and v2 APIs)
- Credit History and Affordability have DB tables but no API endpoints
- Affordability likely calculated from Income + Expenditure data

---

### 5. Employment & Income (FactFind Domain)

| # | Section Name | DB Table(s) | Schema | Entity/Model | API Endpoint(s) | Coverage Status | Notes |
|---|--------------|-------------|--------|--------------|-----------------|-----------------|-------|
| 30 | **Employment** | TEmploymentDetail | FactFind | Employment, EmploymentStatus (hierarchy) | Monolith.FactFind v1: EmploymentController<br>Monolith.FactFind v2: EmploymentController | **COMPLETE** | ISSUE: Dual-entity mapping |
| 31 | **Employment Details** | TEmploymentDetail | FactFind | SalariedEmploymentStatus, ProfitBasedEmploymentStatus | Monolith.FactFind v1: EmploymentController<br>Monolith.FactFind v2: EmploymentController | **COMPLETE** | Polymorphic employment types |
| 32 | **Total Earned Income** | TDetailedIncomeBreakdown (aggregated) | FactFind | Income (aggregated view) | Monolith.FactFind v1: IncomeController<br>Monolith.FactFind v2: IncomeController | **COMPLETE** | Calculated from income sources |
| 33 | **Tax Rate** | TEmploymentDetail (implicit from income) + TPerson (TaxCode) | FactFind + CRM | EmploymentStatus, Person | Monolith.FactFind v1: EmploymentController | **COMPLETE** | Tax code in CRM, tax calcs from income |
| 34 | **Notes (Employment section)** | TEmploymentNote | FactFind | EmploymentNotes | Monolith.FactFind v2: NotesController | **COMPLETE** | Employment notes |

**Employment & Income Coverage:** 5/5 complete (100%)

**Notes:**
- PERFECT END-TO-END COVERAGE: All sections have DB, entities, and APIs
- Both v1 and v2 APIs available for Employment and Income
- v2 NotesController provides access to employment notes
- CRITICAL ISSUE: TEmploymentDetail has dual-entity mapping (Employment + EmploymentStatus hierarchy)

---

### 6. Risk Assessment / ATR (FactFind Domain / ATR Domain)

| # | Section Name | DB Table(s) | Schema | Entity/Model | API Endpoint(s) | Coverage Status | Notes |
|---|--------------|-------------|--------|--------------|-----------------|-----------------|-------|
| 35 | **Risk Questionnaire** | TAtrQuestion, TAtrAnswer, TAtrCategory | FactFind | AtrQuestion (not in Hibernate) | **MISSING API** | **PARTIAL** | Risk profile questionnaires |
| 36 | **Risk Replay** | TAtrInvestment, TAtrRetirement | FactFind | AtrInvestmentGeneral, AtrRetirementGeneral | **MISSING API** | **PARTIAL** | Historical risk assessments |
| 37 | **Risk Income** | TObjective (with risk profile fields) | FactFind | Goal | Monolith.FactFind v1: GoalController | **COMPLETE** | Goals with risk considerations |
| 38 | **Supplementary Questions (Risk)** | TAtrQuestion (supplementary types) | FactFind | AtrQuestion | **MISSING API** | **PARTIAL** | Additional risk questions |
| 39 | **Supplementary Questions (General)** | TAdditionalRiskQuestion, TAdditionalRiskQuestionResponse | FactFind | AdditionalRiskQuestion | **MISSING API** | **PARTIAL** | General supplementary questions |
| 40 | **Declaration** | TDeclaration | FactFind | Declaration | Monolith.FactFind v1: DeclarationController | **COMPLETE** | Regulatory declarations |
| 41 | **Completion** | TFactFind (completion status implied) | FactFind | ClientFactFind | Monolith.FactFind v1: FactFindController | **COMPLETE** | FactFind completion tracking |
| 42 | **Notes (Risk section)** | TProtectionMiscellaneous, TRetirementNextSteps, TSavingsNextSteps | FactFind | ProtectionNotes, RetirementNotes, InvestmentNotes | Monolith.FactFind v2: NotesController | **COMPLETE** | Risk/advice notes per area |

**Risk Assessment Coverage:** 4/8 complete (50%) - Updated from 2/8 after notes review

**Notes:**
- Full database and entity coverage for ATR system
- Very limited API exposure (only via Goals, Declaration, and Notes APIs)
- Risk questionnaire, answers, and profiles not exposed via APIs
- Most ATR functionality likely handled by WebClient controllers (RiskProfileController)
- ATR represents a separate bounded context with minimal API exposure

---

### 7. Existing Plans & Providers (PolicyManagement Domain)

| # | Section Name | DB Table(s) | Schema | Entity/Model | API Endpoint(s) | Coverage Status | Notes |
|---|--------------|-------------|--------|--------------|-----------------|-----------------|-------|
| 43 | **Existing Providers** | PolicyManagement schema (not analyzed) | PolicyMgmt | Provider entities | **MISSING API** | **UNKNOWN** | Likely in PolicyManagement schema |
| 44 | **Cash** | TCashDepositFFExt, TPreExistingCashDepositPlansQuestions | FactFind | Cash deposit plans | **MISSING API** | **PARTIAL** | Cash deposit holdings |
| 45 | **Notes (Plan section)** | Various plan note tables | FactFind | Plan notes | **MISSING API** | **PARTIAL** | Notes on existing plans |

**Plans & Providers Coverage:** 0/3 complete (0%)

**Notes:**
- This domain primarily lives in PolicyManagement schema (not fully analyzed)
- FactFind has extension tables (FFExt suffix) linking to PolicyManagement
- No dedicated APIs found in Monolith.FactFind
- PolicyManagement represents separate bounded context

---

### 8. Protection & Insurance (FactFind Domain / PolicyManagement)

| # | Section Name | DB Table(s) | Schema | Entity/Model | API Endpoint(s) | Coverage Status | Notes |
|---|--------------|-------------|--------|--------------|-----------------|-----------------|-------|
| 46 | **Protection & Insurance** | TProtectionGoalsNeeds, TProtectionCoverNeed | FactFind | ProtectionGoalsNeeds | **MISSING API** | **PARTIAL** | Protection needs analysis |
| 47 | **Existing Provisions** | TCurrentProtection, TExistingProvisionExt | FactFind | CurrentProtection | **MISSING API** | **PARTIAL** | Existing protection policies |
| 48 | **Notes (Protection section)** | TProtectionMiscellaneous | FactFind | ProtectionNotes | Monolith.FactFind v2: NotesController | **COMPLETE** | Protection advice notes |

**Protection & Insurance Coverage:** 1/3 complete (33%) - Updated after notes review

**Notes:**
- Full database schema for protection needs analysis
- Entities exist but not in core Hibernate mappings (may be NIO-specific)
- No dedicated protection APIs in Monolith.FactFind
- Protection notes accessible via v2 NotesController
- WebClient likely has protection controllers

---

### 9. Pensions & Retirement (FactFind Domain / PolicyManagement)

| # | Section Name | DB Table(s) | Schema | Entity/Model | API Endpoint(s) | Coverage Status | Notes |
|---|--------------|-------------|--------|--------------|-----------------|-----------------|-------|
| 49 | **Pensions & Investments** | Multiple pension tables | FactFind | Various pension entities | **MISSING API** | **PARTIAL** | Top-level pension section |
| 50 | **Notes (Pensions section)** | TRetirementNextSteps | FactFind | RetirementNotes | Monolith.FactFind v2: NotesController | **COMPLETE** | Retirement advice notes |
| 51 | **Existing Employers** | TEmploymentDetail (linked to pensions) | FactFind | Employment | Monolith.FactFind v1: EmploymentController | **COMPLETE** | Employers with pension schemes |
| 52 | **Pension Provision** | TOccupationalScheme, TNonOccupationalScheme | FactFind | Pension schemes | **MISSING API** | **PARTIAL** | Pension scheme details |
| 53 | **State Pension Entitlement** | TStatePensionEntitlement | FactFind | StatePensionEntitlement | **MISSING API** | **PARTIAL** | State pension forecasts |
| 54 | **Eligibility & Entitlement** | TStatePensionEntitlement, TPensionContributions | FactFind | Pension eligibility | **MISSING API** | **PARTIAL** | Pension eligibility rules |
| 55 | **Final Salary** | TFinalSalaryFFExt | FactFind | FinalSalaryFFExt | **MISSING API** | **PARTIAL** | Defined benefit pensions |
| 56 | **Final Salary Pension** | TFinalSalaryPensionsPlanFFExt | FactFind | FinalSalaryPensionsPlanFFExt | **MISSING API** | **PARTIAL** | Final salary pension plans |
| 57 | **Money Purchase** | TMoneyPurchaseFFExt | FactFind | MoneyPurchaseFFExt | **MISSING API** | **PARTIAL** | Defined contribution pensions |
| 58 | **Personal Pension** | TMoneyPurchasePensionPlanFFExt | FactFind | Personal pension plans | **MISSING API** | **PARTIAL** | Personal pension schemes |
| 59 | **Annuities** | Policy data (PolicyManagement) | PolicyMgmt | Annuity products | **MISSING API** | **UNKNOWN** | Annuity holdings |
| 60 | **Scheme** | TOccupationalScheme | FactFind | OccupationalScheme | **MISSING API** | **PARTIAL** | Generic pension scheme |
| 61 | **Notes (Pension details)** | TRetirementNextSteps | FactFind | RetirementNotes | Monolith.FactFind v2: NotesController | **COMPLETE** | Same as Pensions notes |

**Pensions & Retirement Coverage:** 3/13 complete (23%) - Updated after notes review

**Notes:**
- Comprehensive database schema for pension tracking
- Many FFExt (FactFind Extension) tables linking to PolicyManagement
- Minimal API exposure (only via Employment and Notes controllers)
- MAJOR GAP: No APIs for pension scheme details, state pension, final salary, money purchase
- Pension data likely exposed via WebClient but not as REST APIs

---

### 10. Savings & Investments (FactFind Domain / PolicyManagement)

| # | Section Name | DB Table(s) | Schema | Entity/Model | API Endpoint(s) | Coverage Status | Notes |
|---|--------------|-------------|--------|--------------|-----------------|-----------------|-------|
| 62 | **Savings & Investments** | TSavingsGoalsNeeds, TInvestmentGoals, TOtherInvestmentFFExt | FactFind | Savings/Investment goals | **MISSING API** | **PARTIAL** | Investment needs and goals |

**Savings & Investments Coverage:** 0/1 complete (0%)

**Notes:**
- Database tables exist for savings and investment goals
- No dedicated API endpoints found
- Investment notes accessible via Monolith.FactFind v2 NotesController
- Likely overlaps with Goals section

---

## Cross-Reference Tables

### Database Schema Distribution

| Schema | Tables Found | Percentage |
|--------|--------------|------------|
| FactFind | 45+ | 79% |
| CRM | 11 | 19% |
| PolicyManagement | Unknown | Unknown |
| ATR | Integrated in FactFind | N/A |
| Administration | Reference data only | N/A |

### API Endpoint Distribution

| API Source | Endpoints Found | Coverage Areas |
|------------|----------------|----------------|
| Monolith.FactFind v1 | 15 | Employment, Income, Expenditure, Budget, Goals, Dependants, Liabilities, Declaration, Disclosure, AdviceAreas |
| Monolith.FactFind v2 | 9 | Employment, Income, Expenditure, Dependants, Disclosure, Notes, ReferenceData |
| WebClient Controllers | 100+ | All areas (legacy monolith UI) |
| Monolith.CRM | Unknown | Client identity and profile |

### Hibernate Entity Distribution

| Entity Type | Count | Location |
|-------------|-------|----------|
| Core FactFind Entities | 37 | Monolith.FactFind/Domain/*.hbm.xml |
| CRM Entities | Unknown | Monolith.CRM |
| WebClient Entities | 237+ | IntelligentOffice (code analysis) |
| Reference Data | Multiple | Shared across schemas |

---

## Pattern Analysis

### Scattered Notes Pattern (Technical Debt)

Notes appear in MULTIPLE locations across different tables:

| Notes Type | DB Table | Column | Entity | API Access |
|------------|----------|--------|--------|------------|
| Profile Notes | TProfileNotes | Notes | ProfileNotes | v2: NotesController |
| Protection Notes | TProtectionMiscellaneous | Notes | ProtectionNotes | v2: NotesController |
| Retirement Notes | TRetirementNextSteps | NextSteps | RetirementNotes | v2: NotesController |
| Investment Notes | TSavingsNextSteps | NextSteps | InvestmentNotes | v2: NotesController |
| Mortgage Notes | TMortgageMiscellaneous | Notes | MortgageNotes | v2: NotesController |
| Estate Planning Notes | TEstateNextSteps | NextSteps | EstatePlanningNotes | v2: NotesController |
| Budget Notes | TBudgetMiscellaneous | BudgetNotes | BudgetNotes | **MISSING** |
| Asset/Liability Notes | TBudgetMiscellaneous | AssetLiabilityNotes | AssetLiabilityNotes | **MISSING** |
| Employment Notes | TEmploymentNote | Note | EmploymentNotes | v2: NotesController |
| Summary Notes | TDeclarationNotes | DeclarationNotes | SummaryNotes | v2: NotesController |

**ISSUE:** TBudgetMiscellaneous table contains BOTH BudgetNotes AND AssetLiabilityNotes (table sharing anti-pattern)

**POSITIVE:** v2 NotesController provides unified API access to most notes types

### Dual-Entity Mapping Pattern (Technical Debt)

**TEmploymentDetail table** is mapped to MULTIPLE entities:
- Employment (flat entity)
- EmploymentStatus (abstract base with discriminator)
  - SalariedEmploymentStatus
  - ProfitBasedEmploymentStatus
  - NotEmployedEmploymentStatus

**Impact:** Confusing model, evolution difficulty, maintenance burden

### Extension Table Pattern (Integration)

Many tables have **FFExt** suffix indicating FactFind extensions linking to PolicyManagement:
- TFinalSalaryFFExt
- TMoneyPurchaseFFExt
- TPersonFFExt
- TPolicyFFExt
- TCashDepositFFExt
- TEquityReleaseExtExt
- etc.

**Purpose:** Bridge between FactFind domain and PolicyManagement domain

---

## Recommendations for V3 API Design

### Priority 1: Fill Critical API Gaps (HIGH)

**Missing Complete Domains:**
1. **Assets** - Create `/clients/{clientId}/assets` endpoint
2. **Properties** - Create `/clients/{clientId}/properties` endpoint
3. **Credit History** - Create `/clients/{clientId}/credit-history` endpoint
4. **Pension Schemes** - Create `/clients/{clientId}/pensions` endpoint family
5. **Protection Needs** - Create `/clients/{clientId}/protection-needs` endpoint
6. **Savings Goals** - Create `/clients/{clientId}/savings` endpoint

**Rationale:** These sections have complete DB/entity coverage but no API exposure

### Priority 2: Rationalize Notes Pattern (MEDIUM)

**Current State:** Notes scattered across 10+ tables with inconsistent design

**V3 Approach:**
- Unified `/clients/{clientId}/notes` endpoint with `noteType` parameter
- Or: Domain-specific notes endpoints: `/clients/{clientId}/employment/notes`, `/clients/{clientId}/protection/notes`
- Consolidate TBudgetMiscellaneous table (separate budget notes from asset/liability notes)

**v2 NotesController** is a good start but needs expansion

### Priority 3: Expose Existing Pension Data (HIGH)

**Gap:** Comprehensive pension tables exist but only 8% API exposure

**V3 Endpoints Needed:**
- `/clients/{clientId}/pensions/state-pension` - State pension entitlement
- `/clients/{clientId}/pensions/occupational` - Occupational schemes
- `/clients/{clientId}/pensions/personal` - Personal pensions
- `/clients/{clientId}/pensions/final-salary` - Defined benefit
- `/clients/{clientId}/pensions/money-purchase` - Defined contribution

### Priority 4: Separate Client vs FactFind APIs (ARCHITECTURAL)

**Current Confusion:** Client profile data mixed with FactFind data

**V3 Separation:**

**Client API (CRM-owned):**
- `/clients/{clientId}` - Client identity
- `/clients/{clientId}/demographics`
- `/clients/{clientId}/addresses`
- `/clients/{clientId}/contacts`
- `/clients/{clientId}/relationships`
- `/clients/{clientId}/vulnerability`

**FactFind API (FactFind-owned):**
- `/clients/{clientId}/factfinds/{factfindId}` - Root
- `/clients/{clientId}/factfinds/{factfindId}/employment`
- `/clients/{clientId}/factfinds/{factfindId}/income`
- `/clients/{clientId}/factfinds/{factfindId}/expenditure`
- `/clients/{clientId}/factfinds/{factfindId}/assets`
- `/clients/{clientId}/factfinds/{factfindId}/liabilities`
- `/clients/{clientId}/factfinds/{factfindId}/goals`
- `/clients/{clientId}/factfinds/{factfindId}/dependants`
- `/clients/{clientId}/factfinds/{factfindId}/pensions`
- `/clients/{clientId}/factfinds/{factfindId}/protection`

### Priority 5: ATR as Separate Service (ARCHITECTURAL)

**Observation:** ATR has complete DB schema but minimal API exposure

**V3 Approach:**
- Extract ATR as microservice
- Provide dedicated ATR API:
  - `/atr/questionnaires`
  - `/atr/assessments/{clientId}`
  - `/atr/profiles/{clientId}`
  - `/atr/templates`

### Priority 6: Reference Data Unification (MEDIUM)

**Current State:** Reference data scattered (TRefData, TRefExpenditureType, etc.)

**V3 Approach:**
- Unified reference data API: `/refdata/{domain}/{type}`
- Examples:
  - `/refdata/factfind/expenditure-categories`
  - `/refdata/factfind/income-types`
  - `/refdata/pensions/scheme-types`

**v2 ReferenceDataController** is a good start

---

## Action Items

### Immediate Actions

1. **Document the 5 missing database tables** - Identify why 5 sections have no DB tables
2. **Analyze PolicyManagement schema** - Understand Plans, Providers, Annuities coverage
3. **Audit WebClient controllers** - Map which sections are accessible via WebClient
4. **Test existing v1/v2 APIs** - Verify actual coverage vs documented coverage

### Short-Term (1-3 months)

1. Create Assets API endpoints
2. Create Properties API endpoints
3. Create Pensions API family
4. Extend Notes API to cover all note types
5. Create Credit History API

### Medium-Term (3-6 months)

1. Create Protection Needs API
2. Create Savings & Investments API
3. Extract ATR as separate service
4. Rationalize reference data APIs
5. Separate Client vs FactFind API boundaries

### Long-Term (6-12 months)

1. Refactor dual-entity mapping (TEmploymentDetail)
2. Consolidate notes pattern
3. Split TBudgetMiscellaneous table
4. Full microservices architecture with clear bounded contexts
5. Deprecate v1 APIs in favor of v3

---

## Appendix: Section to Database Table Mapping

### Complete Mapping List

```
Client Profile (CRM Schema):
  Vulnerability → TClientVulnerability, TCRMContact
  Data Protection → TDataProtectionAct, TCRMContactDpaQuestions
  Contact Details → TAddress, TContactDetail, TEmail
  Personal → TPerson
  Trust → TTrust
  Corporate → TCorporate
  Marketing → TMarketing
  ID Verification → TVerification, TVerificationHistory
  Estate Planning → TEstatePlanning
  Tax Details → TPerson (TaxCode, Domicile, Residency)
  Current Position → TCRMContact (Status fields)

Goals & Objectives (FactFind Schema):
  Goals → TObjective
  Needs & Priorities → TNeedsAndPriorities, TNeedsAndPrioritiesAnswer
  Custom Questions → TNeedsAndPrioritiesQuestion
  Dependants → TDependants

Assets & Liabilities (FactFind Schema):
  Asset → TAssets, TAssetCategory
  Liability → TLiabilities
  Credit History → TCreditHistory
  Property Details → TPropertyDetail, TProperties
  Mortgages → TMortgages
  Equities → TAssets (filtered)
  Notes → TBudgetMiscellaneous (AssetLiabilityNotes)

Credit & Budget (FactFind Schema):
  Credit History → TCreditHistory, TBankruptcy, TCCJ, TIVA
  Budget → TBudget
  Expenditure → TExpenditure, TExpenditureDetail
  Income → TDetailedIncomeBreakdown
  Affordability → TAffordability

Employment & Income (FactFind Schema):
  Employment → TEmploymentDetail
  Employment Details → TEmploymentDetail (with polymorphism)
  Total Earned Income → TDetailedIncomeBreakdown (aggregated)
  Tax Rate → TEmploymentDetail + TPerson
  Notes → TEmploymentNote

Risk Assessment (FactFind Schema):
  Risk Questionnaire → TAtrQuestion, TAtrAnswer
  Risk Replay → TAtrInvestment, TAtrRetirement
  Risk Income → TObjective (with risk fields)
  Supplementary Questions → TAdditionalRiskQuestion
  Declaration → TDeclaration
  Completion → TFactFind
  Notes → TProtectionMiscellaneous, TRetirementNextSteps, TSavingsNextSteps

Plans & Providers (FactFind/PolicyManagement):
  Existing Providers → PolicyManagement schema
  Cash → TCashDepositFFExt
  Notes → Various plan note tables

Protection & Insurance (FactFind Schema):
  Protection & Insurance → TProtectionGoalsNeeds
  Existing Provisions → TCurrentProtection, TExistingProvisionExt
  Notes → TProtectionMiscellaneous

Pensions & Retirement (FactFind/PolicyManagement):
  Multiple pension tables → TOccupationalScheme, TNonOccupationalScheme, TStatePensionEntitlement, TFinalSalaryFFExt, TMoneyPurchaseFFExt, etc.
  Notes → TRetirementNextSteps

Savings & Investments (FactFind Schema):
  Savings & Investments → TSavingsGoalsNeeds, TInvestmentGoals
```

---

**Document Status:** COMPLETE
**Next Steps:** Create FactFind-Coverage-Gaps.md for gap analysis and prioritization
