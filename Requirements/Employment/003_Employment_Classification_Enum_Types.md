# Task 2.1: Create New Enum Types for Employment Classification

**Epic**: Epic 2 - Employment Classification Fields
**Task**: 2.1 - Create New Enum Types
**Status**: Implementation Guide
**Date**: 2026-01-27

---

## Overview

This document specifies the 4 new enum types required for Employment API v2.1, based on the data extracted from "Fact Find Data Analysis v6.0.xlsx". Each enum follows the existing pattern used in `EmploymentStatusValue` and `EmploymentBusinessTypeValue`.

**Source**: Context\Fact Find Data Analysis v6.0.xlsx, "Fact Finds" sheet, rows 312, 316, 318, 319

---

## Enum Type 1: EmploymentTypeValue

**Purpose**: Describes the type of employment classification (used when Employment Status = Working or Semi-Retired)

**File**: `Monolith.FactFind/src/Monolith.FactFind/v2/Contracts/EmploymentTypeValue.cs`

```csharp
using Monolith.FactFind.Infrastructure;

namespace Monolith.FactFind.v2.Contracts
{
    /// <summary>
    /// Represents the type of employment classification
    /// Used when Employment Status indicates the person is working
    /// </summary>
    public enum EmploymentTypeValue
    {
        [StringValue("Employed")]
        Employed = 1,

        [StringValue("Self-Employed")]
        SelfEmployed = 2,

        [StringValue("Sole Trader")]
        SoleTrader = 3,

        [StringValue("Limited Company")]
        LimitedCompany = 4,

        [StringValue("Limited Partnership")]
        LimitedPartnership = 5
    }
}
```

**Source**: Excel Row 312
- Values: "Vision: Employed, Self-Employed, Sole Trader, Limited Company, Limited Partnership"
- Mandatory: Yes (when Employment Status = Working or Semi-Retired)

---

## Enum Type 2: OccupationTypeValue

**Purpose**: Classifies the occupation into broad categories

**File**: `Monolith.FactFind/src/Monolith.FactFind/v2/Contracts/OccupationTypeValue.cs`

```csharp
using Monolith.FactFind.Infrastructure;

namespace Monolith.FactFind.v2.Contracts
{
    /// <summary>
    /// Represents the broad classification of an occupation type
    /// </summary>
    public enum OccupationTypeValue
    {
        [StringValue("Manual")]
        Manual = 1,

        [StringValue("Skilled")]
        Skilled = 2,

        [StringValue("Professional")]
        Professional = 3,

        [StringValue("Civil Servant")]
        CivilServant = 4,

        [StringValue("Director")]
        Director = 5,

        [StringValue("Business Partner")]
        BusinessPartner = 6
    }
}
```

**Source**: Excel Row 316
- Values: "Vision: Manual, Skilled, Professional, Civil Servant, Director, Business Partner"
- Mandatory: No (optional field)

---

## Enum Type 3: EmployedTypeValue

**Purpose**: Indicates whether employment is full-time or part-time

**File**: `Monolith.FactFind/src/Monolith.FactFind/v2/Contracts/EmployedTypeValue.cs`

```csharp
using Monolith.FactFind.Infrastructure;

namespace Monolith.FactFind.v2.Contracts
{
    /// <summary>
    /// Represents whether employment is full-time or part-time
    /// </summary>
    public enum EmployedTypeValue
    {
        [StringValue("Full Time")]
        FullTime = 1,

        [StringValue("Part Time")]
        PartTime = 2
    }
}
```

**Source**: Excel Row 318
- Values: "Vision: Full Time, Part Time"
- Mandatory: Yes (when applicable)

---

## Enum Type 4: EmployedBasisValue

**Purpose**: Describes the contractual basis of employment

**File**: `Monolith.FactFind/src/Monolith.FactFind/v2/Contracts/EmployedBasisValue.cs`

```csharp
using Monolith.FactFind.Infrastructure;

namespace Monolith.FactFind.v2.Contracts
{
    /// <summary>
    /// Represents the contractual basis of employment
    /// </summary>
    public enum EmployedBasisValue
    {
        [StringValue("Agency")]
        Agency = 1,

        [StringValue("Contract")]
        Contract = 2,

        [StringValue("Permanent")]
        Permanent = 3,

        [StringValue("Probationary")]
        Probationary = 4,

        [StringValue("Temporary")]
        Temporary = 5
    }
}
```

**Source**: Excel Row 319
- Values: "Vision: Agency, Contract, Permanent, Probationary, Temporary"
- Mandatory: Yes (when applicable)

---

## Implementation Checklist

- [ ] Create `EmploymentTypeValue.cs` in `Monolith.FactFind/v2/Contracts/`
- [ ] Create `OccupationTypeValue.cs` in `Monolith.FactFind/v2/Contracts/`
- [ ] Create `EmployedTypeValue.cs` in `Monolith.FactFind/v2/Contracts/`
- [ ] Create `EmployedBasisValue.cs` in `Monolith.FactFind/v2/Contracts/`
- [ ] Verify all enums use `[StringValue("...")]` attribute correctly
- [ ] Verify all enums are in `Monolith.FactFind.v2.Contracts` namespace
- [ ] Verify all enums reference `Monolith.FactFind.Infrastructure` for StringValue attribute
- [ ] Build solution - verify no compilation errors
- [ ] Create unit tests for enum GetStringValue() extension method

