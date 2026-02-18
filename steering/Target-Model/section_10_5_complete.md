### 10.5 Risk Assessment History API

**Purpose:** Track risk profile changes over time for audit trail and "Risk Replay" functionality.

**Scope:**
- Historical risk profile snapshots with full audit trail
- Risk profile version comparison and change analysis
- Risk Replay mechanism for FCA compliance (demonstrate suitability over time)
- Risk rating evolution tracking and trend analysis
- Questionnaire response history with timestamps
- Significant change documentation and justification
- Adviser override tracking and rationale
- Risk profile review scheduling and reminders

**Aggregate Root:** FactFind (risk assessment history is nested within)

**Regulatory Compliance:**
- FCA COBS 9.2 (Ongoing Suitability Assessment)
- MiFID II Article 25 (Regular Suitability Reviews)
- ESMA Guidelines (Suitability Records)
- FCA PROD 3.4 (Target Market Compatibility - Ongoing)
- SM&CR (Senior Managers Regime - Audit Trail Requirements)
- Consumer Duty (Ongoing Monitoring of Customer Outcomes)

**Risk Replay Concept:**

Risk Replay is a regulatory compliance mechanism that allows advisers to:
1. Demonstrate how risk assessment has evolved over time
2. Show justification for investment recommendations at specific points in time
3. Evidence ongoing suitability reviews
4. Track changes in client circumstances affecting risk tolerance
5. Provide audit trail for FCA inspections

#### 10.5.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/risk-profiles/history` | Get risk assessment history | `risk:read` |
| GET | `/api/v1/factfinds/{factfindId}/risk-profiles/compare` | Compare two risk assessments (Risk Replay) | `risk:read` |
| GET | `/api/v1/factfinds/{factfindId}/risk-profiles/evolution` | Get risk profile evolution over time | `risk:read` |
| POST | `/api/v1/factfinds/{factfindId}/risk-profiles/snapshot` | Create manual risk profile snapshot | `risk:write` |
| GET | `/api/v1/factfinds/{factfindId}/risk-profiles/{id}` | Get historical risk profile | `risk:read` |
| GET | `/api/v1/factfinds/{factfindId}/risk-profiles/{id}/questionnaire-responses` | Get questionnaire responses for profile | `risk:read` |
| POST | `/api/v1/factfinds/{factfindId}/risk-profiles/{id}/review-notes` | Add review notes to profile | `risk:write` |
| GET | `/api/v1/factfinds/{factfindId}/risk-profiles/timeline` | Get visual timeline of risk changes | `risk:read` |
| GET | `/api/v1/factfinds/{factfindId}/risk-profiles/audit-trail` | Get complete audit trail | `risk:read` |

#### 10.5.2 Key Endpoints

