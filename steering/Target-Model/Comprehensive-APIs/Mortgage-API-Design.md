# Mortgage API Design

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
| **Entity Name** | Mortgage |
| **Domain** | Arrangements |
| **Aggregate Root** | Arrangement |
| **Base Path** | `/api/v2/factfinds/{factfindId}/arrangements/mortgages` |
| **Resource Type** | Collection |

### Description

Mortgage arrangements and lending products

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
| GET | `/api/v2/factfinds/{factfindId}/arrangements/mortgages` | List all mortgages | Query params | Mortgage[] | 200, 401, 403 | Mortgage, List |
| POST | `/api/v2/factfinds/{factfindId}/arrangements/mortgages` | Create mortgage | MortgageRequest | Mortgage | 201, 400, 401, 403, 422 | Mortgage, Create |
| GET | `/api/v2/factfinds/{factfindId}/arrangements/mortgages/{arrangementId}` | Get mortgage by ID | Path params | Mortgage | 200, 401, 403, 404 | Mortgage, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/arrangements/mortgages/{arrangementId}` | Update mortgage | MortgagePatch | Mortgage | 200, 400, 401, 403, 404, 422 | Mortgage, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/arrangements/mortgages/{arrangementId}` | Delete mortgage | Path params | None | 204, 401, 403, 404, 422 | Mortgage, Delete |


### Authorization

**Required Scopes:**
- `mortgage:read` - Read access (GET operations)
- `mortgage:write` - Create and update access (POST, PUT, PATCH)
- `mortgage:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary





### Mortgage Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `accountNumber` | string |  |  |
| `agencyStatus` | string |  | Current age (calculated from date of birth) |
| `agencyStatusDate` | date |  | Current age (calculated from date of birth) |
| `arrangementCategory` | string |  | Expenditure category (Housing, Transport, Food, etc.) |
| `asset` | Reference Link |  | Total value of all assets |
| `createdAt` | date |  | When this record was created in the system |
| `description` | string |  | Description of the goal |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `feesAndCharges` | Complex Data |  |  |
| `id` | integer | ✓ | Unique system identifier for this record |
| `illustrationReference` | string |  |  |
| `interestTerms` | Complex Data |  |  |
| `keyDates` | Complex Data |  |  |
| `lenderName` | string |  |  |
| `linkedArrangements` | List of Complex Data |  |  |
| `loanAmounts` | Complex Data |  | Amount spent |
| `notes` | string |  |  |
| `offsetFeatures` | Complex Data |  |  |
| `owners` | List of Complex Data |  | Who owns this arrangement |
| `policyNumber` | string |  | Policy or account number |
| `productName` | string |  | Name of the financial product |
| `productType` | string |  |  |
| `property` | Reference Link |  | Type of property (Residential, Buy-to-Let, Commercial, etc.) |
| `propertyDetail` | Reference Link |  |  |
| `redemptionTerms` | Complex Data |  |  |
| `repaymentStructure` | Complex Data |  |  |
| `sellingAdviser` | Reference Link |  |  |
| `sharedOwnershipDetails` | Complex Data |  | Who owns this arrangement |
| `specialFeatures` | Complex Data |  |  |
| `updatedAt` | date |  | When this record was last modified |

*Total: 30 properties*


### Related Resources

*See parent document for relationships to other entities.*


## Data Model