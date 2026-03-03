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
- [13.57 PersonalProtection Contract](#1357-personalprotection-contract)
- [13.58 StatePension Contract](#1358-statepension-contract)

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
- Links to multiple financial products (pensions, investments, mortgages, protections)
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
- Links to all clients, financial products, goals, and documents
- Maintains audit trail of creation and updates

### Fields


#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier for this record | 679 |
| href | Text | API link to this resource | /api/v2/factfinds/679 |
| meeting | Complex Data | Meeting information including date, type, and attendees | Complex object |
| products | Complex Data | Products and services discussed during fact find | Complex object |
| disclosureKeyfacts | List of Complex Data | Disclosure documents issued | List with 1 item(s) |
| employmentSummary | List of Complex Data | Summary of client employment and income | List with 1 item(s) |
| supplementaryQuestions | List of Complex Data | Additional questions by category | List with 1 item(s) |
| assetsAndLiabilities | Complex Data | Client asset and liability disclosures | Complex object |
| creditHistory | Complex Data | Credit history information | Complex object |
| estatePlanning | Complex Data | Estate planning details including will and gifts | Complex object |

#### Nested Field Groups

**meeting:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| meetingOn | Date | Date when the meeting took place | 2026-02-16 |
| meetingType | Selection | Type of meeting | FaceToFace |
| clientsPresent | List of Reference Links | Clients who attended the meeting | List with 1 item(s) |
| anyOtherAudience | Yes/No | Whether others were present | true |
| notes | Text | Meeting notes | None |

**meeting.clientsPresent[]:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Client identifier | 123 |
| href | Text | Link to client resource | v2/factfinds/679/clients/123 |
| name | Text | Client name | Jack Marias |

**products:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| investments | Complex Data | Investment products information | Complex object |
| pensions | Complex Data | Pension products information | Complex object |
| mortgages | Complex Data | Mortgage products information | Complex object |
| protections | Complex Data | Protection products information | Complex object |

**products.investments:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasCash | Yes/No | Whether client has cash savings | true |
| hasInvestments | Yes/No | Whether client has investments | true |

**products.pensions:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasEmployerPensionSchemes | Yes/No | Has employer pension schemes | true |
| hasFinalSalary | Yes/No | Has final salary pensions | true |
| hasMoneyPurchases | Yes/No | Has money purchase pensions | true |
| hasPersonalPensions | Yes/No | Has personal pensions | true |
| hasAnnuities | Yes/No | Has annuities | true |
| existingEmployerPensionSchemes | List of Complex Data | Details of employer pension schemes | List with 1 item(s) |

**products.pensions.existingEmployerPensionSchemes[]:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| owner | Reference Link | Client who owns this pension | Complex object |
| isCurrentMember | Yes/No | Whether currently a member | true |
| isProbablemember | Yes/No | Whether there are membership issues | true |
| schemeJoinedOn | Date | Date joined the scheme | None |
| details | Text | Additional scheme details | None |

**products.mortgages:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasMortgages | Yes/No | Whether client has mortgages | true |
| hasEquityRelease | Yes/No | Whether client has equity release | true |

**products.protections:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasProtection | Yes/No | Whether client has protection products | true |
| lifeAndCriticalIllness | Complex Data | Life and critical illness cover details | Complex object |
| incomeProtection | Complex Data | Income protection details | Complex object |
| buildingsAndContent | Complex Data | Buildings and contents insurance | Complex object |

**products.protections.lifeAndCriticalIllness:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasCoverForMortgageOrDebt | Selection | Cover for mortgage or debt (Yes/No/NotApplicable) | Yes |
| hasCoverforDependantsDueToCritcalIllness | Selection | Cover for dependants due to critical illness | Yes |
| hasCoverforDependantsUponDeath | Selection | Cover for dependants upon death | Yes |
| haveReviewedCostofProtectionChange | Selection | Whether cost of protection change reviewed | Yes |
| impactOnYou | Text | Impact on you if no cover | None |
| impactOnDepandants | Text | Impact on dependants if no cover | None |
| actionsToAddressImpacts | Text | Actions to address impacts | None |
| reasonforNotReviewing | Text | Reason for not reviewing | None |

**products.protections.incomeProtection:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasCoverDueToAccidentOrIllness | Yes/No | Cover for accident or illness | true |
| hasCoverDueToUnemployment | Yes/No | Cover for unemployment | true |
| impactOnYou | Text | Impact on you if no cover | None |
| impactOnDepandants | Text | Impact on dependants if no cover | None |
| actionsToAddressImpacts | Text | Actions to address impacts | None |
| reasonforNotReviewing | Text | Reason for not reviewing | None |

**products.protections.buildingsAndContent:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| haveExistingBuildingInsurance | Yes/No | Has building insurance | true |
| haveExistingContentInsurance | Yes/No | Has contents insurance | true |
| buyToLetProperties | Complex Data | Buy-to-let property insurance | Complex object |
| haveSufficientCover | Yes/No | Whether cover is sufficient | true |
| actionsToAddressImpacts | Text | Actions to address gaps | None |
| whenDoyouWantToReviewProtection | Text | When to review protection | None |
| reasonforNotReviewing | Text | Reason for not reviewing | None |

**disclosureKeyfacts[]:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| Type | Selection | Type of disclosure document | CombinedDisclosureDocuments |
| IssuedOn | Date | Date document was issued | None |

**employmentSummary[]:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| client | Reference Link | Client this employment relates to | Complex object |
| totalGrossAnnualIncome | Currency Amount | Total gross annual income (read-only calculated) | Complex object |
| highestTaxRatepaid | Complex Data | Highest tax rate paid | Complex object |

**employmentSummary[].highestTaxRatepaid:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| percentage | Number | Tax rate percentage (0,10,19,20,21,22,40,41,42,45,46,47,48) | 45 |

**supplementaryQuestions[]:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| doBothClientsAgreeToAnswers | Yes/No | Whether both clients agree to answers | true |
| type | Selection | Question category (Profile/Investments/pensions/protection/mortgage/EstatePlanning) | None |

**assetsAndLiabilities:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| clientDisclosures | Complex Data | Client asset and liability disclosures | Complex object |

**assetsAndLiabilities.clientDisclosures:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasAssets | Yes/No | Whether client has assets | true |
| hasLiabilities | Yes/No | Whether client has liabilities | true |
| reductionOfLiabilities | Complex Data | Liability reduction plans | Complex object |

**assetsAndLiabilities.clientDisclosures.reductionOfLiabilities:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| isExpected | Yes/No | Whether reduction is expected | true |
| nonReductionReason | Selection | Reason for not reducing (RetainControlOfCapital/PensionPlanning/Other) | RetainControlOfCapital |
| details | Text | Additional details | None |

**creditHistory:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| hasAdverseHistory | Yes/No | Whether client has adverse credit history | true |
| refusedMortgageOrCredit | Yes/No | Whether refused mortgage or credit | true |
| details | Text | Credit history details | None |

**estatePlanning:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| will | Complex Data | Will information | Complex object |
| totalAssets | Currency Amount | Total assets (read-only calculated) | Complex object |
| jointTotalAssets | Currency Amount | Joint total assets (read-only calculated) | Complex object |
| giftsDetails | Complex Data | Gift details | Complex object |

**estatePlanning.will:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| details | Text | Will details | None |

**estatePlanning.giftsDetails:**

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| inLast7Years | Text | Gifts made in last 7 years | None |
| usedAnnualExeptionInCurrentOrPreviousTaxYears | Text | Annual exemption usage | None |
| regularGiftsOutOfIncome | Text | Regular gifts from income | None |
| expectingInheritanceOrGifts | Text | Expected inheritance or gifts | None |

---

### Relationships

This contract connects to:

- Links to one or more Clients via `meeting.clientsPresent`
- References Clients in `employmentSummary`
- Contains product information (Investments, Pensions, Mortgages, Protections)
- Contains disclosure and keyfacts documents
- Contains supplementary questions by category
- Contains assets, liabilities, credit history, and estate planning information

### Business Validation Rules

- Must have at least one client present in the meeting
- `meetingType` must be one of: Electronic, ElectronicRecorded, Videocall, VideocallRecorded, FaceToFace, FaceToFaceRecorded, Telephone, TelephoneRecorded
- `disclosureKeyfacts[].Type` must be one of: CombinedDisclosureDocuments, CombinedInitialDisclosureDocument, DisclosureDocument, KeyfactsAboutCostOfServices, KeyfactsAboutServices, ServiceCostDisclosureDocument, TermsRefundOfFees, TermsOfBusiness
- `employmentSummary[].highestTaxRatepaid.percentage` must be one of: 0, 10, 19, 20, 21, 22, 40, 41, 42, 45, 46, 47, 48
- `assetsAndLiabilities.clientDisclosures.reductionOfLiabilities.nonReductionReason` must be one of: RetainControlOfCapital, PensionPlanning, Other
- `supplementaryQuestions[].type` must be one of: Profile, Investments, pensions, protection, mortgage, EstatePlanning
- `totalGrossAnnualIncome`, `totalAssets`, and `jointTotalAssets` are read-only calculated fields

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

## 13.6 Goal Contract

### Business Purpose

Represents a financial goal or objective that the client wants to achieve, such as retirement, buying a property, or education funding.

### Key Features

- Defines target amount and target date
- Tracks priority and status
- Links goals to specific financial products and assets
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
- May link to specific financial products
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
The `Investment` contract represents investment products including ISAs, GIAs, Bonds, and Investment Trusts managed under the Plans & Investments Context.

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

## 13.57 PersonalProtection Contract

### Business Purpose

Represents personal protection arrangements including life cover, critical illness cover, income protection, expense cover, and severity-based protection products. This consolidated contract replaces the legacy Arrangement - Protection contracts and provides comprehensive protection policy management under the Plans domain.

### Key Features

- **Multi-Cover Support**: Single policy can include life, critical illness, income, expense, and severity covers
- **Flexible Premium Structures**: Stepped, level, or hybrid premium configurations
- **Trust Arrangements**: Record policies held in trust with beneficiary details
- **Indexation Options**: RPI, CPI, fixed percentage, or level premiums
- **Benefits Configuration**: Comprehensive benefit payment terms including deferred periods and qualification periods
- **Commission Tracking**: Full commission details (indemnity, non-indemnity, renewal)
- **Provider Integration**: Links to insurance providers and selling advisers
- **Multi-Owner Support**: Joint policies with ownership percentage splits

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier | 15001 |
| href | Text | Resource URI | /api/v2/factfinds/679/protections/15001 |
| factfind | Reference Link | Link to parent FactFind | { id: 679, href: "/api/v2/factfinds/679" } |
| sellingAdviser | Reference Link | Selling adviser reference | { id: 123, href: "/api/v2/advisers/123", name: "Jane Adviser" } |
| owners | List of Reference Links | Policy owner(s) | [{ id: 8496, href: "/api/v2/factfinds/679/clients/8496", name: "John Smith" }] |
| provider | Reference Link | Insurance provider | { id: 456, href: "/api/v2/productproviders/456", name: "Legal & General" } |
| protectionCategory | Text | Protection category | PersonalProtection |
| protectionType | Reference Link | Protection type reference | { id: 123, href: "/api/v2/plantypes?filter=id eq 123", name: "Life and Critical Illness" } |
| lifeCycle | Reference Link | Life cycle stage | { id: 45, href: "/api/v2/lifecycles/45", name: "Accumulation" } |
| premiums | List of Complex Data | Premium details | List with premium entries |
| lifeCover | Complex Data | Life cover details | See LifeCoverValue below |
| criticalIllnessCover | Complex Data | Critical illness cover details | See CriticalIllnessCoverValue below |
| incomeCover | Complex Data | Income protection details | See IncomeCoverValue below |
| expenseCover | Complex Data | Expense cover details | See ExpenseCoverValue below |
| severityCover | Complex Data | Severity-based cover details | See SeverityCoverValue below |
| benefitsPayable | Complex Data | Benefits payment configuration | See BenefitsPayableValue below |
| indexType | Text (Selection) | Indexation type | LevelNotIndexed, RPI, FixedPercentage, AEI, Decreasing, CPI |
| inTrust | Yes/No | Whether policy is held in trust | Yes |
| inTrustToWhom | Text | Trust beneficiary details (max 250 chars) | Spouse and children |
| benefitOptions | List of Text | Benefit options | ["Convertible", "Reviewable"] |
| isRated | Yes/No | Whether policy has premium rating | No |
| isPremiumWaiverWoc | Yes/No | Premium waiver on claim | Yes |
| benefitSummary | Text | Summary of benefits | Level term life and CI cover with waiver |
| exclusionNotes | Text | Policy exclusions | Hazardous sports exclusion |
| initialEarningsPeriod | Text (ISO-8601) | Commission clawback period | P180D (180 days) |
| waitingPeriod | Text (ISO-8601) | Waiting period before eligibility | P90D (90 days) |
| premiumLoading | Text (max 50 chars) | Premium loading details | 10% loading due to occupation |
| owner2PercentOfSumAssured | Number | Co-owner's percentage of sum assured | 50.00 |
| sumAssured | Currency Amount | Total sum assured | £500,000 |
| commissions | List of Complex Data | Commission details | See CommissionValue below |
| protectionPayoutType | Text (Selection) | Payout type | Agreed, Indemnity |
| concurrencyId | Text | Optimistic concurrency token | f7a8b9c0-1234-5678-9abc-def012345678 |
| createdAt | Date and Time | Creation timestamp | 2024-01-15T10:30:00Z |
| updatedAt | Date and Time | Last update timestamp | 2024-01-15T10:30:00Z |

#### Nested Field Groups

**PremiumValue** (in premiums list):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| startsOn | Date | Premium start date | 2024-01-01 |
| stopsOn | Date | Premium end date (null if ongoing) | null |
| value | Currency Amount | Premium amount | £150.00 |
| frequency | Text (Selection) | Payment frequency | Monthly, Quarterly, Annually, Single |
| type | Text (Selection) | Premium type | Regular, Single |
| contributorType | Text (Selection) | Contributor type | Self, Employer, Both |
| escalation | Complex Data | Escalation configuration | See EscalationValue below |

**EscalationValue**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| type | Text (Selection) | Escalation type | FixedPercentage, RPI, Level, NAEI, LPI |
| percentage | Number | Escalation percentage | 3.0 |

**LifeCoverValue**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| term | Text (ISO-8601) | Cover term | P25Y (25 years) |
| sumAssured | Currency Amount | Sum assured amount | £500,000 |
| premiumStructure | Text (Selection) | Premium structure | Stepped, Level, Hybrid |
| additionalCover | Currency Amount | Additional cover amount | £50,000 |
| paymentBasis | Text (Selection) | Payment basis | FirstDeath, SecondDeath, Both |
| untilAge | Number | Cover until age (years) | 65 |

**CriticalIllnessCoverValue**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| premiumStructure | Text (Selection) | Premium structure | Stepped, Level, Hybrid |
| amount | Currency Amount | Cover amount | £250,000 |
| term | Text (ISO-8601) | Cover term | P25Y (25 years) |
| untilAge | Number | Cover until age (years) | 65 |

**IncomeCoverValue**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| premiumStructure | Text (Selection) | Premium structure | Stepped, Level, Hybrid |
| amount | Currency Amount | Monthly income amount | £3,000 |
| term | Text (ISO-8601) | Cover term | P30Y (30 years) |
| untilAge | Number | Cover until age (years) | 65 |

**ExpenseCoverValue**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| premiumStructure | Text (Selection) | Premium structure | Stepped, Level, Hybrid |
| amount | Currency Amount | Monthly expense amount | £2,000 |
| term | Text (ISO-8601) | Cover term | P20Y (20 years) |
| untilAge | Number | Cover until age (years) | 60 |

**SeverityCoverValue**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| permanentTotalDisabilityCover | Complex Data | PTD cover details | See PermanentTotalDisabilityCoverValue |
| severityBasedCover | Complex Data | Severity-based cover details | See SeverityBasedCoverValue |

**PermanentTotalDisabilityCoverValue**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| premiumStructure | Text (Selection) | Premium structure | Level |
| amount | Currency Amount | Cover amount | £200,000 |
| term | Text (ISO-8601) | Cover term | P20Y |
| untilAge | Number | Cover until age | 60 |

**SeverityBasedCoverValue**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| premiumStructure | Text (Selection) | Premium structure | Level |
| amount | Currency Amount | Cover amount | £100,000 |
| term | Text (ISO-8601) | Cover term | P20Y |
| untilAge | Number | Cover until age | 60 |

**BenefitsPayableValue**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| benefitFrequency | Text (Selection) | Benefit frequency | Single, Weekly, Monthly, Quarterly, Annually |
| benefitPeriod | Complex Data | Benefit period configuration | See BenefitPeriodValue |
| benefitAmount | Currency Amount | Benefit amount | £500,000 |
| deferredPeriod | Text (ISO-8601) | Deferred period | P90D (90 days) |
| qualificationPeriod | Complex Data | Qualification period config | See QualificationPeriodValue |
| splitBenefitFrequency | Text (Selection) | Split benefit frequency | None, Monthly |
| splitBenefitValue | Currency Amount | Split benefit amount | £2,500 |
| splitDeferredPeriod | Text (ISO-8601) | Split deferred period | P60D |

**BenefitPeriodValue**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| value | Text (ISO-8601) | Period in months | P24M (24 months) |
| details | Text (max 255 chars) | Period details | 24 months with extension option |

**QualificationPeriodValue**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| isBackToDayOne | Yes/No | Back to day one provision | Yes |
| value | Text (ISO-8601) | Period | P30D (30 days) |

**CommissionValue** (in commissions list):

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| frequency | Text (Selection) | Commission frequency | Monthly, Quarterly, Annually, Single |
| type | Text (Selection) | Commission type | Indemnity, NonIndemnity, SinglePremium, Level, Renewal |
| percentage | Number | Commission percentage (0-100) | 2.5 |
| amount | Currency Amount | Commission amount | £3.75 |

### Relationships

**This contract connects to:**
- **FactFind Contract** (parent) - Protection is part of a fact find
- **Client Contract** (owners) - One or more clients own the protection policy
- **Provider Contract** (provider) - Insurance provider details
- **Adviser Contract** (sellingAdviser) - Selling adviser information
- **PlanType Contract** (protectionType) - Protection product type reference
- **LifeCycle Contract** (lifeCycle) - Life cycle stage reference

### Business Rules

1. **Required Fields**: At least one owner, provider, protection type, premiums, sum assured, and benefits payable must be specified
2. **Cover Type Rules**: At least one cover type (life, critical illness, income, expense, or severity) must be configured
3. **Premium Rules**: Premium amount must be greater than zero; start date cannot be more than 30 days in the future
4. **Term and Age Rules**: Cover term must be valid ISO-8601 duration; until age must be between 18 and 100
5. **Benefits Rules**: Deferred period typically 0-365 days for income protection; qualification period must match back-to-day-one setting
6. **Trust Rules**: If inTrust is true, inTrustToWhom should be specified (max 250 characters)
7. **Commission Rules**: Commission percentage must be between 0 and 100
8. **Co-Ownership Rules**: If multiple owners, ownership percentages should total 100%

### Example Usage

**Life and Critical Illness Cover Example:**

```json
{
  "id": 15001,
  "href": "/api/v2/factfinds/679/protections/15001",
  "factfind": { "id": 679, "href": "/api/v2/factfinds/679" },
  "sellingAdviser": { "id": 123, "href": "/api/v2/advisers/123", "name": "Jane Adviser" },
  "owners": [{ "id": 8496, "href": "/api/v2/factfinds/679/clients/8496", "name": "John Smith" }],
  "provider": { "id": 456, "href": "/api/v2/productproviders/456", "name": "Legal & General" },
  "protectionCategory": "PersonalProtection",
  "protectionType": { "id": 123, "href": "/api/v2/plantypes?filter=id eq 123", "name": "Life and CI" },
  "lifeCycle": { "id": 45, "href": "/api/v2/lifecycles/45", "name": "Accumulation" },
  "premiums": [{
    "startsOn": "2024-01-01",
    "value": { "amount": 150.00, "currency": { "code": "GBP", "symbol": "£" } },
    "frequency": "Monthly",
    "type": "Regular",
    "contributorType": "Self",
    "escalation": { "type": "RPI", "percentage": 0 }
  }],
  "lifeCover": {
    "term": "P25Y",
    "sumAssured": { "amount": 500000.00, "currency": { "code": "GBP", "symbol": "£" } },
    "premiumStructure": "Level",
    "paymentBasis": "FirstDeath",
    "untilAge": 65
  },
  "criticalIllnessCover": {
    "premiumStructure": "Level",
    "amount": { "amount": 250000.00, "currency": { "code": "GBP", "symbol": "£" } },
    "term": "P25Y",
    "untilAge": 65
  },
  "benefitsPayable": {
    "benefitFrequency": "Single",
    "benefitAmount": { "amount": 500000.00, "currency": { "code": "GBP", "symbol": "£" } },
    "deferredPeriod": "P0D",
    "qualificationPeriod": { "isBackToDayOne": false, "value": "P30D" }
  },
  "indexType": "RPI",
  "inTrust": true,
  "inTrustToWhom": "Spouse and children",
  "isRated": false,
  "isPremiumWaiverWoc": true,
  "sumAssured": { "amount": 500000.00, "currency": { "code": "GBP", "symbol": "£" } },
  "protectionPayoutType": "Indemnity"
}
```

### Regulatory Context

**FCA ICOBS (Insurance Conduct of Business)**
- Premium ratings must be justified and disclosed
- Exclusions must be clearly stated
- Trust arrangements must comply with trust law
- Commission disclosure requirements apply

**IDD (Insurance Distribution Directive)**
- Demands and needs assessment required
- Product governance requirements
- Customer best interest rule applies

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


## 13.58 StatePension Contract

### Business Purpose

Represents State Pension entitlements including basic State Pension, additional State Pension (SERPS/S2P), new State Pension, Pension Credit, spouse pension inheritance, and BR19 projection data for retirement planning. This contract consolidates all State Pension information for comprehensive retirement income forecasting.

### Key Features

- **Dual System Support**: Handles both old State Pension (pre-2016) and new State Pension (post-2016) systems
- **Component Breakdown**: Separate tracking of basic amount, additional pension, and means-tested benefits
- **Pension Credit Integration**: Records Pension Credit (Guarantee and Savings Credit) entitlements
- **Spouse Inheritance**: Tracks inherited State Pension rights from deceased spouse
- **BR19 Integration**: Stores BR19 State Pension forecast reference and projection data
- **Retirement Age Tracking**: Records individual's State Pension age based on birth date
- **Single Owner**: State Pension is an individual entitlement (cannot be jointly owned)

### Fields

#### Main Fields

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| id | Number | Unique system identifier | 1234 |
| href | Text | Resource URI | /api/v2/factfinds/679/pensions/statepension/1234 |
| factfind | Reference Link | Link to parent FactFind | { id: 679, href: "/api/v2/factfinds/679" } |
| owner | Reference Link | Client who owns this state pension entitlement | { id: 8496, href: "/api/v2/factfinds/679/clients/8496", name: "Sarah Johnson" } |
| retirementAge | Number | State Pension age for this individual (65-68) | 67 |
| statePensionProvision | Complex Data | State Pension provision details | See StatePensionProvisionValue below |
| spousePension | Currency Amount | Inherited spouse pension entitlement | { amount: 1250.00, currency: { code: "GBP", symbol: "£" } } |
| br19Projection | Text | BR19 State Pension forecast reference or data | BR19 Reference: SP-2024-123456789 |
| notes | Text | Additional notes and comments | Full new State Pension entitlement |
| createdAt | Date and Time | Creation timestamp | 2024-11-15T10:00:00Z |
| updatedAt | Date and Time | Last update timestamp | 2026-03-03T14:30:00Z |

#### Nested Field Groups

**StatePensionProvisionValue**:

| Field Name | Type | Description | Example Value |
|---|---|---|---|
| basicAmount | Currency Amount | Basic State Pension or new State Pension amount | { amount: 11502.40, currency: { code: "GBP", symbol: "£" } } |
| additionalAmount | Currency Amount | Additional State Pension (SERPS/S2P) for old system | { amount: 2450.00, currency: { code: "GBP", symbol: "£" } } |
| benefitCredit | Currency Amount | Pension Credit entitlement (means-tested top-up) | { amount: 0.00, currency: { code: "GBP", symbol: "£" } } |

**State Pension Components:**

**Basic State Pension (Old System - Pre-2016):**
- Basic State Pension for those who reached State Pension age before 6 April 2016
- Maximum (2024/25): £169.50 per week (£8,814.00 per annum)
- Qualifying Years: 30 for women, 44 for men born before 1945

**New State Pension (Post-2016):**
- New State Pension for those reaching State Pension age on or after 6 April 2016
- Full Amount (2024/25): £221.20 per week (£11,502.40 per annum)
- Minimum: 10 qualifying years needed to qualify
- Maximum: 35 qualifying years for full entitlement

**Additional State Pension (SERPS/S2P):**
- State Earnings Related Pension Scheme (SERPS) or State Second Pension (S2P)
- Applies to old State Pension system only
- Reduced if previously contracted out via occupational or personal pension

**Pension Credit:**
- Means-tested benefit to top up pension income
- Guarantee Credit: £218.15 per week (single) or £332.95 (couple) in 2024/25
- Savings Credit: Only for those who reached State Pension age before 6 April 2016

### Relationships

**This contract connects to:**
- **FactFind Contract** (parent) - State Pension is part of a fact find
- **Client Contract** (owner) - Single client owns the State Pension entitlement

### Business Rules

1. **Required Fields**: Owner, retirement age, and basic amount must be specified
2. **Single Owner**: State Pension cannot have multiple owners (individual entitlement only)
3. **Retirement Age**: Must be between 65 and 68 (current range; subject to change)
4. **Basic Amount Limits**:
   - New State Pension: Should not exceed £11,502.40 per annum (£221.20 per week)
   - Old State Pension: Should not exceed £8,814.00 per annum (£169.50 per week)
5. **Additional Amount**: Only applicable for old State Pension (pre-2016) system
6. **Pension Credit**: Only applicable if total income below Pension Credit threshold
7. **Spouse Pension**: Only applicable if client is widow/widower under old State Pension system
8. **BR19 Validity**: State Pension forecasts typically valid for 60 days

### Example Usage

**Example 1: New State Pension (Post-2016) with Full Entitlement:**

```json
{
  "id": 1234,
  "href": "/api/v2/factfinds/679/pensions/statepension/1234",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "owner": {
    "id": 8496,
    "href": "/api/v2/factfinds/679/clients/8496",
    "name": "Sarah Johnson"
  },
  "retirementAge": 67,
  "statePensionProvision": {
    "basicAmount": {
      "amount": 11502.40,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "additionalAmount": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "benefitCredit": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    }
  },
  "spousePension": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "br19Projection": "BR19 Reference: SP-2024-123456789 - Full new State Pension £221.20 per week (£11,502.40 per annum) at age 67. Based on 35 qualifying years.",
  "notes": "Full new State Pension entitlement. 35 qualifying years achieved. State Pension age 67 (DOB: 15/08/1970).",
  "createdAt": "2024-11-15T10:00:00Z",
  "updatedAt": "2026-03-03T14:30:00Z"
}
```

**Example 2: Old State Pension (Pre-2016) with Additional Pension and Spouse Inheritance:**

```json
{
  "id": 1235,
  "href": "/api/v2/factfinds/679/pensions/statepension/1235",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "owner": {
    "id": 8497,
    "href": "/api/v2/factfinds/679/clients/8497",
    "name": "Margaret Thompson"
  },
  "retirementAge": 65,
  "statePensionProvision": {
    "basicAmount": {
      "amount": 8814.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "additionalAmount": {
      "amount": 2450.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "benefitCredit": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    }
  },
  "spousePension": {
    "amount": 1250.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "br19Projection": "BR19 Reference: SP-2015-987654321 - Basic State Pension £169.50 per week plus Additional Pension £47.12 per week. Spouse inheritance £24.04 per week.",
  "notes": "Old State Pension system. 30 qualifying years. Additional SERPS pension accrued. Inherited 50% of late husband's Additional Pension.",
  "createdAt": "2015-06-20T09:30:00Z",
  "updatedAt": "2026-03-03T14:30:00Z"
}
```

**Example 3: Reduced New State Pension with Pension Credit:**

```json
{
  "id": 1236,
  "href": "/api/v2/factfinds/679/pensions/statepension/1236",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "owner": {
    "id": 8498,
    "href": "/api/v2/factfinds/679/clients/8498",
    "name": "David Williams"
  },
  "retirementAge": 66,
  "statePensionProvision": {
    "basicAmount": {
      "amount": 7200.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "additionalAmount": {
      "amount": 0.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "benefitCredit": {
      "amount": 4134.80,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    }
  },
  "spousePension": {
    "amount": 0.00,
    "currency": {
      "code": "GBP",
      "display": "British Pound",
      "symbol": "£"
    }
  },
  "br19Projection": "BR19 Reference: SP-2023-555666777 - Reduced new State Pension £138.46 per week (22 qualifying years). Eligible for Pension Credit top-up.",
  "notes": "Incomplete NI record (22 qualifying years). Entitled to Pension Credit Guarantee Credit to top up to minimum income guarantee. Voluntary contributions may increase State Pension.",
  "createdAt": "2023-09-10T11:00:00Z",
  "updatedAt": "2026-03-03T14:30:00Z"
}
```

### UK State Pension Regulations

**State Pension Age:**
- Current: 66 (for those born between 6 October 1954 and 5 April 1960)
- Rising to 67: Between 2026 and 2028 (for those born between 6 April 1960 and 5 April 1977)
- Rising to 68: Planned for 2044-2046 (subject to review)

**National Insurance Qualifying Years:**
- Employed: NI contributions automatically paid on earnings above £242 per week (2024/25)
- Self-Employed: Class 2 and Class 4 NI contributions
- Voluntary Contributions: Class 3 NI (£17.45 per week in 2024/25) to fill gaps
- NI Credits: Automatic credits for unemployment, caring, illness

**State Pension Increases (Triple Lock):**
- Increases each April by the highest of:
  - Earnings growth (average wage increase)
  - Price inflation (CPI)
  - 2.5%

**Deferring State Pension:**
- Old State Pension: Defer by at least 5 weeks; increases by 1% for every 5 weeks (10.4% per year)
- New State Pension: Defer by at least 9 weeks; increases by 1% for every 9 weeks (5.8% per year)

**Tax Treatment:**
- State Pension is taxable income
- No tax deducted at source
- Tax collected through PAYE code on other income or self-assessment
- Personal Allowance (£12,570 in 2024/25) may cover State Pension if only income

### Related Contracts

- **Client Contract** - Links to client record for date of birth and State Pension age calculation
- **Income Contract** - State Pension counts as income for affordability assessments
- **PersonalPension Contract** - Personal pensions that may have contracted out of Additional State Pension
- **FinalSalaryPension Contract** - Occupational pensions that may have contracted out of SERPS/S2P


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


