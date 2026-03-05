# Annuity API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Plans

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | Annuity |
| **Domain** | Plans |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v3/factfinds/{factfindId}/pensions/annuities` |
| **Resource Type** | Collection |

### Description

Comprehensive management of annuity pension arrangements providing guaranteed retirement income for life or a fixed term including purchase amounts, income payments, guarantee periods, spouse benefits, and overlay protections.

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
| GET | `/api/v3/factfinds/{factfindId}/pensions/annuities` | List all annuities | Query params | Annuity[] | 200, 401, 403 | Annuity, List |
| POST | `/api/v3/factfinds/{factfindId}/pensions/annuities` | Create annuity | AnnuityRequest | Annuity | 201, 400, 401, 403, 422 | Annuity, Create |
| GET | `/api/v3/factfinds/{factfindId}/pensions/annuities/{annuityId}` | Get annuity by ID | Path params | Annuity | 200, 401, 403, 404 | Annuity, Retrieve |
| PATCH | `/api/v3/factfinds/{factfindId}/pensions/annuities/{annuityId}` | Update annuity | AnnuityPatch | Annuity | 200, 400, 401, 403, 404, 422 | Annuity, Update |
| DELETE | `/api/v3/factfinds/{factfindId}/pensions/annuities/{annuityId}` | Delete annuity | Path params | None | 204, 401, 403, 404, 422 | Annuity, Delete |


### Authorization

**Required Scopes:**
- `pensions:read` - Read access (GET operations)
- `pensions:write` - Create and update access (POST, PUT, PATCH)
- `pensions:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary

### Annuity Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique identifier for the annuity |
| `href` | string |  | Resource URL for this annuity |
| `factfind` | Reference Link |  | Link to the FactFind that this annuity belongs to |
| `owners` | List of Complex Data |  | Clients who own this annuity |
| `sellingAdviser` | Complex Data |  | Adviser who arranged this annuity |
| `provider` | Complex Data |  | Annuity provider/insurance company |
| `lifeCycle` | Complex Data |  | Annuity lifecycle stage |
| `wrap` | Complex Data |  | Platform/wrap account details |
| `pensionCategory` | Selection |  | Category: Annuity (default) |
| `pensionType` | Complex Data |  | Specific annuity type/plan |
| `policyNumber` | string |  | Policy or annuity contract number |
| `agencyStatus` | Selection |  | Agency servicing status |
| `agencyStatusDate` | date |  | Date of agency status |
| `productName` | string |  | Name of the annuity product |
| `currency` | Complex Data |  | Payment currency |
| `startDate` | date |  | Date annuity payments commenced |
| `annuityType` | Selection |  | Type of annuity (LIFETIME, FIXED_TERM, etc.) |
| `totalPurchaseAmount` | Money |  | Total amount used to purchase annuity |
| `premiumStartDate` | date |  | Date premium payment started |
| `incomeAmount` | Complex Data |  | Annual income payment details |
| `assumedGrowthRate` | Complex Data |  | Annual escalation/growth rate |
| `annuityPaymentType` | Selection |  | Payment timing (Advance or Arrears) |
| `pcls` | Complex Data |  | Pension Commencement Lump Sum details |
| `spouseOrDependantBenefits` | Complex Data |  | Benefits for spouse/dependants |
| `guaranteePeriod` | Complex Data |  | Guaranteed payment period |
| `guaranteedMinimumPensionAnnual` | Money |  | Minimum annual pension guaranteed |
| `overlayBenefits` | Complex Data |  | Additional protection benefits |
| `additionalNotes` | string |  | Additional annuity information |
| `createdAt` | timestamp |  | When this record was created |
| `updatedAt` | timestamp |  | When this record was last modified |

*Total: 30 properties*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### Reference Link

Standard reference structure for linked entities:

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Unique identifier of referenced entity |
| href | string | API endpoint URL for referenced entity |

**Used for:** factfind

#### owners (List of Owner References)

Clients who own this annuity:

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Client unique identifier |
| href | string | API link to client resource (e.g., /api/v3/factfinds/679/clients/8496) |
| name | string | Client full name |

**Note:** Annuities typically have a single owner (the annuitant) or joint annuitants for joint life policies.

#### provider (Annuity Provider Reference)

