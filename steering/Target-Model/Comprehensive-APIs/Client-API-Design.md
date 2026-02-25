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

## Data Model

### Discriminator Pattern

The Client contract uses a **discriminator pattern** with `clientType` as the discriminator field:

```
Client Resource
├── Base Properties (always present)
│   ├── id, clientNumber, clientType
│   ├── factfind, adviser, serviceStatus
│   └── isJoint, spouseRef, territorialProfile
│
└── Discriminated Value (based on clientType)
    ├── clientType = "Person" → personValue { firstName, lastName, dateOfBirth, ... }
    ├── clientType = "Corporate" → corporateValue { companyName, registrationNumber, directors, ... }
    └── clientType = "Trust" → trustValue { trustName, settlor, trustees, beneficiaries, ... }
```

**Business Rules:**
- `clientType` must be one of: "Person", "Corporate", "Trust"
- When `clientType = "Person"`, the `personValue` object is **required**
- When `clientType = "Corporate"`, the `corporateValue` object is **required**
- When `clientType = "Trust"`, the `trustValue` object is **required**
- Only one discriminated value object should be present per client

### Complete Schema

For complete field specifications, enumerations, and complex types, refer to:
- **[FactFind Contracts Reference](../../FactFind-Contracts-Reference.md)** - Complete contract definitions
- **[FactFind API Design v2](../../FactFind-API-Design-v2.md)** - Detailed operation specifications

### Common Field Types

**Standard Types:**
- `integer` - Whole numbers
- `string` - Text values
- `boolean` - true/false
- `date` - ISO 8601 date (YYYY-MM-DD)
- `timestamp` - ISO 8601 datetime (YYYY-MM-DDTHH:mm:ssZ)
- `decimal` - Decimal numbers

**Complex Types:**
- `Money` - Amount with currency (amount, currency object with code, display, symbol)
- `Country` - Country with ISO code (code, display, alpha3)
- `FactFindRef` - Reference to FactFind (id, href, factFindNumber, status)
- `AdviserRef` - Reference to Adviser (id, code, name)
- `ClientRef` - Reference to another Client (id, clientNumber, name, type)
- `MaritalStatus` - Marital status with effective date (code, display, effectiveFrom)
- `HealthMetrics` - Health measurements (heightCm, weightKg, bmi, bmiCategory, lastMeasured)
- `SICCode` - Standard Industrial Classification (code, display)
- `Director` - Company director (personRef, appointedDate, role, shareholding, isActive)
- `Settlor` - Trust settlor (personRef, settlementAmount, settlementDate, isDeceased)
- `Trustee` - Trust trustee (personRef, appointedDate, role, isProfessionalTrustee, isActive)
- `TrustDeed` - Trust deed document (document, documentUrl, executionDate, storedWith, lastReviewedDate)
- `TerritorialProfile` - Residency details (countryOfResidence, countryOfDomicile, countryOfBirth, countriesOfCitizenship, expatriate, ukResident, ukDomicile)

---

## Business Rules

### Entity-Specific Rules

**Discriminator Validation Rules:**
1. `clientType` must be one of: "Person", "Corporate", "Trust"
2. When `clientType = "Person"`, the `personValue` object is **required** and must contain:
   - `firstName` (required)
   - `lastName` (required)
   - `dateOfBirth` (required)
3. When `clientType = "Corporate"`, the `corporateValue` object is **required** and must contain:
   - `companyName` (required)
   - `registrationNumber` (required)
   - `companyType` (required)
4. When `clientType = "Trust"`, the `trustValue` object is **required** and must contain:
   - `trustName` (required)
   - `trustType` (required)
   - `settlementDate` (required)
   - `settlor` (required)
   - `trustees` array with at least one trustee (required)
5. Only one discriminated value object (`personValue`, `corporateValue`, or `trustValue`) should be present per client

**General Validation Rules:**
1. All required fields must be provided
2. Field formats must match specifications
3. `clientNumber` must be unique within the system
4. Business logic constraints apply per entity type
5. Referential integrity must be maintained

**Identity Verification Requirements:**
- Person clients: Valid ID document and proof of address required
- Corporate clients: Company registration documents required
- Trust clients: Trust deed and trustee identification required
- Active clients must have valid identity verification

**Relationship Rules:**
- Joint clients (`isJoint = true`) must have a valid `spouseRef`
- Both clients in a joint relationship must belong to the same FactFind
- Spouse reference must point to a "Person" client type
- Cannot delete a client that is referenced as a spouse

**Contact and Address Rules:**
- At least one primary contact (email or phone) is required
- At least one current address (`addressType = "Current"`) is required
- Primary contact cannot be deleted if other contacts exist
- Current address cannot be deleted if it's the only address

**Business Constraints:**
- Client data must be accurate and up-to-date
- Changes must be auditable (tracked via `updatedAt` and `updatedBy`)
- Deletion may require soft-delete for compliance (if client has arrangements or historical data)
- Data retention policies must be followed per GDPR/DPA 2018
- Vulnerable clients require matching service proposition documentation

