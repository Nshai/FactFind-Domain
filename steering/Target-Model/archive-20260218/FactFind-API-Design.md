# FactFind System API Design Specification
## Comprehensive RESTful API for Wealth Management Platform

**Document Version:** 1.0
**Date:** 2026-02-16
**Status:** Design Specification - Implementation Ready
**API Version:** v1
**Base URL:** `https://api.factfind.com`
**Source:** Greenfield ERD (39 entities, 1,786 fields, 8 bounded contexts)

---

## Executive Summary

This document presents a comprehensive RESTful API design for the FactFind system, a wealth management platform built on Domain-Driven Design (DDD) principles. The API architecture follows industry best practices and provides complete coverage of all business capabilities required for modern financial advisory services.

### Overview

**Business Domain:** Wealth Management & Financial Advisory
**Total Entities:** 39 entities across 8 bounded contexts
**Total Fields:** 1,786 business fields from Excel specification
**Regulatory Compliance:** FCA Handbook, MiFID II, IDD, Consumer Duty, GDPR, MLR 2017
**Industry Standards:** Aligned with Intelligent Office, Salesforce FSC, Xplan, MoneyHub

### API Scope

The FactFind API provides comprehensive digital capabilities for:

1. **Client Onboarding & KYC** - Client management, identity verification, regulatory compliance
2. **Circumstances Discovery** - Fact-finding, employment, income, expenditure tracking
3. **Arrangements Management** - Pensions, investments, protection, mortgages
4. **Goals & Objectives** - Financial goal setting and tracking
5. **Risk Profiling** - Attitude to risk assessment and capacity for loss
6. **Estate Planning** - Gifts, trusts, and inheritance tax planning
7. **Reference Data** - Centralized lookup data management

### Key Features

- **RESTful Architecture** - Resource-oriented design with proper HTTP semantics
- **Single Contract Principle** - One unified contract per entity for create, update, and response operations
- **Aggregate-Based** - APIs organized around DDD aggregates for transactional consistency
- **Event-Driven** - Domain events for loose coupling and integration
- **Industry-Standard** - FCA-compliant terminology and data structures
- **Production-Ready** - Complete request/response contracts with validation rules
- **HATEOAS Level 3** - Hypermedia controls for API discoverability
- **Multi-Tenancy** - Built-in tenant isolation for SaaS deployment

### Target Audience

- **API Consumers:** Frontend developers, mobile app developers, integration partners
- **Backend Developers:** Implementation teams building the API services
- **Product Owners:** Business stakeholders understanding API capabilities
- **Architects:** System designers reviewing architectural decisions
- **Compliance Teams:** Regulatory compliance verification

---

## Table of Contents

