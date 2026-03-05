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
| **Base Path** | `/api/v3/...` |
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

#### assessedBy (Adviser Reference)

Adviser who conducted the assessment:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Adviser unique identifier |
| `name` | string | Adviser full name |

#### client (Client Reference)

Extended client reference with name:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of client |
| `href` | string | API endpoint URL for client |
| `name` | string | Client full name |

#### factfind (Reference Link)

Standard reference structure:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of factfind |
| `href` | string | API endpoint URL for factfind |

#### templateRef (ATR Template Reference)

Reference to the ATR questionnaire template used:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Template unique identifier |
| `version` | string | Template version number (e.g., "5.0") |
| `name` | string | Template display name (e.g., "FCA Standard ATR 2025") |
| `regulatoryApprovalDate` | date | Date template was approved for regulatory compliance |

**Important:** Templates are versioned and regulatory-approved. This ensures audit trail shows which version was used for each assessment.

#### questions (List of Question Objects)

15 standard ATR questions with client answers. Each question contains:

| Field | Type | Description |
|-------|------|-------------|
| `questionId` | string | Question identifier (Q1, Q2, ... Q15) |
| `questionText` | string | The question text presented to client |
| `questionType` | string | Type: SingleChoice, MultipleChoice, Slider |
| `answer` | Complex Data | Client's answer (structure varies by type) |

**Question Types and Answer Structures:**

**For SingleChoice questions:**
- `answerId` (string) - Selected answer identifier (e.g., "A1-3")
- `answerText` (string) - Selected answer text (e.g., "10-15 years")
- `score` (integer) - Score for this answer

**For Slider questions:**
- `value` (integer) - Slider value selected (typically 1-10)
- `minLabel` (string) - Label for minimum value (e.g., "Very Cautious")
- `maxLabel` (string) - Label for maximum value (e.g., "Very Adventurous")
- `score` (integer) - Score for this value

**Example Standard Questions:**
1. How long do you plan to invest for?
2. What is your attitude to investment risk?
3. How would you react to a 20% fall in your investment value?
4. What is your investment objective?
5. How much investment experience do you have?

#### supplementaryQuestions (List of Supplementary Questions)

45 additional context questions providing deeper insights. Each question contains:

| Field | Type | Description |
|-------|------|-------------|
| `category` | string | Category: Risk, General, Financial, Personal |
| `questionId` | string | Question identifier (SQ-R1, SQ-G1, etc.) |
| `questionText` | string | The question text |
| `answer` | Complex Data | Client's answer with type-specific value |

**Answer Structure:**
- `answerType` (string) - Type: Number, Boolean, Text, Date
- `value` (various) - The answer value matching the type

**Example Supplementary Questions:**
- Number of financial dependants (Number)
- Do you have a valid Will? (Boolean)
- Annual gross income (Number)
- Expected retirement date (Date)
- Investment knowledge level (Text)

#### capacityForLoss (Capacity Assessment)

Financial capacity to sustain investment losses:

| Field | Type | Description |
|-------|------|-------------|
| `canAffordLosses` | boolean | Whether client can afford investment losses |
| `emergencyFundMonths` | integer | Months of expenses in emergency fund |
| `essentialExpensesCovered` | boolean | Whether essential expenses adequately covered |
| `dependantsProvisionAdequate` | boolean | Whether adequate provision for dependants exists |
| `assessmentNotes` | string | Adviser assessment notes |

**Capacity for Loss** is separate from **Attitude to Risk**:
- **ATR**: Client's emotional tolerance for investment volatility
- **Capacity**: Client's financial ability to sustain losses

**FCA Requirement:** If capacity is lower than attitude, recommendations must be based on capacity.

#### riskProfiles (Risk Profiles)

Generated and chosen risk profiles:

| Field | Type | Description |
|-------|------|-------------|
| `generated` | List of Complex Data | Three generated risk profiles (main + adjacent higher/lower) |
| `chosen` | Complex Data | The risk profile chosen by client with adviser guidance |

#### riskProfiles.generated[] (Generated Risk Profile)

Each of the 3 generated profiles contains:

