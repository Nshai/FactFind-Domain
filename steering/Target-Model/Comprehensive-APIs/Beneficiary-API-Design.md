# Beneficiary API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Arrangements

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | Beneficiary |
| **Domain** | Arrangements |
| **Aggregate Root** | Arrangement |
| **Base Path** | `/api/v3/...` |
| **Resource Type** | Collection |

### Description

Beneficiary nominations

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
- `beneficiary:read` - Read access (GET operations)
- `beneficiary:write` - Create and update access (POST, PUT, PATCH)
- `beneficiary:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary


### Beneficiary Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique identifier for this beneficiary record |
| `href` | string |  | Link to this beneficiary resource |
| `arrangement` | Reference Link |  | Link to the parent arrangement (pension, protection, trust) |
| `client` | Reference Link |  | Link to the client being nominated as beneficiary |
| `beneficiaryType` | Selection |  | Type of beneficiary: Primary, Contingent, or Residual |
| `relationship` | Selection |  | Relationship to policy holder: Spouse, Child, Parent, Sibling, Other, Trust |
| `fullName` | string |  | Full name of the beneficiary |
| `dateOfBirth` | date |  | Date of birth (if individual) |
| `percentage` | decimal |  | Percentage of benefit allocated to this beneficiary (0-100) |
| `fixedAmount` | Money |  | Fixed amount allocated (alternative to percentage) |
| `isRevocable` | boolean |  | Whether this nomination can be changed |
| `nominatedOn` | date |  | Date when nomination was made |
| `notes` | string |  | Additional notes about this nomination |
| `createdAt` | timestamp |  | When this record was created |
| `updatedAt` | timestamp |  | When this record was last modified |

*Total: 15 properties*

### Referenced Type Definitions

The following types are referenced in the resource properties above:

#### Reference Link

*Reference to another entity* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

#### Selection

*Enumeration with code and display* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

#### Money

*Currency amount with code* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.


### Related Resources

**Parent Resource:** Arrangement


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
- Beneficiary data must be accurate and up-to-date
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
1. Create Beneficiary with valid data
2. Retrieve Beneficiary by ID
3. Update Beneficiary fields
4. Delete Beneficiary

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

See **[Master API Design - Section 11.{"1" if entity_info['domain'] == 'Client Management' else "2" if entity_info['domain'] == 'Circumstances' else "3" if entity_info['domain'] == 'Arrangements' else "4" if entity_info['domain'] == 'Assets & Liabilities' else "5" if entity_info['domain'] == 'Risk Profiling' else "6" if entity_info['domain'] == 'FactFind Root' else "7"}](./MASTER-API-DESIGN.md#11{"1" if entity_info['domain'] == 'Client Management' else "2" if entity_info['domain'] == 'Circumstances' else "3" if entity_info['domain'] == 'Arrangements' else "4" if entity_info['domain'] == 'Assets & Liabilities' else "5" if entity_info['domain'] == 'Risk Profiling' else "6" if entity_info['domain'] == 'FactFind Root' else "7"}-arrangements-domain)** for other APIs in the Arrangements domain.

---

**Document Version:** 2.0
**Last Updated:** 2026-02-25
**Entity:** Beneficiary
**Domain:** Arrangements
