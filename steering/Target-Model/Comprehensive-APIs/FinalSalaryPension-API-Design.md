# Final Salary Pension API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Plans

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | FinalSalaryPension |
| **Domain** | Plans |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v3/factfinds/{factfindId}/pensions/finalsalary` |
| **Resource Type** | Collection |

### Description

Comprehensive management of Final Salary (Defined Benefit) pension schemes including prospective benefits, transfer values, accrual tracking, death benefits, early retirement options, GMP tracking, and scheme enhancements.

---

## Common Standards

This document contains **entity-specific** information only. For common standards applicable to all APIs, refer to the **[Master API Design Document](./MASTER-API-DESIGN.md)**:

- **Authentication & Authorization** - See Master Doc Section 4
- **Request/Response Standards** - See Master Doc Section 5
- **Error Handling** - See Master Doc Section 6
- **Security Standards** - See Master Doc Section 7
- **Performance Standards** - See Master Doc Section 8
- **Testing Standards** - See Master Doc Section 9

---

## Operation Summary

### Supported Operations

| Method | Path | Description | Request | Response | Status Codes | Tags |
|--------|------|-------------|---------|----------|--------------|------|
| GET | `/api/v3/factfinds/{factfindId}/pensions/finalsalary` | List all final salary pensions | Query params | FinalSalaryPension[] | 200, 401, 403 | FinalSalaryPension, List |
| POST | `/api/v3/factfinds/{factfindId}/pensions/finalsalary` | Create final salary pension | FinalSalaryPensionRequest | FinalSalaryPension | 201, 400, 401, 403, 422 | FinalSalaryPension, Create |
| GET | `/api/v3/factfinds/{factfindId}/pensions/finalsalary/{pensionId}` | Get pension by ID | Path params | FinalSalaryPension | 200, 401, 403, 404 | FinalSalaryPension, Retrieve |
| PATCH | `/api/v3/factfinds/{factfindId}/pensions/finalsalary/{pensionId}` | Update pension | FinalSalaryPensionPatch | FinalSalaryPension | 200, 400, 401, 403, 404, 422 | FinalSalaryPension, Update |
| DELETE | `/api/v3/factfinds/{factfindId}/pensions/finalsalary/{pensionId}` | Delete pension | Path params | None | 204, 401, 403, 404, 422 | FinalSalaryPension, Delete |


### Authorization

**Required Scopes:**
- `pensions:read` - Read access (GET operations)
- `pensions:write` - Create and update access (POST, PUT, PATCH)
- `pensions:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary

### Final Salary Pension Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique identifier for the pension |
| `href` | string |  | Resource URL for this pension |
| `factfind` | Reference Link |  | Link to the FactFind that this pension belongs to |
| `owners` | List of Complex Data |  | Clients who own this pension |
| `sellingAdviser` | Complex Data |  | Adviser who arranged this pension |
| `provider` | Complex Data |  | Pension scheme provider/company |
| `lifeCycle` | Complex Data |  | Pension lifecycle stage |
| `wrap` | Complex Data |  | Platform/wrap account details |
| `pensionCategory` | Selection |  | Category: PensionDefinedBenefit (default) |
| `pensionType` | Complex Data |  | Specific pension type/scheme |
| `policyNumber` | string |  | Policy or member number |
| `agencyStatus` | Selection |  | Agency servicing status |
| `employer` | string |  | Employer name |
| `normalRetirementAge` | integer |  | Normal retirement age for this scheme |
| `pensionAtRetirement` | Complex Data |  | Prospective pension benefits at retirement |
| `accrualRate` | string |  | Accrual rate (e.g., 1/60, 1/80) |
| `schemeType` | Selection |  | Scheme type: FinalSalary, CARE, Hybrid |
| `dateSchemeJoined` | date |  | Date member joined the scheme |
| `expectedYearsOfService` | integer |  | Expected total years of service |
| `pensionableSalary` | Money |  | Current pensionable salary |
| `isIndexed` | boolean |  | Whether pension increases with inflation |
| `indexationNotes` | string |  | Details of indexation (e.g., CPI capped) |
| `isPreserved` | boolean |  | Whether this is a preserved pension |
| `transferValue` | Complex Data |  | Cash Equivalent Transfer Value (CETV) |
| `gmpAmount` | Money |  | Guaranteed Minimum Pension amount |
| `deathInService` | Complex Data |  | Death in service benefits |
| `earlyRetirement` | Complex Data |  | Early retirement options and reductions |
| `dependantBenefits` | Complex Data |  | Spouse and children pension benefits |
| `purchaseAddedYears` | Complex Data |  | Purchase of additional service years |
| `affinityDCScheme` | Complex Data |  | Affinity defined contribution scheme |
| `additionalNotes` | string |  | Additional notes and comments |
| `createdAt` | timestamp |  | When this record was created |
| `updatedAt` | timestamp |  | When this record was last modified |

