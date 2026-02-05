# Task 2.4: Update EmploymentValidator for Classification Fields

**Epic**: Epic 2 - Employment Classification Fields
**Task**: 2.4 - Update EmploymentValidator with Validation Rules
**Status**: Implementation Guide
**Date**: 2026-01-27

---

## Overview

This document specifies the validation rules to be added to `EmploymentValidator` for the 4 new employment classification fields. The validation ensures that classification fields are only provided when appropriate based on the `EmploymentStatus`.

**File to modify**: `Monolith.FactFind/src/Monolith.FactFind/v2/Resources/Validators/EmploymentValidator.cs`

---

## Validation Requirements (from Excel Analysis)

Based on Excel Row 312 analysis:
- **Employment Type**: Required when `EmploymentStatus` = "Working" or "Semi-Retired"
- **Occupation Type**: Optional (no status restrictions)
- **Employed Type**: Required when applicable (when employed)
- **Employed Basis**: Required when applicable (when employed)

### Status-Based Validation Rules

The classification fields should follow similar patterns to existing fields:
1. **Should NOT be provided** for unemployment statuses (Student, Unemployed, Retired, etc.)
2. **Can be provided** for employment statuses (Employed, Self-Employed, Company Director, etc.)

---

## Implementation Changes

### 1. Add Classification Status Arrays

Add the following arrays at the top of the `EmploymentValidator` class (after existing status arrays, around line 16):

```csharp
// Classification fields - valid for employment statuses only (API v2.1)
private static readonly EmploymentStatusValue[] ClassificationValidStatuses = {
    EmploymentStatusValue.Employed,
    EmploymentStatusValue.SelfEmployed,
    EmploymentStatusValue.CompanyDirector,
    EmploymentStatusValue.MaternityLeave,
    EmploymentStatusValue.LongTermIllness,
    EmploymentStatusValue.ContractWorker,
    EmploymentStatusValue.Other
};
```

**Rationale**: These are the employment statuses where classification fields are meaningful (i.e., the person is or was recently employed).

### 2. Update Validate Method

Add validation calls in the `Validate(BaseEmploymentDocument employment, EmploymentStatusValue employmentStatus)` method, after line 44 (after the existing `EmploymentBusinessType` validation):

```csharp
public void Validate(BaseEmploymentDocument employment, EmploymentStatusValue employmentStatus)
{
    Check.IsNotNull(employment, $"{nameof(employment)} can't be null");
    if (employment.StartsOn != null && employment.EndsOn != null)
    {
        Check.IsTrue(employment.StartsOn <= employment.EndsOn,
            $"{nameof(employment.StartsOn)} should be less or equal to {nameof(employment.EndsOn)}");
    }
    Check.IsTrue(employment.InProbation.GetValueOrDefault() || !employment.ProbationPeriodInMonths.HasValue,
        $"'{nameof(employment.ProbationPeriodInMonths)}' can be specified only when '{nameof(employment.InProbation)}' is True");

    IsNotValidForEmploymentStatus(!string.IsNullOrEmpty(employment.Employer), nameof(employment.Employer),
        UnemploymentStatuses, employmentStatus);
    IsNotValidForEmploymentStatus(!string.IsNullOrEmpty(employment.Occupation), nameof(employment.Occupation),
        UnemploymentStatuses, employmentStatus);
    IsValidForEmploymentStatus(employment.InProbation.HasValue, nameof(employment.InProbation), InProbationStatuses, employmentStatus);
    IsValidForEmploymentStatus(employment.Address != null, nameof(employment.Address), AddressesStatuses, employmentStatus);
    IsValidForEmploymentStatus(employment.EmploymentBusinessType.HasValue, nameof(employment.EmploymentBusinessType), BusinessTypeStatuses, employmentStatus);

    // NEW: API v2.1 - Classification field validation
    IsValidForEmploymentStatus(employment.EmploymentType.HasValue, nameof(employment.EmploymentType),
        ClassificationValidStatuses, employmentStatus);
    IsValidForEmploymentStatus(employment.OccupationType.HasValue, nameof(employment.OccupationType),
        ClassificationValidStatuses, employmentStatus);
    IsValidForEmploymentStatus(employment.EmployedType.HasValue, nameof(employment.EmployedType),
        ClassificationValidStatuses, employmentStatus);
    IsValidForEmploymentStatus(employment.EmployedBasis.HasValue, nameof(employment.EmployedBasis),
        ClassificationValidStatuses, employmentStatus);
}
```

