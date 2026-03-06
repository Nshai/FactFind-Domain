# FactFind Entity Data Model Documentation
**Analysis Date:** 2026-03-06
**Version:** 3.0
**Status:** Complete ✅

---

## 📚 Documentation Index

This directory contains comprehensive entity data model documentation for the FactFind wealth management platform.

### Primary Documents

| Document | Size | Lines | Purpose |
|----------|------|-------|---------|
| **Entity-Catalog-Complete.md** | 77 KB | 1,500+ | Complete catalog of all 52 entities with full specifications |
| **Entity-Data-Model.md** | 33 KB | 950 | Architectural overview, patterns, and design principles |
| **DATA-MODEL-SUMMARY.md** | 19 KB | 600+ | Executive summary and implementation guidance |
| **README-DATA-MODEL.md** | This file | - | Quick start guide and navigation |

### Source Documents

| Document | Size | Purpose |
|----------|------|---------|
| **FactFind-API-Design-v3.md** | 377 KB | RESTful API specification (38 API sections, 276 endpoints) |
| **FactFind-Contracts-Reference.md** | 329 KB | Data contract reference (39 contracts, 464 fields) |

---

## 🎯 Quick Start

### For Business Stakeholders
**Start here:** [`DATA-MODEL-SUMMARY.md`](DATA-MODEL-SUMMARY.md)
- Executive overview
- Entity statistics
- Business domain coverage
- Regulatory compliance mapping

### For Solution Architects
**Start here:** [`Entity-Data-Model.md`](Entity-Data-Model.md)
- Bounded contexts definition
- Aggregate root pattern
- Entity relationship diagrams
- Value objects reference
- Design principles

### For Developers
**Start here:** [`Entity-Catalog-Complete.md`](Entity-Catalog-Complete.md)
- Complete entity specifications
- Field-by-field reference with data types
- Foreign key relationships
- Business validation rules
- API endpoint mappings

### For Database Designers
**Reference:** [`Entity-Catalog-Complete.md`](Entity-Catalog-Complete.md) Appendix C
- Foreign Key Index
- Primary/foreign key mappings
- Cascade delete rules
- Index recommendations

---

## 📊 System Overview

### Entity Statistics
- **Total Entities:** 52 domain entities
- **Bounded Contexts:** 8
- **Aggregate Roots:** 2 (FactFind, Client)
- **Total Fields:** 900+
- **API Endpoints:** 276
- **Reference Data Entities:** 35+
- **Value Objects:** 12 types

### Bounded Contexts
1. **FactFind Root** (2 entities) - Lifecycle management
2. **Client Management** (15 entities) - Onboarding, KYC, compliance
3. **Circumstances** (7 entities) - Employment, income, expenditure
4. **Assets & Liabilities** (3 entities) - Wealth tracking
5. **Plans & Investments** (11 entities) - Pensions, investments, mortgages, protection
6. **Goals & Objectives** (1 entity) - Goal tracking
7. **Risk Assessment** (2 entities) - ATR profiling
8. **Reference Data** (35+ entities) - Lookup tables

---

## 🗺️ Navigation Guide

### By Role

#### Business Analyst / Product Owner
1. Start: [`DATA-MODEL-SUMMARY.md`](DATA-MODEL-SUMMARY.md) - Overview
2. Review: [`Entity-Catalog-Complete.md`](Entity-Catalog-Complete.md) - Entity specifications
3. Reference: [`Entity-Data-Model.md`](Entity-Data-Model.md) - Bounded contexts

**Key Sections:**
- Business Domain Coverage
- Entity Breakdown by Context
- Regulatory Compliance

#### Technical Architect
1. Start: [`Entity-Data-Model.md`](Entity-Data-Model.md) - Architecture
2. Reference: [`Entity-Catalog-Complete.md`](Entity-Catalog-Complete.md) - Complete catalog
3. Review: [`DATA-MODEL-SUMMARY.md`](DATA-MODEL-SUMMARY.md) - Implementation guidance

**Key Sections:**
- Aggregate Root Pattern
- Bounded Contexts
- Entity Relationship Diagrams
- Value Objects Reference

#### Software Developer
1. Start: [`Entity-Catalog-Complete.md`](Entity-Catalog-Complete.md) - Entity specs
2. Reference: [`Entity-Data-Model.md`](Entity-Data-Model.md) - Design patterns
3. API Docs: [`FactFind-API-Design-v3.md`](FactFind-API-Design-v3.md) - API details

