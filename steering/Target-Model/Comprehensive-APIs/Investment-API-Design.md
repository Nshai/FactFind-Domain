# Investment API Design

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
| **Entity Name** | Investment |
| **Domain** | Plans |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/factfinds/{factfindId}/investments` |
| **Resource Type** | Collection |

### Description

Comprehensive investment management including investment accounts, life-assured investments, cash bank accounts, and investment bonds with flexible contribution tracking and fund holdings management.

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
| GET | `/api/v2/factfinds/{factfindId}/investments` | List all investments | Query params | Investment[] | 200, 401, 403 | Investment, List |
| POST | `/api/v2/factfinds/{factfindId}/investments` | Create investment | InvestmentRequest | Investment | 201, 400, 401, 403, 422 | Investment, Create |
| GET | `/api/v2/factfinds/{factfindId}/investments/{investmentId}` | Get investment by ID | Path params | Investment | 200, 401, 403, 404 | Investment, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/investments/{investmentId}` | Update investment | InvestmentPatch | Investment | 200, 400, 401, 403, 404, 422 | Investment, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/investments/{investmentId}` | Delete investment | Path params | None | 204, 401, 403, 404, 422 | Investment, Delete |


### Authorization

**Required Scopes:**
- `investments:read` - Read access (GET operations)
- `investments:write` - Create and update access (POST, PUT, PATCH)
- `investments:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary

### Investment Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| \`id\` | integer | ✓ | Unique identifier for the investment |
| \`href\` | string |  | Resource URL for this investment |
| \`factfind\` | Reference Link |  | Link to the FactFind that this investment belongs to |
| \`owners\` | List of Complex Data |  | Clients who own this investment |
| \`sellingAdviser\` | Complex Data |  | Adviser who arranged this investment |
| \`provider\` | Complex Data |  | Product provider/company |
| \`lifeCycle\` | Complex Data |  | Investment lifecycle stage |
| \`investmentCategory\` | Selection |  | Category: CashBankAccount, Investment, lifeAssuredInvestment |
| \`investmentType\` | Complex Data |  | Specific investment type/plan |
| \`policyNumber\` | string |  | Policy or account number |
| \`agencyStatus\` | Selection |  | Agency servicing status |
| \`productName\` | string |  | Name of the investment product |
| \`startedOn\` | date |  | Investment start date |
| \`endsOn\` | date |  | Investment end/maturity date |
| \`wrap\` | Complex Data |  | Platform/wrap account details |
| \`valuation\` | Complex Data |  | Current valuation details |
| \`cashAccount\` | Complex Data |  | Cash account specific details (CashBankAccount only) |
| \`maturityDetails\` | Complex Data |  | Maturity projection details (Investment/lifeAssuredInvestment) |
| \`monthlyIncome\` | Money |  | Monthly income from investment |
| \`isOriginalInvestmentProtected\` | boolean |  | Whether original capital is protected |
| \`benefits\` | Complex Data |  | Life cover and critical illness benefits (lifeAssuredInvestment only) |
| \`lifeAssured\` | List of Complex Data |  | Persons whose lives are assured (lifeAssuredInvestment only) |
| \`contributions\` | List of Complex Data |  | Investment contributions (regular, lumpsum, transfer) |
| \`fundHoldings\` | Complex Data |  | Individual fund holdings and allocations |
| \`createdAt\` | timestamp |  | When this record was created |
| \`updatedAt\` | timestamp |  | When this record was last modified |

*Total: 25 properties*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### Reference Link

Standard reference structure for linked entities:

| Field | Type | Description |
|-------|------|-------------|
| \`id\` | integer | Unique identifier of referenced entity |
| \`href\` | string | API endpoint URL for referenced entity |

**Used for:** \`factfind\`

#### owners (List of Owner References)

Clients who own this investment:

| Field | Type | Description |
|-------|------|-------------|
| \`id\` | integer | Client unique identifier |
| \`href\` | string | API link to client resource (e.g., \`/api/v2/factfinds/679/clients/8496\`) |
| \`name\` | string | Client full name |

**Note:** Investments can have multiple owners (joint ownership).

#### sellingAdviser (Selling Adviser Reference)

Adviser who arranged this investment:

| Field | Type | Description |
|-------|------|-------------|
| \`id\` | integer | Adviser unique identifier |
| \`href\` | string | API link to adviser resource (e.g., \`/api/v2/advisers/123\`) |
| \`name\` | string | Adviser full name |

#### provider (Product Provider Reference)

Product provider/company:

| Field | Type | Description |
|-------|------|-------------|
| \`id\` | integer | Product provider unique identifier |
| \`href\` | string | API link to product provider resource (e.g., \`/api/v2/productproviders/456\`) |
| \`name\` | string | Product provider name (e.g., "Vanguard", "Aviva", "Fidelity") |

**Common Product Providers:**
- **Vanguard** - Low-cost index funds and ETFs
- **Fidelity** - Investment platform and fund manager
- **Aviva** - Life assurance and investment bonds
- **Standard Life** - Pensions and investments
- **Legal & General** - Insurance and investments
- **Prudential** - International life insurance
- **Scottish Widows** - Life, pensions, and investments
- **AJ Bell** - Investment platform
- **Hargreaves Lansdown** - Investment platform
- **Interactive Investor** - Investment platform

#### lifeCycle (Lifecycle Reference)

Investment lifecycle stage reference:

| Field | Type | Description |
|-------|------|-------------|
| \`id\` | integer | Lifecycle unique identifier |
| \`href\` | string | API link to lifecycle resource (e.g., \`/api/v2/lifecycles/45\`) |
| \`name\` | string | Lifecycle stage name (e.g., "Accumulation", "Decumulation") |

**Lifecycle Stages:**
- **Accumulation** - Building wealth, regular contributions
- **Consolidation** - Preserving wealth, reduced contributions
- **Decumulation** - Drawing income, withdrawals
- **Maturity** - End of term approaching

#### investmentType (Investment Type Reference)

Specific investment type/plan details:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Plan type unique identifier |
| `href` | string | API link to plan type resource (e.g., `/api/v2/plantypes?filter=id eq 123`) |
| `name` | string | Investment type name (e.g., "Stocks & Shares ISA", "OEIC", "Unit Trust") |

**Common Investment Types:**
- **Stocks & Shares ISA** - Tax-efficient equity investment wrapper
- **OEIC** - Open-Ended Investment Company
- **Unit Trust** - Pooled investment fund
- **Investment Bond** - Life assurance-based investment
- **Offshore Bond** - International investment bond
- **Portfolio Bond** - Multiple fund investment bond
- **VCT** - Venture Capital Trust
- **EIS** - Enterprise Investment Scheme
- **Cash ISA** - Tax-efficient savings account
- **General Investment Account (GIA)** - Taxable investment account

#### wrap (Platform/Wrap Account Reference)

Platform or wrap account details:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Wrap account identifier |
| `href` | string | Link to parent wrap account investment (e.g., `/api/v2/factfinds/679/investments/9001`) |
| `reference` | string | Wrap account reference number |

**Use Cases:**
- **Platform Consolidation** - Links multiple investments to a single platform account
- **Fee Visibility** - Track platform fees at wrap account level
- **Reporting** - Consolidated reporting across wrapped investments
- **Administration** - Simplified account management

#### valuation (Current Valuation Details)

Current investment value information:

| Field | Type | Description |
|-------|------|-------------|
| `currentValue` | Money | Current investment value |
| `valuedOn` | date | Date of valuation |

**Money Structure:**

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Value amount (e.g., 125000.00) |
| `currency` | object | Currency details |
| `currency.code` | string | ISO 4217 currency code (e.g., "GBP", "USD", "EUR") |
| `currency.symbol` | string | Currency symbol (e.g., "£", "$", "€") |

#### cashAccount (Cash Account Details)

Applicable only for `CashBankAccount` investment category:

| Field | Type | Description |
|-------|------|-------------|
| `interestRate` | decimal | Current interest rate percentage (e.g., 4.25) |
| `currency` | string | Account currency (e.g., "GBP") |

**Common Cash Account Types:**
- **Instant Access Savings** - Immediate withdrawal access
- **Notice Account** - Requires notice period for withdrawals
- **Fixed Rate Bond** - Fixed term, fixed rate
- **Cash ISA** - Tax-efficient savings
- **Current Account** - Everyday banking

#### maturityDetails (Maturity Projection Details)

Applicable only for `Investment` and `lifeAssuredInvestment` categories:

| Field | Type | Description |
|-------|------|-------------|
| `maturityOn` | date | Expected maturity date |
| `lowMaturityValue` | Money | Conservative projection value |
| `mediumMaturityValue` | Money | Standard projection value |
| `highMaturityValue` | Money | Optimistic projection value |
| `maturityValueProjectionDetails` | string | Projection assumptions and methodology |

**Projection Assumptions:**
- **Low** - Typically 3% annual growth
- **Medium** - Typically 5% annual growth
- **High** - Typically 7% annual growth

#### benefits (Life Cover and Critical Illness Benefits)

Applicable only for `lifeAssuredInvestment` category:

| Field | Type | Description |
|-------|------|-------------|
| `lifeCover` | object | Life cover details |
| `lifeCover.sumAssured` | Money | Life cover amount |
| `lifeCover.termInYears` | integer | Cover term in years |
| `criticalIllness` | object | Critical illness cover details |
| `criticalIllness.sumAssured` | Money | Critical illness cover amount |
| `criticalIllness.termInYears` | integer | Cover term in years |
| `paymentBasis` | string | When benefit pays out |
| `isInTrust` | boolean | Whether policy is held in trust |
| `inTrustToWhom` | string | Trust beneficiaries description |

**Payment Basis Values:**
- **FirstDeath** - Benefit pays on first death
- **SecondDeath** - Benefit pays on second death (survivorship)
- **Both** - Separate benefits for each life

#### lifeAssured (Life Assured Persons)

Applicable only for `lifeAssuredInvestment` category. List of persons whose lives are assured:

| Field | Type | Description |
|-------|------|-------------|
| `title` | string | Title (e.g., "Mr", "Mrs", "Miss", "Ms", "Dr") |
| `firstName` | string | First name |
| `lastName` | string | Last name |
| `dateOfBirth` | date | Date of birth |
| `gender` | string | Gender (Male, Female, Other) |
| `client` | object | Link to client record |
| `client.id` | integer | Client identifier |
| `client.href` | string | Link to client resource |

#### contributions (Investment Contributions)

List of contribution arrangements (regular, lump sum, or transfers):

| Field | Type | Description |
|-------|------|-------------|
| `type` | string | Contribution type (regular, lumpsum, Transfer) |
| `value` | Money | Contribution amount |
| `startedOn` | date | Contribution start date |
| `endOn` | date | Contribution end date (null if ongoing) |
| `contributor` | string | Who makes the contribution |
| `transfer` | object | Transfer details (when type = Transfer) |

**Contributor Values:**
- **Self** - Client's own contributions
- **Employer** - Employer contributions
- **Other** - Other third party
- **N_A** - Not applicable
- **Government** - Government contributions (e.g., tax relief)
- **Relative** - Family member contributions
- **SalarySacrifice** - Salary sacrifice arrangements
- **PartnerOrSpouse** - Partner or spouse contributions
- **HeldInSuper** - Held in superannuation (non-UK)

**Transfer Object Structure:**

| Field | Type | Description |
|-------|------|-------------|
| `transferType` | string | Transfer type (Cash, Inspecie) |
| `isFullTransfer` | boolean | Whether full transfer |
| `ceedingPlan` | object | Plan being transferred from |
| `ceedingPlan.id` | integer | Ceeding plan identifier |
| `ceedingPlan.href` | string | Link to ceeding plan |
| `ceedingPlan.reference` | string | Ceeding plan reference |

**Transfer Types:**
- **Cash** - Cash transfer (liquidate and transfer proceeds)
- **Inspecie** - In-specie transfer (transfer actual holdings)

#### fundHoldings (Fund Holdings and Allocations)

Detailed fund holdings with identification codes:

| Field | Type | Description |
|-------|------|-------------|
| `model` | object | Model portfolio details |
| `model.code` | string | Model portfolio code |
| `model.Name` | string | Model portfolio name |
| `funds` | array | Individual fund holdings |

**Fund Object Structure:**

| Field | Type | Description |
|-------|------|-------------|
| `codes` | array | Fund identification codes |
| `name` | string | Fund name |
| `holding` | object | Holding details |
| `holding.units` | decimal | Number of units held |
| `holding.percentage` | decimal | Percentage of total portfolio |
| `isFeed` | boolean | Whether this is a feeder fund |
| `type` | string | Fund type |

**Code Object Structure:**

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Code type |
| `value` | string | Code value |

**Fund Code Types:**
- **ISIN** - International Securities Identification Number
- **SEDOL** - Stock Exchange Daily Official List
- **PlatForm** - Platform-specific code
- **CITI** - Citi fund code
- **MEXID** - MEX ID
- **Bloomberg** - Bloomberg ticker

**Fund Types:**
- **Fund** - Unit trust or OEIC
- **Equity** - Individual stock
- **Bond** - Fixed income security
- **Property** - Real estate investment
- **Cash** - Money market fund
- **Commodity** - Commodity investment
- **Other** - Alternative investments

---

## Complete Contract Schema

### Investment Contract Full Definition

```json
{
  "id": 15001,
  "href": "/api/v2/factfinds/679/investments/15001",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "owners": [
    {
      "id": 8496,
      "href": "/api/v2/factfinds/679/clients/8496",
      "name": "John Smith"
    }
  ],
  "sellingAdviser": {
    "id": 123,
    "href": "/api/v2/advisers/123",
    "name": "Jane Financial Adviser"
  },
  "provider": {
    "id": 456,
    "href": "/api/v2/productproviders/456",
    "name": "Vanguard"
  },
  "lifeCycle": {
    "id": 45,
    "href": "/api/v2/lifecycles/45",
    "name": "Accumulation"
  },
  "investmentCategory": "Investment",
  "investmentType": {
    "id": 123,
    "href": "/api/v2/plantypes?filter=id eq 123",
    "name": "Stocks & Shares ISA"
  },
  "policyNumber": "INV-123456789",
  "agencyStatus": "NOT_UNDER_AGENCY",
  "productName": "Global Growth Portfolio",
  "startedOn": "2020-06-15",
  "endsOn": "2035-06-15",
  "wrap": {
    "id": 9001,
    "href": "/api/v2/factfinds/679/investments/9001",
    "reference": "WRAP-987654"
  },
  "valuation": {
    "currentValue": {
      "amount": 125000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "valuedOn": "2026-02-18"
  },
  "maturityDetails": {
    "maturityOn": "2035-06-15",
    "lowMaturityValue": {
      "amount": 180000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "mediumMaturityValue": {
      "amount": 245000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "highMaturityValue": {
      "amount": 325000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "maturityValueProjectionDetails": "Projections based on 3%, 5%, and 7% annual growth rates"
  },
  "monthlyIncome": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "isOriginalInvestmentProtected": false,
  "contributions": [
    {
      "type": "regular",
      "value": {
        "amount": 500.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "startedOn": "2020-06-15",
      "endOn": null,
      "contributor": "Self"
    }
  ],
  "fundHoldings": {
    "model": {
      "code": "BALANCED-GROWTH-60-40",
      "Name": "BALANCED GROWTH-60-40"
    },
    "funds": [
      {
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
        "name": "Vanguard FTSE Global All Cap Index Fund",
        "holding": {
          "units": 1250.567,
          "percentage": 35.5
        },
        "isFeed": false,
        "type": "Fund"
      },
      {
        "codes": [
          {
            "code": "ISIN",
            "value": "GB00B41YBW71"
          }
        ],
        "name": "Vanguard U.K. Investment Grade Bond Index Fund",
        "holding": {
          "units": 890.234,
          "percentage": 25.0
        },
        "isFeed": false,
        "type": "Bond"
      }
    ]
  },
  "createdAt": "2020-06-15T10:00:00Z",
  "updatedAt": "2026-02-18T14:30:00Z"
}
```

### Cash Bank Account Example

```json
{
  "id": 15002,
  "href": "/api/v2/factfinds/679/investments/15002",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "owners": [
    {
      "id": 8496,
      "href": "/api/v2/factfinds/679/clients/8496",
      "name": "John Smith"
    }
  ],
  "provider": {
    "id": 789,
    "href": "/api/v2/productproviders/789",
    "name": "Nationwide Building Society"
  },
  "lifeCycle": {
    "id": 45,
    "href": "/api/v2/lifecycles/45",
    "name": "Accumulation"
  },
  "investmentCategory": "CashBankAccount",
  "investmentType": {
    "id": 456,
    "href": "/api/v2/plantypes?filter=id eq 456",
    "name": "Instant Access Savings"
  },
  "policyNumber": "ACC-987654321",
  "agencyStatus": "NOT_UNDER_AGENCY",
  "productName": "FlexDirect Current Account",
  "startedOn": "2018-03-10",
  "valuation": {
    "currentValue": {
      "amount": 25000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "valuedOn": "2026-02-18"
  },
  "cashAccount": {
    "interestRate": 4.25,
    "currency": "GBP"
  },
  "createdAt": "2018-03-10T09:00:00Z",
  "updatedAt": "2026-02-18T14:30:00Z"
}
```

### Life-Assured Investment Bond Example

```json
{
  "id": 15003,
  "href": "/api/v2/factfinds/679/investments/15003",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "owners": [
    {
      "id": 8496,
      "href": "/api/v2/factfinds/679/clients/8496",
      "name": "John Smith"
    },
    {
      "id": 8497,
      "href": "/api/v2/factfinds/679/clients/8497",
      "name": "Jane Smith"
    }
  ],
  "provider": {
    "id": 234,
    "href": "/api/v2/productproviders/234",
    "name": "Aviva"
  },
  "lifeCycle": {
    "id": 45,
    "href": "/api/v2/lifecycles/45",
    "name": "Accumulation"
  },
  "investmentCategory": "lifeAssuredInvestment",
  "investmentType": {
    "id": 567,
    "href": "/api/v2/plantypes?filter=id eq 567",
    "name": "Investment Bond with Life Cover"
  },
  "policyNumber": "BOND-456789123",
  "agencyStatus": "NOT_UNDER_AGENCY",
  "productName": "Aviva Pension Protector Bond",
  "startedOn": "2019-09-01",
  "endsOn": "2039-09-01",
  "valuation": {
    "currentValue": {
      "amount": 275000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "valuedOn": "2026-02-18"
  },
  "maturityDetails": {
    "maturityOn": "2039-09-01",
    "lowMaturityValue": {
      "amount": 380000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "mediumMaturityValue": {
      "amount": 520000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "highMaturityValue": {
      "amount": 690000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "maturityValueProjectionDetails": "Projections based on 3%, 5%, and 7% annual growth rates with life cover charges deducted"
  },
  "monthlyIncome": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "isOriginalInvestmentProtected": false,
  "benefits": {
    "lifeCover": {
      "sumAssured": {
        "amount": 250000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "termInYears": 20
    },
    "criticalIllness": {
      "sumAssured": {
        "amount": 250000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "termInYears": 20
    },
    "paymentBasis": "FirstDeath",
    "isInTrust": true,
    "inTrustToWhom": "Children: Emily and James Smith"
  },
  "lifeAssured": [
    {
      "title": "Mr",
      "firstName": "John",
      "lastName": "Smith",
      "dateOfBirth": "1980-05-15",
      "gender": "Male",
      "client": {
        "id": 8496,
        "href": "/api/v2/factfinds/679/clients/8496"
      }
    },
    {
      "title": "Mrs",
      "firstName": "Jane",
      "lastName": "Smith",
      "dateOfBirth": "1982-08-22",
      "gender": "Female",
      "client": {
        "id": 8497,
        "href": "/api/v2/factfinds/679/clients/8497"
      }
    }
  ],
  "contributions": [
    {
      "type": "lumpsum",
      "value": {
        "amount": 250000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "startedOn": "2019-09-01",
      "endOn": "2019-09-01",
      "contributor": "Self"
    }
  ],
  "fundHoldings": {
    "funds": [
      {
        "codes": [
          {
            "code": "ISIN",
            "value": "GB00B8GKDB09"
          }
        ],
        "name": "Aviva Pension MyM Managed Balanced 1",
        "holding": {
          "units": 12500.00,
          "percentage": 60.0
        },
        "isFeed": false,
        "type": "Fund"
      },
      {
        "codes": [
          {
            "code": "ISIN",
            "value": "GB00B8GKDC16"
          }
        ],
        "name": "Aviva Pension MyM Corporate Bond All Stocks 1",
        "holding": {
          "units": 8333.33,
          "percentage": 40.0
        },
        "isFeed": false,
        "type": "Bond"
      }
    ]
  },
  "createdAt": "2019-09-01T11:30:00Z",
  "updatedAt": "2026-02-18T14:30:00Z"
}
```

---

## Business Validation Rules

### Category-Based Validation

- `cashAccount` fields only applicable when `investmentCategory = CashBankAccount`
- `maturityDetails`, `monthlyIncome`, `isOriginalInvestmentProtected` only applicable for `Investment` or `lifeAssuredInvestment`
- `benefits` and `lifeAssured` only applicable when `investmentCategory = lifeAssuredInvestment`

### Required Fields

- `investmentCategory` is required (defaults to "Investment")
- `investmentType` is required
- `owners` list must contain at least one owner
- `valuation.currentValue` is required
- `valuation.valuedOn` is required

### Contribution Validation

- When `contributions.type = Transfer`, `transfer` object is required
- When `contributions.type = regular`, `startedOn` is required
- `contributor` must be one of: Self, Employer, Other, N_A, Government, Relative, SalarySacrifice, PartnerOrSpouse, HeldInSuper

### Fund Holdings Validation

- `fundHoldings.funds.holding.percentage` values must sum to 100% across all funds
- At least one fund code must be provided for each fund
- `fundHoldings.funds.type` must be one of: Fund, Equity, Bond, Property, Cash, Commodity, Other

### Investment Category Values

- `CashBankAccount` - Bank accounts, savings accounts, cash ISAs
- `Investment` - General investments, unit trusts, OEICs, investment bonds (without life cover)
- `lifeAssuredInvestment` - Investment bonds with life assurance, whole of life policies with investment element

### Agency Status Values

- `NOT_UNDER_AGENCY` - Investment not under agency servicing
- `UNDER_AGENCY_INFORMATION_ONLY` - Agency provides information only
- `UNDER_AGENCY_SERVICING_AGENT` - Full agency servicing

---

**Document Version:** 2.0
**Last Updated:** 2026-02-25
**Entity:** Investment
**Domain:** Plans
