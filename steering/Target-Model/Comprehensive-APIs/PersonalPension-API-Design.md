# Personal Pension API Design

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
| **Entity Name** | PersonalPension |
| **Domain** | Plans |
| **Aggregate Root** | Client |
| **Base Path** | /api/v3/factfinds/{factfindId}/pensions/personalpension |
| **Resource Type** | Collection |

### Description

Comprehensive management of personal pension arrangements including contribution-based DC pensions, drawdown, and SIPPs with detailed fund holdings, crystallisation tracking, GAD compliance, and retirement options.

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
| GET | /api/v3/factfinds/{factfindId}/pensions/personalpension | List all personal pensions | Query params | PersonalPension[] | 200, 401, 403 | PersonalPension, List |
| POST | /api/v3/factfinds/{factfindId}/pensions/personalpension | Create personal pension | PersonalPensionRequest | PersonalPension | 201, 400, 401, 403, 422 | PersonalPension, Create |
| GET | /api/v3/factfinds/{factfindId}/pensions/personalpension/{pensionId} | Get pension by ID | Path params | PersonalPension | 200, 401, 403, 404 | PersonalPension, Retrieve |
| PATCH | /api/v3/factfinds/{factfindId}/pensions/personalpension/{pensionId} | Update pension | PersonalPensionPatch | PersonalPension | 200, 400, 401, 403, 404, 422 | PersonalPension, Update |
| DELETE | /api/v3/factfinds/{factfindId}/pensions/personalpension/{pensionId} | Delete pension | Path params | None | 204, 401, 403, 404, 422 | PersonalPension, Delete |


### Authorization

**Required Scopes:**
- pensions:read - Read access (GET operations)
- pensions:write - Create and update access (POST, PUT, PATCH)
- pensions:delete - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary

### Personal Pension Resource Properties (50 properties total)

Key properties include:
- Core: id, href, factfind, owners, sellingAdviser, provider, lifeCycle, wrap
- Pension details: pensionCategory, pensionType, policyNumber, productName, currency
- Dates: startedOn, agencyStatusDate, gadCalculatedOn, nextReviewOn
- Valuation: valuation (currentValue, valuedOn)
- Status: crystallisationStatus, pensionArrangement, agencyStatus
- Benefits: pcls, enhancedTaxFreeCash, gmpAmount, deathBenefits, deathInService
- Limits: gadMaximumIncomeLimitAnnual, guaranteedMinimumIncomeLimitAnnual
- Features: guaranteedAnnuityRate, guaranteedGrowthRates, erfLoyaltyBonusTerminalBonus
- Planning: retirementAge, lifetimeAllowanceUsed, hasLifestylingStrategy
- Details: employer, optionsAtRetirement, applicablePenalties
- Flags: isInTrust, isIndexed, isPreserved
- Collections: contributions (list), fundHoldings (complex)
- Notes: lifestylingStrategyDetails, otherBenefitsOrMaterialFeatures, additionalNotes
- Audit: createdAt, updatedAt

### Referenced Type Definitions

The following complex types are used in the properties above:

#### Reference Link

Standard reference structure for linked entities:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of referenced entity |
| `href` | string | API endpoint URL for referenced entity |

**Used for:** `factfind`

#### owners (List of Owner References)

Clients who own this pension:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Client unique identifier |
| `href` | string | API link to client resource (e.g., `/api/v3/factfinds/679/clients/8496`) |
| `name` | string | Client full name |
| `ownershipPercentage` | decimal | Ownership percentage (typically 100.0 for personal pensions) |

#### sellingAdviser (Selling Adviser Reference)

Adviser who arranged this pension:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Adviser unique identifier |
| `href` | string | API link to adviser resource (e.g., `/api/v3/advisers/123`) |
| `name` | string | Adviser full name |

#### provider (Pension Provider Reference)

