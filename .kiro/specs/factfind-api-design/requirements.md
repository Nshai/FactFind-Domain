# FactFind API Design Requirements

## Introduction

This document specifies the requirements for designing modern, resource-centric REST APIs for the FactFind system. The APIs will replace the current screen-based legacy controllers with RESTful endpoints that follow Intelliflo's API Design Guidelines 2.0.

## Glossary

- **FactFind**: A comprehensive data collection process for gathering client financial information
- **Client**: A person or entity for whom financial advice is provided (synonym: Investor)
- **Joint_FactFind**: A FactFind that involves two clients (e.g., married couple)
- **Resource**: A RESTful API entity that can be addressed by a URI and supports CRUD operations
- **Legacy_Controller**: The existing screen-based MVC controllers in IntelligentOffice
- **Modern_API**: The new RESTful API endpoints following Intelliflo guidelines

## Requirements

### Requirement 1: FactFind Management

**User Story:** As a financial adviser, I want to manage FactFind records for my clients, so that I can track and organize their financial data collection process.

#### Acceptance Criteria

1. WHEN I request a client's FactFinds, THE System SHALL return all FactFind records associated with that client
2. WHEN I create a new FactFind, THE System SHALL create a FactFind record linking to the primary client
3. WHEN I add a partner to a FactFind, THE System SHALL update the FactFind to include the secondary client
4. WHEN I remove a partner from a FactFind, THE System SHALL create a separate FactFind for the removed partner
5. THE System SHALL support both individual and joint FactFinds

### Requirement 2: Personal Profile Management

**User Story:** As a financial adviser, I want to manage client personal details, so that I have accurate personal information for advice provision.

#### Acceptance Criteria

1. WHEN I update personal details, THE System SHALL validate and store the client's personal information
2. WHEN I manage contact details, THE System SHALL handle addresses, phone numbers, and email addresses
3. WHEN I add dependants, THE System SHALL store dependant information linked to the client
4. WHEN I manage ID verification, THE System SHALL track verification status and documents
5. THE System SHALL support vulnerability assessments for clients

### Requirement 3: Employment Information Management

**User Story:** As a financial adviser, I want to manage client employment details, so that I can assess their income and employment stability.

#### Acceptance Criteria

1. WHEN I create employment records, THE System SHALL store comprehensive employment information
2. WHEN I update employment status, THE System SHALL validate status-specific required fields
3. WHEN I manage employment history, THE System SHALL maintain chronological employment records
4. WHEN I calculate affordability, THE System SHALL use employment income data
5. THE System SHALL support various employment types (employed, self-employed, retired, etc.)

### Requirement 4: Assets Management

**User Story:** As a financial adviser, I want to manage client assets, so that I can understand their current financial position.

#### Acceptance Criteria

1. WHEN I create asset records, THE System SHALL store asset details with valuations and ownership
2. WHEN I update asset values, THE System SHALL maintain valuation history
3. WHEN I manage asset ownership, THE System SHALL support individual, joint, and percentage ownership
4. WHEN I link assets to addresses, THE System SHALL maintain property relationships
5. THE System SHALL support multiple currencies for international assets

### Requirement 5: Liabilities Management

**User Story:** As a financial adviser, I want to manage client liabilities, so that I can assess their debt position and repayment capacity.

#### Acceptance Criteria

1. WHEN I create liability records, THE System SHALL store comprehensive debt information
2. WHEN I manage mortgage details, THE System SHALL handle property-secured debts
3. WHEN I track repayment schedules, THE System SHALL calculate payment obligations
4. WHEN I assess affordability, THE System SHALL include liability payments
5. THE System SHALL support various liability types (mortgages, loans, credit cards, etc.)

### Requirement 6: Income and Budget Management

**User Story:** As a financial adviser, I want to manage client income and expenditure, so that I can assess their financial capacity and affordability.

#### Acceptance Criteria

1. WHEN I record income sources, THE System SHALL capture detailed income breakdown
2. WHEN I manage expenditure, THE System SHALL categorize expenses by type and priority
3. WHEN I calculate affordability, THE System SHALL compute surplus/deficit from income and expenditure
4. WHEN I track income changes, THE System SHALL maintain historical income data
5. THE System SHALL support various income frequencies and sources

### Requirement 7: Investment and Risk Management

**User Story:** As a financial adviser, I want to manage client investment needs and risk profiles, so that I can provide appropriate investment advice.

#### Acceptance Criteria

1. WHEN I assess investment needs, THE System SHALL capture investment objectives and goals
2. WHEN I conduct risk profiling, THE System SHALL store risk questionnaire responses
3. WHEN I manage investment requirements, THE System SHALL link requirements to client goals
4. WHEN I track risk tolerance, THE System SHALL maintain risk assessment history
5. THE System SHALL support attitude to risk (ATR) template management

### Requirement 8: Notes and Documentation

**User Story:** As a financial adviser, I want to add notes and documentation to FactFind sections, so that I can record additional context and observations.

#### Acceptance Criteria

1. WHEN I add notes to any FactFind section, THE System SHALL store and retrieve notes
2. WHEN I manage document disclosures, THE System SHALL track disclosure requirements
3. WHEN I generate FactFind reports, THE System SHALL include relevant notes and documentation
4. THE System SHALL support rich text formatting in notes
5. THE System SHALL maintain audit trails for note modifications

### Requirement 9: API Design Compliance

**User Story:** As an API consumer, I want consistent and well-designed APIs, so that I can easily integrate with the FactFind system.

#### Acceptance Criteria

1. THE System SHALL follow RESTful architectural principles
2. THE System SHALL use consistent resource naming conventions (plural, lowercase)
3. THE System SHALL implement proper HTTP methods (GET, POST, PUT, DELETE)
4. THE System SHALL return appropriate HTTP status codes
5. THE System SHALL include HATEOAS links for resource navigation
6. THE System SHALL support filtering, sorting, and pagination
7. THE System SHALL use consistent error response formats
8. THE System SHALL follow Intelliflo API Design Guidelines 2.0

### Requirement 10: Data Validation and Security

**User Story:** As a system administrator, I want robust data validation and security, so that client data is protected and accurate.

#### Acceptance Criteria

1. WHEN processing API requests, THE System SHALL validate all input data
2. WHEN handling sensitive data, THE System SHALL apply appropriate security measures
3. WHEN managing client access, THE System SHALL enforce authorization rules
4. WHEN logging activities, THE System SHALL maintain audit trails
5. THE System SHALL support multi-tenant data isolation

### Requirement 11: Backward Compatibility and Migration

**User Story:** As a system integrator, I want smooth migration from legacy systems, so that existing integrations continue to work.

#### Acceptance Criteria

1. WHEN migrating from legacy controllers, THE System SHALL maintain data integrity
2. WHEN supporting existing clients, THE System SHALL provide migration paths
3. WHEN versioning APIs, THE System SHALL maintain backward compatibility
4. THE System SHALL support gradual migration strategies
5. THE System SHALL provide clear deprecation notices for legacy endpoints

### Requirement 12: Performance and Scalability

**User Story:** As a system user, I want responsive APIs, so that I can work efficiently with client data.

#### Acceptance Criteria

1. WHEN processing API requests, THE System SHALL respond within acceptable time limits
2. WHEN handling large datasets, THE System SHALL implement efficient pagination
3. WHEN managing concurrent access, THE System SHALL handle multiple users safely
4. THE System SHALL support caching for frequently accessed data
5. THE System SHALL scale to handle increasing user loads