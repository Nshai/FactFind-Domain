# State Pension API Design

**Version:** 1.0
**Date:** 2026-03-03
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
| **Entity Name** | StatePension |
| **Domain** | Plans |
| **Aggregate Root** | FactFind |
| **Base Path** | `/api/v2/factfinds/{factfindId}/pensions/statepension` |
| **Resource Type** | Collection |

### Description

Comprehensive management of State Pension entitlements including basic State Pension, additional State Pension (SERPS/S2P), new State Pension, Pension Credit, spouse pension inheritance, and BR19 projection data for retirement planning.

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
| GET | `/api/v2/factfinds/{factfindId}/pensions/statepension` | List all state pension records | Query params | StatePensionEntitlement[] | 200, 401, 403 | StatePension, List |
| POST | `/api/v2/factfinds/{factfindId}/pensions/statepension` | Create state pension record | StatePensionRequest | StatePensionEntitlement | 201, 400, 401, 403, 422 | StatePension, Create |
| GET | `/api/v2/factfinds/{factfindId}/pensions/statepension/{pensionId}` | Get state pension by ID | Path params | StatePensionEntitlement | 200, 401, 403, 404 | StatePension, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/pensions/statepension/{pensionId}` | Update state pension | StatePensionPatch | StatePensionEntitlement | 200, 400, 401, 403, 404, 422 | StatePension, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/pensions/statepension/{pensionId}` | Delete state pension | Path params | None | 204, 401, 403, 404, 422 | StatePension, Delete |


### Authorization

