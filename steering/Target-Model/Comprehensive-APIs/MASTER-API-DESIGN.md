# FactFind API Master Design Document

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**API Base URL:** `https://api.factfind.com`

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 2.0 | 2026-02-25 | System | Master API design with common standards |
| 1.0 | 2026-02-01 | System | Initial version |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Architecture Overview](#2-architecture-overview)
3. [API Standards](#3-api-standards)
4. [Authentication & Authorization](#4-authentication--authorization)
5. [Request/Response Standards](#5-requestresponse-standards)
6. [Error Handling](#6-error-handling)
7. [Security](#7-security)
8. [Performance Standards](#8-performance-standards)
9. [Testing Standards](#9-testing-standards)
10. [API Documentation Standards](#10-api-documentation-standards)
11. [Entity APIs by Domain](#11-entity-apis-by-domain)
12. [References](#12-references)

---

## 1. Introduction

### 1.1 Purpose

This master document defines common standards, conventions, and guidelines that apply to **all** entity APIs within the FactFind API system. It serves as the authoritative reference for shared API design principles, eliminating redundancy across individual entity API documents.

### 1.2 Scope

This document covers:
- Common API standards and conventions
- Authentication and authorization patterns
- Standard request/response formats
- Error handling standards
- Security requirements
- Performance standards
- Testing standards
- Links to individual entity API designs organized by domain

### 1.3 Audience

- API Developers
- Frontend Developers
- Solution Architects
- QA Engineers
- Technical Writers
- Product Managers

### 1.4 How to Use This Document

1. **For common standards:** Refer to this master document (Sections 1-10)
2. **For entity-specific details:** Navigate to individual entity API documents via Section 11
3. **Individual entity documents** contain only entity-specific information and reference this master for common standards

---

## 2. Architecture Overview

### 2.1 Domain-Driven Design

The FactFind API follows Domain-Driven Design (DDD) principles, organized into bounded contexts:

- **Client Management** - Client identity, profiles, relationships
- **Circumstances** - Employment, income, expenditure, affordability
- **Arrangements** - Investments, pensions, mortgages, protection
- **Assets & Liabilities** - Assets, Liaabilities, net worth tracking
- **Risk Profiling** - ATR assessments
- **FactFind Root** - Aggregate root for fact-finding sessions
- **Reference Data** - Enumerations, lookup values

### 2.2 RESTful Architecture

All APIs follow RESTful architectural principles:
- **Resource-oriented:** URLs represent resources (nouns, not verbs)
- **Hierarchical:** Parent-child relationships reflected in URL structure
- **Stateless:** Each request contains all necessary information
- **Standard HTTP methods:** GET, POST, PUT, PATCH, DELETE
- **Standard response codes:** HTTP status codes with semantic meaning
- **Versioned:** API version in URL path (`/api/v2/`)

### 2.3 Aggregate Roots

APIs are organized around three main aggregate roots:

**FactFind Aggregate**
```
/api/v2/factfinds/{factfindId}
```

**Client Aggregate**
```
/api/v2/factfinds/{factfindId}/clients/{clientId}
```

**Arrangement Aggregate**
```
/api/v2/factfinds/{factfindId}/arrangements/{arrangementId}
```

---

## 3. API Standards

### 3.1 HTTP Methods

Standard HTTP methods with consistent semantics:

| Method | Purpose | Idempotent | Safe | Response Code |
|--------|---------|------------|------|---------------|
| `GET` | Retrieve resource(s) | Yes | Yes | `200 OK` |
| `POST` | Create new resource | No | No | `201 Created` |
| `PUT` | Replace entire resource | Yes | No | `200 OK` |
| `PATCH` | Partial update resource | No | No | `200 OK` |
| `DELETE` | Remove resource | Yes | No | `204 No Content` |

### 3.2 URL Conventions

**Format:** `/api/v{version}/{resource-path}`

**Rules:**
- Lowercase with hyphens for word separation
- Plural nouns for collections: `/clients`, `/investments`
- Singular for singletons: `/financial-profile`, `/affordability`
- Resource IDs in path: `/clients/{clientId}`
- Query parameters for filtering: `?status=active&limit=50`

**Examples:**
```
GET    /api/v2/factfinds/{factfindId}/clients
POST   /api/v2/factfinds/{factfindId}/clients
GET    /api/v2/factfinds/{factfindId}/clients/{clientId}
PATCH  /api/v2/factfinds/{factfindId}/clients/{clientId}
DELETE /api/v2/factfinds/{factfindId}/clients/{clientId}
```

### 3.3 HTTP Response Codes

**Success Codes:**
- `200 OK` - Successful GET, PUT, PATCH request
- `201 Created` - Successful POST request
- `204 No Content` - Successful DELETE request

**Client Error Codes:**
- `400 Bad Request` - Invalid request format or validation error
- `401 Unauthorized` - Authentication required or failed
- `403 Forbidden` - Authenticated but insufficient permissions
- `404 Not Found` - Resource not found
- `409 Conflict` - Resource conflict (e.g., duplicate)
- `422 Unprocessable Entity` - Business rule violation

**Server Error Codes:**
- `500 Internal Server Error` - Unexpected server error
- `503 Service Unavailable` - Service temporarily unavailable

### 3.4 Content Types

**Request/Response:**
- Content-Type: `application/json`
- Accept: `application/json`
- Character encoding: UTF-8

### 3.5 API Versioning

**Version in URL path:** `/api/v2/`

**Current version:** v2.0

**Version changes:**
- Major version (v2, v3): Breaking changes
- Minor version (v2.1, v2.2): Backward-compatible additions
- Patch version: Bug fixes, no API changes

---

## 4. Authentication & Authorization

### 4.1 Authentication

**Method:** OAuth 2.0 with JWT Bearer Tokens

**Request Header:**
```http
Authorization: Bearer <jwt-token>
```

**Token Format:**
- Standard JWT (JSON Web Token)
- Signed with RS256
- Contains: user ID, roles, scopes, expiry

**Token Expiry:**
- Access token: 1 hour
- Refresh token: 30 days

### 4.2 Authorization

**Pattern:** Scope-based authorization

**Scope Format:** `{entity}:{action}`

**Standard Scopes:**
- `{entity}:read` - Read access (GET operations)
- `{entity}:write` - Create and update access (POST, PUT, PATCH)
- `{entity}:delete` - Delete access (DELETE operations)

**Examples:**
```
client:read
client:write
client:delete
investment:read
investment:write
```

**Wildcard Scopes:**
- `factfind:*` - All operations on all entities
- `client:*` - All operations on client entity
- `*:read` - Read access to all entities

### 4.3 Authorization Header

Every authenticated request must include:

```http
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

### 4.4 Unauthorized Responses

**401 Unauthorized** - Missing or invalid token:
```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Authentication required",
    "details": []
  }
}
```

**403 Forbidden** - Valid token but insufficient permissions:
```json
{
  "error": {
    "code": "FORBIDDEN",
    "message": "Insufficient permissions for this operation",
    "details": [
      {
        "required_scope": "client:write",
        "provided_scopes": ["client:read"]
      }
    ]
  }
}
```

---

## 5. Request/Response Standards

### 5.1 Request Headers

**Required:**
```http
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Optional:**
```http
Accept: application/json
Accept-Language: en-GB
X-Request-ID: <unique-request-id>
If-Match: <etag-value>
```

### 5.2 Request Body Format

**JSON format with camelCase:**

```json
{
  "fieldName": "value",
  "nestedObject": {
    "property": "value"
  },
  "arrayField": ["value1", "value2"]
}
```

**Date/Time Format:** ISO 8601
```json
{
  "startDate": "2026-02-25",
  "createdAt": "2026-02-25T10:30:00Z"
}
```

**Currency Format:**
```json
{
  "amount": {
    "amount": 50000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  }
}
```

### 5.3 Response Body Format

**Single Resource:**
```json
{
  "id": 123,
  "fieldName": "value",
  "created": "2026-02-25T10:00:00Z",
  "modified": "2026-02-25T10:30:00Z"
}
```

**Collection Response:**
```json
{
  "items": [
    {
      "id": 123,
      "fieldName": "value"
    },
    {
      "id": 124,
      "fieldName": "value"
    }
  ],
  "pagination": {
    "total": 150,
    "limit": 50,
    "offset": 0,
    "hasMore": true
  }
}
```

### 5.4 Response Headers

**Standard:**
```http
Content-Type: application/json; charset=utf-8
X-Request-ID: <request-id>
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 950
X-RateLimit-Reset: 1640000000
```

**For cacheable resources:**
```http
Cache-Control: max-age=3600, private
ETag: "33a64df551425fcc55e4d42a148795d9"
Last-Modified: Tue, 25 Feb 2026 10:30:00 GMT
```

**For created resources (201):**
```http
Location: /api/v2/factfinds/123/clients/456
```

### 5.5 Pagination

**Query Parameters:**
```
GET /api/v2/factfinds/{factfindId}/clients?limit=50&offset=100
```

**Parameters:**
- `limit` - Records per page (default: 50, max: 200)
- `offset` - Starting position (default: 0)

**Response:**
```json
{
  "items": [...],
  "pagination": {
    "total": 250,
    "limit": 50,
    "offset": 100,
    "hasMore": true
  }
}
```

### 5.6 Filtering & Sorting

**Filtering:**
```
GET /api/v2/factfinds/{factfindId}/clients?status=active&type=Person
```

**Sorting:**
```
GET /api/v2/factfinds/{factfindId}/clients?sort=lastName:asc,created:desc
```

**Search:**
```
GET /api/v2/factfinds/{factfindId}/clients?search=smith
```

---

## 6. Error Handling

### 6.1 Standard Error Response Format

All error responses follow this consistent format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
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

### 6.2 Standard Error Codes

**Authentication & Authorization:**
- `UNAUTHORIZED` - Authentication required
- `FORBIDDEN` - Insufficient permissions
- `TOKEN_EXPIRED` - JWT token expired
- `INVALID_TOKEN` - JWT token invalid

**Validation Errors:**
- `VALIDATION_ERROR` - Request validation failed
- `REQUIRED_FIELD_MISSING` - Required field not provided
- `INVALID_FORMAT` - Field format invalid
- `INVALID_VALUE` - Field value invalid

**Resource Errors:**
- `NOT_FOUND` - Resource not found
- `CONFLICT` - Resource conflict (duplicate)
- `GONE` - Resource permanently deleted

**Business Rule Errors:**
- `BUSINESS_RULE_VIOLATION` - Business rule not satisfied
- `CONSTRAINT_VIOLATION` - Data constraint violation
- `INVALID_STATE_TRANSITION` - Invalid state change

**Server Errors:**
- `INTERNAL_ERROR` - Unexpected server error
- `SERVICE_UNAVAILABLE` - Service temporarily unavailable
- `TIMEOUT` - Request timeout

### 6.3 Validation Error Example

**400 Bad Request:**
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "email",
        "issue": "Invalid email format",
        "value": "not-an-email"
      },
      {
        "field": "dateOfBirth",
        "issue": "Date must be in the past",
        "value": "2030-01-01"
      }
    ],
    "timestamp": "2026-02-25T10:30:00Z",
    "requestId": "req-123456"
  }
}
```

### 6.4 Not Found Error Example

**404 Not Found:**
```json
{
  "error": {
    "code": "NOT_FOUND",
    "message": "Client with ID 999 not found",
    "details": [
      {
        "resource": "Client",
        "id": "999"
      }
    ],
    "timestamp": "2026-02-25T10:30:00Z",
    "requestId": "req-123456"
  }
}
```

### 6.5 Business Rule Violation Example

**422 Unprocessable Entity:**
```json
{
  "error": {
    "code": "BUSINESS_RULE_VIOLATION",
    "message": "Cannot delete client with active arrangements",
    "details": [
      {
        "rule": "ActiveArrangementsExist",
        "context": {
          "clientId": 123,
          "activeArrangements": 5
        }
      }
    ],
    "timestamp": "2026-02-25T10:30:00Z",
    "requestId": "req-123456"
  }
}
```

---

## 7. Security

### 7.1 Transport Security

**TLS Requirement:**
- TLS 1.3 required for all API traffic
- TLS 1.2 minimum (fallback)
- No support for TLS 1.1 or earlier

**HTTPS Only:**
- All API endpoints available only via HTTPS
- HTTP requests automatically redirected to HTTPS

### 7.2 Authentication Security

**JWT Token Security:**
- Signed with RS256 (RSA with SHA-256)
- Private key secured in HSM
- Public key for verification
- Short-lived access tokens (1 hour)
- Refresh tokens for renewal

**Token Storage:**
- Never log tokens
- Store tokens securely on client
- Use httpOnly cookies where appropriate

### 7.3 Authorization Security

**Principle of Least Privilege:**
- Grant minimum required scopes
- Review permissions regularly
- Audit access logs

**Scope Validation:**
- Validate scopes on every request
- Reject requests with insufficient permissions
- Log authorization failures

### 7.4 Data Protection

**Personal Identifiable Information (PII):**
- Encrypted at rest (AES-256)
- Encrypted in transit (TLS 1.3)
- Masked in logs
- Compliant with GDPR/DPA 2018

**Sensitive Financial Data:**
- Additional encryption layers
- Access audit logging
- Regulatory compliance (FCA, MLR 2017)

**Data Retention:**
- Retention periods per regulation
- Secure deletion after retention
- Right to erasure (GDPR)

### 7.5 Security Best Practices

**Input Validation:**
- Validate all input fields
- Sanitize user input
- Reject malformed requests

**SQL Injection Prevention:**
- Parameterized queries only
- No dynamic SQL construction
- ORM with proper escaping

**Cross-Site Scripting (XSS) Prevention:**
- Output encoding
- Content Security Policy headers
- Input sanitization

**Cross-Site Request Forgery (CSRF) Prevention:**
- CSRF tokens for state-changing operations
- SameSite cookie attribute
- Origin/Referer header validation

**Rate Limiting:**
- Prevent abuse and DoS attacks
- Per-client rate limits
- Exponential backoff

### 7.6 Audit Logging

**Logged Events:**
- Authentication attempts
- Authorization failures
- Resource access (read operations)
- Resource modifications (write operations)
- Resource deletions
- Administrative actions

**Log Contents:**
- Timestamp
- User ID
- Client IP address
- Resource accessed
- Operation performed
- Request ID
- Result (success/failure)

**Log Security:**
- Logs encrypted
- Centralized log storage
- Tamper-proof
- Retention per regulation

---

## 8. Performance Standards

### 8.1 Response Time Targets

**95th Percentile Targets:**

| Operation | Target | Maximum |
|-----------|--------|---------|
| GET (single resource) | < 100ms | < 200ms |
| GET (collection, paginated) | < 150ms | < 300ms |
| POST (create) | < 300ms | < 500ms |
| PUT/PATCH (update) | < 300ms | < 500ms |
| DELETE | < 200ms | < 300ms |

### 8.2 Throughput Targets

**Requests per Second:**
- Minimum: 1,000 req/sec per instance
- Peak: 5,000 req/sec per instance
- With auto-scaling: 50,000+ req/sec

### 8.3 Caching Strategy

**Cacheable Resources:**
- GET requests (where appropriate)
- Reference data (high cache lifetime)
- Infrequently changing entities

**Cache Headers:**
```http
Cache-Control: max-age=3600, private
ETag: "33a64df551425fcc55e4d42a148795d9"
Last-Modified: Tue, 25 Feb 2026 10:30:00 GMT
```

**Cache Invalidation:**
- Invalidate on updates
- ETags for conditional requests
- Last-Modified headers

**Conditional Requests:**
```http
If-None-Match: "33a64df551425fcc55e4d42a148795d9"
If-Modified-Since: Tue, 25 Feb 2026 10:30:00 GMT
```

**304 Not Modified Response:**
```http
HTTP/1.1 304 Not Modified
Cache-Control: max-age=3600, private
ETag: "33a64df551425fcc55e4d42a148795d9"
```

### 8.4 Rate Limiting

**Default Limits:**
- 1,000 requests per hour per client
- 100 requests per minute per client
- 20 requests per second per client

**Rate Limit Headers:**
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 950
X-RateLimit-Reset: 1640000000
```

**Rate Limit Exceeded (429):**
```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Rate limit exceeded. Retry after 60 seconds.",
    "details": [
      {
        "limit": 1000,
        "remaining": 0,
        "reset": 1640000000
      }
    ]
  }
}
```

**Response Header:**
```http
HTTP/1.1 429 Too Many Requests
Retry-After: 60
```

### 8.5 Pagination Performance

**Limit Restrictions:**
- Default: 50 items
- Maximum: 200 items
- Larger limits impact performance

**Offset-based Pagination:**
- Suitable for small datasets
- Performance degrades with large offsets

**Cursor-based Pagination (future):**
- For large datasets
- Consistent performance

---

## 9. Testing Standards

### 9.1 Test Categories

**Unit Tests:**
- Business logic
- Validation rules
- Data transformations
- 80%+ code coverage

**Integration Tests:**
- API endpoint tests
- Database integration
- Authentication/authorization
- Error handling

**Contract Tests:**
- Request/response format
- Schema validation
- Breaking change detection

**Performance Tests:**
- Load testing
- Stress testing
- Spike testing
- Endurance testing

**Security Tests:**
- Authentication bypass
- Authorization bypass
- Injection attacks
- Rate limiting

### 9.2 Standard Test Scenarios

**Happy Path:**
1. Successful creation (POST)
2. Successful retrieval (GET)
3. Successful update (PATCH)
4. Successful deletion (DELETE)

**Validation Errors:**
1. Missing required fields
2. Invalid field formats
3. Invalid field values
4. Field length violations

**Authorization:**
1. Missing authentication token
2. Invalid authentication token
3. Expired authentication token
4. Insufficient permissions

**Resource State:**
1. Resource not found
2. Resource already exists (conflict)
3. Resource already deleted (gone)

**Business Rules:**
1. Constraint violations
2. State transition rules
3. Referential integrity

### 9.3 Test Data Standards

**Use Realistic Data:**
- Actual UK addresses
- Valid NINo patterns
- Realistic currency amounts
- Proper date ranges

**Anonymized Data:**
- No real client data
- Synthetic names
- Test email addresses
- Non-production phone numbers

**Test Data Sets:**
- Minimum data set (required fields only)
- Complete data set (all fields)
- Edge cases (boundary values)
- Invalid data (error cases)

### 9.4 API Testing Tools

**Recommended Tools:**
- Postman / Newman
- REST Assured
- JMeter (performance)
- OWASP ZAP (security)

---

## 10. API Documentation Standards

### 10.1 Entity API Document Structure

Each entity API document must include:

**Required Sections:**
1. Entity Overview (name, domain, base path)
2. Supported Operations Summary
3. Entity-Specific Business Rules
4. Entity-Specific Data Model
5. Request/Response Examples
6. Entity-Specific Validation Rules

**Reference to Master:**
- Link to this master document for common standards
- No duplication of common content

### 10.2 OpenAPI Specification

**Format:** OpenAPI 3.1

**Required:**
- Complete path definitions
- Request/response schemas
- Authentication requirements
- Example requests/responses

**Location:** `/api/docs/openapi.yaml`

### 10.3 API Documentation Portal

**Interactive Documentation:**
- Swagger UI for API exploration
- Try-it-out functionality
- Authentication sandbox

**URL:** `https://api.factfind.com/docs`

---

## 11. Entity APIs by Domain

This section provides navigation to all entity-specific API design documents, organized by bounded context (domain).

### 11.1 Client Management Domain

**Description:** Client identity, profiles, relationships, and client-related data.

**Aggregate Root:** Client

**Entity APIs:**

1. **[Client API Design](./Client-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients`
   - Core client identity and profile management

2. **[Address API Design](./Address-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses`
   - Client address management (current and historical)

3. **[Contact API Design](./Contact-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/contacts`
   - Contact information (phone, email)

4. **[Relationship API Design](./Relationship-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/relationships`
   - Client-to-client relationships

5. **[Note API Design](./Note-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/notes`
   - Client notes and annotations

6. **[Dependant API Design](./Dependant-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/dependants`
   - Financial dependants management

7. **[Vulnerability API Design](./Vulnerability-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/vulnerabilities`
   - Client vulnerability tracking (Consumer Duty)

8. **[Identity Verification API Design](./Identity-Verification-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/identity-verification`
   - KYC/AML identity verification (MLR 2017)

9. **[Financial Profile API Design](./Financial-Profile-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/financial-profile`
   - Client financial profile summary

10. **[DPA Agreement API Design](./DPA-Agreement-API-Design.md)**
    - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/dpa-agreements`
    - Data Processing Agreements (GDPR)

11. **[Estate Planning API Design](./Estate-Planning-API-Design.md)**
    - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/estate-planning`
    - Estate planning, wills, gifts, IHT planning

12. **[Custom Question API Design](./Custom-Question-API-Design.md)**
    - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/custom-questions`
    - Custom and supplementary questions

---

### 11.2 Circumstances Domain

**Description:** Client circumstances including employment, income, expenditure, affordability, and credit history.

**Aggregate Root:** Client

**Entity APIs:**

1. **[Employment API Design](./Employment-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/employments`
   - Employment history and current employment

2. **[Income API Design](./Income-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/income`
   - Income sources and earnings tracking

3. **[Expenditure API Design](./Expenditure-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/expenditure`
   - Expenditure items and spending tracking

4. **[Affordability API Design](./Affordability-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/affordability`
   - Affordability calculations and budget analysis

5. **[Credit History API Design](./Credit-History-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/credit-history`
   - Credit history, scores, payment records

---

### 11.3 Arrangements Domain

**Description:** Financial arrangements including investments, pensions, mortgages, and protection policies.

**Aggregate Root:** Arrangement

**Entity APIs:**

1. **[Investment API Design](./Investment-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/investments`
   - Investment products (GIA, ISA, bonds, cash)

2. **[Mortgage API Design](./Mortgage-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/mortgages`
   - Mortgage products and lending

3. **[PersonalProtection API Design](./PersonalProtection-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/protections`
   - Personal protection policies (life, CI, IP, expense, severity)

4. **[Contribution API Design](./Contribution-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/arrangements/{arrangementId}/contributions`
   - Contribution records for arrangements

6. **[Beneficiary API Design](./Beneficiary-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/arrangements/{arrangementId}/beneficiaries`
   - Beneficiary nominations for arrangements

---

### 11.4 Assets & Liabilities Domain

**Description:** Client assets and liabilities tracking, net worth calculations.

**Aggregate Root:** Client

**Entity APIs:**

1. **[Asset API Design](./Asset-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/assets`
   - Asset management (property, equities, valuables)

2. **[Net Worth API Design](./Net-Worth-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/net-worth`
   - Net worth calculations and tracking

---

### 11.5 Risk Profiling Domain

**Description:** Attitude to Risk (ATR) assessments and risk profiling.

**Aggregate Root:** Client

**Entity APIs:**

1. **[ATR Assessment API Design](./ATR-Assessment-API-Design.md)**
   - Base Path: `/api/v2/factfinds/{factfindId}/clients/{clientId}/atr-assessment`
   - Attitude to Risk assessment and risk profiling

---

### 11.6 FactFind Root Domain

**Description:** FactFind aggregate root for fact-finding sessions.

**Aggregate Root:** FactFind

**Entity APIs:**

1. **[FactFind API Design](./FactFind-API-Design.md)**
   - Base Path: `/api/v2/factfinds`
   - Root FactFind aggregate for fact-finding sessions

---

### 11.7 Reference Data Domain

**Description:** Reference data, enumerations, and lookup values.

**Aggregate Root:** Reference

**Entity APIs:**

1. **[Reference Data API Design](./Reference-Data-API-Design.md)**
   - Base Path: `/api/v2/reference-data`
   - Reference data, enumerations, lookup values

---

## 12. References

### 12.1 Related Documents

- [FactFind API Design v2](../FactFind-API-Design-v2.md) - Complete source document with detailed operations
- [FactFind Contracts Reference](../FactFind-Contracts-Reference.md) - Complete contract/schema definitions
- [API Endpoints Catalog](../API-Endpoints-Catalog.md) - Comprehensive endpoint catalog
- [Entity APIs Breakdown](../ENTITY-APIS-BREAKDOWN.md) - Entity breakdown with navigation

### 12.2 Standards & Specifications

**RESTful API:**
- REST Architectural Style (Roy Fielding)
- HTTP/1.1 Specification (RFC 7231-7235)
- HTTP Semantics (RFC 9110)

**JSON:**
- JSON Specification (RFC 8259)
- JSON Schema (Draft 2020-12)

**Security:**
- OAuth 2.0 (RFC 6749)
- JWT (RFC 7519)
- TLS 1.3 (RFC 8446)

**OpenAPI:**
- OpenAPI Specification 3.1

**UK Regulations:**
- GDPR / Data Protection Act 2018
- FCA Handbook
- Money Laundering Regulations 2017
- Consumer Duty 2023

### 12.3 External Resources

- [RESTful API Design Best Practices](https://restfulapi.net/)
- [HTTP Status Codes](https://httpstatuses.com/)
- [JWT.io](https://jwt.io/)
- [OWASP API Security](https://owasp.org/www-project-api-security/)

---

## Summary

This master document defines all common standards and conventions for the FactFind API system. Individual entity API documents contain only entity-specific information and reference this master for shared standards.

**Key Principles:**
- ✅ DRY (Don't Repeat Yourself) - Common standards in one place
- ✅ Consistency - All APIs follow same standards
- ✅ RESTful - REST architectural principles
- ✅ Secure - Authentication, authorization, encryption
- ✅ Performant - Response time and throughput targets
- ✅ Well-documented - Clear, comprehensive documentation

---

**Document Version:** 2.0
**Last Updated:** 2026-02-25
**Status:** ✅ ACTIVE - MASTER API DESIGN DOCUMENT
