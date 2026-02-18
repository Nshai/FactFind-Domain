### 10.7 Enhanced Declaration Capture

**Purpose:** Comprehensive declaration and consent capture for regulatory compliance.

**Scope:**
- Client declarations (fact find accuracy, risk warnings, advice understanding, data protection)
- Adviser declarations (suitability assessment, compliance confirmation, best advice)
- Data protection consent (GDPR, data processing, retention, profiling)
- Marketing consent with channel preferences (email, phone, SMS, post)
- Regulatory disclosures and acknowledgments
- Electronic and wet signature capture with full audit trail
- Declaration versioning and change tracking
- Signature verification with IP address, device info, and timestamp tracking
- Consent withdrawal mechanism
- Privacy policy version tracking

**Aggregate Root:** FactFind (declarations are nested within)

**Regulatory Compliance:**
- GDPR Article 7 (Conditions for Consent)
- GDPR Article 13 (Information to be Provided)
- GDPR Article 17 (Right to Erasure)
- GDPR Article 21 (Right to Object)
- FCA COBS 2.3 (Client Agreements)
- FCA COBS 4.2 (Risk Warnings)
- FCA COBS 9.2 (Suitability Assessment)
- eIDAS Regulation (Electronic Signatures)
- Electronic Communications Act 2000
- Data Protection Act 2018

#### 10.7.1 Operations Summary

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/factfinds/{factfindId}/declarations/status` | Get declaration status | `factfind:read` |
| POST | `/api/v1/factfinds/{factfindId}/declarations/client-sign` | Sign client declaration | `factfind:write` |
| POST | `/api/v1/factfinds/{factfindId}/declarations/adviser-sign` | Sign adviser declaration | `factfind:write` |
| POST | `/api/v1/factfinds/{factfindId}/declarations/consent` | Record consent | `factfind:write` |
| PUT | `/api/v1/factfinds/{factfindId}/declarations/consent/{id}` | Update consent | `factfind:write` |
| DELETE | `/api/v1/factfinds/{factfindId}/declarations/consent/{id}` | Withdraw consent | `factfind:write` |
| GET | `/api/v1/factfinds/{factfindId}/declarations/signature-history` | Get signature history | `factfind:read` |
| GET | `/api/v1/factfinds/{factfindId}/declarations/consent-audit` | Get consent audit trail | `factfind:read` |
| GET | `/api/v1/factfinds/{factfindId}/declarations/{id}` | Get specific declaration | `factfind:read` |
| POST | `/api/v1/factfinds/{factfindId}/declarations/bulk-sign` | Sign multiple declarations | `factfind:write` |

#### 10.7.2 Key Endpoints

##### 10.7.2.1 Get Declaration Status

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/declarations/status`

**Description:** Get status of all declarations and consents for a fact find, showing which have been signed and which are outstanding.

**Response:**

