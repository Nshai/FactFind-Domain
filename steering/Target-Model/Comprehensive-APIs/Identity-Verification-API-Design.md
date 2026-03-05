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
| **Base Path** | `/api/v3/...` |
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
| `createdAt` | DateTime |  | Record creation timestamp |
| `updatedAt` | DateTime |  | Last update timestamp |
| `createdBy` | string |  | User who created the record |
| `updatedBy` | string |  | User who last updated the record |

*Total: 15 properties*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### client

Client personal information for KYC/AML:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique client identifier |
| `href` | string | Client resource URL |
| `title` | string | Title (Mr, Mrs, Ms, Dr, etc.) |
| `firstName` | string | First name |
| `middleName` | string | Middle name(s) |
| `lastName` | string | Last name |
| `gender` | string | Gender |
| `dateOfBirth` | date | Date of birth |
| `mothersMaidenName` | string | Mother's maiden name (security question) |
| `placeOfBirth` | string | Place of birth (city/town) |
| `countryOfBirth` | Complex Data | Country of birth with ISO code |
| `placeOfBirthOther` | string | Additional birth location details |

*Total: 12 fields*

#### contacts

Contact methods (telephone, email, etc.):

| Field | Type | Description |
|-------|------|-------------|
| `type` | string | Contact type: Telephone, Mobile, Email, Fax |
| `value` | string | Contact value (phone number, email address, etc.) |

#### currentAddress

Current residential address with occupancy details:

| Field | Type | Description |
|-------|------|-------------|
| `residentFrom` | date | Date moved to this address |
| `yearsAtAddress` | string | Years at address (calculated or stated) |
| `address` | Complex Data | Full address details |
| `line1` | string | Address line 1 (building number/name, street) |
| `line2` | string | Address line 2 (flat/apartment number) |
| `line3` | string | Address line 3 (district) |
| `line4` | string | Address line 4 (additional locality) |
| `locality` | string | City/town |
| `postalCode` | string | Postal/ZIP code |
| `country` | Complex Data | Country with ISO code |
| `county` | Complex Data | County/region with code |

*Total: 11 fields (nested)*

#### previousAddresses

Address history (for AML checks - typically 3 years required):

| Field | Type | Description |
|-------|------|-------------|
| `residentFrom` | date | Date moved to this address |
| `yearsAtAddress` | string | Years at address |
| `address` | Complex Data | Full address details (same structure as currentAddress) |

**Note:** Multiple previous addresses may be required to satisfy 3-year address history requirement

#### clientIdentity

Identity documents for verification (multiple document types):

| Field | Type | Description |
|-------|------|-------------|
| `passport` | Complex Data | Passport details |
| `drivingLicence` | Complex Data | Driving licence details |
| `microfiche` | Complex Data | Microfiche details |
| `electricityBill` | Complex Data | Electricity bill details |
| `utilitiesBill` | Complex Data | Utilities bill details |
| `councilTaxBill` | Complex Data | Council tax bill details |
| `irTaxNotification` | Complex Data | HMRC tax notification details |
| `bankStatement` | Complex Data | Bank statement details |
| `mortgageStatement` | Complex Data | Mortgage statement details |
| `firearmOrShotgunCertificate` | Complex Data | Firearm certificate details |

**Each document type contains:**
- `referenceNo` (string) - Document number
- `seenOn` (date) - Date document was verified
- `expiryOn` (date) - Expiry date (if applicable)
- `countryOfOrigin` (Complex Data) - Issuing country with ISO code

**Document Requirements:**
- **Primary ID:** Passport OR Driving Licence
- **Proof of Address:** Utility bill, bank statement, council tax bill (dated within 3 months)

#### supportingDocuments

Uploaded scanned copies of verification documents:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Document ID in document management system |
| `href` | string | Document resource URL for download |

**Used for:** Scanned copies of all verification documents

#### adviser

Adviser who performed the verification:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Adviser unique identifier |
| `href` | string | Adviser resource URL |

#### verification

Witness and premises verification details:

| Field | Type | Description |
|-------|------|-------------|
| `witness` | Complex Data | Witness verification |
| `position` | string | Witness position/title (e.g., Financial Adviser) |
| `witnessedOn` | date | Date documents were witnessed |
| `premises` | Complex Data | Premises verification |
| `lastVisitedOn` | date | Last visit to client premises |
| `enteredOn` | date | Date premises verification entered |
| `expiryOn` | date | Verification expiry date (typically 3 years) |

**Witness Verification:** Documents must be seen by qualified person
**Premises Verification:** Records that client was met at their stated address

#### verificationResult

Third-party electronic verification result (e.g., GBG, Experian):

| Field | Type | Description |
|-------|------|-------------|
| `providerName` | string | Verification provider (GBG, Experian, Equifax, etc.) |
| `status` | Selection | Status: Rejected, ManualReview, Accepted, Completed |
| `outcome` | string | Verification outcome (Pass, Fail, Refer) |
| `score` | integer | Verification confidence score (0-100) |
| `verifiedOn` | timestamp | Verification timestamp |
| `certificateDocument` | Reference Link | Link to verification certificate document |
| `createdAt` | timestamp | Result creation timestamp |
| `updatedAt` | timestamp | Result update timestamp |

**Verification Status Values:**
- `Rejected` - Verification failed (client identity could not be confirmed)
- `ManualReview` - Requires manual review by compliance officer
- `Accepted` - Verification accepted (identity confirmed)
- `Completed` - Verification completed successfully

**Third-Party Providers:**
- **GBG** - Global identity verification
- **Experian** - Credit reference and identity checks
- **Equifax** - Identity and fraud checks
- **TransUnion** - Identity verification services

### Regulatory Compliance

This entity supports compliance with:
- **UK Money Laundering Regulations 2017** - Customer Due Diligence requirements
- **FCA Handbook SYSC 3.2** - Systems and controls for financial crime
- **The Proceeds of Crime Act 2002** - AML obligations
- **Terrorism Act 2000** - Counter-terrorism financing

**KYC Requirements:**
- Verify client identity (primary ID document)
- Verify client address (proof of address document dated within 3 months)
- Record verification method (face-to-face, electronic, certified copy)
- Retain verification records for 5 years after relationship ends

### Related Resources

*See parent document for relationships to other entities.*


## Data Model