---

## Complete Modified Validate Method

```csharp
public void Validate(BaseEmploymentDocument employment, EmploymentStatusValue employmentStatus)
{
    Check.IsNotNull(employment, $"{nameof(employment)} can't be null");
    if (employment.StartsOn != null && employment.EndsOn != null)
    {
        Check.IsTrue(employment.StartsOn <= employment.EndsOn,
            $"{nameof(employment.StartsOn)} should be less or equal to {nameof(employment.EndsOn)}");
    }
    Check.IsTrue(employment.InProbation.GetValueOrDefault() || !employment.ProbationPeriodInMonths.HasValue,
        $"'{nameof(employment.ProbationPeriodInMonths)}' can be specified only when '{nameof(employment.InProbation)}' is True");

    IsNotValidForEmploymentStatus(!string.IsNullOrEmpty(employment.Employer), nameof(employment.Employer),
        UnemploymentStatuses, employmentStatus);
    IsNotValidForEmploymentStatus(!string.IsNullOrEmpty(employment.Occupation), nameof(employment.Occupation),
        UnemploymentStatuses, employmentStatus);
    IsValidForEmploymentStatus(employment.InProbation.HasValue, nameof(employment.InProbation), InProbationStatuses, employmentStatus);
    IsValidForEmploymentStatus(employment.Address != null, nameof(employment.Address), AddressesStatuses, employmentStatus);
    IsValidForEmploymentStatus(employment.EmploymentBusinessType.HasValue, nameof(employment.EmploymentBusinessType), BusinessTypeStatuses, employmentStatus);

    // API v2.1 - Classification field validation
    IsValidForEmploymentStatus(employment.EmploymentType.HasValue, nameof(employment.EmploymentType),
        ClassificationValidStatuses, employmentStatus);
    IsValidForEmploymentStatus(employment.OccupationType.HasValue, nameof(employment.OccupationType),
        ClassificationValidStatuses, employmentStatus);
    IsValidForEmploymentStatus(employment.EmployedType.HasValue, nameof(employment.EmployedType),
        ClassificationValidStatuses, employmentStatus);
    IsValidForEmploymentStatus(employment.EmployedBasis.HasValue, nameof(employment.EmployedBasis),
        ClassificationValidStatuses, employmentStatus);
}
```

---

## Validation Behavior Examples

### Example 1: Valid - Employed with Classification

**Request**:
```json
{
  "employmentStatus": "Employed",
  "employer": "Acme Corp",
  "occupation": "Engineer",
  "employmentType": "Employed",
  "occupationType": "Professional",
  "employedType": "Full Time",
  "employedBasis": "Permanent"
}
```
✅ **Result**: Validation passes (201 Created)

### Example 2: Valid - Self-Employed with Classification

**Request**:
```json
{
  "employmentStatus": "Self-Employed",
  "employer": "My Business Ltd",
  "occupation": "Consultant",
  "employmentType": "Sole Trader",
  "occupationType": "Professional",
  "employedType": "Full Time",
  "employedBasis": "Contract"
}
```
✅ **Result**: Validation passes (201 Created)

### Example 3: Invalid - Student with Classification Fields

**Request**:
```json
{
  "employmentStatus": "Student",
  "employmentType": "Employed"
}
```
❌ **Result**: 400 Bad Request
```json
{
  "error": "EmploymentType can be supplied only for statuses: Employed,SelfEmployed,CompanyDirector,MaternityLeave,LongTermIllness,ContractWorker,Other"
}
```

### Example 4: Invalid - Retired with Classification Fields

**Request**:
```json
{
  "employmentStatus": "Retired",
  "employedBasis": "Permanent"
}
```
❌ **Result**: 400 Bad Request
```json
{
  "error": "EmployedBasis can be supplied only for statuses: Employed,SelfEmployed,CompanyDirector,MaternityLeave,LongTermIllness,ContractWorker,Other"
}
```

### Example 5: Valid - Employed without Classification (Backward Compatible)

**Request**:
```json
{
  "employmentStatus": "Employed",
  "employer": "Old Corp",
  "occupation": "Manager"
}
```
✅ **Result**: Validation passes (201 Created) - classification fields are optional

### Example 6: Valid - Unemployed without Classification

**Request**:
```json
{
  "employmentStatus": "Unemployed"
}
```
✅ **Result**: Validation passes (201 Created)

