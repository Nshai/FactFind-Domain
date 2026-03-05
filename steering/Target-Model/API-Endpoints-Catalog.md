# FactFind API v3.0 - Hierarchical Endpoints Catalog

**Document Purpose:** Comprehensive quick-reference catalog of all API endpoints in the hierarchical FactFind API Design v3.0

**Date:** 2026-03-05
**API Version:** v3.0
**Base URL:** `https://api.factfind.com`

**Architecture:** RESTful hierarchy with context-driven resource nesting

---

## Table of Contents

0. [API v3.0 Key Conventions](#api-v30-key-conventions)
1. [FactFind Root API](#1-factfind-root-api)
2. [Client Onboarding & KYC Context](#2-client-onboarding--kyc-context)
3. [Circumstances Context](#3-circumstances-context)
4. [Assets & Liabilities Context](#4-assets--liabilities-context)
5. [Plans & Investments Context](#5-plans--investments-context)
6. [Goals Context](#6-goals-context)
7. [ATR Context](#7-atr-context)
8. [Reference Data API](#8-reference-data-api)
9. [Summary Statistics](#summary-statistics)

---

## 1. FactFind Root API

**Base Path:** `/api/v3/factfinds`

**Description:** Root-level operations for managing fact find lifecycle and aggregated views.

### Core FactFind Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds` | List all fact finds | ⭐ Supports filtering (e.g., ?filter=clients.id eq 123) |
| POST | `/api/v3/factfinds` | Create new fact find | ⭐ Returns complete factfind with clients, meeting, disclosures |
| GET | `/api/v3/factfinds/{id}` | Get fact find by ID | ⭐ Includes clients, meeting, disclosures |
| PUT | `/api/v3/factfinds/{id}` | Update fact find | ⭐ Full update of factfind |

### Aggregated Views

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/complete` | Get complete fact find | All nested data |
| GET | `/api/v3/factfinds/{id}/current-position` | Get current financial position | Summary view |
| GET | `/api/v3/factfinds/{id}/net-worth` | Get net worth breakdown | Assets - Liabilities |
| GET | `/api/v3/factfinds/{id}/financial-health` | Get financial health score | Calculated metrics |
| GET | `/api/v3/factfinds/{id}/cash-flow` | Get cash flow analysis | Income - Expenditure |
| GET | `/api/v3/factfinds/{id}/asset-allocation` | Get asset allocation | Portfolio breakdown |

### Control Options

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/controloptions` | Get all control options | ⭐ Section gating |
| PUT | `/api/v3/factfinds/{id}/controloptions/assets` | Update assets control options | ⭐ Has assets flag |
| PUT | `/api/v3/factfinds/{id}/controloptions/liabilities` | Update liabilities control options | ⭐ Debt reduction strategy |
| PUT | `/api/v3/factfinds/{id}/controloptions/investments` | Update investments control options | ⭐ Cash & investments |
| PUT | `/api/v3/factfinds/{id}/controloptions/pensions` | Update pensions control options | ⭐ All pension types |
| PUT | `/api/v3/factfinds/{id}/controloptions/protections` | Update protections control options | ⭐ Protection products |
| PUT | `/api/v3/factfinds/{id}/controloptions/mortgages` | Update mortgages control options | ⭐ Mortgages & equity release |

**Total Endpoints:** 17

---

## 2. Client Onboarding & KYC Context

**Base Path:** `/api/v3/factfinds/{id}/clients`

**Description:** Client-centric operations for onboarding, identity verification, consent management, and KYC data collection.

### Core Client Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients` | List clients | Multiple clients per factfind |
| POST | `/api/v3/factfinds/{id}/clients` | Add client to factfind | ⭐ Supports multiple clients |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}` | Get client details | Full client record |
| PATCH | `/api/v3/factfinds/{id}/clients/{clientId}` | Update client | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}` | Remove client | Cascade delete nested data |

### Address Management

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/addresses` | List addresses | Current + historical |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/addresses` | Add address | Supports multiple |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/addresses/{addressId}` | Get address details | ⭐ Individual address |
| PATCH | `/api/v3/factfinds/{id}/clients/{clientId}/addresses/{addressId}` | Update address | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/addresses/{addressId}` | Delete address | Soft delete |

### Contact Management

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/contacts` | List contacts | Phone, email, etc. |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/contacts` | Add contact | Multiple contacts |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/contacts/{contactId}` | Get contact details | ⭐ Individual contact |
| PATCH | `/api/v3/factfinds/{id}/clients/{clientId}/contacts/{contactId}` | Update contact | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/contacts/{contactId}` | Delete contact | Soft delete |

### Professional Contacts

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/professional-contacts` | List professional contacts | Solicitors, accountants |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/professional-contacts` | Add professional contact | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/professional-contacts/{contactId}` | Get professional contact | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/clients/{clientId}/professional-contacts/{contactId}` | Update professional contact | ⭐ New in v3.0 |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/professional-contacts/{contactId}` | Delete professional contact | ⭐ New in v3.0 |

### Estate Planning

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/estateplanning` | Get estate planning singleton | ⭐ Includes gifts array |
| PUT | `/api/v3/factfinds/{id}/clients/{clientId}/estateplanning` | Update estate planning | ⭐ IHT planning |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/estateplanning/gifts` | Create new gift | ⭐ Record PETs |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/estateplanning/gifts/{giftId}` | Get specific gift | ⭐ View details |
| PUT | `/api/v3/factfinds/{id}/clients/{clientId}/estateplanning/gifts/{giftId}` | Update gift | ⭐ Modify exemptions |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/estateplanning/gifts/{giftId}` | Delete gift | ⭐ Remove record |
### Relationships

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/relationships` | List relationships | ⭐ New in v3.0 |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/relationships` | Add relationship | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Get relationship | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Update relationship | ⭐ New in v3.0 |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Delete relationship | ⭐ New in v3.0 |

### DPA Agreements

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/dpa-agreements` | Create DPA agreement | ⭐ GDPR compliance |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/dpa-agreements` | List all DPA agreements | ⭐ Pagination support |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/dpa-agreements/{agreementId}` | Get specific DPA agreement | ⭐ Use 'current' for latest |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/dpa-agreements/{agreementId}` | Delete DPA agreement | ⭐ Use with caution |

### Financial Profile

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/financial-profile` | Get financial profile | ⭐ Singleton resource |
| PUT | `/api/v3/factfinds/{id}/clients/{clientId}/financial-profile` | Update financial profile | ⭐ Summary of finances |

### Client Relationships

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/relationships` | Create client relationship | ⭐ Link clients |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/relationships` | List all relationships | ⭐ Family & partners |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Get specific relationship | ⭐ View details |
| PUT | `/api/v3/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Update relationship | ⭐ Change permissions |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Delete relationship | ⭐ Unlink clients |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/data` | Right to be forgotten (RTBF) | ⭐ GDPR compliance |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/data/export` | Data portability request | ⭐ GDPR compliance |

### Marketing Preferences

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/marketing-preferences` | Get marketing preferences | ⭐ Singleton resource per client |
| PUT | `/api/v3/factfinds/{id}/clients/{clientId}/marketing-preferences` | Update marketing preferences | ⭐ PECR/GDPR compliance |

### Vulnerabilities

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/vulnerabilities` | List all client vulnerabilities | ⭐ FCA compliance |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/vulnerabilities` | Create a vulnerability | ⭐ FCA compliance |
| PUT | `/api/v3/factfinds/{id}/clients/{clientId}/vulnerabilities/{vulnerabilityId}` | Update a vulnerability | ⭐ New in v3.0 |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/vulnerabilities/{vulnerabilityId}` | Delete a vulnerability | ⭐ New in v3.0 |

### Dependants

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/dependants` | List dependants | ⭐ New in v3.0 |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/dependants` | Add dependant | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/dependants/{dependantId}` | Get dependant details | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/clients/{clientId}/dependants/{dependantId}` | Update dependant | ⭐ New in v3.0 |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/dependants/{dependantId}` | Delete dependant | ⭐ New in v3.0 |

### Identity Verification

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/id-verification` | Get identity verification details | ⭐ Singleton resource per client |
| PUT | `/api/v3/factfinds/{id}/clients/{clientId}/id-verification` | Update identity verification details | ⭐ MLR 2017 / KYC/AML |

### Credit History

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/credithistory` | Get credit history | ⭐ Singleton per client |
| PUT | `/api/v3/factfinds/{id}/clients/{clientId}/credithistory` | Update credit history | ⭐ Adverse flags calculated |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/credithistory/events` | Create adverse credit event | ⭐ CCJ, Default, IVA, etc. |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/credithistory/events/{eventId}` | Get adverse credit event | ⭐ Event details |
| PUT | `/api/v3/factfinds/{id}/clients/{clientId}/credithistory/events/{eventId}` | Update adverse credit event | ⭐ Mark satisfied/cleared |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/credithistory/events/{eventId}` | Delete adverse credit event | ⭐ Remove event |

### Pension Summary

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/pension-summary` | Get pension summary | ⭐ New in v3.0 |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/pension-summary/calculate` | Calculate pension projection | ⭐ New in v3.0 |

**Total Endpoints:** 101

---

## 3. Circumstances Context

**Base Path:** `/api/v3/factfinds/{id}/clients/{clientId}`

**Description:** Client-specific circumstances including employment, income, and expenditure. These resources are nested under clients as they are personal to each client.

### Employment

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/employment` | List employment history | ⭐ Hierarchical |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/employment` | Add employment record | ⭐ Hierarchical |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/employment/{employmentId}` | Get employment details | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/clients/{clientId}/employment/{employmentId}` | Update employment | ⭐ New in v3.0 |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/employment/{employmentId}` | Delete employment | ⭐ New in v3.0 |

### Employment Summary

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/employments/summary` | Get employment summary | ⭐ Singleton per client |
| PUT | `/api/v3/factfinds/{id}/clients/{clientId}/employments/summary` | Update employment summary | ⭐ Total income calculated |

### Income

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/income` | List income sources | ⭐ Hierarchical |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/income` | Add income source | ⭐ Hierarchical |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/income/{incomeId}` | Get income details | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/clients/{clientId}/income/{incomeId}` | Update income | ⭐ New in v3.0 |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/income/{incomeId}` | Delete income | ⭐ New in v3.0 |

### Income Changes

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/income-changes` | List income changes | ⭐ New in v3.0 |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/income-changes` | Record income change | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/income-changes/{changeId}` | Get income change details | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/clients/{clientId}/income-changes/{changeId}` | Update income change | ⭐ New in v3.0 |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/income-changes/{changeId}` | Delete income change | ⭐ New in v3.0 |

### Expenditure

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/expenditure` | List expenditure items | ⭐ Hierarchical |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/expenditure` | Add expenditure | ⭐ Hierarchical |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/expenditure/{expenditureId}` | Get expenditure details | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/clients/{clientId}/expenditure/{expenditureId}` | Update expenditure | ⭐ New in v3.0 |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/expenditure/{expenditureId}` | Delete expenditure | ⭐ New in v3.0 |

### Expenditure Changes

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/expenditure-changes` | List expenditure changes | ⭐ New in v3.0 |
| POST | `/api/v3/factfinds/{id}/clients/{clientId}/expenditure-changes` | Record expenditure change | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/expenditure-changes/{changeId}` | Get expenditure change | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/clients/{clientId}/expenditure-changes/{changeId}` | Update expenditure change | ⭐ New in v3.0 |
| DELETE | `/api/v3/factfinds/{id}/clients/{clientId}/expenditure-changes/{changeId}` | Delete expenditure change | ⭐ New in v3.0 |

### Budget Summary

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/clients/{clientId}/budget` | Get budget summary | ⭐ Hierarchical |

**Total Endpoints:** 28 (28 new in v3.0)

---

## 4. Assets & Liabilities Context

**Base Path:** `/api/v3/factfinds/{id}/assets`

**Description:** Factfind-level assets and liabilities. Assets can be jointly owned by multiple clients within the same factfind.

### Assets

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/assets` | List all assets | ⭐ Hierarchical |
| POST | `/api/v3/factfinds/{id}/assets` | Add asset | ⭐ Hierarchical |
| GET | `/api/v3/factfinds/{id}/assets/{assetId}` | Get asset details | ⭐ With embedded details |
| PATCH | `/api/v3/factfinds/{id}/assets/{assetId}` | Update asset | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/assets/{assetId}` | Delete asset | ⭐ Soft delete |

### Liabilities

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/liabilities` | List all liabilities | ⭐ New in v3.0 |
| POST | `/api/v3/factfinds/{id}/liabilities` | Add liability | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/liabilities/{liabilityId}` | Get liability details | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/liabilities/{liabilityId}` | Update liability | ⭐ New in v3.0 |
| DELETE | `/api/v3/factfinds/{id}/liabilities/{liabilityId}` | Delete liability | ⭐ New in v3.0 |

### Property Details (Embedded in Assets)

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/assets/{assetId}/property-detail` | Get property detail | ⭐ For asset_type=property |
| PATCH | `/api/v3/factfinds/{id}/assets/{assetId}/property-detail` | Update property detail | ⭐ Embedded detail |
| GET | `/api/v3/factfinds/{id}/assets/{assetId}/property-detail/valuations` | Get valuation history | ⭐ Property valuations |
| POST | `/api/v3/factfinds/{id}/assets/{assetId}/property-detail/valuations` | Add property valuation | ⭐ New valuation |
| GET | `/api/v3/factfinds/{id}/assets/{assetId}/property-detail/capital-gains` | Calculate CGT | ⭐ Tax calculation |--------|----------|-------------|-------|

### Aggregated Views

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/assets/summary` | Get assets summary | ⭐ Aggregated totals |
| GET | `/api/v3/factfinds/{id}/liabilities/summary` | Get liabilities summary | ⭐ Aggregated totals |
| GET | `/api/v3/factfinds/{id}/net-worth` | Calculate net worth | ⭐ Assets - Liabilities |

**Total Endpoints:** 23 (23 new in v3.0)

**Note:** Rental yield values are calculated and stored as part of the property details contract. No separate calculation endpoint is provided.

---

## 5. Plans & Investments Context

**Base Path:** `/api/v3/factfinds/{id}/investments`

**Description:** Comprehensive investment management including investment accounts, life-assured investments, cash bank accounts, and investment bonds. Supports multi-category investments with flexible contribution tracking and fund holdings management.

### Core Investment Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/investments` | List all investments | ⭐ Supports filtering by category |
| POST | `/api/v3/factfinds/{id}/investments` | Create investment | ⭐ All investment types |
| GET | `/api/v3/factfinds/{id}/investments/{investmentId}` | Get investment details | ⭐ Full investment record |
| PATCH | `/api/v3/factfinds/{id}/investments/{investmentId}` | Update investment | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/investments/{investmentId}` | Delete investment | ⭐ Soft delete |

**Investment Categories:**
- **CashBankAccount** - Bank accounts, savings accounts, cash ISAs
- **Investment** - General investments, unit trusts, OEICs, investment bonds (without life cover)
- **lifeAssuredInvestment** - Investment bonds with life assurance, whole of life policies with investment element

**Key Features:**
- Multi-owner support (joint investments)
- Flexible contributions (regular, lumpsum, transfer)
- Fund holdings with multiple identification codes (ISIN, SEDOL, Platform codes)
- Life assurance benefits (life cover, critical illness)
- Maturity projections (low, medium, high scenarios)
- Wrap/platform account linking
- Product provider tracking
- Selling adviser tracking
- Lifecycle stage management

### Core Final Salary Pension Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/pensions/finalsalary` | List all final salary pensions | ⭐ Supports filtering by scheme type |
| POST | `/api/v3/factfinds/{id}/pensions/finalsalary` | Create final salary pension | ⭐ Defined benefit pensions |
| GET | `/api/v3/factfinds/{id}/pensions/finalsalary/{pensionId}` | Get pension details | ⭐ Full pension record |
| PATCH | `/api/v3/factfinds/{id}/pensions/finalsalary/{pensionId}` | Update pension | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/pensions/finalsalary/{pensionId}` | Delete pension | ⭐ Soft delete |

**Pension Categories:**
- **PensionDefinedBenefit** - Final Salary and CARE (Career Average Revalued Earnings) schemes

**Scheme Types:**
- **FinalSalary** - Benefits based on final salary and service
- **CARE** - Career Average Revalued Earnings schemes
- **Hybrid** - Combination of defined benefit and defined contribution

**Key Features:**
- Prospective benefits tracking (pension with/without lump sum)
- Cash Equivalent Transfer Value (CETV) with expiry dates
- Accrual rate tracking (1/60, 1/80, etc.)
- Death in service benefits
- Early retirement provisions
- Guaranteed Minimum Pension (GMP) tracking
- Dependant benefits (spouse, children)
- Purchase of added years
- Affinity DC scheme integration
- Wrap/platform account linking

### Core Annuity Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/pensions/annuities` | List all annuities | ⭐ Supports filtering by annuity type |
| POST | `/api/v3/factfinds/{id}/pensions/annuities` | Create annuity | ⭐ Guaranteed income pensions |
| GET | `/api/v3/factfinds/{id}/pensions/annuities/{annuityId}` | Get annuity details | ⭐ Full annuity record |
| PATCH | `/api/v3/factfinds/{id}/pensions/annuities/{annuityId}` | Update annuity | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/pensions/annuities/{annuityId}` | Delete annuity | ⭐ Soft delete |

**Pension Categories:**
- **Annuity** - Guaranteed retirement income for life or fixed term

**Annuity Types:**
- **LIFETIME** - Annuity payable for life
- **FIXED_TERM** - Annuity payable for fixed period
- **JOINT_LIFE** - Continues on death to spouse
- **LEVEL** - Fixed income amount
- **ESCALATING** - Income increases annually
- **RPI_LINKED** - Linked to Retail Price Index
- **CPI_LINKED** - Linked to Consumer Price Index

**Key Features:**
- Purchase amount tracking
- Income structure (frequency, escalation)
- Guarantee periods (5, 10, 15 years)
- Spouse/dependant benefits (50%, 66.67%, 100%)
- PCLS (Pension Commencement Lump Sum) handling
- Overlay benefits (value protection, guaranteed minimums)
- Payment timing (advance or arrears)
- Enhanced annuity rates for health conditions
- Wrap/platform account linking

### Core Personal Pension Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/pensions/personalpension` | List all personal pensions | ⭐ Supports filtering by crystallisation status |
| POST | `/api/v3/factfinds/{id}/pensions/personalpension` | Create personal pension | ⭐ DC pensions, drawdown, SIPPs |
| GET | `/api/v3/factfinds/{id}/pensions/personalpension/{pensionId}` | Get pension details | ⭐ Full pension record |
| PATCH | `/api/v3/factfinds/{id}/pensions/personalpension/{pensionId}` | Update pension | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/pensions/personalpension/{pensionId}` | Delete pension | ⭐ Soft delete |

### Core State Pension Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/pensions/statepension` | List all state pension records | ⭐ State pension entitlements |
| POST | `/api/v3/factfinds/{id}/pensions/statepension` | Create state pension record | ⭐ Basic, additional, pension credit |
| GET | `/api/v3/factfinds/{id}/pensions/statepension/{pensionId}` | Get state pension details | ⭐ Full state pension record |
| PATCH | `/api/v3/factfinds/{id}/pensions/statepension/{pensionId}` | Update state pension | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/pensions/statepension/{pensionId}` | Delete state pension | ⭐ Soft delete |

### Core Employer Pension Scheme Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/pensions/employerschemes` | List all employer pension schemes | ⭐ Workplace pensions |
| POST | `/api/v3/factfinds/{id}/pensions/employerschemes` | Create employer pension scheme | ⭐ Current & deferred |
| GET | `/api/v3/factfinds/{id}/pensions/employerschemes/{schemeId}` | Get employer scheme details | ⭐ Full scheme record |
| PATCH | `/api/v3/factfinds/{id}/pensions/employerschemes/{schemeId}` | Update employer scheme | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/pensions/employerschemes/{schemeId}` | Delete employer scheme | ⭐ Soft delete |

**Pension Categories:**
- **PensionContributionDrawdown** - Personal pensions with contribution and drawdown features

**Crystallisation Status:**
- **Crystallised** - Entire pension accessed/drawn down
- **PartCrystallised** - Some funds accessed, some uncrystallised
- **Uncrystallised** - No benefits taken yet

**Key Features:**
- Contribution tracking (regular, lump sum, transfer)
- Fund holdings with multiple codes (ISIN, SEDOL, Platform)
- Crystallisation status monitoring
- GAD compliance (Guaranteed Annuity Drawdown limits)
- PCLS (Pension Commencement Lump Sum) management
- Lifetime allowance usage tracking
- Enhanced benefits (guaranteed annuity rates, loyalty bonuses)
- Death benefits tracking
- Lifestyling strategies
- Trust arrangements
- Wrap/platform account linking

### Core Mortgage Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/mortgages` | List all mortgages | ⭐ Supports filtering by product type |
| POST | `/api/v3/factfinds/{id}/mortgages` | Create mortgage | ⭐ All mortgage types |
| GET | `/api/v3/factfinds/{id}/mortgages/{mortgageId}` | Get mortgage details | ⭐ Full mortgage record |
| PATCH | `/api/v3/factfinds/{id}/mortgages/{mortgageId}` | Update mortgage | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/mortgages/{mortgageId}` | Delete mortgage | ⭐ Soft delete |

**Product Types:**
- **FixedRateMortgage** - Fixed interest rate for initial period
- **VariableRateMortgage** - Lender's standard variable rate
- **TrackerMortgage** - Tracks base rate plus margin
- **BuyToLetMortgage** - Rental property mortgage
- **LifetimeMortgage** - Equity release (interest roll-up)
- **SecondChargeMortgage** - Additional loan secured against property
- **SharedOwnershipMortgage** - Part-buy, part-rent scheme

**Repayment Methods:**
- **CapitalAndInterest** - Principal and interest paid each month
- **InterestOnly** - Interest only paid; capital repaid at end
- **PartAndPart** - Combination of repayment and interest-only
- **InterestRollUp** - Interest added to balance (equity release)

**Key Features:**
- Loan amount and LTV tracking (automatic calculation)
- Interest terms (rate, APR, rate type)
- Repayment structure management
- Early repayment charge (ERC) tracking
- Property integration (links to secured property)
- Linked arrangements (life assurance, buildings insurance)
- Offset mortgage features
- Shared ownership details
- Special features (portability, payment holidays, overpayments)
- Key dates tracking (application, completion, review, maturity)

### Core Personal Protection Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/protections` | List all protections | ⭐ Supports filtering by protection type |
| POST | `/api/v3/factfinds/{id}/protections` | Create protection | ⭐ All protection types |
| GET | `/api/v3/factfinds/{id}/protections/{protectionId}` | Get protection details | ⭐ Full protection record |
| PATCH | `/api/v3/factfinds/{id}/protections/{protectionId}` | Update protection | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/protections/{protectionId}` | Delete protection | ⭐ Soft delete |

**Protection Category:**
- **PersonalProtection** - Life cover, critical illness, income protection, expense cover, severity cover

**Cover Types:**
- **Life Cover** - Death benefit (first death, second death, both)
- **Critical Illness Cover** - Lump sum on diagnosis of critical illness
- **Income Cover** - Monthly income replacement (income protection insurance)
- **Expense Cover** - Monthly expense cover (e.g., mortgage protection)
- **Severity Cover** - Permanent total disability and severity-based benefits

**Key Features:**
- Multi-cover support (life, CI, income, expense, severity in one policy)
- Premium structures (stepped, level, hybrid)
- Indexation options (RPI, CPI, fixed percentage, level)
- Trust arrangements (in trust to beneficiaries)
- Benefits configuration (frequency, deferred periods, qualification periods)
- Commission tracking (indemnity, non-indemnity, renewal)
- Premium waiver on claim
- Policy ratings and loadings
- Benefit options (convertible, reviewable)
- Waiting periods and exclusions

**Total Endpoints:** 40 (5 investments + 5 final salary + 5 annuities + 5 personal pensions + 5 state pensions + 5 employer schemes + 5 mortgages + 5 protections)

### Protection Review

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/protections/reviews/summary` | Get protection review summary | ⭐ All sections |
| PUT | `/api/v3/factfinds/{id}/protections/reviews/lifeAndCriticalIllness` | Update life & critical illness review | ⭐ Needs analysis |
| PUT | `/api/v3/factfinds/{id}/protections/reviews/incomeProtection` | Update income protection review | ⭐ Accident/illness |
| PUT | `/api/v3/factfinds/{id}/protections/reviews/buildingsAndContent` | Update buildings & content review | ⭐ Property insurance |

**Total Endpoints:** 44 (40 plans + 4 protection review)

---

## 6. Goals Context

**Base Path:** `/api/v3/factfinds/{id}/objectives`

**Description:** Type-based objectives and goals with hierarchical structure. Objectives are categorized by type (investment, pension, protection, mortgage, budget, estate-planning).

### Objectives by Type

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/objectives` | List all objectives | ⭐ All types |
| POST | `/api/v3/factfinds/{id}/objectives/investment` | Create Investment Objective | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/objectives/investment` | List Investment Objectives | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/objectives/investment/{objectiveId}` | Get Investment Objective | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/objectives/investment/{objectiveId}` | Update Investment Objective | ⭐ New in v3.0 |
| POST | `/api/v3/factfinds/{id}/objectives/pension` | Create Pension Objective | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/objectives/pension` | List Pension Objectives | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/objectives/pension/{objectiveId}` | Get Pension Objective | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/objectives/pension/{objectiveId}` | Update Pension Objective | ⭐ New in v3.0 |
| POST | `/api/v3/factfinds/{id}/objectives/protection` | Create Protection Objective | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/objectives/protection` | List Protection Objectives | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/objectives/protection/{objectiveId}` | Get Protection Objective | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/objectives/protection/{objectiveId}` | Update Protection Objective | ⭐ New in v3.0 |
| POST | `/api/v3/factfinds/{id}/objectives/mortgage` | Create Mortgage Objective | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/objectives/mortgage` | List Mortgage Objectives | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/objectives/mortgage/{objectiveId}` | Get Mortgage Objective | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/objectives/mortgage/{objectiveId}` | Update Mortgage Objective | ⭐ New in v3.0 |
| POST | `/api/v3/factfinds/{id}/objectives/budget` | Create Budget Objective | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/objectives/budget` | List Budget Objectives | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/objectives/budget/{objectiveId}` | Get Budget Objective | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/objectives/budget/{objectiveId}` | Update Budget Objective | ⭐ New in v3.0 |
| POST | `/api/v3/factfinds/{id}/objectives/estate-planning` | Create Estate Planning Objective | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/objectives/estate-planning` | List Estate Planning Objectives | ⭐ New in v3.0 |
| GET | `/api/v3/factfinds/{id}/objectives/estate-planning/{objectiveId}` | Get Estate Planning Objective | ⭐ New in v3.0 |
| PATCH | `/api/v3/factfinds/{id}/objectives/estate-planning/{objectiveId}` | Update Estate Planning Objective | ⭐ New in v3.0 |
| **DELETE** | **`/api/v3/factfinds/{id}/objectives/{objectiveId}`** | **Delete any objective (all types)** | **⭐ Type-agnostic delete** |

**Note:** DELETE operation does not require type in the path. The objective ID is sufficient to identify and delete the objective regardless of its type.

### Objective Sub-resources (Needs)

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/objectives/{objectiveId}/needs` | List needs | ⭐ All needs for objective |
| POST | `/api/v3/factfinds/{id}/objectives/{objectiveId}/needs` | Add need | ⭐ New need |
| GET | `/api/v3/factfinds/{id}/objectives/{objectiveId}/needs/{needId}` | Get need details | ⭐ Specific need |
| PATCH | `/api/v3/factfinds/{id}/objectives/{objectiveId}/needs/{needId}` | Update need | ⭐ Partial updates |
| DELETE | `/api/v3/factfinds/{id}/objectives/{objectiveId}/needs/{needId}` | Delete need | ⭐ Remove need |

**Total Endpoints:** 31 (31 new in v3.0) - 26 objective operations + 5 needs operations

---

## 7. ATR Context

**Base Path:** `/api/v3/factfinds/{id}`

**Description:** Attitude to Risk (ATR) assessment with embedded questions, answers, risk profiles, capacity for loss, and declarations. All client answers to 15 core + 45 supplementary questions preserved for audit.

### ATR Assessment

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/factfinds/{id}/atr-assessment` | Get ATR with all answers | ⭐ Complete assessment |
| PUT | `/api/v3/factfinds/{id}/atr-assessment` | Submit/update ATR | ⭐ All 15 questions |
| POST | `/api/v3/factfinds/{id}/atr-assessment/choose-profile` | Choose risk profile | ⭐ Select from 3 options |
| GET | `/api/v3/factfinds/{id}/atr-assessment/history` | Get ATR history | ⭐ Risk Replay |
| GET | `/api/v3/factfinds/{id}/atr-assessment/history/{assessmentId}` | Get historical assessment | ⭐ Full details |
| GET | `/api/v3/factfinds/{id}/atr-assessment/compare` | Compare assessments | ⭐ Side-by-side |

### ATR Templates (Reference Data)

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/reference/atr-templates` | List ATR templates | ⭐ Available templates |
| GET | `/api/v3/reference/atr-templates/{templateId}` | Get template details | ⭐ All questions |

**Total Endpoints:** 8 (8 new in v3.0)

**Key Features:**
- **Embedded Answers**: All client answers stored with assessment
- **Risk Profile Generation**: System generates 3 adjacent profiles automatically
- **Capacity for Loss**: Financial capacity assessment included
- **Declarations**: Client and adviser sign-offs embedded
- **Historical Preservation**: All past assessments preserved for audit
- **Risk Replay**: Compare current and historical assessments

---

## 8. Reference Data API

**Base Path:** `/api/v3/reference`

**Description:** Reference data endpoints for enumerations, lookup values, and reference entities.

### Enumeration Value Types

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/reference/genders` | Get gender values | Static reference |
| GET | `/api/v3/reference/marital-statuses` | Get marital status values | Static reference |
| GET | `/api/v3/reference/employment-statuses` | Get employment status values | Static reference |
| GET | `/api/v3/reference/titles` | Get title values | Static reference |
| GET | `/api/v3/reference/address-types` | Get address type values | Static reference |
| GET | `/api/v3/reference/contact-types` | Get contact type values | Static reference |
| GET | `/api/v3/reference/meeting-types` | Get meeting type values | Static reference |
| GET | `/api/v3/reference/statuses` | Get status values | Static reference |
| GET | `/api/v3/reference/relationship-types` | Get relationship type values | ⭐ New in v3.0 |
| GET | `/api/v3/reference/asset-types` | Get asset type values | ⭐ New in v3.0 |
| GET | `/api/v3/reference/liability-types` | Get liability type values | ⭐ New in v3.0 |
| GET | `/api/v3/reference/income-types` | Get income type values | ⭐ New in v3.0 |
| GET | `/api/v3/reference/expenditure-types` | Get expenditure type values | ⭐ New in v3.0 |
| GET | `/api/v3/reference/objective-types` | Get objective type values | ⭐ New in v3.0 |

### Lookup Value Types

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/reference/countries` | Get country values | Lookup table |
| GET | `/api/v3/reference/counties` | Get county values | Lookup table |
| GET | `/api/v3/reference/currencies` | Get currency values | Lookup table |
| GET | `/api/v3/reference/frequencies` | Get frequency values | Lookup table |
| GET | `/api/v3/reference/product-types` | Get product type values | Lookup table |

### Reference Entities

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v3/providers` | List providers | Provider catalog |
| GET | `/api/v3/providers/{id}` | Get provider details | Specific provider |
| GET | `/api/v3/advisers` | List advisers | Adviser catalog |
| GET | `/api/v3/advisers/{id}` | Get adviser details | Specific adviser |

**Total Endpoints:** 24 (7 new in v3.0)

---

## Summary Statistics

### Endpoints by Context

| API Context | Total Endpoints |
|-------------|-----------------|
| **1. FactFind Root** | 17 |
| **2. Client Onboarding & KYC** | 101 |
| **3. Circumstances** | 28 |
| **4. Assets & Liabilities** | 23 |
| **5. Plans & Investments** | 44 |
| **6. Goals** | 31 |
| **7. ATR** | 8 |
| **8. Reference Data** | 24 |
| **TOTAL** | **276** |

**Notes:**
- Arrangements context has been removed - all products now managed under specific contexts (Mortgages and Personal Protection under Plans & Investments)
- Plans & Investments includes: 5 Investments + 5 Final Salary Pensions + 5 Annuities + 5 Personal Pensions + 5 State Pensions + 5 Employer Schemes + 5 Mortgages + 5 Personal Protections + 4 Protection Review

### HTTP Methods Distribution

Based on the 243 endpoint operations documented in this catalog:

| Method | Count | Percentage |
|--------|-------|------------|
| GET | 120 | 49% |
| POST | 40 | 16% |
| PATCH | 31 | 13% |
| PUT | 22 | 9% |
| DELETE | 30 | 12% |
| **TOTAL** | **243** | **100%** |

Note: Total operations (243) differs from unique endpoint patterns (276) as some endpoints support multiple HTTP methods.

---

## Quick Reference by Auth Scope

### Single Unified Scope

The API uses a single unified scope for all FactFind operations:

- `factfind` - Full access to all FactFind API operations including read, write, and delete across all resources

**Scope Coverage:**
- All fact find operations (create, read, update, delete)
- All client information and KYC data
- All circumstances data (employment, income, expenditure)
- All assets and liabilities
- All investments, pensions, and plans
- All objectives and goals
- All ATR assessments
- All credit history
- All reference data (read access)

**Authorization Model:**
- Fine-grained permissions managed at the application/tenant level
- OAuth scope grants broad API access
- Tenant isolation ensures data security

---

## Quick Reference by Compliance Domain

### FCA/MiFID II Compliance
- Section 7: ATR Assessment (Risk profiling)
- Section 6: Goals Context (Suitability)
- Section 5: Plans & Investments Context (Product governance)
- Section 2.11: Vulnerabilities (Consumer Duty)

### GDPR Compliance
- Section 2.7: DPA Consent API (Data processing consent)
- Section 2.8: Marketing Preferences API (Marketing consent)
- Section 2.11: Identity Verification (Data processing)
- Section 7.3: Declaration Capture (Consent management)

### MLR 2017 Compliance (AML/KYC)
- Section 2.11: Identity Verification API (KYC/AML)
- Section 2.13: Credit History (Financial crime checks)
- Section 2.5: Professional Contacts (Beneficial ownership)

### PECR Compliance
- Section 2.8: Marketing Preferences API (Electronic marketing)
- Section 2.7: DPA Consent (Privacy and communications)

### Tax Compliance
- Section 4.3: Property Details (CGT, SDLT, PRR)
- Section 5: Plans & Investments Context (ISA allowances, pension relief)
- Section 3: Circumstances Context (Income tax, NI)

---

## API v3.0 Key Conventions

### Pagination Parameters
- **$top** (integer, optional) - Number of items to return (default: 25, max: 100)
- **$skip** (integer, optional) - Number of items to skip (default: 0)
- Example: `GET /api/v3/factfinds?$top=25&$skip=0`

### Collection Response Structure
All list/collection endpoints return:
```json
{
  "href": "string",          // Current page URL
  "first_href": "string",    // First page URL
  "last_href": "string",     // Last page URL
  "next_href": "string",     // Next page URL (null if on last page)
  "prev_href": "string",     // Previous page URL (null if on first page)
  "items": [],               // Array of resources
  "count": 123               // Total count across all pages
}
```

### Ordering/Sorting
- Syntax: `?orderBy=fieldName asc|desc`
- Examples:
  - `GET /api/v3/factfinds?orderBy=createdAt desc`
  - `GET /api/v3/factfinds/{id}/clients?orderBy=lastName asc,firstName asc`
- Direction: `asc` (ascending) or `desc` (descending)
- Multiple fields: Comma-separated

### Filtering (QueryLang)
- Syntax: `field operator value` with `and` to chain
- Example: `?filter=clients.id eq 123 and meeting.meetingOn gt 2026-01-01`
- Operators: `eq`, `ne`, `gt`, `ge`, `lt`, `le`, `in`, `startswith`

### Money Type Structure
All monetary values use simplified structure:
```json
{
  "amount": 50000.00,
  "currency": {
    "code": "GBP"          // ISO 4217 currency code only
  }
}
```

### Simple Hypermedia
Resources include simple `href` properties for navigation:
```json
{
  "id": 679,
  "href": "/api/v3/factfinds/679",
  "clients": [
    { "id": 123, "href": "/api/v3/factfinds/679/clients/123" }
  ]
}
```

---

## API Design Principles

### Hierarchical Structure
- Resources nested under logical parent resources
- Clear ownership and access control boundaries
- Intuitive navigation through related resources

### Type-Based Routing
- Arrangements and objectives use type-based paths
- Consistent CRUD operations per type
- Type-specific validation and business rules

### PATCH Support
- All resources support partial updates via PATCH
- Reduces payload size and network traffic
- Enables concurrent editing scenarios

### Consistent Patterns
- All collections: GET (list), POST (create)
- All items: GET (read), PATCH (update), DELETE (delete)
- All sub-resources follow same pattern
- Consistent pagination, filtering, sorting

### Compliance-First Design
- GDPR: Consent management, RTBF, data portability
- FCA: ATR assessment, suitability, vulnerability
- MLR: Identity verification, AML checks
- PECR: Marketing consent, opt-in/opt-out

---

**Document End**

**Version:** 3.0
**Last Updated:** 2026-03-05
**Total Endpoints:** 276
**Total HTTP Operations:** 243
