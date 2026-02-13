# V3 API Quick Start Guide
## 5-Minute Getting Started with V3 APIs

**Document Version:** 1.0
**Date:** 2026-02-12
**Audience:** Developers new to V3 APIs
**Time Required:** 5-10 minutes

---

## Welcome to V3 APIs

This guide will get you up and running with V3 APIs in 5 minutes. For complete specifications, see `V3-API-Contracts-Master-Specification.md`.

### What's New in V3?

**Building on 81% Existing Coverage:**
- Portfolio Plans API (1,773 plan types) - Already production-ready
- Requirements Microservice (Goals & Risk) - Modern architecture
- Employment & Income APIs - Gold standard
- **V3 fills the remaining 19% gaps** with targeted enhancements

**Key V3 Improvements:**
- Consistent patterns across all domains
- Complete regulatory compliance support
- Enhanced developer experience
- 95%+ API coverage

---

## Step 1: Authentication (2 minutes)

### Get Your OAuth 2.0 Token

**1. Register Your Application**

Contact API support to register your application and receive:
- Client ID
- Client Secret
- Redirect URI

**2. Authorization Code Flow**

```bash
# Step 1: Get authorization code
https://auth.intelliflo.com/oauth/authorize?
  client_id=YOUR_CLIENT_ID&
  response_type=code&
  redirect_uri=YOUR_REDIRECT_URI&
  scope=crm:read factfind:read portfolio:read requirements:read

# Step 2: Exchange code for token
curl -X POST https://auth.intelliflo.com/oauth/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=authorization_code" \
  -d "code=AUTHORIZATION_CODE" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET" \
  -d "redirect_uri=YOUR_REDIRECT_URI"
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "refresh_token_here",
  "scope": "crm:read factfind:read portfolio:read requirements:read"
}
```

### OAuth Scopes

| Scope | Permission |
|-------|------------|
| `crm:read` | Read client profile data |
| `crm:write` | Create/update client profiles |
| `factfind:read` | Read FactFind data |
| `factfind:write` | Create/update FactFind data |
| `portfolio:read` | Read plans and portfolio data |
| `portfolio:write` | Create/update plans |
| `requirements:read` | Read goals and risk assessments |
| `requirements:write` | Create/update goals |

---

## Step 2: Your First API Call (1 minute)

### Get a Client

```bash
curl -X GET https://api.intelliflo.com/v3/clients/5000 \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Accept: application/json"
```

**Response:**
```json
{
  "id": 5000,
  "href": "/v3/clients/5000",
  "partyType": "Person",
  "person": {
    "title": "Mr",
    "firstName": "John",
    "lastName": "Smith",
    "dateOfBirth": "1985-03-15"
  },
  "currentAdviser": {
    "id": 789,
    "name": "Jane Advisor",
    "href": "/v3/advisers/789"
  },
  "_links": {
    "self": { "href": "/v3/clients/5000" },
    "employments": { "href": "/v3/factfind/financial/clients/5000/employments" },
    "goals": { "href": "/v3/clients/5000/goals" },
    "plans": { "href": "/v3/plans?clientId=5000" }
  }
}
```

### List Client Employments

```bash
curl -X GET https://api.intelliflo.com/v3/factfind/financial/clients/5000/employments \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Accept: application/json"
```

**Response:**
```json
{
  "data": [
    {
      "id": 456,
      "status": "Employed",
      "employer": "ACME Corporation",
      "occupation": "Software Engineer",
      "startsOn": "2020-01-01",
      "basicAnnualIncome": {
        "value": 75000.00,
        "currency": "GBP"
      },
      "_links": {
        "self": { "href": "/v3/factfind/financial/clients/5000/employments/456" },
        "incomes": { "href": "/v3/factfind/financial/clients/5000/incomes?employmentId=456" }
      }
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 100,
    "totalCount": 1
  }
}
```

---

## Step 3: Create a Resource (1 minute)

### Create an Income

```bash
curl -X POST https://api.intelliflo.com/v3/factfind/financial/clients/5000/incomes \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "employmentId": 456,
    "category": "BasicAnnualIncome",
    "description": "Base Salary",
    "gross": {
      "value": 75000.00,
      "currency": "GBP"
    },
    "net": {
      "value": 55000.00,
      "currency": "GBP"
    },
    "frequency": "Annually",
    "includeInAffordability": true,
    "startsOn": "2020-01-01"
  }'
```