```json
{
  "factfindId": "factfind-456",
  "clientId": "client-123",
  "clientName": "John Smith",
  "statusDate": "2026-02-17T15:00:00Z",
  "overallStatus": "Partial",
  "overallCompletionPercentage": 75.0,
  "clientDeclarations": {
    "status": "Complete",
    "totalRequired": 4,
    "signed": 4,
    "unsigned": 0,
    "declarations": [
      {
        "declarationType": "FactFindAccuracy",
        "declarationName": "Fact Find Accuracy Declaration",
        "required": true,
        "signed": true,
        "signedDate": "2026-02-15T16:30:00Z",
        "signedBy": "John Smith",
        "signatureMethod": "ElectronicSignature",
        "declarationVersion": "2024-v1",
        "expiryDate": null,
        "_links": {
          "declaration": { "href": "/api/v1/factfinds/factfind-456/declarations/decl-001" }
        }
      },
      {
        "declarationType": "RiskWarning",
        "declarationName": "Investment Risk Warning Acknowledgment",
        "required": true,
        "signed": true,
        "signedDate": "2026-02-15T16:32:00Z",
        "signedBy": "John Smith",
        "signatureMethod": "ElectronicSignature",
        "declarationVersion": "2024-v1",
        "expiryDate": null,
        "_links": {
          "declaration": { "href": "/api/v1/factfinds/factfind-456/declarations/decl-002" }
        }
      },
      {
        "declarationType": "AdviceUnderstanding",
        "declarationName": "Advice Process Understanding",
        "required": true,
        "signed": true,
        "signedDate": "2026-02-15T16:35:00Z",
        "signedBy": "John Smith",
        "signatureMethod": "ElectronicSignature",
        "declarationVersion": "2024-v1",
        "expiryDate": null,
        "_links": {
          "declaration": { "href": "/api/v1/factfinds/factfind-456/declarations/decl-003" }
        }
      },
      {
        "declarationType": "CostDisclosure",
        "declarationName": "Costs and Charges Understanding",
        "required": true,
        "signed": true,
        "signedDate": "2026-02-15T16:37:00Z",
        "signedBy": "John Smith",
        "signatureMethod": "ElectronicSignature",
        "declarationVersion": "2024-v1",
        "expiryDate": null,
        "_links": {
          "declaration": { "href": "/api/v1/factfinds/factfind-456/declarations/decl-004" }
        }
      }
    ]
  },
  "adviserDeclarations": {
    "status": "Pending",
    "totalRequired": 3,
    "signed": 2,
    "unsigned": 1,
    "declarations": [
      {
        "declarationType": "SuitabilityAssessment",
        "declarationName": "Suitability Assessment Confirmation",
        "required": true,
        "signed": true,
        "signedDate": "2026-02-16T10:00:00Z",
        "signedBy": "Sarah Johnson",
        "signatureMethod": "ElectronicSignature",
        "declarationVersion": "2024-v1",
        "expiryDate": null,
        "_links": {
          "declaration": { "href": "/api/v1/factfinds/factfind-456/declarations/decl-005" }
        }
      },
      {
        "declarationType": "ComplianceConfirmation",
        "declarationName": "Regulatory Compliance Confirmation",
        "required": true,
        "signed": true,
        "signedDate": "2026-02-16T10:05:00Z",
        "signedBy": "Sarah Johnson",
        "signatureMethod": "ElectronicSignature",
        "declarationVersion": "2024-v1",
        "expiryDate": null,
        "_links": {
          "declaration": { "href": "/api/v1/factfinds/factfind-456/declarations/decl-006" }
        }
      },
      {
        "declarationType": "BestAdvice",
        "declarationName": "Best Advice Declaration",
        "required": true,
        "signed": false,
        "signedDate": null,
        "signedBy": null,
        "signatureMethod": null,
        "declarationVersion": "2024-v1",
        "expiryDate": null,
        "blockingIssue": "Requires suitability report completion first",
        "_links": {
          "sign": { "href": "/api/v1/factfinds/factfind-456/declarations/adviser-sign", "method": "POST" }
        }
      }
    ]
  },
  "consents": {
    "status": "Complete",
    "totalRequired": 2,
    "granted": 2,
    "declined": 0,
    "items": [
      {
        "consentType": "DataProcessing",
        "consentName": "Data Processing Consent (GDPR Article 6)",
        "required": true,
        "status": "Granted",
        "grantedDate": "2026-02-15T16:40:00Z",
        "consentMethod": "ExplicitOptIn",
        "privacyPolicyVersion": "2024-v2",
        "expiryDate": null,
        "withdrawable": true,
        "_links": {
          "consent": { "href": "/api/v1/factfinds/factfind-456/declarations/consent/consent-001" },
          "withdraw": { "href": "/api/v1/factfinds/factfind-456/declarations/consent/consent-001", "method": "DELETE" }
        }
      },
      {
        "consentType": "DataProtection",
        "consentName": "Data Protection and Privacy Notice",
        "required": true,
        "status": "Granted",
        "grantedDate": "2026-02-15T16:40:00Z",
        "consentMethod": "ExplicitOptIn",
        "privacyPolicyVersion": "2024-v2",
        "expiryDate": null,
        "withdrawable": true,
        "_links": {
          "consent": { "href": "/api/v1/factfinds/factfind-456/declarations/consent/consent-002" },
          "withdraw": { "href": "/api/v1/factfinds/factfind-456/declarations/consent/consent-002", "method": "DELETE" }
        }
      }
    ]
  },
  "marketingConsents": {
    "status": "Partial",
    "totalChannels": 4,
    "consentedChannels": 2,
    "declinedChannels": 2,
    "items": [
      {
        "channel": "Email",
        "status": "Granted",
        "grantedDate": "2026-02-15T16:45:00Z",
        "preferences": {
          "frequency": "Monthly",
          "contentTypes": ["Newsletter", "ProductUpdates"]
        },
        "_links": {
          "consent": { "href": "/api/v1/factfinds/factfind-456/declarations/consent/consent-m001" }
        }
      },
      {
        "channel": "Phone",
        "status": "Declined",
        "declinedDate": "2026-02-15T16:45:00Z",
        "_links": {
          "consent": { "href": "/api/v1/factfinds/factfind-456/declarations/consent/consent-m002" }
        }
      },
      {
        "channel": "SMS",
        "status": "Declined",
        "declinedDate": "2026-02-15T16:45:00Z",
        "_links": {
          "consent": { "href": "/api/v1/factfinds/factfind-456/declarations/consent/consent-m003" }
        }
      },
      {
        "channel": "Post",
        "status": "Granted",
        "grantedDate": "2026-02-15T16:45:00Z",
        "preferences": {
          "frequency": "Quarterly",
          "contentTypes": ["Newsletter"]
        },
        "_links": {
          "consent": { "href": "/api/v1/factfinds/factfind-456/declarations/consent/consent-m004" }
        }
      }
    ]
  },
  "outstandingDeclarations": [
    {
      "declarationType": "BestAdvice",
      "declarationName": "Best Advice Declaration",
      "requiredBy": "Adviser",
      "blockingReason": "Requires suitability report completion"
    }
  ],
  "readyForAdvice": false,
  "blockingIssues": [
    {
      "severity": "High",
      "issue": "AdviserDeclarationIncomplete",
      "description": "Best Advice declaration not signed - required before providing advice"
    }
  ],
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456/declarations/status" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "signature-history": { "href": "/api/v1/factfinds/factfind-456/declarations/signature-history" },
    "consent-audit": { "href": "/api/v1/factfinds/factfind-456/declarations/consent-audit" },
    "client-sign": { "href": "/api/v1/factfinds/factfind-456/declarations/client-sign", "method": "POST" },
    "adviser-sign": { "href": "/api/v1/factfinds/factfind-456/declarations/adviser-sign", "method": "POST" }
  }
}
```

