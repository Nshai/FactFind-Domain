# Legacy Controller to Modern API Mapping

This document maps the existing legacy MVC controllers to the new resource-centric REST APIs.

## Overview

The legacy FactFind system uses screen-based controllers that handle multiple concerns within single actions. The modern API design separates these into focused, resource-centric endpoints that follow REST principles.

---

## ClientFactFindController Mapping

### Legacy Actions → Modern Endpoints

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `Index()` | GET | `/api/v2/factfinds` | List all FactFinds |
| `Create()` | GET | `/api/v2/factfinds` (OPTIONS) | Get creation schema |
| `Create(model)` | POST | `/api/v2/factfinds` | Create new FactFind |
| `Edit(id)` | GET | `/api/v2/factfinds/{id}` | Get FactFind details |
| `Edit(id, model)` | PUT | `/api/v2/factfinds/{id}` | Update FactFind |
| `Delete(id)` | DELETE | `/api/v2/factfinds/{id}` | Delete FactFind |
| `AddPartner(id)` | POST | `/api/v2/factfinds/{id}` | Update FactFind to add partner |
| `RemovePartner(id)` | POST | `/api/v2/factfinds/{id}` | Update FactFind to remove partner |
| `Copy(id)` | POST | `/api/v2/factfinds` | Create new FactFind from existing |
| `Archive(id)` | PATCH | `/api/v2/factfinds/{id}` | Archive FactFind |
| `Restore(id)` | PATCH | `/api/v2/factfinds/{id}` | Restore FactFind |

### Navigation Actions → HATEOAS Links

| Legacy Action | Modern Approach |
|---------------|----------------|
| `GoToProfile(id)` | HATEOAS link in FactFind response |
| `GoToEmployment(id)` | HATEOAS link in FactFind response |
| `GoToAssets(id)` | HATEOAS link in FactFind response |
| `GoToBudget(id)` | HATEOAS link in FactFind response |
| `GoToInvestment(id)` | HATEOAS link in FactFind response |

---

## ProfileController Mapping

### Personal Details Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `PersonalDetails(id)` | GET | `/api/v2/factfinds/{id}/profile` | Get personal details |
| `PersonalDetails(id, model)` | PUT | `/api/v2/factfinds/{id}/profile` | Update personal details |
| `EditPersonalDetails(id)` | GET | `/api/v2/factfinds/{id}/profile` | Get personal details for editing |
| `EditPersonalDetails(id, model)` | PATCH | `/api/v2/factfinds/{id}/profile` | Partial update personal details |

### Contact Details Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `ContactDetails(id)` | GET | `/api/v2/factfinds/{id}/profile/addresses` | Get contact details |
| `ContactDetails(id, model)` | PUT | `/api/v2/factfinds/{id}/profile` | Update contact details |
| `AddAddress(id)` | POST | `/api/v2/factfinds/{id}/profile/addresses` | Add new address |
| `EditAddress(id, addressId)` | GET | `/api/v2/factfinds/{id}/profile/addresses/{addressId}` | Get address for editing |
| `EditAddress(id, addressId, model)` | PUT | `/api/v2/factfinds/{id}/profile/addresses/{addressId}` | Update address |
| `DeleteAddress(id, addressId)` | DELETE | `/api/v2/factfinds/{id}/profile/addresses/{addressId}` | Delete address |
| `AddPhone(id)` | POST | `/api/v2/factfinds/{id}/profile` | Add phone (via profile update) |
| `EditPhone(id, phoneId)` | PATCH | `/api/v2/factfinds/{id}/profile` | Update phone (via profile update) |
| `DeletePhone(id, phoneId)` | PATCH | `/api/v2/factfinds/{id}/profile` | Delete phone (via profile update) |
| `AddEmail(id)` | POST | `/api/v2/factfinds/{id}/profile` | Add email (via profile update) |
| `EditEmail(id, emailId)` | PATCH | `/api/v2/factfinds/{id}/profile` | Update email (via profile update) |
| `DeleteEmail(id, emailId)` | PATCH | `/api/v2/factfinds/{id}/profile` | Delete email (via profile update) |

