# Client vs FactFind Domain Boundary Analysis

**Date:** 2026-02-12
**Purpose:** Define clear boundaries between Client domain (CRM) and FactFind domain for V3 API design
**Source:** Comprehensive analysis of code, database schemas, and Target-Entities diagram

---

## Executive Decision: Domain Boundary Separation

### The Core Principle

**Client Domain (CRM)** owns **WHO the client is**
**FactFind Domain** owns **WHAT the client's financial situation is**

This separation enables:
- Independent bounded contexts
- Clear ownership and responsibility
- Microservices migration readiness
- Team autonomy
- Scalable architecture

---

## Client Domain (CRM-Owned)

### Core Responsibility
**Client Identity Management** - Managing the identity, demographics, and master data of clients as parties (Person/Corporate/Trust)

### What Belongs in Client Domain

#### 1. Party Identity
- **Person clients:** Name, title, DOB, gender
- **Corporate clients:** Corporate name, company registration, VAT details
- **Trust clients:** Trust name, trust type, establishment details
- **Party type discriminator** (Person/Corporate/Trust)
- **Client status** (Prospect, Client, Archived, Deleted)

#### 2. Demographics & Personal Details
- National Insurance Number (NI Number)
- Nationality and citizenship
- Residency and domicile
- Marital status (as demographic fact)
- Tax code
- National Client Identifier
- Salutation and title preferences

#### 3. Health & Lifestyle (Underwriting Data)
- Smoking status
- Health status (good health indicator)
- Height, weight (if captured)
- **Rationale:** Required for protection product underwriting, intrinsic to person

#### 4. Contact Information
- Addresses (residential, correspondence, etc.)
- Phone numbers
- Email addresses
- Preferred contact methods
- **Rationale:** How to reach the client, independent of financial advice

#### 5. Relationships & Family Structure
- Personal contacts (family relationships)
- Emergency contacts
- Next of kin
- Family group membership
- Head of family designation
- **Rationale:** WHO is related to whom, not financial dependency

#### 6. Client Service & History
- Adviser assignment (current and original)
- Service status (Active, Review, Dormant, etc.)
- Service status start date
- Client segment (categorization)
- Campaign source
- Migration reference
- External reference (from other systems)

#### 7. Legal & Compliance
- Power of Attorney granted
- Attorney name
- Deceased status and date
- Data Protection preferences
- Client vulnerability flags
- Legal entity identifiers (for Corporate/Trust)

### What Does NOT Belong in Client Domain

- Financial data (income, expenditure, assets, liabilities)
- Goals and objectives
- Risk profiling results
- Employment details
- Budget information
- Product holdings
- Advice-specific data

### Database Tables (CRM Schema)

**Core Tables:**
- TCRMContact - Party aggregate root
- TPerson - Person-specific details
- TCorporate - Corporate-specific details
- TTrust - Trust-specific details
- TAddress - Addresses
- TContactDetail - Phone numbers
- TEmail - Email addresses
- TPersonalContact, TPersonalContactLink - Relationships
- TClientVulnerability - Vulnerability assessments
- TClientNote - General client notes
- TClientProofOfIdentity - ID verification
- TDeceased - Deceased details
- TVerification - ID verification details

---

## FactFind Domain (FactFind-Owned)

### Core Responsibility
**Financial Profile Management** - Collecting, storing, and analyzing client financial information for the purpose of providing financial advice

### What Belongs in FactFind Domain

#### 1. Employment & Income
- Current employment status and details
- Employment history
- Income sources (salary, bonuses, rental, investment, etc.)
- Income frequency and amounts
- Gross and net income breakdowns
- Affordability calculations
- **Rationale:** Financial information collected during fact-finding, changes frequently

#### 2. Expenditure & Budget
- Monthly expenditure by category
- Detailed expense breakdown
- Budget planning
- Expected changes to spending
- Liability-imported expenditure
- **Rationale:** Spending patterns for affordability and financial planning

#### 3. Assets & Liabilities
- Asset ownership and valuations
- Property details (for assets)
- Asset categories (Property, Savings, Investment, etc.)
- Debts and loans
- Mortgage details
- Credit commitments
- Repayment plans
- **Rationale:** Financial position snapshot for advice purposes

