# Pension API Design

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
| **Entity Name** | Pension |
| **Domain** | Arrangements |
| **Aggregate Root** | Arrangement |
| **Base Path** | `/api/v2/factfinds/{factfindId}/arrangements/pensions` |
| **Resource Type** | Collection |

### Description

Pension arrangements (personal, SIPP, final salary)

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
| GET | `/api/v2/factfinds/{factfindId}/arrangements/pensions` | List all pensions | Query params | Pension[] | 200, 401, 403 | Pension, List |
| POST | `/api/v2/factfinds/{factfindId}/arrangements/pensions/{pensionType}` | Create pension by type | PensionRequest | Pension | 201, 400, 401, 403, 422 | Pension, Create |
| GET | `/api/v2/factfinds/{factfindId}/arrangements/pensions/{pensionType}/{arrangementId}` | Get pension by ID | Path params | Pension | 200, 401, 403, 404 | Pension, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/arrangements/pensions/{pensionType}/{arrangementId}` | Update pension | PensionPatch | Pension | 200, 400, 401, 403, 404, 422 | Pension, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/arrangements/pensions/{pensionType}/{arrangementId}` | Delete pension | Path params | None | 204, 401, 403, 404, 422 | Pension, Delete |


### Authorization

**Required Scopes:**
- `pension:read` - Read access (GET operations)
- `pension:write` - Create and update access (POST, PUT, PATCH)
- `pension:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary

### Pension Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique pension identifier |
| `arrangementCategory` | string | ✓ | Category: PENSION |
| `pensionType` | string | ✓ | Type: PersonalPension, SIPP, FinalSalary, etc. |
| `provider` | Provider | ✓ | Provider information |
| `policyNumber` | string |  | Policy number |
| `currentValue` | Money | ✓ | Current pension value |
| `owners` | Owner[] | ✓ | Pension owners |
| `status` | string | ✓ | Status: ACTIVE, DEFERRED, IN_PAYMENT, etc. |


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