# API Design Guidelines 2.0 - Summary for V3 API Design

## Executive Summary

This document extracts and summarizes the key principles and standards from the company's API Design Guidelines 2.0 to guide V3 API contract design. The guidelines emphasize RESTful architecture, consistent naming conventions, proper HTTP method usage, clear documentation, and a superior consumer experience.

**Core Philosophy:**
- APIs should be general-purpose and flexible for wider use cases
- Changes must be backwards compatible or properly versioned
- Favor simplicity and consistency over complexity and bespoking
- APIs should be discoverable and self-describing
- **Consumer experience is more important than developer experience**

---

## 1. REST Architectural Principles

### Six Core Constraints

#### 1.1 Uniform Interface
The uniform interface defines how clients and servers interact:

**Resource-Based:**
- Resources are identified by URIs
- Resources are conceptually separate from their representations
- Server returns representations (JSON, XML) not raw database records

**Manipulation Through Representations:**
- Clients holding a representation have enough information to modify/delete resources
- Requires appropriate permissions

**Self-Descriptive Messages:**
- Each message contains enough information to process it
- Specify media types (Content-Type headers)
- Responses indicate cacheability

**Hypermedia as the Engine of Application State (HATEOAS):**
- Clients deliver state via body, query-strings, headers, URIs
- Services deliver state via body, response codes, headers
- Links in response bodies enable resource discovery and navigation

#### 1.2 Stateless
- Server does not maintain session state between requests
- All necessary state must be contained in each request
- Enables greater scalability and simpler load balancing
- Client must include all information for server to fulfill the request

#### 1.3 Cacheable
- Responses must indicate if they can be cached
- Improves scalability and performance
- Reduces server load for repeated requests

#### 1.4 Client-Server
- Separation of concerns between client and server
- Enables independent evolution of each component

#### 1.5 Layered System
- Client cannot tell if connected directly to end server
- Enables intermediaries (proxies, gateways)

#### 1.6 Code on Demand (Optional)
- Server can extend client functionality
- Optional constraint, rarely implemented

---

## 2. Naming Conventions

### 2.1 Resource URI Naming

**Rules:**
- Resources should ALWAYS be **pluralized** (e.g., `/clients`, `/plans`, `/advisers`)
- Resources should ALWAYS be in **lowercase**
- Resources represent NOUNS (not verbs)
- A resource is any coherent and meaningful concept addressable by a URI

**Examples:**
```
/v2/clients
/v2/plans
/v2/advisers
/v2/funds
```

### 2.2 URI Parameter Naming

**Rules:**
- Parameter names should ALWAYS be **camelCased** (e.g., `clientId`)
- Parameter names must ALWAYS be **singular** (e.g., `clientId`, NOT `clientsId`)
- Parameter names should match the singular form of the resource name

**Examples:**
```
/v2/clients/{clientId}
/v2/plans/{planId}/valuations/{valuationId}
```

### 2.3 Resource Definition (Types) Naming

**Resource Types:**
- Types should ALWAYS be named **singular** (e.g., `Client`, `Plan`, `Adviser`)
- Types should ALWAYS be **PascalCased**
- Collection types should use suffix `Collection` (e.g., `ClientCollection`, `PlanCollection`)

**Resource Type References:**
- Reference types should be suffixed with `Ref` (e.g., `AdviserRef`, `ClientRef`, `AddressRef`)
- Contains minimum of `id` and `href` properties
- All properties must be consistent with the actual resource they reference

**Reference Example:**
```json
{
  "sellingAdviser": {
    "id": 123,
    "href": "/v2/advisers/123"
  }
}
```

**Named References:**
- If reference includes a `name` property, prefix with `Named` (e.g., `NamedAdviserRef`, `NamedClientRef`)

**Named Reference Example:**
```json
{
  "owner": {
    "id": 123,
    "name": "Jim Jones",
    "href": "/v2/clients/456"
  }
}
```

**Nested Value Types:**
- Nested value objects should be suffixed with `Value` (e.g., `PersonValue`, `TrustValue`, `CorporateValue`, `CurrencyValue`, `AddressValue`)
- Used for structural concerns only
- Can be reused in different parent contexts
- Do NOT represent independent resources

