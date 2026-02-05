# FactFind Resource-Centric CRUD API Design Specification

## Overview

This specification defines a comprehensive resource-centric CRUD API design for the FactFind system, transforming the existing screen-based legacy controllers into modern RESTful APIs following Intelliflo's API Design Guidelines 2.0.

## Executive Summary

The current FactFind system uses screen-based controllers that map directly to UI screens. This specification proposes a resource-centric API design that:

1. **Transforms screen-based operations into resource-centric CRUD APIs**
2. **Follows REST architectural principles and Intelliflo API Design Guidelines 2.0**
3. **Provides consistent patterns across all FactFind data entities**
4. **Enables better client integration and data management**
5. **Supports modern development practices with comprehensive testing**

## Current State Analysis

### Legacy Controller Structure

The existing FactFind system consists of several screen-based controllers:

- **ClientFactFindController** - Main orchestration and navigation
- **ProfileController** - Personal details, contact details, dependants, ID verification
- **EmploymentController** - Employment details and tax information  
- **AssetsAndLiabilitiesController** - Assets and liabilities management
- **BudgetController** - Income, expenditure, and budget requirements
- **InvestmentController** - Investment needs and risk profiling

### Key Database Entities

Based on schema analysis, the core FactFind entities include:

- **TFactFind** - Main FactFind entity linking clients
- **TEmploymentDetail** - Employment information
- **TAssets** - Asset information with ownership and valuation
- **TLiabilities** - Liability and debt information
- **TPerson** - Personal details and demographics
- **TContacts** - Contact information
- **TDependants** - Dependent information
- **TIncome** - Income details and breakdowns
- **TExpenditure** - Expenditure and budget information

## Proposed Resource-Centric API Design

### Core Design Principles

Following Intelliflo API Design Guidelines 2.0:

1. **Resource-Based URIs** - Use nouns, not verbs
2. **Consistent Naming** - PascalCase for JSON properties, camelCase for parameters
3. **RESTful HTTP Methods** - GET, POST, PUT, DELETE with appropriate status codes
4. **Hypermedia Support** - Include relevant links for discoverability
5. **Comprehensive Error Handling** - Structured error responses with correlation IDs
6. **Data Type Standards** - ISO 8601 dates, decimal percentages, currency codes

### API Structure Overview

```
/v2/clients/{clientId}/factfinds/{factFindId}/
├── profile/
│   ├── personal-details
│   ├── contact-details
│   ├── addresses
│   ├── dependants
│   └── id-verification
├── employment/
│   ├── employments
│   ├── employment-history
│   └── tax-information
├── assets/
│   ├── assets
│   ├── asset-valuations
│   └── asset-income
├── liabilities/
│   ├── liabilities
│   ├── liability-plans
│   └── credit-history
├── budget/
│   ├── income
│   ├── income-breakdown
│   ├── expenditure
│   ├── expenditure-categories
│   └── affordability
└── investment/
    ├── investment-needs
    ├── investment-objectives
    ├── risk-profile
    └── asset-allocation
```

## Detailed API Specifications

### 1. Profile APIs

#### Personal Details API

**Base URL:** `/v2/clients/{clientId}/factfinds/{factFindId}/profile/personal-details`

**GET** - Retrieve personal details
```http
GET /v2/clients/{clientId}/factfinds/{factFindId}/profile/personal-details
```

**Response:**
```json
{
  "Id": 123,
  "ClientId": 456,
  "FactFindId": 789,
  "Title": "Mr",
  "FirstName": "John",
  "LastName": "Smith",
  "DateOfBirth": "1980-05-15T00:00:00Z",
  "Gender": "Male",
  "MaritalStatus": "Married",
  "Nationality": "GB",
  "NINumber": "AB123456C",
  "PlaceOfBirth": "London",
  "CountryOfBirth": "GB",
  "IsVulnerableClient": false,
  "VulnerabilityDetails": null,
  "_links": {
    "self": {"href": "/v2/clients/456/factfinds/789/profile/personal-details"},
    "factfind": {"href": "/v2/clients/456/factfinds/789"},
    "contact-details": {"href": "/v2/clients/456/factfinds/789/profile/contact-details"}
  }
}
```

