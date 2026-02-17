# FactFind API Design - Executive Summary

**Document:** FactFind-API-Design.md
**Version:** 2.0
**Date:** 2026-02-17
**Status:** Implementation Ready - Refactored for Single Root Aggregate Pattern

---

## Overview

A comprehensive RESTful API design specification for a wealth management platform following **strict Domain-Driven Design (DDD) principles** with **FactFind as the ONLY root aggregate**. This architectural pattern ensures transactional consistency, clear ownership boundaries, and proper business rule enforcement across all 39 entities and 8 bounded contexts.

---

## Key Architectural Decision: Single Root Aggregate

**CRITICAL CHANGE:** The API has been refactored to use **FactFind as the single aggregate root** for all business data.

###  OLD Structure (Multi-Root):
```
/api/v1/clients              (Independent root)
/api/v1/arrangements         (Independent root)
/api/v1/goals                (Independent root)
/api/v1/risk-profiles        (Independent root)
```

### NEW Structure (Single Root):
```
/api/v1/factfinds                                  (ONLY root aggregate)
/api/v1/factfinds/{factfindId}/clients             (Nested - clients in this fact find)
/api/v1/factfinds/{factfindId}/arrangements        (Nested - arrangements in this fact find)
/api/v1/factfinds/{factfindId}/goals               (Nested - goals in this fact find)
/api/v1/factfinds/{factfindId}/risk-profile        (Nested - risk profile for this fact find)
/api/v1/factfinds/{factfindId}/assets              (Nested - assets in this fact find)
/api/v1/factfinds/{factfindId}/liabilities         (Nested - liabilities in this fact find)
/api/v1/factfinds/{factfindId}/gifts               (Nested - gifts in this fact find)
/api/v1/factfinds/{factfindId}/income              (Nested - income in this fact find)
/api/v1/factfinds/{factfindId}/expenditure         (Nested - expenditure in this fact find)
/api/v1/factfinds/{factfindId}/complete            (Get entire aggregate)
```

**Exception:** Reference Data remains system-wide:
```
/api/v1/reference/genders                          (System-wide lookups)
/api/v1/reference/countries
/api/v1/reference/providers
/api/v1/reference/product-types
```

---

## Key Metrics

### Coverage
- **Total Entities:** 39 entities from Greenfield ERD
- **Total Fields:** 1,786 business fields mapped
- **Bounded Contexts:** 8 DDD-aligned domains
- **API Endpoints:** 100+ fully specified operations (all nested under FactFind)
- **Data Transfer Objects:** 50+ complete DTOs defined

### Compliance
- **FCA Handbook:** COBS, PROD, ICOBS alignment
- **MiFID II:** Suitability and appropriateness assessments
- **GDPR:** Data protection and consent management
- **Consumer Duty:** Vulnerable customer support
- **MLR 2017:** AML/KYC requirements

### Industry Standards
- **Terminology:** Aligned with Intelligent Office, Salesforce FSC, Xplan
- **Data Formats:** ISO 8601 (dates), ISO 4217 (currencies), ISO 3166 (countries)
- **Error Handling:** RFC 7807 Problem Details format
- **Security:** OAuth 2.0 with JWT tokens

---

## API Domains

### 1. FactFind API - Root Aggregate (20+ endpoints)

**Purpose:** Manage fact-finding sessions - the single aggregate root for all business data

**Key Operations:**
```
POST   /api/v1/factfinds                           (Create fact find - ONLY top-level POST)
GET    /api/v1/factfinds                           (List fact finds)
GET    /api/v1/factfinds/{id}                      (Get fact find)
PUT    /api/v1/factfinds/{id}                      (Update fact find)
DELETE /api/v1/factfinds/{id}                      (Delete fact find - cascades to ALL data)
GET    /api/v1/factfinds/{id}/complete             (Get entire aggregate with all nested entities)
POST   /api/v1/factfinds/{id}/complete             (Mark fact find as complete)
GET    /api/v1/factfinds/{id}/summary              (Get financial summary)
```