---

## Key Design Decisions

### 1. Use IsValidForEmploymentStatus Helper
Following the existing pattern in the validator, we use the `IsValidForEmploymentStatus` helper method which:
- Allows the field to be null (optional)
- Only validates if the field has a value
- Checks if the current `EmploymentStatus` is in the allowed list

### 2. Classification Fields Are Optional
The validation does NOT enforce that classification fields are required. They are optional, but if provided, they must only be used with appropriate employment statuses.

### 3. Consistent Error Messages
Error messages follow the existing pattern:
```
"FieldName can be supplied only for statuses: Status1,Status2,Status3"
```

### 4. No Cross-Field Validation
We do NOT add complex cross-field validation (e.g., "if EmploymentType = SelfEmployed, then EmploymentBusinessType is required"). The API remains flexible, and business logic can be enforced at higher layers if needed.

---

## Unit Tests

**File**: Create `Monolith.FactFind.UnitTests/v2/Resources/Validators/EmploymentValidatorClassificationTests.cs`

```csharp
using FluentAssertions;
using Monolith.FactFind.Infrastructure;
using Monolith.FactFind.v2.Contracts;
using Monolith.FactFind.v2.Resources.Validators;
using NUnit.Framework;
using System;

namespace Monolith.FactFind.UnitTests.v2.Resources.Validators
{
    [TestFixture]
    public class EmploymentValidatorClassificationTests
    {
        private EmploymentValidator validator;

        [SetUp]
        public void Setup()
        {
            validator = new EmploymentValidator();
        }

        [TestFixture]
        public class ValidScenarios : EmploymentValidatorClassificationTests
        {
            [Test]
            public void Should_Accept_Classification_Fields_For_Employed_Status()
            {
                // Arrange
                var employment = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.Employed,
                    Employer = "Test Corp",
                    Occupation = "Engineer",
                    EmploymentType = EmploymentTypeValue.Employed,
                    OccupationType = OccupationTypeValue.Professional,
                    EmployedType = EmployedTypeValue.FullTime,
                    EmployedBasis = EmployedBasisValue.Permanent
                };

                // Act & Assert
                Action act = () => validator.Validate(employment);
                act.Should().NotThrow();
            }

            [Test]
            public void Should_Accept_Classification_Fields_For_SelfEmployed_Status()
            {
                // Arrange
                var employment = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.SelfEmployed,
                    Employer = "My Business",
                    Occupation = "Consultant",
                    EmploymentType = EmploymentTypeValue.SoleTrader,
                    OccupationType = OccupationTypeValue.Professional
                };

                // Act & Assert
                Action act = () => validator.Validate(employment);
                act.Should().NotThrow();
            }

            [Test]
            public void Should_Accept_Employed_Without_Classification_Fields()
            {
                // Arrange
                var employment = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.Employed,
                    Employer = "Test Corp",
                    Occupation = "Manager"
                    // No classification fields provided
                };

                // Act & Assert
                Action act = () => validator.Validate(employment);
                act.Should().NotThrow();
            }

            [Test]
            public void Should_Accept_Unemployed_Without_Classification_Fields()
            {
                // Arrange
                var employment = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.Unemployed
                };

                // Act & Assert
                Action act = () => validator.Validate(employment);
                act.Should().NotThrow();
            }
        }

        [TestFixture]
        public class InvalidScenarios : EmploymentValidatorClassificationTests
        {
            [Test]
            public void Should_Reject_EmploymentType_For_Student_Status()
            {
                // Arrange
                var employment = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.Student,
                    EmploymentType = EmploymentTypeValue.Employed
                };

                // Act
                Action act = () => validator.Validate(employment);

                // Assert
                act.Should().Throw<InvalidOperationException>()
                    .WithMessage("*EmploymentType can be supplied only for statuses*");
            }

            [Test]
            public void Should_Reject_OccupationType_For_Retired_Status()
            {
                // Arrange
                var employment = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.Retired,
                    OccupationType = OccupationTypeValue.Professional
                };

                // Act
                Action act = () => validator.Validate(employment);

                // Assert
                act.Should().Throw<InvalidOperationException>()
                    .WithMessage("*OccupationType can be supplied only for statuses*");
            }

            [Test]
            public void Should_Reject_EmployedType_For_Unemployed_Status()
            {
                // Arrange
                var employment = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.Unemployed,
                    EmployedType = EmployedTypeValue.FullTime
                };

                // Act
                Action act = () => validator.Validate(employment);

                // Assert
                act.Should().Throw<InvalidOperationException>()
                    .WithMessage("*EmployedType can be supplied only for statuses*");
            }

            [Test]
            public void Should_Reject_EmployedBasis_For_Houseperson_Status()
            {
                // Arrange
                var employment = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.Houseperson,
                    EmployedBasis = EmployedBasisValue.Permanent
                };

                // Act
                Action act = () => validator.Validate(employment);

                // Assert
                act.Should().Throw<InvalidOperationException>()
                    .WithMessage("*EmployedBasis can be supplied only for statuses*");
            }

            [Test]
            [TestCase(EmploymentStatusValue.Student)]
            [TestCase(EmploymentStatusValue.Unemployed)]
            [TestCase(EmploymentStatusValue.Retired)]
            [TestCase(EmploymentStatusValue.Houseperson)]
            [TestCase(EmploymentStatusValue.CarerOfaChildUnder16)]
            public void Should_Reject_Classification_Fields_For_Unemployment_Statuses(EmploymentStatusValue status)
            {
                // Arrange
                var employment = new CreateEmploymentDocument
                {
                    EmploymentStatus = status,
                    EmploymentType = EmploymentTypeValue.Employed
                };

                // Act
                Action act = () => validator.Validate(employment);

                // Assert
                act.Should().Throw<InvalidOperationException>()
                    .WithMessage("*EmploymentType can be supplied only for statuses*");
            }
        }

        [TestFixture]
        public class BackwardCompatibilityTests : EmploymentValidatorClassificationTests
        {
            [Test]
            public void Should_Not_Break_Existing_Validation_Logic()
            {
                // Arrange - test existing validation still works
                var employment = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.Employed,
                    Employer = "Test",
                    Occupation = "Role",
                    StartsOn = DateTime.Now.AddYears(1),
                    EndsOn = DateTime.Now // Invalid: starts after ends
                };

                // Act
                Action act = () => validator.Validate(employment);

                // Assert
                act.Should().Throw<InvalidOperationException>()
                    .WithMessage("*StartsOn should be less or equal to EndsOn*");
            }

            [Test]
            public void Should_Allow_Old_Clients_Without_Classification_Fields()
            {
                // Arrange - simulate old client code that doesn't know about classification
                var employment = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.Employed,
                    Employer = "Old Corp",
                    Occupation = "Manager",
                    StartsOn = DateTime.Now.AddYears(-5)
                };

                // Act & Assert
                Action act = () => validator.Validate(employment);
                act.Should().NotThrow();
            }
        }
    }
}
```

