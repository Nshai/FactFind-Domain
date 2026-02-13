# FactFind API Architecture Patterns

**Document Version:** 1.0
**Date:** 2026-02-12
**Purpose:** Document proven architectural patterns discovered in V4 analysis for reuse in future API development
**Status:** REFERENCE GUIDE - Best Practices Catalog

---

## Executive Summary

The V4 coverage correction analysis revealed excellent architectural patterns already implemented in the FactFind ecosystem. This document catalogs these proven patterns as **gold standards** for future API development. Rather than reinventing patterns, V3 and future APIs should extend and standardize these approaches.

### Key Patterns Discovered

| Pattern | Example Implementation | Coverage Impact | Status |
|---------|----------------------|-----------------|--------|
| **Polymorphic Discriminator** | Portfolio Plans API (1,773 types) | +12 sections | GOLD STANDARD |
| **Unified Discriminator Routing** | Notes API (10 types) | +9 sections | GOLD STANDARD |
| **Event-Driven Microservices** | Requirements microservice | +2 sections | GOLD STANDARD |
| **Cross-Schema Integration** | CRM ↔ FactFind ↔ Portfolio | All sections | NEEDS IMPROVEMENT |
| **Shared Entity Pattern** | Address Store | Multiple sections | GOLD STANDARD |

---

## Pattern 1: Polymorphic Discriminator Pattern

**Used By:** Portfolio Plans API
**Impact:** Single API family covers 1,773 plan types across 12+ factfind sections
**Maturity:** Production-proven, 5+ years
**Status:** **GOLD STANDARD - Extend this pattern**

### Problem

Financial advisers work with hundreds of product types across multiple categories (pensions, protection, investments, savings, mortgages, loans). Creating separate APIs for each product type would result in:
- 100+ redundant APIs
- Inconsistent patterns
- Maintenance nightmare
- Poor discoverability

### Solution

**Polymorphic hierarchy with discriminator-based routing:**
- Single base entity (TPolicyBusiness) stores common fields
- Discriminator field (RefPlanDiscriminatorId) determines product type
- Extension tables store type-specific fields (TMortgage, TEquityRelease)
- Type-specific controllers route to same underlying persistence with type filtering

### Architecture

```
Database Layer:
TPolicyBusiness (Base Table)
├── PlanId (PK)
├── ClientId
├── RefPlanDiscriminatorId ← Discriminator
├── ProviderName
├── PlanValue
├── StartDate
└── Common fields...

Extension Tables (Type-Specific):
├── TMortgage (PlanId FK)
│   ├── PropertyId
│   ├── LoanToValue
│   └── Mortgage-specific fields...
├── TEquityRelease (PlanId FK)
│   ├── ReleaseAmount
│   └── EquityRelease-specific fields...
└── [Other extensions...]

TRefPlanType2ProdSubType (Discriminator Mapping)
├── RefPlanDiscriminatorId (PK)
├── PlanType (e.g., "Pension", "Protection")
├── ProdSubType (e.g., "PersonalPension", "LifeInsurance")
└── 1,773 distinct mappings
```

### API Layer

**9 Specialized Controllers:**
```
/v1/clients/{clientId}/plans/pensions         ← PensionPlanController
/v1/clients/{clientId}/plans/protections      ← ProtectionPlanController
/v1/clients/{clientId}/plans/investments      ← InvestmentPlanController
/v1/clients/{clientId}/plans/savingsaccounts  ← SavingsAccountPlanController
/v1/clients/{clientId}/plans/mortgages        ← MortgagePlanController
/v1/clients/{clientId}/plans/loans            ← LoanPlanController
/v1/clients/{clientId}/plans/creditcards      ← CreditCardPlanController
/v1/clients/{clientId}/plans/currentaccounts  ← CurrentAccountPlanController
/v1/clients/{clientId}/plans/equityrelease    ← EquityReleasePlanController
```

**Each Controller:**
- Filters TPolicyBusiness by discriminator range
- Joins extension table if needed
- Returns type-specific document
- Shares common CRUD logic

### Domain Entity Pattern

**Base Document (Common Fields):**
```csharp
public class PlanDocumentBase {
    public int PlanId { get; set; }
    public int ClientId { get; set; }
    public string PlanType { get; set; }  // Discriminator
    public string ProviderName { get; set; }
    public decimal PlanValue { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime? MaturityDate { get; set; }
    // ... common fields
}
```

