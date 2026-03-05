# Estate Planning API Design

**Version:** 2.0
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

The Estate Planning API provides comprehensive management of client estate planning information within the FactFind system, including will details, inheritance expectations, and gift tracking for UK Inheritance Tax (IHT) planning purposes.

### 1.2 Scope

This API covers:
- Singleton estate planning records per client
- Will and estate planning details
- Gift tracking for IHT seven-year rule
- Annual exemption and regular gifts from income
- Expected inheritances
- Automatic calculation of total assets

**Out of Scope:**
- Tax calculations (handled by separate tax planning systems)
- Legal document storage (handled by document management systems)
- Beneficiary management (covered by Beneficiary API)

### 1.3 Conventions

- **Singleton Resource**: One estate planning record per client, accessed via GET and updated via PUT
- **Gifts Collection**: Managed through dedicated POST/GET/PUT/DELETE endpoints with collection structure `{"items": [...], "count": N}`
- **Simple Hypermedia**: Resources include `href` property for navigation
- **Read-Only Fields**: `totalAssets` and `totalJointAssets` are automatically calculated
- **UK IHT Context**: All gift tracking follows UK Inheritance Tax rules and exemptions
- All monetary amounts use multi-currency format
- All dates use ISO 8601 format (YYYY-MM-DD or full datetime)
- **Intelliflo Standards**: Follows Intelliflo API design guidelines

---

## 2. Business Context

### 2.1 Business Requirements

Estate planning is essential for:
1. **IHT Planning**: Track gifts within the seven-year rule for UK Inheritance Tax
2. **Annual Exemptions**: Monitor use of £3,000 annual gift allowance
3. **Regular Gifts**: Identify gifts from surplus income (exempt from IHT)
4. **Will Status**: Document current will arrangements and executors
5. **Succession Planning**: Plan for wealth transfer across generations
6. **Regulatory Compliance**: Meet FCA requirements for holistic advice

### 2.2 Use Cases

**UC-EP-01: Track Potentially Exempt Transfers (PETs)**
- Client makes gift of £50,000 to child
- Record gift with date, recipient, amount
- Track seven-year period from gift date
- Monitor for IHT implications if death occurs within seven years

**UC-EP-02: Monitor Annual Exemptions**
- Client uses £3,000 annual exemption each tax year
- Track gifts marked as within annual exemption
- Identify unused exemptions that can be carried forward one year

**UC-EP-03: Document Regular Gifts from Income**
- Client makes monthly £500 gifts to grandchildren
- Mark as regular gifts from surplus income
- Exempt from IHT if patterns maintained

**UC-EP-04: Estate Valuation**
- System automatically calculates total assets from all asset records
- Provides snapshot of estate size for planning purposes
- Distinguishes jointly-owned assets (50% included in estate)

**UC-EP-05: Will Review Trigger**
- Record current will details
- Identify when circumstances change (marriage, children, divorce)
- Trigger will review recommendations

### 2.3 Constraints

- Singleton pattern: one estate planning record per client
- UK-specific: focused on UK Inheritance Tax rules
- Seven-year tracking: gifts relevant for seven years from gift date
- Asset calculations: read-only, derived from Asset API data

---

## 3. API Overview

### 3.1 Resource Model

```
EstatePlanning (singleton per client)
├── client (reference)
├── factfind (reference)
├── willDetails (editable text)
├── totalAssets (read-only, calculated)
├── totalJointAssets (read-only, calculated)
├── giftInLast7YearsDetails (editable text)
├── recentGiftDetails (editable text)
├── regularGiftDetails (editable text)
├── expectingInheritanceDetails (editable text)
└── gifts[] (collection, managed via separate API)
    ├── id
    ├── href
    ├── giftedOn
    ├── recipient
    ├── relationship
    ├── value
    ├── description
    ├── isRegularGiftFromIncome
    └── isWithinAnnualExemption
```

### 3.2 Resource Characteristics

