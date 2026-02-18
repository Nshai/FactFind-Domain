
<!-- FactFind API Design v2.0 - Generated: 2026-02-17T14:59:30.880008 -->
# FactFind System API Design Specification
## Comprehensive RESTful API for Wealth Management Platform

**Document Version:** 2.0
**Date:** 2026-02-18
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

**PRIORITY 3A: Circumstances & Credit Assessment**
- **Section 6.5:** Credit History API - Credit scores, payment history, adverse credit tracking, mortgage suitability

**PRIORITY 4: Client Profile Enhancements**
- **Section 5.5:** Identity Verification API - KYC workflow, AML checks, document verification (REMOVED in v2.1 - now embedded)
- **Section 5.6:** Data Protection & Consent API - GDPR compliance, consent management (REMOVED in v2.1 - now embedded)
- **Section 5.7:** Marketing Preferences API - Channel preferences, opt-in/opt-out management (REMOVED in v2.1 - now embedded)

**PRIORITY 5: Financial Position Tracking**
- **Section 4.4:** Current Position Summary API - Net worth, asset allocation, financial health

**New Entity Contracts (Section 12)**
- Investment Contract (12.8)
- Property Contract (12.9)
- Equity Contract (12.10)

**Coverage Improvements:**
- Risk Assessment domain coverage increased from 38% to 95%
- Savings & Investments now has dedicated API section
- Client Profile domain coverage increased from 64% to 90%
- Assets & Liabilities domain coverage increased from 67% to 95%
- Overall API coverage increased from 77% to 95%

### What's New in v2.1 (This Release)

**MAJOR ARCHITECTURAL CHANGES:**

1. **FactFind as Aggregate Root** - All API operations now scoped to a fact-find instance
   - All endpoints now follow pattern: `/api/v1/factfinds/{factfindId}/{resource}`
   - Clear hierarchical structure with explicit parent-child relationships
   - Better transactional consistency and data isolation

2. **Context-Based Organization** - Resources grouped by business context
   - Client Onboarding & KYC: `/api/v1/factfinds/{factfindId}/clients`
   - Circumstances: `/api/v1/factfinds/{factfindId}/income`, `/employment`, `/expenditure`
   - Assets & Liabilities: `/api/v1/factfinds/{factfindId}/assets`
   - Arrangements: `/api/v1/factfinds/{factfindId}/arrangements/{type}`
   - Goals: `/api/v1/factfinds/{factfindId}/objectives`

3. **Enhanced API Architecture (Section 1.5)** - New comprehensive section covering:
   - Aggregate root pattern and benefits
   - Hierarchical structure and URL design
   - Context-based organization
   - Transactional boundaries
   - Entity lifecycle management

4. **Breaking Changes** - All endpoints restructured (see Migration Guide in Appendix)
   - Old: `/api/v1/factfinds/{factfindId}/clients/{clientId}` → New: `/api/v1/factfinds/{factfindId}/clients/{clientId}`
   - Old: `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}` → New: `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}`
   - All HATEOAS links updated to reflect new structure

**BENEFITS:**
- Clearer data ownership and boundaries
- Better multi-tenancy and security
- Improved caching and performance
- More discoverable API structure
- Enforced transactional consistency

**MIGRATION REQUIRED:**
- All API consumers must update endpoint URLs
- See Migration Guide for detailed mapping of old → new endpoints
- Backward compatibility NOT maintained (major version bump required)

## Table of Contents