##### 10.5.2.1 Get Risk Assessment History

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/risk-profiles/history`

**Description:** List all historical risk profiles for a fact find with summary information including risk rating changes and significant events.

**Query Parameters:**
- `clientId` - Filter by specific client (for joint fact finds)
- `fromDate` - Filter profiles from this date (ISO 8601)
- `toDate` - Filter profiles to this date (ISO 8601)
- `includeDeleted` - Include deleted/superseded profiles (default: false)
- `sortOrder` - Sort order: asc (oldest first), desc (newest first, default)

**Response:**

```json
{
  "factfindId": "factfind-456",
  "clientId": "client-123",
  "clientName": "John Smith",
  "totalAssessments": 5,
  "dateRange": {
    "firstAssessment": "2022-03-15",
    "lastAssessment": "2026-02-17"
  },
  "currentRiskProfile": {
    "id": "rp-789",
    "riskRating": "MediumRisk",
    "assessmentDate": "2026-02-17"
  },
  "riskRatingChanges": 2,
  "significantChanges": 1,
  "history": [
    {
      "id": "rp-789",
      "assessmentNumber": 5,
      "assessmentDate": "2026-02-17T14:30:00Z",
      "assessmentType": "RegularReview",
      "questionnaireVersion": "3.0",
      "questionnaireName": "Standard Attitude to Risk Questionnaire 2024",
      "riskRating": {
        "code": "MediumRisk",
        "display": "Medium Risk",
        "normalizedScore": 3.56
      },
      "riskCapacityScore": 3.8,
      "riskToleranceScore": 3.2,
      "investmentExperienceScore": 3.0,
      "completedBy": "Client",
      "completionMethod": "OnlinePortal",
      "adviserPresent": true,
      "adviser": {
        "id": "adv-789",
        "name": "Sarah Johnson"
      },
      "changeFromPrevious": {
        "riskRatingChanged": false,
        "previousRiskRating": "MediumRisk",
        "scoreChange": 0.06,
        "scoreChangePercentage": 1.7,
        "significantChange": false
      },
      "adviserOverride": null,
      "reviewScheduled": "2027-02-17",
      "status": "Current",
      "_links": {
        "self": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-789" },
        "questionnaire-responses": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-789/questionnaire-responses" },
        "compare-to-previous": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/compare?from=rp-654&to=rp-789" }
      }
    },
    {
      "id": "rp-654",
      "assessmentNumber": 4,
      "assessmentDate": "2025-02-10T10:15:00Z",
      "assessmentType": "RegularReview",
      "questionnaireVersion": "3.0",
      "questionnaireName": "Standard Attitude to Risk Questionnaire 2024",
      "riskRating": {
        "code": "MediumRisk",
        "display": "Medium Risk",
        "normalizedScore": 3.50
      },
      "riskCapacityScore": 3.7,
      "riskToleranceScore": 3.2,
      "investmentExperienceScore": 3.1,
      "completedBy": "Client",
      "completionMethod": "InMeeting",
      "adviserPresent": true,
      "adviser": {
        "id": "adv-789",
        "name": "Sarah Johnson"
      },
      "changeFromPrevious": {
        "riskRatingChanged": false,
        "previousRiskRating": "MediumRisk",
        "scoreChange": 0.0,
        "scoreChangePercentage": 0.0,
        "significantChange": false
      },
      "adviserOverride": null,
      "reviewScheduled": "2026-02-10",
      "status": "Superseded",
      "_links": {
        "self": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-654" },
        "questionnaire-responses": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-654/questionnaire-responses" },
        "compare-to-next": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/compare?from=rp-654&to=rp-789" },
        "compare-to-previous": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/compare?from=rp-523&to=rp-654" }
      }
    },
    {
      "id": "rp-523",
      "assessmentNumber": 3,
      "assessmentDate": "2024-03-20T11:30:00Z",
      "assessmentType": "SignificantChangeTriggered",
      "questionnaireVersion": "2.1",
      "questionnaireName": "Standard Attitude to Risk Questionnaire 2023",
      "riskRating": {
        "code": "MediumRisk",
        "display": "Medium Risk",
        "normalizedScore": 3.50
      },
      "riskCapacityScore": 3.7,
      "riskToleranceScore": 3.3,
      "investmentExperienceScore": 3.0,
      "completedBy": "Adviser",
      "completionMethod": "InMeeting",
      "adviserPresent": true,
      "adviser": {
        "id": "adv-789",
        "name": "Sarah Johnson"
      },
      "changeFromPrevious": {
        "riskRatingChanged": true,
        "previousRiskRating": "LowRisk",
        "scoreChange": 0.80,
        "scoreChangePercentage": 29.6,
        "significantChange": true,
        "changeReason": "Client circumstances changed - received inheritance increasing financial capacity"
      },
      "adviserOverride": null,
      "reviewScheduled": "2025-03-20",
      "status": "Superseded",
      "significantChangeDetails": {
        "triggerEvent": "InheritanceReceived",
        "triggerDate": "2024-02-28",
        "changeDescription": "Client received £250,000 inheritance significantly improving financial capacity and reducing need for capital preservation",
        "adviserNotes": "Discussed increased capacity for risk. Client comfortable moving to medium risk profile given improved financial position and longer time horizon for inherited funds.",
        "documentedInSuitabilityReport": true,
        "suitabilityReportReference": "SR-2024-03-523"
      },
      "_links": {
        "self": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-523" },
        "questionnaire-responses": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-523/questionnaire-responses" },
        "compare-to-next": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/compare?from=rp-523&to=rp-654" },
        "compare-to-previous": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/compare?from=rp-412&to=rp-523" },
        "suitability-report": { "href": "/api/v1/suitability-reports/SR-2024-03-523" }
      }
    },
    {
      "id": "rp-412",
      "assessmentNumber": 2,
      "assessmentDate": "2023-03-10T14:00:00Z",
      "assessmentType": "RegularReview",
      "questionnaireVersion": "2.1",
      "questionnaireName": "Standard Attitude to Risk Questionnaire 2023",
      "riskRating": {
        "code": "LowRisk",
        "display": "Low Risk",
        "normalizedScore": 2.70
      },
      "riskCapacityScore": 2.8,
      "riskToleranceScore": 2.6,
      "investmentExperienceScore": 2.5,
      "completedBy": "Client",
      "completionMethod": "InMeeting",
      "adviserPresent": true,
      "adviser": {
        "id": "adv-789",
        "name": "Sarah Johnson"
      },
      "changeFromPrevious": {
        "riskRatingChanged": false,
        "previousRiskRating": "LowRisk",
        "scoreChange": 0.10,
        "scoreChangePercentage": 3.8,
        "significantChange": false
      },
      "adviserOverride": null,
      "reviewScheduled": "2024-03-10",
      "status": "Superseded",
      "_links": {
        "self": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-412" },
        "questionnaire-responses": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-412/questionnaire-responses" },
        "compare-to-next": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/compare?from=rp-412&to=rp-523" },
        "compare-to-previous": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/compare?from=rp-301&to=rp-412" }
      }
    },
    {
      "id": "rp-301",
      "assessmentNumber": 1,
      "assessmentDate": "2022-03-15T09:30:00Z",
      "assessmentType": "InitialAssessment",
      "questionnaireVersion": "2.0",
      "questionnaireName": "Standard Attitude to Risk Questionnaire 2022",
      "riskRating": {
        "code": "LowRisk",
        "display": "Low Risk",
        "normalizedScore": 2.60
      },
      "riskCapacityScore": 2.5,
      "riskToleranceScore": 2.7,
      "investmentExperienceScore": 2.2,
      "completedBy": "Client",
      "completionMethod": "PaperBased",
      "adviserPresent": true,
      "adviser": {
        "id": "adv-789",
        "name": "Sarah Johnson"
      },
      "changeFromPrevious": {
        "riskRatingChanged": false,
        "previousRiskRating": null,
        "scoreChange": null,
        "scoreChangePercentage": null,
        "significantChange": false
      },
      "adviserOverride": null,
      "reviewScheduled": "2023-03-15",
      "status": "Superseded",
      "_links": {
        "self": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-301" },
        "questionnaire-responses": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-301/questionnaire-responses" },
        "compare-to-next": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/compare?from=rp-301&to=rp-412" }
      }
    }
  ],
  "riskTrend": {
    "direction": "Increasing",
    "changeOverPeriod": 0.96,
    "averageScore": 3.17,
    "volatility": "Low"
  },
  "nextScheduledReview": "2027-02-17",
  "reviewOverdue": false,
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/history" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "current-risk-profile": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-789" },
    "evolution": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/evolution" },
    "timeline": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/timeline" },
    "audit-trail": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/audit-trail" }
  }
}
```

**Assessment Types:**
- `InitialAssessment` - First risk assessment for client
- `RegularReview` - Scheduled periodic review
- `SignificantChangeTriggered` - Triggered by change in circumstances
- `ProductSuitabilityCheck` - Triggered by new product recommendation
- `RegulatoryReview` - Triggered by regulatory requirement
- `ClientRequested` - Requested by client
- `AdviserInitiated` - Initiated by adviser concern
- `ComplaintInvestigation` - Part of complaint investigation

**Risk Profile Status:**
- `Current` - Current active risk profile
- `Superseded` - Replaced by newer assessment
- `Deleted` - Deleted (kept for audit)
- `UnderReview` - Currently being reviewed/challenged

**Validation Rules:**
- `fromDate` must be before `toDate`
- Dates must be valid ISO 8601 format
- Client must belong to fact find

**HTTP Status Codes:**
- `200 OK` - History retrieved successfully
- `404 Not Found` - Fact find not found
- `403 Forbidden` - Insufficient permissions

---

##### 10.5.2.2 Compare Risk Assessments (Risk Replay)

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/risk-profiles/compare`