**PUT** - Update personal details
```http
PUT /v2/clients/{clientId}/factfinds/{factFindId}/profile/personal-details
Content-Type: application/json

{
  "Title": "Mr",
  "FirstName": "John",
  "LastName": "Smith",
  "DateOfBirth": "1980-05-15T00:00:00Z",
  "Gender": "Male",
  "MaritalStatus": "Married",
  "Nationality": "GB"
}
```

#### Contact Details API

**Base URL:** `/v2/clients/{clientId}/factfinds/{factFindId}/profile/contact-details`

**GET** - Retrieve contact details
```http
GET /v2/clients/{clientId}/factfinds/{factFindId}/profile/contact-details
```

**Response:**
```json
{
  "Id": 123,
  "ClientId": 456,
  "FactFindId": 789,
  "PrimaryEmail": "john.smith@example.com",
  "SecondaryEmail": "j.smith@work.com",
  "HomePhone": "+44 20 1234 5678",
  "MobilePhone": "+44 7700 123456",
  "WorkPhone": "+44 20 8765 4321",
  "PreferredContactMethod": "Email",
  "PreferredContactTime": "Weekday Evenings",
  "_links": {
    "self": {"href": "/v2/clients/456/factfinds/789/profile/contact-details"},
    "addresses": {"href": "/v2/clients/456/factfinds/789/profile/addresses"}
  }
}
```

#### Addresses API

**Base URL:** `/v2/clients/{clientId}/factfinds/{factFindId}/profile/addresses`

**GET** - List addresses
```http
GET /v2/clients/{clientId}/factfinds/{factFindId}/profile/addresses
```

**Response:**
```json
{
  "Addresses": [
    {
      "Id": 123,
      "AddressType": "Home",
      "AddressLine1": "123 Main Street",
      "AddressLine2": "Apartment 4B",
      "City": "London",
      "County": "Greater London",
      "PostCode": "SW1A 1AA",
      "Country": "GB",
      "IsDefault": true,
      "ResidentFromDate": "2020-01-01T00:00:00Z",
      "ResidentToDate": null,
      "_links": {
        "self": {"href": "/v2/clients/456/factfinds/789/profile/addresses/123"}
      }
    }
  ],
  "_links": {
    "self": {"href": "/v2/clients/456/factfinds/789/profile/addresses"}
  }
}
```

**POST** - Create new address
```http
POST /v2/clients/{clientId}/factfinds/{factFindId}/profile/addresses
Content-Type: application/json

{
  "AddressType": "Home",
  "AddressLine1": "123 Main Street",
  "City": "London",
  "PostCode": "SW1A 1AA",
  "Country": "GB",
  "IsDefault": true,
  "ResidentFromDate": "2020-01-01T00:00:00Z"
}
```

**PUT** - Update address
```http
PUT /v2/clients/{clientId}/factfinds/{factFindId}/profile/addresses/{addressId}
```

**DELETE** - Delete address
```http
DELETE /v2/clients/{clientId}/factfinds/{factFindId}/profile/addresses/{addressId}
```

#### Dependants API

**Base URL:** `/v2/clients/{clientId}/factfinds/{factFindId}/profile/dependants`

**GET** - List dependants
```http
GET /v2/clients/{clientId}/factfinds/{factFindId}/profile/dependants
```

**Response:**
```json
{
  "Dependants": [
    {
      "Id": 123,
      "FirstName": "Emma",
      "LastName": "Smith",
      "DateOfBirth": "2010-03-20T00:00:00Z",
      "Relationship": "Daughter",
      "IsFinanciallyDependent": true,
      "DependencyEndDate": "2028-09-01T00:00:00Z",
      "SpecialNeeds": false,
      "SpecialNeedsDetails": null,
      "_links": {
        "self": {"href": "/v2/clients/456/factfinds/789/profile/dependants/123"}
      }
    }
  ],
  "_links": {
    "self": {"href": "/v2/clients/456/factfinds/789/profile/dependants"}
  }
}
```

