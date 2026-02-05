# Implementation Tasks: FactFind API Design

## Overview

This document outlines the implementation tasks for transforming the FactFind system from legacy MVC controllers to modern resource-centric REST APIs following Intelliflo API Design Guidelines 2.0.

## Tasks

- [ ] 1. Project Foundation and Infrastructure Setup
  - Create new API project structure following Monolith.FactFind patterns
  - Set up dependency injection container (Autofac)
  - Configure NHibernate mappings for core FactFind entities
  - Implement base controller, service, and repository patterns
  - Set up Swagger/OpenAPI documentation with comprehensive examples
  - Configure authentication and authorization middleware with scope support
  - Set up unit and integration test projects with FluentAssertions
  - Configure logging with correlation ID support
  - Implement health check endpoints
  - _Requirements: 9.1, 9.2, 9.3, 9.4, 10.1, 10.2, 10.3, 10.4_

- [ ]* 1.1 Write unit tests for base infrastructure components
  - Test base controller functionality
  - Test authentication and authorization filters
  - Test error handling middleware
  - _Requirements: 9.1, 10.1_

- [ ] 2. Core FactFind Resource API
  - [ ] 2.1 Implement FactFind domain entity and NHibernate mapping
    - Create FactFind entity class with audit attributes
    - Add NHibernate mapping file (.hbm.xml)
    - Include support for individual and joint FactFinds
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_

  - [ ] 2.2 Create FactFind API contracts
    - BaseFactFindDocument for shared properties
    - CreateFactFindDocument for POST operations
    - FactFindDocument for GET/PUT responses
    - Include comprehensive data annotations and Swagger documentation
    - _Requirements: 1.1, 1.2, 9.1, 9.2, 9.3_

  - [ ] 2.3 Implement FactFind converter with bidirectional mapping
    - Create IFactFindConverter interface
    - Implement ToContract and ToDomain methods
    - Handle enum conversions using EnumHelper
    - Include HATEOAS links for resource navigation
    - _Requirements: 1.1, 9.5_

  - [ ]* 2.4 Write property test for FactFind converter
    - **Property 1: FactFind round trip consistency**
    - **Validates: Requirements 1.1, 1.2**

  - [ ] 2.5 Create FactFind validator
    - Implement IFactFindValidator interface
    - Validate client relationships and joint FactFind rules
    - Use Check.IsTrue() for validation assertions
    - _Requirements: 1.2, 1.3, 1.4, 10.1_

  - [ ]* 2.6 Write unit tests for FactFind validator
    - Test individual FactFind validation
    - Test joint FactFind validation rules
    - Test partner addition/removal scenarios
    - _Requirements: 1.2, 1.3, 1.4_

  - [ ] 2.7 Implement FactFind resource with business logic
    - Add [Transaction] and [PublishEvent<T>] attributes
    - Implement CRUD operations (Create, Read, Update, Delete)
    - Handle partner addition and removal logic
    - Support FactFind archiving and restoration
    - _Requirements: 1.1, 1.2, 1.3, 1.4_

  - [ ] 2.8 Create FactFind controller with comprehensive endpoints
    - Implement GET /v2/factfinds (list all FactFinds)
    - Implement POST /v2/factfinds (create new FactFind)
    - Implement GET /v2/factfinds/{id} (get FactFind details)
    - Implement PUT /v2/factfinds/{id} (update FactFind)
    - Implement DELETE /v2/factfinds/{id} (delete FactFind)
    - Include comprehensive Swagger documentation
    - _Requirements: 1.1, 1.2, 9.1, 9.2, 9.3, 9.4_

  - [ ]* 2.9 Write integration tests for FactFind API
    - Test CRUD operations end-to-end
    - Test partner management scenarios
    - Test error handling and validation
    - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [ ] 3. Checkpoint - Core FactFind API Complete
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 4. Profile Management APIs
  - [ ] 4.1 Implement Personal Details API
    - Create PersonalDetails domain entity and mapping
    - Implement PersonalDetailsDocument contracts
    - Create converter with proper data type handling (ISO 8601 dates)
    - Build validator for personal information rules
    - Implement GET/PUT endpoints for personal details
    - _Requirements: 2.1, 2.2, 9.1, 9.2_

  - [ ]* 4.2 Write property test for Personal Details
    - **Property 2: Personal details data integrity**
    - **Validates: Requirements 2.1**

  - [ ] 4.3 Implement Contact Details API
    - Create ContactDetails domain entity and mapping
    - Support multiple email addresses and phone numbers
    - Implement contact preference management
    - Build GET/PUT endpoints for contact details
    - _Requirements: 2.2, 9.1, 9.2_

  - [ ] 4.4 Implement Addresses API
    - Create Address domain entity with component mapping
    - Support multiple address types (Home, Work, Previous)
    - Implement address history tracking
    - Build full CRUD endpoints for addresses
    - Include address validation with country/county providers
    - _Requirements: 2.2, 9.1, 9.2_

  - [ ]* 4.5 Write unit tests for Address management
    - Test address CRUD operations
    - Test address type validation
    - Test address history tracking
    - _Requirements: 2.2_

  - [ ] 4.6 Implement Dependants API
    - Create Dependant domain entity and mapping
    - Support financial dependency tracking
    - Handle special needs information
    - Build full CRUD endpoints for dependants
    - _Requirements: 2.3, 9.1, 9.2_

  - [ ] 4.7 Implement ID Verification API
    - Extend PersonalDetails with verification status
    - Track verification documents and status
    - Implement verification workflow endpoints
    - _Requirements: 2.4, 10.1, 10.2_

  - [ ]* 4.8 Write integration tests for Profile APIs
    - Test personal details management
    - Test contact details and addresses
    - Test dependant management
    - Test ID verification workflow
    - _Requirements: 2.1, 2.2, 2.3, 2.4_

