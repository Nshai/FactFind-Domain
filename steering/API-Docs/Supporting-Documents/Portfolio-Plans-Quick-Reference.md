# Portfolio Plans API - Quick Reference Guide

**Version:** 3.0 | **Date:** 2026-02-12 | **For:** Developers & Integration Teams

---

## 🚀 Quick Start

### 1. Authentication

```http
POST /auth/token
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials&client_id=YOUR_CLIENT_ID&client_secret=YOUR_SECRET

Response:
{
  "access_token": "eyJhbGciOiJSUzI1NiIs...",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

### 2. Make Your First API Call

```http
GET /v3/clients/12345/plans/pensions
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
X-Tenant-Id: 1
```

### 3. Create a Plan

```http
POST /v3/clients/12345/plans/pensions
Authorization: Bearer {token}
X-Tenant-Id: 1
Content-Type: application/json

{
  "planTypeId": 6,
  "providerId": 123,
  "policyNumber": "SIPP-001",
  "startDate": "2026-04-06",
  "owners": [{"partyId": 12345, "ownershipPercentage": 100}],
  "regularContribution": {"amount": 500, "frequency": "Monthly"}
}
```

---

## 📋 API Endpoints Cheat Sheet

### Base URL
```
Production:  https://api.factfind.example.com/v3
Staging:     https://api-staging.factfind.example.com/v3
```

### Plan Family Endpoints

| Family | Endpoint | Types Count |
|--------|----------|-------------|
| Pensions | `/v3/clients/{clientId}/plans/pensions` | 287 |
| Protection | `/v3/clients/{clientId}/plans/protections` | 412 |
| Investments | `/v3/clients/{clientId}/plans/investments` | 523 |
| Savings | `/v3/clients/{clientId}/plans/savings` | 89 |
| Mortgages | `/v3/clients/{clientId}/plans/mortgages` | 318 |
| Loans | `/v3/clients/{clientId}/plans/loans` | 67 |
| Credit Cards | `/v3/clients/{clientId}/plans/creditcards` | 21 |
| Current Accounts | `/v3/clients/{clientId}/plans/currentaccounts` | 12 |

### CRUD Operations

```http
# List
GET    /v3/clients/{clientId}/plans/{family}

# Get
GET    /v3/clients/{clientId}/plans/{family}/{planId}

# Create
POST   /v3/clients/{clientId}/plans/{family}

# Update (full)
PUT    /v3/clients/{clientId}/plans/{family}/{planId}

# Update (partial)
PATCH  /v3/clients/{clientId}/plans/{family}/{planId}

# Delete
DELETE /v3/clients/{clientId}/plans/{family}/{planId}
```

### Reference Data

```http
# Get plan types
GET /v3/reference/plan-types?category=Pension

# Get providers
GET /v3/reference/providers?planType=6

# Get products
GET /v3/reference/products?providerId=123
```

---

## 🔑 Common Request Headers

```http
Authorization: Bearer {jwt-token}          # REQUIRED
X-Tenant-Id: {tenantId}                    # REQUIRED
Content-Type: application/json             # For POST/PUT/PATCH
If-Match: "{etag}"                         # For PUT/PATCH/DELETE
Accept: application/json                   # Optional (default)
```

---

## 📊 Query Parameters

### Filtering (OData-style)

```http
# Active plans only
?filter=status eq 'Active'

# High value plans
?filter=currentValue/amount gt 100000

# Date range
?filter=startDate ge '2020-01-01' and startDate le '2025-12-31'

# Provider filter
?filter=provider/name eq 'Aviva'

# Combine filters
?filter=status eq 'Active' and currentValue/amount gt 50000
```

**Operators:** `eq` (equal), `ne` (not equal), `gt` (greater than), `ge` (>=), `lt` (less than), `le` (<=), `and`, `or`

### Sorting

```http
# Sort by value descending
?orderBy=currentValue/amount desc

# Sort by date ascending
?orderBy=startDate asc

# Multiple sorts
?orderBy=provider/name asc, currentValue/amount desc
```

### Pagination

```http
# First page (20 items)
?limit=20

# Next page using cursor
?limit=20&cursor=eyJwbGFuSWQiOjEyMzQ1...
```

### Sparse Fieldsets

```http
# Only return specific fields
?select=planId,policyNumber,currentValue

# Nested fields
?select=planId,provider/name,currentValue/amount
```

### Combining Parameters

```http
GET /v3/clients/12345/plans/investments?
    filter=status eq 'Active'&
    orderBy=currentValue/amount desc&
    select=planId,planType/name,currentValue&
    limit=10
