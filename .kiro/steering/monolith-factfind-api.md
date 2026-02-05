# Monolith.FactFind API Architecture & Development Guide

## Overview

Monolith.FactFind is a modern .NET 8 microservice that provides RESTful APIs for fact-finding and client data management. It follows a clean layered architecture with comprehensive testing, event publishing, and NHibernate ORM integration, adhering to Intelliflo's official API Design Guidelines 2.0.

## API Design Principles (Intelliflo Guidelines 2.0)

### Core Design Principles

1. **Consistency**: APIs should be consistent in naming, structure, and behavior across all services
2. **Simplicity**: Keep APIs simple and intuitive to use
3. **Discoverability**: APIs should be self-documenting and discoverable
4. **Reliability**: APIs should be reliable and predictable
5. **Performance**: APIs should be performant and efficient
6. **Security**: APIs should be secure by design
7. **Evolvability**: APIs should be designed to evolve over time

### REST Architectural Constraints

- **Client-Server**: Clear separation between client and server
- **Stateless**: Each request contains all information needed to process it
- **Cacheable**: Responses should be cacheable when appropriate
- **Uniform Interface**: Consistent interface across all resources
- **Layered System**: Architecture can be composed of hierarchical layers
- **Code on Demand** (optional): Server can extend client functionality

### Naming Conventions

**Resource URIs**:
- Use nouns, not verbs: `/clients/{clientId}/employments` not `/getEmployments`
- Use plural nouns for collections: `/clients` not `/client`
- Use lowercase with hyphens for multi-word resources: `/employment-details`
- Hierarchical relationships: `/clients/{clientId}/employments/{employmentId}`

**Parameters**:
- Use camelCase for query parameters: `?startDate=2023-01-01`
- Use kebab-case for path parameters in URLs: `/employment-details/{employment-id}`

**Properties**:
- Use PascalCase for JSON properties in responses: `"EmploymentStatus": "Employed"`
- Be consistent across all API responses

### Data Types and Formats

**Dates and Times**:
- Use ISO 8601 format: `"2023-12-25T10:30:00Z"`
- Always include timezone information
- Use UTC for storage, local time for display

**Money and Currencies**:
- Always include currency code: `{"Amount": 1000.00, "Currency": "GBP"}`
- Use decimal precision appropriate for currency

**Countries**:
- Use ISO 3166-1 alpha-2 codes: `"GB"`, `"US"`

**Percentages**:
- Express as decimal values: `0.15` for 15%
- Include units in property names when ambiguous: `"InterestRatePercent": 0.15`

**Arrays**:
- Always return arrays, even for single items when the endpoint can return multiple
- Use consistent naming: `"Employments": []` not `"EmploymentList"`

**Enums**:
- Use string values with proper casing: `"Limited Company"` not `"LIMITED_COMPANY"`
- Provide clear, human-readable values

### HTTP Methods and Status Codes

**HTTP Methods**:
- `GET`: Retrieve resources (idempotent, safe)
- `POST`: Create new resources or non-idempotent operations
- `PUT`: Update entire resources (idempotent)
- `PATCH`: Partial updates (not commonly used in current implementation)
- `DELETE`: Remove resources (idempotent)

**Status Codes**:
- `200 OK`: Successful GET, PUT, or PATCH
- `201 Created`: Successful POST with resource creation
- `204 No Content`: Successful DELETE or PUT with no response body
- `400 Bad Request`: Client error (validation failures)
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Resource not found
- `409 Conflict`: Resource conflict (e.g., duplicate creation)
- `422 Unprocessable Entity`: Semantic validation errors
- `500 Internal Server Error`: Server errors

### Error Response Format

All 4xx and 5xx responses must include a structured error body:

```json
{
  "code": "VALIDATION_ERROR",
  "message": "Employment status is required and cannot be empty"
}
```

**Headers**:
- `x-IoErrorType`: Error type for i18n (alphanumeric, ≤40 chars)
- `x-IoRequestId`: Correlation ID for tracing

### Hypermedia and HATEOAS

Include relevant links in responses to support discoverability:

```json
{
  "Id": 123,
  "EmploymentStatus": "Employed",
  "_links": {
    "self": {"href": "/v2/clients/456/employments/123"},
    "client": {"href": "/v2/clients/456"},
    "update": {"href": "/v2/clients/456/employments/123", "method": "PUT"}
  }
}
```

### Filtering and Searching

