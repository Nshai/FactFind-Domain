# Target Model - FactFind System Architecture

**Purpose:** This folder contains the **target state architecture** for the FactFind system, representing the desired future state after implementing all identified gaps and improvements.

**Status:** Target Architecture - For Implementation
**Date:** February 16, 2026
**Version:** 1.0

---

## Overview

The Target Model represents the **complete, production-ready architecture** for the FactFind system incorporating:

1. ✅ All entities from FactFind Data Analysis v6.1.xlsx
2. ✅ All missing entities identified in gap analysis
3. ✅ All missing fields (1,004+ fields) added to existing tables
4. ✅ New bounded contexts (Estate Planning, Professional Network)
5. ✅ FactFind as root aggregate pattern (DDD)
6. ✅ Complete referential integrity with proper cascade rules
7. ✅ Performance optimization with comprehensive indexing
8. ✅ Multi-tenancy with Row-Level Security
9. ✅ All business rules enforced via constraints

---

## Target Model Documents

### 1. **Greenfield-ERD-FactFind.md** ⭐ RECOMMENDED GREENFIELD DESIGN - DATA MODEL

**Completely New Greenfield ERD Design** built from business requirements with zero legacy constraints.

**Approach:**
- Pure Domain-Driven Design (DDD) from first principles
- Based ONLY on business requirements in Fact Find Data Analysis v6.1.xlsx
- Modern aggregate boundaries and bounded contexts
- Event-driven architecture with domain events
- No technical debt or legacy patterns

**Contents:**
- Business domain analysis and capabilities
- Optimal bounded context design (5 contexts)
- Complete entity model with all business fields
- Rich domain models with behavior
- Value objects and domain events
- Modern relationship patterns
- Full SQL DDL with PostgreSQL features
- Microservices deployment architecture
- Performance optimization strategies
- Security and audit patterns

**Bounded Contexts:**
1. **Client Context** - Client identities, relationships, DPA
2. **FactFind Context** - Comprehensive financial fact-finding (root aggregate)
3. **Financial Product Context** - Plans, contributions, valuations
4. **Advice Context** - Advice cases, recommendations, suitability
5. **Reference Data Context** - Product types, providers, organizations

**Why Greenfield:**
- Clean slate design optimized for business needs
- Modern architectural patterns
- No migration complexity from legacy
- Best practices from the start
- Easier to understand and maintain

---

### 2. **Target-ERD-FactFind-Aggregate.md** 📋 INCREMENTAL EVOLUTION

**Incremental Evolution** of existing model addressing identified gaps.

**Approach:**
- Extends current domain architecture
- Adds missing entities and fields
- Maintains backward compatibility
- Lower migration risk

**Contents:**
- 70+ entity definitions
- 12 Mermaid ERD diagrams
- Complete table specifications with all columns
- 108+ foreign key relationships
- ~350 indexes for performance
- Cascade rules and constraints
- Multi-tenancy implementation
- SQL DDL examples

**Coverage:**
- **Client Domain** (10 entities)
- **Employment & Income Domain** (3 entities)
- **Financial Position Domain** (7 entities)
- **Portfolio Plans Domain** (15+ entities with 1,773 plan types)
- **Goals & Requirements Domain** (5 entities)
- **Estate Planning Domain** (4 entities) - NEW
- **Professional Network Domain** (1 entity) - NEW
- **ATR Domain** (4 entities)
- **Notes Domain** (1 unified entity)
- **Reference Data Domain** (20+ entities)

**When to Use:**
- Existing system with large dataset
- Risk-averse organization
- Incremental delivery required
- Team familiar with current architecture

---

### 3. **FactFind-API-Design.md** 🚀 COMPLETE API SPECIFICATION

**Comprehensive RESTful API Design** for the FactFind system based on the Greenfield ERD.

**Contents:**
- **189KB, 6,967 lines** of production-ready API specifications
- **100+ fully documented endpoints** across 10 API domains
- **50+ entity contracts** with complete schemas
- **15+ enumeration value types** (GenderValue, CountryValue, etc.)
- **Single contract principle** - unified DTOs for request/response
- **Value and reference type semantics** - proper DDD patterns
- Complete CRUD operations for all 39 entities
- JSON request/response examples for all operations
- Field-level validation rules and business logic
- Authentication, authorization, and security patterns

