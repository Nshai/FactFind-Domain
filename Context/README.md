# Context Documentation

**Last Updated:** February 13, 2026
**Purpose:** Source materials and legacy system context for FactFind architecture analysis

---

## 📋 Overview

This folder contains the **source context materials** used to inform the domain architecture analysis and API design. These materials represent the legacy system state, original specifications, and database schemas that were analyzed to produce the consolidated documentation in `steering/`.

**Key Principle:** This folder preserves **historical context and source materials**. For the **authoritative, consolidated outputs**, see the `steering/` folder.

---

## 📂 Folder Structure

```
Context/
├── README.md                           # This file
├── 📄 Source Documents (Root Level)
│   ├── API+Design+Guidelines+2.0.doc  # API design standards (source)
│   ├── Fact Find Data Analysis v6.1.xlsx  # Data analysis spreadsheet
│   ├── FactFind_+v3+Client+API.doc    # Legacy v3 API specification
│   ├── FactFind-Swagger.json          # Legacy Swagger 2.0 spec
│   ├── FactFind-Sections-Reference.md # FactFind section catalog
│   ├── Ac+WFlow+-+Provider+Documents+API.doc  # Provider documents API
│   ├── Plan-Model.png                  # Visual plan model diagram
│   └── Target-Entities.png             # Target entity diagram
│
├── 📁 Monolith.Crm/                    # CRM monolith codebase analysis
├── 📁 Monolith.FactFind/               # FactFind monolith codebase analysis
├── 📁 Monolith.Portfolio/              # Portfolio/Policy monolith analysis
├── 📁 Microservice.Requirement/        # Requirements microservice analysis
├── 📁 IntelligentOffice/               # IntelligentOffice legacy system analysis
└── 📁 schema/                          # Database schema exports
    ├── crm/                            # CRM database schemas
    ├── factfind/                       # FactFind database schemas
    ├── policymanagement/               # Portfolio/Policy database schemas
    ├── atr/                            # ATR database schemas
    └── administration/                 # Administration database schemas
```

---

## 📄 Root-Level Source Documents

### API Specifications & Standards

#### **API+Design+Guidelines+2.0.doc** (489 KB)
- **Type:** Microsoft Word document
- **Purpose:** Authoritative API design standards and guidelines
- **Contents:**
  - REST API conventions (naming, HTTP methods, status codes)
  - Data format standards (ISO 8601 dates, ISO 4217 currency, ISO 3166 countries)
  - Security and authentication guidelines
  - Error handling patterns (RFC 7807)
  - Pagination and filtering standards
- **Traceability:** Mapped in `steering/API-Docs/Supporting-Documents/API-Design-Guidelines-Traceability-Matrix.md`
- **Usage:** Source for API design compliance verification

#### **FactFind_+v3+Client+API.doc** (17 KB)
- **Type:** Microsoft Word document
- **Purpose:** Legacy v3 Client API specification
- **Contents:**
  - Client profile endpoints (Person, Corporate, Trust)
  - Address and contact management
  - Identity verification endpoints
- **Status:** Legacy specification superseded by OpenAPI 3.1 spec in `steering/`

#### **FactFind-Swagger.json** (130 KB)
- **Type:** Swagger 2.0 specification (JSON)
- **Purpose:** Legacy API specification
- **Contents:**
  - FactFind API endpoints (v2 format)
  - Schema definitions
  - Legacy authentication model
- **Status:** Superseded by `steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml`
- **Migration:** Analyzed and migrated to OpenAPI 3.1 with V4 corrections

#### **Ac+WFlow+-+Provider+Documents+API.doc** (38 KB)
- **Type:** Microsoft Word document
- **Purpose:** Provider documents workflow API specification
- **Contents:**
  - Document upload/download endpoints
  - Provider integration patterns
  - Document lifecycle management

### Analysis Documents

#### **Fact Find Data Analysis v6.1.xlsx** (379 KB)
- **Type:** Excel spreadsheet
- **Purpose:** Comprehensive FactFind data structure analysis
- **Contents:**
  - 62 FactFind sections cataloged
  - Data field mappings and relationships
  - Coverage analysis (API vs Database)
  - Plan type categorization (1,773 types)
