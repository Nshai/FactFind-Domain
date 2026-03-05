# Employer Pension Scheme API Design

## Overview

The Employer Pension Scheme API provides endpoints to manage employer-sponsored pension schemes that clients may have through current or previous employment. This includes workplace pensions, occupational schemes, and auto-enrolment pensions.

**Base Path:** `/api/v2/factfinds/{id}/pensions/employerschemes`

**Bounded Context:** Plans & Investments

**Aggregate Root:** FactFind

**Version:** v2.0

**Status:** Active

---

## Business Purpose

Employer pension schemes represent workplace pension arrangements provided by employers:

1. **Current Employment Schemes** - Active workplace pensions where contributions are ongoing
2. **Deferred Schemes** - Previous employer pensions where client is no longer contributing
3. **Problem Identification** - Flag schemes with issues requiring investigation or action
4. **Consolidation Planning** - Identify schemes that may benefit from consolidation

### Key Use Cases

- **Employment Discovery** - Record all employer pension schemes during fact find
- **Contribution Tracking** - Identify active vs deferred schemes
- **Problem Detection** - Flag schemes with issues (lost pensions, disputes, unclear benefits)
- **Transfer Analysis** - Evaluate schemes for potential consolidation or transfer
- **Retirement Planning** - Include all employer schemes in retirement income projections

---

## API Endpoints

### 1. List All Employer Pension Schemes

Retrieve all employer pension schemes for a fact find.

**Endpoint:** `GET /api/v2/factfinds/{id}/pensions/employerschemes`

**Authorization:** Requires `factfind:read` scope

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | integer | Yes | The FactFind ID |

**Query Parameters:**

| Parameter | Type | Required | Description | Default |
|-----------|------|----------|-------------|---------|
| ownerId | integer | No | Filter by owner client ID | All owners |
| isCurrentMember | boolean | No | Filter by current member status | All schemes |
| isProblemMember | boolean | No | Filter by problem flag | All schemes |
| page | integer | No | Page number (1-indexed) | 1 |
| pageSize | integer | No | Items per page | 25 |
| sortBy | string | No | Sort field | schemeJoinedOn |
| sortOrder | string | No | Sort direction (asc/desc) | desc |

**Success Response: 200 OK**

```json
{
  "items": [
    {
      "id": 1234,
      "href": "/api/v2/factfinds/679/pensions/employerschemes/1234",
      "owner": {
        "id": 8496,
        "href": "/api/v2/factfinds/679/clients/8496",
        "name": "Jack Marias"
      },
      "isCurrentMember": true,
      "isProblemMember": false,
      "schemeJoinedOn": "2015-06-01",
      "details": "Acme Corp Group Personal Pension - auto-enrolment scheme"
    },
    {
      "id": 1235,
      "href": "/api/v2/factfinds/679/pensions/employerschemes/1235",
      "owner": {
        "id": 8496,
        "href": "/api/v2/factfinds/679/clients/8496",
        "name": "Jack Marias"
      },
      "isCurrentMember": false,
      "isProblemMember": true,
      "schemeJoinedOn": "2008-03-15",
      "details": "Previous employer scheme - unable to locate policy documents"
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 25,
    "totalItems": 2,
    "totalPages": 1
  },
  "_links": {
    "self": {
      "href": "/api/v2/factfinds/679/pensions/employerschemes?page=1&pageSize=25"
    },
    "factfind": {
      "href": "/api/v2/factfinds/679"
    },
    "create": {
      "href": "/api/v2/factfinds/679/pensions/employerschemes"
    }
  }
}
```

**Error Responses:**

- `404 Not Found` - FactFind not found
- `401 Unauthorized` - Missing or invalid authentication
- `403 Forbidden` - Insufficient permissions

---

### 2. Create Employer Pension Scheme

Create a new employer pension scheme record.

**Endpoint:** `POST /api/v2/factfinds/{id}/pensions/employerschemes`

**Authorization:** Requires `factfind:write` scope

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | integer | Yes | The FactFind ID |

**Request Body:**

```json
{
  "owner": {
    "id": 8496
  },
  "isCurrentMember": true,
  "isProblemMember": false,
  "schemeJoinedOn": "2015-06-01",
  "details": "Acme Corp Group Personal Pension - auto-enrolment scheme"
}
```

