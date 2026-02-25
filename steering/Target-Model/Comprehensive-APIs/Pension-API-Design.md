# Pension API Design

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
| **Entity Name** | Pension |
| **Domain** | Arrangements |
| **Aggregate Root** | Arrangement |
| **Base Path** | `/api/v2/factfinds/{factfindId}/arrangements/pensions` |
| **Resource Type** | Collection |

### Description

Pension arrangements (personal, SIPP, final salary)

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
| GET | `/api/v2/factfinds/{factfindId}/arrangements/pensions` | List all pensions | Query params | Pension[] | 200, 401, 403 | Pension, List |
| POST | `/api/v2/factfinds/{factfindId}/arrangements/pensions/{pensionType}` | Create pension by type | PensionRequest | Pension | 201, 400, 401, 403, 422 | Pension, Create |
| GET | `/api/v2/factfinds/{factfindId}/arrangements/pensions/{pensionType}/{arrangementId}` | Get pension by ID | Path params | Pension | 200, 401, 403, 404 | Pension, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/arrangements/pensions/{pensionType}/{arrangementId}` | Update pension | PensionPatch | Pension | 200, 400, 401, 403, 404, 422 | Pension, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/arrangements/pensions/{pensionType}/{arrangementId}` | Delete pension | Path params | None | 204, 401, 403, 404, 422 | Pension, Delete |


### Authorization

**Required Scopes:**
- `pension:read` - Read access (GET operations)
- `pension:write` - Create and update access (POST, PUT, PATCH)
- `pension:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary



### Pension Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `adviser` | Reference Link |  | The adviser responsible for this client |
| `arrangementCategory` | string |  | Type of arrangement (INVESTMENT, PENSION, MORTGAGE, PROTECTION) |
| `arrangementNumber` | string |  |  |
| `arrangementPeriod` | Complex Data |  |  |
| `owners` | List of Complex Data |  | Who owns this arrangement |
| `contributionFrequency` | Selection |  | How often (Monthly, Annual, etc.) |
| `createdAt` | date |  | When this record was created in the system |
| `currentValue` | Money |  | Current value of the arrangement |
| `expectedRetirementAge` | integer |  | Current age (calculated from date of birth) |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `hasGuaranteedAnnuityRate` | boolean |  |  |
| `hasProtectedTaxFreeAmount` | boolean |  | Whether pension has protected tax-free amount |
| `id` | integer | ✓ | Unique system identifier for this record |
| `isInDrawdown` | boolean |  |  |
| `isSalarySacrifice` | boolean |  | Whether pension contributions are via salary sacrifice |
| `notes` | string |  |  |
| `pensionType` | string |  | Sub-type when arrangementCategory=PENSION |
| `investmentType` | string |  | Sub-type when arrangementCategory=INVESTMENT |
| `mortgageType` | string |  | Sub-type when arrangementCategory=MORTGAGE |
| `protectionType` | string |  | Sub-type when arrangementCategory=PROTECTION |
| `policyNumber` | string |  | Policy or account number |
| `productName` | string |  | Name of the financial product |
| `projectedValueAtRetirement` | Money |  | The contact value (email address, phone number, etc.) |
| `provider` | Reference Link |  | Unique system identifier for this record |
| `regularContribution` | Money |  |  |
| `status` | string |  | Current status of the goal |
| `updatedAt` | date |  | When this record was last modified |
| `valuationDate` | date |  |  |

*Total: 28 properties*


### Referenced Type Definitions

The following complex types are used in the properties above:

#### adviser

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Standard Occupational Classification (SOC) code |
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |

#### arrangementPeriod

| Field | Type | Description |
|-------|------|-------------|
| `endDate` | string | Employment end date (null if current) |
| `startDate` | date | Employment start date |

#### contributionFrequency

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `periodsPerYear` | integer |  |

#### current

| Field | Type | Description |
|-------|------|-------------|
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `symbol` | string |  |

#### factfind

| Field | Type | Description |
|-------|------|-------------|
| `factFindNumber` | string |  |
| `id` | integer | Unique system identifier for this record |
| `status` | string | Current status of the goal |

#### projectedAtRetirement

| Field | Type | Description |
|-------|------|-------------|
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `symbol` | string |  |

#### provider

| Field | Type | Description |
|-------|------|-------------|
| `frnNumber` | string |  |
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |

#### regularContribution

| Field | Type | Description |
|-------|------|-------------|
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |


### Related Resources

*See parent document for relationships to other entities.*

## Data Model