**Declaration Status Values:**
- `Complete` - All required declarations signed
- `Partial` - Some required declarations signed
- `Pending` - No declarations signed

**Consent Status Values:**
- `Granted` - Consent given
- `Declined` - Consent explicitly declined
- `Withdrawn` - Consent previously given but withdrawn
- `Expired` - Consent expired (requires renewal)

**Validation Rules:**
- `factfindId` must be valid

**HTTP Status Codes:**
- `200 OK` - Status retrieved successfully
- `404 Not Found` - Fact find not found
- `403 Forbidden` - Insufficient permissions

---

##### 10.7.2.2 Sign Client Declaration

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/declarations/client-sign`

**Description:** Record client signature on a declaration. Captures electronic or wet signature with full audit trail including IP address, device information, and timestamp.

**Request Body:**

```json
{
  "declarationType": "FactFindAccuracy",
  "clientId": "client-123",
  "signatureMethod": "ElectronicSignature",
  "signatureData": {
    "signatureImage": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA...",
    "signatureFormat": "PNG",
    "signatureDimensions": {
      "width": 300,
      "height": 100
    }
  },
  "signedDate": "2026-02-17T14:30:00Z",
  "declarationVersion": "2024-v1",
  "declarationText": "I confirm that the information provided in this fact find is true and accurate to the best of my knowledge. I understand that any inaccurate or incomplete information may affect the suitability of advice provided.",
  "acknowledgedWarnings": [
    "InaccurateInformationRisk",
    "DutyToUpdateInformation"
  ],
  "metadata": {
    "ipAddress": "192.168.1.100",
    "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    "deviceType": "Desktop",
    "operatingSystem": "Windows 10",
    "browser": "Chrome 120",
    "location": {
      "country": "GB",
      "city": "London"
    },
    "signatureDuration": 3.2
  },
  "witnessDetails": {
    "witnessed": false
  },
  "additionalNotes": "Client reviewed fact find details before signing"
}
```

**Signature Methods:**
- `ElectronicSignature` - Digital signature via tablet/mouse/touch
- `WetSignature` - Physical signature scanned and uploaded
- `TypedSignature` - Typed name with checkbox acknowledgment
- `BiometricSignature` - Biometric signature capture device
- `ClickToAccept` - Simple click acceptance (for low-risk declarations)

**Response:**

```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/factfind-456/declarations/decl-client-001
```

```json
{
  "declarationId": "decl-client-001",
  "factfindId": "factfind-456",
  "declarationType": "FactFindAccuracy",
  "declarationName": "Fact Find Accuracy Declaration",
  "declarationCategory": "ClientDeclaration",
  "declarationVersion": "2024-v1",
  "declarationText": "I confirm that the information provided in this fact find is true and accurate to the best of my knowledge. I understand that any inaccurate or incomplete information may affect the suitability of advice provided.",
  "fullDeclarationContent": {
    "mainText": "I confirm that the information provided in this fact find is true and accurate to the best of my knowledge. I understand that any inaccurate or incomplete information may affect the suitability of advice provided.",
    "warnings": [
      {
        "warningType": "InaccurateInformationRisk",
        "warningText": "Providing inaccurate or incomplete information may result in unsuitable advice being given, which could lead to financial loss."
      },
      {
        "warningType": "DutyToUpdateInformation",
        "warningText": "You have a duty to inform us of any changes in your circumstances that may affect the suitability of our advice."
      }
    ],
    "legalImplications": [
      "This declaration forms part of your client agreement",
      "Deliberately providing false information may constitute fraud"
    ]
  },
  "signedBy": {
    "clientId": "client-123",
    "clientName": "John Smith",
    "clientRole": "PrimaryClient"
  },
  "signatureMethod": "ElectronicSignature",
  "signatureData": {
    "signatureImage": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA...",
    "signatureFormat": "PNG",
    "signatureDimensions": {
      "width": 300,
      "height": 100
    },
    "signatureHash": "sha256:a1b2c3d4e5f6...",
    "signatureVerified": true
  },
  "signedDate": "2026-02-17T14:30:00Z",
  "signatureMetadata": {
    "ipAddress": "192.168.1.100",
    "ipAddressVerified": true,
    "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    "deviceType": "Desktop",
    "operatingSystem": "Windows 10",
    "browser": "Chrome 120",
    "location": {
      "country": "GB",
      "countryCode": "GB",
      "city": "London",
      "latitude": 51.5074,
      "longitude": -0.1278
    },
    "signatureDuration": 3.2,
    "timestamp": "2026-02-17T14:30:00Z",
    "timestampVerified": true
  },
  "acknowledgedWarnings": [
    {
      "warningType": "InaccurateInformationRisk",
      "acknowledged": true,
      "acknowledgedDate": "2026-02-17T14:30:00Z"
    },
    {
      "warningType": "DutyToUpdateInformation",
      "acknowledged": true,
      "acknowledgedDate": "2026-02-17T14:30:00Z"
    }
  ],
  "witnessDetails": {
    "witnessed": false
  },
  "complianceStatus": {
    "regulatoryCompliant": true,
    "eIDASCompliant": true,
    "signatureLevel": "AdvancedElectronicSignature",
    "legallyBinding": true
  },
  "auditTrail": {
    "createdDate": "2026-02-17T14:30:00Z",
    "createdBy": "client-123",
    "lastModifiedDate": "2026-02-17T14:30:00Z",
    "modificationCount": 0,
    "immutable": true,
    "auditHash": "sha256:abc123def456..."
  },
  "expiryDate": null,
  "renewalRequired": false,
  "status": "Active",
  "additionalNotes": "Client reviewed fact find details before signing",
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456/declarations/decl-client-001" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "client": { "href": "/api/v1/clients/client-123" },
    "signature-history": { "href": "/api/v1/factfinds/factfind-456/declarations/signature-history" },
    "declaration-pdf": { "href": "/api/v1/factfinds/factfind-456/declarations/decl-client-001/pdf" }
  }
}
```

**Client Declaration Types:**
- `FactFindAccuracy` - Fact find information accuracy
- `RiskWarning` - Investment risk warnings acknowledgment
- `AdviceUnderstanding` - Understanding of advice process
- `CostDisclosure` - Understanding of costs and charges
- `ProductRisks` - Product-specific risk warnings
- `CoolingOffPeriod` - Acknowledgment of cooling-off rights
- `Complaints` - Complaints procedure acknowledgment

**Signature Levels (eIDAS Compliance):**
- `SimpleElectronicSignature` - Basic click acceptance
- `AdvancedElectronicSignature` - Electronic signature with identity verification
- `QualifiedElectronicSignature` - Highest level with qualified certificate

**Validation Rules:**
- `declarationType` must be valid client declaration type
- `clientId` must belong to the fact find
- `signatureMethod` must be valid
- Electronic signatures must include signature image or typed acceptance
- `declarationVersion` must match current approved version
- IP address and timestamp must be captured for electronic signatures
- All required warnings must be acknowledged

**HTTP Status Codes:**
- `201 Created` - Declaration signed successfully
- `400 Bad Request` - Invalid request data
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Fact find or client not found
- `422 Unprocessable Entity` - Validation failed

**Error Response Example:**

```json
{
  "type": "https://api.factfind.com/errors/signature-validation-error",
  "title": "Signature Validation Failed",
  "status": 422,
  "detail": "Electronic signature requires signature image or typed acceptance",
  "instance": "/api/v1/factfinds/factfind-456/declarations/client-sign",
  "errors": [
    {
      "field": "signatureData",
      "message": "Signature image is required for electronic signature method",
      "rejectedValue": null
    }
  ]
}
```

---

##### 10.7.2.3 Sign Adviser Declaration

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/declarations/adviser-sign`

