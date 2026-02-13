# Portfolio Plans API V3: Executive Summary

**Document Date:** 2026-02-12
**Full Specification:** API-Contracts-V3-Portfolio-Plans.md (2,742 lines)
**Status:** Design Complete - Ready for Implementation

---

## What We've Delivered

### Complete V3 API Contracts for Portfolio Plans Domain

This specification provides production-ready OpenAPI 3.1 contracts for the entire Portfolio Plans domain, covering **1,773 distinct plan types** across **9 API families**.

### Key Deliverables

1. **OpenAPI 3.1 Specifications** - Machine-readable contracts for all plan families
2. **Discriminator Pattern Documentation** - How 1,773 plan types are managed polymorphically
3. **Plan Type Catalog** - Organization and categorization of all plan types
4. **Integration Guide** - How Plans APIs integrate with FactFind sections
5. **Usage Examples** - Real-world scenarios with request/response examples
6. **Implementation Guidelines** - For backend, frontend, and API consumers

---

## API Coverage Summary

| API Family | Endpoint | Plan Types | FactFind Sections | Status |
|------------|----------|------------|-------------------|---------|
| **Pensions** | `/v3/clients/{clientId}/plans/pensions` | 287 types | Pensions, Annuities, Money Purchase, State Pension | Production |
| **Protection** | `/v3/clients/{clientId}/plans/protections` | 412 types | Life Assurance, CI, IP, General Insurance | Production |
| **Investments** | `/v3/clients/{clientId}/plans/investments` | 523 types | ISA, Bonds, Unit Trusts, Wrap, GIA | Production |
| **Savings** | `/v3/clients/{clientId}/plans/savings` | 89 types | Savings Accounts, Current Accounts, Cash | Production |
| **Mortgages** | `/v3/clients/{clientId}/plans/mortgages` | 318 types | Residential, Buy-to-Let, Commercial | Production |
| **Equity Release** | `/v3/clients/{clientId}/plans/mortgages` | 44 types | Lifetime Mortgage, Home Reversion | Production |
| **Loans** | `/v3/clients/{clientId}/plans/loans` | 67 types | Personal, Secured, Unsecured, Bridging | Production |
| **Credit Cards** | `/v3/clients/{clientId}/plans/creditcards` | 21 types | Credit Cards | Production |
| **Current Accounts** | `/v3/clients/{clientId}/plans/currentaccounts` | 12 types | Bank Accounts | Production |

**Total: 1,773 plan types with 100% API coverage**

---

## Architecture Highlights

### Polymorphic Discriminator Pattern (Pattern #1)

The Plans API successfully uses Pattern #1 from API-Architecture-Patterns.md:

```
Single Base Entity (TPolicyBusiness)
    ↓
Discriminator Field (RefPlanType2ProdSubTypeId)
    ↓
9 Type-Specific Controllers
    ↓
1,773 Distinct Plan Types
```

**Benefits:**
- Single consistent pattern for all plan types
- Extensible without API changes
- Type-safe with OpenAPI discriminators
- Proven in production for 5+ years

### V3 Enhancements Over V1

| Aspect | V1 (Current) | V3 (Enhanced) |
|--------|--------------|---------------|
| Specification | Internal docs | OpenAPI 3.1 with discriminators |
| Validation | Code-based | JSON Schema comprehensive rules |
| Error Handling | Basic exceptions | RFC 7807 Problem Details |
| Pagination | Ad-hoc | Cursor-based with HATEOAS |
| Filtering | Limited | OData-style expressions |
| Documentation | Minimal | Complete with examples |
| Type Safety | Runtime only | Compile-time + Runtime |

---

## Example API Structures

### Base Plan Document (All Plan Types)

```yaml
BasePlanDocument:
  planId: integer
  clientId: integer
  planType: PlanTypeRef (discriminator)
  provider: ProviderRef
  status: enum [Active, Lapsed, Matured, Surrendered, Cancelled]
  startDate: date
  maturityDate: date
  currentValue: MoneyValue
  regularContribution: ContributionValue
  owners: array[PlanOwnership]
  valuations: array[ValuationValue]
  concurrencyId: integer (optimistic locking)
  _links: PlanLinks (HATEOAS)
```

### Pension-Specific Extension

```yaml
PensionPlanDocument:
  extends: BasePlanDocument
  pensionSpecific:
    retirementAge: integer
    crystallisationDate: date
    taxFreeCashTaken: MoneyValue
    taxFreeCashAvailable: MoneyValue
    lifetimeAllowanceUsed: decimal
    protectionType: enum
    employerContribution: ContributionValue
    employeeContribution: ContributionValue
    benefitType: [DefinedBenefit, DefinedContribution, Hybrid]
```

