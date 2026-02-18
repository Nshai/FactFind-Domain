# FactFind API v2.0 - Implementation Roadmap

**Document Purpose:** Phased implementation plan for delivering the FactFind API v2.0

**Date:** 2026-02-18
**Duration:** 20 weeks (5 months)
**Team Size:** 8-12 developers
**Status:** Ready for Planning

---

## Executive Summary

This roadmap provides a **5-phase, 20-week implementation plan** for delivering the complete FactFind API v2.0. The plan prioritizes compliance-critical features, follows domain-driven design principles, and ensures regulatory readiness at each phase.

### Key Milestones

| Phase | Duration | Deliverable | Coverage |
|-------|----------|-------------|----------|
| **Phase 1** | Weeks 1-4 | Core Infrastructure & Clients | 15% |
| **Phase 2** | Weeks 5-8 | Risk & Compliance | 35% |
| **Phase 3** | Weeks 9-12 | Wealth Management | 60% |
| **Phase 4** | Weeks 13-16 | Goals & Estate Planning | 85% |
| **Phase 5** | Weeks 17-20 | Testing & Refinement | 100% |

---

## Phase 1: Core Infrastructure & Clients (Weeks 1-4)

### Objective
Establish foundational API infrastructure, authentication, and basic client management capabilities.

### Week 1: Infrastructure Setup

**Backend Setup:**
- [ ] Set up API Gateway (AWS API Gateway, Kong, or similar)
- [ ] Configure authentication service (JWT tokens, OAuth 2.0)
- [ ] Set up authorization service (role-based access control)
- [ ] Configure database (PostgreSQL or SQL Server)
- [ ] Set up Redis for caching
- [ ] Configure logging and monitoring (ELK stack or CloudWatch)

**DevOps:**
- [ ] Set up CI/CD pipelines (GitHub Actions, GitLab CI, or Jenkins)
- [ ] Configure development, staging, production environments
- [ ] Set up Docker containers
- [ ] Configure Kubernetes or ECS for orchestration

**Deliverables:**
- API Gateway operational
- Authentication service live
- Database provisioned
- Monitoring dashboards active

---

### Week 2: Common Patterns & Root API

**API Foundation:**
- [ ] Implement HATEOAS link generation
- [ ] Implement RFC 7807 error responses
- [ ] Implement request/response logging middleware
- [ ] Implement rate limiting
- [ ] Implement request validation middleware
- [ ] Implement ETag generation for concurrency control

**Section 4: FactFind Root API**
- [ ] Implement `/api/v1/factfinds` (CRUD operations)
- [ ] Implement vulnerability assessment endpoint
- [ ] Implement complete fact find retrieval
- [ ] Implement pagination and filtering
- [ ] Write unit tests (80% coverage target)

**Deliverables:**
- FactFind CRUD operations functional
- Common middleware operational
- Unit tests passing

---

### Week 3: Client Management (Basic)

**Section 5.1-5.4: Core Client Operations**
- [ ] Implement `/api/v1/factfinds/{factfindId}/clients` (CRUD)
- [ ] Implement Person, Corporate, Trust subtypes
- [ ] Implement address management endpoints
- [ ] Implement contact management endpoints
- [ ] Implement client search and filtering
- [ ] Implement soft delete functionality
- [ ] Write unit tests (80% coverage)

**Data Model:**
- [ ] Create Client entity with inheritance (Person, Corporate, Trust)
- [ ] Create Address value type
- [ ] Create Contact value type
- [ ] Create database migrations
- [ ] Seed reference data (titles, genders, marital statuses)

**Deliverables:**
- Client CRUD operations live
- Address and contact management working
- Database schema deployed

---

### Week 4: Current Position Summary

**Section 4.4: Financial Position Tracking**
- [ ] Implement `/api/v1/factfinds/{factfindId}/current-position`
- [ ] Implement net worth calculation engine
- [ ] Implement financial health scoring (0-100)
- [ ] Implement asset allocation aggregation
- [ ] Implement cash flow analysis
- [ ] Write unit tests