**Required Scopes:**
- `pensions:read` - Read access (GET operations)
- `pensions:write` - Create and update access (POST, PUT, PATCH)
- `pensions:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary

### State Pension Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique identifier for the state pension record |
| `href` | string |  | Resource URL for this state pension record |
| `factfind` | Reference Link |  | Link to the FactFind that this state pension belongs to |
| `owner` | Complex Data |  | Client who owns this state pension entitlement |
| `retirementAge` | integer |  | State Pension age for this individual |
| `statePensionProvision` | Complex Data |  | State Pension provision details |
| `spousePension` | Money |  | Inherited spouse pension entitlement |
| `br19Projection` | string |  | BR19 State Pension forecast reference or data |
| `notes` | string |  | Additional notes and comments |
| `createdAt` | timestamp |  | When this record was created |
| `updatedAt` | timestamp |  | When this record was last modified |

*Total: 11 properties*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### Reference Link

Standard reference structure for linked entities:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of referenced entity |
| `href` | string | API endpoint URL for referenced entity |

**Used for:** `factfind`

#### owner (Owner Reference)

Client who owns this state pension entitlement:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Client unique identifier |
| `href` | string | API link to client resource (e.g., `/api/v2/factfinds/679/clients/8496`) |
| `name` | string | Client full name |

**Note:** State pensions are individual entitlements and cannot be jointly owned.

#### statePensionProvision (State Pension Provision Details)

Breakdown of State Pension entitlement components:

| Field | Type | Description |
|-------|------|-------------|
| `basicAmount` | Money | Basic State Pension amount (pre-2016) or new State Pension amount (post-2016) |
| `additionalAmount` | Money | Additional State Pension (SERPS/S2P) for pre-2016 system |
| `benefitCredit` | Money | Pension Credit entitlement (means-tested top-up) |

**State Pension Components:**

##### Basic State Pension (Old System - Pre-2016)
- **basicAmount** - Basic State Pension for those who reached State Pension age before 6 April 2016
- **Maximum (2024/25)** - £169.50 per week (full entitlement: 30 qualifying years for women, 44 for men born before 1945)
- **Qualifying Years** - National Insurance contribution or credit years

##### New State Pension (Post-2016)
- **basicAmount** - New State Pension for those reaching State Pension age on or after 6 April 2016
- **Full Amount (2024/25)** - £221.20 per week (35 qualifying years required)
- **Minimum** - 10 qualifying years needed to qualify
- **Maximum** - Cannot exceed full new State Pension amount unless transitional protection applies

##### Additional State Pension (SERPS/S2P)
- **additionalAmount** - State Earnings Related Pension Scheme (SERPS) or State Second Pension (S2P)
- **Applies To** - Those who reached State Pension age before 6 April 2016 and did not contract out
- **Contracting Out** - Reduced if previously contracted out via occupational pension or personal pension

##### Pension Credit (Means-Tested)
- **benefitCredit** - Pension Credit is a means-tested benefit to top up pension income
- **Guarantee Credit** - Tops up weekly income to £218.15 (single) or £332.95 (couple) in 2024/25
- **Savings Credit** - Additional amount for those who reached State Pension age before 6 April 2016 and have modest savings

#### Money (Monetary Value)

Standard money structure:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Monetary amount (e.g., 15000.00) |
| `currency` | object | Currency details |
| `currency.code` | string | ISO 4217 currency code (e.g., "GBP") |
| `currency.display` | string | Currency display name (e.g., "British Pound") |
| `currency.symbol` | string | Currency symbol (e.g., "£") |

**Used for:** `statePensionProvision.basicAmount`, `statePensionProvision.additionalAmount`, `statePensionProvision.benefitCredit`, `spousePension`

---

## Complete Contract Schema

### Example 1: New State Pension (Post-2016) with Full Entitlement

```json
{
  "id": 1234,
  "href": "/api/v2/factfinds/679/pensions/statepension/1234",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "owner": {
    "id": 8496,
    "href": "/api/v2/factfinds/679/clients/8496",
    "name": "Sarah Johnson"
  },
  "retirementAge": 67,
  "statePensionProvision": {
    "basicAmount": {
      "amount": 11502.40,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "additionalAmount": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "benefitCredit": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    }
  },
  "spousePension": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "br19Projection": "BR19 Reference: SP-2024-123456789 - Full new State Pension £221.20 per week (£11,502.40 per annum) at age 67. Based on 35 qualifying years.",
  "notes": "Full new State Pension entitlement. 35 qualifying years achieved. State Pension age 67 (DOB: 15/08/1970).",
  "createdAt": "2024-11-15T10:00:00Z",
  "updatedAt": "2026-03-03T14:30:00Z"
}
```

### Example 2: Old State Pension (Pre-2016) with Additional Pension and Spouse Inheritance

```json
{
  "id": 1235,
  "href": "/api/v2/factfinds/679/pensions/statepension/1235",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "owner": {
    "id": 8497,
    "href": "/api/v2/factfinds/679/clients/8497",
    "name": "Margaret Thompson"
  },
  "retirementAge": 65,
  "statePensionProvision": {
    "basicAmount": {
      "amount": 8814.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "additionalAmount": {
      "amount": 2450.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "benefitCredit": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    }
  },
  "spousePension": {
    "amount": 1250.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "br19Projection": "BR19 Reference: SP-2015-987654321 - Basic State Pension £169.50 per week plus Additional Pension £47.12 per week. Spouse inheritance £24.04 per week.",
  "notes": "Old State Pension system. 30 qualifying years. Additional SERPS pension accrued. Inherited 50% of late husband's Additional Pension.",
  "createdAt": "2015-06-20T09:30:00Z",
  "updatedAt": "2026-03-03T14:30:00Z"
}
```

### Example 3: Reduced New State Pension with Pension Credit

```json
{
  "id": 1236,
  "href": "/api/v2/factfinds/679/pensions/statepension/1236",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "owner": {
    "id": 8498,
    "href": "/api/v2/factfinds/679/clients/8498",
    "name": "David Williams"
  },
  "retirementAge": 66,
  "statePensionProvision": {
    "basicAmount": {
      "amount": 7200.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "additionalAmount": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "benefitCredit": {
      "amount": 4134.80,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    }
  },
  "spousePension": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
        "symbol": "£"
      }
  },
  "br19Projection": "BR19 Reference: SP-2023-555666777 - Reduced new State Pension £138.46 per week (22 qualifying years). Eligible for Pension Credit top-up.",
  "notes": "Incomplete NI record (22 qualifying years). Entitled to Pension Credit Guarantee Credit to top up to minimum income guarantee. Voluntary contributions may increase State Pension.",
  "createdAt": "2023-09-10T11:00:00Z",
  "updatedAt": "2026-03-03T14:30:00Z"
}
```

---

## Business Validation Rules

### Retirement Age

- **Current State Pension Age** - 66 (for those born between 6 October 1954 and 5 April 1960)
- **Rising to 67** - Between 2026 and 2028 (for those born between 6 April 1960 and 5 April 1977)
- **Rising to 68** - Planned for 2044-2046 (subject to review)
- **Equal for Men and Women** - Since 6 November 2018

### State Pension Systems

#### Old State Pension (Pre-6 April 2016)

**Applies to:** Anyone who reached State Pension age before 6 April 2016

- **Basic State Pension** - Maximum £169.50 per week (2024/25)
- **Qualifying Years** - 30 for women, 44 for men born before 1945 (reduced to 30 from 6 April 2010)
- **Additional State Pension** - SERPS (1978-2002) or S2P (2002-2016) if not contracted out

#### New State Pension (Post-6 April 2016)

**Applies to:** Anyone reaching State Pension age on or after 6 April 2016

- **Full Amount** - £221.20 per week (2024/25)
- **Minimum Qualifying Years** - 10 years to receive anything
- **Full Entitlement** - 35 qualifying years
- **No Additional State Pension** - Single-tier pension (includes SERPS/S2P equivalent)

### Contracting Out

- **Contracted Out Deduction** - Those who were contracted out into occupational or personal pensions have reduced State Pension entitlement
- **Applies To** - Old State Pension (Additional Pension component)
- **New State Pension** - Contracting out ended on 6 April 2016; past contracting out reduces starting amount

### Pension Credit

**Guarantee Credit:**
- Tops up weekly income to £218.15 (single) or £332.95 (couple) in 2024/25
- Available to those who have reached State Pension age
- Means-tested based on income and capital (capital over £10,000 affects entitlement)

**Savings Credit:**
- Only for those who reached State Pension age before 6 April 2016
- Rewards those who saved for retirement
- Maximum £17.01 per week (single) or £19.04 (couple) in 2024/25

### Spouse Inheritance

#### Old State Pension
- **Widow/Widower** - Can inherit up to 50% of spouse's Additional Pension (SERPS/S2P)
- **Basic State Pension** - Cannot inherit, but may claim based on spouse's NI record if beneficial

#### New State Pension
- **Inherited Protected Payment** - Only in specific circumstances involving transitional arrangements
- **Generally** - Cannot inherit new State Pension

### BR19 State Pension Forecast

- **BR19 Form** - Check your State Pension forecast from HMRC
- **Online Service** - gov.uk/check-state-pension
- **Contents** - Current forecast, qualifying years, gaps in NI record, State Pension age
- **Forecast Date** - Projections typically valid for 60 days

### Validation Rules

- `retirementAge` must be between 65 and 68 (current range; subject to change)
- `statePensionProvision.basicAmount` should not exceed £11,502.40 per annum (£221.20 per week) for new State Pension
- `statePensionProvision.basicAmount` should not exceed £8,814.00 per annum (£169.50 per week) for old State Pension
- If `statePensionProvision.benefitCredit` > 0, total income should be below Pension Credit threshold
- `spousePension` only applicable if client is widow/widower under old State Pension system

---

## UK State Pension Regulations

### State Pension Age

**Historical Changes:**
- **Pre-2010** - 65 for men, 60 for women
- **2010-2018** - Women's State Pension age increased from 60 to 65 to equalize with men
- **2018-2020** - State Pension age increased from 65 to 66 for both men and women
- **2026-2028** - State Pension age increasing from 66 to 67
- **2044-2046** - Planned increase from 67 to 68 (subject to review)

### National Insurance Qualifying Years

**Building Entitlement:**
- **Employed** - NI contributions automatically paid on earnings above £242 per week (2024/25)
- **Self-Employed** - Class 2 and Class 4 NI contributions
- **Voluntary Contributions** - Class 3 NI (£17.45 per week in 2024/25) to fill gaps
- **NI Credits** - Automatic credits for unemployment, caring responsibilities, illness

**Checking Your Record:**
- **Online** - gov.uk/check-national-insurance-record
- **By Post** - Request from HMRC
- **Gaps** - Can usually pay voluntary contributions for past 6 years to fill gaps

### State Pension Increases

**Triple Lock:**
- State Pension increases each April by the highest of:
  - Earnings growth (average wage increase)
  - Price inflation (CPI)
  - 2.5%
- **2024/25 Increase** - 8.5% (based on earnings growth)

### Deferring State Pension

**Old State Pension:**
- Defer by at least 5 weeks
- Increases by 1% for every 5 weeks deferred (10.4% per year)
- Or take lump sum (taxed at highest rate) plus 5.8% per year on remaining pension

**New State Pension:**
- Defer by at least 9 weeks
- Increases by 1% for every 9 weeks deferred (5.8% per year)
- No lump sum option

### State Pension and Tax

- State Pension is **taxable income**
- No tax deducted at source
- Tax collected through PAYE code on other income or self-assessment
- Personal Allowance (£12,570 in 2024/25) may cover State Pension if only income

---

## Related APIs

### Client API
- **GET** `/api/v2/factfinds/{factfindId}/clients/{clientId}` - Get client details including date of birth for State Pension age calculation

### Income API
- **GET** `/api/v2/factfinds/{factfindId}/clients/{clientId}/income` - State Pension counts as income for affordability assessments

### Personal Pension API
- **GET** `/api/v2/factfinds/{factfindId}/pensions/personalpension` - Personal pensions that may have contracted out of Additional State Pension

### Final Salary Pension API
- **GET** `/api/v2/factfinds/{factfindId}/pensions/finalsalary` - Occupational pensions that may have contracted out of SERPS/S2P

---

## Query Parameters

### List Operation Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `owner` | integer | Filter by owner client ID | `?owner=8496` |
| `retirementAge` | integer | Filter by retirement age | `?retirementAge=67` |
| `page` | integer | Page number (1-indexed) | `?page=1` |
| `pageSize` | integer | Items per page (max 100) | `?pageSize=25` |
| `sort` | string | Sort field and direction | `?sort=retirementAge:asc` |

---

## HTTP Status Codes

### Success Responses

| Code | Description | Body |
|------|-------------|------|
| 200 OK | Resource retrieved successfully | StatePensionEntitlement or array |
| 201 Created | Resource created successfully | StatePensionEntitlement |
| 204 No Content | Resource deleted successfully | Empty |

### Client Error Responses

| Code | Description | When |
|------|-------------|------|
| 400 Bad Request | Invalid request format | Malformed JSON, invalid data types |
| 401 Unauthorized | Authentication required | Missing or invalid auth token |
| 403 Forbidden | Insufficient permissions | Missing required scope |
| 404 Not Found | Resource not found | FactFind or StatePension ID doesn't exist |
| 422 Unprocessable Entity | Business validation failed | Invalid retirement age, amounts exceed limits |

### Server Error Responses

| Code | Description | When |
|------|-------------|------|
| 500 Internal Server Error | Server error | Unexpected server issue |
| 503 Service Unavailable | Service temporarily unavailable | Maintenance or overload |

---

## Performance Considerations

### Caching
- State Pension forecasts can be cached for 60 days (typical BR19 validity period)
- Cache invalidation on PATCH/DELETE operations

### Pagination
- Default page size: 25
- Maximum page size: 100
- Use `page` and `pageSize` parameters for large result sets

### Rate Limiting
- Standard rate limits apply (see Master API Design)
- Consider caching BR19 projection data to reduce repeated API calls

---

## Security Considerations

### Sensitive Data
- State Pension entitlements contain personally identifiable information (PII)
- BR19 references should be stored securely
- Pension Credit data is means-tested and sensitive

### Audit Trail
- All creates, updates, and deletes must be audited
- Track who accessed State Pension records
- Maintain history of forecast changes over time

### Access Control
- Only authorized advisers/users should access client State Pension data
- Implement row-level security based on factfind ownership

---

**Document Version:** 1.0
**Last Updated:** 2026-03-03
**Entity:** StatePension
**Domain:** Plans
