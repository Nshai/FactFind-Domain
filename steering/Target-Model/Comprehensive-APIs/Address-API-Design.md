# Address API Design

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
| **Entity Name** | Address |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v3/factfinds/{factfindId}/clients/{clientId}/addresses` |
| **Resource Type** | Collection |

### Description

Client address management (current and historical)

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
| GET | `/api/v3/factfinds/{factfindId}/clients/{clientId}/addresses` | List client addresses | Query params | Address[] | 200, 401, 403, 404 | Address, List |
| POST | `/api/v3/factfinds/{factfindId}/clients/{clientId}/addresses` | Add new address | AddressRequest | Address | 201, 400, 401, 403, 404, 422 | Address, Create |
| GET | `/api/v3/factfinds/{factfindId}/clients/{clientId}/addresses/{addressId}` | Get address by ID | Path params | Address | 200, 401, 403, 404 | Address, Retrieve |
| PATCH | `/api/v3/factfinds/{factfindId}/clients/{clientId}/addresses/{addressId}` | Update address | AddressPatch | Address | 200, 400, 401, 403, 404, 422 | Address, Update |
| DELETE | `/api/v3/factfinds/{factfindId}/clients/{clientId}/addresses/{addressId}` | Delete address | Path params | None | 204, 401, 403, 404, 422 | Address, Delete |


### Authorization

**Required Scopes:**
- `address:read` - Read access (GET operations)
- `address:write` - Create and update access (POST, PUT, PATCH)
- `address:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary





### Address Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `address` | Complex Data |  | List of all addresses for this client (current and historical) |
| `addressType` | string |  | Type of address (Residential, Previous, Business, etc.) |
| `client` | Reference Link |  |  |
| `createdAt` | date |  | When this record was created in the system |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `id` | integer | ✓ | Unique system identifier for this record |
| `isCorrespondenceAddress` | boolean |  |  |
| `isOnElectoralRoll` | boolean |  |  |
| `residencyPeriod` | Complex Data |  | Unique system identifier for this record |
| `residencyStatus` | string |  | Unique system identifier for this record |
| `updatedAt` | date |  | When this record was last modified |

*Total: 11 properties*


### Related Resources

*See parent document for relationships to other entities.*


## Data Model