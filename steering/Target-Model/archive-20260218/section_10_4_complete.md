### 10.4 Risk Questionnaire API

**Purpose:** Manage risk assessment questionnaire templates, versioning, and administration.

**Scope:**
- Questionnaire template management with version control
- Regulatory approval tracking (FCA, MiFID II compliance)
- Question bank administration with scoring algorithms
- Risk rating categories and asset allocation recommendations
- Template distribution and activation workflow
- Multi-language questionnaire support
- Regulatory compliance tracking and audit trail
- Question type support: SingleChoice, MultipleChoice, Slider, Ranking

**Aggregate Root:** FactFind (risk questionnaires are system-level but applied per fact find)

**Regulatory Compliance:**
- FCA COBS 9.2 (Assessing Suitability - Risk Assessment)
- MiFID II Article 25 (Assessment of Suitability and Appropriateness)
- ESMA Guidelines on Suitability Assessment
- FCA Handbook COBS 9 Annex 2 (Risk Profiling)
- Consumer Duty (Understanding Customer Risk Tolerance)

#### 10.4.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/risk-questionnaires` | List questionnaire templates | `risk:read` |
| GET | `/api/v1/risk-questionnaires/{id}` | Get questionnaire details | `risk:read` |
| POST | `/api/v1/risk-questionnaires` | Create questionnaire template | `risk:admin` |
| PUT | `/api/v1/risk-questionnaires/{id}` | Update questionnaire template | `risk:admin` |
| DELETE | `/api/v1/risk-questionnaires/{id}` | Delete questionnaire template | `risk:admin` |
| POST | `/api/v1/risk-questionnaires/{id}/questions` | Add question to template | `risk:admin` |
| PUT | `/api/v1/risk-questionnaires/{id}/questions/{questionId}` | Update question | `risk:admin` |
| DELETE | `/api/v1/risk-questionnaires/{id}/questions/{questionId}` | Remove question | `risk:admin` |
| GET | `/api/v1/risk-questionnaires/{id}/questions` | Get questions for template | `risk:read` |
| POST | `/api/v1/risk-questionnaires/{id}/activate` | Activate questionnaire version | `risk:admin` |
| POST | `/api/v1/risk-questionnaires/{id}/submit-for-approval` | Submit for regulatory approval | `risk:admin` |
| POST | `/api/v1/risk-questionnaires/{id}/approve` | Approve questionnaire | `risk:admin` |
| GET | `/api/v1/risk-questionnaires/active` | Get active questionnaire | `risk:read` |
| GET | `/api/v1/factfinds/{factfindId}/risk-questionnaires/{id}/responses` | Get client responses | `risk:read` |
| POST | `/api/v1/factfinds/{factfindId}/risk-questionnaires/{id}/responses` | Submit client responses | `risk:write` |

#### 10.4.2 Key Endpoints

##### 10.4.2.1 List Questionnaire Templates

**Endpoint:** `GET /api/v1/risk-questionnaires`

**Description:** List all risk questionnaire templates with version and status information.

**Query Parameters:**
- `status` - Filter by status: Draft, PendingApproval, Approved, Active, Archived
- `language` - Filter by language code (ISO 639-1)
- `includeArchived` - Include archived templates (default: false)
- `sortBy` - Sort field: version, createdDate, activatedDate
- `sortOrder` - Sort order: asc, desc

**Response:**

```json
{
  "questionnaires": [
    {
      "id": "rq-2024-v3",
      "version": "3.0",
      "name": "Standard Attitude to Risk Questionnaire 2024",
      "description": "FCA-compliant ATR questionnaire with 15 questions covering risk capacity, risk tolerance, and investment experience",
      "status": "Active",
      "language": {
        "code": "en-GB",
        "display": "English (UK)"
      },
      "questionCount": 15,
      "estimatedCompletionTime": 10,
      "createdDate": "2024-01-15T09:00:00Z",
      "createdBy": {
        "id": "user-789",
        "name": "Compliance Team"
      },
      "approvedDate": "2024-02-01T14:30:00Z",
      "approvedBy": {
        "id": "user-101",
        "name": "Head of Compliance"
      },
      "activatedDate": "2024-02-15T00:00:00Z",
      "activeFrom": "2024-02-15",
      "activeTo": null,
      "usageCount": 1247,
      "riskRatingCategories": [
        "VeryLowRisk",
        "LowRisk",
        "MediumRisk",
        "HighRisk",
        "VeryHighRisk"
      ],
      "scoringMethod": "WeightedAverage",
      "regulatoryApprovals": [
        {
          "regulator": "FCA",
          "approvalReference": "FCA-2024-ATR-001",
          "approvalDate": "2024-01-28",
          "expiryDate": null
        }
      ],
      "_links": {
        "self": { "href": "/api/v1/risk-questionnaires/rq-2024-v3" },
        "questions": { "href": "/api/v1/risk-questionnaires/rq-2024-v3/questions" },
        "activate": { "href": "/api/v1/risk-questionnaires/rq-2024-v3/activate", "method": "POST" }
      }
    },
    {
      "id": "rq-2024-v2",
      "version": "2.1",
      "name": "Standard Attitude to Risk Questionnaire 2023",
      "description": "Previous version - archived after v3.0 activation",
      "status": "Archived",
      "language": {
        "code": "en-GB",
        "display": "English (UK)"
      },
      "questionCount": 12,
      "estimatedCompletionTime": 8,
      "createdDate": "2023-01-10T09:00:00Z",
      "createdBy": {
        "id": "user-789",
        "name": "Compliance Team"
      },
      "approvedDate": "2023-02-05T14:30:00Z",
      "approvedBy": {
        "id": "user-101",
        "name": "Head of Compliance"
      },
      "activatedDate": "2023-02-20T00:00:00Z",
      "activeFrom": "2023-02-20",
      "activeTo": "2024-02-14",
      "usageCount": 3421,
      "riskRatingCategories": [
        "VeryLowRisk",
        "LowRisk",
        "MediumRisk",
        "HighRisk",
        "VeryHighRisk"
      ],
      "scoringMethod": "WeightedAverage",
      "regulatoryApprovals": [
        {
          "regulator": "FCA",
          "approvalReference": "FCA-2023-ATR-002",
          "approvalDate": "2023-01-30",
          "expiryDate": "2024-02-14"
        }
      ],
      "_links": {
        "self": { "href": "/api/v1/risk-questionnaires/rq-2024-v2" },
        "questions": { "href": "/api/v1/risk-questionnaires/rq-2024-v2/questions" }
      }
    },
    {
      "id": "rq-2024-v4-draft",
      "version": "4.0-draft",
      "name": "Enhanced ATR Questionnaire 2025 (Draft)",
      "description": "Next generation questionnaire with behavioral finance insights",
      "status": "Draft",
      "language": {
        "code": "en-GB",
        "display": "English (UK)"
      },
      "questionCount": 18,
      "estimatedCompletionTime": 12,
      "createdDate": "2024-10-01T09:00:00Z",
      "createdBy": {
        "id": "user-789",
        "name": "Compliance Team"
      },
      "approvedDate": null,
      "approvedBy": null,
      "activatedDate": null,
      "activeFrom": null,
      "activeTo": null,
      "usageCount": 0,
      "riskRatingCategories": [
        "VeryLowRisk",
        "LowRisk",
        "MediumLowRisk",
        "MediumRisk",
        "MediumHighRisk",
        "HighRisk",
        "VeryHighRisk"
      ],
      "scoringMethod": "WeightedAverageWithBehavioralAdjustments",
      "regulatoryApprovals": [],
      "_links": {
        "self": { "href": "/api/v1/risk-questionnaires/rq-2024-v4-draft" },
        "questions": { "href": "/api/v1/risk-questionnaires/rq-2024-v4-draft/questions" },
        "submit-for-approval": { "href": "/api/v1/risk-questionnaires/rq-2024-v4-draft/submit-for-approval", "method": "POST" },
        "update": { "href": "/api/v1/risk-questionnaires/rq-2024-v4-draft", "method": "PUT" },
        "delete": { "href": "/api/v1/risk-questionnaires/rq-2024-v4-draft", "method": "DELETE" }
      }
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 3,
    "totalPages": 1
  },
  "_links": {
    "self": { "href": "/api/v1/risk-questionnaires" },
    "create": { "href": "/api/v1/risk-questionnaires", "method": "POST" },
    "active": { "href": "/api/v1/risk-questionnaires/active" }
  }
}
```

