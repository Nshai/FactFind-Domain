# Dependant API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Client Management

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | Dependant |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Financial dependants management

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

*Refer to source document for detailed operations.*


### Authorization

**Required Scopes:**
- `dependant:read` - Read access (GET operations)
- `dependant:write` - Create and update access (POST, PUT, PATCH)
- `dependant:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary






### Dependant Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `age` | integer |  | Current age (calculated from date of birth) |
| `clients` | List of Complex Data |  | Client segment classification (A, B, C, D for prioritization) |
| `createdAt` | date |  | When this record was created in the system |
| `dateOfBirth` | date |  | Date of birth |
| `dependencyDetails` | Complex Data |  |  |
| `educationDetails` | Complex Data |  |  |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `firstName` | string |  | First name (given name) |
| `fullName` | string |  | Complete formatted name including title |
| `gender` | string |  | Gender (M=Male, F=Female, O=Other, X=Prefer not to say) |
| `healthDetails` | Complex Data |  |  |
| `id` | integer | ✓ | Unique system identifier for this record |
| `isFinanciallyDependent` | boolean |  |  |
| `lastName` | string |  | Last name (surname/family name) |
| `livingArrangements` | Complex Data |  |  |
| `middleNames` | string |  | Middle name(s) |
| `notes` | string |  |  |
| `relationship` | string |  |  |
| `updatedAt` | date |  | When this record was last modified |

*Total: 19 properties*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### clients (List of Client References)

List of clients to whom this dependant belongs:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of client |
| `href` | string | API endpoint URL for client |
| `name` | string | Client full name |

**Note:** In joint factfinds, dependants can belong to both clients (e.g., children of married couple).

#### factfind (Reference Link)

Standard reference structure:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of factfind |
| `href` | string | API endpoint URL for factfind |

#### dependencyDetails (Financial Dependency Details)

Financial dependency cost details:

| Field | Type | Description |
|-------|------|-------------|
| `annualCost` | Money | Annual cost to support this dependant |
| `monthlyCost` | Money | Monthly cost to support this dependant |
| `estimatedDependencyEndAge` | integer | Age when financial dependency is expected to end |
| `estimatedDependencyEndDate` | date | Date when financial dependency is expected to end |

**Used For:**
- Protection needs analysis (calculating life insurance requirements)
- Income replacement calculations
- Financial planning scenarios

**Typical Dependency End Ages:**
- Children: 18-21 (end of education)
- University students: 21-23 (completion of higher education)
- Special needs dependants: May extend beyond typical age or indefinitely
- Elderly dependants: Based on life expectancy and care needs

#### educationDetails (Education Planning Details)

Education status and cost planning:

| Field | Type | Description |
|-------|------|-------------|
| `currentEducationLevel` | string | Current education level |
| `isInPrivateEducation` | boolean | Whether currently in private/independent school |
| `plannedHigherEducation` | boolean | Whether higher education (university) is planned |
| `estimatedEducationCosts` | Money | Total estimated education costs (remaining) |

**Education Levels:**
- Pre-School / Nursery
- Primary School (Ages 4-11)
- Secondary School (Ages 11-16)
- Sixth Form / College (Ages 16-18)
- University / Higher Education (Ages 18+)
- Apprenticeship
- Not in Education

**Private Education Costs (UK 2024/25):**
- Private day school: £15,000 - £20,000 per year
- Private boarding school: £30,000 - £45,000 per year
- University (tuition + living): £20,000 - £30,000 per year

**Use Cases:**
- Education fund planning
- Junior ISA / savings planning
- Trust fund requirements
- Grandparent gifting strategies

#### healthDetails (Health and Care Details)

Health status and care requirements:

| Field | Type | Description |
|-------|------|-------------|
| `hasSpecialNeeds` | boolean | Whether dependant has special needs or disabilities |
| `requiresOngoingCare` | boolean | Whether ongoing care is required |
| `healthNotes` | string | Additional health information or care requirements |

**Special Needs Considerations:**
- Impact on protection needs (life insurance, critical illness)
- Long-term care planning requirements
- Special needs trusts
- Disability benefits (Disability Living Allowance, Personal Independence Payment)
- Educational support needs (EHCP - Education Health Care Plan)

**Ongoing Care Costs:**
- Home care: £15 - £30 per hour
- Respite care: £100 - £200 per day
- Residential care (adults): £600 - £1,000+ per week
- Specialist equipment and adaptations

#### livingArrangements (Living Situation)

Current living arrangements for the dependant:

| Field | Type | Description |
|-------|------|-------------|
| `livesWithClient` | boolean | Whether dependant currently lives with client |
| `custodyArrangement` | string | Custody arrangement type |

**Custody Arrangements:**
- **Full Custody** - Dependant lives with client full-time
- **Shared Custody** - Split time between separated/divorced parents
- **Primary Custody** - Primarily with client, regular visitation for other parent
- **Visiting Rights** - Does not live with client, regular visits only
- **No Contact** - Client has no custody or visitation rights

**Impact on Planning:**
- Affects dependency cost calculations (full vs. partial financial responsibility)
- Influences protection needs analysis
- Impacts Child Maintenance calculations
- Estate planning considerations (guardianship, trusts)

#### relationship (Relationship to Client)

Standard relationship types:

**Relationship Values:**
- `CHILD` - Natural or adopted child
- `STEP_CHILD` - Step-child
- `GRANDCHILD` - Grandchild
- `PARENT` - Elderly parent
- `SPOUSE_PARTNER` - Spouse or partner (if financially dependent)
- `SIBLING` - Brother or sister
- `OTHER` - Other dependent relationship

#### Money (Currency Amount)

Currency amount structure:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Monetary amount |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code (e.g., GBP) |
| `symbol` | string | Currency symbol (e.g., £) |

**Used for:** `annualCost`, `monthlyCost`, `estimatedEducationCosts`

### Protection Needs Analysis

**Life Insurance Calculations:**

When calculating life insurance requirements, dependant costs are critical:

```
Protection Need = (Annual Dependency Cost × Years Until Independence) + Lump Sum Costs
```

**Example:**
- Dependant: Child aged 10
- Annual cost: £9,600 (£800/month)
- Dependency end age: 21
- Remaining years: 11
- Estimated education costs: £50,000 (university)

**Calculation:**
- Income replacement: £9,600 × 11 = £105,600
- Education costs: £50,000
- **Total protection need: £155,600**

**Multiple Dependants:**
For multiple dependants, protection needs are calculated for each and summed, accounting for overlapping years.

### Child Benefit and Tax

**Child Benefit (UK 2024/25):**
- First child: £25.60 per week (£1,331 per year)
- Additional children: £16.95 per week (£881 per year)

**High Income Child Benefit Charge:**
- Applies when adjusted net income exceeds £60,000
- 1% charge for every £200 over £60,000
- Fully clawed back at £80,000+

**Tax Treatment:**
Child Benefit is counted as income for affordability assessments but may be offset by High Income Child Benefit Charge.

### Use Cases

**1. Protection Needs Analysis:**
```
1. Client (age 35) with two children (ages 8 and 10)
2. Annual dependency costs: £15,000 per child
3. Children expected to be independent at age 21
4. Child 1: 13 years remaining × £15,000 = £195,000
5. Child 2: 11 years remaining × £15,000 = £165,000
6. University costs: £60,000 (£30k per child)
7. Total protection need from dependants: £420,000
8. Plus: Mortgage balance, funeral costs, other liabilities
```

**2. Private Education Planning:**
```
1. Child currently age 5 in state primary school
2. Parents considering private secondary (age 11)
3. Private day school fees: £18,000 per year
4. Years of private education: 7 years (ages 11-18)
5. Total cost: £18,000 × 7 = £126,000
6. Plus university: £60,000
7. Total education fund needed: £186,000
8. Current Junior ISA: £15,000
9. Additional savings required: £171,000
10. Monthly savings required over 6 years: £2,375
```

**3. Special Needs Planning:**
```
1. Child age 10 with special needs
2. Will require lifetime care (no dependency end age)
3. Annual care costs: £25,000
4. Parent life expectancy: 80 (45 years remaining)
5. Protection need: £25,000 × 45 = £1,125,000
6. Alternative: Special needs trust with investment income
7. Capital needed at 4% yield: £625,000
8. Plus buffer for cost inflation and care escalation
```

**4. Shared Custody Financial Planning:**
```
1. Divorced couple with shared custody (50/50)
2. Child age 12 living alternate weeks with each parent
3. Annual dependency cost: £12,000
4. Allocated cost per parent: £6,000 (50%)
5. Child Maintenance: £5,000 per year (paid by non-resident parent)
6. Protection needs calculated separately for each parent
7. Parent A (resident): £6,000 × 9 years = £54,000
8. Parent B (non-resident): £6,000 × 9 years = £54,000
9. Both parents need life insurance to cover their share
```

**5. Elderly Dependant Care:**
```
1. Client supporting elderly mother (age 85)
2. Mother living in residential care home
3. Monthly care home fees: £4,000 (£48,000 annually)
4. Mother's state pension: £11,500
5. Client contribution: £36,500 per year
6. Estimated dependency period: 5 years (to age 90)
7. Protection need: £36,500 × 5 = £182,500
8. Estate planning: Deprivation of assets rules for care funding
```

### Related Resources

*See parent document for relationships to other entities.*


## Data Model