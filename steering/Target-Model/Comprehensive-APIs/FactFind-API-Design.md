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
| `id` | integer | ✓ | Unique system identifier for this record |
| `href` | string | ✓ | API link to this resource |
| `meeting` | Complex Data |  | Meeting information including date, type, and attendees |
| `products` | Complex Data |  | Products and services discussed during fact find (investments, pensions, mortgages, protections) |
| `disclosureKeyfacts` | List of Complex Data |  | Disclosure documents issued to clients |
| `employmentSummary` | List of Complex Data |  | Summary of client employment and income information |
| `supplementaryQuestions` | List of Complex Data |  | Additional questions organized by category |
| `assetsAndLiabilities` | Complex Data |  | Client asset and liability disclosures |
| `creditHistory` | Complex Data |  | Client credit history information |
| `estatePlanning` | Complex Data |  | Estate planning details including will, assets, and gifts |

*Total: 10 properties*


### Related Resources

*See parent document for relationships to other entities.*


## Data Model