```

---

## 📦 Common Plan Types

### Pensions (Top 10)

| ID | Name | Use Case |
|----|------|----------|
| 6 | SIPP | Self-invested personal pension |
| 8 | Personal Pension Plan | Standard personal pension |
| 10 | Stakeholder Individual | Low-cost stakeholder |
| 15 | Group Personal Pension | Employer group scheme |
| 22 | Final Salary Scheme | Defined benefit |
| 28 | Pension Annuity | Retirement income |
| 76 | Money Purchase | Money purchase scheme |
| 145 | QROPS | Overseas pension |
| 1055 | Flexible Income Drawdown | Post-2015 drawdown |
| 1056 | Capped Income Drawdown | Pre-2015 drawdown |

### Protection (Top 10)

| ID | Name | Use Case |
|----|------|----------|
| 54 | Whole Of Life | Lifetime cover |
| 55 | Term Protection | Fixed-term cover |
| 56 | Income Protection | Salary protection |
| 91 | Critical Illness | Serious illness |
| 92 | Decreasing Term | Mortgage protection |
| 104 | Level Term | Level life cover |
| 124 | Increasing Term | Inflation-linked cover |
| 62 | Private Medical Insurance | Private healthcare |
| 99 | Building Insurance | Home insurance |
| 100 | Contents Insurance | Contents cover |

### Investments (Top 10)

| ID | Name | Use Case |
|----|------|----------|
| 1 | ISA Maxi | Tax-free ISA |
| 141 | ISA Stocks & Shares | Equity ISA |
| 142 | ISA Cash | Cash ISA |
| 31 | Unit Trust/OEIC | Collective investment |
| 32 | Investment Trust | Closed-end fund |
| 33 | Insurance/Investment Bond | Investment bond |
| 143 | Wrap | Platform account |
| 144 | General Investment Account | GIA |
| 1019 | Onshore Bond | UK bond |
| 1020 | Offshore Bond | Offshore bond |

---

## 📝 Request/Response Examples

### Create SIPP

**Request:**
```http
POST /v3/clients/12345/plans/pensions
Content-Type: application/json

{
  "planTypeId": 6,
  "providerId": 123,
  "policyNumber": "SIPP-001",
  "startDate": "2026-04-06",
  "currentValue": {"amount": 0, "currency": "GBP"},
  "regularContribution": {"amount": 500, "currency": "GBP", "frequency": "Monthly"},
  "owners": [
    {"partyId": 12345, "ownershipPercentage": 100, "salaryContributable": 50000}
  ],
  "pensionSpecific": {
    "retirementAge": 67,
    "employerContribution": {"amount": 200, "frequency": "Monthly"},
    "employeeContribution": {"amount": 300, "frequency": "Monthly"}
  }
}
```

**Response: 201 Created**
```http
Location: /v3/clients/12345/plans/pensions/67890
ETag: "1"

{
  "planId": 67890,
  "clientId": 12345,
  "planType": {"planTypeId": 6, "name": "SIPP", "category": "Pension"},
  "provider": {"providerId": 123, "name": "Aviva"},
  "status": "PendingActivation",
  "sequentialRef": "IOB00067890",
  "concurrencyId": 1,
  "_links": {
    "self": {"href": "/v3/clients/12345/plans/pensions/67890"},
    "client": {"href": "/v3/clients/12345"}
  }
}
```

### Update Plan Value (PATCH)

**Request:**
```http
PATCH /v3/clients/12345/plans/pensions/67890
If-Match: "5"
Content-Type: application/json-patch+json

[
  {"op": "replace", "path": "/currentValue/amount", "value": 125000},
  {"op": "replace", "path": "/status", "value": "Active"}
]
```

**Response: 200 OK**
```http
ETag: "6"