#### 4. Goals & Objectives
- Financial targets and aspirations
- Goal amounts and timelines
- Product area (Protection, Retirement, Investment)
- Goal type (Growth, Income)
- Retirement planning details
- Goal completion tracking
- **Rationale:** What client wants to achieve financially

#### 5. Financial Dependants
- Dependant name and relationship
- Financial dependency status (Is financially dependent?)
- Financial dependency duration
- Financial dependency end date
- Living arrangements (for expense calculations)
- **Rationale:** WHO is financially dependent (not family relationships, which are in CRM)

**KEY DISTINCTION:**
- CRM PersonalContact = Family relationships (brother, sister, mother)
- FactFind Dependant = Financial dependency (financially dependent child until age 18)

#### 6. Risk Profiling (Consumed from ATR)
- Attitude to Risk assessment results
- Risk profile recommendations
- Risk profile adjustments by adviser
- Risk discrepancies
- **Rationale:** Risk tolerance for investment advice

#### 7. Advice Context
- Advice areas selected (Protection, Retirement, Investment, Estate, Mortgage)
- Interview type and details
- Compliance declarations specific to advice
- Document disclosures (Terms of Business, Key Facts)
- Needs and priorities analysis
- **Rationale:** Scope and context of advice engagement

#### 8. Advisor Notes & Analysis
- Employment notes
- Budget notes
- Asset/Liability notes
- Protection notes
- Retirement notes
- Investment notes
- Mortgage notes
- Estate planning notes
- Summary notes
- **Rationale:** Advisor commentary and analysis during fact-finding

#### 9. Personal Preferences (Marketing)
- No marketing by post
- No marketing by email
- No marketing by phone
- **Rationale:** Captured during fact-finding process, advice-specific

### What Does NOT Belong in FactFind Domain

- Client name, DOB, demographics (owned by CRM)
- Client identity and party type
- Contact details (addresses, phones, emails)
- Family relationships (use CRM PersonalContact)
- Power of Attorney (legal matter, in CRM)
- Product holdings (owned by PolicyManagement)

### Database Tables (FactFind Schema)

**Core Tables:**
- TFactFind - Fact-find session root
- TEmploymentDetail - Employment & EmploymentStatus
- TDetailedIncomeBreakdown - Income
- TExpenditure, TExpenditureDetail - Expenditure
- TBudget - Budget planning
- TAssets - Assets
- TLiabilities - Liabilities
- TObjective - Goals
- TDependants - Financial dependants
- TAdviceareas - Advice scope
- TDeclaration - Compliance declarations
- TDocumentDisclosure - Disclosures
- TPersonalinformation - Marketing preferences
- TProfessionalContact - Professional advisers
- TCorporateContact - Corporate extensions
- All notes tables (TProfileNotes, TProtectionMiscellaneous, etc.)

---

## Integration Patterns Between Domains

### Pattern 1: CRM → FactFind (Conformist)

**Relationship:** FactFind is downstream consumer of CRM client data

**How it Works:**
- FactFind entities reference CRMContactId
- FactFind does not own or modify client master data
- FactFind queries CRM for client details when needed
- No foreign key constraints (loose coupling)

**27+ FactFind entities reference CRMContactId:**
- TFactFind (CRMContactId1, CRMContactId2)
- TEmploymentDetail, TDetailedIncomeBreakdown
- TExpenditure, TObjective, TLiabilities
- TDependants, TAssets, TAdviceareas
- TDeclaration, TPersonalinformation, etc.

**Anti-Corruption Layer Recommendation:**
```
FactFind creates local FactFindClient value object:
- CRMContactId (reference to CRM)
- Name snapshot (for display)
- DOB snapshot (for age calculations)
- Client status (for validation)

Synchronize via events:
- ClientCreated → Create FactFindClient
- ClientNameChanged → Update FactFindClient name
- ClientArchived → Mark FactFindClient inactive
- ClientDeleted → Archive related fact-finds
```

### Pattern 2: FactFind ← CRM (Read-Only View)

**When FactFind needs client data:**
1. Use local FactFindClient for display (name, basic info)
2. Query CRM API for full details when needed
3. Never update CRM client data from FactFind

**Example API Call:**
```
GET /v3/clients/{clientId}
Returns: Full client demographics, addresses, contacts
Used by: FactFind UI to display client header
```