**API Domains:**
1. **Client Onboarding & KYC API** (25+ endpoints)
2. **Circumstances API (FactFind)** (25+ endpoints) - Root aggregate
3. **Arrangements API** (30+ endpoints) - Pensions, investments, protection
4. **Goals & Objectives API** (15+ endpoints)
5. **Risk Profile API** (10+ endpoints)
6. **Estate Planning API** (10+ endpoints)
7. **Assets & Liabilities API** (15+ endpoints)
8. **Reference Data API** (20+ endpoints) - Enumerations and lookups
9. **Implementation Guidance** - Caching, rate limiting, versioning
10. **Complete Appendices** - Status codes, error catalog, validations

**Design Principles:**
- RESTful Level 3 with HATEOAS
- Single contract principle (one DTO per entity)
- Value types for enumerations (code/display pattern)
- Reference types for entity relationships (id/href/name pattern)
- OAuth 2.0 authentication with granular scopes
- RFC 7807 Problem Details for errors
- Optimistic concurrency with ETags
- Cursor-based pagination for large datasets

**Industry Standards:**
- FCA Handbook compliant (COBS, PROD, ICOBS)
- MiFID II appropriateness and suitability
- Consumer Duty vulnerable customer support
- GDPR data protection and consent management
- ISO 8601 dates, ISO 4217 currencies, ISO 3166 countries

**Why Use This:**
- Production-ready specifications for immediate implementation
- All 1,786 business fields from ERD mapped to API contracts
- Consistent patterns throughout (reduces learning curve)
- Complete with examples (no guesswork for developers)
- Modern API design best practices applied

---

### 4. **FactFind-API-Design-Summary.md** 📋 EXECUTIVE SUMMARY

**10-page executive overview** of the API design.

**Contents:**
- Key metrics and statistics (100+ endpoints, 50+ DTOs)
- API domain summaries
- Design principles and patterns explained
- Security and authorization overview
- Implementation roadmap
- Success criteria and benefits

**Audience:**
- Product owners and business stakeholders
- Solution architects and technical leads
- Project managers
- Anyone needing high-level API overview

---

## Design Approach Comparison

| Aspect | Greenfield Design | Incremental Evolution |
|--------|------------------|----------------------|
| **Based On** | Pure business requirements | Current model + gaps |
| **Legacy Constraints** | None | Must work with existing |
| **DDD Maturity** | Pure DDD from start | DDD retrofitted |
| **Bounded Contexts** | 5 optimal contexts | 10 contexts (evolved) |
| **Aggregates** | Clear boundaries | Some legacy patterns |
| **Events** | Event-driven core | Events added later |
| **Migration Effort** | Full rebuild | Additive changes |
| **Risk** | Higher (new system) | Lower (incremental) |
| **Long-term Maintainability** | Excellent | Good |
| **Time to Value** | Longer initial | Faster initial |
| **Recommended For** | New implementations | Existing systems |

---

## Key Differences from Current Model

### New Entities Added (8 Critical + 30 Supporting)

#### Critical Missing Entities (P0):
1. **TClientRelationship** (8 fields) - Track family/partner relationships
2. **TIncomeChange** (6 fields) - Project future income changes
3. **TExpenditureChange** (6 fields) - Project future expenditure changes
4. **TGift** (8 fields) - Estate planning gift tracking
5. **TGiftTrust** (4 fields) - Gifts in trust
6. **TDPAPolicy** (4 fields) - GDPR consent tracking
7. **TProfessionalContact** (16 fields) - Professional advisers network
8. **TTag** (1 field) - Entity tagging system

#### Supporting Entities (P1):
- TEstatePlanning - Estate planning summary
- TWill - Will details
- TLPA - Lasting Power of Attorney
- TIHTCalculation - Inheritance Tax calculations
- TAffordability - Lending affordability metrics
- TCreditHistory - Credit score tracking
- Plus 25+ more entities from Excel analysis

### Extended Existing Tables (1,004 Fields Added)

#### Top 5 Extensions:
1. **TPolicyBusiness** - +369 fields (commission, fees, valuations)
2. **TPerson** - +103 fields (health, ID docs, estate planning)
3. **TPension** - +103 fields (contribution/withdrawal history, BCE)
4. **TRequirement** - +90 fields (goal progress tracking)
5. **TFactFind** - +78 fields (budget, affordability, net worth)

