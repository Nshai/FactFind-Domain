# FactFind API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** FactFind Root

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | FactFind |
| **Domain** | FactFind Root |
| **Aggregate Root** | FactFind |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Root FactFind aggregate

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
- `factfind:read` - Read access (GET operations)
- `factfind:write` - Create and update access (POST, PUT, PATCH)
- `factfind:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary




### FactFind Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `additionalNotes` | string |  |  |
| `adviser` | Reference Link |  | The adviser responsible for this client |
| `assetHoldings` | Complex Data |  |  |
| `atrAssessment` | Complex Data |  |  |
| `client` | Reference Link |  |  |
| `completionStatus` | Complex Data |  | Current status of the goal |
| `createdAt` | date |  | When this record was created in the system |
| `customQuestions` | List of Complex Data |  |  |
| `factFindNumber` | string |  |  |
| `financialSummary` | Complex Data |  |  |
| `id` | integer | ✓ | Unique system identifier for this record |
| `investmentCapacity` | Complex Data |  | City/town |
| `jointClientRef` | Reference Link |  |  |
| `meetingDetails` | Complex Data |  |  |
| `notes` | string |  |  |
| `updatedAt` | date |  | When this record was last modified |

*Total: 16 properties*


### Referenced Type Definitions

The following complex types are used in the properties above:

#### adviser

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Standard Occupational Classification (SOC) code |
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |

#### assetHoldings

| Field | Type | Description |
|-------|------|-------------|
| `borrowing` | Complex Data |  |
| `hasEquityRelease` | boolean |  |
| `hasMortgage` | boolean | Current age (calculated from date of birth) |
| `hasOtherLiabilities` | boolean |  |
| `credit` | Complex Data |  |
| `hasAdverseCredit` | boolean |  |
| `hasBeenRefusedCredit` | boolean |  |
| `employment` | Complex Data | Current employment status |
| `hasEmployments` | boolean |  |
| `investments` | Complex Data |  |
| `hasInvestments` | boolean |  |
| `hasSavings` | boolean |  |
| `other` | Complex Data |  |
| `hasOtherAssets` | boolean |  |
| `pensions` | Complex Data |  |
| `hasAnnuity` | boolean |  |
| `hasDefinedBenefitPension` | boolean |  |
| `hasMoneyPurchasePension` | boolean |  |
| `hasPersonalPension` | boolean |  |
| `protection` | Complex Data | GDPR consent, data protection, and privacy management |
| `hasProtection` | boolean |  |

*Showing all 21 fields*

#### atrAssessment

| Field | Type | Description |
|-------|------|-------------|
| `assessmentDate` | date |  |
| `capacityForLoss` | Complex Data | City/town |
| `assessmentNotes` | string |  |
| `canAffordLosses` | boolean |  |
| `emergencyFundMonths` | integer |  |
| `completedAt` | date |  |
| `declarations` | Complex Data |  |
| `adviserDeclaration` | Complex Data |  |
| `adviser` | Complex Data | The adviser responsible for this client |
| `agreed` | boolean |  |
| `agreedAt` | date |  |
| `clientDeclaration` | Complex Data |  |
| `agreed` | boolean |  |
| `agreedAt` | date |  |
| `nextReviewDate` | date |  |
| `questions` | List of Complex Data |  |
| `riskProfiles` | Complex Data |  |
| `chosen` | Complex Data |  |
| `chosenAt` | date |  |
| `chosenBy` | string |  |
| `riskRating` | string |  |
| `riskScore` | integer |  |
| `generated` | List of Complex Data |  |
| `supplementaryQuestions` | List |  |
| `templateRef` | Complex Data |  |
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |
| `version` | string |  |

*Showing all 28 fields*

#### client

| Field | Type | Description |
|-------|------|-------------|
| `clientNumber` | string | Client reference number assigned by your organization |
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |
| `type` | string | Type of client: Person (individual), Corporate (company), or Trust |

#### completionStatus

| Field | Type | Description |
|-------|------|-------------|
| `completionDate` | string |  |
| `compliance` | Complex Data |  |
| `allChecksComplete` | boolean |  |
| `amlCheckedDate` | date |  |
| `idCheckedDate` | date | Unique system identifier for this record |
| `declarationSignedDate` | string |  |
| `isComplete` | boolean |  |
| `status` | string | Current status of the goal |

#### financialSummary

| Field | Type | Description |
|-------|------|-------------|
| `calculatedAt` | date | When these figures were calculated |
| `expenditure` | Complex Data | Type of expenditure (Essential, Discretionary, etc.) |
| `monthlyDisposable` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `monthlyTotal` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `income` | Complex Data | Total gross annual income before tax |
| `annualGross` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `monthlyNet` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `netRelevantEarnings` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `liquidity` | Complex Data | Unique system identifier for this record |
| `availableForAdvice` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `totalFundsAvailable` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `sourceOfFunds` | string |  |
| `taxation` | Complex Data |  |
| `highestRate` | Selection |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `rate` | integer | Company information (only for corporate clients) |

*Showing all 31 fields*

#### investmentCapacity

| Field | Type | Description |
|-------|------|-------------|
| `assessmentDate` | date |  |
| `emergencyFund` | Complex Data |  |
| `committed` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `required` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `shortfall` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `status` | string | Current status of the goal |
| `futureChanges` | Complex Data |  |
| `details` | string |  |
| `expenditureChangesExpected` | boolean |  |
| `incomeChangesExpected` | boolean |  |
| `lumpSumInvestment` | Complex Data |  |
| `agreedAmount` | Money | Amount spent |
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `sourceOfFunds` | string |  |
| `regularContributions` | Complex Data | Regular contributions being made |
| `agreedMonthlyBudget` | Money |  |
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `sustainabilityRating` | string |  |

*Showing all 26 fields*

#### jointClient Reference

| Field | Type | Description |
|-------|------|-------------|
| `clientNumber` | string | Client reference number assigned by your organization |
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |
| `type` | string | Type of client: Person (individual), Corporate (company), or Trust |

#### meetingDetails

| Field | Type | Description |
|-------|------|-------------|
| `clientsPresent` | string |  |
| `meetingDate` | date |  |
| `meetingType` | string |  |
| `othersPresent` | boolean |  |
| `othersPresentDetails` | string |  |
| `scopeOfAdvice` | Complex Data |  |
| `estatePlanning` | boolean | Will, power of attorney, gifts, trusts, and inheritance tax planning |
| `mortgage` | boolean | Current age (calculated from date of birth) |
| `protection` | boolean | GDPR consent, data protection, and privacy management |
| `retirementPlanning` | boolean |  |


### Related Resources

*See parent document for relationships to other entities.*

## Data Model