### Pattern 3: Dependants vs Relationships

**CRM PersonalContact (Family Relationships):**
- Relationship type: Father, Mother, Brother, Sister, Son, Daughter
- Purpose: Family tree, emergency contacts, next of kin
- Use case: "Who is John's mother?"

**FactFind Dependant (Financial Dependency):**
- Relationship type: Child, Parent, Other
- IsFinanciallyDependant: Yes/No
- DependantDuration: Age range
- FinancialDependencyEndsOn: Date
- Purpose: Protection needs analysis, financial planning
- Use case: "Is John's daughter financially dependent until age 21?"

**Recommendation:** Keep both entities, different concerns. Link via CRMContactId if needed.

---

## API Design Implications

### Separate APIs per Bounded Context (Recommended)

#### Client API (CRM)
```
GET    /v3/clients/{clientId}
PUT    /v3/clients/{clientId}
DELETE /v3/clients/{clientId}

GET    /v3/clients/{clientId}/addresses
POST   /v3/clients/{clientId}/addresses
PUT    /v3/clients/{clientId}/addresses/{addressId}

GET    /v3/clients/{clientId}/relationships
POST   /v3/clients/{clientId}/relationships
```

**Responsibility:** Client identity, demographics, contacts, relationships

#### FactFind API
```
GET    /v3/factfind/{clientId}/session
POST   /v3/factfind/{clientId}/session

GET    /v3/factfind/{clientId}/employment
POST   /v3/factfind/{clientId}/employment
PUT    /v3/factfind/{clientId}/employment/{id}

GET    /v3/factfind/{clientId}/income
POST   /v3/factfind/{clientId}/income

GET    /v3/factfind/{clientId}/goals
POST   /v3/factfind/{clientId}/goals
PUT    /v3/factfind/{clientId}/goals/{id}

GET    /v3/factfind/{clientId}/dependants
POST   /v3/factfind/{clientId}/dependants
```

**Responsibility:** Financial profile, goals, liabilities, assets, dependants

### Client Data in FactFind Responses

**DO:** Return minimal client snapshot
```json
{
  "goalId": 123,
  "client": {
    "clientId": 456,
    "name": "John Smith",
    "isJoint": false
  },
  "goalName": "Retirement Fund",
  "targetAmount": 500000
}
```

**DON'T:** Return full client demographics
```json
{
  "goalId": 123,
  "client": {
    "clientId": 456,
    "firstName": "John",
    "lastName": "Smith",
    "dob": "1980-05-15",
    "gender": "Male",
    "niNumber": "AB123456C",
    "maritalStatus": "Married",
    "addresses": [...]  // ❌ WRONG - This is CRM data
  },
  "goalName": "Retirement Fund"
}
```

**Rationale:** Client demographics owned by CRM, not FactFind. Use HATEOAS links or client aggregation service.

### HATEOAS Example

```json
{
  "goalId": 123,
  "clientId": 456,
  "goalName": "Retirement Fund",
  "targetAmount": 500000,
  "_links": {
    "client": {
      "href": "/v3/clients/456",
      "title": "John Smith"
    }
  }
}
```

Client app fetches full client details separately if needed.

---

## Decision Matrix: Which Domain Owns What?

| Data Type | Client Domain (CRM) | FactFind Domain | Rationale |
|-----------|---------------------|----------------|-----------|
| Name | ✓ | | Intrinsic identity |
| DOB | ✓ | | Intrinsic identity |
| Gender | ✓ | | Intrinsic identity |
| Marital Status | ✓ | | Demographic fact |
| NI Number | ✓ | | Legal identity |
| Address | ✓ | | Contact information |
| Phone | ✓ | | Contact information |
| Email | ✓ | | Contact information |
| Smoking Status | ✓ | | Underwriting data, intrinsic to person |
| Health Status | ✓ | | Underwriting data, intrinsic to person |
| Nationality | ✓ | | Citizenship |
| Residency | ✓ | | Legal status |
| Family Relationships | ✓ | | Family structure |
| Emergency Contact | ✓ | | Contact information |
| | | | |
| Employment | | ✓ | Financial information |
| Salary/Income | | ✓ | Financial information |
| Expenditure | | ✓ | Financial information |
| Assets | | ✓ | Financial position |
| Liabilities | | ✓ | Financial position |
| Goals | | ✓ | Financial aspirations |
| Risk Profile | | ✓ | Investment suitability |
| Financial Dependants | | ✓ | Financial dependency (not family) |
| Advice Areas | | ✓ | Advice scope |
| Budget | | ✓ | Financial planning |
| Advisor Notes | | ✓ | Advice process |
| Marketing Preferences | | ✓ | Captured during fact-find |

