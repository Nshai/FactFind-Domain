# Financial-Profile API Design

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
| **Entity Name** | Financial-Profile |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Client financial profile summary

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
- `financial_profile:read` - Read access (GET operations)
- `financial_profile:write` - Create and update access (POST, PUT, PATCH)
- `financial_profile:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary


### Financial Profile Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `client` | Reference Link |  | Client reference |
| `factfind` | Reference Link |  | FactFind reference |
| `grossAnnualIncome` | Money |  | Total gross annual income before tax |
| `netAnnualIncome` | Money |  | Total net annual income after tax |
| `totalAssets` | Money |  | Total value of all assets |
| `totalLiabilities` | Money |  | Total value of all liabilities |
| `netWorth` | Money |  | Total net worth (assets minus liabilities) |
| `householdIncome` | Money |  | Combined household income (all clients) |
| `householdNetWorth` | Money |  | Combined household net worth |
| `totalJointAssets` | Money |  | Total value of jointly owned assets |
| `calculatedAt` | timestamp |  | When these figures were calculated |
| `lastReviewDate` | date |  | When these figures were last reviewed |
| `createdAt` | timestamp |  | When this record was created (read-only) |
| `updatedAt` | timestamp |  | When this record was last updated (read-only) |


### Related Resources

*See parent document for related entities.*


### Referenced Type Definitions

The following types are referenced in the resource properties above:

### Money Structure

*Currency amount with code* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

### Reference Link Structure

*Reference to another entity* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

## Data Model