### Dependants Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `Dependants(id)` | GET | `/api/v2/factfinds/{id}/profile/dependants` | Get dependants |
| `Dependants(id, model)` | PUT | `/api/v2/factfinds/{id}/profile/dependants` | Update dependants |
| `AddDependant(id)` | POST | `/api/v2/factfinds/{id}/profile/dependants` | Add new dependant |
| `EditDependant(id, dependantId)` | GET | `/api/v2/factfinds/{id}/profile/dependants/{dependantId}` | Get dependant for editing |
| `EditDependant(id, dependantId, model)` | PUT | `/api/v2/factfinds/{id}/profile/dependants/{dependantId}` | Update dependant |
| `DeleteDependant(id, dependantId)` | DELETE | `/api/v2/factfinds/{id}/profile/dependants/{dependantId}` | Delete dependant |

### ID Verification Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `IdVerification(id)` | GET | `/api/v2/factfinds/{id}/profile` | Get ID verification status |
| `IdVerification(id, model)` | PATCH | `/api/v2/factfinds/{id}/profile` | Update ID verification |
| `MarkAsVerified(id, clientType)` | PATCH | `/api/v2/factfinds/{id}/profile` | Mark client as verified |

---

## EmploymentController Mapping

### Employment Details Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `EmploymentDetails(id)` | GET | `/api/v2/factfinds/{id}/employment` | Get employment details |
| `EmploymentDetails(id, model)` | PUT | `/api/v2/factfinds/{id}/employment` | Update employment details |
| `AddEmployment(id)` | POST | `/api/v2/factfinds/{id}/employment` | Add new employment |
| `EditEmployment(id, empId)` | GET | `/api/v2/factfinds/{id}/employment/{empId}` | Get employment for editing |
| `EditEmployment(id, empId, model)` | PUT | `/api/v2/factfinds/{id}/employment/{empId}` | Update employment |
| `DeleteEmployment(id, empId)` | DELETE | `/api/v2/factfinds/{id}/employment/{empId}` | Delete employment |
| `EmploymentHistory(id)` | GET | `/api/v2/factfinds/{id}/employment?includeHistory=true` | Get employment history |

### Tax Information Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `TaxInformation(id)` | GET | `/api/v2/factfinds/{id}/employment` | Get tax information (part of employment) |
| `TaxInformation(id, model)` | PATCH | `/api/v2/factfinds/{id}/employment` | Update tax information |
| `UpdateTaxCode(id, clientType, taxCode)` | PATCH | `/api/v2/factfinds/{id}/employment` | Update tax code |

---

## AssetsAndLiabilitiesController Mapping

### Assets Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `Assets(id)` | GET | `/api/v2/factfinds/{id}/assets` | Get all assets |
| `Assets(id, model)` | PUT | `/api/v2/factfinds/{id}/assets` | Update assets |
| `AddAsset(id)` | POST | `/api/v2/factfinds/{id}/assets` | Add new asset |
| `EditAsset(id, assetId)` | GET | `/api/v2/factfinds/{id}/assets/{assetId}` | Get asset for editing |
| `EditAsset(id, assetId, model)` | PUT | `/api/v2/factfinds/{id}/assets/{assetId}` | Update asset |
| `DeleteAsset(id, assetId)` | DELETE | `/api/v2/factfinds/{id}/assets/{assetId}` | Delete asset |
| `PropertyAssets(id)` | GET | `/api/v2/factfinds/{id}/assets?assetType=Property` | Get property assets |
| `InvestmentAssets(id)` | GET | `/api/v2/factfinds/{id}/assets?assetType=Investment` | Get investment assets |
| `PensionAssets(id)` | GET | `/api/v2/factfinds/{id}/assets?assetType=Pension` | Get pension assets |