**Key Sections:**
- Entity Catalog (Section 2-9)
- API Endpoints per entity
- Appendix A: Field Type Mappings
- Appendix B: Validation Rules Matrix

#### Database Administrator
1. Start: [`Entity-Catalog-Complete.md`](Entity-Catalog-Complete.md) - Schema reference
2. Review: [`DATA-MODEL-SUMMARY.md`](DATA-MODEL-SUMMARY.md) - Database design

**Key Sections:**
- Entity Properties Tables
- Appendix C: Foreign Key Index
- Database Design recommendations
- Performance Optimization

#### QA / Test Engineer
1. Start: [`Entity-Catalog-Complete.md`](Entity-Catalog-Complete.md) - Validation rules
2. Reference: [`DATA-MODEL-SUMMARY.md`](DATA-MODEL-SUMMARY.md) - Testing strategy

**Key Sections:**
- Business Validation Rules per entity
- Appendix B: Validation Rules Matrix
- Testing Strategy section

---

## 📖 Document Contents

### Entity-Catalog-Complete.md

**Table of Contents:**
1. Quick Reference Index
2. FactFind Root Context (2 entities)
3. Client Management Context (15 entities)
4. Circumstances Context (7 entities)
5. Assets & Liabilities Context (3 entities)
6. Plans & Investments Context (11 entities)
7. Goals & Objectives Context (1 entity)
8. Risk Assessment Context (2 entities)
9. Reference Data Context (35+ entities)
10. System-Wide ERD
11. Appendix A: Field Type Mappings
12. Appendix B: Validation Rules Matrix
13. Appendix C: Foreign Key Index

**Key Features:**
- Complete field specifications with data types
- Max length constraints
- Required/optional indicators
- Foreign key relationships
- Business validation rules
- API endpoint mappings per entity
- Example values

### Entity-Data-Model.md

**Table of Contents:**
1. Executive Summary
2. Bounded Contexts
3. Aggregate Root Pattern
4. Entity Relationship Overview
5. Value Objects Reference (12 types)
6. FactFind Root Context (detailed specs)

**Key Features:**
- Architectural patterns
- Bounded context definitions
- Aggregate root documentation
- Value object specifications
- Mermaid ERD diagrams
- Design principles

### DATA-MODEL-SUMMARY.md

**Table of Contents:**
1. Deliverables Created
2. Key Findings
3. Entity Breakdown
4. Value Objects Reference
5. Key Relationships
6. Data Model Patterns
7. Business Domain Coverage
8. API Design Principles
9. Implementation Considerations
10. Migration Strategy
11. Testing Strategy
12. Recommendations
13. Next Steps

**Key Features:**
- Executive summary
- Implementation guidance
- Migration phases
- Performance recommendations
- Security considerations
- Success metrics

---

## 🔍 Finding Specific Information

### Looking for a specific entity?
**Go to:** [`Entity-Catalog-Complete.md`](Entity-Catalog-Complete.md)
- Section 2-9 contain all entities organized by bounded context
- Use the Quick Reference Index at the top
- Or search for entity name (Ctrl+F)

### Need to understand relationships?
**Go to:** [`Entity-Data-Model.md`](Entity-Data-Model.md)
- Section 3: Entity Relationship Overview
- Mermaid ERD diagrams showing relationships
- Parent-child hierarchies

### Want to know validation rules?
**Go to:** [`Entity-Catalog-Complete.md`](Entity-Catalog-Complete.md)
- Each entity section includes "Business Rules"
- Appendix B: Validation Rules Matrix
- Field tables show Required/Optional

### Looking for API endpoints?
**Go to:** [`Entity-Catalog-Complete.md`](Entity-Catalog-Complete.md)
- Each entity section includes "API Endpoints" table
- Shows method, path, and description

### Need database schema design?
**Go to:** [`DATA-MODEL-SUMMARY.md`](DATA-MODEL-SUMMARY.md)
- Section: Implementation Considerations → Database Design
- Schema recommendations
- Table naming conventions
- Index strategy

### Want to understand bounded contexts?
**Go to:** [`Entity-Data-Model.md`](Entity-Data-Model.md)
- Section 1: Bounded Contexts
- Detailed description of each context
- Entities per context
- Context responsibilities

---

## 🎨 Entity Relationship Diagrams

### System-Wide ERD
Location: [`Entity-Catalog-Complete.md`](Entity-Catalog-Complete.md) - Section 10

Shows all 52 entities and their relationships in a single Mermaid diagram.

