# ATR-Assessment API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Risk Profiling

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | ATR-Assessment |
| **Domain** | Risk Profiling |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/...` |
| **Resource Type** | Collection |

### Description

Attitude to Risk assessment

---

## Common Standards

This document contains **entity-specific** information only. For common standards applicable to all APIs, refer to the **[Master API Design Document](./MASTER-API-DESIGN.md)**:

- **Authentication & Authorization** - See Master Doc Section 4
- **Request/Response Standards** - See Master Doc Section 5
- **Error Handling** - See Master Doc Section 6
- **Security Standards** - See Master Doc Section 7
- **Performance Standards** - See Master Doc Section 8
- **Testing Standards** - See Master Doc Section 9

---

## Operation Summary

### Supported Operations

*Refer to source document for detailed operations.*


### Authorization

**Required Scopes:**
- `atr_assessment:read` - Read access (GET operations)
- `atr_assessment:write` - Create and update access (POST, PUT, PATCH)
- `atr_assessment:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary




### ATR-Assessment Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `assessmentDate` | date |  | When the assessment was conducted |
| `assessedBy` | Reference Link |  | Adviser who conducted the assessment |
| `capacityForLoss` | Complex Data |  | Financial capacity to sustain investment losses |
| `client` | Reference Link |  | Reference to the client being assessed |
| `completedAt` | date |  | When assessment was fully completed (all questions + declarations) |
| `createdAt` | date |  | When this record was created in the system |
| `declarations` | Complex Data |  | Client and adviser declarations |
| `factfind` | Reference Link |  | Link to the FactFind that this assessment belongs to |
| `href` | string |  | API resource link |
| `id` | string | ✓ | Unique system identifier for this assessment |
| `maxScore` | integer |  | Maximum possible score for this assessment |
| `questions` | List of Complex Data |  | 15 standard ATR questions with client answers |
| `reviewDate` | date |  | Date when this assessment should be reviewed |
| `riskProfiles` | Complex Data |  | Generated and chosen risk profiles |
| `supplementaryQuestions` | List of Complex Data |  | 45 additional context questions with answers |
| `templateRef` | Complex Data |  | Reference to the ATR template used |
| `totalScore` | integer |  | Total weighted score from all questions |
| `updatedAt` | date |  | When this record was last modified |

*Total: 18 properties*


### Referenced Type Definitions

The following complex types are used in the properties above:

#### assessedBy

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Adviser unique identifier |
| `name` | string | Adviser full name |

#### capacityForLoss

| Field | Type | Description |
|-------|------|-------------|
| `canAffordLosses` | boolean | Can client afford investment losses |
| `emergencyFundMonths` | integer | Months of expenses in emergency fund |
| `essentialExpensesCovered` | boolean | Essential expenses adequately covered |
| `dependantsProvisionAdequate` | boolean | Adequate provision for dependants |
| `assessmentNotes` | string | Adviser assessment notes |

#### client

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for this record |
| `href` | string | API link to client resource |
| `name` | string | Client full name |

#### declarations

| Field | Type | Description |
|-------|------|-------------|
| `clientDeclaration` | Complex Data | Client's declaration |
| `adviserDeclaration` | Complex Data | Adviser's declaration |

#### declarations.adviserDeclaration

| Field | Type | Description |
|-------|------|-------------|
| `declarationType` | string | Type of declaration |
| `declarationText` | string | Full declaration text |
| `signed` | boolean | Whether declaration is signed |
| `signedDate` | date | When declaration was signed |
| `signedBy` | Complex Data | Adviser who signed |

#### declarations.adviserDeclaration.signedBy

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Adviser unique identifier |
| `name` | string | Adviser full name |

#### declarations.clientDeclaration

| Field | Type | Description |
|-------|------|-------------|
| `declarationType` | string | Type of declaration |
| `declarationText` | string | Full declaration text |
| `signed` | boolean | Whether declaration is signed |
| `signedDate` | date | When declaration was signed |
| `signatureType` | string | Type of signature |
| `ipAddress` | string | IP address where signed |

#### factfind

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique system identifier for this record |
| `href` | string | API link to factfind resource |

#### riskProfiles

| Field | Type | Description |
|-------|------|-------------|
| `generated` | List of Complex Data | Three generated risk profiles (main + adjacent) |
| `chosen` | Complex Data | The risk profile chosen by client |

#### riskProfiles.chosen

| Field | Type | Description |
|-------|------|-------------|
| `riskRating` | string | Chosen risk category name |
| `riskScore` | integer | Chosen risk score |
| `chosenBy` | string | Who made the choice |
| `chosenDate` | date | When choice was made |
| `reasonForChoice` | string | Client's reason for choosing this profile |
| `adviserNotes` | string | Adviser notes on the choice |

#### riskProfiles.generated[].assetAllocation

| Field | Type | Description |
|-------|------|-------------|
| `equities` | integer | Equity allocation percentage |
| `bonds` | integer | Bond allocation percentage |
| `cash` | integer | Cash allocation percentage |
| `alternatives` | integer | Alternative investments percentage |

#### template Reference

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Template unique identifier |
| `version` | string | Template version number |
| `name` | string | Template display name |
| `regulatoryApprovalDate` | date | Date template was approved |


### Related Resources

*See parent document for relationships to other entities.*

## Data Model