### Liabilities Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `Liabilities(id)` | GET | `/api/v2/factfinds/{id}/liabilities` | Get all liabilities |
| `Liabilities(id, model)` | PUT | `/api/v2/factfinds/{id}/liabilities` | Update liabilities |
| `AddLiability(id)` | POST | `/api/v2/factfinds/{id}/liabilities` | Add new liability |
| `EditLiability(id, liabilityId)` | GET | `/api/v2/factfinds/{id}/liabilities/{liabilityId}` | Get liability for editing |
| `EditLiability(id, liabilityId, model)` | PUT | `/api/v2/factfinds/{id}/liabilities/{liabilityId}` | Update liability |
| `DeleteLiability(id, liabilityId)` | DELETE | `/api/v2/factfinds/{id}/liabilities/{liabilityId}` | Delete liability |
| `Mortgages(id)` | GET | `/api/v2/factfinds/{id}/liabilities?liabilityType=Mortgage` | Get mortgages |
| `PersonalLoans(id)` | GET | `/api/v2/factfinds/{id}/liabilities?liabilityType=PersonalLoan` | Get personal loans |
| `CreditCards(id)` | GET | `/api/v2/factfinds/{id}/liabilities?liabilityType=CreditCard` | Get credit cards |

### Credit History Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `CreditHistory(id)` | GET | `/api/v2/factfinds/{id}/profile` | Get credit history (part of profile) |
| `CreditHistory(id, model)` | PATCH | `/api/v2/factfinds/{id}/profile` | Update credit history |

---

## BudgetController Mapping

### Income Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `Income(id)` | GET | `/api/v2/factfinds/{id}/income` | Get income details |
| `Income(id, model)` | PUT | `/api/v2/factfinds/{id}/income` | Update income |
| `AddIncome(id)` | POST | `/api/v2/factfinds/{id}/income` | Add new income item |
| `EditIncome(id, incomeId)` | GET | `/api/v2/factfinds/{id}/income/{incomeId}` | Get income item for editing |
| `EditIncome(id, incomeId, model)` | PUT | `/api/v2/factfinds/{id}/income/{incomeId}` | Update income item |
| `DeleteIncome(id, incomeId)` | DELETE | `/api/v2/factfinds/{id}/income/{incomeId}` | Delete income item |
| `EmploymentIncome(id)` | GET | `/api/v2/factfinds/{id}/income?incomeType=Employment` | Get employment income |
| `PensionIncome(id)` | GET | `/api/v2/factfinds/{id}/income?incomeType=Pension` | Get pension income |
| `InvestmentIncome(id)` | GET | `/api/v2/factfinds/{id}/income?incomeType=Investment` | Get investment income |

### Expenditure Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `Expenditure(id)` | GET | `/api/v2/factfinds/{id}/expenditure` | Get expenditure details |
| `Expenditure(id, model)` | PUT | `/api/v2/factfinds/{id}/expenditure` | Update expenditure |
| `AddExpenditure(id)` | POST | `/api/v2/factfinds/{id}/expenditure` | Add new expenditure item |
| `EditExpenditure(id, expenditureId)` | GET | `/api/v2/factfinds/{id}/expenditure/{expenditureId}` | Get expenditure item for editing |
| `EditExpenditure(id, expenditureId, model)` | PUT | `/api/v2/factfinds/{id}/expenditure/{expenditureId}` | Update expenditure item |
| `DeleteExpenditure(id, expenditureId)` | DELETE | `/api/v2/factfinds/{id}/expenditure/{expenditureId}` | Delete expenditure item |
| `EssentialExpenditure(id)` | GET | `/api/v2/factfinds/{id}/expenditure?isEssential=true` | Get essential expenditure |
| `LifestyleExpenditure(id)` | GET | `/api/v2/factfinds/{id}/expenditure?isEssential=false` | Get lifestyle expenditure |

### Budget Requirements Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `BudgetRequirements(id)` | GET | `/api/v2/factfinds/{id}/budget-summary` | Get budget summary |
| `BudgetRequirements(id, model)` | PATCH | `/api/v2/factfinds/{id}/budget-requirements` | Update budget requirements |
| `CalculateAffordability(id)` | GET | `/api/v2/factfinds/{id}/affordability` | Calculate affordability |
| `BudgetSummary(id)` | GET | `/api/v2/factfinds/{id}/budget-summary` | Get budget summary |

---

## InvestmentController Mapping