*Total: 33 properties*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### Reference Link

Standard reference structure for linked entities:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of referenced entity |
| `href` | string | API endpoint URL for referenced entity |

**Used for:** `factfind`

#### owners (List of Owner References)

Clients who own this pension:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Client unique identifier |
| `href` | string | API link to client resource (e.g., `/api/v3/factfinds/679/clients/8496`) |
| `name` | string | Client full name |

**Note:** Final salary pensions typically have a single owner (the scheme member).

#### sellingAdviser (Selling Adviser Reference)

Adviser who arranged this pension:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Adviser unique identifier |
| `href` | string | API link to adviser resource (e.g., `/api/v3/advisers/123`) |
| `name` | string | Adviser full name |

#### provider (Pension Provider Reference)

Pension scheme provider/company:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Product provider unique identifier |
| `href` | string | API link to product provider resource (e.g., `/api/v3/productproviders/789`) |
| `name` | string | Provider name (e.g., "NHS Pension Scheme", "Teachers Pension") |

**Common Final Salary Pension Providers:**
- **NHS Pension Scheme** - National Health Service pension
- **Teachers Pension Scheme** - Education sector pension
- **Local Government Pension Scheme (LGPS)** - Local authority employees
- **Civil Service Pension Scheme** - Central government employees
- **Police Pension Scheme** - Police officers
- **Firefighters Pension Scheme** - Fire service employees
- **Armed Forces Pension Scheme** - Military personnel
- **Royal Mail Pension Plan** - Royal Mail employees
- **British Steel Pension Scheme** - Steel industry (closed)
- **BT Pension Scheme** - British Telecom employees

#### lifeCycle (Lifecycle Reference)

Pension lifecycle stage reference:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Lifecycle unique identifier |
| `href` | string | API link to lifecycle resource (e.g., `/api/v3/lifecycles/45`) |
| `name` | string | Lifecycle stage name (e.g., "Accumulation", "Preserved", "In Payment") |

**Lifecycle Stages for Final Salary Pensions:**
- **Accumulation** - Actively building pension benefits with current employer
- **Preserved** - Left employment, benefits frozen until retirement
- **In Payment** - Pension currently being drawn
- **Deferred** - Benefits deferred to later retirement date

#### wrap (Platform/Wrap Account Reference)

Platform or wrap account details:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Platform/wrap account identifier |
| `href` | string | API link to investment resource (e.g., `/api/v3/factfinds/679/investments/234`) |
| `reference` | string | Platform account reference number |

**Use Cases:**
- **SIPP/SSAS Tracking** - Final salary pensions held within Self-Invested Personal Pension (SIPP) or Small Self-Administered Scheme (SSAS) platforms
- **Platform Consolidation** - Where DB transfer values have been moved to platform-based pensions
- **Wrap Account Reference** - Links DB pension to platform account for consolidated reporting
- **Investment Visibility** - Track DB pensions alongside platform-held investments

**Note:** While traditional final salary pensions are typically not held on wrap platforms, this field supports scenarios where:
- A DB pension has been transferred to a platform-based DC arrangement (tracked separately but linked)
- The pension is a hybrid scheme with DC elements held on a platform
- Administrative purposes require linking to platform records

#### pensionType (Pension Type Reference)

