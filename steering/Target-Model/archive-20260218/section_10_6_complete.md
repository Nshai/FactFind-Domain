### 10.6 Supplementary Questions API

**Purpose:** Capture additional risk-related and general supplementary questions beyond the standard ATR questionnaire.

**Scope:**
- Risk-specific supplementary questions (dependants, time horizon, emergency funds, retirement plans)
- General supplementary questions (Will, LPA, estate planning, health conditions)
- Compliance supplementary questions (previous advice received, understanding of disclosures)
- Custom question sets per firm/adviser
- Question response tracking with audit trail
- Completion status monitoring and reminders
- Conditional question logic (show questions based on previous answers)
- Integration with risk profiling and suitability assessment

**Aggregate Root:** FactFind (supplementary questions are nested within)

**Regulatory Compliance:**
- FCA COBS 9.2 (Assessing Suitability - Understanding Client Needs)
- FCA COBS 9 Annex 1 (Demands and Needs)
- MiFID II Article 25 (Information from Clients)
- Consumer Duty (Understanding Customer Needs and Characteristics)
- Vulnerable Customers Guidance (FG21/1 - Identifying Vulnerability)

#### 10.6.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/supplementary-questions` | Get supplementary questions | `factfind:read` |
| GET | `/api/v1/factfinds/{factfindId}/supplementary-questions/by-category` | Get questions grouped by category | `factfind:read` |
| POST | `/api/v1/factfinds/{factfindId}/supplementary-questions/responses` | Submit responses | `factfind:write` |
| PUT | `/api/v1/factfinds/{factfindId}/supplementary-questions/responses/{id}` | Update response | `factfind:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/supplementary-questions/responses/{id}` | Delete response | `factfind:write` |
| GET | `/api/v1/factfinds/{factfindId}/supplementary-questions/responses` | Get all responses | `factfind:read` |
| GET | `/api/v1/factfinds/{factfindId}/supplementary-questions/completion-status` | Get completion status | `factfind:read` |
| POST | `/api/v1/factfinds/{factfindId}/supplementary-questions/bulk-response` | Submit multiple responses at once | `factfind:write` |
| GET | `/api/v1/supplementary-questions/templates` | Get question templates (firm-level) | `admin:read` |
| POST | `/api/v1/supplementary-questions/templates` | Create custom question template | `admin:write` |

#### 10.6.2 Key Endpoints

