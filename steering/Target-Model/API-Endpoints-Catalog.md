# FactFind API v3.0 - Hierarchical Endpoints Catalog

**Document Purpose:** Comprehensive quick-reference catalog of all API endpoints in the hierarchical FactFind API Design v3.0

**Date:** 2026-02-18
**API Version:** v3.0
**Base URL:** `https://api.factfind.com`

**Architecture:** RESTful hierarchy with context-driven resource nesting

---

## Table of Contents

1. [FactFind Root API](#1-factfind-root-api)
2. [Client Onboarding & KYC Context](#2-client-onboarding--kyc-context)
3. [Circumstances Context](#3-circumstances-context)
4. [Assets & Liabilities Context](#4-assets--liabilities-context)
5. [Arrangements Context](#5-arrangements-context)
6. [Goals Context](#6-goals-context)
7. [ATR Context](#7-atr-context)
8. [Reference Data API](#8-reference-data-api)
9. [Summary Statistics](#summary-statistics)

---

## 1. FactFind Root API

**Base Path:** `/api/v1/factfinds`

**Description:** Root-level operations for managing fact find lifecycle and aggregated views.

### Core FactFind Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds` | List all fact finds | Supports filtering, pagination |
| POST | `/api/v1/factfinds` | Create new fact find | Returns factfindId |
| GET | `/api/v1/factfinds/{id}` | Get fact find by ID | Core metadata only |
| PATCH | `/api/v1/factfinds/{id}` | Partial update fact find | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}` | Delete fact find | Cascade delete all nested |

### Aggregated Views

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/complete` | Get complete fact find | All nested data |
| GET | `/api/v1/factfinds/{id}/current-position` | Get current financial position | Summary view |
| GET | `/api/v1/factfinds/{id}/net-worth` | Get net worth breakdown | Assets - Liabilities |
| GET | `/api/v1/factfinds/{id}/financial-health` | Get financial health score | Calculated metrics |
| GET | `/api/v1/factfinds/{id}/cash-flow` | Get cash flow analysis | Income - Expenditure |
| GET | `/api/v1/factfinds/{id}/asset-allocation` | Get asset allocation | Portfolio breakdown |

**Total Endpoints:** 11

---

## 2. Client Onboarding & KYC Context

**Base Path:** `/api/v1/factfinds/{id}/clients`

**Description:** Client-centric operations for onboarding, identity verification, consent management, and KYC data collection.

### Core Client Operations

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients` | List clients | Multiple clients per factfind |
| POST | `/api/v1/factfinds/{id}/clients` | Add client to factfind | ⭐ Supports multiple clients |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}` | Get client details | Full client record |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}` | Update client | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}/clients/{clientId}` | Remove client | Cascade delete nested data |

### Address Management

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/addresses` | List addresses | Current + historical |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/addresses` | Add address | Supports multiple |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/addresses/{addressId}` | Get address details | ⭐ Individual address |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/addresses/{addressId}` | Update address | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}/clients/{clientId}/addresses/{addressId}` | Delete address | Soft delete |

### Contact Management

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/contacts` | List contacts | Phone, email, etc. |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/contacts` | Add contact | Multiple contacts |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/contacts/{contactId}` | Get contact details | ⭐ Individual contact |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/contacts/{contactId}` | Update contact | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}/clients/{clientId}/contacts/{contactId}` | Delete contact | Soft delete |

### Professional Contacts

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/professional-contacts` | List professional contacts | Solicitors, accountants |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/professional-contacts` | Add professional contact | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/professional-contacts/{contactId}` | Get professional contact | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/professional-contacts/{contactId}` | Update professional contact | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/clients/{clientId}/professional-contacts/{contactId}` | Delete professional contact | ⭐ New in v3.0 |

### Estate Planning

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/estate-planning` | Get estate planning info | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/estate-planning` | Update estate planning | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/estate-planning/gifts` | Record gift | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/estate-planning/gifts` | List gifts | ⭐ New in v3.0 |

### Relationships

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/relationships` | List relationships | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/relationships` | Add relationship | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Get relationship | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Update relationship | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/clients/{clientId}/relationships/{relationshipId}` | Delete relationship | ⭐ New in v3.0 |

### DPA Consent

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/dpa-consent` | Get DPA consent status | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/dpa-consent` | Record DPA consent | ⭐ GDPR compliance |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/dpa-consent` | Update DPA consent | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/dpa-consent/history` | Get consent history | ⭐ Audit trail |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/dpa-consent/withdraw` | Withdraw consent | ⭐ GDPR right |
| DELETE | `/api/v1/factfinds/{id}/clients/{clientId}/data` | Right to be forgotten (RTBF) | ⭐ GDPR compliance |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/data/export` | Data portability request | ⭐ GDPR compliance |

### Marketing Consent

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/marketing-consent` | Get marketing consent | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/marketing-consent` | Record marketing consent | ⭐ PECR compliance |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/marketing-consent` | Update marketing consent | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/marketing-consent/history` | Get consent history | ⭐ Audit trail |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/marketing-consent/opt-in` | Opt-in to marketing | ⭐ PECR compliance |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/marketing-consent/opt-out` | Opt-out of marketing | ⭐ PECR compliance |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/marketing-consent/unsubscribe` | Unsubscribe (one-click) | ⭐ PECR compliance |

### Vulnerabilities

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/vulnerabilities` | Get vulnerability assessment | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/vulnerabilities` | Record vulnerability | ⭐ FCA compliance |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/vulnerabilities` | Update vulnerability | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/vulnerabilities/history` | Get vulnerability history | ⭐ Audit trail |

### Dependants

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/dependants` | List dependants | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/dependants` | Add dependant | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/dependants/{dependantId}` | Get dependant details | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/dependants/{dependantId}` | Update dependant | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/clients/{clientId}/dependants/{dependantId}` | Delete dependant | ⭐ New in v3.0 |

### Identity Verification

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/identity-verification` | Get verification status | ⭐ MLR 2017 |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/identity-verification` | Submit identity document | ⭐ KYC/AML |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/identity-verification/{verificationId}` | Get verification details | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/identity-verification/{verificationId}` | Update verification | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/identity-verification/history` | Get verification history | ⭐ Audit trail |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/identity-verification/{verificationId}/aml-check` | Trigger AML check | ⭐ MLR 2017 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/identity-verification/{verificationId}/documents` | Get documents | ⭐ Document list |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/identity-verification/{verificationId}/documents` | Upload document | ⭐ Document upload |

### Credit History

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/credit-history` | Get credit history | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/credit-history` | Add credit score | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/credit-history/{scoreId}` | Get credit score details | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/credit-history/status` | Get current credit status | ⭐ Latest score |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/credit-history/payment-events` | Record payment event | ⭐ Payment history |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/credit-history/payment-events` | Get payment history | ⭐ Payment events |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/credit-history/utilization` | Get credit utilization | ⭐ Calculated metric |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/credit-history/health-indicators` | Get credit health | ⭐ Health metrics |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/credit-history/report-request` | Request credit report | ⭐ External API call |

### Pension Summary

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/pension-summary` | Get pension summary | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/pension-summary/calculate` | Calculate pension projection | ⭐ New in v3.0 |

**Total Endpoints:** 96 (85 new in v3.0)

---

## 3. Circumstances Context

**Base Path:** `/api/v1/factfinds/{id}/clients/{clientId}`

**Description:** Client-specific circumstances including employment, income, and expenditure. These resources are nested under clients as they are personal to each client.

### Employment

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/employment` | List employment history | ⭐ Hierarchical |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/employment` | Add employment record | ⭐ Hierarchical |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/employment/{employmentId}` | Get employment details | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/employment/{employmentId}` | Update employment | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/clients/{clientId}/employment/{employmentId}` | Delete employment | ⭐ New in v3.0 |

### Income

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/income` | List income sources | ⭐ Hierarchical |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/income` | Add income source | ⭐ Hierarchical |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/income/{incomeId}` | Get income details | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/income/{incomeId}` | Update income | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/clients/{clientId}/income/{incomeId}` | Delete income | ⭐ New in v3.0 |

### Income Changes

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/income-changes` | List income changes | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/income-changes` | Record income change | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/income-changes/{changeId}` | Get income change details | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/income-changes/{changeId}` | Update income change | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/clients/{clientId}/income-changes/{changeId}` | Delete income change | ⭐ New in v3.0 |

### Expenditure

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/expenditure` | List expenditure items | ⭐ Hierarchical |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/expenditure` | Add expenditure | ⭐ Hierarchical |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/expenditure/{expenditureId}` | Get expenditure details | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/expenditure/{expenditureId}` | Update expenditure | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/clients/{clientId}/expenditure/{expenditureId}` | Delete expenditure | ⭐ New in v3.0 |

### Expenditure Changes

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/expenditure-changes` | List expenditure changes | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/clients/{clientId}/expenditure-changes` | Record expenditure change | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/expenditure-changes/{changeId}` | Get expenditure change | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/clients/{clientId}/expenditure-changes/{changeId}` | Update expenditure change | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/clients/{clientId}/expenditure-changes/{changeId}` | Delete expenditure change | ⭐ New in v3.0 |

### Budget Summary

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/clients/{clientId}/budget` | Get budget summary | ⭐ Hierarchical |

**Total Endpoints:** 26 (26 new in v3.0)

---

## 4. Assets & Liabilities Context

**Base Path:** `/api/v1/factfinds/{id}/assets`

**Description:** Factfind-level assets and liabilities. Assets can be jointly owned by multiple clients within the same factfind.

### Assets

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/assets` | List all assets | ⭐ Hierarchical |
| POST | `/api/v1/factfinds/{id}/assets` | Add asset | ⭐ Hierarchical |
| GET | `/api/v1/factfinds/{id}/assets/{assetId}` | Get asset details | ⭐ With embedded details |
| PATCH | `/api/v1/factfinds/{id}/assets/{assetId}` | Update asset | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}/assets/{assetId}` | Delete asset | ⭐ Soft delete |

### Liabilities

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/liabilities` | List all liabilities | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/liabilities` | Add liability | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/liabilities/{liabilityId}` | Get liability details | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/liabilities/{liabilityId}` | Update liability | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/liabilities/{liabilityId}` | Delete liability | ⭐ New in v3.0 |

### Property Details (Embedded in Assets)

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/assets/{assetId}/property-detail` | Get property detail | ⭐ For asset_type=property |
| PATCH | `/api/v1/factfinds/{id}/assets/{assetId}/property-detail` | Update property detail | ⭐ Embedded detail |
| GET | `/api/v1/factfinds/{id}/assets/{assetId}/property-detail/valuations` | Get valuation history | ⭐ Property valuations |
| POST | `/api/v1/factfinds/{id}/assets/{assetId}/property-detail/valuations` | Add property valuation | ⭐ New valuation |
| GET | `/api/v1/factfinds/{id}/assets/{assetId}/property-detail/capital-gains` | Calculate CGT | ⭐ Tax calculation |--------|----------|-------------|-------|

### Aggregated Views

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/assets/summary` | Get assets summary | ⭐ Aggregated totals |
| GET | `/api/v1/factfinds/{id}/liabilities/summary` | Get liabilities summary | ⭐ Aggregated totals |
| GET | `/api/v1/factfinds/{id}/net-worth` | Calculate net worth | ⭐ Assets - Liabilities |

**Total Endpoints:** 23 (23 new in v3.0)

**Note:** Rental yield values are calculated and stored as part of the property details contract. No separate calculation endpoint is provided.

---

## 5. Arrangements Context

**Base Path:** `/api/v1/factfinds/{id}/arrangements`

**Description:** Type-based financial arrangements including investments, pensions, mortgages, and protection policies. Hierarchical structure with type-specific endpoints.

### List All Arrangements

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/arrangements` | List all arrangements | ⭐ Common properties only |

### Investment Arrangements

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/arrangements/investments` | List all investments | ⭐ All investment types |
| POST | `/api/v1/factfinds/{id}/arrangements/investments/GIA` | Create GIA | ⭐ General Investment Account |
| GET | `/api/v1/factfinds/{id}/arrangements/investments/GIA` | List GIAs | ⭐ Filter by type |
| GET | `/api/v1/factfinds/{id}/arrangements/investments/GIA/{arrangementId}` | Get GIA details | ⭐ Specific GIA |
| PATCH | `/api/v1/factfinds/{id}/arrangements/investments/GIA/{arrangementId}` | Update GIA | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}/arrangements/investments/GIA/{arrangementId}` | Delete GIA | ⭐ Soft delete |
| POST | `/api/v1/factfinds/{id}/arrangements/investments/ISA` | Create ISA | ⭐ Individual Savings Account |
| GET | `/api/v1/factfinds/{id}/arrangements/investments/ISA` | List ISAs | ⭐ Filter by type |
| GET | `/api/v1/factfinds/{id}/arrangements/investments/ISA/{arrangementId}` | Get ISA details | ⭐ Specific ISA |
| PATCH | `/api/v1/factfinds/{id}/arrangements/investments/ISA/{arrangementId}` | Update ISA | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}/arrangements/investments/ISA/{arrangementId}` | Delete ISA | ⭐ Soft delete |
| POST | `/api/v1/factfinds/{id}/arrangements/investments/Bonds` | Create Bond | ⭐ Investment Bonds |
| GET | `/api/v1/factfinds/{id}/arrangements/investments/Bonds` | List Bonds | ⭐ Filter by type |
| GET | `/api/v1/factfinds/{id}/arrangements/investments/Bonds/{arrangementId}` | Get Bond details | ⭐ Specific Bond |
| PATCH | `/api/v1/factfinds/{id}/arrangements/investments/Bonds/{arrangementId}` | Update Bond | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}/arrangements/investments/Bonds/{arrangementId}` | Delete Bond | ⭐ Soft delete |
| POST | `/api/v1/factfinds/{id}/arrangements/investments/Investment-Trust` | Create Investment Trust | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/investments/Investment-Trust` | List Investment Trusts | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/investments/Investment-Trust/{arrangementId}` | Get Investment Trust | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/investments/Investment-Trust/{arrangementId}` | Update Investment Trust | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/investments/Investment-Trust/{arrangementId}` | Delete Investment Trust | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/arrangements/investments/Platform-Account` | Create Platform Account | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/investments/Platform-Account` | List Platform Accounts | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/investments/Platform-Account/{arrangementId}` | Get Platform Account | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/investments/Platform-Account/{arrangementId}` | Update Platform Account | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/investments/Platform-Account/{arrangementId}` | Delete Platform Account | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/arrangements/investments/Offshore-Bond` | Create Offshore Bond | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/investments/Offshore-Bond` | List Offshore Bonds | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/investments/Offshore-Bond/{arrangementId}` | Get Offshore Bond | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/investments/Offshore-Bond/{arrangementId}` | Update Offshore Bond | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/investments/Offshore-Bond/{arrangementId}` | Delete Offshore Bond | ⭐ New in v3.0 |

### Pension Arrangements

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/arrangements/pensions` | List all pensions | ⭐ All pension types |
| POST | `/api/v1/factfinds/{id}/arrangements/pensions/personal-pension` | Create Personal Pension | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/personal-pension` | List Personal Pensions | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/personal-pension/{arrangementId}` | Get Personal Pension | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/pensions/personal-pension/{arrangementId}` | Update Personal Pension | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/pensions/personal-pension/{arrangementId}` | Delete Personal Pension | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/arrangements/pensions/state-pension` | Create State Pension | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/state-pension` | List State Pensions | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/state-pension/{arrangementId}` | Get State Pension | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/pensions/state-pension/{arrangementId}` | Update State Pension | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/pensions/state-pension/{arrangementId}` | Delete State Pension | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/arrangements/pensions/workplace-pension` | Create Workplace Pension | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/workplace-pension` | List Workplace Pensions | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/workplace-pension/{arrangementId}` | Get Workplace Pension | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/pensions/workplace-pension/{arrangementId}` | Update Workplace Pension | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/pensions/workplace-pension/{arrangementId}` | Delete Workplace Pension | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/arrangements/pensions/SIPP` | Create SIPP | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/SIPP` | List SIPPs | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/SIPP/{arrangementId}` | Get SIPP | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/pensions/SIPP/{arrangementId}` | Update SIPP | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/pensions/SIPP/{arrangementId}` | Delete SIPP | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/arrangements/pensions/final-salary` | Create Final Salary | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/final-salary` | List Final Salary | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/final-salary/{arrangementId}` | Get Final Salary | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/pensions/final-salary/{arrangementId}` | Update Final Salary | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/pensions/final-salary/{arrangementId}` | Delete Final Salary | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/arrangements/pensions/drawdown` | Create Drawdown | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/drawdown` | List Drawdowns | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/drawdown/{arrangementId}` | Get Drawdown | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/pensions/drawdown/{arrangementId}` | Update Drawdown | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/pensions/drawdown/{arrangementId}` | Delete Drawdown | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/arrangements/pensions/annuity` | Create Annuity | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/annuity` | List Annuities | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/pensions/annuity/{arrangementId}` | Get Annuity | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/pensions/annuity/{arrangementId}` | Update Annuity | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/pensions/annuity/{arrangementId}` | Delete Annuity | ⭐ New in v3.0 |

### Mortgage Arrangements

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/arrangements/mortgages` | List all mortgages | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/arrangements/mortgages` | Create mortgage | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/mortgages/{arrangementId}` | Get mortgage details | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/mortgages/{arrangementId}` | Update mortgage | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/mortgages/{arrangementId}` | Delete mortgage | ⭐ New in v3.0 |

### Protection Arrangements

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/arrangements/protections` | List all protection | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/arrangements/protections/personal-protection` | Create Personal Protection | ⭐ Life, CI, IP |
| GET | `/api/v1/factfinds/{id}/arrangements/protections/personal-protection` | List Personal Protection | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/protections/personal-protection/{arrangementId}` | Get Personal Protection | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/protections/personal-protection/{arrangementId}` | Update Personal Protection | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/protections/personal-protection/{arrangementId}` | Delete Personal Protection | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/arrangements/protections/general-insurance` | Create General Insurance | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/protections/general-insurance` | List General Insurance | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/arrangements/protections/general-insurance/{arrangementId}` | Get General Insurance | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/arrangements/protections/general-insurance/{arrangementId}` | Update General Insurance | ⭐ New in v3.0 |
| DELETE | `/api/v1/factfinds/{id}/arrangements/protections/general-insurance/{arrangementId}` | Delete General Insurance | ⭐ New in v3.0 |

### Arrangement Sub-resources

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/contributions` | List contributions | ⭐ All contribution records |
| POST | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/contributions` | Add contribution | ⭐ New contribution |
| GET | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/contributions/{contributionId}` | Get contribution details | ⭐ Specific contribution |
| PATCH | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/contributions/{contributionId}` | Update contribution | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/contributions/{contributionId}` | Delete contribution | ⭐ Remove contribution |
| GET | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/withdrawals` | List withdrawals | ⭐ All withdrawal records |
| POST | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/withdrawals` | Add withdrawal | ⭐ New withdrawal |
| GET | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/withdrawals/{withdrawalId}` | Get withdrawal details | ⭐ Specific withdrawal |
| PATCH | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/withdrawals/{withdrawalId}` | Update withdrawal | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/withdrawals/{withdrawalId}` | Delete withdrawal | ⭐ Remove withdrawal |
| GET | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/beneficiaries` | List beneficiaries | ⭐ All beneficiaries |
| POST | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/beneficiaries` | Add beneficiary | ⭐ New beneficiary |
| GET | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/beneficiaries/{beneficiaryId}` | Get beneficiary details | ⭐ Specific beneficiary |
| PATCH | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/beneficiaries/{beneficiaryId}` | Update beneficiary | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/beneficiaries/{beneficiaryId}` | Delete beneficiary | ⭐ Remove beneficiary |
| GET | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/valuations` | List valuations | ⭐ Valuation history |
| POST | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/valuations` | Add valuation | ⭐ New valuation |
| GET | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/valuations/{valuationId}` | Get valuation details | ⭐ Specific valuation |
| PATCH | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/valuations/{valuationId}` | Update valuation | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/valuations/{valuationId}` | Delete valuation | ⭐ Remove valuation |

**Total Endpoints:** 109 (109 new in v3.0)

---

## 6. Goals Context

**Base Path:** `/api/v1/factfinds/{id}/objectives`

**Description:** Type-based objectives and goals with hierarchical structure. Objectives are categorized by type (investment, pension, protection, mortgage, budget, estate-planning).

### Objectives by Type

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/objectives` | List all objectives | ⭐ All types |
| POST | `/api/v1/factfinds/{id}/objectives/investment` | Create Investment Objective | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/objectives/investment` | List Investment Objectives | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/objectives/investment/{objectiveId}` | Get Investment Objective | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/objectives/investment/{objectiveId}` | Update Investment Objective | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/objectives/pension` | Create Pension Objective | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/objectives/pension` | List Pension Objectives | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/objectives/pension/{objectiveId}` | Get Pension Objective | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/objectives/pension/{objectiveId}` | Update Pension Objective | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/objectives/protection` | Create Protection Objective | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/objectives/protection` | List Protection Objectives | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/objectives/protection/{objectiveId}` | Get Protection Objective | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/objectives/protection/{objectiveId}` | Update Protection Objective | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/objectives/mortgage` | Create Mortgage Objective | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/objectives/mortgage` | List Mortgage Objectives | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/objectives/mortgage/{objectiveId}` | Get Mortgage Objective | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/objectives/mortgage/{objectiveId}` | Update Mortgage Objective | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/objectives/budget` | Create Budget Objective | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/objectives/budget` | List Budget Objectives | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/objectives/budget/{objectiveId}` | Get Budget Objective | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/objectives/budget/{objectiveId}` | Update Budget Objective | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/objectives/estate-planning` | Create Estate Planning Objective | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/objectives/estate-planning` | List Estate Planning Objectives | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/objectives/estate-planning/{objectiveId}` | Get Estate Planning Objective | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/objectives/estate-planning/{objectiveId}` | Update Estate Planning Objective | ⭐ New in v3.0 |
| **DELETE** | **`/api/v1/factfinds/{id}/objectives/{objectiveId}`** | **Delete any objective (all types)** | **⭐ Type-agnostic delete** |

**Note:** DELETE operation does not require type in the path. The objective ID is sufficient to identify and delete the objective regardless of its type.

### Objective Sub-resources (Needs)

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/objectives/{objectiveId}/needs` | List needs | ⭐ All needs for objective |
| POST | `/api/v1/factfinds/{id}/objectives/{objectiveId}/needs` | Add need | ⭐ New need |
| GET | `/api/v1/factfinds/{id}/objectives/{objectiveId}/needs/{needId}` | Get need details | ⭐ Specific need |
| PATCH | `/api/v1/factfinds/{id}/objectives/{objectiveId}/needs/{needId}` | Update need | ⭐ Partial updates |
| DELETE | `/api/v1/factfinds/{id}/objectives/{objectiveId}/needs/{needId}` | Delete need | ⭐ Remove need |

**Total Endpoints:** 31 (31 new in v3.0) - 26 objective operations + 5 needs operations

---

## 7. ATR Context

**Base Path:** `/api/v1/factfinds/{id}`

**Description:** Attitude to Risk (ATR) assessment including risk questionnaires, supplementary questions, and declarations.

### ATR Assessment

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/attitude-to-risk` | Get ATR assessment | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/attitude-to-risk` | Create ATR assessment | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/attitude-to-risk` | Update ATR assessment | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/attitude-to-risk/history` | Get ATR history | ⭐ Historical assessments |
| GET | `/api/v1/factfinds/{id}/attitude-to-risk/compare` | Compare ATR (Risk Replay) | ⭐ Compare assessments |

### Risk Questionnaire

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/attitude-to-risk/questionnaire` | Get questionnaire | ⭐ Active questionnaire |
| POST | `/api/v1/factfinds/{id}/attitude-to-risk/questionnaire/responses` | Submit responses | ⭐ Submit answers |
| GET | `/api/v1/factfinds/{id}/attitude-to-risk/questionnaire/responses` | Get responses | ⭐ Get answers |
| PATCH | `/api/v1/factfinds/{id}/attitude-to-risk/questionnaire/responses/{responseId}` | Update response | ⭐ Update answer |

### Supplementary Questions

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/supplementary-questions` | Get supplementary questions | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/supplementary-questions/responses` | Submit responses | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/supplementary-questions/responses` | Get responses | ⭐ New in v3.0 |
| PATCH | `/api/v1/factfinds/{id}/supplementary-questions/responses/{responseId}` | Update response | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/supplementary-questions/completion-status` | Get completion status | ⭐ New in v3.0 |

### Declaration Capture

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/factfinds/{id}/declarations` | Get declarations | ⭐ New in v3.0 |
| GET | `/api/v1/factfinds/{id}/declarations/status` | Get signature status | ⭐ New in v3.0 |
| POST | `/api/v1/factfinds/{id}/declarations/client-sign` | Client signature | ⭐ Client signs |
| POST | `/api/v1/factfinds/{id}/declarations/adviser-sign` | Adviser signature | ⭐ Adviser signs |
| POST | `/api/v1/factfinds/{id}/declarations/consent` | Record consent | ⭐ Consent capture |
| GET | `/api/v1/factfinds/{id}/declarations/signature-history` | Get signature history | ⭐ Audit trail |
| GET | `/api/v1/factfinds/{id}/declarations/consent-audit` | Get consent audit | ⭐ Consent audit |

**Total Endpoints:** 22 (22 new in v3.0)

---

## 8. Reference Data API

**Base Path:** `/api/v1/reference`

**Description:** Reference data endpoints for enumerations, lookup values, and reference entities.

### Enumeration Value Types

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/reference/genders` | Get gender values | Static reference |
| GET | `/api/v1/reference/marital-statuses` | Get marital status values | Static reference |
| GET | `/api/v1/reference/employment-statuses` | Get employment status values | Static reference |
| GET | `/api/v1/reference/titles` | Get title values | Static reference |
| GET | `/api/v1/reference/address-types` | Get address type values | Static reference |
| GET | `/api/v1/reference/contact-types` | Get contact type values | Static reference |
| GET | `/api/v1/reference/meeting-types` | Get meeting type values | Static reference |
| GET | `/api/v1/reference/statuses` | Get status values | Static reference |
| GET | `/api/v1/reference/relationship-types` | Get relationship type values | ⭐ New in v3.0 |
| GET | `/api/v1/reference/asset-types` | Get asset type values | ⭐ New in v3.0 |
| GET | `/api/v1/reference/liability-types` | Get liability type values | ⭐ New in v3.0 |
| GET | `/api/v1/reference/income-types` | Get income type values | ⭐ New in v3.0 |
| GET | `/api/v1/reference/expenditure-types` | Get expenditure type values | ⭐ New in v3.0 |
| GET | `/api/v1/reference/arrangement-types` | Get arrangement type values | ⭐ New in v3.0 |
| GET | `/api/v1/reference/objective-types` | Get objective type values | ⭐ New in v3.0 |

### Lookup Value Types

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/reference/countries` | Get country values | Lookup table |
| GET | `/api/v1/reference/counties` | Get county values | Lookup table |
| GET | `/api/v1/reference/currencies` | Get currency values | Lookup table |
| GET | `/api/v1/reference/frequencies` | Get frequency values | Lookup table |
| GET | `/api/v1/reference/product-types` | Get product type values | Lookup table |

### Reference Entities

| Method | Endpoint | Description | Notes |
|--------|----------|-------------|-------|
| GET | `/api/v1/providers` | List providers | Provider catalog |
| GET | `/api/v1/providers/{id}` | Get provider details | Specific provider |
| GET | `/api/v1/advisers` | List advisers | Adviser catalog |
| GET | `/api/v1/advisers/{id}` | Get adviser details | Specific adviser |

**Total Endpoints:** 24 (7 new in v3.0)

---

## Summary Statistics

### Endpoints by Context

| API Context | Total Endpoints | New in v3.0 |
|-------------|-----------------|-------------|
| **1. FactFind Root** | 11 | 11 ⭐ |
| **2. Client Onboarding & KYC** | 96 | 85 ⭐ |
| **3. Circumstances** | 26 | 26 ⭐ |
| **4. Assets & Liabilities** | 23 | 23 ⭐ |
| **5. Arrangements** | 109 | 109 ⭐ |
| **6. Goals** | 31 | 31 ⭐ |
| **7. ATR** | 22 | 22 ⭐ |
| **8. Reference Data** | 24 | 7 ⭐ |
| **TOTAL** | **342** | **314** |


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
| GET | 163 | 48% |
| POST | 82 | 24% |
| PATCH | 85 | 25% |
| DELETE | 12 | 3% |
| **TOTAL** | **342** | **100%** |

### Hierarchical Depth Analysis

| Depth Level | Example Path | Endpoints |
|-------------|--------------|-----------|
| **Level 1** | `/api/v1/factfinds` | 11 |
| **Level 2** | `/api/v1/factfinds/{id}/clients` | 48 |
| **Level 3** | `/api/v1/factfinds/{id}/clients/{clientId}/addresses` | 142 |
| **Level 4** | `/api/v1/factfinds/{id}/arrangements/{arrangementId}/contributions/{contributionId}` | 147 |

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
- Section 2.8: Marketing Consent API (Marketing consent)
- Section 2.11: Identity Verification (Data processing)
- Section 7.3: Declaration Capture (Consent management)

### MLR 2017 Compliance (AML/KYC)
- Section 2.11: Identity Verification API (KYC/AML)
- Section 2.13: Credit History (Financial crime checks)
- Section 2.5: Professional Contacts (Beneficial ownership)

### PECR Compliance
- Section 2.8: Marketing Consent API (Electronic marketing)
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
**Last Updated:** 2026-02-20
**Total Endpoints:** 347
