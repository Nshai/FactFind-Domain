# API Contracts V3: Portfolio Plans Domain

**Document Version:** 3.0
**Date:** 2026-02-12
**Status:** DESIGN SPECIFICATION
**Purpose:** Complete V3 API contract design for Portfolio Plans domain with 1,773 plan types

---

## Executive Summary

This document specifies V3 API contracts for the Portfolio Plans domain, building upon the proven polymorphic discriminator pattern that successfully manages 1,773 distinct plan types. The V3 contracts enhance the existing architecture with OpenAPI 3.1 specifications, improved documentation, standardized validation patterns, and consistent developer experience across all plan families.

### Key Design Decisions

1. **Preserve Polymorphic Architecture**: The existing discriminator-based pattern has proven successful and is retained
2. **Enhance, Don't Replace**: V3 adds standards compliance, better validation, and documentation to existing endpoints
3. **OpenAPI 3.1 Specifications**: Complete machine-readable contracts for all plan families
4. **Type Safety**: Strong typing with discriminator-based polymorphism in OpenAPI
5. **Single Contract Principle**: Each request/response follows API Design Guidelines 2.0
6. **Consistent Patterns**: All plan families follow identical URL structure, HTTP methods, and response formats

### API Coverage

| Plan Family | Controller | Plan Types | FactFind Sections | Status |
|-------------|-----------|------------|-------------------|---------|
| Pensions | PensionPlanController | 287 types | Pensions & Retirement, Annuities, Money Purchase, State Pension | PRODUCTION |
| Protection | ProtectionPlanController | 412 types | Life Assurance, Critical Illness, Income Protection, General Insurance | PRODUCTION |
| Investments | InvestmentPlanController | 523 types | ISA, Bonds, Unit Trusts, Wrap Accounts, Investment Trusts | PRODUCTION |
| Savings | SavingsAccountPlanController | 89 types | Savings Accounts, Current Accounts, Cash Deposits | PRODUCTION |
| Mortgages | MortgagePlanController | 318 types | Residential, Buy-to-Let, Remortgage, Commercial | PRODUCTION |
| Equity Release | MortgagePlanController | 44 types | Lifetime Mortgage, Home Reversion | PRODUCTION |
| Loans | LoanPlanController | 67 types | Personal Loans, Secured, Unsecured, Bridging | PRODUCTION |
| Credit Cards | CreditCardPlanController | 21 types | Credit Cards | PRODUCTION |
| Current Accounts | CurrentAccountPlanController | 12 types | Bank Accounts | PRODUCTION |

**Total: 1,773 distinct plan types across 9 controller families**

---

## Architecture Overview

### Polymorphic Discriminator Pattern

The Portfolio Plans API uses Pattern #1 (Polymorphic Discriminator) from API-Architecture-Patterns.md, providing:

```
Base Entity: TPolicyBusiness
├── Common Fields: PlanId, ClientId, Provider, Value, StartDate, etc.
├── Discriminator: RefPlanType2ProdSubTypeId → RefPlanDiscriminatorId
└── Extensions:
    ├── TMortgage (mortgage-specific fields)
    └── TEquityRelease (equity release-specific fields)

API Layer: Type-Specific Controllers
├── /v3/clients/{clientId}/plans/pensions
├── /v3/clients/{clientId}/plans/protections
├── /v3/clients/{clientId}/plans/investments
├── /v3/clients/{clientId}/plans/savings
├── /v3/clients/{clientId}/plans/mortgages
├── /v3/clients/{clientId}/plans/loans
├── /v3/clients/{clientId}/plans/creditcards
└── /v3/clients/{clientId}/plans/currentaccounts

Backend: Discriminator-Based Routing
TRefPlanType2ProdSubType.RefPlanDiscriminatorId → Concrete Plan Handler
```

### V3 Enhancements Over V1

| Aspect | V1 (Existing) | V3 (Enhanced) |
|--------|--------------|---------------|
| **Specification Format** | Internal documentation | OpenAPI 3.1 with discriminators |
| **Validation** | Code-based | JSON Schema with comprehensive rules |
| **Error Handling** | Basic exceptions | RFC 7807 Problem Details |
| **Pagination** | Ad-hoc | Cursor-based with HATEOAS links |
| **Filtering** | Limited | OData-style query parameters |
| **Versioning** | ETags only | ETags + Last-Modified headers |
| **Documentation** | Minimal | Comprehensive with examples |
| **Type Safety** | Runtime validation | Compile-time + Runtime via OpenAPI |
| **HATEOAS** | Partial | Complete link relations |

---

## Common API Patterns

### URL Structure

All plan APIs follow consistent RESTful patterns:

```
Base URL: https://api.factfind.example.com/v3

Plan Collections:
GET    /v3/clients/{clientId}/plans/{planFamily}
POST   /v3/clients/{clientId}/plans/{planFamily}

Plan Resources:
GET    /v3/clients/{clientId}/plans/{planFamily}/{planId}
PUT    /v3/clients/{clientId}/plans/{planFamily}/{planId}
PATCH  /v3/clients/{clientId}/plans/{planFamily}/{planId}
DELETE /v3/clients/{clientId}/plans/{planFamily}/{planId}

Reference Data:
GET    /v3/reference/plan-types?category={planFamily}
GET    /v3/reference/providers?planType={planTypeId}
GET    /v3/reference/products?providerId={providerId}
```

### HTTP Methods

| Method | Purpose | Idempotent | Request Body | Success Codes |
|--------|---------|------------|--------------|---------------|
| GET | Retrieve plan(s) | Yes | None | 200 OK |
| POST | Create new plan | No | Plan document | 201 Created |
| PUT | Replace entire plan | Yes | Complete plan | 200 OK |
| PATCH | Update plan fields | No | Partial plan (JSON Patch) | 200 OK |
| DELETE | Remove plan | Yes | None | 204 No Content |

### Status Codes

| Code | Meaning | Usage |
|------|---------|-------|
| 200 OK | Successful retrieval or update | GET, PUT, PATCH |
| 201 Created | Plan created | POST |
| 204 No Content | Successful deletion | DELETE |
| 400 Bad Request | Validation failure | All mutation operations |
| 401 Unauthorized | Missing or invalid authentication | All operations |
| 403 Forbidden | Insufficient permissions | All operations |
| 404 Not Found | Plan or client not found | GET, PUT, PATCH, DELETE |
| 409 Conflict | Concurrency violation (stale ETag) | PUT, PATCH, DELETE |
| 422 Unprocessable Entity | Business rule violation | POST, PUT, PATCH |
| 429 Too Many Requests | Rate limit exceeded | All operations |
| 500 Internal Server Error | Server error | All operations |

### Common Request Headers

```http
Authorization: Bearer {jwt-token}
Content-Type: application/json
Accept: application/json
X-Tenant-Id: {tenantId}
If-Match: "{etag}"  // For updates to prevent lost updates
```

### Common Response Headers

```http
Content-Type: application/json
ETag: "{etag}"  // For optimistic concurrency
Last-Modified: {timestamp}
Location: {resource-uri}  // For POST responses
Link: <{next-page}>; rel="next"  // For pagination
X-Total-Count: {total}  // For collections
X-Rate-Limit-Remaining: {remaining}
```

### Error Response Format (RFC 7807)

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
    "planTypeId": ["Plan type 999 is not valid for pension plans"]
  }
}
```

### Pagination Pattern (Cursor-Based)

```http
GET /v3/clients/{clientId}/plans/pensions?limit=20&cursor={opaque-token}

Response:
{
  "items": [...],
  "pagination": {
    "limit": 20,
    "hasMore": true,
    "nextCursor": "eyJwbGFuSWQiOjEyMzQ1LCJzb3J0IjoiYXNjIn0="
  },
  "_links": {
    "self": { "href": "/v3/clients/12345/plans/pensions?limit=20&cursor=..." },
    "next": { "href": "/v3/clients/12345/plans/pensions?limit=20&cursor=eyJ..." }
  }
}
```

### Filtering and Sorting

```http
GET /v3/clients/{clientId}/plans/pensions?filter=status eq 'Active'&orderBy=startDate desc

Query Parameters:
- filter: OData-style filter expressions
  Examples:
    - status eq 'Active'
    - value gt 10000
    - startDate ge '2020-01-01'
    - provider/name eq 'Aviva'

- orderBy: Sort specification
  Examples:
    - startDate desc
    - value asc
    - provider/name asc, startDate desc

- select: Field selection (sparse fieldsets)
  Examples:
    - planId,policyNumber,value
    - planId,provider/name,value