**Exceptional Cases:**
- If nested types differ across use cases, prefix with parent type name
- Examples: `ClientPersonValue`, `ClientTrustValue`, `ClientAdviserRef`

### 2.4 Operation Naming

| Operation | Description | HTTP Method | Example |
|-----------|-------------|-------------|---------|
| **{Resource} Exists** | Check if resource exists | HEAD | `ClientFee Exists` |
| **Get {Resource}** | Retrieve single resource by ID | GET | `Get ClientFee` |
| **List {Resource}s** | Retrieve list of resources | GET | `List ClientFees` |
| **Create {Resource}** | Create a new resource | POST | `Create ClientFee` |
| **Update {Resource}** | Update entire resource | PUT | `Update ClientFee` |
| **Patch {Resource}** | Partial update of resource | PATCH | `Patch ClientFee` |
| **Delete {Resource}** | Delete a resource | DELETE | `Delete ClientFee` |

### 2.5 Property Naming

**Rules:**
- Properties should be **camelCased**
- Properties may contain underscores for readability (e.g., `tax_year`)
- **No properties should end in "id"** - use nested resource references instead

**Common Properties:**

| Property | Description | Type |
|----------|-------------|------|
| `createdAt` | DateTime resource was created (UTC) | DateTime |
| `createdOn` | Date resource was created | Date |
| `modifiedAt` | DateTime resource was last modified (UTC) | DateTime |
| `archivedAt` | DateTime resource was archived (UTC) | DateTime |
| `deletedAt` | DateTime resource was soft deleted (UTC) | DateTime |
| `isArchived` | Boolean flag indicating archive status | Boolean |
| `id` | Identifier for the resource | String/Number |

**Naming Conventions for Dates:**
- **DateTime properties** should be suffixed with `At` (e.g., `createdAt`, `modifiedAt`)
- **Date-only properties** should be suffixed with `On` (e.g., `createdOn`, `activeOn`)

---

## 3. HTTP Methods and Status Codes

### 3.1 HTTP Method Usage

| HTTP Verb | CRUD | Collection (e.g., `/customers`) | Specific Item (e.g., `/customers/{id}`) | Idempotent |
|-----------|------|----------------------------------|------------------------------------------|------------|
| **POST** | Create | 201 (Created), Location header with `/customers/{id}`<br/>Return resource if Accept header present<br/>Empty body if no Accept header | 404 (Not Found)<br/>409 (Conflict) if resource exists | ❌ Not idempotent |
| **GET** | Read | 200 (OK), collection with pagination | 200 (OK), single resource<br/>404 (Not Found) if invalid ID | ✅ Idempotent |
| **PUT** | Update | 200 (OK) to replace entire collection<br/>404 (Not Found) if not supported | 200 (OK) or 204 (No Content)<br/>404 (Not Found) if invalid ID | ✅ Idempotent |
| **PATCH** | Partial Update | 200 (OK) to modify collection<br/>404 (Not Found) if not supported | 200 (OK) or 204 (No Content)<br/>404 (Not Found) if invalid ID | ✅ Idempotent |
| **DELETE** | Delete | 204 (No Content) to delete collection<br/>404 (Not Found) if not supported | 204 (No Content)<br/>404 (Not Found) if invalid ID | ✅ Idempotent |
| **HEAD** | Read | 200 (OK), no body, same headers as GET | 200 (OK), no body<br/>404 (Not Found) if invalid ID | ✅ Idempotent |

### 3.2 Status Code Guidelines

**Success Codes:**
- `200 OK` - Successful GET, PUT, PATCH (with response body)
- `201 Created` - Successful POST, return Location header
- `204 No Content` - Successful PUT, PATCH, DELETE (no response body)

**Client Error Codes:**
- `400 Bad Request` - Invalid request format or parameters
- `401 Unauthorized` - Authentication required or failed
- `403 Forbidden` - Authenticated but not authorized
- `404 Not Found` - Resource does not exist
- `409 Conflict` - Resource already exists or conflict in state

