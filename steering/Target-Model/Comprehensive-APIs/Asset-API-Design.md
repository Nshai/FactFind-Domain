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
| `id` | integer | Unique system identifier for this record |

#### current

| Field | Type | Description |
|-------|------|-------------|
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |

#### dividends

| Field | Type | Description |
|-------|------|-------------|
| `owners` | List of Complex Data | Who owns this arrangement |

#### factfind

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for this record |

#### income

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for this record |

#### original

| Field | Type | Description |
|-------|------|-------------|
| `amount` | integer | Amount spent |
| `currency` | Complex Data |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `symbol` | string |  |

#### ownership

| Field | Type | Description |
|-------|------|-------------|
| `owners` | List of Complex Data | Who owns this arrangement |
| `ownershipType` | string | Who owns this arrangement |

#### property

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for this record |

#### rentalExpenses

| Field | Type | Description |
|-------|------|-------------|
| `amount` | integer | Amount spent |


### Related Resources

*See parent document for relationships to other entities.*

## Data Model