**Description:** Record adviser signature on a declaration. Used for suitability assessment, compliance confirmation, and best advice declarations.

**Request Body:**

```json
{
  "declarationType": "SuitabilityAssessment",
  "adviserId": "adv-789",
  "signatureMethod": "ElectronicSignature",
  "signatureData": {
    "signatureImage": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA...",
    "signatureFormat": "PNG"
  },
  "signedDate": "2026-02-17T15:00:00Z",
  "declarationVersion": "2024-v1",
  "declarationText": "I confirm that I have conducted a comprehensive suitability assessment in accordance with FCA COBS 9.2 requirements. The advice provided is suitable based on the client's circumstances, objectives, and risk profile.",
  "suitabilityReportReference": "SR-2024-02-456",
  "complianceChecklist": {
    "clientCircumstancesAssessed": true,
    "riskProfileCompleted": true,
    "productSuitabilityVerified": true,
    "costsDisclosed": true,
    "warningsProvided": true,
    "documentationComplete": true,
    "supervisoryReviewCompleted": true
  },
  "adviserConfirmations": [
    {
      "confirmationType": "SuitabilityConfirmed",
      "confirmed": true,
      "confirmationText": "I confirm the recommended products are suitable for the client's needs and circumstances"
    },
    {
      "confirmationType": "RiskAppropriate",
      "confirmed": true,
      "confirmationText": "I confirm the investment risk level is appropriate for the client's risk profile"
    },
    {
      "confirmationType": "BestAdvice",
      "confirmed": true,
      "confirmationText": "I confirm this represents my best advice in the client's interest"
    }
  ],
  "metadata": {
    "ipAddress": "192.168.1.50",
    "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X)",
    "deviceType": "Desktop",
    "location": {
      "country": "GB",
      "city": "London"
    }
  },
  "supervisorApproval": {
    "required": true,
    "supervisorId": "sup-456",
    "approvedDate": "2026-02-17T14:45:00Z",
    "approvalNotes": "Suitability assessment reviewed and approved"
  },
  "additionalNotes": "Comprehensive suitability assessment completed. All FCA requirements met."
}
```

**Adviser Declaration Types:**
- `SuitabilityAssessment` - Suitability assessment confirmation
- `ComplianceConfirmation` - Regulatory compliance confirmation
- `BestAdvice` - Best advice declaration
- `ProductDueDiligence` - Product due diligence confirmation
- `ConflictOfInterest` - Conflict of interest disclosure
- `FeesDisclosed` - Fee disclosure confirmation
- `SupervisoryReview` - Supervisory review sign-off