Pension provider/company:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Product provider unique identifier |
| `href` | string | API link to product provider resource (e.g., `/api/v3/productproviders/456`) |
| `name` | string | Provider name |

**Common Personal Pension Providers:**
- **Vanguard** - Low-cost index fund pensions
- **AJ Bell** - SIPP platform
- **Hargreaves Lansdown** - SIPP and personal pension platform
- **Aviva** - Personal pensions and SIPPs
- **Standard Life** - Workplace and personal pensions
- **Legal & General** - Personal pensions
- **Fidelity** - SIPP platform
- **Interactive Investor** - SIPP platform
- **Aegon** - Personal and workplace pensions

#### lifeCycle (Lifecycle Reference)

Pension lifecycle stage reference:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Lifecycle unique identifier |
| `href` | string | API link to lifecycle resource (e.g., `/api/v3/lifecycles/45`) |
| `name` | string | Lifecycle stage name |

**Lifecycle Stages:**
- **Accumulation** - Building pension fund with contributions
- **Consolidation** - Preserving pension, no longer contributing
- **Decumulation** - Drawing income from pension
- **Transfer** - In process of transferring

#### wrap (Platform/Wrap Account Reference)

Platform or wrap account details:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Platform/wrap account identifier |
| `href` | string | API link to investment resource (e.g., `/api/v3/factfinds/679/investments/234`) |
| `reference` | string | Platform account reference number |

#### pensionType (Pension Type Reference)

Specific pension type/plan details:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Plan type unique identifier |
| `href` | string | API link to plan type resource (e.g., `/api/v3/plantypes?filter=id eq 123`) |
| `name` | string | Pension type name |

**Common Pension Types:**
- **Personal Pension** - Individual pension plan
- **SIPP** - Self-Invested Personal Pension (wider investment choice)
- **Stakeholder Pension** - Low-cost personal pension
- **Group Personal Pension** - Employer-facilitated personal pension
- **Executive Pension Plan** - High-contribution personal pension

#### currency (Pension Currency)

Currency used for pension:

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | ISO 4217 currency code (e.g., "GBP", "USD", "EUR") |
| `display` | string | Currency display name (e.g., "British Pound") |
| `symbol` | string | Currency symbol (e.g., "£", "$", "€") |

#### valuation (Current Valuation Details)

Current pension value:

| Field | Type | Description |
|-------|------|-------------|
| `currentValue` | Money | Current pension value |
| `currentValue.amount` | decimal | Value amount |
| `currentValue.currency` | object | Currency details |
| `valuedOn` | date | Date of valuation |

#### pcls (Pension Commencement Lump Sum)

Tax-free lump sum details:

| Field | Type | Description |
|-------|------|-------------|
| `value` | Money | PCLS amount |
| `value.amount` | decimal | Lump sum amount |
| `value.currency` | object | Currency details |
| `paidBy` | string | Who paid the PCLS (Originating Scheme, Receiving Scheme) |

**PCLS Rules:**
- **Standard Entitlement** - 25% of fund value tax-free
- **Enhanced Entitlement** - Some pensions have protected rights for higher percentage (up to 30-35%)
- **Maximum** - Subject to Lump Sum Allowance (LSA) and Lump Sum and Death Benefit Allowance (LSDBA) from April 2024

#### gadMaximumIncomeLimitAnnual (GAD Maximum Income Limit)

Government Actuary's Department maximum income limit for capped drawdown:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Maximum annual income under GAD |
| `currency` | object | Currency details |

**GAD Rates:**
- Apply to legacy capped drawdown pensions (pre-2015)
- Based on age, fund value, and gilt yields
- Reviewed every 3 years or on significant fund value changes
- Most pensions now flexi-access drawdown (no GAD limit)

#### guaranteedMinimumIncomeLimitAnnual (Guaranteed Minimum Income Limit)

Guaranteed minimum income limit:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Minimum annual income guaranteed |
| `currency` | object | Currency details |

#### gmpAmount (Guaranteed Minimum Pension)

