# API Contract Documentation - Master Documents

This folder contains core API contract specifications, governance frameworks, and quick-start guides for the FactFind system.

## 📚 Document Index

### 🎯 Start Here

1. **[API-Implementation-Complete.md](API-Implementation-Complete.md)** - **READ THIS FIRST**
   - Completion summary and sign-off document
   - Coverage statistics (206 endpoints, 95+ schemas)
   - Success criteria validation
   - Implementation readiness checklist

2. **[API-Master-Specification.md](API-Master-Specification.md)** - **PRIMARY REFERENCE**
   - Single source of truth for entire API system
   - 206 endpoints across 5 domains fully documented
   - Complete OpenAPI 3.1 specifications
   - Integration patterns and domain boundaries
   - Migration strategy and implementation roadmap (90+ pages)

3. **[API-Quick-Start-Guide.md](API-Quick-Start-Guide.md)** - **DEVELOPER ONBOARDING**
   - 5-minute getting started guide
   - Authentication setup
   - First API call examples
   - Common patterns and troubleshooting (20+ pages)

---

### 📋 Domain-Specific Specifications

**Note:** Domain-specific API contracts are located in `../Domain-Contracts/`

#### Client Profile Domain (CRM)
- **[Client-Profile-API-Contracts.md](../Domain-Contracts/Client-Profile-API-Contracts.md)** (101 KB)
  - 9 API families: Demographics, Contact Details, Address, Vulnerability, Data Protection, Marketing, ID Verification, Estate Planning, Tax Details
  - 34 endpoints with full CRUD operations
  - OpenAPI 3.1 specifications

- **[Client-Profile-Quick-Reference.md](../Supporting-Documents/Client-Profile-Quick-Reference.md)** (Quick reference)

#### FactFind Core Domain
- **[FactFind-Core-API-Contracts.md](../Domain-Contracts/FactFind-Core-API-Contracts.md)** (118 KB)
  - 7 API families: Employment, Income, Budget, Expenditure, Assets, Liabilities, Notes
  - 44 endpoints with full CRUD operations
  - **NEW APIs**: Assets (7 endpoints), Affordability
  - Notes API with discriminator pattern (10 categories)
  - 85+ OpenAPI 3.1 schemas

- **[FactFind-Core-Summary.md](../Supporting-Documents/FactFind-Core-Summary.md)** (Executive summary)

#### Portfolio Plans Domain
- **[Portfolio-Plans-API-Contracts.md](../Domain-Contracts/Portfolio-Plans-API-Contracts.md)** (86 KB)
  - 9 API families: Pensions, Protection, Investments, Savings, Mortgages, Equity Release, Loans, Credit Cards, Current Accounts
  - 92 endpoints with full CRUD operations
  - 1,773 plan types with polymorphic discriminator pattern
  - Complete OpenAPI 3.1 specifications

- **[Portfolio-Plans-Summary.md](../Supporting-Documents/Portfolio-Plans-Summary.md)** (Executive summary)

- **[Portfolio-Plans-Quick-Reference.md](../Supporting-Documents/Portfolio-Plans-Quick-Reference.md)** (Developer cheat sheet)

#### Goals & Risk Domain
- **[Goals-Risk-API-Contracts.md](../Domain-Contracts/Goals-Risk-API-Contracts.md)** (76 KB)
  - Goals API with 7 polymorphic types (Investment, Retirement, Protection, Mortgage, Budget, Estate Planning, Equity Release)
  - Risk Assessment API (ATR, questionnaires, risk replay)
  - Supplementary APIs (Dependants, Needs & Priorities)
  - 36 endpoints with event-driven architecture
  - Event schemas documented

---

### 📖 Standards & Guidelines

- **[API-Design-Guidelines-Summary.md](../Supporting-Documents/API-Design-Guidelines-Summary.md)**
  - Complete extraction from company API Design Guidelines 2.0
  - REST principles, naming conventions, HTTP methods
  - Data types, HATEOAS, headers, documentation standards
  - Events, patterns, and best practices
  - Do's and Don'ts checklist

- **[API-Governance-Framework.md](API-Governance-Framework.md)** (33 KB)
  - Complete governance framework
  - API review and change management processes
  - Breaking change policies
  - Testing, security, and performance standards
  - Quality metrics and compliance audits

---

## 📊 Coverage Statistics

- **Total Endpoints:** 206 endpoints
- **Total Schemas:** 95+ schemas (OpenAPI 3.1)
- **API Families:** 30+ organized by domain
- **Plan Types:** 1,773 documented
- **Coverage:** 81% existing → 95% target
- **Bounded Contexts:** 5 (Client Profile, FactFind Core, Portfolio Plans, Goals & Risk, ATR)

---

## 🎯 Quick Navigation by Role

### For Executives
1. API-Implementation-Complete.md (completion summary)
2. ../Supporting-Documents/FactFind-Core-Summary.md (FactFind Core summary)
3. ../Supporting-Documents/Portfolio-Plans-Summary.md (Portfolio summary)

### For Product Owners
1. API-Master-Specification.md (complete catalog)
2. Each domain-specific specification in ../Domain-Contracts/
3. API-Governance-Framework.md (governance)

### For Architects
1. API-Master-Specification.md (architecture overview)
2. ../Supporting-Documents/API-Design-Guidelines-Summary.md (standards)
3. All domain-specific specifications in ../Domain-Contracts/ (integration patterns)

### For Developers
1. API-Quick-Start-Guide.md (get started in 5 minutes)
2. openapi-factfind-complete.yaml (OpenAPI spec)
3. ../Supporting-Documents/Portfolio-Plans-Quick-Reference.md (cheat sheet)
4. ../Supporting-Documents/Client-Profile-Quick-Reference.md (Client Profile quick ref)
5. Domain-specific specifications in ../Domain-Contracts/ for detailed contracts

### For QA/Testing
1. API-Governance-Framework.md (testing requirements)
2. openapi-factfind-complete.yaml (contract testing)
3. Each domain specification in ../Domain-Contracts/ (test scenarios)
4. API-Quick-Start-Guide.md (test setup)

---

## 🚀 Implementation Roadmap

**Timeline:** 20-28 weeks to 95% coverage

**Phase 1 (6 weeks):** Critical gaps
- Affordability API
- Credit History API
- Risk Questionnaire API
- Assets API enhancements

**Phase 2 (9 weeks):** High-value additions
- Enhanced filtering
- Batch operations
- Technical debt fixes

**Phase 3 (13 weeks):** Quality & standardization
- Documentation
- Performance optimization
- SDK generation

---

## 📝 Document Versions

All documents are OpenAPI 3.1 compliant and follow API Design Guidelines 2.0.

**Last Updated:** February 13, 2026
**Status:** Implementation Ready

---

## 🔗 Related Documentation

Located in parent directories:
- `../../Analysis/` - Coverage analysis and implementation roadmap
- `../../Domain-Architecture/` - Domain models, ERD diagrams, and architecture patterns
- `../../Navigation/FINAL-STRUCTURE.md` - Master navigation index
- `../../../Context/FactFind-Sections-Reference.md` - Complete section list (62 sections)

---

## 📞 Questions?

Refer to:
- `API-Governance-Framework.md` for process questions
- `API-Quick-Start-Guide.md` for technical questions
- `../../Navigation/FINAL-STRUCTURE.md` for navigation help

---

**Total Documentation:** 628 KB across 18 comprehensive documents covering the entire API system.