| Field | Type | Description |
|-------|------|-------------|
| `riskRating` | string | Risk category name (e.g., Cautious, Balanced, Adventurous) |
| `riskScore` | integer | Numeric risk score derived from questionnaire |
| `scoreRange` | string | Score range for this category (e.g., "40-50") |
| `description` | string | Full description of this risk profile |
| `assetAllocation` | Complex Data | Recommended asset mix percentages |
| `volatilityTolerance` | string | Expected volatility comfort (Low, Medium, High) |
| `timePeriod` | string | Recommended investment period (e.g., "10-15 years") |
| `potentialLossAcceptance` | string | Expected loss tolerance percentage (e.g., "10-15%") |

**Asset Allocation Structure:**
- `equities` (integer) - Equity allocation percentage (0-100)
- `bonds` (integer) - Bond allocation percentage (0-100)
- `cash` (integer) - Cash allocation percentage (0-100)
- `alternatives` (integer) - Alternative investments percentage (0-100)

**Standard Risk Ratings:**
1. **Very Cautious** (Score 0-20): 20% equities, 60% bonds, 15% cash, 5% alternatives
2. **Cautious** (Score 21-40): 40% equities, 45% bonds, 10% cash, 5% alternatives
3. **Balanced** (Score 41-60): 60% equities, 30% bonds, 5% cash, 5% alternatives
4. **Adventurous** (Score 61-80): 75% equities, 15% bonds, 5% cash, 5% alternatives
5. **Very Adventurous** (Score 81-100): 90% equities, 5% bonds, 0% cash, 5% alternatives

#### riskProfiles.chosen (Chosen Risk Profile)

The risk profile selected by the client:

| Field | Type | Description |
|-------|------|-------------|
| `riskRating` | string | Chosen risk category name |
| `riskScore` | integer | Chosen risk score |
| `chosenBy` | string | Who made the choice (typically "Client") |
| `chosenDate` | timestamp | When choice was made |
| `reasonForChoice` | string | Client's reason for choosing this profile |
| `adviserNotes` | string | Adviser notes on the choice and suitability |

**Three Options Rule:** FCA best practice requires presenting 3 adjacent risk profiles to avoid anchoring bias.

#### declarations (Regulatory Declarations)

Client and adviser declarations for compliance:

| Field | Type | Description |
|-------|------|-------------|
| `clientDeclaration` | Complex Data | Client's declaration of accuracy |
| `adviserDeclaration` | Complex Data | Adviser's declaration of suitability |

**Client Declaration Structure:**
- `declarationType` (string) - Type: ATR_Accuracy
- `declarationText` (string) - Full declaration text
- `signed` (boolean) - Whether declaration is signed
- `signedDate` (timestamp) - When declaration was signed
- `signatureType` (string) - Type: Electronic, Wet Signature
- `ipAddress` (string) - IP address where electronically signed

**Adviser Declaration Structure:**
- `declarationType` (string) - Type: ATR_Suitable
- `declarationText` (string) - Full declaration text
- `signed` (boolean) - Whether declaration is signed
- `signedDate` (timestamp) - When declaration was signed
- `signedBy` (Complex Data) - Adviser who signed (id and name)

### FCA Regulatory Requirements

This entity supports compliance with:

#### COBS 9.2 - Assessing Suitability

**Suitability Assessment Requirements:**
- Obtain necessary information about client's knowledge, experience, and objectives
- Understand client's ability to bear losses (capacity for loss)
- Assess risk tolerance through structured questionnaire
- Ensure recommendations match assessed risk profile

#### MiFID II Article 25 - Assessment Requirements

**Investment Assessment Standards:**
- Knowledge and experience in relevant investment types
- Financial situation including ability to bear losses
- Investment objectives including risk tolerance and time horizon
- Must be reasonable and evidence-based

#### Consumer Duty (FCA)

**Good Outcomes Requirements:**
- Risk assessment must be clear and understandable
- Client must understand volatility and potential losses
- Support clients in making informed decisions
- Avoid foreseeable harm from unsuitable investments

### Business Rules

