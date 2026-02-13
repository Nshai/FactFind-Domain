# FactFind V4 Implementation Roadmap

**Document Version:** 1.0
**Date:** 2026-02-12
**Status:** ACTIVE - Ready for Execution
**Timeline:** 20 weeks to 95% API coverage
**Baseline Coverage:** 81% (50/62 sections)
**Target Coverage:** 95% (59/62 sections)

---

## Executive Summary

This roadmap defines the implementation plan to reach 95% API coverage following the V4 coverage correction analysis. The discovery of comprehensive existing APIs (Portfolio Plans, Unified Notes, Requirements microservice) reduces the scope from 42 weeks to 20 weeks, focusing on filling 12 remaining gaps rather than building 31+ new APIs.

### Roadmap at a Glance

| Phase | Duration | Focus | API Coverage Gain | Status |
|-------|----------|-------|-------------------|--------|
| **Phase 1: Critical Gaps** | 6 weeks | 3 missing APIs | 81% → 85% (+4%) | PLANNED |
| **Phase 2: High-Value Additions** | 9 weeks | 2 new APIs + tech debt | 85% → 88% (+3%) | PLANNED |
| **Phase 3: Quality & Polish** | 13 weeks | Standardization | 88% → 95% (+7%) | PLANNED |
| **TOTAL** | **28 weeks** | **7 months to 95%** | **+14 percentage points** | ACTIVE |

### Key Principles

1. **Build on Success** - Leverage excellent 81% existing coverage
2. **Fill Targeted Gaps** - Focus on 12 missing sections, not 36
3. **Proven Patterns** - Extend existing architectural patterns
4. **Low Risk** - Incremental changes, not greenfield rebuild
5. **Fast Value** - Critical gaps filled in 6 weeks

---

## Phase 1: Critical Gaps (Weeks 1-6)

**Objective:** Fill the 3 most critical API gaps that block core business workflows.

**Timeline:** 6 weeks
**Team Size:** 2-3 developers, 1 QA, 1 architect
**Risk:** LOW - Well-defined requirements, small scope

### 1.1 Affordability API (Week 1)

**Priority:** P0 - CRITICAL
**Business Impact:** Enables mortgage advice calculations
**Effort:** 1 week
**Complexity:** LOW (calculation API, read-only)

**Requirements:**
- Calculate mortgage affordability based on income/expenditure
- Support multiple affordability calculation methods (UK FCA guidance)
- Return affordability breakdown with assumptions
- No persistence required (calculation only)

**API Design:**
```
POST /v3/clients/{clientId}/affordability/calculate
Request:
{
  "incomeIds": [123, 456],
  "expenditureId": 789,
  "mortgageAmount": 250000,
  "mortgageTerm": 25,
  "interestRate": 3.5,
  "calculationMethod": "FCAStressed"
}

Response:
{
  "affordability": {
    "totalIncome": 60000,
    "totalExpenditure": 24000,
    "disposableIncome": 36000,
    "maxBorrowingCapacity": 270000,
    "monthlyPaymentCapacity": 1800,
    "isAffordable": true,
    "stressTestPassed": true,
    "assumptions": [...]
  }
}
```

**Database:** No persistence needed (calculation service)
**Integration Points:** Income API, Expenditure API
**Success Criteria:** Mortgage advisers can calculate affordability via API

---

### 1.2 Credit History API (Weeks 2-3)

**Priority:** P0 - CRITICAL
**Business Impact:** Enables risk assessment and mortgage underwriting
**Effort:** 2 weeks
**Complexity:** MEDIUM (CRUD + credit report integration)

**Requirements:**
- CRUD operations for client credit history
- Store credit check results
- Link to external credit reference agencies (Experian, Equifax)
- Support multiple credit checks per client (historical tracking)
- Audit trail for regulatory compliance

**API Design:**
```
GET    /v3/clients/{clientId}/credit-history
POST   /v3/clients/{clientId}/credit-history
GET    /v3/clients/{clientId}/credit-history/{id}
PUT    /v3/clients/{clientId}/credit-history/{id}
DELETE /v3/clients/{clientId}/credit-history/{id}

Entity:
{
  "id": 123,
  "creditCheckDate": "2026-02-12",
  "creditReferenceAgency": "Experian",
  "creditScore": 750,
  "creditRating": "Excellent",
  "reportReference": "EXP-2026-123456",
  "adverseCredit": false,
  "ccjs": 0,
  "defaults": 0,
  "bankruptcies": 0,
  "notes": "Clean credit history",
  "checkedBy": "adviser@firm.com"
}
```

