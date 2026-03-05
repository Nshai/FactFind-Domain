# FactFind API - Entity APIs Breakdown

**Parent Document:** [FactFind API Design v2](FactFind-API-Design-v2.md)
**Date:** 2026-02-25
**API Version:** v2.0

---

## Overview

The FactFind API has been decomposed into **28 entity-focused API design documents**, each representing a specific domain entity with its complete operations, data models, and relationships.

---

## Entity APIs by Domain Context

### 1. FactFind Root (1 Entity)

The root aggregate for fact-finding sessions.

| Entity | Operations | Description | API Document |
|--------|------------|-------------|--------------|
| **FactFind** | 4 | Root FactFind aggregate for fact-finding sessions | [FactFind API](Entity-APIs/FactFind-API.md) |

---

### 2. Client Management (12 Entities)

Client identity, profile, and compliance-related entities.

| Entity | Operations | Description | API Document |
|--------|------------|-------------|--------------|
| **Client** | 14 | Core client identity and profile management | [Client API](Entity-APIs/Client-API.md) |
| **Address** | 2 | Client address management (current & historical) | [Address API](Entity-APIs/Address-API.md) |
| **Contact** | 1 | Contact information (phone, email, etc.) | [Contact API](Entity-APIs/Contact-API.md) |
| **Estate Planning** | 5 | Estate planning, wills, gifts, IHT planning | [Estate Planning API](Entity-APIs/Estate-Planning-API.md) |
| **Dependant** | 4 | Financial dependants for protection planning | [Dependant API](Entity-APIs/Dependant-API.md) |
| **Note** | 4 | Client notes and annotations | [Note API](Entity-APIs/Note-API.md) |
| **Custom Question** | 6 | Custom and supplementary questions | [Custom Question API](Entity-APIs/Custom-Question-API.md) |
| **Vulnerability** | 2 | Client vulnerability tracking (Consumer Duty) | [Vulnerability API](Entity-APIs/Vulnerability-API.md) |
| **Identity Verification** | 1 | KYC/AML identity verification (MLR 2017) | [Identity Verification API](Entity-APIs/Identity-Verification-API.md) |
| **DPA Agreement** | 3 | Data Processing Agreements (GDPR) | [DPA Agreement API](Entity-APIs/DPA-Agreement-API.md) |
| **Financial Profile** | 1 | Client financial profile summary | [Financial Profile API](Entity-APIs/Financial-Profile-API.md) |
| **Relationship** | 1 | Client-to-client relationships and permissions | [Relationship API](Entity-APIs/Relationship-API.md) |

**Subtotal:** 12 entities, 44 operations

---

### 3. Circumstances (5 Entities)

Client circumstances including employment, income, expenditure, and affordability.

| Entity | Operations | Description | API Document |
|--------|------------|-------------|--------------|
| **Employment** | 5 | Employment history and current employment | [Employment API](Entity-APIs/Employment-API.md) |
| **Income** | 2 | Income sources and earnings tracking | [Income API](Entity-APIs/Income-API.md) |
| **Expenditure** | 1 | Expenditure items and spending tracking | [Expenditure API](Entity-APIs/Expenditure-API.md) |
| **Affordability** | 2 | Affordability calculations and budget analysis | [Affordability API](Entity-APIs/Affordability-API.md) |
| **Credit History** | 2 | Credit history, scores, and payment records | [Credit History API](Entity-APIs/Credit-History-API.md) |

**Subtotal:** 5 entities, 12 operations

---

### 4. Arrangements (6 Entities)

Financial arrangements including investments, pensions, mortgages, and protection.

| Entity | Operations | Description | API Document |
|--------|------------|-------------|--------------|
| **Investment** | 4 | Investment arrangements (GIA, ISA, bonds, cash) | [Investment API](Entity-APIs/Investment-API.md) |
| **Pension** | 2 | Pension arrangements (personal, SIPP, final salary) | [Pension API](Entity-APIs/Pension-API.md) |
| **Mortgage** | 2 | Mortgage arrangements and lending products | [Mortgage API](Entity-APIs/Mortgage-API.md) |
| **Protection** | 2 | Protection policies (life, CI, IP) | [Protection API](Entity-APIs/Protection-API.md) |
| **Contribution** | 1 | Contribution records for arrangements | [Contribution API](Entity-APIs/Contribution-API.md) |
| **Beneficiary** | 1 | Beneficiary nominations for arrangements | [Beneficiary API](Entity-APIs/Beneficiary-API.md) |

**Subtotal:** 6 entities, 12 operations

---

### 5. Assets & Liabilities (2 Entities)

Asset and liability management with net worth calculations.

| Entity | Operations | Description | API Document |
|--------|------------|-------------|--------------|
| **Asset** | 2 | Asset management (property, equities, valuables) | [Asset API](Entity-APIs/Asset-API.md) |
| **Net Worth** | 3 | Net worth calculations and tracking | [Net Worth API](Entity-APIs/Net-Worth-API.md) |

**Subtotal:** 2 entities, 5 operations

---

### 6. Risk Profiling (1 Entity)