### Protection-Specific Extension

```yaml
ProtectionPlanDocument:
  extends: BasePlanDocument
  protectionSpecific:
    protectionType: [Life, CriticalIllness, IncomeProtection, LongTermCare]
    sumAssured: MoneyValue
    termYears: integer
    livesAssured: array
    beneficiaries: array
    writtenInTrust: boolean
    underwritingType: enum
    deferredPeriodWeeks: integer
```

### Investment-Specific Extension

```yaml
InvestmentPlanDocument:
  extends: BasePlanDocument
  investmentSpecific:
    investmentType: [ISA, Bond, UnitTrust, Wrap, GIA]
    isaAllowanceUsed: MoneyValue
    assetAllocation: object (equities/bonds/property/cash)
    managementStyle: [Discretionary, Advisory, ExecutionOnly]
    riskRating: integer (1-10)
    ongoingCharges: decimal
```

---

## REST API Patterns

### Standard Operations (All Plan Families)

```http
# List plans
GET /v3/clients/{clientId}/plans/{planFamily}
Query: ?filter=status eq 'Active'&orderBy=value desc&limit=20

# Get specific plan
GET /v3/clients/{clientId}/plans/{planFamily}/{planId}

# Create plan
POST /v3/clients/{clientId}/plans/{planFamily}
Body: CreatePlanRequest

# Full update
PUT /v3/clients/{clientId}/plans/{planFamily}/{planId}
Headers: If-Match: "5"
Body: UpdatePlanRequest

# Partial update
PATCH /v3/clients/{clientId}/plans/{planFamily}/{planId}
Headers: If-Match: "5"
Body: JSON Patch operations

# Delete plan (soft delete)
DELETE /v3/clients/{clientId}/plans/{planFamily}/{planId}
Headers: If-Match: "5"
```

### Status Codes

- **200 OK** - Successful GET, PUT, PATCH
- **201 Created** - Plan created (POST)
- **204 No Content** - Plan deleted (DELETE)
- **400 Bad Request** - Validation failure
- **401 Unauthorized** - Authentication failure
- **403 Forbidden** - Insufficient permissions
- **404 Not Found** - Plan not found
- **409 Conflict** - Concurrent modification (stale ETag)
- **422 Unprocessable Entity** - Business rule violation

### Error Response (RFC 7807)

```json
{
  "type": "https://api.factfind.example.com/problems/validation-error",
  "title": "Validation Error",
  "status": 400,
  "detail": "One or more validation errors occurred",
  "instance": "/v3/clients/12345/plans/pensions/67890",
  "traceId": "00-4bf92f3577b34da6a3ce929d0e0e4736-00",
  "errors": {
    "startDate": ["Start date cannot be in the future"],
    "owners": ["Total ownership must equal 100%"]
  }
}
```

---

## Discriminator Pattern: How 1,773 Plan Types Work

### Three-Level Hierarchy

```
Level 1: Portfolio Category (9 categories)
├── Pensions (287 types)
├── Protection (412 types)
├── Investments (523 types)
├── Savings (89 types)
├── Mortgages (318 types)
├── Equity Release (44 types)
├── Loans (67 types)
├── Credit Cards (21 types)
└── Current Accounts (12 types)

Level 2: Plan Type Group
Example: Pensions
├── SIPP variants (45 types)
├── Personal Pension variants (67 types)
├── Occupational Pension variants (89 types)
├── Annuity variants (52 types)
└── Other pension types (34 types)

Level 3: Specific Product Variants
Example: Personal Pension Plan (planTypeId: 8)
├── Standard Personal Pension
├── Stakeholder Personal Pension
├── Group Personal Pension
└── Executive Personal Pension
```

### Discriminator Routing

```yaml
# OpenAPI Discriminator Mapping
PlanDocument:
  discriminator:
    propertyName: planType/category
    mapping:
      Pension: PensionPlanDocument
      Protection: ProtectionPlanDocument
      Investment: InvestmentPlanDocument
      Savings: SavingsPlanDocument
      Mortgage: MortgagePlanDocument
      Loan: LoanPlanDocument
      CreditCard: CreditCardPlanDocument
```

**How it Works:**
1. Client sends plan with `planType.category = "Pension"`
2. API Gateway extracts discriminator value
3. Routes to PensionPlanController
4. Validates against PensionPlanDocument schema
5. Queries database: `WHERE RefPlanTypeId IN (pension type IDs)`
6. Returns typed response