Annuity provider/insurance company:

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Product provider unique identifier |
| href | string | API link to product provider resource (e.g., /api/v3/productproviders/456) |
| name | string | Provider name (e.g., Aviva, Legal & General) |

**Common Annuity Providers:**
- **Aviva** - Major UK life and pensions provider
- **Legal & General** - Competitive annuity rates
- **Canada Life** - Enhanced annuity specialist
- **Just Retirement** - Impaired life annuities
- **Scottish Widows** - Part of Lloyds Banking Group
- **Standard Life** - Now part of Phoenix Group

#### lifeCycle (Lifecycle Reference)

Annuity lifecycle stage reference:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Lifecycle unique identifier |
| `href` | string | API link to lifecycle resource (e.g., `/api/v3/lifecycles/45`) |
| `name` | string | Lifecycle stage name (e.g., "In Payment") |

**Lifecycle Stages for Annuities:**
- **In Payment** - Annuity currently paying income
- **Pending** - Annuity purchased but payments not yet started
- **Matured** - Fixed term annuity has reached end of term

#### wrap (Platform/Wrap Account Reference)

Platform or wrap account details:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Platform/wrap account identifier |
| `href` | string | API link to investment resource (e.g., `/api/v3/factfinds/679/investments/234`) |
| `reference` | string | Platform account reference number |

**Use Cases:**
- **SIPP Annuity Purchase** - Annuity purchased from Self-Invested Personal Pension platform
- **Platform Tracking** - Link annuity to originating platform account
- **Administrative Reference** - Platform account for ongoing management

#### pensionType (Pension Type Reference)

Specific annuity type/plan details:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Plan type unique identifier |
| `href` | string | API link to plan type resource (e.g., `/api/v3/plantypes?filter=id eq 123`) |
| `name` | string | Pension type name (e.g., "Lifetime Annuity", "Enhanced Annuity") |

**Common Annuity Types:**
- **Lifetime Annuity** - Standard annuity for life
- **Enhanced Annuity** - Higher rates for health/lifestyle conditions
- **Impaired Life Annuity** - Significantly enhanced rates for serious health conditions
- **Investment-Linked Annuity** - Income linked to investment performance
- **With-Profits Annuity** - Income can grow with bonuses
- **Fixed Term Annuity** - Income for specified period only

#### currency (Payment Currency)

Currency used for annuity payments:

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | ISO 4217 currency code (e.g., "GBP", "USD", "EUR") |
| `display` | string | Currency display name (e.g., "British Pound") |
| `symbol` | string | Currency symbol (e.g., "£", "$", "€") |

#### totalPurchaseAmount (Purchase Amount)

Total amount used to purchase the annuity:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Purchase amount |
| `currency` | object | Currency details |
| `currency.code` | string | Currency code |
| `currency.display` | string | Currency display name |
| `currency.symbol` | string | Currency symbol |

**Note:** This is typically 75% of the pension fund (after 25% PCLS taken), but can be 100% if no lump sum taken.

#### incomeAmount (Income Payment Details)

Annual income payment structure:

| Field | Type | Description |
|-------|------|-------------|
| `value` | Money | Income payment amount |
| `value.amount` | decimal | Annual income amount |
| `value.currency` | object | Currency details |
| `frequency` | string | Payment frequency (Monthly, Quarterly, Annually) |
| `effectiveDate` | date | Date income started |

**Payment Frequencies:**
- **Monthly** - Most common for retirement income
- **Quarterly** - Paid four times per year
- **Annually** - Single annual payment

#### assumedGrowthRate (Escalation Rate)

Annual escalation or growth rate for income:

| Field | Type | Description |
|-------|------|-------------|
| `percentage` | decimal | Annual escalation percentage (e.g., 3.00 for 3% per year) |

**Common Escalation Options:**
- **Level** - No escalation (0%)
- **Fixed Escalation** - Fixed percentage (e.g., 3%, 5%)
- **RPI-Linked** - Linked to Retail Price Index
- **CPI-Linked** - Linked to Consumer Price Index
- **LPI** - Limited Price Indexation (e.g., CPI capped at 5%)

#### pcls (Pension Commencement Lump Sum)

Tax-free lump sum taken at annuity purchase:

| Field | Type | Description |
|-------|------|-------------|
| `value` | Money | Lump sum amount |
| `value.amount` | decimal | PCLS amount |
| `value.currency` | object | Currency details |
| `paidBy` | string | Who paid the PCLS |

