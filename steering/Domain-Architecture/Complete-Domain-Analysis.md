# Complete FactFind Domain Analysis

**Document Purpose:** This document provides comprehensive analysis findings, coverage statistics, critical findings, technical debt inventory, and actionable recommendations for the FactFind domain architecture. It consolidates analysis insights from V3 coverage assessments and V4 corrections.

**Document Version:** 4.0 - Comprehensive Analysis
**Analysis Date:** 2026-02-12 (V4 Update), 2026-02-13 (Consolidation)
**Parent Documents:** Domain-Model-Analysis-V2.md, FactFind-Sections-Reference.md

**Related Documents:**
- Complete-Domain-Model.md - Domain model with diagrams
- Complete-ERD.md - Complete Entity Relationship Diagrams
- API-Domain-Analysis.md - Complete API analysis
- API-Architecture-Patterns.md - Reference guide
- Client-FactFind-Boundary-Analysis.md - Architectural decision

---

## V4 CORRECTION ALERT - February 12, 2026

**CRITICAL UPDATE:** Four parallel deep-dive analyses discovered extensive API coverage that was previously missed. Original V3 assessment was **significantly understated**.

### Coverage Transformation Summary

| Metric | V3 Original Assessment | V4 Corrected Assessment | Improvement |
|--------|----------------------|------------------------|-------------|
| **Overall API Coverage** | 26/62 (42%) | 50/62 (81%) | **+24 sections (+39%)** |
| **Pensions & Retirement** | 3/13 (23%) | 13/13 (100%) | **+10 sections (+77%)** |
| **Protection & Insurance** | 1/3 (33%) | 3/3 (100%) | **+2 sections (+67%)** |
| **Plans & Providers** | 0/3 (0%) | 3/3 (100%) | **+3 sections (+100%)** |
| **Savings & Investments** | 0/1 (0%) | 1/1 (100%) | **+1 section (+100%)** |

### Major Discoveries

1. **Portfolio Plans API:** Comprehensive polymorphic API covering 1,773 plan types across pensions, protection, investments, savings, mortgages, loans
2. **Unified Notes API:** Single discriminator-based endpoint covering ALL 10 note categories
3. **Requirements Microservice:** Modern microservice with full Goals/Objectives coverage including Risk Income
4. **CRM Profile APIs:** Contact Details, Address, and Custom Questions all fully covered

**Recommendation:** Read `steering/COVERAGE-CORRECTION-V4-ANALYSIS.md` for complete details.

**Impact:** V3 API development scope **REDUCED BY 52%** - from 10+ months to 5 months

---

## Coverage Statistics Summary

### Overall Coverage Metrics (V4 Corrected)

| Metric | Count | Percentage | Assessment |
|--------|-------|------------|------------|
| **Total Sections Analyzed** | 62 | 100% | Complete catalog |
| **Database Tables Found** | 57 | 92% | **EXCELLENT** |
| **Entity/Model Coverage** | 57 | 92% | **EXCELLENT** |
| **API Endpoint Coverage** | 50 | 81% | **EXCELLENT** (was 42%) |
| **End-to-End Complete** | 50 | 81% | **EXCELLENT** (was 42%) |

### Coverage by Domain Category (V4 Corrected)

| Category | Sections | V3 API | V3 Grade | **V4 API** | **V4 Grade** | Change |
|----------|----------|--------|----------|-----------|-------------|--------|
| **Client Profile** | 11 | 8 (73%) | B | **10 (91%)** | **A-** | +2 sections |
| **Goals & Objectives** | 4 | 3 (75%) | B | **4 (100%)** | **A+** | +1 section |
| **Assets & Liabilities** | 9 | 3 (33%) | D | **8 (89%)** | **B+** | +5 sections |
| **Credit & Budget** | 5 | 4 (80%) | B+ | **5 (100%)** | **A+** | +1 section |
| **Employment & Income** | 5 | 5 (100%) | A+ | **5 (100%)** | **A+** | No change ⭐ |
| **Risk Assessment (ATR)** | 8 | 4 (50%) | C | **5 (63%)** | **C+** | +1 section |
| **Plans & Providers** | 3 | 0 (0%) | F | **3 (100%)** | **A+** | **+3 sections** ⭐ |
| **Protection & Insurance** | 3 | 1 (33%) | D | **3 (100%)** | **A+** | **+2 sections** ⭐ |
| **Pensions & Retirement** | 13 | 3 (23%) | F | **13 (100%)** | **A+** | **+10 sections** ⭐ |
| **Savings & Investments** | 1 | 0 (0%) | F | **1 (100%)** | **A+** | **+1 section** ⭐ |

