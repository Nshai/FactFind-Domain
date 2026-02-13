# FactFind Sections Reference

This document lists all factfind sections and entities identified in `Context\Target-Entities.png`.

## Overview

The diagram shows a comprehensive factfind structure centered around the **FactFind** entity, with connections to **Client** and **Plan** entities. The factfind covers financial profile, goals, risk assessment, employment, protection, pensions, and investments.

---

## Core Entities

### Central Entity
- **FactFind** (Central hub for all factfind data)

### Related Core Entities
- **Client** (Links to client identity and profile)
- **Plan** (Links to financial planning and recommendations)

---

## Client Profile Sections

These sections relate to client identity and personal information (typically part of CRM domain):

- **Vulnerability**
- **Data Protection**
- **Contact Details**
- **Personal**
- **Trust**
- **Corporate**
- **Marketing**
- **ID Verification**
- **Estate Planning**
- **Tax Details**
- **Current Position**

---

## FactFind Core Sections

### 1. Goals & Objectives
- **Goals**
- **Needs & Priorities**
- **Custom Questions**
- **Dependants** (Financial dependants)

### 2. Assets & Liabilities
- **Asset**
- **Liability**
- **Credit History (A&L)**
- **Asset/Liabilities** (Combined view)

#### Property & Mortgages
- **Property Details**
- **Mortgages** (Under Property)
- **Mortgages** (Standalone)

#### Equities
- **Equities**

#### Notes
- **Notes** (A&L section)

### 3. Credit & Budget
- **Credit History**
- **Budget**
- **Expenditure**
- **Income**
- **Affordability**

### 4. Employment & Income
- **Employment**
- **Employment Details**
- **Total Earned Income**
- **Tax Rate**
- **Notes** (Employment section)

### 5. Risk Assessment (ATR)
- **Risk Questionnaire**
- **Risk Replay**
- **Risk Income**
- **Supplementary Questions** (Risk section)
- **Supplementary Questions** (General)
- **Declaration**
- **Completion**
- **Notes** (Risk section)

### 6. Existing Plans & Providers
- **Existing Providers**
- **Cash**
- **Notes** (Plan section)

### 7. Protection & Insurance
- **Protection & Insurance**
- **Existing Provisions**
- **Notes** (Protection section)

### 8. Pensions & Retirement

#### Top Level
- **Pensions & Investments**
- **Notes** (Pensions section)

#### Pension Details
- **Existing Employers**
- **Pension Provision**
- **State Pension Entitlement**

#### Pension Types
- **Eligibility & Entitlement**
- **Final Salary**
- **Final Salary Pension**
- **Money Purchase**
- **Personal Pension**
- **Annuities**
- **Scheme**
- **Notes** (Pension details)

### 9. Savings & Investments
- **Savings & Investments**

---

## Section Groupings by Domain

### Client Domain (WHO)
Client identity and profile sections (typically managed by CRM):
- Vulnerability
- Data Protection
- Contact Details
- Personal
- Trust
- Corporate
- Marketing
- ID Verification
- Estate Planning
- Tax Details
- Current Position

### FactFind Domain (WHAT)
Financial profile and fact-finding sections:
- Goals & Objectives
- Dependants (Financial)
- Assets & Liabilities
- Credit History
- Budget & Affordability
- Employment & Income
- Existing Plans & Providers
- Protection & Insurance
- Pensions & Retirement
- Savings & Investments

### ATR Domain (Risk Assessment)
Risk profiling and attitude to risk:
- Risk Questionnaire
- Risk Replay
- Risk Income
- Supplementary Questions
- Declaration
- Completion

### Portfolio/Plan Domain
Existing financial products and holdings:
- Existing Providers
- Existing Provisions
- Cash holdings
- Current Position

---

## Total Section Count

- **Client Profile Sections:** 11
- **Goals & Objectives:** 4 entities
- **Assets & Liabilities:** 9 entities
- **Credit & Budget:** 5 entities
- **Employment & Income:** 5 entities
- **Risk Assessment (ATR):** 8 entities
- **Plans & Providers:** 3 entities
- **Protection & Insurance:** 3 entities
- **Pensions & Retirement:** 13 entities
- **Savings & Investments:** 1 entity

**Total Entities Identified:** 62+

---

## Notes Field Pattern

The diagram shows that **Notes** fields appear in multiple sections:
- Assets & Liabilities
- Employment
- Risk Assessment
- Plans
- Protection & Insurance
- Pensions

This indicates a scattered notes pattern (identified as technical debt in the domain analysis).

---

## Key Relationships

1. **FactFind → Client** - Client identity reference
2. **FactFind → Goals** - Client goals and objectives
3. **FactFind → Dependants** - Financial dependants
4. **FactFind → Employment** - Employment and income details
5. **FactFind → Risk** - Risk assessment and ATR
6. **FactFind → Plan** - Financial plans and existing provisions
7. **Client → Goals** - Goals linked to client
8. **Goals → Risk Income** - Goals with risk considerations
9. **Asset/Liability ↔ Income** - Assets generating income

---

## References

- **Source:** Context\Target-Entities.png
- **Related Documents:**
  - Domain-Model-Analysis-V2.md
  - steering/Client-FactFind-Boundary-Analysis.md
  - steering/ANALYSIS-COMPLETE-V2.md

---

**Document Purpose:** This reference document provides a complete catalog of factfind sections to ensure comprehensive V3 API contract coverage.