**PCLS Paid By Values:**
- **Originating Scheme** - PCLS paid from original pension scheme before annuity purchase
- **Receiving Scheme** - PCLS paid by annuity provider as part of annuity purchase
- **Separate Payment** - PCLS taken separately, not from annuity funds

**Rules:**
- Maximum 25% of pension fund value
- Tax-free payment
- Remaining 75% used to purchase annuity income

#### spouseOrDependantBenefits (Spouse/Dependant Benefits)

Benefits payable to spouse or dependants after annuitant's death:

| Field | Type | Description |
|-------|------|-------------|
| `percentage` | decimal | Percentage of main income (e.g., 50.00 for 50%) |
| `amount` | Money | Fixed spouse benefit amount |
| `amount.amount` | decimal | Annual spouse benefit |
| `amount.currency` | object | Currency details |

**Common Spouse Benefit Percentages:**
- **50%** - Half of original income continues to spouse
- **66.67%** - Two-thirds of original income
- **100%** - Full income continues (joint life, 100% continuation)

**Note:** Can be either percentage-based or fixed amount.

#### guaranteePeriod (Guarantee Period)

Guaranteed minimum payment period:

| Field | Type | Description |
|-------|------|-------------|
| `years` | integer | Guarantee period in years |
| `endsOn` | date | Date guarantee period ends |

**Common Guarantee Periods:**
- **5 years** - Most common short guarantee
- **10 years** - Medium-term guarantee
- **15 years** - Longer guarantee period

**Purpose:**
- Payments continue to beneficiaries if annuitant dies within guarantee period
- After guarantee period, payments cease on death (unless joint life or spouse benefit)
- Provides capital protection for early death

#### guaranteedMinimumPensionAnnual (Guaranteed Minimum Pension)

Minimum annual pension guaranteed:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Minimum annual pension |
| `currency` | object | Currency details |
| `currency.code` | string | Currency code |
| `currency.display` | string | Currency display name |
| `currency.symbol` | string | Currency symbol |

**Use Cases:**
- Investment-linked annuities with guaranteed minimum income
- With-profits annuities with minimum income floor
- Protected annuities with guaranteed base rate

#### overlayBenefits (Overlay Protection Benefits)

Additional protection benefits overlaid on the annuity:

| Field | Type | Description |
|-------|------|-------------|
| `hasValueProtection` | boolean | Whether capital value is protected |
| `protectedCapital` | Money | Protected capital amount |
| `protectedCapital.amount` | decimal | Protected amount |
| `protectedCapital.currency` | object | Currency details |
| `hasGuaranteePeriod` | boolean | Whether guarantee period applies |
| `guaranteeInYears` | integer | Guarantee period in years |

**Value Protection:**
- Ensures beneficiaries receive remainder of purchase price if annuitant dies early
- After payments exceed purchase price, no further death benefit
- Provides estate planning certainty

---

## Complete Contract Schema

### Lifetime Annuity Contract Full Definition

