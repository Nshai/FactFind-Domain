# Task 2.3: Update EmploymentConverter Mapping

**Epic**: Epic 2 - Employment Classification Fields
**Task**: 2.3 - Update EmploymentConverter for Classification Field Mapping
**Status**: Implementation Guide
**Date**: 2026-01-27

---

## Overview

This document specifies the changes to `EmploymentConverter` to map the 4 new classification fields between the domain entity (`Employment`) and the API contract (`EmploymentDocument`, `CreateEmploymentDocument`).

**File to modify**: `Monolith.FactFind/src/Monolith.FactFind/v2/Resources/Converters/EmploymentConverter.cs`

---

## Changes Required

### 1. Update ToContract Method (Domain → API)

**Location**: `ToContract(Employment entity)` method (around line 49-77)

Add the following enum parsing logic after line 57 (after `businessType` parsing):

```csharp
// Parse new classification enums (API v2.1)
var employmentType = entity.EmploymentType != null
    ? EnumHelper.FindEnum<EmploymentTypeValue>(entity.EmploymentType, true)
    : (EmploymentTypeValue?)null;

var occupationType = entity.OccupationType != null
    ? EnumHelper.FindEnum<OccupationTypeValue>(entity.OccupationType, true)
    : (OccupationTypeValue?)null;

var employedType = entity.EmployedType != null
    ? EnumHelper.FindEnum<EmployedTypeValue>(entity.EmployedType, true)
    : (EmployedTypeValue?)null;

var employedBasis = entity.EmployedBasis != null
    ? EnumHelper.FindEnum<EmployedBasisValue>(entity.EmployedBasis, true)
    : (EmployedBasisValue?)null;
```

Then add the new properties to the `EmploymentDocument` construction (after line 74):

```csharp
var result = new EmploymentDocument
{
    Id = entity.Id,
    StartsOn = entity.StartDate,
    EndsOn = entity.EndDate,
    Occupation = entity.Role,
    Employer = entity.Employer,
    IntendedRetirementAge = entity.IntendedRetirementAge,
    EmploymentStatus = status,
    EmploymentBusinessType = businessType,
    EmploymentStatusDescription = entity.StatusDescription,
    Address = ToContractAddress(entity.Address),
    InProbation = entity.InProbation,
    Client = new ClientReference { Id = entity.ClientId },
    ProbationPeriodInMonths = entity.ProbationPeriodInMonths,
    IndustryType = entity.IndustryType,
    // NEW: API v2.1 - Classification Fields
    EmploymentType = employmentType,
    OccupationType = occupationType,
    EmployedType = employedType,
    EmployedBasis = employedBasis
};
```

### 2. Update ToDomain Method (API → Domain)

**Location**: `ToDomain(Employment entity, BaseEmploymentDocument document)` method (around line 91-108)

Add the following conversions after line 106:

```csharp
entity.Employer = document.Employer;
entity.StartDate = document.StartsOn;
entity.EndDate = document.EndsOn;
entity.IntendedRetirementAge = document.IntendedRetirementAge;
entity.InProbation = document.InProbation;
entity.ProbationPeriodInMonths = document.ProbationPeriodInMonths;
entity.Role = document.Occupation;
entity.Address = ToDomainAddress(document.Address);
entity.BusinessType = document.EmploymentBusinessType?.ToString();
entity.IndustryType = document.IndustryType;
entity.StatusDescription = document.EmploymentStatusDescription;
// NEW: API v2.1 - Classification Fields
entity.EmploymentType = document.EmploymentType?.ToString();
entity.OccupationType = document.OccupationType?.ToString();
entity.EmployedType = document.EmployedType?.ToString();
entity.EmployedBasis = document.EmployedBasis?.ToString();
return entity;
```

---

## Complete Modified Methods

### Modified ToContract Method

