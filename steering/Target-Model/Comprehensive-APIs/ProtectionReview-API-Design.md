# Protection Review API Design

**Version:** 2.0
**Date:** 2026-03-05
**Status:** Current

## Table of Contents

1. [Introduction](#1-introduction)
2. [Business Context](#2-business-context)
3. [API Overview](#3-api-overview)
4. [Resource Model](#4-resource-model)
5. [API Operations](#5-api-operations)
6. [Request/Response Specifications](#6-requestresponse-specifications)
7. [Data Model](#7-data-model)
8. [Business Rules](#8-business-rules)
9. [Error Handling](#9-error-handling)
10. [Security](#10-security)
11. [Performance](#11-performance)
12. [Testing](#12-testing)
13. [References](#13-references)
14. [Appendices](#14-appendices)

---

## 1. Introduction

### 1.1 Purpose

The Protection Review API provides management of protection needs analysis and review information within the FactFind system. It captures whether clients have adequate protection coverage across three key areas: Life & Critical Illness, Income Protection, and Buildings & Contents insurance.

### 1.2 Scope

This API covers:
- Protection review summary (all three areas in one response)
- Life and Critical Illness protection review
- Income Protection review
- Buildings and Contents insurance review
- Impact assessment and action planning
- Review timing and reasons for not reviewing

**Out of Scope:**
- Actual protection policy details (covered by PersonalProtection API)
- Policy recommendations (handled by advice systems)
- Policy applications (handled by application systems)

### 1.3 Conventions

- **Singleton Resource**: One protection review record per FactFind (not per client)
- **Section-Based Updates**: Three separate PUT endpoints for updating each protection area
- **Summary Endpoint**: Single GET endpoint returns all sections
- **Simple Hypermedia**: Resources include `href` property for navigation
- **All Fields Optional**: Clients may not review all protection areas
- All text fields support free-text entry for notes and reasoning
- Enum fields use specific allowed values
- All dates use ISO 8601 format (YYYY-MM-DD)
- **Intelliflo Standards**: Follows Intelliflo API design guidelines

---

## 2. Business Context

### 2.1 Business Requirements

Protection review is essential for:
1. **Needs Analysis**: Identify gaps in client protection coverage
2. **FCA Compliance**: Document suitability of protection advice
3. **Vulnerability Awareness**: Understand impact on vulnerable dependants
4. **Holistic Advice**: Consider protection alongside other financial planning
5. **Client Outcomes**: Ensure clients understand protection needs and impacts
6. **Review Triggers**: Capture when clients want to review protection

### 2.2 Use Cases

**UC-PR-01: Life Cover Review for Mortgage**
- Client has mortgage debt
- Assess if life cover sufficient to repay mortgage on death
- Document cover adequacy: Yes/No/NotApplicable
- Capture impact on dependants if insufficient
- Plan actions to address gaps

**UC-PR-02: Critical Illness Protection Assessment**
- Client has dependants and mortgage
- Assess if critical illness cover adequate
- Document impact if client diagnosed with critical illness
- Identify actions needed (increase cover, new policy, etc.)

**UC-PR-03: Income Protection Gap Analysis**
- Client is sole earner with dependants
- Assess cover for accident, illness, unemployment
- Document financial impact of income loss
- Plan protection strategy

**UC-PR-04: Buildings and Contents Review**
- Client owns residential property
- Verify buildings and contents insurance in place
- Check buy-to-let property insurance
- Assess adequacy of cover
- Schedule next review

**UC-PR-05: Protection Declined**
- Client chooses not to review protection
- Document reason for not reviewing
- Record client decision for compliance

### 2.3 Constraints

- Singleton pattern: one protection review per FactFind
- Section-based updates: three separate PUT endpoints
- Read-only summary: GET returns combined view
- All fields optional: flexibility for partial completion

---

## 3. API Overview

### 3.1 Resource Model

```
ProtectionReviewSummary (singleton per FactFind)
├── href
├── lifeAndCriticalIllness
│   ├── hasCoverForMortgageOrDebt (enum: Yes/No/NotApplicable)
│   ├── hasCoverforDependantsDueToCritcalIllness (enum: Yes/No)
│   ├── hasCoverforDependantsUponDeath (enum: Yes/No/NotApplicable)
│   ├── hasReviewedCostofProtectionChange (enum: Yes/No)
│   ├── impactOnYou (text)
│   ├── impactOnDepandants (text)
│   ├── actionsToAddressImpacts (text)
│   └── reasonforNotReviewing (text)
├── incomeProtection
│   ├── hasCoverDueToAccidentOrIllness (boolean)
│   ├── hasCoverDueToUnemployment (boolean)
│   ├── impactOnYou (text)
│   ├── impactOnDepandants (text)
│   ├── actionsToAddressImpacts (text)
│   └── reasonforNotReviewing (text)
└── buildingsAndContent
    ├── hasExistingBuildingInsurance (boolean)
    ├── hasExistingContentInsurance (boolean)
    ├── buyToLetProperties
    │   └── haveBuildingContentInsurance (boolean)
    ├── hasSufficientCover (boolean)
    ├── actionsToAddressImpacts (text)
    ├── whenDoyouWantToReviewProtection (text)
    └── reasonforNotReviewing (text)
```

### 3.2 Resource Characteristics

| Characteristic | Value |
|---|---|
| Resource Type | Singleton with section-based updates |
| Mutability | Fully mutable via PUT operations |
| Lifecycle | Created on first PUT, persists with FactFind |
| Versioning | Implicit via timestamps |
| Parent Resource | FactFind |

---

## 4. Resource Model

### 4.1 Resource Structure

**Protection Review Summary:**
- One record per FactFind
- Three main sections: lifeAndCriticalIllness, incomeProtection, buildingsAndContent
- GET returns all sections combined
- PUT endpoints update individual sections

**Sections:**
- **Life & Critical Illness**: Focuses on death and critical illness cover for debt and dependants
- **Income Protection**: Focuses on income replacement during illness, accident, or unemployment
- **Buildings & Content**: Focuses on property insurance (residential and buy-to-let)

### 4.2 Resource Relationships

```
FactFind (1) ──→ (1) ProtectionReviewSummary
FactFind (1) ──→ (N) PersonalProtection [actual policies]
FactFind (1) ──→ (N) Client [individuals covered]
```

### 4.3 Resource Lifecycle

**Protection Review Record:**
1. **Not Exists**: FactFind has no protection review (GET returns 404 or empty structure)
2. **Created**: First PUT to any section creates the singleton
3. **Partially Complete**: Some sections updated, others empty
4. **Complete**: All relevant sections updated
5. **Updated**: Subsequent PUTs modify existing sections
6. **Persists**: Remains throughout FactFind lifecycle

---

## 5. API Operations

### 5.1 Operation Summary

| Operation | Method | Endpoint | Description |
|---|---|---|---|
| Get Protection Review Summary | GET | `/v2/factfinds/{id}/protections/reviews/summary` | Retrieve complete protection review |
| Update Life & Critical Illness | PUT | `/v2/factfinds/{id}/protections/reviews/lifeAndCriticalIllness` | Update life & critical illness section |
| Update Income Protection | PUT | `/v2/factfinds/{id}/protections/reviews/incomeProtection` | Update income protection section |
| Update Buildings & Content | PUT | `/v2/factfinds/{id}/protections/reviews/buildingsAndContent` | Update buildings & content section |

### 5.2 Get Protection Review Summary

**Endpoint:** `GET /v2/factfinds/{id}/protections/reviews/summary`

**Description:** Retrieves the complete protection review summary including all three sections.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Response Codes:**
- `200 OK`: Protection review found
- `404 Not Found`: No protection review exists for this FactFind (or return empty structure)
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** ProtectionReviewSummary object (see section 6.1)

### 5.3 Update Life & Critical Illness

**Endpoint:** `PUT /v2/factfinds/{id}/protections/reviews/lifeAndCriticalIllness`

**Description:** Creates or updates the Life & Critical Illness section of the protection review.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Request Body:** LifeAndCriticalIllness object

**Response Codes:**
- `200 OK`: Section updated
- `201 Created`: Section created (first PUT)
- `400 Bad Request`: Invalid data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** Updated LifeAndCriticalIllness object

### 5.4 Update Income Protection

**Endpoint:** `PUT /v2/factfinds/{id}/protections/reviews/incomeProtection`

**Description:** Creates or updates the Income Protection section of the protection review.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Request Body:** IncomeProtection object

**Response Codes:**
- `200 OK`: Section updated
- `201 Created`: Section created (first PUT)
- `400 Bad Request`: Invalid data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** Updated IncomeProtection object

### 5.5 Update Buildings & Content

**Endpoint:** `PUT /v2/factfinds/{id}/protections/reviews/buildingsAndContent`

**Description:** Creates or updates the Buildings & Content section of the protection review.

**Path Parameters:**
- `id` (integer, required): FactFind identifier

**Request Body:** BuildingsAndContent object

**Response Codes:**
- `200 OK`: Section updated
- `201 Created`: Section created (first PUT)
- `400 Bad Request`: Invalid data
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Insufficient permissions

**Response Body:** Updated BuildingsAndContent object

---

## 6. Request/Response Specifications

### 6.1 Get Protection Review Summary Response

```json
{
  "href": "/v2/factfinds/679/protections/reviews/summary",
  "lifeAndCriticalIllness": {
    "hasCoverForMortgageOrDebt": "Yes",
    "hasCoverforDependantsDueToCritcalIllness": "No",
    "hasCoverforDependantsUponDeath": "Yes",
    "hasReviewedCostofProtectionChange": "Yes",
    "impactOnYou": "If critically ill, mortgage payments would be difficult without cover. May need to sell property.",
    "impactOnDepandants": "Children would need financial support. Spouse would need to return to work immediately.",
    "actionsToAddressImpacts": "Obtain critical illness quote for £250,000. Review existing life cover adequacy. Consider family income benefit.",
    "reasonforNotReviewing": ""
  },
  "incomeProtection": {
    "hasCoverDueToAccidentOrIllness": false,
    "hasCoverDueToUnemployment": false,
    "impactOnYou": "No income for 6 months would deplete emergency fund. Would need to use credit cards.",
    "impactOnDepandants": "Family would need to reduce living standards significantly. May need to move house.",
    "actionsToAddressImpacts": "Get income protection quote. Consider 3-month deferred period to reduce premium. Review emergency fund target.",
    "reasonforNotReviewing": ""
  },
  "buildingsAndContent": {
    "hasExistingBuildingInsurance": true,
    "hasExistingContentInsurance": true,
    "buyToLetProperties": {
      "haveBuildingContentInsurance": true
    },
    "hasSufficientCover": true,
    "actionsToAddressImpacts": "",
    "whenDoyouWantToReviewProtection": "Annual review at renewal in September",
    "reasonforNotReviewing": ""
  }
}
```

### 6.2 Update Life & Critical Illness Request/Response

**Request:**
```json
{
  "hasCoverForMortgageOrDebt": "Yes",
  "hasCoverforDependantsDueToCritcalIllness": "No",
  "hasCoverforDependantsUponDeath": "Yes",
  "hasReviewedCostofProtectionChange": "Yes",
  "impactOnYou": "If critically ill, mortgage payments would be difficult without cover. May need to sell property.",
  "impactOnDepandants": "Children would need financial support. Spouse would need to return to work immediately.",
  "actionsToAddressImpacts": "Obtain critical illness quote for £250,000. Review existing life cover adequacy. Consider family income benefit.",
  "reasonforNotReviewing": ""
}
```

**Response:** 200 OK
Same structure as request.

### 6.3 Update Income Protection Request/Response

**Request:**
```json
{
  "hasCoverDueToAccidentOrIllness": false,
  "hasCoverDueToUnemployment": false,
  "impactOnYou": "No income for 6 months would deplete emergency fund. Would need to use credit cards.",
  "impactOnDepandants": "Family would need to reduce living standards significantly. May need to move house.",
  "actionsToAddressImpacts": "Get income protection quote. Consider 3-month deferred period to reduce premium. Review emergency fund target.",
  "reasonforNotReviewing": ""
}
```

**Response:** 200 OK
Same structure as request.

### 6.4 Update Buildings & Content Request/Response

**Request:**
```json
{
  "hasExistingBuildingInsurance": true,
  "hasExistingContentInsurance": true,
  "buyToLetProperties": {
    "haveBuildingContentInsurance": true
  },
  "hasSufficientCover": true,
  "actionsToAddressImpacts": "",
  "whenDoyouWantToReviewProtection": "Annual review at renewal in September",
  "reasonforNotReviewing": ""
}
```

**Response:** 200 OK
Same structure as request.

### 6.5 Client Declining Review Example

**Life & Critical Illness - Client Declined:**
```json
{
  "hasCoverForMortgageOrDebt": "NotApplicable",
  "hasCoverforDependantsDueToCritcalIllness": "No",
  "hasCoverforDependantsUponDeath": "NotApplicable",
  "hasReviewedCostofProtectionChange": "No",
  "impactOnYou": "",
  "impactOnDepandants": "",
  "actionsToAddressImpacts": "",
  "reasonforNotReviewing": "Client declined to review life and critical illness protection at this time. Prefer to focus on investment planning. Will review in 12 months."
}
```

---

## 7. Data Model

### 7.1 ProtectionReviewSummary Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| href | string | Yes | Yes | API resource link |
| lifeAndCriticalIllness | LifeAndCriticalIllness | No | No | Life & critical illness review section |
| incomeProtection | IncomeProtection | No | No | Income protection review section |
| buildingsAndContent | BuildingsAndContent | No | No | Buildings & content review section |

### 7.2 LifeAndCriticalIllness Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| hasCoverForMortgageOrDebt | enum | No | No | Has life cover for mortgage/debt (Yes, No, NotApplicable) |
| hasCoverforDependantsDueToCritcalIllness | enum | No | No | Has critical illness cover for dependants (Yes, No) |
| hasCoverforDependantsUponDeath | enum | No | No | Has life cover for dependants (Yes, No, NotApplicable) |
| hasReviewedCostofProtectionChange | enum | No | No | Has reviewed cost of protection change (Yes, No) |
| impactOnYou | string | No | No | Financial impact on client (max 2000 chars) |
| impactOnDepandants | string | No | No | Financial impact on dependants (max 2000 chars) |
| actionsToAddressImpacts | string | No | No | Planned actions to address gaps (max 2000 chars) |
| reasonforNotReviewing | string | No | No | Reason for not reviewing protection (max 1000 chars) |

### 7.3 IncomeProtection Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| hasCoverDueToAccidentOrIllness | boolean | No | No | Has income protection for accident/illness |
| hasCoverDueToUnemployment | boolean | No | No | Has income protection for unemployment |
| impactOnYou | string | No | No | Financial impact on client (max 2000 chars) |
| impactOnDepandants | string | No | No | Financial impact on dependants (max 2000 chars) |
| actionsToAddressImpacts | string | No | No | Planned actions to address gaps (max 2000 chars) |
| reasonforNotReviewing | string | No | No | Reason for not reviewing protection (max 1000 chars) |

### 7.4 BuildingsAndContent Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| hasExistingBuildingInsurance | boolean | No | No | Has buildings insurance |
| hasExistingContentInsurance | boolean | No | No | Has contents insurance |
| buyToLetProperties | BuyToLetProperties | No | No | Buy-to-let property insurance details |
| hasSufficientCover | boolean | No | No | Has sufficient insurance cover |
| actionsToAddressImpacts | string | No | No | Planned actions to address gaps (max 2000 chars) |
| whenDoyouWantToReviewProtection | string | No | No | When to review protection (max 500 chars) |
| reasonforNotReviewing | string | No | No | Reason for not reviewing protection (max 1000 chars) |

### 7.5 BuyToLetProperties Schema

| Field | Type | Required | Read-Only | Description |
|---|---|---|---|---|
| haveBuildingContentInsurance | boolean | No | No | Has building & content insurance for buy-to-let properties |

### 7.6 Enumerations

**CoverageStatus** (used for life & critical illness fields):
- `Yes` - Has adequate cover
- `No` - Does not have cover or inadequate
- `NotApplicable` - Not applicable to client situation

**ReviewStatus** (used for hasReviewedCostofProtectionChange):
- `Yes` - Has reviewed
- `No` - Has not reviewed

---

## 8. Business Rules

### 8.1 Singleton Resource Rules

**BR-PR-01: One Record Per FactFind**
- Only one protection review record exists per FactFind
- First PUT to any section creates the singleton
- Subsequent PUTs update individual sections
- GET returns all sections combined

**BR-PR-02: Section Independence**
- Each section can be updated independently
- Updating one section does not affect others
- Partial completion is permitted

### 8.2 Field Validation Rules

**BR-PR-03: Enum Value Validation**
- Life & critical illness coverage fields must use: Yes, No, or NotApplicable
- Review status fields must use: Yes or No
- Invalid enum values return 400 Bad Request

**BR-PR-04: Boolean Field Defaults**
- Boolean fields (income protection, buildings & content) default to null/unset
- Client can explicitly set true or false
- Null indicates not yet reviewed

**BR-PR-05: Text Field Limits**
- Impact and action fields: 2000 characters maximum
- Reason for not reviewing: 1000 characters maximum
- Review timing field: 500 characters maximum
- Exceeding limits returns 400 Bad Request

### 8.3 Business Logic Rules

**BR-PR-06: NotApplicable Usage**
- `NotApplicable` valid when client has no mortgage/debt or no dependants
- Example: Single client, no debt = hasCoverForMortgageOrDebt: "NotApplicable"
- Allows distinction between "No cover" and "Not needed"

**BR-PR-07: Reason for Not Reviewing**
- If client declines review, document reason in reasonforNotReviewing field
- Required for compliance and future reference
- Demonstrates client-led decision making

**BR-PR-08: Impact Assessment**
- If cover inadequate (No), should document impacts
- impactOnYou and impactOnDepandants capture financial/lifestyle effects
- Helps client understand importance of protection

**BR-PR-09: Action Planning**
- If gaps identified, should document actions in actionsToAddressImpacts
- Actions should be specific and actionable
- Examples: "Obtain quote", "Increase cover amount", "Review at next annual meeting"

### 8.4 FCA Compliance Rules

**BR-PR-10: Suitability Documentation**
- Protection review forms part of suitability assessment
- Document client decisions (reviewing or declining)
- Capture rationale for recommendations
- Record client understanding of impacts

**BR-PR-11: Vulnerable Customers**
- Pay particular attention to impactOnDepandants field
- Identify if dependants are vulnerable (children, disabled, elderly)
- Enhanced duty of care under Consumer Duty

**BR-PR-12: Consumer Duty**
- Ensure clients understand consequences of inadequate protection
- Document that impacts have been explained and understood
- Capture client-led decisions about protection priorities

---

## 9. Error Handling

### 9.1 Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid coverage status value",
    "details": [
      {
        "field": "hasCoverForMortgageOrDebt",
        "issue": "Value must be 'Yes', 'No', or 'NotApplicable'",
        "value": "Maybe"
      }
    ]
  }
}
```

### 9.2 Common Error Codes

| Code | HTTP Status | Description |
|---|---|---|
| PROTECTION_REVIEW_NOT_FOUND | 404 | Protection review doesn't exist |
| VALIDATION_ERROR | 400 | Request data validation failed |
| INVALID_ENUM_VALUE | 400 | Enum field has invalid value |
| TEXT_TOO_LONG | 400 | Text field exceeds maximum length |
| UNAUTHORIZED | 401 | Authentication required |
| FORBIDDEN | 403 | Insufficient permissions |

### 9.3 Validation Error Examples

**Invalid Enum Value:**
```json
{
  "error": {
    "code": "INVALID_ENUM_VALUE",
    "message": "Invalid value for coverage status field",
    "details": [
      {
        "field": "hasCoverforDependantsUponDeath",
        "issue": "Value must be 'Yes', 'No', or 'NotApplicable'",
        "value": "Unknown",
        "allowedValues": ["Yes", "No", "NotApplicable"]
      }
    ]
  }
}
```

**Text Field Too Long:**
```json
{
  "error": {
    "code": "TEXT_TOO_LONG",
    "message": "Field exceeds maximum length",
    "details": [
      {
        "field": "impactOnYou",
        "issue": "Maximum 2000 characters allowed",
        "length": 2347
      }
    ]
  }
}
```

---

## 10. Security

### 10.1 Authentication

- All endpoints require valid authentication token
- Token must be included in `Authorization` header
- Format: `Authorization: Bearer {token}`
- Expired tokens return 401 Unauthorized

### 10.2 Authorization

**Resource-Level Permissions:**
- User must have access to the FactFind
- User must have permission to view/edit FactFind data
- Adviser can only access their own FactFind records
- Admin users can access all records within their organization

**Operation-Level Permissions:**
- `GET`: Requires "View FactFind Data" permission
- `PUT`: Requires "Edit FactFind Data" permission

### 10.3 Data Protection

**Sensitive Information:**
- Protection review reveals financial vulnerabilities
- Impact assessments may contain personal circumstances
- Reasons for not reviewing may indicate financial stress
- Access logs maintained for audit purposes

**GDPR Compliance:**
- Protection review data is personal data under GDPR
- Client consent required for processing
- Right to access: clients can request their protection review data
- Right to erasure: clients can request deletion (subject to retention rules)

---

## 11. Performance

### 11.1 Response Time Targets

| Operation | Target | Maximum |
|---|---|---|
| GET Summary | < 200ms | 500ms |
| PUT Section | < 300ms | 1000ms |

### 11.2 Caching

**Protection Review Summary:**
- Cache-Control: private, max-age=300 (5 minutes)
- ETag support for conditional requests
- Last-Modified header included

### 11.3 Rate Limiting

- 100 requests per minute per user
- 1000 requests per hour per organization
- Rate limit headers included in responses

---

## 12. Testing

### 12.1 Test Scenarios

**TS-PR-01: Create Complete Protection Review**
1. FactFind has no protection review
2. PUT to lifeAndCriticalIllness section
3. PUT to incomeProtection section
4. PUT to buildingsAndContent section
5. GET summary returns all three sections
6. Verify all data persisted correctly

**TS-PR-02: Adequate Coverage Scenario**
1. PUT life & critical illness with all fields "Yes"
2. Verify no impacts or actions needed
3. PUT income protection with both boolean fields true
4. PUT buildings & content with sufficient cover
5. GET summary shows comprehensive protection

**TS-PR-03: Protection Gaps Identified**
1. PUT life & critical illness with "No" for critical illness
2. Document impacts on client and dependants
3. Document actions to address gaps
4. Verify impacts and actions captured
5. GET summary shows gaps and action plan

**TS-PR-04: Client Declines Review**
1. PUT life & critical illness with NotApplicable values
2. Set hasReviewedCostofProtectionChange to "No"
3. Document reason for not reviewing
4. Verify client decision recorded
5. Compliance evidence captured

**TS-PR-05: Buy-to-Let Property Insurance**
1. PUT buildings & content section
2. Set buyToLetProperties.haveBuildingContentInsurance to true
3. Verify nested object persisted
4. GET summary returns buy-to-let details

**TS-PR-06: Validate Enum Values**
1. Attempt PUT with invalid enum value ("Maybe")
2. Verify 400 Bad Request returned
3. Verify error message indicates allowed values

**TS-PR-07: Validate Text Field Lengths**
1. Attempt PUT with 2500-character impactOnYou
2. Verify 400 Bad Request returned
3. Verify error indicates maximum length

**TS-PR-08: Update Individual Section**
1. Protection review exists with all sections
2. PUT to update only incomeProtection section
3. Verify only incomeProtection section changed
4. Verify other sections unchanged

**TS-PR-09: Partial Completion**
1. PUT only lifeAndCriticalIllness section
2. GET summary returns lifeAndCriticalIllness populated
3. Verify other sections null or empty
4. Demonstrates valid partial completion

**TS-PR-10: Not Applicable Scenarios**
1. Single client, no dependants
2. PUT hasCoverforDependantsUponDeath: "NotApplicable"
3. No mortgage, no debt
4. PUT hasCoverForMortgageOrDebt: "NotApplicable"
5. Verify distinction from "No"

### 12.2 Sample Test Data

**Comprehensive Protection:**
```json
{
  "lifeAndCriticalIllness": {
    "hasCoverForMortgageOrDebt": "Yes",
    "hasCoverforDependantsDueToCritcalIllness": "Yes",
    "hasCoverforDependantsUponDeath": "Yes",
    "hasReviewedCostofProtectionChange": "Yes",
    "impactOnYou": "",
    "impactOnDepandants": "",
    "actionsToAddressImpacts": "Review cover levels annually",
    "reasonforNotReviewing": ""
  },
  "incomeProtection": {
    "hasCoverDueToAccidentOrIllness": true,
    "hasCoverDueToUnemployment": true,
    "impactOnYou": "",
    "impactOnDepandants": "",
    "actionsToAddressImpacts": "Review deferred period and benefit amount at next review",
    "reasonforNotReviewing": ""
  },
  "buildingsAndContent": {
    "hasExistingBuildingInsurance": true,
    "hasExistingContentInsurance": true,
    "buyToLetProperties": {
      "haveBuildingContentInsurance": true
    },
    "hasSufficientCover": true,
    "actionsToAddressImpacts": "",
    "whenDoyouWantToReviewProtection": "Annual review at renewal",
    "reasonforNotReviewing": ""
  }
}
```

**Protection Gaps:**
```json
{
  "lifeAndCriticalIllness": {
    "hasCoverForMortgageOrDebt": "No",
    "hasCoverforDependantsDueToCritcalIllness": "No",
    "hasCoverforDependantsUponDeath": "No",
    "hasReviewedCostofProtectionChange": "Yes",
    "impactOnYou": "Mortgage debt would remain. Property may need to be sold. No lump sum for family expenses.",
    "impactOnDepandants": "Spouse would need to work full-time immediately. Children's education plans would change. Significant lifestyle reduction.",
    "actionsToAddressImpacts": "Obtain term life quote for £300,000. Get critical illness quote. Compare family income benefit options. Review budget to accommodate premiums.",
    "reasonforNotReviewing": ""
  },
  "incomeProtection": {
    "hasCoverDueToAccidentOrIllness": false,
    "hasCoverDueToUnemployment": false,
    "impactOnYou": "Emergency fund covers 3 months only. Would need to use credit. Standard of living would drop significantly.",
    "impactOnDepandants": "Children would need to change schools. Family holidays cancelled. May need to downsize house.",
    "actionsToAddressImpacts": "Get income protection quotes from 3 providers. Consider 12-week deferred period. Review employer sick pay provision. Build emergency fund to 6 months.",
    "reasonforNotReviewing": ""
  },
  "buildingsAndContent": {
    "hasExistingBuildingInsurance": false,
    "hasExistingContentInsurance": false,
    "buyToLetProperties": {
      "haveBuildingContentInsurance": false
    },
    "hasSufficientCover": false,
    "actionsToAddressImpacts": "Arrange buildings and contents insurance immediately. Review buy-to-let insurance requirements. Compare quotes from 3 providers.",
    "whenDoyouWantToReviewProtection": "Within 2 weeks",
    "reasonforNotReviewing": ""
  }
}
```

**Client Declined:**
```json
{
  "lifeAndCriticalIllness": {
    "hasCoverForMortgageOrDebt": "NotApplicable",
    "hasCoverforDependantsDueToCritcalIllness": "No",
    "hasCoverforDependantsUponDeath": "NotApplicable",
    "hasReviewedCostofProtectionChange": "No",
    "impactOnYou": "",
    "impactOnDepandants": "",
    "actionsToAddressImpacts": "",
    "reasonforNotReviewing": "Client does not wish to discuss protection at this time. Priorities are investment growth and pension planning. Client understands risks. Will review in 12 months or sooner if circumstances change."
  },
  "incomeProtection": {
    "hasCoverDueToAccidentOrIllness": false,
    "hasCoverDueToUnemployment": false,
    "impactOnYou": "",
    "impactOnDepandants": "",
    "actionsToAddressImpacts": "",
    "reasonforNotReviewing": "Client has substantial emergency fund (12 months) and feels this is sufficient. Employer provides 6 months full sick pay. Will reconsider if circumstances change."
  },
  "buildingsAndContent": {
    "hasExistingBuildingInsurance": true,
    "hasExistingContentInsurance": true,
    "buyToLetProperties": {
      "haveBuildingContentInsurance": true
    },
    "hasSufficientCover": true,
    "actionsToAddressImpacts": "",
    "whenDoyouWantToReviewProtection": "Annual review at renewal in November",
    "reasonforNotReviewing": ""
  }
}
```

---

## 13. References

### 13.1 Related APIs

- [FactFind API](./FactFind-API-Design.md) - Parent container
- [PersonalProtection API](./PersonalProtection-API-Design.md) - Actual protection policies
- [Mortgage API](./Mortgage-API-Design.md) - Mortgage debt requiring life cover
- [Client API](./Client-API-Design.md) - Client and dependant information

### 13.2 External Standards

- **REST API Design**: Standard HTTP methods and status codes
- **GDPR**: Data protection and privacy requirements
- **ISO 8601**: Date and datetime formats (if needed in future)

### 13.3 Business Regulations

- **FCA Handbook**: Requirements for protection advice suitability
- **Consumer Duty**: Ensuring good customer outcomes
- **ICOBS (Insurance Conduct of Business)**: Rules for insurance distribution
- **Professional Standards**: Best practices for protection needs analysis

---

## 14. Appendices

### 14.1 Protection Review Best Practices

**Life & Critical Illness:**
- Review when mortgage balance changes
- Review when dependants are born or circumstances change
- Consider level term, decreasing term, or family income benefit
- Critical illness cover important for mortgage protection
- Consider indexation to maintain value against inflation

**Income Protection:**
- Calculate essential monthly expenditure
- Consider deferred period (1, 3, 6, 12 months)
- Check employer sick pay provision
- Consider indexation and guaranteed premiums
- Review against emergency fund

**Buildings & Content:**
- Review annually at renewal
- Ensure rebuild cost adequate (not market value)
- Contents cover should reflect replacement value
- Buy-to-let requires specialist landlord insurance
- Consider accidental damage cover

### 14.2 Common Protection Gaps

**Gap 1: Mortgage Life Cover**
- Many clients have inadequate life cover for mortgage
- Interest-only mortgages need full capital repayment cover
- Repayment mortgages may use decreasing term cover

**Gap 2: Critical Illness**
- Often overlooked vs. life cover
- Important for mortgage and income replacement
- Covers major illnesses like cancer, heart attack, stroke

**Gap 3: Income Protection**
- Most expensive protection product
- Often declined due to cost
- But most likely claim (vs. life or critical illness)
- Employer sick pay often inadequate

**Gap 4: Buildings Insurance**
- Required by mortgage lender
- But sometimes lapses after remortgage
- Rebuild cost ≠ market value (often higher)

**Gap 5: Buy-to-Let Insurance**
- Different from residential insurance
- Standard insurance may not cover let properties
- Landlord insurance essential

### 14.3 FCA Suitability Requirements

**Documentation:**
- Record protection needs analysis
- Document client decisions (accepting or declining recommendations)
- Capture reasons for recommendations
- Record client understanding of impacts

**Consumer Duty:**
- Help clients make informed decisions
- Ensure clients understand consequences
- Act in client's best interests
- Monitor outcomes

**Vulnerability:**
- Identify vulnerable customers
- Enhanced duty of care
- Ensure protection advice suitable
- Consider impact on dependants

### 14.4 Glossary

| Term | Definition |
|---|---|
| Life Cover | Insurance paying lump sum on death |
| Critical Illness | Insurance paying lump sum on diagnosis of specified illnesses |
| Income Protection | Insurance paying regular income if unable to work |
| Term Life | Life cover for fixed term (e.g., 25 years) |
| Decreasing Term | Life cover that reduces over time (matches mortgage repayment) |
| Family Income Benefit | Regular income instead of lump sum (cost-effective) |
| Deferred Period | Waiting time before income protection pays (e.g., 3 months) |
| Buildings Insurance | Cover for structure of property |
| Contents Insurance | Cover for possessions inside property |
| Rebuild Cost | Cost to completely rebuild property (often > market value) |
| Buy-to-Let Insurance | Specialist insurance for rented properties |
| PET | Potentially Exempt Transfer (see Estate Planning API) |

### 14.5 Change History

| Version | Date | Changes | Author |
|---|---|---|---|
| 1.0 | 2025-02-15 | Initial API design | API Team |
| 2.0 | 2026-03-05 | Comprehensive API design with section-based updates | API Team |

---

**Document End**