**Response:**

```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/factfind-456/declarations/decl-adv-001
```

```json
{
  "declarationId": "decl-adv-001",
  "factfindId": "factfind-456",
  "declarationType": "SuitabilityAssessment",
  "declarationName": "Suitability Assessment Confirmation",
  "declarationCategory": "AdviserDeclaration",
  "declarationVersion": "2024-v1",
  "declarationText": "I confirm that I have conducted a comprehensive suitability assessment in accordance with FCA COBS 9.2 requirements. The advice provided is suitable based on the client's circumstances, objectives, and risk profile.",
  "signedBy": {
    "adviserId": "adv-789",
    "adviserName": "Sarah Johnson",
    "fcaRegistrationNumber": "FCA12345",
    "adviserRole": "IndependentFinancialAdviser"
  },
  "signatureMethod": "ElectronicSignature",
  "signatureData": {
    "signatureImage": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA...",
    "signatureFormat": "PNG",
    "signatureHash": "sha256:xyz789abc123...",
    "signatureVerified": true
  },
  "signedDate": "2026-02-17T15:00:00Z",
  "signatureMetadata": {
    "ipAddress": "192.168.1.50",
    "ipAddressVerified": true,
    "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X)",
    "deviceType": "Desktop",
    "operatingSystem": "macOS",
    "browser": "Safari 17",
    "location": {
      "country": "GB",
      "city": "London"
    },
    "timestamp": "2026-02-17T15:00:00Z"
  },
  "suitabilityReportReference": "SR-2024-02-456",
  "complianceChecklist": {
    "clientCircumstancesAssessed": true,
    "riskProfileCompleted": true,
    "productSuitabilityVerified": true,
    "costsDisclosed": true,
    "warningsProvided": true,
    "documentationComplete": true,
    "supervisoryReviewCompleted": true,
    "allChecksPassed": true
  },
  "adviserConfirmations": [
    {
      "confirmationType": "SuitabilityConfirmed",
      "confirmed": true,
      "confirmationText": "I confirm the recommended products are suitable for the client's needs and circumstances",
      "confirmedDate": "2026-02-17T15:00:00Z"
    },
    {
      "confirmationType": "RiskAppropriate",
      "confirmed": true,
      "confirmationText": "I confirm the investment risk level is appropriate for the client's risk profile",
      "confirmedDate": "2026-02-17T15:00:00Z"
    },
    {
      "confirmationType": "BestAdvice",
      "confirmed": true,
      "confirmationText": "I confirm this represents my best advice in the client's interest",
      "confirmedDate": "2026-02-17T15:00:00Z"
    }
  ],
  "supervisorApproval": {
    "required": true,
    "approved": true,
    "supervisorId": "sup-456",
    "supervisorName": "Michael Brown",
    "supervisorRole": "ComplianceOfficer",
    "approvedDate": "2026-02-17T14:45:00Z",
    "approvalNotes": "Suitability assessment reviewed and approved"
  },
  "regulatoryCompliance": {
    "fcaCOBS9_2Compliant": true,
    "mifidIICompliant": true,
    "consumerDutyCompliant": true,
    "smcrCompliant": true,
    "complianceStatus": "FullyCompliant"
  },
  "auditTrail": {
    "createdDate": "2026-02-17T15:00:00Z",
    "createdBy": "adv-789",
    "lastModifiedDate": "2026-02-17T15:00:00Z",
    "modificationCount": 0,
    "immutable": true,
    "auditHash": "sha256:def456ghi789..."
  },
  "professionalIndemnityInsurance": {
    "covered": true,
    "policyNumber": "PII-123456",
    "provider": "XYZ Insurance",
    "coverageAmount": {
      "amount": 10000000.00,
      "currency": "GBP"
    },
    "expiryDate": "2027-03-31"
  },
  "status": "Active",
  "additionalNotes": "Comprehensive suitability assessment completed. All FCA requirements met.",
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456/declarations/decl-adv-001" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "adviser": { "href": "/api/v1/advisers/adv-789" },
    "suitability-report": { "href": "/api/v1/suitability-reports/SR-2024-02-456" },
    "signature-history": { "href": "/api/v1/factfinds/factfind-456/declarations/signature-history" }
  }
}
```

**Validation Rules:**
- `declarationType` must be valid adviser declaration type
- `adviserId` must be valid and have required qualifications
- Suitability assessment requires completed risk profile
- Compliance checklist must have all items confirmed
- Supervisor approval required for certain declaration types
- Adviser must have valid FCA registration
- Professional indemnity insurance must be current

**HTTP Status Codes:**
- `201 Created` - Declaration signed successfully
- `400 Bad Request` - Invalid request data
- `403 Forbidden` - Insufficient permissions or qualifications
- `404 Not Found` - Fact find or adviser not found
- `422 Unprocessable Entity` - Validation failed

---

##### 10.7.2.4 Record Consent

**Endpoint:** `POST /api/v1/factfinds/{factfindId}/declarations/consent`

**Description:** Record client consent for data processing, marketing, or other purposes. Supports GDPR Article 7 requirements for explicit, informed, and freely given consent.