**Questionnaire Status Values:**
- `Draft` - Under development, not ready for use
- `PendingApproval` - Submitted for regulatory/compliance approval
- `Approved` - Approved but not yet activated
- `Active` - Currently in use for new assessments
- `Archived` - Previously active, now superseded

**Scoring Methods:**
- `WeightedAverage` - Standard weighted scoring
- `WeightedAverageWithBehavioralAdjustments` - Includes behavioral finance adjustments
- `PointBased` - Simple point accumulation
- `HybridRiskCapacityAndTolerance` - Combines capacity and tolerance scores

**Validation Rules:**
- Only one questionnaire can be Active per language at a time
- Questionnaire must be Approved before it can be Activated
- Archived questionnaires cannot be edited
- Active questionnaires can only be archived, not deleted

**HTTP Status Codes:**
- `200 OK` - Questionnaires retrieved successfully
- `403 Forbidden` - Insufficient permissions

---

##### 10.4.2.2 Get Questionnaire Template Details

**Endpoint:** `GET /api/v1/risk-questionnaires/{id}`

**Description:** Get complete questionnaire template including all questions, answer options, scoring rules, and risk rating mappings.

**Response:**

```json
{
  "id": "rq-2024-v3",
  "version": "3.0",
  "name": "Standard Attitude to Risk Questionnaire 2024",
  "description": "FCA-compliant ATR questionnaire with 15 questions covering risk capacity, risk tolerance, and investment experience",
  "status": "Active",
  "language": {
    "code": "en-GB",
    "display": "English (UK)"
  },
  "questionCount": 15,
  "estimatedCompletionTime": 10,
  "createdDate": "2024-01-15T09:00:00Z",
  "createdBy": {
    "id": "user-789",
    "name": "Compliance Team"
  },
  "lastModifiedDate": "2024-01-28T11:30:00Z",
  "lastModifiedBy": {
    "id": "user-789",
    "name": "Compliance Team"
  },
  "approvedDate": "2024-02-01T14:30:00Z",
  "approvedBy": {
    "id": "user-101",
    "name": "Head of Compliance"
  },
  "activatedDate": "2024-02-15T00:00:00Z",
  "activeFrom": "2024-02-15",
  "activeTo": null,
  "usageCount": 1247,
  "introductionText": "This questionnaire will help us understand your attitude towards investment risk. There are no right or wrong answers - we simply want to understand your preferences and comfort level with different investment scenarios. Please answer all questions honestly.",
  "completionText": "Thank you for completing the questionnaire. Your responses have been recorded and will be reviewed by your adviser.",
  "questions": [
    {
      "id": "q1",
      "questionNumber": 1,
      "questionType": "SingleChoice",
      "category": "RiskCapacity",
      "questionText": "What is your investment time horizon?",
      "helpText": "How long do you expect to keep your money invested before you need to access it?",
      "required": true,
      "weight": 1.5,
      "displayOrder": 1,
      "answerOptions": [
        {
          "id": "q1-a1",
          "optionText": "Less than 1 year",
          "displayOrder": 1,
          "score": 1
        },
        {
          "id": "q1-a2",
          "optionText": "1-3 years",
          "displayOrder": 2,
          "score": 2
        },
        {
          "id": "q1-a3",
          "optionText": "3-5 years",
          "displayOrder": 3,
          "score": 3
        },
        {
          "id": "q1-a4",
          "optionText": "5-10 years",
          "displayOrder": 4,
          "score": 4
        },
        {
          "id": "q1-a5",
          "optionText": "More than 10 years",
          "displayOrder": 5,
          "score": 5
        }
      ]
    },
    {
      "id": "q2",
      "questionNumber": 2,
      "questionType": "SingleChoice",
      "category": "RiskTolerance",
      "questionText": "If the value of your investment fell by 20% in the first year, what would you do?",
      "helpText": "This helps us understand your emotional response to investment losses",
      "required": true,
      "weight": 2.0,
      "displayOrder": 2,
      "answerOptions": [
        {
          "id": "q2-a1",
          "optionText": "Sell all investments immediately to prevent further losses",
          "displayOrder": 1,
          "score": 1
        },
        {
          "id": "q2-a2",
          "optionText": "Sell some investments to reduce exposure",
          "displayOrder": 2,
          "score": 2
        },
        {
          "id": "q2-a3",
          "optionText": "Do nothing and wait for recovery",
          "displayOrder": 3,
          "score": 3
        },
        {
          "id": "q2-a4",
          "optionText": "Invest more to take advantage of lower prices",
          "displayOrder": 4,
          "score": 5
        }
      ]
    },
    {
      "id": "q3",
      "questionNumber": 3,
      "questionType": "Slider",
      "category": "RiskTolerance",
      "questionText": "What level of risk are you comfortable taking with your investments?",
      "helpText": "Move the slider to indicate your comfort level (0 = no risk, 10 = maximum risk)",
      "required": true,
      "weight": 1.8,
      "displayOrder": 3,
      "sliderConfig": {
        "minValue": 0,
        "maxValue": 10,
        "stepSize": 1,
        "minLabel": "No risk - preserve capital",
        "maxLabel": "Maximum risk - highest growth potential",
        "defaultValue": 5
      }
    },
    {
      "id": "q4",
      "questionNumber": 4,
      "questionType": "SingleChoice",
      "category": "InvestmentExperience",
      "questionText": "How would you describe your investment knowledge and experience?",
      "helpText": "Select the option that best describes your level of investment experience",
      "required": true,
      "weight": 1.2,
      "displayOrder": 4,
      "answerOptions": [
        {
          "id": "q4-a1",
          "optionText": "None - I have no investment experience",
          "displayOrder": 1,
          "score": 1
        },
        {
          "id": "q4-a2",
          "optionText": "Limited - I have basic understanding of investments",
          "displayOrder": 2,
          "score": 2
        },
        {
          "id": "q4-a3",
          "optionText": "Good - I understand most investment concepts",
          "displayOrder": 3,
          "score": 3
        },
        {
          "id": "q4-a4",
          "optionText": "Extensive - I have significant investment experience",
          "displayOrder": 4,
          "score": 4
        },
        {
          "id": "q4-a5",
          "optionText": "Expert - I work in the financial services industry",
          "displayOrder": 5,
          "score": 5
        }
      ]
    },
    {
      "id": "q5",
      "questionNumber": 5,
      "questionType": "SingleChoice",
      "category": "RiskCapacity",
      "questionText": "What percentage of your total wealth is represented by this investment?",
      "helpText": "This helps us understand the impact of potential losses on your overall financial position",
      "required": true,
      "weight": 1.6,
      "displayOrder": 5,
      "answerOptions": [
        {
          "id": "q5-a1",
          "optionText": "More than 75%",
          "displayOrder": 1,
          "score": 1
        },
        {
          "id": "q5-a2",
          "optionText": "50-75%",
          "displayOrder": 2,
          "score": 2
        },
        {
          "id": "q5-a3",
          "optionText": "25-50%",
          "displayOrder": 3,
          "score": 3
        },
        {
          "id": "q5-a4",
          "optionText": "10-25%",
          "displayOrder": 4,
          "score": 4
        },
        {
          "id": "q5-a5",
          "optionText": "Less than 10%",
          "displayOrder": 5,
          "score": 5
        }
      ]
    },
    {
      "id": "q6",
      "questionNumber": 6,
      "questionType": "SingleChoice",
      "category": "RiskCapacity",
      "questionText": "Do you have an emergency fund covering at least 3-6 months of expenses?",
      "helpText": "An emergency fund provides financial security and allows you to take more investment risk",
      "required": true,
      "weight": 1.3,
      "displayOrder": 6,
      "answerOptions": [
        {
          "id": "q6-a1",
          "optionText": "No emergency fund",
          "displayOrder": 1,
          "score": 1
        },
        {
          "id": "q6-a2",
          "optionText": "Less than 3 months",
          "displayOrder": 2,
          "score": 2
        },
        {
          "id": "q6-a3",
          "optionText": "3-6 months",
          "displayOrder": 3,
          "score": 4
        },
        {
          "id": "q6-a4",
          "optionText": "More than 6 months",
          "displayOrder": 4,
          "score": 5
        }
      ]
    },
    {
      "id": "q7",
      "questionNumber": 7,
      "questionType": "SingleChoice",
      "category": "RiskTolerance",
      "questionText": "Which statement best describes your investment objectives?",
      "helpText": "Select the option that most closely matches your primary investment goal",
      "required": true,
      "weight": 1.7,
      "displayOrder": 7,
      "answerOptions": [
        {
          "id": "q7-a1",
          "optionText": "Preserve my capital - I cannot afford to lose any money",
          "displayOrder": 1,
          "score": 1
        },
        {
          "id": "q7-a2",
          "optionText": "Generate income with minimal capital growth",
          "displayOrder": 2,
          "score": 2
        },
        {
          "id": "q7-a3",
          "optionText": "Balance income and growth with moderate risk",
          "displayOrder": 3,
          "score": 3
        },
        {
          "id": "q7-a4",
          "optionText": "Achieve capital growth with some income",
          "displayOrder": 4,
          "score": 4
        },
        {
          "id": "q7-a5",
          "optionText": "Maximize growth - I accept higher risk for higher returns",
          "displayOrder": 5,
          "score": 5
        }
      ]
    },
    {
      "id": "q8",
      "questionNumber": 8,
      "questionType": "Ranking",
      "category": "RiskTolerance",
      "questionText": "Rank these investment options in order of preference (1 = most preferred, 4 = least preferred)",
      "helpText": "Drag and drop to reorder the options according to your preference",
      "required": true,
      "weight": 1.5,
      "displayOrder": 8,
      "rankingOptions": [
        {
          "id": "q8-opt1",
          "optionText": "Bank savings account - guaranteed capital, low return (1-2% p.a.)",
          "displayOrder": 1
        },
        {
          "id": "q8-opt2",
          "optionText": "Government bonds - very low risk, modest return (2-4% p.a.)",
          "displayOrder": 2
        },
        {
          "id": "q8-opt3",
          "optionText": "Balanced portfolio - moderate risk, balanced return (4-7% p.a.)",
          "displayOrder": 3
        },
        {
          "id": "q8-opt4",
          "optionText": "Growth equity portfolio - higher risk, higher return potential (7-12% p.a.)",
          "displayOrder": 4
        }
      ],
      "rankingScoring": {
        "rank1Score": 5,
        "rank2Score": 3,
        "rank3Score": 2,
        "rank4Score": 1
      }
    },
    {
      "id": "q9",
      "questionNumber": 9,
      "questionType": "SingleChoice",
      "category": "RiskCapacity",
      "questionText": "What is your current employment status?",
      "helpText": "Your employment status affects your ability to recover from investment losses",
      "required": true,
      "weight": 1.1,
      "displayOrder": 9,
      "answerOptions": [
        {
          "id": "q9-a1",
          "optionText": "Retired with limited income",
          "displayOrder": 1,
          "score": 2
        },
        {
          "id": "q9-a2",
          "optionText": "Employed - stable income",
          "displayOrder": 2,
          "score": 4
        },
        {
          "id": "q9-a3",
          "optionText": "Self-employed - variable income",
          "displayOrder": 3,
          "score": 3
        },
        {
          "id": "q9-a4",
          "optionText": "Unemployed or not working",
          "displayOrder": 4,
          "score": 1
        }
      ]
    },
    {
      "id": "q10",
      "questionNumber": 10,
      "questionType": "MultipleChoice",
      "category": "InvestmentExperience",
      "questionText": "Which of the following investment types have you held before? (Select all that apply)",
      "helpText": "This helps us understand your familiarity with different investment types",
      "required": true,
      "weight": 1.0,
      "displayOrder": 10,
      "multipleChoiceConfig": {
        "minSelections": 0,
        "maxSelections": null
      },
      "answerOptions": [
        {
          "id": "q10-a1",
          "optionText": "Cash savings accounts only",
          "displayOrder": 1,
          "score": 1
        },
        {
          "id": "q10-a2",
          "optionText": "Fixed income bonds",
          "displayOrder": 2,
          "score": 2
        },
        {
          "id": "q10-a3",
          "optionText": "Investment funds (unit trusts, OEICs)",
          "displayOrder": 3,
          "score": 3
        },
        {
          "id": "q10-a4",
          "optionText": "Individual shares/stocks",
          "displayOrder": 4,
          "score": 4
        },
        {
          "id": "q10-a5",
          "optionText": "Alternative investments (property, commodities, hedge funds)",
          "displayOrder": 5,
          "score": 5
        }
      ],
      "multipleChoiceScoring": "AverageSelected"
    },
    {
      "id": "q11",
      "questionNumber": 11,
      "questionType": "SingleChoice",
      "category": "RiskTolerance",
      "questionText": "How frequently would you want to review your investments?",
      "helpText": "This indicates your comfort level with market volatility",
      "required": true,
      "weight": 0.8,
      "displayOrder": 11,
      "answerOptions": [
        {
          "id": "q11-a1",
          "optionText": "Daily - I need to monitor closely",
          "displayOrder": 1,
          "score": 1
        },
        {
          "id": "q11-a2",
          "optionText": "Weekly",
          "displayOrder": 2,
          "score": 2
        },
        {
          "id": "q11-a3",
          "optionText": "Monthly",
          "displayOrder": 3,
          "score": 3
        },
        {
          "id": "q11-a4",
          "optionText": "Quarterly",
          "displayOrder": 4,
          "score": 4
        },
        {
          "id": "q11-a5",
          "optionText": "Annually - I'm comfortable with long-term investing",
          "displayOrder": 5,
          "score": 5
        }
      ]
    },
    {
      "id": "q12",
      "questionNumber": 12,
      "questionType": "SingleChoice",
      "category": "RiskCapacity",
      "questionText": "Do you expect any major expenses in the next 5 years?",
      "helpText": "Future expenses may affect your ability to maintain investments during downturns",
      "required": true,
      "weight": 1.4,
      "displayOrder": 12,
      "answerOptions": [
        {
          "id": "q12-a1",
          "optionText": "Yes, within 1 year",
          "displayOrder": 1,
          "score": 1
        },
        {
          "id": "q12-a2",
          "optionText": "Yes, within 1-3 years",
          "displayOrder": 2,
          "score": 2
        },
        {
          "id": "q12-a3",
          "optionText": "Yes, within 3-5 years",
          "displayOrder": 3,
          "score": 3
        },
        {
          "id": "q12-a4",
          "optionText": "No major expenses expected",
          "displayOrder": 4,
          "score": 5
        }
      ]
    },
    {
      "id": "q13",
      "questionNumber": 13,
      "questionType": "SingleChoice",
      "category": "RiskTolerance",
      "questionText": "Investment A has a guaranteed return of 3% per year. Investment B could return 15% or lose 10% with equal probability. Which would you choose?",
      "helpText": "This question assesses your risk/reward preference",
      "required": true,
      "weight": 2.0,
      "displayOrder": 13,
      "answerOptions": [
        {
          "id": "q13-a1",
          "optionText": "Definitely choose Investment A (guaranteed 3%)",
          "displayOrder": 1,
          "score": 1
        },
        {
          "id": "q13-a2",
          "optionText": "Probably choose Investment A",
          "displayOrder": 2,
          "score": 2
        },
        {
          "id": "q13-a3",
          "optionText": "Probably choose Investment B",
          "displayOrder": 3,
          "score": 4
        },
        {
          "id": "q13-a4",
          "optionText": "Definitely choose Investment B (15% or -10%)",
          "displayOrder": 4,
          "score": 5
        }
      ]
    },
    {
      "id": "q14",
      "questionNumber": 14,
      "questionType": "SingleChoice",
      "category": "RiskCapacity",
      "questionText": "What is your age?",
      "helpText": "Age is a factor in determining appropriate investment time horizons",
      "required": true,
      "weight": 1.3,
      "displayOrder": 14,
      "answerOptions": [
        {
          "id": "q14-a1",
          "optionText": "Under 30",
          "displayOrder": 1,
          "score": 5
        },
        {
          "id": "q14-a2",
          "optionText": "30-44",
          "displayOrder": 2,
          "score": 4
        },
        {
          "id": "q14-a3",
          "optionText": "45-54",
          "displayOrder": 3,
          "score": 3
        },
        {
          "id": "q14-a4",
          "optionText": "55-64",
          "displayOrder": 4,
          "score": 2
        },
        {
          "id": "q14-a5",
          "optionText": "65 or over",
          "displayOrder": 5,
          "score": 1
        }
      ]
    },
    {
      "id": "q15",
      "questionNumber": 15,
      "questionType": "SingleChoice",
      "category": "RiskTolerance",
      "questionText": "When markets are volatile, how do you typically react?",
      "helpText": "Understanding your emotional response helps us recommend suitable investments",
      "required": true,
      "weight": 1.9,
      "displayOrder": 15,
      "answerOptions": [
        {
          "id": "q15-a1",
          "optionText": "Very anxious - I lose sleep over investment losses",
          "displayOrder": 1,
          "score": 1
        },
        {
          "id": "q15-a2",
          "optionText": "Concerned but manageable",
          "displayOrder": 2,
          "score": 2
        },
        {
          "id": "q15-a3",
          "optionText": "Neutral - I understand volatility is normal",
          "displayOrder": 3,
          "score": 3
        },
        {
          "id": "q15-a4",
          "optionText": "Calm - I see it as a buying opportunity",
          "displayOrder": 4,
          "score": 5
        }
      ]
    }
  ],
  "scoringAlgorithm": {
    "method": "WeightedAverage",
    "description": "Weighted average of all question scores, with questions weighted by importance",
    "formula": "TotalScore = Σ(QuestionScore × QuestionWeight) / Σ(QuestionWeight)",
    "minPossibleScore": 1.0,
    "maxPossibleScore": 5.0,
    "normalizationApplied": true
  },
  "riskRatingCategories": [
    {
      "code": "VeryLowRisk",
      "display": "Very Low Risk",
      "description": "Capital preservation is the primary objective. Minimal exposure to equities.",
      "scoreRange": {
        "min": 1.0,
        "max": 1.8
      },
      "assetAllocationRecommendation": {
        "equities": {
          "min": 0,
          "max": 10,
          "target": 5
        },
        "bonds": {
          "min": 40,
          "max": 60,
          "target": 50
        },
        "cash": {
          "min": 30,
          "max": 60,
          "target": 45
        },
        "alternatives": {
          "min": 0,
          "max": 5,
          "target": 0
        }
      },
      "expectedAnnualReturn": {
        "min": 1.5,
        "max": 3.0,
        "target": 2.0
      },
      "expectedVolatility": {
        "min": 1.0,
        "max": 3.0,
        "target": 2.0
      },
      "suitableProductTypes": [
        "CashISA",
        "FixedRateBonds",
        "NationalSavings",
        "LowRiskManagedFunds"
      ]
    },
    {
      "code": "LowRisk",
      "display": "Low Risk",
      "description": "Income generation with capital preservation. Low equity exposure.",
      "scoreRange": {
        "min": 1.81,
        "max": 2.6
      },
      "assetAllocationRecommendation": {
        "equities": {
          "min": 10,
          "max": 25,
          "target": 20
        },
        "bonds": {
          "min": 40,
          "max": 60,
          "target": 50
        },
        "cash": {
          "min": 15,
          "max": 35,
          "target": 25
        },
        "alternatives": {
          "min": 0,
          "max": 10,
          "target": 5
        }
      },
      "expectedAnnualReturn": {
        "min": 2.5,
        "max": 4.5,
        "target": 3.5
      },
      "expectedVolatility": {
        "min": 3.0,
        "max": 6.0,
        "target": 4.5
      },
      "suitableProductTypes": [
        "CautionsManagedFunds",
        "CorporateBonds",
        "BalancedIncomeISA",
        "DefensivePortfolio"
      ]
    },
    {
      "code": "MediumRisk",
      "display": "Medium Risk",
      "description": "Balanced approach with moderate equity exposure for growth and income.",
      "scoreRange": {
        "min": 2.61,
        "max": 3.4
      },
      "assetAllocationRecommendation": {
        "equities": {
          "min": 35,
          "max": 55,
          "target": 45
        },
        "bonds": {
          "min": 25,
          "max": 40,
          "target": 30
        },
        "cash": {
          "min": 5,
          "max": 20,
          "target": 15
        },
        "alternatives": {
          "min": 5,
          "max": 15,
          "target": 10
        }
      },
      "expectedAnnualReturn": {
        "min": 4.5,
        "max": 7.0,
        "target": 5.5
      },
      "expectedVolatility": {
        "min": 6.0,
        "max": 10.0,
        "target": 8.0
      },
      "suitableProductTypes": [
        "BalancedManagedFunds",
        "MultiAssetISA",
        "DiversifiedPortfolio",
        "IncomeAndGrowthFunds"
      ]
    },
    {
      "code": "HighRisk",
      "display": "High Risk",
      "description": "Growth-focused with significant equity exposure. Higher volatility accepted.",
      "scoreRange": {
        "min": 3.41,
        "max": 4.2
      },
      "assetAllocationRecommendation": {
        "equities": {
          "min": 60,
          "max": 80,
          "target": 70
        },
        "bonds": {
          "min": 10,
          "max": 25,
          "target": 15
        },
        "cash": {
          "min": 0,
          "max": 10,
          "target": 5
        },
        "alternatives": {
          "min": 5,
          "max": 20,
          "target": 10
        }
      },
      "expectedAnnualReturn": {
        "min": 6.5,
        "max": 10.0,
        "target": 8.0
      },
      "expectedVolatility": {
        "min": 10.0,
        "max": 15.0,
        "target": 12.5
      },
      "suitableProductTypes": [
        "GrowthFunds",
        "EquityISA",
        "AggressivePortfolio",
        "EmergingMarketsFunds"
      ]
    },
    {
      "code": "VeryHighRisk",
      "display": "Very High Risk",
      "description": "Maximum growth potential with very high equity exposure. Significant volatility expected.",
      "scoreRange": {
        "min": 4.21,
        "max": 5.0
      },
      "assetAllocationRecommendation": {
        "equities": {
          "min": 80,
          "max": 100,
          "target": 90
        },
        "bonds": {
          "min": 0,
          "max": 10,
          "target": 5
        },
        "cash": {
          "min": 0,
          "max": 5,
          "target": 0
        },
        "alternatives": {
          "min": 0,
          "max": 15,
          "target": 5
        }
      },
      "expectedAnnualReturn": {
        "min": 8.0,
        "max": 15.0,
        "target": 10.0
      },
      "expectedVolatility": {
        "min": 15.0,
        "max": 25.0,
        "target": 20.0
      },
      "suitableProductTypes": [
        "EquityFunds",
        "SpecialistSectorFunds",
        "VentureCapitalTrusts",
        "SingleStockPortfolios"
      ]
    }
  ],
  "regulatoryApprovals": [
    {
      "regulator": "FCA",
      "approvalReference": "FCA-2024-ATR-001",
      "approvalDate": "2024-01-28",
      "approvedBy": "FCA Supervision Team",
      "expiryDate": null,
      "conditions": [
        "Annual review required",
        "Client must receive risk warnings",
        "Adviser must document any overrides"
      ]
    }
  ],
  "complianceNotes": [
    {
      "date": "2024-01-28",
      "author": "Head of Compliance",
      "note": "Questionnaire reviewed and approved for use. Meets FCA COBS 9.2 requirements for risk assessment."
    },
    {
      "date": "2024-02-01",
      "author": "Head of Compliance",
      "note": "Asset allocation recommendations reviewed against current market conditions and approved."
    }
  ],
  "_links": {
    "self": { "href": "/api/v1/risk-questionnaires/rq-2024-v3" },
    "questions": { "href": "/api/v1/risk-questionnaires/rq-2024-v3/questions" },
    "activate": { "href": "/api/v1/risk-questionnaires/rq-2024-v3/activate", "method": "POST" },
    "update": { "href": "/api/v1/risk-questionnaires/rq-2024-v3", "method": "PUT" }
  }
}
```

