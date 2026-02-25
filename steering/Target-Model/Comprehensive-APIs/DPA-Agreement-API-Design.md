# DPA-Agreement API Design

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
| **Entity Name** | DPA-Agreement |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Data Processing Agreements

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
- `dpa_agreement:read` - Read access (GET operations)
- `dpa_agreement:write` - Create and update access (POST, PUT, PATCH)
- `dpa_agreement:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary




### DPA-Agreement Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique identifier for the DPA agreement |
| `href` | string |  | Resource URL for this agreement |
| `client` | Reference Link |  | Reference to the client |
| `factfind` | Reference Link |  | Reference to the factfind |
| `policy` | Reference Link |  | Reference to the DPA policy |
| `agreedAt` | timestamp |  | When the client agreed to the policy |
| `statements` | Complex Data |  | Policy statements and responses |
| `createdAt` | timestamp |  | When this agreement was created (read-only) |
| `createdBy` | string |  | User who created this agreement (read-only) |

*Total: 9 properties*


### Referenced Type Definitions

The following complex types are used in the properties above:

#### client

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique client identifier |
| `href` | string | Client resource URL |

#### factfind

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique FactFind identifier |
| `href` | string | FactFind resource URL |

#### policy

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique policy identifier |
| `name` | string | Policy name (read-only) |
| `href` | string | Policy resource URL |


### Related Resources

*See parent document for relationships to other entities.*

## Data Model