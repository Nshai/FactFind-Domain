# FactFind API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** FactFind Root

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | FactFind |
| **Domain** | FactFind Root |
| **Aggregate Root** | FactFind |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Root FactFind aggregate

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
- `factfind:read` - Read access (GET operations)
- `factfind:write` - Create and update access (POST, PUT, PATCH)
- `factfind:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary


### FactFind Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `additionalNotes` | string |  |  |
| `adviser` | Reference Link |  | The adviser responsible for this client |
| `assetHoldings` | Complex Data |  |  |
| `atrAssessment` | Complex Data |  |  |
| `client` | Reference Link |  |  |
| `completionStatus` | Complex Data |  | Current status of the goal |
| `createdAt` | date |  | When this record was created in the system |
| `customQuestions` | ListofComplexData |  |  |
| `factFindNumber` | string |  |  |
| `financialSummary` | Complex Data |  |  |
| `id` | integer | ✓ | Unique system identifier for this record |
| `investmentCapacity` | Complex Data |  | City/town |
| `jointClientRef` | Reference Link |  |  |
| `meetingDetails` | Complex Data |  |  |
| `notes` | string |  |  |
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