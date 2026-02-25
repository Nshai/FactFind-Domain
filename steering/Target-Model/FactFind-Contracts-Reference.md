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
- [13.17 Asset Contract](#1317-asset-contract)
- [13.18 Liability Contract](#1318-liability-contract)
- [13.19 Employment Contract](#1319-employment-contract)
- [13.20 Budget Contract](#1320-budget-contract)
- [13.21 Expenditure Contract](#1321-expenditure-contract)
- [13.23 Credit History Contract](#1323-credit-history-contract)
- [13.24 Property Detail Contract](#1324-property-detail-contract)
- [13.26 Notes Contract](#1326-notes-contract)
- [13.27 Dependant Contract](#1327-dependant-contract)
- [13.28 Income Changes Contract](#1328-income-changes-contract)
- [13.29 Expenditure Changes Contract](#1329-expenditure-changes-contract)
- [13.30 Affordability Contract](#1330-affordability-contract)
- [13.31 Net Worth Contract](#1331-net-worth-contract)
- [13.32 Contact Contract](#1332-contact-contract)
- [13.32 Attitude to Risk (ATR) Contract](#1332-attitude-to-risk-atr-contract)
- [13.33 Professional Contact Contract](#1333-professional-contact-contract)
- [13.34 Vulnerability Contract](#1334-vulnerability-contract)
- [13.35 Marketing Preferences Contract](#1335-marketing-preferences-contract)
- [13.36 DPA Policy Agreement Contract](#1336-dpa-policy-agreement-contract)
- [13.37 Financial Profile Contract](#1337-financial-profile-contract)
- [13.38 Client Relationship Contract](#1338-client-relationship-contract)
- [13.39 Estate Planning - Will Contract](#1339-estate-planning---will-contract)
- [13.40 Estate Planning - Lasting Power of Attorney (LPA) Contract](#1340-estate-planning---lasting-power-of-attorney-lpa-contract)
- [13.41 Estate Planning - Gift Contract](#1341-estate-planning---gift-contract)
- [13.42 Estate Planning - Trust Contract](#1342-estate-planning---trust-contract)
- [13.43 Identity Verification Contract](#1343-identity-verification-contract)
- [13.44 Arrangement - Mortgage Contract](#1344-arrangement---mortgage-contract)
- [13.44A Investment Contract](#1344a-investment-contract)
- [13.45 Arrangement - Investment Contract (General Investment Account)](#1345-arrangement---investment-contract-general-investment-account)
- [13.46 Arrangement - Protection Contract (Life Assurance)](#1346-arrangement---protection-contract-life-assurance)
- [13.47 Arrangement - Pension Contract (Personal Pension)](#1347-arrangement---pension-contract-personal-pension)

### Appendices
- [Appendix A: Common Value Types](#appendix-a-common-value-types)
- [Appendix B: Common Enum Values](#appendix-b-common-enum-values)

---


## 13.1 Client Contract

### Business Purpose

Represents an individual person, company, or trust that receives financial advice. This is the core entity that links all fact find information together.

### Key Features

- Supports three client types: Person (individual), Corporate (company), and Trust
- Captures core demographic and administrative information
- Enables joint client relationships (married couples, partners)
- Links to related resources via dedicated APIs (addresses, contacts, vulnerabilities, etc.)
- Maintains territorial profile (residency, domicile, citizenship)

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adviser | Reference Link | The adviser responsible for this client | Complex object |
| clientCategory | Text | Client category (e.g., HighNetWorth, Mass Market) | HighNetWorth |
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| clientSegment | Text | Client segment classification (A, B, C, D for prioritization) | A |
| clientSegmentDate | Date | Client segment classification (A, B, C, D for prioritization) | 2020-01-15 |
| clientType | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |
| createdAt | Date | When this record was created in the system | 2020-01-15T10:30:00Z |
| createdBy | Complex Data | User who created this record | Complex object |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 8496 |
| isHeadOfFamilyGroup | Yes/No | Whether this client is the primary contact for the family group | Yes |
| isJoint | Yes/No | Whether this client is part of a joint (couple) fact find | Yes |
| isMatchingServiceProposition | Yes/No | Whether this client requires matching service due to vulnerability | No |
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

**adviser:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ADV001 |
| id | Number | Unique system identifier for this record | 8724 |
| name | Text | First name (given name) | Jane Doe |

**createdBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8724 |
| name | Text | First name (given name) | Jane Doe |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Number | Unique system identifier for this record | 2405 |
| status | Text | Current status of the goal | INP |

**officeRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | LON |
| id | Number | Unique system identifier for this record | 3797 |
| name | Text | First name (given name) | London Office |

**paraplannerRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | PP001 |
| id | Number | Unique system identifier for this record | 8082 |
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

**spouseRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001235 |
| id | Number | Unique system identifier for this record | 912 |
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
| id | Number | Unique system identifier for this record | 8724 |
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
| adviser | Reference Link | The adviser responsible for this client | Complex object |
| assetHoldings | Complex Data |  | Complex object |
| atrAssessment | Complex Data |  | Complex object |
| client | Reference Link |  | Complex object |
| completionStatus | Complex Data | Current status of the goal | Complex object |
| createdAt | Date | When this record was created in the system | 2026-02-16T14:30:00Z |
| customQuestions | List of Complex Data |  | List with 1 item(s) |
| factFindNumber | Text |  | FF001234 |
| financialSummary | Complex Data |  | Complex object |
| id | Number | Unique system identifier for this record | 2405 |
| investmentCapacity | Complex Data | City/town | Complex object |
| jointClientRef | Reference Link |  | Complex object |
| meetingDetails | Complex Data |  | Complex object |
| notes | Text |  | Clients seeking to consolidate pensions and review... |
| updatedAt | Date | When this record was last modified | 2026-02-16T15:45:00Z |

#### Nested Field Groups

**adviser:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ADV001 |
| id | Number | Unique system identifier for this record | 8724 |
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
| adviser | Complex Data | The adviser responsible for this client | Complex object |
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
| id | Number | Unique system identifier for this record | 483 |
| name | Text | First name (given name) | FCA Standard ATR 2025 |
| version | Text |  | 5.0 |

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Number | Unique system identifier for this record | 8496 |
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
| id | Number | Unique system identifier for this record | 912 |
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
| client | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2020-01-15T10:30:00Z |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 1392 |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Number | Unique system identifier for this record | 8496 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Number | Unique system identifier for this record | 2405 |
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
| client | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-02-16T14:30:00Z |
| description | Text | Description of the goal | Salary from Tech Corp Ltd |
| employment | Reference Link |  | Complex object |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| frequency | Selection | How often (Monthly, Annual, etc.) | Complex object |
| grossAmount | Currency Amount | Amount spent | Complex object |
| id | Number | Unique system identifier for this record | 5156 |
| incomePeriod | Complex Data |  | Complex object |
| incomeType | Text |  | Employment |
| isTaxable | Yes/No | Is this income taxable? Some income like Child Benefit or ISA interest may be tax-free. | Yes |
| asset | Link to Asset | Link to the asset (property, investment, business) that generates this income. For example, rental income links to the rental property. | Property #5001 - Rental Property on High Street |
| isGuaranteed | Yes/No |  | Yes |
| isOngoing | Yes/No |  | Yes |
| isPrimary | Yes/No | Whether this is the primary/main address | Yes |
| nationalInsuranceDeducted | Currency Amount |  | Complex object |
| netAmount | Currency Amount | Amount spent | Complex object |
| notes | Text |  | Annual bonus typically £10k |
| taxDeducted | Currency Amount |  | Complex object |
| updatedAt | Date | When this record was last modified | 2026-02-16T15:45:00Z |

#### Nested Field Groups

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Number | Unique system identifier for this record | 8496 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**employment:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| employerName | Text | Name of the employer | Tech Corp Ltd |
| id | Number | Unique system identifier for this record | 8695 |
| status | Text | Current status of the goal | Current |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF001234 |
| id | Number | Unique system identifier for this record | 2405 |
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

**asset:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique identifier for the asset that generates this income | 5001 |
| href | Text | Link to the asset resource | /api/v2/factfinds/679/assets/5001 |
| assetType | Text | Type of asset (Property, Investment, Business, Other) | Property |
| description | Text | Description of the asset | Rental Property - 45 High Street, Manchester |-------------|-----------|-------------|
| Rental Income | Property | Links to residential or commercial property generating rental income |
| Dividend Income | Investment | Links to stocks, shares, or investment accounts paying dividends |
| Interest Income | Savings/Investment | Links to bank accounts, bonds, or other interest-bearing investments |
| Business Profit | Business | Links to self-employed business or company generating profit distributions |

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
| adviser | Reference Link | The adviser responsible for this client | Complex object |
| arrangementCategory | Text | Type of arrangement (INVESTMENT, PENSION, MORTGAGE, PROTECTION) | PENSION |
| arrangementNumber | Text |  | ARR123456 |
| arrangementPeriod | Complex Data |  | Complex object |
| owners | List of Complex Data | Who owns this arrangement | List with 1 item(s) |
| contributionFrequency | Selection | How often (Monthly, Annual, etc.) | Complex object |
| createdAt | Date | When this record was created in the system | 2015-01-01T10:00:00Z |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| expectedRetirementAge | Number | Current age (calculated from date of birth) | 67 |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| hasGuaranteedAnnuityRate | Yes/No |  | No |
| hasProtectedTaxFreeAmount | Yes/No | Whether pension has protected tax-free amount | No |
| id | Number | Unique system identifier for this record | 2348 |
| isInDrawdown | Yes/No |  | No |
| isSalarySacrifice | Yes/No | Whether pension contributions are via salary sacrifice | No |
| notes | Text |  | Consolidated from previous workplace pensions |
| pensionType | Text | Sub-type when arrangementCategory=PENSION | PERSONAL_PENSION |
| investmentType | Text | Sub-type when arrangementCategory=INVESTMENT | STOCKS_SHARES_ISA |
| mortgageType | Text | Sub-type when arrangementCategory=MORTGAGE | RESIDENTIAL |
| protectionType | Text | Sub-type when arrangementCategory=PROTECTION | LIFE_ASSURANCE |
| policyNumber | Text | Policy or account number | POL123456 |
| productName | Text | Name of the financial product | ABC SIPP |
| projectedValueAtRetirement | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| provider | Reference Link | Unique system identifier for this record | Complex object |
| regularContribution | Currency Amount |  | Complex object |
| status | Text | Current status of the goal | ACT |
| updatedAt | Date | When this record was last modified | 2026-02-16T14:30:00Z |
| valuationDate | Date |  | 2026-02-01 |

#### Nested Field Groups

**adviser:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ADV001 |
| id | Number | Unique system identifier for this record | 8724 |
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

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Number | Unique system identifier for this record | 2405 |
| status | Text | Current status of the goal | INP |

**projectedValueAtRetirement:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 450000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**provider:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| frnNumber | Text |  | 123456 |
| id | Number | Unique system identifier for this record | 577 |
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

- arrangementCategory is required
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
| client | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-02-16T14:30:00Z |
| currentSavings | Currency Amount |  | Complex object |
| description | Text | Description of the goal | Build sufficient pension pot to support £40k annua... |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| goalName | Text |  | Comfortable retirement at age 65 |
| goalType | Text | Type of goal (Retirement, Education, Property Purchase, etc.) | Retirement |
| id | Number | Unique system identifier for this record | 9019 |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Number | Unique system identifier for this record | 8496 |
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

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Number | Unique system identifier for this record | 2405 |
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
| adviser | Reference Link | The adviser responsible for this client | Complex object |
| assessmentDate | Date |  | 2026-02-16 |
| assessmentType | Text |  | ATR |
| attitudeToRiskRating | Text |  | Balanced |
| attitudeToRiskScore | Number |  | 6 |
| capacityForLossRating | Text | City/town | Medium |
| capacityForLossScore | Number | City/town | 7 |
| client | Reference Link |  | Complex object |
| comfortableWithVolatility | Yes/No |  | Yes |
| createdAt | Date | When this record was created in the system | 2026-02-16T14:30:00Z |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| hasInvestedBefore | Yes/No |  | Yes |
| id | Number | Unique system identifier for this record | riskprofile-999 |
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

**adviser:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ADV001 |
| id | Number | Unique system identifier for this record | 8724 |
| name | Text | First name (given name) | Jane Doe |

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Number | Unique system identifier for this record | 8496 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Number | Unique system identifier for this record | 2405 |
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
| adviser | Reference Link | The adviser responsible for this client | Complex object |
| annualIsaAllowance | Currency Amount |  | Complex object |
| annualizedReturn | Number |  | 5.87 |
| arrangementCategory | Text | Expenditure category (Housing, Transport, Food, etc.) | INVESTMENT |
| arrangementId | Text | Unique system identifier for this record | arrangement-456 |
| assetAllocation | Complex Data |  | Complex object |
| benchmarkIndex | Text |  | FTSE All-World Index |
| charges | Complex Data |  | Complex object |
| client | Reference Link |  | Complex object |
| contributions | List of Complex Data | Regular contributions being made | List with 2 item(s) |
| costBasis | Currency Amount |  | Complex object |
| createdAt | Date | When this record was created in the system | 2020-04-06T10:00:00Z |
| createdBy | Complex Data | User who created this record | Complex object |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| documents | List of Complex Data |  | List with 1 item(s) |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| geographicAllocation | Complex Data |  | Complex object |
| holdings | List of Complex Data |  | List with 4 item(s) |
| id | Number | Unique system identifier for this record | 9140 |
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

**adviser:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ADV001 |
| id | Number | Unique system identifier for this record | 8724 |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Number | Unique system identifier for this record | 8496 |
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
| id | Number | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

**currentValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 185000.0 |
| currency | Selection |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| display | Text |  | British Pound |
| symbol | Text |  | £ |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Number | Unique system identifier for this record | 4066 |
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
| id | Number | Unique system identifier for this record | user-789 |
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
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| floorArea | Complex Data |  | Complex object |
| groundRent | Currency Amount |  | Complex object |
| id | Number | Unique system identifier for this record | 5754 |
| improvements | List of Complex Data |  | List with 2 item(s) |
| intendToRefinance | Yes/No |  | No |
| intendToSell | Yes/No |  | No |
| isBuyToLet | Yes/No |  | Yes |
| isJointOwnership | Yes/No | Whether this client is part of a joint (couple) fact find | No |
| isPrimaryResidence | Yes/No | Unique system identifier for this record | No |
| isRented | Yes/No |  | Yes |
| jointOwnershipType | Text | Who owns this arrangement | None |
| leaseRemaining | Number |  | 95 |
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
| id | Number | Unique system identifier for this record | user-789 |
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

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Number | Unique system identifier for this record | 4066 |
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
| id | Number | Unique system identifier for this record | user-789 |
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
| adviser | Reference Link | The adviser responsible for this client | Complex object |
| broker | Complex Data |  | Complex object |
| client | Reference Link |  | Complex object |
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
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| holdings | Complex Data |  | Complex object |
| id | Number | Unique system identifier for this record | equity-321 |
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

**adviser:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Standard Occupational Classification (SOC) code | ADV001 |
| id | Number | Unique system identifier for this record | 8724 |
| name | Text | First name (given name) | Jane Doe |

**broker:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| accountNumber | Text |  | HL-12345678 |
| name | Text | First name (given name) | Hargreaves Lansdown |

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Number | Unique system identifier for this record | 8496 |
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
| id | Number | Unique system identifier for this record | user-789 |
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

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Number | Unique system identifier for this record | 4066 |
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
| id | Number | Unique system identifier for this record | user-789 |
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
| client | Reference Link |  | Complex object |
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
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | idverify-987 |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientNumber | Text | Client reference number assigned by your organization | C00001234 |
| id | Number | Unique system identifier for this record | 8496 |
| name | Text | First name (given name) | John Smith |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Person |

**createdBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| factFindNumber | Text |  | FF-2025-00123 |
| id | Number | Unique system identifier for this record | 4066 |
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
| id | Number | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |

**verifiedBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | user-789 |
| name | Text | First name (given name) | Jane Doe |
| role | Text |  | Compliance Officer |

---

## 13.17 Asset Contract
### Overview
The `Asset` contract represents a client's asset (property, business, cash, investments, etc.) with ownership, valuation, and tax planning information.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| arrangement | Reference Link |  | Complex object |
| assetType | Text |  | PROPERTY |
| createdAt | Date | When this record was created in the system | 2026-02-01T10:00:00Z |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| description | Text | Description of the goal | Primary Residence - 123 Main Street |
| dividends | Complex Data | Unique system identifier for this record | Complex object |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 1234 |
| income | Reference Link |  | Complex object |
| isBusinessAssetDisposalRelief | Yes/No |  | No |
| isBusinessReliefQualifying | Yes/No |  | No |
| isFreeFromInheritanceTax | Yes/No |  | No |
| isHolding | Yes/No |  | No |
| isVisibleToClient | Yes/No |  | Yes |
| notes | Text |  | Rental property - managed by external agent |
| originalValue | Currency Amount | The contact value (email address, phone number, etc.) | Complex object |
| ownership | Complex Data | Who owns this arrangement | Complex object |
| property | Reference Link |  | Complex object |
| purchasedOn | Date |  | 2024-05-10 |
| rentalExpenses | Currency Amount |  | Complex object |
| rnrbEligibility | Text |  | Not Eligible |
| updatedAt | Date | When this record was last modified | 2026-02-15T14:30:00Z |
| valuationBasis | Text |  | Comparable Sales |
| valuedOn | Date | The contact value (email address, phone number, etc.) | 2026-01-15 |

#### Nested Field Groups

**arrangement:**

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

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**income:**

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

**property:**

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
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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

**factfind:**

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
| client | Reference Link |  | Complex object |
| id | Number | Unique system identifier for this record | 8496 |
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

Represents comprehensive employment records for clients, including current and historical employment, self-employed income with 3 years of accounts, and all information required for UK mortgage applications and affordability assessments.

**Why This Matters:**
- Critical for mortgage applications (employment verification)
- Self-employed income tracking for affordability calculations
- Continuous employment history affects lending decisions
- Probation periods impact mortgage offers
- Retirement age affects maximum mortgage term

### Key Features

- **Comprehensive Employment Tracking** - Full employment history with dates, status, occupation
- **Self-Employed Income Support** - Track 3 years of accounts for mortgage applications
- **Business Type Classification** - Sole trader, limited company, partnership, LLP
- **Mortgage Application Ready** - Captures all data UK lenders require
- **Affordability Integration** - Employment feeds directly into affordability assessments
- **Probation Period Tracking** - Critical for lending decisions
- **Tax Rate Capture** - For net income calculations
- **Continuous Employment** - Auto-calculated for lending assessments

### When to Use This Contract

**Standard Employment (PAYE):**
- Recording current permanent employment
- Historical employment records for timeline
- Part-time or contract employment

**Self-Employed:**
- Sole trader business with 3 years accounts
- Limited company director with salary + dividends
- Partnership income
- LLP member income

**Other Situations:**
- Retired clients (for pension income tracking)
- Clients on maternity/paternity leave
- Unemployed (for mortgage application context)
- Contract workers with irregular income

### Employment Status Types

| Status | Description | Mortgage Impact |
|--------|-------------|-----------------|
| **Employed** | Standard PAYE employment | Best - standard assessment, 3 months payslips required |
| **SelfEmployed** | Self-employed/sole trader | More scrutiny - 2-3 years accounts + SA302s required |
| **CompanyDirector** | Director of limited company | Complex - accounts + dividend vouchers + shareholding proof |
| **ContractWorker** | Fixed-term contracts | Specialist lenders - contract history required |
| **Retired** | Retired from employment | Age-restricted - pension income must be guaranteed |
| **Unemployed** | Currently unemployed | Generally declined unless alternative income shown |
| **Houseperson** | Home maker | No income - joint application typically required |
| **Student** | Full-time student | Not suitable for standard mortgages |
| **MaternityLeave** | On maternity/paternity | Depends on return date - contract showing return required |
| **LongTermIllness** | Unable to work | Depends on income protection/benefits |

### Self-Employed Business Types

**Only applicable when Employment Status = "SelfEmployed":**

| Business Type | Description | Income Assessment Method |
|---------------|-------------|------------------------|
| **Sole Trader** | Individual trading | Net profit from SA302 forms, average of 2 years |
| **Private Limited Company** | Ltd company (director/shareholder) | Salary + dividends + retained profits, average of 2 years |
| **Partnership** | Business partnership | Share of partnership profits from SA302, average of 2 years |
| **Limited Liability Partnership** | LLP structure | Share of LLP profits from SA302, average of 2 years |

### Fields

#### Identification

| Field Name | Type | Description | Example Value |
|------------|------|-------------|---------------|
| **id** | Number | System-assigned employment record ID | 567 |
| **factfindRef** | Reference | Reference to parent fact find | FactFind #679 |
| **client** | Reference | Reference to the client | Client #346 |

#### Employment Details

| Field Name | Type | Description | Example Value |
|------------|------|-------------|---------------|
| **employmentStatus** | Status | Current employment status (see types above) | Employed |
| **employmentBusinessType** | Status | Business type (only for self-employed) | Private Limited Company |
| **employmentStatusDescription** | Text | Additional employment details | "Managing Director of software company" |
| **occupation** | Text | Job title or occupation | Software Consultant / Director |
| **employer** | Text | Employer or business name | Smith Tech Solutions Ltd |
| **industryType** | Text | Industry or sector | Information Technology |
| **highestTaxRate** | Text | Marginal tax rate (20, 40, 45) | 40 |

#### Employment Period

| Field Name | Type | Description | Example Value |
|------------|------|-------------|---------------|
| **startsOn** | Date | Employment start date | 2018-04-01 |
| **endsOn** | Date | Employment end date (blank if current) | (blank - current employment) |
| **isCurrentEmployment** | Yes/No | Is this current employment? (auto-calculated) | Yes |
| **continuousEmploymentMonths** | Number | Months of continuous employment (auto-calculated) | 70 months |
| **inProbation** | Yes/No | Currently in probation period? | No |
| **probationPeriodInMonths** | Number | Length of probation period | 6 months |
| **intendedRetirementAge** | Number | Planned retirement age | 65 |

#### Employer Address

| Field Name | Type | Description | Example Value |
|------------|------|-------------|---------------|
| **address.line1** | Text | Address line 1 | Tech Hub Building |
| **address.line2** | Text | Address line 2 | 45 Innovation Drive |
| **address.locality** | Text | City/town | London |
| **address.postalCode** | Text | Postal code | EC2A 4BX |
| **address.county** | Text | County | Greater London |
| **address.country** | Text | Country | United Kingdom |

#### Self-Employed Income (3 Years of Accounts)

**Only populated for self-employed clients. Used for mortgage affordability calculations.**

**Most Recent Year:**

| Field Name | Type | Description | Example Value |
|------------|------|-------------|---------------|
| **grossProfit** | Money | Gross profit for the year | £180,000.00 |
| **netProfit** | Money | Net profit after expenses | £150,000.00 |
| **shareOfCompanyProfit** | Money | Individual's share of profit | £180,000.00 |
| **grossDividend** | Money | Gross dividend received | £60,000.00 |
| **netDividend** | Money | Net dividend after tax | £54,000.00 |
| **grossSalary** | Money | Gross salary/director's salary | £25,000.00 |
| **netSalary** | Money | Net salary after tax | £20,000.00 |
| **yearEnd** | Date | Accounting year end | 2024-03-31 |
| **includeInAffordability** | Yes/No | Use in affordability calculations | Yes |

**Year 2 and Year 3:** Same fields as above for previous years' accounts.

**Computed Field:**
- **recentGrossPreTaxProfit** - Most recent gross profit (auto-calculated from most recent year)

#### Related Resources

| Field Name | Type | Description | Example Value |
|------------|------|-------------|---------------|
| **incomesHref** | Link | Link to related income records | /api/v2/factfinds/679/clients/456/incomes?filter=... |

#### Audit Trail

| Field Name | Type | Description | Example Value |
|------------|------|-------------|---------------|
| **createdAt** | DateTime | When this record was created | 2026-01-15T10:00:00Z |
| **updatedAt** | DateTime | When this record was last updated | 2026-02-18T14:30:00Z |

---

### Relationships

This contract connects to:

- **Belongs to:** Client - Each employment belongs to one client
- **Belongs to:** FactFind - Employment is part of the overall fact find
- **Links to:** Income records - Employment generates income records
- **Used by:** Affordability assessments - Employment income feeds affordability calculations
- **Referenced in:** Mortgage applications - Lenders verify employment details

---

### Self-Employed Income Explained

**Why 3 Years of Accounts?**

UK mortgage lenders require 2-3 years of accounts for self-employed applicants to:
- Verify sustainable income levels
- Identify income trends (increasing/decreasing)
- Calculate average income for affordability
- Assess business stability and viability
- Comply with FCA responsible lending rules

**How Lenders Calculate Affordability:**

**Sole Traders:**
```
Average Net Profit = (Year 1 Net Profit + Year 2 Net Profit) / 2
Annual Income = Average Net Profit
```

**Limited Company Directors:**
```
Year 1 Total = Net Salary + Net Dividends + Share of Retained Profits
Year 2 Total = Net Salary + Net Dividends + Share of Retained Profits
Average Income = (Year 1 Total + Year 2 Total) / 2
```

**Example:**
- Year 1 Net Profit: £150,000
- Year 2 Net Profit: £135,000
- **Average: £142,500** (used for mortgage affordability)
- Maximum mortgage at 4.5x income: £641,250

**Evidence Required:**
- Certified accounts (prepared by qualified accountant)
- SA302 tax calculations from HMRC
- Tax year overview from HMRC
- Business bank statements
- Proof of business ownership

---

### Business Validation Rules

**Required Fields:**
- Employment Status must be selected
- Employment Start Date is required
- Country is required (if address provided)

**Conditional Requirements:**
- **If Self-Employed:** Business Type must be selected
- **If Self-Employed:** Most Recent Year accounts must be complete
- **If In Probation:** Probation period length should be provided

**Date Rules:**
- Start date cannot be in the future
- End date must be after start date (if provided)
- Year end dates must be in the past
- Account years must be in chronological order (most recent first)

**Self-Employed Income Rules:**
- Must have at least Most Recent Year accounts
- Cannot have duplicate year end dates
- At least one financial figure per year
- Typically only most recent year included in affordability

**Numeric Rules:**
- Retirement age must be between 50-99 years
- Probation period must be 1-99 months
- Continuous employment auto-calculated (must be >= 0)
- All money amounts must be >= 0

**Business Logic:**
- Current employment: End date must be blank
- Historical employment: End date must be provided
- Continuous employment months: Auto-calculated from dates
- Recent gross profit: Auto-calculated from most recent year

---

### Mortgage Application Requirements by Employment Status

#### Employed (PAYE)

**Typical Requirements:**
- 3 months' recent payslips
- Employment contract or confirmation letter
- 12+ months continuous employment preferred
- Out of probation (or probation end date confirmed)
- Permanent contract (not fixed-term)

**Affordability Calculation:**
- Basic salary used
- Regular bonuses/commission averaged (if 2+ years history)
- Overtime averaged (if regular and sustainable)

#### Self-Employed

**Typical Requirements:**
- 2-3 years certified accounts
- SA302 tax calculations from HMRC
- Tax year overview from HMRC
- Business bank statements (3-6 months)
- Proof of business ownership/trading

**Affordability Calculation:**
- Average of 2 years net profit
- Some lenders use lower of 2 years if declining
- Accountant certification essential

**Probation Period Rules:**
- Most lenders: Must be out of probation
- Some lenders: Accept if probation ends within 3 months
- Require written confirmation of probation completion
- May require higher deposit during probation

**Retirement Age Impact:**
- Mortgage term cannot extend past retirement age
- State pension age: 66-67 (may increase)
- Early retirement reduces maximum term
- Lenders may use state pension age if intended age not provided

**Continuous Employment:**
- Longer employment = lower lending risk
- Gaps require explanation
- 12+ months continuous preferred
- 3+ years history ideal
- Career changes may need justification

---

### Common Business Scenarios

**Scenario 1: Standard Employed Mortgage Application**
- Status: Employed (PAYE)
- Employment: 11 years continuous
- Salary: £65,000
- Result: Standard assessment, best rates available

**Scenario 2: Self-Employed Limited Company Director**
- Status: Self-Employed
- Business Type: Private Limited Company
- Year 1: £150k net profit, Year 2: £135k net profit
- Average: £142,500
- Result: 2 years accounts required, SA302s needed, max mortgage ~£640k at 4.5x

**Scenario 3: Probation Period**
- Status: Employed
- Started: 2 months ago
- In Probation: Yes (6 month probation)
- Result: Most lenders decline, recommend waiting 4 months until probation cleared

**Scenario 4: Recently Self-Employed**
- Status: Self-Employed
- Trading: 8 months
- Accounts: Only 1 year available
- Result: Need 2 years accounts, recommend waiting 16 months or specialist lender

**Scenario 5: Contract Worker**
- Status: Contract Worker
- Contract Length: 12 months rolling
- Day Rate: £500
- Result: Specialist lender needed, contract history required, may need 2+ years contracts

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
| client | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-01-10T09:00:00Z |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8496 |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

---

## 13.21 Expenditure Contract

### Business Purpose

Represents a single expenditure item (outgoing payment) for a client, used for budget planning and affordability assessments. Each expenditure represents a specific payment such as mortgage, rent, utilities, food shopping, or other regular expenses.

### Key Features

- Tracks individual expenditure items by type and frequency
- Links to liabilities being repaid (e.g., mortgage, credit card payments)
- Supports debt consolidation scenarios with consolidation flag
- Categorizes expenditure for affordability assessment (Essential vs Non-Essential)
- Period tracking with start and end dates

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| id | Number | Unique identifier for the expenditure | 1001 |
| href | Text | Link to this expenditure resource | /api/v2/factfinds/234/clients/456/expenditures/1001 |
| factfind | Link to FactFind | The fact-find that this expenditure belongs to | FactFind #234 |
| client | Link to Client | The client who has this expenditure | Client #456 |
| description | Text | Description of the expenditure | Monthly mortgage payment |
| expenditureType | Selection | Type/category of expenditure | Mortgage, Rent, Council Tax, etc. |
| netAmount | Currency Amount | Amount paid (after tax if applicable) - includes currency code, name, and symbol | £1,500.00 (GBP - British Pound) |
| frequency | Selection | How often the payment is made | Monthly, Weekly, Annually |
| startsOn | Date | When the expenditure started | 2025-01-01 |
| endsOn | Date | When the expenditure ends (if known) | null (ongoing) |
| isConsolidated | Yes/No | Is this part of a debt consolidation? | No |
| isLiabilityToBeRepaid | Yes/No | Is this paying off a specific debt? | Yes |
| liability | Link to Liability | The debt/liability being repaid | Liability #5001 - Mortgage |
| notes | Text | Additional notes | Fixed rate until 2027 |
| createdAt | Date | When this record was created in the system | 2026-01-15T10:00:00Z |
| updatedAt | Date | When this record was last modified | 2026-02-18T14:30:00Z |

#### Nested Field Groups

**factfind:**

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| id | Number | FactFind identifier | 234 |
| href | Text | Link to the fact-find | /api/v2/factfinds/234 |

**client:**

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| id | Number | Client identifier | 456 |
| href | Text | Link to the client | /api/v2/factfinds/234/clients/456 |

**netAmount:**

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| amount | Number | The monetary amount | 1500.00 |
| currency.code | Text | ISO 4217 currency code | GBP |
| currency.display | Text | Full currency name | British Pound |
| currency.symbol | Text | Currency symbol | £ |

**liability (optional):**

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| id | Number | Liability identifier | 5001 |
| href | Text | Link to the liability | /api/v2/factfinds/234/liabilities/5001 |
| description | Text | Description of the liability | Residential Mortgage - Main Home |

---

### Expenditure Types

Expenditure types are organized into three categories based on their importance for affordability assessments:

#### Basic Essential Expenditure

| Expenditure Type | Description | Category |
|-----------------|-------------|----------|
| Rent | Monthly or periodic rent payments | Essential |
| Mortgage | Mortgage payment (principal + interest) | Essential |
| Council Tax | Local authority council tax | Essential |
| Gas | Gas utilities | Essential |
| Electricity | Electricity utilities | Essential |
| Water | Water and sewerage charges | Essential |
| Telephone/Mobile | Phone and mobile services | Essential |
| Food & Personal Care | Groceries, toiletries, personal care | Essential |
| Car/Travelling Expenses | Vehicle running costs, fuel, public transport | Essential |
| Housekeeping | General household running costs | Essential |
| Ground Rent/Service charge | Service charges for leasehold properties | Essential |

#### Basic Quality of Living

| Expenditure Type | Description | Category |
|-----------------|-------------|----------|
| Clothing | Clothing and footwear | Quality of Living |
| Furniture/Appliances/Repairs | Household goods and repairs | Quality of Living |
| TV/Satellite/Internet/Basic Recreation | Media subscriptions and basic entertainment | Quality of Living |
| Pension | Personal pension contributions | Quality of Living |
| School Fee/Childcare | Education and childcare costs | Quality of Living |

#### Non-Essential Outgoings

| Expenditure Type | Description | Category |
|-----------------|-------------|----------|
| Sports and Recreation | Sports memberships, hobbies | Non-Essential |
| Holidays | Annual holidays and travel | Non-Essential |
| Entertainment | Dining out, cinema, events | Non-Essential |
| Life/General Assurance Premium | Insurance premiums | Non-Essential |
| Investments | Investment contributions | Non-Essential |
| Credit Card | Credit card payment (minimum or regular) | Non-Essential |

---

### Relationships

This contract connects to:

- Belongs to a Client
- May link to a Liability (if repaying debt)
- Used by Affordability Assessment
- Part of Budget calculations

### Business Validation Rules

- Every expenditure must have a type and amount
- Amount must be greater than zero
- Frequency is required (Daily, Weekly, Fortnightly, Monthly, Quarterly, Annually)
- If end date is provided, it must be after start date
- Essential expenditures (rent, mortgage, utilities) are prioritized for affordability
- If paying off a debt, link to the liability for tracking
- Consolidated debts are flagged for refinancing scenarios
- Frequency must match how often the payment is actually made

### Affordability Assessment Impact

**How Expenditure Categories Affect Affordability:**

1. **Basic Essential Expenditure:**
   - Always included in minimum expenditure calculations
   - Cannot be reduced or excluded in stress testing
   - Forms the baseline for sustainable living costs
   - Lenders verify against industry benchmarks

2. **Basic Quality of Living:**
   - Typically included in standard affordability models
   - Represents normal standard of living
   - May be adjusted based on household size
   - Pension contributions maintain retirement quality

3. **Non-Essential Outgoings:**
   - May be excluded or reduced in affordability stress tests
   - Demonstrates capacity to absorb payment increases
   - Can be forgone temporarily in financial difficulty
   - Shows discretionary spending flexibility

**Regulatory Context:**
- FCA MCOB (Mortgage Conduct of Business) requires thorough expenditure assessment
- Lenders must ensure borrowers can afford payments under stressed scenarios
- Consumer Duty requires fair treatment and consideration of actual living costs
- Expenditure verification may require bank statements or evidence

---

## 13.23 Credit History Contract

### Overview
The `CreditHistory` contract represents a comprehensive record of a client's credit history, including credit scores from Credit Reference Agencies (CRAs), adverse credit events, payment history, and mortgage lending suitability assessments. This information is essential for affordability assessments and mortgage lending decisions, ensuring compliance with FCA regulations.

**Business Purpose:**
- Record credit scores from major providers (Experian, Equifax, TransUnion)
- Track adverse credit events (CCJs, defaults, IVA, bankruptcy, arrears)
- Assess mortgage suitability based on credit profile
- Support FCA-compliant affordability assessments for mortgage lending
- Document payment history and creditworthiness

### Fields

#### Identification

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this credit history record | 334 |
| href | Text | Web link to access this credit history record | /api/v2/factfinds/679/clients/346/credit-history/334 |
| factfind | Reference Link | Link to the FactFind this credit history belongs to | See factfindRef below |
| client | Reference Link | Link to the client this credit history belongs to | See client below |

#### Credit Score Assessment

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| creditScore | Complex Data | Credit score information from Credit Reference Agency | See creditScore below |

**creditScore:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| score | Number | Credit score value (0-999 for Experian, 0-700 for Equifax, 0-710 for TransUnion) | 780 |
| maxScore | Number | Maximum possible score for this provider | 999 |
| rating | Selection | Credit rating category: Excellent, Good, Fair, Poor, Very Poor | Excellent |
| provider | Selection | Credit Reference Agency: Experian, Equifax, TransUnion | Experian |
| checkedDate | Date | Date when credit score was obtained | 2026-01-15 |

#### Adverse Credit Indicators (Summary)

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasAdverseCredit | Yes/No | Does the client have any adverse credit events on their record? | No |
| hasCCJ | Yes/No | Does the client have any County Court Judgments? | No |
| hasBeenRefusedCredit | Yes/No | Has the client been refused credit in the past? | No |
| ivaHistory | Yes/No | Does the client have an Individual Voluntary Arrangement (IVA) history? | No |
| hasDefault | Yes/No | Does the client have any defaults registered on their credit file? | No |
| hasBankruptcyHistory | Yes/No | Does the client have bankruptcy history? | No |
| hasArrears | Yes/No | Does the client currently have or have had payment arrears? | No |

#### Adverse Credit Events (Detailed Records)

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| adverseCreditEvents | List of Events | Detailed list of adverse credit events with financial and timeline information | See adverseCreditEvents below |

**Each Adverse Credit Event contains:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| type | Selection | Type of adverse event: CCJ, Default, IVA, Bankruptcy, Arrears, Repossession, Debt Relief Order | Default |
| registeredOn | Date/Time | Date and time when event was registered with Credit Reference Agencies | 2020-06-15T00:00:00Z |
| satisfiedOrClearedOn | Date/Time | Date and time when the debt was satisfied or cleared | 2023-12-20T00:00:00Z |
| reposessedOn | Date/Time | Date of property repossession (if applicable) | 2022-08-10T00:00:00Z |
| dischargedOn | Date/Time | Date when bankruptcy or IVA was discharged | 2023-12-20T00:00:00Z |
| amountRegistered | Currency Amount | Original amount registered when event occurred | £5,000.00 |
| amountOutstanding | Currency Amount | Current outstanding amount (if any) | £3,500.00 |
| isDebtOutstanding | Yes/No | Is the debt still outstanding or has it been fully paid? | Yes |
| numberOfPaymentsMissed | Number | Total number of payments missed for this event | 2 |
| consecutivePaymentsMissed | Number | Maximum number of consecutive payments missed | 2 |
| numberOfPaymentsInArrears | Number | Number of payments currently in arrears | 1 |
| isArrearsClearedUponCompletion | Yes/No | Were arrears cleared when arrangement completed? | Yes |
| yearsMaintained | Number | Number of years successfully maintained after event (for IVA/payment plans) | 5 |
| lender | Text | Name of lender or creditor involved in the adverse event | High Street Bank |
| liability | Reference Link | Link to related liability record (if applicable) | /api/v2/clients/456/liabilities/1001 |
| concurrencyId | Number | System version control number (automatic) | 12 |
| createdAt | Date/Time | When this event record was created in the system | 2026-01-15T10:30:00Z |
| lastUpdatedAt | Date/Time | When this event record was last modified | 2026-01-29T14:45:00Z |

#### Missed Payments Summary

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| missedPayments | Complex Data | Summary of missed payment history | See missedPayments below |

**missedPayments:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| last12Months | Number | Count of missed payments in the last 12 months (0 = clean record) | 0 |
| last6Years | Number | Count of missed payments in the last 6 years (used for mortgage affordability) | 0 |

#### Mortgage Suitability Assessment

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| mortgageSuitability | Complex Data | Automated assessment of mortgage lending eligibility | See mortgageSuitability below |

**mortgageSuitability:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| isEligible | Yes/No | Is the client eligible for standard mortgage products? (automatically calculated) | Yes |
| factors | List of Text | List of factors affecting mortgage suitability (positive or negative) | ["Good credit score (780)", "No adverse credit", "No missed payments"] |

#### Additional Information

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| notes | Text | Free-text notes about credit history, mitigating circumstances, or additional context (max 2000 characters) | Excellent credit history - eligible for best mortgage rates |

#### System Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| createdAt | Date/Time | When this credit history record was created in the system | 2026-01-15T10:00:00Z |
| updatedAt | Date/Time | When this credit history record was last modified | 2026-01-15T10:00:00Z |

#### Reference Link Structures

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique identifier for the FactFind | 679 |
| href | Text | Web link to the FactFind | /api/v2/factfinds/679 |

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique identifier for the client | 1234 |
| href | Text | Web link to the client record | /api/v2/factfinds/679/clients/1234 |

### Business Validation Rules

#### Credit Score Validations
- Credit score must be between 0 and the maximum score for the provider
- Experian: 0-999 (max: 999)
- Equifax: 0-700 (max: 700)
- TransUnion: 0-710 (max: 710)
- Credit score check date cannot be in the future

#### Adverse Credit Logic
- If "Has Adverse Credit" is Yes, there must be at least one adverse credit event recorded
- If there are adverse credit events recorded, "Has Adverse Credit" must be Yes
- Specific indicators (Has CCJ, Has Default, etc.) should match the types of events recorded
- If "Has CCJ" is Yes, there should be at least one event of type "CCJ"
- If "Has Default" is Yes, there should be at least one event of type "Default"

#### Adverse Credit Event Rules
- Event type is required for every adverse credit event
- Registration date cannot be in the future
- If debt is satisfied/cleared, the satisfied date must be after the registration date
- Outstanding amount cannot be more than the originally registered amount
- If debt is not outstanding, the outstanding amount should be £0
- Number of consecutive payments missed cannot exceed total payments missed
- Years maintained must be zero or positive

#### Date and Time Rules
- All dates use standard format (YYYY-MM-DD for dates, YYYY-MM-DDTHH:mm:ssZ for date/times)
- Historical dates should not be in the future
- Satisfaction/discharge dates should be after registration dates

### Understanding Adverse Credit Events

#### CCJ (County Court Judgment)
**What it is:** A court order requiring you to repay a debt to a creditor.

**Impact on Lending:**
- Stays on credit file for 6 years from judgment date
- Can be marked as "satisfied" when paid, which looks better but still shows on file
- CCJs over £500 within the last 3 years typically exclude standard mortgage applications
- May need specialist lender if CCJ is recent or large

**Mortgage Implications:**
- CCJs older than 3 years: Many mainstream lenders will consider
- CCJs under 3 years old: Likely need specialist lender
- Multiple CCJs: Significantly reduced lender options
- Satisfied CCJs: Better than unsatisfied, but still visible

#### Default
**What it is:** Creditor has officially written off the debt after typically 3-6 months of missed payments.

**Impact on Lending:**
- Stays on credit file for 6 years from default date
- Even if paid in full, it remains on the file
- Indicates serious payment difficulties
- Multiple defaults severely restrict lending options

**Mortgage Implications:**
- Recent defaults (under 2 years): Very difficult, specialist lenders only
- Defaults 2-3 years old: Some specialist lenders available
- Defaults 3+ years old: More mainstream options become available
- Satisfied defaults: Better than unsatisfied, shows responsibility

#### IVA (Individual Voluntary Arrangement)
**What it is:** Formal agreement with creditors to pay reduced debt over time (typically 5-6 years).

**Impact on Lending:**
- Stays on credit file for 6 years from approval date
- Alternative to bankruptcy
- Shows formal debt management
- Must be disclosed to lenders

**Mortgage Implications:**
- During IVA: Usually no mortgage applications possible
- After 3 years with good payment record: Some specialist lenders
- After IVA completion: Gradually more options
- Rebuilding credit after IVA essential

#### Bankruptcy
**What it is:** Legal process to write off unaffordable debts.

**Impact on Lending:**
- Typically discharged after 12 months
- Stays on credit file for 6 years from bankruptcy order date
- Most severe form of insolvency
- Public record

**Mortgage Implications:**
- Discharged less than 3 years: Extremely difficult, very limited specialist lenders
- Discharged 3-6 years: Some specialist lenders with higher rates
- After 6 years: Returns to normal consideration
- May always need to disclose to certain lenders

#### Arrears
**What it is:** Being behind on contractual payments (mortgage, loans, credit cards).

**Impact on Lending:**
- Current arrears: Major red flag for lenders
- Historical arrears (cleared): Impact reduces over time
- 2+ months in arrears triggers serious lender concerns
- Pattern of arrears worse than one-off issues

**Mortgage Implications:**
- Current arrears: Extremely difficult to get new mortgage
- Recent arrears (within 12 months): Specialist lenders only
- Arrears cleared for 12+ months: More options available
- Demonstrated ability to maintain payments essential

#### Repossession
**What it is:** Property has been taken back by the lender due to non-payment.

**Impact on Lending:**
- Stays on file for 6 years
- Extremely serious adverse event
- Shows total payment breakdown
- Very difficult to explain to lenders

**Mortgage Implications:**
- Within 3 years: Almost impossible to obtain mortgage
- 3-6 years: Very limited specialist lenders, very high rates
- Often requires large deposit (25%+ equity)
- May never access best rates

### Credit Score Rating Guide

#### Experian (0-999)
- **Excellent (961-999):** Best mortgage rates and terms available
- **Good (881-960):** Access to most standard mortgage products
- **Fair (721-880):** May face some restrictions or higher rates
- **Poor (561-720):** Limited to specialist lenders
- **Very Poor (0-560):** Very difficult to obtain mortgage

#### Equifax (0-700)
- **Excellent (466-700):** Best mortgage rates and terms available
- **Good (420-465):** Access to most standard mortgage products
- **Fair (380-419):** May face some restrictions or higher rates
- **Poor (280-379):** Limited to specialist lenders
- **Very Poor (0-279):** Very difficult to obtain mortgage

#### TransUnion (0-710)
- **Excellent (628-710):** Best mortgage rates and terms available
- **Good (604-627):** Access to most standard mortgage products
- **Fair (566-603):** May face some restrictions or higher rates
- **Poor (551-565):** Limited to specialist lenders
- **Very Poor (0-550):** Very difficult to obtain mortgage

### Mortgage Suitability Factors

The mortgage suitability assessment considers:

1. **Credit Score Level**
   - 650+: Generally eligible for standard mortgages
   - 550-649: May need specialist lender
   - Below 550: Very limited options

2. **Adverse Credit Recency**
   - CCJs older than 3 years: Better prospects
   - Defaults satisfied for 3+ years: Improving situation
   - Recent adverse events (under 2 years): Significant restrictions

3. **Payment History**
   - No missed payments in 12 months: Ideal
   - 1-2 missed payments in 12 months: Some lenders may accept
   - 3+ missed payments in 12 months: Specialist lenders only

4. **Outstanding Adverse Debt**
   - No outstanding adverse debt: Positive factor
   - Outstanding adverse debt: May need settlement before mortgage

5. **Bankruptcy/IVA Status**
   - Discharged 3+ years: Some options available
   - Discharged less than 3 years: Very limited options
   - Currently in IVA/bankruptcy: Generally no mortgage available

### Regulatory Context (FCA Requirements)

Under FCA MCOB (Mortgage Conduct of Business) rules:

- **Creditworthiness Assessment Required:** Lenders must assess creditworthiness comprehensively before lending
- **Credit Reference Agency Checks Mandatory:** All mortgage applications require CRA searches
- **Adverse Credit Must Be Considered:** Impact on affordability must be assessed
- **Consumer Awareness:** Advisers must explain how credit history affects mortgage options
- **Responsible Lending:** Lenders cannot ignore adverse credit or poor payment history

**Affordability Assessment Requirements:**
- Credit history is key component of affordability assessment
- Pattern of payments indicates future payment reliability
- Adverse credit suggests higher lending risk
- Consumer must demonstrate ability to maintain payments despite past issues

### Best Practices for Advisers

1. **Check Credit Early:** Obtain credit report 3-6 months before mortgage application to identify and address issues
2. **Correct Errors:** Challenge any incorrect information on credit files immediately
3. **Allow Time:** Adverse events have less impact as they age (3+ years is significantly better)
4. **Build Positive History:** Encourage clients to build positive payment history after adverse events
5. **Set Expectations:** Manage client expectations about lender options and likely interest rates
6. **Document Circumstances:** Record mitigating circumstances for adverse events in notes
7. **Consider Specialists:** Don't assume adverse credit means no mortgage - specialist lenders exist
8. **Review All Three CRAs:** Credit scores can vary between agencies - check all three

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
| postalCode | Text |  | GL54 2AB |---|---|---|---|
| asset | Reference Link |  | Complex object |
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

**asset:**

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
| entity | Reference Link |  | Complex object |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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
| id | Number | Unique system identifier for this record | 8724 |
| name | Text | First name (given name) | Sarah Johnson |

**entity:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 1234 |
| type | Text | Type of client: Person (individual), Corporate (company), or Trust | Asset |

**factfind:**

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
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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

**factfind:**

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
| client | Reference Link |  | Complex object |
| confidenceLevel | Text | Unique system identifier for this record | HIGH |
| createdAt | Date | When this record was created in the system | 2026-02-15T10:00:00Z |
| currentAmount | Currency Amount | Amount spent | Complex object |
| description | Text | Description of the goal | Salary increase following promotion to Senior Engi... |
| effectiveDate | Date |  | 2026-04-01 |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| id | Number | Unique system identifier for this record | 345 |
| impactOnAffordability | Complex Data |  | Complex object |
| income | Reference Link |  | Complex object |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8496 |

**currentAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 75000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**factfind:**

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

**income:**

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
| client | Reference Link |  | Complex object |
| confidenceLevel | Text | Unique system identifier for this record | HIGH |
| createdAt | Date | When this record was created in the system | 2026-02-18T11:00:00Z |
| currentAmount | Currency Amount | Amount spent | Complex object |
| description | Text | Description of the goal | Mortgage will be paid off |
| effectiveDate | Date |  | 2027-06-01 |
| expenseRef | Reference Link |  | Complex object |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8496 |

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

**factfind:**

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

## 13.30 Affordability Contract

### Business Purpose

The Affordability Contract evaluates a client's financial capacity to take on new commitments or make investment decisions. It provides comprehensive analysis of both monthly cashflow sustainability and lumpsum capital availability, supporting mortgage applications, investment advice, protection planning, debt consolidation, and retirement planning.

### Key Features

- **Monthly Cashflow Analysis** - Calculates disposable income based on actual income and expenditure
- **Scenario Modelling** - Tests "what-if" scenarios with configurable options (forgo non-essentials, exclude debts, etc.)
- **Lumpsum Assessment** - Evaluates available capital for investment or major purchases
- **Emergency Fund Planning** - Tracks adequacy of emergency reserves
- **Multi-Client Support** - Handles joint assessments for couples
- **Automated Calculations** - All derived fields calculated automatically by the system
- **Regulatory Compliance** - Built-in validation for FCA affordability requirements

### Common Scenarios

**Mortgage Applications:**
- Demonstrate affordability for mortgage lending criteria
- Model impact of new mortgage payment on cashflow
- Show effect of consolidating existing debts
- Exclude current mortgage payment (being replaced)

**Investment Advice:**
- Determine sustainable monthly investment capacity
- Assess lumpsum investment from property sale or inheritance
- Ensure emergency fund adequacy before investing
- Calculate remaining buffer after commitments

**Retirement Planning:**
- Assess sustainability of retirement income vs expenditure
- Model effect of state pension increases
- Evaluate affordability of one-off expenses (holidays, home improvements)
- Long-term cashflow sustainability checks

**Debt Consolidation:**
- Model improved cashflow from consolidating multiple debts
- Compare current position vs consolidated scenario
- Demonstrate monthly savings from consolidation
- Ensure sustainable repayment capacity

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| href | Link | Web address for this assessment | /api/v2/factfinds/456/affordability |
| factfind | Link to FactFind | The fact-find this assessment belongs to | FactFind #456 |
| clients | List of Client Links | Clients included in this assessment (minimum 1) | Client #456, Client #457 |
| incomes | List of Income Links | Income sources to include in calculation (minimum 1) | 3 income sources |
| expenditures | List of Expenditure Links | Expenditures to include in calculation | 12 expenditure items |
| createdAt | Date/Time | When this assessment was created | 2026-01-15T10:30:00Z |
| lastUpdatedAt | Date/Time | When this assessment was last changed | 2026-01-29T14:45:00Z |

**Important:** The assessment references specific income and expenditure records. The system uses these to calculate all the cashflow figures automatically.

---

#### Monthly Cash Flow (Calculated Automatically)

These values are calculated by the system based on the incomes and expenditures you've selected. You cannot edit these directly.

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| totalNetIncome | Currency Amount | Total monthly income after tax | £4,500.00 |
| totalExpenditure | Currency Amount | Total monthly spending | £2,800.00 |
| disposableIncome | Currency Amount | Money left over each month | £1,700.00 |

**How it's calculated:**
- **totalNetIncome** = Sum of all selected income sources (converted to monthly)
- **totalExpenditure** = Sum of all selected expenditures (converted to monthly)
- **disposableIncome** = totalNetIncome minus totalExpenditure

---

#### Monthly Modelling Options

These settings control which "what-if" scenarios are applied to calculate the revised affordability.

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| incorporateIncomeChanges | Yes/No | Include planned future income changes? | Yes |
| incorporateExpenditureChanges | Yes/No | Include planned future expenditure changes? | Yes |
| forgoNonEssentialExpenditure | Yes/No | Exclude all non-essential spending? (conservative scenario) | No |
| excludeConsolidatedExpenditure | Yes/No | Remove debts that will be consolidated? | Yes |
| excludeRepaidExpenditure | Yes/No | Remove debts that will be paid off? | Yes |
| hasRebrokerProtection | Yes/No | Include cost of new/rebrokered protection policies? | No |
| agreedMonthlyBudget | Currency Amount | Monthly amount client commits to for new commitment | £1,500.00 |
| notes | Text | Explanation of modelling assumptions | "Client has variable income from bonus" |

**Typical Use Cases:**

- **Mortgage Application:** Set `excludeRepaidExpenditure = Yes` to remove current mortgage (being replaced)
- **Debt Consolidation:** Set `excludeConsolidatedExpenditure = Yes` to show improved cashflow
- **Conservative Assessment:** Set `forgoNonEssentialExpenditure = Yes` to show worst-case scenario
- **Investment Planning:** Keep all options = No to use current actual position
- **Retirement Planning:** Set `incorporateIncomeChanges = Yes` to include state pension increases

---

#### Monthly Affordability (Calculated Automatically)

These values are calculated by applying your modelling options to the base cashflow. You cannot edit these directly.

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| revisedIncome | Currency Amount | Income after incorporating planned changes | £4,700.00 |
| revisedExpenditure | Currency Amount | Spending after applying scenario options | £2,900.00 |
| consolidatedExpenditurePayments | Currency Amount | Total payments for debts being consolidated | £500.00 |
| expenditurePaymentsTobeRepaid | Currency Amount | Total payments for debts being paid off | £300.00 |
| protectionPremiums | Currency Amount | Cost of new/rebrokered protection policies | £150.00 |
| finalDisposableIncome | Currency Amount | Final monthly surplus after all adjustments | £1,250.00 |

**How it's calculated:**

1. **revisedIncome:** Starts with totalNetIncome, adds future increases if incorporateIncomeChanges = Yes
2. **revisedExpenditure:** Starts with totalExpenditure, applies all your scenario options
3. **consolidatedExpenditurePayments:** Sum of expenditures marked as "to be consolidated"
4. **expenditurePaymentsTobeRepaid:** Sum of expenditures marked as "to be repaid"
5. **protectionPremiums:** Cost of protection if hasRebrokerProtection = Yes
6. **finalDisposableIncome:** revisedIncome minus revisedExpenditure (this is the key figure for affordability)

**Key Figure:** `finalDisposableIncome` is the most important number - it shows how much surplus the client has available each month for new commitments after applying all scenarios.

---

#### Lumpsum Affordability

Assesses available capital for investment, house purchase, or debt repayment.

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| totalLumpSumAvailable | Currency Amount | Total cash available | £50,000.00 |
| agreedInvestmentAmount | Currency Amount | Amount client agrees to invest/commit | £30,000.00 |
| sourceOfInvestment | Text | Where the money comes from | Property Sale |
| isInvestmentAvailableWithoutPenalty | Yes/No | Can access without penalties or early exit charges? | Yes |
| notes | Text | Additional context | "From property sale completion expected March 2026" |
| totalFundsAvailable | Currency Amount | Total funds (may include other sources) - Calculated | £55,000.00 |

**Common Sources:**
- **PropertySale** - Proceeds from selling a property
- **Inheritance** - Inherited funds
- **Bonus** - Employment bonus payment
- **InvestmentMaturity** - Maturing investment or bond
- **Savings** - Accumulated savings
- **Gift** - Gift from family member
- **PensionLumpSum** - Tax-free pension lump sum (typically 25%)
- **Redundancy** - Redundancy payment
- **Other** - Other lump sum source

**Important Considerations:**
- Ensure emergency fund is adequate before committing lumpsum
- Check penalty-free access (early withdrawal charges may apply)
- Consider keeping a liquidity buffer for unexpected needs
- Document source for regulatory compliance (money laundering checks)

---

#### Emergency Fund

Tracks adequacy of emergency reserves (typically 3-6 months of essential expenditure).

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| committedAmount | Currency Amount | Amount client has set aside for emergencies | £5,000.00 |
| requiredAmount | Currency Amount | Recommended emergency fund | £8,000.00 |
| shortfall | Currency Amount | Gap to close (calculated automatically) | £3,000.00 |

**How it's calculated:**
- **shortfall** = requiredAmount minus committedAmount (minimum zero)
- If committedAmount exceeds requiredAmount, shortfall = £0

**Typical Recommendations:**
- **Conservative (6 months):** Self-employed, single income household, uncertain employment
- **Moderate (4 months):** Dual income household, stable employment
- **Minimum (3 months):** Very stable employment, strong family support network

**Essential Expenditure:**
Essential monthly expenditure typically includes:
- Mortgage/rent
- Utilities (gas, electric, water)
- Council tax
- Food shopping
- Insurance premiums
- Minimum debt payments

Does NOT include:
- Entertainment
- Dining out
- Gym memberships
- Subscriptions (Netflix, etc.)
- Non-essential shopping

---

### Relationships

This contract connects to:

- **Belongs to a FactFind** - Each assessment is part of a specific fact-find
- **Includes Clients** - One or more clients (for joint assessments)
- **References Incomes** - Specific income records to include in calculation
- **References Expenditures** - Specific expenditure records to include in calculation
- **May support Arrangements** - Assessment may justify a specific mortgage, investment, or protection recommendation

---

### Business Validation Rules

**When Creating an Assessment:**
- Must select at least 1 client
- Must select at least 1 income source
- Expenditures can be empty (client with no recorded expenditure)
- All referenced clients, incomes, and expenditures must exist and belong to the fact-find
- Cannot mix records from different fact-finds

**Money Values:**
- All amounts must be zero or positive (no negative numbers)
- agreedMonthlyBudget cannot exceed finalDisposableIncome
- agreedInvestmentAmount cannot exceed totalLumpSumAvailable
- All currency amounts should use the same currency (mixing currencies not recommended)

**Yes/No Fields:**
- Must be exactly "Yes" or "No" (case-sensitive)
- Invalid values like "yes", "true", "1" will be rejected

**Emergency Fund:**
- committedAmount should be realistic (actual accessible savings)
- requiredAmount typically = essential monthly expenditure × 3 to 6 months
- Shortfall automatically calculated (cannot be edited)

---

### Calculation Examples

#### Example 1: Basic Monthly Affordability

**Client's Position:**
- Salary: £45,000/year (£3,000/month after tax)
- Rental income: £12,000/year (£1,000/month after tax)
- Total monthly income: £4,000

**Expenditures:**
- Mortgage: £1,200/month
- Living expenses: £1,500/month
- Car loan: £300/month
- Total expenditure: £3,000/month

**Result:**
- **disposableIncome** = £4,000 - £3,000 = **£1,000/month**

---

#### Example 2: Mortgage Application with Debt Consolidation

**Scenario:** Client remortgaging and consolidating car loan and credit card

**Current Position:**
- Total income: £4,000/month
- Current mortgage: £1,200/month (being replaced)
- Car loan: £300/month (being consolidated)
- Credit card: £200/month (being consolidated)
- Other expenses: £1,500/month
- Current disposable income: £800/month

**Modelling Options:**
- `excludeRepaidExpenditure` = Yes (current mortgage will be repaid)
- `excludeConsolidatedExpenditure` = Yes (car loan and credit card will be consolidated)

**Revised Position:**
- Total income: £4,000/month
- Other expenses: £1,500/month (only)
- **revisedExpenditure** = £1,500
- **consolidatedExpenditurePayments** = £500 (car £300 + credit card £200)
- **expenditurePaymentsTobeRepaid** = £1,200 (current mortgage)
- **finalDisposableIncome** = £4,000 - £1,500 = **£2,500/month**

**New mortgage payment:** £1,600/month

**Assessment:** AFFORDABLE - Client has £2,500 available, new mortgage is £1,600, leaving £900 surplus

---

#### Example 3: Investment Capacity with Emergency Fund

**Scenario:** Client wants to invest lumpsum and start monthly contributions

**Financial Position:**
- Monthly disposable income: £1,200
- Lumpsum available: £50,000 (from property sale)
- Current emergency fund: £8,000
- Required emergency fund: £12,000

**Analysis:**
- **Emergency fund shortfall:** £4,000
- **Available for lumpsum investment:** £50,000 - £4,000 = £46,000 (reserve £4,000 to complete emergency fund)
- **Monthly investment capacity:** Recommend £800/month (leaving £400 buffer)

**Recommendation:**
- Invest £45,000 lumpsum (retain £1,000 extra buffer)
- Top up emergency fund with £4,000 first
- Start £800/month regular contribution
- Retain £400/month buffer for flexibility

---

#### Example 4: Retirement Sustainability Check

**Scenario:** Retired couple checking if they can afford £10,000 cruise

**Income:**
- State pensions: £1,800/month combined
- Private pension: £1,500/month
- Total: £3,300/month

**Expenditure:**
- Living expenses: £2,400/month (no mortgage - paid off)
- **disposableIncome** = £900/month

**Annual Surplus:**
- £900 × 12 = £10,800/year

**Emergency Fund:**
- Committed: £18,000 (fully funded)
- Required: £14,400 (6 months × £2,400)
- Surplus: £3,600 above required

**Cruise Assessment:**
- Cost: £10,000
- Can afford from one year's surplus: £10,800 ✓
- Emergency fund remains intact: £18,000 ✓

**Result:** AFFORDABLE - Cruise can be funded from annual surplus without touching emergency fund

---

### Typical Workflow

**Step 1: Gather Information**
1. Identify all clients involved (individual or joint)
2. Record all income sources
3. Record all expenditures
4. Understand the purpose (mortgage, investment, retirement check, etc.)

**Step 2: Create Assessment**
1. Select which clients to include
2. Select which incomes to include (usually all)
3. Select which expenditures to include (usually all)
4. System automatically calculates base position

**Step 3: Apply Scenarios**
1. Choose appropriate modelling options for the situation
2. Set agreedMonthlyBudget if applying for new commitment
3. Add notes explaining assumptions
4. System recalculates with scenarios applied

**Step 4: Assess Lumpsum (if applicable)**
1. Enter totalLumpSumAvailable
2. Specify sourceOfInvestment
3. Confirm if available without penalty
4. Set agreedInvestmentAmount
5. Check emergency fund is adequate first

**Step 5: Check Emergency Fund**
1. Enter committedAmount (actual savings)
2. Calculate requiredAmount (3-6 months essential expenditure)
3. System calculates shortfall
4. Address shortfall before major commitments

**Step 6: Make Recommendation**
1. Review finalDisposableIncome figure
2. Ensure new commitment is affordable with buffer
3. Check lumpsum doesn't compromise emergency fund
4. Document recommendation with reference to assessment

---

### Regulatory Considerations

**FCA Requirements:**
- Comprehensive affordability assessment required for regulated mortgages (MCOB)
- Must consider foreseeable future changes (retirement, children, career changes)
- Stress testing required (can client afford if interest rates rise?)
- Consumer Duty requires understanding of vulnerability and financial resilience

**Documentation:**
- Assessment should be documented and retained
- Support suitability of recommendations
- Evidence of consideration of client circumstances
- Notes field should explain key assumptions

**Vulnerable Customers:**
- Extra care if client has vulnerability indicators
- Conservative approach to affordability
- Ensure adequate emergency fund
- Consider impact of foreseeable changes

**Best Practice:**
- Use conservative assumptions (don't rely on uncertain bonuses)
- Stress test key figures (what if income drops 10%?)
- Maintain adequate emergency fund before major commitments
- Build in buffer (don't commit 100% of disposable income)
- Review annually or when circumstances change

---

## 13.31 Net Worth Contract

### Business Purpose

The Net Worth Contract provides a snapshot calculation of a client's total financial position by aggregating all assets and liabilities at a specific point in time. This enables wealth tracking, financial planning benchmarking, and regulatory reporting.

### Key Features

- **Snapshot Calculation** - Captures net worth at a specific point in time
- **Asset Categorization** - Groups assets by type (property, pensions, investments, cash, other)
- **Liability Categorization** - Groups liabilities by type (mortgages, loans, credit cards, other)
- **Multi-Client Support** - Can calculate net worth for individuals or joint clients
- **Historical Tracking** - Multiple snapshots enable wealth progression analysis
- **Automated Totals** - System automatically calculates subtotals and net worth

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| id | Number | Unique identifier | 9001 |
| href | Link | Web address for this net worth record | /api/v2/factfinds/456/networth/9001 |
| factfind | Link to FactFind | The fact-find this belongs to | FactFind #456 |
| clients | List of Client Links | Clients included in this calculation | Client #456, Client #457 |
| calculatedOn | Date/Time | When this net worth was calculated | 2026-02-18T14:30:00Z |
| notes | Text | Context for this calculation | "Net worth calculation as of property revaluation" |
| createdAt | Date/Time | When this record was created | 2026-02-18T14:30:00Z |
| updatedAt | Date/Time | When this record was last modified | 2026-02-18T14:30:00Z |

#### Asset Breakdown

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| property | Currency Amount | Total property asset value | £450,000.00 |
| pensions | Currency Amount | Total pension asset value | £325,000.00 |
| investments | Currency Amount | Total investment asset value | £185,000.00 |
| cash | Currency Amount | Total cash and savings | £45,000.00 |
| other | Currency Amount | Other assets (business, collectibles, etc.) | £25,000.00 |
| totalAssets | Currency Amount | Sum of all asset categories (calculated) | £1,030,000.00 |

#### Liability Breakdown

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| mortgages | Currency Amount | Total outstanding mortgages | £240,000.00 |
| loans | Currency Amount | Total loans (personal, secured, unsecured) | £15,000.00 |
| creditCards | Currency Amount | Total credit card balances | £8,500.00 |
| other | Currency Amount | Other liabilities | £5,000.00 |
| totalLiabilities | Currency Amount | Sum of all liability categories (calculated) | £268,500.00 |

#### Net Worth

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| netWorth | Currency Amount | Total assets minus total liabilities (calculated) | £761,500.00 |

### Relationships

This contract connects to:

- Belongs to a FactFind
- References one or more Clients
- Derives from Asset and Liability records

### Business Validation Rules

- At least 1 client is required
- calculatedOn is required
- totalAssets = sum of all asset categories
- totalLiabilities = sum of all liability categories
- netWorth = totalAssets - totalLiabilities
- All currency amounts must use the same currency code
- All amounts must be non-negative (except netWorth can be negative)

### Common Use Cases

**Wealth Planning:**
- Track client wealth progression over time
- Identify wealth-building opportunities
- Monitor impact of financial decisions

**Regulatory Reporting:**
- Demonstrate client financial capacity
- Support suitability assessments
- Evidence affordability for large commitments

**Life Event Tracking:**
- Property purchase impact on net worth
- Inheritance or windfall received
- Retirement milestone tracking
- Divorce settlement calculations

---

## 13.32 Contact Contract
### Overview
The `Contact` contract represents a contact method (email, phone, mobile, work phone, website) for a client.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| client | Reference Link |  | Complex object |
| contactType | Text | Type of contact (Email, Phone, Mobile, etc.) | EMAIL |
| createdAt | Date | When this record was created in the system | 2026-01-05T10:00:00Z |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8496 |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

---

## 13.32 Attitude to Risk (ATR) Assessment Contract
### Overview
The `ATR Assessment` contract represents a comprehensive client risk tolerance assessment completed via questionnaire for investment and pension advice. It includes all client answers to ATR questions, generated risk profiles, chosen profile, capacity for loss assessment, and regulatory declarations.

### Key Components
1. **15 Standard ATR Questions** with client answers and scores
2. **45 Supplementary Questions** providing additional context
3. **3 Generated Risk Profiles** (main + adjacent higher/lower)
4. **Chosen Risk Profile** selected by client with adviser guidance
5. **Capacity for Loss Assessment** evaluating financial ability to sustain losses
6. **Client & Adviser Declarations** for regulatory compliance

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| assessmentDate | Date | When the assessment was conducted | 2026-02-10 |
| assessedBy | Reference Link | Adviser who conducted the assessment | Complex object |
| capacityForLoss | Complex Data | Financial capacity to sustain investment losses | Complex object |
| client | Reference Link | Reference to the client being assessed | Complex object |
| completedAt | Date | When assessment was fully completed (all questions + declarations) | 2026-02-10T15:30:00Z |
| createdAt | Date | When this record was created in the system | 2026-02-10T11:00:00Z |
| declarations | Complex Data | Client and adviser declarations | Complex object |
| factfind | Reference Link | Link to the FactFind that this assessment belongs to | Complex object |
| href | Text | API resource link | v2/factfinds/679/atr-assessment |
| id | Text | Unique system identifier for this assessment | atr-20260210-001 |
| maxScore | Number | Maximum possible score for this assessment | 100 |
| questions | List of Complex Data | 15 standard ATR questions with client answers | List with 15 item(s) |
| reviewDate | Date | Date when this assessment should be reviewed | 2027-02-10 |
| riskProfiles | Complex Data | Generated and chosen risk profiles | Complex object |
| supplementaryQuestions | List of Complex Data | 45 additional context questions with answers | List with 45 item(s) |
| templateRef | Complex Data | Reference to the ATR template used | Complex object |
| totalScore | Number | Total weighted score from all questions | 67 |
| updatedAt | Date | When this record was last modified | 2026-02-10T15:30:00Z |

### Question and Answer Structure

#### Standard Questions
Each of the 15 standard questions captures:
- **questionId**: Unique identifier (Q1, Q2, etc.)
- **questionText**: The question presented to client
- **questionType**: SingleChoice, MultipleChoice, Slider, etc.
- **answer**: Client's answer including answerId, answerText, and score

#### Supplementary Questions
Each of the 45 supplementary questions captures:
- **questionId**: Unique identifier (SQ-R1, SQ-G1, etc.)
- **category**: Risk, General, Financial, Personal
- **questionText**: The question presented to client
- **answer**: Client's answer with type-specific value (Number, Boolean, Text, Date)

#### Nested Field Groups

**assessedBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Adviser unique identifier | 789 |
| name | Text | Adviser full name | Jane Doe |

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8496 |
| href | Text | API link to client resource | v2/factfinds/679/clients/8496 |
| name | Text | Client full name | John Smith |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |
| href | Text | API link to factfind resource | v2/factfinds/679 |

**templateRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Template unique identifier | 5407 |
| version | Text | Template version number | 5.0 |
| name | Text | Template display name | FCA Standard ATR 2025 |
| regulatoryApprovalDate | Date | Date template was approved | 2025-01-01 |

**questions** (array of question objects):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| questionId | Text | Question identifier | Q1 |
| questionText | Text | The question text | How long do you plan to invest for? |
| questionType | Text | Type of question | SingleChoice |
| answer | Complex Data | Client's answer | Complex object |

**questions[].answer** (for SingleChoice questions):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| answerId | Text | Selected answer identifier | A1-3 |
| answerText | Text | Selected answer text | 10-15 years |
| score | Number | Score for this answer | 5 |

**questions[].answer** (for Slider questions):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| value | Number | Slider value selected | 7 |
| minLabel | Text | Label for minimum value | Very Cautious |
| maxLabel | Text | Label for maximum value | Very Adventurous |
| score | Number | Score for this value | 7 |

**supplementaryQuestions** (array of supplementary question objects):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| category | Text | Question category | Risk |
| questionId | Text | Question identifier | SQ-R1 |
| questionText | Text | The question text | Number of financial dependants |
| answer | Complex Data | Client's answer | Complex object |

**supplementaryQuestions[].answer**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| answerType | Text | Type of answer | Number, Boolean, Text, Date |
| value | Various | The answer value | 2 |

**riskProfiles:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| generated | List of Complex Data | Three generated risk profiles (main + adjacent) | List with 3 item(s) |
| chosen | Complex Data | The risk profile chosen by client | Complex object |

**riskProfiles.generated[]** (each generated profile):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| riskRating | Text | Risk category name | Balanced |
| riskScore | Number | Numeric risk score | 45 |
| scoreRange | Text | Score range for this category | 40-50 |
| description | Text | Full description of this risk profile | You have a balanced attitude to risk... |
| assetAllocation | Complex Data | Recommended asset mix | Complex object |
| volatilityTolerance | Text | Expected volatility comfort | Medium |
| timePeriod | Text | Recommended investment period | 10-15 years |
| potentialLossAcceptance | Text | Expected loss tolerance | 10-15% |

**riskProfiles.generated[].assetAllocation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| equities | Number | Equity allocation percentage | 60 |
| bonds | Number | Bond allocation percentage | 30 |
| cash | Number | Cash allocation percentage | 5 |
| alternatives | Number | Alternative investments percentage | 5 |

**riskProfiles.chosen:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| riskRating | Text | Chosen risk category name | Balanced |
| riskScore | Number | Chosen risk score | 45 |
| chosenBy | Text | Who made the choice | Client |
| chosenDate | Date | When choice was made | 2026-02-10T14:30:00Z |
| reasonForChoice | Text | Client's reason for choosing this profile | Matches my investment goals and risk tolerance |
| adviserNotes | Text | Adviser notes on the choice | Client comfortable with balanced approach, discussed volatility expectations |

**capacityForLoss:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| canAffordLosses | Boolean | Can client afford investment losses | true |
| emergencyFundMonths | Number | Months of expenses in emergency fund | 6 |
| essentialExpensesCovered | Boolean | Essential expenses adequately covered | true |
| dependantsProvisionAdequate | Boolean | Adequate provision for dependants | true |
| assessmentNotes | Text | Adviser assessment notes | Client has sufficient emergency fund and no debt |

**declarations:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientDeclaration | Complex Data | Client's declaration | Complex object |
| adviserDeclaration | Complex Data | Adviser's declaration | Complex object |

**declarations.clientDeclaration:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| declarationType | Text | Type of declaration | ATR_Accuracy |
| declarationText | Text | Full declaration text | I confirm that the answers I have provided... |
| signed | Boolean | Whether declaration is signed | true |
| signedDate | Date | When declaration was signed | 2026-02-10T14:35:00Z |
| signatureType | Text | Type of signature | Electronic |
| ipAddress | Text | IP address where signed | 192.168.1.100 |

**declarations.adviserDeclaration:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| declarationType | Text | Type of declaration | ATR_Suitable |
| declarationText | Text | Full declaration text | I confirm that the risk profile assessment... |
| signed | Boolean | Whether declaration is signed | true |
| signedDate | Date | When declaration was signed | 2026-02-10T15:30:00Z |
| signedBy | Complex Data | Adviser who signed | Complex object |

**declarations.adviserDeclaration.signedBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Adviser unique identifier | 789 |
| name | Text | Adviser full name | Jane Doe |

### Complete Example

```json
{
  "href": "v2/factfinds/679/atr-assessment",
  "id": "atr-20260210-001",
  "client": {
    "id": 8496,
    "href": "v2/factfinds/679/clients/8496",
    "name": "John Smith"
  },
  "factfind": {
    "id": 679,
    "href": "v2/factfinds/679"
  },
  "templateRef": {
    "id": 5407,
    "version": "5.0",
    "name": "FCA Standard ATR 2025",
    "regulatoryApprovalDate": "2025-01-01"
  },
  "assessmentDate": "2026-02-10T11:00:00Z",
  "assessedBy": {
    "id": 789,
    "name": "Jane Doe"
  },
  "questions": [
    {
      "questionId": "Q1",
      "questionText": "How long do you plan to invest for?",
      "questionType": "SingleChoice",
      "answer": {
        "answerId": "A1-3",
        "answerText": "10-15 years",
        "score": 5
      }
    },
    {
      "questionId": "Q2",
      "questionText": "What is your attitude to investment risk?",
      "questionType": "Slider",
      "answer": {
        "value": 7,
        "minLabel": "Very Cautious",
        "maxLabel": "Very Adventurous",
        "score": 7
      }
    }
  ],
  "supplementaryQuestions": [
    {
      "category": "Risk",
      "questionId": "SQ-R1",
      "questionText": "Number of financial dependants",
      "answer": {
        "answerType": "Number",
        "value": 2
      }
    },
    {
      "category": "General",
      "questionId": "SQ-G1",
      "questionText": "Do you have a valid Will?",
      "answer": {
        "answerType": "Boolean",
        "value": true
      }
    }
  ],
  "totalScore": 67,
  "maxScore": 100,
  "riskProfiles": {
    "generated": [
      {
        "riskRating": "Balanced",
        "riskScore": 45,
        "scoreRange": "40-50",
        "description": "You have a balanced attitude to risk...",
        "assetAllocation": {
          "equities": 60,
          "bonds": 30,
          "cash": 5,
          "alternatives": 5
        },
        "volatilityTolerance": "Medium",
        "timePeriod": "10-15 years",
        "potentialLossAcceptance": "10-15%"
      },
      {
        "riskRating": "Cautious",
        "riskScore": 35,
        "scoreRange": "30-40",
        "description": "Adjacent lower risk option...",
        "assetAllocation": {
          "equities": 40,
          "bonds": 45,
          "cash": 10,
          "alternatives": 5
        }
      },
      {
        "riskRating": "Adventurous",
        "riskScore": 55,
        "scoreRange": "50-60",
        "description": "Adjacent higher risk option...",
        "assetAllocation": {
          "equities": 75,
          "bonds": 15,
          "cash": 5,
          "alternatives": 5
        }
      }
    ],
    "chosen": {
      "riskRating": "Balanced",
      "riskScore": 45,
      "chosenBy": "Client",
      "chosenDate": "2026-02-10T14:30:00Z",
      "reasonForChoice": "Matches my investment goals and risk tolerance",
      "adviserNotes": "Client comfortable with balanced approach, discussed volatility expectations"
    }
  },
  "capacityForLoss": {
    "canAffordLosses": true,
    "emergencyFundMonths": 6,
    "essentialExpensesCovered": true,
    "dependantsProvisionAdequate": true,
    "assessmentNotes": "Client has sufficient emergency fund and no debt"
  },
  "declarations": {
    "clientDeclaration": {
      "declarationType": "ATR_Accuracy",
      "declarationText": "I confirm that the answers I have provided are accurate and complete...",
      "signed": true,
      "signedDate": "2026-02-10T14:35:00Z",
      "signatureType": "Electronic",
      "ipAddress": "192.168.1.100"
    },
    "adviserDeclaration": {
      "declarationType": "ATR_Suitable",
      "declarationText": "I confirm that the risk profile assessment is suitable for this client...",
      "signed": true,
      "signedDate": "2026-02-10T15:30:00Z",
      "signedBy": {
        "id": 789,
        "name": "Jane Doe"
      }
    }
  },
  "completedAt": "2026-02-10T15:30:00Z",
  "reviewDate": "2027-02-10",
  "createdAt": "2026-02-10T11:00:00Z",
  "updatedAt": "2026-02-10T15:30:00Z"
}
```

### Regulatory Compliance

**FCA Requirements:**
- **COBS 9.2**: Assessing suitability requires understanding client risk profile
- **MiFID II Article 25**: Assessment must consider knowledge, experience, and objectives
- **Consumer Duty**: Risk assessment must be clear and support good outcomes

**Key Compliance Points:**
1. **Complete Documentation**: All 15 questions must be answered
2. **Three Options Rule**: Always present 3 adjacent profiles
3. **Capacity vs Tolerance**: If capacity is lower than tolerance, use capacity-based profile
4. **Declarations Required**: Both client and adviser must sign off
5. **Annual Review**: Assessment should be reviewed annually or after major life events
6. **Audit Trail**: All historical assessments preserved for regulatory review

### Business Rules

1. **Question Completion:**
   - All 15 standard questions MUST be answered
   - Supplementary questions are optional but recommended
   - System prevents submission without all required answers

2. **Risk Profile Generation:**
   - System automatically generates 3 adjacent risk profiles
   - Profiles based on total weighted score from questions
   - Asset allocation derived from regulatory-approved template

3. **Profile Selection:**
   - Client must choose from one of the 3 generated profiles
   - Adviser can guide but should not override client choice
   - Reason for choice must be documented

4. **Capacity for Loss:**
   - Must be assessed before finalizing ATR
   - If capacity is lower than tolerance, must adjust recommendation
   - Emergency fund of 6+ months recommended before high-risk investments

5. **Declarations:**
   - Client declaration confirms answer accuracy
   - Adviser declaration confirms suitability assessment
   - Both required before ATR is considered complete

6. **Review Period:**
   - Valid for 12 months unless life event occurs
   - Major life events trigger mandatory reassessment: retirement, inheritance, divorce, redundancy
   - System flags ATR for review 30 days before expiry

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
| client | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-01-10T09:00:00Z |
| email | Text |  | david.williams@wandassoc.co.uk |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8496 |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

---

## 13.34 Vulnerability Contract
### Overview
The `Vulnerability` contract represents a client vulnerability indicator for Consumer Duty compliance. Multiple vulnerability records can be associated with a single client.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 5555 |
| client | Reference Link | Reference to the client | Complex object |
| hasVulnerability | Enum (string) | Whether client has vulnerability. Possible values: Yes, No, Potential (maxLength: 10, minLength: 1) | Yes |
| type | Enum (string) | Type of vulnerability. Possible values: Temporary, Permanent (maxLength: 10, minLength: 1) | Permanent |
| categories | List of Enum (string) | List of vulnerability categories. Possible values: Health, LifeEvent, Resilience, Capability | ["Health", "Capability"] |
| notes | Text | Vulnerability notes (max 4000 characters) | Client has limited mobility and requires accessible... |
| createdBy | Reference Link | User who created the record | Complex object |
| assessedOn | DateTime | When vulnerability was assessed | 2026-02-23T12:37:54.051Z |
| reviewOn | DateTime | When vulnerability should be reviewed | 2026-08-23T12:37:54.051Z |
| isClientPortalSuitable | Text | Whether client portal is suitable for the vulnerable client | WithSupport |
| vulnerabilityActionTaken | Text | Vulnerability action taken notes (max 300 characters) | Home visits arranged, large print documents provided |

#### Nested Field Groups

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 123 |
| name | Text | Client name | John Smith |

**createdBy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 999 |
| href | Text | Link to user resource | /api/v2/users/999 |

### Enumerations

#### Has Vulnerability Values
- `Yes` - Client has confirmed vulnerability
- `No` - Client has no vulnerability
- `Potential` - Potential vulnerability identified but not confirmed

#### Vulnerability Type Values
- `Temporary` - Temporary vulnerability (e.g., recent bereavement, job loss)
- `Permanent` - Permanent vulnerability (e.g., disability, chronic illness)

#### Vulnerability Categories
- `Health` - Health-related vulnerabilities
- `LifeEvent` - Life event vulnerabilities
- `Resilience` - Resilience-related vulnerabilities
- `Capability` - Capability-related vulnerabilities

---

## 13.35 Marketing Preferences Contract
### Overview
The `MarketingPreferences` contract represents a client's marketing consent and communication preferences. This is a singleton resource - each client has exactly one marketing preferences record.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| client | Reference Link | Client reference | Complex object |
| factfind | Reference Link | FactFind reference | Complex object |
| allowCompanyContactByTelephone | Yes/No | Permission for company telephone contact | Yes |
| allowCompanyContactByMail | Yes/No | Permission for company mail contact | Yes |
| allowCompanyContactByEmail | Yes/No | Permission for company email contact | Yes |
| allowCompanyContactBySms | Yes/No | Permission for company SMS contact | Yes |
| allowCompanyContactBySocialMedia | Yes/No | Permission for company social media contact | Yes |
| allowCompanyContactByAutomatedCalls | Yes/No | Permission for company automated calls | Yes |
| allowCompanyContactByPfp | Yes/No | Permission for company PFP contact | Yes |
| allowThirdPartyContactByTelephone | Yes/No | Permission for third-party telephone contact | Yes |
| allowThirdPartyContactByMail | Yes/No | Permission for third-party mail contact | Yes |
| allowThirdPartyContactByEmail | Yes/No | Permission for third-party email contact | Yes |
| allowThirdPartyContactBySms | Yes/No | Permission for third-party SMS contact | Yes |
| allowThirdPartyContactBySocialMedia | Yes/No | Permission for third-party social media contact | Yes |
| allowThirdPartyContactByAutomatedCalls | Yes/No | Permission for third-party automated calls | Yes |
| allowThirdPartyContactByPfp | Yes/No | Permission for third-party PFP contact | Yes |
| canContactForMarketingPurposes | Enum (Text) | Whether marketing contact is permitted. Enum: Yes, No | Yes |
| consentedAt | DateTime | Timestamp when consent was given | 2026-02-23T17:49:54.183Z |
| deliveryMethod | Enum (Text) | Preferred delivery method. Enum: NoPreference, Electronic, Post | NoPreference |
| accessibleFormat | Enum (Text) | Required accessible format. Enum: NoRequirement, LargePrint, AudioTape, Braille | NoRequirement |

#### Nested Field Groups

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique client identifier | 1234 |
| href | Text | Client resource URL | v2/factfinds/234/clients/1234 |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique FactFind identifier | 234 |
| href | Text | FactFind resource URL | v2/factfinds/234 |

### Enumerations

#### canContactForMarketingPurposes Values
- `Yes` - Client has consented to marketing contact
- `No` - Client has not consented or has withdrawn consent

#### deliveryMethod Values
- `NoPreference` - No preference specified
- `Electronic` - Prefers electronic delivery
- `Post` - Prefers postal delivery

#### accessibleFormat Values
- `NoRequirement` - No accessible format required
- `LargePrint` - Large print format required
- `AudioTape` - Audio tape format required
- `Braille` - Braille format required

---

## 13.36 DPA Policy Agreement Contract

### Overview
The `DPAPolicyAgreement` contract represents a client's acceptance of the firm's Data Protection Agreement (DPA) policy. This contract records the client's response to data protection policy statements and provides an audit trail for GDPR compliance.

### Business Purpose
- Record client consent to data protection policies
- Provide audit trail for regulatory compliance (GDPR, Data Protection Act 2018)
- Track which version of the DPA policy was agreed to by the client
- Demonstrate lawful basis for data processing
- Support data subject access requests (DSAR)

### Key Features
- Immutable once created - policy updates require new agreements
- Links to specific DPA policy version
- Records acceptance of up to 5 policy statements
- Scoped to both client and factfind context
- Timestamps when agreement was created

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique identifier for the DPA agreement | 7890 |
| href | Text | Resource URL for this agreement | v2/factfinds/234/clients/1234/dpa-agreements/7890 |
| client | Reference Link | Reference to the client | Complex object |
| factfind | Reference Link | Reference to the factfind | Complex object |
| policy | Reference Link | Reference to the DPA policy | Complex object |
| agreedAt | Date and Time | When the client agreed to the policy | 2026-02-23T14:30:00Z |
| statements | Complex Data | Policy statements and responses | See statements below |
| createdAt | Date and Time | When this agreement was created (read-only) | 2026-02-23T14:30:05Z |
| createdBy | Text | User who created this agreement (read-only) | adviser@example.com |

#### Nested Field Groups

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique client identifier | 1234 |
| href | Text | Client resource URL | v2/factfinds/234/clients/1234 |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique FactFind identifier | 234 |
| href | Text | FactFind resource URL | v2/factfinds/234 |

**policy:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique policy identifier | 42 |
| name | Text | Policy name (read-only) | Standard DPA Policy 2026 |
| href | Text | Policy resource URL | v2/dpa_policies/42 |

**statements:**

The statements object contains up to 5 statement fields (statement1 through statement5). Each statement has the following structure:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| text | Text | Statement text from policy (read-only) | I confirm that I have read and understood the data protection policy. |
| accepted | Yes/No | Whether the client accepted this statement | Yes |

**Example statements structure:**
- `statements.statement1.text` - First statement text (read-only)
- `statements.statement1.accepted` - First statement acceptance (required)
- `statements.statement2.text` - Second statement text (read-only)
- `statements.statement2.accepted` - Second statement acceptance (optional)
- `statements.statement3.text` - Third statement text (read-only)
- `statements.statement3.accepted` - Third statement acceptance (optional)
- `statements.statement4.text` - Fourth statement text (read-only)
- `statements.statement4.accepted` - Fourth statement acceptance (optional)
- `statements.statement5.text` - Fifth statement text (read-only)
- `statements.statement5.accepted` - Fifth statement acceptance (optional)

### Validation Rules
- `id` - System-generated, read-only
- `href` - System-generated, read-only
- `policy.id` - Required on create, must reference an existing DPA policy
- `agreedAt` - Required, must be valid ISO 8601 date-time
- `statements.statement1` - Required, at least the first statement must be present
- `statements.statement1.accepted` - Required, boolean value
- `statements.statementN.accepted` - Required if statementN is present (N = 2-5)
- Statement `text` fields are read-only, populated from the policy definition
- `createdAt` and `createdBy` are system-managed, read-only

### Business Rules
- Agreements are immutable once created (cannot be updated)
- For a valid agreement, all statements present must have accepted = true
- Statement text comes from the policy definition, not the request
- When a policy is updated, clients must create new agreements
- Each client can have multiple agreements over time
- Use agreementId = "current" to retrieve the most recent agreement
- Supports up to 5 policy statements per agreement
- Agreements can be deleted but this should be restricted to specific scenarios (data correction, test cleanup)
- Consider GDPR compliance implications before implementing delete functionality

### GDPR Compliance Notes
- Provides audit trail for Article 7 (consent)
- Demonstrates lawful basis for processing (Article 6)
- Supports right of access (Article 15) through agreement history
- Records timestamp and content of consent
- Immutable records ensure compliance with record-keeping requirements

### Example Usage Scenarios

**Scenario 1: Client onboarding**
- Client is presented with current DPA policy
- Client reads and accepts all policy statements
- System creates DPA agreement linking client, factfind, and policy
- Agreement ID is returned for reference

**Scenario 2: Policy update**
- Firm updates its DPA policy (new policy version created)
- Existing clients are prompted to accept new policy
- New DPA agreement created for each client's acceptance
- Historical agreements remain in system for audit purposes

**Scenario 3: Compliance audit**
- Regulator requests proof of data processing consent
- System retrieves all DPA agreements for client
- Agreements show which policies were accepted and when
- Demonstrates continuous consent management

**Scenario 4: Data correction**
- Test agreement was created with incorrect data
- Administrator deletes the incorrect agreement record
- New agreement is created with correct information
- Deletion is logged for audit purposes

---

## 13.37 Financial Profile Contract

### Overview
The `FinancialProfile` contract represents a summary of a client's financial position. This is a singleton resource - each client has exactly one financial profile record that provides a high-level view of their income, assets, liabilities, and net worth.

### Business Purpose
- Provide quick summary of client's financial position
- Track net worth and household finances over time
- Support portfolio review and planning discussions
- Enable what-if scenario planning with projected figures
- Aggregate individual and joint financial metrics

### Key Features
- Singleton resource per client
- Captures both individual and household-level metrics
- Can be manually entered or calculated from underlying records
- Supports historical tracking via calculatedAt and lastReviewDate
- All currency amounts include currency code

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| client | Reference Link | Client reference | Complex object |
| factfind | Reference Link | FactFind reference | Complex object |
| grossAnnualIncome | Currency Amount | Total gross annual income before tax | Complex object |
| netAnnualIncome | Currency Amount | Total net annual income after tax | Complex object |
| totalAssets | Currency Amount | Total value of all assets | Complex object |
| totalLiabilities | Currency Amount | Total value of all liabilities | Complex object |
| netWorth | Currency Amount | Total net worth (assets minus liabilities) | Complex object |
| householdIncome | Currency Amount | Combined household income (all clients) | Complex object |
| householdNetWorth | Currency Amount | Combined household net worth | Complex object |
| totalJointAssets | Currency Amount | Total value of jointly owned assets | Complex object |
| calculatedAt | Date and Time | When these figures were calculated | 2026-02-23T10:30:00Z |
| lastReviewDate | Date | When these figures were last reviewed | 2026-02-23 |
| createdAt | Date and Time | When this record was created (read-only) | 2026-01-15T09:00:00Z |
| updatedAt | Date and Time | When this record was last updated (read-only) | 2026-02-23T10:30:00Z |

#### Nested Field Groups

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique client identifier | 1234 |
| href | Text | Client resource URL | v2/factfinds/234/clients/1234 |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique FactFind identifier | 234 |
| href | Text | FactFind resource URL | v2/factfinds/234 |

**Currency Amount Structure (applies to all amount fields):**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | The monetary value | 75000.0 |
| currency | Complex Data | Currency information | Complex object |
| code | Text | ISO currency code | GBP |
| symbol | Text | Currency symbol | £ |

### Validation Rules
- All currency amounts are optional
- If provided, currency amounts must include both amount and currency.code
- `lastReviewDate` - Must be a valid date not in the future if provided
- All amounts must be non-negative
- `netWorth` should equal `totalAssets` minus `totalLiabilities` if all are provided
- Currency must be consistent across all amounts for a single profile

### Business Rules
- Financial profile is a singleton - one record per client
- Automatically created when a client is created
- Values can be manually entered or calculated from underlying income, asset, and liability records
- Household metrics aggregate values across joint clients in the factfind
- Net worth calculation: Total Assets - Total Liabilities
- `calculatedAt` is system-managed and records when figures were last computed
- Profile is typically updated after changes to income, assets, or liabilities
- Supports both actual figures and projected/planning scenario figures

### Usage Scenarios

**Scenario 1: Initial client onboarding**
- Client provides high-level financial summary during first meeting
- Adviser creates financial profile with rough estimates
- Profile is refined as detailed information is gathered

**Scenario 2: Portfolio review**
- Adviser reviews client's financial position
- Compares current net worth to previous review
- Updates lastReviewDate to track review completion

**Scenario 3: Planning scenario**
- Adviser creates what-if scenario with projected figures
- Updates profile with anticipated future income and assets
- Discusses implications with client

**Scenario 4: Household comparison**
- Joint factfind with two clients
- Individual profiles show each client's position
- Household metrics show combined family finances

### Calculation Notes
- **Gross Annual Income**: Sum of all income sources before tax
- **Net Annual Income**: Income after tax and deductions
- **Total Assets**: Sum of property, investments, savings, pensions, etc.
- **Total Liabilities**: Sum of mortgages, loans, credit cards, etc.
- **Net Worth**: Total Assets minus Total Liabilities
- **Household Income**: Combined income of all clients in factfind
- **Household Net Worth**: Combined net worth of all clients
- **Total Joint Assets**: Assets owned jointly by multiple clients

---

## 13.38 Client Relationship Contract

### Overview
The `ClientRelationship` contract represents a connection between two clients within a factfind. Relationships track family connections (spouse, parent, child), business partnerships, and data sharing permissions between related clients.

### Business Purpose
- Track family groupings for household-level reporting and analysis
- Identify partner/spouse relationships for joint financial planning
- Manage data sharing permissions between related clients
- Support estate planning and inheritance considerations
- Enable consolidated household financial views

### Key Features
- Bidirectional relationships between clients in the same factfind
- Supports family relationships (spouse, parent, child, sibling, etc.)
- Supports non-family relationships (business partner, trustee, guardian)
- Configurable permission flags for data viewing and access
- Partner flag for primary spouse/partner identification
- Family grouping for household aggregation

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique identifier for the relationship | 9876 |
| href | Text | Resource URL for this relationship | v2/factfinds/234/clients/1234/relationships/9876 |
| client | Reference Link | The primary client in this relationship | Complex object |
| factfind | Reference Link | FactFind reference | Complex object |
| relatedClient | Reference Link | The related client | Complex object |
| relationshipType | Enum (Text) | Type of relationship. See enumerations below | Spouse |
| partner | Yes/No | Whether this is a partner/spouse relationship | Yes |
| familyGrouping | Yes/No | Whether to include in family grouping/household reporting | Yes |
| canRelatedViewClientsPlansAssets | Yes/No | Can related client view this client's plans and assets? | Yes |
| canClientViewRelatedsPlansAssets | Yes/No | Can this client view related client's plans and assets? | Yes |
| canRelatedAccessClientsData | Yes/No | Can related client access/modify this client's data? | No |
| canClientAccessRelatedsData | Yes/No | Can this client access/modify related client's data? | No |
| createdAt | Date and Time | When this record was created (read-only) | 2026-02-23T10:30:00Z |
| updatedAt | Date and Time | When this record was last updated (read-only) | 2026-02-23T10:30:00Z |
| createdBy | Text | User who created this record (read-only) | adviser@example.com |
| updatedBy | Text | User who last updated this record (read-only) | adviser@example.com |

#### Nested Field Groups

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique client identifier | 1234 |
| href | Text | Client resource URL | v2/factfinds/234/clients/1234 |
| name | Text | Client name | John Smith |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique FactFind identifier | 234 |
| href | Text | FactFind resource URL | v2/factfinds/234 |

**relatedClient:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique client identifier | 1235 |
| href | Text | Client resource URL | v2/factfinds/234/clients/1235 |
| name | Text | Client name | Sarah Smith |

### Enumerations

#### relationshipType Values

**Immediate Family:**
- `Spouse` - Married partner
- `Partner` - Unmarried partner
- `CivilPartner` - Civil partnership
- `Son` - Son
- `Daughter` - Daughter
- `Father` - Father
- `Mother` - Mother
- `Brother` - Brother
- `Sister` - Sister

**Extended Family:**
- `Grandfather` - Grandfather
- `Grandmother` - Grandmother
- `Grandson` - Grandson
- `Granddaughter` - Granddaughter
- `Uncle` - Uncle
- `Aunt` - Aunt
- `Nephew` - Nephew
- `Niece` - Niece
- `Cousin` - Cousin

**Blended Family:**
- `StepFather` - Step-father
- `StepMother` - Step-mother
- `StepSon` - Step-son
- `StepDaughter` - Step-daughter
- `StepBrother` - Step-brother
- `StepSister` - Step-sister

**In-Law Relationships:**
- `FatherInLaw` - Father-in-law
- `MotherInLaw` - Mother-in-law
- `SonInLaw` - Son-in-law
- `DaughterInLaw` - Daughter-in-law
- `BrotherInLaw` - Brother-in-law
- `SisterInLaw` - Sister-in-law

**Non-Family:**
- `BusinessPartner` - Business partner
- `Trustee` - Trustee
- `Guardian` - Guardian
- `Dependant` - Dependant
- `Other` - Other relationship type

### Validation Rules
- `relatedClient.id` - Required, must reference an existing client in the same factfind
- `relationshipType` - Required, must be a valid relationship type from the enumeration
- `partner` - Optional boolean, default: false
- `familyGrouping` - Optional boolean, default: false
- Permission flags (`can*`) - Optional booleans, default: false
- Cannot create a relationship from a client to themselves
- Cannot create duplicate relationships (same client pair and relationship type)
- `client` and `relatedClient` are immutable after creation

### Business Rules
- Related client must exist in the same factfind
- Only one relationship per client can be marked as `partner: true`
- Family grouping enables household-level aggregation in reporting
- Permission flags control data visibility and access between related clients
- Creating a Spouse, Partner, or CivilPartner relationship automatically sets `partner: true` if not specified
- Deleting a client does not automatically delete their relationships
- Relationships are directional - reciprocal relationships must be created separately if needed

### Permission Flags Explained

- **canRelatedViewClientsPlansAssets**: Allows the related client to view (read-only) this client's financial plans, goals, and asset information
- **canClientViewRelatedsPlansAssets**: Allows this client to view (read-only) the related client's financial plans, goals, and asset information
- **canRelatedAccessClientsData**: Allows the related client to access and potentially modify this client's data (requires additional authorization)
- **canClientAccessRelatedsData**: Allows this client to access and potentially modify the related client's data (requires additional authorization)

### Usage Scenarios

**Scenario 1: Married couple joint factfind**
- Create Spouse relationship between husband and wife
- Set `partner: true` and `familyGrouping: true`
- Enable bidirectional viewing permissions for transparency
- Household reporting aggregates both clients' finances

**Scenario 2: Parent-child relationship**
- Create Father/Mother relationship from parent to adult child
- Set `familyGrouping: true` for estate planning purposes
- Set `canClientViewRelatedsPlansAssets: true` if parent wants to monitor child's finances
- Keep access permissions false for privacy

**Scenario 3: Business partners**
- Create BusinessPartner relationship between corporate clients
- Set `familyGrouping: false`
- Configure viewing permissions based on business agreement
- Supports business succession planning

**Scenario 4: Trust arrangement**
- Create Trustee relationship from settlor to trustee
- Set `canRelatedViewClientsPlansAssets: true` for trustee oversight
- Track relationship for estate planning documentation

### Calculation Impact

Client relationships affect:
- **Household Income**: Sum of income across family grouping
- **Household Net Worth**: Combined net worth of family grouping
- **Joint Assets**: Assets marked as jointly owned between related clients
- **Estate Planning**: Beneficiary and inheritance calculations
- **Affordability**: Combined household income for joint mortgage applications

---

## 13.39 Estate Planning Contract

### Overview
The `EstatePlanning` contract represents a comprehensive overview of a client's estate planning arrangements. This is a singleton resource - each client has exactly one estate planning record that captures will details, asset values, inheritance tax planning, and associated gifts.

### Business Purpose
- Provide centralized estate planning information for IHT calculations
- Track will details and beneficiary arrangements
- Record gifts made and planned (PETs, trusts, exemptions)
- Calculate inheritance tax liability and available reliefs
- Support estate planning advice and recommendations

### Key Features
- Singleton resource per client
- Captures will details in free text format
- Tracks total assets and joint assets for IHT calculations
- Records gift history (last 7 years, recent, regular)
- Supports inheritance tax reliefs (RNRB, widow's relief, business asset relief)
- Includes gifts collection as sub-resource
- Supports both standard gifts and trust-based arrangements

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| href | Text | Resource URL for this estate planning record | v2/factfinds/345/clients/456/estate-planning |
| client | Reference Link | Client reference | Complex object |
| factfind | Reference Link | FactFind reference | Complex object |
| willDetails | Text | Free-text description of will arrangements | Standard will with spouse as primary beneficiary... |
| totalAssets | Currency Amount | Total value of client's estate | Complex object |
| totalJointAssets | Currency Amount | Total value of jointly owned assets | Complex object |
| giftInLast7YearsDetails | Text | Description of gifts made in last 7 years | Gifted £10,000 to daughter in 2020 for house deposit |
| recentGiftDetails | Text | Description of recent gifts (current tax year) | Used £3,000 annual exemption this tax year... |
| regularGiftDetails | Text | Description of regular gifts from income | £200 monthly to grandchildren from income since 2022 |
| expectingInheritanceDetails | Text | Description of expected inheritance | Expecting £50,000 from father's estate... |
| propertyAdditionalNrb | Currency Amount | Residence nil rate band (max £175,000) | Complex object |
| taxYearWhenPropertySold | Number | Tax year when main residence was sold (if applicable) | 2023 |
| widowsReliefNrbDeceasedPercentage | Number (Percentage) | Percentage of deceased spouse's NRB available to transfer | 50.00 |
| widowsReliefPropertyAdditionalNrbDeceasedPercentage | Number (Percentage) | Percentage of deceased spouse's RNRB available to transfer | 50.00 |
| businessAssetRelief | Currency Amount | Business property relief available | Complex object |
| gifts | List of Complex Data | Collection of gifts (see Gift contract) | List with 2 item(s) |
| createdAt | Date and Time | When this record was created (read-only) | 2026-01-15T09:00:00Z |
| updatedAt | Date and Time | When this record was last updated (read-only) | 2026-02-23T14:30:00Z |

#### Nested Field Groups

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique client identifier | 456 |
| href | Text | Client resource URL | v2/factfinds/345/clients/456 |
| name | Text | Client name | John Smith |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique FactFind identifier | 345 |
| href | Text | FactFind resource URL | v2/factfinds/345 |

**Currency Amount Structure (applies to totalAssets, totalJointAssets, propertyAdditionalNrb, businessAssetRelief):**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| currency | Text | ISO currency code | GBP |
| amount | Number | The monetary value | 500000.00 |

**Gift Item Structure (gifts array):**

See section 13.41 Estate Planning - Gift Contract for full gift structure.

### Validation Rules
- All text fields are optional, max 2000 characters
- Currency amounts must include both currency and amount if provided
- `taxYearWhenPropertySold` - Must be a valid tax year (e.g., 2023) if provided
- `widowsReliefNrbDeceasedPercentage` - Must be between 0 and 100 if provided
- `widowsReliefPropertyAdditionalNrbDeceasedPercentage` - Must be between 0 and 100 if provided
- `propertyAdditionalNrb` - Maximum £175,000 per person (2024/25 tax year)
- `totalJointAssets` - Should be included in `totalAssets` value

### Business Rules
- Estate planning is a singleton per client
- Total assets should include all property, investments, pensions, savings, etc.
- Total joint assets represents portion of total assets owned jointly
- Gifts are managed as sub-resource via separate API endpoints
- Property additional NRB (RNRB) applies only if main residence left to direct descendants
- RNRB tapers away for estates over £2 million
- Widow's relief allows transfer of unused NRB/RNRB from deceased spouse
- Business asset relief provides 50% or 100% relief on qualifying business property
- Gifts in last 7 years affect IHT calculation (taper relief applies years 3-7)

### IHT Planning Notes

**Nil Rate Band (NRB):**
- £325,000 per person (frozen until 2030)
- Transferable to surviving spouse/civil partner
- Applies to lifetime gifts and death estate

**Residence Nil Rate Band (RNRB):**
- Additional £175,000 per person (2024/25)
- Only if main residence left to direct descendants
- Tapers for estates over £2 million (£1 lost per £2 over threshold)
- Transferable to surviving spouse/civil partner

**Potentially Exempt Transfers (PETs):**
- Gifts to individuals become exempt after 7 years
- Taper relief applies if donor dies within 3-7 years
- Full IHT at 40% if donor dies within 3 years

**Regular Gifts from Income:**
- Exempt if from surplus income (not capital)
- Must be regular pattern of giving
- Must not affect donor's standard of living
- No limit on amount

**Annual Exemptions:**
- £3,000 per tax year
- Can carry forward one year if unused
- Plus £250 small gifts exemption per recipient

### Usage Scenarios

**Scenario 1: Initial estate planning discussion**
- Capture will details and beneficiary wishes
- Record total estate value and joint assets
- Document any gifts made or planned
- Calculate potential IHT liability

**Scenario 2: IHT calculation**
- Use total assets to determine estate value
- Apply NRB and RNRB allowances
- Factor in widow's relief if applicable
- Deduct business asset relief
- Account for gifts in last 7 years with taper relief

**Scenario 3: Widow with transferred allowances**
- Widow has 50% of deceased husband's NRB unused
- Set `widowsReliefNrbDeceasedPercentage: 50`
- Total NRB available: £325k + £162.5k = £487,500

**Scenario 4: Downsizing**
- Client sold main residence in 2023
- May still claim RNRB if downsized
- Record `taxYearWhenPropertySold: 2023`
- RNRB available if meets downsizing rules

---

## 13.40 Estate Planning - Will Contract
### Overview
The `Will` contract represents a client's last will and testament details.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| client | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2026-01-10T10:00:00Z |
| executors | List of Complex Data |  | List with 2 item(s) |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8496 |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**mirrorWillClientRef:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 912 |

**willLocation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| address | Text | List of all addresses for this client (current and historical) | 45 Legal Square, London, EC4A 1BR |
| heldBy | Text |  | Williams & Associates Solicitors |
| notes | Text |  | Original will held by solicitor - copy at home |

---

## 13.40 Estate Planning - Lasting Power of Attorney (LPA) Contract
### Overview
The `LastingPowerOfAttorney` contract represents a client's LPA arrangements.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| attorneys | List of Complex Data |  | List with 2 item(s) |
| certificateProvider | Complex Data | Unique system identifier for this record | Complex object |
| client | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2023-09-25T10:00:00Z |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8496 |

**factfind:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |

**lpaLocation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| heldBy | Text |  | Home Safe |
| notes | Text |  | Original registered LPA stored in home safe. Copy ... |

---

## 13.41 Estate Planning - Gift Contract
### Overview
The `Gift` contract represents gifts made or planned by the client for inheritance tax (IHT) planning. Gifts can be either standard potentially exempt transfers (PETs) or trust-based gifts such as loan trusts and discounted gift trusts.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| description | Text | Description of the gift | Cash gift to help with house deposit |
| discountValue | Currency Amount | **Trust gifts only.** The discount value for discounted gift trusts | Complex object |
| exemption1 | Text | Primary exemption applied to the gift | AnnualExemption |
| exemption2 | Text | Secondary exemption applied to the gift (optional) | SmallGiftExemption |
| exemption3 | Text | Tertiary exemption applied to the gift (optional) | NoExemption |
| giftType | Text | Type of gift for IHT planning purposes | PotentiallyExemptTransfer |
| giftValue | Currency Amount | **Standard gifts only.** The monetary value of the gift | Complex object |
| href | Text | API resource link | v2/factfinds/345/clients/456/estate-planning/gifts/gift-001 |
| id | Text | Unique identifier for this gift | gift-001 |
| income | Currency Amount | **Trust gifts only.** Annual income generated by the trust | Complex object |
| incomeStartYear | Number | **Trust gifts only.** Year when income payments begin | 2024 |
| isTrust | Yes/No | Indicates whether this is a trust-based gift | No |
| originalInvestmentAmount | Currency Amount | **Trust gifts only.** Original amount invested in the trust | Complex object |
| repeatGiftYears | Number | **Trust gifts only.** Number of years the gift is repeated | 10 |

### Gift Types

| Gift Type | Description |
|---|---|
| **PotentiallyExemptTransfer** | Standard gift that becomes exempt if donor survives 7 years |
| **LoanTrust** | Loan trust arrangement where capital can be reclaimed |
| **DiscountedGiftTrust** | Gift with retained income rights, reducing IHT value |
| **BareGift** | Simple outright gift with no strings attached |
| **GiftWithReservation** | Gift where donor retains benefit (counted in estate) |
| **ChritableGift** | Gift to registered charity (immediately exempt) |
| **PoliticalGift** | Gift to registered political party (immediately exempt) |

### Gift Exemptions

| Exemption | Annual Limit | Description |
|---|---|---|
| **NoExemption** | N/A | No exemption claimed for this gift |
| **AnnualExemption** | £3,000 | Annual gift exemption (can carry forward 1 year) |
| **SmallGiftExemption** | £250 | Small gifts to any number of people (cannot combine with annual exemption to same person) |
| **MarriageExemption** | £5,000 / £2,500 / £1,000 | Wedding/civil partnership gifts (varies by relationship) |
| **RegularGiftsFromIncome** | Unlimited | Regular gifts from surplus income that don't affect living standards |
| **MaintenancePayments** | Unlimited | Maintenance for dependent relatives |
| **NormalExpenditure** | Unlimited | Normal expenditure from income patterns |

#### Nested Field Groups

**giftValue** (for standard gifts):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Monetary value of the gift | 50000.00 |
| currency | Text | Currency code | GBP |

**originalInvestmentAmount** (for trust gifts):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Original amount invested | 200000.00 |
| currency | Text | Currency code | GBP |

**discountValue** (for discounted gift trusts):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Discount applied to gift value | 80000.00 |
| currency | Text | Currency code | GBP |

**income** (for trust gifts with income):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Annual income amount | 12000.00 |
| currency | Text | Currency code | GBP |

### Gift Structure Patterns

#### Standard Gift (PET)
Standard gifts use the `giftValue` field and typically qualify for annual or small gift exemptions:

```json
{
  "id": "gift-001",
  "href": "v2/factfinds/345/clients/456/estate-planning/gifts/gift-001",
  "description": "Cash gift to help with house deposit",
  "giftType": "PotentiallyExemptTransfer",
  "isTrust": false,
  "giftValue": {"currency": "GBP", "amount": 50000.00},
  "exemption1": "AnnualExemption",
  "exemption2": "SmallGiftExemption",
  "exemption3": "NoExemption"
}
```

#### Loan Trust Gift
Loan trusts use trust-specific fields and typically have no exemptions as the capital can be reclaimed:

```json
{
  "id": "gift-002",
  "href": "v2/factfinds/345/clients/456/estate-planning/gifts/gift-002",
  "description": "Loan trust for estate planning",
  "giftType": "LoanTrust",
  "isTrust": true,
  "originalInvestmentAmount": {"currency": "GBP", "amount": 200000.00},
  "income": {"currency": "GBP", "amount": 12000.00},
  "incomeStartYear": 2024,
  "repeatGiftYears": 10,
  "exemption1": "NoExemption",
  "exemption2": "NoExemption",
  "exemption3": "NoExemption"
}
```

#### Discounted Gift Trust
Discounted gift trusts include a discount value based on retained income rights:

```json
{
  "id": "gift-003",
  "href": "v2/factfinds/345/clients/456/estate-planning/gifts/gift-003",
  "description": "Discounted gift trust with retained income",
  "giftType": "DiscountedGiftTrust",
  "isTrust": true,
  "originalInvestmentAmount": {"currency": "GBP", "amount": 300000.00},
  "discountValue": {"currency": "GBP", "amount": 100000.00},
  "income": {"currency": "GBP", "amount": 15000.00},
  "incomeStartYear": 2024,
  "exemption1": "NoExemption",
  "exemption2": "NoExemption",
  "exemption3": "NoExemption"
}
```

### Business Rules

1. **Gift Type and Fields:**
   - Standard gifts (`isTrust: false`) MUST have `giftValue`
   - Trust gifts (`isTrust: true`) MUST have `originalInvestmentAmount`
   - Discounted gift trusts MUST have `discountValue`
   - Standard gifts MUST NOT have trust-specific fields (originalInvestmentAmount, discountValue, income, incomeStartYear, repeatGiftYears)

2. **Exemption Rules:**
   - `exemption1` is required (use `NoExemption` if no exemption applies)
   - `exemption2` and `exemption3` are optional additional exemptions
   - Annual exemption (£3,000) can be carried forward one year if unused
   - Small gift exemption (£250) cannot be combined with annual exemption for same recipient
   - Marriage exemption varies by relationship: £5,000 (child), £2,500 (grandchild), £1,000 (other)

3. **Trust Gift Taxation:**
   - Loan trusts: Capital can be reclaimed, so not immediately chargeable
   - Discounted gift trusts: Only discounted value (original - discount) is potentially exempt
   - Income retained from discounted gift trusts does not add to estate value

4. **PET Rules:**
   - Potentially exempt transfers become fully exempt after 7 years
   - Taper relief applies to PETs between 3-7 years if donor dies
   - Taper relief: 3-4 years (20% relief), 4-5 years (40%), 5-6 years (60%), 6-7 years (80%)

### IHT Planning Considerations

**Seven-Year Rule:**
- Gifts become exempt if donor survives 7 years
- Taper relief applies between years 3-7
- Important to track gift dates for estate planning

**Annual Exemptions Strategy:**
- Use £3,000 annual exemption each year
- Carry forward unused exemption from previous year
- Combine with small gift exemption (£250) for multiple recipients

**Trust-Based Gifts:**
- Loan trusts allow capital access while removing growth from estate
- Discounted gift trusts provide income while reducing estate value
- Trust gifts typically more complex but offer flexibility

**Regular Gifts from Income:**
- Immediately exempt if from surplus income
- Must not reduce donor's living standards
- Must establish pattern of regular gifts
- Documentation critical for claiming exemption

---

## 13.42 Estate Planning - Trust Contract
### Overview
The `Trust` contract represents trusts established by or benefiting the client.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| beneficiaries | List of Complex Data | List of trust beneficiaries | List with 2 item(s) |
| client | Reference Link |  | Complex object |
| clientRole | Text |  | SETTLOR |
| createdAt | Date | When this record was created in the system | 2020-03-20T10:00:00Z |
| establishedDate | Date | Date the trust was established | 2020-03-15 |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8496 |

**factfind:**

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

## 13.43 Identity Verification Contract
### Overview
The `IdentityVerification` contract represents comprehensive identity verification and KYC/AML compliance data for a client. This is a singleton resource - each client has exactly one identity verification record.

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| href | Text | Resource URL | v2/factfinds/3454/clients/31514626/idverifications |
| client | Complex Data | Client personal information | Complex object |
| contacts | List of Complex Data | Contact methods | List with 1 item(s) |
| currentAddress | Complex Data | Current residential address | Complex object |
| previousAddresses | List of Complex Data | Address history | List with 1 item(s) |
| clientIdentity | Complex Data | Identity documents | Complex object |
| supportingDocuments | List of Reference Link | Uploaded document references | List with 1 item(s) |
| adviser | Reference Link | Adviser who performed verification | Complex object |
| verification | Complex Data | Witness and premises verification | Complex object |
| verificationResult | Complex Data | Third-party verification result | Complex object |
| comments | Text | Additional notes | successful. |
| createdAt | DateTime | Record creation timestamp | 2024-01-16T09:00:00Z |
| updatedAt | DateTime | Last update timestamp | 2024-01-16T15:20:00Z |
| createdBy | Text | User who created the record | adviser@example.com |
| updatedBy | Text | User who last updated the record | adviser@example.com |

#### Nested Field Groups

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique client identifier | 31514626 |
| href | Text | Client resource URL | v2/factfinds/3454/clients/31514626 |
| title | Text | Title (Mr, Mrs, Ms, etc.) | Mr |
| firstName | Text | First name | John |
| middleName | Text | Middle name | David |
| lastName | Text | Last name | Smith |
| gender | Text | Gender | Male |
| dateOfBirth | DateTime | Date of birth | 1985-03-15T00:00:00 |
| mothersMaidenName | Text | Mother's maiden name | Johnson |
| placeOfBirth | Text | Place of birth | London |
| countryOfBirth | Complex Data | Country of birth code | Complex object |
| code | Text | ISO country code | GB |
| placeOfBirthOther | Text | Additional birth location details | Westminster Hospital |

**contacts:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| type | Text | Contact type (Telephone, Email, etc.) | Telephone |
| value | Text | Contact value | +44 7700 900123 |

**currentAddress:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| residentFrom | DateTime | Date moved to address | 2020-01-15T00:00:00 |
| yearsAtAddress | Text | Years at address | 4 |
| address | Complex Data | Address details | Complex object |
| line1 | Text | Address line 1 | 123 High Street |
| line2 | Text | Address line 2 | Flat 4B |
| line3 | Text | Address line 3 | Westminster |
| line4 | Text | Address line 4 | Greater London |
| locality | Text | City/town | London |
| postalCode | Text | Postal code | SW1A 1AA |
| country | Complex Data | Country code | Complex object |
| code | Text | ISO country code | GB |
| county | Complex Data | County code | Complex object |
| code | Text | County code | GB-LND |

**previousAddresses:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| residentFrom | DateTime | Date moved to address | 2015-06-01T00:00:00 |
| yearsAtAddress | Text | Years at address | 5 |
| address | Complex Data | Address details (same structure as currentAddress) | Complex object |

**clientIdentity:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| passport | Complex Data | Passport details | Complex object |
| referenceNo | Text | Passport number | GB123456789 |
| seenOn | DateTime | Date document seen | 2024-01-10T00:00:00 |
| expiryOn | DateTime | Expiry date | 2030-12-31T00:00:00 |
| countryOfOrigin | Complex Data | Issuing country | Complex object |
| code | Text | ISO country code | GB |
| drivingLicence | Complex Data | Driving licence details | Complex object |
| referenceNo | Text | Licence number | SMITH851234JD9AB |
| seenOn | DateTime | Date document seen | 2024-01-10T00:00:00 |
| expiryOn | DateTime | Expiry date | 2030-12-31T00:00:00 |
| countryOfOrigin | Complex Data | Issuing country | Complex object |
| code | Text | ISO country code | GB |
| microfiche | Complex Data | Microfiche details | Complex object |
| number | Text | Microfiche number | MF123456 |
| issuedOn | DateTime | Issue date | 2020-05-15T00:00:00 |
| electricityBill | Complex Data | Electricity bill details | Complex object |
| referenceNo | Text | Bill reference | ELEC-2024-001 |
| seenOn | DateTime | Date document seen | 2024-01-15T00:00:00 |
| utilitiesBill | Complex Data | Utilities bill details | Complex object |
| councilTaxBill | Complex Data | Council tax bill details | Complex object |
| irTaxNotification | Complex Data | IR tax notification details | Complex object |
| bankStatement | Complex Data | Bank statement details | Complex object |
| mortgageStatement | Complex Data | Mortgage statement details | Complex object |
| firearmOrShotgunCertificate | Complex Data | Firearm certificate details | Complex object |

**supportingDocuments:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Document ID | 5001 |
| href | Text | Document resource URL | v2/documents/5001 |

**adviser:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Adviser ID | 789 |
| href | Text | Adviser resource URL | v2/advisers/789 |

**verification:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| witness | Complex Data | Witness verification | Complex object |
| position | Text | Witness position | Financial Adviser |
| witnessedOn | DateTime | Date witnessed | 2024-01-10T00:00:00 |
| premises | Complex Data | Premises verification | Complex object |
| lastVisitedOn | DateTime | Last visit date | 2024-01-08T00:00:00 |
| enteredOn | DateTime | Entry date | 2024-01-08T00:00:00 |
| expiryOn | DateTime | Verification expiry date | 2027-01-10T00:00:00 |

**verificationResult:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| providerName | Text | Verification provider | GBG |
| status | Enum (Text) | Status: Rejected, ManualReview, Accepted, Completed | Completed |
| outcome | Text | Verification outcome | Pass |
| score | Number | Verification score | 95 |
| verifiedOn | DateTime | Verification timestamp | 2024-01-16T10:30:45Z |
| certificateDocument | Reference Link | Certificate document | Complex object |
| id | Number | Document ID | 6001 |
| href | Text | Document resource URL | v2/documents/6001 |
| createdAt | DateTime | Result creation timestamp | 2024-01-16T10:15:00Z |
| updatedAt | DateTime | Result update timestamp | 2024-01-16T10:30:45Z |

### Enumerations

#### Verification Status
- `Rejected` - Verification failed
- `ManualReview` - Requires manual review
- `Accepted` - Verification accepted
- `Completed` - Verification completed successfully

---

## 13.44 Arrangement - Mortgage Contract

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
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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

**factfind:**

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
| loanToValue | Complex Data | Loan-to-Value at origination | Complex object |
| currentLTV | Complex Data | Current Loan-to-Value | Complex object |
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

**loanToValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| percentage | Number | LTV percentage at origination | 75.0 |
| propertyValue | Currency Amount | Property value at origination | Complex object |
| amount | Number | Amount | 400000.0 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |
| loanAmount | Currency Amount | Loan amount at origination | Complex object |
| amount | Number | Amount | 300000.0 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |
| calculatedOn | Date | Date of LTV calculation | 2018-06-15 |

**currentLTV:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| percentage | Number | Current LTV percentage | 57.65 |
| outstandingBalance | Currency Amount | Current outstanding balance | Complex object |
| amount | Number | Amount | 245000.0 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |
| currentPropertyValue | Currency Amount | Current property value | Complex object |
| amount | Number | Amount | 425000.0 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |
| calculatedOn | Date | Date of current LTV calculation | 2026-02-18 |

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


## 13.44A Investment Contract

### Business Purpose

Represents a comprehensive investment entity including investment accounts, life-assured investments, cash bank accounts, and investment bonds. This contract serves as a unified investment wrapper for all investment types with conditional fields based on the investment category.

**Note:** This is a standalone Plans entity, NOT part of Arrangements. Investments are managed independently at `/api/v2/factfinds/{id}/investments`.

### Key Features

- **Multi-Category Support** - Handles CashBankAccount, Investment, and lifeAssuredInvestment categories
- **Flexible Contributions** - Supports regular, lumpsum, and transfer contributions
- **Fund Holdings Management** - Tracks individual fund holdings with detailed codes and allocations
- **Life Assurance Integration** - Includes life cover and critical illness benefits for life-assured investments
- **Wrap Account Support** - Links to platform/wrap accounts
- **Maturity Projections** - Records low, medium, and high maturity value projections

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 15001 |
| href | Link | API resource link | /api/v2/factfinds/679/investments/15001 |
| factfind | Reference Link | Link to the FactFind that this investment belongs to | Complex object |
| owners | List of Complex Data | Clients who own this investment | List with 1-2 item(s) |
| sellingAdviser | Complex Data | Adviser who arranged this investment | Complex object |
| provider | Complex Data | Product provider/company | Complex object |
| lifeCycle | Complex Data | Investment lifecycle stage | Complex object |
| investmentCategory | Text | Category of investment | Investment |
| investmentType | Complex Data | Specific investment type/plan | Complex object |
| policyNumber | Text | Policy or account number | INV-123456789 |
| agencyStatus | Text | Agency servicing status | NOT_UNDER_AGENCY |
| productName | Text | Name of the investment product | Global Growth Portfolio |
| startedOn | Date | Investment start date | 2020-06-15 |
| endsOn | Date | Investment end/maturity date | 2035-06-15 |
| wrap | Complex Data | Platform/wrap account details | Complex object |
| valuation | Complex Data | Current valuation details | Complex object |
| cashAccount | Complex Data | Cash account specific details (CashBankAccount only) | Complex object |
| maturityDetails | Complex Data | Maturity projection details (Investment/lifeAssuredInvestment) | Complex object |
| monthlyIncome | Currency Amount | Monthly income from investment (Investment/lifeAssuredInvestment) | Complex object |
| isOriginalInvestmentProtected | Yes/No | Whether original capital is protected (Investment/lifeAssuredInvestment) | No |
| benefits | Complex Data | Life cover and critical illness benefits (lifeAssuredInvestment only) | Complex object |
| lifeAssured | List of Complex Data | Persons whose lives are assured (lifeAssuredInvestment only) | List with 1-2 item(s) |
| contributions | List of Complex Data | Investment contributions (regular, lumpsum, transfer) | List with 2 item(s) |
| fundHoldings | Complex Data | Individual fund holdings and allocations | Complex object |
| createdAt | Date | When this record was created in the system | 2020-06-15T10:00:00Z |
| updatedAt | Date | When this record was last modified | 2026-02-18T14:30:00Z |

#### Nested Field Groups

**owners:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Client unique identifier | 8496 |
| href | Link | API link to client resource | /api/v2/factfinds/679/clients/8496 |
| name | Text | Client full name | John Smith |

**sellingAdviser:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Adviser unique identifier | 123 |
| href | Link | API link to adviser resource | /api/v2/advisers/123 |
| name | Text | Adviser full name | Jane Financial Adviser |

**provider:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Product provider unique identifier | 456 |
| href | Link | API link to product provider resource | /api/v2/productproviders/456 |
| name | Text | Product provider name | Vanguard |

**lifeCycle:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Lifecycle unique identifier | 45 |
| href | Link | API link to lifecycle resource | /api/v2/lifecycles/45 |
| name | Text | Lifecycle stage name | Accumulation |

**investmentType:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Plan type unique identifier | 123 |
| href | Link | API link to plan type | /api/v2/plantypes?filter=id eq 123 |
| name | Text | Investment type name | Stocks & Shares ISA |

**wrap:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Wrap account identifier | 9001 |
| href | Link | Link to parent wrap account investment | /api/v2/factfinds/679/investments/9001 |
| reference | Text | Wrap account reference | WRAP-987654 |

**valuation:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| currentValue | Currency Amount | Current investment value | Complex object |
| amount | Number | Value amount | 125000.0 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |
| valuedOn | Date | Valuation date | 2026-02-18 |

**cashAccount** (applicable only for CashBankAccount category):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| interestRate | Number | Current interest rate percentage | 4.25 |
| currency | Text | Account currency | GBP |

**maturityDetails** (applicable only for Investment and lifeAssuredInvestment categories):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| maturityOn | Date | Maturity date | 2035-06-15 |
| lowMaturityValue | Currency Amount | Low projection value | Complex object |
| amount | Number | Low projection amount | 180000.0 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |
| mediumMaturityValue | Currency Amount | Medium projection value | Complex object |
| amount | Number | Medium projection amount | 245000.0 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |
| highMaturityValue | Currency Amount | High projection value | Complex object |
| amount | Number | High projection amount | 325000.0 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |
| maturityValueProjectionDetails | Text | Details on projection assumptions | Projections based on 3%, 5%, and 7% annual growth rates |

**benefits** (applicable only for lifeAssuredInvestment category):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| lifeCover | Complex Data | Life cover details | Complex object |
| criticalIllness | Complex Data | Critical illness cover details | Complex object |
| paymentBasis | Text | When benefit pays out | FirstDeath |
| isInTrust | Yes/No | Whether policy is held in trust | Yes |
| inTrustToWhom | Text | Trust beneficiaries | Children: Emily and James Smith |

**benefits.lifeCover:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| sumAssured | Currency Amount | Life cover amount | Complex object |
| amount | Number | Cover amount | 250000.0 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |
| termInYears | Number | Cover term in years | 20 |

**benefits.criticalIllness:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| sumAssured | Currency Amount | Critical illness cover amount | Complex object |
| amount | Number | Cover amount | 250000.0 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |
| termInYears | Number | Cover term in years | 20 |

**lifeAssured** (applicable only for lifeAssuredInvestment category):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| title | Text | Title | Mr |
| firstName | Text | First name | John |
| lastName | Text | Last name | Smith |
| dateOfBirth | Date | Date of birth | 1980-05-15 |
| gender | Text | Gender | Male |
| client | Complex Data | Link to client record | Complex object |
| id | Number | Client identifier | 8496 |
| href | Link | Link to client | /api/v2/factfinds/679/clients/8496 |

**contributions:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| type | Text | Contribution type | regular |
| value | Currency Amount | Contribution amount | Complex object |
| amount | Number | Contribution amount | 500.0 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |
| startedOn | Date | Contribution start date | 2020-06-15 |
| endOn | Date | Contribution end date (null if ongoing) | null |
| contributor | Text | Who makes the contribution | Self |
| transfer | Complex Data | Transfer details (if type = Transfer) | Complex object |

**contributions.transfer** (when type = Transfer):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| transferType | Text | Type of transfer | Cash |
| isFullTransfer | Yes/No | Whether full transfer | Yes |
| ceedingPlan | Complex Data | Plan being transferred from | Complex object |
| id | Number | Ceeding plan identifier | 8001 |
| href | Link | Link to ceeding plan | /api/v2/factfinds/679/investments/8001 |
| reference | Text | Ceeding plan reference | OLD-PLAN-12345 |

**fundHoldings:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| model | Complex Data | Model portfolio details | Complex object |
| funds | List of Complex Data | Individual fund holdings | List with 5 item(s) |

**fundHoldings.model:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Model portfolio code | BALANCED-GROWTH-60-40 |
| Name | Text | Model portfolio name | BALANCED GROWTH-60-40 |

**fundHoldings.funds:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| codes | List of Complex Data | Fund identification codes | List with 2 item(s) |
| name | Text | Fund name | Vanguard FTSE Global All Cap Index Fund |
| holding | Complex Data | Holding details | Complex object |
| isFeed | Yes/No | Whether this is a feeder fund | No |
| type | Text | Fund type | Fund |

**fundHoldings.funds.codes:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Code type | ISIN |
| value | Text | Code value | GB00BD3RZ582 |

**fundHoldings.funds.holding:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| units | Number | Number of units held | 1250.567 |
| percentage | Number | Percentage of total portfolio | 35.5 |

### Relationships

This contract connects to:

- Belongs to a FactFind
- Owned by one or more Clients (owners)
- Advised by a Selling Adviser
- May be held within a Wrap account (parent investment)
- May be ceeded to/from other investments (transfers)
- Links to LifeCycle stage
- References Investment Type/Plan Type

### Business Validation Rules

**Category-Based Validation:**
- `cashAccount` fields only applicable when `investmentCategory = CashBankAccount`
- `maturityDetails`, `monthlyIncome`, `isOriginalInvestmentProtected` only applicable for `Investment` or `lifeAssuredInvestment`
- `benefits` and `lifeAssured` only applicable when `investmentCategory = lifeAssuredInvestment`

**Required Fields:**
- `investmentCategory` is required (defaults to "Investment")
- `investmentType` is required
- `owners` list must contain at least one owner
- `valuation.currentValue` is required
- `valuation.valuedOn` is required

**Contribution Validation:**
- When `contributions.type = Transfer`, `transfer` object is required
- When `contributions.type = regular`, `startedOn` is required
- `contributor` must be one of: Self, Employer, Other, N_A, Government, Relative, SalarySacrifice, PartnerOrSpouse, HeldInSuper

**Fund Holdings Validation:**
- `fundHoldings.funds.holding.percentage` values must sum to 100% across all funds
- At least one fund code must be provided for each fund
- `fundHoldings.funds.type` must be one of: Fund, Equity, Bond, Property, Cash, Commodity, Other

**Investment Category Values:**
- `CashBankAccount` - Bank accounts, savings accounts, cash ISAs
- `Investment` - General investments, unit trusts, OEICs, investment bonds (without life cover)
- `lifeAssuredInvestment` - Investment bonds with life assurance, whole of life policies with investment element

**Agency Status Values:**
- `NOT_UNDER_AGENCY` - Investment not under agency servicing
- `UNDER_AGENCY_INFORMATION_ONLY` - Agency provides information only
- `UNDER_AGENCY_SERVICING_AGENT` - Full agency servicing

**Payment Basis Values** (for lifeAssuredInvestment):
- `FirstDeath` - Benefit pays on first death
- `SecondDeath` - Benefit pays on second death (survivorship)
- `Both` - Separate benefits for each life

**Contributor Values:**
- `Self` - Client's own contributions
- `Employer` - Employer contributions
- `Other` - Other third party
- `N_A` - Not applicable
- `Government` - Government contributions (e.g., tax relief)
- `Relative` - Family member contributions
- `SalarySacrifice` - Salary sacrifice arrangements
- `PartnerOrSpouse` - Partner or spouse contributions
- `HeldInSuper` - Held in superannuation (non-UK)

**Transfer Type Values:**
- `Cash` - Cash transfer (liquidate and transfer proceeds)
- `Inspecie` - In-specie transfer (transfer actual holdings)

**Fund Code Types:**
- `ISIN` - International Securities Identification Number
- `SEDOL` - Stock Exchange Daily Official List
- `PlatForm` - Platform-specific code
- `CITI` - Citi fund code
- `MEXID` - MEX ID
- `Bloomberg` - Bloomberg ticker
- Other provider-specific codes

### Common Use Cases

**1. Stocks & Shares ISA:**
```
investmentCategory: Investment
investmentType: Stocks & Shares ISA
contributions: regular, type: Self
fundHoldings: Multiple funds with ISIN codes
maturityDetails: Projections for long-term growth
```

**2. Investment Bond with Life Cover:**
```
investmentCategory: lifeAssuredInvestment
benefits: lifeCover and criticalIllness populated
lifeAssured: List of assured lives
contributions: lumpsum from pension transfer
paymentBasis: FirstDeath
isInTrust: Yes
```

**3. Cash Bank Account:**
```
investmentCategory: CashBankAccount
cashAccount: interestRate populated
contributions: regular deposits
No maturityDetails or benefits
```

**4. Investment Transfer:**
```
contributions.type: Transfer
contributions.transfer.transferType: Inspecie
contributions.transfer.ceedingPlan: Link to old investment
contributions.transfer.isFullTransfer: Yes
```

**5. Wrap Platform Account:**
```
wrap: null (this IS the wrap)
Other investments reference this as their wrap.id
fundHoldings: Aggregated across all sub-accounts
```

---


## 13.44B Final Salary Pension Contract

### Business Purpose

Represents a defined benefit (final salary) pension scheme including public sector schemes, private sector final salary schemes, and career average revalued earnings (CARE) schemes. This contract captures comprehensive pension benefits, transfer values, and retirement options.

**Note:** This is a standalone Plans entity, NOT part of Arrangements. Final salary pensions are managed independently at `/api/v2/factfinds/{id}/pensions/finalsalary`.

### Key Features

- **Defined Benefit Tracking** - Accrual rates, pensionable salary, and prospective benefits
- **Transfer Value Management** - Cash Equivalent Transfer Value (CETV) with expiry tracking
- **Retirement Options** - Normal, early, and late retirement scenarios with reduction factors
- **Death Benefits** - Spousal pensions, dependant benefits, and death in service provisions
- **GMP Tracking** - Guaranteed Minimum Pension from contracting out
- **Scheme Enhancements** - Additional Voluntary Contributions (AVCs), added years, affinity DC schemes
- **Indexation** - Inflation protection and revaluation terms

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 15001 |
| href | Link | API resource link | /api/v2/factfinds/679/pensions/finalsalary/15001 |
| factfind | Reference Link | Link to the FactFind | Complex object |
| owners | List of Complex Data | Clients who own this pension | List with 1 item(s) |
| sellingAdviser | Complex Data | Adviser who provides advice on this pension | Complex object |
| provider | Complex Data | Pension scheme provider/administrator | Complex object |
| lifeCycle | Complex Data | Pension lifecycle stage | Complex object |
| wrap | Complex Data | Platform/wrap account details | Complex object |
| pensionCategory | Text | Category of pension | PensionDefinedBenefit |
| pensionType | Complex Data | Specific pension type/plan | Complex object |
| policyNumber | Text | Policy or scheme member number | NHS-DB-987654 |
| agencyStatus | Text | Agency servicing status | NotUnderAgency |
| agencyStatusDate | Date | Date of agency status | 2023-01-15 |
| productName | Text | Name of the pension scheme | NHS Pension Scheme (1995 Section) |
| currency | Complex Data | Scheme currency | Complex object |
| status | Text | Current status | ACTIVE |
| employer | Text | Employer providing the scheme | Royal London Hospital Trust |
| normalRetirementAge | Number | Normal retirement age for the scheme | 60 |
| pensionAtRetirement | Complex Data | Prospective pension benefits at retirement | Complex object |
| accrualRate | Text | Benefit accrual rate | 1/80th |
| schemeType | Text | Type of scheme | PUBLIC_SECTOR |
| dateSchemeJoined | Date | Date member joined the scheme | 1995-09-01 |
| expectedYearsOfService | Number | Expected total years of service | 35.0 |
| pensionableSalary | Currency Amount | Current pensionable salary | Complex object |
| isIndexed | Yes/No | Whether pension is inflation-linked | Yes |
| indexationNotes | Text | Details of indexation provisions | CPI linked annual increases, capped at 5% p.a. |
| isPreserved | Yes/No | Whether this is a preserved (deferred) pension | No |
| transferValue | Complex Data | Cash Equivalent Transfer Value details | Complex object |
| gmpAmount | Currency Amount | Guaranteed Minimum Pension amount | Complex object |
| deathInService | Complex Data | Death in service benefits | Complex object |
| earlyRetirement | Complex Data | Early retirement provisions | Complex object |
| dependantBenefits | Text | Benefits for dependants | Children's pensions until age 23 |
| purchaseAddedYears | Complex Data | Option to purchase added years | Complex object |
| affinityDCScheme | Complex Data | Affinity defined contribution scheme | Complex object |
| additionalNotes | Text | Additional scheme information | Protected rights included |
| createdAt | Date | When this record was created | 2023-01-15T10:00:00Z |
| updatedAt | Date | When this record was last modified | 2026-02-25T14:30:00Z |

#### Nested Field Groups

**owners:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Client unique identifier | 8496 |
| href | Link | API link to client resource | /api/v2/factfinds/679/clients/8496 |
| name | Text | Client full name | John Smith |
| ownershipPercentage | Number | Ownership percentage | 100.0 |

**sellingAdviser:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Adviser unique identifier | 123 |
| href | Link | API link to adviser resource | /api/v2/advisers/123 |
| name | Text | Adviser full name | Jane Financial Adviser |

**provider:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Product provider unique identifier | 456 |
| href | Link | API link to product provider resource | /api/v2/productproviders/456 |
| name | Text | Scheme provider/administrator name | NHS Pensions |

**lifeCycle:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Lifecycle unique identifier | 45 |
| href | Link | API link to lifecycle resource | /api/v2/lifecycles/45 |
| name | Text | Lifecycle stage name | Accumulation |

**pensionType:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Plan type unique identifier | 123 |
| href | Link | API link to plan type | /api/v2/plantypes?filter=id eq 123 |
| name | Text | Pension type name | Final Salary Pension |

**wrap:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Platform/wrap account identifier | 234 |
| href | Link | API link to investment resource | /api/v2/factfinds/679/investments/234 |
| reference | Text | Platform account reference | WRAP-ACC-123456 |

**currency:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Currency code | GBP |
| display | Text | Currency display name | British Pound |
| symbol | Text | Currency symbol | £ |

**pensionAtRetirement:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| prospectiveWithNoLumpsumTaken | Currency Amount | Annual pension if no lump sum taken | Complex object |
| amount | Number | Pension amount | 45000.00 |
| currency | Complex Data | Currency details | Complex object |
| prospectiveWithLumpsumTaken | Currency Amount | Annual pension if maximum lump sum taken | Complex object |
| amount | Number | Pension amount | 33750.00 |
| currency | Complex Data | Currency details | Complex object |
| prospectiveLumpSum | Currency Amount | Tax-free lump sum available | Complex object |
| amount | Number | Lump sum amount | 135000.00 |
| currency | Complex Data | Currency details | Complex object |

**pensionableSalary:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Pensionable salary amount | 65000.00 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| display | Text | Currency display name | British Pound |
| symbol | Text | Currency symbol | £ |

**transferValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| cashEquivalentValue | Currency Amount | CETV amount | Complex object |
| amount | Number | Transfer value | 950000.00 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |
| expiryOn | Date | Date CETV expires | 2026-04-15 |

**gmpAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | GMP weekly amount | 1250.00 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| symbol | Text | Currency symbol | £ |

**deathInService:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| spousalBenefits | Number | Spouse's pension as % of member's pension | 50.0 |
| lumpsumMultiple | Number | Lump sum death benefit (multiple of salary) | 4.0 |
| notes | Text | Additional death benefit details | Payable to nominated beneficiaries |

**earlyRetirement:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| retirementAge | Number | Earliest retirement age | 55 |
| reductionFactor | Number | Annual reduction percentage | 3.0 |
| retirementConsiderations | Text | Early retirement terms | 3% reduction per year before age 60 |

**purchaseAddedYears:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| isAvailable | Yes/No | Whether option available | Yes |
| yearsPurchased | Number | Number of additional years purchased | 4 |
| details | Text | Purchase details | Purchased via salary deduction 2015-2019 |

**affinityDCScheme:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| isAvailable | Yes/No | Whether DC scheme available | Yes |
| contributionRate | Number | Member contribution rate | 5.0 |
| details | Text | Affinity scheme details | Additional DC pot alongside DB pension |

### Relationships

This contract connects to:

- Belongs to a FactFind
- Owned by one or more Clients (owners)
- Advised by a Selling Adviser
- Provided/administered by a Product Provider
- Links to LifeCycle stage
- References Pension Type/Plan Type
- May link to Employer entity

### Business Validation Rules

**Required Fields:**
- `pensionCategory` is required (defaults to "PensionDefinedBenefit")
- `pensionType` is required
- `owners` list must contain at least one owner
- `employer` is required for occupational schemes
- `normalRetirementAge` is required
- `pensionableSalary` is required for active members

**Pension Category Values:**
- `PensionDefinedBenefit` - Final salary or defined benefit schemes

**Scheme Type Values:**
- `PUBLIC_SECTOR` - NHS, Teachers, Civil Service, Local Government, Police, Armed Forces
- `PRIVATE_SECTOR` - Company final salary schemes
- `UNFUNDED` - Unfunded public sector schemes (paid from current taxation)

**Status Values:**
- `ACTIVE` - Currently accruing benefits
- `DEFERRED` - Preserved benefits, no longer accruing
- `IN_PAYMENT` - Pension currently being drawn
- `TRANSFERRED_OUT` - Benefits transferred to another arrangement

**Accrual Rate Examples:**
- `1/60th` - 1/60th of final salary per year of service
- `1/80th` - 1/80th of final salary per year of service (with lump sum)
- `1/54th` - Career Average scheme rate
- `2.32%` - Percentage of revalued earnings

**Agency Status Values:**
- `NOT_UNDER_AGENCY` - Not under agency servicing
- `UNDER_AGENCY_INFORMATION_ONLY` - Agency provides information only
- `UNDER_AGENCY_SERVICING_AGENT` - Full agency servicing

**Lifecycle Stage Values:**
- `Accumulation` - Building benefits, active member
- `Preservation` - Deferred member, preserved benefits
- `Decumulation` - In payment, drawing pension
- `Transfer` - Considering or processing transfer

### UK Final Salary Pension Rules

**Protected Rights:**
- Pre-2016 schemes may have protected rights from contracting out
- GMP accrued between 1978-1997 must be preserved
- Section 32 buy-out plans for preserved benefits

**Transfer Out Rules (October 2023+):**
- Statutory right to transfer applies to deferred and active members
- FCA requires advice for transfers over £30,000
- Pension Scams regulations require due diligence
- Transfer Value Analysis (TVA) required

**Abatement:**
- Some public sector schemes reduce pension if member returns to work
- Applies to early retirement pensions in particular

**Revaluation:**
- Deferred pensions must be revalued annually
- Statutory minimum revaluation: CPI capped at 5% or 2.5%
- In-payment increases: CPI, RPI, or fixed percentage depending on scheme rules

**Normal Retirement Age:**
- State Pension Age alignment for post-2015 public sector schemes
- Legacy schemes: age 60 or 65 typically
- Protected retirement ages for some members

### Common Use Cases

**1. Active Public Sector Scheme:**
```
pensionCategory: PensionDefinedBenefit
schemeType: PUBLIC_SECTOR
employer: NHS Trust
status: ACTIVE
accrualRate: 1/54th (CARE scheme)
normalRetirementAge: 68 (State Pension Age)
isIndexed: true (CPI capped at 5%)
```

**2. Deferred Final Salary Pension:**
```
status: DEFERRED
isPreserved: true
dateSchemeJoined: 1995-01-01
dateMemberLeft: 2010-05-31
accrualRate: 1/60th
pensionAtRetirement: Based on salary at leaving
revaluation: Statutory minimum
```

**3. Enhanced Transfer Value Offer:**
```
transferValue.cashEquivalentValue: £850,000
transferValue.expiryOn: 2026-03-31
transferValue.notes: Enhanced 15% above standard CETV
FCA advice required (>£30k)
Pension Transfer Specialist required
```

**4. Protected Retirement Age:**
```
normalRetirementAge: 50 (protected)
schemeType: PUBLIC_SECTOR (Police, Firefighter)
earlyRetirement.retirementAge: 50
earlyRetirement.reductionFactor: 0 (no reduction)
```

**5. Added Years Purchase:**
```
purchaseAddedYears.isAvailable: true
purchaseAddedYears.yearsPurchased: 5
Cost: £15,000 paid via salary deduction
Effect: Increases service years from 25 to 30
```

---

## 13.44C Annuity Contract

### Business Purpose

Represents an annuity pension arrangement providing guaranteed retirement income for life or a fixed term. This contract captures comprehensive annuity details including purchase amounts, income payments, guarantee periods, spouse benefits, and overlay protections.

**Note:** This is a standalone Plans entity, NOT part of Arrangements. Annuities are managed independently at `/api/v2/factfinds/{id}/pensions/annuities`.

### Key Features

- **Lifetime or Fixed Term Income** - Guaranteed income for life or specified period
- **Purchase Amount Tracking** - Total amount used to purchase annuity
- **Income Structure** - Flexible income amounts with frequency and escalation
- **Guarantee Periods** - Minimum payment periods regardless of death
- **Spouse/Dependant Benefits** - Percentage or fixed amount continuation benefits
- **PCLS Handling** - Pension Commencement Lump Sum tracking
- **Overlay Benefits** - Value protection and guaranteed minimum pensions
- **Payment Timing** - Advance or arrears payment options
- **Growth Assumptions** - Escalation rate tracking

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 15001 |
| href | Link | API resource link | /api/v2/factfinds/679/pensions/annuities/15001 |
| factfind | Reference Link | Link to the FactFind | Complex object |
| owners | List of Complex Data | Clients who own this annuity | List with 1 item(s) |
| sellingAdviser | Complex Data | Adviser who arranged this annuity | Complex object |
| provider | Complex Data | Annuity provider/insurance company | Complex object |
| lifeCycle | Complex Data | Annuity lifecycle stage | Complex object |
| wrap | Complex Data | Platform/wrap account details | Complex object |
| pensionCategory | Text | Category of pension | Annuity |
| pensionType | Complex Data | Specific annuity type/plan | Complex object |
| policyNumber | Text | Policy or annuity contract number | ANN-123456789 |
| agencyStatus | Text | Agency servicing status | NotUnderAgency |
| agencyStatusDate | Date | Date of agency status | 2023-01-15 |
| productName | Text | Name of the annuity product | Guaranteed Lifetime Annuity |
| currency | Complex Data | Payment currency | Complex object |
| startDate | Date | Date annuity payments commenced | 2023-01-15 |
| annuityType | Text | Type of annuity | LIFETIME |
| totalPurchaseAmount | Currency Amount | Total amount used to purchase annuity | Complex object |
| premiumStartDate | Date | Date premium payment started | 2023-01-15 |
| incomeAmount | Complex Data | Annual income payment details | Complex object |
| assumedGrowthRate | Complex Data | Annual escalation/growth rate | Complex object |
| annuityPaymentType | Text | Payment timing | Advance |
| pcls | Complex Data | Pension Commencement Lump Sum details | Complex object |
| spouseOrDependantBenefits | Complex Data | Benefits for spouse/dependants | Complex object |
| guaranteePeriod | Complex Data | Guaranteed payment period | Complex object |
| guaranteedMinimumPensionAnnual | Currency Amount | Minimum annual pension guaranteed | Complex object |
| overlayBenefits | Complex Data | Additional protection benefits | Complex object |
| additionalNotes | Text | Additional annuity information | Protected pension with escalation |
| createdAt | Date | When this record was created | 2023-01-15T10:00:00Z |
| updatedAt | Date | When this record was last modified | 2026-02-25T14:30:00Z |

#### Nested Field Groups

**owners:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Client unique identifier | 8496 |
| href | Link | API link to client resource | /api/v2/factfinds/679/clients/8496 |
| name | Text | Client full name | John Smith |
| ownershipPercentage | Number | Ownership percentage | 100.0 |

**sellingAdviser:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Adviser unique identifier | 123 |
| href | Link | API link to adviser resource | /api/v2/advisers/123 |
| name | Text | Adviser full name | Jane Financial Adviser |

**provider:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Product provider unique identifier | 456 |
| href | Link | API link to product provider resource | /api/v2/productproviders/456 |
| name | Text | Annuity provider name | Aviva |

**lifeCycle:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Lifecycle unique identifier | 45 |
| href | Link | API link to lifecycle resource | /api/v2/lifecycles/45 |
| name | Text | Lifecycle stage name | In Payment |

**pensionType:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Plan type unique identifier | 123 |
| href | Link | API link to plan type | /api/v2/plantypes?filter=id eq 123 |
| name | Text | Pension type name | Lifetime Annuity |

**wrap:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Platform/wrap account identifier | 234 |
| href | Link | API link to investment resource | /api/v2/factfinds/679/investments/234 |
| reference | Text | Platform account reference | WRAP-ANN-123456 |

**currency:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| code | Text | Currency code | GBP |
| display | Text | Currency display name | British Pound |
| symbol | Text | Currency symbol | £ |

**totalPurchaseAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Purchase amount | 250000.00 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| display | Text | Currency display name | British Pound |
| symbol | Text | Currency symbol | £ |

**incomeAmount:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| value | Currency Amount | Income payment amount | Complex object |
| amount | Number | Annual income amount | 18500.00 |
| currency | Complex Data | Currency details | Complex object |
| frequency | Text | Payment frequency | Monthly |
| effectiveDate | Date | Date income started | 2023-01-15 |

**assumedGrowthRate:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| percentage | Number | Annual escalation percentage | 3.00 |

**pcls:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| value | Currency Amount | Lump sum amount | Complex object |
| amount | Number | PCLS amount | 62500.00 |
| currency | Complex Data | Currency details | Complex object |
| paidBy | Text | Who paid the PCLS | Originating Scheme |

**spouseOrDependantBenefits:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| percentage | Number | Percentage of main income | 50.00 |
| amount | Currency Amount | Fixed spouse benefit amount | Complex object |
| amount | Number | Annual spouse benefit | 9250.00 |
| currency | Complex Data | Currency details | Complex object |

**guaranteePeriod:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| years | Number | Guarantee period in years | 5 |
| endsOn | Date | Date guarantee period ends | 2028-01-15 |

**guaranteedMinimumPensionAnnual:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Minimum annual pension | 18500.00 |
| currency | Complex Data | Currency details | Complex object |
| code | Text | Currency code | GBP |
| display | Text | Currency display name | British Pound |
| symbol | Text | Currency symbol | £ |

**overlayBenefits:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasValueProtection | Yes/No | Whether capital value is protected | Yes |
| protectedCapital | Currency Amount | Protected capital amount | Complex object |
| amount | Number | Protected amount | 250000.00 |
| currency | Complex Data | Currency details | Complex object |
| hasGuaranteePeriod | Yes/No | Whether guarantee period applies | Yes |
| guaranteeInYears | Number | Guarantee period in years | 10 |

### Business Validation Rules

**Annuity Type:**
- LIFETIME - Annuity payable for life
- FIXED_TERM - Annuity payable for fixed period
- JOINT_LIFE - Continues on death to spouse
- LEVEL - Fixed income amount
- ESCALATING - Income increases annually
- RPI_LINKED - Linked to Retail Price Index
- CPI_LINKED - Linked to Consumer Price Index

**Payment Type:**
- Advance - Paid at start of period (monthly, quarterly, annually)
- Arrears - Paid at end of period

**PCLS Paid By:**
- Originating Scheme - PCLS paid from original pension scheme
- Receiving Scheme - PCLS paid by annuity provider
- Separate Payment - PCLS taken separately, not from annuity

**Guarantee Period:**
- Common periods: 5, 10, 15 years
- Payments continue to beneficiaries if annuitant dies within guarantee period
- After guarantee period, payments cease on death (unless joint life)

**Spouse Benefits:**
- Can be percentage (e.g., 50%, 66.67%, 100%)
- Or fixed amount
- Payable on death of primary annuitant

### UK Pension Regulations

**Annuity Purchase Rules:**
- Can purchase from age 55 (increasing to 57 in 2028)
- Must use open market option (OMO) - can buy from any provider
- 25% tax-free lump sum (PCLS) available at purchase
- Remaining 75% used to purchase annuity income

**Taxation:**
- Annuity income taxed as earned income at marginal rate
- PCLS is tax-free (up to 25% of fund value)
- No further tax charges after purchase

**Enhanced/Impaired Annuities:**
- Higher rates for health conditions or lifestyle factors
- Medical evidence may be required
- Significantly higher income for serious conditions

**Annuity Types (Regulatory):**
- Compulsory Purchase Annuity (CPA) - Purchased with pension fund
- Purchased Life Annuity (PLA) - Purchased with personal funds (different tax treatment)
- Secured Pension - FCA term for pension annuities
- Alternatively Secured Pension (ASP) - Legacy unsecured pensions

**Protections:**
- Financial Services Compensation Scheme (FSCS) - 100% protection for annuities
- Pension Protection Fund (PPF) - Not applicable (annuities purchased from insurers)
- Consumer Duty - Providers must ensure fair value

### Use Cases

**1. Standard Lifetime Annuity Purchase:**
```
Pension fund: £250,000
PCLS (25%): £62,500 tax-free
Amount for annuity: £187,500
Age: 65
Annuity rate: 6.5% (lifetime, level, single life)
Annual income: £12,187
Monthly income: £1,015
Guarantee period: 5 years
No spouse benefit
```

**2. Enhanced Annuity (Health Conditions):**
```
Pension fund: £180,000
PCLS: £45,000
Amount for annuity: £135,000
Age: 63
Health: Type 2 diabetes, high blood pressure, smoker
Standard rate: 5.5%
Enhanced rate: 7.8% (+42% uplift)
Annual income: £10,530 (vs. £7,425 standard)
Monthly income: £877 (vs. £619 standard)
Additional income: £3,105 per year
```

**3. Joint Life Annuity with Escalation:**
```
Pension fund: £300,000
PCLS: £75,000
Amount for annuity: £225,000
Ages: 67 and 65
Annuity type: Joint life, 50% spouse benefit
Escalation: 3% per annum
Initial annual income: £10,125
After 10 years: £13,605 (with escalation)
After 20 years: £18,279
Spouse income on death: 50% = £5,063 to £9,139
```

**4. Fixed Term Annuity (Bridge to State Pension):**
```
Pension fund: £100,000
PCLS: £25,000
Amount for annuity: £75,000
Age: 63
Term: 3 years (to age 66 - State Pension Age)
Annual income: £26,850
Total payments: £80,550 over 3 years
Purpose: Bridge income gap until State Pension starts
```

**5. Guarantee Period Protection:**
```
Pension fund: £200,000
PCLS: £50,000
Amount for annuity: £150,000
Age: 70
Annual income: £11,400
Guarantee period: 10 years
Scenario: Annuitant dies after 2 years
Remaining guarantee: 8 years
Payments continue to estate: 8 × £11,400 = £91,200
Total paid: £22,800 + £91,200 = £114,000
```

---

## 13.44D Personal Pension Contract

### Business Purpose

Represents a personal pension arrangement including contribution-based defined contribution pensions, drawdown pensions, and self-invested personal pensions (SIPPs). This contract captures comprehensive pension details including valuations, contributions, fund holdings, crystallisation status, GAD limits, and retirement options.

**Note:** This is a standalone Plans entity, NOT part of Arrangements. Personal pensions are managed independently at `/api/v2/factfinds/{id}/pensions/personalpension`.

### Key Features

- **Contribution and Drawdown Management** - Track regular and lump sum contributions, transfers
- **Fund Holdings** - Detailed fund allocation with multiple identification codes
- **Crystallisation Tracking** - Monitor crystallised, part-crystallised, and uncrystallised funds
- **GAD Compliance** - Track Guaranteed Annuity Drawdown income limits
- **PCLS Management** - Pension Commencement Lump Sum tracking
- **Lifetime Allowance** - Monitor percentage of lifetime allowance used
- **Enhanced Benefits** - Track guaranteed annuity rates, loyalty bonuses, guaranteed growth
- **Death Benefits** - Comprehensive death in service and death benefits tracking
- **Lifestyling** - Automatic asset allocation strategies approaching retirement
- **Trust Arrangements** - Pension held in trust for inheritance planning

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 15001 |
| href | Link | API resource link | /api/v2/factfinds/679/pensions/personalpension/15001 |
| factfind | Reference Link | Link to the FactFind | Complex object |
| owners | List of Complex Data | Clients who own this pension | List with 1 item(s) |
| sellingAdviser | Complex Data | Adviser who arranged this pension | Complex object |
| provider | Complex Data | Pension provider/company | Complex object |
| lifeCycle | Complex Data | Pension lifecycle stage | Complex object |
| wrap | Complex Data | Platform/wrap account details | Complex object |
| pensionCategory | Text | Category of pension | PensionContributionDrawdown |
| pensionType | Complex Data | Specific pension type/plan | Complex object |
| policyNumber | Text | Policy or pension account number | PP-123456789 |
| agencyStatus | Text | Agency servicing status | NotUnderAgency |
| agencyStatusDate | Date | Date of agency status | 2023-01-15 |
| productName | Text | Name of the pension product | Vanguard Personal Pension |
| currency | Complex Data | Pension currency | Complex object |
| startedOn | Date | Date pension started | 2018-03-15 |
| employer | Text | Employer name (if workplace pension) | ABC Corporation Ltd |
| retirementAge | Number | Target retirement age | 65 |
| valuation | Complex Data | Current valuation details | Complex object |
| pensionArrangement | Text | Arrangement type | Physical |
| crystallisationStatus | Text | Crystallisation status | Uncrystallised |
| pcls | Complex Data | Pension Commencement Lump Sum details | Complex object |
| gadMaximumIncomeLimitAnnual | Currency Amount | GAD maximum income limit per year | Complex object |
| guaranteedMinimumIncomeLimitAnnual | Currency Amount | Guaranteed minimum income limit per year | Complex object |
| gadCalculatedOn | Date | Date GAD was calculated | 2023-04-15 |
| nextReviewOn | Date | Date of next pension review | 2024-04-15 |
| isInTrust | Yes/No | Whether pension is held in trust | Yes |
| gmpAmount | Currency Amount | Guaranteed Minimum Pension amount | Complex object |
| enhancedTaxFreeCash | Currency Amount | Enhanced tax-free cash entitlement | Complex object |
| guaranteedAnnuityRate | Text | Guaranteed annuity rate details | 4.5% at age 65 for single life annuity |
| applicablePenalties | Text | Early exit or other penalties | Early exit penalty of 5% if withdrawn within 5 years |
| erfLoyaltyBonusTerminalBonus | Text | ERF, loyalty, or terminal bonus details | Terminal bonus of 0.5% added at retirement |
| guaranteedGrowthRates | Text | Guaranteed growth rate details | Guaranteed 3% p.a. for first 5 years |
| deathInService | Complex Data | Death in service benefits | Complex object |
| lifetimeAllowanceUsed | Number | Percentage of lifetime allowance used | 45.5 |
| deathBenefits | Currency Amount | Death benefits payable | Complex object |
| hasLifestylingStrategy | Yes/No | Whether lifestyling strategy is active | Yes |
| lifestylingStrategyDetails | Text | Description of lifestyling strategy | Automatic switch from equity funds to bonds and cash starting at age 60 |
| optionsAtRetirement | Text | Options available at retirement | Full drawdown, phased drawdown, annuity purchase, or UFPLS available |
| otherBenefitsOrMaterialFeatures | Text | Other benefits or material features | Access to discounted fund platform with 0.2% p.a. rebate |
| isIndexed | Yes/No | Whether pension is inflation-linked | Yes |
| isPreserved | Yes/No | Whether this is a preserved pension | No |
| contributions | List of Complex Data | Pension contributions | List with multiple items |
| fundHoldings | Complex Data | Fund holdings and allocations | Complex object |
| additionalNotes | Text | Additional pension information | Policy includes protected tax-free cash rights from A-Day |
| createdAt | Date | When this record was created | 2023-01-15T10:00:00Z |
| updatedAt | Date | When this record was last modified | 2026-02-25T14:30:00Z |

*Total: 50 main fields*

#### Nested Field Groups

The contract includes the following nested field groups with detailed structures:

- **owners** - Client references with ownership percentages
- **sellingAdviser** - Adviser reference details
- **provider** - Pension provider reference
- **lifeCycle** - Lifecycle stage reference
- **pensionType** - Pension type reference
- **wrap** - Platform/wrap account reference
- **currency** - Currency details (code, display, symbol)
- **valuation** - currentValue (amount, currency), valuedOn (date)
- **pcls** - value (amount, currency), paidBy (Originating Scheme | Receiving Scheme)
- **gadMaximumIncomeLimitAnnual** - amount, currency
- **guaranteedMinimumIncomeLimitAnnual** - amount, currency
- **gmpAmount** - amount, currency
- **enhancedTaxFreeCash** - amount, currency
- **deathInService** - spousalBenefits (percentage)
- **deathBenefits** - amount, currency
- **contributions** - value (amount, currency), frequency, contributor (Self|Employer), startedOn, endsOn, contributionType (Regular|Lumpsum|Transfer), transfer (isFullTransfer, transferType, ceedingPlan)
- **fundHoldings** - model (code, name), funds (type, isFeed, name, codes, holding with units and percentage)

### Business Validation Rules

**Pension Category:** PensionContributionDrawdown (default)

**Pension Arrangement:**
- Notional - Pension is notional allocation within group scheme
- Physical - Actual segregated pension fund

**Crystallisation Status:**
- Crystallised - Entire pension accessed/drawn down
- PartCrystallised - Some funds accessed, some uncrystallised
- Uncrystallised - No benefits taken yet

**Contribution Type:**
- Regular - Ongoing regular contributions
- Lumpsum - One-off lump sum contribution
- Transfer - Transfer from another pension

**Contributor:** Self | Employer | Both

**Transfer Type:** Cash | Inspecie

**Fund Type:** Fund | Equity | Bond | Cash | Property | Alternative

### UK Pension Regulations

- Pension Freedoms (2015) - Access from age 55, 25% PCLS
- Annual Allowance: £60,000 (2024/25), MPAA £10,000
- Lifetime Allowance: Abolished April 2024
- GAD Rates - Apply to capped drawdown
- Death Benefits - Tax treatment based on age at death

### Use Cases

**1. Active Personal Pension:** Regular contributions, target retirement age 65, lifestyling strategy active
**2. Part-Crystallised:** Phased drawdown approach, tax-efficient withdrawals
**3. Enhanced Tax-Free Cash:** Protected rights from A-Day giving 30% PCLS
**4. Lifestyling Strategy:** Automatic de-risking approaching retirement
**5. Pension Transfer:** Consolidation from workplace schemes

---


## 13.45 Arrangement - Investment Contract (General Investment Account)

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
| client | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2020-03-20T10:00:00Z |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
| fundHoldings | List of Complex Data |  | List with 3 item(s) |
| gainLoss | Currency Amount |  | Complex object |
| id | Number | Unique system identifier for this record | 13001 |
| investmentObjective | Text |  | Long-term capital growth for retirement planning |
| investmentType | Text |  | GENERAL_INVESTMENT_ACCOUNT |
| notes | Text |  | General Investment Account with monthly contributi... |
| productName | Text | Name of the financial product | Vanguard Investment Account |
| providerName | Text | Unique system identifier for this record | Vanguard |
| provider | Reference Link | Unique system identifier for this record | Complex object |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8496 |

**currentValue:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 75000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**factfind:**

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

**provider:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 577 |

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


## 13.46 Arrangement - Protection Contract (Life Assurance)

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
| client | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2023-01-20T10:00:00Z |
| currentSumAssured | Currency Amount |  | Complex object |
| endDate | Date | Employment end date (null if current) | 2048-01-15 |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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
| provider | Reference Link | Unique system identifier for this record | Complex object |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8496 |

**currentSumAssured:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 325000.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |
| note | Text |  | Decreasing with mortgage balance |

**factfind:**

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
| liability | Reference Link |  | Complex object |
| id | Number | Unique system identifier for this record | 5678 |
| mortgage | Reference Link | Current age (calculated from date of birth) | Complex object |
| id | Number | Unique system identifier for this record | 12001 |

**premium:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| amount | Number | Amount spent | 45.0 |
| currency | Complex Data |  | Complex object |
| code | Text | Standard Occupational Classification (SOC) code | GBP |
| symbol | Text |  | £ |

**provider:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 3195 |

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


## 13.47 Arrangement - Pension Contract (Personal Pension)

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
| arrangementCategory | Text | Type of arrangement (INVESTMENT, PENSION, MORTGAGE, PROTECTION) | PENSION |
| assetAllocation | Complex Data |  | Complex object |
| charges | Complex Data |  | Complex object |
| client | Reference Link |  | Complex object |
| createdAt | Date | When this record was created in the system | 2010-04-10T10:00:00Z |
| crystallisedAmount | Currency Amount | Amount spent | Complex object |
| currentValue | Currency Amount | Current value of the arrangement | Complex object |
| deathBenefits | Complex Data |  | Complex object |
| factfind | Reference Link | Link to the FactFind that this client belongs to | Complex object |
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
| provider | Reference Link | Unique system identifier for this record | Complex object |
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

**client:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 8496 |

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

**factfind:**

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

**provider:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 577 |

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

## 13.48 Arrangement - Pension Contract (SIPP)

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

## 13.49 Arrangement - Pension Contract (Final Salary/Defined Benefit)

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

## 13.50 Arrangement - Pension Contract (Money Purchase/Defined Contribution)

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

## 13.51 Arrangement - Pension Contract (State Pension)

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

## 13.52 Arrangement - Investment Contract (Stocks & Shares ISA)

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
| id | Number | Unique identifier of the referenced entity |
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
- **GENERAL_INVESTMENT_ACCOUNT**: General Investment Account (GIA)
- **STOCKS_SHARES_ISA**: Stocks & Shares ISA
- **CASH_ISA**: Cash ISA
- **LIFETIME_ISA**: Lifetime ISA
- **INNOVATIVE_FINANCE_ISA**: Innovative Finance ISA
- **JUNIOR_ISA**: Junior ISA
- **INVESTMENT_BOND_ONSHORE**: Onshore Investment Bond
- **INVESTMENT_BOND_OFFSHORE**: Offshore Investment Bond
- **UNIT_TRUST**: Unit Trust
- **OEIC**: Open-Ended Investment Company
- **INVESTMENT_TRUST**: Investment Trust
- **SAVINGS_ACCOUNT**: Savings Account
- **PLATFORM_ACCOUNT**: Platform Account
- **VCT**: Venture Capital Trust
- **EIS**: Enterprise Investment Scheme

**Deprecated values (for backward compatibility):**
- **GIA**: Use GENERAL_INVESTMENT_ACCOUNT instead
- **ISA**: Use specific ISA type (STOCKS_SHARES_ISA, CASH_ISA, etc.)
- **BOND**: Use INVESTMENT_BOND_ONSHORE or INVESTMENT_BOND_OFFSHORE
- **OFFSHORE_BOND**: Use INVESTMENT_BOND_OFFSHORE instead

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


## 13.31 Net Worth

### Business Purpose

The Net Worth contract calculates and tracks a client's overall financial position by aggregating all assets and liabilities into a single net worth figure. This provides a snapshot of the client's total wealth at a specific point in time.

### Key Features

- **Comprehensive Asset Tracking** - Aggregates property, pensions, investments, cash, and other assets
- **Complete Liability Overview** - Tracks mortgages, loans, credit cards, and other debts
- **Automated Calculations** - System automatically calculates totals and net worth
- **Historical Tracking** - Maintains history of net worth over time
- **Multi-Client Support** - Handles joint net worth calculations for couples
- **Wealth Reporting** - Provides clear breakdown for client presentations

### Common Scenarios

**Wealth Management Planning:**
- Track client wealth progression over time
- Compare current net worth to retirement goals
- Identify wealth accumulation trends
- Support annual review meetings

**Investment Advice:**
- Assess investable assets vs total wealth
- Determine appropriate asset allocation
- Evaluate liquidity needs vs net worth
- Support investment suitability assessments

**Protection Planning:**
- Calculate life cover requirements based on net worth
- Assess estate planning needs
- Evaluate wealth protection strategies
- Support inheritance tax planning

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| id | Number | Unique identifier | 9001 |
| href | Link | Web address for this net worth calculation | /api/v2/factfinds/456/networth/9001 |
| factfind | Link to FactFind | The fact-find this belongs to | FactFind #456 |
| clients | List of Client Links | Clients included in this calculation | Client #456, Client #457 |
| calculatedOn | Date/Time | When this net worth was calculated | 2026-02-18T14:30:00Z |
| notes | Text | Additional context or notes | "Net worth as of property revaluation" |
| createdAt | Date/Time | When this record was created | 2026-02-18T14:30:00Z |
| updatedAt | Date/Time | When this record was last changed | 2026-02-18T14:30:00Z |

#### Asset Breakdown

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| assets.property | Currency Amount | Total value of all property assets | £450,000.00 |
| assets.pensions | Currency Amount | Total value of all pension assets | £325,000.00 |
| assets.investments | Currency Amount | Total value of all investment assets | £185,000.00 |
| assets.cash | Currency Amount | Total value of all cash assets | £45,000.00 |
| assets.other | Currency Amount | Total value of other assets | £25,000.00 |
| assets.totalAssets | Currency Amount | Sum of all assets (calculated) | £1,030,000.00 |

#### Liability Breakdown

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| liabilities.mortgages | Currency Amount | Total of all mortgage balances | £240,000.00 |
| liabilities.loans | Currency Amount | Total of all loan balances | £15,000.00 |
| liabilities.creditCards | Currency Amount | Total of all credit card balances | £8,500.00 |
| liabilities.other | Currency Amount | Total of other liabilities | £5,000.00 |
| liabilities.totalLiabilities | Currency Amount | Sum of all liabilities (calculated) | £268,500.00 |

#### Net Worth Calculation

| Field Name | Type | Description | Example Value |
|-----------|------|-------------|---------------|
| netWorth | Currency Amount | Total net worth (assets - liabilities) | £761,500.00 |

**How it's calculated:**
- **totalAssets** = sum of all asset categories
- **totalLiabilities** = sum of all liability categories
- **netWorth** = totalAssets minus totalLiabilities

**Important:** Net worth can be negative if liabilities exceed assets.

### Validation Rules

- All clients must be associated with the parent factfind
- calculatedOn cannot be in the future
- All money values must have consistent currency
- Calculations must be mathematically correct:
  - totalAssets = sum of all asset categories
  - totalLiabilities = sum of all liability categories
  - netWorth = totalAssets - totalLiabilities
- All amounts must be non-negative except netWorth which can be negative

### Relationships

**Referenced By:**
- FactFind - Parent fact-find
- Clients - Clients included in calculation

**References:**
- Assets - Aggregated from asset records
- Liabilities - Aggregated from liability records

**Business Rules:**
- Net worth should be recalculated when assets or liabilities change significantly
- Historical net worth records should be preserved for tracking
- System should automatically pull latest asset and liability values
- All currency values must match the factfind base currency