```json
{
  "id": 15001,
  "href": "/api/v3/factfinds/679/pensions/annuities/15001",
  "factfind": {
    "id": 679,
    "href": "/api/v3/factfinds/679"
  },
  "owners": [
    {
      "id": 8496,
      "href": "/api/v3/factfinds/679/clients/8496",
      "name": "John Smith",
      "ownershipPercentage": 100.0
    }
  ],
  "sellingAdviser": {
    "id": 123,
    "href": "/api/v3/advisers/123",
    "name": "Jane Financial Adviser"
  },
  "provider": {
    "id": 456,
    "href": "/api/v3/productproviders/456",
    "name": "Aviva"
  },
  "lifeCycle": {
    "id": 45,
    "href": "/api/v3/lifecycles/45",
    "name": "In Payment"
  },
  "wrap": {
    "id": 234,
    "href": "/api/v3/factfinds/679/investments/234",
    "reference": "WRAP-ANN-123456"
  },
  "pensionCategory": "Annuity",
  "pensionType": {
    "id": 123,
    "href": "/api/v3/plantypes?filter=id eq 123",
    "name": "Lifetime Annuity"
  },
  "policyNumber": "ANN-123456789",
  "agencyStatus": "NOT_UNDER_AGENCY",
  "agencyStatusDate": "2023-01-15",
  "productName": "Guaranteed Lifetime Annuity",
  "currency": {
    "code": "GBP"
  },
  "startDate": "2023-01-15",
  "annuityType": "LIFETIME",
  "totalPurchaseAmount": {
    "amount": 250000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "premiumStartDate": "2023-01-15",
  "incomeAmount": {
    "value": {
      "amount": 18500.00,
      "currency": {
        "code": "GBP"
      }
    },
    "frequency": "Monthly",
    "effectiveDate": "2023-01-15"
  },
  "assumedGrowthRate": {
    "percentage": 3.00
  },
  "annuityPaymentType": "Advance",
  "pcls": {
    "value": {
      "amount": 62500.00,
      "currency": {
        "code": "GBP"
      }
    },
    "paidBy": "Originating Scheme"
  },
  "spouseOrDependantBenefits": {
    "percentage": 50.00,
    "amount": {
      "amount": 9250.00,
      "currency": {
        "code": "GBP"
      }
    }
  },
  "guaranteePeriod": {
    "years": 5,
    "endsOn": "2028-01-15"
  },
  "guaranteedMinimumPensionAnnual": {
    "amount": 18500.00,
    "currency": {
      "code": "GBP"
    }
  },
  "overlayBenefits": {
    "hasValueProtection": true,
    "protectedCapital": {
      "amount": 250000.00,
      "currency": {
        "code": "GBP"
      }
    },
    "hasGuaranteePeriod": true,
    "guaranteeInYears": 10
  },
  "additionalNotes": "Protected pension with escalation",
  "createdAt": "2023-01-15T10:00:00Z",
  "updatedAt": "2026-02-25T14:30:00Z"
}
```

### Enhanced Annuity Example

```json
{
  "id": 15002,
  "href": "/api/v3/factfinds/679/pensions/annuities/15002",
  "factfind": {
    "id": 679,
    "href": "/api/v3/factfinds/679"
  },
  "owners": [
    {
      "id": 8496,
      "href": "/api/v3/factfinds/679/clients/8496",
      "name": "John Smith",
      "ownershipPercentage": 100.0
    }
  ],
  "provider": {
    "id": 789,
    "href": "/api/v3/productproviders/789",
    "name": "Just Retirement"
  },
  "lifeCycle": {
    "id": 45,
    "href": "/api/v3/lifecycles/45",
    "name": "In Payment"
  },
  "pensionCategory": "Annuity",
  "pensionType": {
    "id": 125,
    "href": "/api/v3/plantypes?filter=id eq 125",
    "name": "Enhanced Annuity"
  },
  "policyNumber": "ENH-987654321",
  "agencyStatus": "NOT_UNDER_AGENCY",
  "productName": "Enhanced Lifetime Income",
  "currency": {
    "code": "GBP"
  },
  "startDate": "2024-03-01",
  "annuityType": "LIFETIME",
  "totalPurchaseAmount": {
    "amount": 135000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "premiumStartDate": "2024-03-01",
  "incomeAmount": {
    "value": {
      "amount": 10530.00,
      "currency": {
        "code": "GBP"
      }
    },
    "frequency": "Monthly",
    "effectiveDate": "2024-03-01"
  },
  "annuityPaymentType": "Advance",
  "pcls": {
    "value": {
      "amount": 45000.00,
      "currency": {
        "code": "GBP"
      }
    },
    "paidBy": "Originating Scheme"
  },
  "guaranteePeriod": {
    "years": 10,
    "endsOn": "2034-03-01"
  },
  "additionalNotes": "Enhanced rate due to Type 2 diabetes, high blood pressure, and smoking. Rate uplift: 42% above standard. Monthly income: £877 vs £619 standard rate.",
  "createdAt": "2024-03-01T10:00:00Z",
  "updatedAt": "2026-02-25T14:30:00Z"
}
```

### Joint Life Annuity with Escalation Example