**Server Error Codes:**
- `500 Internal Server Error` - Generic server error
- `503 Service Unavailable` - Service temporarily unavailable

### 3.3 Error Response Format

**Mandatory for 4xx and 5xx responses:**

```json
{
  "code": "VALIDATION_FAILED",  // Optional: alphanumeric, <= 40 chars
  "message": "Email format is invalid"  // Mandatory: English, <= 140 chars
}
```

**Required Headers:**
- `x-IoErrorType`: ValidationException, etc. (for i18n)
- `x-IoRequestId`: Correlation ID for tracing

**Error Response Rules:**
- Error status codes MUST include body explaining details
- Mandatory for: 400, 401, 403, 409, and all 5xx
- Message must be in English
- ErrorType is optional and intended for i18n support
- Hypermedia links may be included where appropriate

---

## 4. Data Types

### 4.1 Dates and Times

**DateTime Standards:**
- **Format:** ISO8601 - `yyyy-MM-ddTHH:mm:ssZ` (e.g., `2023-10-15T14:30:00Z`)
- **Storage:** ALWAYS store as UTC
- **Wire Format:** ALWAYS return as UTC
- **Conversion:** Convert to user's timezone at display time

**Date-Only Values:**
- Use ISO8601 date format: `yyyy-MM-dd` (e.g., `2023-10-15`)
- Do NOT include time component if not needed
- Prevents timezone interpretation issues

**Timezone Handling:**
- For calendar/scheduler features requiring DST awareness:
  - Store DateTime in local time
  - Store TimeZoneId from IANA Time Zone database
  - Use NodaTime for conversions

**Property Naming:**
- DateTime properties: suffix with `At` (e.g., `createdAt`, `modifiedAt`)
- Date properties: suffix with `On` (e.g., `createdOn`, `activeOn`)

### 4.2 Periods/Duration

**Format:** ISO8601 Duration - `PnYnMnDTnHnMnS`
- Examples: `P3Y` (3 years), `P6M` (6 months), `PT2H30M` (2 hours 30 minutes)
- Can restrict to fixed unit (e.g., years only) - document restriction in Swagger