```csharp
public EmploymentDocument ToContract(Employment entity)
{
    ArgumentNullException.ThrowIfNull(entity);

    if (entity.Status != null && entity.Status.Equals(SemiRetired, StringComparison.OrdinalIgnoreCase))
        entity.Status = EmploymentStatusValue.Employed.GetStringValue();

    var status = EnumHelper.FindEnum<EmploymentStatusValue>(entity.Status, true);
    var businessType = entity.BusinessType != null
        ? (EmploymentBusinessTypeValue)Enum.Parse(typeof(EmploymentBusinessTypeValue), entity.BusinessType)
        : (EmploymentBusinessTypeValue?)null;

    // Parse new classification enums (API v2.1)
    var employmentType = entity.EmploymentType != null
        ? EnumHelper.FindEnum<EmploymentTypeValue>(entity.EmploymentType, true)
        : (EmploymentTypeValue?)null;

    var occupationType = entity.OccupationType != null
        ? EnumHelper.FindEnum<OccupationTypeValue>(entity.OccupationType, true)
        : (OccupationTypeValue?)null;

    var employedType = entity.EmployedType != null
        ? EnumHelper.FindEnum<EmployedTypeValue>(entity.EmployedType, true)
        : (EmployedTypeValue?)null;

    var employedBasis = entity.EmployedBasis != null
        ? EnumHelper.FindEnum<EmployedBasisValue>(entity.EmployedBasis, true)
        : (EmployedBasisValue?)null;

    var result = new EmploymentDocument
    {
        Id = entity.Id,
        StartsOn = entity.StartDate,
        EndsOn = entity.EndDate,
        Occupation = entity.Role,
        Employer = entity.Employer,
        IntendedRetirementAge = entity.IntendedRetirementAge,
        EmploymentStatus = status,
        EmploymentBusinessType = businessType,
        EmploymentStatusDescription = entity.StatusDescription,
        Address = ToContractAddress(entity.Address),
        InProbation = entity.InProbation,
        Client = new ClientReference { Id = entity.ClientId },
        ProbationPeriodInMonths = entity.ProbationPeriodInMonths,
        IndustryType = entity.IndustryType,
        // NEW: API v2.1 - Classification Fields
        EmploymentType = employmentType,
        OccupationType = occupationType,
        EmployedType = employedType,
        EmployedBasis = employedBasis
    };
    return result;
}
```

### Modified ToDomain Method

```csharp
public Employment ToDomain(Employment entity, BaseEmploymentDocument document)
{
    ArgumentNullException.ThrowIfNull(entity);
    ArgumentNullException.ThrowIfNull(document);

    entity.Employer = document.Employer;
    entity.StartDate = document.StartsOn;
    entity.EndDate = document.EndsOn;
    entity.IntendedRetirementAge = document.IntendedRetirementAge;
    entity.InProbation = document.InProbation;
    entity.ProbationPeriodInMonths = document.ProbationPeriodInMonths;
    entity.Role = document.Occupation;
    entity.Address = ToDomainAddress(document.Address);
    entity.BusinessType = document.EmploymentBusinessType?.ToString();
    entity.IndustryType = document.IndustryType;
    entity.StatusDescription = document.EmploymentStatusDescription;
    // NEW: API v2.1 - Classification Fields
    entity.EmploymentType = document.EmploymentType?.ToString();
    entity.OccupationType = document.OccupationType?.ToString();
    entity.EmployedType = document.EmployedType?.ToString();
    entity.EmployedBasis = document.EmployedBasis?.ToString();
    return entity;
}
```

---

## Key Design Decisions

### 1. Use EnumHelper.FindEnum for ToContract
The existing codebase uses `EnumHelper.FindEnum<T>()` for safe enum parsing that handles null and invalid values gracefully. We follow this pattern for consistency.

### 2. Use ToString() for ToDomain
When converting enum values back to string for domain storage, we use `.ToString()` which returns the enum member name (e.g., "FullTime", not "Full Time"). The database stores the enum member name as a string.