Specific pension scheme details:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Pension type unique identifier |
| `href` | string | API link to pension type resource (e.g., `/api/v3/pensiontypes/301`) |
| `name` | string | Pension scheme name (e.g., "NHS 1995 Section", "LGPS 2014 Scheme") |

**Common Pension Type Examples:**
- **NHS 1995 Section** - Final salary, 1/80 accrual, protected retirement age 60
- **NHS 2008 Section** - Final salary, 1/60 accrual, normal retirement age 65
- **NHS 2015 Scheme** - CARE scheme, 1/54 accrual
- **Teachers Final Salary** - 1/60 or 1/80 accrual
- **LGPS 2014** - CARE scheme, 1/49 accrual
- **Civil Service Classic** - Final salary, 1/80 accrual
- **Police 1987 Scheme** - Final salary, 2/3 after 30 years

#### pensionAtRetirement (Prospective Benefits)

Projected pension benefits at normal retirement age:

| Field | Type | Description |
|-------|------|-------------|
| `prospectiveWithNoLumpsumTaken` | Money | Annual pension if no lump sum taken |
| `prospectiveWithLumpsumTaken` | Money | Annual pension if maximum lump sum taken |
| `prospectiveLumpSum` | Money | Maximum tax-free lump sum available |

**Use Cases:**
- **Retirement planning** - Estimate retirement income
- **Transfer value assessment** - Compare DB pension to DC transfer
- **Tax-free cash decisions** - Evaluate lump sum vs. higher income
- **Financial planning** - Calculate retirement income needs

#### accrualRate (Accrual Rate)

Rate at which pension benefits accrue for each year of service.

**Common Accrual Rates:**
- **1/60** - Most modern final salary schemes (e.g., Teachers, Civil Service)
- **1/80** - Older schemes with automatic lump sum (e.g., NHS 1995)
- **1/54** - NHS 2015 CARE scheme
- **1/49** - LGPS 2014 CARE scheme
- **1/45** - Some enhanced schemes
- **2/3 after 30 years** - Police 1987 scheme

#### currency (Scheme Currency Reference)

Currency used for pension benefits:

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | ISO 4217 currency code (e.g., "GBP", "USD", "EUR") |
| `display` | string | Currency display name (e.g., "British Pound") |
| `symbol` | string | Currency symbol (e.g., "£", "$", "€") |

#### pensionableSalary (Pensionable Salary)

Current pensionable salary for benefit calculations:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Pensionable salary amount |
| `currency` | object | Currency details |
| `currency.code` | string | Currency code |
| `currency.display` | string | Currency display name |
| `currency.symbol` | string | Currency symbol |

**Note:** For final salary schemes, this is the salary used to calculate pension benefits (may exclude bonuses, overtime, etc.). For CARE schemes, this is the current pensionable earnings.

#### transferValue (Cash Equivalent Transfer Value)

Current transfer value details:

| Field | Type | Description |
|-------|------|-------------|
| `cashEquivalentValue` | Money | CETV amount |
| `cashEquivalentValue.amount` | decimal | Transfer value amount |
| `cashEquivalentValue.currency` | object | Currency details |
| `expiryOn` | date | Date the CETV quote expires |

**Important Notes:**
- **CETV Validity** - Transfer value quotes typically valid for 3 months
- **Guaranteed Period** - Must be honored by scheme for specified period
- **Regulatory Advice** - Transfers over £30,000 require FCA-regulated advice
- **Transfer Value Analysis** - Professional analysis comparing DB pension to DC alternative

#### gmpAmount (Guaranteed Minimum Pension)

Guaranteed Minimum Pension from contracting-out (1978-1997):

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | GMP weekly amount |
| `currency` | object | Currency details |

**GMP Background:**
- **Contracting Out** - Pre-1997 schemes could contract out of State Earnings Related Pension (SERPS)
- **Guaranteed Benefits** - Scheme must provide minimum benefits equivalent to foregone state pension
- **Revaluation** - GMP revalued in deferment at fixed rates
- **State Pension Age** - GMP payable from age 60 (women) or 65 (men)

#### deathInService (Death in Service Benefits)

Benefits payable if member dies while in service:

| Field | Type | Description |
|-------|------|-------------|
| `spousalBenefits` | decimal | Spouse's pension as percentage of member's pension (e.g., 50.0 for 50%) |
| `lumpsumMultiple` | decimal | Death benefit lump sum as multiple of salary (e.g., 4.0 for 4x salary) |
| `notes` | string | Additional death benefit details |

**Typical Provisions:**
- **Lump Sum** - Usually 2-4 times pensionable salary
- **Spouse's Pension** - Typically 50% of member's prospective pension
- **Children's Pensions** - Often payable until age 18 or 23 if in full-time education
- **Nomination** - Member can nominate beneficiaries for lump sum

#### earlyRetirement (Early Retirement Options)

Early retirement provisions and reduction factors:

| Field | Type | Description |
|-------|------|-------------|
| `retirementAge` | integer | Earliest retirement age without consent (e.g., 55) |
| `reductionFactor` | decimal | Annual reduction percentage for early retirement (e.g., 3.0 for 3% per year) |
| `retirementConsiderations` | string | Detailed early retirement terms |

**Early Retirement Rules:**
- **Minimum Pension Age** - Usually 55 (rising to 57 in 2028)
- **Actuarial Reduction** - Pension reduced for each year taken early
- **Protected Rights** - Some members have protected lower retirement ages
- **Ill-Health Retirement** - May allow unreduced pension if medically retired

#### dependantBenefits (Dependant Benefits)

Benefits for dependants after member's death:

| Field | Type | Description |
|-------|------|-------------|
| `details` | string | Description of dependant benefits (spouse, children, other dependants) |

**Common Provisions:**
- **Spouse's Pension** - Typically 50% or 66.67% of member's pension
- **Children's Pensions** - Often 25% of member's pension per child
- **Age Limits** - Usually payable until age 18 or 23 (if in education)
- **Civil Partners** - Equal treatment with spouses

#### purchaseAddedYears (Purchase of Additional Service Years)

Option to buy additional service years to increase pension:

| Field | Type | Description |
|-------|------|-------------|
| `isAvailable` | boolean | Whether added years facility available |
| `yearsPurchased` | decimal | Number of additional years purchased |
| `details` | string | Purchase method and terms |

**Added Years Provisions:**
- **Contribution Method** - Usually via salary deduction
- **Cost** - Based on age, service, and salary
- **Benefit** - Increases pensionable service for accrual calculations
- **Legacy Arrangements** - Many schemes closed added years to new purchases

#### affinityDCScheme (Affinity Defined Contribution Scheme)

Additional defined contribution arrangement alongside DB pension:

| Field | Type | Description |
|-------|------|-------------|
| `isAvailable` | boolean | Whether affinity DC scheme available |
| `contributionRate` | decimal | Member contribution rate percentage |
| `details` | string | Description of affinity scheme provisions |

**Affinity DC Schemes:**
- **Hybrid Arrangements** - Combines DB and DC benefits
- **Additional Contributions** - Member makes extra contributions to DC pot
- **Separate Pot** - DC benefits separate from main DB pension
- **Investment Choice** - Member selects funds for DC element

---

## Complete Contract Schema

### Final Salary Pension Contract Full Definition