**Reference:** [ISO 8601 Duration](https://en.wikipedia.org/wiki/ISO_8601#Durations)

### 4.3 Money and Currencies

**Use platform-supported `CurrencyValue2` object:**

```json
{
  "planValue": {
    "currency": "GBP",
    "amount": "10.0"
  }
}
```

**Rules:**
- Currency follows ISO 4217 (3-letter code)
- Amount as string to preserve precision
- Never use JSON float for currency (loses precision)

### 4.4 Countries and Counties

**Countries - ISO 3166-1 alpha-2:**

```json
{
  "countryOfBirth": {
    "code": "GB",    // 2-letter country code
    "name": "United Kingdom"  // ISO English short name
  }
}
```

**Counties/Provinces/States - ISO 3166-2:**

```json
{
  "county": {
    "code": "GB-LON",  // 6-letter county code
    "name": "London"   // ISO English short name
  }
}
```

### 4.5 Percentages

**Default Format:**
- Range: 0.00 to 100.00
- Decimal places: 2
- C# type: `double`
- Database type: `float`

**Example:**
```csharp
[Range(typeof(double), "0.00", "100.00", ErrorMessage = "Value for {0} must be between {1} and {2}")]
[SwaggerDefaultValue("0")]
[RegularExpression(@"^\d*(\.\d{1,2})?$", ErrorMessage = "Invalid percentage format for {0}")]
public double PercentageAllocation { get; set; }
```

### 4.6 Numbers

**JSON Number Limitations:**
- JSON only supports integers and floating-point numbers
- C# integers → JSON integers ✅
- C# doubles → JSON floats ✅
- C# decimals → **DO NOT use as JSON float** ❌ (loses precision)
  - Use `CurrencyValue` for money
  - Use string for other decimal values requiring precision

### 4.7 Free-Form Text (Notes)

- Use standard string type
- Consider max length constraints
- Document any formatting requirements

### 4.8 Arrays

- Use standard JSON array notation
- Always document expected item types
- Consider pagination for large collections

### 4.9 Nulls vs Missing Properties

**Use `Settable<T>` pattern for distinguishing:**
- `null` value - explicitly set to null
- Missing property - not provided in request
- Non-null value - explicit value provided

**Important for PATCH operations** - distinguishing between "set to null" vs "don't change"

### 4.10 Enums

- Use string enums for better readability
- Document all possible values
- Consider versioning strategy for enum changes

---

## 5. Hypermedia (HATEOAS)

### 5.1 Purpose

Hypermedia links enable:
- Resource discovery
- Related resource navigation
- Self-describing APIs
- Dynamic client behavior

### 5.2 Two Acceptable Approaches

#### Approach 1: Href Properties

**Use for:**
- Linking to related collections
- Linking to collection filters (pagination)
- Linking to self
- Facilitating discovery

**Format:** Property name = relation + `_href` suffix

**Examples:**
```json
{
  "addresses_href": "https://api.intelliflo.com/v2/clients/456/addresses",
  "self_href": "https://api.intelliflo.com/v2/clients/456",
  "next_href": "https://api.intelliflo.com/v2/clients?page=2&size=20"
}
```

#### Approach 2: Resource Reference Objects

**Use for:**
- Linking to single related resources
- Including additional useful data (like name)

**Format:** Property name = relation name (no suffix), value = object with `id` and `href`

**Examples:**
```json
{
  "sellingAdviser": {
    "id": 123,
    "href": "/v2/advisers/123"
  },
  "owner": {
    "id": 123,
    "name": "Jim Jones",
    "href": "/v2/clients/456"
  }
}
```

### 5.3 Rules for Resource Reference Objects

1. **Store data locally** - no network calls to populate references
2. **Simple properties only** - identifiable properties like `name`, `reference`, `id`
3. **Maximum 3 properties** - including `id` and `href` (exceptions require justification)
4. **Properties must match** - names and structure consistent with actual resource
5. **Name the relationship** - not just the object type
   - ✅ Good: `owner` (explains why Client is linked to Plan)
   - ❌ Bad: `client` (doesn't explain the relationship)

### 5.4 Swagger Guidelines

- Avoid duplicating reference object definitions
- Reuse common reference types (e.g., single `ResourceRef` with just `id` and `href`)
- Create specific reference types only when additional properties are needed

---

## 6. Headers

### 6.1 Standard Headers

Follow RFC 2616 for standard HTTP headers:
- `Content-Type` - Media type of request/response body
- `Accept` - Media types client can handle
- `Authorization` - Authentication credentials
- `Location` - Resource location (201 Created responses)
- `Cache-Control` - Caching directives
- `ETag` - Resource version identifier

**Reference:** [RFC 2616 Section 14](https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html)

### 6.2 Custom Headers

**All custom headers MUST start with `x-iflo-*`**

**Examples:**
```
x-iflo-object-location
x-iflo-meta-username
```

### 6.3 Prefer Headers

**Purpose:** Client indicates preferences for response content

**Supported on:** GET operations only (ignored on others)

**Format:** RFC 7240 standard
```
Prefer: include=foo
Prefer: include=foo; exclude=bar
```

**Guidelines:**

1. **Default Behavior:**
   - Include all available fields by default
   - Do not exclude modifiable resource fields by default

2. **Exclude Option:**
   - Allow consumers to request excluding fields
   - Example: `Prefer: exclude=notes` (reduces payload size)
   - Use for large/optional fields

3. **Include Option:**
   - Use for read-only fields/relations excluded by default
   - Example: `Prefer: include=fundproposal`
   - Can include just reference by default, full resource on request

**Examples:**

**Example 1: Including Fund Proposals (Read-Only)**
```
GET /v2/clients/{clientId}/plans
Prefer: include=fundproposal
```

**Example 2: Excluding Notes**
```
GET /v2/clients/{clientId}
Prefer: exclude=notes
```

**Example 3: Including Full Fund Details**
```
GET /v2/clients/{clientId}/holdings
Prefer: include=fundDetails
```

---

## 7. Documentation Standards

### 7.1 Summary

**Format Rules:**
- Basic text explaining what endpoint does with respect to resource
- Must be less than 100 characters (fits on single line)
- Use consistent patterns

**Standard Formats:**
```
Returns a single <Resource>
Returns a list of <Resources>
Creates a new <Resource>
Updates an existing <Resource>
Deletes an existing <Resource>
Associates a <ResourceA> with a <ResourceB>
```

**Examples:**
```
Returns a single Client
Returns a list of Plans
Creates a new ClientFee
Updates an existing Adviser
Deletes an existing Plan
Associates an Adviser with a Client
```

### 7.2 Description

- Provide detailed explanation of endpoint behavior
- Document business rules and constraints
- Explain any special processing
- Include usage examples where helpful

### 7.3 Parameters

**Document for each parameter:**
- Name and location (path, query, body)
- Type and format
- Required vs optional
- Validation rules and constraints
- Default values
- Examples

### 7.4 Definitions

- Complete schema definitions for all types
- Document all properties with descriptions
- Include validation rules
- Provide examples
- Mark required vs optional fields

### 7.5 Tags

- Use tags to group related endpoints
- Consistent tag naming across API
- Helps with documentation organization

---

## 8. Events

### 8.1 Event Definition

**What is an Event?**
- Something that happened in the past related to a Resource
- Publishers are unaware of subscribers
- Used for WebHooks and asynchronous processing

**Event Generation:**
- ALL write operations (POST, PUT, PATCH, DELETE) should publish an event
- Use `PublishEvent` attribute for consistency

### 8.2 Event Naming Conventions

**Format:** `[Noun][Verb - past tense, simple form]`

**Nouns:**
- Must be Resources in primitive form (e.g., Client, Plan)
- NOT compound names (e.g., NOT ClientPlan)

**Verbs:**
- Must be one of: `Created`, `Changed`, `Deleted`

**Examples:**
```
PlanCreated
PlanChanged
PlanDeleted
ClientCreated
ClientChanged
ClientDeleted
```

### 8.3 Event Message Structure

**Base Structure (inherits from BusMessage):**

```json
{
  "Event": "DocumentCreated",
  "Payload": {
    "id": 123,
    "href": "/v2/documents/123",
    "title": "This is a title",
    "text": "Some data",
    "relevantUntil": "0001-01-01T00:00:00",
    "readAfter": "0001-01-01T00:00:00",
    "type": "Regular"
  },
  "Headers": {
    "X-IoRequestId": "9886b663-bc4c-420a-ad34-ac59acd4c086",
    "Trusted-Client-Token": "..."
  },
  "Id": "b2b74845-ecb5-4866-a93e-2c532ce2082d",
  "TimeStamp": "2018-05-09T08:50:02.8086122Z"
}
```

**Payload Rules:**
- Always include the FULL contract of the resource
- Applies to all event types (Created, Changed, Deleted)
- For Changed events (PUT/PATCH), include complete updated resource
- For Deleted events, return resource if possible, minimum return `id`

### 8.4 SNS/SQS Naming Conventions

**Queue Format:** `[env]-[instance]-[servicename]`
- Each microservice has a single queue
- Example: `prd-01-crm`

**Topic Format:** `[env]-[instance]-[messagename]`
- Each message gets its own topic
- Example: `prd-01-plancreated`

**Variables:**
- `[env]` - Environment: dev, tst, uat, prd
- `[instance]` - Instance name: 01, 02, 03, etc.
- `[servicename]` - Service name: push, crm, scheduler
- `[messagename]` - Message name in lowercase

### 8.5 Message Headers

**Custom Headers:**
- Use `[EventHeader]` attribute to place properties in message headers
- Use `[JsonIgnore]` to prevent header data from appearing in payload

**Example:**
```csharp
public class PersonDocument
{
    public int Id { get; set; }
    public string Href { get; set; }
    public string Name { get; set; }

    [JsonIgnore]
    [EventHeader]
    public Dictionary<string, string> MessageHeaders { get; set; }
}
```

---

## 9. Patterns and Best Practices

### 9.1 Deleting a Collection

**RESTful Pattern:**

1. Create a temporary selection resource:
```
POST http://example.com/resources/selections
[1, 2, 6, 8, 25]

Response:
HTTP 201 Created
Location: http://example.com/resources/selections/DF4XY7
Expires: [n minutes from now]
```

2. Delete using the selection:
```
DELETE http://example.com/resources/selections/DF4XY7

Response:
HTTP 204 No Content
```

**Note:** This is a legitimate RESTful pattern but not currently supported as a framework component.

### 9.2 Searching and Filtering

**Use Custom Query Language:**
- Repository: https://github.com/Intelliflo/Intelliflo.Platform.QueryLang

**Example Queries:**
```
?filter=name eq 'stuart' and person.lastname startswith 'cull'
?filter=person.age gt 50 and person.salutation in ('Mr', 'Master')
?filter=isArchived eq false and createdAt gt '2023-01-01T00:00:00Z'
```

**Operators:**
- Comparison: `eq`, `ne`, `gt`, `ge`, `lt`, `le`
- Logical: `and`, `or`, `not`
- String: `startswith`, `endswith`, `contains`
- Collection: `in`

### 9.3 Archived Resources

**Default Behavior:**
- Archived resources SHOULD be returned by default

**Filtering:**
- Add `IsArchived` filter for GET (list) operations
- Allows filtering for archived-only or non-archived-only resources

**Examples:**
```
GET /v2/clients?filter=isArchived eq false  // Non-archived only
GET /v2/clients?filter=isArchived eq true   // Archived only
GET /v2/clients                             // All (default)
```

### 9.4 Pagination

**Requirements:**
- Use pagination for all collection endpoints
- Implement default page size (`top` value)
- Support sorting and filtering

**Standard Query Parameters:**
```
?page=2&size=20&sort=createdAt desc
?top=50&skip=100
```

**Response Pattern:**
- Include pagination links using `_href` suffix pattern
- Provide `next_href`, `prev_href`, `first_href`, `last_href`
- Include total count where appropriate

### 9.5 Sorting

**Standard Parameter:**
```
?sort=lastName asc, firstName asc
?sort=-createdAt  // Descending (minus prefix)
```

### 9.6 Single Contract Principle

**Rule:**
- Use the SAME contract for request and response where possible
- Consistency improves developer experience
- Reduces cognitive load and errors

**Exceptions:**
- Read-only computed fields (include in response only)
- Fields that cannot be modified after creation

---

## 10. V3 API Application Notes

### 10.1 Key Principles for V3 Design

1. **Naming Consistency:**
   - Resource types: PascalCase, singular (e.g., `Client`, `Plan`)
   - Reference types: Suffix with `Ref` (e.g., `ClientRef`, `PlanRef`)
   - Value types: Suffix with `Value` (e.g., `PersonValue`, `AddressValue`)
   - Properties: camelCase (e.g., `firstName`, `createdAt`)
   - URIs: lowercase, plural (e.g., `/clients`, `/plans`)
   - Parameters: camelCase, singular (e.g., `clientId`, `planId`)

2. **Resource References:**
   - Minimum: `id` and `href`
   - Named references: Add `name`, prefix type with `Named`
   - Maximum 3 properties (including `id` and `href`)
   - Name the relationship, not the object

3. **Hypermedia:**
   - Collection links: Use `_href` suffix
   - Single resource links: Use reference objects
   - Always include `self_href` on resources

4. **Dates and Times:**
   - DateTime: ISO8601 with UTC (`yyyy-MM-ddTHH:mm:ssZ`)
   - Date: ISO8601 date only (`yyyy-MM-dd`)
   - Property naming: `At` for DateTime, `On` for Date

5. **HTTP Methods:**
   - POST returns 201 with Location header
   - GET returns 200
   - PUT/PATCH returns 200 or 204
   - DELETE returns 204
   - Include resource in response if Accept header present

6. **Error Handling:**
   - Always include error body for 4xx and 5xx
   - Format: `{"code": "...", "message": "..."}`
   - Include `x-IoErrorType` and `x-IoRequestId` headers

7. **Events:**
   - Naming: `[Resource][Created|Changed|Deleted]`
   - Payload: Full resource contract
   - Publish for all write operations

8. **Documentation:**
   - Summary: < 100 characters, standard format
   - Complete parameter documentation
   - Include examples for all endpoints
   - Document validation rules

9. **Backward Compatibility:**
   - Design for evolution
   - Use versioning for breaking changes
   - Consider optional fields and sensible defaults

10. **Developer Experience:**
    - Prioritize clarity over cleverness
    - Maintain consistency across all endpoints
    - Make APIs discoverable and self-describing
    - Provide clear error messages

### 10.2 V3 Checklist

Before finalizing V3 API contracts, verify:

- [ ] All resource URIs are lowercase and plural
- [ ] All type names are PascalCase and singular
- [ ] Reference types use `Ref` suffix, value types use `Value` suffix
- [ ] Properties are camelCase with appropriate suffixes (`At`, `On`)
- [ ] No properties end in "id" (use references instead)
- [ ] HTTP methods are used correctly with proper status codes
- [ ] Error responses include code and message
- [ ] DateTimes are ISO8601 UTC format
- [ ] Money uses `CurrencyValue2` object
- [ ] Countries/counties use ISO codes with `Ref` objects
- [ ] Hypermedia links use `_href` suffix or reference objects
- [ ] Events follow `[Resource][Verb]` naming pattern
- [ ] Documentation summaries are < 100 characters
- [ ] All parameters are fully documented
- [ ] Pagination is supported on collection endpoints
- [ ] Filtering uses custom query language
- [ ] Archived resources are handled appropriately
- [ ] Single contract principle applied where possible
- [ ] Prefer headers supported on GET operations
- [ ] Custom headers use `x-iflo-*` prefix

---

## 11. Do's and Don'ts

### ✅ DO

- **DO** use RESTful principles for all APIs
- **DO** pluralize resource URIs (`/clients`, not `/client`)
- **DO** use lowercase for URIs
- **DO** use camelCase for properties and parameters
- **DO** use PascalCase for type names
- **DO** suffix reference types with `Ref`
- **DO** suffix value types with `Value`
- **DO** suffix DateTime properties with `At`
- **DO** suffix Date properties with `On`
- **DO** use ISO8601 for dates and times
- **DO** store and return DateTimes as UTC
- **DO** use `CurrencyValue2` for money
- **DO** use ISO codes for countries and counties
- **DO** include hypermedia links for navigation
- **DO** return appropriate HTTP status codes
- **DO** include error details in 4xx and 5xx responses
- **DO** publish events for all write operations
- **DO** document all endpoints thoroughly
- **DO** support pagination on collections
- **DO** design for backward compatibility
- **DO** prioritize consumer experience
- **DO** use consistent patterns across all endpoints
- **DO** validate inputs and return clear error messages
- **DO** use the single contract principle

### ❌ DON'T

- **DON'T** end property names with "id" (use references)
- **DON'T** use singular resource URIs
- **DON'T** mix casing conventions
- **DON'T** use verbs in resource URIs
- **DON'T** use non-standard HTTP methods
- **DON'T** return inappropriate status codes
- **DON'T** omit error details for failures
- **DON'T** use JSON float for decimal/currency values
- **DON'T** include time component for date-only values
- **DON'T** return local times without timezone info
- **DON'T** skip event publication for write operations
- **DON'T** use cryptic or missing documentation
- **DON'T** forget pagination on large collections
- **DON'T** break backward compatibility without versioning
- **DON'T** prioritize developer convenience over consumer experience
- **DON'T** create inconsistent patterns across endpoints
- **DON'T** make network calls to populate resource references
- **DON'T** include more than 3 properties in references (without justification)
- **DON'T** duplicate resource reference definitions in Swagger
- **DON'T** use custom headers without `x-iflo-*` prefix

---

## 12. Quick Reference Examples

### Example 1: Complete Resource with References and Hypermedia

```json
{
  "id": 12345,
  "self_href": "/v3/clients/12345",
  "firstName": "John",
  "lastName": "Smith",
  "dateOfBirth": "1980-05-15",
  "createdAt": "2023-01-15T10:30:00Z",
  "modifiedAt": "2023-10-15T14:20:00Z",
  "isArchived": false,
  "primaryAdviser": {
    "id": 789,
    "name": "Jane Doe",
    "href": "/v3/advisers/789"
  },
  "address": {
    "line1": "123 Main Street",
    "city": "London",
    "postcode": "SW1A 1AA",
    "country": {
      "code": "GB",
      "name": "United Kingdom"
    }
  },
  "plans_href": "/v3/clients/12345/plans",
  "documents_href": "/v3/clients/12345/documents"
}
```

### Example 2: Collection Response with Pagination

```json
{
  "items": [
    {
      "id": 1,
      "self_href": "/v3/clients/1",
      "firstName": "John",
      "lastName": "Smith"
    },
    {
      "id": 2,
      "self_href": "/v3/clients/2",
      "firstName": "Jane",
      "lastName": "Doe"
    }
  ],
  "total": 150,
  "page": 1,
  "size": 20,
  "self_href": "/v3/clients?page=1&size=20",
  "next_href": "/v3/clients?page=2&size=20",
  "last_href": "/v3/clients?page=8&size=20"
}
```

### Example 3: POST Request/Response

**Request:**
```
POST /v3/clients
Accept: application/json
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Smith",
  "dateOfBirth": "1980-05-15",
  "primaryAdviser": {
    "id": 789,
    "href": "/v3/advisers/789"
  }
}
```

**Response:**
```
HTTP/1.1 201 Created
Location: /v3/clients/12345
Content-Type: application/json

{
  "id": 12345,
  "self_href": "/v3/clients/12345",
  "firstName": "John",
  "lastName": "Smith",
  "dateOfBirth": "1980-05-15",
  "createdAt": "2023-10-15T14:30:00Z",
  "modifiedAt": "2023-10-15T14:30:00Z",
  "isArchived": false,
  "primaryAdviser": {
    "id": 789,
    "name": "Jane Doe",
    "href": "/v3/advisers/789"
  }
}
```

### Example 4: Error Response

**Request:**
```
POST /v3/clients
Content-Type: application/json

{
  "firstName": "",
  "lastName": "Smith"
}
```

**Response:**
```
HTTP/1.1 400 Bad Request
Content-Type: application/json
x-IoErrorType: ValidationException
x-IoRequestId: 9886b663-bc4c-420a-ad34-ac59acd4c086

{
  "code": "VALIDATION_FAILED",
  "message": "firstName is required and cannot be empty"
}
```

### Example 5: Event Message

```json
{
  "Event": "ClientCreated",
  "Payload": {
    "id": 12345,
    "self_href": "/v3/clients/12345",
    "firstName": "John",
    "lastName": "Smith",
    "dateOfBirth": "1980-05-15",
    "createdAt": "2023-10-15T14:30:00Z",
    "modifiedAt": "2023-10-15T14:30:00Z",
    "isArchived": false,
    "primaryAdviser": {
      "id": 789,
      "name": "Jane Doe",
      "href": "/v3/advisers/789"
    }
  },
  "Headers": {
    "X-IoRequestId": "9886b663-bc4c-420a-ad34-ac59acd4c086"
  },
  "Id": "b2b74845-ecb5-4866-a93e-2c532ce2082d",
  "TimeStamp": "2023-10-15T14:30:02.8086122Z"
}
```

---

## Conclusion

These guidelines provide a comprehensive framework for designing consistent, maintainable, and developer-friendly V3 APIs. The key is to follow RESTful principles, maintain naming consistency, properly use HTTP semantics, and always prioritize the consumer experience.

When in doubt, refer back to these core principles:
1. Be consistent
2. Be simple
3. Be predictable
4. Be well-documented
5. Be backwards compatible

By adhering to these guidelines, V3 APIs will be easier to understand, integrate, and evolve over time.
