# Employment API Design

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
| **Entity Name** | Employment |
| **Domain** | Circumstances |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/factfinds/{factfindId}/clients/{clientId}/employments` |
| **Resource Type** | Collection |

### Description

Employment history and current employment

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
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/employments` | List employment records | Query params | Employment[] | 200, 401, 403, 404 | Employment, List |
| POST | `/api/v2/factfinds/{factfindId}/clients/{clientId}/employments` | Create employment record | EmploymentRequest | Employment | 201, 400, 401, 403, 404, 422 | Employment, Create |
| GET | `/api/v2/factfinds/{factfindId}/clients/{clientId}/employments/{employmentId}` | Get employment by ID | Path params | Employment | 200, 401, 403, 404 | Employment, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/clients/{clientId}/employments/{employmentId}` | Update employment | EmploymentPatch | Employment | 200, 400, 401, 403, 404, 422 | Employment, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/clients/{clientId}/employments/{employmentId}` | Delete employment | Path params | None | 204, 401, 403, 404, 422 | Employment, Delete |


### Authorization

**Required Scopes:**
- `employment:read` - Read access (GET operations)
- `employment:write` - Create and update access (POST, PUT, PATCH)
- `employment:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary



### Employment Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | System-assigned employment record ID |
| `factfindRef` | Reference |  | Reference to parent fact find |
| `client` | Reference |  | Reference to the client |

*Total: 3 properties*


### Related Resources

*See parent document for relationships to other entities.*

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
- Employment data must be accurate and up-to-date
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
  "field1": "value1",
  "field2": "value2",
  "...": "entity-specific fields"
}
```

### Example Response (Success)

```json
{
  "id": 123,
  "field1": "value1",
  "field2": "value2",
  "created": "2026-02-25T10:00:00Z",
  "modified": "2026-02-25T10:00:00Z",
  "...": "entity-specific fields"
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
1. Create Employment with valid data
2. Retrieve Employment by ID
3. Update Employment fields
4. Delete Employment

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

See **[Master API Design - Section 11.{"1" if entity_info['domain'] == 'Client Management' else "2" if entity_info['domain'] == 'Circumstances' else "3" if entity_info['domain'] == 'Arrangements' else "4" if entity_info['domain'] == 'Assets & Liabilities' else "5" if entity_info['domain'] == 'Risk Profiling' else "6" if entity_info['domain'] == 'FactFind Root' else "7"}](./MASTER-API-DESIGN.md#11{"1" if entity_info['domain'] == 'Client Management' else "2" if entity_info['domain'] == 'Circumstances' else "3" if entity_info['domain'] == 'Arrangements' else "4" if entity_info['domain'] == 'Assets & Liabilities' else "5" if entity_info['domain'] == 'Risk Profiling' else "6" if entity_info['domain'] == 'FactFind Root' else "7"}-circumstances-domain)** for other APIs in the Circumstances domain.

---

**Document Version:** 2.0
**Last Updated:** 2026-02-25
**Entity:** Employment
**Domain:** Circumstances
