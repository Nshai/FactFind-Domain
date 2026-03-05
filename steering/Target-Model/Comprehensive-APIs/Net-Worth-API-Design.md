# Net-Worth API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Assets & Liabilities

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | Net-Worth |
| **Domain** | Assets & Liabilities |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v3/...` |
| **Resource Type** | Collection |

### Description

Net worth calculations

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
- `net_worth:read` - Read access (GET operations)
- `net_worth:write` - Create and update access (POST, PUT, PATCH)
- `net_worth:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary






### Net-Worth Resource Properties

*Fields organized into 4 sections*

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| **Main Fields** | | | |
| `id` | integer | ✓ | Unique identifier |
| `href` | string |  | Web address for this net worth record |
| `factfind` | Reference Link |  | The fact-find this belongs to |
| `clients` | List<Reference Link> |  | Clients included in this calculation |
| `calculatedOn` | timestamp |  | When this net worth was calculated |
| `notes` | string |  | Context for this calculation |
| `createdAt` | timestamp |  | When this record was created |
| `updatedAt` | timestamp |  | When this record was last modified |
| **Asset Breakdown** | | | |
| `property` | Money |  | Total property asset value |
| `pensions` | Money |  | Total pension asset value |
| `investments` | Money |  | Total investment asset value |
| `cash` | Money |  | Total cash and savings |
| `other` | Money |  | Other assets (business, collectibles, etc.) |
| `totalAssets` | Money |  | Sum of all asset categories (calculated) |
| **Liability Breakdown** | | | |
| `mortgages` | Money |  | Total outstanding mortgages |
| `loans` | Money |  | Total loans (personal, secured, unsecured) |
| `creditCards` | Money |  | Total credit card balances |
| `totalLiabilities` | Money |  | Sum of all liability categories (calculated) |
| **Net Worth** | | | |
| `netWorth` | Money |  | Total assets minus total liabilities (calculated) |

*Total: 19 properties across 4 sections*

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

**Used for:** All asset values, liability values, and net worth total

#### Reference Link

Standard reference structure for linked entities:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of referenced entity |
| `href` | string | API endpoint URL for referenced entity |

**Used for:** `factfind`, `clients` (list)

### Net Worth Calculation

**Formula:**
```
Net Worth = Total Assets - Total Liabilities
```

**Asset Breakdown:**
```
Total Assets = property + pensions + investments + cash + other
```

**Liability Breakdown:**
```
Total Liabilities = mortgages + loans + creditCards
```

**Complete Calculation:**
```
Net Worth = (property + pensions + investments + cash + other)
          - (mortgages + loans + creditCards)
```

### Asset Categories

**Property:**
- Main residence (equity only, not total value)
- Buy-to-let properties
- Second homes
- Commercial property
- Land

**Pensions:**
- Personal pensions
- Workplace pensions
- SIPPs (Self-Invested Personal Pensions)
- Final salary schemes (transfer value)
- State pension (not typically included)

**Investments:**
- ISAs (Individual Savings Accounts)
- General Investment Accounts
- Stocks and shares
- Bonds
- Investment funds
- Offshore accounts

**Cash:**
- Current accounts
- Savings accounts
- Premium bonds
- Cash ISAs
- Foreign currency accounts

**Other Assets:**
- Business ownership
- Business assets
- Collectibles (art, antiques, jewelry)
- Vehicles
- Life insurance surrender values

### Liability Categories

**Mortgages:**
- Residential mortgages
- Buy-to-let mortgages
- Commercial mortgages
- Second charge mortgages

**Loans:**
- Personal loans
- Car loans
- Secured loans
- Student loans
- Business loans
- Hire purchase agreements

**Credit Cards:**
- Credit card balances
- Store card balances
- Overdrafts

**Excluded Liabilities:**
- Future mortgage payments (only current balance counts)
- Ongoing bills and expenses (these affect cashflow, not net worth)

### Use Cases

**Financial Planning:**
- Baseline for retirement planning
- Asset allocation analysis
- Wealth accumulation tracking
- Estate planning

**Lending Assessment:**
- Mortgage affordability
- Secured lending decisions
- Wealth verification

**Risk Profiling:**
- Loss capacity assessment
- Investment capacity analysis
- Financial resilience evaluation

**Pension Planning:**
- Retirement adequacy assessment
- Income drawdown planning
- Lifetime allowance monitoring

### Snapshot vs. Ongoing Tracking

**Snapshot Approach:**
- Point-in-time net worth calculation
- Captured during fact-find process
- May be recalculated periodically
- Historical snapshots preserved for tracking

**Property Valuations:**
- Use recent valuations or online estimates (Zoopla, Rightmove)
- For mortgages: Equity = Property Value - Outstanding Mortgage

**Pension Valuations:**
- Use latest annual statements
- For defined benefit: Use Cash Equivalent Transfer Value (CETV)
- May need to request valuations from providers

### Related Resources

*See parent document for relationships to other entities.*


## Data Model

### Complete Schema

For complete field specifications, enumerations, and complex types, refer to:
- **[FactFind Contracts Reference](../../FactFind-Contracts-Reference.md)** - Complete contract definitions
- **[FactFind API Design v2](../../FactFind-API-Design-v2.md)** - Detailed operation specifications

### Common Field Types

