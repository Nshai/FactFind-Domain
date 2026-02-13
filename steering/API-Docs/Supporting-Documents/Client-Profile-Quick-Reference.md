# V3 API Contracts - Quick Reference

This README provides quick navigation to the V3 API contract documentation for the Client Profile domain.

## Main Document

**File:** `API-Contracts-V3-Client-Profile.md`

A comprehensive 1,500+ line document containing complete OpenAPI 3.1 specifications for all Client Profile APIs.

## Document Overview

### What's Included

1. **Complete OpenAPI 3.1 Specifications** for 9 API families:
   - Client Demographics API (Person, Corporate, Trust)
   - Contact Details API
   - Address API
   - Vulnerability API
   - Data Protection & Marketing Preferences API
   - ID Verification API
   - Estate Planning Integration Pattern
   - Tax Details (embedded in client demographics)

2. **Comprehensive Documentation**:
   - API design standards and patterns
   - Common components (schemas, parameters, responses)
   - Full request/response examples
   - Error handling specifications
   - Security and authorization details
   - HATEOAS link structures

3. **V2 to V3 Migration Guide**:
   - Breaking changes analysis
   - Migration timeline (Q1 2024 - Q2 2025)
   - Code migration examples
   - Backward compatibility notes
   - Deprecation schedule

4. **Implementation Guidance**:
   - Performance considerations
   - Security best practices
   - Error handling strategies
   - Testing approaches

## Quick Navigation

### By API Family

| API Family | Section | Key Features |
|------------|---------|--------------|
| **Client Demographics** | Section 3 | Person/Corporate/Trust polymorphic client, enhanced demographics, territorial profile, health profile |
| **Contact Details** | Section 4 | Email, phone, social media contacts with verification, primary/default designation |
| **Addresses** | Section 5 | Residential addresses with geocoding, property details, electoral roll status |
| **Vulnerability** | Section 6 | Vulnerability assessments, review scheduling, client portal suitability |
| **Data Protection** | Section 7 | GDPR-compliant marketing preferences, channel-specific consent |
| **ID Verification** | Section 8 | Proof of identity documents, KYC/AML compliance, expiry tracking |
| **Estate Planning** | Section 9 | Integration pattern between CRM (documents) and Requirements (objectives) |
| **Tax Details** | Section 10 | Embedded in client demographics, PII obfuscation, multi-country support |

### By Use Case

#### Creating a New Client

**Section:** 3 (Client Demographics API)
**Endpoint:** `POST /v3/clients`
**Example:** See "Create a Person Client" usage example in Section 3

#### Managing Contact Information

**Section:** 4 (Contact Details API)
**Endpoints:**
- `GET /v3/clients/{clientId}/contact-details`
- `POST /v3/clients/{clientId}/contact-details`
- `PUT /v3/clients/{clientId}/contact-details/{contactDetailId}`

#### Managing Addresses

**Section:** 5 (Address API)
**Endpoints:**
- `GET /v3/clients/{clientId}/addresses`
- `POST /v3/clients/{clientId}/addresses`
- `PUT /v3/clients/{clientId}/addresses/{addressId}`

#### Recording Vulnerability Assessments

**Section:** 6 (Vulnerability API)
**Endpoints:**
- `GET /v3/clients/{clientId}/vulnerability` - Current assessment
- `GET /v3/clients/{clientId}/vulnerability/history` - Assessment history
- `PUT /v3/clients/{clientId}/vulnerability` - Update assessment

#### Managing Marketing Consent

**Section:** 7 (Data Protection & Marketing API)
**Endpoints:**
- `GET /v3/clients/{clientId}/marketing-preferences`
- `PUT /v3/clients/{clientId}/marketing-preferences`

#### KYC/AML Identity Verification

**Section:** 8 (ID Verification API)
**Endpoints:**
- `GET /v3/clients/{clientId}/identity-verification`
- `POST /v3/clients/{clientId}/identity-verification`

## Key Design Decisions

### 1. Build on V2 Success
All V3 APIs enhance existing V2 APIs rather than complete rewrites. This ensures:
- Minimal breaking changes
- Easier migration path
- Preserved domain knowledge
- Proven patterns retained

### 2. Domain Boundary Respect
Clear separation between:
- **CRM Domain** - WHO the client is (identity, demographics, contacts)
- **FactFind Domain** - WHAT the client's financial situation is (income, assets, goals)
- **Requirements Domain** - Future objectives and goals
- **Portfolio Domain** - Existing product holdings