##### 10.6.2.1 Get Supplementary Questions

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/supplementary-questions`

**Description:** Get all supplementary questions applicable to a fact find, organized by category with existing responses if available.

**Query Parameters:**
- `category` - Filter by category: Risk, General, Compliance, Custom
- `includeOptional` - Include optional questions (default: true)
- `includeConditional` - Include conditional questions (default: true)
- `status` - Filter by status: Unanswered, Partial, Complete

**Response:**

```json
{
  "factfindId": "factfind-456",
  "clientId": "client-123",
  "clientName": "John Smith",
  "questionSetVersion": "2024-v1",
  "effectiveDate": "2026-02-17",
  "totalQuestions": 45,
  "answeredQuestions": 32,
  "completionPercentage": 71.1,
  "categories": [
    {
      "category": "Risk",
      "categoryDisplay": "Risk & Capacity for Loss",
      "description": "Questions to assess risk capacity, time horizon, and financial resilience",
      "questionCount": 15,
      "answeredCount": 12,
      "completionPercentage": 80.0,
      "required": true,
      "questions": [
        {
          "id": "sq-risk-001",
          "questionNumber": 1,
          "questionText": "How many financial dependants do you have?",
          "helpText": "Include children under 18, adult children in education, elderly parents, or others financially dependent on you",
          "questionType": "Number",
          "category": "Risk",
          "subcategory": "Dependants",
          "required": true,
          "displayOrder": 1,
          "validationRules": {
            "minValue": 0,
            "maxValue": 20,
            "allowDecimals": false
          },
          "response": {
            "responseId": "resp-001",
            "value": 2,
            "displayValue": "2 dependants",
            "answeredDate": "2026-02-15T10:30:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T10:30:00Z"
          },
          "impactOnRiskAssessment": {
            "affectsCapacityForLoss": true,
            "reasoning": "More dependants typically reduce capacity for loss due to greater financial obligations"
          }
        },
        {
          "id": "sq-risk-002",
          "questionText": "What are the ages of your dependants?",
          "helpText": "Separate ages with commas (e.g., 8, 12, 15)",
          "questionType": "Text",
          "category": "Risk",
          "subcategory": "Dependants",
          "required": false,
          "displayOrder": 2,
          "conditionalLogic": {
            "showIf": {
              "questionId": "sq-risk-001",
              "operator": "GreaterThan",
              "value": 0
            }
          },
          "response": {
            "responseId": "resp-002",
            "value": "12, 15",
            "displayValue": "Ages: 12, 15",
            "answeredDate": "2026-02-15T10:32:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T10:32:00Z"
          }
        },
        {
          "id": "sq-risk-003",
          "questionText": "How long until your youngest dependant becomes financially independent?",
          "helpText": "Estimate in years",
          "questionType": "Number",
          "category": "Risk",
          "subcategory": "Dependants",
          "required": false,
          "displayOrder": 3,
          "validationRules": {
            "minValue": 0,
            "maxValue": 30,
            "allowDecimals": false
          },
          "conditionalLogic": {
            "showIf": {
              "questionId": "sq-risk-001",
              "operator": "GreaterThan",
              "value": 0
            }
          },
          "response": {
            "responseId": "resp-003",
            "value": 6,
            "displayValue": "6 years",
            "answeredDate": "2026-02-15T10:33:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T10:33:00Z"
          },
          "impactOnRiskAssessment": {
            "affectsCapacityForLoss": true,
            "affectsTimeHorizon": true,
            "reasoning": "Shorter dependency period increases capacity for loss as obligations reduce sooner"
          }
        },
        {
          "id": "sq-risk-004",
          "questionText": "How much do you have in accessible emergency funds (cash, instant access savings)?",
          "helpText": "Amount readily available without penalties or delays",
          "questionType": "Currency",
          "category": "Risk",
          "subcategory": "EmergencyFunds",
          "required": true,
          "displayOrder": 4,
          "validationRules": {
            "minValue": 0,
            "currency": "GBP"
          },
          "response": {
            "responseId": "resp-004",
            "value": 25000.00,
            "displayValue": "£25,000",
            "answeredDate": "2026-02-15T10:35:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T10:35:00Z"
          },
          "impactOnRiskAssessment": {
            "affectsCapacityForLoss": true,
            "reasoning": "Adequate emergency fund increases capacity for investment risk"
          }
        },
        {
          "id": "sq-risk-005",
          "questionText": "What are your average monthly essential expenses?",
          "helpText": "Include mortgage/rent, utilities, food, insurance, and other essentials",
          "questionType": "Currency",
          "category": "Risk",
          "subcategory": "EmergencyFunds",
          "required": true,
          "displayOrder": 5,
          "validationRules": {
            "minValue": 0,
            "currency": "GBP"
          },
          "response": {
            "responseId": "resp-005",
            "value": 3500.00,
            "displayValue": "£3,500 per month",
            "answeredDate": "2026-02-15T10:37:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T10:37:00Z"
          },
          "derivedMetrics": {
            "emergencyFundCoverage": {
              "months": 7.1,
              "adequacy": "Excellent",
              "targetMonths": 6.0,
              "exceedsTarget": true
            }
          }
        },
        {
          "id": "sq-risk-006",
          "questionText": "At what age do you plan to retire?",
          "helpText": "Your planned retirement age affects your investment time horizon",
          "questionType": "Number",
          "category": "Risk",
          "subcategory": "TimeHorizon",
          "required": true,
          "displayOrder": 6,
          "validationRules": {
            "minValue": 50,
            "maxValue": 80,
            "allowDecimals": false
          },
          "response": {
            "responseId": "resp-006",
            "value": 67,
            "displayValue": "Age 67",
            "answeredDate": "2026-02-15T10:40:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T10:40:00Z"
          },
          "derivedMetrics": {
            "yearsToRetirement": 22,
            "timeHorizonCategory": "LongTerm",
            "appropriateForGrowthInvesting": true
          },
          "impactOnRiskAssessment": {
            "affectsTimeHorizon": true,
            "reasoning": "Longer time horizon allows greater capacity to absorb short-term volatility"
          }
        },
        {
          "id": "sq-risk-007",
          "questionText": "Do you expect to receive any inheritances or windfalls in the next 10 years?",
          "helpText": "Expected inheritances can affect your overall financial capacity",
          "questionType": "SingleChoice",
          "category": "Risk",
          "subcategory": "FutureIncome",
          "required": false,
          "displayOrder": 7,
          "answerOptions": [
            {
              "id": "opt-yes-significant",
              "optionText": "Yes, significant (>£100,000)",
              "value": "YesSignificant"
            },
            {
              "id": "opt-yes-moderate",
              "optionText": "Yes, moderate (£25,000-£100,000)",
              "value": "YesModerate"
            },
            {
              "id": "opt-yes-small",
              "optionText": "Yes, small (<£25,000)",
              "value": "YesSmall"
            },
            {
              "id": "opt-no",
              "optionText": "No",
              "value": "No"
            },
            {
              "id": "opt-unknown",
              "optionText": "Unknown/Uncertain",
              "value": "Unknown"
            }
          ],
          "response": {
            "responseId": "resp-007",
            "value": "No",
            "displayValue": "No expected inheritances",
            "selectedOptionId": "opt-no",
            "answeredDate": "2026-02-15T10:42:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T10:42:00Z"
          }
        },
        {
          "id": "sq-risk-008",
          "questionText": "What percentage of portfolio loss could you tolerate in a single year before feeling compelled to sell?",
          "helpText": "Be realistic - this helps us recommend suitable investments",
          "questionType": "Percentage",
          "category": "Risk",
          "subcategory": "LossTolerance",
          "required": true,
          "displayOrder": 8,
          "validationRules": {
            "minValue": 0,
            "maxValue": 100,
            "allowDecimals": true
          },
          "response": {
            "responseId": "resp-008",
            "value": 15.0,
            "displayValue": "15%",
            "answeredDate": "2026-02-15T10:45:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T10:45:00Z"
          },
          "impactOnRiskAssessment": {
            "affectsRiskTolerance": true,
            "reasoning": "Lower loss tolerance suggests more conservative investment approach needed"
          }
        },
        {
          "id": "sq-risk-009",
          "questionText": "Do you have other significant assets not included in this investment plan?",
          "helpText": "E.g., property, business interests, other investments",
          "questionType": "SingleChoice",
          "category": "Risk",
          "subcategory": "OtherAssets",
          "required": true,
          "displayOrder": 9,
          "answerOptions": [
            {
              "id": "opt-no-other",
              "optionText": "No, this represents all my assets",
              "value": "NoOther"
            },
            {
              "id": "opt-yes-some",
              "optionText": "Yes, but less than 25% of total wealth",
              "value": "YesMinor"
            },
            {
              "id": "opt-yes-substantial",
              "optionText": "Yes, 25-50% of total wealth",
              "value": "YesModerate"
            },
            {
              "id": "opt-yes-majority",
              "optionText": "Yes, more than 50% of total wealth",
              "value": "YesMajority"
            }
          ],
          "response": {
            "responseId": "resp-009",
            "value": "YesModerate",
            "displayValue": "Yes, 25-50% of total wealth",
            "selectedOptionId": "opt-yes-substantial",
            "answeredDate": "2026-02-15T10:47:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T10:47:00Z"
          },
          "impactOnRiskAssessment": {
            "affectsCapacityForLoss": true,
            "reasoning": "Other assets provide diversification and increase capacity for loss in this portfolio"
          }
        },
        {
          "id": "sq-risk-010",
          "questionText": "Are you expecting any major life changes in the next 5 years?",
          "helpText": "E.g., marriage, divorce, career change, relocation, major purchases",
          "questionType": "MultipleChoice",
          "category": "Risk",
          "subcategory": "LifeEvents",
          "required": false,
          "displayOrder": 10,
          "answerOptions": [
            {
              "id": "opt-none",
              "optionText": "None expected",
              "value": "None"
            },
            {
              "id": "opt-marriage",
              "optionText": "Marriage/Civil Partnership",
              "value": "Marriage"
            },
            {
              "id": "opt-children",
              "optionText": "Having children",
              "value": "Children"
            },
            {
              "id": "opt-career",
              "optionText": "Career change",
              "value": "CareerChange"
            },
            {
              "id": "opt-relocation",
              "optionText": "Relocation/Moving house",
              "value": "Relocation"
            },
            {
              "id": "opt-business",
              "optionText": "Starting a business",
              "value": "Business"
            },
            {
              "id": "opt-education",
              "optionText": "Education expenses",
              "value": "Education"
            }
          ],
          "response": {
            "responseId": "resp-010",
            "value": ["Education"],
            "displayValue": "Education expenses",
            "selectedOptionIds": ["opt-education"],
            "answeredDate": "2026-02-15T10:50:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T10:50:00Z"
          }
        },
        {
          "id": "sq-risk-011",
          "questionText": "Do you have adequate life insurance/protection in place?",
          "helpText": "Life insurance, critical illness, income protection",
          "questionType": "SingleChoice",
          "category": "Risk",
          "subcategory": "Protection",
          "required": true,
          "displayOrder": 11,
          "answerOptions": [
            {
              "id": "opt-adequate",
              "optionText": "Yes, adequate coverage",
              "value": "Adequate"
            },
            {
              "id": "opt-partial",
              "optionText": "Partial coverage",
              "value": "Partial"
            },
            {
              "id": "opt-none",
              "optionText": "No coverage",
              "value": "None"
            },
            {
              "id": "opt-unsure",
              "optionText": "Unsure/need to review",
              "value": "Unsure"
            }
          ],
          "response": {
            "responseId": "resp-011",
            "value": "Adequate",
            "displayValue": "Yes, adequate coverage",
            "selectedOptionId": "opt-adequate",
            "answeredDate": "2026-02-15T10:52:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T10:52:00Z"
          },
          "impactOnRiskAssessment": {
            "affectsCapacityForLoss": true,
            "reasoning": "Adequate protection increases capacity for investment risk by providing financial safety net"
          }
        },
        {
          "id": "sq-risk-012",
          "questionText": "How stable is your employment/income?",
          "helpText": "Job security and income stability affect your capacity for loss",
          "questionType": "SingleChoice",
          "category": "Risk",
          "subcategory": "IncomeStability",
          "required": true,
          "displayOrder": 12,
          "answerOptions": [
            {
              "id": "opt-very-stable",
              "optionText": "Very stable (permanent role, secure industry)",
              "value": "VeryStable"
            },
            {
              "id": "opt-stable",
              "optionText": "Stable (good job security)",
              "value": "Stable"
            },
            {
              "id": "opt-variable",
              "optionText": "Variable (self-employed, commission-based)",
              "value": "Variable"
            },
            {
              "id": "opt-uncertain",
              "optionText": "Uncertain (temporary, at-risk industry)",
              "value": "Uncertain"
            },
            {
              "id": "opt-retired",
              "optionText": "Retired/Not working",
              "value": "Retired"
            }
          ],
          "response": {
            "responseId": "resp-012",
            "value": "Stable",
            "displayValue": "Stable (good job security)",
            "selectedOptionId": "opt-stable",
            "answeredDate": "2026-02-15T10:55:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T10:55:00Z"
          },
          "impactOnRiskAssessment": {
            "affectsCapacityForLoss": true,
            "reasoning": "Stable employment increases capacity to maintain investments during downturns"
          }
        },
        {
          "id": "sq-risk-013",
          "questionText": "Are you currently in debt (excluding mortgage)?",
          "helpText": "Credit cards, loans, overdrafts",
          "questionType": "YesNo",
          "category": "Risk",
          "subcategory": "Debt",
          "required": true,
          "displayOrder": 13,
          "response": null,
          "followUpQuestion": {
            "questionId": "sq-risk-014",
            "showIfValue": "Yes"
          }
        },
        {
          "id": "sq-risk-014",
          "questionText": "What is your total non-mortgage debt?",
          "helpText": "Total amount owed on credit cards, loans, etc.",
          "questionType": "Currency",
          "category": "Risk",
          "subcategory": "Debt",
          "required": false,
          "displayOrder": 14,
          "validationRules": {
            "minValue": 0,
            "currency": "GBP"
          },
          "conditionalLogic": {
            "showIf": {
              "questionId": "sq-risk-013",
              "operator": "Equals",
              "value": "Yes"
            }
          },
          "response": null,
          "impactOnRiskAssessment": {
            "affectsCapacityForLoss": true,
            "reasoning": "High debt levels reduce capacity for investment risk"
          }
        },
        {
          "id": "sq-risk-015",
          "questionText": "How would you describe your overall health?",
          "helpText": "Health status can affect financial planning and risk capacity",
          "questionType": "SingleChoice",
          "category": "Risk",
          "subcategory": "Health",
          "required": false,
          "displayOrder": 15,
          "answerOptions": [
            {
              "id": "opt-excellent",
              "optionText": "Excellent",
              "value": "Excellent"
            },
            {
              "id": "opt-good",
              "optionText": "Good",
              "value": "Good"
            },
            {
              "id": "opt-fair",
              "optionText": "Fair",
              "value": "Fair"
            },
            {
              "id": "opt-poor",
              "optionText": "Poor",
              "value": "Poor"
            },
            {
              "id": "opt-prefer-not",
              "optionText": "Prefer not to say",
              "value": "PreferNotToSay"
            }
          ],
          "response": {
            "responseId": "resp-015",
            "value": "Good",
            "displayValue": "Good",
            "selectedOptionId": "opt-good",
            "answeredDate": "2026-02-15T11:00:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:00:00Z"
          },
          "vulnerabilityIndicator": {
            "mayIndicateVulnerability": false,
            "requiresAdditionalSupport": false
          }
        }
      ]
    },
    {
      "category": "General",
      "categoryDisplay": "General Financial Planning",
      "description": "Questions about wills, estate planning, and general financial matters",
      "questionCount": 12,
      "answeredCount": 10,
      "completionPercentage": 83.3,
      "required": true,
      "questions": [
        {
          "id": "sq-gen-001",
          "questionText": "Do you have a valid Will in place?",
          "helpText": "A Will ensures your assets are distributed according to your wishes",
          "questionType": "YesNo",
          "category": "General",
          "subcategory": "EstatePlanning",
          "required": true,
          "displayOrder": 1,
          "response": {
            "responseId": "resp-g001",
            "value": "Yes",
            "displayValue": "Yes",
            "answeredDate": "2026-02-15T11:05:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:05:00Z"
          },
          "followUpQuestion": {
            "questionId": "sq-gen-002",
            "showIfValue": "Yes"
          }
        },
        {
          "id": "sq-gen-002",
          "questionText": "When was your Will last reviewed or updated?",
          "helpText": "Wills should be reviewed every 5 years or after major life events",
          "questionType": "Date",
          "category": "General",
          "subcategory": "EstatePlanning",
          "required": false,
          "displayOrder": 2,
          "conditionalLogic": {
            "showIf": {
              "questionId": "sq-gen-001",
              "operator": "Equals",
              "value": "Yes"
            }
          },
          "response": {
            "responseId": "resp-g002",
            "value": "2023-01-15",
            "displayValue": "15 January 2023",
            "answeredDate": "2026-02-15T11:07:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:07:00Z"
          },
          "derivedMetrics": {
            "yearsSinceReview": 3.1,
            "reviewRecommended": false,
            "nextReviewDue": "2028-01-15"
          }
        },
        {
          "id": "sq-gen-003",
          "questionText": "Do you have a Lasting Power of Attorney (LPA) in place?",
          "helpText": "LPA allows someone to make decisions on your behalf if you lose capacity",
          "questionType": "MultipleChoice",
          "category": "General",
          "subcategory": "EstatePlanning",
          "required": true,
          "displayOrder": 3,
          "answerOptions": [
            {
              "id": "opt-none",
              "optionText": "No LPA in place",
              "value": "None"
            },
            {
              "id": "opt-property",
              "optionText": "LPA for Property and Financial Affairs",
              "value": "PropertyFinancial"
            },
            {
              "id": "opt-health",
              "optionText": "LPA for Health and Welfare",
              "value": "HealthWelfare"
            },
            {
              "id": "opt-both",
              "optionText": "Both types of LPA",
              "value": "Both"
            }
          ],
          "response": {
            "responseId": "resp-g003",
            "value": ["PropertyFinancial"],
            "displayValue": "LPA for Property and Financial Affairs",
            "selectedOptionIds": ["opt-property"],
            "answeredDate": "2026-02-15T11:10:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:10:00Z"
          }
        },
        {
          "id": "sq-gen-004",
          "questionText": "Have you made any significant gifts in the last 7 years?",
          "helpText": "Gifts over £3,000 per year may have inheritance tax implications",
          "questionType": "YesNo",
          "category": "General",
          "subcategory": "EstatePlanning",
          "required": true,
          "displayOrder": 4,
          "response": {
            "responseId": "resp-g004",
            "value": "No",
            "displayValue": "No",
            "answeredDate": "2026-02-15T11:12:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:12:00Z"
          }
        },
        {
          "id": "sq-gen-005",
          "questionText": "Are you a UK resident for tax purposes?",
          "helpText": "Tax residency affects your tax obligations and investment options",
          "questionType": "YesNo",
          "category": "General",
          "subcategory": "TaxStatus",
          "required": true,
          "displayOrder": 5,
          "response": {
            "responseId": "resp-g005",
            "value": "Yes",
            "displayValue": "Yes",
            "answeredDate": "2026-02-15T11:15:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:15:00Z"
          }
        },
        {
          "id": "sq-gen-006",
          "questionText": "Do you expect your tax status to change in the next 5 years?",
          "helpText": "E.g., moving abroad, domicile changes",
          "questionType": "YesNo",
          "category": "General",
          "subcategory": "TaxStatus",
          "required": false,
          "displayOrder": 6,
          "response": {
            "responseId": "resp-g006",
            "value": "No",
            "displayValue": "No",
            "answeredDate": "2026-02-15T11:17:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:17:00Z"
          }
        },
        {
          "id": "sq-gen-007",
          "questionText": "Do you have any specific ethical, religious, or environmental investment preferences?",
          "helpText": "E.g., ESG investing, Sharia-compliant, excluding certain sectors",
          "questionType": "Text",
          "category": "General",
          "subcategory": "InvestmentPreferences",
          "required": false,
          "displayOrder": 7,
          "response": {
            "responseId": "resp-g007",
            "value": "Prefer ESG-focused funds, exclude tobacco and weapons",
            "displayValue": "Prefer ESG-focused funds, exclude tobacco and weapons",
            "answeredDate": "2026-02-15T11:20:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:20:00Z"
          }
        },
        {
          "id": "sq-gen-008",
          "questionText": "Are you involved in any business partnerships or trusts?",
          "helpText": "Business interests may affect your financial planning",
          "questionType": "YesNo",
          "category": "General",
          "subcategory": "BusinessInterests",
          "required": true,
          "displayOrder": 8,
          "response": {
            "responseId": "resp-g008",
            "value": "No",
            "displayValue": "No",
            "answeredDate": "2026-02-15T11:22:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:22:00Z"
          }
        },
        {
          "id": "sq-gen-009",
          "questionText": "Do you have any charitable giving plans or commitments?",
          "helpText": "Regular charitable donations or planned bequests",
          "questionType": "YesNo",
          "category": "General",
          "subcategory": "CharitableGiving",
          "required": false,
          "displayOrder": 9,
          "response": {
            "responseId": "resp-g009",
            "value": "Yes",
            "displayValue": "Yes",
            "answeredDate": "2026-02-15T11:25:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:25:00Z"
          }
        },
        {
          "id": "sq-gen-010",
          "questionText": "How frequently do you want to receive statements and reports?",
          "helpText": "Choose your preferred reporting frequency",
          "questionType": "SingleChoice",
          "category": "General",
          "subcategory": "ServicePreferences",
          "required": false,
          "displayOrder": 10,
          "answerOptions": [
            {
              "id": "opt-monthly",
              "optionText": "Monthly",
              "value": "Monthly"
            },
            {
              "id": "opt-quarterly",
              "optionText": "Quarterly",
              "value": "Quarterly"
            },
            {
              "id": "opt-half-yearly",
              "optionText": "Half-yearly",
              "value": "HalfYearly"
            },
            {
              "id": "opt-annually",
              "optionText": "Annually",
              "value": "Annually"
            }
          ],
          "response": {
            "responseId": "resp-g010",
            "value": "Quarterly",
            "displayValue": "Quarterly",
            "selectedOptionId": "opt-quarterly",
            "answeredDate": "2026-02-15T11:27:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:27:00Z"
          }
        },
        {
          "id": "sq-gen-011",
          "questionText": "Do you require any accessibility support or reasonable adjustments?",
          "helpText": "E.g., large print documents, audio format, additional meeting time",
          "questionType": "Text",
          "category": "General",
          "subcategory": "Accessibility",
          "required": false,
          "displayOrder": 11,
          "response": null,
          "vulnerabilityIndicator": {
            "mayIndicateVulnerability": true,
            "requiresAdditionalSupport": true,
            "supportType": "AccessibilityAccommodations"
          }
        },
        {
          "id": "sq-gen-012",
          "questionText": "Is there anything else we should know to provide you with the best possible advice?",
          "helpText": "Any additional information that might be relevant",
          "questionType": "TextArea",
          "category": "General",
          "subcategory": "AdditionalInformation",
          "required": false,
          "displayOrder": 12,
          "response": null
        }
      ]
    },
    {
      "category": "Compliance",
      "categoryDisplay": "Compliance & Regulatory",
      "description": "Regulatory and compliance questions required by FCA",
      "questionCount": 10,
      "answeredCount": 8,
      "completionPercentage": 80.0,
      "required": true,
      "questions": [
        {
          "id": "sq-comp-001",
          "questionText": "Have you received financial advice in the past 5 years?",
          "helpText": "From any financial adviser or institution",
          "questionType": "YesNo",
          "category": "Compliance",
          "subcategory": "PreviousAdvice",
          "required": true,
          "displayOrder": 1,
          "response": {
            "responseId": "resp-c001",
            "value": "Yes",
            "displayValue": "Yes",
            "answeredDate": "2026-02-15T11:30:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:30:00Z"
          },
          "followUpQuestion": {
            "questionId": "sq-comp-002",
            "showIfValue": "Yes"
          }
        },
        {
          "id": "sq-comp-002",
          "questionText": "What type of advice did you receive?",
          "helpText": "Select all that apply",
          "questionType": "MultipleChoice",
          "category": "Compliance",
          "subcategory": "PreviousAdvice",
          "required": false,
          "displayOrder": 2,
          "conditionalLogic": {
            "showIf": {
              "questionId": "sq-comp-001",
              "operator": "Equals",
              "value": "Yes"
            }
          },
          "answerOptions": [
            {
              "id": "opt-pension",
              "optionText": "Pensions advice",
              "value": "Pensions"
            },
            {
              "id": "opt-investment",
              "optionText": "Investment advice",
              "value": "Investment"
            },
            {
              "id": "opt-protection",
              "optionText": "Protection/Insurance advice",
              "value": "Protection"
            },
            {
              "id": "opt-mortgage",
              "optionText": "Mortgage advice",
              "value": "Mortgage"
            },
            {
              "id": "opt-estate",
              "optionText": "Estate planning advice",
              "value": "EstatePlanning"
            },
            {
              "id": "opt-other",
              "optionText": "Other",
              "value": "Other"
            }
          ],
          "response": {
            "responseId": "resp-c002",
            "value": ["Pensions", "Investment"],
            "displayValue": "Pensions advice, Investment advice",
            "selectedOptionIds": ["opt-pension", "opt-investment"],
            "answeredDate": "2026-02-15T11:32:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:32:00Z"
          }
        },
        {
          "id": "sq-comp-003",
          "questionText": "Have you made any complaints to financial services providers or the Financial Ombudsman in the past 6 years?",
          "helpText": "FCA requires us to understand your experience with financial services",
          "questionType": "YesNo",
          "category": "Compliance",
          "subcategory": "Complaints",
          "required": true,
          "displayOrder": 3,
          "response": {
            "responseId": "resp-c003",
            "value": "No",
            "displayValue": "No",
            "answeredDate": "2026-02-15T11:35:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:35:00Z"
          }
        },
        {
          "id": "sq-comp-004",
          "questionText": "Are you or any family members employed in the financial services industry?",
          "helpText": "This may affect certain regulatory requirements",
          "questionType": "YesNo",
          "category": "Compliance",
          "subcategory": "IndustryConnection",
          "required": true,
          "displayOrder": 4,
          "response": {
            "responseId": "resp-c004",
            "value": "No",
            "displayValue": "No",
            "answeredDate": "2026-02-15T11:37:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:37:00Z"
          }
        },
        {
          "id": "sq-comp-005",
          "questionText": "Do you hold or have you held a senior position in any organization?",
          "helpText": "E.g., director, senior manager, public official (PEP status)",
          "questionType": "YesNo",
          "category": "Compliance",
          "subcategory": "PEPStatus",
          "required": true,
          "displayOrder": 5,
          "response": {
            "responseId": "resp-c005",
            "value": "No",
            "displayValue": "No",
            "answeredDate": "2026-02-15T11:40:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:40:00Z"
          },
          "regulatoryNote": "Required for AML compliance (Money Laundering Regulations 2017)"
        },
        {
          "id": "sq-comp-006",
          "questionText": "Have you read and understood the Key Information Documents (KIDs) for the products we discussed?",
          "helpText": "PRIIPs regulations require confirmation that you received and understood KIDs",
          "questionType": "YesNo",
          "category": "Compliance",
          "subcategory": "Disclosures",
          "required": true,
          "displayOrder": 6,
          "response": {
            "responseId": "resp-c006",
            "value": "Yes",
            "displayValue": "Yes",
            "answeredDate": "2026-02-15T11:45:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:45:00Z"
          },
          "regulatoryNote": "PRIIPs Regulation Article 13 - Understanding KIDs"
        },
        {
          "id": "sq-comp-007",
          "questionText": "Do you understand that investment values can go down as well as up?",
          "helpText": "Acknowledgment of investment risk",
          "questionType": "YesNo",
          "category": "Compliance",
          "subcategory": "RiskWarnings",
          "required": true,
          "displayOrder": 7,
          "response": {
            "responseId": "resp-c007",
            "value": "Yes",
            "displayValue": "Yes",
            "answeredDate": "2026-02-15T11:47:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:47:00Z"
          },
          "regulatoryNote": "FCA COBS 4.2 - Risk Warnings"
        },
        {
          "id": "sq-comp-008",
          "questionText": "Do you understand that past performance is not a reliable indicator of future results?",
          "helpText": "Acknowledgment of performance risk",
          "questionType": "YesNo",
          "category": "Compliance",
          "subcategory": "RiskWarnings",
          "required": true,
          "displayOrder": 8,
          "response": {
            "responseId": "resp-c008",
            "value": "Yes",
            "displayValue": "Yes",
            "answeredDate": "2026-02-15T11:48:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:48:00Z"
          },
          "regulatoryNote": "FCA COBS 4.2 - Risk Warnings"
        },
        {
          "id": "sq-comp-009",
          "questionText": "Have you received and read our Terms of Business?",
          "helpText": "Terms of Business explain how we work and our fees",
          "questionType": "YesNo",
          "category": "Compliance",
          "subcategory": "Disclosures",
          "required": true,
          "displayOrder": 9,
          "response": null,
          "regulatoryNote": "FCA COBS 2.3 - Client Agreements"
        },
        {
          "id": "sq-comp-010",
          "questionText": "Do you understand our charging structure and fees?",
          "helpText": "Confirmation that fees have been explained and understood",
          "questionType": "YesNo",
          "category": "Compliance",
          "subcategory": "Disclosures",
          "required": true,
          "displayOrder": 10,
          "response": null,
          "regulatoryNote": "FCA COBS 6.1A - Disclosure of Costs and Charges"
        }
      ]
    },
    {
      "category": "Custom",
      "categoryDisplay": "Firm-Specific Questions",
      "description": "Custom questions specific to this advisory firm",
      "questionCount": 8,
      "answeredCount": 2,
      "completionPercentage": 25.0,
      "required": false,
      "questions": [
        {
          "id": "sq-custom-001",
          "questionText": "How did you hear about our firm?",
          "helpText": "Help us understand how clients find us",
          "questionType": "SingleChoice",
          "category": "Custom",
          "subcategory": "Marketing",
          "required": false,
          "displayOrder": 1,
          "answerOptions": [
            {
              "id": "opt-referral",
              "optionText": "Client referral",
              "value": "ClientReferral"
            },
            {
              "id": "opt-web",
              "optionText": "Website/Online search",
              "value": "OnlineSearch"
            },
            {
              "id": "opt-social",
              "optionText": "Social media",
              "value": "SocialMedia"
            },
            {
              "id": "opt-event",
              "optionText": "Event/Seminar",
              "value": "Event"
            },
            {
              "id": "opt-other",
              "optionText": "Other",
              "value": "Other"
            }
          ],
          "response": {
            "responseId": "resp-cu001",
            "value": "ClientReferral",
            "displayValue": "Client referral",
            "selectedOptionId": "opt-referral",
            "answeredDate": "2026-02-15T11:50:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:50:00Z"
          }
        },
        {
          "id": "sq-custom-002",
          "questionText": "What are your main reasons for seeking financial advice?",
          "helpText": "Select all that apply",
          "questionType": "MultipleChoice",
          "category": "Custom",
          "subcategory": "ObjectiveSetting",
          "required": false,
          "displayOrder": 2,
          "answerOptions": [
            {
              "id": "opt-retirement",
              "optionText": "Retirement planning",
              "value": "Retirement"
            },
            {
              "id": "opt-growth",
              "optionText": "Growing wealth",
              "value": "WealthGrowth"
            },
            {
              "id": "opt-protection",
              "optionText": "Protecting family",
              "value": "FamilyProtection"
            },
            {
              "id": "opt-tax",
              "optionText": "Tax planning",
              "value": "TaxPlanning"
            },
            {
              "id": "opt-estate",
              "optionText": "Estate planning",
              "value": "EstatePlanning"
            },
            {
              "id": "opt-education",
              "optionText": "Education funding",
              "value": "Education"
            }
          ],
          "response": {
            "responseId": "resp-cu002",
            "value": ["Retirement", "WealthGrowth"],
            "displayValue": "Retirement planning, Growing wealth",
            "selectedOptionIds": ["opt-retirement", "opt-growth"],
            "answeredDate": "2026-02-15T11:52:00Z",
            "answeredBy": "Client",
            "lastModifiedDate": "2026-02-15T11:52:00Z"
          }
        }
      ]
    }
  ],
  "completionSummary": {
    "overallStatus": "Partial",
    "totalQuestions": 45,
    "requiredQuestions": 37,
    "answeredQuestions": 32,
    "answeredRequiredQuestions": 27,
    "missingRequiredQuestions": 10,
    "optionalQuestions": 8,
    "completionPercentage": 71.1,
    "requiredCompletionPercentage": 73.0,
    "estimatedTimeToComplete": 15
  },
  "nextSteps": [
    "Complete remaining 10 required questions in Compliance category",
    "Review Risk category responses with adviser",
    "Ensure all mandatory risk warnings acknowledged"
  ],
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456/supplementary-questions" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "responses": { "href": "/api/v1/factfinds/factfind-456/supplementary-questions/responses" },
    "completion-status": { "href": "/api/v1/factfinds/factfind-456/supplementary-questions/completion-status" },
    "submit-response": { "href": "/api/v1/factfinds/factfind-456/supplementary-questions/responses", "method": "POST" },
    "bulk-response": { "href": "/api/v1/factfinds/factfind-456/supplementary-questions/bulk-response", "method": "POST" }
  }
}
```

**Question Types:**
- `YesNo` - Boolean yes/no question
- `SingleChoice` - Select one option from list
- `MultipleChoice` - Select multiple options from list
- `Number` - Numeric input
- `Currency` - Monetary amount
- `Percentage` - Percentage value (0-100)
- `Date` - Date picker
- `Text` - Short text input
- `TextArea` - Long text input
- `Slider` - Continuous scale

**Question Categories:**
- `Risk` - Risk assessment and capacity questions
- `General` - General financial planning questions
- `Compliance` - Regulatory and compliance questions
- `Custom` - Firm-specific custom questions

**Completion Status:**
- `Unanswered` - No questions answered
- `Partial` - Some questions answered
- `Complete` - All required questions answered

**Validation Rules:**
- `factfindId` must be valid
- Category filter must match valid categories
- Response data must match question type validation rules
- Required questions must be answered before completion

**HTTP Status Codes:**
- `200 OK` - Questions retrieved successfully
- `404 Not Found` - Fact find not found
- `403 Forbidden` - Insufficient permissions

---

##### 10.6.2.2 Submit Supplementary Question Responses

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/supplementary-questions/responses`