### Context-Specific ERDs
Location: [`Entity-Data-Model.md`](Entity-Data-Model.md)

Detailed diagrams for:
- Aggregate Root Pattern (FactFind hierarchy)
- Client Sub-Aggregate (Client hierarchy)

---

## 📋 Common Lookups

### Entity Count by Context

| Context | Entities |
|---------|----------|
| FactFind Root | 2 |
| Client Management | 15 |
| Circumstances | 7 |
| Assets & Liabilities | 3 |
| Plans & Investments | 11 |
| Goals & Objectives | 1 |
| Risk Assessment | 2 |
| Reference Data | 35+ |
| **Total** | **52+** |

### Largest Entities

| Entity | Field Count | Purpose |
|--------|-------------|---------|
| Personal Pension | 50+ | DC pension with drawdown |
| Personal Protection | 38+ | Life/CI/IP policies |
| Mortgage | 30+ | Mortgage arrangements |
| Final Salary Pension | 33 | DB pension schemes |
| Investment | 23 | Investment portfolio |
| Client | 22+ | Client demographics |

### Singleton Entities

These entities have 1:1 relationship with their parent:

| Entity | Parent | Purpose |
|--------|--------|---------|
| Control Options | FactFind | Section gating |
| Net Worth | FactFind | Wealth calculation |
| Affordability | FactFind | Income/expenditure surplus |
| ATR Assessment | FactFind | Risk profiling |
| Protection Review | FactFind | Protection needs |
| Employment Summary | Client | Employment metrics |
| Credit History | Client | Credit assessment |
| Financial Profile | Client | Financial sophistication |
| Marketing Preferences | Client | GDPR consent |
| Estate Planning | Client | Wills, LPAs, trusts |

---

## 🛠️ Implementation Guide

### Phase 1: Core Entities (MVP)
**Duration:** 2 weeks

**Entities:**
- FactFind
- Client (with Person polymorphic type)
- Address
- Contact
- Bank Account

**Deliverable:** Basic client onboarding

### Phase 2: Financial Data
**Duration:** 2 weeks

**Entities:**
- Employment
- Income
- Expenditure
- Assets
- Liabilities

**Deliverable:** Circumstances capture and affordability

### Phase 3: Financial Products
**Duration:** 3 weeks

**Entities:**
- Investments
- Personal Pension
- State Pension
- Mortgage
- Personal Protection

**Deliverable:** Core financial planning

### Phase 4: Advanced Features
**Duration:** 3 weeks

**Entities:**
- Final Salary Pension
- Annuity
- Employer Pension Scheme
- Estate Planning
- Vulnerability
- Goals
- ATR Assessment

**Deliverable:** Comprehensive advice platform

---

## 📞 Support & Questions

### Technical Questions
- Review complete entity specs in `Entity-Catalog-Complete.md`
- Check field type mappings in Appendix A
- Reference validation rules in Appendix B

### Business Questions
- Review bounded contexts in `Entity-Data-Model.md`
- Check business domain coverage in `DATA-MODEL-SUMMARY.md`
- Consult entity business rules sections

### Implementation Questions
- Review implementation considerations in `DATA-MODEL-SUMMARY.md`
- Check migration strategy
- Reference database design recommendations

---

## 🔄 Version History

| Version | Date | Changes |
|---------|------|---------|
| 3.0 | 2026-03-06 | Complete entity data model analysis |

---

## ✅ Quality Checklist

- ✅ All 52 entities documented
- ✅ All 8 bounded contexts defined
- ✅ All entity relationships mapped
- ✅ All 12 value objects specified
- ✅ All 35+ reference data entities identified
- ✅ Field-level specifications complete
- ✅ Validation rules documented
- ✅ API endpoints mapped
- ✅ ERD diagrams provided
- ✅ Implementation guidance included

---

## 📈 Document Statistics

| Metric | Count |
|--------|-------|
| Total Documentation Pages | 3 main + this README |
| Total Lines of Documentation | 2,500+ |
| Entities Documented | 52 |
| Fields Documented | 900+ |
| Relationships Mapped | 45+ |
| API Endpoints Documented | 276 |
| Source Lines Analyzed | 19,595 |

---

**Last Updated:** 2026-03-06
**Status:** ✅ Complete and Ready for Use

**Need help?** Start with [`DATA-MODEL-SUMMARY.md`](DATA-MODEL-SUMMARY.md) for an overview, then navigate to the specific document based on your role and needs.
