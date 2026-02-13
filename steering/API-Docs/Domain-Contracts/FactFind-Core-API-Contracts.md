# V3 API Contracts: FactFind Core Domain
## Employment, Income, Budget, Assets, Liabilities & Notes

**Document Version:** 1.0
**Date:** 2026-02-12
**Status:** Design Specification
**API Version:** v3
**Base URL:** `https://api.intelliflo.com/v3`
**Bounded Contexts:** 5 Core Domains

---

## Executive Summary

This document specifies V3 API contracts for FactFind Core financial profile sections, building on the excellent existing V2 coverage while addressing identified gaps and standardizing patterns.

### Strategic Context

**V4 Coverage Discovery:**
- Employment & Income: **100% coverage** (Gold Standard)
- Budget & Expenditure: **100% coverage**
- Assets & Liabilities: **89% coverage** (missing direct Asset API)
- Notes API: **100% coverage** via unified discriminator pattern
- Plans API: **100% coverage** for liabilities via Portfolio

**V3 Strategy:**
1. **Preserve and enhance** existing Employment & Income v2 APIs (gold standard)
2. **Extend** unified Notes API discriminator pattern
3. **Build** missing Asset API (only major gap)
4. **Integrate** with Portfolio Plans API for liabilities
5. **Standardize** patterns across all core APIs

### Design Principles

1. **Single Contract Pattern** - One schema for requests and responses
2. **Read-Only Fields** - Server-generated fields marked `readOnly: true`
3. **Polymorphic Types** - Discriminator-based type hierarchies
4. **HATEOAS Level 3** - Hypermedia controls for navigation
5. **Domain-Driven Design** - Clear bounded context separation
6. **Event-Driven** - State changes publish domain events
7. **OpenAPI 3.1** - Complete specification compliance

---

## Table of Contents