Use Intelliflo's custom query language for complex filtering:

```
?filter=name eq 'stuart' and person.lastname startswith 'cull'
?filter=person.age gt 50 and person.salutation in ('Mr', 'Master')
```

### Scopes and Security

**Scope Naming**:
- Use dot notation: `client_data.employment`
- Be specific about data access: `client_financial_data.quotes`
- Include reach indicators: `.app` suffix for app-specific data

**Common Scopes**:
- `client_data`: General client information
- `client_financial_data.employment`: Employment-specific data
- `firm_data`: Firm-level information
- `app_data`: App-owned resources across tenants

### Versioning

- Use URL versioning: `/v2/clients/{clientId}/employments`
- Maintain backward compatibility within major versions
- Plan deprecation strategies for old versions

## Architecture Pattern

The codebase follows a consistent 4-layer architecture pattern:

```
Controller (HTTP concerns)
  ↓
Resource (business logic, transactions)
  ↓
Converter (domain ↔ contract mapping)
  ↓
Repository (NHibernate, data access)
```

### Layer Responsibilities

**Controllers** (`v2/Controllers/`)
- Thin HTTP layer handling routing, status codes, and Swagger documentation
- Delegate all business logic to Resources
- Return appropriate HTTP status codes per Intelliflo guidelines (200, 201, 400, 404, 500)
- Use `[HttpGet]`, `[HttpPost]`, `[HttpPut]`, `[HttpDelete]` attributes
- Include comprehensive Swagger documentation with `[SwaggerOperation]`
- Follow REST naming conventions (nouns, not verbs)
- Implement proper error response format with structured JSON

**Resources** (`v2/Resources/`)
- Business logic and orchestration layer
- Use `[Transaction]` attribute for database transactions
- Use `[PublishEvent<T>]` attributes for domain events (Created, Changed, Deleted)
- Inject converters and validators via dependency injection
- Handle validation and business rule enforcement

**Converters** (`v2/Resources/Converters/`)
- Bidirectional mapping between domain entities and API contracts
- Implement interface contracts (e.g., `IEmploymentConverter`)
- Handle enum conversions using `EnumHelper.FindEnum<T>()` with string values per guidelines
- Map complex objects like addresses using provider services
- Include static helper methods for common conversions
- Follow data type formatting guidelines (ISO 8601 dates, decimal percentages, etc.)
- Ensure PascalCase for JSON properties in responses

**Domain Entities** (`Domain/`)
- NHibernate-mapped entities with `.hbm.xml` mapping files
- Use virtual properties for lazy loading
- Include audit attributes: `[Audit("FactFind", "TableName")]`
- Implement `EqualityAndHashCodeProvider<T, TId>` for identity
- Use computed columns with `formula` attribute for calculated fields

## API Contract Patterns

### Contract Structure

**Base Contracts**
- `BaseEmploymentDocument` - Shared properties for Create/Update operations
- `CreateEmploymentDocument` - Specific to POST operations
- `EmploymentDocument` - Full entity representation for GET/PUT responses

**Data Annotations**
- `[AllowedVerbs(HttpVerbs.Post, HttpVerbs.Put)]` - Specify which operations accept the field
- `[ValidEnumValues(typeof(EnumType))]` - Validate enum values
- `[DefaultValue(null)]` - Specify default values
- `[ReadOnly(true)]` - Mark computed/calculated fields as read-only
- `[Required]` - Mark mandatory fields
- `[Range(min, max)]` - Validate numeric ranges

**Enum Patterns**
```csharp
public enum EmploymentStatusValue
{
    [StringValue("Employed")]
    Employed = 1,
    
    [StringValue("Self-Employed")]
    SelfEmployed = 2
}
```

**Data Type Guidelines**:
- Dates: Use ISO 8601 format with timezone: `"StartsOn": "2023-01-15T00:00:00Z"`
- Money: Include currency when applicable: `{"Salary": 50000.00, "Currency": "GBP"}`
- Percentages: Use decimal values: `"TaxRate": 0.20` for 20%
- Countries: Use ISO 3166-1 alpha-2 codes: `"Country": "GB"`
- Enums: Use human-readable string values: `"EmploymentStatus": "Self-Employed"`