**Request Contract Fields:**

| Field | Type | Required | Description | Validation |
|-------|------|----------|-------------|------------|
| owner | object | Yes | Reference to the client who owns this scheme | Must reference valid client in fact find |
| owner.id | integer | Yes | Client ID | Must exist in fact find |
| isCurrentMember | boolean | Yes | Whether client is currently contributing | true or false |
| isProblemMember | boolean | Yes | Whether there are issues with this scheme | true or false |
| schemeJoinedOn | date | No | Date client joined the scheme | ISO 8601 format (YYYY-MM-DD) |
| details | string | No | Additional details about the scheme | Max 2000 characters |

**Success Response: 201 Created**

```json
{
  "id": 1234,
  "href": "/api/v2/factfinds/679/pensions/employerschemes/1234",
  "owner": {
    "id": 8496,
    "href": "/api/v2/factfinds/679/clients/8496",
    "name": "Jack Marias"
  },
  "isCurrentMember": true,
  "isProblemMember": false,
  "schemeJoinedOn": "2015-06-01",
  "details": "Acme Corp Group Personal Pension - auto-enrolment scheme",
  "_links": {
    "self": {
      "href": "/api/v2/factfinds/679/pensions/employerschemes/1234"
    },
    "factfind": {
      "href": "/api/v2/factfinds/679"
    },
    "owner": {
      "href": "/api/v2/factfinds/679/clients/8496"
    },
    "update": {
      "href": "/api/v2/factfinds/679/pensions/employerschemes/1234"
    },
    "delete": {
      "href": "/api/v2/factfinds/679/pensions/employerschemes/1234"
    }
  }
}
```

**Error Responses:**

- `400 Bad Request` - Invalid request body or validation errors
- `404 Not Found` - FactFind or owner client not found
- `401 Unauthorized` - Missing or invalid authentication
- `403 Forbidden` - Insufficient permissions
- `422 Unprocessable Entity` - Business rule violations

---

### 3. Get Employer Pension Scheme

Retrieve a specific employer pension scheme by ID.

**Endpoint:** `GET /api/v2/factfinds/{id}/pensions/employerschemes/{schemeId}`

**Authorization:** Requires `factfind:read` scope

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | integer | Yes | The FactFind ID |
| schemeId | integer | Yes | The Employer Pension Scheme ID |

**Success Response: 200 OK**

```json
{
  "id": 1234,
  "href": "/api/v2/factfinds/679/pensions/employerschemes/1234",
  "owner": {
    "id": 8496,
    "href": "/api/v2/factfinds/679/clients/8496",
    "name": "Jack Marias"
  },
  "isCurrentMember": true,
  "isProblemMember": false,
  "schemeJoinedOn": "2015-06-01",
  "details": "Acme Corp Group Personal Pension - auto-enrolment scheme",
  "_metadata": {
    "createdAt": "2026-02-15T10:30:00Z",
    "createdBy": {
      "id": 123,
      "name": "Jane Adviser"
    },
    "updatedAt": "2026-03-01T14:22:00Z",
    "updatedBy": {
      "id": 123,
      "name": "Jane Adviser"
    },
    "version": 2
  },
  "_links": {
    "self": {
      "href": "/api/v2/factfinds/679/pensions/employerschemes/1234"
    },
    "factfind": {
      "href": "/api/v2/factfinds/679"
    },
    "owner": {
      "href": "/api/v2/factfinds/679/clients/8496"
    },
    "employment": {
      "href": "/api/v2/factfinds/679/clients/8496/employment"
    },
    "update": {
      "href": "/api/v2/factfinds/679/pensions/employerschemes/1234"
    },
    "delete": {
      "href": "/api/v2/factfinds/679/pensions/employerschemes/1234"
    }
  }
}
```

**Error Responses:**

- `404 Not Found` - FactFind or scheme not found
- `401 Unauthorized` - Missing or invalid authentication
- `403 Forbidden` - Insufficient permissions

---

### 4. Update Employer Pension Scheme

Update an existing employer pension scheme (partial update).

