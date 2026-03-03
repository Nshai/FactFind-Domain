# FactFind System API Design Specification v3.0
## Comprehensive RESTful API for Wealth Management Platform

**Date:** 2026-03-03
**Status:** Active Specification
**API Version:** v2
**Base URL:** `https://api.factfind.com`
**Document Version:** 3.0

---

## Document Information

**Previous Versions:**
- v1.0 - Initial API design (2025-12-15)
- v2.0 - Added comprehensive entity APIs (2026-02-19)
- v3.0 - Consolidated all comprehensive APIs with latest contracts (2026-03-03)

**Changes in v3.0:**
- Consolidated 34 comprehensive API designs into single specification
- Updated all contracts to align with FactFind-Contracts-Reference.md
- Updated all endpoints to align with API-Endpoints-Catalog.md
- Removed legacy arrangement and sub-arrangement APIs
- Added State Pension API (Section 29)
- Added Liability API (Section 23)
- Updated all examples with latest contract schemas
- Enhanced business rules and validation guidance
- Improved regulatory compliance documentation

---

## Executive Summary

This document presents a comprehensive RESTful API design for the FactFind system, a wealth management platform built on Domain-Driven Design (DDD) principles. The API architecture follows industry best practices and provides complete coverage of all business capabilities required for modern financial advisory services.

### Overview

**Business Domain:** Wealth Management & Financial Advisory
**Total Entities:** 50+ entities across 8 bounded contexts
**Total API Endpoints:** 268 endpoints (was 263, added 5 liability endpoints)
**Total API Sections:** 34 comprehensive API specifications
**Total Fields:** 2,000+ business fields from domain specification
**Regulatory Compliance:** FCA Handbook, MiFID II, IDD, Consumer Duty, GDPR, MLR 2017, PECR

### API Scope

The FactFind API provides comprehensive digital capabilities for:

1. **FactFind Root API** - Fact find lifecycle and aggregated views (11 endpoints)
2. **Client Onboarding & KYC** - Client management, identity verification, regulatory compliance (105 endpoints)
3. **Circumstances Context** - Employment, income, expenditure tracking (26 endpoints)
4. **Assets & Liabilities** - Property, assets, liabilities management (23 endpoints)
5. **Plans & Investments** - Pensions, investments, protection, mortgages (35 endpoints)
6. **Goals & Objectives** - Financial goal setting and tracking (31 endpoints)
7. **ATR Context** - Attitude to risk assessment (8 endpoints)
8. **Reference Data API** - Centralized lookup data management (24 endpoints)

### Key Features

- **RESTful Architecture** - Resource-oriented design with proper HTTP semantics
- **Single Contract Principle** - One unified contract per entity for create, update, and response operations
- **Hierarchical Organization** - APIs organized around DDD aggregates for transactional consistency
- **HATEOAS Level 3** - Hypermedia controls for API discoverability
- **Comprehensive Validation** - Business rules and field-level validation
- **Production-Ready** - Complete request/response contracts with examples
- **FCA-Compliant** - Aligned with UK financial services regulations
- **Multi-Tenancy** - Built-in tenant isolation for SaaS deployment
- **Event-Driven** - Domain events for loose coupling and integration

### Target Audience

- **API Consumers:** Frontend developers, mobile app developers, integration partners
- **Backend Developers:** Implementation teams building the API services
- **Product Owners:** Business stakeholders understanding API capabilities
- **Architects:** System designers reviewing architectural decisions
- **Compliance Teams:** Regulatory compliance verification

---

## Table of Contents

### Part 1: Foundation & Standards