### New Bounded Contexts (2)

1. **Estate Planning Context**
   - Gift tracking (7-year rule for IHT)
   - Trust structures
   - Will and LPA management
   - Inheritance Tax calculations

2. **Professional Network Context**
   - Professional contacts (solicitors, accountants, IFAs)
   - Referral tracking
   - Collaboration workflows

---

## Architecture Principles

### 1. **Root Aggregate Pattern**
- FactFind is the single root aggregate
- All child entities owned by FactFind
- All operations go through aggregate root
- Transactional consistency maintained

### 2. **Referential Integrity**
- Every child entity has FactFindId FK
- Proper cascade rules (CASCADE for children, NO ACTION for external)
- 108+ foreign key relationships defined
- Orphan records prevented

### 3. **Performance Optimization**
- ~350 indexes across all tables
- 4 indexing patterns (standard, covering, filtered, temporal)
- Filtered indexes for active records
- Covering indexes for common queries

### 4. **Multi-Tenancy**
- Row-Level Security (RLS) on all tables
- TenantId on every table
- Session context for tenant isolation
- Tenant-specific reference data (TenantId = 0 for global)

### 5. **Data Integrity**
- 60+ check constraints enforcing business rules
- 25+ unique constraints preventing duplicates
- Computed columns for calculated fields (PERSISTED)
- Audit trail on all entities (Created/Updated fields)

### 6. **Concurrency Control**
- Optimistic locking with RowVersion (rowversion)
- ETag-based API concurrency
- Conflict detection and resolution

### 7. **Soft Delete Pattern**
- IsDeleted flag on all tables
- Filtered indexes WHERE IsDeleted = 0
- Audit trail preserved for deleted records
- Compliance with data retention policies

---

## Implementation Roadmap

### Phase 1: Critical Entities (Weeks 1-2) - P0
**Effort:** 2 weeks

**Tasks:**
1. Create 8 critical missing entities
   - TClientRelationship, TIncomeChange, TExpenditureChange
   - TGift, TGiftTrust, TDPAPolicy
   - TProfessionalContact, TTag

2. Implement with:
   - Complete FK constraints
   - Proper cascade rules
   - Multi-tenancy support
   - Audit trail
   - Indexes

3. Update APIs:
   - Add endpoints for new entities
   - Implement DTOs
   - Add business logic

### Phase 2: Table Extensions (Weeks 3-6) - P1
**Effort:** 4 weeks

**Tasks:**
1. Extend 5 major tables (1,004 fields total)
   - TPolicyBusiness (+369 fields)
   - TPerson (+103 fields)
   - TPension (+103 fields)
   - TRequirement (+90 fields)
   - TFactFind (+78 fields)

2. Create supporting entities:
   - TEstatePlanning, TWill, TLPA, TIHTCalculation
   - TAffordability, TCreditHistory
   - 25+ additional entities

3. Update domain model:
   - Add new aggregates (EstatePlan, IncomeProjection)
   - Define domain events
   - Implement domain services

### Phase 3: Reference Data (Week 7) - P1
**Effort:** 1 week

**Tasks:**
1. Validate product types (200+ types in TRefProductSubType)
2. Create TRefIncomeType (40+ types)
3. Create TRefExpenditureType (30+ types)
4. Review and add 27 reference lists

### Phase 4: Domain Services (Weeks 8-10) - P1
**Effort:** 3 weeks

**Tasks:**
1. AffordabilityCalculationService
2. IHTCalculationService
3. CashFlowProjectionService
4. NetWorthCalculationService

### Phase 5: Testing & Validation (Weeks 11-12) - All
**Effort:** 2 weeks

**Tasks:**
1. Unit tests for new repositories
2. Integration tests for workflows
3. Performance testing for queries
4. User acceptance testing
5. Data migration validation

**Total Implementation:** 12 weeks for complete target model

---

## Migration Strategy

### Approach: Additive Only (Low Risk)

**Principles:**
1. ✅ All new tables (no data loss)
2. ✅ All new fields nullable or with defaults (backward compatible)
3. ✅ No breaking changes to existing APIs
4. ✅ Feature flags for new functionality
5. ✅ Dual-run period (old + new APIs)