| Characteristic | Value |
|---|---|
| Resource Type | Singleton + Collection |
| Mutability | Partially mutable (some read-only fields) |
| Lifecycle | Created on demand, persists with client |
| Versioning | Optimistic concurrency via timestamps |
| Parent Resource | Client |

---

## 4. Resource Model

### 4.1 Resource Structure

**Estate Planning Singleton:**
- One record per client
- Contains summary fields and gift collection reference
- Read-only asset totals calculated from Asset API
- Gifts managed through sub-collection endpoints

**Gift Sub-Resource:**
- Multiple gifts per estate planning record
- Tracks individual gifts for IHT planning
- Contains date, recipient, value, exemption flags

### 4.2 Resource Relationships

```
FactFind (1) ──→ (N) Client
Client (1) ──→ (1) EstatePlanning
EstatePlanning (1) ──→ (N) Gift
Client (1) ──→ (N) Asset [source for totalAssets calculation]
```

### 4.3 Resource Lifecycle

**Estate Planning Record:**
1. **Not Exists**: Client has no estate planning record (GET returns 404)
2. **Created**: First PUT creates the singleton record
3. **Updated**: Subsequent PUTs update existing record
4. **Persists**: Remains throughout client relationship

**Gift Record:**
1. **Created**: POST to `/gifts` endpoint
2. **Active**: Gift tracked for IHT purposes
3. **Updated**: PUT to `/gifts/{id}` modifies details
4. **Deleted**: DELETE removes gift record

---

## 5. API Operations

### 5.1 Operation Summary

| Operation | Method | Endpoint | Description |
|---|---|---|---|
| Get Estate Planning | GET | `/v2/factfinds/{id}/clients/{clientId}/estateplanning` | Retrieve singleton |
| Update Estate Planning | PUT | `/v2/factfinds/{id}/clients/{clientId}/estateplanning` | Create/update singleton |
| Create Gift | POST | `/v2/factfinds/{id}/clients/{clientId}/estateplanning/gifts` | Add new gift |
| Get Gift | GET | `/v2/factfinds/{id}/clients/{clientId}/estateplanning/gifts/{giftId}` | Retrieve gift |
| Update Gift | PUT | `/v2/factfinds/{id}/clients/{clientId}/estateplanning/gifts/{giftId}` | Modify gift |
| Delete Gift | DELETE | `/v2/factfinds/{id}/clients/{clientId}/estateplanning/gifts/{giftId}` | Remove gift |

### 5.2 Get Estate Planning

**Endpoint:** `GET /v2/factfinds/{id}/clients/{clientId}/estateplanning`

**Description:** Retrieves the estate planning singleton record for a client.

**Path Parameters:**
- `id` (integer, required): FactFind identifier
- `clientId` (integer, required): Client identifier

**Response Codes:**
- `200 OK`: Estate planning record found
- `404 Not Found`: No estate planning record exists for this client
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** EstatePlanning object (see section 6.1)

### 5.3 Update Estate Planning

**Endpoint:** `PUT /v2/factfinds/{id}/clients/{clientId}/estateplanning`

**Description:** Creates or updates the estate planning singleton record.

**Path Parameters:**
- `id` (integer, required): FactFind identifier
- `clientId` (integer, required): Client identifier

**Request Body:** EstatePlanning object (editable fields only)

**Response Codes:**
- `200 OK`: Estate planning record updated
- `201 Created`: Estate planning record created (first PUT)
- `400 Bad Request`: Invalid data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions
- `409 Conflict`: Concurrent modification detected

**Response Body:** Complete EstatePlanning object

### 5.4 Create Gift

**Endpoint:** `POST /v2/factfinds/{id}/clients/{clientId}/estateplanning/gifts`

**Description:** Creates a new gift record for IHT tracking.

**Path Parameters:**
- `id` (integer, required): FactFind identifier
- `clientId` (integer, required): Client identifier