**Highlights:**
- Single and joint fact finds
- Real-time financial summary calculations
- Affordability assessments (MCOB compliance)
- Complete aggregate retrieval in single request
- Transactional boundary for all nested entities

---

### 2. FactFind Clients API (25+ endpoints)

**Purpose:** Client identity management within fact find context

**Key Entities:**
- CLIENT (96 fields) - Person, Corporate, Trust polymorphic types
- ADDRESS (18 fields) - Residential, correspondence, previous
- CONTACT_DETAIL (20 fields) - Email, phone, social media
- DEPENDANT (18 fields) - Financial dependants
- VULNERABILITY (8 fields) - Consumer Duty compliance

**Sample Endpoints:**
```
POST   /api/v1/factfinds/{factfindId}/clients
GET    /api/v1/factfinds/{factfindId}/clients
GET    /api/v1/factfinds/{factfindId}/clients/{clientId}
PUT    /api/v1/factfinds/{factfindId}/clients/{clientId}
POST   /api/v1/factfinds/{factfindId}/clients/{clientId}/addresses
POST   /api/v1/factfinds/{factfindId}/clients/{clientId}/contacts
PUT    /api/v1/factfinds/{factfindId}/clients/{clientId}/vulnerability
GET    /api/v1/factfinds/{factfindId}/clients/{clientId}/dependants
```

**Highlights:**
- Polymorphic client types (Person, Corporate, Trust)
- PII obfuscation with special scopes
- Identity verification document tracking
- Vulnerability assessment for Consumer Duty
- All clients scoped to specific fact find

**Why Nested:** A client in this context represents a client participating in this specific fact-finding session. The same person could be in multiple fact finds over time.

---

### 3. FactFind Income & Expenditure API (20+ endpoints)

**Purpose:** Income and expenditure discovery within fact find

**Key Entities:**
- EMPLOYMENT (44 fields) - Employment history
- INCOME (36 fields) - Multi-source income tracking
- INCOME_CHANGE (6 fields) - Future income projections
- EXPENDITURE (6 fields) - Essential vs discretionary
- EXPENDITURE_CHANGE (6 fields) - Future expenditure changes

**Sample Endpoints:**
```
POST   /api/v1/factfinds/{factfindId}/employment
POST   /api/v1/factfinds/{factfindId}/income
POST   /api/v1/factfinds/{factfindId}/expenditure
GET    /api/v1/factfinds/{factfindId}/income-changes
GET    /api/v1/factfinds/{factfindId}/affordability
```

**Calculated Fields:**
- Total earned annual income (gross/net)
- Total monthly expenditure (essential/discretionary)
- Monthly disposable income
- Emergency fund shortfall
- Affordability ratios

---

### 4. FactFind Arrangements API (30+ endpoints)

**Purpose:** Manage existing financial arrangements discovered during fact finding

**Key Entities:**
- ARRANGEMENT (300+ fields) - Polymorphic product types
- CONTRIBUTION (24 fields) - Regular and single contributions
- WITHDRAWAL (20 fields) - Income and withdrawals
- BENEFICIARY (11 fields) - Beneficiary designations
- VALUATION (10 fields) - Current and historical values

**Product Coverage:**
- **Pensions:** Personal Pension, SIPP, SSAS, DB, DC, State Pension
- **Investments:** ISA, GIA, Offshore Bond, Onshore Bond, Investment Trust
- **Protection:** Life Assurance, Critical Illness, Income Protection
- **Mortgages:** Residential, Buy-to-Let, Commercial, Equity Release
- **Savings:** Savings Accounts, Cash ISA, Fixed Rate Bonds
- **Insurance:** Buildings, Contents, Motor, Travel
- **Annuities:** Lifetime, Fixed Term, Enhanced

**Sample Endpoints:**
```
POST   /api/v1/factfinds/{factfindId}/arrangements
GET    /api/v1/factfinds/{factfindId}/arrangements
GET    /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}
POST   /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions
POST   /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/valuations
POST   /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/withdrawals
GET    /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/beneficiaries
```

**Why Nested:** Arrangements are discovered/recorded during fact finding. Each fact find captures arrangements at a point in time. Same arrangement could be recorded in multiple fact finds.

