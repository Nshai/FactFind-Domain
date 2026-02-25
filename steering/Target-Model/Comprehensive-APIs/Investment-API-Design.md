# Investment API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Arrangements

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | Investment |
| **Domain** | Arrangements |
| **Aggregate Root** | Arrangement |
| **Base Path** | `/api/v2/factfinds/{factfindId}/arrangements/investments` |
| **Resource Type** | Collection |

### Description

Investment arrangements (GIA, ISA, bonds, cash)

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
| GET | `/api/v2/factfinds/{factfindId}/arrangements/investments` | List all investments | Query params | Investment[] | 200, 401, 403 | Investment, List |
| POST | `/api/v2/factfinds/{factfindId}/arrangements/investments/{investmentType}` | Create investment by type | InvestmentRequest | Investment | 201, 400, 401, 403, 422 | Investment, Create |
| GET | `/api/v2/factfinds/{factfindId}/arrangements/investments/{investmentType}` | List investments by type | Query params | Investment[] | 200, 401, 403 | Investment, List |
| GET | `/api/v2/factfinds/{factfindId}/arrangements/investments/{investmentType}/{arrangementId}` | Get investment by ID | Path params | Investment | 200, 401, 403, 404 | Investment, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/arrangements/investments/{investmentType}/{arrangementId}` | Update investment | InvestmentPatch | Investment | 200, 400, 401, 403, 404, 422 | Investment, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/arrangements/investments/{investmentType}/{arrangementId}` | Delete investment | Path params | None | 204, 401, 403, 404, 422 | Investment, Delete |


### Authorization

**Required Scopes:**
- `investment:read` - Read access (GET operations)
- `investment:write` - Create and update access (POST, PUT, PATCH)
- `investment:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary

### Investment Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique investment identifier |
| `arrangementCategory` | string | ✓ | Category: INVESTMENT |
| `investmentType` | string | ✓ | Type: GIA, ISA, Bond, Cash, etc. |
| `provider` | Provider | ✓ | Provider information |
| `policyNumber` | string |  | Policy/account number |
| `currentValue` | Money | ✓ | Current investment value |
| `owners` | Owner[] | ✓ | Investment owners |
| `status` | string | ✓ | Status: ACTIVE, CLOSED, etc. |


### Related Resources

**Parent Resource:** Arrangement

**Related APIs:**
- See [Master API Design - Section 11](./MASTER-API-DESIGN.md#11-entity-apis-by-domain) for related APIs in the Arrangements domain

---


### Referenced Type Definitions

The following types are referenced in the resource properties above:

### Provider Structure

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for this record |

### Money Structure

*Currency amount with code* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

## Data Model