**Business Logic:**
- [ ] Aggregate assets from arrangements, properties, equities
- [ ] Aggregate liabilities from mortgages, loans
- [ ] Calculate emergency fund adequacy (6 months expenses)
- [ ] Calculate debt-to-income ratio
- [ ] Calculate savings rate
- [ ] Calculate portfolio diversification score

**Deliverables:**
- Current position endpoint functional
- Financial health calculations accurate
- Performance optimized (< 500ms response time)

---

### Phase 1 Acceptance Criteria

✅ **Technical:**
- All Phase 1 endpoints operational
- 80%+ unit test coverage
- < 200ms average response time
- Zero critical security vulnerabilities

✅ **Functional:**
- Can create and manage fact finds
- Can create and manage clients (all types)
- Can retrieve current financial position
- HATEOAS links working correctly

✅ **Compliance:**
- Audit logging operational
- PII fields encrypted at rest
- Authentication and authorization enforced

---

## Phase 2: Risk & Compliance (Weeks 5-8)

### Objective
Deliver compliance-critical risk assessment and data protection capabilities. FCA and GDPR ready.

### Week 5: Identity Verification & KYC

**Section 5.5: Identity Verification API**
- [ ] Implement document upload endpoints
- [ ] Integrate with identity verification provider (Onfido or Jumio)
- [ ] Implement KYC workflow state machine
- [ ] Implement document verification status tracking
- [ ] Implement verification history
- [ ] Write unit and integration tests

**Integration:**
- [ ] Set up Onfido/Jumio sandbox accounts
- [ ] Configure webhook listeners for verification results
- [ ] Implement document storage (S3 or Azure Blob)
- [ ] Implement document retention policies (7 years)

**Deliverables:**
- Identity verification workflow operational
- Document upload and verification working
- Provider integration complete

---

### Week 6: AML Screening & MLR 2017 Compliance

**Section 5.5: AML Checks**
- [ ] Integrate with AML screening provider (World-Check, Dow Jones, ComplyAdvantage)
- [ ] Implement sanctions list screening
- [ ] Implement PEP (Politically Exposed Person) checks
- [ ] Implement adverse media screening
- [ ] Implement risk scoring (Low, Medium, High, Prohibited)
- [ ] Implement Enhanced Due Diligence (EDD) triggers
- [ ] Write integration tests

**Compliance:**
- [ ] Implement MLR 2017 compliance tracking
- [ ] Implement re-verification reminders (every 2 years)
- [ ] Implement CDD (Customer Due Diligence) audit trail
- [ ] Configure compliance reporting

**Deliverables:**
- AML screening operational
- MLR 2017 compliance met
- Risk-based approach implemented

---

### Week 7: Data Protection & GDPR

**Section 5.6: Data Protection & Consent API**
- [ ] Implement consent management endpoints
- [ ] Implement consent audit trail (GDPR Article 7)
- [ ] Implement Right to be Forgotten (RTBF) workflow
- [ ] Implement Data Portability export (JSON/CSV)
- [ ] Implement consent refresh mechanisms
- [ ] Implement privacy policy versioning
- [ ] Write unit tests

**GDPR Implementation:**
- [ ] Implement lawful basis tracking (Consent, Contract, Legitimate Interest)
- [ ] Implement data retention policies
- [ ] Implement data inventory (what data we hold)
- [ ] Implement DSAR (Data Subject Access Request) workflow
- [ ] Implement data rectification endpoint
- [ ] Configure GDPR compliance reporting

**Deliverables:**
- GDPR Articles 6-21 compliance achieved
- Consent management operational
- RTBF workflow functional

---

### Week 8: Marketing Preferences & Risk Questionnaires

**Section 5.7: Marketing Preferences API**
- [ ] Implement marketing preferences endpoints
- [ ] Implement PECR-compliant opt-in workflow
- [ ] Implement double opt-in for email
- [ ] Implement one-click unsubscribe
- [ ] Implement suppression list management
- [ ] Integrate with TPS/CTPS/MPS services
- [ ] Write unit tests

**Section 10.4: Risk Questionnaire API (Basic)**
- [ ] Implement questionnaire template CRUD
- [ ] Implement question bank
- [ ] Implement questionnaire versioning
- [ ] Implement scoring algorithms
- [ ] Create default FCA-compliant ATR questionnaire (15 questions)
- [ ] Write unit tests

