# Employment API v2.1 - Development Plan

**Project**: Employment CRUD API Extension
**Version**: 2.1 (Non-Breaking)
**Document Version**: 1.0
**Date**: January 27, 2026
**Status**: Draft
**Duration**: 5 weeks
**Effort**: ~25 person-days

---

## Table of Contents

1. [Overview](#overview)
2. [Epic 1: Database Schema Changes](#epic-1-database-schema-changes)
3. [Epic 2: Employment Classification Fields](#epic-2-employment-classification-fields)
4. [Epic 3: Self-Employed Financial Accounts](#epic-3-self-employed-financial-accounts)
5. [Epic 4: Testing, Documentation & Release](#epic-4-testing-documentation--release)
6. [Dependencies & Risks](#dependencies--risks)
7. [Definition of Done](#definition-of-done)

---

## Overview

### Objective
Extend the Employment API (v2 → v2.1) to support 21 additional fields identified in the Fact Find Data Analysis v6.0:
- 4 employment classification fields
- 16 self-employed financial account fields (3 years)
- 1 current employment indicator
- 1 calculated field (continuous employment months)

### Principles from Monolith.FactFind Codebase

**Architecture Pattern** (Observed):
```
Controller (thin)
  → Resource (business logic, validation)
    → Converter (domain ↔ contract mapping)
      → Repository (NHibernate)
```

**Key Practices**:
- Use `[Transaction]` attribute on Resource methods
- Use `[PublishEvent<T>]` for domain events (Created, Changed, Deleted)
- Separate `CreateEmploymentDocument` and `EmploymentDocument` (base class: `BaseEmploymentDocument`)
- Validators have interface contracts (`IEmploymentValidator`)
- Converters are injected via DI (`IEmploymentConverter`)
- Sub-system tests for API endpoints, unit tests for converters/validators
- Use `Check.IsTrue()` and `Check.IsNotNull()` for validation

**Testing Pattern**:
- **Unit Tests**: Validators, Converters, business logic
- **Sub-System Tests**: Full API endpoints (GET, POST, PUT, DELETE)
- Use `FluentAssertions` for test assertions
- Use `NUnit` framework
- Embedded JSON files for test data (`.json` resources)

### Non-Functional Requirements (Global)

| Requirement | Target | Measurement |
|-------------|--------|-------------|
| **Backward Compatibility** | 100% | Existing v2 clients must work without changes |
| **Response Time (GET)** | < 200ms (p95) | Performance monitoring |
| **Response Time (POST/PUT)** | < 500ms (p95) | Performance monitoring |
| **Code Coverage** | > 80% | Unit + integration tests |
| **API Availability** | 99.9% | No downtime during deployment |
| **Database Migration** | < 5 minutes | Timed execution in prod |
| **Rollback Time** | < 10 minutes | If issues occur |

---

## Epic 1: Database Schema Changes

**Goal**: Add 15 new columns + 1 computed column to `TEmploymentDetail` table
**Duration**: 3 days
**Priority**: CRITICAL - Blocks all other work

### Task 1.1: Create Database Migration Scripts

#### Functional Requirements
- Add 4 classification columns: `EmploymentType`, `OccupationType`, `EmployedType`, `EmployedBasis`
- Add 1 flag column: `IsCurrentEmployment`
- Add 10 self-employed account columns: `PreviousShareOfCompanyProfit`, `PreviousGrossSalary`, `PreviousGrossDividend`, `PreviousIncludeInAffordability` (+ Second/Third variations)
- Add 1 computed column: `ContinuousEmploymentMonths` (persisted)
- Create filtered index: `IX_TEmploymentDetail_IsCurrentEmployment`

#### Non-Functional Requirements
- **Migration Time**: < 5 minutes on production database (~500K rows estimated)
- **Idempotent**: Script can be run multiple times safely
- **Transactional**: All-or-nothing execution
- **Backward Compatible**: Existing queries continue to work

#### Acceptance Criteria
```sql
-- Must create these columns
- [EmploymentType] varchar(50) NULL
- [OccupationType] varchar(50) NULL
- [EmployedType] varchar(20) NULL
- [EmployedBasis] varchar(50) NULL
- [IsCurrentEmployment] bit NULL
- [PreviousShareOfCompanyProfit] money NULL
- [PreviousGrossSalary] money NULL
- [PreviousGrossDividend] money NULL
- [PreviousIncludeInAffordability] bit NULL
- [SecondPreviousShareOfCompanyProfit] money NULL
- [SecondPreviousGrossSalary] money NULL
- [SecondPreviousGrossDividend] money NULL
- [ThirdPreviousShareOfCompanyProfit] money NULL
- [ThirdPreviousGrossSalary] money NULL
- [ThirdPreviousGrossDividend] money NULL
- [ContinuousEmploymentMonths] AS (DATEDIFF(...)) PERSISTED

-- Must create index
- IX_TEmploymentDetail_IsCurrentEmployment WHERE IsCurrentEmployment = 1
```

#### Pre-Conditions
- DBA approval obtained
- Database backup completed
- Script tested in DEV, TEST environments
- No table locks during business hours

#### Post-Conditions
- All 15 columns exist with correct data types
- Computed column calculates correctly
- Index created successfully
- Existing data integrity maintained (no data loss)
- Rollback script available and tested

#### Deliverables
1. `001_Add_Employment_Extension_Columns.sql` - Migration script
2. `002_Populate_IsCurrentEmployment.sql` - Data migration script
3. `999_Rollback_Employment_Extension.sql` - Rollback script

#### Testing
**Database Testing**:
```sql
-- Test 1: Verify columns exist
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TEmploymentDetail'
  AND COLUMN_NAME IN ('EmploymentType', 'IsCurrentEmployment', ...);

-- Test 2: Verify computed column calculates correctly
SELECT StartDate, EndDate, ContinuousEmploymentMonths
FROM TEmploymentDetail WHERE StartDate IS NOT NULL;

-- Test 3: Verify index exists
EXEC sp_helpindex 'TEmploymentDetail';

-- Test 4: Test rollback script (in DEV only)
-- Run rollback, verify columns removed
```

#### Estimated Effort
- Script creation: 0.5 day
- Testing in DEV/TEST: 0.5 day
- DBA review and approval: 1 day
- Execution in PROD: 0.5 day
- **Total**: 2.5 days

---

### Task 1.2: Update NHibernate Domain Entity Mapping

#### Functional Requirements
- Add 15 new properties to `Employment` domain entity (IntelliFlo.IO.Core.Domain.FactFind.EmploymentDetail)
- Add read-only property for `ContinuousEmploymentMonths`
- Update NHibernate mapping file (`.hbm.xml`) or fluent mapping
- Ensure all properties map to correct database columns

#### Non-Functional Requirements
- **Build Time**: No significant increase
- **Lazy Loading**: Configure appropriately for new fields
- **Backward Compatible**: Existing queries/entities work

#### Acceptance Criteria
```csharp
// Employment domain entity must have these properties
public class EmploymentDetail {
    // Classification fields
    public virtual string EmploymentType { get; set; }
    public virtual string OccupationType { get; set; }
    public virtual string EmployedType { get; set; }
    public virtual string EmployedBasis { get; set; }

    // Flag
    public virtual bool? IsCurrentEmployment { get; set; }

    // Self-employed accounts - Year 1
    public virtual decimal? PreviousShareOfCompanyProfit { get; set; }
    public virtual decimal? PreviousGrossSalary { get; set; }
    public virtual decimal? PreviousGrossDividend { get; set; }
    public virtual bool? PreviousIncludeInAffordability { get; set; }

    // Year 2 (similar)
    // Year 3 (similar)

    // Computed (read-only)
    public virtual int? ContinuousEmploymentMonths { get; private set; }
}
```

#### Pre-Conditions
- Task 1.1 completed (database columns exist in DEV)
- Domain entity class located: `Context/IntelligentOffice/src/IntelliFlo.IO.Core/Domain/FactFind/EmploymentDetail.cs`

#### Post-Conditions
- Domain entity compiles successfully
- NHibernate can read/write new properties
- No breaking changes to existing entity usage

#### Unit Tests
```csharp
[TestFixture]
public class EmploymentDetailMappingTests
{
    [Test]
    public void Should_Map_All_New_Properties_To_Database()
    {
        // Arrange
        var employment = new EmploymentDetail
        {
            EmploymentType = "Limited Company",
            IsCurrentEmployment = true,
            PreviousShareOfCompanyProfit = 50000m,
            // ... set all new properties
        };

        // Act
        using (var session = CreateSession())
        {
            session.Save(employment);
            session.Flush();
            session.Clear();

            var retrieved = session.Get<EmploymentDetail>(employment.Id);

            // Assert
            retrieved.EmploymentType.Should().Be("Limited Company");
            retrieved.IsCurrentEmployment.Should().BeTrue();
            retrieved.PreviousShareOfCompanyProfit.Should().Be(50000m);
        }
    }

    [Test]
    public void ContinuousEmploymentMonths_Should_Be_Calculated_By_Database()
    {
        // Arrange
        var employment = new EmploymentDetail
        {
            StartDate = DateTime.Today.AddYears(-2),
            EndDate = null
        };

        // Act
        using (var session = CreateSession())
        {
            session.Save(employment);
            session.Flush();
            session.Clear();

            var retrieved = session.Get<EmploymentDetail>(employment.Id);

            // Assert
            retrieved.ContinuousEmploymentMonths.Should().BeGreaterThan(23); // ~24 months
        }
    }
}
```

#### Estimated Effort
- Update domain entity: 0.5 day
- Update NHibernate mapping: 0.5 day
- Unit tests: 0.5 day
- **Total**: 1.5 days

---

## Epic 2: Employment Classification Fields

**Goal**: Add 4 enum classification fields + IsCurrentEmployment flag
**Duration**: 5 days
**Priority**: HIGH
**Dependencies**: Epic 1 complete

### Task 2.1: Create New Enum Types

#### Functional Requirements
- Create `EmploymentTypeValue` enum (7 values)
- Create `OccupationTypeValue` enum (6 values)
- Create `EmployedTypeValue` enum (2 values)
- Create `EmployedBasisValue` enum (5 values)
- Each enum must have `[StringValue("...")]` attribute for serialization
- Follow existing pattern from `EmploymentStatusValue` and `EmploymentBusinessTypeValue`

#### Non-Functional Requirements
- **Extensibility**: Easy to add new values in future
- **Serialization**: JSON serialization works correctly
- **Consistency**: Follow naming conventions from existing enums

#### Acceptance Criteria
```csharp
// File: Monolith.FactFind/v2/Contracts/EmploymentTypeValue.cs
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
    LimitedPartnership = 5,

    [StringValue("Company Director")]
    CompanyDirector = 6,

    [StringValue("20% Director")]
    TwentyPercentDirector = 7
}

// Similar for OccupationTypeValue, EmployedTypeValue, EmployedBasisValue
```

#### Pre-Conditions
- Review existing enum patterns in codebase
- Confirm enum values with business analysts

#### Post-Conditions
- All 4 enums compile successfully
- Enums follow codebase conventions
- StringValue attributes serialize correctly

#### Unit Tests
```csharp
[TestFixture]
public class EmploymentTypeValueTests
{
    [Test]
    public void Should_Serialize_To_String_Value()
    {
        // Act
        var result = EmploymentTypeValue.LimitedCompany.GetStringValue();

        // Assert
        result.Should().Be("Limited Company");
    }

    [Test]
    public void Should_Parse_From_String()
    {
        // Act
        var result = EnumHelper.FindEnum<EmploymentTypeValue>("Limited Company", true);

        // Assert
        result.Should().Be(EmploymentTypeValue.LimitedCompany);
    }

    [TestCase("Employed", EmploymentTypeValue.Employed)]
    [TestCase("Self-Employed", EmploymentTypeValue.SelfEmployed)]
    [TestCase("20% Director", EmploymentTypeValue.TwentyPercentDirector)]
    public void Should_Parse_All_Values_Correctly(string input, EmploymentTypeValue expected)
    {
        var result = EnumHelper.FindEnum<EmploymentTypeValue>(input, true);
        result.Should().Be(expected);
    }
}
```

#### Estimated Effort
- Create 4 enum types: 0.5 day
- Unit tests for enums: 0.5 day
- **Total**: 1 day

---

### Task 2.2: Extend EmploymentDocument Contract

#### Functional Requirements
- Add 5 new properties to `EmploymentDocument`:
  - `EmploymentTypeValue? EmploymentType`
  - `OccupationTypeValue? OccupationType`
  - `EmployedTypeValue? EmployedType`
  - `EmployedBasisValue? EmployedBasis`
  - `bool? IsCurrentEmployment`
- Add 1 computed read-only property:
  - `int? ContinuousEmploymentMonths` (with `[ReadOnly(true)]` attribute)
- All new properties optional (nullable)
- Add appropriate data annotations (`[AllowedVerbs]`, `[DefaultValue]`, `[ValidEnumValues]`)
- Add XML documentation comments

#### Non-Functional Requirements
- **Backward Compatibility**: Existing API consumers continue to work
- **Serialization**: JSON serialization/deserialization works correctly
- **Swagger**: New properties appear in Swagger documentation

#### Acceptance Criteria
```csharp
// File: Monolith.FactFind/v2/Contracts/EmploymentDocument.cs
public class EmploymentDocument : BaseEmploymentDocument
{
    // ... existing properties ...

    /// <summary>
    /// Employment Type classification. Used by Vision/Multiply integrations.
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [ValidEnumValues(typeof(EmploymentTypeValue))]
    [DefaultValue(null)]
    public EmploymentTypeValue? EmploymentType { get; set; }

    /// <summary>
    /// Occupation Type classification. Used for insurance/protection underwriting.
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [ValidEnumValues(typeof(OccupationTypeValue))]
    [DefaultValue(null)]
    public OccupationTypeValue? OccupationType { get; set; }

    /// <summary>
    /// Employment basis (Full Time or Part Time).
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [ValidEnumValues(typeof(EmployedTypeValue))]
    [DefaultValue(null)]
    public EmployedTypeValue? EmployedType { get; set; }

    /// <summary>
    /// Employment contract basis.
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [ValidEnumValues(typeof(EmployedBasisValue))]
    [DefaultValue(null)]
    public EmployedBasisValue? EmployedBasis { get; set; }

    /// <summary>
    /// Whether this is the current employment. Auto-derived from dates if not set.
    /// </summary>
    [AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
    [DefaultValue(null)]
    public bool? IsCurrentEmployment { get; set; }

    /// <summary>
    /// Continuous employment duration in months (calculated readonly).
    /// </summary>
    [ReadOnly(true)]
    public int? ContinuousEmploymentMonths { get; set; }
}

// Also update CreateEmploymentDocument and BaseEmploymentDocument
```

#### Pre-Conditions
- Task 2.1 completed (enums exist)
- Existing `EmploymentDocument` contract reviewed

#### Post-Conditions
- Contract compiles successfully
- New properties appear in Swagger UI
- JSON serialization works correctly
- Data annotations validated by framework

#### Unit Tests
```csharp
[TestFixture]
public class EmploymentDocumentTests
{
    [Test]
    public void Should_Serialize_New_Properties_To_Json()
    {
        // Arrange
        var document = new EmploymentDocument
        {
            Id = 123,
            EmploymentType = EmploymentTypeValue.LimitedCompany,
            OccupationType = OccupationTypeValue.Professional,
            EmployedType = EmployedTypeValue.FullTime,
            EmployedBasis = EmployedBasisValue.Permanent,
            IsCurrentEmployment = true,
            ContinuousEmploymentMonths = 24
        };

        // Act
        var json = JsonConvert.SerializeObject(document);
        var deserialized = JsonConvert.DeserializeObject<EmploymentDocument>(json);

        // Assert
        deserialized.EmploymentType.Should().Be(EmploymentTypeValue.LimitedCompany);
        deserialized.IsCurrentEmployment.Should().BeTrue();
        deserialized.ContinuousEmploymentMonths.Should().Be(24);
    }

    [Test]
    public void Should_Handle_Null_Values_For_New_Properties()
    {
        // Arrange
        var document = new EmploymentDocument
        {
            Id = 123,
            EmploymentType = null,
            IsCurrentEmployment = null
        };

        // Act
        var json = JsonConvert.SerializeObject(document);

        // Assert
        json.Should().Contain("\"employmentType\":null");
        json.Should().Contain("\"isCurrentEmployment\":null");
    }
}
```

#### Estimated Effort
- Extend contracts: 0.5 day
- Unit tests: 0.5 day
- **Total**: 1 day

---

### Task 2.3: Update EmploymentConverter

#### Functional Requirements
- Update `ToContract()` method to map new domain properties to contract
- Update `ToDomain()` method to map new contract properties to domain
- Implement auto-calculation logic for `IsCurrentEmployment` if not provided:
  ```
  IsCurrentEmployment = (EndDate IS NULL OR EndDate > Today)
  ```
- Handle enum conversions using `EnumHelper.FindEnum<T>()`
- Map `ContinuousEmploymentMonths` as read-only from domain

#### Non-Functional Requirements
- **Performance**: No significant overhead in conversion
- **Null Safety**: Handle null values gracefully
- **Consistency**: Follow existing converter patterns

#### Acceptance Criteria
```csharp
// File: Monolith.FactFind/v2/Resources/Converters/EmploymentConverter.cs
public class EmploymentConverter : IEmploymentConverter
{
    public EmploymentDocument ToContract(Employment entity)
    {
        // ... existing mappings ...

        var result = new EmploymentDocument
        {
            // Existing properties...

            // New properties
            EmploymentType = ParseEnum<EmploymentTypeValue>(entity.EmploymentType),
            OccupationType = ParseEnum<OccupationTypeValue>(entity.OccupationType),
            EmployedType = ParseEnum<EmployedTypeValue>(entity.EmployedType),
            EmployedBasis = ParseEnum<EmployedBasisValue>(entity.EmployedBasis),
            IsCurrentEmployment = entity.IsCurrentEmployment,
            ContinuousEmploymentMonths = entity.ContinuousEmploymentMonths // From computed column
        };

        return result;
    }

    public Employment ToDomain(Employment entity, BaseEmploymentDocument document)
    {
        // ... existing mappings ...

        // New properties
        entity.EmploymentType = document.EmploymentType?.ToString();
        entity.OccupationType = document.OccupationType?.ToString();
        entity.EmployedType = document.EmployedType?.ToString();
        entity.EmployedBasis = document.EmployedBasis?.ToString();

        // Auto-calculate IsCurrentEmployment if not provided
        entity.IsCurrentEmployment = document.IsCurrentEmployment
            ?? (entity.EndDate == null || entity.EndDate > DateTime.Today);

        return entity;
    }

    private T? ParseEnum<T>(string value) where T : struct, Enum
    {
        if (string.IsNullOrWhiteSpace(value)) return null;
        return EnumHelper.FindEnum<T>(value, ignoreCase: true);
    }
}
```

#### Pre-Conditions
- Task 2.2 completed (contract extended)
- Existing `EmploymentConverter` reviewed

#### Post-Conditions
- Converter compiles successfully
- All new properties map correctly bidirectionally
- Auto-calculation logic works for `IsCurrentEmployment`

#### Unit Tests
```csharp
[TestFixture]
public class EmploymentConverterTests
{
    private EmploymentConverter converter;

    [SetUp]
    public void SetUp()
    {
        converter = new EmploymentConverter(
            Mock.Of<ICountryProvider>(),
            Mock.Of<ICountyProvider>()
        );
    }

    [Test]
    public void ToContract_Should_Map_New_Classification_Fields()
    {
        // Arrange
        var entity = new Employment
        {
            Id = 123,
            EmploymentType = "Limited Company",
            OccupationType = "Professional",
            EmployedType = "Full Time",
            EmployedBasis = "Permanent",
            IsCurrentEmployment = true,
            ContinuousEmploymentMonths = 24
        };

        // Act
        var result = converter.ToContract(entity);

        // Assert
        result.EmploymentType.Should().Be(EmploymentTypeValue.LimitedCompany);
        result.OccupationType.Should().Be(OccupationTypeValue.Professional);
        result.EmployedType.Should().Be(EmployedTypeValue.FullTime);
        result.EmployedBasis.Should().Be(EmployedBasisValue.Permanent);
        result.IsCurrentEmployment.Should().BeTrue();
        result.ContinuousEmploymentMonths.Should().Be(24);
    }

    [Test]
    public void ToDomain_Should_Map_Enums_To_Strings()
    {
        // Arrange
        var document = new EmploymentDocument
        {
            EmploymentType = EmploymentTypeValue.SoleTrader,
            OccupationType = OccupationTypeValue.Manual,
            EmployedType = EmployedTypeValue.PartTime,
            EmployedBasis = EmployedBasisValue.Contract
        };
        var entity = new Employment();

        // Act
        var result = converter.ToDomain(entity, document);

        // Assert
        result.EmploymentType.Should().Be("SoleTrader");
        result.OccupationType.Should().Be("Manual");
        result.EmployedType.Should().Be("PartTime");
        result.EmployedBasis.Should().Be("Contract");
    }

    [Test]
    public void ToDomain_Should_Auto_Calculate_IsCurrentEmployment_When_Null()
    {
        // Arrange
        var document = new EmploymentDocument
        {
            IsCurrentEmployment = null, // Not provided
            EndsOn = null // No end date = current
        };
        var entity = new Employment { EndDate = null };

        // Act
        var result = converter.ToDomain(entity, document);

        // Assert
        result.IsCurrentEmployment.Should().BeTrue();
    }

    [TestCase(null, true, Description = "No end date = current")]
    [TestCase("2025-01-01", true, Description = "Future end date = current")]
    [TestCase("2023-01-01", false, Description = "Past end date = not current")]
    public void ToDomain_Should_Calculate_IsCurrentEmployment_Correctly(string endDate, bool expected)
    {
        // Arrange
        var document = new EmploymentDocument
        {
            IsCurrentEmployment = null,
            EndsOn = endDate != null ? DateTime.Parse(endDate) : (DateTime?)null
        };
        var entity = new Employment
        {
            EndDate = document.EndsOn
        };

        // Act
        var result = converter.ToDomain(entity, document);

        // Assert
        result.IsCurrentEmployment.Should().Be(expected);
    }

    [Test]
    public void Should_Handle_Null_Values_Gracefully()
    {
        // Arrange
        var entity = new Employment
        {
            EmploymentType = null,
            OccupationType = null
        };

        // Act
        var result = converter.ToContract(entity);

        // Assert
        result.EmploymentType.Should().BeNull();
        result.OccupationType.Should().BeNull();
    }
}
```

#### Estimated Effort
- Update converter: 1 day
- Unit tests: 1 day
- **Total**: 2 days

---

### Task 2.4: Update EmploymentValidator

#### Functional Requirements
- No new validation rules required for classification fields (all optional)
- Ensure existing validation still works
- Consider future enhancement: validate that certain enums are only valid for certain `EmploymentStatus` values (e.g., `EmployedType` only for `Employed` status)

#### Non-Functional Requirements
- **Performance**: No degradation in validation speed
- **Extensibility**: Easy to add rules later

#### Acceptance Criteria
```csharp
// File: Monolith.FactFind/v2/Resources/Validators/EmploymentValidator.cs
public class EmploymentValidator : IEmploymentValidator
{
    // Existing validation rules remain unchanged

    // Optional future enhancement:
    // private static readonly EmploymentStatusValue[] EmployedTypeStatuses =
    //     { EmploymentStatusValue.Employed, EmploymentStatusValue.MaternityLeave, ... };

    public void Validate(BaseEmploymentDocument employment, EmploymentStatusValue employmentStatus)
    {
        // ... existing validations ...

        // New validations (if any):
        // Currently, all new fields are optional, so no validation needed
        // This is intentional to maintain backward compatibility
    }
}
```

#### Pre-Conditions
- Existing validator reviewed and understood

#### Post-Conditions
- Validator compiles successfully
- All existing validations still work
- No breaking changes to validation behavior

#### Unit Tests
```csharp
[TestFixture]
public class EmploymentValidatorTests
{
    private EmploymentValidator validator;

    [SetUp]
    public void SetUp()
    {
        validator = new EmploymentValidator();
    }

    [Test]
    public void Should_Accept_New_Fields_As_Optional()
    {
        // Arrange
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatusValue.Employed,
            Employer = "Test Corp",
            EmploymentType = null, // Optional
            IsCurrentEmployment = null // Optional
        };

        // Act & Assert
        Assert.DoesNotThrow(() => validator.Validate(employment, EmploymentStatusValue.Employed));
    }

    [Test]
    public void Should_Accept_New_Fields_When_Provided()
    {
        // Arrange
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatusValue.Employed,
            Employer = "Test Corp",
            EmploymentType = EmploymentTypeValue.Employed,
            OccupationType = OccupationTypeValue.Professional,
            IsCurrentEmployment = true
        };

        // Act & Assert
        Assert.DoesNotThrow(() => validator.Validate(employment, EmploymentStatusValue.Employed));
    }
}
```

#### Estimated Effort
- Review and minor updates: 0.5 day
- Unit tests: 0.5 day
- **Total**: 1 day

---

## Epic 3: Self-Employed Financial Accounts

**Goal**: Add structured 3-year self-employed financial accounts data
**Duration**: 10 days
**Priority**: HIGH
**Dependencies**: Epic 1 complete

### Task 3.1: Create SelfEmployedAccountsValue Object

#### Functional Requirements
- Create `SelfEmployedAccountsValue` value object in `Contracts` folder
- Properties:
  - `int YearNumber` (1, 2, or 3) - **Required**
  - `DateTime? YearEndDate`
  - `decimal? GrossProfit`
  - `decimal? ShareOfCompanyProfit`
  - `decimal? GrossSalary`
  - `decimal? GrossDividend`
  - `bool? IncludeInAffordability`
- Add data annotations: `[Range(1, 3)]` on YearNumber, `[Required]` on YearNumber
- Add Swagger documentation attributes

#### Non-Functional Requirements
- **Serialization**: JSON serialization works correctly
- **Validation**: Data annotations enforced

#### Acceptance Criteria
```csharp
// File: Monolith.FactFind/v2/Contracts/SelfEmployedAccountsValue.cs
[SwaggerDefinition("SelfEmployedAccountsValue")]
public class SelfEmployedAccountsValue
{
    /// <summary>
    /// Account year number (1 = most recent, 2 = previous, 3 = two years prior).
    /// </summary>
    [Range(1, 3)]
    [Required]
    public int YearNumber { get; set; }

    /// <summary>
    /// Financial year end date.
    /// </summary>
    [JsonConverter(typeof(DateOnly))]
    public DateTime? YearEndDate { get; set; }

    /// <summary>
    /// Gross profit for sole trader/partnership.
    /// </summary>
    public decimal? GrossProfit { get; set; }

    /// <summary>
    /// Share of company profit (for PLC/Ltd companies).
    /// </summary>
    public decimal? ShareOfCompanyProfit { get; set; }

    /// <summary>
    /// Gross salary (for PLC/Ltd company directors).
    /// </summary>
    public decimal? GrossSalary { get; set; }

    /// <summary>
    /// Gross dividend (for PLC/Ltd shareholders).
    /// </summary>
    public decimal? GrossDividend { get; set; }

    /// <summary>
    /// Include this year in mortgage affordability calculation.
    /// </summary>
    public bool? IncludeInAffordability { get; set; }
}
```

#### Pre-Conditions
- Review existing value objects in codebase (e.g., `EmploymentAddressValue`)

#### Post-Conditions
- Value object compiles successfully
- Can be serialized/deserialized
- Swagger definition generated

#### Unit Tests
```csharp
[TestFixture]
public class SelfEmployedAccountsValueTests
{
    [Test]
    public void Should_Serialize_To_Json()
    {
        // Arrange
        var account = new SelfEmployedAccountsValue
        {
            YearNumber = 1,
            YearEndDate = new DateTime(2024, 3, 31),
            GrossProfit = 120000m,
            ShareOfCompanyProfit = 120000m,
            GrossSalary = 12000m,
            GrossDividend = 40000m,
            IncludeInAffordability = true
        };

        // Act
        var json = JsonConvert.SerializeObject(account);
        var deserialized = JsonConvert.DeserializeObject<SelfEmployedAccountsValue>(json);

        // Assert
        deserialized.YearNumber.Should().Be(1);
        deserialized.GrossProfit.Should().Be(120000m);
    }

    [Test]
    public void Should_Validate_YearNumber_Range()
    {
        // Arrange
        var account = new SelfEmployedAccountsValue { YearNumber = 5 }; // Invalid

        // Act
        var validationResults = DataAnnotationsValidator.Validate(account);

        // Assert
        validationResults.Should().ContainSingle(v => v.MemberNames.Contains("YearNumber"));
    }
}
```

#### Estimated Effort
- Create value object: 0.5 day
- Unit tests: 0.5 day
- **Total**: 1 day

---

### Task 3.2: Add SelfEmployedAccounts Array Property to Contract

#### Functional Requirements
- Add `SelfEmployedAccountsValue[] SelfEmployedAccounts` property to `EmploymentDocument`
- Add to `BaseEmploymentDocument` (so available in Create and Update)
- Property is optional (nullable array)
- Add data annotations: `[AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]`
- Add XML documentation

#### Non-Functional Requirements
- **Backward Compatibility**: Must not break existing consumers
- **Serialization**: Empty array vs null handled correctly

#### Acceptance Criteria
```csharp
// In EmploymentDocument
/// <summary>
/// Self-employed financial accounts data (up to 3 years).
/// Only applicable when EmploymentStatus = SelfEmployed, CompanyDirector
/// or EmploymentBusinessType is set.
/// </summary>
[AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]
[DefaultValue(null)]
public SelfEmployedAccountsValue[] SelfEmployedAccounts { get; set; }
```

#### Pre-Conditions
- Task 3.1 completed (value object exists)

#### Post-Conditions
- Contract compiles successfully
- Swagger shows array of objects
- Can POST/PUT with array

#### Unit Tests
```csharp
[TestFixture]
public class EmploymentDocumentWithAccountsTests
{
    [Test]
    public void Should_Serialize_With_Accounts_Array()
    {
        // Arrange
        var document = new EmploymentDocument
        {
            Id = 123,
            SelfEmployedAccounts = new[]
            {
                new SelfEmployedAccountsValue { YearNumber = 1, GrossProfit = 100000m },
                new SelfEmployedAccountsValue { YearNumber = 2, GrossProfit = 90000m },
                new SelfEmployedAccountsValue { YearNumber = 3, GrossProfit = 80000m }
            }
        };

        // Act
        var json = JsonConvert.SerializeObject(document);
        var deserialized = JsonConvert.DeserializeObject<EmploymentDocument>(json);

        // Assert
        deserialized.SelfEmployedAccounts.Should().HaveCount(3);
        deserialized.SelfEmployedAccounts[0].GrossProfit.Should().Be(100000m);
    }

    [Test]
    public void Should_Handle_Null_Accounts_Array()
    {
        // Arrange
        var document = new EmploymentDocument
        {
            Id = 123,
            SelfEmployedAccounts = null
        };

        // Act
        var json = JsonConvert.SerializeObject(document);

        // Assert
        json.Should().Contain("\"selfEmployedAccounts\":null");
    }
}
```

#### Estimated Effort
- Add property: 0.5 day
- Unit tests: 0.5 day
- **Total**: 1 day

---

### Task 3.3: Implement Converter Mapping for Self-Employed Accounts

#### Functional Requirements
- **ToContract (Domain → API)**: Read flat DB columns, construct array
  - Year 1: PreviousFinancialYear, PreviousShareOfCompanyProfit, etc. → SelfEmployedAccounts[0]
  - Year 2: SecondPreviousFinancialYear, etc. → SelfEmployedAccounts[1]
  - Year 3: ThirdPreviousFinancialYear, etc. → SelfEmployedAccounts[2]
  - Only include years with data (GrossProfit is not null)
  - Sort by YearNumber ascending

- **ToDomain (API → Domain)**: Flatten array to DB columns
  - Find YearNumber=1 → Map to Previous* columns
  - Find YearNumber=2 → Map to SecondPrevious* columns
  - Find YearNumber=3 → Map to ThirdPrevious* columns
  - If year not in array, set columns to null

#### Non-Functional Requirements
- **Performance**: Efficient mapping (no unnecessary loops)
- **Null Safety**: Handle null arrays, missing years
- **Validation**: Defer validation to validator (converter just maps)

#### Acceptance Criteria
```csharp
// In EmploymentConverter.cs
public EmploymentDocument ToContract(Employment entity)
{
    // ... existing mappings ...

    var result = new EmploymentDocument
    {
        // ... existing properties ...

        SelfEmployedAccounts = BuildSelfEmployedAccountsArray(entity)
    };

    return result;
}

private SelfEmployedAccountsValue[] BuildSelfEmployedAccountsArray(Employment entity)
{
    var accounts = new List<SelfEmployedAccountsValue>();

    // Year 1 (Most Recent)
    if (entity.PreviousFinancialYear.HasValue)
    {
        accounts.Add(new SelfEmployedAccountsValue
        {
            YearNumber = 1,
            YearEndDate = entity.PreviousFinancialYearEndDate,
            GrossProfit = entity.PreviousFinancialYear,
            ShareOfCompanyProfit = entity.PreviousShareOfCompanyProfit,
            GrossSalary = entity.PreviousGrossSalary,
            GrossDividend = entity.PreviousGrossDividend,
            IncludeInAffordability = entity.PreviousIncludeInAffordability
        });
    }

    // Year 2
    if (entity.SecondPreviousFinancialYear.HasValue)
    {
        accounts.Add(new SelfEmployedAccountsValue
        {
            YearNumber = 2,
            YearEndDate = entity.SecondPreviousFinancialYearEndDate,
            GrossProfit = entity.SecondPreviousFinancialYear,
            ShareOfCompanyProfit = entity.SecondPreviousShareOfCompanyProfit,
            GrossSalary = entity.SecondPreviousGrossSalary,
            GrossDividend = entity.SecondPreviousGrossDividend,
            IncludeInAffordability = null // No column for Year 2
        });
    }

    // Year 3
    if (entity.ThirdPreviousFinancialYear.HasValue)
    {
        accounts.Add(new SelfEmployedAccountsValue
        {
            YearNumber = 3,
            YearEndDate = entity.ThirdPreviousFinancialYearEndDate,
            GrossProfit = entity.ThirdPreviousFinancialYear,
            ShareOfCompanyProfit = entity.ThirdPreviousShareOfCompanyProfit,
            GrossSalary = entity.ThirdPreviousGrossSalary,
            GrossDividend = entity.ThirdPreviousGrossDividend,
            IncludeInAffordability = null // No column for Year 3
        });
    }

    return accounts.Any() ? accounts.ToArray() : null;
}

public Employment ToDomain(Employment entity, BaseEmploymentDocument document)
{
    // ... existing mappings ...

    MapSelfEmployedAccountsToEntity(entity, document.SelfEmployedAccounts);

    return entity;
}

private void MapSelfEmployedAccountsToEntity(Employment entity, SelfEmployedAccountsValue[] accounts)
{
    if (accounts == null || accounts.Length == 0)
    {
        // Clear all self-employed account fields
        ClearSelfEmployedAccountFields(entity);
        return;
    }

    // Year 1
    var year1 = accounts.FirstOrDefault(a => a.YearNumber == 1);
    if (year1 != null)
    {
        entity.PreviousFinancialYear = year1.GrossProfit;
        entity.PreviousFinancialYearEndDate = year1.YearEndDate;
        entity.PreviousShareOfCompanyProfit = year1.ShareOfCompanyProfit;
        entity.PreviousGrossSalary = year1.GrossSalary;
        entity.PreviousGrossDividend = year1.GrossDividend;
        entity.PreviousIncludeInAffordability = year1.IncludeInAffordability;
    }
    else
    {
        ClearYear1Fields(entity);
    }

    // Year 2 (similar)
    // Year 3 (similar)
}
```

#### Pre-Conditions
- Task 3.2 completed (contract has array property)
- Domain entity has all required columns

#### Post-Conditions
- Array correctly constructed from DB columns
- Array correctly flattened to DB columns
- Null/empty arrays handled

#### Unit Tests
```csharp
[TestFixture]
public class EmploymentConverterSelfEmployedAccountsTests
{
    private EmploymentConverter converter;

    [Test]
    public void ToContract_Should_Build_Array_From_Domain_Fields()
    {
        // Arrange
        var entity = new Employment
        {
            PreviousFinancialYear = 100000m,
            PreviousFinancialYearEndDate = new DateTime(2024, 3, 31),
            PreviousShareOfCompanyProfit = 100000m,
            PreviousGrossSalary = 12000m,
            PreviousGrossDividend = 30000m,
            PreviousIncludeInAffordability = true,

            SecondPreviousFinancialYear = 90000m,
            SecondPreviousFinancialYearEndDate = new DateTime(2023, 3, 31),
            SecondPreviousShareOfCompanyProfit = 90000m,
            SecondPreviousGrossSalary = 11000m,
            SecondPreviousGrossDividend = 28000m,

            ThirdPreviousFinancialYear = 80000m,
            ThirdPreviousFinancialYearEndDate = new DateTime(2022, 3, 31),
            ThirdPreviousShareOfCompanyProfit = 80000m,
            ThirdPreviousGrossSalary = 10000m,
            ThirdPreviousGrossDividend = 25000m
        };

        // Act
        var result = converter.ToContract(entity);

        // Assert
        result.SelfEmployedAccounts.Should().HaveCount(3);

        var year1 = result.SelfEmployedAccounts.First(a => a.YearNumber == 1);
        year1.GrossProfit.Should().Be(100000m);
        year1.ShareOfCompanyProfit.Should().Be(100000m);
        year1.GrossSalary.Should().Be(12000m);
        year1.GrossDividend.Should().Be(30000m);
        year1.IncludeInAffordability.Should().BeTrue();

        result.SelfEmployedAccounts[1].YearNumber.Should().Be(2);
        result.SelfEmployedAccounts[2].YearNumber.Should().Be(3);
    }

    [Test]
    public void ToContract_Should_Return_Null_When_No_Accounts_Data()
    {
        // Arrange
        var entity = new Employment
        {
            PreviousFinancialYear = null,
            SecondPreviousFinancialYear = null,
            ThirdPreviousFinancialYear = null
        };

        // Act
        var result = converter.ToContract(entity);

        // Assert
        result.SelfEmployedAccounts.Should().BeNull();
    }

    [Test]
    public void ToContract_Should_Include_Only_Years_With_Data()
    {
        // Arrange
        var entity = new Employment
        {
            PreviousFinancialYear = 100000m,
            SecondPreviousFinancialYear = null, // Year 2 missing
            ThirdPreviousFinancialYear = 80000m
        };

        // Act
        var result = converter.ToContract(entity);

        // Assert
        result.SelfEmployedAccounts.Should().HaveCount(2);
        result.SelfEmployedAccounts.Select(a => a.YearNumber).Should().BeEquivalentTo(new[] { 1, 3 });
    }

    [Test]
    public void ToDomain_Should_Flatten_Array_To_Domain_Fields()
    {
        // Arrange
        var document = new EmploymentDocument
        {
            SelfEmployedAccounts = new[]
            {
                new SelfEmployedAccountsValue
                {
                    YearNumber = 1,
                    YearEndDate = new DateTime(2024, 3, 31),
                    GrossProfit = 100000m,
                    ShareOfCompanyProfit = 100000m,
                    GrossSalary = 12000m,
                    GrossDividend = 30000m,
                    IncludeInAffordability = true
                },
                new SelfEmployedAccountsValue
                {
                    YearNumber = 2,
                    GrossProfit = 90000m
                }
            }
        };
        var entity = new Employment();

        // Act
        var result = converter.ToDomain(entity, document);

        // Assert
        result.PreviousFinancialYear.Should().Be(100000m);
        result.PreviousShareOfCompanyProfit.Should().Be(100000m);
        result.PreviousGrossSalary.Should().Be(12000m);
        result.PreviousGrossDividend.Should().Be(30000m);
        result.PreviousIncludeInAffordability.Should().BeTrue();

        result.SecondPreviousFinancialYear.Should().Be(90000m);

        // Year 3 should be null (not in array)
        result.ThirdPreviousFinancialYear.Should().BeNull();
    }

    [Test]
    public void ToDomain_Should_Clear_Fields_When_Array_Is_Null()
    {
        // Arrange
        var document = new EmploymentDocument
        {
            SelfEmployedAccounts = null
        };
        var entity = new Employment
        {
            // Pre-existing data
            PreviousFinancialYear = 100000m,
            SecondPreviousFinancialYear = 90000m
        };

        // Act
        var result = converter.ToDomain(entity, document);

        // Assert
        result.PreviousFinancialYear.Should().BeNull();
        result.SecondPreviousFinancialYear.Should().BeNull();
    }

    [Test]
    public void Should_Handle_Out_Of_Order_Year_Numbers()
    {
        // Arrange
        var document = new EmploymentDocument
        {
            SelfEmployedAccounts = new[]
            {
                new SelfEmployedAccountsValue { YearNumber = 3, GrossProfit = 80000m },
                new SelfEmployedAccountsValue { YearNumber = 1, GrossProfit = 100000m },
                new SelfEmployedAccountsValue { YearNumber = 2, GrossProfit = 90000m }
            }
        };
        var entity = new Employment();

        // Act
        var result = converter.ToDomain(entity, document);

        // Assert
        result.PreviousFinancialYear.Should().Be(100000m);
        result.SecondPreviousFinancialYear.Should().Be(90000m);
        result.ThirdPreviousFinancialYear.Should().Be(80000m);
    }
}
```

#### Estimated Effort
- Implement mapping logic: 2 days
- Unit tests: 2 days
- **Total**: 4 days

---

### Task 3.4: Add Validation Rules for Self-Employed Accounts

#### Functional Requirements
- Validate max 3 accounts in array
- Validate unique year numbers (no duplicates)
- Validate year numbers are 1, 2, or 3 only (covered by data annotation)
- Validate accounts are only provided for self-employed statuses:
  - `EmploymentStatusValue.SelfEmployed`
  - `EmploymentStatusValue.CompanyDirector`
- Provide clear error messages

#### Non-Functional Requirements
- **Performance**: Validation should be fast (< 10ms)
- **User Experience**: Clear, actionable error messages

#### Acceptance Criteria
```csharp
// In EmploymentValidator.cs
public void Validate(BaseEmploymentDocument employment, EmploymentStatusValue employmentStatus)
{
    // ... existing validations ...

    // Self-employed accounts validation
    if (employment.SelfEmployedAccounts != null && employment.SelfEmployedAccounts.Length > 0)
    {
        ValidateSelfEmployedAccounts(employment.SelfEmployedAccounts, employmentStatus);
    }
}

private void ValidateSelfEmployedAccounts(SelfEmployedAccountsValue[] accounts, EmploymentStatusValue status)
{
    // Max 3 years
    Check.IsTrue(accounts.Length <= 3,
        "SelfEmployedAccounts can contain at most 3 years of data");

    // Unique year numbers
    var yearNumbers = accounts.Select(a => a.YearNumber).ToList();
    Check.IsTrue(yearNumbers.Count == yearNumbers.Distinct().Count(),
        "SelfEmployedAccounts must have unique year numbers (no duplicates)");

    // Only for self-employed statuses
    var allowedStatuses = new[] { EmploymentStatusValue.SelfEmployed, EmploymentStatusValue.CompanyDirector };
    Check.IsTrue(allowedStatuses.Contains(status),
        $"SelfEmployedAccounts can only be supplied for statuses: {string.Join(", ", allowedStatuses)}");
}
```

#### Pre-Conditions
- Task 3.3 completed (converter mapping done)

#### Post-Conditions
- Validation rules enforced
- Clear error messages returned

#### Unit Tests
```csharp
[TestFixture]
public class EmploymentValidatorSelfEmployedAccountsTests
{
    private EmploymentValidator validator;

    [SetUp]
    public void SetUp()
    {
        validator = new EmploymentValidator();
    }

    [Test]
    public void Should_Accept_Valid_Self_Employed_Accounts()
    {
        // Arrange
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatusValue.SelfEmployed,
            SelfEmployedAccounts = new[]
            {
                new SelfEmployedAccountsValue { YearNumber = 1, GrossProfit = 100000m },
                new SelfEmployedAccountsValue { YearNumber = 2, GrossProfit = 90000m },
                new SelfEmployedAccountsValue { YearNumber = 3, GrossProfit = 80000m }
            }
        };

        // Act & Assert
        Assert.DoesNotThrow(() => validator.Validate(employment, EmploymentStatusValue.SelfEmployed));
    }

    [Test]
    public void Should_Reject_More_Than_3_Years()
    {
        // Arrange
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatusValue.SelfEmployed,
            SelfEmployedAccounts = new[]
            {
                new SelfEmployedAccountsValue { YearNumber = 1 },
                new SelfEmployedAccountsValue { YearNumber = 2 },
                new SelfEmployedAccountsValue { YearNumber = 3 },
                new SelfEmployedAccountsValue { YearNumber = 4 } // Invalid
            }
        };

        // Act & Assert
        var ex = Assert.Throws<ValidationException>(() =>
            validator.Validate(employment, EmploymentStatusValue.SelfEmployed));
        ex.Message.Should().Contain("at most 3 years");
    }

    [Test]
    public void Should_Reject_Duplicate_Year_Numbers()
    {
        // Arrange
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatusValue.SelfEmployed,
            SelfEmployedAccounts = new[]
            {
                new SelfEmployedAccountsValue { YearNumber = 1, GrossProfit = 100000m },
                new SelfEmployedAccountsValue { YearNumber = 1, GrossProfit = 90000m } // Duplicate
            }
        };

        // Act & Assert
        var ex = Assert.Throws<ValidationException>(() =>
            validator.Validate(employment, EmploymentStatusValue.SelfEmployed));
        ex.Message.Should().Contain("unique year numbers");
    }

    [Test]
    public void Should_Reject_Accounts_For_Employed_Status()
    {
        // Arrange
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatusValue.Employed, // Not self-employed
            SelfEmployedAccounts = new[]
            {
                new SelfEmployedAccountsValue { YearNumber = 1, GrossProfit = 100000m }
            }
        };

        // Act & Assert
        var ex = Assert.Throws<ValidationException>(() =>
            validator.Validate(employment, EmploymentStatusValue.Employed));
        ex.Message.Should().Contain("can only be supplied for statuses");
    }

    [Test]
    public void Should_Accept_Accounts_For_Company_Director()
    {
        // Arrange
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatusValue.CompanyDirector,
            SelfEmployedAccounts = new[]
            {
                new SelfEmployedAccountsValue { YearNumber = 1, GrossProfit = 100000m }
            }
        };

        // Act & Assert
        Assert.DoesNotThrow(() => validator.Validate(employment, EmploymentStatusValue.CompanyDirector));
    }

    [Test]
    public void Should_Accept_Null_Accounts()
    {
        // Arrange
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatusValue.Employed,
            SelfEmployedAccounts = null
        };

        // Act & Assert
        Assert.DoesNotThrow(() => validator.Validate(employment, EmploymentStatusValue.Employed));
    }
}
```

#### Sub-System Tests
```csharp
[TestFixture]
public class EmploymentSelfEmployedAccountsApiTests
{
    [Test]
    public void POST_Should_Reject_More_Than_3_Years()
    {
        // Arrange
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatus.SelfEmployed.ToString(),
            Employer = "Test Ltd",
            SelfEmployedAccounts = new[]
            {
                new SelfEmployedAccountsValue { YearNumber = 1 },
                new SelfEmployedAccountsValue { YearNumber = 2 },
                new SelfEmployedAccountsValue { YearNumber = 3 },
                new SelfEmployedAccountsValue { YearNumber = 4 }
            }
        };

        // Act
        var response = ApiTestsUtils.PostAndExpectError(token, url, employment, HttpStatusCode.BadRequest);

        // Assert
        response.Should().Contain("at most 3 years");
    }

    [Test]
    public void POST_Should_Reject_Duplicate_Years()
    {
        // Arrange
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatus.SelfEmployed.ToString(),
            Employer = "Test Ltd",
            SelfEmployedAccounts = new[]
            {
                new SelfEmployedAccountsValue { YearNumber = 1, GrossProfit = 100000 },
                new SelfEmployedAccountsValue { YearNumber = 1, GrossProfit = 90000 }
            }
        };

        // Act
        var response = ApiTestsUtils.PostAndExpectError(token, url, employment, HttpStatusCode.BadRequest);

        // Assert
        response.Should().Contain("unique year numbers");
    }
}
```

#### Estimated Effort
- Implement validation: 1 day
- Unit tests: 1 day
- Sub-system tests: 1 day
- **Total**: 3 days

---

### Task 3.5: Integration Testing for Self-Employed Accounts

#### Functional Requirements
- End-to-end tests for POST with self-employed accounts
- End-to-end tests for PUT with self-employed accounts
- End-to-end tests for GET with self-employed accounts
- Test data persistence and retrieval

#### Non-Functional Requirements
- **Coverage**: All CRUD operations covered
- **Data Integrity**: Round-trip tests (POST → GET → PUT → GET)

#### Acceptance Criteria
Create sub-system tests covering all scenarios

#### Sub-System Tests
```csharp
[TestFixture]
public class EmploymentSelfEmployedAccountsCRUDTests : ApiTestBase
{
    private TestUser factFindUser;
    private string token;
    private const int ClientId = 12345;
    private string url = $"/v2/clients/{ClientId}/employments";

    [Test]
    public void Should_Create_Employment_With_3_Years_Of_Accounts()
    {
        // Arrange
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatus.SelfEmployed.ToString(),
            EmploymentBusinessType = EmploymentBusinessType.PrivateLimitedCompany.ToString(),
            Employer = "Smith Consulting Ltd",
            Occupation = "Management Consultant",
            StartsOn = "2018-04-01",
            SelfEmployedAccounts = new[]
            {
                new SelfEmployedAccountsValue
                {
                    YearNumber = 1,
                    YearEndDate = "2024-03-31",
                    GrossProfit = 120000,
                    ShareOfCompanyProfit = 120000,
                    GrossSalary = 12000,
                    GrossDividend = 40000,
                    IncludeInAffordability = true
                },
                new SelfEmployedAccountsValue
                {
                    YearNumber = 2,
                    YearEndDate = "2023-03-31",
                    GrossProfit = 110000,
                    ShareOfCompanyProfit = 110000,
                    GrossSalary = 12000,
                    GrossDividend = 38000
                },
                new SelfEmployedAccountsValue
                {
                    YearNumber = 3,
                    YearEndDate = "2022-03-31",
                    GrossProfit = 95000,
                    ShareOfCompanyProfit = 95000,
                    GrossSalary = 12000,
                    GrossDividend = 30000
                }
            }
        };

        // Act
        var response = ApiTestsUtils.Post<EmploymentDocument>(token, url, employment);

        // Assert
        response.Should().NotBeNull();
        response.Id.Should().BeGreaterThan(0);
        response.SelfEmployedAccounts.Should().HaveCount(3);

        var year1 = response.SelfEmployedAccounts.First(a => a.YearNumber == 1);
        year1.GrossProfit.Should().Be(120000);
        year1.ShareOfCompanyProfit.Should().Be(120000);
        year1.GrossSalary.Should().Be(12000);
        year1.GrossDividend.Should().Be(40000);
        year1.IncludeInAffordability.Should().BeTrue();
    }

    [Test]
    public void Should_Retrieve_Employment_With_Accounts()
    {
        // Arrange - Create employment first
        var created = CreateEmploymentWithAccounts();

        // Act
        var retrieved = ApiTestsUtils.Get<EmploymentDocument>(token, $"{url}/{created.Id}");

        // Assert
        retrieved.SelfEmployedAccounts.Should().HaveCount(3);
        retrieved.SelfEmployedAccounts.Should().BeEquivalentTo(created.SelfEmployedAccounts);
    }

    [Test]
    public void Should_Update_Employment_Accounts()
    {
        // Arrange
        var created = CreateEmploymentWithAccounts();
        created.SelfEmployedAccounts = new[]
        {
            // Update Year 1, remove Year 2 & 3
            new SelfEmployedAccountsValue
            {
                YearNumber = 1,
                GrossProfit = 150000 // Updated
            }
        };

        // Act
        var updated = ApiTestsUtils.Put<EmploymentDocument>(token, $"{url}/{created.Id}", created);

        // Assert
        updated.SelfEmployedAccounts.Should().HaveCount(1);
        updated.SelfEmployedAccounts[0].GrossProfit.Should().Be(150000);

        // Verify in database
        var retrieved = ApiTestsUtils.Get<EmploymentDocument>(token, $"{url}/{created.Id}");
        retrieved.SelfEmployedAccounts.Should().HaveCount(1);
    }

    [Test]
    public void Should_Clear_Accounts_When_Set_To_Null()
    {
        // Arrange
        var created = CreateEmploymentWithAccounts();
        created.SelfEmployedAccounts = null;

        // Act
        var updated = ApiTestsUtils.Put<EmploymentDocument>(token, $"{url}/{created.Id}", created);

        // Assert
        updated.SelfEmployedAccounts.Should().BeNull();

        // Verify in database
        var retrieved = ApiTestsUtils.Get<EmploymentDocument>(token, $"{url}/{created.Id}");
        retrieved.SelfEmployedAccounts.Should().BeNull();
    }

    [Test]
    public void Should_Handle_Partial_Year_Data()
    {
        // Arrange
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatus.SelfEmployed.ToString(),
            Employer = "Test Ltd",
            SelfEmployedAccounts = new[]
            {
                new SelfEmployedAccountsValue
                {
                    YearNumber = 1,
                    GrossProfit = 100000
                    // Other fields null
                }
            }
        };

        // Act
        var response = ApiTestsUtils.Post<EmploymentDocument>(token, url, employment);

        // Assert
        response.SelfEmployedAccounts[0].GrossProfit.Should().Be(100000);
        response.SelfEmployedAccounts[0].ShareOfCompanyProfit.Should().BeNull();
        response.SelfEmployedAccounts[0].GrossSalary.Should().BeNull();
    }
}
```

#### Estimated Effort
- Create sub-system tests: 2 days
- Debug and fix issues: 1 day
- **Total**: 3 days

---

## Epic 4: Testing, Documentation & Release

**Goal**: Comprehensive testing, documentation, and production deployment
**Duration**: 5 days
**Priority**: CRITICAL

### Task 4.1: Backward Compatibility Testing

#### Functional Requirements
- Verify existing v2 clients can POST/PUT/GET without new fields
- Verify new fields default to null
- Verify existing validations still work
- Verify no breaking changes in response format

#### Non-Functional Requirements
- **Compatibility**: 100% backward compatible

#### Acceptance Criteria
All existing integration tests pass without modification

#### Sub-System Tests
```csharp
[TestFixture]
public class BackwardCompatibilityTests
{
    [Test]
    public void Should_Accept_POST_Without_New_Fields()
    {
        // Arrange - Old v2 payload (no new fields)
        var employment = new EmploymentDocument
        {
            EmploymentStatus = EmploymentStatus.Employed.ToString(),
            Employer = "Test Corp",
            Occupation = "Developer",
            StartsOn = "2020-01-01",
            Address = new AddressValueDocument
            {
                Line1 = "123 Street",
                PostalCode = "SW1A 1AA",
                Country = new EmploymentCountryValue { IsoCode = "GB" }
            }
            // No EmploymentType, OccupationType, SelfEmployedAccounts, etc.
        };

        // Act
        var response = ApiTestsUtils.Post<EmploymentDocument>(token, url, employment);

        // Assert
        response.Should().NotBeNull();
        response.Id.Should().BeGreaterThan(0);
        response.EmploymentType.Should().BeNull();
        response.SelfEmployedAccounts.Should().BeNull();
    }

    [Test]
    public void Should_Return_New_Fields_As_Null_For_Old_Records()
    {
        // Arrange - Create with old API structure
        var employment = CreateOldStyleEmployment();

        // Act - Retrieve
        var retrieved = ApiTestsUtils.Get<EmploymentDocument>(token, $"{url}/{employment.Id}");

        // Assert
        retrieved.EmploymentType.Should().BeNull();
        retrieved.OccupationType.Should().BeNull();
        retrieved.IsCurrentEmployment.Should().NotBeNull(); // Auto-calculated
        retrieved.SelfEmployedAccounts.Should().BeNull();
    }

    [Test]
    public void Should_Preserve_Old_Data_When_Updating_Without_New_Fields()
    {
        // Arrange
        var employment = CreateOldStyleEmployment();
        employment.Employer = "Updated Corp";
        // Don't set new fields

        // Act
        var updated = ApiTestsUtils.Put<EmploymentDocument>(token, $"{url}/{employment.Id}", employment);

        // Assert
        updated.Employer.Should().Be("Updated Corp");
        updated.EmploymentType.Should().BeNull(); // Still null
    }
}
```

#### Estimated Effort
- Create compatibility tests: 1 day
- Run regression test suite: 0.5 day
- **Total**: 1.5 days

---

### Task 4.2: Performance Testing

#### Functional Requirements
- Measure GET response time with new fields
- Measure POST response time with full data
- Measure PUT response time
- Measure query performance with new index

#### Non-Functional Requirements
- **GET**: < 200ms (p95)
- **POST/PUT**: < 500ms (p95)
- **Database Query**: < 50ms

#### Acceptance Criteria
All performance targets met

#### Tests
```csharp
[TestFixture]
public class PerformanceTests
{
    [Test]
    public void GET_Should_Complete_Under_200ms()
    {
        // Arrange
        var employment = CreateFullEmploymentWithAllFields();
        var stopwatch = Stopwatch.StartNew();

        // Act
        for (int i = 0; i < 100; i++)
        {
            ApiTestsUtils.Get<EmploymentDocument>(token, $"{url}/{employment.Id}");
        }
        stopwatch.Stop();

        // Assert
        var avgTime = stopwatch.ElapsedMilliseconds / 100.0;
        avgTime.Should().BeLessThan(200, "Average GET time should be under 200ms");
    }

    [Test]
    public void POST_With_Full_Data_Should_Complete_Under_500ms()
    {
        // Arrange
        var employment = BuildFullEmploymentPayload();
        var stopwatch = Stopwatch.StartNew();

        // Act
        ApiTestsUtils.Post<EmploymentDocument>(token, url, employment);
        stopwatch.Stop();

        // Assert
        stopwatch.ElapsedMilliseconds.Should().BeLessThan(500, "POST should complete under 500ms");
    }
}
```

#### Estimated Effort
- Create performance tests: 1 day
- Analyze and optimize if needed: 1 day
- **Total**: 2 days

---

### Task 4.3: Update Swagger Documentation

#### Functional Requirements
- All new properties appear in Swagger UI
- Enums documented with values
- SelfEmployedAccountsValue schema visible
- Examples provided for new fields
- Descriptions accurate

#### Acceptance Criteria
- Swagger UI loads without errors
- New properties documented
- Examples work in "Try it out"

#### Deliverables
- Updated Swagger JSON
- Example requests with new fields

#### Estimated Effort
- Review and update: 0.5 day
- Create examples: 0.5 day
- **Total**: 1 day

---

### Task 4.4: Create Developer Documentation

#### Functional Requirements
- API usage guide for new fields
- Migration guide for API consumers
- Sample payloads (JSON)
- Error scenarios documented

#### Deliverables
1. `Employment_API_v2.1_Usage_Guide.md`
2. `Employment_API_Migration_Guide.md`
3. Sample JSON files

#### Estimated Effort
- Write documentation: 1 day

---

### Task 4.5: Production Deployment

#### Functional Requirements
- Execute database migration in PROD
- Deploy application
- Monitor for errors
- Rollback plan ready

#### Pre-Conditions
- All tests passing
- DBA approval
- Change management approval
- Rollback scripts tested
- Deployment window scheduled

#### Post-Conditions
- API operational
- No critical errors
- Performance metrics normal
- Consumers notified

#### Procedure
1. Database migration (5 min)
2. Application deployment (10 min)
3. Smoke tests (10 min)
4. Monitor for 1 hour
5. Sign-off

#### Estimated Effort
- Deployment execution: 0.5 day
- Post-deployment monitoring: 0.5 day
- **Total**: 1 day

---

## Dependencies & Risks

### Dependencies

| Dependency | Impact | Mitigation |
|------------|--------|------------|
| DBA availability | High - blocks database changes | Schedule early, provide lead time |
| NHibernate mapping expertise | Medium | Review existing patterns, consult team |
| Test environment availability | Medium | Reserve environments in advance |
| Production deployment window | High | Schedule during low-traffic period |

### Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Database migration takes longer than expected | Low | High | Test with production-scale data in staging |
| Breaking existing API consumers | Low | Critical | Extensive backward compatibility testing |
| Performance degradation | Low | High | Performance testing, indexes, query optimization |
| Complex converter bugs (array mapping) | Medium | Medium | Comprehensive unit tests, code review |
| Validation rules too restrictive | Low | Medium | Review with business analysts, flexible validation |
| Rollback needed | Low | High | Tested rollback scripts, deployment rollback procedure |

---

## Definition of Done

### Feature Level
- [ ] All code committed to feature branch
- [ ] Code review completed and approved
- [ ] All unit tests passing (>80% coverage)
- [ ] All sub-system tests passing
- [ ] Performance tests passing
- [ ] Backward compatibility verified
- [ ] Documentation updated
- [ ] Swagger documentation accurate

### Epic Level
- [ ] All tasks in epic completed
- [ ] Integration testing across epics completed
- [ ] No critical or high-severity bugs
- [ ] Code merged to main branch

### Release Level
- [ ] Database migration successful in PROD
- [ ] Application deployed to PROD
- [ ] Smoke tests passing in PROD
- [ ] No critical errors in monitoring (24 hours)
- [ ] API consumers notified
- [ ] Documentation published
- [ ] Release notes published
- [ ] Rollback plan verified
- [ ] Sign-off from stakeholders

---

## Summary Timeline

| Epic | Duration | Dependencies |
|------|----------|--------------|
| **Epic 1: Database Schema Changes** | 3 days | None |
| **Epic 2: Classification Fields** | 5 days | Epic 1 |
| **Epic 3: Self-Employed Accounts** | 10 days | Epic 1 |
| **Epic 4: Testing, Documentation & Release** | 5 days | Epic 2, 3 |
| **Total** | **23 days** (~5 weeks) | - |

### Critical Path
Epic 1 → Epic 3 → Epic 4

### Parallel Work Opportunities
- Epic 2 and Epic 3 can be developed in parallel after Epic 1 completes
- Documentation (Task 4.3, 4.4) can start while testing (Task 4.1, 4.2) is ongoing

---

**END OF DEVELOPMENT PLAN**