Guaranteed Minimum Pension from contracting-out:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | GMP amount |
| `currency` | object | Currency details |

#### enhancedTaxFreeCash (Enhanced Tax-Free Cash Entitlement)

Protected enhanced tax-free cash entitlement (pre-A-Day rights):

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Enhanced PCLS amount |
| `currency` | object | Currency details |

**Enhanced Rights:**
- **A-Day Protection** - Rights acquired before 6 April 2006
- **Primary Protection** - For those with funds over £1.5m at A-Day
- **Enhanced Protection** - For those who stopped contributions at A-Day

#### deathInService (Death in Service Benefits)

Death benefits payable if death occurs while employed:

| Field | Type | Description |
|-------|------|-------------|
| `spousalBenefits` | decimal | Percentage of fund payable to spouse |

**Typical Provisions:**
- **Full Fund Value** - Usually entire pension fund payable
- **Tax Treatment** - Tax-free if death before age 75, taxable if after
- **Nomination** - Member can nominate beneficiaries
- **Discretionary** - Trustees/provider have discretion on distribution

#### deathBenefits (Death Benefits)

Death benefits payable:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Death benefit amount |
| `currency` | object | Currency details |

#### contributions (Pension Contributions)

List of contribution arrangements:

| Field | Type | Description |
|-------|------|-------------|
| `value` | Money | Contribution amount |
| `value.amount` | decimal | Contribution amount |
| `value.currency` | object | Currency details |
| `frequency` | string | Payment frequency (Monthly, Annual, etc.) |
| `contributor` | string | Who makes contribution (Self, Employer, Both) |
| `startedOn` | date | Contribution start date |
| `endsOn` | date | Contribution end date (null if ongoing) |
| `contributionType` | string | Type of contribution |
| `transfer` | object | Transfer details (when contributionType = Transfer) |

**Contribution Types:**
- **Regular** - Ongoing regular contributions
- **Lumpsum** - One-off lump sum contribution
- **Transfer** - Transfer from another pension

**Contributor Values:**
- **Self** - Member's own contributions
- **Employer** - Employer contributions
- **Both** - Both member and employer contributing

**Transfer Object:**

| Field | Type | Description |
|-------|------|-------------|
| `isFullTransfer` | boolean | Whether full transfer of ceeding plan |
| `transferType` | string | Cash or Inspecie |
| `ceedingPlan` | object | Plan being transferred from |
| `ceedingPlan.id` | integer | Ceeding plan identifier |
| `ceedingPlan.href` | string | Link to ceeding plan |
| `ceedingPlan.reference` | string | Ceeding plan reference |

#### fundHoldings (Fund Holdings and Allocations)

Detailed fund holdings:

| Field | Type | Description |
|-------|------|-------------|
| `model` | object | Model portfolio details |
| `model.code` | string | Model portfolio code |
| `model.name` | string | Model portfolio name |
| `funds` | array | Individual fund holdings |

**Fund Object:**

| Field | Type | Description |
|-------|------|-------------|
| `type` | string | Fund type (Fund, Equity, Bond, Cash, Property, Alternative) |
| `isFeed` | boolean | Whether feeder fund |
| `name` | string | Fund name |
| `codes` | array | Fund identification codes |
| `holding` | object | Holding details |
| `holding.units` | decimal | Number of units held |
| `holding.percentage` | decimal | Percentage of portfolio |

**Code Object:**

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Code type (ISIN, SEDOL, Platform, CITI, Bloomberg) |
| `value` | string | Code value |

---

## Complete Contract Schema

### Active Personal Pension with Regular Contributions