**Description:** Compare two risk assessments to show changes in responses, risk rating, and suitability. This is the core "Risk Replay" functionality for demonstrating ongoing suitability.

**Query Parameters:**
- `from` - Earlier risk profile ID (required)
- `to` - Later risk profile ID (required)
- `includeQuestionnaireChanges` - Include questionnaire version changes (default: true)
- `highlightSignificantChanges` - Highlight significant changes only (default: false)

**Response:**

```json
{
  "factfindId": "factfind-456",
  "clientId": "client-123",
  "clientName": "John Smith",
  "comparisonDate": "2026-02-17T15:00:00Z",
  "fromProfile": {
    "id": "rp-412",
    "assessmentDate": "2023-03-10T14:00:00Z",
    "assessmentType": "RegularReview",
    "questionnaireVersion": "2.1",
    "questionnaireName": "Standard Attitude to Risk Questionnaire 2023",
    "riskRating": {
      "code": "LowRisk",
      "display": "Low Risk",
      "normalizedScore": 2.70
    },
    "riskCapacityScore": 2.8,
    "riskToleranceScore": 2.6,
    "investmentExperienceScore": 2.5,
    "adviser": {
      "id": "adv-789",
      "name": "Sarah Johnson"
    }
  },
  "toProfile": {
    "id": "rp-523",
    "assessmentDate": "2024-03-20T11:30:00Z",
    "assessmentType": "SignificantChangeTriggered",
    "questionnaireVersion": "2.1",
    "questionnaireName": "Standard Attitude to Risk Questionnaire 2023",
    "riskRating": {
      "code": "MediumRisk",
      "display": "Medium Risk",
      "normalizedScore": 3.50
    },
    "riskCapacityScore": 3.7,
    "riskToleranceScore": 3.3,
    "investmentExperienceScore": 3.0,
    "adviser": {
      "id": "adv-789",
      "name": "Sarah Johnson"
    }
  },
  "timeBetweenAssessments": {
    "days": 375,
    "months": 12.3,
    "years": 1.0
  },
  "riskRatingChange": {
    "changed": true,
    "direction": "Increased",
    "fromRating": "LowRisk",
    "toRating": "MediumRisk",
    "scoreChange": 0.80,
    "scoreChangePercentage": 29.6,
    "significantChange": true,
    "changeClassification": "MajorIncrease"
  },
  "componentScoreChanges": {
    "riskCapacity": {
      "fromScore": 2.8,
      "toScore": 3.7,
      "change": 0.9,
      "changePercentage": 32.1,
      "changed": true,
      "direction": "Increased"
    },
    "riskTolerance": {
      "fromScore": 2.6,
      "toScore": 3.3,
      "change": 0.7,
      "changePercentage": 26.9,
      "changed": true,
      "direction": "Increased"
    },
    "investmentExperience": {
      "fromScore": 2.5,
      "toScore": 3.0,
      "change": 0.5,
      "changePercentage": 20.0,
      "changed": true,
      "direction": "Increased"
    }
  },
  "assetAllocationChange": {
    "from": {
      "equities": 20,
      "bonds": 50,
      "cash": 25,
      "alternatives": 5
    },
    "to": {
      "equities": 45,
      "bonds": 30,
      "cash": 15,
      "alternatives": 10
    },
    "changes": {
      "equities": { "change": 25, "direction": "Increased" },
      "bonds": { "change": -20, "direction": "Decreased" },
      "cash": { "change": -10, "direction": "Decreased" },
      "alternatives": { "change": 5, "direction": "Increased" }
    }
  },
  "questionnaireComparison": {
    "sameQuestionnaire": true,
    "sameVersion": true,
    "questionnaireName": "Standard Attitude to Risk Questionnaire 2023",
    "fromVersion": "2.1",
    "toVersion": "2.1",
    "comparableResponses": true
  },
  "responseChanges": [
    {
      "questionId": "q1",
      "questionNumber": 1,
      "questionText": "What is your investment time horizon?",
      "category": "RiskCapacity",
      "changed": false,
      "fromResponse": {
        "selectedOptionText": "5-10 years",
        "score": 4
      },
      "toResponse": {
        "selectedOptionText": "5-10 years",
        "score": 4
      },
      "scoreChange": 0,
      "significant": false
    },
    {
      "questionId": "q2",
      "questionNumber": 2,
      "questionText": "If the value of your investment fell by 20% in the first year, what would you do?",
      "category": "RiskTolerance",
      "changed": true,
      "fromResponse": {
        "selectedOptionText": "Reduce exposure by selling 50% of investments",
        "score": 2
      },
      "toResponse": {
        "selectedOptionText": "Hold current positions and wait for recovery",
        "score": 3
      },
      "scoreChange": 1,
      "scoreChangePercentage": 50.0,
      "significant": true,
      "changeReason": "Increased confidence in market recovery following improved financial position"
    },
    {
      "questionId": "q5",
      "questionNumber": 5,
      "questionText": "What percentage of your total wealth is represented by this investment?",
      "category": "RiskCapacity",
      "changed": true,
      "fromResponse": {
        "selectedOptionText": "50-75%",
        "score": 2
      },
      "toResponse": {
        "selectedOptionText": "10-25%",
        "score": 4
      },
      "scoreChange": 2,
      "scoreChangePercentage": 100.0,
      "significant": true,
      "changeReason": "Inheritance received significantly increased total wealth, reducing concentration risk"
    },
    {
      "questionId": "q6",
      "questionNumber": 6,
      "questionText": "Do you have an emergency fund covering at least 3-6 months of expenses?",
      "category": "RiskCapacity",
      "changed": true,
      "fromResponse": {
        "selectedOptionText": "Less than 3 months",
        "score": 2
      },
      "toResponse": {
        "selectedOptionText": "More than 6 months",
        "score": 5
      },
      "scoreChange": 3,
      "scoreChangePercentage": 150.0,
      "significant": true,
      "changeReason": "Emergency fund significantly improved following inheritance"
    },
    {
      "questionId": "q7",
      "questionNumber": 7,
      "questionText": "Which statement best describes your investment objectives?",
      "category": "RiskTolerance",
      "changed": true,
      "fromResponse": {
        "selectedOptionText": "Generate income with minimal capital growth",
        "score": 2
      },
      "toResponse": {
        "selectedOptionText": "Balance income and growth with moderate risk",
        "score": 3
      },
      "scoreChange": 1,
      "scoreChangePercentage": 50.0,
      "significant": true,
      "changeReason": "Shift to balanced approach given improved capacity and longer time horizon for inherited funds"
    },
    {
      "questionId": "q10",
      "questionNumber": 10,
      "questionText": "Which of the following investment types have you held before?",
      "category": "InvestmentExperience",
      "changed": true,
      "fromResponse": {
        "selectedOptionTexts": ["Cash savings accounts only", "Fixed income bonds"],
        "score": 1.5
      },
      "toResponse": {
        "selectedOptionTexts": ["Fixed income bonds", "Investment funds (unit trusts, OEICs)", "Individual shares/stocks"],
        "score": 3.0
      },
      "scoreChange": 1.5,
      "scoreChangePercentage": 100.0,
      "significant": true,
      "changeReason": "Gained experience with investment funds and equities over past year"
    },
    {
      "questionId": "q12",
      "questionNumber": 12,
      "questionText": "Do you expect any major expenses in the next 5 years?",
      "category": "RiskCapacity",
      "changed": true,
      "fromResponse": {
        "selectedOptionText": "Yes, within 1-3 years",
        "score": 2
      },
      "toResponse": {
        "selectedOptionText": "No major expenses expected",
        "score": 5
      },
      "scoreChange": 3,
      "scoreChangePercentage": 150.0,
      "significant": true,
      "changeReason": "Major expense (home renovation) completed, no further large expenses planned"
    }
  ],
  "significantChangesSummary": {
    "totalQuestions": 12,
    "questionsChanged": 6,
    "significantChanges": 6,
    "questionsUnchanged": 6,
    "averageScoreChange": 0.67,
    "maxScoreChange": 3.0,
    "changeCategories": {
      "RiskCapacity": 4,
      "RiskTolerance": 2,
      "InvestmentExperience": 1
    }
  },
  "suitabilityImpact": {
    "previousRecommendations": {
      "productTypes": ["CautionsManagedFunds", "CorporateBonds", "BalancedIncomeISA"],
      "assetAllocation": "Conservative income-focused portfolio",
      "equityExposure": "Low (20%)"
    },
    "newRecommendations": {
      "productTypes": ["BalancedManagedFunds", "MultiAssetISA", "DiversifiedPortfolio"],
      "assetAllocation": "Balanced growth and income portfolio",
      "equityExposure": "Medium (45%)"
    },
    "existingPortfolioSuitability": {
      "stillSuitable": false,
      "actionRequired": "RebalanceRequired",
      "reason": "Current portfolio too conservative for updated risk profile. Recommend rebalancing to increase equity exposure from 20% to 45%."
    }
  },
  "changeJustification": {
    "primaryDrivers": [
      "Inheritance received (£250,000) significantly improved financial capacity",
      "Emergency fund increased from <3 months to >6 months coverage",
      "Investment as percentage of total wealth reduced from 50-75% to 10-25%",
      "Major planned expenses completed, no further large expenses expected"
    ],
    "adviserNotes": "Client circumstances have materially improved following inheritance. Capacity for loss significantly increased. Client also gained investment experience and confidence over the past year. Discussed portfolio rebalancing to align with updated risk profile. Client comfortable with increased equity exposure given improved financial position.",
    "documentationReference": "SR-2024-03-523",
    "clientAcknowledgment": {
      "acknowledged": true,
      "acknowledgedDate": "2024-03-20T11:45:00Z",
      "signedBy": "John Smith"
    }
  },
  "regulatoryCompliance": {
    "fcaCOBS9_2Compliance": true,
    "mifidII_Article25Compliance": true,
    "suitabilityReportProduced": true,
    "suitabilityReportReference": "SR-2024-03-523",
    "adviserSignOff": {
      "signedBy": {
        "id": "adv-789",
        "name": "Sarah Johnson",
        "fcaRegistrationNumber": "FCA12345"
      },
      "signedDate": "2024-03-20T12:00:00Z",
      "complianceNotes": "Risk profile change reviewed and approved. Change justified by material improvement in client circumstances. Suitability report documents full rationale. Portfolio rebalancing recommendations provided."
    }
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/compare?from=rp-412&to=rp-523" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "from-profile": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-412" },
    "to-profile": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-523" },
    "suitability-report": { "href": "/api/v1/suitability-reports/SR-2024-03-523" },
    "history": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/history" }
  }
}
```