```json
{
  "id": 15001,
  "href": "/api/v3/factfinds/679/pensions/finalsalary/15001",
  "factfind": {
    "id": 679,
    "href": "/api/v3/factfinds/679"
  },
  "owners": [
    {
      "id": 8496,
      "href": "/api/v3/factfinds/679/clients/8496",
      "name": "John Smith",
      "ownershipPercentage": 100.0
    }
  ],
  "sellingAdviser": {
    "id": 123,
    "href": "/api/v3/advisers/123",
    "name": "Jane Financial Adviser"
  },
  "provider": {
    "id": 456,
    "href": "/api/v3/productproviders/456",
    "name": "NHS Pensions"
  },
  "lifeCycle": {
    "id": 45,
    "href": "/api/v3/lifecycles/45",
    "name": "Accumulation"
  },
  "wrap": {
    "id": 234,
    "href": "/api/v3/factfinds/679/investments/234",
    "reference": "WRAP-ACC-123456"
  },
  "pensionCategory": "PensionDefinedBenefit",
  "pensionType": {
    "id": 123,
    "href": "/api/v3/plantypes?filter=id eq 123",
    "name": "Final Salary Pension"
  },
  "policyNumber": "NHS-DB-987654",
  "agencyStatus": "NOT_UNDER_AGENCY",
  "agencyStatusDate": "2023-01-15",
  "productName": "NHS Pension Scheme (1995 Section)",
  "currency": {
    "code": "GBP"
  },
  "status": "ACTIVE",
  "employer": "Royal London Hospital Trust",
  "normalRetirementAge": 60,
  "pensionAtRetirement": {
    "prospectiveWithNoLumpsumTaken": {
      "amount": 45000.00,
      "currency": {
        "code": "GBP"
      }
    },
    "prospectiveWithLumpsumTaken": {
      "amount": 33750.00,
      "currency": {
        "code": "GBP"
      }
    },
    "prospectiveLumpSum": {
      "amount": 135000.00,
      "currency": {
        "code": "GBP"
      }
    }
  },
  "accrualRate": "1/80th",
  "schemeType": "PUBLIC_SECTOR",
  "dateSchemeJoined": "1995-09-01",
  "expectedYearsOfService": 35.0,
  "pensionableSalary": {
    "amount": 65000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "isIndexed": true,
  "indexationNotes": "CPI linked annual increases, capped at 5% p.a.",
  "isPreserved": false,
  "transferValue": {
    "cashEquivalentValue": {
      "amount": 950000.00,
      "currency": {
        "code": "GBP"
      }
    },
    "expiryOn": "2026-04-15"
  },
  "gmpAmount": {
    "amount": 1250.00,
    "currency": {
      "code": "GBP"
    }
  },
  "deathInService": {
    "spousalBenefits": 50.0,
    "lumpsumMultiple": 4.0,
    "notes": "Payable to nominated beneficiaries"
  },
  "earlyRetirement": {
    "retirementAge": 55,
    "reductionFactor": 3.0,
    "retirementConsiderations": "3% reduction per year before age 60"
  },
  "dependantBenefits": "Children's pensions until age 23",
  "purchaseAddedYears": {
    "isAvailable": true,
    "yearsPurchased": 4,
    "details": "Purchased via salary deduction 2015-2019"
  },
  "affinityDCScheme": {
    "isAvailable": true,
    "contributionRate": 5.0,
    "details": "Additional DC pot alongside DB pension"
  },
  "additionalNotes": "Protected rights included",
  "createdAt": "2023-01-15T10:00:00Z",
  "updatedAt": "2026-02-25T14:30:00Z"
}
```

### Deferred Final Salary Pension Example

```json
{
  "id": 15002,
  "href": "/api/v3/factfinds/679/pensions/finalsalary/15002",
  "factfind": {
    "id": 679,
    "href": "/api/v3/factfinds/679"
  },
  "owners": [
    {
      "id": 8496,
      "href": "/api/v3/factfinds/679/clients/8496",
      "name": "John Smith",
      "ownershipPercentage": 100.0
    }
  ],
  "provider": {
    "id": 789,
    "href": "/api/v3/productproviders/789",
    "name": "Local Government Pension Scheme"
  },
  "lifeCycle": {
    "id": 46,
    "href": "/api/v3/lifecycles/46",
    "name": "Preservation"
  },
  "pensionCategory": "PensionDefinedBenefit",
  "pensionType": {
    "id": 124,
    "href": "/api/v3/plantypes?filter=id eq 124",
    "name": "Deferred Pension"
  },
  "policyNumber": "LGPS-DEF-456789",
  "agencyStatus": "NOT_UNDER_AGENCY",
  "productName": "LGPS 2008 Scheme",
  "currency": {
    "code": "GBP"
  },
  "status": "DEFERRED",
  "employer": "Nottingham City Council",
  "normalRetirementAge": 65,
  "pensionAtRetirement": {
    "prospectiveWithNoLumpsumTaken": {
      "amount": 12500.00,
      "currency": {
        "code": "GBP"
      }
    },
    "prospectiveWithLumpsumTaken": {
      "amount": 9375.00,
      "currency": {
        "code": "GBP"
      }
    },
    "prospectiveLumpSum": {
      "amount": 37500.00,
      "currency": {
        "code": "GBP"
      }
    }
  },
  "accrualRate": "1/60th",
  "schemeType": "PUBLIC_SECTOR",
  "dateSchemeJoined": "2005-04-01",
  "expectedYearsOfService": 8.5,
  "pensionableSalary": {
    "amount": 35000.00,
    "currency": {
      "code": "GBP"
    }
  },
  "isIndexed": true,
  "indexationNotes": "CPI revaluation in deferment, capped at 5% p.a.",
  "isPreserved": true,
  "transferValue": {
    "cashEquivalentValue": {
      "amount": 185000.00,
      "currency": {
        "code": "GBP"
      }
    },
    "expiryOn": "2026-06-30"
  },
  "earlyRetirement": {
    "retirementAge": 55,
    "reductionFactor": 5.0,
    "retirementConsiderations": "5% reduction per year before age 65"
  },
  "dependantBenefits": "Spouse receives 50% of member's pension",
  "additionalNotes": "Left employment 2013-09-30. Pension preserved with statutory revaluation.",
  "createdAt": "2013-09-30T16:00:00Z",
  "updatedAt": "2026-02-25T14:30:00Z"
}
```