**Description:** Submit response to a supplementary question.

**Request Body:**

```json
{
  "questionId": "sq-risk-013",
  "questionNumber": 13,
  "value": "No",
  "answerType": "YesNo",
  "answeredBy": "Client",
  "answeredDate": "2026-02-17T14:30:00Z",
  "notes": "Client confirms no non-mortgage debt"
}
```

**Response:**

```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/factfind-456/supplementary-questions/responses/resp-013
```

```json
{
  "responseId": "resp-013",
  "factfindId": "factfind-456",
  "questionId": "sq-risk-013",
  "questionText": "Are you currently in debt (excluding mortgage)?",
  "questionCategory": "Risk",
  "questionSubcategory": "Debt",
  "value": "No",
  "displayValue": "No",
  "answerType": "YesNo",
  "answeredBy": "Client",
  "answeredDate": "2026-02-17T14:30:00Z",
  "lastModifiedDate": "2026-02-17T14:30:00Z",
  "notes": "Client confirms no non-mortgage debt",
  "impactOnRiskAssessment": {
    "affectsCapacityForLoss": true,
    "reasoning": "Absence of debt increases capacity for investment risk"
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456/supplementary-questions/responses/resp-013" },
    "question": { "href": "/api/v1/factfinds/factfind-456/supplementary-questions?questionId=sq-risk-013" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "update": { "href": "/api/v1/factfinds/factfind-456/supplementary-questions/responses/resp-013", "method": "PUT" },
    "delete": { "href": "/api/v1/factfinds/factfind-456/supplementary-questions/responses/resp-013", "method": "DELETE" }
  }
}
```