---

## Common Pitfalls to Avoid

### Pitfall 1: Duplicating Client Data in FactFind
**Problem:** Storing client name, DOB in FactFind tables
**Solution:** Reference CRMContactId only, query CRM for display

### Pitfall 2: Updating Client Demographics from FactFind
**Problem:** Allowing FactFind UI to update client DOB, address
**Solution:** Redirect to Client API for demographic updates

### Pitfall 3: Confusing Dependants with Family Relationships
**Problem:** Treating TDependants as family tree
**Solution:** Use TDependants for financial dependency, TPersonalContact for family relationships

### Pitfall 4: Mixing Employment in Client Domain
**Problem:** Storing employment history in CRM as demographic data
**Solution:** Employment is financial information, belongs in FactFind

### Pitfall 5: Splitting Risk Profile from Goals
**Problem:** Creating separate Risk Profile entity in FactFind
**Solution:** Goals reference ATR's RiskProfile, don't duplicate

---

## Migration Strategy

### Current State (Monolith)
- All data in single database
- FactFind queries CRM tables directly
- No clear API boundaries

### Target State (Bounded Contexts)
- Separate APIs per bounded context
- FactFind never queries CRM database directly
- Anti-corruption layers at boundaries
- Event-driven synchronization

### Migration Steps

**Step 1: Establish API Contracts (Q1 2026)**
- Define Client API (CRM)
- Define FactFind API
- Document integration patterns

**Step 2: Implement Anti-Corruption Layers (Q2 2026)**
- Create FactFindClient entity in FactFind
- Synchronize from CRM via events
- Implement client data caching

**Step 3: Migrate Queries (Q2-Q3 2026)**
- Replace cross-schema queries with API calls
- Update FactFind UI to call Client API for demographics
- Remove direct database dependencies

**Step 4: Schema Separation (Q3-Q4 2026)**
- Move CRM tables to CRM.dbo schema (if not already)
- Move FactFind tables to FactFind.dbo schema
- Remove cross-schema synonyms

**Step 5: Service Extraction (Q4 2026 - Q1 2027)**
- Deploy Client API as separate microservice
- Deploy FactFind API as separate microservice
- Implement API Gateway
- Migrate to separate databases (optional)

---

## Validation Checklist

Before finalizing V3 API design, validate:

- [ ] No client demographics in FactFind API responses (except minimal snapshot)
- [ ] No FactFind data in Client API responses
- [ ] Clear ownership of every entity documented
- [ ] Integration patterns defined for all cross-context references
- [ ] Anti-corruption layers designed
- [ ] Event-driven synchronization patterns documented
- [ ] API contract boundaries respect bounded contexts
- [ ] Dependants vs Relationships distinction clear
- [ ] Employment belongs to FactFind, not CRM
- [ ] Smoking/Health status belongs to CRM, not FactFind

---

## Summary

**Client Domain (CRM)** = WHO
**FactFind Domain** = WHAT (financially)

This separation enables:
- Clear ownership and responsibility
- Independent evolution and deployment
- Team autonomy
- Microservices architecture readiness
- Better domain model integrity