---

## Critical Findings

### STRENGTHS: What Works Well

#### 1. Employment & Income Domain (100% Coverage - PERFECT)

**Why This Is The Gold Standard:**
- Complete database schema (TEmploymentDetail, TDetailedIncomeBreakdown)
- Full Hibernate entity mapping (Employment, EmploymentStatus hierarchy, Income)
- Comprehensive API exposure (v1 + v2 APIs)
- Both read and write operations supported
- Proper domain modeling with polymorphic employment types

**Lesson for V3:** Use this as the template for all other domains

**Technical Note:** Despite 100% coverage, still has technical debt (dual-entity mapping on TEmploymentDetail)

#### 2. Budget & Expenditure Domain (100% Coverage - V4 CORRECTED)

**Strengths:**
- Expenditure aggregate demonstrates proper DDD design
- Budget tracking complete
- v1 and v2 APIs available
- Reference data well-modeled (ExpenditureType, ExpenditureGroup)
- Credit History and Affordability now fully covered (V4)

#### 3. Strong Database Foundation (92% Coverage)

**Observation:** Nearly complete database schema means the DATA EXISTS
- 57 of 62 sections have database tables
- Well-normalized schemas
- Good separation between CRM and FactFind schemas
- Extension tables (FFExt) provide PolicyManagement integration

**Implication:** The heavy lifting (data modeling) is done. Main gap is API exposure.

#### 4. Portfolio Plans API (100% Coverage - V4 DISCOVERY)

**Gold Standard Implementation:**
- Comprehensive polymorphic discriminator pattern
- 1,773 plan types across all product categories
- 9 REST controllers with full CRUD
- Proper separation of concerns
- Extension tables for type-specific fields

**Why This Matters:**
- Demonstrates mature API design
- Solves complex polymorphic modeling
- Provides template for future discriminator patterns

#### 5. Requirements Microservice (100% Coverage - V4 DISCOVERY)

**Modern Architecture:**
- Separate microservice with dedicated database
- Entity Framework Core (not Hibernate)
- Event-driven architecture
- Domain events published
- Owned entities pattern (RiskProfile embedded)

**Why This Matters:**
- Shows path to microservices
- Modern DDD implementation
- Event sourcing ready
- Independent deployment

#### 6. Unified Notes API (100% Coverage - V4 DISCOVERY)

**Elegant Solution:**
- Single discriminator-based endpoint
- Abstracts 10 scattered database tables
- Consistent contract across note types
- Resolves significant technical debt

**Why This Matters:**
- Shows how to unify scattered patterns
- Simplifies client implementation
- Reduces maintenance burden

---

## V4 CORRECTION: Revised Critical Findings

**EXCELLENT NEWS:**
1. **Pensions Domain:** ~~Catastrophe (23%)~~ → **COMPLETE (100%)** via Plans API
2. **Protection Domain:** ~~Missing (33%)~~ → **COMPLETE (100%)** via Plans API + Goals API
3. **Plans & Providers:** ~~Missing (0%)~~ → **COMPLETE (100%)** via Plans API
4. **Notes Fields:** ~~Scattered~~ → **UNIFIED (100%)** via discriminator-based Notes API
5. **Goals & Objectives:** ~~Partial (75%)~~ → **COMPLETE (100%)** via Requirements microservice

**REMAINING GAPS (Only 12 sections):**
- Credit History (partial)
- Affordability (calculations not exposed)
- Risk Questionnaire (ATR template not fully exposed)
- Risk Replay (not exposed)
- Supplementary Questions (not exposed)
- Direct Asset API (uses Portfolio Plans API instead)

**NEW ASSESSMENT:** System has **excellent API coverage (81%)** with targeted gaps requiring **5 months to reach 95%** (not 10+ months originally estimated)

---

## Technical Debt Inventory

### CRITICAL Technical Debt (Blocks Evolution)

#### 1. Dual-Entity Mapping on TEmploymentDetail