**Database:** TCreditHistory table (already exists)
**Integration Points:** External credit agencies (future), Liability API
**Success Criteria:** Credit history can be captured and retrieved via API

---

### 1.3 Risk Questionnaire API (Weeks 4-6)

**Priority:** P0 - CRITICAL
**Business Impact:** Regulatory compliance (ATR - Attitude to Risk)
**Effort:** 3 weeks
**Complexity:** HIGH (questionnaire configuration + client responses + scoring)

**Requirements:**
- Configure questionnaires (firm-level)
- Store client responses (client-level)
- Calculate risk scores
- Support multiple questionnaire versions (regulatory changes)
- Audit trail for responses
- Integration with Requirements microservice (RiskProfile)

**API Design:**
```
# Configuration API (Firm-level)
GET    /v3/risk/questionnaires
POST   /v3/risk/questionnaires
GET    /v3/risk/questionnaires/{id}
PUT    /v3/risk/questionnaires/{id}

# Client Response API
GET    /v3/clients/{clientId}/risk/assessments
POST   /v3/clients/{clientId}/risk/assessments
GET    /v3/clients/{clientId}/risk/assessments/{id}

Questionnaire Entity:
{
  "id": 1,
  "name": "FCA Compliant ATR v2.1",
  "version": "2.1",
  "effectiveDate": "2026-01-01",
  "questions": [
    {
      "id": "Q1",
      "text": "How would you react to a 20% market drop?",
      "type": "MultipleChoice",
      "options": [...],
      "scoringWeights": {...}
    }
  ]
}

Assessment Entity:
{
  "id": 456,
  "clientId": 123,
  "questionnaireId": 1,
  "assessmentDate": "2026-02-12",
  "responses": [
    {"questionId": "Q1", "answer": "Hold", "score": 3}
  ],
  "totalScore": 42,
  "riskProfile": "Balanced",
  "assessedBy": "adviser@firm.com"
}
```

**Database:** TAtrQuestion, TAtrAnswer tables (already exist)
**Integration Points:** Requirements microservice (publish RiskProfile updates)
**Success Criteria:** Risk questionnaires can be configured and client assessments captured via API

---

### Phase 1 Deliverables

**Week 6 Outcomes:**
- ✅ Affordability API live in production
- ✅ Credit History API live in production
- ✅ Risk Questionnaire API live in production
- ✅ API Coverage: 81% → 85%
- ✅ 3 critical gaps filled
- ✅ Mortgage advice workflows enabled
- ✅ Regulatory compliance (ATR) enabled

**Phase 1 Success Metrics:**
- All 3 APIs pass integration tests
- Documentation published
- No P0/P1 bugs
- Performance SLAs met (p95 < 200ms)
- Advisers can complete end-to-end workflows

---

## Phase 2: High-Value Additions (Weeks 7-15)

**Objective:** Add high-value APIs and address critical technical debt.

**Timeline:** 9 weeks
**Team Size:** 2-3 developers, 1 QA, 1 architect
**Risk:** MEDIUM - Includes technical debt refactoring

### 2.1 Risk Replay API (Weeks 7-8)

**Priority:** P1 - HIGH
**Business Impact:** Audit trail for risk assessments (regulatory requirement)
**Effort:** 2 weeks
**Complexity:** MEDIUM (historical data storage + reporting)

**Requirements:**
- Store historical risk assessments
- Track risk profile changes over time
- Compare current vs historical assessments
- Generate audit reports
- Support regulatory queries

**API Design:**
```
GET /v3/clients/{clientId}/risk/history
GET /v3/clients/{clientId}/risk/history/{assessmentId}
GET /v3/clients/{clientId}/risk/comparison?from={date1}&to={date2}
```

**Database:** TAtrInvestment, TAtrRetirement tables (already exist)
**Integration Points:** Risk Questionnaire API
**Success Criteria:** Historical risk assessments can be queried for audit purposes

