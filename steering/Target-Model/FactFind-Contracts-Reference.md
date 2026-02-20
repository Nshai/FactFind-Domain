# FactFind Contracts Reference
## Executive Summary
This document provides a comprehensive, non-technical reference for all contracts (data structures) used in the FactFind API. Each contract defines what information can be captured and managed within the system.

### Purpose of This Document
This reference is designed for:
- Business analysts and product owners
- Project managers
- Subject matter experts
- Anyone who needs to understand what data the FactFind system captures

### How to Use This Reference
Each contract section includes:
- **Contract Name and Description**: What the contract represents
- **Business Purpose**: Why this information is captured
- **Field Table**: Detailed breakdown of all data fields
- **Relationships**: How this contract connects to other contracts

### Data Type Legend
- **Text**: Any text value (names, descriptions, notes)
- **Number**: Numeric values (ages, counts, percentages)
- **Currency Amount**: Monetary values with currency
- **Date**: Calendar dates
- **Date and Time**: Date with specific time
- **Yes/No**: True or false values
- **Selection**: Choose from predefined options
- **Reference Link**: Connection to another contract/entity
- **List**: Multiple values of the same type

---

## Table of Contents
### Contracts
- [13.1 Client Contract](#131-client-contract)
- [13.2 FactFind Contract](#132-factfind-contract)
- [13.3 Address Contract](#133-address-contract)
- [13.4 Income Contract](#134-income-contract)
- [13.5 Arrangement Contract](#135-arrangement-contract)
- [13.6 Goal Contract](#136-goal-contract)
- [13.7 RiskProfile Contract](#137-riskprofile-contract)
- [13.8 Investment Contract](#138-investment-contract)
- [13.9 Property Contract](#139-property-contract)
- [13.10 Equity Contract](#1310-equity-contract)
- [13.11 IdentityVerification Contract](#1311-identityverification-contract)
- [13.12 Consent Contract](#1312-consent-contract)
- [13.17 Asset Contract](#1317-asset-contract)
- [13.18 Liability Contract](#1318-liability-contract)
- [13.19 Employment Contract](#1319-employment-contract)
- [13.20 Budget Contract](#1320-budget-contract)
- [13.21 Expenditure Contract](#1321-expenditure-contract)
- [13.22 Expense Contract](#1322-expense-contract)
- [13.23 Credit History Contract](#1323-credit-history-contract)
- [13.24 Property Detail Contract](#1324-property-detail-contract)
- [13.25 Business Asset Contract](#1325-business-asset-contract)
- [13.26 Notes Contract](#1326-notes-contract)
- [13.27 Dependant Contract](#1327-dependant-contract)
- [13.28 Income Changes Contract](#1328-income-changes-contract)
- [13.29 Expenditure Changes Contract](#1329-expenditure-changes-contract)
- [13.30 Affordability Assessment Contract](#1330-affordability-assessment-contract)
- [13.31 Contact Contract](#1331-contact-contract)
- [13.32 Attitude to Risk (ATR) Contract](#1332-attitude-to-risk-atr-contract)
- [13.33 Professional Contact Contract](#1333-professional-contact-contract)
- [13.34 Vulnerability Contract](#1334-vulnerability-contract)
- [13.35 Marketing Preferences Contract](#1335-marketing-preferences-contract)
- [13.36 Estate Planning - Will Contract](#1336-estate-planning---will-contract)
- [13.37 Estate Planning - Lasting Power of Attorney (LPA) Contract](#1337-estate-planning---lasting-power-of-attorney-lpa-contract)
- [13.38 Estate Planning - Gift Contract](#1338-estate-planning---gift-contract)
- [13.39 Estate Planning - Trust Contract](#1339-estate-planning---trust-contract)
- [13.40 Identity Verification & Data Protection Consent Contract](#1340-identity-verification-&-data-protection-consent-contract)
- [13.41 Arrangement - Mortgage Contract](#1341-arrangement---mortgage-contract)
- [13.42 Arrangement - Investment Contract (General Investment Account)](#1342-arrangement---investment-contract-general-investment-account)
- [13.43 Arrangement - Protection Contract (Life Assurance)](#1343-arrangement---protection-contract-life-assurance)
- [13.44 Arrangement - Pension Contract (Personal Pension)](#1344-arrangement---pension-contract-personal-pension)

### Appendices
- [Appendix A: Common Value Types](#appendix-a-common-value-types)
- [Appendix B: Common Enum Values](#appendix-b-common-enum-values)

---


## 13.1 Client Contract

### Business Purpose

Represents an individual person, company, or trust that receives financial advice. This is the core entity that links all fact find information together.

### Key Features

- Supports three client types: Person (individual), Corporate (company), and Trust
- Captures complete demographic and contact information
- Manages regulatory compliance (KYC, AML, MLR)
- Tracks GDPR consent and data protection requirements
- Records marketing preferences and communication consents
- Supports estate planning for individuals (wills, LPAs, IHT)
- Enables joint client relationships (married couples, partners)

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| addresses | List of Complex Data | List of all addresses for this client (current and historical) | List with 2 item(s) |
| adviserRef | Reference Link | The adviser responsible for this client | Complex object |
| clientCategory | Text | Client category (e.g., HighNetWorth, Mass Market) | HighNetWorth |
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| clientSegment | Text | Client segment classification (A, B, C, D for prioritization) | A |
| clientSegmentDate | Date | Client segment classification (A, B, C, D for prioritization) | 2020-01-15 |
| clientType | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |
| contacts | List of Complex Data | Contact information including email, phone, mobile, and website | List with 4 item(s) |
| createdAt | Date | When this record was created in the system | 2020-01-15T10:30:00Z |
| createdBy | Complex Data | User who created this record | Complex object |
| dataProtection | Complex Data | GDPR consent, data protection, and privacy management | Complex object |
| dependants | List of Complex Data | List of financially dependent children and relatives | List with 2 item(s) |
| estatePlanning | Complex Data | Will, power of attorney, gifts, trusts, and inheritance tax planning | Complex object |
| factFindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| financialProfile | Complex Data | Summary of income, assets, liabilities, and net worth | Complex object |
| id | Text | Unique system identifier for this record | client-123 |
| identityVerification | Complex Data | Identity verification, KYC, AML checks, and compliance status | Complex object |
| isHeadOfFamilyGroup | Yes/No | Whether this client is the primary contact for the family group | Yes |
| isJoint | Yes/No | Whether this client is part of a joint (couple) fact find | Yes |
| isMatchingServiceProposition | Yes/No | Whether this client requires matching service due to vulnerability | No |
| marketingPreferences | Complex Data | Marketing channel preferences and opt-in/opt-out status | Complex object |
| matchingServicePropositionReason | Text |  | None |
| officeRef | Complex Data | The office/branch where this client is managed | Complex object |
| paraplannerRef | Reference Link | The paraplanner assigned to this client | Complex object |
| personValue | Complex Data | Personal information (only for individual clients) | Complex object |
| serviceStatus | Text | Current service status (Active, Inactive, Prospect, etc.) | Active |
| serviceStatusDate | Date | Current service status (Active, Inactive, Prospect, etc.) | 2020-01-15 |
| spouseRef | Reference Link | Link to the spouse/partner client record (for joint fact finds) | Complex object |
| territorialProfile | Complex Data | Residency, domicile, citizenship, and territorial tax status | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-16T14:30:00Z |
| updatedBy | Complex Data | User who last modified this record | Complex object |

#### Nested Field Groups

**adviserRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ADV001 |
| id | Text | Unique system identifier for this record | adviser-789 |
| name | Text | First name (given name) | Jane Doe |

**createdBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | adviser-789 |
| name | Text | First name (given name) | Jane Doe |

**dataProtection:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| breachNotifications | Complex Data |  | Complex object |
| breachCount | Number |  | 0 |
| breachesNotified | List |  | Empty list |
| lastBreachDate | Text |  | None |
| dataRetention | Complex Data |  | Complex object |
| archiveDate | Text |  | None |
| relationshipEndDate | Text | Employment end date (null if current) | None |
| retentionBasis | Text |  | FCA Regulatory Requirement |
| retentionEndDate | Text | Employment end date (null if current) | None |
| retentionPeriod | Text |  | 7 years after relationship ends |
| gdprConsent | Complex Data |  | Complex object |
| dataProcessing | Complex Data |  | Complex object |
| consentDate | Date |  | 2020-01-15 |
| consentMethod | Text |  | Explicit |
| consentText | Text |  | I consent to my personal data being processed for ... |
| consented | Yes/No |  | Yes |
| lawfulBasis | Text |  | Consent |
| version | Text |  | 1.0 |
| marketing | Complex Data | Marketing channel preferences and opt-in/opt-out status | Complex object |
| consentDate | Date |  | 2020-01-15 |
| consentMethod | Text |  | Explicit |
| consentText | Text |  | I consent to receiving marketing communications |
| consented | Yes/No |  | Yes |
| lawfulBasis | Text |  | Consent |
| version | Text |  | 1.0 |
| profiling | Complex Data |  | Complex object |
| consentDate | Text |  | None |
| consentMethod | Text |  | None |
| consentText | Text |  | None |
| consented | Yes/No |  | No |
| lawfulBasis | Text |  | None |
| version | Text |  | None |
| thirdPartySharing | Complex Data |  | Complex object |
| consentDate | Text |  | None |
| consentMethod | Text |  | None |
| consentText | Text |  | None |
| consented | Yes/No |  | No |
| lawfulBasis | Text |  | None |
| version | Text |  | None |
| privacyPolicy | Complex Data |  | Complex object |
| acceptanceMethod | Text |  | Electronic |
| acceptedDate | Date |  | 2020-01-15 |
| url | Text |  | https://api.factfind.com/privacy-policy |
| version | Text |  | 2.1 |
| rightsExercised | Complex Data |  | Complex object |
| dsarRequests | Number |  | 0 |
| erasureRequests | Number |  | 0 |
| lastRequestDate | Text |  | None |
| lastRequestType | Text |  | None |
| objectionRequests | Number |  | 0 |
| portabilityRequests | Number |  | 0 |
| rectificationRequests | Number |  | 0 |
| restrictionRequests | Number |  | 0 |

**estatePlanning:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| gifts | Complex Data |  | Complex object |
| annualExemptionAvailable | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Selection |  | Complex object |
| annualExemptionUsed | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 6000.0 |
| currency | Selection |  | Complex object |
| petDetails | List of Complex Data |  | List with 2 item(s) |
| petsOutstanding | Number |  | 2 |
| regularGiftsFromIncome | Complex Data |  | Complex object |
| amount | Currency Amount | Amount spent | Complex object |
| frequency | Text | How often (Monthly, Annual, etc.) | Monthly |
| hasRegularGifts | Yes/No |  | Yes |
| recipient | Text |  | Grandchildren |
| totalGiftsLastYear | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 6000.0 |
| currency | Selection |  | Complex object |
| healthWelfareLPA | Complex Data |  | Complex object |
| attorneys | List of Complex Data |  | List with 1 item(s) |
| hasHealthWelfareLPA | Yes/No |  | Yes |
| lpaDate | Date |  | 2021-05-10 |
| lpaRegistered | Yes/No |  | Yes |
| lpaRegistrationDate | Date |  | 2021-05-15 |
| ihtEstimate | Complex Data |  | Complex object |
| calculationDate | Date |  | 2026-02-18 |
| estimatedEstate | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 650000.0 |
| currency | Selection |  | Complex object |
| estimatedIHT | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 60000.0 |
| currency | Selection |  | Complex object |
| ihtRate | Number |  | 0.4 |
| nextReviewDate | Date |  | 2027-02-18 |
| nilRateBand | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 325000.0 |
| currency | Selection |  | Complex object |
| residenceNilRateBand | Currency Amount | Unique system identifier for this record | Complex object |
| amount | Number | Amount spent | 175000.0 |
| currency | Selection |  | Complex object |
| taxableEstate | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 150000.0 |
| currency | Selection |  | Complex object |
| totalNilRateBand | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 500000.0 |
| currency | Selection |  | Complex object |
| transferableNilRateBand | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Selection |  | Complex object |
| lifeInsuranceInTrust | Complex Data |  | Complex object |
| hasLifeInsuranceInTrust | Yes/No |  | Yes |
| policies | List of Complex Data |  | List with 1 item(s) |
| powerOfAttorney | Complex Data |  | Complex object |
| advisedByUs | Yes/No |  | Yes |
| advisedDate | Date |  | 2021-04-15 |
| attorneys | List of Complex Data |  | List with 1 item(s) |
| hasLPA | Yes/No |  | Yes |
| instructions | Text |  | Can act jointly and severally |
| lpaDate | Date |  | 2021-05-10 |
| lpaExpiryDate | Text |  | None |
| lpaRegistered | Yes/No |  | Yes |
| lpaRegistrationDate | Date |  | 2021-05-15 |
| lpaType | Text |  | Property and Financial Affairs |
| trusts | Complex Data |  | Complex object |
| hasTrusts | Yes/No |  | No |
| numberOfTrusts | Number |  | 0 |
| trustDetails | List |  | Empty list |
| will | Complex Data |  | Complex object |
| advisedByUs | Yes/No |  | Yes |
| advisedDate | Date |  | 2020-06-01 |
| beneficiaries | List of Complex Data | List of trust beneficiaries | List with 1 item(s) |
| executors | List of Complex Data |  | List with 2 item(s) |
| hasWill | Yes/No |  | Yes |
| isUpToDate | Yes/No | Date moved from this address (null if current) | Yes |
| lastReviewed | Date |  | 2024-06-15 |
| nextReviewDate | Date |  | 2027-06-15 |
| willDate | Date |  | 2020-06-15 |
| willStoredLocation | Text |  | London Office |
| willStoredWith | Text |  | Smith & Co Solicitors |
| willType | Text |  | Simple Will |

**factFindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Text | Unique system identifier for this record | factfind-456 |
| status | Text | Current status of the goal | INP |

**financialProfile:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| calculatedAt | Date | When these figures were calculated | 2026-02-18T10:30:00Z |
| grossAnnualIncome | Currency Amount | Total gross annual income before tax | Complex object |
| amount | Number | Amount spent | 75000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| householdIncome | Currency Amount | Combined household income (all clients) | Complex object |
| amount | Number | Amount spent | 120000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| householdNetWorth | Currency Amount | Combined household net worth | Complex object |
| amount | Number | Amount spent | 650000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| lastReviewDate | Date | When these figures were last reviewed | 2026-02-18 |
| netWorth | Currency Amount | Total net worth (assets minus liabilities) | Complex object |
| amount | Number | Amount spent | 450000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| totalAssets | Currency Amount | Total value of all assets | Complex object |
| amount | Number | Amount spent | 500000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| totalJointAssets | Currency Amount | Total value of jointly owned assets | Complex object |
| amount | Number | Amount spent | 200000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**identityVerification:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amlChecks | Complex Data |  | Complex object |
| adverseMediaCheckSource | Text |  | LexisNexis |
| adverseMediaChecked | Yes/No |  | Yes |
| adverseMediaMatches | Number |  | 0 |
| checkPerformedBy | Complex Data |  | Complex object |
| id | Text | Unique system identifier for this record | adviser-789 |
| name | Text | First name (given name) | Jane Doe |
| isPep | Yes/No |  | No |
| lastCheckDate | Date |  | 2020-01-15 |
| nextCheckDate | Date |  | 2025-01-15 |
| overallStatus | Text | Current status of the goal | Clear |
| pepCheckSource | Text |  | World-Check |
| pepChecked | Yes/No |  | Yes |
| riskRating | Text |  | Low |
| sanctionsCheckSource | Text |  | World-Check |
| sanctionsChecked | Yes/No |  | Yes |
| sanctionsMatches | Number |  | 0 |
| documents | List of Complex Data |  | List with 2 item(s) |
| expiryDate | Date |  | 2025-01-15 |
| mlrCompliance | Complex Data |  | Complex object |
| cddCompleted | Yes/No |  | Yes |
| cddCompletedDate | Date |  | 2020-01-15 |
| complianceDate | Date |  | 2020-01-15 |
| complianceStatus | Text | Current status of the goal | Compliant |
| eddCompletedDate | Text |  | None |
| eddRequired | Yes/No |  | No |
| kycComplianceDate | Date |  | 2020-01-15 |
| kycCompliant | Yes/No |  | Yes |
| lastReviewDate | Date | When these figures were last reviewed | 2025-01-15 |
| nextReviewDate | Date |  | 2026-01-15 |
| reviewPeriod | Text |  | Annual |
| nextReviewDate | Date |  | 2025-01-15 |
| sourceOfFunds | Complex Data |  | Complex object |
| description | Text | Description of the goal | Personal savings accumulated over 20 years |
| evidenceProvided | Yes/No | Unique system identifier for this record | Yes |
| evidenceType | Text | Unique system identifier for this record | Bank Statements |
| source | Text |  | Savings |
| verifiedDate | Date | When this contact was verified | 2020-01-15 |
| sourceOfWealth | Complex Data |  | Complex object |
| description | Text | Description of the goal | Senior executive salary and investment portfolio |
| evidenceProvided | Yes/No | Unique system identifier for this record | Yes |
| evidenceType | Text | Unique system identifier for this record | Payslips, Investment Statements |
| primarySource | Text |  | Employment |
| secondarySource | Text |  | Investments |
| verifiedDate | Date | When this contact was verified | 2020-01-15 |
| verificationDate | Date |  | 2020-01-15 |
| verificationMethod | Text |  | Electronic |
| verificationStatus | Text | Current status of the goal | Verified |
| verifiedBy | Complex Data |  | Complex object |
| id | Text | Unique system identifier for this record | adviser-789 |
| name | Text | First name (given name) | Jane Doe |

**marketingPreferences:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| channels | Complex Data |  | Complex object |
| email | Complex Data |  | Complex object |
| consentDate | Date |  | 2020-01-15 |
| consented | Yes/No |  | Yes |
| doubleOptInDate | Date |  | 2020-01-15 |
| frequency | Text | How often (Monthly, Annual, etc.) | Monthly |
| lastContactDate | Date |  | 2026-02-01 |
| optOutDate | Text |  | None |
| unsubscribed | Yes/No |  | No |
| phone | Complex Data |  | Complex object |
| consentDate | Text |  | None |
| consented | Yes/No |  | No |
| frequency | Text | How often (Monthly, Annual, etc.) | None |
| lastContactDate | Text |  | None |
| optOutDate | Text |  | None |
| tpsCheckDate | Date |  | 2020-01-15 |
| tpsChecked | Yes/No |  | Yes |
| tpsRegistered | Yes/No |  | No |
| unsubscribed | Yes/No |  | No |
| post | Complex Data | Postcode/ZIP code | Complex object |
| consentDate | Text |  | None |
| consented | Yes/No |  | No |
| frequency | Text | How often (Monthly, Annual, etc.) | None |
| lastContactDate | Text |  | None |
| mpsCheckDate | Date |  | 2020-01-15 |
| mpsChecked | Yes/No |  | Yes |
| mpsRegistered | Yes/No |  | No |
| optOutDate | Text |  | None |
| unsubscribed | Yes/No |  | No |
| sms | Complex Data |  | Complex object |
| consentDate | Date |  | 2020-01-15 |
| consented | Yes/No |  | Yes |
| frequency | Text | How often (Monthly, Annual, etc.) | Quarterly |
| lastContactDate | Date |  | 2026-01-15 |
| optOutDate | Text |  | None |
| unsubscribed | Yes/No |  | No |
| socialMedia | Complex Data |  | Complex object |
| consentDate | Text |  | None |
| consented | Yes/No |  | No |
| frequency | Text | How often (Monthly, Annual, etc.) | None |
| lastContactDate | Text |  | None |
| optOutDate | Text |  | None |
| unsubscribed | Yes/No |  | No |
| doNotContact | Yes/No |  | No |
| doNotContactReason | Text |  | None |
| interests | List of str |  | List with 4 item(s) |
| lastUpdated | Date |  | 2020-01-15 |
| preferredContactTime | Text |  | Weekday Evenings |
| productInterests | List of str |  | List with 4 item(s) |
| suppressionList | Yes/No |  | No |
| unsubscribeAll | Yes/No |  | No |
| unsubscribeAllDate | Text |  | None |

**officeRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | LON |
| id | Text | Unique system identifier for this record | office-1 |
| name | Text | First name (given name) | London Office |

**paraplannerRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | PP001 |
| id | Text | Unique system identifier for this record | adviser-790 |
| name | Text | First name (given name) | Tom Johnson |

**personValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| age | Number | Current age (calculated from date of birth) | 45 |
| dateOfBirth | Date | Date of birth | 1980-05-15 |
| deceasedDate | Text | Date of death (if applicable) | None |
| employmentStatus | Text | Current employment status | Employed |
| firstName | Text | First name (given name) | John |
| fullName | Text | Complete formatted name including title | Mr John Michael Robert Smith |
| gender | Text | Gender (M=Male, F=Female, O=Other, X=Prefer not to say) | M |
| healthMetrics | Complex Data | Height, weight, BMI for health and insurance assessment | Complex object |
| bmi | Number |  | 26.04 |
| bmiCategory | Text | Expenditure category (Housing, Transport, Food, etc.) | Overweight |
| heightCm | Number |  | 178.0 |
| lastMeasured | Date |  | 2026-01-15 |
| weightKg | Number |  | 82.5 |
| isDeceased | Yes/No | Whether the client has passed away | No |
| lastName | Text | Last name (surname/family name) | Smith |
| maritalStatus | Selection | Current marital status (Single, Married, Divorced, etc.) | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | MAR |
| display | Text |  | Married |
| effectiveFrom | Date |  | 2005-06-20 |
| middleNames | Text | Middle name(s) | Michael Robert |
| niNumber | Text | National Insurance number (UK) | AB123456C |
| occupation | Text | Current occupation/job title | Senior Software Engineer |
| occupationCode | Selection | Standard Occupational Classification (SOC) code | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | 2136 |
| display | Text |  | Programmers and Software Development Professionals |
| socVersion | Text |  | SOC2020 |
| preferredName | Text | Name the client prefers to be called | John |
| salutation | Text | How to address the client (e.g., "Mr Smith") | Mr Smith |
| smokingStatus | Text | Smoking status for insurance purposes | NEVER |
| title | Text | Title (Mr, Mrs, Ms, Dr, etc.) | MR |
| vulnerabilities | List of Complex Data | Consumer Duty vulnerabilities and required adjustments | List with 1 item(s) |

**spouseRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001235 |
| id | Text | Unique system identifier for this record | client-124 |
| name | Text | First name (given name) | Sarah Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**territorialProfile:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| countriesOfCitizenship | List of Complex Data | List of countries where the client holds citizenship | List with 1 item(s) |
| countryOfBirth | Selection | Country where the client was born | Complex object |
| alpha3 | Text |  | GBR |
| code | Text | Standard Occupational Classification (SOC) code | GB |
| display | Text |  | United Kingdom |
| countryOfDomicile | Selection | Country of domicile for tax purposes | Complex object |
| alpha3 | Text |  | GBR |
| code | Text | Standard Occupational Classification (SOC) code | GB |
| display | Text |  | United Kingdom |
| countryOfOrigin | Selection | Country of origin | Complex object |
| alpha3 | Text |  | GBR |
| code | Text | Standard Occupational Classification (SOC) code | GB |
| display | Text |  | United Kingdom |
| countryOfResidence | Selection | Current country of residence | Complex object |
| alpha3 | Text |  | GBR |
| code | Text | Standard Occupational Classification (SOC) code | GB |
| display | Text |  | United Kingdom |
| expatriate | Yes/No | Whether the client is an expatriate | No |
| placeOfBirth | Text | City/town where the client was born | London |
| ukDomicile | Yes/No | Whether the client is UK domiciled | Yes |
| ukResident | Yes/No | Whether the client is UK tax resident | Yes |

**updatedBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | adviser-789 |
| name | Text | First name (given name) | Jane Doe |

---

### Relationships

This contract connects to:

- Belongs to a FactFind (via factFindRef)
- May link to a Spouse/Partner (via spouseRef)
- Assigned to an Adviser (via adviserRef)
- May be assigned to a Paraplanner (via paraplannerRef)
- Belongs to an Office/Branch (via officeRef)
- Contains multiple Addresses
- Contains multiple Contact methods
- Contains multiple Dependants
- Links to multiple Arrangements (pensions, investments, etc.)
- Links to multiple Employment records
- Links to multiple Assets and Liabilities

### Business Validation Rules

- clientType must be one of: Person, Corporate, Trust
- personValue required when clientType=Person
- corporateValue required when clientType=Corporate
- trustValue required when clientType=Trust
- At least one primary contact (email or phone) is required
- At least one current address (toDate=null) is required
- Joint clients (isJoint=true) must have a valid spouseRef
- Identity verification must be valid for active clients

---


## 13.2 FactFind Contract

### Business Purpose

Represents a complete fact finding exercise for one or more clients. Acts as the container for all financial planning information.

### Key Features

- Can be individual or joint (for couples)
- Tracks completion status and workflow
- Links to all clients, arrangements, goals, and documents
- Maintains audit trail of creation and updates

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| additionalNotes | Text |  | None |
| adviserRef | Reference Link | The adviser responsible for this client | Complex object |
| assetHoldings | Complex Data |  | Complex object |
| atrAssessment | Complex Data |  | Complex object |
| clientRef | Reference Link |  | Complex object |
| completionStatus | Complex Data | Current status of the goal | Complex object |
| createdAt | Date | When this record was created in the system | 2026-02-16T14:30:00Z |
| customQuestions | List of Complex Data |  | List with 1 item(s) |
| factFindNumber | Text |  | FF001234 |
| financialSummary | Complex Data |  | Complex object |
| id | Text | Unique system identifier for this record | factfind-456 |
| investmentCapacity | Complex Data | City/town | Complex object |
| jointClientRef | Reference Link |  | Complex object |
| meetingDetails | Complex Data |  | Complex object |
| notes | Text |  | Clients seeking to consolidate pensions and review... |
| updatedAt | Date | When this record was last modified | 2026-02-16T15:45:00Z |

#### Nested Field Groups

**adviserRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ADV001 |
| id | Text | Unique system identifier for this record | adviser-789 |
| name | Text | First name (given name) | Jane Doe |

**assetHoldings:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| borrowing | Complex Data |  | Complex object |
| hasEquityRelease | Yes/No |  | No |
| hasMortgage | Yes/No | Current age (calculated from date of birth) | Yes |
| hasOtherLiabilities | Yes/No |  | Yes |
| credit | Complex Data |  | Complex object |
| hasAdverseCredit | Yes/No |  | No |
| hasBeenRefusedCredit | Yes/No |  | No |
| employment | Complex Data | Current employment status | Complex object |
| hasEmployments | Yes/No |  | Yes |
| investments | Complex Data |  | Complex object |
| hasInvestments | Yes/No |  | Yes |
| hasSavings | Yes/No |  | Yes |
| other | Complex Data |  | Complex object |
| hasOtherAssets | Yes/No |  | Yes |
| pensions | Complex Data |  | Complex object |
| hasAnnuity | Yes/No |  | No |
| hasDefinedBenefitPension | Yes/No |  | No |
| hasMoneyPurchasePension | Yes/No |  | Yes |
| hasPersonalPension | Yes/No |  | Yes |
| protection | Complex Data | GDPR consent, data protection, and privacy management | Complex object |
| hasProtection | Yes/No |  | Yes |

**atrAssessment:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| assessmentDate | Date |  | 2026-02-16T10:30:00Z |
| capacityForLoss | Complex Data | City/town | Complex object |
| assessmentNotes | Text |  | Client has adequate emergency fund and stable inco... |
| canAffordLosses | Yes/No |  | Yes |
| emergencyFundMonths | Number |  | 6 |
| completedAt | Date |  | 2026-02-16T11:10:00Z |
| declarations | Complex Data |  | Complex object |
| adviserDeclaration | Complex Data |  | Complex object |
| adviserRef | Complex Data | The adviser responsible for this client | Complex object |
| agreed | Yes/No |  | Yes |
| agreedAt | Date |  | 2026-02-16T11:00:00Z |
| clientDeclaration | Complex Data |  | Complex object |
| agreed | Yes/No |  | Yes |
| agreedAt | Date |  | 2026-02-16T10:50:00Z |
| nextReviewDate | Date |  | 2027-02-16 |
| questions | List of Complex Data |  | List with 1 item(s) |
| riskProfiles | Complex Data |  | Complex object |
| chosen | Complex Data |  | Complex object |
| chosenAt | Date |  | 2026-02-16T10:45:00Z |
| chosenBy | Text |  | Client |
| riskRating | Text |  | Balanced |
| riskScore | Number |  | 45 |
| generated | List of Complex Data |  | List with 3 item(s) |
| supplementaryQuestions | List |  | Empty list |
| templateRef | Complex Data |  | Complex object |
| id | Text | Unique system identifier for this record | atr-template-v5 |
| name | Text | First name (given name) | FCA Standard ATR 2025 |
| version | Text |  | 5.0 |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Text | Unique system identifier for this record | client-123 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**completionStatus:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| completionDate | Text |  | None |
| compliance | Complex Data |  | Complex object |
| allChecksComplete | Yes/No |  | Yes |
| amlCheckedDate | Date |  | 2026-02-16 |
| idCheckedDate | Date | Unique system identifier for this record | 2026-02-16 |
| declarationSignedDate | Text |  | None |
| isComplete | Yes/No |  | No |
| status | Text | Current status of the goal | INPROG |

**financialSummary:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| calculatedAt | Date | When these figures were calculated | 2026-02-16T15:45:00Z |
| expenditure | Complex Data | Type of expenditure (Essential, Discretionary, etc.) | Complex object |
| monthlyDisposable | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 3000.0 |
| currency | Selection |  | Complex object |
| monthlyTotal | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 4500.0 |
| currency | Selection |  | Complex object |
| income | Complex Data | Total gross annual income before tax | Complex object |
| annualGross | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 120000.0 |
| currency | Selection |  | Complex object |
| monthlyNet | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 7500.0 |
| currency | Selection |  | Complex object |
| netRelevantEarnings | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 110000.0 |
| currency | Selection |  | Complex object |
| liquidity | Complex Data | Unique system identifier for this record | Complex object |
| availableForAdvice | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 70000.0 |
| currency | Selection |  | Complex object |
| totalFundsAvailable | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 85000.0 |
| currency | Selection |  | Complex object |
| sourceOfFunds | Text |  | Savings from employment income over past 5 years |
| taxation | Complex Data |  | Complex object |
| highestRate | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | HIGHER |
| display | Text |  | Higher Rate (40%) |
| rate | Number | Company information (only for corporate clients) | 0.4 |

**investmentCapacity:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| assessmentDate | Date |  | 2026-02-16 |
| emergencyFund | Complex Data |  | Complex object |
| committed | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 15000.0 |
| currency | Selection |  | Complex object |
| required | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 11400.0 |
| currency | Selection |  | Complex object |
| shortfall | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Selection |  | Complex object |
| status | Text | Current status of the goal | Adequate |
| futureChanges | Complex Data |  | Complex object |
| details | Text |  | None |
| expenditureChangesExpected | Yes/No |  | No |
| incomeChangesExpected | Yes/No |  | No |
| lumpSumInvestment | Complex Data |  | Complex object |
| agreedAmount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 50000.0 |
| currency | Selection |  | Complex object |
| sourceOfFunds | Text |  | Savings from employment |
| regularContributions | Complex Data | Regular contributions being made | Complex object |
| agreedMonthlyBudget | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 1000.0 |
| currency | Selection |  | Complex object |
| sustainabilityRating | Text |  | High |

**jointClientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001235 |
| id | Text | Unique system identifier for this record | client-124 |
| name | Text | First name (given name) | Sarah Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**meetingDetails:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientsPresent | Text |  | BothClients |
| meetingDate | Date |  | 2026-02-16 |
| meetingType | Text |  | INIT |
| othersPresent | Yes/No |  | No |
| othersPresentDetails | Text |  | None |
| scopeOfAdvice | Complex Data |  | Complex object |
| estatePlanning | Yes/No | Will, power of attorney, gifts, trusts, and inheritance tax planning | No |
| mortgage | Yes/No | Current age (calculated from date of birth) | No |
| protection | Yes/No | GDPR consent, data protection, and privacy management | Yes |
| retirementPlanning | Yes/No |  | Yes |
| savingsAndInvestments | Yes/No |  | Yes |

---

### Relationships

This contract connects to:

- Contains one or more Clients
- Contains multiple Goals/Objectives
- Contains multiple Arrangements
- Contains multiple Assets and Liabilities
- Contains multiple Documents
- Assigned to an Adviser
- May be assigned to a Paraplanner

### Business Validation Rules

- Must have at least one client
- Joint fact finds must have exactly two clients
- FactFind number must be unique
- Status must progress in valid sequence

---


## 13.3 Address Contract
### Overview
The `Address` contract represents a client's address with additional metadata for residency tracking. When an address needs independent lifecycle management (e.g., address history), it becomes a reference type with identity.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| address | Complex Data | List of all addresses for this client (current and historical) | Complex object |
| addressType | Text | Type of address (Residential, Previous, Business, etc.) | Residential |
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2020-01-15T10:30:00Z |
| factFindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Text | Unique system identifier for this record | address-789 |
| isCorrespondenceAddress | Yes/No |  | Yes |
| isOnElectoralRoll | Yes/No |  | Yes |
| residencyPeriod | Complex Data | Unique system identifier for this record | Complex object |
| residencyStatus | Text | Unique system identifier for this record | Owner |
| updatedAt | Date | When this record was last modified | 2026-02-16T14:30:00Z |

#### Nested Field Groups

**address:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| city | Text | City/town | London |
| country | Text | Country | GB |
| county | Text | County/region | Greater London |
| line1 | Text | Address line 1 | 123 High Street |
| line2 | Text | Address line 2 | Apartment 4B |
| postcode | Text | Postcode/ZIP code | SW1A 1AA |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Text | Unique system identifier for this record | client-123 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**factFindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Text | Unique system identifier for this record | factfind-456 |
| status | Text | Current status of the goal | INP |

**residencyPeriod:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| endDate | Text | Employment end date (null if current) | None |
| startDate | Date | Employment start date | 2020-01-15 |

---

## 13.4 Income Contract
### Overview
The `Income` contract represents an income source within a FactFind.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-02-16T14:30:00Z |
| description | Text | Description of the goal | Salary from Tech Corp Ltd |
| employmentRef | Reference Link |  | Complex object |
| factFindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| frequency | Selection | How often (Monthly, Annual, etc.) | Complex object |
| grossAmount | Currency Amount | Amount spent | Complex object |
| id | Text | Unique system identifier for this record | income-101 |
| incomePeriod | Complex Data |  | Complex object |
| incomeType | Text |  | Employment |
| isGuaranteed | Yes/No |  | Yes |
| isOngoing | Yes/No |  | Yes |
| isPrimary | Yes/No | Whether this is the primary/main address | Yes |
| nationalInsuranceDeducted | Currency Amount |  | Complex object |
| netAmount | Currency Amount | Amount spent | Complex object |
| notes | Text |  | Annual bonus typically £10k |
| taxDeducted | Currency Amount |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-16T15:45:00Z |

#### Nested Field Groups

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Text | Unique system identifier for this record | client-123 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**employmentRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| employerName | Text | Name of the employer | Tech Corp Ltd |
| id | Text | Unique system identifier for this record | employment-222 |
| status | Text | Current status of the goal | Current |

**factFindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF001234 |
| id | Text | Unique system identifier for this record | factfind-456 |
| status | Text | Current status of the goal | InProgress |

**frequency:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | A |
| display | Text |  | Annually |
| periodsPerYear | Number |  | 1 |

**grossAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 75000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**incomePeriod:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| endDate | Text | Employment end date (null if current) | None |
| startDate | Date | Employment start date | 2020-01-15 |

**nationalInsuranceDeducted:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 5000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**netAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 55000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**taxDeducted:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 15000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

---

## 13.5 Arrangement Contract

### Business Purpose

Represents any financial product or arrangement including pensions, investments, mortgages, protection policies, and bank accounts.

### Key Features

- Unified structure for all arrangement types
- Tracks current values and contributions
- Manages provider and product information
- Supports single and joint ownership
- Links to underlying investments and funds

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adviserRef | Reference Link | The adviser responsible for this client | Complex object |
| arrangementCategory | Text | Expenditure category (Housing, Transport, Food, etc.) | PENSION |
| arrangementNumber | Text |  | ARR123456 |
| arrangementPeriod | Complex Data |  | Complex object |
| clientOwners | List of Complex Data | Who owns this arrangement | List with 1 item(s) |
| contributionFrequency | Selection | How often (Monthly, Annual, etc.) | Complex object |
| createdAt | Date | When this record was created in the system | 2015-01-01T10:00:00Z |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| expectedRetirementAge | Number | Current age (calculated from date of birth) | 67 |
| factFindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| hasGuaranteedAnnuityRate | Yes/No |  | No |
| hasProtectedTaxFreeAmount | Yes/No | Amount spent | No |
| id | Text | Unique system identifier for this record | arrangement-555 |
| isInDrawdown | Yes/No |  | No |
| isSalarySacrifice | Yes/No | Annual salary | No |
| notes | Text |  | Consolidated from previous workplace pensions |
| pensionType | Text |  | PERSONAL_PENSION |
| policyNumber | Text | Policy or account number | POL123456 |
| productName | Text | Name of the financial product | ABC SIPP |
| projectedValueAtRetirement | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| providerRef | Reference Link | Unique system identifier for this record | Complex object |
| regularContribution | Currency Amount |  | Complex object |
| status | Text | Current status of the goal | ACT |
| updatedAt | Date | When this record was last modified | 2026-02-16T14:30:00Z |
| valuationDate | Date |  | 2026-02-01 |

#### Nested Field Groups

**adviserRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ADV001 |
| id | Text | Unique system identifier for this record | adviser-789 |
| name | Text | First name (given name) | Jane Doe |

**arrangementPeriod:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| endDate | Text | Employment end date (null if current) | None |
| startDate | Date | Employment start date | 2015-01-01 |

**contributionFrequency:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | M |
| display | Text |  | Monthly |
| periodsPerYear | Number |  | 12 |

**currentValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 125000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**factFindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Text | Unique system identifier for this record | factfind-456 |
| status | Text | Current status of the goal | INP |

**projectedValueAtRetirement:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 450000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**providerRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| frnNumber | Text |  | 123456 |
| id | Text | Unique system identifier for this record | provider-456 |
| name | Text | First name (given name) | ABC Pension Provider Ltd |

**regularContribution:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

---

### Relationships

This contract connects to:

- Belongs to a Client (owner)
- Belongs to a FactFind
- May have joint owner (secondOwnerRef)
- Contains multiple Investment holdings
- May link to Property (for mortgages)
- May link to Employment (for workplace pensions)

### Business Validation Rules

- arrangementType is required
- provider is required
- policyNumber must be unique per provider
- Joint arrangements must have secondOwnerRef
- Current value must be >= 0
- Mortgage must link to a property

---


## 13.6 Goal Contract

### Business Purpose

Represents a financial goal or objective that the client wants to achieve, such as retirement, buying a property, or education funding.

### Key Features

- Defines target amount and target date
- Tracks priority and status
- Links goals to specific arrangements and assets
- Supports progress tracking

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-02-16T14:30:00Z |
| currentSavings | Currency Amount |  | Complex object |
| description | Text | Description of the goal | Build sufficient pension pot to support £40k annua... |
| factFindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| goalName | Text |  | Comfortable retirement at age 65 |
| goalType | Text | Type of goal (Retirement, Education, Property Purchase, etc.) | Retirement |
| id | Text | Unique system identifier for this record | goal-888 |
| isAchievable | Yes/No |  | No |
| monthlyContribution | Currency Amount |  | Complex object |
| notes | Text |  | May need to increase contributions or adjust targe... |
| priority | Text | Priority level (High, Medium, Low) | High |
| projectedShortfall | Currency Amount |  | Complex object |
| status | Text | Current status of the goal | InProgress |
| targetAmount | Currency Amount | Target amount needed | Complex object |
| targetDate | Date | Target date to achieve the goal | 2045-05-15 |
| updatedAt | Date | When this record was last modified | 2026-02-16T15:45:00Z |
| yearsToGoal | Number |  | 19 |

#### Nested Field Groups

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Text | Unique system identifier for this record | client-123 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**currentSavings:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 125000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**factFindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Text | Unique system identifier for this record | factfind-456 |
| status | Text | Current status of the goal | INP |

**monthlyContribution:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**projectedShortfall:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 150000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**targetAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 500000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

---

### Relationships

This contract connects to:

- Belongs to a Client
- Belongs to a FactFind
- May link to specific Arrangements
- May link to specific Assets

### Business Validation Rules

- targetDate must be in the future
- targetAmount must be > 0
- priority must be High, Medium, or Low

---


## 13.7 RiskProfile Contract
### Overview
The `RiskProfile` contract represents a client's risk assessment and attitude to risk.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adviserRef | Reference Link | The adviser responsible for this client | Complex object |
| assessmentDate | Date |  | 2026-02-16 |
| assessmentType | Text |  | ATR |
| attitudeToRiskRating | Text |  | Balanced |
| attitudeToRiskScore | Number |  | 6 |
| capacityForLossRating | Text | City/town | Medium |
| capacityForLossScore | Number | City/town | 7 |
| clientRef | Reference Link |  | Complex object |
| comfortableWithVolatility | Yes/No |  | Yes |
| createdAt | Date | When this record was created in the system | 2026-02-16T14:30:00Z |
| factFindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| hasInvestedBefore | Yes/No |  | Yes |
| id | Text | Unique system identifier for this record | riskprofile-999 |
| investmentExperience | Text |  | Moderate |
| isValid | Yes/No | Unique system identifier for this record | Yes |
| notes | Text |  | Client understands market volatility but nervous a... |
| overallRiskRating | Text |  | Balanced |
| questionsAndAnswers | List of Complex Data |  | List with 1 item(s) |
| reviewDate | Date | When these figures were last reviewed | 2027-02-16 |
| timeHorizon | Text |  | LongTerm |
| understandsRisk | Yes/No |  | Yes |
| updatedAt | Date | When this record was last modified | 2026-02-16T15:45:00Z |
| validUntil | Date | Unique system identifier for this record | 2027-02-16 |
| wouldAcceptLosses | Yes/No |  | No |
| yearsToRetirement | Number |  | 19 |

#### Nested Field Groups

**adviserRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ADV001 |
| id | Text | Unique system identifier for this record | adviser-789 |
| name | Text | First name (given name) | Jane Doe |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Text | Unique system identifier for this record | client-123 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**factFindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Text | Unique system identifier for this record | factfind-456 |
| status | Text | Current status of the goal | INP |

---

## 13.8 Investment Contract
### Overview
The `Investment` contract extends the Arrangement contract with investment-specific fields for ISAs, GIAs, Bonds, and Investment Trusts.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| accountNumber | Text |  | ACC-12345678 |
| adviceType | Text |  | ONGOING |
| adviserRef | Reference Link | The adviser responsible for this client | Complex object |
| annualIsaAllowance | Currency Amount |  | Complex object |
| annualizedReturn | Number |  | 5.87 |
| arrangementCategory | Text | Expenditure category (Housing, Transport, Food, etc.) | INVESTMENT |
| arrangementId | Text | Unique system identifier for this record | arrangement-456 |
| assetAllocation | Complex Data |  | Complex object |
| benchmarkIndex | Text |  | FTSE All-World Index |
| charges | Complex Data |  | Complex object |
| clientRef | Reference Link |  | Complex object |
| contributions | List of Complex Data | Regular contributions being made | List with 2 item(s) |
| costBasis | Currency Amount |  | Complex object |
| createdAt | Date | When this record was created in the system | 2020-04-06T10:00:00Z |
| createdBy | Complex Data | User who created this record | Complex object |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| documents | List of Complex Data |  | List with 1 item(s) |
| factFindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| geographicAllocation | Complex Data |  | Complex object |
| holdings | List of Complex Data |  | List with 4 item(s) |
| id | Text | Unique system identifier for this record | investment-789 |
| inceptionDate | Date |  | 2020-04-06 |
| investmentObjective | Text |  | Long-term capital growth with moderate risk exposu... |
| investmentType | Text |  | STOCKS_SHARES_ISA |
| isAdvised | Yes/No |  | Yes |
| isRegularContributionActive | Yes/No |  | Yes |
| isTaxable | Yes/No |  | No |
| isaAllowanceRemaining | Currency Amount |  | Complex object |
| isaAllowanceUsed | Currency Amount |  | Complex object |
| isaType | Text |  | STOCKS_SHARES |
| lastRebalancingDate | Date |  | 2026-01-15 |
| lastReviewDate | Date | When these figures were last reviewed | 2026-01-15 |
| maturityDate | Text | When the arrangement matures | None |
| moneyWeightedReturn | Number |  | 5.65 |
| netContributions | Currency Amount | Regular contributions being made | Complex object |
| nextContributionDate | Date |  | 2026-03-01 |
| nextRebalancingDate | Date |  | 2026-04-15 |
| nextReviewDate | Date |  | 2027-01-15 |
| notes | Text |  | Client prefers sustainable investing, ESG funds wh... |
| planName | Text |  | Vanguard ISA Portfolio |
| policyNumber | Text | Policy or account number | ISA-987654321 |
| provider | Selection | Financial institution or provider | Complex object |
| realizedGain | Currency Amount |  | Complex object |
| rebalancingFrequency | Text | How often (Monthly, Annual, etc.) | QUARTERLY |
| regularContribution | Currency Amount |  | Complex object |
| regularContributionFrequency | Text | How often (Monthly, Annual, etc.) | MONTHLY |
| riskRating | Selection |  | Complex object |
| startDate | Date | Employment start date | 2020-04-06 |
| status | Text | Current status of the goal | ACTIVE |
| taxFields | Complex Data |  | Complex object |
| taxWrapperType | Text |  | ISA |
| taxYear | Text |  | 2025/2026 |
| timeWeightedReturn | Number |  | 6.12 |
| totalContributions | Currency Amount | Regular contributions being made | Complex object |
| totalHoldings | Number |  | 4 |
| totalReturn | Currency Amount |  | Complex object |
| totalReturnPercentage | Number | Current age (calculated from date of birth) | 29.0 |
| totalWithdrawals | Currency Amount |  | Complex object |
| unrealizedGain | Currency Amount |  | Complex object |
| unrealizedGainPercentage | Number | Current age (calculated from date of birth) | 23.33 |
| updatedAt | Date | When this record was last modified | 2026-02-16T16:30:00Z |
| updatedBy | Complex Data | User who last modified this record | Complex object |
| valuationDate | Date |  | 2026-02-16 |
| withdrawals | List of Complex Data |  | List with 1 item(s) |
| yearsHeld | Number |  | 5.87 |

#### Nested Field Groups

**adviserRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ADV001 |
| id | Text | Unique system identifier for this record | adviser-789 |
| name | Text | First name (given name) | Jane Doe |

**annualIsaAllowance:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 20000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**assetAllocation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| alternatives | Complex Data |  | Complex object |
| percentage | Number | Current age (calculated from date of birth) | 5.0 |
| value | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| amount | Number | Amount spent | 9250.0 |
| currency | Selection |  | Complex object |
| bonds | Complex Data |  | Complex object |
| percentage | Number | Current age (calculated from date of birth) | 25.0 |
| value | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| amount | Number | Amount spent | 46250.0 |
| currency | Selection |  | Complex object |
| cash | Complex Data |  | Complex object |
| percentage | Number | Current age (calculated from date of birth) | 5.0 |
| value | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| amount | Number | Amount spent | 9250.0 |
| currency | Selection |  | Complex object |
| equities | Complex Data |  | Complex object |
| percentage | Number | Current age (calculated from date of birth) | 65.0 |
| value | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| amount | Number | Amount spent | 120250.0 |
| currency | Selection |  | Complex object |

**charges:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| annualManagementCharge | Number | Current age (calculated from date of birth) | 0.15 |
| exitFees | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| platformFee | Number |  | 0.25 |
| totalExpenseRatio | Number |  | 0.4 |
| transactionFees | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Text | Unique system identifier for this record | client-123 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**costBasis:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 150000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**createdBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

**currentValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 185000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**factFindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Text | Unique system identifier for this record | factfind-123 |
| status | Text | Current status of the goal | INP |

**geographicAllocation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| asiaPacific | Complex Data |  | Complex object |
| percentage | Number | Current age (calculated from date of birth) | 8.0 |
| value | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| amount | Number | Amount spent | 14800.0 |
| currency | Selection |  | Complex object |
| emergingMarkets | Complex Data |  | Complex object |
| percentage | Number | Current age (calculated from date of birth) | 2.0 |
| value | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| amount | Number | Amount spent | 3700.0 |
| currency | Selection |  | Complex object |
| europe | Complex Data |  | Complex object |
| percentage | Number | Current age (calculated from date of birth) | 15.0 |
| value | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| amount | Number | Amount spent | 27750.0 |
| currency | Selection |  | Complex object |
| northAmerica | Complex Data |  | Complex object |
| percentage | Number | Current age (calculated from date of birth) | 45.0 |
| value | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| amount | Number | Amount spent | 83250.0 |
| currency | Selection |  | Complex object |
| uk | Complex Data | Whether the client is UK tax resident | Complex object |
| percentage | Number | Current age (calculated from date of birth) | 30.0 |
| value | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| amount | Number | Amount spent | 55500.0 |
| currency | Selection |  | Complex object |

**isaAllowanceRemaining:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 5000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**isaAllowanceUsed:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 15000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**netContributions:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 145000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**provider:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | VANGUARD |
| display | Text |  | Vanguard Asset Management |
| frnNumber | Text |  | 123456 |

**realizedGain:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 8500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**regularContribution:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**riskRating:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | MODERATE |
| display | Text |  | Moderate Risk |
| numericScore | Number |  | 5 |
| scale | Text |  | 1-7 |

**taxFields:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| capitalGainsAllowance | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 3000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| capitalGainsUsed | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| dividendsAllowance | Currency Amount | Unique system identifier for this record | Complex object |
| amount | Number | Amount spent | 500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| dividendsReceived | Currency Amount | Unique system identifier for this record | Complex object |
| amount | Number | Amount spent | 8500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| isTaxExempt | Yes/No |  | Yes |
| taxExemptReason | Text |  | Stocks & Shares ISA - tax wrapper |
| taxPaid | Currency Amount | Unique system identifier for this record | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| taxRelief | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**totalContributions:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 150000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**totalReturn:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 43500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**totalWithdrawals:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 5000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**unrealizedGain:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 35000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**updatedBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

---

## 13.9 Property Contract

### Business Purpose

Represents a property owned or partially owned by the client, including residential homes, buy-to-let properties, and commercial property.

### Key Features

- Tracks property value and purchase details
- Manages rental income for investment properties
- Identifies main residence for tax purposes
- Links to mortgages and equity

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| address | Complex Data | List of all addresses for this client (current and historical) | Complex object |
| annualizedGrowth | Number |  | 3.94 |
| capitalGrowth | Currency Amount |  | Complex object |
| capitalGrowthPercentage | Number | Current age (calculated from date of birth) | 30.77 |
| comparables | List of Complex Data |  | List with 2 item(s) |
| councilTaxAnnual | Currency Amount |  | Complex object |
| councilTaxBand | Text |  | D |
| createdAt | Date | When this record was created in the system | 2018-06-15T10:00:00Z |
| createdBy | Complex Data | User who created this record | Complex object |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| documents | List of Complex Data |  | List with 1 item(s) |
| energyPerformanceCertificate | Complex Data |  | Complex object |
| equityAmount | Currency Amount | Amount spent | Complex object |
| equityPercentage | Number | Current age (calculated from date of birth) | 43.53 |
| estimatedSalePrice | Text |  | None |
| expenses | List of Complex Data |  | List with 7 item(s) |
| factFindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| floorArea | Complex Data |  | Complex object |
| groundRent | Currency Amount |  | Complex object |
| id | Text | Unique system identifier for this record | property-456 |
| improvements | List of Complex Data |  | List with 2 item(s) |
| intendToRefinance | Yes/No |  | No |
| intendToSell | Yes/No |  | No |
| isBuyToLet | Yes/No |  | Yes |
| isJointOwnership | Yes/No | Whether this client is part of a joint (couple) fact find | No |
| isPrimaryResidence | Yes/No | Unique system identifier for this record | No |
| isRented | Yes/No |  | Yes |
| jointOwnershipType | Text | Who owns this arrangement | None |
| leaseRemaining | Number |  | 95 |
| loanToValue | Number | The contact value (email address, phone number, etc.) | 56.47 |
| mortgages | List of Complex Data | Current age (calculated from date of birth) | List with 1 item(s) |
| netAnnualIncome | Currency Amount |  | Complex object |
| netMonthlyIncome | Currency Amount |  | Complex object |
| notes | Text |  | Well-maintained property in popular riverside deve... |
| numberOfBathrooms | Number |  | 1 |
| numberOfBedrooms | Number |  | 2 |
| numberOfReceptionRooms | Number |  | 1 |
| owners | List of Complex Data | Who owns this arrangement | List with 1 item(s) |
| ownershipStructure | Text | Who owns this arrangement | SOLE |
| ownershipType | Text | Who owns this arrangement | FREEHOLD |
| plannedSaleDate | Text |  | None |
| previousValuation | Currency Amount |  | Complex object |
| previousValuationDate | Date |  | 2025-02-10 |
| propertyDescription | Text | Description of the goal | Two bedroom apartment with river views, modern kit... |
| propertySubType | Text |  | APARTMENT |
| propertyType | Text | Type of property (Residential, Buy-to-Let, Commercial, etc.) | BTL |
| purchaseCosts | Complex Data |  | Complex object |
| purchaseDate | Date | Date property was purchased | 2018-06-15 |
| purchasePrice | Currency Amount | Original purchase price | Complex object |
| rentalIncome | Complex Data | Annual rental income (if applicable) | Complex object |
| serviceCharge | Currency Amount |  | Complex object |
| taxFields | Complex Data |  | Complex object |
| tenure | Text |  | LEASEHOLD |
| totalAnnualExpenses | Currency Amount |  | Complex object |
| totalImprovementsCost | Currency Amount |  | Complex object |
| totalInvestment | Currency Amount |  | Complex object |
| totalMonthlyExpenses | Currency Amount |  | Complex object |
| totalMortgageBalance | Currency Amount | Current age (calculated from date of birth) | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-16T14:30:00Z |
| updatedBy | Complex Data | User who last modified this record | Complex object |
| valuationChange | Currency Amount |  | Complex object |
| valuationChangePercentage | Number | Current age (calculated from date of birth) | 3.66 |
| valuationDate | Date |  | 2026-02-10 |
| valuationProvider | Text | Unique system identifier for this record | Zoopla |
| valuationReference | Text |  | VAL-2026-02-12345 |
| valuationType | Text |  | DESKTOP |

#### Nested Field Groups

**address:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| addressType | Text | Type of address (Residential, Previous, Business, etc.) | BTL |
| city | Text | City/town | London |
| coordinates | Complex Data |  | Complex object |
| latitude | Number |  | 51.5074 |
| longitude | Number |  | -0.1278 |
| country | Selection | Country | Complex object |
| alpha3 | Text |  | GBR |
| code | Text | Standard Occupational Classification (SOC) code | GB |
| display | Text |  | United Kingdom |
| county | Text | County/region | GLA |
| line1 | Text | Address line 1 | Flat 12, Riverside Apartments |
| line2 | Text | Address line 2 | 45 Thames Street |
| postcode | Text | Postcode/ZIP code | SE1 9PH |
| uprn | Text |  | 100023456789 |

**capitalGrowth:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 100000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**councilTaxAnnual:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 1800.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**createdBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

**currentValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 425000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**energyPerformanceCertificate:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| epcRating | Text |  | C |
| epcReference | Text |  | 1234-5678-9012-3456-7890 |
| epcScore | Number |  | 72 |
| epcValidUntil | Date | Unique system identifier for this record | 2028-06-15 |

**equityAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 185000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**factFindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Text | Unique system identifier for this record | factfind-123 |
| status | Text | Current status of the goal | INP |

**floorArea:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| unit | Text |  | sqft |
| value | Number | The contact value (email address, phone number, etc.) | 850 |

**groundRent:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 250.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| frequency | Text | How often (Monthly, Annual, etc.) | ANNUAL |

**netAnnualIncome:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 5050.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**netMonthlyIncome:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 420.84 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**previousValuation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 410000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**purchaseCosts:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| estateAgentFees | Currency Amount | Current age (calculated from date of birth) | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| legalFees | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 1500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| otherCosts | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 250.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| stampDuty | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 9750.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| surveyFees | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| totalCosts | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 12000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**purchasePrice:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 325000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**rentalIncome:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| annualRent | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 19800.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| depositAmount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 1650.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| depositReference | Text |  | DPS-123456789 |
| depositScheme | Text |  | Deposit Protection Service |
| isFixedTerm | Yes/No |  | Yes |
| lastRentReviewDate | Date |  | 2025-08-01 |
| monthlyRent | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 1650.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| nextRentReviewDate | Date |  | 2026-08-01 |
| rentalYieldGross | Number |  | 4.66 |
| rentalYieldNet | Number |  | 2.35 |
| tenancyEndDate | Date | Employment end date (null if current) | 2026-07-31 |
| tenancyRenewalDate | Date |  | 2026-07-31 |
| tenancyStartDate | Date | Employment start date | 2025-08-01 |
| tenancyType | Text |  | AST |
| tenantContactEmail | Text |  | emma.j@example.com |
| tenantName | Text |  | Emma Johnson |
| voidPeriodsDays | Number | Unique system identifier for this record | 45 |

**serviceCharge:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 150.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| frequency | Text | How often (Monthly, Annual, etc.) | MONTHLY |

**taxFields:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| capitalGainsLiability | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 100000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| capitalGainsTaxEstimate | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 28000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| eligibleForPRR | Yes/No |  | No |
| estimatedCGTBaseValue | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| amount | Number | Amount spent | 325000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| lettingsRelief | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| prrYears | Number |  | 0 |
| rentalIncomeTaxable | Currency Amount | Annual rental income (if applicable) | Complex object |
| amount | Number | Amount spent | 5050.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| stampDutyPaid | Currency Amount | Unique system identifier for this record | Complex object |
| amount | Number | Amount spent | 9750.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| stampDutyRate | Number |  | 3.0 |
| taxYearReported | Text |  | 2025/2026 |

**totalAnnualExpenses:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 14750.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**totalImprovementsCost:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 13000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**totalInvestment:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 337000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**totalMonthlyExpenses:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 1229.16 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**totalMortgageBalance:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 240000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**updatedBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

**valuationChange:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 15000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

---

### Relationships

This contract connects to:

- Belongs to a Client (owner)
- Belongs to a FactFind
- May have joint owner (secondOwnerRef)
- May link to Mortgage arrangements
- Has Property Detail sub-records

### Business Validation Rules

- propertyValue must be > 0
- purchasePrice must be > 0
- Only one property can be marked as main residence
- Rental income only applicable for buy-to-let properties

---


## 13.10 Equity Contract
### Overview
The `Equity` contract represents a direct stock holding with performance tracking and dividend history.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| accountType | Text |  | GIA |
| adviserRef | Reference Link | The adviser responsible for this client | Complex object |
| broker | Complex Data |  | Complex object |
| clientRef | Reference Link |  | Complex object |
| companyDescription | Text | Description of the goal | British multinational oil and gas company |
| companyName | Text | Official registered company name | BP plc |
| corporateActions | List of Complex Data |  | List with 2 item(s) |
| country | Selection | Country | Complex object |
| createdAt | Date | When this record was created in the system | 2021-03-15T10:00:00Z |
| createdBy | Complex Data | User who created this record | Complex object |
| currency | Selection |  | Complex object |
| cusip | Text |  | None |
| dividends | List of Complex Data | Unique system identifier for this record | List with 3 item(s) |
| documents | List of Complex Data |  | List with 1 item(s) |
| exchange | Selection |  | Complex object |
| factFindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| holdings | Complex Data |  | Complex object |
| id | Text | Unique system identifier for this record | equity-321 |
| industry | Text |  | Integrated Oil & Gas |
| investmentObjective | Text |  | Long-term income and capital growth from UK blue-c... |
| isAdvised | Yes/No |  | Yes |
| isin | Text |  | GB0007980591 |
| marketData | Complex Data |  | Complex object |
| notes | Text |  | Core UK equity holding for dividend income. Monito... |
| performance | Complex Data |  | Complex object |
| purchases | List of Complex Data |  | List with 2 item(s) |
| sales | List of Complex Data |  | List with 1 item(s) |
| sector | Selection |  | Complex object |
| sedol | Text |  | 0798059 |
| taxCalculation | Complex Data |  | Complex object |
| ticker | Text |  | BP.L |
| updatedAt | Date | When this record was last modified | 2026-02-16T16:30:00Z |
| updatedBy | Complex Data | User who last modified this record | Complex object |

#### Nested Field Groups

**adviserRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ADV001 |
| id | Text | Unique system identifier for this record | adviser-789 |
| name | Text | First name (given name) | Jane Doe |

**broker:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| accountNumber | Text |  | HL-12345678 |
| name | Text | First name (given name) | Hargreaves Lansdown |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Text | Unique system identifier for this record | client-123 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**country:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| alpha3 | Text |  | GBR |
| code | Text | Standard Occupational Classification (SOC) code | GB |
| display | Text |  | United Kingdom |

**createdBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

**currency:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**exchange:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | LSE |
| display | Text |  | London Stock Exchange |
| mic | Text | Whether the client is UK domiciled | XLON |

**factFindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Text | Unique system identifier for this record | factfind-123 |
| status | Text | Current status of the goal | INP |

**holdings:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| averagePurchasePrice | Currency Amount | Current age (calculated from date of birth) | Complex object |
| amount | Number | Amount spent | 4.25 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| currentPrice | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 5.15 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| amount | Number | Amount spent | 25750.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| priceDate | Date |  | 2026-02-16T16:00:00Z |
| quantity | Number |  | 5000 |
| totalCostBasis | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 21250.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**marketData:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| 52WeekHigh | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 5.85 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| 52WeekLow | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 4.15 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| ask | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 5.16 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| beta | Number |  | 1.15 |
| bid | Currency Amount | Unique system identifier for this record | Complex object |
| amount | Number | Amount spent | 5.14 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| close | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 5.15 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| eps | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.412 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| high | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 5.18 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| lastUpdated | Date |  | 2026-02-16T16:00:00Z |
| low | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 5.05 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| marketCap | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 95000000000 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| open | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 5.07 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| peRatio | Number |  | 12.5 |
| volume | Number |  | 12500000 |

**performance:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| annualizedReturn | Number |  | 5.41 |
| dayChange | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.08 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| dayChangePercentage | Number | Current age (calculated from date of birth) | 1.58 |
| dividendYield | Number | Unique system identifier for this record | 4.85 |
| realizedGain | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 1250.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| totalDividendsReceived | Currency Amount | Unique system identifier for this record | Complex object |
| amount | Number | Amount spent | 3750.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| totalGain | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 5750.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| totalReturn | Number |  | 27.06 |
| totalReturnWithDividends | Currency Amount | Unique system identifier for this record | Complex object |
| amount | Number | Amount spent | 9500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| totalReturnWithDividendsPercentage | Number | Unique system identifier for this record | 44.71 |
| unrealizedGain | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 4500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| unrealizedGainPercentage | Number | Current age (calculated from date of birth) | 21.18 |

**sector:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ENERGY |
| display | Text |  | Energy |
| subSector | Text |  | Oil & Gas Producers |

**taxCalculation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| capitalGainsAllowance | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 3000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| capitalGainsRealized | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 1250.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| capitalGainsUnrealized | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 4500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| costBasisMethod | Text |  | SECTION104 |
| dividendsAllowance | Currency Amount | Unique system identifier for this record | Complex object |
| amount | Number | Amount spent | 500.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| dividendsTaxable | Currency Amount | Unique system identifier for this record | Complex object |
| amount | Number | Amount spent | 3250.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| section104Pool | Complex Data |  | Complex object |
| averageCostPerShare | Currency Amount | Current age (calculated from date of birth) | Complex object |
| amount | Number | Amount spent | 4.25 |
| currency | Selection |  | Complex object |
| pooledCost | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 21250.0 |
| currency | Selection |  | Complex object |
| quantity | Number |  | 5000 |
| taxYear | Text |  | 2025/2026 |
| taxableCGT | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |
| totalCapitalGains | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 5750.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**updatedBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

---

## 13.11 IdentityVerification Contract
### Overview
The `IdentityVerification` contract represents identity verification status with KYC and AML checks.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| addressVerification | Complex Data |  | Complex object |
| amlChecks | Complex Data |  | Complex object |
| biometricVerification | Complex Data |  | Complex object |
| clientRef | Reference Link |  | Complex object |
| consentDate | Date |  | 2026-02-10T14:00:00Z |
| consentGiven | Yes/No |  | Yes |
| consentReference | Text |  | consent-123 |
| createdAt | Date | When this record was created in the system | 2026-02-10T14:30:00Z |
| createdBy | Complex Data | User who created this record | Complex object |
| dataProtectionNoticeDate | Date | GDPR consent, data protection, and privacy management | 2026-02-10T14:00:00Z |
| dataProtectionNoticeProvided | Yes/No | Unique system identifier for this record | Yes |
| dataProtectionNoticeVersion | Text | GDPR consent, data protection, and privacy management | 2.1 |
| daysUntilExpiry | Number |  | 365 |
| documents | List of Complex Data |  | List with 2 item(s) |
| factFindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Text | Unique system identifier for this record | idverify-987 |
| identityProvider | Complex Data | Unique system identifier for this record | Complex object |
| isExpired | Yes/No |  | No |
| nextReviewDate | Date |  | 2027-02-10 |
| notes | Text |  | Enhanced verification completed successfully. All ... |
| regulatoryCompliance | Complex Data |  | Complex object |
| reviewFrequency | Text | How often (Monthly, Annual, etc.) | ANNUAL |
| riskAssessment | Complex Data |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-10T15:00:00Z |
| updatedBy | Complex Data | User who last modified this record | Complex object |
| verificationDate | Date |  | 2026-02-10T14:30:00Z |
| verificationExpiryDate | Date |  | 2027-02-10 |
| verificationHistory | List of Complex Data |  | List with 3 item(s) |
| verificationIpAddress | Text |  | 192.168.1.100 |
| verificationLevel | Text |  | ENHANCED |
| verificationStatus | Text | Current status of the goal | VERIFIED |
| verificationType | Text |  | KYC_AML |
| verificationUserAgent | Text | Current age (calculated from date of birth) | Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb... |
| verifiedAt | Date |  | 2026-02-10T14:30:00Z |
| verifiedBy | Complex Data |  | Complex object |

#### Nested Field Groups

**addressVerification:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| addressMatchScore | Number |  | 100 |
| addressVerified | Yes/No |  | Yes |
| verificationDate | Date |  | 2026-02-10T14:30:00Z |
| verificationMethod | Text |  | DOCUMENT |
| verifiedAddress | Complex Data |  | Complex object |
| city | Text | City/town | London |
| country | Text | Country | GB |
| line1 | Text | Address line 1 | 123 Main Street |
| line2 | Text | Address line 2 | Apartment 4B |
| postcode | Text | Postcode/ZIP code | SW1A 1AA |

**amlChecks:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adverseMediaScreening | Complex Data |  | Complex object |
| adverseMediaChecked | Yes/No |  | Yes |
| adverseMediaMatches | List |  | Empty list |
| checkDate | Date |  | 2026-02-10T14:30:00Z |
| status | Text | Current status of the goal | CLEAR |
| amlCheckDate | Date |  | 2026-02-10T14:30:00Z |
| amlProvider | Selection | Unique system identifier for this record | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | WORLDCHECK |
| display | Text |  | World-Check (Refinitiv) |
| website | Text |  | https://www.refinitiv.com/en/products/world-check-... |
| amlProviderReference | Text | Unique system identifier for this record | WC-2026-02-987654321 |
| amlStatus | Text | Current status of the goal | CLEAR |
| pepScreening | Complex Data |  | Complex object |
| checkDate | Date |  | 2026-02-10T14:30:00Z |
| isPep | Yes/No |  | No |
| pepCategory | Text | Expenditure category (Housing, Transport, Food, etc.) | None |
| pepRelationship | Text |  | None |
| pepSource | Text |  | None |
| status | Text | Current status of the goal | NOT_PEP |
| sanctionsScreening | Complex Data |  | Complex object |
| checkDate | Date |  | 2026-02-10T14:30:00Z |
| listsChecked | List of str |  | List with 5 item(s) |
| matches | List |  | Empty list |
| status | Text | Current status of the goal | CLEAR |
| watchlistScreening | Complex Data |  | Complex object |
| checkDate | Date |  | 2026-02-10T14:30:00Z |
| matches | List |  | Empty list |
| status | Text | Current status of the goal | CLEAR |
| watchlistsChecked | List of str |  | List with 4 item(s) |

**biometricVerification:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| faceMatch | Complex Data |  | Complex object |
| confidence | Number | Unique system identifier for this record | 99.5 |
| matchDate | Date |  | 2026-02-10T14:30:00Z |
| status | Text | Current status of the goal | MATCHED |
| livenessCheck | Complex Data |  | Complex object |
| checkDate | Date |  | 2026-02-10T14:30:00Z |
| confidence | Number | Unique system identifier for this record | 98.2 |
| status | Text | Current status of the goal | PASSED |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Text | Unique system identifier for this record | client-123 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**createdBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

**factFindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Text | Unique system identifier for this record | factfind-123 |
| status | Text | Current status of the goal | INP |

**identityProvider:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| provider | Selection | Financial institution or provider | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | ONFIDO |
| display | Text |  | Onfido |
| website | Text |  | https://onfido.com |
| providerCheckId | Text | Unique system identifier for this record | chk_abc123def456ghi789 |
| providerDecision | Text | Unique system identifier for this record | CLEAR |
| providerReference | Text | Unique system identifier for this record | ONFIDO-CHK-123456789 |
| providerReportUrl | Text | Unique system identifier for this record | https://dashboard.onfido.com/checks/chk_abc123def4... |
| providerResponseDate | Date | Unique system identifier for this record | 2026-02-10T14:30:00Z |
| providerScore | Number | Unique system identifier for this record | 98 |

**regulatoryCompliance:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| fcaCompliance | Complex Data |  | Complex object |
| complianceDate | Date |  | 2026-02-10 |
| isCompliant | Yes/No |  | Yes |
| notes | Text |  | Compliant with FCA systems and controls requiremen... |
| regulationReference | Text |  | FCA Handbook SYSC 3.2 |
| gdprCompliance | Complex Data |  | Complex object |
| complianceDate | Date |  | 2026-02-10 |
| isCompliant | Yes/No |  | Yes |
| lawfulBasis | Text |  | Legal obligation |
| regulationReference | Text |  | GDPR Article 6(1)(c) |
| kycCompliance | Complex Data |  | Complex object |
| complianceDate | Date |  | 2026-02-10 |
| isCompliant | Yes/No |  | Yes |
| notes | Text |  | Compliant with JMLSG KYC guidance |
| standardReference | Text |  | JMLSG Guidance Part I Chapter 5 |
| mlrCompliance | Complex Data |  | Complex object |
| complianceDate | Date |  | 2026-02-10 |
| isCompliant | Yes/No |  | Yes |
| notes | Text |  | Compliant with UK Money Laundering Regulations 201... |
| regulationReference | Text |  | Money Laundering Regulations 2017 |

**riskAssessment:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| overallRiskRating | Text |  | LOW |
| riskFactors | List of Complex Data |  | List with 3 item(s) |
| riskNotes | Text |  | Low risk client with clear AML checks, verified id... |
| riskScore | Number |  | 15 |
| riskScoreMax | Number |  | 100 |

**updatedBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

**verifiedBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |
| role | Text |  | Compliance Officer |

---

## 13.12 Consent Contract
### Overview
The `Consent` contract represents GDPR consent tracking with purpose-specific consents and audit trail.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| audit | Complex Data |  | Complex object |
| clientRef | Reference Link |  | Complex object |
| complianceChecks | Complex Data |  | Complex object |
| consentChannel | Text |  | WEB |
| consentExpiryDate | Date |  | 2028-02-10 |
| consentGivenDate | Date |  | 2026-02-10T14:00:00Z |
| consentMethod | Text |  | EXPLICIT |
| consentPurpose | Text |  | DATA_PROCESSING |
| consentPurposeDescription | Text | Description of the goal | Processing of personal and financial data for the ... |
| consentRenewal | Complex Data |  | Complex object |
| consentStatus | Text | Current status of the goal | GIVEN |
| consentText | Text |  | I consent to the collection, storage, and processi... |
| consentVersion | Text |  | 2.1 |
| consentWithdrawnDate | Text |  | None |
| createdAt | Date | When this record was created in the system | 2026-02-10T14:00:00Z |
| createdBy | Complex Data | User who created this record | Complex object |
| dataProcessing | Complex Data |  | Complex object |
| dataSubjectRights | Complex Data |  | Complex object |
| daysUntilExpiry | Number |  | 730 |
| documents | List of Complex Data |  | List with 2 item(s) |
| dsarHistory | List of Complex Data |  | List with 1 item(s) |
| factFindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Text | Unique system identifier for this record | consent-555 |
| isActive | Yes/No |  | Yes |
| isExpired | Yes/No |  | No |
| lawfulBasis | Text |  | CONSENT |
| lawfulBasisDetails | Text |  | Consent freely given for data processing under GDP... |
| marketingConsent | Complex Data |  | Complex object |
| notes | Text |  | Initial consent obtained during client onboarding.... |
| privacyPolicy | Complex Data |  | Complex object |
| profilingConsent | Complex Data |  | Complex object |
| relatedConsents | List of Complex Data |  | List with 2 item(s) |
| specialCategoryData | Complex Data | Expenditure category (Housing, Transport, Food, etc.) | Complex object |
| thirdPartySharing | Complex Data |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-10T14:30:00Z |
| updatedBy | Complex Data | User who last modified this record | Complex object |

#### Nested Field Groups

**audit:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| consentEvidence | Complex Data | Unique system identifier for this record | Complex object |
| evidenceTimestamp | Date | Unique system identifier for this record | 2026-02-10T14:00:00Z |
| evidenceType | Text | Unique system identifier for this record | CHECKBOX |
| evidenceUrl | Text | Unique system identifier for this record | /api/v2/consent-evidence/consent-555 |
| witnessRequired | Yes/No |  | No |
| consentRecordedAt | Date |  | 2026-02-10T14:00:00Z |
| consentRecordedBy | Complex Data |  | Complex object |
| id | Text | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |
| role | Text |  | Financial Adviser |
| deviceType | Text |  | Desktop |
| ipAddress | Text |  | 192.168.1.100 |
| location | Complex Data |  | Complex object |
| city | Text | City/town | London |
| country | Text | Country | United Kingdom |
| userAgent | Text | Current age (calculated from date of birth) | Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWeb... |
| verificationMethod | Text |  | EMAIL_VERIFIED |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Text | Unique system identifier for this record | client-123 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**complianceChecks:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| fcaComplianceDate | Date |  | 2026-02-10 |
| fcaCompliant | Yes/No |  | Yes |
| gdprComplianceDate | Date |  | 2026-02-10 |
| gdprCompliant | Yes/No |  | Yes |
| lastComplianceReview | Date |  | 2026-02-10 |
| nextComplianceReview | Date |  | 2027-02-10 |
| peComplianceDate | Date |  | 2026-02-10 |
| pecompliant | Yes/No |  | Yes |

**consentRenewal:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| renewalDate | Date |  | 2028-02-10 |
| renewalFrequency | Text | How often (Monthly, Annual, etc.) | BIENNIAL |
| renewalHistory | List of Complex Data |  | List with 1 item(s) |
| renewalReminderDate | Text |  | None |
| renewalReminderSent | Yes/No |  | No |
| renewalRequired | Yes/No |  | Yes |

**createdBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

**dataProcessing:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| dataCategories | List of Complex Data |  | List with 3 item(s) |
| dataRetentionPeriod | Complex Data |  | Complex object |
| reason | Text |  | Regulatory requirement - FCA indefinite retention ... |
| unit | Text |  | years |
| value | Number | The contact value (email address, phone number, etc.) | 7 |
| dataSharedWith | List of Complex Data |  | List with 3 item(s) |
| processingActivities | List of Complex Data |  | List with 3 item(s) |

**dataSubjectRights:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| rightToAccess | Complex Data |  | Complex object |
| lastRequestDate | Text |  | None |
| requestsReceived | Number |  | 0 |
| rightExplained | Yes/No |  | Yes |
| rightToDataPortability | Complex Data |  | Complex object |
| lastRequestDate | Text |  | None |
| requestsReceived | Number |  | 0 |
| rightExplained | Yes/No |  | Yes |
| rightToErasure | Complex Data |  | Complex object |
| lastRequestDate | Text |  | None |
| limitations | Text |  | Data may be retained for regulatory compliance (FC... |
| requestsReceived | Number |  | 0 |
| rightExplained | Yes/No |  | Yes |
| rightToObject | Complex Data |  | Complex object |
| lastRequestDate | Text |  | None |
| requestsReceived | Number |  | 0 |
| rightExplained | Yes/No |  | Yes |
| rightToRectification | Complex Data |  | Complex object |
| lastRequestDate | Text |  | None |
| requestsReceived | Number |  | 0 |
| rightExplained | Yes/No |  | Yes |
| rightToRestriction | Complex Data |  | Complex object |
| lastRequestDate | Text |  | None |
| requestsReceived | Number |  | 0 |
| rightExplained | Yes/No |  | Yes |
| rightToWithdrawConsent | Complex Data |  | Complex object |
| canWithdraw | Yes/No |  | Yes |
| rightExplained | Yes/No |  | Yes |
| withdrawalImpact | Text |  | May affect ability to provide advice services |
| withdrawalMethod | Text |  | Email, phone, or written request |
| rightsInformed | Yes/No |  | Yes |
| rightsInformedDate | Date |  | 2026-02-10T14:00:00Z |

**factFindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Text | Unique system identifier for this record | factfind-123 |
| status | Text | Current status of the goal | INP |

**marketingConsent:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasMarketingConsent | Yes/No |  | Yes |
| marketingChannels | List of Complex Data |  | List with 4 item(s) |
| marketingConsentDate | Date |  | 2026-02-10T14:00:00Z |
| marketingFrequency | Text | How often (Monthly, Annual, etc.) | MONTHLY |
| marketingInterests | List of str |  | List with 4 item(s) |
| thirdPartyMarketing | Complex Data |  | Complex object |
| consentDate | Text |  | None |
| isConsented | Yes/No |  | No |

**privacyPolicy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| privacyNoticeMethod | Text |  | ONLINE |
| privacyNoticeProvided | Yes/No | Unique system identifier for this record | Yes |
| privacyPolicyAcceptedDate | Date |  | 2026-02-10T14:00:00Z |
| privacyPolicyEffectiveDate | Date |  | 2026-01-01 |
| privacyPolicyLastUpdated | Date |  | 2026-01-01 |
| privacyPolicyUrl | Text |  | https://www.example-advisor.com/privacy-policy |
| privacyPolicyVersion | Text |  | 2.1 |

**profilingConsent:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| automatedDecisionMaking | Complex Data |  | Complex object |
| description | Text | Description of the goal | Automated risk assessment questionnaire scoring |
| humanReview | Yes/No |  | Yes |
| isUsed | Yes/No |  | Yes |
| hasProfilingConsent | Yes/No |  | Yes |
| profilingConsentDate | Date |  | 2026-02-10T14:00:00Z |
| profilingPurpose | Text |  | Risk profiling and investment suitability assessme... |

**specialCategoryData:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| isSpecialCategory | Yes/No | Expenditure category (Housing, Transport, Food, etc.) | No |
| lawfulBasisSpecialCategory | Text | Expenditure category (Housing, Transport, Food, etc.) | None |
| specialCategoryTypes | List | Expenditure category (Housing, Transport, Food, etc.) | Empty list |

**thirdPartySharing:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasThirdPartyConsent | Yes/No |  | Yes |
| thirdParties | List of str |  | List with 3 item(s) |
| thirdPartyConsentDate | Date |  | 2026-02-10T14:00:00Z |

**updatedBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

---

## 13.17 Asset Contract
### Overview
The `Asset` contract represents a client's asset (property, business, cash, investments, etc.) with ownership, valuation, and tax planning information.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementRef | Reference Link |  | Complex object |
| assetType | Text |  | PROPERTY |
| createdAt | Date | When this record was created in the system | 2026-02-01T10:00:00Z |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| description | Text | Description of the goal | Primary Residence - 123 Main Street |
| dividends | Complex Data | Unique system identifier for this record | Complex object |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 1234 |
| incomeRef | Reference Link |  | Complex object |
| isBusinessAssetDisposalRelief | Yes/No |  | No |
| isBusinessReliefQualifying | Yes/No |  | No |
| isFreeFromInheritanceTax | Yes/No |  | No |
| isHolding | Yes/No |  | No |
| isVisibleToClient | Yes/No |  | Yes |
| notes | Text |  | Rental property - managed by external agent |
| originalValue | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| ownership | Complex Data | Who owns this arrangement | Complex object |
| propertyRef | Reference Link |  | Complex object |
| purchasedOn | Date |  | 2024-05-10 |
| rentalExpenses | Currency Amount |  | Complex object |
| rnrbEligibility | Text |  | Not Eligible |
| updatedAt | Date | When this record was last modified | 2026-02-15T14:30:00Z |
| valuationBasis | Text |  | Comparable Sales |
| valuedOn | Date | The contact value (email address, phone number, etc.) | 2026-01-15 |

#### Nested Field Groups

**arrangementRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 1234 |

**currentValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 450000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**dividends:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| owners | List of Complex Data | Who owns this arrangement | List with 1 item(s) |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**incomeRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 1234 |

**originalValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 350000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**ownership:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| owners | List of Complex Data | Who owns this arrangement | List with 2 item(s) |
| ownershipType | Text | Who owns this arrangement | JOINT |

**propertyRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 1234 |

**rentalExpenses:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 1200.0 |
| currency | Text |  | GBP |

---

## 13.18 Liability Contract
### Overview
The `Liability` contract represents a client's debt obligation (mortgage, loan, credit card, maintenance/alimony, etc.) with repayment details and protection coverage tracking.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amountOutstanding | Currency Amount | Amount spent | Complex object |
| consolidate | Yes/No | Unique system identifier for this record | No |
| createdAt | Date | When this record was created in the system | 2026-01-15T09:00:00Z |
| creditLimit | Currency Amount |  | Complex object |
| description | Text | Description of the goal | Primary Residence Mortgage - 123 Main Street |
| earlyRedemptionCharge | Currency Amount |  | Complex object |
| endDate | Date | Employment end date (null if current) | 2040-06-01 |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| howWillLiabilityBeRepaid | Text | Unique system identifier for this record | None |
| id | Number | Unique system identifier for this record | 789 |
| interestRate | Number |  | 3.5 |
| isGuarantorMortgage | Yes/No | Current age (calculated from date of birth) | No |
| isToBeRepaid | Yes/No | Unique system identifier for this record | No |
| lender | Text |  | Nationwide Building Society |
| liabilityAccountNumber | Text |  | MTG-123456 |
| liabilityCategory | Text | Expenditure category (Housing, Transport, Food, etc.) | MAIN_RESIDENCE |
| linkedAssetRef | Reference Link |  | Complex object |
| loanTermYears | Number |  | 25 |
| originalLoanAmount | Currency Amount | Amount spent | Complex object |
| owner | Complex Data | Who owns this arrangement | Complex object |
| paymentAmount | Currency Amount | Amount spent | Complex object |
| protected | Text |  | LIFE_AND_CIC |
| protectionArrangementRef | Reference Link |  | Complex object |
| rateType | Text |  | FIXED |
| repaymentOrInterestOnly | Text |  | REPAYMENT |
| updatedAt | Date | When this record was last modified | 2026-02-10T11:30:00Z |

#### Nested Field Groups

**amountOutstanding:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 180000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**creditLimit:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 0.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**earlyRedemptionCharge:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 5000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**linkedAssetRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 1234 |

**originalLoanAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 250000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**owner:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientRef | Reference Link |  | Complex object |
| id | Text | Unique system identifier for this record | client-123 |
| name | Text | First name (given name) | Bob Byblik |

**paymentAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 1200.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**protectionArrangementRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 555 |

---

## 13.19 Employment Contract

### Business Purpose

Represents current or historical employment for a client, including salary, benefits, and workplace pension details.

### Key Features

- Tracks employment dates and status
- Records salary, bonus, and commission
- Links to workplace pension schemes
- Supports multiple employments (current and historical)

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| address | Complex Data | List of all addresses for this client (current and historical) | Complex object |
| client | Complex Data | Client reference number assigned by your organization | Complex object |
| continuousEmploymentMonths | Number |  | 132 |
| employer | Text | Name of the employer | Acme Corporation Ltd |
| employmentBusinessType | Text |  | None |
| employmentStatus | Text | Current employment status | Employed |
| employmentStatusDescription | Text | Current employment status | Full-time permanent employee |
| endsOn | Text |  | None |
| highestTaxRate | Text |  | 40% |
| id | Number | Unique system identifier for this record | 567 |
| inProbation | Yes/No |  | No |
| incomesHref | Text |  | /api/v2/factfinds/679/clients/346/incomes?filter=e... |
| industryType | Text |  | Information Technology |
| intendedRetirementAge | Number | Current age (calculated from date of birth) | 67 |
| isCurrentEmployment | Yes/No |  | Yes |
| occupation | Text | Current occupation/job title | Senior Software Engineer |
| probationPeriodInMonths | Text |  | None |
| selfEmployedIncome | Text |  | None |
| startsOn | Date |  | 2015-03-01 |

#### Nested Field Groups

**address:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| country | Complex Data | Country | Complex object |
| isoCode | Text |  | GB |
| name | Text | First name (given name) | United Kingdom |
| county | Complex Data | County/region | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GB-LND |
| name | Text | First name (given name) | London |
| line1 | Text | Address line 1 | Tech Park Building 5 |
| line2 | Text | Address line 2 | Silicon Way |
| line3 | Text | Address line 3 | None |
| line4 | Text | Address line 4 | None |
| locality | Text |  | London |
| postalCode | Text |  | EC1A 1BB |

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 346 |

---

### Relationships

This contract connects to:

- Belongs to a Client
- Belongs to a FactFind
- May link to workplace Pension arrangements

### Business Validation Rules

- salary must be >= 0
- startDate is required
- endDate must be after startDate (if provided)
- Current employment must have endDate=null

---


## 13.20 Budget Contract
### Overview
The `Budget` contract represents a client's budgeted/planned monthly expenditure by category.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Currency Amount | Amount spent | Complex object |
| category | Text | Expenditure category (Housing, Transport, Food, etc.) | Housing |
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-01-10T09:00:00Z |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 445 |
| notes | Text |  | Monthly mortgage payment and council tax |
| updatedAt | Date | When this record was last modified | 2026-02-05T10:15:00Z |

#### Nested Field Groups

**amount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 1500.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

---

## 13.21 Expenditure Contract

### Business Purpose

Represents the client's regular spending and outgoings, used for budget planning and affordability assessments.

### Key Features

- Categorizes spending (housing, transport, food, etc.)
- Distinguishes essential vs discretionary spending
- Supports different frequencies (monthly, annual)
- Used in affordability calculations

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-01-15T11:00:00Z |
| expenses | List of Complex Data |  | List with 2 item(s) |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 667 |
| includeInAffordability | Yes/No |  | Yes |
| isDetailed | Yes/No |  | Yes |
| notes | Text |  | Monthly expenditure based on bank statements revie... |
| totalMonthlyExpenditure | Currency Amount |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-08T14:30:00Z |

#### Nested Field Groups

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**totalMonthlyExpenditure:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 3250.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

---

### Relationships

This contract connects to:

- Belongs to a Client
- Belongs to a FactFind
- Used by Affordability Assessment
- Part of Budget calculations

### Business Validation Rules

- amount must be > 0
- frequency is required
- category is required

---


## 13.22 Expense Contract
### Overview
The `Expense` contract represents a single expense line item within an expenditure aggregate.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Currency Amount | Amount spent | Complex object |
| category | Text | Expenditure category (Housing, Transport, Food, etc.) | MORTGAGE |
| createdAt | Date | When this record was created in the system | 2026-01-15T11:00:00Z |
| description | Text | Description of the goal | Primary residence mortgage payment |
| expenditureRef | Reference Link |  | Complex object |
| frequency | Text | How often (Monthly, Annual, etc.) | MONTHLY |
| id | Number | Unique system identifier for this record | 1001 |
| includeInAffordability | Yes/No |  | Yes |
| monthlyAmount | Currency Amount | Amount spent | Complex object |
| notes | Text |  | Fixed rate until June 2027 |
| updatedAt | Date | When this record was last modified | 2026-02-08T14:30:00Z |

#### Nested Field Groups

**amount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 1200.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**expenditureRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 667 |

**monthlyAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 1200.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

---

## 13.23 Credit History Contract
### Overview
The `CreditHistory` contract represents a client's credit history items including credit scores, payment history, and adverse credit events.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adverseCreditEvents | List |  | Empty list |
| bankruptcyHistory | Yes/No |  | No |
| ccjCount | Number |  | 0 |
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-01-15T10:00:00Z |
| creditScore | Complex Data |  | Complex object |
| defaultCount | Number |  | 0 |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| hasAdverseCredit | Yes/No |  | No |
| id | Number | Unique system identifier for this record | 334 |
| ivaHistory | Yes/No |  | No |
| missedPayments | Complex Data |  | Complex object |
| mortgageSuitability | Complex Data | Current age (calculated from date of birth) | Complex object |
| notes | Text |  | Excellent credit history - eligible for best mortg... |
| updatedAt | Date | When this record was last modified | 2026-01-15T10:00:00Z |

#### Nested Field Groups

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**creditScore:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| checkedDate | Date |  | 2026-01-15 |
| maxScore | Number |  | 999 |
| provider | Text | Financial institution or provider | Experian |
| rating | Text |  | Excellent |
| score | Number |  | 780 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**missedPayments:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| last12Months | Number |  | 0 |
| last6Years | Number |  | 0 |

**mortgageSuitability:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factors | List of str |  | List with 3 item(s) |
| isEligible | Yes/No |  | Yes |

---

## 13.24 Property Detail Contract
### Overview
The `PropertyDetail` contract represents detailed property information including physical characteristics, construction details, and tenure information.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| address | Complex Data | List of all addresses for this client (current and historical) | Complex object |
| builderName | Text |  | None |
| constructionNotes | Text |  | Victorian cottage with modern renovation |
| constructionType | Text |  | BRICK_AND_TILE |
| createdAt | Date | When this record was created in the system | 2026-01-15T10:00:00Z |
| id | Number | Unique system identifier for this record | 1 |
| isExLocalAuthority | Yes/No |  | No |
| isNHBCCertificateCovered | Yes/No |  | No |
| isNewBuild | Yes/No |  | No |
| isOtherCertificateCovered | Yes/No |  | Yes |
| leaseholdEndsOn | Text |  | None |
| numberOfBedrooms | Number |  | 4 |
| numberOfOutbuildings | Number |  | 1 |
| otherCertificateNotes | Text |  | Grade II Listed Building - Conservation Area |
| propertyStatus | Text | Current status of the goal | RESIDENTIAL |
| propertyType | Text | Type of property (Residential, Buy-to-Let, Commercial, etc.) | DETACHED |
| roofConstructionType | Text |  | PITCHED_SLATE_TILES |
| tenureType | Text |  | Freehold |
| updatedAt | Date | When this record was last modified | 2026-02-10T14:20:00Z |
| yearBuilt | Number |  | 1890 |

#### Nested Field Groups

**address:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| country | Complex Data | Country | Complex object |
| isoCode | Text |  | GB |
| name | Text | First name (given name) | United Kingdom |
| county | Complex Data | County/region | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GB-GLS |
| name | Text | First name (given name) | Gloucestershire |
| line1 | Text | Address line 1 | Rose Cottage |
| line2 | Text | Address line 2 | Church Lane |
| line3 | Text | Address line 3 | None |
| line4 | Text | Address line 4 | None |
| locality | Text |  | Cotswolds Village |
| postalCode | Text |  | GL54 2AB |

---

## 13.25 Business Asset Contract
### Overview
The `BusinessAsset` contract represents detailed business asset information including valuation basis, dividend tracking, and tax relief eligibility.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| assetRef | Reference Link |  | Complex object |
| businessName | Text |  | Smith & Co Limited |
| businessType | Text |  | LIMITED_COMPANY |
| companyNumber | Text |  | 12345678 |
| createdAt | Date | When this record was created in the system | 2026-01-10T09:00:00Z |
| dividendPolicy | Complex Data | Unique system identifier for this record | Complex object |
| exitStrategy | Complex Data |  | Complex object |
| financials | Complex Data |  | Complex object |
| id | Number | Unique system identifier for this record | 555 |
| incorporationDate | Date | Date the company was incorporated | 2018-03-20 |
| industry | Text |  | SOFTWARE |
| notes | Text |  | Profitable software consultancy - considering expa... |
| ownershipStructure | Complex Data | Who owns this arrangement | Complex object |
| taxReliefs | Complex Data |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-01T11:00:00Z |
| valuationBasis | Text |  | NET_ASSET_VALUE |
| valuations | List of Complex Data |  | List with 1 item(s) |

#### Nested Field Groups

**assetRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 1235 |

**dividendPolicy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| annualDividend | Currency Amount | Unique system identifier for this record | Complex object |
| amount | Number | Amount spent | 60000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| monthlyDividend | Currency Amount | Unique system identifier for this record | Complex object |
| amount | Number | Amount spent | 5000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| paymentSchedule | Text |  | MONTHLY |

**exitStrategy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| exitMethod | Text |  | Sale to Management Team |
| expectedSaleValue | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| amount | Number | Amount spent | 500000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| plannedExitDate | Date |  | 2035-03-20 |

**financials:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| annualProfit | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 150000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| annualTurnover | Currency Amount | Annual turnover/revenue | Complex object |
| amount | Number | Amount spent | 500000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| financialYearEnd | Date | Financial year end date | 2025-12-31 |
| netAssets | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 250000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**ownershipStructure:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| ownedShares | Number |  | 100 |
| ownershipPercentage | Number | Current age (calculated from date of birth) | 100.0 |
| shareClass | Text |  | Ordinary |
| totalShares | Number |  | 100 |

**taxReliefs:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| businessAssetDisposalRelief | Yes/No |  | Yes |
| businessReliefQualifying | Yes/No |  | Yes |
| ihtReliefPercentage | Number | Current age (calculated from date of birth) | 100 |
| notes | Text |  | Qualifying trading company - 100% IHT relief after... |

---

## 13.26 Notes Contract
### Overview
The `Notes` contract represents a note attached to a fact find entity using a unified discriminator pattern.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| attachments | List of Complex Data |  | List with 1 item(s) |
| content | Text |  | Discussed recent property valuation with client. M... |
| contentType | Text |  | text/plain |
| createdAt | Date | When this record was created in the system | 2026-02-10T14:00:00Z |
| createdBy | Complex Data | User who created this record | Complex object |
| entityRef | Reference Link |  | Complex object |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 888 |
| isSystemGenerated | Yes/No |  | No |
| isVisibleToClient | Yes/No |  | No |
| noteDiscriminator | Text |  | ASSET_NOTES |
| subject | Text |  | Property Valuation Discussion |
| updatedAt | Date | When this record was last modified | 2026-02-10T14:00:00Z |

#### Nested Field Groups

**createdBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | adviser-789 |
| name | Text | First name (given name) | Sarah Johnson |

**entityRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 1234 |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Asset |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

---

## 13.27 Dependant Contract

### Business Purpose

Represents a person who is financially dependent on the client, such as children or elderly relatives.

### Key Features

- Tracks dependent's age and relationship
- Records financial dependency status
- Identifies special needs or disabilities
- Used for protection needs analysis

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| age | Number | Current age (calculated from date of birth) | 10 |
| clients | List of Complex Data | Client segment classification (A, B, C, D for prioritization) | List with 2 item(s) |
| createdAt | Date | When this record was created in the system | 2026-01-05T10:00:00Z |
| dateOfBirth | Date | Date of birth | 2015-08-20 |
| dependencyDetails | Complex Data |  | Complex object |
| educationDetails | Complex Data |  | Complex object |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| firstName | Text | First name (given name) | Emily |
| fullName | Text | Complete formatted name including title | Emily Rose Smith |
| gender | Text | Gender (M=Male, F=Female, O=Other, X=Prefer not to say) | F |
| healthDetails | Complex Data |  | Complex object |
| id | Number | Unique system identifier for this record | 999 |
| isFinanciallyDependent | Yes/No |  | Yes |
| lastName | Text | Last name (surname/family name) | Smith |
| livingArrangements | Complex Data |  | Complex object |
| middleNames | Text | Middle name(s) | Rose |
| notes | Text |  | Plans to attend university - considering STEM subj... |
| relationship | Text |  | CHILD |
| updatedAt | Date | When this record was last modified | 2026-02-01T09:30:00Z |

#### Nested Field Groups

**dependencyDetails:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| annualCost | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 9600.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| estimatedDependencyEndAge | Number | Current age (calculated from date of birth) | 21 |
| estimatedDependencyEndDate | Date | Employment end date (null if current) | 2036-08-20 |
| monthlyCost | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 800.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**educationDetails:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| currentEducationLevel | Text |  | Primary School |
| estimatedEducationCosts | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 50000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| isInPrivateEducation | Yes/No |  | No |
| plannedHigherEducation | Yes/No |  | Yes |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**healthDetails:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasSpecialNeeds | Yes/No |  | No |
| healthNotes | Text |  | None |
| requiresOngoingCare | Yes/No |  | No |

**livingArrangements:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| custodyArrangement | Text |  | Full Custody |
| livesWithClient | Yes/No |  | Yes |

---

### Relationships

This contract connects to:

- Belongs to a Client
- Belongs to a FactFind
- Referenced in protection needs calculations

### Business Validation Rules

- relationship is required
- dateOfBirth is required
- age calculated from dateOfBirth

---


## 13.28 Income Changes Contract
### Overview
The `IncomeChanges` contract represents anticipated changes to a client's income, used for affordability and cash flow planning.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| changeAmount | Currency Amount | Amount spent | Complex object |
| changePercentage | Number | Current age (calculated from date of birth) | 13.33 |
| changeType | Text |  | INCREASE |
| clientRef | Reference Link |  | Complex object |
| confidenceLevel | Text | Unique system identifier for this record | HIGH |
| createdAt | Date | When this record was created in the system | 2026-02-15T10:00:00Z |
| currentAmount | Currency Amount | Amount spent | Complex object |
| description | Text | Description of the goal | Salary increase following promotion to Senior Engi... |
| effectiveDate | Date |  | 2026-04-01 |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 345 |
| impactOnAffordability | Complex Data |  | Complex object |
| incomeRef | Reference Link |  | Complex object |
| isConfirmed | Yes/No |  | Yes |
| newAmount | Currency Amount | Amount spent | Complex object |
| notes | Text |  | Promotion confirmed by employer - effective from A... |
| updatedAt | Date | When this record was last modified | 2026-02-15T10:00:00Z |

#### Nested Field Groups

**changeAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 10000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**currentAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 75000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**impactOnAffordability:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| improvedAffordability | Yes/No |  | Yes |
| monthlyImpact | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 625.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**incomeRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 890 |

**newAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 85000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

---

## 13.29 Expenditure Changes Contract
### Overview
The `ExpenditureChanges` contract represents anticipated changes to a client's expenditure, used for affordability and cash flow planning.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| changeAmount | Currency Amount | Amount spent | Complex object |
| changePercentage | Number | Current age (calculated from date of birth) | -100.0 |
| changeType | Text |  | CEASE |
| clientRef | Reference Link |  | Complex object |
| confidenceLevel | Text | Unique system identifier for this record | HIGH |
| createdAt | Date | When this record was created in the system | 2026-02-18T11:00:00Z |
| currentAmount | Currency Amount | Amount spent | Complex object |
| description | Text | Description of the goal | Mortgage will be paid off |
| effectiveDate | Date |  | 2027-06-01 |
| expenseRef | Reference Link |  | Complex object |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 456 |
| impactOnAffordability | Complex Data |  | Complex object |
| isConfirmed | Yes/No |  | Yes |
| newAmount | Currency Amount | Amount spent | Complex object |
| notes | Text |  | Mortgage term ends June 2027 - confirmed with lend... |
| updatedAt | Date | When this record was last modified | 2026-02-18T11:00:00Z |

#### Nested Field Groups

**changeAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | -1200.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**currentAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 1200.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**expenseRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 1001 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**impactOnAffordability:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| improvedAffordability | Yes/No |  | Yes |
| monthlyImpact | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 1200.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**newAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 0.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

---

## 13.30 Affordability Assessment Contract

### Business Purpose

Evaluates the client's ability to afford financial commitments such as mortgages or regular investment contributions.

### Key Features

- Calculates disposable income
- Applies stress tests for interest rate changes
- Checks against regulatory lending criteria
- Provides affordability verdict

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| affordabilityCalculations | Complex Data |  | Complex object |
| assessmentDate | Date |  | 2026-02-19 |
| assessmentType | Text |  | MORTGAGE_AFFORDABILITY |
| clients | List of Complex Data | Client segment classification (A, B, C, D for prioritization) | List with 2 item(s) |
| createdAt | Date | When this record was created in the system | 2026-02-19T14:30:00Z |
| expenditureAnalysis | Complex Data |  | Complex object |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 1111 |
| incomeAnalysis | Complex Data |  | Complex object |
| proposedMortgage | Complex Data | Current age (calculated from date of birth) | Complex object |
| recommendation | Complex Data |  | Complex object |
| regulatoryCompliance | Complex Data |  | Complex object |
| stressTesting | Complex Data |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-19T14:30:00Z |

#### Nested Field Groups

**affordabilityCalculations:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| affordabilityRatio | Number |  | 24.56 |
| debtToIncomeRatio | Number |  | 37.5 |
| isAffordable | Yes/No |  | Yes |
| loanToIncomeMultiple | Number |  | 3.68 |
| surplusIncome | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 1471.67 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**expenditureAnalysis:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| discretionaryExpenditure | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 450.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| essentialExpenditure | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 2800.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| existingCreditCommitments | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 500.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| totalMonthlyExpenditure | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 3250.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**incomeAnalysis:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| includedIncomeSources | List of Complex Data |  | List with 2 item(s) |
| monthlyGrossIncome | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 7916.67 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| monthlyNetIncome | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 5666.67 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| totalGrossIncome | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 95000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| totalNetIncome | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 68000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**proposedMortgage:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| interestRate | Number |  | 4.5 |
| loanAmount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 350000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| monthlyPayment | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 1945.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| repaymentType | Text |  | Capital and Interest |
| termYears | Number |  | 25 |

**recommendation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| isAffordable | Yes/No |  | Yes |
| maxAffordableLoan | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 375000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| notes | Text |  | Clients demonstrate strong affordability with comf... |

**regulatoryCompliance:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| fcaAffordabilityChecks | Yes/No |  | Yes |
| responsibleLendingCriteria | Yes/No |  | Yes |
| vulnerableCustomerConsiderations | Yes/No | Unique system identifier for this record | No |

**stressTesting:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| passesStressTest | Yes/No |  | Yes |
| stressTestRate | Number |  | 7.0 |
| stressedMonthlyPayment | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 2475.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| stressedSurplusIncome | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 941.67 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

---

### Relationships

This contract connects to:

- Belongs to a Client
- Belongs to a FactFind
- References Income records
- References Expenditure records
- May relate to specific Arrangement (e.g., mortgage)

### Business Validation Rules

- totalIncome must be >= totalExpenditure + commitment
- stress test must pass for mortgage applications
- Must comply with FCA affordability rules

---


## 13.31 Contact Contract
### Overview
The `Contact` contract represents a contact method (email, phone, mobile, work phone, website) for a client.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientRef | Reference Link |  | Complex object |
| contactType | Text | Type of contact (Email, Phone, Mobile, etc.) | EMAIL |
| createdAt | Date | When this record was created in the system | 2026-01-05T10:00:00Z |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 2222 |
| isPreferred | Yes/No |  | Yes |
| isPrimary | Yes/No | Whether this is the primary/main address | Yes |
| isValidForMarketing | Yes/No | Unique system identifier for this record | Yes |
| isVerified | Yes/No | Whether this contact has been verified | Yes |
| marketingOptIn | Yes/No |  | Yes |
| notes | Text |  | Primary email for all communications |
| updatedAt | Date | When this record was last modified | 2026-01-15T09:30:00Z |
| value | Text | The contact value (email address, phone number, etc.) | john.smith@example.com |
| verifiedDate | Date | When this contact was verified | 2026-01-15 |

#### Nested Field Groups

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

---

## 13.32 Attitude to Risk (ATR) Contract
### Overview
The `AttitudeToRisk` contract represents a client's risk tolerance assessment, typically completed via questionnaire for investment and pension advice.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| assessmentDate | Date |  | 2026-02-10 |
| assessmentMethod | Text |  | QUESTIONNAIRE |
| capacityForLoss | Text | City/town | MEDIUM |
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-02-10T11:00:00Z |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 3333 |
| investmentObjective | Text |  | GROWTH |
| isValid | Yes/No | Unique system identifier for this record | Yes |
| knowledgeAndExperience | Complex Data |  | Complex object |
| notes | Text |  | Client comfortable with balanced risk/return profi... |
| questionnaireUsed | Text |  | FinaMetrica Risk Profile |
| recommendedAssetAllocation | Complex Data |  | Complex object |
| reviewRequired | Yes/No |  | No |
| riskLevel | Number |  | 6 |
| riskProfile | Text |  | BALANCED |
| riskScore | Number |  | 65 |
| timeHorizon | Complex Data |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-10T11:00:00Z |
| validUntil | Date | Unique system identifier for this record | 2027-02-10 |
| volatilityTolerance | Complex Data |  | Complex object |

#### Nested Field Groups

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**knowledgeAndExperience:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| investmentExperience | Text |  | MODERATE |
| investmentKnowledge | Text |  | GOOD |
| productsHeld | List of str |  | List with 3 item(s) |

**recommendedAssetAllocation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| alternatives | Number |  | 5 |
| bonds | Number |  | 30 |
| cash | Number |  | 5 |
| equities | Number |  | 60 |

**timeHorizon:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| category | Text | Expenditure category (Housing, Transport, Food, etc.) | Long Term |
| years | Number | Number of years at this address | 15 |

**volatilityTolerance:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| comfortWithFluctuation | Text |  | Moderate |
| maxAcceptableLoss | Number |  | 20 |
| reactionToLosses | Text |  | Would review strategy but remain invested |

---

## 13.33 Professional Contact Contract
### Overview
The `ProfessionalContact` contract represents a client's professional adviser (solicitor, accountant, IFA, mortgage broker, etc.).

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| address | Complex Data | List of all addresses for this client (current and historical) | Complex object |
| canContactDirectly | Yes/No |  | Yes |
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-01-10T09:00:00Z |
| email | Text |  | david.williams@wandassoc.co.uk |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| firmName | Text |  | Williams & Associates Solicitors |
| firstName | Text | First name (given name) | David |
| fullName | Text | Complete formatted name including title | Mr David Williams |
| id | Number | Unique system identifier for this record | 4444 |
| isReferralSource | Yes/No |  | No |
| jobTitle | Text | Job title/position | Partner |
| lastName | Text | Last name (surname/family name) | Williams |
| mobile | Text |  | 07700 900123 |
| phone | Text |  | 020 7123 4567 |
| professionalType | Text |  | SOLICITOR |
| relationshipNotes | Text |  | Client's solicitor for 10+ years - handles all leg... |
| title | Text | Title (Mr, Mrs, Ms, Dr, etc.) | Mr |
| updatedAt | Date | When this record was last modified | 2026-01-10T09:00:00Z |
| website | Text |  | www.wandassoc.co.uk |

#### Nested Field Groups

**address:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| city | Text | City/town | London |
| country | Text | Country | GB |
| line1 | Text | Address line 1 | 45 Legal Square |
| line2 | Text | Address line 2 | Suite 300 |
| postcode | Text | Postcode/ZIP code | EC4A 1BR |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

---

## 13.34 Vulnerability Contract
### Overview
The `Vulnerability` contract represents a client vulnerability indicator for Consumer Duty compliance.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientRef | Reference Link |  | Complex object |
| consumerDutyCompliance | Complex Data |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-01-15T10:00:00Z |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| hasVulnerabilities | Yes/No | Consumer Duty vulnerabilities and required adjustments | Yes |
| id | Number | Unique system identifier for this record | 5555 |
| identifiedDate | Date | Unique system identifier for this record | 2026-01-15 |
| isReviewRequired | Yes/No |  | No |
| notes | Text |  | Client appreciates extra care taken. Partner very ... |
| reasonableAdjustments | List of str |  | List with 4 item(s) |
| reviewDate | Date | When these figures were last reviewed | 2026-07-15 |
| updatedAt | Date | When this record was last modified | 2026-01-15T10:00:00Z |
| vulnerabilityCategories | List of Complex Data |  | List with 2 item(s) |

#### Nested Field Groups

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**consumerDutyCompliance:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adjustmentsMade | Yes/No |  | Yes |
| communicationTailored | Yes/No |  | Yes |
| needsIdentified | Yes/No | Unique system identifier for this record | Yes |
| ongoingMonitoring | Yes/No |  | Yes |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

---

## 13.35 Marketing Preferences Contract
### Overview
The `MarketingPreferences` contract represents a client's marketing consent and communication preferences.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| channelPreferences | Complex Data |  | Complex object |
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-01-15T10:00:00Z |
| dataRetentionConsent | Yes/No |  | Yes |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 6666 |
| lastUpdated | Date |  | 2026-01-15 |
| notes | Text |  | Client prefers email contact for newsletters and u... |
| overallConsent | Yes/No |  | Yes |
| privacyNoticeAcceptedDate | Date |  | 2026-01-15 |
| privacyNoticeVersion | Text |  | 2.1 |
| productInterests | List of Complex Data |  | List with 4 item(s) |
| suppressionList | Yes/No |  | No |
| thirdPartyMarketing | Complex Data |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-01-15T10:00:00Z |

#### Nested Field Groups

**channelPreferences:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| email | Complex Data |  | Complex object |
| consentDate | Date |  | 2026-01-15 |
| consentMethod | Text |  | Online Form |
| optIn | Yes/No |  | Yes |
| phone | Complex Data |  | Complex object |
| consentDate | Text |  | None |
| consentMethod | Text |  | None |
| optIn | Yes/No |  | No |
| post | Complex Data | Postcode/ZIP code | Complex object |
| consentDate | Date |  | 2026-01-15 |
| consentMethod | Text |  | Written Consent |
| optIn | Yes/No |  | Yes |
| sms | Complex Data |  | Complex object |
| consentDate | Text |  | None |
| consentMethod | Text |  | None |
| optIn | Yes/No |  | No |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**thirdPartyMarketing:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| consentDate | Text |  | None |
| optIn | Yes/No |  | No |

---

## 13.36 Estate Planning - Will Contract
### Overview
The `Will` contract represents a client's last will and testament details.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-01-10T10:00:00Z |
| executors | List of Complex Data |  | List with 2 item(s) |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| hasResidenceNilRateBand | Yes/No | Unique system identifier for this record | Yes |
| hasWill | Yes/No |  | Yes |
| id | Number | Unique system identifier for this record | 7777 |
| isMirrorWill | Yes/No |  | Yes |
| lastReviewedDate | Date |  | 2025-12-10 |
| mainBeneficiaries | List of str | List of trust beneficiaries | List with 2 item(s) |
| mirrorWillClientRef | Reference Link |  | Complex object |
| needsUpdate | Yes/No |  | No |
| nextReviewDate | Date |  | 2026-12-10 |
| notes | Text |  | Will reviewed in December 2025 - no changes requir... |
| updateReason | Text |  | None |
| updatedAt | Date | When this record was last modified | 2026-02-10T09:00:00Z |
| willDate | Date |  | 2023-06-15 |
| willLocation | Complex Data |  | Complex object |
| willType | Text |  | MIRROR_WILL |

#### Nested Field Groups

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**mirrorWillClientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-124 |

**willLocation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| address | Text | List of all addresses for this client (current and historical) | 45 Legal Square, London, EC4A 1BR |
| heldBy | Text |  | Williams & Associates Solicitors |
| notes | Text |  | Original will held by solicitor - copy at home |

---

## 13.37 Estate Planning - Lasting Power of Attorney (LPA) Contract
### Overview
The `LastingPowerOfAttorney` contract represents a client's LPA arrangements.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| attorneys | List of Complex Data |  | List with 2 item(s) |
| certificateProvider | Complex Data | Unique system identifier for this record | Complex object |
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2023-09-25T10:00:00Z |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| guidance | Text | Unique system identifier for this record | Preference to remain at home as long as possible |
| hasLPA | Yes/No |  | Yes |
| id | Number | Unique system identifier for this record | 8888 |
| isRegistered | Yes/No |  | Yes |
| lpaLocation | Complex Data |  | Complex object |
| lpaType | Text |  | PROPERTY_FINANCIAL |
| needsUpdate | Yes/No |  | No |
| notes | Text |  | Property and Financial Affairs LPA registered with... |
| registrationDate | Date |  | 2023-09-20 |
| registrationNumber | Text | Companies House registration number | LPA-2023-987654 |
| restrictions | Text |  | Attorney must consult with family before selling p... |
| updatedAt | Date | When this record was last modified | 2026-01-15T09:00:00Z |

#### Nested Field Groups

**certificateProvider:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| contactDetails | Complex Data |  | Complex object |
| phone | Text |  | 020 7456 7890 |
| name | Text | First name (given name) | Dr. Michael Brown |
| relationship | Text |  | GP |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**lpaLocation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| heldBy | Text |  | Home Safe |
| notes | Text |  | Original registered LPA stored in home safe. Copy ... |

---

## 13.38 Estate Planning - Gift Contract
### Overview
The `Gift` contract represents gifts made or planned by the client for inheritance tax planning.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2024-12-26T10:00:00Z |
| exemptionsClaimed | List of Complex Data |  | List with 1 item(s) |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| giftDate | Date |  | 2024-12-25 |
| giftDescription | Text | Description of the goal | Cash gift to help with house deposit |
| giftType | Text |  | POTENTIALLY_EXEMPT_TRANSFER |
| giftValue | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| id | Number | Unique system identifier for this record | 9999 |
| ihtImplications | Complex Data |  | Complex object |
| isOutOfIncome | Yes/No |  | No |
| isRegularGift | Yes/No |  | No |
| notes | Text |  | Gift to daughter for house purchase. Annual exempt... |
| potentiallyExemptTransfer | Complex Data |  | Complex object |
| recipient | Complex Data |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-15T09:00:00Z |

#### Nested Field Groups

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**giftValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 25000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**ihtImplications:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| currentTaxableAmount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 22000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| includedInEstate | Yes/No |  | Yes |

**potentiallyExemptTransfer:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| isPET | Yes/No |  | Yes |
| sevenYearAnniversary | Date |  | 2031-12-25 |
| taperRelief | Complex Data |  | Complex object |
| applicableRate | Number |  | 100 |
| reliefAmount | Number | Amount spent | 0 |
| yearsRemaining | Number |  | 5.85 |

**recipient:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| dateOfBirth | Date | Date of birth | 1995-03-15 |
| name | Text | First name (given name) | Emily Smith |
| relationship | Text |  | Daughter |

---

## 13.39 Estate Planning - Trust Contract
### Overview
The `Trust` contract represents trusts established by or benefiting the client.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| beneficiaries | List of Complex Data | List of trust beneficiaries | List with 2 item(s) |
| clientRef | Reference Link |  | Complex object |
| clientRole | Text |  | SETTLOR |
| createdAt | Date | When this record was created in the system | 2020-03-20T10:00:00Z |
| establishedDate | Date | Date the trust was established | 2020-03-15 |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 10001 |
| lastReviewDate | Date | When these figures were last reviewed | 2025-06-15 |
| nextReviewDate | Date |  | 2026-06-15 |
| notes | Text |  | Discretionary trust established for children's ben... |
| taxTreatment | Complex Data |  | Complex object |
| trustAssets | Complex Data |  | Complex object |
| trustDeedLocation | Complex Data | Reference to the trust deed document | Complex object |
| trustName | Text | Name of the trust | The Smith Family Discretionary Trust |
| trustType | Text | Type of trust (Discretionary, Bare, Interest in Possession, etc.) | DISCRETIONARY_TRUST |
| trustees | List of Complex Data | List of trustees | List with 2 item(s) |
| updatedAt | Date | When this record was last modified | 2026-02-01T09:00:00Z |

#### Nested Field Groups

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**taxTreatment:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| dividendTaxRate | Number | Unique system identifier for this record | 39.35 |
| lastTaxReturn | Date |  | 2025-10-31 |
| nextTaxReturnDue | Date |  | 2026-10-31 |
| taxYear | Text |  | 2025/26 |
| trustTaxRate | Number |  | 45 |

**trustAssets:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| assetTypes | List of str |  | List with 2 item(s) |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| amount | Number | Amount spent | 150000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| lastValuationDate | Date |  | 2026-01-31 |

**trustDeedLocation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| address | Text | List of all addresses for this client (current and historical) | 45 Legal Square, London, EC4A 1BR |
| heldBy | Text |  | Williams & Associates Solicitors |

---

## 13.40 Identity Verification & Data Protection Consent Contract
### Overview
The `IdentityVerification` contract represents identity verification checks and data protection consents.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amlChecks | Complex Data |  | Complex object |
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-01-05T10:00:00Z |
| dataProtectionConsent | Complex Data | GDPR consent, data protection, and privacy management | Complex object |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| gdprRights | Complex Data |  | Complex object |
| id | Number | Unique system identifier for this record | 11111 |
| identityDocuments | List of Complex Data | Unique system identifier for this record | List with 2 item(s) |
| nextReviewDate | Date |  | 2027-01-05 |
| notes | Text |  | Full identity verification completed via Experian.... |
| sourceOfWealth | Complex Data |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-01-05T10:00:00Z |
| verificationDate | Date |  | 2026-01-05 |
| verificationMethod | Text |  | ELECTRONIC_VERIFICATION |
| verificationProvider | Text | Unique system identifier for this record | Experian Identity Check |
| verificationReference | Text |  | EXP-2026-123456 |
| verificationStatus | Text | Current status of the goal | VERIFIED |

#### Nested Field Groups

**amlChecks:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adverseMediaCheck | Complex Data |  | Complex object |
| checkDate | Date |  | 2026-01-05 |
| performed | Yes/No |  | Yes |
| result | Text |  | Clear |
| pepCheck | Complex Data |  | Complex object |
| checkDate | Date |  | 2026-01-05 |
| isPoliticallyExposed | Yes/No |  | No |
| performed | Yes/No |  | Yes |
| result | Text |  | Clear |
| sanctionsCheck | Complex Data |  | Complex object |
| checkDate | Date |  | 2026-01-05 |
| performed | Yes/No |  | Yes |
| provider | Text | Financial institution or provider | World-Check |
| result | Text |  | Clear |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**dataProtectionConsent:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| consentDate | Date |  | 2026-01-05 |
| consentGiven | Yes/No |  | Yes |
| consentMethod | Text |  | Electronic Signature |
| dataProcessingPurposes | List of str |  | List with 4 item(s) |
| dataRetentionPeriod | Text |  | 7 years from last contact |
| privacyNoticeProvided | Yes/No | Unique system identifier for this record | Yes |
| privacyNoticeVersion | Text |  | 2.1 |
| rightToWithdrawConsent | Yes/No |  | Yes |
| thirdPartyDisclosure | Complex Data |  | Complex object |
| consentGiven | Yes/No |  | Yes |
| disclosureReasons | List of str |  | List with 3 item(s) |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**gdprRights:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| rightToAccess | Yes/No |  | Yes |
| rightToDataPortability | Yes/No |  | Yes |
| rightToErasure | Yes/No |  | Yes |
| rightToObject | Yes/No |  | Yes |
| rightToRectification | Yes/No |  | Yes |
| rightToRestriction | Yes/No |  | Yes |

**sourceOfWealth:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| description | Text | Description of the goal | Senior Software Engineer - employed for 15 years |
| isVerified | Yes/No | Whether this contact has been verified | Yes |
| primarySource | Text |  | EMPLOYMENT |

---

## 13.41 Arrangement - Mortgage Contract

### Business Purpose

Represents a mortgage loan secured against a property, including terms, repayments, and property details.

### Key Features

- Tracks mortgage amount, rate, and term
- Records monthly repayments
- Links to the secured property
- Manages multiple mortgages per property

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| accountNumber | Text |  | MTG-001234 |
| agencyStatus | Text | Current age (calculated from date of birth) | NotUnderAgency |
| agencyStatusDate | Date | Current age (calculated from date of birth) | 2023-02-06 |
| arrangementCategory | Text | Expenditure category (Housing, Transport, Food, etc.) | MORTGAGE |
| asset | Reference Link | Total value of all assets | Complex object |
| createdAt | Date | When this record was created in the system | 2023-01-15T10:00:00Z |
| description | Text | Description of the goal | Main residence mortgage - 25 year fixed |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| feesAndCharges | Complex Data |  | Complex object |
| id | Number | Unique system identifier for this record | 5001 |
| illustrationReference | Text |  | IOB-REF-123456 |
| interestTerms | Complex Data |  | Complex object |
| keyDates | Complex Data |  | Complex object |
| lenderName | Text |  | National Bank plc |
| linkedArrangements | List of Complex Data |  | List with 1 item(s) |
| loanAmounts | Complex Data | Amount spent | Complex object |
| notes | Text |  | Main residence mortgage. Fixed rate ends February ... |
| offsetFeatures | Complex Data |  | Complex object |
| owners | List of Complex Data | Who owns this arrangement | List with 1 item(s) |
| policyNumber | Text | Policy or account number | POL-98765 |
| productName | Text | Name of the financial product | Fixed Rate Mortgage Premium |
| productType | Text |  | FixedRateMortgage |
| property | Reference Link | Type of property (Residential, Buy-to-Let, Commercial, etc.) | Complex object |
| propertyDetail | Reference Link |  | Complex object |
| redemptionTerms | Complex Data |  | Complex object |
| repaymentStructure | Complex Data |  | Complex object |
| sellingAdviser | Reference Link |  | Complex object |
| sharedOwnershipDetails | Complex Data | Who owns this arrangement | Complex object |
| specialFeatures | Complex Data |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-10T14:30:00Z |

#### Nested Field Groups

**asset:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 67890 |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**feesAndCharges:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| lenderFees | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 995.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| ongoingContributions | Text | Regular contributions being made | None |

**interestTerms:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| annualPercentageRate | Number | Current age (calculated from date of birth) | 3.75 |
| baseRateIndex | Text |  | SONIA |
| collarRate | Text |  | None |
| hasCollarRate | Yes/No |  | No |
| initialRatePeriodEndsOn | Date |  | 2028-02-06 |
| initialTermMonths | Number |  | 0 |
| initialTermYears | Number |  | 5 |
| interestRate | Number |  | 3.5 |
| rateType | Text |  | Fixed |
| remainingTermMonths | Number |  | 6 |
| remainingTermYears | Number |  | 23 |
| reversionRate | Number |  | 4.25 |

**keyDates:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| applicationSubmittedDate | Date |  | 2023-01-20 |
| balanceAsOfDate | Date |  | 2026-02-10 |
| completionDate | Date |  | 2023-02-06 |
| endDate | Date | Employment end date (null if current) | 2048-02-06 |
| exchangeDate | Date |  | 2023-01-27 |
| nextPaymentDueDate | Date |  | 2026-03-06 |
| nextReviewDate | Date |  | 2028-02-01 |
| offerIssuedDate | Date |  | 2023-01-30 |
| schemeEndDate | Text | Employment end date (null if current) | None |
| startDate | Date | Employment start date | 2023-02-06 |
| targetCompletionDate | Date |  | 2023-02-06 |
| valuationDate | Date |  | 2023-01-22 |
| valuationInstructedDate | Date |  | 2023-01-15 |
| valuationReceivedDate | Date |  | 2023-01-28 |

**loanAmounts:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| currentBalance | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 235000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| currentPropertyValuation | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 385000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| depositAmount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 132000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| equityReleased | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| loanToValueRatio | Number | The contact value (email address, phone number, etc.) | 65.5 |
| originalLoanAmount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 250000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| originalPropertyValuation | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 382000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**offsetFeatures:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| offsetLinkedAccountNumber | Text |  | OFFSET-123456 |
| offsetOptions | List of str |  | List with 3 item(s) |

**property:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 12345 |

**propertyDetail:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 5 |

**redemptionTerms:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| earlyRepaymentCharge | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 7500.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| earlyRepaymentChargeEndsOn | Date |  | 2028-02-06 |
| earlyRepaymentChargeSecondCharge | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| earlyRepaymentTerms | Text |  | No repayment for first 2 years, 3% penalty for yea... |
| hasEarlyRepaymentCharge | Yes/No |  | Yes |
| netProceedsOnRedemption | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 227500.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**repaymentStructure:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| capitalRepaymentAmount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 200000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| capitalTermMonths | Number |  | 0 |
| capitalTermYears | Number |  | 25 |
| currentRepaymentVehicles | List of str |  | List with 2 item(s) |
| interestOnlyAmount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 50000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| interestOnlyRepaymentVehicle | Text |  | ISA |
| interestOnlyTermMonths | Number |  | 0 |
| interestOnlyTermYears | Number |  | 10 |
| lumpSumAdvance | Text |  | None |
| monthlyIncomeDrawdown | Text |  | None |
| regularAnnualOverpayment | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 5000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| repaymentMethod | Text |  | CapitalAndInterest |

**sellingAdviser:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| firmName | Text |  | ABC Mortgage Services |
| id | Number | Unique system identifier for this record | 123 |
| name | Text | First name (given name) | John Adviser |

**sharedOwnershipDetails:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| sharedEquityLoanAmount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| sharedEquityLoanPercentage | Text | Current age (calculated from date of birth) | None |
| sharedEquityRepaymentStartsOn | Text |  | None |
| sharedEquitySchemeProvider | Text | Unique system identifier for this record | None |
| sharedEquitySchemeType | Text |  | None |
| sharedOwnershipHousingAssociation | Text | Who owns this arrangement | None |
| sharedOwnershipMonthlyRent | Currency Amount | Who owns this arrangement | Complex object |
| amount | Number | Amount spent | 0.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| sharedOwnershipPercentageOwned | Text | Current age (calculated from date of birth) | None |

**specialFeatures:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| consentToLetExpiresOn | Text |  | None |
| hasConsentToLet | Yes/No |  | No |
| hasDebtConsolidation | Yes/No | Unique system identifier for this record | No |
| hasDischargeOnCompletion | Yes/No |  | Yes |
| hasGuarantor | Yes/No |  | No |
| incomeVerificationStatus | Text | Current status of the goal | Employed |
| isCurrentResidence | Yes/No | Unique system identifier for this record | Yes |
| isFirstTimeBuyer | Yes/No |  | No |
| isIncomeEvidenced | Yes/No | Unique system identifier for this record | Yes |
| isPortable | Yes/No |  | Yes |
| isPropertySold | Yes/No |  | No |
| isRedeemed | Yes/No |  | No |

---

### Relationships

This contract connects to:

- Belongs to a Client (borrower)
- Links to Property record
- May have joint borrower
- Part of Affordability Assessment

### Business Validation Rules

- propertyRef is required
- originalAmount must be > 0
- outstandingBalance must be <= originalAmount
- monthlyRepayment must be > 0
- maturityDate must be after startDate

---


## 13.42 Arrangement - Investment Contract (General Investment Account)

### Business Purpose

Represents a general investment account (GIA) or other investment wrapper.

### Key Features

- Tracks investment value and performance
- Records asset allocation
- Manages contributions and withdrawals
- Links to underlying fund holdings

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| accountNumber | Text |  | GIA-987654321 |
| adviserDetails | Complex Data |  | Complex object |
| arrangementCategory | Text | Expenditure category (Housing, Transport, Food, etc.) | INVESTMENT |
| assetAllocation | Complex Data |  | Complex object |
| charges | Complex Data |  | Complex object |
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2020-03-20T10:00:00Z |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| fundHoldings | List of Complex Data |  | List with 3 item(s) |
| gainLoss | Currency Amount |  | Complex object |
| id | Number | Unique system identifier for this record | 13001 |
| investmentObjective | Text |  | Long-term capital growth for retirement planning |
| investmentType | Text |  | GENERAL_INVESTMENT_ACCOUNT |
| notes | Text |  | General Investment Account with monthly contributi... |
| productName | Text | Name of the financial product | Vanguard Investment Account |
| providerName | Text | Unique system identifier for this record | Vanguard |
| providerRef | Reference Link | Unique system identifier for this record | Complex object |
| regularContributions | Complex Data | Regular contributions being made | Complex object |
| riskProfile | Complex Data |  | Complex object |
| startDate | Date | Employment start date | 2020-03-15 |
| taxWrapper | Text |  | TAXABLE |
| totalContributions | Currency Amount | Regular contributions being made | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-18T14:00:00Z |
| valuationDate | Date |  | 2026-02-18 |
| withdrawals | Complex Data |  | Complex object |

#### Nested Field Groups

**adviserDetails:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adviceDate | Date |  | 2020-02-28 |
| adviserName | Text |  | Jane Financial Adviser |
| firmName | Text |  | XYZ Wealth Management |
| lastReviewDate | Date | When these figures were last reviewed | 2025-11-15 |

**assetAllocation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| alternatives | Number |  | 5.0 |
| bonds | Number |  | 25.0 |
| cash | Number |  | 5.0 |
| equities | Number |  | 65.0 |

**charges:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| fundCharges | Number |  | 0.22 |
| platformFee | Number |  | 0.25 |
| totalAnnualCharge | Number |  | 0.47 |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**currentValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 75000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**gainLoss:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 15000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| percentage | Number | Current age (calculated from date of birth) | 25.0 |

**providerRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | provider-456 |

**regularContributions:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 500.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| frequency | Text | How often (Monthly, Annual, etc.) | MONTHLY |
| isActive | Yes/No |  | Yes |
| startDate | Date | Employment start date | 2020-03-15 |

**riskProfile:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| atrRef | Reference Link |  | Complex object |
| id | Number | Unique system identifier for this record | 3333 |
| targetRiskLevel | Number |  | 6 |

**totalContributions:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 60000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**withdrawals:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasRegularWithdrawals | Yes/No |  | No |

---

### Relationships

This contract connects to:

- Belongs to a Client
- Contains multiple Investment holdings
- May link to Financial Adviser
- Part of total assets calculation

### Business Validation Rules

- currentValue must be >= 0
- Units and prices must be consistent with value
- Asset allocation must sum to 100%

---


## 13.43 Arrangement - Protection Contract (Life Assurance)

### Business Purpose

Represents life assurance, critical illness cover, income protection, or other protection policies.

### Key Features

- Records sum assured and premium
- Tracks beneficiaries
- Manages policy terms and conditions
- Links to life assurance trusts

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adviserDetails | Complex Data |  | Complex object |
| arrangementCategory | Text | Expenditure category (Housing, Transport, Food, etc.) | PROTECTION |
| beneficiaries | List of Complex Data | List of trust beneficiaries | List with 1 item(s) |
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2023-01-20T10:00:00Z |
| currentSumAssured | Currency Amount |  | Complex object |
| endDate | Date | Employment end date (null if current) | 2048-01-15 |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 20001 |
| indexation | Complex Data |  | Complex object |
| isInTrust | Yes/No |  | Yes |
| linkedTo | Complex Data |  | Complex object |
| notes | Text |  | Decreasing term assurance to protect mortgage. Wri... |
| policyNumber | Text | Policy or account number | LA-12345678 |
| policyType | Text |  | DECREASING_TERM |
| premium | Currency Amount |  | Complex object |
| premiumFrequency | Text | How often (Monthly, Annual, etc.) | MONTHLY |
| premiumType | Text |  | GUARANTEED |
| productName | Text | Name of the financial product | Mortgage Protection Plan |
| protectionType | Text |  | LIFE_ASSURANCE |
| providerName | Text | Unique system identifier for this record | Aviva |
| providerRef | Reference Link | Unique system identifier for this record | Complex object |
| reviewDate | Date | When these figures were last reviewed | 2027-01-15 |
| startDate | Date | Employment start date | 2023-01-15 |
| sumAssured | Currency Amount |  | Complex object |
| termRemaining | Complex Data |  | Complex object |
| trustDetails | Complex Data |  | Complex object |
| underwriting | Complex Data |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-15T09:00:00Z |

#### Nested Field Groups

**adviserDetails:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adviceDate | Date |  | 2022-12-10 |
| adviserName | Text |  | John Adviser |
| firmName | Text |  | ABC Protection Services |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**currentSumAssured:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 325000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| note | Text |  | Decreasing with mortgage balance |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**indexation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| isIndexLinked | Yes/No |  | No |

**linkedTo:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| liabilityRef | Reference Link |  | Complex object |
| id | Number | Unique system identifier for this record | 5678 |
| mortgageRef | Reference Link | Current age (calculated from date of birth) | Complex object |
| id | Number | Unique system identifier for this record | 12001 |

**premium:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 45.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**providerRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | provider-789 |

**sumAssured:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 350000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**termRemaining:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| months | Number |  | 11 |
| years | Number | Number of years at this address | 21 |

**trustDetails:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| beneficiaries | List of str | List of trust beneficiaries | List with 2 item(s) |
| trustType | Text | Type of trust (Discretionary, Bare, Interest in Possession, etc.) | Bare Trust |
| trustees | List of str | List of trustees | List with 1 item(s) |

**underwriting:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| completedDate | Date |  | 2023-01-10 |
| exclusions | List |  | Empty list |
| underwritingType | Text |  | Full Medical Underwriting |

---

### Relationships

This contract connects to:

- Belongs to a Client (life assured)
- May have different policy owner
- May link to Trust
- Part of protection needs analysis

### Business Validation Rules

- sumAssured must be > 0
- premium must be > 0
- At least one beneficiary required
- Policy must be in force or lapsed

---


## 13.44 Arrangement - Pension Contract (Personal Pension)

### Business Purpose

Represents a personal pension, workplace pension, SIPP, or other pension arrangement.

### Key Features

- Tracks pension fund value
- Records contributions (personal and employer)
- Manages pension scheme details
- Calculates retirement projections

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adviserDetails | Complex Data |  | Complex object |
| arrangementCategory | Text | Expenditure category (Housing, Transport, Food, etc.) | PENSION |
| assetAllocation | Complex Data |  | Complex object |
| charges | Complex Data |  | Complex object |
| clientRef | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2010-04-10T10:00:00Z |
| crystallisedAmount | Currency Amount | Amount spent | Complex object |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| deathBenefits | Complex Data |  | Complex object |
| factfindRef | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| fundHoldings | List of Complex Data |  | List with 3 item(s) |
| growthToDate | Currency Amount | Date moved from this address (null if current) | Complex object |
| id | Number | Unique system identifier for this record | 30001 |
| lifetimeAllowanceUsed | Currency Amount |  | Complex object |
| notes | Text |  | Personal pension with regular monthly contribution... |
| pensionType | Text |  | PERSONAL_PENSION |
| policyNumber | Text | Policy or account number | PP-123456789 |
| productName | Text | Name of the financial product | Vanguard Personal Pension |
| projectedValueAtRetirement | Complex Data | The contact value (email address, phone number, etc.) | Complex object |
| providerName | Text | Unique system identifier for this record | Vanguard |
| providerRef | Reference Link | Unique system identifier for this record | Complex object |
| regularContributions | Complex Data | Regular contributions being made | Complex object |
| retirementAge | Number | Current age (calculated from date of birth) | 67 |
| selectedRetirementAge | Number | Current age (calculated from date of birth) | 65 |
| startDate | Date | Employment start date | 2010-04-06 |
| stateRetirementAge | Number | Current age (calculated from date of birth) | 67 |
| taxFreeCashAvailable | Currency Amount |  | Complex object |
| totalContributions | Currency Amount | Regular contributions being made | Complex object |
| uncrystallisedAmount | Currency Amount | Amount spent | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-18T14:00:00Z |
| valuationDate | Date |  | 2026-02-18 |

#### Nested Field Groups

**adviserDetails:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adviceDate | Date |  | 2010-03-15 |
| adviserName | Text |  | Jane Financial Adviser |
| firmName | Text |  | XYZ Wealth Management |
| lastReviewDate | Date | When these figures were last reviewed | 2025-09-20 |

**assetAllocation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| alternatives | Number |  | 2.0 |
| bonds | Number |  | 15.0 |
| cash | Number |  | 3.0 |
| equities | Number |  | 80.0 |

**charges:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| fundCharges | Number |  | 0.22 |
| platformFee | Number |  | 0.15 |
| totalAnnualCharge | Number |  | 0.37 |

**clientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | client-123 |

**crystallisedAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 0.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**currentValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 185000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**deathBenefits:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| beforeRetirement | Complex Data |  | Complex object |
| amount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 185000.0 |
| currency | Complex Data |  | Complex object |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Full fund value |
| isInTrust | Yes/No |  | Yes |
| nominatedBeneficiaries | List of Complex Data | List of trust beneficiaries | List with 1 item(s) |

**factfindRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**growthToDate:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 65000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| percentage | Number | Current age (calculated from date of birth) | 54.2 |

**lifetimeAllowanceUsed:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 185000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| note | Text |  | Lifetime Allowance abolished from April 2024 |
| percentage | Number | Current age (calculated from date of birth) | 16.4 |

**projectedValueAtRetirement:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| assumedRetirementAge | Number | Current age (calculated from date of birth) | 65 |
| highGrowth | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 410000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| lowGrowth | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 285000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| mediumGrowth | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 340000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**providerRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Text | Unique system identifier for this record | provider-456 |

**regularContributions:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| frequency | Text | How often (Monthly, Annual, etc.) | MONTHLY |
| grossAmount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 800.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| isActive | Yes/No |  | Yes |
| netAmount | Currency Amount | Amount spent | Complex object |
| amount | Number | Amount spent | 640.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| startDate | Date | Employment start date | 2010-04-06 |
| taxRelief | Currency Amount |  | Complex object |
| amount | Number | Amount spent | 160.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**taxFreeCashAvailable:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 46250.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| percentage | Number | Current age (calculated from date of birth) | 25 |

**totalContributions:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 120000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**uncrystallisedAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 185000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

---

### Relationships

This contract connects to:

- Belongs to a Client
- May link to Employment (for workplace pensions)
- Contains Investment holdings
- Part of retirement planning

### Business Validation Rules

- currentValue must be >= 0
- Contributions must not exceed annual allowance
- normalRetirementAge must be >= 55
- Pension scheme must be registered with HMRC

---




---

## 13.45 Arrangement - Pension Contract (SIPP)

### Business Purpose

Represents a Self-Invested Personal Pension with wider investment choices including property and direct equities.

### Key Features

- Commercial property investment within pension wrapper
- Direct equity holdings allowed
- Greater investment flexibility than standard pensions
- Higher charges for additional services

### Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementCategory | Text | Type of arrangement | PENSION |
| pensionType | Text | Specific pension type | SIPP |
| currentValue | Currency Amount | Current total fund value | £425,000 |
| sippSpecificFeatures | Complex Data | SIPP-specific investment features | Complex object |
| allowsCommercialProperty | Yes/No | Whether can invest in commercial property | Yes |
| hasPropertyHolding | Yes/No | Currently holds commercial property | Yes |
| propertyHoldingsCount | Number | Number of properties held | 1 |
| charges | Complex Data | SIPP fee structure | Complex object |
| setupFee | Currency Amount | One-time setup fee | £0 (waived) |
| annualAdministrationFee | Currency Amount | Annual admin charge | £400 |
| propertyRelatedFees | Complex Data | Additional property fees | Complex object |

### Business Validation Rules

- Commercial property must be for business use only (not residential)
- Property should not exceed 60% of total SIPP value
- Annual contributions subject to £60,000 limit
- SIPP provider must be FCA regulated

---

## 13.46 Arrangement - Pension Contract (Final Salary/Defined Benefit)

### Business Purpose

Represents a Final Salary or Defined Benefit pension providing guaranteed income based on salary and service.

### Key Features

- Guaranteed pension income for life
- Based on years of service and final/career average salary
- Spouse and dependant pensions
- Cash Equivalent Transfer Value (CETV) for transfer options
- Early/late retirement factors

### Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementCategory | Text | Type of arrangement | PENSION |
| pensionType | Text | Specific pension type | FINAL_SALARY |
| membershipStatus | Text | Current membership status | DEFERRED |
| yearsOfService | Complex Data | Service years breakdown | 17 years, 5 months |
| accrualRate | Text | Benefit accrual rate | 1/60th |
| projectedPensionAtNRA | Currency Amount | Projected annual pension | £16,837 per year |
| transferValue | Complex Data | CETV details | Complex object |
| cashEquivalentTransferValue | Currency Amount | Current transfer value | £415,000 |
| cetvDate | Date | Date CETV calculated | 2026-01-15 |
| transferValueMultiplier | Number | CETV as multiple of pension | 24.6 |
| deathBenefits | Complex Data | Death benefit structure | Complex object |
| spousePension | Complex Data | Spouse's pension entitlement | 50% of member pension |

### Business Validation Rules

- Transfer advice mandatory if CETV ≥ £30,000 (FCA requirement)
- Pension Wise guidance must be offered to members aged 50+
- Transfer value expires after guarantee period (typically 3 months)
- Accrual rate typically 1/60th or 1/80th for UK schemes

---

## 13.47 Arrangement - Pension Contract (Money Purchase/Defined Contribution)

### Business Purpose

Represents a workplace Defined Contribution pension with employer matching contributions.

### Key Features

- Employer contribution matching
- Auto-enrolment compliance
- Lifestyling investment strategy
- Member and employer contribution tracking
- Salary sacrifice options available

### Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementCategory | Text | Type of arrangement | PENSION |
| pensionType | Text | Specific pension type | MONEY_PURCHASE |
| currentValue | Currency Amount | Current fund value | £48,500 |
| contributionStructure | Complex Data | Contribution breakdown | Complex object |
| memberContribution | Complex Data | Employee contribution | 5% of salary |
| employerContribution | Complex Data | Employer contribution | 7.5% of salary |
| matchingStructure | Complex Data | Matching rules | 1.5:1 ratio |
| autoEnrolmentDetails | Complex Data | Auto-enrolment compliance | Complex object |
| minimumContributionsMet | Yes/No | Meets minimum 8% total | Yes |
| lifestyling | Complex Data | Lifestyling strategy | Complex object |
| lifestylingStartAge | Number | Age lifestyling begins | 55 |

### Business Validation Rules

- Minimum total contributions: 8% (3% employer + 5% employee from April 2019)
- Qualifying earnings: £6,240 to £50,270 (2024/25)
- Auto-enrolment age: 22 to State Pension Age
- Re-enrolment every 3 years for opt-outs

---

## 13.48 Arrangement - Pension Contract (State Pension)

### Business Purpose

Represents UK State Pension entitlement based on National Insurance contributions.

### Key Features

- National Insurance contributions record tracking
- State Pension forecast calculations
- Voluntary contributions options
- Deferral benefits
- Contracted-out impact assessment

### Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementCategory | Text | Type of arrangement | PENSION |
| pensionType | Text | Specific pension type | STATE_PENSION |
| statePensionType | Text | New or Basic State Pension | NEW_STATE_PENSION |
| nationalInsuranceNumber | Text | NI number | AB123456C |
| stateRetirementAge | Number | State Pension Age | 67 |
| nationalInsuranceRecord | Complex Data | NI contributions history | Complex object |
| qualifyingYears | Number | Years with full NI credits | 23 |
| yearsRequired | Number | Years needed for full pension | 35 |
| statePensionForecast | Complex Data | Forecast amounts | Complex object |
| forecastWeeklyAmount | Currency Amount | Forecast weekly pension | £203.85 per week |
| forecastAnnualAmount | Currency Amount | Forecast annual pension | £10,600 per year |
| voluntaryContributions | Complex Data | Options to fill gaps | Complex object |
| costToFillOneYear | Currency Amount | Cost per year of gaps | £824.20 |

### Business Validation Rules

- Minimum 10 qualifying years needed for any State Pension
- Full State Pension requires 35 qualifying years
- Maximum State Pension 2024/25: £221.20 per week
- Voluntary contributions deadline: typically within 6 years

---

## 13.49 Arrangement - Investment Contract (Stocks & Shares ISA)

### Business Purpose

Represents a tax-efficient investment wrapper providing tax-free growth and income on investments.

### Key Features

- Annual subscription limit (£20,000 for 2024/25)
- Tax-free dividends and capital gains
- Flexible ISA withdrawal replacement
- Wide investment choice
- ISA transfer capabilities

### Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementCategory | Text | Type of arrangement | INVESTMENT |
| investmentType | Text | Specific investment type | STOCKS_SHARES_ISA |
| currentValue | Currency Amount | Current ISA value | £142,000 |
| isaAllowanceTracking | Complex Data | ISA allowance details | Complex object |
| annualAllowance | Currency Amount | Current year allowance | £20,000 |
| usedThisYear | Currency Amount | Allowance used this year | £15,000 |
| remainingThisYear | Currency Amount | Allowance remaining | £5,000 |
| flexibleISA | Complex Data | Flexible ISA features | Complex object |
| isFlexibleISA | Yes/No | Allows withdrawal replacement | Yes |
| withdrawalsThisYear | Currency Amount | Amount withdrawn this year | £5,000 |
| replacementAllowanceAvailable | Currency Amount | Extra allowance from withdrawals | £5,000 |
| incomeGenerated | Complex Data | Tax-free income tracking | Complex object |
| dividendsReceivedThisYear | Currency Amount | Dividends received | £3,200 |
| taxTreatment | Text | Tax status | TAX_FREE |

### Business Validation Rules

- One Stocks & Shares ISA per tax year
- Age 18+ required
- UK resident (or Crown employee/spouse serving overseas)
- Transfers don't count towards annual allowance

---

## 13.50 Arrangement - Investment Contract (Lifetime ISA)

### Business Purpose

Represents a Lifetime ISA for first-time home buyers or retirement savings with government bonus.

### Key Features

- 25% government bonus on contributions (max £1,000/year)
- £4,000 annual contribution limit
- Use for first home (≤£450k) or age 60+ withdrawal
- 25% penalty on early withdrawal
- Counts towards £20,000 ISA allowance

### Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementCategory | Text | Type of arrangement | INVESTMENT |
| investmentType | Text | Specific investment type | LIFETIME_ISA |
| lisaType | Text | Cash or Stocks & Shares | STOCKS_SHARES_LISA |
| currentValue | Currency Amount | Total fund value | £17,200 |
| memberContributions | Currency Amount | Client contributions (excl bonus) | £12,000 |
| governmentBonus | Currency Amount | Total bonus received | £3,000 |
| eligibilityAndWithdrawal | Complex Data | Eligibility rules | Complex object |
| ageAtOpening | Number | Age when opened | 28 |
| earlyWithdrawalPenalty | Number | Penalty percentage | 25% |
| firstHomeEligibility | Complex Data | First home purchase rules | Complex object |
| maxPropertyPrice | Currency Amount | Maximum property value | £450,000 |
| penaltyCalculation | Complex Data | Penalty breakdown | Complex object |
| penaltyAmount | Currency Amount | Calculated penalty | £4,300 |
| bonusLost | Currency Amount | Bonus lost to penalty | £3,000 |

### Business Validation Rules

- Age 18-39 to open
- Contribute until day before 50th birthday
- Maximum £4,000 per tax year
- Government bonus: 25% (max £1,000/year)
- First home: UK property, ≤£450k, main residence, use mortgage

---

## 13.51 Arrangement - Investment Contract (Investment Bond - Onshore)

### Business Purpose

Represents an onshore investment bond (life insurance wrapper) with tax-deferred growth.

### Key Features

- Life insurance wrapper with tax benefits
- 5% annual withdrawal allowance (cumulative)
- Top-slicing relief on chargeable gains
- Segment structure for partial encashment
- 20% basic rate tax paid within bond

### Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementCategory | Text | Type of arrangement | INVESTMENT |
| investmentType | Text | Specific investment type | INVESTMENT_BOND_ONSHORE |
| currentValue | Currency Amount | Current bond value | £285,000 |
| bondStructure | Complex Data | Segment structure | Complex object |
| numberOfSegments | Number | Total segments | 100 |
| segmentValue | Currency Amount | Value per segment | £2,850 |
| withdrawalAllowance | Complex Data | 5% allowance tracking | Complex object |
| annualAllowancePercentage | Number | Annual allowance | 5% |
| cumulativeAllowanceAvailable | Currency Amount | Total unused allowance | £100,000 |
| taxPosition | Complex Data | Tax treatment | Complex object |
| bondType | Text | Onshore or offshore | ONSHORE |
| topSlicingReliefAvailable | Yes/No | Tax relief available | Yes |
| basicRateTaxCredit | Number | Tax already paid | 20% |

### Business Validation Rules

- 5% annual withdrawal allowance accumulates if unused
- Calculation: Total invested × 5% × years elapsed
- Top-slicing relief: Gain ÷ years held = average gain
- Chargeable gain on full or partial surrender

---

## 13.52 Arrangement - Protection Contract (Critical Illness Cover)

### Business Purpose

Represents critical illness insurance paying lump sum on diagnosis of specified conditions.

### Key Features

- Defined list of covered conditions (typically 40-50)
- Full and partial pay-out conditions
- Severity-based benefits
- Children's cover included
- Additional payment cover options

### Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementCategory | Text | Type of arrangement | PROTECTION |
| protectionType | Text | Specific protection type | CRITICAL_ILLNESS_COVER |
| policyType | Text | Standalone or combined | STANDALONE_CRITICAL_ILLNESS |
| sumAssured | Currency Amount | Lump sum benefit | £200,000 |
| premium | Currency Amount | Monthly premium | £95 |
| coverageDetails | Complex Data | Coverage specifics | Complex object |
| numberOfConditionsCovered | Number | Total conditions covered | 47 |
| fullPayOutConditions | Number | Full benefit conditions | 42 |
| partialPayOutConditions | Number | Partial benefit conditions | 5 |
| childrensCoverIncluded | Yes/No | Children's cover | Yes |
| childrensCoverAmount | Currency Amount | Children's benefit | £25,000 |
| additionalPaymentCover | Yes/No | Extra payment option | Yes |

### Business Validation Rules

- Full pay-out: 100% of sum assured for major conditions
- Partial pay-out: typically 25% for less severe conditions
- Examples: Cancer, heart attack, stroke, major organ transplant
- Children's cover: typically £10k-£50k per child

---

## 13.53 Arrangement - Protection Contract (Income Protection)

### Business Purpose

Represents income protection insurance providing replacement income during illness or injury.

### Key Features

- Deferred period before benefit starts
- Benefit percentage (typically 50-70% of income)
- Payment until retirement age or fixed term
- Own occupation vs any occupation definition
- Rehabilitation support

### Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementCategory | Text | Type of arrangement | PROTECTION |
| protectionType | Text | Specific protection type | INCOME_PROTECTION |
| monthlyBenefit | Currency Amount | Monthly income benefit | £3,500 |
| premium | Currency Amount | Monthly premium | £87.50 |
| deferredPeriod | Complex Data | Waiting period | Complex object |
| weeks | Number | Weeks before benefit starts | 13 |
| benefitDetails | Complex Data | Benefit structure | Complex object |
| benefitPercentageOfIncome | Number | Percentage of income covered | 60% |
| paymentPeriod | Text | How long benefits paid | TO_RETIREMENT_AGE |
| occupationDefinition | Complex Data | Definition of incapacity | Complex object |
| definitionType | Text | Type of definition | OWN_OCCUPATION |
| rehabilitationBenefit | Currency Amount | Support for return to work | £3,500 |

### Business Validation Rules

- Deferred period: typically 4, 8, 13, 26, or 52 weeks
- Benefit percentage: usually 50-70% of gross income (prevents over-insurance)
- Own occupation: can't perform your specific job
- Payment period: typically to age 60, 65, or 70

---

## 13.54 Arrangement - Protection Contract (Buildings Insurance)

### Business Purpose

Represents buildings insurance providing structural protection for property.

### Key Features

- Based on rebuild cost (not market value)
- Structural damage cover
- Subsidence and landslip protection
- Alternative accommodation provision
- Public liability included

### Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementCategory | Text | Type of arrangement | PROTECTION |
| protectionType | Text | Specific protection type | BUILDINGS_INSURANCE |
| sumInsured | Currency Amount | Rebuild cost estimate | £450,000 |
| valuationBasis | Text | How sum insured determined | REBUILD_COST |
| annualPremium | Currency Amount | Annual premium | £385 |
| excess | Currency Amount | Standard excess | £250 |
| subsidenceExcess | Currency Amount | Subsidence-specific excess | £1,000 |
| coverageDetails | Complex Data | What's covered | Complex object |
| subsidenceAndHeave | Yes/No | Subsidence cover included | Yes |
| alternativeAccommodation | Currency Amount | Max alternative accommodation | £50,000 |
| publicLiability | Currency Amount | Public liability cover | £2,000,000 |

### Business Validation Rules

- Sum insured should equal rebuild cost (not market value)
- Rebuild cost typically lower than market value
- Review annually to account for building cost inflation
- Subsidence excess typically £1,000

---

## 13.55 Arrangement - Mortgage Contract (Lifetime Mortgage)

### Business Purpose

Represents a lifetime mortgage (equity release) for homeowners aged 55+ with no monthly repayments.

### Key Features

- No monthly repayments (interest rolls up)
- No negative equity guarantee
- Fixed or capped interest rate for life
- Voluntary payment options
- Inheritance protection available

### Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementCategory | Text | Type of arrangement | MORTGAGE |
| productType | Text | Specific mortgage type | LifetimeMortgage |
| lenderName | Text | Equity release provider | Aviva Equity Release |
| youngestBorrowerAge | Number | Age of youngest borrower | 66 |
| loanDetails | Complex Data | Loan structure | Complex object |
| initialAdvance | Currency Amount | Lump sum released | £85,000 |
| currentBalance | Currency Amount | Current amount owed | £87,650 |
| loanToValue | Number | LTV percentage | 23% |
| interestDetails | Complex Data | Interest terms | Complex object |
| interestRate | Number | Annual interest rate | 5.95% |
| rollUpMethod | Text | How interest compounds | COMPOUND_INTEREST |
| noPaymentRequired | Yes/No | No monthly payments | Yes |
| equityReleaseCouncilStandards | Complex Data | ERC compliance | Complex object |
| noNegativeEquityGuarantee | Yes/No | Balance never exceeds value | Yes |
| inheritanceProtection | Complex Data | Protected amount | Complex object |
| protectionPercentage | Number | Percentage protected | 20% |

### Business Validation Rules

- Minimum age: typically 55 (youngest borrower)
- No negative equity guarantee: balance never exceeds property value
- Interest rolls up: £85k at 5.95% for 20 years = £256k
- Equity Release Council membership recommended
- Lifetime occupancy guarantee

---

## 13.56 Arrangement - Mortgage Contract (Buy-to-Let Mortgage)

### Business Purpose

Represents a buy-to-let mortgage for investment properties assessed on rental income.

### Key Features

- Rental income assessment (125-145% ICR requirement)
- Higher interest rates than residential
- Interest coverage ratio stress testing
- Section 24 tax implications (for personal ownership)
- Portfolio landlord considerations

### Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangementCategory | Text | Type of arrangement | MORTGAGE |
| productType | Text | Specific mortgage type | BuyToLetMortgage |
| lenderName | Text | BTL mortgage lender | Paragon Bank |
| loanDetails | Complex Data | Loan structure | Complex object |
| currentBalance | Currency Amount | Amount owed | £175,000 |
| loanToValue | Number | LTV percentage | 58.3% |
| interestDetails | Complex Data | Interest terms | Complex object |
| interestRate | Number | Annual interest rate | 4.75% |
| monthlyPayment | Currency Amount | Monthly interest payment | £976 |
| rentalIncome | Complex Data | Rental income details | Complex object |
| monthlyRental | Currency Amount | Monthly rent | £1,450 |
| annualRental | Currency Amount | Annual rent | £17,400 |
| interestCoverageRatio | Complex Data | ICR calculation | Complex object |
| requiredICR | Number | Minimum ICR required | 125% |
| actualICR | Number | Actual ICR achieved | 145% |
| ownershipStructure | Complex Data | Tax structure | Complex object |
| ownershipType | Text | Personal or limited company | PERSONAL |
| section24TaxApplies | Yes/No | Section 24 restrictions | Yes |

### Business Validation Rules

- Interest Coverage Ratio: (Annual Rent ÷ Annual Interest) × 100
- Required ICR: 125% standard, 145% for higher rate taxpayers
- Assessment rate: typically 5.5% (stress test)
- Section 24: Interest relief restricted to 20% for personal ownership
- Portfolio landlord: typically 4+ mortgaged BTL properties

---

# Appendices

## Appendix A: Common Value Types

These are reusable data structures used throughout the contracts.

### MoneyValue

Represents a monetary amount with currency.

| Field | Type | Description |
|-------|------|-------------|
| amount | Number | The numeric amount |
| currency | CurrencyCode | Currency details (code, name, symbol) |

### AddressValue

Represents a physical address.

| Field | Type | Description |
|-------|------|-------------|
| addressType | Selection | Type of address (Residential, Business, Previous, etc.) |
| line1 | Text | Address line 1 |
| line2 | Text | Address line 2 (optional) |
| line3 | Text | Address line 3 (optional) |
| line4 | Text | Address line 4 (optional) |
| city | Text | City or town |
| county | Text | County or region |
| postcode | Text | Postcode or ZIP code |
| country | CountryCode | Country details |
| isPrimary | Yes/No | Whether this is the primary address |
| fromDate | Date | Date moved to this address |
| toDate | Date | Date moved from this address (null if current) |
| yearsAtAddress | Number | Number of years at this address |

### ContactValue

Represents a contact method.

| Field | Type | Description |
|-------|------|-------------|
| contactType | Selection | Type of contact (Email, Phone, Mobile, etc.) |
| value | Text | The contact value (email address, phone number) |
| isPrimary | Yes/No | Whether this is the primary contact of this type |
| isVerified | Yes/No | Whether this contact has been verified |
| verifiedDate | Date | When this contact was verified |

### CountryCode

Represents a country using ISO standards.

| Field | Type | Description |
|-------|------|-------------|
| code | Text | ISO 3166-1 alpha-2 country code (e.g., GB, US) |
| display | Text | Full country name (e.g., United Kingdom) |
| alpha3 | Text | ISO 3166-1 alpha-3 country code (e.g., GBR) |

### CurrencyCode

Represents a currency using ISO standards.

| Field | Type | Description |
|-------|------|-------------|
| code | Text | ISO 4217 currency code (e.g., GBP, USD, EUR) |
| display | Text | Currency name (e.g., British Pound) |
| symbol | Text | Currency symbol (e.g., £, $, €) |

### Reference

Represents a link to another entity.

| Field | Type | Description |
|-------|------|-------------|
| id | Text | Unique identifier of the referenced entity |
| href | Text | API URL to access the referenced entity |
| name | Text | Display name of the referenced entity (optional) |

## Appendix B: Common Enum Values

These are predefined selection lists used throughout the system.

### Client Type
- **Person**: Individual client
- **Corporate**: Company or business entity
- **Trust**: Trust entity

### Gender
- **M**: Male
- **F**: Female
- **O**: Other
- **X**: Prefer not to say

### Marital Status
- **SIN**: Single
- **MAR**: Married
- **CIV**: Civil Partnership
- **DIV**: Divorced
- **SEP**: Separated
- **WID**: Widowed
- **COH**: Cohabiting

### Title
- **MR**: Mr
- **MRS**: Mrs
- **MISS**: Miss
- **MS**: Ms
- **DR**: Dr
- **PROF**: Professor
- **REV**: Reverend
- **SIR**: Sir
- **LORD**: Lord
- **LADY**: Lady

### Smoking Status
- **NEVER**: Never smoked
- **FORMER**: Former smoker
- **LIGHT**: Light smoker (< 10 per day)
- **MODERATE**: Moderate smoker (10-20 per day)
- **HEAVY**: Heavy smoker (> 20 per day)

### Address Type
- **RES**: Residential (current home)
- **PREV**: Previous address
- **CORRESPONDENCE**: Correspondence address
- **BUSINESS**: Business address
- **REGISTERED**: Registered office (corporate only)
- **TRADING**: Trading address (corporate only)

### Contact Type
- **EMAIL**: Email address
- **PHONE**: Home phone number
- **MOBILE**: Mobile phone number
- **WORK_PHONE**: Work phone number
- **WORK_EMAIL**: Work email address
- **FAX**: Fax number
- **WEBSITE**: Website URL

### Service Status
- **Prospect**: Potential client (not yet onboarded)
- **Active**: Active client receiving services
- **Inactive**: Inactive client (no current advice)
- **Suspended**: Temporarily suspended
- **Closed**: Client relationship ended
- **Deceased**: Client has passed away

### Client Segment
- **A**: Premier/highest priority
- **B**: High priority
- **C**: Standard priority
- **D**: Lower priority

### Arrangement Type
- **PENSION**: Pension arrangement
- **INVESTMENT**: Investment arrangement
- **PROTECTION**: Life assurance or protection policy
- **MORTGAGE**: Mortgage
- **BANK_ACCOUNT**: Bank or savings account
- **EQUITY_RELEASE**: Equity release mortgage

### Pension Sub-Type
- **PERSONAL_PENSION**: Personal pension
- **STAKEHOLDER**: Stakeholder pension
- **SIPP**: Self-Invested Personal Pension
- **WORKPLACE_PENSION**: Workplace pension (DC)
- **FINAL_SALARY**: Final salary pension (DB)
- **STATE_PENSION**: State pension

### Investment Sub-Type
- **GIA**: General Investment Account
- **ISA**: Individual Savings Account
- **BOND**: Investment Bond
- **OFFSHORE_BOND**: Offshore Investment Bond
- **UNIT_TRUST**: Unit Trust
- **OEIC**: Open-Ended Investment Company

### Protection Sub-Type
- **LIFE_ASSURANCE**: Life assurance
- **CRITICAL_ILLNESS**: Critical illness cover
- **INCOME_PROTECTION**: Income protection
- **PMI**: Private medical insurance
- **FAMILY_INCOME_BENEFIT**: Family income benefit

### Property Type
- **RESIDENTIAL**: Residential property (main home)
- **BUY_TO_LET**: Buy-to-let property
- **SECOND_HOME**: Second home/holiday home
- **COMMERCIAL**: Commercial property
- **LAND**: Land

### Employment Type
- **EMPLOYED**: Employed (PAYE)
- **SELF_EMPLOYED**: Self-employed
- **DIRECTOR**: Company director
- **PARTNER**: Business partner
- **CONTRACTOR**: Contractor
- **RETIRED**: Retired
- **UNEMPLOYED**: Unemployed
- **STUDENT**: Student
- **HOME_MAKER**: Home maker

### Goal Type
- **RETIREMENT**: Retirement planning
- **EDUCATION**: Education funding
- **PROPERTY_PURCHASE**: Property purchase
- **DEBT_REPAYMENT**: Debt repayment
- **WEDDING**: Wedding
- **TRAVEL**: Travel or holiday
- **CAR_PURCHASE**: Car purchase
- **HOME_IMPROVEMENT**: Home improvement
- **INHERITANCE**: Leaving an inheritance
- **BUSINESS**: Business investment
- **OTHER**: Other goal

### Priority Level
- **High**: High priority
- **Medium**: Medium priority
- **Low**: Low priority

### Frequency
- **Weekly**: Weekly
- **Fortnightly**: Fortnightly (every 2 weeks)
- **Monthly**: Monthly
- **Quarterly**: Quarterly (every 3 months)
- **Half-Yearly**: Half-yearly (every 6 months)
- **Annual**: Annual (yearly)
- **One-off**: One-off (single payment)

