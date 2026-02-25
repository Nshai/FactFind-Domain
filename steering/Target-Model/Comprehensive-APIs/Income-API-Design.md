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
| `asset` | Link to Asset |  | Link to the asset (property, investment, business) that generates this income. For example, rental income links to th... |
| `isGuaranteed` | boolean |  |  |
| `isOngoing` | boolean |  |  |
| `isPrimary` | boolean |  | Whether this is the primary/main address |
| `nationalInsuranceDeducted` | Money |  |  |
| `netAmount` | Money |  | Amount spent |
| `notes` | string |  |  |
| `taxDeducted` | Money |  |  |
| `updatedAt` | date |  | When this record was last modified |

*Total: 20 properties*


### Referenced Type Definitions

The following complex types are used in the properties above:

#### asset

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier for the asset that generates this income |
| `href` | string | Link to the asset resource |
| `assetType` | string | Type of asset (Property, Investment, Business, Other) |
| `description` | string | Description of the asset |
| `Rental Income` | Property | Links to residential or commercial property generating rental income |
| `Dividend Income` | Investment | Links to stocks, shares, or investment accounts paying dividends |
| `Interest Income` | Savings/Investment | Links to bank accounts, bonds, or other interest-bearing investments |

#### client

| Field | Type | Description |
|-------|------|-------------|
| `clientNumber` | string | Client reference number assigned by your organization |
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |
| `type` | string | Type of client: Person (individual), Corporate (company), or Trust |

#### employment

| Field | Type | Description |
|-------|------|-------------|
| `employerName` | string | Name of the employer |
| `id` | integer | Unique system identifier for this record |
| `status` | string | Current status of the goal |

#### factfind

| Field | Type | Description |
|-------|------|-------------|
| `factFindNumber` | string |  |
| `id` | integer | Unique system identifier for this record |
| `status` | string | Current status of the goal |

#### frequency

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `periodsPerYear` | integer |  |

#### grossAmount

| Field | Type | Description |
|-------|------|-------------|
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `symbol` | string |  |

#### incomePeriod

| Field | Type | Description |
|-------|------|-------------|
| `endDate` | string | Employment end date (null if current) |
| `startDate` | date | Employment start date |

#### nationalInsuranceDeducted

| Field | Type | Description |
|-------|------|-------------|
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `symbol` | string |  |

#### netAmount

| Field | Type | Description |
|-------|------|-------------|
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `symbol` | string |  |

#### taxDeducted

| Field | Type | Description |
|-------|------|-------------|
| `amount` | integer | Amount spent |
| `currency` | Selection |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `symbol` | string |  |


### Related Resources

*See parent document for relationships to other entities.*

## Data Model