# V3 API Contracts: Client Profile Domain

**Domain:** monolith.CRM (Client Bounded Context)
**Version:** 3.0
**Status:** Design Specification
**Date:** 2026-02-12
**Author:** API Architecture Team

---

## Executive Summary

This document specifies the V3 API contracts for the **Client Profile domain** within the CRM bounded context. These APIs manage client identity, demographics, contact information, vulnerability assessment, data protection preferences, and regulatory compliance data.

### Scope

The Client Profile domain owns **WHO the client is**, including:
- Client identity and demographics (Person, Corporate, Trust)
- Contact information (addresses, phone, email)
- Vulnerability assessments
- Data protection and marketing preferences
- ID verification and compliance
- Estate planning documents (wills, power of attorney)
- Tax details and residency information

### Out of Scope

The following are managed by other bounded contexts:
- **Financial data** (FactFind domain) - income, assets, liabilities, goals
- **Product holdings** (Portfolio domain) - existing plans and investments
- **Risk profiling** (ATR/Requirements domain) - attitude to risk assessments
- **Advice process** (FactFind domain) - fact-find sessions, objectives

### Key Design Principles

1. **Build on V2 Success** - Enhance existing APIs, don't rebuild
2. **OpenAPI 3.1 Compliance** - Full specification with schemas, examples, errors
3. **Domain Boundary Respect** - Clear separation between CRM and FactFind
4. **Backward Compatibility** - Minimize breaking changes, provide migration paths
5. **Single Contract Principle** - One unified contract per request/response
6. **Security First** - Proper scopes, PII handling, GDPR compliance
7. **HATEOAS Links** - Discoverability through hypermedia
8. **Consistent Patterns** - Uniform naming, structure, and behavior

---

## Table of Contents