```

---

## Common Schema Definitions

### Base Plan Document (Shared by All Plan Types)

```yaml
BasePlanDocument:
  type: object
  required:
    - planId
    - clientId
    - planType
    - provider
    - status
  properties:
    planId:
      type: integer
      format: int32
      description: Unique plan identifier
      example: 67890
    clientId:
      type: integer
      format: int32
      description: Primary client identifier
      example: 12345
    tenantId:
      type: integer
      format: int32
      description: Multi-tenancy identifier
      example: 1
    policyNumber:
      type: string
      maxLength: 50
      description: Provider's policy/plan reference number
      example: "PP-123456-789"
    planType:
      $ref: '#/components/schemas/PlanTypeRef'
    provider:
      $ref: '#/components/schemas/ProviderRef'
    status:
      type: string
      enum: [Active, Lapsed, Matured, Surrendered, Cancelled, PendingActivation]
      description: Current lifecycle status of the plan
      example: Active
    startDate:
      type: string
      format: date
      description: Plan commencement date
      example: "2020-01-01"
    maturityDate:
      type: string
      format: date
      nullable: true
      description: Plan maturity or end date
      example: "2045-01-01"
    baseCurrency:
      type: string
      maxLength: 3
      description: ISO 4217 currency code
      pattern: '^[A-Z]{3}$'
      default: GBP
      example: GBP
    currentValue:
      $ref: '#/components/schemas/MoneyValue'
    regularContribution:
      $ref: '#/components/schemas/ContributionValue'
    adviser:
      $ref: '#/components/schemas/AdviserRef'
    owners:
      type: array
      minItems: 1
      maxItems: 4
      items:
        $ref: '#/components/schemas/PlanOwnership'
    valuations:
      type: array
      items:
        $ref: '#/components/schemas/ValuationValue'
    concurrencyId:
      type: integer
      format: int32
      description: Optimistic concurrency token
      example: 5
    sequentialRef:
      type: string
      readOnly: true
      description: Human-readable reference (e.g., IOB00000001)
      pattern: '^[A-Z]{3}\d{8}$'
      example: "IOB00012345"
    createdAt:
      type: string
      format: date-time
      readOnly: true
      description: Timestamp when plan was created
    updatedAt:
      type: string
      format: date-time
      readOnly: true
      description: Timestamp when plan was last updated
    _links:
      $ref: '#/components/schemas/PlanLinks'

PlanTypeRef:
  type: object
  required:
    - planTypeId
    - name
  properties:
    planTypeId:
      type: integer
      format: int32
      description: RefPlanType2ProdSubTypeId discriminator value
      example: 8
    name:
      type: string
      description: Display name of plan type
      example: "Personal Pension Plan"
    category:
      type: string
      description: High-level category
      enum: [Pension, Protection, Investment, Savings, Mortgage, Liability]
      example: Pension
    discriminatorId:
      type: integer
      format: int32
      readOnly: true
      description: Internal discriminator for polymorphic routing
      example: 1

ProviderRef:
  type: object
  required:
    - providerId
    - name
  properties:
    providerId:
      type: integer
      format: int32
      example: 123
    name:
      type: string
      example: "Aviva"
    regulatoryReference:
      type: string
      nullable: true
      description: FCA reference number
      example: "119790"

AdviserRef:
  type: object
  properties:
    practitionerId:
      type: integer
      format: int32
      example: 789
    name:
      type: string
      example: "John Smith"
    firmName:
      type: string
      nullable: true
      example: "XYZ Financial Advisers Ltd"

PlanOwnership:
  type: object
  required:
    - partyId
    - ownershipPercentage
  properties:
    partyId:
      type: integer
      format: int32
      description: CRMContactId of the owner
      example: 12345
    ownerName:
      type: string
      readOnly: true
      example: "Jane Doe"
    ownershipPercentage:
      type: number
      format: decimal
      minimum: 0
      maximum: 100
      example: 100.00
    salaryContributable:
      type: number
      format: decimal
      nullable: true
      description: For pension plans, the salary used for contribution calculations
      example: 45000.00

MoneyValue:
  type: object
  required:
    - amount
    - currency
  properties:
    amount:
      type: number
      format: decimal
      example: 125000.50
    currency:
      type: string
      maxLength: 3
      pattern: '^[A-Z]{3}$'
      example: GBP

ContributionValue:
  type: object
  properties:
    amount:
      type: number
      format: decimal
      example: 500.00
    currency:
      type: string
      maxLength: 3
      default: GBP
      example: GBP
    frequency:
      type: string
      enum: [Monthly, Quarterly, Annual, SinglePremium, AdHoc]
      example: Monthly

ValuationValue:
  type: object
  required:
    - valuationDate
    - value
  properties:
    valuationDate:
      type: string
      format: date
      example: "2026-01-31"
    value:
      $ref: '#/components/schemas/MoneyValue'
    source:
      type: string
      enum: [Provider, Estimated, Calculated, Manual]
      example: Provider
    fundBreakdown:
      type: array
      items:
        $ref: '#/components/schemas/FundHoldingValue'

FundHoldingValue:
  type: object
  properties:
    fundName:
      type: string
      example: "Aviva Global Equity Fund"
    fundCode:
      type: string
      example: "AVV001"
    units:
      type: number
      format: decimal
      example: 1234.56
    unitPrice:
      type: number
      format: decimal
      example: 101.25
    value:
      $ref: '#/components/schemas/MoneyValue'
    percentage:
      type: number
      format: decimal
      minimum: 0
      maximum: 100
      example: 35.5

PlanLinks:
  type: object
  description: HATEOAS links for related resources
  properties:
    self:
      $ref: '#/components/schemas/Link'
    client:
      $ref: '#/components/schemas/Link'
    provider:
      $ref: '#/components/schemas/Link'
    valuations:
      $ref: '#/components/schemas/Link'
    contributions:
      $ref: '#/components/schemas/Link'
    withdrawals:
      $ref: '#/components/schemas/Link'
    documents:
      $ref: '#/components/schemas/Link'

Link:
  type: object
  required:
    - href
  properties:
    href:
      type: string
      format: uri
      example: "/v3/clients/12345/plans/pensions/67890"
    method:
      type: string
      enum: [GET, POST, PUT, PATCH, DELETE]
      default: GET
    templated:
      type: boolean
      default: false
```

---

## Pensions API Family

### Overview

The Pensions API manages retirement planning products including SIPPs, personal pensions, final salary schemes, money purchase pensions, annuities, and state pension information.

**Plan Types Covered:** 287 distinct types
**Base Endpoint:** `/v3/clients/{clientId}/plans/pensions`
**Discriminator Range:** RefPlanDiscriminatorId = 1 (AssetPlan - Pension subtypes)

### Key Pension Plan Types

| Plan Type ID | Name | Description |
|--------------|------|-------------|
| 6 | SIPP | Self-Invested Personal Pension |
| 8 | Personal Pension Plan | Standard personal pension |
| 10 | Stakeholder Individual | Low-cost stakeholder pension |
| 11 | Executive Pension Plan | Company executive pension |
| 12 | SSAS | Small Self-Administered Scheme |
| 13 | s32 Buyout Bond | Section 32 buyout policy |
| 15 | Group Personal Pension | Employer group scheme |
| 22 | Final Salary Scheme | Defined benefit pension |
| 28 | Pension Annuity | Standard pension annuity |
| 76 | Money Purchase Contracted | Money purchase scheme |
| 145 | QROPS | Qualifying Recognised Overseas Pension Scheme |
| 1054 | Enhanced Pension Annuity | Enhanced annuity for health conditions |
| 1055 | Flexible Income Drawdown | Post-pension freedom drawdown |
| 1056 | Capped Income Drawdown | Pre-2015 capped drawdown |
| 1098 | QNUPS | Qualifying Non-UK Pension Scheme |

### Pension-Specific Fields

```yaml
PensionPlanDocument:
  allOf:
    - $ref: '#/components/schemas/BasePlanDocument'
    - type: object
      properties:
        pensionSpecific:
          type: object
          properties:
            retirementAge:
              type: integer
              minimum: 55
              maximum: 100
              description: Target retirement age
              example: 67
            crystallisationDate:
              type: string
              format: date
              nullable: true
              description: Date benefits were accessed (post-2015)
              example: "2025-04-06"
            taxFreeCashTaken:
              $ref: '#/components/schemas/MoneyValue'
            taxFreeCashAvailable:
              $ref: '#/components/schemas/MoneyValue'
            annualAllowance:
              $ref: '#/components/schemas/MoneyValue'
            lifetimeAllowanceUsed:
              type: number
              format: decimal
              minimum: 0
              maximum: 100
              description: Percentage of lifetime allowance used
              example: 35.5
            protectionType:
              type: string
              enum: [None, Enhanced, Primary, Fixed2012, Fixed2014, Fixed2016, Individual2014, Individual2016]
              nullable: true
              example: Fixed2016
            protectionReference:
              type: string
              nullable: true
              description: HMRC protection certificate reference
              example: "FP161234567890A"
            transferValue:
              $ref: '#/components/schemas/MoneyValue'
            projectedFundAtRetirement:
              $ref: '#/components/schemas/MoneyValue'
            projectedIncomeAtRetirement:
              $ref: '#/components/schemas/MoneyValue'
            employerContribution:
              $ref: '#/components/schemas/ContributionValue'
            employeeContribution:
              $ref: '#/components/schemas/ContributionValue'
            benefitType:
              type: string
              enum: [DefinedBenefit, DefinedContribution, Hybrid]
              example: DefinedContribution
            schemeReference:
              type: string
              nullable: true
              description: HMRC Pension Scheme Tax Reference (PSTR)
              pattern: '^\d{8}[A-Z]{2}$'
              example: "12345678AB"
```

### OpenAPI 3.1 Specification - Pensions API

```yaml
openapi: 3.1.0
info:
  title: Pensions API
  version: 3.0.0
  description: |
    Manage pension plans including SIPPs, personal pensions, final salary schemes,
    money purchase pensions, and annuities. Supports full CRUD operations with
    polymorphic plan type handling.
  contact:
    name: API Support
    email: api-support@factfind.example.com
  license:
    name: Proprietary