**Request Body:**

```json
{
  "clientId": "client-123",
  "consentType": "DataProcessing",
  "consentPurpose": "ProcessPersonalDataForFinancialAdvice",
  "consentMethod": "ExplicitOptIn",
  "consentGiven": true,
  "consentDate": "2026-02-17T14:30:00Z",
  "privacyPolicyVersion": "2024-v2",
  "privacyPolicyUrl": "https://example.com/privacy-policy-2024-v2",
  "consentText": "I consent to the processing of my personal data for the purpose of receiving financial advice, in accordance with the Privacy Policy dated February 2024 (v2).",
  "consentDetails": {
    "dataCategories": [
      "PersonalIdentificationData",
      "FinancialData",
      "ContactInformation",
      "EmploymentData"
    ],
    "processingPurposes": [
      "ProvideFinancialAdvice",
      "RiskAssessment",
      "ProductRecommendation",
      "OngoingServiceProvision",
      "RegulatoryCompliance"
    ],
    "dataRetentionPeriod": "7 years after relationship ends (FCA requirement)",
    "thirdPartySharing": {
      "shared": true,
      "sharedWith": [
        "ProductProviders",
        "RegulatoryBodies",
        "ProfessionalIndemnityInsurer"
      ],
      "legalBasis": "LegitimateInterest"
    },
    "dataTransferOutsideEEA": false,
    "automatedDecisionMaking": false
  },
  "informationProvided": {
    "privacyPolicyProvided": true,
    "rightToWithdrawExplained": true,
    "dataProtectionRightsExplained": true,
    "contactDetailsForQueries": true
  },
  "consentMetadata": {
    "ipAddress": "192.168.1.100",
    "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "deviceType": "Desktop",
    "location": {
      "country": "GB",
      "city": "London"
    },
    "consentDuration": 2.5,
    "consentVerified": true
  },
  "renewalPolicy": {
    "renewalRequired": false,
    "renewalFrequency": null,
    "expiryDate": null
  },
  "additionalNotes": "Client provided informed consent after reviewing privacy policy"
}
```

**Consent Types:**
- `DataProcessing` - GDPR Article 6 data processing
- `DataProtection` - General data protection consent
- `Marketing` - Marketing communications consent
- `Profiling` - Automated profiling consent
- `ThirdPartySharing` - Sharing data with third parties
- `SensitiveData` - Processing sensitive personal data (Article 9)
- `DataTransfer` - Transferring data outside EEA

**Consent Methods:**
- `ExplicitOptIn` - Active consent with checkbox or signature
- `ImpliedConsent` - Implied through actions (limited use)
- `SoftOptIn` - Existing relationship basis
- `ContractualNecessity` - Required for contract performance
- `LegalObligation` - Required by law

**Response:**

```http
HTTP/1.1 201 Created
Location: /api/v1/factfinds/factfind-456/declarations/consent/consent-001
```

```json
{
  "consentId": "consent-001",
  "factfindId": "factfind-456",
  "clientId": "client-123",
  "clientName": "John Smith",
  "consentType": "DataProcessing",
  "consentPurpose": "ProcessPersonalDataForFinancialAdvice",
  "consentMethod": "ExplicitOptIn",
  "consentGiven": true,
  "consentDate": "2026-02-17T14:30:00Z",
  "consentStatus": "Active",
  "privacyPolicyVersion": "2024-v2",
  "privacyPolicyUrl": "https://example.com/privacy-policy-2024-v2",
  "consentText": "I consent to the processing of my personal data for the purpose of receiving financial advice, in accordance with the Privacy Policy dated February 2024 (v2).",
  "consentDetails": {
    "dataCategories": [
      "PersonalIdentificationData",
      "FinancialData",
      "ContactInformation",
      "EmploymentData"
    ],
    "processingPurposes": [
      "ProvideFinancialAdvice",
      "RiskAssessment",
      "ProductRecommendation",
      "OngoingServiceProvision",
      "RegulatoryCompliance"
    ],
    "dataRetentionPeriod": "7 years after relationship ends (FCA requirement)",
    "thirdPartySharing": {
      "shared": true,
      "sharedWith": [
        "ProductProviders",
        "RegulatoryBodies",
        "ProfessionalIndemnityInsurer"
      ],
      "legalBasis": "LegitimateInterest",
      "dataProcessingAgreementsInPlace": true
    },
    "dataTransferOutsideEEA": false,
    "automatedDecisionMaking": false
  },
  "informationProvided": {
    "privacyPolicyProvided": true,
    "rightToWithdrawExplained": true,
    "dataProtectionRightsExplained": true,
    "contactDetailsForQueries": true,
    "dataProtectionOfficerContact": "dpo@example.com"
  },
  "consentMetadata": {
    "ipAddress": "192.168.1.100",
    "ipAddressVerified": true,
    "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "deviceType": "Desktop",
    "operatingSystem": "Windows 10",
    "browser": "Chrome 120",
    "location": {
      "country": "GB",
      "city": "London"
    },
    "consentDuration": 2.5,
    "consentVerified": true,
    "timestamp": "2026-02-17T14:30:00Z"
  },
  "renewalPolicy": {
    "renewalRequired": false,
    "renewalFrequency": null,
    "nextRenewalDate": null,
    "expiryDate": null
  },
  "withdrawalRights": {
    "withdrawable": true,
    "withdrawalMethod": "ContactDataProtectionOfficer",
    "withdrawalContact": "dpo@example.com",
    "withdrawalEffectiveness": "Immediate",
    "consequencesOfWithdrawal": "We may not be able to provide financial advice if you withdraw consent to process your data"
  },
  "gdprCompliance": {
    "article6Compliant": true,
    "article7Compliant": true,
    "article13Compliant": true,
    "lawfulBasis": "Consent",
    "consentSpecific": true,
    "consentInformed": true,
    "consentUnambiguous": true,
    "consentFreelyGiven": true
  },
  "auditTrail": {
    "consentGivenDate": "2026-02-17T14:30:00Z",
    "consentGivenBy": "client-123",
    "consentModifiedDate": null,
    "consentWithdrawnDate": null,
    "consentHistory": []
  },
  "additionalNotes": "Client provided informed consent after reviewing privacy policy",
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456/declarations/consent/consent-001" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "client": { "href": "/api/v1/clients/client-123" },
    "privacy-policy": { "href": "https://example.com/privacy-policy-2024-v2" },
    "withdraw": { "href": "/api/v1/factfinds/factfind-456/declarations/consent/consent-001", "method": "DELETE" },
    "update": { "href": "/api/v1/factfinds/factfind-456/declarations/consent/consent-001", "method": "PUT" },
    "consent-audit": { "href": "/api/v1/factfinds/factfind-456/declarations/consent-audit" }
  }
}
```