- **Key Insights:**
  - Original 42% coverage estimate corrected to 81% in V4 analysis
  - Portfolio Plans API discovery (all 1,773 plan types)
  - Protection Plans polymorphic structure corrections
- **Outputs:** Fed into `steering/Analysis/Coverage-Analysis-Complete.md`

#### **FactFind-Sections-Reference.md** (5 KB)
- **Type:** Markdown reference document
- **Purpose:** Quick reference catalog of all 62 FactFind sections
- **Contents:**
  - Section names and identifiers
  - Brief descriptions
  - Categorization by domain
- **Usage:** Reference for coverage analysis and API planning

### Visual Diagrams

#### **Plan-Model.png** (411 KB)
- **Type:** PNG image
- **Purpose:** Visual representation of the plan/policy domain model
- **Contents:**
  - Plan type hierarchy
  - Relationships between plan entities
  - Polymorphic discriminator patterns
- **Related:** Informed `steering/Domain-Architecture/Complete-Domain-Model.md`

#### **Target-Entities.png** (118 KB)
- **Type:** PNG image
- **Purpose:** Target entity relationship diagram
- **Contents:**
  - High-level entity relationships
  - Key domain boundaries
  - Integration points
- **Related:** Influenced domain context identification

---

## 📁 Codebase Analysis Folders

### **Monolith.Crm/**
- **Purpose:** CRM monolith codebase analysis
- **Contents:**
  - Entity mappings and Hibernate configurations
  - Service layer analysis
  - Database schema extracts
  - README with analysis findings
- **Key Entities:**
  - TCRMContact (Client polymorphic root)
  - TAddress, TContactDetail
  - TVulnerability, TIDVerification
- **Database:** CRM.dbo schema
- **Output:** Fed into Client Domain analysis in `steering/Domain-Architecture/`

### **Monolith.FactFind/**
- **Purpose:** FactFind monolith codebase analysis
- **Contents:**
  - Employment, Income, Budget entity mappings
  - Asset and Liability structures
  - Expenditure tracking entities
  - README with domain analysis
- **Key Entities:**
  - TEmploymentDetail (polymorphic)
  - TDetailedIncomeBreakdown
  - TBudgetMiscellaneous
  - TAsset, TLiability
- **Database:** FactFind.dbo schema
- **Output:** Fed into FactFind Core Domain in `steering/Domain-Architecture/`

### **Monolith.Portfolio/**
- **Purpose:** Portfolio/Policy management codebase analysis (IntelligentOffice)
- **Contents:**
  - Plan/Policy entity structures
  - 1,773 plan type discriminators
  - Protection Plans corrected structure
  - Pension, Investment, Mortgage entities
  - README with portfolio analysis
- **Key Entities:**
  - TPolicyBusiness (base plan entity)
  - TPension, TProtection (with polymorphic structure)
  - TAssuredLife, TBenefit (0-2 lives, 4 benefits max)
  - TInvestment, TMortgage, TSavings
- **Database:** PolicyManagement.dbo schema
- **Critical Discovery:** V4 corrections identified complete Portfolio Plans API (81% coverage, not 42%)
- **Output:** Fed into Portfolio Plans Domain in `steering/Domain-Architecture/`

### **Microservice.Requirement/**
- **Purpose:** Requirements microservice codebase analysis (modern architecture)
- **Contents:**
  - Entity Framework Core models
  - Goals/Objectives polymorphic structure
  - Risk Profile owned entities
  - Domain events and integration
  - README with microservice architecture analysis
  - service_dependencies.json (integration mapping)
- **Key Entities:**
  - Goal (polymorphic with GUID identifiers)
  - RiskProfile (owned entity)
  - Dependant, Allocation
- **Database:** Requirements.dbo (separate database)
- **Architecture:** Modern DDD with domain events, EF Core, GUID identifiers
- **Output:** Fed into Goals & Risk Domain in `steering/Domain-Architecture/`