servers:
  - url: https://api.factfind.example.com/v3
    description: Production
  - url: https://api-staging.factfind.example.com/v3
    description: Staging

tags:
  - name: Pensions
    description: Pension plan operations
  - name: Reference Data
    description: Plan types, providers, and product reference data

paths:
  /clients/{clientId}/plans/pensions:
    parameters:
      - $ref: '#/components/parameters/ClientId'

    get:
      operationId: listPensionPlans
      summary: List all pension plans for a client
      description: |
        Retrieves all pension plans associated with the client. Supports filtering,
        sorting, pagination, and sparse fieldsets.
      tags:
        - Pensions
      parameters:
        - $ref: '#/components/parameters/Filter'
        - $ref: '#/components/parameters/OrderBy'
        - $ref: '#/components/parameters/Limit'
        - $ref: '#/components/parameters/Cursor'
        - $ref: '#/components/parameters/Select'
      responses:
        '200':
          description: Successful response with pension plans
          headers:
            X-Total-Count:
              schema:
                type: integer
              description: Total number of plans matching filter
            ETag:
              schema:
                type: string
              description: Collection ETag for caching
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PensionPlanCollection'
              examples:
                multiple-pensions:
                  $ref: '#/components/examples/PensionPlanCollectionExample'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'
        '404':
          $ref: '#/components/responses/NotFound'

    post:
      operationId: createPensionPlan
      summary: Create a new pension plan
      description: |
        Creates a new pension plan for the client. The plan type determines which
        fields are required and validated.
      tags:
        - Pensions
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreatePensionPlanRequest'
            examples:
              create-sipp:
                $ref: '#/components/examples/CreateSIPPExample'
              create-final-salary:
                $ref: '#/components/examples/CreateFinalSalaryExample'
      responses:
        '201':
          description: Pension plan created successfully
          headers:
            Location:
              schema:
                type: string
                format: uri
              description: URI of the created plan
            ETag:
              schema:
                type: string
              description: ETag for optimistic concurrency
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PensionPlanDocument'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'
        '422':
          $ref: '#/components/responses/UnprocessableEntity'

  /clients/{clientId}/plans/pensions/{planId}:
    parameters:
      - $ref: '#/components/parameters/ClientId'
      - $ref: '#/components/parameters/PlanId'

    get:
      operationId: getPensionPlan
      summary: Get a specific pension plan
      description: Retrieves detailed information about a specific pension plan
      tags:
        - Pensions
      parameters:
        - $ref: '#/components/parameters/Select'
      responses:
        '200':
          description: Successful response
          headers:
            ETag:
              schema:
                type: string
              description: ETag for optimistic concurrency
            Last-Modified:
              schema:
                type: string
                format: date-time
              description: Last modification timestamp
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PensionPlanDocument'
              examples:
                sipp-plan:
                  $ref: '#/components/examples/SIPPPlanExample'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'
        '404':
          $ref: '#/components/responses/NotFound'

    put:
      operationId: updatePensionPlan
      summary: Update a pension plan (full replacement)
      description: |
        Replaces the entire pension plan with the provided data. Requires the current
        ETag in the If-Match header to prevent lost updates.
      tags:
        - Pensions
      parameters:
        - $ref: '#/components/parameters/IfMatch'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdatePensionPlanRequest'
      responses:
        '200':
          description: Plan updated successfully
          headers:
            ETag:
              schema:
                type: string
              description: New ETag after update
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PensionPlanDocument'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'
        '404':
          $ref: '#/components/responses/NotFound'
        '409':
          $ref: '#/components/responses/Conflict'
        '422':
          $ref: '#/components/responses/UnprocessableEntity'

    patch:
      operationId: patchPensionPlan
      summary: Partially update a pension plan
      description: |
        Updates specific fields of a pension plan using JSON Patch (RFC 6902) operations.
        Requires the current ETag in the If-Match header.
      tags:
        - Pensions
      parameters:
        - $ref: '#/components/parameters/IfMatch'
      requestBody:
        required: true
        content:
          application/json-patch+json:
            schema:
              type: array
              items:
                $ref: '#/components/schemas/JsonPatchOperation'
            examples:
              update-value:
                summary: Update plan value
                value:
                  - op: replace
                    path: /currentValue/amount
                    value: 135000.00
              update-contribution:
                summary: Update regular contribution
                value:
                  - op: replace
                    path: /regularContribution/amount
                    value: 600.00
                  - op: replace
                    path: /regularContribution/frequency
                    value: Monthly
      responses:
        '200':
          description: Plan patched successfully
          headers:
            ETag:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PensionPlanDocument'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'
        '404':
          $ref: '#/components/responses/NotFound'
        '409':
          $ref: '#/components/responses/Conflict'
        '422':
          $ref: '#/components/responses/UnprocessableEntity'

    delete:
      operationId: deletePensionPlan
      summary: Delete a pension plan
      description: |
        Soft-deletes a pension plan by marking it as deleted. The plan data is retained
        for audit purposes but excluded from normal queries.
      tags:
        - Pensions
      parameters:
        - $ref: '#/components/parameters/IfMatch'
      responses:
        '204':
          description: Plan deleted successfully
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'
        '404':
          $ref: '#/components/responses/NotFound'
        '409':
          $ref: '#/components/responses/Conflict'

