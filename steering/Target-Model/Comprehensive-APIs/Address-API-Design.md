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
| **Base Path** | `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses` |
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
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses` | List client addresses | Query params | Address[] | 200, 401, 403, 404 | Address, List |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses` | Add new address | AddressRequest | Address | 201, 400, 401, 403, 404, 422 | Address, Create |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses/{addressId}` | Get address by ID | Path params | Address | 200, 401, 403, 404 | Address, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses/{addressId}` | Update address | AddressPatch | Address | 200, 400, 401, 403, 404, 422 | Address, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/addresses/{addressId}` | Delete address | Path params | None | 204, 401, 403, 404, 422 | Address, Delete |


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
| `id` | integer | ✓ | Unique address identifier |
| `addressType` | string | ✓ | Type: Current, Previous |
| `line1` | string | ✓ | Address line 1 |
| `line2` | string |  | Address line 2 |
| `locality` | string | ✓ | Town/City |
| `postalCode` | string | ✓ | Postal code |
| `country` | Country | ✓ | Country object with isoCode |
| `movedInDate` | date |  | Date moved in |
| `movedOutDate` | date |  | Date moved out |


### Related Resources

**Parent Resource:** Client

**Related APIs:**
- See [Master API Design - Section 11](./MASTER-API-DESIGN.md#11-entity-apis-by-domain) for related APIs in the Client Management domain

---


### Referenced Type Definitions

The following types are referenced in the resource properties above:

### Country Structure

| Field | Type | Description |
|-------|------|-------------|
| `alpha3` | string |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |

## Data Model