### **IntelligentOffice/**
- **Purpose:** Legacy IntelligentOffice system analysis
- **Contents:**
  - PolicyManagement schema deep dive
  - NuGet packages and dependencies
  - Feature state tracking (feature_state.json)
  - PolicyManagement-Schema-Analysis.md
  - README with legacy system overview
- **Key Discovery:** Source of 1,773 plan type discriminators via RefPlanSubCategoryId
- **Output:** Critical for understanding Portfolio Plans polymorphic patterns

---

## 📁 Database Schema Exports (`schema/`)

The `schema/` folder contains SQL schema exports and table definitions from the legacy monolith databases.

### **schema/crm/**
- **Database:** CRM.dbo
- **Tables:** ~10 tables
- **Key Tables:**
  - TCRMContact (polymorphic client root)
  - TAddress
  - TContactDetail
  - TVulnerability
  - TMarketingPreferences
  - TIDVerification
- **Output:** Informed `steering/Domain-Architecture/Complete-ERD.md` CRM section

### **schema/factfind/**
- **Database:** FactFind.dbo
- **Tables:** ~8 tables
- **Key Tables:**
  - TEmploymentDetail (polymorphic)
  - TDetailedIncomeBreakdown
  - TBudgetMiscellaneous
  - TAsset, TLiability
  - TExpenditure, TExpense
- **Output:** Informed `steering/Domain-Architecture/Complete-ERD.md` FactFind section

### **schema/policymanagement/**
- **Database:** PolicyManagement.dbo
- **Tables:** ~13 tables
- **Key Tables:**
  - TPolicyBusiness (base plan entity)
  - TPension, TProtection, TInvestment
  - TMortgage, TSavings, TLoan
  - TAssuredLife, TBenefit
  - RefPlanSubCategory (1,773 discriminators)
- **Critical:** Revealed complete Portfolio Plans structure correcting V4 coverage analysis
- **Output:** Informed `steering/Domain-Architecture/Complete-ERD.md` Portfolio section

### **schema/atr/**
- **Database:** ATR.dbo
- **Tables:** ~4 tables
- **Key Tables:**
  - TATRAssessment
  - TATRTemplate
  - TATRQuestion
  - TATRResponse
- **Output:** Informed ATR Domain in `steering/Domain-Architecture/`

### **schema/administration/**
- **Database:** Administration.dbo
- **Tables:** Reference data and lookups
- **Contents:**
  - Country codes
  - Income/Expenditure categories
  - Plan type hierarchies
  - User and permissions

---

## 🔗 Relationship to Steering Documentation

The Context folder provides **source materials** that were analyzed to produce the **authoritative outputs** in the `steering/` folder:

| Context Source | Steering Output |
|----------------|-----------------|
| `Fact Find Data Analysis v6.1.xlsx` | `steering/Analysis/Coverage-Analysis-Complete.md` |
| `Monolith.*` folders + `schema/` | `steering/Domain-Architecture/Complete-Domain-Model.md` |
| `schema/*` | `steering/Domain-Architecture/Complete-ERD.md` |
| `API+Design+Guidelines+2.0.doc` | `steering/API-Docs/Supporting-Documents/API-Design-Guidelines-Traceability-Matrix.md` |
| `FactFind-Swagger.json` + Analysis | `steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml` |
| All Context materials | `steering/Domain-Architecture/Complete-Domain-Analysis.md` |

---

## 📊 Key Metrics & Statistics

### Analyzed Codebase
- **Monoliths Analyzed:** 3 (CRM, FactFind, Portfolio/Policy)
- **Microservices Analyzed:** 1 (Requirements)
- **Total Database Tables:** 42 (across 5 databases)
- **Plan Type Discriminators:** 1,773 (RefPlanSubCategoryId)
- **FactFind Sections:** 62 cataloged

### Coverage Discovery
- **Initial Estimate:** 42% API coverage (incorrect)
- **V4 Corrected:** 81% API coverage (50/62 sections)
- **Database Coverage:** 92% (57/62 sections)
- **Key Discovery:** Portfolio Plans API was fully implemented but undocumented