**Standard Types:**
- `integer` - Whole numbers
- `string` - Text values
- `boolean` - true/false
- `date` - ISO 8601 date (YYYY-MM-DD)
- `timestamp` - ISO 8601 datetime (YYYY-MM-DDTHH:mm:ssZ)
- `decimal` - Decimal numbers

**Complex Types:**
- `Money` - Amount with currency
- `Provider` - Provider information object
- `Owner` - Ownership details object
- `Country` - Country with ISO code

---

## Business Rules

### Entity-Specific Rules

**Validation Rules:**
1. All required fields must be provided
2. Field formats must match specifications
3. Business logic constraints apply per entity type
4. Referential integrity must be maintained

**Business Constraints:**
- Net-Worth data must be accurate and up-to-date
- Changes must be auditable
- Deletion may require soft-delete for compliance
- Data retention policies must be followed

### Common Business Rules

For common business rules applicable to all entities, refer to **[Master API Design - Section 8](./MASTER-API-DESIGN.md#8-performance-standards)**.

---

## Request/Response Examples

### Example Request (Create)

```json
{
  "factfind": {
    "id": 456,
    "href": "/api/v3/factfinds/456"
  },
  "clients": [
    {
      "id": 789,
      "href": "/api/v3/factfinds/456/clients/789"
    }
  ],
  "notes": "Net worth calculated at point of initial fact-find"
}
```

**Note:** Asset and liability breakdowns are typically calculated automatically by aggregating from Asset and Liability entities.

### Example Response (Success)

```json
{
  "id": 123,
  "href": "/api/v3/factfinds/456/net-worth/123",
  "factfind": {
    "id": 456,
    "href": "/api/v3/factfinds/456"
  },
  "clients": [
    {
      "id": 789,
      "href": "/api/v3/factfinds/456/clients/789"
    }
  ],
  "calculatedOn": "2026-02-25T10:00:00Z",
  "property": {
    "amount": 350000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "pensions": {
    "amount": 185000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "investments": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "cash": {
    "amount": 25000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "other": {
    "amount": 15000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "totalAssets": {
    "amount": 650000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "mortgages": {
    "amount": 180000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "loans": {
    "amount": 12000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "creditCards": {
    "amount": 3000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "totalLiabilities": {
    "amount": 195000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "netWorth": {
    "amount": 455000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "notes": "Net worth calculated at point of initial fact-find",
  "createdAt": "2026-02-25T10:00:00Z",
  "updatedAt": "2026-02-25T10:00:00Z"
}
```

**Calculation Verification:**
- Total Assets: £350k (property) + £185k (pensions) + £75k (investments) + £25k (cash) + £15k (other) = **£650,000**
- Total Liabilities: £180k (mortgages) + £12k (loans) + £3k (credit cards) = **£195,000**
- Net Worth: £650,000 - £195,000 = **£455,000**

### Example Error Response

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "fieldName",
        "issue": "Specific issue description",
        "value": "invalid-value"
      }
    ],
    "timestamp": "2026-02-25T10:30:00Z",
    "requestId": "req-123456"
  }
}
```

For complete error response format and error codes, refer to **[Master API Design - Section 6](./MASTER-API-DESIGN.md#6-error-handling)**.

---

## Testing

### Test Scenarios

**Happy Path:**
1. Create Net-Worth with valid data
2. Retrieve Net-Worth by ID
3. Update Net-Worth fields
4. Delete Net-Worth

**Validation:**
1. Missing required fields
2. Invalid field formats
3. Business rule violations

**Authorization:**
1. Missing/invalid token
2. Insufficient permissions

For complete testing standards, refer to **[Master API Design - Section 9](./MASTER-API-DESIGN.md#9-testing-standards)**.

---

## References

### Primary Documents

- **[Master API Design](./MASTER-API-DESIGN.md)** - Common standards for all APIs
- **[FactFind API Design v2](../../FactFind-API-Design-v2.md)** - Complete source with detailed operations
- **[FactFind Contracts Reference](../../FactFind-Contracts-Reference.md)** - Complete contract/schema definitions
- **[API Endpoints Catalog](../../API-Endpoints-Catalog.md)** - Comprehensive endpoint catalog

### Related Entity APIs

See **[Master API Design - Section 11.{"1" if entity_info['domain'] == 'Client Management' else "2" if entity_info['domain'] == 'Circumstances' else "3" if entity_info['domain'] == 'Arrangements' else "4" if entity_info['domain'] == 'Assets & Liabilities' else "5" if entity_info['domain'] == 'Risk Profiling' else "6" if entity_info['domain'] == 'FactFind Root' else "7"}](./MASTER-API-DESIGN.md#11{"1" if entity_info['domain'] == 'Client Management' else "2" if entity_info['domain'] == 'Circumstances' else "3" if entity_info['domain'] == 'Arrangements' else "4" if entity_info['domain'] == 'Assets & Liabilities' else "5" if entity_info['domain'] == 'Risk Profiling' else "6" if entity_info['domain'] == 'FactFind Root' else "7"}-assets--liabilities-domain)** for other APIs in the Assets & Liabilities domain.

---

**Document Version:** 2.0
**Last Updated:** 2026-02-25
**Entity:** Net-Worth
**Domain:** Assets & Liabilities