---

## Key Plan Types Reference

### Top 50 Most Common Plan Types

| ID | Name | Category | Usage |
|----|------|----------|-------|
| 6 | SIPP | Pension | Self-invested personal pension |
| 8 | Personal Pension Plan | Pension | Standard personal pension |
| 22 | Final Salary Scheme | Pension | Defined benefit pension |
| 28 | Pension Annuity | Pension | Retirement income |
| 54 | Whole Of Life | Protection | Lifetime life cover |
| 55 | Term Protection | Protection | Fixed-term life cover |
| 56 | Income Protection | Protection | Salary protection |
| 91 | Critical Illness | Protection | Serious illness cover |
| 1 | ISA Maxi | Investment | Tax-free investment |
| 141 | ISA Stocks & Shares | Investment | Equity ISA |
| 142 | ISA Cash | Savings | Cash ISA |
| 31 | Unit Trust/OEIC | Investment | Collective investment |
| 33 | Insurance/Investment Bond | Investment | Investment bond |
| 143 | Wrap | Investment | Platform account |
| 67 | Mortgage | Mortgage | Standard mortgage |
| 1088 | Standard Residential | Mortgage | Residential mortgage |
| 151 | Buy-to-Let | Mortgage | BTL mortgage |
| 68 | Equity Release | Mortgage | Lifetime mortgage |
| 87 | Personal Loan | Loan | Unsecured loan |
| 30 | Cash Deposit | Savings | Cash account |
| 79 | Savings Account | Savings | Savings account |

**Complete catalog:** See `TRefPlanType2ProdSubType` table or API-Contracts-V3-Portfolio-Plans.md

---

## Integration with FactFind Sections

### Mapping: FactFind UI → Plans API

```
FactFind Section              Plans API Endpoint
════════════════════════════  ══════════════════════════════════
Pensions & Retirement    →    /plans/pensions
Annuities               →    /plans/pensions (type: annuity)
Money Purchase          →    /plans/pensions (type: money purchase)
State Pension           →    /plans/pensions (type: state pension)

Protection (Existing)    →    /plans/protections (type: personal)
General Insurance        →    /plans/protections (type: general)

Investments (Existing)   →    /plans/investments
Savings (Cash)          →    /plans/savings

Mortgages               →    /plans/mortgages
Equity Release          →    /plans/mortgages (type: equity release)

Loans                   →    /plans/loans
Credit Cards            →    /plans/creditcards
Current Accounts        →    /plans/currentaccounts
```

### Query Example: Load Pensions Section

```javascript
// Get all pension plans for client
async function loadPensionsSection(clientId) {
  const response = await fetch(
    `https://api.factfind.example.com/v3/clients/${clientId}/plans/pensions`,
    {
      headers: {
        'Authorization': `Bearer ${token}`,
        'X-Tenant-Id': tenantId
      }
    }
  );

  const data = await response.json();

  return {
    plans: data.items,
    summary: {
      totalValue: data.summary.totalValue,
      totalContributions: data.summary.totalRegularContributions,
      projectedIncome: data.summary.projectedRetirementIncome
    }
  };
}
```

---

## Usage Examples

### Example 1: Create SIPP

```http
POST /v3/clients/12345/plans/pensions
Content-Type: application/json

{
  "planTypeId": 6,
  "providerId": 123,
  "policyNumber": "SIPP-2026-001",
  "startDate": "2026-04-06",
  "currentValue": { "amount": 0, "currency": "GBP" },
  "regularContribution": {
    "amount": 1000,
    "currency": "GBP",
    "frequency": "Monthly"
  },
  "owners": [
    {
      "partyId": 12345,
      "ownershipPercentage": 100,
      "salaryContributable": 60000
    }
  ],
  "pensionSpecific": {
    "retirementAge": 67,
    "employerContribution": { "amount": 400, "frequency": "Monthly" },
    "employeeContribution": { "amount": 600, "frequency": "Monthly" }
  }
}

Response: 201 Created
Location: /v3/clients/12345/plans/pensions/67890
ETag: "1"
{
  "planId": 67890,
  "status": "PendingActivation",
  "sequentialRef": "IOB00067890",
  ...
}
```

### Example 2: Update Plan Value

```http
PATCH /v3/clients/12345/plans/pensions/67890
If-Match: "5"
Content-Type: application/json-patch+json

[
  { "op": "replace", "path": "/currentValue/amount", "value": 135000 },
  { "op": "replace", "path": "/status", "value": "Active" }
]