1. [API Design Principles](#1-api-design-principles)
   - [1.1 RESTful Architecture](#11-restful-architecture)
   - [1.2 Naming Conventions](#12-naming-conventions)
   - [1.3 HTTP Methods & Status Codes](#13-http-methods--status-codes)
   - [1.4 Error Response Format](#14-error-response-format-rfc-7807)
   - [1.5 API Architecture & Aggregate Root Pattern](#15-api-architecture--aggregate-root-pattern) **NEW v2.1**
   - [1.6 Versioning Strategy](#16-versioning-strategy)
   - [1.7 Single Contract Principle](#17-single-contract-principle)
   - [1.8 Value and Reference Type Semantics](#18-value-and-reference-type-semantics)
   - [1.9 Aggregate Root Pattern](#19-aggregate-root-pattern)
2. [Authentication & Authorization](#2-authentication--authorization)
   - [2.1 OAuth 2.0 with JWT](#21-oauth-20-with-jwt)
   - [2.2 Authorization Scopes](#22-authorization-scopes)
   - [2.3 Multi-Tenancy](#23-multi-tenancy)
   - [2.4 Sensitive Data Handling](#24-sensitive-data-handling)
   - [2.5 Audit Logging](#25-audit-logging)
3. [Common Patterns](#3-common-patterns)
   - [3.1 Pagination](#31-pagination)
   - [3.2 Filtering & Sorting](#32-filtering--sorting)
   - [3.3 Field Selection](#33-field-selection-sparse-fieldsets)
   - [3.4 Resource Expansion](#34-resource-expansion)
   - [3.5 Optimistic Concurrency Control](#35-optimistic-concurrency-control)
   - [3.6 Batch Operations](#36-batch-operations)
   - [3.7 HATEOAS](#37-hateoas-hypermedia-controls)
   - [3.8 Data Types](#38-data-types)
4. [FactFind API (Root Aggregate)](#4-factfind-api-root-aggregate)
   - [4.1 Overview](#41-overview)
   - [4.2 Operations Summary](#42-operations-summary)
   - [4.3 Key Endpoints](#43-key-endpoints)
   - [4.4 Current Position Summary API](#44-current-position-summary-api) **NEW v2.0**
5. [Client Management API](#5-client-management-api)
   - [5.1 Overview](#51-overview)
   - [5.2 Operations Summary](#52-operations-summary)
   - [5.3 Key Endpoints](#53-key-endpoints)
   - [5.4 Estate Planning](#54-estate-planning) **NEW v3.0**
     - [5.4.1 Operations Summary](#541-operations-summary)
     - [5.4.2 Get Estate Planning Overview](#542-get-estate-planning-overview)
     - [5.4.3 Update Estate Planning Details](#543-update-estate-planning-details)
     - [5.4.4 Record Gift](#544-record-gift)
     - [5.4.5 List Gifts](#545-list-gifts)
     - [5.4.6 Create Gift Trust](#546-create-gift-trust)
   - [5.5 Dependants](#55-dependants) **NEW v3.0**
     - [5.5.1 Operations Summary](#551-operations-summary)
     - [5.5.2 List Dependants](#552-list-dependants)
     - [5.5.3 Create Dependant](#553-create-dependant)
     - [5.5.4 Get Dependant Details](#554-get-dependant-details)
     - [5.5.5 Update Dependant](#555-update-dependant)
     - [5.5.6 Delete Dependant](#556-delete-dependant)
   - [5.6 Notes](#56-notes) **NEW v3.0**
     - [5.6.1 Operations Summary](#561-operations-summary)
     - [5.6.2 List Notes](#562-list-notes)
     - [5.6.3 Create Note](#563-create-note)
     - [5.6.4 Update Note](#564-update-note)
     - [5.6.5 Delete Note](#565-delete-note)
   - [5.7 Custom Questions (Supplementary Questions)](#57-custom-questions-supplementary-questions) **NEW v3.0**
     - [5.7.1 Operations Summary](#571-operations-summary)
     - [5.7.2 List Custom Questions](#572-list-custom-questions)
     - [5.7.3 Create Custom Question](#573-create-custom-question)
     - [5.7.4 Get Custom Question Details](#574-get-custom-question-details)
     - [5.7.5 Update Custom Question](#575-update-custom-question)
     - [5.7.6 Delete Custom Question](#576-delete-custom-question)
     - [5.7.7 Submit Question Answers](#577-submit-question-answers)
     - [5.7.8 Get Question Answers](#578-get-question-answers)
6. [Income & Expenditure API (Circumstances Context)](#6-income--expenditure-api-circumstances-context)
   - [6.1 Overview](#61-overview)
   - [6.2 Operations Summary](#62-operations-summary)
   - [6.3 Key Endpoints](#63-key-endpoints)
     - [6.3.1 List Employment Records](#631-list-employment-records)
     - [6.3.2 Create Employment Record](#632-create-employment-record)
     - [6.3.3 List Income Sources](#633-list-income-sources)
     - [6.3.4 Create Income Source](#634-create-income-source)
     - [6.3.5 Create Income Change](#635-create-income-change)
     - [6.3.6 List Expenditure Items](#636-list-expenditure-items)
     - [6.3.7 Create Expenditure Item](#637-create-expenditure-item)
     - [6.3.8 Create Expenditure Change](#638-create-expenditure-change)
   - [6.4 Affordability](#64-affordability) **MOVED from 5.6 v3.0**
     - [6.4.1 Operations Summary](#641-operations-summary)
     - [6.4.2 Calculate Affordability](#642-calculate-affordability)
     - [6.4.3 List Affordability Calculations](#643-list-affordability-calculations)
     - [6.4.4 Update Affordability Calculation](#644-update-affordability-calculation)
     - [6.4.5 Delete Affordability Calculation](#645-delete-affordability-calculation)
   - [6.5 Credit History](#65-credit-history) **NEW v3.0**
     - [6.5.1 Operations Summary](#651-operations-summary)
     - [6.5.2 List Credit History](#652-list-credit-history)
     - [6.5.3 Create Credit History Record](#653-create-credit-history-record)
     - [6.5.4 Update Credit History Record](#654-update-credit-history-record)
     - [6.5.5 Delete Credit History Record](#655-delete-credit-history-record)
7. [Employment API (Part of Circumstances Context)](#7-employment-api-part-of-circumstances-context)
   - [7.1 Overview](#71-overview)
   - [7.2 Operations Summary](#72-operations-summary)
   - [7.3 Key Endpoints](#73-key-endpoints)
8. [Goals & Objectives API (Goals Context)](#8-goals--objectives-api-goals-context)
   - [8.1 Overview](#81-overview)
   - [8.2 Operations Summary](#82-operations-summary)
   - [8.3 Key Endpoints](#83-key-endpoints)
9. [Assets & Liabilities API](#9-assets--liabilities-api)
   - [9.1 Overview](#91-overview)
   - [9.2 Operations Summary](#92-operations-summary)
   - [9.3 Key Endpoints](#93-key-endpoints)
9A. [Arrangements API (Type-Based Routing)](#9a-arrangements-api-type-based-routing) **NEW v2.1**
   - [9A.1 Overview](#9a1-overview)
   - [9A.2 Arrangement Types and Sub-Types](#9a2-arrangement-types-and-sub-types)
   - [9A.3 Common Arrangement Operations](#9a3-common-arrangement-operations)
   - [9A.4 Arrangement Sub-Resources](#9a4-arrangement-sub-resources)
   - [9A.5 Client Pension Summary](#9a5-client-pension-summary)
9B. [Savings & Investments API](#9b-savings--investments-api) **NEW v2.0**
   - [9B.1 Overview](#9b1-overview)
   - [9B.2 Operations Summary](#9b2-operations-summary)
   - [9B.3 Key Endpoints](#9b3-key-endpoints)
10. [Arrangements API (Type-Based Routing)](#10-arrangements-api-type-based-routing) **NEW v3.0**
    - [10.1 Overview](#101-overview)
    - [10.2 Arrangement Types and Routing](#102-arrangement-types-and-routing)
    - [10.3 Investment Arrangements](#103-investment-arrangements)
      - [10.3.1 GIA (General Investment Account)](#1031-gia-general-investment-account)
      - [10.3.2 ISA (Individual Savings Account)](#1032-isa-individual-savings-account)
      - [10.3.3 Investment Bonds](#1033-investment-bonds)
      - [10.3.4 Investment Trusts](#1034-investment-trusts)
      - [10.3.5 Platform Accounts](#1035-platform-accounts)
      - [10.3.6 Offshore Bonds](#1036-offshore-bonds)
    - [10.4 Pension Arrangements](#104-pension-arrangements)
      - [10.4.1 Personal Pension](#1041-personal-pension)
      - [10.4.2 State Pension](#1042-state-pension)
      - [10.4.3 Workplace Pension](#1043-workplace-pension)
      - [10.4.4 SIPP (Self-Invested Personal Pension)](#1044-sipp-self-invested-personal-pension)
      - [10.4.5 Final Salary (Defined Benefit)](#1045-final-salary-defined-benefit)
      - [10.4.6 Pension Drawdown](#1046-pension-drawdown)
      - [10.4.7 Annuity](#1047-annuity)
    - [10.5 Mortgage Arrangements](#105-mortgage-arrangements)
    - [10.6 Protection Arrangements](#106-protection-arrangements)
      - [10.6.1 Personal Protection (Life, CI, IP)](#1061-personal-protection-life-ci-ip)
      - [10.6.2 General Insurance](#1062-general-insurance)
    - [10.7 Arrangement Sub-Resources](#107-arrangement-sub-resources)
      - [10.7.1 Contributions](#1071-contributions)
      - [10.7.2 Withdrawals](#1072-withdrawals)
      - [10.7.3 Beneficiaries](#1073-beneficiaries)
      - [10.7.4 Valuations](#1074-valuations)
11. [Risk Profile API](#11-risk-profile-api)
    - [11.1 Overview](#111-overview)
    - [11.2 Operations Summary](#112-operations-summary)
    - [11.3 Key Endpoints](#113-key-endpoints)
    - [11.4 ATR Templates Reference Data](#114-atr-templates-reference-data) **NEW v2.0**
    - [11.5 Risk Assessment History API](#115-risk-assessment-history-api) **NEW v2.0**
    - [11.6 Integration with FactFind Workflow](#116-integration-with-factfind-workflow)
12. [Reference Data API](#12-reference-data-api)
    - Reference data APIs remain unchanged (not scoped to factfinds)
13. [Entity Contracts](#13-entity-contracts)
    - [13.1 Client Contract](#131-client-contract)
    - [13.2 FactFind Contract](#132-factfind-contract)
    - [13.3 Address Contract](#133-address-contract)
    - [13.4 Income Contract](#134-income-contract)
    - [13.5 Arrangement Contract](#135-arrangement-contract)
    - [13.6 Goal Contract](#136-goal-contract)
    - [13.7 RiskProfile Contract](#137-riskprofile-contract)
    - [13.8 Investment Contract](#138-investment-contract)
    - [13.9 Property Contract](#139-property-contract)
    - [13.10 Equity Contract](#1310-equity-contract)
    - [13.11 IdentityVerification Contract](#1311-identityverification-contract)
    - [13.12 Consent Contract](#1312-consent-contract)
    - [13.13 Collection Response Wrapper](#1313-collection-response-wrapper)
    - [13.14 Contract Extension for Other Entities](#1314-contract-extension-for-other-entities)
    - [13.15 Standard Value Types](#1315-standard-value-types)
    - [13.16 Standard Reference Types](#1316-standard-reference-types)

---

**Appendices**

- [Appendix A: Migration Guide - v2.0 to v2.1](#appendix-a-migration-guide---v20-to-v21) **NEW v2.1**

---

## 1. API Design Principles

### 1.1 RESTful Architecture

The FactFind API strictly follows REST architectural principles:

**Resource-Oriented Design:**
- Resources are identified by URIs (e.g., `/api/v1/factfinds/{factfindId}/clients/123`)
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
/api/v1/factfinds/{factfindId}/clients                     (collection)
/api/v1/factfinds/{factfindId}/clients/{id}                (single resource)
/api/v1/factfinds/{factfindId}/clients/{id}/addresses      (sub-resource collection)
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
  "instance": "/api/v1/factfinds/{factfindId}/clients/123/income",
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


### 1.5 API Architecture & Aggregate Root Pattern

#### 1.5.1 Hierarchical Structure

The FactFind API follows a **hierarchical, context-based structure** where **FactFind is the aggregate root**. This means all business operations are scoped to a specific fact-find instance, and all API endpoints reflect this parent-child relationship in their URL structure.

**Design Principle:**
```
/api/v1/factfinds/{factfindId}/{context}/{resource}
```

**Examples:**
```
/api/v1/factfinds/12345/clients                                    # Client context
/api/v1/factfinds/12345/clients/67890/income                       # Circumstances context (per client)
/api/v1/factfinds/12345/arrangements/investments/isa               # Arrangements context (type-based)
/api/v1/factfinds/12345/arrangements/pensions/personal-pension     # Pension arrangements (type-based)
/api/v1/factfinds/12345/objectives/investment                      # Goals context (type-based)
/api/v1/factfinds/12345/attitude-to-risk                           # Risk profiling context
```

#### 1.5.2 FactFind as Aggregate Root

**What is an Aggregate Root?**

In Domain-Driven Design (DDD), an **aggregate** is a cluster of domain objects that can be treated as a single unit for data changes. The **aggregate root** is the entry point to the aggregate and the only entity that external objects should reference.

**Why FactFind is the Aggregate Root:**

1. **Transactional Boundary** - All client data, income, expenses, arrangements, and goals exist within the context of a single fact-find
2. **Consistency Guarantee** - Changes to related entities (client, income, arrangements) must be consistent within the fact-find
3. **Lifecycle Management** - Child entities (clients, arrangements, objectives) cannot exist without a parent fact-find
4. **Business Rule Enforcement** - Business rules (e.g., "total income must equal sum of all income sources") are enforced at the fact-find level
5. **Access Control** - Permissions are granted at the fact-find level and inherited by child entities

#### 1.5.3 Context-Based Organization

Resources are organized into **business contexts** that reflect the domain model:

| Context | Resources | Base Path |
|---------|-----------|-----------|
| **Client Onboarding & KYC** | Clients, Addresses, Contacts, Relationships, Dependants, Estate Planning, DPA Consent, Marketing Consent, Vulnerabilities, ID Verification, Professional Contacts | `/api/v1/factfinds/{id}/clients/{id}/*` |
| **Circumstances** | Employment, Income, Income Changes, Expenditure, Expenditure Changes | `/api/v1/factfinds/{id}/clients/{id}/*` |
| **Assets & Liabilities** | Assets, Business Assets, Property Details, Credit History, Valuations | `/api/v1/factfinds/{id}/assets` |
| **Arrangements** | Investment Arrangements (GIA, ISA, Bonds), Pension Arrangements (personal-pension, state-pension), Mortgage Arrangements, Protection Arrangements (personal-protection, general-insurance), Contributions, Withdrawals, Beneficiaries, Client Pension Summary | `/api/v1/factfinds/{id}/arrangements/{type}` |
| **Goals & Objectives** | Objectives (investment, pension, protection, mortgage, budget, estate-planning), Needs | `/api/v1/factfinds/{id}/objectives/{type}` |
| **Risk Profiling** | ATR (client ATR), Supplementary Questions | `/api/v1/factfinds/{id}/attitude-to-risk` |
| **Estate Planning** | Gifts, Trusts (nested under clients) | `/api/v1/factfinds/{id}/clients/{id}/estate-planning` |

#### 1.5.4 Benefits of This Approach

**1. Clear Data Ownership**
- Every resource has a clear parent (ultimately, the fact-find)
- No ambiguity about which fact-find a client or arrangement belongs to
- Simplifies multi-tenancy and data isolation

**2. Transactional Consistency**
- All operations within a fact-find can be made atomic
- Business rules can be enforced at aggregate boundaries
- Easier to implement eventual consistency where needed

**3. Better API Discoverability**
- URL structure reflects domain model
- Parent-child relationships are explicit
- HATEOAS links are more meaningful

**4. Simplified Security**
- Access control at fact-find level applies to all child resources
- No need to check permissions on every nested resource
- Easier to implement row-level security

**5. Improved Multi-Tenancy**
- Clear tenant boundaries (each fact-find belongs to one tenant)
- Data isolation guaranteed by URL structure
- Prevents cross-fact-find data leakage

**6. Better Caching**
- Cache invalidation is simpler (invalidate by fact-find ID)
- More predictable cache keys
- Better cache hit rates

#### 1.5.5 Transactional Boundaries

**Aggregate Boundary = Transaction Boundary**

All changes within a fact-find aggregate should be:
- **Atomic** - Either all changes succeed or all fail
- **Consistent** - Business rules are enforced across all entities
- **Isolated** - Concurrent changes don't interfere
- **Durable** - Changes are persisted reliably

**Example - Adding Income to a Client:**

```http
POST /api/v1/factfinds/12345/clients/67890/income
```

This operation:
1. Creates the income record for the specific client
2. Updates the client's total income
3. Recalculates the client's disposable income
4. Updates the fact-find's last modified timestamp
5. Emits a domain event (`IncomeAdded`)

All these changes happen atomically within the fact-find aggregate boundary.

#### 1.5.6 Entity Lifecycle

**All entities within a fact-find follow a consistent lifecycle:**

1. **Creation** - Entities are created within a fact-find context
2. **Retrieval** - Entities are retrieved via their parent fact-find
3. **Update** - Entities are updated within their fact-find context
4. **Deletion** - Entities are deleted, but the fact-find remains
5. **Archival** - When a fact-find is archived, all child entities are archived

**Example Lifecycle:**

```http
# 1. Create a fact-find
POST /api/v1/factfinds
Response: 201 Created, Location: /api/v1/factfinds/12345

# 2. Add a client to the fact-find
POST /api/v1/factfinds/12345/clients
Response: 201 Created, Location: /api/v1/factfinds/12345/clients/67890

# 3. Add an address to the client
POST /api/v1/factfinds/12345/clients/67890/addresses
Response: 201 Created, Location: /api/v1/factfinds/12345/clients/67890/addresses/11111

# 4. Update the address
PATCH /api/v1/factfinds/12345/clients/67890/addresses/11111
Response: 200 OK

# 5. Delete the address
DELETE /api/v1/factfinds/12345/clients/67890/addresses/11111
Response: 204 No Content

# 6. Archive the fact-find (archives all children)
POST /api/v1/factfinds/12345/archive
Response: 200 OK
```

#### 1.5.7 Special Considerations

**Cross-Aggregate References**

Some entities may need to reference entities in other fact-finds (e.g., comparing historical risk profiles). These should be:
- **Read-only** - No modifications across aggregates
- **Eventually consistent** - Denormalized data may be slightly stale
- **Explicitly marked** - Use `factfindRef` to indicate cross-aggregate references

**Reference Data Exception**

Reference data (lookup tables, templates, provider data) is **not** scoped to a fact-find:
- `/api/v1/reference/income-types` - NOT `/api/v1/factfinds/{id}/reference/income-types`
- `/api/v1/reference/providers` - NOT `/api/v1/factfinds/{id}/reference/providers`

Reference data is **shared across all fact-finds** and managed separately.


### 1.6 Versioning Strategy

**URL-Based Versioning:**
```
https://api.factfind.com/api/v1/factfinds/{factfindId}/clients
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

**PATCH /api/v1/factfinds/{factfindId}/clients/{id}** (Partial Update)
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
    "href": "/api/v1/factfinds/{factfindId}/clients/uuid-123",  // Required: URL to resource
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
| `ClientRef` | `name`<br>`clientNumber`<br>`type` | `{ "id": "uuid", "href": "/api/v1/factfinds/{factfindId}/clients/uuid", "name": "John Smith", "clientNumber": "C00001", "type": "Person" }` |
| `AdviserRef` | `name`<br>`code` | `{ "id": "uuid", "href": "/api/v1/advisers/uuid", "name": "Sarah Johnson", "code": "ADV001" }` |
| `ProviderRef` | `name`<br>`frnNumber` | `{ "id": "uuid", "href": "/api/v1/providers/uuid", "name": "Aviva", "frnNumber": "123456" }` |
| `ArrangementRef` | `policyNumber`<br>`productType`<br>`provider` | `{ "id": "uuid", "href": "/api/v1/factfinds/{factfindId}/arrangements/uuid", "policyNumber": "POL12345", "productType": "Pension", "provider": "Aviva" }` |
| `EmploymentRef` | `employerName`<br>`status` | `{ "id": "uuid", "href": "/api/v1/employments/uuid", "employerName": "Acme Corp", "status": "Current" }` |
| `GoalRef` | `goalName`<br>`priority` | `{ "id": "uuid", "href": "/api/v1/factfinds/{factfindId}/goals/uuid", "goalName": "Retirement Planning", "priority": "High" }` |
| `FactFindRef` | `factFindNumber`<br>`status` | `{ "id": "uuid", "href": "/api/v1/factfinds/uuid", "factFindNumber": "FF001234", "status": "InProgress" }` |

**Reference Type Usage Example:**

```json
{
  "id": "factfind-456",                   // FactFind entity has identity
  "factFindNumber": "FF001234",
  "clientRef": {                          // ClientRef - reference to Client entity
    "id": "client-123",
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "jointClientRef": {                     // Optional second client reference
    "id": "client-124",
    "href": "/api/v1/factfinds/{factfindId}/clients/client-124",
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
❌ GET  /api/v1/factfinds/{factfindId}/clients/{id}          (Not supported)
❌ POST /api/v1/factfinds/{factfindId}/arrangements          (Not supported)
❌ GET  /api/v1/factfinds/{factfindId}/arrangements/{id}     (Not supported)
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
      "href": "/api/v1/factfinds/{factfindId}/clients?limit=20&cursor=eyJpZCI6MTAwfQ=="
    },
    "next": {
      "href": "/api/v1/factfinds/{factfindId}/clients?limit=20&cursor=eyJpZCI6MTIwfQ=="
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
    "first": { "href": "/api/v1/factfinds/{factfindId}/clients?page=1&pageSize=20" },
    "prev": { "href": "/api/v1/factfinds/{factfindId}/clients?page=1&pageSize=20" },
    "self": { "href": "/api/v1/factfinds/{factfindId}/clients?page=2&pageSize=20" },
    "next": { "href": "/api/v1/factfinds/{factfindId}/clients?page=3&pageSize=20" },
    "last": { "href": "/api/v1/factfinds/{factfindId}/clients?page=10&pageSize=20" }
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-456",
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-456",
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
PUT /api/v1/factfinds/{factfindId}/clients/123
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
      "href": "/api/v1/factfinds/{factfindId}/clients/123/addresses"
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

See Section 12.10.9 for complete enumeration value type definitions.

---

## 4. FactFind API (Root Aggregate)


**ARCHITECTURAL NOTE (v2.1):**

FactFind is the **aggregate root** for all business operations. All other resources (clients, income, arrangements, etc.) are accessed through the FactFind context:

- `/api/v1/factfinds` - Root collection
- `/api/v1/factfinds/{factfindId}` - Specific fact-find
- `/api/v1/factfinds/{factfindId}/clients` - Clients within a fact-find
- `/api/v1/factfinds/{factfindId}/arrangements` - Arrangements within a fact-find
- `/api/v1/factfinds/{factfindId}/objectives` - Objectives within a fact-find

All subsequent API sections (5-11) document resources that are **nested under** the FactFind aggregate root.

---
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

**Contract:** Uses the unified `Client` contract (see Section 12.1). The same contract structure is used for request and response. Read-only fields (`id`, `createdAt`, `updatedAt`, computed fields) are ignored in the request and populated by the server in the response.

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
      "href": "/api/v1/factfinds/{factfindId}/clients/123/addresses"
    },
    "contacts": {
      "href": "/api/v1/factfinds/{factfindId}/clients/123/contacts"
    },
    "factfinds": {
      "href": "/api/v1/factfinds?clientId=123"
    },
    "arrangements": {
      "href": "/api/v1/factfinds/{factfindId}/arrangements?clientId=123"
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

**Contract:** Returns the complete unified `Client` contract (see Section 12.1) with all fields populated.

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
    "addresses": { "href": "/api/v1/factfinds/{factfindId}/clients/123/addresses" },
    "contacts": { "href": "/api/v1/factfinds/{factfindId}/clients/123/contacts" },
    "relationships": { "href": "/api/v1/factfinds/{factfindId}/clients/123/relationships" },
    "dependants": { "href": "/api/v1/factfinds/{factfindId}/clients/123/dependants" },
    "factfinds": { "href": "/api/v1/factfinds?clientId=123" },
    "arrangements": { "href": "/api/v1/factfinds/{factfindId}/arrangements?clientId=123" },
    "goals": { "href": "/api/v1/factfinds/{factfindId}/objectives?clientId=123" }
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

**Contract:** Returns collection wrapper (see Section 12.8) containing an array of `Client` contracts. Use `fields` query parameter for sparse fieldsets.

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
      "href": "/api/v1/factfinds/{factfindId}/clients?limit=20"
    },
    "next": {
      "href": "/api/v1/factfinds/{factfindId}/clients?limit=20&cursor=eyJpZCI6MTI0fQ=="
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
Location: /api/v1/factfinds/{factfindId}/clients/client-123/addresses/address-456

{
  "id": "address-456",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "self": { "href": "/api/v1/factfinds/{factfindId}/clients/client-123/addresses/address-456" },
    "client": { "href": "/api/v1/factfinds/{factfindId}/clients/client-123" }
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "self": { "href": "/api/v1/factfinds/{factfindId}/clients/123/vulnerability" },
    "client": { "href": "/api/v1/factfinds/{factfindId}/clients/123" },
    "history": { "href": "/api/v1/factfinds/{factfindId}/clients/123/vulnerability/history" }
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


## 5. Client Management API

### 5.1 Overview


**Base Path:** `/api/v1/factfinds/{factfindId}/clients`

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

**Contract:** Uses the unified `FactFind` contract (see Section 12.2). Request includes required-on-create fields; response includes complete contract with server-generated fields.

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

**Contract:** Uses the unified `Income` contract (see Section 12.4). The same contract is used for request and response.

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

### 5.4 Estate Planning

**Base Path:** `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning`

**Purpose:** Manage client-specific estate planning information including wills, powers of attorney, trusts, and gift planning for inheritance tax (IHT) mitigation.

**Scope:**
- Estate planning overview (wills, lasting power of attorney, inheritance wishes)
- Gift recording and tracking (cash gifts, property gifts, business asset gifts)
- Potentially Exempt Transfer (PET) tracking and 7-year rule monitoring
- Gift trust management and beneficiary tracking
- Inheritance Tax (IHT) calculations and liability assessment
- Estate value monitoring and IHT planning strategies

**Key Features:**
- **Client-Level Resource** - Estate planning is specific to each individual client
- **Gift History** - Complete audit trail of all gifts made by the client
- **PET Tracking** - Automatic 7-year countdown for potentially exempt transfers
- **IHT Calculations** - Real-time IHT exposure based on estate value and gifts
- **Trust Management** - Link gifts to trusts with beneficiary tracking

**Aggregate Root:** Client (estate planning nested under client)

**Regulatory Compliance:**
- FCA Handbook - Understanding client estate planning needs
- HMRC Inheritance Tax regulations
- Inheritance Tax Act 1984 - 7-year rule, exemptions, reliefs
- Data Protection Act 2018 - Sensitive estate planning data
- Money Laundering Regulations 2017 - Source of wealth for large gifts

#### 5.4.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| **Estate Planning Overview** | | | |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning` | Get estate planning overview | `estate:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning` | Update estate planning details | `estate:write` |
| **Gifts Management** | | | |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/gifts` | Record a new gift | `estate:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/gifts` | List all gifts by client | `estate:read` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/gifts/{giftId}` | Get gift details | `estate:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/gifts/{giftId}` | Update gift record | `estate:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/gifts/{giftId}` | Delete gift record | `estate:write` |
| **Trusts Management** | | | |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/trusts` | Create gift trust | `estate:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/trusts` | List client's trusts | `estate:read` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/trusts/{trustId}` | Get trust details | `estate:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/trusts/{trustId}` | Update trust | `estate:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/trusts/{trustId}` | Delete trust | `estate:write` |

**Total Endpoints:** 12

#### 5.4.2 Get Estate Planning Overview

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning`

**Description:** Retrieve comprehensive estate planning information for a client including wills, powers of attorney, total gifts made, and IHT exposure.

**Response:**

```json
{
  "clientRef": {
    "id": "client-123",
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/ff-456/clients/client-123"
  },
  "estatePlanning": {
    "hasWill": true,
    "willLastUpdated": "2023-06-15",
    "willLocation": "With solicitor - Smith & Partners LLP",
    "hasLastingPowerOfAttorney": true,
    "lpaTypes": ["Property and Financial Affairs", "Health and Welfare"],
    "lpaRegistered": true,
    "lpaRegistrationDate": "2023-07-01",
    "executors": [
      {
        "name": "Sarah Smith",
        "relationshipToClient": "Spouse",
        "contactRef": { "id": "client-124" }
      },
      {
        "name": "David Smith",
        "relationshipToClient": "Brother",
        "contactRef": { "id": "contact-789" }
      }
    ],
    "inheritanceWishes": "Estate split equally between children. Family home to spouse.",
    "concernsOrPriorities": "Minimize IHT burden, protect family home"
  },
  "giftsSummary": {
    "totalGifts": 8,
    "totalValueGifted": {
      "amount": 125000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "activePETs": 3,
    "giftsTaxFree": 5,
    "totalIHTExposure": {
      "amount": 42000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "trustsSummary": {
    "totalTrusts": 2,
    "totalValueInTrust": {
      "amount": 200000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "beneficiaryCount": 4
  },
  "ihtCalculation": {
    "estimatedEstateValue": {
      "amount": 850000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "ihtThreshold": {
      "amount": 325000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "residenceNilRateBand": {
      "amount": 175000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "totalAllowance": {
      "amount": 500000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "taxableEstate": {
      "amount": 350000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "estimatedIHT": {
      "amount": 140000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "effectiveRate": 16.47
  },
  "lastReviewed": "2026-01-15",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning" },
    "client": { "href": "/api/v1/factfinds/ff-456/clients/client-123" },
    "gifts": { "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning/gifts" },
    "trusts": { "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning/trusts" }
  }
}
```

#### 5.4.3 Update Estate Planning Details

**Endpoint:** `PATCH /api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning`

**Description:** Update estate planning information such as will status, powers of attorney, and inheritance wishes.

**Request Body:**

```json
{
  "hasWill": true,
  "willLastUpdated": "2026-02-15",
  "willLocation": "With solicitor - Smith & Partners LLP",
  "hasLastingPowerOfAttorney": true,
  "lpaTypes": ["Property and Financial Affairs", "Health and Welfare"],
  "lpaRegistered": true,
  "lpaRegistrationDate": "2026-02-10",
  "inheritanceWishes": "Estate to be split equally between three children after spouse passes. Family home to spouse with life interest.",
  "concernsOrPriorities": "Minimize IHT, protect family home, provide for grandchildren's education"
}
```

**Response:** 200 OK with updated estate planning overview.

#### 5.4.4 Record Gift

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/gifts`

**Description:** Record a gift made by the client for IHT planning and PET tracking.

**Request Body:**

```json
{
  "giftDate": "2026-01-15",
  "giftType": {
    "code": "CASH",
    "display": "Cash Gift"
  },
  "recipientName": "Emma Smith",
  "recipientRelationship": {
    "code": "CHILD",
    "display": "Child"
  },
  "recipientRef": {
    "id": "dependent-789"
  },
  "giftValue": {
    "amount": 15000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "giftPurpose": "University tuition assistance",
  "isPotentiallyExemptTransfer": true,
  "exemptionType": {
    "code": "NONE",
    "display": "No Exemption - Full PET"
  },
  "notes": "First of three annual payments for university costs"
}
```

**Response:**

```json
{
  "id": "gift-123",
  "clientRef": {
    "id": "client-123",
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/ff-456/clients/client-123"
  },
  "giftDate": "2026-01-15",
  "giftType": {
    "code": "CASH",
    "display": "Cash Gift"
  },
  "recipientName": "Emma Smith",
  "recipientRelationship": {
    "code": "CHILD",
    "display": "Child"
  },
  "recipientRef": {
    "id": "dependent-789",
    "href": "/api/v1/factfinds/ff-456/clients/client-123/dependents/dependent-789"
  },
  "giftValue": {
    "amount": 15000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "giftPurpose": "University tuition assistance",
  "isPotentiallyExemptTransfer": true,
  "exemptionType": {
    "code": "NONE",
    "display": "No Exemption - Full PET"
  },
  "petExpiryDate": "2033-01-15",
  "yearsRemaining": 6.92,
  "petStatus": {
    "code": "ACTIVE",
    "display": "Active PET"
  },
  "ihtLiability": {
    "amount": 6000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "notes": "First of three annual payments for university costs",
  "createdAt": "2026-02-18T10:30:00Z",
  "updatedAt": "2026-02-18T10:30:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning/gifts/gift-123" },
    "client": { "href": "/api/v1/factfinds/ff-456/clients/client-123" },
    "estate-planning": { "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning" }
  }
}
```

**Validation Rules:**
- `giftDate` - Required, cannot be in future
- `giftType` - Required, one of: Cash, Property, Business Asset, Investment, Other
- `giftValue` - Required, must be positive
- `recipientName` - Required

**Business Rules:**
- PET expiry date automatically calculated as gift date + 7 years
- IHT liability calculated based on current IHT rate (40%) and exemptions
- Years remaining updated automatically each day
- PET status changes to "Exempt" once 7 years elapsed
- Annual exemption (£3,000) applied automatically if available

#### 5.4.5 List Gifts

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/gifts`

**Description:** Retrieve all gifts made by the client, with optional filtering by status and date range.

**Query Parameters:**
- `petStatus` - Filter by PET status (active, exempt, expired)
- `fromDate` - Filter gifts from this date onwards
- `toDate` - Filter gifts up to this date
- `giftType` - Filter by gift type (cash, property, business_asset, etc.)
- `minValue` - Minimum gift value
- `includeExempt` - Include tax-exempt gifts (default: true)

**Response:**

```json
{
  "clientRef": {
    "id": "client-123",
    "fullName": "John Smith"
  },
  "gifts": [
    {
      "id": "gift-123",
      "giftDate": "2026-01-15",
      "giftType": { "code": "CASH", "display": "Cash Gift" },
      "recipientName": "Emma Smith",
      "recipientRelationship": { "code": "CHILD", "display": "Child" },
      "giftValue": {
        "amount": 15000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "isPotentiallyExemptTransfer": true,
      "petExpiryDate": "2033-01-15",
      "yearsRemaining": 6.92,
      "petStatus": { "code": "ACTIVE", "display": "Active PET" },
      "ihtLiability": {
        "amount": 6000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning/gifts/gift-123" }
      }
    },
    {
      "id": "gift-124",
      "giftDate": "2025-12-25",
      "giftType": { "code": "CASH", "display": "Cash Gift" },
      "recipientName": "Michael Smith",
      "recipientRelationship": { "code": "CHILD", "display": "Child" },
      "giftValue": {
        "amount": 10000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "isPotentiallyExemptTransfer": true,
      "petExpiryDate": "2032-12-25",
      "yearsRemaining": 6.86,
      "petStatus": { "code": "ACTIVE", "display": "Active PET" },
      "ihtLiability": {
        "amount": 4000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning/gifts/gift-124" }
      }
    },
    {
      "id": "gift-125",
      "giftDate": "2019-03-10",
      "giftType": { "code": "PROPERTY", "display": "Property Gift" },
      "recipientName": "Sarah Smith",
      "recipientRelationship": { "code": "SPOUSE", "display": "Spouse" },
      "giftValue": {
        "amount": 200000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "isPotentiallyExemptTransfer": false,
      "exemptionType": { "code": "SPOUSE", "display": "Spouse Exemption" },
      "petExpiryDate": null,
      "yearsRemaining": 0,
      "petStatus": { "code": "EXEMPT", "display": "Tax Exempt" },
      "ihtLiability": {
        "amount": 0.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning/gifts/gift-125" }
      }
    }
  ],
  "totalGifts": 3,
  "totalValueGifted": {
    "amount": 225000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "activePETs": 2,
  "totalIHTExposure": {
    "amount": 10000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning/gifts" },
    "estate-planning": { "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning" }
  }
}
```

#### 5.4.6 Create Gift Trust

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/estate-planning/trusts`

**Description:** Create a gift trust for estate planning and IHT mitigation.

**Request Body:**

```json
{
  "trustName": "Smith Family Education Trust",
  "trustType": {
    "code": "BARE_TRUST",
    "display": "Bare Trust"
  },
  "establishedDate": "2026-02-01",
  "trustValue": {
    "amount": 100000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "trustPurpose": "Provide for grandchildren's education expenses",
  "trustees": [
    {
      "name": "John Smith",
      "relationshipToClient": "Self",
      "contactRef": { "id": "client-123" }
    },
    {
      "name": "Sarah Smith",
      "relationshipToClient": "Spouse",
      "contactRef": { "id": "client-124" }
    }
  ],
  "beneficiaries": [
    {
      "name": "Oliver Smith",
      "relationshipToClient": "Grandchild",
      "dateOfBirth": "2015-08-22",
      "benefitShare": 50.0
    },
    {
      "name": "Sophie Smith",
      "relationshipToClient": "Grandchild",
      "dateOfBirth": "2018-03-15",
      "benefitShare": 50.0
    }
  ],
  "linkedGifts": [
    { "giftRef": { "id": "gift-126" } }
  ]
}
```

**Response:**

```json
{
  "id": "trust-456",
  "clientRef": {
    "id": "client-123",
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/ff-456/clients/client-123"
  },
  "trustName": "Smith Family Education Trust",
  "trustType": {
    "code": "BARE_TRUST",
    "display": "Bare Trust"
  },
  "establishedDate": "2026-02-01",
  "trustValue": {
    "amount": 100000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "trustPurpose": "Provide for grandchildren's education expenses",
  "trustees": [
    {
      "name": "John Smith",
      "relationshipToClient": "Self",
      "contactRef": { "id": "client-123", "href": "/api/v1/factfinds/ff-456/clients/client-123" }
    },
    {
      "name": "Sarah Smith",
      "relationshipToClient": "Spouse",
      "contactRef": { "id": "client-124", "href": "/api/v1/factfinds/ff-456/clients/client-124" }
    }
  ],
  "beneficiaries": [
    {
      "name": "Oliver Smith",
      "relationshipToClient": "Grandchild",
      "dateOfBirth": "2015-08-22",
      "age": 10,
      "benefitShare": 50.0
    },
    {
      "name": "Sophie Smith",
      "relationshipToClient": "Grandchild",
      "dateOfBirth": "2018-03-15",
      "age": 7,
      "benefitShare": 50.0
    }
  ],
  "linkedGifts": [
    {
      "giftRef": { "id": "gift-126", "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning/gifts/gift-126" },
      "giftDate": "2026-02-01",
      "giftValue": { "amount": 100000.00, "currency": { "code": "GBP" } }
    }
  ],
  "totalGiftsInTrust": {
    "amount": 100000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "ihtTreatment": "Immediately chargeable transfer - periodic charges apply",
  "nextPeriodicCharge": "2036-02-01",
  "createdAt": "2026-02-18T11:00:00Z",
  "updatedAt": "2026-02-18T11:00:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning/trusts/trust-456" },
    "client": { "href": "/api/v1/factfinds/ff-456/clients/client-123" },
    "estate-planning": { "href": "/api/v1/factfinds/ff-456/clients/client-123/estate-planning" }
  }
}
```

**Trust Types:**
- **Bare Trust** - Beneficiary has immediate absolute entitlement
- **Discretionary Trust** - Trustees have discretion over distributions
- **Interest in Possession Trust** - Beneficiary has right to income
- **Life Interest Trust** - Beneficiary has interest for life
- **Disabled Person's Trust** - Special tax treatment for disabled beneficiaries

**Validation Rules:**
- `trustName` - Required, max 200 characters
- `trustType` - Required
- `establishedDate` - Required, cannot be in future
- `trustValue` - Required, must be positive
- `beneficiaries` - At least one beneficiary required
- `benefitShare` - Must sum to 100% across all beneficiaries

**Business Rules:**
- Trust creation automatically creates linked gift if value > 0
- IHT treatment determined by trust type
- Periodic charges calculated for relevant property trusts (every 10 years)
- Trust value tracked separately from personal estate

---

### 5.5 Dependants

**Base Path:** `/api/v1/factfinds/{factfindId}/clients/{clientId}/dependants`

**Purpose:** Manage client's dependants including children, elderly parents, and other financially dependent individuals for protection planning and financial forecasting.

**Scope:**
- Dependant demographic information (name, date of birth, relationship)
- Living arrangements tracking (living with client or separate)
- Financial dependency status and duration
- Age-based dependency calculations
- Dependency end date projections
- Multiple client associations (e.g., child dependant of both joint clients)

**Key Features:**
- **Automatic Age Calculation** - Age calculated from date of birth and updated daily
- **Dependency Period Tracking** - Track when financial dependency ends (age-based or date-based)
- **Custom Age Thresholds** - Override standard dependency age (e.g., dependency until age 25 for university)
- **Multiple Parent Support** - Dependant can be associated with multiple clients (joint families)
- **Protection Planning** - Critical for calculating protection needs and life insurance requirements

**Aggregate Root:** Client (dependants nested under client)

**Regulatory Compliance:**
- FCA Handbook - Understanding dependant needs for protection advice
- COBS 9.2 - Assessing suitability for protection planning
- Consumer Duty - Ensuring adequate protection for dependants
- Data Protection Act 2018 - Sensitive data about minors

#### 5.5.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/dependants` | List all client's dependants | `clients:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/dependants` | Add new dependant | `clients:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/dependants/{dependantId}` | Get dependant details | `clients:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/dependants/{dependantId}` | Update dependant | `clients:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/dependants/{dependantId}` | Delete dependant | `clients:write` |

**Total Endpoints:** 5

#### 5.5.2 List Dependants

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/dependants`

**Description:** Retrieve all dependants associated with a client.

**Query Parameters:**
- `isFinanciallyDependant` - Filter by financial dependency status (true/false)
- `isLivingWith` - Filter by living arrangement (true/false)
- `relationshipType` - Filter by relationship (Son, Daughter, Elderly Parent, etc.)
- `maxAge` - Filter dependants under specified age
- `includeInactive` - Include dependants past financial dependency end date (default: false)

**Response:**

```json
{
  "clientRef": {
    "id": "client-123",
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/ff-456/clients/client-123"
  },
  "dependants": [
    {
      "id": "dep-001",
      "name": "James Smith",
      "dateOfBirth": "2015-06-20",
      "calculatedAge": 10,
      "relationshipType": {
        "code": "SON",
        "display": "Son"
      },
      "isLivingWith": true,
      "isFinanciallyDependant": true,
      "ageCustomUntil": 21,
      "financialDependencyEndsOn": "2036-06-20",
      "financialDependencyPeriod": "Until Age 21",
      "yearsOfDependencyRemaining": 11,
      "clients": [
        {
          "id": "client-123",
          "fullName": "John Smith",
          "href": "/api/v1/factfinds/ff-456/clients/client-123"
        },
        {
          "id": "client-124",
          "fullName": "Sarah Smith",
          "href": "/api/v1/factfinds/ff-456/clients/client-124"
        }
      ],
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/dependants/dep-001" }
      }
    },
    {
      "id": "dep-002",
      "name": "Emma Smith",
      "dateOfBirth": "2018-03-15",
      "calculatedAge": 7,
      "relationshipType": {
        "code": "DAUGHTER",
        "display": "Daughter"
      },
      "isLivingWith": true,
      "isFinanciallyDependant": true,
      "ageCustomUntil": 18,
      "financialDependencyEndsOn": "2036-03-15",
      "financialDependencyPeriod": "Until Age 18",
      "yearsOfDependencyRemaining": 10,
      "clients": [
        {
          "id": "client-123",
          "fullName": "John Smith",
          "href": "/api/v1/factfinds/ff-456/clients/client-123"
        },
        {
          "id": "client-124",
          "fullName": "Sarah Smith",
          "href": "/api/v1/factfinds/ff-456/clients/client-124"
        }
      ],
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/dependants/dep-002" }
      }
    }
  ],
  "totalCount": 2,
  "financiallyDependantCount": 2,
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/dependants" },
    "client": { "href": "/api/v1/factfinds/ff-456/clients/client-123" }
  }
}
```

#### 5.5.3 Create Dependant

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/dependants`

**Description:** Add a new dependant to a client's record.

**Request Body:**

```json
{
  "name": "James Smith",
  "dateOfBirth": "2015-06-20",
  "relationshipType": {
    "code": "SON",
    "display": "Son"
  },
  "isLivingWith": true,
  "isFinanciallyDependant": true,
  "ageCustom": null,
  "ageCustomUntil": 21,
  "notes": "Attending secondary school. Plans to attend university.",
  "clients": [
    {
      "id": "client-123"
    },
    {
      "id": "client-124"
    }
  ]
}
```

**Response:**

```json
{
  "id": "dep-001",
  "name": "James Smith",
  "dateOfBirth": "2015-06-20",
  "calculatedAge": 10,
  "relationshipType": {
    "code": "SON",
    "display": "Son"
  },
  "isLivingWith": true,
  "isFinanciallyDependant": true,
  "ageCustom": null,
  "ageCustomUntil": 21,
  "financialDependencyEndsOn": "2036-06-20",
  "financialDependencyPeriod": "Until Age 21",
  "yearsOfDependencyRemaining": 11,
  "notes": "Attending secondary school. Plans to attend university.",
  "clients": [
    {
      "id": "client-123",
      "fullName": "John Smith",
      "href": "/api/v1/factfinds/ff-456/clients/client-123"
    },
    {
      "id": "client-124",
      "fullName": "Sarah Smith",
      "href": "/api/v1/factfinds/ff-456/clients/client-124"
    }
  ],
  "createdAt": "2026-02-18T12:00:00Z",
  "updatedAt": "2026-02-18T12:00:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/dependants/dep-001" },
    "client": { "href": "/api/v1/factfinds/ff-456/clients/client-123" }
  }
}
```

**Validation Rules:**
- `name` - Required, max 200 characters
- `dateOfBirth` - Required, cannot be in future, must result in age < 100
- `relationshipType` - Required, must be valid code
- `ageCustomUntil` - Optional, must be >= current age and <= 30
- `clients` - At least one client required, all clients must exist and belong to same factfind

**Business Rules:**
- If `ageCustomUntil` not provided, defaults to 18
- If `ageCustom` provided, overrides calculated age (for adoption scenarios)
- `financialDependencyEndsOn` automatically calculated as dateOfBirth + ageCustomUntil years
- `calculatedAge` updated daily based on current date and dateOfBirth
- `yearsOfDependencyRemaining` = financialDependencyEndsOn - current date (in years)
- `financialDependencyPeriod` formatted as human-readable string

#### 5.5.4 Get Dependant Details

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/dependants/{dependantId}`

**Description:** Retrieve detailed information about a specific dependant.

**Response:**

```json
{
  "id": "dep-001",
  "name": "James Smith",
  "dateOfBirth": "2015-06-20",
  "calculatedAge": 10,
  "ageCustom": null,
  "ageCustomUntil": 21,
  "relationshipType": {
    "code": "SON",
    "display": "Son"
  },
  "isLivingWith": true,
  "isFinanciallyDependant": true,
  "financialDependencyEndsOn": "2036-06-20",
  "financialDependencyPeriod": "Until Age 21",
  "yearsOfDependencyRemaining": 11,
  "monthsOfDependencyRemaining": 131,
  "notes": "Attending secondary school. Plans to attend university.",
  "clients": [
    {
      "id": "client-123",
      "fullName": "John Smith",
      "relationshipToClient": "Father",
      "href": "/api/v1/factfinds/ff-456/clients/client-123"
    },
    {
      "id": "client-124",
      "fullName": "Sarah Smith",
      "relationshipToClient": "Mother",
      "href": "/api/v1/factfinds/ff-456/clients/client-124"
    }
  ],
  "protectionNeeds": {
    "estimatedAnnualCost": {
      "amount": 12000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "totalCapitalRequired": {
      "amount": 132000.00,
      "currency": { "code": "GBP", "symbol": "£" },
      "calculation": "11 years × £12,000"
    }
  },
  "createdAt": "2026-02-18T12:00:00Z",
  "updatedAt": "2026-02-18T12:00:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/clients/client-123/dependants/dep-001" },
    "client": { "href": "/api/v1/factfinds/ff-456/clients/client-123" },
    "update": { "href": "/api/v1/factfinds/ff-456/clients/client-123/dependants/dep-001", "method": "PATCH" },
    "delete": { "href": "/api/v1/factfinds/ff-456/clients/client-123/dependants/dep-001", "method": "DELETE" }
  }
}
```

**Additional Calculated Fields:**
- `monthsOfDependencyRemaining` - Months until dependency ends
- `protectionNeeds.estimatedAnnualCost` - Estimated yearly cost for dependant
- `protectionNeeds.totalCapitalRequired` - Total capital needed until independence

#### 5.5.5 Update Dependant

**Endpoint:** `PATCH /api/v1/factfinds/{factfindId}/clients/{clientId}/dependants/{dependantId}`

**Description:** Update dependant information. Commonly used to update living arrangements, financial dependency status, or custom age threshold.

**Request Body:**

```json
{
  "isLivingWith": false,
  "ageCustomUntil": 25,
  "notes": "Now attending university. Living in student accommodation. Extended dependency to age 25 to cover university and initial career years."
}
```

**Response:** 200 OK with updated dependant entity including recalculated fields:
- `financialDependencyEndsOn` recalculated to "2040-06-20" (age 25)
- `financialDependencyPeriod` updated to "Until Age 25"
- `yearsOfDependencyRemaining` recalculated to 15 years
- `protectionNeeds.totalCapitalRequired` recalculated based on new duration

**Partial Update Support:**
- Only provided fields are updated
- Calculated fields automatically updated when dependencies change
- Timestamps updated on any change

#### 5.5.6 Delete Dependant

**Endpoint:** `DELETE /api/v1/factfinds/{factfindId}/clients/{clientId}/dependants/{dependantId}`

**Description:** Remove a dependant record from the client.

**Response:** 204 No Content

**Business Rules:**
- Soft delete - record marked as deleted but retained for audit
- Cannot be restored via API (contact support for restoration)
- Removes dependant from protection needs calculations
- Does not affect historical protection recommendations

---

**Relationship Types:**

| Code | Display | Description |
|------|---------|-------------|
| CHILD | Child | Child of client (gender neutral) |
| SON | Son | Male child of client |
| DAUGHTER | Daughter | Female child of client |
| STEP_CHILD | StepChild | Stepchild of client |
| GRANDCHILD | Grandchild | Child of client's child |
| PARENT | Parent | Parent of client requiring support |
| GRANDPARENT | Grandparent | Grandparent of client requiring support |
| STEP_PARENT | StepParent | Stepparent of client requiring support |
| SPOUSE | Spouse | Married partner of client |
| CIVIL_PARTNER | CivilPartner | Civil partnership partner of client |
| PARTNER | Partner | Unmarried partner of client |
| OTHER | Other | Other dependent relationship |

---

**Age Calculation Rules:**

1. **Standard Calculation:**
   - `calculatedAge = floor((current date - dateOfBirth) / 365.25)`
   - Updated daily at midnight UTC

2. **Custom Age Override:**
   - `ageCustom` field allows manual age entry (for adoption scenarios)
   - If `ageCustom` is set, it overrides `calculatedAge`
   - Use case: Child adopted at age 5, birth date unknown

3. **Financial Dependency End Date:**
   - `financialDependencyEndsOn = dateOfBirth + ageCustomUntil years`
   - Default `ageCustomUntil = 18`
   - Common overrides: 21 (higher education), 25 (university + career start)

4. **Years Remaining:**
   - `yearsOfDependencyRemaining = floor((financialDependencyEndsOn - current date) / 365.25)`
   - Can be negative if dependency end date has passed
   - Used for protection needs calculations

---

**Protection Needs Calculation:**

Used to calculate life insurance and income protection requirements.

**Formula:**
```
Total Capital Required = Years of Dependency Remaining × Estimated Annual Cost

Where:
- Years of Dependency Remaining = financialDependencyEndsOn - current date
- Estimated Annual Cost = configurable per dependant (default £12,000 per child)
```

**Example:**
- Dependant: James Smith, age 10
- Dependency until: Age 21
- Years remaining: 11 years
- Estimated annual cost: £12,000
- **Total capital required: £132,000**

**Multiple Dependants:**
- Sum total capital required across all dependants
- Add 10-20% buffer for inflation and unexpected costs
- Consider education costs separately (university fees, living expenses)

---

**Use Cases:**

### Use Case 1: Add Child Dependant for Joint Clients

**Scenario:** Joint clients have a 10-year-old son attending secondary school

**API Flow:**
```
1. POST /clients/client-123/dependants
   Request: {
     name: "James Smith",
     dateOfBirth: "2015-06-20",
     relationshipType: "SON",
     isLivingWith: true,
     isFinanciallyDependant: true,
     ageCustomUntil: 21,
     clients: [client-123, client-124]  // Both parents
   }

2. Response includes:
   - calculatedAge: 10
   - financialDependencyEndsOn: "2036-06-20"
   - yearsOfDependencyRemaining: 11
   - protectionNeeds.totalCapitalRequired: £132,000

3. Use for protection planning:
   - Calculate life insurance requirement
   - Calculate income protection requirement
   - Factor into retirement planning (freed-up cash flow at age 21)
```

### Use Case 2: Update Dependency Age for University

**Scenario:** Child going to university, extend dependency from 18 to 25

**API Flow:**
```
1. PATCH /clients/client-123/dependants/dep-001
   Request: {
     ageCustomUntil: 25,
     notes: "Attending university. Extended to age 25 for university and career start."
   }

2. Automatic recalculation:
   - financialDependencyEndsOn: "2040-06-20" (was "2033-06-20")
   - yearsOfDependencyRemaining: 15 (was 8)
   - protectionNeeds.totalCapitalRequired: £180,000 (was £96,000)

3. Update protection recommendations:
   - Increase life insurance coverage by £84,000
   - Update income protection calculations
```

### Use Case 3: Calculate Total Protection Needs

**Scenario:** Calculate total life insurance required for all dependants

**API Flow:**
```
1. GET /clients/client-123/dependants

2. Response includes 3 dependants:
   - James (age 10, until 21): £132,000
   - Emma (age 7, until 18): £132,000
   - Oliver (age 4, until 18): £168,000

3. Calculate total:
   - Sum: £432,000
   - Add 15% buffer: £496,800
   - Add mortgage: £250,000
   - Add funeral costs: £10,000
   - **Total life insurance required: £756,800**
```

---

### 5.6 Notes

**Base Path:** `/api/v1/factfinds/{factfindId}/clients/{clientId}/notes`

**Purpose:** Capture and manage advisor notes across different areas of the fact find, providing context, observations, and important information related to specific aspects of the client's financial planning.

**Scope:**
- Profile notes (personal circumstances, life events)
- Employment notes (job security, career plans)
- Asset & Liabilities notes (property, investments, debts)
- Budget notes (spending patterns, financial discipline)
- Mortgage notes (housing plans, affordability concerns)
- Protection notes (health issues, cover requirements)
- Retirement notes (retirement plans, pension expectations)
- Investment notes (risk tolerance, investment experience)
- Estate Planning notes (inheritance wishes, family dynamics)
- Summary notes (overall observations, recommendations)

**Key Features:**
- **Categorized Notes** - Notes organized by discriminator for easy filtering
- **Character Limit** - 500 characters per note for concise documentation
- **Multiple Notes** - Multiple notes per category for comprehensive tracking
- **Timestamped** - Track when notes were created and updated
- **Audit Trail** - Complete history of all notes for compliance

**Aggregate Root:** Client (notes nested under client)

**Regulatory Compliance:**
- FCA Handbook - Documenting client interactions and observations
- COBS 9.2 - Recording basis for suitability assessment
- Consumer Duty - Understanding customer circumstances
- Data Protection Act 2018 - Secure storage of client notes
- TCF (Treating Customers Fairly) - Documenting fair treatment

#### 5.6.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/notes` | List all notes for client | `notes:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/notes` | Create new note | `notes:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/notes/{noteId}` | Get specific note | `notes:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/notes/{noteId}` | Update note | `notes:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/notes/{noteId}` | Delete note | `notes:write` |

**Total Endpoints:** 5

#### 5.6.2 List Notes

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/notes`

**Description:** Retrieve all notes for a client with optional filtering by discriminator.

**Query Parameters:**
- `discriminator` - Filter by note category (Profile, Employment, AssetLiabilities, etc.)
- `sort` - Sort by createdAt or updatedAt (default: createdAt desc)
- `limit` - Maximum results (default: 50, max: 200)
- `offset` - Pagination offset

**Response:**

```json
{
  "clientRef": {
    "id": "client-456",
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/ff-423/clients/client-456"
  },
  "notes": [
    {
      "id": "note-789",
      "href": "/api/v1/factfinds/ff-423/clients/client-456/notes/note-789",
      "discriminator": "Profile",
      "notes": "Client recently married, spouse is self-employed. Planning to start a family within 2 years. Important for protection planning.",
      "createdAt": "2026-02-18T10:30:00Z",
      "updatedAt": "2026-02-18T10:30:00Z"
    },
    {
      "id": "note-790",
      "href": "/api/v1/factfinds/ff-423/clients/client-456/notes/note-790",
      "discriminator": "Mortgage",
      "notes": "Client's fixed rate ends in 6 months. Should review remortgage options. Considering moving to larger property in next 2-3 years.",
      "createdAt": "2026-02-18T11:00:00Z",
      "updatedAt": "2026-02-18T11:00:00Z"
    },
    {
      "id": "note-791",
      "href": "/api/v1/factfinds/ff-423/clients/client-456/notes/note-791",
      "discriminator": "Protection",
      "notes": "Client has no life insurance. High priority due to mortgage and planned family. Spouse has chronic condition - may affect premiums.",
      "createdAt": "2026-02-18T11:15:00Z",
      "updatedAt": "2026-02-18T11:15:00Z"
    }
  ],
  "totalCount": 3,
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/ff-423/clients/client-456/notes"
    },
    "client": {
      "href": "/api/v1/factfinds/ff-423/clients/client-456"
    }
  }
}
```

#### 5.6.3 Create Note

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/notes`

**Description:** Create a new note for the client in a specific category.

**Request Body:**

```json
{
  "discriminator": "Investment",
  "notes": "Client has limited investment experience. Previously held only cash ISAs. Risk profile indicates balanced approach. Recommend gradual introduction to equity funds with clear education on volatility."
}
```

**Response:**

```json
{
  "id": "note-792",
  "href": "/api/v1/factfinds/ff-423/clients/client-456/notes/note-792",
  "clientRef": {
    "id": "client-456",
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/ff-423/clients/client-456"
  },
  "discriminator": "Investment",
  "notes": "Client has limited investment experience. Previously held only cash ISAs. Risk profile indicates balanced approach. Recommend gradual introduction to equity funds with clear education on volatility.",
  "createdAt": "2026-02-18T14:20:00Z",
  "updatedAt": "2026-02-18T14:20:00Z",
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/ff-423/clients/client-456/notes/note-792"
    },
    "client": {
      "href": "/api/v1/factfinds/ff-423/clients/client-456"
    }
  }
}
```

**Validation Rules:**
- `discriminator` - Required, must be valid enum value
- `notes` - Required, max 500 characters
- Client must exist and belong to factfind

**Business Rules:**
- Notes are immutable after creation (updates create new version)
- Deleted notes soft-deleted (retained for audit)
- Notes included in fact find completion checklist
- Notes exported with fact find reports

#### 5.6.4 Update Note

**Endpoint:** `PATCH /api/v1/factfinds/{factfindId}/clients/{clientId}/notes/{noteId}`

**Description:** Update the text content of an existing note.

**Request Body:**

```json
{
  "notes": "Client has limited investment experience. Previously held only cash ISAs. Risk profile indicates balanced approach. Recommend gradual introduction to equity funds with clear education on volatility. UPDATE: Client comfortable with proposal after discussion."
}
```

**Response:** 200 OK with updated note entity.

**Note:** Some implementations may choose to make notes append-only for compliance, in which case PATCH would create a new version rather than overwrite.

#### 5.6.5 Delete Note

**Endpoint:** `DELETE /api/v1/factfinds/{factfindId}/clients/{clientId}/notes/{noteId}`

**Description:** Delete a note (soft delete for audit trail).

**Response:** 204 No Content

---

**Note Discriminators (Enum):**

| Code | Display | Use Case |
|------|---------|----------|
| PROFILE | Profile | Personal circumstances, life events, family status |
| EMPLOYMENT | Employment | Job security, career plans, income stability |
| ASSET_LIABILITIES | AssetLiabilities | Property notes, investment holdings, debt concerns |
| BUDGET | Budget | Spending patterns, financial discipline, affordability |
| MORTGAGE | Mortgage | Housing plans, remortgage, property moves |
| PROTECTION | Protection | Health issues, cover requirements, existing policies |
| RETIREMENT | Retirement | Retirement plans, pension expectations, lifestyle goals |
| INVESTMENT | Investment | Risk tolerance, investment experience, objectives |
| ESTATE_PLANNING | EstatePlanning | Inheritance wishes, family dynamics, trusts |
| SUMMARY | Summary | Overall observations, key recommendations, next steps |

---

**Use Cases:**

### Use Case 1: Record Protection Planning Notes

**Scenario:** During fact find, discover client health issues affecting protection

**API Flow:**
```
POST /clients/client-456/notes
{
  "discriminator": "Protection",
  "notes": "Client disclosed pre-existing condition (Type 2 diabetes, controlled). May affect life insurance premiums. Consider specialist broker for underwriting."
}

Response: Note created successfully

Use: Reference during protection planning
```

### Use Case 2: Track Mortgage Timeline

**Scenario:** Client fixed rate ending, need to track timeline

**API Flow:**
```
POST /clients/client-456/notes
{
  "discriminator": "Mortgage",
  "notes": "Fixed rate ends Aug 2026. Current rate 2.5%, reverting to 6.5% SVR. Must review options by June 2026. Client considering moving to 4-bed in next 2 years."
}

Response: Note created

Use: Set reminders, include in regular review
```

### Use Case 3: Document Investment Risk Discussion

**Scenario:** Record client's risk tolerance discussion

**API Flow:**
```
POST /clients/client-456/notes
{
  "discriminator": "Investment",
  "notes": "ATR questionnaire: Balanced risk. Client comfortable with 5-10% volatility. Lost money in 2008 crash, learned to hold long-term. Prefers diversified funds over individual stocks."
}

Response: Note created

Use: Demonstrate suitability in file review
```

---

### 5.7 Custom Questions (Supplementary Questions)

**Base Path:** `/api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions`

**Purpose:** Capture additional client information through configurable custom questions beyond standard fact-find fields. Supports dynamic questionnaires with conditional logic, validation rules, and flexible answer types.

**Key Features:**
- **10 Question Types** - Text, Textarea, NumberWhole, NumberDecimal, Date, YesNo, DropDownList, Select, Checkbox, Monetary
- **Conditional Logic** - Questions can be required, enabled, or visible based on answers to other questions
- **Flexible Options** - Multi-select support for dropdown, select, and checkbox questions
- **Pattern Validation** - Regex patterns for text input validation
- **Custom Attributes** - Extensible dictionary for additional metadata
- **Tagging System** - Organize questions by tags and subcategories
- **Separate Answer Storage** - Questions and answers stored separately for versioning
- **Archival Support** - Questions can be archived without losing historical data

**Use Cases:**
- ESG preferences and ethical investing criteria
- Additional due diligence questions for high-net-worth clients
- Product-specific suitability questions
- Regional compliance requirements
- Firm-specific data capture requirements
- Client preference tracking (communication, meeting preferences, etc.)

**Aggregate Root:** Client (within FactFind context)

**Regulatory Compliance:**
- FCA COBS 9.2 (Assessing Suitability - Additional Information Gathering)
- MiFID II Article 25 (Assessment of Suitability)
- FCA Consumer Duty (Understanding Customer Needs)
- GDPR Article 6 (Lawful Basis for Processing)
- Data Protection Act 2018 (Special Category Data)

---

#### 5.7.1 Operations Summary

**Question Management Endpoints:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions` | List all custom questions | `client:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions` | Create custom question | `client:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions/{questionId}` | Get question details | `client:read` |
| PUT | `/api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions/{questionId}` | Update custom question | `client:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions/{questionId}` | Delete custom question | `client:write` |

**Answer Management Endpoints:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions/answers` | Get all question answers | `client:read` |
| PUT | `/api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions/answers` | Submit/update question answers | `client:write` |

---

#### 5.7.2 List Custom Questions

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions`

**Description:** Retrieves all custom questions configured for a client, including archived questions. Use query parameters to filter by tags, subcategory, or archived status.

**Path Parameters:**
- `factfindId` (required) - The fact find identifier
- `clientId` (required) - The client identifier

**Query Parameters:**
- `tags` (optional) - Filter by tags (comma-separated)
- `subcategoryId` (optional) - Filter by subcategory ID
- `includeArchived` (optional) - Include archived questions (default: false)
- `page` (optional) - Page number (default: 1)
- `pageSize` (optional) - Items per page (default: 50, max: 200)

**Response:** `200 OK`

```json
{
  "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions",
  "first_href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions?page=1",
  "last_href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions?page=1",
  "next_href": null,
  "prev_href": null,
  "items": [
    {
      "id": 1234,
      "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1234",
      "questionType": "YesNo",
      "subcategory": {
        "id": 10,
        "order": 1
      },
      "isRequired": true,
      "isMultiple": false,
      "text": "Are you interested in ethical or ESG investing?",
      "options": null,
      "order": 1,
      "tags": ["ESG", "Investment"],
      "isArchived": false,
      "includeNotes": true,
      "placeHolderText": null,
      "helpText": "ESG stands for Environmental, Social, and Governance investing",
      "pattern": null,
      "errorText": null,
      "attributes": {
        "displayGroup": "Investment Preferences",
        "adviserOnly": "false"
      },
      "logic": []
    },
    {
      "id": 1235,
      "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1235",
      "questionType": "Checkbox",
      "subcategory": {
        "id": 10,
        "order": 2
      },
      "isRequired": false,
      "isMultiple": true,
      "text": "Which ESG factors are most important to you?",
      "options": [
        {
          "order": 1,
          "isArchived": false,
          "value": 1,
          "text": "Environmental sustainability"
        },
        {
          "order": 2,
          "isArchived": false,
          "value": 2,
          "text": "Social responsibility"
        },
        {
          "order": 3,
          "isArchived": false,
          "value": 3,
          "text": "Corporate governance"
        },
        {
          "order": 4,
          "isArchived": false,
          "value": 4,
          "text": "Climate change mitigation"
        }
      ],
      "order": 2,
      "tags": ["ESG", "Investment"],
      "isArchived": false,
      "includeNotes": false,
      "placeHolderText": null,
      "helpText": "Select all that apply",
      "pattern": null,
      "errorText": null,
      "attributes": {
        "displayGroup": "Investment Preferences"
      },
      "logic": [
        {
          "type": "VisibleIf",
          "parentQuestion": {
            "id": 1234,
            "answer": "Yes"
          }
        }
      ]
    },
    {
      "id": 1236,
      "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1236",
      "questionType": "Monetary",
      "subcategory": {
        "id": 11,
        "order": 1
      },
      "isRequired": true,
      "isMultiple": false,
      "text": "What is your target retirement income per year?",
      "options": null,
      "order": 3,
      "tags": ["Retirement", "Goals"],
      "isArchived": false,
      "includeNotes": true,
      "placeHolderText": "GBP 50000",
      "helpText": "Enter amount in format: CURRENCY AMOUNT (e.g., GBP 50000)",
      "pattern": "^[A-Z]{3}\\s\\d+(\\.\\d{2})?$",
      "errorText": "Please enter amount in format: GBP 50000",
      "attributes": {
        "displayGroup": "Retirement Planning"
      },
      "logic": []
    }
  ],
  "count": 3,
  "_links": {
    "self": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions" },
    "client": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456" },
    "answers": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/answers" }
  }
}
```

**Business Rules:**
- Questions are returned in `order` sequence
- Archived questions excluded by default unless `includeArchived=true`
- Questions with conditional logic include parent question reference
- Maximum 200 custom questions per client

**Validation Rules:**
- `factfindId` must exist
- `clientId` must exist and belong to the factfind
- User must have `client:read` permission

---

#### 5.7.3 Create Custom Question

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions`

**Description:** Creates a new custom question for a client. The question can include validation rules, conditional logic, and custom attributes.

**Path Parameters:**
- `factfindId` (required) - The fact find identifier
- `clientId` (required) - The client identifier

**Request Body:**

```json
{
  "questionType": "DropDownList",
  "subcategory": {
    "id": 12,
    "order": 1
  },
  "isRequired": true,
  "isMultiple": false,
  "text": "How frequently would you like portfolio reviews?",
  "options": [
    {
      "order": 1,
      "isArchived": false,
      "value": 1,
      "text": "Quarterly"
    },
    {
      "order": 2,
      "isArchived": false,
      "value": 2,
      "text": "Semi-annually"
    },
    {
      "order": 3,
      "isArchived": false,
      "value": 3,
      "text": "Annually"
    }
  ],
  "order": 5,
  "tags": ["Service", "Preferences"],
  "isArchived": false,
  "includeNotes": true,
  "placeHolderText": "Select review frequency",
  "helpText": "We'll schedule regular reviews based on your preference",
  "pattern": null,
  "errorText": null,
  "attributes": {
    "displayGroup": "Service Preferences",
    "affectsServiceLevel": "true"
  },
  "logic": []
}
```

**Response:** `201 Created`

```json
{
  "id": 1240,
  "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1240",
  "questionType": "DropDownList",
  "subcategory": {
    "id": 12,
    "order": 1
  },
  "isRequired": true,
  "isMultiple": false,
  "text": "How frequently would you like portfolio reviews?",
  "options": [
    {
      "order": 1,
      "isArchived": false,
      "value": 1,
      "text": "Quarterly"
    },
    {
      "order": 2,
      "isArchived": false,
      "value": 2,
      "text": "Semi-annually"
    },
    {
      "order": 3,
      "isArchived": false,
      "value": 3,
      "text": "Annually"
    }
  ],
  "order": 5,
  "tags": ["Service", "Preferences"],
  "isArchived": false,
  "includeNotes": true,
  "placeHolderText": "Select review frequency",
  "helpText": "We'll schedule regular reviews based on your preference",
  "pattern": null,
  "errorText": null,
  "attributes": {
    "displayGroup": "Service Preferences",
    "affectsServiceLevel": "true"
  },
  "logic": [],
  "_links": {
    "self": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1240" },
    "client": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456" },
    "questions": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions" },
    "answers": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/answers" }
  }
}
```

**Validation Rules:**
- `questionType` must be one of: Text, Textarea, NumberWhole, NumberDecimal, Date, YesNo, DropDownList, Select, Checkbox, Monetary
- `text` is required (max 500 characters)
- `options` required for DropDownList, Select, Checkbox types
- `options` must have at least 2 options
- Each option must have unique `value`
- `pattern` must be valid regex if provided
- `logic.parentQuestion.id` must reference existing question
- Maximum 200 custom questions per client

**Error Responses:**
- `400 Bad Request` - Invalid question type or validation failure
- `404 Not Found` - Client or factfind not found
- `409 Conflict` - Order conflict with existing question
- `422 Unprocessable Entity` - Parent question reference invalid

---

#### 5.7.4 Get Custom Question Details

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions/{questionId}`

**Description:** Retrieves full details of a specific custom question including all logic rules and options.

**Path Parameters:**
- `factfindId` (required) - The fact find identifier
- `clientId` (required) - The client identifier
- `questionId` (required) - The custom question identifier

**Response:** `200 OK`

```json
{
  "id": 1237,
  "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1237",
  "questionType": "NumberDecimal",
  "subcategory": {
    "id": 13,
    "order": 1
  },
  "isRequired": true,
  "isMultiple": false,
  "text": "What percentage of your portfolio would you allocate to alternative investments?",
  "options": null,
  "order": 10,
  "tags": ["Investment", "RiskProfile"],
  "isArchived": false,
  "includeNotes": true,
  "placeHolderText": "0.00",
  "helpText": "Alternative investments include private equity, hedge funds, commodities, real estate",
  "pattern": "^\\d{1,2}(\\.\\d{1,2})?$",
  "errorText": "Please enter a percentage between 0 and 100",
  "attributes": {
    "displayGroup": "Asset Allocation",
    "min": "0",
    "max": "100",
    "step": "0.01"
  },
  "logic": [
    {
      "type": "EnabledIf",
      "parentQuestion": {
        "id": 1234,
        "answer": "Yes"
      }
    }
  ],
  "_links": {
    "self": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1237" },
    "client": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456" },
    "questions": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions" },
    "parentQuestion": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1234" }
  }
}
```

**Error Responses:**
- `404 Not Found` - Question, client, or factfind not found

---

#### 5.7.5 Update Custom Question

**Endpoint:** `PUT /api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions/{questionId}`

**Description:** Updates an existing custom question. Cannot change question type. All fields are replaced (not merged).

**Path Parameters:**
- `factfindId` (required) - The fact find identifier
- `clientId` (required) - The client identifier
- `questionId` (required) - The custom question identifier

**Request Body:**

```json
{
  "questionType": "Text",
  "subcategory": {
    "id": 14,
    "order": 1
  },
  "isRequired": false,
  "isMultiple": false,
  "text": "Do you have any specific investment exclusions? (Updated wording)",
  "options": null,
  "order": 7,
  "tags": ["Investment", "ESG", "Preferences"],
  "isArchived": false,
  "includeNotes": true,
  "placeHolderText": "e.g., tobacco, weapons, fossil fuels",
  "helpText": "List any sectors or companies you wish to exclude from your portfolio",
  "pattern": null,
  "errorText": null,
  "attributes": {
    "displayGroup": "Investment Preferences",
    "maxLength": "1000"
  },
  "logic": []
}
```

**Response:** `200 OK`

```json
{
  "id": 1238,
  "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1238",
  "questionType": "Text",
  "subcategory": {
    "id": 14,
    "order": 1
  },
  "isRequired": false,
  "isMultiple": false,
  "text": "Do you have any specific investment exclusions? (Updated wording)",
  "options": null,
  "order": 7,
  "tags": ["Investment", "ESG", "Preferences"],
  "isArchived": false,
  "includeNotes": true,
  "placeHolderText": "e.g., tobacco, weapons, fossil fuels",
  "helpText": "List any sectors or companies you wish to exclude from your portfolio",
  "pattern": null,
  "errorText": null,
  "attributes": {
    "displayGroup": "Investment Preferences",
    "maxLength": "1000"
  },
  "logic": [],
  "_links": {
    "self": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1238" },
    "client": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456" },
    "questions": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions" }
  }
}
```

**Business Rules:**
- Cannot change `questionType` after creation
- Updating question text does not affect existing answers
- Order changes may require reordering other questions

**Validation Rules:**
- Same validation rules as Create operation
- `id` in URL must match existing question
- Cannot change `questionType`

**Error Responses:**
- `400 Bad Request` - Attempt to change question type
- `404 Not Found` - Question not found
- `409 Conflict` - Order conflict

---

#### 5.7.6 Delete Custom Question

**Endpoint:** `DELETE /api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions/{questionId}`

**Description:** Soft deletes a custom question by marking it as archived. Historical answers are retained for audit purposes.

**Path Parameters:**
- `factfindId` (required) - The fact find identifier
- `clientId` (required) - The client identifier
- `questionId` (required) - The custom question identifier

**Response:** `204 No Content`

**Business Rules:**
- Question is marked as `isArchived: true` (soft delete)
- Historical answers are retained
- Archived questions excluded from default listings
- Can be retrieved with `includeArchived=true` query parameter

**Error Responses:**
- `404 Not Found` - Question not found
- `409 Conflict` - Question has dependent child questions with logic

---

#### 5.7.7 Submit Question Answers

**Endpoint:** `PUT /api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions/answers`

**Description:** Submits or updates answers to custom questions. Replaces all answers (upsert operation). Missing questions in request remain unchanged.

**Path Parameters:**
- `factfindId` (required) - The fact find identifier
- `clientId` (required) - The client identifier

**Request Body:**

```json
[
  {
    "question": {
      "id": 1234
    },
    "answerText": "Yes",
    "selectedOptions": null,
    "notes": "Client very interested in sustainable investing options"
  },
  {
    "question": {
      "id": 1235
    },
    "answerText": null,
    "selectedOptions": [
      {
        "value": 1,
        "text": "Environmental sustainability"
      },
      {
        "value": 4,
        "text": "Climate change mitigation"
      }
    ],
    "notes": null
  },
  {
    "question": {
      "id": 1236
    },
    "answerText": "GBP 60000",
    "selectedOptions": null,
    "notes": "Includes state pension estimate of £11,500/year"
  }
]
```

**Response:** `200 OK`

```json
{
  "message": "Answers saved successfully",
  "answeredCount": 3,
  "totalQuestions": 5,
  "completionPercentage": 60.0,
  "_links": {
    "self": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/answers" },
    "questions": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions" },
    "client": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456" }
  }
}
```

**Business Rules:**
- Upsert operation - creates new answers or updates existing
- Missing questions in request are not modified
- Empty `answerText` and `selectedOptions` clears the answer
- For monetary questions, format is "CURRENCY AMOUNT" (e.g., "GBP 50000")
- For select/dropdown/checkbox, use `selectedOptions` array
- For all other types, use `answerText`

**Validation Rules:**
- `question.id` must reference existing custom question
- `answerText` OR `selectedOptions` required (not both)
- For DropDownList/Select/Checkbox: `selectedOptions` required
- For other types: `answerText` required
- `selectedOptions` values must match question's option values
- `isMultiple=false`: maximum 1 option in `selectedOptions`
- `isMultiple=true`: multiple options allowed in `selectedOptions`
- Monetary format must match pattern: `^[A-Z]{3}\s\d+(\.\d{2})?$`
- Number answers must match question's `pattern` if specified
- Required questions must have answer if visible/enabled

**Error Responses:**
- `400 Bad Request` - Invalid answer format or validation failure
- `404 Not Found` - Question reference not found
- `422 Unprocessable Entity` - Answer doesn't match question type or options

---

#### 5.7.8 Get Question Answers

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/custom-questions/answers`

**Description:** Retrieves all answers to custom questions for a client, including the question details for context.

**Path Parameters:**
- `factfindId` (required) - The fact find identifier
- `clientId` (required) - The client identifier

**Query Parameters:**
- `tags` (optional) - Filter by question tags (comma-separated)
- `subcategoryId` (optional) - Filter by subcategory
- `includeUnanswered` (optional) - Include questions without answers (default: false)

**Response:** `200 OK`

```json
{
  "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/answers",
  "first_href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/answers?page=1",
  "last_href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/answers?page=1",
  "next_href": null,
  "prev_href": null,
  "items": [
    {
      "question": {
        "id": 1234,
        "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1234",
        "questionType": "YesNo",
        "subcategory": {
          "id": 10,
          "order": 1
        },
        "isRequired": true,
        "isMultiple": false,
        "text": "Are you interested in ethical or ESG investing?",
        "options": null,
        "order": 1,
        "tags": ["ESG", "Investment"],
        "isArchived": false,
        "includeNotes": true,
        "placeHolderText": null,
        "helpText": "ESG stands for Environmental, Social, and Governance investing",
        "pattern": null,
        "errorText": null,
        "attributes": {
          "displayGroup": "Investment Preferences"
        },
        "logic": []
      },
      "answer": {
        "answerText": "Yes",
        "selectedOptions": null,
        "notes": "Client very interested in sustainable investing options"
      }
    },
    {
      "question": {
        "id": 1235,
        "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1235",
        "questionType": "Checkbox",
        "subcategory": {
          "id": 10,
          "order": 2
        },
        "isRequired": false,
        "isMultiple": true,
        "text": "Which ESG factors are most important to you?",
        "options": [
          {
            "order": 1,
            "isArchived": false,
            "value": 1,
            "text": "Environmental sustainability"
          },
          {
            "order": 2,
            "isArchived": false,
            "value": 2,
            "text": "Social responsibility"
          },
          {
            "order": 3,
            "isArchived": false,
            "value": 3,
            "text": "Corporate governance"
          },
          {
            "order": 4,
            "isArchived": false,
            "value": 4,
            "text": "Climate change mitigation"
          }
        ],
        "order": 2,
        "tags": ["ESG", "Investment"],
        "isArchived": false,
        "includeNotes": false,
        "placeHolderText": null,
        "helpText": "Select all that apply",
        "pattern": null,
        "errorText": null,
        "attributes": {
          "displayGroup": "Investment Preferences"
        },
        "logic": [
          {
            "type": "VisibleIf",
            "parentQuestion": {
              "id": 1234,
              "answer": "Yes"
            }
          }
        ]
      },
      "answer": {
        "answerText": null,
        "selectedOptions": [
          {
            "value": 1,
            "text": "Environmental sustainability"
          },
          {
            "value": 4,
            "text": "Climate change mitigation"
          }
        ],
        "notes": null
      }
    },
    {
      "question": {
        "id": 1236,
        "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/1236",
        "questionType": "Monetary",
        "subcategory": {
          "id": 11,
          "order": 1
        },
        "isRequired": true,
        "isMultiple": false,
        "text": "What is your target retirement income per year?",
        "options": null,
        "order": 3,
        "tags": ["Retirement", "Goals"],
        "isArchived": false,
        "includeNotes": true,
        "placeHolderText": "GBP 50000",
        "helpText": "Enter amount in format: CURRENCY AMOUNT (e.g., GBP 50000)",
        "pattern": "^[A-Z]{3}\\s\\d+(\\.\\d{2})?$",
        "errorText": "Please enter amount in format: GBP 50000",
        "attributes": {
          "displayGroup": "Retirement Planning"
        },
        "logic": []
      },
      "answer": {
        "answerText": "GBP 60000",
        "selectedOptions": null,
        "notes": "Includes state pension estimate of £11,500/year"
      }
    }
  ],
  "count": 3,
  "_links": {
    "self": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions/answers" },
    "client": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456" },
    "questions": { "href": "https://api.factfind.com/api/v1/factfinds/ff-123/clients/client-456/custom-questions" }
  }
}
```

**Business Rules:**
- Returns only answered questions by default
- Use `includeUnanswered=true` to see all questions with empty answers
- Answers are returned in question order
- Includes full question details for context

---

### Question Types Reference

| Question Type | Answer Format | Example | Notes |
|--------------|---------------|---------|-------|
| **Text** | Short text string | `"John Smith"` | Single-line text, max 255 chars |
| **Textarea** | Long text string | `"Multi-line\ntext content"` | Multi-line text, max 5000 chars |
| **NumberWhole** | Integer string | `"42"` | Whole numbers only |
| **NumberDecimal** | Decimal string | `"42.50"` | Decimal numbers |
| **Date** | ISO 8601 date | `"2026-02-18"` | Format: YYYY-MM-DD |
| **YesNo** | "Yes" or "No" | `"Yes"` | Boolean question |
| **DropDownList** | selectedOptions array | `[{"value": 1, "text": "Option 1"}]` | Single selection |
| **Select** | selectedOptions array | `[{"value": 2, "text": "Option 2"}]` | Single or multiple selection |
| **Checkbox** | selectedOptions array | `[{"value": 1}, {"value": 3}]` | Multiple selection |
| **Monetary** | Currency + amount | `"GBP 50000.00"` | Format: CURRENCY AMOUNT |

### Logic Types Reference

| Logic Type | Description | Example Use Case |
|-----------|-------------|------------------|
| **RequiredIf** | Question becomes required if parent answer matches | "Pension transfer details required if 'Have existing pension' = Yes" |
| **EnabledIf** | Question becomes enabled (editable) if parent answer matches | "Investment amount enabled if 'Investing?' = Yes" |
| **VisibleIf** | Question becomes visible if parent answer matches | "ESG preferences visible if 'Interest in ESG' = Yes" |

---

### Use Cases

#### Use Case 1: ESG Investment Preferences

**Scenario:** Capture client's environmental, social, and governance investment preferences

**API Flow:**
```
1. Create YesNo question: "Interested in ESG investing?"
   POST /custom-questions

2. Create Checkbox question with VisibleIf logic: "Which ESG factors?"
   POST /custom-questions
   (Visible only if Q1 = "Yes")

3. Client completes questionnaire:
   PUT /custom-questions/answers
   [
     {"question": {"id": 1}, "answerText": "Yes"},
     {"question": {"id": 2}, "selectedOptions": [{"value": 1}, {"value": 4}]}
   ]

4. Retrieve answers for suitability report:
   GET /custom-questions/answers
```

**Benefit:** Dynamic questionnaire adapts based on client responses, reducing clutter

---

#### Use Case 2: High-Net-Worth Due Diligence

**Scenario:** Additional KYC questions for HNW clients (>£1M investable assets)

**API Flow:**
```
1. Create custom questions for source of wealth:
   POST /custom-questions
   {
     "text": "Please describe the source of your wealth",
     "questionType": "Textarea",
     "isRequired": true,
     "tags": ["KYC", "HNW"]
   }

2. Create question for politically exposed person status:
   POST /custom-questions
   {
     "text": "Are you or any family member a Politically Exposed Person?",
     "questionType": "YesNo",
     "isRequired": true,
     "tags": ["KYC", "HNW", "PEP"]
   }

3. Submit answers during onboarding:
   PUT /custom-questions/answers
```

**Benefit:** Firm-specific compliance requirements captured alongside standard fact-find

---

#### Use Case 3: Pension Transfer Suitability

**Scenario:** Additional questions required for DB pension transfer advice

**API Flow:**
```
1. Create question: "Do you have guaranteed benefits?"
   POST /custom-questions

2. Create conditional question: "What is your guaranteed annual income?"
   POST /custom-questions
   {
     "logic": [{
       "type": "RequiredIf",
       "parentQuestion": {"id": 100, "answer": "Yes"}
     }]
   }

3. Create monetary question: "Current transfer value?"
   POST /custom-questions
   {"questionType": "Monetary"}

4. Adviser submits pension analysis:
   PUT /custom-questions/answers
```

**Benefit:** Complex conditional logic ensures regulatory compliance for specialist advice

---

### Regulatory Compliance

**FCA COBS 9.2 - Assessing Suitability:**
- Custom questions allow firms to gather additional information beyond standard fact-find
- Supports "know your customer" obligation
- Documents client circumstances affecting suitability

**MiFID II Article 25:**
- Additional questions support enhanced suitability assessment
- ESG preferences align with sustainability preferences requirements
- Documented questionnaire responses provide audit trail

**FCA Consumer Duty:**
- Custom questions help firms understand individual client needs
- Flexible questionnaire adapts to client circumstances
- Notes field allows advisers to document client discussions

**Data Protection Act 2018:**
- Custom questions may capture special category data (health, politics)
- Firms must ensure lawful basis for processing
- Attributes field can flag data requiring additional protection
- Soft delete preserves data for regulatory retention periods

**FCA Handbook PS21/5 (Pension Transfer Advice):**
- Additional due diligence questions for DB pension transfers
- Conditional logic ensures required fields completed
- Monetary question types capture transfer values and guaranteed benefits

---

### Technical Notes

**Question Versioning:**
- Questions are immutable once answers exist
- Updates create new version internally
- Historical answers reference original question version

**Performance Optimization:**
- Questions cached per client (invalidate on update)
- Answers stored separately for efficient retrieval
- Pagination recommended for clients with >50 questions

**Conditional Logic Execution:**
- Logic evaluated client-side for UX responsiveness
- Server validates all logic rules on answer submission
- Circular dependencies detected and rejected

**Security Considerations:**
- Custom attributes allow PII flagging
- Questions marked as "adviserOnly" hidden from client portal
- Audit log tracks all question and answer modifications
- GDPR right-to-erasure: soft delete retains regulatory minimum

---



## 6. Income & Expenditure API (Circumstances Context)

### 6.1 Overview

**Base Paths:**
- Employment: `/api/v1/factfinds/{factfindId}/clients/{clientId}/employment`
- Income: `/api/v1/factfinds/{factfindId}/clients/{clientId}/income`
- Income Changes: `/api/v1/factfinds/{factfindId}/clients/{clientId}/income-changes`
- Expenditure: `/api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure`
- Expenditure Changes: `/api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure-changes`

**Purpose:** Track client's actual income sources, employment history, expenditure, and expected changes to their financial circumstances.

**Scope:**
- Employment history (current and past employment records)
- Income sources (salaries, rental income, dividends, pensions in payment, benefits)
- Expected income changes (promotions, bonuses, retirement, benefit changes)
- Living expenses (mortgage/rent, utilities, food, transport, insurance)
- Debt payments (loans, credit cards)
- Expected expenditure changes (mortgage payoff, retirement lifestyle changes)

**Aggregate Root:** Client (each client has their own circumstances, nested under FactFind)

**Key Characteristics:**
- **Nested under clients** - Each client in a fact-find has their own income and expenditure
- **Actual cash flow** - Records real money coming in and going out
- **Time-based** - Tracks start dates, end dates, and future changes
- **Frequency-aware** - Handles weekly, monthly, quarterly, annual amounts
- **Affordability calculations** - Supports budget and affordability assessments

**Regulatory Compliance:**
- FCA COBS (Suitability and Affordability)
- Consumer Duty (Understanding Customer Needs)
- Mortgage Credit Directive (Affordability Assessment)

### 6.2 Operations Summary

**Employment Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/employment` | List employment records | `circumstances:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/employment` | Create employment record | `circumstances:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/employment/{id}` | Get employment details | `circumstances:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/employment/{id}` | Update employment record | `circumstances:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/employment/{id}` | Delete employment record | `circumstances:write` |

**Income Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/income` | List income sources | `circumstances:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/income` | Create income source | `circumstances:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/income/{id}` | Get income details | `circumstances:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/income/{id}` | Update income source | `circumstances:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/income/{id}` | Delete income source | `circumstances:write` |

**Income Changes Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/income-changes` | List expected income changes | `circumstances:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/income-changes` | Create income change | `circumstances:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/income-changes/{id}` | Get income change details | `circumstances:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/income-changes/{id}` | Update income change | `circumstances:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/income-changes/{id}` | Delete income change | `circumstances:write` |

**Expenditure Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure` | List expenditure items | `circumstances:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure` | Create expenditure item | `circumstances:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure/{id}` | Get expenditure details | `circumstances:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure/{id}` | Update expenditure item | `circumstances:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure/{id}` | Delete expenditure item | `circumstances:write` |

**Expenditure Changes Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure-changes` | List expected expenditure changes | `circumstances:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure-changes` | Create expenditure change | `circumstances:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure-changes/{id}` | Get expenditure change details | `circumstances:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure-changes/{id}` | Update expenditure change | `circumstances:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure-changes/{id}` | Delete expenditure change | `circumstances:write` |

### 6.3 Key Endpoints

### 6.3 Key Endpoints

#### 6.3.1 List Employment Records

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/employment`

**Description:** Retrieve all employment records for a client, including current and historical employment.

**Query Parameters:**
- `status` - Filter by employment status (Current, Previous, NotEmployed)
- `includeEnded` - Include employment records with end dates (default: true)

**Response:**
```json
{
  "clientId": "client-123",
  "clientName": "John Smith",
  "totalRecords": 2,
  "employment": [
    {
      "id": "emp-456",
      "employmentType": "Employed",
      "employerName": "ABC Technology Ltd",
      "jobTitle": "Software Engineer",
      "occupation": {
        "code": "2136",
        "display": "Programmers and software development professionals"
      },
      "startDate": "2020-03-01",
      "endDate": null,
      "status": "Current",
      "annualSalary": {
        "amount": 65000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "payFrequency": "Monthly",
      "bonusAmount": {
        "amount": 5000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "benefitsInKind": {
        "amount": 2000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "_links": {
        "self": {
          "href": "/api/v1/factfinds/{factfindId}/clients/client-123/employment/emp-456"
        }
      }
    }
  ],
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/employment"
    },
    "create": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/employment",
      "method": "POST"
    }
  }
}
```

#### 6.3.2 Create Employment Record

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/employment`

**Description:** Create a new employment record for a client.

**Request Body:**
```json
{
  "employmentType": "Employed",
  "employerName": "XYZ Corporation",
  "jobTitle": "Financial Analyst",
  "occupation": {
    "code": "3537",
    "display": "Financial and accounting technicians"
  },
  "startDate": "2021-06-01",
  "endDate": null,
  "status": "Current",
  "annualSalary": {
    "amount": 45000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "payFrequency": "Monthly",
  "bonusAmount": {
    "amount": 3000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  }
}
```

**Response:**
```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/{factfindId}/clients/client-123/employment/emp-789

{
  "id": "emp-789",
  "employmentType": "Employed",
  "employerName": "XYZ Corporation",
  "jobTitle": "Financial Analyst",
  "occupation": {
    "code": "3537",
    "display": "Financial and accounting technicians"
  },
  "startDate": "2021-06-01",
  "endDate": null,
  "status": "Current",
  "annualSalary": {
    "amount": 45000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "payFrequency": "Monthly",
  "bonusAmount": {
    "amount": 3000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "createdAt": "2026-02-18T10:00:00Z",
  "updatedAt": "2026-02-18T10:00:00Z",
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/employment/emp-789"
    },
    "update": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/employment/emp-789",
      "method": "PATCH"
    },
    "client": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123"
    }
  }
}
```

**Employment Types:**
- `Employed` - Salaried employment
- `SelfEmployed` - Self-employed/sole trader
- `Director` - Company director
- `Retired` - Retired from employment
- `NotEmployed` - Unemployed or not in workforce

#### 6.3.3 List Income Sources

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/income`

**Description:** Retrieve all income sources for a client.

**Query Parameters:**
- `incomeCategory` - Filter by income category (Employment, Rental, Investment, Pension, Benefits, Other)
- `isTaxable` - Filter by taxable status (true/false)
- `includeEnded` - Include income with end dates (default: true)

**Response:**
```json
{
  "clientId": "client-123",
  "clientName": "John Smith",
  "totalIncome": {
    "amount": 72000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "income": [
    {
      "id": "inc-111",
      "incomeCategory": "Employment",
      "description": "Salary from ABC Technology",
      "amount": {
        "amount": 65000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": "Annual",
      "startDate": "2020-03-01",
      "endDate": null,
      "isTaxable": true,
      "_links": {
        "self": {
          "href": "/api/v1/factfinds/{factfindId}/clients/client-123/income/inc-111"
        }
      }
    },
    {
      "id": "inc-222",
      "incomeCategory": "Rental",
      "description": "Rental income - Buy-to-Let property",
      "amount": {
        "amount": 7000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": "Annual",
      "startDate": "2019-01-01",
      "endDate": null,
      "isTaxable": true,
      "_links": {
        "self": {
          "href": "/api/v1/factfinds/{factfindId}/clients/client-123/income/inc-222"
        }
      }
    }
  ],
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/income"
    },
    "create": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/income",
      "method": "POST"
    }
  }
}
```

#### 6.3.4 Create Income Source

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/income`

**Description:** Create a new income source for a client.

**Request Body:**
```json
{
  "incomeCategory": "Pension",
  "description": "State Pension",
  "amount": {
    "amount": 10600.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "frequency": "Annual",
  "startDate": "2027-01-01",
  "endDate": null,
  "isTaxable": true
}
```

**Response:**
```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/{factfindId}/clients/client-123/income/inc-333

{
  "id": "inc-333",
  "incomeCategory": "Pension",
  "description": "State Pension",
  "amount": {
    "amount": 10600.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "frequency": "Annual",
  "startDate": "2027-01-01",
  "endDate": null,
  "isTaxable": true,
  "createdAt": "2026-02-18T10:15:00Z",
  "updatedAt": "2026-02-18T10:15:00Z",
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/income/inc-333"
    },
    "update": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/income/inc-333",
      "method": "PATCH"
    },
    "client": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123"
    }
  }
}
```

**Income Categories:**
- `Employment` - Salary, wages, bonuses
- `Rental` - Rental income from properties
- `Investment` - Dividends, interest
- `Pension` - Pension income (state, private)
- `Benefits` - State benefits, welfare
- `Other` - Other income sources

**Frequency Values:**
- `Weekly`, `Fortnightly`, `Monthly`, `Quarterly`, `Annual`

#### 6.3.5 Create Income Change

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/income-changes`

**Description:** Record an expected change to income (e.g., retirement, promotion, bonus ending).

**Request Body:**
```json
{
  "incomeRef": {
    "id": "inc-111",
    "description": "Salary from ABC Technology"
  },
  "changeType": "Stop",
  "effectiveDate": "2027-03-01",
  "newAmount": null,
  "reason": "Retirement"
}
```

**Response:**
```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/{factfindId}/clients/client-123/income-changes/inc-change-444

{
  "id": "inc-change-444",
  "incomeRef": {
    "id": "inc-111",
    "description": "Salary from ABC Technology",
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123/income/inc-111"
  },
  "changeType": "Stop",
  "effectiveDate": "2027-03-01",
  "newAmount": null,
  "reason": "Retirement",
  "createdAt": "2026-02-18T10:30:00Z",
  "updatedAt": "2026-02-18T10:30:00Z",
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/income-changes/inc-change-444"
    },
    "income": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/income/inc-111"
    },
    "client": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123"
    }
  }
}
```

**Change Types:**
- `Increase` - Income will increase
- `Decrease` - Income will decrease
- `Stop` - Income will cease
- `Start` - New income will commence

#### 6.3.6 List Expenditure Items

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure`

**Description:** Retrieve all expenditure items for a client.

**Query Parameters:**
- `expenditureType` - Filter by type (Mortgage, Rent, Utilities, Food, Transport, Insurance, Debt, Discretionary)
- `isDiscretionary` - Filter by discretionary status (true/false)

**Response:**
```json
{
  "clientId": "client-123",
  "clientName": "John Smith",
  "totalExpenditure": {
    "amount": 48000.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "expenditure": [
    {
      "id": "exp-555",
      "expenditureType": "Mortgage",
      "description": "Mortgage payment - main residence",
      "amount": {
        "amount": 18000.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": "Annual",
      "isDiscretionary": false,
      "startDate": "2015-06-01",
      "endDate": "2040-05-31",
      "_links": {
        "self": {
          "href": "/api/v1/factfinds/{factfindId}/clients/client-123/expenditure/exp-555"
        }
      }
    },
    {
      "id": "exp-666",
      "expenditureType": "Utilities",
      "description": "Gas, electricity, water",
      "amount": {
        "amount": 2400.00,
        "currency": {
          "code": "GBP",
          "display": "British Pound",
          "symbol": "£"
        }
      },
      "frequency": "Annual",
      "isDiscretionary": false,
      "startDate": "2015-06-01",
      "endDate": null,
      "_links": {
        "self": {
          "href": "/api/v1/factfinds/{factfindId}/clients/client-123/expenditure/exp-666"
        }
      }
    }
  ],
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/expenditure"
    },
    "create": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/expenditure",
      "method": "POST"
    }
  }
}
```

#### 6.3.7 Create Expenditure Item

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure`

**Description:** Create a new expenditure item for a client.

**Request Body:**
```json
{
  "expenditureType": "Transport",
  "description": "Car lease payment",
  "amount": {
    "amount": 3600.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "frequency": "Annual",
  "isDiscretionary": true,
  "startDate": "2024-01-01",
  "endDate": "2027-12-31"
}
```

**Response:**
```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/{factfindId}/clients/client-123/expenditure/exp-777

{
  "id": "exp-777",
  "expenditureType": "Transport",
  "description": "Car lease payment",
  "amount": {
    "amount": 3600.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "frequency": "Annual",
  "isDiscretionary": true,
  "startDate": "2024-01-01",
  "endDate": "2027-12-31",
  "createdAt": "2026-02-18T11:00:00Z",
  "updatedAt": "2026-02-18T11:00:00Z",
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/expenditure/exp-777"
    },
    "update": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/expenditure/exp-777",
      "method": "PATCH"
    },
    "client": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123"
    }
  }
}
```

**Expenditure Types:**
- `Mortgage` - Mortgage or rent payments
- `Rent` - Rental payments
- `Utilities` - Gas, electricity, water, council tax
- `Food` - Groceries and dining
- `Transport` - Car, fuel, public transport
- `Insurance` - Home, car, life insurance premiums
- `Debt` - Loan payments, credit card payments
- `Discretionary` - Entertainment, holidays, hobbies
- `Other` - Other expenses

#### 6.3.8 Create Expenditure Change

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/expenditure-changes`

**Description:** Record an expected change to expenditure (e.g., mortgage payoff, lifestyle changes).

**Request Body:**
```json
{
  "expenditureRef": {
    "id": "exp-555",
    "description": "Mortgage payment - main residence"
  },
  "changeType": "Stop",
  "effectiveDate": "2040-05-31",
  "newAmount": null,
  "reason": "Mortgage term end"
}
```

**Response:**
```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/{factfindId}/clients/client-123/expenditure-changes/exp-change-888

{
  "id": "exp-change-888",
  "expenditureRef": {
    "id": "exp-555",
    "description": "Mortgage payment - main residence",
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123/expenditure/exp-555"
  },
  "changeType": "Stop",
  "effectiveDate": "2040-05-31",
  "newAmount": null,
  "reason": "Mortgage term end",
  "createdAt": "2026-02-18T11:15:00Z",
  "updatedAt": "2026-02-18T11:15:00Z",
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/expenditure-changes/exp-change-888"
    },
    "expenditure": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123/expenditure/exp-555"
    },
    "client": {
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123"
    }
  }
}
```

**Change Types:**
- `Increase` - Expenditure will increase
- `Decrease` - Expenditure will decrease
- `Stop` - Expenditure will cease
- `Start` - New expenditure will commence

### 6.4 Affordability

**Base Path:** `/api/v1/factfinds/{factfindId}/clients/{clientId}/affordability`

**Purpose:** Calculate comprehensive affordability assessments for clients based on their income and expenditure, supporting mortgage applications, protection planning, investment planning, and debt consolidation scenarios.

**Scope:**
- Monthly disposable income calculations
- Revised income/expenditure with expected changes
- Consolidated and repaid liability adjustments
- Protection premium impact analysis
- Emergency fund assessment
- Lump sum availability analysis
- Multiple scenario modeling (forgo non-essentials, exclude liabilities, rebroker protection)
- Budget agreement and tracking

**Key Features:**
- **Dynamic Calculations** - Real-time affordability based on selected income and expenditure items
- **Scenario Modeling** - Toggle various options to see impact on disposable income
- **Expected Changes** - Include or exclude future income/expenditure changes
- **Liability Consolidation** - Model impact of debt consolidation
- **Protection Analysis** - Calculate protection premium impact
- **Emergency Fund** - Track committed vs required emergency fund
- **Lump Sum Planning** - Model available capital for investment or debt reduction

**Aggregate Root:** Client (affordability nested under client)

**Regulatory Compliance:**
- MCOB (Mortgage Conduct of Business) - Affordability assessments
- FCA Handbook - Responsible lending requirements
- Consumer Duty - Understanding customer financial position
- COBS 9.2 - Assessing suitability for investments and protection
- CCA (Consumer Credit Act) - Creditworthiness assessments

#### 6.4.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/affordability` | Calculate affordability | `affordability:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/affordability` | List all affordability calculations | `affordability:read` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/affordability/{affordabilityId}` | Get specific calculation | `affordability:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/affordability/{affordabilityId}` | Update calculation parameters | `affordability:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/affordability/{affordabilityId}` | Delete calculation | `affordability:write` |

**Total Endpoints:** 5

#### 6.4.2 Calculate Affordability

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/affordability`

**Description:** Perform a comprehensive affordability calculation based on selected income and expenditure items, with configurable scenario options.

**Request Body:**

```json
{
  "incomes": [
    { "id": "income-001" },
    { "id": "income-002" }
  ],
  "expenditures": [
    { "id": "exp-001" },
    { "id": "exp-002" },
    { "id": "exp-003" }
  ],
  "options": {
    "isIncludeExpectedIncomeChanges": true,
    "isIncludeExpectedExpenditureChanges": false,
    "isForgoNonEssentialExpenditure": false,
    "isExcludeConsolidatedLiabilities": false,
    "isExcludeRepaidLiabilities": false,
    "isRebrokerProtection": false
  },
  "emergencyFund": {
    "committedAmount": {
      "amount": 5000.00,
      "currencyCode": "GBP"
    },
    "requiredAmount": {
      "amount": 8000.00,
      "currencyCode": "GBP"
    }
  },
  "lumpSum": {
    "availableAmount": {
      "amount": 50000.00,
      "currencyCode": "GBP"
    },
    "agreedInvestmentAmount": {
      "amount": 30000.00,
      "currencyCode": "GBP"
    },
    "fundSource": "PropertySale",
    "isAvailableWithoutPenalty": true,
    "totalFundsAvailable": {
      "amount": 55000.00,
      "currencyCode": "GBP"
    },
    "notes": "From property sale completion expected March 2026"
  },
  "agreedBudget": {
    "amount": 1500.00,
    "currencyCode": "GBP"
  },
  "notes": "Client has variable income from bonus"
}
```

**Response:**

```json
{
  "id": "afford-1001",
  "href": "/api/v1/factfinds/ff-234/clients/client-456/affordability/afford-1001",
  "clientRef": {
    "id": "client-456",
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/ff-234/clients/client-456"
  },
  "incomes": [
    {
      "id": "income-001",
      "description": "Primary employment salary",
      "netMonthlyAmount": {
        "amount": 3500.00,
        "currencyCode": "GBP"
      },
      "href": "/api/v1/factfinds/ff-234/clients/client-456/income/income-001"
    },
    {
      "id": "income-002",
      "description": "Rental income from BTL property",
      "netMonthlyAmount": {
        "amount": 1000.00,
        "currencyCode": "GBP"
      },
      "href": "/api/v1/factfinds/ff-234/clients/client-456/income/income-002"
    }
  ],
  "expenditures": [
    {
      "id": "exp-001",
      "description": "Mortgage payment",
      "monthlyAmount": {
        "amount": 1500.00,
        "currencyCode": "GBP"
      },
      "isEssential": true,
      "href": "/api/v1/factfinds/ff-234/clients/client-456/expenditure/exp-001"
    },
    {
      "id": "exp-002",
      "description": "Living expenses",
      "monthlyAmount": {
        "amount": 1000.00,
        "currencyCode": "GBP"
      },
      "isEssential": true,
      "href": "/api/v1/factfinds/ff-234/clients/client-456/expenditure/exp-002"
    },
    {
      "id": "exp-003",
      "description": "Gym membership and leisure",
      "monthlyAmount": {
        "amount": 300.00,
        "currencyCode": "GBP"
      },
      "isEssential": false,
      "href": "/api/v1/factfinds/ff-234/clients/client-456/expenditure/exp-003"
    }
  ],
  "monthly": {
    "totalNetIncome": {
      "amount": 4500.00,
      "currencyCode": "GBP"
    },
    "totalExpenditure": {
      "amount": 2800.00,
      "currencyCode": "GBP"
    },
    "disposableIncome": {
      "amount": 1700.00,
      "currencyCode": "GBP"
    },
    "revisedIncome": {
      "amount": 4700.00,
      "currencyCode": "GBP"
    },
    "revisedExpenditure": {
      "amount": 2900.00,
      "currencyCode": "GBP"
    },
    "consolidatedExpenditure": {
      "amount": 500.00,
      "currencyCode": "GBP"
    },
    "repaidExpenditure": {
      "amount": 300.00,
      "currencyCode": "GBP"
    },
    "protectionPremiums": {
      "amount": 150.00,
      "currencyCode": "GBP"
    },
    "finalDisposableIncome": {
      "amount": 1250.00,
      "currencyCode": "GBP"
    },
    "isIncludeExpectedIncomeChanges": true,
    "isIncludeExpectedExpenditureChanges": false,
    "isForgoNonEssentialExpenditure": false,
    "isExcludeConsolidatedLiabilities": false,
    "isExcludeRepaidLiabilities": false,
    "isRebrokerProtection": false,
    "agreedBudget": {
      "amount": 1500.00,
      "currencyCode": "GBP"
    },
    "notes": "Client has variable income from bonus"
  },
  "emergencyFund": {
    "committedAmount": {
      "amount": 5000.00,
      "currencyCode": "GBP"
    },
    "requiredAmount": {
      "amount": 8000.00,
      "currencyCode": "GBP"
    },
    "shortfall": {
      "amount": 3000.00,
      "currencyCode": "GBP"
    }
  },
  "lumpSum": {
    "availableAmount": {
      "amount": 50000.00,
      "currencyCode": "GBP"
    },
    "agreedInvestmentAmount": {
      "amount": 30000.00,
      "currencyCode": "GBP"
    },
    "fundSource": "PropertySale",
    "isAvailableWithoutPenalty": true,
    "totalFundsAvailable": {
      "amount": 55000.00,
      "currencyCode": "GBP"
    },
    "notes": "From property sale completion expected March 2026"
  },
  "createdAt": "2026-01-15T10:30:00Z",
  "updatedAt": "2026-01-29T14:45:00Z",
  "concurrencyId": 5,
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/ff-234/clients/client-456/affordability/afford-1001"
    },
    "client": {
      "href": "/api/v1/factfinds/ff-234/clients/client-456"
    },
    "update": {
      "href": "/api/v1/factfinds/ff-234/clients/client-456/affordability/afford-1001",
      "method": "PATCH"
    },
    "delete": {
      "href": "/api/v1/factfinds/ff-234/clients/client-456/affordability/afford-1001",
      "method": "DELETE"
    }
  }
}
```

**Calculation Logic:**

**1. Base Calculation:**
```
disposableIncome = totalNetIncome - totalExpenditure
```

**2. Revised Income (with expected changes):**
```
revisedIncome = totalNetIncome + expectedIncomeIncreases - expectedIncomeDecreases
```

**3. Revised Expenditure (with expected changes):**
```
revisedExpenditure = totalExpenditure + expectedExpenditureIncreases - expectedExpenditureDecreases
```

**4. Consolidated Expenditure Adjustment:**
```
If isExcludeConsolidatedLiabilities = true:
  adjustedExpenditure = revisedExpenditure - consolidatedExpenditure
```

**5. Repaid Expenditure Adjustment:**
```
If isExcludeRepaidLiabilities = true:
  adjustedExpenditure = adjustedExpenditure - repaidExpenditure
```

**6. Non-Essential Forgo:**
```
If isForgoNonEssentialExpenditure = true:
  adjustedExpenditure = essentialExpenditureOnly
```

**7. Protection Premium Adjustment:**
```
If isRebrokerProtection = true:
  adjustedExpenditure = adjustedExpenditure - currentProtectionPremiums + rebrokenProtectionPremiums
```

**8. Final Disposable Income:**
```
finalDisposableIncome = revisedIncome - adjustedExpenditure
```

**Validation Rules:**
- `incomes` - At least one income required
- `expenditures` - At least one expenditure required
- All income/expenditure IDs must exist and belong to client
- Emergency fund amounts must be non-negative
- Lump sum amounts must be non-negative
- agreedInvestmentAmount cannot exceed availableAmount

**Business Rules:**
- All amounts normalized to monthly frequency
- Income changes only included if isIncludeExpectedIncomeChanges = true
- Expenditure changes only included if isIncludeExpectedExpenditureChanges = true
- Emergency fund shortfall calculated as requiredAmount - committedAmount
- Emergency fund recommendation: 3-6 months essential expenditure
- Final disposable income used for mortgage affordability, investment capacity

#### 6.4.3 List Affordability Calculations

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/affordability`

**Description:** Retrieve all affordability calculations for a client.

**Query Parameters:**
- `sort` - Sort by createdAt, updatedAt (default: createdAt desc)
- `limit` - Maximum results (default: 20, max: 100)
- `offset` - Pagination offset

**Response:**

```json
{
  "clientRef": {
    "id": "client-456",
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/ff-234/clients/client-456"
  },
  "calculations": [
    {
      "id": "afford-1001",
      "createdAt": "2026-01-29T14:45:00Z",
      "monthly": {
        "totalNetIncome": {
          "amount": 4500.00,
          "currencyCode": "GBP"
        },
        "finalDisposableIncome": {
          "amount": 1250.00,
          "currencyCode": "GBP"
        }
      },
      "notes": "Client has variable income from bonus",
      "href": "/api/v1/factfinds/ff-234/clients/client-456/affordability/afford-1001"
    },
    {
      "id": "afford-1000",
      "createdAt": "2026-01-15T10:30:00Z",
      "monthly": {
        "totalNetIncome": {
          "amount": 4200.00,
          "currencyCode": "GBP"
        },
        "finalDisposableIncome": {
          "amount": 1100.00,
          "currencyCode": "GBP"
        }
      },
      "notes": "Initial assessment",
      "href": "/api/v1/factfinds/ff-234/clients/client-456/affordability/afford-1000"
    }
  ],
  "totalCount": 2,
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/ff-234/clients/client-456/affordability"
    },
    "client": {
      "href": "/api/v1/factfinds/ff-234/clients/client-456"
    }
  }
}
```

#### 6.4.4 Update Affordability Calculation

**Endpoint:** `PATCH /api/v1/factfinds/{factfindId}/clients/{clientId}/affordability/{affordabilityId}`

**Description:** Update scenario options or add/remove income/expenditure items, triggering recalculation.

**Request Body:**

```json
{
  "options": {
    "isForgoNonEssentialExpenditure": true,
    "isExcludeConsolidatedLiabilities": true
  },
  "agreedBudget": {
    "amount": 1800.00,
    "currencyCode": "GBP"
  },
  "notes": "Updated scenario: client willing to forgo non-essentials"
}
```

**Response:** 200 OK with recalculated affordability entity.

**Automatic Recalculations:**
- All monthly figures recalculated
- Revised income/expenditure updated
- Final disposable income recalculated
- Updated timestamp incremented
- concurrencyId incremented

#### 6.4.5 Delete Affordability Calculation

**Endpoint:** `DELETE /api/v1/factfinds/{factfindId}/clients/{clientId}/affordability/{affordabilityId}`

**Description:** Delete an affordability calculation.

**Response:** 204 No Content

**Business Rules:**
- Soft delete (retained for audit)
- Does not affect related income/expenditure records
- Cannot delete if referenced in active mortgage application

---

**Scenario Options Explained:**

| Option | Description | Impact |
|--------|-------------|--------|
| **isIncludeExpectedIncomeChanges** | Include future income increases/decreases | Increases revisedIncome if positive changes expected |
| **isIncludeExpectedExpenditureChanges** | Include future expenditure increases/decreases | May increase/decrease revisedExpenditure |
| **isForgoNonEssentialExpenditure** | Client willing to cut non-essential spending | Reduces expenditure to essentials only |
| **isExcludeConsolidatedLiabilities** | Model debt consolidation scenario | Reduces expenditure by consolidated debt payments |
| **isExcludeRepaidLiabilities** | Exclude debts being paid off | Reduces expenditure by repaid debt amounts |
| **isRebrokerProtection** | Model rebrokering protection policies | Adjusts expenditure based on new protection premiums |

---

**Emergency Fund Calculation:**

**Required Amount Recommendation:**
- **Conservative:** 6 months essential expenditure
- **Moderate:** 4 months essential expenditure
- **Aggressive:** 3 months essential expenditure

**Formula:**
```
requiredAmount = essentialMonthlyExpenditure × months (3-6)
shortfall = requiredAmount - committedAmount
```

**Example:**
- Essential monthly expenditure: £2,500
- Months coverage: 4
- Required amount: £10,000
- Committed amount: £6,000
- **Shortfall: £4,000**

---

**Lump Sum Sources:**

| Code | Display | Description |
|------|---------|-------------|
| PROPERTY_SALE | PropertySale | Proceeds from property sale |
| INHERITANCE | Inheritance | Inherited funds |
| BONUS | Bonus | Employment bonus |
| INVESTMENT_MATURITY | InvestmentMaturity | Maturing investment |
| SAVINGS | Savings | Accumulated savings |
| GIFT | Gift | Gift from family |
| PENSION_LUMP_SUM | PensionLumpSum | Tax-free pension lump sum |
| REDUNDANCY | Redundancy | Redundancy payment |
| OTHER | Other | Other lump sum source |

---

**Use Cases:**

### Use Case 1: Mortgage Affordability Assessment

**Scenario:** Client applying for £250,000 mortgage

**API Flow:**
```
1. POST /clients/client-456/affordability
   Request: {
     incomes: [salary, rental income],
     expenditures: [all current expenditures],
     options: {
       isIncludeExpectedIncomeChanges: false,  // Conservative
       isIncludeExpectedExpenditureChanges: true,
       isForgoNonEssentialExpenditure: false
     }
   }

2. Response shows:
   - finalDisposableIncome: £1,250/month
   - Maximum affordable mortgage payment: ~£1,000/month (80% of disposable)
   - Affordable loan amount: ~£220,000 (at 4% over 25 years)

3. Decision: £250,000 mortgage marginally affordable
   - Requires: Reduce non-essentials OR increase income OR longer term
```

### Use Case 2: Debt Consolidation Planning

**Scenario:** Client has 3 credit cards totaling £15,000, paying £500/month

**API Flow:**
```
1. Create affordability scenario with consolidation:
   POST /clients/client-456/affordability
   Request: {
     options: {
       isExcludeConsolidatedLiabilities: true
     },
     consolidatedExpenditure: { amount: 500.00 }
   }

2. Response shows:
   - Current disposable income: £800/month
   - With consolidation (£250/month loan): £1,050/month
   - Monthly saving: £250

3. Decision: Consolidate at 8% APR over 5 years
   - New payment: £250/month
   - Frees up: £250/month
   - Total interest saved: £3,000+
```

### Use Case 3: Investment Capacity Assessment

**Scenario:** Client wants to start regular investment

**API Flow:**
```
1. Calculate current affordability:
   GET /clients/client-456/affordability (latest)
   - finalDisposableIncome: £1,250/month
   - agreedBudget: £1,500/month (client's target)

2. Available for investment:
   - Current disposable: £1,250
   - Recommended emergency fund top-up: £100/month
   - Available for regular investment: £1,150/month

3. Recommendation:
   - Regular investment: £800/month
   - Emergency fund: £100/month
   - Buffer: £350/month

4. Create investment plan referencing affordability calculation
```

### Use Case 4: Forgo Non-Essentials Scenario

**Scenario:** Client struggling with affordability, model cutting non-essentials

**API Flow:**
```
1. Current position:
   - Disposable income: £600/month
   - Non-essential expenditure: £400/month
   - Essential only: £200/month

2. Model scenario:
   PATCH /clients/client-456/affordability/afford-1001
   Request: {
     options: { isForgoNonEssentialExpenditure: true }
   }

3. Response shows:
   - Original disposable income: £600/month
   - With forgo non-essentials: £1,000/month
   - Improvement: £400/month

4. Discussion with client:
   - Identify which non-essentials can be reduced
   - Gym, entertainment, dining out
   - Create sustainable budget
```

### 6.5 Credit History

**Base Path:** `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history`

**Purpose:** Track and manage client credit history including adverse credit events, missed payments, defaults, IVAs, bankruptcies, and repossessions to support mortgage applications, creditworthiness assessments, and financial planning.

**Scope:**
- Credit refusal tracking
- Adverse credit events (defaults, CCJs, IVAs, bankruptcies)
- Missed payment history
- Payment arrears tracking
- Debt outstanding status
- Repossession history
- Lender relationships
- Liability linkage

**Key Features:**
- **Adverse Credit Flags** - Track refused credit and adverse events
- **Event Dating** - Register, satisfy, discharge, and repossession dates
- **Amount Tracking** - Original and outstanding debt amounts
- **Payment History** - Missed and consecutive missed payments
- **Arrears Management** - Track arrears and clearance status
- **IVA Tracking** - Current IVA status and years maintained
- **Liability Linking** - Connect credit history to specific liabilities
- **Multiple Owners** - Support joint credit accounts

**Aggregate Root:** Client (credit history nested under client)

**Regulatory Compliance:**
- MCOB (Mortgage Conduct of Business) - Credit history disclosure for mortgages
- FCA Handbook - Understanding client creditworthiness
- Consumer Credit Act - Credit history accuracy requirements
- Data Protection Act 2018 - Sensitive credit data handling
- GDPR - Right to rectification of credit data

#### 6.5.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history` | List all credit history records | `credit:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history` | Add credit history record | `credit:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history/{historyId}` | Get specific record | `credit:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history/{historyId}` | Update credit record | `credit:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history/{historyId}` | Delete credit record | `credit:write` |

**Total Endpoints:** 5

#### 6.5.2 List Credit History

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history`

**Description:** Retrieve all credit history records for a client.

**Query Parameters:**
- `hasAdverseCredit` - Filter by adverse credit flag (true/false)
- `type` - Filter by event type (Default, CCJ, IVA, Bankruptcy, Repossession)
- `isDebtOutstanding` - Filter by outstanding debt status
- `sort` - Sort by dateRegisteredOn, updatedAt (default: dateRegisteredOn desc)

**Response:**

```json
{
  "clientRef": {
    "id": "client-456",
    "fullName": "John Smith",
    "href": "/api/v1/factfinds/ff-423/clients/client-456"
  },
  "creditHistory": [
    {
      "id": "ch-789",
      "href": "/api/v1/factfinds/ff-423/clients/client-456/credit-history/ch-789",
      "owners": [
        {
          "id": "client-456",
          "href": "/api/v1/factfinds/ff-423/clients/client-456",
          "name": "John Smith",
          "ownershipType": "Primary"
        }
      ],
      "hasBeenRefusedCredit": false,
      "hasAdverseCredit": true,
      "type": "Default",
      "dateRegisteredOn": "2020-06-15",
      "dateSatisfiedOrClearedOn": "2023-12-20",
      "amountRegistered": {
        "amount": 5000.00,
        "currency": "GBP"
      },
      "amountOutstanding": {
        "amount": 0.00,
        "currency": "GBP"
      },
      "isDebtOutstanding": false,
      "lender": "High Street Bank",
      "liability": {
        "id": "liab-1001",
        "href": "/api/v1/factfinds/ff-423/liabilities/liab-1001",
        "description": "Credit Card Debt"
      }
    }
  ],
  "summary": {
    "totalRecords": 1,
    "hasRefusedCredit": false,
    "hasAdverseCredit": true,
    "adverseEventCount": 1,
    "totalDebtOutstanding": {
      "amount": 0.00,
      "currency": "GBP"
    }
  },
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/ff-423/clients/client-456/credit-history"
    },
    "client": {
      "href": "/api/v1/factfinds/ff-423/clients/client-456"
    }
  }
}
```

#### 6.5.3 Create Credit History Record

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history`

**Description:** Add a new credit history event for the client.

**Request Body:**

```json
{
  "owners": [
    {
      "id": "client-456",
      "ownershipType": "Primary"
    }
  ],
  "hasBeenRefusedCredit": false,
  "refusedCreditDetails": null,
  "hasAdverseCredit": true,
  "type": "Default",
  "dateRegisteredOn": "2020-06-15",
  "dateSatisfiedOrClearedOn": "2023-12-20",
  "dateReposessedOn": null,
  "dateDischargedOn": null,
  "amountRegistered": {
    "amount": 5000.00,
    "currency": "GBP"
  },
  "amountOutstanding": {
    "amount": 3500.00,
    "currency": "GBP"
  },
  "isDebtOutstanding": true,
  "numberOfPaymentsMissed": 2,
  "consecutivePaymentsMissed": 2,
  "numberOfPaymentsInArrears": 1,
  "isArrearsClearedUponCompletion": true,
  "isIvaCurrent": false,
  "yearsMaintained": 5,
  "lender": "High Street Bank",
  "liability": {
    "id": "liab-1001"
  }
}
```

**Response:**

```json
{
  "id": "ch-789",
  "href": "/api/v1/factfinds/ff-423/clients/client-456/credit-history/ch-789",
  "owners": [
    {
      "id": "client-456",
      "href": "/api/v1/factfinds/ff-423/clients/client-456",
      "name": "John Smith",
      "ownershipType": "Primary"
    }
  ],
  "hasBeenRefusedCredit": false,
  "refusedCreditDetails": null,
  "hasAdverseCredit": true,
  "type": "Default",
  "dateRegisteredOn": "2020-06-15",
  "dateSatisfiedOrClearedOn": "2023-12-20",
  "dateReposessedOn": null,
  "dateDischargedOn": null,
  "amountRegistered": {
    "amount": 5000.00,
    "currency": "GBP"
  },
  "amountOutstanding": {
    "amount": 3500.00,
    "currency": "GBP"
  },
  "isDebtOutstanding": true,
  "numberOfPaymentsMissed": 2,
  "consecutivePaymentsMissed": 2,
  "numberOfPaymentsInArrears": 1,
  "isArrearsClearedUponCompletion": true,
  "isIvaCurrent": false,
  "yearsMaintained": 5,
  "lender": "High Street Bank",
  "liability": {
    "id": "liab-1001",
    "href": "/api/v1/factfinds/ff-423/liabilities/liab-1001",
    "description": "Credit Card Debt"
  },
  "concurrencyId": 1,
  "createdAt": "2026-02-18T15:30:00Z",
  "updatedAt": "2026-02-18T15:30:00Z",
  "_links": {
    "self": {
      "href": "/api/v1/factfinds/ff-423/clients/client-456/credit-history/ch-789"
    },
    "client": {
      "href": "/api/v1/factfinds/ff-423/clients/client-456"
    },
    "liability": {
      "href": "/api/v1/factfinds/ff-423/liabilities/liab-1001"
    }
  }
}
```

**Validation Rules:**
- `owners` - At least one owner required
- `type` - Required if hasAdverseCredit = true
- `dateRegisteredOn` - Required if hasAdverseCredit = true
- `amountRegistered` - Required for defaults, CCJs
- `amountOutstanding` - Must be <= amountRegistered
- `yearsMaintained` - Required if isIvaCurrent = true
- All dates cannot be in future

**Business Rules:**
- Adverse credit flag automatically set if type is specified
- Satisfied date must be after registered date
- Discharged date must be after registered date
- Credit history affects mortgage affordability assessments
- IVA affects creditworthiness for 6 years
- Defaults remain on file for 6 years from registration date

#### 6.5.4 Update Credit History Record

**Endpoint:** `PATCH /api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history/{historyId}`

**Description:** Update an existing credit history record, typically to mark as satisfied/cleared or update outstanding amount.

**Request Body:**

```json
{
  "dateSatisfiedOrClearedOn": "2024-01-15",
  "amountOutstanding": {
    "amount": 0.00,
    "currency": "GBP"
  },
  "isDebtOutstanding": false,
  "concurrencyId": 12
}
```

**Response:** 200 OK with updated credit history entity.

**Common Updates:**
- Mark default as satisfied
- Update outstanding debt amount
- Clear arrears status
- Complete IVA
- Discharge bankruptcy

#### 6.5.5 Delete Credit History Record

**Endpoint:** `DELETE /api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history/{historyId}`

**Description:** Delete a credit history record (soft delete for audit).

**Response:** 204 No Content

**Business Rules:**
- Soft delete (retained for compliance)
- Cannot delete if referenced in active mortgage application
- Deletion logged for audit trail

---

**Credit History Types (Enum):**

| Code | Display | Description | Typical Duration on File |
|------|---------|-------------|-------------------------|
| DEFAULT | Default | Payment default registered | 6 years from registration |
| CCJ | County Court Judgment | Court judgment for unpaid debt | 6 years from judgment |
| IVA | Individual Voluntary Arrangement | Formal agreement with creditors | 6 years from start |
| BANKRUPTCY | Bankruptcy | Declared bankrupt | 6 years from discharge |
| REPOSSESSION | Repossession | Property repossessed | 6 years from repossession |
| MISSED_PAYMENT | Missed Payment | Late or missed payment | 6 years from missed payment |
| DEBT_RELIEF_ORDER | Debt Relief Order | DRO for debts under £30k | 6 years from DRO |

---

**Ownership Types (Enum):**

| Code | Display | Description |
|------|---------|-------------|
| PRIMARY | Primary | Primary account holder |
| JOINT | Joint | Joint account holder (equal responsibility) |
| GUARANTOR | Guarantor | Guarantor for account |
| LINKED | Linked | Financial association (e.g., spouse) |

---

**Use Cases:**

### Use Case 1: Record Satisfied Default for Mortgage Application

**Scenario:** Client had credit card default, now satisfied, applying for mortgage

**API Flow:**
```
POST /clients/client-456/credit-history
{
  "hasAdverseCredit": true,
  "type": "Default",
  "dateRegisteredOn": "2020-06-15",
  "dateSatisfiedOrClearedOn": "2023-12-20",
  "amountRegistered": { "amount": 5000.00, "currency": "GBP" },
  "amountOutstanding": { "amount": 0.00, "currency": "GBP" },
  "isDebtOutstanding": false,
  "lender": "High Street Bank"
}

Response: Credit history created

Impact on mortgage:
- Default satisfied 1+ years ago: Good
- Original amount only £5k: Minimal impact
- Zero outstanding: Positive
- Lender assessment: Consider specialist or mainstream with larger deposit
```

### Use Case 2: Track Active IVA

**Scenario:** Client in IVA, need to track for creditworthiness

**API Flow:**
```
POST /clients/client-456/credit-history
{
  "hasAdverseCredit": true,
  "type": "IVA",
  "dateRegisteredOn": "2022-03-01",
  "isIvaCurrent": true,
  "yearsMaintained": 2,
  "amountRegistered": { "amount": 45000.00, "currency": "GBP" },
  "amountOutstanding": { "amount": 15000.00, "currency": "GBP" }
}

Response: IVA credit history created

Impact:
- Active IVA: Cannot obtain mainstream credit
- Years maintained: 2 of typical 5-6 year term
- Must complete IVA before mortgage application
- Review annually for IVA completion
```

### Use Case 3: Update Credit History - Default Satisfied

**Scenario:** Client pays off default during fact find process

**API Flow:**
```
GET /clients/client-456/credit-history/ch-789
Current state: amountOutstanding = £3,500

PATCH /clients/client-456/credit-history/ch-789
{
  "dateSatisfiedOrClearedOn": "2026-02-18",
  "amountOutstanding": { "amount": 0.00, "currency": "GBP" },
  "isDebtOutstanding": false
}

Response: Updated credit history

Impact on mortgage application:
- Recently satisfied: Better than outstanding
- Shows commitment to clearing debt
- May improve mortgage terms
- Recommend waiting 3-6 months for credit score improvement
```

### Use Case 4: Joint Credit History

**Scenario:** Joint clients have shared CCJ

**API Flow:**
```
POST /clients/client-456/credit-history
{
  "owners": [
    { "id": "client-456", "ownershipType": "Joint" },
    { "id": "client-457", "ownershipType": "Joint" }
  ],
  "hasAdverseCredit": true,
  "type": "CCJ",
  "dateRegisteredOn": "2021-08-10",
  "dateSatisfiedOrClearedOn": "2022-12-15",
  "amountRegistered": { "amount": 8500.00, "currency": "GBP" },
  "amountOutstanding": { "amount": 0.00, "currency": "GBP" },
  "isDebtOutstanding": false,
  "lender": "Utility Company"
}

Response: Joint credit history created

Impact:
- Affects both clients equally
- CCJ satisfied 1+ year ago: Acceptable for many lenders
- Joint mortgage application affected
- Consider specialist broker
```

---

## 7. Employment API (Part of Circumstances Context)

### 7.1 Overview

**Base Path:** `/api/v1/factfinds/{factfindId}/clients/{clientId}/employment`

**Purpose:** Track client's employment history and current employment status.

**Scope:**
- Current employment records
- Historical employment (employment timeline)
- Self-employment and directorship tracking
- Employment income and benefits
- Occupation and industry information
- Employment status changes over time

**Aggregate Root:** Client (employment is nested under each client)

**Key Characteristics:**
- **Nested under clients** - Each client has their own employment records
- **Supports current and historical** - Track employment timeline including past roles
- **Multiple employment types** - Employed, self-employed, director, retired, not employed
- **Income connection** - Employment records link to income sources

**Regulatory Compliance:**
- FCA COBS (Know Your Customer - Employment Status)
- Mortgage Credit Directive (Employment verification for affordability)
- Consumer Duty (Understanding client circumstances)

### 7.2 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/employment` | List employment history | `employment:read` |
| POST | `/api/v1/factfinds/{factfindId}/clients/{clientId}/employment` | Add employment record | `employment:write` |
| GET | `/api/v1/factfinds/{factfindId}/clients/{clientId}/employment/{employmentId}` | Get employment details | `employment:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/clients/{clientId}/employment/{employmentId}` | Update employment | `employment:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/clients/{clientId}/employment/{employmentId}` | Delete employment | `employment:write` |

### 7.3 Key Endpoints

Employment operations are documented in Section 6.3 (Income & Expenditure API) as part of the Circumstances Context.

See Section 6.3.1 and 6.3.2 for detailed employment endpoint documentation including:
- List Employment Records (Section 6.3.1)
- Create Employment Record (Section 6.3.2)
- Update Employment Record
- Employment Types and Contract Types

---

## 8. Goals & Objectives API (Goals Context)

### 8.1 Overview

**Base Path:** `/api/v1/factfinds/{factfindId}/objectives`

**Purpose:** Capture and track client financial goals and objectives across different life areas using type-based routing.

**Scope:**
- Type-based objectives (investment, pension, protection, mortgage, budget, estate-planning)
- Short, medium, and long-term goal definition
- Protection goals (life cover, income protection, critical illness)
- Retirement planning goals (retirement age, desired income)
- Investment goals (lump sum targets, regular savings)
- Mortgage goals (house purchase, remortgage)
- Budget goals (spending limits, debt reduction)
- Estate planning goals (inheritance, trusts, gifting)
- Goal prioritization and tracking
- Needs sub-resources for detailed requirements capture

**Aggregate Root:** FactFind (objectives are nested within)

**Key Characteristics:**
- **Type discrimination via URL path** - Different objective types have type-specific fields
- **Six objective types** - investment, pension, protection, mortgage, budget, estate-planning
- **Type-specific contracts** - Each objective type has its own schema
- **Needs sub-resources** - Capture detailed needs under each objective

**Regulatory Compliance:**
- FCA COBS (Understanding client objectives)
- Consumer Duty (Delivering good outcomes)
- PROD (Target Market assessment)

### 8.2 Operations Summary

**Objective Type Operations (6 types × 4 operations + 1 list + 1 delete = 26 endpoints):**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/objectives` | List all objectives (all types) | `objectives:read` |
| POST | `/api/v1/factfinds/{factfindId}/objectives/investment` | Create Investment Objective | `objectives:write` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/investment` | List Investment Objectives | `objectives:read` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/investment/{objectiveId}` | Get Investment Objective | `objectives:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/objectives/investment/{objectiveId}` | Update Investment Objective | `objectives:write` |
| POST | `/api/v1/factfinds/{factfindId}/objectives/pension` | Create Pension Objective | `objectives:write` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/pension` | List Pension Objectives | `objectives:read` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/pension/{objectiveId}` | Get Pension Objective | `objectives:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/objectives/pension/{objectiveId}` | Update Pension Objective | `objectives:write` |
| POST | `/api/v1/factfinds/{factfindId}/objectives/protection` | Create Protection Objective | `objectives:write` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/protection` | List Protection Objectives | `objectives:read` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/protection/{objectiveId}` | Get Protection Objective | `objectives:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/objectives/protection/{objectiveId}` | Update Protection Objective | `objectives:write` |
| POST | `/api/v1/factfinds/{factfindId}/objectives/mortgage` | Create Mortgage Objective | `objectives:write` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/mortgage` | List Mortgage Objectives | `objectives:read` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/mortgage/{objectiveId}` | Get Mortgage Objective | `objectives:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/objectives/mortgage/{objectiveId}` | Update Mortgage Objective | `objectives:write` |
| POST | `/api/v1/factfinds/{factfindId}/objectives/budget` | Create Budget Objective | `objectives:write` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/budget` | List Budget Objectives | `objectives:read` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/budget/{objectiveId}` | Get Budget Objective | `objectives:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/objectives/budget/{objectiveId}` | Update Budget Objective | `objectives:write` |
| POST | `/api/v1/factfinds/{factfindId}/objectives/estate-planning` | Create Estate Planning Objective | `objectives:write` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/estate-planning` | List Estate Planning Objectives | `objectives:read` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/estate-planning/{objectiveId}` | Get Estate Planning Objective | `objectives:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/objectives/estate-planning/{objectiveId}` | Update Estate Planning Objective | `objectives:write` |
| **DELETE** | **`/api/v1/factfinds/{factfindId}/objectives/{objectiveId}`** | **Delete any objective (all types)** | `objectives:write` |

**Note:** DELETE operation does not require type in the path. The objective ID is sufficient to identify and delete the objective regardless of its type. The type is determined from the existing objective record.

**Needs Sub-Resources (5 operations):**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/objectives/{objectiveId}/needs` | List needs | `objectives:read` |
| POST | `/api/v1/factfinds/{factfindId}/objectives/{objectiveId}/needs` | Add need | `objectives:write` |
| GET | `/api/v1/factfinds/{factfindId}/objectives/{objectiveId}/needs/{needId}` | Get need details | `objectives:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/objectives/{objectiveId}/needs/{needId}` | Update need | `objectives:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/objectives/{objectiveId}/needs/{needId}` | Delete need | `objectives:write` |

**Total Endpoints:** 31 (26 objective operations + 5 needs operations)

### 8.3 Objective Types and Contracts

Each objective type has specific fields relevant to that goal category. All objectives share common fields (id, factfindRef, clientRef, description, priority, targetDate, status) plus type-specific fields.

#### 8.3.1 Investment Objectives

**Purpose:** Track investment goals and savings targets.

**Type-Specific Fields:**
- `investmentPurpose` - Purpose of the investment (Wealth accumulation, House deposit, Education, etc.)
- `timeHorizon` - Investment time horizon in years
- `riskProfile` - Target risk profile for investments
- `lumpSumRequired` - Target lump sum amount
- `currentInvestments` - Current investment value
- `shortfallAmount` - Gap to target

For detailed request/response examples, see API Endpoints Catalog Section 6.3.1.

#### 8.3.2 Pension Objectives

**Purpose:** Track retirement planning goals.

**Type-Specific Fields:**
- `retirementAge` - Target retirement age
- `annualIncomeRequired` - Annual retirement income target
- `lumpSumRequired` - Lump sum required at retirement
- `incomeDrawdownStrategy` - Strategy for drawing income
- `statePensionForecast` - Expected state pension amount

For detailed request/response examples, see API Endpoints Catalog Section 6.3.2.

#### 8.3.3 Protection Objectives

**Purpose:** Track protection needs (life, critical illness, income protection).

**Type-Specific Fields:**
- `protectionType` - Type of protection (Life, Critical Illness, Income Protection)
- `coverRequired` - Amount of cover required
- `coverTerm` - Term of cover in years
- `dependants` - Number of dependants
- `currentCover` - Existing cover amount
- `shortfallAmount` - Gap in protection

For detailed request/response examples, see API Endpoints Catalog Section 6.3.3.

#### 8.3.4 Mortgage Objectives

**Purpose:** Track mortgage and property purchase goals.

**Type-Specific Fields:**
- `propertyValue` - Target property value
- `depositAmount` - Available deposit
- `loanRequired` - Mortgage amount required
- `propertyAddress` - Target property address (if known)
- `isFirstTimeBuyer` - First-time buyer status
- `affordabilityAssessment` - Affordability assessment result

For detailed request/response examples, see API Endpoints Catalog Section 6.3.4.

#### 8.3.5 Budget Objectives

**Purpose:** Track budget and spending goals.

**Type-Specific Fields:**
- `budgetType` - Type of budget goal (Debt Reduction, Emergency Fund, Spending Control, Savings)
- `monthlyTarget` - Monthly budget target
- `currentSpend` - Current monthly spending
- `savingsTarget` - Target monthly savings

For detailed request/response examples, see API Endpoints Catalog Section 6.3.5.

#### 8.3.6 Estate Planning Objectives

**Purpose:** Track estate planning and inheritance goals.

**Type-Specific Fields:**
- `estateValue` - Current estate value
- `inheritanceTaxLiability` - Estimated IHT liability
- `beneficiaryCount` - Number of beneficiaries
- `trustsRequired` - Whether trusts are needed
- `willInPlace` - Whether will is in place
- `powerOfAttorneyInPlace` - Whether POA is in place

For detailed request/response examples, see API Endpoints Catalog Section 6.3.6.

### 8.4 Needs Sub-Resources

**Purpose:** Capture detailed needs and questions under each objective.

**Endpoint Pattern:** `/api/v1/factfinds/{factfindId}/objectives/{objectiveId}/needs`

**Need Contract:**
- `id` - Unique identifier
- `questionId` - Question identifier
- `question` - The question text
- `answer` - Client's answer
- `answeredAt` - Timestamp
- `priority` - Priority level (High, Medium, Low)

For detailed request/response examples, see API Endpoints Catalog Section 6.4.

---

## 9. Assets & Liabilities API

### 9.1 Overview

**Base Path:** `/api/v1/factfinds/{id}/assets`

**Purpose:** Manage factfind-level assets and liabilities with comprehensive tracking, valuations, and financial calculations.

**Scope:**
- Asset management (property, business, investments, cash, other)
- Liability tracking (mortgages, loans, credit cards, other debts)
- Property details with valuations, LTV, rental yield, and CGT calculations
- Business asset details with valuations
- Aggregated views for financial summary and net worth calculations
- Joint ownership tracking across multiple clients

**Key Features:**
- **Embedded Property Details** - Property-specific data nested within property assets
- **Embedded Business Details** - Business-specific data nested within business assets
- **Valuation History** - Track multiple valuations over time for properties and businesses
- **Financial Calculations** - Automated LTV, rental yield, CGT, net worth calculations
- **Joint Ownership** - Assets can be jointly owned by multiple clients within factfind

**Aggregate Root:** FactFind (assets and liabilities are factfind-level resources)

**Regulatory Compliance:**
- FCA Handbook - Understanding client assets for suitability
- MLR 2017 - Source of wealth verification
- HMRC Capital Gains Tax regulations
- HMRC Stamp Duty Land Tax requirements
- Data Protection Act 2018 - Asset data retention

### 9.2 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| **Assets** | | | |
| GET | `/api/v1/factfinds/{id}/assets` | List all assets | `assets:read` |
| POST | `/api/v1/factfinds/{id}/assets` | Add asset | `assets:write` |
| GET | `/api/v1/factfinds/{id}/assets/{assetId}` | Get asset details | `assets:read` |
| PATCH | `/api/v1/factfinds/{id}/assets/{assetId}` | Update asset | `assets:write` |
| DELETE | `/api/v1/factfinds/{id}/assets/{assetId}` | Delete asset | `assets:write` |
| **Liabilities** | | | |
| GET | `/api/v1/factfinds/{id}/liabilities` | List all liabilities | `liabilities:read` |
| POST | `/api/v1/factfinds/{id}/liabilities` | Add liability | `liabilities:write` |
| GET | `/api/v1/factfinds/{id}/liabilities/{liabilityId}` | Get liability details | `liabilities:read` |
| PATCH | `/api/v1/factfinds/{id}/liabilities/{liabilityId}` | Update liability | `liabilities:write` |
| DELETE | `/api/v1/factfinds/{id}/liabilities/{liabilityId}` | Delete liability | `liabilities:write` |
| **Property Details** | | | |
| GET | `/api/v1/factfinds/{id}/assets/{assetId}/property-detail` | Get property detail | `assets:read` |
| PATCH | `/api/v1/factfinds/{id}/assets/{assetId}/property-detail` | Update property detail | `assets:write` |
| GET | `/api/v1/factfinds/{id}/assets/{assetId}/property-detail/valuations` | Get valuation history | `assets:read` |
| POST | `/api/v1/factfinds/{id}/assets/{assetId}/property-detail/valuations` | Add property valuation | `assets:write` |
| GET | `/api/v1/factfinds/{id}/assets/{assetId}/property-detail/ltv` | Calculate LTV | `assets:read` |
| GET | `/api/v1/factfinds/{id}/assets/{assetId}/property-detail/rental-yield` | Calculate rental yield | `assets:read` |
| GET | `/api/v1/factfinds/{id}/assets/{assetId}/property-detail/capital-gains` | Calculate CGT | `assets:read` |
| **Business Asset Details** | | | |
| GET | `/api/v1/factfinds/{id}/assets/{assetId}/business-asset` | Get business asset detail | `assets:read` |
| PATCH | `/api/v1/factfinds/{id}/assets/{assetId}/business-asset` | Update business asset | `assets:write` |
| GET | `/api/v1/factfinds/{id}/assets/{assetId}/business-asset/valuations` | Get valuation history | `assets:read` |
| POST | `/api/v1/factfinds/{id}/assets/{assetId}/business-asset/valuations` | Add business valuation | `assets:write` |
| **Aggregated Views** | | | |
| GET | `/api/v1/factfinds/{id}/assets/summary` | Get assets summary | `assets:read` |
| GET | `/api/v1/factfinds/{id}/liabilities/summary` | Get liabilities summary | `liabilities:read` |
| GET | `/api/v1/factfinds/{id}/net-worth` | Calculate net worth | `assets:read` |

**Total Endpoints:** 24

### 9.3 Key Endpoints

#### 9.3.1 List Assets

**Endpoint:** `GET /api/v1/factfinds/{id}/assets`

**Description:** Retrieve all assets associated with a factfind. Assets can be owned by individual clients or jointly owned.

**Query Parameters:**
- `assetType` - Filter by asset type (property, business, investment, cash, other)
- `clientId` - Filter by owning client
- `includeDetails` - Include embedded property/business details (default: false)

**Response:**

```json
{
  "assets": [
    {
      "id": "asset-123",
      "factfindRef": { "id": "ff-456", "href": "/api/v1/factfinds/ff-456" },
      "assetType": {
        "code": "PROPERTY",
        "display": "Property"
      },
      "description": "Primary Residence - 123 Main Street",
      "currentValue": {
        "amount": 450000.00,
        "currency": { "code": "GBP", "symbol": "£" },
        "valuationDate": "2026-01-15"
      },
      "ownership": {
        "ownershipType": {
          "code": "JOINT",
          "display": "Joint Ownership"
        },
        "owners": [
          {
            "clientRef": { "id": "client-123", "href": "/api/v1/factfinds/ff-456/clients/client-123" },
            "ownershipShare": 50.0
          },
          {
            "clientRef": { "id": "client-124", "href": "/api/v1/factfinds/ff-456/clients/client-124" },
            "ownershipShare": 50.0
          }
        ]
      },
      "hasPropertyDetail": true,
      "createdAt": "2026-02-01T10:00:00Z",
      "updatedAt": "2026-02-15T14:30:00Z",
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/assets/asset-123" },
        "property-detail": { "href": "/api/v1/factfinds/ff-456/assets/asset-123/property-detail" }
      }
    }
  ],
  "totalCount": 1,
  "totalValue": {
    "amount": 450000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  }
}
```

#### 9.3.2 Create Asset

**Endpoint:** `POST /api/v1/factfinds/{id}/assets`

**Description:** Add a new asset to the factfind.

**Request Body:**

```json
{
  "assetType": {
    "code": "PROPERTY"
  },
  "description": "Buy-to-Let Property - 45 Oak Avenue",
  "currentValue": {
    "amount": 275000.00,
    "currency": { "code": "GBP" },
    "valuationDate": "2026-02-01"
  },
  "ownership": {
    "ownershipType": { "code": "SOLE" },
    "owners": [
      {
        "clientRef": { "id": "client-123" },
        "ownershipShare": 100.0
      }
    ]
  },
  "purchaseDetails": {
    "purchaseDate": "2020-03-15",
    "purchasePrice": {
      "amount": 220000.00,
      "currency": { "code": "GBP" }
    }
  }
}
```

**Response:** 201 Created with complete asset entity including server-generated fields.

#### 9.3.3 Get Property Details

**Endpoint:** `GET /api/v1/factfinds/{id}/assets/{assetId}/property-detail`

**Description:** Get detailed property information for a property asset. This embedded resource contains property-specific fields.

**Response:**

```json
{
  "assetRef": { "id": "asset-123", "href": "/api/v1/factfinds/ff-456/assets/asset-123" },
  "propertyType": {
    "code": "RESIDENTIAL_OWNER_OCCUPIED",
    "display": "Residential - Owner Occupied"
  },
  "address": {
    "line1": "123 Main Street",
    "line2": "Apartment 4B",
    "city": "London",
    "county": "Greater London",
    "postcode": "SW1A 1AA",
    "country": { "code": "GB", "display": "United Kingdom" }
  },
  "propertyDetails": {
    "bedrooms": 3,
    "bathrooms": 2,
    "propertySize": {
      "value": 1200,
      "unit": "sqft"
    },
    "yearBuilt": 1995,
    "tenure": {
      "code": "FREEHOLD",
      "display": "Freehold"
    }
  },
  "linkedMortgages": [
    {
      "liabilityRef": { "id": "liability-789", "href": "/api/v1/factfinds/ff-456/liabilities/liability-789" },
      "outstandingBalance": {
        "amount": 180000.00,
        "currency": { "code": "GBP" }
      }
    }
  ],
  "rentalDetails": {
    "isRented": true,
    "monthlyRent": {
      "amount": 1800.00,
      "currency": { "code": "GBP" }
    },
    "annualRentalIncome": {
      "amount": 21600.00,
      "currency": { "code": "GBP" }
    }
  },
  "taxDetails": {
    "isPrimaryResidence": false,
    "cgtExemptions": [],
    "stampDutyPaid": {
      "amount": 8500.00,
      "currency": { "code": "GBP" }
    }
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/assets/asset-123/property-detail" },
    "asset": { "href": "/api/v1/factfinds/ff-456/assets/asset-123" },
    "valuations": { "href": "/api/v1/factfinds/ff-456/assets/asset-123/property-detail/valuations" },
    "ltv": { "href": "/api/v1/factfinds/ff-456/assets/asset-123/property-detail/ltv" },
    "rental-yield": { "href": "/api/v1/factfinds/ff-456/assets/asset-123/property-detail/rental-yield" },
    "capital-gains": { "href": "/api/v1/factfinds/ff-456/assets/asset-123/property-detail/capital-gains" }
  }
}
```

#### 9.3.4 Calculate LTV (Loan-to-Value)

**Endpoint:** `GET /api/v1/factfinds/{id}/assets/{assetId}/property-detail/ltv`

**Description:** Calculate the Loan-to-Value ratio for a property by comparing linked mortgages to current property value.

**Response:**

```json
{
  "assetRef": { "id": "asset-123" },
  "currentValue": {
    "amount": 450000.00,
    "currency": { "code": "GBP" }
  },
  "totalMortgageBalance": {
    "amount": 180000.00,
    "currency": { "code": "GBP" }
  },
  "ltvRatio": 40.0,
  "equity": {
    "amount": 270000.00,
    "currency": { "code": "GBP" }
  },
  "linkedMortgages": [
    {
      "liabilityRef": { "id": "liability-789" },
      "outstandingBalance": {
        "amount": 180000.00,
        "currency": { "code": "GBP" }
      }
    }
  ],
  "calculatedAt": "2026-02-18T10:30:00Z"
}
```

#### 9.3.5 Calculate Rental Yield

**Endpoint:** `GET /api/v1/factfinds/{id}/assets/{assetId}/property-detail/rental-yield`

**Description:** Calculate gross and net rental yield for a buy-to-let property.

**Response:**

```json
{
  "assetRef": { "id": "asset-123" },
  "propertyValue": {
    "amount": 275000.00,
    "currency": { "code": "GBP" }
  },
  "annualRentalIncome": {
    "amount": 21600.00,
    "currency": { "code": "GBP" }
  },
  "annualExpenses": {
    "amount": 4200.00,
    "currency": { "code": "GBP" },
    "breakdown": {
      "maintenance": { "amount": 1200.00 },
      "insurance": { "amount": 800.00 },
      "managementFees": { "amount": 2200.00 }
    }
  },
  "grossYield": 7.85,
  "netYield": 6.33,
  "calculatedAt": "2026-02-18T10:30:00Z"
}
```

#### 9.3.6 List Liabilities

**Endpoint:** `GET /api/v1/factfinds/{id}/liabilities`

**Description:** Retrieve all liabilities associated with a factfind.

**Query Parameters:**
- `liabilityType` - Filter by type (mortgage, loan, credit_card, other)
- `clientId` - Filter by responsible client

**Response:**

```json
{
  "liabilities": [
    {
      "id": "liability-789",
      "factfindRef": { "id": "ff-456" },
      "liabilityType": {
        "code": "MORTGAGE",
        "display": "Mortgage"
      },
      "lender": "First National Bank",
      "accountNumber": "****1234",
      "outstandingBalance": {
        "amount": 180000.00,
        "currency": { "code": "GBP" }
      },
      "monthlyPayment": {
        "amount": 1200.00,
        "currency": { "code": "GBP" }
      },
      "interestRate": 3.5,
      "remainingTerm": {
        "years": 20,
        "months": 6
      },
      "linkedAsset": {
        "assetRef": { "id": "asset-123", "href": "/api/v1/factfinds/ff-456/assets/asset-123" },
        "description": "Primary Residence"
      },
      "responsibleClients": [
        {
          "clientRef": { "id": "client-123" },
          "responsibilityShare": 50.0
        },
        {
          "clientRef": { "id": "client-124" },
          "responsibilityShare": 50.0
        }
      ],
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/liabilities/liability-789" },
        "linked-asset": { "href": "/api/v1/factfinds/ff-456/assets/asset-123" }
      }
    }
  ],
  "totalCount": 1,
  "totalOutstanding": {
    "amount": 180000.00,
    "currency": { "code": "GBP" }
  }
}
```

#### 9.3.7 Get Assets Summary

**Endpoint:** `GET /api/v1/factfinds/{id}/assets/summary`

**Description:** Get aggregated summary of all assets by type.

**Response:**

```json
{
  "factfindRef": { "id": "ff-456" },
  "totalAssets": {
    "amount": 725000.00,
    "currency": { "code": "GBP" }
  },
  "assetsByType": [
    {
      "assetType": { "code": "PROPERTY", "display": "Property" },
      "count": 2,
      "totalValue": {
        "amount": 725000.00,
        "currency": { "code": "GBP" }
      },
      "percentage": 100.0
    }
  ],
  "assetsByClient": [
    {
      "clientRef": { "id": "client-123", "name": "John Smith" },
      "totalValue": {
        "amount": 500000.00,
        "currency": { "code": "GBP" }
      },
      "percentage": 68.97
    },
    {
      "clientRef": { "id": "client-124", "name": "Jane Smith" },
      "totalValue": {
        "amount": 225000.00,
        "currency": { "code": "GBP" }
      },
      "percentage": 31.03
    }
  ],
  "calculatedAt": "2026-02-18T10:30:00Z"
}
```

#### 9.3.8 Calculate Net Worth

**Endpoint:** `GET /api/v1/factfinds/{id}/net-worth`

**Description:** Calculate net worth (total assets minus total liabilities) for the factfind.

**Response:**

```json
{
  "factfindRef": { "id": "ff-456" },
  "totalAssets": {
    "amount": 725000.00,
    "currency": { "code": "GBP" }
  },
  "totalLiabilities": {
    "amount": 180000.00,
    "currency": { "code": "GBP" }
  },
  "netWorth": {
    "amount": 545000.00,
    "currency": { "code": "GBP" }
  },
  "byClient": [
    {
      "clientRef": { "id": "client-123", "name": "John Smith" },
      "assets": { "amount": 500000.00, "currency": { "code": "GBP" } },
      "liabilities": { "amount": 90000.00, "currency": { "code": "GBP" } },
      "netWorth": { "amount": 410000.00, "currency": { "code": "GBP" } }
    },
    {
      "clientRef": { "id": "client-124", "name": "Jane Smith" },
      "assets": { "amount": 225000.00, "currency": { "code": "GBP" } },
      "liabilities": { "amount": 90000.00, "currency": { "code": "GBP" } },
      "netWorth": { "amount": 135000.00, "currency": { "code": "GBP" } }
    }
  ],
  "calculatedAt": "2026-02-18T10:30:00Z"
}
```

---
## 10. Arrangements API (Type-Based Routing)

### 10.1 Overview

**Purpose:** Manage all financial arrangements held by clients including investments, pensions, mortgages, and protection policies with type-specific endpoints and operations.

**Base Path:** `/api/v1/factfinds/{factfindId}/arrangements`

**Key Features:**

The Arrangements API provides comprehensive management of client financial products through a hierarchical, type-based routing structure:

1. **Type-Based Routing** - Separate endpoints for each arrangement category (investments, pensions, mortgages, protection)
2. **Sub-Type Specialization** - Further refined endpoints for specific product types (GIA, ISA, SIPP, etc.)
3. **Unified Data Model** - Common base fields with type-specific extensions
4. **Provider Integration** - Track provider details, policy numbers, and account references
5. **Valuation History** - Complete audit trail of arrangement values over time
6. **Ownership Tracking** - Multi-client ownership with percentage allocations
7. **Sub-Resource Management** - Contributions, withdrawals, beneficiaries, and valuations

**Aggregate Root:** FactFind (arrangements are part of the fact-find lifecycle)

**Arrangement Categories:**
- **Investment Arrangements:** GIA, ISA, Investment Bonds, Investment Trusts, Platform Accounts, Offshore Bonds
- **Pension Arrangements:** Personal Pension, State Pension, Workplace Pension, SIPP, Final Salary, Drawdown, Annuity
- **Mortgage Arrangements:** Residential, Buy-to-Let, Second Charge
- **Protection Arrangements:** Personal Protection (Life, Critical Illness, Income Protection), General Insurance

**Regulatory Compliance:**
- FCA COBS 9.2 (Suitability Assessment)
- FCA COBS 13 (Periodic Reporting)
- MiFID II Article 25 (Suitability and Appropriateness)
- Pension Schemes Act 2015 (Pension Freedoms)
- Financial Services and Markets Act 2000 (Regulated Activities)
- Consumer Duty (Product Governance and Fair Value)
- IDD (Insurance Distribution Directive)
- GDPR (Data Protection for Financial Records)

### 10.2 Arrangement Types and Routing

**Hierarchical URL Structure:**

```
/api/v1/factfinds/{factfindId}/arrangements
├── /investments
│   ├── /GIA
│   ├── /ISA
│   ├── /Bonds
│   ├── /Investment-Trust
│   ├── /Platform-Account
│   └── /Offshore-Bond
├── /pensions
│   ├── /personal-pension
│   ├── /state-pension
│   ├── /workplace-pension
│   ├── /SIPP
│   ├── /final-salary
│   ├── /drawdown
│   └── /annuity
├── /mortgages
└── /protections
    ├── /personal-protection
    └── /general-insurance
```

**Common Operations (All Types):**

| Method | Endpoint Pattern | Description |
|--------|-----------------|-------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{category}/{type}` | Create new arrangement |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{category}/{type}` | List arrangements by type |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{category}/{type}/{arrangementId}` | Get specific arrangement |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/{category}/{type}/{arrangementId}` | Update arrangement |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/{category}/{type}/{arrangementId}` | Delete arrangement (soft) |

**Common Fields (All Arrangements):**

```json
{
  "id": "string",
  "href": "string",
  "arrangementType": "CodeValue",
  "arrangementCategory": "CodeValue",
  "provider": {
    "name": "string",
    "reference": "string",
    "contactDetails": {}
  },
  "policyNumber": "string",
  "accountNumber": "string",
  "startDate": "date",
  "maturityDate": "date",
  "currentValue": "Money",
  "valuationDate": "date",
  "owners": [
    {
      "clientRef": "Reference",
      "ownershipPercentage": "number"
    }
  ],
  "status": "CodeValue",
  "concurrencyId": "string",
  "createdAt": "datetime",
  "updatedAt": "datetime",
  "_links": {}
}
```

### 10.3 Investment Arrangements

**Base Path:** `/api/v1/factfinds/{factfindId}/arrangements/investments`

**Purpose:** Manage investment products including tax-wrappers (ISA, GIA), bonds, trusts, and platform-based investments.

**Common Investment Fields:**

```json
{
  "investmentType": "CodeValue",
  "platformName": "string",
  "investmentObjective": "CodeValue",
  "assetAllocation": {
    "cash": "number",
    "equities": "number",
    "bonds": "number",
    "property": "number",
    "alternatives": "number"
  },
  "performanceMetrics": {
    "annualReturn": "number",
    "totalReturn": "number",
    "benchmark": "string",
    "benchmarkReturn": "number"
  },
  "charges": {
    "amc": "number",
    "platformFee": "number",
    "adviserFee": "number",
    "totalCharges": "number"
  },
  "holdings": [
    {
      "fundName": "string",
      "isin": "string",
      "units": "number",
      "value": "Money",
      "percentage": "number"
    }
  ]
}
```

#### 10.3.1 GIA (General Investment Account)

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/investments/GIA` | Create GIA | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/investments/GIA` | List GIAs | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/investments/GIA/{arrangementId}` | Get GIA details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/investments/GIA/{arrangementId}` | Update GIA | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/investments/GIA/{arrangementId}` | Delete GIA | `arrangements:write` |

**Create GIA Request:**

```json
{
  "arrangementType": {
    "code": "GIA",
    "display": "General Investment Account"
  },
  "provider": {
    "name": "Vanguard UK",
    "reference": "VANG-UK-001",
    "contactDetails": {
      "phone": "0800 587 0460",
      "email": "clientservices@vanguard.co.uk",
      "website": "https://www.vanguard.co.uk"
    }
  },
  "accountNumber": "GB12345678",
  "startDate": "2020-03-15",
  "currentValue": {
    "amount": 45000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "valuationDate": "2026-02-18",
  "owners": [
    {
      "clientRef": { "id": "client-123" },
      "ownershipPercentage": 100.0
    }
  ],
  "status": {
    "code": "ACTIVE",
    "display": "Active"
  },
  "investmentObjective": {
    "code": "GROWTH",
    "display": "Capital Growth"
  },
  "assetAllocation": {
    "cash": 5.0,
    "equities": 70.0,
    "bonds": 20.0,
    "property": 5.0,
    "alternatives": 0.0
  },
  "charges": {
    "amc": 0.15,
    "platformFee": 0.25,
    "adviserFee": 0.50,
    "totalCharges": 0.90
  },
  "taxPosition": {
    "capitalGainsUsed": {
      "amount": 3000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "dividendTaxPaid": {
      "amount": 450.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "taxYear": "2025/26"
  },
  "regularContribution": {
    "amount": {
      "amount": 500.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "frequency": {
      "code": "MONTHLY",
      "display": "Monthly"
    },
    "startDate": "2020-04-01",
    "endDate": null
  }
}
```

**Response (201 Created):**

```json
{
  "id": "arr-gia-001",
  "href": "/api/v1/factfinds/ff-456/arrangements/investments/GIA/arr-gia-001",
  "arrangementType": {
    "code": "GIA",
    "display": "General Investment Account"
  },
  "arrangementCategory": {
    "code": "INVESTMENT",
    "display": "Investment"
  },
  "provider": {
    "name": "Vanguard UK",
    "reference": "VANG-UK-001",
    "contactDetails": {
      "phone": "0800 587 0460",
      "email": "clientservices@vanguard.co.uk",
      "website": "https://www.vanguard.co.uk"
    }
  },
  "accountNumber": "GB12345678",
  "startDate": "2020-03-15",
  "currentValue": {
    "amount": 45000.00,
    "currency": { "code": "GBP", "symbol": "£", "display": "British Pound" }
  },
  "valuationDate": "2026-02-18",
  "owners": [
    {
      "clientRef": {
        "id": "client-123",
        "fullName": "John Smith",
        "href": "/api/v1/factfinds/ff-456/clients/client-123"
      },
      "ownershipPercentage": 100.0
    }
  ],
  "status": {
    "code": "ACTIVE",
    "display": "Active"
  },
  "investmentObjective": {
    "code": "GROWTH",
    "display": "Capital Growth"
  },
  "assetAllocation": {
    "cash": 5.0,
    "equities": 70.0,
    "bonds": 20.0,
    "property": 5.0,
    "alternatives": 0.0
  },
  "performanceMetrics": {
    "annualReturn": 7.2,
    "totalReturn": 28.5,
    "benchmark": "FTSE All Share",
    "benchmarkReturn": 6.8
  },
  "charges": {
    "amc": 0.15,
    "platformFee": 0.25,
    "adviserFee": 0.50,
    "totalCharges": 0.90
  },
  "taxPosition": {
    "capitalGainsUsed": {
      "amount": 3000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "dividendTaxPaid": {
      "amount": 450.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "taxYear": "2025/26"
  },
  "regularContribution": {
    "amount": {
      "amount": 500.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "frequency": {
      "code": "MONTHLY",
      "display": "Monthly"
    },
    "startDate": "2020-04-01",
    "endDate": null
  },
  "concurrencyId": "e7b3c1a0-2f45-4e8b-9d3c-1a2b3c4d5e6f",
  "createdAt": "2026-02-18T10:30:00Z",
  "updatedAt": "2026-02-18T10:30:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/investments/GIA/arr-gia-001" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" },
    "owner": { "href": "/api/v1/factfinds/ff-456/clients/client-123" },
    "contributions": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-gia-001/contributions" },
    "withdrawals": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-gia-001/withdrawals" },
    "valuations": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-gia-001/valuations" }
  }
}
```

**Validation Rules:**
- `arrangementType.code` - Required, must be "GIA"
- `provider.name` - Required
- `accountNumber` - Required, unique per provider
- `startDate` - Required, cannot be in future
- `currentValue` - Required, must be positive
- `valuationDate` - Required, cannot be more than 12 months old
- `owners` - Required, at least one owner, percentages must sum to 100
- `assetAllocation` - If provided, percentages must sum to 100

**Business Rules:**
- Capital gains tracking against annual allowance (£3,000 for 2025/26)
- Dividend tax calculation based on dividend allowance
- Regular contribution tracking for cash flow planning
- Performance comparison against benchmark indices

#### 10.3.2 ISA (Individual Savings Account)

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/investments/ISA` | Create ISA | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/investments/ISA` | List ISAs | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/investments/ISA/{arrangementId}` | Get ISA details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/investments/ISA/{arrangementId}` | Update ISA | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/investments/ISA/{arrangementId}` | Delete ISA | `arrangements:write` |

**Create ISA Request:**

```json
{
  "arrangementType": {
    "code": "ISA",
    "display": "Individual Savings Account"
  },
  "isaType": {
    "code": "STOCKS_SHARES",
    "display": "Stocks & Shares ISA"
  },
  "provider": {
    "name": "Hargreaves Lansdown",
    "reference": "HL-UK-001",
    "contactDetails": {
      "phone": "0117 900 9000",
      "email": "helpdesk@hl.co.uk",
      "website": "https://www.hl.co.uk"
    }
  },
  "accountNumber": "HL-ISA-987654",
  "startDate": "2018-04-06",
  "currentValue": {
    "amount": 75000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "valuationDate": "2026-02-18",
  "owners": [
    {
      "clientRef": { "id": "client-123" },
      "ownershipPercentage": 100.0
    }
  ],
  "status": {
    "code": "ACTIVE",
    "display": "Active"
  },
  "investmentObjective": {
    "code": "BALANCED",
    "display": "Balanced Growth"
  },
  "assetAllocation": {
    "cash": 10.0,
    "equities": 60.0,
    "bonds": 25.0,
    "property": 5.0,
    "alternatives": 0.0
  },
  "charges": {
    "amc": 0.18,
    "platformFee": 0.45,
    "adviserFee": 0.00,
    "totalCharges": 0.63
  },
  "isaAllowance": {
    "taxYear": "2025/26",
    "annualAllowance": {
      "amount": 20000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "usedThisYear": {
      "amount": 15000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "remainingAllowance": {
      "amount": 5000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "previousYearTransfers": [
    {
      "fromProvider": "AJ Bell",
      "transferDate": "2023-09-15",
      "transferValue": {
        "amount": 45000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    }
  ],
  "regularContribution": {
    "amount": {
      "amount": 1250.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "frequency": {
      "code": "MONTHLY",
      "display": "Monthly"
    },
    "startDate": "2025-04-06",
    "endDate": null
  }
}
```

**Response (201 Created):**

```json
{
  "id": "arr-isa-002",
  "href": "/api/v1/factfinds/ff-456/arrangements/investments/ISA/arr-isa-002",
  "arrangementType": {
    "code": "ISA",
    "display": "Individual Savings Account"
  },
  "arrangementCategory": {
    "code": "INVESTMENT",
    "display": "Investment"
  },
  "isaType": {
    "code": "STOCKS_SHARES",
    "display": "Stocks & Shares ISA"
  },
  "provider": {
    "name": "Hargreaves Lansdown",
    "reference": "HL-UK-001",
    "contactDetails": {
      "phone": "0117 900 9000",
      "email": "helpdesk@hl.co.uk",
      "website": "https://www.hl.co.uk"
    }
  },
  "accountNumber": "HL-ISA-987654",
  "startDate": "2018-04-06",
  "currentValue": {
    "amount": 75000.00,
    "currency": { "code": "GBP", "symbol": "£", "display": "British Pound" }
  },
  "valuationDate": "2026-02-18",
  "owners": [
    {
      "clientRef": {
        "id": "client-123",
        "fullName": "John Smith",
        "href": "/api/v1/factfinds/ff-456/clients/client-123"
      },
      "ownershipPercentage": 100.0
    }
  ],
  "status": {
    "code": "ACTIVE",
    "display": "Active"
  },
  "investmentObjective": {
    "code": "BALANCED",
    "display": "Balanced Growth"
  },
  "assetAllocation": {
    "cash": 10.0,
    "equities": 60.0,
    "bonds": 25.0,
    "property": 5.0,
    "alternatives": 0.0
  },
  "performanceMetrics": {
    "annualReturn": 6.8,
    "totalReturn": 45.3,
    "benchmark": "FTSE 100",
    "benchmarkReturn": 6.2
  },
  "charges": {
    "amc": 0.18,
    "platformFee": 0.45,
    "adviserFee": 0.00,
    "totalCharges": 0.63
  },
  "isaAllowance": {
    "taxYear": "2025/26",
    "annualAllowance": {
      "amount": 20000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "usedThisYear": {
      "amount": 15000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "remainingAllowance": {
      "amount": 5000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "projectedYearEnd": {
      "amount": 20000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "previousYearTransfers": [
    {
      "fromProvider": "AJ Bell",
      "transferDate": "2023-09-15",
      "transferValue": {
        "amount": 45000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    }
  ],
  "regularContribution": {
    "amount": {
      "amount": 1250.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "frequency": {
      "code": "MONTHLY",
      "display": "Monthly"
    },
    "startDate": "2025-04-06",
    "endDate": null
  },
  "taxBenefits": {
    "taxSavedPerYear": {
      "amount": 1200.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "lifetimeTaxSaved": {
      "amount": 9600.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "concurrencyId": "f8c4d2b1-3g56-5f9c-0e4d-2b3c4d5e6f7g",
  "createdAt": "2026-02-18T10:35:00Z",
  "updatedAt": "2026-02-18T10:35:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/investments/ISA/arr-isa-002" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" },
    "owner": { "href": "/api/v1/factfinds/ff-456/clients/client-123" },
    "contributions": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-isa-002/contributions" },
    "withdrawals": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-isa-002/withdrawals" },
    "valuations": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-isa-002/valuations" }
  }
}
```

**Validation Rules:**
- `arrangementType.code` - Required, must be "ISA"
- `isaType` - Required, one of: STOCKS_SHARES, CASH, LIFETIME, INNOVATIVE_FINANCE
- `provider.name` - Required
- `accountNumber` - Required
- `startDate` - Required, must be on or after April 6 (ISA year start)
- `currentValue` - Required, must be positive
- `isaAllowance.usedThisYear` - Cannot exceed annual allowance
- `owners` - Required, must be single owner (ISAs cannot be joint)

**Business Rules:**
- Annual ISA allowance tracking (£20,000 for 2025/26)
- Only one ISA of each type per tax year
- Automatic calculation of remaining allowance
- Tax benefits calculation based on income tax band
- Lifetime ISA bonus tracking (25% government bonus up to £1,000/year)
- Transfer tracking maintains tax-free status

#### 10.3.3 Investment Bonds

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/investments/Bonds` | Create Investment Bond | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/investments/Bonds` | List Investment Bonds | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/investments/Bonds/{arrangementId}` | Get Bond details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/investments/Bonds/{arrangementId}` | Update Bond | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/investments/Bonds/{arrangementId}` | Delete Bond | `arrangements:write` |

**Bond-Specific Fields:**

```json
{
  "bondType": {
    "code": "ONSHORE",
    "display": "Onshore Investment Bond"
  },
  "segments": 101,
  "segmentsRemaining": 95,
  "topSlicing": {
    "years": 8,
    "annualGain": {
      "amount": 1875.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "surrenderValue": {
    "amount": 85000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "initialInvestment": {
    "amount": 75000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "cumulativeWithdrawals": {
    "amount": 4500.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "annualWithdrawalAllowance": {
    "amount": 3750.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "unused5PercentAllowance": {
    "amount": 18750.00,
    "currency": { "code": "GBP", "symbol": "£" }
  }
}
```

**Validation Rules:**
- `bondType` - Required, one of: ONSHORE, OFFSHORE
- `segments` - Required for UK bonds, must be positive integer
- `initialInvestment` - Required
- 5% withdrawal allowance tracking
- Top-slicing relief calculations

#### 10.3.4 Investment Trusts

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/investments/Investment-Trust` | Create Investment Trust | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/investments/Investment-Trust` | List Investment Trusts | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/investments/Investment-Trust/{arrangementId}` | Get Trust details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/investments/Investment-Trust/{arrangementId}` | Update Trust | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/investments/Investment-Trust/{arrangementId}` | Delete Trust | `arrangements:write` |

**Trust-Specific Fields:**

```json
{
  "trustName": "Scottish Mortgage Investment Trust",
  "ticker": "SMT.L",
  "isin": "GB0009349011",
  "shares": 5000,
  "averagePurchasePrice": {
    "amount": 8.50,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "currentSharePrice": {
    "amount": 9.25,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "premiumDiscount": -2.3,
  "yieldPercent": 0.8,
  "dividendPaymentSchedule": "Quarterly"
}
```

#### 10.3.5 Platform Accounts

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/investments/Platform-Account` | Create Platform Account | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/investments/Platform-Account` | List Platform Accounts | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/investments/Platform-Account/{arrangementId}` | Get Account details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/investments/Platform-Account/{arrangementId}` | Update Account | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/investments/Platform-Account/{arrangementId}` | Delete Account | `arrangements:write` |

**Platform-Specific Fields:**

```json
{
  "platformName": "Interactive Investor",
  "platformType": {
    "code": "DISCRETIONARY",
    "display": "Discretionary Managed"
  },
  "modelPortfolio": "Aggressive Growth Portfolio",
  "rebalancingFrequency": {
    "code": "QUARTERLY",
    "display": "Quarterly"
  },
  "lastRebalance": "2026-01-15"
}
```

#### 10.3.6 Offshore Bonds

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/investments/Offshore-Bond` | Create Offshore Bond | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/investments/Offshore-Bond` | List Offshore Bonds | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/investments/Offshore-Bond/{arrangementId}` | Get Offshore Bond details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/investments/Offshore-Bond/{arrangementId}` | Update Offshore Bond | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/investments/Offshore-Bond/{arrangementId}` | Delete Offshore Bond | `arrangements:write` |

**Offshore Bond-Specific Fields:**

```json
{
  "bondJurisdiction": {
    "code": "IOM",
    "display": "Isle of Man"
  },
  "segments": 0,
  "foreignTaxCredit": {
    "amount": 0.00,
    "currency": { "code": "EUR", "symbol": "€" }
  },
  "currencyHedging": true,
  "reportableForUKTax": true,
  "topSlicingAvailable": true
}
```

### 10.4 Pension Arrangements

**Base Path:** `/api/v1/factfinds/{factfindId}/arrangements/pensions`

**Purpose:** Manage all pension arrangements including workplace, personal, SIPPs, defined benefit schemes, drawdown, and annuities.

**Common Pension Fields:**

```json
{
  "pensionType": "CodeValue",
  "employerContribution": "Money",
  "employeeContribution": "Money",
  "taxRelief": {
    "method": "CodeValue",
    "amount": "Money"
  },
  "crystallisedAmount": "Money",
  "uncrystallisedAmount": "Money",
  "protectedRights": "Money",
  "pensionCommencement": "date",
  "normalRetirementAge": "number",
  "projectedFund": {
    "atAge55": "Money",
    "atAge60": "Money",
    "atAge65": "Money",
    "atSPA": "Money"
  },
  "annualAllowance": {
    "standardAllowance": "Money",
    "usedThisYear": "Money",
    "carryForward": [
      {
        "taxYear": "string",
        "available": "Money"
      }
    ]
  },
  "lifetimeAllowance": {
    "standard": "Money",
    "used": "Money",
    "remaining": "Money",
    "hasProtection": "boolean",
    "protectionType": "CodeValue"
  }
}
```

#### 10.4.1 Personal Pension

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/pensions/personal-pension` | Create Personal Pension | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/personal-pension` | List Personal Pensions | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/personal-pension/{arrangementId}` | Get Personal Pension | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/pensions/personal-pension/{arrangementId}` | Update Personal Pension | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/pensions/personal-pension/{arrangementId}` | Delete Personal Pension | `arrangements:write` |

**Create Personal Pension Request:**

```json
{
  "arrangementType": {
    "code": "PERSONAL_PENSION",
    "display": "Personal Pension"
  },
  "provider": {
    "name": "Standard Life",
    "reference": "SL-UK-001",
    "contactDetails": {
      "phone": "0800 333 353",
      "email": "customer.services@standardlife.com"
    }
  },
  "policyNumber": "PP-12345678",
  "startDate": "2015-06-01",
  "currentValue": {
    "amount": 125000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "valuationDate": "2026-02-18",
  "owners": [
    {
      "clientRef": { "id": "client-123" },
      "ownershipPercentage": 100.0
    }
  ],
  "status": {
    "code": "ACTIVE",
    "display": "Active"
  },
  "uncrystallisedAmount": {
    "amount": 125000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "crystallisedAmount": {
    "amount": 0.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "regularContribution": {
    "grossAmount": {
      "amount": 625.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "netAmount": {
      "amount": 500.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "taxRelief": {
      "amount": 125.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "frequency": {
      "code": "MONTHLY",
      "display": "Monthly"
    }
  },
  "employeeContribution": {
    "amount": 500.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "normalRetirementAge": 67,
  "selectedRetirementAge": 60,
  "projectedFund": {
    "atAge55": {
      "amount": 142000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "atAge60": {
      "amount": 175000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "atAge65": {
      "amount": 215000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "atAge67": {
      "amount": 235000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "investmentStrategy": {
    "riskProfile": {
      "code": "MODERATE",
      "display": "Moderate Risk"
    },
    "lifestyling": true,
    "lifestylingStartAge": 55
  }
}
```

**Response (201 Created):**

```json
{
  "id": "arr-pp-003",
  "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003",
  "arrangementType": {
    "code": "PERSONAL_PENSION",
    "display": "Personal Pension"
  },
  "arrangementCategory": {
    "code": "PENSION",
    "display": "Pension"
  },
  "provider": {
    "name": "Standard Life",
    "reference": "SL-UK-001",
    "contactDetails": {
      "phone": "0800 333 353",
      "email": "customer.services@standardlife.com"
    }
  },
  "policyNumber": "PP-12345678",
  "startDate": "2015-06-01",
  "currentValue": {
    "amount": 125000.00,
    "currency": { "code": "GBP", "symbol": "£", "display": "British Pound" }
  },
  "valuationDate": "2026-02-18",
  "owners": [
    {
      "clientRef": {
        "id": "client-123",
        "fullName": "John Smith",
        "href": "/api/v1/factfinds/ff-456/clients/client-123"
      },
      "ownershipPercentage": 100.0
    }
  ],
  "status": {
    "code": "ACTIVE",
    "display": "Active"
  },
  "uncrystallisedAmount": {
    "amount": 125000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "crystallisedAmount": {
    "amount": 0.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "taxFreeCashAvailable": {
    "amount": 31250.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "regularContribution": {
    "grossAmount": {
      "amount": 625.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "netAmount": {
      "amount": 500.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "taxRelief": {
      "amount": 125.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "frequency": {
      "code": "MONTHLY",
      "display": "Monthly"
    }
  },
  "employeeContribution": {
    "amount": 500.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "annualContribution": {
    "amount": 7500.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "normalRetirementAge": 67,
  "selectedRetirementAge": 60,
  "yearsToRetirement": 15,
  "projectedFund": {
    "atAge55": {
      "amount": 142000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "atAge60": {
      "amount": 175000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "atAge65": {
      "amount": 215000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "atAge67": {
      "amount": 235000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "investmentStrategy": {
    "riskProfile": {
      "code": "MODERATE",
      "display": "Moderate Risk"
    },
    "lifestyling": true,
    "lifestylingStartAge": 55
  },
  "annualAllowance": {
    "taxYear": "2025/26",
    "standardAllowance": {
      "amount": 60000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "usedThisYear": {
      "amount": 7500.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "remaining": {
      "amount": 52500.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "concurrencyId": "g9d5e3c2-4h67-6g0d-1f5e-3c4d5e6f7g8h",
  "createdAt": "2026-02-18T10:40:00Z",
  "updatedAt": "2026-02-18T10:40:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" },
    "owner": { "href": "/api/v1/factfinds/ff-456/clients/client-123" },
    "contributions": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/contributions" },
    "beneficiaries": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/beneficiaries" },
    "valuations": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/valuations" }
  }
}
```

**Validation Rules:**
- `arrangementType.code` - Required, must be "PERSONAL_PENSION"
- `provider.name` - Required
- `policyNumber` - Required
- `normalRetirementAge` - Required, typically 65-68
- Annual allowance tracking (£60,000 for 2025/26)
- Tapered annual allowance for high earners
- Tax-free cash capped at 25% of fund value

#### 10.4.2 State Pension

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/pensions/state-pension` | Create State Pension | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/state-pension` | List State Pensions | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/state-pension/{arrangementId}` | Get State Pension | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/pensions/state-pension/{arrangementId}` | Update State Pension | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/pensions/state-pension/{arrangementId}` | Delete State Pension | `arrangements:write` |

**State Pension-Specific Fields:**

```json
{
  "arrangementType": {
    "code": "STATE_PENSION",
    "display": "State Pension"
  },
  "nationalInsuranceNumber": "AB123456C",
  "qualifyingYears": 35,
  "yearsToStatePensionAge": 12,
  "statePensionAge": 67,
  "forecastAnnualAmount": {
    "amount": 11502.40,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "forecastWeeklyAmount": {
    "amount": 221.20,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "maxStatePension": {
    "amount": 11502.40,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "contracted Out": false,
  "deferralOptions": {
    "canDefer": true,
    "deferralIncrease": 5.8
  }
}
```

#### 10.4.3 Workplace Pension

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/pensions/workplace-pension` | Create Workplace Pension | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/workplace-pension` | List Workplace Pensions | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/workplace-pension/{arrangementId}` | Get Workplace Pension | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/pensions/workplace-pension/{arrangementId}` | Update Workplace Pension | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/pensions/workplace-pension/{arrangementId}` | Delete Workplace Pension | `arrangements:write` |

**Workplace Pension-Specific Fields:**

```json
{
  "employerName": "Tech Solutions Ltd",
  "employerRef": { "id": "employer-456" },
  "employerContribution": {
    "percentage": 5.0,
    "amount": {
      "amount": 250.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "employeeContribution": {
    "percentage": 5.0,
    "amount": {
      "amount": 250.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "salaryForPension": {
    "amount": 60000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "salaryExchangeApplied": true,
  "autoEnrollmentDate": "2020-01-15",
  "optedOut": false
}
```

#### 10.4.4 SIPP (Self-Invested Personal Pension)

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/pensions/SIPP` | Create SIPP | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/SIPP` | List SIPPs | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/SIPP/{arrangementId}` | Get SIPP | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/pensions/SIPP/{arrangementId}` | Update SIPP | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/pensions/SIPP/{arrangementId}` | Delete SIPP | `arrangements:write` |

**SIPP-Specific Fields:**

```json
{
  "allowsCommercialProperty": true,
  "holdsCommercialProperty": false,
  "allowsDirectEquities": true,
  "directEquityHoldings": 15,
  "sippCharges": {
    "setupFee": {
      "amount": 0.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "annualFee": {
      "amount": 300.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "dealingCharges": {
      "amount": 9.95,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "investmentFlexibility": {
    "code": "HIGH",
    "display": "High - Full investment control"
  }
}
```

#### 10.4.5 Final Salary (Defined Benefit)

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/pensions/final-salary` | Create Final Salary | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/final-salary` | List Final Salary Pensions | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/final-salary/{arrangementId}` | Get Final Salary | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/pensions/final-salary/{arrangementId}` | Update Final Salary | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/pensions/final-salary/{arrangementId}` | Delete Final Salary | `arrangements:write` |

**Create Final Salary Request:**

```json
{
  "arrangementType": {
    "code": "FINAL_SALARY",
    "display": "Final Salary / Defined Benefit"
  },
  "provider": {
    "name": "NHS Pension Scheme",
    "reference": "NHS-PS-001"
  },
  "policyNumber": "NHS-DB-987654",
  "startDate": "1995-09-01",
  "owners": [
    {
      "clientRef": { "id": "client-123" },
      "ownershipPercentage": 100.0
    }
  ],
  "status": {
    "code": "ACTIVE",
    "display": "Active - In Service"
  },
  "schemeDetails": {
    "schemeName": "NHS Pension Scheme (1995 Section)",
    "schemeType": {
      "code": "PUBLIC_SECTOR",
      "display": "Public Sector DB"
    },
    "accrualRate": "1/80th",
    "normalRetirementAge": 60,
    "earlyRetirementAge": 55,
    "employerName": "Royal London Hospital Trust"
  },
  "serviceDetails": {
    "totalService": 28.5,
    "pensionableService": 28.5,
    "additionalPurchasedYears": 0,
    "projectedServiceAtRetirement": 35.0
  },
  "salaryDetails": {
    "currentPensionableSalary": {
      "amount": 65000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "finalSalary": {
      "amount": 65000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "projectedFinalSalary": {
      "amount": 72000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "benefitDetails": {
    "guaranteedAnnualPension": {
      "amount": 23100.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "taxFreeLumpSum": {
      "amount": 69300.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "spousePension": {
      "percentage": 50.0,
      "amount": {
        "amount": 11550.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    },
    "escalationRate": {
      "code": "CPI",
      "display": "CPI (Consumer Price Index)"
    },
    "escalationPercentage": 2.5
  },
  "revaluationMethod": {
    "code": "CAREER_AVERAGE",
    "display": "Career Average Revalued Earnings (CARE)"
  },
  "transferValue": {
    "cetv": {
      "amount": 950000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "cetvDate": "2026-01-15",
    "cetvExpiry": "2026-04-15",
    "transferAdviceRequired": true
  }
}
```

**Response (201 Created):**

```json
{
  "id": "arr-db-004",
  "href": "/api/v1/factfinds/ff-456/arrangements/pensions/final-salary/arr-db-004",
  "arrangementType": {
    "code": "FINAL_SALARY",
    "display": "Final Salary / Defined Benefit"
  },
  "arrangementCategory": {
    "code": "PENSION",
    "display": "Pension"
  },
  "provider": {
    "name": "NHS Pension Scheme",
    "reference": "NHS-PS-001"
  },
  "policyNumber": "NHS-DB-987654",
  "startDate": "1995-09-01",
  "currentValue": {
    "amount": 950000.00,
    "currency": { "code": "GBP", "symbol": "£", "display": "British Pound" }
  },
  "valuationDate": "2026-01-15",
  "valuationType": {
    "code": "CETV",
    "display": "Cash Equivalent Transfer Value"
  },
  "owners": [
    {
      "clientRef": {
        "id": "client-123",
        "fullName": "John Smith",
        "href": "/api/v1/factfinds/ff-456/clients/client-123"
      },
      "ownershipPercentage": 100.0
    }
  ],
  "status": {
    "code": "ACTIVE",
    "display": "Active - In Service"
  },
  "schemeDetails": {
    "schemeName": "NHS Pension Scheme (1995 Section)",
    "schemeType": {
      "code": "PUBLIC_SECTOR",
      "display": "Public Sector DB"
    },
    "accrualRate": "1/80th",
    "normalRetirementAge": 60,
    "earlyRetirementAge": 55,
    "employerName": "Royal London Hospital Trust"
  },
  "serviceDetails": {
    "totalService": 28.5,
    "pensionableService": 28.5,
    "additionalPurchasedYears": 0,
    "projectedServiceAtRetirement": 35.0,
    "yearsToNormalRetirement": 6.5
  },
  "salaryDetails": {
    "currentPensionableSalary": {
      "amount": 65000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "finalSalary": {
      "amount": 65000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "projectedFinalSalary": {
      "amount": 72000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "benefitDetails": {
    "guaranteedAnnualPension": {
      "amount": 23100.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "taxFreeLumpSum": {
      "amount": 69300.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "spousePension": {
      "percentage": 50.0,
      "amount": {
        "amount": 11550.00,
        "currency": { "code": "GBP", "symbol": "£" }
      }
    },
    "escalationRate": {
      "code": "CPI",
      "display": "CPI (Consumer Price Index)"
    },
    "escalationPercentage": 2.5,
    "lifetimeValue": {
      "amount": 462000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "revaluationMethod": {
    "code": "CAREER_AVERAGE",
    "display": "Career Average Revalued Earnings (CARE)"
  },
  "transferValue": {
    "cetv": {
      "amount": 950000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "cetvDate": "2026-01-15",
    "cetvExpiry": "2026-04-15",
    "cetvMultiple": 41.1,
    "transferAdviceRequired": true,
    "adviceThreshold": {
      "amount": 30000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "riskWarnings": [
    "Transfer value exceeds £30,000 - FCA regulated advice mandatory",
    "Loss of guaranteed income for life",
    "Loss of spouse's pension benefits",
    "Loss of inflation protection (CPI escalation)",
    "Scheme funded by employer - reduced counterparty risk"
  ],
  "concurrencyId": "h0e6f4d3-5i78-7h1e-2g6f-4d5e6f7g8h9i",
  "createdAt": "2026-02-18T10:45:00Z",
  "updatedAt": "2026-02-18T10:45:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/pensions/final-salary/arr-db-004" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" },
    "owner": { "href": "/api/v1/factfinds/ff-456/clients/client-123" },
    "beneficiaries": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-db-004/beneficiaries" },
    "valuations": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-db-004/valuations" }
  }
}
```

**Validation Rules:**
- `arrangementType.code` - Required, must be "FINAL_SALARY"
- `schemeDetails.schemeName` - Required
- `guaranteedAnnualPension` - Required
- Transfer advice mandatory if CETV > £30,000 (FCA requirement)
- Spouse's pension typically 50% of member's pension
- Escalation rate required (CPI, RPI, Fixed, None)

**Business Rules:**
- CETV multiple calculated as CETV / Annual Pension
- Typical DB multipliers: 20-25x for good schemes, 30-40x+ for transfer incentives
- Transfer advice required by FCA if CETV exceeds £30,000
- Early retirement reductions typically 3-5% per year before NRA
- Protected rights tracking for pre-1997 contracting out
- Pension input amount tracking for annual allowance purposes

#### 10.4.6 Pension Drawdown

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/pensions/drawdown` | Create Drawdown | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/drawdown` | List Drawdowns | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/drawdown/{arrangementId}` | Get Drawdown | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/pensions/drawdown/{arrangementId}` | Update Drawdown | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/pensions/drawdown/{arrangementId}` | Delete Drawdown | `arrangements:write` |

**Drawdown-Specific Fields:**

```json
{
  "crystallisedAmount": {
    "amount": 180000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "uncrystallisedAmount": {
    "amount": 0.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "taxFreeCashTaken": {
    "amount": 60000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "drawdownIncome": {
    "annualAmount": {
      "amount": 12000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "frequency": {
      "code": "MONTHLY",
      "display": "Monthly"
    },
    "nextReviewDate": "2026-06-01"
  },
  "sustainabilityAnalysis": {
    "projectedDepletionAge": 88,
    "sustainableWithdrawalRate": 4.2,
    "currentWithdrawalRate": 6.7
  },
  "moneyPurchaseAnnualAllowance": {
    "triggered": true,
    "allowance": {
      "amount": 10000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  }
}
```

#### 10.4.7 Annuity

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/pensions/annuity` | Create Annuity | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/annuity` | List Annuities | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/pensions/annuity/{arrangementId}` | Get Annuity | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/pensions/annuity/{arrangementId}` | Update Annuity | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/pensions/annuity/{arrangementId}` | Delete Annuity | `arrangements:write` |

**Annuity-Specific Fields:**

```json
{
  "annuityType": {
    "code": "LIFETIME",
    "display": "Lifetime Annuity"
  },
  "guaranteedAnnualIncome": {
    "amount": 8500.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "paymentFrequency": {
    "code": "MONTHLY",
    "display": "Monthly"
  },
  "escalation": {
    "type": {
      "code": "RPI",
      "display": "RPI Linked"
    },
    "rate": 3.0,
    "cappedAt": 5.0
  },
  "guaranteePeriod": {
    "years": 5,
    "endsOn": "2030-03-15"
  },
  "spouseBenefit": {
    "percentage": 66.67,
    "amount": {
      "amount": 5666.95,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "overlayBenefits": {
    "hasValueProtection": true,
    "hasGuaranteePeriod": true
  },
  "purchaseDetails": {
    "fundUsed": {
      "amount": 180000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "purchaseDate": "2025-03-15",
    "annuityRate": 4.72
  }
}
```

### 10.5 Mortgage Arrangements

**Base Path:** `/api/v1/factfinds/{factfindId}/arrangements/mortgages`

**Purpose:** Manage mortgage and secured lending arrangements linked to property assets.

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/mortgages` | Create Mortgage | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/mortgages` | List Mortgages | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/mortgages/{arrangementId}` | Get Mortgage details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/mortgages/{arrangementId}` | Update Mortgage | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/mortgages/{arrangementId}` | Delete Mortgage | `arrangements:write` |

**Create Mortgage Request:**

```json
{
  "arrangementType": {
    "code": "MORTGAGE",
    "display": "Mortgage"
  },
  "mortgageType": {
    "code": "RESIDENTIAL",
    "display": "Residential Mortgage"
  },
  "provider": {
    "name": "Nationwide Building Society",
    "reference": "NBS-UK-001",
    "contactDetails": {
      "phone": "0800 302 010",
      "email": "mortgages@nationwide.co.uk"
    }
  },
  "accountNumber": "NBS-MORT-123456",
  "startDate": "2018-06-15",
  "maturityDate": "2043-06-15",
  "owners": [
    {
      "clientRef": { "id": "client-123" },
      "ownershipPercentage": 50.0
    },
    {
      "clientRef": { "id": "client-124" },
      "ownershipPercentage": 50.0
    }
  ],
  "status": {
    "code": "ACTIVE",
    "display": "Active"
  },
  "propertyRef": {
    "id": "asset-prop-001",
    "href": "/api/v1/factfinds/ff-456/assets/property/asset-prop-001"
  },
  "loanDetails": {
    "originalAmount": {
      "amount": 300000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "currentBalance": {
      "amount": 245000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "balanceDate": "2026-02-18"
  },
  "repaymentDetails": {
    "repaymentType": {
      "code": "REPAYMENT",
      "display": "Capital & Interest Repayment"
    },
    "monthlyPayment": {
      "amount": 1450.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "termRemaining": {
      "years": 17,
      "months": 4
    }
  },
  "interestDetails": {
    "currentRate": 4.25,
    "rateType": {
      "code": "FIXED",
      "display": "Fixed Rate"
    },
    "fixedUntil": "2028-06-30",
    "revertRate": 7.99,
    "initialRate": 2.89,
    "productType": "5 Year Fixed Rate"
  },
  "ltvAnalysis": {
    "propertyValue": {
      "amount": 425000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "currentLTV": 57.65,
    "ltvAtPurchase": 70.59,
    "equity": {
      "amount": 180000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "remortgageOptions": {
    "earlyRepaymentCharge": {
      "amount": 9800.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "ercExpiryDate": "2028-06-30",
    "portability": true
  }
}
```

**Response (201 Created):**

```json
{
  "id": "arr-mort-005",
  "href": "/api/v1/factfinds/ff-456/arrangements/mortgages/arr-mort-005",
  "arrangementType": {
    "code": "MORTGAGE",
    "display": "Mortgage"
  },
  "arrangementCategory": {
    "code": "MORTGAGE",
    "display": "Mortgage"
  },
  "mortgageType": {
    "code": "RESIDENTIAL",
    "display": "Residential Mortgage"
  },
  "provider": {
    "name": "Nationwide Building Society",
    "reference": "NBS-UK-001",
    "contactDetails": {
      "phone": "0800 302 010",
      "email": "mortgages@nationwide.co.uk"
    }
  },
  "accountNumber": "NBS-MORT-123456",
  "startDate": "2018-06-15",
  "maturityDate": "2043-06-15",
  "currentValue": {
    "amount": -245000.00,
    "currency": { "code": "GBP", "symbol": "£", "display": "British Pound" }
  },
  "valuationDate": "2026-02-18",
  "owners": [
    {
      "clientRef": {
        "id": "client-123",
        "fullName": "John Smith",
        "href": "/api/v1/factfinds/ff-456/clients/client-123"
      },
      "ownershipPercentage": 50.0
    },
    {
      "clientRef": {
        "id": "client-124",
        "fullName": "Jane Smith",
        "href": "/api/v1/factfinds/ff-456/clients/client-124"
      },
      "ownershipPercentage": 50.0
    }
  ],
  "status": {
    "code": "ACTIVE",
    "display": "Active"
  },
  "propertyRef": {
    "id": "asset-prop-001",
    "address": "123 High Street, London",
    "href": "/api/v1/factfinds/ff-456/assets/property/asset-prop-001"
  },
  "loanDetails": {
    "originalAmount": {
      "amount": 300000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "currentBalance": {
      "amount": 245000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "balanceDate": "2026-02-18",
    "principalRepaid": {
      "amount": 55000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "repaymentDetails": {
    "repaymentType": {
      "code": "REPAYMENT",
      "display": "Capital & Interest Repayment"
    },
    "monthlyPayment": {
      "amount": 1450.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "annualPayment": {
      "amount": 17400.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "termRemaining": {
      "years": 17,
      "months": 4
    },
    "projectedPayoffDate": "2043-06-15"
  },
  "interestDetails": {
    "currentRate": 4.25,
    "rateType": {
      "code": "FIXED",
      "display": "Fixed Rate"
    },
    "fixedUntil": "2028-06-30",
    "monthsRemainingOnDeal": 28,
    "revertRate": 7.99,
    "initialRate": 2.89,
    "productType": "5 Year Fixed Rate"
  },
  "ltvAnalysis": {
    "propertyValue": {
      "amount": 425000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "currentLTV": 57.65,
    "ltvAtPurchase": 70.59,
    "equity": {
      "amount": 180000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "equityPercentage": 42.35
  },
  "affordabilityCheck": {
    "debtToIncomeRatio": 2.45,
    "stressTested": true,
    "stressTestRate": 7.25,
    "passedStressTest": true
  },
  "remortgageOptions": {
    "earlyRepaymentCharge": {
      "amount": 9800.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "ercPercentage": 4.0,
    "ercExpiryDate": "2028-06-30",
    "portability": true,
    "remortgageRecommended": false
  },
  "concurrencyId": "i1f7g5e4-6j89-8i2f-3h7g-5e6f7g8h9i0j",
  "createdAt": "2026-02-18T10:50:00Z",
  "updatedAt": "2026-02-18T10:50:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/mortgages/arr-mort-005" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" },
    "property": { "href": "/api/v1/factfinds/ff-456/assets/property/asset-prop-001" },
    "owners": [
      { "href": "/api/v1/factfinds/ff-456/clients/client-123" },
      { "href": "/api/v1/factfinds/ff-456/clients/client-124" }
    ]
  }
}
```

**Validation Rules:**
- `arrangementType.code` - Required, must be "MORTGAGE"
- `mortgageType` - Required, one of: RESIDENTIAL, BUY_TO_LET, SECOND_CHARGE
- `propertyRef` - Required, must link to existing property asset
- `currentBalance` - Required, must be positive
- `monthlyPayment` - Required, must be positive
- `currentRate` - Required, must be > 0
- LTV cannot exceed 95% for residential, 85% for BTL

**Business Rules:**
- LTV = (Current Balance / Property Value) * 100
- Equity = Property Value - Current Balance
- Stress test typically at current rate + 3%
- ERC typically 1-5% of outstanding balance during fixed period
- Remortgage review when deal expiry within 6 months
- Affordability based on debt-to-income ratio (typically max 4.5x)

### 10.6 Protection Arrangements

**Base Path:** `/api/v1/factfinds/{factfindId}/arrangements/protections`

**Purpose:** Manage protection policies including life insurance, critical illness, income protection, and general insurance.

#### 10.6.1 Personal Protection (Life, CI, IP)

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/protections/personal-protection` | Create Personal Protection | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/protections/personal-protection` | List Personal Protection | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/protections/personal-protection/{arrangementId}` | Get Protection details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/protections/personal-protection/{arrangementId}` | Update Protection | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/protections/personal-protection/{arrangementId}` | Delete Protection | `arrangements:write` |

**Create Personal Protection Request:**

```json
{
  "arrangementType": {
    "code": "PROTECTION",
    "display": "Protection"
  },
  "protectionType": {
    "code": "LIFE_COVER",
    "display": "Life Cover"
  },
  "provider": {
    "name": "Legal & General",
    "reference": "LG-UK-001",
    "contactDetails": {
      "phone": "0800 783 4137",
      "email": "life@landg.com"
    }
  },
  "policyNumber": "LG-LIFE-789012",
  "startDate": "2020-04-01",
  "maturityDate": "2050-04-01",
  "owners": [
    {
      "clientRef": { "id": "client-123" },
      "ownershipPercentage": 100.0
    }
  ],
  "status": {
    "code": "ACTIVE",
    "display": "Active - In Force"
  },
  "coverDetails": {
    "coverAmount": {
      "amount": 500000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "coverType": {
      "code": "LEVEL_TERM",
      "display": "Level Term Assurance"
    },
    "coverPeriod": {
      "years": 30,
      "endsOn": "2050-04-01"
    }
  },
  "premiumDetails": {
    "monthlyPremium": {
      "amount": 35.50,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "annualPremium": {
      "amount": 426.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "paymentFrequency": {
      "code": "MONTHLY",
      "display": "Monthly"
    },
    "reviewable": false,
    "guaranteed": true
  },
  "beneficiaries": [
    {
      "name": "Jane Smith",
      "relationship": {
        "code": "SPOUSE",
        "display": "Spouse"
      },
      "percentage": 100.0,
      "ref": { "id": "client-124" }
    }
  ],
  "trustDetails": {
    "inTrust": true,
    "trustType": {
      "code": "SPLIT_TRUST",
      "display": "Split Trust"
    },
    "trustees": [
      "Jane Smith",
      "David Smith"
    ]
  },
  "underwritingDetails": {
    "underwritingType": {
      "code": "FULL_MEDICAL",
      "display": "Full Medical Underwriting"
    },
    "loadings": [],
    "exclusions": []
  }
}
```

**Response (201 Created):**

```json
{
  "id": "arr-prot-006",
  "href": "/api/v1/factfinds/ff-456/arrangements/protections/personal-protection/arr-prot-006",
  "arrangementType": {
    "code": "PROTECTION",
    "display": "Protection"
  },
  "arrangementCategory": {
    "code": "PROTECTION",
    "display": "Protection"
  },
  "protectionType": {
    "code": "LIFE_COVER",
    "display": "Life Cover"
  },
  "provider": {
    "name": "Legal & General",
    "reference": "LG-UK-001",
    "contactDetails": {
      "phone": "0800 783 4137",
      "email": "life@landg.com"
    }
  },
  "policyNumber": "LG-LIFE-789012",
  "startDate": "2020-04-01",
  "maturityDate": "2050-04-01",
  "currentValue": {
    "amount": 500000.00,
    "currency": { "code": "GBP", "symbol": "£", "display": "British Pound" }
  },
  "valuationDate": "2026-02-18",
  "owners": [
    {
      "clientRef": {
        "id": "client-123",
        "fullName": "John Smith",
        "href": "/api/v1/factfinds/ff-456/clients/client-123"
      },
      "ownershipPercentage": 100.0
    }
  ],
  "status": {
    "code": "ACTIVE",
    "display": "Active - In Force"
  },
  "coverDetails": {
    "coverAmount": {
      "amount": 500000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "coverType": {
      "code": "LEVEL_TERM",
      "display": "Level Term Assurance"
    },
    "coverPeriod": {
      "years": 30,
      "endsOn": "2050-04-01"
    },
    "yearsRemaining": 24.1
  },
  "premiumDetails": {
    "monthlyPremium": {
      "amount": 35.50,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "annualPremium": {
      "amount": 426.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "paymentFrequency": {
      "code": "MONTHLY",
      "display": "Monthly"
    },
    "totalPremiumsPaid": {
      "amount": 2982.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "reviewable": false,
    "guaranteed": true,
    "nextReviewDate": null
  },
  "beneficiaries": [
    {
      "id": "ben-001",
      "name": "Jane Smith",
      "relationship": {
        "code": "SPOUSE",
        "display": "Spouse"
      },
      "percentage": 100.0,
      "ref": {
        "id": "client-124",
        "href": "/api/v1/factfinds/ff-456/clients/client-124"
      }
    }
  ],
  "trustDetails": {
    "inTrust": true,
    "trustType": {
      "code": "SPLIT_TRUST",
      "display": "Split Trust"
    },
    "trustees": [
      "Jane Smith",
      "David Smith"
    ],
    "ihtBenefit": "Policy proceeds excluded from estate for IHT purposes"
  },
  "underwritingDetails": {
    "underwritingType": {
      "code": "FULL_MEDICAL",
      "display": "Full Medical Underwriting"
    },
    "loadings": [],
    "exclusions": [],
    "terms": "Standard Terms"
  },
  "adequacyCheck": {
    "recommendedCover": {
      "amount": 650000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "shortfall": {
      "amount": 150000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "adequacyPercentage": 76.92
  },
  "concurrencyId": "j2g8h6f5-7k90-9j3g-4i8h-6f7g8h9i0j1k",
  "createdAt": "2026-02-18T10:55:00Z",
  "updatedAt": "2026-02-18T10:55:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/protections/personal-protection/arr-prot-006" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" },
    "owner": { "href": "/api/v1/factfinds/ff-456/clients/client-123" },
    "beneficiaries": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-prot-006/beneficiaries" }
  }
}
```

**Protection Type Variations:**

**Critical Illness Cover:**
```json
{
  "protectionType": {
    "code": "CRITICAL_ILLNESS",
    "display": "Critical Illness Cover"
  },
  "coverDetails": {
    "conditionsCovered": 50,
    "partialPayment": true,
    "childrensCover": true
  }
}
```

**Income Protection:**
```json
{
  "protectionType": {
    "code": "INCOME_PROTECTION",
    "display": "Income Protection"
  },
  "coverDetails": {
    "monthlyBenefit": {
      "amount": 3000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "deferredPeriod": {
      "weeks": 13
    },
    "benefitPeriod": {
      "code": "AGE_65",
      "display": "To Age 65"
    },
    "indexation": true
  }
}
```

#### 10.6.2 General Insurance

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/factfinds/{factfindId}/arrangements/protections/general-insurance` | Create General Insurance | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/protections/general-insurance` | List General Insurance | `arrangements:read` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/protections/general-insurance/{arrangementId}` | Get Insurance details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/protections/general-insurance/{arrangementId}` | Update Insurance | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/protections/general-insurance/{arrangementId}` | Delete Insurance | `arrangements:write` |

**General Insurance Types:**
- Buildings Insurance
- Contents Insurance
- Motor Insurance
- Travel Insurance
- Pet Insurance
- Private Medical Insurance

**Buildings Insurance Example:**

```json
{
  "arrangementType": {
    "code": "GENERAL_INSURANCE",
    "display": "General Insurance"
  },
  "insuranceType": {
    "code": "BUILDINGS",
    "display": "Buildings Insurance"
  },
  "provider": {
    "name": "Aviva",
    "reference": "AVIVA-UK-001"
  },
  "policyNumber": "BLDG-456789",
  "coverAmount": {
    "amount": 425000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "annualPremium": {
    "amount": 285.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "excess": {
    "amount": 250.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "renewalDate": "2026-06-15",
  "linkedAssetRef": {
    "id": "asset-prop-001"
  }
}
```

### 10.7 Arrangement Sub-Resources

**Purpose:** Manage detailed transaction history and associated data for arrangements including contributions, withdrawals, beneficiaries, and valuations.

#### 10.7.1 Contributions

**Base Path:** `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions`

**Purpose:** Track contributions made to investment and pension arrangements.

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions` | List contributions | `arrangements:read` |
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions` | Add contribution | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions/{contributionId}` | Get contribution details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions/{contributionId}` | Update contribution | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions/{contributionId}` | Delete contribution | `arrangements:write` |

**Create Contribution Request:**

```json
{
  "contributionDate": "2026-02-15",
  "contributionType": {
    "code": "REGULAR",
    "display": "Regular Contribution"
  },
  "grossAmount": {
    "amount": 625.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "netAmount": {
    "amount": 500.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "taxRelief": {
    "amount": 125.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "employerContribution": {
    "amount": 250.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "source": {
    "code": "SALARY",
    "display": "Salary Deduction"
  },
  "notes": "Standard monthly contribution"
}
```

**Response (201 Created):**

```json
{
  "id": "contrib-001",
  "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/contributions/contrib-001",
  "arrangementRef": {
    "id": "arr-pp-003",
    "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003"
  },
  "contributionDate": "2026-02-15",
  "contributionType": {
    "code": "REGULAR",
    "display": "Regular Contribution"
  },
  "grossAmount": {
    "amount": 625.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "netAmount": {
    "amount": 500.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "taxRelief": {
    "amount": 125.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "employerContribution": {
    "amount": 250.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "totalContribution": {
    "amount": 875.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "source": {
    "code": "SALARY",
    "display": "Salary Deduction"
  },
  "taxYear": "2025/26",
  "annualAllowanceUsed": {
    "amount": 875.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "notes": "Standard monthly contribution",
  "createdAt": "2026-02-18T11:00:00Z",
  "updatedAt": "2026-02-18T11:00:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/contributions/contrib-001" },
    "arrangement": { "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" }
  }
}
```

**List Contributions Response:**

```json
{
  "arrangementRef": {
    "id": "arr-pp-003",
    "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003"
  },
  "contributions": [
    {
      "id": "contrib-001",
      "contributionDate": "2026-02-15",
      "grossAmount": {
        "amount": 625.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "contributionType": { "code": "REGULAR", "display": "Regular Contribution" },
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/contributions/contrib-001" }
      }
    },
    {
      "id": "contrib-002",
      "contributionDate": "2026-01-15",
      "grossAmount": {
        "amount": 625.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "contributionType": { "code": "REGULAR", "display": "Regular Contribution" },
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/contributions/contrib-002" }
      }
    }
  ],
  "summary": {
    "totalContributions": 24,
    "totalAmount": {
      "amount": 21000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "thisYearContributions": {
      "amount": 1750.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "annualAllowanceUsed": {
      "amount": 1750.00,
      "currency": { "code": "GBP", "symbol": "£" }
    }
  },
  "totalCount": 24,
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/contributions" },
    "arrangement": { "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003" }
  }
}
```

**Query Parameters:**
- `fromDate` - Filter contributions from this date
- `toDate` - Filter contributions to this date
- `contributionType` - Filter by type (REGULAR, AD_HOC, TRANSFER, EMPLOYER)
- `taxYear` - Filter by tax year (e.g., "2025/26")

#### 10.7.2 Withdrawals

**Base Path:** `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/withdrawals`

**Purpose:** Track withdrawals from investment, pension, and drawdown arrangements.

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/withdrawals` | List withdrawals | `arrangements:read` |
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/withdrawals` | Add withdrawal | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/withdrawals/{withdrawalId}` | Get withdrawal details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/withdrawals/{withdrawalId}` | Update withdrawal | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/withdrawals/{withdrawalId}` | Delete withdrawal | `arrangements:write` |

**Create Withdrawal Request (Pension Drawdown):**

```json
{
  "withdrawalDate": "2026-02-15",
  "withdrawalType": {
    "code": "INCOME",
    "display": "Regular Income Withdrawal"
  },
  "grossAmount": {
    "amount": 1000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "taxDeducted": {
    "amount": 200.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "netAmount": {
    "amount": 800.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "taxCode": "1257L",
  "crystallisedFund": {
    "amount": 1000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "uncrystallisedFund": {
    "amount": 0.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "reason": {
    "code": "REGULAR_INCOME",
    "display": "Regular Income Requirement"
  },
  "notes": "Monthly drawdown payment"
}
```

**Response (201 Created):**

```json
{
  "id": "withdraw-001",
  "href": "/api/v1/factfinds/ff-456/arrangements/arr-dd-007/withdrawals/withdraw-001",
  "arrangementRef": {
    "id": "arr-dd-007",
    "href": "/api/v1/factfinds/ff-456/arrangements/pensions/drawdown/arr-dd-007"
  },
  "withdrawalDate": "2026-02-15",
  "withdrawalType": {
    "code": "INCOME",
    "display": "Regular Income Withdrawal"
  },
  "grossAmount": {
    "amount": 1000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "taxDeducted": {
    "amount": 200.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "netAmount": {
    "amount": 800.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "taxCode": "1257L",
  "effectiveTaxRate": 20.0,
  "crystallisedFund": {
    "amount": 1000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "uncrystallisedFund": {
    "amount": 0.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "taxYear": "2025/26",
  "reason": {
    "code": "REGULAR_INCOME",
    "display": "Regular Income Requirement"
  },
  "notes": "Monthly drawdown payment",
  "createdAt": "2026-02-18T11:05:00Z",
  "updatedAt": "2026-02-18T11:05:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-dd-007/withdrawals/withdraw-001" },
    "arrangement": { "href": "/api/v1/factfinds/ff-456/arrangements/pensions/drawdown/arr-dd-007" },
    "factfind": { "href": "/api/v1/factfinds/ff-456" }
  }
}
```

**Create Withdrawal Request (Investment Bond 5% Rule):**

```json
{
  "withdrawalDate": "2026-02-15",
  "withdrawalType": {
    "code": "TAX_DEFERRED",
    "display": "5% Tax-Deferred Withdrawal"
  },
  "grossAmount": {
    "amount": 3750.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "netAmount": {
    "amount": 3750.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "fivePercentAllowanceUsed": {
    "amount": 3750.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "cumulativeAllowanceRemaining": {
    "amount": 15000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "taxYear": "2025/26",
  "reason": {
    "code": "INCOME_REQUIREMENT",
    "display": "Income Requirement"
  }
}
```

#### 10.7.3 Beneficiaries

**Base Path:** `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/beneficiaries`

**Purpose:** Manage beneficiary designations for pensions and protection policies.

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/beneficiaries` | List beneficiaries | `arrangements:read` |
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/beneficiaries` | Add beneficiary | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/beneficiaries/{beneficiaryId}` | Get beneficiary details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/beneficiaries/{beneficiaryId}` | Update beneficiary | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/beneficiaries/{beneficiaryId}` | Delete beneficiary | `arrangements:write` |

**Create Beneficiary Request:**

```json
{
  "beneficiaryType": {
    "code": "PERSON",
    "display": "Individual Person"
  },
  "name": "Sarah Smith",
  "relationship": {
    "code": "CHILD",
    "display": "Child"
  },
  "dateOfBirth": "2005-08-15",
  "percentage": 50.0,
  "contingent": false,
  "contactRef": {
    "id": "dependent-789"
  },
  "address": {
    "line1": "123 High Street",
    "city": "London",
    "postcode": "SW1A 1AA"
  },
  "notes": "Primary beneficiary - daughter"
}
```

**Response (201 Created):**

```json
{
  "id": "ben-002",
  "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/beneficiaries/ben-002",
  "arrangementRef": {
    "id": "arr-pp-003",
    "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003"
  },
  "beneficiaryType": {
    "code": "PERSON",
    "display": "Individual Person"
  },
  "name": "Sarah Smith",
  "relationship": {
    "code": "CHILD",
    "display": "Child"
  },
  "dateOfBirth": "2005-08-15",
  "age": 20,
  "percentage": 50.0,
  "contingent": false,
  "contactRef": {
    "id": "dependent-789",
    "href": "/api/v1/factfinds/ff-456/clients/client-123/dependents/dependent-789"
  },
  "address": {
    "line1": "123 High Street",
    "city": "London",
    "postcode": "SW1A 1AA"
  },
  "notes": "Primary beneficiary - daughter",
  "createdAt": "2026-02-18T11:10:00Z",
  "updatedAt": "2026-02-18T11:10:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/beneficiaries/ben-002" },
    "arrangement": { "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003" },
    "dependent": { "href": "/api/v1/factfinds/ff-456/clients/client-123/dependents/dependent-789" }
  }
}
```

**List Beneficiaries Response:**

```json
{
  "arrangementRef": {
    "id": "arr-pp-003",
    "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003"
  },
  "beneficiaries": [
    {
      "id": "ben-002",
      "name": "Sarah Smith",
      "relationship": { "code": "CHILD", "display": "Child" },
      "percentage": 50.0,
      "contingent": false,
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/beneficiaries/ben-002" }
      }
    },
    {
      "id": "ben-003",
      "name": "Michael Smith",
      "relationship": { "code": "CHILD", "display": "Child" },
      "percentage": 50.0,
      "contingent": false,
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/beneficiaries/ben-003" }
      }
    }
  ],
  "totalCount": 2,
  "totalPercentage": 100.0,
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/beneficiaries" },
    "arrangement": { "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003" }
  }
}
```

**Validation Rules:**
- Total percentage for non-contingent beneficiaries must equal 100%
- At least one beneficiary required for protection policies in trust
- Beneficiary age restrictions apply for certain arrangements
- Relationship to policyholder must be declared

#### 10.7.4 Valuations

**Base Path:** `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/valuations`

**Purpose:** Track historical valuation of arrangements over time for performance analysis.

**Operations:**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/valuations` | List valuations | `arrangements:read` |
| POST | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/valuations` | Add valuation | `arrangements:write` |
| GET | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/valuations/{valuationId}` | Get valuation details | `arrangements:read` |
| PATCH | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/valuations/{valuationId}` | Update valuation | `arrangements:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/valuations/{valuationId}` | Delete valuation | `arrangements:write` |

**Create Valuation Request:**

```json
{
  "valuationDate": "2026-02-18",
  "valuationType": {
    "code": "STATEMENT",
    "display": "Provider Statement"
  },
  "value": {
    "amount": 125000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "source": {
    "code": "PROVIDER",
    "display": "Provider Statement"
  },
  "crystallisedValue": {
    "amount": 0.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "uncrystallisedValue": {
    "amount": 125000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "documentRef": "statement-2026-02.pdf",
  "notes": "Q4 2025/26 statement"
}
```

**Response (201 Created):**

```json
{
  "id": "val-001",
  "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/valuations/val-001",
  "arrangementRef": {
    "id": "arr-pp-003",
    "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003"
  },
  "valuationDate": "2026-02-18",
  "valuationType": {
    "code": "STATEMENT",
    "display": "Provider Statement"
  },
  "value": {
    "amount": 125000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "source": {
    "code": "PROVIDER",
    "display": "Provider Statement"
  },
  "crystallisedValue": {
    "amount": 0.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "uncrystallisedValue": {
    "amount": 125000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "changeFromPrevious": {
    "amount": 5000.00,
    "currency": { "code": "GBP", "symbol": "£" }
  },
  "percentageChange": 4.17,
  "documentRef": "statement-2026-02.pdf",
  "notes": "Q4 2025/26 statement",
  "createdAt": "2026-02-18T11:15:00Z",
  "updatedAt": "2026-02-18T11:15:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/valuations/val-001" },
    "arrangement": { "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003" },
    "document": { "href": "/api/v1/factfinds/ff-456/documents/statement-2026-02.pdf" }
  }
}
```

**List Valuations Response:**

```json
{
  "arrangementRef": {
    "id": "arr-pp-003",
    "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003"
  },
  "valuations": [
    {
      "id": "val-001",
      "valuationDate": "2026-02-18",
      "value": {
        "amount": 125000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "valuationType": { "code": "STATEMENT", "display": "Provider Statement" },
      "percentageChange": 4.17,
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/valuations/val-001" }
      }
    },
    {
      "id": "val-002",
      "valuationDate": "2025-11-18",
      "value": {
        "amount": 120000.00,
        "currency": { "code": "GBP", "symbol": "£" }
      },
      "valuationType": { "code": "STATEMENT", "display": "Provider Statement" },
      "percentageChange": 3.45,
      "_links": {
        "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/valuations/val-002" }
      }
    }
  ],
  "summary": {
    "totalValuations": 8,
    "latestValue": {
      "amount": 125000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "earliestValue": {
      "amount": 95000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "totalGrowth": {
      "amount": 30000.00,
      "currency": { "code": "GBP", "symbol": "£" }
    },
    "totalGrowthPercentage": 31.58,
    "annualizedReturn": 6.2
  },
  "totalCount": 8,
  "_links": {
    "self": { "href": "/api/v1/factfinds/ff-456/arrangements/arr-pp-003/valuations" },
    "arrangement": { "href": "/api/v1/factfinds/ff-456/arrangements/pensions/personal-pension/arr-pp-003" }
  }
}
```

**Query Parameters:**
- `fromDate` - Filter valuations from this date
- `toDate` - Filter valuations to this date
- `valuationType` - Filter by type (STATEMENT, PROJECTION, ESTIMATE)
- `sortBy` - Sort by date (asc/desc)

---

## Regulatory Compliance

### FCA Requirements

**COBS 9.2 - Suitability Assessment:**
- All arrangements must be assessed for suitability
- Client objectives, financial situation, and knowledge/experience must be considered
- Suitability reports must reference specific arrangements

**COBS 13 - Periodic Reporting:**
- Annual statements for investment-based products
- Performance reporting against objectives
- Cost and charges disclosure

**COBS 19.1 - Pension Transfers:**
- Transfer value analysis for defined benefit schemes
- CETV must be clearly disclosed
- Risk warnings mandatory for transfers exceeding £30,000

**IDD Compliance:**
- Insurance product governance
- Target market assessment
- Fair value assessment for protection products

### Data Protection

**GDPR Article 9 - Special Category Data:**
- Health information for underwriting (protection policies)
- Trade union membership (pension schemes)
- Consent required for processing

**Right to Erasure:**
- Soft delete maintains audit trail
- Regulatory retention periods respected (6 years minimum)

### Anti-Money Laundering

**MLR 2017:**
- Source of wealth verification for large contributions
- Enhanced due diligence for offshore arrangements
- Politically Exposed Persons (PEP) screening

---

## Error Responses

**Standard Error Format (RFC 7807):**

```json
{
  "type": "https://api.factfind.com/errors/validation-error",
  "title": "Validation Failed",
  "status": 400,
  "detail": "ISA allowance exceeded for tax year 2025/26",
  "instance": "/api/v1/factfinds/ff-456/arrangements/investments/ISA/arr-isa-002",
  "errors": [
    {
      "field": "isaAllowance.usedThisYear",
      "message": "Contribution would exceed annual ISA allowance of £20,000",
      "code": "ALLOWANCE_EXCEEDED",
      "value": 21500.00,
      "limit": 20000.00
    }
  ]
}
```

**Common Error Codes:**
- `ALLOWANCE_EXCEEDED` - Annual allowance limit breached
- `INVALID_OWNER` - Owner does not exist in fact-find
- `ARRANGEMENT_NOT_FOUND` - Arrangement ID not found
- `DUPLICATE_POLICY` - Policy number already exists
- `VALUATION_TOO_OLD` - Valuation date exceeds 12 months
- `BENEFICIARY_PERCENTAGE_INVALID` - Beneficiary percentages do not sum to 100%
- `TRANSFER_ADVICE_REQUIRED` - FCA advice mandatory (DB transfer > £30k)
- `PROPERTY_NOT_FOUND` - Linked property asset not found (mortgages)

---

## Total Endpoints Summary

**Investment Arrangements:** 30 endpoints (6 types × 5 operations)
**Pension Arrangements:** 35 endpoints (7 types × 5 operations)
**Mortgage Arrangements:** 5 endpoints
**Protection Arrangements:** 10 endpoints (2 types × 5 operations)
**Sub-Resources:** 20 endpoints (4 resources × 5 operations)

**Total Arrangement Endpoints:** 100

---
## 11. Risk Profile API

### 11.1 Overview

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

### 11.2 Operations Summary

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

### 11.3 Key Endpoints

#### 11.3.1 Get Current ATR Assessment

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

#### 11.3.2 Submit/Update ATR Assessment

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

#### 11.3.3 Choose Risk Profile

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

#### 11.3.4 Get ATR Assessment History (Risk Replay)

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

### 11.4 ATR Templates Reference Data

**Purpose:** ATR questionnaire templates are system configuration and reference data. They are not managed via the main API but can be queried to see available templates.

**Key Points:**
- Templates are managed by system administrators, not via public API
- No create, update, delete operations for templates
- Templates include the full questionnaire structure, scoring algorithms, and risk rating categories
- Multiple template versions can exist but only one is "active" at any time

#### 11.4.1 List Available ATR Templates

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

#### 11.4.2 Get ATR Template Details

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

### 11.5 Risk Assessment History API

**Purpose:** Historical tracking and comparison of ATR assessments over time (Risk Replay).

**Key Capabilities:**
- View all historical assessments for a fact find
- Compare two assessments side-by-side
- Track risk profile changes over time
- Regulatory audit trail

See Section 10.3.4 for the main history endpoint.

#### 11.5.1 Compare Two Assessments

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

### 11.6 Integration with FactFind Workflow

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

- ATR assessment embedded in FactFind Contract (Section 12.2)
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-124",
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
    "self": { "href": "/api/v1/factfinds/{factfindId}/clients/client-123" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "spouse": { "href": "/api/v1/factfinds/{factfindId}/clients/client-124" },
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
          "href": "/api/v1/factfinds/{factfindId}/clients/client-568",
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
          "href": "/api/v1/factfinds/{factfindId}/clients/client-569",
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
    "self": { "href": "/api/v1/factfinds/{factfindId}/clients/client-567" },
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
        "href": "/api/v1/factfinds/{factfindId}/clients/client-1000",
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
          "href": "/api/v1/factfinds/{factfindId}/clients/client-1001",
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
          "href": "/api/v1/factfinds/{factfindId}/clients/client-1002",
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
    "self": { "href": "/api/v1/factfinds/{factfindId}/clients/client-999" },
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
POST /api/v1/factfinds/{factfindId}/clients
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
POST /api/v1/factfinds/{factfindId}/clients
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
POST /api/v1/factfinds/{factfindId}/clients
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

For the complete FactFind Contract with full ATR assessment example, see Section 10.3.1 or Section 12.2 in the latest version.


The `FactFind` contract (also known as ADVICE_CASE) represents a fact-finding session and aggregate root for circumstances discovery.

**Reference Type:** FactFind is a reference type with identity (has `id` field).

Complete fact find aggregate root with summary calculations.

**ENHANCED v2.2 - Industry-Aligned Value Types:**
The FactFind contract has been refactored to group related fields into industry-standard value types:
- **MeetingDetailsValue** (Section 12.2.1) - Meeting/consultation information (FCA/MiFID II terminology)
- **FinancialSummaryValue** (Section 12.2.2) - Computed financial totals and metrics (read-only snapshot)
- **AssetHoldingsValue** (Section 12.2.3) - Indicators of what financial products client holds (portfolio management terminology)
- **InvestmentCapacityValue** (Section 12.2.4) - Client's capacity and budget for new investments (FCA suitability terminology)
- **CompletionStatusValue** (Section 12.2.5) - Completion tracking and compliance checks

This grouping improves clarity, aligns with industry standards, and makes the contract easier to understand and maintain.

```json
{
  "id": "factfind-456",
  "factFindNumber": "FF001234",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
    "name": "John Smith",
    "clientNumber": "C00001234",
    "type": "Person"
  },
  "jointClientRef": {
    "id": "client-124",
    "href": "/api/v1/factfinds/{factfindId}/clients/client-124",
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
| **`meetingDetails`** | **MeetingDetailsValue** | **required** | **updatable** | **included** | **Value type group (Section 12.2.1)** |
| **`financialSummary`** | **FinancialSummaryValue** | **ignored** | **ignored** | **included** | **read-only, computed value type (Section 12.2.2)** |
| **`assetHoldings`** | **AssetHoldingsValue** | **ignored** | **partial** | **included** | **Mostly computed, credit fields updatable (Section 12.2.3)** |
| **`investmentCapacity`** | **InvestmentCapacityValue** | **optional** | **updatable** | **included** | **Value type group (Section 12.2.4)** |
| **`completionStatus`** | **CompletionStatusValue** | **optional** | **updatable** | **included** | **Value type group (Section 12.2.5)** |
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

**Note:** For simple embedded addresses (like `primaryAddress` in Client), use `AddressValue` (see Section 12.10.2) which has no `id` and is embedded directly.

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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
      "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "self": { "href": "/api/v1/factfinds/{factfindId}/arrangements/arrangement-555" },
    "contributions": { "href": "/api/v1/factfinds/{factfindId}/arrangements/arrangement-555/contributions" },
    "valuations": { "href": "/api/v1/factfinds/{factfindId}/arrangements/arrangement-555/valuations" }
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "arrangement": { "href": "/api/v1/factfinds/{factfindId}/arrangements/arrangement-456" },
    "client": { "href": "/api/v1/factfinds/{factfindId}/clients/client-123" },
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
        "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
        "href": "/api/v1/factfinds/{factfindId}/arrangements/mortgage-789",
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
    "self": { "href": "/api/v1/factfinds/{factfindId}/assets/property-456" },
    "update": { "href": "/api/v1/factfinds/{factfindId}/assets/property-456", "method": "PUT" },
    "delete": { "href": "/api/v1/factfinds/{factfindId}/assets/property-456", "method": "DELETE" },
    "factfind": { "href": "/api/v1/factfinds/factfind-123" },
    "owners": { "href": "/api/v1/factfinds/{factfindId}/assets/property-456/owners" },
    "mortgages": { "href": "/api/v1/factfinds/{factfindId}/assets/property-456/mortgages" },
    "expenses": { "href": "/api/v1/factfinds/{factfindId}/assets/property-456/expenses" },
    "rental": { "href": "/api/v1/factfinds/{factfindId}/assets/property-456/rental" },
    "valuations": { "href": "/api/v1/factfinds/{factfindId}/assets/property-456/valuations" },
    "documents": { "href": "/api/v1/factfinds/{factfindId}/assets/property-456/documents" }
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

**Creating a Buy-To-Let Property (POST /api/v1/factfinds/{factfindId}/assets):**
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "self": { "href": "/api/v1/factfinds/{factfindId}/assets/equity-321" },
    "update": { "href": "/api/v1/factfinds/{factfindId}/assets/equity-321", "method": "PUT" },
    "delete": { "href": "/api/v1/factfinds/{factfindId}/assets/equity-321", "method": "DELETE" },
    "client": { "href": "/api/v1/factfinds/{factfindId}/clients/client-123" },
    "factfind": { "href": "/api/v1/factfinds/factfind-123" },
    "transactions": { "href": "/api/v1/factfinds/{factfindId}/assets/equity-321/transactions" },
    "dividends": { "href": "/api/v1/factfinds/{factfindId}/assets/equity-321/dividends" },
    "corporateActions": { "href": "/api/v1/factfinds/{factfindId}/assets/equity-321/corporate-actions" },
    "performance": { "href": "/api/v1/factfinds/{factfindId}/assets/equity-321/performance" },
    "documents": { "href": "/api/v1/factfinds/{factfindId}/assets/equity-321/documents" }
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

**Creating an Equity Holding (POST /api/v1/factfinds/{factfindId}/assets):**
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

### 13.11 IdentityVerification Contract

The `IdentityVerification` contract represents identity verification status with KYC and AML checks.

**Reference Type:** IdentityVerification is a reference type with identity (has `id` field).

```json
{
  "id": "idverify-987",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "client": { "href": "/api/v1/factfinds/{factfindId}/clients/client-123" },
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

### 13.12 Consent Contract

The `Consent` contract represents GDPR consent tracking with purpose-specific consents and audit trail.

**Reference Type:** Consent is a reference type with identity (has `id` field).

```json
{
  "id": "consent-555",
  "clientRef": {
    "id": "client-123",
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "client": { "href": "/api/v1/factfinds/{factfindId}/clients/client-123" },
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

### 13.13 Collection Response Wrapper

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
    "first": { "href": "/api/v1/factfinds/{factfindId}/clients?page=1&pageSize=20" },
    "prev": null,
    "self": { "href": "/api/v1/factfinds/{factfindId}/clients?page=1&pageSize=20" },
    "next": { "href": "/api/v1/factfinds/{factfindId}/clients?page=2&pageSize=20" },
    "last": { "href": "/api/v1/factfinds/{factfindId}/clients?page=5&pageSize=20" }
  }
}
```

The `data` array contains complete entity contracts. Clients can use field selection (`?fields=id,name`) to reduce response size.

---

### 13.14 Contract Extension for Other Entities

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

### 13.15 Standard Value Types

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

### 13.16 Standard Reference Types

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
  "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
    "href": "/api/v1/factfinds/{factfindId}/clients/client-123",
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
  "href": "/api/v1/factfinds/{factfindId}/arrangements/arrangement-111",
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
    "href": "/api/v1/factfinds/{factfindId}/arrangements/arrangement-111",
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
  "href": "/api/v1/factfinds/{factfindId}/objectives/goal-333",
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
    "href": "/api/v1/factfinds/{factfindId}/objectives/goal-333",
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
- CLIENT → `/api/v1/factfinds/{factfindId}/clients`
- ADDRESS → `/api/v1/factfinds/{factfindId}/clients/{id}/addresses`
- CONTACT_DETAIL → `/api/v1/factfinds/{factfindId}/clients/{id}/contacts`
- PROFESSIONAL_CONTACT → `/api/v1/factfinds/{factfindId}/clients/{id}/professional-contacts`
- CLIENT_RELATIONSHIP → `/api/v1/factfinds/{factfindId}/clients/{id}/relationships`
- DPA_CONSENT → `/api/v1/factfinds/{factfindId}/clients/{id}/dpa-consent`
- MARKETING_CONSENT → `/api/v1/factfinds/{factfindId}/clients/{id}/marketing-consent`
- VULNERABLE_CUSTOMER_FLAG → `/api/v1/factfinds/{factfindId}/clients/{id}/vulnerability`
- DEPENDANT → `/api/v1/factfinds/{factfindId}/clients/{id}/dependants`

**Circumstances Context:**
- ADVICE_CASE → `/api/v1/factfinds`
- EMPLOYMENT → `/api/v1/factfinds/{id}/employment`
- INCOME → `/api/v1/factfinds/{id}/income`
- INCOME_CHANGE → `/api/v1/factfinds/{id}/income-changes`
- EXPENDITURE → `/api/v1/factfinds/{id}/expenditure`
- EXPENDITURE_CHANGE → `/api/v1/factfinds/{id}/expenditure-changes`

**Assets & Liabilities Context:**
- ASSET → `/api/v1/factfinds/{factfindId}/assets`
- BUSINESS_ASSET → `/api/v1/factfinds/{factfindId}/assets/{id}` (embedded in ASSET)
- PROPERTY_DETAIL → `/api/v1/factfinds/{factfindId}/assets/{id}` (embedded in ASSET)
- CREDIT_HISTORY → `/api/v1/factfinds/{factfindId}/clients/{id}/credit-history`
- VALUATION → `/api/v1/factfinds/{factfindId}/arrangements/{id}/valuations`

**Arrangements Context:**
- ARRANGEMENT → `/api/v1/factfinds/{factfindId}/arrangements`
- CONTRIBUTION → `/api/v1/factfinds/{factfindId}/arrangements/{id}/contributions`
- WITHDRAWAL → `/api/v1/factfinds/{factfindId}/arrangements/{id}/withdrawals`
- BENEFICIARY → `/api/v1/factfinds/{factfindId}/arrangements/{id}/beneficiaries`
- CLIENT_PENSION → `/api/v1/factfinds/{factfindId}/clients/{id}/pension-summary`

**Goals Context:**
- GOAL → `/api/v1/factfinds/{factfindId}/objectives`
- OBJECTIVE → `/api/v1/factfinds/{factfindId}/goals/{id}/objectives`
- NEED → `/api/v1/factfinds/{factfindId}/goals/{id}/needs`

**Risk Profile Context:**
- RISK_PROFILE → `/api/v1/factfinds/{factfindId}/risk-profile`

**Estate Planning Context:**
- GIFT → `/api/v1/factfinds/{factfindId}/gifts`
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
**Date:** 2026-02-18
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


---

## Appendix A: Migration Guide - v2.0 to v2.1

### Overview

Version 2.1 introduces **breaking changes** to all API endpoints. The API has been restructured to follow a hierarchical, context-based design with **FactFind as the aggregate root**.

**Impact:** ALL API consumers must update their endpoint URLs.

**Timeline:** Immediate (no backward compatibility maintained - requires major version bump)

### Endpoint Migration Map

#### Client Management APIs

| Old Endpoint (v2.0) | New Endpoint (v2.1) |
|---------------------|---------------------|
| `POST /api/v1/factfinds/{factfindId}/clients` | `POST /api/v1/factfinds/{factfindId}/clients` |
| `GET /api/v1/factfinds/{factfindId}/clients/{clientId}` | `GET /api/v1/factfinds/{factfindId}/clients/{clientId}` |
| `GET /api/v1/factfinds/{factfindId}/clients` | `GET /api/v1/factfinds/{factfindId}/clients` |
| `PATCH /api/v1/factfinds/{factfindId}/clients/{clientId}` | `PATCH /api/v1/factfinds/{factfindId}/clients/{clientId}` |
| `DELETE /api/v1/factfinds/{factfindId}/clients/{clientId}` | `DELETE /api/v1/factfinds/{factfindId}/clients/{clientId}` |
| `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/addresses` | `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/addresses` |
| `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/addresses` | `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/addresses` |
| `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/contacts` | `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/contacts` |
| `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/professional-contacts` | `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/professional-contacts` |
| `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/relationships` | `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/relationships` |
| `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/dpa-consent` | `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/dpa-consent` |
| `PUT /api/v1/factfinds/{factfindId}/clients/{clientId}/dpa-consent` | `PUT /api/v1/factfinds/{factfindId}/clients/{clientId}/dpa-consent` |
| `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/marketing-consent` | `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/marketing-consent` |
| `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/vulnerability` | `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/vulnerability` |
| `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/dependants` | `POST /api/v1/factfinds/{factfindId}/clients/{clientId}/dependants` |
| `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history` | `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/credit-history` |
| `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/pension-summary` | `GET /api/v1/factfinds/{factfindId}/clients/{clientId}/pension-summary` |

#### Employment APIs

| Old Endpoint (v2.0) | New Endpoint (v2.1) |
|---------------------|---------------------|
| `POST /api/v1/employment` | `POST /api/v1/factfinds/{factfindId}/employment` |
| `GET /api/v1/employment` | `GET /api/v1/factfinds/{factfindId}/employment` |
| `GET /api/v1/employment/{employmentId}` | `GET /api/v1/factfinds/{factfindId}/employment/{employmentId}` |
| `PATCH /api/v1/employment/{employmentId}` | `PATCH /api/v1/factfinds/{factfindId}/employment/{employmentId}` |
| `DELETE /api/v1/employment/{employmentId}` | `DELETE /api/v1/factfinds/{factfindId}/employment/{employmentId}` |

#### Income & Expenditure APIs

| Old Endpoint (v2.0) | New Endpoint (v2.1) |
|---------------------|---------------------|
| `POST /api/v1/income` | `POST /api/v1/factfinds/{factfindId}/income` |
| `GET /api/v1/income` | `GET /api/v1/factfinds/{factfindId}/income` |
| `GET /api/v1/income/{incomeId}` | `GET /api/v1/factfinds/{factfindId}/income/{incomeId}` |
| `PATCH /api/v1/income/{incomeId}` | `PATCH /api/v1/factfinds/{factfindId}/income/{incomeId}` |
| `DELETE /api/v1/income/{incomeId}` | `DELETE /api/v1/factfinds/{factfindId}/income/{incomeId}` |
| `POST /api/v1/income-changes` | `POST /api/v1/factfinds/{factfindId}/income-changes` |
| `POST /api/v1/expenditure` | `POST /api/v1/factfinds/{factfindId}/expenditure` |
| `GET /api/v1/expenditure` | `GET /api/v1/factfinds/{factfindId}/expenditure` |
| `GET /api/v1/expenditure/{expenditureId}` | `GET /api/v1/factfinds/{factfindId}/expenditure/{expenditureId}` |
| `PATCH /api/v1/expenditure/{expenditureId}` | `PATCH /api/v1/factfinds/{factfindId}/expenditure/{expenditureId}` |
| `DELETE /api/v1/expenditure/{expenditureId}` | `DELETE /api/v1/factfinds/{factfindId}/expenditure/{expenditureId}` |
| `POST /api/v1/expenditure-changes` | `POST /api/v1/factfinds/{factfindId}/expenditure-changes` |

#### Assets & Liabilities APIs

| Old Endpoint (v2.0) | New Endpoint (v2.1) |
|---------------------|---------------------|
| `POST /api/v1/factfinds/{factfindId}/assets` | `POST /api/v1/factfinds/{factfindId}/assets` |
| `GET /api/v1/factfinds/{factfindId}/assets` | `GET /api/v1/factfinds/{factfindId}/assets` |
| `GET /api/v1/factfinds/{factfindId}/assets/{assetId}` | `GET /api/v1/factfinds/{factfindId}/assets/{assetId}` |
| `PATCH /api/v1/factfinds/{factfindId}/assets/{assetId}` | `PATCH /api/v1/factfinds/{factfindId}/assets/{assetId}` |
| `DELETE /api/v1/factfinds/{factfindId}/assets/{assetId}` | `DELETE /api/v1/factfinds/{factfindId}/assets/{assetId}` |
| `POST /api/v1/properties` | `POST /api/v1/factfinds/{factfindId}/assets` (type=property) |
| `GET /api/v1/properties/{propertyId}` | `GET /api/v1/factfinds/{factfindId}/assets/{assetId}` |
| `POST /api/v1/equities` | `POST /api/v1/factfinds/{factfindId}/assets` (type=equity) |
| `GET /api/v1/equities/{equityId}` | `GET /api/v1/factfinds/{factfindId}/assets/{assetId}` |

#### Arrangements APIs

| Old Endpoint (v2.0) | New Endpoint (v2.1) |
|---------------------|---------------------|
| `POST /api/v1/factfinds/{factfindId}/arrangements` | `POST /api/v1/factfinds/{factfindId}/arrangements` |
| `GET /api/v1/factfinds/{factfindId}/arrangements` | `GET /api/v1/factfinds/{factfindId}/arrangements` |
| `GET /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}` | `GET /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}` |
| `PATCH /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}` | `PATCH /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}` |
| `DELETE /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}` | `DELETE /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}` |
| `POST /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions` | `POST /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions` |
| `GET /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions` | `GET /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/contributions` |
| `POST /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/withdrawals` | `POST /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/withdrawals` |
| `POST /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/beneficiaries` | `POST /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/beneficiaries` |
| `POST /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/valuations` | `POST /api/v1/factfinds/{factfindId}/arrangements/{arrangementId}/valuations` |

**Type-Specific Arrangement Endpoints (NEW in v2.1):**

| Type | Endpoint |
|------|----------|
| Investments | `GET /api/v1/factfinds/{factfindId}/arrangements/investments` |
| Pensions | `GET /api/v1/factfinds/{factfindId}/arrangements/pensions` |
| Mortgages | `GET /api/v1/factfinds/{factfindId}/arrangements/mortgages` |
| Protection | `GET /api/v1/factfinds/{factfindId}/arrangements/protection` |

#### Goals & Objectives APIs

| Old Endpoint (v2.0) | New Endpoint (v2.1) |
|---------------------|---------------------|
| `POST /api/v1/factfinds/{factfindId}/goals` | `POST /api/v1/factfinds/{factfindId}/objectives` |
| `GET /api/v1/factfinds/{factfindId}/goals` | `GET /api/v1/factfinds/{factfindId}/objectives` |
| `GET /api/v1/factfinds/{factfindId}/goals/{goalId}` | `GET /api/v1/factfinds/{factfindId}/objectives/{objectiveId}` |
| `PATCH /api/v1/factfinds/{factfindId}/goals/{goalId}` | `PATCH /api/v1/factfinds/{factfindId}/objectives/{objectiveId}` |
| `DELETE /api/v1/factfinds/{factfindId}/goals/{goalId}` | `DELETE /api/v1/factfinds/{factfindId}/objectives/{objectiveId}` |
| `POST /api/v1/factfinds/{factfindId}/objectives` | `POST /api/v1/factfinds/{factfindId}/objectives` |
| `POST /api/v1/factfinds/{factfindId}/objectives/{objectiveId}/needs` | `POST /api/v1/factfinds/{factfindId}/objectives/{objectiveId}/needs` |

#### Risk Profile APIs

| Old Endpoint (v2.0) | New Endpoint (v2.1) |
|---------------------|---------------------|
| `GET /api/v1/risk-profiles` | `GET /api/v1/factfinds/{factfindId}/risk-profile` |
| `POST /api/v1/risk-profiles` | `POST /api/v1/factfinds/{factfindId}/risk-profile` |
| `GET /api/v1/risk-profiles/{riskProfileId}` | `GET /api/v1/factfinds/{factfindId}/risk-profile` |
| `PATCH /api/v1/risk-profiles/{riskProfileId}` | `PATCH /api/v1/factfinds/{factfindId}/risk-profile` |

**Note:** Risk profile is now a singleton within each fact-find (one risk profile per fact-find).

#### Estate Planning APIs

| Old Endpoint (v2.0) | New Endpoint (v2.1) |
|---------------------|---------------------|
| `POST /api/v1/factfinds/{factfindId}/gifts` | `POST /api/v1/factfinds/{factfindId}/gifts` |
| `GET /api/v1/factfinds/{factfindId}/gifts` | `GET /api/v1/factfinds/{factfindId}/gifts` |
| `GET /api/v1/factfinds/{factfindId}/gifts/{giftId}` | `GET /api/v1/factfinds/{factfindId}/gifts/{giftId}` |
| `POST /api/v1/factfinds/{factfindId}/trusts` | `POST /api/v1/factfinds/{factfindId}/trusts` |
| `GET /api/v1/factfinds/{factfindId}/trusts` | `GET /api/v1/factfinds/{factfindId}/trusts` |
| `GET /api/v1/factfinds/{factfindId}/trusts/{trustId}` | `GET /api/v1/factfinds/{factfindId}/trusts/{trustId}` |

### Migration Steps

#### 1. Identify FactFind Context

Before migrating, you need to determine the `factfindId` for each operation:

**Option A: From UI Context**
```javascript
// In a typical SPA, the factfindId is in the URL
const factfindId = window.location.pathname.split('/')[2]; // /factfinds/12345/...
```

**Option B: From Client/User Context**
```javascript
// Get active fact-find for current user
const response = await fetch('/api/v1/factfinds?status=active&limit=1');
const factfind = await response.json();
const factfindId = factfind.data[0].factfindId;
```

**Option C: Create New FactFind First**
```javascript
// Create a new fact-find if none exists
const response = await fetch('/api/v1/factfinds', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    title: 'New Fact-Find',
    clientType: 'INDIVIDUAL'
  })
});
const factfind = await response.json();
const factfindId = factfind.factfindId;
```

#### 2. Update Base URLs

**Before (v2.0):**
```javascript
const BASE_URL = '/api/v1';
const clientsUrl = `${BASE_URL}/clients`;
```

**After (v2.1):**
```javascript
const BASE_URL = '/api/v1';
const factfindId = getCurrentFactfindId(); // Your implementation
const clientsUrl = `${BASE_URL}/factfinds/${factfindId}/clients`;
```

#### 3. Update API Client

**Before (v2.0):**
```javascript
class ClientAPI {
  async getClient(clientId) {
    return fetch(`/api/v1/clients/${clientId}`);
  }

  async createAddress(clientId, address) {
    return fetch(`/api/v1/clients/${clientId}/addresses`, {
      method: 'POST',
      body: JSON.stringify(address)
    });
  }
}
```

**After (v2.1):**
```javascript
class ClientAPI {
  constructor(factfindId) {
    this.factfindId = factfindId;
  }

  async getClient(clientId) {
    return fetch(`/api/v1/factfinds/${this.factfindId}/clients/${clientId}`);
  }

  async createAddress(clientId, address) {
    return fetch(`/api/v1/factfinds/${this.factfindId}/clients/${clientId}/addresses`, {
      method: 'POST',
      body: JSON.stringify(address)
    });
  }
}

// Usage
const factfindId = getCurrentFactfindId();
const api = new ClientAPI(factfindId);
```

#### 4. Update HATEOAS Link Following

**Before (v2.0):**
```javascript
// Old HATEOAS links
{
  "_links": {
    "self": { "href": "/api/v1/factfinds/{factfindId}/clients/12345" },
    "addresses": { "href": "/api/v1/factfinds/{factfindId}/clients/12345/addresses" }
  }
}
```

**After (v2.1):**
```javascript
// New HATEOAS links (factfindId embedded)
{
  "_links": {
    "self": { "href": "/api/v1/factfinds/999/clients/12345" },
    "addresses": { "href": "/api/v1/factfinds/999/clients/12345/addresses" }
  }
}
```

**Migration Strategy:**
- If your code follows HATEOAS links (recommended), minimal changes needed
- Links are now absolute and include factfindId
- Continue using `_links.self.href` for navigation

#### 5. Update Query Parameters

Query parameters remain the same, but base URLs change:

**Before (v2.0):**
```
GET /api/v1/factfinds/{factfindId}/clients?page=1&limit=20&sort=lastName
```

**After (v2.1):**
```
GET /api/v1/factfinds/{factfindId}/clients?page=1&limit=20&sort=lastName
```

#### 6. Update Response Handling

Response structure remains the same - only URLs change:

**Before (v2.0):**
```javascript
const response = await fetch('/api/v1/factfinds/{factfindId}/clients/12345');
const client = await response.json();
console.log(client.clientId); // Still works
```

**After (v2.1):**
```javascript
const response = await fetch(`/api/v1/factfinds/${factfindId}/clients/12345`);
const client = await response.json();
console.log(client.clientId); // Same response structure
```

### Breaking Changes Summary

| Category | Change | Impact |
|----------|--------|--------|
| **URLs** | All endpoints now require `factfindId` in path | HIGH - All API calls affected |
| **Response Structure** | HATEOAS `_links` now include `factfindId` | LOW - Follow links as before |
| **Request Bodies** | No changes | NONE |
| **Query Parameters** | No changes | NONE |
| **HTTP Methods** | No changes | NONE |
| **Status Codes** | No changes | NONE |
| **Headers** | No changes | NONE |

### Non-Breaking Changes

The following remain unchanged:

1. **Request/Response payloads** - Same JSON structure
2. **Authentication** - Same OAuth 2.0 flow
3. **Error format** - Same RFC 7807 format
4. **Pagination** - Same cursor-based pagination
5. **Filtering** - Same query syntax
6. **Field selection** - Same `fields` parameter
7. **Resource expansion** - Same `expand` parameter
8. **Optimistic concurrency** - Same `If-Match` / `ETag` headers

### Reference Data (No Changes)

Reference data APIs are **NOT affected** by this migration:

```
GET /api/v1/reference/income-types        ✓ No change
GET /api/v1/reference/providers           ✓ No change
GET /api/v1/reference/risk-templates      ✓ No change
```

These remain global and are not scoped to a fact-find.

### Testing Your Migration

#### 1. Unit Tests

Update base URLs in your API mocks:

```javascript
// Before
const mockClientUrl = '/api/v1/factfinds/{factfindId}/clients/12345';

// After
const mockFactfindId = '999';
const mockClientUrl = `/api/v1/factfinds/${mockFactfindId}/clients/12345`;
```

#### 2. Integration Tests

Update test fixtures:

```javascript
// Before
describe('Client API', () => {
  it('should fetch client', async () => {
    const response = await fetch('/api/v1/factfinds/{factfindId}/clients/12345');
    expect(response.status).toBe(200);
  });
});

// After
describe('Client API', () => {
  const factfindId = 'test-factfind-123';

  it('should fetch client', async () => {
    const response = await fetch(`/api/v1/factfinds/${factfindId}/clients/12345`);
    expect(response.status).toBe(200);
  });
});
```

#### 3. End-to-End Tests

Update page objects:

```javascript
// Before
class ClientPage {
  async getClient(clientId) {
    return this.page.goto(`/api/v1/clients/${clientId}`);
  }
}

// After
class ClientPage {
  constructor(page, factfindId) {
    this.page = page;
    this.factfindId = factfindId;
  }

  async getClient(clientId) {
    return this.page.goto(`/api/v1/factfinds/${this.factfindId}/clients/${clientId}`);
  }
}
```

### Rollback Strategy

If you need to rollback to v2.0:

1. **Version pinning**: Use `Accept: application/vnd.factfind.v2+json` header
2. **Feature flag**: Enable v2.0 endpoints via feature flag
3. **Dual writes**: Temporarily support both v2.0 and v2.1 endpoints

**Note:** Rollback should be temporary. Plan to fully migrate to v2.1 as v2.0 will be deprecated.

### Support & Questions

- **Documentation**: See Section 1.5 for architectural details
- **Examples**: All sections include updated examples
- **Issues**: Report migration issues to API support team
- **Timeline**: All API consumers must migrate within 90 days

---