---

### 2.2 Supplementary Questions API (Weeks 9-10)

**Priority:** P1 - HIGH
**Business Impact:** Additional compliance questions (FCA, GDPR, etc.)
**Effort:** 2 weeks
**Complexity:** MEDIUM (questionnaire pattern, similar to Risk Questionnaire)

**Requirements:**
- Configure supplementary questions (firm-level)
- Capture client answers (client-level)
- Support multiple question types (text, multiple choice, yes/no)
- Group questions by category (Risk, General, Mortgage)

**API Design:**
```
GET    /v3/supplementary-questions
POST   /v3/supplementary-questions
GET    /v3/clients/{clientId}/supplementary-answers
POST   /v3/clients/{clientId}/supplementary-answers
```

**Database:** TAdditionalRiskQuestion table (already exists)
**Integration Points:** Risk Questionnaire API
**Success Criteria:** Supplementary questions can be configured and answers captured

---

### 2.3 Technical Debt: Fix Dual-Entity Mapping (Weeks 11-14)

**Priority:** P1 - TECHNICAL DEBT
**Business Impact:** Enables clean domain modeling and future evolution
**Effort:** 4 weeks
**Complexity:** HIGH (requires data migration and API updates)

**Problem:**
- `TEmploymentDetail` table mapped to TWO entities:
  1. `Employment` (flat query entity)
  2. `EmploymentStatus` (polymorphic hierarchy: Salaried, ProfitBased, NotEmployed)
- Causes confusion, data inconsistency risk, maintenance burden

**Solution: Implement CQRS Pattern**
- **Write Model:** EmploymentStatus hierarchy (commands)
- **Read Model:** Employment entity (queries)
- **Migration:** Create read model view/table

**Implementation:**
1. Create TEmploymentReadModel table
2. Populate from TEmploymentDetail
3. Update Employment API to use read model
4. Update EmploymentStatus API to use write model
5. Implement synchronization (write → read)
6. Migrate existing API consumers

**Database Changes:**
- Add: TEmploymentReadModel (new table)
- Keep: TEmploymentDetail (write model)
- Add: Synchronization trigger/service

**Success Criteria:**
- Write and read models separated
- No data inconsistencies
- API consumers migrated with zero downtime
- Future employment type changes isolated to write model

---

### 2.4 Technical Debt: Remove Cross-Schema Dependency (Week 15)

**Priority:** P1 - TECHNICAL DEBT
**Business Impact:** Enables microservices migration
**Effort:** 1 week
**Complexity:** LOW (data copy + schema change)

**Problem:**
- FactFind references `CRM.dbo.TRefOccupation` directly
- Blocks independent deployment of FactFind
- Violates bounded context boundaries

**Solution: Anti-Corruption Layer**
- Create `TRefOccupation` in FactFind schema
- Synchronize from CRM via events
- Update FactFind references

**Implementation:**
1. Create FactFind.dbo.TRefOccupation
2. Copy data from CRM.dbo.TRefOccupation
3. Update FactFind mappings
4. Implement event listener (CRM occupation changes)
5. Remove cross-schema reference

**Database Changes:**
- Add: FactFind.dbo.TRefOccupation
- Update: Occupation.hbm.xml mapping
- Remove: Cross-schema reference

**Success Criteria:**
- FactFind no longer references CRM schema directly
- Occupation data synchronized via events
- Independent deployment possible

---

### Phase 2 Deliverables

**Week 15 Outcomes:**
- ✅ Risk Replay API live
- ✅ Supplementary Questions API live
- ✅ Dual-entity mapping resolved (Employment)
- ✅ Cross-schema dependency removed (Occupation)
- ✅ API Coverage: 85% → 88%
- ✅ Technical debt reduced
- ✅ Microservices readiness improved

**Phase 2 Success Metrics:**
- All APIs operational
- Employment CQRS pattern working
- Zero data inconsistencies
- FactFind independently deployable
- Performance maintained or improved

---

## Phase 3: Quality & Polish (Weeks 16-28)

**Objective:** Standardize patterns, improve documentation, create unified API gateway.