1. [API Families Overview](#1-api-families-overview)
2. [Employment Family](#2-employment-family)
3. [Income Family](#3-income-family)
4. [Budget Family](#4-budget-family)
5. [Assets Family](#5-assets-family)
6. [Liabilities Family](#6-liabilities-family)
7. [Notes Family](#7-notes-family)
8. [Common Patterns](#8-common-patterns)
9. [Reference Data](#9-reference-data)
10. [Integration Patterns](#10-integration-patterns)

---

## 1. API Families Overview

### 1.1 Bounded Contexts

```
FactFind Core Domain
├── Employment & Income Context
│   ├── Employments API (v2 gold standard - enhance)
│   ├── Incomes API (v2 gold standard - enhance)
│   └── Employment History API (new)
│
├── Budget & Expenditure Context
│   ├── Budgets API (v1 - enhance)
│   ├── Expenditures API (v2 - enhance)
│   ├── Expenses API (v2 - enhance)
│   └── Affordability API (new - gap fill)
│
├── Assets Context
│   ├── Assets API (new - major gap)
│   └── Properties API (new - major gap)
│
├── Liabilities Context
│   ├── Liabilities API (v1 - enhance)
│   └── Portfolio Plans Integration (existing)
│
└── Cross-Cutting
    ├── Notes API (v2 discriminator - extend)
    └── Reference Data API (v2 - standardize)
```

### 1.2 API Endpoint Summary

| Family | Base Path | Endpoints | Status |
|--------|-----------|-----------|--------|
| **Employment** | `/v3/clients/{clientId}/employments` | 6 | Enhance V2 |
| **Income** | `/v3/clients/{clientId}/incomes` | 7 | Enhance V2 |
| **Budget** | `/v3/clients/{clientId}/budgets` | 5 | Enhance V1 |
| **Expenditure** | `/v3/clients/{clientId}/expenditures` | 6 | Enhance V2 |
| **Assets** | `/v3/clients/{clientId}/assets` | 7 | **New** |
| **Liabilities** | `/v3/clients/{clientId}/liabilities` | 6 | Enhance V1 |
| **Notes** | `/v3/clients/{clientId}/notes` | 3 | Extend V2 |
| **Reference Data** | `/v3/refdata/*` | 15+ | Standardize |
| **TOTAL** | | **55+** | |

### 1.3 Coverage Improvement

| Domain | V2 Coverage | V3 Coverage | Gap Filled |
|--------|-------------|-------------|------------|
| Employment & Income | 100% | 100% | Enhanced |
| Budget & Expenditure | 100% | 100% | Affordability added |
| Assets | 0% | **100%** | ✓ Complete |
| Liabilities | 89% | 100% | Direct API added |
| Notes | 100% | 100% | Extended |
| **Overall Core** | 78% | **100%** | ✓ Complete |

---

## 2. Employment Family

### 2.1 Overview

**Base Path:** `/v3/clients/{clientId}/employments`
**V2 Status:** Gold Standard (100% coverage)
**V3 Strategy:** Enhance with additional features, maintain compatibility

**Key Features:**
- Polymorphic employment types (Salaried, ProfitBased, NotEmployed)
- Employment history tracking
- Income relationship management
- Tax rate calculations
- Affordability integration

### 2.2 Employment Resource

**OpenAPI 3.1 Specification:**

```yaml
components:
  schemas:
    EmploymentValue:
      description: >
        Employment details for a client. Represents current or historical employment
        with associated income sources. Uses discriminator pattern for employment-specific
        fields based on employment status type.
      type: object
      required:
        - status
        - startsOn
      properties:
        id:
          type: integer
          format: int32
          readOnly: true
          description: System-assigned employment identifier
          example: 1234

        client:
          $ref: '#/components/schemas/ClientRef'
          readOnly: true
          description: Reference to owning client

        status:
          $ref: '#/components/schemas/EmploymentStatusValue'
          description: Employment status determining polymorphic type

        employmentType:
          type: string
          readOnly: true
          description: Discriminator for employment-specific fields
          enum:
            - SalariedEmployment
            - ProfitBasedEmployment
            - NotEmployed
          example: SalariedEmployment

        startsOn:
          type: string
          format: date
          description: Employment start date
          example: '2020-01-15'

        endsOn:
          type: string
          format: date
          nullable: true
          description: Employment end date (null for current employment)
          example: null

        intendedRetirementAge:
          type: integer
          minimum: 1
          maximum: 99
          nullable: true
          description: Age at which client intends to retire from this employment
          example: 65

        notes:
          type: string
          maxLength: 5000
          nullable: true
          description: Additional employment notes
          example: 'Working from home 3 days per week'

        # Salaried Employment Fields (when employmentType = SalariedEmployment)
        employer:
          type: string
          maxLength: 200
          description: Employer name (required for Salaried)
          example: 'ACME Corporation Ltd'

        occupation:
          type: string
          maxLength: 200
          description: Job title/occupation (required for Salaried)
          example: 'Senior Software Engineer'

        employerAddress:
          $ref: '#/components/schemas/AddressValue'
          nullable: true
          description: Employer address (optional for Salaried)

        basicAnnualIncome:
          $ref: '#/components/schemas/MoneyValue'
          description: Gross basic annual salary (Salaried only)

        netBasicMonthlyIncome:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true
          description: Calculated net monthly salary (Salaried only)

        inProbation:
          type: boolean
          default: false
          description: Whether employee is in probation period (Salaried only)

        probationPeriodMonths:
          type: integer
          minimum: 0
          maximum: 24
          nullable: true
          description: Length of probation period in months (Salaried only)

        hasOvertimeIncome:
          type: boolean
          default: false
          description: Whether employee has overtime income (Salaried only)

        hasBonusIncome:
          type: boolean
          default: false
          description: Whether employee has bonus income (Salaried only)

        # Profit-Based Employment Fields (when employmentType = ProfitBasedEmployment)
        businessType:
          type: string
          enum:
            - SelfEmployed
            - ContractWorker
            - Partner
            - Director
          description: Type of profit-based business (required for ProfitBased)
          example: 'SelfEmployed'

        hasProjectionsForCurrentYear:
          type: boolean
          default: false
          description: Whether financial projections are available (ProfitBased only)

        hasStatementOfAccounts:
          type: boolean
          default: false
          description: Whether statement of accounts is available (ProfitBased only)

        hasTaxReturns:
          type: boolean
          default: false
          description: Whether tax returns are available (ProfitBased only)

        accountsAvailableYears:
          type: integer
          minimum: 0
          maximum: 10
          nullable: true
          description: Number of years of accounts available (ProfitBased only)

        netProfitHistory:
          type: array
          maxItems: 3
          description: Historical net profit data (ProfitBased only)
          items:
            type: object
            properties:
              financialYear:
                type: string
                format: date
                description: Financial year end date
              netProfit:
                $ref: '#/components/schemas/MoneyValue'
                description: Net profit for the year

        # Calculated Fields
        totalAnnualIncome:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true
          description: Total annual income from all sources linked to this employment

        totalMonthlyIncome:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true
          description: Total monthly income from all sources linked to this employment

        incomeCount:
          type: integer
          readOnly: true
          description: Number of income sources linked to this employment

        # Metadata
        createdOn:
          type: string
          format: date-time
          readOnly: true
          example: '2026-02-12T10:30:00Z'

        updatedOn:
          type: string
          format: date-time
          readOnly: true
          example: '2026-02-12T14:45:00Z'

        _links:
          $ref: '#/components/schemas/HATEOASLinks'
          readOnly: true

    EmploymentStatusValue:
      type: string
      enum:
        - Employed
        - SelfEmployed
        - CompanyDirector
        - ContractWorker
        - SemiRetired
        - MaternityLeave
        - LongTermIllness
        - Unemployed
        - Retired
        - Student
        - Homemaker
        - Other
      example: Employed

    EmploymentHistoryValue:
      description: Historical employment record
      type: object
      required:
        - employer
        - startsOn
      properties:
        id:
          type: integer
          format: int32
          readOnly: true

        client:
          $ref: '#/components/schemas/ClientRef'
          readOnly: true

        employer:
          type: string
          maxLength: 200
          description: Previous employer name

        startsOn:
          type: string
          format: date
          description: Employment start date

        endsOn:
          type: string
          format: date
          nullable: true
          description: Employment end date

        grossAnnualEarnings:
          $ref: '#/components/schemas/MoneyValue'
          nullable: true
          description: Final year gross annual earnings

        createdOn:
          type: string
          format: date-time
          readOnly: true

        _links:
          $ref: '#/components/schemas/HATEOASLinks'
          readOnly: true
```

### 2.3 Employment Endpoints

```yaml
paths:
  /v3/clients/{clientId}/employments:
    get:
      summary: List client employments
      operationId: listEmployments
      tags:
        - Employments
      security:
        - OAuth2:
            - factfind:employments:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/StatusFilter'
        - $ref: '#/components/parameters/IsCurrent'
        - $ref: '#/components/parameters/OrderBy'
        - $ref: '#/components/parameters/Limit'
        - $ref: '#/components/parameters/Cursor'
      responses:
        '200':
          description: List of employments
          headers:
            X-Total-Count:
              schema:
                type: integer
              description: Total number of employments
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/EmploymentValue'
                  pagination:
                    $ref: '#/components/schemas/PaginationValue'
                  _links:
                    $ref: '#/components/schemas/HATEOASLinks'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'

    post:
      summary: Create employment
      operationId: createEmployment
      tags:
        - Employments
      security:
        - OAuth2:
            - factfind:employments:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/EmploymentValue'
            examples:
              salariedEmployment:
                summary: Create salaried employment
                value:
                  status: Employed
                  employer: 'ACME Corporation Ltd'
                  occupation: 'Senior Software Engineer'
                  startsOn: '2020-01-15'
                  intendedRetirementAge: 65
                  basicAnnualIncome:
                    value: 75000.00
                    currency: GBP
                  inProbation: false
                  hasOvertimeIncome: true
                  hasBonusIncome: true
                  employerAddress:
                    line1: '123 Business Park'
                    cityTown: 'London'
                    postcode: 'SW1A 1AA'
                    country:
                      id: 1

              selfEmployed:
                summary: Create self-employed record
                value:
                  status: SelfEmployed
                  businessType: SelfEmployed
                  startsOn: '2018-04-01'
                  hasStatementOfAccounts: true
                  hasTaxReturns: true
                  accountsAvailableYears: 3
                  netProfitHistory:
                    - financialYear: '2023-03-31'
                      netProfit:
                        value: 45000.00
                        currency: GBP
                    - financialYear: '2024-03-31'
                      netProfit:
                        value: 52000.00
                        currency: GBP
      responses:
        '201':
          description: Employment created successfully
          headers:
            Location:
              schema:
                type: string
              description: URI of created employment
            ETag:
              schema:
                type: string
              description: Entity tag for concurrency control
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/EmploymentValue'
        '400':
          $ref: '#/components/responses/ValidationError'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'
        '409':
          $ref: '#/components/responses/ConflictError'

  /v3/clients/{clientId}/employments/{employmentId}:
    get:
      summary: Get employment details
      operationId: getEmployment
      tags:
        - Employments
      security:
        - OAuth2:
            - factfind:employments:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/EmploymentIdPath'
        - name: expand
          in: query
          schema:
            type: array
            items:
              type: string
              enum:
                - incomes
                - address
          description: Related resources to expand
      responses:
        '200':
          description: Employment details
          headers:
            ETag:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/EmploymentValue'
        '404':
          $ref: '#/components/responses/NotFound'

    put:
      summary: Update employment
      operationId: updateEmployment
      tags:
        - Employments
      security:
        - OAuth2:
            - factfind:employments:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/EmploymentIdPath'
        - $ref: '#/components/parameters/IfMatch'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/EmploymentValue'
      responses:
        '200':
          description: Employment updated successfully
          headers:
            ETag:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/EmploymentValue'
        '409':
          $ref: '#/components/responses/ConcurrentModification'
        '412':
          $ref: '#/components/responses/PreconditionFailed'

    delete:
      summary: Delete employment
      operationId: deleteEmployment
      tags:
        - Employments
      security:
        - OAuth2:
            - factfind:employments:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/EmploymentIdPath'
      responses:
        '204':
          description: Employment deleted successfully
        '404':
          $ref: '#/components/responses/NotFound'
        '409':
          description: Cannot delete - has linked incomes
          content:
            application/problem+json:
              schema:
                $ref: '#/components/schemas/ProblemDetail'

  /v3/clients/{clientId}/employment-history:
    get:
      summary: List employment history
      operationId: listEmploymentHistory
      tags:
        - Employments
      security:
        - OAuth2:
            - factfind:employments:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
      responses:
        '200':
          description: Employment history records
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/EmploymentHistoryValue'

    post:
      summary: Add employment history record
      operationId: createEmploymentHistory
      tags:
        - Employments
      security:
        - OAuth2:
            - factfind:employments:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/EmploymentHistoryValue'
      responses:
        '201':
          description: Employment history created
```

### 2.4 Employment Business Rules

**Validation Rules:**

1. **Employment Status Transitions:**
   - Cannot change status directly between Salaried ↔ ProfitBased ↔ NotEmployed
   - Must delete and recreate employment for type changes
   - Prevents data integrity issues with discriminator pattern

2. **Date Validation:**
   - `startsOn` must be <= today
   - `endsOn` must be >= `startsOn`
   - Cannot have overlapping current employments (where `endsOn` is null)

3. **Salaried Employment Requirements:**
   - Must have `employer` and `occupation`
   - `basicAnnualIncome` required
   - `employerAddress` optional but recommended

4. **Profit-Based Employment Requirements:**
   - Must have `businessType`
   - If `accountsAvailableYears` > 0, must have `netProfitHistory`
   - Maximum 3 years of profit history

5. **Income Relationship:**
   - Cannot delete employment with active incomes
   - Must delete incomes first or cascade delete
   - Income affordability recalculated on employment changes

6. **Retirement Age:**
   - Must be between 1 and 99 if provided
   - Used for retirement planning calculations

---

## 3. Income Family

### 3.1 Overview

**Base Path:** `/v3/clients/{clientId}/incomes`
**V2 Status:** Gold Standard (100% coverage)
**V3 Strategy:** Enhance filtering and expand affordability integration

**Key Features:**
- Multi-source income tracking (employment, rental, investment, pension)
- Gross/net income with automatic frequency conversions
- Affordability flags for mortgage calculations
- Employment linking
- Asset linking (rental income from properties)
- Plan linking (pension drawdown, investment withdrawals)

### 3.2 Income Resource

**OpenAPI 3.1 Specification:**

```yaml
components:
  schemas:
    IncomeValue:
      description: >
        Income source for a client. Can be linked to employment, assets (rental),
        or financial plans (pension/investment withdrawals). Includes gross and net
        amounts with automatic frequency conversions for affordability calculations.
      type: object
      required:
        - category
        - frequency
        - gross
      properties:
        id:
          type: integer
          format: int32
          readOnly: true
          description: System-assigned income identifier
          example: 5678

        client:
          $ref: '#/components/schemas/ClientRef'
          readOnly: true
          description: Primary client owner

        jointClient:
          $ref: '#/components/schemas/ClientRef'
          nullable: true
          readOnly: true
          description: Joint client owner (if applicable)

        ownership:
          type: string
          enum:
            - Client1
            - Client2
            - Joint
          description: Ownership designation for joint clients
          example: Client1

        category:
          $ref: '#/components/schemas/IncomeCategoryValue'
          description: Type of income

        description:
          type: string
          maxLength: 500
          nullable: true
          description: User-provided income description
          example: 'Base salary - monthly pay'

        gross:
          $ref: '#/components/schemas/MoneyValue'
          description: Gross income amount at specified frequency

        grossDescription:
          type: string
          maxLength: 1000
          nullable: true
          description: Additional gross amount details

        net:
          $ref: '#/components/schemas/MoneyValue'
          nullable: true
          description: Net income amount at specified frequency

        frequency:
          $ref: '#/components/schemas/FrequencyValue'
          description: Payment frequency

        # Calculated Monthly Amounts (for affordability)
        grossMonthly:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true
          description: Calculated gross monthly income

        netMonthly:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true
          description: Calculated net monthly income

        # Affordability
        includeInAffordability:
          type: boolean
          default: false
          description: Whether to include in mortgage affordability calculations

        # Relationships
        employment:
          $ref: '#/components/schemas/EmploymentRef'
          nullable: true
          description: Linked employment record (for employment income)

        asset:
          $ref: '#/components/schemas/AssetRef'
          nullable: true
          description: Linked asset (for rental/investment income)

        plan:
          type: object
          nullable: true
          description: Linked financial plan (for pension/investment withdrawals)
          properties:
            planId:
              type: integer
            withdrawalId:
              type: integer
              nullable: true
            href:
              type: string
              format: uri

        # Period
        startsOn:
          type: string
          format: date
          nullable: true
          description: Income start date

        endsOn:
          type: string
          format: date
          nullable: true
          description: Income end date (null for ongoing)

        # Metadata
        createdOn:
          type: string
          format: date-time
          readOnly: true

        updatedOn:
          type: string
          format: date-time
          readOnly: true

        lastUpdated:
          type: string
          format: date-time
          readOnly: true
          description: Last modification timestamp

        _links:
          $ref: '#/components/schemas/HATEOASLinks'
          readOnly: true

    IncomeCategoryValue:
      type: string
      enum:
        # Employment Income
        - BasicAnnualIncome
        - GuaranteedOvertime
        - RegularOvertime
        - GuaranteedBonus
        - RegularBonus
        - Commission
        - IncomeAsPartner
        -
        # Non-Employment Income
        - RentalIncome
        - InvestmentIncome
        - DividendIncome
        - PensionIncome
        - StatePension
        - BenefitIncome
        - MaintenanceIncome
        - TrustIncome
        - OtherIncome
      example: BasicAnnualIncome

    FrequencyValue:
      type: string
      enum:
        - Weekly
        - Fortnightly
        - FourWeekly
        - Monthly
        - Quarterly
        - HalfYearly
        - Annually
        - Single
      example: Monthly

    EmploymentRef:
      type: object
      description: Reference to employment record
      properties:
        id:
          type: integer
        href:
          type: string
          format: uri
        employer:
          type: string
          readOnly: true
      example:
        id: 1234
        href: '/v3/clients/5000/employments/1234'
        employer: 'ACME Corporation Ltd'

    AssetRef:
      type: object
      description: Reference to asset record
      properties:
        id:
          type: integer
        href:
          type: string
          format: uri
        description:
          type: string
          readOnly: true
      example:
        id: 789
        href: '/v3/clients/5000/assets/789'
        description: '10 High Street - Rental Property'
```

### 3.3 Income Endpoints

```yaml
paths:
  /v3/clients/{clientId}/incomes:
    get:
      summary: List client incomes
      operationId: listIncomes
      tags:
        - Incomes
      security:
        - OAuth2:
            - factfind:incomes:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - name: employmentId
          in: query
          schema:
            type: integer
          description: Filter by employment ID
        - name: category
          in: query
          schema:
            type: array
            items:
              $ref: '#/components/schemas/IncomeCategoryValue'
          description: Filter by income categories
        - name: includeInAffordability
          in: query
          schema:
            type: boolean
          description: Filter by affordability inclusion
        - name: frequency
          in: query
          schema:
            type: array
            items:
              $ref: '#/components/schemas/FrequencyValue'
          description: Filter by payment frequency
        - name: isActive
          in: query
          schema:
            type: boolean
          description: Filter by active status (no end date or end date in future)
        - $ref: '#/components/parameters/OrderBy'
        - $ref: '#/components/parameters/Limit'
        - $ref: '#/components/parameters/Cursor'
      responses:
        '200':
          description: List of incomes
          headers:
            X-Total-Count:
              schema:
                type: integer
            X-Total-Gross-Monthly:
              schema:
                type: number
                format: double
              description: Sum of all gross monthly incomes
            X-Total-Net-Monthly:
              schema:
                type: number
                format: double
              description: Sum of all net monthly incomes
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/IncomeValue'
                  summary:
                    type: object
                    description: Income summary statistics
                    properties:
                      totalGrossMonthly:
                        $ref: '#/components/schemas/MoneyValue'
                      totalNetMonthly:
                        $ref: '#/components/schemas/MoneyValue'
                      affordabilityGrossMonthly:
                        $ref: '#/components/schemas/MoneyValue'
                      affordabilityNetMonthly:
                        $ref: '#/components/schemas/MoneyValue'
                      incomeCount:
                        type: integer
                  pagination:
                    $ref: '#/components/schemas/PaginationValue'
                  _links:
                    $ref: '#/components/schemas/HATEOASLinks'

    post:
      summary: Create income
      operationId: createIncome
      tags:
        - Incomes
      security:
        - OAuth2:
            - factfind:incomes:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/IncomeValue'
            examples:
              employmentIncome:
                summary: Create employment-linked income
                value:
                  category: BasicAnnualIncome
                  description: 'Base salary - monthly pay'
                  gross:
                    value: 6250.00
                    currency: GBP
                  net:
                    value: 4583.33
                    currency: GBP
                  frequency: Monthly
                  includeInAffordability: true
                  employment:
                    id: 1234
                  startsOn: '2020-01-15'

              rentalIncome:
                summary: Create rental income from property
                value:
                  category: RentalIncome
                  description: 'Rental income - 10 High Street'
                  gross:
                    value: 1500.00
                    currency: GBP
                  net:
                    value: 1200.00
                    currency: GBP
                  frequency: Monthly
                  includeInAffordability: true
                  asset:
                    id: 789
                  startsOn: '2022-06-01'
      responses:
        '201':
          description: Income created successfully
          headers:
            Location:
              schema:
                type: string
            ETag:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IncomeValue'

  /v3/clients/{clientId}/incomes/{incomeId}:
    get:
      summary: Get income details
      operationId: getIncome
      tags:
        - Incomes
      security:
        - OAuth2:
            - factfind:incomes:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/IncomeIdPath'
      responses:
        '200':
          description: Income details
          headers:
            ETag:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IncomeValue'

    put:
      summary: Update income
      operationId: updateIncome
      tags:
        - Incomes
      security:
        - OAuth2:
            - factfind:incomes:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/IncomeIdPath'
        - $ref: '#/components/parameters/IfMatch'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/IncomeValue'
      responses:
        '200':
          description: Income updated successfully
          headers:
            ETag:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IncomeValue'

    patch:
      summary: Partially update income
      operationId: patchIncome
      tags:
        - Incomes
      security:
        - OAuth2:
            - factfind:incomes:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/IncomeIdPath'
        - $ref: '#/components/parameters/IfMatch'
      requestBody:
        required: true
        content:
          application/json-patch+json:
            schema:
              type: array
              items:
                type: object
                description: JSON Patch operation (RFC 6902)
            example:
              - op: replace
                path: /gross/value
                value: 6500.00
              - op: replace
                path: /net/value
                value: 4750.00
      responses:
        '200':
          description: Income patched successfully

    delete:
      summary: Delete income
      operationId: deleteIncome
      tags:
        - Incomes
      security:
        - OAuth2:
            - factfind:incomes:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/IncomeIdPath'
      responses:
        '204':
          description: Income deleted successfully

  /v3/clients/{clientId}/incomes/summary:
    get:
      summary: Get income summary
      operationId: getIncomeSummary
      tags:
        - Incomes
      security:
        - OAuth2:
            - factfind:incomes:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - name: includeAffordabilityOnly
          in: query
          schema:
            type: boolean
            default: false
          description: Only include incomes marked for affordability
      responses:
        '200':
          description: Income summary with totals
          content:
            application/json:
              schema:
                type: object
                properties:
                  totalGrossAnnual:
                    $ref: '#/components/schemas/MoneyValue'
                  totalNetAnnual:
                    $ref: '#/components/schemas/MoneyValue'
                  totalGrossMonthly:
                    $ref: '#/components/schemas/MoneyValue'
                  totalNetMonthly:
                    $ref: '#/components/schemas/MoneyValue'
                  affordabilityGrossMonthly:
                    $ref: '#/components/schemas/MoneyValue'
                  affordabilityNetMonthly:
                    $ref: '#/components/schemas/MoneyValue'
                  breakdown:
                    type: object
                    properties:
                      employment:
                        $ref: '#/components/schemas/MoneyValue'
                      rental:
                        $ref: '#/components/schemas/MoneyValue'
                      investment:
                        $ref: '#/components/schemas/MoneyValue'
                      pension:
                        $ref: '#/components/schemas/MoneyValue'
                      other:
                        $ref: '#/components/schemas/MoneyValue'
                  _links:
                    $ref: '#/components/schemas/HATEOASLinks'
```

### 3.4 Income Business Rules

**Validation Rules:**

1. **Category-Specific Validation:**
   - Employment income categories (BasicAnnualIncome, GuaranteedOvertime, etc.) require `employment` link
   - RentalIncome should have `asset` link (rental property)
   - PensionIncome from plans should have `plan` link

2. **Employment-Income Relationship:**
   - Income category must match employment type:
     - Salaried employment: BasicAnnualIncome, Overtime, Bonus, Commission
     - Profit-based employment: IncomeAsPartner
   - Cannot link to NotEmployed employment status

3. **Frequency Conversions:**
   - System calculates monthly amounts automatically:
     - Weekly: × 52 ÷ 12
     - Fortnightly: × 26 ÷ 12
     - FourWeekly: × 13 ÷ 12
     - Monthly: × 1
     - Quarterly: × 4 ÷ 12
     - HalfYearly: × 2 ÷ 12
     - Annually: ÷ 12

4. **Affordability Rules:**
   - Only incomes with `includeInAffordability = true` count for mortgage calculations
   - Lenders may have specific category requirements
   - Employment-linked income requires employment to be current (`endsOn` is null)

5. **Date Validation:**
   - If `startsOn` provided, must be valid date
   - If `endsOn` provided, must be >= `startsOn`
   - Cannot have `endsOn` in the past for affordability-flagged income

---

## 4. Budget Family

### 4.1 Overview

**Base Path:** `/v3/clients/{clientId}/budgets` and `/v3/clients/{clientId}/expenditures`
**V2 Status:** 100% coverage for Expenditures, partial for Budgets
**V3 Strategy:** Complete budget planning features, add Affordability API

**Key Features:**
- Budget planning (targets/projections)
- Detailed expenditure tracking
- Expense categorization
- Affordability calculations (NEW)
- Credit history (NEW via integration)
- Change expectations

### 4.2 Budget Resource

**OpenAPI 3.1 Specification:**

```yaml
components:
  schemas:
    BudgetValue:
      description: >
        Budget planning record representing planned/target expenditure for a client.
        Distinct from actual expenditure tracking. Used for financial planning and
        comparison with actual spending patterns.
      type: object
      required:
        - category
        - amount
      properties:
        id:
          type: integer
          format: int32
          readOnly: true
          description: System-assigned budget identifier

        client:
          $ref: '#/components/schemas/ClientRef'
          readOnly: true

        tenantId:
          type: integer
          readOnly: true
          description: Multi-tenant identifier

        category:
          type: string
          maxLength: 100
          description: Budget category name
          example: 'Housing'

        amount:
          $ref: '#/components/schemas/MoneyValue'
          description: Budgeted amount (monthly)

        notes:
          type: string
          maxLength: 2000
          nullable: true
          description: Budget notes and assumptions

        createdOn:
          type: string
          format: date-time
          readOnly: true

        createdBy:
          type: integer
          readOnly: true
          description: User ID who created budget

        updatedOn:
          type: string
          format: date-time
          readOnly: true

        updatedBy:
          type: integer
          readOnly: true
          description: User ID who last updated budget

        _links:
          $ref: '#/components/schemas/HATEOASLinks'
          readOnly: true

    ExpenditureValue:
      description: >
        Expenditure aggregate root containing client's actual spending breakdown.
        Can represent either summarized monthly expenditure or detailed expense tracking.
      type: object
      required:
        - isDetailed
      properties:
        id:
          type: integer
          format: int32
          readOnly: true
          description: System-assigned expenditure identifier

        client:
          $ref: '#/components/schemas/ClientRef'
          readOnly: true

        isDetailed:
          type: boolean
          description: Whether expenditure uses detailed expense breakdown

        netMonthlyAmount:
          $ref: '#/components/schemas/MoneyValue'
          description: Total net monthly expenditure

        includeLiabilities:
          type: boolean
          default: false
          description: Whether liability repayments are included in expenditure

        expectedChange:
          type: object
          nullable: true
          description: Expected future changes to expenditure
          properties:
            isChangeExpected:
              type: boolean
            isRiseExpected:
              type: boolean
              nullable: true
            changeAmount:
              $ref: '#/components/schemas/MoneyValue'
              nullable: true
            reasonForChange:
              type: string
              maxLength: 500
              nullable: true
          example:
            isChangeExpected: true
            isRiseExpected: false
            changeAmount:
              value: 300.00
              currency: GBP
            reasonForChange: 'Mortgage will be paid off in 6 months'

        expenses:
          type: array
          readOnly: true
          description: Detailed expense breakdown (if isDetailed = true)
          items:
            $ref: '#/components/schemas/ExpenseRef'

        expenseCount:
          type: integer
          readOnly: true
          description: Number of detailed expenses

        createdOn:
          type: string
          format: date-time
          readOnly: true

        updatedOn:
          type: string
          format: date-time
          readOnly: true

        _links:
          $ref: '#/components/schemas/HATEOASLinks'
          readOnly: true

    ExpenseValue:
      description: >
        Individual expense item within expenditure aggregate. Represents a specific
        spending category with amount, frequency, and period details.
      type: object
      required:
        - expenditureId
        - type
        - netAmount
        - frequency
      properties:
        id:
          type: integer
          format: int32
          readOnly: true
          description: System-assigned expense identifier

        expenditure:
          type: object
          readOnly: true
          description: Parent expenditure reference
          properties:
            id:
              type: integer
            href:
              type: string
              format: uri

        client:
          $ref: '#/components/schemas/ClientRef'
          readOnly: true

        type:
          $ref: '#/components/schemas/ExpenditureTypeRef'
          description: Expense category/type

        userDescription:
          type: string
          maxLength: 500
          nullable: true
          description: User-provided expense description
          example: 'Tesco weekly shop'

        netAmount:
          $ref: '#/components/schemas/MoneyValue'
          description: Net expense amount at specified frequency

        frequency:
          $ref: '#/components/schemas/FrequencyValue'
          description: Payment frequency

        netMonthlyAmount:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true
          description: Calculated net monthly amount

        isConsolidated:
          type: boolean
          default: false
          description: Whether expense is consolidated/combined with others

        isLiabilityToBeRepaid:
          type: boolean
          default: false
          description: Whether expense is a liability repayment that will end

        jointClient:
          $ref: '#/components/schemas/ClientRef'
          nullable: true
          readOnly: true
          description: Joint client for joint expenses

        plan:
          type: object
          nullable: true
          description: Linked financial plan (for plan contributions)
          properties:
            planId:
              type: integer
            contributionId:
              type: integer
              nullable: true
            href:
              type: string
              format: uri

        startsOn:
          type: string
          format: date
          nullable: true
          description: Expense start date

        endsOn:
          type: string
          format: date
          nullable: true
          description: Expense end date (for time-limited expenses)

        createdOn:
          type: string
          format: date-time
          readOnly: true

        updatedOn:
          type: string
          format: date-time
          readOnly: true

        _links:
          $ref: '#/components/schemas/HATEOASLinks'
          readOnly: true

    AffordabilityValue:
      description: >
        Mortgage affordability calculation result based on income, expenditure,
        and lender-specific criteria. NEW API for V3 - fills identified gap.
      type: object
      properties:
        id:
          type: integer
          format: int32
          readOnly: true

        client:
          $ref: '#/components/schemas/ClientRef'
          readOnly: true

        calculatedOn:
          type: string
          format: date-time
          readOnly: true
          description: When calculation was performed

        # Income Summary
        totalGrossMonthlyIncome:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true

        totalNetMonthlyIncome:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true

        affordabilityGrossMonthlyIncome:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true
          description: Income included in affordability calculation

        affordabilityNetMonthlyIncome:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true

        # Expenditure Summary
        totalMonthlyExpenditure:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true

        essentialExpenditure:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true

        discretionaryExpenditure:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true

        # Existing Commitments
        existingMortgagePayments:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true

        otherLoanPayments:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true

        creditCardPayments:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true

        # Affordability Calculation
        monthlyDisposableIncome:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true
          description: Net income minus essential expenditure

        maxAffordableMonthlyPayment:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true
          description: Maximum monthly mortgage payment client can afford

        affordabilityMultiple:
          type: number
          format: double
          readOnly: true
          description: Income multiple used (typically 4-5x)
          example: 4.5

        maxAffordableLoanAmount:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true
          description: Maximum loan amount client can afford

        # Stress Testing
        stressTestRate:
          type: number
          format: double
          description: Interest rate used for stress testing
          example: 7.5

        stressTestMonthlyPayment:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true

        stressTestPassed:
          type: boolean
          readOnly: true
          description: Whether client passes stress test

        # Ratios
        loanToIncomeRatio:
          type: number
          format: double
          readOnly: true
          description: Loan amount as multiple of annual income

        debtToIncomeRatio:
          type: number
          format: double
          readOnly: true
          description: Total debt payments as percentage of gross income

        # Warnings/Flags
        warnings:
          type: array
          readOnly: true
          items:
            type: object
            properties:
              code:
                type: string
                enum:
                  - HIGH_DTI_RATIO
                  - INSUFFICIENT_INCOME
                  - STRESS_TEST_FAIL
                  - PROBATION_PERIOD
                  - SHORT_EMPLOYMENT_HISTORY
                  - INCOMPLETE_DATA
              message:
                type: string
              severity:
                type: string
                enum:
                  - INFO
                  - WARNING
                  - ERROR

        _links:
          $ref: '#/components/schemas/HATEOASLinks'
          readOnly: true
```

### 4.3 Budget & Expenditure Endpoints

```yaml
paths:
  /v3/clients/{clientId}/budgets:
    get:
      summary: List budgets
      operationId: listBudgets
      tags:
        - Budgets
      security:
        - OAuth2:
            - factfind:budgets:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
      responses:
        '200':
          description: List of budget categories
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/BudgetValue'
                  summary:
                    type: object
                    properties:
                      totalMonthlyBudget:
                        $ref: '#/components/schemas/MoneyValue'

    post:
      summary: Create budget category
      operationId: createBudget
      tags:
        - Budgets
      security:
        - OAuth2:
            - factfind:budgets:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/BudgetValue'
      responses:
        '201':
          description: Budget created successfully

  /v3/clients/{clientId}/expenditures:
    get:
      summary: List expenditures
      operationId: listExpenditures
      tags:
        - Expenditures
      security:
        - OAuth2:
            - factfind:expenditures:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
      responses:
        '200':
          description: Client expenditure records
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/ExpenditureValue'

    post:
      summary: Create expenditure
      operationId: createExpenditure
      tags:
        - Expenditures
      security:
        - OAuth2:
            - factfind:expenditures:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ExpenditureValue'
      responses:
        '201':
          description: Expenditure created successfully

  /v3/clients/{clientId}/expenses:
    get:
      summary: List all expenses
      operationId: listExpenses
      tags:
        - Expenses
      security:
        - OAuth2:
            - factfind:expenditures:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - name: expenditureId
          in: query
          schema:
            type: integer
          description: Filter by expenditure ID
        - name: typeId
          in: query
          schema:
            type: integer
          description: Filter by expense type ID
        - name: groupId
          in: query
          schema:
            type: integer
          description: Filter by expense group ID
      responses:
        '200':
          description: List of expenses
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/ExpenseValue'
                  summary:
                    type: object
                    properties:
                      totalMonthlyExpenses:
                        $ref: '#/components/schemas/MoneyValue'
                      expenseCount:
                        type: integer

  /v3/clients/{clientId}/affordability:
    get:
      summary: Get affordability calculation
      operationId: getAffordability
      tags:
        - Affordability
      security:
        - OAuth2:
            - factfind:affordability:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - name: stressTestRate
          in: query
          schema:
            type: number
            format: double
            default: 7.5
          description: Interest rate for stress testing
        - name: incomeMultiple
          in: query
          schema:
            type: number
            format: double
            default: 4.5
          description: Income multiple for maximum loan calculation
      responses:
        '200':
          description: Affordability calculation result
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AffordabilityValue'
        '400':
          description: Insufficient data for calculation
          content:
            application/problem+json:
              schema:
                $ref: '#/components/schemas/ProblemDetail'
              example:
                type: 'https://api.intelliflo.com/problems/insufficient-data'
                title: 'Insufficient Data'
                status: 400
                detail: 'Cannot calculate affordability: No income sources marked for affordability'
                instance: '/v3/clients/5000/affordability'
                missingData:
                  - 'income.includeInAffordability'
                  - 'expenditure.isDetailed'
```

### 4.4 Budget Family Business Rules

**Validation Rules:**

1. **Expenditure Aggregate:**
   - If `isDetailed = true`, must have at least one expense
   - If `isDetailed = false`, must have `netMonthlyAmount`
   - Cannot change `isDetailed` after creation (delete and recreate required)

2. **Expense Rules:**
   - Cannot exist without parent expenditure
   - `netMonthlyAmount` calculated automatically from `netAmount` and `frequency`
   - If `isLiabilityToBeRepaid = true`, should have `endsOn` date

3. **Affordability Calculation Requirements:**
   - Requires at least one income with `includeInAffordability = true`
   - Requires expenditure record (detailed or summary)
   - Calculation uses current data only (no historical data)
   - Results are read-only, recalculated on demand

4. **Stress Testing:**
   - Default stress test rate: 7.5% (UK FCA requirement)
   - Stress test applies even if actual mortgage rate is lower
   - Client must pass stress test for mortgage approval

---

## 5. Assets Family

### 5.1 Overview

**Base Path:** `/v3/clients/{clientId}/assets`
**V2 Status:** 0% coverage (MAJOR GAP)
**V3 Strategy:** NEW API family - complete asset management

**Key Features:**
- Multi-category asset tracking (property, savings, investments, vehicles, valuables)
- Property-specific details (type, tenure, valuation)
- Income linking (rental income from properties)
- Address integration
- Joint ownership support
- Asset valuation history

### 5.2 Asset Resource

**OpenAPI 3.1 Specification:**

```yaml
components:
  schemas:
    AssetValue:
      description: >
        Client asset record representing property, savings, investments, or other valuable
        holdings. Can link to income sources (rental property) and addresses (property location).
        NEW API for V3 - fills major coverage gap.
      type: object
      required:
        - category
        - amount
      properties:
        id:
          type: integer
          format: int32
          readOnly: true
          description: System-assigned asset identifier

        client:
          $ref: '#/components/schemas/ClientRef'
          readOnly: true
          description: Primary asset owner

        jointClient:
          $ref: '#/components/schemas/ClientRef'
          nullable: true
          readOnly: true
          description: Joint owner (if applicable)

        ownership:
          type: string
          enum:
            - Client1
            - Client2
            - Joint
          description: Ownership designation for joint clients
          example: Client1

        category:
          $ref: '#/components/schemas/AssetCategoryValue'
          description: Type of asset

        description:
          type: string
          maxLength: 500
          description: Asset description
          example: '10 High Street - Rental Property'

        amount:
          $ref: '#/components/schemas/MoneyValue'
          description: Current asset value/balance

        valuationDate:
          type: string
          format: date
          nullable: true
          description: Date of last valuation/balance

        purchaseDate:
          type: string
          format: date
          nullable: true
          description: Date asset was acquired

        purchasePrice:
          $ref: '#/components/schemas/MoneyValue'
          nullable: true
          description: Original purchase price

        # Income Relationship
        income:
          $ref: '#/components/schemas/IncomeRef'
          nullable: true
          description: Linked income source (e.g., rental income from property)

        monthlyIncome:
          $ref: '#/components/schemas/MoneyValue'
          nullable: true
          readOnly: true
          description: Monthly income generated by asset (from linked income)

        # Address (for Property assets)
        address:
          $ref: '#/components/schemas/AddressRef'
          nullable: true
          description: Property address (for Property category assets)

        # Property-Specific Details
        propertyDetail:
          type: object
          nullable: true
          description: Additional property details (for Property category)
          properties:
            propertyType:
              type: string
              enum:
                - ResidentialOwnerOccupied
                - ResidentialLetting
                - CommercialProperty
                - Land
                - HolidayHome
                - Overseas
              description: Type of property

            tenure:
              type: string
              enum:
                - Freehold
                - Leasehold
                - Shared
              description: Property tenure

            numberOfBedrooms:
              type: integer
              minimum: 0
              maximum: 50
              nullable: true
              description: Number of bedrooms

            mortgaged:
              type: boolean
              default: false
              description: Whether property has mortgage

            outstandingMortgage:
              $ref: '#/components/schemas/MoneyValue'
              nullable: true
              description: Outstanding mortgage balance

            netEquity:
              $ref: '#/components/schemas/MoneyValue'
              readOnly: true
              description: Property value minus mortgage (calculated)

        # Account Details (for Savings/Investment assets)
        accountDetail:
          type: object
          nullable: true
          description: Account details (for Savings/Investment categories)
          properties:
            provider:
              type: string
              maxLength: 200
              description: Financial institution name

            accountNumber:
              type: string
              maxLength: 50
              nullable: true
              description: Account number (masked)

            accountType:
              type: string
              maxLength: 100
              description: Type of account (ISA, SIPP, etc.)

            interestRate:
              type: number
              format: double
              nullable: true
              description: Current interest rate percentage

        # Metadata
        notes:
          type: string
          maxLength: 2000
          nullable: true
          description: Additional asset notes

        createdOn:
          type: string
          format: date-time
          readOnly: true

        updatedOn:
          type: string
          format: date-time
          readOnly: true

        _links:
          $ref: '#/components/schemas/HATEOASLinks'
          readOnly: true

    AssetCategoryValue:
      type: string
      enum:
        - Property
        - Savings
        - Investment
        - Pension
        - Vehicle
        - Valuables
        - BusinessAssets
        - OtherAssets
      example: Property

    PropertyDetailValue:
      type: object
      description: Detailed property information
      properties:
        id:
          type: integer
          format: int32
          readOnly: true

        asset:
          type: object
          readOnly: true
          properties:
            id:
              type: integer
            href:
              type: string
              format: uri

        propertyType:
          type: string
          enum:
            - ResidentialOwnerOccupied
            - ResidentialLetting
            - CommercialProperty
            - Land
            - HolidayHome
            - Overseas

        tenure:
          type: string
          enum:
            - Freehold
            - Leasehold
            - Shared

        buildingType:
          type: string
          enum:
            - DetachedHouse
            - SemiDetachedHouse
            - TerracedHouse
            - Bungalow
            - Flat
            - Maisonette
            - Other
          nullable: true

        numberOfBedrooms:
          type: integer
          minimum: 0
          maximum: 50
          nullable: true

        numberOfBathrooms:
          type: integer
          minimum: 0
          maximum: 20
          nullable: true

        floorArea:
          type: number
          format: double
          nullable: true
          description: Floor area in square feet

        constructionYear:
          type: integer
          minimum: 1700
          maximum: 2100
          nullable: true

        # Ownership
        purchaseDate:
          type: string
          format: date
          nullable: true

        purchasePrice:
          $ref: '#/components/schemas/MoneyValue'
          nullable: true

        currentValuation:
          $ref: '#/components/schemas/MoneyValue'
          nullable: true

        valuationDate:
          type: string
          format: date
          nullable: true

        # Mortgage
        isMortgaged:
          type: boolean
          default: false

        outstandingMortgage:
          $ref: '#/components/schemas/MoneyValue'
          nullable: true

        mortgageProvider:
          type: string
          maxLength: 200
          nullable: true

        netEquity:
          $ref: '#/components/schemas/MoneyValue'
          readOnly: true
          description: Valuation minus mortgage (calculated)

        # Rental (if letting property)
        isRentalProperty:
          type: boolean
          default: false

        monthlyRentalIncome:
          $ref: '#/components/schemas/MoneyValue'
          nullable: true

        tenancyType:
          type: string
          enum:
            - AssuredShorthold
            - Regulated
            - LongLease
            - Commercial
          nullable: true

        tenancyStartDate:
          type: string
          format: date
          nullable: true

        # Insurance
        isInsured:
          type: boolean
          default: false

        insuranceProvider:
          type: string
          maxLength: 200
          nullable: true

        annualInsurancePremium:
          $ref: '#/components/schemas/MoneyValue'
          nullable: true
```

### 5.3 Assets Endpoints

```yaml
paths:
  /v3/clients/{clientId}/assets:
    get:
      summary: List client assets
      operationId: listAssets
      tags:
        - Assets
      security:
        - OAuth2:
            - factfind:assets:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - name: category
          in: query
          schema:
            type: array
            items:
              $ref: '#/components/schemas/AssetCategoryValue'
          description: Filter by asset categories
        - name: hasIncome
          in: query
          schema:
            type: boolean
          description: Filter assets with linked income
        - name: ownership
          in: query
          schema:
            type: string
            enum:
              - Client1
              - Client2
              - Joint
          description: Filter by ownership type
        - $ref: '#/components/parameters/OrderBy'
        - $ref: '#/components/parameters/Limit'
        - $ref: '#/components/parameters/Cursor'
      responses:
        '200':
          description: List of assets
          headers:
            X-Total-Count:
              schema:
                type: integer
            X-Total-Value:
              schema:
                type: number
                format: double
              description: Sum of all asset values
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/AssetValue'
                  summary:
                    type: object
                    properties:
                      totalValue:
                        $ref: '#/components/schemas/MoneyValue'
                      breakdown:
                        type: object
                        properties:
                          property:
                            $ref: '#/components/schemas/MoneyValue'
                          savings:
                            $ref: '#/components/schemas/MoneyValue'
                          investments:
                            $ref: '#/components/schemas/MoneyValue'
                          pensions:
                            $ref: '#/components/schemas/MoneyValue'
                          other:
                            $ref: '#/components/schemas/MoneyValue'
                      assetCount:
                        type: integer
                  pagination:
                    $ref: '#/components/schemas/PaginationValue'
                  _links:
                    $ref: '#/components/schemas/HATEOASLinks'

    post:
      summary: Create asset
      operationId: createAsset
      tags:
        - Assets
      security:
        - OAuth2:
            - factfind:assets:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AssetValue'
            examples:
              rentalProperty:
                summary: Create rental property with income
                value:
                  category: Property
                  description: '10 High Street - Rental Property'
                  amount:
                    value: 250000.00
                    currency: GBP
                  valuationDate: '2025-12-01'
                  purchaseDate: '2020-06-15'
                  purchasePrice:
                    value: 200000.00
                    currency: GBP
                  address:
                    id: 500
                  income:
                    id: 999
                  propertyDetail:
                    propertyType: ResidentialLetting
                    tenure: Freehold
                    numberOfBedrooms: 3
                    isMortgaged: true
                    outstandingMortgage:
                      value: 150000.00
                      currency: GBP
                    isRentalProperty: true
                    monthlyRentalIncome:
                      value: 1500.00
                      currency: GBP

              savingsAccount:
                summary: Create savings account
                value:
                  category: Savings
                  description: 'Nationwide ISA'
                  amount:
                    value: 15000.00
                    currency: GBP
                  valuationDate: '2026-02-01'
                  accountDetail:
                    provider: 'Nationwide Building Society'
                    accountType: 'Cash ISA'
                    interestRate: 4.5
      responses:
        '201':
          description: Asset created successfully
          headers:
            Location:
              schema:
                type: string
            ETag:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AssetValue'

  /v3/clients/{clientId}/assets/{assetId}:
    get:
      summary: Get asset details
      operationId: getAsset
      tags:
        - Assets
      security:
        - OAuth2:
            - factfind:assets:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/AssetIdPath'
        - name: expand
          in: query
          schema:
            type: array
            items:
              type: string
              enum:
                - income
                - address
                - propertyDetail
          description: Related resources to expand
      responses:
        '200':
          description: Asset details
          headers:
            ETag:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AssetValue'

    put:
      summary: Update asset
      operationId: updateAsset
      tags:
        - Assets
      security:
        - OAuth2:
            - factfind:assets:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/AssetIdPath'
        - $ref: '#/components/parameters/IfMatch'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AssetValue'
      responses:
        '200':
          description: Asset updated successfully

    delete:
      summary: Delete asset
      operationId: deleteAsset
      tags:
        - Assets
      security:
        - OAuth2:
            - factfind:assets:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/AssetIdPath'
      responses:
        '204':
          description: Asset deleted successfully

  /v3/clients/{clientId}/properties:
    get:
      summary: List properties (convenience endpoint)
      operationId: listProperties
      tags:
        - Assets
      security:
        - OAuth2:
            - factfind:assets:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - name: propertyType
          in: query
          schema:
            type: string
          description: Filter by property type
      responses:
        '200':
          description: List of property assets
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/AssetValue'
```

### 5.4 Assets Business Rules

**Validation Rules:**

1. **Property Assets:**
   - Must have `address` reference
   - If `propertyDetail.isMortgaged = true`, must have `propertyDetail.outstandingMortgage`
   - Net equity calculated as: `amount - outstandingMortgage`
   - If `propertyDetail.isRentalProperty = true`, should have linked `income`

2. **Income Linking:**
   - Asset-income links are bidirectional
   - Income category should match asset type:
     - Property → RentalIncome
     - Savings/Investment → InvestmentIncome/DividendIncome
   - Linked income `asset` reference must match asset ID

3. **Valuation:**
   - `valuationDate` should not be future date
   - `amount` represents current value/balance
   - `purchasePrice` historical and immutable

4. **Joint Ownership:**
   - Joint assets require both `client` and `jointClient`
   - `ownership` must be specified for joint clients
   - Net worth calculations split joint assets based on ownership

---

## 6. Liabilities Family

### 6.1 Overview

**Base Path:** `/v3/clients/{clientId}/liabilities`
**V2 Status:** 89% coverage (v1 API exists, Portfolio Plans API covers some)
**V3 Strategy:** Direct Liability API + integration with Portfolio Plans API

**Key Features:**
- Multi-category liability tracking (mortgage, loan, credit card, overdraft)
- Repayment tracking
- Protection coverage linking
- Integration with Portfolio Plans API for plan-linked liabilities
- Consolidation planning
- Early redemption charge tracking

### 6.2 Liability Resource

**OpenAPI 3.1 Specification:**

```yaml
components:
  schemas:
    LiabilityValue:
      description: >
        Client liability record representing debts, loans, mortgages, and other
        financial obligations. Can link to protection plans and properties.
      type: object
      required:
        - category
        - outstandingAmount
        - monthlyPayment
      properties:
        id:
          type: integer
          format: int32
          readOnly: true
          description: System-assigned liability identifier

        client:
          $ref: '#/components/schemas/ClientRef'
          readOnly: true
          description: Primary debtor

        jointClient:
          $ref: '#/components/schemas/ClientRef'
          nullable: true
          readOnly: true
          description: Joint debtor (if applicable)

        ownership:
          type: string
          enum:
            - Client1
            - Client2
            - Joint
          description: Ownership designation for joint clients

        category:
          $ref: '#/components/schemas/LiabilityCategoryValue'
          description: Type of liability

        description:
          type: string
          maxLength: 500
          description: Liability description
          example: 'Barclaycard - transferred balance'

        lenderName:
          type: string
          maxLength: 200
          description: Lender/creditor name
          example: 'Barclays Bank PLC'

        accountNumber:
          type: string
          maxLength: 50
          nullable: true
          description: Account/loan number (masked)

        # Amounts
        outstandingAmount:
          $ref: '#/components/schemas/MoneyValue'
          description: Current outstanding balance

        originalLoanAmount:
          $ref: '#/components/schemas/MoneyValue'
          nullable: true
          description: Original loan amount (for loans/mortgages)

        creditLimit:
          $ref: '#/components/schemas/MoneyValue'
          nullable: true
          description: Credit limit (for credit cards/overdrafts)

        monthlyPayment:
          $ref: '#/components/schemas/MoneyValue'
          description: Regular monthly payment amount

        # Repayment
        repaymentType:
          type: string
          enum:
            - CapitalAndInterest
            - InterestOnly
            - MinimumPayment
            - FixedAmount
          description: Repayment method

        interestRate:
          type: number
          format: double
          nullable: true
          description: Current interest rate percentage
          example: 4.25

        interestRateType:
          type: string
          enum:
            - Fixed
            - Variable
            - Tracker
            - Discounted
          nullable: true
          description: Type of interest rate

        loanTerm:
          type: integer
          minimum: 0
          maximum: 600
          nullable: true
          description: Original loan term in months

        remainingTerm:
          type: integer
          readOnly: true
          nullable: true
          description: Remaining loan term in months (calculated)

        # Dates
        startDate:
          type: string
          format: date
          nullable: true
          description: Loan/liability start date

        endDate:
          type: string
          format: date
          nullable: true
          description: Expected repayment completion date

        fixedRateEndDate:
          type: string
          format: date
          nullable: true
          description: Date fixed rate period ends (mortgages)

        # Protection
        protectionType:
          type: string
          enum:
            - None
            - LifeAssurance
            - CriticalIllness
            - IncomeProtection
            - MPPI
          description: Type of protection coverage

        protectionPlan:
          type: object
          nullable: true
          description: Linked protection plan
          properties:
            planId:
              type: integer
            href:
              type: string
              format: uri
            provider:
              type: string
              readOnly: true

        # Property (for mortgages)
        property:
          $ref: '#/components/schemas/AssetRef'
          nullable: true
          description: Linked property asset (for mortgages)

        isGuarantorMortgage:
          type: boolean
          default: false
          description: Whether mortgage has guarantor

        # Consolidation Planning
        isToBeRepaid:
          type: boolean
          default: false
          description: Whether liability is planned to be repaid/refinanced

        isConsolidated:
          type: boolean
          default: false
          description: Whether liability is part of consolidation plan

        repaymentNotes:
          type: string
          maxLength: 1000
          nullable: true
          description: How liability will be repaid

        # Early Redemption
        hasEarlyRedemptionCharge:
          type: boolean
          default: false
          description: Whether early repayment incurs charges

        earlyRedemptionCharge:
          $ref: '#/components/schemas/MoneyValue'
          nullable: true
          description: Estimated early redemption charge

        # Portfolio Plan Link
        plan:
          type: object
          nullable: true
          description: Linked portfolio plan (for plan-tracked liabilities)
          properties:
            planId:
              type: integer
            href:
              type: string
              format: uri

        # Metadata
        notes:
          type: string
          maxLength: 2000
          nullable: true
          description: Additional liability notes

        createdOn:
          type: string
          format: date-time
          readOnly: true

        updatedOn:
          type: string
          format: date-time
          readOnly: true

        _links:
          $ref: '#/components/schemas/HATEOASLinks'
          readOnly: true

    LiabilityCategoryValue:
      type: string
      enum:
        - Mortgage
        - SecuredLoan
        - PersonalLoan
        - CarLoan
        - CreditCard
        - StoreCard
        - Overdraft
        - StudentLoan
        - CouncilTax
        - Utilities
        - OtherLiability
      example: Mortgage
```

### 6.3 Liabilities Endpoints

```yaml
paths:
  /v3/clients/{clientId}/liabilities:
    get:
      summary: List client liabilities
      operationId: listLiabilities
      tags:
        - Liabilities
      security:
        - OAuth2:
            - factfind:liabilities:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - name: category
          in: query
          schema:
            type: array
            items:
              $ref: '#/components/schemas/LiabilityCategoryValue'
          description: Filter by liability categories
        - name: isToBeRepaid
          in: query
          schema:
            type: boolean
          description: Filter by repayment plan status
        - name: hasProtection
          in: query
          schema:
            type: boolean
          description: Filter liabilities with/without protection
        - $ref: '#/components/parameters/OrderBy'
      responses:
        '200':
          description: List of liabilities
          headers:
            X-Total-Outstanding:
              schema:
                type: number
                format: double
              description: Sum of all outstanding amounts
            X-Total-Monthly:
              schema:
                type: number
                format: double
              description: Sum of all monthly payments
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/LiabilityValue'
                  summary:
                    type: object
                    properties:
                      totalOutstanding:
                        $ref: '#/components/schemas/MoneyValue'
                      totalMonthlyPayments:
                        $ref: '#/components/schemas/MoneyValue'
                      breakdown:
                        type: object
                        properties:
                          mortgages:
                            $ref: '#/components/schemas/MoneyValue'
                          loans:
                            $ref: '#/components/schemas/MoneyValue'
                          creditCards:
                            $ref: '#/components/schemas/MoneyValue'
                          other:
                            $ref: '#/components/schemas/MoneyValue'
                      liabilityCount:
                        type: integer
                  _links:
                    $ref: '#/components/schemas/HATEOASLinks'

    post:
      summary: Create liability
      operationId: createLiability
      tags:
        - Liabilities
      security:
        - OAuth2:
            - factfind:liabilities:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/LiabilityValue'
            examples:
              mortgage:
                summary: Create mortgage liability
                value:
                  category: Mortgage
                  description: 'Primary residence mortgage'
                  lenderName: 'Nationwide Building Society'
                  outstandingAmount:
                    value: 200000.00
                    currency: GBP
                  originalLoanAmount:
                    value: 250000.00
                    currency: GBP
                  monthlyPayment:
                    value: 1200.00
                    currency: GBP
                  repaymentType: CapitalAndInterest
                  interestRate: 4.25
                  interestRateType: Fixed
                  loanTerm: 300
                  startDate: '2015-06-01'
                  endDate: '2040-06-01'
                  fixedRateEndDate: '2027-06-01'
                  protectionType: LifeAssurance
                  property:
                    id: 123

              creditCard:
                summary: Create credit card liability
                value:
                  category: CreditCard
                  description: 'Barclaycard - transferred balance'
                  lenderName: 'Barclays Bank PLC'
                  outstandingAmount:
                    value: 5000.00
                    currency: GBP
                  creditLimit:
                    value: 10000.00
                    currency: GBP
                  monthlyPayment:
                    value: 150.00
                    currency: GBP
                  repaymentType: MinimumPayment
                  interestRate: 18.9
                  interestRateType: Variable
                  isToBeRepaid: true
                  repaymentNotes: 'Plan to consolidate with personal loan'
      responses:
        '201':
          description: Liability created successfully
          headers:
            Location:
              schema:
                type: string
            ETag:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/LiabilityValue'

  /v3/clients/{clientId}/liabilities/{liabilityId}:
    get:
      summary: Get liability details
      operationId: getLiability
      tags:
        - Liabilities
      security:
        - OAuth2:
            - factfind:liabilities:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/LiabilityIdPath'
      responses:
        '200':
          description: Liability details
          headers:
            ETag:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/LiabilityValue'

    put:
      summary: Update liability
      operationId: updateLiability
      tags:
        - Liabilities
      security:
        - OAuth2:
            - factfind:liabilities:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/LiabilityIdPath'
        - $ref: '#/components/parameters/IfMatch'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/LiabilityValue'
      responses:
        '200':
          description: Liability updated successfully

    delete:
      summary: Delete liability
      operationId: deleteLiability
      tags:
        - Liabilities
      security:
        - OAuth2:
            - factfind:liabilities:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - $ref: '#/components/parameters/LiabilityIdPath'
      responses:
        '204':
          description: Liability deleted successfully
```

### 6.4 Liabilities Business Rules

**Validation Rules:**

1. **Mortgage-Specific:**
   - If `category = Mortgage`, should have `property` link
   - Mortgage requires `repaymentType`
   - If `protectionType != None`, should have `protectionPlan` link

2. **Credit Cards:**
   - `creditLimit` required for credit cards
   - `outstandingAmount` must be <= `creditLimit`
   - `interestRate` required

3. **Repayment Planning:**
   - If `isToBeRepaid = true`, should have `repaymentNotes`
   - If `isConsolidated = true`, should reference consolidation plan

4. **Protection Coverage:**
   - Protection plan link validates against Portfolio Plans API
   - Protection type should match plan type

5. **Portfolio Integration:**
   - Mortgage liabilities can link to Portfolio Mortgage Plans
   - Loan liabilities can link to Portfolio Loan Plans
   - Synchronization with Portfolio ensures data consistency

---

## 7. Notes Family

### 7.1 Overview

**Base Path:** `/v3/clients/{clientId}/notes`
**V2 Status:** 100% coverage via unified discriminator pattern
**V3 Strategy:** Extend proven discriminator pattern, add batch operations

**Key Features:**
- Unified discriminator-based routing (10 note types)
- Single API abstracts scattered database tables
- Consistent contract for all note types
- HATEOAS navigation
- Batch operations (NEW for V3)

### 7.2 Notes Resource

**OpenAPI 3.1 Specification:**

```yaml
components:
  schemas:
    NotesValue:
      description: >
        Notes for specific FactFind section. Uses discriminator pattern to route
        to appropriate backend table while presenting unified API contract.
        V2 GOLD STANDARD - Extended in V3 with batch operations.
      type: object
      required:
        - discriminator
      properties:
        client:
          $ref: '#/components/schemas/ClientRef'
          readOnly: true
          description: Client owner

        discriminator:
          $ref: '#/components/schemas/NotesDiscriminatorValue'
          description: Note type/section discriminator

        notes:
          type: string
          maxLength: 15000
          nullable: true
          description: Note content (max varies by discriminator, validated server-side)
          example: 'Client prefers email communication. Has elderly parents requiring care consideration.'

        updatedOn:
          type: string
          format: date-time
          readOnly: true
          description: Last modification timestamp

        updatedBy:
          type: integer
          readOnly: true
          description: User ID who last updated notes

        _links:
          $ref: '#/components/schemas/HATEOASLinks'
          readOnly: true

    NotesDiscriminatorValue:
      type: string
      enum:
        - Profile
        - Employment
        - AssetLiabilities
        - Budget
        - Mortgage
        - Protection
        - Retirement
        - Investment
        - EstatePlanning
        - Summary
      description: >
        Note section discriminator routing to backend tables:
        - Profile → TProfileNotes
        - Employment → TEmploymentNote
        - AssetLiabilities → TBudgetMiscellaneous.AssetLiabilityNotes
        - Budget → TBudgetMiscellaneous.BudgetNotes
        - Mortgage → TMortgageMiscellaneous
        - Protection → TProtectionMiscellaneous
        - Retirement → TRetirementNextSteps
        - Investment → TSavingsNextSteps
        - EstatePlanning → TEstateNextSteps
        - Summary → TDeclarationNotes
      example: Employment

    NotesBatchValue:
      description: Batch notes update request (NEW for V3)
      type: object
      required:
        - updates
      properties:
        updates:
          type: array
          minItems: 1
          maxItems: 10
          items:
            type: object
            required:
              - discriminator
            properties:
              discriminator:
                $ref: '#/components/schemas/NotesDiscriminatorValue'
              notes:
                type: string
                maxLength: 15000
                nullable: true
```

### 7.3 Notes Endpoints

```yaml
paths:
  /v3/clients/{clientId}/notes:
    get:
      summary: Get notes by discriminator
      operationId: getNotes
      tags:
        - Notes
      security:
        - OAuth2:
            - factfind:notes:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - name: discriminator
          in: query
          required: true
          schema:
            $ref: '#/components/schemas/NotesDiscriminatorValue'
          description: Note section type
          example: Employment
      responses:
        '200':
          description: Notes for specified section
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/NotesValue'
              example:
                client:
                  id: 5000
                  href: '/v3/clients/5000'
                  displayName: 'John Smith'
                discriminator: Employment
                notes: 'Client is currently in probation period. Permanent contract expected in 3 months.'
                updatedOn: '2026-02-12T14:30:00Z'
                updatedBy: 42
                _links:
                  self:
                    href: '/v3/clients/5000/notes?discriminator=Employment'
                  all:
                    href: '/v3/clients/5000/notes/all'
        '404':
          description: Notes not found for discriminator

    put:
      summary: Update notes
      operationId: updateNotes
      tags:
        - Notes
      security:
        - OAuth2:
            - factfind:notes:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/NotesValue'
            example:
              discriminator: Budget
              notes: 'Client wants to reduce discretionary spending by 20%. Focus on subscription services and dining out.'
      responses:
        '200':
          description: Notes updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/NotesValue'

  /v3/clients/{clientId}/notes/all:
    get:
      summary: Get all notes (NEW for V3)
      operationId: getAllNotes
      tags:
        - Notes
      security:
        - OAuth2:
            - factfind:notes:read
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
        - name: discriminators
          in: query
          schema:
            type: array
            items:
              $ref: '#/components/schemas/NotesDiscriminatorValue'
          description: Filter by specific discriminators (optional)
      responses:
        '200':
          description: All notes across discriminators
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/NotesValue'
                  _links:
                    $ref: '#/components/schemas/HATEOASLinks'
              example:
                data:
                  - discriminator: Profile
                    notes: 'Client prefers email communication.'
                    updatedOn: '2026-02-10T10:00:00Z'
                  - discriminator: Employment
                    notes: 'In probation period.'
                    updatedOn: '2026-02-12T14:30:00Z'
                  - discriminator: Budget
                    notes: 'Wants to reduce spending by 20%.'
                    updatedOn: '2026-02-11T09:15:00Z'

  /v3/clients/{clientId}/notes/batch:
    put:
      summary: Batch update notes (NEW for V3)
      operationId: batchUpdateNotes
      tags:
        - Notes
      security:
        - OAuth2:
            - factfind:notes:write
      parameters:
        - $ref: '#/components/parameters/ClientIdPath'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/NotesBatchValue'
            example:
              updates:
                - discriminator: Profile
                  notes: 'Updated profile notes.'
                - discriminator: Employment
                  notes: 'Updated employment notes.'
                - discriminator: Budget
                  notes: 'Updated budget notes.'
      responses:
        '200':
          description: Batch update completed
          content:
            application/json:
              schema:
                type: object
                properties:
                  results:
                    type: array
                    items:
                      type: object
                      properties:
                        discriminator:
                          $ref: '#/components/schemas/NotesDiscriminatorValue'
                        success:
                          type: boolean
                        error:
                          type: string
                          nullable: true
        '400':
          description: Validation error
```

### 7.4 Notes Business Rules

**Validation Rules:**

1. **Discriminator Validation:**
   - Must be one of 10 supported discriminators
   - Each discriminator routes to specific backend table
   - Max length varies by discriminator (enforced server-side)

2. **Max Lengths by Discriminator:**
   - Profile: 5000 characters
   - Employment: 5000 characters
   - AssetLiabilities: 5000 characters
   - Budget: 5000 characters
   - Mortgage: 7899 characters
   - Protection: 15000 characters
   - Retirement: 5000 characters
   - Investment: 5000 characters
   - EstatePlanning: 5000 characters
   - Summary: 5000 characters

3. **Batch Operations:**
   - Maximum 10 discriminators per batch
   - All updates processed atomically
   - Partial failure returns success/failure per discriminator

4. **Audit Trail:**
   - All note changes tracked in audit tables
   - `updatedOn` and `updatedBy` automatically managed

---

## 8. Common Patterns

### 8.1 Value Objects

All APIs use consistent value object patterns:

```yaml
components:
  schemas:
    MoneyValue:
      type: object
      required:
        - value
        - currency
      properties:
        value:
          type: number
          format: double
          description: Monetary amount
          example: 50000.00
        currency:
          type: string
          minLength: 3
          maxLength: 3
          description: ISO 4217 currency code
          example: GBP

    ClientRef:
      type: object
      description: Reference to client
      properties:
        id:
          type: integer
          description: Client ID
        href:
          type: string
          format: uri
          description: URI to client resource
        displayName:
          type: string
          readOnly: true
          description: Client display name
        type:
          type: string
          enum:
            - Personal
            - Corporate
            - Trust
          readOnly: true
      example:
        id: 5000
        href: '/v3/clients/5000'
        displayName: 'John Smith'
        type: Personal

    AddressValue:
      type: object
      properties:
        line1:
          type: string
          maxLength: 200
        line2:
          type: string
          maxLength: 200
          nullable: true
        line3:
          type: string
          maxLength: 200
          nullable: true
        line4:
          type: string
          maxLength: 200
          nullable: true
        cityTown:
          type: string
          maxLength: 100
        postcode:
          type: string
          maxLength: 20
          nullable: true
        county:
          type: object
          nullable: true
          properties:
            id:
              type: integer
            name:
              type: string
              readOnly: true
        country:
          type: object
          properties:
            id:
              type: integer
            name:
              type: string
              readOnly: true

    AddressRef:
      type: object
      description: Reference to address
      properties:
        id:
          type: integer
        href:
          type: string
          format: uri
        line1:
          type: string
          readOnly: true
        postcode:
          type: string
          readOnly: true

    HATEOASLinks:
      type: object
      description: Hypermedia links for navigation
      additionalProperties:
        type: object
        properties:
          href:
            type: string
            format: uri
          method:
            type: string
            enum:
              - GET
              - POST
              - PUT
              - PATCH
              - DELETE
          title:
            type: string
            nullable: true
      example:
        self:
          href: '/v3/clients/5000/employments/1234'
          method: GET
        update:
          href: '/v3/clients/5000/employments/1234'
          method: PUT
          title: 'Update Employment'
        delete:
          href: '/v3/clients/5000/employments/1234'
          method: DELETE
          title: 'Delete Employment'
        incomes:
          href: '/v3/clients/5000/incomes?employmentId=1234'
          method: GET
          title: 'View Incomes'

    PaginationValue:
      type: object
      properties:
        limit:
          type: integer
          description: Page size
        cursor:
          type: string
          nullable: true
          description: Current cursor position
        hasMore:
          type: boolean
          description: Whether more results available
        nextCursor:
          type: string
          nullable: true
          description: Cursor for next page

    ProblemDetail:
      type: object
      description: RFC 7807 Problem Detail
      properties:
        type:
          type: string
          format: uri
        title:
          type: string
        status:
          type: integer
        detail:
          type: string
        instance:
          type: string
          format: uri
        errors:
          type: array
          nullable: true
          items:
            type: object
            properties:
              field:
                type: string
              code:
                type: string
              message:
                type: string
              rejectedValue:
                type: string
                nullable: true
```

### 8.2 Common Parameters

```yaml
components:
  parameters:
    ClientIdPath:
      name: clientId
      in: path
      required: true
      schema:
        type: integer
        format: int32
      description: Client identifier

    EmploymentIdPath:
      name: employmentId
      in: path
      required: true
      schema:
        type: integer
        format: int32
      description: Employment identifier

    IncomeIdPath:
      name: incomeId
      in: path
      required: true
      schema:
        type: integer
        format: int32
      description: Income identifier

    AssetIdPath:
      name: assetId
      in: path
      required: true
      schema:
        type: integer
        format: int32
      description: Asset identifier

    LiabilityIdPath:
      name: liabilityId
      in: path
      required: true
      schema:
        type: integer
        format: int32
      description: Liability identifier

    IfMatch:
      name: If-Match
      in: header
      required: true
      schema:
        type: string
      description: ETag for optimistic concurrency control

    OrderBy:
      name: orderBy
      in: query
      schema:
        type: string
      description: Field(s) to sort by (e.g., 'startsOn desc')

    Limit:
      name: limit
      in: query
      schema:
        type: integer
        minimum: 1
        maximum: 500
        default: 100
      description: Maximum number of results per page

    Cursor:
      name: cursor
      in: query
      schema:
        type: string
      description: Pagination cursor for next page

    StatusFilter:
      name: status
      in: query
      schema:
        type: string
      description: Filter by status

    IsCurrent:
      name: isCurrent
      in: query
      schema:
        type: boolean
      description: Filter for current/active records only
```

### 8.3 Common Responses

```yaml
components:
  responses:
    Unauthorized:
      description: Authentication required
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetail'
          example:
            type: 'https://api.intelliflo.com/problems/authentication-required'
            title: 'Authentication Required'
            status: 401
            detail: 'Missing or invalid JWT token'
            instance: '/v3/clients/5000/employments'

    Forbidden:
      description: Insufficient permissions
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetail'
          example:
            type: 'https://api.intelliflo.com/problems/forbidden'
            title: 'Forbidden'
            status: 403
            detail: 'User does not have permission to access this client'
            instance: '/v3/clients/5000/employments'

    NotFound:
      description: Resource not found
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetail'
          example:
            type: 'https://api.intelliflo.com/problems/not-found'
            title: 'Resource Not Found'
            status: 404
            detail: 'Employment with ID 1234 does not exist'
            instance: '/v3/clients/5000/employments/1234'

    ValidationError:
      description: Validation failed
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetail'
          example:
            type: 'https://api.intelliflo.com/problems/validation-error'
            title: 'Validation Failed'
            status: 400
            detail: 'The request contains invalid data'
            instance: '/v3/clients/5000/employments'
            errors:
              - field: 'basicAnnualIncome.value'
                code: 'RANGE_ERROR'
                message: 'Basic annual income cannot be negative'
                rejectedValue: '-5000'

    ConcurrentModification:
      description: Concurrent modification detected
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetail'
          example:
            type: 'https://api.intelliflo.com/problems/concurrent-modification'
            title: 'Concurrent Modification Detected'
            status: 409
            detail: 'The resource has been modified by another user since you retrieved it'
            instance: '/v3/clients/5000/employments/1234'
            currentETag: '8f434346648f6b96df89dda901c5176b10a6d83f'

    ConflictError:
      description: Business rule conflict
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetail'
          example:
            type: 'https://api.intelliflo.com/problems/business-rule-violation'
            title: 'Business Rule Violation'
            status: 409
            detail: 'Cannot delete employment with active income sources'
            instance: '/v3/clients/5000/employments/1234'
            conflictingResources:
              - '/v3/clients/5000/incomes/789'
              - '/v3/clients/5000/incomes/790'

    PreconditionFailed:
      description: Missing If-Match header
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/ProblemDetail'
          example:
            type: 'https://api.intelliflo.com/problems/precondition-failed'
            title: 'Precondition Failed'
            status: 412
            detail: 'If-Match header is required for PUT operations'
            instance: '/v3/clients/5000/employments/1234'
```

---

## 9. Reference Data

### 9.1 Overview

**Base Path:** `/v3/refdata`
**V2 Status:** Partial coverage
**V3 Strategy:** Complete, standardize, and consolidate

### 9.2 Reference Data Endpoints

```yaml
paths:
  /v3/refdata/employment-statuses:
    get:
      summary: List employment status types
      tags:
        - Reference Data
      responses:
        '200':
          description: Employment status types
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  properties:
                    id:
                      type: string
                    name:
                      type: string
                    description:
                      type: string

  /v3/refdata/income-categories:
    get:
      summary: List income categories
      tags:
        - Reference Data
      parameters:
        - name: employmentType
          in: query
          schema:
            type: string
            enum:
              - Salaried
              - ProfitBased
              - NotEmployed
          description: Filter by employment type
      responses:
        '200':
          description: Income categories
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  properties:
                    id:
                      type: string
                    name:
                      type: string
                    description:
                      type: string
                    employmentTypes:
                      type: array
                      items:
                        type: string

  /v3/refdata/expenditure-categories:
    get:
      summary: List expenditure categories
      tags:
        - Reference Data
      responses:
        '200':
          description: Expenditure categories
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/ExpenditureTypeRef'

  /v3/refdata/expenditure-groups:
    get:
      summary: List expenditure groups
      tags:
        - Reference Data
      responses:
        '200':
          description: Expenditure groups
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  properties:
                    id:
                      type: integer
                    name:
                      type: string
                    ordinal:
                      type: integer
                    categories:
                      type: array
                      items:
                        $ref: '#/components/schemas/ExpenditureTypeRef'

  /v3/refdata/asset-categories:
    get:
      summary: List asset categories
      tags:
        - Reference Data
      responses:
        '200':
          description: Asset categories

  /v3/refdata/liability-categories:
    get:
      summary: List liability categories
      tags:
        - Reference Data
      responses:
        '200':
          description: Liability categories

  /v3/refdata/frequencies:
    get:
      summary: List payment frequencies
      tags:
        - Reference Data
      responses:
        '200':
          description: Payment frequency types
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
                  properties:
                    id:
                      type: string
                    name:
                      type: string
                    monthlyMultiplier:
                      type: number
                      format: double
                      description: Multiplier to convert to monthly amount
              example:
                - id: Weekly
                  name: Weekly
                  monthlyMultiplier: 4.333333
                - id: Monthly
                  name: Monthly
                  monthlyMultiplier: 1.0
                - id: Annually
                  name: Annually
                  monthlyMultiplier: 0.083333
```

---

## 10. Integration Patterns

### 10.1 Portfolio Plans API Integration

**Purpose:** Liabilities may be tracked in Portfolio Plans API (mortgages, loans via plans)

**Integration Pattern:**

```yaml
# Liability with plan link
{
  "id": 1234,
  "category": "Mortgage",
  "outstandingAmount": {
    "value": 200000.00,
    "currency": "GBP"
  },
  "plan": {
    "planId": 5678,
    "href": "/v1/clients/5000/plans/mortgages/5678"
  }
}

# Cross-reference query
GET /v1/clients/5000/plans/mortgages/5678
# Returns Portfolio Plan with liability reference
```

**Synchronization:**
- Changes to liability in FactFind Core should publish events
- Portfolio Plans API subscribes to liability change events
- Eventual consistency model acceptable
- Conflicts resolved by source of truth (Portfolio Plans for plan-tracked liabilities)

### 10.2 CRM Client Integration

**Purpose:** All FactFind resources belong to CRM clients

**Integration Pattern:**

```yaml
# ClientRef includes HATEOAS link to CRM
{
  "client": {
    "id": 5000,
    "href": "/v3/clients/5000",  # CRM API
    "displayName": "John Smith",
    "type": "Personal"
  }
}

# Anti-Corruption Layer
# FactFind does not directly query CRM database
# Uses CRM API or event-driven sync for client data
```

### 10.3 Requirements Microservice Integration

**Purpose:** Goals managed by Requirements microservice

**Integration Pattern:**

```yaml
# Goals in Requirements API
GET /v2/clients/5000/objectives

# FactFind Budget references goals for target planning
{
  "budgetId": 123,
  "linkedGoal": {
    "goalId": "uuid-here",
    "href": "/v2/clients/5000/objectives/uuid-here"
  }
}
```

### 10.4 Event Publishing

**Domain Events Published:**

```yaml
# Employment Events
EmploymentCreated:
  - employmentId
  - clientId
  - status
  - employer

EmploymentChanged:
  - employmentId
  - clientId
  - changes: {...}

EmploymentDeleted:
  - employmentId
  - clientId

# Income Events
IncomeCreated:
  - incomeId
  - clientId
  - category
  - grossMonthly
  - includeInAffordability

IncomeChanged:
  - incomeId
  - clientId
  - changes: {...}
  - affordabilityImpact: true/false

# Affordability Events
AffordabilityRecalculated:
  - clientId
  - maxAffordableLoanAmount
  - stressTestPassed
  - recalculationTrigger: IncomeChanged/ExpenditureChanged
```

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-12 | Claude (API Architect) | Initial V3 API contracts for FactFind Core domain. Complete specifications for Employment, Income, Budget, Assets, Liabilities, and Notes families. |

---

## Next Steps

1. **Stakeholder Review:** Present to product owners and architects
2. **Implementation Planning:** Phase implementation (Employment/Income → Budget → Assets → Liabilities)
3. **Code Generation:** Generate server stubs from OpenAPI specs
4. **Client SDK Generation:** Generate TypeScript/C# client SDKs
5. **Documentation:** Generate API documentation portal
6. **Testing Strategy:** Define contract tests, integration tests
7. **Migration Planning:** V2 → V3 migration guide for existing APIs

---

**END OF DOCUMENT**