### Value Objects
- Use for complex nested data (e.g., `EmploymentAddressValue`, `SelfEmployedAccountsValue`)
- Include comprehensive data annotations following Intelliflo guidelines
- Add Swagger documentation attributes
- Support JSON serialization/deserialization
- Follow proper data type formatting (ISO dates, decimal percentages, etc.)
- Use PascalCase for all properties

## Validation Patterns

### Validator Implementation
```csharp
public class EmploymentValidator : IEmploymentValidator
{
    public void Validate(CreateEmploymentDocument employment)
    {
        Check.IsNotNull(employment, $"{nameof(employment)} can't be null");
        Check.IsTrue(!string.IsNullOrEmpty(employment.EmploymentStatus.GetStringValue()), 
            $"{nameof(employment.EmploymentStatus)} can't be empty");
        
        Validate(employment, employmentStatus);
    }

    public void Validate(BaseEmploymentDocument employment, EmploymentStatusValue employmentStatus)
    {
        // Date validation
        if (employment.StartsOn != null && employment.EndsOn != null)
        {
            Check.IsTrue(employment.StartsOn <= employment.EndsOn, 
                $"{nameof(employment.StartsOn)} should be less or equal to {nameof(employment.EndsOn)}");
        }

        // Conditional field validation
        IsValidForEmploymentStatus(employment.InProbation.HasValue, 
            nameof(employment.InProbation), InProbationStatuses, employmentStatus);
    }
}
```

### Validation Principles
- Use `Check.IsTrue()` and `Check.IsNotNull()` for validation assertions
- Provide clear, actionable error messages following Intelliflo error format
- Validate conditional fields based on employment status
- Use arrays to define which statuses allow specific fields
- Separate validation for Create vs Update operations
- Return structured error responses with appropriate HTTP status codes
- Include correlation IDs for error tracking

## Converter Implementation Patterns

### Bidirectional Mapping
```csharp
public class EmploymentConverter : IEmploymentConverter
{
    public EmploymentDocument ToContract(Employment entity)
    {
        ArgumentNullException.ThrowIfNull(entity);

        var status = EnumHelper.FindEnum<EmploymentStatusValue>(entity.Status, true);
        var businessType = entity.BusinessType != null ? 
            (EmploymentBusinessTypeValue)Enum.Parse(typeof(EmploymentBusinessTypeValue), entity.BusinessType) : 
            (EmploymentBusinessTypeValue?)null;

        return new EmploymentDocument
        {
            Id = entity.Id,
            StartsOn = entity.StartDate,
            EndsOn = entity.EndDate,
            EmploymentStatus = status,
            EmploymentBusinessType = businessType,
            Address = ToContractAddress(entity.Address),
            Client = new ClientReference { Id = entity.ClientId }
        };
    }

    public Employment ToDomain(ClientId clientId, CreateEmploymentDocument document)
    {
        ArgumentNullException.ThrowIfNull(clientId);
        ArgumentNullException.ThrowIfNull(document);

        return ToDomain(new Employment
        {
            ClientId = clientId,
            Status = document.EmploymentStatus.GetStringValue()
        }, document);
    }
}
```

### Converter Best Practices
- Always validate null arguments with `ArgumentNullException.ThrowIfNull()`
- Use `EnumHelper.FindEnum<T>()` for string-to-enum conversions per Intelliflo guidelines
- Handle null values gracefully throughout mapping
- Use provider services for complex lookups (countries, counties)
- Include static helper methods for common conversions
- Map computed/calculated fields as read-only
- Follow data type formatting guidelines (ISO 8601 dates, decimal percentages)
- Ensure PascalCase for JSON properties in responses
- Handle currency formatting when applicable

## Database Integration

### NHibernate Mapping
```xml
<hibernate-mapping xmlns="urn:nhibernate-mapping-2.2"
                   assembly="Monolith.FactFind"
                   namespace="Monolith.FactFind.Domain"
                   schema="FactFind.dbo">
  <class name="Employment" table="TEmploymentDetail">
    <id name="Id" column="EmploymentDetailId">
      <generator class="identity"/>
    </id>
    <property name="ClientId" column="CRMContactId"/>
    <property name="Status" column="EmploymentStatus"/>
    <property name="Checksum" type="Int64" formula="binary_checksum(*)" access="readonly" />
    
    <component name="Address" class="EmployerAddress">
      <property name="AddressLine1" column="EmployerAddressLine1"/>
      <property name="CountryId" column="RefCountryId"/>
    </component>
  </class>
</hibernate-mapping>
```