**Timeline:** 13 weeks
**Team Size:** 2-3 developers, 1 technical writer, 1 architect
**Risk:** LOW - Quality improvements, no breaking changes

### 3.1 API Gateway Unification (Weeks 16-18)

**Effort:** 3 weeks
**Impact:** Consistent routing, authentication, error handling

**Tasks:**
- Design unified API gateway architecture
- Implement consistent routing patterns
- Standardize authentication/authorization
- Unified error handling (RFC 7807)
- Rate limiting and throttling
- API versioning strategy
- Cross-domain query support

**Deliverables:**
- API Gateway deployed
- All APIs routed through gateway
- Consistent patterns applied

---

### 3.2 Pattern Standardization (Weeks 19-21)

**Effort:** 3 weeks
**Impact:** Consistent developer experience across all APIs

**Tasks:**
- Audit all 50+ APIs for pattern consistency
- Standardize pagination (cursor-based)
- Standardize filtering (OData)
- Standardize sorting (orderBy parameter)
- Standardize error responses
- Standardize concurrency (ETags)
- Standardize HATEOAS links

**Deliverables:**
- Pattern consistency checklist
- All APIs updated to standard patterns
- OpenAPI specs updated

---

### 3.3 Replace EAV Reference Data (Weeks 22-25)

**Effort:** 4 weeks
**Impact:** Performance improvement, type safety

**Problem:**
- TRefData uses Entity-Attribute-Value pattern
- Poor query performance
- Lacks type safety
- Hard to maintain

**Solution:**
- Replace with typed reference tables
- TRefIncomeFrequency, TRefDurations, TRefCategories, etc.

**Implementation:**
- Create typed reference tables
- Migrate data from TRefData
- Update API references
- Performance testing

---

### 3.4 Fix Formula-Based Discriminator (Week 26)

**Effort:** 1 week
**Impact:** Removes database dependency

**Problem:**
- EmploymentStatus uses database CASE formula for discriminator
- Fragile, hard to test, database-dependent

**Solution:**
- Add EmploymentClass column
- Move logic to application layer

---

### 3.5 Documentation & Training (Weeks 27-28)

**Effort:** 2 weeks
**Impact:** Developer productivity, adoption

**Tasks:**
- Complete API documentation
- Create integration guides
- Pattern documentation
- Architecture decision records (ADRs)
- Migration guides (v1 → v2 → v3)
- Video tutorials
- Code samples
- Postman collections

**Deliverables:**
- API documentation portal
- Integration guides published
- Training materials available
- Migration tooling ready

---

### Phase 3 Deliverables

**Week 28 Outcomes:**
- ✅ API Gateway operational
- ✅ All APIs standardized
- ✅ EAV reference data replaced
- ✅ Formula discriminator fixed
- ✅ Comprehensive documentation
- ✅ API Coverage: 88% → 95%
- ✅ Developer experience excellent
- ✅ System production-ready

---

## Resource Requirements

### Team Composition

**Core Team (Full Duration):**
- 1 Technical Architect (part-time, 50%)
- 2 Senior Backend Developers (full-time)
- 1 QA Engineer (full-time)
- 1 Technical Writer (Phase 3 only)

**Support Team (Part-time):**
- 1 Frontend Developer (integration testing)
- 1 DevOps Engineer (deployment, monitoring)
- 1 Database Administrator (schema changes)

**Total Effort:**
- Development: ~40 person-weeks
- QA: ~20 person-weeks
- Architecture: ~10 person-weeks
- Documentation: ~6 person-weeks
- **Total:** ~76 person-weeks over 28 weeks

### Budget Estimate

**Development Costs:**
- Senior Developer (£800/day × 2 × 140 days): £224,000
- QA Engineer (£500/day × 140 days): £70,000
- Technical Architect (£1,000/day × 70 days): £70,000
- Technical Writer (£400/day × 10 days): £4,000
- **Total Development:** £368,000

**Infrastructure & Tools:**
- API Gateway license: £10,000/year
- Monitoring tools: £5,000/year
- Development environments: £5,000
- **Total Infrastructure:** £20,000

**TOTAL ESTIMATED COST:** £388,000

