# Task 2.2: Extend EmploymentDocument Contract

**Epic**: Epic 2 - Employment Classification Fields
**Task**: 2.2 - Extend EmploymentDocument Contract with Classification Fields
**Status**: Implementation Guide
**Date**: 2026-01-27

---

## Overview

This document specifies the additions to `BaseEmploymentDocument` to support the 4 new employment classification fields. These properties will be automatically inherited by both `EmploymentDocument` and `CreateEmploymentDocument`.

**File to modify**: `Monolith.FactFind/src/Monolith.FactFind/v2/Contracts/EmploymentDocument.cs`

---

## Contract Changes

Add the following properties to the `BaseEmploymentDocument` abstract class (recommend adding after `EmploymentStatusDescription` property, before the closing brace of the class):

```csharp
/// <summary>
/// Type of employment classification (e.g., Employed, Self-Employed, Sole Trader, Limited Company, Limited Partnership)
/// Used when Employment Status indicates the person is working
/// </summary>
[AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
[DefaultValue(null)]
[ValidEnumValues(typeof(EmploymentTypeValue))]
public EmploymentTypeValue? EmploymentType { get; set; }

/// <summary>
/// Broad classification of occupation type (e.g., Manual, Skilled, Professional, Civil Servant, Director, Business Partner)
/// </summary>
[AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
[DefaultValue(null)]
[ValidEnumValues(typeof(OccupationTypeValue))]
public OccupationTypeValue? OccupationType { get; set; }

/// <summary>
/// Indicates whether employment is Full Time or Part Time
/// </summary>
[AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
[DefaultValue(null)]
[ValidEnumValues(typeof(EmployedTypeValue))]
public EmployedTypeValue? EmployedType { get; set; }

/// <summary>
/// Contractual basis of employment (e.g., Agency, Contract, Permanent, Probationary, Temporary)
/// </summary>
[AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
[DefaultValue(null)]
[ValidEnumValues(typeof(EmployedBasisValue))]
public EmployedBasisValue? EmployedBasis { get; set; }
```

### Complete Modified BaseEmploymentDocument Class

The complete class after modifications should look like this (showing only the new section):

```csharp
[SwaggerDefinition("BaseEmployment")]
public abstract class BaseEmploymentDocument
{
    // ... existing properties (Id, Href, StartsOn, EndsOn, etc.) ...

    /// <summary>
    /// Employment Status Description.
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [MaxLength(1000)]
    [DefaultValue(null)]
    public string EmploymentStatusDescription { get; set; }

    // NEW: API v2.1 - Employment Classification Fields

    /// <summary>
    /// Type of employment classification (e.g., Employed, Self-Employed, Sole Trader, Limited Company, Limited Partnership)
    /// Used when Employment Status indicates the person is working
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [DefaultValue(null)]
    [ValidEnumValues(typeof(EmploymentTypeValue))]
    public EmploymentTypeValue? EmploymentType { get; set; }

    /// <summary>
    /// Broad classification of occupation type (e.g., Manual, Skilled, Professional, Civil Servant, Director, Business Partner)
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [DefaultValue(null)]
    [ValidEnumValues(typeof(OccupationTypeValue))]
    public OccupationTypeValue? OccupationType { get; set; }

    /// <summary>
    /// Indicates whether employment is Full Time or Part Time
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [DefaultValue(null)]
    [ValidEnumValues(typeof(EmployedTypeValue))]
    public EmployedTypeValue? EmployedType { get; set; }

    /// <summary>
    /// Contractual basis of employment (e.g., Agency, Contract, Permanent, Probationary, Temporary)
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [DefaultValue(null)]
    [ValidEnumValues(typeof(EmployedBasisValue))]
    public EmployedBasisValue? EmployedBasis { get; set; }
}
```

---

## Key Design Decisions

### 1. All Fields Optional (Nullable)
All 4 new properties use nullable enum types (`EmploymentTypeValue?`, etc.) to maintain backward compatibility. Existing API clients can continue to work without providing these fields.

### 2. AllowedVerbs
- **POST and PUT**: Allows setting values when creating or updating employment records
- **GET**: Implicitly allowed for all properties
- **DELETE**: Not applicable to properties

### 3. ValidEnumValues Attribute
The `[ValidEnumValues]` attribute ensures that:
- Only valid enum values are accepted
- Invalid values result in a 400 Bad Request with clear error message
- Swagger documentation shows available enum values

### 4. DefaultValue(null)
Explicitly documents that these fields default to null when not provided, maintaining API clarity.

---

## API Examples

### Example 1: Create Employment with Classification Fields (POST)

**Request**:
```http
POST /v2/clients/12345/employments
Content-Type: application/json

{
  "employmentStatus": "Employed",
  "employer": "Acme Corporation",
  "occupation": "Software Engineer",
  "startsOn": "2020-01-15",
  "employmentType": "Employed",
  "occupationType": "Professional",
  "employedType": "Full Time",
  "employedBasis": "Permanent"
}
```

