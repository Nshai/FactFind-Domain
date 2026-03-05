# Employment Summary API Design

## Overview

The Employment Summary API provides endpoints to manage aggregated employment and income information for each client within a fact find. This singleton resource per client summarizes total income and tax position.

**Base Path:** `/api/v2/factfinds/{id}/clients/{clientId}/employments/summary`

**Bounded Context:** Circumstances

**Aggregate Root:** FactFind → Client

**Version:** v2.0

**Status:** Active

---

## Business Purpose

The Employment Summary aggregates employment and income data into a single view:

1. **Income Aggregation** - Automatically calculate total gross annual income from all employment sources
2. **Tax Position** - Record the client's highest marginal tax rate
3. **Affordability Assessment** - Support mortgage and lending affordability calculations
4. **Financial Planning** - Provide quick overview of client's income position
5. **Tax Planning** - Inform tax-efficient advice based on tax bracket

### Key Use Cases

- **Mortgage Applications** - Quick access to total income for affordability assessments
- **Tax Planning** - Understand client's tax position for tax-efficient recommendations
- **Financial Reviews** - Snapshot of client's employment income position
- **Cash Flow Planning** - Input to budget and cash flow calculations
- **Capacity for Loss** - Assess client's ability to absorb investment losses

---

## API Endpoints

### 1. Get Employment Summary

Retrieve the employment summary for a specific client.

**Endpoint:** `GET /api/v2/factfinds/{id}/clients/{clientId}/employments/summary`

**Authorization:** Requires `factfind:read` scope

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | integer | Yes | The FactFind ID |
| clientId | integer | Yes | The Client ID |

**Success Response: 200 OK**

```json
{
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "client": {
    "id": 8496,
    "href": "/api/v2/factfinds/679/clients/8496",
    "name": "Jack Marias"
  },
  "totalGrossAnnualIncome": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "highestTaxRatePaid": {
    "percentage": 40
  },
  "_links": {
    "self": {
      "href": "/api/v2/factfinds/679/clients/8496/employments/summary"
    },
    "factfind": {
      "href": "/api/v2/factfinds/679"
    },
    "client": {
      "href": "/api/v2/factfinds/679/clients/8496"
    },
    "employments": {
      "href": "/api/v2/factfinds/679/clients/8496/employment"
    },
    "income": {
      "href": "/api/v2/factfinds/679/clients/8496/income"
    },
    "update": {
      "href": "/api/v2/factfinds/679/clients/8496/employments/summary"
    }
  }
}
```

**Error Responses:**

- `404 Not Found` - FactFind or client not found, or summary not yet created
- `401 Unauthorized` - Missing or invalid authentication
- `403 Forbidden` - Insufficient permissions

**Notes:**
- If the employment summary has never been created for the client, a 404 is returned
- The first PUT request will initialize the summary
- `totalGrossAnnualIncome` is automatically calculated from all income sources for the client

---

### 2. Update Employment Summary

Update or create the employment summary for a specific client. This is a singleton resource, so PUT is used for both create and update operations.

**Endpoint:** `PUT /api/v2/factfinds/{id}/clients/{clientId}/employments/summary`

**Authorization:** Requires `factfind:write` scope

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | integer | Yes | The FactFind ID |
| clientId | integer | Yes | The Client ID |

**Request Body:**

```json
{
  "highestTaxRatePaid": {
    "percentage": 40
  }
}
```

**Request Contract Fields:**

| Field | Type | Required | Description | Validation |
|-------|------|----------|-------------|------------|
| highestTaxRatePaid | object | Yes | Client's highest marginal tax rate | Must contain percentage |
| highestTaxRatePaid.percentage | integer | Yes | Tax rate percentage | Must be one of: 0, 10, 19, 20, 21, 22, 40, 41, 42, 45, 46, 47, 48 |

**Success Response: 200 OK**