### Database Patterns
- Use identity columns for primary keys
- Map computed columns with `formula` attribute and `access="readonly"`
- Use component mapping for value objects (addresses)
- Include checksum columns for optimistic concurrency
- Follow naming convention: `T{EntityName}` for tables

## Testing Strategy

### Test Structure
```
test/
├── Monolith.FactFind.Tests/           # Unit tests
└── Monolith.FactFind.SubSystemTests/  # Integration/API tests
```

### Unit Testing Patterns
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
    public void ToContract_Should_Map_All_Properties()
    {
        // Arrange
        var entity = new Employment
        {
            Id = 123,
            Status = "Employed",
            StartDate = DateTime.Today.AddYears(-2)
        };

        // Act
        var result = converter.ToContract(entity);

        // Assert
        result.Id.Should().Be(123);
        result.EmploymentStatus.Should().Be(EmploymentStatusValue.Employed);
        result.StartsOn.Should().Be(DateTime.Today.AddYears(-2));
    }
}
```

### Sub-System Testing Patterns
```csharp
[TestFixture]
public class EmploymentApiTests : ApiTestBase
{
    private TestUser factFindUser;
    private string token;
    private const int ClientId = 12345;

    [Test]
    public void POST_Should_Create_Employment()
    {
        // Arrange
        var employment = new CreateEmploymentDocument
        {
            EmploymentStatus = EmploymentStatusValue.Employed,
            Employer = "Test Corp",
            Occupation = "Developer"
        };

        // Act
        var response = ApiTestsUtils.Post<EmploymentDocument>(token, url, employment);

        // Assert
        response.Should().NotBeNull();
        response.Id.Should().BeGreaterThan(0);
        response.Employer.Should().Be("Test Corp");
    }
}
```

### Testing Best Practices
- **Unit Tests**: Focus on converters, validators, and business logic
- **Sub-System Tests**: Test full API endpoints end-to-end
- Use `FluentAssertions` for readable assertions
- Use `NUnit` framework with `[TestFixture]` and `[Test]` attributes
- Mock external dependencies with `Mock.Of<T>()`
- Use embedded JSON files for complex test data
- Test both happy path and error scenarios
- Include validation error testing

## Event Publishing

### Event Attributes
```csharp
[PublishEvent<EmploymentCreated>]
[PublishEvent<EmploymentChanged>]
[PublishEvent<EmploymentDeleted>]
public class EmploymentResource
{
    [Transaction]
    public async Task<EmploymentDocument> CreateAsync(ClientId clientId, CreateEmploymentDocument document)
    {
        // Implementation
    }
}
```

### Event Types
- `Created` events for new entities
- `Changed` events for updates
- `Deleted` events for removals
- Events are automatically published based on attributes

## API Development Guidelines

### Creating New APIs

1. **Define Domain Entity**
   - Create entity class in `Domain/` folder
   - Add NHibernate mapping file (`.hbm.xml`)
   - Include audit attributes and equality providers

2. **Create API Contracts**
   - `Base{Entity}Document` for shared properties
   - `Create{Entity}Document` for POST operations
   - `{Entity}Document` for GET/PUT responses
   - Add comprehensive data annotations

3. **Implement Converter**
   - Create `I{Entity}Converter` interface
   - Implement bidirectional mapping
   - Handle enum conversions and null values
   - Include comprehensive unit tests

4. **Create Validator**
   - Implement `I{Entity}Validator` interface
   - Add conditional validation rules
   - Use `Check.IsTrue()` for assertions
   - Test all validation scenarios

5. **Build Resource**
   - Add `[Transaction]` and `[PublishEvent<T>]` attributes
   - Inject converter and validator
   - Handle business logic and orchestration

6. **Create Controller**
   - Thin HTTP layer with proper status codes
   - Comprehensive Swagger documentation
   - Delegate to Resource layer

7. **Add Tests**
   - Unit tests for converter and validator
   - Sub-system tests for API endpoints
   - Test CRUD operations and error scenarios

### Extending Existing APIs

1. **Database Changes**
   - Add columns with migration scripts
   - Update NHibernate mapping
   - Ensure backward compatibility

2. **Contract Updates**
   - Add new properties to contracts
   - Use nullable types for optional fields
   - Add appropriate data annotations

3. **Converter Updates**
   - Update bidirectional mapping
   - Handle new field conversions
   - Maintain null safety

4. **Validation Updates**
   - Add new validation rules if needed
   - Ensure backward compatibility

5. **Testing**
   - Update existing tests
   - Add tests for new functionality
   - Verify backward compatibility

## Security and Authentication

### Authentication
- Use token-based authentication following Intelliflo standards
- Validate tokens in controllers
- Include user context in operations
- Support both user and application authentication

### Authorization and Scopes
- Implement scope-based access control
- Common scopes for employment data:
  - `client_data.employment` - Basic employment information
  - `client_financial_data.employment` - Financial employment details
  - `firm_data.employment` - Firm-level employment data
- Use `.app` suffix for app-specific data access

### Reach Control
Intelliflo defines four key reaches:
1. **System Reach** - See everything across tenants
2. **Tenant Reach** - See everything within a tenant
3. **User Reach** - See data based on user's entity security permissions
4. **App Reach** - See only data created by the calling application

### Data Protection
- Sanitize input data
- Validate all user inputs
- Use parameterized queries (NHibernate handles this)
- Don't expose sensitive information in error messages
- Log security events appropriately

### Claims and Custom Claims
- Standard claims are encoded in tokens
- Custom claims can be added through Developer Platform
- Claims must be verified by Intelliflo during app certification
- Use claims for fine-grained authorization decisions

## Filtering and Searching

### Query Language
Use Intelliflo's custom query language for complex filtering on URIs:

**Examples**:
```
?filter=name eq 'stuart' and person.lastname startswith 'cull'
?filter=person.age gt 50 and person.salutation in ('Mr', 'Master')
?filter=employmentStatus eq 'Employed' and startsOn gt '2023-01-01'
```

**Supported Operators**:
- `eq` - equals
- `ne` - not equals
- `gt` - greater than
- `ge` - greater than or equal
- `lt` - less than
- `le` - less than or equal
- `startswith` - string starts with
- `endswith` - string ends with
- `contains` - string contains
- `in` - value in list

### Simple Filtering
For simple cases, use query parameters:
```
?employmentStatus=Employed
?startDate=2023-01-01
?endDate=2023-12-31
```

### Archived Resources
- Archived resources should be returned by default
- Add `IsArchived` filter for GET operations to filter archived/non-archived resources
- Example: `?filter=IsArchived eq false` to exclude archived items

## Bulk Operations and Collection Management

### Deleting Collections
For RESTful bulk deletion, create a temporary selection resource:

1. **Create Selection**:
   ```
   POST /v2/clients/{clientId}/employments/selections
   [1, 2, 6, 8, 25]
   ```
   Response: `201 Created` with `Location: /v2/clients/{clientId}/employments/selections/DF4XY7`

2. **Delete Selection**:
   ```
   DELETE /v2/clients/{clientId}/employments/selections/DF4XY7
   ```

### Bulk Updates
- Use PATCH with array of operations for bulk updates
- Consider performance implications for large collections
- Implement proper transaction handling for consistency

### Collection Responses
- Always return arrays for collection endpoints
- Include metadata when helpful (total count, pagination info)
- Use consistent naming: `"Employments": []` not `"EmploymentList"`

## API Documentation Standards

### Swagger/OpenAPI Documentation
- Use comprehensive `[SwaggerOperation]` attributes on all endpoints
- Include detailed parameter descriptions with examples
- Document all possible response codes and their meanings
- Provide example request/response bodies
- Use `[SwaggerResponse]` attributes for different status codes
- Include authentication requirements in documentation

### Documentation Best Practices
- Write clear, concise operation summaries
- Include business context in descriptions
- Document any side effects or business rules
- Provide realistic examples that developers can use
- Keep documentation up-to-date with code changes
- Use consistent terminology across all endpoints

### Example Documentation Pattern
```csharp
[HttpPost]
[SwaggerOperation(
    Summary = "Create a new employment record",
    Description = "Creates a new employment record for the specified client. The employment status determines which fields are required.",
    OperationId = "CreateEmployment"
)]
[SwaggerResponse(201, "Employment created successfully", typeof(EmploymentDocument))]
[SwaggerResponse(400, "Invalid request data", typeof(ErrorResponse))]
[SwaggerResponse(404, "Client not found", typeof(ErrorResponse))]
public async Task<ActionResult<EmploymentDocument>> CreateAsync(
    [FromRoute, SwaggerParameter("The unique identifier of the client")] ClientId clientId,
    [FromBody, SwaggerParameter("The employment data to create")] CreateEmploymentDocument employment)