### Investment Needs Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `InvestmentNeeds(id)` | GET | `/api/v2/factfinds/{id}/investments` | Get investment needs |
| `InvestmentNeeds(id, model)` | PUT | `/api/v2/factfinds/{id}/investments` | Update investment needs |
| `AddInvestmentObjective(id)` | POST | `/api/v2/factfinds/{id}/investments/objectives` | Add investment objective |
| `EditInvestmentObjective(id, objId)` | PUT | `/api/v2/factfinds/{id}/investments/objectives/{objId}` | Update investment objective |
| `DeleteInvestmentObjective(id, objId)` | DELETE | `/api/v2/factfinds/{id}/investments/objectives/{objId}` | Delete investment objective |

### Risk Profile Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `RiskProfile(id)` | GET | `/api/v2/factfinds/{id}/investments/risk-profile` | Get risk profile |
| `RiskProfile(id, model)` | PUT | `/api/v2/factfinds/{id}/investments/risk-profile` | Update risk profile |
| `RiskQuestionnaire(id)` | GET | `/api/v2/factfinds/{id}/investments/risk-questionnaire` | Get risk questionnaire |
| `RiskQuestionnaire(id, model)` | POST | `/api/v2/factfinds/{id}/investments/risk-questionnaire` | Submit risk questionnaire |
| `AttitudeToRisk(id)` | GET | `/api/v2/factfinds/{id}/investments/risk-profile` | Get attitude to risk |
| `AttitudeToRisk(id, model)` | PATCH | `/api/v2/factfinds/{id}/investments/risk-profile` | Update attitude to risk |
| `CapacityForLoss(id)` | GET | `/api/v2/factfinds/{id}/investments/risk-profile` | Get capacity for loss |
| `CapacityForLoss(id, model)` | PATCH | `/api/v2/factfinds/{id}/investments/risk-profile` | Update capacity for loss |

### Investment Requirements Section

| Legacy Action | HTTP Method | Modern Endpoint | Purpose |
|---------------|-------------|-----------------|----------|
| `InvestmentRequirements(id)` | GET | `/api/v2/factfinds/{id}/investments/requirements` | Get investment requirements |
| `InvestmentRequirements(id, model)` | PUT | `/api/v2/factfinds/{id}/investments/requirements` | Update investment requirements |
| `AddRequirement(id)` | POST | `/api/v2/factfinds/{id}/investments/requirements` | Add new requirement |
| `EditRequirement(id, reqId)` | GET | `/api/v2/factfinds/{id}/investments/requirements/{reqId}` | Get requirement for editing |
| `EditRequirement(id, reqId, model)` | PUT | `/api/v2/factfinds/{id}/investments/requirements/{reqId}` | Update requirement |
| `DeleteRequirement(id, reqId)` | DELETE | `/api/v2/factfinds/{id}/investments/requirements/{reqId}` | Delete requirement |

---

## Common Patterns and Transformations

### Screen-Based to Resource-Based

**Legacy Pattern:**
```csharp
[HttpGet]
public ActionResult PersonalDetails(Guid id)
{
    var model = GetPersonalDetailsViewModel(id);
    return View(model);
}

[HttpPost]
public ActionResult PersonalDetails(Guid id, PersonalDetailsViewModel model)
{
    if (ModelState.IsValid)
    {
        SavePersonalDetails(id, model);
        return RedirectToAction("ContactDetails", new { id });
    }
    return View(model);
}
```
**Modern API Pattern:**
```csharp
[HttpGet("/api/v2/factfinds/{factfindId}/profile")]
public async Task<ActionResult<ProfileResource>> GetProfile(Guid factfindId)
{
    var profile = await _profileService.GetProfileAsync(factfindId);
    return Ok(profile);
}

[HttpPut("/api/v2/factfinds/{factfindId}/profile")]
public async Task<ActionResult<ProfileResource>> UpdateProfile(Guid factfindId, UpdateProfileRequest request)
{
    var profile = await _profileService.UpdateProfileAsync(factfindId, request);
    return Ok(profile);
}
```

### Navigation to Resource Discovery

