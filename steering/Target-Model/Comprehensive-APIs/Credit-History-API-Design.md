# Credit-History API Design

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
| **Entity Name** | Credit-History |
| **Domain** | Circumstances |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Credit history and scores

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
- `credit_history:read` - Read access (GET operations)
- `credit_history:write` - Create and update access (POST, PUT, PATCH)
- `credit_history:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary







### Credit-History Resource Properties

*Fields organized into 8 sections*

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| **Identification** | | | |
| `id` | integer | ✓ | Unique system identifier for this credit history record |
| `href` | string |  | Web link to access this credit history record |
| `factfind` | Reference Link |  | Link to the FactFind this credit history belongs to |
| `client` | Reference Link |  | Link to the client this credit history belongs to |
| **Credit Score Assessment** | | | |
| `creditScore` | Complex Data |  | Credit score information from Credit Reference Agency |
| **Adverse Credit Indicators (Summary)** | | | |
| `hasAdverseCredit` | boolean |  | Does the client have any adverse credit events on their record? |
| `hasCCJ` | boolean |  | Does the client have any County Court Judgments? |
| `hasBeenRefusedCredit` | boolean |  | Has the client been refused credit in the past? |
| `ivaHistory` | boolean |  | Does the client have an Individual Voluntary Arrangement (IVA) history? |
| `hasDefault` | boolean |  | Does the client have any defaults registered on their credit file? |
| `hasBankruptcyHistory` | boolean |  | Does the client have bankruptcy history? |
| `hasArrears` | boolean |  | Does the client currently have or have had payment arrears? |
| **Adverse Credit Events (Detailed Records)** | | | |
| `adverseCreditEvents` | List of Events |  | Detailed list of adverse credit events with financial and timeline information |
| **Missed Payments Summary** | | | |
| `missedPayments` | Complex Data |  | Summary of missed payment history |
| **Mortgage Suitability Assessment** | | | |
| `mortgageSuitability` | Complex Data |  | Automated assessment of mortgage lending eligibility |
| **Additional Information** | | | |
| `notes` | string |  | Free-text notes about credit history, mitigating circumstances, or additional context (max 2000 characters) |
| **System Fields** | | | |
| `createdAt` | timestamp |  | When this credit history record was created in the system |
| `updatedAt` | timestamp |  | When this credit history record was last modified |

*Total: 18 properties*


### Related Resources

*See parent document for relationships to other entities.*


## Data Model