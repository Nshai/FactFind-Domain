# Mortgage API Design

**Version:** 2.0
**Date:** 2026-02-25
**Status:** Active
**Domain:** Plans

---

## Navigation

- **[← Back to Master API Design](./MASTER-API-DESIGN.md)** - Common standards and conventions
- **[← Back to API Index](./README.md)** - All entity APIs by domain

---

## Quick Reference

### Entity Information

| Attribute | Value |
|-----------|-------|
| **Entity Name** | Mortgage |
| **Domain** | Plans |
| **Aggregate Root** | Client |
| **Base Path** | `/api/v2/factfinds/{factfindId}/mortgages` |
| **Resource Type** | Collection |

### Description

Comprehensive management of mortgage arrangements including traditional mortgages, buy-to-let mortgages, and equity release products secured against property assets with automatic LTV calculation, interest term tracking, and redemption management.

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

| Method | Path | Description | Request | Response | Status Codes | Tags |
|--------|------|-------------|---------|----------|--------------|------|
| GET | `/api/v2/factfinds/{factfindId}/mortgages` | List all mortgages | Query params | Mortgage[] | 200, 401, 403 | Mortgage, List |
| POST | `/api/v2/factfinds/{factfindId}/mortgages` | Create mortgage | MortgageRequest | Mortgage | 201, 400, 401, 403, 422 | Mortgage, Create |
| GET | `/api/v2/factfinds/{factfindId}/mortgages/{mortgageId}` | Get mortgage by ID | Path params | Mortgage | 200, 401, 403, 404 | Mortgage, Retrieve |
| PATCH | `/api/v2/factfinds/{factfindId}/mortgages/{mortgageId}` | Update mortgage | MortgagePatch | Mortgage | 200, 400, 401, 403, 404, 422 | Mortgage, Update |
| DELETE | `/api/v2/factfinds/{factfindId}/mortgages/{mortgageId}` | Delete mortgage | Path params | None | 204, 401, 403, 404, 422 | Mortgage, Delete |


### Authorization

**Required Scopes:**
- `mortgages:read` - Read access (GET operations)
- `mortgages:write` - Create and update access (POST, PUT, PATCH)
- `mortgages:delete` - Delete access (DELETE operations)