components:
  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      description: JWT token obtained from authentication service

  parameters:
    ClientId:
      name: clientId
      in: path
      required: true
      description: Unique client identifier (CRMContactId)
      schema:
        type: integer
        format: int32
        minimum: 1
      example: 12345

    PlanId:
      name: planId
      in: path
      required: true
      description: Unique plan identifier (PolicyBusinessId)
      schema:
        type: integer
        format: int32
        minimum: 1
      example: 67890

    Filter:
      name: filter
      in: query
      description: OData-style filter expression
      schema:
        type: string
      examples:
        active-plans:
          value: "status eq 'Active'"
          summary: Active plans only
        high-value:
          value: "currentValue/amount gt 100000"
          summary: Plans worth more than 100k
        recent:
          value: "startDate ge '2020-01-01'"
          summary: Plans started since 2020

    OrderBy:
      name: orderBy
      in: query
      description: Sort specification
      schema:
        type: string
      examples:
        value-desc:
          value: "currentValue/amount desc"
        date-asc:
          value: "startDate asc"

    Limit:
      name: limit
      in: query
      description: Maximum number of items to return
      schema:
        type: integer
        minimum: 1
        maximum: 100
        default: 20

    Cursor:
      name: cursor
      in: query
      description: Opaque pagination cursor
      schema:
        type: string

    Select:
      name: select
      in: query
      description: Comma-separated list of fields to include (sparse fieldsets)
      schema:
        type: string
      example: "planId,policyNumber,currentValue,provider/name"

    IfMatch:
      name: If-Match
      in: header
      description: ETag for optimistic concurrency control
      required: true
      schema:
        type: string
      example: '"5"'

  schemas:
    PensionPlanCollection:
      type: object
      required:
        - items
        - pagination
      properties:
        items:
          type: array
          items:
            $ref: '#/components/schemas/PensionPlanDocument'
        pagination:
          $ref: '#/components/schemas/PaginationInfo'
        summary:
          $ref: '#/components/schemas/PensionSummary'
        _links:
          $ref: '#/components/schemas/CollectionLinks'

    PensionPlanDocument:
      allOf:
        - $ref: '#/components/schemas/BasePlanDocument'
        - type: object
          properties:
            pensionSpecific:
              type: object
              properties:
                retirementAge:
                  type: integer
                  minimum: 55
                  maximum: 100
                crystallisationDate:
                  type: string
                  format: date
                  nullable: true
                taxFreeCashTaken:
                  $ref: '#/components/schemas/MoneyValue'
                taxFreeCashAvailable:
                  $ref: '#/components/schemas/MoneyValue'
                annualAllowance:
                  $ref: '#/components/schemas/MoneyValue'
                lifetimeAllowanceUsed:
                  type: number
                  format: decimal
                  minimum: 0
                  maximum: 100
                protectionType:
                  type: string
                  enum: [None, Enhanced, Primary, Fixed2012, Fixed2014, Fixed2016, Individual2014, Individual2016]
                  nullable: true
                protectionReference:
                  type: string
                  nullable: true
                transferValue:
                  $ref: '#/components/schemas/MoneyValue'
                projectedFundAtRetirement:
                  $ref: '#/components/schemas/MoneyValue'
                projectedIncomeAtRetirement:
                  $ref: '#/components/schemas/MoneyValue'
                employerContribution:
                  $ref: '#/components/schemas/ContributionValue'
                employeeContribution:
                  $ref: '#/components/schemas/ContributionValue'
                benefitType:
                  type: string
                  enum: [DefinedBenefit, DefinedContribution, Hybrid]
                schemeReference:
                  type: string
                  nullable: true
                  pattern: '^\d{8}[A-Z]{2}$'

    CreatePensionPlanRequest:
      type: object
      required:
        - planTypeId
        - providerId
        - policyNumber
        - startDate
        - owners
      properties:
        planTypeId:
          type: integer
          format: int32
          description: Must be a valid pension plan type
        providerId:
          type: integer
          format: int32
        policyNumber:
          type: string
          maxLength: 50
        startDate:
          type: string
          format: date
        maturityDate:
          type: string
          format: date
          nullable: true
        currentValue:
          $ref: '#/components/schemas/MoneyValue'
        regularContribution:
          $ref: '#/components/schemas/ContributionValue'
        owners:
          type: array
          minItems: 1
          items:
            type: object
            required:
              - partyId
              - ownershipPercentage
            properties:
              partyId:
                type: integer
                format: int32
              ownershipPercentage:
                type: number
                format: decimal
                minimum: 0
                maximum: 100
              salaryContributable:
                type: number
                format: decimal
                nullable: true
        pensionSpecific:
          type: object
          properties:
            retirementAge:
              type: integer
              minimum: 55
              maximum: 100
            employerContribution:
              $ref: '#/components/schemas/ContributionValue'
            employeeContribution:
              $ref: '#/components/schemas/ContributionValue'
            schemeReference:
              type: string
              nullable: true

    UpdatePensionPlanRequest:
      allOf:
        - $ref: '#/components/schemas/CreatePensionPlanRequest'
        - type: object
          required:
            - concurrencyId
          properties:
            concurrencyId:
              type: integer
              format: int32

    PensionSummary:
      type: object
      description: Aggregate statistics for the pension collection
      properties:
        totalPlans:
          type: integer
          example: 5
        totalValue:
          $ref: '#/components/schemas/MoneyValue'
        totalRegularContributions:
          $ref: '#/components/schemas/MoneyValue'
        projectedRetirementIncome:
          $ref: '#/components/schemas/MoneyValue'
        lifetimeAllowanceUsed:
          type: number
          format: decimal
          example: 45.3

    JsonPatchOperation:
      type: object
      required:
        - op
        - path
      properties:
        op:
          type: string
          enum: [add, remove, replace, move, copy, test]
        path:
          type: string
          pattern: '^/'
        value:
          description: Value for add/replace operations
        from:
          type: string
          pattern: '^/'
          description: Source path for move/copy operations

    PaginationInfo:
      type: object
      required:
        - limit
        - hasMore
      properties:
        limit:
          type: integer
          minimum: 1
          maximum: 100
        hasMore:
          type: boolean
        nextCursor:
          type: string
          nullable: true
        totalCount:
          type: integer
          nullable: true
          description: Total count if requested (expensive operation)

    CollectionLinks:
      type: object
      properties:
        self:
          $ref: '#/components/schemas/Link'
        next:
          $ref: '#/components/schemas/Link'
        client:
          $ref: '#/components/schemas/Link'

    ProblemDetails:
      type: object
      required:
        - type
        - title
        - status
      properties:
        type:
          type: string
          format: uri
          description: URI reference identifying the problem type
        title:
          type: string
          description: Short, human-readable summary
        status:
          type: integer
          description: HTTP status code
        detail:
          type: string
          description: Human-readable explanation
        instance:
          type: string
          format: uri
          description: URI reference identifying the specific occurrence
        traceId:
          type: string
          description: Unique trace identifier for debugging
        errors:
          type: object
          additionalProperties:
            type: array
            items:
              type: string
          description: Field-level validation errors

  responses:
    BadRequest:
      description: Bad Request - Invalid input
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetails'
          example:
            type: "https://api.factfind.example.com/problems/validation-error"
            title: "Validation Error"
            status: 400
            detail: "One or more validation errors occurred"
            instance: "/v3/clients/12345/plans/pensions"
            traceId: "00-4bf92f3577b34da6a3ce929d0e0e4736-00"
            errors:
              planTypeId: ["Plan type 999 is not a valid pension plan type"]
              startDate: ["Start date cannot be in the future"]

    Unauthorized:
      description: Unauthorized - Authentication required
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetails'

    Forbidden:
      description: Forbidden - Insufficient permissions
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetails'

    NotFound:
      description: Not Found - Resource does not exist
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetails'

    Conflict:
      description: Conflict - Concurrent modification detected
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetails'
          example:
            type: "https://api.factfind.example.com/problems/concurrency-conflict"
            title: "Concurrency Conflict"
            status: 409
            detail: "The plan has been modified by another user. Please refresh and try again."
            instance: "/v3/clients/12345/plans/pensions/67890"
            traceId: "00-4bf92f3577b34da6a3ce929d0e0e4736-00"
            currentETag: '"7"'
            providedETag: '"5"'

    UnprocessableEntity:
      description: Unprocessable Entity - Business rule violation
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetails'
          example:
            type: "https://api.factfind.example.com/problems/business-rule-violation"
            title: "Business Rule Violation"
            status: 422
            detail: "Total ownership percentage must equal 100%"
            instance: "/v3/clients/12345/plans/pensions/67890"
            traceId: "00-4bf92f3577b34da6a3ce929d0e0e4736-00"
            errors:
              owners: ["Total ownership is 75%, must be 100%"]

  examples:
    PensionPlanCollectionExample:
      summary: Collection of pension plans
      value:
        items:
          - planId: 67890
            clientId: 12345
            tenantId: 1
            policyNumber: "PP-123456"
            planType:
              planTypeId: 6
              name: "SIPP"
              category: "Pension"
            provider:
              providerId: 123
              name: "Aviva"
            status: "Active"
            startDate: "2015-04-06"
            currentValue:
              amount: 125000.50
              currency: "GBP"
            regularContribution:
              amount: 500.00
              currency: "GBP"
              frequency: "Monthly"
            pensionSpecific:
              retirementAge: 67
              benefitType: "DefinedContribution"
            concurrencyId: 5
            sequentialRef: "IOB00067890"
            _links:
              self:
                href: "/v3/clients/12345/plans/pensions/67890"
          - planId: 67891
            clientId: 12345
            policyNumber: "FS-789012"
            planType:
              planTypeId: 22
              name: "Final Salary Scheme"
              category: "Pension"
            provider:
              providerId: 456
              name: "Local Government Pension Scheme"
            status: "Active"
            startDate: "2000-01-15"
            pensionSpecific:
              retirementAge: 65
              benefitType: "DefinedBenefit"
              projectedIncomeAtRetirement:
                amount: 18000.00
                currency: "GBP"
            _links:
              self:
                href: "/v3/clients/12345/plans/pensions/67891"
        pagination:
          limit: 20
          hasMore: false
        summary:
          totalPlans: 2
          totalValue:
            amount: 125000.50
            currency: "GBP"
          totalRegularContributions:
            amount: 500.00
            currency: "GBP"
          projectedRetirementIncome:
            amount: 24000.00
            currency: "GBP"
        _links:
          self:
            href: "/v3/clients/12345/plans/pensions?limit=20"
          client:
            href: "/v3/clients/12345"

    SIPPPlanExample:
      summary: Detailed SIPP plan
      value:
        planId: 67890
        clientId: 12345
        tenantId: 1
        policyNumber: "SIPP-987654"
        planType:
          planTypeId: 6
          name: "SIPP"
          category: "Pension"
          discriminatorId: 1
        provider:
          providerId: 123
          name: "Aviva"
          regulatoryReference: "119790"
        status: "Active"
        startDate: "2015-04-06"
        maturityDate: "2042-04-06"
        baseCurrency: "GBP"
        currentValue:
          amount: 185750.25
          currency: "GBP"
        regularContribution:
          amount: 800.00
          currency: "GBP"
          frequency: "Monthly"
        adviser:
          practitionerId: 789
          name: "John Smith"
          firmName: "XYZ Financial Advisers Ltd"
        owners:
          - partyId: 12345
            ownerName: "Jane Doe"
            ownershipPercentage: 100.00
            salaryContributable: 50000.00
        valuations:
          - valuationDate: "2026-01-31"
            value:
              amount: 185750.25
              currency: "GBP"
            source: "Provider"
            fundBreakdown:
              - fundName: "Vanguard FTSE Global All Cap Index"
                fundCode: "VAN001"
                units: 1500.00
                unitPrice: 95.50
                value:
                  amount: 143250.00
                  currency: "GBP"
                percentage: 77.1
              - fundName: "Aviva Cash Fund"
                fundCode: "AVV999"
                value:
                  amount: 42500.25
                  currency: "GBP"
                percentage: 22.9
        pensionSpecific:
          retirementAge: 67
          taxFreeCashAvailable:
            amount: 46437.56
            currency: "GBP"
          annualAllowance:
            amount: 60000.00
            currency: "GBP"
          lifetimeAllowanceUsed: 17.2
          protectionType: "None"
          employerContribution:
            amount: 300.00
            currency: "GBP"
            frequency: "Monthly"
          employeeContribution:
            amount: 500.00
            currency: "GBP"
            frequency: "Monthly"
          benefitType: "DefinedContribution"
          projectedFundAtRetirement:
            amount: 525000.00
            currency: "GBP"
          projectedIncomeAtRetirement:
            amount: 21000.00
            currency: "GBP"
        concurrencyId: 12
        sequentialRef: "IOB00067890"
        createdAt: "2015-04-06T09:30:00Z"
        updatedAt: "2026-02-01T14:22:15Z"
        _links:
          self:
            href: "/v3/clients/12345/plans/pensions/67890"
          client:
            href: "/v3/clients/12345"
          provider:
            href: "/v3/reference/providers/123"
          valuations:
            href: "/v3/clients/12345/plans/pensions/67890/valuations"
          contributions:
            href: "/v3/clients/12345/plans/pensions/67890/contributions"
          withdrawals:
            href: "/v3/clients/12345/plans/pensions/67890/withdrawals"
          documents:
            href: "/v3/clients/12345/plans/pensions/67890/documents"

    CreateSIPPExample:
      summary: Create SIPP request
      value:
        planTypeId: 6
        providerId: 123
        policyNumber: "SIPP-NEW-001"
        startDate: "2026-04-06"
        currentValue:
          amount: 0.00
          currency: "GBP"
        regularContribution:
          amount: 1000.00
          currency: "GBP"
          frequency: "Monthly"
        owners:
          - partyId: 12345
            ownershipPercentage: 100.00
            salaryContributable: 60000.00
        pensionSpecific:
          retirementAge: 67
          employerContribution:
            amount: 400.00
            currency: "GBP"
            frequency: "Monthly"
          employeeContribution:
            amount: 600.00
            currency: "GBP"
            frequency: "Monthly"

    CreateFinalSalaryExample:
      summary: Create Final Salary scheme request
      value:
        planTypeId: 22
        providerId: 456
        policyNumber: "FS-NHS-12345"
        startDate: "2010-09-01"
        owners:
          - partyId: 12345
            ownershipPercentage: 100.00
            salaryContributable: 45000.00
        pensionSpecific:
          retirementAge: 65
          benefitType: "DefinedBenefit"
          schemeReference: "10012345AB"
          employeeContribution:
            amount: 225.00
            currency: "GBP"
            frequency: "Monthly"