**Endpoint:** `PATCH /api/v2/factfinds/{id}/pensions/employerschemes/{schemeId}`

**Authorization:** Requires `factfind:write` scope

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | integer | Yes | The FactFind ID |
| schemeId | integer | Yes | The Employer Pension Scheme ID |

**Request Body (all fields optional):**

```json
{
  "isCurrentMember": false,
  "isProblemMember": false,
  "details": "Scheme transferred to new provider on 2026-03-01"
}
```

**Request Contract Fields:**

| Field | Type | Required | Description | Validation |
|-------|------|----------|-------------|------------|
| owner | object | No | Change scheme owner | Must reference valid client in fact find |
| owner.id | integer | Conditional | Client ID | Required if owner provided |
| isCurrentMember | boolean | No | Update current member status | true or false |
| isProblemMember | boolean | No | Update problem flag | true or false |
| schemeJoinedOn | date | No | Update join date | ISO 8601 format (YYYY-MM-DD) |
| details | string | No | Update scheme details | Max 2000 characters |

**Success Response: 200 OK**

```json
{
  "id": 1234,
  "href": "/api/v2/factfinds/679/pensions/employerschemes/1234",
  "owner": {
    "id": 8496,
    "href": "/api/v2/factfinds/679/clients/8496",
    "name": "Jack Marias"
  },
  "isCurrentMember": false,
  "isProblemMember": false,
  "schemeJoinedOn": "2015-06-01",
  "details": "Scheme transferred to new provider on 2026-03-01",
  "_metadata": {
    "createdAt": "2026-02-15T10:30:00Z",
    "createdBy": {
      "id": 123,
      "name": "Jane Adviser"
    },
    "updatedAt": "2026-03-05T09:15:00Z",
    "updatedBy": {
      "id": 123,
      "name": "Jane Adviser"
    },
    "version": 3
  },
  "_links": {
    "self": {
      "href": "/api/v2/factfinds/679/pensions/employerschemes/1234"
    },
    "factfind": {
      "href": "/api/v2/factfinds/679"
    },
    "owner": {
      "href": "/api/v2/factfinds/679/clients/8496"
    }
  }
}
```

**Error Responses:**

- `400 Bad Request` - Invalid request body or validation errors
- `404 Not Found` - FactFind or scheme not found
- `401 Unauthorized` - Missing or invalid authentication
- `403 Forbidden` - Insufficient permissions
- `409 Conflict` - Version conflict (optimistic concurrency)
- `422 Unprocessable Entity` - Business rule violations

---

### 5. Delete Employer Pension Scheme

Delete an employer pension scheme record.

**Endpoint:** `DELETE /api/v2/factfinds/{id}/pensions/employerschemes/{schemeId}`

**Authorization:** Requires `factfind:write` scope

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | integer | Yes | The FactFind ID |
| schemeId | integer | Yes | The Employer Pension Scheme ID |

**Success Response: 204 No Content**

No response body.

**Error Responses:**

- `404 Not Found` - FactFind or scheme not found
- `401 Unauthorized` - Missing or invalid authentication
- `403 Forbidden` - Insufficient permissions
- `409 Conflict` - Scheme cannot be deleted due to dependencies

---

## Contract Reference

### EmployerPensionSchemeContract

**Type:** Entity (part of FactFind aggregate)

**Purpose:** Records employer-sponsored pension schemes from current or previous employment.

| Field | Type | Required | Description | Default |
|-------|------|----------|-------------|---------|
| id | integer | Yes (response) | Unique system identifier | Auto-generated |
| href | string | Yes (response) | API link to this resource | Auto-generated |
| owner | ClientReference | Yes | Client who owns this scheme | null |
| isCurrentMember | boolean | Yes | Whether client is currently contributing | false |
| isProblemMember | boolean | Yes | Whether there are issues with this scheme | false |
| schemeJoinedOn | date | No | Date client joined the scheme | null |
| details | string | No | Additional details about the scheme | null |

### ClientReference

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | integer | Yes | Client ID |
| href | string | Yes (response) | Link to client resource |
| name | string | Yes (response) | Client display name |

---

## Business Rules

### Validation Rules