Attitude to Risk assessment and risk profiling.

| Entity | Operations | Description | API Document |
|--------|------------|-------------|--------------|
| **ATR Assessment** | 4 | Attitude to Risk assessment and risk profiling | [ATR Assessment API](Entity-APIs/ATR-Assessment-API.md) |

**Subtotal:** 1 entity, 4 operations

---

### 7. Reference Data (1 Entity)

Reference data, enumerations, and lookup values.

| Entity | Operations | Description | API Document |
|--------|------------|-------------|--------------|
| **Reference Data** | 6 | Reference data, enumerations, lookup values | [Reference Data API](Entity-APIs/Reference-Data-API.md) |

**Subtotal:** 1 entity, 6 operations

---

## Summary Statistics

### By Domain

| Domain | Entities | Operations | % of Total |
|--------|----------|------------|------------|
| **Client Management** | 12 | 44 | 53% |
| **Arrangements** | 6 | 12 | 14% |
| **Circumstances** | 5 | 12 | 14% |
| **Assets & Liabilities** | 2 | 5 | 6% |
| **Risk Profiling** | 1 | 4 | 5% |
| **FactFind Root** | 1 | 4 | 5% |
| **Reference Data** | 1 | 6 | 7% |
| **Total** | **28** | **83** | **100%** |

### Entity Sizes

| Size Category | Count | Entities |
|---------------|-------|----------|
| **Large (10+ ops)** | 2 | Client (14), Custom Question (6) |
| **Medium (3-9 ops)** | 9 | Estate Planning (5), Employment (5), ATR Assessment (4), Dependant (4), Note (4), FactFind (4), Investment (4), DPA Agreement (3), Net Worth (3) |
| **Small (1-2 ops)** | 17 | 17 remaining entities |

---

## Entity API Document Structure

Each entity API document includes:

### Header Section
- Parent document link
- Entity name and metadata
- API version and date
- Status

### Core Sections
1. **Overview** - Entity purpose and description
2. **Entity Summary** - Key metadata (base path, aggregate root, domain context)
3. **API Operations** - All operations for this entity
4. **Request/Response Examples** - Complete examples with JSON payloads
5. **Data Model** - Entity contracts and field definitions
6. **Validation Rules** - Business rules and constraints
7. **Related Entities** - Links to related entity APIs in same domain
8. **References** - Links to parent docs, contracts, and specifications

---

## Navigation Guide

### Direct Access
Navigate directly to specific entity API:
```
steering/Target-Model/Entity-APIs/{Entity-Name}-API.md
```

Examples:
- `steering/Target-Model/Entity-APIs/Client-API.md`
- `steering/Target-Model/Entity-APIs/Investment-API.md`
- `steering/Target-Model/Entity-APIs/ATR-Assessment-API.md`

### By Domain
Browse entities grouped by domain context:
```
steering/Target-Model/Entity-APIs/README.md
```

### From Parent
Link from this document to specific entities using the tables above.

---

## Entity Relationships

### Domain Boundaries

```
FactFind (Root)
├── Client Management Domain
│   ├── Client (core)
│   ├── Address (composition)
│   ├── Contact (composition)
│   ├── Estate Planning (composition)
│   ├── Dependant (composition)
│   ├── Note (composition)
│   ├── Custom Question (composition)
│   ├── Vulnerability (composition)
│   ├── Identity Verification (singleton)
│   ├── DPA Agreement (collection)
│   ├── Financial Profile (singleton)
│   └── Relationship (collection)
│
├── Circumstances Domain
│   ├── Employment (collection)
│   ├── Income (collection)
│   ├── Expenditure (collection)
│   ├── Affordability (singleton)
│   └── Credit History (singleton)
│
├── Arrangements Domain
│   ├── Investment (type-based)
│   ├── Pension (type-based)
│   ├── Mortgage (type-based)
│   ├── Protection (type-based)
│   ├── Contribution (sub-resource)
│   └── Beneficiary (sub-resource)
│
├── Assets & Liabilities Domain
│   ├── Asset (collection)
│   └── Net Worth (calculated)
│
├── Risk Profiling Domain
│   └── ATR Assessment (singleton)
│
└── Reference Data Domain
    └── Reference Data (lookup)
```

### Key Relationships

- **Client** → has many → Address, Contact, Dependant, Note
- **Client** → has one → Estate Planning, Financial Profile, Identity Verification, Affordability
- **Client** → has many → Employment, Income, Expenditure, Relationship
- **FactFind** → has many → Asset, Liability, Arrangement, Objective
- **FactFind** → has one → ATR Assessment, Net Worth (calculated)
- **Arrangement** → has many → Contribution, Beneficiary

---

## Aggregate Roots

### Client Aggregate
- **Root:** Client
- **Entities:** Address, Contact, Estate Planning, Dependant, Note, Custom Question, Vulnerability, Identity Verification, DPA Agreement, Financial Profile, Relationship, Employment, Income, Expenditure, Affordability, Credit History

### FactFind Aggregate
- **Root:** FactFind
- **Entities:** Client (aggregate), Asset, Liability, Net Worth, Objective, ATR Assessment