**Deliverables:**
- Marketing consent PECR-compliant
- Risk questionnaire templates operational
- Default ATR questionnaire deployed

---

### Phase 2 Acceptance Criteria

✅ **Technical:**
- All Phase 2 endpoints operational
- 80%+ unit test coverage
- Provider integrations working (Onfido, WorldCheck)

✅ **Functional:**
- Can verify client identity
- Can perform AML screening
- Can manage GDPR consents
- Can manage marketing preferences
- Can create and use risk questionnaires

✅ **Compliance:**
- MLR 2017 compliant (KYC/AML)
- GDPR compliant (Articles 6-21)
- PECR compliant (marketing consent)
- FCA-ready (ATR questionnaire template)

---

## Phase 3: Wealth Management (Weeks 9-12)

### Objective
Deliver comprehensive wealth tracking capabilities including income, arrangements, properties, equities, and investments.

### Week 9: Income & Expenditure

**Section 6: Income & Expenditure API**
- [ ] Implement income CRUD operations
- [ ] Implement expenditure CRUD operations
- [ ] Implement budget summary calculations
- [ ] Implement employment tracking
- [ ] Implement affordability calculations
- [ ] Implement income/expenditure comparison
- [ ] Write unit tests

**Business Logic:**
- [ ] Implement income frequency conversions (monthly, annual)
- [ ] Implement expenditure categorization (essential vs. discretionary)
- [ ] Implement disposable income calculation
- [ ] Implement budget variance analysis

**Deliverables:**
- Income and expenditure tracking operational
- Budget calculations accurate
- Affordability assessments working

---

### Week 10: Arrangements & Pensions

**Section 7: Arrangements API**
- [ ] Implement arrangement CRUD (polymorphic for product types)
- [ ] Implement pension arrangements (Personal Pension, SIPP, DB, DC)
- [ ] Implement contribution tracking
- [ ] Implement valuation tracking
- [ ] Implement withdrawal/income tracking
- [ ] Implement beneficiary management
- [ ] Write unit tests

**Product Types:**
- [ ] Personal Pension
- [ ] Occupational Pension (DB, DC)
- [ ] State Pension
- [ ] Protection products (Life, Critical Illness, Income Protection)
- [ ] Investment products (ISA, GIA, Bonds)
- [ ] Mortgages

**Deliverables:**
- Arrangement management operational
- Pension tracking complete
- Product type polymorphism working

---

### Week 11: Properties & Equities

**Section 9.4: Property Management API**
- [ ] Implement property CRUD operations
- [ ] Implement property valuation tracking
- [ ] Implement LTV calculations
- [ ] Implement rental yield calculations (gross/net)
- [ ] Implement CGT calculations (with PRR and Letting Relief)
- [ ] Implement SDLT tracking
- [ ] Write unit tests

**Section 9.5: Equities Portfolio API**
- [ ] Implement equity holding CRUD
- [ ] Implement purchase transaction tracking
- [ ] Implement dividend tracking
- [ ] Implement corporate action recording
- [ ] Implement Section 104 pooling (UK CGT)
- [ ] Implement portfolio performance calculations
- [ ] Integrate with market data provider (Yahoo Finance, IEX Cloud)
- [ ] Write unit tests

**Deliverables:**
- Property portfolio management working
- LTV and rental yield calculations accurate
- Equity holdings and performance tracking operational

---

### Week 12: Investments & Credit Tracking

**Section 9A: Savings & Investments API**
- [ ] Implement investment CRUD operations
- [ ] Implement ISA allowance tracking
- [ ] Implement portfolio performance calculations (1M, 3M, 6M, 1Y, 3Y, 5Y, SI)
- [ ] Implement asset allocation analysis
- [ ] Implement rebalancing recommendations
- [ ] Implement tax wrapper efficiency analysis
- [ ] Write unit tests