---

## Testing Checklist

After implementation:

- [ ] Compile solution - verify no compilation errors
- [ ] Run all `EmploymentValidatorClassificationTests` unit tests - all pass
- [ ] Run existing `EmploymentValidator` unit tests - all pass (no regression)
- [ ] Test validation accepts classification fields for employment statuses
- [ ] Test validation rejects classification fields for unemployment statuses
- [ ] Test validation allows null classification fields (optional)
- [ ] Test backward compatibility - old requests without classification still work
- [ ] Verify error messages are clear and helpful

---

## Pre-Conditions

- Task 2.1 completed: Enum types created
- Task 2.2 completed: Contract extended with classification properties
- Task 2.3 completed: Converter updated

## Post-Conditions

- `EmploymentValidator` enforces status-based rules for classification fields
- Classification fields can only be supplied for appropriate employment statuses
- Classification fields remain optional (null allowed)
- Clear error messages guide API consumers
- All validation unit tests pass
- No breaking changes to existing validation behavior

---

## Next Steps

After completing Epic 2 (Tasks 2.1-2.4):
- **Epic 3**: Self-Employed Financial Accounts (Task 3.1-3.5)
- **Epic 4**: Testing, Documentation & Release (Task 4.1-4.5)

---

## Related Files

- Validator Implementation: `Context/Monolith.FactFind/v2/Resources/Validators/EmploymentValidator.cs`
- Enum Definitions: `Requirements/Employment/003_Employment_Classification_Enum_Types.md`
- Contract Definition: `Requirements/Employment/004_Extend_Employment_Document_Contract.md`
- Converter Changes: `Requirements/Employment/005_Update_Employment_Converter.md`
- Development Plan: `Requirements/Employment/Development_Plan.md` (Task 2.4)
