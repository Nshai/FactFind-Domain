# FactFind API v3.0 - Hierarchical Endpoints Catalog

**Document Purpose:** Comprehensive quick-reference catalog of all API endpoints in the hierarchical FactFind API Design v3.0

**Date:** 2026-02-18
**API Version:** v2.0
**Base URL:** `https://api.factfind.com`

**Architecture:** RESTful hierarchy with context-driven resource nesting

---

## Table of Contents

1. [FactFind Root API](#1-factfind-root-api)
2. [Client Onboarding & KYC Context](#2-client-onboarding--kyc-context)
3. [Circumstances Context](#3-circumstances-context)
4. [Assets & Liabilities Context](#4-assets--liabilities-context)
5. [Arrangements Context](#5-arrangements-context)
6. [Plans & Investments Context](#6-plans--investments-context)
7. [Goals Context](#7-goals-context)
8. [ATR Context](#8-atr-context)
9. [Reference Data API](#9-reference-data-api)
9. [Summary Statistics](#summary-statistics)

---

## 1. FactFind Root API

**Base Path:** `/api/v2/factfinds`

**Description:** Root-level operations for managing fact find lifecycle and aggregated views.

### Core FactFind Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds` | List all fact finds | Supports filtering, pagination |
| POST | `/api/v2/factfinds` | Create new fact find | Returns factfindId |
| GET | `/api/v2/factfinds/{id}` | Get fact find by ID | Core metadata only |
| PATCH | `/api/v2/factfinds/{id}` | Partial update fact find | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}` | Delete fact find | Cascade delete all nested |

### Aggregated Views

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/complete` | Get complete fact find | All nested data |
| GET | `/api/v2/factfinds/{id}/current-position` | Get current financial position | Summary view |
| GET | `/api/v2/factfinds/{id}/net-worth` | Get net worth breakdown | Assets - Liabilities |
| GET | `/api/v2/factfinds/{id}/financial-health` | Get financial health score | Calculated metrics |
| GET | `/api/v2/factfinds/{id}/cash-flow` | Get cash flow analysis | Income - Expenditure |
| GET | `/api/v2/factfinds/{id}/asset-allocation` | Get asset allocation | Portfolio breakdown |

**Total Endpoints:** 11

---

## 2. Client Onboarding & KYC Context

**Base Path:** `/api/v2/factfinds/{id}/clients`

**Description:** Client-centric operations for onboarding, identity verification, consent management, and KYC data collection.

### Core Client Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients` | List clients | Multiple clients per factfind |
| POST | `/api/v2/factfinds/{id}/clients` | Add client to factfind | ⭐ Supports multiple clients |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}` | Get client details | Full client record |
| PATCH | `/api/v2/factfinds/{id}/clients/{clientId}` | Update client | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}` | Remove client | Cascade delete nested data |

### Address Management

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/addresses` | List addresses | Current + historical |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/addresses` | Add address | Supports multiple |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/addresses/{addressId}` | Get address details | ⭐ Individual address |
| PATCH | `/api/v2/factfinds/{id}/clients/{clientId}/addresses/{addressId}` | Update address | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/addresses/{addressId}` | Delete address | Soft delete |

### Contact Management

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/contacts` | List contacts | Phone, email, etc. |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/contacts` | Add contact | Multiple contacts |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/contacts/{contactId}` | Get contact details | ⭐ Individual contact |
| PATCH | `/api/v2/factfinds/{id}/clients/{clientId}/contacts/{contactId}` | Update contact | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/contacts/{contactId}` | Delete contact | Soft delete |

### Professional Contacts

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/professional-contacts` | List professional contacts | Solicitors, accountants |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/professional-contacts` | Add professional contact | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/professional-contacts/{contactId}` | Get professional contact | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/clients/{clientId}/professional-contacts/{contactId}` | Update professional contact | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/professional-contacts/{contactId}` | Delete professional contact | ⭐ New in v3.0 |

### Estate Planning

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/estate-planning` | Get estate planning details | ⭐ Singleton per client |
| PUT | `/api/v2/factfinds/{id}/clients/{clientId}/estate-planning` | Update estate planning | ⭐ IHT planning |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/estate-planning/gifts` | List all gifts | ⭐ PETs & trusts |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/estate-planning/gifts` | Create new gift | ⭐ Record gifts |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/estate-planning/gifts/{giftId}` | Get specific gift | ⭐ View details |
| PUT | `/api/v2/factfinds/{id}/clients/{clientId}/estate-planning/gifts/{giftId}` | Update gift | ⭐ Modify exemptions |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/estate-planning/gifts/{giftId}` | Delete gift | ⭐ Remove record |

### Relationships

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/relationships` | List relationships | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/relationships` | Add relationship | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Get relationship | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Update relationship | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Delete relationship | ⭐ New in v3.0 |

### DPA Agreements

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/dpa-agreements` | Create DPA agreement | ⭐ GDPR compliance |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/dpa-agreements` | List all DPA agreements | ⭐ Pagination support |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/dpa-agreements/{agreementId}` | Get specific DPA agreement | ⭐ Use 'current' for latest |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/dpa-agreements/{agreementId}` | Delete DPA agreement | ⭐ Use with caution |

### Financial Profile

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/financial-profile` | Get financial profile | ⭐ Singleton resource |
| PUT | `/api/v2/factfinds/{id}/clients/{clientId}/financial-profile` | Update financial profile | ⭐ Summary of finances |

### Client Relationships

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/relationships` | Create client relationship | ⭐ Link clients |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/relationships` | List all relationships | ⭐ Family & partners |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Get specific relationship | ⭐ View details |
| PUT | `/api/v2/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Update relationship | ⭐ Change permissions |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Delete relationship | ⭐ Unlink clients |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/data` | Right to be forgotten (RTBF) | ⭐ GDPR compliance |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/data/export` | Data portability request | ⭐ GDPR compliance |

### Marketing Preferences

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/marketing-preferences` | Get marketing preferences | ⭐ Singleton resource per client |
| PUT | `/api/v2/factfinds/{id}/clients/{clientId}/marketing-preferences` | Update marketing preferences | ⭐ PECR/GDPR compliance |

### Vulnerabilities

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/vulnerabilities` | List all client vulnerabilities | ⭐ FCA compliance |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/vulnerabilities` | Create a vulnerability | ⭐ FCA compliance |
| PUT | `/api/v2/factfinds/{id}/clients/{clientId}/vulnerabilities/{vulnerabilityId}` | Update a vulnerability | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/vulnerabilities/{vulnerabilityId}` | Delete a vulnerability | ⭐ New in v3.0 |

### Dependants

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/dependants` | List dependants | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/dependants` | Add dependant | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/dependants/{dependantId}` | Get dependant details | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/clients/{clientId}/dependants/{dependantId}` | Update dependant | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/dependants/{dependantId}` | Delete dependant | ⭐ New in v3.0 |

### Identity Verification

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/id-verification` | Get identity verification details | ⭐ Singleton resource per client |
| PUT | `/api/v2/factfinds/{id}/clients/{clientId}/id-verification` | Update identity verification details | ⭐ MLR 2017 / KYC/AML |

### Credit History

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/credit-history` | Get credit history | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/credit-history` | Add credit score | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/credit-history/{scoreId}` | Get credit score details | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/credit-history/status` | Get current credit status | ⭐ Latest score |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/credit-history/payment-events` | Record payment event | ⭐ Payment history |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/credit-history/payment-events` | Get payment history | ⭐ Payment events |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/credit-history/utilization` | Get credit utilization | ⭐ Calculated metric |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/credit-history/health-indicators` | Get credit health | ⭐ Health metrics |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/credit-history/report-request` | Request credit report | ⭐ External API call |

### Pension Summary

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/pension-summary` | Get pension summary | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/pension-summary/calculate` | Calculate pension projection | ⭐ New in v3.0 |

**Total Endpoints:** 105 (94 new in v3.0)

---

## 3. Circumstances Context

**Base Path:** `/api/v2/factfinds/{id}/clients/{clientId}`

**Description:** Client-specific circumstances including employment, income, and expenditure. These resources are nested under clients as they are personal to each client.

### Employment

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/employment` | List employment history | ⭐ Hierarchical |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/employment` | Add employment record | ⭐ Hierarchical |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/employment/{employmentId}` | Get employment details | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/clients/{clientId}/employment/{employmentId}` | Update employment | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/employment/{employmentId}` | Delete employment | ⭐ New in v3.0 |

### Income

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/income` | List income sources | ⭐ Hierarchical |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/income` | Add income source | ⭐ Hierarchical |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/income/{incomeId}` | Get income details | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/clients/{clientId}/income/{incomeId}` | Update income | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/income/{incomeId}` | Delete income | ⭐ New in v3.0 |

### Income Changes

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/income-changes` | List income changes | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/income-changes` | Record income change | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/income-changes/{changeId}` | Get income change details | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/clients/{clientId}/income-changes/{changeId}` | Update income change | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/income-changes/{changeId}` | Delete income change | ⭐ New in v3.0 |

### Expenditure

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/expenditure` | List expenditure items | ⭐ Hierarchical |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/expenditure` | Add expenditure | ⭐ Hierarchical |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/expenditure/{expenditureId}` | Get expenditure details | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/clients/{clientId}/expenditure/{expenditureId}` | Update expenditure | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/expenditure/{expenditureId}` | Delete expenditure | ⭐ New in v3.0 |

### Expenditure Changes

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/expenditure-changes` | List expenditure changes | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/clients/{clientId}/expenditure-changes` | Record expenditure change | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/expenditure-changes/{changeId}` | Get expenditure change | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/clients/{clientId}/expenditure-changes/{changeId}` | Update expenditure change | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/clients/{clientId}/expenditure-changes/{changeId}` | Delete expenditure change | ⭐ New in v3.0 |

### Budget Summary

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/clients/{clientId}/budget` | Get budget summary | ⭐ Hierarchical |

**Total Endpoints:** 26 (26 new in v3.0)

---

## 4. Assets & Liabilities Context

**Base Path:** `/api/v2/factfinds/{id}/assets`

**Description:** Factfind-level assets and liabilities. Assets can be jointly owned by multiple clients within the same factfind.

### Assets

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/assets` | List all assets | ⭐ Hierarchical |
| POST | `/api/v2/factfinds/{id}/assets` | Add asset | ⭐ Hierarchical |
| GET | `/api/v2/factfinds/{id}/assets/{assetId}` | Get asset details | ⭐ With embedded details |
| PATCH | `/api/v2/factfinds/{id}/assets/{assetId}` | Update asset | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/assets/{assetId}` | Delete asset | ⭐ Soft delete |

### Liabilities

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/liabilities` | List all liabilities | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/liabilities` | Add liability | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/liabilities/{liabilityId}` | Get liability details | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/liabilities/{liabilityId}` | Update liability | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/liabilities/{liabilityId}` | Delete liability | ⭐ New in v3.0 |

### Property Details (Embedded in Assets)

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/assets/{assetId}/property-detail` | Get property detail | ⭐ For asset_type=property |
| PATCH | `/api/v2/factfinds/{id}/assets/{assetId}/property-detail` | Update property detail | ⭐ Embedded detail |
| GET | `/api/v2/factfinds/{id}/assets/{assetId}/property-detail/valuations` | Get valuation history | ⭐ Property valuations |
| POST | `/api/v2/factfinds/{id}/assets/{assetId}/property-detail/valuations` | Add property valuation | ⭐ New valuation |
| GET | `/api/v2/factfinds/{id}/assets/{assetId}/property-detail/capital-gains` | Calculate CGT | ⭐ Tax calculation |--------|----------|-------------|-------|

### Aggregated Views

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/assets/summary` | Get assets summary | ⭐ Aggregated totals |
| GET | `/api/v2/factfinds/{id}/liabilities/summary` | Get liabilities summary | ⭐ Aggregated totals |
| GET | `/api/v2/factfinds/{id}/net-worth` | Calculate net worth | ⭐ Assets - Liabilities |

**Total Endpoints:** 23 (23 new in v3.0)

**Note:** Rental yield values are calculated and stored as part of the property details contract. No separate calculation endpoint is provided.

---

## 5. Arrangements Context

**Base Path:** `/api/v2/factfinds/{id}/arrangements`

**Description:** Type-based financial arrangements including pensions, mortgages, and protection policies. Hierarchical structure with type-specific endpoints.

**Note:** Investments are now managed separately under Plans & Investments Context (Section 6).

### List All Arrangements

| Method | Endpoint | Description | Notes |

### Mortgage Arrangements

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/arrangements/mortgages` | List all mortgages | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/arrangements/mortgages` | Create mortgage | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/arrangements/mortgages/{arrangementId}` | Get mortgage details | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/arrangements/mortgages/{arrangementId}` | Update mortgage | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/arrangements/mortgages/{arrangementId}` | Delete mortgage | ⭐ New in v3.0 |

### Protection Arrangements

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/arrangements/protections` | List all protection | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/arrangements/protections/personal-protection` | Create Personal Protection | ⭐ Life, CI, IP |
| GET | `/api/v2/factfinds/{id}/arrangements/protections/personal-protection` | List Personal Protection | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/arrangements/protections/personal-protection/{arrangementId}` | Get Personal Protection | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/arrangements/protections/personal-protection/{arrangementId}` | Update Personal Protection | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/arrangements/protections/personal-protection/{arrangementId}` | Delete Personal Protection | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/arrangements/protections/general-insurance` | Create General Insurance | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/arrangements/protections/general-insurance` | List General Insurance | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/arrangements/protections/general-insurance/{arrangementId}` | Get General Insurance | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/arrangements/protections/general-insurance/{arrangementId}` | Update General Insurance | ⭐ New in v3.0 |
| DELETE | `/api/v2/factfinds/{id}/arrangements/protections/general-insurance/{arrangementId}` | Delete General Insurance | ⭐ New in v3.0 |

### Arrangement Sub-resources

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/contributions` | List contributions | ⭐ All contribution records |
| POST | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/contributions` | Add contribution | ⭐ New contribution |
| GET | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/contributions/{contributionId}` | Get contribution details | ⭐ Specific contribution |
| PATCH | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/contributions/{contributionId}` | Update contribution | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/contributions/{contributionId}` | Delete contribution | ⭐ Remove contribution |
| GET | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/withdrawals` | List withdrawals | ⭐ All withdrawal records |
| POST | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/withdrawals` | Add withdrawal | ⭐ New withdrawal |
| GET | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/withdrawals/{withdrawalId}` | Get withdrawal details | ⭐ Specific withdrawal |
| PATCH | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/withdrawals/{withdrawalId}` | Update withdrawal | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/withdrawals/{withdrawalId}` | Delete withdrawal | ⭐ Remove withdrawal |
| GET | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/beneficiaries` | List beneficiaries | ⭐ All beneficiaries |
| POST | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/beneficiaries` | Add beneficiary | ⭐ New beneficiary |
| GET | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/beneficiaries/{beneficiaryId}` | Get beneficiary details | ⭐ Specific beneficiary |
| PATCH | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/beneficiaries/{beneficiaryId}` | Update beneficiary | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/beneficiaries/{beneficiaryId}` | Delete beneficiary | ⭐ Remove beneficiary |
| GET | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/valuations` | List valuations | ⭐ Valuation history |
| POST | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/valuations` | Add valuation | ⭐ New valuation |
| GET | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/valuations/{valuationId}` | Get valuation details | ⭐ Specific valuation |
| PATCH | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/valuations/{valuationId}` | Update valuation | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/valuations/{valuationId}` | Delete valuation | ⭐ Remove valuation |

**Total Endpoints:** 32 (32 new in v3.0)

**Note:**
- Investment arrangements have been moved to Plans & Investments Context (Section 6).
- ALL Pension arrangements (Personal Pension, State Pension, Workplace Pension, SIPP, Final Salary, Drawdown, Annuity, etc.) have been moved to Plans & Investments Context (Section 6) as standalone Plans entities.

---

## 6. Plans & Investments Context

**Base Path:** `/api/v2/factfinds/{id}/investments`

**Description:** Comprehensive investment management including investment accounts, life-assured investments, cash bank accounts, and investment bonds. Supports multi-category investments with flexible contribution tracking and fund holdings management.

### Core Investment Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/investments` | List all investments | ⭐ Supports filtering by category |
| POST | `/api/v2/factfinds/{id}/investments` | Create investment | ⭐ All investment types |
| GET | `/api/v2/factfinds/{id}/investments/{investmentId}` | Get investment details | ⭐ Full investment record |
| PATCH | `/api/v2/factfinds/{id}/investments/{investmentId}` | Update investment | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/investments/{investmentId}` | Delete investment | ⭐ Soft delete |

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
| GET | `/api/v2/factfinds/{id}/pensions/finalsalary` | List all final salary pensions | ⭐ Supports filtering by scheme type |
| POST | `/api/v2/factfinds/{id}/pensions/finalsalary` | Create final salary pension | ⭐ Defined benefit pensions |
| GET | `/api/v2/factfinds/{id}/pensions/finalsalary/{pensionId}` | Get pension details | ⭐ Full pension record |
| PATCH | `/api/v2/factfinds/{id}/pensions/finalsalary/{pensionId}` | Update pension | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/pensions/finalsalary/{pensionId}` | Delete pension | ⭐ Soft delete |

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
| GET | `/api/v2/factfinds/{id}/pensions/annuities` | List all annuities | ⭐ Supports filtering by annuity type |
| POST | `/api/v2/factfinds/{id}/pensions/annuities` | Create annuity | ⭐ Guaranteed income pensions |
| GET | `/api/v2/factfinds/{id}/pensions/annuities/{annuityId}` | Get annuity details | ⭐ Full annuity record |
| PATCH | `/api/v2/factfinds/{id}/pensions/annuities/{annuityId}` | Update annuity | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/pensions/annuities/{annuityId}` | Delete annuity | ⭐ Soft delete |

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
| GET | `/api/v2/factfinds/{id}/pensions/personalpension` | List all personal pensions | ⭐ Supports filtering by crystallisation status |
| POST | `/api/v2/factfinds/{id}/pensions/personalpension` | Create personal pension | ⭐ DC pensions, drawdown, SIPPs |
| GET | `/api/v2/factfinds/{id}/pensions/personalpension/{pensionId}` | Get pension details | ⭐ Full pension record |
| PATCH | `/api/v2/factfinds/{id}/pensions/personalpension/{pensionId}` | Update pension | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/pensions/personalpension/{pensionId}` | Delete pension | ⭐ Soft delete |

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

**Total Endpoints:** 20 (5 investments + 5 final salary + 5 annuities + 5 personal pensions)

---

## 7. Goals Context

**Base Path:** `/api/v2/factfinds/{id}/objectives`

**Description:** Type-based objectives and goals with hierarchical structure. Objectives are categorized by type (investment, pension, protection, mortgage, budget, estate-planning).

### Objectives by Type

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/objectives` | List all objectives | ⭐ All types |
| POST | `/api/v2/factfinds/{id}/objectives/investment` | Create Investment Objective | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/objectives/investment` | List Investment Objectives | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/objectives/investment/{objectiveId}` | Get Investment Objective | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/objectives/investment/{objectiveId}` | Update Investment Objective | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/objectives/pension` | Create Pension Objective | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/objectives/pension` | List Pension Objectives | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/objectives/pension/{objectiveId}` | Get Pension Objective | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/objectives/pension/{objectiveId}` | Update Pension Objective | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/objectives/protection` | Create Protection Objective | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/objectives/protection` | List Protection Objectives | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/objectives/protection/{objectiveId}` | Get Protection Objective | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/objectives/protection/{objectiveId}` | Update Protection Objective | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/objectives/mortgage` | Create Mortgage Objective | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/objectives/mortgage` | List Mortgage Objectives | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/objectives/mortgage/{objectiveId}` | Get Mortgage Objective | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/objectives/mortgage/{objectiveId}` | Update Mortgage Objective | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/objectives/budget` | Create Budget Objective | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/objectives/budget` | List Budget Objectives | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/objectives/budget/{objectiveId}` | Get Budget Objective | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/objectives/budget/{objectiveId}` | Update Budget Objective | ⭐ New in v3.0 |
| POST | `/api/v2/factfinds/{id}/objectives/estate-planning` | Create Estate Planning Objective | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/objectives/estate-planning` | List Estate Planning Objectives | ⭐ New in v3.0 |
| GET | `/api/v2/factfinds/{id}/objectives/estate-planning/{objectiveId}` | Get Estate Planning Objective | ⭐ New in v3.0 |
| PATCH | `/api/v2/factfinds/{id}/objectives/estate-planning/{objectiveId}` | Update Estate Planning Objective | ⭐ New in v3.0 |
| **DELETE** | **`/api/v2/factfinds/{id}/objectives/{objectiveId}`** | **Delete any objective (all types)** | **⭐ Type-agnostic delete** |

**Note:** DELETE operation does not require type in the path. The objective ID is sufficient to identify and delete the objective regardless of its type.

### Objective Sub-resources (Needs)

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/objectives/{objectiveId}/needs` | List needs | ⭐ All needs for objective |
| POST | `/api/v2/factfinds/{id}/objectives/{objectiveId}/needs` | Add need | ⭐ New need |
| GET | `/api/v2/factfinds/{id}/objectives/{objectiveId}/needs/{needId}` | Get need details | ⭐ Specific need |
| PATCH | `/api/v2/factfinds/{id}/objectives/{objectiveId}/needs/{needId}` | Update need | ⭐ Partial updates |
| DELETE | `/api/v2/factfinds/{id}/objectives/{objectiveId}/needs/{needId}` | Delete need | ⭐ Remove need |

**Total Endpoints:** 31 (31 new in v3.0) - 26 objective operations + 5 needs operations

---

## 8. ATR Context

**Base Path:** `/api/v2/factfinds/{id}`

**Description:** Attitude to Risk (ATR) assessment with embedded questions, answers, risk profiles, capacity for loss, and declarations. All client answers to 15 core + 45 supplementary questions preserved for audit.

### ATR Assessment

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/factfinds/{id}/atr-assessment` | Get ATR with all answers | ⭐ Complete assessment |
| PUT | `/api/v2/factfinds/{id}/atr-assessment` | Submit/update ATR | ⭐ All 15 questions |
| POST | `/api/v2/factfinds/{id}/atr-assessment/choose-profile` | Choose risk profile | ⭐ Select from 3 options |
| GET | `/api/v2/factfinds/{id}/atr-assessment/history` | Get ATR history | ⭐ Risk Replay |
| GET | `/api/v2/factfinds/{id}/atr-assessment/history/{assessmentId}` | Get historical assessment | ⭐ Full details |
| GET | `/api/v2/factfinds/{id}/atr-assessment/compare` | Compare assessments | ⭐ Side-by-side |

### ATR Templates (Reference Data)

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/reference/atr-templates` | List ATR templates | ⭐ Available templates |
| GET | `/api/v2/reference/atr-templates/{templateId}` | Get template details | ⭐ All questions |

**Total Endpoints:** 8 (8 new in v3.0)

**Key Features:**
- **Embedded Answers**: All client answers stored with assessment
- **Risk Profile Generation**: System generates 3 adjacent profiles automatically
- **Capacity for Loss**: Financial capacity assessment included
- **Declarations**: Client and adviser sign-offs embedded
- **Historical Preservation**: All past assessments preserved for audit
- **Risk Replay**: Compare current and historical assessments

---

## 9. Reference Data API

**Base Path:** `/api/v2/reference`

**Description:** Reference data endpoints for enumerations, lookup values, and reference entities.

### Enumeration Value Types

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/reference/genders` | Get gender values | Static reference |
| GET | `/api/v2/reference/marital-statuses` | Get marital status values | Static reference |
| GET | `/api/v2/reference/employment-statuses` | Get employment status values | Static reference |
| GET | `/api/v2/reference/titles` | Get title values | Static reference |
| GET | `/api/v2/reference/address-types` | Get address type values | Static reference |
| GET | `/api/v2/reference/contact-types` | Get contact type values | Static reference |
| GET | `/api/v2/reference/meeting-types` | Get meeting type values | Static reference |
| GET | `/api/v2/reference/statuses` | Get status values | Static reference |
| GET | `/api/v2/reference/relationship-types` | Get relationship type values | ⭐ New in v3.0 |
| GET | `/api/v2/reference/asset-types` | Get asset type values | ⭐ New in v3.0 |
| GET | `/api/v2/reference/liability-types` | Get liability type values | ⭐ New in v3.0 |
| GET | `/api/v2/reference/income-types` | Get income type values | ⭐ New in v3.0 |
| GET | `/api/v2/reference/expenditure-types` | Get expenditure type values | ⭐ New in v3.0 |
| GET | `/api/v2/reference/arrangement-types` | Get arrangement type values | ⭐ New in v3.0 |
| GET | `/api/v2/reference/objective-types` | Get objective type values | ⭐ New in v3.0 |

### Lookup Value Types

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/reference/countries` | Get country values | Lookup table |
| GET | `/api/v2/reference/counties` | Get county values | Lookup table |
| GET | `/api/v2/reference/currencies` | Get currency values | Lookup table |
| GET | `/api/v2/reference/frequencies` | Get frequency values | Lookup table |
| GET | `/api/v2/reference/product-types` | Get product type values | Lookup table |

### Reference Entities

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v2/providers` | List providers | Provider catalog |
| GET | `/api/v2/providers/{id}` | Get provider details | Specific provider |
| GET | `/api/v2/advisers` | List advisers | Adviser catalog |
| GET | `/api/v2/advisers/{id}` | Get adviser details | Specific adviser |

**Total Endpoints:** 24 (7 new in v3.0)

---

## Summary Statistics

### Endpoints by Context

| API Context | Total Endpoints | New in v3.0 |
|-------------|-----------------|-------------|
| **1. FactFind Root** | 11 | 11 ⭐ |
| **2. Client Onboarding & KYC** | 105 | 94 ⭐ |
| **3. Circumstances** | 26 | 26 ⭐ |
| **4. Assets & Liabilities** | 23 | 23 ⭐ |
| **5. Arrangements** | 32 | 32 ⭐ |
| **6. Plans & Investments** | 20 | 20 ⭐ |
| **7. Goals** | 31 | 31 ⭐ |
| **8. ATR** | 8 | 8 ⭐ |
| **9. Reference Data** | 24 | 7 ⭐ |
| **TOTAL** | **280** | **252** |


### Net Worth

Calculate and track client net worth.

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/v2/factfinds/{factfindId}/networth | List all net worth calculations |
| POST | /api/v2/factfinds/{factfindId}/networth | Create net worth calculation |
| GET | /api/v2/factfinds/{factfindId}/networth/{networthId} | Get specific net worth |
| PATCH | /api/v2/factfinds/{factfindId}/networth/{networthId} | Update net worth |
| DELETE | /api/v2/factfinds/{factfindId}/networth/{networthId} | Delete net worth |


### HTTP Methods Distribution

| Method | Count | Percentage |
|--------|-------|------------|
| GET | 150 | 48% |
| POST | 72 | 23% |
| PATCH | 75 | 24% |
| PUT | 5 | 2% |
| DELETE | 9 | 3% |
| **TOTAL** | **311** | **100%** |

### Hierarchical Depth Analysis

| Depth Level | Example Path | Endpoints |
|-------------|--------------|-----------|
| **Level 1** | `/api/v2/factfinds` | 11 |
| **Level 2** | `/api/v2/factfinds/{id}/clients` | 48 |
| **Level 3** | `/api/v2/factfinds/{id}/clients/{clientId}/addresses` | 142 |
| **Level 4** | `/api/v2/factfinds/{id}/arrangements/{arrangementId}/contributions/{contributionId}` | 147 |

---

## Quick Reference by Auth Scope

### Read Operations
- `factfind:read` - Read fact find data
- `client:read` - Read client information
- `circumstances:read` - Read income/expenditure
- `assets:read` - Read assets and liabilities
- `arrangements:read` - Read arrangements
- `objectives:read` - Read objectives
- `atr:read` - Read ATR assessment
- `credit:read` - Read credit history

### Write Operations
- `factfind:write` - Create/update fact finds
- `client:write` - Create/update clients
- `circumstances:write` - Manage income/expenditure
- `assets:write` - Manage assets and liabilities
- `arrangements:write` - Manage arrangements
- `objectives:write` - Manage objectives
- `atr:write` - Manage ATR assessment
- `credit:write` - Add credit scores

### Admin Operations
- `atr:admin` - Manage risk questionnaires
- `client:admin` - RTBF and administrative functions
- `reference:admin` - Manage reference data

---

## Quick Reference by Compliance Domain

### FCA/MiFID II Compliance
- Section 7: ATR Assessment (Risk profiling)
- Section 6: Goals Context (Suitability)
- Section 5: Arrangements Context (Product governance)
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
- Section 5: Arrangements Context (ISA allowances, pension relief)
- Section 3: Circumstances Context (Income tax, NI)

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
**Last Updated:** 2026-02-23
**Total Endpoints:** 353
