# Control Options API Design

**Version:** 2.0
**Date:** 2026-03-05
**Status:** Current

## Table of Contents

1. [Introduction](#1-introduction)
2. [Business Context](#2-business-context)
3. [API Overview](#3-api-overview)
4. [Resource Model](#4-resource-model)
5. [API Operations](#5-api-operations)
6. [Request/Response Specifications](#6-requestresponse-specifications)
7. [Data Model](#7-data-model)
8. [Business Rules](#8-business-rules)
9. [Error Handling](#9-error-handling)
10. [Security](#10-security)
11. [Performance](#11-performance)
12. [Testing](#12-testing)
13. [References](#13-references)
14. [Appendices](#14-appendices)

---

## 1. Introduction

### 1.1 Purpose

The Control Options API provides management of high-level control flags that determine which sections of the FactFind are relevant to a client. These control options enable conditional logic in the data-gathering process, showing or hiding sections based on client circumstances.

### 1.2 Scope

This API covers:
- Control Options singleton per FactFind
- Section-based updates for different financial areas
- Boolean flags for presence of financial products
- Liability reduction planning options
- Section gating logic for efficient data collection

**Out of Scope:**
- Detailed financial product data (covered by specific entity APIs)
- Product recommendations (handled by advice systems)
- Workflow and progress tracking (handled by separate systems)

### 1.3 Conventions

- **Singleton Resource**: One control options record per FactFind
- **Section-Based Updates**: Six separate PUT endpoints for updating each area
- **Summary Endpoint**: Single GET endpoint returns all sections
- **All Fields Boolean**: Most fields are simple yes/no flags
- **Full Response**: All PUT operations return complete ControlOptions object

---

## 2. Business Context

### 2.1 Business Requirements

Control Options are essential for:
1. **Efficient Data Gathering**: Skip irrelevant sections based on client circumstances
2. **User Experience**: Show only applicable questions and forms
3. **Process Optimization**: Focus on client's actual financial situation
4. **Conditional Logic**: Enable/disable sections dynamically
5. **Progress Tracking**: Understand which areas need to be completed
6. **Adviser Efficiency**: Reduce time spent on non-applicable areas

### 2.2 Use Cases

**UC-CO-01: Client Has No Investments**
- Adviser asks if client has cash savings or investments
- Client responds: No
- Set `investments.hasCash` and `investments.hasInvestments` to false
- System hides investments section from FactFind
- Adviser proceeds to next relevant area

**UC-CO-02: Client Has Mortgages But No Equity Release**
- Client has residential mortgage
- Client does not have equity release products
- Set `mortgages.hasMortgages` to true
- Set `mortgages.hasEquityRelease` to false
- System shows mortgage section but hides equity release questions

**UC-CO-03: Pension Types Identification**
- Client has employer pension schemes and personal pensions
- Client does not have final salary or annuities
- Set appropriate pension flags
- System shows relevant pension sections only
- Adviser can focus on applicable pension types

**UC-CO-04: Liability Reduction Planning**
- Client has liabilities (debts)
- Client does not plan to reduce liabilities
- Reason: Retaining control of capital for flexibility
- Document reason in `liabilities.reductionOfLiabilities`
- Adviser understands debt strategy

**UC-CO-05: Protection Products Present**
- Client has life insurance, critical illness, or income protection
- Set `protections.hasProtection` to true
- System enables protection section for detailed capture
- Adviser gathers policy details

**UC-CO-06: Comprehensive Portfolio Client**
- Client has assets, liabilities, investments, pensions, mortgages, and protection
- All flags set to true
- Full FactFind data gathering required
- Complete financial planning approach

### 2.3 Constraints

- Singleton pattern: one control options record per FactFind
- Section-based updates: six separate PUT endpoints
- Read-only FactFind reference
- All PUT operations return full contract

---

## 3. API Overview

### 3.1 Resource Model

```
ControlOptions (singleton per FactFind)
├── href
├── factfind (reference, read-only)
├── investments
│   ├── hasCash
│   └── hasInvestments
├── pensions
│   ├── hasEmployerPensionSchemes
│   ├── hasFinalSalary
│   ├── hasMoneyPurchases
│   ├── hasPersonalPensions
│   └── hasAnnuities
├── mortgages
│   ├── hasMortgages
│   └── hasEquityRelease
├── protections
│   └── hasProtection
├── assets
│   └── hasAssets
└── liabilities
    ├── hasLiabilities
    └── reductionOfLiabilities
        ├── isExpected
        ├── nonReductionReason (enum)
        └── details
```

### 3.2 Resource Characteristics

| Characteristic | Value |
|---|---|
| Resource Type | Singleton with section-based updates |
| Mutability | Fully mutable via PUT operations |
| Lifecycle | Created on first PUT, persists with FactFind |
| Versioning | Implicit via timestamps |
| Parent Resource | FactFind |

---

## 4. Resource Model

### 4.1 Resource Structure

**Control Options Singleton:**
- One record per FactFind
- Six main sections: investments, pensions, mortgages, protections, assets, liabilities
- GET returns all sections combined
- PUT endpoints update individual sections
- All PUT operations return full ControlOptions object

**Sections:**
- **Investments**: Cash savings and investment products
- **Pensions**: All pension types (employer, final salary, personal, annuities)
- **Mortgages**: Residential mortgages and equity release
- **Protections**: Life insurance, critical illness, income protection
- **Assets**: Property, vehicles, valuables, etc.
- **Liabilities**: Debts, loans, credit cards with reduction planning

### 4.2 Resource Relationships

```
FactFind (1) ──→ (1) ControlOptions
FactFind (1) ──→ (N) Investment [if investments flags true]
FactFind (1) ──→ (N) Pension [if pension flags true]
FactFind (1) ──→ (N) Mortgage [if mortgage flags true]
FactFind (1) ──→ (N) PersonalProtection [if protection flag true]
FactFind (1) ──→ (N) Asset [if assets flag true]
FactFind (1) ──→ (N) Liability [if liabilities flag true]
```

### 4.3 Resource Lifecycle

**Control Options Record:**
1. **Not Exists**: FactFind has no control options (GET returns 404 or empty structure)
2. **Created**: First PUT to any section creates the singleton
3. **Partially Complete**: Some sections set, others default/unset
4. **Complete**: All relevant sections set
5. **Updated**: Subsequent PUTs modify existing sections
6. **Persists**: Remains throughout FactFind lifecycle

---

## 5. API Operations

### 5.1 Operation Summary

| Operation | Method | Endpoint | Description |
|---|---|---|---|
| Get Control Options | GET | `/v2/factfinds/{id}/controloptions` | Retrieve complete control options |
| Update Assets | PUT | `/v2/factfinds/{id}/controloptions/assets` | Update assets section |
| Update Liabilities | PUT | `/v2/factfinds/{id}/controloptions/liabilities` | Update liabilities section |
| Update Investments | PUT | `/v2/factfinds/{id}/controloptions/investments` | Update investments section |
| Update Pensions | PUT | `/v2/factfinds/{id}/controloptions/pensions` | Update pensions section |
| Update Protections | PUT | `/v2/factfinds/{id}/controloptions/protections` | Update protections section |
| Update Mortgages | PUT | `/v2/factfinds/{id}/controloptions/mortgages` | Update mortgages section |

### 5.2 Get Control Options

**Endpoint:** `GET /v2/factfinds/{id}/controloptions`

**Description:** Retrieves the complete control options singleton.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Response Codes:**
- `200 OK`: Control options found
- `404 Not Found`: Control options not created yet
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** ControlOptions object (see section 6.1)

### 5.3 Update Assets

**Endpoint:** `PUT /v2/factfinds/{id}/controloptions/assets`

**Description:** Creates or updates the assets section.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Request Body:** Assets object

**Response Codes:**
- `200 OK`: Section updated
- `201 Created`: Section created (first PUT)
- `400 Bad Request`: Invalid data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** Complete ControlOptions object

### 5.4 Update Liabilities

**Endpoint:** `PUT /v2/factfinds/{id}/controloptions/liabilities`

**Description:** Creates or updates the liabilities section.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Request Body:** Liabilities object

**Response Codes:**
- `200 OK`: Section updated
- `201 Created`: Section created (first PUT)
- `400 Bad Request`: Invalid data (invalid enum value)
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** Complete ControlOptions object

### 5.5 Update Investments

**Endpoint:** `PUT /v2/factfinds/{id}/controloptions/investments`

**Description:** Creates or updates the investments section.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Request Body:** Investments object

**Response Codes:**
- `200 OK`: Section updated
- `201 Created`: Section created (first PUT)
- `400 Bad Request`: Invalid data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** Complete ControlOptions object

### 5.6 Update Pensions

**Endpoint:** `PUT /v2/factfinds/{id}/controloptions/pensions`

**Description:** Creates or updates the pensions section.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Request Body:** Pensions object

**Response Codes:**
- `200 OK`: Section updated
- `201 Created`: Section created (first PUT)
- `400 Bad Request`: Invalid data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** Complete ControlOptions object

### 5.7 Update Protections

**Endpoint:** `PUT /v2/factfinds/{id}/controloptions/protections`

**Description:** Creates or updates the protections section.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Request Body:** Protections object

**Response Codes:**
- `200 OK`: Section updated
- `201 Created`: Section created (first PUT)
- `400 Bad Request`: Invalid data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** Complete ControlOptions object

### 5.8 Update Mortgages

**Endpoint:** `PUT /v2/factfinds/{id}/controloptions/mortgages`

**Description:** Creates or updates the mortgages section.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Request Body:** Mortgages object

**Response Codes:**
- `200 OK`: Section updated
- `201 Created`: Section created (first PUT)
- `400 Bad Request`: Invalid data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** Complete ControlOptions object

---

## 6. Request/Response Specifications

### 6.1 Get Control Options Response

```json
{
  "href": "/v2/factfinds/123/controloptions",
  "factfind": {
    "id": 123,
    "href": "/v2/factfinds/123"
  },
  "investments": {
    "hasCash": true,
    "hasInvestments": true
  },
  "pensions": {
    "hasEmployerPensionSchemes": true,
    "hasFinalSalary": true,
    "hasMoneyPurchases": true,
    "hasPersonalPensions": true,
    "hasAnnuities": true
  },
  "mortgages": {
    "hasMortgages": true,
    "hasEquityRelease": true
  },
  "protections": {
    "hasProtection": true
  },
  "assets": {
    "hasAssets": true
  },
  "liabilities": {
    "hasLiabilities": true,
    "reductionOfLiabilities": {
      "isExpected": true,
      "nonReductionReason": "RetainControlOfCapital",
      "details": "Client prefers to maintain liquidity for flexibility and investment opportunities."
    }
  }
}
```

### 6.2 Update Assets Request/Response

**Request:**
```json
{
  "hasAssets": true
}
```

**Response:** 200 OK
Returns complete ControlOptions object (same structure as 6.1).

### 6.3 Update Liabilities Request/Response

**Request:**
```json
{
  "hasLiabilities": true,
  "reductionOfLiabilities": {
    "isExpected": false,
    "nonReductionReason": "RetainControlOfCapital",
    "details": "Client prefers to maintain liquidity for flexibility and investment opportunities."
  }
}
```

**Response:** 200 OK
Returns complete ControlOptions object.

### 6.4 Update Investments Request/Response

**Request:**
```json
{
  "hasCash": true,
  "hasInvestments": true
}
```

**Response:** 200 OK
Returns complete ControlOptions object.

### 6.5 Update Pensions Request/Response

**Request:**
```json
{
  "hasEmployerPensionSchemes": true,
  "hasFinalSalary": false,
  "hasMoneyPurchases": true,
  "hasPersonalPensions": true,
  "hasAnnuities": false
}
```

**Response:** 200 OK
Returns complete ControlOptions object.

### 6.6 Update Protections Request/Response

**Request:**
```json
{
  "hasProtection": true
}
```

**Response:** 200 OK
Returns complete ControlOptions object.

### 6.7 Update Mortgages Request/Response

**Request:**
```json
{
  "hasMortgages": true,
  "hasEquityRelease": false
}
```

**Response:** 200 OK
Returns complete ControlOptions object.

---

## 7. Data Model

### 7.1 ControlOptions Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| href | string | Yes | Yes | API resource link |
| factfind | FactFindReference | Yes | Yes | FactFind reference |
| investments | Investments | No | No | Investments section |
| pensions | Pensions | No | No | Pensions section |
| mortgages | Mortgages | No | No | Mortgages section |
| protections | Protections | No | No | Protections section |
| assets | Assets | No | No | Assets section |
| liabilities | Liabilities | No | No | Liabilities section |

### 7.2 FactFindReference Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| id | integer | Yes | Yes | FactFind identifier |
| href | string | Yes | Yes | Link to FactFind resource |

### 7.3 Investments Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| hasCash | boolean | No | No | Has cash savings or accounts |
| hasInvestments | boolean | No | No | Has investment products (ISAs, bonds, stocks, funds) |

### 7.4 Pensions Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| hasEmployerPensionSchemes | boolean | No | No | Has employer pension schemes |
| hasFinalSalary | boolean | No | No | Has final salary (defined benefit) pensions |
| hasMoneyPurchases | boolean | No | No | Has money purchase (defined contribution) pensions |
| hasPersonalPensions | boolean | No | No | Has personal pensions (SIPPs, stakeholder) |
| hasAnnuities | boolean | No | No | Has annuity products |

### 7.5 Mortgages Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| hasMortgages | boolean | No | No | Has residential mortgages |
| hasEquityRelease | boolean | No | No | Has equity release products (lifetime mortgage, home reversion) |

### 7.6 Protections Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| hasProtection | boolean | No | No | Has protection products (life, critical illness, income protection) |

### 7.7 Assets Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| hasAssets | boolean | No | No | Has assets (property, vehicles, valuables, collectibles) |

### 7.8 Liabilities Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| hasLiabilities | boolean | No | No | Has liabilities (loans, credit cards, overdrafts) |
| reductionOfLiabilities | ReductionOfLiabilities | No | No | Liability reduction planning |

### 7.9 ReductionOfLiabilities Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| isExpected | boolean | No | No | Whether reduction of liabilities is expected/planned |
| nonReductionReason | enum | No | No | Reason for not reducing liabilities (see NonReductionReason enum) |
| details | string | No | No | Additional details about liability strategy (max 1000 chars) |

### 7.10 Enumerations

**NonReductionReason:**
- `RetainControlOfCapital` - Prefer to retain control of capital for flexibility
- `PensionPlanning` - Using liabilities as part of pension planning strategy
- `Other` - Other reason (explain in details field)

---

## 8. Business Rules

### 8.1 Singleton Resource Rules

**BR-CO-01: One Record Per FactFind**
- Only one control options record exists per FactFind
- First PUT to any section creates the singleton
- Subsequent PUTs update individual sections
- GET returns all sections combined

**BR-CO-02: Section Independence**
- Each section can be updated independently
- Updating one section does not affect others
- Partial completion is permitted

**BR-CO-03: Full Response on PUT**
- All PUT operations return complete ControlOptions object
- Enables UI to refresh entire control options state
- Single source of truth after each update

### 8.2 Field Validation Rules

**BR-CO-04: Boolean Field Defaults**
- Boolean fields default to null/unset
- Client can explicitly set true or false
- Null indicates not yet determined

**BR-CO-05: Enum Value Validation**
- nonReductionReason must be one of: RetainControlOfCapital, PensionPlanning, Other
- Returns 400 Bad Request if invalid enum value
- Case-sensitive enum matching

**BR-CO-06: Details Field Length**
- liabilities.reductionOfLiabilities.details maximum 1000 characters
- Returns 400 Bad Request if exceeded

### 8.3 Business Logic Rules

**BR-CO-07: Conditional Section Display**
- If flag is false, system should hide corresponding section
- If flag is true, system should show corresponding section for data entry
- Null/unset flags: section visibility at system's discretion (typically shown until explicitly set false)

**BR-CO-08: Liability Reduction Logic**
- If `hasLiabilities` is false, `reductionOfLiabilities` is not applicable
- If `isExpected` is false, `nonReductionReason` should be provided
- If `nonReductionReason` is "Other", `details` should explain reason

**BR-CO-09: Pension Type Granularity**
- Multiple pension flags can be true simultaneously
- Enables precise section gating for different pension types
- Example: Show employer schemes section but hide annuities section

**BR-CO-10: Investment Type Distinction**
- `hasCash` covers bank accounts, savings accounts, cash ISAs
- `hasInvestments` covers stocks, shares, investment ISAs, bonds, funds
- Both can be true (client has both cash and investments)
- Both can be false (client has neither)

### 8.4 Data Integrity Rules

**BR-CO-11: FactFind Reference Immutable**
- FactFind reference is read-only
- Cannot be changed after creation
- Populated automatically from URL path parameter

**BR-CO-12: Section Object Immutability**
- When updating a section, entire section object is replaced
- Cannot partially update section (must provide all fields)
- Ensures consistency and avoids partial state issues

---

## 9. Error Handling

### 9.1 Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid non-reduction reason value",
    "details": [
      {
        "field": "liabilities.reductionOfLiabilities.nonReductionReason",
        "issue": "Value must be 'RetainControlOfCapital', 'PensionPlanning', or 'Other'",
        "value": "TaxPlanning"
      }
    ]
  }
}
```

### 9.2 Common Error Codes

| Code | HTTP Status | Description |
|---|---|---|
| CONTROL_OPTIONS_NOT_FOUND | 404 | Control options not created yet |
| VALIDATION_ERROR | 400 | Request data validation failed |
| INVALID_ENUM_VALUE | 400 | Enum field has invalid value |
| TEXT_TOO_LONG | 400 | Text field exceeds maximum length |
| UNAUTHORIZED | 401 | Authentication required |
| FORBIDDEN | 403 | Insufficient permissions |

### 9.3 Validation Error Examples

**Invalid Enum Value:**
```json
{
  "error": {
    "code": "INVALID_ENUM_VALUE",
    "message": "Invalid value for non-reduction reason",
    "details": [
      {
        "field": "liabilities.reductionOfLiabilities.nonReductionReason",
        "issue": "Value must be 'RetainControlOfCapital', 'PensionPlanning', or 'Other'",
        "value": "InvestmentStrategy",
        "allowedValues": ["RetainControlOfCapital", "PensionPlanning", "Other"]
      }
    ]
  }
}
```

**Text Field Too Long:**
```json
{
  "error": {
    "code": "TEXT_TOO_LONG",
    "message": "Field exceeds maximum length",
    "details": [
      {
        "field": "liabilities.reductionOfLiabilities.details",
        "issue": "Maximum 1000 characters allowed",
        "length": 1247
      }
    ]
  }
}
```

---

## 10. Security

### 10.1 Authentication

- All endpoints require valid authentication token
- Token must be included in `Authorization` header
- Format: `Authorization: Bearer {token}`
- Expired tokens return 401 Unauthorized

### 10.2 Authorization

**Resource-Level Permissions:**
- User must have access to the FactFind
- User must have permission to view/edit FactFind data
- Adviser can only access control options for their own FactFinds
- Admin users can access all control options within their organization

**Operation-Level Permissions:**
- `GET`: Requires "View FactFind Data" permission
- `PUT`: Requires "Edit FactFind Data" permission

### 10.3 Data Protection

**Sensitive Information:**
- Control options reveal client's financial situation at high level
- Indicates presence/absence of financial products
- Liability reduction strategy may indicate financial stress
- Access logs maintained for audit purposes

**GDPR Compliance:**
- Control options data is personal data under GDPR
- Client consent required for processing
- Right to access: clients can request their control options data
- Right to erasure: clients can request deletion (subject to retention rules)

---

## 11. Performance

### 11.1 Response Time Targets

| Operation | Target | Maximum |
|---|---|---|
| GET Control Options | < 200ms | 500ms |
| PUT Section | < 300ms | 1000ms |

### 11.2 Caching

**Control Options Record:**
- Cache-Control: private, max-age=300 (5 minutes)
- ETag support for conditional requests
- Last-Modified header included

### 11.3 Rate Limiting

- 100 requests per minute per user
- 1000 requests per hour per organization
- Rate limit headers included in responses

---

## 12. Testing

### 12.1 Test Scenarios

**TS-CO-01: Create Control Options via Assets Update**
1. FactFind has no control options
2. PUT to assets section
3. Verify 201 Created response
4. GET control options returns assets section populated
5. Verify other sections null/empty

**TS-CO-02: Update Multiple Sections**
1. PUT to investments section
2. PUT to pensions section
3. PUT to mortgages section
4. GET control options shows all three sections
5. Verify sections independent

**TS-CO-03: Client Has No Investments**
1. PUT investments with both flags false
2. Verify flags saved correctly
3. System hides investments section
4. Adviser proceeds to next area

**TS-CO-04: Complex Pension Portfolio**
1. PUT pensions with mixed flags (some true, some false)
2. Verify specific pension types identified
3. System shows relevant pension sections only

**TS-CO-05: Liability Reduction Planning**
1. PUT liabilities with hasLiabilities=true
2. Set isExpected=false
3. Set nonReductionReason="RetainControlOfCapital"
4. Provide details explaining strategy
5. Verify all fields saved

**TS-CO-06: Validate Enum Values**
1. Attempt PUT with invalid nonReductionReason
2. Verify 400 Bad Request
3. Verify error indicates valid enum values

**TS-CO-07: Validate Text Length**
1. Attempt PUT with 1500-character details
2. Verify 400 Bad Request
3. Verify error indicates maximum length

**TS-CO-08: Full Response on PUT**
1. Control options has multiple sections populated
2. PUT to update one section
3. Verify response includes all sections
4. Verify only updated section changed

**TS-CO-09: Section Independence**
1. Control options exists with investments populated
2. PUT to update pensions section
3. Verify investments section unchanged
4. Verify pensions section updated

**TS-CO-10: FactFind Reference Immutable**
1. Control options exists for FactFind 123
2. GET confirms factfind.id = 123
3. Verify href matches
4. FactFind reference cannot be changed

### 12.2 Sample Test Data

**All Sections True:**
```json
{
  "investments": {
    "hasCash": true,
    "hasInvestments": true
  },
  "pensions": {
    "hasEmployerPensionSchemes": true,
    "hasFinalSalary": true,
    "hasMoneyPurchases": true,
    "hasPersonalPensions": true,
    "hasAnnuities": true
  },
  "mortgages": {
    "hasMortgages": true,
    "hasEquityRelease": true
  },
  "protections": {
    "hasProtection": true
  },
  "assets": {
    "hasAssets": true
  },
  "liabilities": {
    "hasLiabilities": true,
    "reductionOfLiabilities": {
      "isExpected": true,
      "nonReductionReason": null,
      "details": null
    }
  }
}
```

**Simple Financial Situation:**
```json
{
  "investments": {
    "hasCash": true,
    "hasInvestments": false
  },
  "pensions": {
    "hasEmployerPensionSchemes": true,
    "hasFinalSalary": false,
    "hasMoneyPurchases": false,
    "hasPersonalPensions": false,
    "hasAnnuities": false
  },
  "mortgages": {
    "hasMortgages": true,
    "hasEquityRelease": false
  },
  "protections": {
    "hasProtection": false
  },
  "assets": {
    "hasAssets": false
  },
  "liabilities": {
    "hasLiabilities": true,
    "reductionOfLiabilities": {
      "isExpected": true,
      "nonReductionReason": null,
      "details": "Planning to pay off mortgage in 5 years"
    }
  }
}
```

**No Liabilities Reduction:**
```json
{
  "liabilities": {
    "hasLiabilities": true,
    "reductionOfLiabilities": {
      "isExpected": false,
      "nonReductionReason": "RetainControlOfCapital",
      "details": "Client prefers to maintain liquidity. Low-interest mortgage provides leverage for investment portfolio."
    }
  }
}
```

---

## 13. References

### 13.1 Related APIs

- [FactFind API](./FactFind-API-Design.md) - Parent container
- [Investment API](./Investment-API-Design.md) - Detailed investment data
- [Pension APIs](./PersonalPension-API-Design.md) - Pension product details
- [Mortgage API](./Mortgage-API-Design.md) - Mortgage details
- [PersonalProtection API](./PersonalProtection-API-Design.md) - Protection policies
- [Asset API](./Asset-API-Design.md) - Asset details
- [Liability API](./Liability-API-Design.md) - Liability details

### 13.2 External Standards

- **REST API Design**: Standard HTTP methods and status codes
- **GDPR**: Data protection and privacy requirements

### 13.3 Business Regulations

- **FCA Handbook**: Requirements for comprehensive data gathering
- **Consumer Duty**: Ensuring efficient and appropriate advice process

---

## 14. Appendices

### 14.1 Section Gating Logic

**Purpose of Control Options:**
- Improve user experience by showing only relevant sections
- Reduce data entry burden on advisers
- Focus on client's actual financial situation
- Enable progressive disclosure of complexity

**Implementation Pattern:**
- Ask high-level questions first ("Do you have investments?")
- Based on answers, show/hide detailed sections
- Example: If hasCash=false and hasInvestments=false, hide entire investments section

**Benefits:**
- Faster FactFind completion
- Reduced cognitive load
- Better client experience (fewer irrelevant questions)
- More focused advice conversations

### 14.2 Liability Reduction Strategies

**When Clients Plan to Reduce Liabilities (isExpected=true):**
- Standard debt reduction approach
- Pay down high-interest debt first
- Mortgage overpayments
- Clear credit cards and loans
- Build debt-free lifestyle

**When Clients Do Not Plan to Reduce Liabilities (isExpected=false):**

**RetainControlOfCapital:**
- Keep liabilities at current level
- Prefer liquidity and investment flexibility
- Low-interest debt provides leverage
- Can respond to opportunities
- Emergency fund provides security

**PensionPlanning:**
- Using mortgage interest for tax relief (if applicable)
- Balancing debt reduction vs pension contributions
- Maximizing pension tax relief instead of debt repayment
- Viewing mortgage as forced saving

**Other:**
- Business investment priorities
- Education funding
- Property portfolio growth
- Other strategic reasons (document in details)

### 14.3 Pension Type Definitions

**Employer Pension Schemes:**
- Workplace pensions provided by employer
- Auto-enrolment pensions
- Group personal pensions
- Group stakeholder pensions

**Final Salary (Defined Benefit):**
- Guaranteed income based on salary and service
- Index-linked increases
- Typically public sector or older private sector schemes
- No investment risk for member

**Money Purchase (Defined Contribution):**
- Investment-based pensions
- Value depends on contributions and investment performance
- Member bears investment risk
- Most modern workplace pensions

**Personal Pensions:**
- Individual arrangements outside employment
- SIPPs (Self-Invested Personal Pensions)
- Stakeholder pensions
- Old-style personal pensions

**Annuities:**
- Guaranteed income for life
- Purchased with pension savings
- Fixed or escalating payments
- Provides certainty in retirement

### 14.4 Glossary

| Term | Definition |
|---|---|
| Control Options | High-level flags determining which FactFind sections are relevant |
| Section Gating | Showing/hiding sections based on control options |
| Cash | Bank accounts, savings accounts, cash ISAs |
| Investments | Stocks, shares, investment ISAs, bonds, funds |
| Final Salary | Defined benefit pension with guaranteed income |
| Money Purchase | Defined contribution pension with investment risk |
| Equity Release | Lifetime mortgage or home reversion plan |
| PET | Potentially Exempt Transfer (see Estate Planning API) |

### 14.5 Change History

| Version | Date | Changes | Author |
|---|---|---|---|
| 1.0 | 2025-02-10 | Initial API design | API Team |
| 2.0 | 2026-03-05 | Renamed from Control Questions to Control Options, simplified structure | API Team |

---

**Document End**
