# Task 1.2: Update NHibernate Domain Entity Mapping

**Epic**: Epic 1 - Database Schema Changes
**Task**: 1.2 - Update NHibernate Domain Entity and Mapping
**Status**: Implementation Guide
**Date**: 2026-01-27

---

## Overview

This document specifies the changes required to the `EmploymentDetail` domain entity and its NHibernate mapping file to support the 14 new columns added in migration script 001.

---

## Part 1: Domain Entity Changes

**File**: `IntelliFlo.IO.Core/Domain/FactFind/EmploymentDetail.cs`

### 1.1 Add Private Fields (after line 89)

Add the following private fields to the `#region Fields` section:

```csharp
// Classification Fields (API v2.1)
private string employmentType;
private string occupationType;
private string employedType;
private string employedBasis;

// Self-Employed Accounts - Previous Year (API v2.1)
private decimal? previousShareOfCompanyProfit;
private decimal? previousGrossSalary;
private decimal? previousGrossDividend;

// Self-Employed Accounts - Second Previous Year (API v2.1)
private decimal? secondPreviousShareOfCompanyProfit;
private decimal? secondPreviousGrossSalary;
private decimal? secondPreviousGrossDividend;

// Self-Employed Accounts - Third Previous Year (API v2.1)
private decimal? thirdPreviousShareOfCompanyProfit;
private decimal? thirdPreviousGrossSalary;
private decimal? thirdPreviousGrossDividend;

// Computed field - not mapped as property (handled by DB)
// IsCurrentEmployment - computed column in database
```

### 1.2 Add Public Virtual Properties

Add the following virtual properties after the existing properties (recommend placing after `ProbationPeriodMonths` property):

```csharp
#region API v2.1 - Classification Fields

/// <summary>
/// Type of employment (e.g., Permanent, Temporary, Contract)
/// </summary>
public virtual string EmploymentType
{
    get { return employmentType; }
    set { employmentType = value; }
}

/// <summary>
/// Type of occupation classification
/// </summary>
public virtual string OccupationType
{
    get { return occupationType; }
    set { occupationType = value; }
}

/// <summary>
/// Employment type classification (e.g., Full-Time, Part-Time)
/// </summary>
public virtual string EmployedType
{
    get { return employedType; }
    set { employedType = value; }
}

/// <summary>
/// Employment basis (e.g., Salaried, Hourly)
/// </summary>
public virtual string EmployedBasis
{
    get { return employedBasis; }
    set { employedBasis = value; }
}

#endregion

#region API v2.1 - Self-Employed Financial Accounts

// Previous Year (Year 1)
public virtual decimal? PreviousShareOfCompanyProfit
{
    get { return previousShareOfCompanyProfit; }
    set { previousShareOfCompanyProfit = value; }
}

public virtual decimal? PreviousGrossSalary
{
    get { return previousGrossSalary; }
    set { previousGrossSalary = value; }
}

public virtual decimal? PreviousGrossDividend
{
    get { return previousGrossDividend; }
    set { previousGrossDividend = value; }
}

// Second Previous Year (Year 2)
public virtual decimal? SecondPreviousShareOfCompanyProfit
{
    get { return secondPreviousShareOfCompanyProfit; }
    set { secondPreviousShareOfCompanyProfit = value; }
}

public virtual decimal? SecondPreviousGrossSalary
{
    get { return secondPreviousGrossSalary; }
    set { secondPreviousGrossSalary = value; }
}

public virtual decimal? SecondPreviousGrossDividend
{
    get { return secondPreviousGrossDividend; }
    set { secondPreviousGrossDividend = value; }
}

// Third Previous Year (Year 3)
public virtual decimal? ThirdPreviousShareOfCompanyProfit
{
    get { return thirdPreviousShareOfCompanyProfit; }
    set { thirdPreviousShareOfCompanyProfit = value; }
}

public virtual decimal? ThirdPreviousGrossSalary
{
    get { return thirdPreviousGrossSalary; }
    set { thirdPreviousGrossSalary = value; }
}

public virtual decimal? ThirdPreviousGrossDividend
{
    get { return thirdPreviousGrossDividend; }
    set { thirdPreviousGrossDividend = value; }
}

#endregion

#region API v2.1 - Computed Properties

/// <summary>
/// Computed property indicating if this is a current employment
/// Calculated by database: EndDate IS NULL OR EndDate >= GETDATE()
/// This property is read-only and computed by the database
/// </summary>
public virtual bool? IsCurrentEmployment { get; set; }

#endregion
```

---

## Part 2: NHibernate Mapping Changes