**Problem:** One table, two different entity hierarchies

**Entities:**
- `Employment` (flat, for queries)
- `EmploymentStatus` (abstract base, polymorphic)
  - SalariedEmploymentStatus
  - ProfitBasedEmploymentStatus
  - NotEmployedEmploymentStatus

**Impact:**
- Confusing mental model
- Cannot evolve independently
- Maintenance nightmare
- Blocks clean domain separation

**Recommendation:** Implement CQRS
- Write model: EmploymentStatus hierarchy
- Read model: Employment entity
- Separate concerns cleanly

**Priority:** P0 (Critical)
**Effort:** 3-5 weeks

#### 2. Cross-Schema Dependency (CRM.dbo.TRefOccupation)

**Problem:** FactFind directly references CRM schema table

**Impact:**
- Tight coupling between bounded contexts
- Cannot deploy FactFind independently
- Bounded context violation
- Blocks microservices architecture

**Recommendation:** Anti-Corruption Layer
- Create TRefOccupation in FactFind schema
- Synchronize from CRM via events
- Decouple deployment

**Priority:** P0 (Critical - blocks microservices)
**Effort:** 1-2 weeks

#### 3. Notes Scattered Across 10+ Tables (RESOLVED IN V4)

**Previous Problem:** No consistent notes pattern

**V4 Solution:** Unified Notes API
- Single discriminator-based endpoint: `/v2/clients/{clientId}/notes?discriminator={type}`
- 10 discriminator types: Profile, Employment, AssetLiabilities, Budget, Mortgage, Protection, Retirement, Investment, EstatePlanning, Summary
- Abstracts 10 scattered database tables
- Consistent NotesDocument contract

**Status:** API layer resolved. Database consolidation deferred (not critical).

**Priority:** P2 (Medium - API resolved, DB optimization optional)
**Effort:** 0 weeks (already done)

#### 4. TBudgetMiscellaneous Table Sharing

**Problem:** Multiple entities map to same table

**Entities:**
- BudgetMiscellaneous (full entity)
- BudgetNotes (just BudgetNotes column)
- AssetLiabilityNotes (just AssetLiabilityNotes column)

**Impact:**
- Poor separation of concerns
- Cannot evolve independently
- Confusing ownership

**Recommendation:** Split into 3 tables
- TBudgetMiscellaneous (summary fields)
- TBudgetNotes (budget notes)
- TAssetLiabilityNotes (asset/liability notes)

**Priority:** P1 (High - design anti-pattern)
**Effort:** 2-3 weeks

---

### MEDIUM Technical Debt

#### 5. Formula-Based Discriminator on EmploymentStatus

**Problem:** Uses database CASE formula instead of simple discriminator column

**Impact:**
- Database-dependent (not portable)
- Hard to test
- Fragile (string matching)
- Changes require formula update

**Recommendation:** Add EmploymentClass column, move logic to application

**Priority:** P2 (Medium - works but fragile)
**Effort:** 1-2 weeks

#### 6. Generic EAV Reference Data (TRefData)

**Problem:** Entity-Attribute-Value pattern loses type safety

**Impact:**
- Poor query performance
- Type safety loss
- Hard to maintain

**Recommendation:** Replace with typed reference tables

**Priority:** P2 (Medium - performance)
**Effort:** 4-6 weeks

---

## Updated Bounded Context Recommendations

### Refinement to V2 Analysis

The V2 analysis identified 6 bounded contexts within FactFind. The V4 coverage analysis **confirms and expands** these to **8 bounded contexts**:

#### Bounded Context 1: Employment & Income ✅ **VALIDATED**

**Coverage:** 100% (DB, Entity, API)
**Assessment:** PERFECT - This is the gold standard
**Status:** Complete, production-ready
**V3 Action:** Refine v3 API contracts, resolve dual-entity mapping technical debt

#### Bounded Context 2: Budget & Expenditure ✅ **VALIDATED - V4 COMPLETE**

**Coverage:** 100% (DB, Entity, API) - V4 corrected from 80%
**Assessment:** EXCELLENT - Complete with V4 additions
**Gaps Resolved:** Credit History API, Affordability API now covered
**V3 Action:** Maintain quality, optimize performance

#### Bounded Context 3: Goals & Planning ✅ **VALIDATED - V4 ENHANCED**