**Legacy Pattern:**
- Controllers have hardcoded navigation methods
- Screen-to-screen navigation via action methods
- Tight coupling between UI screens

**Modern API Pattern:**
- HATEOAS links provide resource discovery
- Client-driven navigation based on available links
- Loose coupling between client and server

### Validation Transformation

**Legacy Pattern:**
```csharp
[HttpPost]
public ActionResult Create(CreateFactFindViewModel model)
{
    if (!ModelState.IsValid)
    {
        return View(model);
    }
    
    // Business validation mixed with controller logic
    if (model.PrimaryClientId == model.SecondaryClientId)
    {
        ModelState.AddModelError("SecondaryClientId", "Cannot be same as primary client");
        return View(model);
    }
    
    // Save logic
}
```

**Modern API Pattern:**
```csharp
[HttpPost("/api/v2/factfinds")]
public async Task<ActionResult<FactFindResource>> CreateFactFind(CreateFactFindRequest request)
{
    // Validation handled by validators in service layer
    var factFind = await _factFindService.CreateAsync(request);
    return CreatedAtAction(nameof(GetFactFind), new { id = factFind.Id }, factFind);
}
```

### Error Handling Transformation

**Legacy Pattern:**
- ModelState errors for validation
- ViewBag/TempData for messages
- Exception pages for errors

**Modern API Pattern:**
- Structured error responses with HTTP status codes
- Consistent error format across all endpoints
- Correlation IDs for tracing

---

## Data Model Transformations

### Flattened ViewModels to Hierarchical Resources

**Legacy ViewModel (Flattened):**
```csharp
public class PersonalDetailsViewModel
{
    public string PrimaryClientTitle { get; set; }
    public string PrimaryClientFirstName { get; set; }
    public string PrimaryClientLastName { get; set; }
    public DateTime? PrimaryClientDateOfBirth { get; set; }
    
    public string SecondaryClientTitle { get; set; }
    public string SecondaryClientFirstName { get; set; }
    public string SecondaryClientLastName { get; set; }
    public DateTime? SecondaryClientDateOfBirth { get; set; }
    
    public string HomeAddressLine1 { get; set; }
    public string HomeAddressLine2 { get; set; }
    public string HomeAddressCity { get; set; }
    // ... many more flattened properties
}
```

**Modern Resource (Hierarchical):**
```json
{
  "personalDetails": {
    "primaryClient": {
      "title": "Mr",
      "firstName": "John",
      "lastName": "Smith",
      "dateOfBirth": "1980-05-15"
    },
    "secondaryClient": {
      "title": "Mrs",
      "firstName": "Jane",
      "lastName": "Smith",
      "dateOfBirth": "1982-08-22"
    }
  },
  "contactDetails": {
    "addresses": [
      {
        "type": "Home",
        "addressLine1": "123 Main Street",
        "addressLine2": "Apartment 4B",
        "city": "London"
      }
    ]
  }
}
```

### Screen State to Resource State

**Legacy Screen State:**
- Current screen/step tracking
- Wizard-like progression
- Session-based state management

**Modern Resource State:**
- Resource-based state (Draft, InProgress, Complete)
- Stateless API design
- Client manages navigation state

---

## Authentication and Authorization Mapping

### Legacy Authentication

**Legacy Pattern:**
```csharp
[Authorize]
public class ProfileController : BaseController
{
    [HttpGet]
    public ActionResult PersonalDetails(Guid id)
    {
        // Check if user can access this FactFind
        if (!CanAccessFactFind(id))
        {
            return new HttpUnauthorizedResult();
        }
        
        // Controller logic
    }
}
```

**Modern API Pattern:**
```csharp
[Authorize(Policy = "FactFindAccess")]
[ApiController]
[Route("/api/v2/factfinds/{factfindId}/profile")]
public class ProfileController : ControllerBase
{
    [HttpGet]
    [RequiredScope("client_data.factfind")]
    public async Task<ActionResult<ProfileResource>> GetProfile(
        [FromRoute] Guid factfindId)
    {
        // Authorization handled by policy and scope requirements
        var profile = await _profileService.GetProfileAsync(factfindId);
        return Ok(profile);
    }
}
```