Refer to **[Master API Design - Section 4](./MASTER-API-DESIGN.md#4-authentication--authorization)** for authentication details.

---

## Resource Summary





### Mortgage Resource Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `accountNumber` | string |  |  |
| `agencyStatus` | string |  | Current age (calculated from date of birth) |
| `agencyStatusDate` | date |  | Current age (calculated from date of birth) |
| `arrangementCategory` | string |  | Expenditure category (Housing, Transport, Food, etc.) |
| `asset` | Reference Link |  | Total value of all assets |
| `createdAt` | date |  | When this record was created in the system |
| `description` | string |  | Description of the goal |
| `factfind` | Reference Link |  | Link to the FactFind that this client belongs to |
| `feesAndCharges` | Complex Data |  |  |
| `id` | integer | ✓ | Unique system identifier for this record |
| `illustrationReference` | string |  |  |
| `interestTerms` | Complex Data |  |  |
| `keyDates` | Complex Data |  |  |
| `lenderName` | string |  |  |
| `linkedArrangements` | List of Complex Data |  |  |
| `loanAmounts` | Complex Data |  | Amount spent |
| `notes` | string |  |  |
| `offsetFeatures` | Complex Data |  |  |
| `owners` | List of Complex Data |  | Who owns this arrangement |
| `policyNumber` | string |  | Policy or account number |
| `productName` | string |  | Name of the financial product |
| `productType` | string |  |  |
| `property` | Reference Link |  | Type of property (Residential, Buy-to-Let, Commercial, etc.) |
| `propertyDetail` | Reference Link |  |  |
| `redemptionTerms` | Complex Data |  |  |
| `repaymentStructure` | Complex Data |  |  |
| `sellingAdviser` | Reference Link |  |  |
| `sharedOwnershipDetails` | Complex Data |  | Who owns this arrangement |
| `specialFeatures` | Complex Data |  |  |
| `updatedAt` | date |  | When this record was last modified |

*Total: 30 properties*

### Referenced Type Definitions

The following complex types are used in the properties above:

#### feesAndCharges

Mortgage fees and ongoing charges:

| Field | Type | Description |
|-------|------|-------------|
| `lenderFees` | Money | Fees charged by lender (arrangement fee, booking fee, etc.) |
| `ongoingContributions` | string | Regular ongoing charges description |

#### interestTerms

Interest rate and term details:

| Field | Type | Description |
|-------|------|-------------|
| `annualPercentageRate` | decimal | APR (%) - total cost including fees |
| `baseRateIndex` | string | Base rate index (SONIA, Bank of England Base Rate) |
| `collarRate` | string | Collar rate (minimum rate for variable mortgages) |
| `hasCollarRate` | boolean | Whether a collar rate applies |
| `initialRatePeriodEndsOn` | date | Date when initial rate period ends |
| `initialTermMonths` | integer | Initial term in months |
| `initialTermYears` | integer | Initial term in years |
| `interestRate` | decimal | Current interest rate (%) |
| `rateType` | string | Rate type: Fixed, Variable, Tracker, Discount, Capped |
| `remainingTermMonths` | integer | Remaining term in months |
| `remainingTermYears` | integer | Remaining term in years |

**Rate Types:**
- **Fixed** - Rate fixed for initial period (e.g., 2, 5, 10 years)
- **Variable** - Lender's standard variable rate (SVR)
- **Tracker** - Tracks base rate plus margin (e.g., SONIA + 2%)
- **Discount** - Discount off SVR for initial period
- **Capped** - Variable but with maximum rate cap

#### keyDates

Important mortgage dates:

| Field | Type | Description |
|-------|------|-------------|
| `applicationDate` | date | Date mortgage application submitted |
| `offerDate` | date | Date mortgage offer issued |
| `completionDate` | date | Date mortgage completed/drew down |
| `firstPaymentDate` | date | Date of first payment |
| `maturityDate` | date | Date mortgage matures/final payment due |
| `initialRateEndsOn` | date | Date when initial rate period ends |
| `nextReviewDate` | date | Date for next review/rebroking opportunity |

#### loanAmounts

Loan amount details:

| Field | Type | Description |
|-------|------|-------------|
| `originalLoanAmount` | Money | Original loan amount at inception |
| `currentBalance` | Money | Current outstanding balance |
| `advancedAmount` | Money | Amount actually advanced |
| `additionalBorrowing` | Money | Additional borrowing amount |
| `originalLTV` | decimal | Original Loan-to-Value ratio (%) |
| `currentLTV` | decimal | Current Loan-to-Value ratio (%) |

**LTV Calculation:** `LTV = (Outstanding Balance / Property Value) × 100%`

#### repaymentStructure

Repayment method and amounts:

| Field | Type | Description |
|-------|------|-------------|
| `repaymentType` | string | Repayment type: Repayment, Interest-Only, Part-and-Part |
| `monthlyPayment` | Money | Total monthly payment |
| `principalPayment` | Money | Monthly principal repayment portion |
| `interestPayment` | Money | Monthly interest payment portion |
| `overpaymentsMade` | Money | Total overpayments made to date |
| `overpaymentAllowance` | decimal | Annual overpayment allowance (% or amount) |

**Repayment Types:**
- **Repayment** - Capital and interest paid each month
- **Interest-Only** - Interest only paid; capital due at end
- **Part-and-Part** - Combination of repayment and interest-only

#### redemptionTerms

Early repayment and exit terms:

| Field | Type | Description |
|-------|------|-------------|
| `earlyRepaymentCharge` | Money | Current ERC amount |
| `ercAppliesUntil` | date | Date until which ERC applies |
| `ercPercentage` | decimal | ERC as percentage of balance |
| `overpaymentLimit` | decimal | Overpayment limit without penalty (%) |
| `portabilityAvailable` | boolean | Whether mortgage can be ported to new property |

**ERC:** Early Repayment Charge - penalty for paying off mortgage early

#### offsetFeatures

Offset mortgage features (if applicable):

| Field | Type | Description |
|-------|------|-------------|
| `hasOffsetFeature` | boolean | Whether this is an offset mortgage |
| `linkedSavingsAccounts` | List | List of linked savings accounts |
| `currentOffsetBalance` | Money | Current balance in offset accounts |
| `interestSaved` | Money | Interest saved through offset |

**Offset Mortgage:** Savings balances offset against mortgage, reducing interest charged

#### sharedOwnershipDetails

Shared ownership mortgage details:

| Field | Type | Description |
|-------|------|-------------|
| `isSharedOwnership` | boolean | Whether this is shared ownership |
| `equityShare` | decimal | Percentage of property owned (%) |
| `rentOnUnownedShare` | Money | Monthly rent paid on unowned share |
| `staircasingOptions` | string | Options to buy additional equity |

**Shared Ownership:** Part-buy, part-rent scheme (typically housing association)

#### specialFeatures

Special mortgage features:

| Field | Type | Description |
|-------|------|-------------|
| `hasPaymentHoliday` | boolean | Payment holiday feature available |
| `hasUnderpaymentOption` | boolean | Option to temporarily underpay |
| `hasBorrowBack` | boolean | Option to borrow back overpayments |
| `cashbackAmount` | Money | Cashback received |
| `freeValuation` | boolean | Free valuation included |
| `freeLegalFees` | boolean | Free legal fees included |

#### owners

Mortgage ownership details:

| Field | Type | Description |
|-------|------|-------------|
| `client` | Reference Link | Link to client owner |
| `ownershipType` | string | Ownership type: Sole, Joint, Joint Tenants, Tenants in Common |
| `percentage` | decimal | Ownership percentage (for Tenants in Common) |

#### linkedArrangements

Other arrangements linked to this mortgage:

| Field | Type | Description |
|-------|------|-------------|
| `arrangementType` | string | Type: Life Assurance, Buildings Insurance, Contents Insurance |
| `arrangementId` | integer | Linked arrangement ID |
| `policyNumber` | string | Policy number |
| `provider` | string | Provider name |

**Common Linked Arrangements:**
- **Life Assurance** - Life cover to repay mortgage on death
- **Buildings Insurance** - Required by lender
- **Payment Protection Insurance** - Optional income protection

#### Reference Link

Standard reference structure:

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique identifier of referenced entity |
| `href` | string | API endpoint URL for referenced entity |

**Used for:** `asset`, `factfind`, `property`, `propertyDetail`, `sellingAdviser`

#### Money

Currency amount structure:

| Field | Type | Description |
|-------|------|-------------|
| `amount` | decimal | Monetary amount |
| `currency` | Complex Data | Currency details |
| `code` | string | Currency code (e.g., GBP) |
| `symbol` | string | Currency symbol (e.g., £) |

### Mortgage Types and Purposes

**By Property Type:**
- **Residential** - Main residence or second home
- **Buy-to-Let** - Rental investment property
- **Commercial** - Business premises
- **Right to Buy** - Council property purchase
- **Shared Ownership** - Part-buy, part-rent

**By Purpose:**
- **Purchase** - Buying a property
- **Remortgage** - Switching to new lender
- **Further Advance** - Additional borrowing on existing mortgage
- **Product Transfer** - Switching product with same lender
- **Equity Release** - Lifetime/retirement mortgage

### Regulatory Requirements

This entity supports compliance with:
- **MCOB (Mortgage Conduct of Business)** - FCA mortgage regulations
- **Mortgage Credit Directive** - EU consumer protection
- **Responsible Lending** - Affordability assessments required

### Related Resources

Mortgages link to:
- **Property Detail** - The secured property asset
- **Clients** - Mortgage owners/borrowers
- **Selling Adviser** - The mortgage adviser
- **Linked Arrangements** - Associated life assurance and insurance policies

---

## Complete Contract Schema

### Residential Mortgage Example (Fixed Rate)

```json
{
  "id": 5001,
  "href": "/api/v2/factfinds/679/mortgages/5001",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "arrangementCategory": "MORTGAGE",
  "accountNumber": "NBS-MORT-123456",
  "policyNumber": "POL-98765",
  "illustrationReference": "ILL-REF-2018-456",
  "owners": [
    {
      "id": 8496,
      "href": "/api/v2/factfinds/679/clients/8496",
      "fullName": "John Smith",
      "ownershipPercentage": 50.0
    },
    {
      "id": 8497,
      "href": "/api/v2/factfinds/679/clients/8497",
      "fullName": "Jane Smith",
      "ownershipPercentage": 50.0
    }
  ],
  "sellingAdviser": {
    "id": 123,
    "href": "/api/v2/advisers/123",
    "name": "Jane Financial Adviser"
  },
  "productType": "FixedRateMortgage",
  "lenderName": "Nationwide Building Society",
  "productName": "5 Year Fixed Rate Mortgage",
  "description": "Main residence mortgage - 25 year term",
  "loanAmounts": {
    "originalLoanAmount": {
      "amount": 300000.00,
      "currency": {
        "code": "GBP",
        "display": "British Pound",
        "symbol": "£"
      }
    },
    "currentBalance": {
      "amount": 245000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "depositAmount": {
      "amount": 100000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "originalPropertyValuation": {
      "amount": 400000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "currentPropertyValuation": {
      "amount": 425000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "loanToValue": {
      "percentage": 75.0,
      "propertyValue": {
        "amount": 400000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "loanAmount": {
        "amount": 300000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "calculatedOn": "2018-06-15"
    },
    "currentLTV": {
      "percentage": 57.65,
      "outstandingBalance": {
        "amount": 245000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "currentPropertyValue": {
        "amount": 425000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "calculatedOn": "2026-02-18"
    }
  },
  "interestTerms": {
    "interestRate": 4.25,
    "annualPercentageRate": 4.35,
    "rateType": "Fixed",
    "baseRateIndex": null,
    "reversionRate": 7.99,
    "hasCollarRate": false,
    "collarRate": null,
    "initialRatePeriodEndsOn": "2028-06-30",
    "initialTermYears": 5,
    "initialTermMonths": 0,
    "remainingTermYears": 17,
    "remainingTermMonths": 4
  },
  "repaymentStructure": {
    "repaymentMethod": "CapitalAndInterest",
    "capitalRepaymentAmount": {
      "amount": 300000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "capitalTermYears": 25,
    "capitalTermMonths": 0,
    "interestOnlyAmount": null,
    "interestOnlyTermYears": null,
    "interestOnlyTermMonths": null,
    "interestOnlyRepaymentVehicle": null,
    "lumpSumAdvance": null,
    "monthlyIncomeDrawdown": null,
    "regularAnnualOverpayment": null,
    "currentRepaymentVehicles": []
  },
  "feesAndCharges": {
    "lenderFees": {
      "amount": 999.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "ongoingContributions": null
  },
  "keyDates": {
    "startDate": "2018-06-15",
    "endDate": "2043-06-15",
    "completionDate": "2018-06-15",
    "exchangeDate": "2018-06-08",
    "nextPaymentDueDate": "2026-03-15",
    "nextReviewDate": "2028-01-01",
    "balanceAsOfDate": "2026-02-18",
    "applicationSubmittedDate": "2018-05-10",
    "valuationInstructedDate": "2018-05-12",
    "valuationDate": "2018-05-18",
    "valuationReceivedDate": "2018-05-22",
    "offerIssuedDate": "2018-05-28",
    "targetCompletionDate": "2018-06-15",
    "schemeEndDate": null
  },
  "redemptionTerms": {
    "hasEarlyRepaymentCharge": true,
    "earlyRepaymentTerms": "4% of outstanding balance until 2028-06-30",
    "earlyRepaymentChargeEndsOn": "2028-06-30",
    "earlyRepaymentCharge": {
      "amount": 9800.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "earlyRepaymentChargeSecondCharge": null,
    "netProceedsOnRedemption": {
      "amount": 235200.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    }
  },
  "specialFeatures": {
    "isFirstTimeBuyer": false,
    "isCurrentResidence": true,
    "hasGuarantor": false,
    "isPortable": true,
    "isPropertySold": false,
    "isRedeemed": false,
    "hasDischargeOnCompletion": false,
    "hasConsentToLet": false,
    "consentToLetExpiresOn": null,
    "hasDebtConsolidation": false,
    "incomeVerificationStatus": "Employed",
    "isIncomeEvidenced": true
  },
  "propertyDetail": {
    "id": 1001,
    "href": "/api/v2/factfinds/679/property-details/1001"
  },
  "asset": {
    "id": 67890,
    "href": "/api/v2/factfinds/679/assets/67890"
  },
  "linkedArrangements": [
    {
      "arrangementType": "LifeAssurance",
      "arrangementId": 6001,
      "policyNumber": "LIFE-123456",
      "provider": "Aviva",
      "sumAssured": {
        "amount": 300000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      }
    }
  ],
  "agencyStatus": "NOT_UNDER_AGENCY",
  "agencyStatusDate": "2018-06-15",
  "notes": "5 year fixed rate ends June 2028. Review remortgage options 6 months before.",
  "createdAt": "2018-06-15T11:00:00Z",
  "updatedAt": "2026-02-25T14:30:00Z"
}
```

### Buy-to-Let Mortgage Example (Tracker Rate)

```json
{
  "id": 5002,
  "href": "/api/v2/factfinds/679/mortgages/5002",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "arrangementCategory": "MORTGAGE",
  "accountNumber": "BTL-789456",
  "owners": [
    {
      "id": 8496,
      "href": "/api/v2/factfinds/679/clients/8496",
      "fullName": "John Smith",
      "ownershipPercentage": 100.0
    }
  ],
  "productType": "BuyToLetMortgage",
  "lenderName": "Paragon Bank",
  "productName": "Buy-to-Let Tracker Mortgage",
  "description": "Rental property investment - Leicester flat",
  "loanAmounts": {
    "originalLoanAmount": {
      "amount": 150000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "currentBalance": {
      "amount": 138000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "depositAmount": {
      "amount": 50000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "originalPropertyValuation": {
      "amount": 200000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "currentPropertyValuation": {
      "amount": 220000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "loanToValue": {
      "percentage": 75.0,
      "propertyValue": {
        "amount": 200000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "loanAmount": {
        "amount": 150000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "calculatedOn": "2020-09-01"
    },
    "currentLTV": {
      "percentage": 62.73,
      "outstandingBalance": {
        "amount": 138000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "currentPropertyValue": {
        "amount": 220000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "calculatedOn": "2026-02-18"
    }
  },
  "interestTerms": {
    "interestRate": 6.24,
    "annualPercentageRate": 6.35,
    "rateType": "Tracker",
    "baseRateIndex": "Bank of England Base Rate",
    "trackerMargin": 1.49,
    "reversionRate": 8.99,
    "hasCollarRate": false,
    "remainingTermYears": 19,
    "remainingTermMonths": 7
  },
  "repaymentStructure": {
    "repaymentMethod": "InterestOnly",
    "interestOnlyAmount": {
      "amount": 150000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "interestOnlyTermYears": 25,
    "interestOnlyRepaymentVehicle": "Property Sale on Maturity"
  },
  "keyDates": {
    "startDate": "2020-09-01",
    "endDate": "2045-09-01",
    "completionDate": "2020-09-01",
    "nextPaymentDueDate": "2026-03-01",
    "nextReviewDate": "2026-09-01",
    "balanceAsOfDate": "2026-02-18"
  },
  "redemptionTerms": {
    "hasEarlyRepaymentCharge": false
  },
  "specialFeatures": {
    "isFirstTimeBuyer": false,
    "isCurrentResidence": false,
    "hasGuarantor": false,
    "isPortable": false,
    "hasConsentToLet": true,
    "rentalIncome": {
      "amount": 950.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      },
      "frequency": "Monthly"
    }
  },
  "propertyDetail": {
    "id": 1002,
    "href": "/api/v2/factfinds/679/property-details/1002"
  },
  "agencyStatus": "NOT_UNDER_AGENCY",
  "notes": "BTL rental property. Current tenant lease expires Aug 2027. Rental yield 5.2%.",
  "createdAt": "2020-09-01T10:00:00Z",
  "updatedAt": "2026-02-25T14:30:00Z"
}
```

### Equity Release (Lifetime Mortgage) Example

```json
{
  "id": 5003,
  "href": "/api/v2/factfinds/679/mortgages/5003",
  "factfind": {
    "id": 679,
    "href": "/api/v2/factfinds/679"
  },
  "arrangementCategory": "MORTGAGE",
  "accountNumber": "EQR-456789",
  "owners": [
    {
      "id": 8498,
      "href": "/api/v2/factfinds/679/clients/8498",
      "fullName": "Mary Johnson",
      "ownershipPercentage": 100.0
    }
  ],
  "productType": "LifetimeMortgage",
  "lenderName": "Just Retirement",
  "productName": "Lifetime Mortgage Plan",
  "description": "Equity release for home improvements and gifting",
  "loanAmounts": {
    "originalLoanAmount": {
      "amount": 75000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "currentBalance": {
      "amount": 95250.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "equityReleased": {
      "amount": 75000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "originalPropertyValuation": {
      "amount": 350000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "currentPropertyValuation": {
      "amount": 385000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "loanToValue": {
      "percentage": 21.43,
      "propertyValue": {
        "amount": 350000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "loanAmount": {
        "amount": 75000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "calculatedOn": "2021-03-15"
    },
    "currentLTV": {
      "percentage": 24.74,
      "outstandingBalance": {
        "amount": 95250.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "currentPropertyValue": {
        "amount": 385000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      },
      "calculatedOn": "2026-02-18"
    }
  },
  "interestTerms": {
    "interestRate": 6.10,
    "annualPercentageRate": 6.10,
    "rateType": "Fixed",
    "interestRollUp": true,
    "compoundFrequency": "Annual"
  },
  "repaymentStructure": {
    "repaymentMethod": "InterestRollUp",
    "interestOnlyAmount": {
      "amount": 75000.00,
      "currency": {
        "code": "GBP",
        "symbol": "£"
      }
    },
    "interestOnlyRepaymentVehicle": "Repayable on death or move to care"
  },
  "keyDates": {
    "startDate": "2021-03-15",
    "completionDate": "2021-03-15",
    "balanceAsOfDate": "2026-02-18",
    "nextReviewDate": "2027-03-15"
  },
  "redemptionTerms": {
    "hasEarlyRepaymentCharge": true,
    "earlyRepaymentTerms": "No ERC if moving to long-term care or death. 5% ERC for voluntary redemption in years 1-5, reducing by 1% per year.",
    "earlyRepaymentChargeEndsOn": "2026-03-15"
  },
  "specialFeatures": {
    "isCurrentResidence": true,
    "hasNoNegativeEquityGuarantee": true,
    "hasDownsizingProtection": true,
    "hasInheritanceProtection": false,
    "drawdownReserveFacility": {
      "available": true,
      "reserveAmount": {
        "amount": 25000.00,
        "currency": {
          "code": "GBP",
          "symbol": "£"
        }
      }
    }
  },
  "propertyDetail": {
    "id": 1003,
    "href": "/api/v2/factfinds/679/property-details/1003"
  },
  "agencyStatus": "UNDER_AGENCY_SERVICING_AGENT",
  "agencyStatusDate": "2021-03-15",
  "notes": "Lifetime mortgage with drawdown reserve. No monthly payments. Interest rolls up. Protected by no negative equity guarantee.",
  "createdAt": "2021-03-15T14:00:00Z",
  "updatedAt": "2026-02-25T14:30:00Z"
}
```

---

## Business Validation Rules

### Required Fields

- `arrangementCategory` is required (must be "MORTGAGE")
- `productType` is required
- `lenderName` is required
- `owners` list must contain at least one owner
- `loanAmounts.originalLoanAmount` is required
- `loanAmounts.currentBalance` is required
- `interestTerms.interestRate` is required
- `interestTerms.rateType` is required
- `repaymentStructure.repaymentMethod` is required

### Product Types

- **FixedRateMortgage** - Fixed interest rate for initial period
- **VariableRateMortgage** - Lender's standard variable rate
- **TrackerMortgage** - Tracks base rate plus margin
- **DiscountMortgage** - Discount off SVR for initial period
- **BuyToLetMortgage** - Rental property mortgage
- **LifetimeMortgage** - Equity release (interest roll-up)
- **HomeReversionPlan** - Equity release (sell share of property)
- **SecondChargeMortgage** - Additional loan secured against property
- **SharedOwnershipMortgage** - Part-buy, part-rent scheme

### Rate Types

- **Fixed** - Rate fixed for initial period (e.g., 2, 5, 10 years)
- **Variable** - Lender's standard variable rate (SVR)
- **Tracker** - Tracks base rate plus margin (e.g., Base Rate + 2%)
- **Discount** - Discount off SVR for initial period
- **Capped** - Variable but with maximum rate cap

### Repayment Methods

- **CapitalAndInterest** - Principal and interest paid each month (repayment)
- **InterestOnly** - Interest only paid; capital repaid at end
- **PartAndPart** - Combination of repayment and interest-only
- **InterestRollUp** - Interest added to balance (equity release)

### LTV Validation

- `loanToValue.percentage` must be calculated as: `(loanAmount / propertyValue) × 100`
- `currentLTV.percentage` must be calculated as: `(currentBalance / currentPropertyValue) × 100`
- Residential mortgages typically max 95% LTV
- Buy-to-Let mortgages typically max 75-80% LTV
- Equity release typically max 50-60% LTV (age-dependent)

### Interest Terms Validation

- `interestRate` must be greater than 0
- `annualPercentageRate` (APR) must be greater than or equal to `interestRate`
- When `rateType = Tracker`, `baseRateIndex` is required
- `initialRatePeriodEndsOn` required for Fixed and Discount rates
- `remainingTermYears` and `remainingTermMonths` must reflect time to maturity

### Repayment Structure Validation

- When `repaymentMethod = CapitalAndInterest`, `capitalRepaymentAmount` and `capitalTermYears` are required
- When `repaymentMethod = InterestOnly`, `interestOnlyAmount` and `interestOnlyRepaymentVehicle` are required
- When `repaymentMethod = PartAndPart`, both capital and interest-only fields are required

---

## UK Mortgage Regulations

### Regulatory Framework

- **FCA MCOB** - Mortgage Conduct of Business sourcebook
- **Mortgage Credit Directive (MCD)** - EU consumer protection (retained in UK law)
- **Responsible Lending** - Affordability assessments required
- **Consumer Duty** - Fair value and good outcomes

### Key Requirements

**Affordability Assessment:**
- Lenders must assess borrower's ability to repay
- Income verification required
- Expenditure analysis mandatory
- Stress testing at higher rates

**Loan-to-Value Limits:**
- Residential: Typically max 95% LTV (95% maximum for high LTV lending)
- Buy-to-Let: Typically max 75-80% LTV
- Interest Coverage Ratio (ICR) of 125-145% for BTL

**Early Repayment Charges:**
- Must be disclosed upfront
- Typically apply during initial rate period
- Cannot exceed outstanding interest for the term

**Equity Release Protections:**
- **No Negative Equity Guarantee** - Debt cannot exceed property value
- **Right to Remain** - Borrower can stay in home for life
- **Fixed Interest Rate** - Rate cannot increase
- **Downsizing Protection** - Ability to move without full ERC

**Product Types:**
- **Regulated Mortgage** - Primary residence (MCOB protection)
- **Buy-to-Let** - Investment property (limited regulation)
- **Second Charge** - Additional loan on property with existing mortgage

---

**Document Version:** 2.0
**Last Updated:** 2026-02-25
**Entity:** Mortgage
**Domain:** Plans