**Request Body:** Gift object (without id and href)

**Response Codes:**
- `201 Created`: Gift created successfully
- `400 Bad Request`: Invalid gift data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Estate planning record doesn't exist

**Response Body:** Complete Gift object with assigned id

### 5.5 Get Gift

**Endpoint:** `GET /v2/factfinds/{id}/clients/{clientId}/estateplanning/gifts/{giftId}`

**Description:** Retrieves a specific gift record.

**Path Parameters:**
- `id` (integer, required): FactFind identifier
- `clientId` (integer, required): Client identifier
- `giftId` (integer, required): Gift identifier

**Response Codes:**
- `200 OK`: Gift found
- `404 Not Found`: Gift not found
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** Gift object

### 5.6 Update Gift

**Endpoint:** `PUT /v2/factfinds/{id}/clients/{clientId}/estateplanning/gifts/{giftId}`

**Description:** Updates an existing gift record.

**Path Parameters:**
- `id` (integer, required): FactFind identifier
- `clientId` (integer, required): Client identifier
- `giftId` (integer, required): Gift identifier

**Request Body:** Complete Gift object

**Response Codes:**
- `200 OK`: Gift updated successfully
- `400 Bad Request`: Invalid gift data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Gift not found

**Response Body:** Updated Gift object

### 5.7 Delete Gift

**Endpoint:** `DELETE /v2/factfinds/{id}/clients/{clientId}/estateplanning/gifts/{giftId}`

**Description:** Removes a gift record from tracking.

**Path Parameters:**
- `id` (integer, required): FactFind identifier
- `clientId` (integer, required): Client identifier
- `giftId` (integer, required): Gift identifier

**Response Codes:**
- `204 No Content`: Gift deleted successfully
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Gift not found

**Response Body:** None

---

## 6. Request/Response Specifications

### 6.1 Get Estate Planning Response

```json
{
  "href": "/v2/factfinds/679/clients/8496/estateplanning",
  "client": {
    "id": 8496,
    "href": "/v2/factfinds/679/clients/8496",
    "name": "John Smith"
  },
  "factfind": {
    "id": 679
  },
  "willDetails": "Mirror wills in place with spouse. Estate passes to spouse on first death, then to children equally. Executors: spouse and solicitor. Guardians appointed for children under 18.",
  "totalAssets": {
    "amount": 850000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "totalJointAssets": {
    "amount": 425000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "giftInLast7YearsDetails": "Annual exemption gifts to both children (£3,000 per year each)",
  "recentGiftDetails": "£3,000 to daughter Emily (annual exemption 2025/26)",
  "regularGiftDetails": "Monthly £250 into each child's Junior ISA from surplus income",
  "expectingInheritanceDetails": "Potential inheritance from parents' estate (estimated £200,000)",
  "gifts": [
    {
      "id": 1,
      "href": "/v2/factfinds/679/clients/8496/estateplanning/gifts/1",
      "giftedOn": "2025-04-10",
      "recipient": "Emily Rose Smith",
      "relationship": "Daughter",
      "value": {
        "amount": 3000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "description": "Annual exemption gift for tax year 2025/26",
      "isRegularGiftFromIncome": false,
      "isWithinAnnualExemption": true
    }
  ],
  "createdAt": "2020-01-15T10:30:00Z",
  "updatedAt": "2026-03-01T14:20:00Z"
}
```

### 6.2 Update Estate Planning Request

```json
{
  "willDetails": "Mirror wills updated in 2026. Estate passes to spouse, then children equally. Executors: spouse and professional executor service.",
  "giftInLast7YearsDetails": "Annual exemption gifts to children, total £6,000 per year",
  "recentGiftDetails": "£3,000 to each child for tax year 2025/26",
  "regularGiftDetails": "Monthly £250 to each child's Junior ISA (£500 total per month)",
  "expectingInheritanceDetails": "Expected inheritance from mother's estate, estimated £150,000-£200,000"
}
```