**Question Types:**
- `SingleChoice` - Select one option from a list
- `MultipleChoice` - Select multiple options from a list
- `Slider` - Continuous scale input
- `Ranking` - Rank options in order of preference
- `FreeText` - Open text response (not scored)

**Question Categories:**
- `RiskCapacity` - Ability to withstand losses (objective)
- `RiskTolerance` - Willingness to accept risk (subjective)
- `InvestmentExperience` - Knowledge and familiarity with investments
- `BehavioralFinance` - Psychological and emotional factors

**Scoring Methods for Multiple Choice:**
- `AverageSelected` - Average score of selected options
- `SumSelected` - Sum of scores of selected options
- `MaxSelected` - Maximum score among selected options
- `MinSelected` - Minimum score among selected options

**Validation Rules:**
- All questions must have unique question numbers
- Question numbers must be sequential starting from 1
- All required questions must be answered before scoring
- Score ranges for risk categories must not overlap
- Score ranges must cover the full possible score range (min to max)
- Asset allocation percentages must sum to 100%
- At least one questionnaire must be Active for each language

**HTTP Status Codes:**
- `200 OK` - Questionnaire retrieved successfully
- `404 Not Found` - Questionnaire not found
- `403 Forbidden` - Insufficient permissions

---

##### 10.4.2.3 Create Questionnaire Template

