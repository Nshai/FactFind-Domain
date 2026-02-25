# Asset API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Assets & Liabilities

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | Asset |
| **Domain** | Assets & Liabilities |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Asset management

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
- `asset:read` - Read access (GET operations)
- `asset:write` - Create and update access (POST, PUT, PATCH)
- `asset:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary






### Asset Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `arrangement` | Reference Link |  |  |
| `assetType` | string |  |  |
| `createdAt` | date |  | When this record was created in the system |
| `currentValue` | Money |  | Current value of the arrangement |
| `description` | string |  | Description of the goal |
| `dividends` | Complex Data |  | Unique system identifier for this record |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `id` | integer | ✓ | Unique system identifier for this record |
| `income` | Reference Link |  |  |
| `isBusinessAssetDisposalRelief` | boolean |  |  |
| `isBusinessReliefQualifying` | boolean |  |  |
| `isFreeFromInheritanceTax` | boolean |  |  |
| `isHolding` | boolean |  |  |
| `isVisibleToClient` | boolean |  |  |
| `notes` | string |  |  |
| `originalValue` | Money |  | The contact value (email address, phone number, etc.) |
| `ownership` | Complex Data |  | Who owns this arrangement |
| `property` | Reference Link |  |  |
| `purchasedOn` | date |  |  |
| `rentalExpenses` | Money |  |  |
| `rnrbEligibility` | string |  |  |
| `updatedAt` | date |  | When this record was last modified |
| `valuationBasis` | string |  |  |
| `valuedOn` | date |  | The contact value (email address, phone number, etc.) |

*Total: 24 properties*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### arrangement

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for the linked arrangement |

#### currentValue (Money Structure)

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Current value amount |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code (e.g., GBP) |
| `symbol` | string | Currency symbol (e.g., £) |

#### dividends

| Field | Type | Description |
|-------|------|-------------|
| `owners` | List<Complex Data> | Dividend ownership details |

#### factfind

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier for the parent fact-find |

#### income

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier for linked income record |

#### originalValue (Money Structure)

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Original purchase/acquisition value |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code (e.g., GBP) |
| `symbol` | string | Currency symbol (e.g., £) |

#### ownership

| Field | Type | Description |
|-------|------|-------------|
| `owners` | List<Complex Data> | List of owners with percentages |
| `ownershipType` | string | Type of ownership (e.g., JOINT, SOLE) |

#### property

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier for linked property record |

#### rentalExpenses (Money Structure)

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Monthly rental expenses amount |
| `currency` | string | Currency code |

### Related Resources

*See parent document for relationships to other entities.*


## Data Model