{
  "planId": 67890,
  "currentValue": {"amount": 125000, "currency": "GBP"},
  "status": "Active",
  "concurrencyId": 6,
  ...
}
```

### Query Active High-Value Plans

**Request:**
```http
GET /v3/clients/12345/plans/investments?filter=status eq 'Active' and currentValue/amount gt 100000&orderBy=currentValue/amount desc
```

**Response: 200 OK**
```json
{
  "items": [
    {
      "planId": 11111,
      "planType": {"name": "ISA Stocks & Shares"},
      "provider": {"name": "Aviva"},
      "currentValue": {"amount": 185000, "currency": "GBP"}
    },
    {
      "planId": 22222,
      "planType": {"name": "Wrap"},
      "provider": {"name": "Fidelity"},
      "currentValue": {"amount": 142000, "currency": "GBP"}
    }
  ],
  "pagination": {"limit": 20, "hasMore": false},
  "summary": {
    "totalPlans": 2,
    "totalValue": {"amount": 327000, "currency": "GBP"}
  }
}
```

---

## ⚠️ Error Handling

### HTTP Status Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success (GET, PUT, PATCH) | Continue |
| 201 | Created (POST) | Use Location header |
| 204 | No Content (DELETE) | Success, no body |
| 400 | Bad Request | Fix validation errors |
| 401 | Unauthorized | Refresh token |
| 403 | Forbidden | Check permissions |
| 404 | Not Found | Check IDs |
| 409 | Conflict | Refresh and retry |
| 422 | Business Rule Violation | Fix business logic |
| 429 | Too Many Requests | Back off and retry |
| 500 | Server Error | Contact support |

### Error Response Format (RFC 7807)

```json
{
  "type": "https://api.factfind.example.com/problems/validation-error",
  "title": "Validation Error",
  "status": 400,
  "detail": "One or more validation errors occurred",
  "instance": "/v3/clients/12345/plans/pensions/67890",
  "traceId": "00-4bf92f3577b34da6a3ce929d0e0e4736-00",
  "errors": {
    "startDate": ["Start date cannot be in the future"],
    "owners": ["Total ownership must equal 100%"],
    "planTypeId": ["Plan type 999 is not a valid pension plan type"]
  }
}
```

### Handling Concurrency Conflicts (409)

```javascript
async function updatePlanWithRetry(planId, updates, maxRetries = 3) {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    // Get current plan with ETag
    const current = await getPlan(planId);
    const etag = current.headers.get('ETag');

    // Attempt update
    try {
      return await updatePlan(planId, updates, etag);
    } catch (error) {
      if (error.status === 409 && attempt < maxRetries - 1) {
        // Conflict - retry with fresh data
        await new Promise(resolve => setTimeout(resolve, 100 * (attempt + 1)));
        continue;
      }
      throw error;
    }
  }
}
```

---

## 🔒 Security Best Practices

### 1. Token Management
```javascript
// Refresh token before expiry
const TOKEN_BUFFER = 60000; // 1 minute

async function getValidToken() {
  if (Date.now() >= tokenExpiry - TOKEN_BUFFER) {
    await refreshToken();
  }
  return currentToken;
}
```

### 2. Rate Limiting
```javascript
// Check rate limit headers
const remaining = response.headers.get('X-Rate-Limit-Remaining');
const reset = response.headers.get('X-Rate-Limit-Reset');

