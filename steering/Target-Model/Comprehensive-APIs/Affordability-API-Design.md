# Affordability API Design

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
| **Entity Name** | Affordability |
| **Domain** | Circumstances |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Affordability calculations

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
- `affordability:read` - Read access (GET operations)
- `affordability:write` - Create and update access (POST, PUT, PATCH)
- `affordability:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary






### Affordability Resource Properties

*Fields organized into 6 sections*

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| **Main Fields** | | | |
| `href` | string |  | Web address for this assessment |
| `factfind` | Reference Link |  | The fact-find this assessment belongs to |
| `clients` | List<Reference Link> |  | Clients included in this assessment (minimum 1) |
| `incomes` | List<Reference Link> |  | Income sources to include in calculation (minimum 1) |
| `expenditures` | List<Reference Link> |  | Expenditures to include in calculation |
| `createdAt` | timestamp |  | When this assessment was created |
| `lastUpdatedAt` | timestamp |  | When this assessment was last changed |
| **Monthly Cash Flow (Calculated Automatically)** | | | |
| `totalNetIncome` | Money |  | Total monthly income after tax |
| `totalExpenditure` | Money |  | Total monthly spending |
| `disposableIncome` | Money |  | Money left over each month |
| **Monthly Modelling Options** | | | |
| `incorporateIncomeChanges` | boolean |  | Include planned future income changes? |
| `incorporateExpenditureChanges` | boolean |  | Include planned future expenditure changes? |
| `forgoNonEssentialExpenditure` | boolean |  | Exclude all non-essential spending? (conservative scenario) |
| `excludeConsolidatedExpenditure` | boolean |  | Remove debts that will be consolidated? |
| `excludeRepaidExpenditure` | boolean |  | Remove debts that will be paid off? |
| `hasRebrokerProtection` | boolean |  | Include cost of new/rebrokered protection policies? |
| `agreedMonthlyBudget` | Money |  | Monthly amount client commits to for new commitment |
| `notes` | string |  | Explanation of modelling assumptions |
| **Monthly Affordability (Calculated Automatically)** | | | |
| `revisedIncome` | Money |  | Income after incorporating planned changes |
| `revisedExpenditure` | Money |  | Spending after applying scenario options |
| `consolidatedExpenditurePayments` | Money |  | Total payments for debts being consolidated |
| `expenditurePaymentsTobeRepaid` | Money |  | Total payments for debts being paid off |
| `protectionPremiums` | Money |  | Cost of new/rebrokered protection policies |
| `finalDisposableIncome` | Money |  | Final monthly surplus after all adjustments |
| **Lumpsum Affordability** | | | |
| `totalLumpSumAvailable` | Money |  | Total cash available |
| `agreedInvestmentAmount` | Money |  | Amount client agrees to invest/commit |
| `sourceOfInvestment` | string |  | Where the money comes from |
| `isInvestmentAvailableWithoutPenalty` | boolean |  | Can access without penalties or early exit charges? |
| `totalFundsAvailable` | Money |  | Total funds (may include other sources) - Calculated |
| **Emergency Fund** | | | |
| `committedAmount` | Money |  | Amount client has set aside for emergencies |
| `requiredAmount` | Money |  | Recommended emergency fund |
| `shortfall` | Money |  | Gap to close (calculated automatically) |

*Total: 32 properties*


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
- Affordability data must be accurate and up-to-date
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
1. Create Affordability with valid data
2. Retrieve Affordability by ID
3. Update Affordability fields
4. Delete Affordability

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
**Entity:** Affordability
**Domain:** Circumstances