### Common Business Rules

For common business rules applicable to all entities, refer to **[Master API Design - Section 8](./MASTER-API-DESIGN.md#8-performance-standards)**.

---

## Request/Response Examples

### Example 1: Create Person Client

**Request:**
```json
POST /api/v2/factfinds/{factfindId}/clients
Content-Type: application/json

{
  "clientNumber": "C00012345",
  "clientType": "Person",
  "serviceStatus": "Active",
  "personValue": {
    "title": "MR",
    "firstName": "John",
    "middleNames": "Michael",
    "lastName": "Smith",
    "dateOfBirth": "1980-05-15",
    "gender": "M",
    "niNumber": "AB123456C",
    "maritalStatus": {
      "code": "MAR",
      "display": "Married",
      "effectiveFrom": "2005-06-20"
    },
    "occupation": "Senior Software Engineer",
    "smokingStatus": "NEVER"
  },
  "territorialProfile": {
    "countryOfResidence": { "code": "GB", "display": "United Kingdom", "alpha3": "GBR" },
    "countryOfDomicile": { "code": "GB", "display": "United Kingdom", "alpha3": "GBR" },
    "ukResident": true,
    "ukDomicile": true
  }
}
```

**Response (201 Created):**
```json
{
  "id": 123,
  "clientNumber": "C00012345",
  "clientType": "Person",
  "serviceStatus": "Active",
  "personValue": {
    "title": "MR",
    "firstName": "John",
    "middleNames": "Michael",
    "lastName": "Smith",
    "fullName": "Mr John Michael Smith",
    "dateOfBirth": "1980-05-15",
    "age": 45,
    "gender": "M",
    "niNumber": "AB123456C",
    "maritalStatus": {
      "code": "MAR",
      "display": "Married",
      "effectiveFrom": "2005-06-20"
    },
    "occupation": "Senior Software Engineer",
    "smokingStatus": "NEVER",
    "isDeceased": false
  },
  "territorialProfile": {
    "countryOfResidence": { "code": "GB", "display": "United Kingdom", "alpha3": "GBR" },
    "countryOfDomicile": { "code": "GB", "display": "United Kingdom", "alpha3": "GBR" },
    "ukResident": true,
    "ukDomicile": true
  },
  "factfind": {
    "id": 890,
    "href": "/api/v2/factfinds/890",
    "factFindNumber": "FF-2025-00123"
  },
  "adviser": {
    "id": 456,
    "code": "ADV001",
    "name": "Jane Adviser"
  },
  "createdAt": "2026-02-25T10:00:00Z",
  "updatedAt": "2026-02-25T10:00:00Z"
}
```

### Example 2: Create Corporate Client

**Request:**
```json
POST /api/v2/factfinds/{factfindId}/clients
Content-Type: application/json

{
  "clientNumber": "C00056789",
  "clientType": "Corporate",
  "serviceStatus": "Active",
  "corporateValue": {
    "companyName": "TechVenture Solutions Ltd",
    "tradingName": "TechVenture",
    "registrationNumber": "09876543",
    "incorporationDate": "2015-03-20",
    "companyType": "LTD",
    "vatNumber": "GB123456789",
    "companyStatus": "ACTIVE",
    "numberOfEmployees": 45,
    "annualTurnover": {
      "amount": 3500000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "directors": [
      {
        "personRef": {
          "id": 124,
          "clientNumber": "C00056790",
          "name": "Robert Johnson"
        },
        "appointedDate": "2015-03-20",
        "role": "Managing Director",
        "shareholding": 60.0,
        "isActive": true
      }
    ],
    "countryOfIncorporation": { "code": "GB", "display": "United Kingdom", "alpha3": "GBR" }
  }
}
```

**Response (201 Created):**
```json
{
  "id": 567,
  "clientNumber": "C00056789",
  "clientType": "Corporate",
  "serviceStatus": "Active",
  "corporateValue": {
    "companyName": "TechVenture Solutions Ltd",
    "tradingName": "TechVenture",
    "registrationNumber": "09876543",
    "incorporationDate": "2015-03-20",
    "companyType": "LTD",
    "vatNumber": "GB123456789",
    "companyStatus": "ACTIVE",
    "numberOfEmployees": 45,
    "annualTurnover": {
      "amount": 3500000.00,
      "currency": { "code": "GBP", "display": "British Pound", "symbol": "£" }
    },
    "directors": [
      {
        "personRef": {
          "id": 124,
          "href": "/api/v2/factfinds/{factfindId}/clients/124",
          "clientNumber": "C00056790",
          "name": "Robert Johnson"
        },
        "appointedDate": "2015-03-20",
        "role": "Managing Director",
        "shareholding": 60.0,
        "isActive": true
      }
    ],
    "countryOfIncorporation": { "code": "GB", "display": "United Kingdom", "alpha3": "GBR" }
  },
  "factfind": {
    "id": 890,
    "href": "/api/v2/factfinds/890",
    "factFindNumber": "FF-2025-00456"
  },
  "createdAt": "2026-02-25T10:00:00Z",
  "updatedAt": "2026-02-25T10:00:00Z"
}
```

### Example 3: Create Trust Client

**Request:**
```json
POST /api/v2/factfinds/{factfindId}/clients
Content-Type: application/json

{
  "clientNumber": "C00099999",
  "clientType": "Trust",
  "serviceStatus": "Active",
  "trustValue": {
    "trustName": "The Smith Family Discretionary Trust",
    "trustType": "DISCRETIONARY",
    "settlementDate": "2018-04-15",
    "trustRegistrationNumber": "TRN12345678",
    "settlor": {
      "personRef": {
        "id": 1000,
        "clientNumber": "C00010000",
        "name": "William Smith"
      },
      "settlementAmount": {
        "amount": 500000.00,
        "currency": { "code": "GBP", "display": "British Pound", "symbol": "£" }
      },
      "settlementDate": "2018-04-15",
      "isDeceased": false
    },
    "trustees": [
      {
        "personRef": {
          "id": 1001,
          "clientNumber": "C00010001",
          "name": "Margaret Smith"
        },
        "appointedDate": "2018-04-15",
        "role": "Principal Trustee",
        "isProfessionalTrustee": false,
        "isActive": true
      }
    ]
  }
}
```

**Response (201 Created):**
```json
{
  "id": 999,
  "clientNumber": "C00099999",
  "clientType": "Trust",
  "serviceStatus": "Active",
  "trustValue": {
    "trustName": "The Smith Family Discretionary Trust",
    "trustType": "DISCRETIONARY",
    "settlementDate": "2018-04-15",
    "trustRegistrationNumber": "TRN12345678",
    "settlor": {
      "personRef": {
        "id": 1000,
        "href": "/api/v2/factfinds/{factfindId}/clients/1000",
        "clientNumber": "C00010000",
        "name": "William Smith"
      },
      "settlementAmount": {
        "amount": 500000.00,
        "currency": { "code": "GBP", "display": "British Pound", "symbol": "£" }
      },
      "settlementDate": "2018-04-15",
      "isDeceased": false
    },
    "trustees": [
      {
        "personRef": {
          "id": 1001,
          "href": "/api/v2/factfinds/{factfindId}/clients/1001",
          "clientNumber": "C00010001",
          "name": "Margaret Smith"
        },
        "appointedDate": "2018-04-15",
        "role": "Principal Trustee",
        "isProfessionalTrustee": false,
        "isActive": true
      }
    ]
  },
  "factfind": {
    "id": 1111,
    "href": "/api/v2/factfinds/1111",
    "factFindNumber": "FF-2025-00789"
  },
  "createdAt": "2026-02-25T10:00:00Z",
  "updatedAt": "2026-02-25T10:00:00Z"
}
```

### Example Error Response

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "fieldName",
        "issue": "Specific issue description",
        "value": "invalid-value"
      }
    ],
    "timestamp": "2026-02-25T10:30:00Z",
    "requestId": "req-123456"
  }
}
```

For complete error response format and error codes, refer to **[Master API Design - Section 6](./MASTER-API-DESIGN.md#6-error-handling)**.

---

## Testing

### Test Scenarios

**Happy Path:**
1. Create Client with valid data
2. Retrieve Client by ID
3. Update Client fields
4. Delete Client

**Validation:**
1. Missing required fields
2. Invalid field formats
3. Business rule violations

**Authorization:**
1. Missing/invalid token
2. Insufficient permissions

For complete testing standards, refer to **[Master API Design - Section 9](./MASTER-API-DESIGN.md#9-testing-standards)**.

---

## References

### Primary Documents

- **[Master API Design](./MASTER-API-DESIGN.md)** - Common standards for all APIs
- **[FactFind API Design v2](../../FactFind-API-Design-v2.md)** - Complete source with detailed operations
- **[FactFind Contracts Reference](../../FactFind-Contracts-Reference.md)** - Complete contract/schema definitions
- **[API Endpoints Catalog](../../API-Endpoints-Catalog.md)** - Comprehensive endpoint catalog

### Related Entity APIs

See **[Master API Design - Section 11.{"1" if entity_info['domain'] == 'Client Management' else "2" if entity_info['domain'] == 'Circumstances' else "3" if entity_info['domain'] == 'Arrangements' else "4" if entity_info['domain'] == 'Assets & Liabilities' else "5" if entity_info['domain'] == 'Risk Profiling' else "6" if entity_info['domain'] == 'FactFind Root' else "7"}](./MASTER-API-DESIGN.md#11{"1" if entity_info['domain'] == 'Client Management' else "2" if entity_info['domain'] == 'Circumstances' else "3" if entity_info['domain'] == 'Arrangements' else "4" if entity_info['domain'] == 'Assets & Liabilities' else "5" if entity_info['domain'] == 'Risk Profiling' else "6" if entity_info['domain'] == 'FactFind Root' else "7"}-client-management-domain)** for other APIs in the Client Management domain.

---

**Document Version:** 2.0
**Last Updated:** 2026-02-25
**Entity:** Client
**Domain:** Client Management
