# Identity-Verification API Design

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
| **Entity Name** | Identity-Verification |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

KYC/AML identity verification

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
- `identity_verification:read` - Read access (GET operations)
- `identity_verification:write` - Create and update access (POST, PUT, PATCH)
- `identity_verification:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary


### Identity Verification Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `href` | string |  | Resource URL |
| `client` | Complex Data |  | Client personal information |
| `contacts` | ListofComplexData |  | Contact methods |
| `currentAddress` | Complex Data |  | Current residential address |
| `previousAddresses` | ListofComplexData |  | Address history |
| `clientIdentity` | Complex Data |  | Identity documents |
| `supportingDocuments` | ListofReferenceLink |  | Uploaded document references |
| `adviser` | Reference Link |  | Adviser who performed verification |
| `verification` | Complex Data |  | Witness and premises verification |
| `verificationResult` | Complex Data |  | Third-party verification result |
| `comments` | string |  | Additional notes |
| `createdAt` | timestamp |  | Record creation timestamp |
| `updatedAt` | timestamp |  | Last update timestamp |
| `createdBy` | string |  | User who created the record |
| `updatedBy` | string |  | User who last updated the record |


### Related Resources

*See parent document for related entities.*


### Referenced Type Definitions

The following types are referenced in the resource properties above:

### Complex Data Structure

*Nested object structure* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

### Reference Link Structure

*Reference to another entity* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

## Data Model