### Arrangement Aggregate (Type-Based)
- **Root:** Arrangement
- **Types:** Investment, Pension, Mortgage, Protection
- **Sub-resources:** Contribution, Beneficiary

---

## Regulatory Compliance Mapping

### FCA COBS 9.2 (Suitability)
- **ATR Assessment API** - Risk profiling
- **Objective API** - Client goals
- **Client API** - Client circumstances
- **Vulnerability API** - Consumer Duty

### GDPR Compliance
- **DPA Agreement API** - Data processing consent
- **Identity Verification API** - Data processing lawful basis
- **Client API** - Right to erasure, data portability

### MLR 2017 (AML/KYC)
- **Identity Verification API** - KYC verification
- **Client API** - Customer due diligence
- **Credit History API** - Financial crime checks

### MCOB (Mortgage Conduct)
- **Affordability API** - Affordability assessment
- **Income API** - Income verification
- **Expenditure API** - Expenditure assessment

---

## Usage Examples

### Working with Client Domain

1. **Create Client:**
   ```
   POST /api/v2/factfinds/{id}/clients
   → See: Client API
   ```

2. **Add Client Address:**
   ```
   POST /api/v2/factfinds/{id}/clients/{clientId}/addresses
   → See: Address API
   ```

3. **Record Estate Planning:**
   ```
   PUT /api/v2/factfinds/{id}/clients/{clientId}/estate-planning
   → See: Estate Planning API
   ```

### Working with Arrangements

1. **Create Investment:**
   ```
   POST /api/v2/factfinds/{id}/arrangements/investments/GIA
   → See: Investment API
   ```

2. **Add Contributions:**
   ```
   POST /api/v2/factfinds/{id}/arrangements/{arrangementId}/contributions
   → See: Contribution API
   ```

3. **Nominate Beneficiary:**
   ```
   POST /api/v2/factfinds/{id}/arrangements/{arrangementId}/beneficiaries
   → See: Beneficiary API
   ```

### Working with ATR

1. **Submit ATR Assessment:**
   ```
   PUT /api/v2/factfinds/{id}/atr-assessment
   → See: ATR Assessment API
   ```

2. **Choose Risk Profile:**
   ```
   POST /api/v2/factfinds/{id}/atr-assessment/choose-profile
   → See: ATR Assessment API
   ```

---

## Entity API Index

**Full Index:** [Entity APIs README](Entity-APIs/README.md)

### Quick Links by Domain

**Client Management:**
[Client](Entity-APIs/Client-API.md) | [Address](Entity-APIs/Address-API.md) | [Contact](Entity-APIs/Contact-API.md) | [Estate Planning](Entity-APIs/Estate-Planning-API.md) | [Dependant](Entity-APIs/Dependant-API.md) | [Note](Entity-APIs/Note-API.md) | [Custom Question](Entity-APIs/Custom-Question-API.md) | [Vulnerability](Entity-APIs/Vulnerability-API.md) | [Identity Verification](Entity-APIs/Identity-Verification-API.md) | [DPA Agreement](Entity-APIs/DPA-Agreement-API.md) | [Financial Profile](Entity-APIs/Financial-Profile-API.md) | [Relationship](Entity-APIs/Relationship-API.md)

**Circumstances:**
[Employment](Entity-APIs/Employment-API.md) | [Income](Entity-APIs/Income-API.md) | [Expenditure](Entity-APIs/Expenditure-API.md) | [Affordability](Entity-APIs/Affordability-API.md) | [Credit History](Entity-APIs/Credit-History-API.md)

**Arrangements:**
[Investment](Entity-APIs/Investment-API.md) | [Pension](Entity-APIs/Pension-API.md) | [Mortgage](Entity-APIs/Mortgage-API.md) | [Protection](Entity-APIs/Protection-API.md) | [Contribution](Entity-APIs/Contribution-API.md) | [Beneficiary](Entity-APIs/Beneficiary-API.md)

**Assets & Liabilities:**
[Asset](Entity-APIs/Asset-API.md) | [Net Worth](Entity-APIs/Net-Worth-API.md)

**Risk Profiling:**
[ATR Assessment](Entity-APIs/ATR-Assessment-API.md)

**FactFind Root:**
[FactFind](Entity-APIs/FactFind-API.md)

**Reference Data:**
[Reference Data](Entity-APIs/Reference-Data-API.md)

---

## Migration from Previous Structure

### What Changed

**Before:**
```
3-Level Hierarchy:
Root → API Sections (9) → Subsections (115)
```

**After:**
```
2-Level Hierarchy:
Root → Entity APIs (28)
```

### Benefits

1. **Entity-Focused:** Each document represents a single domain entity
2. **Simplified Navigation:** Direct access to entity operations
3. **Clearer Ownership:** Each entity API has clear boundaries
4. **Domain Alignment:** Entities grouped by domain context
5. **Reduced Redundancy:** Consolidated subsections into coherent entities

---

**Document End**
**Version:** 1.0
**Last Updated:** 2026-02-25