```json
{
  "id": 15001,
  "href": "/api/v3/factfinds/679/pensions/personalpension/15001",
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
    "name": "Vanguard"
  },
  "lifeCycle": {
    "id": 45,
    "href": "/api/v3/lifecycles/45",
    "name": "Accumulation"
  },
  "wrap": {
    "id": 234,
    "href": "/api/v3/factfinds/679/investments/234",
    "reference": "WRAP-PP-123456"
  },
  "pensionCategory": "PensionContributionDrawdown",
  "pensionType": {
    "id": 123,
    "href": "/api/v3/plantypes?filter=id eq 123",
    "name": "Personal Pension"
  },
  "policyNumber": "PP-123456789",
  "agencyStatus": "NOT_UNDER_AGENCY",
  "agencyStatusDate": "2023-01-15",
  "productName": "Vanguard Personal Pension",
  "currency": {
    "code": "GBP"
  },
  "startedOn": "2018-03-15",
  "employer": "ABC Corporation Ltd",
  "retirementAge": 65,
  "valuation": {
    "currentValue": {
      "amount": 185000.00,
      "currency": {
        "code": "GBP"
      }
    },
    "valuedOn": "2026-02-18"
  },
  "pensionArrangement": "Physical",
  "crystallisationStatus": "Uncrystallised",
  "pcls": {
    "value": {
      "amount": 46250.00,
      "currency": {
        "code": "GBP"
      }
    },
    "paidBy": "Receiving Scheme"
  },
  "nextReviewOn": "2027-03-15",
  "isInTrust": true,
  "hasLifestylingStrategy": true,
  "lifestylingStrategyDetails": "Automatic switch from equity funds to bonds and cash starting at age 60",
  "optionsAtRetirement": "Full drawdown, phased drawdown, annuity purchase, or UFPLS available",
  "otherBenefitsOrMaterialFeatures": "Access to discounted fund platform with 0.2% p.a. rebate",
  "isIndexed": false,
  "isPreserved": false,
  "contributions": [
    {
      "value": {
        "amount": 800.00,
        "currency": {
          "code": "GBP"
        }
      },
      "frequency": "Monthly",
      "contributor": "Self",
      "startedOn": "2018-03-15",
      "endsOn": null,
      "contributionType": "Regular"
    },
    {
      "value": {
        "amount": 500.00,
        "currency": {
          "code": "GBP"
        }
      },
      "frequency": "Monthly",
      "contributor": "Employer",
      "startedOn": "2018-03-15",
      "endsOn": null,
      "contributionType": "Regular"
    }
  ],
  "fundHoldings": {
    "model": {
      "code": "BALANCED-60-40",
      "name": "Balanced Growth 60/40"
    },
    "funds": [
      {
        "type": "Fund",
        "isFeed": false,
        "name": "Vanguard FTSE Global All Cap Index Fund",
        "codes": [
          {
            "code": "ISIN",
            "value": "GB00BD3RZ582"
          },
          {
            "code": "SEDOL",
            "value": "BD3RZ58"
          }
        ],
        "holding": {
          "units": 2500.50,
          "percentage": 60.0
        }
      },
      {
        "type": "Bond",
        "isFeed": false,
        "name": "Vanguard U.K. Investment Grade Bond Index Fund",
        "codes": [
          {
            "code": "ISIN",
            "value": "GB00B41YBW71"
          }
        ],
        "holding": {
          "units": 1800.25,
          "percentage": 35.0
        }
      },
      {
        "type": "Cash",
        "isFeed": false,
        "name": "Vanguard Cash Reserve Fund",
        "codes": [
          {
            "code": "ISIN",
            "value": "GB00B3X7QG63"
          }
        ],
        "holding": {
          "units": 500.00,
          "percentage": 5.0
        }
      }
    ]
  },
  "additionalNotes": "Workplace pension with 5% employer contribution, lifestyling active from age 60",
  "createdAt": "2018-03-15T10:00:00Z",
  "updatedAt": "2026-02-25T14:30:00Z"
}
```

### Part-Crystallised SIPP with Drawdown