---

## Business Validation Rules

### Required Fields

- `pensionCategory` is required (defaults to "PensionDefinedBenefit")
- `pensionType` is required
- `owners` list must contain at least one owner
- `employer` is required for occupational schemes
- `normalRetirementAge` is required
- `pensionableSalary` is required for active members

### Pension Category Values

- `PensionDefinedBenefit` - Final salary or defined benefit schemes

### Scheme Type Values

- `PUBLIC_SECTOR` - NHS, Teachers, Civil Service, Local Government, Police, Armed Forces
- `PRIVATE_SECTOR` - Company final salary schemes
- `UNFUNDED` - Unfunded public sector schemes (paid from current taxation)

### Status Values

- `ACTIVE` - Currently accruing benefits
- `DEFERRED` - Preserved benefits, no longer accruing
- `IN_PAYMENT` - Pension currently being drawn
- `TRANSFERRED_OUT` - Benefits transferred to another arrangement

### Accrual Rate Examples

- `1/60th` - 1/60th of final salary per year of service
- `1/80th` - 1/80th of final salary per year of service (with lump sum)
- `1/54th` - Career Average scheme rate
- `2.32%` - Percentage of revalued earnings

### Agency Status Values

- `NOT_UNDER_AGENCY` - Not under agency servicing
- `UNDER_AGENCY_INFORMATION_ONLY` - Agency provides information only
- `UNDER_AGENCY_SERVICING_AGENT` - Full agency servicing

### Lifecycle Stage Values

- `Accumulation` - Building benefits, active member
- `Preservation` - Deferred member, preserved benefits
- `Decumulation` - In payment, drawing pension
- `Transfer` - Considering or processing transfer

---

## UK Final Salary Pension Rules

### Protected Rights

- Pre-2016 schemes may have protected rights from contracting out
- GMP accrued between 1978-1997 must be preserved
- Section 32 buy-out plans for preserved benefits

### Transfer Out Rules (October 2023+)

- Statutory right to transfer applies to deferred and active members
- FCA requires advice for transfers over £30,000
- Pension Scams regulations require due diligence
- Transfer Value Analysis (TVA) required

### Abatement

- Some public sector schemes reduce pension if member returns to work
- Applies to early retirement pensions in particular

### Revaluation

- Deferred pensions must be revalued annually
- Statutory minimum revaluation: CPI capped at 5% or 2.5%
- In-payment increases: CPI, RPI, or fixed percentage depending on scheme rules

### Normal Retirement Age

- State Pension Age alignment for post-2015 public sector schemes
- Legacy schemes: age 60 or 65 typically
- Protected retirement ages for some members

---

**Document Version:** 2.0
**Last Updated:** 2026-02-25
**Entity:** FinalSalaryPension
**Domain:** Plans