1. [API Design Standards](#api-design-standards)
2. [Common Components](#common-components)
3. [Client Demographics API](#client-demographics-api)
4. [Contact Details API](#contact-details-api)
5. [Address API](#address-api)
6. [Vulnerability API](#vulnerability-api)
7. [Data Protection & Marketing API](#data-protection-marketing-api)
8. [ID Verification API](#id-verification-api)
9. [Estate Planning Integration](#estate-planning-integration)
10. [Tax Details API](#tax-details-api)
11. [V2 to V3 Migration Guide](#v2-to-v3-migration-guide)
12. [Implementation Considerations](#implementation-considerations)

---

## API Design Standards

### Naming Conventions

Following API Design Guidelines 2.0:

**Value Types** (immutable data):
- Suffix: `Value`
- Example: `AddressTypeValue`, `GenderValue`, `MaritalStatusValue`
- Used for: Enumerations, lookup values, immutable data

**Reference Types** (links to other entities):
- Suffix: `Ref`
- Example: `ClientRef`, `AdviserRef`, `CountryRef`
- Used for: Entity references, foreign keys

**Document Types** (primary resources):
- Suffix: `Document`
- Example: `ClientDocument`, `AddressDocument`, `VulnerabilityDocument`
- Used for: Main API contracts

**Collection Types**:
- Suffix: `Collection`
- Example: `AddressCollection`, `ContactDetailCollection`
- Used for: Lists of resources with pagination

### HTTP Methods

| Method | Usage | Idempotent | Safe |
|--------|-------|------------|------|
| GET | Retrieve resource(s) | Yes | Yes |
| POST | Create new resource | No | No |
| PUT | Full update (replace) | Yes | No |
| PATCH | Partial update (JSON Patch) | No | No |
| DELETE | Remove resource | Yes | No |

### Status Codes

| Code | Meaning | Usage |
|------|---------|-------|
| 200 | OK | Successful GET, PUT, PATCH |
| 201 | Created | Successful POST |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Validation error, malformed request |
| 401 | Unauthorized | Missing or invalid authentication |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Concurrency conflict, duplicate |
| 422 | Unprocessable Entity | Business rule violation |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unexpected server error |

### Pagination

All collection endpoints support OData-style pagination:

**Query Parameters:**
- `$top` - Number of items per page (default: 25, max: 100)
- `$skip` - Number of items to skip (default: 0)
- `$orderby` - Sort order (e.g., `createdAt desc`)
- `$filter` - OData filter expression

**Response Structure:**
```json
{
  "items": [...],
  "totalCount": 150,
  "pageSize": 25,
  "pageNumber": 1,
  "_links": {
    "self": "/v3/clients/123/addresses?$top=25&$skip=0",
    "next": "/v3/clients/123/addresses?$top=25&$skip=25",
    "prev": null,
    "first": "/v3/clients/123/addresses?$top=25&$skip=0",
    "last": "/v3/clients/123/addresses?$top=25&$skip=125"
  }
}
```

### Error Response Format

Standard error contract across all APIs:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "One or more validation errors occurred",
    "target": "firstName",
    "details": [
      {
        "code": "REQUIRED_FIELD",
        "message": "First name is required",
        "target": "firstName"
      },
      {
        "code": "MAX_LENGTH_EXCEEDED",
        "message": "Last name must not exceed 100 characters",
        "target": "lastName",
        "metadata": {
          "maxLength": 100,
          "actualLength": 125
        }
      }
    ],
    "innererror": {
      "trace": "...",
      "context": "..."
    }
  }
}
```

### Security & Authorization

**OAuth 2.0 Scopes:**

| Scope | Access Level | Usage |
|-------|--------------|-------|
| `client_data:read` | Read client profile data | GET operations |
| `client_data:write` | Modify client profile data | POST, PUT, PATCH, DELETE |
| `client_identification_data:read` | Read PII (NI numbers, IDs) | Sensitive data access |
| `client_vulnerability:read` | Read vulnerability data | Compliance data |
| `client_vulnerability:write` | Modify vulnerability data | Assessment updates |

**PII Obfuscation:**
- NI Number: `AB****56C` (without `client_identification_data:read` scope)
- Tax Reference: `****5678` (last 4 digits only)
- Passport Number: `****1234` (last 4 digits only)

---

## Common Components

### Shared Schemas

#### ClientRef

Reference to a client entity.

```yaml
ClientRef:
  type: object
  required:
    - id
  properties:
    id:
      type: integer
      format: int32
      description: Unique client identifier
      example: 12345
    href:
      type: string
      format: uri
      description: Link to client resource
      example: /v3/clients/12345
    name:
      type: string
      description: Client display name
      example: John Smith
      readOnly: true
```

#### AdviserRef

Reference to an adviser.

```yaml
AdviserRef:
  type: object
  required:
    - id
  properties:
    id:
      type: integer
      format: int32
      description: Unique adviser identifier
      example: 789
    href:
      type: string
      format: uri
      description: Link to adviser resource
      example: /v3/advisers/789
    name:
      type: string
      description: Adviser display name
      example: Jane Adviser
      readOnly: true
```

#### CountryRef

Reference to a country (ISO 3166).

```yaml
CountryRef:
  type: object
  required:
    - code
  properties:
    code:
      type: string
      minLength: 2
      maxLength: 3
      description: ISO 3166-1 alpha-2 or alpha-3 country code
      example: GB
    name:
      type: string
      description: Country name
      example: United Kingdom
      readOnly: true
```

#### CountyRef

Reference to a county/subdivision (ISO 3166-2).

```yaml
CountyRef:
  type: object
  required:
    - code
  properties:
    code:
      type: string
      maxLength: 10
      description: ISO 3166-2 subdivision code
      example: GB-ENG
    name:
      type: string
      description: County/subdivision name
      example: England
      readOnly: true
```

#### DateValue

Date-only value (no time component).

```yaml
DateValue:
  type: string
  format: date
  description: ISO 8601 date (YYYY-MM-DD)
  example: "1985-03-15"
```

#### Settable&lt;T&gt;

Explicit null-setting pattern for optional fields.

```yaml
SettableDateTime:
  type: object
  description: Wrapper to explicitly set nullable date to null
  properties:
    value:
      type: string
      format: date-time
      nullable: true
      example: "2024-01-15T00:00:00Z"
  example:
    value: null  # Explicitly clear the field
```

#### AuditInfo

Audit metadata for entity tracking.

```yaml
AuditInfo:
  type: object
  readOnly: true
  properties:
    createdAt:
      type: string
      format: date-time
      description: Timestamp when entity was created
      example: "2024-01-01T10:30:00Z"
    createdBy:
      $ref: '#/components/schemas/UserRef'
    updatedAt:
      type: string
      format: date-time
      description: Timestamp when entity was last updated
      example: "2024-06-15T14:22:00Z"
    updatedBy:
      $ref: '#/components/schemas/UserRef'
    concurrencyToken:
      type: string
      description: Optimistic concurrency control token
      example: "W/\"20240615142200\""
```

---

## Client Demographics API

### Overview

The Client Demographics API manages client identity and personal information for three party types:
- **Person** - Individual clients
- **Corporate** - Company/organization clients
- **Trust** - Trust entity clients

**Base Path:** `/v3/clients`

**Key Enhancements from V2:**
- Unified polymorphic client resource
- Enhanced validation and business rules
- Improved nationality and residency handling
- Better support for client lifecycle management
- Comprehensive audit trails

---

### OpenAPI 3.1 Specification

```yaml
openapi: 3.1.0
info:
  title: Client Demographics API
  description: Manages client identity and demographic information
  version: 3.0.0
  contact:
    name: API Support
    email: api-support@intelliflo.com

servers:
  - url: https://api.intelliflo.com/v3
    description: Production
  - url: https://api-staging.intelliflo.com/v3
    description: Staging

security:
  - OAuth2:
      - client_data:read
      - client_data:write

paths:
  /clients:
    get:
      summary: List clients
      description: Retrieve a paginated list of clients with optional filtering
      operationId: listClients
      tags:
        - Clients
      security:
        - OAuth2:
            - client_data:read
      parameters:
        - $ref: '#/components/parameters/Top'
        - $ref: '#/components/parameters/Skip'
        - $ref: '#/components/parameters/OrderBy'
        - $ref: '#/components/parameters/Filter'
        - name: partyType
          in: query
          description: Filter by party type
          schema:
            type: string
            enum: [Person, Corporate, Trust]
        - name: adviserId
          in: query
          description: Filter by current adviser ID
          schema:
            type: integer
        - name: serviceStatusId
          in: query
          description: Filter by service status ID
          schema:
            type: integer
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ClientCollection'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'
        '429':
          $ref: '#/components/responses/TooManyRequests'
        '500':
          $ref: '#/components/responses/InternalServerError'

    post:
      summary: Create client
      description: Create a new client (Person, Corporate, or Trust)
      operationId: createClient
      tags:
        - Clients
      security:
        - OAuth2:
            - client_data:write
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ClientCreateRequest'
            examples:
              person:
                $ref: '#/components/examples/CreatePersonClient'
              corporate:
                $ref: '#/components/examples/CreateCorporateClient'
              trust:
                $ref: '#/components/examples/CreateTrustClient'
      responses:
        '201':
          description: Client created successfully
          headers:
            Location:
              description: URI of created client
              schema:
                type: string
                format: uri
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ClientDocument'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'
        '409':
          description: Conflict - client already exists
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '422':
          $ref: '#/components/responses/UnprocessableEntity'
        '500':
          $ref: '#/components/responses/InternalServerError'

  /clients/{clientId}:
    parameters:
      - $ref: '#/components/parameters/ClientId'

    get:
      summary: Get client
      description: Retrieve a specific client by ID
      operationId: getClient
      tags:
        - Clients
      security:
        - OAuth2:
            - client_data:read
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ClientDocument'
              examples:
                person:
                  $ref: '#/components/examples/PersonClientResponse'
                corporate:
                  $ref: '#/components/examples/CorporateClientResponse'
        '404':
          $ref: '#/components/responses/NotFound'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'
        '500':
          $ref: '#/components/responses/InternalServerError'

    put:
      summary: Update client
      description: Fully update an existing client
      operationId: updateClient
      tags:
        - Clients
      security:
        - OAuth2:
            - client_data:write
      parameters:
        - name: If-Match
          in: header
          description: Optimistic concurrency control (ETag)
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ClientUpdateRequest'
      responses:
        '200':
          description: Client updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ClientDocument'
        '400':
          $ref: '#/components/responses/BadRequest'
        '404':
          $ref: '#/components/responses/NotFound'
        '409':
          description: Concurrency conflict
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '412':
          description: Precondition failed (If-Match header mismatch)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '422':
          $ref: '#/components/responses/UnprocessableEntity'
        '500':
          $ref: '#/components/responses/InternalServerError'

    patch:
      summary: Partially update client
      description: Update specific fields using JSON Patch (RFC 6902)
      operationId: patchClient
      tags:
        - Clients
      security:
        - OAuth2:
            - client_data:write
      parameters:
        - name: If-Match
          in: header
          description: Optimistic concurrency control (ETag)
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json-patch+json:
            schema:
              type: array
              items:
                $ref: '#/components/schemas/JsonPatchOperation'
            example:
              - op: replace
                path: /person/maritalStatus
                value: Married
              - op: add
                path: /tags/-
                value: HighValue
      responses:
        '200':
          description: Client patched successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ClientDocument'
        '400':
          $ref: '#/components/responses/BadRequest'
        '404':
          $ref: '#/components/responses/NotFound'
        '409':
          $ref: '#/components/responses/Conflict'
        '412':
          $ref: '#/components/responses/PreconditionFailed'
        '422':
          $ref: '#/components/responses/UnprocessableEntity'

    delete:
      summary: Archive client
      description: Soft delete (archive) a client - does not physically delete
      operationId: archiveClient
      tags:
        - Clients
      security:
        - OAuth2:
            - client_data:write
      responses:
        '204':
          description: Client archived successfully
        '404':
          $ref: '#/components/responses/NotFound'
        '409':
          description: Cannot archive - client has active dependencies
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '500':
          $ref: '#/components/responses/InternalServerError'

components:
  securitySchemes:
    OAuth2:
      type: oauth2
      flows:
        authorizationCode:
          authorizationUrl: https://auth.intelliflo.com/oauth2/authorize
          tokenUrl: https://auth.intelliflo.com/oauth2/token
          scopes:
            client_data:read: Read client profile data
            client_data:write: Modify client profile data
            client_identification_data:read: Read sensitive identification data

  parameters:
    ClientId:
      name: clientId
      in: path
      required: true
      description: Unique client identifier
      schema:
        type: integer
        format: int32
        example: 12345

    Top:
      name: $top
      in: query
      description: Maximum number of items to return
      schema:
        type: integer
        minimum: 1
        maximum: 100
        default: 25

    Skip:
      name: $skip
      in: query
      description: Number of items to skip
      schema:
        type: integer
        minimum: 0
        default: 0

    OrderBy:
      name: $orderby
      in: query
      description: Sort order (e.g., 'name asc', 'createdAt desc')
      schema:
        type: string
        example: createdAt desc

    Filter:
      name: $filter
      in: query
      description: OData filter expression
      schema:
        type: string
        example: startswith(name, 'Smith')

  schemas:
    ClientDocument:
      type: object
      description: Complete client entity (Person, Corporate, or Trust)
      required:
        - id
        - partyType
        - currentAdviser
      properties:
        id:
          type: integer
          format: int32
          description: Unique client identifier
          readOnly: true
          example: 12345
        href:
          type: string
          format: uri
          description: Link to this client resource
          readOnly: true
          example: /v3/clients/12345
        partyType:
          type: string
          enum: [Person, Corporate, Trust]
          description: Type of client entity
          example: Person
        name:
          type: string
          description: Client display name (derived from party type details)
          readOnly: true
          example: John Smith
        category:
          $ref: '#/components/schemas/ClientCategoryValue'
        currentAdviser:
          $ref: '#/components/schemas/AdviserRef'
        originalAdviser:
          $ref: '#/components/schemas/AdviserRef'
        serviceStatus:
          $ref: '#/components/schemas/ServiceStatusValue'
        clientSegment:
          $ref: '#/components/schemas/ClientSegmentValue'
        group:
          $ref: '#/components/schemas/GroupRef'
        household:
          $ref: '#/components/schemas/HouseholdRef'
        isHeadOfFamilyGroup:
          type: boolean
          description: Indicates if client is head of a family group
          example: true
        servicingAdministrator:
          $ref: '#/components/schemas/UserRef'
        paraplanner:
          $ref: '#/components/schemas/UserRef'
        tags:
          type: array
          maxItems: 30
          description: Client tags (max 30, each max 100 chars, no spaces)
          items:
            type: string
            maxLength: 100
            pattern: '^[^\s]+$'
          example: [HighValue, ComplexNeeds]
        externalReference:
          type: string
          maxLength: 100
          description: External system reference
          example: EXT-12345
        migrationReference:
          type: string
          maxLength: 100
          description: Migration/import reference
          example: MIG-OLD-SYSTEM-456
        secondaryReference:
          type: string
          maxLength: 100
          description: Secondary external reference
          example: SEC-REF-789
        person:
          $ref: '#/components/schemas/PersonValue'
        corporate:
          $ref: '#/components/schemas/CorporateValue'
        trust:
          $ref: '#/components/schemas/TrustValue'
        audit:
          $ref: '#/components/schemas/AuditInfo'
        _links:
          type: object
          description: HATEOAS links to related resources
          readOnly: true
          properties:
            self:
              $ref: '#/components/schemas/Link'
            addresses:
              $ref: '#/components/schemas/Link'
            contactDetails:
              $ref: '#/components/schemas/Link'
            vulnerability:
              $ref: '#/components/schemas/Link'
            marketingPreferences:
              $ref: '#/components/schemas/Link'
            identityVerification:
              $ref: '#/components/schemas/Link'
            relationships:
              $ref: '#/components/schemas/Link'
            plans:
              $ref: '#/components/schemas/Link'
            factFinds:
              $ref: '#/components/schemas/Link'
          example:
            self:
              href: /v3/clients/12345
            addresses:
              href: /v3/clients/12345/addresses
            contactDetails:
              href: /v3/clients/12345/contact-details
            vulnerability:
              href: /v3/clients/12345/vulnerability
            marketingPreferences:
              href: /v3/clients/12345/marketing-preferences
            identityVerification:
              href: /v3/clients/12345/identity-verification
      oneOf:
        - required: [person]
        - required: [corporate]
        - required: [trust]

    PersonValue:
      type: object
      description: Person-specific client details
      required:
        - firstName
        - lastName
      properties:
        salutation:
          type: string
          maxLength: 50
          description: Preferred salutation
          example: Mr
        title:
          type: string
          maxLength: 50
          description: Title (Mr, Mrs, Ms, Dr, etc.)
          example: Mr
        firstName:
          type: string
          maxLength: 100
          pattern: '^.*[a-zA-Z].*$'
          description: First name (must contain at least one letter)
          example: John
        middleName:
          type: string
          maxLength: 100
          description: Middle name
          example: Michael
        lastName:
          type: string
          maxLength: 100
          pattern: '^.*[a-zA-Z].*$'
          description: Last name (must contain at least one letter)
          example: Smith
        maidenName:
          type: string
          maxLength: 100
          description: Maiden name (if applicable)
          example: Johnson
        dateOfBirth:
          type: string
          format: date
          description: Date of birth (YYYY-MM-DD)
          example: "1985-03-15"
        gender:
          $ref: '#/components/schemas/GenderValue'
        maritalStatus:
          type: string
          maxLength: 50
          description: Marital status
          example: Married
        maritalStatusSince:
          type: string
          format: date
          description: Date marital status began
          example: "2010-06-20"
        nationality:
          $ref: '#/components/schemas/CountryRef'
        territorialProfile:
          $ref: '#/components/schemas/TerritorialProfileValue'
        healthProfile:
          $ref: '#/components/schemas/HealthProfileValue'
        niNumber:
          type: string
          maxLength: 20
          description: National Insurance Number (obfuscated without client_identification_data:read scope)
          example: AB123456C
        nationalClientIdentifier:
          type: string
          maxLength: 50
          description: Country-specific unique identifier
          example: NI-AB123456C
        taxReferenceNumber:
          type: string
          maxLength: 50
          description: Tax reference number (obfuscated without client_identification_data:read scope)
          example: 1234567890
        isDeceased:
          type: boolean
          description: Indicates if person is deceased
          default: false
        deceasedOn:
          type: string
          format: date
          description: Date of death (required if isDeceased is true)
          example: "2023-11-15"
        hasWill:
          type: boolean
          description: Indicates if person has a will
          example: true
        isWillUpToDate:
          type: boolean
          description: Indicates if will is current
          example: true
        isPowerOfAttorneyGranted:
          type: boolean
          description: Indicates if power of attorney has been granted
          example: false
        attorneyName:
          type: string
          maxLength: 200
          description: Name of attorney (if POA granted)
          example: Jane Smith

    CorporateValue:
      type: object
      description: Corporate/company client details
      required:
        - companyName
      properties:
        companyName:
          type: string
          maxLength: 200
          description: Registered company name
          example: Acme Corporation Ltd
        tradingName:
          type: string
          maxLength: 200
          description: Trading name (if different from company name)
          example: Acme Corp
        companyRegistrationNumber:
          type: string
          maxLength: 50
          description: Company registration number
          example: 12345678
        vatNumber:
          type: string
          maxLength: 50
          description: VAT registration number
          example: GB123456789
        incorporationDate:
          type: string
          format: date
          description: Date of incorporation
          example: "2015-04-10"
        companyType:
          type: string
          maxLength: 100
          description: Type of corporate entity
          example: Limited Company
        industryCode:
          type: string
          maxLength: 20
          description: Industry classification code (SIC)
          example: "62011"
        countryOfIncorporation:
          $ref: '#/components/schemas/CountryRef'
        registeredAddress:
          $ref: '#/components/schemas/AddressRef'

    TrustValue:
      type: object
      description: Trust entity client details
      required:
        - trustName
        - trustType
      properties:
        trustName:
          type: string
          maxLength: 200
          description: Name of the trust
          example: The Smith Family Trust
        trustType:
          type: string
          maxLength: 100
          description: Type of trust
          example: Discretionary Trust
        establishedOn:
          type: string
          format: date
          description: Date trust was established
          example: "2018-09-01"
        trustReference:
          type: string
          maxLength: 50
          description: Trust registration reference
          example: TRUST-001234
        taxReferenceNumber:
          type: string
          maxLength: 50
          description: Trust tax reference (obfuscated)
          example: UTR****789
        settlor:
          type: string
          maxLength: 200
          description: Name of trust settlor
          example: John Smith
        countryOfEstablishment:
          $ref: '#/components/schemas/CountryRef'

    TerritorialProfileValue:
      type: object
      description: Territorial/residency information
      properties:
        residency:
          type: string
          maxLength: 100
          description: Residency status
          example: UK Resident
        domicile:
          $ref: '#/components/schemas/CountryRef'
        taxResidency:
          type: array
          description: Countries of tax residency
          items:
            $ref: '#/components/schemas/CountryRef'
          example:
            - code: GB
              name: United Kingdom
        isDualCitizen:
          type: boolean
          description: Indicates dual citizenship
          example: false
        citizenships:
          type: array
          description: Citizenship countries
          items:
            $ref: '#/components/schemas/CountryRef'

    HealthProfileValue:
      type: object
      description: Health and lifestyle information for underwriting
      properties:
        smokingStatus:
          type: string
          enum: [NonSmoker, Smoker, ExSmoker]
          description: Smoking status
          example: NonSmoker
        smokingCessationDate:
          type: string
          format: date
          description: Date stopped smoking (for ExSmoker)
          example: "2020-01-01"
        isInGoodHealth:
          type: boolean
          description: General health indicator
          example: true
        height:
          type: number
          format: double
          description: Height in centimeters
          example: 175.5
        weight:
          type: number
          format: double
          description: Weight in kilograms
          example: 75.2

    GenderValue:
      type: string
      enum:
        - Male
        - Female
        - Other
        - PreferNotToSay
      description: Gender identity
      example: Male

    ClientCollection:
      type: object
      required:
        - items
        - totalCount
      properties:
        items:
          type: array
          items:
            $ref: '#/components/schemas/ClientDocument'
        totalCount:
          type: integer
          description: Total number of clients matching filter
          example: 1500
        pageSize:
          type: integer
          description: Number of items per page
          example: 25
        pageNumber:
          type: integer
          description: Current page number (1-indexed)
          example: 1
        _links:
          type: object
          properties:
            self:
              $ref: '#/components/schemas/Link'
            next:
              $ref: '#/components/schemas/Link'
            prev:
              $ref: '#/components/schemas/Link'
            first:
              $ref: '#/components/schemas/Link'
            last:
              $ref: '#/components/schemas/Link'

    ClientCreateRequest:
      type: object
      required:
        - partyType
        - currentAdviser
      properties:
        partyType:
          type: string
          enum: [Person, Corporate, Trust]
        currentAdviser:
          type: object
          required: [id]
          properties:
            id:
              type: integer
        category:
          type: object
          properties:
            id:
              type: integer
        serviceStatus:
          type: object
          properties:
            id:
              type: integer
        person:
          $ref: '#/components/schemas/PersonValue'
        corporate:
          $ref: '#/components/schemas/CorporateValue'
        trust:
          $ref: '#/components/schemas/TrustValue'
        tags:
          type: array
          items:
            type: string

    ClientUpdateRequest:
      allOf:
        - $ref: '#/components/schemas/ClientCreateRequest'

    ErrorResponse:
      type: object
      required:
        - error
      properties:
        error:
          type: object
          required:
            - code
            - message
          properties:
            code:
              type: string
              description: Error code
              example: VALIDATION_ERROR
            message:
              type: string
              description: Human-readable error message
              example: One or more validation errors occurred
            target:
              type: string
              description: Field or property that caused the error
              example: firstName
            details:
              type: array
              description: Detailed validation errors
              items:
                type: object
                properties:
                  code:
                    type: string
                    example: REQUIRED_FIELD
                  message:
                    type: string
                    example: First name is required
                  target:
                    type: string
                    example: firstName
                  metadata:
                    type: object
                    additionalProperties: true
            innererror:
              type: object
              description: Internal debugging information
              properties:
                trace:
                  type: string
                context:
                  type: object

    Link:
      type: object
      properties:
        href:
          type: string
          format: uri
        title:
          type: string
        templated:
          type: boolean
          default: false

    JsonPatchOperation:
      type: object
      required:
        - op
        - path
      properties:
        op:
          type: string
          enum: [add, remove, replace, move, copy, test]
        path:
          type: string
        value:
          description: Value for add/replace/test operations
        from:
          type: string
          description: Source path for move/copy operations

  examples:
    CreatePersonClient:
      summary: Create person client
      value:
        partyType: Person
        currentAdviser:
          id: 789
        person:
          title: Mr
          firstName: John
          lastName: Smith
          dateOfBirth: "1985-03-15"
          gender: Male
          niNumber: AB123456C
          nationality:
            code: GB
        tags:
          - NewClient

    CreateCorporateClient:
      summary: Create corporate client
      value:
        partyType: Corporate
        currentAdviser:
          id: 789
        corporate:
          companyName: Acme Corporation Ltd
          companyRegistrationNumber: "12345678"
          vatNumber: GB123456789
          incorporationDate: "2015-04-10"
          countryOfIncorporation:
            code: GB

    CreateTrustClient:
      summary: Create trust client
      value:
        partyType: Trust
        currentAdviser:
          id: 789
        trust:
          trustName: The Smith Family Trust
          trustType: Discretionary Trust
          establishedOn: "2018-09-01"
          settlor: John Smith
          countryOfEstablishment:
            code: GB

    PersonClientResponse:
      summary: Person client response
      value:
        id: 12345
        href: /v3/clients/12345
        partyType: Person
        name: John Smith
        currentAdviser:
          id: 789
          href: /v3/advisers/789
          name: Jane Adviser
        person:
          title: Mr
          firstName: John
          lastName: Smith
          dateOfBirth: "1985-03-15"
          gender: Male
          niNumber: AB****56C
          nationality:
            code: GB
            name: United Kingdom
        audit:
          createdAt: "2024-01-01T10:00:00Z"
          createdBy:
            id: 100
            name: Admin User
        _links:
          self:
            href: /v3/clients/12345
          addresses:
            href: /v3/clients/12345/addresses
          contactDetails:
            href: /v3/clients/12345/contact-details

    CorporateClientResponse:
      summary: Corporate client response
      value:
        id: 67890
        href: /v3/clients/67890
        partyType: Corporate
        name: Acme Corporation Ltd
        currentAdviser:
          id: 789
          href: /v3/advisers/789
          name: Jane Adviser
        corporate:
          companyName: Acme Corporation Ltd
          companyRegistrationNumber: "12345678"
          vatNumber: GB123456789
          incorporationDate: "2015-04-10"
          countryOfIncorporation:
            code: GB
            name: United Kingdom

  responses:
    BadRequest:
      description: Bad request - validation error or malformed request
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

    Unauthorized:
      description: Unauthorized - missing or invalid authentication
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

    Forbidden:
      description: Forbidden - insufficient permissions
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

    NotFound:
      description: Not found - resource does not exist
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

    Conflict:
      description: Conflict - concurrency or business rule conflict
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

    PreconditionFailed:
      description: Precondition failed - If-Match header mismatch
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

    UnprocessableEntity:
      description: Unprocessable entity - business rule violation
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

    TooManyRequests:
      description: Too many requests - rate limit exceeded
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

    InternalServerError:
      description: Internal server error
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'
```

---

### Usage Examples

#### Create a Person Client

```bash
POST /v3/clients
Authorization: Bearer {token}
Content-Type: application/json

{
  "partyType": "Person",
  "currentAdviser": {
    "id": 789
  },
  "person": {
    "title": "Mr",
    "firstName": "John",
    "middleName": "Michael",
    "lastName": "Smith",
    "dateOfBirth": "1985-03-15",
    "gender": "Male",
    "maritalStatus": "Married",
    "maritalStatusSince": "2010-06-20",
    "niNumber": "AB123456C",
    "nationality": {
      "code": "GB"
    },
    "territorialProfile": {
      "residency": "UK Resident",
      "domicile": {
        "code": "GB"
      },
      "taxResidency": [
        {
          "code": "GB"
        }
      ]
    },
    "healthProfile": {
      "smokingStatus": "NonSmoker",
      "isInGoodHealth": true
    },
    "hasWill": true,
    "isWillUpToDate": true
  },
  "tags": ["NewClient", "Pension"]
}
```

**Response:**
```http
HTTP/1.1 201 Created
Location: /v3/clients/12345
Content-Type: application/json

{
  "id": 12345,
  "href": "/v3/clients/12345",
  "partyType": "Person",
  "name": "John Michael Smith",
  "currentAdviser": {
    "id": 789,
    "href": "/v3/advisers/789",
    "name": "Jane Adviser"
  },
  "person": {
    "title": "Mr",
    "firstName": "John",
    "middleName": "Michael",
    "lastName": "Smith",
    "dateOfBirth": "1985-03-15",
    "gender": "Male",
    "maritalStatus": "Married",
    "maritalStatusSince": "2010-06-20",
    "niNumber": "AB****56C",
    "nationality": {
      "code": "GB",
      "name": "United Kingdom"
    },
    "territorialProfile": {
      "residency": "UK Resident",
      "domicile": {
        "code": "GB",
        "name": "United Kingdom"
      },
      "taxResidency": [
        {
          "code": "GB",
          "name": "United Kingdom"
        }
      ]
    },
    "healthProfile": {
      "smokingStatus": "NonSmoker",
      "isInGoodHealth": true
    },
    "hasWill": true,
    "isWillUpToDate": true
  },
  "tags": ["NewClient", "Pension"],
  "audit": {
    "createdAt": "2024-02-12T14:30:00Z",
    "createdBy": {
      "id": 100,
      "name": "API User"
    },
    "concurrencyToken": "W/\"20240212143000\""
  },
  "_links": {
    "self": {
      "href": "/v3/clients/12345"
    },
    "addresses": {
      "href": "/v3/clients/12345/addresses",
      "title": "Client addresses"
    },
    "contactDetails": {
      "href": "/v3/clients/12345/contact-details",
      "title": "Contact details"
    },
    "vulnerability": {
      "href": "/v3/clients/12345/vulnerability",
      "title": "Vulnerability assessment"
    },
    "marketingPreferences": {
      "href": "/v3/clients/12345/marketing-preferences",
      "title": "Marketing preferences"
    },
    "identityVerification": {
      "href": "/v3/clients/12345/identity-verification",
      "title": "Identity verification"
    }
  }
}
```

#### Update Marital Status with PATCH

```bash
PATCH /v3/clients/12345
Authorization: Bearer {token}
Content-Type: application/json-patch+json
If-Match: W/"20240212143000"

[
  {
    "op": "replace",
    "path": "/person/maritalStatus",
    "value": "Divorced"
  },
  {
    "op": "add",
    "path": "/person/maritalStatusSince",
    "value": "2023-09-15"
  }
]
```

#### List Clients with Filtering

```bash
GET /v3/clients?$top=50&$skip=0&$orderby=name asc&$filter=partyType eq 'Person' and person/dateOfBirth lt '1990-01-01'&adviserId=789
Authorization: Bearer {token}
```

---

### V2 to V3 Migration Notes

#### Breaking Changes

1. **Namespace Change**: `/v2/clients` → `/v3/clients`
2. **Date Format**: Now strictly ISO 8601 (YYYY-MM-DD) for date-only fields
3. **Error Response Structure**: Unified error format (V2 had inconsistencies)
4. **Concurrency Control**: `If-Match` header now required for PUT/PATCH operations
5. **PII Obfuscation**: Default obfuscation unless `client_identification_data:read` scope provided

#### Non-Breaking Enhancements

1. **HATEOAS Links**: `_links` object added to all responses (V2 had only `href` strings)
2. **Audit Info**: Comprehensive audit metadata in `audit` object
3. **Territorial Profile**: Enhanced residency and domicile handling
4. **Health Profile**: Structured health data for underwriting
5. **Tags**: Now properly validated (max 30, max length 100, no spaces)

#### Deprecations

The following V2 fields are deprecated but still supported:

| V2 Field | V3 Replacement | Deprecation Date | Removal Date |
|----------|----------------|------------------|--------------|
| `Nationality` (string) | `nationality` (CountryRef) | 2024-Q2 | 2025-Q2 |
| Individual `*Href` fields | `_links` object | 2024-Q2 | 2025-Q2 |

#### Migration Strategy

**Phase 1: Parallel Operation (Q2-Q3 2024)**
- Both V2 and V3 APIs operational
- V2 writes propagate to V3 structure
- V3 reads available for testing

**Phase 2: V3 Default (Q4 2024)**
- New integrations use V3 only
- V2 marked as deprecated
- Migration guidance and tools provided

**Phase 3: V2 Sunset (Q2 2025)**
- V2 endpoints return 410 Gone
- All traffic migrated to V3

---

## Contact Details API

### Overview

The Contact Details API manages client contact information including phone numbers, email addresses, and other communication channels.

**Base Path:** `/v3/clients/{clientId}/contact-details`

**Key Enhancements from V2:**
- Enhanced validation for phone numbers and emails
- Support for additional contact types (social media, messaging apps)
- Contact verification status tracking
- Preferred contact method designation
- Contact history and audit trail

---

### OpenAPI 3.1 Specification

```yaml
openapi: 3.1.0
info:
  title: Contact Details API
  version: 3.0.0

paths:
  /clients/{clientId}/contact-details:
    parameters:
      - $ref: '#/components/parameters/ClientId'

    get:
      summary: List contact details
      description: Retrieve all contact details for a client
      operationId: listContactDetails
      tags:
        - ContactDetails
      security:
        - OAuth2:
            - client_data:read
      parameters:
        - name: type
          in: query
          description: Filter by contact type
          schema:
            type: string
            enum: [Email, PhoneHome, PhoneMobile, PhoneWork, Website, LinkedIn, Twitter, WhatsApp, Other]
        - name: isDefault
          in: query
          description: Filter by default status
          schema:
            type: boolean
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ContactDetailCollection'

    post:
      summary: Add contact detail
      description: Add a new contact detail for a client
      operationId: createContactDetail
      tags:
        - ContactDetails
      security:
        - OAuth2:
            - client_data:write
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ContactDetailCreateRequest'
      responses:
        '201':
          description: Contact detail created successfully
          headers:
            Location:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ContactDetailDocument'

  /clients/{clientId}/contact-details/{contactDetailId}:
    parameters:
      - $ref: '#/components/parameters/ClientId'
      - $ref: '#/components/parameters/ContactDetailId'

    get:
      summary: Get contact detail
      description: Retrieve a specific contact detail
      operationId: getContactDetail
      tags:
        - ContactDetails
      security:
        - OAuth2:
            - client_data:read
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ContactDetailDocument'

    put:
      summary: Update contact detail
      description: Update an existing contact detail
      operationId: updateContactDetail
      tags:
        - ContactDetails
      security:
        - OAuth2:
            - client_data:write
      parameters:
        - name: If-Match
          in: header
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ContactDetailUpdateRequest'
      responses:
        '200':
          description: Contact detail updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ContactDetailDocument'

    delete:
      summary: Delete contact detail
      description: Remove a contact detail
      operationId: deleteContactDetail
      tags:
        - ContactDetails
      security:
        - OAuth2:
            - client_data:write
      responses:
        '204':
          description: Contact detail deleted successfully

components:
  parameters:
    ContactDetailId:
      name: contactDetailId
      in: path
      required: true
      description: Unique contact detail identifier
      schema:
        type: integer

  schemas:
    ContactDetailDocument:
      type: object
      required:
        - id
        - type
        - value
      properties:
        id:
          type: integer
          description: Unique contact detail identifier
          readOnly: true
          example: 1001
        href:
          type: string
          format: uri
          description: Link to this contact detail
          readOnly: true
          example: /v3/clients/12345/contact-details/1001
        type:
          $ref: '#/components/schemas/ContactDetailTypeValue'
        value:
          type: string
          maxLength: 200
          description: Contact value (email address, phone number, etc.)
          example: john.smith@example.com
        isDefault:
          type: boolean
          description: Indicates if this is the default contact method
          default: false
          example: true
        isPrimary:
          type: boolean
          description: Indicates if this is the primary contact method of this type
          default: false
          example: true
        isVerified:
          type: boolean
          description: Indicates if contact has been verified
          readOnly: true
          default: false
          example: true
        verifiedOn:
          type: string
          format: date-time
          description: Timestamp when contact was verified
          readOnly: true
          example: "2024-01-15T10:30:00Z"
        note:
          type: string
          maxLength: 500
          description: Additional notes about this contact detail
          example: Preferred for urgent matters
        countryCode:
          type: string
          maxLength: 5
          description: Country calling code for phone numbers
          example: "+44"
        extension:
          type: string
          maxLength: 10
          description: Phone extension number
          example: "1234"
        audit:
          $ref: '#/components/schemas/AuditInfo'
        _links:
          type: object
          readOnly: true
          properties:
            self:
              $ref: '#/components/schemas/Link'
            client:
              $ref: '#/components/schemas/Link'
            verify:
              $ref: '#/components/schemas/Link'

    ContactDetailTypeValue:
      type: string
      enum:
        - Email
        - PhoneHome
        - PhoneMobile
        - PhoneWork
        - PhoneFax
        - Website
        - LinkedIn
        - Twitter
        - Facebook
        - WhatsApp
        - Telegram
        - Skype
        - Other
      description: Type of contact detail
      example: Email

    ContactDetailCollection:
      type: object
      properties:
        items:
          type: array
          items:
            $ref: '#/components/schemas/ContactDetailDocument'
        totalCount:
          type: integer
          example: 5
        _links:
          type: object
          properties:
            self:
              $ref: '#/components/schemas/Link'
            client:
              $ref: '#/components/schemas/Link'

    ContactDetailCreateRequest:
      type: object
      required:
        - type
        - value
      properties:
        type:
          $ref: '#/components/schemas/ContactDetailTypeValue'
        value:
          type: string
          maxLength: 200
        isDefault:
          type: boolean
          default: false
        isPrimary:
          type: boolean
          default: false
        note:
          type: string
          maxLength: 500
        countryCode:
          type: string
          maxLength: 5
        extension:
          type: string
          maxLength: 10

    ContactDetailUpdateRequest:
      allOf:
        - $ref: '#/components/schemas/ContactDetailCreateRequest'
```

### Usage Examples

#### Add Email Contact

```bash
POST /v3/clients/12345/contact-details
Authorization: Bearer {token}
Content-Type: application/json

{
  "type": "Email",
  "value": "john.smith@example.com",
  "isDefault": true,
  "isPrimary": true,
  "note": "Personal email - preferred"
}
```

#### Add Mobile Phone

```bash
POST /v3/clients/12345/contact-details
Authorization: Bearer {token}
Content-Type: application/json

{
  "type": "PhoneMobile",
  "value": "07700 900000",
  "countryCode": "+44",
  "isDefault": false,
  "isPrimary": true,
  "note": "Available 9am-5pm weekdays"
}
```

### V2 to V3 Migration Notes

#### Breaking Changes
1. **Type Values**: New contact types added (LinkedIn, WhatsApp, etc.)
2. **Verification**: Added `isVerified` and `verifiedOn` fields
3. **Primary vs Default**: Distinguished between `isDefault` (overall) and `isPrimary` (within type)

#### Enhancements
1. **Country Code**: Explicit field for international phone numbers
2. **Extension**: Support for phone extensions
3. **Longer Notes**: Increased from 255 to 500 characters
4. **Verification**: Contact verification workflow support

---

## Address API

### Overview

The Address API manages client addresses including residential, correspondence, and work addresses.

**Base Path:** `/v3/clients/{clientId}/addresses`

**Key Enhancements from V2:**
- Enhanced property details integration
- Address validation and geocoding support
- Electoral roll status tracking
- Mortgage eligibility flags
- Address history with date ranges

---

### OpenAPI 3.1 Specification

```yaml
openapi: 3.1.0
info:
  title: Address API
  version: 3.0.0

paths:
  /clients/{clientId}/addresses:
    parameters:
      - $ref: '#/components/parameters/ClientId'

    get:
      summary: List addresses
      description: Retrieve all addresses for a client
      operationId: listAddresses
      tags:
        - Addresses
      security:
        - OAuth2:
            - client_data:read
      parameters:
        - name: type
          in: query
          description: Filter by address type
          schema:
            type: string
            enum: [Home, Work, Correspondence, Previous, Temporary]
        - name: isDefault
          in: query
          description: Filter by default status
          schema:
            type: boolean
        - name: isCurrent
          in: query
          description: Filter by current residency
          schema:
            type: boolean
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AddressCollection'

    post:
      summary: Add address
      description: Add a new address for a client
      operationId: createAddress
      tags:
        - Addresses
      security:
        - OAuth2:
            - client_data:write
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AddressCreateRequest'
      responses:
        '201':
          description: Address created successfully
          headers:
            Location:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AddressDocument'

  /clients/{clientId}/addresses/{addressId}:
    parameters:
      - $ref: '#/components/parameters/ClientId'
      - $ref: '#/components/parameters/AddressId'

    get:
      summary: Get address
      description: Retrieve a specific address
      operationId: getAddress
      tags:
        - Addresses
      security:
        - OAuth2:
            - client_data:read
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AddressDocument'

    put:
      summary: Update address
      description: Update an existing address
      operationId: updateAddress
      tags:
        - Addresses
      security:
        - OAuth2:
            - client_data:write
      parameters:
        - name: If-Match
          in: header
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/AddressUpdateRequest'
      responses:
        '200':
          description: Address updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AddressDocument'

    delete:
      summary: Delete address
      description: Remove an address
      operationId: deleteAddress
      tags:
        - Addresses
      security:
        - OAuth2:
            - client_data:write
      responses:
        '204':
          description: Address deleted successfully

components:
  parameters:
    AddressId:
      name: addressId
      in: path
      required: true
      description: Unique address identifier
      schema:
        type: integer

  schemas:
    AddressDocument:
      type: object
      required:
        - id
        - type
        - address
      properties:
        id:
          type: integer
          format: int64
          description: Unique address identifier
          readOnly: true
          example: 2001
        href:
          type: string
          format: uri
          description: Link to this address
          readOnly: true
          example: /v3/clients/12345/addresses/2001
        type:
          $ref: '#/components/schemas/AddressTypeValue'
        address:
          $ref: '#/components/schemas/AddressValue'
        residentFrom:
          type: string
          format: date
          description: Date client moved to this address
          example: "2015-06-01"
        residentTo:
          type: string
          format: date
          nullable: true
          description: Date client moved from this address (null if current)
          example: null
        isCurrent:
          type: boolean
          description: Indicates if this is the current address (residentTo is null)
          readOnly: true
          example: true
        isDefault:
          type: boolean
          description: Indicates if this is the default address
          default: false
          example: true
        status:
          $ref: '#/components/schemas/AddressStatusValue'
        residencyStatus:
          $ref: '#/components/schemas/ResidencyStatusValue'
        isRegisteredOnElectoralRoll:
          type: boolean
          nullable: true
          description: Indicates if registered to vote at this address
          example: true
        isPotentialMortgage:
          type: boolean
          nullable: true
          description: Indicates if address is suitable for mortgage
          example: true
        propertyDetails:
          $ref: '#/components/schemas/PropertyDetailsValue'
        geocoding:
          $ref: '#/components/schemas/GeocodingValue'
        audit:
          $ref: '#/components/schemas/AuditInfo'
        _links:
          type: object
          readOnly: true
          properties:
            self:
              $ref: '#/components/schemas/Link'
            client:
              $ref: '#/components/schemas/Link'
            validate:
              $ref: '#/components/schemas/Link'

    AddressValue:
      type: object
      required:
        - addressLine1
        - country
      properties:
        addressLine1:
          type: string
          maxLength: 1000
          description: First line of address
          example: 123 High Street
        addressLine2:
          type: string
          maxLength: 1000
          description: Second line of address
          example: Apartment 4B
        addressLine3:
          type: string
          maxLength: 1000
          description: Third line of address
          example: Business Park
        addressLine4:
          type: string
          maxLength: 1000
          description: Fourth line of address
          example: null
        locality:
          type: string
          maxLength: 255
          description: Town or city
          example: London
        county:
          $ref: '#/components/schemas/CountyRef'
        postalCode:
          type: string
          maxLength: 20
          description: Postal or ZIP code
          example: SW1A 1AA
        country:
          $ref: '#/components/schemas/CountryRef'

    AddressTypeValue:
      type: string
      enum:
        - Home
        - Work
        - Correspondence
        - Previous
        - Temporary
        - Holiday
        - Investment
      description: Type of address
      example: Home

    AddressStatusValue:
      type: string
      enum:
        - Active
        - Inactive
        - Pending
        - Invalid
      description: Address status
      example: Active

    ResidencyStatusValue:
      type: string
      enum:
        - Owner
        - Renter
        - LivingWithFamily
        - LivingWithFriends
        - CouncilTenant
        - HousingAssociation
        - Other
      description: Residency status
      example: Owner

    PropertyDetailsValue:
      type: object
      description: Property-specific details (for owned properties)
      properties:
        propertyType:
          type: string
          enum: [Detached, SemiDetached, Terraced, Flat, Bungalow, Other]
          description: Type of property
          example: Detached
        numberOfBedrooms:
          type: integer
          minimum: 0
          description: Number of bedrooms
          example: 4
        numberOfBathrooms:
          type: integer
          minimum: 0
          description: Number of bathrooms
          example: 2
        yearBuilt:
          type: integer
          minimum: 1700
          maximum: 2100
          description: Year property was built
          example: 1995
        estimatedValue:
          type: number
          format: double
          description: Estimated property value
          example: 450000.00
        lastValuationDate:
          type: string
          format: date
          description: Date of last valuation
          example: "2023-10-15"
        tenureType:
          type: string
          enum: [Freehold, Leasehold, Commonhold, Shared]
          description: Property tenure type
          example: Freehold
        leaseExpiryDate:
          type: string
          format: date
          description: Lease expiry date (for leasehold)
          example: null

    GeocodingValue:
      type: object
      description: Geographic coordinates for address
      readOnly: true
      properties:
        latitude:
          type: number
          format: double
          description: Latitude coordinate
          example: 51.5074
        longitude:
          type: number
          format: double
          description: Longitude coordinate
          example: -0.1278
        accuracy:
          type: string
          enum: [Rooftop, Interpolated, Approximate]
          description: Geocoding accuracy level
          example: Rooftop
        geocodedAt:
          type: string
          format: date-time
          description: Timestamp when address was geocoded
          example: "2024-01-10T08:00:00Z"

    AddressCollection:
      type: object
      properties:
        items:
          type: array
          items:
            $ref: '#/components/schemas/AddressDocument'
        totalCount:
          type: integer
          example: 3
        _links:
          type: object
          properties:
            self:
              $ref: '#/components/schemas/Link'
            client:
              $ref: '#/components/schemas/Link'

    AddressCreateRequest:
      type: object
      required:
        - type
        - address
      properties:
        type:
          $ref: '#/components/schemas/AddressTypeValue'
        address:
          $ref: '#/components/schemas/AddressValue'
        residentFrom:
          type: string
          format: date
        residentTo:
          type: string
          format: date
          nullable: true
        isDefault:
          type: boolean
          default: false
        status:
          $ref: '#/components/schemas/AddressStatusValue'
        residencyStatus:
          $ref: '#/components/schemas/ResidencyStatusValue'
        isRegisteredOnElectoralRoll:
          type: boolean
          nullable: true
        isPotentialMortgage:
          type: boolean
          nullable: true
        propertyDetails:
          $ref: '#/components/schemas/PropertyDetailsValue'

    AddressUpdateRequest:
      allOf:
        - $ref: '#/components/schemas/AddressCreateRequest'
```

### Usage Examples

#### Add Home Address

```bash
POST /v3/clients/12345/addresses
Authorization: Bearer {token}
Content-Type: application/json

{
  "type": "Home",
  "address": {
    "addressLine1": "123 High Street",
    "addressLine2": "Apartment 4B",
    "locality": "London",
    "postalCode": "SW1A 1AA",
    "country": {
      "code": "GB"
    }
  },
  "residentFrom": "2015-06-01",
  "residentTo": null,
  "isDefault": true,
  "residencyStatus": "Owner",
  "isRegisteredOnElectoralRoll": true,
  "isPotentialMortgage": false,
  "propertyDetails": {
    "propertyType": "Detached",
    "numberOfBedrooms": 4,
    "numberOfBathrooms": 2,
    "yearBuilt": 1995,
    "estimatedValue": 450000.00,
    "tenureType": "Freehold"
  }
}
```

**Response:**
```json
{
  "id": 2001,
  "href": "/v3/clients/12345/addresses/2001",
  "type": "Home",
  "address": {
    "addressLine1": "123 High Street",
    "addressLine2": "Apartment 4B",
    "locality": "London",
    "postalCode": "SW1A 1AA",
    "country": {
      "code": "GB",
      "name": "United Kingdom"
    }
  },
  "residentFrom": "2015-06-01",
  "residentTo": null,
  "isCurrent": true,
  "isDefault": true,
  "status": "Active",
  "residencyStatus": "Owner",
  "isRegisteredOnElectoralRoll": true,
  "isPotentialMortgage": false,
  "propertyDetails": {
    "propertyType": "Detached",
    "numberOfBedrooms": 4,
    "numberOfBathrooms": 2,
    "yearBuilt": 1995,
    "estimatedValue": 450000.00,
    "tenureType": "Freehold"
  },
  "geocoding": {
    "latitude": 51.5074,
    "longitude": -0.1278,
    "accuracy": "Rooftop",
    "geocodedAt": "2024-02-12T15:00:00Z"
  },
  "audit": {
    "createdAt": "2024-02-12T15:00:00Z",
    "createdBy": {
      "id": 100,
      "name": "API User"
    },
    "concurrencyToken": "W/\"20240212150000\""
  },
  "_links": {
    "self": {
      "href": "/v3/clients/12345/addresses/2001"
    },
    "client": {
      "href": "/v3/clients/12345"
    },
    "validate": {
      "href": "/v3/clients/12345/addresses/2001/validate"
    }
  }
}
```

### V2 to V3 Migration Notes

#### Breaking Changes
1. **Geocoding**: Now automatically performed and included in response
2. **Property Details**: Enhanced structure with more fields
3. **Current Flag**: Added `isCurrent` computed field based on `residentTo` being null

#### Enhancements
1. **Validation Endpoint**: New address validation/verification endpoint
2. **Geocoding**: Automatic geocoding with accuracy indication
3. **Property Details**: Comprehensive property characteristics
4. **Status Management**: Better address lifecycle management

---

## Vulnerability API

### Overview

The Vulnerability API manages client vulnerability assessments and tracking for regulatory compliance.

**Base Path:** `/v3/clients/{clientId}/vulnerability`

**Key Features:**
- Vulnerability assessment and categorization
- Assessment history tracking
- Review scheduling and reminders
- Client portal suitability determination
- Action tracking and documentation

---

### OpenAPI 3.1 Specification

```yaml
openapi: 3.1.0
info:
  title: Vulnerability API
  version: 3.0.0

paths:
  /clients/{clientId}/vulnerability:
    parameters:
      - $ref: '#/components/parameters/ClientId'

    get:
      summary: Get current vulnerability
      description: Retrieve the current vulnerability assessment for a client
      operationId: getCurrentVulnerability
      tags:
        - Vulnerability
      security:
        - OAuth2:
            - client_vulnerability:read
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/VulnerabilityDocument'
        '404':
          description: No vulnerability assessment found

    put:
      summary: Update vulnerability
      description: Update or create vulnerability assessment
      operationId: updateVulnerability
      tags:
        - Vulnerability
      security:
        - OAuth2:
            - client_vulnerability:write
      parameters:
        - name: If-Match
          in: header
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/VulnerabilityUpdateRequest'
      responses:
        '200':
          description: Vulnerability updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/VulnerabilityDocument'
        '201':
          description: Vulnerability created successfully

  /clients/{clientId}/vulnerability/history:
    parameters:
      - $ref: '#/components/parameters/ClientId'

    get:
      summary: Get vulnerability history
      description: Retrieve all historical vulnerability assessments
      operationId: getVulnerabilityHistory
      tags:
        - Vulnerability
      security:
        - OAuth2:
            - client_vulnerability:read
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/VulnerabilityHistoryCollection'

components:
  schemas:
    VulnerabilityDocument:
      type: object
      required:
        - id
        - clientId
        - hasVulnerability
      properties:
        id:
          type: integer
          description: Unique vulnerability assessment identifier
          readOnly: true
          example: 3001
        href:
          type: string
          format: uri
          description: Link to this vulnerability assessment
          readOnly: true
          example: /v3/clients/12345/vulnerability
        clientId:
          type: integer
          description: Client identifier
          readOnly: true
          example: 12345
        client:
          $ref: '#/components/schemas/ClientRef'
        hasVulnerability:
          type: string
          enum: [Yes, No, Potential]
          description: Vulnerability status
          example: Yes
        type:
          type: string
          enum: [Temporary, Permanent]
          description: Vulnerability type
          example: Temporary
        categories:
          type: array
          description: Vulnerability categories
          items:
            type: string
            enum: [Health, LifeEvent, Resilience, Capability, Financial]
          example: [Health, Resilience]
        notes:
          type: string
          maxLength: 4000
          description: Detailed vulnerability notes
          example: Client has hearing impairment - requires written communication
        assessedOn:
          type: string
          format: date
          description: Date vulnerability was assessed
          example: "2024-01-15"
        reviewOn:
          type: string
          format: date
          description: Date vulnerability should be reviewed
          example: "2024-07-15"
        isClientPortalSuitable:
          type: string
          enum: [Yes, No, YesWithSupport]
          description: Client portal suitability determination
          example: YesWithSupport
        vulnerabilityActionTaken:
          type: string
          maxLength: 300
          description: Actions taken to support vulnerable client
          example: Arranged face-to-face meetings, provided large print documents
        isCurrent:
          type: boolean
          description: Indicates if this is the current assessment
          readOnly: true
          example: true
        audit:
          $ref: '#/components/schemas/AuditInfo'
        _links:
          type: object
          readOnly: true
          properties:
            self:
              $ref: '#/components/schemas/Link'
            client:
              $ref: '#/components/schemas/Link'
            history:
              $ref: '#/components/schemas/Link'

    VulnerabilityUpdateRequest:
      type: object
      required:
        - hasVulnerability
      properties:
        hasVulnerability:
          type: string
          enum: [Yes, No, Potential]
        type:
          type: string
          enum: [Temporary, Permanent]
        categories:
          type: array
          items:
            type: string
            enum: [Health, LifeEvent, Resilience, Capability, Financial]
        notes:
          type: string
          maxLength: 4000
        assessedOn:
          type: string
          format: date
        reviewOn:
          type: string
          format: date
        isClientPortalSuitable:
          type: string
          enum: [Yes, No, YesWithSupport]
        vulnerabilityActionTaken:
          type: string
          maxLength: 300

    VulnerabilityHistoryCollection:
      type: object
      properties:
        items:
          type: array
          items:
            $ref: '#/components/schemas/VulnerabilityDocument'
        totalCount:
          type: integer
          example: 5
        _links:
          type: object
          properties:
            self:
              $ref: '#/components/schemas/Link'
            client:
              $ref: '#/components/schemas/Link'
```

### Usage Example

```bash
PUT /v3/clients/12345/vulnerability
Authorization: Bearer {token}
Content-Type: application/json

{
  "hasVulnerability": "Yes",
  "type": "Temporary",
  "categories": ["Health", "Resilience"],
  "notes": "Client has hearing impairment - requires written communication and face-to-face meetings",
  "assessedOn": "2024-01-15",
  "reviewOn": "2024-07-15",
  "isClientPortalSuitable": "YesWithSupport",
  "vulnerabilityActionTaken": "Arranged face-to-face meetings, provided large print documents, confirmed understanding at each step"
}
```

---

## Data Protection Marketing API

### Overview

The Data Protection and Marketing API manages client consent preferences for marketing and data protection compliance (GDPR).

**Base Path:** `/v3/clients/{clientId}/marketing-preferences`

**Key Features:**
- Marketing consent by channel (email, phone, mail, SMS)
- Third-party sharing preferences
- Consent timestamp tracking
- Accessible format preferences
- Delivery method preferences

---

### OpenAPI 3.1 Specification

```yaml
openapi: 3.1.0
info:
  title: Data Protection & Marketing API
  version: 3.0.0

paths:
  /clients/{clientId}/marketing-preferences:
    parameters:
      - $ref: '#/components/parameters/ClientId'

    get:
      summary: Get marketing preferences
      description: Retrieve marketing and data protection preferences
      operationId: getMarketingPreferences
      tags:
        - MarketingPreferences
      security:
        - OAuth2:
            - client_data:read
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MarketingPreferencesDocument'

    put:
      summary: Update marketing preferences
      description: Update marketing and data protection preferences
      operationId: updateMarketingPreferences
      tags:
        - MarketingPreferences
      security:
        - OAuth2:
            - client_data:write
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/MarketingPreferencesUpdateRequest'
      responses:
        '200':
          description: Marketing preferences updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/MarketingPreferencesDocument'

components:
  schemas:
    MarketingPreferencesDocument:
      type: object
      required:
        - id
        - clientId
      properties:
        id:
          type: integer
          format: int64
          description: Unique identifier
          readOnly: true
          example: 4001
        href:
          type: string
          format: uri
          description: Link to this resource
          readOnly: true
          example: /v3/clients/12345/marketing-preferences
        clientId:
          type: integer
          description: Client identifier
          readOnly: true
          example: 12345
        client:
          $ref: '#/components/schemas/ClientRef'
        canContactForMarketingPurposes:
          type: string
          enum: [Yes, No, RelatedProductsOnly]
          description: Overall marketing consent
          example: RelatedProductsOnly
        consentedAt:
          type: string
          format: date-time
          description: Timestamp when consent was given
          example: "2024-01-01T10:00:00Z"
        companyContact:
          $ref: '#/components/schemas/ChannelPreferencesValue'
        thirdPartyContact:
          $ref: '#/components/schemas/ChannelPreferencesValue'
        deliveryMethod:
          type: string
          enum: [NoPreference, Email, Mail, Online]
          description: Preferred delivery method for communications
          example: Email
        accessibleFormat:
          type: string
          enum: [NoRequirement, LargePrint, Braille, Audio, EasyRead]
          description: Accessible format requirement
          example: LargePrint
        audit:
          $ref: '#/components/schemas/AuditInfo'
        _links:
          type: object
          readOnly: true
          properties:
            self:
              $ref: '#/components/schemas/Link'
            client:
              $ref: '#/components/schemas/Link'

    ChannelPreferencesValue:
      type: object
      description: Contact preferences by channel
      properties:
        allowTelephone:
          type: boolean
          description: Allow contact by telephone
          default: false
          example: true
        allowMail:
          type: boolean
          description: Allow contact by mail
          default: false
          example: true
        allowEmail:
          type: boolean
          description: Allow contact by email
          default: false
          example: true
        allowSms:
          type: boolean
          description: Allow contact by SMS
          default: false
          example: false
        allowSocialMedia:
          type: boolean
          description: Allow contact via social media
          default: false
          example: false
        allowAutomatedCalls:
          type: boolean
          description: Allow automated calls
          default: false
          example: false
        allowPfp:
          type: boolean
          description: Allow contact via preferred financial planner
          default: false
          example: true

    MarketingPreferencesUpdateRequest:
      type: object
      properties:
        canContactForMarketingPurposes:
          type: string
          enum: [Yes, No, RelatedProductsOnly]
        consentedAt:
          type: string
          format: date-time
        companyContact:
          $ref: '#/components/schemas/ChannelPreferencesValue'
        thirdPartyContact:
          $ref: '#/components/schemas/ChannelPreferencesValue'
        deliveryMethod:
          type: string
          enum: [NoPreference, Email, Mail, Online]
        accessibleFormat:
          type: string
          enum: [NoRequirement, LargePrint, Braille, Audio, EasyRead]
```

### Usage Example

```bash
PUT /v3/clients/12345/marketing-preferences
Authorization: Bearer {token}
Content-Type: application/json

{
  "canContactForMarketingPurposes": "RelatedProductsOnly",
  "consentedAt": "2024-01-01T10:00:00Z",
  "companyContact": {
    "allowTelephone": true,
    "allowMail": true,
    "allowEmail": true,
    "allowSms": false,
    "allowSocialMedia": false,
    "allowAutomatedCalls": false,
    "allowPfp": true
  },
  "thirdPartyContact": {
    "allowTelephone": false,
    "allowMail": false,
    "allowEmail": false,
    "allowSms": false,
    "allowSocialMedia": false,
    "allowAutomatedCalls": false,
    "allowPfp": false
  },
  "deliveryMethod": "Email",
  "accessibleFormat": "LargePrint"
}
```

---

## ID Verification API

### Overview

The ID Verification API manages proof of identity documents and client verification status for AML/KYC compliance.

**Base Path:** `/v3/clients/{clientId}/identity-verification`

**Key Features:**
- Multiple ID document support
- Document expiry tracking
- Verification status management
- Document linking (file storage integration)
- Country of issue tracking

---

### OpenAPI 3.1 Specification

```yaml
openapi: 3.1.0
info:
  title: ID Verification API
  version: 3.0.0

paths:
  /clients/{clientId}/identity-verification:
    parameters:
      - $ref: '#/components/parameters/ClientId'

    get:
      summary: List identity documents
      description: Retrieve all identity verification documents for a client
      operationId: listIdentityDocuments
      tags:
        - IdentityVerification
      security:
        - OAuth2:
            - client_data:read
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IdentityDocumentCollection'

    post:
      summary: Add identity document
      description: Add a new identity verification document
      operationId: createIdentityDocument
      tags:
        - IdentityVerification
      security:
        - OAuth2:
            - client_identification_data:write
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/IdentityDocumentCreateRequest'
      responses:
        '201':
          description: Identity document created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IdentityDocumentDocument'

  /clients/{clientId}/identity-verification/{documentId}:
    parameters:
      - $ref: '#/components/parameters/ClientId'
      - $ref: '#/components/parameters/DocumentId'

    get:
      summary: Get identity document
      description: Retrieve a specific identity document
      operationId: getIdentityDocument
      tags:
        - IdentityVerification
      security:
        - OAuth2:
            - client_data:read
            - client_identification_data:read
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/IdentityDocumentDocument'

    put:
      summary: Update identity document
      description: Update an existing identity document
      operationId: updateIdentityDocument
      tags:
        - IdentityVerification
      security:
        - OAuth2:
            - client_identification_data:write
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/IdentityDocumentUpdateRequest'
      responses:
        '200':
          description: Identity document updated successfully

    delete:
      summary: Delete identity document
      description: Remove an identity document
      operationId: deleteIdentityDocument
      tags:
        - IdentityVerification
      security:
        - OAuth2:
            - client_identification_data:write
      responses:
        '204':
          description: Identity document deleted successfully

components:
  parameters:
    DocumentId:
      name: documentId
      in: path
      required: true
      description: Unique document identifier
      schema:
        type: integer

  schemas:
    IdentityDocumentDocument:
      type: object
      required:
        - id
        - type
        - number
        - countryOfIssue
      properties:
        id:
          type: integer
          description: Unique document identifier
          readOnly: true
          example: 5001
        href:
          type: string
          format: uri
          description: Link to this document record
          readOnly: true
          example: /v3/clients/12345/identity-verification/5001
        clientId:
          type: integer
          description: Client identifier
          readOnly: true
          example: 12345
        type:
          type: string
          description: Type of identity document
          enum: [Passport, DriversLicense, NationalIdentityCard, BirthCertificate, ResidencePermit, Other]
          example: Passport
        number:
          type: string
          maxLength: 255
          description: Document number (obfuscated without client_identification_data:read scope)
          example: "****1234"
        issuedOn:
          type: string
          format: date
          description: Date document was issued
          example: "2019-01-15"
        expiresOn:
          type: string
          format: date
          description: Date document expires
          example: "2029-01-15"
        isExpired:
          type: boolean
          description: Indicates if document has expired
          readOnly: true
          example: false
        countryOfIssue:
          $ref: '#/components/schemas/CountryRef'
        countyOfIssue:
          $ref: '#/components/schemas/CountyRef'
        lastSeenOn:
          type: string
          format: date
          description: Date document was last physically verified
          example: "2024-01-10"
        verificationStatus:
          type: string
          enum: [NotVerified, Verified, Expired, Invalid]
          description: Verification status
          readOnly: true
          example: Verified
        documentFileHref:
          type: string
          format: uri
          description: Link to uploaded document file
          example: /v3/documents/abc123
        audit:
          $ref: '#/components/schemas/AuditInfo'
        _links:
          type: object
          readOnly: true
          properties:
            self:
              $ref: '#/components/schemas/Link'
            client:
              $ref: '#/components/schemas/Link'
            documentFile:
              $ref: '#/components/schemas/Link'

    IdentityDocumentCollection:
      type: object
      properties:
        items:
          type: array
          items:
            $ref: '#/components/schemas/IdentityDocumentDocument'
        totalCount:
          type: integer
          example: 2
        _links:
          type: object
          properties:
            self:
              $ref: '#/components/schemas/Link'
            client:
              $ref: '#/components/schemas/Link'

    IdentityDocumentCreateRequest:
      type: object
      required:
        - type
        - number
        - countryOfIssue
      properties:
        type:
          type: string
          enum: [Passport, DriversLicense, NationalIdentityCard, BirthCertificate, ResidencePermit, Other]
        number:
          type: string
          maxLength: 255
        issuedOn:
          type: string
          format: date
        expiresOn:
          type: string
          format: date
        countryOfIssue:
          type: object
          required: [code]
          properties:
            code:
              type: string
        countyOfIssue:
          type: object
          properties:
            code:
              type: string
        lastSeenOn:
          type: string
          format: date

    IdentityDocumentUpdateRequest:
      allOf:
        - $ref: '#/components/schemas/IdentityDocumentCreateRequest'
```

### Usage Example

```bash
POST /v3/clients/12345/identity-verification
Authorization: Bearer {token}
Content-Type: application/json

{
  "type": "Passport",
  "number": "123456789",
  "issuedOn": "2019-01-15",
  "expiresOn": "2029-01-15",
  "countryOfIssue": {
    "code": "GB"
  },
  "lastSeenOn": "2024-01-10"
}
```

---

## Estate Planning Integration

### Overview

Estate planning data spans two domains:
1. **Client Profile (CRM)** - Current documents (wills, power of attorney)
2. **Requirements** - Future objectives and planning goals

This section documents the integration pattern between these domains.

### CRM Domain - Document Status

**Fields in PersonValue:**
- `hasWill` - Boolean indicating if client has a will
- `isWillUpToDate` - Boolean indicating if will is current
- `isPowerOfAttorneyGranted` - Boolean indicating POA status
- `attorneyName` - Name of attorney if POA granted

**Usage:**
```json
{
  "person": {
    "hasWill": true,
    "isWillUpToDate": true,
    "isPowerOfAttorneyGranted": false,
    "attorneyName": null
  }
}
```

### Requirements Domain - Objectives

Estate planning objectives managed by `/v2/clients/{clientId}/objectives` in Requirements microservice.

**Integration Pattern:**
```
[CRM] Client Profile
  └─> hasWill, isPowerOfAttorneyGranted (current status)

[Requirements] Estate Planning Objectives
  └─> Future goals, will updates needed, POA planning

[UI] Estate Planning Screen
  └─> Combines both sources for complete view
```

### Recommendation

Clients should:
1. Use **Client Demographics API** to track current estate documents
2. Use **Requirements Objectives API** for planning future estate actions
3. Create aggregated view in UI for user experience

---

## Tax Details API

### Overview

The Tax Details API manages client tax-related information including tax reference numbers, residency status, and domicile.

**Note:** Much of this data is embedded in `PersonValue`, `TerritorialProfileValue`, and main client record.

### Tax-Related Fields

**In PersonValue:**
```yaml
niNumber:
  type: string
  description: National Insurance Number (UK)
  example: AB****56C  # Obfuscated

nationalClientIdentifier:
  type: string
  description: Country-specific unique tax identifier
  example: NI-AB123456C

taxReferenceNumber:
  type: string
  description: Tax reference number
  example: "****5678"  # Obfuscated
```

**In TerritorialProfileValue:**
```yaml
residency:
  type: string
  description: Residency status
  example: UK Resident

domicile:
  $ref: '#/components/schemas/CountryRef'

taxResidency:
  type: array
  items:
    $ref: '#/components/schemas/CountryRef'
  description: Countries of tax residency
```

**In CorporateValue:**
```yaml
vatNumber:
  type: string
  description: VAT registration number
  example: GB123456789
```

**In TrustValue:**
```yaml
taxReferenceNumber:
  type: string
  description: Trust tax reference
  example: UTR****789
```

### Security Considerations

All tax-related fields require `client_identification_data:read` scope to view unobfuscated values.

**Without scope:**
```json
{
  "niNumber": "AB****56C",
  "taxReferenceNumber": "****5678"
}
```

**With scope:**
```json
{
  "niNumber": "AB123456C",
  "taxReferenceNumber": "1234567890"
}
```

---

## V2 to V3 Migration Guide

### Migration Timeline

| Phase | Timeline | Activity | Status |
|-------|----------|----------|--------|
| **Phase 1: Design** | Q1 2024 | V3 API specifications completed | ✓ Complete |
| **Phase 2: Development** | Q2 2024 | V3 endpoints implementation | In Progress |
| **Phase 3: Beta** | Q2-Q3 2024 | Beta testing with select partners | Planned |
| **Phase 4: GA** | Q4 2024 | General availability, V2 deprecated | Planned |
| **Phase 5: V2 Sunset** | Q2 2025 | V2 endpoints return 410 Gone | Planned |

### Breaking Changes Summary

#### All APIs

1. **URL Structure**: `/v2/...` → `/v3/...`
2. **Error Format**: Standardized error response structure
3. **Concurrency**: `If-Match` header required for PUT/PATCH
4. **Authentication**: OAuth 2.0 scopes more granular

#### Client Demographics

1. **Nationality**: String → CountryRef object
2. **Date Format**: Consistent ISO 8601 date formatting
3. **Territorial Profile**: New structured object for residency/domicile
4. **Health Profile**: New structured object for health data

#### Contact Details

1. **New Types**: Added social media and messaging app types
2. **Verification**: New `isVerified` and `verifiedOn` fields
3. **Primary/Default**: Distinction between `isPrimary` and `isDefault`

#### Addresses

1. **Geocoding**: Automatic geocoding included in response
2. **Current Flag**: New `isCurrent` computed field
3. **Property Details**: Expanded structure

### Migration Steps

#### Step 1: Update Authentication

**V2:**
```
Authorization: Bearer {token}
Scope: client_data
```

**V3:**
```
Authorization: Bearer {token}
Scope: client_data:read client_data:write
```

#### Step 2: Update Base URLs

**V2:**
```
https://api.intelliflo.com/v2/clients/12345
```

**V3:**
```
https://api.intelliflo.com/v3/clients/12345
```

#### Step 3: Update Request Formats

**V2 Create Client:**
```json
{
  "Person": {
    "FirstName": "John",
    "LastName": "Smith",
    "Nationality": "British"
  },
  "CurrentAdviser": {
    "Id": 789
  }
}
```

**V3 Create Client:**
```json
{
  "partyType": "Person",
  "person": {
    "firstName": "John",
    "lastName": "Smith",
    "nationality": {
      "code": "GB"
    }
  },
  "currentAdviser": {
    "id": 789
  }
}
```

#### Step 4: Handle Response Differences

**V2 Response:**
```json
{
  "Id": 12345,
  "Href": "/v2/clients/12345",
  "Name": "John Smith",
  "AddressesHref": "/v2/clients/12345/addresses"
}
```

**V3 Response:**
```json
{
  "id": 12345,
  "href": "/v3/clients/12345",
  "name": "John Smith",
  "_links": {
    "self": {
      "href": "/v3/clients/12345"
    },
    "addresses": {
      "href": "/v3/clients/12345/addresses",
      "title": "Client addresses"
    }
  }
}
```

#### Step 5: Implement Concurrency Control

**V3 Update with Concurrency:**
```http
PUT /v3/clients/12345
If-Match: W/"20240212143000"
Content-Type: application/json

{
  ...
}
```

### Backward Compatibility

The following V2 behaviors are maintained in V3:

1. **Collection Pagination**: OData-style `$top`, `$skip`, `$filter`, `$orderby`
2. **Resource IDs**: Same numeric identifiers
3. **Core Data Model**: Entity relationships unchanged
4. **Event Publishing**: Same domain events published

### Code Examples

#### V2 to V3 Client Creation

**V2 Code (C#):**
```csharp
var client = new ClientDocument
{
    Person = new PersonDocument
    {
        FirstName = "John",
        LastName = "Smith",
        Nationality = "British",
        DateOfBirth = new DateTime(1985, 3, 15)
    },
    CurrentAdviser = new NamedAdviserReference { Id = 789 }
};

var response = await httpClient.PostAsJsonAsync("/v2/clients", client);
```

**V3 Code (C#):**
```csharp
var client = new ClientCreateRequest
{
    PartyType = "Person",
    Person = new PersonValue
    {
        FirstName = "John",
        LastName = "Smith",
        Nationality = new CountryRef { Code = "GB" },
        DateOfBirth = "1985-03-15"
    },
    CurrentAdviser = new AdviserRef { Id = 789 }
};

var response = await httpClient.PostAsJsonAsync("/v3/clients", client);
```

---

## Implementation Considerations

### Performance

1. **Caching**: All GET endpoints support ETag for caching
2. **Pagination**: Default page size 25, max 100
3. **Partial Responses**: Use `$select` to request specific fields only
4. **Batch Operations**: Bulk operations not supported - use parallel requests

### Security

1. **TLS 1.3 Required**: All API calls must use TLS 1.3+
2. **Rate Limiting**: 1000 requests per minute per tenant
3. **PII Handling**: Automatic obfuscation without appropriate scopes
4. **Audit Logging**: All mutations logged with user context

### Error Handling

1. **Retry Logic**: Implement exponential backoff for 429, 500, 503
2. **Idempotency**: PUT and DELETE are idempotent, POST is not
3. **Validation**: Comprehensive validation errors in `error.details` array

### Testing

1. **Staging Environment**: `https://api-staging.intelliflo.com/v3`
2. **Test Data**: Sandbox tenant with test clients available
3. **Mock Server**: OpenAPI-based mock server available for development

### Support

- **API Documentation**: https://developer.intelliflo.com/v3
- **Support Email**: api-support@intelliflo.com
- **Status Page**: https://status.intelliflo.com
- **Change Log**: https://developer.intelliflo.com/changelog

---

## Appendices

### Appendix A: Complete OpenAPI Specification

The complete OpenAPI 3.1 specification files are available at:
- **Client Demographics**: `/specs/v3/client-demographics.yaml`
- **Contact Details**: `/specs/v3/contact-details.yaml`
- **Addresses**: `/specs/v3/addresses.yaml`
- **Vulnerability**: `/specs/v3/vulnerability.yaml`
- **Marketing Preferences**: `/specs/v3/marketing-preferences.yaml`
- **Identity Verification**: `/specs/v3/identity-verification.yaml`

### Appendix B: Postman Collection

Import the V3 Client Profile API Postman collection:
```
https://api.intelliflo.com/v3/postman/client-profile.json
```

### Appendix C: SDK Support

Official SDKs available:
- **.NET**: `IntelliFlo.Api.Client.V3` (NuGet)
- **JavaScript**: `@intelliflo/api-client-v3` (npm)
- **Python**: `intelliflo-api-client-v3` (PyPI)

### Appendix D: Reference Data

Common reference data endpoints:
- **Countries**: `/v3/reference/countries`
- **Counties**: `/v3/reference/counties`
- **Client Categories**: `/v3/reference/client-categories`
- **Service Statuses**: `/v3/reference/service-statuses`

---

## Document Control

| Attribute | Value |
|-----------|-------|
| **Document ID** | API-V3-CLIENT-PROFILE-001 |
| **Version** | 3.0.0 |
| **Status** | Design Specification |
| **Author** | API Architecture Team |
| **Date Created** | 2026-02-12 |
| **Last Updated** | 2026-02-12 |
| **Approved By** | Pending |
| **Review Date** | 2024-Q2 |

---

**END OF DOCUMENT**
