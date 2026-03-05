# FactFind API Design

**Version:** 3.0
**Date:** 2026-03-05
**Status:** Current

## Table of Contents

1. [Introduction](#1-introduction)
2. [Business Context](#2-business-context)
3. [API Overview](#3-api-overview)
4. [Resource Model](#4-resource-model)
5. [API Operations](#5-api-operations)
6. [Request/Response Specifications](#6-requestresponse-specifications)
7. [Data Model](#7-data-model)
8. [Business Rules](#8-business-rules)
9. [Error Handling](#9-error-handling)
10. [Security](#10-security)
11. [Performance](#11-performance)
12. [Testing](#12-testing)
13. [References](#13-references)
14. [Appendices](#14-appendices)

---

## 1. Introduction

### 1.1 Purpose

The FactFind API provides management of FactFind records, which are the root aggregate containing all client financial information, advice processes, and regulatory documentation. A FactFind represents a formal data-gathering exercise as part of the financial advice process.

### 1.2 Scope

This API covers:
- FactFind creation and management
- Client associations with FactFinds
- Meeting details and recording compliance
- Disclosure document tracking
- FactFind filtering and search
- FactFind lifecycle management

**Out of Scope:**
- Detailed client information (covered by Client API)
- Financial data (covered by specific entity APIs: Assets, Liabilities, Income, etc.)
- Advice and suitability reports (handled by advice systems)

### 1.3 Conventions

- **Collection Resource**: Multiple FactFinds can exist per organization
- **Collection Structure**: List responses use collection wrapper with pagination links at root level:
  - `href` - current page URL
  - `first_href` - first page URL
  - `last_href` - last page URL
  - `next_href` - next page URL (null if on last page)
  - `prev_href` - previous page URL (null if on first page)
  - `items` - array of resources
  - `count` - total count of items across all pages
- **Filtering Support**: GET list endpoint supports QueryLang filtering (Intelliflo standard)
- **Simple Hypermedia**: Individual resources include `href` property for navigation
- **Client References**: Clients array contains read-only references
- **Meeting Recording**: Meeting type enum captures recording compliance
- **Disclosure Tracking**: Array of issued disclosure documents with dates
- All dates use ISO 8601 format (YYYY-MM-DD)
- All monetary amounts use multi-currency format

---

## 2. Business Context

### 2.1 Business Requirements

FactFind is essential for:
1. **Regulatory Compliance**: FCA requires comprehensive data gathering before advice
2. **Suitability Assessment**: Foundation for all advice and recommendations
3. **Audit Trail**: Records when, where, and how information was gathered
4. **Client Relationship**: Links multiple clients (joint FactFinds)
5. **Disclosure Compliance**: Tracks regulatory disclosures issued to clients
6. **Recording Compliance**: Documents meeting type and recording consent

### 2.2 Use Cases

**UC-FF-01: Create FactFind for New Client**
- Adviser meets new client for initial consultation
- Create FactFind with meeting details
- Associate client(s) with FactFind
- Issue disclosure documents
- Begin data gathering process

**UC-FF-02: Joint FactFind for Couple**
- Couple attend meeting together
- Create FactFind with both clients
- Record which clients present at meeting
- Issue disclosures to both clients
- Gather joint financial information

**UC-FF-03: Update Meeting Details**
- Record subsequent meeting date and type
- Update clients present
- Note if other audience present (e.g., interpreter, family member)
- Add meeting notes

**UC-FF-04: Track Disclosure Documents**
- Issue Combined Initial Disclosure Document
- Record issuance date
- Issue Terms of Business
- Issue Key Facts About Services
- Maintain compliance audit trail

**UC-FF-05: Filter FactFinds by Client**
- View all FactFinds for specific client
- Use filter: `?filter=clients.id eq 123`
- Returns FactFinds where client 123 is associated

**UC-FF-06: Telephone Meeting with Recording**
- Telephone meeting with client
- Record meeting type as TelephoneRecorded
- Capture client consent for recording
- Meet FCA recording requirements

### 2.3 Constraints

- FactFind must have at least one associated client
- Meeting type enum must be one of specified values
- Disclosure documents must have valid type and issuance date
- Client names in clients array are read-only (sourced from Client API)

---

## 3. API Overview

### 3.1 Resource Model

```
FactFind
├── id (system generated)
├── href (system generated)
├── clients[] (read-only references)
│   ├── id
│   ├── href
│   └── name (read-only)
├── meeting
│   ├── meetingOn (date)
│   ├── meetingType (enum)
│   ├── clientsPresent[]
│   │   ├── id
│   │   ├── href
│   │   └── name
│   ├── anyOtherAudience (boolean)
│   └── notes (text)
└── disclosureKeyfacts[]
    ├── Type (enum)
    └── IssuedOn (date)
```

### 3.2 Resource Characteristics

| Characteristic | Value |
|---|---|
| Resource Type | Collection |
| Mutability | Fully mutable via PUT |
| Lifecycle | Created, active, archived |
| Versioning | Implicit via updatedAt timestamp |
| Parent Resource | None (root aggregate) |

---

## 4. Resource Model

### 4.1 Resource Structure

**FactFind Root:**
- Aggregate root for all client financial data
- Contains references to associated clients
- Stores meeting metadata and compliance information
- Tracks disclosure document issuance
- Gateway to all sub-resources (assets, liabilities, income, etc.)

**Client References:**
- Read-only array of associated clients
- Client names populated from Client API
- Supports joint FactFinds (multiple clients)

**Meeting Object:**
- Records when meeting occurred
- Captures meeting type (including recording status)
- Lists which clients attended
- Flags other audience present
- Free-text notes

**Disclosure Keyfacts Array:**
- Regulatory disclosure documents issued
- Each has type and issuance date
- Audit trail for FCA compliance

### 4.2 Resource Relationships

```
FactFind (1) ──→ (N) Client [association]
FactFind (1) ──→ (N) Asset
FactFind (1) ──→ (N) Liability
FactFind (1) ──→ (N) Income
FactFind (1) ──→ (N) Expenditure
FactFind (1) ──→ (N) Employment
FactFind (1) ──→ (N) Mortgage
FactFind (1) ──→ (N) Investment
FactFind (1) ──→ (N) PersonalProtection
[... all other entities hang off FactFind]
```

### 4.3 Resource Lifecycle

**FactFind Record:**
1. **Created**: POST creates new FactFind with initial data
2. **Active**: Being populated with client data, meetings ongoing
3. **Complete**: Data gathering finished, ready for advice
4. **Review**: Updated during annual reviews or life events
5. **Archived**: Historical record, no longer active

---

## 5. API Operations

### 5.1 Operation Summary

| Operation | Method | Endpoint | Description |
|---|---|---|---|
| Create FactFind | POST | `/v2/factfinds` | Create new FactFind |
| List FactFinds | GET | `/v2/factfinds` | List all FactFinds (with filtering) |
| Get FactFind | GET | `/v2/factfinds/{id}` | Retrieve specific FactFind |
| Update FactFind | PUT | `/v2/factfinds/{id}` | Update FactFind |

### 5.2 Create FactFind

**Endpoint:** `POST /v2/factfinds`

**Description:** Creates a new FactFind record.

**Request Body:** FactFind object (without id and href)

**Response Codes:**
- `201 Created`: FactFind created successfully
- `400 Bad Request`: Invalid data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** Complete FactFind object with assigned id

### 5.3 List FactFinds

**Endpoint:** `GET /v2/factfinds`

**Description:** Retrieves a list of FactFinds with optional filtering.

**Query Parameters:**
- `filter` (string, optional): QueryLang filter expression
  - Example: `?filter=clients.id eq 123` - Filter FactFinds by client ID
  - Syntax: `field operator value` with `and` to chain expressions
  - Operators: `eq`, `ne`, `gt`, `ge`, `lt`, `le`, `in`, `startswith`
- `page` (integer, optional): Page number (1-indexed, default: 1)
- `pageSize` (integer, optional): Items per page (default: 25, max: 100)

**Response Codes:**
- `200 OK`: FactFinds retrieved successfully
- `400 Bad Request`: Invalid filter syntax
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** Collection object with pagination links at root level
- `href` - current page URL
- `first_href` - first page URL
- `last_href` - last page URL
- `next_href` - next page URL (null if no next page)
- `prev_href` - previous page URL (null if no previous page)
- `items` - array of FactFind objects
- `count` - total count across all pages

### 5.4 Get FactFind

**Endpoint:** `GET /v2/factfinds/{id}`

**Description:** Retrieves a specific FactFind by ID.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Response Codes:**
- `200 OK`: FactFind found
- `404 Not Found`: FactFind not found
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** FactFind object

### 5.5 Update FactFind

**Endpoint:** `PUT /v2/factfinds/{id}`

**Description:** Updates an existing FactFind record.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Request Body:** Complete FactFind object

**Response Codes:**
- `200 OK`: FactFind updated successfully
- `400 Bad Request`: Invalid data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: FactFind not found
- `409 Conflict`: Concurrent modification detected

**Response Body:** Updated FactFind object

---

## 6. Request/Response Specifications

### 6.1 Create FactFind Request

```json
{
  "clients": [
    {
      "id": 123
    },
    {
      "id": 124
    }
  ],
  "meeting": {
    "meetingOn": "2026-03-05",
    "meetingType": "FaceToFace",
    "clientsPresent": [
      {
        "id": 123
      },
      {
        "id": 124
      }
    ],
    "anyOtherAudience": false,
    "notes": "Initial consultation to discuss retirement planning and mortgage options."
  },
  "disclosureKeyfacts": [
    {
      "Type": "CombinedInitialDisclosureDocument",
      "IssuedOn": "2026-03-05"
    },
    {
      "Type": "TermsOfBusiness",
      "IssuedOn": "2026-03-05"
    }
  ]
}
```

### 6.2 Create FactFind Response

```json
{
  "id": 679,
  "href": "/api/v2/factfinds/679",
  "clients": [
    {
      "id": 123,
      "href": "/api/v2/factfinds/679/clients/123",
      "name": "John Smith"
    },
    {
      "id": 124,
      "href": "/api/v2/factfinds/679/clients/124",
      "name": "Jane Smith"
    }
  ],
  "meeting": {
    "meetingOn": "2026-03-05",
    "meetingType": "FaceToFace",
    "clientsPresent": [
      {
        "id": 123,
        "href": "/api/v2/factfinds/679/clients/123",
        "name": "John Smith"
      },
      {
        "id": 124,
        "href": "/api/v2/factfinds/679/clients/124",
        "name": "Jane Smith"
      }
    ],
    "anyOtherAudience": false,
    "notes": "Initial consultation to discuss retirement planning and mortgage options."
  },
  "disclosureKeyfacts": [
    {
      "Type": "CombinedInitialDisclosureDocument",
      "IssuedOn": "2026-03-05"
    },
    {
      "Type": "TermsOfBusiness",
      "IssuedOn": "2026-03-05"
    }
  ]
}
```

### 6.3 Get FactFind Response

```json
{
  "id": 679,
  "href": "/api/v2/factfinds/679",
  "clients": [
    {
      "id": 123,
      "href": "/api/v2/factfinds/679/clients/123",
      "name": "John Smith"
    },
    {
      "id": 124,
      "href": "/api/v2/factfinds/679/clients/124",
      "name": "Jane Smith"
    }
  ],
  "meeting": {
    "meetingOn": "2026-03-05",
    "meetingType": "FaceToFace",
    "clientsPresent": [
      {
        "id": 123,
        "href": "/api/v2/factfinds/679/clients/123",
        "name": "John Smith"
      },
      {
        "id": 124,
        "href": "/api/v2/factfinds/679/clients/124",
        "name": "Jane Smith"
      }
    ],
    "anyOtherAudience": false,
    "notes": "Initial consultation to discuss retirement planning and mortgage options."
  },
  "disclosureKeyfacts": [
    {
      "Type": "CombinedInitialDisclosureDocument",
      "IssuedOn": "2026-03-05"
    },
    {
      "Type": "TermsOfBusiness",
      "IssuedOn": "2026-03-05"
    }
  ]
}
```

### 6.4 List FactFinds Response

```json
{
  "href": "/api/v2/factfinds?page=1&pageSize=25",
  "first_href": "/api/v2/factfinds?page=1&pageSize=25",
  "last_href": "/api/v2/factfinds?page=1&pageSize=25",
  "next_href": null,
  "prev_href": null,
  "items": [
    {
      "id": 679,
      "href": "/api/v2/factfinds/679",
      "clients": [
        {
          "id": 123,
          "href": "/api/v2/factfinds/679/clients/123",
          "name": "John Smith"
        }
      ],
      "meeting": {
        "meetingOn": "2026-03-05",
        "meetingType": "FaceToFace",
        "clientsPresent": [
          {
            "id": 123,
            "href": "/api/v2/factfinds/679/clients/123",
            "name": "John Smith"
          }
        ],
        "anyOtherAudience": false,
        "notes": "Initial consultation."
      },
      "disclosureKeyfacts": [
        {
          "Type": "CombinedInitialDisclosureDocument",
          "IssuedOn": "2026-03-05"
        }
      ]
    },
    {
      "id": 680,
      "href": "/api/v2/factfinds/680",
      "clients": [
        {
          "id": 125,
          "href": "/api/v2/factfinds/680/clients/125",
          "name": "Alice Johnson"
        }
      ],
      "meeting": {
        "meetingOn": "2026-03-06",
        "meetingType": "Videocall",
        "clientsPresent": [
          {
            "id": 125,
            "href": "/api/v2/factfinds/680/clients/125",
            "name": "Alice Johnson"
          }
        ],
        "anyOtherAudience": false,
        "notes": "Video consultation for investment review."
      },
      "disclosureKeyfacts": [
        {
          "Type": "DisclosureDocument",
          "IssuedOn": "2026-03-06"
        }
      ]
    }
  ],
  "count": 2
}
```

### 6.5 Filter FactFinds by Client Example

**Request:**
```
GET /v2/factfinds?filter=clients.id eq 123
```

**Response:** 200 OK
```json
{
  "href": "/api/v2/factfinds?filter=clients.id eq 123",
  "first_href": "/api/v2/factfinds?filter=clients.id eq 123&page=1&pageSize=25",
  "last_href": "/api/v2/factfinds?filter=clients.id eq 123&page=1&pageSize=25",
  "next_href": null,
  "prev_href": null,
  "items": [
    {
      "id": 679,
      "href": "/api/v2/factfinds/679",
      "clients": [
        {
          "id": 123,
          "href": "/api/v2/factfinds/679/clients/123",
          "name": "John Smith"
        },
        {
          "id": 124,
          "href": "/api/v2/factfinds/679/clients/124",
          "name": "Jane Smith"
        }
      ],
      "meeting": {
        "meetingOn": "2026-03-05",
        "meetingType": "FaceToFace",
        "clientsPresent": [
          {
            "id": 123,
            "href": "/api/v2/factfinds/679/clients/123",
            "name": "John Smith"
          }
        ],
        "anyOtherAudience": false,
        "notes": "Annual review meeting."
      },
      "disclosureKeyfacts": []
    }
  ],
  "count": 1
}
```

### 6.6 Update FactFind Request

```json
{
  "id": 679,
  "href": "/api/v2/factfinds/679",
  "clients": [
    {
      "id": 123
    },
    {
      "id": 124
    }
  ],
  "meeting": {
    "meetingOn": "2026-03-12",
    "meetingType": "TelephoneRecorded",
    "clientsPresent": [
      {
        "id": 123
      }
    ],
    "anyOtherAudience": false,
    "notes": "Follow-up call recorded with client consent. Discussed investment portfolio adjustments."
  },
  "disclosureKeyfacts": [
    {
      "Type": "CombinedInitialDisclosureDocument",
      "IssuedOn": "2026-03-05"
    },
    {
      "Type": "TermsOfBusiness",
      "IssuedOn": "2026-03-05"
    },
    {
      "Type": "KeyfactsAboutServices",
      "IssuedOn": "2026-03-12"
    }
  ]
}
```

---

## 7. Data Model

### 7.1 FactFind Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| id | integer | Yes | Yes | Unique system identifier |
| href | string | Yes | Yes | API resource link |
| clients | ClientReference[] | Yes | Partial | Array of associated clients (id required, name read-only) |
| meeting | Meeting | No | No | Meeting details |
| disclosureKeyfacts | DisclosureKeyfact[] | No | No | Array of issued disclosure documents |

### 7.2 ClientReference Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| id | integer | Yes | No | Client identifier |
| href | string | No | Yes | Link to client resource (populated by system) |
| name | string | No | Yes | Client name (populated from Client API) |

### 7.3 Meeting Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| meetingOn | date | No | No | Date meeting occurred (ISO 8601) |
| meetingType | enum | No | No | Type of meeting (see MeetingType enum) |
| clientsPresent | ClientReference[] | No | Partial | Clients present at meeting (id required, name read-only) |
| anyOtherAudience | boolean | No | No | Whether other audience present (interpreter, family, etc.) |
| notes | string | No | No | Meeting notes (max 5000 chars) |

### 7.4 DisclosureKeyfact Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| Type | enum | Yes | No | Disclosure document type (see DisclosureType enum) |
| IssuedOn | date | Yes | No | Date document issued to client (ISO 8601) |

### 7.5 Enumerations

**MeetingType:**
- `Electronic` - Electronic meeting (e.g., email, online form)
- `ElectronicRecorded` - Electronic meeting with recording
- `Videocall` - Video call meeting
- `VideocallRecorded` - Video call with recording
- `FaceToFace` - In-person meeting
- `FaceToFaceRecorded` - In-person meeting with recording
- `Telephone` - Telephone call
- `TelephoneRecorded` - Telephone call with recording (client consent required)

**DisclosureType:**
- `CombinedDisclosureDocuments` - Combined disclosure documents
- `CombinedInitialDisclosureDocument` - Combined initial disclosure document (CIDD)
- `DisclosureDocument` - General disclosure document
- `KeyfactsAboutCostOfServices` - Key facts about cost of services
- `KeyfactsAboutServices` - Key facts about services
- `ServiceCostDisclosureDocument` - Service cost disclosure document
- `TermsRefundOfFees` - Terms for refund of fees
- `TermsOfBusiness` - Terms of business (TOB)

---

## 8. Business Rules

### 8.1 FactFind Creation Rules

**BR-FF-01: Client Association Required**
- FactFind must have at least one associated client
- POST request must include clients array with at least one client ID
- Returns 400 Bad Request if clients array empty or missing

**BR-FF-02: Client ID Validation**
- All client IDs in clients array must exist in Client API
- Returns 400 Bad Request if client ID not found
- Client names populated automatically from Client API

### 8.2 Client Reference Rules

**BR-FF-03: Read-Only Client Names**
- Client name field is read-only
- Populated automatically from Client API based on client ID
- PUT requests can update client IDs but not names
- Names refreshed on every GET request

**BR-FF-04: Joint FactFinds**
- Multiple clients can be associated with one FactFind
- Common for couples, families, business partners
- All associated clients have equal visibility to FactFind data

### 8.3 Meeting Rules

**BR-FF-05: Meeting Type Enum Validation**
- meetingType must be one of specified enum values
- Returns 400 Bad Request if invalid meeting type
- Case-sensitive enum matching

**BR-FF-06: Recording Consent**
- If meetingType includes "Recorded", must document client consent
- Use meeting notes to record consent obtained
- FCA requirement for call/meeting recording

**BR-FF-07: Clients Present Validation**
- Clients in clientsPresent array must be subset of clients array
- Cannot have client present who is not associated with FactFind
- Returns 400 Bad Request if validation fails

**BR-FF-08: Meeting Notes Length**
- Meeting notes maximum 5000 characters
- Returns 400 Bad Request if exceeded

**BR-FF-09: Other Audience Flag**
- Set anyOtherAudience to true if non-client present
- Examples: interpreter, family member, solicitor, accountant
- Document in notes who was present

### 8.4 Disclosure Rules

**BR-FF-10: Disclosure Type Enum Validation**
- Type must be one of specified enum values
- Returns 400 Bad Request if invalid disclosure type
- Case-sensitive enum matching

**BR-FF-11: Issuance Date Validation**
- IssuedOn must be valid date in past or today
- Cannot be in the future
- Format: ISO 8601 (YYYY-MM-DD)

**BR-FF-12: CIDD Requirement**
- FCA requires Combined Initial Disclosure Document or equivalent
- Should be issued before providing advice
- Audit trail via disclosureKeyfacts array

**BR-FF-13: Disclosure Immutability**
- Once issued, disclosure documents should not be removed
- Can add new disclosures via PUT
- Maintains compliance audit trail

### 8.5 Filtering Rules

**BR-FF-14: QueryLang Filter Syntax**
- Filter parameter supports QueryLang expressions (Intelliflo standard)
- Format: `field operator value` with `and` to chain expressions
- Operators: `eq` (equal), `ne` (not equal), `gt` (greater than), `ge` (greater than or equal), `lt` (less than), `le` (less than or equal), `in` (intersection), `startswith`
- Example: `clients.id eq 123`
- Example with chaining: `clients.id eq 123 and meeting.meetingOn gt 2026-01-01`
- Invalid syntax returns 400 Bad Request

**BR-FF-15: Filter by Client ID**
- Most common filter: `filter=clients.id eq 123`
- Returns all FactFinds where client 123 is associated
- Includes joint FactFinds
- Can combine with other filters using `and` operator

---

## 9. Error Handling

### 9.1 Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid meeting type value",
    "details": [
      {
        "field": "meeting.meetingType",
        "issue": "Value must be one of: Electronic, ElectronicRecorded, Videocall, VideocallRecorded, FaceToFace, FaceToFaceRecorded, Telephone, TelephoneRecorded",
        "value": "InPerson"
      }
    ]
  }
}
```

### 9.2 Common Error Codes

| Code | HTTP Status | Description |
|---|---|---|
| FACTFIND_NOT_FOUND | 404 | FactFind not found |
| VALIDATION_ERROR | 400 | Request data validation failed |
| INVALID_MEETING_TYPE | 400 | Meeting type enum invalid |
| INVALID_DISCLOSURE_TYPE | 400 | Disclosure type enum invalid |
| CLIENT_NOT_FOUND | 400 | Referenced client ID not found |
| NO_CLIENTS_ASSOCIATED | 400 | FactFind must have at least one client |
| INVALID_CLIENT_PRESENT | 400 | Client in clientsPresent not in clients array |
| INVALID_FILTER_SYNTAX | 400 | Filter query parameter syntax error |
| TEXT_TOO_LONG | 400 | Text field exceeds maximum length |
| UNAUTHORIZED | 401 | Authentication required |
| FORBIDDEN | 403 | Insufficient permissions |
| CONCURRENT_MODIFICATION | 409 | Record modified by another user |

### 9.3 Validation Error Examples

**Invalid Meeting Type:**
```json
{
  "error": {
    "code": "INVALID_MEETING_TYPE",
    "message": "Invalid meeting type value",
    "details": [
      {
        "field": "meeting.meetingType",
        "issue": "Value must be one of: Electronic, ElectronicRecorded, Videocall, VideocallRecorded, FaceToFace, FaceToFaceRecorded, Telephone, TelephoneRecorded",
        "value": "Zoom"
      }
    ]
  }
}
```

**Client Not Found:**
```json
{
  "error": {
    "code": "CLIENT_NOT_FOUND",
    "message": "Referenced client does not exist",
    "details": [
      {
        "field": "clients[0].id",
        "issue": "Client ID not found in system",
        "value": 99999
      }
    ]
  }
}
```

**Invalid Client Present:**
```json
{
  "error": {
    "code": "INVALID_CLIENT_PRESENT",
    "message": "Client in clientsPresent must be in clients array",
    "details": [
      {
        "field": "meeting.clientsPresent[1].id",
        "issue": "Client 125 is not associated with this FactFind",
        "value": 125
      }
    ]
  }
}
```

---

## 10. Security

### 10.1 Authentication

- All endpoints require valid authentication token
- Token must be included in `Authorization` header
- Format: `Authorization: Bearer {token}`
- Expired tokens return 401 Unauthorized

### 10.2 Authorization

**Resource-Level Permissions:**
- User must have access to the FactFind
- User must have permission to view/edit FactFind data
- Adviser can only access FactFinds they created or are assigned to
- Admin users can access all FactFinds within their organization

**Operation-Level Permissions:**
- `GET`: Requires "View FactFind Data" permission
- `POST`: Requires "Create FactFind" permission
- `PUT`: Requires "Edit FactFind Data" permission

**Client-Level Security:**
- User must have access to ALL associated clients
- If user cannot access any client, entire FactFind is inaccessible
- Protects client confidentiality in joint FactFinds

### 10.3 Data Protection

**Sensitive Information:**
- FactFind is gateway to all client financial data
- Meeting notes may contain personal information
- Disclosure documents indicate advice process
- Access logs maintained for audit purposes

**GDPR Compliance:**
- FactFind data is personal data under GDPR
- Client consent required for processing
- Right to access: clients can request their FactFind data
- Right to erasure: clients can request deletion (subject to retention rules)
- Data retention: follow firm's data retention policy (typically 6+ years)

---

## 11. Performance

### 11.1 Response Time Targets

| Operation | Target | Maximum |
|---|---|---|
| GET FactFind | < 200ms | 500ms |
| POST FactFind | < 300ms | 1000ms |
| PUT FactFind | < 300ms | 1000ms |
| GET FactFinds (list) | < 500ms | 2000ms |

### 11.2 Scalability

**FactFind Collection:**
- Typical: 100-10,000 FactFinds per organization
- Large firms: 50,000+ FactFinds
- Pagination recommended for list operations (future enhancement)

**Client Association:**
- Typical: 1-2 clients per FactFind
- Maximum: 10 clients per FactFind (edge case)

### 11.3 Caching

**FactFind Records:**
- Cache-Control: private, max-age=300 (5 minutes)
- ETag support for conditional requests
- Last-Modified header included
- Client names cached for performance

### 11.4 Rate Limiting

- 100 requests per minute per user
- 1000 requests per hour per organization
- Rate limit headers included in responses:
  - `X-RateLimit-Limit`: Total requests allowed
  - `X-RateLimit-Remaining`: Requests remaining
  - `X-RateLimit-Reset`: Unix timestamp when limit resets

---

## 12. Testing

### 12.1 Test Scenarios

**TS-FF-01: Create Single Client FactFind**
1. POST FactFind with one client
2. Verify 201 Created response
3. Verify client name populated
4. Verify href generated
5. GET FactFind to confirm persistence

**TS-FF-02: Create Joint FactFind**
1. POST FactFind with two clients
2. Verify both clients in response
3. Verify both client names populated
4. GET FactFind to confirm both clients

**TS-FF-03: Update Meeting Details**
1. FactFind exists
2. PUT with updated meeting date and type
3. Verify 200 OK response
4. Verify changes persisted
5. GET FactFind to confirm update

**TS-FF-04: Add Disclosure Document**
1. FactFind exists with one disclosure
2. PUT with additional disclosure added
3. Verify both disclosures in response
4. GET FactFind to confirm both present

**TS-FF-05: Filter by Client ID**
1. Multiple FactFinds exist
2. GET with filter: `?filter=clients.id eq 123`
3. Verify only FactFinds with client 123 returned
4. Verify joint FactFinds included

**TS-FF-06: Validate Meeting Type Enum**
1. Attempt POST with invalid meeting type
2. Verify 400 Bad Request
3. Verify error indicates valid enum values

**TS-FF-07: Validate Client Present**
1. Attempt POST with client in clientsPresent not in clients
2. Verify 400 Bad Request
3. Verify error indicates validation failure

**TS-FF-08: Recorded Meeting**
1. POST FactFind with meetingType: "TelephoneRecorded"
2. Include consent note in meeting.notes
3. Verify recorded meeting captured
4. Demonstrates FCA compliance

**TS-FF-09: Read-Only Client Names**
1. POST FactFind with client ID
2. Verify client name populated automatically
3. Attempt PUT with different client name
4. Verify name unchanged (read-only)
5. Name sourced from Client API

**TS-FF-10: Other Audience Flag**
1. POST FactFind with anyOtherAudience: true
2. Document who present in notes
3. Verify flag captured
4. Use case: interpreter, family member present

### 12.2 Sample Test Data

**Simple FactFind:**
```json
{
  "clients": [
    {
      "id": 123
    }
  ],
  "meeting": {
    "meetingOn": "2026-03-05",
    "meetingType": "FaceToFace",
    "clientsPresent": [
      {
        "id": 123
      }
    ],
    "anyOtherAudience": false,
    "notes": "Initial consultation."
  },
  "disclosureKeyfacts": [
    {
      "Type": "CombinedInitialDisclosureDocument",
      "IssuedOn": "2026-03-05"
    }
  ]
}
```

**Joint FactFind:**
```json
{
  "clients": [
    {
      "id": 123
    },
    {
      "id": 124
    }
  ],
  "meeting": {
    "meetingOn": "2026-03-05",
    "meetingType": "FaceToFace",
    "clientsPresent": [
      {
        "id": 123
      },
      {
        "id": 124
      }
    ],
    "anyOtherAudience": false,
    "notes": "Joint consultation with couple for retirement planning."
  },
  "disclosureKeyfacts": [
    {
      "Type": "CombinedInitialDisclosureDocument",
      "IssuedOn": "2026-03-05"
    },
    {
      "Type": "TermsOfBusiness",
      "IssuedOn": "2026-03-05"
    }
  ]
}
```

**Recorded Meeting:**
```json
{
  "clients": [
    {
      "id": 123
    }
  ],
  "meeting": {
    "meetingOn": "2026-03-10",
    "meetingType": "TelephoneRecorded",
    "clientsPresent": [
      {
        "id": 123
      }
    ],
    "anyOtherAudience": false,
    "notes": "Telephone consultation recorded with client consent obtained. Discussed investment portfolio review."
  },
  "disclosureKeyfacts": []
}
```

---

## 13. References

### 13.1 Related APIs

- [Client API](./Client-API-Design.md) - Client management and information
- All other entity APIs depend on FactFind as root aggregate

### 13.2 External Standards

- **ISO 8601**: Date format standard
- **QueryLang**: Intelliflo query filter syntax for filtering and searching
- **REST API Design**: Standard HTTP methods and status codes
- **GDPR**: Data protection and privacy requirements

### 13.3 Business Regulations

- **FCA Handbook**: Requirements for data gathering and advice process
- **Consumer Duty**: Ensuring good customer outcomes
- **COBS (Conduct of Business Sourcebook)**: Rules for disclosure documents
- **Recording Rules**: FCA requirements for recording client interactions

---

## 14. Appendices

### 14.1 FCA Disclosure Requirements

**Combined Initial Disclosure Document (CIDD):**
- Must be provided before advice given
- Explains firm's services, charges, and status
- Required for independent and restricted advisers
- Must issue to all new clients

**Terms of Business (TOB):**
- Contract between firm and client
- Details services provided
- Explains charging structure
- Sets out client and adviser responsibilities

**Key Facts About Services:**
- Summary of services offered
- Helps clients understand what firm provides
- Required before providing advice

**Service Cost Disclosure:**
- Details of all charges client will pay
- Must be clear and transparent
- Required under Consumer Duty

### 14.2 Meeting Recording Guidelines

**FCA Recording Rules:**
- Certain firms must record telephone conversations and electronic communications
- MiFID firms must record relevant conversations
- Client consent not strictly required for recording, but best practice
- Recordings must be retained for 5-7 years

**Best Practices:**
- Always inform clients when recording
- Document consent in meeting notes
- Use "Recorded" meeting types to flag recordings
- Ensure recordings stored securely

**Meeting Type Selection:**
- Use non-recorded types by default
- Use recorded types when:
  - FCA recording requirements apply
  - Complex advice being given
  - Client requests recording
  - Disputes anticipated

### 14.3 Joint FactFind Scenarios

**Married Couple:**
- Both clients on FactFind
- Joint assets, liabilities, income
- Both must consent to advice
- Both receive disclosure documents

**Cohabiting Partners:**
- May have joint FactFind or separate
- Consider unmarried partner protections
- Estate planning considerations
- Joint and individual assets

**Business Partners:**
- Joint FactFind for business protection
- Separate personal FactFinds
- Key person insurance, partnership protection
- Buy/sell agreements

**Parent and Adult Child:**
- Joint FactFind for estate planning
- Inheritance tax planning
- Gifting strategies
- Lasting power of attorney

### 14.4 Glossary

| Term | Definition |
|---|---|
| FactFind | Formal data-gathering exercise in financial advice process |
| CIDD | Combined Initial Disclosure Document - regulatory disclosure |
| TOB | Terms of Business - contract between firm and client |
| Joint FactFind | FactFind with multiple clients (e.g., couple) |
| MiFID | Markets in Financial Instruments Directive - EU regulation |
| COBS | Conduct of Business Sourcebook - FCA rules |
| Recording Rule | FCA requirement to record certain client interactions |
| Aggregate Root | Domain-driven design pattern - FactFind is root of client data |

### 14.5 Change History

| Version | Date | Changes | Author |
|---|---|---|---|
| 1.0 | 2025-01-15 | Initial API design | API Team |
| 2.0 | 2026-02-25 | Added meeting and disclosure details | API Team |
| 3.0 | 2026-03-05 | Comprehensive design with filtering, full operations | API Team |

---

**Document End**
