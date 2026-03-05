# DPA-Agreement API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Client Management

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | DPA-Agreement |
| **Domain** | Client Management |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v3/...` |
| **Resource Type** | Collection |

### Description

Data Processing Agreements

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
- `dpa_agreement:read` - Read access (GET operations)
- `dpa_agreement:write` - Create and update access (POST, PUT, PATCH)
- `dpa_agreement:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary






### DPA-Agreement Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `id` | integer | ✓ | Unique identifier for the DPA agreement |
| `href` | string |  | Resource URL for this agreement |
| `client` | Reference Link |  | Reference to the client |
| `factfind` | Reference Link |  | Reference to the factfind |
| `policy` | Reference Link |  | Reference to the DPA policy |
| `agreedAt` | Date and Time |  | When the client agreed to the policy |
| `statements` | Complex Data |  | Policy statements and responses |
| `createdAt` | Date and Time |  | When this agreement was created (read-only) |
| `createdBy` | string |  | User who created this agreement (read-only) |

*Total: 9 properties*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### Reference Link

Standard reference structure for linked entities:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of referenced entity |
| `href` | string | API endpoint URL for referenced entity |

**Used for:** `client`, `factfind`, `policy`

#### policy (DPA Policy Reference)

Reference to the specific DPA policy version:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique policy identifier |
| `name` | string | Policy name (read-only, e.g., "Standard DPA Policy 2026") |
| `href` | string | Policy resource URL |

**Important:** Links to specific policy version - ensures audit trail shows which version was agreed

#### statements (Policy Statements and Responses)

Complex object containing up to 5 policy statements with client responses:

| Field | Type | Description |
|-------|------|-------------|
| `statement1` | Object | First statement (required) |
| `statement1.text` | string | Statement text from policy (read-only) |
| `statement1.accepted` | boolean | Whether client accepted this statement (required) |
| `statement2` | Object | Second statement (optional) |
| `statement2.text` | string | Statement text from policy (read-only) |
| `statement2.accepted` | boolean | Whether client accepted (required if present) |
| `statement3` | Object | Third statement (optional) |
| `statement3.text` | string | Statement text from policy (read-only) |
| `statement3.accepted` | boolean | Whether client accepted (required if present) |
| `statement4` | Object | Fourth statement (optional) |
| `statement4.text` | string | Statement text from policy (read-only) |
| `statement4.accepted` | boolean | Whether client accepted (required if present) |
| `statement5` | Object | Fifth statement (optional) |
| `statement5.text` | string | Statement text from policy (read-only) |
| `statement5.accepted` | boolean | Whether client accepted (required if present) |

**Statement Text Examples:**
1. "I confirm that I have read and understood the data protection policy."
2. "I consent to my personal data being processed for the purposes of financial advice."
3. "I consent to my data being shared with third-party providers where necessary."
4. "I understand I can withdraw my consent at any time."
5. "I consent to receiving marketing communications (optional)."

**Validation Rules:**
- At least `statement1` must be present
- All statements present must have `accepted = true` for valid agreement
- Statement text is read-only (populated from policy definition)

### GDPR & UK Data Protection Compliance

This entity supports compliance with:

#### UK GDPR (General Data Protection Regulation)

**Article 6 - Lawful Basis for Processing:**
- Records client consent as lawful basis for data processing
- Documents specific purposes for which data is processed

**Article 7 - Conditions for Consent:**
- ✓ Consent must be freely given, specific, informed, and unambiguous
- ✓ Request for consent presented in clear and plain language
- ✓ Client can withdraw consent at any time
- ✓ Burden of proof that consent was given rests with firm (audit trail)

**Article 13 - Information to be Provided:**
- DPA policy informs data subjects about data processing
- Links to full privacy notice

**Article 15 - Right of Access:**
- Agreement history supports data subject access requests (DSAR)
- Shows what was consented to and when

**Article 30 - Records of Processing Activities:**
- Provides evidence of consent management
- Demonstrates compliance with record-keeping requirements

#### Data Protection Act 2018 (UK)

- Implements UK GDPR requirements
- Specific provisions for financial services data
- Processing for contractual necessity (advisory services)

#### FCA Requirements

**SYSC 3.2 - Systems and Controls:**
- Adequate policies and procedures for data protection
- Evidence of client consent management

**Treating Customers Fairly (TCF):**
- Clear communication of data usage
- Transparency in data processing

**Consumer Duty:**
- Act in good faith towards customers
- Avoid causing foreseeable harm (including data breaches)

### Business Rules

**Immutability:**
- Agreements are **immutable** once created (cannot be updated)
- Policy updates require new agreements
- Historical agreements preserved for audit trail

**Valid Agreement Requirements:**
- All statements present must have `accepted = true`
- At least first statement must be accepted
- Agreement timestamp must be recorded

**Policy Versioning:**
- Each agreement links to specific policy version
- Policy updates trigger need for new client agreements
- Existing agreements remain valid for their policy version

**Agreement History:**
- Multiple agreements per client over time
- Use `agreementId = "current"` to retrieve most recent
- Historical agreements retained for compliance

**Consent Management:**
- Consent can be withdrawn (creates new agreement or flags in system)
- Withdrawal must be as easy as giving consent (GDPR requirement)
- Records must show current consent status

### Use Cases

**1. Client Onboarding:**
```
1. Retrieve current DPA policy (GET /api/v3/dpa-policies/current)
2. Present policy and statements to client
3. Client accepts all statements
4. Create DPA agreement (POST /api/v3/factfinds/{id}/clients/{id}/dpa-agreements)
5. Store agreement ID for audit trail
```

**2. Policy Update:**
```
1. Firm updates DPA policy (new policy version created)
2. System identifies clients without agreement for new policy
3. Present new policy to clients
4. Create new agreements as clients accept
5. Old agreements remain for historical record
```

**3. Compliance Audit:**
```
1. Regulator requests proof of consent
2. Retrieve all DPA agreements for client
3. Show policy versions accepted and timestamps
4. Demonstrate continuous consent management
```

**4. Data Subject Access Request (DSAR):**
```
1. Client requests all data held about them
2. Include DPA agreement history in DSAR response
3. Show what was consented to and when
4. Demonstrate lawful basis for processing
```

**5. Consent Withdrawal:**
```
1. Client withdraws consent for specific processing
2. Create new agreement record showing withdrawal
3. Update systems to reflect withdrawn consent
4. Cease processing for withdrawn purposes
```

### Typical Policy Statements

**Essential (Always Required):**
1. "I have read and understood the data protection policy"
2. "I consent to processing of my data for financial advice purposes"
3. "I understand my rights under GDPR/Data Protection Act"

**Optional (Can be Declined):**
4. "I consent to receiving marketing communications"
5. "I consent to anonymous data use for service improvement"

**Note:** Marketing consent (statement 4) must be **optional** and separate from essential processing consent

### Related Resources

*See parent document for relationships to other entities.*


## Data Model