**Comparison to Original V3 Plan:**
- Original estimate (42 weeks): £650,000
- Revised estimate (28 weeks): £388,000
- **Cost Savings:** £262,000 (40% reduction)

---

## Success Metrics

### Coverage Metrics

| Milestone | API Coverage | Sections Covered | Target Date |
|-----------|-------------|------------------|-------------|
| Baseline (Today) | 81% (50/62) | 50 sections | 2026-02-12 |
| Phase 1 Complete | 85% (53/62) | 53 sections | 2026-03-26 (Week 6) |
| Phase 2 Complete | 88% (55/62) | 55 sections | 2026-05-21 (Week 15) |
| Phase 3 Complete | 95% (59/62) | 59 sections | 2026-08-27 (Week 28) |

### Quality Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| API Response Time (p95) | < 200ms | Performance monitoring |
| API Availability | > 99.9% | Uptime monitoring |
| API Error Rate | < 0.1% | Error tracking |
| Test Coverage | > 80% | Code coverage tools |
| Documentation Coverage | 100% | API documentation audit |
| Breaking Changes | 0 | API versioning compliance |

### Business Impact Metrics

| Metric | Baseline | Phase 1 | Phase 2 | Phase 3 |
|--------|----------|---------|---------|---------|
| API-Driven Workflows | 81% | 90% | 95% | 98% |
| Manual Workarounds | 19% | 10% | 5% | 2% |
| Developer Onboarding Time | 4 weeks | 3 weeks | 2 weeks | < 2 weeks |
| Integration Time (New Partner) | 8 weeks | 6 weeks | 4 weeks | 3 weeks |

---

## Risk Management

### Phase 1 Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Requirements Unclear (Affordability)** | MEDIUM | HIGH | Early stakeholder workshops, prototype validation |
| **Credit Agency Integration Delays** | HIGH | MEDIUM | Decouple Credit History API from agency integration, phase agency integration later |
| **Risk Questionnaire Complexity** | MEDIUM | HIGH | Start with minimal viable questionnaire, iterate based on feedback |
| **Resource Availability** | MEDIUM | HIGH | Pre-allocate team 2 weeks before start, backup developers identified |

### Phase 2 Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Employment CQRS Migration Complexity** | HIGH | HIGH | Thorough testing, feature flags, gradual rollout, rollback plan |
| **Data Inconsistency During Migration** | MEDIUM | HIGH | Dual-write period, validation checks, automated reconciliation |
| **API Consumer Disruption** | MEDIUM | HIGH | Maintain backwards compatibility, deprecation warnings, migration tooling |

### Phase 3 Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **API Gateway Performance** | MEDIUM | MEDIUM | Load testing, caching strategy, gradual rollout |
| **Pattern Standardization Breaks Consumers** | LOW | HIGH | Non-breaking changes only, versioning, comprehensive testing |
| **Documentation Incomplete** | MEDIUM | MEDIUM | Dedicated technical writer, documentation-driven development |

### Overall Project Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Scope Creep** | HIGH | HIGH | Strict scope management, change control process, stakeholder alignment |
| **Team Attrition** | MEDIUM | HIGH | Knowledge sharing, documentation, cross-training, backup resources |
| **Dependency on External Teams** | MEDIUM | MEDIUM | Early coordination, clear interfaces, fallback plans |
| **Production Issues Post-Deployment** | MEDIUM | HIGH | Comprehensive testing, staged rollouts, monitoring, rollback procedures |

---

## Dependencies

### External Dependencies

1. **CRM Team** - Cross-schema dependency removal coordination
2. **Portfolio Team** - Plans API enhancement coordination
3. **Requirements Team** - Risk profile integration
4. **Infrastructure Team** - API Gateway provisioning
5. **Compliance Team** - Risk questionnaire validation

### Technical Dependencies

1. **Database Team** - Schema changes, performance tuning
2. **DevOps Team** - CI/CD pipeline updates
3. **Security Team** - Authentication/authorization reviews
4. **Frontend Team** - API consumer updates

### Business Dependencies

1. **Product Owners** - Affordability calculation requirements
2. **Compliance Officers** - Risk questionnaire validation
3. **Advisers** - UAT and feedback
4. **Training Team** - Documentation and training materials

---

## Communication Plan

### Weekly Status Updates

