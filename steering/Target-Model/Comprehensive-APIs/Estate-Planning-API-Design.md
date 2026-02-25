# Estate-Planning API Design

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
| **Entity Name** | Estate-Planning |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Estate planning, wills, gifts

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
- `estate_planning:read` - Read access (GET operations)
- `estate_planning:write` - Create and update access (POST, PUT, PATCH)
- `estate_planning:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary


### Estate Planning Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `href` | string |  | Resource URL for this estate planning record |
| `client` | Reference Link |  | Client reference |
| `factfind` | Reference Link |  | FactFind reference |
| `willDetails` | string |  | Free-text description of will arrangements |
| `totalAssets` | Money |  | Total value of client's estate |
| `totalJointAssets` | Money |  | Total value of jointly owned assets |
| `giftInLast7YearsDetails` | string |  | Description of gifts made in last 7 years |
| `recentGiftDetails` | string |  | Description of recent gifts (current tax year) |
| `regularGiftDetails` | string |  | Description of regular gifts from income |
| `expectingInheritanceDetails` | string |  | Description of expected inheritance |
| `propertyAdditionalNrb` | Money |  | Residence nil rate band (max £175,000) |
| `taxYearWhenPropertySold` | integer |  | Tax year when main residence was sold (if applicable) |
| `widowsReliefNrbDeceasedPercentage` | Number(Percentage) |  | Percentage of deceased spouse's NRB available to transfer |
| `widowsReliefPropertyAdditionalNrbDeceasedPercentage` | Number(Percentage) |  | Percentage of deceased spouse's RNRB available to transfer |
| `businessAssetRelief` | Money |  | Business property relief available |
| `gifts` | ListofComplexData |  | Collection of gifts (see Gift contract) |
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