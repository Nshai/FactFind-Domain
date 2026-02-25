# Custom-Question API Design

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
| **Entity Name** | Custom-Question |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Custom and supplementary questions

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
- `custom_question:read` - Read access (GET operations)
- `custom_question:write` - Create and update access (POST, PUT, PATCH)
- `custom_question:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary


### Custom-Question Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique identifier for this custom question |
| `href` | string |  | Link to this custom question resource |
| `factfind` | Reference Link |  | Link to the parent fact-find |
| `client` | Reference Link |  | Link to the client (if question is client-specific) |
| `category` | Selection |  | Question category: General, Financial, Health, Lifestyle, Goals, Other |
| `question` | string | ✓ | The question text |
| `answer` | string |  | The answer provided |
| `answerType` | Selection |  | Type of answer expected: Text, Number, Yes/No, Date, Selection |
| `isRequired` | boolean |  | Whether this question must be answered |
| `displayOrder` | integer |  | Order in which to display this question |
| `notes` | string |  | Additional notes or context |
| `createdBy` | Reference Link |  | User who created this question |
| `createdAt` | timestamp |  | When this question was created |
| `updatedAt` | timestamp |  | When this question was last modified |

*Total: 14 properties*

### Referenced Type Definitions

The following types are referenced in the resource properties above:

#### Reference Link

Standard reference structure used throughout the API:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of the referenced entity |
| `href` | string | API endpoint URL for the referenced entity |

**Used for:** `factfind`, `client`, `createdBy`

#### Selection

Enumeration structure with code and display value:

| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Machine-readable code value |
| `display` | string | Human-readable display text |

**Used for:** `category`, `answerType`

**Category Values:**
- `GENERAL` - General questions
- `FINANCIAL` - Financial information questions
- `HEALTH` - Health and medical questions
- `LIFESTYLE` - Lifestyle and preferences
- `GOALS` - Goals and objectives
- `OTHER` - Other custom categories

**AnswerType Values:**
- `TEXT` - Free text answer
- `NUMBER` - Numeric answer
- `YES_NO` - Boolean yes/no answer
- `DATE` - Date value answer
- `SELECTION` - Multiple choice selection


### Related Resources

**Parent Resource:** Client


## Data Model

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
- `Money` - Amount with currency
- `Provider` - Provider information object
- `Owner` - Ownership details object
- `Country` - Country with ISO code

---

## Business Rules

### Entity-Specific Rules

**Validation Rules:**
1. All required fields must be provided
2. Field formats must match specifications
3. Business logic constraints apply per entity type
4. Referential integrity must be maintained

**Business Constraints:**
- Custom-Question data must be accurate and up-to-date
- Changes must be auditable
- Deletion may require soft-delete for compliance
- Data retention policies must be followed

### Common Business Rules

For common business rules applicable to all entities, refer to **[Master API Design - Section 8](./MASTER-API-DESIGN.md#8-performance-standards)**.

---

## Request/Response Examples

### Example Request (Create)

```json
{
  "factfind": {
    "id": 456,
    "href": "/api/v2/factfinds/456"
  },
  "client": {
    "id": 789,
    "href": "/api/v2/factfinds/456/clients/789"
  },
  "category": {
    "code": "LIFESTYLE",
    "display": "Lifestyle"
  },
  "question": "Do you have any plans to relocate in the next 5 years?",
  "answerType": {
    "code": "YES_NO",
    "display": "Yes/No"
  },
  "isRequired": true,
  "displayOrder": 10,
  "notes": "Important for long-term financial planning"
}
```

### Example Response (Success)

```json
{
  "id": 123,
  "href": "/api/v2/factfinds/456/custom-questions/123",
  "factfind": {
    "id": 456,
    "href": "/api/v2/factfinds/456"
  },
  "client": {
    "id": 789,
    "href": "/api/v2/factfinds/456/clients/789"
  },
  "category": {
    "code": "LIFESTYLE",
    "display": "Lifestyle"
  },
  "question": "Do you have any plans to relocate in the next 5 years?",
  "answer": "No",
  "answerType": {
    "code": "YES_NO",
    "display": "Yes/No"
  },
  "isRequired": true,
  "displayOrder": 10,
  "notes": "Important for long-term financial planning",
  "createdBy": {
    "id": 42,
    "href": "/api/v2/users/42"
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
1. Create Custom-Question with valid data
2. Retrieve Custom-Question by ID
3. Update Custom-Question fields
4. Delete Custom-Question

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
**Entity:** Custom-Question
**Domain:** Client Management