**File**: `IntelliFlo.IO.Repository.Hibernate/Mapping/FactFind/EmploymentDetail.hbm.xml`

### 2.1 Add Property Mappings

Add the following property mappings after line 62 (after `ThirdPreviousFinancialYearEndDate`):

```xml
<!-- API v2.1: Classification Fields -->
<property name="EmploymentType"/>
<property name="OccupationType"/>
<property name="EmployedType"/>
<property name="EmployedBasis"/>

<!-- API v2.1: Self-Employed Accounts - Previous Year -->
<property name="PreviousShareOfCompanyProfit"/>
<property name="PreviousGrossSalary"/>
<property name="PreviousGrossDividend"/>

<!-- API v2.1: Self-Employed Accounts - Second Previous Year -->
<property name="SecondPreviousShareOfCompanyProfit"/>
<property name="SecondPreviousGrossSalary"/>
<property name="SecondPreviousGrossDividend"/>

<!-- API v2.1: Self-Employed Accounts - Third Previous Year -->
<property name="ThirdPreviousShareOfCompanyProfit"/>
<property name="ThirdPreviousGrossSalary"/>
<property name="ThirdPreviousGrossDividend"/>

<!-- API v2.1: Computed Column (read-only) -->
<property name="IsCurrentEmployment" insert="false" update="false"/>
```

**Important Notes**:
- The `IsCurrentEmployment` property uses `insert="false" update="false"` because it's a computed column in the database
- The property is mapped to allow reading the value, but NHibernate won't attempt to write to it
- All other properties use default mapping behavior (camelcase field access)

### 2.2 Optional: Update CustomUpdateSpecificFields SQL Query

If the `CustomUpdateSpecificFields` named query is used to update employment records, you may need to add the new fields to the UPDATE statement (lines 84-112). However, this depends on business requirements:

- **Classification fields** should likely be updateable
- **Self-employed accounts** should likely be updateable
- **IsCurrentEmployment** should NOT be included (it's computed)

Example addition after line 109:

```xml
EmploymentType = :employmentType,
OccupationType = :occupationType,
EmployedType = :employedType,
EmployedBasis = :employedBasis,
PreviousShareOfCompanyProfit = :previousShareOfCompanyProfit,
PreviousGrossSalary = :previousGrossSalary,
PreviousGrossDividend = :previousGrossDividend,
SecondPreviousShareOfCompanyProfit = :secondPreviousShareOfCompanyProfit,
SecondPreviousGrossSalary = :secondPreviousGrossSalary,
SecondPreviousGrossDividend = :secondPreviousGrossDividend,
ThirdPreviousShareOfCompanyProfit = :thirdPreviousShareOfCompanyProfit,
ThirdPreviousGrossSalary = :thirdPreviousGrossSalary,
ThirdPreviousGrossDividend = :thirdPreviousGrossDividend,
```

---

## Testing Checklist

After implementing these changes:

- [ ] Compile the solution - verify no compilation errors
- [ ] Run NHibernate schema validation tests
- [ ] Verify that existing employment records can be loaded without errors
- [ ] Create a new employment record and verify new fields are NULL by default
- [ ] Update an employment record with new field values and verify persistence
- [ ] Verify that `IsCurrentEmployment` is read-only and reflects the computed column value
- [ ] Run all existing EmploymentDetail unit tests
- [ ] Run all existing EmploymentDetail integration tests

---

## Pre-Conditions

- Migration script `001_Add_Employment_Classification_And_SelfEmployed_Accounts.sql` must be executed successfully
- Database must have all 14 new columns present in TEmploymentDetail table

## Post-Conditions

- `EmploymentDetail` domain entity has 14 new properties
- NHibernate can successfully map all new properties
- Computed column `IsCurrentEmployment` is readable but not writable
- All existing tests pass
- No breaking changes to existing functionality

---

## Rollback Procedure

If these changes need to be rolled back:

1. Revert changes to `EmploymentDetail.cs` (remove added fields and properties)
2. Revert changes to `EmploymentDetail.hbm.xml` (remove added property mappings)
3. Execute rollback script: `001_Rollback_Employment_Classification_And_SelfEmployed_Accounts.sql`
4. Rebuild solution and verify all tests pass

---

## Related Files

- Migration Script: `Requirements/Employment/001_Add_Employment_Classification_And_SelfEmployed_Accounts.sql`
- Rollback Script: `Requirements/Employment/001_Rollback_Employment_Classification_And_SelfEmployed_Accounts.sql`
- Development Plan: `Requirements/Employment/Development_Plan.md` (Task 1.2)
- Analysis Document: `Requirements/Employment/Employment_API_Analysis.md`