**Response:**
```json
{
  "id": 789,
  "employmentId": 456,
  "category": "BasicAnnualIncome",
  "description": "Base Salary",
  "gross": {
    "value": 75000.00,
    "currency": "GBP"
  },
  "net": {
    "value": 55000.00,
    "currency": "GBP"
  },
  "frequency": "Annually",
  "grossMonthly": {
    "value": 6250.00,
    "currency": "GBP"
  },
  "netMonthly": {
    "value": 4583.33,
    "currency": "GBP"
  },
  "includeInAffordability": true,
  "startsOn": "2020-01-01",
  "_links": {
    "self": { "href": "/v3/factfind/financial/clients/5000/incomes/789" },
    "employment": { "href": "/v3/factfind/financial/clients/5000/employments/456" }
  }
}
```

---

## Step 4: Update a Resource (1 minute)

### Update with Optimistic Concurrency (ETag)

**1. Get resource with ETag:**
```bash
curl -X GET https://api.intelliflo.com/v3/factfind/financial/clients/5000/incomes/789 \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Response Headers:**
```
ETag: "abc123def456"
```

**2. Update with If-Match header:**
```bash
curl -X PUT https://api.intelliflo.com/v3/factfind/financial/clients/5000/incomes/789 \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -H "If-Match: \"abc123def456\"" \
  -d '{
    "employmentId": 456,
    "category": "BasicAnnualIncome",
    "description": "Base Salary (Updated)",
    "gross": {
      "value": 80000.00,
      "currency": "GBP"
    },
    "net": {
      "value": 58000.00,
      "currency": "GBP"
    },
    "frequency": "Annually",
    "includeInAffordability": true,
    "startsOn": "2020-01-01"
  }'
```

**Success Response:**
```
HTTP/1.1 200 OK
ETag: "xyz789uvw012"
```

**Conflict Response (if resource changed):**
```json
HTTP/1.1 409 Conflict

{
  "type": "https://api.intelliflo.com/problems/concurrent-modification",
  "title": "Concurrent Modification Detected",
  "status": 409,
  "detail": "The resource has been modified by another user",
  "instance": "/v3/factfind/financial/clients/5000/incomes/789",
  "currentETag": "different_etag"
}
```

---

## Common Patterns

### Pattern 1: Pagination

**Cursor-Based Pagination:**

```bash
# First page
curl -X GET https://api.intelliflo.com/v3/factfind/financial/clients/5000/incomes?limit=20

# Next page (use nextCursor from previous response)
curl -X GET https://api.intelliflo.com/v3/factfind/financial/clients/5000/incomes?limit=20&cursor=eyJpZCI6NDU2fQ==
```

**Response:**
```json
{
  "data": [...],
  "pagination": {
    "limit": 20,
    "hasMore": true,
    "nextCursor": "eyJpZCI6NDc2fQ=="
  },
  "_links": {
    "next": { "href": "/v3/factfind/financial/clients/5000/incomes?limit=20&cursor=eyJpZCI6NDc2fQ==" }
  }
}
```

### Pattern 2: Filtering

**Simple Filtering:**
```bash
curl -X GET "https://api.intelliflo.com/v3/factfind/financial/clients/5000/incomes?includeInAffordability=true&frequency=Monthly"
```

**OData Filtering:**
```bash
curl -X GET "https://api.intelliflo.com/v3/factfind/financial/clients/5000/incomes?$filter=includeInAffordability eq true and gross/value gt 1000"
```

### Pattern 3: Sorting

```bash
curl -X GET "https://api.intelliflo.com/v3/factfind/financial/clients/5000/incomes?orderBy=startsOn desc"
```

### Pattern 4: Field Selection

```bash
curl -X GET "https://api.intelliflo.com/v3/factfind/financial/clients/5000/incomes?fields=id,description,grossMonthly"
```

### Pattern 5: HATEOAS Navigation

**Follow links in `_links` section:**

```json
{
  "id": 456,
  "_links": {
    "self": { "href": "/v3/factfind/financial/clients/5000/employments/456" },
    "incomes": { "href": "/v3/factfind/financial/clients/5000/incomes?employmentId=456" },
    "client": { "href": "/v3/clients/5000" }
  }
}
```

**Navigate to related resources:**
```bash
# Follow "incomes" link
curl -X GET https://api.intelliflo.com/v3/factfind/financial/clients/5000/incomes?employmentId=456 \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

---

## Error Handling

### Standard Error Response (RFC 7807)

