# Dependant API Design

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
| **Entity Name** | Dependant |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Financial dependants management

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
- `dependant:read` - Read access (GET operations)
- `dependant:write` - Create and update access (POST, PUT, PATCH)
- `dependant:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary






### Dependant Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `age` | integer |  | Current age (calculated from date of birth) |
| `clients` | List of Complex Data |  | Client segment classification (A, B, C, D for prioritization) |
| `createdAt` | date |  | When this record was created in the system |
| `dateOfBirth` | date |  | Date of birth |
| `dependencyDetails` | Complex Data |  |  |
| `educationDetails` | Complex Data |  |  |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `firstName` | string |  | First name (given name) |
| `fullName` | string |  | Complete formatted name including title |
| `gender` | string |  | Gender (M=Male, F=Female, O=Other, X=Prefer not to say) |
| `healthDetails` | Complex Data |  |  |
| `id` | integer | ✓ | Unique system identifier for this record |
| `isFinanciallyDependent` | boolean |  |  |
| `lastName` | string |  | Last name (surname/family name) |
| `livingArrangements` | Complex Data |  |  |
| `middleNames` | string |  | Middle name(s) |
| `notes` | string |  |  |
| `relationship` | string |  |  |
| `updatedAt` | date |  | When this record was last modified |

*Total: 19 properties*


### Related Resources

*See parent document for relationships to other entities.*


## Data Model