**Type-Specific Documents (Inheritance):**
```csharp
public class PensionPlanDocument : PlanDocumentBase {
    public int RetirementAge { get; set; }
    public DateTime? CrystallisationDate { get; set; }
    public decimal ContributionAmount { get; set; }
    // ... pension-specific fields
}

public class MortgagePlanDocument : PlanDocumentBase {
    public int PropertyId { get; set; }
    public decimal LoanToValue { get; set; }
    public decimal InterestRate { get; set; }
    public string RateType { get; set; }
    // ... mortgage-specific fields
}
```

### Benefits

1. **Single API Family:** One consistent pattern for all plan types
2. **Extensibility:** New plan types added without new APIs
3. **Type Safety:** Compile-time checking for type-specific fields
4. **Discoverability:** Clear endpoint structure
5. **Maintainability:** Shared logic, single codebase
6. **Performance:** Discriminator index for efficient filtering

### Trade-offs

**Pros:**
- Scales to hundreds of types
- Consistent developer experience
- Easy to add new types
- Shared validation and business logic

**Cons:**
- Requires discriminator mapping table
- Extension tables can proliferate
- Type-specific validation more complex
- API documentation can be verbose

### When to Use This Pattern

Use Polymorphic Discriminator Pattern when:
- You have 10+ related entity types with common fields
- Types share 50%+ of fields
- New types added frequently
- Consistent CRUD operations across types
- Strong type safety needed

**Examples in FactFind:**
- Plans/Products (already implemented)
- Risk Objectives (already implemented in Requirements microservice)
- Document Types (candidate)
- Asset Types (candidate)

### Implementation Checklist

- [ ] Design base entity with common fields
- [ ] Create discriminator mapping table
- [ ] Design extension tables for type-specific fields
- [ ] Implement discriminator-filtered repositories
- [ ] Create type-specific controllers
- [ ] Define type-specific documents/contracts
- [ ] Implement shared validation logic
- [ ] Add discriminator index for performance
- [ ] Document discriminator values
- [ ] Create integration tests for each type

### V3 Recommendation

**EXTEND, DON'T REPLACE** - Portfolio Plans API uses this pattern excellently. V3 should:
1. Document the pattern thoroughly
2. Ensure all plan types covered (gap analysis)
3. Standardize response formats across controllers
4. Add missing fields if needed
5. Create unified query API across all plan types

---

## Pattern 2: Unified Discriminator Routing Pattern

**Used By:** Monolith.FactFind Notes API
**Impact:** Single API endpoint abstracts 10 scattered database tables
**Maturity:** Production-proven
**Status:** **GOLD STANDARD - Extend this pattern to other cross-cutting concerns**

### Problem

Notes/comments exist throughout the factfind journey (employment notes, budget notes, protection notes, etc.). Original design created separate note tables in each domain, resulting in:
- 10+ scattered note tables
- Inconsistent schemas (different column names, lengths, nullable)
- No unified query capability
- Maintenance burden
- Poor UX (separate API calls for each note type)

### Solution

**Single API endpoint with discriminator query parameter routes to multiple backing tables:**
- One REST endpoint: `/v2/clients/{clientId}/notes?discriminator={type}`
- Discriminator determines which table to access
- Consistent API contract regardless of backing storage
- Abstracts technical debt without requiring database refactoring

### Architecture

```
API Layer:
GET /v2/clients/{clientId}/notes?discriminator=Employment
PUT /v2/clients/{clientId}/notes

Discriminator Enum:
public enum NoteDiscriminator {
    Profile,          → TProfileNotes.Notes
    Employment,       → TEmploymentNote.Note
    AssetLiabilities, → TBudgetMiscellaneous.AssetLiabilityNotes
    Budget,           → TBudgetMiscellaneous.BudgetNotes
    Mortgage,         → TMortgageMiscellaneous.Notes
    Protection,       → TProtectionMiscellaneous.Notes
    Retirement,       → TRetirementNextSteps.NextSteps
    Investment,       → TSavingsNextSteps.NextSteps
    EstatePlanning,   → TEstateNextSteps.NextSteps
    Summary           → TDeclarationNotes.DeclarationNotes
}

Backend Router (Strategy Pattern):
public interface INoteRepository {
    string GetNotes(int clientId, NoteDiscriminator type);
    void UpdateNotes(int clientId, NoteDiscriminator type, string notes);
}

public class NotesRouter : INoteRepository {
    public string GetNotes(int clientId, NoteDiscriminator type) {
        return type switch {
            NoteDiscriminator.Employment => _context.TEmploymentNote
                .FirstOrDefault(x => x.ClientId == clientId)?.Note,
            NoteDiscriminator.Budget => _context.TBudgetMiscellaneous
                .FirstOrDefault(x => x.ClientId == clientId)?.BudgetNotes,
            // ... other cases
        };
    }
}
```