- [ ] 5. Employment Management APIs
  - [ ] 5.1 Implement Employment domain entity
    - Create Employment entity with comprehensive fields
    - Add NHibernate mapping with component for employer address
    - Support various employment statuses and business types
    - Include employment history tracking
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

  - [ ] 5.2 Create Employment API contracts
    - BaseEmploymentDocument for shared properties
    - CreateEmploymentDocument for POST operations
    - EmploymentDocument for GET/PUT responses
    - Include employment address as value object
    - Support self-employed accounts information
    - _Requirements: 3.1, 3.2, 9.1, 9.2_

  - [ ] 5.3 Implement Employment converter
    - Handle employment status enum conversions
    - Map employer address using address providers
    - Convert employment dates with proper ISO 8601 format
    - Include currency handling for salary information
    - _Requirements: 3.1, 3.2, 9.1_

  - [ ]* 5.4 Write property test for Employment converter
    - **Property 3: Employment data round trip consistency**
    - **Validates: Requirements 3.1, 3.2**

  - [ ] 5.5 Create Employment validator
    - Validate employment status-specific required fields
    - Ensure employment date consistency (start <= end)
    - Validate salary and currency information
    - Check self-employed specific validations
    - _Requirements: 3.1, 3.2, 10.1_

  - [ ] 5.6 Implement Employment resource
    - Add transaction and event publishing attributes
    - Support employment history management
    - Handle current vs historical employment logic
    - Implement affordability calculations
    - _Requirements: 3.1, 3.2, 3.3, 3.4_

  - [ ] 5.7 Create Employment controller
    - Implement GET /v2/factfinds/{id}/employment/employments
    - Implement POST for creating new employment
    - Implement PUT for updating employment
    - Implement DELETE for removing employment
    - Support filtering by employment status and dates
    - _Requirements: 3.1, 3.2, 3.3, 9.1, 9.2_

  - [ ]* 5.8 Write integration tests for Employment API
    - Test employment CRUD operations
    - Test employment history tracking
    - Test employment status transitions
    - Test affordability calculations
    - _Requirements: 3.1, 3.2, 3.3, 3.4_