**Validation Rules:**
- `questionId` must be valid for the fact find
- `value` must match question type validation rules
- `answerType` must match question type
- Required questions must have non-empty values
- Conditional questions must only be answered if conditions met

**HTTP Status Codes:**
- `201 Created` - Response created successfully
- `400 Bad Request` - Invalid request data
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Question or fact find not found
- `422 Unprocessable Entity` - Validation failed

---

##### 10.6.2.3 Get Completion Status

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/supplementary-questions/completion-status`

**Description:** Get completion status showing which question categories are complete and which required questions remain unanswered.

**Response:**

```json
{
  "factfindId": "factfind-456",
  "clientId": "client-123",
  "overallStatus": "Partial",
  "overallCompletionPercentage": 71.1,
  "requiredCompletionPercentage": 73.0,
  "lastUpdated": "2026-02-17T14:30:00Z",
  "categoryStatus": [
    {
      "category": "Risk",
      "status": "Partial",
      "totalQuestions": 15,
      "requiredQuestions": 13,
      "answeredQuestions": 12,
      "answeredRequiredQuestions": 11,
      "missingRequiredQuestions": 2,
      "completionPercentage": 80.0,
      "requiredCompletionPercentage": 84.6,
      "missingRequired": [
        {
          "questionId": "sq-risk-013",
          "questionNumber": 13,
          "questionText": "Are you currently in debt (excluding mortgage)?"
        },
        {
          "questionId": "sq-risk-014",
          "questionNumber": 14,
          "questionText": "What is your total non-mortgage debt?",
          "conditional": true,
          "showIfCondition": "sq-risk-013 = Yes"
        }
      ]
    },
    {
      "category": "General",
      "status": "Partial",
      "totalQuestions": 12,
      "requiredQuestions": 10,
      "answeredQuestions": 10,
      "answeredRequiredQuestions": 8,
      "missingRequiredQuestions": 2,
      "completionPercentage": 83.3,
      "requiredCompletionPercentage": 80.0,
      "missingRequired": [
        {
          "questionId": "sq-gen-011",
          "questionNumber": 11,
          "questionText": "Do you require any accessibility support or reasonable adjustments?"
        },
        {
          "questionId": "sq-gen-012",
          "questionNumber": 12,
          "questionText": "Is there anything else we should know to provide you with the best possible advice?"
        }
      ]
    },
    {
      "category": "Compliance",
      "status": "Partial",
      "totalQuestions": 10,
      "requiredQuestions": 10,
      "answeredQuestions": 8,
      "answeredRequiredQuestions": 8,
      "missingRequiredQuestions": 2,
      "completionPercentage": 80.0,
      "requiredCompletionPercentage": 80.0,
      "missingRequired": [
        {
          "questionId": "sq-comp-009",
          "questionNumber": 9,
          "questionText": "Have you received and read our Terms of Business?"
        },
        {
          "questionId": "sq-comp-010",
          "questionNumber": 10,
          "questionText": "Do you understand our charging structure and fees?"
        }
      ]
    },
    {
      "category": "Custom",
      "status": "Partial",
      "totalQuestions": 8,
      "requiredQuestions": 4,
      "answeredQuestions": 2,
      "answeredRequiredQuestions": 2,
      "missingRequiredQuestions": 2,
      "completionPercentage": 25.0,
      "requiredCompletionPercentage": 50.0,
      "missingRequired": []
    }
  ],
  "readyForRiskAssessment": false,
  "readyForSuitabilityReport": false,
  "blockingIssues": [
    {
      "severity": "High",
      "issue": "MissingComplianceQuestions",
      "description": "2 required compliance questions unanswered - cannot proceed to suitability report",
      "affectedQuestions": ["sq-comp-009", "sq-comp-010"]
    },
    {
      "severity": "Medium",
      "issue": "IncompleteRiskQuestions",
      "description": "2 required risk questions unanswered - may affect risk profile accuracy",
      "affectedQuestions": ["sq-risk-013", "sq-risk-014"]
    }
  ],
  "estimatedTimeToComplete": 10,
  "nextRecommendedAction": "Complete remaining compliance questions (sq-comp-009, sq-comp-010) to unblock suitability report",
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456/supplementary-questions/completion-status" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "questions": { "href": "/api/v1/factfinds/factfind-456/supplementary-questions" },
    "responses": { "href": "/api/v1/factfinds/factfind-456/supplementary-questions/responses" }
  }
}
```

**Completion Status Values:**
- `Complete` - All required questions answered
- `Partial` - Some required questions unanswered
- `Unanswered` - No questions answered

**Blocking Issue Severity:**
- `High` - Prevents progression to next stage
- `Medium` - May affect quality/accuracy
- `Low` - Optional enhancements

**Validation Rules:**
- `factfindId` must be valid

**HTTP Status Codes:**
- `200 OK` - Status retrieved successfully
- `404 Not Found` - Fact find not found
- `403 Forbidden` - Insufficient permissions

---