```json
{
  "type": "https://api.intelliflo.com/problems/validation-error",
  "title": "Validation Failed",
  "status": 400,
  "detail": "The request contains invalid data",
  "instance": "/v3/factfind/financial/clients/5000/incomes",
  "errors": [
    {
      "field": "gross.value",
      "code": "RANGE_ERROR",
      "message": "Gross amount cannot be negative",
      "rejectedValue": -5000
    },
    {
      "field": "frequency",
      "code": "INVALID_ENUM",
      "message": "Invalid frequency. Valid values: Weekly, Monthly, Annually",
      "rejectedValue": "Daily"
    }
  ]
}
```

### Common Error Status Codes

| Status | Error Type | Description |
|--------|------------|-------------|
| 400 | Bad Request | Invalid request format or validation error |
| 401 | Unauthorized | Authentication required or failed |
| 403 | Forbidden | Authenticated but not authorized |
| 404 | Not Found | Resource does not exist |
| 409 | Conflict | Concurrent modification or business rule violation |
| 412 | Precondition Failed | Missing If-Match header |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unexpected server error |

---

## Working with Polymorphic Resources

### Portfolio Plans (1,773 Types)

**Create a Pension Plan:**

```bash
curl -X POST https://api.intelliflo.com/v3/plans/pensions \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "discriminator": "PersonalPension",
    "planNumber": "PP123456",
    "provider": { "id": 100 },
    "status": "Active",
    "client": { "id": 5000 },
    "personalPension": {
      "pensionType": "SIPP",
      "taxRelief": "NetPay",
      "contributionAmount": {
        "value": 500.00,
        "currency": "GBP"
      },
      "contributionFrequency": "Monthly"
    }
  }'
```

### Goals (7 Types)

**Create an Investment Goal:**

```bash
curl -X POST https://api.intelliflo.com/v3/clients/5000/goals \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "investment",
    "category": "Savings",
    "summary": "Retirement nest egg",
    "targetAmount": {
      "value": 500000.00,
      "currency": "GBP"
    },
    "targetDate": "2040-12-31",
    "riskProfile": { "id": 5 }
  }'
```

---

## SDK Support

### TypeScript/JavaScript

```bash
npm install @intelliflo/api-client
```

```typescript
import { IntelliFlo ApiClient } from '@intelliflo/api-client';

const client = new IntelliFloApiClient({
  accessToken: 'YOUR_ACCESS_TOKEN',
  baseUrl: 'https://api.intelliflo.com'
});

// Get client
const clientData = await client.clients.get(5000);

// List employments
const employments = await client.factfind.employments.list(5000);

// Create income
const income = await client.factfind.incomes.create(5000, {
  employmentId: 456,
  category: 'BasicAnnualIncome',
  gross: { value: 75000.00, currency: 'GBP' }
});
```

### C#

```bash
dotnet add package IntelliFloe.Api.Client
```

```csharp
using IntelliFloe.Api.Client;

var client = new IntelliFloApiClient(
    accessToken: "YOUR_ACCESS_TOKEN",
    baseUrl: "https://api.intelliflo.com"
);

// Get client
var clientData = await client.Clients.GetAsync(5000);

// List employments
var employments = await client.FactFind.Employments.ListAsync(5000);

// Create income
var income = await client.FactFind.Incomes.CreateAsync(5000, new IncomeCreateRequest
{
    EmploymentId = 456,
    Category = "BasicAnnualIncome",
    Gross = new Money { Value = 75000.00m, Currency = "GBP" }
});
```

### Python

```bash
pip install intelliflo-api-client
```

```python
from intelliflo_api_client import IntelliFloApiClient

client = IntelliFloApiClient(
    access_token="YOUR_ACCESS_TOKEN",
    base_url="https://api.intelliflo.com"
)

# Get client
client_data = client.clients.get(5000)

# List employments
employments = client.factfind.employments.list(5000)

# Create income
income = client.factfind.incomes.create(5000, {
    'employmentId': 456,
    'category': 'BasicAnnualIncome',
    'gross': {'value': 75000.00, 'currency': 'GBP'}
})
```

---

## Troubleshooting

### Problem: 401 Unauthorized

**Cause:** Missing or invalid access token

**Solution:**
```bash
# Check token in request
curl -X GET https://api.intelliflo.com/v3/clients/5000 \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -v

# Refresh token if expired
curl -X POST https://auth.intelliflo.com/oauth/token \
  -d "grant_type=refresh_token" \
  -d "refresh_token=YOUR_REFRESH_TOKEN" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET"
```

