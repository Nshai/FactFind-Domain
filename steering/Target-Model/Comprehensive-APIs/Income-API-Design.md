# Income API Design

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
| **Entity Name** | Income |
| **Domain** | Circumstances |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Income sources and earnings

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
- `income:read` - Read access (GET operations)
- `income:write` - Create and update access (POST, PUT, PATCH)
- `income:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary


### Income Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `client` | Reference Link |  |  |
| `createdAt` | date |  | When this record was created in the system |
| `description` | string |  | Description of the goal |
| `employment` | Reference Link |  |  |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `frequency` | Selection |  | How often (Monthly, Annual, etc.) |
| `grossAmount` | Money |  | Amount spent |
| `id` | integer | ✓ | Unique system identifier for this record |
| `incomePeriod` | Complex Data |  |  |
| `incomeType` | string |  |  |
| `isTaxable` | boolean |  | Is this income taxable? Some income like Child Benefit or ISA interest may be tax-free. |
| `asset` | LinktoAsset |  | Link to the asset (property, investment, business) that generates this income. For example, renta... |
| `isGuaranteed` | boolean |  |  |
| `isOngoing` | boolean |  |  |
| `isPrimary` | boolean |  | Whether this is the primary/main address |
| `nationalInsuranceDeducted` | Money |  |  |
| `netAmount` | Money |  | Amount spent |
| `notes` | string |  |  |
| `taxDeducted` | Money |  |  |
| `updatedAt` | date |  | When this record was last modified |


### Related Resources

*See parent document for related entities.*


### Referenced Type Definitions

The following types are referenced in the resource properties above:

### Selection Structure

*Enumeration with code and display* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

### Reference Link Structure

*Reference to another entity* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

### Money Structure

*Currency amount with code* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

### Complex Data Structure

*Nested object structure* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

## Data Model