1. [API Design Principles](#1-api-design-principles)
   - [1.7 Single Contract Principle](#17-single-contract-principle)
   - [1.8 Value and Reference Type Semantics](#18-value-and-reference-type-semantics)
   - [1.9 Aggregate Root Pattern](#19-aggregate-root-pattern)
2. [Authentication & Authorization](#2-authentication--authorization)
3. [Common Patterns](#3-common-patterns)
4. [FactFind API (Root Aggregate)](#4-factfind-api-root-aggregate)
5. [FactFind Clients API](#5-factfind-clients-api)
6. [FactFind Income & Expenditure API](#6-factfind-income--expenditure-api)
7. [FactFind Arrangements API](#7-factfind-arrangements-api)
8. [FactFind Goals API](#8-factfind-goals-api)
9. [FactFind Assets & Liabilities API](#9-factfind-assets--liabilities-api)
10. [FactFind Risk Profile API](#10-factfind-risk-profile-api)
11. [FactFind Estate Planning API](#11-factfind-estate-planning-api)
12. [Reference Data API](#12-reference-data-api)
13. [Entity Contracts](#13-entity-contracts)
   - [13.1 Client Contract](#131-client-contract)
   - [13.2 FactFind Contract](#132-factfind-contract)
   - [13.3 Address Contract](#133-address-contract)
   - [13.4 Income Contract](#134-income-contract)
   - [13.5 Arrangement Contract](#135-arrangement-contract)
   - [13.6 Goal Contract](#136-goal-contract)
   - [13.7 RiskProfile Contract](#137-riskprofile-contract)
   - [13.8 Collection Response Wrapper](#138-collection-response-wrapper)
   - [13.9 Contract Extension for Other Entities](#139-contract-extension-for-other-entities)
   - [13.10 Standard Value Types](#1310-standard-value-types)
   - [13.11 Standard Reference Types](#1311-standard-reference-types)
14. [Implementation Guidance](#14-implementation-guidance)
15. [Appendices](#appendices)

---

## 1. API Design Principles

### 1.1 RESTful Architecture

The FactFind API strictly follows REST architectural principles:

**Resource-Oriented Design:**
- Resources are identified by URIs (e.g., `/api/v1/clients/123`)
- Resources are nouns, not verbs (clients, factfinds, arrangements)
- HTTP methods define operations (GET, POST, PUT, PATCH, DELETE)
- Proper HTTP status codes indicate outcomes

**Stateless Communication:**
- Each request contains all information needed to process it
- No server-side session state maintained
- Authentication via JWT tokens passed in Authorization header
- Enables horizontal scalability and load balancing

**Cacheable Responses:**
- ETags for optimistic concurrency control
- Cache-Control headers for performance optimization
- Conditional requests with If-Match/If-None-Match headers

**Layered System:**
- API Gateway for routing and security
- Service layer for business logic
- Data access layer for persistence
- Integration layer for external systems

### 1.2 Naming Conventions

**Resource URIs:**
```
/api/v1/clients                     (collection)
/api/v1/clients/{id}                (single resource)
/api/v1/clients/{id}/addresses      (sub-resource collection)
/api/v1/factfinds/{id}/income       (nested resource)
```

**Naming Rules:**
- Plural nouns for collections (`/clients`, `/factfinds`, `/arrangements`)
- Lowercase with hyphens for multi-word resources (`/contact-details`, `/risk-profiles`)
- Path parameters in camelCase (`{clientId}`, `{factfindId}`)
- Query parameters in camelCase (`sortBy`, `pageSize`, `includeArchived`)

**Property Naming (JSON):**
- camelCase for all properties (`firstName`, `dateOfBirth`, `grossAnnualIncome`)
- DateTime properties suffixed with `At` (`createdAt`, `updatedAt`)
- Date properties suffixed with `On` (`startedOn`, `completedOn`)
- Boolean properties prefixed with `is`, `has`, `can` (`isActive`, `hasWill`)

### 1.3 HTTP Methods & Status Codes

**Method Usage:**

| Method | Purpose | Success Response | Idempotent |
|--------|---------|------------------|------------|
| GET | Retrieve resource(s) | 200 OK | Yes |
| POST | Create new resource | 201 Created + Location header | No |
| PUT | Replace entire resource | 200 OK or 204 No Content | Yes |
| PATCH | Partial update | 200 OK or 204 No Content | Yes |
| DELETE | Remove resource | 204 No Content | Yes |

**Status Code Standards:**

**Success (2xx):**
- `200 OK` - Successful GET, PUT, PATCH with response body
- `201 Created` - Successful POST, Location header points to new resource
- `204 No Content` - Successful PUT, PATCH, DELETE with no response body

**Client Errors (4xx):**
- `400 Bad Request` - Invalid request syntax or validation failure
- `401 Unauthorized` - Authentication required or invalid
- `403 Forbidden` - Authenticated but lacks permission
- `404 Not Found` - Resource does not exist
- `409 Conflict` - Concurrent modification conflict (ETag mismatch)
- `412 Precondition Failed` - If-Match header missing or invalid
- `422 Unprocessable Entity` - Semantic validation error

**Server Errors (5xx):**
- `500 Internal Server Error` - Unexpected server error
- `503 Service Unavailable` - Service temporarily unavailable

### 1.4 Error Response Format (RFC 7807)

All error responses follow RFC 7807 Problem Details format:

```json
{
  "type": "https://api.factfind.com/problems/validation-error",
  "title": "Validation Failed",
  "status": 400,
  "detail": "One or more validation errors occurred",
  "instance": "/api/v1/clients/123/income",
  "traceId": "00-4bf92f3577b34da6a3ce929d0e0e4736-00",
  "errors": [
    {
      "field": "grossAmount.value",
      "code": "RANGE_ERROR",
      "message": "Gross amount must be greater than zero",
      "rejectedValue": -5000
    },
    {
      "field": "frequency",
      "code": "REQUIRED",
      "message": "Frequency is required",
      "rejectedValue": null
    }
  ]
}
```

**Error Type URIs:**
- `validation-error` - Request validation failures
- `authentication-error` - Authentication failures
- `authorization-error` - Permission denied
- `not-found-error` - Resource not found
- `conflict-error` - Business rule or concurrency violations
- `server-error` - Internal server errors

### 1.5 Aggregate-Oriented Design

The FactFind API follows strict Domain-Driven Design (DDD) aggregate patterns with **FactFind as the single aggregate root**. This ensures transactional consistency, clear ownership boundaries, and proper business rule enforcement.

**Single Aggregate Root: FactFind**

All business entities are owned by and accessed through the FactFind aggregate root:

```
/api/v1/factfinds                                    (Root aggregate - ONLY top-level resource)
/api/v1/factfinds/{factfindId}
/api/v1/factfinds/{factfindId}/clients               (Clients in this fact find)
/api/v1/factfinds/{factfindId}/clients/{clientId}
/api/v1/factfinds/{factfindId}/income                (Income discovered in this fact find)
/api/v1/factfinds/{factfindId}/expenditure           (Expenditure captured in this fact find)
/api/v1/factfinds/{factfindId}/employment            (Employment recorded in this fact find)
/api/v1/factfinds/{factfindId}/arrangements          (Arrangements identified in this fact find)
/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}
/api/v1/factfinds/{factfindId}/goals                 (Goals established in this fact find)
/api/v1/factfinds/{factfindId}/assets                (Assets discovered in this fact find)
/api/v1/factfinds/{factfindId}/liabilities           (Liabilities identified in this fact find)
/api/v1/factfinds/{factfindId}/risk-profile          (Risk profile assessed in this fact find)
/api/v1/factfinds/{factfindId}/gifts                 (Gifts recorded in this fact find)
/api/v1/factfinds/{factfindId}/complete              (Complete aggregate with all nested data)
```

**Reference Data (System-Wide, Not Owned by FactFind):**
```
/api/v1/reference/genders                            (System-wide lookups)
/api/v1/reference/countries
/api/v1/reference/providers
/api/v1/reference/product-types
```

**Design Principles:**
- **Single Root Aggregate:** FactFind is the ONLY aggregate root for business data
- **Transactional Boundary:** All operations within a fact find are transactionally consistent
- **Clear Ownership:** Every entity belongs to exactly one fact find
- **No Independent Access:** Clients, arrangements, goals, etc. cannot exist without a fact find context
- **Reference Data Separation:** System-wide lookup data remains independent

### 1.6 Versioning Strategy

**URL-Based Versioning:**
```
https://api.factfind.com/api/v1/clients
https://api.factfind.com/api/v2/clients (future)
```

**Version Support Policy:**
- Current version (v1): Full support
- Previous version: Maintenance mode (12 months)
- Deprecated version: Security fixes only (6 months)
- Sunset: Returns 410 Gone

**Breaking vs Non-Breaking Changes:**

Non-Breaking (safe):
- Add new endpoints
- Add optional request fields
- Add response fields
- Add enum values (append only)
- Add optional query parameters

Breaking (requires version bump):
- Remove fields or endpoints
- Rename fields
- Change data types
- Change required/optional status
- Remove enum values
- Change validation rules (stricter)

### 1.7 Single Contract Principle

The FactFind API follows the **Single Contract Principle** for all entity representations. Instead of maintaining separate DTOs for create requests, update requests, and responses, each entity has **one unified contract** that flows through the entire request/response pipeline.

**Core Concept:**

A single entity contract (e.g., `Client`) is used for:
- POST requests (create operations)
- PUT requests (full updates)
- PATCH requests (partial updates)
- GET responses (retrieval)

**Traditional Approach (Not Used):**
```
CreateClientRequest { firstName, lastName, dateOfBirth }
UpdateClientRequest { firstName?, lastName?, email? }
ClientResponse { id, firstName, lastName, dateOfBirth, email, createdAt, updatedAt }
```

**Single Contract Approach (Used):**
```
Client {
  id: uuid (read-only)
  firstName: string (required-on-create, updatable)
  lastName: string (required-on-create, updatable)
  dateOfBirth: date (required-on-create, write-once)
  email: string (optional, updatable)
  createdAt: timestamp (read-only)
  updatedAt: timestamp (read-only)
}
```

**Field Annotations:**

Each field in the unified contract is annotated with behavioral characteristics:

| Annotation | Meaning | Create | Update | Response |
|------------|---------|--------|--------|----------|
| `required-on-create` | Must be provided when creating | Required | Optional/Ignored | Included |
| `optional` | Can be omitted in any operation | Optional | Optional | Included if set |
| `read-only` | System-generated, cannot be set | Ignored | Ignored | Included |
| `write-once` | Set on create, immutable thereafter | Allowed | Ignored | Included |
| `updatable` | Can be modified via PUT/PATCH | Allowed | Allowed | Included |

**HTTP Method Handling:**

**POST /api/v1/factfinds/{factfindId}/clients** (Create)
- Request: `Client` contract with required-on-create fields
- Server ignores: `id`, `createdAt`, `updatedAt`, and any read-only fields
- Response: Complete `Client` contract with all fields populated

**PUT /api/v1/factfinds/{factfindId}/clients/{clientId}** (Full Update)
- Request: `Client` contract with all updatable fields (full replacement)
- Server ignores: `id`, `createdAt`, `updatedAt`, `write-once` fields
- Response: Complete `Client` contract with updated values

**PATCH /api/v1/clients/{id}** (Partial Update)
- Request: `Client` contract with subset of updatable fields
- Server ignores: `id`, `createdAt`, `updatedAt`, `write-once` fields
- Response: Complete `Client` contract with updated values

**GET /api/v1/factfinds/{factfindId}/clients/{id}** (Retrieve)
- Response: Complete `Client` contract with all fields

**Benefits:**

1. **Single Source of Truth** - One contract definition per entity
2. **Reduced Duplication** - No need to maintain multiple DTOs
3. **Easier Maintenance** - Changes made in one place
4. **Clearer Contracts** - Field behaviors explicitly documented
5. **Better Versioning** - Contract evolution is simpler
6. **Type Safety** - Strongly typed across all operations
7. **API Simplicity** - Consumers learn one contract per entity

**Example: Client Contract**

```json
{
  "id": 123,                        // read-only
  "firstName": "John",              // required-on-create, updatable
  "lastName": "Smith",              // required-on-create, updatable
  "dateOfBirth": "1980-05-15",     // required-on-create, write-once
  "email": "john@example.com",     // optional, updatable
  "createdAt": "2020-01-15T10:30:00Z",  // read-only
  "updatedAt": "2026-02-16T14:30:00Z"   // read-only
}
```

When creating (POST): Client supplies `firstName`, `lastName`, `dateOfBirth`, and optionally `email`. Server generates `id`, `createdAt`, `updatedAt`.

When updating (PUT/PATCH): Client can modify `firstName`, `lastName`, `email`. Cannot change `dateOfBirth` (write-once) or `id`, `createdAt`, `updatedAt` (read-only).

When retrieving (GET): Server returns complete contract with all fields.

**Field Selection:**

For partial responses, use field selection query parameters rather than separate DTOs:

```http
GET /api/v1/factfinds/{factfindId}/clients/123?fields=id,firstName,lastName,email
```

Response returns the same `Client` contract with only requested fields populated.

**Collection Responses:**

Collection endpoints use a wrapper that contains an array of complete contracts:

```json
{
  "data": [
    { /* Complete Client contract */ },
    { /* Complete Client contract */ }
  ],
  "pagination": { /* Pagination metadata */ },
  "_links": { /* HATEOAS links */ }
}
```

**Polymorphic Types:**

For entities with subtypes (e.g., Arrangement with Pension, Investment, Protection), use a discriminator field in the unified contract:

```json
{
  "id": 456,
  "arrangementType": "Pension",     // discriminator (read-only, required-on-create, write-once)
  "productName": "SIPP",            // common field
  "pensionType": "PersonalPension", // type-specific field
  // ... other fields
}
```

### 1.8 Value and Reference Type Semantics

The FactFind API applies strict **VALUE TYPE** and **REFERENCE TYPE** semantics to all contracts to ensure consistency, clarity, and proper resource lifecycle management.

#### 1.8.1 Value Types

**Definition:**

Value types represent data that has **no independent identity** and are compared by their content rather than by an identifier. They are immutable concepts that are embedded directly within their parent entity.

**Characteristics:**

- **No Identity:** Value types do NOT have an `id` field
- **Embedded:** Always nested within a parent entity, never standalone resources
- **Immutable:** Represent immutable concepts (though the parent can replace them)
- **No Lifecycle:** Cannot be created, updated, or deleted independently
- **No Endpoints:** No dedicated API endpoints
- **Compared by Value:** Two value types are equal if their fields match
- **Naming Convention:** Suffixed with "Value" (e.g., `MoneyValue`, `AddressValue`)

**Common Value Types:**

Value types include three main categories:

1. **Composite Value Objects:** Complex data structures with multiple fields
   - `MoneyValue`, `AddressValue`, `NameValue`, `ContactValue`, `DateRangeValue`, `TaxDetailsValue`, `RateValue`, `PercentageValue`

2. **Enumerations:** Code/display pairs for categorical data
   - `GenderValue`, `MaritalStatusValue`, `EmploymentStatusValue`, `AddressTypeValue`, `ContactTypeValue`, `TitleValue`, `StatusValue`, `MeetingTypeValue`

3. **Lookup Values:** Reference data with rich metadata
   - `CountryValue`, `CountyValue`, `CurrencyValue`, `FrequencyValue`, `ProductTypeValue`

**All value types share these characteristics:**
- Are immutable
- Do NOT have identity (no `id` field)
- Named with "Value" suffix
- Embedded within parent entities
- Compared by value equality

| Value Type | Fields | Example |
|------------|--------|---------|
| `MoneyValue` | `amount: decimal`<br>`currency: CurrencyValue` | `{ "amount": 75000.00, "currency": { "code": "GBP", "display": "British Pound", "symbol": "£" } }` |
| `AddressValue` | `line1-4, city, county, postcode`<br>`country: CountryValue`<br>`addressType: AddressTypeValue` | `{ "line1": "123 Main St", "city": "London", "postcode": "SW1A 1AA", "country": { "code": "GB", "display": "United Kingdom" } }` |
| `GenderValue` | `code: string`<br>`display: string` | `{ "code": "M", "display": "Male" }` |
| `MaritalStatusValue` | `code: string`<br>`display: string`<br>`effectiveFrom: date` | `{ "code": "MAR", "display": "Married", "effectiveFrom": "2015-06-20" }` |
| `CountryValue` | `code: string`<br>`display: string`<br>`alpha3: string` | `{ "code": "GB", "display": "United Kingdom", "alpha3": "GBR" }` |
| `DateRangeValue` | `startDate: date`<br>`endDate: date` | `{ "startDate": "2020-01-01", "endDate": "2025-12-31" }` |
| `NameValue` | `title: TitleValue`<br>`firstName, middleName`<br>`lastName, preferredName` | `{ "title": { "code": "MR", "display": "Mr" }, "firstName": "John", "lastName": "Smith" }` |
| `ContactValue` | `type: ContactTypeValue`<br>`value: string`<br>`isPrimary: boolean` | `{ "type": { "code": "EMAIL", "display": "Email" }, "value": "john@example.com", "isPrimary": true }` |
| `PercentageValue` | `value: decimal` (0.00-1.00) | `{ "value": 0.25 }` |
| `RateValue` | `rate: decimal`<br>`type: enum` | `{ "rate": 3.5, "type": "Fixed" }` |
| `TaxDetailsValue` | `niNumber: string`<br>`taxReference: string` | `{ "niNumber": "AB123456C", "taxReference": "1234567890" }` |

**Value Type Usage Example:**

```json
{
  "id": "client-123",                     // Client entity has identity
  "name": {                               // NameValue - no id, embedded
    "title": {                            // TitleValue (enumeration)
      "code": "MR",
      "display": "Mr"
    },
    "firstName": "John",
    "lastName": "Smith"
  },
  "dateOfBirth": "1980-01-15",            // Primitive value type
  "gender": {                             // GenderValue (enumeration)
    "code": "M",
    "display": "Male"
  },
  "maritalStatus": {                      // MaritalStatusValue (enumeration)
    "code": "MAR",
    "display": "Married",
    "effectiveFrom": "2015-06-20"
  },
  "grossAnnualIncome": {                  // MoneyValue - no id, embedded
    "amount": 75000.00,
    "currency": {                         // CurrencyValue (lookup)
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "primaryAddress": {                     // AddressValue - no id, embedded
    "line1": "123 Main Street",
    "city": "London",
    "postcode": "SW1A 1AA",
    "country": {                          // CountryValue (lookup)
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    },
    "addressType": {                      // AddressTypeValue (enumeration)
      "code": "RES",
      "display": "Residential"
    }
  },
  "contacts": [                           // Array of ContactValue
    {
      "type": {                           // ContactTypeValue (enumeration)
        "code": "EMAIL",
        "display": "Email"
      },
      "value": "john@example.com",
      "isPrimary": true
    },
    {
      "type": {                           // ContactTypeValue (enumeration)
        "code": "MOBILE",
        "display": "Mobile"
      },
      "value": "+44 7700 900123",
      "isPrimary": false
    }
  ]
}
```

**Key Points:**

- Value types are owned by their parent entity
- To change a value type, update the parent entity
- Value types cannot be referenced from multiple parents
- No hypermedia links (`href`) for value types

#### 1.8.2 Reference Types

**Definition:**

Reference types represent entities that have **independent identity** and can exist and be managed independently. They are first-class resources with their own lifecycle.

**Characteristics:**

- **Has Identity:** Reference types MUST have an `id` field (UUID or string)
- **Standalone Resources:** Can be created, read, updated, and deleted independently
- **Mutable:** Can be updated over time while maintaining identity
- **Own Endpoints:** Have dedicated API endpoints
- **Cross-References:** Can be referenced from multiple other entities
- **Naming Convention:**
  - Entity type: Singular noun (e.g., `Client`, `Adviser`, `Provider`)
  - Reference field: Entity name + "Ref" suffix (e.g., `clientRef`, `adviserRef`)

**Reference Object Pattern:**

When one entity references another, use an expanded reference object containing:

```json
{
  "clientRef": {
    "id": "uuid-123",                    // Required: Unique identifier
    "href": "/api/v1/clients/uuid-123",  // Required: URL to resource
    "name": "John Smith",                // Required: Human-readable display name
    "clientNumber": "C00001234",         // Optional: Business identifier
    "type": "Person"                     // Optional: Discriminator for polymorphic types
  }
}
```

**Reference Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid/string | Yes | Unique identifier for the referenced entity |
| `href` | string | Yes | Absolute or relative URL to the resource |
| Display field(s) | varies | Yes | Human-readable identifier (name, number, etc.) |
| `type` | enum | Optional | Discriminator for polymorphic references |

**Common Reference Types:**

| Reference Type | Display Fields | Example |
|----------------|----------------|---------|
| `ClientRef` | `name`<br>`clientNumber`<br>`type` | `{ "id": "uuid", "href": "/api/v1/clients/uuid", "name": "John Smith", "clientNumber": "C00001", "type": "Person" }` |
| `AdviserRef` | `name`<br>`code` | `{ "id": "uuid", "href": "/api/v1/advisers/uuid", "name": "Sarah Johnson", "code": "ADV001" }` |
| `ProviderRef` | `name`<br>`frnNumber` | `{ "id": "uuid", "href": "/api/v1/providers/uuid", "name": "Aviva", "frnNumber": "123456" }` |
| `ArrangementRef` | `policyNumber`<br>`productType`<br>`provider` | `{ "id": "uuid", "href": "/api/v1/arrangements/uuid", "policyNumber": "POL12345", "productType": "Pension", "provider": "Aviva" }` |
| `EmploymentRef` | `employerName`<br>`status` | `{ "id": "uuid", "href": "/api/v1/employments/uuid", "employerName": "Acme Corp", "status": "Current" }` |
| `GoalRef` | `goalName`<br>`priority` | `{ "id": "uuid", "href": "/api/v1/goals/uuid", "goalName": "Retirement Planning", "priority": "High" }` |
| `FactFindRef` | `factFindNumber`<br>`status` | `{ "id": "uuid", "href": "/api/v1/factfinds/uuid", "factFindNumber": "FF001234", "status": "InProgress" }` |

**Reference Type Usage Example:**

```json
{
  "id": "factfind-456",                   // FactFind entity has identity
  "factFindNumber": "FF001234",
  "clientRef": {                          // ClientRef - reference to Client entity
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "jointClientRef": {                     // Optional second client reference
    "id": "client-124",
    "href": "/api/v1/clients/client-124",
    "name": "Jane Smith",
    "clientNumber": "C00001235",
    "type": "Person"
  },
  "adviserRef": {                         // AdviserRef - reference to Adviser entity
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Sarah Johnson",
    "code": "ADV001"
  },
  "totalNetMonthlyIncome": {              // MoneyValue - embedded value type
    "amount": 4500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "sessionDate": "2026-02-15"             // Primitive value type
}
```

#### 1.8.3 When to Use Value vs Reference Types

**Use Value Types When:**

- ✅ The data has no independent identity
- ✅ The data is owned exclusively by one parent
- ✅ The data is conceptually immutable (replace, don't update)
- ✅ The data is compared by content, not identity
- ✅ Examples: Money amounts, addresses, date ranges, percentages

**Use Reference Types When:**

- ✅ The entity has independent identity and lifecycle
- ✅ The entity can be shared/referenced by multiple parents
- ✅ The entity can be updated independently
- ✅ The entity needs its own API endpoints
- ✅ Examples: Clients, advisers, providers, arrangements

#### 1.8.4 Benefits of Value/Reference Semantics

**Clarity:**
- Clear distinction between entities and value objects
- Obvious which types have lifecycle management
- Explicit ownership relationships

**Consistency:**
- Uniform naming conventions across all contracts
- Predictable structure for references
- Standard patterns for expansion and linking

**API Design:**
- Value types: No endpoints needed
- Reference types: Full CRUD endpoints
- Reduced API surface area

**Performance:**
- Value types embedded: Fewer HTTP requests
- Reference types expandable: Client controls data fetching
- Selective expansion via query parameters

**Maintainability:**
- Clear contract boundaries
- Easier to reason about relationships
- Simplified testing and mocking

#### 1.8.5 Resource Expansion

Reference types support expansion to include the full referenced entity inline:

**Default Response (Minimal):**
```http
GET /api/v1/factfinds/factfind-456
```

```json
{
  "id": "factfind-456",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234"
  }
}
```

**Expanded Response:**
```http
GET /api/v1/factfinds/factfind-456?expand=clientRef,adviserRef
```

```json
{
  "id": "factfind-456",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person",
    // Full Client entity embedded when expanded
    "dateOfBirth": "1980-01-15",
    "grossAnnualIncome": {
      "amount": 75000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "primaryAddress": {
      "line1": "123 Main St",
      "city": "London",
      "postcode": "SW1A 1AA",
      "country": "GB"
    }
  }
}
```

**Expansion Rules:**
- Use `?expand=fieldName` query parameter
- Multiple fields: `?expand=clientRef,adviserRef,providerRef`
- Nested expansion: `?expand=clientRef.employmentRef`
- Only reference types can be expanded
- Value types are always fully embedded

#### 1.8.6 Creating and Updating References

**Creating with References (POST):**

When creating an entity that references others, provide only the reference `id`:

```json
POST /api/v1/factfinds

{
  "clientRef": {
    "id": "client-123"              // Only id required on create
  },
  "adviserRef": {
    "id": "adviser-789"
  },
  "sessionDate": "2026-02-15",
  "totalNetMonthlyIncome": {        // Value type fully embedded
    "amount": 4500.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
  }
}

Response:
{
  "id": "factfind-456",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",           // Server populates display fields
    "clientNumber": "C00001234"
  },
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Sarah Johnson",
    "code": "ADV001"
  },
  "sessionDate": "2026-02-15",
  "totalNetMonthlyIncome": {
    "amount": 4500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "createdAt": "2026-02-16T10:30:00Z",
  "updatedAt": "2026-02-16T10:30:00Z"
}
```

**Updating References (PUT/PATCH):**

To change a reference, provide the new reference `id`:

```json
PATCH /api/v1/factfinds/factfind-456

{
  "adviserRef": {
    "id": "adviser-999"             // Change to different adviser
  }
}

Response:
{
  "id": "factfind-456",
  "adviserRef": {
    "id": "adviser-999",
    "href": "/api/v1/advisers/adviser-999",
    "name": "Michael Brown",        // Server updates display fields
    "code": "ADV002"
  },
  // ... other fields unchanged
}
```

**Validation:**

- Server validates that referenced `id` exists
- Returns `422 Unprocessable Entity` if reference is invalid
- Returns updated display fields in response

### 1.9 Aggregate Root Pattern

The FactFind API implements a strict **single aggregate root pattern** where FactFind is the ONLY aggregate root for all business data. This architectural decision enforces Domain-Driven Design principles and provides strong transactional guarantees.

#### 1.9.1 What is an Aggregate Root?

In Domain-Driven Design (DDD), an **aggregate** is a cluster of domain objects that can be treated as a single unit for data changes. The **aggregate root** is the only member of the aggregate that outside objects are allowed to hold references to.

**Key Characteristics:**
- **Single Entry Point:** All access to aggregate members must go through the root
- **Transactional Boundary:** Changes within an aggregate are atomic
- **Consistency Boundary:** Business invariants are maintained within the aggregate
- **Identity:** Only the aggregate root has global identity; members have local identity

#### 1.9.2 Why FactFind is the Aggregate Root

**FactFind represents a complete fact-finding session** for one or more clients. It is the natural aggregate root because:

1. **Contextual Ownership:** All data collected during fact-finding (clients, income, expenditure, arrangements, goals) belongs to that specific fact-finding session

2. **Temporal Consistency:** The fact find represents a point-in-time snapshot of a client's financial situation. All data must be consistent with that point in time.

3. **Business Process Boundary:** Fact-finding is a complete business process. Creating a fact find initiates the process; completing it marks the end.

4. **Transactional Integrity:** Changes to any part of the fact find (adding income, recording arrangements, setting goals) should be transactionally consistent with the fact find state.

5. **Access Control:** Authorization is naturally scoped to the fact find level. Users have permissions to view/edit specific fact finds, which includes all nested data.

#### 1.9.3 What This Means for API Consumers

**Top-Level Resource:**

FactFind is the ONLY top-level business resource:
```
POST /api/v1/factfinds          (Create a new fact find - the only top-level POST)
GET  /api/v1/factfinds          (List fact finds)
GET  /api/v1/factfinds/{id}     (Get a fact find)
PUT  /api/v1/factfinds/{id}     (Update fact find metadata)
DELETE /api/v1/factfinds/{id}   (Delete entire fact find and all data)
```

**All Other Entities are Nested:**

Clients, arrangements, goals, etc. are accessed through the fact find:
```
POST /api/v1/factfinds/{factfindId}/clients
GET  /api/v1/factfinds/{factfindId}/clients/{clientId}
POST /api/v1/factfinds/{factfindId}/arrangements
GET  /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}
POST /api/v1/factfinds/{factfindId}/goals
GET  /api/v1/factfinds/{factfindId}/goals/{goalId}
```

**No Independent Entity Access:**

You CANNOT create or access these entities without a fact find context:
```
❌ POST /api/v1/factfinds/{factfindId}/clients               (Not supported)
❌ GET  /api/v1/clients/{id}          (Not supported)
❌ POST /api/v1/factfinds/{factfindId}/arrangements          (Not supported)
❌ GET  /api/v1/arrangements/{id}     (Not supported)
❌ POST /api/v1/factfinds/{factfindId}/goals                 (Not supported)
```

#### 1.9.4 Transactional Boundaries

**Within Aggregate (Atomic):**
```http
# These operations are transactionally consistent
POST /api/v1/factfinds/{id}/income
POST /api/v1/factfinds/{id}/expenditure
PUT  /api/v1/factfinds/{id}
```

All operations on the same fact find aggregate are guaranteed to be consistent. For example:
- Adding income automatically updates the fact find's total income calculation
- Deleting a fact find deletes all nested entities atomically
- Completing a fact find validates all required data is present

**Cross-Aggregate (Eventual Consistency):**

Reference data and lookups are separate aggregates:
```http
GET /api/v1/reference/countries     (Separate aggregate)
GET /api/v1/reference/providers     (Separate aggregate)
```

Changes to reference data do not affect existing fact finds immediately; they use eventual consistency patterns.

#### 1.9.5 Entity Lifecycle

**FactFind Lifecycle:**
```
1. Create fact find         POST /api/v1/factfinds
2. Add client data         POST /api/v1/factfinds/{id}/clients
3. Record income           POST /api/v1/factfinds/{id}/income
4. Record expenditure      POST /api/v1/factfinds/{id}/expenditure
5. Identify arrangements   POST /api/v1/factfinds/{id}/arrangements
6. Set goals               POST /api/v1/factfinds/{id}/goals
7. Complete fact find      POST /api/v1/factfinds/{id}/complete
```

**Cascading Deletes:**

Deleting a fact find cascades to ALL nested entities:
```http
DELETE /api/v1/factfinds/456   # Deletes:
                                # - All clients in this fact find
                                # - All income records
                                # - All expenditure records
                                # - All arrangements
                                # - All goals
                                # - All assets and liabilities
                                # - Risk profile
                                # - Estate planning data
```

#### 1.9.6 Special Operations

**Get Complete Aggregate:**

A special endpoint retrieves the entire aggregate in a single request:

```http
GET /api/v1/factfinds/{id}/complete
```

**Response:**
```json
{
  "id": "factfind-456",
  "sessionDate": "2026-02-16",
  "status": {"code": "COMP", "display": "Complete"},
  "clients": [
    { /* Complete client data */ }
  ],
  "income": [
    { /* All income records */ }
  ],
  "expenditure": [
    { /* All expenditure records */ }
  ],
  "arrangements": [
    { /* All arrangements with contributions, valuations */ }
  ],
  "goals": [
    { /* All goals */ }
  ],
  "assets": [
    { /* All assets */ }
  ],
  "liabilities": [
    { /* All liabilities */ }
  ],
  "riskProfile": {
    /* Risk assessment data */
  },
  "estatePlanning": {
    /* Estate planning data */
  }
}
```

**Use Cases:**
- Displaying complete fact find summary
- Generating fact find reports
- Exporting fact find data
- Comparing fact finds
- Audit trail review

#### 1.9.7 Benefits of This Approach

**1. Transactional Consistency**
- All changes within a fact find are atomic
- No partial updates or inconsistent states
- Database transactions align with business transactions

**2. Business Rule Enforcement**
- Fact find status controls what operations are allowed
- Cannot add data to a completed fact find without reopening it
- Required sections can be enforced before completion

**3. Clear Ownership and Context**
- Every entity belongs to exactly one fact find
- No ambiguity about which fact find data belongs to
- Easy to understand data lineage

**4. Simplified Authorization**
- Permissions are scoped at the fact find level
- Grant access to a fact find = access to all nested data
- Easier to implement row-level security

**5. Better API Ergonomics**
- Clear, predictable URL structure
- Obvious relationship between entities
- HATEOAS links are more meaningful

**6. Data Integrity**
- Cascading deletes prevent orphaned data
- Cannot create entities without proper context
- Referential integrity is enforced

**7. Performance Optimization**
- Can cache entire aggregate
- Bulk operations are natural
- Denormalization strategies are clearer

**8. Audit and Compliance**
- Complete fact find history is preserved
- Changes are scoped to specific fact finds
- Easier to generate audit reports

#### 1.9.8 Reference Data Exception

**System-Wide Reference Data** remains independent and is NOT part of the FactFind aggregate:

```
/api/v1/reference/genders           (System-wide enum)
/api/v1/reference/countries         (System-wide lookup)
/api/v1/reference/providers         (System-wide directory)
/api/v1/reference/product-types     (System-wide catalog)
```

**Rationale:**
- Reference data is shared across all fact finds
- Changes to reference data should not affect existing fact finds
- Reference data has its own lifecycle and versioning
- Reference data is read-mostly and heavily cached

---

## 2. Authentication & Authorization

### 2.1 OAuth 2.0 with JWT

**Authentication Flow:**

1. Client obtains access token from authorization server
2. Client includes token in Authorization header: `Bearer {token}`
3. API validates token signature and expiration
4. API extracts claims (userId, tenantId, scopes)
5. API enforces authorization based on scopes

**Token Structure (JWT):**
```json
{
  "sub": "user-123",
  "tenant_id": "tenant-456",
  "scope": "factfind:read factfind:write client:read",
  "iat": 1708084800,
  "exp": 1708088400,
  "aud": "https://api.factfind.com"
}
```

### 2.2 Authorization Scopes

**Scope Hierarchy:**

| Scope | Access Level | Description |
|-------|--------------|-------------|
| `client:read` | Read | View client profiles and demographics |
| `client:write` | Write | Create/update client information |
| `client:pii:read` | Sensitive Read | View PII (NI number, passport) |
| `factfind:read` | Read | View fact find data |
| `factfind:write` | Write | Create/update fact finds |
| `arrangements:read` | Read | View arrangements (plans, policies) |
| `arrangements:write` | Write | Create/update arrangements |
| `goals:read` | Read | View goals and objectives |
| `goals:write` | Write | Create/update goals |
| `risk:read` | Read | View risk profiles |
| `risk:write` | Write | Create/update risk assessments |
| `admin:*` | Admin | Full administrative access |

**Scope Naming Convention:**
```
{domain}:{permission}:{sensitivity}
```

Examples:
- `client:read` - Read client data
- `client:pii:read` - Read sensitive PII
- `factfind:write` - Write fact find data
- `admin:users:write` - Admin user management

### 2.3 Multi-Tenancy

**Tenant Isolation:**

- Tenant ID extracted from JWT claims (`tenant_id`)
- All queries filtered by tenant ID automatically
- Cross-tenant access strictly prohibited
- Tenant data physically or logically separated

**Tenant Context:**
```http
GET /api/v1/factfinds/{factfindId}/clients HTTP/1.1
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
X-Tenant-ID: tenant-456

Response includes only clients for tenant-456
```

**Tenant-Level Configuration:**
- Reference data customization per tenant
- Feature flags per tenant
- Rate limits per tenant
- Branding and white-labeling

### 2.4 Sensitive Data Handling

**PII Fields (Personally Identifiable Information):**

Requires special scope: `client:pii:read`

- National Insurance Number
- Passport Number
- Driving License Number
- Date of Birth
- Full Address
- Bank Account Details

**Obfuscation Strategy:**

Default response (without `client:pii:read` scope):
```json
{
  "nationalInsuranceNumber": "AB****56C",
  "passportNumber": "5******21",
  "dateOfBirth": "****-**-15"
}
```

Full response (with `client:pii:read` scope):
```json
{
  "nationalInsuranceNumber": "AB123456C",
  "passportNumber": "502135321",
  "dateOfBirth": "1980-05-15"
}
```

### 2.5 Audit Logging

**Audit Requirements:**

All write operations (POST, PUT, PATCH, DELETE) are logged:

- User ID (from JWT)
- Tenant ID
- Timestamp
- Operation type (CREATE, UPDATE, DELETE)
- Resource type and ID
- Changed fields (before/after values)
- IP address
- Request ID (correlation)

**Audit Log Entry:**
```json
{
  "auditId": "audit-789",
  "timestamp": "2026-02-16T14:30:00Z",
  "tenantId": "tenant-456",
  "userId": "user-123",
  "operation": "UPDATE",
  "resourceType": "Client",
  "resourceId": "client-999",
  "changes": [
    {
      "field": "lastName",
      "oldValue": "Smith",
      "newValue": "Johnson"
    }
  ],
  "ipAddress": "203.0.113.42",
  "requestId": "req-abc-123"
}
```

---

## 3. Common Patterns

### 3.1 Pagination

**Cursor-Based Pagination (Preferred):**

Request:
```http
GET /api/v1/factfinds/{factfindId}/clients?limit=20&cursor=eyJpZCI6MTAwfQ==
```

Response:
```json
{
  "data": [
    { "id": 101, "firstName": "John", "lastName": "Smith" },
    { "id": 102, "firstName": "Jane", "lastName": "Doe" }
  ],
  "pagination": {
    "limit": 20,
    "hasMore": true,
    "nextCursor": "eyJpZCI6MTIwfQ==",
    "prevCursor": null
  },
  "_links": {
    "self": {
      "href": "/api/v1/clients?limit=20&cursor=eyJpZCI6MTAwfQ=="
    },
    "next": {
      "href": "/api/v1/clients?limit=20&cursor=eyJpZCI6MTIwfQ=="
    }
  }
}
```

**Offset-Based Pagination (Alternative):**

Request:
```http
GET /api/v1/factfinds/{factfindId}/clients?page=2&pageSize=20
```

Response:
```json
{
  "data": [...],
  "pagination": {
    "page": 2,
    "pageSize": 20,
    "totalPages": 10,
    "totalCount": 195
  },
  "_links": {
    "first": { "href": "/api/v1/clients?page=1&pageSize=20" },
    "prev": { "href": "/api/v1/clients?page=1&pageSize=20" },
    "self": { "href": "/api/v1/clients?page=2&pageSize=20" },
    "next": { "href": "/api/v1/clients?page=3&pageSize=20" },
    "last": { "href": "/api/v1/clients?page=10&pageSize=20" }
  }
}
```

### 3.2 Filtering & Sorting

**Query Parameters:**

```http
GET /api/v1/factfinds/{factfindId}/clients?status=Active&clientType=Person&sortBy=lastName&sortOrder=asc
```

**Supported Filters:**
- Equality: `?status=Active`
- Multiple values: `?status=Active,Prospect`
- Date ranges: `?createdAfter=2026-01-01&createdBefore=2026-12-31`
- Boolean flags: `?isActive=true&hasWill=false`
- Text search: `?search=smith` (searches across multiple fields)

**Sorting:**
- Single field: `?sortBy=lastName&sortOrder=asc`
- Multiple fields: `?sortBy=lastName,firstName&sortOrder=asc,asc`
- Shorthand: `?sort=lastName,-createdAt` (minus = desc)

### 3.3 Field Selection (Sparse Fieldsets)

Following the Single Contract Principle (see Section 1.7), the API uses field selection for partial responses rather than creating separate "summary" or "list" DTOs. The same entity contract is returned with only the requested fields populated.

**Select Specific Fields:**
```http
GET /api/v1/factfinds/{factfindId}/clients/123?fields=id,firstName,lastName,dateOfBirth
```

Response returns the `Client` contract with only requested fields populated:
```json
{
  "id": 123,
  "firstName": "John",
  "lastName": "Smith",
  "dateOfBirth": "1980-05-15"
}
```

**Exclude Fields:**
```http
GET /api/v1/factfinds/{factfindId}/clients/123?exclude=notes,medicalConditions
```

### 3.4 Resource Expansion

**Embed Related Resources:**

Reference types (entities with identity) can be expanded to include their full entity data inline. This applies to fields ending with "Ref" (e.g., `clientRef`, `adviserRef`). Value types are always fully embedded by default.

**Default response (minimal references):**
```http
GET /api/v1/factfinds/factfind-123
```
```json
{
  "id": "factfind-123",
  "factFindNumber": "FF001234",
  "clientRef": {
    "id": "client-456",
    "href": "/api/v1/clients/client-456",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },
  "totalNetMonthlyIncome": {
    "amount": 7500.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
  }
}
```

**Expanded response (full referenced entities):**
```http
GET /api/v1/factfinds/factfind-123?expand=clientRef,adviserRef
```
```json
{
  "id": "factfind-123",
  "factFindNumber": "FF001234",
  "clientRef": {
    "id": "client-456",
    "href": "/api/v1/clients/client-456",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person",
    // Full Client entity expanded
    "dateOfBirth": "1980-05-15",
    "age": 45,
    "grossAnnualIncome": {
      "amount": 75000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "primaryAddress": {
      "line1": "123 Main Street",
      "city": "London",
      "postcode": "SW1A 1AA",
      "country": "GB"
    }
  },
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001",
    // Full Adviser entity expanded
    "email": "jane.doe@example.com",
    "phone": "+44 20 1234 5678"
  },
  "totalNetMonthlyIncome": {
    "amount": 7500.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
  }
}
```

**Expansion Rules:**
- Use `?expand=fieldName` query parameter
- Multiple fields: `?expand=clientRef,adviserRef,providerRef`
- Nested expansion: `?expand=clientRef.employmentRef` (expand client, then employment within client)
- Only reference types (with "Ref" suffix) can be expanded
- Value types (MoneyValue, AddressValue, etc.) are always fully embedded
- Maximum expansion depth: 2 levels to prevent excessive response sizes

### 3.5 Optimistic Concurrency Control

**ETag-Based Locking:**

1. Client retrieves resource:
```http
GET /api/v1/factfinds/{factfindId}/clients/123

Response:
ETag: "33a64df551425fcc55e4d42a148795d9f25f89d4"
```

2. Client updates resource with If-Match:
```http
PUT /api/v1/clients/123
If-Match: "33a64df551425fcc55e4d42a148795d9f25f89d4"

{
  "firstName": "John",
  "lastName": "Johnson"
}
```

3. Success or conflict:
```http
Success (200 OK):
ETag: "9b8769a4f1dce434b9b9c5c82b68b61c0e7f9a5d"

Conflict (409 Conflict):
{
  "type": "https://api.factfind.com/problems/conflict-error",
  "title": "Concurrent Modification",
  "status": 409,
  "detail": "Resource has been modified by another user"
}
```

### 3.6 Batch Operations

**Bulk Create:**
```http
POST /api/v1/factfinds/{factfindId}/clients/bulk
Content-Type: application/json

{
  "clients": [
    {
      "firstName": "John",
      "lastName": "Smith",
      "clientType": "Person"
    },
    {
      "firstName": "Jane",
      "lastName": "Doe",
      "clientType": "Person"
    }
  ]
}

Response (207 Multi-Status):
{
  "results": [
    {
      "status": 201,
      "id": 101,
      "href": "/api/v1/factfinds/{factfindId}/clients/101"
    },
    {
      "status": 400,
      "error": {
        "type": "validation-error",
        "message": "Invalid client type"
      }
    }
  ]
}
```

### 3.7 HATEOAS (Hypermedia Controls)

**Resource Links:**

```json
{
  "id": 123,
  "firstName": "John",
  "lastName": "Smith",
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/{factfindId}/clients/123"
    },
    "update": {
      "href": "/api/v1/factfinds/{factfindId}/clients/123",
      "method": "PUT"
    },
    "delete": {
      "href": "/api/v1/factfinds/{factfindId}/clients/123",
      "method": "DELETE"
    },
    "addresses": {
      "href": "/api/v1/clients/123/addresses"
    },
    "factfinds": {
      "href": "/api/v1/factfinds?clientId=123"
    }
  }
}
```

**Conditional Links (State-Based):**

```json
{
  "id": 123,
  "status": {
    "code": "DRAFT",
    "display": "Draft"
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/123" },
    "complete": {
      "href": "/api/v1/factfinds/123/complete",
      "method": "POST",
      "enabled": true
    },
    "archive": {
      "href": "/api/v1/factfinds/123/archive",
      "method": "POST",
      "enabled": false,
      "reason": "Cannot archive draft fact find"
    }
  }
}
```

### 3.8 Data Types

**Money (Currency):**
Uses `MoneyValue` with nested `CurrencyValue`:
```json
{
  "grossAnnualIncome": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  }
}
```

**Date and DateTime (ISO 8601):**
```json
{
  "dateOfBirth": "1980-05-15",
  "createdAt": "2026-02-16T14:30:00Z",
  "updatedAt": "2026-02-16T15:45:00Z"
}
```

**Percentage:**
```json
{
  "interestRate": 4.75,
  "ownershipPercentage": 50.0
}
```

**Address:**
Uses `AddressValue` with nested `CountryValue` and `CountyValue`:
```json
{
  "address": {
    "line1": "123 High Street",
    "line2": "Apartment 4B",
    "city": "London",
    "postcode": "SW1A 1AA",
    "county": {
      "code": "GLA",
      "display": "Greater London"
    },
    "country": {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    },
    "addressType": {
      "code": "RES",
      "display": "Residential"
    }
  }
}
```

**Enumeration Value Types:**
All enumerations use structured Value Types with code/display pattern:
```json
{
  "gender": {
    "code": "M",
    "display": "Male"
  },
  "maritalStatus": {
    "code": "MAR",
    "display": "Married",
    "effectiveFrom": "2015-06-20"
  },
  "employmentStatus": {
    "code": "EMP",
    "display": "Employed"
  }
}
```

**Key Benefits:**
- **Self-Documenting**: No need to look up code meanings
- **Internationalization**: Display text can be localized
- **Rich Metadata**: Additional context fields (dates, categories, etc.)
- **Forward-Compatible**: New fields can be added without breaking changes
- **Type-Safe**: Strongly typed in contract definitions

See Section 11.10.9 for complete enumeration value type definitions.

---

## 4. FactFind API (Root Aggregate)

### 4.1 Overview

**Purpose:** Manage client identities, relationships, and regulatory onboarding requirements.

**Scope:**
- Client registration (Person, Corporate, Trust)
- Contact details management
- Address management
- Identity verification (KYC/AML)
- Data protection consent (GDPR)
- Marketing preferences
- Vulnerability assessments
- Professional contacts (solicitors, accountants)
- Family relationships and dependants

**Aggregate Root:** FactFind (clients are nested within)

**Regulatory Compliance:**
- FCA COBS (Client Classification)
- Money Laundering Regulations 2017 (AML/CTF)
- GDPR (Data Protection)
- Consumer Duty (Vulnerable Customers)

### 4.2 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/clients` | List clients with filtering | `client:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients` | Create new client | `client:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}` | Get client details | `client:read` |
| PUT | `/api/v1/factfinds/{factfindId}/clients/{clientId}` | Update client | `client:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}` | Delete client (soft delete) | `client:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/addresses` | List client addresses | `client:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/addresses` | Add address | `client:write` |
| PUT | `/api/v1/factfinds/{factfindId}/clients/{clientId}/addresses/{id}` | Update address | `client:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/addresses/{id}` | Remove address | `client:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/contacts` | List contact details | `client:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/contacts` | Add contact detail | `client:write` |
| PUT | `/api/v1/factfinds/{factfindId}/clients/{clientId}/contacts/{id}` | Update contact | `client:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/contacts/{id}` | Remove contact | `client:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/relationships` | List relationships | `client:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/relationships` | Create relationship | `client:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/relationships/{id}` | Remove relationship | `client:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/dependants` | List dependants | `client:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/dependants` | Add dependant | `client:write` |
| PUT | `/api/v1/factfinds/{factfindId}/clients/{clientId}/dependants/{id}` | Update dependant | `client:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/dependants/{id}` | Remove dependant | `client:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/id-verification` | Get ID verification docs | `client:pii:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/id-verification` | Upload ID document | `client:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/dpa-consent` | Get data protection consent | `client:read` |
| PUT | `/api/v1/factfinds/{factfindId}/clients/{clientId}/dpa-consent` | Update DPA consent | `client:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/marketing-consent` | Get marketing preferences | `client:read` |
| PUT | `/api/v1/factfinds/{factfindId}/clients/{clientId}/marketing-consent` | Update marketing consent | `client:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/vulnerability` | Get vulnerability assessment | `client:read` |
| PUT | `/api/v1/factfinds/{factfindId}/clients/{clientId}/vulnerability` | Update vulnerability | `client:write` |

### 4.3 Key Endpoints

#### 4.3.1 Create Client

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients`

**Description:** Create a new client record (Person, Corporate, or Trust).

**Contract:** Uses the unified `Client` contract (see Section 11.1). The same contract structure is used for request and response. Read-only fields (`id`, `createdAt`, `updatedAt`, computed fields) are ignored in the request and populated by the server in the response.

**Request Headers:**
```http
Content-Type: application/json
Authorization: Bearer {token}
```

**Request Body (Person):**
Client contract with required-on-create fields. Read-only and computed fields are ignored.
```json
{
  "clientType": "Person",
  "name": {
    "title": {
      "code": "MR",
      "display": "Mr"
    },
    "firstName": "John",
    "middleName": "Michael",
    "lastName": "Smith",
    "preferredName": "John"
  },
  "salutation": "Mr Smith",
  "dateOfBirth": "1980-05-15",
  "gender": {
    "code": "M",
    "display": "Male"
  },
  "maritalStatus": {
    "code": "MAR",
    "display": "Married"
  },
  "taxDetails": {
    "niNumber": "AB123456C"
  },
  "nationalityCountry": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "countryOfBirth": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "countryOfResidence": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "isUkResident": true,
  "isExpatriate": false,
  "isDeceased": false,
  "hasEverSmoked": false,
  "inGoodHealth": true,
  "hasWill": true,
  "isWillUpToDate": true,
  "isPowerOfAttorneyGranted": false,
  "adviserRef": {
    "id": "adviser-789"
  }
}
```

**Response:**
Complete `Client` contract with all fields populated, including server-generated fields.

```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/{factfindId}/clients/123
ETag: "33a64df551425fcc55e4d42a148795d9f25f89d4"
Content-Type: application/json

{
  "id": "client-123",
  "clientNumber": "C00001234",
  "clientType": "Person",
  "name": {
    "title": {
      "code": "MR",
      "display": "Mr"
    },
    "firstName": "John",
    "middleName": "Michael",
    "lastName": "Smith",
    "preferredName": "John"
  },
  "fullName": "Mr John Michael Smith",
  "salutation": "Mr Smith",
  "dateOfBirth": "1980-05-15",
  "age": 45,
  "gender": {
    "code": "M",
    "display": "Male"
  },
  "maritalStatus": {
    "code": "MAR",
    "display": "Married"
  },
  "taxDetails": {
    "niNumber": "AB123456C"
  },
  "nationalityCountry": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "countryOfBirth": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "countryOfResidence": {
    "code": "GB",
    "name": "United Kingdom"
  },
  "isUkResident": true,
  "isExpatriate": false,
  "isDeceased": false,
  "hasEverSmoked": false,
  "isSmoker": "Never",
  "inGoodHealth": true,
  "hasWill": true,
  "isWillUpToDate": true,
  "isPowerOfAttorneyGranted": false,
  "primaryAdviser": {
    "id": 789,
    "firstName": "Jane",
    "lastName": "Doe",
    "href": "/api/v1/advisers/789"
  },
  "serviceStatus": "Active",
  "clientSegment": "A",
  "createdAt": "2026-02-16T14:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "createdBy": {
    "id": 999,
    "name": "System Admin"
  },
  "updatedBy": {
    "id": 999,
    "name": "System Admin"
  },
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/{factfindId}/clients/123"
    },
    "update": {
      "href": "/api/v1/factfinds/{factfindId}/clients/123",
      "method": "PUT"
    },
    "addresses": {
      "href": "/api/v1/clients/123/addresses"
    },
    "contacts": {
      "href": "/api/v1/clients/123/contacts"
    },
    "factfinds": {
      "href": "/api/v1/factfinds?clientId=123"
    },
    "arrangements": {
      "href": "/api/v1/arrangements?clientId=123"
    }
  }
}
```

**Status Codes:**
- `201 Created` - Client created successfully
- `400 Bad Request` - Validation errors
- `401 Unauthorized` - Invalid or missing authentication token
- `403 Forbidden` - Insufficient permissions
- `409 Conflict` - Client with same NI number already exists

**Validation Rules:**
- `firstName` - Required, max 100 characters
- `lastName` - Required, max 100 characters
- `dateOfBirth` - Required, must be in past, minimum age 18
- `nationalInsuranceNumber` - Optional, UK NI format validation
- `clientType` - Required, one of: Person, Corporate, Trust
- `gender` - Required for Person, one of: Male, Female, Other, PreferNotToSay
- `maritalStatus` - Optional, one of: Single, Married, Divorced, Widowed, CivilPartnership, Separated

**Business Rules:**
- National Insurance Number must be unique across all clients
- Date of Birth must represent age 18 or older for full client
- UK resident requires UK address
- Primary adviser must be an active adviser in the system

#### 4.3.2 Get Client

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}`

**Description:** Retrieve complete client details including demographic information.

**Contract:** Returns the complete unified `Client` contract (see Section 11.1) with all fields populated.

**Request Headers:**
```http
Authorization: Bearer {token}
```

**Query Parameters:**
- `expand` (optional) - Comma-separated list: `addresses,contacts,dependants,relationships`
- `fields` (optional) - Comma-separated field list for sparse fieldsets (returns `Client` contract with only requested fields)

**Response:**
Complete `Client` contract.
```json
{
  "id": 123,
  "clientType": "Person",
  "name": {
    "title": {
      "code": "MR",
      "display": "Mr"
    },
    "firstName": "John",
    "middleName": "Michael",
    "lastName": "Smith"
  },
  "fullName": "Mr John Michael Smith",
  "dateOfBirth": "1980-05-15",
  "age": 45,
  "gender": {
    "code": "M",
    "display": "Male"
  },
  "maritalStatus": {
    "code": "MAR",
    "display": "Married",
    "effectiveFrom": "2005-06-20"
  },
  "nationalInsuranceNumber": "AB123456C",
  "nationalityCountry": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "countryOfBirth": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "countryOfResidence": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "isUkResident": true,
  "isExpatriate": false,
  "hasWill": true,
  "isWillUpToDate": true,
  "willDetails": "Will created in 2020, held by Smith & Co Solicitors",
  "isPowerOfAttorneyGranted": false,
  "hasEverSmoked": false,
  "isSmoker": "Never",
  "inGoodHealth": true,
  "serviceStatus": "Active",
  "serviceStatusDate": "2020-01-15",
  "clientSegment": "A",
  "clientSegmentDate": "2020-01-15",
  "grossAnnualIncome": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "netWorth": {
    "amount": 450000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalAssets": {
    "amount": 500000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "householdIncome": {
    "amount": 120000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "primaryAdviser": {
    "id": 789,
    "firstName": "Jane",
    "lastName": "Doe",
    "email": "jane.doe@example.com",
    "href": "/api/v1/advisers/789"
  },
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/{factfindId}/clients/123" },
    "update": { "href": "/api/v1/factfinds/{factfindId}/clients/123", "method": "PUT" },
    "addresses": { "href": "/api/v1/clients/123/addresses" },
    "contacts": { "href": "/api/v1/clients/123/contacts" },
    "relationships": { "href": "/api/v1/clients/123/relationships" },
    "dependants": { "href": "/api/v1/clients/123/dependants" },
    "factfinds": { "href": "/api/v1/factfinds?clientId=123" },
    "arrangements": { "href": "/api/v1/arrangements?clientId=123" },
    "goals": { "href": "/api/v1/goals?clientId=123" }
  }
}
```

**Status Codes:**
- `200 OK` - Client retrieved successfully
- `401 Unauthorized` - Invalid authentication
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Client does not exist

#### 4.3.3 List Clients

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients`

**Description:** List clients with filtering, sorting, and pagination.

**Contract:** Returns collection wrapper (see Section 11.8) containing an array of `Client` contracts. Use `fields` query parameter for sparse fieldsets.

**Query Parameters:**
- `search` (optional) - Full-text search across name fields
- `clientType` (optional) - Filter by type: Person, Corporate, Trust
- `serviceStatus` (optional) - Filter by status: Active, Inactive, Prospect
- `adviserId` (optional) - Filter by primary adviser
- `hasWill` (optional) - Filter by will status: true, false
- `maritalStatus` (optional) - Filter by marital status
- `sortBy` (optional) - Sort field: lastName, firstName, createdAt (default: lastName)
- `sortOrder` (optional) - Sort direction: asc, desc (default: asc)
- `limit` (optional) - Page size (default: 20, max: 100)
- `cursor` (optional) - Pagination cursor
- `expand` (optional) - Include related resources: addresses, contacts
- `fields` (optional) - Comma-separated field list for sparse fieldsets (e.g., `id,fullName,serviceStatus`)

**Response:**
Collection wrapper with array of `Client` contracts (partial fields shown for brevity).

```json
{
  "data": [
    {
      "id": 123,
      "clientType": "Person",
      "fullName": "Mr John Smith",
      "firstName": "John",
      "lastName": "Smith",
      "dateOfBirth": "1980-05-15",
      "age": 45,
      "maritalStatus": "Married",
      "serviceStatus": "Active",
      "primaryAdviser": {
        "id": 789,
        "name": "Jane Doe",
        "href": "/api/v1/advisers/789"
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/{factfindId}/clients/123" }
      }
    },
    {
      "id": 124,
      "clientType": "Person",
      "fullName": "Mrs Sarah Smith",
      "firstName": "Sarah",
      "lastName": "Smith",
      "dateOfBirth": "1982-08-22",
      "age": 43,
      "maritalStatus": "Married",
      "serviceStatus": "Active",
      "primaryAdviser": {
        "id": 789,
        "name": "Jane Doe",
        "href": "/api/v1/advisers/789"
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/{factfindId}/clients/124" }
      }
    }
  ],
  "pagination": {
    "limit": 20,
    "hasMore": true,
    "nextCursor": "eyJpZCI6MTI0fQ==",
    "totalCount": 156
  },
  "_links": {
    "self": {
      "href": "/api/v1/clients?limit=20"
    },
    "next": {
      "href": "/api/v1/clients?limit=20&cursor=eyJpZCI6MTI0fQ=="
    }
  }
}
```

#### 4.3.4 Add Address

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{id}/addresses`

**Description:** Add a new address for a client (residential, correspondence, etc.).

**Request Body:**
```json
{
  "addressType": "Residential",
  "addressLine1": "123 High Street",
  "addressLine2": "Apartment 4B",
  "city": "London",
  "postcode": "SW1A 1AA",
  "county": {
    "code": "GB-LND",
    "name": "London"
  },
  "country": {
    "code": "GB",
    "name": "United Kingdom"
  },
  "correspondenceAddress": true,
  "residentFromDate": "2020-01-15",
  "residencyStatus": "Owner",
  "isOnElectoralRoll": true
}
```

**Response:**
```http
HTTP/1.1 201 Created
Location: /api/v1/clients/client-123/addresses/address-456

{
  "id": "address-456",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
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
  "isCorrespondenceAddress": true,
  "residencyPeriod": {
    "startDate": "2020-01-15",
    "endDate": null
  },
  "residencyStatus": "Owner",
  "isOnElectoralRoll": true,
  "durationAtAddressYears": 6,
  "durationAtAddressMonths": 1,
  "createdAt": "2026-02-16T14:30:00Z",
  "_links": {
    "self": { "href": "/api/v1/clients/client-123/addresses/address-456" },
    "client": { "href": "/api/v1/clients/client-123" }
  }
}
```

**Validation Rules:**
- `addressLine1` - Required, max 100 characters
- `city` - Required, max 50 characters
- `postcode` - Required for UK addresses, format validation
- `country` - Required
- `addressType` - Required, one of: Residential, Correspondence, Previous, Business
- `residencyStatus` - Optional, one of: Owner, Tenant, LivingWithFamily, Other

#### 4.3.5 Update Vulnerability Assessment

**Endpoint:** `PUT /api/v1/factfinds/{factfindId}/clients/{clientId}/vulnerability`

**Description:** Update client vulnerability assessment for Consumer Duty compliance.

**Request Body:**
```json
{
  "hasVulnerability": "Yes",
  "vulnerabilityType": "Physical",
  "vulnerabilityCategory": "HealthCondition",
  "vulnerabilityActionTakenDetails": "Large print documents provided, additional time given during meetings, family member invited to participate",
  "isClientPortalSuitable": "WithSupport",
  "clientPortalSuitabilityDetails": "Can use portal with assistance from family member",
  "dateAssessed": "2026-02-16",
  "reviewDate": "2026-08-16"
}
```

**Response:**
```json
{
  "id": "vulnerability-789",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "hasVulnerability": "Yes",
  "vulnerabilityType": "Physical",
  "vulnerabilityCategory": "HealthCondition",
  "vulnerabilityActionTakenDetails": "Large print documents provided, additional time given during meetings, family member invited to participate",
  "isClientPortalSuitable": "WithSupport",
  "clientPortalSuitabilityDetails": "Can use portal with assistance from family member",
  "dateAssessed": "2026-02-16",
  "reviewDate": "2026-08-16",
  "updatedAt": "2026-02-16T14:30:00Z",
  "updatedBy": {
    "id": "user-999",
    "name": "Jane Doe"
  },
  "_links": {
    "self": { "href": "/api/v1/clients/123/vulnerability" },
    "client": { "href": "/api/v1/factfinds/{factfindId}/clients/123" },
    "history": { "href": "/api/v1/clients/123/vulnerability/history" }
  }
}
```

**Validation Rules:**
- `hasVulnerability` - Required, one of: Yes, No, Unknown
- `vulnerabilityType` - Required if hasVulnerability=Yes, one of: Physical, Mental, Financial, LifeEvent
- `dateAssessed` - Required, must not be in future
- `reviewDate` - Optional, must be after dateAssessed

**Business Rules:**
- Review date should typically be 6-12 months after assessment
- Action taken details required if vulnerability identified
- Assessment triggers notification to primary adviser

---

## 5. FactFind Clients API

### 5.1 Overview

**Purpose:** Capture comprehensive client circumstances and current financial position for financial planning.

**Scope:**
- Fact find session management (ADVICE_CASE aggregate root)
- Employment history and current employment
- Income from all sources (employed, self-employed, investment, rental, etc.)
- Expenditure tracking (essential vs discretionary)
- Expenditure and income changes (future projections)
- Budget analysis and affordability calculations
- Emergency fund assessment

**Aggregate Root:** ADVICE_CASE (FactFind)

**Regulatory Compliance:**
- FCA COBS 9.2 (Assessing Suitability)
- MCOB (Mortgage affordability)
- Consumer Duty (Understanding customer needs)

### 5.2 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds` | List fact finds | `factfind:read` |
| POST | `/api/v1/factfinds` | Create new fact find | `factfind:write` |
| GET | `/api/v1/factfinds/{id}` | Get fact find summary | `factfind:read` |
| PUT | `/api/v1/factfinds/{id}` | Update fact find | `factfind:write` |
| DELETE | `/api/v1/factfinds/{id}` | Delete fact find | `factfind:write` |
| POST | `/api/v1/factfinds/{id}/complete` | Mark fact find as complete | `factfind:write` |
| GET | `/api/v1/factfinds/{id}/summary` | Get financial summary | `factfind:read` |
| GET | `/api/v1/factfinds/{id}/employment` | List employment records | `factfind:read` |
| POST | `/api/v1/factfinds/{id}/employment` | Add employment | `factfind:write` |
| PUT | `/api/v1/factfinds/{id}/employment/{empId}` | Update employment | `factfind:write` |
| DELETE | `/api/v1/factfinds/{id}/employment/{empId}` | Remove employment | `factfind:write` |
| GET | `/api/v1/factfinds/{id}/income` | List income sources | `factfind:read` |
| POST | `/api/v1/factfinds/{id}/income` | Add income | `factfind:write` |
| PUT | `/api/v1/factfinds/{id}/income/{incomeId}` | Update income | `factfind:write` |
| DELETE | `/api/v1/factfinds/{id}/income/{incomeId}` | Remove income | `factfind:write` |
| GET | `/api/v1/factfinds/{id}/expenditure` | List expenditure | `factfind:read` |
| POST | `/api/v1/factfinds/{id}/expenditure` | Add expenditure | `factfind:write` |
| PUT | `/api/v1/factfinds/{id}/expenditure/{expId}` | Update expenditure | `factfind:write` |
| DELETE | `/api/v1/factfinds/{id}/expenditure/{expId}` | Remove expenditure | `factfind:write` |
| GET | `/api/v1/factfinds/{id}/income-changes` | List expected income changes | `factfind:read` |
| POST | `/api/v1/factfinds/{id}/income-changes` | Add income change | `factfind:write` |
| GET | `/api/v1/factfinds/{id}/expenditure-changes` | List expected expenditure changes | `factfind:read` |
| POST | `/api/v1/factfinds/{id}/expenditure-changes` | Add expenditure change | `factfind:write` |
| GET | `/api/v1/factfinds/{id}/affordability` | Calculate affordability | `factfind:read` |
| GET | `/api/v1/factfinds/{id}/complete` | Get complete aggregate | `factfind:read` |

### 5.3 Key Endpoints

#### 5.3.1 Create FactFind

**Endpoint:** `POST /api/v1/factfinds`

**Description:** Create a new fact find session for a client or joint clients.

**Contract:** Uses the unified `FactFind` contract (see Section 11.2). Request includes required-on-create fields; response includes complete contract with server-generated fields.

**Request Body:**
FactFind contract with required-on-create fields. Read-only and computed fields are ignored.


```json
{
  "client": {
    "id": 123
  },
  "jointClient": {
    "id": 124
  },
  "dateOfMeeting": "2026-02-16",
  "typeOfMeeting": "InitialConsultation",
  "scopeOfAdvice": [
    "RetirementPlanning",
    "InvestmentAdvice",
    "ProtectionReview"
  ],
  "primaryAdviser": {
    "id": 789
  },
  "anybodyElsePresent": false,
  "customQuestions": [
    {
      "question": "What are your main financial concerns?",
      "answer": "Ensuring sufficient retirement income and protecting family"
    }
  ]
}
```

**Response:**
Complete `FactFind` contract with all fields populated.

```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/456
ETag: "a1b2c3d4e5f6"

{
  "id": 456,
  "client": {
    "id": 123,
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/{factfindId}/clients/123"
  },
  "jointClient": {
    "id": 124,
    "fullName": "Sarah Smith",
    "href": "/api/v1/factfinds/{factfindId}/clients/124"
  },
  "dateOfMeeting": "2026-02-16",
  "typeOfMeeting": "InitialConsultation",
  "scopeOfAdvice": [
    "RetirementPlanning",
    "InvestmentAdvice",
    "ProtectionReview"
  ],
  "primaryAdviser": {
    "id": 789,
    "fullName": "Jane Doe",
    "href": "/api/v1/advisers/789"
  },
  "isComplete": false,
  "dateFactFindCompleted": null,
  "anybodyElsePresent": false,
  "status": {
    "code": "INPROG",
    "display": "In Progress"
  },
  "createdAt": "2026-02-16T14:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/456" },
    "complete": { "href": "/api/v1/factfinds/456/complete", "method": "POST" },
    "employment": { "href": "/api/v1/factfinds/456/employment" },
    "income": { "href": "/api/v1/factfinds/456/income" },
    "expenditure": { "href": "/api/v1/factfinds/456/expenditure" },
    "summary": { "href": "/api/v1/factfinds/456/summary" }
  }
}
```

**Validation Rules:**
- `client` - Required, must be existing client
- `dateOfMeeting` - Required, must not be in future
- `typeOfMeeting` - Required, one of: InitialConsultation, Review, AdHoc, Annual, SixMonth
- `scopeOfAdvice` - Required, array, min 1 item

**Business Rules:**
- Joint fact find requires jointClient reference
- Single client fact find has null jointClient
- Primary adviser must be active adviser
- Scope of advice determines required sections

#### 5.3.2 Add Income

**Endpoint:** `POST /api/v1/factfinds/{id}/income`

**Description:** Add an income source to the fact find.

**Contract:** Uses the unified `Income` contract (see Section 11.4). The same contract is used for request and response.

**Request Body:**
Income contract with required-on-create fields.


```json
{
  "owner": "Client1",
  "category": "EmployedIncome",
  "description": "Primary employment salary",
  "employment": {
    "id": 789
  },
  "basicIncomeGross": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "basicIncomeNet": {
    "amount": 52500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "frequencyGross": {
    "code": "A",
    "display": "Annual",
    "periodsPerYear": 1
  },
  "frequencyNet": {
    "code": "A",
    "display": "Annual",
    "periodsPerYear": 1
  },
  "hasOvertimeIncome": true,
  "guaranteedOvertimeGross": {
    "amount": 5000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "hasBonusIncome": true,
  "regularBonusGross": {
    "amount": 10000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "includeInAffordability": true,
  "includeBasicIncomeInAffordability": true,
  "includeGuaranteedOvertimeInAffordability": true,
  "includeRegularBonusInAffordability": true,
  "startDate": "2020-01-15",
  "endDate": null
}
```

**Response:**
```json
{
  "id": 999,
  "factfindId": 456,
  "owner": "Client1",
  "category": "EmployedIncome",
  "description": "Primary employment salary",
  "employment": {
    "id": 789,
    "employer": "ACME Corporation Ltd",
    "occupation": "Senior Software Engineer",
    "href": "/api/v1/factfinds/456/employment/789"
  },
  "basicIncomeGross": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "basicIncomeNet": {
    "amount": 52500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "frequencyGross": {
    "code": "A",
    "display": "Annual",
    "periodsPerYear": 1
  },
  "frequencyNet": {
    "code": "A",
    "display": "Annual",
    "periodsPerYear": 1
  },
  "hasOvertimeIncome": true,
  "guaranteedOvertimeGross": {
    "amount": 5000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "guaranteedOvertimeNet": {
    "amount": 3500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "hasBonusIncome": true,
  "regularBonusGross": {
    "amount": 10000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "regularBonusNet": {
    "amount": 7000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalGrossAnnualEarnings": {
    "amount": 90000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "netMonthlyIncome": {
    "amount": 5250.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "includeInAffordability": true,
  "includeBasicIncomeInAffordability": true,
  "includeGuaranteedOvertimeInAffordability": true,
  "includeRegularBonusInAffordability": true,
  "startDate": "2020-01-15",
  "endDate": null,
  "createdAt": "2026-02-16T14:35:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/456/income/999" },
    "factfind": { "href": "/api/v1/factfinds/456" },
    "employment": { "href": "/api/v1/factfinds/456/employment/789" }
  }
}
```

**Income Categories:**
- `EmployedIncome` - Salary from employment
- `SelfEmployedIncome` - Self-employment profits
- `DividendIncome` - Company dividends
- `RentalIncome` - Property rental income
- `PensionIncome` - Pension payments
- `InvestmentIncome` - Investment returns
- `StateBedefits` - State benefits
- `MaintenanceIncome` - Maintenance payments
- `OtherIncome` - Other income sources

**Validation Rules:**
- `owner` - Required, one of: Client1, Client2, Joint
- `category` - Required, see categories above
- `basicIncomeGross` - Required, amount > 0
- `frequencyGross` - Required, one of: Annual, Monthly, Weekly, Quarterly
- Income amounts must be positive
- Net income must be less than gross income
- Employment link required for EmployedIncome category

#### 5.3.3 Add Expenditure

**Endpoint:** `POST /api/v1/factfinds/{id}/expenditure`

**Description:** Add an expenditure item (essential or discretionary).

**Request Body:**
```json
{
  "owner": "Joint",
  "category": "Mortgage",
  "description": "Primary residence mortgage payment",
  "netAmount": {
    "amount": 1500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "discretionaryAmount": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "frequency": {
    "code": "M",
    "display": "Monthly",
    "periodsPerYear": 12
  },
  "liability": {
    "id": 555
  }
}
```

**Response:**
```json
{
  "id": 888,
  "factfindId": 456,
  "owner": "Joint",
  "category": "Mortgage",
  "description": "Primary residence mortgage payment",
  "netAmount": {
    "amount": 1500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "discretionaryAmount": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "essentialAmount": {
    "amount": 1500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "frequency": {
    "code": "M",
    "display": "Monthly",
    "periodsPerYear": 12
  },
  "annualAmount": {
    "amount": 18000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "liability": {
    "id": 555,
    "type": "Mortgage",
    "provider": "UK Building Society",
    "href": "/api/v1/factfinds/{factfindId}/arrangements/555"
  },
  "createdAt": "2026-02-16T14:40:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/456/expenditure/888" },
    "factfind": { "href": "/api/v1/factfinds/456" },
    "liability": { "href": "/api/v1/factfinds/{factfindId}/arrangements/555" }
  }
}
```

**Expenditure Categories:**
- `Mortgage` - Mortgage payments
- `Rent` - Rental payments
- `UtilitiesGas` - Gas bills
- `UtilitiesElectric` - Electricity bills
- `UtilitiesWater` - Water bills
- `CouncilTax` - Council tax
- `Groceries` - Food and household shopping
- `Transport` - Car, fuel, public transport
- `Insurance` - General insurance premiums
- `ChildcareCosts` - Childcare and education
- `Entertainment` - Leisure and entertainment
- `HolidaysTravel` - Holidays and travel
- `ClothingFootwear` - Clothing and footwear
- `CommunicationsPhone` - Phone and internet
- `LoanRepayments` - Loan and credit repayments
- `Other` - Other expenditure

**Business Rules:**
- Essential expenditure: discretionaryAmount = 0
- Discretionary expenditure: discretionaryAmount > 0
- Total expenditure = netAmount = essentialAmount + discretionaryAmount
- Frequency determines annualization factor
- Linked liabilities affect affordability calculations

#### 5.3.4 Get FactFind Summary

**Endpoint:** `GET /api/v1/factfinds/{id}/summary`

**Description:** Get comprehensive financial summary with calculated totals.

**Response:**
```json
{
  "factfindId": 456,
  "client": {
    "id": 123,
    "fullName": "John Smith"
  },
  "jointClient": {
    "id": 124,
    "fullName": "Sarah Smith"
  },
  "incomeSummary": {
    "totalEarnedAnnualIncomeGross": {
      "amount": 120000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "totalNetMonthlyIncome": {
      "amount": 7500.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "client1Income": {
      "amount": 90000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "client2Income": {
      "amount": 30000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "incomeCount": 4,
    "incomeForAffordability": {
      "amount": 110000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    }
  },
  "expenditureSummary": {
    "totalMonthlyExpenditure": {
      "amount": 4500.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "totalEssentialExpenditure": {
      "amount": 3800.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "totalDiscretionaryExpenditure": {
      "amount": 700.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "client1Expenditure": {
      "amount": 500.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "client2Expenditure": {
      "amount": 300.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "jointExpenditure": {
      "amount": 3700.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "expenditureCount": 18
  },
  "disposableIncome": {
    "totalMonthlyDisposableIncome": {
      "amount": 3000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "netDisposableIncome": {
      "amount": 2300.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "discretionaryIncome": {
      "amount": 700.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    }
  },
  "emergencyFund": {
    "requiredAmount": {
      "amount": 11400.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "committedAmount": {
      "amount": 15000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "shortfall": {
      "amount": 0.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "monthsCovered": 3.3
  },
  "affordability": {
    "grossAnnualIncomeForAffordability": {
      "amount": 110000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "netMonthlyIncomeAvailable": {
      "amount": 7000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "monthlyDisposableIncome": {
      "amount": 2300.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "affordabilityRatio": 0.31,
    "stressTestedAffordability": {
      "amount": 2000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    }
  },
  "calculatedAt": "2026-02-16T14:45:00Z",
  "_links": {
    "factfind": { "href": "/api/v1/factfinds/456" },
    "income": { "href": "/api/v1/factfinds/456/income" },
    "expenditure": { "href": "/api/v1/factfinds/456/expenditure" },
    "affordability": { "href": "/api/v1/factfinds/456/affordability" }
  }
}
```

**Calculation Rules:**
- All amounts normalized to monthly for comparison
- Essential expenditure = netAmount - discretionaryAmount
- Disposable income = total income - total expenditure
- Emergency fund recommended = 3-6 months essential expenditure
- Affordability ratio = housing costs / gross income
- Stress test applies +3% interest rate increase

---

## 6. FactFind Income & Expenditure API

### 6.1 Overview

**Purpose:** Manage client's existing financial arrangements including pensions, investments, protection policies, and mortgages.

**Scope:**
- Pension arrangements (Personal Pension, SIPP, SSAS, Defined Benefit, State Pension)
- Investment arrangements (ISA, GIA, Offshore Bond, Onshore Bond, Investment Trust)
- Protection arrangements (Life Assurance, Critical Illness, Income Protection, PHI)
- Mortgage arrangements (Residential, Buy-to-Let, Commercial)
- Savings accounts
- General insurance (Home, Contents, Motor)
- Annuities (Lifetime, Fixed Term)
- Contributions tracking
- Valuations and performance
- Withdrawals and income

**Aggregate Root:** FactFind (arrangements are nested within)

**Regulatory Compliance:**
- FCA COBS (Suitability)
- Pension Transfer regulations (TVAS/AVAS)
- PROD (Product Governance)
- Consumer Duty (Value Assessment)

### 6.2 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/arrangements` | List arrangements with filters | `arrangements:read` |
| POST | `/api/v1/factfinds/{factfindId}/arrangements` | Create arrangement | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}` | Get arrangement details | `arrangements:read` |
| PUT | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}` | Update arrangement | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}` | Delete arrangement | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions` | List contributions | `arrangements:read` |
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions` | Add contribution | `arrangements:write` |
| PUT | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions/{id}` | Update contribution | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/valuations` | List valuations | `arrangements:read` |
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/valuations` | Add valuation | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/withdrawals` | List withdrawals/income | `arrangements:read` |
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/withdrawals` | Add withdrawal | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/beneficiaries` | List beneficiaries | `arrangements:read` |
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/beneficiaries` | Add beneficiary | `arrangements:write` |
| GET | `/api/v1/reference/arrangement-types` | List arrangement types | `arrangements:read` |

### 6.3 Key Endpoints

#### 6.3.1 Create Arrangement (Pension)

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/arrangements`

**Description:** Create a new arrangement (polymorphic - type determined by productType).

**Contract:** Uses the unified `Arrangement` contract (see Section 11.5). This is a polymorphic contract where `arrangementType` acts as a discriminator. Type-specific fields are included based on the arrangementType value.

**Request Body (Personal Pension SIPP):**
Arrangement contract with required-on-create fields and type-specific fields for pension arrangements.


```json
{
  "client": {
    "id": 123
  },
  "productType": {
    "code": "PP",
    "display": "Personal Pension",
    "category": "Pension"
  },
  "productSubType": "SIPP",
  "provider": {
    "id": 500,
    "name": "Vanguard"
  },
  "policyNumber": "PP-12345678",
  "productName": "Vanguard SIPP",
  "status": {
    "code": "INF",
    "display": "In Force"
  },
  "startDate": "2020-01-15",
  "owners": "Client1",
  "isPreExistingPlan": true,
  "isCurrentScheme": true,
  "pensionArrangement": "PersonalPension",
  "pensionTaxBasis": "Relief at Source",
  "normalRetirementAge": 65,
  "selectedRetirementAge": 65,
  "taxFreeCashOptions": "SchemeStandard",
  "schemeSpecificPclsADayFundValue": {
    "amount": 250000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "schemeSpecificPclsADayPclsValue": {
    "amount": 62500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "hasProtectedPcls": false,
  "isContributionsPaidBySalaryExchange": false,
  "showInPfpPortfolio": true,
  "isVisibleToClient": true
}
```

**Response:**
Complete `Arrangement` contract with all fields populated, including server-generated and computed fields.

```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/{factfindId}/arrangements/777

{
  "id": 777,
  "client": {
    "id": 123,
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/{factfindId}/clients/123"
  },
  "productType": {
    "code": "PP",
    "display": "Personal Pension",
    "category": "Pension"
  },
  "productSubType": "SIPP",
  "provider": {
    "id": 500,
    "name": "Vanguard",
    "href": "/api/v1/providers/500"
  },
  "policyNumber": "PP-12345678",
  "productName": "Vanguard SIPP",
  "status": {
    "code": "INF",
    "display": "In Force"
  },
  "startDate": "2020-01-15",
  "owners": "Client1",
  "isPreExistingPlan": true,
  "isCurrentScheme": true,
  "pensionArrangement": "PersonalPension",
  "pensionTaxBasis": "Relief at Source",
  "normalRetirementAge": 65,
  "selectedRetirementAge": 65,
  "taxFreeCashOptions": "SchemeStandard",
  "schemeSpecificPclsADayFundValue": {
    "amount": 250000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "schemeSpecificPclsADayPclsValue": {
    "amount": 62500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "hasProtectedPcls": false,
  "isContributionsPaidBySalaryExchange": false,
  "currentValue": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "showInPfpPortfolio": true,
  "isVisibleToClient": true,
  "createdAt": "2026-02-16T15:00:00Z",
  "updatedAt": "2026-02-16T15:00:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/{factfindId}/arrangements/777" },
    "update": { "href": "/api/v1/factfinds/{factfindId}/arrangements/777", "method": "PUT" },
    "contributions": { "href": "/api/v1/arrangements/777/contributions" },
    "valuations": { "href": "/api/v1/arrangements/777/valuations" },
    "withdrawals": { "href": "/api/v1/arrangements/777/withdrawals" },
    "client": { "href": "/api/v1/factfinds/{factfindId}/clients/123" }
  }
}
```

**Product Types:**

**Pensions:**
- `PersonalPension` (SIPP, SSAS, Group Personal Pension, Stakeholder)
- `OccupationalPension` (Defined Benefit, Defined Contribution, SASS, FSAVC)
- `StatePension` (Old State Pension, New State Pension)
- `Annuity` (Lifetime Annuity, Fixed Term Annuity, Enhanced Annuity)

**Investments:**
- `ISA` (Stocks & Shares ISA, Cash ISA, Lifetime ISA, Innovative Finance ISA)
- `GeneralInvestmentAccount` (GIA, Platform Account, Discretionary Management)
- `OffshoreBond` (Single Premium, Regular Premium)
- `OnshoreBond` (Investment Bond, Guaranteed Bond)
- `InvestmentTrust` (IT, OEIC, Unit Trust)

**Protection:**
- `LifeAssurance` (Term Life, Whole of Life, Universal Life)
- `CriticalIllnessCover` (Standalone, Accelerated)
- `IncomeProtection` (Personal, Group, ASU)
- `KeyPersonInsurance`

**Mortgages:**
- `ResidentialMortgage` (Repayment, Interest Only, Mixed)
- `BuyToLetMortgage`
- `CommercialMortgage`
- `EquityRelease` (Lifetime Mortgage, Home Reversion)

**Savings:**
- `SavingsAccount` (Instant Access, Notice Account, Fixed Rate Bond)
- `CashISA`

**General Insurance:**
- `BuildingsInsurance`
- `ContentsInsurance`
- `MotorInsurance`
- `TravelInsurance`

#### 6.3.2 Add Contribution

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/arrangements/{id}/contributions`

**Description:** Add a contribution to a pension or investment arrangement.

**Request Body:**
```json
{
  "contributionType": "Regular",
  "contributorType": "Member",
  "contributionFrequency": "Monthly",
  "contributionAmount": {
    "amount": 500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "contributionTaxBasis": "ReliefAtSource",
  "regularContributionAmountNetMember": {
    "amount": 400.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "regularContributionAmountGrossMember": {
    "amount": 500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "contributionStartsOn": "2020-01-15",
  "contributionStopsOn": null
}
```

**Response:**
```json
{
  "id": "contribution-888",
  "arrangementRef": {
    "id": "arrangement-777",
    "href": "/api/v1/arrangements/arrangement-777",
    "policyNumber": "POL123456",
    "productType": "Pension",
    "provider": "ABC Provider"
  },
  "contributionType": "Regular",
  "contributorType": "Member",
  "contributionFrequency": "Monthly",
  "contributionAmount": {
    "amount": 500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "contributionTaxBasis": "ReliefAtSource",
  "regularContributionAmountNetMember": {
    "amount": 400.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "regularContributionAmountGrossMember": {
    "amount": 500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "taxReliefAmount": {
    "amount": 100.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "annualContributionGross": {
    "amount": 6000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "contributionPeriod": {
    "startDate": "2020-01-15",
    "endDate": null
  },
  "isActive": true,
  "createdAt": "2026-02-16T15:05:00Z",
  "_links": {
    "self": { "href": "/api/v1/arrangements/arrangement-777/contributions/contribution-888" },
    "arrangement": { "href": "/api/v1/arrangements/arrangement-777" }
  }
}
```

**Validation Rules:**
- `contributionType` - Required, one of: Regular, Single, Transfer, EmployerContribution
- `contributionFrequency` - Required for Regular, one of: Monthly, Quarterly, Annual
- `contributionAmount` - Required, amount > 0
- Net + Tax Relief = Gross for Relief at Source
- Gross - Tax Relief = Net for Net Pay Arrangement

#### 6.3.3 Add Valuation

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/arrangements/{id}/valuations`

**Description:** Record a valuation for an arrangement.

**Request Body:**
```json
{
  "valuationDate": "2026-02-16",
  "valuationType": "Current",
  "currentValue": {
    "amount": 275000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "surrenderTransferValue": {
    "amount": 270000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
}
```

**Response:**
```json
{
  "id": "valuation-999",
  "arrangementRef": {
    "id": "arrangement-777",
    "href": "/api/v1/arrangements/arrangement-777",
    "policyNumber": "POL123456",
    "productType": "Pension",
    "provider": "ABC Provider"
  },
  "valuationDate": "2026-02-16",
  "valuationType": "Current",
  "currentValue": {
    "amount": 275000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "surrenderTransferValue": {
    "amount": 270000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  },
  "growthSinceLastValuation": {
    "amount": 25000.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  },
    "percentageGrowth": 10.0
  },
  "createdAt": "2026-02-16T15:10:00Z",
  "_links": {
    "self": { "href": "/api/v1/arrangements/777/valuations/999" },
    "arrangement": { "href": "/api/v1/factfinds/{factfindId}/arrangements/777" }
  }
}
```

**Valuation Types:**
- `Current` - Current market value
- `TransferValue` - Cash Equivalent Transfer Value (CETV) for DB pensions
- `Projection` - Projected future value
- `MaturityValue` - Expected maturity value

---

## 7. FactFind Arrangements API

### 7.1 Overview

**Purpose:** Capture and track client financial goals and objectives.

**Scope:**
- Short, medium, and long-term goal definition
- Protection goals (life cover, income protection, critical illness)
- Retirement planning goals (retirement age, desired income)
- Investment goals (lump sum targets, regular savings)
- Mortgage goals (house purchase, remortgage)
- Budget goals (spending limits, debt reduction)
- Estate planning goals (inheritance, trusts, gifting)
- Equity release goals
- Goal prioritization
- Funding allocation to goals
- Goal completion tracking

**Aggregate Root:** FactFind (goals are nested within)

**Regulatory Compliance:**
- FCA COBS (Understanding client objectives)
- Consumer Duty (Delivering good outcomes)
- PROD (Target Market assessment)

### 7.2 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/goals` | List goals | `goals:read` |
| POST | `/api/v1/factfinds/{factfindId}/goals` | Create goal | `goals:write` |
| GET | `/api/v1/factfinds/{factfindId}/goals/{goalId}` | Get goal details | `goals:read` |
| PUT | `/api/v1/factfinds/{factfindId}/goals/{goalId}` | Update goal | `goals:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/goals/{goalId}` | Delete goal | `goals:write` |
| POST | `/api/v1/factfinds/{factfindId}/goals/{goalId}/complete` | Mark goal as complete | `goals:write` |
| GET | `/api/v1/factfinds/{factfindId}/goals/{goalId}/objectives` | List objectives under goal | `goals:read` |
| POST | `/api/v1/factfinds/{factfindId}/goals/{goalId}/objectives` | Add objective to goal | `goals:write` |
| PUT | `/api/v1/goals/{id}/objectives/{objId}` | Update objective | `goals:write` |
| DELETE | `/api/v1/goals/{id}/objectives/{objId}` | Remove objective | `goals:write` |
| GET | `/api/v1/factfinds/{factfindId}/goals/{goalId}/funding` | Get goal funding allocation | `goals:read` |
| PUT | `/api/v1/goals/{id}/funding` | Update funding allocation | `goals:write` |

### 7.3 Key Endpoints

#### 7.3.1 Create Goal

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/goals`

**Description:** Create a new financial goal for a client.

**Contract:** Uses the unified `Goal` contract (see Section 11.6). The same contract is used for request and response.

**Request Body (Retirement Goal):**
Goal contract with required-on-create fields.


```json
{
  "client": {
    "id": 123
  },
  "goalType": "Retirement",
  "category": "LongTerm",
  "description": "Comfortable retirement at age 65",
  "priority": 1,
  "targetDate": "2045-05-15",
  "targetAmount": {
    "amount": 500000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "retirementAge": 65,
  "desiredRetirementIncome": {
    "amount": 30000.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  },
    "frequency": {
      "code": "A",
      "display": "Annual",
      "periodsPerYear": 1
    }
  },
  "currentProvisionAdequate": "No",
  "shortfallAmount": {
    "amount": 200000.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
  }
}
```

**Response:**
Complete `Goal` contract with all fields populated, including server-generated and computed fields.

```json
{
  "id": 555,
  "client": {
    "id": 123,
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/{factfindId}/clients/123"
  },
  "goalType": "Retirement",
  "category": "LongTerm",
  "description": "Comfortable retirement at age 65",
  "priority": 1,
  "status": {
    "code": "ACT",
    "display": "Active"
  },
  "targetDate": "2045-05-15",
  "yearsToGoal": 19,
  "targetAmount": {
    "amount": 500000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "retirementAge": 65,
  "desiredRetirementIncome": {
    "amount": 30000.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  },
    "frequency": {
      "code": "A",
      "display": "Annual",
      "periodsPerYear": 1
    }
  },
  "currentProvisionAdequate": "No",
  "shortfallAmount": {
    "amount": 200000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "fundingProgress": {
    "allocatedAmount": {
      "amount": 0.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "percentageComplete": 0.0,
    "onTrack": false
  },
  "createdAt": "2026-02-16T15:20:00Z",
  "updatedAt": "2026-02-16T15:20:00Z",
  "_links": {
    "self": { "href": "/api/v1/goals/555" },
    "update": { "href": "/api/v1/goals/555", "method": "PUT" },
    "objectives": { "href": "/api/v1/goals/555/objectives" },
    "funding": { "href": "/api/v1/goals/555/funding" },
    "client": { "href": "/api/v1/factfinds/{factfindId}/clients/123" }
  }
}
```

**Goal Types:**
- `Investment` - Investment/savings goals
- `Retirement` - Retirement planning
- `Protection` - Protection needs (life, CI, IP)
- `Mortgage` - Mortgage goals
- `Budget` - Budget and spending goals
- `EstatePlanning` - Estate planning goals
- `EquityRelease` - Equity release goals

**Categories:**
- `ShortTerm` - 0-2 years
- `MediumTerm` - 2-10 years
- `LongTerm` - 10+ years

#### 7.3.2 Add Objective

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/goals/{id}/objectives`

**Description:** Add a specific objective under a goal.

**Request Body:**
```json
{
  "objectiveType": "IncreasePensionContributions",
  "description": "Increase pension contributions to £750 per month",
  "targetAmount": {
    "amount": 9000.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  },
    "frequency": {
      "code": "A",
      "display": "Annual",
      "periodsPerYear": 1
    }
  },
  "targetDate": "2026-04-06",
  "priority": 1,
  "status": {
    "code": "NS",
    "display": "Not Started"
  }
}
```

**Response:**
```json
{
  "id": "objective-666",
  "goalRef": {
    "id": "goal-555",
    "href": "/api/v1/goals/goal-555",
    "goalName": "Comfortable retirement at age 65",
    "priority": "High"
  },
  "objectiveType": "IncreasePensionContributions",
  "description": "Increase pension contributions to £750 per month",
  "targetAmount": {
    "amount": 9000.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  },
    "frequency": {
      "code": "A",
      "display": "Annual",
      "periodsPerYear": 1
    }
  },
  "targetDate": "2026-04-06",
  "priority": 1,
  "status": {
    "code": "NS",
    "display": "Not Started"
  },
  "createdAt": "2026-02-16T15:25:00Z",
  "_links": {
    "self": { "href": "/api/v1/goals/goal-555/objectives/objective-666" },
    "goal": { "href": "/api/v1/goals/goal-555" }
  }
}
```

**Objective Types:**
- `IncreasePensionContributions`
- `StartRegularSavings`
- `ArrangeLifeCover`
- `ArrangeCriticalIllnessCover`
- `ArrangeIncomeProtection`
- `RepayMortgage`
- `RemortgageProperty`
- `ConsolidateDebts`
- `BuildEmergencyFund`
- `ReduceExpenditure`
- `CreateWill`
- `SetupTrust`
- `PlanGiftingStrategy`

---

## 8. FactFind Goals API

### 8.1 Overview

**Purpose:** Assess and record client's risk profile for investment suitability.

**Scope:**
- Attitude to Risk (ATR) questionnaire
- Capacity for Loss assessment
- Risk tolerance scoring
- Investment knowledge and experience
- Appropriateness assessment (MiFID II)
- Risk rating assignment
- Risk profile history and auditing

**Aggregate Root:** RISK_PROFILE

**Regulatory Compliance:**
- FCA COBS 9 (Assessing Suitability)
- MiFID II (Appropriateness Assessment)
- PROD (Target Market matching)
- Consumer Duty (Understanding needs)

### 8.2 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/risk-profile` | List risk profiles | `risk:read` |
| POST | `/api/v1/factfinds/{factfindId}/risk-profile` | Create risk profile | `risk:write` |
| GET | `/api/v1/factfinds/{factfindId}/risk-profile` | Get risk profile | `risk:read` |
| PUT | `/api/v1/factfinds/{factfindId}/risk-profile` | Update risk profile | `risk:write` |
| GET | `/api/v1/factfinds/{factfindId}/risk-profile/questionnaire` | Get ATR questionnaire responses | `risk:read` |
| PUT | `/api/v1/risk-profiles/{id}/questionnaire` | Update questionnaire | `risk:write` |
| GET | `/api/v1/factfinds/{factfindId}/risk-profile/history` | Get risk profile history | `risk:read` |

### 8.3 Key Endpoints

#### 8.3.1 Create Risk Profile

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/risk-profile`

**Description:** Create a new risk profile assessment.

**Contract:** Uses the unified `RiskProfile` contract (see Section 11.7). The same contract is used for request and response.

**Request Body:**
RiskProfile contract with required-on-create fields and assessment data.


```json
{
  "client": {
    "id": 123
  },
  "assessmentDate": "2026-02-16",
  "attitudeToRiskScore": 6,
  "attitudeToRiskRating": "Balanced",
  "capacityForLossScore": 7,
  "capacityForLossRating": "High",
  "overallRiskRating": "Balanced",
  "investmentKnowledge": "Good",
  "investmentExperience": "Experienced",
  "appropriatenessAssessment": "Appropriate",
  "assessmentMethod": "AdviserQuestionnaire",
  "questionnaire": {
    "questionnaireId": "ATR-2024-v1",
    "responses": [
      {
        "questionId": "Q1",
        "question": "How would you describe your investment experience?",
        "response": "I have been investing for over 10 years",
        "score": 4
      },
      {
        "questionId": "Q2",
        "question": "How would you react to a 20% fall in your portfolio value?",
        "response": "I would hold and wait for recovery",
        "score": 3
      }
    ],
    "totalScore": 60,
    "maxScore": 100
  },
  "capacityForLossDetails": "Client has substantial emergency fund, stable employment, no debts, and can withstand short-term volatility",
  "reviewDate": "2027-02-16"
}
```

**Response:**
Complete `RiskProfile` contract with all fields populated, including server-generated and computed fields.

```json
{
  "id": 777,
  "client": {
    "id": 123,
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/{factfindId}/clients/123"
  },
  "assessmentDate": "2026-02-16",
  "attitudeToRiskScore": 6,
  "attitudeToRiskRating": "Balanced",
  "capacityForLossScore": 7,
  "capacityForLossRating": "High",
  "overallRiskRating": "Balanced",
  "investmentKnowledge": "Good",
  "investmentExperience": "Experienced",
  "appropriatenessAssessment": "Appropriate",
  "assessmentMethod": "AdviserQuestionnaire",
  "questionnaire": {
    "questionnaireId": "ATR-2024-v1",
    "responses": [
      {
        "questionId": "Q1",
        "question": "How would you describe your investment experience?",
        "response": "I have been investing for over 10 years",
        "score": 4
      },
      {
        "questionId": "Q2",
        "question": "How would you react to a 20% fall in your portfolio value?",
        "response": "I would hold and wait for recovery",
        "score": 3
      }
    ],
    "totalScore": 60,
    "maxScore": 100,
    "percentageScore": 60.0
  },
  "capacityForLossDetails": "Client has substantial emergency fund, stable employment, no debts, and can withstand short-term volatility",
  "reviewDate": "2027-02-16",
  "isValid": true,
  "expiryDate": "2028-02-16",
  "createdAt": "2026-02-16T15:30:00Z",
  "updatedAt": "2026-02-16T15:30:00Z",
  "_links": {
    "self": { "href": "/api/v1/risk-profiles/777" },
    "update": { "href": "/api/v1/risk-profiles/777", "method": "PUT" },
    "questionnaire": { "href": "/api/v1/risk-profiles/777/questionnaire" },
    "history": { "href": "/api/v1/risk-profiles/777/history" },
    "client": { "href": "/api/v1/factfinds/{factfindId}/clients/123" }
  }
}
```

**Risk Ratings:**
- `VeryCautious` - Score 1-2
- `Cautious` - Score 3-4
- `Balanced` - Score 5-6
- `Adventurous` - Score 7-8
- `VeryAdventurous` - Score 9-10

**Investment Knowledge Levels:**
- `None` - No investment knowledge
- `Basic` - Basic understanding
- `Good` - Good understanding
- `Advanced` - Advanced knowledge
- `Expert` - Professional/expert level

---

## 9. FactFind Assets & Liabilities API

### 9.1 Overview

**Purpose:** Manage estate planning activities including gifts and trusts.

**Scope:**
- Gift recording (cash, property, business assets)
- Gift trust management
- Potentially Exempt Transfer (PET) tracking
- Inheritance Tax (IHT) calculations
- Trust beneficiary management

**Aggregate Root:** GIFT, GIFT_TRUST

### 9.2 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/gifts` | List gifts | `estate:read` |
| POST | `/api/v1/factfinds/{factfindId}/gifts` | Record gift | `estate:write` |
| GET | `/api/v1/factfinds/{factfindId}/gifts/{giftId}` | Get gift details | `estate:read` |
| PUT | `/api/v1/factfinds/{factfindId}/gifts/{giftId}` | Update gift | `estate:write` |
| GET | `/api/v1/factfinds/{factfindId}/gift-trusts` | List gift trusts | `estate:read` |
| POST | `/api/v1/factfinds/{factfindId}/gift-trusts` | Create gift trust | `estate:write` |
| GET | `/api/v1/factfinds/{factfindId}/gift-trusts/{trustId}` | Get trust details | `estate:read` |

### 9.3 Key Endpoints

#### 9.3.1 Record Gift

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/gifts`

**Contract:** Uses a unified `Gift` contract. The same contract is used for request and response, with read-only fields (id, computed fields like yearsRemaining, petStatus) populated by the server.

**Request Body:**
Gift contract with required-on-create fields.


```json
{
  "client": {
    "id": 123
  },
  "giftDate": "2024-12-25",
  "giftType": "Cash",
  "recipient": {
    "id": 124,
    "relationshipToClient": "Child"
  },
  "giftValue": {
    "amount": 50000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "isPotentiallyExemptTransfer": true,
  "exemptionType": "AnnualExemption",
  "ihtSevenYearExpiry": "2031-12-25"
}
```

**Response:**
Complete `Gift` contract with all fields populated, including server-generated and computed fields.

```json
{
  "id": 888,
  "client": {
    "id": 123,
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/{factfindId}/clients/123"
  },
  "giftDate": "2024-12-25",
  "giftType": "Cash",
  "recipient": {
    "id": 124,
    "name": "Emma Smith",
    "relationshipToClient": "Child",
    "href": "/api/v1/factfinds/{factfindId}/clients/124"
  },
  "giftValue": {
    "amount": 50000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "isPotentiallyExemptTransfer": true,
  "exemptionType": "AnnualExemption",
  "ihtSevenYearExpiry": "2031-12-25",
  "yearsRemaining": 5.86,
  "petStatus": "Active",
  "createdAt": "2026-02-16T15:40:00Z",
  "_links": {
    "self": { "href": "/api/v1/gifts/888" },
    "client": { "href": "/api/v1/factfinds/{factfindId}/clients/123" },
    "recipient": { "href": "/api/v1/factfinds/{factfindId}/clients/124" }
  }
}
```

---

## 10. FactFind Risk Profile API

### 10.1 Overview

**Purpose:** Centralized lookup data for enumeration value types, reference entities, and system configuration.

**Key Concepts:**

The Reference Data API provides access to **Enumeration Value Types** that are used throughout the FactFind API. All enumerations follow a consistent code/display pattern with optional metadata fields.

**Enumeration Value Types Pattern:**
```json
{
  "code": "MACHINE_READABLE_CODE",
  "display": "Human Readable Label",
  // ... optional metadata fields
}
```

**Benefits:**
- Self-documenting: No code lookup required
- Internationalization-ready: Display text can be localized
- Rich metadata: Dates, categories, symbols, etc.
- Forward-compatible: Can add fields without breaking changes

**Scope:**
- Enumeration value types (gender, marital status, employment status, titles, etc.)
- Lookup value types (countries, counties, currencies, product types, frequencies)
- Provider directory
- Adviser directory
- System configuration

### 10.2 Operations Summary

**Enumeration Value Type Endpoints:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/reference/genders` | Get gender values | Public |
| GET | `/api/v1/reference/marital-statuses` | Get marital status values | Public |
| GET | `/api/v1/reference/employment-statuses` | Get employment status values | Public |
| GET | `/api/v1/reference/titles` | Get title/honorific values | Public |
| GET | `/api/v1/reference/address-types` | Get address type values | Public |
| GET | `/api/v1/reference/contact-types` | Get contact type values | Public |
| GET | `/api/v1/reference/meeting-types` | Get meeting type values | Public |
| GET | `/api/v1/reference/statuses` | Get generic status values | Public |
| GET | `/api/v1/reference/residency-statuses` | Get residency status values | Public |
| GET | `/api/v1/reference/health-statuses` | Get health status values | Public |

**Lookup Value Type Endpoints:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/reference/countries` | Get country values (ISO 3166-1) | Public |
| GET | `/api/v1/reference/counties` | Get county/region values | Public |
| GET | `/api/v1/reference/currencies` | Get currency values (ISO 4217) | Public |
| GET | `/api/v1/reference/frequencies` | Get frequency values | Public |
| GET | `/api/v1/reference/product-types` | Get product type values | Public |

**Reference Entity Endpoints:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/providers` | List providers | `refdata:read` |
| GET | `/api/v1/providers/{id}` | Get provider details | `refdata:read` |
| GET | `/api/v1/advisers` | List advisers | `refdata:read` |
| GET | `/api/v1/advisers/{id}` | Get adviser details | `refdata:read` |

### 10.3 Key Endpoints

#### 10.3.1 Get Gender Values

**Endpoint:** `GET /api/v1/reference/genders`

**Description:** Returns available gender values as GenderValue types.

**Response:**
```json
{
  "items": [
    {
      "code": "M",
      "display": "Male"
    },
    {
      "code": "F",
      "display": "Female"
    },
    {
      "code": "O",
      "display": "Other"
    },
    {
      "code": "U",
      "display": "Unknown"
    },
    {
      "code": "N",
      "display": "Prefer not to say"
    }
  ]
}
```

---

#### 10.3.2 Get Marital Status Values

**Endpoint:** `GET /api/v1/reference/marital-statuses`

**Description:** Returns available marital status values as MaritalStatusValue types.

**Response:**
```json
{
  "items": [
    {
      "code": "SIN",
      "display": "Single"
    },
    {
      "code": "MAR",
      "display": "Married"
    },
    {
      "code": "CIV",
      "display": "Civil Partnership"
    },
    {
      "code": "DIV",
      "display": "Divorced"
    },
    {
      "code": "WID",
      "display": "Widowed"
    },
    {
      "code": "SEP",
      "display": "Separated"
    },
    {
      "code": "COH",
      "display": "Cohabiting"
    }
  ]
}
```

---

#### 10.3.3 Get Employment Status Values

**Endpoint:** `GET /api/v1/reference/employment-statuses`

**Description:** Returns available employment status values as EmploymentStatusValue types.

**Response:**
```json
{
  "items": [
    {
      "code": "EMP",
      "display": "Employed"
    },
    {
      "code": "SELF",
      "display": "Self-Employed"
    },
    {
      "code": "DIR",
      "display": "Company Director"
    },
    {
      "code": "RET",
      "display": "Retired"
    },
    {
      "code": "UNE",
      "display": "Unemployed"
    },
    {
      "code": "NW",
      "display": "Not Working"
    },
    {
      "code": "STU",
      "display": "Student"
    },
    {
      "code": "HOME",
      "display": "Homemaker"
    }
  ]
}
```

---

#### 10.3.4 Get Title Values

**Endpoint:** `GET /api/v1/reference/titles`

**Description:** Returns available title/honorific values as TitleValue types.

**Response:**
```json
{
  "items": [
    {
      "code": "MR",
      "display": "Mr"
    },
    {
      "code": "MRS",
      "display": "Mrs"
    },
    {
      "code": "MS",
      "display": "Ms"
    },
    {
      "code": "MISS",
      "display": "Miss"
    },
    {
      "code": "DR",
      "display": "Dr"
    },
    {
      "code": "PROF",
      "display": "Professor"
    },
    {
      "code": "REV",
      "display": "Reverend"
    },
    {
      "code": "SIR",
      "display": "Sir"
    },
    {
      "code": "LADY",
      "display": "Lady"
    },
    {
      "code": "LORD",
      "display": "Lord"
    }
  ]
}
```

---

#### 10.3.5 Get Country Values

**Endpoint:** `GET /api/v1/reference/countries`

**Description:** Returns available country values as CountryValue types using ISO 3166-1 standard.

**Query Parameters:**
- `region` (optional) - Filter by region (e.g., "Europe", "Asia")
- `search` (optional) - Search by country name

**Response:**
```json
{
  "items": [
    {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    },
    {
      "code": "US",
      "display": "United States",
      "alpha3": "USA"
    },
    {
      "code": "FR",
      "display": "France",
      "alpha3": "FRA"
    },
    {
      "code": "DE",
      "display": "Germany",
      "alpha3": "DEU"
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 50,
    "totalItems": 249,
    "totalPages": 5
  }
}
```

---

#### 10.3.6 Get Currency Values

**Endpoint:** `GET /api/v1/reference/currencies`

**Description:** Returns available currency values as CurrencyValue types using ISO 4217 standard.

**Response:**
```json
{
  "items": [
    {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    },
    {
      "code": "USD",
      "display": "US Dollar",
      "symbol": "$"
    },
    {
      "code": "EUR",
      "display": "Euro",
      "symbol": "€"
    },
    {
      "code": "CHF",
      "display": "Swiss Franc",
      "symbol": "CHF"
    },
    {
      "code": "JPY",
      "display": "Japanese Yen",
      "symbol": "¥"
    },
    {
      "code": "AUD",
      "display": "Australian Dollar",
      "symbol": "A$"
    },
    {
      "code": "CAD",
      "display": "Canadian Dollar",
      "symbol": "C$"
    }
  ]
}
```

---

#### 10.3.7 Get Frequency Values

**Endpoint:** `GET /api/v1/reference/frequencies`

**Description:** Returns available frequency values as FrequencyValue types for payments and contributions.

**Response:**
```json
{
  "items": [
    {
      "code": "M",
      "display": "Monthly",
      "periodsPerYear": 12
    },
    {
      "code": "Q",
      "display": "Quarterly",
      "periodsPerYear": 4
    },
    {
      "code": "S",
      "display": "Semi-Annual",
      "periodsPerYear": 2
    },
    {
      "code": "A",
      "display": "Annual",
      "periodsPerYear": 1
    },
    {
      "code": "W",
      "display": "Weekly",
      "periodsPerYear": 52
    },
    {
      "code": "F",
      "display": "Fortnightly",
      "periodsPerYear": 26
    },
    {
      "code": "SINGLE",
      "display": "Single Payment",
      "periodsPerYear": 0
    }
  ]
}
```

---

#### 10.3.8 Get Product Type Values

**Endpoint:** `GET /api/v1/reference/product-types`

**Description:** Returns available product type values as ProductTypeValue types.

**Query Parameters:**
- `category` (optional) - Filter by category (e.g., "Pension", "Investment", "Protection")

**Response:**
```json
{
  "items": [
    {
      "code": "SIPP",
      "display": "Self-Invested Personal Pension",
      "category": "Pension"
    },
    {
      "code": "PP",
      "display": "Personal Pension",
      "category": "Pension"
    },
    {
      "code": "GPP",
      "display": "Group Personal Pension",
      "category": "Pension"
    },
    {
      "code": "ISA",
      "display": "ISA",
      "category": "Investment"
    },
    {
      "code": "GIA",
      "display": "General Investment Account",
      "category": "Investment"
    },
    {
      "code": "LIFE",
      "display": "Life Insurance",
      "category": "Protection"
    },
    {
      "code": "CIC",
      "display": "Critical Illness Cover",
      "category": "Protection"
    },
    {
      "code": "IP",
      "display": "Income Protection",
      "category": "Protection"
    }
  ]
}
```

---

#### 10.3.9 Usage in Client Code

**Frontend Example (TypeScript):**

```typescript
// Fetch reference data on app initialization
const genders = await fetch('/api/v1/reference/genders').then(r => r.json());
const maritalStatuses = await fetch('/api/v1/reference/marital-statuses').then(r => r.json());
const countries = await fetch('/api/v1/reference/countries').then(r => r.json());

// Populate dropdown
<select name="gender">
  {genders.items.map(g => (
    <option value={g.code}>{g.display}</option>
  ))}
</select>

// Submit with Value Type
const clientData = {
  name: {
    title: { code: "MR", display: "Mr" },
    firstName: "John",
    lastName: "Smith"
  },
  gender: { code: "M", display: "Male" },
  maritalStatus: { code: "MAR", display: "Married" },
  // ... other fields
};

await fetch('/api/v1/clients', {
  method: 'POST',
  body: JSON.stringify(clientData)
});
```

**Benefits for Clients:**
1. **Self-Documenting**: API responses include human-readable labels
2. **No Code Lookups**: Display text embedded in response
3. **Internationalization**: Server can return localized display text based on Accept-Language header
4. **Rich Metadata**: Additional fields (symbols, categories, periods) available
5. **Forward-Compatible**: New metadata fields can be added without breaking existing clients
- `AssetCategory`
- `ProductType`
- `GoalType`
- `RiskRating`
- And 100+ more...

---

## 11. FactFind Estate Planning API

This section defines the unified entity contracts used throughout the FactFind API. Following the **Single Contract Principle** (Section 1.7), each entity has one canonical contract used for both requests (POST, PUT, PATCH) and responses (GET).

Each field is annotated with its behavioral characteristics:
- **required-on-create** - Must be provided when creating the entity
- **optional** - Can be omitted in any operation
- **read-only** - System-generated, cannot be set by clients
- **write-once** - Can only be set on create, immutable thereafter
- **updatable** - Can be modified via PUT/PATCH operations

### 11.1 Client Contract

The `Client` contract represents a client entity (Person, Corporate, or Trust) with all demographic and regulatory information.

**Reference Type:** Client is a reference type with identity (has `id` field).

```json
{
  "id": "client-123",
  "clientNumber": "C00001234",
  "clientType": "Person",
  "name": {
    "title": {
      "code": "MR",
      "display": "Mr"
    },
    "firstName": "John",
    "middleName": "Michael",
    "lastName": "Smith",
    "preferredName": "John"
  },
  "fullName": "Mr John Michael Smith",
  "salutation": "Mr Smith",
  "dateOfBirth": "1980-05-15",
  "age": 45,
  "placeOfBirth": "London",
  "gender": {
    "code": "M",
    "display": "Male"
  },
  "maritalStatus": {
    "code": "MAR",
    "display": "Married",
    "effectiveFrom": "2005-06-20"
  },
  "taxDetails": {
    "niNumber": "AB123456C",
    "taxReference": "1234567890"
  },
  "nationalClientIdentifier": "NCI-123456",
  "passportRef": "502135321",
  "passportExpiryDate": "2030-05-15",
  "drivingLicenceRef": "SMITH801055JM9IJ",
  "drivingLicenceExpiryDate": "2030-05-15",
  "nationalityCountry": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "countryOfBirth": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "countryOfResidence": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "countryOfDomicile": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "isUkResident": true,
  "isExpatriate": false,
  "isDeceased": false,
  "deceasedOn": null,
  "hasWill": true,
  "isWillUpToDate": true,
  "isWillAdvised": true,
  "willDetails": "Will created in 2020, held by Smith & Co Solicitors",
  "isPowerOfAttorneyGranted": false,
  "powerOfAttorneyName": null,
  "hasEverSmoked": false,
  "isSmoker": "Never",
  "hasSmokedInLast12Months": "No",
  "hasNicotineReplacementInLastYear": "No",
  "hasVapedInLastYear": "No",
  "inGoodHealth": true,
  "medicalConditions": null,
  "isMatchingServiceProposition": false,
  "matchingServicePropositionReason": null,
  "isHeadOfFamilyGroup": true,
  "isJoint": true,
  "spouseRef": {
    "id": "client-124",
    "href": "/api/v1/clients/client-124",
    "name": "Sarah Smith",
    "clientNumber": "C00001235",
    "type": "Person"
  },
  "serviceStatus": "Active",
  "serviceStatusDate": "2020-01-15",
  "clientSegment": "A",
  "clientSegmentDate": "2020-01-15",
  "clientCategory": "HighNetWorth",
  "grossAnnualIncome": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "householdIncome": {
    "amount": 120000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "netWorth": {
    "amount": 450000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "householdNetWorth": {
    "amount": 650000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalAssets": {
    "amount": 500000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalJointAssets": {
    "amount": 200000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "primaryAddress": {
    "line1": "123 Main Street",
    "line2": "Apartment 4B",
    "city": "London",
    "county": {
      "code": "GLA",
      "display": "Greater London"
    },
    "postcode": "SW1A 1AA",
    "country": {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    },
    "addressType": {
      "code": "RES",
      "display": "Residential"
    }
  },
  "contacts": [
    {
      "type": {
        "code": "EMAIL",
        "display": "Email"
      },
      "value": "john.smith@example.com",
      "isPrimary": true
    },
    {
      "type": {
        "code": "MOBILE",
        "display": "Mobile"
      },
      "value": "+44 7700 900123",
      "isPrimary": false
    }
  ],
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },
  "paraplannerRef": {
    "id": "adviser-790",
    "href": "/api/v1/advisers/adviser-790",
    "name": "Mark Taylor",
    "code": "PP001"
  },
  "idCheckCompletedDate": "2020-01-10",
  "idCheckExpiryDate": "2025-01-10",
  "idCheckIssuer": "Experian",
  "idCheckReference": "IDC-123456",
  "idCheckResult": "Passed",
  "taxCode": "1257L",
  "notes": "Prefers email communication, interested in sustainable investing",
  "profilePicture": "https://cdn.factfind.com/profiles/client-123.jpg",
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "createdBy": {
    "id": "user-999",
    "name": "System Admin"
  },
  "updatedBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "_links": {
    "self": { "href": "/api/v1/clients/client-123" },
    "update": { "href": "/api/v1/clients/client-123", "method": "PUT" },
    "delete": { "href": "/api/v1/clients/client-123", "method": "DELETE" },
    "addresses": { "href": "/api/v1/clients/client-123/addresses" },
    "contacts": { "href": "/api/v1/clients/client-123/contacts" },
    "relationships": { "href": "/api/v1/clients/client-123/relationships" },
    "dependants": { "href": "/api/v1/clients/client-123/dependants" },
    "factfinds": { "href": "/api/v1/factfinds?clientId=client-123" },
    "arrangements": { "href": "/api/v1/arrangements?clientId=client-123" },
    "goals": { "href": "/api/v1/goals?clientId=client-123" },
    "riskProfile": { "href": "/api/v1/risk-profiles?clientId=client-123" }
  }
}
```

**Field Behaviors:**

| Field | Type | Create | Update | Response | Notes |
|-------|------|--------|--------|----------|-------|
| `id` | uuid | ignored | ignored | included | read-only, server-generated |
| `clientNumber` | string | optional | ignored | included | write-once, business identifier |
| `clientType` | enum | required | ignored | included | write-once, discriminator field |
| `name` | NameValue | required | updatable | included | Value type: firstName, lastName required |
| `fullName` | string | ignored | ignored | included | read-only, computed from name |
| `salutation` | string | optional | updatable | included | - |
| `dateOfBirth` | date | required | ignored | included | write-once, immutable after creation |
| `age` | integer | ignored | ignored | included | read-only, computed from dateOfBirth |
| `placeOfBirth` | string | optional | updatable | included | - |
| `gender` | GenderValue | optional | updatable | included | Value type: code/display enumeration |
| `maritalStatus` | MaritalStatusValue | optional | updatable | included | Value type: code/display/effectiveFrom |
| `taxDetails` | TaxDetailsValue | optional | updatable | included | Value type: PII, requires `client:pii:read` scope |
| `nationalClientIdentifier` | string | optional | updatable | included | - |
| `passportRef` | string | optional | updatable | included | PII, requires `client:pii:read` scope |
| `passportExpiryDate` | date | optional | updatable | included | - |
| `drivingLicenceRef` | string | optional | updatable | included | PII, requires `client:pii:read` scope |
| `drivingLicenceExpiryDate` | date | optional | updatable | included | - |
| `nationalityCountry` | CountryValue | optional | updatable | included | Value type: ISO country code/display/alpha3 |
| `countryOfBirth` | CountryValue | optional | updatable | included | Value type: ISO country code/display/alpha3 |
| `countryOfResidence` | CountryValue | optional | updatable | included | Value type: ISO country code/display/alpha3 |
| `countryOfDomicile` | CountryValue | optional | updatable | included | Value type: ISO country code/display/alpha3 |
| `isUkResident` | boolean | optional | updatable | included | - |
| `isExpatriate` | boolean | optional | updatable | included | - |
| `isDeceased` | boolean | optional | updatable | included | - |
| `deceasedOn` | date | optional | updatable | included | - |
| `hasWill` | boolean | optional | updatable | included | - |
| `isWillUpToDate` | boolean | optional | updatable | included | - |
| `isWillAdvised` | boolean | optional | updatable | included | - |
| `willDetails` | string | optional | updatable | included | - |
| `isPowerOfAttorneyGranted` | boolean | optional | updatable | included | - |
| `powerOfAttorneyName` | string | optional | updatable | included | - |
| `hasEverSmoked` | boolean | optional | updatable | included | - |
| `isSmoker` | enum | optional | updatable | included | - |
| `hasSmokedInLast12Months` | enum | optional | updatable | included | - |
| `hasNicotineReplacementInLastYear` | enum | optional | updatable | included | - |
| `hasVapedInLastYear` | enum | optional | updatable | included | - |
| `inGoodHealth` | boolean | optional | updatable | included | - |
| `medicalConditions` | string | optional | updatable | included | - |
| `isMatchingServiceProposition` | boolean | optional | updatable | included | - |
| `matchingServicePropositionReason` | string | optional | updatable | included | - |
| `isHeadOfFamilyGroup` | boolean | optional | updatable | included | - |
| `isJoint` | boolean | optional | updatable | included | - |
| `spouseRef` | ClientRef | optional | updatable | included | Reference type: Provide id on create/update |
| `serviceStatus` | enum | optional | updatable | included | - |
| `serviceStatusDate` | date | optional | updatable | included | - |
| `clientSegment` | string | optional | updatable | included | - |
| `clientSegmentDate` | date | optional | updatable | included | - |
| `clientCategory` | enum | optional | updatable | included | - |
| `grossAnnualIncome` | MoneyValue | optional | updatable | included | Value type: amount + currency |
| `householdIncome` | MoneyValue | optional | updatable | included | Value type: amount + currency |
| `netWorth` | MoneyValue | optional | updatable | included | Value type: amount + currency |
| `householdNetWorth` | MoneyValue | optional | updatable | included | Value type: amount + currency |
| `totalAssets` | MoneyValue | ignored | ignored | included | read-only, computed from arrangements |
| `totalJointAssets` | MoneyValue | ignored | ignored | included | read-only, computed |
| `primaryAddress` | AddressValue | optional | updatable | included | Value type: Embedded address, no id |
| `contacts` | ContactValue[] | optional | updatable | included | Value type array: Email, phone contacts |
| `adviserRef` | AdviserRef | optional | updatable | included | Reference type: Primary adviser |
| `paraplannerRef` | AdviserRef | optional | updatable | included | Reference type: Paraplanner |
| `idCheckCompletedDate` | date | optional | updatable | included | - |
| `idCheckExpiryDate` | date | optional | updatable | included | - |
| `idCheckIssuer` | string | optional | updatable | included | - |
| `idCheckReference` | string | optional | updatable | included | - |
| `idCheckResult` | enum | optional | updatable | included | - |
| `taxCode` | string | optional | updatable | included | - |
| `notes` | string | optional | updatable | included | - |
| `profilePicture` | string | optional | updatable | included | URL to profile image |
| `createdAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `updatedAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `createdBy` | object | ignored | ignored | included | read-only, audit trail |
| `updatedBy` | object | ignored | ignored | included | read-only, audit trail |
| `_links` | object | ignored | ignored | included | read-only, HATEOAS links |

**Usage Examples:**

**Creating a Client (POST /api/v1/factfinds/{factfindId}/clients):**
```json
{
  "clientType": "Person",
  "name": {
    "title": "Mr",
    "firstName": "John",
    "lastName": "Smith"
  },
  "dateOfBirth": "1980-05-15",
  "gender": "Male",
  "nationalityCountry": { "code": "GB" },
  "primaryAddress": {
    "line1": "123 Main Street",
    "city": "London",
    "postcode": "SW1A 1AA",
    "country": "GB"
  },
  "contacts": [
    {
      "type": "Email",
      "value": "john.smith@example.com",
      "isPrimary": true
    }
  ],
  "adviserRef": {
    "id": "adviser-789"
  }
}
```
Server generates `id`, `clientNumber`, `createdAt`, `updatedAt`, `fullName`, `age`, and populates reference display fields. Returns complete contract.

**Updating a Client (PUT /api/v1/clients/client-123):**
```json
{
  "name": {
    "title": "Mr",
    "firstName": "John",
    "lastName": "Smith-Jones"
  },
  "gender": "Male",
  "maritalStatus": "Married",
  "nationalityCountry": { "code": "GB" },
  "grossAnnualIncome": {
    "amount": 85000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "spouseRef": {
    "id": "client-124"
  }
}
```
Cannot change `dateOfBirth` (write-once). Server updates `updatedAt`, `fullName`, and returns complete contract.

**Partial Update (PATCH /api/v1/clients/client-123):**
```json
{
  "name": {
    "lastName": "Smith-Jones"
  },
  "maritalStatus": {
    "code": "MAR",
    "display": "Married",
    "effectiveFrom": "2015-06-20"
  },
  "householdIncome": {
    "amount": 145000.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
  }
}
```
Only specified fields are updated. Returns complete contract with changes applied.

---

### 11.2 FactFind Contract

The `FactFind` contract (also known as ADVICE_CASE) represents a fact-finding session and aggregate root for circumstances discovery.

**Reference Type:** FactFind is a reference type with identity (has `id` field).

Complete fact find aggregate root with summary calculations.

```json
{
  "id": "factfind-456",
  "factFindNumber": "FF001234",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "jointClientRef": {
    "id": "client-124",
    "href": "/api/v1/clients/client-124",
    "name": "Sarah Smith",
    "clientNumber": "C00001235",
    "type": "Person"
  },
  "dateOfMeeting": "2026-02-16",
  "typeOfMeeting": {
    "code": "INIT",
    "display": "Initial Consultation"
  },
  "clientsPresent": "BothClients",
  "anybodyElsePresent": false,
  "anybodyElsePresentDetails": null,
  "scopeOfAdvice": {
    "retirementPlanning": true,
    "savingsAndInvestments": true,
    "protection": true,
    "mortgage": false,
    "estatePlanning": false
  },
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },
  "isComplete": false,
  "dateFactFindCompleted": null,
  "dateDeclarationSigned": null,
  "dateIdAmlChecked": "2026-02-16",
  "status": {
    "code": "INPROG",
    "display": "In Progress"
  },
  "hasEmployments": true,
  "hasExpenditures": true,
  "hasAssets": true,
  "hasLiabilities": true,
  "hasDcPensionPersonal": true,
  "hasDcPensionMoneyPurchase": true,
  "hasDbPension": false,
  "hasSavings": true,
  "hasInvestments": true,
  "hasProtection": true,
  "hasExistingMortgage": true,
  "hasAnnuity": false,
  "hasEquityRelease": false,
  "hasAdverseCredit": false,
  "hasBeenRefusedCredit": false,
  "incomeChangesExpected": false,
  "expenditureChangesExpected": false,
  "totalEarnedAnnualIncomeGross": {
    "amount": 120000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalNetMonthlyIncome": {
    "amount": 7500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalMonthlyExpenditure": {
    "amount": 4500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalMonthlyDisposableIncome": {
    "amount": 3000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "emergencyFund": {
    "requiredAmount": {
      "amount": 11400.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "committedAmount": {
      "amount": 15000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "shortfall": {
      "amount": 0.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    }
  },
  "totalFundsAvailable": {
    "amount": 85000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalLumpSumAvailableForAdvice": {
    "amount": 70000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "agreedMonthlyBudget": {
    "amount": 1000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "agreedSingleInvestmentAmount": {
    "amount": 50000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "highestTaxRate": "HigherRate",
  "totalNetRelevantEarnings": {
    "amount": 110000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "sourceOfInvestmentFunds": "Savings from employment income over past 5 years",
  "notes": "Clients seeking to consolidate pensions and review protection cover",
  "additionalNotes": null,
  "customQuestions": [
    {
      "question": "What are your main financial concerns?",
      "answer": "Ensuring sufficient retirement income and protecting family"
    }
  ],
  "createdAt": "2026-02-16T14:30:00Z",
  "updatedAt": "2026-02-16T15:45:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456" },
    "complete": { "href": "/api/v1/factfinds/factfind-456/complete", "method": "POST" },
    "summary": { "href": "/api/v1/factfinds/factfind-456/summary" },
    "employment": { "href": "/api/v1/factfinds/factfind-456/employment" },
    "income": { "href": "/api/v1/factfinds/factfind-456/income" },
    "expenditure": { "href": "/api/v1/factfinds/factfind-456/expenditure" },
    "affordability": { "href": "/api/v1/factfinds/factfind-456/affordability" }
  }
}
```

**Field Behaviors:**

| Field | Type | Create | Update | Response | Notes |
|-------|------|--------|--------|----------|-------|
| `id` | uuid | ignored | ignored | included | read-only, server-generated |
| `factFindNumber` | string | optional | ignored | included | write-once, business identifier |
| `clientRef` | ClientRef | required | ignored | included | write-once, reference to Client |
| `jointClientRef` | ClientRef | optional | ignored | included | write-once, reference to Client |
| `dateOfMeeting` | date | required | updatable | included | - |
| `typeOfMeeting` | enum | required | updatable | included | - |
| `clientsPresent` | enum | optional | updatable | included | - |
| `anybodyElsePresent` | boolean | optional | updatable | included | - |
| `anybodyElsePresentDetails` | string | optional | updatable | included | - |
| `scopeOfAdvice` | object | optional | updatable | included | Value type: embedded scope flags |
| `adviserRef` | AdviserRef | required | updatable | included | Reference type: Primary adviser |
| `isComplete` | boolean | ignored | ignored | included | read-only, computed from completion status |
| `dateFactFindCompleted` | date | optional | updatable | included | - |
| `dateDeclarationSigned` | date | optional | updatable | included | - |
| `dateIdAmlChecked` | date | optional | updatable | included | - |
| `status` | enum | optional | updatable | included | - |
| `hasEmployments` | boolean | ignored | ignored | included | read-only, computed from child entities |
| `hasExpenditures` | boolean | ignored | ignored | included | read-only, computed |
| `hasAssets` | boolean | ignored | ignored | included | read-only, computed |
| `hasLiabilities` | boolean | ignored | ignored | included | read-only, computed |
| `hasDcPensionPersonal` | boolean | ignored | ignored | included | read-only, computed |
| `hasDcPensionMoneyPurchase` | boolean | ignored | ignored | included | read-only, computed |
| `hasDbPension` | boolean | ignored | ignored | included | read-only, computed |
| `hasSavings` | boolean | ignored | ignored | included | read-only, computed |
| `hasInvestments` | boolean | ignored | ignored | included | read-only, computed |
| `hasProtection` | boolean | ignored | ignored | included | read-only, computed |
| `hasExistingMortgage` | boolean | ignored | ignored | included | read-only, computed |
| `hasAnnuity` | boolean | ignored | ignored | included | read-only, computed |
| `hasEquityRelease` | boolean | ignored | ignored | included | read-only, computed |
| `hasAdverseCredit` | boolean | optional | updatable | included | - |
| `hasBeenRefusedCredit` | boolean | optional | updatable | included | - |
| `incomeChangesExpected` | boolean | optional | updatable | included | - |
| `expenditureChangesExpected` | boolean | optional | updatable | included | - |
| `totalEarnedAnnualIncomeGross` | MoneyValue | ignored | ignored | included | read-only, computed from Income entities |
| `totalNetMonthlyIncome` | MoneyValue | ignored | ignored | included | read-only, computed |
| `totalMonthlyExpenditure` | MoneyValue | ignored | ignored | included | read-only, computed from Expenditure entities |
| `totalMonthlyDisposableIncome` | MoneyValue | ignored | ignored | included | read-only, computed |
| `emergencyFund` | object | optional | updatable | included | Value type: requiredAmount, committedAmount, shortfall (all MoneyValue) |
| `totalFundsAvailable` | MoneyValue | ignored | ignored | included | read-only, computed |
| `totalLumpSumAvailableForAdvice` | MoneyValue | optional | updatable | included | Value type |
| `agreedMonthlyBudget` | MoneyValue | optional | updatable | included | Value type |
| `agreedSingleInvestmentAmount` | MoneyValue | optional | updatable | included | Value type |
| `highestTaxRate` | enum | ignored | ignored | included | read-only, computed |
| `totalNetRelevantEarnings` | MoneyValue | ignored | ignored | included | read-only, computed |
| `sourceOfInvestmentFunds` | string | optional | updatable | included | - |
| `notes` | string | optional | updatable | included | - |
| `additionalNotes` | string | optional | updatable | included | - |
| `customQuestions` | array | optional | updatable | included | - |
| `createdAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `updatedAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `_links` | object | ignored | ignored | included | read-only, HATEOAS links |

**Usage Examples:**

**Creating a FactFind (POST /api/v1/factfinds):**
```json
{
  "clientRef": { "id": "client-123" },
  "jointClientRef": { "id": "client-124" },
  "dateOfMeeting": "2026-02-16",
  "typeOfMeeting": "InitialConsultation",
  "adviserRef": { "id": "adviser-789" },
  "scopeOfAdvice": {
    "retirementPlanning": true,
    "protection": true
  },
  "agreedMonthlyBudget": {
    "amount": 1000.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
  }
}
```

**Updating a FactFind (PATCH /api/v1/factfinds/456):**
```json
{
  "status": {
    "code": "COM",
    "display": "Complete"
  },
  "dateFactFindCompleted": "2026-02-16",
  "agreedMonthlyBudget": {
    "amount": 1500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  }
}
```

---

### 11.3 Address Contract

The `Address` contract represents a client's address with additional metadata for residency tracking. When an address needs independent lifecycle management (e.g., address history), it becomes a reference type with identity.

**Reference Type:** Address is a reference type with identity when managed as a separate resource (has `id` field).

**Note:** For simple embedded addresses (like `primaryAddress` in Client), use `AddressValue` (see Section 11.10.2) which has no `id` and is embedded directly.

```json
{
  "id": "address-789",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
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
  "isCorrespondenceAddress": true,
  "residencyPeriod": {
    "startDate": "2020-01-15",
    "endDate": null
  },
  "residencyStatus": "Owner",
  "isOnElectoralRoll": true,
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z"
}
```

**Key Field Behaviors:**
- `id` - read-only, server-generated (uuid)
- `clientRef` - write-once, reference to Client
- `addressType` - required-on-create, updatable
- `address` - required-on-create, updatable (AddressValue embedded)
- `isCorrespondenceAddress` - optional, updatable (boolean)
- `residencyPeriod` - optional, updatable (DateRangeValue)
- `residencyStatus` - optional, updatable
- `isOnElectoralRoll` - optional, updatable
- `createdAt`, `updatedAt` - read-only

---

### 11.4 Income Contract

The `Income` contract represents an income source within a FactFind.

**Reference Type:** Income is a reference type with identity (has `id` field).

```json
{
  "id": "income-101",
  "factFindRef": {
    "id": "factfind-456",
    "href": "/api/v1/factfinds/factfind-456",
    "factFindNumber": "FF001234",
    "status": "InProgress"
  },
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "employmentRef": {
    "id": "employment-222",
    "href": "/api/v1/employments/employment-222",
    "employerName": "Tech Corp Ltd",
    "status": "Current"
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
  "frequency": {
    "code": "A",
    "display": "Annually",
    "periodsPerYear": 1
  },
  "incomePeriod": {
    "startDate": "2020-01-15",
    "endDate": null
  },
  "isOngoing": true,
  "isPrimary": true,
  "isGuaranteed": true,
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
  "notes": "Annual bonus typically £10k",
  "createdAt": "2026-02-16T14:30:00Z",
  "updatedAt": "2026-02-16T15:45:00Z"
}
```

**Key Field Behaviors:**
- `id` - read-only, server-generated (uuid)
- `factFindRef` - write-once, reference to FactFind (set from URL path parameter)
- `clientRef` - required-on-create, write-once, reference to Client
- `employmentRef` - optional, updatable, reference to Employment
- `incomeType` - required-on-create, updatable
- `description` - optional, updatable
- `grossAmount` - required-on-create, updatable (MoneyValue)
- `netAmount` - optional, updatable (MoneyValue)
- `frequency` - required-on-create, updatable
- `incomePeriod` - optional, updatable (DateRangeValue)
- `isOngoing`, `isPrimary`, `isGuaranteed` - optional, updatable
- `taxDeducted`, `nationalInsuranceDeducted` - optional, updatable (MoneyValue)
- `createdAt`, `updatedAt` - read-only

---

### 11.5 Arrangement Contract

The `Arrangement` contract represents financial products (pensions, investments, protection, mortgages). This is a polymorphic contract with type-specific fields.

**Reference Type:** Arrangement is a reference type with identity (has `id` field).

```json
{
  "id": "arrangement-555",
  "arrangementNumber": "ARR123456",
  "arrangementType": "Pension",
  "pensionType": "PersonalPension",
  "clientOwners": [
    {
      "id": "client-123",
      "href": "/api/v1/clients/client-123",
      "name": "John Smith",
      "clientNumber": "C00001234",
      "type": "Person"
    }
  ],
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },
  "productName": "ABC SIPP",
  "providerRef": {
    "id": "provider-456",
    "href": "/api/v1/providers/provider-456",
    "name": "ABC Pension Provider Ltd",
    "frnNumber": "123456"
  },
  "policyNumber": "POL123456",
  "status": {
    "code": "ACT",
    "display": "Active"
  },
  "arrangementPeriod": {
    "startDate": "2015-01-01",
    "endDate": null
  },
  "currentValue": {
    "amount": 125000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "valuationDate": "2026-02-01",
  "regularContribution": {
    "amount": 500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "contributionFrequency": {
    "code": "M",
    "display": "Monthly",
    "periodsPerYear": 12
  },
  "isInDrawdown": false,
  "expectedRetirementAge": 67,
  "projectedValueAtRetirement": {
    "amount": 450000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "hasGuaranteedAnnuityRate": false,
  "hasProtectedTaxFreeAmount": false,
  "isSalarySacrifice": false,
  "notes": "Consolidated from previous workplace pensions",
  "createdAt": "2015-01-01T10:00:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "_links": {
    "self": { "href": "/api/v1/arrangements/arrangement-555" },
    "contributions": { "href": "/api/v1/arrangements/arrangement-555/contributions" },
    "valuations": { "href": "/api/v1/arrangements/arrangement-555/valuations" }
  }
}
```

**Key Field Behaviors:**
- `id` - read-only, server-generated
- `arrangementType` - required-on-create, write-once (discriminator)
- `pensionType`, `investmentType`, `protectionType`, `mortgageType` - required-on-create (type-specific), write-once
- `clientId` - required-on-create, write-once
- `productName`, `providerName`, `policyNumber` - required-on-create, updatable
- `status` - optional, updatable
- `startDate`, `endDate` - optional, updatable
- `currentValue` - optional, updatable
- `valuationDate` - optional, updatable (should match currentValue update)
- Type-specific fields - vary by arrangementType
- `createdAt`, `updatedAt` - read-only

---

### 11.6 Goal Contract

The `Goal` contract represents a client's financial goal.

**Reference Type:** Goal is a reference type with identity (has `id` field).

```json
{
  "id": "goal-888",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "goalType": "Retirement",
  "goalName": "Comfortable retirement at age 65",
  "description": "Build sufficient pension pot to support £40k annual income in retirement",
  "priority": "High",
  "targetAmount": {
    "amount": 500000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "targetDate": "2045-05-15",
  "yearsToGoal": 19,
  "currentSavings": {
    "amount": 125000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "monthlyContribution": {
    "amount": 500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "projectedShortfall": {
    "amount": 150000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "isAchievable": false,
  "status": "InProgress",
  "notes": "May need to increase contributions or adjust target",
  "createdAt": "2026-02-16T14:30:00Z",
  "updatedAt": "2026-02-16T15:45:00Z"
}
```

**Key Field Behaviors:**
- `id` - read-only, server-generated (uuid)
- `clientRef` - write-once, reference to Client
- `goalType` - required-on-create, updatable
- `goalName` - required-on-create, updatable
- `description` - optional, updatable
- `priority` - optional, updatable
- `targetAmount` - required-on-create, updatable (MoneyValue)
- `targetDate` - required-on-create, updatable
- `yearsToGoal` - read-only, computed from targetDate
- `currentSavings`, `monthlyContribution` - optional, updatable (MoneyValue)
- `projectedShortfall` - read-only, computed (MoneyValue)
- `isAchievable` - read-only, computed
- `status` - optional, updatable
- `createdAt`, `updatedAt` - read-only

---

### 11.7 RiskProfile Contract

The `RiskProfile` contract represents a client's risk assessment and attitude to risk.

**Reference Type:** RiskProfile is a reference type with identity (has `id` field).

```json
{
  "id": "riskprofile-999",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },
  "assessmentDate": "2026-02-16",
  "assessmentType": "ATR",
  "attitudeToRiskScore": 6,
  "attitudeToRiskRating": "Balanced",
  "capacityForLossScore": 7,
  "capacityForLossRating": "Medium",
  "overallRiskRating": "Balanced",
  "timeHorizon": "LongTerm",
  "yearsToRetirement": 19,
  "investmentExperience": "Moderate",
  "hasInvestedBefore": true,
  "understandsRisk": true,
  "comfortableWithVolatility": true,
  "wouldAcceptLosses": false,
  "notes": "Client understands market volatility but nervous about large losses",
  "questionsAndAnswers": [
    {
      "question": "How would you react to a 20% fall in your portfolio?",
      "answer": "Hold steady and wait for recovery",
      "score": 6
    }
  ],
  "validUntil": "2027-02-16",
  "reviewDate": "2027-02-16",
  "isValid": true,
  "createdAt": "2026-02-16T14:30:00Z",
  "updatedAt": "2026-02-16T15:45:00Z"
}
```

**Key Field Behaviors:**
- `id` - read-only, server-generated
- `clientId` - write-once, set from URL or required-on-create
- `assessmentDate` - required-on-create, updatable
- `assessmentType` - required-on-create, write-once
- `attitudeToRiskScore`, `capacityForLossScore` - required-on-create, updatable
- `attitudeToRiskRating`, `capacityForLossRating`, `overallRiskRating` - read-only, computed from scores
- `timeHorizon`, `yearsToRetirement` - optional, updatable
- `investmentExperience` - optional, updatable
- Boolean fields (`hasInvestedBefore`, `understandsRisk`, etc.) - optional, updatable
- `questionsAndAnswers` - optional, updatable (array)
- `validUntil`, `reviewDate` - optional, updatable
- `isValid` - read-only, computed from validUntil date
- `createdAt`, `updatedAt` - read-only

---

### 11.8 Collection Response Wrapper

All list/collection endpoints use a standard wrapper contract:

```json
{
  "data": [
    { /* Complete entity contract */ },
    { /* Complete entity contract */ }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalPages": 5,
    "totalCount": 95,
    "hasMore": true
  },
  "_links": {
    "first": { "href": "/api/v1/clients?page=1&pageSize=20" },
    "prev": null,
    "self": { "href": "/api/v1/clients?page=1&pageSize=20" },
    "next": { "href": "/api/v1/clients?page=2&pageSize=20" },
    "last": { "href": "/api/v1/clients?page=5&pageSize=20" }
  }
}
```

The `data` array contains complete entity contracts. Clients can use field selection (`?fields=id,name`) to reduce response size.

---

### 11.9 Contract Extension for Other Entities

All other entities in the FactFind system follow the same Single Contract Principle:

**Circumstances Entities:**
- `Employment` - Employment history within FactFind
- `Expenditure` - Expenditure items within FactFind
- `Asset` - Assets (property, savings, investments)
- `Liability` - Liabilities (mortgages, loans, credit cards)

**Estate Planning Entities:**
- `Gift` - Gifts made or intended
- `GiftTrust` - Trust arrangements for gifts
- `Beneficiary` - Beneficiaries of estates/trusts

**Relationship Entities:**
- `Relationship` - Client relationships (spouse, partner, ex-partner)
- `Dependant` - Dependent family members
- `ProfessionalContact` - Solicitors, accountants, other advisers

**Reference Data Entities:**
- `Provider` - Financial product providers
- `ProductCategory` - Product categorization
- `EnumValue` - Dynamic enumeration values

Each entity contract follows the same field annotation pattern:
- Fields marked as `required-on-create`, `optional`, `read-only`, `write-once`, or `updatable`
- Same contract used for POST, PUT, PATCH, and GET
- Collection responses wrapped in standard pagination envelope
- Field selection supported via `?fields` query parameter

### 11.10 Standard Value Types

Value types are embedded data structures with no independent identity. They are named with a "Value" suffix and never have an `id` field. Value types are always embedded within their parent entity and have no separate API endpoints.

#### 11.10.1 MoneyValue

Represents a monetary amount with currency.

**Contract:**
```json
{
  "amount": 75000.00,
  "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
}
```

**Fields:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `amount` | decimal | Yes | - | Monetary amount (positive or negative) |
| `currency` | CurrencyValue | Yes | - | Currency details (code, display, symbol) |

**Validation Rules:**
- `amount`: Precision 19, scale 4 (e.g., 9999999999999999.9999)
- `currency.code`: Must be valid ISO 4217 code (GBP, USD, EUR, etc.)

**Usage Example:**
```json
{
  "grossAnnualIncome": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "netMonthlyIncome": {
    "amount": 4500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  }
}
```

#### 11.10.2 AddressValue

Represents a physical address.

**Contract:**
```json
{
  "line1": "123 Main Street",
  "line2": "Flat 4B",
  "line3": null,
  "line4": null,
  "city": "London",
  "county": {
    "code": "GLA",
    "display": "Greater London"
  },
  "postcode": "SW1A 1AA",
  "country": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "addressType": {
    "code": "RES",
    "display": "Residential"
  }
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `line1` | string | Yes | Address line 1 (max 100 chars) |
| `line2` | string | No | Address line 2 (max 100 chars) |
| `line3` | string | No | Address line 3 (max 100 chars) |
| `line4` | string | No | Address line 4 (max 100 chars) |
| `city` | string | Yes | City/town (max 50 chars) |
| `county` | CountyValue | No | County/state with code and display name |
| `postcode` | string | Yes | Postal/ZIP code (max 20 chars) |
| `country` | CountryValue | Yes | Country with ISO codes and display name |
| `addressType` | AddressTypeValue | No | Type of address (Residential, Correspondence, etc.) |

**Validation Rules:**
- `country.code`: Must be valid ISO 3166-1 alpha-2 code (GB, US, FR, etc.)
- `postcode`: Format validation based on country

**Usage Example:**
```json
{
  "primaryAddress": {
    "line1": "10 Downing Street",
    "city": "London",
    "county": {
      "code": "GLA",
      "display": "Greater London"
    },
    "postcode": "SW1A 2AA",
    "country": {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    },
    "addressType": {
      "code": "RES",
      "display": "Residential"
    }
  }
}
```

#### 11.10.3 DateRangeValue

Represents a date range with start and optional end date.

**Contract:**
```json
{
  "startDate": "2020-01-01",
  "endDate": "2025-12-31"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `startDate` | date | Yes | Start date (ISO 8601: YYYY-MM-DD) |
| `endDate` | date | No | End date (ISO 8601: YYYY-MM-DD), null = ongoing |

**Validation Rules:**
- `endDate` must be after `startDate` if provided
- Both dates must be valid calendar dates

**Usage Example:**
```json
{
  "employmentPeriod": {
    "startDate": "2015-06-01",
    "endDate": null
  }
}
```

#### 11.10.4 NameValue

Represents a person's name.

**Contract:**
```json
{
  "title": {
    "code": "MR",
    "display": "Mr"
  },
  "firstName": "John",
  "middleName": "Michael",
  "lastName": "Smith",
  "preferredName": "Johnny"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | TitleValue | No | Title/honorific with code and display |
| `firstName` | string | Yes | First name (max 50 chars) |
| `middleName` | string | No | Middle name(s) (max 50 chars) |
| `lastName` | string | Yes | Last name/surname (max 50 chars) |
| `preferredName` | string | No | Preferred name/nickname (max 50 chars) |

**Usage Example:**
```json
{
  "name": {
    "title": {
      "code": "DR",
      "display": "Dr"
    },
    "firstName": "Jane",
    "lastName": "Doe",
    "preferredName": "Janey"
  }
}
```

#### 11.10.5 ContactValue

Represents contact information (email, phone).

**Contract:**
```json
{
  "type": {
    "code": "EMAIL",
    "display": "Email"
  },
  "value": "john.smith@example.com",
  "isPrimary": true
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `type` | ContactTypeValue | Yes | Contact type with code and display (EMAIL, MOBILE, HOME, WORK, FAX) |
| `value` | string | Yes | Contact value (email address or phone number) |
| `isPrimary` | boolean | No | Whether this is the primary contact method |

**Validation Rules:**
- `value`: Format validation based on `type.code` (email format, phone number format)

**Usage Example:**
```json
{
  "contacts": [
    {
      "type": {
        "code": "EMAIL",
        "display": "Email"
      },
      "value": "john@example.com",
      "isPrimary": true
    },
    {
      "type": {
        "code": "MOBILE",
        "display": "Mobile"
      },
      "value": "+44 7700 900123",
      "isPrimary": false
    }
  ]
}
```

#### 11.10.6 PercentageValue

Represents a percentage as a decimal value.

**Contract:**
```json
{
  "value": 0.25
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `value` | decimal | Yes | Percentage value (0.00 = 0%, 1.00 = 100%) |

**Validation Rules:**
- `value`: Must be between 0.00 and 1.00 (or other specified range)

**Usage Example:**
```json
{
  "contributionRate": {
    "value": 0.08
  },
  "taxRate": {
    "value": 0.20
  }
}
```

#### 11.10.7 RateValue

Represents an interest rate or other rate.

**Contract:**
```json
{
  "rate": 3.5,
  "type": "Fixed"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `rate` | decimal | Yes | Rate value (e.g., 3.5 for 3.5%) |
| `type` | enum | No | Rate type: Fixed, Variable, Tracker, Discount, Capped |

**Usage Example:**
```json
{
  "interestRate": {
    "rate": 2.75,
    "type": "Fixed"
  },
  "projectedGrowthRate": {
    "rate": 5.0,
    "type": "Variable"
  }
}
```

#### 11.10.8 TaxDetailsValue

Represents tax identification details.

**Contract:**
```json
{
  "niNumber": "AB123456C",
  "taxReference": "1234567890"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `niNumber` | string | No | UK National Insurance Number (9 chars) |
| `taxReference` | string | No | Tax reference number (10 chars) |

**Validation Rules:**
- `niNumber`: Format AA123456A (2 letters, 6 digits, 1 letter)
- `taxReference`: 10-digit UTR format

**Usage Example:**
```json
{
  "taxDetails": {
    "niNumber": "AB123456C",
    "taxReference": "1234567890"
  }
}
```

#### 11.10.9 Enumeration Value Types

Enumeration value types represent categorical data using a structured code/display pattern. Unlike simple string enumerations, enumeration value types are self-documenting, internationalization-ready, and can carry rich metadata.

**Standard Pattern:**
All enumeration value types follow a consistent structure:
```json
{
  "code": "MACHINE_READABLE_CODE",    // Required: Uppercase, short identifier
  "display": "Human Readable Label",  // Required: User-facing label
  // ... additional metadata as needed
}
```

**Benefits:**
- Self-documenting: No need to look up code meanings
- Internationalization-ready: Display text can be localized
- Rich metadata: Dates, categories, and other context
- Forward-compatible: Can add fields without breaking changes
- Type-safe: Strongly typed in contract definitions

---

##### GenderValue

Represents a person's gender.

**Contract:**
```json
{
  "code": "M",
  "display": "Male"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Gender code: M, F, O, U, N |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `M` - Male
- `F` - Female
- `O` - Other
- `U` - Unknown
- `N` - Prefer not to say

**Usage Example:**
```json
{
  "gender": {
    "code": "M",
    "display": "Male"
  }
}
```

---

##### MaritalStatusValue

Represents a person's marital status with optional effective date.

**Contract:**
```json
{
  "code": "MAR",
  "display": "Married",
  "effectiveFrom": "2015-06-20"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Marital status code |
| `display` | string | Yes | Human-readable label |
| `effectiveFrom` | date | No | Date this status became effective (ISO 8601) |

**Standard Codes:**
- `SIN` - Single
- `MAR` - Married
- `CIV` - Civil Partnership
- `DIV` - Divorced
- `WID` - Widowed
- `SEP` - Separated
- `COH` - Cohabiting

**Usage Example:**
```json
{
  "maritalStatus": {
    "code": "MAR",
    "display": "Married",
    "effectiveFrom": "2015-06-20"
  }
}
```

---

##### EmploymentStatusValue

Represents a person's employment status.

**Contract:**
```json
{
  "code": "EMP",
  "display": "Employed"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Employment status code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `EMP` - Employed
- `SELF` - Self-Employed
- `DIR` - Company Director
- `RET` - Retired
- `UNE` - Unemployed
- `NW` - Not Working
- `STU` - Student
- `HOME` - Homemaker

**Usage Example:**
```json
{
  "employmentStatus": {
    "code": "EMP",
    "display": "Employed"
  }
}
```

---

##### AddressTypeValue

Represents the type of an address.

**Contract:**
```json
{
  "code": "RES",
  "display": "Residential"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Address type code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `RES` - Residential
- `CORR` - Correspondence
- `PREV` - Previous
- `WORK` - Work
- `OTHER` - Other

**Usage Example:**
```json
{
  "addressType": {
    "code": "RES",
    "display": "Residential"
  }
}
```

---

##### ContactTypeValue

Represents the type of contact information.

**Contract:**
```json
{
  "code": "EMAIL",
  "display": "Email"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Contact type code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `EMAIL` - Email
- `MOBILE` - Mobile Phone
- `HOME` - Home Phone
- `WORK` - Work Phone
- `FAX` - Fax

**Usage Example:**
```json
{
  "type": {
    "code": "EMAIL",
    "display": "Email"
  }
}
```

---

##### TitleValue

Represents a person's title or honorific.

**Contract:**
```json
{
  "code": "MR",
  "display": "Mr"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Title code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `MR` - Mr
- `MRS` - Mrs
- `MS` - Ms
- `MISS` - Miss
- `DR` - Dr
- `PROF` - Professor
- `REV` - Reverend
- `SIR` - Sir
- `LADY` - Lady
- `LORD` - Lord

**Usage Example:**
```json
{
  "title": {
    "code": "MR",
    "display": "Mr"
  }
}
```

---

##### ProductTypeValue

Represents a financial product type with optional category.

**Contract:**
```json
{
  "code": "SIPP",
  "display": "Self-Invested Personal Pension",
  "category": "Pension"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Product type code |
| `display` | string | Yes | Human-readable label |
| `category` | string | No | Product category grouping |

**Standard Codes:**
- Pensions: `PP` (Personal Pension), `SIPP` (SIPP), `GPP` (Group Personal Pension), `SSAS` (SSAS), `DB` (Defined Benefit), `SP` (State Pension)
- Investments: `ISA` (ISA), `GIA` (General Investment Account), `JISA` (Junior ISA), `LISA` (Lifetime ISA), `OIC` (Offshore Investment)
- Protection: `LIFE` (Life Insurance), `CIC` (Critical Illness), `IP` (Income Protection), `PMI` (Private Medical Insurance)
- Mortgages: `RESMTG` (Residential Mortgage), `BTL` (Buy-to-Let), `EQUITY` (Equity Release)
- Other: `BOND` (Investment Bond), `TRUST` (Trust), `SAVINGS` (Savings Account)

**Usage Example:**
```json
{
  "productType": {
    "code": "SIPP",
    "display": "Self-Invested Personal Pension",
    "category": "Pension"
  }
}
```

---

##### CountryValue

Represents a country using ISO 3166-1 standard codes.

**Contract:**
```json
{
  "code": "GB",
  "display": "United Kingdom",
  "alpha3": "GBR"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | ISO 3166-1 alpha-2 country code (2 chars) |
| `display` | string | Yes | Full country name |
| `alpha3` | string | No | ISO 3166-1 alpha-3 country code (3 chars) |

**Usage Example:**
```json
{
  "country": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  }
}
```

---

##### CountyValue

Represents a county or administrative region.

**Contract:**
```json
{
  "code": "GLA",
  "display": "Greater London",
  "country": {
    "code": "GB",
    "display": "United Kingdom"
  }
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | County/region code |
| `display` | string | Yes | Full county/region name |
| `country` | CountryValue | No | Associated country |

**Usage Example:**
```json
{
  "county": {
    "code": "GLA",
    "display": "Greater London",
    "country": {
      "code": "GB",
      "display": "United Kingdom"
    }
  }
}
```

---

##### CurrencyValue

Represents a currency using ISO 4217 standard codes.

**Contract:**
```json
{
  "code": "GBP",
  "display": "British Pound",
  "symbol": "£"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | ISO 4217 currency code (3 chars) |
| `display` | string | Yes | Full currency name |
| `symbol` | string | No | Currency symbol (£, $, €, etc.) |

**Standard Codes:**
- `GBP` - British Pound (£)
- `USD` - US Dollar ($)
- `EUR` - Euro (€)
- `CHF` - Swiss Franc (CHF)
- `JPY` - Japanese Yen (¥)
- `AUD` - Australian Dollar (A$)
- `CAD` - Canadian Dollar (C$)

**Usage Example:**
```json
{
  "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
}
```

---

##### FrequencyValue

Represents payment or contribution frequency.

**Contract:**
```json
{
  "code": "M",
  "display": "Monthly",
  "periodsPerYear": 12
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Frequency code |
| `display` | string | Yes | Human-readable label |
| `periodsPerYear` | integer | No | Number of periods per year (for calculations) |

**Standard Codes:**
- `M` - Monthly (12 periods/year)
- `Q` - Quarterly (4 periods/year)
- `S` - Semi-Annual (2 periods/year)
- `A` - Annual (1 period/year)
- `W` - Weekly (52 periods/year)
- `F` - Fortnightly (26 periods/year)
- `SINGLE` - Single Payment (0 periods/year)

**Usage Example:**
```json
{
  "frequency": {
    "code": "M",
    "display": "Monthly",
    "periodsPerYear": 12
  }
}
```

---

##### StatusValue

Represents a generic status with optional category.

**Contract:**
```json
{
  "code": "ACT",
  "display": "Active",
  "category": "Arrangement"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Status code |
| `display` | string | Yes | Human-readable label |
| `category` | string | No | Status category grouping |

**Standard Codes:**
- `ACT` - Active
- `INA` - Inactive
- `PEN` - Pending
- `COM` - Completed
- `CAN` - Cancelled
- `SUB` - Submitted
- `APP` - Approved
- `REJ` - Rejected
- `DRAFT` - Draft
- `CLOSED` - Closed

**Usage Example:**
```json
{
  "status": {
    "code": "ACT",
    "display": "Active",
    "category": "Arrangement"
  }
}
```

---

##### MeetingTypeValue

Represents the type of a client meeting.

**Contract:**
```json
{
  "code": "INIT",
  "display": "Initial Meeting"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Meeting type code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `INIT` - Initial Meeting
- `REVIEW` - Review Meeting
- `ANNUAL` - Annual Review
- `ADHOC` - Ad-hoc Meeting
- `PHONE` - Phone Call
- `VIDEO` - Video Conference

**Usage Example:**
```json
{
  "meetingType": {
    "code": "INIT",
    "display": "Initial Meeting"
  }
}
```

---

##### ResidencyStatusValue

Represents tax residency status.

**Contract:**
```json
{
  "code": "UK_RES",
  "display": "UK Resident"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Residency status code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `UK_RES` - UK Resident
- `UK_DOM` - UK Domiciled
- `NON_RES` - Non-Resident
- `NON_DOM` - Non-Domiciled
- `EXPAT` - Expatriate

**Usage Example:**
```json
{
  "residencyStatus": {
    "code": "UK_RES",
    "display": "UK Resident"
  }
}
```

---

##### HealthStatusValue

Represents a person's health status for insurance purposes.

**Contract:**
```json
{
  "code": "GOOD",
  "display": "Good Health"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Health status code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `GOOD` - Good Health
- `FAIR` - Fair Health
- `POOR` - Poor Health
- `PREEX` - Pre-existing Conditions
- `UNKNOWN` - Unknown

**Usage Example:**
```json
{
  "healthStatus": {
    "code": "GOOD",
    "display": "Good Health"
  }
}
```

---

### 11.11 Standard Reference Types

Reference types represent entities with independent identity. They are referenced from other entities using an expanded reference object containing `id`, `href`, and display fields. Reference fields are named with a "Ref" suffix (e.g., `clientRef`, `adviserRef`).

#### 11.11.1 ClientRef

Reference to a Client entity.

**Minimal Contract (Required for Create/Update):**
```json
{
  "id": "client-123"
}
```

**Full Contract (Server Response):**
```json
{
  "id": "client-123",
  "href": "/api/v1/clients/client-123",
  "name": "John Michael Smith",
  "clientNumber": "C00001234",
  "type": "Person"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique client identifier |
| `href` | string | Yes (response) | URL to client resource |
| `name` | string | Yes (response) | Full client name |
| `clientNumber` | string | No | Business client number |
| `type` | enum | No | Client type: Person, Corporate, Trust |

**Usage Example:**
```json
{
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  }
}
```

#### 11.11.2 AdviserRef

Reference to an Adviser entity.

**Full Contract:**
```json
{
  "id": "adviser-789",
  "href": "/api/v1/advisers/adviser-789",
  "name": "Sarah Johnson",
  "code": "ADV001"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique adviser identifier |
| `href` | string | Yes (response) | URL to adviser resource |
| `name` | string | Yes (response) | Adviser full name |
| `code` | string | No | Adviser business code |

**Usage Example:**
```json
{
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Sarah Johnson",
    "code": "ADV001"
  }
}
```

#### 11.11.3 ProviderRef

Reference to a financial product Provider entity.

**Full Contract:**
```json
{
  "id": "provider-456",
  "href": "/api/v1/providers/provider-456",
  "name": "Aviva Life & Pensions UK Limited",
  "frnNumber": "185896"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique provider identifier |
| `href` | string | Yes (response) | URL to provider resource |
| `name` | string | Yes (response) | Provider name |
| `frnNumber` | string | No | FCA Firm Reference Number |

**Usage Example:**
```json
{
  "providerRef": {
    "id": "provider-456",
    "href": "/api/v1/providers/provider-456",
    "name": "Aviva",
    "frnNumber": "185896"
  }
}
```

#### 11.11.4 ArrangementRef

Reference to an Arrangement entity (pension, investment, protection, mortgage).

**Full Contract:**
```json
{
  "id": "arrangement-111",
  "href": "/api/v1/arrangements/arrangement-111",
  "policyNumber": "POL123456",
  "productType": "Pension",
  "provider": "Aviva"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique arrangement identifier |
| `href` | string | Yes (response) | URL to arrangement resource |
| `policyNumber` | string | No | Policy/plan number |
| `productType` | string | Yes (response) | Product type (Pension, Investment, etc.) |
| `provider` | string | Yes (response) | Provider name |

**Usage Example:**
```json
{
  "arrangementRef": {
    "id": "arrangement-111",
    "href": "/api/v1/arrangements/arrangement-111",
    "policyNumber": "SIPP123456",
    "productType": "Pension",
    "provider": "Aviva"
  }
}
```

#### 11.11.5 EmploymentRef

Reference to an Employment entity.

**Full Contract:**
```json
{
  "id": "employment-222",
  "href": "/api/v1/employments/employment-222",
  "employerName": "Acme Corporation Ltd",
  "status": "Current"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique employment identifier |
| `href` | string | Yes (response) | URL to employment resource |
| `employerName` | string | Yes (response) | Employer name |
| `status` | enum | Yes (response) | Status: Current, Previous, Future |

**Usage Example:**
```json
{
  "employmentRef": {
    "id": "employment-222",
    "href": "/api/v1/employments/employment-222",
    "employerName": "Acme Corp",
    "status": "Current"
  }
}
```

#### 11.11.6 GoalRef

Reference to a Goal entity.

**Full Contract:**
```json
{
  "id": "goal-333",
  "href": "/api/v1/goals/goal-333",
  "goalName": "Retirement at 65",
  "priority": "High"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique goal identifier |
| `href` | string | Yes (response) | URL to goal resource |
| `goalName` | string | Yes (response) | Goal name/description |
| `priority` | enum | No | Priority: High, Medium, Low |

**Usage Example:**
```json
{
  "goalRef": {
    "id": "goal-333",
    "href": "/api/v1/goals/goal-333",
    "goalName": "Retirement Planning",
    "priority": "High"
  }
}
```

#### 11.11.7 FactFindRef

Reference to a FactFind (ADVICE_CASE) entity.

**Full Contract:**
```json
{
  "id": "factfind-444",
  "href": "/api/v1/factfinds/factfind-444",
  "factFindNumber": "FF001234",
  "status": "InProgress"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique fact find identifier |
| `href` | string | Yes (response) | URL to fact find resource |
| `factFindNumber` | string | No | Business fact find number |
| `status` | enum | Yes (response) | Status: Draft, InProgress, Complete, Submitted |

**Usage Example:**
```json
{
  "factFindRef": {
    "id": "factfind-444",
    "href": "/api/v1/factfinds/factfind-444",
    "factFindNumber": "FF001234",
    "status": "InProgress"
  }
}
```

---

## 12. Reference Data API

### 12.1 Performance Considerations

**Query Optimization:**
- Index all foreign keys for fast joins
- Index commonly filtered fields (status, clientType, dateOfBirth)
- Use covering indexes for list queries
- Implement query result caching (Redis)

**Lazy vs Eager Loading:**
- Default: Lazy load related entities
- Use `expand` query parameter for eager loading
- Limit expansion depth to 2 levels
- Cache expanded results aggressively

**Pagination:**
- Cursor-based pagination for large datasets (>10,000 records)
- Offset-based pagination acceptable for small datasets
- Default page size: 20
- Maximum page size: 100

### 12.2 Caching Strategy

**HTTP Caching:**
- ETags for all GET requests on single resources
- Cache-Control: private for user-specific data
- Cache-Control: public for reference data
- Vary header based on Accept-Language, Authorization

**Application Caching (Redis):**
- Reference data: 24 hours TTL
- Enum values: 7 days TTL
- Client lists: 5 minutes TTL
- Client details: 15 minutes TTL
- FactFind summaries: 5 minutes TTL

**Cache Invalidation:**
- Invalidate on write operations (POST, PUT, PATCH, DELETE)
- Publish cache invalidation events
- Subscribers update local caches

### 12.3 Rate Limiting

**Per-User Limits:**
- 1,000 requests per hour per user
- 100 requests per minute per user
- Burst allowance: 10 requests per second

**Per-Tenant Limits:**
- 10,000 requests per hour per tenant
- 1,000 requests per minute per tenant

**Headers:**
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 847
X-RateLimit-Reset: 1708088400
```

**Rate Limit Exceeded Response:**
```http
HTTP/1.1 429 Too Many Requests
Retry-After: 3600

{
  "type": "https://api.factfind.com/problems/rate-limit-error",
  "title": "Rate Limit Exceeded",
  "status": 429,
  "detail": "You have exceeded the rate limit of 1000 requests per hour",
  "retryAfter": 3600
}
```

### 12.4 API Versioning

**Version Lifecycle:**
1. **Development** - Not publicly available
2. **Beta** - Available for early adopters, may change
3. **Stable** - Production-ready, fully supported
4. **Deprecated** - Maintenance mode, 12 months notice before sunset
5. **Sunset** - No longer available, returns 410 Gone

**Deprecation Process:**
1. Announce deprecation 12 months in advance
2. Include `Deprecation` header in responses
3. Provide migration guide
4. Support parallel versions during transition
5. Sunset after transition period

**Deprecation Header:**
```http
Deprecation: Sun, 01 Jan 2028 00:00:00 GMT
Sunset: Sun, 01 Jul 2028 00:00:00 GMT
Link: <https://docs.factfind.com/migration/v1-to-v2>; rel="deprecation"
```

### 12.5 Security Best Practices

**Input Validation:**
- Validate all inputs against schema
- Sanitize user input to prevent injection attacks
- Use parameterized queries for database access
- Validate content-type headers

**Output Encoding:**
- Encode all output to prevent XSS
- Use appropriate content-type headers
- Implement CSP (Content Security Policy)

**HTTPS/TLS:**
- Require TLS 1.2 or higher
- Use strong cipher suites
- Implement HSTS (HTTP Strict Transport Security)
- Certificate pinning for mobile apps

**API Keys & Tokens:**
- Rotate secrets regularly (90 days)
- Use short-lived access tokens (1 hour)
- Long-lived refresh tokens (30 days)
- Revoke tokens on logout or compromise

---


## 13. Entity Contracts

This section defines the unified entity contracts used throughout the FactFind API. Following the **Single Contract Principle** (Section 1.7), each entity has one canonical contract used for both requests (POST, PUT, PATCH) and responses (GET).

Each field is annotated with its behavioral characteristics:
- **required-on-create** - Must be provided when creating the entity
- **optional** - Can be omitted in any operation
- **read-only** - System-generated, cannot be set by clients
- **write-once** - Can only be set on create, immutable thereafter
- **updatable** - Can be modified via PUT/PATCH operations

### 13.1 Client Contract

The `Client` contract represents a client entity (Person, Corporate, or Trust) with all demographic and regulatory information.

**Reference Type:** Client is a reference type with identity (has `id` field).

```json
{
  "id": "client-123",
  "factFindRef": {
    "id": "factfind-456",
    "href": "/api/v1/factfinds/factfind-456",
    "factFindNumber": "FF-2025-00123",
    "status": {
      "code": "INP",
      "display": "In Progress"
    }
  },
  "clientNumber": "C00001234",
  "clientType": "Person",
  "name": {
    "title": {
      "code": "MR",
      "display": "Mr"
    },
    "firstName": "John",
    "middleName": "Michael",
    "lastName": "Smith",
    "preferredName": "John"
  },
  "fullName": "Mr John Michael Smith",
  "salutation": "Mr Smith",
  "dateOfBirth": "1980-05-15",
  "age": 45,
  "placeOfBirth": "London",
  "gender": {
    "code": "M",
    "display": "Male"
  },
  "maritalStatus": {
    "code": "MAR",
    "display": "Married",
    "effectiveFrom": "2005-06-20"
  },
  "taxDetails": {
    "niNumber": "AB123456C",
    "taxReference": "1234567890"
  },
  "nationalClientIdentifier": "NCI-123456",
  "passportRef": "502135321",
  "passportExpiryDate": "2030-05-15",
  "drivingLicenceRef": "SMITH801055JM9IJ",
  "drivingLicenceExpiryDate": "2030-05-15",
  "nationalityCountry": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "countryOfBirth": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "countryOfResidence": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "countryOfDomicile": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "isUkResident": true,
  "isExpatriate": false,
  "isDeceased": false,
  "deceasedOn": null,
  "hasWill": true,
  "isWillUpToDate": true,
  "isWillAdvised": true,
  "willDetails": "Will created in 2020, held by Smith & Co Solicitors",
  "isPowerOfAttorneyGranted": false,
  "powerOfAttorneyName": null,
  "hasEverSmoked": false,
  "isSmoker": "Never",
  "hasSmokedInLast12Months": "No",
  "hasNicotineReplacementInLastYear": "No",
  "hasVapedInLastYear": "No",
  "inGoodHealth": true,
  "medicalConditions": null,
  "isMatchingServiceProposition": false,
  "matchingServicePropositionReason": null,
  "isHeadOfFamilyGroup": true,
  "isJoint": true,
  "spouseRef": {
    "id": "client-124",
    "href": "/api/v1/clients/client-124",
    "name": "Sarah Smith",
    "clientNumber": "C00001235",
    "type": "Person"
  },
  "serviceStatus": "Active",
  "serviceStatusDate": "2020-01-15",
  "clientSegment": "A",
  "clientSegmentDate": "2020-01-15",
  "clientCategory": "HighNetWorth",
  "grossAnnualIncome": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "householdIncome": {
    "amount": 120000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "netWorth": {
    "amount": 450000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "householdNetWorth": {
    "amount": 650000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalAssets": {
    "amount": 500000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalJointAssets": {
    "amount": 200000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "primaryAddress": {
    "line1": "123 Main Street",
    "line2": "Apartment 4B",
    "city": "London",
    "county": {
      "code": "GLA",
      "display": "Greater London"
    },
    "postcode": "SW1A 1AA",
    "country": {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    },
    "addressType": {
      "code": "RES",
      "display": "Residential"
    }
  },
  "contacts": [
    {
      "type": {
        "code": "EMAIL",
        "display": "Email"
      },
      "value": "john.smith@example.com",
      "isPrimary": true
    },
    {
      "type": {
        "code": "MOBILE",
        "display": "Mobile"
      },
      "value": "+44 7700 900123",
      "isPrimary": false
    }
  ],
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },
  "paraplannerRef": {
    "id": "adviser-790",
    "href": "/api/v1/advisers/adviser-790",
    "name": "Mark Taylor",
    "code": "PP001"
  },
  "idCheckCompletedDate": "2020-01-10",
  "idCheckExpiryDate": "2025-01-10",
  "idCheckIssuer": "Experian",
  "idCheckReference": "IDC-123456",
  "idCheckResult": "Passed",
  "taxCode": "1257L",
  "notes": "Prefers email communication, interested in sustainable investing",
  "profilePicture": "https://cdn.factfind.com/profiles/client-123.jpg",
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "createdBy": {
    "id": "user-999",
    "name": "System Admin"
  },
  "updatedBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "_links": {
    "self": { "href": "/api/v1/clients/client-123" },
    "update": { "href": "/api/v1/clients/client-123", "method": "PUT" },
    "delete": { "href": "/api/v1/clients/client-123", "method": "DELETE" },
    "addresses": { "href": "/api/v1/clients/client-123/addresses" },
    "contacts": { "href": "/api/v1/clients/client-123/contacts" },
    "relationships": { "href": "/api/v1/clients/client-123/relationships" },
    "dependants": { "href": "/api/v1/clients/client-123/dependants" },
    "factfinds": { "href": "/api/v1/factfinds?clientId=client-123" },
    "arrangements": { "href": "/api/v1/arrangements?clientId=client-123" },
    "goals": { "href": "/api/v1/goals?clientId=client-123" },
    "riskProfile": { "href": "/api/v1/risk-profiles?clientId=client-123" }
  }
}
```

**Field Behaviors:**

| Field | Type | Create | Update | Response | Notes |
|-------|------|--------|--------|----------|-------|
| `id` | uuid | ignored | ignored | included | read-only, server-generated |
| `factFindRef` | FactFindRef | required | ignored | included | Reference to owning FactFind, write-once |
| `clientNumber` | string | optional | ignored | included | write-once, business identifier |
| `clientType` | enum | required | ignored | included | write-once, discriminator field |
| `name` | NameValue | required | updatable | included | Value type: firstName, lastName required |
| `fullName` | string | ignored | ignored | included | read-only, computed from name |
| `salutation` | string | optional | updatable | included | - |
| `dateOfBirth` | date | required | ignored | included | write-once, immutable after creation |
| `age` | integer | ignored | ignored | included | read-only, computed from dateOfBirth |
| `placeOfBirth` | string | optional | updatable | included | - |
| `gender` | GenderValue | optional | updatable | included | Value type: code/display enumeration |
| `maritalStatus` | MaritalStatusValue | optional | updatable | included | Value type: code/display/effectiveFrom |
| `taxDetails` | TaxDetailsValue | optional | updatable | included | Value type: PII, requires `client:pii:read` scope |
| `nationalClientIdentifier` | string | optional | updatable | included | - |
| `passportRef` | string | optional | updatable | included | PII, requires `client:pii:read` scope |
| `passportExpiryDate` | date | optional | updatable | included | - |
| `drivingLicenceRef` | string | optional | updatable | included | PII, requires `client:pii:read` scope |
| `drivingLicenceExpiryDate` | date | optional | updatable | included | - |
| `nationalityCountry` | CountryValue | optional | updatable | included | Value type: ISO country code/display/alpha3 |
| `countryOfBirth` | CountryValue | optional | updatable | included | Value type: ISO country code/display/alpha3 |
| `countryOfResidence` | CountryValue | optional | updatable | included | Value type: ISO country code/display/alpha3 |
| `countryOfDomicile` | CountryValue | optional | updatable | included | Value type: ISO country code/display/alpha3 |
| `isUkResident` | boolean | optional | updatable | included | - |
| `isExpatriate` | boolean | optional | updatable | included | - |
| `isDeceased` | boolean | optional | updatable | included | - |
| `deceasedOn` | date | optional | updatable | included | - |
| `hasWill` | boolean | optional | updatable | included | - |
| `isWillUpToDate` | boolean | optional | updatable | included | - |
| `isWillAdvised` | boolean | optional | updatable | included | - |
| `willDetails` | string | optional | updatable | included | - |
| `isPowerOfAttorneyGranted` | boolean | optional | updatable | included | - |
| `powerOfAttorneyName` | string | optional | updatable | included | - |
| `hasEverSmoked` | boolean | optional | updatable | included | - |
| `isSmoker` | enum | optional | updatable | included | - |
| `hasSmokedInLast12Months` | enum | optional | updatable | included | - |
| `hasNicotineReplacementInLastYear` | enum | optional | updatable | included | - |
| `hasVapedInLastYear` | enum | optional | updatable | included | - |
| `inGoodHealth` | boolean | optional | updatable | included | - |
| `medicalConditions` | string | optional | updatable | included | - |
| `isMatchingServiceProposition` | boolean | optional | updatable | included | - |
| `matchingServicePropositionReason` | string | optional | updatable | included | - |
| `isHeadOfFamilyGroup` | boolean | optional | updatable | included | - |
| `isJoint` | boolean | optional | updatable | included | - |
| `spouseRef` | ClientRef | optional | updatable | included | Reference type: Provide id on create/update |
| `serviceStatus` | enum | optional | updatable | included | - |
| `serviceStatusDate` | date | optional | updatable | included | - |
| `clientSegment` | string | optional | updatable | included | - |
| `clientSegmentDate` | date | optional | updatable | included | - |
| `clientCategory` | enum | optional | updatable | included | - |
| `grossAnnualIncome` | MoneyValue | optional | updatable | included | Value type: amount + currency |
| `householdIncome` | MoneyValue | optional | updatable | included | Value type: amount + currency |
| `netWorth` | MoneyValue | optional | updatable | included | Value type: amount + currency |
| `householdNetWorth` | MoneyValue | optional | updatable | included | Value type: amount + currency |
| `totalAssets` | MoneyValue | ignored | ignored | included | read-only, computed from arrangements |
| `totalJointAssets` | MoneyValue | ignored | ignored | included | read-only, computed |
| `primaryAddress` | AddressValue | optional | updatable | included | Value type: Embedded address, no id |
| `contacts` | ContactValue[] | optional | updatable | included | Value type array: Email, phone contacts |
| `adviserRef` | AdviserRef | optional | updatable | included | Reference type: Primary adviser |
| `paraplannerRef` | AdviserRef | optional | updatable | included | Reference type: Paraplanner |
| `idCheckCompletedDate` | date | optional | updatable | included | - |
| `idCheckExpiryDate` | date | optional | updatable | included | - |
| `idCheckIssuer` | string | optional | updatable | included | - |
| `idCheckReference` | string | optional | updatable | included | - |
| `idCheckResult` | enum | optional | updatable | included | - |
| `taxCode` | string | optional | updatable | included | - |
| `notes` | string | optional | updatable | included | - |
| `profilePicture` | string | optional | updatable | included | URL to profile image |
| `createdAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `updatedAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `createdBy` | object | ignored | ignored | included | read-only, audit trail |
| `updatedBy` | object | ignored | ignored | included | read-only, audit trail |
| `_links` | object | ignored | ignored | included | read-only, HATEOAS links |

**Usage Examples:**

**Creating a Client (POST /api/v1/clients):**
```json
{
  "clientType": "Person",
  "name": {
    "title": "Mr",
    "firstName": "John",
    "lastName": "Smith"
  },
  "dateOfBirth": "1980-05-15",
  "gender": "Male",
  "nationalityCountry": { "code": "GB" },
  "primaryAddress": {
    "line1": "123 Main Street",
    "city": "London",
    "postcode": "SW1A 1AA",
    "country": "GB"
  },
  "contacts": [
    {
      "type": "Email",
      "value": "john.smith@example.com",
      "isPrimary": true
    }
  ],
  "adviserRef": {
    "id": "adviser-789"
  }
}
```
Server generates `id`, `clientNumber`, `createdAt`, `updatedAt`, `fullName`, `age`, and populates reference display fields. Returns complete contract.

**Updating a Client (PUT /api/v1/clients/client-123):**
```json
{
  "name": {
    "title": "Mr",
    "firstName": "John",
    "lastName": "Smith-Jones"
  },
  "gender": "Male",
  "maritalStatus": "Married",
  "nationalityCountry": { "code": "GB" },
  "grossAnnualIncome": {
    "amount": 85000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "spouseRef": {
    "id": "client-124"
  }
}
```
Cannot change `dateOfBirth` (write-once). Server updates `updatedAt`, `fullName`, and returns complete contract.

**Partial Update (PATCH /api/v1/clients/client-123):**
```json
{
  "name": {
    "lastName": "Smith-Jones"
  },
  "maritalStatus": {
    "code": "MAR",
    "display": "Married",
    "effectiveFrom": "2015-06-20"
  },
  "householdIncome": {
    "amount": 145000.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
  }
}
```
Only specified fields are updated. Returns complete contract with changes applied.

---

### 13.2 FactFind Contract

The `FactFind` contract (also known as ADVICE_CASE) represents a fact-finding session and aggregate root for circumstances discovery.

**Reference Type:** FactFind is a reference type with identity (has `id` field).

Complete fact find aggregate root with summary calculations.

```json
{
  "id": "factfind-456",
  "factFindNumber": "FF001234",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "jointClientRef": {
    "id": "client-124",
    "href": "/api/v1/clients/client-124",
    "name": "Sarah Smith",
    "clientNumber": "C00001235",
    "type": "Person"
  },
  "dateOfMeeting": "2026-02-16",
  "typeOfMeeting": {
    "code": "INIT",
    "display": "Initial Consultation"
  },
  "clientsPresent": "BothClients",
  "anybodyElsePresent": false,
  "anybodyElsePresentDetails": null,
  "scopeOfAdvice": {
    "retirementPlanning": true,
    "savingsAndInvestments": true,
    "protection": true,
    "mortgage": false,
    "estatePlanning": false
  },
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },
  "isComplete": false,
  "dateFactFindCompleted": null,
  "dateDeclarationSigned": null,
  "dateIdAmlChecked": "2026-02-16",
  "status": {
    "code": "INPROG",
    "display": "In Progress"
  },
  "hasEmployments": true,
  "hasExpenditures": true,
  "hasAssets": true,
  "hasLiabilities": true,
  "hasDcPensionPersonal": true,
  "hasDcPensionMoneyPurchase": true,
  "hasDbPension": false,
  "hasSavings": true,
  "hasInvestments": true,
  "hasProtection": true,
  "hasExistingMortgage": true,
  "hasAnnuity": false,
  "hasEquityRelease": false,
  "hasAdverseCredit": false,
  "hasBeenRefusedCredit": false,
  "incomeChangesExpected": false,
  "expenditureChangesExpected": false,
  "totalEarnedAnnualIncomeGross": {
    "amount": 120000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalNetMonthlyIncome": {
    "amount": 7500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalMonthlyExpenditure": {
    "amount": 4500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalMonthlyDisposableIncome": {
    "amount": 3000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "emergencyFund": {
    "requiredAmount": {
      "amount": 11400.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "committedAmount": {
      "amount": 15000.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    },
    "shortfall": {
      "amount": 0.00,
      "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
    }
  },
  "totalFundsAvailable": {
    "amount": 85000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalLumpSumAvailableForAdvice": {
    "amount": 70000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "agreedMonthlyBudget": {
    "amount": 1000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "agreedSingleInvestmentAmount": {
    "amount": 50000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "highestTaxRate": "HigherRate",
  "totalNetRelevantEarnings": {
    "amount": 110000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "sourceOfInvestmentFunds": "Savings from employment income over past 5 years",
  "notes": "Clients seeking to consolidate pensions and review protection cover",
  "additionalNotes": null,
  "customQuestions": [
    {
      "question": "What are your main financial concerns?",
      "answer": "Ensuring sufficient retirement income and protecting family"
    }
  ],
  "createdAt": "2026-02-16T14:30:00Z",
  "updatedAt": "2026-02-16T15:45:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456" },
    "complete": { "href": "/api/v1/factfinds/factfind-456/complete", "method": "POST" },
    "summary": { "href": "/api/v1/factfinds/factfind-456/summary" },
    "employment": { "href": "/api/v1/factfinds/factfind-456/employment" },
    "income": { "href": "/api/v1/factfinds/factfind-456/income" },
    "expenditure": { "href": "/api/v1/factfinds/factfind-456/expenditure" },
    "affordability": { "href": "/api/v1/factfinds/factfind-456/affordability" }
  }
}
```

**Field Behaviors:**

| Field | Type | Create | Update | Response | Notes |
|-------|------|--------|--------|----------|-------|
| `id` | uuid | ignored | ignored | included | read-only, server-generated |
| `factFindNumber` | string | optional | ignored | included | write-once, business identifier |
| `clientRef` | ClientRef | required | ignored | included | write-once, reference to Client |
| `jointClientRef` | ClientRef | optional | ignored | included | write-once, reference to Client |
| `dateOfMeeting` | date | required | updatable | included | - |
| `typeOfMeeting` | enum | required | updatable | included | - |
| `clientsPresent` | enum | optional | updatable | included | - |
| `anybodyElsePresent` | boolean | optional | updatable | included | - |
| `anybodyElsePresentDetails` | string | optional | updatable | included | - |
| `scopeOfAdvice` | object | optional | updatable | included | Value type: embedded scope flags |
| `adviserRef` | AdviserRef | required | updatable | included | Reference type: Primary adviser |
| `isComplete` | boolean | ignored | ignored | included | read-only, computed from completion status |
| `dateFactFindCompleted` | date | optional | updatable | included | - |
| `dateDeclarationSigned` | date | optional | updatable | included | - |
| `dateIdAmlChecked` | date | optional | updatable | included | - |
| `status` | enum | optional | updatable | included | - |
| `hasEmployments` | boolean | ignored | ignored | included | read-only, computed from child entities |
| `hasExpenditures` | boolean | ignored | ignored | included | read-only, computed |
| `hasAssets` | boolean | ignored | ignored | included | read-only, computed |
| `hasLiabilities` | boolean | ignored | ignored | included | read-only, computed |
| `hasDcPensionPersonal` | boolean | ignored | ignored | included | read-only, computed |
| `hasDcPensionMoneyPurchase` | boolean | ignored | ignored | included | read-only, computed |
| `hasDbPension` | boolean | ignored | ignored | included | read-only, computed |
| `hasSavings` | boolean | ignored | ignored | included | read-only, computed |
| `hasInvestments` | boolean | ignored | ignored | included | read-only, computed |
| `hasProtection` | boolean | ignored | ignored | included | read-only, computed |
| `hasExistingMortgage` | boolean | ignored | ignored | included | read-only, computed |
| `hasAnnuity` | boolean | ignored | ignored | included | read-only, computed |
| `hasEquityRelease` | boolean | ignored | ignored | included | read-only, computed |
| `hasAdverseCredit` | boolean | optional | updatable | included | - |
| `hasBeenRefusedCredit` | boolean | optional | updatable | included | - |
| `incomeChangesExpected` | boolean | optional | updatable | included | - |
| `expenditureChangesExpected` | boolean | optional | updatable | included | - |
| `totalEarnedAnnualIncomeGross` | MoneyValue | ignored | ignored | included | read-only, computed from Income entities |
| `totalNetMonthlyIncome` | MoneyValue | ignored | ignored | included | read-only, computed |
| `totalMonthlyExpenditure` | MoneyValue | ignored | ignored | included | read-only, computed from Expenditure entities |
| `totalMonthlyDisposableIncome` | MoneyValue | ignored | ignored | included | read-only, computed |
| `emergencyFund` | object | optional | updatable | included | Value type: requiredAmount, committedAmount, shortfall (all MoneyValue) |
| `totalFundsAvailable` | MoneyValue | ignored | ignored | included | read-only, computed |
| `totalLumpSumAvailableForAdvice` | MoneyValue | optional | updatable | included | Value type |
| `agreedMonthlyBudget` | MoneyValue | optional | updatable | included | Value type |
| `agreedSingleInvestmentAmount` | MoneyValue | optional | updatable | included | Value type |
| `highestTaxRate` | enum | ignored | ignored | included | read-only, computed |
| `totalNetRelevantEarnings` | MoneyValue | ignored | ignored | included | read-only, computed |
| `sourceOfInvestmentFunds` | string | optional | updatable | included | - |
| `notes` | string | optional | updatable | included | - |
| `additionalNotes` | string | optional | updatable | included | - |
| `customQuestions` | array | optional | updatable | included | - |
| `createdAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `updatedAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `_links` | object | ignored | ignored | included | read-only, HATEOAS links |

**Usage Examples:**

**Creating a FactFind (POST /api/v1/factfinds):**
```json
{
  "clientRef": { "id": "client-123" },
  "jointClientRef": { "id": "client-124" },
  "dateOfMeeting": "2026-02-16",
  "typeOfMeeting": "InitialConsultation",
  "adviserRef": { "id": "adviser-789" },
  "scopeOfAdvice": {
    "retirementPlanning": true,
    "protection": true
  },
  "agreedMonthlyBudget": {
    "amount": 1000.00,
    "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
  }
}
```

**Updating a FactFind (PATCH /api/v1/factfinds/456):**
```json
{
  "status": {
    "code": "COM",
    "display": "Complete"
  },
  "dateFactFindCompleted": "2026-02-16",
  "agreedMonthlyBudget": {
    "amount": 1500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  }
}
```

---

### 13.3 Address Contract

The `Address` contract represents a client's address with additional metadata for residency tracking. When an address needs independent lifecycle management (e.g., address history), it becomes a reference type with identity.

**Reference Type:** Address is a reference type with identity when managed as a separate resource (has `id` field).

**Note:** For simple embedded addresses (like `primaryAddress` in Client), use `AddressValue` (see Section 13.10.2) which has no `id` and is embedded directly.

```json
{
  "id": "address-789",
  "factFindRef": {
    "id": "factfind-456",
    "href": "/api/v1/factfinds/factfind-456",
    "factFindNumber": "FF-2025-00123",
    "status": {
      "code": "INP",
      "display": "In Progress"
    }
  },
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
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
  "isCorrespondenceAddress": true,
  "residencyPeriod": {
    "startDate": "2020-01-15",
    "endDate": null
  },
  "residencyStatus": "Owner",
  "isOnElectoralRoll": true,
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z"
}
```

**Key Field Behaviors:**
- `id` - read-only, server-generated (uuid)
- `factFindRef` - required-on-create, write-once, reference to FactFind (owning aggregate)
- `clientRef` - write-once, reference to Client
- `addressType` - required-on-create, updatable
- `address` - required-on-create, updatable (AddressValue embedded)
- `isCorrespondenceAddress` - optional, updatable (boolean)
- `residencyPeriod` - optional, updatable (DateRangeValue)
- `residencyStatus` - optional, updatable
- `isOnElectoralRoll` - optional, updatable
- `createdAt`, `updatedAt` - read-only

---

### 13.4 Income Contract

The `Income` contract represents an income source within a FactFind.

**Reference Type:** Income is a reference type with identity (has `id` field).

```json
{
  "id": "income-101",
  "factFindRef": {
    "id": "factfind-456",
    "href": "/api/v1/factfinds/factfind-456",
    "factFindNumber": "FF001234",
    "status": "InProgress"
  },
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "employmentRef": {
    "id": "employment-222",
    "href": "/api/v1/employments/employment-222",
    "employerName": "Tech Corp Ltd",
    "status": "Current"
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
  "frequency": {
    "code": "A",
    "display": "Annually",
    "periodsPerYear": 1
  },
  "incomePeriod": {
    "startDate": "2020-01-15",
    "endDate": null
  },
  "isOngoing": true,
  "isPrimary": true,
  "isGuaranteed": true,
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
  "notes": "Annual bonus typically £10k",
  "createdAt": "2026-02-16T14:30:00Z",
  "updatedAt": "2026-02-16T15:45:00Z"
}
```

**Key Field Behaviors:**
- `id` - read-only, server-generated (uuid)
- `factFindRef` - write-once, reference to FactFind (set from URL path parameter)
- `clientRef` - required-on-create, write-once, reference to Client
- `employmentRef` - optional, updatable, reference to Employment
- `incomeType` - required-on-create, updatable
- `description` - optional, updatable
- `grossAmount` - required-on-create, updatable (MoneyValue)
- `netAmount` - optional, updatable (MoneyValue)
- `frequency` - required-on-create, updatable
- `incomePeriod` - optional, updatable (DateRangeValue)
- `isOngoing`, `isPrimary`, `isGuaranteed` - optional, updatable
- `taxDeducted`, `nationalInsuranceDeducted` - optional, updatable (MoneyValue)
- `createdAt`, `updatedAt` - read-only

---

### 13.5 Arrangement Contract

The `Arrangement` contract represents financial products (pensions, investments, protection, mortgages). This is a polymorphic contract with type-specific fields.

**Reference Type:** Arrangement is a reference type with identity (has `id` field).

```json
{
  "id": "arrangement-555",
  "factFindRef": {
    "id": "factfind-456",
    "href": "/api/v1/factfinds/factfind-456",
    "factFindNumber": "FF-2025-00123",
    "status": {
      "code": "INP",
      "display": "In Progress"
    }
  },
  "arrangementNumber": "ARR123456",
  "arrangementType": "Pension",
  "pensionType": "PersonalPension",
  "clientOwners": [
    {
      "id": "client-123",
      "href": "/api/v1/clients/client-123",
      "name": "John Smith",
      "clientNumber": "C00001234",
      "type": "Person"
    }
  ],
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },
  "productName": "ABC SIPP",
  "providerRef": {
    "id": "provider-456",
    "href": "/api/v1/providers/provider-456",
    "name": "ABC Pension Provider Ltd",
    "frnNumber": "123456"
  },
  "policyNumber": "POL123456",
  "status": {
    "code": "ACT",
    "display": "Active"
  },
  "arrangementPeriod": {
    "startDate": "2015-01-01",
    "endDate": null
  },
  "currentValue": {
    "amount": 125000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "valuationDate": "2026-02-01",
  "regularContribution": {
    "amount": 500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "contributionFrequency": {
    "code": "M",
    "display": "Monthly",
    "periodsPerYear": 12
  },
  "isInDrawdown": false,
  "expectedRetirementAge": 67,
  "projectedValueAtRetirement": {
    "amount": 450000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "hasGuaranteedAnnuityRate": false,
  "hasProtectedTaxFreeAmount": false,
  "isSalarySacrifice": false,
  "notes": "Consolidated from previous workplace pensions",
  "createdAt": "2015-01-01T10:00:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "_links": {
    "self": { "href": "/api/v1/arrangements/arrangement-555" },
    "contributions": { "href": "/api/v1/arrangements/arrangement-555/contributions" },
    "valuations": { "href": "/api/v1/arrangements/arrangement-555/valuations" }
  }
}
```

**Key Field Behaviors:**
- `id` - read-only, server-generated
- `factFindRef` - required-on-create, write-once, reference to FactFind (owning aggregate)
- `arrangementType` - required-on-create, write-once (discriminator)
- `pensionType`, `investmentType`, `protectionType`, `mortgageType` - required-on-create (type-specific), write-once
- `clientId` - required-on-create, write-once
- `productName`, `providerName`, `policyNumber` - required-on-create, updatable
- `status` - optional, updatable
- `startDate`, `endDate` - optional, updatable
- `currentValue` - optional, updatable
- `valuationDate` - optional, updatable (should match currentValue update)
- Type-specific fields - vary by arrangementType
- `createdAt`, `updatedAt` - read-only

---

### 13.6 Goal Contract

The `Goal` contract represents a client's financial goal.

**Reference Type:** Goal is a reference type with identity (has `id` field).

```json
{
  "id": "goal-888",
  "factFindRef": {
    "id": "factfind-456",
    "href": "/api/v1/factfinds/factfind-456",
    "factFindNumber": "FF-2025-00123",
    "status": {
      "code": "INP",
      "display": "In Progress"
    }
  },
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "goalType": "Retirement",
  "goalName": "Comfortable retirement at age 65",
  "description": "Build sufficient pension pot to support £40k annual income in retirement",
  "priority": "High",
  "targetAmount": {
    "amount": 500000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "targetDate": "2045-05-15",
  "yearsToGoal": 19,
  "currentSavings": {
    "amount": 125000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "monthlyContribution": {
    "amount": 500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "projectedShortfall": {
    "amount": 150000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "isAchievable": false,
  "status": "InProgress",
  "notes": "May need to increase contributions or adjust target",
  "createdAt": "2026-02-16T14:30:00Z",
  "updatedAt": "2026-02-16T15:45:00Z"
}
```

**Key Field Behaviors:**
- `id` - read-only, server-generated (uuid)
- `factFindRef` - required-on-create, write-once, reference to FactFind (owning aggregate)
- `clientRef` - write-once, reference to Client
- `goalType` - required-on-create, updatable
- `goalName` - required-on-create, updatable
- `description` - optional, updatable
- `priority` - optional, updatable
- `targetAmount` - required-on-create, updatable (MoneyValue)
- `targetDate` - required-on-create, updatable
- `yearsToGoal` - read-only, computed from targetDate
- `currentSavings`, `monthlyContribution` - optional, updatable (MoneyValue)
- `projectedShortfall` - read-only, computed (MoneyValue)
- `isAchievable` - read-only, computed
- `status` - optional, updatable
- `createdAt`, `updatedAt` - read-only

---

### 13.7 RiskProfile Contract

The `RiskProfile` contract represents a client's risk assessment and attitude to risk.

**Reference Type:** RiskProfile is a reference type with identity (has `id` field).

```json
{
  "id": "riskprofile-999",
  "factFindRef": {
    "id": "factfind-456",
    "href": "/api/v1/factfinds/factfind-456",
    "factFindNumber": "FF-2025-00123",
    "status": {
      "code": "INP",
      "display": "In Progress"
    }
  },
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },
  "assessmentDate": "2026-02-16",
  "assessmentType": "ATR",
  "attitudeToRiskScore": 6,
  "attitudeToRiskRating": "Balanced",
  "capacityForLossScore": 7,
  "capacityForLossRating": "Medium",
  "overallRiskRating": "Balanced",
  "timeHorizon": "LongTerm",
  "yearsToRetirement": 19,
  "investmentExperience": "Moderate",
  "hasInvestedBefore": true,
  "understandsRisk": true,
  "comfortableWithVolatility": true,
  "wouldAcceptLosses": false,
  "notes": "Client understands market volatility but nervous about large losses",
  "questionsAndAnswers": [
    {
      "question": "How would you react to a 20% fall in your portfolio?",
      "answer": "Hold steady and wait for recovery",
      "score": 6
    }
  ],
  "validUntil": "2027-02-16",
  "reviewDate": "2027-02-16",
  "isValid": true,
  "createdAt": "2026-02-16T14:30:00Z",
  "updatedAt": "2026-02-16T15:45:00Z"
}
```

**Key Field Behaviors:**
- `id` - read-only, server-generated
- `factFindRef` - required-on-create, write-once, reference to FactFind (owning aggregate)
- `clientId` - write-once, set from URL or required-on-create
- `assessmentDate` - required-on-create, updatable
- `assessmentType` - required-on-create, write-once
- `attitudeToRiskScore`, `capacityForLossScore` - required-on-create, updatable
- `attitudeToRiskRating`, `capacityForLossRating`, `overallRiskRating` - read-only, computed from scores
- `timeHorizon`, `yearsToRetirement` - optional, updatable
- `investmentExperience` - optional, updatable
- Boolean fields (`hasInvestedBefore`, `understandsRisk`, etc.) - optional, updatable
- `questionsAndAnswers` - optional, updatable (array)
- `validUntil`, `reviewDate` - optional, updatable
- `isValid` - read-only, computed from validUntil date
- `createdAt`, `updatedAt` - read-only

---

### 13.8 Collection Response Wrapper

All list/collection endpoints use a standard wrapper contract:

```json
{
  "data": [
    { /* Complete entity contract */ },
    { /* Complete entity contract */ }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalPages": 5,
    "totalCount": 95,
    "hasMore": true
  },
  "_links": {
    "first": { "href": "/api/v1/clients?page=1&pageSize=20" },
    "prev": null,
    "self": { "href": "/api/v1/clients?page=1&pageSize=20" },
    "next": { "href": "/api/v1/clients?page=2&pageSize=20" },
    "last": { "href": "/api/v1/clients?page=5&pageSize=20" }
  }
}
```

The `data` array contains complete entity contracts. Clients can use field selection (`?fields=id,name`) to reduce response size.

---

### 13.9 Contract Extension for Other Entities

All other entities in the FactFind system follow the same Single Contract Principle:

**Circumstances Entities:**
- `Employment` - Employment history within FactFind
- `Expenditure` - Expenditure items within FactFind
- `Asset` - Assets (property, savings, investments)
- `Liability` - Liabilities (mortgages, loans, credit cards)

**Estate Planning Entities:**
- `Gift` - Gifts made or intended
- `GiftTrust` - Trust arrangements for gifts
- `Beneficiary` - Beneficiaries of estates/trusts

**Relationship Entities:**
- `Relationship` - Client relationships (spouse, partner, ex-partner)
- `Dependant` - Dependent family members
- `ProfessionalContact` - Solicitors, accountants, other advisers

**Reference Data Entities:**
- `Provider` - Financial product providers
- `ProductCategory` - Product categorization
- `EnumValue` - Dynamic enumeration values

Each entity contract follows the same field annotation pattern:
- Fields marked as `required-on-create`, `optional`, `read-only`, `write-once`, or `updatable`
- Same contract used for POST, PUT, PATCH, and GET
- Collection responses wrapped in standard pagination envelope
- Field selection supported via `?fields` query parameter

### 13.10 Standard Value Types

Value types are embedded data structures with no independent identity. They are named with a "Value" suffix and never have an `id` field. Value types are always embedded within their parent entity and have no separate API endpoints.

#### 13.10.1 MoneyValue

Represents a monetary amount with currency.

**Contract:**
```json
{
  "amount": 75000.00,
  "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
}
```

**Fields:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `amount` | decimal | Yes | - | Monetary amount (positive or negative) |
| `currency` | CurrencyValue | Yes | - | Currency details (code, display, symbol) |

**Validation Rules:**
- `amount`: Precision 19, scale 4 (e.g., 9999999999999999.9999)
- `currency.code`: Must be valid ISO 4217 code (GBP, USD, EUR, etc.)

**Usage Example:**
```json
{
  "grossAnnualIncome": {
    "amount": 75000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "netMonthlyIncome": {
    "amount": 4500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  }
}
```

#### 13.10.2 AddressValue

Represents a physical address.

**Contract:**
```json
{
  "line1": "123 Main Street",
  "line2": "Flat 4B",
  "line3": null,
  "line4": null,
  "city": "London",
  "county": {
    "code": "GLA",
    "display": "Greater London"
  },
  "postcode": "SW1A 1AA",
  "country": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "addressType": {
    "code": "RES",
    "display": "Residential"
  }
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `line1` | string | Yes | Address line 1 (max 100 chars) |
| `line2` | string | No | Address line 2 (max 100 chars) |
| `line3` | string | No | Address line 3 (max 100 chars) |
| `line4` | string | No | Address line 4 (max 100 chars) |
| `city` | string | Yes | City/town (max 50 chars) |
| `county` | CountyValue | No | County/state with code and display name |
| `postcode` | string | Yes | Postal/ZIP code (max 20 chars) |
| `country` | CountryValue | Yes | Country with ISO codes and display name |
| `addressType` | AddressTypeValue | No | Type of address (Residential, Correspondence, etc.) |

**Validation Rules:**
- `country.code`: Must be valid ISO 3166-1 alpha-2 code (GB, US, FR, etc.)
- `postcode`: Format validation based on country

**Usage Example:**
```json
{
  "primaryAddress": {
    "line1": "10 Downing Street",
    "city": "London",
    "county": {
      "code": "GLA",
      "display": "Greater London"
    },
    "postcode": "SW1A 2AA",
    "country": {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    },
    "addressType": {
      "code": "RES",
      "display": "Residential"
    }
  }
}
```

#### 13.10.3 DateRangeValue

Represents a date range with start and optional end date.

**Contract:**
```json
{
  "startDate": "2020-01-01",
  "endDate": "2025-12-31"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `startDate` | date | Yes | Start date (ISO 8601: YYYY-MM-DD) |
| `endDate` | date | No | End date (ISO 8601: YYYY-MM-DD), null = ongoing |

**Validation Rules:**
- `endDate` must be after `startDate` if provided
- Both dates must be valid calendar dates

**Usage Example:**
```json
{
  "employmentPeriod": {
    "startDate": "2015-06-01",
    "endDate": null
  }
}
```

#### 13.10.4 NameValue

Represents a person's name.

**Contract:**
```json
{
  "title": {
    "code": "MR",
    "display": "Mr"
  },
  "firstName": "John",
  "middleName": "Michael",
  "lastName": "Smith",
  "preferredName": "Johnny"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | TitleValue | No | Title/honorific with code and display |
| `firstName` | string | Yes | First name (max 50 chars) |
| `middleName` | string | No | Middle name(s) (max 50 chars) |
| `lastName` | string | Yes | Last name/surname (max 50 chars) |
| `preferredName` | string | No | Preferred name/nickname (max 50 chars) |

**Usage Example:**
```json
{
  "name": {
    "title": {
      "code": "DR",
      "display": "Dr"
    },
    "firstName": "Jane",
    "lastName": "Doe",
    "preferredName": "Janey"
  }
}
```

#### 13.10.5 ContactValue

Represents contact information (email, phone).

**Contract:**
```json
{
  "type": {
    "code": "EMAIL",
    "display": "Email"
  },
  "value": "john.smith@example.com",
  "isPrimary": true
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `type` | ContactTypeValue | Yes | Contact type with code and display (EMAIL, MOBILE, HOME, WORK, FAX) |
| `value` | string | Yes | Contact value (email address or phone number) |
| `isPrimary` | boolean | No | Whether this is the primary contact method |

**Validation Rules:**
- `value`: Format validation based on `type.code` (email format, phone number format)

**Usage Example:**
```json
{
  "contacts": [
    {
      "type": {
        "code": "EMAIL",
        "display": "Email"
      },
      "value": "john@example.com",
      "isPrimary": true
    },
    {
      "type": {
        "code": "MOBILE",
        "display": "Mobile"
      },
      "value": "+44 7700 900123",
      "isPrimary": false
    }
  ]
}
```

#### 13.10.6 PercentageValue

Represents a percentage as a decimal value.

**Contract:**
```json
{
  "value": 0.25
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `value` | decimal | Yes | Percentage value (0.00 = 0%, 1.00 = 100%) |

**Validation Rules:**
- `value`: Must be between 0.00 and 1.00 (or other specified range)

**Usage Example:**
```json
{
  "contributionRate": {
    "value": 0.08
  },
  "taxRate": {
    "value": 0.20
  }
}
```

#### 13.10.7 RateValue

Represents an interest rate or other rate.

**Contract:**
```json
{
  "rate": 3.5,
  "type": "Fixed"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `rate` | decimal | Yes | Rate value (e.g., 3.5 for 3.5%) |
| `type` | enum | No | Rate type: Fixed, Variable, Tracker, Discount, Capped |

**Usage Example:**
```json
{
  "interestRate": {
    "rate": 2.75,
    "type": "Fixed"
  },
  "projectedGrowthRate": {
    "rate": 5.0,
    "type": "Variable"
  }
}
```

#### 13.10.8 TaxDetailsValue

Represents tax identification details.

**Contract:**
```json
{
  "niNumber": "AB123456C",
  "taxReference": "1234567890"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `niNumber` | string | No | UK National Insurance Number (9 chars) |
| `taxReference` | string | No | Tax reference number (10 chars) |

**Validation Rules:**
- `niNumber`: Format AA123456A (2 letters, 6 digits, 1 letter)
- `taxReference`: 10-digit UTR format

**Usage Example:**
```json
{
  "taxDetails": {
    "niNumber": "AB123456C",
    "taxReference": "1234567890"
  }
}
```

#### 13.10.9 Enumeration Value Types

Enumeration value types represent categorical data using a structured code/display pattern. Unlike simple string enumerations, enumeration value types are self-documenting, internationalization-ready, and can carry rich metadata.

**Standard Pattern:**
All enumeration value types follow a consistent structure:
```json
{
  "code": "MACHINE_READABLE_CODE",    // Required: Uppercase, short identifier
  "display": "Human Readable Label",  // Required: User-facing label
  // ... additional metadata as needed
}
```

**Benefits:**
- Self-documenting: No need to look up code meanings
- Internationalization-ready: Display text can be localized
- Rich metadata: Dates, categories, and other context
- Forward-compatible: Can add fields without breaking changes
- Type-safe: Strongly typed in contract definitions

---

##### GenderValue

Represents a person's gender.

**Contract:**
```json
{
  "code": "M",
  "display": "Male"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Gender code: M, F, O, U, N |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `M` - Male
- `F` - Female
- `O` - Other
- `U` - Unknown
- `N` - Prefer not to say

**Usage Example:**
```json
{
  "gender": {
    "code": "M",
    "display": "Male"
  }
}
```

---

##### MaritalStatusValue

Represents a person's marital status with optional effective date.

**Contract:**
```json
{
  "code": "MAR",
  "display": "Married",
  "effectiveFrom": "2015-06-20"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Marital status code |
| `display` | string | Yes | Human-readable label |
| `effectiveFrom` | date | No | Date this status became effective (ISO 8601) |

**Standard Codes:**
- `SIN` - Single
- `MAR` - Married
- `CIV` - Civil Partnership
- `DIV` - Divorced
- `WID` - Widowed
- `SEP` - Separated
- `COH` - Cohabiting

**Usage Example:**
```json
{
  "maritalStatus": {
    "code": "MAR",
    "display": "Married",
    "effectiveFrom": "2015-06-20"
  }
}
```

---

##### EmploymentStatusValue

Represents a person's employment status.

**Contract:**
```json
{
  "code": "EMP",
  "display": "Employed"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Employment status code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `EMP` - Employed
- `SELF` - Self-Employed
- `DIR` - Company Director
- `RET` - Retired
- `UNE` - Unemployed
- `NW` - Not Working
- `STU` - Student
- `HOME` - Homemaker

**Usage Example:**
```json
{
  "employmentStatus": {
    "code": "EMP",
    "display": "Employed"
  }
}
```

---

##### AddressTypeValue

Represents the type of an address.

**Contract:**
```json
{
  "code": "RES",
  "display": "Residential"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Address type code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `RES` - Residential
- `CORR` - Correspondence
- `PREV` - Previous
- `WORK` - Work
- `OTHER` - Other

**Usage Example:**
```json
{
  "addressType": {
    "code": "RES",
    "display": "Residential"
  }
}
```

---

##### ContactTypeValue

Represents the type of contact information.

**Contract:**
```json
{
  "code": "EMAIL",
  "display": "Email"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Contact type code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `EMAIL` - Email
- `MOBILE` - Mobile Phone
- `HOME` - Home Phone
- `WORK` - Work Phone
- `FAX` - Fax

**Usage Example:**
```json
{
  "type": {
    "code": "EMAIL",
    "display": "Email"
  }
}
```

---

##### TitleValue

Represents a person's title or honorific.

**Contract:**
```json
{
  "code": "MR",
  "display": "Mr"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Title code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `MR` - Mr
- `MRS` - Mrs
- `MS` - Ms
- `MISS` - Miss
- `DR` - Dr
- `PROF` - Professor
- `REV` - Reverend
- `SIR` - Sir
- `LADY` - Lady
- `LORD` - Lord

**Usage Example:**
```json
{
  "title": {
    "code": "MR",
    "display": "Mr"
  }
}
```

---

##### ProductTypeValue

Represents a financial product type with optional category.

**Contract:**
```json
{
  "code": "SIPP",
  "display": "Self-Invested Personal Pension",
  "category": "Pension"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Product type code |
| `display` | string | Yes | Human-readable label |
| `category` | string | No | Product category grouping |

**Standard Codes:**
- Pensions: `PP` (Personal Pension), `SIPP` (SIPP), `GPP` (Group Personal Pension), `SSAS` (SSAS), `DB` (Defined Benefit), `SP` (State Pension)
- Investments: `ISA` (ISA), `GIA` (General Investment Account), `JISA` (Junior ISA), `LISA` (Lifetime ISA), `OIC` (Offshore Investment)
- Protection: `LIFE` (Life Insurance), `CIC` (Critical Illness), `IP` (Income Protection), `PMI` (Private Medical Insurance)
- Mortgages: `RESMTG` (Residential Mortgage), `BTL` (Buy-to-Let), `EQUITY` (Equity Release)
- Other: `BOND` (Investment Bond), `TRUST` (Trust), `SAVINGS` (Savings Account)

**Usage Example:**
```json
{
  "productType": {
    "code": "SIPP",
    "display": "Self-Invested Personal Pension",
    "category": "Pension"
  }
}
```

---

##### CountryValue

Represents a country using ISO 3166-1 standard codes.

**Contract:**
```json
{
  "code": "GB",
  "display": "United Kingdom",
  "alpha3": "GBR"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | ISO 3166-1 alpha-2 country code (2 chars) |
| `display` | string | Yes | Full country name |
| `alpha3` | string | No | ISO 3166-1 alpha-3 country code (3 chars) |

**Usage Example:**
```json
{
  "country": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  }
}
```

---

##### CountyValue

Represents a county or administrative region.

**Contract:**
```json
{
  "code": "GLA",
  "display": "Greater London",
  "country": {
    "code": "GB",
    "display": "United Kingdom"
  }
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | County/region code |
| `display` | string | Yes | Full county/region name |
| `country` | CountryValue | No | Associated country |

**Usage Example:**
```json
{
  "county": {
    "code": "GLA",
    "display": "Greater London",
    "country": {
      "code": "GB",
      "display": "United Kingdom"
    }
  }
}
```

---

##### CurrencyValue

Represents a currency using ISO 4217 standard codes.

**Contract:**
```json
{
  "code": "GBP",
  "display": "British Pound",
  "symbol": "£"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | ISO 4217 currency code (3 chars) |
| `display` | string | Yes | Full currency name |
| `symbol` | string | No | Currency symbol (£, $, €, etc.) |

**Standard Codes:**
- `GBP` - British Pound (£)
- `USD` - US Dollar ($)
- `EUR` - Euro (€)
- `CHF` - Swiss Franc (CHF)
- `JPY` - Japanese Yen (¥)
- `AUD` - Australian Dollar (A$)
- `CAD` - Canadian Dollar (C$)

**Usage Example:**
```json
{
  "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
}
```

---

##### FrequencyValue

Represents payment or contribution frequency.

**Contract:**
```json
{
  "code": "M",
  "display": "Monthly",
  "periodsPerYear": 12
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Frequency code |
| `display` | string | Yes | Human-readable label |
| `periodsPerYear` | integer | No | Number of periods per year (for calculations) |

**Standard Codes:**
- `M` - Monthly (12 periods/year)
- `Q` - Quarterly (4 periods/year)
- `S` - Semi-Annual (2 periods/year)
- `A` - Annual (1 period/year)
- `W` - Weekly (52 periods/year)
- `F` - Fortnightly (26 periods/year)
- `SINGLE` - Single Payment (0 periods/year)

**Usage Example:**
```json
{
  "frequency": {
    "code": "M",
    "display": "Monthly",
    "periodsPerYear": 12
  }
}
```

---

##### StatusValue

Represents a generic status with optional category.

**Contract:**
```json
{
  "code": "ACT",
  "display": "Active",
  "category": "Arrangement"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Status code |
| `display` | string | Yes | Human-readable label |
| `category` | string | No | Status category grouping |

**Standard Codes:**
- `ACT` - Active
- `INA` - Inactive
- `PEN` - Pending
- `COM` - Completed
- `CAN` - Cancelled
- `SUB` - Submitted
- `APP` - Approved
- `REJ` - Rejected
- `DRAFT` - Draft
- `CLOSED` - Closed

**Usage Example:**
```json
{
  "status": {
    "code": "ACT",
    "display": "Active",
    "category": "Arrangement"
  }
}
```

---

##### MeetingTypeValue

Represents the type of a client meeting.

**Contract:**
```json
{
  "code": "INIT",
  "display": "Initial Meeting"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Meeting type code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `INIT` - Initial Meeting
- `REVIEW` - Review Meeting
- `ANNUAL` - Annual Review
- `ADHOC` - Ad-hoc Meeting
- `PHONE` - Phone Call
- `VIDEO` - Video Conference

**Usage Example:**
```json
{
  "meetingType": {
    "code": "INIT",
    "display": "Initial Meeting"
  }
}
```

---

##### ResidencyStatusValue

Represents tax residency status.

**Contract:**
```json
{
  "code": "UK_RES",
  "display": "UK Resident"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Residency status code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `UK_RES` - UK Resident
- `UK_DOM` - UK Domiciled
- `NON_RES` - Non-Resident
- `NON_DOM` - Non-Domiciled
- `EXPAT` - Expatriate

**Usage Example:**
```json
{
  "residencyStatus": {
    "code": "UK_RES",
    "display": "UK Resident"
  }
}
```

---

##### HealthStatusValue

Represents a person's health status for insurance purposes.

**Contract:**
```json
{
  "code": "GOOD",
  "display": "Good Health"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | string | Yes | Health status code |
| `display` | string | Yes | Human-readable label |

**Standard Codes:**
- `GOOD` - Good Health
- `FAIR` - Fair Health
- `POOR` - Poor Health
- `PREEX` - Pre-existing Conditions
- `UNKNOWN` - Unknown

**Usage Example:**
```json
{
  "healthStatus": {
    "code": "GOOD",
    "display": "Good Health"
  }
}
```

---

### 13.11 Standard Reference Types

Reference types represent entities with independent identity. They are referenced from other entities using an expanded reference object containing `id`, `href`, and display fields. Reference fields are named with a "Ref" suffix (e.g., `clientRef`, `adviserRef`).

#### 13.11.1 ClientRef

Reference to a Client entity.

**Minimal Contract (Required for Create/Update):**
```json
{
  "id": "client-123"
}
```

**Full Contract (Server Response):**
```json
{
  "id": "client-123",
  "href": "/api/v1/clients/client-123",
  "name": "John Michael Smith",
  "clientNumber": "C00001234",
  "type": "Person"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique client identifier |
| `href` | string | Yes (response) | URL to client resource |
| `name` | string | Yes (response) | Full client name |
| `clientNumber` | string | No | Business client number |
| `type` | enum | No | Client type: Person, Corporate, Trust |

**Usage Example:**
```json
{
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  }
}
```

#### 13.11.2 AdviserRef

Reference to an Adviser entity.

**Full Contract:**
```json
{
  "id": "adviser-789",
  "href": "/api/v1/advisers/adviser-789",
  "name": "Sarah Johnson",
  "code": "ADV001"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique adviser identifier |
| `href` | string | Yes (response) | URL to adviser resource |
| `name` | string | Yes (response) | Adviser full name |
| `code` | string | No | Adviser business code |

**Usage Example:**
```json
{
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Sarah Johnson",
    "code": "ADV001"
  }
}
```

#### 13.11.3 ProviderRef

Reference to a financial product Provider entity.

**Full Contract:**
```json
{
  "id": "provider-456",
  "href": "/api/v1/providers/provider-456",
  "name": "Aviva Life & Pensions UK Limited",
  "frnNumber": "185896"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique provider identifier |
| `href` | string | Yes (response) | URL to provider resource |
| `name` | string | Yes (response) | Provider name |
| `frnNumber` | string | No | FCA Firm Reference Number |

**Usage Example:**
```json
{
  "providerRef": {
    "id": "provider-456",
    "href": "/api/v1/providers/provider-456",
    "name": "Aviva",
    "frnNumber": "185896"
  }
}
```

#### 13.11.4 ArrangementRef

Reference to an Arrangement entity (pension, investment, protection, mortgage).

**Full Contract:**
```json
{
  "id": "arrangement-111",
  "href": "/api/v1/arrangements/arrangement-111",
  "policyNumber": "POL123456",
  "productType": "Pension",
  "provider": "Aviva"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique arrangement identifier |
| `href` | string | Yes (response) | URL to arrangement resource |
| `policyNumber` | string | No | Policy/plan number |
| `productType` | string | Yes (response) | Product type (Pension, Investment, etc.) |
| `provider` | string | Yes (response) | Provider name |

**Usage Example:**
```json
{
  "arrangementRef": {
    "id": "arrangement-111",
    "href": "/api/v1/arrangements/arrangement-111",
    "policyNumber": "SIPP123456",
    "productType": "Pension",
    "provider": "Aviva"
  }
}
```

#### 13.11.5 EmploymentRef

Reference to an Employment entity.

**Full Contract:**
```json
{
  "id": "employment-222",
  "href": "/api/v1/employments/employment-222",
  "employerName": "Acme Corporation Ltd",
  "status": "Current"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique employment identifier |
| `href` | string | Yes (response) | URL to employment resource |
| `employerName` | string | Yes (response) | Employer name |
| `status` | enum | Yes (response) | Status: Current, Previous, Future |

**Usage Example:**
```json
{
  "employmentRef": {
    "id": "employment-222",
    "href": "/api/v1/employments/employment-222",
    "employerName": "Acme Corp",
    "status": "Current"
  }
}
```

#### 13.11.6 GoalRef

Reference to a Goal entity.

**Full Contract:**
```json
{
  "id": "goal-333",
  "href": "/api/v1/goals/goal-333",
  "goalName": "Retirement at 65",
  "priority": "High"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique goal identifier |
| `href` | string | Yes (response) | URL to goal resource |
| `goalName` | string | Yes (response) | Goal name/description |
| `priority` | enum | No | Priority: High, Medium, Low |

**Usage Example:**
```json
{
  "goalRef": {
    "id": "goal-333",
    "href": "/api/v1/goals/goal-333",
    "goalName": "Retirement Planning",
    "priority": "High"
  }
}
```

#### 13.11.7 FactFindRef

Reference to a FactFind (ADVICE_CASE) entity.

**Full Contract:**
```json
{
  "id": "factfind-444",
  "href": "/api/v1/factfinds/factfind-444",
  "factFindNumber": "FF001234",
  "status": "InProgress"
}
```

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | uuid | Yes | Unique fact find identifier |
| `href` | string | Yes (response) | URL to fact find resource |
| `factFindNumber` | string | No | Business fact find number |
| `status` | enum | Yes (response) | Status: Draft, InProgress, Complete, Submitted |

**Usage Example:**
```json
{
  "factFindRef": {
    "id": "factfind-444",
    "href": "/api/v1/factfinds/factfind-444",
    "factFindNumber": "FF001234",
    "status": "InProgress"
  }
}
```

---

## Appendices

### Appendix A: Complete Entity-to-Endpoint Mapping

**Client Onboarding & KYC Context:**
- CLIENT → `/api/v1/clients`
- ADDRESS → `/api/v1/clients/{id}/addresses`
- CONTACT_DETAIL → `/api/v1/clients/{id}/contacts`
- PROFESSIONAL_CONTACT → `/api/v1/clients/{id}/professional-contacts`
- CLIENT_RELATIONSHIP → `/api/v1/clients/{id}/relationships`
- DPA_CONSENT → `/api/v1/clients/{id}/dpa-consent`
- MARKETING_CONSENT → `/api/v1/clients/{id}/marketing-consent`
- VULNERABLE_CUSTOMER_FLAG → `/api/v1/clients/{id}/vulnerability`
- DEPENDANT → `/api/v1/clients/{id}/dependants`

**Circumstances Context:**
- ADVICE_CASE → `/api/v1/factfinds`
- EMPLOYMENT → `/api/v1/factfinds/{id}/employment`
- INCOME → `/api/v1/factfinds/{id}/income`
- INCOME_CHANGE → `/api/v1/factfinds/{id}/income-changes`
- EXPENDITURE → `/api/v1/factfinds/{id}/expenditure`
- EXPENDITURE_CHANGE → `/api/v1/factfinds/{id}/expenditure-changes`

**Assets & Liabilities Context:**
- ASSET → `/api/v1/assets`
- BUSINESS_ASSET → `/api/v1/assets/{id}` (embedded in ASSET)
- PROPERTY_DETAIL → `/api/v1/assets/{id}` (embedded in ASSET)
- CREDIT_HISTORY → `/api/v1/clients/{id}/credit-history`
- VALUATION → `/api/v1/arrangements/{id}/valuations`

**Arrangements Context:**
- ARRANGEMENT → `/api/v1/arrangements`
- CONTRIBUTION → `/api/v1/arrangements/{id}/contributions`
- WITHDRAWAL → `/api/v1/arrangements/{id}/withdrawals`
- BENEFICIARY → `/api/v1/arrangements/{id}/beneficiaries`
- CLIENT_PENSION → `/api/v1/clients/{id}/pension-summary`

**Goals Context:**
- GOAL → `/api/v1/goals`
- OBJECTIVE → `/api/v1/goals/{id}/objectives`
- NEED → `/api/v1/goals/{id}/needs`

**Risk Profile Context:**
- RISK_PROFILE → `/api/v1/risk-profiles`

**Estate Planning Context:**
- GIFT → `/api/v1/gifts`
- GIFT_TRUST → `/api/v1/gift-trusts`

### Appendix B: HTTP Status Code Reference

**2xx Success:**
- `200 OK` - GET, PUT, PATCH successful with body
- `201 Created` - POST successful, resource created
- `204 No Content` - PUT, PATCH, DELETE successful without body

**4xx Client Errors:**
- `400 Bad Request` - Invalid request syntax or validation error
- `401 Unauthorized` - Authentication required or failed
- `403 Forbidden` - Authenticated but not authorized
- `404 Not Found` - Resource does not exist
- `409 Conflict` - Concurrent modification or business rule violation
- `412 Precondition Failed` - If-Match header missing/invalid
- `422 Unprocessable Entity` - Semantic validation error
- `429 Too Many Requests` - Rate limit exceeded

**5xx Server Errors:**
- `500 Internal Server Error` - Unexpected error
- `503 Service Unavailable` - Service temporarily unavailable

### Appendix C: Data Type Formats

**Date/DateTime (ISO 8601):**
- Date: `yyyy-MM-dd` (e.g., `2026-02-16`)
- DateTime: `yyyy-MM-ddTHH:mm:ssZ` (e.g., `2026-02-16T14:30:00Z`)
- Always UTC for DateTime

**Money:**
```json
{
  "amount": 75000.00,
  "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  }
}
```

**Address:**
```json
{
  "line1": "123 High Street",
  "line2": "Apartment 4B",
  "city": "London",
  "postcode": "SW1A 1AA",
  "county": {
    "code": "GB-LND",
    "name": "London"
  },
  "country": {
    "code": "GB",
    "name": "United Kingdom"
  }
}
```

**Country (ISO 3166-1 alpha-2):**
```json
{
  "code": "GB",
  "name": "United Kingdom"
}
```

**County (ISO 3166-2):**
```json
{
  "code": "GB-LND",
  "name": "London"
}
```

**Percentage:**
- Range: 0.00 to 100.00
- Decimal places: 2
- Example: `4.75`, `50.0`, `100.00`

### Appendix D: Common Enumerations

**Marital Status:**
- Single
- Married
- CivilPartnership
- Divorced
- Widowed
- Separated

**Gender:**
- Male
- Female
- Other
- PreferNotToSay

**Employment Status:**
- Employed
- SelfEmployed
- CompanyDirector
- ContractWorker
- SemiRetired
- MaternityLeave
- LongTermIllness
- Unemployed
- Retired
- Student
- Homemaker
- Other

**Client Type:**
- Person
- Corporate
- Trust

**Service Status:**
- Prospect
- Active
- Inactive
- Archived

**Risk Rating:**
- VeryCautious
- Cautious
- Balanced
- Adventurous
- VeryAdventurous

### Appendix E: Security Considerations

**Authentication:**
- OAuth 2.0 with JWT tokens required for all endpoints
- Token expiry: 1 hour (access), 30 days (refresh)
- Support for token refresh flow

**Authorization:**
- Granular scope-based permissions
- Resource-level access control
- Tenant isolation enforced at data layer

**Data Protection:**
- PII fields obfuscated by default
- Special scope required for sensitive data
- Audit logging for all PII access
- GDPR right to erasure support

**Transport Security:**
- TLS 1.2+ required
- Strong cipher suites only
- Certificate validation enforced

**API Security:**
- Rate limiting per user and tenant
- Input validation and sanitization
- Output encoding to prevent XSS
- SQL injection prevention (parameterized queries)
- CSRF protection for state-changing operations

---

## Document Metadata

**Document Version:** 1.0
**Status:** Design Specification - Implementation Ready
**Date:** 2026-02-16
**Author:** Principal API Designer
**Reviewers:** Architecture Team, Product Owners, Compliance Team
**Next Review:** 2026-03-16

**Change Log:**
- 2026-02-16: Initial comprehensive API design created (v1.0)
- Complete coverage of 39 entities from Greenfield ERD
- 8 bounded contexts with RESTful API specifications
- Full request/response contracts with validation rules
- Industry-standard terminology and compliance alignment

**Related Documents:**
- Greenfield ERD Design - FactFind System (steering/Target-Model/Greenfield-ERD-FactFind.md)
- API Design Guidelines 2.0 (Company Standards)
- FCA Handbook (COBS, PROD, ICOBS)
- MiFID II Directive
- GDPR Compliance Guidelines

**File Path:** `C:\work\FactFind-Entities\steering\API-Docs\FactFind-API-Design.md`

---

**END OF SPECIFICATION**

This comprehensive API design provides production-ready specifications for implementing the complete FactFind system. All endpoints follow RESTful principles, industry standards, and regulatory requirements for wealth management platforms.
