# FactFind Entities - Complete Architecture & API Specification

**Project Status:** Production-Ready ✅
**Last Updated:** February 13, 2026
**Version:** 3.1.0

---

## 📋 Project Overview

This repository contains the **complete architectural analysis, domain modeling, and API specification** for the FactFind system. It represents the authoritative documentation for modernizing and consolidating the legacy FactFind monolith into a well-architected, domain-driven system.

### What This Project Delivers

✅ **Complete Domain Architecture** - 8 bounded contexts with 48+ entities across 42 database tables
✅ **Comprehensive API Specification** - 238 RESTful endpoints with OpenAPI 3.1 specification
✅ **Coverage Analysis** - 81% API coverage (50/62 FactFind sections), 92% database coverage
✅ **Implementation Roadmap** - 20-week delivery plan with phased approach
✅ **Source Traceability** - Complete mapping from legacy systems to modern architecture

### Key Achievements

🎯 **V4 Corrections**: Corrected coverage from initial 42% estimate to actual 81%
🎯 **Portfolio Plans Discovery**: Identified complete API for 1,773 plan types
🎯 **Unified Architecture**: Consolidated 3 monoliths + 1 microservice into coherent domain model
🎯 **SDK-Ready APIs**: Production-ready OpenAPI 3.1 spec for automated client generation
🎯 **Regulatory Compliance**: FCA vulnerability tracking, GDPR consent, KYC/AML verification

---

## 📂 Repository Structure

```
FactFind-Entities/
├── README.md                    # ⭐ This file - Project overview
│
├── 📁 steering/                 # 🎯 AUTHORITATIVE DOCUMENTATION
│   ├── Navigation/              # Master navigation and structure
│   ├── Analysis/                # Coverage analysis and roadmap
│   ├── Domain-Architecture/     # Domain models, ERDs, patterns
│   └── API-Docs/                # API specifications and contracts
│
├── 📁 Context/                  # 📚 SOURCE MATERIALS
│   ├── README.md                # Context documentation guide
│   ├── Monolith.Crm/            # CRM codebase analysis
│   ├── Monolith.FactFind/       # FactFind codebase analysis
│   ├── Monolith.Portfolio/      # Portfolio codebase analysis
│   ├── Microservice.Requirement/# Requirements microservice
│   ├── IntelligentOffice/       # Legacy system analysis
│   ├── schema/                  # Database schema exports
│   └── [Source Documents]       # Excel, Word, JSON specs
│
├── 📁 analysis/                 # Working analysis artifacts
└── 📁 API-Docs/                 # Additional API documentation
```

### Folder Purposes