---

### 5. FactFind Goals API (15+ endpoints)

**Purpose:** Financial goal setting and tracking within fact find context

**Key Entities:**
- GOAL (30+ fields) - Financial goals
- OBJECTIVE (15+ fields) - Specific objectives
- NEED (10+ fields) - Client needs

**Goal Types:**
- Investment
- Retirement
- Protection
- Mortgage
- Budget
- EstatePlanning
- EquityRelease

**Sample Endpoints:**
```
POST   /api/v1/factfinds/{factfindId}/goals
GET    /api/v1/factfinds/{factfindId}/goals
GET    /api/v1/factfinds/{factfindId}/goals/{goalId}
PUT    /api/v1/factfinds/{factfindId}/goals/{goalId}
POST   /api/v1/factfinds/{factfindId}/goals/{goalId}/complete
POST   /api/v1/factfinds/{factfindId}/goals/{goalId}/objectives
GET    /api/v1/factfinds/{factfindId}/goals/{goalId}/funding
```

**Why Nested:** Goals are identified during fact finding. Goals are specific to the fact find session and tied to the discovered circumstances.

---

### 6. FactFind Assets & Liabilities API (15+ endpoints)

**Purpose:** Asset and liability management within fact find

**Key Entities:**
- ASSET (24 fields) - General assets
- BUSINESS_ASSET (6 fields) - Business interests
- PROPERTY_DETAIL (19 fields) - Property specifics
- CREDIT_HISTORY (25 fields) - Credit history

**Asset Categories:**
- Property (residential, investment, commercial)
- Business Assets
- Savings and Cash
- Collectibles and Valuables
- Vehicles

**Sample Endpoints:**
```
POST   /api/v1/factfinds/{factfindId}/assets
GET    /api/v1/factfinds/{factfindId}/assets
GET    /api/v1/factfinds/{factfindId}/assets/{assetId}
POST   /api/v1/factfinds/{factfindId}/liabilities
GET    /api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history
```

---

### 7. FactFind Risk Profile API (10+ endpoints)

**Purpose:** Risk assessment and suitability within fact find

**Key Entities:**
- RISK_PROFILE (40+ fields) - ATR and capacity for loss

**Sample Endpoints:**
```
POST   /api/v1/factfinds/{factfindId}/risk-profile
GET    /api/v1/factfinds/{factfindId}/risk-profile
PUT    /api/v1/factfinds/{factfindId}/risk-profile
GET    /api/v1/factfinds/{factfindId}/risk-profile/questionnaire
GET    /api/v1/factfinds/{factfindId}/risk-profile/history
```

**Highlights:**
- Attitude to Risk (ATR) questionnaire
- Capacity for Loss assessment
- Investment knowledge and experience
- Appropriateness assessment (MiFID II)
- Risk rating assignment (1-10 scale)

**Risk Ratings:**
- Very Cautious (1-2)
- Cautious (3-4)
- Balanced (5-6)
- Adventurous (7-8)
- Very Adventurous (9-10)

**Why Nested:** Risk profile is assessed within the context of a specific fact find session.

---

### 8. FactFind Estate Planning API (10+ endpoints)

**Purpose:** Estate planning and IHT management within fact find

**Key Entities:**
- GIFT (20+ fields) - Gift recording
- GIFT_TRUST (15+ fields) - Trust management

**Sample Endpoints:**
```
POST   /api/v1/factfinds/{factfindId}/gifts
GET    /api/v1/factfinds/{factfindId}/gifts
GET    /api/v1/factfinds/{factfindId}/gifts/{giftId}
POST   /api/v1/factfinds/{factfindId}/gift-trusts
GET    /api/v1/factfinds/{factfindId}/gift-trusts/{trustId}
```

**Highlights:**
- Potentially Exempt Transfer (PET) tracking
- 7-year IHT rule monitoring
- Gift type classification
- Trust beneficiary management

---

### 9. Reference Data API (20+ endpoints)

**Purpose:** Centralized lookup and configuration data (System-Wide, NOT owned by FactFind)