### 3. Nullable Handling
All new fields are nullable, so we check for null before attempting conversion:
- `entity.EmploymentType != null ? ... : null`
- `document.EmploymentType?.ToString()`

### 4. Backward Compatibility
When these fields are null in the database, they map to null in the API, and vice versa. Existing records without classification data work seamlessly.

---

## Unit Tests

**File**: Create `Monolith.FactFind.UnitTests/v2/Resources/Converters/EmploymentConverterClassificationTests.cs`

```csharp
using FluentAssertions;
using Monolith.FactFind.Domain;
using Monolith.FactFind.Infrastructure;
using Monolith.FactFind.v2.Contracts;
using Monolith.FactFind.v2.Resources.Converters;
using NUnit.Framework;
using NSubstitute;

namespace Monolith.FactFind.UnitTests.v2.Resources.Converters
{
    [TestFixture]
    public class EmploymentConverterClassificationTests
    {
        private EmploymentConverter converter;

        [SetUp]
        public void Setup()
        {
            var countryProvider = Substitute.For<ICountryProvider>();
            var countyProvider = Substitute.For<ICountyProvider>();
            converter = new EmploymentConverter(countryProvider, countyProvider);
        }

        [TestFixture]
        public class ToContractTests : EmploymentConverterClassificationTests
        {
            [Test]
            public void ToContract_Should_Map_All_Classification_Fields()
            {
                // Arrange
                var entity = new Employment
                {
                    Id = 123,
                    ClientId = 456,
                    Status = EmploymentStatusValue.Employed.GetStringValue(),
                    EmploymentType = "Employed",
                    OccupationType = "Professional",
                    EmployedType = "FullTime",
                    EmployedBasis = "Permanent"
                };

                // Act
                var result = converter.ToContract(entity);

                // Assert
                result.EmploymentType.Should().Be(EmploymentTypeValue.Employed);
                result.OccupationType.Should().Be(OccupationTypeValue.Professional);
                result.EmployedType.Should().Be(EmployedTypeValue.FullTime);
                result.EmployedBasis.Should().Be(EmployedBasisValue.Permanent);
            }

            [Test]
            public void ToContract_Should_Handle_Null_Classification_Fields()
            {
                // Arrange
                var entity = new Employment
                {
                    Id = 123,
                    ClientId = 456,
                    Status = EmploymentStatusValue.Employed.GetStringValue(),
                    EmploymentType = null,
                    OccupationType = null,
                    EmployedType = null,
                    EmployedBasis = null
                };

                // Act
                var result = converter.ToContract(entity);

                // Assert
                result.EmploymentType.Should().BeNull();
                result.OccupationType.Should().BeNull();
                result.EmployedType.Should().BeNull();
                result.EmployedBasis.Should().BeNull();
            }

            [Test]
            public void ToContract_Should_Map_SelfEmployed_EmploymentType()
            {
                // Arrange
                var entity = new Employment
                {
                    Id = 123,
                    ClientId = 456,
                    Status = EmploymentStatusValue.SelfEmployed.GetStringValue(),
                    EmploymentType = "SoleTrader"
                };

                // Act
                var result = converter.ToContract(entity);

                // Assert
                result.EmploymentType.Should().Be(EmploymentTypeValue.SoleTrader);
            }
        }

        [TestFixture]
        public class ToDomainTests : EmploymentConverterClassificationTests
        {
            [Test]
            public void ToDomain_Should_Map_All_Classification_Fields()
            {
                // Arrange
                var entity = new Employment { ClientId = 456 };
                var document = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.Employed,
                    EmploymentType = EmploymentTypeValue.LimitedCompany,
                    OccupationType = OccupationTypeValue.Director,
                    EmployedType = EmployedTypeValue.FullTime,
                    EmployedBasis = EmployedBasisValue.Contract
                };

                // Act
                var result = converter.ToDomain(entity, document);

                // Assert
                result.EmploymentType.Should().Be("LimitedCompany");
                result.OccupationType.Should().Be("Director");
                result.EmployedType.Should().Be("FullTime");
                result.EmployedBasis.Should().Be("Contract");
            }

            [Test]
            public void ToDomain_Should_Handle_Null_Classification_Fields()
            {
                // Arrange
                var entity = new Employment { ClientId = 456 };
                var document = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.Employed,
                    EmploymentType = null,
                    OccupationType = null,
                    EmployedType = null,
                    EmployedBasis = null
                };

                // Act
                var result = converter.ToDomain(entity, document);

                // Assert
                result.EmploymentType.Should().BeNull();
                result.OccupationType.Should().BeNull();
                result.EmployedType.Should().BeNull();
                result.EmployedBasis.Should().BeNull();
            }

            [Test]
            public void ToDomain_Should_Convert_Enum_To_String_For_Database()
            {
                // Arrange
                var entity = new Employment { ClientId = 456 };
                var document = new CreateEmploymentDocument
                {
                    EmploymentStatus = EmploymentStatusValue.Employed,
                    EmploymentType = EmploymentTypeValue.SelfEmployed
                };

                // Act
                var result = converter.ToDomain(entity, document);

                // Assert
                result.EmploymentType.Should().Be("SelfEmployed"); // Enum name, not string value
            }
        }

        [TestFixture]
        public class BackwardCompatibilityTests : EmploymentConverterClassificationTests
        {
            [Test]
            public void Existing_Employment_Without_Classification_Should_Work()
            {
                // Arrange - simulate existing employment record in database without new fields
                var entity = new Employment
                {
                    Id = 999,
                    ClientId = 123,
                    Status = EmploymentStatusValue.Employed.GetStringValue(),
                    Employer = "Old Company",
                    Role = "Manager"
                    // EmploymentType, OccupationType, etc. are null (old records)
                };

                // Act
                var result = converter.ToContract(entity);

                // Assert
                result.Should().NotBeNull();
                result.Employer.Should().Be("Old Company");
                result.Occupation.Should().Be("Manager");
                result.EmploymentType.Should().BeNull();
                result.OccupationType.Should().BeNull();
                result.EmployedType.Should().BeNull();
                result.EmployedBasis.Should().BeNull();
            }
        }
    }
}
```