Response: 200 OK
ETag: "6"
{
  "planId": 67890,
  "currentValue": { "amount": 135000, "currency": "GBP" },
  "status": "Active",
  "concurrencyId": 6,
  ...
}
```

### Example 3: Query Active High-Value Plans

```http
GET /v3/clients/12345/plans/investments?filter=status eq 'Active' and currentValue/amount gt 100000&orderBy=currentValue/amount desc

Response: 200 OK
{
  "items": [
    {
      "planId": 11111,
      "planType": { "name": "ISA Stocks & Shares" },
      "currentValue": { "amount": 185000 }
    },
    {
      "planId": 22222,
      "planType": { "name": "Wrap" },
      "currentValue": { "amount": 142000 }
    }
  ],
  "pagination": { "hasMore": false },
  "summary": {
    "totalValue": { "amount": 327000, "currency": "GBP" }
  }
}
```

### Example 4: Create Mortgage with Property

```http
POST /v3/clients/12345/plans/mortgages
{
  "planTypeId": 1088,
  "providerId": 789,
  "policyNumber": "MTG-2026-12345",
  "startDate": "2026-03-01",
  "maturityDate": "2051-03-01",
  "owners": [
    { "partyId": 12345, "ownershipPercentage": 50 },
    { "partyId": 12346, "ownershipPercentage": 50 }
  ],
  "mortgageSpecific": {
    "propertyValue": { "amount": 350000, "currency": "GBP" },
    "loanAmount": { "amount": 280000, "currency": "GBP" },
    "loanToValue": 80.0,
    "interestRate": 3.75,
    "interestRateType": "Fixed",
    "mortgageTerm": 25,
    "repaymentMethod": "Repayment",
    "monthlyPayment": { "amount": 1425, "currency": "GBP" },
    "property": {
      "address": {
        "line1": "123 Example Street",
        "town": "London",
        "postcode": "SW1A 1AA"
      },
      "propertyType": "SemiDetached",
      "tenure": "Freehold"
    },
    "mortgageType": "Residential"
  }
}
```

---

## Reference Data APIs

### Get Available Plan Types

```http
GET /v3/reference/plan-types?category=Pension&isArchived=false

Response:
{
  "items": [
    {
      "planTypeId": 6,
      "name": "SIPP",
      "category": "Pension",
      "discriminatorId": 1,
      "requiredFields": ["retirementAge", "owners"],
      "optionalFields": ["employerContribution", "schemeReference"]
    },
    {
      "planTypeId": 8,
      "name": "Personal Pension Plan",
      "category": "Pension",
      "discriminatorId": 1,
      ...
    }
  ]
}
```

### Get Providers for Plan Type

```http
GET /v3/reference/providers?planType=6