- [ ] 6. Checkpoint - Profile and Employment APIs Complete
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 7. Assets Management APIs
  - [ ] 7.1 Implement Assets domain entity
    - Create Asset entity with valuation support
    - Add NHibernate mapping with component for asset address
    - Support multiple asset types (Property, Investment, Pension)
    - Include ownership percentage and joint ownership
    - Track asset income generation
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

  - [ ] 7.2 Create Assets API contracts
    - BaseAssetDocument for shared properties
    - CreateAssetDocument for POST operations
    - AssetDocument for GET/PUT responses
    - Include asset address and valuation information
    - Support multiple currencies for international assets
    - _Requirements: 4.1, 4.2, 4.5, 9.1, 9.2_

  - [ ] 7.3 Implement Assets converter
    - Handle asset type enum conversions
    - Map asset addresses using address providers
    - Convert monetary values with currency support
    - Handle ownership percentage calculations
    - _Requirements: 4.1, 4.2, 4.5, 9.1_

  - [ ]* 7.4 Write property test for Assets converter
    - **Property 4: Asset valuation consistency**
    - **Validates: Requirements 4.1, 4.2**

  - [ ] 7.5 Create Assets validator
    - Validate asset values and currencies
    - Ensure ownership percentages sum correctly for joint assets
    - Validate asset-specific required fields
    - Check valuation date consistency
    - _Requirements: 4.1, 4.2, 4.3, 10.1_

  - [ ] 7.6 Implement Assets resource
    - Add transaction and event publishing attributes
    - Support asset valuation history
    - Handle asset income calculations
    - Implement asset filtering and categorization
    - _Requirements: 4.1, 4.2, 4.3, 4.4_

  - [ ] 7.7 Create Assets controller
    - Implement GET /v2/factfinds/{id}/assets/assets
    - Support filtering by asset type and ownership
    - Implement POST for creating new assets
    - Implement PUT for updating assets
    - Implement DELETE for removing assets
    - _Requirements: 4.1, 4.2, 4.3, 9.1, 9.2_

  - [ ]* 7.8 Write integration tests for Assets API
    - Test asset CRUD operations
    - Test asset valuation tracking
    - Test ownership calculations
    - Test asset filtering and categorization
    - _Requirements: 4.1, 4.2, 4.3, 4.4_

- [ ] 8. Liabilities Management APIs
  - [ ] 8.1 Implement Liabilities domain entity
    - Create Liability entity with comprehensive debt information
    - Add NHibernate mapping for various liability types
    - Support secured and unsecured liabilities
    - Include repayment schedule information
    - Track liability ownership (individual/joint)
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

  - [ ] 8.2 Create Liabilities API contracts
    - BaseLiabilityDocument for shared properties
    - CreateLiabilityDocument for POST operations
    - LiabilityDocument for GET/PUT responses
    - Include repayment schedule information
    - Support multiple currencies for international liabilities
    - _Requirements: 5.1, 5.2, 5.5, 9.1, 9.2_

  - [ ] 8.3 Implement Liabilities converter
    - Handle liability type enum conversions
    - Convert interest rates as decimal percentages
    - Map repayment schedules with proper date formatting
    - Handle currency conversions for international debts
    - _Requirements: 5.1, 5.2, 5.5, 9.1_

  - [ ]* 8.4 Write property test for Liabilities converter
    - **Property 5: Liability payment calculations**
    - **Validates: Requirements 5.3, 5.4**

  - [ ] 8.5 Create Liabilities validator
    - Validate liability amounts and interest rates
    - Ensure repayment dates are consistent
    - Validate liability-specific required fields
    - Check affordability impact calculations
    - _Requirements: 5.1, 5.2, 5.4, 10.1_

  - [ ] 8.6 Implement Liabilities resource
    - Add transaction and event publishing attributes
    - Support liability payment calculations
    - Handle affordability assessments
    - Implement liability categorization
    - _Requirements: 5.1, 5.2, 5.3, 5.4_

  - [ ] 8.7 Create Liabilities controller
    - Implement GET /v2/factfinds/{id}/liabilities/liabilities
    - Support filtering by liability type and status
    - Implement POST for creating new liabilities
    - Implement PUT for updating liabilities
    - Implement DELETE for removing liabilities
    - _Requirements: 5.1, 5.2, 5.3, 9.1, 9.2_

  - [ ]* 8.8 Write integration tests for Liabilities API
    - Test liability CRUD operations
    - Test repayment calculations
    - Test affordability assessments
    - Test liability categorization
    - _Requirements: 5.1, 5.2, 5.3, 5.4_