**Response** (201 Created):
```json
{
  "id": 789,
  "href": "/v2/clients/12345/employments/789",
  "employmentStatus": "Employed",
  "employer": "Acme Corporation",
  "occupation": "Software Engineer",
  "startsOn": "2020-01-15",
  "endsOn": null,
  "employmentType": "Employed",
  "occupationType": "Professional",
  "employedType": "Full Time",
  "employedBasis": "Permanent",
  "client": {
    "id": 12345,
    "href": "/v2/clients/12345"
  },
  "incomesHref": "/v2/clients/12345/incomes?filter=employment.id eq 789"
}
```

### Example 2: Update Employment - Add Classification (PUT)

**Request**:
```http
PUT /v2/clients/12345/employments/789
Content-Type: application/json

{
  "employmentStatus": "Self-Employed",
  "employer": "My Consulting Ltd",
  "occupation": "IT Consultant",
  "startsOn": "2021-06-01",
  "employmentType": "Limited Company",
  "occupationType": "Professional",
  "employedType": "Full Time",
  "employedBasis": "Contract"
}
```

### Example 3: Backward Compatible - No Classification Fields

**Request** (existing client code):
```http
POST /v2/clients/12345/employments
Content-Type: application/json

{
  "employmentStatus": "Employed",
  "employer": "Old Client Corp",
  "occupation": "Manager"
}
```

**Response** (201 Created - works perfectly):
```json
{
  "id": 790,
  "href": "/v2/clients/12345/employments/790",
  "employmentStatus": "Employed",
  "employer": "Old Client Corp",
  "occupation": "Manager",
  "startsOn": null,
  "endsOn": null,
  "employmentType": null,
  "occupationType": null,
  "employedType": null,
  "employedBasis": null,
  "client": {
    "id": 12345,
    "href": "/v2/clients/12345"
  }
}
```

---

## Swagger Documentation

After this change, Swagger will automatically document the new fields with their enum values:

```yaml
BaseEmployment:
  type: object
  properties:
    # ... existing properties ...
    employmentType:
      type: string
      enum:
        - Employed
        - Self-Employed
        - Sole Trader
        - Limited Company
        - Limited Partnership
      nullable: true
    occupationType:
      type: string
      enum:
        - Manual
        - Skilled
        - Professional
        - Civil Servant
        - Director
        - Business Partner
      nullable: true
    employedType:
      type: string
      enum:
        - Full Time
        - Part Time
      nullable: true
    employedBasis:
      type: string
      enum:
        - Agency
        - Contract
        - Permanent
        - Probationary
        - Temporary
      nullable: true
```

---

## Validation Behavior

The `[ValidEnumValues]` attribute provides automatic validation:

### Valid Request:
```json
{
  "employmentStatus": "Employed",
  "employmentType": "Permanent"
}
```
✅ **Result**: 201 Created

### Invalid Enum Value:
```json
{
  "employmentStatus": "Employed",
  "employmentType": "InvalidValue"
}
```
❌ **Result**: 400 Bad Request
```json
{
  "error": "The value 'InvalidValue' is not valid for EmploymentType. Allowed values are: Employed, Self-Employed, Sole Trader, Limited Company, Limited Partnership"
}
```

### Null/Omitted (Optional):
```json
{
  "employmentStatus": "Employed"
}
```
✅ **Result**: 201 Created (new fields are null)

---

## Testing Checklist

After implementation:

- [ ] Compile solution - verify no compilation errors
- [ ] Verify Swagger UI shows new enum fields with correct values
- [ ] Test POST with all 4 new fields populated
- [ ] Test POST with no new fields (backward compatibility)
- [ ] Test PUT to add classification fields to existing employment
- [ ] Test PUT to update classification fields
- [ ] Test validation - invalid enum value returns 400 Bad Request
- [ ] Test GET returns classification fields correctly
- [ ] Run all existing EmploymentDocument unit tests
- [ ] Run all existing API sub-system tests

---

## Pre-Conditions

- Task 2.1 completed: All 4 enum types created
- Enums available in `Monolith.FactFind.v2.Contracts` namespace

## Post-Conditions

- `BaseEmploymentDocument` has 4 new optional properties
- `EmploymentDocument` (GET response) includes new fields
- `CreateEmploymentDocument` (POST request) accepts new fields
- All properties marked as [AllowedVerbs(Post, Put)]
- Swagger documentation auto-generated for new fields
- Backward compatibility maintained (all fields optional)

---

## Next Steps

After completing this task:
1. **Task 2.3**: Update EmploymentConverter to map new fields between domain and contract
2. **Task 2.4**: Update EmploymentValidator to add validation rules for new fields

---

## Related Files

- Enum Definitions: `Requirements/Employment/003_Employment_Classification_Enum_Types.md`
- Development Plan: `Requirements/Employment/Development_Plan.md` (Task 2.2)
- Reference Contract: `Context/Monolith.FactFind/v2/Contracts/EmploymentDocument.cs`
