# Mortgage API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Arrangements

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | Mortgage |
| **Domain** | Arrangements |
| **Aggregate Root** | Arrangement |
| **Base Path** | `/api/v2/factfinds/{factfindId}/arrangements/mortgages` |
| **Resource Type** | Collection |

### Description

Mortgage arrangements and lending products

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

| Method | Path | Description | Request | Response | Status Codes | Tags |
|--------|------|-------------|---------|----------|--------------|------|
| GET | `/api/v2/factfinds/{factfindId}/arrangements/mortgages` | List all mortgages | Query params | Mortgage[] | 200, 401, 403 | Mortgage, List |
| POST | `/api/v2/factfinds/{factfindId}/arrangements/mortgages` | Create mortgage | MortgageRequest | Mortgage | 201, 400, 401, 403, 422 | Mortgage, Create |
| GET | `/api/v2/factfinds/{factfindId}/arrangements/mortgages/{arrangementId}` | Get mortgage by ID | Path params | Mortgage | 200, 401, 403, 404 | Mortgage, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/arrangements/mortgages/{arrangementId}` | Update mortgage | MortgagePatch | Mortgage | 200, 400, 401, 403, 404, 422 | Mortgage, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/arrangements/mortgages/{arrangementId}` | Delete mortgage | Path params | None | 204, 401, 403, 404, 422 | Mortgage, Delete |


### Authorization