security:
  - BearerAuth: []
```

---

## Protection API Family

### Overview

The Protection API manages life assurance, critical illness, income protection, and general insurance products.

**Plan Types Covered:** 412 distinct types
**Base Endpoint:** `/v3/clients/{clientId}/plans/protections`
**Discriminator Range:** RefPlanDiscriminatorId = 2 (ProtectionPlan)

**SCHEMA CORRECTION (February 12, 2026):** PolicyManagement schema analysis revealed the actual database structure:
- TProtection uses Class Table Inheritance (RefPlanSubCategoryId discriminator: 51=PersonalProtection, 47=GeneralInsurance)
- Benefits are linked through TAssuredLife intermediary entity (0-2 assured lives per policy)
- Each assured life can have 2 benefits (main + additional)
- Maximum 4 benefits per policy (2 lives × 2 benefits each)

See: `steering/Domain-Architecture/ERD-UPDATES-V2-PolicyManagement.md` for complete schema details.

**API Design Decision:** The V3 API simplifies this structure for client consumption by flattening TAssuredLife into an embedded `livesAssured` array. Benefits are returned as a separate collection linked to each assured life. This abstraction shields API consumers from database complexity while maintaining data integrity.

### Key Protection Plan Types

| Plan Type ID | Name | Type Category |
|--------------|------|---------------|
| 54 | Whole Of Life | Life Assurance |
| 55 | Term Protection | Life Assurance |
| 56 | Income Protection | Income Protection |
| 57 | Long Term Care | Care Insurance |
| 62 | Private Medical Insurance | Health Insurance |
| 63 | Group Private Medical Insurance | Group Health |
| 64 | Group Income Protection | Group Income Protection |
| 65 | Group Term Assurance | Group Life |
| 91 | Critical Illness | Critical Illness |
| 92 | Decreasing Term | Life Assurance |
| 94 | Family Income Benefit | Life Assurance |
| 99 | Building Insurance | General Insurance |
| 100 | Contents Insurance | General Insurance |
| 104 | Level Term | Life Assurance |
| 124 | Increasing Term | Life Assurance |
| 127 | Motor Insurance | General Insurance |
| 128 | Travel Insurance | General Insurance |

### Protection-Specific Fields

```yaml
ProtectionPlanDocument:
  allOf:
    - $ref: '#/components/schemas/BasePlanDocument'
    - type: object
      properties:
        protectionSpecific:
          type: object
          properties:
            protectionType:
              type: string
              enum: [Life, CriticalIllness, IncomeProtection, LongTermCare, PrivateMedical, General]
              description: High-level protection category
              example: Life
            sumAssured:
              $ref: '#/components/schemas/MoneyValue'
            benefitAmount:
              $ref: '#/components/schemas/MoneyValue'
            benefitFrequency:
              type: string
              enum: [Lumpsum, Monthly, Annual]
              nullable: true
              example: Lumpsum
            termYears:
              type: integer
              minimum: 1
              maximum: 50
              description: Policy term in years
              example: 25
            termRemainingYears:
              type: integer
              readOnly: true
              description: Calculated remaining term
              example: 18
            endDate:
              type: string
              format: date
              description: Policy end/maturity date
              example: "2051-04-06"
            isInForce:
              type: boolean
              description: Whether policy is currently active
              example: true
            isIndexLinked:
              type: boolean
              description: Whether benefits increase with inflation
              example: true
            indexRate:
              type: number
              format: decimal
              nullable: true
              minimum: 0
              maximum: 10
              description: Annual increase percentage
              example: 2.5
            isOnClaim:
              type: boolean
              description: Whether a claim is currently active
              example: false
            claimDetails:
              type: object
              nullable: true
              properties:
                claimDate:
                  type: string
                  format: date
                claimAmount:
                  $ref: '#/components/schemas/MoneyValue'
                claimStatus:
                  type: string
                  enum: [Pending, Approved, Declined, InProgress]
            livesAssured:
              type: array
              maxItems: 2
              description: Assured lives on the policy (maximum 2)
              items:
                type: object
                required:
                  - assuredLifeId
                  - partyId
                properties:
                  assuredLifeId:
                    type: integer
                    format: int64
                    description: Unique identifier for this assured life (maps to TAssuredLife.AssuredLifeId)
                    readOnly: true
                  partyId:
                    type: integer
                    format: int32
                    description: CRM Contact ID of the insured person
                  name:
                    type: string
                    readOnly: true
                    description: Full name of insured person (denormalized from CRM)
                  relationship:
                    type: string
                    enum: [Self, Spouse, Partner, Child, Parent, Other]
                  dateOfBirth:
                    type: string
                    format: date
                  gender:
                    type: string
                    enum: [Male, Female, Other]
                  isSmoker:
                    type: boolean
                  healthRating:
                    type: string
                    enum: [Standard, Preferred, Rated, Declined]
                  orderKey:
                    type: integer
                    enum: [1, 2]
                    description: Assured life ordering (1=primary, 2=secondary)
                  benefits:
                    type: array
                    maxItems: 2
                    description: Benefits for this assured life (main + additional)
                    items:
                      type: object
                      properties:
                        benefitId:
                          type: integer
                          format: int64
                        benefitType:
                          type: string
                          enum: [Main, Additional]
                        benefitAmount:
                          $ref: '#/components/schemas/MoneyValue'
                        splitBenefitAmount:
                          $ref: '#/components/schemas/MoneyValue'
                        deferredPeriodDays:
                          type: integer
                        frequency:
                          type: string
                        isPremiumWaiver:
                          type: boolean
                        isRated:
                          type: boolean
            beneficiaries:
              type: array
              items:
                type: object
                properties:
                  name:
                    type: string
                  relationship:
                    type: string
                  percentage:
                    type: number
                    format: decimal
                    minimum: 0
                    maximum: 100
            writtenInTrust:
              type: boolean
              description: Whether policy is written in trust
              example: true
            trustDetails:
              type: object
              nullable: true
              properties:
                trustType:
                  type: string
                  enum: [Discretionary, Absolute, FlexibleReversionary]
                trustees:
                  type: array
                  items:
                    type: string
            underwritingType:
              type: string
              enum: [FullMedical, MoratoriumBased, MedicalHistoryDisregarded, Guaranteed]
              nullable: true
              example: FullMedical
            loadingPercentage:
              type: number
              format: decimal
              nullable: true
              description: Premium loading for health conditions
              example: 25.0
            exclusions:
              type: array
              items:
                type: string
              description: Medical conditions or activities excluded
              example: ["Pre-existing back condition", "Hazardous sports"]
            deferredPeriodWeeks:
              type: integer
              nullable: true
              minimum: 0
              description: For income protection, weeks before benefit starts
              example: 13
            benefitCeasesAt:
              type: integer
              nullable: true
              description: Age at which benefit ceases
              example: 65
