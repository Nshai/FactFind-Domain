# Relationship API Design

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
| **Entity Name** | Relationship |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Client-to-client relationships

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
- `relationship:read` - Read access (GET operations)
- `relationship:write` - Create and update access (POST, PUT, PATCH)
- `relationship:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary





### Relationship Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique identifier for the relationship |
| `href` | string |  | Resource URL for this relationship |
| `client` | Reference Link |  | The primary client in this relationship |
| `factfind` | Reference Link |  | FactFind reference |
| `relatedClient` | Reference Link |  | The related client |
| `relationshipType` | Enum (Text) |  | Type of relationship. See enumerations below |
| `partner` | boolean |  | Whether this is a partner/spouse relationship |
| `familyGrouping` | boolean |  | Whether to include in family grouping/household reporting |
| `canRelatedViewClientsPlansAssets` | boolean |  | Can related client view this client's plans and assets? |
| `canClientViewRelatedsPlansAssets` | boolean |  | Can this client view related client's plans and assets? |
| `canRelatedAccessClientsData` | boolean |  | Can related client access/modify this client's data? |
| `canClientAccessRelatedsData` | boolean |  | Can this client access/modify related client's data? |
| `createdAt` | timestamp |  | When this record was created (read-only) |
| `updatedAt` | timestamp |  | When this record was last updated (read-only) |
| `createdBy` | string |  | User who created this record (read-only) |
| `updatedBy` | string |  | User who last updated this record (read-only) |

*Total: 16 properties*


### Referenced Type Definitions

The following complex types are used in the properties above:

#### client

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique client identifier |
| `href` | string | Client resource URL |
| `name` | string | Client name |

#### factfind

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique FactFind identifier |
| `href` | string | FactFind resource URL |

#### relatedClient

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique client identifier |
| `href` | string | Client resource URL |
| `name` | string | Client name |


### Related Resources

*See parent document for relationships to other entities.*

## Data Model