**Sample Endpoints:**
```
GET    /api/v1/reference/genders
GET    /api/v1/reference/countries
GET    /api/v1/reference/providers
GET    /api/v1/reference/advisers
GET    /api/v1/reference/product-types
GET    /api/v1/reference/counties
GET    /api/v1/reference/arrangement-types
```

**Highlights:**
- 100+ enumeration types
- Provider directory
- Adviser directory
- Product type catalog
- Country/county lookups (ISO codes)

**Why NOT Nested:** Reference data is shared across all fact finds and has its own lifecycle. Changes to reference data do not affect existing fact finds.

---

## Design Principles

### 1. Single Root Aggregate Pattern (NEW)

**FactFind is the ONLY aggregate root for all business data:**

**Benefits:**
1. **Transactional Consistency** - All changes within a fact find are atomic
2. **Business Rule Enforcement** - Fact find status controls operations
3. **Clear Ownership** - Every entity belongs to exactly one fact find
4. **Simplified Authorization** - Permissions scoped at fact find level
5. **Better API Ergonomics** - Clear, predictable URL structure
6. **Data Integrity** - Cascading deletes prevent orphaned data
7. **Performance Optimization** - Can cache entire aggregate
8. **Audit and Compliance** - Complete fact find history preserved

**Transactional Boundaries:**
- Within aggregate (atomic): All operations on same fact find
- Cross-aggregate (eventual): Reference data lookups

**Lifecycle:**
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
```
DELETE /api/v1/factfinds/456   # Deletes ALL:
                                # - Clients
                                # - Income/Expenditure
                                # - Arrangements
                                # - Goals
                                # - Assets/Liabilities
                                # - Risk Profile
                                # - Estate Planning
```

### 2. RESTful Architecture
- **Resource-Oriented:** Clear URI structure with nouns, not verbs
- **HTTP Methods:** Proper use of GET, POST, PUT, PATCH, DELETE
- **Status Codes:** Correct HTTP status codes (200, 201, 400, 404, etc.)
- **Stateless:** No server-side session state
- **Cacheable:** ETags and Cache-Control headers

### 3. Single Contract Principle
- One unified contract per entity for create, update, and response operations
- Field annotations: required-on-create, optional, read-only, write-once, updatable
- Reduces duplication and maintenance
- Type safety across all operations

### 4. Value and Reference Type Semantics
- **Value Types:** No identity, embedded, immutable (MoneyValue, AddressValue, etc.)
- **Reference Types:** Have identity, independently accessible within aggregate
- Clear distinction enforces proper domain modeling

### 5. Naming Conventions
- **URIs:** Lowercase, plural, hyphenated (`/api/v1/factfinds/{factfindId}/clients`)
- **Properties:** camelCase (`firstName`, `grossAnnualIncome`)
- **DateTime:** Suffix `At` (`createdAt`, `updatedAt`)
- **Date:** Suffix `On` (`startedOn`, `completedOn`)
- **Boolean:** Prefix `is`, `has`, `can` (`isActive`, `hasWill`)

### 6. Error Handling (RFC 7807)
```json
{
  "type": "https://api.factfind.com/problems/validation-error",
  "title": "Validation Failed",
  "status": 400,
  "detail": "One or more validation errors occurred",
  "instance": "/api/v1/factfinds/456/clients",
  "traceId": "00-4bf92f3577b34da6a3ce929d0e0e4736-00",
  "errors": [
    {
      "field": "dateOfBirth",
      "code": "REQUIRED",
      "message": "Date of birth is required",
      "rejectedValue": null
    }
  ]
}
```

---

## Common Patterns

### Pagination (Cursor-Based)
```http
GET /api/v1/factfinds/{factfindId}/clients?limit=20&cursor=eyJpZCI6MTAwfQ==

Response:
{
  "data": [...],
  "pagination": {
    "limit": 20,
    "hasMore": true,
    "nextCursor": "eyJpZCI6MTIwfQ=="
  },
  "_links": {
    "next": { "href": "/api/v1/factfinds/{factfindId}/clients?limit=20&cursor=eyJpZCI6MTIwfQ==" }
  }
}
```