| Folder | Purpose | Status |
|--------|---------|--------|
| **steering/** | Authoritative, consolidated outputs | ✅ Production-Ready |
| **Context/** | Source materials and legacy analysis | 📚 Reference-Only |
| **analysis/** | Working analysis artifacts | 🔧 Historical |
| **API-Docs/** | Additional API documentation | 📝 Supplementary |

---

## 🎯 Quick Start by Role

### 👔 **Executives** (15 minutes)
Start here for high-level overview and business value:

1. **📊 [Coverage Executive Summary](steering/Analysis/Coverage-Executive-Summary.md)**
   - Business value proposition
   - Key statistics (81% coverage, 238 endpoints)
   - Implementation timeline (20 weeks)

2. **🎯 [Implementation Roadmap](steering/Analysis/Implementation-Roadmap.md)**
   - Phased delivery approach
   - Resource requirements
   - Risk mitigation

### 📊 **Product Owners** (1-2 hours)
Understand scope, coverage, and planning:

1. **📈 [Coverage Analysis Complete](steering/Analysis/Coverage-Analysis-Complete.md)** ⭐
   - Detailed coverage breakdown by domain
   - V4 corrections and discoveries
   - Gap analysis and recommendations

2. **🗺️ [Implementation Roadmap](steering/Analysis/Implementation-Roadmap.md)**
   - 20-week delivery plan
   - Sprint-by-sprint breakdown
   - Dependencies and risks

3. **📋 [FactFind Coverage Matrix](steering/Analysis/FactFind-Coverage-Matrix.md)**
   - Section-by-section coverage table
   - API and database coverage details

### 🏛️ **Architects** (4-6 hours)
Deep dive into domain architecture and patterns:

1. **🏗️ [Complete Domain Model](steering/Domain-Architecture/Complete-Domain-Model.md)** ⭐
   - 8 bounded contexts with relationships
   - 6 Mermaid diagrams
   - Entity catalog (48+ entities)
   - Cross-layer mappings (Legacy → Target → API)

2. **🗄️ [Complete ERD](steering/Domain-Architecture/Complete-ERD.md)** ⭐
   - 42 database tables across 5 databases
   - 14 ERD diagrams with relationships
   - Full column specifications

3. **🔌 [API Master Specification](steering/API-Docs/Master-Documents/API-Master-Specification.md)**
   - 238 endpoints organized by domain
   - Request/response patterns
   - Security and authentication

4. **⚙️ [API Architecture Patterns](steering/Domain-Architecture/API-Architecture-Patterns.md)**
   - 5 proven architectural patterns
   - Polymorphic discriminators
   - HATEOAS implementation
   - Event-driven integration

### 💻 **Developers** (30 minutes - 2 hours)
Get started with API implementation:

1. **🚀 [API Quick Start Guide](steering/API-Docs/Master-Documents/API-Quick-Start-Guide.md)** ⭐
   - Authentication setup
   - Common patterns
   - Code examples
   - Error handling

2. **📜 [OpenAPI Specification](steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml)** ⭐
   - **Production-ready OpenAPI 3.1 spec**
   - 238 endpoints with full schemas
   - SDK generation ready (TypeScript, C#, Java, Python)
   - 2,500+ lines of comprehensive definitions

3. **📦 Domain API Contracts** (in [steering/API-Docs/Domain-Contracts/](steering/API-Docs/Domain-Contracts/))
   - Client Profile API Contracts
   - FactFind Core API Contracts
   - Portfolio Plans API Contracts
   - Goals & Risk API Contracts

### 🧪 **QA Engineers** (1-2 hours)
Test planning and validation:

1. **📏 [API Governance Framework](steering/API-Docs/Master-Documents/API-Governance-Framework.md)** ⭐
   - API standards and guidelines
   - Testing requirements
   - Quality gates

2. **📜 [OpenAPI Specification](steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml)**
   - Complete endpoint catalog for test coverage
   - Request/response schemas for validation
   - Error scenarios

3. **✅ [Coverage Matrix](steering/Analysis/FactFind-Coverage-Matrix.md)**
   - Section-by-section validation checklist

---

## 📊 Key Statistics

### Coverage Metrics
- **API Coverage:** 81% (50 of 62 FactFind sections)
- **Database Coverage:** 92% (57 of 62 sections)
- **Total Endpoints:** 238 across 8 bounded contexts
- **Plan Type Support:** 1,773 plan types via discriminator pattern

### Domain Breakdown
| Domain | Endpoints | Tables | Coverage |
|--------|-----------|--------|----------|
| **Client (CRM)** | 37 | 10 | 91% (10/11) |
| **FactFind Core** | 44 | 8 | 100% (8/8) |
| **Portfolio Plans** | 92 | 13 | 100% (13/13) |
| **Goals & Risk** | 36 | 7 | 100% (4/4) |
| **Notes** | 5 | 1 unified | 100% |
| **ATR** | 15 | 4 | 63% (5/8) |
| **Reference Data** | 3+ | varies | Partial |
| **TOTAL** | **238** | **42** | **81%** |

### Architecture Artifacts
- **Bounded Contexts:** 8 fully documented
- **Database Tables:** 42 with complete schemas
- **Mermaid Diagrams:** 20 (6 domain + 14 ERD)
- **OpenAPI Specification:** 2,500+ lines
- **Total Documentation:** 31+ markdown files

---

## 🗂️ Steering Documentation (Authoritative)

### 📍 Master Navigation
**👉 [FINAL-STRUCTURE.md](steering/Navigation/FINAL-STRUCTURE.md)** ⭐ **Complete documentation index**

### 📊 Analysis Folder
Strategic analysis and implementation planning:

- **[Coverage Executive Summary](steering/Analysis/Coverage-Executive-Summary.md)** - 15-minute executive briefing
- **[Coverage Analysis Complete](steering/Analysis/Coverage-Analysis-Complete.md)** - Comprehensive coverage breakdown
- **[Implementation Roadmap](steering/Analysis/Implementation-Roadmap.md)** - 20-week delivery plan
- **[FactFind Coverage Matrix](steering/Analysis/FactFind-Coverage-Matrix.md)** - Section-by-section table

### 🏗️ Domain-Architecture Folder
Domain modeling and database design:

- **[Complete Domain Model](steering/Domain-Architecture/Complete-Domain-Model.md)** - 8 bounded contexts, 6 diagrams
- **[Complete ERD](steering/Domain-Architecture/Complete-ERD.md)** - 42 tables, 14 ERD diagrams
- **[Complete Domain Analysis](steering/Domain-Architecture/Complete-Domain-Analysis.md)** - Findings & technical debt
- **[API Architecture Patterns](steering/Domain-Architecture/API-Architecture-Patterns.md)** - 5 proven patterns
- **[API Domain Analysis](steering/Domain-Architecture/API-Domain-Analysis.md)** - 24+ controllers
- **[Client-FactFind Boundary Analysis](steering/Domain-Architecture/Client-FactFind-Boundary-Analysis.md)** - Context boundaries

### 🔌 API-Docs Folder
Complete API specifications and contracts:

#### Master Documents
- **[openapi-factfind-complete.yaml](steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml)** ⭐ OpenAPI 3.1 specification (238 endpoints)
- **[API-Quick-Start-Guide.md](steering/API-Docs/Master-Documents/API-Quick-Start-Guide.md)** ⭐ Developer onboarding
- **[API-Master-Specification.md](steering/API-Docs/Master-Documents/API-Master-Specification.md)** - Detailed endpoint catalog
- **[API-Governance-Framework.md](steering/API-Docs/Master-Documents/API-Governance-Framework.md)** - Standards and guidelines
- **[API-Implementation-Complete.md](steering/API-Docs/Master-Documents/API-Implementation-Complete.md)** - Implementation summary

#### Domain Contracts
- **[Client-Profile-API-Contracts.md](steering/API-Docs/Domain-Contracts/Client-Profile-API-Contracts.md)** - CRM API contracts
- **[FactFind-Core-API-Contracts.md](steering/API-Docs/Domain-Contracts/FactFind-Core-API-Contracts.md)** - FactFind API contracts
- **[Portfolio-Plans-API-Contracts.md](steering/API-Docs/Domain-Contracts/Portfolio-Plans-API-Contracts.md)** - Portfolio API contracts
- **[Goals-Risk-API-Contracts.md](steering/API-Docs/Domain-Contracts/Goals-Risk-API-Contracts.md)** - Goals API contracts

#### Supporting Documents
- **[API-Design-Guidelines-Summary.md](steering/API-Docs/Supporting-Documents/API-Design-Guidelines-Summary.md)** - Design guidelines
- **[API-Design-Guidelines-Traceability-Matrix.md](steering/API-Docs/Supporting-Documents/API-Design-Guidelines-Traceability-Matrix.md)** - Standards traceability
- **[OpenAPI-Complete-Summary.md](steering/API-Docs/Supporting-Documents/OpenAPI-Complete-Summary.md)** - OpenAPI overview

---

## 📚 Context Documentation (Source Materials)

The `Context/` folder contains source materials from legacy system analysis:

**👉 [Context/README.md](Context/README.md)** - Complete context documentation guide

### Key Context Artifacts
- **Source Documents:** API specs, Excel analysis, legacy Swagger
- **Codebase Analysis:** Monolith.Crm, Monolith.FactFind, Monolith.Portfolio
- **Microservice Analysis:** Microservice.Requirement (modern DDD architecture)
- **Database Schemas:** SQL exports from 5 databases (42 tables)
- **Legacy System:** IntelligentOffice analysis (1,773 plan types)

**Important:** Context is for historical reference. Use `steering/` for authoritative documentation.

---

## 🎯 V4 Corrections & Key Discoveries

### Coverage Correction
- **Initial Estimate (V1-V3):** 42% API coverage ❌
- **V4 Corrected:** 81% API coverage (50/62 sections) ✅
- **Root Cause:** Portfolio Plans API was fully implemented but undocumented

### Critical Discoveries

1. **Portfolio Plans API** - Complete coverage of 1,773 plan types
   - Pensions, Protection, Investments, Mortgages, Savings, Loans
   - Polymorphic discriminator via RefPlanSubCategoryId

2. **Protection Plans Structure** - Corrected polymorphic hierarchy
   - RefPlanSubCategoryId discriminator: 51=PersonalProtection, 47=GeneralInsurance
   - AssuredLife entities: 0-2 per policy (not 1-1)
   - Benefits: Main + additional per life, max 4 per policy

3. **Unified Notes API** - Single discriminator endpoint
   - Abstracts 10 note types through one API
   - Resolves scattered table technical debt

4. **Requirements Microservice** - Modern DDD architecture
   - GUID identifiers (not int32)
   - Entity Framework Core (not Hibernate)
   - Domain events for cross-context integration
   - 7 polymorphic objective types

---

## 🚀 Implementation Approach

### Phased Delivery (20 weeks)

#### **Phase 1: Foundation** (Weeks 1-4)
- Core infrastructure and authentication
- Client API (37 endpoints)
- Database setup

#### **Phase 2: FactFind Core** (Weeks 5-8)
- Employment and Income APIs (44 endpoints)
- Budget and expenditure tracking

#### **Phase 3: Portfolio Plans** (Weeks 9-14)
- Base plans and pensions (92 endpoints)
- Protection plans with corrected structure
- Investments, mortgages, savings

#### **Phase 4: Goals & Integration** (Weeks 15-18)
- Goals & Risk APIs (36 endpoints)
- ATR assessments (15 endpoints)
- Cross-context integration

#### **Phase 5: Polish & Launch** (Weeks 19-20)
- Testing and validation
- Documentation finalization
- Production deployment

---

## 🔧 Technical Architecture

### API Standards
- **Protocol:** RESTful HTTP/1.1
- **Format:** JSON (application/json)
- **Specification:** OpenAPI 3.1
- **Architecture:** HATEOAS Level 3
- **Authentication:** OAuth 2.0 with granular scopes (30+)
- **Error Format:** RFC 7807 Problem Details
- **Concurrency:** Optimistic locking with ETags

### Data Standards
- **Dates:** ISO 8601 (YYYY-MM-DD, UTC)
- **Currency:** ISO 4217 (3-letter codes: GBP, EUR, USD)
- **Countries:** ISO 3166-1 alpha-2 (GB, US, FR)
- **Naming:** camelCase properties, PascalCase types

### Bounded Contexts
1. **Client Domain (CRM)** - Identity, demographics, compliance
2. **FactFind Core** - Financial situation capture
3. **Portfolio Plans** - Product holdings (1,773 types)
4. **Goals & Risk** - Objectives and risk profiling
5. **ATR** - Attitude to Risk assessments
6. **Notes Management** - Unified notes (10 types)
7. **Reference Data** - Lookups and enumerations

### Integration Patterns
- **Polymorphic Discriminators** - Plan types, client types, objectives
- **HATEOAS Links** - Discoverable API navigation
- **Domain Events** - Cross-context integration (Requirements microservice)
- **Anti-Corruption Layer** - Legacy system integration
- **Shared Kernel** - Common types (Money, Date, Address)

---

## 📖 Documentation Standards

### File Naming Convention
- **No version numbers** in file names (removed V3, V4 suffixes)
- **Descriptive names** for audience clarity
- **Consistent prefixes** (API-, Complete-, Coverage-)

### Documentation Levels
1. **Executive** - 15-minute summaries with business focus
2. **Strategic** - 1-2 hour analyses for product owners
3. **Architectural** - 4-6 hour deep dives with diagrams
4. **Technical** - Developer and QA implementation guides

### Cross-References
All documents use relative paths and maintain bidirectional traceability:
- Context sources → Steering outputs
- Analysis → Domain models → API specs
- Legacy entities → Target entities → API endpoints

---

## 🛠️ For Developers

### SDK Generation
The OpenAPI specification is ready for automated client generation:

```bash
# TypeScript
npx openapi-typescript steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml --output factfind-api.d.ts

# C# (NSwag)
nswag openapi2csclient /input:steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml /output:FactFindClient.cs

# Java
openapi-generator-cli generate -i steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml -g java -o ./factfind-client

# Python
openapi-python-client generate --path steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml
```

### API Base URLs
- **Production:** `https://api.intelliflo.com/v3`
- **Staging:** `https://api-staging.intelliflo.com/v3`
- **Development:** `https://api-dev.intelliflo.com/v3`
- **Local:** `http://localhost:8080/v3`

### Key Endpoints Examples
```
GET    /v3/clients                          # List all clients
GET    /v3/clients/{clientId}               # Get client details
POST   /v3/clients/{clientId}/employments   # Create employment
GET    /v3/clients/{clientId}/plans         # List portfolio plans
POST   /v3/clients/{clientId}/goals         # Create financial goal
```

---

## 📞 Support & Contact

### Documentation Issues
For questions or corrections to this documentation:
- **Repository:** Internal Git repository
- **Maintained By:** Architecture Team
- **Last Updated:** February 13, 2026

### Architecture Decisions
Refer to architecture decision records in:
- `steering/Domain-Architecture/API-Architecture-Patterns.md`
- `steering/Domain-Architecture/Complete-Domain-Analysis.md`

---

## ✅ Project Status

| Deliverable | Status | Location |
|-------------|--------|----------|
| Domain Model | ✅ Complete | [steering/Domain-Architecture/Complete-Domain-Model.md](steering/Domain-Architecture/Complete-Domain-Model.md) |
| Database ERD | ✅ Complete | [steering/Domain-Architecture/Complete-ERD.md](steering/Domain-Architecture/Complete-ERD.md) |
| API Specification | ✅ Complete | [steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml](steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml) |
| Coverage Analysis | ✅ Complete | [steering/Analysis/Coverage-Analysis-Complete.md](steering/Analysis/Coverage-Analysis-Complete.md) |
| Implementation Plan | ✅ Complete | [steering/Analysis/Implementation-Roadmap.md](steering/Analysis/Implementation-Roadmap.md) |
| API Contracts | ✅ Complete | [steering/API-Docs/Domain-Contracts/](steering/API-Docs/Domain-Contracts/) |

**Overall Status:** 🎯 **Production-Ready** - All deliverables complete and validated

---

## 🎓 Learning Path

### New to the Project? Start Here:

1. **Understand the Scope** (15 min)
   - Read this README
   - Review [Coverage Executive Summary](steering/Analysis/Coverage-Executive-Summary.md)

2. **Explore the Architecture** (1 hour)
   - Browse [Complete Domain Model](steering/Domain-Architecture/Complete-Domain-Model.md)
   - Review [API Architecture Patterns](steering/Domain-Architecture/API-Architecture-Patterns.md)

3. **Try the APIs** (30 min)
   - Read [API Quick Start Guide](steering/API-Docs/Master-Documents/API-Quick-Start-Guide.md)
   - Explore [OpenAPI Specification](steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml)

4. **Understand the Context** (optional)
   - Review [Context/README.md](Context/README.md) for historical background
   - Explore legacy system analysis in `Context/` folders

---

## 📌 Key Links

### Most Important Documents
- ⭐ **[Master Navigation](steering/Navigation/FINAL-STRUCTURE.md)** - Complete documentation index
- ⭐ **[OpenAPI Specification](steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml)** - 238 endpoints
- ⭐ **[Complete Domain Model](steering/Domain-Architecture/Complete-Domain-Model.md)** - 8 bounded contexts
- ⭐ **[Coverage Analysis](steering/Analysis/Coverage-Analysis-Complete.md)** - V4 corrected (81%)
- ⭐ **[API Quick Start](steering/API-Docs/Master-Documents/API-Quick-Start-Guide.md)** - Developer guide

### Reference
- [Context Documentation](Context/README.md) - Source materials guide
- [FactFind Sections Reference](Context/FactFind-Sections-Reference.md) - 62 section catalog

---

**Version:** 3.1.0
**Status:** Production-Ready ✅
**Maintained By:** Architecture Team
**Last Updated:** February 13, 2026

---

*This repository represents the complete architectural foundation for the FactFind system modernization initiative. All documentation is production-ready and suitable for immediate implementation.*