```json
{
  "id": 15003,
  "href": "/api/v3/factfinds/679/pensions/annuities/15003",
  "factfind": {
    "id": 679,
    "href": "/api/v3/factfinds/679"
  },
  "owners": [
    {
      "id": 8496,
      "href": "/api/v3/factfinds/679/clients/8496",
      "name": "John Smith",
      "ownershipPercentage": 50.0
    },
    {
      "id": 8497,
      "href": "/api/v3/factfinds/679/clients/8497",
      "name": "Jane Smith",
      "ownershipPercentage": 50.0
    }
  ],
  "provider": {
    "id": 234,
    "href": "/api/v3/productproviders/234",
    "name": "Legal & General"
  },
  "lifeCycle": {
    "id": 45,
    "href": "/api/v3/lifecycles/45",
    "name": "In Payment"
  },
  "pensionCategory": "Annuity",
  "pensionType": {
    "id": 126,
    "href": "/api/v3/plantypes?filter=id eq 126",
    "name": "Joint Life Annuity"
  },
  "policyNumber": "JL-456789123",
  "agencyStatus": "NOT_UNDER_AGENCY",
  "productName": "Joint Life with Escalation",
  "currency": {
    "code": "GBP"
  },
  "startDate": "2021-06-01",
  "annuityType": "JOINT_LIFE",
  "totalPurchaseAmount": {
    "amount": 225000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "premiumStartDate": "2021-06-01",
  "incomeAmount": {
    "value": {
      "amount": 10125.00,
      "currency": {
        "code": "GBP"
      }
    },
    "frequency": "Monthly",
    "effectiveDate": "2021-06-01"
  },
  "assumedGrowthRate": {
    "percentage": 3.00
  },
  "annuityPaymentType": "Advance",
  "pcls": {
    "value": {
      "amount": 75000.00,
      "currency": {
        "code": "GBP"
      }
    },
    "paidBy": "Originating Scheme"
  },
  "spouseOrDependantBenefits": {
    "percentage": 50.00,
    "amount": {
      "amount": 5062.50,
      "currency": {
        "code": "GBP"
      }
    }
  },
  "additionalNotes": "Joint life annuity with 3% annual escalation. After 10 years, income will be £13,605. After 20 years, £18,279. Spouse receives 50% on first death.",
  "createdAt": "2021-06-01T11:00:00Z",
  "updatedAt": "2026-02-25T14:30:00Z"
}
```

---

## Business Validation Rules

### Annuity Type Values

- `LIFETIME` - Annuity payable for life
- `FIXED_TERM` - Annuity payable for fixed period
- `JOINT_LIFE` - Continues on death to spouse
- `LEVEL` - Fixed income amount
- `ESCALATING` - Income increases annually
- `RPI_LINKED` - Linked to Retail Price Index
- `CPI_LINKED` - Linked to Consumer Price Index

### Payment Type Values

- `Advance` - Paid at start of period (monthly, quarterly, annually)
- `Arrears` - Paid at end of period

### PCLS Paid By Values

- `Originating Scheme` - PCLS paid from original pension scheme before annuity purchase
- `Receiving Scheme` - PCLS paid by annuity provider as part of annuity purchase
- `Separate Payment` - PCLS taken separately, not from annuity funds

### Guarantee Period Rules

- Common periods: 5, 10, 15 years
- Payments continue to beneficiaries if annuitant dies within guarantee period
- After guarantee period, payments cease on death (unless joint life)

### Spouse Benefits Rules

- Can be percentage (e.g., 50%, 66.67%, 100%)
- Or fixed amount
- Payable on death of primary annuitant

---

## UK Pension Regulations

### Annuity Purchase Rules

- Can purchase from age 55 (increasing to 57 in 2028)
- Must use open market option (OMO) - can buy from any provider
- 25% tax-free lump sum (PCLS) available at purchase
- Remaining 75% used to purchase annuity income

### Taxation

- Annuity income taxed as earned income at marginal rate
- PCLS is tax-free (up to 25% of fund value)
- No further tax charges after purchase

### Enhanced/Impaired Annuities

- Higher rates for health conditions or lifestyle factors
- Medical evidence may be required
- Significantly higher income for serious conditions

### Annuity Types (Regulatory)

- **Compulsory Purchase Annuity (CPA)** - Purchased with pension fund
- **Purchased Life Annuity (PLA)** - Purchased with personal funds (different tax treatment)
- **Secured Pension** - FCA term for pension annuities
- **Alternatively Secured Pension (ASP)** - Legacy unsecured pensions

### Protections

- **Financial Services Compensation Scheme (FSCS)** - 100% protection for annuities
- **Pension Protection Fund (PPF)** - Not applicable (annuities purchased from insurers)
- **Consumer Duty** - Providers must ensure fair value

---

**Document Version:** 2.0
**Last Updated:** 2026-02-25
**Entity:** Annuity
**Domain:** Plans