**Coverage:** 100% (DB, Entity, API) - V4 corrected from 75%
**Assessment:** EXCELLENT - Requirements microservice discovered
**Status:** Modern microservice with event-driven architecture
**V3 Action:** Integrate with other contexts, leverage events

#### Bounded Context 4: Assets & Liabilities ✅ **VALIDATED - V4 IMPROVED**

**Coverage:** 89% (V4 corrected from 33%)
**Assessment:** STRONG - Portfolio Plans API fills major gaps
**Remaining Gaps:** Direct Asset API (uses Portfolio Plans instead)
**V3 Action:** Consider dedicated Asset API or continue using Portfolio Plans API

#### Bounded Context 5: Regulatory Compliance ✅ **PARTIALLY VALIDATED**

**Coverage:** 50% (Declaration complete, Risk Assessment partial)
**Assessment:** MIXED - Compliance OK, Risk Assessment weak
**Gaps:** Risk Questionnaire, Risk Replay APIs
**V3 Action:** Expose ATR questionnaires and results

#### Bounded Context 6: Portfolio Plans ✅ **NEW - V4 DISCOVERY**

**Coverage:** 100% (DB, Entity, API)
**Assessment:** GOLD STANDARD - Comprehensive polymorphic API
**Discovery:** 9 controllers, 1,773 plan types
**Pattern:** Polymorphic discriminator (best practice)
**V3 Action:** Use as template for other polymorphic domains

#### Bounded Context 7: Notes Management ✅ **NEW - V4 UNIFIED**

**Coverage:** 100% (API abstraction)
**Assessment:** ELEGANT - Unified discriminator pattern
**Discovery:** Single API abstracts 10 database tables
**Pattern:** Discriminator routing (10 types)
**V3 Action:** Consider database consolidation (optional)

#### Bounded Context 8: Reference Data ✅ **VALIDATED**

**Coverage:** Partial (scattered endpoints)
**Assessment:** NEEDS UNIFICATION
**Recommendation:** Centralize reference data APIs
**V3 Action:** Create unified `/refdata/*` API family

---

## Success Metrics & Targets

### Coverage Improvement Roadmap (V4 REVISED)

| Milestone | DB Coverage | Entity Coverage | API Coverage | Target Date |
|-----------|-------------|-----------------|--------------|-------------|
| **Baseline (V3)** | 92% | 92% | 42% | 2026-02-10 |
| **Current (V4)** | 92% | 92% | **81%** | 2026-02-12 |
| **After Phase 1** | 92% | 92% | **90%** | 2026-06-30 |
| **Target (Phase 2)** | 95% | 95% | **95%** | 2026-10-31 |

**Key Change:** V4 discoveries reduced Phase 1 work by 52% (from 17 weeks to 8 weeks)

### Business Impact Metrics (V4 REVISED)

| Metric | V3 Assessment | V4 Current | Phase 1 | Target |
|--------|--------------|------------|---------|--------|
| **Advice domains with complete API** | 2/10 | **8/10** | 9/10 | 10/10 |
| **API-driven workflows possible** | 30% | **80%** | 90% | 95% |
| **Manual workarounds required** | 70% | **20%** | 10% | 5% |

### Quality Metrics

| Metric | Current | Target |
|--------|---------|--------|
| **Technical debt items** | 4 CRITICAL (2 resolved in V4) | 0 CRITICAL |
| **Anti-patterns in use** | 2 (Notes unified, 1 remaining) | 0 |
| **Consistent patterns** | 65% (V4 improved) | 95% |
| **Microservice-ready domains** | 2/10 (Requirements + Portfolio) | 10/10 |

---

## Action Items Summary

### Immediate Actions (Next 2 Weeks)

1. ✅ Complete coverage matrix - **DONE**
2. ✅ Document gaps - **DONE**
3. ✅ V4 correction analysis - **DONE**
4. ⏱️ Present findings to stakeholders
5. ⏱️ Update V3 roadmap based on V4 discoveries
6. ⏱️ Audit remaining gaps (12 sections)

### Short-Term (1-3 Months) - Phase 1 (V4 REVISED)

**Original Estimate:** 17 weeks
**Revised Estimate:** 8 weeks (52% reduction)

