# Note API Design

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
| **Entity Name** | Note |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Client notes and annotations

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
- `note:read` - Read access (GET operations)
- `note:write` - Create and update access (POST, PUT, PATCH)
- `note:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary


### Note Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `attachments` | ListofComplexData |  |  |
| `content` | string |  |  |
| `contentType` | string |  |  |
| `createdAt` | date |  | When this record was created in the system |
| `createdBy` | Complex Data |  | User who created this record |
| `entity` | Reference Link |  |  |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `id` | integer | ✓ | Unique system identifier for this record |
| `isSystemGenerated` | boolean |  |  |
| `isVisibleToClient` | boolean |  |  |
| `noteDiscriminator` | string |  |  |
| `subject` | string |  |  |
| `updatedAt` | date |  | When this record was last modified |


### Related Resources

*See parent document for related entities.*


### Referenced Type Definitions

The following types are referenced in the resource properties above:

### Complex Data Structure

*Nested object structure* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

### Reference Link Structure

*Reference to another entity* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

## Data Model