```

---

## Investments API Family

### Overview

The Investments API manages ISAs, bonds, unit trusts, wrap accounts, and general investment accounts.

**Plan Types Covered:** 523 distinct types
**Base Endpoint:** `/v3/clients/{clientId}/plans/investments`
**Discriminator Range:** RefPlanDiscriminatorId = 1 (AssetPlan - Investment subtypes)

### Key Investment Plan Types

| Plan Type ID | Name | Category |
|--------------|------|----------|
| 1 | ISA Maxi | ISA |
| 31 | Unit Trust/OEIC | Unit Trusts |
| 32 | Investment Trust | Investment Trusts |
| 33 | Insurance/Investment Bond | Bonds |
| 34 | National Savings | Savings |
| 141 | ISA Stocks & Shares | ISA |
| 142 | ISA Cash | ISA |
| 143 | Wrap | Platform |
| 144 | General Investment Account | GIA |
| 1019 | Onshore Bond | Bonds |
| 1020 | Offshore Bond | Bonds |

### Investment-Specific Fields

```yaml
InvestmentPlanDocument:
  allOf:
    - $ref: '#/components/schemas/BasePlanDocument'
    - type: object
      properties:
        investmentSpecific:
          type: object
          properties:
            investmentType:
              type: string
              enum: [ISA, Bond, UnitTrust, InvestmentTrust, Wrap, GIA, NationalSavings, OEIC]
              example: ISA
            platformName:
              type: string
              nullable: true
              description: For wrap/platform accounts
              example: "Aviva Platform"
            isaType:
              type: string
              enum: [StocksShares, Cash, Lifetime, InnovativeFinance]
              nullable: true
              description: Type of ISA if applicable
              example: StocksShares
            isaAllowanceUsed:
              $ref: '#/components/schemas/MoneyValue'
            taxYear:
              type: string
              pattern: '^\d{4}-\d{4}$'
              description: Tax year in format YYYY-YYYY
              example: "2025-2026"
            bondType:
              type: string
              enum: [Onshore, Offshore]
              nullable: true
              example: Onshore
            numberOfLives:
              type: integer
              minimum: 1
              maximum: 4
              nullable: true
              description: Number of lives assured (for bonds)
            bondSegments:
              type: integer
              nullable: true
              description: Number of 5% segments available
              example: 20
            surrenderPenalty:
              type: object
              nullable: true
              properties:
                penaltyPercentage:
                  type: number
                  format: decimal
                penaltyEndsDate:
                  type: string
                  format: date
            assetAllocation:
              type: object
              properties:
                equities:
                  type: number
                  format: decimal
                  minimum: 0
                  maximum: 100
                  example: 65.0
                bonds:
                  type: number
                  format: decimal
                  minimum: 0
                  maximum: 100
                  example: 20.0
                property:
                  type: number
                  format: decimal
                  minimum: 0
                  maximum: 100
                  example: 10.0
                cash:
                  type: number
                  format: decimal
                  minimum: 0
                  maximum: 100
                  example: 5.0
                alternatives:
                  type: number
                  format: decimal
                  minimum: 0
                  maximum: 100
                  example: 0.0
            managementStyle:
              type: string
              enum: [Discretionary, Advisory, ExecutionOnly]
              example: Discretionary
            modelPortfolio:
              type: string
              nullable: true
              description: Name of model portfolio if applicable
              example: "Balanced Growth Portfolio"
            riskRating:
              type: integer
              minimum: 1
              maximum: 10
              nullable: true
              description: Investment risk rating
              example: 6
            ongoingCharges:
              type: number
              format: decimal
              nullable: true
              description: OCF/TER percentage per annum
              example: 0.75
            platformFee:
              type: number
              format: decimal
              nullable: true
              description: Platform fee percentage per annum
              example: 0.25
            adviserFee:
              type: number
              format: decimal
              nullable: true
              description: Adviser fee percentage per annum
              example: 0.50
```

---

## Savings, Mortgages, and Liabilities API Families

Due to length constraints, the following sections provide condensed specifications. The pattern is identical to Pensions, Protection, and Investments above.

### Savings API

**Endpoint:** `/v3/clients/{clientId}/plans/savings`
**Plan Types:** 89 types (Cash Deposits, Savings Accounts, Current Accounts)

**Savings-Specific Fields:**
```yaml
savingsSpecific:
  accountType: [Instant, Notice, Fixed, Regular]
  interestRate: decimal
  grossInterestRate: decimal
  netInterestRate: decimal
  accountNumber: string
  sortCode: string
  noticePeriodDays: integer
  fixedTermMonths: integer
  fixedTermEndsDate: date
  penaltyForEarlyWithdrawal: MoneyValue
```

### Mortgages API

**Endpoint:** `/v3/clients/{clientId}/plans/mortgages`
**Plan Types:** 318 types (Residential, Buy-to-Let, Remortgage, Commercial, Equity Release)

**Mortgage-Specific Fields:**
```yaml
mortgageSpecific:
  propertyValue: MoneyValue
  loanAmount: MoneyValue
  loanToValue: decimal
  interestRate: decimal
  interestRateType: [Fixed, Variable, Tracker, Discount]
  fixedRateEndsDate: date
  standardVariableRate: decimal
  mortgageTerm: integer
  termRemainingMonths: integer
  repaymentMethod: [Repayment, InterestOnly, PartAndPart]
  monthlyPayment: MoneyValue
  currentBalance: MoneyValue
  completionDate: date
  property:
    addressId: integer
    address: AddressValue
    propertyType: [Detached, SemiDetached, Terraced, Flat, Bungalow]
    tenure: [Freehold, Leasehold]
  borrowers:
    - partyId: integer
      borrowerType: [SoleOwner, JointTenants, TenantsInCommon]
      ownershipPercentage: decimal
  mortgageType: [Residential, BuyToLet, SecondHome, HolidayLet]
  productType: [Standard, FirstTimeBuyer, SharedOwnership]
  earlyRepaymentCharges:
    hasERC: boolean
    ercPercentage: decimal
    ercEndsDate: date
```

### Loans API

**Endpoint:** `/v3/clients/{clientId}/plans/loans`
**Plan Types:** 67 types (Personal Loans, Secured Loans, Bridging Loans)

**Loan-Specific Fields:**
```yaml
loanSpecific:
  loanType: [Personal, Secured, Unsecured, Bridging, Commercial, StudentLoan]
  loanAmount: MoneyValue
  outstandingBalance: MoneyValue
  interestRate: decimal
  loanTerm: integer
  termRemainingMonths: integer
  monthlyPayment: MoneyValue
  isConsolidated: boolean
  isToBeRepaid: boolean
  repaymentPlan: string
  securedAgainst:
    propertyId: integer
    securityValue: MoneyValue
  purposeOfLoan: string
  loanAccount: string
```

### Credit Cards API

**Endpoint:** `/v3/clients/{clientId}/plans/creditcards`
**Plan Types:** 21 types

**Credit Card-Specific Fields:**
```yaml
creditCardSpecific:
  creditLimit: MoneyValue
  currentBalance: MoneyValue
  availableCredit: MoneyValue
  interestRate: decimal
  introductoryRate: decimal
  introRateEndsDate: date
  minimumPayment: MoneyValue
  lastStatementBalance: MoneyValue
  lastStatementDate: date
  cardNumber: string (masked)
  isRewardCard: boolean
  rewardScheme: string
```

---

## Reference Data APIs

### Plan Types Reference Data

```yaml
openapi: 3.1.0
info:
  title: Plan Types Reference Data API
  version: 3.0.0

paths:
  /v3/reference/plan-types:
    get:
      operationId: listPlanTypes
      summary: List all available plan types
      parameters:
        - name: category
          in: query
          schema:
            type: string
            enum: [Pension, Protection, Investment, Savings, Mortgage, Liability]
        - name: isArchived
          in: query
          schema:
            type: boolean
            default: false
        - name: regionCode
          in: query
          schema:
            type: string
            pattern: '^[A-Z]{2}$'
            default: GB
      responses:
        '200':
          description: List of plan types
          content:
            application/json:
              schema:
                type: object
                properties:
                  items:
                    type: array
                    items:
                      $ref: '#/components/schemas/PlanTypeDetail'
                  _links:
                    type: object

components:
  schemas:
    PlanTypeDetail:
      type: object
      properties:
        planTypeId:
          type: integer
          format: int32
          description: RefPlanType2ProdSubTypeId
        name:
          type: string
        description:
          type: string
        category:
          type: string
          enum: [Pension, Protection, Investment, Savings, Mortgage, Liability]
        portfolioCategory:
          type: string
        discriminatorId:
          type: integer
          format: int32
        defaultCategory:
          type: string
        isArchived:
          type: boolean
        regionCode:
          type: string
        requiredFields:
          type: array
          items:
            type: string
          description: List of required field names for this plan type
        optionalFields:
          type: array
          items:
            type: string
```

### Providers Reference Data

```yaml
paths:
  /v3/reference/providers:
    get:
      operationId: listProviders
      summary: List financial product providers
      parameters:
        - name: planType
          in: query
          description: Filter providers by plan type they support
          schema:
            type: integer
            format: int32
        - name: search
          in: query
          description: Search provider name
          schema:
            type: string
      responses:
        '200':
          content:
            application/json:
              schema:
                type: object
                properties:
                  items:
                    type: array
                    items:
                      $ref: '#/components/schemas/ProviderDetail'

components:
  schemas:
    ProviderDetail:
      type: object
      properties:
        providerId:
          type: integer
        name:
          type: string
        tradingNames:
          type: array
          items:
            type: string
        regulatoryReference:
          type: string
          description: FCA firm reference number
        status:
          type: string
          enum: [Active, Inactive, Acquired]
        websiteUrl:
          type: string
          format: uri
        contactDetails:
          type: object
        supportedPlanTypes:
          type: array
          items:
            type: integer
          description: Plan type IDs this provider supports
