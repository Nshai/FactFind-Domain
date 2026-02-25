# Expenditure API Design

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
| **Entity Name** | Expenditure |
| **Domain** | Circumstances |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Expenditure and spending

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
- `expenditure:read` - Read access (GET operations)
- `expenditure:write` - Create and update access (POST, PUT, PATCH)
- `expenditure:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary






### Expenditure Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique identifier for the expenditure |
| `href` | string |  | Link to this expenditure resource |
| `factfind` | Reference Link |  | The fact-find that this expenditure belongs to |
| `client` | Reference Link |  | The client who has this expenditure |
| `description` | string |  | Description of the expenditure |
| `expenditureType` | Selection |  | Type/category of expenditure |
| `netAmount` | Money |  | Amount paid (after tax if applicable) - includes currency code, name, and symbol |
| `frequency` | Selection |  | How often the payment is made |
| `startsOn` | date |  | When the expenditure started |
| `endsOn` | date |  | When the expenditure ends (if known) |
| `isConsolidated` | boolean |  | Is this part of a debt consolidation? |
| `isLiabilityToBeRepaid` | boolean |  | Is this paying off a specific debt? |
| `liability` | Link to Liability |  | The debt/liability being repaid |
| `notes` | string |  | Additional notes |
| `createdAt` | date |  | When this record was created in the system |
| `updatedAt` | date |  | When this record was last modified |

*Total: 16 properties*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### Money

Currency amount structure:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Expenditure amount |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code (e.g., GBP) |
| `symbol` | string | Currency symbol (e.g., £) |

**Used for:** `netAmount`

#### Selection

Enumeration structure with code and display:

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Machine-readable code value |
| `display` | string | Human-readable display text |

**Used for:** `expenditureType`, `frequency`

**Expenditure Type Categories:**
- **HOUSING** - Mortgage, rent, council tax, utilities
- **TRANSPORT** - Car payments, fuel, insurance, public transport
- **FOOD** - Groceries, dining out
- **HOUSEHOLD** - Maintenance, repairs, furnishings
- **PERSONAL** - Clothing, hairdressing, personal care
- **LIFESTYLE** - Entertainment, hobbies, gym, subscriptions
- **INSURANCE** - Life, health, home, car insurance
- **CHILDREN** - Childcare, education, activities
- **DEBT** - Loan repayments, credit card payments
- **SAVINGS** - Regular savings contributions
- **OTHER** - Miscellaneous expenses

**Frequency Values:**
- `WEEKLY` - Weekly expenditure
- `FORTNIGHTLY` - Fortnightly expenditure
- `FOUR_WEEKLY` - Four-weekly expenditure
- `MONTHLY` - Monthly expenditure
- `QUARTERLY` - Quarterly expenditure
- `HALF_YEARLY` - Half-yearly expenditure
- `ANNUALLY` - Annual expenditure
- `ONE_OFF` - One-off payment

#### Reference Link

Standard reference structure:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of referenced entity |
| `href` | string | API endpoint URL for referenced entity |

**Used for:** `factfind`, `client`, `liability`

### Expenditure Categories Explained

**Essential vs. Non-Essential:**

**Essential Expenditures** (required for basic living):
- Mortgage/rent
- Council tax
- Utilities (gas, electric, water)
- Food shopping
- Minimum debt payments
- Basic insurance

**Non-Essential Expenditures** (discretionary spending):
- Entertainment
- Dining out
- Gym memberships
- Subscriptions (Netflix, Spotify, etc.)
- Holidays
- Hobbies

**Why This Matters:**
- Affordability assessments can model scenarios excluding non-essential spending
- Emergency budgeting focuses on essential expenditures only
- Mortgage lending considers sustainability of essential costs

### Debt Consolidation Fields

**`isConsolidated`:** Marks expenditure as part of debt consolidation plan
- Used in affordability modeling
- Helps demonstrate cashflow improvement from consolidation
- Can be excluded from affordability calculations when consolidating

**`isLiabilityToBeRepaid`:** Marks expenditure as being paid off
- Used when replacing current mortgage or paying off loans
- Excluded from affordability calculations for new mortgage
- Links to specific liability record

**`liability`:** Reference to the underlying debt
- Links expenditure (payment) to liability (debt)
- Enables tracking of repayment progress
- Used for debt consolidation and refinancing scenarios

### Frequency Normalization

For affordability calculations, all expenditures are normalized to monthly:

| Frequency | Monthly Multiplier | Example |
|-----------|-------------------|---------|
| Weekly | × 52 ÷ 12 = 4.33 | £100/week = £433/month |
| Fortnightly | × 26 ÷ 12 = 2.17 | £200/fortnight = £434/month |
| Four-weekly | × 13 ÷ 12 = 1.08 | £400/4-weeks = £433/month |
| Monthly | × 1 | £500/month = £500/month |
| Quarterly | ÷ 3 | £300/quarter = £100/month |
| Half-yearly | ÷ 6 | £600/6-months = £100/month |
| Annually | ÷ 12 | £1200/year = £100/month |

### Related Resources

*See parent document for relationships to other entities.*


## Data Model