**Question Completion:**
1. All 15 standard questions MUST be answered
2. Supplementary questions are optional but recommended for better assessment
3. System prevents submission without all required answers
4. Questions presented in fixed order for consistency

**Risk Profile Generation:**
1. System automatically generates 3 adjacent risk profiles based on total score
2. Main profile matches calculated score range
3. Adjacent lower and higher profiles presented for client choice
4. Asset allocation derived from regulatory-approved template
5. Cannot manually override generated profiles without audit trail

**Profile Selection:**
1. Client must choose from one of the 3 generated profiles
2. Adviser can guide but should not override client choice
3. Reason for choice must be documented
4. If client chooses profile different from calculated, reason must be comprehensive

**Capacity vs. Tolerance:**
1. Capacity for loss assessed separately from attitude
2. If capacity is lower than attitude, adviser MUST:
   - Recommend based on lower capacity
   - Document reason for recommendation
   - Obtain explicit client acknowledgment
3. Cannot recommend higher risk than capacity supports

**Regulatory Compliance:**
1. Both client and adviser declarations REQUIRED
2. Electronic signatures must capture IP address and timestamp
3. Assessment valid for 12 months
4. Review required after major life events:
   - Marriage/divorce
   - Retirement
   - Inheritance
   - Job loss
   - Significant income change

**Audit Trail:**
1. All historical assessments preserved (immutable)
2. Template version recorded for each assessment
3. Assessment cannot be deleted (soft delete only)
4. Changes to chosen profile require new assessment or documented justification

### Use Cases

**1. Initial Investment Advice:**
```
1. Client meets adviser for first time
2. Adviser presents ATR questionnaire (15 questions)
3. Client answers all questions
4. System calculates total score (e.g., 67/100)
5. System generates 3 profiles: Cautious (35), Balanced (45), Adventurous (55)
6. Adviser discusses each profile with client
7. Client chooses "Balanced" - matches risk comfort and investment goals
8. Adviser assesses capacity for loss (emergency fund, dependants, essential expenses)
9. Both sign declarations
10. Assessment saved and used for investment recommendations
```

**2. Capacity Override Scenario:**
```
1. Client ATR score: 75 (Adventurous)
2. Generated profiles: Balanced (65), Adventurous (75), Very Adventurous (85)
3. Client initially wants Adventurous profile
4. Adviser assesses capacity for loss:
   - Emergency fund: 2 months (below recommended 6 months)
   - Significant mortgage payments
   - Two young dependants
5. Capacity assessment: Can only afford Balanced risk
6. Adviser recommends Balanced despite Adventurous attitude
7. Client acknowledges and agrees to Balanced
8. Documentation records capacity override
```

**3. Annual Review:**
```
1. Client had previous assessment 12 months ago (Balanced profile)
2. Life changes: Received inheritance, paid off mortgage
3. Complete new ATR assessment
4. New score: 72 (moved from Balanced to Adventurous)
5. Capacity improved significantly (no mortgage, larger emergency fund)
6. Client now chooses Adventurous profile
7. New assessment saved, historical assessment preserved
8. Portfolio rebalancing recommended based on new profile
```

**4. Regulatory Audit:**
```
1. FCA requests suitability evidence for client investments
2. Retrieve ATR assessment history for client
3. Show:
   - Completed questionnaire with all answers
   - Generated risk profiles
   - Chosen profile with documented reason
   - Capacity for loss assessment
   - Client and adviser declarations
   - Template version used (regulatory-approved)
4. Demonstrate recommendations matched assessed profile
5. Show annual review compliance
```

**5. Pension Transfer Assessment:**
```
1. Client considering defined benefit pension transfer
2. Enhanced ATR required (regulatory requirement for DB transfers)
3. Complete full 15 standard questions
4. Complete all 45 supplementary questions
5. Enhanced capacity for loss assessment:
   - Retirement income adequacy
   - State pension coverage
   - Other income sources
   - Health considerations
6. Risk profile must support pension investment recommendations
7. Special declaration acknowledging DB transfer risks
```

### Related Resources

*See parent document for relationships to other entities.*


## Data Model