- [ ] 9. Checkpoint - Assets and Liabilities APIs Complete
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 10. Budget Management APIs
  - [ ] 10.1 Implement Income domain entities
    - Create Income entity with detailed breakdown support
    - Add NHibernate mapping for various income types
    - Support multiple income frequencies
    - Include gross and net income calculations
    - Track income history and changes
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

  - [ ] 10.2 Create Income API contracts
    - BaseIncomeDocument for shared properties
    - CreateIncomeDocument for POST operations
    - IncomeDocument for GET/PUT responses
    - Include income breakdown and summary information
    - Support affordability calculations
    - _Requirements: 6.1, 6.2, 6.3, 9.1, 9.2_

  - [ ] 10.3 Implement Income converter
    - Handle income type enum conversions
    - Convert income frequencies and amounts
    - Calculate gross/net income relationships
    - Map income breakdown structures
    - _Requirements: 6.1, 6.2, 6.3, 9.1_

  - [ ]* 10.4 Write property test for Income calculations
    - **Property 6: Income calculation consistency**
    - **Validates: Requirements 6.2, 6.3**

  - [ ] 10.5 Implement Expenditure domain entities
    - Create Expenditure entity with categorization
    - Add NHibernate mapping for expense categories
    - Support essential vs lifestyle expenditure
    - Include expenditure frequency handling
    - Track expenditure history
    - _Requirements: 6.2, 6.3, 6.4, 6.5_

  - [ ] 10.6 Create Expenditure API contracts
    - BaseExpenditureDocument for shared properties
    - CreateExpenditureDocument for POST operations
    - ExpenditureDocument for GET/PUT responses
    - Include expenditure categorization
    - Support budget summary calculations
    - _Requirements: 6.2, 6.3, 9.1, 9.2_

  - [ ] 10.7 Implement Budget resource with affordability calculations
    - Add transaction and event publishing attributes
    - Calculate surplus/deficit from income and expenditure
    - Support affordability assessments
    - Handle budget requirement tracking
    - _Requirements: 6.2, 6.3, 6.4, 6.5_

  - [ ] 10.8 Create Budget controller endpoints
    - Implement GET /v2/factfinds/{id}/budget/income
    - Implement GET /v2/factfinds/{id}/budget/expenditure
    - Implement GET /v2/factfinds/{id}/budget/affordability
    - Support income and expenditure CRUD operations
    - Include budget summary calculations
    - _Requirements: 6.1, 6.2, 6.3, 9.1, 9.2_

  - [ ]* 10.9 Write integration tests for Budget APIs
    - Test income and expenditure management
    - Test affordability calculations
    - Test budget summary generation
    - Test expenditure categorization
    - _Requirements: 6.1, 6.2, 6.3, 6.4_

- [ ] 11. Investment Management APIs
  - [ ] 11.1 Implement Investment domain entities
    - Create InvestmentObjective entity with goal tracking
    - Create RiskProfile entity with questionnaire support
    - Add NHibernate mappings for investment data
    - Support attitude to risk (ATR) assessments
    - Include investment requirement tracking
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5_

  - [ ] 11.2 Create Investment API contracts
    - BaseInvestmentDocument for shared properties
    - CreateInvestmentObjectiveDocument for POST operations
    - InvestmentObjectiveDocument for GET/PUT responses
    - RiskProfileDocument for risk assessment data
    - Include investment timeline and target information
    - _Requirements: 7.1, 7.2, 7.3, 9.1, 9.2_

  - [ ] 11.3 Implement Investment converter
    - Handle investment objective enum conversions
    - Convert risk scores and categories
    - Map investment timelines with proper date formatting
    - Handle target amounts with currency support
    - _Requirements: 7.1, 7.2, 7.3, 9.1_

  - [ ]* 11.4 Write property test for Investment objectives
    - **Property 7: Investment objective consistency**
    - **Validates: Requirements 7.1, 7.2**

  - [ ] 11.5 Create Investment validator
    - Validate investment objectives and timelines
    - Ensure risk profile consistency
    - Validate target amounts and dates
    - Check investment requirement completeness
    - _Requirements: 7.1, 7.2, 7.3, 10.1_

  - [ ] 11.6 Implement Investment resource
    - Add transaction and event publishing attributes
    - Support risk profiling workflows
    - Handle investment objective management
    - Implement ATR template management
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5_

  - [ ] 11.7 Create Investment controller endpoints
    - Implement GET /v2/factfinds/{id}/investment/investment-needs
    - Implement GET /v2/factfinds/{id}/investment/risk-profile
    - Support investment objective CRUD operations
    - Include risk questionnaire endpoints
    - _Requirements: 7.1, 7.2, 7.3, 9.1, 9.2_

  - [ ]* 11.8 Write integration tests for Investment APIs
    - Test investment objective management
    - Test risk profiling workflows
    - Test ATR assessments
    - Test investment requirement tracking
    - _Requirements: 7.1, 7.2, 7.3, 7.4_

