# Mortgage API Design

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
| **Entity Name** | Mortgage |
| **Domain** | Arrangements |
| **Aggregate Root** | Arrangement |
| **Base Path** | `/api/v2/factfinds/{factfindId}/arrangements/mortgages` |
| **Resource Type** | Collection |

### Description

Mortgage arrangements and lending products

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
| GET | `/api/v2/factfinds/{factfindId}/arrangements/mortgages` | List all mortgages | Query params | Mortgage[] | 200, 401, 403 | Mortgage, List |
| POST | `/api/v2/factfinds/{factfindId}/arrangements/mortgages` | Create mortgage | MortgageRequest | Mortgage | 201, 400, 401, 403, 422 | Mortgage, Create |
| GET | `/api/v2/factfinds/{factfindId}/arrangements/mortgages/{arrangementId}` | Get mortgage by ID | Path params | Mortgage | 200, 401, 403, 404 | Mortgage, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/arrangements/mortgages/{arrangementId}` | Update mortgage | MortgagePatch | Mortgage | 200, 400, 401, 403, 404, 422 | Mortgage, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/arrangements/mortgages/{arrangementId}` | Delete mortgage | Path params | None | 204, 401, 403, 404, 422 | Mortgage, Delete |


### Authorization

**Required Scopes:**
- `mortgage:read` - Read access (GET operations)
- `mortgage:write` - Create and update access (POST, PUT, PATCH)
- `mortgage:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary

### Mortgage Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique mortgage identifier |
| `arrangementCategory` | string | ✓ | Category: MORTGAGE |
| `mortgageType` | string | ✓ | Type: Residential, BuyToLet, EquityRelease |
| `provider` | Provider | ✓ | Lender information |
| `accountNumber` | string |  | Mortgage account number |
| `outstandingBalance` | Money | ✓ | Outstanding mortgage balance |
| `interestRate` | decimal | ✓ | Interest rate (%) |
| `owners` | Owner[] | ✓ | Mortgage owners/borrowers |


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