**Change Classifications:**
- `NoChange` - Risk rating unchanged
- `MinorIncrease` - Score increase <0.5, same risk band
- `MinorDecrease` - Score decrease <0.5, same risk band
- `ModerateIncrease` - Score increase 0.5-1.0, may change risk band
- `ModerateDecrease` - Score decrease 0.5-1.0, may change risk band
- `MajorIncrease` - Score increase >1.0, changes risk band
- `MajorDecrease` - Score decrease >1.0, changes risk band

**Validation Rules:**
- `from` profile must be earlier than `to` profile
- Both profiles must belong to the same fact find
- Both profiles must exist and be accessible
- Profiles should ideally use the same questionnaire version for accurate comparison

**HTTP Status Codes:**
- `200 OK` - Comparison completed successfully
- `400 Bad Request` - Invalid comparison parameters
- `404 Not Found` - One or both profiles not found
- `403 Forbidden` - Insufficient permissions
- `422 Unprocessable Entity` - Profiles not comparable (different questionnaires, incompatible versions)

**Error Response Example:**

```json
{
  "type": "https://api.factfind.com/errors/incompatible-comparison",
  "title": "Risk Profiles Not Comparable",
  "status": 422,
  "detail": "Cannot compare risk profiles using different questionnaire versions",
  "instance": "/api/v1/factfinds/factfind-456/risk-profiles/compare",
  "fromProfile": {
    "id": "rp-301",
    "questionnaireVersion": "2.0",
    "questionnaireName": "Standard Attitude to Risk Questionnaire 2022"
  },
  "toProfile": {
    "id": "rp-789",
    "questionnaireVersion": "3.0",
    "questionnaireName": "Standard Attitude to Risk Questionnaire 2024"
  },
  "recommendation": "Use evolution endpoint for high-level trend analysis across different questionnaire versions"
}
```

