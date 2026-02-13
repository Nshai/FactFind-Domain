# V3 API Contracts: Goals/Objectives and Risk Assessment

**Document Version:** 1.0
**Date:** 2026-02-12
**Status:** DESIGN SPECIFICATION
**Microservice:** Requirements (Goals & Risk)
**API Version:** v3

---

## Executive Summary

### Purpose

This document defines the V3 API contracts for Goals/Objectives and Risk Assessment functionality, building on the existing Requirements microservice architecture. The V3 API modernizes the user-facing terminology (objectives → goals), uses current patterns (RiskProfileNamedRef), and provides enhanced functionality while maintaining backward compatibility.

### Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| **Rename `/objectives` → `/goals`** | More user-friendly, aligns with customer-facing terminology |
| **Use `RiskProfileNamedRef`** | Modern pattern, replaces obsolete `RiskProfile` |
| **Maintain event-driven architecture** | Proven pattern from Requirements microservice |
| **Polymorphic goal types** | Leverage existing discriminator pattern (7 types) |
| **Single contract principle** | Each request/response is self-contained |
| **Reference type naming** | Suffix with `Ref` for consistency |
| **Value type naming** | Suffix with `Value` for clarity |

### Architecture Context

**Based on Requirements Microservice:**
- Modern event-driven microservice (Pattern #3 from API-Architecture-Patterns.md)
- Separate database (Requirements DB)
- Full CRUD operations with rich querying
- 100% coverage confirmed (see Requirements-Goals-API-Coverage.md)

### V2 → V3 Migration

| V2 API | V3 API | Change Type |
|--------|--------|-------------|
| `/v2/clients/{clientId}/objectives` | `/v3/clients/{clientId}/goals` | Route rename |
| `RiskProfile` (obsolete) | `RiskProfileNamedRef` | Modern pattern |
| `discriminator` field | `type` field | User-friendly naming |
| Basic filtering | Enhanced filtering + search | Capability expansion |

---

## Table of Contents

1. [API Overview](#1-api-overview)
2. [Core Domain Model](#2-core-domain-model)
3. [Goals API Contracts](#3-goals-api-contracts)
4. [Risk Assessment API Contracts](#4-risk-assessment-api-contracts)
5. [Supplementary APIs](#5-supplementary-apis)
6. [Event Schemas](#6-event-schemas)
7. [OpenAPI 3.1 Specification](#7-openapi-31-specification)
8. [Migration Guide](#8-migration-guide)

---

## 1. API Overview

### 1.1 Service Endpoints

**Base URL:** `https://api.intelliflo.com/requirements`

**API Families:**

```
Goals & Objectives API
├── /v3/clients/{clientId}/goals
├── /v3/leads/{leadId}/goals
└── /v3/goals/{goalId}/allocations

Risk Assessment API
├── /v3/clients/{clientId}/risk-profiles
├── /v3/clients/{clientId}/atrs
└── /v3/risk-questionnaires

Supplementary APIs
├── /v3/clients/{clientId}/dependants
├── /v3/clients/{clientId}/needs-priorities
└── /v3/reference-data/goal-categories
```

### 1.2 Authentication & Authorization

**Authentication:** OAuth 2.0 Bearer Token

**Required Scopes:**
- `requirements:read` - Read goals, risk profiles, dependants
- `requirements:write` - Create/update/delete goals and risk assessments
- `client-data:read` - Access client-specific data

**Authorization Policy:** `Policies.Requirements`

### 1.3 Standard Headers

**Request Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
Accept: application/json
X-Tenant-Id: {tenantId}
X-Correlation-Id: {correlationId}
```

**Response Headers:**
```
Content-Type: application/json
X-Request-Id: {requestId}
X-RateLimit-Remaining: {count}
ETag: "{version}"
```

### 1.4 Common Patterns

**Pagination:**
```
?page=1&pageSize=100
```
- Default page size: 100
- Maximum page size: 500
- Returns `X-Total-Count` header

**Filtering:**
```
?filter=type eq 'investment' and status eq 'active'
```
- OData-style filter syntax
- Supported operators: eq, ne, in, gt, lt, startswith

**Sorting:**
```
?orderBy=createdOn desc,category asc
```

**Field Selection:**
```
?fields=id,summary,targetAmount,status
```

**HATEOAS Links:**
All resources include hypermedia links in `_links` section.

---

## 2. Core Domain Model

### 2.1 Goal Types (Polymorphic Hierarchy)

**Base Type:** `Goal` (abstract)

**Concrete Types:**

```
Goal (base)
├── InvestmentGoal
├── RetirementGoal
├── ProtectionGoal
├── MortgageGoal
├── BudgetGoal
├── EstatePlanningGoal
└── EquityReleaseGoal
```

**Discriminator Mapping:**

| Type Value | Discriminator (DB) | Description |
|------------|-------------------|-------------|
| `investment` | InvestmentObjective | Investment savings goals |
| `retirement` | RetirementObjective | Retirement planning goals |
| `protection` | ProtectionObjective | Life insurance protection goals |
| `mortgage` | MortgageObjective | Mortgage/property purchase goals |
| `budget` | BudgetObjective | Budget planning goals |
| `estatePlanning` | EstatePlanningObjective | Estate planning goals |
| `equityRelease` | EquityReleaseObjective | Equity release goals |

### 2.2 Entity Relationships

```
Client
  ├── 1:N Goals
  │    ├── InvestmentGoal → RiskProfile
  │    ├── RetirementGoal → RiskProfile
  │    ├── ProtectionGoal
  │    └── MortgageGoal
  ├── 1:N Dependants
  ├── 1:1 NeedsPriorities
  └── 1:N RiskProfiles (per advice area)

Goal
  ├── N:M Opportunities (via OpportunityRef)
  ├── N:M Plans (via PlanRef)
  └── 1:N Allocations

RiskProfile
  ├── 1:1 ATR (Attitude to Risk assessment)
  ├── 1:1 ATRTemplate
  └── 1:1 InvestmentPreference (optional)
```

### 2.3 Core Value Objects

**CurrencyValue:**
```json
{
  "value": 100000.00,
  "currency": "GBP"
}
```

**FrequencyValue:**
```
Enum: monthly, annual, oneOff, quarterly
```

**TimeHorizonValue:**
```
Enum: shortTerm, mediumTerm, longTerm
```

**StatusValue:**
```
Enum: active, completed, onHold, cancelled
```

---

## 3. Goals API Contracts

### 3.1 Core Operations

#### 3.1.1 List Goals

**Endpoint:** `GET /v3/clients/{clientId}/goals`

**Description:** Retrieve all goals for a client with optional filtering, sorting, and pagination.

**Path Parameters:**
- `clientId` (integer, required) - Client identifier

**Query Parameters:**
- `page` (integer, optional, default: 1) - Page number
- `pageSize` (integer, optional, default: 100, max: 500) - Results per page
- `filter` (string, optional) - OData filter expression
- `orderBy` (string, optional) - Sort expression
- `fields` (string, optional) - Field selection (comma-separated)

**Filter Examples:**
```
# Investment goals only
?filter=type eq 'investment'

# Active goals with target amount > £50k
?filter=status eq 'active' and targetAmount/value gt 50000

# Multiple goal types
?filter=type in ('investment','retirement')

# By applicant
?filter=applicants/any(a: a/id eq 123)

# By category
?filter=category eq 'Savings'
```

**Request Example:**
```http
GET /v3/clients/456/goals?filter=type eq 'investment'&orderBy=createdOn desc HTTP/1.1
Host: api.intelliflo.com
Authorization: Bearer eyJhbGc...
Accept: application/json
X-Tenant-Id: 1
```

**Response 200 OK:**
```json
{
  "goals": [
    {
      "id": 123,
      "href": "/v3/clients/456/goals/123",
      "type": "investment",
      "category": "Savings",
      "summary": "Retirement nest egg",
      "details": "Build investment portfolio for retirement in 15 years",
      "status": "active",
      "timeHorizon": "longTerm",
      "applicants": [
        {
          "id": 456,
          "name": "John Smith",
          "isPrimary": true,
          "href": "/v3/clients/456"
        }
      ],
      "targetAmount": {
        "value": 500000.00,
        "currency": "GBP"
      },
      "targetDate": "2040-12-31",
      "frequency": "monthly",
      "term": 180,
      "hasInvestmentPreference": "yes",
      "riskProfile": {
        "id": 5,
        "name": "Balanced",
        "href": "/v3/risk-profiles/5"
      },
      "atr": {
        "id": 789,
        "href": "/v3/clients/456/atrs/789"
      },
      "investmentPreference": {
        "id": 101,
        "href": "/v3/clients/456/investment-preferences/101"
      },
      "linkedOpportunities": [
        {
          "id": 999,
          "href": "/v3/clients/456/opportunities/999"
        }
      ],
      "allocations": {
        "href": "/v3/goals/123/allocations"
      },
      "createdBy": {
        "id": 1,
        "name": "Jane Advisor"
      },
      "createdOn": "2024-01-15T10:30:00Z",
      "lastReviewedAt": "2025-06-01T14:20:00Z",
      "_links": {
        "self": { "href": "/v3/clients/456/goals/123" },
        "update": { "href": "/v3/clients/456/goals/123", "method": "PUT" },
        "delete": { "href": "/v3/clients/456/goals/123", "method": "DELETE" },
        "allocations": { "href": "/v3/goals/123/allocations" },
        "riskProfile": { "href": "/v3/risk-profiles/5" }
      }
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 100,
    "totalCount": 1,
    "totalPages": 1
  },
  "_links": {
    "self": { "href": "/v3/clients/456/goals?page=1&pageSize=100" },
    "create": { "href": "/v3/clients/456/goals", "method": "POST" }
  }
}
```

**Response Headers:**
```
Content-Type: application/json
X-Total-Count: 1
X-Request-Id: 7d3e4f5a-1234-5678-90ab-cdef12345678
```

---

#### 3.1.2 Get Single Goal

**Endpoint:** `GET /v3/clients/{clientId}/goals/{goalId}`

**Description:** Retrieve a specific goal by identifier.

**Path Parameters:**
- `clientId` (integer, required) - Client identifier
- `goalId` (integer, required) - Goal identifier

**Request Example:**
```http
GET /v3/clients/456/goals/123 HTTP/1.1
Host: api.intelliflo.com
Authorization: Bearer eyJhbGc...
Accept: application/json
```

**Response 200 OK:**
```json
{
  "id": 123,
  "href": "/v3/clients/456/goals/123",
  "type": "investment",
  "category": "Savings",
  "summary": "Retirement nest egg",
  "details": "Build investment portfolio for retirement in 15 years",
  "status": "active",
  "timeHorizon": "longTerm",
  "applicants": [
    {
      "id": 456,
      "name": "John Smith",
      "isPrimary": true,
      "href": "/v3/clients/456"
    }
  ],
  "targetAmount": {
    "value": 500000.00,
    "currency": "GBP"
  },
  "targetDate": "2040-12-31",
  "frequency": "monthly",
  "term": 180,
  "hasInvestmentPreference": "yes",
  "riskProfile": {
    "id": 5,
    "name": "Balanced",
    "href": "/v3/risk-profiles/5"
  },
  "atr": {
    "id": 789,
    "href": "/v3/clients/456/atrs/789"
  },
  "investmentPreference": {
    "id": 101,
    "href": "/v3/clients/456/investment-preferences/101"
  },
  "linkedOpportunities": [
    {
      "id": 999,
      "href": "/v3/clients/456/opportunities/999"
    }
  ],
  "plans": [
    {
      "id": 888,
      "name": "Vanguard SIPP",
      "href": "/v3/plans/888"
    }
  ],
  "allocations": {
    "href": "/v3/goals/123/allocations"
  },
  "properties": {
    "customField1": "value1",
    "customField2": "value2"
  },
  "createdBy": {
    "id": 1,
    "name": "Jane Advisor"
  },
  "createdOn": "2024-01-15T10:30:00Z",
  "lastReviewedAt": "2025-06-01T14:20:00Z",
  "_links": {
    "self": { "href": "/v3/clients/456/goals/123" },
    "update": { "href": "/v3/clients/456/goals/123", "method": "PUT" },
    "delete": { "href": "/v3/clients/456/goals/123", "method": "DELETE" },
    "allocations": { "href": "/v3/goals/123/allocations" },
    "linkOpportunity": {
      "href": "/v3/clients/456/goals/123/opportunities/{opportunityId}",
      "method": "POST",
      "templated": true
    }
  }
}
```

**Response 404 Not Found:**
```json
{
  "type": "https://api.intelliflo.com/problems/resource-not-found",
  "title": "Goal Not Found",
  "status": 404,
  "detail": "Goal with ID 123 not found for client 456",
  "instance": "/v3/clients/456/goals/123",
  "traceId": "00-7d3e4f5a12345678-90abcdef12345678-00"
}
```

---

#### 3.1.3 Create Goal

**Endpoint:** `POST /v3/clients/{clientId}/goals`

**Description:** Create a new goal for a client.

**Path Parameters:**
- `clientId` (integer, required) - Client identifier

**Request Body (Investment Goal Example):**
```json
{
  "type": "investment",
  "category": "Savings",
  "summary": "Retirement nest egg",
  "details": "Build investment portfolio for retirement in 15 years",
  "status": "active",
  "timeHorizon": "longTerm",
  "applicants": [
    {
      "id": 456,
      "isPrimary": true
    }
  ],
  "targetAmount": {
    "value": 500000.00,
    "currency": "GBP"
  },
  "targetDate": "2040-12-31",
  "frequency": "monthly",
  "term": 180,
  "hasInvestmentPreference": "yes",
  "investmentPreferences": "Ethical investments preferred",
  "riskProfile": {
    "id": 5
  },
  "atr": {
    "id": 789
  },
  "properties": {
    "customField1": "value1"
  }
}
```

**Request Body (Retirement Goal Example):**
```json
{
  "type": "retirement",
  "category": "Pension",
  "summary": "Comfortable retirement at 65",
  "details": "Target retirement income of £40k per year",
  "status": "active",
  "timeHorizon": "longTerm",
  "applicants": [
    {
      "id": 456,
      "isPrimary": true
    }
  ],
  "targetAge": 65,
  "term": 240,
  "lumpSum": {
    "amount": {
      "value": 100000.00,
      "currency": "GBP"
    },
    "type": "tfls"
  },
  "income": {
    "amount": {
      "value": 40000.00,
      "currency": "GBP"
    },
    "frequency": "annual",
    "inflationAdjusted": true
  },
  "riskProfile": {
    "id": 5
  },
  "atr": {
    "id": 789
  }
}
```

**Request Body (Protection Goal Example):**
```json
{
  "type": "protection",
  "category": "Life Cover",
  "summary": "Family protection",
  "details": "Protect family in case of death",
  "status": "active",
  "timeHorizon": "longTerm",
  "applicants": [
    {
      "id": 456,
      "isPrimary": true
    }
  ],
  "coverAmount": {
    "value": 500000.00,
    "currency": "GBP"
  },
  "startDate": "2026-03-01",
  "term": 300,
  "coverFrequency": "monthly",
  "isWholeOfLife": false
}
```

**Request Body (Mortgage Goal Example):**
```json
{
  "type": "mortgage",
  "category": "House Purchase",
  "summary": "First home purchase",
  "details": "Purchase first home in London",
  "status": "active",
  "timeHorizon": "shortTerm",
  "applicants": [
    {
      "id": 456,
      "isPrimary": true
    },
    {
      "id": 457,
      "isPrimary": false
    }
  ],
  "mortgageType": {
    "id": 1,
    "name": "Residential Mortgage"
  },
  "loan": {
    "value": 350000.00,
    "currency": "GBP"
  },
  "deposit": {
    "amount": {
      "value": 50000.00,
      "currency": "GBP"
    },
    "source": "savings"
  },
  "term": {
    "years": 25,
    "months": 300
  },
  "repaymentMethod": {
    "id": 1,
    "name": "Repayment"
  },
  "propertyValuation": {
    "value": 400000.00,
    "currency": "GBP"
  },
  "propertyAddress": {
    "id": 123,
    "name": "Proposed Property",
    "href": "/v3/addresses/123"
  },
  "isFirstTimeBuyer": true
}
```

**Response 201 Created:**
```json
{
  "id": 124,
  "href": "/v3/clients/456/goals/124",
  "type": "investment",
  "category": "Savings",
  "summary": "Retirement nest egg",
  "details": "Build investment portfolio for retirement in 15 years",
  "status": "active",
  "timeHorizon": "longTerm",
  "applicants": [
    {
      "id": 456,
      "name": "John Smith",
      "isPrimary": true,
      "href": "/v3/clients/456"
    }
  ],
  "targetAmount": {
    "value": 500000.00,
    "currency": "GBP"
  },
  "targetDate": "2040-12-31",
  "frequency": "monthly",
  "term": 180,
  "hasInvestmentPreference": "yes",
  "investmentPreferences": "Ethical investments preferred",
  "riskProfile": {
    "id": 5,
    "name": "Balanced",
    "href": "/v3/risk-profiles/5"
  },
  "atr": {
    "id": 789,
    "href": "/v3/clients/456/atrs/789"
  },
  "properties": {
    "customField1": "value1"
  },
  "createdBy": {
    "id": 1,
    "name": "Jane Advisor"
  },
  "createdOn": "2026-02-12T15:30:00Z",
  "_links": {
    "self": { "href": "/v3/clients/456/goals/124" },
    "update": { "href": "/v3/clients/456/goals/124", "method": "PUT" },
    "delete": { "href": "/v3/clients/456/goals/124", "method": "DELETE" }
  }
}
```

**Response Headers:**
```
Content-Type: application/json
Location: /v3/clients/456/goals/124
X-Request-Id: 8e4f5a6b-2345-6789-01bc-def123456789
```

**Response 400 Bad Request (Validation Error):**
```json
{
  "type": "https://api.intelliflo.com/problems/validation-error",
  "title": "Validation Failed",
  "status": 400,
  "detail": "One or more validation errors occurred",
  "instance": "/v3/clients/456/goals",
  "traceId": "00-8e4f5a6b23456789-01bcdef123456789-00",
  "errors": {
    "type": ["The type field is required"],
    "category": ["The category field is required"],
    "targetAmount.value": ["Value must be between 0 and 999999999.99"],
    "term": ["Value for term must be between 0 and 1799"]
  }
}
```

---

#### 3.1.4 Update Goal

**Endpoint:** `PUT /v3/clients/{clientId}/goals/{goalId}`

**Description:** Update an existing goal. Full update (not partial).

**Path Parameters:**
- `clientId` (integer, required) - Client identifier
- `goalId` (integer, required) - Goal identifier

**Headers:**
```
If-Match: "{etag}"
```

**Request Body:**
```json
{
  "type": "investment",
  "category": "Savings",
  "summary": "Updated retirement nest egg",
  "details": "Build investment portfolio for early retirement in 12 years",
  "status": "active",
  "timeHorizon": "mediumTerm",
  "applicants": [
    {
      "id": 456,
      "isPrimary": true
    }
  ],
  "targetAmount": {
    "value": 600000.00,
    "currency": "GBP"
  },
  "targetDate": "2037-12-31",
  "frequency": "monthly",
  "term": 144,
  "hasInvestmentPreference": "yes",
  "investmentPreferences": "Ethical investments preferred, ESG focus",
  "riskProfile": {
    "id": 6
  },
  "atr": {
    "id": 789
  },
  "properties": {
    "customField1": "updatedValue1"
  }
}
```

**Response 200 OK:**
```json
{
  "id": 123,
  "href": "/v3/clients/456/goals/123",
  "type": "investment",
  "category": "Savings",
  "summary": "Updated retirement nest egg",
  "details": "Build investment portfolio for early retirement in 12 years",
  "status": "active",
  "timeHorizon": "mediumTerm",
  "applicants": [
    {
      "id": 456,
      "name": "John Smith",
      "isPrimary": true,
      "href": "/v3/clients/456"
    }
  ],
  "targetAmount": {
    "value": 600000.00,
    "currency": "GBP"
  },
  "targetDate": "2037-12-31",
  "frequency": "monthly",
  "term": 144,
  "hasInvestmentPreference": "yes",
  "investmentPreferences": "Ethical investments preferred, ESG focus",
  "riskProfile": {
    "id": 6,
    "name": "Growth",
    "href": "/v3/risk-profiles/6"
  },
  "atr": {
    "id": 789,
    "href": "/v3/clients/456/atrs/789"
  },
  "createdBy": {
    "id": 1,
    "name": "Jane Advisor"
  },
  "createdOn": "2024-01-15T10:30:00Z",
  "lastReviewedAt": "2026-02-12T16:00:00Z",
  "_links": {
    "self": { "href": "/v3/clients/456/goals/123" }
  }
}
```

**Response Headers:**
```
ETag: "v2"
```

**Response 409 Conflict (Optimistic Concurrency):**
```json
{
  "type": "https://api.intelliflo.com/problems/concurrency-conflict",
  "title": "Concurrency Conflict",
  "status": 409,
  "detail": "The goal has been modified since you last retrieved it. Please refresh and try again.",
  "instance": "/v3/clients/456/goals/123",
  "traceId": "00-9f5a6b7c-3456-7890-12cd-ef1234567890-00",
  "currentETag": "v2",
  "providedETag": "v1"
}
```

---

#### 3.1.5 Delete Goal

**Endpoint:** `DELETE /v3/clients/{clientId}/goals/{goalId}`

**Description:** Delete a goal.

**Path Parameters:**
- `clientId` (integer, required) - Client identifier
- `goalId` (integer, required) - Goal identifier

**Request Example:**
```http
DELETE /v3/clients/456/goals/123 HTTP/1.1
Host: api.intelliflo.com
Authorization: Bearer eyJhbGc...
```

**Response 204 No Content:**
```
(Empty body)
```

**Response 404 Not Found:**
```json
{
  "type": "https://api.intelliflo.com/problems/resource-not-found",
  "title": "Goal Not Found",
  "status": 404,
  "detail": "Goal with ID 123 not found for client 456",
  "instance": "/v3/clients/456/goals/123",
  "traceId": "00-af6b7c8d-4567-8901-23de-f12345678901-00"
}
```

---

### 3.2 Goal Relationships

#### 3.2.1 Link Opportunity to Goal

**Endpoint:** `POST /v3/clients/{clientId}/goals/{goalId}/opportunities/{opportunityId}`

**Description:** Link an opportunity to a goal.

**Path Parameters:**
- `clientId` (integer, required)
- `goalId` (integer, required)
- `opportunityId` (integer, required)

**Request Example:**
```http
POST /v3/clients/456/goals/123/opportunities/999 HTTP/1.1
Host: api.intelliflo.com
Authorization: Bearer eyJhbGc...
Content-Length: 0
```

**Response 204 No Content**

---

#### 3.2.2 Unlink Opportunity from Goal

**Endpoint:** `DELETE /v3/clients/{clientId}/goals/{goalId}/opportunities/{opportunityId}`

**Description:** Remove opportunity link from goal.

**Response 204 No Content**

---

### 3.3 Goal Allocations

#### 3.3.1 List Goal Allocations

**Endpoint:** `GET /v3/goals/{goalId}/allocations`

**Description:** Retrieve plan allocations for a goal.

**Response 200 OK:**
```json
{
  "allocations": [
    {
      "id": 1001,
      "href": "/v3/goals/123/allocations/1001",
      "goal": {
        "id": 123,
        "summary": "Retirement nest egg",
        "href": "/v3/clients/456/goals/123"
      },
      "plan": {
        "id": 888,
        "name": "Vanguard SIPP",
        "provider": "Vanguard",
        "href": "/v3/plans/888"
      },
      "allocationPercentage": 100.0,
      "allocatedAmount": {
        "value": 50000.00,
        "currency": "GBP"
      },
      "createdOn": "2024-06-15T10:00:00Z",
      "_links": {
        "self": { "href": "/v3/goals/123/allocations/1001" },
        "goal": { "href": "/v3/clients/456/goals/123" },
        "plan": { "href": "/v3/plans/888" }
      }
    }
  ],
  "_links": {
    "self": { "href": "/v3/goals/123/allocations" },
    "create": { "href": "/v3/goals/123/allocations", "method": "POST" }
  }
}
```

---

#### 3.3.2 Create Goal Allocation

**Endpoint:** `POST /v3/goals/{goalId}/allocations`

**Description:** Allocate a plan to a goal.

**Request Body:**
```json
{
  "plan": {
    "id": 888
  },
  "allocationPercentage": 100.0,
  "allocatedAmount": {
    "value": 50000.00,
    "currency": "GBP"
  }
}
```

**Response 201 Created:**
```json
{
  "id": 1002,
  "href": "/v3/goals/123/allocations/1002",
  "goal": {
    "id": 123,
    "summary": "Retirement nest egg",
    "href": "/v3/clients/456/goals/123"
  },
  "plan": {
    "id": 888,
    "name": "Vanguard SIPP",
    "provider": "Vanguard",
    "href": "/v3/plans/888"
  },
  "allocationPercentage": 100.0,
  "allocatedAmount": {
    "value": 50000.00,
    "currency": "GBP"
  },
  "createdOn": "2026-02-12T17:00:00Z",
  "_links": {
    "self": { "href": "/v3/goals/123/allocations/1002" }
  }
}
```

---

## 4. Risk Assessment API Contracts

### 4.1 Risk Profile Operations

#### 4.1.1 List Risk Profiles

**Endpoint:** `GET /v3/clients/{clientId}/risk-profiles`

**Description:** Retrieve all risk profiles for a client (investment, retirement, etc.).

**Response 200 OK:**
```json
{
  "riskProfiles": [
    {
      "id": 5,
      "href": "/v3/risk-profiles/5",
      "name": "Balanced",
      "riskNumber": 5,
      "description": "Balanced risk/return profile",
      "adviceArea": "investment",
      "riskScore": 45,
      "riskBand": {
        "lower": 40,
        "upper": 55
      },
      "isActive": true,
      "_links": {
        "self": { "href": "/v3/risk-profiles/5" }
      }
    },
    {
      "id": 6,
      "href": "/v3/risk-profiles/6",
      "name": "Growth",
      "riskNumber": 6,
      "description": "Growth-oriented profile",
      "adviceArea": "retirement",
      "riskScore": 58,
      "riskBand": {
        "lower": 56,
        "upper": 70
      },
      "isActive": true,
      "_links": {
        "self": { "href": "/v3/risk-profiles/6" }
      }
    }
  ],
  "_links": {
    "self": { "href": "/v3/clients/456/risk-profiles" }
  }
}
```

---

### 4.2 ATR (Attitude to Risk) Operations

#### 4.2.1 List Client ATRs

**Endpoint:** `GET /v3/clients/{clientId}/atrs`

**Description:** Retrieve all ATR assessments for a client.

**Query Parameters:**
- `adviceArea` (string, optional) - Filter by advice area (investment, retirement)

**Response 200 OK:**
```json
{
  "atrs": [
    {
      "id": 789,
      "href": "/v3/clients/456/atrs/789",
      "adviceArea": "investment",
      "template": {
        "id": 1,
        "name": "Standard ATR Questionnaire v2",
        "href": "/v3/atr-templates/1"
      },
      "calculatedRiskProfile": {
        "id": 5,
        "name": "Balanced",
        "href": "/v3/risk-profiles/5"
      },
      "chosenRiskProfile": {
        "id": 5,
        "name": "Balanced",
        "href": "/v3/risk-profiles/5"
      },
      "adjustedRiskProfile": null,
      "adjustmentReason": null,
      "adjustmentDate": null,
      "riskScore": 45,
      "riskBand": {
        "lower": 40,
        "upper": 55,
        "weighting": 45
      },
      "clientAgreement": {
        "client1Agrees": true,
        "client2Agrees": true,
        "agreedOn": "2025-06-01T10:00:00Z"
      },
      "notes": "Client comfortable with balanced approach",
      "completedOn": "2025-06-01T09:45:00Z",
      "isLegacyAtr": false,
      "_links": {
        "self": { "href": "/v3/clients/456/atrs/789" },
        "questionnaire": { "href": "/v3/clients/456/atrs/789/questionnaire" },
        "replay": { "href": "/v3/clients/456/atrs/789/replay" }
      }
    },
    {
      "id": 790,
      "href": "/v3/clients/456/atrs/790",
      "adviceArea": "retirement",
      "template": {
        "id": 2,
        "name": "Retirement ATR Questionnaire v1",
        "href": "/v3/atr-templates/2"
      },
      "calculatedRiskProfile": {
        "id": 6,
        "name": "Growth",
        "href": "/v3/risk-profiles/6"
      },
      "chosenRiskProfile": {
        "id": 6,
        "name": "Growth",
        "href": "/v3/risk-profiles/6"
      },
      "adjustedRiskProfile": {
        "id": 5,
        "name": "Balanced",
        "href": "/v3/risk-profiles/5"
      },
      "adjustmentReason": "Client prefers more conservative approach closer to retirement",
      "adjustmentDate": "2025-07-15T14:30:00Z",
      "riskScore": 58,
      "riskBand": {
        "lower": 56,
        "upper": 70,
        "weighting": 58
      },
      "clientAgreement": {
        "client1Agrees": true,
        "client2Agrees": null,
        "agreedOn": "2025-07-15T14:30:00Z"
      },
      "notes": "Adjusted down due to proximity to retirement",
      "completedOn": "2025-07-15T14:00:00Z",
      "isLegacyAtr": false,
      "_links": {
        "self": { "href": "/v3/clients/456/atrs/790" },
        "questionnaire": { "href": "/v3/clients/456/atrs/790/questionnaire" },
        "replay": { "href": "/v3/clients/456/atrs/790/replay" }
      }
    }
  ],
  "_links": {
    "self": { "href": "/v3/clients/456/atrs" },
    "create": { "href": "/v3/clients/456/atrs", "method": "POST" }
  }
}
```

---

#### 4.2.2 Get Single ATR

**Endpoint:** `GET /v3/clients/{clientId}/atrs/{atrId}`

**Response 200 OK:**
```json
{
  "id": 789,
  "href": "/v3/clients/456/atrs/789",
  "adviceArea": "investment",
  "template": {
    "id": 1,
    "name": "Standard ATR Questionnaire v2",
    "version": "2.0",
    "href": "/v3/atr-templates/1"
  },
  "calculatedRiskProfile": {
    "id": 5,
    "name": "Balanced",
    "riskNumber": 5,
    "href": "/v3/risk-profiles/5"
  },
  "chosenRiskProfile": {
    "id": 5,
    "name": "Balanced",
    "riskNumber": 5,
    "href": "/v3/risk-profiles/5"
  },
  "adjustedRiskProfile": null,
  "adjustmentReason": null,
  "adjustmentDate": null,
  "riskScore": 45,
  "riskBand": {
    "lower": 40,
    "upper": 55,
    "weighting": 45
  },
  "clientAgreement": {
    "client1Agrees": true,
    "client1AgreementDate": "2025-06-01T10:00:00Z",
    "client1Notes": "Happy with balanced approach",
    "client2Agrees": true,
    "client2AgreementDate": "2025-06-01T10:05:00Z",
    "client2Notes": null
  },
  "advisorNotes": "Client comfortable with balanced approach",
  "completedBy": {
    "id": 1,
    "name": "Jane Advisor"
  },
  "completedOn": "2025-06-01T09:45:00Z",
  "isLegacyAtr": false,
  "linkedGoals": [
    {
      "id": 123,
      "summary": "Retirement nest egg",
      "href": "/v3/clients/456/goals/123"
    }
  ],
  "_links": {
    "self": { "href": "/v3/clients/456/atrs/789" },
    "questionnaire": { "href": "/v3/clients/456/atrs/789/questionnaire" },
    "replay": { "href": "/v3/clients/456/atrs/789/replay" },
    "template": { "href": "/v3/atr-templates/1" },
    "goals": { "href": "/v3/clients/456/goals?filter=atr/id eq 789" }
  }
}
```

---

#### 4.2.3 Create ATR Assessment

**Endpoint:** `POST /v3/clients/{clientId}/atrs`

**Description:** Create a new ATR assessment for a client.

**Request Body:**
```json
{
  "adviceArea": "investment",
  "template": {
    "id": 1
  },
  "answers": [
    {
      "questionId": 1,
      "answer": "B",
      "score": 3
    },
    {
      "questionId": 2,
      "answer": "C",
      "score": 4
    }
  ],
  "clientAgreement": {
    "client1Agrees": true,
    "client1Notes": "Happy with balanced approach"
  },
  "advisorNotes": "Client comfortable with balanced approach"
}
```

**Response 201 Created:**
```json
{
  "id": 791,
  "href": "/v3/clients/456/atrs/791",
  "adviceArea": "investment",
  "template": {
    "id": 1,
    "name": "Standard ATR Questionnaire v2",
    "href": "/v3/atr-templates/1"
  },
  "calculatedRiskProfile": {
    "id": 5,
    "name": "Balanced",
    "href": "/v3/risk-profiles/5"
  },
  "chosenRiskProfile": {
    "id": 5,
    "name": "Balanced",
    "href": "/v3/risk-profiles/5"
  },
  "riskScore": 45,
  "completedOn": "2026-02-12T18:00:00Z",
  "_links": {
    "self": { "href": "/v3/clients/456/atrs/791" },
    "questionnaire": { "href": "/v3/clients/456/atrs/791/questionnaire" }
  }
}
```

---

#### 4.2.4 Adjust Risk Profile

**Endpoint:** `POST /v3/clients/{clientId}/atrs/{atrId}/adjust`

**Description:** Adjust the risk profile from calculated/chosen to a different profile.

**Request Body:**
```json
{
  "adjustedRiskProfile": {
    "id": 4
  },
  "adjustmentReason": "Client has reduced capacity for loss due to recent life changes",
  "clientAgreement": {
    "client1Agrees": true,
    "client1Notes": "Agreed to more conservative approach"
  },
  "advisorNotes": "Discussed recent circumstances and agreed adjustment appropriate"
}
```

**Response 200 OK:**
```json
{
  "id": 789,
  "href": "/v3/clients/456/atrs/789",
  "adviceArea": "investment",
  "calculatedRiskProfile": {
    "id": 5,
    "name": "Balanced"
  },
  "chosenRiskProfile": {
    "id": 5,
    "name": "Balanced"
  },
  "adjustedRiskProfile": {
    "id": 4,
    "name": "Cautious",
    "href": "/v3/risk-profiles/4"
  },
  "adjustmentReason": "Client has reduced capacity for loss due to recent life changes",
  "adjustmentDate": "2026-02-12T18:15:00Z",
  "_links": {
    "self": { "href": "/v3/clients/456/atrs/789" }
  }
}
```

---

### 4.3 Risk Questionnaire

#### 4.3.1 Get ATR Questionnaire

**Endpoint:** `GET /v3/clients/{clientId}/atrs/{atrId}/questionnaire`

**Description:** Retrieve the full questionnaire with questions and answers for an ATR.

**Response 200 OK:**
```json
{
  "atrId": 789,
  "template": {
    "id": 1,
    "name": "Standard ATR Questionnaire v2",
    "version": "2.0",
    "href": "/v3/atr-templates/1"
  },
  "questions": [
    {
      "id": 1,
      "order": 1,
      "text": "How would you describe your investment knowledge?",
      "type": "multipleChoice",
      "options": [
        {
          "id": "A",
          "text": "No knowledge",
          "score": 1
        },
        {
          "id": "B",
          "text": "Limited knowledge",
          "score": 2
        },
        {
          "id": "C",
          "text": "Good knowledge",
          "score": 3
        },
        {
          "id": "D",
          "text": "Extensive knowledge",
          "score": 4
        }
      ],
      "selectedAnswer": {
        "id": "B",
        "text": "Limited knowledge",
        "score": 2
      },
      "weight": 1.0
    },
    {
      "id": 2,
      "order": 2,
      "text": "How would you react if your investment fell by 20% in one year?",
      "type": "multipleChoice",
      "options": [
        {
          "id": "A",
          "text": "Sell immediately",
          "score": 1
        },
        {
          "id": "B",
          "text": "Consider selling",
          "score": 2
        },
        {
          "id": "C",
          "text": "Hold and wait",
          "score": 3
        },
        {
          "id": "D",
          "text": "Buy more",
          "score": 4
        }
      ],
      "selectedAnswer": {
        "id": "C",
        "text": "Hold and wait",
        "score": 3
      },
      "weight": 1.5
    }
  ],
  "totalScore": 45,
  "maxPossibleScore": 100,
  "calculatedRiskProfile": {
    "id": 5,
    "name": "Balanced"
  },
  "_links": {
    "self": { "href": "/v3/clients/456/atrs/789/questionnaire" },
    "atr": { "href": "/v3/clients/456/atrs/789" }
  }
}
```

---

#### 4.3.2 Risk Replay

**Endpoint:** `GET /v3/clients/{clientId}/atrs/{atrId}/replay`

**Description:** Replay historical ATR results to see how risk profile was calculated.

**Response 200 OK:**
```json
{
  "atrId": 789,
  "completedOn": "2025-06-01T09:45:00Z",
  "template": {
    "id": 1,
    "name": "Standard ATR Questionnaire v2",
    "version": "2.0"
  },
  "calculation": {
    "totalScore": 45,
    "weightedScore": 45,
    "maxScore": 100,
    "scorePercentage": 45.0,
    "riskBands": [
      {
        "id": 1,
        "name": "Very Cautious",
        "range": { "min": 0, "max": 15 }
      },
      {
        "id": 2,
        "name": "Cautious",
        "range": { "min": 16, "max": 30 }
      },
      {
        "id": 3,
        "name": "Moderate Cautious",
        "range": { "min": 31, "max": 39 }
      },
      {
        "id": 4,
        "name": "Moderate",
        "range": { "min": 40, "max": 55 }
      },
      {
        "id": 5,
        "name": "Balanced",
        "range": { "min": 56, "max": 70 },
        "selected": true
      },
      {
        "id": 6,
        "name": "Growth",
        "range": { "min": 71, "max": 85 }
      },
      {
        "id": 7,
        "name": "Adventurous",
        "range": { "min": 86, "max": 100 }
      }
    ],
    "selectedBand": {
      "id": 5,
      "name": "Balanced",
      "range": { "min": 56, "max": 70 }
    }
  },
  "history": [
    {
      "action": "calculated",
      "riskProfile": { "id": 5, "name": "Balanced" },
      "timestamp": "2025-06-01T09:45:00Z",
      "performedBy": { "id": 1, "name": "Jane Advisor" }
    },
    {
      "action": "chosen",
      "riskProfile": { "id": 5, "name": "Balanced" },
      "timestamp": "2025-06-01T10:00:00Z",
      "performedBy": { "id": 456, "name": "John Smith" }
    }
  ],
  "_links": {
    "self": { "href": "/v3/clients/456/atrs/789/replay" },
    "atr": { "href": "/v3/clients/456/atrs/789" }
  }
}
```

---

### 4.4 Investment Preferences

#### 4.4.1 Get Investment Preference

**Endpoint:** `GET /v3/clients/{clientId}/investment-preferences/{preferenceId}`

**Response 200 OK:**
```json
{
  "id": 101,
  "href": "/v3/clients/456/investment-preferences/101",
  "client": {
    "id": 456,
    "name": "John Smith",
    "href": "/v3/clients/456"
  },
  "preferences": {
    "ethicalInvesting": true,
    "esgFocus": true,
    "excludedSectors": ["tobacco", "gambling", "weapons"],
    "geographicPreferences": ["uk", "europe"],
    "assetClassPreferences": {
      "equities": 60,
      "bonds": 30,
      "alternatives": 10
    }
  },
  "notes": "Strong preference for ethical and sustainable investing",
  "createdOn": "2025-06-01T10:30:00Z",
  "lastUpdated": "2025-08-15T14:00:00Z",
  "_links": {
    "self": { "href": "/v3/clients/456/investment-preferences/101" },
    "goals": { "href": "/v3/clients/456/goals?filter=investmentPreference/id eq 101" }
  }
}
```

---

## 5. Supplementary APIs

### 5.1 Dependants

#### 5.1.1 List Dependants

**Endpoint:** `GET /v3/clients/{clientId}/dependants`

**Response 200 OK:**
```json
{
  "dependants": [
    {
      "id": 201,
      "href": "/v3/clients/456/dependants/201",
      "name": "Emily Smith",
      "dateOfBirth": "2015-03-15",
      "age": 10,
      "relationship": "daughter",
      "isFinanciallyDependant": true,
      "financialDependencyEndsOn": "2033-09-01",
      "dependencyDuration": "untilEducationComplete",
      "livesWithClient": "bothClients",
      "notes": "University education planned",
      "_links": {
        "self": { "href": "/v3/clients/456/dependants/201" }
      }
    },
    {
      "id": 202,
      "href": "/v3/clients/456/dependants/202",
      "name": "James Smith",
      "dateOfBirth": "2018-07-22",
      "age": 7,
      "relationship": "son",
      "isFinanciallyDependant": true,
      "financialDependencyEndsOn": "2036-09-01",
      "dependencyDuration": "untilEducationComplete",
      "livesWithClient": "bothClients",
      "notes": null,
      "_links": {
        "self": { "href": "/v3/clients/456/dependants/202" }
      }
    }
  ],
  "_links": {
    "self": { "href": "/v3/clients/456/dependants" },
    "create": { "href": "/v3/clients/456/dependants", "method": "POST" }
  }
}
```

---

#### 5.1.2 Create Dependant

**Endpoint:** `POST /v3/clients/{clientId}/dependants`

**Request Body:**
```json
{
  "name": "Sophie Smith",
  "dateOfBirth": "2020-11-10",
  "relationship": "daughter",
  "isFinanciallyDependant": true,
  "financialDependencyEndsOn": "2038-09-01",
  "dependencyDuration": "untilEducationComplete",
  "livesWithClient": "bothClients",
  "notes": "Youngest child"
}
```

**Response 201 Created:**
```json
{
  "id": 203,
  "href": "/v3/clients/456/dependants/203",
  "name": "Sophie Smith",
  "dateOfBirth": "2020-11-10",
  "age": 5,
  "relationship": "daughter",
  "isFinanciallyDependant": true,
  "financialDependencyEndsOn": "2038-09-01",
  "dependencyDuration": "untilEducationComplete",
  "livesWithClient": "bothClients",
  "notes": "Youngest child",
  "createdOn": "2026-02-12T19:00:00Z",
  "_links": {
    "self": { "href": "/v3/clients/456/dependants/203" },
    "update": { "href": "/v3/clients/456/dependants/203", "method": "PUT" },
    "delete": { "href": "/v3/clients/456/dependants/203", "method": "DELETE" }
  }
}
```

---

### 5.2 Needs & Priorities

#### 5.2.1 Get Needs & Priorities

**Endpoint:** `GET /v3/clients/{clientId}/needs-priorities`

**Description:** Retrieve custom questions and answers about client needs and priorities.

**Response 200 OK:**
```json
{
  "clientId": 456,
  "href": "/v3/clients/456/needs-priorities",
  "sections": [
    {
      "name": "Protection Needs",
      "questions": [
        {
          "id": 1,
          "text": "What would happen to your family if you were unable to work?",
          "answer": "My partner would need to return to work and we'd struggle with childcare costs",
          "importance": "high"
        },
        {
          "id": 2,
          "text": "Do you have any existing life insurance?",
          "answer": "£100,000 life cover through work",
          "importance": "medium"
        }
      ]
    },
    {
      "name": "Retirement Aspirations",
      "questions": [
        {
          "id": 10,
          "text": "What does a comfortable retirement look like to you?",
          "answer": "Maintain current lifestyle, travel twice a year, support grandchildren",
          "importance": "high"
        },
        {
          "id": 11,
          "text": "At what age would you like to retire?",
          "answer": "Between 60-65, flexible depending on circumstances",
          "importance": "high"
        }
      ]
    }
  ],
  "lastUpdated": "2025-06-01T11:00:00Z",
  "_links": {
    "self": { "href": "/v3/clients/456/needs-priorities" },
    "update": { "href": "/v3/clients/456/needs-priorities", "method": "PUT" }
  }
}
```

---

#### 5.2.2 Update Needs & Priorities

**Endpoint:** `PUT /v3/clients/{clientId}/needs-priorities`

**Request Body:**
```json
{
  "sections": [
    {
      "name": "Protection Needs",
      "questions": [
        {
          "id": 1,
          "text": "What would happen to your family if you were unable to work?",
          "answer": "Updated: Partner would need to return to work, childcare now arranged",
          "importance": "high"
        }
      ]
    }
  ]
}
```

**Response 200 OK:**
```json
{
  "clientId": 456,
  "href": "/v3/clients/456/needs-priorities",
  "sections": [
    {
      "name": "Protection Needs",
      "questions": [
        {
          "id": 1,
          "text": "What would happen to your family if you were unable to work?",
          "answer": "Updated: Partner would need to return to work, childcare now arranged",
          "importance": "high"
        }
      ]
    }
  ],
  "lastUpdated": "2026-02-12T19:30:00Z",
  "_links": {
    "self": { "href": "/v3/clients/456/needs-priorities" }
  }
}
```

---

### 5.3 Reference Data

#### 5.3.1 Get Goal Categories

**Endpoint:** `GET /v3/reference-data/goal-categories`

**Response 200 OK:**
```json
{
  "categories": [
    {
      "id": 1,
      "name": "Savings",
      "applicableGoalTypes": ["investment"]
    },
    {
      "id": 2,
      "name": "Pension",
      "applicableGoalTypes": ["retirement"]
    },
    {
      "id": 3,
      "name": "Life Cover",
      "applicableGoalTypes": ["protection"]
    },
    {
      "id": 4,
      "name": "House Purchase",
      "applicableGoalTypes": ["mortgage"]
    },
    {
      "id": 5,
      "name": "Budget Planning",
      "applicableGoalTypes": ["budget"]
    },
    {
      "id": 6,
      "name": "Estate Planning",
      "applicableGoalTypes": ["estatePlanning"]
    },
    {
      "id": 7,
      "name": "Equity Release",
      "applicableGoalTypes": ["equityRelease"]
    }
  ],
  "_links": {
    "self": { "href": "/v3/reference-data/goal-categories" }
  }
}
```

---

## 6. Event Schemas

### 6.1 Goal Events

#### GoalCreated

**Event Type:** `intelliflo.requirements.goal.created.v1`

**Schema:**
```json
{
  "eventId": "uuid",
  "eventType": "intelliflo.requirements.goal.created.v1",
  "occurredAt": "2026-02-12T15:30:00Z",
  "tenantId": 1,
  "source": "requirements-service",
  "data": {
    "goalId": 124,
    "clientId": 456,
    "type": "investment",
    "category": "Savings",
    "summary": "Retirement nest egg",
    "status": "active",
    "targetAmount": {
      "value": 500000.00,
      "currency": "GBP"
    },
    "targetDate": "2040-12-31",
    "applicants": [
      {
        "id": 456,
        "isPrimary": true
      }
    ],
    "createdBy": {
      "id": 1,
      "name": "Jane Advisor"
    },
    "createdOn": "2026-02-12T15:30:00Z"
  },
  "metadata": {
    "correlationId": "7d3e4f5a-1234-5678-90ab-cdef12345678",
    "causationId": "user-action-create-goal"
  }
}
```

---

#### GoalUpdated

**Event Type:** `intelliflo.requirements.goal.updated.v1`

**Schema:**
```json
{
  "eventId": "uuid",
  "eventType": "intelliflo.requirements.goal.updated.v1",
  "occurredAt": "2026-02-12T16:00:00Z",
  "tenantId": 1,
  "source": "requirements-service",
  "data": {
    "goalId": 123,
    "clientId": 456,
    "type": "investment",
    "changes": {
      "targetAmount": {
        "from": { "value": 500000.00, "currency": "GBP" },
        "to": { "value": 600000.00, "currency": "GBP" }
      },
      "targetDate": {
        "from": "2040-12-31",
        "to": "2037-12-31"
      },
      "riskProfile": {
        "from": { "id": 5, "name": "Balanced" },
        "to": { "id": 6, "name": "Growth" }
      }
    },
    "updatedBy": {
      "id": 1,
      "name": "Jane Advisor"
    },
    "updatedOn": "2026-02-12T16:00:00Z"
  },
  "metadata": {
    "correlationId": "8e4f5a6b-2345-6789-01bc-def123456789",
    "causationId": "user-action-update-goal"
  }
}
```

---

#### GoalDeleted

**Event Type:** `intelliflo.requirements.goal.deleted.v1`

**Schema:**
```json
{
  "eventId": "uuid",
  "eventType": "intelliflo.requirements.goal.deleted.v1",
  "occurredAt": "2026-02-12T17:00:00Z",
  "tenantId": 1,
  "source": "requirements-service",
  "data": {
    "goalId": 123,
    "clientId": 456,
    "type": "investment",
    "deletedBy": {
      "id": 1,
      "name": "Jane Advisor"
    },
    "deletedOn": "2026-02-12T17:00:00Z"
  },
  "metadata": {
    "correlationId": "9f5a6b7c-3456-7890-12cd-ef1234567890",
    "causationId": "user-action-delete-goal"
  }
}
```

---

### 6.2 Risk Profile Events

#### RiskProfileCalculated

**Event Type:** `intelliflo.requirements.risk-profile.calculated.v1`

**Schema:**
```json
{
  "eventId": "uuid",
  "eventType": "intelliflo.requirements.risk-profile.calculated.v1",
  "occurredAt": "2025-06-01T09:45:00Z",
  "tenantId": 1,
  "source": "requirements-service",
  "data": {
    "atrId": 789,
    "clientId": 456,
    "adviceArea": "investment",
    "calculatedRiskProfile": {
      "id": 5,
      "name": "Balanced",
      "riskNumber": 5
    },
    "riskScore": 45,
    "templateId": 1,
    "completedBy": {
      "id": 1,
      "name": "Jane Advisor"
    },
    "completedOn": "2025-06-01T09:45:00Z"
  }
}
```

---

#### RiskProfileAdjusted

**Event Type:** `intelliflo.requirements.risk-profile.adjusted.v1`

**Schema:**
```json
{
  "eventId": "uuid",
  "eventType": "intelliflo.requirements.risk-profile.adjusted.v1",
  "occurredAt": "2026-02-12T18:15:00Z",
  "tenantId": 1,
  "source": "requirements-service",
  "data": {
    "atrId": 789,
    "clientId": 456,
    "adviceArea": "investment",
    "calculatedRiskProfile": {
      "id": 5,
      "name": "Balanced"
    },
    "adjustedRiskProfile": {
      "id": 4,
      "name": "Cautious"
    },
    "adjustmentReason": "Client has reduced capacity for loss due to recent life changes",
    "adjustedBy": {
      "id": 1,
      "name": "Jane Advisor"
    },
    "adjustedOn": "2026-02-12T18:15:00Z",
    "clientAgreed": true
  }
}
```

---

## 7. OpenAPI 3.1 Specification

### 7.1 Complete OpenAPI Spec (YAML)

```yaml
openapi: 3.1.0
info:
  title: Requirements API - Goals & Risk Assessment
  version: 3.0.0
  description: |
    V3 API for Goals/Objectives and Risk Assessment functionality.

    This API provides comprehensive management of client goals, risk profiling,
    and related entities. Built on the modern Requirements microservice architecture.

    **Key Features:**
    - Polymorphic goal types (7 types)
    - Risk profile integration
    - Event-driven architecture
    - Full CRUD operations
    - Rich querying and filtering

  contact:
    name: API Support
    url: https://developer.intelliflo.com/support
    email: api-support@intelliflo.com
  license:
    name: Proprietary
    url: https://intelliflo.com/legal/api-license

servers:
  - url: https://api.intelliflo.com/requirements
    description: Production
  - url: https://api-sandbox.intelliflo.com/requirements
    description: Sandbox

security:
  - oauth2:
      - requirements:read
      - requirements:write
      - client-data:read

tags:
  - name: Goals
    description: Client goals and objectives management
  - name: Risk Assessment
    description: Risk profiling and ATR assessments
  - name: Dependants
    description: Financial dependants
  - name: Needs & Priorities
    description: Custom client questions
  - name: Reference Data
    description: Static reference data

paths:
  /v3/clients/{clientId}/goals:
    get:
      summary: List client goals
      operationId: listGoals
      tags: [Goals]
      parameters:
        - $ref: '#/components/parameters/ClientIdParam'
        - $ref: '#/components/parameters/PageParam'
        - $ref: '#/components/parameters/PageSizeParam'
        - $ref: '#/components/parameters/FilterParam'
        - $ref: '#/components/parameters/OrderByParam'
        - $ref: '#/components/parameters/FieldsParam'
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GoalCollection'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'
        '429':
          $ref: '#/components/responses/TooManyRequests'

    post:
      summary: Create goal
      operationId: createGoal
      tags: [Goals]
      parameters:
        - $ref: '#/components/parameters/ClientIdParam'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              oneOf:
                - $ref: '#/components/schemas/InvestmentGoal'
                - $ref: '#/components/schemas/RetirementGoal'
                - $ref: '#/components/schemas/ProtectionGoal'
                - $ref: '#/components/schemas/MortgageGoal'
                - $ref: '#/components/schemas/BudgetGoal'
                - $ref: '#/components/schemas/EstatePlanningGoal'
                - $ref: '#/components/schemas/EquityReleaseGoal'
              discriminator:
                propertyName: type
                mapping:
                  investment: '#/components/schemas/InvestmentGoal'
                  retirement: '#/components/schemas/RetirementGoal'
                  protection: '#/components/schemas/ProtectionGoal'
                  mortgage: '#/components/schemas/MortgageGoal'
                  budget: '#/components/schemas/BudgetGoal'
                  estatePlanning: '#/components/schemas/EstatePlanningGoal'
                  equityRelease: '#/components/schemas/EquityReleaseGoal'
      responses:
        '201':
          description: Created
          headers:
            Location:
              description: URI of created goal
              schema:
                type: string
          content:
            application/json:
              schema:
                oneOf:
                  - $ref: '#/components/schemas/InvestmentGoal'
                  - $ref: '#/components/schemas/RetirementGoal'
                  - $ref: '#/components/schemas/ProtectionGoal'
                  - $ref: '#/components/schemas/MortgageGoal'
                  - $ref: '#/components/schemas/BudgetGoal'
                  - $ref: '#/components/schemas/EstatePlanningGoal'
                  - $ref: '#/components/schemas/EquityReleaseGoal'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'

  /v3/clients/{clientId}/goals/{goalId}:
    get:
      summary: Get goal
      operationId: getGoal
      tags: [Goals]
      parameters:
        - $ref: '#/components/parameters/ClientIdParam'
        - $ref: '#/components/parameters/GoalIdParam'
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                oneOf:
                  - $ref: '#/components/schemas/InvestmentGoal'
                  - $ref: '#/components/schemas/RetirementGoal'
                  - $ref: '#/components/schemas/ProtectionGoal'
                  - $ref: '#/components/schemas/MortgageGoal'
                  - $ref: '#/components/schemas/BudgetGoal'
                  - $ref: '#/components/schemas/EstatePlanningGoal'
                  - $ref: '#/components/schemas/EquityReleaseGoal'
        '404':
          $ref: '#/components/responses/NotFound'

    put:
      summary: Update goal
      operationId: updateGoal
      tags: [Goals]
      parameters:
        - $ref: '#/components/parameters/ClientIdParam'
        - $ref: '#/components/parameters/GoalIdParam'
        - $ref: '#/components/parameters/IfMatchParam'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              oneOf:
                - $ref: '#/components/schemas/InvestmentGoal'
                - $ref: '#/components/schemas/RetirementGoal'
                - $ref: '#/components/schemas/ProtectionGoal'
                - $ref: '#/components/schemas/MortgageGoal'
                - $ref: '#/components/schemas/BudgetGoal'
                - $ref: '#/components/schemas/EstatePlanningGoal'
                - $ref: '#/components/schemas/EquityReleaseGoal'
      responses:
        '200':
          description: Success
          headers:
            ETag:
              description: Entity version
              schema:
                type: string
          content:
            application/json:
              schema:
                oneOf:
                  - $ref: '#/components/schemas/InvestmentGoal'
                  - $ref: '#/components/schemas/RetirementGoal'
                  - $ref: '#/components/schemas/ProtectionGoal'
                  - $ref: '#/components/schemas/MortgageGoal'
                  - $ref: '#/components/schemas/BudgetGoal'
                  - $ref: '#/components/schemas/EstatePlanningGoal'
                  - $ref: '#/components/schemas/EquityReleaseGoal'
        '400':
          $ref: '#/components/responses/BadRequest'
        '404':
          $ref: '#/components/responses/NotFound'
        '409':
          $ref: '#/components/responses/Conflict'

    delete:
      summary: Delete goal
      operationId: deleteGoal
      tags: [Goals]
      parameters:
        - $ref: '#/components/parameters/ClientIdParam'
        - $ref: '#/components/parameters/GoalIdParam'
      responses:
        '204':
          description: No Content
        '404':
          $ref: '#/components/responses/NotFound'

  /v3/clients/{clientId}/atrs:
    get:
      summary: List client ATRs
      operationId: listAtrs
      tags: [Risk Assessment]
      parameters:
        - $ref: '#/components/parameters/ClientIdParam'
        - name: adviceArea
          in: query
          schema:
            type: string
            enum: [investment, retirement]
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AtrCollection'

    post:
      summary: Create ATR assessment
      operationId: createAtr
      tags: [Risk Assessment]
      parameters:
        - $ref: '#/components/parameters/ClientIdParam'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AtrCreateRequest'
      responses:
        '201':
          description: Created
          headers:
            Location:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Atr'

components:
  securitySchemes:
    oauth2:
      type: oauth2
      flows:
        authorizationCode:
          authorizationUrl: https://auth.intelliflo.com/oauth/authorize
          tokenUrl: https://auth.intelliflo.com/oauth/token
          scopes:
            requirements:read: Read goals and risk assessments
            requirements:write: Create/update/delete goals and risk assessments
            client-data:read: Access client data

  parameters:
    ClientIdParam:
      name: clientId
      in: path
      required: true
      schema:
        type: integer
        format: int32
      description: Client identifier

    GoalIdParam:
      name: goalId
      in: path
      required: true
      schema:
        type: integer
        format: int32
      description: Goal identifier

    PageParam:
      name: page
      in: query
      schema:
        type: integer
        format: int32
        default: 1
        minimum: 1
      description: Page number

    PageSizeParam:
      name: pageSize
      in: query
      schema:
        type: integer
        format: int32
        default: 100
        minimum: 1
        maximum: 500
      description: Results per page

    FilterParam:
      name: filter
      in: query
      schema:
        type: string
      description: OData filter expression
      example: "type eq 'investment' and status eq 'active'"

    OrderByParam:
      name: orderBy
      in: query
      schema:
        type: string
      description: Sort expression
      example: "createdOn desc,category asc"

    FieldsParam:
      name: fields
      in: query
      schema:
        type: string
      description: Field selection (comma-separated)
      example: "id,summary,targetAmount,status"

    IfMatchParam:
      name: If-Match
      in: header
      schema:
        type: string
      description: ETag for optimistic concurrency

  schemas:
    # Base Goal Schema
    BaseGoal:
      type: object
      required:
        - type
        - category
        - status
      properties:
        id:
          type: integer
          format: int32
          readOnly: true
        href:
          type: string
          format: uri
          readOnly: true
        type:
          type: string
          enum:
            - investment
            - retirement
            - protection
            - mortgage
            - budget
            - estatePlanning
            - equityRelease
        category:
          type: string
          maxLength: 255
        summary:
          type: string
          maxLength: 100
        details:
          type: string
          maxLength: 3000
        status:
          type: string
          enum: [active, completed, onHold, cancelled]
          default: active
        timeHorizon:
          type: string
          enum: [shortTerm, mediumTerm, longTerm]
        applicants:
          type: array
          items:
            $ref: '#/components/schemas/ApplicantRef'
          maxItems: 2
        linkedOpportunities:
          type: array
          items:
            $ref: '#/components/schemas/OpportunityRef'
          readOnly: true
        plans:
          type: array
          items:
            $ref: '#/components/schemas/PlanRef'
          readOnly: true
        properties:
          type: object
          additionalProperties:
            type: string
          maxProperties: 25
        createdBy:
          $ref: '#/components/schemas/UserRef'
          readOnly: true
        createdOn:
          type: string
          format: date-time
          readOnly: true
        lastReviewedAt:
          type: string
          format: date-time
        _links:
          type: object
          readOnly: true
      discriminator:
        propertyName: type

    # Investment Goal
    InvestmentGoal:
      allOf:
        - $ref: '#/components/schemas/BaseGoal'
        - type: object
          properties:
            targetAmount:
              $ref: '#/components/schemas/CurrencyValue'
            targetDate:
              type: string
              format: date
            frequency:
              type: string
              enum: [monthly, annual, oneOff, quarterly]
            term:
              type: integer
              minimum: 0
              maximum: 1799
              description: Term in months
            hasInvestmentPreference:
              type: string
              enum: [yes, no, unanswered]
            investmentPreferences:
              type: string
              maxLength: 255
            riskProfile:
              $ref: '#/components/schemas/RiskProfileNamedRef'
            atr:
              $ref: '#/components/schemas/AtrRef'
            investmentPreference:
              $ref: '#/components/schemas/InvestmentPreferenceRef'

    # Retirement Goal
    RetirementGoal:
      allOf:
        - $ref: '#/components/schemas/BaseGoal'
        - type: object
          properties:
            targetAge:
              type: integer
              minimum: 50
              maximum: 100
            term:
              type: integer
              minimum: 0
              maximum: 1799
              description: Term in months
            lumpSum:
              $ref: '#/components/schemas/LumpSumValue'
            income:
              $ref: '#/components/schemas/RetirementIncomeValue'
            hasInvestmentPreference:
              type: string
              enum: [yes, no, unanswered]
            investmentPreferences:
              type: string
              maxLength: 255
            riskProfile:
              $ref: '#/components/schemas/RiskProfileNamedRef'
            atr:
              $ref: '#/components/schemas/AtrRef'
            investmentPreference:
              $ref: '#/components/schemas/InvestmentPreferenceRef'

    # Protection Goal
    ProtectionGoal:
      allOf:
        - $ref: '#/components/schemas/BaseGoal'
        - type: object
          properties:
            coverAmount:
              $ref: '#/components/schemas/CurrencyValue'
            startDate:
              type: string
              format: date
            term:
              type: integer
              minimum: 0
              maximum: 1799
              description: Term in months
            coverFrequency:
              type: string
              enum: [monthly, annual]
            isWholeOfLife:
              type: boolean

    # Mortgage Goal
    MortgageGoal:
      allOf:
        - $ref: '#/components/schemas/BaseGoal'
        - type: object
          properties:
            mortgageType:
              $ref: '#/components/schemas/ReferenceDataValue'
            loan:
              $ref: '#/components/schemas/CurrencyValue'
            deposit:
              $ref: '#/components/schemas/DepositValue'
            term:
              $ref: '#/components/schemas/MortgageTermValue'
            repaymentMethod:
              $ref: '#/components/schemas/ReferenceDataValue'
            capitalRepayment:
              type: number
              format: decimal
            interestOnlyRepayment:
              type: number
              format: decimal
            propertyValuation:
              $ref: '#/components/schemas/CurrencyValue'
            propertyAddress:
              $ref: '#/components/schemas/PropertyAddressRef'
            isFirstTimeBuyer:
              type: boolean

    # Budget Goal
    BudgetGoal:
      allOf:
        - $ref: '#/components/schemas/BaseGoal'

    # Estate Planning Goal
    EstatePlanningGoal:
      allOf:
        - $ref: '#/components/schemas/BaseGoal'

    # Equity Release Goal
    EquityReleaseGoal:
      allOf:
        - $ref: '#/components/schemas/BaseGoal'
        - type: object
          properties:
            releaseAmount:
              $ref: '#/components/schemas/CurrencyValue'
            equityReleaseType:
              $ref: '#/components/schemas/ReferenceDataValue'

    # Value Objects
    CurrencyValue:
      type: object
      required:
        - value
        - currency
      properties:
        value:
          type: number
          format: decimal
          minimum: 0
          maximum: 999999999.99
        currency:
          type: string
          pattern: '^[A-Z]{3}$'
          example: GBP

    LumpSumValue:
      type: object
      properties:
        amount:
          $ref: '#/components/schemas/CurrencyValue'
        type:
          type: string
          enum: [tfls, pcls, ufpls]
          description: Tax-free lump sum, Pension commencement lump sum, Uncrystallised funds pension lump sum

    RetirementIncomeValue:
      type: object
      properties:
        amount:
          $ref: '#/components/schemas/CurrencyValue'
        frequency:
          type: string
          enum: [monthly, annual]
        inflationAdjusted:
          type: boolean

    DepositValue:
      type: object
      properties:
        amount:
          $ref: '#/components/schemas/CurrencyValue'
        source:
          type: string
          maxLength: 255

    MortgageTermValue:
      type: object
      properties:
        years:
          type: integer
          minimum: 0
          maximum: 40
        months:
          type: integer
          minimum: 0
          maximum: 1799

    ReferenceDataValue:
      type: object
      properties:
        id:
          type: integer
          format: int32
        name:
          type: string

    # Reference Types
    ApplicantRef:
      type: object
      required:
        - id
      properties:
        id:
          type: integer
          format: int32
        name:
          type: string
          readOnly: true
        isPrimary:
          type: boolean
        href:
          type: string
          format: uri
          readOnly: true

    RiskProfileNamedRef:
      type: object
      required:
        - id
      properties:
        id:
          type: integer
          format: int32
        name:
          type: string
          readOnly: true
        riskNumber:
          type: integer
          minimum: 1
          maximum: 10
          readOnly: true
        href:
          type: string
          format: uri
          readOnly: true

    AtrRef:
      type: object
      required:
        - id
      properties:
        id:
          type: integer
          format: int32
        href:
          type: string
          format: uri
          readOnly: true

    InvestmentPreferenceRef:
      type: object
      required:
        - id
      properties:
        id:
          type: integer
          format: int32
        href:
          type: string
          format: uri
          readOnly: true

    OpportunityRef:
      type: object
      properties:
        id:
          type: integer
          format: int32
        href:
          type: string
          format: uri

    PlanRef:
      type: object
      properties:
        id:
          type: integer
          format: int32
        name:
          type: string
        href:
          type: string
          format: uri

    PropertyAddressRef:
      type: object
      properties:
        id:
          type: integer
          format: int32
        name:
          type: string
        href:
          type: string
          format: uri

    UserRef:
      type: object
      properties:
        id:
          type: integer
          format: int32
        name:
          type: string

    # Collections
    GoalCollection:
      type: object
      properties:
        goals:
          type: array
          items:
            oneOf:
              - $ref: '#/components/schemas/InvestmentGoal'
              - $ref: '#/components/schemas/RetirementGoal'
              - $ref: '#/components/schemas/ProtectionGoal'
              - $ref: '#/components/schemas/MortgageGoal'
              - $ref: '#/components/schemas/BudgetGoal'
              - $ref: '#/components/schemas/EstatePlanningGoal'
              - $ref: '#/components/schemas/EquityReleaseGoal'
        pagination:
          $ref: '#/components/schemas/Pagination'
        _links:
          type: object

    # ATR Schemas
    Atr:
      type: object
      properties:
        id:
          type: integer
          format: int32
        href:
          type: string
          format: uri
        adviceArea:
          type: string
          enum: [investment, retirement]
        template:
          $ref: '#/components/schemas/AtrTemplateRef'
        calculatedRiskProfile:
          $ref: '#/components/schemas/RiskProfileNamedRef'
        chosenRiskProfile:
          $ref: '#/components/schemas/RiskProfileNamedRef'
        adjustedRiskProfile:
          $ref: '#/components/schemas/RiskProfileNamedRef'
        adjustmentReason:
          type: string
          maxLength: 1000
        adjustmentDate:
          type: string
          format: date-time
        riskScore:
          type: number
          format: decimal
        riskBand:
          $ref: '#/components/schemas/RiskBand'
        clientAgreement:
          $ref: '#/components/schemas/ClientAgreement'
        notes:
          type: string
          maxLength: 5000
        completedOn:
          type: string
          format: date-time
        isLegacyAtr:
          type: boolean
        _links:
          type: object

    AtrTemplateRef:
      type: object
      properties:
        id:
          type: integer
          format: int32
        name:
          type: string
        version:
          type: string
        href:
          type: string
          format: uri

    RiskBand:
      type: object
      properties:
        lower:
          type: number
        upper:
          type: number
        weighting:
          type: number

    ClientAgreement:
      type: object
      properties:
        client1Agrees:
          type: boolean
        client1AgreementDate:
          type: string
          format: date-time
        client1Notes:
          type: string
          maxLength: 500
        client2Agrees:
          type: boolean
        client2AgreementDate:
          type: string
          format: date-time
        client2Notes:
          type: string
          maxLength: 500

    AtrCreateRequest:
      type: object
      required:
        - adviceArea
        - template
      properties:
        adviceArea:
          type: string
          enum: [investment, retirement]
        template:
          type: object
          required:
            - id
          properties:
            id:
              type: integer
              format: int32
        answers:
          type: array
          items:
            type: object
            properties:
              questionId:
                type: integer
              answer:
                type: string
              score:
                type: number
        clientAgreement:
          $ref: '#/components/schemas/ClientAgreement'
        advisorNotes:
          type: string
          maxLength: 5000

    AtrCollection:
      type: object
      properties:
        atrs:
          type: array
          items:
            $ref: '#/components/schemas/Atr'
        _links:
          type: object

    # Common
    Pagination:
      type: object
      properties:
        page:
          type: integer
          format: int32
        pageSize:
          type: integer
          format: int32
        totalCount:
          type: integer
          format: int64
        totalPages:
          type: integer
          format: int32

    # Error
    ProblemDetails:
      type: object
      properties:
        type:
          type: string
          format: uri
        title:
          type: string
        status:
          type: integer
          format: int32
        detail:
          type: string
        instance:
          type: string
          format: uri
        traceId:
          type: string
        errors:
          type: object
          additionalProperties: true

  responses:
    BadRequest:
      description: Bad Request
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ProblemDetails'

    Unauthorized:
      description: Unauthorized
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ProblemDetails'

    Forbidden:
      description: Forbidden
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ProblemDetails'

    NotFound:
      description: Not Found
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ProblemDetails'

    Conflict:
      description: Conflict (e.g., optimistic concurrency)
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ProblemDetails'

    TooManyRequests:
      description: Too Many Requests
      headers:
        Retry-After:
          schema:
            type: integer
          description: Seconds to wait before retry
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ProblemDetails'
```

---

## 8. Migration Guide

### 8.1 V2 → V3 Breaking Changes

| Change | V2 | V3 | Migration Strategy |
|--------|----|----|-------------------|
| **Route rename** | `/v2/clients/{id}/objectives` | `/v3/clients/{id}/goals` | Update all API calls to new route |
| **Discriminator field** | `discriminator` | `type` | Update JSON field name in requests/responses |
| **Risk Profile** | `RiskProfile` (obsolete) | `RiskProfileNamedRef` | Use new structure with `id`, `name`, `href` |
| **Applicants** | `Applicants` array | `applicants` array (camelCase) | Update JSON casing |

### 8.2 V2 → V3 Additive Changes (Non-Breaking)

- Enhanced filtering capabilities
- New `fields` parameter for field selection
- Improved error responses (RFC 7807)
- HATEOAS links in `_links` section
- Additional goal types (Budget, EstatePlanning, EquityRelease)

### 8.3 Migration Checklist

- [ ] Update API base URLs from `/v2/` to `/v3/`
- [ ] Replace `objectives` with `goals` in all routes
- [ ] Update `discriminator` field to `type`
- [ ] Replace obsolete `RiskProfile` with `RiskProfileNamedRef`
- [ ] Update OAuth scopes if needed
- [ ] Test polymorphic goal type handling
- [ ] Update error handling for RFC 7807 format
- [ ] Implement HATEOAS link navigation (optional)
- [ ] Update event subscribers to new event types

### 8.4 Backward Compatibility

**V2 API remains available** during migration period (12-18 months).

**Dual-version support:**
- Both V2 and V3 will be operational
- Data synced automatically between versions
- Events published for both V2 and V3 consumers
- Deprecation warnings added to V2 responses

---

## Document Metadata

**Version:** 1.0
**Status:** Design Specification
**Date:** 2026-02-12
**Author:** API Architecture Team (Claude Code)
**Review Status:** Pending stakeholder review

**Related Documents:**
- `Requirements-Goals-API-Coverage.md` - V2 API analysis (10,000+ lines)
- `REQUIREMENTS-ANALYSIS-SUMMARY.md` - Quick reference
- `steering/API-Architecture-Patterns.md` - Pattern #3 Event-Driven Microservices
- `Context/API+Design+Guidelines+2.0.doc` - API design standards

**File Path:** `C:\work\FactFind-Entities\API-Contracts-V3-Goals-Risk.md`

---

**END OF V3 API CONTRACTS DOCUMENT**
