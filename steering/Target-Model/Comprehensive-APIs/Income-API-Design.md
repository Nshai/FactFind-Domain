# Income API Design

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
| **Entity Name** | Income |
| **Domain** | Circumstances |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v3/...` |
| **Resource Type** | Collection |

### Description

Income sources and earnings

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
- `income:read` - Read access (GET operations)
- `income:write` - Create and update access (POST, PUT, PATCH)
- `income:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary






### Income Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `client` | Reference Link |  |  |
| `createdAt` | date |  | When this record was created in the system |
| `description` | string |  | Description of the goal |
| `employment` | Reference Link |  |  |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `frequency` | Selection |  | How often (Monthly, Annual, etc.) |
| `grossAmount` | Money |  | Amount spent |
| `id` | integer | ✓ | Unique system identifier for this record |
| `incomePeriod` | Complex Data |  |  |
| `incomeType` | string |  |  |
| `isTaxable` | boolean |  | Is this income taxable? Some income like Child Benefit or ISA interest may be tax-free. |
| `asset` | Link to Asset |  | Link to the asset (property, investment, business) that generates this income. For example, rental income links to the rental property. |
| `isGuaranteed` | boolean |  |  |
| `isOngoing` | boolean |  |  |
| `isPrimary` | boolean |  | Whether this is the primary/main address |
| `nationalInsuranceDeducted` | Money |  |  |
| `netAmount` | Money |  | Amount spent |
| `notes` | string |  |  |
| `taxDeducted` | Money |  |  |
| `updatedAt` | date |  | When this record was last modified |

*Total: 20 properties*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### Money

Currency amount structure used for all monetary values:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Monetary amount |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code (e.g., GBP, USD, EUR) |
| `symbol` | string | Currency symbol (e.g., £, $, €) |

**Used for:** `grossAmount`, `netAmount`, `nationalInsuranceDeducted`, `taxDeducted`

#### Selection

Enumeration structure with code and display value:

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Machine-readable code value |
| `display` | string | Human-readable display text |

**Used for:** `frequency`

**Frequency Values:**
- `WEEKLY` - Weekly income
- `FORTNIGHTLY` - Fortnightly income
- `FOUR_WEEKLY` - Four-weekly income
- `MONTHLY` - Monthly income
- `QUARTERLY` - Quarterly income
- `HALF_YEARLY` - Half-yearly income
- `ANNUALLY` - Annual income
- `ONE_OFF` - One-off payment

#### Reference Link

Standard reference structure for linked entities:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of the referenced entity |
| `href` | string | API endpoint URL for the referenced entity |

**Used for:** `client`, `employment`, `factfind`, `asset`

#### incomePeriod

Income period details (for incomes that aren't ongoing):

| Field | Type | Description |
|-------|------|-------------|
| `startsOn` | date | Date when income started/will start |
| `endsOn` | date | Date when income ends/will end (if known) |
| `isOngoing` | boolean | Whether income is ongoing (no end date) |

**Income Types by Source:**
- **Employment Income:** Linked to `employment` record (salary, wages, bonus, commission)
- **Rental Income:** Linked to `asset` record (property generating rental income)
- **Investment Income:** Linked to `asset` record (dividends, interest from investments)
- **Pension Income:** From pension arrangements
- **State Benefits:** Child benefit, state pension, disability benefits (typically tax-free)
- **Other Income:** Trust income, maintenance payments, etc.

**Tax Treatment:**
- `isTaxable`: Indicates if income is subject to tax (state benefits often aren't)
- `grossAmount`: Total income before deductions
- `taxDeducted`: Income tax deducted at source (PAYE for employment)
- `nationalInsuranceDeducted`: NI contributions deducted
- `netAmount`: Take-home income after all deductions

**Calculation:** `netAmount = grossAmount - taxDeducted - nationalInsuranceDeducted`

### Related Resources

*See parent document for relationships to other entities.*


## Data Model