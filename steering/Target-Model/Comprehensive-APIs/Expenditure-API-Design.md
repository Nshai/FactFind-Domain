# Expenditure API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Circumstances

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | Expenditure |
| **Domain** | Circumstances |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Expenditure and spending

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
- `expenditure:read` - Read access (GET operations)
- `expenditure:write` - Create and update access (POST, PUT, PATCH)
- `expenditure:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary




### Expenditure Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique identifier for the expenditure |
| `href` | string |  | Link to this expenditure resource |
| `factfind` | Link to FactFind |  | The fact-find that this expenditure belongs to |
| `client` | Link to Client |  | The client who has this expenditure |
| `description` | string |  | Description of the expenditure |
| `expenditureType` | Selection |  | Type/category of expenditure |
| `netAmount` | Money |  | Amount paid (after tax if applicable) - includes currency code, name, and symbol |
| `frequency` | Selection |  | How often the payment is made |
| `startsOn` | date |  | When the expenditure started |
| `endsOn` | date |  | When the expenditure ends (if known) |
| `isConsolidated` | boolean |  | Is this part of a debt consolidation? |
| `isLiabilityToBeRepaid` | boolean |  | Is this paying off a specific debt? |
| `liability` | Link to Liability |  | The debt/liability being repaid |
| `notes` | string |  | Additional notes |
| `createdAt` | date |  | When this record was created in the system |
| `updatedAt` | date |  | When this record was last modified |

*Total: 16 properties*


### Referenced Type Definitions

The following complex types are used in the properties above:

#### client

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Client identifier |
| `href` | string | Link to the client |

#### factfind

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | FactFind identifier |
| `href` | string | Link to the fact-find |

#### liability (optional)

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Liability identifier |
| `href` | string | Link to the liability |

#### netAmount

| Field | Type | Description |
|-------|------|-------------|
| `amount` | integer | The monetary amount |
| `currency.code` | string | ISO 4217 currency code |
| `currency.display` | string | Full currency name |
| `currency.symbol` | string | Currency symbol |


### Related Resources

*See parent document for relationships to other entities.*

## Data Model