**GDPR Compliance Requirements:**
- Consent must be freely given, specific, informed, and unambiguous (Article 7)
- Clear and plain language required
- Easy withdrawal mechanism must be provided
- Separate consent for each processing purpose
- Records of consent must be maintained
- Privacy policy must be provided
- Data retention periods must be specified

**Validation Rules:**
- `consentType` must be valid
- `consentMethod` must be appropriate for consent type
- Privacy policy version must be current
- All GDPR information requirements must be met
- Third party sharing requires separate explicit consent
- Sensitive data processing requires explicit consent (Article 9)

**HTTP Status Codes:**
- `201 Created` - Consent recorded successfully
- `400 Bad Request` - Invalid request data
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Fact find or client not found
- `422 Unprocessable Entity` - GDPR compliance validation failed

---

##### 10.7.2.5 Get Consent Audit Trail

**Endpoint:** `GET /api/v1/factfinds/{factfindId}/declarations/consent-audit`

**Description:** Get complete audit trail of all consent events including consent given, updated, and withdrawn. Required for GDPR Article 7 compliance.

**Query Parameters:**
- `clientId` - Filter by specific client
- `consentType` - Filter by consent type
- `fromDate` - Filter from this date
- `toDate` - Filter to this date

**Response:**

```json
{
  "factfindId": "factfind-456",
  "clientId": "client-123",
  "clientName": "John Smith",
  "auditDate": "2026-02-17T16:00:00Z",
  "totalConsentEvents": 8,
  "activeConsents": 4,
  "withdrawnConsents": 1,
  "updatedConsents": 2,
  "consentAuditTrail": [
    {
      "eventId": "event-001",
      "eventType": "ConsentGiven",
      "eventDate": "2026-02-15T16:40:00Z",
      "consentId": "consent-001",
      "consentType": "DataProcessing",
      "consentPurpose": "ProcessPersonalDataForFinancialAdvice",
      "consentMethod": "ExplicitOptIn",
      "privacyPolicyVersion": "2024-v2",
      "eventDetails": {
        "consentGiven": true,
        "ipAddress": "192.168.1.100",
        "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        "location": "London, GB"
      },
      "gdprCompliant": true
    },
    {
      "eventId": "event-002",
      "eventType": "ConsentGiven",
      "eventDate": "2026-02-15T16:40:00Z",
      "consentId": "consent-002",
      "consentType": "DataProtection",
      "consentPurpose": "DataProtectionAndPrivacyNotice",
      "consentMethod": "ExplicitOptIn",
      "privacyPolicyVersion": "2024-v2",
      "eventDetails": {
        "consentGiven": true,
        "ipAddress": "192.168.1.100",
        "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        "location": "London, GB"
      },
      "gdprCompliant": true
    },
    {
      "eventId": "event-003",
      "eventType": "ConsentGiven",
      "eventDate": "2026-02-15T16:45:00Z",
      "consentId": "consent-m001",
      "consentType": "Marketing",
      "consentPurpose": "EmailMarketing",
      "consentMethod": "ExplicitOptIn",
      "privacyPolicyVersion": "2024-v2",
      "eventDetails": {
        "consentGiven": true,
        "channel": "Email",
        "preferences": {
          "frequency": "Monthly",
          "contentTypes": ["Newsletter", "ProductUpdates"]
        },
        "ipAddress": "192.168.1.100",
        "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        "location": "London, GB"
      },
      "gdprCompliant": true
    },
    {
      "eventId": "event-004",
      "eventType": "ConsentDeclined",
      "eventDate": "2026-02-15T16:45:00Z",
      "consentId": "consent-m002",
      "consentType": "Marketing",
      "consentPurpose": "PhoneMarketing",
      "consentMethod": "ExplicitOptOut",
      "privacyPolicyVersion": "2024-v2",
      "eventDetails": {
        "consentGiven": false,
        "channel": "Phone",
        "ipAddress": "192.168.1.100",
        "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        "location": "London, GB"
      },
      "gdprCompliant": true
    },
    {
      "eventId": "event-005",
      "eventType": "ConsentDeclined",
      "eventDate": "2026-02-15T16:45:00Z",
      "consentId": "consent-m003",
      "consentType": "Marketing",
      "consentPurpose": "SMSMarketing",
      "consentMethod": "ExplicitOptOut",
      "privacyPolicyVersion": "2024-v2",
      "eventDetails": {
        "consentGiven": false,
        "channel": "SMS",
        "ipAddress": "192.168.1.100",
        "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        "location": "London, GB"
      },
      "gdprCompliant": true
    },
    {
      "eventId": "event-006",
      "eventType": "ConsentGiven",
      "eventDate": "2026-02-15T16:45:00Z",
      "consentId": "consent-m004",
      "consentType": "Marketing",
      "consentPurpose": "PostMarketing",
      "consentMethod": "ExplicitOptIn",
      "privacyPolicyVersion": "2024-v2",
      "eventDetails": {
        "consentGiven": true,
        "channel": "Post",
        "preferences": {
          "frequency": "Quarterly",
          "contentTypes": ["Newsletter"]
        },
        "ipAddress": "192.168.1.100",
        "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        "location": "London, GB"
      },
      "gdprCompliant": true
    },
    {
      "eventId": "event-007",
      "eventType": "ConsentUpdated",
      "eventDate": "2026-02-16T10:00:00Z",
      "consentId": "consent-m001",
      "consentType": "Marketing",
      "consentPurpose": "EmailMarketing",
      "eventDetails": {
        "changeType": "PreferenceUpdate",
        "previousPreferences": {
          "frequency": "Monthly",
          "contentTypes": ["Newsletter", "ProductUpdates"]
        },
        "newPreferences": {
          "frequency": "Quarterly",
          "contentTypes": ["Newsletter"]
        },
        "ipAddress": "192.168.1.100",
        "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        "location": "London, GB"
      },
      "gdprCompliant": true
    },
    {
      "eventId": "event-008",
      "eventType": "PrivacyPolicyUpdated",
      "eventDate": "2026-02-17T09:00:00Z",
      "eventDetails": {
        "previousVersion": "2024-v1",
        "newVersion": "2024-v2",
        "changesSummary": "Updated data retention periods and third-party sharing disclosure",
        "reconsentRequired": false,
        "notificationSent": true,
        "notificationDate": "2026-02-17T09:00:00Z"
      },
      "affectedConsents": [
        "consent-001",
        "consent-002",
        "consent-m001",
        "consent-m004"
      ]
    }
  ],
  "consentSummary": {
    "dataProcessingConsent": {
      "status": "Active",
      "consentDate": "2026-02-15T16:40:00Z",
      "lastUpdated": "2026-02-15T16:40:00Z",
      "withdrawable": true
    },
    "marketingConsents": {
      "email": {
        "status": "Active",
        "consentDate": "2026-02-15T16:45:00Z",
        "lastUpdated": "2026-02-16T10:00:00Z",
        "preferences": {
          "frequency": "Quarterly",
          "contentTypes": ["Newsletter"]
        }
      },
      "phone": {
        "status": "Declined",
        "declinedDate": "2026-02-15T16:45:00Z"
      },
      "sms": {
        "status": "Declined",
        "declinedDate": "2026-02-15T16:45:00Z"
      },
      "post": {
        "status": "Active",
        "consentDate": "2026-02-15T16:45:00Z",
        "preferences": {
          "frequency": "Quarterly",
          "contentTypes": ["Newsletter"]
        }
      }
    }
  },
  "gdprCompliance": {
    "article7Compliant": true,
    "consentRecordsComplete": true,
    "withdrawalMechanismAvailable": true,
    "privacyPolicyProvided": true,
    "dataProtectionRightsExplained": true
  },
  "_links": {
    "self": { "href": "/api/v1/factfinds/factfind-456/declarations/consent-audit" },
    "factfind": { "href": "/api/v1/factfinds/factfind-456" },
    "client": { "href": "/api/v1/clients/client-123" },
    "current-consents": { "href": "/api/v1/factfinds/factfind-456/declarations/consent" },
    "privacy-policy": { "href": "https://example.com/privacy-policy-2024-v2" }
  }
}
```

**Event Types:**
- `ConsentGiven` - Initial consent granted
- `ConsentDeclined` - Consent explicitly declined
- `ConsentUpdated` - Consent preferences updated
- `ConsentWithdrawn` - Consent withdrawn
- `ConsentExpired` - Consent expired
- `ConsentRenewed` - Consent renewed
- `PrivacyPolicyUpdated` - Privacy policy version changed

**Validation Rules:**
- `factfindId` must be valid
- Date filters must be valid ISO 8601 format
- `fromDate` must be before `toDate`

**HTTP Status Codes:**
- `200 OK` - Audit trail retrieved successfully
- `404 Not Found` - Fact find not found
- `403 Forbidden` - Insufficient permissions

---