### Authorization Scopes Mapping

| Legacy Permission | Modern Scope | Description |
|------------------|--------------|-------------|
| `CanViewFactFind` | `client_data.factfind:read` | Read FactFind data |
| `CanEditFactFind` | `client_data.factfind:write` | Modify FactFind data |
| `CanDeleteFactFind` | `client_data.factfind:delete` | Delete FactFind |
| `CanViewClientData` | `client_data:read` | Read client information |
| `CanViewFinancialData` | `client_financial_data:read` | Read financial information |
| `CanManageFirm` | `firm_data:write` | Manage firm-level data |

---

## Migration Strategy

### Phase 1: API-First Development
1. Build new REST APIs alongside existing MVC controllers
2. Implement new APIs following modern patterns
3. Maintain existing MVC controllers for backward compatibility

### Phase 2: Gradual Migration
1. Update client applications to use new APIs
2. Implement feature flags to switch between old and new endpoints
3. Monitor usage and performance of new APIs

### Phase 3: Legacy Deprecation
1. Mark legacy controllers as deprecated
2. Provide migration guides for API consumers
3. Remove legacy controllers after deprecation period

### Data Migration Considerations

**Database Schema:**
- Existing database schema can largely remain unchanged
- Add new tables for API-specific features (audit logs, etc.)
- Use views or stored procedures to bridge data model differences

**Business Logic Migration:**
- Extract business logic from controllers into service layer
- Implement domain services that can be used by both legacy and modern APIs
- Gradually refactor complex business rules

**Integration Points:**
- Maintain existing integration points during transition
- Implement adapters to translate between legacy and modern formats
- Update external systems to use new APIs over time

---

## Testing Strategy

### Legacy Controller Testing
```csharp
[Test]
public void PersonalDetails_Get_ReturnsCorrectViewModel()
{
    // Arrange
    var controller = new ProfileController();
    var factFindId = Guid.NewGuid();
    
    // Act
    var result = controller.PersonalDetails(factFindId) as ViewResult;
    
    // Assert
    Assert.IsNotNull(result);
    Assert.IsInstanceOf<PersonalDetailsViewModel>(result.Model);
}
```

### Modern API Testing
```csharp
[Test]
public async Task GetProfile_ReturnsProfileResource()
{
    // Arrange
    var factFindId = Guid.NewGuid();
    var expectedProfile = new ProfileResource { /* ... */ };
    _profileService.Setup(x => x.GetProfileAsync(factFindId))
               .ReturnsAsync(expectedProfile);
    
    // Act
    var result = await _controller.GetProfile(factFindId);
    
    // Assert
    var okResult = result.Result as OkObjectResult;
    Assert.IsNotNull(okResult);
    Assert.AreEqual(200, okResult.StatusCode);
    Assert.IsInstanceOf<ProfileResource>(okResult.Value);
}
```

### Integration Testing
- Test both legacy and modern endpoints during transition
- Ensure data consistency between old and new APIs
- Validate that business rules are maintained across both implementations

---

## Performance Considerations

### Legacy Performance Issues
- N+1 query problems in MVC controllers
- Large ViewModels with unnecessary data
- Synchronous operations blocking threads

### Modern API Improvements
- Optimized queries with proper includes
- Selective field loading based on client needs
- Asynchronous operations throughout
- Caching strategies for reference data

### Monitoring and Metrics
- Track API response times and error rates
- Monitor database query performance
- Compare legacy vs modern endpoint performance
- Set up alerts for performance degradation

---

## Documentation and Communication

### API Documentation
- Comprehensive OpenAPI/Swagger documentation
- Interactive API explorer for developers
- Code examples in multiple languages
- Migration guides from legacy endpoints

### Developer Communication
- Regular updates on migration progress
- Deprecation notices with timelines
- Training sessions on new API patterns
- Support channels for migration questions

### Change Management
- Feature flags for gradual rollout
- Rollback procedures for issues
- Communication plan for stakeholders
- Success metrics and KPIs