```json
{
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "client": {
    "id": 8496,
    "href": "/api/v2/factfinds/679/clients/8496",
    "name": "Jack Marias"
  },
  "totalGrossAnnualIncome": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "highestTaxRatePaid": {
    "percentage": 40
  },
  "_metadata": {
    "createdAt": "2026-02-15T10:30:00Z",
    "createdBy": {
      "id": 123,
      "name": "Jane Adviser"
    },
    "updatedAt": "2026-03-05T14:22:00Z",
    "updatedBy": {
      "id": 123,
      "name": "Jane Adviser"
    },
    "version": 3
  },
  "_links": {
    "self": {
      "href": "/api/v2/factfinds/679/clients/8496/employments/summary"
    },
    "factfind": {
      "href": "/api/v2/factfinds/679"
    },
    "client": {
      "href": "/api/v2/factfinds/679/clients/8496"
    },
    "employments": {
      "href": "/api/v2/factfinds/679/clients/8496/employment"
    },
    "income": {
      "href": "/api/v2/factfinds/679/clients/8496/income"
    }
  }
}
```

**Error Responses:**

- `400 Bad Request` - Invalid request body or validation errors
- `404 Not Found` - FactFind or client not found
- `401 Unauthorized` - Missing or invalid authentication
- `403 Forbidden` - Insufficient permissions
- `422 Unprocessable Entity` - Business rule violations

---

## Contract Reference

### EmploymentSummaryContract

**Type:** Singleton Resource (one per client)

**Purpose:** Aggregated view of a client's employment income and tax position.

| Field | Type | Required | Description | Default | Read-only |
|-------|------|----------|-------------|---------|-----------|
| factfind | FactFindReference | Yes | Reference to parent fact find | Auto-set | Yes |
| client | ClientReference | Yes | Reference to client | Auto-set | Yes |
| totalGrossAnnualIncome | MoneyAmount | Yes | Total annual income from all sources | Calculated | Yes |
| highestTaxRatePaid | TaxRate | Yes | Client's highest marginal tax rate | null | No |

### FactFindReference

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | integer | Yes | FactFind ID |
| href | string | Yes | Link to FactFind resource |

### ClientReference

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | integer | Yes | Client ID |
| href | string | Yes | Link to Client resource |
| name | string | Yes | Client display name |

### MoneyAmount

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| amount | decimal | Yes | Monetary amount (2 decimal places) |
| currency | Currency | Yes | Currency information |

### Currency

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| code | string | Yes | ISO 4217 currency code (e.g., GBP, USD, EUR) |
| display | string | Yes | Human-readable currency name |
| symbol | string | Yes | Currency symbol (e.g., £, $, €) |

### TaxRate

| Field | Type | Required | Description | Valid Values |
|-------|------|----------|-------------|--------------|
| percentage | integer | Yes | Tax rate as a percentage | 0, 10, 19, 20, 21, 22, 40, 41, 42, 45, 46, 47, 48 |

---

## Business Rules

### Validation Rules

1. **Singleton Resource**
   - Only one employment summary can exist per client
   - Use PUT to create or update (idempotent)
   - GET returns 404 if not yet created

2. **Tax Rate Validation**
   - `highestTaxRatePaid.percentage` must be one of the allowed UK tax rates
   - Allowed values: 0, 10, 19, 20, 21, 22, 40, 41, 42, 45, 46, 47, 48
   - Covers: 0% (no income/personal allowance), Scottish rates (19-21%), standard UK rates (20%, 40%, 45%), and Welsh rates (various)

3. **Read-Only Fields**
   - `totalGrossAnnualIncome` is calculated and cannot be set via API
   - Calculation includes all income sources from employment and income endpoints
   - `factfind` and `client` references are set based on URL path parameters

4. **Client Validation**
   - Client must belong to the specified fact find
   - Client must exist and be active

### Calculation Logic

**Total Gross Annual Income:**
- Automatically calculated from all income sources for the client
- Includes:
  - Employment income (salary, bonuses, commissions)
  - Self-employment income
  - Rental income
  - Investment income
  - Pension income
  - Other regular income sources
- Annualized based on frequency (monthly × 12, weekly × 52, etc.)
- Updated automatically when income records are added, updated, or deleted
- Currency conversion applied if income sources are in different currencies

**Tax Rate Guidance:**
- **0%** - No taxable income or income within personal allowance
- **19%** - Scottish starter rate
- **20%** - UK basic rate / Scottish basic rate
- **21%** - Scottish intermediate rate
- **22%** - UK basic rate (historical)
- **40%** - UK higher rate / Scottish higher rate
- **41%** - Scottish higher rate (historical)
- **42%** - Scottish advanced rate / UK higher rate (historical)
- **45%** - UK additional rate / Scottish top rate
- **46%** - Scottish top rate (historical)
- **47%** - Scottish top rate (alternative)
- **48%** - Scottish top rate (alternative)

