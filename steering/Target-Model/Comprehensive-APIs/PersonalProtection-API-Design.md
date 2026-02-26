# Personal Protection API Design

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
| **Entity Name** | PersonalProtection |
| **Domain** | Plans |
| **Aggregate Root** | FactFind |
| **Base Path** | `/api/v2/factfinds/{factfindId}/protections` |
| **Resource Type** | Collection |

### Description

Personal protection arrangements including life cover, critical illness cover, income protection, expense cover, and severity-based protection products.

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

| Method | Endpoint | Description | Auth Scope |
|--------|----------|-------------|------------|
| POST | `/api/v2/factfinds/{factfindId}/protections` | Create new protection | `protections:write` |
| GET | `/api/v2/factfinds/{factfindId}/protections` | List all protections | `protections:read` |
| GET | `/api/v2/factfinds/{factfindId}/protections/{protectionId}` | Get protection details | `protections:read` |
| PATCH | `/api/v2/factfinds/{factfindId}/protections/{protectionId}` | Update protection | `protections:write` |
| DELETE | `/api/v2/factfinds/{factfindId}/protections/{protectionId}` | Delete protection (soft) | `protections:delete` |

### Authorization

**Required Scopes:**
- `protections:read` - Read access (GET operations)
- `protections:write` - Create and update access (POST, PATCH)
- `protections:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Contract Schema

### PersonalProtection Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ (read-only) | Unique system identifier |
| `href` | string | ✓ (read-only) | Resource URI |
| `factfind` | FactFindRef | ✓ (read-only) | Parent fact find reference |
| `sellingAdviser` | AdviserRef |  | Selling adviser reference |
| `owners` | ClientRef[] | ✓ | Policy owner(s) |
| `provider` | ProviderRef | ✓ | Insurance provider reference |
| `protectionCategory` | string | ✓ | Protection category (default: "PersonalProtection") |
| `protectionType` | PlanTypeRef | ✓ | Protection type reference |
| `lifeCycle` | LifeCycleRef |  | Life cycle stage reference |
| `premiums` | PremiumValue[] | ✓ | Premium details |
| `lifeCover` | LifeCoverValue |  | Life cover details |
| `criticalIllnessCover` | CriticalIllnessCoverValue |  | Critical illness cover details |
| `incomeCover` | IncomeCoverValue |  | Income protection cover details |
| `expenseCover` | ExpenseCoverValue |  | Expense cover details |
| `severityCover` | SeverityCoverValue |  | Severity-based cover details |
| `benefitsPayable` | BenefitsPayableValue | ✓ | Benefits payment configuration |
| `indexType` | string | ✓ | Indexation type |
| `inTrust` | boolean | ✓ | Whether policy is held in trust |
| `inTrustToWhom` | string |  | Trust beneficiary details (max 250 chars) |
| `benefitOptions` | string[] |  | Benefit options (e.g., "Convertible") |
| `isRated` | boolean | ✓ | Whether policy has premium rating |
| `isPremiumWaiverWoc` | boolean | ✓ | Premium waiver on claim |
| `benefitSummary` | string |  | Summary of benefits |
| `exclusionNotes` | string |  | Policy exclusions |
| `initialEarningsPeriod` | string |  | Commission clawback period (ISO-8601) |
| `waitingPeriod` | string |  | Waiting period before eligibility (ISO-8601) |
| `premiumLoading` | string |  | Premium loading details (max 50 chars) |
| `owner2PercentOfSumAssured` | number |  | Co-owner's percentage of sum assured |
| `sumAssured` | MoneyValue | ✓ | Total sum assured |
| `commissions` | CommissionValue[] |  | Commission details |
| `protectionPayoutType` | string | ✓ | Payout type (Agreed/Indemnity) |
| `concurrencyId` | string | ✓ (read-only) | Optimistic concurrency token |
| `createdAt` | datetime | ✓ (read-only) | Creation timestamp |
| `updatedAt` | datetime | ✓ (read-only) | Last update timestamp |

---

## Value Types

### PremiumValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `startsOn` | date | ✓ | Premium start date |
| `stopsOn` | date |  | Premium end date (null if ongoing) |
| `value` | MoneyValue | ✓ | Premium amount |
| `frequency` | string | ✓ | Payment frequency |
| `type` | string | ✓ | Premium type (Regular/Single) |
| `contributorType` | string | ✓ | Contributor type (Self/Employer/Both) |
| `escalation` | EscalationValue | ✓ | Escalation configuration |

### EscalationValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `type` | string | ✓ | Escalation type (FixedPercentage, RPI, Level, NAEI, LPI) |
| `percentage` | number | ✓ | Escalation percentage |

### LifeCoverValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `term` | string | ✓ | Cover term in ISO-8601 format (P[n]Y) |
| `sumAssured` | MoneyValue | ✓ | Sum assured amount |
| `premiumStructure` | string | ✓ | Premium structure (Stepped/Level/Hybrid) |
| `additionalCover` | MoneyValue |  | Additional cover amount |
| `paymentBasis` | string | ✓ | Payment basis (FirstDeath/SecondDeath/Both) |
| `untilAge` | integer | ✓ | Cover until age (years) |

### CriticalIllnessCoverValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `premiumStructure` | string | ✓ | Premium structure (Stepped/Level/Hybrid) |
| `amount` | MoneyValue | ✓ | Cover amount |
| `term` | string | ✓ | Cover term in ISO-8601 format (P[n]Y) |
| `untilAge` | integer | ✓ | Cover until age (years) |

### IncomeCoverValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `premiumStructure` | string | ✓ | Premium structure (Stepped/Level/Hybrid) |
| `amount` | MoneyValue | ✓ | Monthly income amount |
| `term` | string | ✓ | Cover term in ISO-8601 format (P[n]Y) |
| `untilAge` | integer | ✓ | Cover until age (years) |

### ExpenseCoverValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `premiumStructure` | string | ✓ | Premium structure (Stepped/Level/Hybrid) |
| `amount` | MoneyValue | ✓ | Monthly expense amount |
| `term` | string | ✓ | Cover term in ISO-8601 format (P[n]Y) |
| `untilAge` | integer | ✓ | Cover until age (years) |

### SeverityCoverValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `permanentTotalDisabilityCover` | PermanentTotalDisabilityCoverValue |  | PTD cover details |
| `severityBasedCover` | SeverityBasedCoverValue |  | Severity-based cover details |

### PermanentTotalDisabilityCoverValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `premiumStructure` | string | ✓ | Premium structure (Stepped/Level/Hybrid) |
| `amount` | MoneyValue | ✓ | Cover amount |
| `term` | string | ✓ | Cover term in ISO-8601 format (P[n]Y) |
| `untilAge` | integer | ✓ | Cover until age (years) |

### SeverityBasedCoverValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `premiumStructure` | string | ✓ | Premium structure (Stepped/Level/Hybrid) |
| `amount` | MoneyValue | ✓ | Cover amount |
| `term` | string | ✓ | Cover term in ISO-8601 format (P[n]Y) |
| `untilAge` | integer | ✓ | Cover until age (years) |

### BenefitsPayableValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `benefitFrequency` | string | ✓ | Benefit frequency (Single/Weekly/Monthly/etc.) |
| `benefitPeriod` | BenefitPeriodValue |  | Benefit period configuration |
| `benefitAmount` | MoneyValue | ✓ | Benefit amount |
| `deferredPeriod` | string |  | Deferred period (ISO-8601: P[n]D) |
| `qualificationPeriod` | QualificationPeriodValue |  | Qualification period configuration |
| `splitBenefitFrequency` | string | ✓ | Split benefit frequency (default: None) |
| `splitBenefitValue` | MoneyValue |  | Split benefit amount |
| `splitDeferredPeriod` | string |  | Split deferred period (ISO-8601: P[n]Y/M/D) |

### BenefitPeriodValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `value` | string | ✓ | Period in months (ISO-8601: P[n]M) |
| `details` | string |  | Period details (max 255 chars) |

### QualificationPeriodValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `isBackToDayOne` | boolean | ✓ | Back to day one provision |
| `value` | string | ✓ | Period (ISO-8601: P[n]D) |

### CommissionValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `frequency` | string | ✓ | Commission frequency |
| `type` | string | ✓ | Commission type (Indemnity/NonIndemnity/SinglePremium/Level/Renewal) |
| `percentage` | number |  | Commission percentage (0-100) |
| `amount` | MoneyValue |  | Commission amount |

### MoneyValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `amount` | number | ✓ | Monetary amount |
| `currency` | CurrencyValue | ✓ | Currency details |

### CurrencyValue

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `code` | string | ✓ | ISO 4217 currency code (e.g., "GBP") |
| `display` | string | ✓ | Display name (e.g., "British Pound") |
| `symbol` | string | ✓ | Currency symbol (e.g., "£") |

---

## Reference Types

### FactFindRef

| Property | Type | Description |
|----------|------|-------------|
| `id` | integer | FactFind ID |
| `href` | string | FactFind URI |

### AdviserRef

| Property | Type | Description |
|----------|------|-------------|
| `id` | integer | Adviser ID |
| `href` | string | Adviser URI |
| `name` | string | Adviser name |

### ClientRef

| Property | Type | Description |
|----------|------|-------------|
| `id` | integer | Client ID |
| `href` | string | Client URI |
| `name` | string | Client name |

### ProviderRef

| Property | Type | Description |
|----------|------|-------------|
| `id` | integer | Provider ID |
| `href` | string | Provider URI |
| `name` | string | Provider name |

### PlanTypeRef

| Property | Type | Description |
|----------|------|-------------|
| `id` | integer | Plan type ID |
| `href` | string | Plan type URI |
| `name` | string | Plan type name |

### LifeCycleRef

| Property | Type | Description |
|----------|------|-------------|
| `id` | integer | Life cycle ID |
| `href` | string | Life cycle URI |
| `name` | string | Life cycle name |

---

## Enumeration Values

### Protection Category
- `PersonalProtection` (default)

### Index Type
- `LevelNotIndexed`
- `RPI`
- `FixedPercentage`
- `AEI`
- `Decreasing`
- `CPI`

### Premium Structure
- `Stepped`
- `Level`
- `Hybrid`

### Payment Basis (Life Cover)
- `FirstDeath`
- `SecondDeath`
- `Both`

### Benefit Frequency
- `None`
- `Weekly`
- `Fortnightly`
- `FourWeekly`
- `Monthly`
- `Quarterly`
- `HalfYearly`
- `Annually`
- `Single` (default)

### Escalation Type
- `FixedPercentage`
- `RPI`
- `Level`
- `NAEI`
- `LPI`

### Premium Frequency
- `Single`
- `Monthly`
- `Quarterly`
- `HalfYearly`
- `Annually`

### Premium Type
- `Regular`
- `Single`

### Contributor Type
- `Self`
- `Employer`
- `Both`

### Commission Type
- `Indemnity` (default)
- `NonIndemnity`
- `SinglePremium`
- `Level`
- `Renewal`

### Protection Payout Type
- `Agreed`
- `Indemnity` (default)

---

## Complete Examples

### Example 1: Life and Critical Illness Cover

```json
{
  "id": 15001,
  "href": "/api/v2/factfinds/679/protections/15001",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "sellingAdviser": {
    "id": 123,
    "href": "/api/v2/advisers/123",
    "name": "Jane Financial Adviser"
  },
  "owners": [
    {
      "id": 8496,
      "href": "/api/v2/factfinds/679/clients/8496",
      "name": "John Smith"
    }
  ],
  "provider": {
    "id": 456,
    "href": "/api/v2/productproviders/456",
    "name": "Legal & General"
  },
  "protectionCategory": "PersonalProtection",
  "protectionType": {
    "id": 123,
    "href": "/api/v2/plantypes?filter=id eq 123",
    "name": "Life and Critical Illness"
  },
  "lifeCycle": {
    "id": 45,
    "href": "/api/v2/lifecycles/45",
    "name": "Accumulation"
  },
  "premiums": [
    {
      "startsOn": "2024-01-01",
      "stopsOn": null,
      "value": {
        "amount": 150.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": "Monthly",
      "type": "Regular",
      "contributorType": "Self",
      "escalation": {
        "type": "RPI",
        "percentage": 0
      }
    }
  ],
  "lifeCover": {
    "term": "P25Y",
    "sumAssured": {
      "amount": 500000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "premiumStructure": "Level",
    "additionalCover": {
      "amount": 0,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "paymentBasis": "FirstDeath",
    "untilAge": 65
  },
  "criticalIllnessCover": {
    "premiumStructure": "Level",
    "amount": {
      "amount": 250000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "term": "P25Y",
    "untilAge": 65
  },
  "benefitsPayable": {
    "benefitFrequency": "Single",
    "benefitPeriod": {
      "value": "P12M",
      "details": "12 months benefit period"
    },
    "benefitAmount": {
      "amount": 500000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "deferredPeriod": "P0D",
    "qualificationPeriod": {
      "isBackToDayOne": false,
      "value": "P30D"
    },
    "splitBenefitFrequency": "None",
    "splitBenefitValue": {
      "amount": 0,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "splitDeferredPeriod": "P0D"
  },
  "indexType": "RPI",
  "inTrust": true,
  "inTrustToWhom": "Spouse and children",
  "benefitOptions": ["Convertible"],
  "isRated": false,
  "isPremiumWaiverWoc": true,
  "benefitSummary": "Level term life and critical illness cover with premium waiver",
  "exclusionNotes": "",
  "sumAssured": {
    "amount": 500000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "commissions": [
    {
      "frequency": "Monthly",
      "type": "Indemnity",
      "percentage": 2.5,
      "amount": {
        "amount": 3.75,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    }
  ],
  "protectionPayoutType": "Indemnity",
  "concurrencyId": "f7a8b9c0-1234-5678-9abc-def012345678",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

### Example 2: Income Protection Insurance

```json
{
  "id": 15002,
  "href": "/api/v2/factfinds/679/protections/15002",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "sellingAdviser": {
    "id": 123,
    "href": "/api/v2/advisers/123",
    "name": "Jane Financial Adviser"
  },
  "owners": [
    {
      "id": 8497,
      "href": "/api/v2/factfinds/679/clients/8497",
      "name": "Sarah Johnson"
    }
  ],
  "provider": {
    "id": 457,
    "href": "/api/v2/productproviders/457",
    "name": "Royal London"
  },
  "protectionCategory": "PersonalProtection",
  "protectionType": {
    "id": 124,
    "href": "/api/v2/plantypes?filter=id eq 124",
    "name": "Income Protection"
  },
  "lifeCycle": {
    "id": 45,
    "href": "/api/v2/lifecycles/45",
    "name": "Accumulation"
  },
  "premiums": [
    {
      "startsOn": "2024-02-01",
      "stopsOn": null,
      "value": {
        "amount": 85.50,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": "Monthly",
      "type": "Regular",
      "contributorType": "Self",
      "escalation": {
        "type": "FixedPercentage",
        "percentage": 3.0
      }
    }
  ],
  "incomeCover": {
    "premiumStructure": "Stepped",
    "amount": {
      "amount": 3000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "term": "P30Y",
    "untilAge": 65
  },
  "benefitsPayable": {
    "benefitFrequency": "Monthly",
    "benefitPeriod": {
      "value": "P24M",
      "details": "24 months benefit period with option to extend"
    },
    "benefitAmount": {
      "amount": 3000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "deferredPeriod": "P90D",
    "qualificationPeriod": {
      "isBackToDayOne": true,
      "value": "P30D"
    },
    "splitBenefitFrequency": "None",
    "splitBenefitValue": {
      "amount": 0,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "splitDeferredPeriod": "P0D"
  },
  "indexType": "FixedPercentage",
  "inTrust": false,
  "inTrustToWhom": null,
  "benefitOptions": [],
  "isRated": false,
  "isPremiumWaiverWoc": true,
  "benefitSummary": "Income protection with 90-day deferred period and 24-month benefit period",
  "exclusionNotes": "Pre-existing back condition excluded",
  "waitingPeriod": "P90D",
  "sumAssured": {
    "amount": 72000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "commissions": [
    {
      "frequency": "Monthly",
      "type": "Indemnity",
      "percentage": 3.0,
      "amount": {
        "amount": 2.57,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    }
  ],
  "protectionPayoutType": "Indemnity",
  "concurrencyId": "a1b2c3d4-5678-90ab-cdef-1234567890ab",
  "createdAt": "2024-02-10T14:20:00Z",
  "updatedAt": "2024-02-10T14:20:00Z"
}
```

### Example 3: Family Protection Bundle (Multi-Cover)

```json
{
  "id": 15003,
  "href": "/api/v2/factfinds/679/protections/15003",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "sellingAdviser": {
    "id": 123,
    "href": "/api/v2/advisers/123",
    "name": "Jane Financial Adviser"
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
      "name": "Sarah Johnson"
    }
  ],
  "provider": {
    "id": 458,
    "href": "/api/v2/productproviders/458",
    "name": "Aviva"
  },
  "protectionCategory": "PersonalProtection",
  "protectionType": {
    "id": 125,
    "href": "/api/v2/plantypes?filter=id eq 125",
    "name": "Family Protection Bundle"
  },
  "lifeCycle": {
    "id": 45,
    "href": "/api/v2/lifecycles/45",
    "name": "Accumulation"
  },
  "premiums": [
    {
      "startsOn": "2024-03-01",
      "stopsOn": null,
      "value": {
        "amount": 275.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": "Monthly",
      "type": "Regular",
      "contributorType": "Self",
      "escalation": {
        "type": "RPI",
        "percentage": 0
      }
    }
  ],
  "lifeCover": {
    "term": "P20Y",
    "sumAssured": {
      "amount": 750000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "premiumStructure": "Level",
    "additionalCover": {
      "amount": 50000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "paymentBasis": "FirstDeath",
    "untilAge": 60
  },
  "criticalIllnessCover": {
    "premiumStructure": "Level",
    "amount": {
      "amount": 300000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "term": "P20Y",
    "untilAge": 60
  },
  "incomeCover": {
    "premiumStructure": "Stepped",
    "amount": {
      "amount": 2500.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "term": "P20Y",
    "untilAge": 60
  },
  "severityCover": {
    "permanentTotalDisabilityCover": {
      "premiumStructure": "Level",
      "amount": {
        "amount": 200000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "term": "P20Y",
      "untilAge": 60
    },
    "severityBasedCover": {
      "premiumStructure": "Level",
      "amount": {
        "amount": 100000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "term": "P20Y",
      "untilAge": 60
    }
  },
  "benefitsPayable": {
    "benefitFrequency": "Single",
    "benefitPeriod": {
      "value": "P12M",
      "details": "Lump sum for life and CI, monthly for income"
    },
    "benefitAmount": {
      "amount": 750000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "deferredPeriod": "P0D",
    "qualificationPeriod": {
      "isBackToDayOne": false,
      "value": "P30D"
    },
    "splitBenefitFrequency": "Monthly",
    "splitBenefitValue": {
      "amount": 2500.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "splitDeferredPeriod": "P60D"
  },
  "indexType": "RPI",
  "inTrust": true,
  "inTrustToWhom": "Children aged under 18",
  "benefitOptions": ["Convertible", "Reviewable"],
  "isRated": true,
  "isPremiumWaiverWoc": true,
  "benefitSummary": "Comprehensive family protection bundle with life, CI, income, and severity covers",
  "exclusionNotes": "Hazardous sports exclusion applies",
  "premiumLoading": "10% loading due to occupation",
  "owner2PercentOfSumAssured": 50.00,
  "sumAssured": {
    "amount": 750000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "commissions": [
    {
      "frequency": "Monthly",
      "type": "Indemnity",
      "percentage": 3.5,
      "amount": {
        "amount": 9.63,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    }
  ],
  "protectionPayoutType": "Agreed",
  "concurrencyId": "x9y8z7w6-5432-10ab-cdef-fedcba987654",
  "createdAt": "2024-03-15T09:45:00Z",
  "updatedAt": "2024-03-15T09:45:00Z"
}
```

---

## Business Validation Rules

### Required Fields
- At least one owner must be specified
- Provider reference is required
- Protection type must be specified
- Premium details are required (at least one premium entry)
- Sum assured must be greater than zero
- Benefits payable configuration is required

### Protection Type Rules
- **Life Cover**: Must specify term, sum assured, premium structure, payment basis, and untilAge
- **Critical Illness Cover**: Must specify premium structure, amount, term, and untilAge
- **Income Cover**: Must specify premium structure, monthly amount, term, and untilAge
- **Expense Cover**: Must specify premium structure, monthly amount, term, and untilAge
- **Severity Cover**: At least one of PTD or severity-based cover must be specified

### Premium Rules
- Premium amount must be greater than zero
- Premium frequency must be valid (Single, Monthly, Quarterly, etc.)
- Premium start date cannot be in the future (more than 30 days)
- If premium stop date is specified, it must be after start date
- Escalation percentage must be between 0 and 100

### Term and Age Rules
- Cover term must be valid ISO-8601 duration (e.g., P25Y for 25 years)
- Until age must be between 18 and 100
- Until age must be greater than current owner age

### Benefits Payable Rules
- Benefit frequency must match cover type (Single for lump sum, Monthly for income)
- Deferred period must be valid ISO-8601 duration (P[n]D)
- Deferred period typically ranges from 0 to 365 days for income protection
- Qualification period must be valid ISO-8601 duration
- If back-to-day-one is true, qualification period must be 30 or 60 days
- If back-to-day-one is false, qualification period must be 30, 60, 90, or 180 days

### Trust Rules
- If inTrust is true, inTrustToWhom should be specified (max 250 characters)

### Commission Rules
- Commission percentage must be between 0 and 100
- Commission type must be valid (Indemnity, NonIndemnity, etc.)
- Either percentage or amount should be specified (or both)

### Co-Ownership Rules
- If multiple owners, owner2PercentOfSumAssured can specify split (0-100%)
- Sum of ownership percentages should equal 100%

---

## UK Protection Regulations

### FCA ICOBS (Insurance Conduct of Business)
- **ICOBS 2.2** - Communications with customers must be clear, fair and not misleading
- **ICOBS 5.1** - Demands and needs assessment required before selling protection
- **ICOBS 6.1** - Product information must be provided before contract conclusion
- **ICOBS 6.1.5** - Policy summary must highlight key features, benefits, exclusions, and costs

### IDD (Insurance Distribution Directive)
- **Article 20** - Demands and needs test required
- **Article 29** - Product oversight and governance requirements
- **Article 30** - Customer best interest rule

### Consumer Duty (FCA)
- **Outcome 1** - Fair value assessment (price vs. benefits)
- **Outcome 2** - Products and services that meet customer needs
- **Outcome 3** - Consumer understanding (clear communications)
- **Outcome 4** - Consumer support (throughout product lifecycle)

### Protection-Specific Requirements

#### Underwriting and Ratings
- Premium ratings must be justified and disclosed
- Medical underwriting must comply with data protection regulations
- Occupational loadings must be risk-based and proportionate

#### Policy Terms
- Exclusions must be clearly stated and reasonable
- Waiting periods must be disclosed upfront
- Benefit limitations must be transparent

#### Indexation and Escalation
- RPI/CPI indexation must use official indices
- Fixed percentage escalation must be clearly stated
- Level/non-indexed options must be available

#### Trust Arrangements
- Trust deeds must comply with trust law
- Beneficiaries must be clearly identified
- Tax implications must be explained

#### Income Protection Specific
- Deferred periods typically: 1, 3, 6, 12, or 24 months
- Benefit periods typically: 12, 24, 60 months, or until retirement
- Own occupation vs any occupation definitions must be clear
- Proportionate benefits must be explained

#### Commission Disclosure
- Initial commission rates must be disclosed
- Ongoing/renewal commission must be disclosed
- Clawback terms (initial earnings period) must be explained

---

## Integration Points

### Related APIs
- **Client API** - Owner references
- **Provider API** - Insurance provider details
- **Adviser API** - Selling adviser information
- **Plan Types API** - Protection type reference data
- **Life Cycles API** - Life cycle stage reference data

### Downstream Systems
- **Commission System** - Commission tracking and payments
- **Document Management** - Policy documents and trust deeds
- **Regulatory Reporting** - FCA regulatory returns
- **CRM System** - Customer relationship management

---

## Performance Considerations

### Caching Strategy
- Protection type reference data: 24 hours
- Provider reference data: 12 hours
- Life cycle reference data: 24 hours

### Query Optimization
- Index on: factfindId, protectionType, provider, owners
- Consider pagination for large protection lists
- Use filtering to reduce payload size

### Payload Size
- Average protection: ~3-5 KB
- Protection with full multi-cover: ~8-12 KB
- List view (summary): ~1-2 KB per item

---

## Error Scenarios

### Common Validation Errors
- **400 Bad Request** - Invalid protection type, invalid term format, invalid premium structure
- **404 Not Found** - Protection ID not found, FactFind not found
- **409 Conflict** - Concurrency conflict (stale concurrencyId)
- **422 Unprocessable Entity** - Business rule violation (e.g., term exceeds maximum age)

### Authorization Errors
- **401 Unauthorized** - Missing or invalid bearer token
- **403 Forbidden** - Insufficient scope (requires protections:write or protections:delete)

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | 2026-02-25 | Moved from Arrangements domain to Plans domain. Complete contract schema with all cover types. |
| 1.0 | 2025-01-15 | Initial version under Arrangements domain |

---

**Document Owner:** API Design Team
**Last Reviewed:** 2026-02-25
**Next Review:** 2026-05-25