1. [API Design Principles](#1-api-design-principles)
   - 1.1 RESTful Architecture
   - 1.2 Naming Conventions
   - 1.3 HTTP Methods & Status Codes
   - 1.4 Error Response Format
   - 1.5 Hierarchical Architecture
   - 1.6 Versioning Strategy
   - 1.7 Single Contract Principle
   - 1.8 Value and Reference Type Semantics
   - 1.9 Aggregate Root Pattern

2. [Authentication & Authorization](#2-authentication--authorization)
   - 2.1 OAuth 2.0 with JWT
   - 2.2 Authorization Scopes
   - 2.3 Multi-Tenancy
   - 2.4 Sensitive Data Handling
   - 2.5 Audit Logging

3. [Common Patterns](#3-common-patterns)
   - 3.1 Pagination
   - 3.2 Filtering & Sorting
   - 3.3 Field Selection
   - 3.4 Resource Expansion
   - 3.5 Optimistic Concurrency Control
   - 3.6 Batch Operations
   - 3.7 HATEOAS Controls
   - 3.8 Data Types

### Part 2: Core APIs

4. [FactFind Root API](#4-factfind-root-api)
5. [Client Management API](#5-client-management-api)
6. [Address API](#6-address-api)
7. [Contact API](#7-contact-api)
8. [Professional Contact API](#8-professional-contact-api)
9. [Client Relationship API](#9-client-relationship-api)
10. [Dependant API](#10-dependant-api)
11. [Vulnerability API](#11-vulnerability-api)
12. [Estate Planning API](#12-estate-planning-api)
13. [Identity Verification API](#13-identity-verification-api)
14. [Credit History API](#14-credit-history-api)
15. [Financial Profile API](#15-financial-profile-api)
16. [Marketing Preferences API](#16-marketing-preferences-api)
17. [DPA Agreement API](#17-dpa-agreement-api)

### Part 3: Circumstances APIs

18. [Employment API](#18-employment-api)
19. [Income API](#19-income-api)
20. [Expenditure API](#20-expenditure-api)
21. [Affordability API](#21-affordability-api)

### Part 4: Assets & Liabilities APIs

22. [Asset API](#22-asset-api)
23. [Liability API](#23-liability-api)
24. [Net Worth API](#24-net-worth-api)

### Part 5: Plans & Investments APIs

25. [Investment API](#25-investment-api)
26. [Final Salary Pension API](#26-final-salary-pension-api)
27. [Annuity API](#27-annuity-api)
28. [Personal Pension API](#28-personal-pension-api)
29. [State Pension API](#29-state-pension-api)
30. [Mortgage API](#30-mortgage-api)
31. [Personal Protection API](#31-personal-protection-api)

### Part 6: Goals & Risk APIs

32. [Objectives API](#32-objectives-api)
33. [ATR Assessment API](#33-atr-assessment-api)

### Part 7: Reference Data

34. [Reference Data API](#34-reference-data-api)

### Appendices

- [Appendix A: Complete Endpoint Catalog](#appendix-a-complete-endpoint-catalog)
- [Appendix B: Common Value Types](#appendix-b-common-value-types)
- [Appendix C: HTTP Status Codes Reference](#appendix-c-http-status-codes-reference)
- [Appendix D: Regulatory Compliance Matrix](#appendix-d-regulatory-compliance-matrix)

---

## 1. API Design Principles

### 1.1 RESTful Architecture

The FactFind API follows REST (Representational State Transfer) architectural principles:

**Resource-Oriented Design:**
- Resources are identified by URIs (e.g., `/api/v2/factfinds/{id}`)
- Resources have representations (typically JSON)
- Resources support standard HTTP methods (GET, POST, PATCH, DELETE)

**Stateless Communication:**
- Each request contains all information needed to process it
- No server-side session state (authentication via JWT tokens)
- Supports horizontal scaling and load balancing

**Hierarchical Structure:**
- Resources are organized in a logical hierarchy
- Parent-child relationships reflected in URI paths
- Example: `/api/v2/factfinds/{id}/clients/{clientId}/addresses/{addressId}`

**Standard HTTP Methods:**
- `GET` - Retrieve resources (safe, idempotent)
- `POST` - Create new resources
- `PATCH` - Partially update existing resources (idempotent)
- `PUT` - Full replacement of resources (idempotent)
- `DELETE` - Remove resources (idempotent)

**HATEOAS (Level 3 REST):**
- Responses include hypermedia links
- Clients discover available actions through links
- Reduces coupling between client and server

### 1.2 Naming Conventions

**URI Naming:**
- Use lowercase letters
- Use hyphens (-) to separate words, not underscores
- Use plural nouns for collections: `/clients`, `/addresses`, `/investments`
- Use singular nouns for singleton resources: `/estate-planning`, `/financial-profile`
- No trailing slashes: `/api/v2/clients` not `/api/v2/clients/`

**JSON Field Naming:**
- Use camelCase for field names: `firstName`, `dateOfBirth`, `retirementAge`
- Be descriptive and consistent
- Avoid abbreviations unless industry-standard (e.g., `NI` for National Insurance)

**Query Parameters:**
- Use camelCase: `?pageSize=25`, `?sortBy=lastName`
- Boolean flags without `is` prefix: `?active=true` not `?isActive=true`

**Examples:**
```
Good:
- /api/v2/factfinds/{id}/clients/{clientId}/employment
- /api/v2/factfinds/{id}/pensions/statepension
- /api/v2/factfinds/{id}/estate-planning

Avoid:
- /api/v2/factfinds/{id}/client (singular for collection)
- /api/v2/factfinds/{id}/clients/{clientId}/Employment (uppercase)
- /api/v2/factfinds/{id}/clients/{clientId}/employment/ (trailing slash)
```

### 1.3 HTTP Methods & Status Codes

**HTTP Methods:**

| Method | Description | Idempotent | Safe | Request Body | Response Body |
|--------|-------------|------------|------|--------------|---------------|
| GET | Retrieve resource(s) | Yes | Yes | No | Yes (resource) |
| POST | Create new resource | No | No | Yes (new resource) | Yes (created resource) |
| PATCH | Partial update | Yes | No | Yes (changes only) | Yes (updated resource) |
| PUT | Full replacement | Yes | No | Yes (complete resource) | Yes (updated resource) |
| DELETE | Remove resource | Yes | No | No | No (204) |

**Success Status Codes:**

| Code | Meaning | When to Use |
|------|---------|-------------|
| 200 OK | Success | GET, PATCH, PUT successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |

**Client Error Status Codes:**

| Code | Meaning | When to Use |
|------|---------|-------------|
| 400 Bad Request | Invalid syntax | Malformed JSON, invalid data types |
| 401 Unauthorized | Authentication required | Missing or invalid token |
| 403 Forbidden | Insufficient permissions | Valid token but lacks required scope |
| 404 Not Found | Resource not found | Invalid ID in URI path |
| 409 Conflict | Concurrency conflict | Optimistic locking failure |
| 422 Unprocessable Entity | Validation failed | Business rule violations |
| 429 Too Many Requests | Rate limit exceeded | Too many requests in time window |

**Server Error Status Codes:**

| Code | Meaning | When to Use |
|------|---------|-------------|
| 500 Internal Server Error | Unexpected error | Unhandled exceptions |
| 503 Service Unavailable | Temporarily unavailable | Maintenance mode, overload |

### 1.4 Error Response Format

All error responses follow RFC 7807 (Problem Details for HTTP APIs):

```json
{
  "type": "https://api.factfind.com/errors/validation-error",
  "title": "Validation Failed",
  "status": 422,
  "detail": "One or more validation errors occurred",
  "instance": "/api/v2/factfinds/679/clients/8496",
  "traceId": "00-4bf92f3577b34da6a3ce929d0e0e4736-00",
  "errors": [
    {
      "field": "dateOfBirth",
      "code": "FUTURE_DATE",
      "message": "Date of birth cannot be in the future"
    },
    {
      "field": "email",
      "code": "INVALID_FORMAT",
      "message": "Email address is not in a valid format"
    }
  ]
}
```

**Field Definitions:**

| Field | Type | Description |
|-------|------|-------------|
| `type` | URI | URI identifying the error type |
| `title` | string | Short, human-readable summary |
| `status` | integer | HTTP status code |
| `detail` | string | Human-readable explanation |
| `instance` | URI | URI of the specific occurrence |
| `traceId` | string | Correlation ID for tracking |
| `errors` | array | Field-level validation errors |

### 1.5 Hierarchical Architecture

The FactFind API uses a hierarchical structure that reflects the domain model:

**FactFind as Root:**
```
/api/v2/factfinds/{factfindId}
  ├── /clients/{clientId}
  │   ├── /addresses/{addressId}
  │   ├── /contacts/{contactId}
  │   ├── /employment/{employmentId}
  │   ├── /income/{incomeId}
  │   ├── /expenditure/{expenditureId}
  │   ├── /dependants/{dependantId}
  │   └── /estate-planning
  ├── /assets/{assetId}
  ├── /investments/{investmentId}
  ├── /pensions/finalsalary/{pensionId}
  ├── /pensions/annuities/{annuityId}
  ├── /pensions/personalpension/{pensionId}
  ├── /pensions/statepension/{pensionId}
  ├── /mortgages/{mortgageId}
  ├── /protections/{protectionId}
  ├── /objectives/{objectiveId}
  └── /atr-assessment
```

**Benefits:**
- Clear ownership and lifecycle management
- Transactional consistency within aggregates
- Simplified authorization (inherit from parent)
- Natural data isolation for multi-tenancy

### 1.6 Versioning Strategy

**URI Versioning:**
- Version included in URI path: `/api/v2/...`
- Major version only (v1, v2, v3)
- Breaking changes require new major version

**What Constitutes a Breaking Change:**
- Removing or renaming fields
- Changing field types
- Adding required fields
- Changing URI structure
- Changing HTTP methods

**Non-Breaking Changes:**
- Adding optional fields
- Adding new endpoints
- Adding new enum values (with proper client handling)
- Deprecating fields (with notice period)

**Deprecation Process:**
1. Announce deprecation in documentation and headers
2. Add `Sunset` header with deprecation date
3. Provide migration guide
4. Support old version for minimum 12 months
5. Remove old version after notice period

### 1.7 Single Contract Principle

Each entity has **one unified contract** used for:
- POST (create) requests
- PATCH (update) requests
- GET responses

**Benefits:**
- Simpler client code (one model per entity)
- Consistent validation rules
- Easier to maintain and evolve
- Clear documentation

**Optional Fields:**
- All fields optional in PATCH requests (send only changes)
- Some fields required in POST requests (documented per entity)
- All fields present in GET responses (unless sparse fieldsets used)

**Example:**

```json
// POST /api/v2/factfinds/{id}/clients
{
  "firstName": "John",
  "lastName": "Smith",
  "dateOfBirth": "1980-05-15"
}

// PATCH /api/v2/factfinds/{id}/clients/{clientId}
{
  "email": "john.smith@example.com"
}

// GET /api/v2/factfinds/{id}/clients/{clientId}
{
  "id": 8496,
  "href": "/api/v2/factfinds/679/clients/8496",
  "firstName": "John",
  "lastName": "Smith",
  "dateOfBirth": "1980-05-15",
  "email": "john.smith@example.com",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-16T14:20:00Z"
}
```

### 1.8 Value and Reference Type Semantics

The API uses two approaches for representing related data:

#### 1.8.1 Value Types

**Embedded complete data** for objects that have no independent existence:

```json
{
  "homeAddress": {
    "line1": "123 Main Street",
    "city": "London",
    "postcode": "SW1A 1AA",
    "country": "United Kingdom"
  }
}
```

**Characteristics:**
- No `id` or `href` fields
- Lifecycle tied to parent
- Updated by updating parent
- Cannot be referenced elsewhere

#### 1.8.2 Reference Types

**Links to independent resources** with their own lifecycle:

```json
{
  "adviser": {
    "id": 123,
    "href": "/api/v2/advisers/123",
    "name": "Jane Financial Adviser"
  }
}
```

**Characteristics:**
- Has `id` and `href`
- Independent lifecycle
- Can be referenced by multiple resources
- Can include summary fields (`name`, `code`) for convenience

#### 1.8.3 When to Use Value vs Reference Types

**Use Value Types for:**
- Addresses (part of client, no independent meaning)
- Money amounts (currency + amount)
- Date ranges (start + end dates)
- Embedded configuration objects

**Use Reference Types for:**
- Clients, Advisers, Providers (independent entities)
- Product types, Lifecycles (reference data)
- Resources in other aggregates

### 1.9 Aggregate Root Pattern

**FactFind is the Aggregate Root** for all financial planning data:

**Transactional Boundary:**
- All changes within a FactFind are transactionally consistent
- FactFind ID required in URI for all nested resources
- Deleting FactFind cascades to all nested resources

**Entity Lifecycle:**
- All entities exist within the context of a FactFind
- Cannot create client without a FactFind
- Cannot move client between FactFinds (must recreate)

**Benefits:**
- Clear transactional boundaries
- Simplified consistency management
- Natural data isolation for multi-tenancy
- Efficient authorization checks

---

## 2. Authentication & Authorization

### 2.1 OAuth 2.0 with JWT

**Authentication Flow:**

1. **Client Credentials Flow** (Server-to-Server):
```http
POST https://auth.factfind.com/oauth/token
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials&
client_id={clientId}&
client_secret={clientSecret}&
scope=factfind:read factfind:write
```

Response:
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "factfind:read factfind:write"
}
```

2. **Authorization Code Flow** (User-facing applications):
- User redirected to authorization server
- User authenticates and consents
- Authorization code exchanged for access token

**Using Access Token:**

```http
GET /api/v2/factfinds/679/clients/8496
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
```

**JWT Token Claims:**

```json
{
  "sub": "user@example.com",
  "iss": "https://auth.factfind.com",
  "aud": "https://api.factfind.com",
  "exp": 1640995200,
  "iat": 1640991600,
  "scope": "factfind:read factfind:write client:read",
  "tenant_id": "acme-wealth-mgmt",
  "roles": ["adviser", "paraplanner"]
}
```

### 2.2 Authorization Scopes

**Scope Naming Convention:** `{resource}:{action}`

**Core Scopes:**

| Scope | Description |
|-------|-------------|
| `factfind:read` | Read fact finds and summary data |
| `factfind:write` | Create and update fact finds |
| `factfind:delete` | Delete fact finds |
| `client:read` | Read client information |
| `client:write` | Create and update clients |
| `client:admin` | RTBF and administrative functions |
| `circumstances:read` | Read employment, income, expenditure |
| `circumstances:write` | Manage circumstances data |
| `assets:read` | Read assets and liabilities |
| `assets:write` | Manage assets and liabilities |
| `investments:read` | Read investments and plans |
| `investments:write` | Manage investments and plans |
| `pensions:read` | Read pension data |
| `pensions:write` | Manage pension data |
| `pensions:delete` | Delete pension records |
| `objectives:read` | Read objectives and goals |
| `objectives:write` | Manage objectives and goals |
| `atr:read` | Read ATR assessments |
| `atr:write` | Submit and update ATR assessments |
| `credit:read` | Read credit history |
| `credit:write` | Add credit scores |
| `reference:read` | Read reference data |
| `reference:admin` | Manage reference data |

**Scope Hierarchy:**
- `{resource}:admin` implies `{resource}:write` and `{resource}:read`
- `{resource}:write` implies `{resource}:read`
- `{resource}:delete` requires `{resource}:write`

### 2.3 Multi-Tenancy

**Tenant Isolation:**
- Each organization is a separate tenant
- Tenant ID included in JWT token claims
- Data automatically filtered by tenant
- Cross-tenant access blocked at API layer

**Tenant ID in Requests:**

```http
GET /api/v2/factfinds
Authorization: Bearer {token}
X-Tenant-ID: acme-wealth-mgmt
```

**Tenant Validation:**
- Tenant ID in header must match token claim
- All resources tagged with tenant ID
- Queries automatically scoped to tenant
- No manual tenant filtering required in client code

### 2.4 Sensitive Data Handling

**PII (Personally Identifiable Information):**
- Client names, addresses, contact details
- Date of birth, National Insurance numbers
- Financial data, income, assets

**Security Measures:**
- TLS 1.3 for all API communication
- Encryption at rest for database storage
- Field-level encryption for highly sensitive data (NI numbers, bank accounts)
- Audit logging for all PII access
- GDPR-compliant data retention policies

**Sensitive Fields:**
- Never logged or cached
- Masked in non-production environments
- Access controlled by fine-grained permissions
- Available for RTBF (Right To Be Forgotten) operations

### 2.5 Audit Logging

**All API calls are logged with:**
- Timestamp (ISO 8601)
- User ID / Service Account
- Tenant ID
- HTTP method and URI
- Request/Response status code
- Correlation ID (traceId)
- IP address
- Changes made (for write operations)

**Audit Log Format:**

```json
{
  "timestamp": "2024-01-15T10:30:00.123Z",
  "traceId": "00-4bf92f3577b34da6a3ce929d0e0e4736-00",
  "userId": "jane.adviser@acme.com",
  "tenantId": "acme-wealth-mgmt",
  "method": "PATCH",
  "path": "/api/v2/factfinds/679/clients/8496",
  "statusCode": 200,
  "ipAddress": "203.0.113.45",
  "changes": {
    "email": {
      "from": "old@example.com",
      "to": "new@example.com"
    }
  }
}
```

**Retention:**
- Audit logs retained for 7 years (UK regulatory requirement)
- Available for compliance audits and investigations
- Cannot be modified or deleted

---

## 3. Common Patterns

### 3.1 Pagination

**Offset-based Pagination:**

Request:
```http
GET /api/v2/factfinds/679/clients?page=1&pageSize=25
```

Response:
```json
{
  "items": [...],
  "pagination": {
    "page": 1,
    "pageSize": 25,
    "totalItems": 150,
    "totalPages": 6
  },
  "_links": {
    "self": { "href": "/api/v2/factfinds/679/clients?page=1&pageSize=25" },
    "first": { "href": "/api/v2/factfinds/679/clients?page=1&pageSize=25" },
    "next": { "href": "/api/v2/factfinds/679/clients?page=2&pageSize=25" },
    "last": { "href": "/api/v2/factfinds/679/clients?page=6&pageSize=25" }
  }
}
```

**Parameters:**
- `page` - Page number (1-indexed, default: 1)
- `pageSize` - Items per page (default: 25, max: 100)

**Performance Considerations:**
- Use cursor-based pagination for large datasets
- Cache total counts when possible
- Set reasonable page size limits

### 3.2 Filtering & Sorting

**Filtering:**

```http
GET /api/v2/factfinds/679/clients?lastName=Smith&status=Active
GET /api/v2/factfinds/679/income?incomeType=Employment&minAmount=30000
```

**Advanced Filtering (OData-style):**

```http
GET /api/v2/factfinds/679/clients?$filter=age gt 30 and status eq 'Active'
```

**Sorting:**

```http
GET /api/v2/factfinds/679/clients?sort=lastName:asc,firstName:asc
GET /api/v2/factfinds/679/assets?sort=currentValue:desc
```

**Sort Direction:**
- `asc` - Ascending (default)
- `desc` - Descending

### 3.3 Field Selection (Sparse Fieldsets)

**Select Specific Fields:**

```http
GET /api/v2/factfinds/679/clients/8496?fields=id,firstName,lastName,email
```

Response:
```json
{
  "id": 8496,
  "firstName": "John",
  "lastName": "Smith",
  "email": "john.smith@example.com"
}
```

**Benefits:**
- Reduced payload size
- Improved performance
- Lower bandwidth usage
- Faster client-side processing

### 3.4 Resource Expansion

**Expand Related Resources:**

```http
GET /api/v2/factfinds/679/clients/8496?expand=addresses,contacts
```

Response includes full nested resources instead of just references:
```json
{
  "id": 8496,
  "firstName": "John",
  "lastName": "Smith",
  "addresses": [
    {
      "id": 1001,
      "line1": "123 Main Street",
      "city": "London",
      "postcode": "SW1A 1AA"
    }
  ],
  "contacts": [
    {
      "id": 2001,
      "type": "Email",
      "value": "john.smith@example.com"
    }
  ]
}
```

**Multi-level Expansion:**

```http
GET /api/v2/factfinds/679?expand=clients.addresses,clients.contacts
```

### 3.5 Optimistic Concurrency Control

**ETag-based Concurrency:**

Request:
```http
GET /api/v2/factfinds/679/clients/8496
```

Response:
```http
HTTP/1.1 200 OK
ETag: "33a64df551425fcc55e4d42a148795d9"

{
  "id": 8496,
  "firstName": "John",
  ...
}
```

Update with ETag:
```http
PATCH /api/v2/factfinds/679/clients/8496
If-Match: "33a64df551425fcc55e4d42a148795d9"

{
  "email": "new.email@example.com"
}
```

**Conflict Response:**
```http
HTTP/1.1 409 Conflict

{
  "type": "https://api.factfind.com/errors/concurrency-conflict",
  "title": "Concurrency Conflict",
  "status": 409,
  "detail": "The resource has been modified by another user",
  "instance": "/api/v2/factfinds/679/clients/8496"
}
```

### 3.6 Batch Operations

**Batch Create:**

```http
POST /api/v2/factfinds/679/clients/batch
Content-Type: application/json

{
  "items": [
    { "firstName": "John", "lastName": "Smith" },
    { "firstName": "Jane", "lastName": "Doe" }
  ]
}
```

Response:
```json
{
  "results": [
    {
      "status": "success",
      "statusCode": 201,
      "resource": { "id": 8496, ... }
    },
    {
      "status": "success",
      "statusCode": 201,
      "resource": { "id": 8497, ... }
    }
  ]
}
```

**Batch Update:**

```http
PATCH /api/v2/factfinds/679/clients/batch

{
  "updates": [
    { "id": 8496, "email": "john@example.com" },
    { "id": 8497, "email": "jane@example.com" }
  ]
}
```

### 3.7 HATEOAS (Hypermedia Controls)

**All responses include hypermedia links:**

```json
{
  "id": 8496,
  "firstName": "John",
  "lastName": "Smith",
  "_links": {
    "self": {
      "href": "/api/v2/factfinds/679/clients/8496",
      "method": "GET"
    },
    "update": {
      "href": "/api/v2/factfinds/679/clients/8496",
      "method": "PATCH"
    },
    "delete": {
      "href": "/api/v2/factfinds/679/clients/8496",
      "method": "DELETE"
    },
    "addresses": {
      "href": "/api/v2/factfinds/679/clients/8496/addresses",
      "method": "GET"
    },
    "contacts": {
      "href": "/api/v2/factfinds/679/clients/8496/contacts",
      "method": "GET"
    }
  }
}
```

**Benefits:**
- API discoverability
- Reduced client coupling
- Version-safe evolution
- Self-documenting responses

### 3.8 Data Types

**Standard JSON Types:**

| Type | JSON Type | Example | Notes |
|------|-----------|---------|-------|
| String | string | `"John Smith"` | UTF-8 encoded |
| Integer | number | `12345` | No decimals |
| Decimal | number | `12345.67` | Max 2 decimal places for currency |
| Boolean | boolean | `true` | Lowercase only |
| Date | string | `"2024-01-15"` | ISO 8601 (YYYY-MM-DD) |
| DateTime | string | `"2024-01-15T10:30:00Z"` | ISO 8601 with timezone |
| Money | object | `{"amount": 50000.00, "currency": {...}}` | Amount + currency |
| Duration | string | `"P10Y"` | ISO 8601 duration |

**Money Type:**

```json
{
  "amount": 50000.00,
  "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
}
```

**Reference Link Type:**

```json
{
  "id": 123,
  "href": "/api/v2/advisers/123",
  "name": "Jane Adviser"
}
```

---

[Document continues with detailed API sections...]

## 4. FactFind Root API

[Full FactFind API section to be added - referencing Comprehensive-APIs/FactFind-API-Design.md]

## 5. Client Management API

[Full Client API section to be added - referencing Comprehensive-APIs/Client-API-Design.md]

[Additional sections to follow...]

---

**End of Part 1**

**Note:** This is a large comprehensive document. The full version 3.0 specification includes all 33 API sections with complete operation details, contract schemas, examples, business rules, and regulatory guidance. Each API section follows the same comprehensive structure as established in the Comprehensive-APIs folder.

**Total Document Size:** Approximately 50,000+ lines
**Recommended Usage:** Reference specific API sections as needed rather than reading sequentially.

---

## Quick Reference: API Endpoint Summary

### FactFind Root (11 endpoints)
- Fact find CRUD operations
- Aggregated views (complete, current position, net worth, etc.)

### Client Onboarding & KYC (105 endpoints)
- Client management
- Addresses and contacts
- Professional contacts
- Relationships
- Estate planning
- DPA agreements
- Vulnerabilities
- Dependants
- Identity verification
- Credit history
- Financial profile
- Marketing preferences

### Circumstances (26 endpoints)
- Employment
- Income
- Expenditure
- Income/expenditure changes
- Budget summary
- Affordability

### Assets & Liabilities (23 endpoints)
- Assets (property, other assets)
- Liabilities
- Property details
- Net worth calculations

### Plans & Investments (35 endpoints)
- Investments (cash bank accounts, investment accounts, life-assured investments)
- Final Salary Pensions
- Annuities
- Personal Pensions
- State Pensions ⭐ NEW in v3.0
- Mortgages
- Personal Protection

### Goals (31 endpoints)
- Objectives by type (investment, pension, protection, mortgage, budget, estate planning)
- Needs management

### ATR (8 endpoints)
- ATR assessment
- Risk profile selection
- Assessment history

### Reference Data (24 endpoints)
- Enumerations (genders, titles, statuses, etc.)
- Lookups (countries, currencies, frequencies, etc.)
- Reference entities (providers, advisers, product types)

**Total: 263 endpoints**

---

## Document Status

**Version:** 3.0
**Status:** Active
**Last Updated:** 2026-03-03
**Next Review:** 2026-06-03

**Maintainers:**
- API Architecture Team
- Product Management
- Compliance Team

**Change Log:**
- 2026-03-03: v3.0 - Consolidated comprehensive APIs, added State Pension API
- 2026-02-19: v2.0 - Added comprehensive entity APIs
- 2025-12-15: v1.0 - Initial API design

---

**END OF DOCUMENT**
## 4. FactFind Root API

### 4.1 Overview

**Purpose:** The FactFind API manages the lifecycle of financial planning fact finds and provides aggregated views of complete client financial information.

**Base Path:** `/api/v2/factfinds`

**Key Features:**
- Complete fact find CRUD operations
- Aggregated financial views (complete, net worth, current position)
- Meeting and disclosure tracking
- Product summary management
- Multi-client support (individual and joint fact finds)

### 4.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds` | List all fact finds | N/A | 200 OK - FactFind[] |
| POST | `/api/v2/factfinds` | Create new fact find | FactFindRequest | 201 Created - FactFind |
| GET | `/api/v2/factfinds/{id}` | Get fact find by ID | N/A | 200 OK - FactFind |
| PATCH | `/api/v2/factfinds/{id}` | Partial update fact find | FactFindPatch | 200 OK - FactFind |
| DELETE | `/api/v2/factfinds/{id}` | Delete fact find | N/A | 204 No Content |
| GET | `/api/v2/factfinds/{id}/complete` | Get complete fact find with all nested data | N/A | 200 OK - FactFindComplete |
| GET | `/api/v2/factfinds/{id}/current-position` | Get current financial position summary | N/A | 200 OK - CurrentPosition |
| GET | `/api/v2/factfinds/{id}/net-worth` | Get net worth breakdown | N/A | 200 OK - NetWorth |
| GET | `/api/v2/factfinds/{id}/financial-health` | Get financial health score and metrics | N/A | 200 OK - FinancialHealth |
| GET | `/api/v2/factfinds/{id}/cash-flow` | Get cash flow analysis | N/A | 200 OK - CashFlow |
| GET | `/api/v2/factfinds/{id}/asset-allocation` | Get asset allocation breakdown | N/A | 200 OK - AssetAllocation |

**Total Operations:** 11 endpoints

### 4.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `meeting` | object | No | Meeting information including date, type, and attendees |
| `meeting.meetingOn` | date | No | Date when the meeting took place |
| `meeting.meetingType` | enum | No | Type of meeting (FaceToFace, Electronic, Telephone, etc.) |
| `meeting.clientsPresent` | array | No | List of clients who attended the meeting |
| `meeting.anyOtherAudience` | boolean | No | Whether others were present |
| `meeting.notes` | string | No | Meeting notes |
| `products` | object | No | Products and services discussed during fact find |
| `products.investments` | object | No | Investment products information |
| `products.pensions` | object | No | Pension products information |
| `products.mortgages` | object | No | Mortgage products information |
| `products.protections` | object | No | Protection products information |
| `disclosureKeyfacts` | array | No | Disclosure documents issued to clients |
| `employmentSummary` | array | No | Summary of client employment and income information |
| `supplementaryQuestions` | array | No | Additional questions organized by category |
| `assetsAndLiabilities` | object | No | Client asset and liability disclosures |
| `creditHistory` | object | No | Client credit history information |
| `estatePlanning` | object | No | Estate planning details including will, assets, and gifts |

**Total Properties:** 19 core properties with nested structures

### 4.4 Contract Schema

```json
{
  "id": 679,
  "href": "/api/v2/factfinds/679",
  "meeting": {
    "meetingOn": "2026-02-16",
    "meetingType": "FaceToFace",
    "clientsPresent": [
      {
        "id": 8496,
        "href": "/api/v2/factfinds/679/clients/8496",
        "name": "John Smith"
      }
    ],
    "anyOtherAudience": false,
    "notes": "Initial fact find meeting"
  },
  "products": {
    "investments": {
      "hasCash": true,
      "hasInvestments": true
    },
    "pensions": {
      "hasEmployerPensionSchemes": true,
      "hasFinalSalary": false,
      "hasMoneyPurchases": true,
      "hasPersonalPensions": true,
      "hasAnnuities": false
    },
    "mortgages": {
      "hasMortgages": true,
      "hasEquityRelease": false
    },
    "protections": {
      "hasProtection": true
    }
  },
  "disclosureKeyfacts": [
    {
      "type": "CombinedDisclosureDocuments",
      "issuedOn": "2026-02-16"
    }
  ],
  "employmentSummary": [
    {
      "client": {
        "id": 8496,
        "href": "/api/v2/factfinds/679/clients/8496",
        "name": "John Smith"
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
      }
    }
  ],
  "assetsAndLiabilities": {
    "clientDisclosures": {
      "hasAssets": true,
      "hasLiabilities": true,
      "reductionOfLiabilities": {
        "isExpected": false,
        "nonReductionReason": "RetainControlOfCapital",
        "details": "Client prefers to maintain liquidity"
      }
    }
  },
  "creditHistory": {
    "hasAdverseHistory": false,
    "refusedMortgageOrCredit": false,
    "details": null
  },
  "estatePlanning": {
    "will": {
      "details": "Mirror wills in place, updated 2024"
    },
    "totalAssets": {
      "amount": 850000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "giftsDetails": {
      "inLast7Years": "Annual exemption gifts to children",
      "usedAnnualExemptionInCurrentOrPreviousTaxYears": "Yes",
      "regularGiftsOutOfIncome": "Monthly contributions to children's ISAs",
      "expectingInheritanceOrGifts": "Potential inheritance from parents"
    }
  }
}
```

### 4.5 Complete Examples

#### Example 1: Create Individual Fact Find

**Request:**
```http
POST /api/v2/factfinds
Content-Type: application/json
Authorization: Bearer {token}

{
  "meeting": {
    "meetingOn": "2026-03-01",
    "meetingType": "FaceToFace",
    "anyOtherAudience": false,
    "notes": "Initial consultation for retirement planning"
  },
  "products": {
    "investments": {
      "hasCash": true,
      "hasInvestments": false
    },
    "pensions": {
      "hasEmployerPensionSchemes": true,
      "hasFinalSalary": false,
      "hasMoneyPurchases": true,
      "hasPersonalPensions": false,
      "hasAnnuities": false
    },
    "mortgages": {
      "hasMortgages": true,
      "hasEquityRelease": false
    },
    "protections": {
      "hasProtection": false
    }
  }
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json
Location: /api/v2/factfinds/680

{
  "id": 680,
  "href": "/api/v2/factfinds/680",
  "meeting": {
    "meetingOn": "2026-03-01",
    "meetingType": "FaceToFace",
    "clientsPresent": [],
    "anyOtherAudience": false,
    "notes": "Initial consultation for retirement planning"
  },
  "products": {
    "investments": {
      "hasCash": true,
      "hasInvestments": false
    },
    "pensions": {
      "hasEmployerPensionSchemes": true,
      "hasFinalSalary": false,
      "hasMoneyPurchases": true,
      "hasPersonalPensions": false,
      "hasAnnuities": false
    },
    "mortgages": {
      "hasMortgages": true,
      "hasEquityRelease": false
    },
    "protections": {
      "hasProtection": false
    }
  },
  "disclosureKeyfacts": [],
  "employmentSummary": [],
  "assetsAndLiabilities": null,
  "creditHistory": null,
  "estatePlanning": null,
  "_links": {
    "self": {
      "href": "/api/v2/factfinds/680",
      "method": "GET"
    },
    "update": {
      "href": "/api/v2/factfinds/680",
      "method": "PATCH"
    },
    "delete": {
      "href": "/api/v2/factfinds/680",
      "method": "DELETE"
    },
    "complete": {
      "href": "/api/v2/factfinds/680/complete",
      "method": "GET"
    },
    "clients": {
      "href": "/api/v2/factfinds/680/clients",
      "method": "GET"
    }
  }
}
```

#### Example 2: Get Complete Fact Find

**Request:**
```http
GET /api/v2/factfinds/679/complete
Authorization: Bearer {token}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 679,
  "href": "/api/v2/factfinds/679",
  "meeting": {
    "meetingOn": "2026-02-16",
    "meetingType": "FaceToFace",
    "clientsPresent": [
      {
        "id": 8496,
        "href": "/api/v2/factfinds/679/clients/8496",
        "name": "John Smith"
      }
    ]
  },
  "clients": [
    {
      "id": 8496,
      "href": "/api/v2/factfinds/679/clients/8496",
      "clientNumber": "C00001234",
      "clientType": "Person",
      "personValue": {
        "firstName": "John",
        "lastName": "Smith",
        "dateOfBirth": "1980-05-15",
        "age": 45,
        "gender": "M",
        "maritalStatus": {
          "code": "MAR",
          "display": "Married"
        }
      }
    }
  ],
  "assets": [
    {
      "id": 5001,
      "href": "/api/v2/factfinds/679/assets/5001",
      "assetType": "Property",
      "currentValue": {
        "amount": 425000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    }
  ],
  "investments": [],
  "pensions": [],
  "mortgages": [],
  "protections": [],
  "netWorth": {
    "totalAssets": {
      "amount": 850000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "totalLiabilities": {
      "amount": 240000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "netWorthAmount": {
      "amount": 610000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  }
}
```

#### Example 3: Get Net Worth Breakdown

**Request:**
```http
GET /api/v2/factfinds/679/net-worth
Authorization: Bearer {token}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "factfindId": 679,
  "calculatedOn": "2026-03-03T10:30:00Z",
  "assets": {
    "property": {
      "amount": 425000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "investments": {
      "amount": 185000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "pensions": {
      "amount": 200000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "cash": {
      "amount": 40000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "totalAssets": {
      "amount": 850000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "liabilities": {
    "mortgages": {
      "amount": 200000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "loans": {
      "amount": 30000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "creditCards": {
      "amount": 10000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "totalLiabilities": {
      "amount": 240000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "netWorth": {
    "amount": 610000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "equityByAsset": [
    {
      "assetId": 5001,
      "assetType": "Property",
      "assetValue": {
        "amount": 425000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "mortgageBalance": {
        "amount": 200000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "equity": {
        "amount": 225000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "equityPercentage": 52.94
    }
  ]
}
```

### 4.6 Business Rules

1. **Meeting Date Validation:** `meeting.meetingOn` cannot be in the future
2. **Meeting Type Validation:** Must be one of: FaceToFace, FaceToFaceRecorded, Electronic, ElectronicRecorded, Videocall, VideocallRecorded, Telephone, TelephoneRecorded
3. **Disclosure Type Validation:** Must be one of: CombinedDisclosureDocuments, CombinedInitialDisclosureDocument, DisclosureDocument, KeyfactsAboutCostOfServices, KeyfactsAboutServices, ServiceCostDisclosureDocument, TermsRefundOfFees, TermsOfBusiness
4. **Tax Rate Validation:** `employmentSummary[].highestTaxRatePaid.percentage` must be one of: 0, 10, 19, 20, 21, 22, 40, 41, 42, 45, 46, 47, 48
5. **Calculated Fields:** `totalGrossAnnualIncome`, `totalAssets`, and `jointTotalAssets` are read-only calculated fields
6. **Cascade Delete:** Deleting a fact find will cascade delete all nested resources (clients, assets, investments, etc.)
7. **Required Disclosure:** At least one disclosure document must be issued before fact find completion

### 4.7 Query Parameters

**List Fact Finds (`GET /api/v2/factfinds`):**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `page` | integer | Page number (1-indexed) | `page=1` |
| `pageSize` | integer | Items per page (max 100) | `pageSize=25` |
| `sortBy` | string | Sort field | `sortBy=meetingOn:desc` |
| `meetingDateFrom` | date | Filter by meeting date range (from) | `meetingDateFrom=2026-01-01` |
| `meetingDateTo` | date | Filter by meeting date range (to) | `meetingDateTo=2026-12-31` |
| `hasPensions` | boolean | Filter by pension products | `hasPensions=true` |
| `hasInvestments` | boolean | Filter by investment products | `hasInvestments=true` |
| `hasProtection` | boolean | Filter by protection products | `hasProtection=true` |

### 4.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET requests successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed JSON |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid fact find ID |
| 409 Conflict | Concurrency conflict | ETag mismatch |
| 422 Unprocessable Entity | Validation failed | Business rule violation |
| 500 Internal Server Error | Unexpected error | System failure |

### 4.9 Regulatory Compliance

**FCA Handbook COBS 9.2 - Assessing Suitability:**
- Fact find must capture sufficient information to assess suitability
- Knowledge and experience must be documented
- Financial situation must be recorded
- Investment objectives must be captured

**FCA Consumer Duty:**
- Clear disclosure of services and costs
- Evidence of understanding client needs
- Documentation of advice process
- Fair and reasonable outcomes

**GDPR Compliance:**
- Data processing consent required
- Right to access (export fact find data)
- Right to erasure (delete fact find)
- Data retention policies (7 years minimum for financial advice)

**MLR 2017 (Money Laundering Regulations):**
- Identity verification required
- Source of funds documentation
- Enhanced due diligence for high-risk clients
- Ongoing monitoring requirements

### 4.10 Related APIs

**Child Resources:**
- [Client Management API](#5-client-management-api) - `/api/v2/factfinds/{id}/clients`
- [Asset API](#22-asset-api) - `/api/v2/factfinds/{id}/assets`
- [Investment API](#24-investment-api) - `/api/v2/factfinds/{id}/investments`
- [Pension APIs](#25-29) - `/api/v2/factfinds/{id}/pensions/*`
- [Mortgage API](#29-mortgage-api) - `/api/v2/factfinds/{id}/mortgages`
- [Protection API](#30-personal-protection-api) - `/api/v2/factfinds/{id}/protections`
- [Objectives API](#31-objectives-api) - `/api/v2/factfinds/{id}/objectives`
- [ATR Assessment API](#32-atr-assessment-api) - `/api/v2/factfinds/{id}/atr-assessment`

---
## 5. Client Management API

### 5.1 Overview

**Purpose:** The Client Management API handles core client identity, profile management, and demographic information for individuals, companies, and trusts receiving financial advice.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients`

**Key Features:**
- Multi-type client support (Person, Corporate, Trust)
- Comprehensive demographic and personal information
- Territorial profile (residency, domicile, citizenship)
- Health metrics (BMI, height, weight)
- Joint client relationships
- Service status and segmentation tracking

### 5.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients` | List all clients in factfind | N/A | 200 OK - Client[] |
| POST | `/api/v2/factfinds/{factfindId}/clients` | Create new client | ClientRequest | 201 Created - Client |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}` | Get client by ID | N/A | 200 OK - Client |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}` | Update client details | ClientPatch | 200 OK - Client |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}` | Delete client | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 5.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `clientNumber` | string | No | Client reference number assigned by your organization |
| `clientType` | enum | Yes | Type of client: Person, Corporate, Trust |
| `clientCategory` | string | No | Client category (HighNetWorth, MassMarket, etc.) |
| `clientSegment` | enum | No | Client segment classification (A, B, C, D) |
| `clientSegmentDate` | date | No | Date of segment classification |
| `serviceStatus` | enum | No | Current service status (Active, Inactive, Prospect) |
| `serviceStatusDate` | date | No | Date of service status change |
| `isJoint` | boolean | No | Whether part of a joint (couple) fact find |
| `isHeadOfFamilyGroup` | boolean | No | Whether primary contact for family group |
| `isMatchingServiceProposition` | boolean | No | Whether requires matching service due to vulnerability |
| `matchingServicePropositionReason` | string | No | Reason for matching service |
| `spouseRef` | object | No | Link to spouse/partner client record (for joint fact finds) |
| `adviser` | object | No | The adviser responsible for this client |
| `paraplannerRef` | object | No | The paraplanner assigned to this client |
| `officeRef` | object | No | The office/branch where client is managed |
| `factfind` | object | Yes (response only) | Link to the FactFind that this client belongs to |
| `personValue` | object | Conditional | Personal information (required when clientType=Person) |
| `territorialProfile` | object | No | Residency, domicile, citizenship, and territorial tax status |
| `createdAt` | datetime | Yes (response only) | When this record was created |
| `updatedAt` | datetime | Yes (response only) | When this record was last modified |
| `createdBy` | object | Yes (response only) | User who created this record |
| `updatedBy` | object | Yes (response only) | User who last modified this record |

**Total Properties:** 23 core properties

#### Person Value Properties (when clientType=Person)

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `title` | enum | No | Title (MR, MRS, MS, DR, etc.) |
| `firstName` | string | Yes | First name (given name) |
| `middleNames` | string | No | Middle name(s) |
| `lastName` | string | Yes | Last name (surname/family name) |
| `fullName` | string | No (calculated) | Complete formatted name including title |
| `preferredName` | string | No | Name the client prefers to be called |
| `salutation` | string | No | How to address the client |
| `dateOfBirth` | date | Yes | Date of birth |
| `age` | integer | No (calculated) | Current age (calculated from date of birth) |
| `gender` | enum | No | Gender (M=Male, F=Female, O=Other, X=Prefer not to say) |
| `maritalStatus` | object | No | Current marital status with effective date |
| `niNumber` | string | No | National Insurance number (UK) |
| `occupation` | string | No | Current occupation/job title |
| `occupationCode` | object | No | Standard Occupational Classification (SOC) code |
| `employmentStatus` | enum | No | Current employment status |
| `smokingStatus` | enum | No | Smoking status for insurance purposes |
| `isDeceased` | boolean | No | Whether the client has passed away |
| `deceasedDate` | date | No | Date of death (if applicable) |
| `healthMetrics` | object | No | Height, weight, BMI for health and insurance assessment |

#### Territorial Profile Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `countryOfResidence` | object | No | Current country of residence with ISO code |
| `countryOfDomicile` | object | No | Country of domicile for tax purposes |
| `countryOfBirth` | object | No | Country where the client was born |
| `countryOfOrigin` | object | No | Country of origin |
| `placeOfBirth` | string | No | City/town where the client was born |
| `countriesOfCitizenship` | array | No | List of countries where client holds citizenship |
| `ukResident` | boolean | No | Whether the client is UK tax resident |
| `ukDomicile` | boolean | No | Whether the client is UK domiciled |
| `expatriate` | boolean | No | Whether the client is an expatriate |

#### Health Metrics Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `heightCm` | decimal | No | Height in centimeters |
| `weightKg` | decimal | No | Weight in kilograms |
| `bmi` | decimal | No (calculated) | Body Mass Index (calculated) |
| `bmiCategory` | enum | No (calculated) | BMI category (Underweight, Normal, Overweight, Obese) |
| `lastMeasured` | date | No | Date measurements were taken |

### 5.4 Contract Schema

```json
{
  "id": 8496,
  "href": "/api/v2/factfinds/679/clients/8496",
  "clientNumber": "C00001234",
  "clientType": "Person",
  "clientCategory": "HighNetWorth",
  "clientSegment": "A",
  "clientSegmentDate": "2020-01-15",
  "serviceStatus": "Active",
  "serviceStatusDate": "2020-01-15",
  "isJoint": true,
  "isHeadOfFamilyGroup": true,
  "isMatchingServiceProposition": false,
  "matchingServicePropositionReason": null,
  "spouseRef": {
    "id": 8497,
    "href": "/api/v2/factfinds/679/clients/8497",
    "clientNumber": "C00001235",
    "name": "Sarah Smith",
    "type": "Person"
  },
  "adviser": {
    "id": 8724,
    "code": "ADV001",
    "name": "Jane Doe"
  },
  "paraplannerRef": {
    "id": 8082,
    "code": "PP001",
    "name": "Tom Johnson"
  },
  "officeRef": {
    "id": 3797,
    "code": "LON",
    "name": "London Office"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123",
    "status": "INP"
  },
  "personValue": {
    "title": "MR",
    "firstName": "John",
    "middleNames": "Michael Robert",
    "lastName": "Smith",
    "fullName": "Mr John Michael Robert Smith",
    "preferredName": "John",
    "salutation": "Mr Smith",
    "dateOfBirth": "1980-05-15",
    "age": 45,
    "gender": "M",
    "maritalStatus": {
      "code": "MAR",
      "display": "Married",
      "effectiveFrom": "2005-06-20"
    },
    "niNumber": "AB123456C",
    "occupation": "Senior Software Engineer",
    "occupationCode": {
      "code": "2136",
      "display": "Programmers and Software Development Professionals",
      "socVersion": "SOC2020"
    },
    "employmentStatus": "Employed",
    "smokingStatus": "NEVER",
    "isDeceased": false,
    "deceasedDate": null,
    "healthMetrics": {
      "heightCm": 178.0,
      "weightKg": 82.5,
      "bmi": 26.04,
      "bmiCategory": "Overweight",
      "lastMeasured": "2026-01-15"
    }
  },
  "territorialProfile": {
    "countryOfResidence": {
      "code": "GB",
      "alpha3": "GBR",
      "display": "United Kingdom"
    },
    "countryOfDomicile": {
      "code": "GB",
      "alpha3": "GBR",
      "display": "United Kingdom"
    },
    "countryOfBirth": {
      "code": "GB",
      "alpha3": "GBR",
      "display": "United Kingdom"
    },
    "countryOfOrigin": {
      "code": "GB",
      "alpha3": "GBR",
      "display": "United Kingdom"
    },
    "placeOfBirth": "London",
    "countriesOfCitizenship": [
      {
        "code": "GB",
        "alpha3": "GBR",
        "display": "United Kingdom"
      }
    ],
    "ukResident": true,
    "ukDomicile": true,
    "expatriate": false
  },
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "createdBy": {
    "id": 8724,
    "name": "Jane Doe"
  },
  "updatedBy": {
    "id": 8724,
    "name": "Jane Doe"
  }
}
```

### 5.5 Complete Examples

#### Example 1: Create Individual Person Client

**Request:**
```http
POST /api/v2/factfinds/679/clients
Content-Type: application/json
Authorization: Bearer {token}

{
  "clientType": "Person",
  "clientNumber": "C00001234",
  "serviceStatus": "Prospect",
  "personValue": {
    "title": "MR",
    "firstName": "John",
    "middleNames": "Michael",
    "lastName": "Smith",
    "dateOfBirth": "1980-05-15",
    "gender": "M",
    "maritalStatus": {
      "code": "MAR",
      "display": "Married",
      "effectiveFrom": "2005-06-20"
    },
    "niNumber": "AB123456C",
    "occupation": "Senior Software Engineer",
    "employmentStatus": "Employed",
    "smokingStatus": "NEVER"
  },
  "territorialProfile": {
    "countryOfResidence": {
      "code": "GB"
    },
    "countryOfDomicile": {
      "code": "GB"
    },
    "ukResident": true,
    "ukDomicile": true
  }
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json
Location: /api/v2/factfinds/679/clients/8496

{
  "id": 8496,
  "href": "/api/v2/factfinds/679/clients/8496",
  "clientNumber": "C00001234",
  "clientType": "Person",
  "serviceStatus": "Prospect",
  "serviceStatusDate": "2026-03-03",
  "isJoint": false,
  "personValue": {
    "title": "MR",
    "firstName": "John",
    "middleNames": "Michael",
    "lastName": "Smith",
    "fullName": "Mr John Michael Smith",
    "salutation": "Mr Smith",
    "dateOfBirth": "1980-05-15",
    "age": 45,
    "gender": "M",
    "maritalStatus": {
      "code": "MAR",
      "display": "Married",
      "effectiveFrom": "2005-06-20"
    },
    "niNumber": "AB123456C",
    "occupation": "Senior Software Engineer",
    "employmentStatus": "Employed",
    "smokingStatus": "NEVER",
    "isDeceased": false
  },
  "territorialProfile": {
    "countryOfResidence": {
      "code": "GB",
      "alpha3": "GBR",
      "display": "United Kingdom"
    },
    "countryOfDomicile": {
      "code": "GB",
      "alpha3": "GBR",
      "display": "United Kingdom"
    },
    "ukResident": true,
    "ukDomicile": true,
    "expatriate": false
  },
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z",
  "_links": {
    "self": {
      "href": "/api/v2/factfinds/679/clients/8496"
    },
    "addresses": {
      "href": "/api/v2/factfinds/679/clients/8496/addresses"
    },
    "contacts": {
      "href": "/api/v2/factfinds/679/clients/8496/contacts"
    },
    "employment": {
      "href": "/api/v2/factfinds/679/clients/8496/employment"
    },
    "income": {
      "href": "/api/v2/factfinds/679/clients/8496/income"
    }
  }
}
```

#### Example 2: Update Client with Health Metrics

**Request:**
```http
PATCH /api/v2/factfinds/679/clients/8496
Content-Type: application/json
Authorization: Bearer {token}

{
  "personValue": {
    "healthMetrics": {
      "heightCm": 178.0,
      "weightKg": 82.5,
      "lastMeasured": "2026-03-01"
    }
  }
}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 8496,
  "href": "/api/v2/factfinds/679/clients/8496",
  "clientNumber": "C00001234",
  "clientType": "Person",
  "personValue": {
    "firstName": "John",
    "lastName": "Smith",
    "dateOfBirth": "1980-05-15",
    "age": 45,
    "healthMetrics": {
      "heightCm": 178.0,
      "weightKg": 82.5,
      "bmi": 26.04,
      "bmiCategory": "Overweight",
      "lastMeasured": "2026-03-01"
    }
  },
  "updatedAt": "2026-03-03T11:15:00Z"
}
```

#### Example 3: Create Joint Client with Spouse Link

**Request:**
```http
POST /api/v2/factfinds/679/clients
Content-Type: application/json
Authorization: Bearer {token}

{
  "clientType": "Person",
  "clientNumber": "C00001235",
  "serviceStatus": "Prospect",
  "isJoint": true,
  "spouseRef": {
    "id": 8496
  },
  "personValue": {
    "title": "MRS",
    "firstName": "Sarah",
    "lastName": "Smith",
    "dateOfBirth": "1982-08-22",
    "gender": "F",
    "maritalStatus": {
      "code": "MAR",
      "display": "Married",
      "effectiveFrom": "2005-06-20"
    }
  }
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json
Location: /api/v2/factfinds/679/clients/8497

{
  "id": 8497,
  "href": "/api/v2/factfinds/679/clients/8497",
  "clientNumber": "C00001235",
  "clientType": "Person",
  "isJoint": true,
  "spouseRef": {
    "id": 8496,
    "href": "/api/v2/factfinds/679/clients/8496",
    "clientNumber": "C00001234",
    "name": "John Smith",
    "type": "Person"
  },
  "personValue": {
    "title": "MRS",
    "firstName": "Sarah",
    "lastName": "Smith",
    "fullName": "Mrs Sarah Smith",
    "dateOfBirth": "1982-08-22",
    "age": 43,
    "gender": "F",
    "maritalStatus": {
      "code": "MAR",
      "display": "Married",
      "effectiveFrom": "2005-06-20"
    }
  },
  "createdAt": "2026-03-03T10:45:00Z",
  "updatedAt": "2026-03-03T10:45:00Z"
}
```

### 5.6 Business Rules

1. **Client Type Validation:** `clientType` must be one of: Person, Corporate, Trust
2. **Conditional Requirements:**
   - `personValue` required when `clientType=Person`
   - `corporateValue` required when `clientType=Corporate`
   - `trustValue` required when `clientType=Trust`
3. **Date of Birth Validation:** Must be in the past and client must be at least 16 years old
4. **Age Calculation:** Age is automatically calculated from `dateOfBirth`
5. **BMI Calculation:** BMI automatically calculated from height and weight: `BMI = weight(kg) / (height(m))²`
6. **BMI Categories:**
   - Underweight: BMI < 18.5
   - Normal: BMI 18.5-24.9
   - Overweight: BMI 25-29.9
   - Obese: BMI ≥ 30
7. **Joint Clients:** When `isJoint=true`, `spouseRef` must reference a valid client in the same fact find
8. **Full Name Generation:** `fullName` automatically generated from title, firstName, middleNames, and lastName
9. **UK Resident Rules:** If `ukResident=true`, typically `countryOfResidence.code='GB'`
10. **Identity Verification:** Active clients must have valid identity verification

### 5.7 Query Parameters

**List Clients (`GET /api/v2/factfinds/{factfindId}/clients`):**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `clientType` | enum | Filter by client type | `clientType=Person` |
| `serviceStatus` | enum | Filter by service status | `serviceStatus=Active` |
| `isJoint` | boolean | Filter joint clients | `isJoint=true` |
| `clientSegment` | enum | Filter by segment | `clientSegment=A` |
| `sortBy` | string | Sort field and direction | `sortBy=lastName:asc` |
| `fields` | string | Sparse fieldsets | `fields=id,firstName,lastName` |

### 5.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PATCH requests successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed JSON, invalid data types |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks `client:write` scope |
| 404 Not Found | Resource not found | Invalid client ID |
| 409 Conflict | Concurrency conflict | ETag mismatch |
| 422 Unprocessable Entity | Validation failed | Business rule violations |

### 5.9 Regulatory Compliance

**GDPR (General Data Protection Regulation):**
- Client data is personal data requiring lawful basis for processing
- Data minimization principle applies
- Right to access: Clients can request their data via export
- Right to erasure: Clients can request deletion (subject to regulatory retention)
- Right to portability: Data export in machine-readable format

**FCA Handbook SYSC 3.2 - Client Categorization:**
- Retail clients (default)
- Professional clients (opt-up available)
- Eligible counterparties
- Categorization affects regulatory protections

**MLR 2017 (Money Laundering Regulations):**
- Enhanced due diligence for:
  - Politically Exposed Persons (PEPs)
  - High-risk countries
  - High-value clients
- NI number verification for UK residents
- Identity verification mandatory

**Consumer Duty (FCA):**
- Vulnerability identification (`isMatchingServiceProposition`)
- Additional support for vulnerable clients
- Fair treatment outcomes
- Communications accessibility

### 5.10 Related APIs

**Child Resources:**
- [Address API](#6-address-api) - `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses`
- [Contact API](#7-contact-api) - `/api/v2/factfinds/{factfindId}/clients/{clientId}/contacts`
- [Professional Contact API](#8-professional-contact-api) - `/api/v2/factfinds/{factfindId}/clients/{clientId}/professional-contacts`
- [Client Relationship API](#9-client-relationship-api) - `/api/v2/factfinds/{factfindId}/clients/{clientId}/relationships`
- [Dependant API](#10-dependant-api) - `/api/v2/factfinds/{factfindId}/clients/{clientId}/dependants`
- [Vulnerability API](#11-vulnerability-api) - `/api/v2/factfinds/{factfindId}/clients/{clientId}/vulnerabilities`
- [Estate Planning API](#12-estate-planning-api) - `/api/v2/factfinds/{factfindId}/clients/{clientId}/estate-planning`
- [Identity Verification API](#13-identity-verification-api) - `/api/v2/factfinds/{factfindId}/clients/{clientId}/id-verification`
- [Employment API](#18-employment-api) - `/api/v2/factfinds/{factfindId}/clients/{clientId}/employment`
- [Income API](#19-income-api) - `/api/v2/factfinds/{factfindId}/clients/{clientId}/income`
- [Expenditure API](#20-expenditure-api) - `/api/v2/factfinds/{factfindId}/clients/{clientId}/expenditure`

**Parent Resources:**
- [FactFind Root API](#4-factfind-root-api) - `/api/v2/factfinds`

---
## 6. Address API

### 6.1 Overview

**Purpose:** The Address API manages client address information including current and historical addresses for KYC/AML compliance and correspondence purposes.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses`

**Key Features:**
- Current and historical address tracking
- Residency period management
- Electoral roll confirmation
- Correspondence address designation
- Address type classification (Residential, Business, Previous)

### 6.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses` | List client addresses | N/A | 200 OK - Address[] |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses` | Add new address | AddressRequest | 201 Created - Address |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses/{addressId}` | Get address by ID | N/A | 200 OK - Address |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses/{addressId}` | Update address | AddressPatch | 200 OK - Address |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses/{addressId}` | Delete address | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 6.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `client` | object | Yes (response only) | Reference to the client |
| `factfind` | object | Yes (response only) | Reference to the fact find |
| `addressType` | enum | Yes | Type of address (Residential, Previous, Business, BTL, Holiday) |
| `address` | object | Yes | Full address details |
| `address.line1` | string | Yes | Address line 1 |
| `address.line2` | string | No | Address line 2 |
| `address.city` | string | Yes | City/town |
| `address.county` | string | No | County/region |
| `address.postcode` | string | Yes | Postcode/ZIP code |
| `address.country` | string | Yes | Country code (ISO 3166-1 alpha-2) |
| `residencyPeriod` | object | No | Start and end dates of residency |
| `residencyPeriod.startDate` | date | Yes | Residency start date |
| `residencyPeriod.endDate` | date | No | Residency end date (null if current) |
| `residencyStatus` | enum | No | Residency status (Owner, Tenant, LivingWithFamily) |
| `isCorrespondenceAddress` | boolean | No | Whether this is the correspondence address |
| `isOnElectoralRoll` | boolean | No | Whether client is on electoral roll at this address |
| `createdAt` | datetime | Yes (response only) | When this record was created |
| `updatedAt` | datetime | Yes (response only) | When this record was last modified |

**Total Properties:** 19 properties

### 6.4 Contract Schema

```json
{
  "id": 1392,
  "href": "/api/v2/factfinds/679/clients/8496/addresses/1392",
  "client": {
    "id": 8496,
    "clientNumber": "C00001234",
    "name": "John Smith",
    "type": "Person"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123",
    "status": "INP"
  },
  "addressType": "Residential",
  "address": {
    "line1": "123 High Street",
    "line2": "Apartment 4B",
    "city": "London",
    "county": "Greater London",
    "postcode": "SW1A 1AA",
    "country": "GB"
  },
  "residencyPeriod": {
    "startDate": "2020-01-15",
    "endDate": null
  },
  "residencyStatus": "Owner",
  "isCorrespondenceAddress": true,
  "isOnElectoralRoll": true,
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z"
}
```

### 6.5 Complete Examples

#### Example 1: Add Current Residential Address

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/addresses
Content-Type: application/json
Authorization: Bearer {token}

{
  "addressType": "Residential",
  "address": {
    "line1": "123 High Street",
    "line2": "Apartment 4B",
    "city": "London",
    "county": "Greater London",
    "postcode": "SW1A 1AA",
    "country": "GB"
  },
  "residencyPeriod": {
    "startDate": "2020-01-15"
  },
  "residencyStatus": "Owner",
  "isCorrespondenceAddress": true,
  "isOnElectoralRoll": true
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json
Location: /api/v2/factfinds/679/clients/8496/addresses/1392

{
  "id": 1392,
  "href": "/api/v2/factfinds/679/clients/8496/addresses/1392",
  "addressType": "Residential",
  "address": {
    "line1": "123 High Street",
    "line2": "Apartment 4B",
    "city": "London",
    "county": "Greater London",
    "postcode": "SW1A 1AA",
    "country": "GB"
  },
  "residencyPeriod": {
    "startDate": "2020-01-15",
    "endDate": null
  },
  "residencyStatus": "Owner",
  "isCorrespondenceAddress": true,
  "isOnElectoralRoll": true,
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Add Previous Address

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/addresses
Content-Type: application/json
Authorization: Bearer {token}

{
  "addressType": "Previous",
  "address": {
    "line1": "45 Oak Avenue",
    "city": "Manchester",
    "postcode": "M1 2AB",
    "country": "GB"
  },
  "residencyPeriod": {
    "startDate": "2015-06-01",
    "endDate": "2020-01-14"
  },
  "residencyStatus": "Tenant"
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1393,
  "href": "/api/v2/factfinds/679/clients/8496/addresses/1393",
  "addressType": "Previous",
  "address": {
    "line1": "45 Oak Avenue",
    "city": "Manchester",
    "postcode": "M1 2AB",
    "country": "GB"
  },
  "residencyPeriod": {
    "startDate": "2015-06-01",
    "endDate": "2020-01-14"
  },
  "residencyStatus": "Tenant",
  "isCorrespondenceAddress": false,
  "createdAt": "2026-03-03T10:35:00Z",
  "updatedAt": "2026-03-03T10:35:00Z"
}
```

### 6.6 Business Rules

1. **At least one current address required:** Client must have at least one address with `residencyPeriod.endDate=null`
2. **Only one correspondence address:** Only one address can have `isCorrespondenceAddress=true`
3. **Date validation:** `residencyPeriod.endDate` must be after `residencyPeriod.startDate`
4. **UK postcode format:** UK postcodes must match standard format pattern
5. **3-year address history:** For AML compliance, address history covering at least 3 years is recommended
6. **Address type validation:** Must be one of: Residential, Previous, Business, BTL, Holiday
7. **Residency status validation:** Must be one of: Owner, Tenant, LivingWithFamily, Other

### 6.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `addressType` | enum | Filter by address type | `addressType=Residential` |
| `current` | boolean | Filter current addresses only | `current=true` |
| `sortBy` | string | Sort field | `sortBy=startDate:desc` |

### 6.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid address ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 6.9 Regulatory Compliance

**MLR 2017 (Money Laundering Regulations):**
- Address verification required as part of KYC
- 3-year address history recommended
- Electoral roll confirmation strengthens verification

**GDPR:**
- Address data is personal data
- Must have lawful basis for processing
- Right to erasure applies (subject to regulatory retention)

### 6.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Identity Verification API](#13-identity-verification-api) - Uses address for verification

---

## 7. Contact API

### 7.1 Overview

**Purpose:** The Contact API manages client contact methods including email, phone, and mobile numbers for communication and marketing purposes.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/contacts`

**Key Features:**
- Multiple contact methods per client
- Primary and preferred contact designation
- Marketing consent tracking
- Contact verification status
- Contact type classification

### 7.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/contacts` | List contact methods | N/A | 200 OK - Contact[] |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/contacts` | Add contact method | ContactRequest | 201 Created - Contact |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/contacts/{contactId}` | Get contact by ID | N/A | 200 OK - Contact |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}/contacts/{contactId}` | Update contact | ContactPatch | 200 OK - Contact |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/contacts/{contactId}` | Delete contact | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 7.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `client` | object | Yes (response only) | Reference to the client |
| `factfind` | object | Yes (response only) | Reference to the fact find |
| `contactType` | enum | Yes | Type of contact (Email, Phone, Mobile, Fax) |
| `value` | string | Yes | The contact value (email address, phone number, etc.) |
| `isPrimary` | boolean | No | Whether this is the primary contact of this type |
| `isPreferred` | boolean | No | Whether this is the client's preferred contact method |
| `isVerified` | boolean | No | Whether this contact has been verified |
| `verifiedDate` | date | No | When this contact was verified |
| `isValidForMarketing` | boolean | No | Whether valid for marketing purposes |
| `marketingOptIn` | boolean | No | Whether client opted in for marketing |
| `notes` | string | No | Additional notes about this contact |
| `createdAt` | datetime | Yes (response only) | When this record was created |
| `updatedAt` | datetime | Yes (response only) | When this record was last modified |

**Total Properties:** 15 properties

### 7.4 Contract Schema

```json
{
  "id": 2001,
  "href": "/api/v2/factfinds/679/clients/8496/contacts/2001",
  "client": {
    "id": 8496,
    "clientNumber": "C00001234",
    "name": "John Smith",
    "type": "Person"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123",
    "status": "INP"
  },
  "contactType": "Email",
  "value": "john.smith@example.com",
  "isPrimary": true,
  "isPreferred": true,
  "isVerified": true,
  "verifiedDate": "2026-02-16",
  "isValidForMarketing": true,
  "marketingOptIn": true,
  "notes": null,
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z"
}
```

### 7.5 Complete Examples

#### Example 1: Add Primary Email Contact

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/contacts
Content-Type: application/json
Authorization: Bearer {token}

{
  "contactType": "Email",
  "value": "john.smith@example.com",
  "isPrimary": true,
  "isPreferred": true,
  "marketingOptIn": true
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 2001,
  "href": "/api/v2/factfinds/679/clients/8496/contacts/2001",
  "contactType": "Email",
  "value": "john.smith@example.com",
  "isPrimary": true,
  "isPreferred": true,
  "isVerified": false,
  "isValidForMarketing": true,
  "marketingOptIn": true,
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Add Mobile Phone Contact

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/contacts
Content-Type: application/json
Authorization: Bearer {token}

{
  "contactType": "Mobile",
  "value": "+44 7700 900123",
  "isPrimary": true,
  "marketingOptIn": false
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 2002,
  "href": "/api/v2/factfinds/679/clients/8496/contacts/2002",
  "contactType": "Mobile",
  "value": "+44 7700 900123",
  "isPrimary": true,
  "isPreferred": false,
  "isVerified": false,
  "marketingOptIn": false,
  "createdAt": "2026-03-03T10:32:00Z",
  "updatedAt": "2026-03-03T10:32:00Z"
}
```

### 7.6 Business Rules

1. **At least one contact required:** Client must have at least one primary email or phone contact
2. **One primary per type:** Only one contact can be primary for each contact type
3. **Only one preferred:** Only one contact can be marked as preferred overall
4. **Email format validation:** Email addresses must be valid format
5. **Phone number format:** Phone numbers should include country code for international numbers
6. **Marketing consent:** `marketingOptIn` must be explicitly set by client (PECR compliance)
7. **Contact type validation:** Must be one of: Email, Phone, Mobile, Fax

### 7.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `contactType` | enum | Filter by contact type | `contactType=Email` |
| `isPrimary` | boolean | Filter primary contacts | `isPrimary=true` |
| `isVerified` | boolean | Filter verified contacts | `isVerified=true` |

### 7.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Invalid email/phone format |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid contact ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 7.9 Regulatory Compliance

**PECR (Privacy and Electronic Communications Regulations):**
- Marketing consent must be explicit opt-in
- Cannot use pre-ticked boxes
- Must provide easy opt-out mechanism
- Consent must be specific to channel (email, phone, SMS)

**GDPR:**
- Contact data is personal data
- Lawful basis required (usually consent or legitimate interest)
- Right to withdraw consent
- Right to erasure applies

### 7.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Marketing Preferences API](#16-marketing-preferences-api) - Detailed marketing consent

---

## 8. Professional Contact API

### 8.1 Overview

**Purpose:** The Professional Contact API manages references to the client's professional advisers including solicitors, accountants, and other professional relationships.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/professional-contacts`

**Key Features:**
- Solicitor contact details
- Accountant contact details
- Other professional advisers
- Contact information and firm details
- Relationship status tracking

### 8.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/professional-contacts` | List professional contacts | N/A | 200 OK - ProfessionalContact[] |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/professional-contacts` | Add professional contact | ProfessionalContactRequest | 201 Created - ProfessionalContact |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/professional-contacts/{contactId}` | Get professional contact by ID | N/A | 200 OK - ProfessionalContact |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}/professional-contacts/{contactId}` | Update professional contact | ProfessionalContactPatch | 200 OK - ProfessionalContact |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/professional-contacts/{contactId}` | Delete professional contact | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 8.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `client` | object | Yes (response only) | Reference to the client |
| `factfind` | object | Yes (response only) | Reference to the fact find |
| `professionalType` | enum | Yes | Type (Solicitor, Accountant, BankManager, Other) |
| `firmName` | string | Yes | Name of the professional firm |
| `contactName` | string | No | Name of the contact person |
| `email` | string | No | Email address |
| `phone` | string | No | Phone number |
| `address` | object | No | Firm address |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | When this record was created |
| `updatedAt` | datetime | Yes (response only) | When this record was last modified |

**Total Properties:** 13 properties

### 8.4 Contract Schema

```json
{
  "id": 3001,
  "href": "/api/v2/factfinds/679/clients/8496/professional-contacts/3001",
  "client": {
    "id": 8496,
    "clientNumber": "C00001234",
    "name": "John Smith",
    "type": "Person"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123",
    "status": "INP"
  },
  "professionalType": "Solicitor",
  "firmName": "Smith & Jones Solicitors",
  "contactName": "Alice Williams",
  "email": "alice.williams@smithjones.co.uk",
  "phone": "+44 20 7946 0958",
  "address": {
    "line1": "10 Legal Street",
    "city": "London",
    "postcode": "EC1A 1AA",
    "country": "GB"
  },
  "notes": "Handles conveyancing and wills",
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z"
}
```

### 8.5 Complete Examples

#### Example 1: Add Solicitor Contact

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/professional-contacts
Content-Type: application/json
Authorization: Bearer {token}

{
  "professionalType": "Solicitor",
  "firmName": "Smith & Jones Solicitors",
  "contactName": "Alice Williams",
  "email": "alice.williams@smithjones.co.uk",
  "phone": "+44 20 7946 0958",
  "address": {
    "line1": "10 Legal Street",
    "city": "London",
    "postcode": "EC1A 1AA",
    "country": "GB"
  },
  "notes": "Handles conveyancing and wills"
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 3001,
  "href": "/api/v2/factfinds/679/clients/8496/professional-contacts/3001",
  "professionalType": "Solicitor",
  "firmName": "Smith & Jones Solicitors",
  "contactName": "Alice Williams",
  "email": "alice.williams@smithjones.co.uk",
  "phone": "+44 20 7946 0958",
  "address": {
    "line1": "10 Legal Street",
    "city": "London",
    "postcode": "EC1A 1AA",
    "country": "GB"
  },
  "notes": "Handles conveyancing and wills",
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Add Accountant Contact

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/professional-contacts
Content-Type: application/json
Authorization: Bearer {token}

{
  "professionalType": "Accountant",
  "firmName": "ABC Accountants Ltd",
  "contactName": "Robert Brown",
  "email": "robert.brown@abcaccountants.com",
  "phone": "+44 161 123 4567"
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 3002,
  "href": "/api/v2/factfinds/679/clients/8496/professional-contacts/3002",
  "professionalType": "Accountant",
  "firmName": "ABC Accountants Ltd",
  "contactName": "Robert Brown",
  "email": "robert.brown@abcaccountants.com",
  "phone": "+44 161 123 4567",
  "createdAt": "2026-03-03T10:35:00Z",
  "updatedAt": "2026-03-03T10:35:00Z"
}
```

### 8.6 Business Rules

1. **Firm name required:** `firmName` is mandatory
2. **Contact details validation:** At least one contact method (email or phone) recommended
3. **Professional type validation:** Must be one of: Solicitor, Accountant, BankManager, Mortgage Broker, Other
4. **Email format:** Email must be valid format if provided
5. **No duplicates:** Cannot add duplicate professional contacts of the same type with same firm name

### 8.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `professionalType` | enum | Filter by professional type | `professionalType=Solicitor` |
| `firmName` | string | Filter by firm name | `firmName=Smith` |

### 8.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid contact ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 8.9 Regulatory Compliance

**MLR 2017:**
- Professional contacts may be used for verification
- Helps establish client identity and credibility

**GDPR:**
- Professional contact data is business contact data
- Lower protection requirements than personal data
- Still requires lawful basis for processing

### 8.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Estate Planning API](#12-estate-planning-api) - Solicitor referenced for wills

---

## 9. Client Relationship API

### 9.1 Overview

**Purpose:** The Client Relationship API manages relationships between clients including family connections, partners, and permissions for data access.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/relationships`

**Key Features:**
- Family relationship tracking
- Partner and spouse connections
- Data access permissions
- Family grouping for reporting
- Bidirectional relationship management

### 9.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/relationships` | List relationships | N/A | 200 OK - Relationship[] |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/relationships` | Create relationship | RelationshipRequest | 201 Created - Relationship |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/relationships/{relationshipId}` | Get relationship by ID | N/A | 200 OK - Relationship |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}/relationships/{relationshipId}` | Update relationship | RelationshipPatch | 200 OK - Relationship |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/relationships/{relationshipId}` | Delete relationship | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 9.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique identifier for the relationship |
| `href` | string | Yes (response only) | Resource URL for this relationship |
| `client` | object | Yes (response only) | The primary client in this relationship |
| `factfind` | object | Yes (response only) | FactFind reference |
| `relatedClient` | object | Yes | The related client |
| `relationshipType` | enum | Yes | Type of relationship (Spouse, Partner, Parent, Child, etc.) |
| `partner` | boolean | No | Whether this is a partner/spouse relationship |
| `familyGrouping` | boolean | No | Whether to include in family grouping/household reporting |
| `canRelatedViewClientsPlansAssets` | boolean | No | Can related client view this client's plans and assets? |
| `canClientViewRelatedsPlansAssets` | boolean | No | Can this client view related client's plans and assets? |
| `canRelatedAccessClientsData` | boolean | No | Can related client access/modify this client's data? |
| `canClientAccessRelatedsData` | boolean | No | Can this client access/modify related client's data? |
| `createdAt` | datetime | Yes (response only) | When this record was created |
| `updatedAt` | datetime | Yes (response only) | When this record was last updated |
| `createdBy` | string | Yes (response only) | User who created this record |
| `updatedBy` | string | Yes (response only) | User who last updated this record |

**Total Properties:** 16 properties

### 9.4 Contract Schema

```json
{
  "id": 4001,
  "href": "/api/v2/factfinds/679/clients/8496/relationships/4001",
  "client": {
    "id": 8496,
    "href": "/api/v2/factfinds/679/clients/8496",
    "clientNumber": "C00001234",
    "name": "John Smith",
    "type": "Person"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123",
    "status": "INP"
  },
  "relatedClient": {
    "id": 8497,
    "href": "/api/v2/factfinds/679/clients/8497",
    "clientNumber": "C00001235",
    "name": "Sarah Smith",
    "type": "Person"
  },
  "relationshipType": "Spouse",
  "partner": true,
  "familyGrouping": true,
  "canRelatedViewClientsPlansAssets": true,
  "canClientViewRelatedsPlansAssets": true,
  "canRelatedAccessClientsData": false,
  "canClientAccessRelatedsData": false,
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "createdBy": "jane.adviser@acme.com",
  "updatedBy": "jane.adviser@acme.com"
}
```

### 9.5 Complete Examples

#### Example 1: Create Spouse Relationship

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/relationships
Content-Type: application/json
Authorization: Bearer {token}

{
  "relatedClient": {
    "id": 8497
  },
  "relationshipType": "Spouse",
  "partner": true,
  "familyGrouping": true,
  "canRelatedViewClientsPlansAssets": true,
  "canClientViewRelatedsPlansAssets": true
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 4001,
  "href": "/api/v2/factfinds/679/clients/8496/relationships/4001",
  "client": {
    "id": 8496,
    "name": "John Smith"
  },
  "relatedClient": {
    "id": 8497,
    "name": "Sarah Smith"
  },
  "relationshipType": "Spouse",
  "partner": true,
  "familyGrouping": true,
  "canRelatedViewClientsPlansAssets": true,
  "canClientViewRelatedsPlansAssets": true,
  "canRelatedAccessClientsData": false,
  "canClientAccessRelatedsData": false,
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Create Parent-Child Relationship

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/relationships
Content-Type: application/json
Authorization: Bearer {token}

{
  "relatedClient": {
    "id": 8498
  },
  "relationshipType": "Parent",
  "familyGrouping": true,
  "canRelatedViewClientsPlansAssets": false,
  "canClientViewRelatedsPlansAssets": true
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 4002,
  "href": "/api/v2/factfinds/679/clients/8496/relationships/4002",
  "client": {
    "id": 8496,
    "name": "John Smith"
  },
  "relatedClient": {
    "id": 8498,
    "name": "Margaret Smith"
  },
  "relationshipType": "Parent",
  "partner": false,
  "familyGrouping": true,
  "canRelatedViewClientsPlansAssets": false,
  "canClientViewRelatedsPlansAssets": true,
  "createdAt": "2026-03-03T10:35:00Z",
  "updatedAt": "2026-03-03T10:35:00Z"
}
```

### 9.6 Business Rules

1. **No self-relationships:** Client cannot have a relationship with themselves
2. **Unique relationships:** Cannot create duplicate relationships between same two clients
3. **Relationship type validation:** Must be one of: Spouse, CivilPartner, Partner, Parent, Child, Sibling, Grandparent, Grandchild, Other
4. **Partner flag:** If `relationshipType` is Spouse or CivilPartner, `partner` should be true
5. **Bidirectional permissions:** Access permissions should be set appropriately for both directions
6. **Same factfind:** Related clients must be in the same fact find
7. **Family grouping:** At least Spouse/Partner relationships should have `familyGrouping=true`

### 9.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `relationshipType` | enum | Filter by relationship type | `relationshipType=Spouse` |
| `partner` | boolean | Filter partner relationships | `partner=true` |
| `familyGrouping` | boolean | Filter family grouping | `familyGrouping=true` |

### 9.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid relationship ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 9.9 Regulatory Compliance

**GDPR:**
- Relationship data is personal data
- Access permissions must be documented
- Data sharing requires lawful basis
- Right to erasure applies

**FCA Consumer Duty:**
- Clear communication of data sharing
- Appropriate consent for access permissions
- Fair treatment of vulnerable clients

### 9.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Dependant API](#10-dependant-api) - Financial dependants (subset of relationships)

---
## 10. Dependant API

### 10.1 Overview

**Purpose:** The Dependant API manages information about persons financially dependent on the client, including children, elderly relatives, and others requiring support.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/dependants`

**Key Features:**
- Financial dependency tracking
- Protection needs analysis
- Education planning details
- Special needs identification
- Custody arrangement documentation

### 10.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/dependants` | List dependants | N/A | 200 OK - Dependant[] |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/dependants` | Add dependant | DependantRequest | 201 Created - Dependant |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/dependants/{dependantId}` | Get dependant details | N/A | 200 OK - Dependant |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}/dependants/{dependantId}` | Update dependant | DependantPatch | 200 OK - Dependant |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/dependants/{dependantId}` | Delete dependant | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 10.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `clients` | array | Yes | List of clients to whom this dependant belongs |
| `factfind` | object | Yes (response only) | Reference to the fact find |
| `firstName` | string | Yes | First name (given name) |
| `middleNames` | string | No | Middle name(s) |
| `lastName` | string | Yes | Last name (surname/family name) |
| `fullName` | string | No (calculated) | Complete formatted name |
| `dateOfBirth` | date | Yes | Date of birth |
| `age` | integer | No (calculated) | Current age (calculated from date of birth) |
| `gender` | enum | No | Gender (M, F, O, X) |
| `relationship` | enum | Yes | Relationship to client (CHILD, STEP_CHILD, GRANDCHILD, PARENT, etc.) |
| `isFinanciallyDependent` | boolean | No | Whether financially dependent on the client |
| `dependencyDetails` | object | No | Financial dependency cost details |
| `dependencyDetails.annualCost` | money | No | Annual cost to support this dependant |
| `dependencyDetails.monthlyCost` | money | No | Monthly cost to support this dependant |
| `dependencyDetails.estimatedDependencyEndAge` | integer | No | Age when financial dependency is expected to end |
| `dependencyDetails.estimatedDependencyEndDate` | date | No | Date when financial dependency is expected to end |
| `educationDetails` | object | No | Education status and cost planning |
| `educationDetails.currentEducationLevel` | string | No | Current education level |
| `educationDetails.isInPrivateEducation` | boolean | No | Whether currently in private/independent school |
| `educationDetails.plannedHigherEducation` | boolean | No | Whether higher education (university) is planned |
| `educationDetails.estimatedEducationCosts` | money | No | Total estimated education costs (remaining) |
| `healthDetails` | object | No | Health status and care requirements |
| `healthDetails.hasSpecialNeeds` | boolean | No | Whether dependant has special needs or disabilities |
| `healthDetails.requiresOngoingCare` | boolean | No | Whether ongoing care is required |
| `healthDetails.healthNotes` | string | No | Additional health information or care requirements |
| `livingArrangements` | object | No | Current living situation |
| `livingArrangements.livesWithClient` | boolean | No | Whether dependant currently lives with client |
| `livingArrangements.custodyArrangement` | enum | No | Custody arrangement type |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | When this record was created |
| `updatedAt` | datetime | Yes (response only) | When this record was last modified |

**Total Properties:** 31 properties (including nested)

### 10.4 Contract Schema

```json
{
  "id": 999,
  "href": "/api/v2/factfinds/679/clients/8496/dependants/999",
  "clients": [
    {
      "id": 8496,
      "href": "/api/v2/factfinds/679/clients/8496",
      "name": "John Smith"
    },
    {
      "id": 8497,
      "href": "/api/v2/factfinds/679/clients/8497",
      "name": "Sarah Smith"
    }
  ],
  "factfind": {
    "id": 679
  },
  "firstName": "Emily",
  "middleNames": "Rose",
  "lastName": "Smith",
  "fullName": "Emily Rose Smith",
  "dateOfBirth": "2015-08-20",
  "age": 10,
  "gender": "F",
  "relationship": "CHILD",
  "isFinanciallyDependent": true,
  "dependencyDetails": {
    "annualCost": {
      "amount": 9600.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "monthlyCost": {
      "amount": 800.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "estimatedDependencyEndAge": 21,
    "estimatedDependencyEndDate": "2036-08-20"
  },
  "educationDetails": {
    "currentEducationLevel": "Primary School",
    "isInPrivateEducation": false,
    "plannedHigherEducation": true,
    "estimatedEducationCosts": {
      "amount": 50000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    }
  },
  "healthDetails": {
    "hasSpecialNeeds": false,
    "requiresOngoingCare": false,
    "healthNotes": null
  },
  "livingArrangements": {
    "livesWithClient": true,
    "custodyArrangement": "Full Custody"
  },
  "notes": "Plans to attend university - considering STEM subjects",
  "createdAt": "2026-01-05T10:00:00Z",
  "updatedAt": "2026-02-01T09:30:00Z"
}
```

### 10.5 Complete Examples

#### Example 1: Add Child Dependant

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/dependants
Content-Type: application/json
Authorization: Bearer {token}

{
  "firstName": "Emily",
  "middleNames": "Rose",
  "lastName": "Smith",
  "dateOfBirth": "2015-08-20",
  "gender": "F",
  "relationship": "CHILD",
  "isFinanciallyDependent": true,
  "dependencyDetails": {
    "monthlyCost": {
      "amount": 800.00,
      "currency": {
        "code": "GBP"
      }
    },
    "estimatedDependencyEndAge": 21
  },
  "educationDetails": {
    "currentEducationLevel": "Primary School",
    "isInPrivateEducation": false,
    "plannedHigherEducation": true,
    "estimatedEducationCosts": {
      "amount": 50000.00,
      "currency": {
        "code": "GBP"
      }
    }
  },
  "livingArrangements": {
    "livesWithClient": true,
    "custodyArrangement": "Full Custody"
  }
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 999,
  "href": "/api/v2/factfinds/679/clients/8496/dependants/999",
  "clients": [
    {
      "id": 8496,
      "name": "John Smith"
    }
  ],
  "firstName": "Emily",
  "middleNames": "Rose",
  "lastName": "Smith",
  "fullName": "Emily Rose Smith",
  "dateOfBirth": "2015-08-20",
  "age": 10,
  "gender": "F",
  "relationship": "CHILD",
  "isFinanciallyDependent": true,
  "dependencyDetails": {
    "annualCost": {
      "amount": 9600.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "monthlyCost": {
      "amount": 800.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "estimatedDependencyEndAge": 21,
    "estimatedDependencyEndDate": "2036-08-20"
  },
  "educationDetails": {
    "currentEducationLevel": "Primary School",
    "isInPrivateEducation": false,
    "plannedHigherEducation": true,
    "estimatedEducationCosts": {
      "amount": 50000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "livingArrangements": {
    "livesWithClient": true,
    "custodyArrangement": "Full Custody"
  },
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Add Elderly Parent Dependant

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/dependants
Content-Type: application/json
Authorization: Bearer {token}

{
  "firstName": "Margaret",
  "lastName": "Smith",
  "dateOfBirth": "1941-03-15",
  "gender": "F",
  "relationship": "PARENT",
  "isFinanciallyDependent": true,
  "dependencyDetails": {
    "monthlyCost": {
      "amount": 3000.00,
      "currency": {
        "code": "GBP"
      }
    }
  },
  "healthDetails": {
    "hasSpecialNeeds": false,
    "requiresOngoingCare": true,
    "healthNotes": "Residential care home fees"
  },
  "livingArrangements": {
    "livesWithClient": false,
    "custodyArrangement": null
  },
  "notes": "Care home fees £4,000/month, state pension covers £1,000"
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1000,
  "href": "/api/v2/factfinds/679/clients/8496/dependants/1000",
  "firstName": "Margaret",
  "lastName": "Smith",
  "fullName": "Margaret Smith",
  "dateOfBirth": "1941-03-15",
  "age": 85,
  "gender": "F",
  "relationship": "PARENT",
  "isFinanciallyDependent": true,
  "dependencyDetails": {
    "annualCost": {
      "amount": 36000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "monthlyCost": {
      "amount": 3000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "healthDetails": {
    "hasSpecialNeeds": false,
    "requiresOngoingCare": true,
    "healthNotes": "Residential care home fees"
  },
  "livingArrangements": {
    "livesWithClient": false
  },
  "notes": "Care home fees £4,000/month, state pension covers £1,000",
  "createdAt": "2026-03-03T10:35:00Z",
  "updatedAt": "2026-03-03T10:35:00Z"
}
```

### 10.6 Business Rules

1. **Date of birth validation:** Must be in the past
2. **Age calculation:** Age is automatically calculated from `dateOfBirth`
3. **Annual cost calculation:** `annualCost` automatically calculated from `monthlyCost × 12`
4. **Dependency end date calculation:** If `estimatedDependencyEndAge` provided, end date is calculated
5. **Relationship validation:** Must be one of: CHILD, STEP_CHILD, GRANDCHILD, PARENT, SPOUSE_PARTNER, SIBLING, OTHER
6. **Custody arrangement validation:** Must be one of: Full Custody, Shared Custody, Primary Custody, Visiting Rights, No Contact
7. **Joint dependants:** For joint fact finds, child dependants typically belong to both clients

### 10.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `relationship` | enum | Filter by relationship type | `relationship=CHILD` |
| `isFinanciallyDependent` | boolean | Filter financially dependent | `isFinanciallyDependent=true` |
| `hasSpecialNeeds` | boolean | Filter special needs | `hasSpecialNeeds=true` |

### 10.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid dependant ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 10.9 Regulatory Compliance

**GDPR:**
- Dependant data is personal data of vulnerable individuals (children)
- Heightened protection requirements
- Parental consent required for processing children's data
- Right to erasure applies

**FCA Consumer Duty:**
- Protection needs analysis must consider dependants
- Vulnerable client considerations for special needs dependants

### 10.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Client Relationship API](#9-client-relationship-api) - Broader relationships
- [Personal Protection API](#30-personal-protection-api) - Life insurance for dependants

---

## 11. Vulnerability API

### 11.1 Overview

**Purpose:** The Vulnerability API manages client vulnerability assessments as required by FCA Consumer Duty regulations.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/vulnerabilities`

**Key Features:**
- FCA vulnerability category tracking
- Temporary and permanent vulnerability classification
- Matching service proposition flagging
- Review date management
- Actionable support tracking

### 11.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/vulnerabilities` | List all client vulnerabilities | N/A | 200 OK - Vulnerability[] |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/vulnerabilities` | Create a vulnerability | VulnerabilityRequest | 201 Created - Vulnerability |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/vulnerabilities/{vulnerabilityId}` | Get vulnerability by ID | N/A | 200 OK - Vulnerability |
| PUT | `/api/v2/factfinds/{factfindId}/clients/{clientId}/vulnerabilities/{vulnerabilityId}` | Update a vulnerability | VulnerabilityRequest | 200 OK - Vulnerability |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/vulnerabilities/{vulnerabilityId}` | Delete a vulnerability | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 11.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `client` | object | Yes (response only) | Reference to the client |
| `hasVulnerability` | enum | Yes | Whether client has vulnerability (Yes, No, Potential) |
| `type` | enum | Conditional | Type of vulnerability (Temporary, Permanent) - required if hasVulnerability=Yes |
| `categories` | array | Conditional | List of vulnerability categories - required if hasVulnerability=Yes |
| `notes` | string | No | Vulnerability notes (max 4000 characters) |
| `assessedOn` | date | No | When vulnerability was assessed |
| `reviewOn` | date | No | When vulnerability should be reviewed |
| `isClientPortalSuitable` | string | No | Whether client portal is suitable for the vulnerable client |
| `vulnerabilityActionTaken` | string | No | Vulnerability action taken notes (max 300 characters) |
| `createdBy` | object | Yes (response only) | User who created the record |
| `createdAt` | datetime | Yes (response only) | When this record was created |
| `updatedAt` | datetime | Yes (response only) | When this record was last modified |

**Total Properties:** 14 properties

**Vulnerability Categories (FCA):**
- **Health** - Physical/mental health conditions, disabilities, hearing/visual impairments
- **LifeEvent** - Bereavement, relationship breakdown, job loss, caring responsibilities
- **Resilience** - Low income, over-indebtedness, low savings, unemployment
- **Capability** - Low literacy/numeracy, poor English, low knowledge of financial matters, learning difficulties

### 11.4 Contract Schema

```json
{
  "id": 5001,
  "href": "/api/v2/factfinds/679/clients/8496/vulnerabilities/5001",
  "client": {
    "id": 8496,
    "clientNumber": "C00001234",
    "name": "John Smith"
  },
  "hasVulnerability": "Yes",
  "type": "Temporary",
  "categories": [
    "LifeEvent",
    "Resilience"
  ],
  "notes": "Client recently bereaved (spouse) and experiencing temporary financial difficulty due to loss of partner's income. Requires additional support and clear communication. Has good financial understanding but emotionally vulnerable.",
  "assessedOn": "2026-02-15",
  "reviewOn": "2026-08-15",
  "isClientPortalSuitable": "With support",
  "vulnerabilityActionTaken": "Arranged for face-to-face meetings only. Provide written summaries. Check understanding throughout.",
  "createdBy": {
    "id": 8724,
    "name": "Jane Doe"
  },
  "createdAt": "2026-02-15T10:30:00Z",
  "updatedAt": "2026-02-15T10:30:00Z"
}
```

### 11.5 Complete Examples

#### Example 1: Record Temporary Vulnerability (Bereavement)

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/vulnerabilities
Content-Type: application/json
Authorization: Bearer {token}

{
  "hasVulnerability": "Yes",
  "type": "Temporary",
  "categories": [
    "LifeEvent",
    "Resilience"
  ],
  "notes": "Client recently bereaved (spouse) and experiencing temporary financial difficulty due to loss of partner's income. Requires additional support and clear communication.",
  "assessedOn": "2026-02-15",
  "reviewOn": "2026-08-15",
  "isClientPortalSuitable": "With support",
  "vulnerabilityActionTaken": "Arranged for face-to-face meetings only. Provide written summaries. Check understanding throughout."
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 5001,
  "href": "/api/v2/factfinds/679/clients/8496/vulnerabilities/5001",
  "hasVulnerability": "Yes",
  "type": "Temporary",
  "categories": [
    "LifeEvent",
    "Resilience"
  ],
  "notes": "Client recently bereaved (spouse) and experiencing temporary financial difficulty due to loss of partner's income. Requires additional support and clear communication.",
  "assessedOn": "2026-02-15",
  "reviewOn": "2026-08-15",
  "isClientPortalSuitable": "With support",
  "vulnerabilityActionTaken": "Arranged for face-to-face meetings only. Provide written summaries. Check understanding throughout.",
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Record Permanent Vulnerability (Health)

**Request:**
```http
POST /api/v2/factfinds/679/clients/8497/vulnerabilities
Content-Type: application/json
Authorization: Bearer {token}

{
  "hasVulnerability": "Yes",
  "type": "Permanent",
  "categories": [
    "Health",
    "Capability"
  ],
  "notes": "Client has severe hearing impairment and requires written communication. BSL interpreter available for important meetings. Client has good financial understanding but communication needs special consideration.",
  "assessedOn": "2026-03-01",
  "reviewOn": "2027-03-01",
  "isClientPortalSuitable": "Yes",
  "vulnerabilityActionTaken": "All communications in writing. Email preferred. BSL interpreter booked for annual reviews. Face-to-face meetings with note-taking."
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 5002,
  "href": "/api/v2/factfinds/679/clients/8497/vulnerabilities/5002",
  "hasVulnerability": "Yes",
  "type": "Permanent",
  "categories": [
    "Health",
    "Capability"
  ],
  "notes": "Client has severe hearing impairment and requires written communication. BSL interpreter available for important meetings.",
  "assessedOn": "2026-03-01",
  "reviewOn": "2027-03-01",
  "isClientPortalSuitable": "Yes",
  "vulnerabilityActionTaken": "All communications in writing. Email preferred. BSL interpreter booked for annual reviews.",
  "createdAt": "2026-03-03T10:35:00Z",
  "updatedAt": "2026-03-03T10:35:00Z"
}
```

### 11.6 Business Rules

1. **Vulnerability assessment required:** All clients must be assessed for vulnerability
2. **Categories required if vulnerable:** If `hasVulnerability=Yes`, at least one category must be selected
3. **Type required if vulnerable:** If `hasVulnerability=Yes`, type (Temporary/Permanent) must be specified
4. **Review dates:**
   - Temporary vulnerabilities: Review every 6 months
   - Permanent vulnerabilities: Review annually
5. **Action documentation:** `vulnerabilityActionTaken` should document specific support measures
6. **Validation values:**
   - `hasVulnerability`: Yes, No, Potential
   - `type`: Temporary, Permanent
   - `categories`: Health, LifeEvent, Resilience, Capability

### 11.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `hasVulnerability` | enum | Filter by vulnerability status | `hasVulnerability=Yes` |
| `type` | enum | Filter by type | `type=Permanent` |
| `category` | enum | Filter by category | `category=Health` |
| `reviewDue` | boolean | Filter reviews due | `reviewDue=true` |

### 11.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PUT successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid vulnerability ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 11.9 Regulatory Compliance

**FCA Consumer Duty (July 2023):**
- Firms must identify and support vulnerable customers
- Four key vulnerability drivers: Health, Life events, Resilience, Capability
- Reasonable adjustments must be made
- Staff training on vulnerability required
- Regular reviews of vulnerability status

**FCA Guidance FG21/1 - Guidance for firms on the fair treatment of vulnerable customers:**
- Understanding needs of vulnerable customers
- Ensuring products and services meet their needs
- Good customer service for vulnerable customers
- Monitoring and review of support provided

**Equality Act 2010:**
- Reasonable adjustments for disabled customers
- Accessibility requirements

### 11.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource with `isMatchingServiceProposition` flag
- [Marketing Preferences API](#16-marketing-preferences-api) - Adjusted marketing approach
- [DPA Agreement API](#17-dpa-agreement-api) - Enhanced consent process

---

## 12. Estate Planning API

### 12.1 Overview

**Purpose:** The Estate Planning API manages client estate planning information including wills, lasting powers of attorney (LPAs), trusts, and gifts for inheritance tax planning.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/estate-planning`

**Key Features:**
- Will arrangement tracking
- Lasting Power of Attorney (LPA) management
- Gift recording (7-year rule tracking)
- IHT allowance calculations (NRB, RNRB)
- Trust arrangement documentation

### 12.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/estate-planning` | Get estate planning details | N/A | 200 OK - EstatePlanning |
| PUT | `/api/v2/factfinds/{factfindId}/clients/{clientId}/estate-planning` | Update estate planning | EstatePlanningRequest | 200 OK - EstatePlanning |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/estate-planning/gifts` | List all gifts | N/A | 200 OK - Gift[] |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/estate-planning/gifts` | Create new gift | GiftRequest | 201 Created - Gift |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/estate-planning/gifts/{giftId}` | Get specific gift | N/A | 200 OK - Gift |
| PUT | `/api/v2/factfinds/{factfindId}/clients/{clientId}/estate-planning/gifts/{giftId}` | Update gift | GiftRequest | 200 OK - Gift |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/estate-planning/gifts/{giftId}` | Delete gift | N/A | 204 No Content |

**Total Operations:** 7 endpoints

### 12.3 Resource Properties

#### Estate Planning Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `href` | string | Yes (response only) | Resource URL for this estate planning record |
| `client` | object | Yes (response only) | Client reference |
| `factfind` | object | Yes (response only) | FactFind reference |
| `willDetails` | string | No | Free-text description of will arrangements |
| `totalAssets` | money | No | Total value of client's estate |
| `totalJointAssets` | money | No | Total value of jointly owned assets |
| `giftInLast7YearsDetails` | string | No | Description of gifts made in last 7 years |
| `recentGiftDetails` | string | No | Description of recent gifts (current tax year) |
| `regularGiftDetails` | string | No | Description of regular gifts from income |
| `expectingInheritanceDetails` | string | No | Description of expected inheritance |
| `propertyAdditionalNrb` | money | No | Residence nil rate band (max £175,000) |
| `taxYearWhenPropertySold` | integer | No | Tax year when main residence was sold (if applicable) |
| `widowsReliefNrbDeceasedPercentage` | decimal | No | Percentage of deceased spouse's NRB available to transfer (0-100) |
| `widowsReliefPropertyAdditionalNrbDeceasedPercentage` | decimal | No | Percentage of deceased spouse's RNRB available to transfer (0-100) |
| `businessAssetRelief` | money | No | Business property relief available |
| `gifts` | array | No | Collection of gifts |
| `createdAt` | datetime | Yes (response only) | When this record was created |
| `updatedAt` | datetime | Yes (response only) | When this record was last updated |

#### Gift Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique gift identifier |
| `giftDate` | date | Yes | Date gift was made |
| `recipient` | string | Yes | Name of recipient |
| `relationship` | string | No | Relationship to client |
| `amount` | money | Yes | Value of gift |
| `description` | string | No | Description of gift |
| `isRegularGiftFromIncome` | boolean | No | Whether this is a regular gift from surplus income |
| `isWithinAnnualExemption` | boolean | No | Whether covered by £3,000 annual exemption |

### 12.4 Contract Schema

```json
{
  "href": "/api/v2/factfinds/679/clients/8496/estate-planning",
  "client": {
    "id": 8496,
    "href": "/api/v2/factfinds/679/clients/8496",
    "name": "John Smith"
  },
  "factfind": {
    "id": 679
  },
  "willDetails": "Mirror wills in place with spouse. Estate passes to spouse on first death, then to children equally. Executors: spouse and solicitor. Guardians appointed for children under 18.",
  "totalAssets": {
    "amount": 850000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "totalJointAssets": {
    "amount": 425000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "giftInLast7YearsDetails": "Annual exemption gifts to both children (£3,000 per year each)",
  "recentGiftDetails": "£3,000 to daughter Emily (annual exemption 2025/26)",
  "regularGiftDetails": "Monthly £250 into each child's Junior ISA from surplus income",
  "expectingInheritanceDetails": "Potential inheritance from parents' estate (estimated £200,000)",
  "propertyAdditionalNrb": {
    "amount": 175000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "taxYearWhenPropertySold": null,
  "widowsReliefNrbDeceasedPercentage": null,
  "widowsReliefPropertyAdditionalNrbDeceasedPercentage": null,
  "businessAssetRelief": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "gifts": [
    {
      "id": 1,
      "giftDate": "2025-04-10",
      "recipient": "Emily Rose Smith",
      "relationship": "Daughter",
      "amount": {
        "amount": 3000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "description": "Annual exemption gift for tax year 2025/26",
      "isRegularGiftFromIncome": false,
      "isWithinAnnualExemption": true
    }
  ],
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-03-01T14:20:00Z"
}
```

### 12.5 Complete Examples

#### Example 1: Update Estate Planning Details

**Request:**
```http
PUT /api/v2/factfinds/679/clients/8496/estate-planning
Content-Type: application/json
Authorization: Bearer {token}

{
  "willDetails": "Mirror wills updated January 2026. Estate passes to spouse on first death, then to children equally. Executors: spouse and solicitor.",
  "totalAssets": {
    "amount": 850000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "totalJointAssets": {
    "amount": 425000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "propertyAdditionalNrb": {
    "amount": 175000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "giftInLast7YearsDetails": "Annual exemption gifts to both children",
  "regularGiftDetails": "Monthly £250 into each child's Junior ISA"
}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "href": "/api/v2/factfinds/679/clients/8496/estate-planning",
  "willDetails": "Mirror wills updated January 2026. Estate passes to spouse on first death, then to children equally. Executors: spouse and solicitor.",
  "totalAssets": {
    "amount": 850000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "totalJointAssets": {
    "amount": 425000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "propertyAdditionalNrb": {
    "amount": 175000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Record Gift

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/estate-planning/gifts
Content-Type: application/json
Authorization: Bearer {token}

{
  "giftDate": "2025-04-10",
  "recipient": "Emily Rose Smith",
  "relationship": "Daughter",
  "amount": {
    "amount": 3000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "description": "Annual exemption gift for tax year 2025/26",
  "isRegularGiftFromIncome": false,
  "isWithinAnnualExemption": true
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1,
  "href": "/api/v2/factfinds/679/clients/8496/estate-planning/gifts/1",
  "giftDate": "2025-04-10",
  "recipient": "Emily Rose Smith",
  "relationship": "Daughter",
  "amount": {
    "amount": 3000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "description": "Annual exemption gift for tax year 2025/26",
  "isRegularGiftFromIncome": false,
  "isWithinAnnualExemption": true,
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

### 12.6 Business Rules

1. **NRB (Nil Rate Band):** Standard £325,000 (frozen until April 2028)
2. **RNRB (Residence Nil Rate Band):** Up to £175,000 when main residence passes to direct descendants
3. **Transferable allowances:** Widow/widower can inherit unused NRB and RNRB from deceased spouse
4. **RNRB taper:** Reduces £1 for every £2 over £2 million estate value
5. **7-year rule:** Gifts made more than 7 years before death are IHT-free
6. **Annual exemption:** £3,000 per year (can carry forward one unused year)
7. **Regular gifts from income:** Immediately exempt if from surplus income

### 12.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `giftDateFrom` | date | Filter gifts from date | `giftDateFrom=2020-01-01` |
| `giftDateTo` | date | Filter gifts to date | `giftDateTo=2026-12-31` |
| `within7Years` | boolean | Filter gifts within 7 years | `within7Years=true` |

### 12.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PUT successful |
| 201 Created | Resource created | POST successful (gift) |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid gift ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 12.9 Regulatory Compliance

**UK Inheritance Tax:**
- IHT charged at 40% on estates above nil rate band
- Reduced to 36% if 10%+ of estate left to charity
- Potentially Exempt Transfers (PETs) within 7 years

**Estate Planning Best Practices:**
- Wills should be reviewed every 5 years
- LPAs should be in place (Property & Affairs, Health & Welfare)
- Regular gift recording for IHT planning
- Consider trust arrangements for asset protection

### 12.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Asset API](#22-asset-api) - Estate valuation
- [Professional Contact API](#8-professional-contact-api) - Solicitor details

---

## 13. Identity Verification API

### 13.1 Overview

**Purpose:** The Identity Verification API manages KYC/AML identity verification records as required by UK Money Laundering Regulations 2017.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/id-verification`

**Key Features:**
- Document verification tracking (passport, driving licence, etc.)
- Electronic verification integration
- Address verification (3-year history)
- Witness verification
- Verification expiry management

### 13.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/id-verification` | Get identity verification details | N/A | 200 OK - IdentityVerification |
| PUT | `/api/v2/factfinds/{factfindId}/clients/{clientId}/id-verification` | Update identity verification details | IdentityVerificationRequest | 200 OK - IdentityVerification |

**Total Operations:** 2 endpoints (singleton resource)

### 13.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `href` | string | Yes (response only) | Resource URL |
| `client` | object | Yes (response only) | Client personal information |
| `contacts` | array | No | Contact methods |
| `currentAddress` | object | No | Current residential address |
| `previousAddresses` | array | No | Address history (3-year requirement) |
| `clientIdentity` | object | No | Identity documents |
| `supportingDocuments` | array | No | Uploaded document references |
| `adviser` | object | No | Adviser who performed verification |
| `verification` | object | No | Witness and premises verification |
| `verificationResult` | object | No | Third-party verification result |
| `comments` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | Record creation timestamp |
| `updatedAt` | datetime | Yes (response only) | Last update timestamp |
| `createdBy` | string | Yes (response only) | User who created the record |
| `updatedBy` | string | Yes (response only) | User who last updated the record |

**Identity Documents (clientIdentity):**
- Passport
- Driving Licence
- Utility Bills (electricity, gas, water)
- Council Tax Bill
- Bank Statement
- Mortgage Statement
- HMRC Tax Notification

### 13.4 Contract Schema

```json
{
  "href": "/api/v2/factfinds/679/clients/8496/id-verification",
  "client": {
    "id": 8496,
    "href": "/api/v2/factfinds/679/clients/8496",
    "title": "MR",
    "firstName": "John",
    "middleName": "Michael",
    "lastName": "Smith",
    "gender": "M",
    "dateOfBirth": "1980-05-15",
    "placeOfBirth": "London",
    "countryOfBirth": {
      "code": "GB",
      "display": "United Kingdom"
    }
  },
  "contacts": [
    {
      "type": "Email",
      "value": "john.smith@example.com"
    },
    {
      "type": "Mobile",
      "value": "+44 7700 900123"
    }
  ],
  "currentAddress": {
    "residentFrom": "2020-01-15",
    "yearsAtAddress": "6",
    "address": {
      "line1": "123 High Street",
      "line2": "Apartment 4B",
      "locality": "London",
      "postalCode": "SW1A 1AA",
      "country": {
        "code": "GB",
        "display": "United Kingdom"
      }
    }
  },
  "previousAddresses": [
    {
      "residentFrom": "2015-06-01",
      "residentTo": "2020-01-14",
      "yearsAtAddress": "4.5",
      "address": {
        "line1": "45 Oak Avenue",
        "locality": "Manchester",
        "postalCode": "M1 2AB",
        "country": {
          "code": "GB",
          "display": "United Kingdom"
        }
      }
    }
  ],
  "clientIdentity": {
    "passport": {
      "referenceNo": "123456789",
      "seenOn": "2026-02-16",
      "expiryOn": "2030-05-15",
      "countryOfOrigin": {
        "code": "GB",
        "display": "United Kingdom"
      }
    },
    "utilitiesBill": {
      "referenceNo": "EDF-123456",
      "seenOn": "2026-02-16",
      "expiryOn": null
    }
  },
  "supportingDocuments": [
    {
      "id": 9001,
      "href": "/api/v2/documents/9001"
    },
    {
      "id": 9002,
      "href": "/api/v2/documents/9002"
    }
  ],
  "adviser": {
    "id": 8724,
    "href": "/api/v2/advisers/8724"
  },
  "verification": {
    "witness": {
      "position": "Financial Adviser",
      "witnessedOn": "2026-02-16"
    },
    "premises": {
      "lastVisitedOn": "2026-02-16",
      "enteredOn": "2026-02-16",
      "expiryOn": "2029-02-16"
    }
  },
  "verificationResult": {
    "providerName": "GBG",
    "status": "Completed",
    "outcome": "Pass",
    "score": 95,
    "verifiedOn": "2026-02-16T10:30:00Z",
    "certificateDocument": {
      "id": 9003,
      "href": "/api/v2/documents/9003"
    },
    "createdAt": "2026-02-16T10:30:00Z",
    "updatedAt": "2026-02-16T10:30:00Z"
  },
  "comments": "Client identity verified via passport and utility bill. Electronic verification passed with high confidence score.",
  "createdAt": "2026-02-16T10:30:00Z",
  "updatedAt": "2026-02-16T10:30:00Z",
  "createdBy": "jane.adviser@acme.com",
  "updatedBy": "jane.adviser@acme.com"
}
```

### 13.5 Complete Examples

#### Example 1: Update Identity Verification with Passport

**Request:**
```http
PUT /api/v2/factfinds/679/clients/8496/id-verification
Content-Type: application/json
Authorization: Bearer {token}

{
  "currentAddress": {
    "residentFrom": "2020-01-15",
    "address": {
      "line1": "123 High Street",
      "line2": "Apartment 4B",
      "locality": "London",
      "postalCode": "SW1A 1AA",
      "country": {
        "code": "GB"
      }
    }
  },
  "clientIdentity": {
    "passport": {
      "referenceNo": "123456789",
      "seenOn": "2026-02-16",
      "expiryOn": "2030-05-15",
      "countryOfOrigin": {
        "code": "GB"
      }
    },
    "utilitiesBill": {
      "referenceNo": "EDF-123456",
      "seenOn": "2026-02-16"
    }
  },
  "verification": {
    "witness": {
      "position": "Financial Adviser",
      "witnessedOn": "2026-02-16"
    },
    "premises": {
      "lastVisitedOn": "2026-02-16",
      "enteredOn": "2026-02-16",
      "expiryOn": "2029-02-16"
    }
  },
  "comments": "Client identity verified via passport and utility bill."
}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "href": "/api/v2/factfinds/679/clients/8496/id-verification",
  "client": {
    "id": 8496,
    "firstName": "John",
    "lastName": "Smith",
    "dateOfBirth": "1980-05-15"
  },
  "currentAddress": {
    "residentFrom": "2020-01-15",
    "yearsAtAddress": "6",
    "address": {
      "line1": "123 High Street",
      "locality": "London",
      "postalCode": "SW1A 1AA"
    }
  },
  "clientIdentity": {
    "passport": {
      "referenceNo": "123456789",
      "seenOn": "2026-02-16",
      "expiryOn": "2030-05-15"
    },
    "utilitiesBill": {
      "referenceNo": "EDF-123456",
      "seenOn": "2026-02-16"
    }
  },
  "verification": {
    "witness": {
      "position": "Financial Adviser",
      "witnessedOn": "2026-02-16"
    },
    "premises": {
      "expiryOn": "2029-02-16"
    }
  },
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Electronic Verification Result

**Request:**
```http
PUT /api/v2/factfinds/679/clients/8496/id-verification
Content-Type: application/json
Authorization: Bearer {token}

{
  "verificationResult": {
    "providerName": "GBG",
    "status": "Completed",
    "outcome": "Pass",
    "score": 95,
    "verifiedOn": "2026-02-16T10:30:00Z"
  }
}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "href": "/api/v2/factfinds/679/clients/8496/id-verification",
  "verificationResult": {
    "providerName": "GBG",
    "status": "Completed",
    "outcome": "Pass",
    "score": 95,
    "verifiedOn": "2026-02-16T10:30:00Z",
    "createdAt": "2026-03-03T10:30:00Z",
    "updatedAt": "2026-03-03T10:30:00Z"
  },
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

### 13.6 Business Rules

1. **Primary ID required:** Passport OR Driving Licence
2. **Proof of address required:** Utility bill, bank statement, or council tax bill dated within 3 months
3. **3-year address history:** Combined address history must cover at least 3 years
4. **Verification expiry:** Typically 3 years from verification date
5. **Electronic verification:** Score >80 typically acceptable, <60 requires manual review
6. **Document requirements:**
   - All documents must be original or certified copies
   - Documents must be in date
   - Proof of address must be within 3 months
7. **Verification status:** Rejected, ManualReview, Accepted, Completed

### 13.7 Query Parameters

None (singleton resource)

### 13.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PUT successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid client ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 13.9 Regulatory Compliance

**MLR 2017 (Money Laundering Regulations):**
- Customer Due Diligence (CDD) required for all new clients
- Identity verification mandatory
- Address verification required
- Source of wealth documentation for high-risk clients
- Enhanced Due Diligence (EDD) for PEPs and high-value clients

**FCA Handbook SYSC 3.2:**
- Systems and controls for financial crime
- Identity verification procedures
- Record retention (5 years after relationship ends)
- Staff training on AML procedures

**Proceeds of Crime Act 2002:**
- Know Your Customer (KYC) obligations
- Suspicious Activity Reports (SARs) where appropriate

### 13.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Address API](#6-address-api) - Address verification
- [Contact API](#7-contact-api) - Contact verification

---
## 14. Credit History API

### 14.1 Overview

**Purpose:** The Credit History API manages comprehensive credit history records including credit scores, adverse credit events, payment history, and mortgage suitability assessments to support FCA-compliant affordability assessments.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/credit-history`

**Key Features:**
- Credit score tracking from major CRAs (Experian, Equifax, TransUnion)
- Adverse credit event management (CCJs, defaults, IVA, bankruptcy, arrears)
- Payment history tracking (12-month and 6-year history)
- Automated mortgage suitability assessment
- Credit report request management
- Credit utilization calculations
- Credit health indicators

### 14.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/credit-history` | Get complete credit history | N/A | 200 OK - CreditHistory |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/credit-history/score` | Record new credit score | CreditScoreRequest | 201 Created - CreditScore |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/credit-history/status` | Get current credit status summary | N/A | 200 OK - CreditStatus |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/credit-history/payment-events` | Record payment event | PaymentEventRequest | 201 Created - PaymentEvent |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/credit-history/utilization` | Get credit utilization analysis | N/A | 200 OK - CreditUtilization |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/credit-history/health-indicators` | Get credit health indicators | N/A | 200 OK - HealthIndicators |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/credit-history/report-request` | Request credit report from CRA | ReportRequest | 202 Accepted - RequestStatus |
| PUT | `/api/v2/factfinds/{factfindId}/clients/{clientId}/credit-history` | Update credit history details | CreditHistoryUpdate | 200 OK - CreditHistory |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/credit-history/adverse-events` | Add adverse credit event | AdverseEventRequest | 201 Created - AdverseEvent |

**Total Operations:** 9 endpoints

### 14.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `client` | object | Yes (response only) | Client reference |
| `factfind` | object | Yes (response only) | FactFind reference |
| `creditScore` | object | No | Current credit score information |
| `creditScore.score` | integer | Yes | Credit score value (provider-specific range) |
| `creditScore.maxScore` | integer | Yes | Maximum possible score |
| `creditScore.rating` | enum | Yes | Excellent, Good, Fair, Poor, Very Poor |
| `creditScore.provider` | enum | Yes | Experian, Equifax, TransUnion |
| `creditScore.checkedDate` | date | Yes | When score was obtained |
| `hasAdverseCredit` | boolean | No | Whether client has adverse credit events |
| `hasCCJ` | boolean | No | Has County Court Judgments |
| `hasBeenRefusedCredit` | boolean | No | Has been refused credit |
| `ivaHistory` | boolean | No | Has IVA history |
| `hasDefault` | boolean | No | Has default records |
| `hasBankruptcyHistory` | boolean | No | Has bankruptcy history |
| `hasArrears` | boolean | No | Has payment arrears |
| `adverseCreditEvents` | array | No | Detailed adverse credit event records |
| `missedPayments` | object | No | Missed payment summary |
| `missedPayments.last12Months` | integer | No | Count in last 12 months |
| `missedPayments.last6Years` | integer | No | Count in last 6 years |
| `mortgageSuitability` | object | No | Automated suitability assessment |
| `mortgageSuitability.isEligible` | boolean | No (calculated) | Eligible for standard mortgages |
| `mortgageSuitability.factors` | array | No | List of influencing factors |
| `notes` | string | No | Additional context (max 2000 characters) |
| `createdAt` | datetime | Yes (response only) | When record was created |
| `updatedAt` | datetime | Yes (response only) | When record was last updated |

**Total Properties:** 27 properties (including nested)

### 14.4 Contract Schema

```json
{
  "id": 334,
  "href": "/api/v2/factfinds/679/clients/8496/credit-history/334",
  "client": {
    "id": 8496,
    "clientNumber": "C00001234",
    "name": "John Smith"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123"
  },
  "creditScore": {
    "score": 780,
    "maxScore": 999,
    "rating": "Excellent",
    "provider": "Experian",
    "checkedDate": "2026-01-15"
  },
  "hasAdverseCredit": false,
  "hasCCJ": false,
  "hasBeenRefusedCredit": false,
  "ivaHistory": false,
  "hasDefault": false,
  "hasBankruptcyHistory": false,
  "hasArrears": false,
  "adverseCreditEvents": [],
  "missedPayments": {
    "last12Months": 0,
    "last6Years": 0
  },
  "mortgageSuitability": {
    "isEligible": true,
    "factors": [
      "Good credit score (780)",
      "No adverse credit",
      "No missed payments",
      "Clean payment history for 6+ years"
    ]
  },
  "notes": "Excellent credit history - eligible for best mortgage rates",
  "createdAt": "2026-01-15T10:00:00Z",
  "updatedAt": "2026-01-15T10:00:00Z"
}
```

### 14.5 Complete Examples

#### Example 1: Record Credit Score

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/credit-history/score
Content-Type: application/json
Authorization: Bearer {token}

{
  "score": 780,
  "maxScore": 999,
  "rating": "Excellent",
  "provider": "Experian",
  "checkedDate": "2026-01-15"
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1,
  "score": 780,
  "maxScore": 999,
  "rating": "Excellent",
  "provider": "Experian",
  "checkedDate": "2026-01-15",
  "scorePercentile": 78,
  "ratingDescription": "You have an excellent credit score and should qualify for the best rates and terms",
  "createdAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Add Adverse Credit Event (Default)

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/credit-history/adverse-events
Content-Type: application/json
Authorization: Bearer {token}

{
  "type": "Default",
  "registeredOn": "2020-06-15T00:00:00Z",
  "satisfiedOrClearedOn": "2023-12-20T00:00:00Z",
  "amountRegistered": {
    "amount": 5000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "amountOutstanding": {
    "amount": 0.00,
    "currency": {
      "code": "GBP"
    }
  },
  "isDebtOutstanding": false,
  "lender": "High Street Bank",
  "notes": "Credit card default from 2020, fully settled December 2023"
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1,
  "type": "Default",
  "registeredOn": "2020-06-15T00:00:00Z",
  "satisfiedOrClearedOn": "2023-12-20T00:00:00Z",
  "amountRegistered": {
    "amount": 5000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "amountOutstanding": {
    "amount": 0.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "isDebtOutstanding": false,
  "lender": "High Street Bank",
  "yearsOnFile": 3,
  "yearsRemaining": 3,
  "removalDate": "2026-06-15",
  "impactLevel": "Moderate",
  "impactNotes": "Default older than 3 years and satisfied - minimal impact on mortgage applications",
  "createdAt": "2026-03-03T10:35:00Z"
}
```

#### Example 3: Get Credit Health Indicators

**Request:**
```http
GET /api/v2/factfinds/679/clients/8496/credit-history/health-indicators
Authorization: Bearer {token}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "overallHealth": "Excellent",
  "healthScore": 92,
  "indicators": {
    "creditScore": {
      "status": "Excellent",
      "value": 780,
      "maxValue": 999,
      "percentile": 78,
      "impact": "Positive"
    },
    "paymentHistory": {
      "status": "Clean",
      "missedPaymentsLast12Months": 0,
      "missedPaymentsLast6Years": 0,
      "impact": "Positive"
    },
    "adverseCredit": {
      "status": "None",
      "hasAdverseCredit": false,
      "impact": "Positive"
    },
    "creditAge": {
      "status": "Mature",
      "oldestAccountYears": 15,
      "averageAccountYears": 8,
      "impact": "Positive"
    },
    "creditUtilization": {
      "status": "Low",
      "utilizationPercentage": 15,
      "recommendedMaximum": 30,
      "impact": "Positive"
    },
    "recentApplications": {
      "status": "Stable",
      "last6Months": 0,
      "last12Months": 1,
      "impact": "Neutral"
    }
  },
  "recommendations": [
    "Continue maintaining excellent payment history",
    "Keep credit utilization below 30%",
    "Avoid multiple credit applications in short period"
  ],
  "calculatedOn": "2026-03-03T10:30:00Z"
}
```

### 14.6 Business Rules

1. **Credit Score Ranges:**
   - Experian: 0-999 (Excellent: 961-999, Good: 881-960, Fair: 721-880, Poor: 561-720, Very Poor: 0-560)
   - Equifax: 0-700 (Excellent: 466-700, Good: 420-465, Fair: 380-419, Poor: 280-379, Very Poor: 0-279)
   - TransUnion: 0-710 (Excellent: 628-710, Good: 604-627, Fair: 566-603, Poor: 551-565, Very Poor: 0-550)

2. **Adverse Credit Retention:** All adverse credit events remain on file for 6 years from registration date

3. **Mortgage Suitability Calculation:**
   - Credit score 650+: Generally eligible for standard mortgages
   - No adverse credit in last 3 years: Preferred
   - No missed payments in last 12 months: Required for best rates
   - Outstanding adverse debt: May need settlement before mortgage

4. **CCJ Impact Rules:**
   - CCJs over £500 within 3 years: Typically excludes standard mortgages
   - Satisfied CCJs: Better than unsatisfied but still visible
   - Multiple CCJs: Significantly reduced lender options

5. **Default Rules:**
   - Registration date cannot be in future
   - Satisfied date must be after registration date
   - Outstanding amount cannot exceed registered amount
   - If not outstanding, amount outstanding must be £0

6. **Payment History Tracking:**
   - Last 12 months: Critical for current creditworthiness
   - Last 6 years: Full FCA affordability assessment requirement

7. **Bankruptcy/IVA Rules:**
   - Typically discharged after 12 months (bankruptcy)
   - IVA typically 5-6 years duration
   - Must record discharge/completion dates

### 14.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `provider` | enum | Filter by credit score provider | `provider=Experian` |
| `includeHistory` | boolean | Include historical scores | `includeHistory=true` |
| `adverseOnly` | boolean | Return only adverse events | `adverseOnly=true` |
| `from` | date | Filter events from date | `from=2020-01-01` |
| `to` | date | Filter events to date | `to=2026-12-31` |

### 14.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PUT successful |
| 201 Created | Resource created | POST successful |
| 202 Accepted | Request accepted | Credit report request queued |
| 400 Bad Request | Invalid syntax | Invalid score range |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid client ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 14.9 Regulatory Compliance

**FCA MCOB (Mortgage Conduct of Business):**
- Creditworthiness assessment required before lending
- Credit Reference Agency checks mandatory
- Adverse credit must be considered in affordability
- Pattern of payments indicates future reliability

**MLR 2017 (Money Laundering Regulations):**
- Credit checks support identity verification
- Helps establish financial profile
- Part of customer due diligence

**Consumer Credit Act 1974:**
- Right to view credit file
- Right to correct errors
- Right to explanation of credit decisions

**GDPR:**
- Credit data is personal data
- Lawful basis required for processing
- Data minimization applies
- Retention limited to regulatory requirements

**Integration with Credit Reference Agencies:**
- **Experian:** Via Experian Connect API
- **Equifax:** Via Equifax API Gateway
- **TransUnion:** Via TransUnion Credit Vision API
- Soft credit checks for fact-finding (no impact on score)
- Hard credit checks for applications (temporary score impact)

### 14.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Affordability API](#21-affordability-api) - Uses credit history for assessment
- [Mortgage API](#29-mortgage-api) - Credit history informs mortgage suitability
- [Financial Profile API](#15-financial-profile-api) - Includes credit sophistication

---

## 15. Financial Profile API

### 15.1 Overview

**Purpose:** The Financial Profile API manages the client's financial sophistication assessment, investment experience, and knowledge for FCA Appropriateness Test compliance.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/financial-profile`

**Key Features:**
- Investment experience tracking
- Financial sophistication assessment
- Knowledge and understanding evaluation
- Appropriateness test compliance (MiFID II)
- Income and asset summary
- Investment objective classification

### 15.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/financial-profile` | Get financial profile | N/A | 200 OK - FinancialProfile |
| PUT | `/api/v2/factfinds/{factfindId}/clients/{clientId}/financial-profile` | Update financial profile | FinancialProfileRequest | 200 OK - FinancialProfile |

**Total Operations:** 2 endpoints (singleton resource)

### 15.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `href` | string | Yes (response only) | API link to this resource |
| `client` | object | Yes (response only) | Client reference |
| `factfind` | object | Yes (response only) | FactFind reference |
| `investmentExperience` | object | No | Investment experience details |
| `investmentExperience.hasInvestedBefore` | boolean | No | Has invested previously |
| `investmentExperience.yearsExperience` | integer | No | Years of investment experience |
| `investmentExperience.productsExperienced` | array | No | List of product types |
| `investmentExperience.transactionFrequency` | enum | No | Never, Rarely, Occasionally, Frequently |
| `investmentExperience.lastTransactionDate` | date | No | Date of last investment transaction |
| `financialSophistication` | enum | No | None, Basic, Intermediate, Advanced, Expert |
| `knowledgeAndUnderstanding` | object | No | Knowledge assessment |
| `knowledgeAndUnderstanding.understandsRisk` | boolean | No | Understands investment risk |
| `knowledgeAndUnderstanding.understandsVolatility` | boolean | No | Understands market volatility |
| `knowledgeAndUnderstanding.understandsLiquidty` | boolean | No | Understands liquidity risk |
| `knowledgeAndUnderstanding.hasFinancialEducation` | boolean | No | Has formal financial education |
| `knowledgeAndUnderstanding.hasFinancialQualifications` | boolean | No | Has financial qualifications |
| `incomeAndAssets` | object | No | Income and asset summary |
| `incomeAndAssets.totalAnnualIncome` | money | No | Total annual income |
| `incomeAndAssets.totalNetWorth` | money | No | Total net worth |
| `incomeAndAssets.liquidAssets` | money | No | Cash and liquid investments |
| `incomeAndAssets.incomeStability` | enum | No | Stable, Variable, Uncertain |
| `investmentObjectives` | object | No | Investment objectives |
| `investmentObjectives.primaryObjective` | enum | No | Capital Preservation, Income, Growth, Balanced |
| `investmentObjectives.timeHorizon` | enum | No | ShortTerm, MediumTerm, LongTerm |
| `investmentObjectives.liquidityNeeds` | enum | No | High, Medium, Low |
| `appropriatenessAssessment` | object | No | MiFID II appropriateness |
| `appropriatenessAssessment.assessmentDate` | date | No | When assessment was performed |
| `appropriatenessAssessment.isAppropriate` | boolean | No | Whether client is appropriate |
| `appropriatenessAssessment.productCategories` | array | No | Appropriate product categories |
| `appropriatenessAssessment.restrictions` | array | No | Any restrictions or warnings |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | When record was created |
| `updatedAt` | datetime | Yes (response only) | When record was last updated |

**Total Properties:** 31 properties (including nested)

### 15.4 Contract Schema

```json
{
  "href": "/api/v2/factfinds/679/clients/8496/financial-profile",
  "client": {
    "id": 8496,
    "clientNumber": "C00001234",
    "name": "John Smith"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123"
  },
  "investmentExperience": {
    "hasInvestedBefore": true,
    "yearsExperience": 10,
    "productsExperienced": [
      "Stocks and Shares ISA",
      "Unit Trusts",
      "Investment Bonds",
      "Individual Shares"
    ],
    "transactionFrequency": "Occasionally",
    "lastTransactionDate": "2025-11-20"
  },
  "financialSophistication": "Intermediate",
  "knowledgeAndUnderstanding": {
    "understandsRisk": true,
    "understandsVolatility": true,
    "understandsLiquidity": true,
    "hasFinancialEducation": false,
    "hasFinancialQualifications": false
  },
  "incomeAndAssets": {
    "totalAnnualIncome": {
      "amount": 75000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "totalNetWorth": {
      "amount": 610000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "liquidAssets": {
      "amount": 40000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "incomeStability": "Stable"
  },
  "investmentObjectives": {
    "primaryObjective": "Growth",
    "timeHorizon": "LongTerm",
    "liquidityNeeds": "Medium"
  },
  "appropriatenessAssessment": {
    "assessmentDate": "2026-02-16",
    "isAppropriate": true,
    "productCategories": [
      "Stocks and Shares ISA",
      "Unit Trusts / OEICs",
      "Investment Bonds",
      "Direct Equities (with advice)"
    ],
    "restrictions": []
  },
  "notes": "Client has good understanding of investment principles. Appropriate for standard advised investment products.",
  "createdAt": "2026-02-16T10:00:00Z",
  "updatedAt": "2026-02-16T10:00:00Z"
}
```

### 15.5 Complete Examples

#### Example 1: Update Financial Profile for Experienced Investor

**Request:**
```http
PUT /api/v2/factfinds/679/clients/8496/financial-profile
Content-Type: application/json
Authorization: Bearer {token}

{
  "investmentExperience": {
    "hasInvestedBefore": true,
    "yearsExperience": 10,
    "productsExperienced": [
      "Stocks and Shares ISA",
      "Unit Trusts",
      "Investment Bonds",
      "Individual Shares"
    ],
    "transactionFrequency": "Occasionally",
    "lastTransactionDate": "2025-11-20"
  },
  "financialSophistication": "Intermediate",
  "knowledgeAndUnderstanding": {
    "understandsRisk": true,
    "understandsVolatility": true,
    "understandsLiquidity": true,
    "hasFinancialEducation": false,
    "hasFinancialQualifications": false
  },
  "investmentObjectives": {
    "primaryObjective": "Growth",
    "timeHorizon": "LongTerm",
    "liquidityNeeds": "Medium"
  }
}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "href": "/api/v2/factfinds/679/clients/8496/financial-profile",
  "investmentExperience": {
    "hasInvestedBefore": true,
    "yearsExperience": 10,
    "productsExperienced": [
      "Stocks and Shares ISA",
      "Unit Trusts",
      "Investment Bonds",
      "Individual Shares"
    ],
    "transactionFrequency": "Occasionally"
  },
  "financialSophistication": "Intermediate",
  "appropriatenessAssessment": {
    "assessmentDate": "2026-03-03",
    "isAppropriate": true,
    "productCategories": [
      "Stocks and Shares ISA",
      "Unit Trusts / OEICs",
      "Investment Bonds",
      "Direct Equities (with advice)"
    ],
    "restrictions": []
  },
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Update Financial Profile for Inexperienced Client

**Request:**
```http
PUT /api/v2/factfinds/679/clients/8497/financial-profile
Content-Type: application/json
Authorization: Bearer {token}

{
  "investmentExperience": {
    "hasInvestedBefore": false,
    "yearsExperience": 0,
    "productsExperienced": [],
    "transactionFrequency": "Never"
  },
  "financialSophistication": "Basic",
  "knowledgeAndUnderstanding": {
    "understandsRisk": false,
    "understandsVolatility": false,
    "understandsLiquidity": false,
    "hasFinancialEducation": false,
    "hasFinancialQualifications": false
  },
  "investmentObjectives": {
    "primaryObjective": "Capital Preservation",
    "timeHorizon": "ShortTerm",
    "liquidityNeeds": "High"
  }
}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "href": "/api/v2/factfinds/679/clients/8497/financial-profile",
  "investmentExperience": {
    "hasInvestedBefore": false,
    "yearsExperience": 0,
    "transactionFrequency": "Never"
  },
  "financialSophistication": "Basic",
  "appropriatenessAssessment": {
    "assessmentDate": "2026-03-03",
    "isAppropriate": false,
    "productCategories": [],
    "restrictions": [
      "Client lacks investment experience - execution-only not suitable",
      "Advised service recommended",
      "Basic investment education required before proceeding"
    ]
  },
  "updatedAt": "2026-03-03T10:35:00Z"
}
```

### 15.6 Business Rules

1. **Appropriateness Assessment Required:** Must assess before offering execution-only services (MiFID II)
2. **Experience Validation:** If `hasInvestedBefore=false`, `yearsExperience` must be 0
3. **Sophistication Levels:**
   - None: No investment knowledge
   - Basic: Understands cash savings only
   - Intermediate: Understands collective investments
   - Advanced: Understands direct investments
   - Expert: Professional-level knowledge
4. **Transaction Frequency:** Never, Rarely (yearly), Occasionally (quarterly), Frequently (monthly+)
5. **Time Horizons:**
   - ShortTerm: <3 years
   - MediumTerm: 3-10 years
   - LongTerm: 10+ years
6. **Review Frequency:** Financial profile should be reviewed annually
7. **Negative Appropriateness:** If not appropriate, advised service must be offered

### 15.7 Query Parameters

None (singleton resource)

### 15.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PUT successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid client ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 15.9 Regulatory Compliance

**MiFID II (Markets in Financial Instruments Directive):**
- Appropriateness test required for execution-only services
- Assesses knowledge, experience, and understanding
- If client not appropriate, must warn or refuse service
- Advised service recommended for complex products

**FCA Handbook COBS 10 (Appropriateness):**
- Firm must assess appropriateness before providing service
- Consider nature of service and product complexity
- Warn client if product not appropriate
- Document assessment and outcome

**PROD 3 (Product Governance):**
- Target market identification requires client categorization
- Financial sophistication informs product suitability
- Positive and negative target markets

### 15.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [ATR Assessment API](#32-atr-assessment-api) - Risk profiling
- [Investment API](#24-investment-api) - Investment products
- [Credit History API](#14-credit-history-api) - Financial capability assessment

---

## 16. Marketing Preferences API

### 16.1 Overview

**Purpose:** The Marketing Preferences API manages client marketing consent for various communication channels in compliance with PECR and GDPR requirements.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/marketing-preferences`

**Key Features:**
- Channel-specific consent (email, phone, SMS, post)
- Explicit opt-in tracking
- Consent timestamp recording
- Preference change history
- Third-party marketing consent
- Unsubscribe management

### 16.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/marketing-preferences` | Get marketing preferences | N/A | 200 OK - MarketingPreferences |
| PUT | `/api/v2/factfinds/{factfindId}/clients/{clientId}/marketing-preferences` | Update marketing preferences | MarketingPreferencesRequest | 200 OK - MarketingPreferences |

**Total Operations:** 2 endpoints (singleton resource)

### 16.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `href` | string | Yes (response only) | API link to this resource |
| `client` | object | Yes (response only) | Client reference |
| `factfind` | object | Yes (response only) | FactFind reference |
| `email` | object | No | Email marketing preferences |
| `email.optedIn` | boolean | Yes | Opted in for email marketing |
| `email.consentDate` | datetime | No | When consent was given |
| `email.consentMethod` | enum | No | Online, Phone, Post, InPerson |
| `email.lastUpdated` | datetime | No | When preference was last changed |
| `phone` | object | No | Phone marketing preferences |
| `phone.optedIn` | boolean | Yes | Opted in for phone marketing |
| `phone.consentDate` | datetime | No | When consent was given |
| `phone.consentMethod` | enum | No | Online, Phone, Post, InPerson |
| `phone.lastUpdated` | datetime | No | When preference was last changed |
| `sms` | object | No | SMS marketing preferences |
| `sms.optedIn` | boolean | Yes | Opted in for SMS marketing |
| `sms.consentDate` | datetime | No | When consent was given |
| `sms.consentMethod` | enum | No | Online, Phone, Post, InPerson |
| `sms.lastUpdated` | datetime | No | When preference was last changed |
| `post` | object | No | Postal marketing preferences |
| `post.optedIn` | boolean | Yes | Opted in for postal marketing |
| `post.consentDate` | datetime | No | When consent was given |
| `post.consentMethod` | enum | No | Online, Phone, Post, InPerson |
| `post.lastUpdated` | datetime | No | When preference was last changed |
| `thirdParty` | object | No | Third-party marketing |
| `thirdParty.allowSharing` | boolean | Yes | Allow sharing with partners |
| `thirdParty.consentDate` | datetime | No | When consent was given |
| `thirdParty.lastUpdated` | datetime | No | When preference was last changed |
| `preferredContactTime` | enum | No | Morning, Afternoon, Evening, Anytime |
| `preferredContactDay` | enum | No | Weekday, Weekend, Anytime |
| `doNotContact` | boolean | No | Global do-not-contact flag |
| `notes` | string | No | Additional notes about preferences |
| `createdAt` | datetime | Yes (response only) | When record was created |
| `updatedAt` | datetime | Yes (response only) | When record was last updated |

**Total Properties:** 31 properties (including nested)

### 15.4 Contract Schema

```json
{
  "href": "/api/v2/factfinds/679/clients/8496/marketing-preferences",
  "client": {
    "id": 8496,
    "clientNumber": "C00001234",
    "name": "John Smith"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123"
  },
  "email": {
    "optedIn": true,
    "consentDate": "2020-01-15T10:30:00Z",
    "consentMethod": "Online",
    "lastUpdated": "2020-01-15T10:30:00Z"
  },
  "phone": {
    "optedIn": false,
    "consentDate": null,
    "consentMethod": null,
    "lastUpdated": "2020-01-15T10:30:00Z"
  },
  "sms": {
    "optedIn": false,
    "consentDate": null,
    "consentMethod": null,
    "lastUpdated": "2020-01-15T10:30:00Z"
  },
  "post": {
    "optedIn": true,
    "consentDate": "2020-01-15T10:30:00Z",
    "consentMethod": "InPerson",
    "lastUpdated": "2020-01-15T10:30:00Z"
  },
  "thirdParty": {
    "allowSharing": false,
    "consentDate": null,
    "lastUpdated": "2020-01-15T10:30:00Z"
  },
  "preferredContactTime": "Evening",
  "preferredContactDay": "Weekday",
  "doNotContact": false,
  "notes": "Prefers email communication. Available evenings after 6pm.",
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2020-01-15T10:30:00Z"
}
```

### 16.5 Complete Examples

#### Example 1: Update Marketing Preferences (Opt-In)

**Request:**
```http
PUT /api/v2/factfinds/679/clients/8496/marketing-preferences
Content-Type: application/json
Authorization: Bearer {token}

{
  "email": {
    "optedIn": true,
    "consentMethod": "Online"
  },
  "phone": {
    "optedIn": false
  },
  "sms": {
    "optedIn": false
  },
  "post": {
    "optedIn": true,
    "consentMethod": "InPerson"
  },
  "thirdParty": {
    "allowSharing": false
  },
  "preferredContactTime": "Evening",
  "preferredContactDay": "Weekday"
}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "href": "/api/v2/factfinds/679/clients/8496/marketing-preferences",
  "email": {
    "optedIn": true,
    "consentDate": "2026-03-03T10:30:00Z",
    "consentMethod": "Online",
    "lastUpdated": "2026-03-03T10:30:00Z"
  },
  "phone": {
    "optedIn": false,
    "lastUpdated": "2026-03-03T10:30:00Z"
  },
  "sms": {
    "optedIn": false,
    "lastUpdated": "2026-03-03T10:30:00Z"
  },
  "post": {
    "optedIn": true,
    "consentDate": "2026-03-03T10:30:00Z",
    "consentMethod": "InPerson",
    "lastUpdated": "2026-03-03T10:30:00Z"
  },
  "thirdParty": {
    "allowSharing": false,
    "lastUpdated": "2026-03-03T10:30:00Z"
  },
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Global Opt-Out

**Request:**
```http
PUT /api/v2/factfinds/679/clients/8496/marketing-preferences
Content-Type: application/json
Authorization: Bearer {token}

{
  "email": {
    "optedIn": false
  },
  "phone": {
    "optedIn": false
  },
  "sms": {
    "optedIn": false
  },
  "post": {
    "optedIn": false
  },
  "thirdParty": {
    "allowSharing": false
  },
  "doNotContact": true,
  "notes": "Client requested to be removed from all marketing communications"
}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "href": "/api/v2/factfinds/679/clients/8496/marketing-preferences",
  "email": {
    "optedIn": false,
    "lastUpdated": "2026-03-03T10:35:00Z"
  },
  "phone": {
    "optedIn": false,
    "lastUpdated": "2026-03-03T10:35:00Z"
  },
  "sms": {
    "optedIn": false,
    "lastUpdated": "2026-03-03T10:35:00Z"
  },
  "post": {
    "optedIn": false,
    "lastUpdated": "2026-03-03T10:35:00Z"
  },
  "thirdParty": {
    "allowSharing": false,
    "lastUpdated": "2026-03-03T10:35:00Z"
  },
  "doNotContact": true,
  "notes": "Client requested to be removed from all marketing communications",
  "updatedAt": "2026-03-03T10:35:00Z"
}
```

### 16.6 Business Rules

1. **Explicit Opt-In Required:** No pre-ticked boxes allowed - must be explicit action
2. **Consent Timestamps:** All opt-ins must record `consentDate` and `consentMethod`
3. **Easy Opt-Out:** Must provide simple mechanism to withdraw consent
4. **Channel-Specific:** Consent for one channel doesn't imply consent for others
5. **Third-Party Consent:** Separate consent required for sharing with partners
6. **DoNotContact Override:** If `doNotContact=true`, all channel preferences ignored
7. **Regular Review:** Marketing preferences should be reviewed annually

### 16.7 Query Parameters

None (singleton resource)

### 16.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PUT successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid client ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 16.9 Regulatory Compliance

**PECR (Privacy and Electronic Communications Regulations) 2003:**
- Explicit consent required for electronic marketing
- Cannot use pre-ticked boxes
- Must identify sender clearly
- Must provide easy opt-out mechanism
- Applies to email, SMS, automated calls

**GDPR (General Data Protection Regulation):**
- Consent must be freely given, specific, informed, unambiguous
- Clear affirmative action required
- Easy to withdraw consent
- Consent valid for reasonable period only
- Must keep records of consent

**ICO Guidance:**
- Keep consent records indefinitely
- Review and refresh consent periodically
- Provide granular consent options (channel-specific)
- Honor opt-outs immediately

### 16.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Contact API](#7-contact-api) - Communication channels
- [DPA Agreement API](#17-dpa-agreement-api) - Data processing consent

---

## 17. DPA Agreement API

### 17.1 Overview

**Purpose:** The DPA Agreement API manages Data Processing Agreements and GDPR consent records including version tracking and consent withdrawal.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/dpa-agreements`

**Key Features:**
- Consent capture and tracking
- Version management
- Lawful basis documentation
- Consent withdrawal
- Data retention tracking
- GDPR Article 6 compliance

### 17.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/dpa-agreements` | Create new DPA agreement | DPAAgreementRequest | 201 Created - DPAAgreement |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/dpa-agreements` | List all DPA agreements | N/A | 200 OK - DPAAgreement[] |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/dpa-agreements/current` | Get current active agreement | N/A | 200 OK - DPAAgreement |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/dpa-agreements/{agreementId}` | Withdraw consent | N/A | 204 No Content |

**Total Operations:** 4 endpoints

### 17.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `client` | object | Yes (response only) | Client reference |
| `factfind` | object | Yes (response only) | FactFind reference |
| `agreementType` | enum | Yes | Type (DataProcessing, MarketingConsent, ThirdPartySharing) |
| `version` | string | Yes | Agreement version number |
| `consentDate` | datetime | Yes | When consent was given |
| `consentMethod` | enum | Yes | Online, Phone, Post, InPerson, Email |
| `consentGiven` | boolean | Yes | Whether consent was given |
| `lawfulBasis` | enum | Yes | Consent, Contract, LegalObligation, LegitimateInterest |
| `purposeDescription` | string | Yes | Description of processing purpose |
| `dataCategories` | array | Yes | Categories of data being processed |
| `retentionPeriod` | string | No | How long data will be retained |
| `retentionEndDate` | date | No | Calculated retention end date |
| `ipAddress` | string | No | IP address where consent was captured |
| `userAgent` | string | No | Browser/device used for consent |
| `isActive` | boolean | No (calculated) | Whether agreement is currently active |
| `withdrawnDate` | datetime | No | When consent was withdrawn |
| `withdrawnBy` | string | No | Who withdrew consent |
| `withdrawnReason` | string | No | Reason for withdrawal |
| `documentUrl` | string | No | Link to full agreement document |
| `checksum` | string | No | Document integrity checksum |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | When record was created |
| `updatedAt` | datetime | Yes (response only) | When record was last updated |

**Total Properties:** 23 properties

### 17.4 Contract Schema

```json
{
  "id": 1001,
  "href": "/api/v2/factfinds/679/clients/8496/dpa-agreements/1001",
  "client": {
    "id": 8496,
    "clientNumber": "C00001234",
    "name": "John Smith"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123"
  },
  "agreementType": "DataProcessing",
  "version": "2.1",
  "consentDate": "2026-02-16T10:00:00Z",
  "consentMethod": "Online",
  "consentGiven": true,
  "lawfulBasis": "Consent",
  "purposeDescription": "To collect, store, and process personal and financial information for the purpose of providing financial advice and related services",
  "dataCategories": [
    "Personal Identity Data (name, DOB, address)",
    "Contact Information (email, phone)",
    "Financial Data (income, assets, liabilities)",
    "Sensitive Data (health information for protection needs)"
  ],
  "retentionPeriod": "5 years after relationship ends",
  "retentionEndDate": null,
  "ipAddress": "192.168.1.100",
  "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
  "isActive": true,
  "withdrawnDate": null,
  "withdrawnBy": null,
  "withdrawnReason": null,
  "documentUrl": "https://example.com/dpa/v2.1.pdf",
  "checksum": "sha256:abc123...",
  "notes": null,
  "createdAt": "2026-02-16T10:00:00Z",
  "updatedAt": "2026-02-16T10:00:00Z"
}
```

### 17.5 Complete Examples

#### Example 1: Create DPA Agreement

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/dpa-agreements
Content-Type: application/json
Authorization: Bearer {token}

{
  "agreementType": "DataProcessing",
  "version": "2.1",
  "consentMethod": "Online",
  "consentGiven": true,
  "lawfulBasis": "Consent",
  "purposeDescription": "To collect, store, and process personal and financial information for the purpose of providing financial advice and related services",
  "dataCategories": [
    "Personal Identity Data (name, DOB, address)",
    "Contact Information (email, phone)",
    "Financial Data (income, assets, liabilities)",
    "Sensitive Data (health information for protection needs)"
  ],
  "retentionPeriod": "5 years after relationship ends",
  "documentUrl": "https://example.com/dpa/v2.1.pdf"
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json
Location: /api/v2/factfinds/679/clients/8496/dpa-agreements/1001

{
  "id": 1001,
  "href": "/api/v2/factfinds/679/clients/8496/dpa-agreements/1001",
  "agreementType": "DataProcessing",
  "version": "2.1",
  "consentDate": "2026-03-03T10:30:00Z",
  "consentMethod": "Online",
  "consentGiven": true,
  "lawfulBasis": "Consent",
  "purposeDescription": "To collect, store, and process personal and financial information for the purpose of providing financial advice and related services",
  "dataCategories": [
    "Personal Identity Data (name, DOB, address)",
    "Contact Information (email, phone)",
    "Financial Data (income, assets, liabilities)",
    "Sensitive Data (health information for protection needs)"
  ],
  "retentionPeriod": "5 years after relationship ends",
  "ipAddress": "192.168.1.100",
  "isActive": true,
  "documentUrl": "https://example.com/dpa/v2.1.pdf",
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Withdraw Consent

**Request:**
```http
DELETE /api/v2/factfinds/679/clients/8496/dpa-agreements/1001?reason=Client+request
Authorization: Bearer {token}
```

**Response:**
```http
HTTP/1.1 204 No Content
```

#### Example 3: Get Current Active Agreement

**Request:**
```http
GET /api/v2/factfinds/679/clients/8496/dpa-agreements/current
Authorization: Bearer {token}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 1001,
  "agreementType": "DataProcessing",
  "version": "2.1",
  "consentDate": "2026-03-03T10:30:00Z",
  "consentGiven": true,
  "lawfulBasis": "Consent",
  "isActive": true,
  "withdrawnDate": null,
  "createdAt": "2026-03-03T10:30:00Z"
}
```

### 17.6 Business Rules

1. **Only One Active Agreement:** Only one agreement of each type can be active at a time
2. **Version Tracking:** New version supersedes previous version
3. **Withdrawal:** Consent can be withdrawn at any time - marks agreement as inactive
4. **Retention Period:** Default 5 years after relationship ends (FCA requirement)
5. **Lawful Basis Types:**
   - Consent: Freely given, specific, informed
   - Contract: Necessary for contract performance
   - LegalObligation: Required by law (e.g., AML checks)
   - LegitimateInterest: Legitimate business interest (with balancing test)
6. **Data Categories:** Must specify what data is being processed
7. **Audit Trail:** All consent changes must be logged

### 17.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `agreementType` | enum | Filter by agreement type | `agreementType=DataProcessing` |
| `isActive` | boolean | Filter active agreements | `isActive=true` |
| `version` | string | Filter by version | `version=2.1` |

### 17.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid agreement ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 17.9 Regulatory Compliance

**GDPR Article 6 (Lawful Basis):**
- Must have lawful basis for all processing
- Consent must be freely given, specific, informed, unambiguous
- Contract basis for essential service delivery
- Legal obligation for AML/KYC requirements
- Legitimate interest with documented balancing test

**GDPR Article 7 (Conditions for Consent):**
- Clear affirmative action required
- Withdrawing consent must be as easy as giving it
- Consent request must be clear and distinguishable
- Cannot make service conditional on unnecessary consent

**GDPR Article 13 & 14 (Information Requirements):**
- Identity of data controller
- Purpose of processing
- Legal basis for processing
- Data retention periods
- Right to withdraw consent
- Right to lodge complaint with ICO

**ICO Guidance:**
- Keep detailed records of consent
- Review consent regularly (every 2 years recommended)
- Refresh consent if purpose changes
- Document version control

**FCA Requirements:**
- 5-year minimum retention for financial records
- 7-year retention for mortgage advice
- Indefinite retention for pension transfers

### 17.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Marketing Preferences API](#16-marketing-preferences-api) - Marketing-specific consent
- [Identity Verification API](#13-identity-verification-api) - GDPR compliance notes

---
## 18. Employment API

### 18.1 Overview

**Purpose:** The Employment API manages client employment records including employed, self-employed, retired, and unemployed statuses with earnings, tax information, and Standard Occupational Classification (SOC) codes.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/employment`

**Key Features:**
- Multiple employment record tracking
- Employment status management (Employed, Self-Employed, Retired, Unemployed, Homemaker)
- Occupation classification with SOC codes
- Earnings and tax tracking (PAYE, CIS, Self Assessment)
- Employment period management
- Employer contact details

### 18.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/employment` | List all employment records | N/A | 200 OK - Employment[] |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/employment` | Create new employment record | EmploymentRequest | 201 Created - Employment |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/employment/{employmentId}` | Get employment details | N/A | 200 OK - Employment |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}/employment/{employmentId}` | Update employment | EmploymentPatch | 200 OK - Employment |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/employment/{employmentId}` | Delete employment record | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 18.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `client` | object | Yes (response only) | Client reference |
| `factfind` | object | Yes (response only) | FactFind reference |
| `employmentStatus` | enum | Yes | Current, Previous, Future |
| `employmentType` | enum | Yes | Employed, SelfEmployed, Retired, Unemployed, Homemaker, Student |
| `employerName` | string | Conditional | Employer name (required if Employed) |
| `jobTitle` | string | No | Job title or occupation |
| `occupation` | object | No | Occupation details with SOC code |
| `occupation.title` | string | No | Occupation title |
| `occupation.socCode` | string | No | Standard Occupational Classification code |
| `occupation.socVersion` | string | No | SOC version (SOC2020) |
| `occupation.description` | string | No | Occupation description |
| `employmentPeriod` | object | No | Employment dates |
| `employmentPeriod.startDate` | date | Yes | Start date |
| `employmentPeriod.endDate` | date | No | End date (null if current) |
| `earnings` | object | No | Earnings details |
| `earnings.grossAnnualSalary` | money | No | Annual gross salary |
| `earnings.netMonthlySalary` | money | No | Monthly net salary |
| `earnings.bonusAmount` | money | No | Annual bonus amount |
| `earnings.overtimeAmount` | money | No | Overtime earnings |
| `earnings.commissionAmount` | money | No | Commission earnings |
| `taxInformation` | object | No | Tax details |
| `taxInformation.paymentMethod` | enum | No | PAYE, SelfAssessment, CIS |
| `taxInformation.taxCode` | string | No | Current tax code |
| `taxInformation.niNumber` | string | No | National Insurance number |
| `selfEmploymentDetails` | object | No | Self-employment specific |
| `selfEmploymentDetails.businessName` | string | No | Trading name |
| `selfEmploymentDetails.businessType` | enum | No | SoleTrader, Partnership, LimitedCompany |
| `selfEmploymentDetails.companyNumber` | string | No | Companies House registration number |
| `selfEmploymentDetails.yearlyTurnover` | money | No | Annual turnover |
| `selfEmploymentDetails.netProfit` | money | No | Net profit |
| `employerContact` | object | No | Employer contact details |
| `employerContact.phone` | string | No | Contact phone number |
| `employerContact.email` | string | No | Contact email |
| `employerContact.address` | object | No | Employer address |
| `isPrimary` | boolean | No | Whether this is primary employment |
| `hoursPerWeek` | decimal | No | Hours worked per week |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | When record was created |
| `updatedAt` | datetime | Yes (response only) | When record was last updated |

**Total Properties:** 40 properties (including nested)

### 18.4 Contract Schema

```json
{
  "id": 8695,
  "href": "/api/v2/factfinds/679/clients/8496/employment/8695",
  "client": {
    "id": 8496,
    "clientNumber": "C00001234",
    "name": "John Smith"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123"
  },
  "employmentStatus": "Current",
  "employmentType": "Employed",
  "employerName": "Tech Corp Ltd",
  "jobTitle": "Senior Software Engineer",
  "occupation": {
    "title": "Programmers and Software Development Professionals",
    "socCode": "2136",
    "socVersion": "SOC2020",
    "description": "Software development professionals design, develop, test, and maintain software systems"
  },
  "employmentPeriod": {
    "startDate": "2015-03-01",
    "endDate": null
  },
  "earnings": {
    "grossAnnualSalary": {
      "amount": 75000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "netMonthlySalary": {
      "amount": 4583.33,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "bonusAmount": {
      "amount": 10000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "overtimeAmount": null,
    "commissionAmount": null
  },
  "taxInformation": {
    "paymentMethod": "PAYE",
    "taxCode": "1257L",
    "niNumber": "AB123456C"
  },
  "selfEmploymentDetails": null,
  "employerContact": {
    "phone": "+44 20 7946 0958",
    "email": "hr@techcorp.com",
    "address": {
      "line1": "Tech House",
      "line2": "123 Innovation Street",
      "city": "London",
      "postcode": "EC2A 4NE",
      "country": "GB"
    }
  },
  "isPrimary": true,
  "hoursPerWeek": 37.5,
  "notes": "Annual bonus typically paid in March",
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z"
}
```

### 18.5 Complete Examples

#### Example 1: Add Employed Record

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/employment
Content-Type: application/json
Authorization: Bearer {token}

{
  "employmentStatus": "Current",
  "employmentType": "Employed",
  "employerName": "Tech Corp Ltd",
  "jobTitle": "Senior Software Engineer",
  "occupation": {
    "title": "Programmers and Software Development Professionals",
    "socCode": "2136",
    "socVersion": "SOC2020"
  },
  "employmentPeriod": {
    "startDate": "2015-03-01"
  },
  "earnings": {
    "grossAnnualSalary": {
      "amount": 75000.00,
      "currency": {
        "code": "GBP"
      }
    },
    "bonusAmount": {
      "amount": 10000.00,
      "currency": {
        "code": "GBP"
      }
    }
  },
  "taxInformation": {
    "paymentMethod": "PAYE",
    "taxCode": "1257L",
    "niNumber": "AB123456C"
  },
  "isPrimary": true,
  "hoursPerWeek": 37.5
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 8695,
  "href": "/api/v2/factfinds/679/clients/8496/employment/8695",
  "employmentStatus": "Current",
  "employmentType": "Employed",
  "employerName": "Tech Corp Ltd",
  "jobTitle": "Senior Software Engineer",
  "employmentPeriod": {
    "startDate": "2015-03-01",
    "endDate": null,
    "yearsEmployed": 11
  },
  "earnings": {
    "grossAnnualSalary": {
      "amount": 75000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "bonusAmount": {
      "amount": 10000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "taxInformation": {
    "paymentMethod": "PAYE",
    "taxCode": "1257L"
  },
  "isPrimary": true,
  "hoursPerWeek": 37.5,
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Add Self-Employed Record

**Request:**
```http
POST /api/v2/factfinds/679/clients/8497/employment
Content-Type: application/json
Authorization: Bearer {token}

{
  "employmentStatus": "Current",
  "employmentType": "SelfEmployed",
  "jobTitle": "Marketing Consultant",
  "occupation": {
    "title": "Marketing and Sales Directors",
    "socCode": "1132",
    "socVersion": "SOC2020"
  },
  "employmentPeriod": {
    "startDate": "2018-06-01"
  },
  "selfEmploymentDetails": {
    "businessName": "Smith Marketing Solutions",
    "businessType": "SoleTrader",
    "yearlyTurnover": {
      "amount": 85000.00,
      "currency": {
        "code": "GBP"
      }
    },
    "netProfit": {
      "amount": 52000.00,
      "currency": {
        "code": "GBP"
      }
    }
  },
  "taxInformation": {
    "paymentMethod": "SelfAssessment",
    "niNumber": "CD987654B"
  },
  "isPrimary": true,
  "hoursPerWeek": 40
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 8696,
  "href": "/api/v2/factfinds/679/clients/8497/employment/8696",
  "employmentStatus": "Current",
  "employmentType": "SelfEmployed",
  "jobTitle": "Marketing Consultant",
  "selfEmploymentDetails": {
    "businessName": "Smith Marketing Solutions",
    "businessType": "SoleTrader",
    "yearlyTurnover": {
      "amount": 85000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "netProfit": {
      "amount": 52000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "taxInformation": {
    "paymentMethod": "SelfAssessment"
  },
  "isPrimary": true,
  "createdAt": "2026-03-03T10:35:00Z",
  "updatedAt": "2026-03-03T10:35:00Z"
}
```

### 18.6 Business Rules

1. **Employment Status:** Current, Previous, or Future
2. **Only One Primary:** Only one employment can be marked as primary
3. **Employer Required:** If `employmentType=Employed`, `employerName` is required
4. **Self-Employment Details:** If `employmentType=SelfEmployed`, `selfEmploymentDetails` required
5. **Date Validation:** `endDate` must be after `startDate` if provided
6. **Tax Payment Methods:**
   - PAYE: Pay As You Earn (employed)
   - SelfAssessment: Self-employed tax returns
   - CIS: Construction Industry Scheme
7. **SOC Codes:** Use SOC2020 standard (9-digit codes grouped into 4 levels)

### 18.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `employmentStatus` | enum | Filter by status | `employmentStatus=Current` |
| `employmentType` | enum | Filter by type | `employmentType=Employed` |
| `isPrimary` | boolean | Filter primary employment | `isPrimary=true` |

### 18.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid employment ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 18.9 Regulatory Compliance

**FCA MCOB (Mortgage Affordability):**
- Employment status affects affordability assessment
- Self-employed require 2-3 years accounts
- Contract/zero-hours employment may need guarantees

**SOC 2020 Standard:**
- Office for National Statistics occupational classification
- 9 major groups, 4 hierarchical levels
- Used for statistical analysis and risk assessment

### 18.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Income API](#19-income-api) - Employment income records
- [Affordability API](#21-affordability-api) - Income stability assessment

---

## 19. Income API

### 19.1 Overview

**Purpose:** The Income API manages all income sources for clients including salary, dividends, rental income, pension income, and state benefits with frequency, tax treatment, and gross/net calculations.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/income`

**Key Features:**
- Multiple income source tracking
- Income type classification (Employment, Dividend, Rental, Pension, Benefits)
- Frequency management (Monthly, Annual, Weekly)
- Tax treatment (taxable/non-taxable)
- Gross/net amount calculations
- Income period tracking (start/end dates)
- Link to employment or assets generating income

### 19.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/income` | List all income sources | N/A | 200 OK - Income[] |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/income` | Create new income source | IncomeRequest | 201 Created - Income |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/income/{incomeId}` | Get income details | N/A | 200 OK - Income |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}/income/{incomeId}` | Update income | IncomePatch | 200 OK - Income |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/income/{incomeId}` | Delete income source | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 19.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `client` | object | Yes (response only) | Client reference |
| `factfind` | object | Yes (response only) | FactFind reference |
| `incomeType` | enum | Yes | Employment, Dividend, Rental, Pension, Benefits, Other |
| `description` | string | Yes | Description of income source |
| `grossAmount` | money | Yes | Gross amount before tax |
| `netAmount` | money | No | Net amount after tax |
| `taxDeducted` | money | No | Tax deducted amount |
| `nationalInsuranceDeducted` | money | No | NI deducted amount |
| `frequency` | object | Yes | Payment frequency |
| `frequency.code` | string | Yes | Frequency code (A, M, W, etc.) |
| `frequency.display` | string | Yes | Display text (Annually, Monthly, Weekly) |
| `frequency.periodsPerYear` | integer | Yes | Number of periods per year |
| `incomePeriod` | object | No | Income period dates |
| `incomePeriod.startDate` | date | Yes | Income start date |
| `incomePeriod.endDate` | date | No | Income end date (null if ongoing) |
| `isTaxable` | boolean | Yes | Whether income is taxable |
| `isGuaranteed` | boolean | No | Whether income is guaranteed |
| `isOngoing` | boolean | No | Whether income is ongoing |
| `isPrimary` | boolean | No | Whether this is primary income |
| `employment` | object | No | Link to employment record (if employment income) |
| `asset` | object | No | Link to asset generating income (rental, dividends) |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | When record was created |
| `updatedAt` | datetime | Yes (response only) | When record was last updated |

**Total Properties:** 24 properties (including nested)

### 19.4 Contract Schema

```json
{
  "id": 5156,
  "href": "/api/v2/factfinds/679/clients/8496/income/5156",
  "client": {
    "id": 8496,
    "clientNumber": "C00001234",
    "name": "John Smith",
    "type": "Person"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF001234",
    "status": "InProgress"
  },
  "incomeType": "Employment",
  "description": "Salary from Tech Corp Ltd",
  "grossAmount": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "netAmount": {
    "amount": 55000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "taxDeducted": {
    "amount": 15000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "nationalInsuranceDeducted": {
    "amount": 5000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "frequency": {
    "code": "A",
    "display": "Annually",
    "periodsPerYear": 1
  },
  "incomePeriod": {
    "startDate": "2020-01-15",
    "endDate": null
  },
  "isTaxable": true,
  "isGuaranteed": true,
  "isOngoing": true,
  "isPrimary": true,
  "employment": {
    "id": 8695,
    "employerName": "Tech Corp Ltd",
    "status": "Current"
  },
  "asset": null,
  "notes": "Annual bonus typically £10k",
  "createdAt": "2026-02-16T14:30:00Z",
  "updatedAt": "2026-02-16T15:45:00Z"
}
```

### 19.5 Complete Examples

#### Example 1: Add Employment Income

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/income
Content-Type: application/json
Authorization: Bearer {token}

{
  "incomeType": "Employment",
  "description": "Salary from Tech Corp Ltd",
  "grossAmount": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "netAmount": {
    "amount": 55000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "taxDeducted": {
    "amount": 15000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "nationalInsuranceDeducted": {
    "amount": 5000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "frequency": {
    "code": "A",
    "display": "Annually",
    "periodsPerYear": 1
  },
  "incomePeriod": {
    "startDate": "2020-01-15"
  },
  "isTaxable": true,
  "isGuaranteed": true,
  "isOngoing": true,
  "isPrimary": true,
  "employment": {
    "id": 8695
  }
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 5156,
  "href": "/api/v2/factfinds/679/clients/8496/income/5156",
  "incomeType": "Employment",
  "description": "Salary from Tech Corp Ltd",
  "grossAmount": {
    "amount": 75000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "netAmount": {
    "amount": 55000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "frequency": {
    "code": "A",
    "display": "Annually",
    "periodsPerYear": 1
  },
  "isTaxable": true,
  "isPrimary": true,
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Add Rental Income

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/income
Content-Type: application/json
Authorization: Bearer {token}

{
  "incomeType": "Rental",
  "description": "Rental income from BTL property",
  "grossAmount": {
    "amount": 18000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "netAmount": {
    "amount": 14400.00,
    "currency": {
      "code": "GBP"
    }
  },
  "frequency": {
    "code": "A",
    "display": "Annually",
    "periodsPerYear": 1
  },
  "isTaxable": true,
  "isGuaranteed": false,
  "isOngoing": true,
  "asset": {
    "id": 5001,
    "assetType": "Property",
    "description": "Rental Property - 45 High Street"
  }
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 5157,
  "href": "/api/v2/factfinds/679/clients/8496/income/5157",
  "incomeType": "Rental",
  "description": "Rental income from BTL property",
  "grossAmount": {
    "amount": 18000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "netAmount": {
    "amount": 14400.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "frequency": {
    "code": "A",
    "display": "Annually",
    "periodsPerYear": 1
  },
  "isTaxable": true,
  "isGuaranteed": false,
  "isOngoing": true,
  "asset": {
    "id": 5001,
    "href": "/api/v2/factfinds/679/assets/5001",
    "assetType": "Property",
    "description": "Rental Property - 45 High Street, Manchester"
  },
  "createdAt": "2026-03-03T10:35:00Z",
  "updatedAt": "2026-03-03T10:35:00Z"
}
```

### 19.6 Business Rules

1. **Gross Amount Required:** All income must have `grossAmount`
2. **Net Calculation:** If tax deducted provided, system can calculate net amount
3. **Frequency Codes:**
   - A: Annually (1 per year)
   - M: Monthly (12 per year)
   - W: Weekly (52 per year)
   - F: Fortnightly (26 per year)
   - Q: Quarterly (4 per year)
4. **Tax-Free Income Examples:**
   - ISA interest
   - Child benefit (under threshold)
   - Premium bond prizes
   - Some state benefits
5. **Only One Primary:** Only one income can be marked as primary
6. **Income Types and Tax Treatment:**
   - Employment: Usually PAYE taxed
   - Dividend: Dividend tax rates apply
   - Rental: Self-assessment, allowable expenses
   - Pension: Usually taxed at source
   - Benefits: Some taxable, some not
7. **Asset Link:** Rental and dividend income should link to generating asset

### 19.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `incomeType` | enum | Filter by income type | `incomeType=Employment` |
| `isTaxable` | boolean | Filter taxable income | `isTaxable=true` |
| `isOngoing` | boolean | Filter ongoing income | `isOngoing=true` |
| `isPrimary` | boolean | Filter primary income | `isPrimary=true` |

### 19.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid income ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 19.9 Regulatory Compliance

**FCA MCOB (Mortgage Affordability):**
- All income sources must be verified
- Self-employed income requires 2-3 years evidence
- Bonus/commission may be averaged or excluded
- Rental income treated at 125% coverage typically

**HMRC Tax Treatment:**
- Employment income: PAYE taxed
- Self-employment: Self-assessment
- Rental: Property allowance £1,000 or expenses
- Dividends: £500 allowance (2024/25)

### 19.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Employment API](#18-employment-api) - Employment income link
- [Asset API](#22-asset-api) - Asset income link (rental, dividends)
- [Affordability API](#21-affordability-api) - Income used for affordability

---

## 20. Expenditure API

### 20.1 Overview

**Purpose:** The Expenditure API manages client outgoing payments and expenses categorized by type for budget planning and affordability assessments with essential/non-essential classification.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/expenditure`

**Key Features:**
- Comprehensive expenditure tracking
- ONS category classification
- Essential vs non-essential designation
- Frequency management
- Debt consolidation flagging
- Liability linking (for debt payments)
- Period tracking

### 20.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/expenditure` | List all expenditure items | N/A | 200 OK - Expenditure[] |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/expenditure` | Create new expenditure | ExpenditureRequest | 201 Created - Expenditure |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/expenditure/{expenditureId}` | Get expenditure details | N/A | 200 OK - Expenditure |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}/expenditure/{expenditureId}` | Update expenditure | ExpenditurePatch | 200 OK - Expenditure |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/expenditure/{expenditureId}` | Delete expenditure | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 20.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `client` | object | Yes (response only) | Client reference |
| `factfind` | object | Yes (response only) | FactFind reference |
| `category` | enum | Yes | Expenditure category |
| `description` | string | Yes | Description of expenditure |
| `amount` | money | Yes | Amount spent |
| `frequency` | object | Yes | Payment frequency |
| `frequency.code` | string | Yes | Frequency code |
| `frequency.display` | string | Yes | Display text |
| `frequency.periodsPerYear` | integer | Yes | Periods per year |
| `expenditurePeriod` | object | No | Expenditure period |
| `expenditurePeriod.startDate` | date | Yes | Start date |
| `expenditurePeriod.endDate` | date | No | End date (null if ongoing) |
| `isEssential` | boolean | No (calculated) | Whether essential expenditure |
| `isDiscretionary` | boolean | No (calculated) | Whether discretionary |
| `isConsolidated` | boolean | No | Part of debt consolidation |
| `isLiabilityToBeRepaid` | boolean | No | Repaying specific debt |
| `liability` | object | No | Link to liability being repaid |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | When record was created |
| `updatedAt` | datetime | Yes (response only) | When record was last updated |

**Total Properties:** 20 properties (including nested)

**Expenditure Categories:**
- **Essential:** Mortgage, Rent, Council Tax, Gas, Electricity, Water, Food, Transport
- **Quality of Living:** Clothing, Furniture, TV/Internet, Pension Contributions, Childcare
- **Non-Essential:** Sports, Holidays, Entertainment, Investments, Credit Card payments

### 20.4 Contract Schema

```json
{
  "id": 1001,
  "href": "/api/v2/factfinds/679/clients/8496/expenditure/1001",
  "client": {
    "id": 8496,
    "clientNumber": "C00001234",
    "name": "John Smith"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123"
  },
  "category": "Mortgage",
  "description": "Monthly mortgage payment",
  "amount": {
    "amount": 1500.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "frequency": {
    "code": "M",
    "display": "Monthly",
    "periodsPerYear": 12
  },
  "expenditurePeriod": {
    "startDate": "2025-01-01",
    "endDate": null
  },
  "isEssential": true,
  "isDiscretionary": false,
  "isConsolidated": false,
  "isLiabilityToBeRepaid": true,
  "liability": {
    "id": 5001,
    "href": "/api/v2/factfinds/679/liabilities/5001",
    "description": "Residential Mortgage - Main Home"
  },
  "notes": "Fixed rate until 2027",
  "createdAt": "2026-01-15T10:00:00Z",
  "updatedAt": "2026-02-18T14:30:00Z"
}
```

### 20.5 Complete Examples

#### Example 1: Add Mortgage Expenditure

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/expenditure
Content-Type: application/json
Authorization: Bearer {token}

{
  "category": "Mortgage",
  "description": "Monthly mortgage payment",
  "amount": {
    "amount": 1500.00,
    "currency": {
      "code": "GBP"
    }
  },
  "frequency": {
    "code": "M",
    "display": "Monthly",
    "periodsPerYear": 12
  },
  "expenditurePeriod": {
    "startDate": "2025-01-01"
  },
  "isLiabilityToBeRepaid": true,
  "liability": {
    "id": 5001
  },
  "notes": "Fixed rate until 2027"
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1001,
  "href": "/api/v2/factfinds/679/clients/8496/expenditure/1001",
  "category": "Mortgage",
  "description": "Monthly mortgage payment",
  "amount": {
    "amount": 1500.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "frequency": {
    "code": "M",
    "display": "Monthly",
    "periodsPerYear": 12
  },
  "annualAmount": {
    "amount": 18000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "isEssential": true,
  "isDiscretionary": false,
  "isLiabilityToBeRepaid": true,
  "liability": {
    "id": 5001,
    "description": "Residential Mortgage - Main Home"
  },
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Add Discretionary Expenditure

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/expenditure
Content-Type: application/json
Authorization: Bearer {token}

{
  "category": "Entertainment",
  "description": "Dining out and cinema",
  "amount": {
    "amount": 300.00,
    "currency": {
      "code": "GBP"
    }
  },
  "frequency": {
    "code": "M",
    "display": "Monthly",
    "periodsPerYear": 12
  },
  "expenditurePeriod": {
    "startDate": "2026-01-01"
  }
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1002,
  "href": "/api/v2/factfinds/679/clients/8496/expenditure/1002",
  "category": "Entertainment",
  "description": "Dining out and cinema",
  "amount": {
    "amount": 300.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "frequency": {
    "code": "M",
    "display": "Monthly",
    "periodsPerYear": 12
  },
  "annualAmount": {
    "amount": 3600.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "isEssential": false,
  "isDiscretionary": true,
  "createdAt": "2026-03-03T10:35:00Z",
  "updatedAt": "2026-03-03T10:35:00Z"
}
```

### 20.6 Business Rules

1. **Amount Required:** All expenditure must have positive amount
2. **Essential Classification:** System automatically classifies based on category
3. **Annual Calculation:** System calculates annual amount from frequency
4. **Debt Payments:** Mortgage and loan payments should link to liability
5. **Consolidation Flag:** Mark debts being consolidated for refinancing scenarios
6. **End Date Validation:** If provided, must be after start date
7. **Affordability Impact:**
   - Essential: Always included in affordability
   - Quality of Living: Typically included
   - Non-Essential: May be excluded in stress tests

### 20.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `category` | enum | Filter by category | `category=Mortgage` |
| `isEssential` | boolean | Filter essential expenditure | `isEssential=true` |
| `isDiscretionary` | boolean | Filter discretionary | `isDiscretionary=true` |
| `isConsolidated` | boolean | Filter consolidated debts | `isConsolidated=true` |

### 20.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid expenditure ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 20.9 Regulatory Compliance

**FCA MCOB 11 (Responsible Lending):**
- Thorough expenditure assessment required
- Must verify actual expenditure (bank statements)
- Cannot exclude essential expenditure in affordability
- Stress testing must include essential costs

**Consumer Duty:**
- Fair treatment requires realistic expenditure assessment
- Cannot pressure clients to understate expenditure
- Must consider actual living costs

### 20.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Affordability API](#21-affordability-api) - Uses expenditure for assessment
- [Income API](#19-income-api) - Income vs expenditure analysis

---

## 21. Affordability API

### 21.1 Overview

**Purpose:** The Affordability API performs comprehensive affordability calculations for mortgage lending including income multiples, stress testing, and disposable income analysis in compliance with FCA MCOB 11.

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/affordability`

**Key Features:**
- Income multiple calculations (3x, 4x, 4.5x income)
- FCA stress testing (3% interest rate increase)
- Committed expenditure analysis
- Disposable income calculations
- Loan-to-income (LTI) ratios
- Debt-to-income (DTI) ratios
- Affordability history tracking

### 21.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/affordability` | Get affordability assessment | N/A | 200 OK - Affordability |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/affordability/calculate` | Calculate affordability | AffordabilityRequest | 200 OK - AffordabilityResult |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/affordability/history` | Get calculation history | N/A | 200 OK - AffordabilityHistory[] |

**Total Operations:** 3 endpoints

### 21.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `href` | string | Yes (response only) | API link to this resource |
| `client` | object | Yes (response only) | Client reference |
| `factfind` | object | Yes (response only) | FactFind reference |
| `totalAnnualIncome` | money | No | Total annual income |
| `totalMonthlyIncome` | money | No | Total monthly income |
| `totalCommittedExpenditure` | money | No | Essential expenditure |
| `totalDiscretionaryExpenditure` | money | No | Non-essential expenditure |
| `netDisposableIncome` | money | No | Income after all expenditure |
| `maxLoanAmount` | money | No | Maximum affordable loan |
| `incomeMultiple` | decimal | No | Loan as multiple of income |
| `loanToIncomeRatio` | decimal | No | LTI ratio |
| `debtToIncomeRatio` | decimal | No | DTI ratio percentage |
| `stressTest` | object | No | Stress test results |
| `stressTest.proposedRate` | decimal | No | Proposed mortgage rate |
| `stressTest.stressedRate` | decimal | No | Rate after 3% increase |
| `stressTest.proposedPayment` | money | No | Payment at proposed rate |
| `stressTest.stressedPayment` | money | No | Payment at stressed rate |
| `stressTest.remainingIncome` | money | No | Income after stressed payment |
| `stressTest.passes` | boolean | No | Whether passes stress test |
| `affordabilityRating` | enum | No | Strong, Good, Fair, Marginal, Insufficient |
| `recommendations` | array | No | List of recommendations |
| `warnings` | array | No | List of warnings |
| `calculatedOn` | datetime | No | When calculated |
| `calculatedBy` | string | No | Who calculated |
| `notes` | string | No | Additional notes |

**Total Properties:** 25 properties (including nested)

### 21.4 Contract Schema

```json
{
  "href": "/api/v2/factfinds/679/clients/8496/affordability",
  "client": {
    "id": 8496,
    "clientNumber": "C00001234",
    "name": "John Smith"
  },
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123"
  },
  "totalAnnualIncome": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "totalMonthlyIncome": {
    "amount": 6250.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "totalCommittedExpenditure": {
    "amount": 2500.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "totalDiscretionaryExpenditure": {
    "amount": 800.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "netDisposableIncome": {
    "amount": 2950.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "maxLoanAmount": {
    "amount": 337500.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "incomeMultiple": 4.5,
  "loanToIncomeRatio": 4.5,
  "debtToIncomeRatio": 40,
  "stressTest": {
    "proposedRate": 5.5,
    "stressedRate": 8.5,
    "proposedPayment": {
      "amount": 1850.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "stressedPayment": {
      "amount": 2350.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "remainingIncome": {
      "amount": 1400.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "passes": true
  },
  "affordabilityRating": "Good",
  "recommendations": [
    "Maximum borrowing 4.5x income = £337,500",
    "Strong affordability with stress test pass",
    "Consider fixed rate for payment certainty"
  ],
  "warnings": [],
  "calculatedOn": "2026-03-03T10:30:00Z",
  "calculatedBy": "jane.adviser@acme.com",
  "notes": "Client has good income stability and manageable expenditure"
}
```

### 21.5 Complete Examples

#### Example 1: Calculate Affordability

**Request:**
```http
POST /api/v2/factfinds/679/clients/8496/affordability/calculate
Content-Type: application/json
Authorization: Bearer {token}

{
  "proposedLoanAmount": {
    "amount": 300000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "proposedMortgageRate": 5.5,
  "loanTermYears": 25,
  "repaymentType": "Repayment"
}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "affordabilityResult": "Affordable",
  "proposedLoan": {
    "amount": 300000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "proposedRate": 5.5,
  "monthlyPayment": {
    "amount": 1850.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "incomeMultiple": 4.0,
  "loanToIncomeRatio": 4.0,
  "stressTest": {
    "stressedRate": 8.5,
    "stressedPayment": {
      "amount": 2350.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "remainingIncome": {
      "amount": 1400.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "passes": true
  },
  "debtToIncomeRatio": 37,
  "affordabilityRating": "Good",
  "recommendations": [
    "Loan is affordable with good margin",
    "Passes stress test with £1,400/month remaining",
    "LTI ratio 4.0x is within normal lending criteria"
  ],
  "warnings": [],
  "calculatedOn": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Failed Stress Test

**Request:**
```http
POST /api/v2/factfinds/679/clients/8497/affordability/calculate
Content-Type: application/json
Authorization: Bearer {token}

{
  "proposedLoanAmount": {
    "amount": 400000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "proposedMortgageRate": 5.5,
  "loanTermYears": 25,
  "repaymentType": "Repayment"
}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "affordabilityResult": "NotAffordable",
  "proposedLoan": {
    "amount": 400000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "proposedRate": 5.5,
  "monthlyPayment": {
    "amount": 2467.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "incomeMultiple": 5.33,
  "loanToIncomeRatio": 5.33,
  "stressTest": {
    "stressedRate": 8.5,
    "stressedPayment": {
      "amount": 3133.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "remainingIncome": {
      "amount": -383.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "passes": false
  },
  "debtToIncomeRatio": 62,
  "affordabilityRating": "Insufficient",
  "recommendations": [],
  "warnings": [
    "FAILS stress test - negative remaining income of £383/month",
    "LTI ratio 5.33x exceeds typical lending criteria",
    "DTI ratio 62% is very high - should be under 45%",
    "Recommend reducing loan amount to £337,500 (4.5x income)"
  ],
  "calculatedOn": "2026-03-03T10:35:00Z"
}
```

### 21.6 Business Rules

1. **FCA Stress Test:** Must apply 3% interest rate increase (or 1% above reversion rate if higher)
2. **Income Multiples:**
   - Standard: 3-4x income
   - Maximum: Usually 4.5x income
   - Some lenders: Up to 5.5x for high earners
3. **Loan-to-Income (LTI) Limits:**
   - Bank of England: Max 15% of new mortgages above 4.5x LTI
   - Most lenders: 4.5x cap
4. **Debt-to-Income (DTI) Ratios:**
   - Excellent: <36%
   - Good: 36-42%
   - Fair: 43-49%
   - Poor: 50%+
5. **Committed Expenditure:** Essential expenditure must be included
6. **Affordability Ratings:**
   - Strong: Passes stress test with 20%+ margin
   - Good: Passes stress test with 10-20% margin
   - Fair: Passes stress test with <10% margin
   - Marginal: Borderline pass
   - Insufficient: Fails stress test

### 21.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `fromDate` | date | Filter history from date | `fromDate=2026-01-01` |
| `toDate` | date | Filter history to date | `toDate=2026-12-31` |

### 21.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, POST successful |
| 400 Bad Request | Invalid syntax | Invalid calculation parameters |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid client ID |
| 422 Unprocessable Entity | Validation failed | Insufficient income data |

### 21.9 Regulatory Compliance

**FCA MCOB 11 (Responsible Lending):**
- Comprehensive affordability assessment required
- Must consider income, expenditure, commitments
- Stress testing mandatory at 3% rate increase
- Cannot rely solely on income multiples
- Must assess sustainability of mortgage payments

**Prudential Regulation Authority (PRA):**
- Bank of England LTI flow limit (15% above 4.5x)
- Stress testing at reversion rate
- Interest coverage ratio requirements

**Consumer Duty:**
- Fair treatment in affordability assessment
- Realistic expenditure consideration
- Clear explanation of affordability results
- Must not lend to clients who cannot afford

### 21.10 Related APIs

- [Client Management API](#5-client-management-api) - Parent resource
- [Income API](#19-income-api) - Income sources
- [Expenditure API](#20-expenditure-api) - Expenditure items
- [Mortgage API](#29-mortgage-api) - Mortgage applications

---
## 22. Asset API

### 22.1 Overview

**Purpose:** The Asset API manages client assets including property, businesses, cash, investments, and other valuables with ownership tracking, valuation management, and tax planning information.

**Base Path:** `/api/v2/factfinds/{factfindId}/assets`

**Key Features:**
- Multi-type asset management (Property, Business, Cash, Investment, Other)
- Current valuation tracking
- Ownership and joint ownership
- Tax relief qualification (Business Relief, IHT exemptions)
- Property sub-resource with detailed property information
- Rental income linking
- Purchase history and capital growth tracking

### 22.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/assets` | List all assets | N/A | 200 OK - Asset[] |
| POST | `/api/v2/factfinds/{factfindId}/assets` | Create new asset | AssetRequest | 201 Created - Asset |
| GET | `/api/v2/factfinds/{factfindId}/assets/{assetId}` | Get asset details | N/A | 200 OK - Asset |
| PATCH | `/api/v2/factfinds/{factfindId}/assets/{assetId}` | Update asset | AssetPatch | 200 OK - Asset |
| DELETE | `/api/v2/factfinds/{factfindId}/assets/{assetId}` | Delete asset | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 22.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `factfind` | object | Yes (response only) | FactFind reference |
| `assetType` | enum | Yes | PROPERTY, BUSINESS, CASH, INVESTMENT, OTHER |
| `description` | string | Yes | Asset description |
| `currentValue` | money | Yes | Current market value |
| `originalValue` | money | No | Original purchase value |
| `purchasedOn` | date | No | Purchase date |
| `valuedOn` | date | No | Valuation date |
| `valuationBasis` | string | No | How valued (Market Value, Professional Valuation, etc.) |
| `ownership` | object | No | Ownership details |
| `ownership.ownershipType` | enum | No | SOLE, JOINT, TRUST |
| `ownership.jointOwnershipType` | enum | No | JOINT_TENANTS, TENANTS_IN_COMMON |
| `ownership.ownershipPercentage` | decimal | No | Percentage owned by this client |
| `ownership.owners` | array | No | List of owners |
| `isBusinessAssetDisposalRelief` | boolean | No | Qualifies for Business Asset Disposal Relief |
| `isBusinessReliefQualifying` | boolean | No | Qualifies for Business Property Relief (IHT) |
| `isFreeFromInheritanceTax` | boolean | No | Free from IHT |
| `rnrbEligibility` | enum | No | Residence Nil Rate Band eligibility |
| `property` | object | No | Property details (if assetType=PROPERTY) |
| `income` | object | No | Link to income generated |
| `dividends` | object | No | Dividend information |
| `rentalExpenses` | money | No | Annual rental expenses |
| `notes` | string | No | Additional notes |
| `isVisibleToClient` | boolean | No | Whether visible to client |
| `isHolding` | boolean | No | Whether this is a holding asset |
| `arrangement` | object | No | Link to financial arrangement |
| `createdAt` | datetime | Yes (response only) | When record was created |
| `updatedAt` | datetime | Yes (response only) | When record was last updated |

**Total Properties:** 28 properties (including nested)

### 22.4 Contract Schema

```json
{
  "id": 1234,
  "href": "/api/v2/factfinds/679/assets/1234",
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123",
    "status": "INP"
  },
  "assetType": "PROPERTY",
  "description": "Primary Residence - 123 Main Street",
  "currentValue": {
    "amount": 450000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "originalValue": {
    "amount": 325000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "purchasedOn": "2018-05-10",
  "valuedOn": "2026-01-15",
  "valuationBasis": "Comparable Sales",
  "ownership": {
    "ownershipType": "JOINT",
    "jointOwnershipType": "JOINT_TENANTS",
    "ownershipPercentage": 50.0,
    "owners": [
      {
        "clientId": 8496,
        "clientName": "John Smith",
        "percentage": 50.0
      },
      {
        "clientId": 8497,
        "clientName": "Sarah Smith",
        "percentage": 50.0
      }
    ]
  },
  "isBusinessAssetDisposalRelief": false,
  "isBusinessReliefQualifying": false,
  "isFreeFromInheritanceTax": false,
  "rnrbEligibility": "Eligible",
  "property": {
    "id": 1,
    "propertyType": "DETACHED",
    "numberOfBedrooms": 4,
    "address": {
      "line1": "123 Main Street",
      "city": "London",
      "postcode": "SW1A 1AA",
      "country": "GB"
    }
  },
  "income": null,
  "notes": "Rental property - managed by external agent",
  "isVisibleToClient": true,
  "isHolding": false,
  "createdAt": "2026-02-01T10:00:00Z",
  "updatedAt": "2026-02-15T14:30:00Z"
}
```

### 22.5 Complete Examples

#### Example 1: Add Primary Residence Property

**Request:**
```http
POST /api/v2/factfinds/679/assets
Content-Type: application/json
Authorization: Bearer {token}

{
  "assetType": "PROPERTY",
  "description": "Primary Residence - 123 Main Street",
  "currentValue": {
    "amount": 450000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "originalValue": {
    "amount": 325000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "purchasedOn": "2018-05-10",
  "valuedOn": "2026-01-15",
  "valuationBasis": "Comparable Sales",
  "ownership": {
    "ownershipType": "JOINT",
    "jointOwnershipType": "JOINT_TENANTS",
    "ownershipPercentage": 50.0,
    "owners": [
      {
        "clientId": 8496,
        "percentage": 50.0
      },
      {
        "clientId": 8497,
        "percentage": 50.0
      }
    ]
  },
  "rnrbEligibility": "Eligible",
  "property": {
    "propertyType": "DETACHED",
    "numberOfBedrooms": 4,
    "address": {
      "line1": "123 Main Street",
      "city": "London",
      "postcode": "SW1A 1AA",
      "country": "GB"
    }
  }
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json
Location: /api/v2/factfinds/679/assets/1234

{
  "id": 1234,
  "href": "/api/v2/factfinds/679/assets/1234",
  "assetType": "PROPERTY",
  "description": "Primary Residence - 123 Main Street",
  "currentValue": {
    "amount": 450000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "originalValue": {
    "amount": 325000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "capitalGrowth": {
    "amount": 125000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "capitalGrowthPercentage": 38.46,
  "annualizedGrowth": 4.21,
  "ownership": {
    "ownershipType": "JOINT",
    "jointOwnershipType": "JOINT_TENANTS",
    "ownershipPercentage": 50.0
  },
  "rnrbEligibility": "Eligible",
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z",
  "_links": {
    "property": {
      "href": "/api/v2/factfinds/679/assets/1234/property"
    }
  }
}
```

#### Example 2: Add Business Asset

**Request:**
```http
POST /api/v2/factfinds/679/assets
Content-Type: application/json
Authorization: Bearer {token}

{
  "assetType": "BUSINESS",
  "description": "Smith & Co Limited - Software Consultancy",
  "currentValue": {
    "amount": 250000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "valuedOn": "2026-02-01",
  "valuationBasis": "NET_ASSET_VALUE",
  "ownership": {
    "ownershipType": "SOLE",
    "ownershipPercentage": 100.0
  },
  "isBusinessAssetDisposalRelief": true,
  "isBusinessReliefQualifying": true,
  "notes": "Qualifying trading company - 100% IHT relief after 2 years ownership"
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1235,
  "href": "/api/v2/factfinds/679/assets/1235",
  "assetType": "BUSINESS",
  "description": "Smith & Co Limited - Software Consultancy",
  "currentValue": {
    "amount": 250000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "ownership": {
    "ownershipType": "SOLE",
    "ownershipPercentage": 100.0
  },
  "isBusinessAssetDisposalRelief": true,
  "isBusinessReliefQualifying": true,
  "ihtReliefPercentage": 100,
  "notes": "Qualifying trading company - 100% IHT relief after 2 years ownership",
  "createdAt": "2026-03-03T10:35:00Z",
  "updatedAt": "2026-03-03T10:35:00Z"
}
```

#### Example 3: Add Cash Savings

**Request:**
```http
POST /api/v2/factfinds/679/assets
Content-Type: application/json
Authorization: Bearer {token}

{
  "assetType": "CASH",
  "description": "Emergency fund - instant access savings",
  "currentValue": {
    "amount": 25000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "valuedOn": "2026-03-01",
  "ownership": {
    "ownershipType": "SOLE",
    "ownershipPercentage": 100.0
  }
}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1236,
  "href": "/api/v2/factfinds/679/assets/1236",
  "assetType": "CASH",
  "description": "Emergency fund - instant access savings",
  "currentValue": {
    "amount": 25000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "ownership": {
    "ownershipType": "SOLE",
    "ownershipPercentage": 100.0
  },
  "createdAt": "2026-03-03T10:40:00Z",
  "updatedAt": "2026-03-03T10:40:00Z"
}
```

### 22.6 Business Rules

1. **Asset Type Validation:** Must be one of: PROPERTY, BUSINESS, CASH, INVESTMENT, OTHER
2. **Current Value Required:** All assets must have a current value
3. **Ownership Percentage:** Must sum to 100% across all owners
4. **Joint Ownership Types:**
   - JOINT_TENANTS: Both own 100%, passes to survivor on death
   - TENANTS_IN_COMMON: Own specific percentages, can be left in will
5. **RNRB Eligibility:** Main residence passing to direct descendants qualifies
6. **Business Property Relief (BPR):**
   - Trading businesses: 100% relief after 2 years
   - Investment businesses: Not qualifying
   - Agricultural property: May qualify for Agricultural Property Relief instead
7. **Capital Growth Calculation:** `currentValue - originalValue` if both provided
8. **Annualized Growth:** Calculated as CAGR if purchase date provided

### 22.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `assetType` | enum | Filter by asset type | `assetType=PROPERTY` |
| `ownershipType` | enum | Filter by ownership | `ownershipType=SOLE` |
| `businessReliefQualifying` | boolean | Filter BPR qualifying | `businessReliefQualifying=true` |
| `minValue` | decimal | Minimum asset value | `minValue=100000` |
| `maxValue` | decimal | Maximum asset value | `maxValue=1000000` |

### 22.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid asset ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 22.9 Regulatory Compliance

**Inheritance Tax (IHT):**
- Standard IHT: 40% on estate above nil rate band
- Nil Rate Band (NRB): £325,000 (frozen until 2028)
- Residence Nil Rate Band (RNRB): Up to £175,000 for main residence
- Business Property Relief: 50% or 100% relief for qualifying businesses
- Agricultural Property Relief: 50% or 100% for agricultural property

**Capital Gains Tax (CGT):**
- Main residence: Usually exempt (Private Residence Relief)
- Other property: CGT at 18% (basic rate) or 28% (higher rate)
- Business assets: May qualify for Business Asset Disposal Relief (10% rate)
- Annual exemption: £3,000 (2024/25)

**FCA Requirements:**
- Asset verification for high-value assets
- Valuation evidence for properties (surveyor, estate agent)
- Beneficial ownership disclosure

### 22.10 Related APIs

- [FactFind Root API](#4-factfind-root-api) - Parent resource
- [Net Worth API](#23-net-worth-api) - Asset aggregation
- [Income API](#19-income-api) - Asset-generated income (rental, dividends)
- [Estate Planning API](#12-estate-planning-api) - IHT planning

---

## 23. Liability API

### 23.1 Overview

**Purpose:** The Liability API manages client debt obligations including mortgages, loans, credit cards, hire purchase agreements, student loans, and maintenance payments with comprehensive tracking of repayment terms, protection coverage, and linked assets.

**Base Path:** `/api/v2/factfinds/{factfindId}/liabilities`

**Aggregate Root:** FactFind

**Key Features:**
- Multi-type liability tracking (mortgage, personal loan, credit card, HP/lease, student loan, maintenance, other)
- Linked asset tracking for secured debts (property, car, etc.)
- Protection arrangement linking (life insurance, critical illness coverage)
- Consolidation flagging for debt refinancing analysis
- Early redemption charge tracking
- Repayment plan monitoring (capital & interest, interest-only, part-and-part)
- Interest rate and rate type tracking (fixed, variable, tracker)
- Credit limit tracking for revolving credit
- Debt payment tracking linked to expenditure

### 23.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/liabilities` | List all liabilities | N/A | 200 OK - Liability[] |
| POST | `/api/v2/factfinds/{factfindId}/liabilities` | Add new liability | LiabilityRequest | 201 Created - Liability |
| GET | `/api/v2/factfinds/{factfindId}/liabilities/{liabilityId}` | Get liability details | N/A | 200 OK - Liability |
| PATCH | `/api/v2/factfinds/{factfindId}/liabilities/{liabilityId}` | Update liability | LiabilityPatch | 200 OK - Liability |
| DELETE | `/api/v2/factfinds/{factfindId}/liabilities/{liabilityId}` | Delete liability | N/A | 204 No Content |

**Total Operations:** 5 endpoints

**Required Authorization Scopes:**
- `assets:read` - Read access to liabilities
- `assets:write` - Create and update liabilities
- `assets:delete` - Delete liabilities

### 23.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique identifier for the liability |
| `href` | string | Yes (response only) | API link to this resource |
| `factfind` | object | Yes (response only) | FactFind reference |
| `owner` | object | Yes | Client who owns this liability |
| `description` | string | No | Description of the liability (e.g., "Primary Residence Mortgage - 123 Main Street") |
| `liabilityCategory` | enum | Yes | Type of liability |
| `lender` | string | Yes | Lender/creditor name |
| `liabilityAccountNumber` | string | No | Account or reference number |
| `originalLoanAmount` | money | Yes | Original loan principal |
| `amountOutstanding` | money | Yes | Current outstanding balance |
| `creditLimit` | money | No | Credit limit (required for credit cards) |
| `interestRate` | decimal | Yes | Current interest rate percentage (e.g., 3.5) |
| `rateType` | enum | Yes | Interest rate type |
| `repaymentOrInterestOnly` | enum | Yes | Repayment method |
| `paymentAmount` | money | Yes | Regular payment amount |
| `loanTermYears` | integer | Yes | Original loan term in years |
| `startDate` | date | No | Loan start date |
| `endDate` | date | No | Expected end/maturity date |
| `earlyRedemptionCharge` | money | No | Early repayment penalty amount |
| `protected` | enum | Yes | Protection coverage type |
| `linkedAssetRef` | object | No | Reference to secured asset |
| `protectionArrangementRef` | object | No | Reference to protection policy |
| `isToBeRepaid` | boolean | Yes | Whether liability will be repaid |
| `consolidate` | boolean | Yes | Whether to consolidate this debt |
| `howWillLiabilityBeRepaid` | string | No | Repayment plan description |
| `isGuarantorMortgage` | boolean | No | Whether this is a guarantor mortgage |
| `createdAt` | datetime | Yes (response only) | When created |
| `updatedAt` | datetime | Yes (response only) | Last updated |

**Liability Categories:**
- `MAIN_RESIDENCE` - Primary residence mortgage
- `BUY_TO_LET` - Buy-to-let mortgage
- `SECOND_HOME` - Second home/holiday home mortgage
- `PERSONAL_LOAN` - Unsecured personal loan
- `CREDIT_CARD` - Revolving credit card debt
- `HP_LEASE` - Hire purchase or lease agreement
- `STUDENT_LOAN` - Student loan debt
- `MAINTENANCE` - Maintenance or alimony payments
- `OTHER` - Other liability types

**Rate Types:**
- `FIXED` - Fixed interest rate
- `VARIABLE` - Variable interest rate
- `TRACKER` - Tracker rate (follows base rate)

**Repayment Methods:**
- `REPAYMENT` - Capital and interest (repayment)
- `INTEREST_ONLY` - Interest-only payments
- `PART_AND_PART` - Part repayment, part interest-only

**Protection Types:**
- `NOT_PROTECTED` - No protection cover
- `LIFE` - Life insurance only
- `CIC` - Critical illness cover only
- `LIFE_AND_CIC` - Life and critical illness cover

### 23.4 Contract Schema

**Complete Liability Contract:**

```json
{
  "id": 789,
  "href": "/api/v2/factfinds/679/liabilities/789",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "owner": {
    "client": {
      "id": 8496,
      "href": "/api/v2/factfinds/679/clients/8496",
      "name": "John Smith"
    }
  },
  "description": "Primary Residence Mortgage - 123 Main Street, London",
  "liabilityCategory": "MAIN_RESIDENCE",
  "lender": "Nationwide Building Society",
  "liabilityAccountNumber": "MTG-123456",
  "originalLoanAmount": {
    "amount": 250000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "amountOutstanding": {
    "amount": 180000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "creditLimit": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "interestRate": 3.5,
  "rateType": "FIXED",
  "repaymentOrInterestOnly": "REPAYMENT",
  "paymentAmount": {
    "amount": 1200.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "loanTermYears": 25,
  "startDate": "2015-06-01",
  "endDate": "2040-06-01",
  "earlyRedemptionCharge": {
    "amount": 5000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "protected": "LIFE_AND_CIC",
  "linkedAssetRef": {
    "id": 1234,
    "href": "/api/v2/factfinds/679/assets/1234"
  },
  "protectionArrangementRef": {
    "id": 555,
    "href": "/api/v2/factfinds/679/protections/555"
  },
  "isToBeRepaid": false,
  "consolidate": false,
  "howWillLiabilityBeRepaid": null,
  "isGuarantorMortgage": false,
  "createdAt": "2015-06-01T10:00:00Z",
  "updatedAt": "2024-01-15T14:30:00Z"
}
```

### 23.5 Complete Examples

**Example 1: Primary Residence Mortgage (Secured Against Property)**

Request:
```http
POST /api/v2/factfinds/679/liabilities
Content-Type: application/json
Authorization: Bearer {token}

{
  "owner": {
    "client": {
      "id": 8496,
      "name": "John Smith"
    }
  },
  "description": "Primary Residence Mortgage - 123 Main Street, London",
  "liabilityCategory": "MAIN_RESIDENCE",
  "lender": "Nationwide Building Society",
  "liabilityAccountNumber": "MTG-123456",
  "originalLoanAmount": {
    "amount": 250000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "amountOutstanding": {
    "amount": 180000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "interestRate": 3.5,
  "rateType": "FIXED",
  "repaymentOrInterestOnly": "REPAYMENT",
  "paymentAmount": {
    "amount": 1200.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "loanTermYears": 25,
  "startDate": "2015-06-01",
  "endDate": "2040-06-01",
  "earlyRedemptionCharge": {
    "amount": 5000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "protected": "LIFE_AND_CIC",
  "linkedAssetRef": {
    "id": 1234
  },
  "protectionArrangementRef": {
    "id": 555
  },
  "isToBeRepaid": false,
  "consolidate": false,
  "isGuarantorMortgage": false
}
```

Response: `201 Created` with complete Liability object including `id` and `href`.

**Example 2: Personal Loan (Unsecured, Protection Linked)**

```json
{
  "id": 790,
  "href": "/api/v2/factfinds/679/liabilities/790",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "owner": {
    "client": {
      "id": 8496,
      "href": "/api/v2/factfinds/679/clients/8496",
      "name": "John Smith"
    }
  },
  "description": "Personal Loan - Debt Consolidation",
  "liabilityCategory": "PERSONAL_LOAN",
  "lender": "Santander UK",
  "liabilityAccountNumber": "PL-987654",
  "originalLoanAmount": {
    "amount": 15000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "amountOutstanding": {
    "amount": 12500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "creditLimit": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "interestRate": 6.9,
  "rateType": "FIXED",
  "repaymentOrInterestOnly": "REPAYMENT",
  "paymentAmount": {
    "amount": 280.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "loanTermYears": 5,
  "startDate": "2022-01-15",
  "endDate": "2027-01-15",
  "earlyRedemptionCharge": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "protected": "LIFE",
  "linkedAssetRef": null,
  "protectionArrangementRef": {
    "id": 556,
    "href": "/api/v2/factfinds/679/protections/556"
  },
  "isToBeRepaid": true,
  "consolidate": false,
  "howWillLiabilityBeRepaid": "Regular monthly payments from salary",
  "isGuarantorMortgage": false,
  "createdAt": "2022-01-15T09:00:00Z",
  "updatedAt": "2024-01-15T11:20:00Z"
}
```

**Example 3: Credit Card (Revolving, Consolidation Flagged)**

```json
{
  "id": 791,
  "href": "/api/v2/factfinds/679/liabilities/791",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "owner": {
    "client": {
      "id": 8496,
      "href": "/api/v2/factfinds/679/clients/8496",
      "name": "John Smith"
    }
  },
  "description": "Barclaycard Platinum",
  "liabilityCategory": "CREDIT_CARD",
  "lender": "Barclays Bank PLC",
  "liabilityAccountNumber": "CC-567890",
  "originalLoanAmount": {
    "amount": 8000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "amountOutstanding": {
    "amount": 8000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "creditLimit": {
    "amount": 12000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "interestRate": 21.9,
  "rateType": "VARIABLE",
  "repaymentOrInterestOnly": "REPAYMENT",
  "paymentAmount": {
    "amount": 160.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "loanTermYears": 0,
  "startDate": "2018-03-01",
  "endDate": null,
  "earlyRedemptionCharge": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "protected": "NOT_PROTECTED",
  "linkedAssetRef": null,
  "protectionArrangementRef": null,
  "isToBeRepaid": true,
  "consolidate": true,
  "howWillLiabilityBeRepaid": "To be consolidated into debt consolidation loan",
  "isGuarantorMortgage": false,
  "createdAt": "2018-03-01T10:00:00Z",
  "updatedAt": "2024-01-20T09:15:00Z"
}
```

### 23.6 Business Rules

1. **Linked Asset Validation:** If `linkedAssetRef` is provided, the referenced asset must exist in the same factfind and belong to one of the liability owners
2. **Protection Arrangement Validation:** If `protected` is not `NOT_PROTECTED`, it is recommended (but not required) to provide `protectionArrangementRef`
3. **Credit Limit Requirement:** For `CREDIT_CARD` category, `creditLimit` is required and must be greater than or equal to `amountOutstanding`
4. **Outstanding Balance:** `amountOutstanding` must be less than or equal to `originalLoanAmount` (debt cannot exceed original principal)
5. **Consolidation Planning:** If `consolidate` is true, `howWillLiabilityBeRepaid` should be specified to document the consolidation strategy
6. **Asset Linking Suggestion:** For `MAIN_RESIDENCE`, `BUY_TO_LET`, or `SECOND_HOME` categories, link to an Asset with matching category
7. **Interest Rate Range:** Interest rate should be positive and typically between 0.5% and 30% (higher rates warrant review)
8. **Repayment Date Logic:** If `endDate` is provided, it should be after `startDate` and calculated based on `loanTermYears`

### 23.7 Query Parameters

**List Operation Query Parameters:**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `liabilityCategory` | enum | Filter by liability type | `?liabilityCategory=CREDIT_CARD` |
| `lender` | string | Filter by lender name | `?lender=Nationwide` |
| `owner` | integer | Filter by owner client ID | `?owner=8496` |
| `minAmount` | decimal | Minimum outstanding amount | `?minAmount=10000` |
| `maxAmount` | decimal | Maximum outstanding amount | `?maxAmount=200000` |
| `isToBeRepaid` | boolean | Filter by repayment intention | `?isToBeRepaid=true` |
| `consolidate` | boolean | Filter by consolidation flag | `?consolidate=true` |
| `protected` | enum | Filter by protection type | `?protected=LIFE_AND_CIC` |
| `rateType` | enum | Filter by rate type | `?rateType=FIXED` |
| `page` | integer | Page number (1-indexed) | `?page=1` |
| `pageSize` | integer | Items per page (max 100) | `?pageSize=25` |
| `sort` | string | Sort field and direction | `?sort=amountOutstanding:desc` |

**Sort Fields:**
- `amountOutstanding` - Outstanding balance
- `interestRate` - Interest rate percentage
- `paymentAmount` - Monthly payment amount
- `endDate` - Maturity date
- `lender` - Lender name (alphabetical)
- `createdAt` - Creation date

### 23.8 HTTP Status Codes

| Code | Description | When Used |
|------|-------------|-----------|
| 200 OK | Success | GET, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed JSON, invalid data types |
| 401 Unauthorized | Authentication required | Missing or invalid token |
| 403 Forbidden | Insufficient permissions | Lacks `assets:write` or `assets:delete` scope |
| 404 Not Found | Resource not found | Invalid liability ID or factfind ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation (e.g., invalid linked asset, creditLimit < amountOutstanding) |
| 500 Internal Server Error | Server error | Unexpected server issue |

### 23.9 Regulatory Compliance

**FCA MCOB 11 (Responsible Lending):**
- Complete liability data required for affordability assessments
- Lenders must verify existing debt commitments
- Debt-to-income ratio calculations require all liabilities
- Stress testing includes all debt payments

**Consumer Credit Act 1974:**
- Regulates consumer credit agreements (loans, credit cards, HP)
- Credit limit tracking for regulated agreements
- Early redemption rights and charges
- Disclosure requirements

**FCA CONC (Consumer Credit Sourcebook):**
- Creditworthiness assessments require liability verification
- Affordability checks must consider all existing credit commitments
- High-cost short-term credit (HCSTC) rules

**GDPR Compliance:**
- Debt information is personally identifiable information (PII)
- Consent required for data processing
- Right to erasure (with financial record retention exceptions)
- Data minimization - only collect necessary liability details

**Money and Mental Health Policy Institute:**
- Vulnerability considerations for debt management
- Breathing space scheme (60-day protection from creditor action)
- Mental health crisis debt protections

**Debt Collection Regulations:**
- FCA rules on debt collection practices
- Forbearance requirements for customers in financial difficulty
- Fair treatment of customers in arrears

**Mortgage Market Review (MMR):**
- Interest-only mortgage validation
- Repayment strategy verification required for interest-only
- Debt consolidation must improve affordability position

### 23.10 Related APIs

- **[Asset API](#22-asset-api)** - Linked assets for secured debts (property, vehicles)
- **[Personal Protection API](#30-personal-protection-api)** - Linked protection policies (life insurance, critical illness)
- **[Expenditure API](#20-expenditure-api)** - Monthly debt payments recorded as expenditure
- **[Net Worth API](#24-net-worth-api)** - Liability aggregation for net worth calculation
- **[Mortgage API](#29-mortgage-api)** - Detailed mortgage product management (superset of mortgage liabilities)
- **[Affordability API](#21-affordability-api)** - Debt obligations impact affordability calculations
- **[Objectives API](#31-objectives-api)** - Debt repayment and consolidation goals
- **[Client API](#5-client-management-api)** - Liability ownership
- **[FactFind Root API](#4-factfind-root-api)** - Parent aggregate root

---

## 24. Net Worth API

### 23.1 Overview

**Purpose:** The Net Worth API calculates and tracks client net worth (assets minus liabilities) with historical tracking, wealth progression analysis, and retirement gap calculations.

**Base Path:** `/api/v2/factfinds/{factfindId}/net-worth`

**Key Features:**
- Current net worth calculation
- Asset and liability aggregation
- Historical net worth tracking
- Wealth progression analysis
- Retirement gap assessment
- Asset allocation breakdown
- Liquidity analysis

### 23.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/net-worth` | Get current net worth | N/A | 200 OK - NetWorth |
| POST | `/api/v2/factfinds/{factfindId}/net-worth/calculate` | Calculate net worth | N/A | 201 Created - NetWorthSnapshot |
| GET | `/api/v2/factfinds/{factfindId}/net-worth/history` | Get historical snapshots | N/A | 200 OK - NetWorthHistory[] |
| PATCH | `/api/v2/factfinds/{factfindId}/net-worth/{snapshotId}` | Update snapshot | NetWorthPatch | 200 OK - NetWorthSnapshot |
| DELETE | `/api/v2/factfinds/{factfindId}/net-worth/{snapshotId}` | Delete snapshot | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 23.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `href` | string | Yes (response only) | API link to this resource |
| `factfind` | object | Yes (response only) | FactFind reference |
| `calculatedOn` | datetime | Yes | When calculated |
| `totalAssets` | money | Yes | Total value of all assets |
| `totalLiabilities` | money | Yes | Total value of all liabilities |
| `netWorth` | money | Yes | Assets minus liabilities |
| `assetBreakdown` | object | No | Assets by type |
| `assetBreakdown.property` | money | No | Property assets |
| `assetBreakdown.investments` | money | No | Investment assets |
| `assetBreakdown.pensions` | money | No | Pension assets |
| `assetBreakdown.business` | money | No | Business assets |
| `assetBreakdown.cash` | money | No | Cash assets |
| `assetBreakdown.other` | money | No | Other assets |
| `liabilityBreakdown` | object | No | Liabilities by type |
| `liabilityBreakdown.mortgages` | money | No | Mortgage debt |
| `liabilityBreakdown.loans` | money | No | Loan debt |
| `liabilityBreakdown.creditCards` | money | No | Credit card debt |
| `liabilityBreakdown.other` | money | No | Other liabilities |
| `liquidAssets` | money | No | Cash and easily liquidated assets |
| `illiquidAssets` | money | No | Property and difficult-to-sell assets |
| `liquidityRatio` | decimal | No | Liquid assets as % of total |
| `debtToAssetRatio` | decimal | No | Liabilities as % of assets |
| `wealthProgression` | object | No | Comparison to previous snapshot |
| `wealthProgression.previousNetWorth` | money | No | Previous net worth |
| `wealthProgression.change` | money | No | Change in net worth |
| `wealthProgression.changePercentage` | decimal | No | Percentage change |
| `wealthProgression.periodMonths` | integer | No | Months since last snapshot |
| `retirementGap` | object | No | Retirement planning analysis |
| `retirementGap.targetRetirementAge` | integer | No | Target retirement age |
| `retirementGap.currentAge` | integer | No | Current age |
| `retirementGap.yearsToRetirement` | integer | No | Years until retirement |
| `retirementGap.requiredNetWorth` | money | No | Net worth needed for retirement |
| `retirementGap.currentNetWorth` | money | No | Current net worth |
| `retirementGap.shortfall` | money | No | Retirement shortfall |
| `retirementGap.monthlyContributionRequired` | money | No | Monthly savings needed |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | When record was created |
| `updatedAt` | datetime | Yes (response only) | When record was last updated |

**Total Properties:** 38 properties (including nested)

### 23.4 Contract Schema

```json
{
  "href": "/api/v2/factfinds/679/net-worth",
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123",
    "status": "INP"
  },
  "calculatedOn": "2026-03-03T10:30:00Z",
  "totalAssets": {
    "amount": 850000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "totalLiabilities": {
    "amount": 240000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "netWorth": {
    "amount": 610000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "assetBreakdown": {
    "property": {
      "amount": 450000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "investments": {
      "amount": 185000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "pensions": {
      "amount": 175000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "business": {
      "amount": 0.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "cash": {
      "amount": 40000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "other": {
      "amount": 0.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "liabilityBreakdown": {
    "mortgages": {
      "amount": 200000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "loans": {
      "amount": 30000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "creditCards": {
      "amount": 10000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "other": {
      "amount": 0.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "liquidAssets": {
    "amount": 225000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "illiquidAssets": {
    "amount": 625000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "liquidityRatio": 26.47,
  "debtToAssetRatio": 28.24,
  "wealthProgression": {
    "previousNetWorth": {
      "amount": 575000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "change": {
      "amount": 35000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "changePercentage": 6.09,
    "periodMonths": 12
  },
  "retirementGap": {
    "targetRetirementAge": 65,
    "currentAge": 45,
    "yearsToRetirement": 20,
    "requiredNetWorth": {
      "amount": 1200000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "currentNetWorth": {
      "amount": 610000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "shortfall": {
      "amount": 590000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "monthlyContributionRequired": {
      "amount": 1750.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "notes": "Strong wealth progression. Property value growth main driver.",
  "createdAt": "2026-03-03T10:30:00Z",
  "updatedAt": "2026-03-03T10:30:00Z"
}
```

### 23.5 Complete Examples

#### Example 1: Calculate Current Net Worth

**Request:**
```http
POST /api/v2/factfinds/679/net-worth/calculate
Authorization: Bearer {token}
```

**Response:**
```http
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 1,
  "href": "/api/v2/factfinds/679/net-worth/1",
  "calculatedOn": "2026-03-03T10:30:00Z",
  "totalAssets": {
    "amount": 850000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "totalLiabilities": {
    "amount": 240000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "netWorth": {
    "amount": 610000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "assetBreakdown": {
    "property": {
      "amount": 450000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "investments": {
      "amount": 185000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "pensions": {
      "amount": 175000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "cash": {
      "amount": 40000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "liabilityBreakdown": {
    "mortgages": {
      "amount": 200000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "loans": {
      "amount": 30000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "creditCards": {
      "amount": 10000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "liquidityRatio": 26.47,
  "debtToAssetRatio": 28.24,
  "createdAt": "2026-03-03T10:30:00Z"
}
```

#### Example 2: Get Net Worth History

**Request:**
```http
GET /api/v2/factfinds/679/net-worth/history
Authorization: Bearer {token}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "factfindId": 679,
  "snapshots": [
    {
      "id": 1,
      "calculatedOn": "2026-03-03T10:30:00Z",
      "netWorth": {
        "amount": 610000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "totalAssets": {
        "amount": 850000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "totalLiabilities": {
        "amount": 240000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    },
    {
      "id": 2,
      "calculatedOn": "2025-03-01T10:00:00Z",
      "netWorth": {
        "amount": 575000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "totalAssets": {
        "amount": 810000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "totalLiabilities": {
        "amount": 235000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    },
    {
      "id": 3,
      "calculatedOn": "2024-03-01T10:00:00Z",
      "netWorth": {
        "amount": 540000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "totalAssets": {
        "amount": 775000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "totalLiabilities": {
        "amount": 235000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    }
  ],
  "progression": {
    "firstSnapshot": "2024-03-01T10:00:00Z",
    "latestSnapshot": "2026-03-03T10:30:00Z",
    "totalIncrease": {
      "amount": 70000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "percentageIncrease": 12.96,
    "annualizedGrowth": 6.21
  }
}
```

#### Example 3: Get Net Worth with Retirement Gap

**Request:**
```http
GET /api/v2/factfinds/679/net-worth?includeRetirementGap=true&targetRetirementAge=65&requiredIncome=40000
Authorization: Bearer {token}
```

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "href": "/api/v2/factfinds/679/net-worth",
  "netWorth": {
    "amount": 610000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "retirementGap": {
    "targetRetirementAge": 65,
    "currentAge": 45,
    "yearsToRetirement": 20,
    "requiredAnnualIncome": {
      "amount": 40000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "estimatedStatePension": {
      "amount": 11502.40,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "requiredPrivateIncome": {
      "amount": 28497.60,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "requiredNetWorth": {
      "amount": 1200000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "currentNetWorth": {
      "amount": 610000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "shortfall": {
      "amount": 590000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "monthlyContributionRequired": {
      "amount": 1750.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "assumptions": {
      "annualReturnRate": 5.0,
      "inflationRate": 2.5,
      "withdrawalRate": 4.0
    }
  },
  "calculatedOn": "2026-03-03T10:30:00Z"
}
```

### 23.6 Business Rules

1. **Net Worth Calculation:** `totalAssets - totalLiabilities`
2. **Liquid Assets:** Cash, investments easily sold within 30 days
3. **Illiquid Assets:** Property, business assets, pension funds
4. **Liquidity Ratio:** `liquidAssets / totalAssets × 100`
5. **Debt-to-Asset Ratio:** `totalLiabilities / totalAssets × 100`
6. **Healthy Ratios:**
   - Liquidity: 20-30% considered healthy
   - Debt-to-Asset: Under 50% considered manageable
7. **Retirement Gap Calculation:**
   - Uses 4% safe withdrawal rate
   - Factors in state pension
   - Assumes 5% growth, 2.5% inflation
8. **Snapshot Frequency:** Recommended annual or semi-annual

### 23.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `includeRetirementGap` | boolean | Include retirement analysis | `includeRetirementGap=true` |
| `targetRetirementAge` | integer | Target retirement age | `targetRetirementAge=65` |
| `requiredIncome` | decimal | Required annual income | `requiredIncome=40000` |
| `fromDate` | date | Filter history from date | `fromDate=2024-01-01` |
| `toDate` | date | Filter history to date | `toDate=2026-12-31` |

### 23.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET successful |
| 201 Created | Resource created | POST calculate successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Invalid parameters |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid snapshot ID |
| 422 Unprocessable Entity | Validation failed | Missing asset/liability data |

### 23.9 Regulatory Compliance

**FCA Requirements:**
- Net worth assessment for suitability of products
- High net worth classification (£250k+ excluding main residence and pension)
- Sophistication criteria for investment categorization

**Pension Lifetime Allowance:**
- Was £1,073,100 (abolished April 2024)
- Now unlimited pension savings
- Lump sum allowances still apply

**Retirement Planning:**
- State Pension: £11,502.40 per annum (2024/25)
- State Pension age: Currently 66, rising to 67 by 2028
- Private pension needed for lifestyle above state pension

### 23.10 Related APIs

- [FactFind Root API](#4-factfind-root-api) - Parent resource
- [Asset API](#22-asset-api) - Asset details
- [Liability APIs](#mortgage-api-29) - Liability details
- [Pension APIs](#25-29) - Pension assets
- [Investment API](#24-investment-api) - Investment assets

---

**End of Sections 14-23**

---
## 25. Investment API

### 25.1 Overview

**Purpose:** The Investment API manages investment products including Cash Bank Accounts, Collective Investments (ISAs, OEICs, Unit Trusts), and Life-Assured Investments (Investment Bonds) with fund holdings, contribution tracking, and maturity projections.

**Base Path:** `/api/v2/factfinds/{factfindId}/investments`

**Key Features:**
- Multi-category support (CashBankAccount, Investment, LifeAssuredInvestment)
- ISA allowance tracking and tax wrapper management
- Fund holdings with ISIN/SEDOL codes and asset allocation
- Regular, lump sum, and transfer contributions
- Life cover and critical illness benefits for Investment Bonds
- Low/medium/high maturity projections
- Withdrawal and income tracking

### 25.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/investments` | List all investments | N/A | 200 OK - Investment[] |
| POST | `/api/v2/factfinds/{factfindId}/investments` | Create new investment | InvestmentRequest | 201 Created - Investment |
| GET | `/api/v2/factfinds/{factfindId}/investments/{investmentId}` | Get investment by ID | N/A | 200 OK - Investment |
| PATCH | `/api/v2/factfinds/{factfindId}/investments/{investmentId}` | Update investment | InvestmentPatch | 200 OK - Investment |
| DELETE | `/api/v2/factfinds/{factfindId}/investments/{investmentId}` | Delete investment | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 25.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique system identifier |
| `href` | string | Yes (response only) | API link to this resource |
| `factfind` | object | Yes (response only) | FactFind reference |
| `owners` | array | Yes | Investment owner(s) |
| `provider` | object | Yes | Investment provider/platform |
| `investmentType` | enum | Yes | STOCKS_SHARES_ISA, CASH_ISA, GIA, OEIC, UNIT_TRUST, INVESTMENT_BOND |
| `planName` | string | Yes | Investment plan name |
| `accountNumber` | string | No | Account or policy number |
| `currentValue` | money | Yes | Current investment value |
| `valuationDate` | date | Yes | Date of valuation |
| `inceptionDate` | date | No | Date investment started |
| `taxWrapperType` | enum | No | ISA, GIA, Offshore Bond, Onshore Bond |
| `isaType` | enum | No | STOCKS_SHARES, CASH, LIFETIME, JUNIOR |
| `isAdvised` | boolean | No | Whether investment is advised |
| `adviceType` | enum | No | ONGOING, ONE_OFF, EXECUTION_ONLY |
| `riskRating` | object | No | Risk rating (scale 1-10) |
| `fundHoldings` | array | No | List of fund holdings |
| `contributions` | array | No | List of contributions |
| `withdrawals` | array | No | List of withdrawals |
| `charges` | object | No | Fee and charge structure |
| `assetAllocation` | object | No | Asset class breakdown |
| `geographicAllocation` | object | No | Geographic breakdown |
| `maturityDate` | date | No | Maturity date (if applicable) |
| `projections` | object | No | Low/medium/high projections |
| `lifeCover` | object | No | Life cover details (Investment Bonds) |
| `criticalIllnessCover` | object | No | Critical illness cover (Investment Bonds) |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | When record was created |
| `updatedAt` | datetime | Yes (response only) | When record was last updated |

**Total Properties:** 28 properties (including nested)

### 25.4 Contract Schema

```json
{
  "id": 9140,
  "href": "/api/v2/factfinds/679/investments/9140",
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123"
  },
  "owners": [
    {
      "id": 8496,
      "name": "John Smith",
      "ownershipPercentage": 100.0
    }
  ],
  "provider": {
    "id": 456,
    "code": "VANGUARD",
    "display": "Vanguard Asset Management",
    "frnNumber": "123456"
  },
  "investmentType": "STOCKS_SHARES_ISA",
  "planName": "Vanguard ISA Portfolio",
  "accountNumber": "ISA-987654321",
  "currentValue": {
    "amount": 185000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "valuationDate": "2026-02-16",
  "inceptionDate": "2020-04-06",
  "taxWrapperType": "ISA",
  "isaType": "STOCKS_SHARES",
  "isAdvised": true,
  "adviceType": "ONGOING",
  "riskRating": {
    "code": "MODERATE",
    "display": "Moderate Risk",
    "numericScore": 5,
    "scale": "1-7"
  },
  "fundHoldings": [
    {
      "fundName": "Vanguard FTSE Global All Cap Index Fund",
      "isin": "GB00BD3RZ582",
      "sedol": "BD3RZ58",
      "units": 15234.56,
      "pricePerUnit": {
        "amount": 9.85,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "currentValue": {
        "amount": 150061.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "percentage": 81.1
    },
    {
      "fundName": "Vanguard Global Bond Index Fund",
      "isin": "GB00B4M8P890",
      "sedol": "B4M8P89",
      "units": 7856.23,
      "pricePerUnit": {
        "amount": 4.45,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "currentValue": {
        "amount": 34960.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "percentage": 18.9
    }
  ],
  "contributions": [
    {
      "id": 1,
      "type": "REGULAR",
      "amount": {
        "amount": 500.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "frequency": "MONTHLY",
      "startDate": "2020-04-06",
      "endDate": null,
      "isActive": true
    }
  ],
  "withdrawals": [],
  "charges": {
    "annualManagementCharge": 0.15,
    "platformFee": 0.25,
    "totalExpenseRatio": 0.40,
    "transactionFees": {
      "amount": 0.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "exitFees": {
      "amount": 0.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "assetAllocation": {
    "equities": {
      "percentage": 65.0,
      "value": {
        "amount": 120250.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    },
    "bonds": {
      "percentage": 25.0,
      "value": {
        "amount": 46250.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    },
    "cash": {
      "percentage": 5.0,
      "value": {
        "amount": 9250.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    },
    "alternatives": {
      "percentage": 5.0,
      "value": {
        "amount": 9250.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    }
  },
  "geographicAllocation": {
    "uk": {
      "percentage": 30.0,
      "value": {
        "amount": 55500.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    },
    "northAmerica": {
      "percentage": 45.0,
      "value": {
        "amount": 83250.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    },
    "europe": {
      "percentage": 15.0,
      "value": {
        "amount": 27750.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    },
    "asiaPacific": {
      "percentage": 8.0,
      "value": {
        "amount": 14800.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    },
    "emergingMarkets": {
      "percentage": 2.0,
      "value": {
        "amount": 3700.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    }
  },
  "notes": "Client prefers sustainable investing, ESG funds where possible",
  "createdAt": "2020-04-06T10:00:00Z",
  "updatedAt": "2026-02-16T16:30:00Z"
}
```

### 25.5 Complete Examples

See contract schema above for comprehensive investment example.

**Additional Investment Bond Example:**

```json
{
  "id": 9141,
  "investmentType": "INVESTMENT_BOND",
  "planName": "Prudential International Investment Bond",
  "taxWrapperType": "OFFSHORE_BOND",
  "currentValue": {
    "amount": 250000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "lifeCover": {
    "sumAssured": {
      "amount": 252500.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "coverPercentage": 101.0
  },
  "segmentation": {
    "numberOfSegments": 20,
    "segmentsSurrendered": 0,
    "segmentsRemaining": 20
  },
  "taxDeferred": true,
  "topSlicing": {
    "applicable": true,
    "years": 7
  }
}
```

### 25.6 Business Rules

1. **ISA Annual Allowance:** £20,000 per tax year (2024/25)
2. **ISA Types:** Cash ISA, Stocks & Shares ISA, Lifetime ISA, Junior ISA
3. **Only One Provider:** Can only pay into one ISA of each type per tax year
4. **Tax Benefits:**
   - ISA: Tax-free income and growth
   - Offshore Bond: Tax-deferred growth, 5% withdrawal allowance
   - Onshore Bond: Basic rate tax paid by provider
5. **Fund Identification:** Use ISIN (International Securities Identification Number) or SEDOL (Stock Exchange Daily Official List)
6. **Investment Bond Top Slicing:** Gains divided by number of complete years held to calculate tax
7. **Chargeable Event:** Surrender, full withdrawal, death, or assignment triggers chargeable event

### 25.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `investmentType` | enum | Filter by type | `investmentType=STOCKS_SHARES_ISA` |
| `taxWrapperType` | enum | Filter by wrapper | `taxWrapperType=ISA` |
| `isAdvised` | boolean | Filter advised | `isAdvised=true` |
| `minValue` | decimal | Minimum value | `minValue=10000` |

### 25.8 HTTP Status Codes

| Status Code | Description | When Used |
|-------------|-------------|-----------|
| 200 OK | Success | GET, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success with no body | DELETE successful |
| 400 Bad Request | Invalid syntax | Malformed request |
| 401 Unauthorized | Authentication required | Missing/invalid token |
| 403 Forbidden | Insufficient permissions | Lacks required scope |
| 404 Not Found | Resource not found | Invalid investment ID |
| 422 Unprocessable Entity | Validation failed | Business rule violation |

### 25.9 Regulatory Compliance

**FCA COBS 9 (Suitability):**
- Advice must be suitable for client's circumstances
- Risk profiling required for advised investments
- Ongoing suitability reviews required

**PROD 3 (Product Governance):**
- Target market identification
- Negative target markets
- Distribution strategy alignment

**HMRC Tax Treatment:**
- ISA: Tax-free
- GIA: Subject to income tax and CGT
- Offshore Bond: Tax-deferred, 5% withdrawal rule
- Onshore Bond: Basic rate tax already paid

### 25.10 Related APIs

- [Client Management API](#5-client-management-api) - Client ownership
- [ATR Assessment API](#32-atr-assessment-api) - Risk profiling
- [Financial Profile API](#15-financial-profile-api) - Investment experience
- [Net Worth API](#23-net-worth-api) - Investment assets aggregation

---

## 26. Final Salary Pension API

### 26.1 Overview

**Purpose:** The Final Salary Pension API manages Defined Benefit (DB) pension schemes including prospective benefits, Cash Equivalent Transfer Values (CETV), accrual tracking, death benefits, early retirement provisions, and Guaranteed Minimum Pension (GMP) tracking.

**Base Path:** `/api/v2/factfinds/{factfindId}/pensions/finalsalary`

**Key Features:**
- Final Salary, CARE, and Hybrid scheme support
- Prospective pension benefit calculations
- CETV tracking with expiry dates
- Accrual rate management (1/60, 1/80, etc.)
- Death in service and dependant benefits
- Early retirement reduction calculations
- GMP tracking (contracting-out periods)
- Scheme indexation (CPI, RPI caps)

### 26.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/pensions/finalsalary` | List all final salary pensions | N/A | 200 OK - FinalSalaryPension[] |
| POST | `/api/v2/factfinds/{factfindId}/pensions/finalsalary` | Create final salary pension | FinalSalaryPensionRequest | 201 Created - FinalSalaryPension |
| GET | `/api/v2/factfinds/{factfindId}/pensions/finalsalary/{pensionId}` | Get pension by ID | N/A | 200 OK - FinalSalaryPension |
| PATCH | `/api/v2/factfinds/{factfindId}/pensions/finalsalary/{pensionId}` | Update pension | FinalSalaryPensionPatch | 200 OK - FinalSalaryPension |
| DELETE | `/api/v2/factfinds/{factfindId}/pensions/finalsalary/{pensionId}` | Delete pension | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 26.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique identifier |
| `href` | string | Yes (response only) | Resource URL |
| `factfind` | object | Yes (response only) | FactFind reference |
| `owners` | array | Yes | Scheme member(s) |
| `provider` | object | Yes | Pension scheme provider (NHS, Teachers, etc.) |
| `schemeType` | enum | Yes | FinalSalary, CARE, Hybrid |
| `policyNumber` | string | No | Member/policy number |
| `employer` | string | Yes | Employer name |
| `normalRetirementAge` | integer | Yes | Normal retirement age |
| `dateSchemeJoined` | date | Yes | Date joined scheme |
| `expectedYearsOfService` | integer | No | Total expected years of service |
| `pensionableSalary` | money | Yes | Current pensionable salary |
| `accrualRate` | string | Yes | Accrual rate (e.g., 1/60, 1/80) |
| `pensionAtRetirement` | object | No | Prospective benefits at retirement |
| `pensionAtRetirement.prospectiveWithNoLumpsumTaken` | money | No | Annual pension if no lump sum |
| `pensionAtRetirement.prospectiveWithLumpsumTaken` | money | No | Annual pension with max lump sum |
| `pensionAtRetirement.prospectiveLumpSum` | money | No | Maximum tax-free lump sum |
| `isIndexed` | boolean | No | Whether indexed for inflation |
| `indexationNotes` | string | No | Indexation details (e.g., CPI capped at 2.5%) |
| `isPreserved` | boolean | No | Whether preserved (left employment) |
| `transferValue` | object | No | CETV details |
| `transferValue.cashEquivalentValue` | money | Yes | CETV amount |
| `transferValue.expiryOn` | date | Yes | CETV quote expiry date |
| `gmpAmount` | money | No | Guaranteed Minimum Pension |
| `deathInService` | object | No | Death in service benefits |
| `deathInService.lumpsumMultiple` | decimal | No | Multiple of salary (e.g., 3x, 4x) |
| `deathInService.lumpsumAmount` | money | No | Actual lump sum amount |
| `earlyRetirement` | object | No | Early retirement provisions |
| `earlyRetirement.earliestAge` | integer | No | Earliest age can retire |
| `earlyRetirement.reductionFactor` | decimal | No | Annual reduction percentage |
| `dependantBenefits` | object | No | Spouse/children benefits |
| `dependantBenefits.spousePension` | decimal | No | Spouse percentage (e.g., 50%, 66.67%) |
| `dependantBenefits.childrensPension` | decimal | No | Children's percentage |
| `lifeCycle` | object | No | Lifecycle stage |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | Creation timestamp |
| `updatedAt` | datetime | Yes (response only) | Update timestamp |

**Total Properties:** 33 properties (including nested)

### 26.4 Contract Schema

```json
{
  "id": 101,
  "href": "/api/v2/factfinds/679/pensions/finalsalary/101",
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123"
  },
  "owners": [
    {
      "id": 8496,
      "name": "John Smith"
    }
  ],
  "provider": {
    "id": 789,
    "name": "NHS Pension Scheme",
    "code": "NHS"
  },
  "schemeType": "FinalSalary",
  "policyNumber": "NHS-12345678",
  "employer": "Royal London Hospital NHS Trust",
  "normalRetirementAge": 60,
  "dateSchemeJoined": "1995-09-01",
  "expectedYearsOfService": 35,
  "pensionableSalary": {
    "amount": 55000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "accrualRate": "1/80",
  "pensionAtRetirement": {
    "prospectiveWithNoLumpsumTaken": {
      "amount": 24063.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "prospectiveWithLumpsumTaken": {
      "amount": 18047.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "prospectiveLumpSum": {
      "amount": 54141.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "isIndexed": true,
  "indexationNotes": "CPI capped at 2.5% per annum",
  "isPreserved": false,
  "transferValue": {
    "cashEquivalentValue": {
      "amount": 850000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "expiryOn": "2026-06-01"
  },
  "gmpAmount": {
    "amount": 3500.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "deathInService": {
    "lumpsumMultiple": 2.0,
    "lumpsumAmount": {
      "amount": 110000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "earlyRetirement": {
    "earliestAge": 55,
    "reductionFactor": 4.0
  },
  "dependantBenefits": {
    "spousePension": 50.0,
    "childrensPension": 25.0
  },
  "lifeCycle": {
    "id": 45,
    "name": "Accumulation"
  },
  "notes": "Protected NRA of 60. Member of NHS 1995 Section.",
  "createdAt": "2020-01-15T10:00:00Z",
  "updatedAt": "2026-02-16T14:30:00Z"
}
```

### 26.5 Complete Examples

See contract schema above for comprehensive example.

### 26.6 Business Rules

1. **Accrual Rates:**
   - 1/60: Modern schemes (Teachers, Civil Service)
   - 1/80: Older schemes with automatic lump sum (NHS 1995)
   - 1/54: NHS 2015 CARE
   - 1/49: LGPS 2014 CARE
2. **CETV Validity:** Transfer value quotes valid for 3 months
3. **Transfer Value Advice:** Transfers over £30,000 require FCA-regulated advice
4. **GMP:** Guaranteed Minimum Pension from contracting-out (1978-1997)
5. **Early Retirement:** Typically 4-5% reduction per year before NRA
6. **Spouse Benefits:** Usually 50% or 66.67% of member's pension
7. **Indexation:** Post-retirement increases (CPI capped, RPI, fixed %)

### 26.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `schemeType` | enum | Filter by scheme type | `schemeType=FinalSalary` |
| `isPreserved` | boolean | Filter preserved pensions | `isPreserved=true` |
| `provider` | string | Filter by provider | `provider=NHS` |

### 26.8 HTTP Status Codes

Standard HTTP status codes (200, 201, 204, 400, 401, 403, 404, 422)

### 26.9 Regulatory Compliance

**Pension Schemes Act 2015:**
- Statutory transfer rights
- CETV calculation requirements
- Transfer value guarantees (3-month validity)

**FCA Pension Transfer Advice:**
- Advice required for transfers over £30,000
- Transfer Value Analysis (TVAS) required
- Appropriate Pension Transfer Analysis (APTA)
- Must demonstrate transfer is in client's best interests

**FCA PS19/25 (British Steel Guidance):**
- Enhanced transfer value analysis
- Critical yield calculations
- Sustainability of income in retirement
- Comparison with DB benefits

### 26.10 Related APIs

- [Client Management API](#5-client-management-api) - Scheme member
- [Employment API](#18-employment-api) - Employment history
- [Net Worth API](#23-net-worth-api) - Pension assets

---

## 27. Annuity API

### 27.1 Overview

**Purpose:** The Annuity API manages annuity products including lifetime, fixed-term, and joint-life annuities with level, escalating, or RPI/CPI linked income, guarantee periods, and spouse continuation options.

**Base Path:** `/api/v2/factfinds/{factfindId}/pensions/annuity`

**Key Features:**
- Lifetime and fixed-term annuities
- Level, escalating, RPI/CPI linked income
- Single life and joint-life options
- Pension Commencement Lump Sum (PCLS) handling
- Guarantee periods (5, 10 years)
- Spouse/dependent continuation benefits
- Enhanced/impaired life annuities
- Value protection (return of capital)

### 27.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/pensions/annuity` | List all annuities | N/A | 200 OK - Annuity[] |
| POST | `/api/v2/factfinds/{factfindId}/pensions/annuity` | Create annuity | AnnuityRequest | 201 Created - Annuity |
| GET | `/api/v2/factfinds/{factfindId}/pensions/annuity/{annuityId}` | Get annuity by ID | N/A | 200 OK - Annuity |
| PATCH | `/api/v2/factfinds/{factfindId}/pensions/annuity/{annuityId}` | Update annuity | AnnuityPatch | 200 OK - Annuity |
| DELETE | `/api/v2/factfinds/{factfindId}/pensions/annuity/{annuityId}` | Delete annuity | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 27.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique identifier |
| `href` | string | Yes (response only) | Resource URL |
| `factfind` | object | Yes (response only) | FactFind reference |
| `owners` | array | Yes | Annuity owner(s) |
| `provider` | object | Yes | Annuity provider |
| `annuityType` | enum | Yes | Lifetime, FixedTerm, Enhanced, Impaired |
| `policyNumber` | string | No | Policy number |
| `purchasePrice` | money | Yes | Amount used to purchase annuity |
| `purchaseDate` | date | Yes | Date annuity purchased |
| `incomeType` | enum | Yes | Level, Escalating, RPI_Linked, CPI_Linked |
| `escalationRate` | decimal | No | Annual escalation % (if escalating) |
| `initialAnnualIncome` | money | Yes | Initial annual income |
| `currentAnnualIncome` | money | Yes | Current annual income (after escalations) |
| `paymentFrequency` | enum | Yes | Monthly, Quarterly, Annual |
| `isJointLife` | boolean | Yes | Whether joint-life annuity |
| `jointLifePercentage` | decimal | No | % to spouse on death (50%, 66.67%, 100%) |
| `guaranteePeriod` | integer | No | Guarantee period (years) - 0, 5, 10 |
| `valueProtection` | boolean | No | Return of capital on early death |
| `pcls` | object | No | Pension Commencement Lump Sum taken |
| `pcls.amount` | money | No | PCLS amount |
| `pcls.percentage` | decimal | No | PCLS percentage of fund |
| `lifeCycle` | object | No | Lifecycle stage (typically "In Payment") |
| `isEnhanced` | boolean | No | Enhanced/impaired life annuity |
| `enhancementFactors` | array | No | Health factors (smoking, medical conditions) |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | Creation timestamp |
| `updatedAt` | datetime | Yes (response only) | Update timestamp |

**Total Properties:** 27 properties (including nested)

### 27.4 Contract Schema

```json
{
  "id": 201,
  "href": "/api/v2/factfinds/679/pensions/annuity/201",
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123"
  },
  "owners": [
    {
      "id": 8496,
      "name": "John Smith"
    }
  ],
  "provider": {
    "id": 456,
    "name": "Aviva",
    "code": "AVIVA"
  },
  "annuityType": "Lifetime",
  "policyNumber": "ANN-123456",
  "purchasePrice": {
    "amount": 200000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "purchaseDate": "2025-05-15",
  "incomeType": "RPI_Linked",
  "escalationRate": null,
  "initialAnnualIncome": {
    "amount": 9500.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "currentAnnualIncome": {
    "amount": 9738.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "paymentFrequency": "Monthly",
  "isJointLife": true,
  "jointLifePercentage": 66.67,
  "guaranteePeriod": 10,
  "valueProtection": true,
  "pcls": {
    "amount": {
      "amount": 50000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "percentage": 25.0
  },
  "lifeCycle": {
    "id": 47,
    "name": "In Payment"
  },
  "isEnhanced": false,
  "enhancementFactors": [],
  "notes": "RPI-linked with 10-year guarantee and 66.67% spouse continuation",
  "createdAt": "2025-05-15T10:00:00Z",
  "updatedAt": "2026-02-16T14:30:00Z"
}
```

### 27.5 Complete Examples

See contract schema above for comprehensive example.

### 27.6 Business Rules

1. **Annuity Purchase:** Typically purchased from pension fund at retirement
2. **PCLS:** Usually 25% of fund taken as tax-free lump sum before annuity purchase
3. **Income Types:**
   - Level: Fixed income for life
   - Escalating: Fixed % increase (3%, 5% per year)
   - RPI/CPI: Increases with inflation (may be capped)
4. **Joint Life:** Continue at reduced % to spouse on death (50%, 66.67%, 100%)
5. **Guarantee Period:** Payments guaranteed for period even if death occurs
6. **Value Protection:** Return of remaining capital on death (reduces income)
7. **Enhanced Annuities:** Higher income for health/lifestyle factors (10-40% uplift)

### 27.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `annuityType` | enum | Filter by type | `annuityType=Lifetime` |
| `isJointLife` | boolean | Filter joint-life | `isJointLife=true` |
| `incomeType` | enum | Filter by income type | `incomeType=RPI_Linked` |

### 27.8 HTTP Status Codes

Standard HTTP status codes (200, 201, 204, 400, 401, 403, 404, 422)

### 27.9 Regulatory Compliance

**FCA COBS 19.3 (Pension Transfers):**
- Annuity purchase vs drawdown comparison required
- Open market option must be explained
- Enhanced annuity eligibility assessment required

**Pension Flexibility (2015):**
- Freedom to choose drawdown over annuity
- Annuity purchase irreversible
- Alternative income options must be explained

### 27.10 Related APIs

- [Personal Pension API](#27-personal-pension-api) - Source pension
- [Client Management API](#5-client-management-api) - Annuity owner
- [Net Worth API](#23-net-worth-api) - Pension assets

---

## 28. Personal Pension API

### 28.1 Overview

**Purpose:** The Personal Pension API manages Defined Contribution (DC) pensions including personal pensions, SIPPs, and drawdown arrangements with detailed fund holdings, crystallisation tracking, GAD compliance, PCLS management, and death benefits.

**Base Path:** `/api/v2/factfinds/{factfindId}/pensions/personalpension`

**Key Features:**
- Personal Pension, SIPP, Stakeholder support
- Capped and Flexi-Access Drawdown
- Crystallisation status tracking (uncrystallised, crystallised, in drawdown)
- PCLS (25% tax-free lump sum) management
- Fund holdings with ISIN/SEDOL
- Contribution tracking (employee, employer, relief at source)
- GAD maximum income limits (legacy capped drawdown)
- Death benefits (lump sum, drawdown pension)
- Lifetime Allowance usage tracking

### 28.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/pensions/personalpension` | List all personal pensions | N/A | 200 OK - PersonalPension[] |
| POST | `/api/v2/factfinds/{factfindId}/pensions/personalpension` | Create personal pension | PersonalPensionRequest | 201 Created - PersonalPension |
| GET | `/api/v2/factfinds/{factfindId}/pensions/personalpension/{pensionId}` | Get pension by ID | N/A | 200 OK - PersonalPension |
| PATCH | `/api/v2/factfinds/{factfindId}/pensions/personalpension/{pensionId}` | Update pension | PersonalPensionPatch | 200 OK - PersonalPension |
| DELETE | `/api/v2/factfinds/{factfindId}/pensions/personalpension/{pensionId}` | Delete pension | N/A | 204 No Content |

**Total Operations:** 5 endpoints

### 28.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique identifier |
| `href` | string | Yes (response only) | Resource URL |
| `factfind` | object | Yes (response only) | FactFind reference |
| `owners` | array | Yes | Pension owner(s) |
| `provider` | object | Yes | Pension provider/platform |
| `pensionType` | enum | Yes | PersonalPension, SIPP, Stakeholder, GroupPersonalPension |
| `productName` | string | Yes | Pension product name |
| `policyNumber` | string | No | Policy/account number |
| `currentValue` | money | Yes | Current pension value |
| `valuationDate` | date | Yes | Valuation date |
| `startedOn` | date | No | Pension start date |
| `retirementAge` | integer | No | Target retirement age |
| `crystallisationStatus` | enum | Yes | Uncrystallised, PartiallyCrystallised, FullyCrystallised, InDrawdown |
| `pensionArrangement` | enum | No | Accumulation, CappedDrawdown, FlexiAccessDrawdown |
| `pcls` | object | No | PCLS details |
| `pcls.value` | money | No | PCLS amount taken |
| `pcls.paidBy` | string | No | OriginatingScheme, ReceivingScheme |
| `pcls.datePaid` | date | No | Date PCLS paid |
| `gadMaximumIncomeLimitAnnual` | money | No | GAD maximum (capped drawdown only) |
| `gadCalculatedOn` | date | No | GAD calculation date |
| `lifetimeAllowanceUsed` | decimal | No | LTA used % (abolished April 2024) |
| `isInTrust` | boolean | No | Whether in trust |
| `contributions` | array | No | Contribution history |
| `fundHoldings` | array | No | Fund portfolio |
| `deathBenefits` | object | No | Death benefit provisions |
| `deathBenefits.nominatedBeneficiaries` | array | No | Nominated beneficiaries |
| `deathBenefits.expressionOfWish` | string | No | Expression of wish details |
| `charges` | object | No | Charges and fees |
| `guaranteedAnnuityRate` | decimal | No | Protected annuity rate |
| `hasLifestylingStrategy` | boolean | No | Auto de-risking as retirement approaches |
| `lifestylingStrategyDetails` | string | No | Lifestyling details |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | Creation timestamp |
| `updatedAt` | datetime | Yes (response only) | Update timestamp |

**Total Properties:** 50+ properties (including nested)

### 28.4 Contract Schema

```json
{
  "id": 301,
  "href": "/api/v2/factfinds/679/pensions/personalpension/301",
  "factfind": {
    "id": 679,
    "factFindNumber": "FF-2025-00123"
  },
  "owners": [
    {
      "id": 8496,
      "name": "John Smith",
      "ownershipPercentage": 100.0
    }
  ],
  "provider": {
    "id": 456,
    "name": "Vanguard",
    "code": "VANGUARD"
  },
  "pensionType": "SIPP",
  "productName": "Vanguard SIPP",
  "policyNumber": "SIPP-123456",
  "currentValue": {
    "amount": 175000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "valuationDate": "2026-02-16",
  "startedOn": "2015-04-06",
  "retirementAge": 65,
  "crystallisationStatus": "Uncrystallised",
  "pensionArrangement": "Accumulation",
  "pcls": null,
  "lifetimeAllowanceUsed": null,
  "isInTrust": false,
  "contributions": [
    {
      "type": "Regular",
      "amount": {
        "amount": 500.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "frequency": "Monthly",
      "contributorType": "Self",
      "startDate": "2015-04-06",
      "endDate": null,
      "netAmount": {
        "amount": 500.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "taxReliefAmount": {
        "amount": 125.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "grossAmount": {
        "amount": 625.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    }
  ],
  "fundHoldings": [
    {
      "fundName": "Vanguard Target Retirement 2035 Fund",
      "isin": "GB00BG3T3G97",
      "sedol": "BG3T3G9",
      "units": 17856.34,
      "pricePerUnit": {
        "amount": 9.80,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "currentValue": {
        "amount": 175000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "percentage": 100.0
    }
  ],
  "deathBenefits": {
    "nominatedBeneficiaries": [
      {
        "name": "Sarah Smith",
        "relationship": "Spouse",
        "percentage": 100.0
      }
    ],
    "expressionOfWish": "100% to spouse Sarah Smith"
  },
  "charges": {
    "annualManagementCharge": 0.15,
    "platformFee": 0.25,
    "totalExpenseRatio": 0.40
  },
  "hasLifestylingStrategy": true,
  "lifestylingStrategyDetails": "Auto de-risk starting 10 years before retirement",
  "notes": "Client contributing maximum to take advantage of employer match",
  "createdAt": "2015-04-06T10:00:00Z",
  "updatedAt": "2026-02-16T14:30:00Z"
}
```

### 28.5 Complete Examples

See contract schema above for comprehensive example.

### 28.6 Business Rules

1. **Annual Allowance:** £60,000 per tax year (2024/25)
2. **Tax Relief:** Basic rate (20%) relief at source, higher rate claim via tax return
3. **PCLS:** 25% of fund tax-free (subject to LSA from April 2024)
4. **Lifetime Allowance:** Abolished April 2024, replaced with Lump Sum Allowances
5. **Crystallisation:** Taking benefits triggers crystallisation event
6. **Money Purchase Annual Allowance (MPAA):** £10,000 if flexibly accessed
7. **Flexi-Access Drawdown:** Unlimited withdrawals (but triggers MPAA)
8. **Capped Drawdown:** Legacy arrangement, GAD limits apply (up to 150% of GAD)
9. **Death Benefits:**
   - Before 75: Tax-free
   - After 75: Taxed at beneficiary's marginal rate

### 28.7 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `pensionType` | enum | Filter by type | `pensionType=SIPP` |
| `crystallisationStatus` | enum | Filter by status | `crystallisationStatus=Uncrystallised` |
| `pensionArrangement` | enum | Filter by arrangement | `pensionArrangement=FlexiAccessDrawdown` |

### 28.8 HTTP Status Codes

Standard HTTP status codes (200, 201, 204, 400, 401, 403, 404, 422)

### 28.9 Regulatory Compliance

**Finance Act 2004:**
- Annual Allowance rules
- Lifetime Allowance (abolished April 2024)
- Tax-free lump sum rules
- Registered pension scheme requirements

**Pension Flexibility Act 2015:**
- Freedom to access from age 55 (rising to 57 in 2028)
- Flexi-access drawdown introduced
- 25% tax-free, remainder taxable

**FCA COBS 19.5 (Pension Transfer and Opt-out):**
- Transfer advice requirements
- Appropriate pension transfer analysis
- Retirement income comparison

### 28.10 Related APIs

- [Client Management API](#5-client-management-api) - Pension owner
- [Employment API](#18-employment-api) - Workplace pensions
- [Net Worth API](#23-net-worth-api) - Pension assets
- [Annuity API](#26-annuity-API) - Annuity purchase option

---
## 29. State Pension API

### 29.1 Overview

**Purpose:** The State Pension API manages UK State Pension entitlements including old (pre-2016) and new (post-2016) State Pension systems, Additional Pension (SERPS/S2P), Pension Credit, spouse inheritance, and BR19 projections.

**Base Path:** `/api/v2/factfinds/{factfindId}/pensions/statepension`

**Key Features:**
- Old State Pension (pre-April 2016) and New State Pension (post-April 2016)
- Basic State Pension, Additional Pension (SERPS/S2P)
- Contracting-out tracking and GMP
- State Pension age calculation
- BR19 forecast integration
- Pension Credit eligibility
- Triple Lock protection tracking
- Spouse/civil partner inheritance

### 29.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/pensions/statepension` | List all state pensions | N/A | 200 OK - StatePension[] |
| POST | `/api/v2/factfinds/{factfindId}/pensions/statepension` | Create state pension | StatePensionRequest | 201 Created - StatePension |
| GET | `/api/v2/factfinds/{factfindId}/pensions/statepension/{pensionId}` | Get state pension by ID | N/A | 200 OK - StatePension |
| PATCH | `/api/v2/factfinds/{factfindId}/pensions/statepension/{pensionId}` | Update state pension | StatePensionPatch | 200 OK - StatePension |
| DELETE | `/api/v2/factfinds/{factfindId}/pensions/statepension/{pensionId}` | Delete state pension | N/A | 204 No Content |

### 29.3 Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | Yes (response only) | Unique identifier |
| `owner` | object | Yes | State Pension recipient |
| `statePensionAge` | integer | Yes | State Pension age (66, 67, 68) |
| `statePensionType` | enum | Yes | Old (pre-2016), New (post-2016) |
| `basicStatePension` | money | No | Basic amount (old system) |
| `additionalPension` | money | No | SERPS/S2P (old system) |
| `graduatedRetirementBenefit` | money | No | GRB (pre-1975 contributions) |
| `newStatePension` | money | No | New State Pension amount |
| `qualifyingYears` | integer | Yes | National Insurance qualifying years |
| `yearsNeededForFull` | integer | Yes | Years needed for full pension (35) |
| `isContractedOut` | boolean | No | Was contracted-out (reduced State Pension) |
| `contractedOutDeduction` | money | No | Deduction due to contracting-out |
| `statePensionForecast` | object | No | BR19 forecast details |
| `statePensionForecast.weeklyAmount` | money | No | Forecast weekly amount |
| `statePensionForecast.annualAmount` | money | No | Forecast annual amount |
| `statePensionForecast.forecastDate` | date | No | When forecast obtained (BR19) |
| `isEligibleForPensionCredit` | boolean | No | Pension Credit eligibility |
| `pensionCredit` | object | No | Pension Credit details |
| `spouseInheritance` | object | No | Spouse entitlement on death |
| `deferralOption` | object | No | Deferral details if applicable |
| `notes` | string | No | Additional notes |
| `createdAt` | datetime | Yes (response only) | Creation timestamp |
| `updatedAt` | datetime | Yes (response only) | Update timestamp |

### 29.4 Contract Schema

```json
{
  "id": 401,
  "owner": {
    "id": 8496,
    "name": "John Smith"
  },
  "statePensionAge": 67,
  "statePensionType": "New",
  "newStatePension": {
    "amount": 11502.40,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "qualifyingYears": 35,
  "yearsNeededForFull": 35,
  "isContractedOut": false,
  "statePensionForecast": {
    "weeklyAmount": {
      "amount": 221.20,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "annualAmount": {
      "amount": 11502.40,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "forecastDate": "2026-01-15"
  },
  "isEligibleForPensionCredit": false,
  "notes": "Full New State Pension entitlement. BR19 forecast obtained Jan 2026.",
  "createdAt": "2026-01-15T10:00:00Z",
  "updatedAt": "2026-02-16T14:30:00Z"
}
```

### 29.5 Business Rules

1. **New State Pension:** £221.20 per week / £11,502.40 per year (2024/25)
2. **Qualifying Years:** 35 years for full New State Pension, minimum 10 years
3. **State Pension Age:** Currently 66, rising to 67 by 2028, 68 by 2046
4. **Triple Lock:** Increase by highest of earnings, inflation (CPI), or 2.5%
5. **Contracting-Out:** Reduces State Pension (pre-2016 system)
6. **Pension Credit:** Tops up income to £218.15/week (single, 2024/25)
7. **Spouse Inheritance:** Old system only, not new system
8. **Deferral:** Can defer to get higher amount (1% increase per 9 weeks deferred)

### 29.6 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `statePensionType` | enum | Filter by type | `statePensionType=New` |
| `isContractedOut` | boolean | Filter contracted-out | `isContractedOut=true` |

### 29.7 HTTP Status Codes

Standard HTTP status codes (200, 201, 204, 400, 401, 403, 404, 422)

### 29.8 Regulatory Compliance

**Pensions Act 2014:**
- New State Pension from April 2016
- Single-tier pension system
- 35 qualifying years requirement

**Triple Lock:**
- Annual increase guarantee
- Highest of: earnings growth, CPI inflation, 2.5%

### 29.9 Related APIs

- [Client Management API](#5-client-management-api) - Pension recipient
- [Personal Pension API](#27-personal-pension-api) - Private pension provision
- [Net Worth API](#23-net-worth-api) - Pension income planning

---

## 30. Mortgage API

### 30.1 Overview

**Purpose:** The Mortgage API manages comprehensive mortgage arrangements including residential mortgages, buy-to-let, lifetime mortgages, and second charge mortgages with automatic LTV calculations, early repayment charges, and special features tracking.

**Base Path:** `/api/v2/factfinds/{factfindId}/mortgages`

**Key Features:**
- Fixed, Variable, Tracker, Discount, Capped rates
- Repayment, Interest-Only, Part-and-Part structures
- LTV calculation and tracking
- Early Repayment Charge (ERC) management
- Offset mortgage features
- Overpayment tracking and allowances
- Payment holiday and borrow-back features
- Portability options

### 30.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/mortgages` | List all mortgages | N/A | 200 OK - Mortgage[] |
| POST | `/api/v2/factfinds/{factfindId}/mortgages` | Create mortgage | MortgageRequest | 201 Created - Mortgage |
| GET | `/api/v2/factfinds/{factfindId}/mortgages/{mortgageId}` | Get mortgage by ID | N/A | 200 OK - Mortgage |
| PATCH | `/api/v2/factfinds/{factfindId}/mortgages/{mortgageId}` | Update mortgage | MortgagePatch | 200 OK - Mortgage |
| DELETE | `/api/v2/factfinds/{factfindId}/mortgages/{mortgageId}` | Delete mortgage | N/A | 204 No Content |

### 30.3 Resource Properties (30 core properties - see Contract Schema for full structure)

### 30.4 Contract Schema

```json
{
  "id": 501,
  "factfind": {
    "id": 679
  },
  "owners": [
    {
      "clientId": 8496,
      "clientName": "John Smith",
      "ownershipType": "Joint Tenants",
      "percentage": 50.0
    },
    {
      "clientId": 8497,
      "clientName": "Sarah Smith",
      "ownershipType": "Joint Tenants",
      "percentage": 50.0
    }
  ],
  "lenderName": "HSBC UK",
  "productType": "Residential",
  "productName": "5 Year Fixed Rate Mortgage",
  "accountNumber": "MORT-12345678",
  "property": {
    "id": 1234,
    "href": "/api/v2/factfinds/679/assets/1234",
    "currentValue": {
      "amount": 450000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "loanAmounts": {
    "originalLoanAmount": {
      "amount": 360000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "currentBalance": {
      "amount": 340000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "originalLTV": 80.0,
    "currentLTV": 75.56
  },
  "interestTerms": {
    "rateType": "Fixed",
    "interestRate": 4.5,
    "annualPercentageRate": 4.7,
    "initialTermYears": 5,
    "initialRatePeriodEndsOn": "2029-03-31",
    "remainingTermYears": 22,
    "remainingTermMonths": 264
  },
  "repaymentStructure": {
    "repaymentType": "Repayment",
    "monthlyPayment": {
      "amount": 1895.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "principalPayment": {
      "amount": 620.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "interestPayment": {
      "amount": 1275.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "overpaymentsMade": {
      "amount": 20000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "overpaymentAllowance": "10% per annum without penalty"
  },
  "keyDates": {
    "applicationDate": "2024-01-15",
    "offerDate": "2024-02-01",
    "completionDate": "2024-03-31",
    "maturityDate": "2046-03-31",
    "initialRateEndsOn": "2029-03-31",
    "nextReviewDate": "2028-12-31"
  },
  "redemptionTerms": {
    "earlyRepaymentCharge": {
      "amount": 13600.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "ercAppliesUntil": "2029-03-31",
    "ercPercentage": 4.0,
    "overpaymentLimit": 10.0,
    "portabilityAvailable": true
  },
  "linkedArrangements": [
    {
      "arrangementType": "Life Assurance",
      "arrangementId": 601,
      "policyNumber": "LIFE-789",
      "provider": "Legal & General",
      "coverAmount": {
        "amount": 340000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    }
  ],
  "notes": "Client planning to overpay £500/month. Review remortgage options 6 months before fixed rate ends.",
  "createdAt": "2024-03-31T10:00:00Z",
  "updatedAt": "2026-02-16T14:30:00Z"
}
```

### 30.5 Business Rules

1. **LTV Calculation:** `LTV = (Current Balance / Property Value) × 100%`
2. **Maximum LTV:** Typically 95% for first-time buyers, 90% standard, 75% BTL
3. **ERC:** Usually 1-5% of balance, reduces over time (5%, 4%, 3%, 2%, 1%)
4. **Overpayment Allowance:** Typically 10% per year without penalty
5. **Stress Testing:** Must afford at current rate + 3% increase
6. **Portability:** Ability to transfer mortgage to new property
7. **Repayment Types:**
   - Repayment (Capital & Interest): Pays off loan over term
   - Interest-Only: Capital due at end (requires repayment vehicle)
   - Part-and-Part: Combination of both

### 30.6 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `productType` | enum | Filter by type | `productType=BTL` |
| `rateType` | enum | Filter by rate type | `rateType=Fixed` |
| `repaymentType` | enum | Filter by repayment | `repaymentType=Repayment` |

### 30.7 HTTP Status Codes

Standard HTTP status codes (200, 201, 204, 400, 401, 403, 404, 422)

### 30.8 Regulatory Compliance

**FCA MCOB (Mortgage Conduct of Business):**
- Affordability assessment mandatory
- Stress testing at current rate + 3%
- Clear disclosure of total cost
- APR calculations required

**MMR (Mortgage Market Review) 2014:**
- Comprehensive affordability assessment
- Income and expenditure verification
- Interest-only mortgages: credible repayment strategy required

### 30.9 Related APIs

- [Asset API](#22-asset-api) - Linked property
- [Affordability API](#21-affordability-api) - Affordability assessment
- [Personal Protection API](#30-personal-protection-api) - Linked life cover

---

## 31. Personal Protection API

### 31.1 Overview

**Purpose:** The Personal Protection API manages life assurance, critical illness, income protection, and expense cover policies with multi-cover support, premium structures, trust arrangements, and commission tracking.

**Base Path:** `/api/v2/factfinds/{factfindId}/protections`

**Key Features:**
- Life Cover (term, whole-of-life, family income benefit)
- Critical Illness Cover (standalone or accelerated)
- Income Protection (long-term income replacement)
- Expense Cover (mortgage/bill protection)
- Severity-based cover (partial/total permanent disability)
- Premium structures (Stepped, Level, Hybrid)
- Trust arrangements for IHT planning
- Indexation (RPI, fixed percentage)

### 31.2 Operations

| Method | Endpoint | Description | Request Body | Success Response |
|--------|----------|-------------|--------------|------------------|
| GET | `/api/v2/factfinds/{factfindId}/protections` | List all protections | N/A | 200 OK - PersonalProtection[] |
| POST | `/api/v2/factfinds/{factfindId}/protections` | Create protection | PersonalProtectionRequest | 201 Created - PersonalProtection |
| GET | `/api/v2/factfinds/{factfindId}/protections/{protectionId}` | Get protection by ID | N/A | 200 OK - PersonalProtection |
| PATCH | `/api/v2/factfinds/{factfindId}/protections/{protectionId}` | Update protection | PersonalProtectionPatch | 200 OK - PersonalProtection |
| DELETE | `/api/v2/factfinds/{factfindId}/protections/{protectionId}` | Delete protection | N/A | 204 No Content |

### 31.3 Resource Properties (38 core properties - see Contract Schema)

### 31.4 Contract Schema

```json
{
  "id": 601,
  "factfind": {
    "id": 679
  },
  "owners": [
    {
      "id": 8496,
      "name": "John Smith"
    }
  ],
  "provider": {
    "id": 789,
    "name": "Legal & General",
    "code": "L&G"
  },
  "protectionType": {
    "id": 101,
    "name": "Life and Critical Illness Cover"
  },
  "sumAssured": {
    "amount": 500000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "premiums": [
    {
      "startsOn": "2024-04-01",
      "stopsOn": "2049-04-01",
      "value": {
        "amount": 85.50,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "frequency": "Monthly",
      "type": "Regular",
      "contributorType": "Self",
      "escalation": {
        "type": "RPI",
        "percentage": 0.0
      }
    }
  ],
  "lifeCover": {
    "term": "P25Y",
    "sumAssured": {
      "amount": 500000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "premiumStructure": "Level",
    "paymentBasis": "FirstDeath",
    "untilAge": 70
  },
  "criticalIllnessCover": {
    "premiumStructure": "Level",
    "amount": {
      "amount": 500000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "term": "P25Y",
    "untilAge": 70
  },
  "indexType": "RPI",
  "inTrust": true,
  "inTrustToWhom": "Discretionary trust for benefit of spouse and children",
  "benefitOptions": [
    "Convertible",
    "Waiver of Premium on CI Claim"
  ],
  "isRated": false,
  "isPremiumWaiverWoc": true,
  "benefitSummary": "£500k life and critical illness on 25-year term. Level premiums. In discretionary trust.",
  "exclusionNotes": "Standard exclusions apply. Self-inflicted injury and war risks excluded.",
  "protectionPayoutType": "Agreed",
  "notes": "Policy written in trust to avoid IHT. Review annually.",
  "createdAt": "2024-04-01T10:00:00Z",
  "updatedAt": "2026-02-16T14:30:00Z"
}
```

### 31.5 Business Rules

1. **Life Cover:** Pays lump sum on death
2. **Critical Illness:** Pays on diagnosis of specified conditions (cancer, heart attack, stroke, etc.)
3. **Income Protection:** Pays monthly income if unable to work (typically 50-70% of earnings)
4. **Trust Arrangements:**
   - Keeps proceeds outside estate for IHT
   - Speeds up payment (no probate)
   - Protects from creditors
5. **Premium Structures:**
   - Level: Fixed premium for term
   - Stepped: Increases with age
   - Hybrid: Level initially, then stepped
6. **Indexation:** Annual benefit increase (RPI, CPI, fixed %)
7. **Underwriting:** Medical underwriting, premium loadings for health conditions

### 31.6 Query Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `coverType` | string | Filter by cover type | `coverType=Life` |
| `inTrust` | boolean | Filter trust policies | `inTrust=true` |
| `provider` | string | Filter by provider | `provider=L&G` |

### 31.7 HTTP Status Codes

Standard HTTP status codes (200, 201, 204, 400, 401, 403, 404, 422)

### 31.8 Regulatory Compliance

**FCA ICOBS (Insurance Conduct of Business):**
- Demands and needs statement required
- Suitability explanation for advised sales
- Clear disclosure of benefits and exclusions

**FCA RMAR (Retail Mediation Activities Return):**
- Commission disclosure requirements
- Product sales reporting

### 31.9 Related APIs

- [Client Management API](#5-client-management-api) - Policy owners
- [Mortgage API](#29-mortgage-api) - Linked life cover
- [Dependant API](#10-dependant-api) - Protection needs

---

## 32. Objectives API

### 32.1 Overview

**Purpose:** The Objectives API manages client financial goals and objectives across multiple domains (investment, pension, protection, mortgage, budget, estate-planning) with priority ranking, target dates, and needs analysis.

**Base Path:** `/api/v2/factfinds/{factfindId}/objectives`

**Key Features:**
- 6 objective types (investment, pension, protection, mortgage, budget, estate-planning)
- Priority ranking (High, Medium, Low)
- Target amount and date tracking
- Progress monitoring
- Needs analysis sub-resource
- Goal dependencies

### 32.2 Operations (26 total)

**Base Operations (5):**
- GET `/api/v2/factfinds/{factfindId}/objectives` - List all
- POST `/api/v2/factfinds/{factfindId}/objectives` - Create
- GET `/api/v2/factfinds/{factfindId}/objectives/{id}` - Get by ID
- PATCH `/api/v2/factfinds/{factfindId}/objectives/{id}` - Update
- DELETE `/api/v2/factfinds/{factfindId}/objectives/{id}` - Delete

**Type-Specific Operations (6 × 3 = 18):**
- Each type (investment, pension, protection, mortgage, budget, estate-planning) has:
  - GET by type, POST by type, GET specific

**Needs Sub-resource (3):**
- GET needs, POST needs, DELETE needs

### 32.3 Contract Schema

```json
{
  "id": 701,
  "client": {
    "id": 8496,
    "name": "John Smith"
  },
  "objectiveType": "Retirement",
  "goalName": "Comfortable retirement at age 65",
  "description": "Build sufficient pension pot to support £40k annual income in retirement",
  "priority": "High",
  "targetAmount": {
    "amount": 500000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "targetDate": "2045-05-15",
  "currentSavings": {
    "amount": 125000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "monthlyContribution": {
    "amount": 500.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "yearsToGoal": 19,
  "isAchievable": false,
  "projectedShortfall": {
    "amount": 150000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "status": "InProgress",
  "notes": "May need to increase contributions or adjust target date",
  "createdAt": "2026-02-16T10:00:00Z",
  "updatedAt": "2026-02-16T15:45:00Z"
}
```

### 32.4 Business Rules

1. **Priority:** High, Medium, Low (affects recommendation order)
2. **Status:** NotStarted, InProgress, Achieved, Abandoned
3. **Achievability:** Calculated based on current savings, contributions, growth assumptions
4. **Target Date:** Must be in future
5. **Dependencies:** Some goals may depend on others (e.g., mortgage payoff before retirement)

### 32.5 Related APIs

All planning APIs feed into objectives

---

## 33. ATR Assessment API

### 33.1 Overview

**Purpose:** The ATR (Attitude to Risk) Assessment API manages comprehensive risk profiling questionnaires with 15 core questions, risk score calculation, capacity for loss assessment, and historical assessment tracking (Risk Replay).

**Base Path:** `/api/v2/factfinds/{factfindId}/clients/{clientId}/atr-assessment`

**Key Features:**
- 15 standardized ATR questions
- Risk profile generation (1-10 scale: Defensive to Adventurous)
- Capacity for loss evaluation
- Volatility comfort assessment
- Historical assessments (Risk Replay)
- Risk profile comparison over time
- Profile selection for investments

### 33.2 Operations (6)

- GET current assessment
- POST create assessment
- GET assessment history
- POST calculate risk profile
- GET compare assessments
- PATCH update profile selection

### 33.3 Contract Schema

```json
{
  "id": 801,
  "client": {
    "id": 8496,
    "name": "John Smith"
  },
  "assessmentDate": "2026-02-16",
  "attitudeToRiskScore": 6,
  "attitudeToRiskRating": "Balanced",
  "capacityForLossScore": 7,
  "capacityForLossRating": "Medium",
  "overallRiskRating": "Balanced",
  "comfortableWithVolatility": true,
  "hasInvestedBefore": true,
  "understandsRisk": true,
  "wouldAcceptLosses": false,
  "yearsToRetirement": 19,
  "questionsAndAnswers": [
    {
      "questionId": 1,
      "question": "What best describes your investment experience?",
      "answer": "I have invested in stocks and shares for over 5 years",
      "score": 3
    }
  ],
  "validUntil": "2027-02-16",
  "isValid": true,
  "reviewDate": "2027-02-16",
  "notes": "Client understands market volatility but nervous about potential losses",
  "createdAt": "2026-02-16T10:00:00Z"
}
```

### 33.4 Business Rules

1. **Review Period:** ATR assessments valid for 12 months
2. **Risk Ratings:** Defensive (1-2), Cautious (3-4), Balanced (5-6), Adventurous (7-8), Aggressive (9-10)
3. **Capacity for Loss:** Separate from attitude - measures ability to absorb losses
4. **Investment Suitability:** Risk profile must match investment risk rating
5. **Regulatory Review:** Must be reviewed annually or on significant life event

### 33.5 Related APIs

- [Financial Profile API](#15-financial-profile-api) - Investment experience
- [Investment API](#24-investment-api) - Risk-rated investments

---

## 34. Reference Data API

### 34.1 Overview

**Purpose:** The Reference Data API provides enumeration values, lookup data, and reference entities for dropdown lists, validation, and data consistency across the application.

**Base Path:** `/api/v2/reference`

**Key Features:**
- Static enumerations (genders, titles, marital statuses)
- Dynamic lookups (countries, currencies, frequencies)
- Reference entities (providers, advisers)
- Version tracking for data changes

### 34.2 Operations (24 total)

**Enumerations (14):**
- GET /genders, /titles, /marital-statuses
- GET /client-types, /employment-statuses, /income-types
- GET /expenditure-categories, /asset-types, /liability-types
- GET /protection-types, /risk-ratings, /objective-types
- GET /lifecycle-stages, /agency-statuses

**Lookups (5):**
- GET /countries, /currencies, /frequencies
- GET /soc-codes (Standard Occupational Classification)
- GET /financial-institutions

**Reference Entities (5):**
- GET/POST providers, GET/POST/PATCH/DELETE provider
- Similar for advisers

### 34.3 Example Responses

**GET /api/v2/reference/genders:**
```json
{
  "values": [
    { "code": "M", "display": "Male" },
    { "code": "F", "display": "Female" },
    { "code": "O", "display": "Other" },
    { "code": "X", "display": "Prefer not to say" }
  ]
}
```

**GET /api/v2/reference/currencies:**
```json
{
  "values": [
    {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£",
      "numericCode": 826,
      "minorUnits": 2
    },
    {
      "code": "EUR",
      "display": "Euro",
      "symbol": "€",
      "numericCode": 978,
      "minorUnits": 2
    },
    {
      "code": "USD",
      "display": "US Dollar",
      "symbol": "$",
      "numericCode": 840,
      "minorUnits": 2
    }
  ]
}
```

### 34.4 Business Rules

1. **ISO Standards:** Use ISO codes where applicable (ISO 3166 countries, ISO 4217 currencies)
2. **Versioning:** Reference data changes tracked with version numbers
3. **Caching:** Client-side caching recommended (data changes infrequently)
4. **Deprecation:** Deprecated values retained for backward compatibility

---

## Appendix A: Complete Endpoint Catalog

### API Endpoint Summary by Context

**Total Endpoints: 263 across 33 APIs**

#### FactFind Root (11 endpoints)
- FactFind CRUD operations
- Aggregated views (complete, net-worth, current-position, financial-health, cash-flow, asset-allocation)

#### Client Onboarding & KYC (105 endpoints)
- Client (5), Address (5), Contact (5), Professional Contact (5)
- Relationship (5), Dependant (5), Vulnerability (5)
- Estate Planning (7), Identity Verification (2)
- Credit History (9), Financial Profile (2), Marketing Preferences (2), DPA Agreement (4)

#### Circumstances (26 endpoints)
- Employment (5), Income (5), Expenditure (5)
- Affordability (3), Employment History (8)

#### Assets & Liabilities (10 endpoints)
- Asset (5), Net Worth (5)

#### Plans & Investments (35 endpoints)
- Investment (5), Final Salary Pension (5), Annuity (5)
- Personal Pension (5), State Pension (5)
- Mortgage (5), Personal Protection (5)

#### Goals & Risk (32 endpoints)
- Objectives (26), ATR Assessment (6)

#### Reference Data (24 endpoints)
- Enumerations (14), Lookups (5), Reference entities (5)

#### Other Contexts (20 endpoints)
- Beneficiary, Contribution, Custom Question, DPA Agreement, Note, etc.

---

## Appendix B: Common Value Types

### Money Type
```json
{
  "amount": 150000.00,
  "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
}
```

### Reference Link Type
```json
{
  "id": 8496,
  "href": "/api/v2/factfinds/679/clients/8496",
  "name": "John Smith",
  "type": "Person"
}
```

### Date/DateTime Formats
- **Date:** ISO 8601 format `YYYY-MM-DD` (e.g., `2026-03-03`)
- **DateTime:** ISO 8601 format `YYYY-MM-DDTHH:mm:ssZ` (e.g., `2026-03-03T10:30:00Z`)
- **Always UTC:** All timestamps in UTC with Z suffix

### Duration Format (ISO 8601)
- **Years:** `P10Y` (10 years)
- **Months:** `P6M` (6 months)
- **Days:** `P90D` (90 days)
- **Combined:** `P10Y6M15D` (10 years, 6 months, 15 days)

### Address Type
```json
{
  "line1": "123 High Street",
  "line2": "Apartment 4B",
  "city": "London",
  "county": "Greater London",
  "postcode": "SW1A 1AA",
  "country": "GB"
}
```

### Contact Type
```json
{
  "type": "Email",
  "value": "john.smith@example.com",
  "isPrimary": true,
  "isPreferred": true,
  "isVerified": true
}
```

---

## Appendix C: HTTP Status Codes Reference

### Success Codes

| Code | Name | When Used | Response Body |
|------|------|-----------|---------------|
| 200 OK | Success | GET, PATCH, PUT successful | Resource representation |
| 201 Created | Resource created | POST successful | Created resource with Location header |
| 202 Accepted | Accepted for processing | Async operations | Status URL |
| 204 No Content | Success with no body | DELETE successful | Empty |

### Client Error Codes

| Code | Name | When Used | Response Body |
|------|------|-----------|---------------|
| 400 Bad Request | Invalid syntax | Malformed JSON, invalid data types | Error details |
| 401 Unauthorized | Authentication required | Missing/invalid token | Authentication challenge |
| 403 Forbidden | Insufficient permissions | Lacks required scope | Permission error |
| 404 Not Found | Resource not found | Invalid ID, deleted resource | Error message |
| 409 Conflict | Concurrency conflict | ETag mismatch, duplicate | Conflict details |
| 422 Unprocessable Entity | Validation failed | Business rule violation | Validation errors |
| 429 Too Many Requests | Rate limit exceeded | Too many requests | Retry-After header |

### Server Error Codes

| Code | Name | When Used | Response Body |
|------|------|-----------|---------------|
| 500 Internal Server Error | Unexpected error | System failure | Generic error |
| 502 Bad Gateway | Gateway error | Upstream service down | Error message |
| 503 Service Unavailable | Service down | Maintenance, overload | Retry-After header |

### Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "One or more validation errors occurred",
    "details": [
      {
        "field": "dateOfBirth",
        "message": "Date of birth must be in the past",
        "code": "INVALID_DATE"
      },
      {
        "field": "email",
        "message": "Email address is already in use",
        "code": "DUPLICATE_EMAIL"
      }
    ],
    "timestamp": "2026-03-03T10:30:00Z",
    "path": "/api/v2/factfinds/679/clients",
    "requestId": "req-123456"
  }
}
```

---

## Appendix D: Regulatory Compliance Matrix

### FCA Handbook Requirements Mapped to APIs

| Requirement | FCA Reference | Applicable APIs | Notes |
|-------------|---------------|-----------------|-------|
| Suitability Assessment | COBS 9 | Investment, Pension, Protection, Mortgage | Know Your Customer |
| Appropriateness Test | COBS 10 | Financial Profile, Investment | Execution-only sales |
| Client Categorization | COBS 3 | Client Management | Retail, Professional, Eligible Counterparty |
| Creditworthiness | MCOB 11 | Credit History, Affordability, Mortgage | Responsible lending |
| Affordability Assessment | MCOB 11 | Affordability, Income, Expenditure, Mortgage | Stress testing required |
| Pension Transfer Advice | COBS 19.1 | Final Salary Pension, Personal Pension | £30k+ transfers |
| Vulnerable Customers | PRIN 2A, FG21/1 | Vulnerability, Marketing Preferences | Consumer Duty |
| Data Protection | GDPR | All APIs | Consent, retention, erasure |
| Anti-Money Laundering | MLR 2017 | Identity Verification, Address, Credit History | KYC/CDD/EDD |
| Marketing Consent | PECR | Marketing Preferences, DPA Agreement | Explicit opt-in |

### GDPR Compliance Checklist

| Requirement | Implementation | APIs |
|-------------|----------------|------|
| Lawful Basis (Art 6) | Consent, Contract, Legal Obligation tracked | DPA Agreement |
| Data Minimization | Only essential fields required | All APIs |
| Right to Access (Art 15) | Export functionality | All APIs |
| Right to Erasure (Art 17) | DELETE operations with retention checks | All APIs |
| Right to Portability (Art 20) | JSON export format | All APIs |
| Consent Management (Art 7) | Version tracking, withdrawal | DPA Agreement |
| Retention Periods | 5-7 years (FCA requirement) | All APIs |
| Privacy by Design | Encryption, access controls | All APIs |

### MLR 2017 (KYC/AML) Requirements

| Requirement | Implementation | APIs |
|-------------|----------------|------|
| Customer Due Diligence | Identity and address verification | Identity Verification, Address |
| Identity Verification | Passport, driving licence, utility bills | Identity Verification |
| Address Verification | 3-year address history | Address |
| Source of Wealth | High-value client documentation | Client Management |
| Enhanced Due Diligence | PEPs, high-risk countries | Client Management, Identity Verification |
| Ongoing Monitoring | Regular reviews | All client APIs |
| Record Retention | 5 years after relationship ends | All APIs |

### Consumer Duty Obligations

| Obligation | Implementation | APIs |
|------------|----------------|------|
| Act in Good Faith | Fair treatment outcomes | All APIs |
| Avoid Foreseeable Harm | Vulnerability identification | Vulnerability |
| Enable and Support | Clear information, accessible | All APIs |
| Fair Value | Price vs benefits assessment | All product APIs |
| Vulnerable Customers | Matching service proposition | Vulnerability, Client Management |
| Monitoring Outcomes | Client outcome tracking | Objectives, Net Worth |

### PECR Marketing Compliance

| Requirement | Implementation | APIs |
|-------------|----------------|------|
| Explicit Opt-in | No pre-ticked boxes | Marketing Preferences |
| Channel-Specific Consent | Separate for email, phone, SMS, post | Marketing Preferences |
| Easy Opt-out | Simple withdrawal mechanism | Marketing Preferences |
| Consent Records | Timestamp, method, IP address | DPA Agreement |
| Regular Review | Annual consent refresh | Marketing Preferences |

### MiFID II Appropriateness/Suitability

| Requirement | Implementation | APIs |
|-------------|----------------|------|
| Appropriateness Test | Knowledge and experience assessment | Financial Profile |
| Suitability Report | Comprehensive recommendation | Investment, Pension |
| Client Categorization | Retail, Professional classification | Client Management |
| Best Execution | Product selection rationale | All product APIs |
| Ongoing Suitability | Annual reviews | All product APIs |

---

**END OF FACTFIND-API-DESIGN-V3.MD**

**Document Statistics:**
- **Sections:** 33 comprehensive API sections
- **Appendices:** 4 detailed reference appendices
- **Total Endpoints:** 263 REST API endpoints
- **Total Lines:** 11,000+ lines
- **Regulatory References:** FCA, GDPR, MLR 2017, Consumer Duty, PECR, MiFID II
- **Version:** 3.0 Final
- **Date:** March 2026
- **Status:** Production-Ready

This comprehensive API specification provides complete documentation for implementing a regulatory-compliant UK financial advice system with full contract schemas, business rules, and compliance mappings.
