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




### Identity-Verification Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `href` | string |  | Resource URL |
| `client` | Complex Data |  | Client personal information |
| `contacts` | List of Complex Data |  | Contact methods |
| `currentAddress` | Complex Data |  | Current residential address |
| `previousAddresses` | List of Complex Data |  | Address history |
| `clientIdentity` | Complex Data |  | Identity documents |
| `supportingDocuments` | List of Reference Link |  | Uploaded document references |
| `adviser` | Reference Link |  | Adviser who performed verification |
| `verification` | Complex Data |  | Witness and premises verification |
| `verificationResult` | Complex Data |  | Third-party verification result |
| `comments` | string |  | Additional notes |
| `createdAt` | timestamp |  | Record creation timestamp |
| `updatedAt` | timestamp |  | Last update timestamp |
| `createdBy` | string |  | User who created the record |
| `updatedBy` | string |  | User who last updated the record |

*Total: 15 properties*


### Referenced Type Definitions

The following complex types are used in the properties above:

#### adviser

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Adviser ID |
| `href` | string | Adviser resource URL |

#### client

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique client identifier |
| `href` | string | Client resource URL |
| `title` | string | Title (Mr, Mrs, Ms, etc.) |
| `firstName` | string | First name |
| `middleName` | string | Middle name |
| `lastName` | string | Last name |
| `gender` | string | Gender |
| `dateOfBirth` | timestamp | Date of birth |
| `mothersMaidenName` | string | Mother's maiden name |
| `placeOfBirth` | string | Place of birth |
| `countryOfBirth` | Complex Data | Country of birth code |
| `code` | string | ISO country code |
| `placeOfBirthOther` | string | Additional birth location details |

#### clientIdentity

| Field | Type | Description |
|-------|------|-------------|
| `passport` | Complex Data | Passport details |
| `referenceNo` | string | Passport number |
| `seenOn` | timestamp | Date document seen |
| `expiryOn` | timestamp | Expiry date |
| `countryOfOrigin` | Complex Data | Issuing country |
| `code` | string | ISO country code |
| `drivingLicence` | Complex Data | Driving licence details |
| `referenceNo` | string | Licence number |
| `seenOn` | timestamp | Date document seen |
| `expiryOn` | timestamp | Expiry date |
| `countryOfOrigin` | Complex Data | Issuing country |
| `code` | string | ISO country code |
| `microfiche` | Complex Data | Microfiche details |
| `number` | string | Microfiche number |
| `issuedOn` | timestamp | Issue date |
| `electricityBill` | Complex Data | Electricity bill details |
| `referenceNo` | string | Bill reference |
| `seenOn` | timestamp | Date document seen |
| `utilitiesBill` | Complex Data | Utilities bill details |
| `councilTaxBill` | Complex Data | Council tax bill details |
| `irTaxNotification` | Complex Data | IR tax notification details |
| `bankStatement` | Complex Data | Bank statement details |
| `mortgageStatement` | Complex Data | Mortgage statement details |
| `firearmOrShotgunCertificate` | Complex Data | Firearm certificate details |

*Showing all 24 fields*

#### contacts

| Field | Type | Description |
|-------|------|-------------|
| `type` | string | Contact type (Telephone, Email, etc.) |
| `value` | string | Contact value |

#### currentAddress

| Field | Type | Description |
|-------|------|-------------|
| `residentFrom` | timestamp | Date moved to address |
| `yearsAtAddress` | string | Years at address |
| `address` | Complex Data | Address details |
| `line1` | string | Address line 1 |
| `line2` | string | Address line 2 |
| `line3` | string | Address line 3 |
| `line4` | string | Address line 4 |
| `locality` | string | City/town |
| `postalCode` | string | Postal code |
| `country` | Complex Data | Country code |
| `code` | string | ISO country code |
| `county` | Complex Data | County code |
| `code` | string | County code |

#### previousAddresses

| Field | Type | Description |
|-------|------|-------------|
| `residentFrom` | timestamp | Date moved to address |
| `yearsAtAddress` | string | Years at address |
| `address` | Complex Data | Address details (same structure as currentAddress) |

#### supportingDocuments

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Document ID |
| `href` | string | Document resource URL |

#### verification

| Field | Type | Description |
|-------|------|-------------|
| `witness` | Complex Data | Witness verification |
| `position` | string | Witness position |
| `witnessedOn` | timestamp | Date witnessed |
| `premises` | Complex Data | Premises verification |
| `lastVisitedOn` | timestamp | Last visit date |
| `enteredOn` | timestamp | Entry date |
| `expiryOn` | timestamp | Verification expiry date |

#### verificationResult

| Field | Type | Description |
|-------|------|-------------|
| `providerName` | string | Verification provider |
| `status` | Enum (Text) | Status: Rejected, ManualReview, Accepted, Completed |
| `outcome` | string | Verification outcome |
| `score` | integer | Verification score |
| `verifiedOn` | timestamp | Verification timestamp |
| `certificateDocument` | Reference Link | Certificate document |
| `id` | integer | Document ID |
| `href` | string | Document resource URL |
| `createdAt` | timestamp | Result creation timestamp |
| `updatedAt` | timestamp | Result update timestamp |


### Related Resources

*See parent document for relationships to other entities.*

## Data Model