### Business Logic

**When to Update:**
- After recording all employment and income sources
- During annual reviews
- When client's tax position changes
- For mortgage applications or affordability assessments

**Impact on Other Areas:**
- Affordability calculations for mortgage applications
- Tax planning recommendations
- Investment suitability assessments
- Capacity for loss evaluations

---

## Integration Patterns

### Workflow Integration

**Step 1: Create Income Sources**
```
POST /api/v2/factfinds/{id}/clients/{clientId}/employment
POST /api/v2/factfinds/{id}/clients/{clientId}/income
```
Create employment and income records first

**Step 2: Retrieve Calculated Income**
```
GET /api/v2/factfinds/{id}/clients/{clientId}/employments/summary
```
System automatically calculates total gross annual income

**Step 3: Set Tax Rate**
```
PUT /api/v2/factfinds/{id}/clients/{clientId}/employments/summary
{
  "highestTaxRatePaid": {
    "percentage": 40
  }
}
```
Update with client's highest marginal tax rate

**Step 4: Use in Affordability Calculations**
```
GET /api/v2/factfinds/{id}/clients/{clientId}/employments/summary
```
Use total income for mortgage affordability or budget planning

### Automatic Calculation

The `totalGrossAnnualIncome` field is automatically recalculated when:
- New income source is added
- Existing income source is updated
- Income source is deleted
- Employment record is modified

**Calculation Example:**
```javascript
// Employment income: £60,000/year
// Rental income: £1,000/month = £12,000/year
// Dividends: £3,000/year
// Total: £75,000/year

// System automatically calculates and populates
totalGrossAnnualIncome: {
  amount: 75000.00,
  currency: { code: "GBP", display: "British Pound", symbol: "£" }
}
```

---

## Error Handling

### Common Error Scenarios

**400 Bad Request - Invalid Tax Rate:**

```json
{
  "status": 400,
  "title": "Validation Error",
  "detail": "Invalid tax rate percentage",
  "errors": [
    {
      "field": "highestTaxRatePaid.percentage",
      "message": "Must be one of: 0, 10, 19, 20, 21, 22, 40, 41, 42, 45, 46, 47, 48",
      "rejectedValue": 35
    }
  ]
}
```

**400 Bad Request - Missing Required Field:**

```json
{
  "status": 400,
  "title": "Validation Error",
  "detail": "highestTaxRatePaid is required",
  "errors": [
    {
      "field": "highestTaxRatePaid",
      "message": "This field is required"
    }
  ]
}
```

**404 Not Found - Summary Not Created:**

```json
{
  "status": 404,
  "title": "Resource Not Found",
  "detail": "Employment summary not found for client 8496 in fact find 679. Use PUT to create it."
}
```

**404 Not Found - Client Not Found:**

```json
{
  "status": 404,
  "title": "Resource Not Found",
  "detail": "Client with ID 8496 not found in fact find 679"
}
```

**422 Unprocessable Entity - Read-Only Field:**

```json
{
  "status": 422,
  "title": "Business Rule Violation",
  "detail": "Cannot manually set totalGrossAnnualIncome - this field is calculated automatically",
  "errors": [
    {
      "field": "totalGrossAnnualIncome",
      "message": "This field is read-only and calculated from income sources"
    }
  ]
}
```

---

## Security Considerations

### Authorization

- **Read Operations** - Require `factfind:read` scope
- **Write Operations** - Require `factfind:write` scope
- **Data Access** - Users can only access summaries for clients they are authorized to view
- **Audit Logging** - All changes logged with user ID and timestamp

### Data Protection

- Tax information is sensitive personal data
- Income data is confidential
- Follow GDPR guidelines for data retention
- Support Right to Erasure (RTBF) operations

### Validation

- Tax rate must be from allowed list
- Client must exist in fact find
- Calculated fields cannot be manually set
- Currency is validated against ISO 4217 codes

---

## Performance Considerations

### Caching