### 2. Employment APIs

#### Employments API

**Base URL:** `/v2/clients/{clientId}/factfinds/{factFindId}/employment/employments`

**GET** - List employments
```http
GET /v2/clients/{clientId}/factfinds/{factFindId}/employment/employments
```

**Response:**
```json
{
  "Employments": [
    {
      "Id": 123,
      "EmploymentStatus": "Employed",
      "EmploymentBusinessType": "Limited Company",
      "Employer": "Tech Solutions Ltd",
      "JobTitle": "Software Developer",
      "Occupation": "Information Technology",
      "StartsOn": "2020-01-15T00:00:00Z",
      "EndsOn": null,
      "IsCurrentEmployment": true,
      "BasicAnnualSalary": 50000.00,
      "Currency": "GBP",
      "InProbation": false,
      "Address": {
        "AddressLine1": "100 Business Park",
        "City": "London",
        "PostCode": "EC1A 1BB",
        "Country": "GB"
      },
      "_links": {
        "self": {"href": "/v2/clients/456/factfinds/789/employment/employments/123"}
      }
    }
  ],
  "_links": {
    "self": {"href": "/v2/clients/456/factfinds/789/employment/employments"}
  }
}
```

**POST** - Create employment
```http
POST /v2/clients/{clientId}/factfinds/{factFindId}/employment/employments
Content-Type: application/json

{
  "EmploymentStatus": "Employed",
  "EmploymentBusinessType": "Limited Company",
  "Employer": "Tech Solutions Ltd",
  "JobTitle": "Software Developer",
  "StartsOn": "2020-01-15T00:00:00Z",
  "BasicAnnualSalary": 50000.00,
  "Currency": "GBP"
}
```

### 3. Assets APIs

#### Assets API

**Base URL:** `/v2/clients/{clientId}/factfinds/{factFindId}/assets/assets`

**GET** - List assets
```http
GET /v2/clients/{clientId}/factfinds/{factFindId}/assets/assets
```

**Response:**
```json
{
  "Assets": [
    {
      "Id": 123,
      "AssetType": "Property",
      "Description": "Main Residence",
      "CurrentValue": 450000.00,
      "Currency": "GBP",
      "ValuationDate": "2023-12-01T00:00:00Z",
      "PurchasePrice": 350000.00,
      "PurchaseDate": "2018-06-15T00:00:00Z",
      "Owner": "Joint",
      "OwnershipPercentage": 50.0,
      "IsInvestmentProperty": false,
      "GeneratesIncome": false,
      "Address": {
        "AddressLine1": "123 Main Street",
        "City": "London",
        "PostCode": "SW1A 1AA",
        "Country": "GB"
      },
      "_links": {
        "self": {"href": "/v2/clients/456/factfinds/789/assets/assets/123"},
        "valuations": {"href": "/v2/clients/456/factfinds/789/assets/assets/123/valuations"}
      }
    }
  ],
  "_links": {
    "self": {"href": "/v2/clients/456/factfinds/789/assets/assets"}
  }
}
```

### 4. Liabilities APIs

#### Liabilities API

**Base URL:** `/v2/clients/{clientId}/factfinds/{factFindId}/liabilities/liabilities`

**GET** - List liabilities
```http
GET /v2/clients/{clientId}/factfinds/{factFindId}/liabilities/liabilities
```

**Response:**
```json
{
  "Liabilities": [
    {
      "Id": 123,
      "LiabilityType": "Mortgage",
      "Description": "Main Residence Mortgage",
      "LenderName": "ABC Bank",
      "OutstandingBalance": 250000.00,
      "Currency": "GBP",
      "OriginalLoanAmount": 300000.00,
      "InterestRate": 3.5,
      "RateType": "Fixed",
      "MonthlyPayment": 1200.00,
      "StartDate": "2018-06-15T00:00:00Z",
      "EndDate": "2043-06-15T00:00:00Z",
      "IsSecured": true,
      "Owner": "Joint",
      "_links": {
        "self": {"href": "/v2/clients/456/factfinds/789/liabilities/liabilities/123"}
      }
    }
  ],
  "_links": {
    "self": {"href": "/v2/clients/456/factfinds/789/liabilities/liabilities"}
  }
}
```