### API Contract

**Unified Contract:**
```json
GET /v2/clients/123/notes?discriminator=Employment
Response:
{
  "clientId": 123,
  "noteType": "Employment",
  "notes": "Client is employed as software engineer...",
  "lastUpdated": "2026-02-12T10:30:00Z",
  "_links": {
    "self": { "href": "/v2/clients/123/notes?discriminator=Employment" }
  }
}
```

**Update:**
```json
PUT /v2/clients/123/notes
Request:
{
  "noteType": "Employment",
  "notes": "Updated employment notes..."
}
```

### Benefits

1. **Single API Contract:** One endpoint for all note types
2. **Abstracts Technical Debt:** Hides scattered tables from consumers
3. **Easy to Extend:** New note types added without breaking changes
4. **Consistent UX:** Predictable pattern for all notes
5. **Gradual Refactoring:** Can refactor backend without API changes

### Trade-offs

**Pros:**
- Clean API despite messy backend
- No breaking changes required
- Easy to test
- Clear separation of concerns

**Cons:**
- Backend complexity (routing logic)
- Performance varies by discriminator
- Can't easily query all notes at once
- Discriminator values must be documented

### When to Use This Pattern

Use Unified Discriminator Routing when:
- Multiple similar entities scattered across database
- Entities have similar structure but different tables
- Want to provide unified API without backend refactoring
- Entities accessed by type, rarely all together
- Performance acceptable (no complex joins needed)

**Examples in FactFind:**
- Notes (already implemented)
- Custom Fields (candidate)
- Attachments/Documents (candidate)
- Audit Logs (candidate)

### Implementation Checklist

- [ ] Define discriminator enum
- [ ] Create unified API contract
- [ ] Implement strategy pattern router
- [ ] Map each discriminator to table/column
- [ ] Add discriminator validation
- [ ] Create integration tests for each discriminator
- [ ] Document discriminator values
- [ ] Consider performance implications
- [ ] Plan backend consolidation (optional future)

### V3 Recommendation

**EXTEND THIS PATTERN** - Notes API demonstrates excellent abstraction. V3 should:
1. Ensure all note types covered
2. Add bulk query capability (all notes for client)
3. Add filtering/search across note types
4. Consider future backend consolidation
5. Apply pattern to other cross-cutting concerns

---

## Pattern 3: Event-Driven Microservices Pattern

**Used By:** Microservice.Requirement
**Impact:** Modern DDD microservice with full CRUD + event publishing
**Maturity:** Production-proven
**Status:** **GOLD STANDARD - Use as template for new microservices**

### Problem

Monolithic systems create tight coupling, slow deployment cycles, and scaling challenges. Requirements/Goals domain needed:
- Independent evolution from FactFind monolith
- Event-driven integration with other systems
- Modern technology stack (Entity Framework Core)
- Separate database (no shared tables)

### Solution

**Standalone microservice with:**
- Separate database (Requirements DB)
- Domain-Driven Design patterns
- Event publishing for state changes
- RESTful API with rich querying
- No direct database dependencies from other services

### Architecture

```
Requirements Microservice:
┌─────────────────────────────────────┐
│  API Layer                          │
│  /v2/clients/{id}/objectives        │
│  - GET (list with filtering)        │
│  - POST (create)                    │
│  - PUT (update)                     │
│  - DELETE (delete)                  │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│  Domain Layer                       │
│  - Objective (Aggregate Root)       │
│  - RiskProfile (Owned Entity)       │
│  - Domain Events                    │
│  - Business Logic                   │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│  Persistence Layer (EF Core)        │
│  - DbContext                        │
│  - Repositories                     │
│  - Migrations                       │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│  Requirements Database              │
│  - Objectives table                 │
│  - No shared tables                 │
└─────────────────────────────────────┘
            ↓
┌─────────────────────────────────────┐
│  Event Bus                          │
│  - ObjectiveCreated                 │
│  - ObjectiveChanged                 │
│  - ObjectiveDeleted                 │
└─────────────────────────────────────┘

Other services subscribe to events:
- FactFind monolith (for display)
- Plans service (for goal-plan linking)
- Reporting service (for analytics)
```