- **Cache Duration**: 5 minutes for GET operations
- **Cache Key**: `factfind:{id}:client:{clientId}:employment-summary`
- **Invalidation**: On any income/employment changes or PUT to summary
- **Conditional Requests**: Support for `If-None-Match` using ETags

### Calculation Performance

- Total income calculated asynchronously when income sources change
- Cached to avoid expensive recalculation on every GET
- Recalculation triggered by events from income/employment APIs
- Typical calculation time: < 50ms for clients with < 50 income sources

### Response Time SLAs

- `GET /employments/summary` - Target: < 100ms (p95)
- `PUT /employments/summary` - Target: < 200ms (p95)

---

## Example Scenarios

### Scenario 1: Basic Rate Taxpayer

**Create Employment Summary:**
```http
PUT /api/v2/factfinds/679/clients/8496/employments/summary
Content-Type: application/json

{
  "highestTaxRatePaid": {
    "percentage": 20
  }
}
```

**Response:**
```json
{
  "factfind": {"id": 679, "href": "/api/v2/factfinds/679"},
  "client": {
    "id": 8496,
    "href": "/api/v2/factfinds/679/clients/8496",
    "name": "Jack Marias"
  },
  "totalGrossAnnualIncome": {
    "amount": 35000.00,
    "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}
  },
  "highestTaxRatePaid": {"percentage": 20}
}
```

### Scenario 2: Higher Rate Taxpayer

**Update for Higher Rate:**
```http
PUT /api/v2/factfinds/679/clients/8496/employments/summary
Content-Type: application/json

{
  "highestTaxRatePaid": {
    "percentage": 40
  }
}
```

**Result:** Client moved into higher rate tax bracket, informing tax-efficient investment advice.

### Scenario 3: Scottish Taxpayer

**Set Scottish Intermediate Rate:**
```http
PUT /api/v2/factfinds/679/clients/8496/employments/summary
Content-Type: application/json

{
  "highestTaxRatePaid": {
    "percentage": 21
  }
}
```

**Result:** Scottish tax rate recorded for accurate tax planning.

### Scenario 4: Mortgage Application

**Retrieve Income Summary:**
```http
GET /api/v2/factfinds/679/clients/8496/employments/summary
```

**Response shows:**
- Total gross annual income: £75,000
- Tax rate: 40%
- Used for mortgage affordability calculation: £75,000 × 4.5 = £337,500 maximum borrowing

### Scenario 5: No Taxable Income

**Set Zero Tax Rate:**
```http
PUT /api/v2/factfinds/679/clients/8496/employments/summary
Content-Type: application/json

{
  "highestTaxRatePaid": {
    "percentage": 0
  }
}
```

**Result:** Client has no taxable income (e.g., retired with income below personal allowance).

---

## UK Tax Rate Reference

### England, Wales & Northern Ireland

| Rate | Band | Income Range (2024/25) |
|------|------|------------------------|
| 0% | Personal Allowance | £0 - £12,570 |
| 20% | Basic Rate | £12,571 - £50,270 |
| 40% | Higher Rate | £50,271 - £125,140 |
| 45% | Additional Rate | Over £125,140 |

### Scotland

| Rate | Band | Income Range (2024/25) |
|------|------|------------------------|
| 0% | Personal Allowance | £0 - £12,570 |
| 19% | Starter Rate | £12,571 - £14,876 |
| 20% | Basic Rate | £14,877 - £26,561 |
| 21% | Intermediate Rate | £26,562 - £43,662 |
| 42% | Higher Rate | £43,663 - £75,000 |
| 45% | Advanced Rate | £75,001 - £125,140 |
| 48% | Top Rate | Over £125,140 |

**Note:** Tax rates and bands are subject to change in annual budgets. Historical rates (10, 22, 41, 46, 47) are included for backwards compatibility with older fact finds.

---

## Related APIs

- [Client Management API](Client-API-Design.md) - Client information
- [Employment API](Employment-API-Design.md) - Detailed employment records
- [Income API](Income-API-Design.md) - Income sources that feed the calculation
- [Expenditure API](Expenditure-API-Design.md) - Related to budget/affordability
- [Affordability API](Affordability-API-Design.md) - Uses employment summary for calculations
- [FactFind API](FactFind-API-Design.md) - Parent container

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-03-05 | Initial API design for Employment Summary |

---

**Document End**