---

## Testing Checklist

After implementation:

- [ ] Compile solution - verify no compilation errors
- [ ] Run all `EmploymentConverterClassificationTests` unit tests - all pass
- [ ] Run existing `EmploymentConverter` unit tests - all pass (no regression)
- [ ] Test ToContract with populated classification fields
- [ ] Test ToContract with null classification fields
- [ ] Test ToDomain with populated classification fields
- [ ] Test ToDomain with null classification fields
- [ ] Verify enum-to-string and string-to-enum conversions
- [ ] Test backward compatibility with existing employment records

---

## Pre-Conditions

- Task 2.1 completed: Enum types created
- Task 2.2 completed: Contract extended with classification properties
- Domain entity updated with classification fields (Task 1.2)

## Post-Conditions

- `EmploymentConverter.ToContract()` maps classification fields from domain to API
- `EmploymentConverter.ToDomain()` maps classification fields from API to domain
- All mappings handle null values correctly
- Unit tests verify correct bidirectional mapping
- No breaking changes to existing converter behavior

---

## Next Steps

After completing this task:
- **Task 2.4**: Update EmploymentValidator to add validation rules for classification fields

---

## Related Files

- Converter Implementation: `Context/Monolith.FactFind/v2/Resources/Converters/EmploymentConverter.cs`
- Enum Definitions: `Requirements/Employment/003_Employment_Classification_Enum_Types.md`
- Contract Definition: `Requirements/Employment/004_Extend_Employment_Document_Contract.md`
- Development Plan: `Requirements/Employment/Development_Plan.md` (Task 2.3)
