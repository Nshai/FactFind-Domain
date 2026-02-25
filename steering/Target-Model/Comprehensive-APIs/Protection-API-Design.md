# Protection API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Arrangements

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | Protection |
| **Domain** | Arrangements |
| **Aggregate Root** | Arrangement |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Protection policies

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
- `protection:read` - Read access (GET operations)
- `protection:write` - Create and update access (POST, PUT, PATCH)
- `protection:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary






### Protection Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `adviserDetails` | Complex Data |  |  |
| `arrangementCategory` | string |  | Expenditure category (Housing, Transport, Food, etc.) |
| `beneficiaries` | List of Complex Data |  | List of trust beneficiaries |
| `client` | Reference Link |  |  |
| `createdAt` | date |  | When this record was created in the system |
| `currentSumAssured` | Money |  |  |
| `endDate` | date |  | Employment end date (null if current) |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `id` | integer | ✓ | Unique system identifier for this record |
| `indexation` | Complex Data |  |  |
| `isInTrust` | boolean |  |  |
| `linkedTo` | Complex Data |  |  |
| `notes` | string |  |  |
| `policyNumber` | string |  | Policy or account number |
| `policyType` | string |  |  |
| `premium` | Money |  |  |
| `premiumFrequency` | string |  | How often (Monthly, Annual, etc.) |
| `premiumType` | string |  |  |
| `productName` | string |  | Name of the financial product |
| `protectionType` | string |  |  |
| `providerName` | string |  | Unique system identifier for this record |
| `provider` | Reference Link |  | Unique system identifier for this record |
| `reviewDate` | date |  | When these figures were last reviewed |
| `startDate` | date |  | Employment start date |
| `sumAssured` | Money |  |  |
| `termRemaining` | Complex Data |  |  |
| `trustDetails` | Complex Data |  |  |
| `underwriting` | Complex Data |  |  |
| `updatedAt` | date |  | When this record was last modified |

*Total: 29 properties*


### Related Resources

*See parent document for relationships to other entities.*


## Data Model