1. **Owner Validation**
   - Owner must reference a valid client within the same fact find
   - Owner cannot be changed to a client outside the fact find
   - Owner is required when creating a scheme

2. **Status Flags**
   - `isCurrentMember` must be explicitly set to true or false
   - `isProblemMember` must be explicitly set to true or false
   - Both flags can be true simultaneously

3. **Date Validation**
   - `schemeJoinedOn` must be a valid date in the past or present
   - `schemeJoinedOn` cannot be in the future
   - Format must be ISO 8601 (YYYY-MM-DD)

4. **Details Field**
   - Maximum length: 2000 characters
   - Optional but recommended for problem schemes
   - Should explain the issue if `isProblemMember` is true

### Business Logic

**Current Member Status:**
- `isCurrentMember = true` indicates active contributions are ongoing
- `isCurrentMember = false` indicates deferred/paid-up scheme
- Should align with client's current employment status

**Problem Member Flag:**
- Use `isProblemMember = true` for:
  - Lost or untraceable pensions
  - Schemes with incomplete information
  - Disputes or unresolved issues
  - Schemes requiring investigation
- When flagged, `details` should explain the issue

**Scheme Dating:**
- `schemeJoinedOn` helps determine:
  - Length of service
  - Potential accrued benefits
  - Transfer value estimates
  - Priority for investigation

### Compliance Considerations

**Pension Tracing Service:**
- Problem schemes may require Pension Tracing Service search
- Document all attempts to locate lost pensions

**Transfer Analysis:**
- Consider transfer value analysis for deferred schemes
- Evaluate consolidation benefits
- Document advice given

**Auto-Enrolment:**
- Current employer schemes subject to auto-enrolment regulations
- Minimum contribution requirements apply

---

## Integration Patterns

### Workflow Integration

**Step 1: Discover Employment History**
```
GET /api/v2/factfinds/{id}/clients/{clientId}/employment
```
Identify all current and previous employers

**Step 2: Record Employer Schemes**
```
POST /api/v2/factfinds/{id}/pensions/employerschemes
```
Create scheme record for each employer pension

**Step 3: Flag Problem Schemes**
```
PATCH /api/v2/factfinds/{id}/pensions/employerschemes/{schemeId}
{
  "isProblemMember": true,
  "details": "Unable to obtain policy documents from provider"
}
```

**Step 4: Retrieve All Schemes**
```
GET /api/v2/factfinds/{id}/pensions/employerschemes?ownerId={clientId}
```
Get complete list for retirement planning

### UI Behavior

```javascript
// Example: Displaying schemes with status indicators
const schemes = await fetchEmployerPensionSchemes(factfindId);

schemes.items.forEach(scheme => {
  displayScheme(scheme, {
    statusIcon: scheme.isCurrentMember ? 'active' : 'deferred',
    alertFlag: scheme.isProblemMember ? 'warning' : null,
    tooltip: scheme.details
  });
});

// Filter for problem schemes requiring action
const problemSchemes = schemes.items.filter(s => s.isProblemMember);
showActionRequired(problemSchemes);
```

---

## Error Handling

### Common Error Scenarios

**400 Bad Request - Invalid Owner:**

```json
{
  "status": 400,
  "title": "Validation Error",
  "detail": "Owner client does not exist in this fact find",
  "errors": [
    {
      "field": "owner.id",
      "message": "Client ID 9999 not found in fact find 679",
      "rejectedValue": 9999
    }
  ]
}
```

**400 Bad Request - Invalid Date:**

```json
{
  "status": 400,
  "title": "Validation Error",
  "detail": "Scheme join date cannot be in the future",
  "errors": [
    {
      "field": "schemeJoinedOn",
      "message": "Date must be in the past or present",
      "rejectedValue": "2027-01-01"
    }
  ]
}
```

**422 Unprocessable Entity - Business Rule Violation:**

```json
{
  "status": 422,
  "title": "Business Rule Violation",
  "detail": "Problem schemes should include details explaining the issue",
  "errors": [
    {
      "field": "details",
      "message": "Details field is required when isProblemMember is true",
      "rejectedValue": null
    }
  ]
}
```

**404 Not Found:**