### 3. Single Contract Principle
Each request/response uses a unified contract:
- No need to call multiple endpoints for related data
- HATEOAS links for navigation, not data duplication
- Embedded related entities are references only

### 4. Consistent Naming Conventions
Following API Design Guidelines 2.0:
- Value types suffix: `Value` (e.g., `AddressValue`, `GenderValue`)
- Reference types suffix: `Ref` (e.g., `ClientRef`, `AdviserRef`)
- Document types suffix: `Document` (e.g., `ClientDocument`)
- Collection types suffix: `Collection` (e.g., `AddressCollection`)

### 5. Security First
- OAuth 2.0 with granular scopes
- PII obfuscation by default
- `client_identification_data:read` scope required for sensitive data
- Audit trails on all mutations

## V2 to V3 Migration Timeline

| Phase | Date | Milestone |
|-------|------|-----------|
| **Design Complete** | Q1 2024 | ✓ This document |
| **Development** | Q2 2024 | Implementation of V3 endpoints |
| **Beta Testing** | Q2-Q3 2024 | Partner testing |
| **General Availability** | Q4 2024 | V3 GA, V2 deprecated |
| **V2 Sunset** | Q2 2025 | V2 returns 410 Gone |

## Breaking Changes Summary

### All APIs
1. URL structure: `/v2/...` → `/v3/...`
2. Error response format: Unified structure
3. Concurrency control: `If-Match` header required
4. OAuth scopes: More granular (`:read`, `:write` suffixes)

### Client Demographics
1. `Nationality` string → `CountryRef` object
2. Date format: Strict ISO 8601
3. New: `TerritorialProfileValue` for residency/domicile
4. New: `HealthProfileValue` for underwriting data

### Contact Details
1. New contact types: LinkedIn, WhatsApp, etc.
2. New: `isVerified` and `verifiedOn` fields
3. New: Distinction between `isPrimary` and `isDefault`

### Addresses
1. New: Automatic geocoding in response
2. New: `isCurrent` computed field
3. Enhanced: `PropertyDetailsValue` structure

## Code Examples

### C# Client Creation

```csharp
var client = new ClientCreateRequest
{
    PartyType = "Person",
    Person = new PersonValue
    {
        Title = "Mr",
        FirstName = "John",
        LastName = "Smith",
        DateOfBirth = "1985-03-15",
        Gender = "Male",
        Nationality = new CountryRef { Code = "GB" }
    },
    CurrentAdviser = new AdviserRef { Id = 789 }
};

var response = await httpClient.PostAsJsonAsync("/v3/clients", client);
var createdClient = await response.Content.ReadFromJsonAsync<ClientDocument>();
```

### JavaScript Address Addition

```javascript
const address = {
  type: 'Home',
  address: {
    addressLine1: '123 High Street',
    locality: 'London',
    postalCode: 'SW1A 1AA',
    country: { code: 'GB' }
  },
  residentFrom: '2015-06-01',
  isDefault: true,
  residencyStatus: 'Owner'
};

const response = await fetch(`/v3/clients/${clientId}/addresses`, {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify(address)
});

const createdAddress = await response.json();
```

## Additional Resources

### Related Documents
- `CRM-Client-Profile-API-Coverage.md` - Existing V2 API analysis
- `steering/Client-FactFind-Boundary-Analysis.md` - Domain boundary definitions
- `FactFind-Sections-Reference.md` - Complete section catalog

### External Resources
- API Developer Portal: https://developer.intelliflo.com/v3
- OpenAPI Specifications: `/specs/v3/`
- Postman Collection: https://api.intelliflo.com/v3/postman/client-profile.json
- SDK Documentation: https://developer.intelliflo.com/sdks

### Support
- API Support Email: api-support@intelliflo.com
- Status Page: https://status.intelliflo.com
- Change Log: https://developer.intelliflo.com/changelog

## Document Maintenance

| Attribute | Value |
|-----------|-------|
| **Document Owner** | API Architecture Team |
| **Last Updated** | 2026-02-12 |
| **Version** | 3.0.0 |
| **Status** | Design Specification |
| **Next Review** | Q2 2024 |

## Feedback

Please provide feedback on this specification via:
- GitHub Issues: (internal repo)
- Email: api-architecture@intelliflo.com
- Slack: #api-v3-feedback

---

**Quick Start:** Open `API-Contracts-V3-Client-Profile.md` and jump to Section 3 for Client Demographics API.