```json
{
  "id": 15002,
  "href": "/api/v3/factfinds/679/pensions/personalpension/15002",
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
    "name": "AJ Bell"
  },
  "lifeCycle": {
    "id": 47,
    "href": "/api/v3/lifecycles/47",
    "name": "Decumulation"
  },
  "pensionCategory": "PensionContributionDrawdown",
  "pensionType": {
    "id": 125,
    "href": "/api/v3/plantypes?filter=id eq 125",
    "name": "SIPP"
  },
  "policyNumber": "SIPP-987654321",
  "agencyStatus": "NOT_UNDER_AGENCY",
  "productName": "AJ Bell Investcentre SIPP",
  "currency": {
    "code": "GBP"
  },
  "startedOn": "2010-06-01",
  "retirementAge": 67,
  "valuation": {
    "currentValue": {
      "amount": 450000.00,
      "currency": {
        "code": "GBP"
      }
    },
    "valuedOn": "2026-02-18"
  },
  "pensionArrangement": "Physical",
  "crystallisationStatus": "PartCrystallised",
  "pcls": {
    "value": {
      "amount": 75000.00,
      "currency": {
        "code": "GBP"
      }
    },
    "paidBy": "Receiving Scheme"
  },
  "enhancedTaxFreeCash": {
    "amount": 90000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "guaranteedAnnuityRate": "5.2% at age 65 for single life level annuity with 5-year guarantee",
  "deathBenefits": {
    "amount": 450000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "lifetimeAllowanceUsed": 52.5,
  "nextReviewOn": "2027-06-01",
  "isInTrust": false,
  "hasLifestylingStrategy": false,
  "optionsAtRetirement": "Currently in flexi-access drawdown, taking £18,000 per annum",
  "otherBenefitsOrMaterialFeatures": "Protected enhanced tax-free cash entitlement (30% instead of 25%). Guaranteed annuity rate available.",
  "isIndexed": false,
  "isPreserved": false,
  "contributions": [
    {
      "value": {
        "amount": 125000.00,
        "currency": {
          "code": "GBP"
        }
      },
      "frequency": "One-off",
      "contributor": "Self",
      "startedOn": "2015-04-15",
      "endsOn": "2015-04-15",
      "contributionType": "Transfer",
      "transfer": {
        "isFullTransfer": true,
        "transferType": "Cash",
        "ceedingPlan": {
          "id": 14001,
          "href": "/api/v3/factfinds/679/pensions/personalpension/14001",
          "reference": "OLD-PP-555666"
        }
      }
    }
  ],
  "fundHoldings": {
    "funds": [
      {
        "type": "Equity",
        "isFeed": false,
        "name": "Fundsmith Equity Fund",
        "codes": [
          {
            "code": "ISIN",
            "value": "GB00B41YBW71"
          }
        ],
        "holding": {
          "units": 15000.00,
          "percentage": 45.0
        }
      },
      {
        "type": "Fund",
        "isFeed": false,
        "name": "Vanguard LifeStrategy 60% Equity",
        "codes": [
          {
            "code": "ISIN",
            "value": "GB00B4PQW151"
          }
        ],
        "holding": {
          "units": 10000.00,
          "percentage": 35.0
        }
      },
      {
        "type": "Bond",
        "isFeed": false,
        "name": "Royal London Short Term Money Market",
        "codes": [
          {
            "code": "ISIN",
            "value": "GB00B8FZTW67"
          }
        ],
        "holding": {
          "units": 8000.00,
          "percentage": 20.0
        }
      }
    ]
  },
  "additionalNotes": "Part-crystallised SIPP with protected enhanced PCLS rights from A-Day. Taking £18,000 annual drawdown. Guaranteed annuity rate available but not currently utilized.",
  "createdAt": "2010-06-01T11:00:00Z",
  "updatedAt": "2026-02-25T14:30:00Z"
}
```

---

## Business Validation Rules

### Pension Category

- `PensionContributionDrawdown` - Personal pensions, SIPPs, drawdown arrangements (default)

### Pension Arrangement