**Section 9.6: Credit History API**
- [ ] Implement credit score tracking
- [ ] Integrate with credit agencies (Experian, Equifax, TransUnion)
- [ ] Implement credit health scoring (0-100)
- [ ] Implement credit utilization calculations
- [ ] Implement payment history tracking
- [ ] Implement lending suitability assessment
- [ ] Write unit tests

**Deliverables:**
- Investment performance tracking operational
- ISA management working
- Credit tracking and health scoring functional

---

### Phase 3 Acceptance Criteria

✅ **Technical:**
- All Phase 3 endpoints operational
- 80%+ unit test coverage
- Market data integration working
- Performance optimized (complex calculations < 1s)

✅ **Functional:**
- Can track income and expenditure
- Can manage arrangements (all product types)
- Can track property portfolio with LTV/yield
- Can track equity holdings with performance
- Can track ISAs and tax wrappers
- Can monitor credit scores

✅ **Business:**
- Accurate financial calculations (LTV, yield, CGT, Section 104)
- Portfolio performance metrics correct
- Asset allocation analysis working

---

## Phase 4: Goals & Estate Planning (Weeks 13-16)

### Objective
Complete risk profiling, goals management, and estate planning capabilities.

### Week 13: Risk Assessment Completion

**Section 10.5: Risk Assessment History API**
- [ ] Implement risk profile history tracking
- [ ] Implement Risk Replay comparison
- [ ] Implement risk profile evolution analysis
- [ ] Implement snapshot creation
- [ ] Write unit tests

**Section 10.6: Supplementary Questions API**
- [ ] Implement supplementary questions (45 questions across 4 categories)
- [ ] Implement conditional question logic
- [ ] Implement response tracking
- [ ] Implement completion status monitoring
- [ ] Write unit tests

**Section 10.7: Declaration Capture**
- [ ] Implement client declaration endpoints
- [ ] Implement adviser declaration endpoints
- [ ] Implement electronic signature capture (with IP tracking)
- [ ] Implement signature audit trail
- [ ] Implement consent recording
- [ ] Write unit tests

**Deliverables:**
- Complete ATR assessment workflow operational
- Risk Replay functional (FCA compliance)
- Declaration and signature capture working

---

### Week 14: Goals Management

**Section 8: Goals API**
- [ ] Implement goal CRUD operations
- [ ] Implement goal types (Retirement, Investment, Protection, Mortgage, Budget, Estate)
- [ ] Implement goal prioritization
- [ ] Implement goal funding allocation
- [ ] Implement goal completion tracking
- [ ] Implement objectives sub-resources
- [ ] Write unit tests

**Business Logic:**
- [ ] Link goals to arrangements (funding sources)
- [ ] Calculate goal progress (funded vs. target)
- [ ] Calculate shortfall analysis
- [ ] Generate goal recommendations

**Deliverables:**
- Goals management operational
- Goal prioritization and tracking working
- Funding allocation accurate

---

### Week 15: Estate Planning

**Section 11: Estate Planning API**
- [ ] Implement gift recording
- [ ] Implement gift trust management
- [ ] Implement PET (Potentially Exempt Transfer) tracking
- [ ] Implement 7-year IHT tracking
- [ ] Calculate IHT liability
- [ ] Track Will status and LPA
- [ ] Write unit tests

**Business Logic:**
- [ ] Calculate years remaining on PETs
- [ ] Calculate taper relief
- [ ] Calculate IHT thresholds (£325,000 nil-rate band, £175,000 RNRB)
- [ ] Track gifting patterns

**Deliverables:**
- Gift and trust tracking operational
- IHT calculations accurate
- Estate planning reports working

---

### Week 16: Reference Data & Integration

**Section 12: Reference Data API**
- [ ] Implement enumeration endpoints (genders, marital statuses, titles, etc.)
- [ ] Implement lookup endpoints (countries, currencies, frequencies)
- [ ] Implement provider directory
- [ ] Implement adviser directory
- [ ] Implement product type taxonomy
- [ ] Seed all reference data
- [ ] Write unit tests