### 5. Budget APIs

#### Income API

**Base URL:** `/v2/clients/{clientId}/factfinds/{factFindId}/budget/income`

**GET** - Get income summary
```http
GET /v2/clients/{clientId}/factfinds/{factFindId}/budget/income
```

**Response:**
```json
{
  "TotalGrossAnnualIncome": 65000.00,
  "TotalNetMonthlyIncome": 4200.00,
  "Currency": "GBP",
  "IncomeBreakdown": [
    {
      "Id": 123,
      "IncomeType": "Employment",
      "Description": "Basic Salary",
      "GrossAnnualAmount": 50000.00,
      "NetMonthlyAmount": 3200.00,
      "Frequency": "Monthly",
      "StartDate": "2020-01-15T00:00:00Z",
      "EndDate": null,
      "IncludeInAffordability": true,
      "Owner": "Client1"
    }
  ],
  "_links": {
    "self": {"href": "/v2/clients/456/factfinds/789/budget/income"},
    "breakdown": {"href": "/v2/clients/456/factfinds/789/budget/income-breakdown"}
  }
}
```

#### Expenditure API

**Base URL:** `/v2/clients/{clientId}/factfinds/{factFindId}/budget/expenditure`

**GET** - Get expenditure summary
```http
GET /v2/clients/{clientId}/factfinds/{factFindId}/budget/expenditure
```

**Response:**
```json
{
  "TotalMonthlyExpenditure": 3500.00,
  "Currency": "GBP",
  "ExpenditureByCategory": [
    {
      "Category": "Essential",
      "TotalAmount": 2000.00,
      "Items": [
        {
          "Id": 123,
          "Description": "Mortgage Payment",
          "Amount": 1200.00,
          "Frequency": "Monthly",
          "ExpenditureType": "Housing"
        }
      ]
    }
  ],
  "_links": {
    "self": {"href": "/v2/clients/456/factfinds/789/budget/expenditure"}
  }
}
```

### 6. Investment APIs

#### Investment Needs API

**Base URL:** `/v2/clients/{clientId}/factfinds/{factFindId}/investment/investment-needs`

**GET** - Get investment needs
```http
GET /v2/clients/{clientId}/factfinds/{factFindId}/investment/investment-needs
```

**Response:**
```json
{
  "InvestmentObjectives": [
    {
      "Id": 123,
      "Objective": "Retirement Planning",
      "Priority": "High",
      "TargetAmount": 500000.00,
      "Currency": "GBP",
      "TargetDate": "2045-05-15T00:00:00Z",
      "RiskTolerance": "Moderate",
      "TimeHorizon": "Long Term"
    }
  ],
  "RiskProfile": {
    "RiskScore": 6,
    "RiskCategory": "Moderate",
    "LastAssessmentDate": "2023-12-01T00:00:00Z",
    "QuestionnaireVersion": "2.1"
  },
  "_links": {
    "self": {"href": "/v2/clients/456/factfinds/789/investment/investment-needs"},
    "risk-profile": {"href": "/v2/clients/456/factfinds/789/investment/risk-profile"}
  }
}
```

## API Contract Patterns

### Base Contract Structure

Following the existing Monolith.FactFind patterns:

```csharp
// Base contract for shared properties
public abstract class BaseFactFindDocument
{
    public long ClientId { get; set; }
    public long FactFindId { get; set; }
    public DateTime LastModified { get; set; }
    public string Owner { get; set; } // "Client1", "Client2", "Joint"
}

// Create contracts for POST operations
public class CreatePersonalDetailsDocument : BaseFactFindDocument
{
    [Required]
    public string FirstName { get; set; }
    
    [Required]
    public string LastName { get; set; }
    
    public DateTime? DateOfBirth { get; set; }
    public string Gender { get; set; }
    public string MaritalStatus { get; set; }
}

// Full contracts for GET/PUT responses
public class PersonalDetailsDocument : CreatePersonalDetailsDocument
{
    public long Id { get; set; }
    public DateTime CreatedDate { get; set; }
    public Dictionary<string, object> _links { get; set; }
}
```

### Validation Patterns

```csharp
public class PersonalDetailsValidator : IPersonalDetailsValidator
{
    public void Validate(CreatePersonalDetailsDocument personalDetails)
    {
        Check.IsNotNull(personalDetails, $"{nameof(personalDetails)} can't be null");
        Check.IsTrue(!string.IsNullOrEmpty(personalDetails.FirstName), 
            $"{nameof(personalDetails.FirstName)} can't be empty");
        Check.IsTrue(!string.IsNullOrEmpty(personalDetails.LastName), 
            $"{nameof(personalDetails.LastName)} can't be empty");
            
        // Date validation
        if (personalDetails.DateOfBirth.HasValue)
        {
            Check.IsTrue(personalDetails.DateOfBirth <= DateTime.Today, 
                "Date of birth cannot be in the future");
        }
    }
}
```

### Converter Patterns

```csharp
public class PersonalDetailsConverter : IPersonalDetailsConverter
{
    public PersonalDetailsDocument ToContract(PersonalDetails entity)
    {
        ArgumentNullException.ThrowIfNull(entity);

        return new PersonalDetailsDocument
        {
            Id = entity.Id,
            ClientId = entity.ClientId,
            FactFindId = entity.FactFindId,
            FirstName = entity.FirstName,
            LastName = entity.LastName,
            DateOfBirth = entity.DateOfBirth,
            Gender = entity.Gender,
            MaritalStatus = entity.MaritalStatus,
            Owner = entity.Owner,
            _links = new Dictionary<string, object>
            {
                ["self"] = new { href = $"/v2/clients/{entity.ClientId}/factfinds/{entity.FactFindId}/profile/personal-details" },
                ["factfind"] = new { href = $"/v2/clients/{entity.ClientId}/factfinds/{entity.FactFindId}" }
            }
        };
    }

    public PersonalDetails ToDomain(ClientId clientId, long factFindId, CreatePersonalDetailsDocument document)
    {
        ArgumentNullException.ThrowIfNull(document);

        return new PersonalDetails
        {
            ClientId = clientId,
            FactFindId = factFindId,
            FirstName = document.FirstName,
            LastName = document.LastName,
            DateOfBirth = document.DateOfBirth,
            Gender = document.Gender,
            MaritalStatus = document.MaritalStatus,
            Owner = document.Owner ?? "Client1"
        };
    }
}
```

## Error Handling Standards

### Structured Error Responses

All 4xx and 5xx responses must include structured error bodies:

```json
{
  "code": "VALIDATION_ERROR",
  "message": "Personal details validation failed",
  "details": [
    {
      "field": "FirstName",
      "message": "First name is required and cannot be empty"
    }
  ]
}
```

### HTTP Status Code Usage

- **200 OK** - Successful GET, PUT operations
- **201 Created** - Successful POST with resource creation
- **204 No Content** - Successful DELETE operations
- **400 Bad Request** - Client validation errors
- **401 Unauthorized** - Authentication required
- **403 Forbidden** - Insufficient permissions
- **404 Not Found** - Resource not found
- **409 Conflict** - Resource conflicts (e.g., duplicate creation)
- **422 Unprocessable Entity** - Semantic validation errors
- **500 Internal Server Error** - Server errors

### Error Headers

- **x-IoErrorType** - Error type for i18n (alphanumeric, ≤40 chars)
- **x-IoRequestId** - Correlation ID for tracing

## Security and Authorization

### Scope Requirements

Following Intelliflo's scope patterns:

- **client_data.factfind** - Basic FactFind information access
- **client_financial_data.factfind** - Financial FactFind details
- **client_data.employment** - Employment information
- **client_financial_data.assets** - Asset information
- **client_financial_data.liabilities** - Liability information

### Authentication

- Use token-based authentication following Intelliflo standards
- Support both user and application authentication
- Include user context in operations

## Testing Strategy

### Unit Testing Requirements

```csharp
[TestFixture]
public class PersonalDetailsConverterTests
{
    private PersonalDetailsConverter converter;

    [SetUp]
    public void SetUp()
    {
        converter = new PersonalDetailsConverter();
    }

    [Test]
    public void ToContract_Should_Map_All_Properties()
    {
        // Arrange
        var entity = new PersonalDetails
        {
            Id = 123,
            ClientId = 456,
            FactFindId = 789,
            FirstName = "John",
            LastName = "Smith",
            DateOfBirth = new DateTime(1980, 5, 15)
        };

        // Act
        var result = converter.ToContract(entity);

        // Assert
        result.Id.Should().Be(123);
        result.FirstName.Should().Be("John");
        result.LastName.Should().Be("Smith");
        result.DateOfBirth.Should().Be(new DateTime(1980, 5, 15));
        result._links.Should().ContainKey("self");
    }
}
```

### Integration Testing Requirements

```csharp
[TestFixture]
public class PersonalDetailsApiTests : ApiTestBase
{
    [Test]
    public void GET_Should_Return_Personal_Details()
    {
        // Arrange
        var clientId = 456;
        var factFindId = 789;

        // Act
        var response = ApiTestsUtils.Get<PersonalDetailsDocument>(
            token, $"/v2/clients/{clientId}/factfinds/{factFindId}/profile/personal-details");

        // Assert
        response.Should().NotBeNull();
        response.ClientId.Should().Be(clientId);
        response.FactFindId.Should().Be(factFindId);
    }

    [Test]
    public void POST_Should_Create_Personal_Details()
    {
        // Arrange
        var personalDetails = new CreatePersonalDetailsDocument
        {
            FirstName = "John",
            LastName = "Smith",
            DateOfBirth = new DateTime(1980, 5, 15)
        };

        // Act
        var response = ApiTestsUtils.Post<PersonalDetailsDocument>(
            token, $"/v2/clients/{clientId}/factfinds/{factFindId}/profile/personal-details", personalDetails);

        // Assert
        response.Should().NotBeNull();
        response.Id.Should().BeGreaterThan(0);
        response.FirstName.Should().Be("John");
    }
}
```

## Implementation Roadmap

### Phase 1: Core Profile APIs
- Personal Details API
- Contact Details API
- Addresses API
- Dependants API

### Phase 2: Employment APIs
- Employments API
- Employment History API
- Tax Information API

### Phase 3: Financial APIs
- Assets API
- Liabilities API
- Asset Valuations API

### Phase 4: Budget APIs
- Income API
- Income Breakdown API
- Expenditure API
- Affordability API

### Phase 5: Investment APIs
- Investment Needs API
- Investment Objectives API
- Risk Profile API
- Asset Allocation API

## Success Criteria

1. **API Consistency** - All APIs follow the same patterns and conventions
2. **Comprehensive Coverage** - All FactFind data entities have CRUD operations
3. **Performance** - APIs meet performance targets (< 200ms for GET, < 500ms for POST/PUT)
4. **Testing** - 100% unit test coverage, comprehensive integration tests
5. **Documentation** - Complete Swagger documentation with examples
6. **Security** - Proper authentication, authorization, and data protection
7. **Error Handling** - Consistent error responses with correlation IDs

## Conclusion

This specification provides a comprehensive foundation for transforming the FactFind system from screen-based controllers to modern resource-centric CRUD APIs. The design follows REST principles, Intelliflo API Design Guidelines 2.0, and established patterns from the existing Monolith.FactFind implementation.

The proposed APIs will enable better client integration, improved data management, and support for modern development practices while maintaining consistency across all FactFind data entities.