```

---

## Discriminator Pattern Documentation

### Overview

The Plans API uses OpenAPI 3.1 discriminator mappings to implement polymorphic plan types. This provides:

1. **Type Safety**: Clients can validate requests against specific plan type schemas
2. **Code Generation**: OpenAPI generators create type-safe client SDKs
3. **Runtime Routing**: API Gateway routes requests to correct handler based on discriminator
4. **Extensibility**: New plan types added without breaking existing clients

### Discriminator Hierarchy

```yaml
components:
  schemas:
    PlanDocument:
      oneOf:
        - $ref: '#/components/schemas/PensionPlanDocument'
        - $ref: '#/components/schemas/ProtectionPlanDocument'
        - $ref: '#/components/schemas/InvestmentPlanDocument'
        - $ref: '#/components/schemas/SavingsPlanDocument'
        - $ref: '#/components/schemas/MortgagePlanDocument'
        - $ref: '#/components/schemas/LoanPlanDocument'
        - $ref: '#/components/schemas/CreditCardPlanDocument'
      discriminator:
        propertyName: planType/category
        mapping:
          Pension: '#/components/schemas/PensionPlanDocument'
          Protection: '#/components/schemas/ProtectionPlanDocument'
          Investment: '#/components/schemas/InvestmentPlanDocument'
          Savings: '#/components/schemas/SavingsPlanDocument'
          Mortgage: '#/components/schemas/MortgagePlanDocument'
          Loan: '#/components/schemas/LoanPlanDocument'
          CreditCard: '#/components/schemas/CreditCardPlanDocument'
```

### Discriminator Routing Logic

```
Client Request → API Gateway
                     ↓
            Extract planType.category
                     ↓
         ┌───────────┴───────────┐
         ↓                       ↓
    category = "Pension"   category = "Protection"
         ↓                       ↓
PensionPlanController    ProtectionPlanController
         ↓                       ↓
    Validate against         Validate against
    PensionPlanDocument      ProtectionPlanDocument
         ↓                       ↓
    Query TPolicyBusiness    Query TPolicyBusiness
    WHERE RefPlanTypeId      WHERE RefPlanTypeId
          IN (pension types)      IN (protection types)
```

### 1,773 Plan Type Organization

The plan types are organized hierarchically:

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
├── Pensions
│   ├── SIPP variants (45 types)
│   ├── Personal Pension variants (67 types)
│   ├── Occupational Pension variants (89 types)
│   ├── Annuity variants (52 types)
│   └── Other pension types (34 types)

Level 3: Specific Product Variants
├── Personal Pension Plan (planTypeId: 8)
│   ├── Standard Personal Pension
│   ├── Stakeholder Personal Pension
│   ├── Group Personal Pension
│   └── Executive Personal Pension
```

### Plan Type Catalog (Excerpt - 50 of 1,773)

| ID | Name | Category | Discriminator | Subcategory |
|----|------|----------|---------------|-------------|
| 1 | ISA Maxi | Investment | 1 | ISA |
| 6 | SIPP | Pension | 1 | SIPP |
| 8 | Personal Pension Plan | Pension | 1 | Personal Pension |
| 10 | Stakeholder Individual | Pension | 1 | Stakeholder |
| 11 | Executive Pension Plan | Pension | 1 | Executive Pension |
| 12 | SSAS | Pension | 1 | SSAS |
| 13 | s32 Buyout Bond | Pension | 1 | Buyout |
| 15 | Group Personal Pension | Pension | 1 | Group Pension |
| 22 | Final Salary Scheme | Pension | 1 | Defined Benefit |
| 28 | Pension Annuity | Pension | 1 | Annuity |
| 30 | Cash Deposit | Savings | 1 | Cash |
| 31 | Unit Trust/OEIC | Investment | 1 | Unit Trust |
| 32 | Investment Trust | Investment | 1 | Investment Trust |
| 33 | Insurance/Investment Bond | Investment | 1 | Bond |
| 34 | National Savings | Savings | 1 | National Savings |
| 54 | Whole Of Life | Protection | 2 | Life Assurance |
| 55 | Term Protection | Protection | 2 | Life Assurance |
| 56 | Income Protection | Protection | 2 | Income Protection |
| 57 | Long Term Care | Protection | 2 | Care |
| 62 | Private Medical Insurance | Protection | 2 | Medical |
| 67 | Mortgage | Mortgage | 3 | Mortgage |
| 68 | Equity Release | Mortgage | 4 | Equity Release |
| 76 | Money Purchase Contracted | Pension | 1 | Money Purchase |
| 79 | Savings Account | Savings | 1 | Savings |
| 87 | Personal Loan | Loan | 5 | Loan |
| 91 | Critical Illness | Protection | 2 | Critical Illness |
| 92 | Decreasing Term | Protection | 2 | Life Assurance |
| 94 | Family Income Benefit | Protection | 2 | Life Assurance |
| 99 | Building Insurance | Protection | 2 | General Insurance |
| 100 | Contents Insurance | Protection | 2 | General Insurance |
| 104 | Level Term | Protection | 2 | Life Assurance |
| 106 | CIMP | Pension | 1 | Money Purchase |
| 107 | COMP | Pension | 1 | Money Purchase |
| 108 | Bridging Loan | Loan | 5 | Bridging |
| 121 | Commercial Finance | Loan | 5 | Commercial |
| 124 | Increasing Term | Protection | 2 | Life Assurance |
| 125 | Cash Account | Savings | 1 | Current Account |
| 127 | Motor Insurance | Protection | 2 | General Insurance |
| 128 | Travel Insurance | Protection | 2 | General Insurance |
| 136 | Unsecured Loan | Loan | 5 | Unsecured |
| 137 | Secured Loan | Loan | 5 | Secured |
| 141 | ISA Stocks & Shares | Investment | 1 | ISA |
| 142 | ISA Cash | Savings | 1 | ISA |
| 143 | Wrap | Investment | 1 | Platform |
| 144 | General Investment Account | Investment | 1 | GIA |
| 145 | QROPS | Pension | 1 | Overseas Pension |
| 148 | Full Status | Mortgage | 3 | Mortgage |
| 150 | Self-Cert | Mortgage | 3 | Mortgage |
| 151 | Buy-to-Let | Mortgage | 3 | Mortgage |
| 154 | Second Charge | Mortgage | 3 | Mortgage |

**Complete catalog available in:** `TRefPlanType2ProdSubType` database table

---

## Integration with FactFind Sections

### Mapping: FactFind Sections → Plans API Endpoints

| FactFind Section | Plans API Endpoint | Plan Types | User Journey |
|------------------|-------------------|------------|--------------|
| Pensions & Retirement | `/plans/pensions` | SIPP, Personal Pension, Final Salary | Retirement planning |
| Annuities | `/plans/pensions` | Pension Annuity, Enhanced Annuity | Retirement income |
| Money Purchase | `/plans/pensions` | Money Purchase, CIMP, COMP | Defined contribution pensions |
| State Pension | `/plans/pensions` | State Pension records | Basic retirement provision |
| Protection (Existing) | `/plans/protections` | Life, CI, IP, Whole of Life, Term | Protection needs |
| General Insurance | `/plans/protections` | Building, Contents, Motor, Travel, PMI | General insurance review |
| Investments (Existing) | `/plans/investments` | ISA, Bonds, Unit Trusts, Wrap, GIA | Investment portfolio |
| Savings (Cash) | `/plans/savings` | Cash Deposit, Savings Account, ISA Cash | Cash holdings |
| Mortgages | `/plans/mortgages` | All mortgage types | Mortgage review |
| Equity Release | `/plans/mortgages` | Equity Release, Lifetime Mortgage | Later life borrowing |
| Loans | `/plans/loans` | Personal Loan, Bridging, Secured/Unsecured | Liability review |
| Credit Cards | `/plans/creditcards` | Credit card accounts | Unsecured debt |

### Query Patterns for FactFind Display

```http
# Get all client plans across all types
GET /v3/clients/{clientId}/plans/pensions
GET /v3/clients/{clientId}/plans/protections
GET /v3/clients/{clientId}/plans/investments
GET /v3/clients/{clientId}/plans/savings
GET /v3/clients/{clientId}/plans/mortgages
GET /v3/clients/{clientId}/plans/loans
GET /v3/clients/{clientId}/plans/creditcards

# Filter to active plans only
GET /v3/clients/{clientId}/plans/pensions?filter=status eq 'Active'

# Get high-level summary (sparse fieldsets)
GET /v3/clients/{clientId}/plans/pensions?select=planId,policyNumber,planType/name,currentValue

# Get plans by specific type
GET /v3/clients/{clientId}/plans/pensions?filter=planType/planTypeId eq 6

# Sort by value descending
GET /v3/clients/{clientId}/plans/investments?orderBy=currentValue/amount desc
```

---

## Usage Examples

### Example 1: Creating a SIPP