### Domain Model

**Aggregate Root:**
```csharp
public class Objective {
    public Guid Id { get; private set; }
    public int ClientId { get; private set; }
    public ObjectiveType Type { get; private set; }  // Discriminator
    public string Name { get; private set; }
    public decimal? TargetAmount { get; private set; }
    public DateTime? TargetDate { get; private set; }
    public RiskProfile RiskProfile { get; private set; }  // Owned entity

    // Domain events
    public IReadOnlyCollection<IDomainEvent> DomainEvents => _domainEvents.AsReadOnly();
    private List<IDomainEvent> _domainEvents = new();

    // Factory method
    public static Objective Create(int clientId, ObjectiveType type, string name) {
        var objective = new Objective {
            Id = Guid.NewGuid(),
            ClientId = clientId,
            Type = type,
            Name = name
        };

        objective.AddDomainEvent(new ObjectiveCreated(objective.Id, clientId, type));
        return objective;
    }

    // Business logic
    public void UpdateRiskProfile(RiskProfile riskProfile, string reason) {
        RiskProfile = riskProfile;
        AddDomainEvent(new ObjectiveRiskProfileChanged(Id, riskProfile, reason));
    }
}
```

**Owned Entity:**
```csharp
public class RiskProfile {  // Owned by Objective
    public Guid? RiskProfileId { get; private set; }
    public int RiskScore { get; private set; }
    public string RiskCategory { get; private set; }
    public DateTime? AssessmentDate { get; private set; }
    public bool AdjustedByAdviser { get; private set; }
    public string AdjustmentReason { get; private set; }
}
```

**Domain Events:**
```csharp
public class ObjectiveCreated : IDomainEvent {
    public Guid ObjectiveId { get; set; }
    public int ClientId { get; set; }
    public ObjectiveType ObjectiveType { get; set; }
    public DateTime OccurredAt { get; set; } = DateTime.UtcNow;
}

public class ObjectiveChanged : IDomainEvent {
    public Guid ObjectiveId { get; set; }
    public Dictionary<string, object> Changes { get; set; }
    public DateTime OccurredAt { get; set; } = DateTime.UtcNow;
}
```

### Event Publishing

**On Save Changes:**
```csharp
public class RequirementsDbContext : DbContext {
    private readonly IEventBus _eventBus;

    public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken) {
        // Collect domain events
        var domainEvents = ChangeTracker.Entries<Objective>()
            .SelectMany(x => x.Entity.DomainEvents)
            .ToList();

        // Save to database
        var result = await base.SaveChangesAsync(cancellationToken);

        // Publish events (after transaction commits)
        foreach (var domainEvent in domainEvents) {
            await _eventBus.PublishAsync(domainEvent);
        }

        return result;
    }
}
```

### Benefits

1. **Independent Deployment:** Deploy Requirements service without affecting FactFind
2. **Technology Choice:** Use modern stack (EF Core) independent of legacy (Hibernate)
3. **Loose Coupling:** Event-driven integration, no direct dependencies
4. **Scalability:** Scale Requirements service independently
5. **Clear Ownership:** Requirements team owns service end-to-end
6. **DDD Patterns:** Proper aggregate boundaries, domain events, owned entities

### Trade-offs

**Pros:**
- Maximum autonomy
- Modern technology stack
- Event-driven integration
- Independent scaling
- Clear boundaries

**Cons:**
- Eventual consistency challenges
- Distributed transaction complexity
- More operational overhead
- Network latency
- Event versioning needed

### When to Use This Pattern

Use Event-Driven Microservices when:
- Domain has clear boundary and can operate independently
- Different technology stack desired
- Independent scaling needed
- Different deployment cadence required
- Team wants full ownership
- Eventual consistency acceptable

**Examples in FactFind:**
- Requirements/Goals (already implemented)
- Risk Assessment (candidate - strong boundary)
- Document Management (candidate - independent lifecycle)
- Notifications (candidate - cross-cutting, async)

### Implementation Checklist

- [ ] Define bounded context boundary
- [ ] Design domain model (aggregates, entities, value objects)
- [ ] Create separate database
- [ ] Implement RESTful API
- [ ] Define domain events
- [ ] Implement event publishing
- [ ] Create event consumers in other services
- [ ] Add monitoring and logging
- [ ] Implement circuit breakers
- [ ] Create deployment pipeline
- [ ] Document API contracts
- [ ] Plan for eventual consistency

### V3 Recommendation