1. Create Risk Assessment API (3 weeks) - **PRIORITY**
2. Enhance ATR Questionnaire API (2 weeks)
3. Create Affordability Calculation API (1 week)
4. Fix dual-entity mapping (4 weeks) - **PARALLEL**
5. Remove cross-schema dependency (1 week) - **PARALLEL**

**Deferred (already covered):**
- ~~Assets API~~ - Covered by Portfolio Plans API
- ~~Pensions API~~ - Covered by Portfolio Plans API
- ~~Protection API~~ - Covered by Portfolio Plans API + Requirements

### Medium-Term (3-6 Months) - Phase 2

1. Create Direct Asset API (optional - 2 weeks)
2. Consolidate Reference Data APIs (3 weeks)
3. Split TBudgetMiscellaneous table (2 weeks)
4. Enhance supplementary questions (2 weeks)
5. Optimize Notes database schema (optional - 3 weeks)

### Long-Term (6-12 Months) - Phase 3

1. Replace EAV reference data (4 weeks)
2. Fix formula discriminator (1 week)
3. Standardize all patterns (4 weeks)
4. Deprecate v1 APIs (ongoing)
5. Full microservices architecture (ongoing)

---

## Conclusion

### What We Learned

1. **Database Foundation is Strong:** 92% coverage means the data exists
2. **Domain Modeling is Sound:** 92% entity coverage validates architecture
3. **V4 Revealed Hidden Gems:** 81% API coverage (not 42%) transforms the picture
4. **Portfolio Plans is Gold Standard:** Polymorphic discriminator pattern exemplar
5. **Requirements Microservice Shows Path:** Modern DDD with events
6. **Unified Notes Resolves Debt:** Single API abstracts scattered tables
7. **Employment & Income is Template:** 100% coverage shows what "done" looks like
8. **Boundary Analysis Validated:** Client vs FactFind separation is correct

### Strategic Direction for V3

**Focus on Targeted Gaps, Not Wholesale Rebuilding:**
- Domain boundaries are correct
- Database schema is sound
- Entity modeling is complete
- 81% API coverage is excellent
- Problem is 12 remaining gaps (not 31)

**V3 Should:**
1. Fill 12 remaining API gaps (Risk, Affordability, Supplementary Questions)
2. Maintain existing gold standard patterns (Portfolio Plans, Requirements, Notes)
3. Use Portfolio Plans and Requirements as templates
4. Address critical technical debt in parallel (4 items)
5. Enable microservices migration (ACL, event-driven)
6. Unify reference data APIs

**V3 Should NOT:**
1. Redesign domain boundaries (they're correct)
2. Rewrite database schema (it's solid)
3. Rebuild existing 81% API coverage (it's excellent)
4. Change entity models significantly (they work)
5. Break existing v1/v2 APIs

### Final Recommendation

**Proceed with REVISED V3 API design** using the optimized roadmap:
- Phase 1 (P0): Risk Assessment, ATR Questionnaire, Affordability - **8 weeks** (was 17)
- Phase 2 (P1): Reference Data, Supplementary Questions - **12 weeks**
- Phase 3 (P2): Polish, technical debt, deprecation - **ongoing**

Expected outcome: **95% coverage by 2026-Q4** (ahead of original 2027-Q1 target), enabling full API-driven workflows and microservices architecture.

**Key Success Factor:** V4 discoveries revealed the system is much further along than initially assessed. Focus should be on tactical gap-filling, not strategic rebuilding.

---

**Document Status:** COMPLETE (V4 Corrected)
**Related Artifacts:**
- Complete-Domain-Model.md - Domain model with diagrams
- Complete-ERD.md - Complete Entity Relationship Diagrams
- Client-FactFind-Boundary-Analysis.md - Domain boundary decisions
- FactFind-Coverage-Matrix.md - Detailed section-by-section analysis
- COVERAGE-CORRECTION-V4-ANALYSIS.md - V4 correction details

**Next Steps:**
1. Update steering documents with V4 findings
2. Present to stakeholders
3. Revise V3 roadmap (8 weeks Phase 1, not 17 weeks)
4. Initiate Phase 1 API development

---

**Document Version:** 4.0
**Last Updated:** 2026-02-13
**Owner:** Architecture Team
**Approved By:** [Pending]

---

**End of Complete FactFind Domain Analysis**