### 6.3 Create Gift Request

```json
{
  "giftedOn": "2026-04-06",
  "recipient": "Thomas James Smith",
  "relationship": "Son",
  "value": {
    "amount": 3000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "description": "Annual exemption gift for tax year 2026/27",
  "isRegularGiftFromIncome": false,
  "isWithinAnnualExemption": true
}
```

### 6.4 Create Gift Response

```json
{
  "id": 2,
  "href": "/v2/factfinds/679/clients/8496/estateplanning/gifts/2",
  "giftedOn": "2026-04-06",
  "recipient": "Thomas James Smith",
  "relationship": "Son",
  "value": {
    "amount": 3000.00,
    "currency": {
      "code": "GBP",
      "symbol": "£"
    }
  },
  "description": "Annual exemption gift for tax year 2026/27",
  "isRegularGiftFromIncome": false,
  "isWithinAnnualExemption": true
}
```

---

## 7. Data Model

### 7.1 EstatePlanning Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| href | string | Yes | Yes | API resource link |
| client | ClientReference | Yes | Yes | Client reference |
| factfind | FactFindReference | Yes | Yes | FactFind reference |
| willDetails | string | No | No | Will and estate planning details (max 2000 chars) |
| totalAssets | Money | No | Yes | Total asset value (calculated) |
| totalJointAssets | Money | No | Yes | Total jointly-owned assets (calculated) |
| giftInLast7YearsDetails | string | No | No | Summary of gifts in last 7 years (max 2000 chars) |
| recentGiftDetails | string | No | No | Details of recent gifts (max 1000 chars) |
| regularGiftDetails | string | No | No | Details of regular gifts from income (max 1000 chars) |
| expectingInheritanceDetails | string | No | No | Expected inheritance details (max 1000 chars) |
| gifts | Gift[] | No | Yes | Collection of gift records (managed via gifts API) |
| createdAt | datetime | Yes | Yes | Record creation timestamp |
| updatedAt | datetime | Yes | Yes | Last update timestamp |

### 7.2 Gift Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| id | integer | Yes | Yes | Unique gift identifier |
| href | string | Yes | Yes | API resource link |
| giftedOn | date | Yes | No | Date gift was made (ISO 8601) |
| recipient | string | Yes | No | Name of gift recipient (max 100 chars) |
| relationship | string | No | No | Relationship to client (max 50 chars) |
| value | Money | Yes | No | Gift value |
| description | string | No | No | Gift description/notes (max 500 chars) |
| isRegularGiftFromIncome | boolean | No | No | Gift qualifies as regular from surplus income (IHT exempt) |
| isWithinAnnualExemption | boolean | No | No | Gift uses annual exemption (£3,000 per year) |

### 7.3 Common Types

**ClientReference:**
```json
{
  "id": 8496,
  "href": "/v2/factfinds/679/clients/8496",
  "name": "John Smith"
}
```

**FactFindReference:**
```json
{
  "id": 679
}
```

**Money:**
```json
{
  "amount": 3000.00,
  "currency": {
    "code": "GBP",
    "symbol": "£"
  }
}
```

---

## 8. Business Rules

### 8.1 Singleton Resource Rules

**SR-EP-01: One Record Per Client**
- Only one estate planning record exists per client
- First PUT creates the record (201 Created)
- Subsequent PUTs update the record (200 OK)
- GET returns 404 if record doesn't exist yet

**SR-EP-02: Parent Record Required**
- Estate planning singleton must be created before gifts can be added
- POST to `/gifts` returns 404 if estate planning doesn't exist

### 8.2 Read-Only Field Rules

**SR-EP-03: Automatic Asset Calculation**
- `totalAssets` is automatically calculated from all client assets
- Includes: property, investments, pensions, bank accounts, other assets
- Updated whenever asset records are modified
- Cannot be manually set via API