**USE AS TEMPLATE** - Requirements microservice is gold standard. Apply to:
1. New microservices (Risk Assessment, Documents)
2. Extracted domains from monolith
3. Event-driven integration patterns
4. Modern technology stack adoption

---

## Pattern 4: Cross-Schema Integration Pattern

**Used By:** CRM ↔ FactFind ↔ Portfolio
**Impact:** All domains integrated via ClientId
**Maturity:** Production (but needs improvement)
**Status:** **NEEDS REFACTORING - Anti-Corruption Layer required**

### Problem (Current State)

FactFind, CRM, and Portfolio share ClientId as foreign key:
- FactFind queries CRM tables directly (cross-schema)
- Portfolio queries FactFind tables directly
- Tight coupling prevents independent deployment
- Schema changes ripple across domains
- Testing requires all databases

### Current Anti-Pattern

```
FactFind tables reference:
- CRM.dbo.TCRMContact (ClientId)
- CRM.dbo.TRefOccupation (direct reference)

Portfolio tables reference:
- FactFind.dbo.TFactFind
- CRM.dbo.TCRMContact

Direct cross-schema queries:
SELECT * FROM FactFind.dbo.TEmploymentDetail e
JOIN CRM.dbo.TCRMContact c ON e.CRMContactId = c.ContactId  ← BAD
```

### Recommended Pattern: Anti-Corruption Layer

**Solution:**
- Each domain maintains local Client reference
- Synchronize via domain events
- No direct cross-schema queries
- Each domain can evolve independently

**Architecture:**
```
CRM Domain (Source of Truth):
┌────────────────────────────┐
│ TCRMContact (Master)       │
│ - ContactId (PK)           │
│ - Name, DOB, etc.          │
└────────────────────────────┘
         ↓ (publishes events)
┌────────────────────────────┐
│ Event Bus                  │
│ - ClientCreated            │
│ - ClientUpdated            │
│ - ClientDeleted            │
└────────────────────────────┘
         ↓ (subscribes)
┌────────────────────────────┐
│ FactFind Domain            │
│ TFactFindClient (Local)    │
│ - ClientId (PK)            │
│ - CRMContactId (opaque)    │
│ - NameSnapshot             │
│ - DOBSnapshot              │
└────────────────────────────┘
```

**Event-Driven Synchronization:**
```csharp
// CRM publishes
public class ClientCreated : IDomainEvent {
    public int CRMContactId { get; set; }
    public string Name { get; set; }
    public DateTime DateOfBirth { get; set; }
}

// FactFind subscribes
public class ClientCreatedHandler : IEventHandler<ClientCreated> {
    public async Task Handle(ClientCreated @event) {
        var factFindClient = new FactFindClient {
            CRMContactId = @event.CRMContactId,
            NameSnapshot = @event.Name,
            DOBSnapshot = @event.DateOfBirth
        };
        await _repository.AddAsync(factFindClient);
    }
}
```

### Benefits

1. **Loose Coupling:** No direct database dependencies
2. **Independent Deployment:** Deploy FactFind without CRM
3. **Independent Testing:** Mock event bus, no database dependencies
4. **Schema Isolation:** CRM schema changes don't break FactFind
5. **Technology Flexibility:** FactFind can use different database

### Implementation Roadmap

**Phase 1: Create Local References (Week 1-2)**
- Create TFactFindClient table in FactFind schema
- Populate from CRM (initial sync)
- Update FactFind code to use local reference

**Phase 2: Event Listeners (Week 3-4)**
- Implement ClientCreated, ClientUpdated, ClientDeleted handlers
- Synchronize changes from CRM to FactFind
- Add reconciliation job (handle missed events)

**Phase 3: Remove Direct References (Week 5)**
- Remove cross-schema queries
- Remove cross-schema foreign keys
- Update Hibernate mappings
- Test independent deployment

### V3 Recommendation

**CRITICAL REFACTORING NEEDED**:
1. Implement Anti-Corruption Layer (Phase 1-3 above)
2. Remove TRefOccupation cross-schema reference
3. Synchronize via events
4. Enable independent deployment

This is captured in V4 Implementation Roadmap Phase 2.

---

## Pattern 5: Shared Entity Pattern (Address Store)

**Used By:** Shared across CRM, FactFind, Portfolio
**Impact:** Consistent address handling
**Maturity:** Production-proven
**Status:** **GOLD STANDARD - Extend to other shared concerns**

### Problem