```json
{
  "status": 404,
  "title": "Resource Not Found",
  "detail": "Employer pension scheme with ID 1234 not found in fact find 679"
}
```

---

## Security Considerations

### Authorization

- **Read Operations** - Require `factfind:read` scope
- **Write Operations** - Require `factfind:write` scope
- **Data Access** - Users can only access schemes in fact finds they are authorized for
- **Audit Logging** - All changes logged with user ID and timestamp

### Data Protection

- Scheme details may contain sensitive information
- Follow GDPR guidelines for data retention
- Support Right to Erasure (RTBF) operations
- Encrypt sensitive fields at rest

### Validation

- All required fields must be provided
- Owner references are validated against fact find clients
- Dates are validated for format and logical constraints
- String fields have maximum length limits

---

## Performance Considerations

### Caching

- **Cache Duration**: 5 minutes for list operations
- **Cache Key**: `factfind:{id}:employerschemes`
- **Invalidation**: On any write operation (POST, PATCH, DELETE)
- **Conditional Requests**: Support for `If-None-Match` using ETags

### Response Time SLAs

- `GET /employerschemes` (list) - Target: < 200ms (p95)
- `GET /employerschemes/{id}` (single) - Target: < 100ms (p95)
- `POST /employerschemes` - Target: < 300ms (p95)
- `PATCH /employerschemes/{id}` - Target: < 250ms (p95)
- `DELETE /employerschemes/{id}` - Target: < 200ms (p95)

### Pagination

- Default page size: 25 items
- Maximum page size: 100 items
- Use cursor-based pagination for large datasets
- Include total count in pagination metadata

---

## Example Scenarios

### Scenario 1: Current Employee with Active Scheme

**Create Active Employer Scheme:**
```http
POST /api/v2/factfinds/679/pensions/employerschemes
Content-Type: application/json

{
  "owner": {
    "id": 8496
  },
  "isCurrentMember": true,
  "isProblemMember": false,
  "schemeJoinedOn": "2020-03-01",
  "details": "TechCorp Ltd Group Personal Pension - Scottish Widows. Employee contributes 5%, employer contributes 3%. Platform access available online."
}
```

**Result:** Active scheme recorded with full details for ongoing contributions.

### Scenario 2: Lost Pension from Previous Employment

**Create Problem Scheme:**
```http
POST /api/v2/factfinds/679/pensions/employerschemes
Content-Type: application/json

{
  "owner": {
    "id": 8496
  },
  "isCurrentMember": false,
  "isProblemMember": true,
  "schemeJoinedOn": "2005-06-01",
  "details": "Previous employer: ABC Manufacturing Ltd (now dissolved). Unable to locate pension provider. Pension Tracing Service search initiated 2026-03-01. Client recalls contributions made for approximately 3 years."
}
```

**Result:** Problem scheme flagged for investigation and follow-up action.

### Scenario 3: Multiple Employer Schemes for Consolidation

**List All Client Schemes:**
```http
GET /api/v2/factfinds/679/pensions/employerschemes?ownerId=8496
```

**Response shows:**
- 1 current active scheme
- 3 deferred schemes from previous employers
- Total value estimation needed for consolidation analysis

### Scenario 4: Update Scheme Status After Transfer

**Update to Reflect Transfer:**
```http
PATCH /api/v2/factfinds/679/pensions/employerschemes/1234
Content-Type: application/json

{
  "isCurrentMember": false,
  "details": "Scheme transferred to consolidated SIPP on 2026-03-05. Transfer value: £45,000. Original scheme now closed."
}
```

**Result:** Scheme marked as inactive with transfer details documented.

---

## Related APIs

- [Client API](Client-API-Design.md) - Owner client information
- [Employment API](Employment-API-Design.md) - Employment history that generated schemes
- [Personal Pension API](PersonalPension-API-Design.md) - Personal pensions (non-employer)
- [Final Salary Pension API](FinalSalaryPension-API-Design.md) - Defined benefit employer schemes
- [Control Questions API](Control-Questions-API-Design.md) - Controls whether pension section is shown
- [FactFind API](FactFind-API-Design.md) - Parent container

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-03-05 | Initial API design for Employer Pension Schemes |

---

**Document End**