**Endpoint:** `POST /api/v1/risk-questionnaires`

**Description:** Create a new risk questionnaire template in Draft status.

**Request Body:**

```json
{
  "version": "5.0",
  "name": "Enhanced ATR Questionnaire 2026",
  "description": "Next generation questionnaire incorporating behavioral finance insights and ESG preferences",
  "language": {
    "code": "en-GB"
  },
  "estimatedCompletionTime": 15,
  "introductionText": "This enhanced questionnaire will help us understand your attitude towards investment risk, including your environmental and social preferences. Please answer all questions honestly - there are no right or wrong answers.",
  "completionText": "Thank you for completing the questionnaire. Your responses have been recorded and will be reviewed by your adviser to create a personalized investment recommendation.",
  "questions": [
    {
      "questionNumber": 1,
      "questionType": "SingleChoice",
      "category": "RiskCapacity",
      "questionText": "What is your primary investment time horizon?",
      "helpText": "Consider when you might need to access these funds",
      "required": true,
      "weight": 1.5,
      "displayOrder": 1,
      "answerOptions": [
        {
          "optionText": "Less than 1 year",
          "displayOrder": 1,
          "score": 1
        },
        {
          "optionText": "1-3 years",
          "displayOrder": 2,
          "score": 2
        },
        {
          "optionText": "3-5 years",
          "displayOrder": 3,
          "score": 3
        },
        {
          "optionText": "5-10 years",
          "displayOrder": 4,
          "score": 4
        },
        {
          "optionText": "More than 10 years",
          "displayOrder": 5,
          "score": 5
        }
      ]
    },
    {
      "questionNumber": 2,
      "questionType": "SingleChoice",
      "category": "RiskTolerance",
      "questionText": "During a market downturn, your investment portfolio loses 25% of its value over 3 months. What would you most likely do?",
      "helpText": "This helps us understand your emotional response to significant losses",
      "required": true,
      "weight": 2.0,
      "displayOrder": 2,
      "answerOptions": [
        {
          "optionText": "Sell everything immediately to stop further losses",
          "displayOrder": 1,
          "score": 1
        },
        {
          "optionText": "Reduce exposure by selling 50% of investments",
          "displayOrder": 2,
          "score": 2
        },
        {
          "optionText": "Hold current positions and wait for recovery",
          "displayOrder": 3,
          "score": 3
        },
        {
          "optionText": "Hold and invest regular monthly contributions",
          "displayOrder": 4,
          "score": 4
        },
        {
          "optionText": "Invest additional lump sum to buy at lower prices",
          "displayOrder": 5,
          "score": 5
        }
      ]
    }
  ],
  "scoringAlgorithm": {
    "method": "WeightedAverageWithBehavioralAdjustments",
    "description": "Weighted average with adjustments for behavioral biases and inconsistent responses"
  },
  "riskRatingCategories": [
    {
      "code": "VeryLowRisk",
      "display": "Very Low Risk - Capital Preservation",
      "description": "Focus on capital preservation with minimal volatility",
      "scoreRange": {
        "min": 1.0,
        "max": 1.8
      },
      "assetAllocationRecommendation": {
        "equities": {"min": 0, "max": 10, "target": 5},
        "bonds": {"min": 45, "max": 60, "target": 55},
        "cash": {"min": 30, "max": 55, "target": 40},
        "alternatives": {"min": 0, "max": 5, "target": 0}
      },
      "expectedAnnualReturn": {"min": 1.5, "max": 3.0, "target": 2.0},
      "expectedVolatility": {"min": 1.0, "max": 3.0, "target": 2.0}
    },
    {
      "code": "LowRisk",
      "display": "Low Risk - Income Focus",
      "description": "Income generation with low capital volatility",
      "scoreRange": {
        "min": 1.81,
        "max": 2.6
      },
      "assetAllocationRecommendation": {
        "equities": {"min": 10, "max": 25, "target": 20},
        "bonds": {"min": 45, "max": 60, "target": 50},
        "cash": {"min": 15, "max": 30, "target": 25},
        "alternatives": {"min": 0, "max": 10, "target": 5}
      },
      "expectedAnnualReturn": {"min": 2.5, "max": 4.5, "target": 3.5},
      "expectedVolatility": {"min": 3.0, "max": 6.0, "target": 4.5}
    }
  ]
}
```