---

## Unit Tests

**File**: `Monolith.FactFind.UnitTests/v2/Contracts/EmploymentEnumTests.cs`

```csharp
using FluentAssertions;
using Monolith.FactFind.Infrastructure;
using Monolith.FactFind.v2.Contracts;
using NUnit.Framework;

namespace Monolith.FactFind.UnitTests.v2.Contracts
{
    [TestFixture]
    public class EmploymentEnumTests
    {
        [TestFixture]
        public class EmploymentTypeValueTests
        {
            [Test]
            public void GetStringValue_Should_Return_Correct_Value_For_Employed()
            {
                // Arrange
                var value = EmploymentTypeValue.Employed;

                // Act
                var result = value.GetStringValue();

                // Assert
                result.Should().Be("Employed");
            }

            [Test]
            public void GetStringValue_Should_Return_Correct_Value_For_LimitedPartnership()
            {
                // Arrange
                var value = EmploymentTypeValue.LimitedPartnership;

                // Act
                var result = value.GetStringValue();

                // Assert
                result.Should().Be("Limited Partnership");
            }
        }

        [TestFixture]
        public class OccupationTypeValueTests
        {
            [Test]
            public void GetStringValue_Should_Return_Correct_Value_For_Professional()
            {
                // Arrange
                var value = OccupationTypeValue.Professional;

                // Act
                var result = value.GetStringValue();

                // Assert
                result.Should().Be("Professional");
            }

            [Test]
            public void GetStringValue_Should_Return_Correct_Value_For_CivilServant()
            {
                // Arrange
                var value = OccupationTypeValue.CivilServant;

                // Act
                var result = value.GetStringValue();

                // Assert
                result.Should().Be("Civil Servant");
            }
        }

        [TestFixture]
        public class EmployedTypeValueTests
        {
            [Test]
            public void GetStringValue_Should_Return_Correct_Value_For_FullTime()
            {
                // Arrange
                var value = EmployedTypeValue.FullTime;

                // Act
                var result = value.GetStringValue();

                // Assert
                result.Should().Be("Full Time");
            }

            [Test]
            public void GetStringValue_Should_Return_Correct_Value_For_PartTime()
            {
                // Arrange
                var value = EmployedTypeValue.PartTime;

                // Act
                var result = value.GetStringValue();

                // Assert
                result.Should().Be("Part Time");
            }
        }

        [TestFixture]
        public class EmployedBasisValueTests
        {
            [Test]
            public void GetStringValue_Should_Return_Correct_Value_For_Permanent()
            {
                // Arrange
                var value = EmployedBasisValue.Permanent;

                // Act
                var result = value.GetStringValue();

                // Assert
                result.Should().Be("Permanent");
            }

            [Test]
            public void GetStringValue_Should_Return_Correct_Value_For_Probationary()
            {
                // Arrange
                var value = EmployedBasisValue.Probationary;

                // Act
                var result = value.GetStringValue();

                // Assert
                result.Should().Be("Probationary");
            }

            [Test]
            [TestCase(EmployedBasisValue.Agency, "Agency")]
            [TestCase(EmployedBasisValue.Contract, "Contract")]
            [TestCase(EmployedBasisValue.Temporary, "Temporary")]
            public void GetStringValue_Should_Return_Correct_Value(EmployedBasisValue value, string expected)
            {
                // Act
                var result = value.GetStringValue();

                // Assert
                result.Should().Be(expected);
            }
        }
    }
}
```

---

## Swagger Documentation

When these enums are used in API contracts, Swagger will automatically generate documentation showing the available string values. Example:

```json
{
  "employmentType": "Employed",
  "occupationType": "Professional",
  "employedType": "Full Time",
  "employedBasis": "Permanent"
}
```

The `[StringValue]` attribute ensures that the API serializes these as strings (not integers), maintaining readability and consistency with existing Employment API patterns.

---

## Pre-Conditions

- None (these are new types)

## Post-Conditions

- 4 new enum types available in `Monolith.FactFind.v2.Contracts` namespace
- All enums use StringValue attribute for serialization
- Unit tests verify correct string value mapping
- Ready for use in `BaseEmploymentDocument` contract (Task 2.2)

---

## Related Files

- Reference Enums: `Context/Monolith.FactFind/v2/Contracts/EmploymentStatusValue.cs`
- Reference Enums: `Context/Monolith.FactFind/v2/Contracts/EmploymentBusinessTypeValue.cs`
- Excel Source: `Context/Fact Find Data Analysis v6.0.xlsx` (Rows 312, 316, 318, 319)
- Development Plan: `Requirements/Employment/Development_Plan.md` (Task 2.1)
- Next Task: Task 2.2 - Extend EmploymentDocument Contract
