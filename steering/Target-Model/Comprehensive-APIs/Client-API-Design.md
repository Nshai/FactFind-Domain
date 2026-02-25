# Client API Design

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
| **Entity Name** | Client |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/factfinds/{factfindId}/clients` |
| **Resource Type** | Collection |

### Description

Core client identity and profile management

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
| GET | `/api/v2/factfinds/{factfindId}/clients` | List all clients in factfind | Query params | Client[] | 200, 401, 403 | Client, List |
| POST | `/api/v2/factfinds/{factfindId}/clients` | Create new client | ClientRequest | Client | 201, 400, 401, 403, 422 | Client, Create |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}` | Get client by ID | Path params | Client | 200, 401, 403, 404 | Client, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}` | Update client details | ClientPatch | Client | 200, 400, 401, 403, 404, 422 | Client, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}` | Delete client | Path params | None | 204, 401, 403, 404, 422 | Client, Delete |


### Authorization

**Required Scopes:**
- `client:read` - Read access (GET operations)
- `client:write` - Create and update access (POST, PUT, PATCH)
- `client:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary





### Client Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `adviser` | Reference Link |  | The adviser responsible for this client |
| `clientCategory` | string |  | Client category (e.g., HighNetWorth, Mass Market) |
| `clientNumber` | string |  | Client reference number assigned by your organization |
| `clientSegment` | string |  | Client segment classification (A, B, C, D for prioritization) |
| `clientSegmentDate` | date |  | Client segment classification (A, B, C, D for prioritization) |
| `clientType` | string |  | Type of client: Person (individual), Corporate (company), or Trust |
| `createdAt` | date |  | When this record was created in the system |
| `createdBy` | Complex Data |  | User who created this record |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `id` | integer | ✓ | Unique system identifier for this record |
| `isHeadOfFamilyGroup` | boolean |  | Whether this client is the primary contact for the family group |
| `isJoint` | boolean |  | Whether this client is part of a joint (couple) fact find |
| `isMatchingServiceProposition` | boolean |  | Whether this client requires matching service due to vulnerability |
| `matchingServicePropositionReason` | string |  |  |
| `officeRef` | Complex Data |  | The office/branch where this client is managed |
| `paraplannerRef` | Reference Link |  | The paraplanner assigned to this client |
| `personValue` | Complex Data |  | Personal information (only for individual clients) |
| `serviceStatus` | string |  | Current service status (Active, Inactive, Prospect, etc.) |
| `serviceStatusDate` | date |  | Current service status (Active, Inactive, Prospect, etc.) |
| `spouseRef` | Reference Link |  | Link to the spouse/partner client record (for joint fact finds) |
| `territorialProfile` | Complex Data |  | Residency, domicile, citizenship, and territorial tax status |
| `updatedAt` | date |  | When this record was last modified |
| `updatedBy` | Complex Data |  | User who last modified this record |

*Total: 23 properties*


### Related Resources

*See parent document for relationships to other entities.*


## Data Model