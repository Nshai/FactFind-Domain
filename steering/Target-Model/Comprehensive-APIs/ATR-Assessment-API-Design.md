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


### ATR Assessment Resource Properties

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
| `questions` | ListofComplexData |  | 15 standard ATR questions with client answers |
| `reviewDate` | date |  | Date when this assessment should be reviewed |
| `riskProfiles` | Complex Data |  | Generated and chosen risk profiles |
| `supplementaryQuestions` | ListofComplexData |  | 45 additional context questions with answers |
| `templateRef` | Complex Data |  | Reference to the ATR template used |
| `totalScore` | integer |  | Total weighted score from all questions |
| `updatedAt` | date |  | When this record was last modified |


### Related Resources

*See parent document for related entities.*


### Referenced Type Definitions

The following types are referenced in the resource properties above:

### Complex Data Structure

*Nested object structure* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

### Reference Link Structure

*Reference to another entity* - See [FactFind Contracts Reference](../../FactFind-Contracts-Reference.md) for complete definition.

## Data Model