**Response:**

```http
HTTP/1.1 201 Created
Location: /api/v1/risk-questionnaires/rq-2026-v5-draft
ETag: "xyz789abc123"
```

```json
{
  "id": "rq-2026-v5-draft",
  "version": "5.0",
  "name": "Enhanced ATR Questionnaire 2026",
  "description": "Next generation questionnaire incorporating behavioral finance insights and ESG preferences",
  "status": "Draft",
  "language": {
    "code": "en-GB",
    "display": "English (UK)"
  },
  "questionCount": 2,
  "estimatedCompletionTime": 15,
  "createdDate": "2026-02-17T10:30:00Z",
  "createdBy": {
    "id": "user-789",
    "name": "Compliance Team"
  },
  "lastModifiedDate": "2026-02-17T10:30:00Z",
  "lastModifiedBy": {
    "id": "user-789",
    "name": "Compliance Team"
  },
  "usageCount": 0,
  "_links": {
    "self": { "href": "/api/v1/risk-questionnaires/rq-2026-v5-draft" },
    "questions": { "href": "/api/v1/risk-questionnaires/rq-2026-v5-draft/questions" },
    "add-question": { "href": "/api/v1/risk-questionnaires/rq-2026-v5-draft/questions", "method": "POST" },
    "submit-for-approval": { "href": "/api/v1/risk-questionnaires/rq-2026-v5-draft/submit-for-approval", "method": "POST" },
    "update": { "href": "/api/v1/risk-questionnaires/rq-2026-v5-draft", "method": "PUT" },
    "delete": { "href": "/api/v1/risk-questionnaires/rq-2026-v5-draft", "method": "DELETE" }
  }
}
```