if (remaining < 10) {
  console.warn('Approaching rate limit');
}
```

### 3. Secure Storage
```javascript
// NEVER log or store tokens in plain text
// Use secure storage
const token = await secureStorage.get('api_token');
```

---

## 🎯 Common Patterns

### Load Complete Client Portfolio

```javascript
async function getClientPortfolio(clientId) {
  const families = ['pensions', 'protections', 'investments', 'savings', 'mortgages', 'loans', 'creditcards'];

  const results = await Promise.all(
    families.map(family =>
      fetch(`/v3/clients/${clientId}/plans/${family}`)
        .then(r => r.json())
    )
  );

  return {
    pensions: results[0].items,
    protections: results[1].items,
    investments: results[2].items,
    savings: results[3].items,
    mortgages: results[4].items,
    loans: results[5].items,
    creditcards: results[6].items
  };
}
```

### Paginate Through Large Collections

```javascript
async function getAllPlans(clientId, family) {
  const allPlans = [];
  let cursor = null;

  do {
    const url = `/v3/clients/${clientId}/plans/${family}?limit=100${cursor ? `&cursor=${cursor}` : ''}`;
    const response = await fetch(url);
    const data = await response.json();

    allPlans.push(...data.items);
    cursor = data.pagination.nextCursor;
  } while (data.pagination.hasMore);

  return allPlans;
}
```

### Create Plan with Validation

```javascript
async function createPlanSafely(clientId, family, planData) {
  // Validate plan type is appropriate for family
  const planType = await getPlanType(planData.planTypeId);

  if (planType.category.toLowerCase() !== family) {
    throw new Error(`Plan type ${planData.planTypeId} is not valid for ${family}`);
  }

  // Validate ownership totals 100%
  const totalOwnership = planData.owners.reduce((sum, o) => sum + o.ownershipPercentage, 0);
  if (Math.abs(totalOwnership - 100) > 0.01) {
    throw new Error(`Total ownership is ${totalOwnership}%, must be 100%`);
  }

  // Create plan
  const response = await fetch(`/v3/clients/${clientId}/plans/${family}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
      'X-Tenant-Id': tenantId
    },
    body: JSON.stringify(planData)
  });

  if (!response.ok) {
    const error = await response.json();
    throw new ValidationError(error);
  }

  return response.json();
}
```

---

## 📚 TypeScript Definitions

### Generate from OpenAPI

```bash
# Install generator
npm install -g @openapitools/openapi-generator-cli

# Generate TypeScript client
openapi-generator-cli generate \
  -i https://api.factfind.example.com/v3/openapi.json \
  -g typescript-fetch \
  -o ./src/api-client
```

### Example Type-Safe Usage

```typescript
import { PlansApi, CreatePensionPlanRequest } from './api-client';

const api = new PlansApi({
  basePath: 'https://api.factfind.example.com/v3',
  accessToken: token
});

// Type-safe request
const request: CreatePensionPlanRequest = {
  planTypeId: 6,
  providerId: 123,
  policyNumber: 'SIPP-001',
  startDate: '2026-04-06',
  owners: [
    { partyId: 12345, ownershipPercentage: 100 }
  ],
  pensionSpecific: {
    retirementAge: 67
  }
};

// Type-safe response
const plan = await api.createPensionPlan(12345, request);
console.log(plan.planId, plan.sequentialRef);
```

---

## 🧪 Testing

### Unit Test Example

```javascript
describe('Plans API', () => {
  it('should create SIPP plan', async () => {
    const mockResponse = {
      planId: 67890,
      planType: { planTypeId: 6, name: 'SIPP' }
    };

    fetch.mockResponseOnce(JSON.stringify(mockResponse), {
      status: 201,
      headers: { 'Location': '/v3/clients/12345/plans/pensions/67890' }
    });

    const result = await createPlan(12345, 'pensions', {
      planTypeId: 6,
      providerId: 123,
      policyNumber: 'SIPP-001',
      startDate: '2026-04-06',
      owners: [{ partyId: 12345, ownershipPercentage: 100 }]
    });

    expect(result.planId).toBe(67890);
    expect(result.planType.name).toBe('SIPP');
  });
});
```

### Contract Testing

```javascript
import { Pact } from '@pact-foundation/pact';

const provider = new Pact({
  consumer: 'FactFind-UI',
  provider: 'Plans-API',
  spec: 3
});

describe('Plans API Contract', () => {
  beforeAll(() => provider.setup());
  afterAll(() => provider.finalize());

  it('should get pension plan', async () => {
    await provider.addInteraction({
      state: 'plan 67890 exists',
      uponReceiving: 'a request for pension plan',
      withRequest: {
        method: 'GET',
        path: '/v3/clients/12345/plans/pensions/67890',
        headers: { 'Authorization': 'Bearer token' }
      },
      willRespondWith: {
        status: 200,
        body: {
          planId: 67890,
          planType: { planTypeId: 6, name: 'SIPP' }
        }
      }
    });

    const plan = await api.getPensionPlan(12345, 67890);
    expect(plan.planId).toBe(67890);
  });
});
```

---

## 🔧 Troubleshooting

### Issue: 401 Unauthorized

**Cause:** Invalid or expired token

**Solution:**
```javascript
// Check token expiry
const decoded = jwt.decode(token);
if (decoded.exp * 1000 < Date.now()) {
  token = await refreshToken();
}
```

### Issue: 409 Conflict

**Cause:** Stale ETag (concurrent modification)

**Solution:**
```javascript
// Always get fresh ETag before update
const current = await getPlan(planId);
const etag = current.headers.get('ETag');
await updatePlan(planId, updates, etag);
```

### Issue: 422 Business Rule Violation

**Cause:** Business validation failed

**Solution:**
```javascript
// Check error.errors for field-level details
if (error.status === 422) {
  const fieldErrors = error.errors;
  console.log('Validation errors:', fieldErrors);
  // { "owners": ["Total ownership must equal 100%"] }
}
```

### Issue: 429 Too Many Requests

**Cause:** Rate limit exceeded

**Solution:**
```javascript
// Implement exponential backoff
async function fetchWithRetry(url, options, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    const response = await fetch(url, options);

    if (response.status === 429) {
      const retryAfter = response.headers.get('Retry-After') || Math.pow(2, i);
      await new Promise(r => setTimeout(r, retryAfter * 1000));
      continue;
    }

    return response;
  }
}
```

---

## 📖 Further Reading

**Documentation:**
- Full API Specification: API-Contracts-V3-Portfolio-Plans.md
- Executive Summary: API-Contracts-V3-Portfolio-Plans-Summary.md
- Architecture Patterns: API-Architecture-Patterns.md

**Developer Portal:**
- Interactive API Explorer: https://developers.factfind.example.com
- OpenAPI Specs: https://api.factfind.example.com/v3/openapi.json
- Code Examples: https://github.com/factfind/api-examples

**Support:**
- API Support: api-support@factfind.example.com
- Developer Forum: https://forum.factfind.example.com
- Status Page: https://status.factfind.example.com
- Slack: #api-support

---

**Document Version:** 1.0
**Last Updated:** 2026-02-12
**Maintained By:** API Architecture Team

---

**Happy Coding! 🎉**