**SR-EP-04: Joint Asset Calculation**
- `totalJointAssets` is 50% of jointly-owned assets
- Calculated from assets where ownership type is "Joint"
- Updated automatically with asset changes
- Cannot be manually set via API

### 8.3 Gift Validation Rules

**SR-EP-05: Gift Date Validation**
- `giftedOn` must be a valid date in the past or today
- Cannot be in the future
- Format: ISO 8601 (YYYY-MM-DD)

**SR-EP-06: Gift Value Validation**
- `value.amount` must be positive (> 0)
- No maximum limit (large gifts are tracked)
- Currency must be valid ISO 4217 code

**SR-EP-07: Recipient Required**
- `recipient` must be non-empty string
- Minimum 2 characters, maximum 100 characters
- Should be individual's name or organization

**SR-EP-08: Seven-Year Tracking**
- Gifts are tracked for IHT purposes for seven years from gift date
- Historical gifts older than seven years may be archived
- System may filter gifts by relevance for IHT planning

### 8.4 UK IHT Rules (Informational)

**SR-EP-09: Annual Exemption**
- £3,000 annual gift allowance per person per tax year
- Can be carried forward one year if unused
- `isWithinAnnualExemption` flag helps track usage
- Adviser must ensure correct application

**SR-EP-10: Regular Gifts from Income**
- Gifts made regularly from surplus income are IHT exempt
- Must be from after-tax income, not capital
- Pattern must be established and maintained
- `isRegularGiftFromIncome` flag identifies these gifts

**SR-EP-11: Small Gifts Exemption**
- £250 per recipient per year (not tracked in this API)
- Cannot be combined with annual exemption for same person
- Advisers manage separately from main gift tracking

**SR-EP-12: Seven-Year Rule (PETs)**
- Potentially Exempt Transfers (PETs) become exempt after 7 years
- If donor dies within 7 years, gift counts toward estate
- Taper relief applies years 3-7: 80%, 60%, 40%, 20%
- System tracks all gifts with dates for this calculation

### 8.5 Text Field Limits

**SR-EP-13: Field Length Limits**
- `willDetails`: 2000 characters maximum
- `giftInLast7YearsDetails`: 2000 characters maximum
- `recentGiftDetails`: 1000 characters maximum
- `regularGiftDetails`: 1000 characters maximum
- `expectingInheritanceDetails`: 1000 characters maximum
- `gift.recipient`: 100 characters maximum
- `gift.relationship`: 50 characters maximum
- `gift.description`: 500 characters maximum

---

## 9. Error Handling