### Critical Corrections (V4 Analysis)
1. **Portfolio Plans API:** Complete coverage of 1,773 plan types discovered
2. **Protection Plans Structure:** Polymorphic structure corrected (RefPlanSubCategoryId: 51=PersonalProtection, 47=GeneralInsurance)
3. **AssuredLife Entities:** 0-2 per protection policy, not 1-1 as initially thought
4. **Benefits Structure:** Main + additional per life, max 4 benefits per policy
5. **Unified Notes API:** Single discriminator endpoint abstracts 10 note types
6. **Requirements Microservice:** GUID identifiers, EF Core, domain events (not Hibernate)

---

## 🎯 Usage Guidelines

### For Architects
- **Start Here:** Review `Fact Find Data Analysis v6.1.xlsx` for coverage overview
- **Dive Deeper:** Explore `Monolith.*` folders for entity-level details
- **Verify Against:** Check `schema/` folders for authoritative database structures
- **Reference:** Use visual diagrams (Plan-Model.png, Target-Entities.png) for understanding

### For Developers
- **API Contracts:** Use `steering/API-Docs/` (NOT the legacy Swagger in Context)
- **Domain Models:** Reference `steering/Domain-Architecture/Complete-Domain-Model.md`
- **Database Schema:** Use `steering/Domain-Architecture/Complete-ERD.md` (consolidated)
- **Context Research:** Explore this folder for understanding legacy decisions

### For Product Owners
- **Coverage Stats:** See `steering/Analysis/Coverage-Analysis-Complete.md`
- **Implementation Plan:** See `steering/Analysis/Implementation-Roadmap.md`
- **Quick Overview:** See `steering/Analysis/Coverage-Executive-Summary.md`

---

## ⚠️ Important Notes

1. **Context vs Steering:**
   - **Context/** = Source materials and legacy analysis
   - **steering/** = Authoritative consolidated outputs
   - Always use `steering/` for current state and API contracts

2. **Version Control:**
   - This folder preserves historical context
   - Documents may be superseded by steering/ outputs
   - Check `steering/` for latest consolidated documentation

3. **V4 Corrections:**
   - Initial analysis (V1-V3) underestimated coverage
   - V4 analysis corrected to 81% (from 42%)
   - Portfolio Plans API discovery was the key finding
   - All V4 corrections are incorporated in `steering/`

4. **Database Schemas:**
   - `schema/` contains exports as-is from legacy systems
   - `steering/Domain-Architecture/Complete-ERD.md` is the normalized, consolidated version
   - Use Complete-ERD.md for current database design

5. **API Specifications:**
   - `FactFind-Swagger.json` is legacy (Swagger 2.0)
   - `steering/API-Docs/Master-Documents/openapi-factfind-complete.yaml` is authoritative (OpenAPI 3.1)
   - Legacy specs retained for traceability only

---

## 🔄 Maintenance

This folder should be treated as **read-only reference material**. Updates should focus on:
- Adding new source materials when analyzing additional legacy systems
- Updating README.md to document new materials
- Cross-referencing new findings to `steering/` outputs

**Do NOT:**
- Use this folder for authoritative specifications (use `steering/` instead)
- Modify source documents (preserves historical accuracy)
- Store new design artifacts here (belongs in `steering/`)

---

## 📚 Related Documentation

**For Authoritative Outputs, See:**
- `steering/README.md` - Main steering documentation index
- `steering/Navigation/FINAL-STRUCTURE.md` - Master navigation for all documentation
- `steering/Analysis/` - Coverage analysis and implementation roadmap
- `steering/Domain-Architecture/` - Consolidated domain models and ERDs
- `steering/API-Docs/` - Complete API specifications and contracts

**For Historical Context:**
- This folder (Context/) - Source materials and legacy system analysis

---

**Maintained By:** Architecture Team
**Purpose:** Historical Context & Source Materials
**Status:** Reference-Only (Authoritative outputs in steering/)
**Last Updated:** February 13, 2026
