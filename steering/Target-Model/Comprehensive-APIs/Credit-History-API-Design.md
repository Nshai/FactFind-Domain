# Credit-History API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Circumstances

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | Credit-History |
| **Domain** | Circumstances |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Credit history and scores

---

## Common Standards

This document contains **entity-specific** information only. For common standards applicable to all APIs, refer to the **[Master API Design Document](./MASTER-API-DESIGN.md)**:

- **Authentication & Authorization** - See Master Doc Section 4
- **Request/Response Standards** - See Master Doc Section 5
- **Error Handling** - See Master Doc Section 6
- **Security Standards** - See Master Doc Section 7
- **Performance Standards** - See Master Doc Section 8
- **Testing Standards** - See Master Doc Section 9

---

## Operation Summary

### Supported Operations

*Refer to source document for detailed operations.*


### Authorization

**Required Scopes:**
- `credit_history:read` - Read access (GET operations)
- `credit_history:write` - Create and update access (POST, PUT, PATCH)
- `credit_history:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary







### Credit-History Resource Properties

*Fields organized into 8 sections*

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| **Identification** | | | |
| `id` | integer | ✓ | Unique system identifier for this credit history record |
| `href` | string |  | Web link to access this credit history record |
| `factfind` | Reference Link |  | Link to the FactFind this credit history belongs to |
| `client` | Reference Link |  | Link to the client this credit history belongs to |
| **Credit Score Assessment** | | | |
| `creditScore` | Complex Data |  | Credit score information from Credit Reference Agency |
| **Adverse Credit Indicators (Summary)** | | | |
| `hasAdverseCredit` | boolean |  | Does the client have any adverse credit events on their record? |
| `hasCCJ` | boolean |  | Does the client have any County Court Judgments? |
| `hasBeenRefusedCredit` | boolean |  | Has the client been refused credit in the past? |
| `ivaHistory` | boolean |  | Does the client have an Individual Voluntary Arrangement (IVA) history? |
| `hasDefault` | boolean |  | Does the client have any defaults registered on their credit file? |
| `hasBankruptcyHistory` | boolean |  | Does the client have bankruptcy history? |
| `hasArrears` | boolean |  | Does the client currently have or have had payment arrears? |
| **Adverse Credit Events (Detailed Records)** | | | |
| `adverseCreditEvents` | List of Events |  | Detailed list of adverse credit events with financial and timeline information |
| **Missed Payments Summary** | | | |
| `missedPayments` | Complex Data |  | Summary of missed payment history |
| **Mortgage Suitability Assessment** | | | |
| `mortgageSuitability` | Complex Data |  | Automated assessment of mortgage lending eligibility |
| **Additional Information** | | | |
| `notes` | string |  | Free-text notes about credit history, mitigating circumstances, or additional context (max 2000 characters) |
| **System Fields** | | | |
| `createdAt` | timestamp |  | When this credit history record was created in the system |
| `updatedAt` | timestamp |  | When this credit history record was last modified |

*Total: 18 properties across 8 sections*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### creditScore

Credit score information from Credit Reference Agency:

| Field | Type | Description |
|-------|------|-------------|
| `score` | integer | Credit score value (0-999 for Experian, 0-700 for Equifax, 0-710 for TransUnion) |
| `maxScore` | integer | Maximum possible score for this provider |
| `rating` | Selection | Credit rating category: Excellent, Good, Fair, Poor, Very Poor |
| `provider` | Selection | Credit Reference Agency: Experian, Equifax, TransUnion |
| `checkedDate` | date | Date when credit score was obtained |

#### adverseCreditEvents

Each adverse credit event contains:

| Field | Type | Description |
|-------|------|-------------|
| `type` | Selection | Type: CCJ, Default, IVA, Bankruptcy, Arrears, Repossession, Debt Relief Order |
| `registeredOn` | timestamp | Date/time when event was registered with Credit Reference Agencies |
| `satisfiedOrClearedOn` | timestamp | Date/time when the debt was satisfied or cleared |
| `reposessedOn` | timestamp | Date of property repossession (if applicable) |
| `dischargedOn` | timestamp | Date when bankruptcy or IVA was discharged |
| `amountRegistered` | Money | Original amount registered when event occurred |
| `amountOutstanding` | Money | Current outstanding amount (if any) |
| `isDebtOutstanding` | boolean | Is the debt still outstanding or has it been fully paid? |
| `numberOfPaymentsMissed` | integer | Total number of payments missed for this event |
| `consecutivePaymentsMissed` | integer | Maximum number of consecutive payments missed |
| `numberOfPaymentsInArrears` | integer | Number of payments currently in arrears |
| `isArrearsClearedUponCompletion` | boolean | Were arrears cleared when arrangement completed? |
| `yearsMaintained` | integer | Number of years successfully maintained after event (for IVA/payment plans) |
| `lender` | string | Name of lender or creditor involved in the adverse event |
| `liability` | Reference Link | Link to related liability record (if applicable) |
| `concurrencyId` | integer | System version control number (automatic) |
| `createdAt` | timestamp | When this event record was created in the system |
| `lastUpdatedAt` | timestamp | When this event record was last modified |

*Total: 18 fields per event*

#### missedPayments

Summary of missed payment history:

| Field | Type | Description |
|-------|------|-------------|
| `last12Months` | integer | Count of missed payments in the last 12 months (0 = clean record) |
| `last6Years` | integer | Count of missed payments in the last 6 years (used for mortgage affordability) |

#### mortgageSuitability

Automated assessment of mortgage lending eligibility:

| Field | Type | Description |
|-------|------|-------------|
| `overallAssessment` | Selection | Overall suitability: Excellent, Good, Fair, Poor, Very Poor |
| `eligibleForStandardLending` | boolean | Can access standard mainstream mortgage lenders |
| `requiresSpecialistLender` | boolean | May need specialist adverse credit lender |
| `estimatedLTV` | decimal | Estimated Loan-to-Value ratio client may achieve (percentage) |
| `notes` | string | Additional notes about mortgage suitability factors |

#### Reference Link

Standard reference structure:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of the referenced entity |
| `href` | string | API endpoint URL for the referenced entity |

**Used for:** `factfind`, `client`, `liability` (in adverse events)

#### Selection

Enumeration structure:

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Machine-readable code value |
| `display` | string | Human-readable display text |

**Used for:** Credit rating, provider, adverse event types, mortgage suitability

#### Money

Currency amount structure:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Monetary amount |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code (e.g., GBP) |
| `symbol` | string | Currency symbol (e.g., £) |

**Used for:** `amountRegistered`, `amountOutstanding` in adverse events

### Related Resources

*See parent document for relationships to other entities.*


## Data Model