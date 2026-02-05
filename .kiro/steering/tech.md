# Technology Stack & Build System

## Technology Stack

### IntelligentOffice (Legacy)
- **.NET Framework 4.7.2** - Main application framework
- **C#** - Primary programming language
- **ASP.NET Web Forms/MVC** - Web application framework
- **NHibernate** - Object-relational mapping (ORM)
- **SQL Server** - Primary database (FactFind, CRM, Administration schemas)
- **MSBuild** - Build system with custom targets
- **NUnit 2.6.3** - Unit testing framework
- **Autofac** - Dependency injection container
- **log4net** - Logging framework

### Monolith.FactFind (Modern)
- **.NET 8** - Modern application framework
- **ASP.NET Core** - Web API framework
- **NHibernate** - ORM (maintaining consistency with legacy)
- **NUnit** - Unit testing framework
- **FluentAssertions** - Test assertion library
- **Swagger/OpenAPI** - API documentation
- **Docker** - Containerization support

### Third-Party Libraries
- **AutoMapper** - Object-to-object mapping
- **Aspose.Words** - Document processing
- **ChartFX** - Charting components
- **iTextSharp** - PDF generation
- **AWS SDK** - Cloud services integration

## Build System

### IntelligentOffice Build Commands

**Restore NuGet Packages:**
```batch
nuget restore .\Intelliflo.IO.ALL.sln -Source https://artifactory.intelliflo.io/artifactory/api/nuget/nuget-virtual -Verbosity quiet
```

**Build and Publish Web Application:**
```batch
msbuild "newbuild.proj" /t:PublishWebApp /p:RunCodeAnalysis=false /p:TargetFrameworkVersion=v4.7.1 /p:Configuration=Release /clp:ErrorsOnly /p:Build=1.0.0.0 /p:GitHash=0000000000000000000000000000000000000000
```

**Run Unit Tests:**
```batch
# Build solution first
msbuild IntelliFlo.IO.ALL.sln

# Run tests with NUnit console runner
c:\jenkins_tools\NUnit.Runners\tools\nunit-console.exe build\test\*.dll --framework=4.0 --nodots --nologo --noshadow /xml:dist\UnitTestResults.xml
```

**Available MSBuild Targets:**
- `BuildIOOnly` - Build IntelligentOffice projects only
- `PublishIOOnly` - Build and publish web app and job servers
- `PackageIOOnly` - Create deployment packages
- `TestIO` - Run unit tests

### Monolith.FactFind Build Commands

**Build and Run Application:**
```powershell
dotnet build
dotnet run --project src/Monolith.FactFind
```

**Run Tests:**
```powershell
# Unit tests
./.docker/run-unit-tests.ps1

# API/Subsystem tests
./.docker/run-api-tests.ps1 -AwsKeyId "your_key_id" -AwsKey "your_key" -AwsToken "your_token"
```

**Docker Commands:**
```powershell
# Build application image
./.docker/build-application-image.ps1

# Run checks (linting, analysis)
./.docker/run-checks.ps1
```

## Development Environment Setup

### Prerequisites
- Visual Studio 2017+ or VS Code
- .NET Framework 4.7.2 SDK
- .NET 8 SDK
- SQL Server 2017+
- Docker Desktop (for containerized development)
- Access to Intelliflo Artifactory for NuGet packages

### Database Setup
- Use `dbsync` from Monolith.Sql repository
- Database schemas: FactFind, CRM, Administration, PolicyManagement, ATR
- Connection strings configured via app.config/appsettings.json

### Configuration Management
- **Legacy**: Web.config transformations for different environments
- **Modern**: appsettings.json with environment-specific overrides
- **Secrets**: Use Consul/Vault for production secrets
- **Local Development**: appsettings.Development.json for local overrides