**Steps:**

1. **Database Migration**
   - Create new tables (no data migration needed)
   - Add new columns to existing tables (nullable/defaults)
   - Create indexes
   - Add constraints
   - Deploy RLS policies

2. **API Migration**
   - Add new endpoints (v3 API)
   - Extend existing DTOs (optional fields)
   - Maintain v2 API compatibility
   - Gradual client migration

3. **Application Migration**
   - Add new domain services
   - Update aggregate roots
   - Implement domain events
   - Feature flags for rollout

4. **Testing & Rollout**
   - Staging environment testing
   - Canary deployment
   - Monitor performance
   - Gradual rollout to production

---

## Success Metrics

### Technical Metrics

| Metric | Current | Target | Improvement |
|--------|---------|--------|-------------|
| **Entities** | 40 | 70+ | +30 entities |
| **Fields** | ~780 | 1,784+ | +1,004 fields |
| **API Coverage** | 81% | 95%+ | +14% |
| **Database Coverage** | 92% | 98%+ | +6% |
| **Foreign Keys** | ~60 | 108+ | +48 relationships |
| **Indexes** | ~150 | ~350 | +200 indexes |
| **Bounded Contexts** | 6 | 10 | +4 contexts |

### Business Metrics

| Capability | Current | Target |
|------------|---------|--------|
| **Estate Planning** | ❌ No | ✅ Complete |
| **Cash Flow Projection** | ❌ No | ✅ Complete |
| **Affordability Checks** | ❌ No | ✅ Complete |
| **GDPR Compliance** | ⚠️ Partial | ✅ Complete |
| **Professional Network** | ❌ No | ✅ Complete |
| **Commission Tracking** | ⚠️ Partial | ✅ Complete |
| **IHT Planning** | ❌ No | ✅ Complete |
| **Risk Profiling** | ⚠️ Partial | ✅ Complete |

---

## Related Documents

### Gap Analysis
- **steering/Analysis/ERD-Gap-Analysis.md** - Detailed ERD-level gaps
- **steering/Analysis/Domain-Analysis-Gap-Summary.md** - Combined domain and ERD gaps

### Current Model (Baseline)
- **steering/Domain-Architecture/Complete-ERD.md** - Current ERD baseline
- **steering/Domain-Architecture/Complete-Domain-Model.md** - Current domain model
- **steering/Domain-Architecture/Complete-Domain-Analysis.md** - Current analysis

### API Specifications
- **steering/Target-Model/FactFind-API-Design.md** - Complete RESTful API specification (NEW)
- **steering/Target-Model/FactFind-API-Design-Summary.md** - API design executive summary (NEW)
- **steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml** - Legacy API specification

### Design Documents
- **steering/Domain-Architecture/FactFind-Facade-Design.md** - Facade pattern design
- **steering/Domain-Architecture/API-Architecture-Patterns.md** - API patterns

---

## Governance & Approval

### Stakeholder Sign-off Required

| Stakeholder | Role | Sign-off Date |
|-------------|------|---------------|
| **Business Owner** | Product Owner | Pending |
| **Solution Architect** | Technical Lead | Pending |
| **Database Architect** | Data Lead | Pending |
| **Development Manager** | Engineering Lead | Pending |
| **QA Manager** | Quality Lead | Pending |
| **Security Officer** | Security Lead | Pending |
| **Compliance Officer** | Compliance Lead | Pending |

### Review Checklist

- [ ] Business requirements validated
- [ ] Technical architecture reviewed
- [ ] Database design approved
- [ ] Performance impact assessed
- [ ] Security review completed
- [ ] Compliance requirements met
- [ ] Cost/benefit analysis reviewed
- [ ] Implementation timeline agreed
- [ ] Resource allocation confirmed
- [ ] Risk mitigation plan approved

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-16 | Architecture Team | Initial target model |

---

## Contact

For questions or clarifications about the target model:

- **Architecture Team**: architecture@intelliflo.com
- **Project Lead**: [TBD]
- **Technical Lead**: [TBD]

---

**Status:** ✅ Target Model Complete - Ready for Review & Approval

This target model represents the **complete future state** of the FactFind system with all gaps addressed and all requirements met.
