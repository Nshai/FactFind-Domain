# Project Structure & Organization

## Repository Layout

### Root Structure
```
Context/
├── IntelligentOffice/          # Legacy .NET Framework application
├── Monolith.FactFind/          # Modern .NET 8 microservice
└── schema/                     # Database schema definitions

Requirements/                   # Business requirements and development plans
├── Employment/                 # Employment API requirements
└── [other features]/

analyze_excel_gaps.py          # Data analysis scripts
read_excel.py                  # Excel processing utilities
```

## IntelligentOffice (Legacy) Structure

### Core Directories
```
Context/IntelligentOffice/
├── src/                        # Source code
│   ├── IntelliFlo.IO.Core/                    # Domain models and core logic
│   ├── IntelliFlo.IO.Commons/                 # Shared utilities
│   ├── IntelliFlo.IO.ServiceTier.BusinessServices/  # Business logic layer
│   ├── IntelliFlo.IO.Repository.Hibernate/    # Data access layer
│   ├── IntelliFlo.IO.Presentation/            # Presentation layer
│   ├── IntelliFlo.IO.ClientTier.WebClient/    # Web application
│   └── IntelliFlo.IO.JobServer/               # Background job processing
├── test/                       # Unit and integration tests
├── config/                     # Environment-specific configurations
├── lib/                        # Third-party libraries
├── build/                      # Build output directory
├── externalapps/              # External application packages
└── legacy/                    # Legacy platform contracts
```

### Architecture Layers
- **Domain Layer**: `IntelliFlo.IO.Core` - Entity models, domain logic
- **Service Layer**: `IntelliFlo.IO.ServiceTier.BusinessServices` - Business operations
- **Repository Layer**: `IntelliFlo.IO.Repository.Hibernate` - Data persistence
- **Presentation Layer**: `IntelliFlo.IO.Presentation` - UI logic and controllers
- **Web Layer**: `IntelliFlo.IO.ClientTier.WebClient` - Web application and APIs

## Monolith.FactFind (Modern) Structure

### Core Directories
```
Context/Monolith.FactFind/
├── src/Monolith.FactFind/      # Main application
│   ├── Controllers/            # API controllers
│   ├── Domain/                 # Domain entities and NHibernate mappings
│   ├── Resources/              # Business logic and services
│   │   ├── Converters/         # Domain ↔ Contract mapping
│   │   └── Validators/         # Business validation rules
│   ├── v2/Contracts/          # API contract models
│   └── Resources/             # Embedded resources (SQL, JSON)
├── test/
│   ├── Monolith.FactFind.Tests/           # Unit tests
│   └── Monolith.FactFind.SubSystemTests/  # Integration/API tests
└── .docker/                   # Docker build and test scripts
```

### API Architecture Pattern
```
Controller (thin, HTTP concerns)
  ↓
Resource (business logic, transactions)
  ↓
Converter (domain ↔ contract mapping)
  ↓
Repository (NHibernate, data access)
```

## Database Schema Organization

### Schema Structure
```
Context/schema/
├── administration/            # User management, system config
├── atr/                      # ATR (Adviser Training Record) data
├── crm/                      # Customer relationship management
├── factfind/                 # Fact-finding and client data
└── policymanagement/         # Insurance and policy data
```

Each schema contains:
- `Tables/` - Table definitions
- `Stored Procedures/` - Database procedures
- `Views/` - Database views
- `Functions/` - Database functions
- `Data/` - Reference data
- `refdata/` - Reference data scripts

## Naming Conventions

### C# Code Conventions
- **Namespaces**: `IntelliFlo.IO.{Layer}.{Feature}`
- **Classes**: PascalCase (`EmploymentDocument`, `EmploymentConverter`)
- **Methods**: PascalCase (`ToContract`, `ValidateEmployment`)
- **Properties**: PascalCase (`EmploymentType`, `IsCurrentEmployment`)
- **Fields**: camelCase with underscore prefix (`_employmentRepository`)
- **Constants**: UPPER_CASE (`MAX_EMPLOYMENT_YEARS`)

### Database Conventions
- **Tables**: PascalCase with T prefix (`TEmploymentDetail`, `TClientInformation`)
- **Columns**: PascalCase (`EmploymentType`, `ClientId`)
- **Stored Procedures**: PascalCase with sp prefix (`spGetEmploymentHistory`)
- **Indexes**: IX_{TableName}_{ColumnName} (`IX_TEmploymentDetail_ClientId`)

### API Conventions
- **Endpoints**: `/v{version}/{resource}` (`/v2/clients/{clientId}/employments`)
- **HTTP Methods**: Standard REST verbs (GET, POST, PUT, DELETE)
- **Response Models**: PascalCase properties in JSON
- **Enum Values**: String values with proper casing (`"Limited Company"`)

## Configuration Management

### Environment-Specific Configs
```
IntelligentOffice/config/
├── nioweb/                    # Web application configs
│   ├── Web.Prd-10.config     # Production environment
│   ├── Web.Tst-01.config     # Test environment
│   └── Web.Uat-10.config     # UAT environment
├── jobserver-ps/              # Job server configs
├── scheduler/                 # Scheduler configs
├── server-core/               # Core server configs
├── server-landg/              # L&G specific configs
└── server-zurich/             # Zurich specific configs
```

### Deployment Structure
```
.harness/                      # Harness CI/CD configuration
├── k8s/                       # Kubernetes manifests
├── terraform/                 # Infrastructure as code
└── values/                    # Environment-specific values
```

## Testing Organization

### Test Structure
- **Unit Tests**: Test individual classes/methods in isolation
- **Integration Tests**: Test component interactions
- **Sub-System Tests**: Test full API endpoints end-to-end
- **Contract Tests**: Validate API contract compliance

### Test Naming
- **Test Classes**: `{ClassUnderTest}Tests` (`EmploymentConverterTests`)
- **Test Methods**: `Should_{ExpectedBehavior}_When_{Condition}` 
- **Test Data**: Use `TestData/` folders for JSON fixtures

## Development Workflow

### Branch Strategy
- `main` - Production-ready code
- `develop` - Integration branch
- `feature/{ticket-id}-{description}` - Feature branches
- `hotfix/{ticket-id}-{description}` - Production hotfixes

### Code Review Requirements
- All changes require pull request review
- Unit tests required for new functionality
- Integration tests for API changes
- Documentation updates for public APIs