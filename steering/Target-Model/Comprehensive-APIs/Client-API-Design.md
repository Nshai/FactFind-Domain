# Client API Design

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
| **Entity Name** | Client |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/factfinds/{factfindId}/clients` |
| **Resource Type** | Collection |

### Description

Core client identity and profile management

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
| GET | `/api/v2/factfinds/{factfindId}/clients` | List all clients in factfind | Query params | Client[] | 200, 401, 403 | Client, List |
| POST | `/api/v2/factfinds/{factfindId}/clients` | Create new client | ClientRequest | Client | 201, 400, 401, 403, 422 | Client, Create |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}` | Get client by ID | Path params | Client | 200, 401, 403, 404 | Client, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}` | Update client details | ClientPatch | Client | 200, 400, 401, 403, 404, 422 | Client, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}` | Delete client | Path params | None | 204, 401, 403, 404, 422 | Client, Delete |


### Authorization

**Required Scopes:**
- `client:read` - Read access (GET operations)
- `client:write` - Create and update access (POST, PUT, PATCH)
- `client:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary

### Client Resource Properties

**Base Properties (All Client Types):**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique client identifier |
| `clientNumber` | string | ✓ | Client reference number |
| `clientType` | string | ✓ | Discriminator: "Person", "Corporate", or "Trust" |
| `factfind` | FactFindRef | ✓ | Reference to parent FactFind |
| `adviser` | AdviserRef | ✓ | Assigned adviser reference |
| `serviceStatus` | string | ✓ | Status: Active, Inactive, Prospect, etc. |
| `isJoint` | boolean |  | Whether this is a joint client |
| `spouseRef` | ClientRef |  | Reference to spouse/partner (if joint) |
| `territorialProfile` | TerritorialProfile |  | Residency, domicile, citizenship details |
| `createdAt` | timestamp |  | Creation timestamp |
| `updatedAt` | timestamp |  | Last modification timestamp |

**Discriminated Value Types (based on clientType):**

### For Person Clients (clientType = "Person")

`personValue` object contains:

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `title` | string |  | Title: MR, MRS, MISS, MS, DR, etc. |
| `firstName` | string | ✓ | First name (given name) |
| `middleNames` | string |  | Middle name(s) |
| `lastName` | string | ✓ | Last name (surname/family name) |
| `fullName` | string |  | Complete formatted name with title |
| `preferredName` | string |  | Name client prefers to be called |
| `dateOfBirth` | date | ✓ | Date of birth |
| `age` | integer |  | Current age (calculated) |
| `gender` | string |  | Gender: M, F, O, X (prefer not to say) |
| `niNumber` | string |  | National Insurance Number (UK) |
| `maritalStatus` | MaritalStatus |  | Marital status with effective date |
| `employmentStatus` | string |  | Employment status |
| `occupation` | string |  | Current occupation/job title |
| `smokingStatus` | string |  | Smoking status: NEVER, FORMER, LIGHT, MODERATE, HEAVY |
| `healthMetrics` | HealthMetrics |  | Height, weight, BMI for health assessment |
| `isDeceased` | boolean |  | Whether the person has passed away |
| `deceasedDate` | date |  | Date of death (if applicable) |

### For Corporate Clients (clientType = "Corporate")

`corporateValue` object contains:

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `companyName` | string | ✓ | Official registered company name |
| `tradingName` | string |  | Trading name (if different) |
| `registrationNumber` | string | ✓ | Company registration number |
| `incorporationDate` | date |  | Date of incorporation |
| `companyType` | string | ✓ | Company type: LTD, PLC, LLP, etc. |
| `vatNumber` | string |  | VAT registration number |
| `companyStatus` | string |  | Status: ACTIVE, DISSOLVED, etc. |
| `sicCodes` | SICCode[] |  | Standard Industrial Classification codes |
| `numberOfEmployees` | integer |  | Number of employees |
| `annualTurnover` | Money |  | Annual turnover amount |
| `directors` | Director[] |  | List of company directors with shareholding |
| `countryOfIncorporation` | Country |  | Country where company is incorporated |

### For Trust Clients (clientType = "Trust")

`trustValue` object contains:

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `trustName` | string | ✓ | Name of the trust |
| `trustType` | string | ✓ | Type: DISCRETIONARY, BARE, INTEREST_IN_POSSESSION, etc. |
| `settlementDate` | date | ✓ | Date trust was established |
| `trustRegistrationNumber` | string |  | Trust Registration Number (TRN) |
| `taxReference` | string |  | Tax reference number |
| `trustDeed` | TrustDeed |  | Trust deed document details |
| `settlor` | Settlor | ✓ | Person who established the trust |
| `trustees` | Trustee[] | ✓ | List of trustees managing the trust |
| `beneficiaries` | Beneficiary[] |  | List of trust beneficiaries |
| `trustPurpose` | string |  | Purpose of the trust |


### Related Resources

**Parent Resource:** Client

**Related APIs:**
- See [Master API Design - Section 11](./MASTER-API-DESIGN.md#11-entity-apis-by-domain) for related APIs in the Client Management domain

---


### Referenced Type Definitions

The following types are referenced in the resource properties above:

### TerritorialProfile Structure

| Field | Type | Description |
|-------|------|-------------|
| `countriesOfCitizenship` | List of Complex Data | List of countries where the client holds citizenship |
| `countryOfBirth` | Selection | Country where the client was born |
| `alpha3` | string |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `countryOfDomicile` | Selection | Country of domicile for tax purposes |
| `alpha3` | string |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `countryOfOrigin` | Selection | Country of origin |

*Showing first 10 of 21 fields.*

### Money Structure

*Currency amount with code* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

### Country Structure

| Field | Type | Description |
|-------|------|-------------|
| `alpha3` | string |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |

## Data Model