**API Integration:**
- [ ] Implement API documentation (Swagger/OpenAPI)
- [ ] Create Postman collection
- [ ] Create API client SDKs (JavaScript, C#, Python)
- [ ] Create integration examples

**Deliverables:**
- Reference data fully seeded
- API documentation published
- Client SDKs available

---

### Phase 4 Acceptance Criteria

✅ **Technical:**
- All Phase 4 endpoints operational
- 80%+ unit test coverage
- API documentation complete
- Client SDKs published

✅ **Functional:**
- Can complete full ATR assessment with Risk Replay
- Can capture declarations and signatures
- Can manage goals with prioritization
- Can track gifts and calculate IHT
- Can access all reference data

✅ **Integration:**
- Swagger documentation accessible
- Postman collections working
- SDKs functional in all languages

---

## Phase 5: Testing & Refinement (Weeks 17-20)

### Objective
Comprehensive testing, performance optimization, security hardening, and go-live preparation.

### Week 17: Integration Testing

**End-to-End Testing:**
- [ ] Create complete fact find workflow tests
- [ ] Test client onboarding journey (identity verification → AML → consent → marketing)
- [ ] Test risk assessment journey (questionnaire → supplementary → declaration)
- [ ] Test wealth management journey (income → arrangements → properties → investments)
- [ ] Test goals and planning journey (goals → funding → progress tracking)
- [ ] Test estate planning journey (gifts → IHT calculations)

**Integration Testing:**
- [ ] Test FactFind → Client → Income → Arrangements integration
- [ ] Test Goals → Arrangements funding allocation
- [ ] Test Property → Mortgage linking
- [ ] Test Investment → ISA allowance tracking
- [ ] Test all HATEOAS link navigation

**Deliverables:**
- 100+ integration tests passing
- All user journeys validated
- Cross-entity integrations working

---

### Week 18: Performance & Security

**Performance Testing:**
- [ ] Load testing (1000 concurrent users)
- [ ] Stress testing (identify breaking points)
- [ ] Optimize slow endpoints (< 500ms target for 95th percentile)
- [ ] Implement caching for reference data
- [ ] Optimize database queries (add indexes)
- [ ] Implement query result caching (Redis)

**Security Testing:**
- [ ] Penetration testing (OWASP Top 10)
- [ ] Authentication/authorization testing
- [ ] Input validation testing (SQL injection, XSS)
- [ ] PII data encryption verification
- [ ] API rate limiting testing
- [ ] HTTPS/TLS configuration verification

**Deliverables:**
- Performance benchmarks met (< 500ms p95)
- Zero critical security vulnerabilities
- Security testing report

---

### Week 19: Compliance Testing & Documentation

**Compliance Testing:**
- [ ] FCA compliance review (ATR process)
- [ ] GDPR compliance audit (Articles 6-21)
- [ ] MLR 2017 compliance verification (KYC/AML)
- [ ] PECR compliance verification (marketing consent)
- [ ] Data retention policy verification
- [ ] Audit trail completeness verification

**Documentation:**
- [ ] Complete API reference documentation
- [ ] Create implementation guides
- [ ] Create best practices guide
- [ ] Create troubleshooting guide
- [ ] Create runbooks for operations
- [ ] Create disaster recovery procedures

**Training:**
- [ ] Train development teams on API usage
- [ ] Train QA teams on testing procedures
- [ ] Train support teams on troubleshooting

**Deliverables:**
- Compliance sign-off from legal/compliance teams
- Complete documentation published
- Teams trained

---

### Week 20: UAT & Go-Live Preparation

**User Acceptance Testing:**
- [ ] Business stakeholder UAT (fact find creation)
- [ ] Adviser UAT (client onboarding, risk assessment)
- [ ] Compliance UAT (audit trail, reporting)
- [ ] Product team UAT (arrangements, goals, estate planning)
- [ ] Fix critical UAT issues
- [ ] Retest fixed issues

**Go-Live Preparation:**
- [ ] Production environment setup
- [ ] Database migration scripts tested
- [ ] Reference data seeded in production
- [ ] Monitoring alerts configured
- [ ] On-call rotation established
- [ ] Rollback procedures documented

**Go-Live:**
- [ ] Deploy to production (off-peak hours)
- [ ] Smoke testing in production
- [ ] Monitor for 24 hours
- [ ] Resolve any immediate issues
- [ ] Communication to stakeholders

**Deliverables:**
- UAT sign-off
- Production deployment successful
- API live and operational
- Monitoring active

---

### Phase 5 Acceptance Criteria

✅ **Technical:**
- 80%+ overall test coverage
- < 500ms p95 response time
- Zero critical/high security vulnerabilities
- 99.9% uptime SLA met

✅ **Functional:**
- All user journeys validated by business
- UAT sign-off received
- No critical defects

✅ **Compliance:**
- FCA compliance verified
- GDPR compliance verified
- MLR 2017 compliance verified
- PECR compliance verified

✅ **Operational:**
- Production deployed
- Monitoring operational
- Support processes established
- Documentation complete

---

## Team Structure

### Recommended Team Composition

**Backend Developers (6):**
- 2 developers on Phases 1-2 (Core + Compliance)
- 2 developers on Phase 3 (Wealth Management)
- 1 developer on Phase 4 (Goals + Estate)
- 1 developer on cross-cutting concerns (auth, logging, monitoring)

**Frontend Developers (2):**
- Work in parallel on API consumption
- Build admin portal and client portal

**QA Engineers (2):**
- 1 focused on automated testing (unit, integration)
- 1 focused on manual testing (UAT, exploratory)

**DevOps Engineer (1):**
- Infrastructure setup
- CI/CD pipelines
- Monitoring and alerting

**Product Owner (1):**
- Requirements clarification
- UAT coordination
- Stakeholder communication

**Tech Lead (1):**
- Architecture decisions
- Code reviews
- Technical blockers

---

## Risk Management

### High-Risk Areas

| Risk | Impact | Mitigation |
|------|--------|------------|
| **Provider Integration Delays** (Onfido, WorldCheck) | High | Start provider onboarding in Week 1, use sandbox environments early |
| **Complex Tax Calculations** (CGT, Section 104) | High | Involve tax specialist early, extensive test cases, third-party validation |
| **Performance Issues** (complex aggregations) | Medium | Identify slow queries early, implement caching, optimize database indexes |
| **GDPR Compliance Gaps** | High | Legal review in Phase 2, external GDPR audit before go-live |
| **Security Vulnerabilities** | High | Security testing throughout, penetration testing in Phase 5 |
| **Scope Creep** | Medium | Strict change control, defer non-critical features to post-launch |

---

## Success Metrics

### Technical Metrics
- ✅ API uptime: 99.9%
- ✅ Response time (p95): < 500ms
- ✅ Test coverage: > 80%
- ✅ Security vulnerabilities: Zero critical/high

### Business Metrics
- ✅ API adoption: 100% of fact finds created via API within 3 months
- ✅ Data quality: < 5% error rate in fact find data
- ✅ Compliance: Zero compliance breaches

### Operational Metrics
- ✅ Mean time to resolution (MTTR): < 4 hours for critical issues
- ✅ Deployment frequency: Weekly releases
- ✅ Change failure rate: < 10%

---

## Post-Launch (Weeks 21+)

### Month 1: Stabilization
- Monitor production for stability
- Fix high-priority bugs
- Performance tuning based on real usage
- Gather user feedback

### Month 2-3: Enhancements
- Implement deferred features
- Add advanced reporting
- Improve search and filtering
- Optimize based on usage patterns

### Month 4-6: Scale
- Horizontal scaling based on load
- Additional geographic regions
- Additional provider integrations
- Mobile app development

---

## Conclusion

This **20-week roadmap** provides a structured path to delivering the complete FactFind API v2.0 with 95% domain coverage. The phased approach ensures:

1. **Early Value Delivery** - Core capabilities in Phase 1
2. **Compliance First** - Critical risk and data protection in Phase 2
3. **Business Capabilities** - Wealth management in Phase 3
4. **Complete Solution** - Goals and estate planning in Phase 4
5. **Production Ready** - Testing and hardening in Phase 5

**Total Duration:** 5 months
**Expected Team Size:** 8-12 people
**Expected Outcome:** Production-ready, FCA-compliant, GDPR-ready FactFind API

---

**Document Version:** 1.0
**Status:** Ready for Planning

**End of Roadmap**