```

## Error Handling

### Validation Errors
- Use `Check.IsTrue()` and `Check.IsNotNull()` for validation
- Provide clear, actionable error messages following Intelliflo format
- Return HTTP 400 Bad Request for validation failures
- Include structured error response body:
  ```json
  {
    "code": "VALIDATION_ERROR",
    "message": "Employment status is required and cannot be empty"
  }
  ```

### Business Logic Errors
- Throw appropriate exceptions in Resource layer
- Use custom exception types when needed
- Return appropriate HTTP status codes (409 for conflicts, 422 for semantic errors)
- Include correlation IDs in error headers

### System Errors
- Log exceptions appropriately
- Return HTTP 500 for unexpected errors
- Don't expose internal details to clients
- Include correlation ID for troubleshooting

## Performance Considerations

### Database Access
- Use lazy loading appropriately
- Optimize NHibernate queries
- Consider caching for reference data

### API Response Times
- Target < 200ms for GET operations
- Target < 500ms for POST/PUT operations
- Monitor performance with metrics

### Memory Usage
- Dispose resources properly
- Use streaming for large datasets
- Avoid loading unnecessary data

## Security

### Authentication
- Use token-based authentication
- Validate tokens in controllers
- Include user context in operations

### Authorization
- Implement role-based access control
- Validate user permissions for operations
- Audit sensitive operations

### Data Protection
- Sanitize input data
- Validate all user inputs
- Use parameterized queries (NHibernate handles this)

## Deployment and Environment Management

### Environment Configuration
- Use `appsettings.json` with environment-specific overrides
- Store secrets in secure configuration (Consul/Vault for production)
- Use connection string transformations
- Follow Intelliflo's configuration management standards

### Database Migrations
- Create idempotent migration scripts
- Test migrations in non-production environments first
- Plan rollback strategies for all changes
- Use `dbsync` from Monolith.Sql repository for schema management

### API Versioning Strategy
- Use URL versioning (`/v2/`) as per Intelliflo standards
- Maintain backward compatibility within major versions
- Plan deprecation strategies for old versions
- Communicate breaking changes well in advance
- Support multiple versions during transition periods

### Health Checks and Monitoring
- Implement health check endpoints following Intelliflo patterns
- Monitor dependencies (database, external services)
- Use for load balancer health checks
- Include version information in health responses

### Performance Targets
- Target < 200ms for GET operations
- Target < 500ms for POST/PUT operations
- Monitor API response times with metrics
- Track error rates and database performance
- Use structured logging with correlation IDs

## Monitoring and Observability

### Logging Standards
- Use structured logging with consistent format
- Include correlation IDs in all log entries
- Log business events and errors appropriately
- Follow Intelliflo's logging guidelines
- Use appropriate log levels (Debug, Info, Warning, Error, Critical)

### Metrics and Telemetry
- Monitor API response times and track performance trends
- Track error rates by endpoint and error type
- Monitor database performance and query execution times
- Use correlation IDs for distributed tracing
- Implement custom metrics for business events

### Health Checks
- Implement comprehensive health check endpoints
- Monitor all critical dependencies (database, external APIs)
- Use for load balancer health checks and automated monitoring
- Include version and build information
- Return appropriate HTTP status codes (200 for healthy, 503 for unhealthy)

### Alerting and Incident Response
- Set up alerts for critical metrics (error rates, response times)
- Define SLAs and SLOs for API performance
- Implement automated incident response where appropriate
- Maintain runbooks for common issues
- Use correlation IDs for efficient troubleshooting

## Integration Patterns

### Event Publishing
- Use `[PublishEvent<T>]` attributes for domain events
- Publish events for all significant business operations:
  - `EmploymentCreated` for new employment records
  - `EmploymentChanged` for updates
  - `EmploymentDeleted` for deletions
- Ensure events contain sufficient context for consumers
- Follow Intelliflo's event schema standards

### External API Integration
- Use proper authentication and authorization
- Implement retry policies with exponential backoff
- Handle rate limiting gracefully
- Log all external API calls with correlation IDs
- Cache responses when appropriate

### Database Integration Patterns
- Use NHibernate following established patterns
- Implement proper transaction boundaries with `[Transaction]` attribute
- Use lazy loading appropriately to optimize performance
- Consider caching for reference data that changes infrequently
- Monitor query performance and optimize as needed