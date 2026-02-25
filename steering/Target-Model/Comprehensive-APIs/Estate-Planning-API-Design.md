# Estate-Planning API Design

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
| **Entity Name** | Estate-Planning |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Estate planning, wills, gifts

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
- `estate_planning:read` - Read access (GET operations)
- `estate_planning:write` - Create and update access (POST, PUT, PATCH)
- `estate_planning:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary






### Estate-Planning Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `href` | string |  | Resource URL for this estate planning record |
| `client` | Reference Link |  | Client reference |
| `factfind` | Reference Link |  | FactFind reference |
| `willDetails` | string |  | Free-text description of will arrangements |
| `totalAssets` | Money |  | Total value of client's estate |
| `totalJointAssets` | Money |  | Total value of jointly owned assets |
| `giftInLast7YearsDetails` | string |  | Description of gifts made in last 7 years |
| `recentGiftDetails` | string |  | Description of recent gifts (current tax year) |
| `regularGiftDetails` | string |  | Description of regular gifts from income |
| `expectingInheritanceDetails` | string |  | Description of expected inheritance |
| `propertyAdditionalNrb` | Money |  | Residence nil rate band (max £175,000) |
| `taxYearWhenPropertySold` | integer |  | Tax year when main residence was sold (if applicable) |
| `widowsReliefNrbDeceasedPercentage` | Number (Percentage) |  | Percentage of deceased spouse's NRB available to transfer |
| `widowsReliefPropertyAdditionalNrbDeceasedPercentage` | Number (Percentage) |  | Percentage of deceased spouse's RNRB available to transfer |
| `businessAssetRelief` | Money |  | Business property relief available |
| `gifts` | List of Complex Data |  | Collection of gifts (see Gift contract) |
| `createdAt` | Date and Time |  | When this record was created (read-only) |
| `updatedAt` | Date and Time |  | When this record was last updated (read-only) |

*Total: 18 properties*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### Money

Currency amount structure:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Monetary amount |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code (e.g., GBP) |
| `symbol` | string | Currency symbol (e.g., £) |

**Used for:** `totalAssets`, `totalJointAssets`, `propertyAdditionalNrb`, `businessAssetRelief`

#### Reference Link

Standard reference structure:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of referenced entity |
| `href` | string | API endpoint URL for referenced entity |

**Used for:** `client`, `factfind`

#### gifts (List of Complex Data)

Each gift record contains:

| Field | Type | Description |
|-------|------|-------------|
| `giftDate` | date | Date gift was made |
| `recipient` | string | Name of recipient |
| `relationship` | string | Relationship to client |
| `amount` | Money | Value of gift |
| `description` | string | Description of gift |
| `isRegularGiftFromIncome` | boolean | Whether this is a regular gift from surplus income |
| `isWithinAnnualExemption` | boolean | Whether covered by £3,000 annual exemption |

### UK Inheritance Tax (IHT) Planning

#### Nil Rate Band (NRB)

**Standard NRB:** £325,000 (2024/25 tax year)
- Amount of estate that can pass free of IHT
- Frozen until April 2028
- Any amount above NRB taxed at 40%

**Transferable NRB:** Surviving spouse can inherit unused portion
- `widowsReliefNrbDeceasedPercentage`: Percentage of deceased spouse's NRB available
- If deceased spouse left everything to survivor: 100% NRB available to transfer
- Maximum transferable NRB: £325,000 (100%)

#### Residence Nil Rate Band (RNRB)

**Additional NRB:** Up to £175,000 (2024/25 tax year)
- Only applies when main residence passes to direct descendants
- Direct descendants: Children, grandchildren, step-children
- `propertyAdditionalNrb`: RNRB available for this client

**Transferable RNRB:** Also transferable between spouses
- `widowsReliefPropertyAdditionalNrbDeceasedPercentage`: Percentage of deceased spouse's RNRB available
- Maximum transferable RNRB: £175,000 (100%)

**RNRB Taper:** Reduces for estates over £2 million
- £1 reduction for every £2 over threshold
- Fully tapered away at £2.35 million (for single person)

**Property Downsizing Relief:**
- If main residence sold after July 2015
- `taxYearWhenPropertySold`: Records when property was sold
- Relief may still be available if proceeds inherited by descendants

#### Total IHT Allowance (Married Couple)

Maximum combined allowance:
- 2 × Standard NRB: 2 × £325,000 = **£650,000**
- 2 × RNRB: 2 × £175,000 = **£350,000**
- **Total: £1,000,000** (if both allowances fully transferred)

#### Gifts and Exemptions

**7-Year Rule:**
- Gifts made more than 7 years before death: IHT-free
- Gifts within 7 years: May be subject to IHT
- `giftInLast7YearsDetails`: Records potentially exempt transfers (PETs)

**Taper Relief:** Gifts made 3-7 years before death get taper relief:
| Years Before Death | Tax Rate |
|-------------------|----------|
| 0-3 years | 40% |
| 3-4 years | 32% |
| 4-5 years | 24% |
| 5-6 years | 16% |
| 6-7 years | 8% |
| 7+ years | 0% |

**Annual Exemptions:**
- £3,000 per year (can carry forward one year if unused)
- Small gifts: £250 per person per year
- Wedding gifts: £5,000 (parent), £2,500 (grandparent), £1,000 (anyone else)

**Regular Gifts from Income:**
- Gifts made from surplus income
- Must be regular pattern
- Must not affect standard of living
- Immediately exempt (no 7-year wait)
- `regularGiftDetails`: Records these exempt gifts

**Recent Gifts:**
- `recentGiftDetails`: Gifts made in current tax year
- May use current year's £3,000 exemption

#### Business Property Relief (BPR)

**`businessAssetRelief`:** Value of business assets qualifying for relief
- 100% relief: Business, unlisted shares
- 50% relief: Controlling shareholding in listed company
- Must own business/shares for 2 years
- Passes free of IHT

#### Expected Inheritance

**`expectingInheritanceDetails`:** Future inheritance expected
- Important for overall financial planning
- May affect estate planning strategy
- Not part of current estate valuation

### IHT Calculation Example

**Estate Value:** £1,200,000
**Jointly Owned Assets:** £400,000 (only 50% counts = £200,000)
**Chargeable Estate:** £1,200,000 - £200,000 = **£1,000,000**

**IHT Allowances (widow/widower with transferred NRB & RNRB):**
- Standard NRB: £325,000 × 2 = £650,000
- RNRB: £175,000 × 2 = £350,000
- **Total Allowances:** £1,000,000

**IHT Due:** £1,000,000 - £1,000,000 = £0 (no IHT payable)

**Without Transferred Allowances:**
- Allowances: £325,000 + £175,000 = £500,000
- Taxable: £1,000,000 - £500,000 = £500,000
- IHT: £500,000 × 40% = **£200,000**

**Benefit of Planning:** £200,000 IHT saved

### Will Planning Essentials

**`willDetails` should capture:**
- Executor appointments
- Guardian appointments (for children under 18)
- Specific bequests
- Residuary beneficiaries
- Trust arrangements
- Funeral wishes

**Important Considerations:**
- Mirror wills (for couples)
- Discretionary trusts
- Life interest trusts
- Nil rate band trusts
- Business succession planning

### Related Resources

*See parent document for relationships to other entities.*


## Data Model