Response:
{
  "items": [
    {
      "providerId": 123,
      "name": "Aviva",
      "regulatoryReference": "119790",
      "supportedPlanTypes": [6, 8, 10, 15, ...]
    },
    {
      "providerId": 456,
      "name": "Legal & General",
      "regulatoryReference": "202050",
      ...
    }
  ]
}
```

---

## Implementation Guidelines

### For Backend Developers

**Phase 1: OpenAPI Annotations (2 weeks)**
- Add OpenAPI/Swagger attributes to existing controllers
- Generate OpenAPI 3.1 specs from code
- Validate specs match documentation

**Phase 2: RFC 7807 Error Handling (1 week)**
- Create ProblemDetails exception filter
- Map existing exceptions to Problem Details
- Add field-level validation errors

**Phase 3: Pagination & Filtering (2 weeks)**
- Implement cursor-based pagination
- Add OData-style filter parsing
- Add orderBy and select support

**Phase 4: HATEOAS Links (1 week)**
- Add _links to all responses
- Implement link generators
- Test link navigation

**Total Effort:** 6 weeks

### For Frontend Developers

**Phase 1: OpenAPI Client Generation (1 week)**
- Generate TypeScript clients from OpenAPI specs
- Create typed request/response models
- Set up API client configuration

**Phase 2: Update API Calls (3 weeks)**
- Replace V1 calls with V3 clients
- Implement cursor-based pagination UI
- Add filter/sort controls
- Handle RFC 7807 errors

**Phase 3: Optimistic Concurrency (1 week)**
- Send If-Match headers on updates
- Handle 409 Conflict responses
- Implement retry with refresh logic

**Total Effort:** 5 weeks

### For API Consumers

**Quick Start:**
1. Generate client from OpenAPI spec
2. Obtain JWT token from auth service
3. Include token in Authorization header
4. Include X-Tenant-Id header
5. Use typed request objects
6. Handle errors from Problem Details
7. Respect rate limits

**Best Practices:**
- Always use If-Match for updates
- Implement exponential backoff for retries
- Cache reference data (plan types, providers)
- Use sparse fieldsets (select) to reduce bandwidth
- Monitor X-Rate-Limit headers

---

## Migration from V1 to V3

### Breaking Changes

| Aspect | V1 | V3 |
|--------|----|----|
| URL | `/v1/clients/...` | `/v3/clients/...` |
| Errors | Custom format | RFC 7807 Problem Details |
| Pagination | Offset/limit | Cursor-based |
| Response | Wrapped | Direct document |
| Dates | Variable format | ISO 8601 with timezone |

### Migration Timeline

**Month 1-3: Parallel Running**
- V3 deployed alongside V1
- Both APIs read/write same database
- Feature parity validation

**Month 4-9: Client Migration**
- Client applications migrate to V3
- V1 marked deprecated in documentation
- Migration support provided

**Month 10-12: V1 Sunset**
- V1 endpoints return 410 Gone
- All traffic on V3
- V1 code removed

---

## Key Benefits of V3 Design

### 1. Standards Compliance
- OpenAPI 3.1 for machine-readable contracts
- RFC 7807 for consistent error handling
- OData for powerful filtering
- JSON Patch (RFC 6902) for efficient updates

### 2. Developer Experience
- Type-safe client code generation
- Comprehensive validation before API calls
- Clear error messages with field-level detail
- HATEOAS links for discoverability

### 3. Extensibility
- New plan types added without API changes
- Discriminator pattern scales to thousands of types
- Backward compatible field additions
- Versioned independently per family

### 4. Performance
- Cursor-based pagination for large collections
- Sparse fieldsets reduce bandwidth
- ETag caching prevents unnecessary transfers
- Efficient filtering at database layer

### 5. Maintainability
- Single source of truth (OpenAPI specs)
- Consistent patterns across all APIs
- Automated validation from schemas
- Clear separation of concerns

---

## Success Metrics

### API Quality
- OpenAPI 3.1 spec validation: 100% pass
- API Design Guidelines compliance: 100%
- Breaking change detection: Automated
- Documentation coverage: 100%

### Performance
- Single plan GET: <100ms (p95)
- Collection GET (20 items): <200ms (p95)
- Plan mutations: <300ms (p95)
- Reference data: <50ms (p95, cached)

### Developer Adoption
- Client SDK generation: Automated
- Type safety coverage: 100%
- Integration examples: Complete
- Migration guides: Available

---

## Next Steps

### Immediate Actions (Week 1-2)
1. Review and approve V3 API contracts
2. Set up OpenAPI tooling and validation
3. Configure API gateway for V3 routes
4. Create development environment

### Implementation (Week 3-8)
1. Backend: Add OpenAPI annotations
2. Backend: Implement RFC 7807 errors
3. Backend: Add pagination/filtering
4. Frontend: Generate TypeScript clients
5. Frontend: Migrate API calls

### Testing (Week 9-10)
1. Contract testing against OpenAPI specs
2. Integration testing across all plan families
3. Performance testing (p95 targets)
4. Security testing (OWASP Top 10)

### Production Rollout (Week 11-12)
1. Deploy V3 in parallel with V1
2. Route 10% traffic to V3 (canary)
3. Monitor metrics and errors
4. Gradually increase to 100%

---

## Related Documents

**Full Specification:**
- API-Contracts-V3-Portfolio-Plans.md (2,742 lines)

**Reference Documents:**
- Portfolio-Plans-API-Coverage-Analysis.md
- API-Architecture-Patterns.md (Pattern #1: Polymorphic Discriminator)
- Context/API+Design+Guidelines+2.0.doc

**Database Schema:**
- TPolicyBusiness (base plan table)
- TRefPlanType2ProdSubType (discriminator mapping, 1,773 rows)
- TMortgage, TEquityRelease (extension tables)

---

## Contact

**API Architecture Team**
- Email: api-architecture@factfind.example.com
- Slack: #api-architecture
- Wiki: https://wiki.factfind.example.com/api/v3/plans

**Support Channels**
- API Support: api-support@factfind.example.com
- Developer Portal: https://developers.factfind.example.com
- Status Page: https://status.factfind.example.com

---

**Document Status:** ✅ DESIGN COMPLETE
**Approvals Required:** Product Owner, Technical Architect, Security Team
**Target Implementation:** Q2 2026

---

**END OF SUMMARY**
