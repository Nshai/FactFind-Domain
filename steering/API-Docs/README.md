# API Contract Documentation

This folder contains all API contract specifications, OpenAPI schemas, and governance frameworks organized by category.

**For complete project overview:** [**../../README.md**](../../README.md) ⭐

**For master navigation:** [**../Navigation/FINAL-STRUCTURE.md**](../Navigation/FINAL-STRUCTURE.md)

---

## 📁 Folder Structure

### 📜 Master-Documents/
**Core API specifications and governance - Start here**

- **openapi-factfind-complete.yaml** ⭐ **AUTHORITATIVE SPEC (NEW - Feb 2026)**
  - Comprehensive OpenAPI 3.1 specification aligned with domain architecture
  - Based on Complete-Domain-Model.md (42 tables, 8 bounded contexts)
  - 206 endpoints across all domains (foundation implemented)
  - Ready for code generation (TypeScript, C#, Java, Python SDKs)
  - Production-ready: RFC 7807 errors, HATEOAS Level 3, concurrency control
  - See OpenAPI-Complete-Summary.md for details

- **openapi-factfind-legacy.yaml** (LEGACY - 97KB)
  - Original OpenAPI 3.1 specification (deprecated)
  - Broad coverage but incomplete schemas
  - Use openapi-factfind-complete.yaml instead

- **README.md** (7 KB)
  - Master documents navigation index

- **OpenAPI-Complete-Summary.md** (26 KB) ⭐ **START HERE FOR API SPEC**
  - Summary of comprehensive OpenAPI specification
  - Alignment with domain architecture (42 tables, 8 contexts)
  - Production-ready features (RFC 7807, HATEOAS, concurrency)
  - Extension roadmap and next steps

- **API-Implementation-Complete.md** (16 KB)
  - Completion summary and sign-off
  - Coverage statistics
  - Success criteria validation
  - Implementation readiness checklist

- **API-Master-Specification.md** (55 KB)
  - Single source of truth for entire API system
  - 206 endpoints documented
  - Integration patterns and domain boundaries
  - Migration strategy

- **API-Quick-Start-Guide.md** (18 KB) ⭐ **DEVELOPERS START HERE**
  - 5-minute getting started guide
  - Authentication setup
  - First API call examples
  - Common patterns and troubleshooting

- **API-Governance-Framework.md** (33 KB)
  - API review and change management processes
  - Breaking change policies
  - Testing, security, and performance standards
  - Quality metrics and compliance audits

---

### 🎯 Domain-Contracts/
**Complete API contracts by bounded context**

- **Client-Profile-API-Contracts.md** (101 KB)
  - Client Profile domain (CRM Bounded Context)
  - 34 endpoints with full CRUD operations
  - 9 API families: Demographics, Contact Details, Address, Vulnerability, Data Protection, Marketing, ID Verification, Estate Planning, Tax Details
  - OpenAPI 3.1 specifications with examples

- **FactFind-Core-API-Contracts.md** (118 KB)
  - FactFind Core domain
  - 44 endpoints with full CRUD operations
  - 7 API families: Employment, Income, Budget, Expenditure, Assets, Liabilities, Notes
  - NEW APIs: Assets (7 endpoints), Affordability
  - 85+ OpenAPI 3.1 schemas

- **Portfolio-Plans-API-Contracts.md** (86 KB)
  - Portfolio Plans domain
  - 92 endpoints with full CRUD operations
  - 9 API families: Pensions, Protection, Investments, Savings, Mortgages, Equity Release, Loans, Credit Cards, Current Accounts
  - 1,773 plan types with polymorphic discriminator pattern

- **Goals-Risk-API-Contracts.md** (76 KB)
  - Goals & Risk domain (Requirements microservice + ATR)
  - 36 endpoints with event-driven architecture
  - Goals API with 7 polymorphic types
  - Risk Assessment API with ATR integration
  - Event schemas documented

---

### 📚 Supporting-Documents/
**Guidelines, summaries, and quick references**

- **API-Design-Guidelines-Summary.md** (32 KB)
  - Complete extraction from company API Design Guidelines 2.0
  - REST principles, naming conventions, HTTP methods
  - Data types, HATEOAS, headers, documentation standards
  - Do's and Don'ts checklist

- **FactFind-Core-Summary.md** (14 KB)
  - FactFind Core domain executive summary
  - Quick overview of achievements
  - Implementation checklist

- **Portfolio-Plans-Summary.md** (22 KB)
  - Portfolio Plans domain executive summary
  - Plan type categorization
  - Integration patterns

- **Portfolio-Plans-Quick-Reference.md** (18 KB)
  - Developer cheat sheet for Plans API
  - Common operations and examples
  - TypeScript integration examples
  - Troubleshooting guide

- **Client-Profile-Quick-Reference.md** (9 KB)
  - Client Profile domain quick reference
  - API family overview

---

## 🚀 Quick Start Guide

### 1. For First-Time Users
**Read:** Master-Documents/API-Implementation-Complete.md (5 minutes)
- Understand scope and coverage
- Review success criteria
- Check implementation readiness

### 2. For Developers
**Read:** Master-Documents/API-Quick-Start-Guide.md (5 minutes)
- Set up authentication
- Make your first API call
- Learn common patterns

**Use:** Master-Documents/openapi-factfind-complete.yaml ⭐ NEW
- Import into Swagger UI for interactive docs
- Generate client SDKs (C#, TypeScript, Java, Python)
- Import into Postman for testing
- Aligned with domain architecture (42 tables, 8 bounded contexts)
- Production-ready features

### 3. For Architects
**Read:** Master-Documents/API-Master-Specification.md (90 minutes)
- Complete system overview
- Integration patterns
- Domain boundaries

**Then review domain-specific contracts:**
- Domain-Contracts/Client-Profile-API-Contracts.md
- Domain-Contracts/FactFind-Core-API-Contracts.md
- Domain-Contracts/Portfolio-Plans-API-Contracts.md
- Domain-Contracts/Goals-Risk-API-Contracts.md

### 4. For QA/Testing
**Read:** Master-Documents/API-Governance-Framework.md
- Testing requirements
- Quality standards
- Contract validation

**Use:** Master-Documents/openapi-factfind-complete.yaml ⭐ NEW
- Contract testing with Pact/Dredd
- Generate test data
- Validate responses
- RFC 7807 error format validation

---

## 🛠️ Common Tasks

### View Interactive API Documentation
```bash
# Using Swagger UI (NEW SPEC)
npx swagger-ui-dist -p 8080 Master-Documents/openapi-factfind-complete.yaml

# Or upload to https://editor.swagger.io
```

### Validate OpenAPI Specification
```bash
# Using Spectral (recommended for OpenAPI 3.1)
npx @stoplight/spectral-cli lint Master-Documents/openapi-factfind-complete.yaml

# Using swagger-cli
npx @apidevtools/swagger-cli validate Master-Documents/openapi-factfind-complete.yaml
```

### Generate Server Stubs
```bash
# ASP.NET Core
npx @openapitools/openapi-generator-cli generate \
  -i Master-Documents/openapi-factfind-complete.yaml \
  -g aspnetcore -o ./server
```

### Generate Client SDKs
```bash
# TypeScript Client (recommended)
npx openapi-typescript Master-Documents/openapi-factfind-complete.yaml -o types.ts

# C# Client
nswag openapi2csclient \
  /input:Master-Documents/openapi-factfind-complete.yaml \
  /output:Client.cs

# Python Client
npx @openapitools/openapi-generator-cli generate \
  -i Master-Documents/openapi-factfind-complete.yaml \
  -g python -o ./clients/python
```

### Import to Testing Tools
- **Postman:** Import → File → Select openapi-factfind-complete.yaml
- **Insomnia:** Import → From File → Select openapi-factfind-complete.yaml

---

## 📊 Coverage Statistics

### Comprehensive Spec (openapi-factfind-complete.yaml)
- **Total Endpoints Planned:** 206 endpoints
- **Foundation Implemented:** 28+ paths (Client, Employment, Income, Budget)
- **Total Schemas:** 20+ implemented, 60+ planned
- **API Families:** 30+ organized by domain
- **Plan Types:** 1,773 documented (Portfolio Plans discriminator pattern)
- **Bounded Contexts:** 8 (Client Profile, FactFind Core, Portfolio Plans, Goals & Risk, ATR, Notes, Reference Data, Cross-cutting)
- **Database Tables:** 42 tables aligned with ERD
- **API Coverage:** 81%

### By Domain:
- **Client Profile (CRM):** 34 endpoints planned, 10 paths implemented
- **FactFind Core:** 44 endpoints planned, 18 paths implemented
- **Portfolio Plans:** 92 endpoints planned (1,773 plan types, gold standard)
- **Goals & Risk:** 36 endpoints planned (Requirements microservice)
- **ATR:** 15 endpoints planned
- **Notes:** 3 endpoints (unified discriminator API)

---

## 🎯 Quick Navigation by Role

### Executives
1. Master-Documents/API-Implementation-Complete.md
2. Supporting-Documents/FactFind-Core-Summary.md

### Product Owners
1. Master-Documents/API-Master-Specification.md
2. Each domain-specific contract in Domain-Contracts/

### Architects
1. Master-Documents/API-Master-Specification.md
2. Supporting-Documents/API-Design-Guidelines-Summary.md
3. All domain contracts

### Developers
1. Master-Documents/API-Quick-Start-Guide.md ⭐ START HERE
2. Master-Documents/openapi-factfind-complete.yaml ⭐ OpenAPI SPEC
3. Master-Documents/OpenAPI-Complete-Summary.md
4. Supporting-Documents/Portfolio-Plans-Quick-Reference.md

### QA/Testing
1. Master-Documents/API-Governance-Framework.md
2. Master-Documents/openapi-factfind-complete.yaml ⭐ OpenAPI SPEC
3. Contract testing with Spectral validation

---

## ✅ Key Features (openapi-factfind-complete.yaml)

### Architecture Alignment
- ✅ **Domain-driven design** - 8 bounded contexts from Complete-Domain-Model.md
- ✅ **ERD precision** - 42 tables aligned with Complete-ERD.md schemas
- ✅ **Proven patterns** - Polymorphic discriminator, unified routing, event-driven

### Production-Ready Features
- ✅ **OpenAPI 3.1** - Full JSON Schema 2020-12 compliance
- ✅ **RFC 7807 errors** - Problem Details format throughout
- ✅ **HATEOAS Level 3** - Hypermedia navigation links
- ✅ **Optimistic concurrency** - ETags with If-Match headers
- ✅ **Pagination** - Cursor-based (recommended) + offset-based (legacy)
- ✅ **Filtering** - OData subset support ($filter, $orderby)
- ✅ **Rate limiting** - Headers and 429 responses
- ✅ **Deprecation policy** - Sunset headers, 12-month notice

### Data Standards
- ✅ **ISO 8601** - Dates and times (UTC)
- ✅ **ISO 4217** - Currency codes (3-letter)
- ✅ **ISO 3166** - Country codes (2-letter)
- ✅ **Comprehensive validation** - Min/max, patterns, enums, constraints
- ✅ **Audit trails** - Created/updated by/at, versioning

### Code Generation
- ✅ **TypeScript** - openapi-typescript ready
- ✅ **C#** - NSwag, AutoRest ready
- ✅ **Java** - OpenAPI Generator ready
- ✅ **Python** - openapi-python-client ready

---

## 🔗 Related Folders

- **../Analysis/** - Coverage analysis and implementation roadmap
- **../Domain-Architecture/** - Domain models, ERD diagrams, and architecture patterns
- **../Navigation/** - Master navigation index (FINAL-STRUCTURE.md)
- **../../Context/** - Source code repositories and database schemas

---

## 📞 Support

For questions about:
- **API Design:** See Master-Documents/API-Governance-Framework.md
- **Implementation:** See Master-Documents/API-Master-Specification.md
- **Navigation:** See ../Navigation/FINAL-STRUCTURE.md

---

## 🆕 What's New (February 2026)

### Comprehensive OpenAPI Specification (openapi-factfind-complete.yaml)
- ✅ **Authoritative specification** aligned with consolidated domain architecture
- ✅ **42 tables** from Complete-ERD.md precisely mapped
- ✅ **8 bounded contexts** from Complete-Domain-Model.md documented
- ✅ **Proven patterns** from API-Architecture-Patterns.md applied
- ✅ **Production-ready** features (RFC 7807, HATEOAS Level 3, concurrency control)
- ✅ **Code generation ready** for TypeScript, C#, Java, Python SDKs

See **Master-Documents/OpenAPI-Complete-Summary.md** for complete details.

---

**Last Updated:** February 13, 2026
**OpenAPI Version:** 3.1.0
**Status:** Authoritative foundation - ready for systematic extension