### Filtering & Sorting
```http
GET /api/v1/factfinds/{factfindId}/arrangements?productType=Pension&status=Active&sortBy=startDate&sortOrder=desc
```

### Field Selection (Sparse Fieldsets)
```http
GET /api/v1/factfinds/{factfindId}/clients/123?fields=id,firstName,lastName,dateOfBirth
```

### Resource Expansion
```http
GET /api/v1/factfinds/456?expand=clients,arrangements
```

### Optimistic Concurrency (ETags)
```http
GET /api/v1/factfinds/{factfindId}/clients/123
Response: ETag: "abc123"

PUT /api/v1/factfinds/{factfindId}/clients/123
If-Match: "abc123"
```

### HATEOAS (Hypermedia Controls)
```json
{
  "id": "factfind-456",
  "sessionDate": "2026-02-17",
  "_links": {
    "self": { "href": "/api/v1/factfinds/456" },
    "complete": { "href": "/api/v1/factfinds/456/complete", "method": "POST" },
    "clients": { "href": "/api/v1/factfinds/456/clients" },
    "arrangements": { "href": "/api/v1/factfinds/456/arrangements" },
    "goals": { "href": "/api/v1/factfinds/456/goals" },
    "summary": { "href": "/api/v1/factfinds/456/summary" },
    "aggregate": { "href": "/api/v1/factfinds/456/complete" }
  }
}
```

---

## Security & Authorization

### Authentication
- **OAuth 2.0** with JWT tokens
- **Token Expiry:** 1 hour (access), 30 days (refresh)
- **TLS 1.2+** required

### Authorization Scopes
- `factfind:read` / `factfind:write`
- `client:read` / `client:write`
- `client:pii:read` (sensitive PII access)
- `arrangements:read` / `arrangements:write`
- `goals:read` / `goals:write`
- `risk:read` / `risk:write`
- `admin:*` (administrative access)

### Multi-Tenancy
- Tenant ID in JWT claims
- Automatic tenant filtering
- Cross-tenant access prohibited
- Fact finds isolated by tenant

### PII Obfuscation
Default response (without `client:pii:read`):
```json
{
  "nationalInsuranceNumber": "AB****56C",
  "dateOfBirth": "****-**-15"
}
```

Full response (with `client:pii:read`):
```json
{
  "nationalInsuranceNumber": "AB123456C",
  "dateOfBirth": "1980-05-15"
}
```

---

## Data Types & Formats

### Money
```json
{
  "amount": 75000.00,
  "currency": "GBP"
}
```

### Date/DateTime (ISO 8601)
```json
{
  "dateOfBirth": "1980-05-15",
  "createdAt": "2026-02-17T14:30:00Z"
}
```

### Address
```json
{
  "line1": "123 High Street",
  "city": "London",
  "postcode": "SW1A 1AA",
  "county": { "code": "GB-LND", "name": "London" },
  "country": { "code": "GB", "name": "United Kingdom" }
}
```

### Percentage
- Range: 0.00 to 100.00
- Example: `4.75`, `50.0`

---

## Implementation Guidance

### Performance
- **Query Optimization:** Index foreign keys and filtered fields
- **Caching:** Redis for reference data (24h TTL), fact find data (15min TTL)
- **Pagination:** Cursor-based for large datasets (>10k records)
- **Lazy Loading:** Default behavior, use `expand` for eager loading
- **Aggregate Caching:** Cache entire fact find aggregate for performance

### Rate Limiting
- **Per User:** 1,000 requests/hour, 100 requests/minute
- **Per Tenant:** 10,000 requests/hour, 1,000 requests/minute
- **Headers:** `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`

### Versioning
- **URL-Based:** `/api/v1/`, `/api/v2/` (future)
- **Support Policy:** Current (full), Previous (maintenance 12mo), Deprecated (security 6mo)
- **Breaking Changes:** Require version bump
- **Non-Breaking:** Add endpoints, optional fields, response fields

