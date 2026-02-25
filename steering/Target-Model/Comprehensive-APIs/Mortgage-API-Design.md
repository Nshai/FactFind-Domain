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

#### feesAndCharges

Mortgage fees and ongoing charges:

| Field | Type | Description |
|-------|------|-------------|
| `lenderFees` | Money | Fees charged by lender (arrangement fee, booking fee, etc.) |
| `ongoingContributions` | string | Regular ongoing charges description |

#### interestTerms

Interest rate and term details:

| Field | Type | Description |
|-------|------|-------------|
| `annualPercentageRate` | decimal | APR (%) - total cost including fees |
| `baseRateIndex` | string | Base rate index (SONIA, Bank of England Base Rate) |
| `collarRate` | string | Collar rate (minimum rate for variable mortgages) |
| `hasCollarRate` | boolean | Whether a collar rate applies |
| `initialRatePeriodEndsOn` | date | Date when initial rate period ends |
| `initialTermMonths` | integer | Initial term in months |
| `initialTermYears` | integer | Initial term in years |
| `interestRate` | decimal | Current interest rate (%) |
| `rateType` | string | Rate type: Fixed, Variable, Tracker, Discount, Capped |
| `remainingTermMonths` | integer | Remaining term in months |
| `remainingTermYears` | integer | Remaining term in years |

**Rate Types:**
- **Fixed** - Rate fixed for initial period (e.g., 2, 5, 10 years)
- **Variable** - Lender's standard variable rate (SVR)
- **Tracker** - Tracks base rate plus margin (e.g., SONIA + 2%)
- **Discount** - Discount off SVR for initial period
- **Capped** - Variable but with maximum rate cap

#### keyDates

Important mortgage dates:

| Field | Type | Description |
|-------|------|-------------|
| `applicationDate` | date | Date mortgage application submitted |
| `offerDate` | date | Date mortgage offer issued |
| `completionDate` | date | Date mortgage completed/drew down |
| `firstPaymentDate` | date | Date of first payment |
| `maturityDate` | date | Date mortgage matures/final payment due |
| `initialRateEndsOn` | date | Date when initial rate period ends |
| `nextReviewDate` | date | Date for next review/rebroking opportunity |

#### loanAmounts

Loan amount details:

| Field | Type | Description |
|-------|------|-------------|
| `originalLoanAmount` | Money | Original loan amount at inception |
| `currentBalance` | Money | Current outstanding balance |
| `advancedAmount` | Money | Amount actually advanced |
| `additionalBorrowing` | Money | Additional borrowing amount |
| `originalLTV` | decimal | Original Loan-to-Value ratio (%) |
| `currentLTV` | decimal | Current Loan-to-Value ratio (%) |

**LTV Calculation:** `LTV = (Outstanding Balance / Property Value) × 100%`

#### repaymentStructure

Repayment method and amounts:

| Field | Type | Description |
|-------|------|-------------|
| `repaymentType` | string | Repayment type: Repayment, Interest-Only, Part-and-Part |
| `monthlyPayment` | Money | Total monthly payment |
| `principalPayment` | Money | Monthly principal repayment portion |
| `interestPayment` | Money | Monthly interest payment portion |
| `overpaymentsMade` | Money | Total overpayments made to date |
| `overpaymentAllowance` | decimal | Annual overpayment allowance (% or amount) |

**Repayment Types:**
- **Repayment** - Capital and interest paid each month
- **Interest-Only** - Interest only paid; capital due at end
- **Part-and-Part** - Combination of repayment and interest-only

#### redemptionTerms

Early repayment and exit terms:

| Field | Type | Description |
|-------|------|-------------|
| `earlyRepaymentCharge` | Money | Current ERC amount |
| `ercAppliesUntil` | date | Date until which ERC applies |
| `ercPercentage` | decimal | ERC as percentage of balance |
| `overpaymentLimit` | decimal | Overpayment limit without penalty (%) |
| `portabilityAvailable` | boolean | Whether mortgage can be ported to new property |

**ERC:** Early Repayment Charge - penalty for paying off mortgage early

#### offsetFeatures

Offset mortgage features (if applicable):

| Field | Type | Description |
|-------|------|-------------|
| `hasOffsetFeature` | boolean | Whether this is an offset mortgage |
| `linkedSavingsAccounts` | List | List of linked savings accounts |
| `currentOffsetBalance` | Money | Current balance in offset accounts |
| `interestSaved` | Money | Interest saved through offset |

**Offset Mortgage:** Savings balances offset against mortgage, reducing interest charged

#### sharedOwnershipDetails

Shared ownership mortgage details:

| Field | Type | Description |
|-------|------|-------------|
| `isSharedOwnership` | boolean | Whether this is shared ownership |
| `equityShare` | decimal | Percentage of property owned (%) |
| `rentOnUnownedShare` | Money | Monthly rent paid on unowned share |
| `staircasingOptions` | string | Options to buy additional equity |

**Shared Ownership:** Part-buy, part-rent scheme (typically housing association)

#### specialFeatures

Special mortgage features:

| Field | Type | Description |
|-------|------|-------------|
| `hasPaymentHoliday` | boolean | Payment holiday feature available |
| `hasUnderpaymentOption` | boolean | Option to temporarily underpay |
| `hasBorrowBack` | boolean | Option to borrow back overpayments |
| `cashbackAmount` | Money | Cashback received |
| `freeValuation` | boolean | Free valuation included |
| `freeLegalFees` | boolean | Free legal fees included |

#### owners

Mortgage ownership details:

| Field | Type | Description |
|-------|------|-------------|
| `client` | Reference Link | Link to client owner |
| `ownershipType` | string | Ownership type: Sole, Joint, Joint Tenants, Tenants in Common |
| `percentage` | decimal | Ownership percentage (for Tenants in Common) |

#### linkedArrangements

Other arrangements linked to this mortgage:

| Field | Type | Description |
|-------|------|-------------|
| `arrangementType` | string | Type: Life Assurance, Buildings Insurance, Contents Insurance |
| `arrangementId` | integer | Linked arrangement ID |
| `policyNumber` | string | Policy number |
| `provider` | string | Provider name |

**Common Linked Arrangements:**
- **Life Assurance** - Life cover to repay mortgage on death
- **Buildings Insurance** - Required by lender
- **Payment Protection Insurance** - Optional income protection

#### Reference Link

Standard reference structure:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of referenced entity |
| `href` | string | API endpoint URL for referenced entity |

**Used for:** `asset`, `factfind`, `property`, `propertyDetail`, `sellingAdviser`

#### Money

Currency amount structure:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Monetary amount |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code (e.g., GBP) |
| `symbol` | string | Currency symbol (e.g., £) |

### Mortgage Types and Purposes

**By Property Type:**
- **Residential** - Main residence or second home
- **Buy-to-Let** - Rental investment property
- **Commercial** - Business premises
- **Right to Buy** - Council property purchase
- **Shared Ownership** - Part-buy, part-rent

**By Purpose:**
- **Purchase** - Buying a property
- **Remortgage** - Switching to new lender
- **Further Advance** - Additional borrowing on existing mortgage
- **Product Transfer** - Switching product with same lender
- **Equity Release** - Lifetime/retirement mortgage

### Regulatory Requirements

This entity supports compliance with:
- **MCOB (Mortgage Conduct of Business)** - FCA mortgage regulations
- **Mortgage Credit Directive** - EU consumer protection
- **Responsible Lending** - Affordability assessments required

### Related Resources

*See parent document for relationships to other entities.*


## Data Model