**Validation Rules:**
- `version` is required and must be unique
- `name` is required (max 200 characters)
- `language.code` must be valid ISO 639-1 language code
- `estimatedCompletionTime` must be positive integer (minutes)
- Questions must have sequential question numbers starting from 1
- All answer options must have display order starting from 1
- Score ranges in risk rating categories must not overlap
- Asset allocation percentages must sum to 100% (within tolerance of ±0.5%)
- At least 2 questions required before submission for approval
- At least 3 risk rating categories required

**HTTP Status Codes:**
- `201 Created` - Questionnaire created successfully
- `400 Bad Request` - Invalid request data
- `403 Forbidden` - Insufficient permissions
- `422 Unprocessable Entity` - Validation failed

**Error Response Example:**

```json
{
  "type": "https://api.factfind.com/errors/validation-error",
  "title": "Questionnaire Validation Failed",
  "status": 422,
  "detail": "Asset allocation percentages do not sum to 100%",
  "instance": "/api/v1/risk-questionnaires",
  "errors": [
    {
      "field": "riskRatingCategories[0].assetAllocationRecommendation",
      "message": "Asset allocation percentages sum to 95% but must equal 100%",
      "rejectedValue": {
        "equities": 5,
        "bonds": 55,
        "cash": 30,
        "alternatives": 5
      }
    }
  ]
}
```

---