```http
POST /v3/clients/12345/plans/pensions HTTP/1.1
Host: api.factfind.example.com
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
Content-Type: application/json
X-Tenant-Id: 1

{
  "planTypeId": 6,
  "providerId": 123,
  "policyNumber": "SIPP-2026-001",
  "startDate": "2026-04-06",
  "currentValue": {
    "amount": 0.00,
    "currency": "GBP"
  },
  "regularContribution": {
    "amount": 1000.00,
    "currency": "GBP",
    "frequency": "Monthly"
  },
  "owners": [
    {
      "partyId": 12345,
      "ownershipPercentage": 100.00,
      "salaryContributable": 60000.00
    }
  ],
  "pensionSpecific": {
    "retirementAge": 67,
    "employerContribution": {
      "amount": 400.00,
      "currency": "GBP",
      "frequency": "Monthly"
    },
    "employeeContribution": {
      "amount": 600.00,
      "currency": "GBP",
      "frequency": "Monthly"
    }
  }
}

Response:
HTTP/1.1 201 Created
Location: /v3/clients/12345/plans/pensions/67890
ETag: "1"
Content-Type: application/json

{
  "planId": 67890,
  "clientId": 12345,
  "planType": {
    "planTypeId": 6,
    "name": "SIPP",
    "category": "Pension"
  },
  "provider": {
    "providerId": 123,
    "name": "Aviva"
  },
  "status": "PendingActivation",
  "policyNumber": "SIPP-2026-001",
  "startDate": "2026-04-06",
  "currentValue": {
    "amount": 0.00,
    "currency": "GBP"
  },
  "regularContribution": {
    "amount": 1000.00,
    "currency": "GBP",
    "frequency": "Monthly"
  },
  "pensionSpecific": {
    "retirementAge": 67,
    "employerContribution": {
      "amount": 400.00,
      "currency": "GBP",
      "frequency": "Monthly"
    },
    "employeeContribution": {
      "amount": 600.00,
      "currency": "GBP",
      "frequency": "Monthly"
    },
    "benefitType": "DefinedContribution"
  },
  "concurrencyId": 1,
  "sequentialRef": "IOB00067890",
  "createdAt": "2026-02-12T10:30:00Z",
  "updatedAt": "2026-02-12T10:30:00Z",
  "_links": {
    "self": {
      "href": "/v3/clients/12345/plans/pensions/67890"
    },
    "client": {
      "href": "/v3/clients/12345"
    },
    "provider": {
      "href": "/v3/reference/providers/123"
    }
  }
}
```

### Example 2: Updating Plan Value with PATCH

```http
PATCH /v3/clients/12345/plans/pensions/67890 HTTP/1.1
Host: api.factfind.example.com
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
Content-Type: application/json-patch+json
If-Match: "5"
X-Tenant-Id: 1

[
  {
    "op": "replace",
    "path": "/currentValue/amount",
    "value": 135000.00
  },
  {
    "op": "replace",
    "path": "/status",
    "value": "Active"
  }
]

Response:
HTTP/1.1 200 OK
ETag: "6"
Content-Type: application/json

{
  "planId": 67890,
  "currentValue": {
    "amount": 135000.00,
    "currency": "GBP"
  },
  "status": "Active",
  "concurrencyId": 6,
  ...
}
```

### Example 3: Querying All Plans for Client (Portfolio View)

```javascript
// TypeScript/JavaScript example using fetch API
async function getClientPortfolio(clientId) {
  const token = await getAuthToken();
  const endpoints = [
    'pensions',
    'protections',
    'investments',
    'savings',
    'mortgages',
    'loans',
    'creditcards'
  ];

  const requests = endpoints.map(endpoint =>
    fetch(`https://api.factfind.example.com/v3/clients/${clientId}/plans/${endpoint}`, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'X-Tenant-Id': '1'
      }
    }).then(r => r.json())
  );

  const results = await Promise.all(requests);

  return {
    pensions: results[0].items,
    protections: results[1].items,
    investments: results[2].items,
    savings: results[3].items,
    mortgages: results[4].items,
    loans: results[5].items,
    creditcards: results[6].items,
    totalValue: calculateTotalValue(results)
  };
}
```

### Example 4: Creating Mortgage with Property Details

```http
POST /v3/clients/12345/plans/mortgages HTTP/1.1
Content-Type: application/json

{
  "planTypeId": 1088,
  "providerId": 789,
  "policyNumber": "MTG-2026-12345",
  "startDate": "2026-03-01",
  "maturityDate": "2051-03-01",
  "owners": [
    {
      "partyId": 12345,
      "ownershipPercentage": 50.00
    },
    {
      "partyId": 12346,
      "ownershipPercentage": 50.00
    }
  ],
  "mortgageSpecific": {
    "propertyValue": {
      "amount": 350000.00,
      "currency": "GBP"
    },
    "loanAmount": {
      "amount": 280000.00,
      "currency": "GBP"
    },
    "loanToValue": 80.0,
    "interestRate": 3.75,
    "interestRateType": "Fixed",
    "fixedRateEndsDate": "2031-03-01",
    "mortgageTerm": 25,
    "repaymentMethod": "Repayment",
    "monthlyPayment": {
      "amount": 1425.00,
      "currency": "GBP"
    },
    "completionDate": "2026-03-01",
    "property": {
      "address": {
        "line1": "123 Example Street",
        "town": "London",
        "postcode": "SW1A 1AA",
        "country": "GB"
      },
      "propertyType": "SemiDetached",
      "tenure": "Freehold"
    },
    "borrowers": [
      {
        "partyId": 12345,
        "borrowerType": "JointTenants",
        "ownershipPercentage": 50.00
      },
      {
        "partyId": 12346,
        "borrowerType": "JointTenants",
        "ownershipPercentage": 50.00
      }
    ],
    "mortgageType": "Residential",
    "earlyRepaymentCharges": {
      "hasERC": true,
      "ercPercentage": 2.5,
      "ercEndsDate": "2031-03-01"
    }
  }
}
```

---

## Implementation Guidelines

### For Backend Developers

1. **Preserve Existing Logic**: V3 is an enhancement layer over existing controllers
2. **Add OpenAPI Annotations**: Annotate existing controllers with OpenAPI/Swagger attributes
3. **Implement RFC 7807**: Standardize error responses to Problem Details format
4. **Add Pagination**: Implement cursor-based pagination for collection endpoints
5. **Add Filtering**: Support OData-style filter expressions
6. **ETags**: Ensure ETag headers are generated and validated
7. **HATEOAS Links**: Add _links to all response documents
8. **Validation**: Use JSON Schema validation from OpenAPI specs
9. **Discriminator Routing**: Ensure planType.category correctly routes to handlers

### For Frontend Developers

1. **Use OpenAPI Clients**: Generate type-safe clients from OpenAPI specs
2. **Handle Pagination**: Implement cursor-based pagination UI
3. **Display Links**: Use HATEOAS links for navigation
4. **Optimistic Concurrency**: Always send If-Match headers on updates
5. **Error Handling**: Parse RFC 7807 Problem Details for field-level errors
6. **Sparse Fieldsets**: Use select parameter to reduce payload size
7. **Caching**: Respect ETag and Last-Modified headers
8. **Filtering**: Provide UI for OData-style filters

### For API Consumers

1. **Authentication**: Always include valid Bearer token
2. **Tenant Context**: Include X-Tenant-Id header
3. **Idempotency**: Use idempotency keys for POST operations if needed
4. **Rate Limiting**: Respect X-Rate-Limit headers
5. **Versioning**: Use /v3 endpoints for new integrations
6. **Discriminators**: Validate plan type against category before creating
7. **Concurrency**: Handle 409 Conflict responses gracefully

---

## Migration from V1 to V3

### Breaking Changes

1. **URL Structure**: `/v1/clients/{id}/plans/...` → `/v3/clients/{id}/plans/...`
2. **Error Format**: Custom errors → RFC 7807 Problem Details
3. **Pagination**: Offset/limit → Cursor-based
4. **Response Wrapper**: Removed wrapper, direct document return
5. **Date Format**: ISO 8601 with timezone always included

### Non-Breaking Enhancements

1. **Additional Fields**: New optional fields added
2. **Additional Query Parameters**: filter, orderBy, select
3. **Additional Response Headers**: ETag, Last-Modified, Link
4. **Additional Status Codes**: 422 for business rule violations

### Migration Strategy

**Phase 1: Parallel Running (3 months)**
- Both V1 and V3 APIs available
- V3 reads/writes to same database tables
- Feature parity testing

**Phase 2: Migration (6 months)**
- Client applications migrate to V3
- V1 marked deprecated
- Migration guides provided

**Phase 3: V1 Sunset (12 months)**
- V1 endpoints return 410 Gone
- All traffic on V3

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 3.0 | 2026-02-12 | API Architecture Team | Initial V3 specification |

---

## Appendices

### Appendix A: Complete Plan Type Catalog

**Location**: Database table `TRefPlanType2ProdSubType`
**Query**: `SELECT * FROM TRefPlanType2ProdSubType WHERE IsArchived = 0 ORDER BY RefPortfolioCategoryId, RefPlanTypeId`

### Appendix B: Provider Catalog

**Location**: Database table `TProvider`
**Active Providers**: 450+ providers
**Major Providers**: Aviva, Legal & General, Scottish Widows, Aegon, Standard Life, etc.

### Appendix C: Validation Rules

**Cross-Field Validations**:
- Total ownership percentage must equal 100%
- Plan start date cannot be in future (except new business)
- Maturity date must be after start date
- Regular contribution frequency must align with plan type
- Pension retirement age must be >= 55 (current legislation)
- Mortgage LTV cannot exceed 100%

### Appendix D: Performance Characteristics

**Expected Response Times** (95th percentile):
- Single plan GET: <100ms
- Collection GET (20 items): <200ms
- Plan POST: <300ms
- Plan PUT: <250ms
- Plan PATCH: <200ms

**Rate Limits**:
- 1000 requests per minute per client
- 10,000 requests per minute per tenant
- Burst allowance: 2x for 30 seconds

---

**END OF DOCUMENT**