- `Notional` - Notional allocation within group scheme
- `Physical` - Actual segregated pension fund

### Crystallisation Status

- `Crystallised` - Entire pension accessed/drawn down
- `PartCrystallised` - Some funds accessed, some uncrystallised
- `Uncrystallised` - No benefits taken yet

### Contribution Type

- `Regular` - Ongoing regular contributions
- `Lumpsum` - One-off lump sum contribution
- `Transfer` - Transfer from another pension

### Contributor

- `Self` - Member's own contributions
- `Employer` - Employer contributions
- `Both` - Both member and employer contributing

### Transfer Type

- `Cash` - Cash transfer (liquidate and transfer proceeds)
- `Inspecie` - In-specie transfer (transfer actual holdings)

### Fund Type

- `Fund` - Unit trust or OEIC
- `Equity` - Individual stock
- `Bond` - Fixed income security
- `Cash` - Money market fund
- `Property` - Real estate investment
- `Alternative` - Alternative investments

### Validation Rules

- `fundHoldings.funds.holding.percentage` values must sum to 100% across all funds
- When `contributions.contributionType = Transfer`, `transfer` object is required
- At least one fund code must be provided for each fund
- `lifetimeAllowanceUsed` should be between 0 and 100 (percentage)

---

## UK Pension Regulations

### Pension Freedoms (2015)

- **Access Age** - Minimum pension age 55 (rising to 57 in 2028)
- **PCLS** - 25% tax-free lump sum (up to Lump Sum Allowance)
- **Flexi-Access Drawdown** - No income limits, take as much or little as needed
- **UFPLS** - Uncrystallised Funds Pension Lump Sum (take ad-hoc lump sums)

### Annual Allowance

- **Standard Annual Allowance** - £60,000 (2024/25 tax year)
- **Tapered Annual Allowance** - Reduces for high earners (income over £260,000)
- **Minimum Tapered Allowance** - £10,000
- **MPAA** - Money Purchase Annual Allowance £10,000 (applies after accessing pension flexibly)
- **Carry Forward** - Unused allowance from previous 3 years can be carried forward

### Lifetime Allowance (Abolished April 2024)

- **Abolished** - Lifetime Allowance charge removed from 6 April 2024
- **Replaced By** - Lump Sum Allowance (LSA) and Lump Sum and Death Benefit Allowance (LSDBA)
- **LSA** - £268,275 (maximum tax-free cash across all pensions)
- **LSDBA** - £1,073,100 (maximum for lump sum death benefits)
- **Protections** - Various protections remain for those who had them (Primary, Enhanced, Fixed)

### GAD Rates

- **Legacy Capped Drawdown** - Apply to pre-2015 capped drawdown pensions
- **Based On** - Age, fund value, and gilt yields
- **Maximum Income** - 120% or 150% of GAD rate depending on age
- **Review Frequency** - Every 3 years or on significant fund value change
- **Most Pensions** - Now flexi-access drawdown (no GAD limit)

### Death Benefits

- **Death Before Age 75** - Pension fund passes tax-free to beneficiaries
- **Death After Age 75** - Beneficiaries pay income tax at their marginal rate
- **Lump Sum Death Benefits** - Subject to LSDBA from April 2024
- **Nomination** - Member can nominate beneficiaries (but usually discretionary)
- **Trust Arrangements** - Pension can be held in trust for estate planning

### Protected Rights

- **A-Day (6 April 2006)** - Pension simplification day
- **Enhanced PCLS** - Some members have protected rights to higher tax-free cash (up to 30-35%)
- **Primary Protection** - For those with funds over £1.5m at A-Day
- **Enhanced Protection** - For those who stopped contributions at A-Day
- **Guaranteed Annuity Rates** - Many older pensions have valuable GAR clauses

---

**Document Version:** 2.0
**Last Updated:** 2026-02-25
**Entity:** PersonalPension
**Domain:** Plans