##### 10.4.2.4 Activate Questionnaire Version

**Endpoint:** `POST /api/v1/risk-questionnaires/{id}/activate`

**Description:** Activate an approved questionnaire for use in new risk assessments. This will deactivate the currently active questionnaire for the same language.

**Request Body:**

```json
{
  "activationDate": "2026-03-01",
  "activationNotes": "Activating new version with enhanced behavioral finance questions. Previous version (v3.0) will be archived.",
  "notifyAdvisers": true,
  "migrationStrategy": "ImmediateForNew",
  "allowExistingToComplete": true
}
```

**Activation Strategies:**
- `ImmediateForNew` - New assessments use new version, existing in-progress assessments continue with old version
- `ImmediateForAll` - All assessments (including in-progress) use new version
- `PhaseIn` - Gradual rollout to subset of advisers before full activation

**Response:**

```http
HTTP/1.1 200 OK
```

```json
{
  "activationId": "act-20260217-001",
  "questionnaireId": "rq-2024-v3",
  "previouslyActiveQuestionnaireId": "rq-2024-v2",
  "activationDate": "2026-03-01",
  "activatedBy": {
    "id": "user-101",
    "name": "Head of Compliance"
  },
  "activationTimestamp": "2026-02-17T11:00:00Z",
  "migrationStrategy": "ImmediateForNew",
  "affectedAssessments": {
    "inProgress": 47,
    "toBeCompleted": 47,
    "newAssessments": "UnlimitedAfterActivationDate"
  },
  "previousQuestionnaireArchived": true,
  "notificationsSent": {
    "advisers": 125,
    "complianceOfficers": 5,
    "systemAdministrators": 3
  },
  "activationNotes": "Activating new version with enhanced behavioral finance questions. Previous version (v3.0) will be archived.",
  "_links": {
    "self": { "href": "/api/v1/risk-questionnaires/rq-2024-v3/activate" },
    "questionnaire": { "href": "/api/v1/risk-questionnaires/rq-2024-v3" },
    "previous-questionnaire": { "href": "/api/v1/risk-questionnaires/rq-2024-v2" },
    "active": { "href": "/api/v1/risk-questionnaires/active" }
  }
}
```

**Validation Rules:**
- Questionnaire must have status `Approved`
- `activationDate` must be today or future date
- Only one questionnaire can be Active per language at a time
- Previous active questionnaire will be automatically archived
- Cannot activate if questionnaire has validation errors
- Requires `risk:admin` permission

**HTTP Status Codes:**
- `200 OK` - Questionnaire activated successfully
- `400 Bad Request` - Invalid activation request
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Questionnaire not found
- `422 Unprocessable Entity` - Questionnaire not in Approved status

**Error Response Example:**

```json
{
  "type": "https://api.factfind.com/errors/activation-error",
  "title": "Questionnaire Activation Failed",
  "status": 422,
  "detail": "Cannot activate questionnaire that is not in Approved status",
  "instance": "/api/v1/risk-questionnaires/rq-2026-v5-draft/activate",
  "currentStatus": "Draft",
  "requiredStatus": "Approved",
  "recommendation": "Submit questionnaire for approval first using POST /api/v1/risk-questionnaires/{id}/submit-for-approval"
}
```

---

