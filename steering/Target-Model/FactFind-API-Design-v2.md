
<!-- FactFind API Design v2.0 - Generated: 2026-02-17T14:59:30.880008 -->
# FactFind System API Design Specification
## Comprehensive RESTful API for Wealth Management Platform

**Document Version:** 2.0
**Date:** 2026-02-17
**Status:** Design Specification v2.0 - Enhanced with Missing Entities
**API Version:** v1
**Base URL:** `https://api.factfind.com`
**Source:** Greenfield ERD Enhanced - Complete Domain Coverage (50+ entities, 2,000+ fields)

---

## Executive Summary

This document presents a comprehensive RESTful API design for the FactFind system, a wealth management platform built on Domain-Driven Design (DDD) principles. The API architecture follows industry best practices and provides complete coverage of all business capabilities required for modern financial advisory services.

### Overview

**Business Domain:** Wealth Management & Financial Advisory
**Total Entities:** 50+ entities across 8 bounded contexts (enhanced with 11+ new entities)
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



### What's New in v2.0

**PRIORITY 1: Risk Assessment Enhancements (Compliance Critical)**
- **Section 10.4:** Risk Questionnaire API - Template management, versioning, regulatory approval
- **Section 10.5:** Risk Assessment History API - Risk Replay mechanism, audit trail, comparison
- **Section 10.6:** Supplementary Questions API - Additional risk and compliance questions
- **Section 10.7:** Enhanced Declaration Capture - Comprehensive consent and signature management

**PRIORITY 2: New Investment Capabilities**
- **Section 9A:** NEW - Savings & Investments API - Dedicated investment operations, performance tracking, rebalancing

**PRIORITY 3: Assets & Liabilities Enhancements**
- **Section 9.4:** Property Management API - Property portfolio, valuations, LTV calculations
- **Section 9.5:** Equities Portfolio API - Direct stock holdings, performance tracking
- **Section 9.6:** Credit History API - Credit scores, payment history, credit reports

**PRIORITY 4: Client Profile Enhancements**
- **Section 5.5:** Identity Verification API - KYC workflow, AML checks, document verification (REMOVED in v2.1 - now embedded)
- **Section 5.6:** Data Protection & Consent API - GDPR compliance, consent management (REMOVED in v2.1 - now embedded)
- **Section 5.7:** Marketing Preferences API - Channel preferences, opt-in/opt-out management (REMOVED in v2.1 - now embedded)

**PRIORITY 5: Financial Position Tracking**
- **Section 4.4:** Current Position Summary API - Net worth, asset allocation, financial health

**New Entity Contracts (Section 13)**
- Investment Contract (13.8)
- Property Contract (13.9)
- Equity Contract (13.10)
- CreditHistory Contract (13.11)

**Coverage Improvements:**
- Risk Assessment domain coverage increased from 38% to 95%
- Savings & Investments now has dedicated API section
- Client Profile domain coverage increased from 64% to 90%
- Assets & Liabilities domain coverage increased from 67% to 95%
- Overall API coverage increased from 77% to 95%

### What's New in v2.1 (This Release)

**MAJOR ARCHITECTURAL CHANGES:**

**1. ATR Embedded in FactFind (Section 10)**
- **BREAKING CHANGE:** ATR is now embedded within the FactFind entity, not a separate resource
- **Template Management Removed:** No more POST/PUT/DELETE on risk questionnaires
- **Templates as Reference Data:** ATR templates are system configuration, queryable via `/api/v1/reference/atr-templates`
- **Simplified API:** Just 4 main endpoints - GET, PUT, choose-profile, history
- **Risk Replay:** Enhanced historical tracking and comparison capabilities
- **Regulatory Benefit:** Single source of truth for ATR assessment lifecycle

**2. Client Contract Enhanced with Value Types (Section 13.1)**
- **Addresses:** Full address history as embedded value types (not separate resources)
- **Contacts:** All contact types (email, phone, mobile, work, website) embedded
- **Identity Verification:** KYC, AML checks, document verification embedded
- **Vulnerabilities:** Client vulnerabilities and required adjustments embedded
- **Data Protection:** GDPR consent, privacy policy, data retention embedded
- **Marketing Preferences:** Channel preferences, interests, frequency embedded
- **Estate Planning:** Will, LPA, gifts, trusts, IHT estimates embedded
- **Section 5 Impact:** Removed separate APIs for identity verification, data protection, marketing preferences

**3. FactFind Contract Enhanced with ATR Assessment (Section 13.2)**
- **Embedded ATR:** Complete ATR assessment within FactFind contract
- **Full Question History:** 15 standard questions + 45 supplementary questions
- **Risk Profiles:** System-generated 3 adjacent profiles + client choice
- **Capacity for Loss:** Adviser assessment included
- **Declarations:** Client and adviser declarations embedded
- **Workflow Integration:** ATR required for FactFind completion

**Benefits of These Changes:**
- **Simpler API:** Fewer endpoints, less complexity
- **Better Cohesion:** Related data stays together
- **Transactional Consistency:** Updates are atomic
- **Reduced Latency:** No N+1 query problems
- **Regulatory Compliance:** Complete audit trail in one place
- **Domain-Driven Design:** True aggregate boundaries

**Breaking Changes:**
- Removed: `POST /api/v1/risk-questionnaires` (template creation)
- Removed: `PUT /api/v1/risk-questionnaires/{id}` (template update)
- Removed: `DELETE /api/v1/risk-questionnaires/{id}` (template deletion)
- Removed: `POST /api/v1/factfinds/{id}/risk-questionnaires/{qid}/responses` (separate responses)
- Removed: Section 5.5 (Identity Verification API)
- Removed: Section 5.6 (Data Protection & Consent API)
- Removed: Section 5.7 (Marketing Preferences API)
- Removed: Section 10.6 (Supplementary Questions API)
- Changed: Section 10.4 (now just reference data, not CRUD)
- Enhanced: GET/PUT `/api/v1/factfinds/{id}` now includes embedded atrAssessment
- Enhanced: GET/PUT `/api/v1/clients/{id}` now includes all value types

---

## Table of Contents

1. [API Design Principles](#1-api-design-principles)
   - [1.7 Single Contract Principle](#17-single-contract-principle)
   - [1.8 Value and Reference Type Semantics](#18-value-and-reference-type-semantics)
   - [1.9 Aggregate Root Pattern](#19-aggregate-root-pattern)
2. [Authentication & Authorization](#2-authentication--authorization)
3. [Common Patterns](#3-common-patterns)
4. [FactFind API (Root Aggregate)](#4-factfind-api-root-aggregate)
   - [4.4 Current Position Summary API](#44-current-position-summary-api) **NEW v2.0**
5. [FactFind Clients API](#5-factfind-clients-api)
6. [FactFind Income & Expenditure API](#6-factfind-income--expenditure-api)
7. [FactFind Arrangements API](#7-factfind-arrangements-api)
8. [FactFind Goals API](#8-factfind-goals-api)
9. [FactFind Assets & Liabilities API](#9-factfind-assets--liabilities-api)
   - [9.4 Property Management API](#94-property-management-api) **NEW v2.0**
   - [9.5 Equities Portfolio API](#95-equities-portfolio-api) **NEW v2.0**
   - [9.6 Credit History API](#96-credit-history-api) **NEW v2.0**
9A. [FactFind Savings & Investments API](#9a-factfind-savings--investments-api) **NEW SECTION v2.0**
   - [9A.1 Overview](#9a1-overview)
   - [9A.2 Operations Summary](#9a2-operations-summary)
   - [9A.3 Key Endpoints](#9a3-key-endpoints)
10. [FactFind Risk Profile API](#10-factfind-risk-profile-api)
   - [10.1 Overview](#101-overview) **UPDATED v2.1**
   - [10.2 Operations Summary](#102-operations-summary) **UPDATED v2.1**
   - [10.3 Key Endpoints](#103-key-endpoints) **UPDATED v2.1**
   - [10.4 ATR Templates Reference Data](#104-atr-templates-reference-data) **SIMPLIFIED v2.1**
   - [10.5 Risk Assessment History API](#105-risk-assessment-history-api) **UPDATED v2.1**
   - [10.6 Integration with FactFind Workflow](#106-integration-with-factfind-workflow) **NEW v2.1**
11. [FactFind Estate Planning API](#11-factfind-estate-planning-api)
12. [Reference Data API](#12-reference-data-api)
13. [Entity Contracts](#13-entity-contracts)
   - [13.1 Client Contract](#131-client-contract) **ENHANCED v2.1**
   - [13.2 FactFind Contract](#132-factfind-contract) **ENHANCED v2.1**
   - [13.3 Address Contract](#133-address-contract)
   - [13.4 Income Contract](#134-income-contract)
   - [13.5 Arrangement Contract](#135-arrangement-contract)
   - [13.6 Goal Contract](#136-goal-contract)
   - [13.7 RiskProfile Contract](#137-riskprofile-contract)
   - [13.8 Investment Contract](#138-investment-contract) **NEW v2.0**
   - [13.9 Property Contract](#139-property-contract) **NEW v2.0**
   - [13.10 Equity Contract](#1310-equity-contract) **NEW v2.0**
   - [13.11 CreditHistory Contract](#1311-credithistory-contract) **NEW v2.0**
   - [13.12 Standard Value Types](#1312-standard-value-types) **ENHANCED v2.1**
   - [13.13 Standard Reference Types](#1313-standard-reference-types)
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
  "financialProfile": {                   // FinancialProfileValue - no id, embedded
    "grossAnnualIncome": {                // MoneyValue - no id, embedded
      "amount": 75000.00,
      "currency": {                       // CurrencyValue (lookup)
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
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
    "financialProfile": {
      "grossAnnualIncome": {
        "amount": 75000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
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
    "financialProfile": {
      "grossAnnualIncome": {
        "amount": 75000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
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
  "financialProfile": {
    "grossAnnualIncome": {
      "amount": 75000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
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
  "financialProfile": {
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
    "totalAssets": {
      "amount": 500000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "calculatedAt": "2026-02-18T10:30:00Z",
    "lastReviewDate": "2026-02-18"
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


### 4.4 Current Position Summary API

**Purpose:** Provide aggregated financial position snapshot including net worth, asset allocation, income vs. expenditure comparison, and financial health scoring.

**Scope:**
- Net worth calculation (assets minus liabilities)
- Asset allocation summary across all holdings
- Income vs. expenditure comparison
- Cash flow analysis
- Financial health score (0-100) with component breakdown
- Portfolio diversification metrics
- Debt-to-income ratios
- Emergency fund adequacy
- Savings rate analysis

**Aggregate Root:** FactFind

**Regulatory Compliance:**
- FCA Consumer Duty (Financial Resilience Assessment)
- Vulnerability Framework (Financial Health Indicators)
- Treating Customers Fairly (TCF) Outcome 1

### 4.4.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/current-position` | Get comprehensive financial position summary | `factfind:read` |
| GET | `/api/v1/factfinds/{factfindId}/current-position/net-worth` | Get detailed net worth breakdown | `factfind:read` |
| GET | `/api/v1/factfinds/{factfindId}/current-position/financial-health` | Get financial health score and analysis | `factfind:read` |
| GET | `/api/v1/factfinds/{factfindId}/current-position/cash-flow` | Get cash flow analysis | `factfind:read` |
| GET | `/api/v1/factfinds/{factfindId}/current-position/asset-allocation` | Get detailed asset allocation | `factfind:read` |

### 4.4.2 Key Endpoints

#### 4.4.2.1 Get Current Position Summary

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/current-position`

**Description:** Get comprehensive financial position summary for a fact find including net worth, asset allocation, cash flow, and financial health score.

**Query Parameters:**
- `asOfDate` - Calculate position as of specific date (ISO 8601 format, default: today)
- `includeProjections` - Include future projections (default: false)

**Response:**

```json
{
  "factfindId": "factfind-456",
  "asOfDate": "2026-02-17",
  "clients": [
    {
      "id": "client-123",
      "name": "John Smith",
      "age": 45,
      "retirementAge": 67
    },
    {
      "id": "client-124",
      "name": "Jane Smith",
      "age": 43,
      "retirementAge": 67
    }
  ],
  "netWorth": {
    "totalAssets": {
      "amount": 850000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "totalLiabilities": {
      "amount": 250000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "netWorth": {
      "amount": 600000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    }
  },
  "assetBreakdown": {
    "property": {
      "amount": 450000.00,
      "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"},
      "percentage": 52.9,
      "count": 2
    },
    "pensions": {
      "amount": 250000.00,
      "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"},
      "percentage": 29.4,
      "count": 3
    },
    "investments": {
      "amount": 100000.00,
      "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"},
      "percentage": 11.8,
      "count": 5
    },
    "cash": {
      "amount": 30000.00,
      "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"},
      "percentage": 3.5,
      "count": 3
    }
  },
  "liabilityBreakdown": {
    "mortgages": {
      "amount": 200000.00,
      "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"},
      "percentage": 80.0,
      "count": 1
    },
    "loans": {
      "amount": 30000.00,
      "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"},
      "percentage": 12.0,
      "count": 2
    },
    "creditCards": {
      "amount": 15000.00,
      "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"},
      "percentage": 6.0,
      "count": 3
    }
  },
  "assetAllocation": {
    "equities": {
      "percentage": 45.0,
      "amount": {"amount": 382500.00, "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}}
    },
    "bonds": {
      "percentage": 25.0,
      "amount": {"amount": 212500.00, "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}}
    },
    "property": {
      "percentage": 20.0,
      "amount": {"amount": 170000.00, "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}}
    },
    "cash": {
      "percentage": 7.0,
      "amount": {"amount": 59500.00, "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}}
    },
    "alternatives": {
      "percentage": 3.0,
      "amount": {"amount": 25500.00, "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}}
    }
  },
  "incomeVsExpenditure": {
    "totalGrossAnnualIncome": {"amount": 120000.00, "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}},
    "totalNetMonthlyIncome": {"amount": 7500.00, "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}},
    "totalNetAnnualIncome": {"amount": 90000.00, "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}},
    "totalMonthlyExpenditure": {"amount": 4500.00, "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}},
    "totalAnnualExpenditure": {"amount": 54000.00, "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}},
    "monthlyDisposableIncome": {"amount": 3000.00, "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}},
    "annualDisposableIncome": {"amount": 36000.00, "currency": {"code": "GBP", "display": "British Pound", "symbol": "£"}},
    "savingsRate": 40.0
  },
  "financialHealthScore": {
    "overallScore": 75,
    "scoreDate": "2026-02-17",
    "rating": "Good",
    "components": {
      "emergencyFund": {
        "score": 18,
        "maxScore": 20,
        "percentage": 90.0,
        "status": "Excellent",
        "monthsCovered": 6.7,
        "targetMonths": 6.0,
        "details": "Emergency fund covers 6.7 months of expenditure (target: 6 months)"
      },
      "debtToIncome": {
        "score": 20,
        "maxScore": 25,
        "percentage": 80.0,
        "status": "Good",
        "ratio": 31.2,
        "targetRatio": 36.0,
        "details": "Debt-to-income ratio of 31.2% is below the 36% threshold"
      },
      "savingsRate": {
        "score": 16,
        "maxScore": 20,
        "percentage": 80.0,
        "status": "Good",
        "rate": 40.0,
        "targetRate": 20.0,
        "details": "Saving 40.0% of net income (target: 20%)"
      },
      "diversification": {
        "score": 14,
        "maxScore": 20,
        "percentage": 70.0,
        "status": "Fair",
        "assetClassCount": 5,
        "concentrationRisk": "Medium",
        "details": "Portfolio spread across 5 asset classes with medium concentration"
      },
      "netWorthGrowth": {
        "score": 7,
        "maxScore": 15,
        "percentage": 46.7,
        "status": "Fair",
        "oneYearGrowth": 4.5,
        "threeYearGrowth": 12.8,
        "details": "Net worth growth of 4.5% over past year"
      }
    },
    "recommendations": [
      "Consider increasing property diversification to reduce concentration risk",
      "Net worth growth is below inflation - review investment strategy",
      "Strong emergency fund position - consider redirecting excess to investments"
    ]
  },
  "_links": {
    "self": {"href": "/api/v1/factfinds/factfind-456/current-position"},
    "factfind": {"href": "/api/v1/factfinds/factfind-456"},
    "net-worth": {"href": "/api/v1/factfinds/factfind-456/current-position/net-worth"},
    "financial-health": {"href": "/api/v1/factfinds/factfind-456/current-position/financial-health"},
    "cash-flow": {"href": "/api/v1/factfinds/factfind-456/current-position/cash-flow"},
    "asset-allocation": {"href": "/api/v1/factfinds/factfind-456/current-position/asset-allocation"}
  }
}
```

**Financial Health Score Calculation:**

The financial health score is calculated on a 0-100 scale with five components:

1. **Emergency Fund (20 points max)**
   - 20 points: 6+ months of expenditure
   - 15 points: 4-6 months
   - 10 points: 2-4 months
   - 5 points: 1-2 months
   - 0 points: < 1 month

2. **Debt-to-Income Ratio (25 points max)**
   - 25 points: < 20%
   - 20 points: 20-30%
   - 15 points: 30-36%
   - 10 points: 36-43%
   - 5 points: 43-50%
   - 0 points: > 50%

3. **Savings Rate (20 points max)**
   - 20 points: > 30% of net income
   - 15 points: 20-30%
   - 10 points: 10-20%
   - 5 points: 5-10%
   - 0 points: < 5%

4. **Diversification (20 points max)**
   - 20 points: Well diversified across 5+ asset classes, no concentration > 40%
   - 15 points: Diversified across 4-5 asset classes, concentration < 50%
   - 10 points: Moderate diversification, concentration < 60%
   - 5 points: Limited diversification, concentration < 75%
   - 0 points: Poor diversification, high concentration > 75%

5. **Net Worth Growth (15 points max)**
   - 15 points: > 10% annual growth
   - 12 points: 7-10% annual growth
   - 9 points: 5-7% annual growth
   - 6 points: 3-5% annual growth
   - 3 points: 0-3% annual growth
   - 0 points: Negative growth

**Rating Bands:**
- 90-100: Excellent
- 75-89: Good
- 60-74: Fair
- 40-59: Needs Improvement
- 0-39: Poor

**Validation Rules:**
- `factfindId` must be a valid fact find identifier
- `asOfDate` must be valid ISO 8601 date format
- Response includes only data available as of the specified date
- All monetary values must be positive
- Percentages must sum to 100 where applicable

**HTTP Status Codes:**
- `200 OK` - Summary retrieved successfully
- `404 Not Found` - Fact find not found
- `403 Forbidden` - Insufficient permissions

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



### 9.4 Property Management API

**Purpose:** Manage property portfolio with comprehensive valuation tracking, mortgage linking, LTV calculations, and rental yield analysis.

**Scope:**
- Property entity management (residential, buy-to-let, commercial, holiday, land)
- Property valuation history tracking with multiple valuation types
- Loan-to-Value (LTV) calculations across all mortgages
- Rental income tracking and yield calculations
- Property expenses and net yield analysis
- Mortgage linking and equity tracking
- Capital gains tax (CGT) calculations
- Private Residence Relief (PRR) and Letting Relief tracking
- Stamp Duty Land Tax (SDLT) tracking
- Property ownership structures (sole, joint, company, trust)

**Aggregate Root:** FactFind (properties are nested within fact find)

**Regulatory Compliance:**
- FCA Handbook - Understanding client assets
- MLR 2017 - Source of wealth verification
- HMRC Capital Gains Tax regulations
- HMRC Stamp Duty Land Tax requirements
- Data Protection Act 2018 - Property data retention

#### 9.4.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/properties` | Add property | `assets:write` |
| GET | `/api/v1/factfinds/{factfindId}/properties` | List properties | `assets:read` |
| GET | `/api/v1/factfinds/{factfindId}/properties/{id}` | Get property details | `assets:read` |
| PUT | `/api/v1/factfinds/{factfindId}/properties/{id}` | Update property | `assets:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/properties/{id}` | Delete property | `assets:write` |
| POST | `/api/v1/factfinds/{factfindId}/properties/{id}/valuations` | Add valuation | `assets:write` |
| GET | `/api/v1/factfinds/{factfindId}/properties/{id}/valuations` | Get valuation history | `assets:read` |
| GET | `/api/v1/factfinds/{factfindId}/properties/{id}/ltv` | Calculate LTV | `assets:read` |
| GET | `/api/v1/factfinds/{factfindId}/properties/{id}/rental-yield` | Calculate rental yield | `assets:read` |
| GET | `/api/v1/factfinds/{factfindId}/properties/{id}/capital-gains` | Calculate capital gains | `assets:read` |
| GET | `/api/v1/factfinds/{factfindId}/properties/{id}/equity` | Calculate equity | `assets:read` |
| POST | `/api/v1/factfinds/{factfindId}/properties/{id}/expenses` | Add property expense | `assets:write` |
| GET | `/api/v1/factfinds/{factfindId}/properties/{id}/expenses` | Get property expenses | `assets:read` |

#### 9.4.2 Key Endpoints

##### 9.4.2.1 Add Property

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/properties`

**Description:** Add a new property to the client's property portfolio. Supports residential, buy-to-let, commercial, holiday homes, and land.

**Request Body:**

```json
{
  "propertyType": "BuyToLet",
  "propertySubtype": "ResidentialFlat",
  "propertyPurpose": "Investment",
  "address": {
    "line1": "Flat 12, Riverside Apartments",
    "line2": "45 Thames Street",
    "line3": null,
    "city": "Manchester",
    "county": "Greater Manchester",
    "postcode": "M1 2AB",
    "country": "United Kingdom",
    "uprn": "100023456789"
  },
  "ownership": {
    "ownershipType": "JointTenants",
    "owners": [
      {
        "clientId": "client-123",
        "ownershipPercentage": 50.0,
        "ownerName": "John Smith",
        "isPrimaryOwner": true
      },
      {
        "clientId": "client-124",
        "ownershipPercentage": 50.0,
        "ownerName": "Jane Smith",
        "isPrimaryOwner": false
      }
    ],
    "ownershipNotes": "Joint tenants with right of survivorship"
  },
  "purchase": {
    "purchaseDate": "2019-06-15",
    "purchasePrice": 285000.00,
    "purchaseCurrency": "GBP",
    "stampDutyPaid": 8500.00,
    "legalFees": 1500.00,
    "surveyFees": 600.00,
    "otherPurchaseCosts": 250.00,
    "totalAcquisitionCost": 295850.00,
    "fundingSource": "MortgageAndSavings",
    "mortgageAmount": 228000.00,
    "depositAmount": 57000.00
  },
  "currentValuation": {
    "value": 345000.00,
    "valuationDate": "2026-01-15",
    "valuationType": "Online",
    "valuationProvider": "Zoopla",
    "valuationReference": "ZPL-2026-12345",
    "valuerName": null,
    "valuerNotes": "Automated valuation based on recent sales in area",
    "confidenceLevel": "Medium"
  },
  "propertyDetails": {
    "bedrooms": 2,
    "bathrooms": 2,
    "receptionRooms": 1,
    "totalRooms": 5,
    "propertySize": {
      "area": 750,
      "unit": "SquareFeet"
    },
    "tenure": "Leasehold",
    "leaseYearsRemaining": 95,
    "yearBuilt": 2015,
    "constructionType": "NewBuild",
    "parking": "OneSpace",
    "garden": false,
    "epcRating": "B",
    "councilTaxBand": "D"
  },
  "linkedMortgages": [
    {
      "arrangementId": "arr-mortgage-789",
      "mortgageProvider": "Nationwide Building Society",
      "outstandingBalance": 198450.00,
      "monthlyPayment": 1245.00,
      "interestRate": 3.89,
      "mortgageType": "BuyToLetInterestOnly",
      "endDate": "2029-06-15"
    }
  ],
  "rentalDetails": {
    "isCurrentlyRented": true,
    "tenancyType": "AssuredShorthold",
    "tenancyStartDate": "2023-08-01",
    "tenancyEndDate": "2024-07-31",
    "monthlyRentalIncome": 1650.00,
    "annualRentalIncome": 19800.00,
    "rentalIncomeFrequency": "Monthly",
    "tenantName": "Mr. David Jones",
    "tenantContactEmail": "david.jones@email.com",
    "managementType": "LettingAgent",
    "lettingAgent": {
      "name": "Manchester Property Lettings Ltd",
      "contactName": "Sarah Williams",
      "phone": "0161 234 5678",
      "email": "sarah@manchesterpropertylet.co.uk",
      "managementFeePercentage": 12.0,
      "monthlyManagementFee": 198.00
    },
    "rentReviewDate": "2024-08-01",
    "depositAmount": 2475.00,
    "depositProtectionScheme": "MyDeposits"
  },
  "expenses": {
    "annualExpenses": [
      {
        "expenseType": "MortgageInterest",
        "amount": 7500.00,
        "frequency": "Annual",
        "notes": "Interest-only mortgage payments"
      },
      {
        "expenseType": "ManagementFees",
        "amount": 2376.00,
        "frequency": "Annual",
        "notes": "Letting agent fees at 12%"
      },
      {
        "expenseType": "ServiceCharge",
        "amount": 1800.00,
        "frequency": "Annual",
        "notes": "Building service charge"
      },
      {
        "expenseType": "GroundRent",
        "amount": 250.00,
        "frequency": "Annual",
        "notes": "Annual ground rent"
      },
      {
        "expenseType": "Insurance",
        "amount": 450.00,
        "frequency": "Annual",
        "notes": "Landlord building and contents insurance"
      },
      {
        "expenseType": "Maintenance",
        "amount": 800.00,
        "frequency": "Annual",
        "notes": "Average annual maintenance and repairs"
      },
      {
        "expenseType": "SafetyCertificates",
        "amount": 350.00,
        "frequency": "Annual",
        "notes": "Gas safety, EPC, EICR certificates"
      }
    ],
    "totalAnnualExpenses": 13526.00
  },
  "taxInformation": {
    "isPrimaryResidence": false,
    "hasEverBeenPrimaryResidence": false,
    "primaryResidencePeriod": null,
    "eligibleForPrivateResidenceRelief": false,
    "eligibleForLettingRelief": false,
    "wearAndTearAllowanceClaimed": false,
    "capitalAllowancesClaimed": false
  },
  "notes": "Buy-to-let property purchased in 2019. Currently let on assured shorthold tenancy. Property has increased in value by approximately 21% since purchase. Good rental yield area.",
  "adviserId": "adv-789"
}
```

**Property Type Values:**
- `Residential` - Owner-occupied residential property
- `BuyToLet` - Investment property for rental income
- `Commercial` - Commercial property (office, retail, industrial)
- `Holiday` - Holiday home or vacation property
- `Land` - Undeveloped land
- `DevelopmentProject` - Property under development

**Property Subtype Values:**
- `DetachedHouse`, `SemiDetachedHouse`, `TerracedHouse`, `Bungalow`
- `ResidentialFlat`, `Maisonette`, `Studio`
- `CommercialOffice`, `Retail`, `Industrial`, `Warehouse`
- `FarmLand`, `BuildingPlot`, `WoodLand`

**Ownership Type Values:**
- `Sole` - Single owner
- `JointTenants` - Joint ownership with right of survivorship
- `TenantsInCommon` - Specified ownership percentages
- `Company` - Owned through limited company
- `Trust` - Held in trust

**Tenure Values:**
- `Freehold` - Full ownership of property and land
- `Leasehold` - Long-term lease (typically 99-999 years)
- `Shared Ownership` - Part-own, part-rent scheme
- `Commonhold` - Freehold flat ownership

**Response:**

```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/ff-456/properties/prop-789
```

```json
{
  "id": "prop-789",
  "factfindId": "ff-456",
  "propertyType": "BuyToLet",
  "propertySubtype": "ResidentialFlat",
  "propertyPurpose": "Investment",
  "address": {
    "line1": "Flat 12, Riverside Apartments",
    "line2": "45 Thames Street",
    "line3": null,
    "city": "Manchester",
    "county": "Greater Manchester",
    "postcode": "M1 2AB",
    "country": "United Kingdom",
    "uprn": "100023456789",
    "formattedAddress": "Flat 12, Riverside Apartments, 45 Thames Street, Manchester, M1 2AB"
  },
  "ownership": {
    "ownershipType": "JointTenants",
    "owners": [
      {
        "clientId": "client-123",
        "ownershipPercentage": 50.0,
        "ownerName": "John Smith",
        "isPrimaryOwner": true
      },
      {
        "clientId": "client-124",
        "ownershipPercentage": 50.0,
        "ownerName": "Jane Smith",
        "isPrimaryOwner": false
      }
    ],
    "ownershipNotes": "Joint tenants with right of survivorship"
  },
  "purchase": {
    "purchaseDate": "2019-06-15",
    "purchasePrice": 285000.00,
    "purchaseCurrency": "GBP",
    "stampDutyPaid": 8500.00,
    "legalFees": 1500.00,
    "surveyFees": 600.00,
    "otherPurchaseCosts": 250.00,
    "totalAcquisitionCost": 295850.00,
    "fundingSource": "MortgageAndSavings",
    "mortgageAmount": 228000.00,
    "depositAmount": 57000.00,
    "depositPercentage": 20.0,
    "yearsOwned": 6.6
  },
  "currentValuation": {
    "value": 345000.00,
    "valuationDate": "2026-01-15",
    "valuationType": "Online",
    "valuationProvider": "Zoopla",
    "valuationReference": "ZPL-2026-12345",
    "valuerName": null,
    "valuerNotes": "Automated valuation based on recent sales in area",
    "confidenceLevel": "Medium",
    "daysOld": 33
  },
  "propertyDetails": {
    "bedrooms": 2,
    "bathrooms": 2,
    "receptionRooms": 1,
    "totalRooms": 5,
    "propertySize": {
      "area": 750,
      "unit": "SquareFeet"
    },
    "tenure": "Leasehold",
    "leaseYearsRemaining": 95,
    "yearBuilt": 2015,
    "propertyAge": 11,
    "constructionType": "NewBuild",
    "parking": "OneSpace",
    "garden": false,
    "epcRating": "B",
    "councilTaxBand": "D"
  },
  "linkedMortgages": [
    {
      "arrangementId": "arr-mortgage-789",
      "mortgageProvider": "Nationwide Building Society",
      "outstandingBalance": 198450.00,
      "monthlyPayment": 1245.00,
      "interestRate": 3.89,
      "mortgageType": "BuyToLetInterestOnly",
      "endDate": "2029-06-15",
      "yearsRemaining": 3.4
    }
  ],
  "totalMortgageBalance": 198450.00,
  "equity": {
    "currentValue": 345000.00,
    "totalMortgages": 198450.00,
    "equityAmount": 146550.00,
    "equityPercentage": 42.5
  },
  "loanToValue": {
    "currentLTV": 57.5,
    "purchaseLTV": 80.0,
    "ltvChange": -22.5
  },
  "capitalGrowth": {
    "purchasePrice": 285000.00,
    "currentValue": 345000.00,
    "absoluteGain": 60000.00,
    "percentageGain": 21.05,
    "annualizedReturn": 3.02
  },
  "rentalDetails": {
    "isCurrentlyRented": true,
    "tenancyType": "AssuredShorthold",
    "tenancyStartDate": "2023-08-01",
    "tenancyEndDate": "2024-07-31",
    "monthlyRentalIncome": 1650.00,
    "annualRentalIncome": 19800.00,
    "rentalIncomeFrequency": "Monthly",
    "tenantName": "Mr. David Jones",
    "tenantContactEmail": "david.jones@email.com",
    "managementType": "LettingAgent",
    "lettingAgent": {
      "name": "Manchester Property Lettings Ltd",
      "contactName": "Sarah Williams",
      "phone": "0161 234 5678",
      "email": "sarah@manchesterpropertylet.co.uk",
      "managementFeePercentage": 12.0,
      "monthlyManagementFee": 198.00,
      "annualManagementFee": 2376.00
    },
    "rentReviewDate": "2024-08-01",
    "depositAmount": 2475.00,
    "depositProtectionScheme": "MyDeposits"
  },
  "expenses": {
    "annualExpenses": [
      {
        "expenseType": "MortgageInterest",
        "amount": 7500.00,
        "frequency": "Annual",
        "notes": "Interest-only mortgage payments"
      },
      {
        "expenseType": "ManagementFees",
        "amount": 2376.00,
        "frequency": "Annual",
        "notes": "Letting agent fees at 12%"
      },
      {
        "expenseType": "ServiceCharge",
        "amount": 1800.00,
        "frequency": "Annual",
        "notes": "Building service charge"
      },
      {
        "expenseType": "GroundRent",
        "amount": 250.00,
        "frequency": "Annual",
        "notes": "Annual ground rent"
      },
      {
        "expenseType": "Insurance",
        "amount": 450.00,
        "frequency": "Annual",
        "notes": "Landlord building and contents insurance"
      },
      {
        "expenseType": "Maintenance",
        "amount": 800.00,
        "frequency": "Annual",
        "notes": "Average annual maintenance and repairs"
      },
      {
        "expenseType": "SafetyCertificates",
        "amount": 350.00,
        "frequency": "Annual",
        "notes": "Gas safety, EPC, EICR certificates"
      }
    ],
    "totalAnnualExpenses": 13526.00
  },
  "rentalYield": {
    "grossAnnualRent": 19800.00,
    "currentPropertyValue": 345000.00,
    "grossYieldPercentage": 5.74,
    "totalAnnualExpenses": 13526.00,
    "netAnnualIncome": 6274.00,
    "netYieldPercentage": 1.82,
    "marketAverageYield": 5.2,
    "yieldVsMarket": 0.54
  },
  "taxInformation": {
    "isPrimaryResidence": false,
    "hasEverBeenPrimaryResidence": false,
    "primaryResidencePeriod": null,
    "eligibleForPrivateResidenceRelief": false,
    "eligibleForLettingRelief": false,
    "wearAndTearAllowanceClaimed": false,
    "capitalAllowancesClaimed": false
  },
  "performanceMetrics": {
    "totalInvestment": 295850.00,
    "currentValue": 345000.00,
    "currentEquity": 146550.00,
    "totalReturn": 49700.00,
    "totalReturnPercentage": 16.8,
    "annualizedReturn": 2.4,
    "mortgagePaidDown": 29550.00,
    "capitalAppreciation": 60000.00,
    "netRentalIncomeReceived": 41424.00
  },
  "notes": "Buy-to-let property purchased in 2019. Currently let on assured shorthold tenancy. Property has increased in value by approximately 21% since purchase. Good rental yield area.",
  "createdDate": "2026-02-17T10:00:00Z",
  "createdBy": {
    "id": "adv-789",
    "name": "Jane Adviser"
  },
  "lastModifiedDate": "2026-02-17T10:00:00Z",
  "lastModifiedBy": {
    "id": "adv-789",
    "name": "Jane Adviser"
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/properties/prop-789" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" },
    "valuations": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/valuations" },
    "ltv": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/ltv" },
    "rental-yield": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/rental-yield" },
    "capital-gains": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/capital-gains" },
    "equity": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/equity" },
    "expenses": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/expenses" },
    "update": { "href": "/api/v1/factfinds/ff-456/properties/prop-789", "method": "PUT" },
    "delete": { "href": "/api/v1/factfinds/ff-456/properties/prop-789", "method": "DELETE" }
  }
}
```

**Validation Rules:**
- Property address is required
- Purchase date cannot be in the future
- Purchase price must be positive
- Current valuation value must be positive
- Ownership percentages must sum to 100%
- At least one owner required
- Linked mortgage balances should not exceed property value (warning if LTV > 100%)
- Rental income required if propertyType is BuyToLet and isCurrentlyRented is true
- Leasehold properties must have leaseYearsRemaining specified
- EPC rating required for residential properties in UK (legal requirement)

**HTTP Status Codes:**
- `201 Created` - Property created successfully
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - FactFind not found
- `422 Unprocessable Entity` - Validation failed

**Error Response Example:**

```json
{
  "type": "https://api.factfind.com/errors/validation-error",
  "title": "Property Validation Failed",
  "status": 422,
  "detail": "Ownership percentages must sum to 100%",
  "instance": "/api/v1/factfinds/ff-456/properties",
  "errors": [
    {
      "field": "ownership.owners",
      "message": "Total ownership percentage is 95% but must equal 100%",
      "rejectedValue": [
        {"ownershipPercentage": 45.0},
        {"ownershipPercentage": 50.0}
      ],
      "constraint": "sumEquals100",
      "currentSum": 95.0,
      "requiredSum": 100.0
    }
  ]
}
```

---

##### 9.4.2.2 List Properties

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/properties`

**Description:** List all properties in the client's portfolio with current valuations, LTV calculations, and rental yields.

**Query Parameters:**
- `propertyType` - Filter by property type: Residential, BuyToLet, Commercial, Holiday, Land
- `ownershipType` - Filter by ownership: Sole, JointTenants, TenantsInCommon, Company, Trust
- `clientId` - Filter properties owned by specific client
- `isRented` - Filter by rental status (true/false)
- `includeValuations` - Include valuation history (default: false)
- `includeExpenses` - Include expense details (default: false)
- `sortBy` - Sort field: value, purchaseDate, ltv, rentalYield, equity
- `sortOrder` - Sort order: asc, desc

**Response:**

```json
{
  "properties": [
    {
      "id": "prop-789",
      "propertyType": "BuyToLet",
      "propertySubtype": "ResidentialFlat",
      "address": {
        "line1": "Flat 12, Riverside Apartments",
        "line2": "45 Thames Street",
        "city": "Manchester",
        "postcode": "M1 2AB",
        "formattedAddress": "Flat 12, Riverside Apartments, 45 Thames Street, Manchester, M1 2AB"
      },
      "ownership": {
        "ownershipType": "JointTenants",
        "primaryOwner": "John Smith",
        "ownerCount": 2
      },
      "purchase": {
        "purchaseDate": "2019-06-15",
        "purchasePrice": 285000.00,
        "yearsOwned": 6.6
      },
      "currentValuation": {
        "value": 345000.00,
        "valuationDate": "2026-01-15",
        "valuationType": "Online",
        "daysOld": 33
      },
      "financials": {
        "totalMortgageBalance": 198450.00,
        "equity": 146550.00,
        "equityPercentage": 42.5,
        "ltvPercentage": 57.5,
        "capitalGain": 60000.00,
        "capitalGainPercentage": 21.05
      },
      "rental": {
        "isRented": true,
        "monthlyRent": 1650.00,
        "annualRent": 19800.00,
        "grossYield": 5.74,
        "netYield": 1.82
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/properties/prop-789" },
        "ltv": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/ltv" },
        "rental-yield": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/rental-yield" }
      }
    },
    {
      "id": "prop-790",
      "propertyType": "Residential",
      "propertySubtype": "SemiDetachedHouse",
      "address": {
        "line1": "42 Oakwood Drive",
        "line2": null,
        "city": "Leeds",
        "postcode": "LS17 8QY",
        "formattedAddress": "42 Oakwood Drive, Leeds, LS17 8QY"
      },
      "ownership": {
        "ownershipType": "JointTenants",
        "primaryOwner": "John Smith",
        "ownerCount": 2
      },
      "purchase": {
        "purchaseDate": "2015-03-20",
        "purchasePrice": 425000.00,
        "yearsOwned": 10.9
      },
      "currentValuation": {
        "value": 575000.00,
        "valuationDate": "2026-02-10",
        "valuationType": "EstateAgent",
        "daysOld": 7
      },
      "financials": {
        "totalMortgageBalance": 285000.00,
        "equity": 290000.00,
        "equityPercentage": 50.4,
        "ltvPercentage": 49.6,
        "capitalGain": 150000.00,
        "capitalGainPercentage": 35.29
      },
      "rental": {
        "isRented": false,
        "isPrimaryResidence": true
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/properties/prop-790" },
        "ltv": { "href": "/api/v1/factfinds/ff-456/properties/prop-790/ltv" },
        "capital-gains": { "href": "/api/v1/factfinds/ff-456/properties/prop-790/capital-gains" }
      }
    },
    {
      "id": "prop-791",
      "propertyType": "Holiday",
      "propertySubtype": "DetachedHouse",
      "address": {
        "line1": "Seaview Cottage",
        "line2": "12 Coastal Road",
        "city": "Whitby",
        "postcode": "YO21 3HB",
        "formattedAddress": "Seaview Cottage, 12 Coastal Road, Whitby, YO21 3HB"
      },
      "ownership": {
        "ownershipType": "Sole",
        "primaryOwner": "John Smith",
        "ownerCount": 1
      },
      "purchase": {
        "purchaseDate": "2021-08-10",
        "purchasePrice": 315000.00,
        "yearsOwned": 4.5
      },
      "currentValuation": {
        "value": 355000.00,
        "valuationDate": "2025-11-20",
        "valuationType": "Online",
        "daysOld": 88
      },
      "financials": {
        "totalMortgageBalance": 0.00,
        "equity": 355000.00,
        "equityPercentage": 100.0,
        "ltvPercentage": 0.0,
        "capitalGain": 40000.00,
        "capitalGainPercentage": 12.70
      },
      "rental": {
        "isRented": false,
        "isPrimaryResidence": false,
        "isOccasionallyLet": true,
        "annualRentalDays": 45,
        "estimatedAnnualIncome": 9000.00
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/properties/prop-791" },
        "capital-gains": { "href": "/api/v1/factfinds/ff-456/properties/prop-791/capital-gains" }
      }
    }
  ],
  "summary": {
    "totalProperties": 3,
    "totalValue": 1275000.00,
    "totalMortgages": 483450.00,
    "totalEquity": 791550.00,
    "averageLTV": 37.9,
    "totalCapitalGain": 250000.00,
    "propertyByType": {
      "Residential": 1,
      "BuyToLet": 1,
      "Holiday": 1
    },
    "rentedProperties": 1,
    "totalAnnualRentalIncome": 19800.00,
    "averageGrossYield": 5.74
  },
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 3,
    "totalPages": 1
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/properties" },
    "create": { "href": "/api/v1/factfinds/ff-456/properties", "method": "POST" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" }
  }
}
```

**HTTP Status Codes:**
- `200 OK` - Properties retrieved successfully
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - FactFind not found

---

##### 9.4.2.3 Get Property Details

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/properties/{id}`

**Description:** Get complete property information including current valuation, linked mortgages, equity calculation, rental income tracking, capital gains, and historical valuations.

**Query Parameters:**
- `includeValuationHistory` - Include all historical valuations (default: false)
- `includeExpenseHistory` - Include all expense records (default: false)
- `includeMortgageDetails` - Include full mortgage details (default: true)

**Response:**

```json
{
  "id": "prop-789",
  "factfindId": "ff-456",
  "propertyType": "BuyToLet",
  "propertySubtype": "ResidentialFlat",
  "propertyPurpose": "Investment",
  "address": {
    "line1": "Flat 12, Riverside Apartments",
    "line2": "45 Thames Street",
    "line3": null,
    "city": "Manchester",
    "county": "Greater Manchester",
    "postcode": "M1 2AB",
    "country": "United Kingdom",
    "uprn": "100023456789",
    "formattedAddress": "Flat 12, Riverside Apartments, 45 Thames Street, Manchester, M1 2AB",
    "coordinates": {
      "latitude": 53.4808,
      "longitude": -2.2426
    }
  },
  "ownership": {
    "ownershipType": "JointTenants",
    "owners": [
      {
        "clientId": "client-123",
        "ownershipPercentage": 50.0,
        "ownerName": "John Smith",
        "isPrimaryOwner": true
      },
      {
        "clientId": "client-124",
        "ownershipPercentage": 50.0,
        "ownerName": "Jane Smith",
        "isPrimaryOwner": false
      }
    ],
    "ownershipNotes": "Joint tenants with right of survivorship"
  },
  "purchase": {
    "purchaseDate": "2019-06-15",
    "purchasePrice": 285000.00,
    "purchaseCurrency": "GBP",
    "stampDutyPaid": 8500.00,
    "stampDutyRate": "Higher rate - additional property",
    "legalFees": 1500.00,
    "surveyFees": 600.00,
    "otherPurchaseCosts": 250.00,
    "totalAcquisitionCost": 295850.00,
    "fundingSource": "MortgageAndSavings",
    "mortgageAmount": 228000.00,
    "depositAmount": 57000.00,
    "depositPercentage": 20.0,
    "yearsOwned": 6.6
  },
  "currentValuation": {
    "value": 345000.00,
    "valuationDate": "2026-01-15",
    "valuationType": "Online",
    "valuationProvider": "Zoopla",
    "valuationReference": "ZPL-2026-12345",
    "valuerName": null,
    "valuerNotes": "Automated valuation based on recent sales in area. Confidence: Medium. Range: £330,000 - £360,000",
    "confidenceLevel": "Medium",
    "valuationRange": {
      "lower": 330000.00,
      "upper": 360000.00
    },
    "daysOld": 33,
    "nextValuationDue": "2027-01-15"
  },
  "valuationHistory": [
    {
      "valuationDate": "2026-01-15",
      "value": 345000.00,
      "valuationType": "Online",
      "provider": "Zoopla",
      "changeFromPrevious": 10000.00,
      "percentageChange": 2.99
    },
    {
      "valuationDate": "2025-01-10",
      "value": 335000.00,
      "valuationType": "Online",
      "provider": "Rightmove",
      "changeFromPrevious": 15000.00,
      "percentageChange": 4.69
    },
    {
      "valuationDate": "2024-02-01",
      "value": 320000.00,
      "valuationType": "Professional",
      "provider": "RICS Valuer",
      "changeFromPrevious": 15000.00,
      "percentageChange": 4.92
    },
    {
      "valuationDate": "2022-06-15",
      "value": 305000.00,
      "valuationType": "EstateAgent",
      "provider": "Local Estate Agent",
      "changeFromPrevious": 20000.00,
      "percentageChange": 7.02
    },
    {
      "valuationDate": "2019-06-15",
      "value": 285000.00,
      "valuationType": "Purchase",
      "provider": "Purchase Price",
      "changeFromPrevious": 0.00,
      "percentageChange": 0.00
    }
  ],
  "propertyDetails": {
    "bedrooms": 2,
    "bathrooms": 2,
    "receptionRooms": 1,
    "totalRooms": 5,
    "propertySize": {
      "area": 750,
      "unit": "SquareFeet",
      "areaInSquareMeters": 69.7
    },
    "tenure": "Leasehold",
    "leaseYearsRemaining": 95,
    "leaseStartDate": "2015-01-01",
    "leaseExpiryDate": "2140-01-01",
    "yearBuilt": 2015,
    "propertyAge": 11,
    "constructionType": "NewBuild",
    "parking": "OneSpace",
    "garden": false,
    "epcRating": "B",
    "epcScore": 82,
    "epcValidUntil": "2028-03-15",
    "councilTaxBand": "D",
    "annualCouncilTax": 1850.00
  },
  "linkedMortgages": [
    {
      "arrangementId": "arr-mortgage-789",
      "mortgageProvider": "Nationwide Building Society",
      "accountNumber": "****5678",
      "mortgageType": "BuyToLetInterestOnly",
      "originalAmount": 228000.00,
      "outstandingBalance": 198450.00,
      "amountPaidOff": 29550.00,
      "interestRate": 3.89,
      "interestRateType": "Fixed",
      "monthlyPayment": 1245.00,
      "annualPayment": 14940.00,
      "startDate": "2019-06-15",
      "endDate": "2029-06-15",
      "yearsRemaining": 3.4,
      "fixedRateEndDate": "2024-06-15",
      "ltvAtOrigination": 80.0,
      "currentLTV": 57.5
    }
  ],
  "totalMortgageBalance": 198450.00,
  "equity": {
    "currentValue": 345000.00,
    "totalMortgages": 198450.00,
    "equityAmount": 146550.00,
    "equityPercentage": 42.5,
    "originalEquity": 57000.00,
    "equityGrowth": 89550.00,
    "equityGrowthPercentage": 157.1
  },
  "loanToValue": {
    "currentLTV": 57.5,
    "purchaseLTV": 80.0,
    "ltvChange": -22.5,
    "ltvStatus": "Good",
    "ltvWarning": null,
    "recommendedLTV": {
      "conservative": 75.0,
      "standard": 80.0,
      "maximum": 85.0
    }
  },
  "capitalGrowth": {
    "purchasePrice": 285000.00,
    "currentValue": 345000.00,
    "absoluteGain": 60000.00,
    "percentageGain": 21.05,
    "annualizedReturn": 3.02,
    "totalReturn": 109700.00,
    "totalReturnPercentage": 38.4,
    "comparisonVsMarket": {
      "marketAverageGrowth": 18.5,
      "outperformance": 2.55
    }
  },
  "rentalDetails": {
    "isCurrentlyRented": true,
    "tenancyType": "AssuredShorthold",
    "tenancyStartDate": "2023-08-01",
    "tenancyEndDate": "2024-07-31",
    "tenancyLengthMonths": 12,
    "monthlyRentalIncome": 1650.00,
    "annualRentalIncome": 19800.00,
    "rentalIncomeFrequency": "Monthly",
    "tenantName": "Mr. David Jones",
    "tenantContactEmail": "david.jones@email.com",
    "tenantOccupancyMonths": 18,
    "managementType": "LettingAgent",
    "lettingAgent": {
      "name": "Manchester Property Lettings Ltd",
      "contactName": "Sarah Williams",
      "phone": "0161 234 5678",
      "email": "sarah@manchesterpropertylet.co.uk",
      "managementFeePercentage": 12.0,
      "monthlyManagementFee": 198.00,
      "annualManagementFee": 2376.00
    },
    "rentReviewDate": "2024-08-01",
    "proposedNewRent": 1700.00,
    "rentIncreasePercentage": 3.03,
    "depositAmount": 2475.00,
    "depositProtectionScheme": "MyDeposits",
    "depositProtectionReference": "MD-123456-789",
    "voidPeriods": [
      {
        "startDate": "2022-12-01",
        "endDate": "2023-01-15",
        "daysVoid": 45,
        "lostRent": 2475.00
      }
    ],
    "totalVoidDays": 45,
    "occupancyRate": 97.9
  },
  "expenses": {
    "annualExpenses": [
      {
        "expenseType": "MortgageInterest",
        "amount": 7500.00,
        "frequency": "Annual",
        "taxDeductible": true,
        "notes": "Interest-only mortgage payments"
      },
      {
        "expenseType": "ManagementFees",
        "amount": 2376.00,
        "frequency": "Annual",
        "taxDeductible": true,
        "notes": "Letting agent fees at 12%"
      },
      {
        "expenseType": "ServiceCharge",
        "amount": 1800.00,
        "frequency": "Annual",
        "taxDeductible": true,
        "notes": "Building service charge"
      },
      {
        "expenseType": "GroundRent",
        "amount": 250.00,
        "frequency": "Annual",
        "taxDeductible": true,
        "notes": "Annual ground rent"
      },
      {
        "expenseType": "Insurance",
        "amount": 450.00,
        "frequency": "Annual",
        "taxDeductible": true,
        "notes": "Landlord building and contents insurance"
      },
      {
        "expenseType": "Maintenance",
        "amount": 800.00,
        "frequency": "Annual",
        "taxDeductible": true,
        "notes": "Average annual maintenance and repairs"
      },
      {
        "expenseType": "SafetyCertificates",
        "amount": 350.00,
        "frequency": "Annual",
        "taxDeductible": true,
        "notes": "Gas safety, EPC, EICR certificates"
      }
    ],
    "totalAnnualExpenses": 13526.00,
    "totalTaxDeductibleExpenses": 13526.00,
    "monthlyExpenses": 1127.17
  },
  "rentalYield": {
    "grossAnnualRent": 19800.00,
    "currentPropertyValue": 345000.00,
    "grossYieldPercentage": 5.74,
    "totalAnnualExpenses": 13526.00,
    "netAnnualIncome": 6274.00,
    "netYieldPercentage": 1.82,
    "marketAverageYield": 5.2,
    "yieldVsMarket": 0.54,
    "yieldRating": "AboveAverage",
    "cashOnCashReturn": 11.01,
    "yieldTrend": {
      "currentYear": 5.74,
      "previousYear": 5.52,
      "twoYearsAgo": 5.31,
      "trend": "Increasing"
    }
  },
  "taxInformation": {
    "isPrimaryResidence": false,
    "hasEverBeenPrimaryResidence": false,
    "primaryResidencePeriod": null,
    "eligibleForPrivateResidenceRelief": false,
    "eligibleForLettingRelief": false,
    "lettingReliefAmount": 0.00,
    "wearAndTearAllowanceClaimed": false,
    "capitalAllowancesClaimed": false,
    "stampDutyRatePaid": "HigherRate",
    "stampDutyAmount": 8500.00,
    "estimatedCGTLiability": {
      "potentialGain": 60000.00,
      "deductions": 10850.00,
      "taxableGain": 49150.00,
      "cgtRate": 28.0,
      "estimatedTax": 13762.00,
      "note": "Assumes higher rate taxpayer, no PRR or letting relief"
    }
  },
  "capitalGainsTaxCalculation": {
    "disposalValue": 345000.00,
    "purchaseCost": 285000.00,
    "stampDuty": 8500.00,
    "legalFees": 1500.00,
    "improvementCosts": 0.00,
    "disposalCosts": 3450.00,
    "allowableDeductions": 13450.00,
    "grossGain": 60000.00,
    "netGain": 46550.00,
    "annualCGTAllowance": 12300.00,
    "taxableGain": 34250.00,
    "cgtRateBasic": 18.0,
    "cgtRateHigher": 28.0,
    "estimatedCGTBasicRate": 6165.00,
    "estimatedCGTHigherRate": 9590.00,
    "privateResidenceRelief": 0.00,
    "lettingRelief": 0.00,
    "note": "Actual CGT liability depends on taxpayer's overall income and allowances used"
  },
  "performanceMetrics": {
    "totalInvestment": 295850.00,
    "currentValue": 345000.00,
    "currentEquity": 146550.00,
    "totalEquityReturn": 49700.00,
    "equityReturnPercentage": 16.8,
    "annualizedReturn": 2.4,
    "mortgagePaidDown": 29550.00,
    "capitalAppreciation": 60000.00,
    "totalRentalIncomeReceived": 124200.00,
    "totalExpensesPaid": 82824.00,
    "netRentalIncome": 41376.00,
    "totalReturn": 130926.00,
    "totalReturnPercentage": 44.3,
    "irr": 8.7,
    "returnOnInvestment": {
      "capitalGain": 60000.00,
      "rentalProfit": 41376.00,
      "mortgageReduction": 29550.00,
      "totalProfit": 130926.00,
      "profitPercentage": 44.3
    }
  },
  "marketComparison": {
    "localAreaAveragePricePerSqFt": 450.00,
    "propertyPricePerSqFt": 460.00,
    "priceVsArea": 2.22,
    "localAreaAverageYield": 5.2,
    "propertyYield": 5.74,
    "yieldVsArea": 10.38,
    "localAreaCapitalGrowth1Year": 2.5,
    "propertyCapitalGrowth1Year": 2.99,
    "performanceVsArea": "AboveAverage"
  },
  "notes": "Buy-to-let property purchased in 2019. Currently let on assured shorthold tenancy. Property has increased in value by approximately 21% since purchase. Good rental yield area. Tenant has been reliable and rent reviews have been accepted without issue.",
  "createdDate": "2026-02-17T10:00:00Z",
  "createdBy": {
    "id": "adv-789",
    "name": "Jane Adviser",
    "email": "jane.adviser@financialservices.com"
  },
  "lastModifiedDate": "2026-02-17T10:00:00Z",
  "lastModifiedBy": {
    "id": "adv-789",
    "name": "Jane Adviser",
    "email": "jane.adviser@financialservices.com"
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/properties/prop-789" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" },
    "valuations": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/valuations" },
    "add-valuation": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/valuations", "method": "POST" },
    "ltv": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/ltv" },
    "rental-yield": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/rental-yield" },
    "capital-gains": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/capital-gains" },
    "equity": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/equity" },
    "expenses": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/expenses" },
    "add-expense": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/expenses", "method": "POST" },
    "update": { "href": "/api/v1/factfinds/ff-456/properties/prop-789", "method": "PUT" },
    "delete": { "href": "/api/v1/factfinds/ff-456/properties/prop-789", "method": "DELETE" }
  }
}
```

**HTTP Status Codes:**
- `200 OK` - Property retrieved successfully
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Property or FactFind not found

---

##### 9.4.2.4 Add Property Valuation

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/properties/{id}/valuations`

**Description:** Add a new valuation to the property's valuation history. Supports multiple valuation types including professional valuations, estate agent valuations, and online estimates.

**Request Body:**

```json
{
  "valuationDate": "2026-02-17",
  "value": 350000.00,
  "valuationType": "Professional",
  "valuationProvider": "RICS Chartered Surveyor",
  "valuerDetails": {
    "name": "Thompson Valuation Services Ltd",
    "valuerName": "Michael Thompson MRICS",
    "ricsMember": true,
    "ricsMembershipNumber": "1234567",
    "contactEmail": "m.thompson@thompsonvaluations.co.uk",
    "contactPhone": "0161 555 0123"
  },
  "valuationReference": "TVS-2026-456789",
  "valuationReportUrl": "https://secure-docs.factfind.com/valuations/tvs-2026-456789.pdf",
  "valuationMethod": "ComparisonMethod",
  "valuationPurpose": "RemortgageApplication",
  "valuationRange": {
    "lower": 345000.00,
    "upper": 355000.00
  },
  "confidenceLevel": "High",
  "marketConditions": "Stable",
  "comparableProperties": [
    {
      "address": "Flat 8, Riverside Apartments, 45 Thames Street",
      "soldDate": "2025-11-15",
      "soldPrice": 342000.00,
      "bedrooms": 2,
      "propertySize": 720
    },
    {
      "address": "Flat 15, Waterside Court, 52 Canal Street",
      "soldDate": "2025-12-10",
      "soldPrice": 355000.00,
      "bedrooms": 2,
      "propertySize": 780
    },
    {
      "address": "Flat 6, Harborview, 18 Dockside Road",
      "soldDate": "2026-01-05",
      "soldPrice": 348000.00,
      "bedrooms": 2,
      "propertySize": 760
    }
  ],
  "marketInsights": "Property values in this area have shown steady growth of 3-4% annually. Recent sales of similar 2-bed apartments range from £342k to £355k. Strong demand from professionals working in city center. New transport links have improved accessibility.",
  "notes": "Professional RICS valuation conducted for remortgage application. Property in good condition with recent kitchen refurbishment. Comparable sales support current valuation.",
  "instructedBy": "adv-789",
  "instructedDate": "2026-02-10",
  "reportDeliveredDate": "2026-02-17",
  "validityPeriod": 90,
  "fees": {
    "valuationFee": 450.00,
    "adminFee": 50.00,
    "totalFee": 500.00
  }
}
```

**Valuation Type Values:**
- `Purchase` - Original purchase price
- `Professional` - RICS qualified surveyor valuation
- `EstateAgent` - Estate agent market appraisal
- `Online` - Online valuation tool (Zoopla, Rightmove)
- `SelfAssessed` - Owner's own estimate
- `Mortgage` - Lender's valuation for mortgage
- `Insurance` - Insurance rebuild value
- `Probate` - Probate valuation for estate
- `TaxAuthority` - HMRC or council valuation

**Valuation Method Values:**
- `ComparisonMethod` - Sales comparison approach
- `InvestmentMethod` - Income capitalization approach
- `ResidualMethod` - Development residual approach
- `CostMethod` - Depreciated replacement cost
- `ProfitsMethod` - Trading potential approach

**Valuation Purpose Values:**
- `MortgageApplication` - Mortgage lending purposes
- `RemortgageApplication` - Remortgage purposes
- `PortfolioReview` - Portfolio valuation review
- `Insurance` - Insurance coverage purposes
- `TaxPlanning` - Capital gains or IHT planning
- `Probate` - Estate administration
- `Divorce` - Matrimonial proceedings
- `GeneralAdvice` - General financial planning

**Market Conditions Values:**
- `Strong` - Strong buyer demand, rising prices
- `Stable` - Balanced market conditions
- `Weak` - Low demand, falling prices
- `Volatile` - Uncertain market conditions

**Response:**

```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/ff-456/properties/prop-789/valuations/val-123
```

```json
{
  "id": "val-123",
  "propertyId": "prop-789",
  "factfindId": "ff-456",
  "valuationDate": "2026-02-17",
  "value": 350000.00,
  "currency": "GBP",
  "valuationType": "Professional",
  "valuationProvider": "RICS Chartered Surveyor",
  "valuerDetails": {
    "name": "Thompson Valuation Services Ltd",
    "valuerName": "Michael Thompson MRICS",
    "ricsMember": true,
    "ricsMembershipNumber": "1234567",
    "contactEmail": "m.thompson@thompsonvaluations.co.uk",
    "contactPhone": "0161 555 0123"
  },
  "valuationReference": "TVS-2026-456789",
  "valuationReportUrl": "https://secure-docs.factfind.com/valuations/tvs-2026-456789.pdf",
  "valuationMethod": "ComparisonMethod",
  "valuationPurpose": "RemortgageApplication",
  "valuationRange": {
    "lower": 345000.00,
    "upper": 355000.00,
    "variance": 10000.00,
    "variancePercentage": 2.86
  },
  "confidenceLevel": "High",
  "marketConditions": "Stable",
  "comparableProperties": [
    {
      "address": "Flat 8, Riverside Apartments, 45 Thames Street",
      "soldDate": "2025-11-15",
      "soldPrice": 342000.00,
      "bedrooms": 2,
      "propertySize": 720,
      "pricePerSqFt": 475.00
    },
    {
      "address": "Flat 15, Waterside Court, 52 Canal Street",
      "soldDate": "2025-12-10",
      "soldPrice": 355000.00,
      "bedrooms": 2,
      "propertySize": 780,
      "pricePerSqFt": 455.13
    },
    {
      "address": "Flat 6, Harborview, 18 Dockside Road",
      "soldDate": "2026-01-05",
      "soldPrice": 348000.00,
      "bedrooms": 2,
      "propertySize": 760,
      "pricePerSqFt": 457.89
    }
  ],
  "comparablesAverage": 348333.33,
  "marketInsights": "Property values in this area have shown steady growth of 3-4% annually. Recent sales of similar 2-bed apartments range from £342k to £355k. Strong demand from professionals working in city center. New transport links have improved accessibility.",
  "changeFromPreviousValuation": {
    "previousValue": 345000.00,
    "previousDate": "2026-01-15",
    "changeAmount": 5000.00,
    "changePercentage": 1.45,
    "daysBetween": 33,
    "annualizedGrowthRate": 16.5
  },
  "changeFromPurchase": {
    "purchasePrice": 285000.00,
    "purchaseDate": "2019-06-15",
    "changeAmount": 65000.00,
    "changePercentage": 22.81,
    "yearsOwned": 6.67,
    "annualizedGrowthRate": 3.21
  },
  "impactOnFinancials": {
    "newLTV": 56.7,
    "previousLTV": 57.5,
    "ltvImprovement": 0.8,
    "newEquity": 151550.00,
    "previousEquity": 146550.00,
    "equityIncrease": 5000.00,
    "newEquityPercentage": 43.3
  },
  "notes": "Professional RICS valuation conducted for remortgage application. Property in good condition with recent kitchen refurbishment. Comparable sales support current valuation.",
  "instructedBy": {
    "id": "adv-789",
    "name": "Jane Adviser"
  },
  "instructedDate": "2026-02-10",
  "reportDeliveredDate": "2026-02-17",
  "turnaroundDays": 7,
  "validUntil": "2026-05-18",
  "validityPeriod": 90,
  "fees": {
    "valuationFee": 450.00,
    "adminFee": 50.00,
    "totalFee": 500.00
  },
  "createdDate": "2026-02-17T14:30:00Z",
  "createdBy": {
    "id": "adv-789",
    "name": "Jane Adviser"
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/valuations/val-123" },
    "property": { "href": "/api/v1/factfinds/ff-456/properties/prop-789" },
    "valuation-report": { "href": "https://secure-docs.factfind.com/valuations/tvs-2026-456789.pdf" },
    "valuation-history": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/valuations" }
  }
}
```

**Validation Rules:**
- Valuation date cannot be in the future
- Valuation value must be positive
- RICS valuations require valuer RICS membership number
- Professional valuations should include valuation report
- Valuation range (if provided) must include the main value
- Comparable properties should be from last 6 months for best accuracy
- Valuation validity period typically 90 days for mortgage purposes

**HTTP Status Codes:**
- `201 Created` - Valuation created successfully
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Property not found
- `422 Unprocessable Entity` - Validation failed

---

##### 9.4.2.5 Calculate LTV (Loan-to-Value)

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/properties/{id}/ltv`

**Description:** Calculate comprehensive Loan-to-Value ratio across all mortgages secured against the property. Provides LTV analysis, equity position, and recommendations.

**Query Parameters:**
- `valuationDate` - Use specific valuation date (default: latest)
- `includeProjections` - Include future LTV projections (default: false)

**Response:**

```json
{
  "propertyId": "prop-789",
  "propertyAddress": "Flat 12, Riverside Apartments, 45 Thames Street, Manchester, M1 2AB",
  "calculationDate": "2026-02-17T14:30:00Z",
  "currentValuation": {
    "value": 350000.00,
    "valuationDate": "2026-02-17",
    "valuationType": "Professional",
    "valuationProvider": "RICS Chartered Surveyor",
    "valuationAge": 0,
    "valuationConfidence": "High"
  },
  "mortgages": [
    {
      "arrangementId": "arr-mortgage-789",
      "mortgageProvider": "Nationwide Building Society",
      "accountNumber": "****5678",
      "mortgageType": "BuyToLetInterestOnly",
      "outstandingBalance": 198450.00,
      "originalAmount": 228000.00,
      "interestRate": 3.89,
      "monthlyPayment": 1245.00,
      "startDate": "2019-06-15",
      "endDate": "2029-06-15",
      "yearsRemaining": 3.4,
      "mortgageLTV": 56.7,
      "priority": "First"
    }
  ],
  "totalMortgageBalance": 198450.00,
  "totalMonthlyPayments": 1245.00,
  "totalAnnualPayments": 14940.00,
  "ltvAnalysis": {
    "currentLTV": 56.7,
    "ltvBand": "51-75%",
    "ltvRating": "Good",
    "ltvStatus": "Healthy",
    "purchaseLTV": 80.0,
    "ltvImprovement": 23.3,
    "ltvChangeDescription": "LTV has improved significantly from 80% to 56.7% due to property appreciation and mortgage paydown"
  },
  "equityPosition": {
    "currentValue": 350000.00,
    "totalMortgages": 198450.00,
    "equityAmount": 151550.00,
    "equityPercentage": 43.3,
    "originalEquity": 57000.00,
    "equityGrowth": 94550.00,
    "equityGrowthPercentage": 165.9,
    "equityGrowthSources": {
      "capitalAppreciation": 65000.00,
      "mortgageReduction": 29550.00,
      "improvements": 0.00
    }
  },
  "ltvThresholds": {
    "excellent": {
      "threshold": 50.0,
      "status": "Not Met",
      "description": "Excellent LTV - below 50%",
      "benefit": "Access to best mortgage rates"
    },
    "good": {
      "threshold": 75.0,
      "status": "Met",
      "description": "Good LTV - below 75%",
      "benefit": "Access to competitive mortgage rates"
    },
    "standard": {
      "threshold": 80.0,
      "status": "Met",
      "description": "Standard LTV - below 80%",
      "benefit": "Good range of mortgage products available"
    },
    "high": {
      "threshold": 90.0,
      "status": "Met",
      "description": "High LTV - 80-90%",
      "benefit": "Limited mortgage products, higher rates"
    },
    "veryHigh": {
      "threshold": 95.0,
      "status": "Met",
      "description": "Very High LTV - 90-95%",
      "benefit": "Very limited products, highest rates"
    },
    "excessive": {
      "threshold": 100.0,
      "status": "Met",
      "description": "Excessive LTV - above 95%",
      "benefit": "Negative equity risk, remortgage difficult"
    }
  },
  "currentThreshold": "good",
  "riskAssessment": {
    "ltvRisk": "Low",
    "negativeEquityRisk": "None",
    "remortgageProspects": "Excellent",
    "furtherBorrowingCapacity": {
      "at75LTV": 64050.00,
      "at80LTV": 81550.00,
      "at85LTV": 99050.00,
      "recommendation": "Significant equity available for further borrowing or remortgage"
    },
    "stressTesting": {
      "valueDropToReach75LTV": -32000.00,
      "valueDropPercentage": -9.14,
      "valueDropToReach80LTV": -57000.00,
      "valueDropPercentageFor80": -16.29,
      "valueDropToNegativeEquity": -151550.00,
      "valueDropPercentageNegativeEquity": -43.3,
      "resilience": "High - Property can withstand significant value decline before reaching concerning LTV levels"
    }
  },
  "marketContext": {
    "averageLTVForPropertyType": 65.0,
    "clientLTVVsAverage": -8.3,
    "clientPosition": "Better than average",
    "firstTimeBuyerAverageLTV": 85.0,
    "remortgageAverageLTV": 60.0
  },
  "recommendations": [
    {
      "priority": "High",
      "recommendation": "Consider remortgaging to access better rates",
      "rationale": "Current LTV of 56.7% provides access to highly competitive mortgage rates. Could save approximately £150-200/month on mortgage payments.",
      "potentialBenefit": "£1,800-2,400 annual saving",
      "action": "Review mortgage market for better deals"
    },
    {
      "priority": "Medium",
      "recommendation": "Equity release opportunity",
      "rationale": "£64,050 available to borrow while maintaining 75% LTV. Could be used for property improvements, investment diversification, or portfolio expansion.",
      "potentialBenefit": "Access to equity for investment",
      "action": "Consider further advance or remortgage with equity release"
    },
    {
      "priority": "Low",
      "recommendation": "Monitor property valuations",
      "rationale": "Continue obtaining annual valuations to track equity growth and ensure LTV remains healthy.",
      "potentialBenefit": "Maintain awareness of financial position",
      "action": "Schedule next valuation in 12 months"
    }
  ],
  "ltvHistory": [
    {
      "date": "2026-02-17",
      "value": 350000.00,
      "mortgageBalance": 198450.00,
      "ltv": 56.7,
      "equity": 151550.00
    },
    {
      "date": "2026-01-15",
      "value": 345000.00,
      "mortgageBalance": 199200.00,
      "ltv": 57.7,
      "equity": 145800.00
    },
    {
      "date": "2025-01-10",
      "value": 335000.00,
      "mortgageBalance": 207500.00,
      "ltv": 61.9,
      "equity": 127500.00
    },
    {
      "date": "2024-02-01",
      "value": 320000.00,
      "mortgageBalance": 215800.00,
      "ltv": 67.4,
      "equity": 104200.00
    },
    {
      "date": "2022-06-15",
      "value": 305000.00,
      "mortgageBalance": 224100.00,
      "ltv": 73.5,
      "equity": 80900.00
    },
    {
      "date": "2019-06-15",
      "value": 285000.00,
      "mortgageBalance": 228000.00,
      "ltv": 80.0,
      "equity": 57000.00
    }
  ],
  "ltvTrend": {
    "direction": "Improving",
    "averageAnnualImprovement": 3.5,
    "projectedLTVIn1Year": 53.2,
    "projectedLTVIn3Years": 46.4,
    "projectedLTVIn5Years": 39.8,
    "assumptions": "Based on 3% annual property growth and current mortgage payments"
  },
  "calculationMetadata": {
    "calculationMethod": "Current mortgage balance / Current property value * 100",
    "dataSource": "Latest property valuation and mortgage statements",
    "lastUpdated": "2026-02-17T14:30:00Z",
    "nextUpdateRecommended": "2027-02-17"
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/ltv" },
    "property": { "href": "/api/v1/factfinds/ff-456/properties/prop-789" },
    "valuations": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/valuations" },
    "mortgages": { "href": "/api/v1/factfinds/ff-456/arrangements?type=Mortgage&propertyId=prop-789" },
    "equity": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/equity" }
  }
}
```

**LTV Bands:**
- `0-50%` - Excellent (best mortgage rates available)
- `51-75%` - Good (competitive rates)
- `76-80%` - Standard (good product range)
- `81-90%` - High (limited products, higher rates)
- `91-95%` - Very High (very limited options)
- `96-100%` - Excessive (high risk)
- `>100%` - Negative Equity (remortgage very difficult)

**HTTP Status Codes:**
- `200 OK` - LTV calculated successfully
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Property not found

---

##### 9.4.2.6 Calculate Rental Yield

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/properties/{id}/rental-yield`

**Description:** Calculate comprehensive rental yield analysis including gross yield, net yield, cash-on-cash return, and comparison to market averages. For buy-to-let properties only.

**Query Parameters:**
- `includeProjections` - Include future yield projections (default: false)
- `includeExpenseBreakdown` - Include detailed expense analysis (default: true)

**Response:**

```json
{
  "propertyId": "prop-789",
  "propertyAddress": "Flat 12, Riverside Apartments, 45 Thames Street, Manchester, M1 2AB",
  "propertyType": "BuyToLet",
  "calculationDate": "2026-02-17T14:30:00Z",
  "calculationPeriod": "Annual",
  "rentalIncome": {
    "monthlyRent": 1650.00,
    "annualRent": 19800.00,
    "rentFrequency": "Monthly",
    "tenancyStatus": "Occupied",
    "currentTenant": "Mr. David Jones",
    "tenancyStartDate": "2023-08-01",
    "tenancyEndDate": "2024-07-31",
    "nextRentReview": "2024-08-01",
    "proposedRentIncrease": 50.00,
    "proposedNewRent": 1700.00,
    "proposedIncreasePercentage": 3.03
  },
  "propertyValuation": {
    "currentValue": 350000.00,
    "valuationDate": "2026-02-17",
    "valuationType": "Professional"
  },
  "grossYieldCalculation": {
    "formula": "(Annual Rent / Property Value) * 100",
    "annualRent": 19800.00,
    "propertyValue": 350000.00,
    "grossYieldPercentage": 5.66,
    "grossYieldRating": "Good",
    "marketAverageGrossYield": 5.2,
    "differenceFromMarket": 0.46,
    "performanceVsMarket": "Above Average"
  },
  "expenses": {
    "mortgagePayments": {
      "type": "InterestOnly",
      "annualAmount": 14940.00,
      "interestRate": 3.89,
      "taxDeductible": true,
      "notes": "Interest-only payments - principal not repaid"
    },
    "managementFees": {
      "annualAmount": 2376.00,
      "percentage": 12.0,
      "provider": "Manchester Property Lettings Ltd",
      "taxDeductible": true
    },
    "serviceCharge": {
      "annualAmount": 1800.00,
      "taxDeductible": true,
      "notes": "Building maintenance and communal areas"
    },
    "groundRent": {
      "annualAmount": 250.00,
      "taxDeductible": true,
      "notes": "Annual ground rent - leasehold property"
    },
    "insurance": {
      "annualAmount": 450.00,
      "type": "LandlordInsurance",
      "taxDeductible": true,
      "notes": "Building and contents insurance"
    },
    "maintenance": {
      "annualAmount": 800.00,
      "taxDeductible": true,
      "notes": "Average annual maintenance and repairs"
    },
    "safetyCertificates": {
      "annualAmount": 350.00,
      "taxDeductible": true,
      "notes": "Gas safety, EPC, EICR certificates"
    },
    "voidPeriods": {
      "annualAmount": 0.00,
      "daysVoid": 0,
      "notes": "No void periods in last 12 months"
    },
    "totalAnnualExpenses": 20966.00,
    "totalTaxDeductibleExpenses": 20966.00,
    "expenseRatio": 105.9
  },
  "netYieldCalculation": {
    "formula": "((Annual Rent - Annual Expenses) / Property Value) * 100",
    "annualRent": 19800.00,
    "annualExpenses": 20966.00,
    "netAnnualIncome": -1166.00,
    "propertyValue": 350000.00,
    "netYieldPercentage": -0.33,
    "netYieldRating": "Poor",
    "marketAverageNetYield": 2.1,
    "differenceFromMarket": -2.43,
    "performanceVsMarket": "Below Average",
    "notes": "Negative net yield due to high expenses. However, property has strong capital growth and mortgage interest will reduce over time."
  },
  "cashOnCashReturn": {
    "formula": "(Net Annual Income / Initial Investment) * 100",
    "initialInvestment": 57000.00,
    "netAnnualIncome": -1166.00,
    "cashOnCashReturn": -2.05,
    "notes": "Negative cash flow currently, but strong capital appreciation offsets this"
  },
  "yieldComparison": {
    "nationalAverageYield": 4.8,
    "regionalAverageYield": 5.2,
    "localAreaAverageYield": 5.5,
    "clientGrossYield": 5.66,
    "clientNetYield": -0.33,
    "comparisonSummary": "Gross yield slightly above local average. Net yield impacted by high mortgage costs. Consider remortgaging to improve net yield."
  },
  "taxConsiderations": {
    "rentalIncome": 19800.00,
    "allowableExpenses": 20966.00,
    "taxableProfit": -1166.00,
    "taxPosition": "Loss",
    "mortgageInterestRestriction": {
      "mortgageInterest": 7500.00,
      "restrictionApplies": true,
      "basicRateTaxRelief": 1500.00,
      "notes": "Since April 2020, mortgage interest no longer fully deductible. Only 20% tax credit available."
    },
    "adjustedTaxableProfit": 6334.00,
    "estimatedTaxLiability": {
      "basicRate": 1266.80,
      "higherRate": 2533.60,
      "notes": "Actual tax depends on individual's total income and tax position"
    },
    "afterTaxNetIncome": {
      "basicRateTaxpayer": -2432.80,
      "higherRateTaxpayer": -3699.60
    },
    "afterTaxYield": {
      "basicRateTaxpayer": -0.70,
      "higherRateTaxpayer": -1.06
    }
  },
  "profitabilityAnalysis": {
    "monthlyIncome": 1650.00,
    "monthlyExpenses": 1747.17,
    "monthlyCashFlow": -97.17,
    "annualCashFlow": -1166.00,
    "cashFlowStatus": "Negative",
    "capitalGrowth": {
      "purchasePrice": 285000.00,
      "currentValue": 350000.00,
      "capitalGain": 65000.00,
      "capitalGainPercentage": 22.81,
      "annualizedCapitalGrowth": 3.21
    },
    "totalReturn": {
      "rentalIncome": -1166.00,
      "capitalGrowth": 65000.00,
      "mortgageReduction": 29550.00,
      "totalAnnualReturn": 93384.00,
      "totalReturnPercentage": 163.8,
      "annualizedTotalReturn": 15.8
    },
    "investmentViability": "Good",
    "viabilityNotes": "Despite negative cash flow, strong capital appreciation and mortgage reduction make this a viable long-term investment. Consider refinancing to improve cash flow."
  },
  "recommendations": [
    {
      "priority": "High",
      "recommendation": "Remortgage to improve net yield",
      "rationale": "Current LTV of 56.7% allows access to better mortgage rates. Reducing interest rate from 3.89% to 3.0% would save £2,000/year, turning negative yield positive.",
      "potentialImpact": {
        "currentAnnualExpenses": 20966.00,
        "projectedAnnualExpenses": 18966.00,
        "annualSaving": 2000.00,
        "newNetYield": 0.24,
        "improvement": 0.57
      },
      "action": "Research remortgage options"
    },
    {
      "priority": "High",
      "recommendation": "Rent increase at next review",
      "rationale": "Proposed rent increase to £1,700/month (3%) is below market rate. Local comparables show similar properties renting for £1,750-1,800/month.",
      "potentialImpact": {
        "currentAnnualRent": 19800.00,
        "proposedAnnualRent": 20400.00,
        "annualIncrease": 600.00,
        "newGrossYield": 5.83,
        "newNetYield": -0.16,
        "improvement": 0.17
      },
      "action": "Issue rent increase notice for next review"
    },
    {
      "priority": "Medium",
      "recommendation": "Review management fees",
      "rationale": "Letting agent charges 12% which is above market average of 10%. Potential saving of £396/year.",
      "potentialImpact": {
        "currentManagementFees": 2376.00,
        "marketAverageFees": 1980.00,
        "potentialSaving": 396.00
      },
      "action": "Research alternative letting agents or negotiate fee reduction"
    },
    {
      "priority": "Low",
      "recommendation": "Build maintenance reserve",
      "rationale": "Property is 11 years old. Major maintenance items may be needed in next 5-10 years (boiler, appliances, decorating).",
      "potentialImpact": {
        "recommendedReserve": 500.00,
        "notes": "£500/year reserve fund for future maintenance"
      },
      "action": "Set aside monthly reserve for future expenses"
    }
  ],
  "yieldTrend": {
    "historical": [
      {
        "year": 2026,
        "grossYield": 5.66,
        "netYield": -0.33
      },
      {
        "year": 2025,
        "grossYield": 5.91,
        "netYield": 0.24
      },
      {
        "year": 2024,
        "grossYield": 6.19,
        "netYield": 0.94
      },
      {
        "year": 2023,
        "grossYield": 6.23,
        "netYield": 1.15
      }
    ],
    "trendDirection": "Declining",
    "trendReason": "Property value growth outpacing rent increases, combined with rising mortgage costs",
    "projectedYield3Years": {
      "grossYield": 5.45,
      "netYield": 0.12,
      "assumptions": "3% annual rent increases, 3% annual property value growth, remortgage at 3.0%"
    }
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/rental-yield" },
    "property": { "href": "/api/v1/factfinds/ff-456/properties/prop-789" },
    "expenses": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/expenses" },
    "ltv": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/ltv" },
    "capital-gains": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/capital-gains" }
  }
}
```

**Yield Rating Bands:**
- **Gross Yield:**
  - Excellent: > 7%
  - Good: 5-7%
  - Average: 3-5%
  - Poor: < 3%
- **Net Yield:**
  - Excellent: > 4%
  - Good: 2-4%
  - Average: 0-2%
  - Poor: < 0%

**HTTP Status Codes:**
- `200 OK` - Yield calculated successfully
- `400 Bad Request` - Property is not buy-to-let type
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Property not found

---

##### 9.4.2.7 Calculate Capital Gains Tax

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/properties/{id}/capital-gains`

**Description:** Calculate comprehensive Capital Gains Tax (CGT) liability on property disposal, including Private Residence Relief (PRR), Letting Relief, and UK tax regulations.

**Query Parameters:**
- `disposalPrice` - Hypothetical disposal price (default: current valuation)
- `disposalDate` - Hypothetical disposal date (default: today)
- `disposalCosts` - Estimated selling costs (default: 1% of disposal price)
- `includeScenarios` - Include multiple disposal scenarios (default: false)

**Response:**

```json
{
  "propertyId": "prop-789",
  "propertyAddress": "Flat 12, Riverside Apartments, 45 Thames Street, Manchester, M1 2AB",
  "propertyType": "BuyToLet",
  "calculationDate": "2026-02-17T14:30:00Z",
  "taxYear": "2025/26",
  "disposal": {
    "disposalPrice": 350000.00,
    "disposalDate": "2026-02-17",
    "disposalMethod": "OpenMarketSale",
    "disposalCosts": {
      "estateAgentFees": 2800.00,
      "legalFees": 1500.00,
      "epcAndOtherCerts": 150.00,
      "totalDisposalCosts": 4450.00
    }
  },
  "acquisition": {
    "purchasePrice": 285000.00,
    "purchaseDate": "2019-06-15",
    "stampDutyLandTax": 8500.00,
    "legalFees": 1500.00,
    "surveyFees": 600.00,
    "otherAcquisitionCosts": 250.00,
    "totalAcquisitionCosts": 10850.00
  },
  "improvements": {
    "capitalImprovements": [
      {
        "description": "Kitchen refurbishment",
        "date": "2023-03-15",
        "cost": 8500.00,
        "isCapitalImprovement": true,
        "notes": "Full kitchen replacement qualifies as capital improvement"
      }
    ],
    "totalImprovementCosts": 8500.00,
    "repairs": [
      {
        "description": "Boiler repair",
        "date": "2024-06-10",
        "cost": 450.00,
        "isCapitalImprovement": false,
        "notes": "Repairs not allowable for CGT"
      }
    ],
    "totalRepairCosts": 450.00
  },
  "gainCalculation": {
    "disposalProceeds": 350000.00,
    "lessDisposalCosts": 4450.00,
    "netDisposalProceeds": 345550.00,
    "acquisitionCost": 285000.00,
    "lessAcquisitionCosts": 10850.00,
    "lessImprovementCosts": 8500.00,
    "totalAllowableDeductions": 19350.00,
    "totalCostBase": 304350.00,
    "grossGain": 41200.00,
    "formula": "Net Disposal Proceeds - Total Cost Base"
  },
  "reliefs": {
    "privateResidenceRelief": {
      "eligible": false,
      "periodOfOwnership": {
        "totalMonths": 80,
        "residenceMonths": 0,
        "absenceMonths": 80,
        "lettingMonths": 42
      },
      "prr Amount": 0.00,
      "finalPeriodExemption": 0.00,
      "notes": "Property never used as main residence. No PRR available."
    },
    "lettingRelief": {
      "eligible": false,
      "maxLettingRelief": 40000.00,
      "actualLettingRelief": 0.00,
      "notes": "Letting relief only available if PRR claimed. Not applicable here."
    },
    "totalReliefs": 0.00
  },
  "taxableGain": {
    "grossGain": 41200.00,
    "lessReliefs": 0.00,
    "gainAfterReliefs": 41200.00,
    "annualExemptAmount": 12300.00,
    "taxableGain": 28900.00,
    "taxYear": "2025/26"
  },
  "cgtCalculation": {
    "taxableGain": 28900.00,
    "cgtRates": {
      "basicRate": 18.0,
      "higherAdditionalRate": 28.0,
      "notes": "Residential property CGT rates apply (18%/28% vs 10%/20% for other assets)"
    },
    "scenarios": [
      {
        "taxpayerType": "BasicRateTaxpayer",
        "applicableRate": 18.0,
        "cgtLiability": 5202.00,
        "effectiveTaxRate": 12.6,
        "notes": "Basic rate taxpayer - 18% CGT on residential property"
      },
      {
        "taxpayerType": "HigherRateTaxpayer",
        "applicableRate": 28.0,
        "cgtLiability": 8092.00,
        "effectiveTaxRate": 19.6,
        "notes": "Higher/additional rate taxpayer - 28% CGT on residential property"
      },
      {
        "taxpayerType": "SplitRate",
        "description": "Part basic, part higher rate",
        "basicRateBand": 37700.00,
        "otherIncome": 30000.00,
        "remainingBasicRate": 7700.00,
        "taxedAtBasicRate": 7700.00,
        "taxedAtHigherRate": 21200.00,
        "cgtBasicRate": 1386.00,
        "cgtHigherRate": 5936.00,
        "totalCGT": 7322.00,
        "effectiveTaxRate": 17.8,
        "notes": "Taxpayer with income near basic rate threshold"
      }
    ],
    "estimatedCGT": {
      "minimum": 5202.00,
      "maximum": 8092.00,
      "mostLikely": 8092.00,
      "notes": "Most buy-to-let landlords are higher rate taxpayers"
    }
  },
  "netProceeds": {
    "disposalProceeds": 350000.00,
    "lessDisposalCosts": 4450.00,
    "lessMortgageRepayment": 198450.00,
    "lessEstimatedCGT": 8092.00,
    "netProceedsToClient": 139008.00,
    "originalInvestment": 295850.00,
    "netProfit": -156842.00,
    "profitPercentage": -53.0,
    "notes": "After all costs and tax, client retains £139,008 from original £57,000 investment (143% return)"
  },
  "paymentDueDate": {
    "disposalDate": "2026-02-17",
    "taxYear": "2025/26",
    "selfAssessmentDeadline": "2027-01-31",
    "paymentOnAccountRequired": false,
    "notes": "CGT payable by 31 January following end of tax year"
  },
  "planningOpportunities": [
    {
      "opportunity": "Defer disposal to next tax year",
      "benefit": "Utilize 2026/27 CGT annual exemption (£12,300)",
      "potentialSaving": 0.00,
      "notes": "Already in 2025/26 tax year - not applicable"
    },
    {
      "opportunity": "Transfer to spouse before sale",
      "benefit": "Utilize both spouses' CGT annual exemptions (£24,600 total)",
      "potentialSaving": 3444.00,
      "feasibility": "High",
      "notes": "Property jointly owned. Each spouse can use their £12,300 exemption"
    },
    {
      "opportunity": "Hold for 12+ months",
      "benefit": "Already held for 6.67 years - long-term holding period met",
      "potentialSaving": 0.00,
      "notes": "No additional benefit from longer hold period"
    },
    {
      "opportunity": "Sell in tranches over multiple tax years",
      "benefit": "Spread gain over multiple years to use annual exemptions",
      "potentialSaving": 3444.00,
      "feasibility": "Low",
      "notes": "Property cannot easily be sold in tranches. Better to use spouse exemption."
    }
  ],
  "recommendations": [
    {
      "priority": "High",
      "recommendation": "Review ownership structure before sale",
      "rationale": "Property jointly owned by spouses. Ensure ownership shares are structured to maximize use of both CGT annual exemptions (£24,600 total vs £12,300).",
      "potentialSaving": 3444.00,
      "action": "Confirm ownership shares and file separate tax returns"
    },
    {
      "priority": "High",
      "recommendation": "Document all improvement costs",
      "rationale": "£8,500 kitchen refurbishment reduces CGT liability by £2,380. Ensure all receipts and evidence retained.",
      "potentialSaving": 2380.00,
      "action": "Gather all improvement invoices and receipts"
    },
    {
      "priority": "Medium",
      "recommendation": "Consider timing of sale",
      "rationale": "No urgent need to sell. If capital gain expected to continue growing, may trigger higher CGT in future.",
      "potentialImpact": "Monitor CGT rates and exemptions for changes",
      "action": "Review annually"
    },
    {
      "priority": "Low",
      "recommendation": "Explore incorporation",
      "rationale": "Holding property in limited company has different tax treatment. Corporation tax 25%, but double tax on extraction. Complex analysis required.",
      "feasibility": "Low for existing property",
      "notes": "Incorporation triggers CGT on transfer. Better for new acquisitions."
    }
  ],
  "comparisonScenarios": [
    {
      "scenario": "Sell now at £350,000",
      "netProceeds": 139008.00,
      "cgt": 8092.00,
      "returnOnInvestment": 143.9
    },
    {
      "scenario": "Sell at £375,000 (7% growth)",
      "netProceeds": 154558.00,
      "cgt": 13092.00,
      "returnOnInvestment": 171.1
    },
    {
      "scenario": "Sell at £400,000 (14% growth)",
      "netProceeds": 170108.00,
      "cgt": 18092.00,
      "returnOnInvestment": 198.4
    },
    {
      "scenario": "Hold 3 years, sell at £380,000",
      "assumptions": "3% annual growth, mortgage paid down to £180,000",
      "netProceeds": 165408.00,
      "cgt": 12592.00,
      "additionalRentalProfit": 18000.00,
      "totalReturn": 183408.00,
      "returnOnInvestment": 221.8
    }
  ],
  "importantNotes": [
    "CGT rates for residential property (18%/28%) higher than other assets (10%/20%)",
    "Annual exemption of £12,300 applies across all capital gains in tax year",
    "CGT payable by 31 January following end of tax year",
    "Non-residents have different CGT rules and may pay 28% regardless of income",
    "This calculation assumes UK tax residency and excludes foreign tax implications",
    "Actual liability depends on individual circumstances - seek professional tax advice"
  ],
  "calculationMetadata": {
    "calculationDate": "2026-02-17T14:30:00Z",
    "taxYear": "2025/26",
    "cgtAnnualExemption2025_26": 12300.00,
    "residentialPropertyCGTRates": {
      "basicRate": 18.0,
      "higherRate": 28.0
    },
    "dataSource": "HMRC CGT rates 2025/26",
    "disclaimer": "This is an estimate only. Actual CGT liability may differ based on individual circumstances. Professional tax advice recommended."
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/properties/prop-789/capital-gains" },
    "property": { "href": "/api/v1/factfinds/ff-456/properties/prop-789" },
    "tax-planning": { "href": "/api/v1/factfinds/ff-456/tax-planning" },
    "hmrc-guidance": { "href": "https://www.gov.uk/capital-gains-tax" }
  }
}
```

**CGT Rates (2025/26):**
- **Residential Property:**
  - Basic rate taxpayers: 18%
  - Higher/Additional rate taxpayers: 28%
- **Other Assets:**
  - Basic rate taxpayers: 10%
  - Higher/Additional rate taxpayers: 20%

**Annual Exemption (2025/26):** £12,300

**Private Residence Relief (PRR):**
- Full relief for period of main residence
- Final 9 months always exempt
- Periods of absence may qualify in certain circumstances

**Letting Relief:**
- Maximum £40,000 per person
- Only available if PRR claimed
- Lesser of: PRR amount, £40,000, or gain from letting

**Validation Rules:**
- Disposal price must be positive
- Disposal date cannot be before purchase date
- All costs must be positive values
- Tax year correctly identified from disposal date

**HTTP Status Codes:**
- `200 OK` - CGT calculated successfully
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Property not found

**Error Response Example:**

```json
{
  "type": "https://api.factfind.com/errors/validation-error",
  "title": "Capital Gains Calculation Failed",
  "status": 422,
  "detail": "Disposal date cannot be before purchase date",
  "instance": "/api/v1/factfinds/ff-456/properties/prop-789/capital-gains",
  "errors": [
    {
      "field": "disposalDate",
      "message": "Disposal date (2018-01-01) is before purchase date (2019-06-15)",
      "rejectedValue": "2018-01-01",
      "constraint": "afterPurchaseDate",
      "purchaseDate": "2019-06-15"
    }
  ]
}
```

---

### 9.5 Equities Portfolio API

**Purpose:** Track direct stock holdings, manage equity portfolios, monitor performance, and calculate capital gains for individual stock investments.

**Scope:**
- Direct stock holdings tracking with purchase history
- Stock portfolio management and consolidation
- Real-time and historical price tracking
- Dividend tracking and reinvestment (DRIP)
- Capital gains and loss tracking with tax calculations
- Corporate actions (splits, dividends, rights issues, mergers)
- Market data integration (LSE, NYSE, NASDAQ, etc.)
- Section 104 holding pooling (UK tax treatment)
- Portfolio performance metrics and analytics
- Diversification analysis

**Aggregate Root:** FactFind (equities are nested within fact find)

**Regulatory Compliance:**
- FCA Handbook - Understanding client assets
- MiFID II - Best execution and reporting
- HMRC Capital Gains Tax regulations
- Section 104 Holding Rules (UK)
- US securities regulations for US-listed stocks
- Data Protection Act 2018 - Investment data retention

#### 9.5.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/equities` | Add equity holding | `assets:write` |
| GET | `/api/v1/factfinds/{factfindId}/equities` | List equity holdings | `assets:read` |
| GET | `/api/v1/factfinds/{factfindId}/equities/{id}` | Get equity details | `assets:read` |
| PUT | `/api/v1/factfinds/{factfindId}/equities/{id}` | Update equity | `assets:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/equities/{id}` | Delete equity | `assets:write` |
| GET | `/api/v1/factfinds/{factfindId}/equities/portfolio-performance` | Get portfolio performance | `assets:read` |
| GET | `/api/v1/factfinds/{factfindId}/equities/{id}/dividends` | Get dividend history | `assets:read` |
| POST | `/api/v1/factfinds/{factfindId}/equities/{id}/dividends` | Record dividend | `assets:write` |
| GET | `/api/v1/factfinds/{factfindId}/equities/{id}/capital-gains` | Calculate capital gains | `assets:read` |
| POST | `/api/v1/factfinds/{factfindId}/equities/{id}/corporate-actions` | Record corporate action | `assets:write` |
| POST | `/api/v1/factfinds/{factfindId}/equities/{id}/transactions` | Add buy/sell transaction | `assets:write` |
| GET | `/api/v1/factfinds/{factfindId}/equities/{id}/transactions` | Get transaction history | `assets:read` |
| GET | `/api/v1/factfinds/{factfindId}/equities/{id}/performance` | Get holding performance | `assets:read` |

#### 9.5.2 Key Endpoints

##### 9.5.2.1 Add Equity Holding

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/equities`

**Description:** Add a new equity (stock) holding to the client's portfolio. Supports stocks from major exchanges worldwide including LSE, NYSE, NASDAQ, and others.

**Request Body:**

```json
{
  "securityIdentification": {
    "tickerSymbol": "BARC.L",
    "isin": "GB0031348658",
    "sedol": "3134865",
    "cusip": null,
    "securityName": "Barclays PLC",
    "securityType": "OrdinaryShare",
    "exchange": "LSE",
    "exchangeName": "London Stock Exchange",
    "country": "United Kingdom",
    "sector": "Financials",
    "industry": "Banks"
  },
  "initialPurchase": {
    "purchaseDate": "2022-03-15",
    "quantity": 5000,
    "purchasePrice": 1.85,
    "pricePerShare": 1.85,
    "currency": "GBP",
    "totalCost": 9250.00,
    "transactionCosts": {
      "brokerCommission": 11.99,
      "stampDuty": 46.25,
      "otherFees": 0.00,
      "totalCosts": 58.24
    },
    "totalInvestment": 9308.24,
    "averageCostPerShare": 1.862,
    "broker": "Hargreaves Lansdown",
    "accountNumber": "HL123456",
    "orderType": "MarketOrder",
    "notes": "Initial purchase of Barclays shares"
  },
  "currentHolding": {
    "totalQuantity": 5000,
    "averagePurchasePrice": 1.862,
    "totalCostBasis": 9308.24,
    "acquisitionMethod": "Purchase"
  },
  "valuationMethod": "MarkToMarket",
  "ownership": {
    "clientId": "client-123",
    "ownerName": "John Smith",
    "accountType": "Individual",
    "holdingStructure": "DirectOwnership",
    "taxWrapper": "None"
  },
  "dividendPreference": {
    "reinvestDividends": false,
    "dividendPaymentMethod": "BankTransfer",
    "notes": "Dividends paid into linked bank account"
  },
  "notes": "Long-term holding in UK banking sector. Part of diversified portfolio strategy.",
  "adviserId": "adv-789"
}
```

**Security Type Values:**
- `OrdinaryShare` - Common stock/ordinary shares
- `PreferredShare` - Preferred stock
- `ADR` - American Depositary Receipt
- `GDR` - Global Depositary Receipt
- `REIT` - Real Estate Investment Trust
- `ETF` - Exchange Traded Fund (if tracking individual equities)

**Exchange Values:**
- `LSE` - London Stock Exchange
- `NYSE` - New York Stock Exchange
- `NASDAQ` - NASDAQ
- `EURONEXT` - Euronext
- `XETRA` - Deutsche Börse XETRA
- `TSE` - Tokyo Stock Exchange
- `HKEX` - Hong Kong Stock Exchange

**Tax Wrapper Values:**
- `None` - No tax wrapper (general investment account)
- `ISA` - Individual Savings Account (UK)
- `SIPP` - Self-Invested Personal Pension (UK)
- `401k` - 401(k) retirement plan (US)
- `IRA` - Individual Retirement Account (US)
- `Roth IRA` - Roth IRA (US)

**Response:**

```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/ff-456/equities/eq-789
```

```json
{
  "id": "eq-789",
  "factfindId": "ff-456",
  "securityIdentification": {
    "tickerSymbol": "BARC.L",
    "isin": "GB0031348658",
    "sedol": "3134865",
    "cusip": null,
    "securityName": "Barclays PLC",
    "securityType": "OrdinaryShare",
    "exchange": "LSE",
    "exchangeName": "London Stock Exchange",
    "country": "United Kingdom",
    "sector": "Financials",
    "industry": "Banks",
    "mic": "XLON"
  },
  "currentHolding": {
    "totalQuantity": 5000,
    "averagePurchasePrice": 1.862,
    "totalCostBasis": 9308.24,
    "costPerShare": 1.862,
    "acquisitionMethod": "Purchase",
    "holdingPeriod": {
      "firstPurchaseDate": "2022-03-15",
      "daysHeld": 1435,
      "yearsHeld": 3.93
    }
  },
  "currentMarketValue": {
    "currentPrice": 2.15,
    "priceDate": "2026-02-17T16:35:00Z",
    "currency": "GBP",
    "priceChange24h": 0.03,
    "priceChangePercentage24h": 1.42,
    "totalMarketValue": 10750.00,
    "dataSource": "LSE",
    "lastUpdated": "2026-02-17T16:35:00Z"
  },
  "unrealizedGainLoss": {
    "costBasis": 9308.24,
    "currentValue": 10750.00,
    "unrealizedGain": 1441.76,
    "unrealizedGainPercentage": 15.49,
    "gainPerShare": 0.288,
    "gainPerSharePercentage": 15.47
  },
  "ownership": {
    "clientId": "client-123",
    "ownerName": "John Smith",
    "accountType": "Individual",
    "holdingStructure": "DirectOwnership",
    "taxWrapper": "None",
    "brokerAccount": {
      "broker": "Hargreaves Lansdown",
      "accountNumber": "HL123456"
    }
  },
  "dividendInformation": {
    "dividendYield": 4.65,
    "annualDividend": 0.10,
    "dividendFrequency": "Quarterly",
    "lastDividendAmount": 0.025,
    "lastDividendDate": "2026-01-15",
    "exDividendDate": "2026-01-10",
    "nextDividendEstimate": 0.025,
    "nextExDividendDate": "2026-04-10",
    "totalDividendsReceived": 1475.00,
    "reinvestDividends": false
  },
  "performance": {
    "since Inception": {
      "return": 1441.76,
      "returnPercentage": 15.49,
      "annualizedReturn": 3.76
    },
    "ytd": {
      "return": 125.00,
      "returnPercentage": 1.18
    },
    "1month": {
      "return": 50.00,
      "returnPercentage": 0.47
    },
    "3months": {
      "return": 175.00,
      "returnPercentage": 1.66
    },
    "1year": {
      "return": 550.00,
      "returnPercentage": 5.39
    }
  },
  "taxInformation": {
    "taxWrapper": "None",
    "taxableHolding": true,
    "cgtExemptionAvailable": true,
    "section104Pooling": true,
    "holdingPeriodQualification": "LongTerm"
  },
  "riskMetrics": {
    "beta": 1.25,
    "volatility30Day": 18.5,
    "sharpeRatio": 0.72,
    "maxDrawdown": -12.3,
    "riskRating": "Medium-High"
  },
  "valuationMethod": "MarkToMarket",
  "notes": "Long-term holding in UK banking sector. Part of diversified portfolio strategy.",
  "createdDate": "2026-02-17T10:00:00Z",
  "createdBy": {
    "id": "adv-789",
    "name": "Jane Adviser"
  },
  "lastModifiedDate": "2026-02-17T10:00:00Z",
  "lastModifiedBy": {
    "id": "adv-789",
    "name": "Jane Adviser"
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/equities/eq-789" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" },
    "dividends": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/dividends" },
    "transactions": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/transactions" },
    "performance": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/performance" },
    "capital-gains": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/capital-gains" },
    "corporate-actions": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/corporate-actions" },
    "update": { "href": "/api/v1/factfinds/ff-456/equities/eq-789", "method": "PUT" },
    "delete": { "href": "/api/v1/factfinds/ff-456/equities/eq-789", "method": "DELETE" }
  }
}
```

**Validation Rules:**
- Either ticker symbol or ISIN must be provided
- Quantity must be positive
- Purchase price must be positive
- Purchase date cannot be in the future
- Currency must be valid ISO 4217 code
- Exchange must be recognized exchange code
- Transaction costs cannot exceed 10% of purchase value (warning threshold)

**HTTP Status Codes:**
- `201 Created` - Equity holding created successfully
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - FactFind not found
- `422 Unprocessable Entity` - Validation failed

**Error Response Example:**

```json
{
  "type": "https://api.factfind.com/errors/validation-error",
  "title": "Equity Holding Validation Failed",
  "status": 422,
  "detail": "Invalid ISIN format",
  "instance": "/api/v1/factfinds/ff-456/equities",
  "errors": [
    {
      "field": "securityIdentification.isin",
      "message": "ISIN must be 12 characters (2 letter country code + 10 alphanumeric)",
      "rejectedValue": "GB003134865",
      "constraint": "isinFormat",
      "expectedFormat": "^[A-Z]{2}[A-Z0-9]{10}$"
    }
  ]
}
```

---

##### 9.5.2.2 List Equity Holdings

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/equities`

**Description:** List all equity holdings in the client's portfolio with current prices, unrealized gains/losses, and portfolio summary.

**Query Parameters:**
- `exchange` - Filter by exchange (LSE, NYSE, NASDAQ, etc.)
- `sector` - Filter by sector (Technology, Financials, Healthcare, etc.)
- `currency` - Filter by currency (GBP, USD, EUR, etc.)
- `taxWrapper` - Filter by tax wrapper (None, ISA, SIPP, etc.)
- `clientId` - Filter by specific client
- `includePerformance` - Include performance metrics (default: true)
- `sortBy` - Sort field: value, gain, dividendYield, ticker
- `sortOrder` - Sort order: asc, desc

**Response:**

```json
{
  "holdings": [
    {
      "id": "eq-789",
      "ticker": "BARC.L",
      "securityName": "Barclays PLC",
      "exchange": "LSE",
      "sector": "Financials",
      "holding": {
        "quantity": 5000,
        "averageCost": 1.862,
        "totalCostBasis": 9308.24
      },
      "currentValue": {
        "price": 2.15,
        "priceDate": "2026-02-17T16:35:00Z",
        "currency": "GBP",
        "totalValue": 10750.00,
        "priceChange24h": 1.42
      },
      "gainLoss": {
        "unrealizedGain": 1441.76,
        "gainPercentage": 15.49
      },
      "dividends": {
        "yield": 4.65,
        "annualDividend": 0.10,
        "totalReceived": 1475.00
      },
      "performance": {
        "ytd": 1.18,
        "oneYear": 5.39
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/equities/eq-789" }
      }
    },
    {
      "id": "eq-790",
      "ticker": "AAPL",
      "securityName": "Apple Inc.",
      "exchange": "NASDAQ",
      "sector": "Technology",
      "holding": {
        "quantity": 150,
        "averageCost": 145.50,
        "totalCostBasis": 21825.00
      },
      "currentValue": {
        "price": 178.25,
        "priceDate": "2026-02-17T21:00:00Z",
        "currency": "USD",
        "totalValue": 26737.50,
        "totalValueGBP": 21390.00,
        "exchangeRate": 1.25,
        "priceChange24h": 0.85
      },
      "gainLoss": {
        "unrealizedGain": 4912.50,
        "unrealizedGainGBP": 3929.40,
        "gainPercentage": 22.51,
        "currencyGainLoss": -983.10
      },
      "dividends": {
        "yield": 0.52,
        "annualDividend": 0.92,
        "totalReceived": 276.00
      },
      "performance": {
        "ytd": 4.25,
        "oneYear": 18.75
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/equities/eq-790" }
      }
    },
    {
      "id": "eq-791",
      "ticker": "VOD.L",
      "securityName": "Vodafone Group PLC",
      "exchange": "LSE",
      "sector": "Telecommunications",
      "holding": {
        "quantity": 12000,
        "averageCost": 0.95,
        "totalCostBasis": 11400.00
      },
      "currentValue": {
        "price": 0.78,
        "priceDate": "2026-02-17T16:35:00Z",
        "currency": "GBP",
        "totalValue": 9360.00,
        "priceChange24h": -1.27
      },
      "gainLoss": {
        "unrealizedLoss": -2040.00,
        "lossPercentage": -17.89
      },
      "dividends": {
        "yield": 7.69,
        "annualDividend": 0.06,
        "totalReceived": 2280.00
      },
      "performance": {
        "ytd": -3.15,
        "oneYear": -12.45
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/equities/eq-791" }
      }
    },
    {
      "id": "eq-792",
      "ticker": "MSFT",
      "securityName": "Microsoft Corporation",
      "exchange": "NASDAQ",
      "sector": "Technology",
      "holding": {
        "quantity": 100,
        "averageCost": 285.00,
        "totalCostBasis": 28500.00
      },
      "currentValue": {
        "price": 415.50,
        "priceDate": "2026-02-17T21:00:00Z",
        "currency": "USD",
        "totalValue": 41550.00,
        "totalValueGBP": 33240.00,
        "exchangeRate": 1.25,
        "priceChange24h": 1.15
      },
      "gainLoss": {
        "unrealizedGain": 13050.00,
        "unrealizedGainGBP": 10440.00,
        "gainPercentage": 45.79,
        "currencyGainLoss": -2610.00
      },
      "dividends": {
        "yield": 0.72,
        "annualDividend": 3.00,
        "totalReceived": 600.00
      },
      "performance": {
        "ytd": 6.85,
        "oneYear": 28.50
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/equities/eq-792" }
      }
    }
  ],
  "portfolioSummary": {
    "totalHoldings": 4,
    "totalCostBasis": 71033.24,
    "totalCostBasisGBP": 71033.24,
    "totalMarketValue": 88397.50,
    "totalMarketValueGBP": 74740.00,
    "totalUnrealizedGain": 3706.76,
    "totalUnrealizedGainPercentage": 5.22,
    "currencyExposure": {
      "GBP": 31110.00,
      "USD": 43630.00
    },
    "currencyGainLoss": -3593.10,
    "totalDividendsReceived": 4631.00,
    "averageYield": 3.40,
    "topHoldings": [
      {
        "ticker": "MSFT",
        "value": 33240.00,
        "percentageOfPortfolio": 44.5
      },
      {
        "ticker": "AAPL",
        "value": 21390.00,
        "percentageOfPortfolio": 28.6
      },
      {
        "ticker": "BARC.L",
        "value": 10750.00,
        "percentageOfPortfolio": 14.4
      }
    ],
    "sectorAllocation": {
      "Technology": 54630.00,
      "Financials": 10750.00,
      "Telecommunications": 9360.00
    },
    "sectorAllocationPercentage": {
      "Technology": 73.1,
      "Financials": 14.4,
      "Telecommunications": 12.5
    },
    "geographicAllocation": {
      "UnitedKingdom": 20110.00,
      "UnitedStates": 54630.00
    },
    "geographicAllocationPercentage": {
      "UnitedKingdom": 26.9,
      "UnitedStates": 73.1
    },
    "performanceMetrics": {
      "portfolioReturnYTD": 3.85,
      "portfolioReturn1Year": 12.45,
      "portfolioReturnSinceInception": 5.22,
      "bestPerformer": {
        "ticker": "MSFT",
        "return": 45.79
      },
      "worstPerformer": {
        "ticker": "VOD.L",
        "return": -17.89
      }
    },
    "diversificationMetrics": {
      "numberOfHoldings": 4,
      "concentrationRisk": "High",
      "topHoldingPercentage": 44.5,
      "top3HoldingsPercentage": 87.5,
      "diversificationScore": 42,
      "recommendation": "Portfolio highly concentrated in technology sector (73%). Consider diversification into other sectors."
    }
  },
  "marketData": {
    "lastUpdated": "2026-02-17T21:00:00Z",
    "dataProvider": "Bloomberg",
    "delayMinutes": 0,
    "exchangeRates": {
      "GBPUSD": 1.2500,
      "USDGBP": 0.8000,
      "lastUpdated": "2026-02-17T21:00:00Z"
    }
  },
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 4,
    "totalPages": 1
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/equities" },
    "create": { "href": "/api/v1/factfinds/ff-456/equities", "method": "POST" },
    "portfolio-performance": { "href": "/api/v1/factfinds/ff-456/equities/portfolio-performance" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" }
  }
}
```

**HTTP Status Codes:**
- `200 OK` - Holdings retrieved successfully
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - FactFind not found

---

##### 9.5.2.3 Get Equity Holding Details

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/equities/{id}`

**Description:** Get complete equity holding information including purchase history, current price, unrealized gains/losses, dividend history, corporate actions, and performance metrics.

**Query Parameters:**
- `includePriceHistory` - Include historical price data (default: false)
- `includeDividendHistory` - Include all dividend payments (default: true)
- `includeCorporateActions` - Include corporate action history (default: true)
- `includeTransactions` - Include all buy/sell transactions (default: true)

**Response:**

```json
{
  "id": "eq-789",
  "factfindId": "ff-456",
  "securityIdentification": {
    "tickerSymbol": "BARC.L",
    "isin": "GB0031348658",
    "sedol": "3134865",
    "cusip": null,
    "securityName": "Barclays PLC",
    "securityType": "OrdinaryShare",
    "exchange": "LSE",
    "exchangeName": "London Stock Exchange",
    "exchangeMIC": "XLON",
    "country": "United Kingdom",
    "sector": "Financials",
    "industry": "Banks",
    "subIndustry": "Diversified Banks",
    "companyDescription": "Barclays PLC is a British universal bank. It is diversified by business, by different types of customers and clients, and by geography.",
    "companyWebsite": "https://home.barclays",
    "marketCap": 29500000000,
    "marketCapCurrency": "GBP",
    "sharesOutstanding": 13720000000
  },
  "holding": {
    "totalQuantity": 5000,
    "availableQuantity": 5000,
    "reservedQuantity": 0,
    "averagePurchasePrice": 1.862,
    "totalCostBasis": 9308.24,
    "costPerShare": 1.862,
    "acquisitionMethod": "Purchase",
    "firstPurchaseDate": "2022-03-15",
    "lastPurchaseDate": "2022-03-15",
    "purchaseCount": 1,
    "holdingPeriod": {
      "daysHeld": 1435,
      "monthsHeld": 47,
      "yearsHeld": 3.93
    }
  },
  "transactions": [
    {
      "id": "txn-001",
      "transactionType": "Buy",
      "transactionDate": "2022-03-15",
      "quantity": 5000,
      "price": 1.85,
      "totalAmount": 9250.00,
      "currency": "GBP",
      "brokerCommission": 11.99,
      "stampDuty": 46.25,
      "otherFees": 0.00,
      "totalCosts": 58.24,
      "netAmount": 9308.24,
      "broker": "Hargreaves Lansdown",
      "orderType": "MarketOrder",
      "notes": "Initial purchase"
    }
  ],
  "currentMarketValue": {
    "currentPrice": 2.15,
    "priceDate": "2026-02-17T16:35:00Z",
    "priceTime": "16:35:00",
    "currency": "GBP",
    "priceSource": "LSE",
    "bidPrice": 2.145,
    "askPrice": 2.155,
    "spreadPercentage": 0.47,
    "dayOpen": 2.12,
    "dayHigh": 2.18,
    "dayLow": 2.11,
    "previousClose": 2.12,
    "priceChange": 0.03,
    "priceChangePercentage": 1.42,
    "volume": 45820000,
    "averageVolume30Day": 38500000,
    "totalMarketValue": 10750.00,
    "lastUpdated": "2026-02-17T16:35:00Z"
  },
  "unrealizedGainLoss": {
    "costBasis": 9308.24,
    "currentValue": 10750.00,
    "unrealizedGain": 1441.76,
    "unrealizedGainPercentage": 15.49,
    "gainPerShare": 0.288,
    "breakEvenPrice": 1.862,
    "currentPriceVsBreakEven": 15.47,
    "allTimeHigh": 2.89,
    "distanceFromATH": -25.61,
    "allTimeLow": 1.12,
    "distanceFromATL": 91.96
  },
  "ownership": {
    "clientId": "client-123",
    "ownerName": "John Smith",
    "accountType": "Individual",
    "holdingStructure": "DirectOwnership",
    "taxWrapper": "None",
    "brokerAccount": {
      "broker": "Hargreaves Lansdown",
      "accountNumber": "HL123456",
      "accountType": "StockAndSharesISA"
    },
    "certificateNumber": null,
    "certificated": false,
    "crest": true
  },
  "dividendInformation": {
    "dividendYield": 4.65,
    "annualDividend": 0.10,
    "dividendPerShare": 0.10,
    "dividendFrequency": "Quarterly",
    "dividendPaymentMonths": [3, 6, 9, 12],
    "lastDividend": {
      "amount": 0.025,
      "currency": "GBP",
      "exDividendDate": "2026-01-10",
      "recordDate": "2026-01-11",
      "paymentDate": "2026-01-15",
      "type": "Ordinary"
    },
    "nextDividend": {
      "estimatedAmount": 0.025,
      "estimatedExDividendDate": "2026-04-10",
      "estimatedPaymentDate": "2026-04-15"
    },
    "dividendHistory": [
      {
        "exDividendDate": "2026-01-10",
        "amount": 0.025,
        "type": "Ordinary",
        "totalReceived": 125.00
      },
      {
        "exDividendDate": "2025-10-10",
        "amount": 0.025,
        "type": "Ordinary",
        "totalReceived": 125.00
      },
      {
        "exDividendDate": "2025-07-10",
        "amount": 0.025,
        "type": "Ordinary",
        "totalReceived": 125.00
      },
      {
        "exDividendDate": "2025-04-10",
        "amount": 0.025,
        "type": "Ordinary",
        "totalReceived": 125.00
      }
    ],
    "totalDividendsReceived": 1475.00,
    "dividendCoverageRatio": 2.1,
    "dividendGrowthRate5Year": 3.5,
    "reinvestDividends": false,
    "dividendPaymentMethod": "BankTransfer"
  },
  "corporateActions": [
    {
      "id": "ca-001",
      "actionType": "Dividend",
      "actionDate": "2026-01-15",
      "exDate": "2026-01-10",
      "description": "Quarterly dividend payment £0.025 per share",
      "impactOnHolding": {
        "quantityBefore": 5000,
        "quantityAfter": 5000,
        "cashReceived": 125.00
      }
    },
    {
      "id": "ca-002",
      "actionType": "StockSplit",
      "actionDate": "2024-06-15",
      "exDate": "2024-06-14",
      "description": "1-for-2 stock consolidation (reverse split)",
      "splitRatio": "1:2",
      "impactOnHolding": {
        "quantityBefore": 10000,
        "quantityAfter": 5000,
        "priceBefore": 0.931,
        "priceAfter": 1.862
      },
      "notes": "Holding consolidated from 10,000 shares at £0.931 to 5,000 shares at £1.862"
    }
  ],
  "performance": {
    "sinceInception": {
      "return": 1441.76,
      "returnPercentage": 15.49,
      "annualizedReturn": 3.76,
      "daysHeld": 1435
    },
    "ytd": {
      "return": 125.00,
      "returnPercentage": 1.18,
      "priceReturn": 1.42,
      "dividendReturn": -0.24
    },
    "1day": {
      "return": 150.00,
      "returnPercentage": 1.42
    },
    "1week": {
      "return": 75.00,
      "returnPercentage": 0.70
    },
    "1month": {
      "return": 50.00,
      "returnPercentage": 0.47
    },
    "3months": {
      "return": 175.00,
      "returnPercentage": 1.66
    },
    "6months": {
      "return": 325.00,
      "returnPercentage": 3.12
    },
    "1year": {
      "return": 550.00,
      "returnPercentage": 5.39
    },
    "3years": {
      "return": 1225.00,
      "returnPercentage": 13.16,
      "annualizedReturn": 4.20
    },
    "allTime": {
      "return": 1441.76,
      "returnPercentage": 15.49,
      "annualizedReturn": 3.76
    }
  },
  "riskMetrics": {
    "beta": 1.25,
    "alpha": 0.15,
    "volatility30Day": 18.5,
    "volatility90Day": 21.2,
    "volatility1Year": 24.8,
    "sharpeRatio": 0.72,
    "sortinoRatio": 0.89,
    "maxDrawdown": -12.3,
    "maxDrawdownDate": "2024-08-15",
    "var95": -3.2,
    "cvar95": -4.8,
    "riskRating": "Medium-High",
    "correlationToFTSE100": 0.85,
    "correlationToSP500": 0.62
  },
  "section104Pooling": {
    "applicable": true,
    "pooledHolding": {
      "totalQuantity": 5000,
      "totalCost": 9308.24,
      "averageCostPerShare": 1.862
    },
    "sameDayRule": {
      "applicable": false,
      "matchedQuantity": 0
    },
    "bedAndBreakfastRule": {
      "applicable": false,
      "matchedQuantity": 0,
      "periodDays": 30
    },
    "notes": "Section 104 holding pool applies for UK CGT calculation"
  },
  "taxInformation": {
    "taxWrapper": "None",
    "taxableHolding": true,
    "cgtExemptionAvailable": true,
    "dividendTaxApplies": true,
    "dividendAllowance2025_26": 500.00,
    "holdingPeriodQualification": "LongTerm",
    "estimatedCGTLiability": {
      "unrealizedGain": 1441.76,
      "estimatedCGTBasicRate": 144.18,
      "estimatedCGTHigherRate": 288.35,
      "note": "Assumes full CGT allowance available (£12,300 for 2025/26)"
    }
  },
  "valuationMethod": "MarkToMarket",
  "benchmarkComparison": {
    "benchmark": "FTSE 100",
    "holdingReturn1Year": 5.39,
    "benchmarkReturn1Year": 4.85,
    "outperformance": 0.54,
    "holdingVolatility": 24.8,
    "benchmarkVolatility": 12.5,
    "riskAdjustedReturn": 0.22
  },
  "analystRatings": {
    "consensusRating": "Hold",
    "buyRatings": 5,
    "holdRatings": 12,
    "sellRatings": 2,
    "averageTargetPrice": 2.25,
    "targetPriceUpside": 4.65,
    "lastUpdated": "2026-02-10"
  },
  "notes": "Long-term holding in UK banking sector. Part of diversified portfolio strategy. Stock underwent 1:2 consolidation in June 2024.",
  "createdDate": "2026-02-17T10:00:00Z",
  "createdBy": {
    "id": "adv-789",
    "name": "Jane Adviser",
    "email": "jane.adviser@financialservices.com"
  },
  "lastModifiedDate": "2026-02-17T10:00:00Z",
  "lastModifiedBy": {
    "id": "adv-789",
    "name": "Jane Adviser",
    "email": "jane.adviser@financialservices.com"
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/equities/eq-789" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" },
    "dividends": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/dividends" },
    "add-dividend": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/dividends", "method": "POST" },
    "transactions": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/transactions" },
    "add-transaction": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/transactions", "method": "POST" },
    "performance": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/performance" },
    "capital-gains": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/capital-gains" },
    "corporate-actions": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/corporate-actions" },
    "add-corporate-action": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/corporate-actions", "method": "POST" },
    "market-data": { "href": "https://api.marketdata.com/quote/BARC.L" },
    "company-info": { "href": "https://home.barclays" },
    "update": { "href": "/api/v1/factfinds/ff-456/equities/eq-789", "method": "PUT" },
    "delete": { "href": "/api/v1/factfinds/ff-456/equities/eq-789", "method": "DELETE" }
  }
}
```

**HTTP Status Codes:**
- `200 OK` - Equity holding retrieved successfully
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Equity holding or FactFind not found

---

##### 9.5.2.4 Get Portfolio Performance

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/equities/portfolio-performance`

**Description:** Get comprehensive portfolio performance analysis including total returns, sector allocation, diversification metrics, and risk-adjusted returns.

**Query Parameters:**
- `period` - Performance period: 1D, 1W, 1M, 3M, 6M, 1Y, YTD, All
- `includeBenchmark` - Include benchmark comparison (default: true)
- `benchmark` - Benchmark index: FTSE100, SP500, NASDAQ, MSCIWORLD (default: FTSE100)

**Response:**

```json
{
  "factfindId": "ff-456",
  "portfolioName": "John Smith Equity Portfolio",
  "calculationDate": "2026-02-17T21:00:00Z",
  "totalInvestment": {
    "totalCostBasis": 71033.24,
    "costBasisGBP": 71033.24,
    "numberOfHoldings": 4,
    "firstInvestmentDate": "2022-03-15",
    "investmentPeriodDays": 1435,
    "investmentPeriodYears": 3.93
  },
  "currentValue": {
    "totalMarketValue": 88397.50,
    "totalMarketValueGBP": 74740.00,
    "lastUpdated": "2026-02-17T21:00:00Z"
  },
  "totalReturn": {
    "unrealizedGain": 3706.76,
    "unrealizedGainPercentage": 5.22,
    "realizedGain": 0.00,
    "totalGain": 3706.76,
    "totalGainPercentage": 5.22,
    "dividendsReceived": 4631.00,
    "totalReturn": 8337.76,
    "totalReturnPercentage": 11.74,
    "annualizedReturn": 2.85,
    "cumulativeReturn": 11.74
  },
  "performanceByPeriod": {
    "1day": {
      "return": 625.50,
      "returnPercentage": 0.84
    },
    "1week": {
      "return": 1125.00,
      "returnPercentage": 1.52
    },
    "1month": {
      "return": 875.00,
      "returnPercentage": 1.18
    },
    "3months": {
      "return": 1950.00,
      "returnPercentage": 2.67
    },
    "6months": {
      "return": 3150.00,
      "returnPercentage": 4.39
    },
    "ytd": {
      "return": 2875.00,
      "returnPercentage": 3.85
    },
    "1year": {
      "return": 8825.00,
      "returnPercentage": 12.45
    },
    "3years": {
      "return": 7850.00,
      "returnPercentage": 11.05,
      "annualizedReturn": 3.56
    },
    "sinceInception": {
      "return": 8337.76,
      "returnPercentage": 11.74,
      "annualizedReturn": 2.85
    }
  },
  "holdingPerformance": [
    {
      "ticker": "MSFT",
      "securityName": "Microsoft Corporation",
      "costBasis": 28500.00,
      "currentValue": 33240.00,
      "return": 10440.00,
      "returnPercentage": 45.79,
      "contributionToPortfolio": 44.5,
      "contributionToReturn": 125.3
    },
    {
      "ticker": "AAPL",
      "securityName": "Apple Inc.",
      "costBasis": 21825.00,
      "currentValue": 21390.00,
      "return": 3929.40,
      "returnPercentage": 22.51,
      "contributionToPortfolio": 28.6,
      "contributionToReturn": 47.1
    },
    {
      "ticker": "BARC.L",
      "securityName": "Barclays PLC",
      "costBasis": 9308.24,
      "currentValue": 10750.00,
      "return": 1441.76,
      "returnPercentage": 15.49,
      "contributionToPortfolio": 14.4,
      "contributionToReturn": 17.3
    },
    {
      "ticker": "VOD.L",
      "securityName": "Vodafone Group PLC",
      "costBasis": 11400.00,
      "currentValue": 9360.00,
      "return": -2040.00,
      "returnPercentage": -17.89,
      "contributionToPortfolio": 12.5,
      "contributionToReturn": -24.5
    }
  ],
  "sectorAllocation": {
    "sectors": [
      {
        "sector": "Technology",
        "value": 54630.00,
        "percentage": 73.1,
        "return": 14369.40,
        "returnPercentage": 35.7
      },
      {
        "sector": "Financials",
        "value": 10750.00,
        "percentage": 14.4,
        "return": 1441.76,
        "returnPercentage": 15.5
      },
      {
        "sector": "Telecommunications",
        "value": 9360.00,
        "percentage": 12.5,
        "return": -2040.00,
        "returnPercentage": -17.9
      }
    ],
    "topSector": "Technology",
    "mostDiversifiedSector": "Technology"
  },
  "geographicAllocation": {
    "regions": [
      {
        "country": "United States",
        "value": 54630.00,
        "percentage": 73.1,
        "holdings": 2
      },
      {
        "country": "United Kingdom",
        "value": 20110.00,
        "percentage": 26.9,
        "holdings": 2
      }
    ]
  },
  "currencyExposure": {
    "GBP": {
      "value": 31110.00,
      "percentage": 41.6,
      "unrealizedGain": 941.76
    },
    "USD": {
      "value": 43630.00,
      "valueGBP": 34890.00,
      "percentage": 58.4,
      "unrealizedGain": 14369.40,
      "currencyGainLoss": -3593.10,
      "exchangeRate": 1.25
    }
  },
  "dividendAnalysis": {
    "totalDividendsReceived": 4631.00,
    "averageYield": 3.40,
    "highestYield": {
      "ticker": "VOD.L",
      "yield": 7.69
    },
    "lowestYield": {
      "ticker": "AAPL",
      "yield": 0.52
    },
    "estimatedAnnualDividends": 1475.00,
    "dividendGrowthRate": 3.2
  },
  "riskMetrics": {
    "portfolioBeta": 1.12,
    "portfolioAlpha": 0.18,
    "volatility30Day": 16.8,
    "volatility1Year": 19.5,
    "sharpeRatio": 0.85,
    "sortinoRatio": 1.05,
    "maxDrawdown": -8.5,
    "maxDrawdownDate": "2024-08-15",
    "var95": -2.8,
    "cvar95": -4.2,
    "riskRating": "Medium"
  },
  "diversificationMetrics": {
    "numberOfHoldings": 4,
    "effectiveNumberOfHoldings": 2.3,
    "herfindahlIndex": 0.435,
    "concentrationRisk": "High",
    "topHoldingPercentage": 44.5,
    "top3HoldingsPercentage": 87.5,
    "top5HoldingsPercentage": 100.0,
    "sectorConcentration": {
      "topSector": "Technology",
      "topSectorPercentage": 73.1,
      "concentrationRisk": "High"
    },
    "geographicConcentration": {
      "topCountry": "United States",
      "topCountryPercentage": 73.1,
      "concentrationRisk": "High"
    },
    "diversificationScore": 42,
    "recommendation": "Portfolio concentration is high with 73% in technology stocks. Consider adding holdings in other sectors for better diversification."
  },
  "benchmarkComparison": {
    "benchmark": "FTSE 100",
    "benchmarkTicker": "^FTSE",
    "portfolioReturn1Year": 12.45,
    "benchmarkReturn1Year": 4.85,
    "outperformance": 7.60,
    "portfolioReturnYTD": 3.85,
    "benchmarkReturnYTD": 2.15,
    "outperformanceYTD": 1.70,
    "portfolioVolatility": 19.5,
    "benchmarkVolatility": 12.5,
    "excessVolatility": 7.0,
    "informationRatio": 0.62,
    "trackingError": 12.2,
    "riskAdjustedReturn": {
      "portfolioSharpeRatio": 0.85,
      "benchmarkSharpeRatio": 0.52,
      "riskAdjustedOutperformance": 0.33
    }
  },
  "taxSummary": {
    "unrealizedCapitalGains": 3706.76,
    "estimatedCGTLiability": {
      "basicRate": 370.68,
      "higherRate": 741.35
    },
    "dividendsReceived": 4631.00,
    "estimatedDividendTax": {
      "basicRate": 347.33,
      "higherRate": 1073.65
    },
    "totalEstimatedTaxLiability": {
      "basicRate": 718.01,
      "higherRate": 1815.00
    },
    "note": "Tax estimates assume full allowances available"
  },
  "recommendations": [
    {
      "priority": "High",
      "recommendation": "Reduce concentration in technology sector",
      "rationale": "73% of portfolio in technology creates significant sector risk. Consider rebalancing to include healthcare, consumer goods, or energy sectors.",
      "potentialAction": "Sell 25% of MSFT or AAPL holdings and reinvest in other sectors"
    },
    {
      "priority": "High",
      "recommendation": "Diversify geographic exposure",
      "rationale": "73% US exposure creates currency and geographic risk. Consider increasing UK or European holdings.",
      "potentialAction": "Add FTSE 100 or European blue-chip stocks"
    },
    {
      "priority": "Medium",
      "recommendation": "Review Vodafone holding",
      "rationale": "VOD.L has underperformed with -17.89% loss. Consider whether to hold or reallocate capital.",
      "potentialAction": "Assess turnaround prospects or crystallize loss for tax relief"
    },
    {
      "priority": "Low",
      "recommendation": "Consider dividend growth stocks",
      "rationale": "Low average yield of 3.4%. Consider adding higher-yielding dividend growth stocks for income.",
      "potentialAction": "Research FTSE 100 dividend aristocrats"
    }
  ],
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/equities/portfolio-performance" },
    "holdings": { "href": "/api/v1/factfinds/ff-456/equities" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" },
    "rebalancing-suggestions": { "href": "/api/v1/factfinds/ff-456/equities/rebalancing" }
  }
}
```

**HTTP Status Codes:**
- `200 OK` - Portfolio performance retrieved successfully
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - FactFind not found

---

##### 9.5.2.5 Record Dividend

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/equities/{id}/dividends`

**Description:** Record a dividend payment received from an equity holding.

**Request Body:**

```json
{
  "dividendType": "Ordinary",
  "amountPerShare": 0.025,
  "currency": "GBP",
  "exDividendDate": "2026-02-10",
  "recordDate": "2026-02-11",
  "paymentDate": "2026-02-15",
  "quantity": 5000,
  "totalDividend": 125.00,
  "taxWithheld": 0.00,
  "netDividendReceived": 125.00,
  "reinvested": false,
  "notes": "Q1 2026 dividend payment"
}
```

**Dividend Type Values:**
- `Ordinary` - Regular dividend
- `Special` - Special/one-time dividend
- `Interim` - Interim dividend
- `Final` - Final dividend
- `Scrip` - Stock dividend

**Response:**

```http
HTTP/1.1 201 Created
```

```json
{
  "id": "div-456",
  "equityId": "eq-789",
  "ticker": "BARC.L",
  "dividendType": "Ordinary",
  "amountPerShare": 0.025,
  "currency": "GBP",
  "exDividendDate": "2026-02-10",
  "recordDate": "2026-02-11",
  "paymentDate": "2026-02-15",
  "quantity": 5000,
  "totalDividend": 125.00,
  "taxWithheld": 0.00,
  "netDividendReceived": 125.00,
  "reinvested": false,
  "cumulativeDividends": 1600.00,
  "notes": "Q1 2026 dividend payment",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/dividends/div-456" },
    "equity": { "href": "/api/v1/factfinds/ff-456/equities/eq-789" },
    "dividend-history": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/dividends" }
  }
}
```

**HTTP Status Codes:**
- `201 Created` - Dividend recorded successfully
- `400 Bad Request` - Invalid request data
- `422 Unprocessable Entity` - Validation failed

---

##### 9.5.2.6 Calculate Capital Gains

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/equities/{id}/capital-gains`

**Description:** Calculate capital gains tax liability using Section 104 pooling rules for UK shares or FIFO/Average Cost methods for other jurisdictions.

**Query Parameters:**
- `disposalQuantity` - Number of shares to dispose (required)
- `disposalPrice` - Price per share for disposal (default: current market price)
- `disposalDate` - Date of disposal (default: today)
- `disposalCosts` - Transaction costs (default: 0.1% of proceeds)

**Response:**

```json
{
  "equityId": "eq-789",
  "ticker": "BARC.L",
  "securityName": "Barclays PLC",
  "calculationDate": "2026-02-17T21:00:00Z",
  "taxYear": "2025/26",
  "calculationMethod": "Section104Pooling",
  "disposal": {
    "quantity": 2000,
    "pricePerShare": 2.15,
    "disposalProceeds": 4300.00,
    "disposalDate": "2026-02-17",
    "brokerCommission": 11.99,
    "stampDuty": 0.00,
    "netProceeds": 4288.01
  },
  "acquisition": {
    "method": "Section104Pool",
    "pooledQuantity": 5000,
    "pooledCost": 9308.24,
    "averageCostPerShare": 1.862,
    "sharesDisposed": 2000,
    "costOfSharesDisposed": 3724.00,
    "remainingPoolQuantity": 3000,
    "remainingPoolCost": 5584.24
  },
  "gainCalculation": {
    "disposalProceeds": 4288.01,
    "allowableDeductions": 3735.99,
    "acquisitionCost": 3724.00,
    "disposalCosts": 11.99,
    "gain": 552.02
  },
  "taxCalculation": {
    "gain": 552.02,
    "annualExemption": 12300.00,
    "exemptionUsed": 552.02,
    "taxableGain": 0.00,
    "cgtLiability": 0.00,
    "note": "Gain fully covered by annual CGT exemption"
  },
  "remainingExemption": 11747.98,
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/equities/eq-789/capital-gains" },
    "equity": { "href": "/api/v1/factfinds/ff-456/equities/eq-789" }
  }
}
```

**HTTP Status Codes:**
- `200 OK` - Capital gains calculated successfully
- `400 Bad Request` - Invalid parameters
- `404 Not Found` - Equity holding not found

---

### 9.6 Credit History API

**Purpose:** Track credit score, payment history, and credit reports for comprehensive credit assessment and lending suitability analysis.

**Scope:**
- Credit score tracking from multiple agencies (Experian, Equifax, TransUnion)
- Credit score history and trend analysis
- Payment history monitoring (on-time, late, missed, defaults)
- Credit utilization metrics and monitoring
- Credit report integration and storage
- Credit inquiry tracking (hard and soft pulls)
- Derogatory marks tracking (defaults, CCJs, bankruptcies, IVAs)
- Credit age and mix analysis
- Credit health indicators and scoring
- Credit improvement recommendations
- Lending suitability assessment

**Aggregate Root:** FactFind (credit history is nested within client)

**Regulatory Compliance:**
- Consumer Credit Act 1974 (as amended)
- Data Protection Act 2018 - Credit data handling
- GDPR Article 22 - Automated decision-making
- FCA Handbook - Creditworthiness assessments
- ICO Credit Reference Agency Code of Practice

#### 9.6.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-scores` | Add credit score | `credit:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-scores` | Get credit score history | `credit:read` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-status` | Get current credit status | `credit:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/payment-history` | Record payment event | `credit:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/payment-history` | Get payment history | `credit:read` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-utilization` | Get credit utilization | `credit:read` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-health` | Get credit health indicators | `credit:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-report` | Request credit report | `credit:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-report` | Get latest credit report | `credit:read` |

#### 9.6.2 Key Endpoints

##### 9.6.2.1 Add Credit Score

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/credit-scores`

**Description:** Add a credit score record from a credit reference agency. Supports UK credit scoring systems (Experian 0-999, Equifax 0-700, TransUnion 0-710) and US FICO scoring (300-850).

**Request Body:**

```json
{
  "creditAgency": "Experian",
  "scoreValue": 785,
  "scoreDate": "2026-02-17",
  "scoreModel": "Experian Credit Score",
  "scoreRange": {
    "minimum": 0,
    "maximum": 999
  },
  "scoreBand": "Good",
  "creditReportReference": "EXP-2026-CR-123456789",
  "reportUrl": "https://secure-docs.factfind.com/credit-reports/exp-123456789.pdf",
  "factorsAffectingScore": [
    {
      "factor": "PaymentHistory",
      "impact": "Positive",
      "description": "100% of payments made on time in last 12 months"
    },
    {
      "factor": "CreditUtilization",
      "impact": "Positive",
      "description": "Credit utilization at 28% - below recommended 30% threshold"
    },
    {
      "factor": "CreditAge",
      "impact": "Positive",
      "description": "Average account age of 8.5 years demonstrates established credit history"
    },
    {
      "factor": "CreditInquiries",
      "impact": "Neutral",
      "description": "2 hard inquiries in last 12 months - within normal range"
    },
    {
      "factor": "DerogatoryMarks",
      "impact": "Positive",
      "description": "No defaults, CCJs, or bankruptcies on file"
    }
  ],
  "requestedBy": "adv-789",
  "requestDate": "2026-02-17",
  "consentObtained": true,
  "consentReference": "consent-456",
  "purpose": "MortgageApplication",
  "notes": "Credit check performed for mortgage application. Client aware and provided consent."
}
```

**Credit Agency Values:**
- `Experian` - Experian UK (score range 0-999)
- `Equifax` - Equifax UK (score range 0-700)
- `TransUnion` - TransUnion UK (score range 0-710)
- `FICO` - FICO Score USA (score range 300-850)
- `Experian_US` - Experian USA (score range 300-850)
- `Equifax_US` - Equifax USA (score range 300-850)

**Score Band Values (UK):**
- **Experian (0-999):**
  - VeryPoor: 0-560
  - Poor: 561-720
  - Fair: 721-880
  - Good: 881-960
  - Excellent: 961-999
- **Equifax (0-700):**
  - VeryPoor: 0-279
  - Poor: 280-379
  - Fair: 380-419
  - Good: 420-465
  - Excellent: 466-700
- **TransUnion (0-710):**
  - VeryPoor: 0-550
  - Poor: 551-565
  - Fair: 566-603
  - Good: 604-627
  - Excellent: 628-710

**Purpose Values:**
- `MortgageApplication` - Mortgage lending assessment
- `PersonalLoanApplication` - Personal loan assessment
- `CreditCardApplication` - Credit card application
- `FinancialReview` - Regular financial review
- `IdentityVerification` - Identity verification check

**Response:**

```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/ff-456/clients/client-123/credit-scores/cs-789
```

```json
{
  "id": "cs-789",
  "factfindId": "ff-456",
  "clientId": "client-123",
  "clientName": "John Smith",
  "creditAgency": "Experian",
  "scoreValue": 785,
  "scoreDate": "2026-02-17",
  "scoreModel": "Experian Credit Score",
  "scoreRange": {
    "minimum": 0,
    "maximum": 999
  },
  "scoreBand": "Good",
  "scoreBandRange": {
    "lower": 721,
    "upper": 880
  },
  "scorePercentile": 68,
  "scoreComparison": {
    "ukAverage": 759,
    "differenceFromAverage": 26,
    "betterThan": "68% of UK adults"
  },
  "creditReportReference": "EXP-2026-CR-123456789",
  "reportUrl": "https://secure-docs.factfind.com/credit-reports/exp-123456789.pdf",
  "factorsAffectingScore": [
    {
      "factor": "PaymentHistory",
      "impact": "Positive",
      "weight": 35,
      "score": 33,
      "description": "100% of payments made on time in last 12 months",
      "recommendation": "Continue making all payments on time"
    },
    {
      "factor": "CreditUtilization",
      "impact": "Positive",
      "weight": 30,
      "score": 27,
      "description": "Credit utilization at 28% - below recommended 30% threshold",
      "recommendation": "Maintain utilization below 30%"
    },
    {
      "factor": "CreditAge",
      "impact": "Positive",
      "weight": 15,
      "score": 13,
      "description": "Average account age of 8.5 years demonstrates established credit history",
      "recommendation": "Keep oldest accounts open"
    },
    {
      "factor": "CreditMix",
      "impact": "Neutral",
      "weight": 10,
      "score": 7,
      "description": "Good mix of credit types (mortgage, credit cards, personal loan)",
      "recommendation": "Diversified credit mix"
    },
    {
      "factor": "CreditInquiries",
      "impact": "Neutral",
      "weight": 10,
      "score": 8,
      "description": "2 hard inquiries in last 12 months - within normal range",
      "recommendation": "Limit credit applications to necessary only"
    }
  ],
  "scoreBreakdown": {
    "paymentHistory": 33,
    "creditUtilization": 27,
    "creditAge": 13,
    "creditMix": 7,
    "creditInquiries": 8,
    "totalScore": 88,
    "normalizedScore": 785
  },
  "changeFromPreviousScore": {
    "previousScore": 768,
    "previousDate": "2025-02-15",
    "scoreChange": 17,
    "scoreChangePercentage": 2.21,
    "direction": "Improved",
    "daysBetween": 367
  },
  "requestedBy": {
    "id": "adv-789",
    "name": "Jane Adviser"
  },
  "requestDate": "2026-02-17",
  "consentObtained": true,
  "consentReference": "consent-456",
  "purpose": "MortgageApplication",
  "notes": "Credit check performed for mortgage application. Client aware and provided consent.",
  "createdDate": "2026-02-17T10:00:00Z",
  "createdBy": {
    "id": "adv-789",
    "name": "Jane Adviser"
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/credit-scores/cs-789" },
    "client": { "href": "/api/v1/factfinds/ff-456/clients/client-123" },
    "credit-report": { "href": "https://secure-docs.factfind.com/credit-reports/exp-123456789.pdf" },
    "credit-history": { "href": "/api/v1/factfinds/ff-456/clients/client-123/credit-scores" },
    "credit-status": { "href": "/api/v1/factfinds/ff-456/clients/client-123/credit-status" }
  }
}
```

**Validation Rules:**
- Score value must be within agency's score range
- Score date cannot be in the future
- Consent must be obtained before requesting credit report
- Credit report reference required for formal credit checks
- Score band must match agency's banding system

**HTTP Status Codes:**
- `201 Created` - Credit score recorded successfully
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions or consent not obtained
- `404 Not Found` - Client or FactFind not found
- `422 Unprocessable Entity` - Validation failed

**Error Response Example:**

```json
{
  "type": "https://api.factfind.com/errors/validation-error",
  "title": "Credit Score Validation Failed",
  "status": 422,
  "detail": "Score value out of range for specified credit agency",
  "instance": "/api/v1/factfinds/ff-456/clients/client-123/credit-scores",
  "errors": [
    {
      "field": "scoreValue",
      "message": "Experian score must be between 0 and 999",
      "rejectedValue": 1050,
      "constraint": "scoreRange",
      "validRange": {
        "min": 0,
        "max": 999
      }
    }
  ]
}
```

---

---




## 9A. FactFind Savings & Investments API

### 9A.1 Overview

**Purpose:** Dedicated management of savings and investment products with specialized tracking, performance monitoring, and rebalancing capabilities.

**Scope:**
- ISA management (Stocks & Shares ISA, Cash ISA, Lifetime ISA, Innovative Finance ISA)
- General Investment Accounts (GIA, Platform Accounts, Discretionary Management)
- Offshore Bonds (Single Premium, Regular Premium)
- Onshore Bonds (Investment Bond, Guaranteed Bond)
- Investment Trusts (IT, OEIC, Unit Trust)
- Investment performance tracking and analysis
- Portfolio rebalancing recommendations
- Asset allocation monitoring and optimization
- Tax wrapper efficiency analysis
- Dividend and income tracking
- Fund holdings and transaction history
- Capital gains tracking and tax reporting

**Relationship to Arrangements API:**

Savings & Investments API provides specialized operations for investment products that are stored as Arrangements (Section 7). While Arrangements provide the core product data (policy numbers, providers, valuations), this API adds investment-specific capabilities like:
- Performance analysis across multiple time periods
- Asset allocation and rebalancing
- Tax-efficient investment strategies
- Portfolio consolidation and reporting

**Aggregate Root:** FactFind (investments are nested within)

**Regulatory Compliance:**
- FCA COBS (Product Governance and Suitability)
- MiFID II (Investment Services and Best Execution)
- PROD (Target Market Assessment)
- ISA Regulations 1998
- Offshore Funds (Tax) Regulations 2009
- Consumer Duty (Value Assessment and Fair Outcomes)

### 9A.2 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/investments` | List all investment products | `investments:read` |
| POST | `/api/v1/factfinds/{factfindId}/investments` | Create investment product | `investments:write` |
| GET | `/api/v1/factfinds/{factfindId}/investments/{investmentId}` | Get investment details | `investments:read` |
| PUT | `/api/v1/factfinds/{factfindId}/investments/{investmentId}` | Update investment | `investments:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/investments/{investmentId}` | Delete investment | `investments:write` |
| GET | `/api/v1/factfinds/{factfindId}/investments/summary` | Get portfolio summary | `investments:read` |
| GET | `/api/v1/factfinds/{factfindId}/investments/performance` | Get portfolio performance | `investments:read` |
| GET | `/api/v1/factfinds/{factfindId}/investments/asset-allocation` | Get asset allocation analysis | `investments:read` |
| POST | `/api/v1/factfinds/{factfindId}/investments/rebalance` | Generate rebalancing recommendations | `investments:write` |
| GET | `/api/v1/factfinds/{factfindId}/investments/tax-analysis` | Analyze tax wrapper efficiency | `investments:read` |

### 9A.3 Key Endpoints

#### 9A.3.1 List Investment Products

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/investments`

**Description:** List all investment products for a fact find with optional performance metrics.

**Query Parameters:**
- `investmentType` - Filter by type: ISA, GIA, OffshoreBond, OnshoreBond, InvestmentTrust
- `clientId` - Filter by client ID
- `providerId` - Filter by provider ID
- `includePerformance` - Include performance metrics (default: false)
- `asOfDate` - Performance as of date (ISO 8601 format)

**Response:**

```json
{
  "factfindId": "factfind-456",
  "asOfDate": "2026-02-17",
  "totalInvestments": 5,
  "totalValue": {
    "amount": 250000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "investments": [
    {
      "id": "inv-888",
      "arrangementId": "arr-777",
      "client": {
        "id": 123,
        "name": "John Smith"
      },
      "investmentType": "ISA",
      "isaType": "StocksAndSharesISA",
      "productName": "Vanguard ISA",
      "provider": {
        "id": 500,
        "name": "Vanguard"
      },
      "policyNumber": "ISA-98765432",
      "currentValue": {
        "amount": 45000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "valuationDate": "2026-02-16",
      "performance": {
        "oneYearReturn": 8.5,
        "threeYearReturn": 12.3,
        "fiveYearReturn": 45.2,
        "sinceInception": 67.8
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/{factfindId}/investments/inv-888" },
        "arrangement": { "href": "/api/v1/factfinds/{factfindId}/arrangements/arr-777" }
      }
    },
    {
      "id": "inv-889",
      "arrangementId": "arr-778",
      "client": {
        "id": 123,
        "name": "John Smith"
      },
      "investmentType": "GIA",
      "productName": "ABC General Investment Account",
      "provider": {
        "id": 501,
        "name": "ABC Wealth Management"
      },
      "policyNumber": "GIA-12345678",
      "currentValue": {
        "amount": 125000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "valuationDate": "2026-02-16",
      "performance": {
        "oneYearReturn": 10.2,
        "threeYearReturn": 15.6,
        "fiveYearReturn": 52.8,
        "sinceInception": 85.4
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/{factfindId}/investments/inv-889" },
        "arrangement": { "href": "/api/v1/factfinds/{factfindId}/arrangements/arr-778" }
      }
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 5,
    "totalPages": 1
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/{factfindId}/investments" },
    "create": { "href": "/api/v1/factfinds/{factfindId}/investments", "method": "POST" },
    "summary": { "href": "/api/v1/factfinds/{factfindId}/investments/summary" },
    "performance": { "href": "/api/v1/factfinds/{factfindId}/investments/performance" },
    "asset-allocation": { "href": "/api/v1/factfinds/{factfindId}/investments/asset-allocation" },
    "rebalance": { "href": "/api/v1/factfinds/{factfindId}/investments/rebalance", "method": "POST" }
  }
}
```

**Investment Types:**
- `ISA` - Individual Savings Account
  - `StocksAndSharesISA` - Stocks & Shares ISA
  - `CashISA` - Cash ISA
  - `LifetimeISA` - Lifetime ISA (LISA)
  - `InnovativeFinanceISA` - Innovative Finance ISA
- `GIA` - General Investment Account
- `OffshoreBond` - Offshore Investment Bond
- `OnshoreBond` - Onshore Investment Bond
- `InvestmentTrust` - Investment Trust, OEIC, Unit Trust
- `PlatformAccount` - Investment Platform Account
- `DiscretionaryManaged` - Discretionary Managed Portfolio

**Validation Rules:**
- `investmentType` filter must match valid investment types
- `asOfDate` must be valid ISO 8601 date format
- `includePerformance=true` requires performance data to be available

#### 9A.3.2 Get Portfolio Summary

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/investments/summary`

**Description:** Get aggregated portfolio summary across all investments.

**Response:**

```json
{
  "factfindId": "factfind-456",
  "asOfDate": "2026-02-17",
  "totalPortfolioValue": {
    "amount": 250000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "investmentBreakdown": {
    "isa": {
      "count": 2,
      "value": {
        "amount": 75000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "percentage": 30.0
    },
    "gia": {
      "count": 2,
      "value": {
        "amount": 125000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "percentage": 50.0
    },
    "offshoreBond": {
      "count": 1,
      "value": {
        "amount": 50000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "percentage": 20.0
    }
  },
  "assetAllocation": {
    "equities": 60.0,
    "bonds": 25.0,
    "cash": 10.0,
    "alternatives": 5.0
  },
  "taxWrapperEfficiency": {
    "isaUtilization": 37.5,
    "availableIsaAllowance": {
      "amount": 10000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "taxEfficientPercentage": 30.0
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/{factfindId}/investments/summary" },
    "investments": { "href": "/api/v1/factfinds/{factfindId}/investments" },
    "performance": { "href": "/api/v1/factfinds/{factfindId}/investments/performance" }
  }
}
```

**Note:** For complete specifications of performance tracking (9A.3.3), asset allocation analysis (9A.3.4), and rebalancing recommendations (9A.3.5), these endpoints provide:
- Multi-period performance analysis (1M, 3M, 6M, 1Y, 3Y, 5Y, Since Inception)
- Asset allocation drift monitoring and rebalancing threshold alerts
- Tax-efficient rebalancing strategies prioritizing ISA wrappers
- Transaction cost and capital gains tax impact analysis
- Alternative rebalancing strategies (minimize transactions, minimize costs, tax-efficient)

---

## 10. FactFind Risk Profile API

### 10.1 Overview

**Purpose:** Capture and manage client Attitude to Risk (ATR) assessment as an embedded part of the FactFind.

**Key Changes in v2.1:**
- **ATR is now embedded in the FactFind entity** - No more separate template management API
- **Templates are reference data** - Risk questionnaire templates are system configuration, not managed via API
- **Simplified assessment flow** - Submit, view, and choose risk profiles directly on the fact find
- **Historical tracking** - Risk Replay mechanism for viewing past assessments and comparing changes

**Key Concepts:**

The ATR Assessment is a critical component of the FactFind that captures:
1. **15 Standard ATR Questions** - Time horizon, risk tolerance, investment experience, etc.
2. **45 Supplementary Questions** - Additional context (dependents, will status, emergency funds, etc.)
3. **Risk Profile Generation** - System generates 3 adjacent risk profiles based on scores
4. **Client Choice** - Client chooses their preferred profile from the 3 options
5. **Capacity for Loss Assessment** - Adviser assesses financial capacity to sustain losses
6. **Declarations** - Client and adviser declarations confirming assessment accuracy and suitability

**Aggregate Root:** FactFind (ATR is part of the FactFind lifecycle)

**Regulatory Compliance:**
- FCA COBS 9.2 (Assessing Suitability - Risk Assessment)
- MiFID II Article 25 (Assessment of Suitability and Appropriateness)
- ESMA Guidelines on Suitability Assessment
- FCA Handbook COBS 9 Annex 2 (Risk Profiling)
- Consumer Duty (Understanding Customer Risk Tolerance)

### 10.2 Operations Summary

**ATR Assessment Endpoints:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/atr-assessment` | Get current ATR assessment | `factfind:read` |
| PUT | `/api/v1/factfinds/{factfindId}/atr-assessment` | Submit/update ATR assessment | `factfind:write` |
| POST | `/api/v1/factfinds/{factfindId}/atr-assessment/choose-profile` | Choose risk profile from options | `factfind:write` |
| GET | `/api/v1/factfinds/{factfindId}/atr-assessment/history` | Get ATR history (Risk Replay) | `factfind:read` |
| GET | `/api/v1/factfinds/{factfindId}/atr-assessment/history/{assessmentId}` | Get specific historical assessment | `factfind:read` |
| GET | `/api/v1/factfinds/{factfindId}/atr-assessment/compare` | Compare two assessments | `factfind:read` |

**Reference Data Endpoints:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/reference/atr-templates` | List available ATR templates | Public |
| GET | `/api/v1/reference/atr-templates/{templateId}` | Get template details | Public |

### 10.3 Key Endpoints

#### 10.3.1 Get Current ATR Assessment

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/atr-assessment`

**Description:** Retrieves the current ATR assessment for a fact find, including all questions, answers, risk profiles, and declarations.

**Path Parameters:**
- `factfindId` (required) - The fact find identifier

**Response:**

```json
{
  "atrAssessment": {
    "templateRef": {
      "id": "atr-template-v5",
      "version": "5.0",
      "name": "FCA Standard ATR 2025",
      "regulatoryApprovalDate": "2025-01-01"
    },
    "assessmentDate": "2026-02-18T10:30:00Z",
    "assessedBy": {
      "id": "adviser-789",
      "name": "Jane Doe"
    },
    "questions": [
      {
        "questionId": "Q1",
        "questionText": "How long do you plan to invest for?",
        "questionType": "SingleChoice",
        "answer": {
          "answerId": "A1-3",
          "answerText": "10-15 years",
          "score": 5
        }
      },
      {
        "questionId": "Q2",
        "questionText": "What is your attitude to investment risk?",
        "questionType": "Slider",
        "answer": {
          "value": 7,
          "minLabel": "Very Cautious",
          "maxLabel": "Very Adventurous",
          "score": 7
        }
      }
    ],
    "supplementaryQuestions": [
      {
        "category": "Risk",
        "questionId": "SQ-R1",
        "questionText": "Number of financial dependants",
        "answer": {
          "answerType": "Number",
          "value": 2
        }
      },
      {
        "category": "General",
        "questionId": "SQ-G1",
        "questionText": "Do you have a valid Will?",
        "answer": {
          "answerType": "Boolean",
          "value": true
        }
      }
    ],
    "riskProfiles": {
      "generated": [
        {
          "riskRating": "Balanced",
          "riskScore": 45,
          "scoreRange": "40-50",
          "description": "You have a balanced attitude to risk...",
          "assetAllocation": {
            "equities": 60,
            "bonds": 30,
            "cash": 5,
            "alternatives": 5
          },
          "volatilityTolerance": "Medium",
          "timePeriod": "10-15 years",
          "potentialLossAcceptance": "10-15%"
        },
        {
          "riskRating": "Cautious",
          "riskScore": 35,
          "scoreRange": "30-40",
          "description": "Adjacent lower risk option...",
          "assetAllocation": {
            "equities": 40,
            "bonds": 45,
            "cash": 10,
            "alternatives": 5
          }
        },
        {
          "riskRating": "Adventurous",
          "riskScore": 55,
          "scoreRange": "50-60",
          "description": "Adjacent higher risk option...",
          "assetAllocation": {
            "equities": 75,
            "bonds": 15,
            "cash": 5,
            "alternatives": 5
          }
        }
      ],
      "chosen": {
        "riskRating": "Balanced",
        "riskScore": 45,
        "chosenBy": "Client",
        "chosenDate": "2026-02-18T11:00:00Z",
        "reasonForChoice": "Matches my investment goals and risk tolerance",
        "adviserNotes": "Client comfortable with balanced approach, discussed volatility expectations"
      }
    },
    "totalScore": 67,
    "maxScore": 100,
    "capacityForLoss": {
      "canAffordLosses": true,
      "emergencyFundMonths": 6,
      "essentialExpensesCovered": true,
      "dependantsProvisionAdequate": true,
      "assessmentNotes": "Client has sufficient emergency fund and no debt"
    },
    "declarations": {
      "clientDeclaration": {
        "declarationType": "ATR_Accuracy",
        "declarationText": "I confirm that the answers I have provided...",
        "signed": true,
        "signedDate": "2026-02-18T11:05:00Z",
        "signatureType": "Electronic",
        "ipAddress": "192.168.1.100"
      },
      "adviserDeclaration": {
        "declarationType": "ATR_Suitable",
        "declarationText": "I confirm that the risk profile assessment...",
        "signed": true,
        "signedDate": "2026-02-18T11:10:00Z",
        "signedBy": {
          "id": "adviser-789",
          "name": "Jane Doe"
        }
      }
    },
    "completedAt": "2026-02-18T11:10:00Z",
    "reviewDate": "2027-02-18"
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-123/atr-assessment" },
    "factfind": { "href": "/api/v1/factfinds/factfind-123" },
    "history": { "href": "/api/v1/factfinds/factfind-123/atr-assessment/history" },
    "chooseProfile": { "href": "/api/v1/factfinds/factfind-123/atr-assessment/choose-profile", "method": "POST" }
  }
}
```

**Status Codes:**
- `200 OK` - ATR assessment retrieved successfully
- `404 Not Found` - Fact find not found or no ATR assessment exists
- `403 Forbidden` - User lacks permission to view this fact find

---

#### 10.3.2 Submit/Update ATR Assessment

**Endpoint:** `PUT /api/v1/factfinds/{factfindId}/atr-assessment`

**Description:** Submit or update the ATR assessment for a fact find. This includes all 15 standard questions, 45 supplementary questions, and capacity for loss assessment.

**Path Parameters:**
- `factfindId` (required) - The fact find identifier

**Request Body:**

```json
{
  "templateRef": {
    "id": "atr-template-v5",
    "version": "5.0"
  },
  "questions": [
    {
      "questionId": "Q1",
      "answer": {
        "answerId": "A1-3",
        "score": 5
      }
    }
  ],
  "supplementaryQuestions": [
    {
      "questionId": "SQ-R1",
      "answer": {
        "answerType": "Number",
        "value": 2
      }
    }
  ],
  "capacityForLoss": {
    "canAffordLosses": true,
    "emergencyFundMonths": 6,
    "essentialExpensesCovered": true,
    "dependantsProvisionAdequate": true,
    "assessmentNotes": "Client has sufficient emergency fund and no debt"
  },
  "declarations": {
    "clientDeclaration": {
      "declarationType": "ATR_Accuracy",
      "signed": true,
      "signatureType": "Electronic",
      "ipAddress": "192.168.1.100"
    },
    "adviserDeclaration": {
      "declarationType": "ATR_Suitable",
      "signed": true
    }
  }
}
```

**Response:**

```json
{
  "atrAssessment": {
    // ... full assessment with generated risk profiles
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-123/atr-assessment" },
    "factfind": { "href": "/api/v1/factfinds/factfind-123" },
    "chooseProfile": { "href": "/api/v1/factfinds/factfind-123/atr-assessment/choose-profile", "method": "POST" }
  }
}
```

**Status Codes:**
- `200 OK` - ATR assessment updated successfully
- `201 Created` - ATR assessment created for the first time
- `400 Bad Request` - Invalid request (missing required questions, invalid scores)
- `404 Not Found` - Fact find not found
- `403 Forbidden` - User lacks permission to update this fact find

**Business Rules:**
1. All 15 standard questions must be answered
2. Supplementary questions are optional but recommended
3. System automatically generates 3 adjacent risk profiles based on total score
4. Capacity for loss must be assessed before finalizing
5. Both client and adviser declarations required for completion

---

#### 10.3.3 Choose Risk Profile

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/atr-assessment/choose-profile`

**Description:** Client chooses their preferred risk profile from the 3 generated options (main, lower, higher).

**Path Parameters:**
- `factfindId` (required) - The fact find identifier

**Request Body:**

```json
{
  "riskRating": "Balanced",
  "riskScore": 45,
  "chosenBy": "Client",
  "reasonForChoice": "Matches my investment goals and risk tolerance",
  "adviserNotes": "Client comfortable with balanced approach, discussed volatility expectations"
}
```

**Response:**

```json
{
  "atrAssessment": {
    // ... full assessment with chosen profile updated
    "riskProfiles": {
      "generated": [ /* ... */ ],
      "chosen": {
        "riskRating": "Balanced",
        "riskScore": 45,
        "chosenBy": "Client",
        "chosenDate": "2026-02-18T11:00:00Z",
        "reasonForChoice": "Matches my investment goals and risk tolerance",
        "adviserNotes": "Client comfortable with balanced approach"
      }
    }
  }
}
```

**Status Codes:**
- `200 OK` - Risk profile chosen successfully
- `400 Bad Request` - Invalid risk profile (not one of the 3 generated options)
- `404 Not Found` - Fact find or ATR assessment not found
- `403 Forbidden` - User lacks permission

---

#### 10.3.4 Get ATR Assessment History (Risk Replay)

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/atr-assessment/history`

**Description:** Retrieve historical ATR assessments for a fact find. Supports "Risk Replay" - the ability to review how a client's risk profile has changed over time.

**Path Parameters:**
- `factfindId` (required) - The fact find identifier

**Query Parameters:**
- `fromDate` (optional) - Filter from date (ISO 8601)
- `toDate` (optional) - Filter to date (ISO 8601)
- `sortOrder` (optional) - `asc` or `desc` (default: desc - newest first)

**Response:**

```json
{
  "assessments": [
    {
      "assessmentId": "atr-20260218-001",
      "assessmentDate": "2026-02-18T10:30:00Z",
      "templateVersion": "5.0",
      "totalScore": 67,
      "chosenRiskRating": "Balanced",
      "chosenRiskScore": 45,
      "assessedBy": {
        "id": "adviser-789",
        "name": "Jane Doe"
      },
      "changeFromPrevious": {
        "scoreDifference": +5,
        "riskRatingChange": "Increased",
        "significantChange": false
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/factfind-123/atr-assessment/history/atr-20260218-001" },
        "fullDetails": { "href": "/api/v1/factfinds/factfind-123/atr-assessment/history/atr-20260218-001" }
      }
    },
    {
      "assessmentId": "atr-20250215-001",
      "assessmentDate": "2025-02-15T14:20:00Z",
      "templateVersion": "4.0",
      "totalScore": 62,
      "chosenRiskRating": "Cautious",
      "chosenRiskScore": 40,
      "assessedBy": {
        "id": "adviser-789",
        "name": "Jane Doe"
      },
      "changeFromPrevious": null,
      "_links": {
        "self": { "href": "/api/v1/factfinds/factfind-123/atr-assessment/history/atr-20250215-001" }
      }
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 2,
    "totalPages": 1
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-123/atr-assessment/history" },
    "factfind": { "href": "/api/v1/factfinds/factfind-123" },
    "compare": { "href": "/api/v1/factfinds/factfind-123/atr-assessment/compare?from={assessmentId1}&to={assessmentId2}" }
  }
}
```

**Status Codes:**
- `200 OK` - History retrieved successfully
- `404 Not Found` - Fact find not found
- `403 Forbidden` - User lacks permission

**Use Cases:**
1. **Annual Review** - Compare current assessment with previous year
2. **Life Event Tracking** - See how major events (retirement, inheritance) changed risk profile
3. **Regulatory Audit** - Demonstrate appropriate risk profiling over time
4. **Suitability Documentation** - Evidence that risk profile was reassessed appropriately

---

### 10.4 ATR Templates Reference Data

**Purpose:** ATR questionnaire templates are system configuration and reference data. They are not managed via the main API but can be queried to see available templates.

**Key Points:**
- Templates are managed by system administrators, not via public API
- No create, update, delete operations for templates
- Templates include the full questionnaire structure, scoring algorithms, and risk rating categories
- Multiple template versions can exist but only one is "active" at any time

#### 10.4.1 List Available ATR Templates

**Endpoint:** `GET /api/v1/reference/atr-templates`

**Description:** List available ATR questionnaire templates with metadata.

**Response:**

```json
{
  "templates": [
    {
      "id": "atr-template-v5",
      "version": "5.0",
      "name": "FCA Standard ATR 2025",
      "description": "Updated 15-question ATR with enhanced capacity for loss assessment",
      "status": "Active",
      "regulatoryApprovalDate": "2025-01-01",
      "questionCount": 15,
      "supplementaryQuestionCount": 45,
      "estimatedCompletionTime": 12,
      "riskRatingCategories": [
        "VeryLowRisk",
        "LowRisk",
        "Cautious",
        "Balanced",
        "Adventurous",
        "HighRisk",
        "VeryHighRisk"
      ]
    },
    {
      "id": "atr-template-v4",
      "version": "4.0",
      "name": "FCA Standard ATR 2024",
      "description": "Previous version - still valid for existing assessments",
      "status": "Archived",
      "regulatoryApprovalDate": "2024-01-01",
      "questionCount": 12,
      "supplementaryQuestionCount": 40,
      "estimatedCompletionTime": 10,
      "riskRatingCategories": [
        "VeryLowRisk",
        "LowRisk",
        "MediumRisk",
        "HighRisk",
        "VeryHighRisk"
      ]
    }
  ]
}
```

---

#### 10.4.2 Get ATR Template Details

**Endpoint:** `GET /api/v1/reference/atr-templates/{templateId}`

**Description:** Get full details of an ATR template including all questions, answer options, and scoring.

**Path Parameters:**
- `templateId` (required) - The template identifier

**Response:**

```json
{
  "id": "atr-template-v5",
  "version": "5.0",
  "name": "FCA Standard ATR 2025",
  "description": "Updated 15-question ATR with enhanced capacity for loss assessment",
  "status": "Active",
  "regulatoryApprovalDate": "2025-01-01",
  "questionCount": 15,
  "questions": [
    {
      "questionId": "Q1",
      "questionNumber": 1,
      "questionText": "How long do you plan to invest for?",
      "questionType": "SingleChoice",
      "required": true,
      "weight": 1.2,
      "answers": [
        {
          "answerId": "A1-1",
          "answerText": "Less than 3 years",
          "score": 1
        },
        {
          "answerId": "A1-2",
          "answerText": "3-5 years",
          "score": 3
        },
        {
          "answerId": "A1-3",
          "answerText": "10-15 years",
          "score": 5
        },
        {
          "answerId": "A1-4",
          "answerText": "More than 15 years",
          "score": 7
        }
      ]
    }
  ],
  "supplementaryQuestions": [
    {
      "category": "Risk",
      "questionId": "SQ-R1",
      "questionText": "Number of financial dependants",
      "answerType": "Number",
      "required": false
    },
    {
      "category": "General",
      "questionId": "SQ-G1",
      "questionText": "Do you have a valid Will?",
      "answerType": "Boolean",
      "required": false
    }
  ],
  "scoringAlgorithm": {
    "method": "WeightedAverage",
    "maxScore": 100,
    "riskBands": [
      {
        "riskRating": "VeryLowRisk",
        "scoreRange": { "min": 0, "max": 20 },
        "assetAllocation": { "equities": 10, "bonds": 70, "cash": 20, "alternatives": 0 }
      },
      {
        "riskRating": "LowRisk",
        "scoreRange": { "min": 21, "max": 30 },
        "assetAllocation": { "equities": 25, "bonds": 60, "cash": 10, "alternatives": 5 }
      },
      {
        "riskRating": "Cautious",
        "scoreRange": { "min": 31, "max": 40 },
        "assetAllocation": { "equities": 40, "bonds": 45, "cash": 10, "alternatives": 5 }
      },
      {
        "riskRating": "Balanced",
        "scoreRange": { "min": 41, "max": 50 },
        "assetAllocation": { "equities": 60, "bonds": 30, "cash": 5, "alternatives": 5 }
      },
      {
        "riskRating": "Adventurous",
        "scoreRange": { "min": 51, "max": 60 },
        "assetAllocation": { "equities": 75, "bonds": 15, "cash": 5, "alternatives": 5 }
      },
      {
        "riskRating": "HighRisk",
        "scoreRange": { "min": 61, "max": 80 },
        "assetAllocation": { "equities": 85, "bonds": 5, "cash": 5, "alternatives": 5 }
      },
      {
        "riskRating": "VeryHighRisk",
        "scoreRange": { "min": 81, "max": 100 },
        "assetAllocation": { "equities": 95, "bonds": 0, "cash": 0, "alternatives": 5 }
      }
    ]
  }
}
```

---

### 10.5 Risk Assessment History API

**Purpose:** Historical tracking and comparison of ATR assessments over time (Risk Replay).

**Key Capabilities:**
- View all historical assessments for a fact find
- Compare two assessments side-by-side
- Track risk profile changes over time
- Regulatory audit trail

See Section 10.3.4 for the main history endpoint.

#### 10.5.1 Compare Two Assessments

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/atr-assessment/compare`

**Description:** Compare two ATR assessments to see what changed.

**Path Parameters:**
- `factfindId` (required) - The fact find identifier

**Query Parameters:**
- `from` (required) - First assessment ID
- `to` (required) - Second assessment ID

**Response:**

```json
{
  "comparison": {
    "fromAssessment": {
      "assessmentId": "atr-20250215-001",
      "assessmentDate": "2025-02-15T14:20:00Z",
      "totalScore": 62,
      "chosenRiskRating": "Cautious",
      "chosenRiskScore": 40
    },
    "toAssessment": {
      "assessmentId": "atr-20260218-001",
      "assessmentDate": "2026-02-18T10:30:00Z",
      "totalScore": 67,
      "chosenRiskRating": "Balanced",
      "chosenRiskScore": 45
    },
    "changes": {
      "scoreDifference": +5,
      "riskRatingChange": "Increased from Cautious to Balanced",
      "significantChange": true,
      "changedQuestions": [
        {
          "questionId": "Q3",
          "questionText": "How would you react to a 20% fall in your investment value?",
          "previousAnswer": "Sell immediately",
          "newAnswer": "Hold and wait for recovery",
          "scoreDifference": +2
        }
      ],
      "capacityForLossChange": {
        "previous": {
          "canAffordLosses": false,
          "emergencyFundMonths": 3
        },
        "current": {
          "canAffordLosses": true,
          "emergencyFundMonths": 6
        },
        "improved": true
      }
    }
  }
}
```

**Status Codes:**
- `200 OK` - Comparison retrieved successfully
- `400 Bad Request` - Invalid assessment IDs
- `404 Not Found` - One or both assessments not found
- `403 Forbidden` - User lacks permission

---

### 10.6 Integration with FactFind Workflow

**ATR Assessment Lifecycle:**

1. **Initiate FactFind** - Create fact find with client details
2. **Gather Circumstances** - Income, expenditure, arrangements, goals
3. **Conduct ATR Assessment** - Submit 15 questions + supplementary questions
4. **System Generates Profiles** - 3 adjacent risk profiles created automatically
5. **Client Chooses Profile** - Client selects preferred profile with adviser guidance
6. **Capacity for Loss** - Adviser assesses financial capacity
7. **Declarations** - Both parties sign off
8. **Complete FactFind** - ATR assessment is now part of the completed fact find

**Key Integration Points:**

- ATR assessment embedded in FactFind Contract (Section 13.2)
- No separate ATR entity - it's a complex value type on FactFind
- History maintained automatically when ATR is updated
- Risk profile influences product recommendations

**Business Rules:**

1. **ATR Required for Completion** - FactFind cannot be marked complete without ATR assessment
2. **Annual Review** - ATR should be reviewed annually or after life events
3. **Capacity vs. Tolerance** - Both must align; if capacity is lower, use capacity-based profile
4. **Three Options Rule** - Always present 3 adjacent profiles (main, +1 band, -1 band)
5. **Regulatory Documentation** - All assessments preserved for audit trail

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
  "financialProfile": {
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
    "calculatedAt": "2026-02-18T10:30:00Z",
    "lastReviewDate": "2026-02-18"
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
| `financialProfile` | FinancialProfileValue | optional | updatable (partial for computed fields) | included | Value type: Financial snapshot and computed wealth metrics |
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
  "financialProfile": {
    "grossAnnualIncome": {
      "amount": 85000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
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
  "financialProfile": {
    "householdIncome": {
      "amount": 145000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
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
  "financialProfile": {
    "grossAnnualIncome": {
      "amount": 75000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
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

The `Client` contract represents a client entity (Person, Corporate, or Trust) with all demographic, regulatory, and preference information using a **composition pattern** with conditional types.

**Reference Type:** Client is a reference type with identity (has `id` field).

**Composition Pattern Architecture:**
- **TClient** table contains common fields and `clientType` discriminator
- **PersonValue**, **CorporateValue**, **TrustValue** are conditional embedded types based on `clientType`
- Person-specific fields only present when `clientType="Person"`
- Corporate-specific fields only present when `clientType="Corporate"`
- Trust-specific fields only present when `clientType="Trust"`

**Key Enhancements in v2.1:**
- **Composition Pattern** - Conditional value types based on client type discriminator
- **PersonValue** - Person-specific demographics (DOB, gender, marital status, health, occupation, vulnerabilities)
- **CorporateValue** - Corporate-specific details (company name, registration, directors, shareholders)
- **TrustValue** - Trust-specific information (trust name, type, settlor, trustees, beneficiaries)
- **TerritorialProfile** - Territorial status, residency, domicile, citizenship (all client types)
- **Addresses** - Full address history embedded as value types
- **Contacts** - All contact methods (email, phone, mobile, work, website) embedded
- **Identity Verification** - KYC, AML checks, MLR compliance embedded
- **Vulnerabilities** - Client vulnerabilities embedded in PersonValue (Person only, Consumer Duty)
- **Data Protection** - GDPR consent and privacy management embedded
- **Marketing Preferences** - Channel preferences and interests embedded
- **Estate Planning** - Will, LPA, gifts, trusts, IHT embedded (Person only)

---

#### 13.1.1 Person Client Example

**Person client** with full PersonValue embedded:

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
  "personValue": {
    "title": {
      "code": "MR",
      "display": "Mr"
    },
    "firstName": "John",
    "middleNames": "Michael Robert",
    "lastName": "Smith",
    "preferredName": "John",
    "fullName": "Mr John Michael Robert Smith",
    "salutation": "Mr Smith",
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
    "niNumber": "AB123456C",
    "smokingStatus": {
      "code": "NEVER",
      "display": "Never Smoked"
    },
    "healthMetrics": {
      "heightCm": 178.0,
      "weightKg": 82.5,
      "bmi": 26.04,
      "bmiCategory": "Overweight",
      "lastMeasured": "2026-01-15"
    },
    "occupation": "Senior Software Engineer",
    "occupationCode": {
      "code": "2136",
      "display": "Programmers and Software Development Professionals",
      "socVersion": "SOC2020"
    },
    "employmentStatus": {
      "code": "FT_EMP",
      "display": "Full-Time Employed"
    },
    "isDeceased": false,
    "deceasedDate": null,
    "vulnerabilities": [
      {
        "vulnerabilityType": {
          "code": "HEALTH",
          "display": "Health-related"
        },
        "severity": "Medium",
        "description": "Requires large print documents due to visual impairment",
        "assessmentDate": "2020-01-15",
        "reviewDate": "2025-01-15",
        "adjustmentsRequired": [
          "Large print documents (16pt minimum)",
          "Extended appointment times (allow 90 minutes)",
          "Well-lit meeting rooms"
        ],
        "isActive": true,
        "recordedBy": {
          "id": "adviser-789",
          "name": "Jane Doe"
        }
      }
    ]
  },
  "territorialProfile": {
    "ukResident": true,
    "ukDomicile": true,
    "expatriate": false,
    "countryOfBirth": {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    },
    "placeOfBirth": "London",
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
    "countryOfOrigin": {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    },
    "countriesOfCitizenship": [
      {
        "country": {
          "code": "GB",
          "display": "United Kingdom",
          "alpha3": "GBR"
        },
        "isPrimary": true,
        "acquisitionDate": "1980-05-15",
        "acquisitionMethod": {
          "code": "BIRTH",
          "display": "Birth"
        }
      }
    ]
  },
  "addresses": [
    {
      "addressType": {
        "code": "RES",
        "display": "Residential"
      },
      "line1": "123 Main Street",
      "line2": "Apartment 4B",
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
      "isPrimary": true,
      "fromDate": "2020-01-15",
      "toDate": null,
      "yearsAtAddress": 6
    },
    {
      "addressType": {
        "code": "PREV",
        "display": "Previous Address"
      },
      "line1": "45 Old Road",
      "line2": null,
      "line3": null,
      "line4": null,
      "city": "Manchester",
      "county": {
        "code": "GTM",
        "display": "Greater Manchester"
      },
      "postcode": "M1 1AA",
      "country": {
        "code": "GB",
        "display": "United Kingdom",
        "alpha3": "GBR"
      },
      "isPrimary": false,
      "fromDate": "2015-03-10",
      "toDate": "2020-01-14",
      "yearsAtAddress": 5
    }
  ],
  "contacts": [
    {
      "contactType": {
        "code": "EMAIL",
        "display": "Email"
      },
      "value": "john.smith@example.com",
      "isPrimary": true,
      "isVerified": true,
      "verifiedDate": "2020-01-15"
    },
    {
      "contactType": {
        "code": "MOBILE",
        "display": "Mobile Phone"
      },
      "value": "+44 7700 900123",
      "isPrimary": true,
      "isVerified": true,
      "verifiedDate": "2020-01-15"
    },
    {
      "contactType": {
        "code": "PHONE",
        "display": "Home Phone"
      },
      "value": "+44 20 7946 0958",
      "isPrimary": false,
      "isVerified": false
    },
    {
      "contactType": {
        "code": "WORK_PHONE",
        "display": "Work Phone"
      },
      "value": "+44 20 7946 0123",
      "isPrimary": false,
      "isVerified": false
    }
  ],
  "identityVerification": {
    "verificationStatus": "Verified",
    "verificationDate": "2020-01-15",
    "expiryDate": "2025-01-15",
    "nextReviewDate": "2025-01-15",
    "verifiedBy": {
      "id": "adviser-789",
      "name": "Jane Doe"
    },
    "verificationMethod": "Electronic",
    "documents": [
      {
        "documentType": "Passport",
        "documentNumber": "502135321",
        "issueDate": "2020-05-15",
        "expiryDate": "2030-05-15",
        "issuingCountry": {
          "code": "GB",
          "display": "United Kingdom"
        },
        "verified": true,
        "verifiedDate": "2020-01-15",
        "verificationSource": "GOV.UK Verify"
      },
      {
        "documentType": "DrivingLicense",
        "documentNumber": "SMITH801055JM9IJ",
        "issueDate": "2020-05-15",
        "expiryDate": "2030-05-15",
        "issuingCountry": {
          "code": "GB",
          "display": "United Kingdom"
        },
        "verified": true,
        "verifiedDate": "2020-01-15",
        "verificationSource": "DVLA"
      }
    ],
    "amlChecks": {
      "lastCheckDate": "2020-01-15",
      "nextCheckDate": "2025-01-15",
      "riskRating": "Low",
      "sanctionsChecked": true,
      "sanctionsMatches": 0,
      "sanctionsCheckSource": "World-Check",
      "pepChecked": true,
      "isPep": false,
      "pepCheckSource": "World-Check",
      "adverseMediaChecked": true,
      "adverseMediaMatches": 0,
      "adverseMediaCheckSource": "LexisNexis",
      "overallStatus": "Clear",
      "checkPerformedBy": {
        "id": "adviser-789",
        "name": "Jane Doe"
      }
    },
    "mlrCompliance": {
      "kycCompliant": true,
      "kycComplianceDate": "2020-01-15",
      "cddCompleted": true,
      "cddCompletedDate": "2020-01-15",
      "eddRequired": false,
      "eddCompletedDate": null,
      "complianceStatus": "Compliant",
      "complianceDate": "2020-01-15",
      "reviewPeriod": "Annual",
      "lastReviewDate": "2025-01-15",
      "nextReviewDate": "2026-01-15"
    },
    "sourceOfWealth": {
      "primarySource": "Employment",
      "secondarySource": "Investments",
      "description": "Senior executive salary and investment portfolio",
      "evidenceProvided": true,
      "evidenceType": "Payslips, Investment Statements",
      "verifiedDate": "2020-01-15"
    },
    "sourceOfFunds": {
      "source": "Savings",
      "description": "Personal savings accumulated over 20 years",
      "evidenceProvided": true,
      "evidenceType": "Bank Statements",
      "verifiedDate": "2020-01-15"
    }
  },
  "dataProtection": {
    "gdprConsent": {
      "dataProcessing": {
        "consented": true,
        "consentDate": "2020-01-15",
        "consentMethod": "Explicit",
        "lawfulBasis": "Consent",
        "consentText": "I consent to my personal data being processed for financial advice services",
        "version": "1.0"
      },
      "marketing": {
        "consented": true,
        "consentDate": "2020-01-15",
        "consentMethod": "Explicit",
        "lawfulBasis": "Consent",
        "consentText": "I consent to receiving marketing communications",
        "version": "1.0"
      },
      "profiling": {
        "consented": false,
        "consentDate": null,
        "consentMethod": null,
        "lawfulBasis": null,
        "consentText": null,
        "version": null
      },
      "thirdPartySharing": {
        "consented": false,
        "consentDate": null,
        "consentMethod": null,
        "lawfulBasis": null,
        "consentText": null,
        "version": null
      }
    },
    "privacyPolicy": {
      "version": "2.1",
      "acceptedDate": "2020-01-15",
      "url": "https://api.factfind.com/privacy-policy/v2.1",
      "acceptanceMethod": "Electronic"
    },
    "dataRetention": {
      "retentionPeriod": "7 years after relationship ends",
      "retentionBasis": "FCA Regulatory Requirement",
      "relationshipEndDate": null,
      "retentionEndDate": null,
      "archiveDate": null
    },
    "rightsExercised": {
      "dsarRequests": 0,
      "rectificationRequests": 0,
      "erasureRequests": 0,
      "portabilityRequests": 0,
      "restrictionRequests": 0,
      "objectionRequests": 0,
      "lastRequestDate": null,
      "lastRequestType": null
    },
    "breachNotifications": {
      "breachCount": 0,
      "lastBreachDate": null,
      "breachesNotified": []
    }
  },
  "marketingPreferences": {
    "channels": {
      "email": {
        "consented": true,
        "consentDate": "2020-01-15",
        "doubleOptInDate": "2020-01-15",
        "optOutDate": null,
        "frequency": "Monthly",
        "lastContactDate": "2026-02-01",
        "unsubscribed": false
      },
      "phone": {
        "consented": false,
        "consentDate": null,
        "optOutDate": null,
        "frequency": null,
        "lastContactDate": null,
        "unsubscribed": false,
        "tpsChecked": true,
        "tpsRegistered": false,
        "tpsCheckDate": "2020-01-15"
      },
      "sms": {
        "consented": true,
        "consentDate": "2020-01-15",
        "optOutDate": null,
        "frequency": "Quarterly",
        "lastContactDate": "2026-01-15",
        "unsubscribed": false
      },
      "post": {
        "consented": false,
        "consentDate": null,
        "optOutDate": null,
        "frequency": null,
        "lastContactDate": null,
        "unsubscribed": false,
        "mpsChecked": true,
        "mpsRegistered": false,
        "mpsCheckDate": "2020-01-15"
      },
      "socialMedia": {
        "consented": false,
        "consentDate": null,
        "optOutDate": null,
        "frequency": null,
        "lastContactDate": null,
        "unsubscribed": false
      }
    },
    "interests": [
      "Retirement Planning",
      "Investment Advice",
      "Tax Planning",
      "Estate Planning"
    ],
    "productInterests": [
      "Pensions",
      "ISAs",
      "Investments",
      "Protection"
    ],
    "suppressionList": false,
    "unsubscribeAll": false,
    "unsubscribeAllDate": null,
    "lastUpdated": "2020-01-15",
    "preferredContactTime": "Weekday Evenings",
    "doNotContact": false,
    "doNotContactReason": null
  },
  "estatePlanning": {
    "will": {
      "hasWill": true,
      "willDate": "2020-06-15",
      "lastReviewed": "2024-06-15",
      "nextReviewDate": "2027-06-15",
      "isUpToDate": true,
      "willType": "Simple Will",
      "willStoredWith": "Smith & Co Solicitors",
      "willStoredLocation": "London Office",
      "executors": [
        {
          "name": "Sarah Smith",
          "relationship": "Spouse",
          "type": "Primary",
          "contactDetails": "sarah.smith@example.com"
        },
        {
          "name": "David Smith",
          "relationship": "Brother",
          "type": "Substitute",
          "contactDetails": "david.smith@example.com"
        }
      ],
      "beneficiaries": [
        {
          "name": "Sarah Smith",
          "relationship": "Spouse",
          "percentage": 100,
          "notes": "Primary beneficiary"
        }
      ],
      "advisedByUs": true,
      "advisedDate": "2020-06-01"
    },
    "powerOfAttorney": {
      "hasLPA": true,
      "lpaType": "Property and Financial Affairs",
      "lpaDate": "2021-05-10",
      "lpaRegistered": true,
      "lpaRegistrationDate": "2021-05-15",
      "lpaExpiryDate": null,
      "attorneys": [
        {
          "name": "Sarah Smith",
          "relationship": "Spouse",
          "type": "Primary",
          "contactDetails": "sarah.smith@example.com"
        }
      ],
      "instructions": "Can act jointly and severally",
      "advisedByUs": true,
      "advisedDate": "2021-04-15"
    },
    "healthWelfareLPA": {
      "hasHealthWelfareLPA": true,
      "lpaDate": "2021-05-10",
      "lpaRegistered": true,
      "lpaRegistrationDate": "2021-05-15",
      "attorneys": [
        {
          "name": "Sarah Smith",
          "relationship": "Spouse",
          "type": "Primary",
          "contactDetails": "sarah.smith@example.com"
        }
      ]
    },
    "gifts": {
      "totalGiftsLastYear": {
        "amount": 6000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "annualExemptionUsed": {
        "amount": 6000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "annualExemptionAvailable": {
        "amount": 0.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "petsOutstanding": 2,
      "petDetails": [
        {
          "recipient": "Adult Child 1",
          "amount": {
            "amount": 10000.00,
            "currency": {
              "code": "GBP",
              "display": "British Pound",
              "symbol": "£"
            }
          },
          "dateOfGift": "2023-05-15",
          "survivePeriod": 7,
          "yearsRemaining": 4
        },
        {
          "recipient": "Adult Child 2",
          "amount": {
            "amount": 10000.00,
            "currency": {
              "code": "GBP",
              "display": "British Pound",
              "symbol": "£"
            }
          },
          "dateOfGift": "2024-05-15",
          "survivePeriod": 7,
          "yearsRemaining": 5
        }
      ],
      "regularGiftsFromIncome": {
        "hasRegularGifts": true,
        "amount": {
          "amount": 500.00,
          "currency": {
            "code": "GBP",
            "display": "British Pound",
            "symbol": "£"
          }
        },
        "frequency": "Monthly",
        "recipient": "Grandchildren"
      }
    },
    "trusts": {
      "hasTrusts": false,
      "numberOfTrusts": 0,
      "trustDetails": []
    },
    "ihtEstimate": {
      "estimatedEstate": {
        "amount": 650000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "nilRateBand": {
        "amount": 325000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "residenceNilRateBand": {
        "amount": 175000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "transferableNilRateBand": {
        "amount": 0.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "totalNilRateBand": {
        "amount": 500000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "taxableEstate": {
        "amount": 150000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "estimatedIHT": {
        "amount": 60000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "ihtRate": 0.40,
      "calculationDate": "2026-02-18",
      "nextReviewDate": "2027-02-18"
    },
    "lifeInsuranceInTrust": {
      "hasLifeInsuranceInTrust": true,
      "policies": [
        {
          "policyRef": "LI-123456",
          "sumAssured": {
            "amount": 250000.00,
            "currency": {
              "code": "GBP",
              "display": "British Pound",
              "symbol": "£"
            }
          },
          "trustType": "Discretionary Trust",
          "beneficiaries": ["Spouse", "Children"]
        }
      ]
    }
  },
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
  "dependants": [
    {
      "name": "Emma Smith",
      "relationship": "Daughter",
      "dateOfBirth": "2010-03-15",
      "age": 16,
      "isFinanciallyDependent": true,
      "isDisabled": false
    },
    {
      "name": "Oliver Smith",
      "relationship": "Son",
      "dateOfBirth": "2012-08-22",
      "age": 14,
      "isFinanciallyDependent": true,
      "isDisabled": false
    }
  ],
  "serviceStatus": "Active",
  "serviceStatusDate": "2020-01-15",
  "clientSegment": "A",
  "clientSegmentDate": "2020-01-15",
  "clientCategory": "HighNetWorth",
  "financialProfile": {
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
    "calculatedAt": "2026-02-18T10:30:00Z",
    "lastReviewDate": "2026-02-18"
  },
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },
  "paraplannerRef": {
    "id": "adviser-790",
    "href": "/api/v1/advisers/adviser-790",
    "name": "Tom Johnson",
    "code": "PP001"
  },
  "officeRef": {
    "id": "office-1",
    "name": "London Office",
    "code": "LON"
  },
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "createdBy": {
    "id": "adviser-789",
    "name": "Jane Doe"
  },
  "updatedBy": {
    "id": "adviser-789",
    "name": "Jane Doe"
  },
  "_etag": "W/\"v2-20260216-143000\"",
  "_links": {
    "self": { "href": "/api/v1/clients/client-123" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "spouse": { "href": "/api/v1/clients/client-124" },
    "adviser": { "href": "/api/v1/advisers/adviser-789" }
  }
}
```

---

#### 13.1.2 Corporate Client Example

**Corporate client** with full CorporateValue embedded:

```json
{
  "id": "client-567",
  "factFindRef": {
    "id": "factfind-890",
    "href": "/api/v1/factfinds/factfind-890",
    "factFindNumber": "FF-2025-00456",
    "status": {
      "code": "INP",
      "display": "In Progress"
    }
  },
  "clientNumber": "C00005678",
  "clientType": "Corporate",
  "corporateValue": {
    "companyName": "TechVenture Solutions Ltd",
    "tradingName": "TechVenture",
    "registrationNumber": "09876543",
    "incorporationDate": "2015-03-20",
    "companyType": {
      "code": "LTD",
      "display": "Private Limited Company"
    },
    "vatNumber": "GB123456789",
    "companyStatus": {
      "code": "ACTIVE",
      "display": "Active"
    },
    "sicCodes": [
      {
        "code": "62012",
        "display": "Business and domestic software development"
      },
      {
        "code": "62020",
        "display": "Information technology consultancy activities"
      }
    ],
    "numberOfEmployees": 45,
    "annualTurnover": {
      "amount": 3500000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "directors": [
      {
        "personRef": {
          "id": "client-568",
          "href": "/api/v1/clients/client-568",
          "name": "Robert Johnson",
          "clientNumber": "C00005679"
        },
        "appointedDate": "2015-03-20",
        "role": "Managing Director",
        "shareholding": 60.0,
        "isActive": true
      },
      {
        "personRef": {
          "id": "client-569",
          "href": "/api/v1/clients/client-569",
          "name": "Amanda Chen",
          "clientNumber": "C00005680"
        },
        "appointedDate": "2015-03-20",
        "role": "Technical Director",
        "shareholding": 40.0,
        "isActive": true
      }
    ],
    "shareholders": [
      {
        "shareholderRef": {
          "id": "client-568",
          "name": "Robert Johnson",
          "type": "Person"
        },
        "sharesHeld": 600,
        "shareClass": "Ordinary",
        "percentage": 60.0,
        "nominalValue": {
          "amount": 600.00,
          "currency": {
            "code": "GBP",
            "display": "British Pound",
            "symbol": "£"
          }
        }
      },
      {
        "shareholderRef": {
          "id": "client-569",
          "name": "Amanda Chen",
          "type": "Person"
        },
        "sharesHeld": 400,
        "shareClass": "Ordinary",
        "percentage": 40.0,
        "nominalValue": {
          "amount": 400.00,
          "currency": {
            "code": "GBP",
            "display": "British Pound",
            "symbol": "£"
          }
        }
      }
    ],
    "registeredOffice": {
      "line1": "Tech Park Building 5",
      "line2": "Silicon Street",
      "line3": null,
      "line4": null,
      "city": "London",
      "county": {
        "code": "GLA",
        "display": "Greater London"
      },
      "postcode": "EC2A 4DN",
      "country": {
        "code": "GB",
        "display": "United Kingdom",
        "alpha3": "GBR"
      }
    },
    "accountsFilingDate": "2026-12-31",
    "confirmationStatementDate": "2026-03-20",
    "financialYearEnd": "2026-12-31"
  },
  "addresses": [
    {
      "addressType": {
        "code": "REGISTERED",
        "display": "Registered Office"
      },
      "line1": "Tech Park Building 5",
      "line2": "Silicon Street",
      "line3": null,
      "line4": null,
      "city": "London",
      "county": {
        "code": "GLA",
        "display": "Greater London"
      },
      "postcode": "EC2A 4DN",
      "country": {
        "code": "GB",
        "display": "United Kingdom",
        "alpha3": "GBR"
      },
      "isPrimary": true,
      "fromDate": "2015-03-20",
      "toDate": null,
      "yearsAtAddress": 11
    },
    {
      "addressType": {
        "code": "TRADING",
        "display": "Trading Address"
      },
      "line1": "Innovation Hub",
      "line2": "25 Tech Square",
      "line3": null,
      "line4": null,
      "city": "London",
      "county": {
        "code": "GLA",
        "display": "Greater London"
      },
      "postcode": "E1 6AN",
      "country": {
        "code": "GB",
        "display": "United Kingdom",
        "alpha3": "GBR"
      },
      "isPrimary": false,
      "fromDate": "2020-06-01",
      "toDate": null,
      "yearsAtAddress": 6
    }
  ],
  "contacts": [
    {
      "contactType": {
        "code": "EMAIL",
        "display": "Email"
      },
      "value": "info@techventure.com",
      "isPrimary": true,
      "isVerified": true,
      "verifiedDate": "2015-03-20"
    },
    {
      "contactType": {
        "code": "PHONE",
        "display": "Main Office Phone"
      },
      "value": "+44 20 7946 1234",
      "isPrimary": true,
      "isVerified": true,
      "verifiedDate": "2015-03-20"
    },
    {
      "contactType": {
        "code": "WEBSITE",
        "display": "Website"
      },
      "value": "https://www.techventure.com",
      "isPrimary": false,
      "isVerified": true,
      "verifiedDate": "2015-03-20"
    }
  ],
  "identityVerification": {
    "verificationStatus": "Verified",
    "verificationDate": "2015-03-20",
    "expiryDate": "2028-03-20",
    "nextReviewDate": "2027-03-20",
    "verifiedBy": {
      "id": "adviser-800",
      "name": "Michael Brown"
    },
    "verificationMethod": "Electronic",
    "documents": [
      {
        "documentType": "Certificate of Incorporation",
        "documentNumber": "09876543",
        "issueDate": "2015-03-20",
        "expiryDate": null,
        "issuingCountry": {
          "code": "GB",
          "display": "United Kingdom"
        },
        "verified": true,
        "verifiedDate": "2015-03-20",
        "verificationSource": "Companies House"
      },
      {
        "documentType": "VAT Registration Certificate",
        "documentNumber": "GB123456789",
        "issueDate": "2015-04-15",
        "expiryDate": null,
        "issuingCountry": {
          "code": "GB",
          "display": "United Kingdom"
        },
        "verified": true,
        "verifiedDate": "2015-04-20",
        "verificationSource": "HMRC"
      }
    ],
    "amlChecks": {
      "lastCheckDate": "2025-03-20",
      "nextCheckDate": "2028-03-20",
      "riskRating": "Low",
      "sanctionsChecked": true,
      "sanctionsMatches": 0,
      "sanctionsCheckSource": "Dow Jones",
      "pepChecked": true,
      "isPep": false,
      "pepCheckSource": "Dow Jones",
      "adverseMediaChecked": true,
      "adverseMediaMatches": 0,
      "adverseMediaCheckSource": "LexisNexis",
      "overallStatus": "Clear",
      "checkPerformedBy": {
        "id": "adviser-800",
        "name": "Michael Brown"
      }
    },
    "mlrCompliance": {
      "kycCompliant": true,
      "kycComplianceDate": "2015-03-20",
      "cddCompleted": true,
      "cddCompletedDate": "2015-03-20",
      "eddRequired": false,
      "eddCompletedDate": null,
      "complianceStatus": "Compliant",
      "complianceDate": "2015-03-20",
      "reviewPeriod": "Triennial",
      "lastReviewDate": "2025-03-20",
      "nextReviewDate": "2028-03-20"
    },
    "sourceOfWealth": {
      "primarySource": "Trading Activities",
      "secondarySource": "Retained Earnings",
      "description": "Software development and IT consulting services",
      "evidenceProvided": true,
      "evidenceType": "Annual Accounts, Management Accounts",
      "verifiedDate": "2025-03-20"
    },
    "sourceOfFunds": {
      "source": "Operating Profits",
      "description": "Revenue from software development contracts",
      "evidenceProvided": true,
      "evidenceType": "Bank Statements, Invoices",
      "verifiedDate": "2025-03-20"
    }
  },
  "territorialProfile": {
    "ukResident": true,
    "ukDomicile": true,
    "countryOfOrigin": {
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
    }
  },
  "dataProtection": {
    "gdprConsent": {
      "dataProcessing": {
        "consented": true,
        "consentDate": "2015-03-20",
        "consentMethod": "Written",
        "lawfulBasis": "Legitimate Interest",
        "consentText": "Company consents to data processing for corporate financial advice services",
        "version": "1.0"
      },
      "marketing": {
        "consented": true,
        "consentDate": "2015-03-20",
        "consentMethod": "Written",
        "lawfulBasis": "Consent",
        "consentText": "Company consents to receiving marketing communications",
        "version": "1.0"
      },
      "profiling": {
        "consented": false,
        "consentDate": null,
        "consentMethod": null,
        "lawfulBasis": null,
        "consentText": null,
        "version": null
      },
      "thirdPartySharing": {
        "consented": false,
        "consentDate": null,
        "consentMethod": null,
        "lawfulBasis": null,
        "consentText": null,
        "version": null
      }
    },
    "privacyPolicy": {
      "version": "2.1",
      "acceptedDate": "2015-03-20",
      "url": "https://api.factfind.com/privacy-policy/v2.1",
      "acceptanceMethod": "Written"
    },
    "dataRetention": {
      "retentionPeriod": "7 years after relationship ends",
      "retentionBasis": "FCA Regulatory Requirement",
      "relationshipEndDate": null,
      "retentionEndDate": null,
      "archiveDate": null
    },
    "rightsExercised": {
      "dsarRequests": 0,
      "rectificationRequests": 0,
      "erasureRequests": 0,
      "portabilityRequests": 0,
      "restrictionRequests": 0,
      "objectionRequests": 0,
      "lastRequestDate": null,
      "lastRequestType": null
    },
    "breachNotifications": {
      "breachCount": 0,
      "lastBreachDate": null,
      "breachesNotified": []
    }
  },
  "marketingPreferences": {
    "channels": {
      "email": {
        "consented": true,
        "consentDate": "2015-03-20",
        "doubleOptInDate": "2015-03-20",
        "optOutDate": null,
        "frequency": "Quarterly",
        "lastContactDate": "2026-01-15",
        "unsubscribed": false
      },
      "phone": {
        "consented": true,
        "consentDate": "2015-03-20",
        "optOutDate": null,
        "frequency": "Annual",
        "lastContactDate": "2025-12-10",
        "unsubscribed": false,
        "tpsChecked": false,
        "tpsRegistered": false,
        "tpsCheckDate": null
      },
      "sms": {
        "consented": false,
        "consentDate": null,
        "optOutDate": null,
        "frequency": null,
        "lastContactDate": null,
        "unsubscribed": false
      },
      "post": {
        "consented": true,
        "consentDate": "2015-03-20",
        "optOutDate": null,
        "frequency": "Biannual",
        "lastContactDate": "2025-11-01",
        "unsubscribed": false,
        "mpsChecked": false,
        "mpsRegistered": false,
        "mpsCheckDate": null
      },
      "socialMedia": {
        "consented": false,
        "consentDate": null,
        "optOutDate": null,
        "frequency": null,
        "lastContactDate": null,
        "unsubscribed": false
      }
    },
    "interests": [
      "Corporate Pensions",
      "Group Life Assurance",
      "Key Person Insurance",
      "Business Protection"
    ],
    "productInterests": [
      "Group Pensions",
      "Group Life",
      "Keyman Protection",
      "Shareholder Protection"
    ],
    "suppressionList": false,
    "unsubscribeAll": false,
    "unsubscribeAllDate": null,
    "lastUpdated": "2015-03-20",
    "preferredContactTime": "Business Hours",
    "doNotContact": false,
    "doNotContactReason": null
  },
  "serviceStatus": "Active",
  "serviceStatusDate": "2015-03-20",
  "clientSegment": "B",
  "clientSegmentDate": "2015-03-20",
  "clientCategory": "SmallBusiness",
  "financialProfile": {
    "grossAnnualIncome": {
      "amount": 3500000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "netWorth": {
      "amount": 1250000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "totalAssets": {
      "amount": 2100000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "calculatedAt": "2026-02-18T10:30:00Z",
    "lastReviewDate": "2026-02-18"
  },
  "adviserRef": {
    "id": "adviser-800",
    "href": "/api/v1/advisers/adviser-800",
    "name": "Michael Brown",
    "code": "ADV002"
  },
  "paraplannerRef": {
    "id": "adviser-801",
    "href": "/api/v1/advisers/adviser-801",
    "name": "Lisa Wong",
    "code": "PP002"
  },
  "officeRef": {
    "id": "office-2",
    "name": "Manchester Office",
    "code": "MAN"
  },
  "createdAt": "2015-03-20T09:00:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "createdBy": {
    "id": "adviser-800",
    "name": "Michael Brown"
  },
  "updatedBy": {
    "id": "adviser-800",
    "name": "Michael Brown"
  },
  "_etag": "W/\"v2-20260216-143000\"",
  "_links": {
    "self": { "href": "/api/v1/clients/client-567" },
    "factfind": { "href": "/api/v1/factfinds/factfind-890" },
    "adviser": { "href": "/api/v1/advisers/adviser-800" }
  }
}
```

---

#### 13.1.3 Trust Client Example

**Trust client** with full TrustValue embedded:

```json
{
  "id": "client-999",
  "factFindRef": {
    "id": "factfind-1111",
    "href": "/api/v1/factfinds/factfind-1111",
    "factFindNumber": "FF-2025-00789",
    "status": {
      "code": "INP",
      "display": "In Progress"
    }
  },
  "clientNumber": "C00009999",
  "clientType": "Trust",
  "trustValue": {
    "trustName": "The Smith Family Discretionary Trust",
    "trustType": {
      "code": "DISCRETIONARY",
      "display": "Discretionary Trust"
    },
    "settlementDate": "2018-04-15",
    "trustRegistrationNumber": "TRN12345678",
    "taxReference": "1234567890",
    "trustDeed": {
      "documentRef": "DEED-2018-04-15-SMITH",
      "documentUrl": "https://docs.example.com/trusts/deed-smith-2018.pdf",
      "executionDate": "2018-04-15",
      "storedWith": "Harrison & Partners Solicitors",
      "lastReviewedDate": "2024-04-15"
    },
    "settlor": {
      "personRef": {
        "id": "client-1000",
        "href": "/api/v1/clients/client-1000",
        "name": "William Smith",
        "clientNumber": "C00010000"
      },
      "settlementAmount": {
        "amount": 500000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "settlementDate": "2018-04-15",
      "isDeceased": false
    },
    "trustees": [
      {
        "personRef": {
          "id": "client-1001",
          "href": "/api/v1/clients/client-1001",
          "name": "Margaret Smith",
          "clientNumber": "C00010001"
        },
        "appointedDate": "2018-04-15",
        "role": "Principal Trustee",
        "isProfessionalTrustee": false,
        "isActive": true
      },
      {
        "personRef": {
          "id": "client-1002",
          "href": "/api/v1/clients/client-1002",
          "name": "James Harrison",
          "clientNumber": "C00010002"
        },
        "appointedDate": "2018-04-15",
        "role": "Professional Trustee",
        "isProfessionalTrustee": true,
        "professionalFirm": "Harrison & Partners Solicitors",
        "isActive": true
      }
    ],
    "beneficiaries": [
      {
        "personRef": {
          "id": "client-1003",
          "name": "Alexander Smith",
          "type": "Person"
        },
        "relationship": "Grandchild",
        "beneficiaryType": "Discretionary",
        "class": "Income and Capital",
        "percentage": null,
        "fromDate": "2018-04-15",
        "isActive": true
      },
      {
        "personRef": {
          "id": "client-1004",
          "name": "Emily Smith",
          "type": "Person"
        },
        "relationship": "Grandchild",
        "beneficiaryType": "Discretionary",
        "class": "Income and Capital",
        "percentage": null,
        "fromDate": "2018-04-15",
        "isActive": true
      },
      {
        "personRef": {
          "id": "client-1005",
          "name": "Sophie Smith",
          "type": "Person"
        },
        "relationship": "Grandchild",
        "beneficiaryType": "Discretionary",
        "class": "Income and Capital",
        "percentage": null,
        "fromDate": "2020-06-20",
        "isActive": true
      }
    ],
    "trustAssets": {
      "totalValue": {
        "amount": 650000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "assetBreakdown": [
        {
          "assetType": "Cash",
          "value": {
            "amount": 50000.00,
            "currency": {
              "code": "GBP",
              "display": "British Pound",
              "symbol": "£"
            }
          },
          "percentage": 7.69
        },
        {
          "assetType": "Investments",
          "value": {
            "amount": 450000.00,
            "currency": {
              "code": "GBP",
              "display": "British Pound",
              "symbol": "£"
            }
          },
          "percentage": 69.23
        },
        {
          "assetType": "Property",
          "value": {
            "amount": 150000.00,
            "currency": {
              "code": "GBP",
              "display": "British Pound",
              "symbol": "£"
            }
          },
          "percentage": 23.08
        }
      ],
      "valuationDate": "2026-01-31"
    },
    "taxStatus": {
      "taxYear": "2025/26",
      "ihtRelevantProperty": true,
      "lastIhtCharge": null,
      "nextIhtChargeDate": "2028-04-15",
      "cgtLiability": {
        "amount": 0.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "incomeTaxLiability": {
        "amount": 5600.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "trustRate": 45.0
    },
    "distributions": [
      {
        "beneficiaryRef": {
          "id": "client-1003",
          "name": "Alexander Smith"
        },
        "distributionDate": "2025-12-20",
        "amount": {
          "amount": 10000.00,
          "currency": {
            "code": "GBP",
            "display": "British Pound",
            "symbol": "£"
          }
        },
        "distributionType": "Discretionary Payment",
        "purpose": "Education Expenses"
      },
      {
        "beneficiaryRef": {
          "id": "client-1004",
          "name": "Emily Smith"
        },
        "distributionDate": "2025-12-20",
        "amount": {
          "amount": 8000.00,
          "currency": {
            "code": "GBP",
            "display": "British Pound",
            "symbol": "£"
          }
        },
        "distributionType": "Discretionary Payment",
        "purpose": "Education Expenses"
      }
    ],
    "accountingPeriodEnd": "2026-04-05",
    "nextReviewDate": "2027-04-15"
  },
  "addresses": [
    {
      "addressType": {
        "code": "TRUST_CORRESPONDENCE",
        "display": "Trust Correspondence Address"
      },
      "line1": "Harrison & Partners Solicitors",
      "line2": "Regency House",
      "line3": "25 High Street",
      "line4": null,
      "city": "London",
      "county": {
        "code": "GLA",
        "display": "Greater London"
      },
      "postcode": "WC2N 5DU",
      "country": {
        "code": "GB",
        "display": "United Kingdom",
        "alpha3": "GBR"
      },
      "isPrimary": true,
      "fromDate": "2018-04-15",
      "toDate": null,
      "yearsAtAddress": 8
    }
  ],
  "contacts": [
    {
      "contactType": {
        "code": "EMAIL",
        "display": "Email"
      },
      "value": "trustees@smithfamilytrust.com",
      "isPrimary": true,
      "isVerified": true,
      "verifiedDate": "2018-04-15"
    },
    {
      "contactType": {
        "code": "PHONE",
        "display": "Trustee Contact Phone"
      },
      "value": "+44 20 7946 5678",
      "isPrimary": true,
      "isVerified": true,
      "verifiedDate": "2018-04-15"
    }
  ],
  "identityVerification": {
    "verificationStatus": "Verified",
    "verificationDate": "2018-04-15",
    "expiryDate": "2028-04-15",
    "nextReviewDate": "2027-04-15",
    "verifiedBy": {
      "id": "adviser-810",
      "name": "Patricia Davies"
    },
    "verificationMethod": "Documentary",
    "documents": [
      {
        "documentType": "Trust Deed",
        "documentNumber": "DEED-2018-04-15-SMITH",
        "issueDate": "2018-04-15",
        "expiryDate": null,
        "issuingCountry": {
          "code": "GB",
          "display": "United Kingdom"
        },
        "verified": true,
        "verifiedDate": "2018-04-15",
        "verificationSource": "Solicitor Certification"
      },
      {
        "documentType": "HMRC Trust Registration",
        "documentNumber": "TRN12345678",
        "issueDate": "2018-04-20",
        "expiryDate": null,
        "issuingCountry": {
          "code": "GB",
          "display": "United Kingdom"
        },
        "verified": true,
        "verifiedDate": "2018-04-25",
        "verificationSource": "HMRC"
      }
    ],
    "amlChecks": {
      "lastCheckDate": "2025-04-15",
      "nextCheckDate": "2028-04-15",
      "riskRating": "Low",
      "sanctionsChecked": true,
      "sanctionsMatches": 0,
      "sanctionsCheckSource": "Dow Jones",
      "pepChecked": true,
      "isPep": false,
      "pepCheckSource": "Dow Jones",
      "adverseMediaChecked": true,
      "adverseMediaMatches": 0,
      "adverseMediaCheckSource": "LexisNexis",
      "overallStatus": "Clear",
      "checkPerformedBy": {
        "id": "adviser-810",
        "name": "Patricia Davies"
      }
    },
    "mlrCompliance": {
      "kycCompliant": true,
      "kycComplianceDate": "2018-04-15",
      "cddCompleted": true,
      "cddCompletedDate": "2018-04-15",
      "eddRequired": false,
      "eddCompletedDate": null,
      "complianceStatus": "Compliant",
      "complianceDate": "2018-04-15",
      "reviewPeriod": "Triennial",
      "lastReviewDate": "2025-04-15",
      "nextReviewDate": "2028-04-15"
    },
    "sourceOfWealth": {
      "primarySource": "Settlement by Settlor",
      "secondarySource": "Investment Growth",
      "description": "Initial settlement of £500,000 from William Smith, plus investment returns",
      "evidenceProvided": true,
      "evidenceType": "Trust Deed, Settlement Documentation, Investment Statements",
      "verifiedDate": "2018-04-15"
    },
    "sourceOfFunds": {
      "source": "Settlement Funds",
      "description": "Cash and securities transferred from settlor",
      "evidenceProvided": true,
      "evidenceType": "Bank Transfer Records, Securities Transfer Documentation",
      "verifiedDate": "2018-04-15"
    }
  },
  "territorialProfile": {
    "ukResident": true,
    "ukDomicile": true,
    "countryOfOrigin": {
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
    }
  },
  "dataProtection": {
    "gdprConsent": {
      "dataProcessing": {
        "consented": true,
        "consentDate": "2018-04-15",
        "consentMethod": "Written",
        "lawfulBasis": "Legitimate Interest",
        "consentText": "Trustees consent to data processing for trust administration and financial advice services",
        "version": "1.0"
      },
      "marketing": {
        "consented": false,
        "consentDate": null,
        "consentMethod": null,
        "lawfulBasis": null,
        "consentText": null,
        "version": null
      },
      "profiling": {
        "consented": false,
        "consentDate": null,
        "consentMethod": null,
        "lawfulBasis": null,
        "consentText": null,
        "version": null
      },
      "thirdPartySharing": {
        "consented": false,
        "consentDate": null,
        "consentMethod": null,
        "lawfulBasis": null,
        "consentText": null,
        "version": null
      }
    },
    "privacyPolicy": {
      "version": "2.1",
      "acceptedDate": "2018-04-15",
      "url": "https://api.factfind.com/privacy-policy/v2.1",
      "acceptanceMethod": "Written"
    },
    "dataRetention": {
      "retentionPeriod": "10 years after trust dissolution",
      "retentionBasis": "Trust Law Requirement",
      "relationshipEndDate": null,
      "retentionEndDate": null,
      "archiveDate": null
    },
    "rightsExercised": {
      "dsarRequests": 0,
      "rectificationRequests": 0,
      "erasureRequests": 0,
      "portabilityRequests": 0,
      "restrictionRequests": 0,
      "objectionRequests": 0,
      "lastRequestDate": null,
      "lastRequestType": null
    },
    "breachNotifications": {
      "breachCount": 0,
      "lastBreachDate": null,
      "breachesNotified": []
    }
  },
  "marketingPreferences": {
    "channels": {
      "email": {
        "consented": false,
        "consentDate": null,
        "doubleOptInDate": null,
        "optOutDate": null,
        "frequency": null,
        "lastContactDate": null,
        "unsubscribed": true
      },
      "phone": {
        "consented": false,
        "consentDate": null,
        "optOutDate": null,
        "frequency": null,
        "lastContactDate": null,
        "unsubscribed": true,
        "tpsChecked": false,
        "tpsRegistered": false,
        "tpsCheckDate": null
      },
      "sms": {
        "consented": false,
        "consentDate": null,
        "optOutDate": null,
        "frequency": null,
        "lastContactDate": null,
        "unsubscribed": true
      },
      "post": {
        "consented": false,
        "consentDate": null,
        "optOutDate": null,
        "frequency": null,
        "lastContactDate": null,
        "unsubscribed": true,
        "mpsChecked": false,
        "mpsRegistered": false,
        "mpsCheckDate": null
      },
      "socialMedia": {
        "consented": false,
        "consentDate": null,
        "optOutDate": null,
        "frequency": null,
        "lastContactDate": null,
        "unsubscribed": true
      }
    },
    "interests": [],
    "productInterests": [],
    "suppressionList": false,
    "unsubscribeAll": true,
    "unsubscribeAllDate": "2018-04-15",
    "lastUpdated": "2018-04-15",
    "preferredContactTime": null,
    "doNotContact": true,
    "doNotContactReason": "Trust Entity - Professional Trustees Only"
  },
  "serviceStatus": "Active",
  "serviceStatusDate": "2018-04-15",
  "clientSegment": "C",
  "clientSegmentDate": "2018-04-15",
  "clientCategory": "Trust",
  "financialProfile": {
    "netWorth": {
      "amount": 650000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "totalAssets": {
      "amount": 650000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "calculatedAt": "2026-02-18T10:30:00Z",
    "lastReviewDate": "2026-02-18"
  },
  "adviserRef": {
    "id": "adviser-810",
    "href": "/api/v1/advisers/adviser-810",
    "name": "Patricia Davies",
    "code": "ADV003"
  },
  "paraplannerRef": {
    "id": "adviser-811",
    "href": "/api/v1/advisers/adviser-811",
    "name": "Andrew Wilson",
    "code": "PP003"
  },
  "officeRef": {
    "id": "office-1",
    "name": "London Office",
    "code": "LON"
  },
  "createdAt": "2018-04-15T10:00:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "createdBy": {
    "id": "adviser-810",
    "name": "Patricia Davies"
  },
  "updatedBy": {
    "id": "adviser-810",
    "name": "Patricia Davies"
  },
  "_etag": "W/\"v2-20260216-143000\"",
  "_links": {
    "self": { "href": "/api/v1/clients/client-999" },
    "factfind": { "href": "/api/v1/factfinds/factfind-1111" },
    "adviser": { "href": "/api/v1/advisers/adviser-810" }
  }
}
```

---

#### 13.1.4 Field Behaviors (Composition Pattern)

| Field | Type | Required | Validation Rules | Notes |
|-------|------|----------|------------------|-------|
| `id` | string | Yes (read-only) | System-generated | Unique identifier |
| `clientNumber` | string | Yes | Unique, max 20 chars | Business key |
| `clientType` | string | Yes | Enum: Person, Corporate, Trust | Discriminator field |
| `personValue` | PersonValue | Conditional | Required if clientType=Person | Person-specific fields |
| `corporateValue` | CorporateValue | Conditional | Required if clientType=Corporate | Corporate-specific fields |
| `trustValue` | TrustValue | Conditional | Required if clientType=Trust | Trust-specific fields |
| `addresses` | AddressValue[] | Yes | Min 1 address required | Full address history |
| `contacts` | ContactValue[] | Yes | Min 1 email or phone required | All contact methods |
| `identityVerification` | IdentityVerificationValue | Conditional | Required for KYC completion | KYC, AML, MLR compliance |
| `territorialProfile` | TerritorialProfileValue | No | | Territorial status, residency, domicile, citizenship |
| `dataProtection` | DataProtectionValue | Yes | Required for GDPR compliance | GDPR consent management |
| `marketingPreferences` | MarketingPreferencesValue | Yes | Required for marketing | Marketing opt-in/out |
| `estatePlanning` | EstatePlanningValue | Conditional | Only for Person clients | Will, LPA, gifts, IHT |
| `spouseRef` | ClientRef | Conditional | Only for Person clients | Spouse reference |
| `dependants` | DependantValue[] | Conditional | Only for Person clients | Financial dependants |

---

#### 13.1.5 PersonValue Type Definition

Embedded value type for Person-specific fields. Only present when `clientType="Person"`.

**Fields:**

```typescript
PersonValue {
  title: CodedValue                    // Mr, Mrs, Dr, etc.
  firstName: string                    // Required
  middleNames: string                  // Optional, multiple middle names
  lastName: string                     // Required
  preferredName: string                // Optional
  fullName: string                     // Calculated: "Title FirstName MiddleNames LastName"
  salutation: string                   // Calculated: "Title LastName"
  dateOfBirth: date                    // ISO 8601, Required
  age: integer                         // Calculated from dateOfBirth
  gender: CodedValue                   // M, F, O
  maritalStatus: MaritalStatusValue    // MAR, SIN, DIV, etc. with effectiveFrom
  niNumber: string                     // National Insurance Number (encrypted)
  smokingStatus: CodedValue            // NEVER, FORMER, CURRENT
  healthMetrics: HealthMetricsValue    // Height, weight, BMI
  occupation: string                   // Free text occupation
  occupationCode: OccupationCodeValue  // SOC code
  employmentStatus: CodedValue         // FT_EMP, PT_EMP, SELF_EMP, RETIRED, etc.
  isDeceased: boolean                  // Default false
  deceasedDate: date                   // Null if not deceased
  vulnerabilities: VulnerabilityValue[] // Client vulnerabilities (Consumer Duty)
}
```

**Health Metrics:**
```typescript
HealthMetricsValue {
  heightCm: decimal                    // Height in centimeters
  weightKg: decimal                    // Weight in kilograms
  bmi: decimal                         // Calculated: weight / (height^2)
  bmiCategory: string                  // Calculated: Underweight, Normal, Overweight, Obese
  lastMeasured: date                   // Date of last measurement
}
```

**Validation Rules:**
- `firstName` and `lastName` are required
- `dateOfBirth` is required and must be in the past
- `age` is system-calculated from `dateOfBirth`
- `niNumber` must match UK NI format: `^[A-Z]{2}[0-9]{6}[A-D]$`
- `bmi` is calculated as: `weightKg / (heightCm/100)^2`
- If `isDeceased=true`, `deceasedDate` is required

---

#### 13.1.6 CorporateValue Type Definition

Embedded value type for Corporate-specific fields. Only present when `clientType="Corporate"`.

**Fields:**

```typescript
CorporateValue {
  companyName: string                  // Required, official registered name
  tradingName: string                  // Optional, trading as name
  registrationNumber: string           // Optional, Companies House number
  incorporationDate: date              // Date of incorporation
  companyType: CodedValue              // LTD, PLC, LLP, etc.
  vatNumber: string                    // VAT registration number
  companyStatus: CodedValue            // ACTIVE, DISSOLVED, LIQUIDATION, etc.
  sicCodes: SicCodeValue[]             // SIC industry classification codes
  numberOfEmployees: integer           // Current employee count
  annualTurnover: MoneyValue           // Last reported annual turnover
  directors: DirectorValue[]           // Company directors
  shareholders: ShareholderValue[]     // Company shareholders
  registeredOffice: AddressValue       // Official registered office address
  accountsFilingDate: date             // Next accounts filing date
  confirmationStatementDate: date      // Next confirmation statement date
  financialYearEnd: date               // Financial year end date
}
```

**Director:**
```typescript
DirectorValue {
  personRef: ClientRef                 // Reference to Person client
  appointedDate: date                  // Date appointed as director
  role: string                         // Managing Director, Technical Director, etc.
  shareholding: decimal                // Percentage shareholding (0-100)
  isActive: boolean                    // Currently active
}
```

**Shareholder:**
```typescript
ShareholderValue {
  shareholderRef: EntityRef            // Reference to Person/Corporate/Trust
  sharesHeld: integer                  // Number of shares held
  shareClass: string                   // Ordinary, Preference, etc.
  percentage: decimal                  // Percentage of total shares (0-100)
  nominalValue: MoneyValue             // Nominal value of shares
}
```

**SIC Code:**
```typescript
SicCodeValue {
  code: string                         // 5-digit SIC code
  display: string                      // Description
}
```

**Validation Rules:**
- `companyName` is required
- `registrationNumber` must match UK Companies House format if provided: `^[A-Z0-9]{8}$`
- `vatNumber` must match UK VAT format if provided: `^GB[0-9]{9}$`
- Director shareholdings sum must not exceed 100%
- Shareholder percentages sum must equal 100%

---

#### 13.1.7 TrustValue Type Definition

Embedded value type for Trust-specific fields. Only present when `clientType="Trust"`.

**Fields:**

```typescript
TrustValue {
  trustName: string                    // Required, full trust name
  trustType: CodedValue                // DISCRETIONARY, LIFE_INTEREST, BARE, etc.
  settlementDate: date                 // Date trust was established
  trustRegistrationNumber: string      // HMRC Trust Registration Number
  taxReference: string                 // Trust tax reference (UTR)
  trustDeed: TrustDeedValue            // Trust deed document details
  settlor: SettlorValue                // Person who established the trust
  trustees: TrusteeValue[]             // Trust trustees
  beneficiaries: BeneficiaryValue[]    // Trust beneficiaries
  trustAssets: TrustAssetsValue        // Asset breakdown and valuation
  taxStatus: TrustTaxStatusValue       // IHT, CGT, income tax status
  distributions: DistributionValue[]   // Historical distributions
  accountingPeriodEnd: date            // Trust accounting period end date
  nextReviewDate: date                 // Next trust review date
}
```

**Trust Deed:**
```typescript
TrustDeedValue {
  documentRef: string                  // Document reference number
  documentUrl: string                  // URL to stored document
  executionDate: date                  // Date deed was executed
  storedWith: string                   // Where original is stored
  lastReviewedDate: date               // Last review date
}
```

**Settlor:**
```typescript
SettlorValue {
  personRef: ClientRef                 // Reference to Person client
  settlementAmount: MoneyValue         // Initial settlement amount
  settlementDate: date                 // Date of settlement
  isDeceased: boolean                  // Whether settlor is deceased
}
```

**Trustee:**
```typescript
TrusteeValue {
  personRef: ClientRef                 // Reference to Person client
  appointedDate: date                  // Date appointed as trustee
  role: string                         // Principal Trustee, Professional Trustee, etc.
  isProfessionalTrustee: boolean       // Whether professional trustee
  professionalFirm: string             // Firm name if professional
  isActive: boolean                    // Currently active
}
```

**Beneficiary:**
```typescript
BeneficiaryValue {
  personRef: EntityRef                 // Reference to Person/Corporate
  relationship: string                 // Child, Grandchild, etc.
  beneficiaryType: string              // Discretionary, Fixed, Contingent
  class: string                        // Income and Capital, Income Only, etc.
  percentage: decimal                  // Fixed percentage if applicable
  fromDate: date                       // Date became beneficiary
  isActive: boolean                    // Currently active
}
```

**Trust Assets:**
```typescript
TrustAssetsValue {
  totalValue: MoneyValue               // Total asset value
  assetBreakdown: AssetBreakdownValue[] // Breakdown by asset type
  valuationDate: date                  // Date of valuation
}

AssetBreakdownValue {
  assetType: string                    // Cash, Investments, Property, etc.
  value: MoneyValue                    // Value of this asset type
  percentage: decimal                  // Percentage of total (0-100)
}
```

**Trust Tax Status:**
```typescript
TrustTaxStatusValue {
  taxYear: string                      // e.g., "2025/26"
  ihtRelevantProperty: boolean         // Subject to 10-year IHT charges
  lastIhtCharge: date                  // Date of last IHT charge
  nextIhtChargeDate: date              // Next 10-year charge date
  cgtLiability: MoneyValue             // Estimated CGT liability
  incomeTaxLiability: MoneyValue       // Estimated income tax liability
  trustRate: decimal                   // Trust rate of tax (typically 45%)
}
```

**Distribution:**
```typescript
DistributionValue {
  beneficiaryRef: EntityRef            // Reference to beneficiary
  distributionDate: date               // Date of distribution
  amount: MoneyValue                   // Amount distributed
  distributionType: string             // Discretionary Payment, Income Distribution, etc.
  purpose: string                      // Purpose of distribution
}
```

**Validation Rules:**
- `trustName` is required
- `settlementDate` must be in the past
- `trustRegistrationNumber` must match HMRC format if provided: `^TRN[0-9]{8}$`
- At least one trustee is required
- At least one beneficiary is required
- Asset breakdown percentages must sum to 100%
- Distribution amounts must not exceed trust assets

---

#### 13.1.8 AddressValue Type

Embedded value type representing an address. Addresses have history (fromDate, toDate) but no separate identity.

```json
{
  "addressType": {
    "code": "RES",
    "display": "Residential"
  },
  "line1": "123 Main Street",
  "line2": "Apartment 4B",
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
  "isPrimary": true,
  "fromDate": "2020-01-15",
  "toDate": null,
  "yearsAtAddress": 6
}
```

**Address Types:**
- `RES` - Residential (Person)
- `WORK` - Work Address (Person)
- `PREV` - Previous Address (Person)
- `MAIL` - Mailing Address (All)
- `REGISTERED` - Registered Office (Corporate)
- `TRADING` - Trading Address (Corporate)
- `TRUST_CORRESPONDENCE` - Trust Correspondence Address (Trust)

**Fields:**
- `addressType` - Type of address
- `line1-4` - Address lines (line1 required)
- `city` - City/town (required)
- `county` - County/region
- `postcode` - Postal/ZIP code
- `country` - Country (required, default GB)
- `isPrimary` - Is this the primary address?
- `fromDate` - Date moved to this address
- `toDate` - Date moved from this address (null if current)
- `yearsAtAddress` - Calculated years at address (for affordability checks)

---

#### 13.1.9 ContactValue Type

Embedded value type representing a contact method.

```json
{
  "contactType": {
    "code": "EMAIL",
    "display": "Email"
  },
  "value": "john.smith@example.com",
  "isPrimary": true,
  "isVerified": true,
  "verifiedDate": "2020-01-15"
}
```

**Contact Types:**
- `EMAIL` - Email address
- `MOBILE` - Mobile phone
- `PHONE` - Home phone / Main office phone
- `WORK_PHONE` - Work phone
- `WEBSITE` - Website
- `LINKEDIN` - LinkedIn profile
- `FAX` - Fax number (legacy)

**Validation:**
- `EMAIL` must match email format
- Phone numbers should be in E.164 format: `+[country code][number]`
- `WEBSITE` must be valid URL

---

#### 13.1.10 IdentityVerificationValue Type

Embedded value type representing KYC, AML, and MLR compliance.

**Key Components:**
- **Verification Status** - Overall status (Verified, Pending, Failed, Expired)
- **Documents** - Passport, driving license, utility bills, company docs, trust deeds
- **AML Checks** - Sanctions, PEP, adverse media screening
- **MLR Compliance** - KYC, CDD, EDD status
- **Source of Wealth/Funds** - Evidence and verification

See full examples in the client JSON examples above.

---

#### 13.1.11 VulnerabilityValue Type

Embedded value type representing client vulnerabilities (Consumer Duty requirement). **Only applicable to Person clients** - embedded in `personValue.vulnerabilities` array.

```json
{
  "vulnerabilityType": {
    "code": "HEALTH",
    "display": "Health-related"
  },
  "severity": "Medium",
  "description": "Requires large print documents due to visual impairment",
  "assessmentDate": "2020-01-15",
  "reviewDate": "2025-01-15",
  "adjustmentsRequired": [
    "Large print documents (16pt minimum)",
    "Extended appointment times (allow 90 minutes)"
  ],
  "isActive": true
}
```

**Vulnerability Types:**
- `HEALTH` - Health-related (physical/mental health)
- `FINANCIAL` - Financial vulnerability (low income, high debt)
- `LIFE_EVENT` - Life event (bereavement, divorce, redundancy)
- `CAPABILITY` - Capability limitation (language, literacy, digital skills)
- `RESILIENCE` - Low resilience (multiple vulnerabilities)

**Note:** Vulnerabilities are only applicable to Person clients (Consumer Duty requirement). This array is embedded in `personValue.vulnerabilities` for Person clients only. Corporate and Trust clients do not have vulnerabilities.

---

#### 13.1.12 DataProtectionValue Type

Embedded value type representing GDPR compliance and data protection.

**Key Components:**
- **GDPR Consent** - Data processing, marketing, profiling, third-party sharing consents
- **Privacy Policy** - Version acceptance tracking
- **Data Retention** - Retention period and deletion dates
- **Rights Exercised** - DSAR, rectification, erasure, portability requests
- **Breach Notifications** - Any data breach notifications

See full examples in the client JSON examples above.

---

#### 13.1.13 MarketingPreferencesValue Type

Embedded value type representing marketing consent and preferences.

**Key Components:**
- **Channels** - Email, phone, SMS, post, social media preferences
- **Interests** - Topics of interest (retirement, investments, tax, estate planning)
- **Product Interests** - Product categories of interest
- **Frequency** - Preferred contact frequency per channel
- **TPS/MPS Checks** - Telephone/Mail Preference Service registration

See full examples in the client JSON examples above.

---

#### 13.1.14 EstatePlanningValue Type

Embedded value type representing estate planning information. **Only applicable to Person clients.**

**Key Components:**
- **Will** - Will details, executors, beneficiaries, review dates
- **Power of Attorney** - LPA for property/finance and health/welfare
- **Gifts** - Annual exemption usage, PETs, regular gifts from income
- **Trusts** - Trust structures and beneficiaries
- **IHT Estimate** - Inheritance tax calculation with nil-rate bands
- **Life Insurance in Trust** - Trust-based life insurance policies

See full example in the Person Client JSON above.

---

#### 13.1.15 FinancialProfileValue Type

Embedded value type representing client financial snapshot and computed wealth metrics. **Value type** with no identity, embedded in Client aggregate root.

**Purpose:** Store client financial position including income, net worth, and computed asset totals from arrangements.

**Type Classification:** Value Type (no identity, embedded in Client)

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `grossAnnualIncome` | MoneyValue | No | Individual's gross annual income (Person only) or company revenue (Corporate only) |
| `householdIncome` | MoneyValue | No | Combined household income (Person only) |
| `netWorth` | MoneyValue | No | Individual/entity net worth (assets - liabilities) |
| `householdNetWorth` | MoneyValue | No | Combined household net worth (Person only) |
| `totalAssets` | MoneyValue | No | **Computed** - Sum of all assets from arrangements (read-only) |
| `totalJointAssets` | MoneyValue | No | **Computed** - Sum of jointly held assets (read-only) |
| `calculatedAt` | timestamp | No | When financial metrics were last calculated |
| `lastReviewDate` | date | No | When financial position was last reviewed with client |

**Applicability by Client Type:**

- **Person clients:** All fields applicable
- **Corporate clients:** Only `grossAnnualIncome`, `netWorth`, `totalAssets` applicable (no household fields)
- **Trust clients:** Only `netWorth`, `totalAssets` applicable

**Example (Person Client):**

```json
{
  "financialProfile": {
    "grossAnnualIncome": {
      "amount": 75000.00,
      "currency": { "code": "GBP", "display": "British Pound", "symbol": "£" }
    },
    "householdIncome": {
      "amount": 120000.00,
      "currency": { "code": "GBP" }
    },
    "netWorth": {
      "amount": 450000.00,
      "currency": { "code": "GBP" }
    },
    "householdNetWorth": {
      "amount": 650000.00,
      "currency": { "code": "GBP" }
    },
    "totalAssets": {
      "amount": 500000.00,
      "currency": { "code": "GBP" }
    },
    "totalJointAssets": {
      "amount": 200000.00,
      "currency": { "code": "GBP" }
    },
    "calculatedAt": "2026-02-18T10:30:00Z",
    "lastReviewDate": "2026-02-18"
  }
}
```

**Validation Rules:**

- `totalAssets` and `totalJointAssets` are computed fields (read-only)
- All monetary amounts must be >= 0
- For Person clients: `householdIncome` >= `grossAnnualIncome` (if both provided)
- For Person clients: `householdNetWorth` >= `netWorth` (if both provided)
- `calculatedAt` is automatically set when computed fields are recalculated
- `lastReviewDate` should be set when financial position is reviewed with client

**Computed Field Calculation:**

- `totalAssets` = Sum of all asset values from arrangements (bank accounts, investments, pensions, properties, etc.)
- `totalJointAssets` = Sum of asset values where ownership = "Joint" or "JointTenants"

---

#### 13.1.16 TerritorialProfileValue Type

Embedded value type representing territorial status, residency, domicile, and citizenship information. **Value type** with no identity, embedded in Client aggregate root.

**Purpose:** Store territorial status, tax residency, domicile, and citizenship information for all client types (Person, Corporate, Trust).

**Type Classification:** Value Type (no identity, embedded in Client)

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `ukResident` | boolean | No | UK resident for tax purposes (HMRC definition) |
| `ukDomicile` | boolean | No | **Computed** - UK domiciled (countryOfDomicile.code === "GB") |
| `expatriate` | boolean | No | Is expatriate (living outside country of origin) - Person only |
| `countryOfBirth` | CodedValue | No | Country of birth (ISO 3166-1) - Person only |
| `placeOfBirth` | string | No | City/town of birth - Person only |
| `countryOfResidence` | CodedValue | No | Current country of residence (ISO 3166-1) - Person only |
| `countryOfDomicile` | CodedValue | No | Country of domicile for tax purposes (ISO 3166-1) - Person only |
| `countryOfOrigin` | CodedValue | No | Country of origin/nationality (Person), country of incorporation (Corporate), or jurisdiction of trust (Trust) (ISO 3166-1) |
| `countriesOfCitizenship` | CitizenshipValue[] | No | Array of citizenship countries (supports dual/multiple citizenship) - Person only |

**CitizenshipValue Structure:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `country` | CodedValue | Yes | Country of citizenship (ISO 3166-1) |
| `isPrimary` | boolean | No | Primary citizenship |
| `acquisitionDate` | date | No | Date citizenship acquired |
| `acquisitionMethod` | CodedValue | No | How acquired (Birth/Naturalization/Descent/Marriage) |

**Example (Person Client):**

```json
{
  "territorialProfile": {
    "ukResident": true,
    "ukDomicile": true,
    "expatriate": false,
    "countryOfBirth": {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    },
    "placeOfBirth": "London",
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
    "countryOfOrigin": {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    },
    "countriesOfCitizenship": [
      {
        "country": {
          "code": "GB",
          "display": "United Kingdom",
          "alpha3": "GBR"
        },
        "isPrimary": true,
        "acquisitionDate": "1980-05-15",
        "acquisitionMethod": {
          "code": "BIRTH",
          "display": "Birth"
        }
      }
    ]
  }
}
```

**Example (Corporate Client):**

```json
{
  "territorialProfile": {
    "ukResident": true,
    "countryOfOrigin": {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    }
  }
}
```

**Example (Trust Client):**

```json
{
  "territorialProfile": {
    "ukResident": true,
    "countryOfOrigin": {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    }
  }
}
```

**Applicability by Client Type:**

- **Person clients:** All fields applicable
  - `countryOfOrigin` represents nationality/citizenship country
  - Full territorial profile including birth, residence, domicile, and citizenship
- **Corporate clients:** Limited fields applicable
  - `ukResident` - for UK tax resident status
  - `countryOfOrigin` - country of incorporation
- **Trust clients:** Limited fields applicable
  - `ukResident` - for UK tax resident status
  - `countryOfOrigin` - jurisdiction where trust is registered/established

**Validation Rules:**

- `ukDomicile` is computed from `countryOfDomicile.code === "GB"` (read-only)
- For Person clients: `ukResident` should align with `countryOfResidence.code === "GB"` (but may differ for tax purposes)
- `expatriate` should be `true` if `countryOfResidence` differs from `countryOfOrigin`
- At least one citizenship is recommended for Person clients
- If multiple citizenships exist, exactly one should have `isPrimary: true`
- All country codes must be valid ISO 3166-1 codes (alpha-2 format)
- `acquisitionMethod` must be one of: Birth, Naturalization, Descent, Marriage

**Notes:**

- Territorial profile applies to all client types but with different field relevance
- For Person clients, this supports Consumer Duty requirements for understanding client circumstances
- For Corporate and Trust clients, primarily used for tax residency determination
- `ukDomicile` is computed to ensure consistency with `countryOfDomicile`
- Supports dual/multiple citizenship scenarios common in international clients

---

#### 13.1.17 Validation Rules by Client Type

**Person Client:**
- `personValue` is required
- `personValue.firstName` is required
- `personValue.lastName` is required
- `personValue.dateOfBirth` is required
- `personValue.vulnerabilities` is optional array (Consumer Duty)
- `estatePlanning` is optional but only valid for Person
- `spouseRef` is optional but only valid for Person
- `dependants` is optional but only valid for Person
- `territorialProfile` is optional but all Person-specific fields are available
- `territorialProfile.ukDomicile` is computed from `territorialProfile.countryOfDomicile.code === "GB"`
- `territorialProfile.countriesOfCitizenship` should have exactly one with `isPrimary: true` if multiple citizenships
- `financialProfile.householdIncome` >= `financialProfile.grossAnnualIncome` (if both provided)
- `financialProfile.householdNetWorth` >= `financialProfile.netWorth` (if both provided)
- `financialProfile.householdIncome` and `financialProfile.householdNetWorth` only valid for Person

**Corporate Client:**
- `corporateValue` is required
- `corporateValue.companyName` is required
- `corporateValue.directors` must have at least 1 director
- `corporateValue.shareholders` must have at least 1 shareholder
- `territorialProfile` is optional but only `ukResident` and `countryOfOrigin` fields are applicable
- `territorialProfile.countryOfOrigin` represents country of incorporation
- `personValue.vulnerabilities` must not be present (vulnerabilities only for Person clients)
- `estatePlanning` must not be present
- `spouseRef` must not be present
- `dependants` must not be present
- `financialProfile.householdIncome` must not be present
- `financialProfile.householdNetWorth` must not be present

**Trust Client:**
- `trustValue` is required
- `trustValue.trustName` is required
- `trustValue.trustees` must have at least 1 trustee
- `trustValue.beneficiaries` must have at least 1 beneficiary
- `territorialProfile` is optional but only `ukResident` and `countryOfOrigin` fields are applicable
- `territorialProfile.countryOfOrigin` represents jurisdiction where trust is registered
- `personValue.vulnerabilities` must not be present (vulnerabilities only for Person clients)
- `estatePlanning` must not be present
- `spouseRef` must not be present
- `dependants` must not be present
- `financialProfile.grossAnnualIncome` must not be present
- `financialProfile.householdIncome` must not be present
- `financialProfile.householdNetWorth` must not be present

**FinancialProfileValue Validation (All Client Types):**
- `totalAssets` and `totalJointAssets` are read-only computed fields
- All monetary amounts must be >= 0
- Computed fields are automatically calculated and cannot be set via API

---

#### 13.1.18 Usage Examples

**Creating a Person Client:**

```http
POST /api/v1/clients
Content-Type: application/json

{
  "clientNumber": "C00001234",
  "clientType": "Person",
  "personValue": {
    "title": { "code": "MR", "display": "Mr" },
    "firstName": "John",
    "lastName": "Smith",
    "dateOfBirth": "1980-05-15",
    "gender": { "code": "M", "display": "Male" },
    "vulnerabilities": []
  },
  "territorialProfile": {
    "ukResident": true,
    "ukDomicile": true,
    "countryOfOrigin": { "code": "GB", "display": "United Kingdom", "alpha3": "GBR" },
    "countryOfResidence": { "code": "GB", "display": "United Kingdom", "alpha3": "GBR" }
  },
  "addresses": [
    {
      "addressType": { "code": "RES", "display": "Residential" },
      "line1": "123 Main Street",
      "city": "London",
      "postcode": "SW1A 1AA",
      "country": { "code": "GB", "display": "United Kingdom", "alpha3": "GBR" },
      "isPrimary": true,
      "fromDate": "2020-01-15"
    }
  ],
  "contacts": [
    {
      "contactType": { "code": "EMAIL", "display": "Email" },
      "value": "john.smith@example.com",
      "isPrimary": true
    }
  ],
  "financialProfile": {
    "grossAnnualIncome": {
      "amount": 75000.00,
      "currency": { "code": "GBP" }
    },
    "netWorth": {
      "amount": 450000.00,
      "currency": { "code": "GBP" }
    },
    "lastReviewDate": "2026-02-18"
  }
}
```

**Creating a Corporate Client:**

```http
POST /api/v1/clients
Content-Type: application/json

{
  "clientNumber": "C00005678",
  "clientType": "Corporate",
  "corporateValue": {
    "companyName": "TechVenture Solutions Ltd",
    "tradingName": "TechVenture",
    "registrationNumber": "09876543",
    "incorporationDate": "2015-03-20",
    "companyType": { "code": "LTD", "display": "Private Limited Company" },
    "countryOfIncorporation": { "code": "GB", "display": "United Kingdom", "alpha3": "GBR" }
  },
  "addresses": [
    {
      "addressType": { "code": "REGISTERED", "display": "Registered Office" },
      "line1": "Tech Park Building 5",
      "city": "London",
      "postcode": "EC2A 4DN",
      "country": { "code": "GB", "display": "United Kingdom", "alpha3": "GBR" },
      "isPrimary": true,
      "fromDate": "2015-03-20"
    }
  ],
  "contacts": [
    {
      "contactType": { "code": "EMAIL", "display": "Email" },
      "value": "info@techventure.com",
      "isPrimary": true
    }
  ],
  "financialProfile": {
    "grossAnnualIncome": {
      "amount": 3500000.00,
      "currency": { "code": "GBP" }
    },
    "netWorth": {
      "amount": 1250000.00,
      "currency": { "code": "GBP" }
    },
    "lastReviewDate": "2026-02-18"
  }
}
```

**Creating a Trust Client:**

```http
POST /api/v1/clients
Content-Type: application/json

{
  "clientNumber": "C00009999",
  "clientType": "Trust",
  "trustValue": {
    "trustName": "The Smith Family Discretionary Trust",
    "trustType": { "code": "DISCRETIONARY", "display": "Discretionary Trust" },
    "settlementDate": "2018-04-15",
    "trustRegistrationNumber": "TRN12345678",
    "settlor": {
      "personRef": {
        "id": "client-1000",
        "name": "William Smith"
      },
      "settlementAmount": {
        "amount": 500000.00,
        "currency": { "code": "GBP", "display": "British Pound", "symbol": "£" }
      },
      "settlementDate": "2018-04-15"
    }
  },
  "addresses": [
    {
      "addressType": { "code": "TRUST_CORRESPONDENCE", "display": "Trust Correspondence Address" },
      "line1": "Harrison & Partners Solicitors",
      "city": "London",
      "postcode": "WC2N 5DU",
      "country": { "code": "GB", "display": "United Kingdom", "alpha3": "GBR" },
      "isPrimary": true,
      "fromDate": "2018-04-15"
    }
  ],
  "contacts": [
    {
      "contactType": { "code": "EMAIL", "display": "Email" },
      "value": "trustees@smithfamilytrust.com",
      "isPrimary": true
    }
  ],
  "financialProfile": {
    "netWorth": {
      "amount": 650000.00,
      "currency": { "code": "GBP" }
    },
    "lastReviewDate": "2026-02-18"
  }
}
```

---

### 13.2 FactFind Contract


**IMPORTANT NOTE - v2.1 Enhancement:**
The FactFind Contract now includes an embedded `atrAssessment` object containing:
- 15 standard ATR questions with answers
- 45 supplementary questions
- System-generated risk profiles (3 adjacent options)
- Client's chosen risk profile
- Capacity for loss assessment
- Client and adviser declarations
- Review dates and history tracking

See Section 10 for complete ATR API documentation and example payloads.

**Example of embedded ATR in FactFind:**
```json
{
  "id": "factfind-123",
  "client": {...},
  "status": "InProgress",
  "atrAssessment": {
    "templateRef": { "id": "atr-template-v5", "version": "5.0", "name": "FCA Standard ATR 2025" },
    "assessmentDate": "2026-02-18T10:30:00Z",
    "questions": [ /* 15 questions */ ],
    "supplementaryQuestions": [ /* 45 questions */ ],
    "riskProfiles": {
      "generated": [ /* 3 adjacent profiles */ ],
      "chosen": { "riskRating": "Balanced", "riskScore": 45, "chosenBy": "Client" }
    },
    "capacityForLoss": { "canAffordLosses": true, "emergencyFundMonths": 6 },
    "declarations": { /* client and adviser declarations */ },
    "completedAt": "2026-02-18T11:10:00Z"
  },
  "createdAt": "2026-02-15T09:00:00Z",
  "updatedAt": "2026-02-18T11:10:00Z"
}
```

For the complete FactFind Contract with full ATR assessment example, see Section 10.3.1 or Section 13.2 in the latest version.


The `FactFind` contract (also known as ADVICE_CASE) represents a fact-finding session and aggregate root for circumstances discovery.

**Reference Type:** FactFind is a reference type with identity (has `id` field).

Complete fact find aggregate root with summary calculations.

**ENHANCED v2.2 - Industry-Aligned Value Types:**
The FactFind contract has been refactored to group related fields into industry-standard value types:
- **MeetingDetailsValue** (Section 13.2.1) - Meeting/consultation information (FCA/MiFID II terminology)
- **FinancialSummaryValue** (Section 13.2.2) - Computed financial totals and metrics (read-only snapshot)
- **AssetHoldingsValue** (Section 13.2.3) - Indicators of what financial products client holds (portfolio management terminology)
- **InvestmentCapacityValue** (Section 13.2.4) - Client's capacity and budget for new investments (FCA suitability terminology)
- **CompletionStatusValue** (Section 13.2.5) - Completion tracking and compliance checks

This grouping improves clarity, aligns with industry standards, and makes the contract easier to understand and maintain.

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
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },

  "meetingDetails": {
    "meetingDate": "2026-02-16",
    "meetingType": {
      "code": "INIT",
      "display": "Initial Consultation"
    },
    "clientsPresent": "BothClients",
    "othersPresent": false,
    "othersPresentDetails": null,
    "scopeOfAdvice": {
      "retirementPlanning": true,
      "savingsAndInvestments": true,
      "protection": true,
      "mortgage": false,
      "estatePlanning": false
    }
  },

  "financialSummary": {
    "income": {
      "annualGross": {
        "amount": 120000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "monthlyNet": {
        "amount": 7500.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "netRelevantEarnings": {
        "amount": 110000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    },
    "expenditure": {
      "monthlyTotal": {
        "amount": 4500.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "monthlyDisposable": {
        "amount": 3000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    },
    "liquidity": {
      "totalFundsAvailable": {
        "amount": 85000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "availableForAdvice": {
        "amount": 70000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    },
    "taxation": {
      "highestRate": {
        "code": "HIGHER",
        "display": "Higher Rate (40%)",
        "rate": 0.40
      }
    },
    "sourceOfFunds": "Savings from employment income over past 5 years",
    "calculatedAt": "2026-02-16T15:45:00Z"
  },

  "assetHoldings": {
    "employment": {
      "hasEmployments": true
    },
    "pensions": {
      "hasPersonalPension": true,
      "hasMoneyPurchasePension": true,
      "hasDefinedBenefitPension": false,
      "hasAnnuity": false
    },
    "investments": {
      "hasSavings": true,
      "hasInvestments": true
    },
    "borrowing": {
      "hasMortgage": true,
      "hasEquityRelease": false,
      "hasOtherLiabilities": true
    },
    "protection": {
      "hasProtection": true
    },
    "credit": {
      "hasAdverseCredit": false,
      "hasBeenRefusedCredit": false
    },
    "other": {
      "hasOtherAssets": true
    }
  },

  "investmentCapacity": {
    "emergencyFund": {
      "required": {
        "amount": 11400.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "committed": {
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
      "status": "Adequate"
    },
    "regularContributions": {
      "agreedMonthlyBudget": {
        "amount": 1000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "sustainabilityRating": "High"
    },
    "lumpSumInvestment": {
      "agreedAmount": {
        "amount": 50000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "sourceOfFunds": "Savings from employment"
    },
    "futureChanges": {
      "incomeChangesExpected": false,
      "expenditureChangesExpected": false,
      "details": null
    },
    "assessmentDate": "2026-02-16"
  },

  "completionStatus": {
    "isComplete": false,
    "status": {
      "code": "INPROG",
      "display": "In Progress"
    },
    "completionDate": null,
    "declarationSignedDate": null,
    "compliance": {
      "idCheckedDate": "2026-02-16",
      "amlCheckedDate": "2026-02-16",
      "allChecksComplete": true
    }
  },

  "atrAssessment": {
    "templateRef": {
      "id": "atr-template-v5",
      "version": "5.0",
      "name": "FCA Standard ATR 2025"
    },
    "assessmentDate": "2026-02-16T10:30:00Z",
    "questions": [
      {
        "questionId": "Q1",
        "text": "What is your investment experience?",
        "answer": {
          "code": "EXPERIENCED",
          "display": "Experienced - I have invested for more than 5 years"
        },
        "score": 4
      }
    ],
    "supplementaryQuestions": [],
    "riskProfiles": {
      "generated": [
        {
          "riskRating": "Cautious",
          "riskScore": 35,
          "description": "Lower risk, lower potential returns"
        },
        {
          "riskRating": "Balanced",
          "riskScore": 45,
          "description": "Medium risk, medium potential returns"
        },
        {
          "riskRating": "Adventurous",
          "riskScore": 55,
          "description": "Higher risk, higher potential returns"
        }
      ],
      "chosen": {
        "riskRating": "Balanced",
        "riskScore": 45,
        "chosenBy": "Client",
        "chosenAt": "2026-02-16T10:45:00Z"
      }
    },
    "capacityForLoss": {
      "canAffordLosses": true,
      "emergencyFundMonths": 6,
      "assessmentNotes": "Client has adequate emergency fund and stable income"
    },
    "declarations": {
      "clientDeclaration": {
        "agreed": true,
        "agreedAt": "2026-02-16T10:50:00Z"
      },
      "adviserDeclaration": {
        "agreed": true,
        "agreedAt": "2026-02-16T11:00:00Z",
        "adviserRef": {
          "id": "adviser-789",
          "name": "Jane Doe"
        }
      }
    },
    "completedAt": "2026-02-16T11:10:00Z",
    "nextReviewDate": "2027-02-16"
  },

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
| `adviserRef` | AdviserRef | required | updatable | included | Reference type: Primary adviser |
| **`meetingDetails`** | **MeetingDetailsValue** | **required** | **updatable** | **included** | **Value type group (Section 13.2.1)** |
| **`financialSummary`** | **FinancialSummaryValue** | **ignored** | **ignored** | **included** | **read-only, computed value type (Section 13.2.2)** |
| **`assetHoldings`** | **AssetHoldingsValue** | **ignored** | **partial** | **included** | **Mostly computed, credit fields updatable (Section 13.2.3)** |
| **`investmentCapacity`** | **InvestmentCapacityValue** | **optional** | **updatable** | **included** | **Value type group (Section 13.2.4)** |
| **`completionStatus`** | **CompletionStatusValue** | **optional** | **updatable** | **included** | **Value type group (Section 13.2.5)** |
| `atrAssessment` | ATRAssessmentValue | optional | updatable | included | Embedded ATR from v2.1 (Section 10) |
| `notes` | string | optional | updatable | included | - |
| `additionalNotes` | string | optional | updatable | included | - |
| `customQuestions` | array | optional | updatable | included | - |
| `createdAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `updatedAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `_links` | object | ignored | ignored | included | read-only, HATEOAS links |

**Field Mapping from v2.1 to v2.2:**

| v2.1 Root Field | v2.2 Location | Behavior |
|----------------|---------------|----------|
| `dateOfMeeting` | `meetingDetails.meetingDate` | updatable |
| `typeOfMeeting` | `meetingDetails.meetingType` | updatable |
| `clientsPresent` | `meetingDetails.clientsPresent` | updatable |
| `anybodyElsePresent` | `meetingDetails.othersPresent` | updatable |
| `anybodyElsePresentDetails` | `meetingDetails.othersPresentDetails` | updatable |
| `scopeOfAdvice` | `meetingDetails.scopeOfAdvice` | updatable |
| `totalEarnedAnnualIncomeGross` | `financialSummary.income.annualGross` | read-only, computed |
| `totalNetMonthlyIncome` | `financialSummary.income.monthlyNet` | read-only, computed |
| `totalNetRelevantEarnings` | `financialSummary.income.netRelevantEarnings` | read-only, computed |
| `totalMonthlyExpenditure` | `financialSummary.expenditure.monthlyTotal` | read-only, computed |
| `totalMonthlyDisposableIncome` | `financialSummary.expenditure.monthlyDisposable` | read-only, computed |
| `totalFundsAvailable` | `financialSummary.liquidity.totalFundsAvailable` | read-only, computed |
| `totalLumpSumAvailableForAdvice` | `financialSummary.liquidity.availableForAdvice` | read-only, computed |
| `highestTaxRate` | `financialSummary.taxation.highestRate` | read-only, computed |
| `sourceOfInvestmentFunds` | `financialSummary.sourceOfFunds` | updatable |
| `hasEmployments` | `assetHoldings.employment.hasEmployments` | read-only, computed |
| `hasDcPensionPersonal` | `assetHoldings.pensions.hasPersonalPension` | read-only, computed |
| `hasDcPensionMoneyPurchase` | `assetHoldings.pensions.hasMoneyPurchasePension` | read-only, computed |
| `hasDbPension` | `assetHoldings.pensions.hasDefinedBenefitPension` | read-only, computed |
| `hasAnnuity` | `assetHoldings.pensions.hasAnnuity` | read-only, computed |
| `hasSavings` | `assetHoldings.investments.hasSavings` | read-only, computed |
| `hasInvestments` | `assetHoldings.investments.hasInvestments` | read-only, computed |
| `hasExistingMortgage` | `assetHoldings.borrowing.hasMortgage` | read-only, computed |
| `hasEquityRelease` | `assetHoldings.borrowing.hasEquityRelease` | read-only, computed |
| `hasLiabilities` | `assetHoldings.borrowing.hasOtherLiabilities` | read-only, computed |
| `hasProtection` | `assetHoldings.protection.hasProtection` | read-only, computed |
| `hasAdverseCredit` | `assetHoldings.credit.hasAdverseCredit` | updatable |
| `hasBeenRefusedCredit` | `assetHoldings.credit.hasBeenRefusedCredit` | updatable |
| `hasAssets` | `assetHoldings.other.hasOtherAssets` | read-only, computed |
| `emergencyFund` | `investmentCapacity.emergencyFund` | updatable |
| `agreedMonthlyBudget` | `investmentCapacity.regularContributions.agreedMonthlyBudget` | updatable |
| `agreedSingleInvestmentAmount` | `investmentCapacity.lumpSumInvestment.agreedAmount` | updatable |
| `incomeChangesExpected` | `investmentCapacity.futureChanges.incomeChangesExpected` | updatable |
| `expenditureChangesExpected` | `investmentCapacity.futureChanges.expenditureChangesExpected` | updatable |
| `isComplete` | `completionStatus.isComplete` | read-only, computed |
| `status` | `completionStatus.status` | updatable |
| `dateFactFindCompleted` | `completionStatus.completionDate` | updatable |
| `dateDeclarationSigned` | `completionStatus.declarationSignedDate` | updatable |
| `dateIdAmlChecked` | `completionStatus.compliance.idCheckedDate` | updatable |

**Usage Examples:**

**Creating a FactFind (POST /api/v1/factfinds):**
```json
{
  "clientRef": { "id": "client-123" },
  "jointClientRef": { "id": "client-124" },
  "adviserRef": { "id": "adviser-789" },
  "meetingDetails": {
    "meetingDate": "2026-02-16",
    "meetingType": {
      "code": "INIT",
      "display": "Initial Consultation"
    },
    "scopeOfAdvice": {
      "retirementPlanning": true,
      "protection": true
    }
  },
  "investmentCapacity": {
    "regularContributions": {
      "agreedMonthlyBudget": {
        "amount": 1000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    }
  }
}
```

**Updating a FactFind (PATCH /api/v1/factfinds/456):**
```json
{
  "completionStatus": {
    "status": {
      "code": "COM",
      "display": "Complete"
    },
    "completionDate": "2026-02-16"
  },
  "investmentCapacity": {
    "regularContributions": {
      "agreedMonthlyBudget": {
        "amount": 1500.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    }
  }
}
```

---

#### 13.2.1 MeetingDetailsValue Type

The `MeetingDetailsValue` groups all information related to the consultation meeting itself. This aligns with FCA and MiFID II requirements for documenting client interactions.

**Purpose:** Capture meeting/consultation information as required for regulatory compliance and audit trails.

**Structure:**
```json
{
  "meetingDate": "2026-02-16",
  "meetingType": {
    "code": "INIT",
    "display": "Initial Consultation"
  },
  "clientsPresent": "BothClients",
  "othersPresent": false,
  "othersPresentDetails": null,
  "scopeOfAdvice": {
    "retirementPlanning": true,
    "savingsAndInvestments": true,
    "protection": true,
    "mortgage": false,
    "estatePlanning": false
  }
}
```

**Field Definitions:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `meetingDate` | date | Yes | Date when the fact-finding meeting took place |
| `meetingType` | CodedValue | Yes | Type of meeting: Initial/Review/Annual |
| `clientsPresent` | string | No | Who attended: BothClients/ClientOnly/JointOnly |
| `othersPresent` | boolean | No | Whether anyone else was present besides clients and adviser |
| `othersPresentDetails` | string | No | Details of who else was present (if othersPresent = true) |
| `scopeOfAdvice` | object | No | Areas of advice covered in this fact find session |

**Validation Rules:**
- `meetingDate` cannot be in the future
- If `othersPresent` is true, `othersPresentDetails` should be provided
- At least one `scopeOfAdvice` area should be true

---

#### 13.2.2 FinancialSummaryValue Type

The `FinancialSummaryValue` provides a read-only snapshot of the client's financial position, computed from child entities. This aligns with wealth management platform terminology.

**Purpose:** Provide computed financial totals and metrics as a convenience for UI display and decision-making, without requiring clients to traverse child collections.

**Behavior:** This is a **read-only** value type. All fields are computed by the system and cannot be updated directly. To change these values, update the underlying Income and Expenditure entities.

**Structure:**
```json
{
  "income": {
    "annualGross": {
      "amount": 120000.00,
      "currency": { "code": "GBP", "display": "British Pound", "symbol": "£" }
    },
    "monthlyNet": {
      "amount": 7500.00,
      "currency": { "code": "GBP" }
    },
    "netRelevantEarnings": {
      "amount": 110000.00,
      "currency": { "code": "GBP" }
    }
  },
  "expenditure": {
    "monthlyTotal": {
      "amount": 4500.00,
      "currency": { "code": "GBP" }
    },
    "monthlyDisposable": {
      "amount": 3000.00,
      "currency": { "code": "GBP" }
    }
  },
  "liquidity": {
    "totalFundsAvailable": {
      "amount": 85000.00,
      "currency": { "code": "GBP" }
    },
    "availableForAdvice": {
      "amount": 70000.00,
      "currency": { "code": "GBP" }
    }
  },
  "taxation": {
    "highestRate": {
      "code": "HIGHER",
      "display": "Higher Rate (40%)",
      "rate": 0.40
    }
  },
  "sourceOfFunds": "Savings from employment income over past 5 years",
  "calculatedAt": "2026-02-16T15:45:00Z"
}
```

**Field Definitions:**

| Field | Computed From | Description |
|-------|---------------|-------------|
| `income.annualGross` | Sum of all Employment Income (gross, annualized) | Total earned annual income before tax |
| `income.monthlyNet` | Sum of all Income (net, monthly) | Total net monthly income after tax |
| `income.netRelevantEarnings` | Computed from earned income | Total net relevant earnings for pension purposes |
| `expenditure.monthlyTotal` | Sum of all Expenditure (monthly) | Total monthly expenditure |
| `expenditure.monthlyDisposable` | income.monthlyNet - expenditure.monthlyTotal | Monthly disposable income (surplus/deficit) |
| `liquidity.totalFundsAvailable` | Sum of liquid Assets | Total funds available across all accounts |
| `liquidity.availableForAdvice` | totalFundsAvailable - emergencyFund.committed | Funds available after emergency fund |
| `taxation.highestRate` | Derived from income bands | Highest tax rate applicable to client |
| `sourceOfFunds` | User-provided | Source of investment funds (AML requirement) |
| `calculatedAt` | System timestamp | When these calculations were last performed |

**Calculation Rules:**
- All monetary values use the same currency across the fact find
- Income values are normalized to annual/monthly as indicated
- Disposable income can be negative (deficit scenario)
- Emergency fund committed amount is subtracted from available funds
- Calculations are performed asynchronously when Income/Expenditure entities change

---

#### 13.2.3 AssetHoldingsValue Type

The `AssetHoldingsValue` provides boolean indicators of what financial products and arrangements the client currently holds. This uses standard portfolio management terminology.

**Purpose:** Quick overview of client's existing product holdings to guide advice scope and product recommendations.

**Behavior:** Most fields are **read-only** (computed from child Arrangement entities). The `credit` fields (`hasAdverseCredit`, `hasBeenRefusedCredit`) are **updatable** as they're typically captured during the fact-finding interview.

**Structure:**
```json
{
  "employment": {
    "hasEmployments": true
  },
  "pensions": {
    "hasPersonalPension": true,
    "hasMoneyPurchasePension": true,
    "hasDefinedBenefitPension": false,
    "hasAnnuity": false
  },
  "investments": {
    "hasSavings": true,
    "hasInvestments": true
  },
  "borrowing": {
    "hasMortgage": true,
    "hasEquityRelease": false,
    "hasOtherLiabilities": true
  },
  "protection": {
    "hasProtection": true
  },
  "credit": {
    "hasAdverseCredit": false,
    "hasBeenRefusedCredit": false
  },
  "other": {
    "hasOtherAssets": true
  }
}
```

**Field Definitions:**

| Field | Computed From | Updatable | Description |
|-------|---------------|-----------|-------------|
| `employment.hasEmployments` | Employment entities exist | No | Client has employment records |
| `pensions.hasPersonalPension` | Arrangement type = Personal Pension | No | Has personal pension plan |
| `pensions.hasMoneyPurchasePension` | Arrangement type = Money Purchase | No | Has money purchase pension |
| `pensions.hasDefinedBenefitPension` | Arrangement type = DB Pension | No | Has defined benefit pension |
| `pensions.hasAnnuity` | Arrangement type = Annuity | No | Has annuity in payment |
| `investments.hasSavings` | Arrangement type = Savings | No | Has savings accounts |
| `investments.hasInvestments` | Arrangement type = Investment | No | Has investment accounts/ISAs |
| `borrowing.hasMortgage` | Liability type = Mortgage | No | Has active mortgage |
| `borrowing.hasEquityRelease` | Arrangement type = Equity Release | No | Has equity release product |
| `borrowing.hasOtherLiabilities` | Liability entities exist | No | Has other liabilities |
| `protection.hasProtection` | Arrangement type = Protection | No | Has protection policies |
| `credit.hasAdverseCredit` | User input | **Yes** | Client has adverse credit history |
| `credit.hasBeenRefusedCredit` | User input | **Yes** | Client has been refused credit |
| `other.hasOtherAssets` | Asset entities exist | No | Has other assets |

**Usage Notes:**
- These flags are typically updated automatically when Arrangement entities are created/deleted
- The credit flags must be explicitly set during fact-finding as they're self-declared
- Use these flags in UI to conditionally display sections of the fact find

---

#### 13.2.4 InvestmentCapacityValue Type

The `InvestmentCapacityValue` captures the client's capacity and budget for new investments or advice. This aligns with FCA suitability terminology around "capacity for loss" and "investment capacity."

**Purpose:** Assess client's financial capacity to make new investments, considering emergency fund requirements and ongoing commitments.

**Structure:**
```json
{
  "emergencyFund": {
    "required": {
      "amount": 11400.00,
      "currency": { "code": "GBP" }
    },
    "committed": {
      "amount": 15000.00,
      "currency": { "code": "GBP" }
    },
    "shortfall": {
      "amount": 0.00,
      "currency": { "code": "GBP" }
    },
    "status": "Adequate"
  },
  "regularContributions": {
    "agreedMonthlyBudget": {
      "amount": 1000.00,
      "currency": { "code": "GBP" }
    },
    "sustainabilityRating": "High"
  },
  "lumpSumInvestment": {
    "agreedAmount": {
      "amount": 50000.00,
      "currency": { "code": "GBP" }
    },
    "sourceOfFunds": "Savings from employment"
  },
  "futureChanges": {
    "incomeChangesExpected": false,
    "expenditureChangesExpected": false,
    "details": null
  },
  "assessmentDate": "2026-02-16"
}
```

**Field Definitions:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `emergencyFund.required` | MoneyValue | No | Calculated emergency fund requirement (typically 3-6 months expenses) |
| `emergencyFund.committed` | MoneyValue | No | Amount client has committed to emergency fund |
| `emergencyFund.shortfall` | MoneyValue | No | Shortfall if committed < required (computed) |
| `emergencyFund.status` | string | No | Adequate/Shortfall/Not Set |
| `regularContributions.agreedMonthlyBudget` | MoneyValue | No | Monthly amount client agrees to invest regularly |
| `regularContributions.sustainabilityRating` | string | No | High/Medium/Low - sustainability assessment |
| `lumpSumInvestment.agreedAmount` | MoneyValue | No | Lump sum amount client agrees to invest |
| `lumpSumInvestment.sourceOfFunds` | string | No | Where the lump sum comes from (AML) |
| `futureChanges.incomeChangesExpected` | boolean | No | Whether income changes are expected |
| `futureChanges.expenditureChangesExpected` | boolean | No | Whether expenditure changes are expected |
| `futureChanges.details` | string | No | Details of expected changes |
| `assessmentDate` | date | No | When this assessment was completed |

**Validation Rules:**
- `emergencyFund.shortfall` is computed: max(0, required - committed)
- `emergencyFund.status` is computed based on shortfall
- `regularContributions.agreedMonthlyBudget` should not exceed monthly disposable income
- If future changes expected, details should be provided

**Emergency Fund Calculation:**
- Default requirement: 3 months of monthly expenditure
- Can be overridden based on client circumstances (e.g., stable employment = 3 months, self-employed = 6 months)
- Shortfall must be addressed before recommending investments (FCA requirement)

---

#### 13.2.5 CompletionStatusValue Type

The `CompletionStatusValue` tracks the completion status of the fact find and associated compliance checks.

**Purpose:** Track workflow status and ensure all regulatory compliance checks are completed before advice can be provided.

**Structure:**
```json
{
  "isComplete": false,
  "status": {
    "code": "INPROG",
    "display": "In Progress"
  },
  "completionDate": null,
  "declarationSignedDate": null,
  "compliance": {
    "idCheckedDate": "2026-02-16",
    "amlCheckedDate": "2026-02-16",
    "allChecksComplete": true
  }
}
```

**Field Definitions:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `isComplete` | boolean | No | Whether fact find is complete (computed from status) |
| `status` | CodedValue | No | Current status: Draft/InProgress/Complete/Archived |
| `completionDate` | date | No | Date when fact find was marked complete |
| `declarationSignedDate` | date | No | Date when client signed fact find declaration |
| `compliance.idCheckedDate` | date | No | Date when ID verification was completed |
| `compliance.amlCheckedDate` | date | No | Date when AML checks were completed |
| `compliance.allChecksComplete` | boolean | No | Whether all compliance checks are done (computed) |

**Validation Rules:**
- `isComplete` is computed: true if status.code = "COM" (Complete)
- `compliance.allChecksComplete` is computed: true if both idCheckedDate and amlCheckedDate are set
- Cannot mark fact find complete unless allChecksComplete is true
- `completionDate` is automatically set when status changes to Complete

**Status Codes:**
- `DRAFT` - Initial draft, not yet started
- `INPROG` - In progress
- `COM` - Complete and signed
- `ARCHIVED` - Archived (historical record)

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

### 13.8 Investment Contract

The `Investment` contract extends the Arrangement contract with investment-specific fields for ISAs, GIAs, Bonds, and Investment Trusts.

**Reference Type:** Investment is a reference type with identity (has `id` field).

```json
{
  "id": "investment-789",
  "arrangementId": "arrangement-456",
  "factFindRef": {
    "id": "factfind-123",
    "href": "/api/v1/factfinds/factfind-123",
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
  "arrangementType": {
    "code": "INV",
    "display": "Investment"
  },
  "productType": {
    "code": "ISA",
    "display": "Individual Savings Account"
  },
  "provider": {
    "code": "VANGUARD",
    "display": "Vanguard Asset Management",
    "frnNumber": "123456"
  },
  "policyNumber": "ISA-987654321",
  "accountNumber": "ACC-12345678",
  "planName": "Vanguard ISA Portfolio",
  "startDate": "2020-04-06",
  "maturityDate": null,
  "status": {
    "code": "ACTIVE",
    "display": "Active"
  },
  "investmentType": {
    "code": "STOCKS_SHARES_ISA",
    "display": "Stocks & Shares ISA"
  },
  "isaType": {
    "code": "STOCKS_SHARES",
    "display": "Stocks & Shares ISA"
  },
  "taxYear": "2025/2026",
  "annualIsaAllowance": {
    "amount": 20000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "isaAllowanceUsed": {
    "amount": 15000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "isaAllowanceRemaining": {
    "amount": 5000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "taxWrapperType": {
    "code": "ISA",
    "display": "ISA Tax Wrapper"
  },
  "isTaxable": false,
  "currentValue": {
    "amount": 185000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "valuationDate": "2026-02-16",
  "costBasis": {
    "amount": 150000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "unrealizedGain": {
    "amount": 35000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "unrealizedGainPercentage": 23.33,
  "realizedGain": {
    "amount": 8500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalReturn": {
    "amount": 43500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalReturnPercentage": 29.00,
  "annualizedReturn": 5.87,
  "timeWeightedReturn": 6.12,
  "moneyWeightedReturn": 5.65,
  "inceptionDate": "2020-04-06",
  "yearsHeld": 5.87,
  "assetAllocation": {
    "equities": {
      "percentage": 65.00,
      "value": {
        "amount": 120250.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    },
    "bonds": {
      "percentage": 25.00,
      "value": {
        "amount": 46250.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    },
    "cash": {
      "percentage": 5.00,
      "value": {
        "amount": 9250.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    },
    "alternatives": {
      "percentage": 5.00,
      "value": {
        "amount": 9250.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    }
  },
  "geographicAllocation": {
    "uk": {
      "percentage": 30.00,
      "value": {
        "amount": 55500.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    },
    "northAmerica": {
      "percentage": 45.00,
      "value": {
        "amount": 83250.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    },
    "europe": {
      "percentage": 15.00,
      "value": {
        "amount": 27750.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    },
    "asiaPacific": {
      "percentage": 8.00,
      "value": {
        "amount": 14800.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    },
    "emergingMarkets": {
      "percentage": 2.00,
      "value": {
        "amount": 3700.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    }
  },
  "holdings": [
    {
      "holdingId": "holding-001",
      "isin": "GB00B3X7QG63",
      "sedol": "B3X7QG6",
      "fundName": "Vanguard FTSE Global All Cap Index Fund",
      "ticker": "VWRL",
      "fundType": {
        "code": "INDEX",
        "display": "Index Fund"
      },
      "assetClass": {
        "code": "EQUITY",
        "display": "Equity"
      },
      "units": 15000.00,
      "unitPrice": {
        "amount": 6.25,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "currentValue": {
        "amount": 93750.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "costBasis": {
        "amount": 75000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "unrealizedGain": {
        "amount": 18750.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "unrealizedGainPercentage": 25.00,
      "percentageOfPortfolio": 50.68,
      "ocf": 0.23,
      "lastUpdated": "2026-02-16T16:00:00Z"
    },
    {
      "holdingId": "holding-002",
      "isin": "GB00B4PQW151",
      "sedol": "B4PQW15",
      "fundName": "Vanguard U.K. Government Bond Index Fund",
      "ticker": "VGOV",
      "fundType": {
        "code": "INDEX",
        "display": "Index Fund"
      },
      "assetClass": {
        "code": "BOND",
        "display": "Fixed Income"
      },
      "units": 28000.00,
      "unitPrice": {
        "amount": 1.65,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "currentValue": {
        "amount": 46200.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "costBasis": {
        "amount": 42000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "unrealizedGain": {
        "amount": 4200.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "unrealizedGainPercentage": 10.00,
      "percentageOfPortfolio": 24.97,
      "ocf": 0.15,
      "lastUpdated": "2026-02-16T16:00:00Z"
    },
    {
      "holdingId": "holding-003",
      "isin": "GB00BPN5P238",
      "sedol": "BPN5P23",
      "fundName": "Vanguard LifeStrategy 60% Equity Fund",
      "ticker": "VLS60",
      "fundType": {
        "code": "MIXED",
        "display": "Mixed Asset Fund"
      },
      "assetClass": {
        "code": "MIXED",
        "display": "Mixed Assets"
      },
      "units": 12500.00,
      "unitPrice": {
        "amount": 2.80,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "currentValue": {
        "amount": 35000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "costBasis": {
        "amount": 25000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "unrealizedGain": {
        "amount": 10000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "unrealizedGainPercentage": 40.00,
      "percentageOfPortfolio": 18.92,
      "ocf": 0.22,
      "lastUpdated": "2026-02-16T16:00:00Z"
    },
    {
      "holdingId": "holding-004",
      "isin": "CASH001",
      "fundName": "Cash Holding",
      "fundType": {
        "code": "CASH",
        "display": "Cash"
      },
      "assetClass": {
        "code": "CASH",
        "display": "Cash"
      },
      "currentValue": {
        "amount": 10050.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "costBasis": {
        "amount": 8000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "unrealizedGain": {
        "amount": 2050.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "unrealizedGainPercentage": 25.63,
      "percentageOfPortfolio": 5.43,
      "interestRate": 4.50,
      "lastUpdated": "2026-02-16T16:00:00Z"
    }
  ],
  "totalHoldings": 4,
  "contributions": [
    {
      "contributionId": "contrib-001",
      "date": "2025-04-06",
      "amount": {
        "amount": 20000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "type": {
        "code": "REGULAR",
        "display": "Regular Contribution"
      },
      "taxYear": "2025/2026",
      "notes": "Annual ISA contribution for tax year 2025/26"
    },
    {
      "contributionId": "contrib-002",
      "date": "2024-04-06",
      "amount": {
        "amount": 20000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "type": {
        "code": "REGULAR",
        "display": "Regular Contribution"
      },
      "taxYear": "2024/2025",
      "notes": "Annual ISA contribution for tax year 2024/25"
    }
  ],
  "totalContributions": {
    "amount": 150000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "withdrawals": [
    {
      "withdrawalId": "withdraw-001",
      "date": "2025-09-15",
      "amount": {
        "amount": 5000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "type": {
        "code": "ADHOC",
        "display": "Ad-hoc Withdrawal"
      },
      "reason": "Home improvement",
      "taxableAmount": {
        "amount": 0.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "notes": "Tax-free ISA withdrawal"
    }
  ],
  "totalWithdrawals": {
    "amount": 5000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "netContributions": {
    "amount": 145000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "regularContribution": {
    "amount": 500.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "regularContributionFrequency": {
    "code": "MONTHLY",
    "display": "Monthly"
  },
  "nextContributionDate": "2026-03-01",
  "isRegularContributionActive": true,
  "taxFields": {
    "capitalGainsUsed": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "capitalGainsAllowance": {
      "amount": 3000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "dividendsReceived": {
      "amount": 8500.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "dividendsAllowance": {
      "amount": 500.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "taxPaid": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "taxRelief": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "isTaxExempt": true,
    "taxExemptReason": "Stocks & Shares ISA - tax wrapper"
  },
  "charges": {
    "annualManagementCharge": 0.15,
    "platformFee": 0.25,
    "totalExpenseRatio": 0.40,
    "transactionFees": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "exitFees": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    }
  },
  "riskRating": {
    "code": "MODERATE",
    "display": "Moderate Risk",
    "numericScore": 5,
    "scale": "1-7"
  },
  "investmentObjective": "Long-term capital growth with moderate risk exposure",
  "benchmarkIndex": "FTSE All-World Index",
  "rebalancingFrequency": {
    "code": "QUARTERLY",
    "display": "Quarterly"
  },
  "lastRebalancingDate": "2026-01-15",
  "nextRebalancingDate": "2026-04-15",
  "isAdvised": true,
  "adviceType": {
    "code": "ONGOING",
    "display": "Ongoing Advice"
  },
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },
  "lastReviewDate": "2026-01-15",
  "nextReviewDate": "2027-01-15",
  "notes": "Client prefers sustainable investing, ESG funds where possible",
  "documents": [
    {
      "documentId": "doc-001",
      "type": {
        "code": "STATEMENT",
        "display": "Account Statement"
      },
      "name": "ISA Annual Statement 2025",
      "date": "2025-12-31",
      "url": "/api/v1/documents/doc-001"
    }
  ],
  "createdAt": "2020-04-06T10:00:00Z",
  "updatedAt": "2026-02-16T16:30:00Z",
  "createdBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "updatedBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "_links": {
    "self": { "href": "/api/v1/investments/investment-789" },
    "update": { "href": "/api/v1/investments/investment-789", "method": "PUT" },
    "delete": { "href": "/api/v1/investments/investment-789", "method": "DELETE" },
    "arrangement": { "href": "/api/v1/arrangements/arrangement-456" },
    "client": { "href": "/api/v1/clients/client-123" },
    "factfind": { "href": "/api/v1/factfinds/factfind-123" },
    "holdings": { "href": "/api/v1/investments/investment-789/holdings" },
    "contributions": { "href": "/api/v1/investments/investment-789/contributions" },
    "withdrawals": { "href": "/api/v1/investments/investment-789/withdrawals" },
    "transactions": { "href": "/api/v1/investments/investment-789/transactions" },
    "documents": { "href": "/api/v1/investments/investment-789/documents" },
    "performance": { "href": "/api/v1/investments/investment-789/performance" }
  }
}
```

**Field Behaviors:**

| Field | Type | Create | Update | Response | Notes |
|-------|------|--------|--------|----------|-------|
| `id` | uuid | ignored | ignored | included | read-only, server-generated |
| `arrangementId` | uuid | required | ignored | included | write-once, link to parent Arrangement |
| `factFindRef` | FactFindRef | required | ignored | included | Reference to owning FactFind, write-once |
| `clientRef` | ClientRef | required | ignored | included | Reference to client, write-once |
| `arrangementType` | CodeValue | required | ignored | included | write-once, discriminator field |
| `productType` | CodeValue | required | ignored | included | write-once, ISA/GIA/Bond/Investment Trust |
| `provider` | ProviderValue | required | updatable | included | Provider details with FRN |
| `policyNumber` | string | required | ignored | included | write-once, unique identifier |
| `accountNumber` | string | optional | updatable | included | Account reference number |
| `planName` | string | optional | updatable | included | Name of investment plan |
| `startDate` | date | required | ignored | included | write-once, inception date |
| `maturityDate` | date | optional | updatable | included | For fixed-term investments |
| `status` | CodeValue | optional | updatable | included | Active/Closed/Suspended |
| `investmentType` | CodeValue | required | updatable | included | Detailed investment classification |
| `isaType` | CodeValue | optional | updatable | included | If ISA: Stocks/Cash/Innovative/Lifetime |
| `taxYear` | string | optional | updatable | included | Current tax year for ISA allowance |
| `annualIsaAllowance` | MoneyValue | optional | updatable | included | Annual ISA contribution limit |
| `isaAllowanceUsed` | MoneyValue | optional | updatable | included | Amount of allowance used this year |
| `isaAllowanceRemaining` | MoneyValue | ignored | ignored | included | read-only, computed |
| `taxWrapperType` | CodeValue | optional | updatable | included | ISA/SIPP/other tax wrapper |
| `isTaxable` | boolean | optional | updatable | included | Whether gains are taxable |
| `currentValue` | MoneyValue | required | updatable | included | Current market value |
| `valuationDate` | date | required | updatable | included | Date of valuation |
| `costBasis` | MoneyValue | optional | updatable | included | Total cost of investments |
| `unrealizedGain` | MoneyValue | ignored | ignored | included | read-only, currentValue - costBasis |
| `unrealizedGainPercentage` | decimal | ignored | ignored | included | read-only, percentage gain/loss |
| `realizedGain` | MoneyValue | optional | updatable | included | Gains from sales |
| `totalReturn` | MoneyValue | ignored | ignored | included | read-only, unrealized + realized |
| `totalReturnPercentage` | decimal | ignored | ignored | included | read-only, total return % |
| `annualizedReturn` | decimal | ignored | ignored | included | read-only, compound annual growth rate |
| `timeWeightedReturn` | decimal | optional | updatable | included | TWR performance metric |
| `moneyWeightedReturn` | decimal | optional | updatable | included | MWR performance metric |
| `inceptionDate` | date | required | ignored | included | write-once, first investment date |
| `yearsHeld` | decimal | ignored | ignored | included | read-only, computed from inceptionDate |
| `assetAllocation` | object | optional | updatable | included | Equities/bonds/cash/alternatives breakdown |
| `geographicAllocation` | object | optional | updatable | included | Regional allocation breakdown |
| `holdings` | array | optional | updatable | included | Array of fund holdings with ISIN/value |
| `totalHoldings` | integer | ignored | ignored | included | read-only, count of holdings |
| `contributions` | array | optional | updatable | included | Array of contribution transactions |
| `totalContributions` | MoneyValue | ignored | ignored | included | read-only, sum of contributions |
| `withdrawals` | array | optional | updatable | included | Array of withdrawal transactions |
| `totalWithdrawals` | MoneyValue | ignored | ignored | included | read-only, sum of withdrawals |
| `netContributions` | MoneyValue | ignored | ignored | included | read-only, contributions - withdrawals |
| `regularContribution` | MoneyValue | optional | updatable | included | Regular monthly/annual contribution |
| `regularContributionFrequency` | CodeValue | optional | updatable | included | Monthly/Quarterly/Annual |
| `nextContributionDate` | date | optional | updatable | included | Next scheduled contribution |
| `isRegularContributionActive` | boolean | optional | updatable | included | Whether regular contributions are active |
| `taxFields` | object | optional | updatable | included | Capital gains, dividends, tax paid |
| `charges` | object | optional | updatable | included | AMC, platform fees, TER |
| `riskRating` | CodeValue | optional | updatable | included | Investment risk rating |
| `investmentObjective` | string | optional | updatable | included | Stated investment goal |
| `benchmarkIndex` | string | optional | updatable | included | Performance benchmark |
| `rebalancingFrequency` | CodeValue | optional | updatable | included | Quarterly/Semi-annual/Annual |
| `lastRebalancingDate` | date | optional | updatable | included | Last portfolio rebalance |
| `nextRebalancingDate` | date | optional | updatable | included | Next scheduled rebalance |
| `isAdvised` | boolean | optional | updatable | included | Whether investment is advised |
| `adviceType` | CodeValue | optional | updatable | included | Ongoing/One-off advice |
| `adviserRef` | AdviserRef | optional | updatable | included | Reference to adviser |
| `lastReviewDate` | date | optional | updatable | included | Last review date |
| `nextReviewDate` | date | optional | updatable | included | Next scheduled review |
| `notes` | string | optional | updatable | included | Additional notes |
| `documents` | array | optional | updatable | included | Array of document references |
| `createdAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `updatedAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `createdBy` | object | ignored | ignored | included | read-only, audit trail |
| `updatedBy` | object | ignored | ignored | included | read-only, audit trail |
| `_links` | object | ignored | ignored | included | read-only, HATEOAS links |

**Usage Examples:**

**Creating an Investment ISA (POST /api/v1/investments):**
```json
{
  "arrangementId": "arrangement-456",
  "factFindRef": { "id": "factfind-123" },
  "clientRef": { "id": "client-123" },
  "arrangementType": { "code": "INV" },
  "productType": { "code": "ISA" },
  "provider": { "code": "VANGUARD" },
  "policyNumber": "ISA-987654321",
  "startDate": "2020-04-06",
  "inceptionDate": "2020-04-06",
  "investmentType": { "code": "STOCKS_SHARES_ISA" },
  "isaType": { "code": "STOCKS_SHARES" },
  "taxYear": "2025/2026",
  "currentValue": { "amount": 185000.00, "currency": { "code": "GBP" } },
  "valuationDate": "2026-02-16",
  "costBasis": { "amount": 150000.00, "currency": { "code": "GBP" } }
}
```
Server generates `id`, `createdAt`, `updatedAt`, and computes read-only fields like `unrealizedGain`, `totalReturn`, etc. Returns complete contract.

**Updating Asset Allocation (PUT /api/v1/investments/investment-789):**
```json
{
  "currentValue": { "amount": 190000.00, "currency": { "code": "GBP" } },
  "valuationDate": "2026-02-18",
  "assetAllocation": {
    "equities": { "percentage": 70.00, "value": { "amount": 133000.00, "currency": { "code": "GBP" } } },
    "bonds": { "percentage": 20.00, "value": { "amount": 38000.00, "currency": { "code": "GBP" } } },
    "cash": { "percentage": 5.00, "value": { "amount": 9500.00, "currency": { "code": "GBP" } } },
    "alternatives": { "percentage": 5.00, "value": { "amount": 9500.00, "currency": { "code": "GBP" } } }
  }
}
```
Server updates `updatedAt` and recalculates computed fields. Returns complete contract.

**Adding a Holding (PATCH /api/v1/investments/investment-789):**
```json
{
  "holdings": [
    {
      "isin": "GB00B3X7QG63",
      "fundName": "Vanguard FTSE Global All Cap Index Fund",
      "units": 15000.00,
      "unitPrice": { "amount": 6.25, "currency": { "code": "GBP" } },
      "currentValue": { "amount": 93750.00, "currency": { "code": "GBP" } },
      "costBasis": { "amount": 75000.00, "currency": { "code": "GBP" } }
    }
  ]
}
```
Only specified fields are updated. Returns complete contract with new holding added.

**Validation Rules:**

1. **Required Fields on Create:** `arrangementId`, `factFindRef`, `clientRef`, `arrangementType`, `productType`, `provider`, `policyNumber`, `startDate`, `inceptionDate`, `currentValue`, `valuationDate`
2. **Write-Once Fields:** Cannot be changed after creation: `arrangementId`, `factFindRef`, `clientRef`, `arrangementType`, `productType`, `policyNumber`, `startDate`, `inceptionDate`
3. **ISA Validation:** If `productType` is ISA, `isaType` must be provided (Stocks/Cash/Innovative/Lifetime)
4. **ISA Allowance:** `isaAllowanceUsed` cannot exceed `annualIsaAllowance` (£20,000 for 2025/26)
5. **Asset Allocation:** Sum of percentages in `assetAllocation` must equal 100%
6. **Geographic Allocation:** Sum of percentages in `geographicAllocation` must equal 100%
7. **Holdings Validation:** Each holding must have `isin` or `sedol`, `fundName`, and `currentValue`
8. **Date Logic:** `startDate` must be <= `valuationDate`, `maturityDate` (if provided) must be > `startDate`
9. **Contribution Limits:** For ISAs, total contributions in a tax year cannot exceed annual allowance
10. **Reference Integrity:** `arrangementId`, `clientRef.id`, `factFindRef.id`, `adviserRef.id` must reference existing entities

---

### 13.9 Property Contract

The `Property` contract represents a property asset with valuation tracking, mortgage linking, and rental income management.

**Reference Type:** Property is a reference type with identity (has `id` field).

```json
{
  "id": "property-456",
  "factFindRef": {
    "id": "factfind-123",
    "href": "/api/v1/factfinds/factfind-123",
    "factFindNumber": "FF-2025-00123",
    "status": {
      "code": "INP",
      "display": "In Progress"
    }
  },
  "propertyType": {
    "code": "BTL",
    "display": "Buy To Let"
  },
  "propertySubType": {
    "code": "APARTMENT",
    "display": "Apartment/Flat"
  },
  "ownershipType": {
    "code": "FREEHOLD",
    "display": "Freehold"
  },
  "address": {
    "line1": "Flat 12, Riverside Apartments",
    "line2": "45 Thames Street",
    "city": "London",
    "county": {
      "code": "GLA",
      "display": "Greater London"
    },
    "postcode": "SE1 9PH",
    "country": {
      "code": "GB",
      "display": "United Kingdom",
      "alpha3": "GBR"
    },
    "addressType": {
      "code": "BTL",
      "display": "Buy To Let"
    },
    "uprn": "100023456789",
    "coordinates": {
      "latitude": 51.5074,
      "longitude": -0.1278
    }
  },
  "propertyDescription": "Two bedroom apartment with river views, modern kitchen and bathroom, secure parking",
  "numberOfBedrooms": 2,
  "numberOfBathrooms": 1,
  "numberOfReceptionRooms": 1,
  "floorArea": {
    "value": 850,
    "unit": "sqft"
  },
  "tenure": {
    "code": "LEASEHOLD",
    "display": "Leasehold"
  },
  "leaseRemaining": 95,
  "groundRent": {
    "amount": 250.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    },
    "frequency": {
      "code": "ANNUAL",
      "display": "Annually"
    }
  },
  "serviceCharge": {
    "amount": 150.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    },
    "frequency": {
      "code": "MONTHLY",
      "display": "Monthly"
    }
  },
  "purchaseDate": "2018-06-15",
  "purchasePrice": {
    "amount": 325000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "purchaseCosts": {
    "stampDuty": {
      "amount": 9750.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "legalFees": {
      "amount": 1500.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "surveyFees": {
      "amount": 500.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "estateAgentFees": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "otherCosts": {
      "amount": 250.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "totalCosts": {
      "amount": 12000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    }
  },
  "totalInvestment": {
    "amount": 337000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "owners": [
    {
      "clientRef": {
        "id": "client-123",
        "href": "/api/v1/clients/client-123",
        "name": "John Smith",
        "clientNumber": "C00001234",
        "type": "Person"
      },
      "ownershipPercentage": 100.00,
      "isPrimaryOwner": true,
      "ownershipType": {
        "code": "SOLE",
        "display": "Sole Ownership"
      }
    }
  ],
  "ownershipStructure": {
    "code": "SOLE",
    "display": "Sole Ownership"
  },
  "isJointOwnership": false,
  "jointOwnershipType": null,
  "currentValue": {
    "amount": 425000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "valuationDate": "2026-02-10",
  "valuationType": {
    "code": "DESKTOP",
    "display": "Desktop Valuation"
  },
  "valuationProvider": "Zoopla",
  "valuationReference": "VAL-2026-02-12345",
  "previousValuation": {
    "amount": 410000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "previousValuationDate": "2025-02-10",
  "valuationChange": {
    "amount": 15000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "valuationChangePercentage": 3.66,
  "capitalGrowth": {
    "amount": 100000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "capitalGrowthPercentage": 30.77,
  "annualizedGrowth": 3.94,
  "mortgages": [
    {
      "mortgageRef": {
        "id": "mortgage-789",
        "href": "/api/v1/arrangements/mortgage-789",
        "arrangementType": "Mortgage",
        "provider": "Nationwide Building Society",
        "policyNumber": "MTG-987654321"
      },
      "outstandingBalance": {
        "amount": 240000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "monthlyPayment": {
        "amount": 1250.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "interestRate": 3.75,
      "isPrimary": true
    }
  ],
  "totalMortgageBalance": {
    "amount": 240000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "equityAmount": {
    "amount": 185000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "equityPercentage": 43.53,
  "loanToValue": 56.47,
  "isPrimaryResidence": false,
  "isRented": true,
  "isBuyToLet": true,
  "rentalIncome": {
    "monthlyRent": {
      "amount": 1650.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "annualRent": {
      "amount": 19800.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "tenancyType": {
      "code": "AST",
      "display": "Assured Shorthold Tenancy"
    },
    "tenancyStartDate": "2025-08-01",
    "tenancyEndDate": "2026-07-31",
    "tenancyRenewalDate": "2026-07-31",
    "isFixedTerm": true,
    "tenantName": "Emma Johnson",
    "tenantContactEmail": "emma.j@example.com",
    "depositAmount": {
      "amount": 1650.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "depositScheme": "Deposit Protection Service",
    "depositReference": "DPS-123456789",
    "rentalYieldGross": 4.66,
    "rentalYieldNet": 2.35,
    "voidPeriodsDays": 45,
    "lastRentReviewDate": "2025-08-01",
    "nextRentReviewDate": "2026-08-01"
  },
  "expenses": [
    {
      "expenseType": {
        "code": "MORTGAGE_INTEREST",
        "display": "Mortgage Interest"
      },
      "amount": {
        "amount": 750.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": {
        "code": "MONTHLY",
        "display": "Monthly"
      },
      "annualAmount": {
        "amount": 9000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "isTaxDeductible": true,
      "notes": "Interest-only mortgage"
    },
    {
      "expenseType": {
        "code": "BUILDINGS_INSURANCE",
        "display": "Buildings Insurance"
      },
      "amount": {
        "amount": 35.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": {
        "code": "MONTHLY",
        "display": "Monthly"
      },
      "annualAmount": {
        "amount": 420.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "isTaxDeductible": true,
      "notes": "Landlord buildings insurance"
    },
    {
      "expenseType": {
        "code": "LANDLORD_INSURANCE",
        "display": "Landlord Insurance"
      },
      "amount": {
        "amount": 25.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": {
        "code": "MONTHLY",
        "display": "Monthly"
      },
      "annualAmount": {
        "amount": 300.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "isTaxDeductible": true,
      "notes": "Rent guarantee and legal expenses"
    },
    {
      "expenseType": {
        "code": "LETTING_AGENT",
        "display": "Letting Agent Fees"
      },
      "amount": {
        "amount": 165.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": {
        "code": "MONTHLY",
        "display": "Monthly"
      },
      "annualAmount": {
        "amount": 1980.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "isTaxDeductible": true,
      "notes": "10% management fee"
    },
    {
      "expenseType": {
        "code": "GROUND_RENT",
        "display": "Ground Rent"
      },
      "amount": {
        "amount": 20.83,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": {
        "code": "MONTHLY",
        "display": "Monthly"
      },
      "annualAmount": {
        "amount": 250.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "isTaxDeductible": true,
      "notes": "Annual ground rent"
    },
    {
      "expenseType": {
        "code": "SERVICE_CHARGE",
        "display": "Service Charge"
      },
      "amount": {
        "amount": 150.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": {
        "code": "MONTHLY",
        "display": "Monthly"
      },
      "annualAmount": {
        "amount": 1800.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "isTaxDeductible": true,
      "notes": "Building maintenance and communal areas"
    },
    {
      "expenseType": {
        "code": "REPAIRS_MAINTENANCE",
        "display": "Repairs & Maintenance"
      },
      "amount": {
        "amount": 83.33,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": {
        "code": "MONTHLY",
        "display": "Monthly"
      },
      "annualAmount": {
        "amount": 1000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "isTaxDeductible": true,
      "notes": "Average annual maintenance budget"
    }
  ],
  "totalMonthlyExpenses": {
    "amount": 1229.16,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "totalAnnualExpenses": {
    "amount": 14750.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "netMonthlyIncome": {
    "amount": 420.84,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "netAnnualIncome": {
    "amount": 5050.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "taxFields": {
    "stampDutyPaid": {
      "amount": 9750.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "stampDutyRate": 3.00,
    "eligibleForPRR": false,
    "prrYears": 0,
    "lettingsRelief": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "estimatedCGTBaseValue": {
      "amount": 325000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "capitalGainsLiability": {
      "amount": 100000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "capitalGainsTaxEstimate": {
      "amount": 28000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "rentalIncomeTaxable": {
      "amount": 5050.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "taxYearReported": "2025/2026"
  },
  "energyPerformanceCertificate": {
    "epcRating": "C",
    "epcScore": 72,
    "epcValidUntil": "2028-06-15",
    "epcReference": "1234-5678-9012-3456-7890"
  },
  "councilTaxBand": "D",
  "councilTaxAnnual": {
    "amount": 1800.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "improvements": [
    {
      "improvementType": "Kitchen Renovation",
      "date": "2020-03-15",
      "cost": {
        "amount": 8000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "description": "Full kitchen replacement with new appliances"
    },
    {
      "improvementType": "Bathroom Renovation",
      "date": "2021-07-20",
      "cost": {
        "amount": 5000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "description": "New bathroom suite and tiling"
    }
  ],
  "totalImprovementsCost": {
    "amount": 13000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "comparables": [
    {
      "address": "Flat 8, Riverside Apartments, Thames Street",
      "soldDate": "2025-11-15",
      "soldPrice": {
        "amount": 418000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "bedrooms": 2,
      "propertyType": "Apartment"
    },
    {
      "address": "Flat 15, Thames View, 50 River Lane",
      "soldDate": "2025-12-10",
      "soldPrice": {
        "amount": 435000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "bedrooms": 2,
      "propertyType": "Apartment"
    }
  ],
  "plannedSaleDate": null,
  "estimatedSalePrice": null,
  "intendToSell": false,
  "intendToRefinance": false,
  "notes": "Well-maintained property in popular riverside development. Excellent rental demand in area.",
  "documents": [
    {
      "documentId": "doc-prop-001",
      "type": {
        "code": "VALUATION",
        "display": "Property Valuation"
      },
      "name": "Desktop Valuation February 2026",
      "date": "2026-02-10",
      "url": "/api/v1/documents/doc-prop-001"
    }
  ],
  "createdAt": "2018-06-15T10:00:00Z",
  "updatedAt": "2026-02-16T14:30:00Z",
  "createdBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "updatedBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "_links": {
    "self": { "href": "/api/v1/properties/property-456" },
    "update": { "href": "/api/v1/properties/property-456", "method": "PUT" },
    "delete": { "href": "/api/v1/properties/property-456", "method": "DELETE" },
    "factfind": { "href": "/api/v1/factfinds/factfind-123" },
    "owners": { "href": "/api/v1/properties/property-456/owners" },
    "mortgages": { "href": "/api/v1/properties/property-456/mortgages" },
    "expenses": { "href": "/api/v1/properties/property-456/expenses" },
    "rental": { "href": "/api/v1/properties/property-456/rental" },
    "valuations": { "href": "/api/v1/properties/property-456/valuations" },
    "documents": { "href": "/api/v1/properties/property-456/documents" }
  }
}
```

**Field Behaviors:**

| Field | Type | Create | Update | Response | Notes |
|-------|------|--------|--------|----------|-------|
| `id` | uuid | ignored | ignored | included | read-only, server-generated |
| `factFindRef` | FactFindRef | required | ignored | included | Reference to owning FactFind, write-once |
| `propertyType` | CodeValue | required | ignored | included | write-once, PrimaryResidence/BuyToLet/SecondHome/Commercial |
| `propertySubType` | CodeValue | optional | updatable | included | Detached/SemiDetached/Terraced/Apartment/Bungalow |
| `ownershipType` | CodeValue | optional | updatable | included | Freehold/Leasehold/Shared Ownership |
| `address` | AddressValue | required | updatable | included | Full property address with UPRN and coordinates |
| `propertyDescription` | string | optional | updatable | included | Free text description |
| `numberOfBedrooms` | integer | optional | updatable | included | Number of bedrooms |
| `numberOfBathrooms` | integer | optional | updatable | included | Number of bathrooms |
| `numberOfReceptionRooms` | integer | optional | updatable | included | Number of reception rooms |
| `floorArea` | object | optional | updatable | included | Floor area with unit (sqft/sqm) |
| `tenure` | CodeValue | optional | updatable | included | Freehold/Leasehold |
| `leaseRemaining` | integer | optional | updatable | included | Years remaining on lease |
| `groundRent` | object | optional | updatable | included | Annual ground rent with frequency |
| `serviceCharge` | object | optional | updatable | included | Monthly/annual service charge |
| `purchaseDate` | date | required | ignored | included | write-once, date property purchased |
| `purchasePrice` | MoneyValue | required | ignored | included | write-once, original purchase price |
| `purchaseCosts` | object | optional | updatable | included | Breakdown of purchase costs (stamp duty, legal, etc.) |
| `totalInvestment` | MoneyValue | ignored | ignored | included | read-only, purchasePrice + purchaseCosts.totalCosts |
| `owners` | array | required | updatable | included | Array of owners with percentage ownership |
| `ownershipStructure` | CodeValue | required | updatable | included | Sole/Joint/Tenants in Common |
| `isJointOwnership` | boolean | ignored | ignored | included | read-only, computed from owners array |
| `jointOwnershipType` | CodeValue | optional | updatable | included | If joint: Joint Tenants/Tenants in Common |
| `currentValue` | MoneyValue | required | updatable | included | Current market value |
| `valuationDate` | date | required | updatable | included | Date of valuation |
| `valuationType` | CodeValue | required | updatable | included | Desktop/Surveyor/EstateAgent/RICS |
| `valuationProvider` | string | optional | updatable | included | Name of valuation provider |
| `valuationReference` | string | optional | updatable | included | Reference number for valuation |
| `previousValuation` | MoneyValue | optional | updatable | included | Previous valuation amount |
| `previousValuationDate` | date | optional | updatable | included | Previous valuation date |
| `valuationChange` | MoneyValue | ignored | ignored | included | read-only, currentValue - previousValuation |
| `valuationChangePercentage` | decimal | ignored | ignored | included | read-only, percentage change |
| `capitalGrowth` | MoneyValue | ignored | ignored | included | read-only, currentValue - purchasePrice |
| `capitalGrowthPercentage` | decimal | ignored | ignored | included | read-only, percentage growth |
| `annualizedGrowth` | decimal | ignored | ignored | included | read-only, CAGR from purchase |
| `mortgages` | array | optional | updatable | included | Array of mortgage references |
| `totalMortgageBalance` | MoneyValue | ignored | ignored | included | read-only, sum of mortgage balances |
| `equityAmount` | MoneyValue | ignored | ignored | included | read-only, currentValue - totalMortgageBalance |
| `equityPercentage` | decimal | ignored | ignored | included | read-only, equity as % of value |
| `loanToValue` | decimal | ignored | ignored | included | read-only, LTV percentage |
| `isPrimaryResidence` | boolean | optional | updatable | included | Whether this is primary residence |
| `isRented` | boolean | optional | updatable | included | Whether property is rented |
| `isBuyToLet` | boolean | optional | updatable | included | Whether this is a BTL property |
| `rentalIncome` | object | optional | updatable | included | Full rental details including tenancy info |
| `expenses` | array | optional | updatable | included | Array of property expenses |
| `totalMonthlyExpenses` | MoneyValue | ignored | ignored | included | read-only, sum of monthly expenses |
| `totalAnnualExpenses` | MoneyValue | ignored | ignored | included | read-only, sum of annual expenses |
| `netMonthlyIncome` | MoneyValue | ignored | ignored | included | read-only, rental income - expenses |
| `netAnnualIncome` | MoneyValue | ignored | ignored | included | read-only, annual rental - annual expenses |
| `taxFields` | object | optional | updatable | included | Tax details including CGT, PRR, stamp duty |
| `energyPerformanceCertificate` | object | optional | updatable | included | EPC rating and details |
| `councilTaxBand` | string | optional | updatable | included | Council tax band |
| `councilTaxAnnual` | MoneyValue | optional | updatable | included | Annual council tax |
| `improvements` | array | optional | updatable | included | Array of property improvements |
| `totalImprovementsCost` | MoneyValue | ignored | ignored | included | read-only, sum of improvement costs |
| `comparables` | array | optional | updatable | included | Array of comparable property sales |
| `plannedSaleDate` | date | optional | updatable | included | Planned sale date if applicable |
| `estimatedSalePrice` | MoneyValue | optional | updatable | included | Estimated sale price |
| `intendToSell` | boolean | optional | updatable | included | Whether client intends to sell |
| `intendToRefinance` | boolean | optional | updatable | included | Whether client intends to refinance |
| `notes` | string | optional | updatable | included | Additional notes |
| `documents` | array | optional | updatable | included | Array of document references |
| `createdAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `updatedAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `createdBy` | object | ignored | ignored | included | read-only, audit trail |
| `updatedBy` | object | ignored | ignored | included | read-only, audit trail |
| `_links` | object | ignored | ignored | included | read-only, HATEOAS links |

**Usage Examples:**

**Creating a Buy-To-Let Property (POST /api/v1/properties):**
```json
{
  "factFindRef": { "id": "factfind-123" },
  "propertyType": { "code": "BTL" },
  "address": {
    "line1": "Flat 12, Riverside Apartments",
    "line2": "45 Thames Street",
    "city": "London",
    "postcode": "SE1 9PH",
    "country": { "code": "GB" }
  },
  "purchaseDate": "2018-06-15",
  "purchasePrice": { "amount": 325000.00, "currency": { "code": "GBP" } },
  "currentValue": { "amount": 425000.00, "currency": { "code": "GBP" } },
  "valuationDate": "2026-02-10",
  "valuationType": { "code": "DESKTOP" },
  "owners": [
    {
      "clientRef": { "id": "client-123" },
      "ownershipPercentage": 100.00,
      "isPrimaryOwner": true
    }
  ],
  "ownershipStructure": { "code": "SOLE" },
  "isBuyToLet": true,
  "isRented": true
}
```
Server generates `id`, `createdAt`, `updatedAt`, and computes read-only fields. Returns complete contract.

**Updating Property Valuation (PUT /api/v1/properties/property-456):**
```json
{
  "currentValue": { "amount": 435000.00, "currency": { "code": "GBP" } },
  "valuationDate": "2026-06-15",
  "valuationType": { "code": "SURVEYOR" },
  "valuationProvider": "Knight Frank",
  "previousValuation": { "amount": 425000.00, "currency": { "code": "GBP" } },
  "previousValuationDate": "2026-02-10"
}
```
Server updates `updatedAt` and recalculates equity, LTV, capital growth. Returns complete contract.

**Updating Rental Income (PATCH /api/v1/properties/property-456):**
```json
{
  "rentalIncome": {
    "monthlyRent": { "amount": 1750.00, "currency": { "code": "GBP" } },
    "tenancyStartDate": "2026-08-01",
    "tenancyEndDate": "2027-07-31",
    "tenantName": "Michael Brown"
  }
}
```
Only specified fields are updated. Server recalculates rental yield and net income. Returns complete contract.

**Validation Rules:**

1. **Required Fields on Create:** `factFindRef`, `propertyType`, `address`, `purchaseDate`, `purchasePrice`, `currentValue`, `valuationDate`, `valuationType`, `owners`, `ownershipStructure`
2. **Write-Once Fields:** Cannot be changed after creation: `factFindRef`, `propertyType`, `purchaseDate`, `purchasePrice`
3. **Ownership Validation:** Sum of `owners[].ownershipPercentage` must equal 100%
4. **Date Logic:** `purchaseDate` must be <= `valuationDate`, `tenancyEndDate` must be > `tenancyStartDate`
5. **Rental Validation:** If `isRented` is true, `rentalIncome` must be provided
6. **Buy-To-Let Validation:** If `isBuyToLet` is true, `propertyType` must be "BTL"
7. **Leasehold Validation:** If `tenure` is "Leasehold", `leaseRemaining` should be provided
8. **Mortgage Linking:** `mortgages[].mortgageRef.id` must reference valid Arrangement entities
9. **Valuation Requirements:** `currentValue` must be > 0, `valuationDate` must not be in future
10. **Reference Integrity:** `factFindRef.id`, `owners[].clientRef.id` must reference existing entities

---

### 13.10 Equity Contract

The `Equity` contract represents a direct stock holding with performance tracking and dividend history.

**Reference Type:** Equity is a reference type with identity (has `id` field).

```json
{
  "id": "equity-321",
  "factFindRef": {
    "id": "factfind-123",
    "href": "/api/v1/factfinds/factfind-123",
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
  "ticker": "BP.L",
  "isin": "GB0007980591",
  "sedol": "0798059",
  "cusip": null,
  "companyName": "BP plc",
  "companyDescription": "British multinational oil and gas company",
  "exchange": {
    "code": "LSE",
    "display": "London Stock Exchange",
    "mic": "XLON"
  },
  "sector": {
    "code": "ENERGY",
    "display": "Energy",
    "subSector": "Oil & Gas Producers"
  },
  "industry": "Integrated Oil & Gas",
  "currency": {
    "code": "GBP",
    "display": "British Pound",
    "symbol": "£"
  },
  "country": {
    "code": "GB",
    "display": "United Kingdom",
    "alpha3": "GBR"
  },
  "holdings": {
    "quantity": 5000,
    "averagePurchasePrice": {
      "amount": 4.25,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "totalCostBasis": {
      "amount": 21250.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "currentPrice": {
      "amount": 5.15,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "currentValue": {
      "amount": 25750.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "priceDate": "2026-02-16T16:00:00Z"
  },
  "performance": {
    "unrealizedGain": {
      "amount": 4500.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "unrealizedGainPercentage": 21.18,
    "realizedGain": {
      "amount": 1250.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "totalGain": {
      "amount": 5750.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "totalReturn": 27.06,
    "dayChange": {
      "amount": 0.08,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "dayChangePercentage": 1.58,
    "annualizedReturn": 5.41,
    "totalDividendsReceived": {
      "amount": 3750.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "dividendYield": 4.85,
    "totalReturnWithDividends": {
      "amount": 9500.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "totalReturnWithDividendsPercentage": 44.71
  },
  "purchases": [
    {
      "transactionId": "txn-001",
      "date": "2021-03-15",
      "transactionType": {
        "code": "BUY",
        "display": "Purchase"
      },
      "quantity": 3000,
      "price": {
        "amount": 4.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "grossAmount": {
        "amount": 12000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "commission": {
        "amount": 10.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "stampDuty": {
        "amount": 60.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "otherCosts": {
        "amount": 0.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "totalCost": {
        "amount": 12070.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "broker": "Hargreaves Lansdown",
      "notes": "Initial purchase"
    },
    {
      "transactionId": "txn-002",
      "date": "2022-06-20",
      "transactionType": {
        "code": "BUY",
        "display": "Purchase"
      },
      "quantity": 2000,
      "price": {
        "amount": 4.60,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "grossAmount": {
        "amount": 9200.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "commission": {
        "amount": 10.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "stampDuty": {
        "amount": 46.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "otherCosts": {
        "amount": 0.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "totalCost": {
        "amount": 9256.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "broker": "Hargreaves Lansdown",
      "notes": "Additional purchase during market dip"
    }
  ],
  "sales": [
    {
      "transactionId": "txn-003",
      "date": "2024-09-10",
      "transactionType": {
        "code": "SELL",
        "display": "Sale"
      },
      "quantity": 500,
      "price": {
        "amount": 5.50,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "grossAmount": {
        "amount": 2750.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "commission": {
        "amount": 10.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "otherCosts": {
        "amount": 0.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "netProceeds": {
        "amount": 2740.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "costBasisOfSharesSold": {
        "amount": 2125.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "realizedGain": {
        "amount": 615.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "broker": "Hargreaves Lansdown",
      "notes": "Partial profit taking"
    }
  ],
  "dividends": [
    {
      "dividendId": "div-001",
      "exDividendDate": "2021-08-05",
      "paymentDate": "2021-09-27",
      "dividendType": {
        "code": "ORDINARY",
        "display": "Ordinary Dividend"
      },
      "amountPerShare": {
        "amount": 0.05175,
        "currency": {
          "code": "USD",
          "display": "US Dollar",
          "symbol": "$"
        }
      },
      "amountPerShareGBP": {
        "amount": 0.0375,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "quantityHeld": 3000,
      "grossDividend": {
        "amount": 112.50,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "withholdingTax": {
        "amount": 0.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "netDividend": {
        "amount": 112.50,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "reinvested": false,
      "taxYear": "2021/2022",
      "notes": "Q3 2021 dividend"
    },
    {
      "dividendId": "div-002",
      "exDividendDate": "2021-11-04",
      "paymentDate": "2021-12-20",
      "dividendType": {
        "code": "ORDINARY",
        "display": "Ordinary Dividend"
      },
      "amountPerShare": {
        "amount": 0.05250,
        "currency": {
          "code": "USD",
          "display": "US Dollar",
          "symbol": "$"
        }
      },
      "amountPerShareGBP": {
        "amount": 0.0390,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "quantityHeld": 3000,
      "grossDividend": {
        "amount": 117.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "withholdingTax": {
        "amount": 0.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "netDividend": {
        "amount": 117.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "reinvested": false,
      "taxYear": "2021/2022",
      "notes": "Q4 2021 dividend"
    },
    {
      "dividendId": "div-003",
      "exDividendDate": "2025-11-07",
      "paymentDate": "2025-12-23",
      "dividendType": {
        "code": "ORDINARY",
        "display": "Ordinary Dividend"
      },
      "amountPerShare": {
        "amount": 0.08010,
        "currency": {
          "code": "USD",
          "display": "US Dollar",
          "symbol": "$"
        }
      },
      "amountPerShareGBP": {
        "amount": 0.0625,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "quantityHeld": 5000,
      "grossDividend": {
        "amount": 312.50,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "withholdingTax": {
        "amount": 0.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "netDividend": {
        "amount": 312.50,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "reinvested": false,
      "taxYear": "2025/2026",
      "notes": "Q4 2025 dividend - increased payout"
    }
  ],
  "corporateActions": [
    {
      "actionId": "action-001",
      "date": "2023-05-15",
      "actionType": {
        "code": "STOCK_SPLIT",
        "display": "Stock Split"
      },
      "ratio": "2:1",
      "description": "2-for-1 stock split",
      "quantityBefore": 2500,
      "quantityAfter": 5000,
      "impact": "Holdings doubled, cost basis per share halved"
    },
    {
      "actionId": "action-002",
      "date": "2024-03-20",
      "actionType": {
        "code": "RIGHTS_ISSUE",
        "display": "Rights Issue"
      },
      "ratio": "1:10",
      "description": "Rights issue at £4.00 per share",
      "pricePerShare": {
        "amount": 4.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "quantityOffered": 500,
      "quantityTaken": 0,
      "impact": "Rights not taken up"
    }
  ],
  "taxCalculation": {
    "costBasisMethod": {
      "code": "SECTION104",
      "display": "Section 104 Pool (UK)"
    },
    "section104Pool": {
      "quantity": 5000,
      "pooledCost": {
        "amount": 21250.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "averageCostPerShare": {
        "amount": 4.25,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      }
    },
    "capitalGainsRealized": {
      "amount": 1250.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "capitalGainsUnrealized": {
      "amount": 4500.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "totalCapitalGains": {
      "amount": 5750.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "capitalGainsAllowance": {
      "amount": 3000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "taxableCGT": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "dividendsTaxable": {
      "amount": 3250.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "dividendsAllowance": {
      "amount": 500.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "taxYear": "2025/2026"
  },
  "marketData": {
    "lastUpdated": "2026-02-16T16:00:00Z",
    "bid": {
      "amount": 5.14,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "ask": {
      "amount": 5.16,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "open": {
      "amount": 5.07,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "high": {
      "amount": 5.18,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "low": {
      "amount": 5.05,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "close": {
      "amount": 5.15,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "volume": 12500000,
    "52WeekHigh": {
      "amount": 5.85,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "52WeekLow": {
      "amount": 4.15,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "marketCap": {
      "amount": 95000000000,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "peRatio": 12.5,
    "eps": {
      "amount": 0.412,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "beta": 1.15
  },
  "accountType": {
    "code": "GIA",
    "display": "General Investment Account"
  },
  "broker": {
    "name": "Hargreaves Lansdown",
    "accountNumber": "HL-12345678"
  },
  "isAdvised": true,
  "adviserRef": {
    "id": "adviser-789",
    "href": "/api/v1/advisers/adviser-789",
    "name": "Jane Doe",
    "code": "ADV001"
  },
  "investmentObjective": "Long-term income and capital growth from UK blue-chip dividend stock",
  "notes": "Core UK equity holding for dividend income. Monitor oil price exposure.",
  "documents": [
    {
      "documentId": "doc-eq-001",
      "type": {
        "code": "CONTRACT_NOTE",
        "display": "Contract Note"
      },
      "name": "Purchase Contract Note - March 2021",
      "date": "2021-03-15",
      "url": "/api/v1/documents/doc-eq-001"
    }
  ],
  "createdAt": "2021-03-15T10:00:00Z",
  "updatedAt": "2026-02-16T16:30:00Z",
  "createdBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "updatedBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "_links": {
    "self": { "href": "/api/v1/equities/equity-321" },
    "update": { "href": "/api/v1/equities/equity-321", "method": "PUT" },
    "delete": { "href": "/api/v1/equities/equity-321", "method": "DELETE" },
    "client": { "href": "/api/v1/clients/client-123" },
    "factfind": { "href": "/api/v1/factfinds/factfind-123" },
    "transactions": { "href": "/api/v1/equities/equity-321/transactions" },
    "dividends": { "href": "/api/v1/equities/equity-321/dividends" },
    "corporateActions": { "href": "/api/v1/equities/equity-321/corporate-actions" },
    "performance": { "href": "/api/v1/equities/equity-321/performance" },
    "documents": { "href": "/api/v1/equities/equity-321/documents" }
  }
}
```

**Field Behaviors:**

| Field | Type | Create | Update | Response | Notes |
|-------|------|--------|--------|----------|-------|
| `id` | uuid | ignored | ignored | included | read-only, server-generated |
| `factFindRef` | FactFindRef | required | ignored | included | Reference to owning FactFind, write-once |
| `clientRef` | ClientRef | required | ignored | included | Reference to client, write-once |
| `ticker` | string | required | ignored | included | write-once, stock ticker symbol |
| `isin` | string | required | ignored | included | write-once, International Securities ID |
| `sedol` | string | optional | ignored | included | write-once, Stock Exchange Daily Official List |
| `cusip` | string | optional | ignored | included | write-once, CUSIP identifier (US stocks) |
| `companyName` | string | required | updatable | included | Name of company |
| `companyDescription` | string | optional | updatable | included | Brief description of company |
| `exchange` | CodeValue | required | updatable | included | Stock exchange where traded |
| `sector` | CodeValue | optional | updatable | included | Sector and sub-sector classification |
| `industry` | string | optional | updatable | included | Industry classification |
| `currency` | CurrencyValue | required | updatable | included | Trading currency |
| `country` | CountryValue | optional | updatable | included | Country of domicile |
| `holdings` | object | required | updatable | included | Current holdings with quantity and values |
| `performance` | object | ignored | ignored | included | read-only, computed performance metrics |
| `purchases` | array | optional | updatable | included | Array of purchase transactions |
| `sales` | array | optional | updatable | included | Array of sale transactions |
| `dividends` | array | optional | updatable | included | Array of dividend payments |
| `corporateActions` | array | optional | updatable | included | Array of corporate actions (splits, rights issues) |
| `taxCalculation` | object | optional | updatable | included | Tax calculation details including Section 104 pool |
| `marketData` | object | optional | updatable | included | Current market data and statistics |
| `accountType` | CodeValue | optional | updatable | included | ISA/GIA/SIPP account type |
| `broker` | object | optional | updatable | included | Broker details and account number |
| `isAdvised` | boolean | optional | updatable | included | Whether holding is advised |
| `adviserRef` | AdviserRef | optional | updatable | included | Reference to adviser |
| `investmentObjective` | string | optional | updatable | included | Investment objective for this holding |
| `notes` | string | optional | updatable | included | Additional notes |
| `documents` | array | optional | updatable | included | Array of document references |
| `createdAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `updatedAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `createdBy` | object | ignored | ignored | included | read-only, audit trail |
| `updatedBy` | object | ignored | ignored | included | read-only, audit trail |
| `_links` | object | ignored | ignored | included | read-only, HATEOAS links |

**Usage Examples:**

**Creating an Equity Holding (POST /api/v1/equities):**
```json
{
  "factFindRef": { "id": "factfind-123" },
  "clientRef": { "id": "client-123" },
  "ticker": "BP.L",
  "isin": "GB0007980591",
  "sedol": "0798059",
  "companyName": "BP plc",
  "exchange": { "code": "LSE" },
  "currency": { "code": "GBP" },
  "holdings": {
    "quantity": 3000,
    "averagePurchasePrice": { "amount": 4.00, "currency": { "code": "GBP" } },
    "totalCostBasis": { "amount": 12000.00, "currency": { "code": "GBP" } },
    "currentPrice": { "amount": 5.15, "currency": { "code": "GBP" } },
    "currentValue": { "amount": 15450.00, "currency": { "code": "GBP" } }
  },
  "accountType": { "code": "GIA" }
}
```
Server generates `id`, `createdAt`, `updatedAt`, and computes performance metrics. Returns complete contract.

**Recording a Purchase (PUT /api/v1/equities/equity-321):**
```json
{
  "purchases": [
    {
      "date": "2026-02-18",
      "transactionType": { "code": "BUY" },
      "quantity": 1000,
      "price": { "amount": 5.20, "currency": { "code": "GBP" } },
      "grossAmount": { "amount": 5200.00, "currency": { "code": "GBP" } },
      "commission": { "amount": 10.00, "currency": { "code": "GBP" } },
      "stampDuty": { "amount": 26.00, "currency": { "code": "GBP" } },
      "totalCost": { "amount": 5236.00, "currency": { "code": "GBP" } }
    }
  ],
  "holdings": {
    "quantity": 6000,
    "totalCostBasis": { "amount": 26486.00, "currency": { "code": "GBP" } }
  }
}
```
Server updates `updatedAt`, recalculates performance and Section 104 pool. Returns complete contract.

**Recording a Dividend (PATCH /api/v1/equities/equity-321):**
```json
{
  "dividends": [
    {
      "exDividendDate": "2026-02-14",
      "paymentDate": "2026-03-28",
      "dividendType": { "code": "ORDINARY" },
      "amountPerShare": { "amount": 0.0650, "currency": { "code": "GBP" } },
      "quantityHeld": 5000,
      "grossDividend": { "amount": 325.00, "currency": { "code": "GBP" } },
      "netDividend": { "amount": 325.00, "currency": { "code": "GBP" } },
      "reinvested": false
    }
  ]
}
```
Only specified fields are updated. Server recalculates total dividends and yield. Returns complete contract.

**Validation Rules:**

1. **Required Fields on Create:** `factFindRef`, `clientRef`, `ticker`, `isin`, `companyName`, `exchange`, `currency`, `holdings`
2. **Write-Once Fields:** Cannot be changed after creation: `factFindRef`, `clientRef`, `ticker`, `isin`, `sedol`, `cusip`
3. **Holdings Validation:** `holdings.quantity` must be > 0, `currentValue` must equal `quantity * currentPrice`
4. **Transaction Validation:** Each purchase/sale must have `date`, `quantity`, `price`, `totalCost`/`netProceeds`
5. **Dividend Validation:** Each dividend must have `exDividendDate`, `paymentDate`, `amountPerShare`, `quantityHeld`
6. **Section 104 Pool:** For UK equities, `taxCalculation.section104Pool` must track pooled cost accurately
7. **Corporate Actions:** Stock splits must maintain cost basis (quantity doubles, cost per share halves)
8. **Date Logic:** `exDividendDate` must be before `paymentDate`, transaction dates must be in past
9. **Market Data:** `marketData.lastUpdated` must not be in future
10. **Reference Integrity:** `factFindRef.id`, `clientRef.id`, `adviserRef.id` must reference existing entities

---

### 13.11 CreditHistory Contract

The `CreditHistory` contract represents credit score and credit history tracking from multiple agencies.

**Reference Type:** CreditHistory is a reference type with identity (has `id` field).

```json
{
  "id": "credit-654",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "factFindRef": {
    "id": "factfind-123",
    "href": "/api/v1/factfinds/factfind-123",
    "factFindNumber": "FF-2025-00123",
    "status": {
      "code": "INP",
      "display": "In Progress"
    }
  },
  "creditAgency": {
    "code": "EXPERIAN",
    "display": "Experian",
    "website": "https://www.experian.co.uk"
  },
  "scoreDate": "2026-02-10",
  "score": {
    "scoreValue": 875,
    "scoreRange": {
      "minimum": 0,
      "maximum": 999
    },
    "scoreBand": {
      "code": "GOOD",
      "display": "Good",
      "rangeStart": 721,
      "rangeEnd": 880
    },
    "scorePercentile": 68,
    "changeFromPreviousMonth": 15,
    "changeFromPreviousYear": 42,
    "previousScore": 860,
    "previousScoreDate": "2026-01-10"
  },
  "overallAssessment": {
    "creditHealthScore": 72,
    "creditHealthRating": {
      "code": "GOOD",
      "display": "Good"
    },
    "lendingSuitability": {
      "code": "LIKELY",
      "display": "Likely to be accepted for most lending"
    },
    "riskLevel": {
      "code": "LOW_MEDIUM",
      "display": "Low to Medium Risk"
    }
  },
  "paymentHistory": {
    "totalAccounts": 12,
    "activeAccounts": 8,
    "closedAccounts": 4,
    "onTimePayments": 144,
    "onTimePaymentPercentage": 96.0,
    "latePayments": 6,
    "missedPayments": 0,
    "defaultedAccounts": 0,
    "latePaymentsByPeriod": {
      "last30Days": 0,
      "last31To60Days": 1,
      "last61To90Days": 0,
      "over90Days": 0
    },
    "paymentHistoryScore": 85,
    "paymentHistoryRating": {
      "code": "GOOD",
      "display": "Good"
    },
    "oldestAccountDate": "2010-03-15",
    "accountAgeYears": 15.92
  },
  "creditUtilization": {
    "totalCreditAvailable": {
      "amount": 45000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "totalCreditUsed": {
      "amount": 8500.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "utilizationPercentage": 18.89,
    "utilizationScore": 82,
    "utilizationRating": {
      "code": "EXCELLENT",
      "display": "Excellent"
    },
    "accountsAtLimit": 0,
    "accountsNearLimit": 1,
    "recommendedUtilization": 30.00
  },
  "creditAge": {
    "oldestAccountDate": "2010-03-15",
    "oldestAccountAgeYears": 15.92,
    "averageAccountAge": {
      "years": 8,
      "months": 4
    },
    "averageAccountAgeYears": 8.33,
    "newestAccountDate": "2025-06-12",
    "newestAccountAgeMonths": 8,
    "creditAgeScore": 78,
    "creditAgeRating": {
      "code": "GOOD",
      "display": "Good"
    }
  },
  "creditMix": {
    "revolvingAccounts": 4,
    "revolvingAccountsOpen": 3,
    "installmentAccounts": 5,
    "installmentAccountsOpen": 3,
    "mortgageAccounts": 2,
    "mortgageAccountsOpen": 1,
    "otherAccounts": 1,
    "otherAccountsOpen": 1,
    "accountTypeBreakdown": {
      "creditCards": 3,
      "personalLoans": 2,
      "carLoans": 1,
      "mortgages": 2,
      "storeCards": 1,
      "utilities": 3
    },
    "creditMixScore": 88,
    "creditMixRating": {
      "code": "EXCELLENT",
      "display": "Excellent"
    }
  },
  "creditInquiries": {
    "hardInquiries": {
      "last12Months": 2,
      "last24Months": 4,
      "last6Months": 1
    },
    "softInquiries": {
      "last12Months": 8
    },
    "recentInquiries": [
      {
        "date": "2025-12-05",
        "inquiryType": {
          "code": "HARD",
          "display": "Hard Inquiry"
        },
        "creditor": "HSBC UK",
        "productType": "Credit Card",
        "impact": "Minor negative impact"
      },
      {
        "date": "2025-06-12",
        "inquiryType": {
          "code": "HARD",
          "display": "Hard Inquiry"
        },
        "creditor": "Santander UK",
        "productType": "Personal Loan",
        "impact": "Minor negative impact"
      }
    ],
    "inquiriesScore": 91,
    "inquiriesRating": {
      "code": "EXCELLENT",
      "display": "Excellent"
    }
  },
  "derogatoryMarks": {
    "hasAnyDerogatoryMarks": false,
    "defaults": {
      "count": 0,
      "totalAmount": {
        "amount": 0.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "details": []
    },
    "ccjs": {
      "count": 0,
      "totalAmount": {
        "amount": 0.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "details": []
    },
    "bankruptcies": {
      "count": 0,
      "details": []
    },
    "ivas": {
      "count": 0,
      "details": []
    },
    "arrangementsToPayDebt": {
      "count": 0,
      "details": []
    },
    "repossessions": {
      "count": 0,
      "details": []
    },
    "foreclosures": {
      "count": 0,
      "details": []
    }
  },
  "publicRecords": {
    "hasPublicRecords": false,
    "electoralRoll": {
      "isRegistered": true,
      "registrationDate": "2015-04-01",
      "address": "123 Main Street, London, SW1A 1AA"
    },
    "bankruptcySearchDate": "2026-02-10",
    "bankruptcyStatus": "Clear"
  },
  "accounts": [
    {
      "accountId": "acc-001",
      "accountType": {
        "code": "CREDIT_CARD",
        "display": "Credit Card"
      },
      "creditor": "HSBC UK",
      "accountNumber": "****1234",
      "status": {
        "code": "OPEN",
        "display": "Open"
      },
      "openedDate": "2018-05-12",
      "closedDate": null,
      "creditLimit": {
        "amount": 15000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "currentBalance": {
        "amount": 2500.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "utilizationPercentage": 16.67,
      "paymentStatus": {
        "code": "CURRENT",
        "display": "Current"
      },
      "lastPaymentDate": "2026-02-05",
      "lastPaymentAmount": {
        "amount": 500.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "missedPayments": 0,
      "latePayments": 1,
      "monthsReviewed": 72,
      "paymentHistory": "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC1CCC"
    },
    {
      "accountId": "acc-002",
      "accountType": {
        "code": "MORTGAGE",
        "display": "Mortgage"
      },
      "creditor": "Nationwide Building Society",
      "accountNumber": "****5678",
      "status": {
        "code": "OPEN",
        "display": "Open"
      },
      "openedDate": "2015-09-22",
      "closedDate": null,
      "originalAmount": {
        "amount": 250000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "currentBalance": {
        "amount": 185000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "monthlyPayment": {
        "amount": 1250.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "paymentStatus": {
        "code": "CURRENT",
        "display": "Current"
      },
      "lastPaymentDate": "2026-02-01",
      "missedPayments": 0,
      "latePayments": 0,
      "monthsReviewed": 125,
      "paymentHistory": "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"
    },
    {
      "accountId": "acc-003",
      "accountType": {
        "code": "PERSONAL_LOAN",
        "display": "Personal Loan"
      },
      "creditor": "Santander UK",
      "accountNumber": "****9012",
      "status": {
        "code": "OPEN",
        "display": "Open"
      },
      "openedDate": "2025-06-12",
      "closedDate": null,
      "originalAmount": {
        "amount": 10000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "currentBalance": {
        "amount": 8500.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "monthlyPayment": {
        "amount": 350.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "paymentStatus": {
        "code": "CURRENT",
        "display": "Current"
      },
      "lastPaymentDate": "2026-02-12",
      "missedPayments": 0,
      "latePayments": 0,
      "monthsReviewed": 8,
      "paymentHistory": "CCCCCCCC"
    }
  ],
  "totalAccounts": 12,
  "totalActiveAccounts": 8,
  "creditReport": {
    "reportProvider": "Experian",
    "reportDate": "2026-02-10",
    "reportReference": "EXP-2026-02-123456789",
    "reportType": {
      "code": "STATUTORY",
      "display": "Statutory Credit Report"
    },
    "reportUrl": "/api/v1/documents/credit-report-654",
    "validUntil": "2026-05-10",
    "costOfReport": {
      "amount": 2.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    }
  },
  "trends": {
    "scoreHistory": [
      {
        "date": "2025-02-10",
        "score": 833
      },
      {
        "date": "2025-05-10",
        "score": 845
      },
      {
        "date": "2025-08-10",
        "score": 852
      },
      {
        "date": "2025-11-10",
        "score": 860
      },
      {
        "date": "2026-02-10",
        "score": 875
      }
    ],
    "utilizationHistory": [
      {
        "date": "2025-02-10",
        "utilization": 25.5
      },
      {
        "date": "2025-05-10",
        "utilization": 22.3
      },
      {
        "date": "2025-08-10",
        "utilization": 20.1
      },
      {
        "date": "2025-11-10",
        "utilization": 19.5
      },
      {
        "date": "2026-02-10",
        "utilization": 18.89
      }
    ]
  },
  "recommendations": [
    {
      "category": {
        "code": "PAYMENT_HISTORY",
        "display": "Payment History"
      },
      "priority": {
        "code": "LOW",
        "display": "Low Priority"
      },
      "recommendation": "Continue making all payments on time to maintain excellent payment history",
      "potentialScoreImpact": 5
    },
    {
      "category": {
        "code": "CREDIT_UTILIZATION",
        "display": "Credit Utilization"
      },
      "priority": {
        "code": "LOW",
        "display": "Low Priority"
      },
      "recommendation": "Your credit utilization is excellent at 18.89%. Keep it below 30% for optimal score",
      "potentialScoreImpact": 3
    },
    {
      "category": {
        "code": "CREDIT_AGE",
        "display": "Credit Age"
      },
      "priority": {
        "code": "MEDIUM",
        "display": "Medium Priority"
      },
      "recommendation": "Avoid closing your oldest credit accounts to maintain credit age",
      "potentialScoreImpact": 10
    }
  ],
  "adverseCredit": {
    "hasAdverseCredit": false,
    "hasEverBeenBankrupt": false,
    "hasBeenRefusedCredit": false,
    "lastCreditRefusalDate": null,
    "hasArrangementsToPayDebt": false,
    "isInDebtManagementPlan": false
  },
  "fraudAlerts": {
    "hasActiveFraudAlert": false,
    "fraudAlerts": []
  },
  "identityVerification": {
    "addressLinked": true,
    "nameMatched": true,
    "dateOfBirthMatched": true,
    "verificationScore": 98,
    "verificationStatus": {
      "code": "VERIFIED",
      "display": "Verified"
    }
  },
  "nextReviewDate": "2026-05-10",
  "reviewFrequency": {
    "code": "QUARTERLY",
    "display": "Quarterly"
  },
  "isConsented": true,
  "consentDate": "2026-02-10",
  "consentExpiryDate": "2027-02-10",
  "notes": "Credit score improving steadily. Good payment history. Low utilization. No adverse marks.",
  "documents": [
    {
      "documentId": "doc-cr-001",
      "type": {
        "code": "CREDIT_REPORT",
        "display": "Credit Report"
      },
      "name": "Experian Statutory Credit Report - Feb 2026",
      "date": "2026-02-10",
      "url": "/api/v1/documents/doc-cr-001"
    }
  ],
  "createdAt": "2026-02-10T10:00:00Z",
  "updatedAt": "2026-02-10T11:30:00Z",
  "createdBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "updatedBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "_links": {
    "self": { "href": "/api/v1/credit-history/credit-654" },
    "update": { "href": "/api/v1/credit-history/credit-654", "method": "PUT" },
    "delete": { "href": "/api/v1/credit-history/credit-654", "method": "DELETE" },
    "client": { "href": "/api/v1/clients/client-123" },
    "factfind": { "href": "/api/v1/factfinds/factfind-123" },
    "creditReport": { "href": "/api/v1/documents/doc-cr-001" },
    "accounts": { "href": "/api/v1/credit-history/credit-654/accounts" },
    "trends": { "href": "/api/v1/credit-history/credit-654/trends" },
    "recommendations": { "href": "/api/v1/credit-history/credit-654/recommendations" }
  }
}
```

**Field Behaviors:**

| Field | Type | Create | Update | Response | Notes |
|-------|------|--------|--------|----------|-------|
| `id` | uuid | ignored | ignored | included | read-only, server-generated |
| `clientRef` | ClientRef | required | ignored | included | Reference to client, write-once |
| `factFindRef` | FactFindRef | optional | ignored | included | Reference to owning FactFind, write-once |
| `creditAgency` | CodeValue | required | ignored | included | write-once, Experian/Equifax/TransUnion |
| `scoreDate` | date | required | updatable | included | Date of credit score assessment |
| `score` | object | required | updatable | included | Credit score with range and band |
| `overallAssessment` | object | optional | updatable | included | Overall credit health assessment |
| `paymentHistory` | object | optional | updatable | included | Payment history metrics and scores |
| `creditUtilization` | object | optional | updatable | included | Credit utilization details and score |
| `creditAge` | object | optional | updatable | included | Credit age metrics and score |
| `creditMix` | object | optional | updatable | included | Mix of credit account types |
| `creditInquiries` | object | optional | updatable | included | Hard and soft inquiries |
| `derogatoryMarks` | object | optional | updatable | included | Defaults, CCJs, bankruptcies, IVAs |
| `publicRecords` | object | optional | updatable | included | Electoral roll, bankruptcy searches |
| `accounts` | array | optional | updatable | included | Array of credit accounts |
| `totalAccounts` | integer | ignored | ignored | included | read-only, count of accounts |
| `totalActiveAccounts` | integer | ignored | ignored | included | read-only, count of active accounts |
| `creditReport` | object | optional | updatable | included | Credit report details and reference |
| `trends` | object | optional | updatable | included | Score and utilization history |
| `recommendations` | array | optional | updatable | included | Recommendations for improving score |
| `adverseCredit` | object | optional | updatable | included | Adverse credit indicators |
| `fraudAlerts` | object | optional | updatable | included | Active fraud alerts |
| `identityVerification` | object | optional | updatable | included | Identity verification status |
| `nextReviewDate` | date | optional | updatable | included | Next scheduled review |
| `reviewFrequency` | CodeValue | optional | updatable | included | Review frequency (Monthly/Quarterly/Annual) |
| `isConsented` | boolean | required | updatable | included | Whether client has consented to credit check |
| `consentDate` | date | required | updatable | included | Date of consent |
| `consentExpiryDate` | date | optional | updatable | included | Consent expiry date |
| `notes` | string | optional | updatable | included | Additional notes |
| `documents` | array | optional | updatable | included | Array of document references |
| `createdAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `updatedAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `createdBy` | object | ignored | ignored | included | read-only, audit trail |
| `updatedBy` | object | ignored | ignored | included | read-only, audit trail |
| `_links` | object | ignored | ignored | included | read-only, HATEOAS links |

**Usage Examples:**

**Creating a Credit History Record (POST /api/v1/credit-history):**
```json
{
  "clientRef": { "id": "client-123" },
  "factFindRef": { "id": "factfind-123" },
  "creditAgency": { "code": "EXPERIAN" },
  "scoreDate": "2026-02-10",
  "score": {
    "scoreValue": 875,
    "scoreRange": { "minimum": 0, "maximum": 999 },
    "scoreBand": { "code": "GOOD" }
  },
  "isConsented": true,
  "consentDate": "2026-02-10"
}
```
Server generates `id`, `createdAt`, `updatedAt`. Returns complete contract.

**Updating with New Credit Report (PUT /api/v1/credit-history/credit-654):**
```json
{
  "scoreDate": "2026-05-10",
  "score": {
    "scoreValue": 890,
    "scoreRange": { "minimum": 0, "maximum": 999 },
    "scoreBand": { "code": "EXCELLENT" },
    "changeFromPreviousMonth": 15
  },
  "creditUtilization": {
    "totalCreditUsed": { "amount": 7500.00, "currency": { "code": "GBP" } },
    "utilizationPercentage": 16.67
  },
  "creditReport": {
    "reportDate": "2026-05-10",
    "reportReference": "EXP-2026-05-234567890"
  }
}
```
Server updates `updatedAt`. Returns complete contract with updated scores.

**Adding Payment Event (PATCH /api/v1/credit-history/credit-654):**
```json
{
  "paymentHistory": {
    "onTimePayments": 147,
    "latePayments": 6,
    "onTimePaymentPercentage": 96.1
  }
}
```
Only specified fields are updated. Returns complete contract.

**Validation Rules:**

1. **Required Fields on Create:** `clientRef`, `creditAgency`, `scoreDate`, `score`, `isConsented`, `consentDate`
2. **Write-Once Fields:** Cannot be changed after creation: `clientRef`, `factFindRef`, `creditAgency`
3. **Consent Validation:** `isConsented` must be true before creating credit check record
4. **Score Range Validation:** `score.scoreValue` must be within `score.scoreRange` (0-999 for Experian, 300-850 for others)
5. **Score Band Validation:** `score.scoreBand` must correspond to `score.scoreValue` for the credit agency
6. **Date Logic:** `scoreDate` must not be in future, `consentExpiryDate` must be > `consentDate`
7. **Utilization Calculation:** `creditUtilization.utilizationPercentage` = (totalCreditUsed / totalCreditAvailable) * 100
8. **Payment History:** `onTimePaymentPercentage` = (onTimePayments / (onTimePayments + latePayments + missedPayments)) * 100
9. **Account Validation:** Each account must have `accountType`, `creditor`, `status`, `openedDate`
10. **Reference Integrity:** `clientRef.id`, `factFindRef.id` must reference existing entities

---

### 13.12 IdentityVerification Contract

The `IdentityVerification` contract represents identity verification status with KYC and AML checks.

**Reference Type:** IdentityVerification is a reference type with identity (has `id` field).

```json
{
  "id": "idverify-987",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "factFindRef": {
    "id": "factfind-123",
    "href": "/api/v1/factfinds/factfind-123",
    "factFindNumber": "FF-2025-00123",
    "status": {
      "code": "INP",
      "display": "In Progress"
    }
  },
  "verificationType": {
    "code": "KYC_AML",
    "display": "KYC & AML Verification"
  },
  "verificationLevel": {
    "code": "ENHANCED",
    "display": "Enhanced Due Diligence"
  },
  "verificationStatus": {
    "code": "VERIFIED",
    "display": "Verified"
  },
  "verificationDate": "2026-02-10T14:30:00Z",
  "verificationExpiryDate": "2027-02-10",
  "isExpired": false,
  "daysUntilExpiry": 365,
  "documents": [
    {
      "documentId": "doc-001",
      "documentType": {
        "code": "PASSPORT",
        "display": "Passport"
      },
      "documentNumber": "502135321",
      "issuingCountry": {
        "code": "GB",
        "display": "United Kingdom",
        "alpha3": "GBR"
      },
      "issueDate": "2020-05-15",
      "expiryDate": "2030-05-15",
      "documentStatus": {
        "code": "VERIFIED",
        "display": "Verified"
      },
      "verifiedDate": "2026-02-10T14:30:00Z",
      "documentImageUrl": "https://secure.documents.example.com/id/doc-001-encrypted",
      "isExpired": false,
      "isPrimary": true
    },
    {
      "documentId": "doc-002",
      "documentType": {
        "code": "UTILITY_BILL",
        "display": "Utility Bill"
      },
      "utilityType": "Electricity",
      "issueDate": "2026-01-15",
      "documentStatus": {
        "code": "VERIFIED",
        "display": "Verified"
      },
      "verifiedDate": "2026-02-10T14:30:00Z",
      "address": {
        "line1": "123 Main Street",
        "line2": "Apartment 4B",
        "city": "London",
        "postcode": "SW1A 1AA",
        "country": {
          "code": "GB",
          "display": "United Kingdom"
        }
      },
      "addressMatched": true,
      "documentImageUrl": "https://secure.documents.example.com/id/doc-002-encrypted",
      "isPrimary": false
    }
  ],
  "identityProvider": {
    "provider": {
      "code": "ONFIDO",
      "display": "Onfido",
      "website": "https://onfido.com"
    },
    "providerReference": "ONFIDO-CHK-123456789",
    "providerCheckId": "chk_abc123def456ghi789",
    "providerScore": 98,
    "providerDecision": {
      "code": "CLEAR",
      "display": "Clear"
    },
    "providerReportUrl": "https://dashboard.onfido.com/checks/chk_abc123def456ghi789",
    "providerResponseDate": "2026-02-10T14:30:00Z"
  },
  "biometricVerification": {
    "faceMatch": {
      "status": {
        "code": "MATCHED",
        "display": "Matched"
      },
      "confidence": 99.5,
      "matchDate": "2026-02-10T14:30:00Z"
    },
    "livenessCheck": {
      "status": {
        "code": "PASSED",
        "display": "Passed"
      },
      "confidence": 98.2,
      "checkDate": "2026-02-10T14:30:00Z"
    }
  },
  "addressVerification": {
    "addressVerified": true,
    "verificationMethod": {
      "code": "DOCUMENT",
      "display": "Document Verification"
    },
    "verifiedAddress": {
      "line1": "123 Main Street",
      "line2": "Apartment 4B",
      "city": "London",
      "postcode": "SW1A 1AA",
      "country": {
        "code": "GB",
        "display": "United Kingdom"
      }
    },
    "addressMatchScore": 100,
    "verificationDate": "2026-02-10T14:30:00Z"
  },
  "amlChecks": {
    "amlStatus": {
      "code": "CLEAR",
      "display": "Clear"
    },
    "amlCheckDate": "2026-02-10T14:30:00Z",
    "amlProvider": {
      "code": "WORLDCHECK",
      "display": "World-Check (Refinitiv)",
      "website": "https://www.refinitiv.com/en/products/world-check-kyc-screening"
    },
    "amlProviderReference": "WC-2026-02-987654321",
    "sanctionsScreening": {
      "status": {
        "code": "CLEAR",
        "display": "Clear"
      },
      "listsChecked": [
        "UN Security Council",
        "EU Sanctions",
        "OFAC SDN",
        "UK HM Treasury",
        "Interpol"
      ],
      "matches": [],
      "checkDate": "2026-02-10T14:30:00Z"
    },
    "pepScreening": {
      "status": {
        "code": "NOT_PEP",
        "display": "Not a Politically Exposed Person"
      },
      "isPep": false,
      "pepCategory": null,
      "pepRelationship": null,
      "pepSource": null,
      "checkDate": "2026-02-10T14:30:00Z"
    },
    "adverseMediaScreening": {
      "status": {
        "code": "CLEAR",
        "display": "Clear"
      },
      "adverseMediaChecked": true,
      "adverseMediaMatches": [],
      "checkDate": "2026-02-10T14:30:00Z"
    },
    "watchlistScreening": {
      "status": {
        "code": "CLEAR",
        "display": "Clear"
      },
      "watchlistsChecked": [
        "FBI Most Wanted",
        "Europol Most Wanted",
        "OFAC Non-SDN Lists",
        "Specially Designated Nationals"
      ],
      "matches": [],
      "checkDate": "2026-02-10T14:30:00Z"
    }
  },
  "riskAssessment": {
    "overallRiskRating": {
      "code": "LOW",
      "display": "Low Risk"
    },
    "riskScore": 15,
    "riskScoreMax": 100,
    "riskFactors": [
      {
        "factor": {
          "code": "CLEAR_AML",
          "display": "Clear AML Check"
        },
        "impact": {
          "code": "POSITIVE",
          "display": "Positive"
        },
        "weight": -10
      },
      {
        "factor": {
          "code": "VERIFIED_IDENTITY",
          "display": "Identity Verified"
        },
        "impact": {
          "code": "POSITIVE",
          "display": "Positive"
        },
        "weight": -15
      },
      {
        "factor": {
          "code": "HIGH_CONFIDENCE_BIOMETRIC",
          "display": "High Confidence Biometric Match"
        },
        "impact": {
          "code": "POSITIVE",
          "display": "Positive"
        },
        "weight": -10
      }
    ],
    "riskNotes": "Low risk client with clear AML checks, verified identity, and high confidence biometric match"
  },
  "regulatoryCompliance": {
    "mlrCompliance": {
      "isCompliant": true,
      "regulationReference": "Money Laundering Regulations 2017",
      "complianceDate": "2026-02-10",
      "notes": "Compliant with UK Money Laundering Regulations 2017"
    },
    "fcaCompliance": {
      "isCompliant": true,
      "regulationReference": "FCA Handbook SYSC 3.2",
      "complianceDate": "2026-02-10",
      "notes": "Compliant with FCA systems and controls requirements"
    },
    "kycCompliance": {
      "isCompliant": true,
      "standardReference": "JMLSG Guidance Part I Chapter 5",
      "complianceDate": "2026-02-10",
      "notes": "Compliant with JMLSG KYC guidance"
    },
    "gdprCompliance": {
      "isCompliant": true,
      "regulationReference": "GDPR Article 6(1)(c)",
      "lawfulBasis": "Legal obligation",
      "complianceDate": "2026-02-10"
    }
  },
  "verificationHistory": [
    {
      "historyId": "hist-001",
      "verificationType": {
        "code": "INITIAL_KYC",
        "display": "Initial KYC"
      },
      "verificationDate": "2020-01-10T10:00:00Z",
      "status": {
        "code": "VERIFIED",
        "display": "Verified"
      },
      "provider": "Experian",
      "providerReference": "EXP-KYC-2020-01-123",
      "expiryDate": "2021-01-10",
      "notes": "Initial client onboarding verification"
    },
    {
      "historyId": "hist-002",
      "verificationType": {
        "code": "ANNUAL_REVIEW",
        "display": "Annual Review"
      },
      "verificationDate": "2021-01-15T09:00:00Z",
      "status": {
        "code": "VERIFIED",
        "display": "Verified"
      },
      "provider": "Experian",
      "providerReference": "EXP-KYC-2021-01-456",
      "expiryDate": "2022-01-15",
      "notes": "Annual KYC review - no changes"
    },
    {
      "historyId": "hist-003",
      "verificationType": {
        "code": "ENHANCED_DD",
        "display": "Enhanced Due Diligence"
      },
      "verificationDate": "2026-02-10T14:30:00Z",
      "status": {
        "code": "VERIFIED",
        "display": "Verified"
      },
      "provider": "Onfido",
      "providerReference": "ONFIDO-CHK-123456789",
      "expiryDate": "2027-02-10",
      "notes": "Enhanced verification with biometric checks"
    }
  ],
  "nextReviewDate": "2027-02-10",
  "reviewFrequency": {
    "code": "ANNUAL",
    "display": "Annual"
  },
  "verifiedBy": {
    "id": "user-789",
    "name": "Jane Doe",
    "role": "Compliance Officer"
  },
  "verifiedAt": "2026-02-10T14:30:00Z",
  "verificationIpAddress": "192.168.1.100",
  "verificationUserAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
  "consentGiven": true,
  "consentDate": "2026-02-10T14:00:00Z",
  "consentReference": "consent-123",
  "dataProtectionNoticeProvided": true,
  "dataProtectionNoticeVersion": "2.1",
  "dataProtectionNoticeDate": "2026-02-10T14:00:00Z",
  "notes": "Enhanced verification completed successfully. All checks clear. High confidence biometric match. No adverse findings.",
  "documents": [
    {
      "documentId": "doc-verify-001",
      "type": {
        "code": "VERIFICATION_REPORT",
        "display": "Identity Verification Report"
      },
      "name": "Onfido Verification Report - Feb 2026",
      "date": "2026-02-10",
      "url": "/api/v1/documents/doc-verify-001"
    },
    {
      "documentId": "doc-verify-002",
      "type": {
        "code": "AML_REPORT",
        "display": "AML Screening Report"
      },
      "name": "World-Check AML Report - Feb 2026",
      "date": "2026-02-10",
      "url": "/api/v1/documents/doc-verify-002"
    }
  ],
  "createdAt": "2026-02-10T14:30:00Z",
  "updatedAt": "2026-02-10T15:00:00Z",
  "createdBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "updatedBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "_links": {
    "self": { "href": "/api/v1/identity-verification/idverify-987" },
    "update": { "href": "/api/v1/identity-verification/idverify-987", "method": "PUT" },
    "delete": { "href": "/api/v1/identity-verification/idverify-987", "method": "DELETE" },
    "client": { "href": "/api/v1/clients/client-123" },
    "factfind": { "href": "/api/v1/factfinds/factfind-123" },
    "verificationReport": { "href": "/api/v1/documents/doc-verify-001" },
    "amlReport": { "href": "/api/v1/documents/doc-verify-002" },
    "history": { "href": "/api/v1/identity-verification/idverify-987/history" },
    "renew": { "href": "/api/v1/identity-verification/idverify-987/renew", "method": "POST" }
  }
}
```

**Field Behaviors:**

| Field | Type | Create | Update | Response | Notes |
|-------|------|--------|--------|----------|-------|
| `id` | uuid | ignored | ignored | included | read-only, server-generated |
| `clientRef` | ClientRef | required | ignored | included | Reference to client, write-once |
| `factFindRef` | FactFindRef | optional | ignored | included | Reference to owning FactFind, write-once |
| `verificationType` | CodeValue | required | ignored | included | write-once, KYC/AML/EnhancedDueDiligence |
| `verificationLevel` | CodeValue | optional | updatable | included | Standard/Enhanced/Simplified |
| `verificationStatus` | CodeValue | required | updatable | included | Pending/InProgress/Verified/Failed/Expired |
| `verificationDate` | timestamp | required | updatable | included | Date/time of verification |
| `verificationExpiryDate` | date | optional | updatable | included | Verification expiry date |
| `isExpired` | boolean | ignored | ignored | included | read-only, computed from expiryDate |
| `daysUntilExpiry` | integer | ignored | ignored | included | read-only, computed |
| `documents` | array | required | updatable | included | Array of identity documents |
| `identityProvider` | object | optional | updatable | included | Third-party verification provider details |
| `biometricVerification` | object | optional | updatable | included | Face match and liveness check results |
| `addressVerification` | object | optional | updatable | included | Address verification details |
| `amlChecks` | object | required | updatable | included | AML checks including sanctions, PEP, adverse media |
| `riskAssessment` | object | optional | updatable | included | Overall risk rating and factors |
| `regulatoryCompliance` | object | optional | updatable | included | Compliance with MLR, FCA, KYC, GDPR |
| `verificationHistory` | array | optional | updatable | included | Historical verification records |
| `nextReviewDate` | date | optional | updatable | included | Next scheduled review date |
| `reviewFrequency` | CodeValue | optional | updatable | included | Monthly/Quarterly/Annual |
| `verifiedBy` | object | required | updatable | included | User who performed verification |
| `verifiedAt` | timestamp | required | updatable | included | Verification timestamp |
| `verificationIpAddress` | string | optional | updatable | included | IP address of verification |
| `verificationUserAgent` | string | optional | updatable | included | User agent of verification |
| `consentGiven` | boolean | required | updatable | included | Whether consent was given |
| `consentDate` | timestamp | optional | updatable | included | Date of consent |
| `consentReference` | string | optional | updatable | included | Reference to consent record |
| `dataProtectionNoticeProvided` | boolean | optional | updatable | included | Whether data protection notice was provided |
| `dataProtectionNoticeVersion` | string | optional | updatable | included | Version of data protection notice |
| `dataProtectionNoticeDate` | timestamp | optional | updatable | included | Date notice was provided |
| `notes` | string | optional | updatable | included | Additional notes |
| `documents` | array | optional | updatable | included | Array of document references |
| `createdAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `updatedAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `createdBy` | object | ignored | ignored | included | read-only, audit trail |
| `updatedBy` | object | ignored | ignored | included | read-only, audit trail |
| `_links` | object | ignored | ignored | included | read-only, HATEOAS links |

**Usage Examples:**

**Submitting Identity Verification (POST /api/v1/identity-verification):**
```json
{
  "clientRef": { "id": "client-123" },
  "factFindRef": { "id": "factfind-123" },
  "verificationType": { "code": "KYC_AML" },
  "verificationLevel": { "code": "ENHANCED" },
  "verificationStatus": { "code": "PENDING" },
  "verificationDate": "2026-02-10T14:30:00Z",
  "documents": [
    {
      "documentType": { "code": "PASSPORT" },
      "documentNumber": "502135321",
      "issuingCountry": { "code": "GB" },
      "issueDate": "2020-05-15",
      "expiryDate": "2030-05-15",
      "isPrimary": true
    }
  ],
  "amlChecks": {
    "amlStatus": { "code": "PENDING" }
  },
  "consentGiven": true,
  "consentDate": "2026-02-10T14:00:00Z",
  "verifiedBy": { "id": "user-789" },
  "verifiedAt": "2026-02-10T14:30:00Z"
}
```
Server generates `id`, `createdAt`, `updatedAt`. Returns complete contract.

**Updating Verification Status (PUT /api/v1/identity-verification/idverify-987):**
```json
{
  "verificationStatus": { "code": "VERIFIED" },
  "verificationDate": "2026-02-10T14:30:00Z",
  "verificationExpiryDate": "2027-02-10",
  "identityProvider": {
    "provider": { "code": "ONFIDO" },
    "providerReference": "ONFIDO-CHK-123456789",
    "providerScore": 98,
    "providerDecision": { "code": "CLEAR" }
  },
  "amlChecks": {
    "amlStatus": { "code": "CLEAR" },
    "amlCheckDate": "2026-02-10T14:30:00Z",
    "sanctionsScreening": {
      "status": { "code": "CLEAR" }
    },
    "pepScreening": {
      "status": { "code": "NOT_PEP" },
      "isPep": false
    }
  },
  "riskAssessment": {
    "overallRiskRating": { "code": "LOW" },
    "riskScore": 15
  }
}
```
Server updates `updatedAt`. Returns complete contract with verification complete.

**Adding AML Result (PATCH /api/v1/identity-verification/idverify-987):**
```json
{
  "amlChecks": {
    "amlStatus": { "code": "CLEAR" },
    "amlProvider": { "code": "WORLDCHECK" },
    "amlProviderReference": "WC-2026-02-987654321",
    "sanctionsScreening": {
      "status": { "code": "CLEAR" },
      "matches": []
    },
    "adverseMediaScreening": {
      "status": { "code": "CLEAR" },
      "adverseMediaMatches": []
    }
  }
}
```
Only specified fields are updated. Returns complete contract.

**Validation Rules:**

1. **Required Fields on Create:** `clientRef`, `verificationType`, `verificationStatus`, `verificationDate`, `documents`, `amlChecks`, `consentGiven`, `verifiedBy`, `verifiedAt`
2. **Write-Once Fields:** Cannot be changed after creation: `clientRef`, `factFindRef`, `verificationType`
3. **Consent Validation:** `consentGiven` must be true before verification can be performed
4. **Document Validation:** At least one primary identity document (Passport/DrivingLicense) must be provided
5. **Document Expiry:** Identity documents must not be expired (expiryDate must be in future)
6. **AML Requirements:** For `verificationStatus` = "VERIFIED", `amlChecks.amlStatus` must be "CLEAR" or "REVIEW"
7. **Biometric Validation:** If biometric verification is used, confidence scores must be > 90%
8. **Address Match:** For address verification, `addressMatchScore` should be > 80%
9. **Date Logic:** `verificationDate` must not be in future, `verificationExpiryDate` must be > `verificationDate`
10. **Reference Integrity:** `clientRef.id`, `factFindRef.id` must reference existing entities

---

### 13.13 Consent Contract

The `Consent` contract represents GDPR consent tracking with purpose-specific consents and audit trail.

**Reference Type:** Consent is a reference type with identity (has `id` field).

```json
{
  "id": "consent-555",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "factFindRef": {
    "id": "factfind-123",
    "href": "/api/v1/factfinds/factfind-123",
    "factFindNumber": "FF-2025-00123",
    "status": {
      "code": "INP",
      "display": "In Progress"
    }
  },
  "consentPurpose": {
    "code": "DATA_PROCESSING",
    "display": "Data Processing"
  },
  "consentPurposeDescription": "Processing of personal and financial data for the purpose of financial advice and planning",
  "consentStatus": {
    "code": "GIVEN",
    "display": "Consent Given"
  },
  "consentGivenDate": "2026-02-10T14:00:00Z",
  "consentWithdrawnDate": null,
  "consentExpiryDate": "2028-02-10",
  "isExpired": false,
  "daysUntilExpiry": 730,
  "isActive": true,
  "consentMethod": {
    "code": "EXPLICIT",
    "display": "Explicit Consent"
  },
  "consentChannel": {
    "code": "WEB",
    "display": "Web Portal"
  },
  "consentVersion": "2.1",
  "consentText": "I consent to the collection, storage, and processing of my personal and financial data for the purpose of receiving financial advice and planning services. I understand that my data will be processed in accordance with the Privacy Policy and GDPR regulations.",
  "lawfulBasis": {
    "code": "CONSENT",
    "display": "Consent (GDPR Article 6(1)(a))"
  },
  "lawfulBasisDetails": "Consent freely given for data processing under GDPR Article 6(1)(a)",
  "specialCategoryData": {
    "isSpecialCategory": false,
    "specialCategoryTypes": [],
    "lawfulBasisSpecialCategory": null
  },
  "dataProcessing": {
    "dataCategories": [
      {
        "category": {
          "code": "PERSONAL_IDENTITY",
          "display": "Personal Identity Data"
        },
        "dataTypes": [
          "Name",
          "Date of Birth",
          "Address",
          "Contact Details",
          "National Insurance Number"
        ]
      },
      {
        "category": {
          "code": "FINANCIAL",
          "display": "Financial Data"
        },
        "dataTypes": [
          "Income",
          "Expenditure",
          "Assets",
          "Liabilities",
          "Investment Holdings",
          "Pension Details"
        ]
      },
      {
        "category": {
          "code": "EMPLOYMENT",
          "display": "Employment Data"
        },
        "dataTypes": [
          "Employer Details",
          "Employment History",
          "Salary Information"
        ]
      }
    ],
    "processingActivities": [
      {
        "activity": {
          "code": "STORAGE",
          "display": "Data Storage"
        },
        "description": "Secure storage of client data in encrypted databases",
        "purpose": "Maintaining client records for advice delivery"
      },
      {
        "activity": {
          "code": "ANALYSIS",
          "display": "Data Analysis"
        },
        "description": "Analysis of financial circumstances for advice purposes",
        "purpose": "Delivering personalized financial advice"
      },
      {
        "activity": {
          "code": "COMMUNICATION",
          "display": "Communication"
        },
        "description": "Sending advice recommendations and updates to client",
        "purpose": "Ongoing client service and advice delivery"
      }
    ],
    "dataRetentionPeriod": {
      "value": 7,
      "unit": "years",
      "reason": "Regulatory requirement - FCA indefinite retention for advised products"
    },
    "dataSharedWith": [
      {
        "recipient": {
          "code": "PRODUCT_PROVIDER",
          "display": "Product Providers"
        },
        "recipientName": "Various Insurance and Investment Providers",
        "purpose": "Product application and policy administration",
        "dataCategories": [
          "Personal Identity Data",
          "Financial Data",
          "Health Data (for protection products)"
        ],
        "legalBasis": "Contract fulfillment",
        "isOutsideEEA": false
      },
      {
        "recipient": {
          "code": "REGULATOR",
          "display": "Regulatory Bodies"
        },
        "recipientName": "Financial Conduct Authority (FCA)",
        "purpose": "Regulatory compliance and oversight",
        "dataCategories": [
          "Personal Identity Data",
          "Financial Data",
          "Advice Records"
        ],
        "legalBasis": "Legal obligation",
        "isOutsideEEA": false
      },
      {
        "recipient": {
          "code": "IT_PROVIDER",
          "display": "IT Service Providers"
        },
        "recipientName": "Microsoft Azure, AWS",
        "purpose": "Cloud hosting and data processing",
        "dataCategories": [
          "All client data"
        ],
        "legalBasis": "Data Processing Agreement",
        "isOutsideEEA": false,
        "adequacyDecision": "EU-US Data Privacy Framework"
      }
    ]
  },
  "marketingConsent": {
    "hasMarketingConsent": true,
    "marketingConsentDate": "2026-02-10T14:00:00Z",
    "marketingChannels": [
      {
        "channel": {
          "code": "EMAIL",
          "display": "Email"
        },
        "isConsented": true,
        "consentDate": "2026-02-10T14:00:00Z"
      },
      {
        "channel": {
          "code": "PHONE",
          "display": "Phone"
        },
        "isConsented": false,
        "consentDate": null
      },
      {
        "channel": {
          "code": "SMS",
          "display": "SMS"
        },
        "isConsented": false,
        "consentDate": null
      },
      {
        "channel": {
          "code": "POST",
          "display": "Post"
        },
        "isConsented": true,
        "consentDate": "2026-02-10T14:00:00Z"
      }
    ],
    "marketingFrequency": {
      "code": "MONTHLY",
      "display": "Monthly"
    },
    "marketingInterests": [
      "Investment Opportunities",
      "Retirement Planning",
      "Tax Planning",
      "Estate Planning"
    ],
    "thirdPartyMarketing": {
      "isConsented": false,
      "consentDate": null
    }
  },
  "profilingConsent": {
    "hasProfilingConsent": true,
    "profilingConsentDate": "2026-02-10T14:00:00Z",
    "profilingPurpose": "Risk profiling and investment suitability assessment",
    "automatedDecisionMaking": {
      "isUsed": true,
      "description": "Automated risk assessment questionnaire scoring",
      "humanReview": true
    }
  },
  "thirdPartySharing": {
    "hasThirdPartyConsent": true,
    "thirdPartyConsentDate": "2026-02-10T14:00:00Z",
    "thirdParties": [
      "Product Providers (for applications)",
      "Credit Reference Agencies (for creditworthiness)",
      "Identity Verification Providers"
    ]
  },
  "privacyPolicy": {
    "privacyPolicyVersion": "2.1",
    "privacyPolicyUrl": "https://www.example-advisor.com/privacy-policy",
    "privacyPolicyAcceptedDate": "2026-02-10T14:00:00Z",
    "privacyPolicyEffectiveDate": "2026-01-01",
    "privacyPolicyLastUpdated": "2026-01-01",
    "privacyNoticeProvided": true,
    "privacyNoticeMethod": {
      "code": "ONLINE",
      "display": "Online Privacy Notice"
    }
  },
  "dataSubjectRights": {
    "rightsInformed": true,
    "rightsInformedDate": "2026-02-10T14:00:00Z",
    "rightToAccess": {
      "rightExplained": true,
      "requestsReceived": 0,
      "lastRequestDate": null
    },
    "rightToRectification": {
      "rightExplained": true,
      "requestsReceived": 0,
      "lastRequestDate": null
    },
    "rightToErasure": {
      "rightExplained": true,
      "requestsReceived": 0,
      "lastRequestDate": null,
      "limitations": "Data may be retained for regulatory compliance (FCA rules)"
    },
    "rightToRestriction": {
      "rightExplained": true,
      "requestsReceived": 0,
      "lastRequestDate": null
    },
    "rightToDataPortability": {
      "rightExplained": true,
      "requestsReceived": 0,
      "lastRequestDate": null
    },
    "rightToObject": {
      "rightExplained": true,
      "requestsReceived": 0,
      "lastRequestDate": null
    },
    "rightToWithdrawConsent": {
      "rightExplained": true,
      "canWithdraw": true,
      "withdrawalMethod": "Email, phone, or written request",
      "withdrawalImpact": "May affect ability to provide advice services"
    }
  },
  "dsarHistory": [
    {
      "requestId": "dsar-001",
      "requestType": {
        "code": "ACCESS",
        "display": "Data Subject Access Request"
      },
      "requestDate": "2025-06-15T10:00:00Z",
      "requestMethod": {
        "code": "EMAIL",
        "display": "Email"
      },
      "responseDate": "2025-07-10T16:00:00Z",
      "responseMethod": {
        "code": "SECURE_PORTAL",
        "display": "Secure Online Portal"
      },
      "status": {
        "code": "COMPLETED",
        "display": "Completed"
      },
      "notes": "Full data export provided within 30 days"
    }
  ],
  "consentRenewal": {
    "renewalRequired": true,
    "renewalDate": "2028-02-10",
    "renewalFrequency": {
      "code": "BIENNIAL",
      "display": "Every 2 Years"
    },
    "renewalReminderSent": false,
    "renewalReminderDate": null,
    "renewalHistory": [
      {
        "renewalId": "ren-001",
        "previousConsentDate": "2024-02-10",
        "renewalDate": "2026-02-10",
        "renewalMethod": {
          "code": "ONLINE",
          "display": "Online Renewal"
        },
        "changesFromPrevious": "Updated privacy policy version, added cloud provider information"
      }
    ]
  },
  "audit": {
    "consentRecordedBy": {
      "id": "user-789",
      "name": "Jane Doe",
      "role": "Financial Adviser"
    },
    "consentRecordedAt": "2026-02-10T14:00:00Z",
    "ipAddress": "192.168.1.100",
    "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    "deviceType": "Desktop",
    "location": {
      "country": "United Kingdom",
      "city": "London"
    },
    "consentEvidence": {
      "evidenceType": {
        "code": "CHECKBOX",
        "display": "Checkbox Selection"
      },
      "evidenceUrl": "/api/v1/consent-evidence/consent-555",
      "evidenceTimestamp": "2026-02-10T14:00:00Z",
      "witnessRequired": false
    },
    "verificationMethod": {
      "code": "EMAIL_VERIFIED",
      "display": "Email Verified"
    }
  },
  "complianceChecks": {
    "gdprCompliant": true,
    "gdprComplianceDate": "2026-02-10",
    "pecompliant": true,
    "peComplianceDate": "2026-02-10",
    "fcaCompliant": true,
    "fcaComplianceDate": "2026-02-10",
    "lastComplianceReview": "2026-02-10",
    "nextComplianceReview": "2027-02-10"
  },
  "relatedConsents": [
    {
      "consentId": "consent-556",
      "consentPurpose": {
        "code": "MARKETING",
        "display": "Marketing Communications"
      },
      "href": "/api/v1/consents/consent-556"
    },
    {
      "consentId": "consent-557",
      "consentPurpose": {
        "code": "THIRD_PARTY_SHARING",
        "display": "Third Party Data Sharing"
      },
      "href": "/api/v1/consents/consent-557"
    }
  ],
  "notes": "Initial consent obtained during client onboarding. Client fully informed of data processing activities and rights. Marketing consent given for email and post only.",
  "documents": [
    {
      "documentId": "doc-consent-001",
      "type": {
        "code": "CONSENT_FORM",
        "display": "Consent Form"
      },
      "name": "Data Processing Consent Form - Signed",
      "date": "2026-02-10",
      "url": "/api/v1/documents/doc-consent-001"
    },
    {
      "documentId": "doc-consent-002",
      "type": {
        "code": "PRIVACY_NOTICE",
        "display": "Privacy Notice"
      },
      "name": "Privacy Notice v2.1",
      "date": "2026-01-01",
      "url": "/api/v1/documents/doc-consent-002"
    }
  ],
  "createdAt": "2026-02-10T14:00:00Z",
  "updatedAt": "2026-02-10T14:30:00Z",
  "createdBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "updatedBy": {
    "id": "user-789",
    "name": "Jane Doe"
  },
  "_links": {
    "self": { "href": "/api/v1/consents/consent-555" },
    "update": { "href": "/api/v1/consents/consent-555", "method": "PUT" },
    "withdraw": { "href": "/api/v1/consents/consent-555/withdraw", "method": "POST" },
    "renew": { "href": "/api/v1/consents/consent-555/renew", "method": "POST" },
    "delete": { "href": "/api/v1/consents/consent-555", "method": "DELETE" },
    "client": { "href": "/api/v1/clients/client-123" },
    "factfind": { "href": "/api/v1/factfinds/factfind-123" },
    "consentForm": { "href": "/api/v1/documents/doc-consent-001" },
    "privacyNotice": { "href": "/api/v1/documents/doc-consent-002" },
    "evidence": { "href": "/api/v1/consent-evidence/consent-555" },
    "dsarRequests": { "href": "/api/v1/consents/consent-555/dsar-requests" },
    "history": { "href": "/api/v1/consents/consent-555/history" }
  }
}
```

**Field Behaviors:**

| Field | Type | Create | Update | Response | Notes |
|-------|------|--------|--------|----------|-------|
| `id` | uuid | ignored | ignored | included | read-only, server-generated |
| `clientRef` | ClientRef | required | ignored | included | Reference to client, write-once |
| `factFindRef` | FactFindRef | optional | ignored | included | Reference to owning FactFind, write-once |
| `consentPurpose` | CodeValue | required | ignored | included | write-once, DataProcessing/Marketing/Profiling/ThirdPartySharing |
| `consentPurposeDescription` | string | optional | updatable | included | Detailed description of purpose |
| `consentStatus` | CodeValue | required | updatable | included | Given/Withdrawn/Expired |
| `consentGivenDate` | timestamp | required | updatable | included | Date/time consent was given |
| `consentWithdrawnDate` | timestamp | optional | updatable | included | Date/time consent was withdrawn |
| `consentExpiryDate` | date | optional | updatable | included | Consent expiry date |
| `isExpired` | boolean | ignored | ignored | included | read-only, computed from expiryDate |
| `daysUntilExpiry` | integer | ignored | ignored | included | read-only, computed |
| `isActive` | boolean | ignored | ignored | included | read-only, status is Given and not expired |
| `consentMethod` | CodeValue | required | updatable | included | Explicit/Implicit/LegitimateInterest |
| `consentChannel` | CodeValue | required | updatable | included | Web/Mobile/InPerson/Email/Phone |
| `consentVersion` | string | optional | updatable | included | Version of consent form |
| `consentText` | string | optional | updatable | included | Actual consent text shown to client |
| `lawfulBasis` | CodeValue | required | updatable | included | GDPR lawful basis (Consent/Contract/LegalObligation/etc) |
| `lawfulBasisDetails` | string | optional | updatable | included | Details of lawful basis |
| `specialCategoryData` | object | optional | updatable | included | Special category data processing details |
| `dataProcessing` | object | required | updatable | included | Data categories, processing activities, retention |
| `marketingConsent` | object | optional | updatable | included | Marketing consent with channels and preferences |
| `profilingConsent` | object | optional | updatable | included | Profiling and automated decision making consent |
| `thirdPartySharing` | object | optional | updatable | included | Third party data sharing consent |
| `privacyPolicy` | object | required | updatable | included | Privacy policy details and acceptance |
| `dataSubjectRights` | object | required | updatable | included | Data subject rights information and exercise history |
| `dsarHistory` | array | optional | updatable | included | Data Subject Access Request history |
| `consentRenewal` | object | optional | updatable | included | Consent renewal requirements and history |
| `audit` | object | required | updatable | included | Audit trail of consent recording |
| `complianceChecks` | object | optional | updatable | included | GDPR, PECR, FCA compliance checks |
| `relatedConsents` | array | optional | updatable | included | References to related consent records |
| `notes` | string | optional | updatable | included | Additional notes |
| `documents` | array | optional | updatable | included | Array of document references |
| `createdAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `updatedAt` | timestamp | ignored | ignored | included | read-only, server-generated |
| `createdBy` | object | ignored | ignored | included | read-only, audit trail |
| `updatedBy` | object | ignored | ignored | included | read-only, audit trail |
| `_links` | object | ignored | ignored | included | read-only, HATEOAS links |

**Usage Examples:**

**Recording Consent (POST /api/v1/consents):**
```json
{
  "clientRef": { "id": "client-123" },
  "factFindRef": { "id": "factfind-123" },
  "consentPurpose": { "code": "DATA_PROCESSING" },
  "consentPurposeDescription": "Processing of personal and financial data for financial advice",
  "consentStatus": { "code": "GIVEN" },
  "consentGivenDate": "2026-02-10T14:00:00Z",
  "consentMethod": { "code": "EXPLICIT" },
  "consentChannel": { "code": "WEB" },
  "lawfulBasis": { "code": "CONSENT" },
  "dataProcessing": {
    "dataCategories": [
      {
        "category": { "code": "PERSONAL_IDENTITY" },
        "dataTypes": ["Name", "Date of Birth", "Address"]
      }
    ],
    "dataRetentionPeriod": {
      "value": 7,
      "unit": "years"
    }
  },
  "privacyPolicy": {
    "privacyPolicyVersion": "2.1",
    "privacyPolicyUrl": "https://www.example-advisor.com/privacy-policy",
    "privacyPolicyAcceptedDate": "2026-02-10T14:00:00Z"
  },
  "dataSubjectRights": {
    "rightsInformed": true,
    "rightsInformedDate": "2026-02-10T14:00:00Z"
  },
  "audit": {
    "consentRecordedBy": { "id": "user-789" },
    "consentRecordedAt": "2026-02-10T14:00:00Z",
    "ipAddress": "192.168.1.100"
  }
}
```
Server generates `id`, `createdAt`, `updatedAt`. Returns complete contract.

**Updating Marketing Preferences (PUT /api/v1/consents/consent-555):**
```json
{
  "marketingConsent": {
    "hasMarketingConsent": true,
    "marketingChannels": [
      {
        "channel": { "code": "EMAIL" },
        "isConsented": true,
        "consentDate": "2026-02-10T14:00:00Z"
      },
      {
        "channel": { "code": "PHONE" },
        "isConsented": true,
        "consentDate": "2026-02-18T10:00:00Z"
      }
    ],
    "marketingFrequency": { "code": "MONTHLY" }
  }
}
```
Server updates `updatedAt`. Returns complete contract with updated preferences.

**Withdrawing Consent (PATCH /api/v1/consents/consent-555/withdraw):**
```json
{
  "consentStatus": { "code": "WITHDRAWN" },
  "consentWithdrawnDate": "2026-06-15T10:00:00Z",
  "notes": "Client requested withdrawal of marketing consent via email"
}
```
Server updates status and withdrawal date. Returns complete contract.

**Validation Rules:**

1. **Required Fields on Create:** `clientRef`, `consentPurpose`, `consentStatus`, `consentGivenDate`, `consentMethod`, `consentChannel`, `lawfulBasis`, `dataProcessing`, `privacyPolicy`, `dataSubjectRights`, `audit`
2. **Write-Once Fields:** Cannot be changed after creation: `clientRef`, `factFindRef`, `consentPurpose`
3. **Status Validation:** If `consentStatus` is "GIVEN", `consentGivenDate` must be provided. If "WITHDRAWN", `consentWithdrawnDate` must be provided
4. **Date Logic:** `consentGivenDate` must not be in future, `consentWithdrawnDate` must be > `consentGivenDate`
5. **Lawful Basis:** For `lawfulBasis` = "CONSENT", consent must be freely given, specific, informed, and unambiguous
6. **Data Categories:** At least one data category must be specified in `dataProcessing.dataCategories`
7. **Retention Period:** `dataProcessing.dataRetentionPeriod` must be specified and justified
8. **Privacy Policy:** `privacyPolicy.privacyPolicyAcceptedDate` must be provided and not in future
9. **Marketing Consent:** If marketing consent is given, at least one marketing channel must have `isConsented` = true
10. **Reference Integrity:** `clientRef.id`, `factFindRef.id` must reference existing entities

---

### 13.14 Collection Response Wrapper

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

### 13.15 Contract Extension for Other Entities

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

### 13.16 Standard Value Types

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
  "financialProfile": {
    "grossAnnualIncome": {
      "amount": 75000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
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

### 13.17 Standard Reference Types

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

**Document Version:** 2.0
**Status:** Design Specification v2.0 - Enhanced with Missing Entities
**Date:** 2026-02-17
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