### Audit Logging
All write operations logged:
- User ID, Tenant ID, Timestamp
- Operation type, Resource type, Resource ID
- FactFind ID (for all nested entities)
- Changed fields (before/after)
- IP address, Request ID

---

## Success Criteria

### Functional Requirements
✅ Complete coverage of 39 entities from Greenfield ERD
✅ All 1,786 business fields mapped to API contracts
✅ 8 bounded contexts with clear boundaries
✅ 100+ fully specified endpoints with examples
✅ Request/response DTOs with validation rules
✅ **Single root aggregate pattern implemented (FactFind)**
✅ All entities nested under fact find context

### Non-Functional Requirements
✅ RESTful architecture principles applied
✅ Industry-standard terminology (FCA, MiFID II)
✅ Regulatory compliance (GDPR, Consumer Duty, AML)
✅ OAuth 2.0 authentication and authorization
✅ Multi-tenancy support
✅ PII protection and obfuscation
✅ Optimistic concurrency control (ETags)
✅ HATEOAS Level 3 hypermedia controls
✅ RFC 7807 error handling
✅ Comprehensive validation rules
✅ Audit logging requirements
✅ Performance optimization strategies
✅ Rate limiting policies
✅ **Strict DDD aggregate root pattern**
✅ **Transactional consistency guarantees**
✅ **Clear ownership and lifecycle management**

### Documentation Quality
✅ Implementation-ready specifications
✅ Complete request/response examples
✅ Business rules documented
✅ Validation rules specified
✅ Error scenarios covered
✅ Security considerations detailed
✅ **Aggregate root pattern explained**
✅ **Transactional boundaries defined**

---

## Key Achievements

### Version 2.0 - Single Root Aggregate Refactoring

**Major Architectural Change:**
- Refactored from multiple independent root aggregates to single root aggregate pattern
- FactFind is now the ONLY top-level business resource
- All other entities (clients, arrangements, goals, etc.) nested under FactFind
- Reference data remains independent (system-wide lookups)

**Benefits:**
- ✅ Stronger transactional consistency
- ✅ Clearer ownership and context
- ✅ Simplified authorization model
- ✅ Better API ergonomics
- ✅ Improved data integrity
- ✅ Enhanced auditability

**Changes:**
- Updated 100+ endpoint paths
- Restructured API sections
- Added aggregate root pattern documentation
- Added `/complete` endpoint for full aggregate retrieval
- Maintained backward compatibility where possible

---

## Total Specification Size

- Main document: 7200+ lines, 50+ pages
- Endpoints: 100+ operations (all nested under FactFind)
- DTOs: 50+ data structures
- Examples: 100+ JSON samples
- Validation rules: 500+ rules documented
- **New:** Aggregate root pattern documentation
- **New:** Complete aggregate retrieval endpoint

---

## Summary

This comprehensive API design provides a production-ready blueprint for implementing a modern wealth management platform following **strict Domain-Driven Design principles** with **FactFind as the single aggregate root**. The design follows industry best practices, regulatory requirements, and proven architectural patterns to deliver a scalable, secure, and maintainable API system.

**Key Differentiators:**
- ✅ 100% coverage of Greenfield ERD (39 entities, 1,786 fields)
- ✅ **Single root aggregate pattern (FactFind-centric)**
- ✅ 8 bounded contexts with clear separation of concerns
- ✅ 100+ endpoints fully specified and documented (all nested appropriately)
- ✅ Industry-standard terminology and compliance alignment
- ✅ Production-ready specifications for immediate implementation
- ✅ Comprehensive security, performance, and operational guidance
- ✅ **Strong transactional guarantees**
- ✅ **Clear ownership and lifecycle management**

This API design is ready for architecture review, stakeholder approval, and implementation by development teams.

---

**Document:** C:\work\FactFind-Entities\steering\Target-Model\FactFind-API-Design.md
**Summary:** C:\work\FactFind-Entities\steering\Target-Model\FactFind-API-Design-Summary.md
**Created:** 2026-02-16
**Refactored:** 2026-02-17
**Author:** Principal API Designer
**Version:** 2.0 - Single Root Aggregate Pattern
