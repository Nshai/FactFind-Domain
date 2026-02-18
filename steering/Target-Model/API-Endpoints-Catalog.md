# FactFind API v2.0 - Complete Endpoints Catalog

**Document Purpose:** Quick reference catalog of all 110+ API endpoints in the FactFind API Design v2.0

**Date:** 2026-02-18
**API Version:** v2.0
**Base URL:** `https://api.factfind.com`

---

## Table of Contents

1. [FactFind Root API (Section 4)](#1-factfind-root-api)
2. [Clients API (Section 5)](#2-clients-api)
3. [Income & Expenditure API (Section 6)](#3-income--expenditure-api)
4. [Arrangements API (Section 7)](#4-arrangements-api)
5. [Goals API (Section 8)](#5-goals-api)
6. [Assets & Liabilities API (Section 9)](#6-assets--liabilities-api)
7. [Savings & Investments API (Section 9A)](#7-savings--investments-api)
8. [Risk Profile API (Section 10)](#8-risk-profile-api)
9. [Estate Planning API (Section 11)](#9-estate-planning-api)
10. [Reference Data API (Section 12)](#10-reference-data-api)

---

## 1. FactFind Root API

**Base Path:** `/api/v1/factfinds`

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds` | List all fact finds | 4.3.1 |
| POST | `/api/v1/factfinds` | Create new fact find | 4.3.2 |
| GET | `/api/v1/factfinds/{factfindId}` | Get fact find details | 4.3.3 |
| PUT | `/api/v1/factfinds/{factfindId}` | Update fact find | 4.3.4 |
| DELETE | `/api/v1/factfinds/{factfindId}` | Delete fact find | 4.3.4 |
| PUT | `/api/v1/factfinds/{factfindId}/vulnerability` | Update vulnerability assessment | 4.3.5 |
| GET | `/api/v1/factfinds/{factfindId}/complete` | Get complete fact find with all nested data | 4.3.6 |
| **GET** | **`/api/v1/factfinds/{factfindId}/current-position`** | **Get current financial position summary** | **4.4** ⭐ |
| **GET** | **`/api/v1/factfinds/{factfindId}/net-worth`** | **Get net worth breakdown** | **4.4** ⭐ |
| **GET** | **`/api/v1/factfinds/{factfindId}/financial-health`** | **Get financial health score** | **4.4** ⭐ |
| **GET** | **`/api/v1/factfinds/{factfindId}/cash-flow`** | **Get cash flow analysis** | **4.4** ⭐ |
| **GET** | **`/api/v1/factfinds/{factfindId}/asset-allocation`** | **Get asset allocation summary** | **4.4** ⭐ |

**Total Endpoints:** 12 (5 new in v2.0)

---

## 2. Clients API

**Base Path:** `/api/v1/factfinds/{factfindId}/clients`

### Core Client Operations

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/clients` | List clients | 5.3.1 |
| POST | `/api/v1/factfinds/{factfindId}/clients` | Create client | 5.3.1 |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}` | Get client details | 5.3.2 |
| PUT | `/api/v1/factfinds/{factfindId}/clients/{clientId}` | Update client | 5.3.2 |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}` | Partial update client | 5.3.2 |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}` | Delete client | 5.3.2 |

### Address Management

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/addresses` | List addresses | 5.3.3 |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/addresses` | Add address | 5.3.3 |
| PUT | `/api/v1/factfinds/{factfindId}/clients/{clientId}/addresses/{id}` | Update address | 5.3.3 |

### Contact Management

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/contacts` | List contacts | 5.3.4 |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/contacts` | Add contact | 5.3.4 |
| PUT | `/api/v1/factfinds/{factfindId}/clients/{clientId}/contacts/{id}` | Update contact | 5.3.4 |

### Identity Verification (NEW v2.0) ⭐

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| **POST** | **`/clients/{clientId}/identity-verification`** | **Submit identity document** | **5.5** |
| **GET** | **`/clients/{clientId}/identity-verification`** | **Get verification status** | **5.5** |
| **PUT** | **`/clients/{clientId}/identity-verification/{id}`** | **Update verification** | **5.5** |
| **GET** | **`/clients/{clientId}/identity-verification/history`** | **Get verification history** | **5.5** |
| **POST** | **`/clients/{clientId}/identity-verification/{id}/aml-check`** | **Trigger AML check** | **5.5** |
| **GET** | **`/clients/{clientId}/identity-verification/{id}/documents`** | **Get documents** | **5.5** |
| **POST** | **`/clients/{clientId}/identity-verification/{id}/documents`** | **Upload document** | **5.5** |

### Data Protection & Consent (NEW v2.0) ⭐

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| **GET** | **`/clients/{clientId}/consent`** | **Get consent status** | **5.6** |
| **PUT** | **`/clients/{clientId}/consent`** | **Update consent** | **5.6** |
| **POST** | **`/clients/{clientId}/consent/record`** | **Record consent event** | **5.6** |
| **GET** | **`/clients/{clientId}/consent/history`** | **Get consent history** | **5.6** |
| **DELETE** | **`/clients/{clientId}/data`** | **Right to be forgotten (RTBF)** | **5.6** |
| **POST** | **`/clients/{clientId}/data/export`** | **Data portability request** | **5.6** |
| **POST** | **`/clients/{clientId}/consent/withdraw`** | **Withdraw consent** | **5.6** |

### Marketing Preferences (NEW v2.0) ⭐

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| **GET** | **`/clients/{clientId}/marketing-preferences`** | **Get preferences** | **5.7** |
| **PUT** | **`/clients/{clientId}/marketing-preferences`** | **Update preferences** | **5.7** |
| **POST** | **`/clients/{clientId}/marketing/opt-in`** | **Opt-in to marketing** | **5.7** |
| **POST** | **`/clients/{clientId}/marketing/opt-out`** | **Opt-out of marketing** | **5.7** |
| **POST** | **`/clients/{clientId}/marketing/unsubscribe`** | **Unsubscribe (one-click)** | **5.7** |
| **GET** | **`/clients/{clientId}/marketing/history`** | **Get preference history** | **5.7** |

**Total Endpoints:** 33 (20 new in v2.0)

---

## 3. Income & Expenditure API

**Base Path:** `/api/v1/factfinds/{factfindId}`

### Income Management

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/income` | List income sources | 6.3.1 |
| POST | `/api/v1/factfinds/{factfindId}/income` | Add income source | 6.3.2 |
| GET | `/api/v1/factfinds/{factfindId}/income/{id}` | Get income details | 6.3.2 |
| PUT | `/api/v1/factfinds/{factfindId}/income/{id}` | Update income | 6.3.2 |
| DELETE | `/api/v1/factfinds/{factfindId}/income/{id}` | Delete income | 6.3.2 |

### Expenditure Management

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/expenditure` | List expenditure items | 6.3.3 |
| POST | `/api/v1/factfinds/{factfindId}/expenditure` | Add expenditure | 6.3.3 |
| GET | `/api/v1/factfinds/{factfindId}/expenditure/{id}` | Get expenditure details | 6.3.3 |
| PUT | `/api/v1/factfinds/{factfindId}/expenditure/{id}` | Update expenditure | 6.3.3 |
| DELETE | `/api/v1/factfinds/{factfindId}/expenditure/{id}` | Delete expenditure | 6.3.3 |

### Budget & Employment

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/budget` | Get budget summary | 6 |
| GET | `/api/v1/factfinds/{factfindId}/employment` | List employment history | 6 |
| POST | `/api/v1/factfinds/{factfindId}/employment` | Add employment | 6 |

**Total Endpoints:** 13

---

## 4. Arrangements API

**Base Path:** `/api/v1/factfinds/{factfindId}/arrangements`

### Core Arrangement Operations

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/arrangements` | List arrangements | 7.3.1 |
| POST | `/api/v1/factfinds/{factfindId}/arrangements` | Create arrangement | 7.3.1 |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{id}` | Get arrangement details | 7.3.1 |
| PUT | `/api/v1/factfinds/{factfindId}/arrangements/{id}` | Update arrangement | 7.3.1 |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/{id}` | Delete arrangement | 7.3.1 |

### Contributions

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{id}/contributions` | List contributions | 7.3.2 |
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{id}/contributions` | Add contribution | 7.3.2 |
| PUT | `/api/v1/factfinds/{factfindId}/arrangements/{id}/contributions/{contribId}` | Update contribution | 7.3.2 |

### Valuations

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{id}/valuations` | List valuations | 7.3.3 |
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{id}/valuations` | Add valuation | 7.3.3 |

### Withdrawals & Beneficiaries

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{id}/withdrawals` | List withdrawals | 7 |
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{id}/withdrawals` | Add withdrawal | 7 |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{id}/beneficiaries` | List beneficiaries | 7 |
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{id}/beneficiaries` | Add beneficiary | 7 |

**Total Endpoints:** 14

---

## 5. Goals API

**Base Path:** `/api/v1/factfinds/{factfindId}/goals`

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/goals` | List goals | 8.3.1 |
| POST | `/api/v1/factfinds/{factfindId}/goals` | Create goal | 8.3.1 |
| GET | `/api/v1/factfinds/{factfindId}/goals/{id}` | Get goal details | 8.3.1 |
| PUT | `/api/v1/factfinds/{factfindId}/goals/{id}` | Update goal | 8.3.1 |
| DELETE | `/api/v1/factfinds/{factfindId}/goals/{id}` | Delete goal | 8.3.1 |
| POST | `/api/v1/factfinds/{factfindId}/goals/{id}/complete` | Mark goal complete | 8 |
| GET | `/api/v1/factfinds/{factfindId}/goals/{id}/objectives` | List objectives | 8 |
| POST | `/api/v1/factfinds/{factfindId}/goals/{id}/objectives` | Add objective | 8 |

**Total Endpoints:** 8

---

## 6. Assets & Liabilities API

**Base Path:** `/api/v1/factfinds/{factfindId}`

### Assets & Liabilities

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/assets` | List assets | 9 |
| POST | `/api/v1/factfinds/{factfindId}/assets` | Add asset | 9 |
| GET | `/api/v1/factfinds/{factfindId}/liabilities` | List liabilities | 9 |
| POST | `/api/v1/factfinds/{factfindId}/liabilities` | Add liability | 9 |

### Property Management (NEW v2.0) ⭐

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| **POST** | **`/factfinds/{factfindId}/properties`** | **Add property** | **9.4** |
| **GET** | **`/factfinds/{factfindId}/properties`** | **List properties** | **9.4** |
| **GET** | **`/factfinds/{factfindId}/properties/{id}`** | **Get property details** | **9.4** |
| **PUT** | **`/factfinds/{factfindId}/properties/{id}`** | **Update property** | **9.4** |
| **DELETE** | **`/factfinds/{factfindId}/properties/{id}`** | **Delete property** | **9.4** |
| **POST** | **`/factfinds/{factfindId}/properties/{id}/valuations`** | **Add valuation** | **9.4** |
| **GET** | **`/factfinds/{factfindId}/properties/{id}/valuations`** | **Get valuation history** | **9.4** |
| **GET** | **`/factfinds/{factfindId}/properties/{id}/ltv`** | **Calculate LTV** | **9.4** |
| **GET** | **`/factfinds/{factfindId}/properties/{id}/rental-yield`** | **Calculate rental yield** | **9.4** |
| **GET** | **`/factfinds/{factfindId}/properties/{id}/capital-gains`** | **Calculate CGT** | **9.4** |

### Equities Portfolio (NEW v2.0) ⭐

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| **POST** | **`/factfinds/{factfindId}/equities`** | **Add equity holding** | **9.5** |
| **GET** | **`/factfinds/{factfindId}/equities`** | **List equities** | **9.5** |
| **GET** | **`/factfinds/{factfindId}/equities/{id}`** | **Get equity details** | **9.5** |
| **PUT** | **`/factfinds/{factfindId}/equities/{id}`** | **Update equity** | **9.5** |
| **DELETE** | **`/factfinds/{factfindId}/equities/{id}`** | **Delete equity** | **9.5** |
| **GET** | **`/factfinds/{factfindId}/equities/portfolio-performance`** | **Get portfolio performance** | **9.5** |
| **GET** | **`/factfinds/{factfindId}/equities/{id}/dividends`** | **Get dividend history** | **9.5** |
| **POST** | **`/factfinds/{factfindId}/equities/{id}/dividends`** | **Record dividend** | **9.5** |
| **GET** | **`/factfinds/{factfindId}/equities/{id}/capital-gains`** | **Calculate CGT** | **9.5** |
| **POST** | **`/factfinds/{factfindId}/equities/{id}/corporate-actions`** | **Record corporate action** | **9.5** |

### Credit History (NEW v2.0) ⭐

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| **POST** | **`/clients/{clientId}/credit-scores`** | **Add credit score** | **9.6** |
| **GET** | **`/clients/{clientId}/credit-scores`** | **Get credit history** | **9.6** |
| **GET** | **`/clients/{clientId}/credit-status`** | **Get current status** | **9.6** |
| **POST** | **`/clients/{clientId}/payment-history`** | **Record payment event** | **9.6** |
| **GET** | **`/clients/{clientId}/payment-history`** | **Get payment history** | **9.6** |
| **GET** | **`/clients/{clientId}/credit-utilization`** | **Get utilization** | **9.6** |
| **GET** | **`/clients/{clientId}/credit-health`** | **Get health indicators** | **9.6** |
| **POST** | **`/clients/{clientId}/credit-report`** | **Request credit report** | **9.6** |

**Total Endpoints:** 32 (28 new in v2.0)

---

## 7. Savings & Investments API (NEW SECTION v2.0) ⭐

**Base Path:** `/api/v1/factfinds/{factfindId}/investments`

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| **GET** | **`/factfinds/{factfindId}/investments`** | **List investments** | **9A** |
| **POST** | **`/factfinds/{factfindId}/investments`** | **Create investment** | **9A** |
| **GET** | **`/factfinds/{factfindId}/investments/{id}`** | **Get investment details** | **9A** |
| **PUT** | **`/factfinds/{factfindId}/investments/{id}`** | **Update investment** | **9A** |
| **DELETE** | **`/factfinds/{factfindId}/investments/{id}`** | **Delete investment** | **9A** |
| **GET** | **`/factfinds/{factfindId}/investments/summary`** | **Get portfolio summary** | **9A** |
| **GET** | **`/factfinds/{factfindId}/investments/performance`** | **Get performance** | **9A** |
| **GET** | **`/factfinds/{factfindId}/investments/asset-allocation`** | **Get asset allocation** | **9A** |
| **POST** | **`/factfinds/{factfindId}/investments/rebalance`** | **Generate rebalancing** | **9A** |
| **GET** | **`/factfinds/{factfindId}/investments/tax-analysis`** | **Analyze tax wrappers** | **9A** |

**Total Endpoints:** 10 (all new in v2.0)

---

## 8. Risk Profile API

**Base Path:** `/api/v1/factfinds/{factfindId}`

### Risk Questionnaire (NEW v2.0) ⭐

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| **GET** | **`/factfinds/{factfindId}/risk-questionnaires`** | **List questionnaires** | **10.4** |
| **GET** | **`/factfinds/{factfindId}/risk-questionnaires/{id}`** | **Get questionnaire** | **10.4** |
| **POST** | **`/factfinds/{factfindId}/risk-questionnaires`** | **Create questionnaire** | **10.4** |
| **PUT** | **`/factfinds/{factfindId}/risk-questionnaires/{id}`** | **Update questionnaire** | **10.4** |
| **POST** | **`/factfinds/{factfindId}/risk-questionnaires/{id}/questions`** | **Add question** | **10.4** |
| **GET** | **`/factfinds/{factfindId}/risk-questionnaires/{id}/questions`** | **Get questions** | **10.4** |
| **POST** | **`/factfinds/{factfindId}/risk-questionnaires/{id}/activate`** | **Activate version** | **10.4** |

### Risk Assessment History (NEW v2.0) ⭐

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| **GET** | **`/factfinds/{factfindId}/risk-profiles/history`** | **Get history** | **10.5** |
| **GET** | **`/factfinds/{factfindId}/risk-profiles/compare`** | **Compare (Risk Replay)** | **10.5** |
| **GET** | **`/factfinds/{factfindId}/risk-profiles/evolution`** | **Get evolution** | **10.5** |
| **POST** | **`/factfinds/{factfindId}/risk-profiles/snapshot`** | **Create snapshot** | **10.5** |
| **GET** | **`/factfinds/{factfindId}/risk-profiles/{id}`** | **Get historical profile** | **10.5** |

### Supplementary Questions (NEW v2.0) ⭐

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| **GET** | **`/factfinds/{factfindId}/supplementary-questions`** | **Get questions** | **10.6** |
| **POST** | **`/factfinds/{factfindId}/supplementary-questions/responses`** | **Submit responses** | **10.6** |
| **PUT** | **`/factfinds/{factfindId}/supplementary-questions/responses/{id}`** | **Update response** | **10.6** |
| **GET** | **`/factfinds/{factfindId}/supplementary-questions/completion-status`** | **Get completion** | **10.6** |

### Declaration Capture (NEW v2.0) ⭐

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| **GET** | **`/factfinds/{factfindId}/declarations/status`** | **Get status** | **10.7** |
| **POST** | **`/factfinds/{factfindId}/declarations/client-sign`** | **Client signature** | **10.7** |
| **POST** | **`/factfinds/{factfindId}/declarations/adviser-sign`** | **Adviser signature** | **10.7** |
| **POST** | **`/factfinds/{factfindId}/declarations/consent`** | **Record consent** | **10.7** |
| **GET** | **`/factfinds/{factfindId}/declarations/signature-history`** | **Get signature history** | **10.7** |
| **GET** | **`/factfinds/{factfindId}/declarations/consent-audit`** | **Get consent audit** | **10.7** |

**Total Endpoints:** 22 (all new in v2.0)

---

## 9. Estate Planning API

**Base Path:** `/api/v1/factfinds/{factfindId}`

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/factfinds/{factfindId}/gifts` | List gifts | 11 |
| POST | `/api/v1/factfinds/{factfindId}/gifts` | Record gift | 11 |
| GET | `/api/v1/factfinds/{factfindId}/gifts/{id}` | Get gift details | 11 |
| PUT | `/api/v1/factfinds/{factfindId}/gifts/{id}` | Update gift | 11 |
| GET | `/api/v1/factfinds/{factfindId}/gift-trusts` | List gift trusts | 11 |
| POST | `/api/v1/factfinds/{factfindId}/gift-trusts` | Create gift trust | 11 |

**Total Endpoints:** 6

---

## 10. Reference Data API

**Base Path:** `/api/v1/reference`

### Enumeration Value Types

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/reference/genders` | Get gender values | 12 |
| GET | `/api/v1/reference/marital-statuses` | Get marital status values | 12 |
| GET | `/api/v1/reference/employment-statuses` | Get employment status values | 12 |
| GET | `/api/v1/reference/titles` | Get title values | 12 |
| GET | `/api/v1/reference/address-types` | Get address type values | 12 |
| GET | `/api/v1/reference/contact-types` | Get contact type values | 12 |
| GET | `/api/v1/reference/meeting-types` | Get meeting type values | 12 |
| GET | `/api/v1/reference/statuses` | Get status values | 12 |

### Lookup Value Types

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/reference/countries` | Get country values | 12 |
| GET | `/api/v1/reference/counties` | Get county values | 12 |
| GET | `/api/v1/reference/currencies` | Get currency values | 12 |
| GET | `/api/v1/reference/frequencies` | Get frequency values | 12 |
| GET | `/api/v1/reference/product-types` | Get product type values | 12 |

### Reference Entities

| Method | Endpoint | Description | Section |
|--------|----------|-------------|---------|
| GET | `/api/v1/providers` | List providers | 12 |
| GET | `/api/v1/providers/{id}` | Get provider details | 12 |
| GET | `/api/v1/advisers` | List advisers | 12 |
| GET | `/api/v1/advisers/{id}` | Get adviser details | 12 |

**Total Endpoints:** 17

---

## Summary Statistics

| API Section | v1.0 Endpoints | v2.0 Endpoints | New in v2.0 |
|-------------|----------------|----------------|-------------|
| **FactFind Root** | 7 | 12 | 5 ⭐ |
| **Clients** | 13 | 33 | 20 ⭐ |
| **Income & Expenditure** | 13 | 13 | 0 |
| **Arrangements** | 14 | 14 | 0 |
| **Goals** | 8 | 8 | 0 |
| **Assets & Liabilities** | 4 | 32 | 28 ⭐ |
| **Savings & Investments** | 0 | 10 | 10 ⭐ (NEW SECTION) |
| **Risk Profile** | 0 | 22 | 22 ⭐ |
| **Estate Planning** | 6 | 6 | 0 |
| **Reference Data** | 17 | 17 | 0 |
| **TOTAL** | **~82** | **167** | **85** |

---

## Quick Reference by Auth Scope

### Read Operations
- `factfind:read` - Read fact find data
- `client:read` - Read client information
- `assets:read` - Read assets and liabilities
- `investments:read` - Read investment data
- `risk:read` - Read risk assessment data
- `credit:read` - Read credit history

### Write Operations
- `factfind:write` - Create/update fact finds
- `client:write` - Create/update clients
- `assets:write` - Manage assets and liabilities
- `investments:write` - Manage investments
- `risk:write` - Manage risk assessments
- `credit:write` - Add credit scores

### Admin Operations
- `risk:admin` - Manage risk questionnaires
- `client:admin` - RTBF and administrative functions

---

## Quick Reference by Compliance Domain

### FCA/MiFID II Compliance
- Section 10.4-10.7: Risk Assessment APIs
- Section 8: Goals API (suitability)
- Section 7: Arrangements API (product governance)

### GDPR Compliance
- Section 5.6: Data Protection & Consent API
- Section 5.5: Identity Verification API (data processing)
- Section 10.7: Declaration Capture (consent management)

### MLR 2017 Compliance
- Section 5.5: Identity Verification API (KYC/AML)
- Section 4.3.5: Vulnerability Assessment

### PECR Compliance
- Section 5.7: Marketing Preferences API

### Tax Compliance
- Section 9.4: Property Management (CGT, SDLT, PRR)
- Section 9.5: Equities Portfolio (Section 104, CGT)
- Section 9A: Savings & Investments (ISA allowances)

---

**Document End**