### 9.1 Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Gift date cannot be in the future",
    "details": [
      {
        "field": "giftedOn",
        "issue": "Date must be today or in the past",
        "value": "2027-12-25"
      }
    ]
  }
}
```

### 9.2 Common Error Codes

| Code | HTTP Status | Description |
|---|---|---|
| ESTATE_PLANNING_NOT_FOUND | 404 | Estate planning record doesn't exist |
| GIFT_NOT_FOUND | 404 | Gift record not found |
| VALIDATION_ERROR | 400 | Request data validation failed |
| INVALID_GIFT_DATE | 400 | Gift date is invalid or in future |
| INVALID_GIFT_VALUE | 400 | Gift value is zero, negative, or invalid |
| RECIPIENT_REQUIRED | 400 | Recipient name is missing |
| TEXT_TOO_LONG | 400 | Text field exceeds maximum length |
| UNAUTHORIZED | 401 | Authentication required |
| FORBIDDEN | 403 | Insufficient permissions |
| CONCURRENT_MODIFICATION | 409 | Record modified by another user |

### 9.3 Validation Error Examples

**Future Gift Date:**
```json
{
  "error": {
    "code": "INVALID_GIFT_DATE",
    "message": "Gift date cannot be in the future",
    "details": [
      {
        "field": "giftedOn",
        "issue": "Date must be today or in the past",
        "value": "2027-12-25"
      }
    ]
  }
}
```

**Negative Gift Value:**
```json
{
  "error": {
    "code": "INVALID_GIFT_VALUE",
    "message": "Gift value must be positive",
    "details": [
      {
        "field": "value.amount",
        "issue": "Amount must be greater than zero",
        "value": "-1000.00"
      }
    ]
  }
}
```

**Text Field Too Long:**
```json
{
  "error": {
    "code": "TEXT_TOO_LONG",
    "message": "Field exceeds maximum length",
    "details": [
      {
        "field": "willDetails",
        "issue": "Maximum 2000 characters allowed",
        "length": 2347
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
- User must have permission to view/edit client data
- Adviser can only access their own clients' records
- Admin users can access all records within their organization

**Operation-Level Permissions:**
- `GET`: Requires "View Client Data" permission
- `PUT`: Requires "Edit Client Data" permission
- `POST/DELETE`: Requires "Edit Client Data" permission

### 10.3 Data Protection

**Sensitive Information:**
- Estate planning details may contain sensitive family information
- Inheritance details may reveal financial circumstances of relatives
- Gift records may indicate family disputes or preferences
- Access logs maintained for audit purposes

**GDPR Compliance:**
- Estate planning data is personal data under GDPR
- Client consent required for processing
- Right to access: clients can request their estate planning data
- Right to erasure: clients can request deletion (subject to retention rules)
- Data retention: follow firm's data retention policy

---

## 11. Performance

### 11.1 Response Time Targets

| Operation | Target | Maximum |
|---|---|---|
| GET Estate Planning | < 200ms | 500ms |
| PUT Estate Planning | < 300ms | 1000ms |
| GET Gift | < 100ms | 300ms |
| POST Gift | < 200ms | 500ms |
| PUT Gift | < 200ms | 500ms |
| DELETE Gift | < 150ms | 400ms |

### 11.2 Scalability

**Gift Collection Size:**
- Typical: 0-10 gifts per client
- Expected maximum: 50 gifts per client
- No pagination needed for gifts array in estate planning GET
- Gifts older than 7 years may be archived automatically

**Asset Calculation:**
- `totalAssets` and `totalJointAssets` pre-calculated
- Calculation triggered when assets are modified
- No real-time calculation on GET requests
- Cached values used for performance

### 11.3 Caching

**Estate Planning Record:**
- Cache-Control: private, max-age=300 (5 minutes)
- ETag support for conditional requests
- Last-Modified header included

**Gift Records:**
- Cache-Control: private, max-age=600 (10 minutes)
- Gifts rarely change once recorded
- Cache invalidation on PUT/DELETE

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

**TS-EP-01: Create Estate Planning Singleton**
1. Client has no estate planning record
2. PUT estate planning with will details
3. Verify 201 Created response
4. Verify record contains provided data
5. Verify totalAssets calculated correctly

**TS-EP-02: Update Existing Estate Planning**
1. Estate planning record exists
2. PUT with updated will details
3. Verify 200 OK response
4. Verify changes persisted
5. Verify updatedAt timestamp changed

**TS-EP-03: Add Gift Within Annual Exemption**
1. POST gift with value £3,000
2. Set isWithinAnnualExemption = true
3. Verify 201 Created response
4. Verify gift appears in estate planning GET

**TS-EP-04: Add Regular Gift from Income**
1. POST gift with monthly amount
2. Set isRegularGiftFromIncome = true
3. Verify gift marked correctly
4. Verify appears in gifts collection

**TS-EP-05: Track Seven-Year Gift**
1. POST gift with large amount (e.g., £50,000)
2. Set both exemption flags to false (PET)
3. Record giftedOn date
4. Verify system calculates seven-year anniversary

**TS-EP-06: Validate Future Gift Date**
1. Attempt POST gift with future date
2. Verify 400 Bad Request
3. Verify error message indicates date issue

**TS-EP-07: Validate Negative Gift Value**
1. Attempt POST gift with negative amount
2. Verify 400 Bad Request
3. Verify error indicates value must be positive

**TS-EP-08: Update Gift Details**
1. Gift exists
2. PUT with updated description
3. Verify 200 OK
4. Verify changes persisted

**TS-EP-09: Delete Gift**
1. Gift exists
2. DELETE gift
3. Verify 204 No Content
4. Verify GET returns 404
5. Verify gift removed from estate planning collection

**TS-EP-10: Read-Only Asset Totals**
1. Attempt PUT with totalAssets value
2. System ignores provided value
3. System uses calculated value from assets
4. Response shows correct calculated total

### 12.2 Sample Test Data

**Estate Planning - Simple Will:**
```json
{
  "willDetails": "Simple will leaving everything to spouse",
  "giftInLast7YearsDetails": "None",
  "recentGiftDetails": "None",
  "regularGiftDetails": "None",
  "expectingInheritanceDetails": "None"
}
```

**Estate Planning - Complex Estate:**
```json
{
  "willDetails": "Mirror wills with spouse. Discretionary trust for children. Professional executors. Nil-rate band legacy to children, residue to spouse.",
  "giftInLast7YearsDetails": "£100,000 to family trust in 2022, annual exemption gifts each year",
  "recentGiftDetails": "£6,000 annual exemptions to children (2025/26)",
  "regularGiftDetails": "£500/month to children's ISAs from surplus income",
  "expectingInheritanceDetails": "£300,000 from parents' estates (both now aged 85)"
}
```

**Gift - Annual Exemption:**
```json
{
  "giftedOn": "2025-04-06",
  "recipient": "Sarah Jane Doe",
  "relationship": "Daughter",
  "value": {
    "amount": 3000.00,
    "currency": {"code": "GBP", "symbol": "£"}
  },
  "description": "Annual exemption 2025/26",
  "isRegularGiftFromIncome": false,
  "isWithinAnnualExemption": true
}
```

**Gift - Potentially Exempt Transfer:**
```json
{
  "giftedOn": "2024-11-15",
  "recipient": "Michael Robert Doe",
  "relationship": "Son",
  "value": {
    "amount": 75000.00,
    "currency": {"code": "GBP", "symbol": "£"}
  },
  "description": "Deposit gift for house purchase",
  "isRegularGiftFromIncome": false,
  "isWithinAnnualExemption": false
}
```

**Gift - Regular from Income:**
```json
{
  "giftedOn": "2026-01-15",
  "recipient": "Grandchildren Junior ISAs",
  "relationship": "Grandchildren",
  "value": {
    "amount": 500.00,
    "currency": {"code": "GBP", "symbol": "£"}
  },
  "description": "Monthly Junior ISA contributions (total for all grandchildren)",
  "isRegularGiftFromIncome": true,
  "isWithinAnnualExemption": false
}
```

---

## 13. References

### 13.1 Related APIs

- [Client API](./Client-API-Design.md) - Client management
- [FactFind API](./FactFind-API-Design.md) - Parent container
- [Asset API](./Asset-API-Design.md) - Source of totalAssets calculation
- [Beneficiary API](./Beneficiary-API-Design.md) - Beneficiary management for policies/pensions

### 13.2 External Standards

- **UK Inheritance Tax Rules**: HMRC guidance on IHT, exemptions, and reliefs
- **ISO 8601**: Date and datetime formats
- **ISO 4217**: Currency codes
- **REST API Design**: Standard HTTP methods and status codes
- **GDPR**: Data protection and privacy requirements

### 13.3 Business Regulations

- **FCA Handbook**: Requirements for holistic financial advice
- **UK Inheritance Tax Act 1984**: Legal framework for IHT
- **HMRC IHT400**: Form and guidance for estate reporting
- **Professional Standards**: Recommendations for estate planning advice

---

## 14. Appendices

### 14.1 UK Inheritance Tax Exemptions Summary

**Annual Exemption:**
- £3,000 per person per tax year
- Can carry forward unused exemption from previous year only
- Can combine with other exemptions

**Small Gifts:**
- £250 per recipient per tax year
- Cannot combine with annual exemption for same person
- Unlimited number of recipients

**Regular Gifts from Income:**
- Must be from surplus income (not capital)
- Must not reduce donor's standard of living
- Must be regular and habitual pattern
- Fully exempt from IHT

**Gifts to Spouse:**
- Unlimited exemption for gifts to UK-domiciled spouse
- £325,000 total exemption for non-UK-domiciled spouse

**Wedding Gifts:**
- £5,000 from parent to child
- £2,500 from grandparent to grandchild
- £1,000 from anyone else

**Seven-Year Rule (PETs):**
- Potentially Exempt Transfers become exempt after 7 years
- If donor dies within 7 years, gift included in estate
- Taper relief years 3-7: 80%, 60%, 40%, 20% of tax liability

**Nil-Rate Band (2025/26):**
- £325,000 per person
- Transferable to surviving spouse (up to £650,000)
- Residence Nil-Rate Band: additional £175,000 for main home passing to direct descendants

### 14.2 Estate Planning Best Practices

1. **Regular Reviews**: Estate plans should be reviewed every 3-5 years or after major life events
2. **Will Updates**: Update wills after marriage, divorce, children born, house purchases
3. **Gift Tracking**: Maintain accurate records of all gifts with dates and values
4. **Seven-Year Planning**: Consider timing of large gifts relative to life expectancy
5. **Income Gifts**: Establish regular patterns early for surplus income exemption
6. **Professional Advice**: Complex estates benefit from specialist tax and legal advice

### 14.3 Gift Tracking Examples

**Example 1: Annual Exemption Strategy**
- Client gives £3,000 to each of two children every April
- Uses full annual exemption (2 × £3,000 = £6,000 including spouse)
- Mark as `isWithinAnnualExemption: true`
- Fully exempt from IHT immediately

**Example 2: Large Gift (PET)**
- Client gifts £100,000 to son for house deposit
- Not within any exemption
- Potentially Exempt Transfer (PET)
- Mark both exemption flags false
- Track for seven years from gift date
- Becomes fully exempt if client survives seven years

**Example 3: Regular Gifts from Surplus Income**
- Client has £80,000 income, £55,000 expenses
- Monthly gift of £2,000 from surplus income
- Establish regular pattern over time
- Mark as `isRegularGiftFromIncome: true`
- Fully exempt if truly from surplus income

**Example 4: Combination Strategy**
- Annual exemption: £3,000 to each child
- Regular income gifts: £500/month to grandchildren's savings
- Small gifts: £250 birthday/Christmas to various family members
- Large PET: £50,000 to trust (track for seven years)
- All gifts tracked separately with appropriate flags

### 14.4 Glossary

| Term | Definition |
|---|---|
| PET | Potentially Exempt Transfer - gift that becomes exempt after seven years |
| IHT | Inheritance Tax - UK tax on estates over nil-rate band |
| Nil-Rate Band | Tax-free threshold for IHT (£325,000 in 2025/26) |
| RNRB | Residence Nil-Rate Band - additional £175,000 for main home |
| Annual Exemption | £3,000 per person per year gift allowance |
| Surplus Income | After-tax income remaining after normal expenditure |
| Taper Relief | Reduction in IHT on PETs if donor dies 3-7 years after gift |
| Mirror Wills | Matching wills for spouses with similar provisions |
| Discretionary Trust | Trust where trustees have discretion over distributions |
| Executor | Person appointed to administer estate after death |

### 14.5 Change History

| Version | Date | Changes | Author |
|---|---|---|---|
| 1.0 | 2025-01-10 | Initial comprehensive API design | API Team |
| 2.0 | 2026-03-05 | Updated to singleton + gifts pattern, read-only asset totals | API Team |

---

**Document End**