**Audience:** Development team, architects, product owners
**Format:** Email summary + Slack update
**Content:**
- Progress against plan
- Blockers and risks
- Upcoming milestones
- Help needed

### Fortnightly Steering Committee

**Audience:** Senior stakeholders, executive sponsors
**Format:** 30-minute meeting + slide deck
**Content:**
- Phase progress
- Budget and timeline status
- Key decisions needed
- Risk escalation

### Monthly Demo Sessions

**Audience:** All stakeholders, advisers, partners
**Format:** 1-hour live demo
**Content:**
- New APIs demonstrated
- Real-world use cases
- Q&A session
- Feedback collection

### Phase Completion Reviews

**Audience:** Full project team + stakeholders
**Format:** Half-day workshop
**Content:**
- Retrospective (what went well, what didn't)
- Lessons learned
- Next phase planning
- Celebration of achievements

---

## Change Control Process

### Minor Changes (No Impact on Timeline/Budget)

**Process:**
- Developer proposes change
- Architect reviews and approves
- Update task tracking
- Communicate to team

### Major Changes (Impact on Timeline/Budget)

**Process:**
1. Change request submitted with impact analysis
2. Architect review and recommendation
3. Steering committee approval required
4. Update project plan
5. Communicate to all stakeholders
6. Re-baseline if necessary

### Emergency Changes (Production Issues)

**Process:**
- Follow incident management process
- Hotfix approval from technical architect
- Deploy with accelerated testing
- Post-incident review
- Update documentation

---

## Success Criteria

### Phase 1 Success Criteria

- ✅ All 3 critical APIs deployed to production
- ✅ Zero P0/P1 bugs
- ✅ Performance SLAs met
- ✅ API documentation complete
- ✅ Integration tests passing
- ✅ Adviser workflows enabled
- ✅ Coverage increased to 85%

### Phase 2 Success Criteria

- ✅ Risk Replay and Supplementary Questions APIs live
- ✅ Employment CQRS pattern operational
- ✅ Cross-schema dependency removed
- ✅ Zero data inconsistencies
- ✅ FactFind independently deployable
- ✅ Coverage increased to 88%

### Phase 3 Success Criteria

- ✅ API Gateway operational with all APIs
- ✅ Pattern standardization complete
- ✅ EAV reference data replaced
- ✅ Comprehensive documentation published
- ✅ Training materials available
- ✅ Coverage reached 95%
- ✅ Developer experience excellent
- ✅ Production-ready system

### Overall Project Success Criteria

- ✅ 95% API coverage achieved (59/62 sections)
- ✅ All critical business workflows API-enabled
- ✅ Technical debt reduced significantly
- ✅ System microservices-ready
- ✅ Documentation complete
- ✅ Training delivered
- ✅ Timeline met (28 weeks)
- ✅ Budget met (£388k)
- ✅ Zero breaking changes to existing consumers
- ✅ Adviser and partner satisfaction high

---

## Next Actions

### Immediate (This Week)

1. ✅ Complete V4 documentation updates - **IN PROGRESS**
2. **Present V4 findings to stakeholders** - Schedule presentation
3. **Secure budget approval** - £388k vs original £650k
4. **Allocate team resources** - 2 senior devs, 1 QA, 1 architect
5. **Set up project tracking** - Jira, Confluence, Slack channel

### Pre-Phase 1 (Next 2 Weeks)

1. **Requirements workshops** - Affordability, Credit History, Risk Questionnaire
2. **API design specifications** - Detailed specs for 3 Phase 1 APIs
3. **Database schema design** - TCreditHistory, TAtrQuestion/Answer
4. **Environment setup** - Dev, test, staging environments
5. **Team onboarding** - Knowledge transfer, existing API walkthrough

### Phase 1 Kickoff (Week 1)

1. **Sprint planning** - Week 1 deliverables
2. **Affordability API development** - Start implementation
3. **Daily standups** - Team synchronization
4. **Stakeholder communication** - Weekly status updates begin

---

**Document Status:** ACTIVE
**Owner:** Architecture Team
**Approved By:** [Pending Steering Committee]
**Next Review:** End of Phase 1 (Week 6)

---

**END OF V4 IMPLEMENTATION ROADMAP**