##### 10.4.2.5 Submit Client Responses

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/risk-questionnaires/{id}/responses`

**Description:** Submit client responses to a risk questionnaire. System calculates risk score and determines risk rating category.

**Request Body:**

```json
{
  "clientId": "client-123",
  "completedDate": "2026-02-17T14:30:00Z",
  "completedBy": "Client",
  "completionMethod": "OnlinePortal",
  "adviserPresent": true,
  "adviserId": "adv-789",
  "responses": [
    {
      "questionId": "q1",
      "questionNumber": 1,
      "answerType": "SingleChoice",
      "selectedOptionId": "q1-a4",
      "selectedOptionText": "5-10 years",
      "score": 4,
      "weight": 1.5,
      "weightedScore": 6.0
    },
    {
      "questionId": "q2",
      "questionNumber": 2,
      "answerType": "SingleChoice",
      "selectedOptionId": "q2-a3",
      "selectedOptionText": "Do nothing and wait for recovery",
      "score": 3,
      "weight": 2.0,
      "weightedScore": 6.0
    },
    {
      "questionId": "q3",
      "questionNumber": 3,
      "answerType": "Slider",
      "sliderValue": 6,
      "score": 6,
      "weight": 1.8,
      "weightedScore": 10.8
    },
    {
      "questionId": "q4",
      "questionNumber": 4,
      "answerType": "SingleChoice",
      "selectedOptionId": "q4-a3",
      "selectedOptionText": "Good - I understand most investment concepts",
      "score": 3,
      "weight": 1.2,
      "weightedScore": 3.6
    },
    {
      "questionId": "q5",
      "questionNumber": 5,
      "answerType": "SingleChoice",
      "selectedOptionId": "q5-a4",
      "selectedOptionText": "10-25%",
      "score": 4,
      "weight": 1.6,
      "weightedScore": 6.4
    },
    {
      "questionId": "q6",
      "questionNumber": 6,
      "answerType": "SingleChoice",
      "selectedOptionId": "q6-a3",
      "selectedOptionText": "3-6 months",
      "score": 4,
      "weight": 1.3,
      "weightedScore": 5.2
    },
    {
      "questionId": "q7",
      "questionNumber": 7,
      "answerType": "SingleChoice",
      "selectedOptionId": "q7-a3",
      "selectedOptionText": "Balance income and growth with moderate risk",
      "score": 3,
      "weight": 1.7,
      "weightedScore": 5.1
    },
    {
      "questionId": "q8",
      "questionNumber": 8,
      "answerType": "Ranking",
      "rankedOptions": [
        {"optionId": "q8-opt3", "rank": 1, "score": 5},
        {"optionId": "q8-opt4", "rank": 2, "score": 3},
        {"optionId": "q8-opt2", "rank": 3, "score": 2},
        {"optionId": "q8-opt1", "rank": 4, "score": 1}
      ],
      "score": 2.75,
      "weight": 1.5,
      "weightedScore": 4.125
    },
    {
      "questionId": "q9",
      "questionNumber": 9,
      "answerType": "SingleChoice",
      "selectedOptionId": "q9-a2",
      "selectedOptionText": "Employed - stable income",
      "score": 4,
      "weight": 1.1,
      "weightedScore": 4.4
    },
    {
      "questionId": "q10",
      "questionNumber": 10,
      "answerType": "MultipleChoice",
      "selectedOptionIds": ["q10-a2", "q10-a3", "q10-a4"],
      "selectedOptionTexts": ["Fixed income bonds", "Investment funds (unit trusts, OEICs)", "Individual shares/stocks"],
      "selectedScores": [2, 3, 4],
      "score": 3.0,
      "weight": 1.0,
      "weightedScore": 3.0
    },
    {
      "questionId": "q11",
      "questionNumber": 11,
      "answerType": "SingleChoice",
      "selectedOptionId": "q11-a4",
      "selectedOptionText": "Quarterly",
      "score": 4,
      "weight": 0.8,
      "weightedScore": 3.2
    },
    {
      "questionId": "q12",
      "questionNumber": 12,
      "answerType": "SingleChoice",
      "selectedOptionId": "q12-a3",
      "selectedOptionText": "Yes, within 3-5 years",
      "score": 3,
      "weight": 1.4,
      "weightedScore": 4.2
    },
    {
      "questionId": "q13",
      "questionNumber": 13,
      "answerType": "SingleChoice",
      "selectedOptionId": "q13-a2",
      "selectedOptionText": "Probably choose Investment A",
      "score": 2,
      "weight": 2.0,
      "weightedScore": 4.0
    },
    {
      "questionId": "q14",
      "questionNumber": 14,
      "answerType": "SingleChoice",
      "selectedOptionId": "q14-a2",
      "selectedOptionText": "30-44",
      "score": 4,
      "weight": 1.3,
      "weightedScore": 5.2
    },
    {
      "questionId": "q15",
      "questionNumber": 15,
      "answerType": "SingleChoice",
      "selectedOptionId": "q15-a3",
      "selectedOptionText": "Neutral - I understand volatility is normal",
      "score": 3,
      "weight": 1.9,
      "weightedScore": 5.7
    }
  ],
  "additionalNotes": "Client expressed concern about recent market volatility but understands the importance of long-term investing."
}
```

**Response:**

```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/factfind-456/risk-profiles/rp-789
ETag: "abc123def456"
```

```json
{
  "id": "rp-789",
  "factfindId": "factfind-456",
  "clientId": "client-123",
  "questionnaireId": "rq-2024-v3",
  "questionnaireVersion": "3.0",
  "questionnaireName": "Standard Attitude to Risk Questionnaire 2024",
  "completedDate": "2026-02-17T14:30:00Z",
  "completedBy": "Client",
  "completionMethod": "OnlinePortal",
  "adviserPresent": true,
  "adviserId": "adv-789",
  "totalQuestions": 15,
  "questionsAnswered": 15,
  "completionPercentage": 100.0,
  "scoring": {
    "rawScore": 76.925,
    "totalWeight": 21.6,
    "normalizedScore": 3.56,
    "scoreMethod": "WeightedAverage",
    "minPossibleScore": 1.0,
    "maxPossibleScore": 5.0
  },
  "riskRating": {
    "code": "MediumRisk",
    "display": "Medium Risk",
    "description": "Balanced approach with moderate equity exposure for growth and income.",
    "scoreRange": {
      "min": 2.61,
      "max": 3.4
    },
    "confidence": "High",
    "confidenceScore": 92.5
  },
  "assetAllocationRecommendation": {
    "equities": {
      "min": 35,
      "max": 55,
      "target": 45,
      "amount": null
    },
    "bonds": {
      "min": 25,
      "max": 40,
      "target": 30,
      "amount": null
    },
    "cash": {
      "min": 5,
      "max": 20,
      "target": 15,
      "amount": null
    },
    "alternatives": {
      "min": 5,
      "max": 15,
      "target": 10,
      "amount": null
    }
  },
  "expectedPerformance": {
    "annualReturn": {
      "min": 4.5,
      "max": 7.0,
      "target": 5.5
    },
    "volatility": {
      "min": 6.0,
      "max": 10.0,
      "target": 8.0
    }
  },
  "suitableProductTypes": [
    "BalancedManagedFunds",
    "MultiAssetISA",
    "DiversifiedPortfolio",
    "IncomeAndGrowthFunds"
  ],
  "riskCapacityScore": 3.8,
  "riskToleranceScore": 3.2,
  "investmentExperienceScore": 3.0,
  "responses": [
    {
      "questionId": "q1",
      "questionNumber": 1,
      "questionText": "What is your investment time horizon?",
      "category": "RiskCapacity",
      "answerType": "SingleChoice",
      "selectedOptionText": "5-10 years",
      "score": 4,
      "weight": 1.5,
      "weightedScore": 6.0
    },
    {
      "questionId": "q2",
      "questionNumber": 2,
      "questionText": "If the value of your investment fell by 20% in the first year, what would you do?",
      "category": "RiskTolerance",
      "answerType": "SingleChoice",
      "selectedOptionText": "Do nothing and wait for recovery",
      "score": 3,
      "weight": 2.0,
      "weightedScore": 6.0
    }
  ],
  "additionalNotes": "Client expressed concern about recent market volatility but understands the importance of long-term investing.",
  "adviserOverride": null,
  "regulatoryWarnings": [
    {
      "type": "RiskWarning",
      "message": "Investment values can go down as well as up and you may get back less than you invest",
      "acknowledged": false
    },
    {
      "type": "NoGuarantee",
      "message": "Past performance is not a reliable indicator of future results",
      "acknowledged": false
    }
  ],
  "nextReviewDate": "2027-02-17",
  "createdDate": "2026-02-17T14:35:00Z",
  "lastModifiedDate": "2026-02-17T14:35:00Z",
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-789" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "client": { "href": "/api/v1/clients/client-123" },
    "questionnaire": { "href": "/api/v1/risk-questionnaires/rq-2024-v3" },
    "history": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/history" },
    "update": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-789", "method": "PUT" }
  }
}
```

**Completion Methods:**
- `OnlinePortal` - Client completed via online portal
- `InMeeting` - Completed during adviser meeting
- `PaperBased` - Completed on paper and entered by adviser
- `Telephone` - Completed via telephone with adviser
- `Video` - Completed via video call with adviser

**Validation Rules:**
- All required questions must be answered
- Question IDs must match questionnaire template
- Selected option IDs must be valid for the question
- Slider values must be within min/max range
- Ranking must include all options exactly once
- Multiple choice must respect min/max selection constraints
- `completedDate` cannot be in the future
- Client must belong to the fact find

**HTTP Status Codes:**
- `201 Created` - Responses submitted and risk profile created
- `400 Bad Request` - Invalid request data
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Fact find or questionnaire not found
- `422 Unprocessable Entity` - Validation failed (incomplete responses)

**Error Response Example:**

```json
{
  "type": "https://api.factfind.com/errors/incomplete-questionnaire",
  "title": "Questionnaire Incomplete",
  "status": 422,
  "detail": "Cannot submit questionnaire with missing required questions",
  "instance": "/api/v1/factfinds/factfind-456/risk-questionnaires/rq-2024-v3/responses",
  "totalQuestions": 15,
  "answeredQuestions": 13,
  "missingQuestions": [
    {
      "questionId": "q7",
      "questionNumber": 7,
      "questionText": "Which statement best describes your investment objectives?"
    },
    {
      "questionId": "q12",
      "questionNumber": 12,
      "questionText": "Do you expect any major expenses in the next 5 years?"
    }
  ]
}
```

---