### Problem: 403 Forbidden

**Cause:** Insufficient OAuth scopes

**Solution:** Request additional scopes during authorization

```
# Add required scopes
scope=crm:read crm:write factfind:read factfind:write
```

### Problem: 404 Not Found

**Cause:** Resource does not exist or incorrect URL

**Solution:**
```bash
# Verify resource exists
curl -X HEAD https://api.intelliflo.com/v3/clients/5000 \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# Check URL structure
# Correct: /v3/clients/5000
# Incorrect: /v2/clients/5000 (wrong version)
# Incorrect: /v3/client/5000 (singular, should be plural)
```

### Problem: 409 Conflict

**Cause:** Concurrent modification (ETag mismatch)

**Solution:**
```bash
# 1. Refetch resource to get latest ETag
GET /v3/clients/5000/incomes/789

# 2. Retry update with new ETag
PUT /v3/clients/5000/incomes/789
If-Match: "new_etag"
```

### Problem: 429 Too Many Requests

**Cause:** Rate limit exceeded

**Solution:**
```bash
# Check rate limit headers
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1738266000

# Wait until reset time
# Implement exponential backoff
```

### Problem: 500 Internal Server Error

**Cause:** Server error

**Solution:**
```bash
# Check status page
https://status.intelliflo.com

# Retry with exponential backoff
# Contact support if persistent
```

---

## Next Steps

### Learn More

1. **Master Specification:** Read `V3-API-Contracts-Master-Specification.md` for complete documentation

2. **Domain-Specific Guides:**
   - `API-Contracts-V3-Client-Profile.md` - Client Profile APIs
   - `API-Contracts-V3-FactFind-Core.md` - FactFind APIs
   - `API-Contracts-V3-Portfolio-Plans.md` - Portfolio Plans
   - `API-Contracts-V3-Goals-Risk.md` - Goals & Risk

3. **API Design Standards:** Read `API-Design-Guidelines-Summary.md` for patterns and conventions

### Useful Links

**Documentation:**
- Developer Portal: https://developer.intelliflo.com/v3
- API Reference: https://developer.intelliflo.com/v3/reference
- OpenAPI Specs: https://developer.intelliflo.com/v3/specs

**Tools:**
- Postman Collection: https://api.intelliflo.com/v3/postman
- API Explorer: https://developer.intelliflo.com/v3/explorer
- SDK Downloads: https://developer.intelliflo.com/sdks

**Support:**
- Email: api-support@intelliflo.com
- Status Page: https://status.intelliflo.com
- Slack: #api-v3-support
- Office Hours: Thursdays 2pm-4pm GMT

### Sample Applications

**GitHub Repositories:**
- TypeScript/React Example: https://github.com/intelliflo/v3-api-examples-typescript
- C#/.NET Example: https://github.com/intelliflo/v3-api-examples-dotnet
- Python Example: https://github.com/intelliflo/v3-api-examples-python

---

## Quick Reference Card

**Base URL:** `https://api.intelliflo.com`

**Authentication:** OAuth 2.0 Bearer Token
```
Authorization: Bearer YOUR_ACCESS_TOKEN
```

**Content Type:**
```
Content-Type: application/json
Accept: application/json
```

**Common Endpoints:**
```
GET    /v3/clients/{id}
GET    /v3/factfind/financial/clients/{id}/employments
GET    /v3/factfind/financial/clients/{id}/incomes
POST   /v3/factfind/financial/clients/{id}/incomes
GET    /v3/clients/{id}/goals
GET    /v3/plans/pensions
```

**Rate Limits:**
- 1000 requests/hour per user
- 100 requests/minute burst

**Support:** api-support@intelliflo.com

---

## Document Metadata

**Version:** 1.0
**Date:** 2026-02-12
**Audience:** Developers
**Estimated Reading Time:** 5-10 minutes
**Prerequisites:** Basic REST API knowledge, OAuth 2.0 familiarity

**Related Documents:**
- `V3-API-Contracts-Master-Specification.md` - Complete specification
- `V3-API-Governance-Framework.md` - Standards and governance
- `API-Design-Guidelines-Summary.md` - Design patterns

**File Path:** `C:\work\FactFind-Entities\V3-API-Contracts-Quick-Start.md`

---

**END OF QUICK START GUIDE**

You're now ready to build with V3 APIs! For detailed specifications and advanced patterns, proceed to the master specification document.
