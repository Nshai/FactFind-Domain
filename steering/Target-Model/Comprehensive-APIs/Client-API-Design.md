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

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `adviser` | Reference Link |  | The adviser responsible for this client |
| `clientCategory` | string |  | Client category (e.g., HighNetWorth, Mass Market) |
| `clientNumber` | string |  | Client reference number assigned by your organization |
| `clientSegment` | string |  | Client segment classification (A, B, C, D for prioritization) |
| `clientSegmentDate` | date |  | Client segment classification (A, B, C, D for prioritization) |
| `clientType` | string |  | Type of client: Person (individual), Corporate (company), or Trust |
| `createdAt` | date |  | When this record was created in the system |
| `createdBy` | Complex Data |  | User who created this record |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `id` | integer | ✓ | Unique system identifier for this record |
| `isHeadOfFamilyGroup` | boolean |  | Whether this client is the primary contact for the family group |
| `isJoint` | boolean |  | Whether this client is part of a joint (couple) fact find |
| `isMatchingServiceProposition` | boolean |  | Whether this client requires matching service due to vulnerability |
| `matchingServicePropositionReason` | string |  |  |
| `officeRef` | Complex Data |  | The office/branch where this client is managed |
| `paraplannerRef` | Reference Link |  | The paraplanner assigned to this client |
| `personValue` | Complex Data |  | Personal information (only for individual clients) |
| `serviceStatus` | string |  | Current service status (Active, Inactive, Prospect, etc.) |
| `serviceStatusDate` | date |  | Current service status (Active, Inactive, Prospect, etc.) |
| `spouseRef` | Reference Link |  | Link to the spouse/partner client record (for joint fact finds) |
| `territorialProfile` | Complex Data |  | Residency, domicile, citizenship, and territorial tax status |
| `updatedAt` | date |  | When this record was last modified |
| `updatedBy` | Complex Data |  | User who last modified this record |

*Total: 23 properties*


### Referenced Type Definitions

The following complex types are used in the properties above:

#### adviser

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Standard Occupational Classification (SOC) code |
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |

#### createdBy

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |

#### factfind

| Field | Type | Description |
|-------|------|-------------|
| `factFindNumber` | string |  |
| `id` | integer | Unique system identifier for this record |
| `status` | string | Current status of the goal |

#### office Reference

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Standard Occupational Classification (SOC) code |
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |

#### paraplanner Reference

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Standard Occupational Classification (SOC) code |
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |

#### person

| Field | Type | Description |
|-------|------|-------------|
| `age` | integer | Current age (calculated from date of birth) |
| `dateOfBirth` | date | Date of birth |
| `deceasedDate` | string | Date of death (if applicable) |
| `employmentStatus` | string | Current employment status |
| `firstName` | string | First name (given name) |
| `fullName` | string | Complete formatted name including title |
| `gender` | string | Gender (M=Male, F=Female, O=Other, X=Prefer not to say) |
| `healthMetrics` | Complex Data | Height, weight, BMI for health and insurance assessment |
| `bmi` | integer |  |
| `bmiCategory` | string | Expenditure category (Housing, Transport, Food, etc.) |
| `heightCm` | integer |  |
| `lastMeasured` | date |  |
| `weightKg` | integer |  |
| `isDeceased` | boolean | Whether the client has passed away |
| `lastName` | string | Last name (surname/family name) |
| `maritalStatus` | Selection | Current marital status (Single, Married, Divorced, etc.) |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `effectiveFrom` | date |  |
| `middleNames` | string | Middle name(s) |
| `niNumber` | string | National Insurance number (UK) |
| `occupation` | string | Current occupation/job title |
| `occupationCode` | Selection | Standard Occupational Classification (SOC) code |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `socVersion` | string |  |
| `preferredName` | string | Name the client prefers to be called |
| `salutation` | string | How to address the client (e.g., "Mr Smith") |
| `smokingStatus` | string | Smoking status for insurance purposes |
| `title` | string | Title (Mr, Mrs, Ms, Dr, etc.) |

*Showing all 30 fields*

#### spouse Reference

| Field | Type | Description |
|-------|------|-------------|
| `clientNumber` | string | Client reference number assigned by your organization |
| `id` | integer | Unique system identifier for this record |
| `name` | string | First name (given name) |
| `type` | string | Type of client: Person (individual), Corporate (company), or Trust |

#### territorialProfile

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
| `alpha3` | string |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `countryOfResidence` | Selection | Current country of residence |
| `alpha3` | string |  |
| `code` | string | Standard Occupational Classification (SOC) code |
| `display` | string |  |
| `expatriate` | boolean | Whether the client is an expatriate |
| `placeOfBirth` | string | City/town where the client was born |
| `ukDomicile` | boolean | Whether the client is UK domiciled |
| `ukResident` | boolean | Whether the client is UK tax resident |

*Showing all 21 fields*

#### updatedBy

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for this record |


### Related Resources

*See parent document for relationships to other entities.*

## Data Model