**Required Scopes:**
- `mortgage:read` - Read access (GET operations)
- `mortgage:write` - Create and update access (POST, PUT, PATCH)
- `mortgage:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary




### Mortgage Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `accountNumber` | string |  |  |
| `agencyStatus` | string |  | Current age (calculated from date of birth) |
| `agencyStatusDate` | date |  | Current age (calculated from date of birth) |
| `arrangementCategory` | string |  | Expenditure category (Housing, Transport, Food, etc.) |
| `asset` | Reference Link |  | Total value of all assets |
| `createdAt` | date |  | When this record was created in the system |
| `description` | string |  | Description of the goal |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `feesAndCharges` | Complex Data |  |  |
| `id` | integer | ✓ | Unique system identifier for this record |
| `illustrationReference` | string |  |  |
| `interestTerms` | Complex Data |  |  |
| `keyDates` | Complex Data |  |  |
| `lenderName` | string |  |  |
| `linkedArrangements` | List of Complex Data |  |  |
| `loanAmounts` | Complex Data |  | Amount spent |
| `notes` | string |  |  |
| `offsetFeatures` | Complex Data |  |  |
| `owners` | List of Complex Data |  | Who owns this arrangement |
| `policyNumber` | string |  | Policy or account number |
| `productName` | string |  | Name of the financial product |
| `productType` | string |  |  |
| `property` | Reference Link |  | Type of property (Residential, Buy-to-Let, Commercial, etc.) |
| `propertyDetail` | Reference Link |  |  |
| `redemptionTerms` | Complex Data |  |  |
| `repaymentStructure` | Complex Data |  |  |
| `sellingAdviser` | Reference Link |  |  |
| `sharedOwnershipDetails` | Complex Data |  | Who owns this arrangement |
| `specialFeatures` | Complex Data |  |  |
| `updatedAt` | date |  | When this record was last modified |

*Total: 30 properties*


### Referenced Type Definitions

The following complex types are used in the properties above:

#### asset

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for this record |

#### currentLTV

| Field | Type | Description |
|-------|------|-------------|
| `percentage` | integer | Current LTV percentage |
| `outstandingBalance` | Money | Current outstanding balance |
| `amount` | integer | Amount |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code |
| `symbol` | string | Currency symbol |
| `currentPropertyValue` | Money | Current property value |
| `amount` | integer | Amount |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code |
| `symbol` | string | Currency symbol |
| `calculatedOn` | date | Date of current LTV calculation |

#### factfind

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for this record |

#### feesAndCharges

| Field | Type | Description |
|-------|------|-------------|
| `lenderFees` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `ongoingContributions` | string | Regular contributions being made |

#### interestTerms

| Field | Type | Description |
|-------|------|-------------|
| `annualPercentageRate` | integer | Current age (calculated from date of birth) |
| `baseRateIndex` | string |  |
| `collarRate` | string |  |
| `hasCollarRate` | boolean |  |
| `initialRatePeriodEndsOn` | date |  |
| `initialTermMonths` | integer |  |
| `initialTermYears` | integer |  |
| `interestRate` | integer |  |
| `rateType` | string |  |
| `remainingTermMonths` | integer |  |
| `remainingTermYears` | integer |  |
| `reversionRate` | integer |  |

#### keyDates

| Field | Type | Description |
|-------|------|-------------|
| `applicationSubmittedDate` | date |  |
| `balanceAsOfDate` | date |  |
| `completionDate` | date |  |
| `endDate` | date | Employment end date (null if current) |
| `exchangeDate` | date |  |
| `nextPaymentDueDate` | date |  |
| `nextReviewDate` | date |  |
| `offerIssuedDate` | date |  |
| `schemeEndDate` | string | Employment end date (null if current) |
| `startDate` | date | Employment start date |
| `targetCompletionDate` | date |  |
| `valuationDate` | date |  |
| `valuationInstructedDate` | date |  |
| `valuationReceivedDate` | date |  |

#### loanAmounts

| Field | Type | Description |
|-------|------|-------------|
| `currentBalance` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `currentPropertyValuation` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `depositAmount` | Money | Amount spent |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `equityReleased` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `loanToValue` | Complex Data | Loan-to-Value at origination |
| `currentLTV` | Complex Data | Current Loan-to-Value |
| `originalLoanAmount` | Money | Amount spent |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `originalPropertyValuation` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |

*Showing all 32 fields*

#### loanTo

| Field | Type | Description |
|-------|------|-------------|
| `percentage` | integer | LTV percentage at origination |
| `propertyValue` | Money | Property value at origination |
| `amount` | integer | Amount |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code |
| `symbol` | string | Currency symbol |
| `loanAmount` | Money | Loan amount at origination |
| `amount` | integer | Amount |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code |
| `symbol` | string | Currency symbol |
| `calculatedOn` | date | Date of LTV calculation |

#### offsetFeatures

| Field | Type | Description |
|-------|------|-------------|
| `offsetLinkedAccountNumber` | string |  |
| `offsetOptions` | List of str |  |

#### property

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for this record |

#### propertyDetail

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for this record |

#### redemptionTerms

| Field | Type | Description |
|-------|------|-------------|
| `earlyRepaymentCharge` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `earlyRepaymentChargeEndsOn` | date |  |
| `earlyRepaymentChargeSecondCharge` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `earlyRepaymentTerms` | string |  |
| `hasEarlyRepaymentCharge` | boolean |  |
| `netProceedsOnRedemption` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |

*Showing all 18 fields*

#### repaymentStructure

| Field | Type | Description |
|-------|------|-------------|
| `capitalRepaymentAmount` | Money | Amount spent |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `capitalTermMonths` | integer |  |
| `capitalTermYears` | integer |  |
| `currentRepaymentVehicles` | List of str |  |
| `interestOnlyAmount` | Money | Amount spent |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `interestOnlyRepaymentVehicle` | string |  |
| `interestOnlyTermMonths` | integer |  |
| `interestOnlyTermYears` | integer |  |
| `lumpSumAdvance` | string |  |
| `monthlyIncomeDrawdown` | string |  |
| `regularAnnualOverpayment` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `repaymentMethod` | string |  |

*Showing all 24 fields*

#### sellingAdviser

| Field | Type | Description |
|-------|------|-------------|
| `firmName` | string |  |
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |

#### sharedOwnershipDetails

| Field | Type | Description |
|-------|------|-------------|
| `sharedEquityLoanAmount` | Money | Amount spent |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `sharedEquityLoanPercentage` | string | Current age (calculated from date of birth) |
| `sharedEquityRepaymentStartsOn` | string |  |
| `sharedEquitySchemeProvider` | string | Unique system identifier for this record |
| `sharedEquitySchemeType` | string |  |
| `sharedOwnershipHousingAssociation` | string | Who owns this arrangement |
| `sharedOwnershipMonthlyRent` | Money | Who owns this arrangement |
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |
| `sharedOwnershipPercentageOwned` | string | Current age (calculated from date of birth) |

*Showing all 16 fields*

#### specialFeatures

| Field | Type | Description |
|-------|------|-------------|
| `consentToLetExpiresOn` | string |  |
| `hasConsentToLet` | boolean |  |
| `hasDebtConsolidation` | boolean | Unique system identifier for this record |
| `hasDischargeOnCompletion` | boolean |  |
| `hasGuarantor` | boolean |  |
| `incomeVerificationStatus` | string | Current status of the goal |
| `isCurrentResidence` | boolean | Unique system identifier for this record |
| `isFirstTimeBuyer` | boolean |  |
| `isIncomeEvidenced` | boolean | Unique system identifier for this record |
| `isPortable` | boolean |  |
| `isPropertySold` | boolean |  |


### Related Resources

*See parent document for relationships to other entities.*

## Data Model