Addresses needed by multiple domains:
- Client addresses (CRM)
- Property addresses (FactFind Assets)
- Employer addresses (FactFind Employment)
- Provider addresses (Portfolio Plans)

Duplication leads to inconsistency and maintenance burden.

### Solution

**Centralized Address Store with domain-specific references:**
- Single TAddress table (master)
- Domain tables store AddressId (FK)
- Address validation centralized
- Address formatting consistent
- Geocoding/postcode lookup centralized

### Architecture

```
TAddress (Shared Store):
- AddressId (PK)
- Line1, Line2, Line3
- Town, County
- Postcode, Country
- Latitude, Longitude (geocoded)
- CreatedDate, UpdatedDate

Domain References:
TCRMContact → AddressId (FK to TAddress)
TPropertyDetail → PropertyAddressId (FK to TAddress)
TEmploymentDetail → EmployerAddressId (FK to TAddress)
TPolicyBusiness → ProviderAddressId (FK to TAddress)
```

### API Pattern

**Composite Entity:**
```json
{
  "employmentId": 123,
  "employer": "ABC Corp",
  "employerAddress": {
    "addressId": 456,
    "line1": "123 Business Park",
    "town": "London",
    "postcode": "SW1A 1AA"
  }
}
```

**Or Separate Endpoints:**
```
GET /v3/addresses/{addressId}
POST /v3/addresses
PUT /v3/addresses/{addressId}

GET /v3/clients/{clientId}/employments/{id}
  → Returns: { "employerAddressId": 456 }
```

### Benefits

1. **Consistency:** Single address format across all domains
2. **Centralized Validation:** Postcode validation, geocoding
3. **Reusability:** Create once, reference many times
4. **Maintainability:** Update address logic in one place

### When to Use This Pattern

Use Shared Entity Pattern for:
- Entities used across multiple domains
- Entities with complex validation logic
- Entities with external service integration (geocoding)
- Entities with regulatory requirements (data retention)

**Examples:**
- Address (already implemented)
- Currency/Exchange Rates (candidate)
- Country/Region Reference Data (candidate)
- Tax Rates (candidate)

### V3 Recommendation

**EXTEND THIS PATTERN** to other shared concerns:
1. Currency handling
2. Reference data (countries, regions)
3. Audit metadata
4. Attachment storage

---

## Summary: V3 API Design Principles

Based on V4 pattern analysis:

### 1. Leverage Existing Patterns

**DO:**
- Extend Polymorphic Discriminator Pattern (Plans API)
- Extend Unified Discriminator Routing (Notes API)
- Use Requirements microservice as template
- Adopt Shared Entity Pattern for cross-cutting concerns

**DON'T:**
- Rebuild Plans API (it's excellent)
- Rebuild Notes API (it's excellent)
- Rebuild Requirements microservice (gold standard)
- Duplicate address/shared entity logic

### 2. Refactor Anti-Patterns

**Priority 1:**
- Remove cross-schema dependencies (Anti-Corruption Layer)
- Fix dual-entity mapping (Employment CQRS)

**Priority 2:**
- Replace EAV reference data (typed tables)
- Fix formula-based discriminator (application logic)

### 3. Standardize Across APIs

**Consistency Goals:**
- Pagination (cursor-based)
- Filtering (OData)
- Sorting (orderBy parameter)
- Error handling (RFC 7807)
- Concurrency (ETags)
- HATEOAS links

### 4. Event-Driven Integration

**Adopt Event Publishing:**
- All state changes publish events
- Event schema versioning
- Event sourcing for audit trail
- Consumer idempotency

### 5. Documentation-First

**For Each Pattern:**
- Document discriminator values
- Provide integration examples
- Create Postman collections
- Generate OpenAPI specs

---

## Related Documents

**V4 Analysis:**
- `steering/COVERAGE-CORRECTION-V4-ANALYSIS.md`
- `steering/EXECUTIVE-SUMMARY-COVERAGE-V4.md`

**Implementation:**
- `steering/V4-Implementation-Roadmap.md`
- `steering/API-Contract-Design-V3.md`

**Deep Dives:**
- `Portfolio-Plans-API-Coverage-Analysis.md`
- `Requirements-Goals-API-Coverage.md`
- `FactFind-Notes-Income-API-Coverage.md`

---

**Document Status:** ACTIVE REFERENCE GUIDE
**Owner:** Architecture Team
**Next Review:** Quarterly
**Last Updated:** 2026-02-12

**END OF API ARCHITECTURE PATTERNS GUIDE**