**Key Integration Pattern:** Conformist (FactFind conforms to CRM's client model via CRMContactId)

**Next Steps:** Use this boundary analysis to design V3 API contracts with clear domain separation.

---

## V4 API Evidence Supporting Boundary Decisions

**Added:** 2026-02-12

### Portfolio Domain as Separate Bounded Context (NEW)

**V4 Discovery:** monolith.Portfolio is a separate bounded context with its own comprehensive API family.

**API Evidence:**
- 9 REST controllers (PensionPlanController, ProtectionPlanController, etc.)
- 1,773 plan types via polymorphic discriminator
- Separate database schema (Portfolio.dbo)
- Covers: Pensions, Protection, Investments, Savings, Mortgages, Loans, Credit Cards

**Boundary Relationship:**
- **FactFind Context** (upstream) → captures client needs and goals
- **Portfolio Context** (downstream) → manages existing product holdings
- Integration: Goals link to Plans via PlanId, Income links to Withdrawals, Expenditure links to Contributions

**Recommended Pattern:** Conformist (Portfolio conforms to FactFind's client and goal references)

---

### Requirements Microservice as Goals Domain (ENHANCED)

**V4 Discovery:** Microservice.Requirement is a gold standard DDD microservice, not just Goals API.

**API Evidence:**
- Modern microservice architecture
- Separate database (Requirements.dbo)
- Entity Framework Core (not Hibernate)
- Event-driven: ObjectiveCreated, ObjectiveChanged, ObjectiveDeleted
- Polymorphic objectives: Investment, Retirement, Protection, Mortgage, Budget, EstatePlanning, EquityRelease
- Embedded RiskProfile (owned entity pattern)

**Boundary Relationship:**
- **FactFind Context** → captures raw client information
- **Requirements Context** (separate microservice) → captures structured goals and risk profile
- Integration: Async events, no direct database dependencies

**Recommended Pattern:** Published Language (Requirements publishes events, FactFind subscribes)

---

### Notes Management as Cross-Cutting Concern (UNIFIED)

**V4 Discovery:** Unified Notes API abstracts scattered database tables into single discriminator-based endpoint.

**API Evidence:**
- `/v2/clients/{clientId}/notes?discriminator={type}`
- 10 discriminator types: Profile, Employment, AssetLiabilities, Budget, Mortgage, Protection, Retirement, Investment, EstatePlanning, Summary
- Single API contract abstracts 10 database tables
- Resolves "scattered notes" technical debt

**Boundary Relationship:**
- **Notes** is cross-cutting concern, not a separate bounded context
- Used by multiple contexts (FactFind, Goals, Obligations)
- Discriminator routes to appropriate domain table

**Recommended Pattern:** Shared Kernel (notes abstraction used by multiple contexts)

---

### Updated Bounded Context Map

```
CRM Domain (Identity)
│
│ (Conformist - CRMContactId)
│
├─► FactFind Domain (Financial Profile)
│   │
│   │ (Conformist - ClientId, FactFindId)
│   │
│   ├─► Portfolio Domain (Product Holdings)
│   │   - Plans API (1,773 types)
│   │   - Separate database
│   │
│   │ (Published Language - Events)
│   │
│   └─► Requirements Domain (Goals & Risk)
│       - Microservice architecture
│       - Event-driven
│       - Separate database
│
└─► Notes (Cross-Cutting)
    - Shared kernel pattern
    - Unified discriminator API
```

### Integration Patterns (V4 Confirmed)

**Pattern 1: CRM → FactFind (Conformist)**
- FactFind references CRMContactId
- No foreign key constraints (loose coupling)
- **V4 Recommendation:** Implement Anti-Corruption Layer (see V4-Implementation-Roadmap Phase 2)

**Pattern 2: FactFind → Portfolio (Conformist)**
- Goals link to Plans via PlanId
- Income links to Plan Withdrawals
- Expenditure links to Plan Contributions
- **V4 Evidence:** Working integration pattern

**Pattern 3: FactFind → Requirements (Published Language)**
- Requirements publishes ObjectiveCreated, ObjectiveChanged, ObjectiveDeleted
- FactFind subscribes for display/reporting
- Async, event-driven integration
- **V4 Evidence:** Gold standard microservice pattern

**Pattern 4: Notes (Shared Kernel)**
- Unified API abstracts multiple tables
- Discriminator-based routing
- Used across multiple contexts
- **V4 Evidence:** Excellent abstraction pattern

---

**Document Version:** 2.0 (V4 Updated)
**Date:** 2026-02-12 (Original), 2026-02-12 (V4 Update)
**Author:** Principal Software Architect
**Status:** V4 Corrected - Ready for V3 API Contract Design

**Related V4 Documents:**
- `steering/COVERAGE-CORRECTION-V4-ANALYSIS.md`
- `steering/API-Domain-Analysis.md` (V2.0)
- `steering/Consolidated-FactFind-Domain-Model.md` (V2.0)
- `steering/API-Architecture-Patterns.md`