- [ ] 12. Notes and Documentation APIs
  - [ ] 12.1 Implement Notes domain entity
    - Create Note entity with rich text support
    - Add NHibernate mapping for note attachments
    - Support notes for all FactFind sections
    - Include note versioning and audit trails
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5_

  - [ ] 12.2 Create Notes API contracts
    - BaseNoteDocument for shared properties
    - CreateNoteDocument for POST operations
    - NoteDocument for GET/PUT responses
    - Include rich text formatting support
    - Support document disclosure tracking
    - _Requirements: 8.1, 8.2, 8.3, 9.1, 9.2_

  - [ ] 12.3 Implement Notes resource and controller
    - Add transaction and event publishing attributes
    - Support notes for all FactFind sections
    - Handle document disclosure requirements
    - Implement note search and filtering
    - Create endpoints for note management
    - _Requirements: 8.1, 8.2, 8.3, 8.4_

  - [ ]* 12.4 Write integration tests for Notes API
    - Test note CRUD operations
    - Test rich text formatting
    - Test document disclosure tracking
    - Test note audit trails
    - _Requirements: 8.1, 8.2, 8.3, 8.5_

- [ ] 13. API Security and Performance Implementation
  - [ ] 13.1 Implement comprehensive authentication and authorization
    - Configure token-based authentication
    - Implement scope-based authorization
    - Add multi-tenant data isolation
    - Include audit logging for sensitive operations
    - _Requirements: 10.1, 10.2, 10.3, 10.4_

  - [ ] 13.2 Implement API performance optimizations
    - Add response caching for reference data
    - Implement efficient pagination for large datasets
    - Optimize database queries with proper includes
    - Add response compression
    - _Requirements: 12.1, 12.2, 12.3, 12.4, 12.5_

  - [ ]* 13.3 Write performance tests
    - Test API response times under load
    - Test concurrent access scenarios
    - Test large dataset handling
    - Test caching effectiveness
    - _Requirements: 12.1, 12.2, 12.3_

- [ ] 14. Migration Support and Backward Compatibility
  - [ ] 14.1 Implement legacy controller compatibility layer
    - Create adapter services for legacy integration
    - Implement data migration utilities
    - Add feature flags for gradual migration
    - Include legacy endpoint deprecation notices
    - _Requirements: 11.1, 11.2, 11.3, 11.4, 11.5_

  - [ ] 14.2 Create migration documentation and tools
    - Write comprehensive API migration guides
    - Create data migration scripts
    - Implement API versioning strategy
    - Add migration validation tools
    - _Requirements: 11.1, 11.2, 11.3, 11.5_

  - [ ]* 14.3 Write migration tests
    - Test data integrity during migration
    - Test backward compatibility scenarios
    - Test gradual migration workflows
    - Test legacy adapter functionality
    - _Requirements: 11.1, 11.2, 11.3_

- [ ] 15. Final Integration and Documentation
  - [ ] 15.1 Complete API documentation
    - Finalize comprehensive Swagger documentation
    - Create interactive API explorer
    - Write developer integration guides
    - Include code examples in multiple languages
    - _Requirements: 9.6, 9.7, 9.8_

  - [ ] 15.2 Implement comprehensive error handling
    - Ensure consistent error response formats
    - Add correlation IDs for all requests
    - Implement proper HTTP status code usage
    - Include structured error responses
    - _Requirements: 9.4, 9.7, 10.4_

  - [ ]* 15.3 Write end-to-end integration tests
    - Test complete FactFind workflows
    - Test cross-resource relationships
    - Test error handling scenarios
    - Test performance under realistic loads
    - _Requirements: 9.1, 9.2, 9.3, 12.1_

- [ ] 16. Final Checkpoint - Complete API Implementation
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation and user feedback
- Property tests validate universal correctness properties
- Unit tests validate specific examples and edge cases
- Integration tests validate end-to-end API functionality
- The implementation follows the established Monolith.FactFind patterns
- All APIs follow Intelliflo API Design Guidelines 2.0
- Comprehensive testing ensures reliability and maintainability