---

##### 10.5.2.3 Get Risk Profile Evolution

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/risk-profiles/evolution`

**Description:** Get time-series data showing how risk profile has evolved over time. Provides chart-ready data for visualizing risk rating changes, score trends, and component breakdowns.

**Query Parameters:**
- `clientId` - Filter by specific client
- `fromDate` - Start date for evolution analysis
- `toDate` - End date for evolution analysis
- `granularity` - Data point frequency: daily, weekly, monthly, yearly (default: monthly)
- `includeProjections` - Include future projections (default: false)

**Response:**

```json
{
  "factfindId": "factfind-456",
  "clientId": "client-123",
  "clientName": "John Smith",
  "analysisDate": "2026-02-17",
  "dateRange": {
    "from": "2022-03-15",
    "to": "2026-02-17",
    "durationMonths": 47,
    "durationYears": 3.9
  },
  "totalAssessments": 5,
  "granularity": "monthly",
  "timeline": [
    {
      "date": "2022-03-15",
      "assessmentId": "rp-301",
      "assessmentType": "InitialAssessment",
      "riskRating": {
        "code": "LowRisk",
        "display": "Low Risk",
        "normalizedScore": 2.60
      },
      "riskCapacityScore": 2.5,
      "riskToleranceScore": 2.7,
      "investmentExperienceScore": 2.2,
      "dataPoint": true,
      "adviserNotes": "Initial risk assessment completed. Client has limited investment experience and modest capacity for loss."
    },
    {
      "date": "2023-03-10",
      "assessmentId": "rp-412",
      "assessmentType": "RegularReview",
      "riskRating": {
        "code": "LowRisk",
        "display": "Low Risk",
        "normalizedScore": 2.70
      },
      "riskCapacityScore": 2.8,
      "riskToleranceScore": 2.6,
      "investmentExperienceScore": 2.5,
      "changeFromPrevious": {
        "scoreChange": 0.10,
        "months": 12,
        "annualizedChange": 0.10
      },
      "dataPoint": true,
      "adviserNotes": "Annual review - minor improvement in capacity and experience. Risk rating unchanged."
    },
    {
      "date": "2024-03-20",
      "assessmentId": "rp-523",
      "assessmentType": "SignificantChangeTriggered",
      "riskRating": {
        "code": "MediumRisk",
        "display": "Medium Risk",
        "normalizedScore": 3.50
      },
      "riskCapacityScore": 3.7,
      "riskToleranceScore": 3.3,
      "investmentExperienceScore": 3.0,
      "changeFromPrevious": {
        "scoreChange": 0.80,
        "months": 12.3,
        "annualizedChange": 0.78
      },
      "significantChange": true,
      "changeDrivers": [
        "InheritanceReceived",
        "ImprovedFinancialPosition",
        "IncreasedEmergencyFund"
      ],
      "dataPoint": true,
      "adviserNotes": "Significant improvement following inheritance. Risk rating increased from Low to Medium. Portfolio rebalancing recommended."
    },
    {
      "date": "2025-02-10",
      "assessmentId": "rp-654",
      "assessmentType": "RegularReview",
      "riskRating": {
        "code": "MediumRisk",
        "display": "Medium Risk",
        "normalizedScore": 3.50
      },
      "riskCapacityScore": 3.7,
      "riskToleranceScore": 3.2,
      "investmentExperienceScore": 3.1,
      "changeFromPrevious": {
        "scoreChange": 0.0,
        "months": 10.7,
        "annualizedChange": 0.0
      },
      "dataPoint": true,
      "adviserNotes": "Annual review - risk profile stable. Portfolio performing well."
    },
    {
      "date": "2026-02-17",
      "assessmentId": "rp-789",
      "assessmentType": "RegularReview",
      "riskRating": {
        "code": "MediumRisk",
        "display": "Medium Risk",
        "normalizedScore": 3.56
      },
      "riskCapacityScore": 3.8,
      "riskToleranceScore": 3.2,
      "investmentExperienceScore": 3.0,
      "changeFromPrevious": {
        "scoreChange": 0.06,
        "months": 12.2,
        "annualizedChange": 0.06
      },
      "dataPoint": true,
      "adviserNotes": "Annual review - slight improvement in capacity. Risk profile stable at medium risk."
    }
  ],
  "trendAnalysis": {
    "overallTrend": "Increasing",
    "averageScore": 3.17,
    "medianScore": 3.50,
    "scoreRange": {
      "min": 2.60,
      "max": 3.56,
      "spread": 0.96
    },
    "volatility": "Low",
    "standardDeviation": 0.42,
    "riskRatingStability": "Stable",
    "riskRatingChanges": 1,
    "longestPeriodInSameRating": {
      "riskRating": "MediumRisk",
      "startDate": "2024-03-20",
      "endDate": "2026-02-17",
      "durationMonths": 23
    },
    "averageTimeBetweenAssessments": {
      "months": 11.75,
      "withinExpectedRange": true,
      "expectedRange": "12 months"
    }
  },
  "componentTrends": {
    "riskCapacity": {
      "trend": "Increasing",
      "firstScore": 2.5,
      "lastScore": 3.8,
      "totalChange": 1.3,
      "percentageChange": 52.0,
      "averageScore": 3.3,
      "volatility": "Moderate"
    },
    "riskTolerance": {
      "trend": "Stable",
      "firstScore": 2.7,
      "lastScore": 3.2,
      "totalChange": 0.5,
      "percentageChange": 18.5,
      "averageScore": 2.9,
      "volatility": "Low"
    },
    "investmentExperience": {
      "trend": "Increasing",
      "firstScore": 2.2,
      "lastScore": 3.0,
      "totalChange": 0.8,
      "percentageChange": 36.4,
      "averageScore": 2.7,
      "volatility": "Low"
    }
  },
  "riskRatingDistribution": {
    "VeryLowRisk": {
      "count": 0,
      "percentage": 0.0,
      "totalMonths": 0
    },
    "LowRisk": {
      "count": 2,
      "percentage": 40.0,
      "totalMonths": 24
    },
    "MediumRisk": {
      "count": 3,
      "percentage": 60.0,
      "totalMonths": 23
    },
    "HighRisk": {
      "count": 0,
      "percentage": 0.0,
      "totalMonths": 0
    },
    "VeryHighRisk": {
      "count": 0,
      "percentage": 0.0,
      "totalMonths": 0
    }
  },
  "keyMilestones": [
    {
      "date": "2022-03-15",
      "event": "Initial Assessment",
      "description": "First risk assessment completed - Low Risk rating established",
      "riskRating": "LowRisk"
    },
    {
      "date": "2024-03-20",
      "event": "Risk Rating Upgrade",
      "description": "Risk rating increased to Medium following inheritance",
      "riskRating": "MediumRisk",
      "changeDriver": "InheritanceReceived"
    }
  ],
  "nextReviewDate": "2027-02-17",
  "reviewFrequency": "Annual",
  "projections": null,
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/evolution" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "history": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/history" },
    "current-profile": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/rp-789" },
    "timeline": { "href": "/api/v1/factfinds/factfind-456/risk-profiles/timeline" }
  }
}
```

**Trend Analysis:**
- `Increasing` - Overall upward trend in risk score
- `Decreasing` - Overall downward trend in risk score
- `Stable` - No significant trend (changes < 10% over period)
- `Volatile` - Frequent significant changes (high standard deviation)

**Volatility Classifications:**
- `Low` - Standard deviation < 0.5
- `Moderate` - Standard deviation 0.5 - 1.0
- `High` - Standard deviation > 1.0

**Validation Rules:**
- `fromDate` must be before `toDate`
- Granularity must be valid value
- Date range cannot exceed 10 years for daily granularity
- Client must belong to fact find

**HTTP Status Codes:**
- `200 OK` - Evolution data retrieved successfully
- `400 Bad Request` - Invalid parameters
- `404 Not Found` - Fact find not found
- `403 Forbidden` - Insufficient permissions

---
