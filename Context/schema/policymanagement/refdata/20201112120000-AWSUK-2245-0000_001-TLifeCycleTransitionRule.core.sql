 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TLifeCycleTransitionRule
--    Join: 
--   Where: WHERE tenantid is null
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'B927AFC7-0AE7-477C-A9FC-15ADD510ABE1'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TLifeCycleTransitionRule ON; 
 
        INSERT INTO TLifeCycleTransitionRule([LifeCycleTransitionRuleId], [TenantId], [Name], [Code], [Description], [SpName], [ConcurrencyId], [RefLifecycleRuleCategoryId])
        SELECT 2,NULL, 'Check for Switch details', 'SWITCH', 'Checks whether the plan switch question has been answered', 'spCustomTransitionRule_Switch',1,4 UNION ALL 
        SELECT 3,NULL, 'Check for Total Regular Premium', 'REGPREM', 'Checks whether the plan has at least one regular contribution (of any amount)', 'spCustomTransitionRule_TotalRegPremium',1,4 UNION ALL 
        SELECT 4,NULL, 'Check for TQC', 'TQC', 'Checks that a TnC Coach has been assigned to the plan)', 'spCustomTransitionRule_CheckForTQC',1,4 UNION ALL 
        SELECT 5,NULL, 'Check for Total Lump Sum', 'LUMPSUM', 'Checks whether the plan has at least one lump sum contribution (of any amount)', 'spCustomTransitionRule_TotalLumpSum',1,4 UNION ALL 
        SELECT 6,NULL, 'Check for Cash Matched', 'CASHMATCHED', 'Checks that no cash has been matched to the plan', 'spCustomTransitionRule_WithdrawPolicy',1,4 UNION ALL 
        SELECT 7,NULL, 'Check for Plan Purpose', 'PLANPURPOSE', 'Checks that at least one plan purpose has been assigned to the plan (if applicable to the plan type)', 'spCustomTransitionRule_PlanPurpose',1,4 UNION ALL 
        SELECT 9,NULL, 'Check for Primary Reference (BCN)', 'PRIMARYREF', 'Checks that the all plan owners have a Primary Reference (BCN) set', 'spCustomTransitionRule_HasBCN',1,1 UNION ALL 
        SELECT 10,NULL, 'Check for Secondary Reference', 'SECONDARYREF', 'Checks that the all plan owners have a Secondary Reference set', 'spCustomTransitionRule_SecondaryRef',1,1 UNION ALL 
        SELECT 11,NULL, 'Check for Expected Commission', 'EXPECTEDCOMMS', 'Checks that expected commission has been added to the plan', 'spCustomTransitionRule_ExpectedCommission',1,4 UNION ALL 
        SELECT 12,NULL, 'Check for positive Contribution', 'POSITIVECONTRIB', 'Checks that the plan has at least one contribution with an amount greater that zero', 'spCustomTransitionRule_CheckContribution',1,4 UNION ALL 
        SELECT 13,NULL, 'Check for DOB', 'DOB', 'Checks that owner 1 has a date of birth', 'spCustomTransitionRule_CheckDOB',1,1 UNION ALL 
        SELECT 14,NULL, 'Check for Policy Number', 'POLICYNUM', 'Checks that a policy number has been entered', 'spCustomTransitionRule_CheckPolicyNumber',1,4 UNION ALL 
        SELECT 15,NULL, 'Check for Policy Start Date', 'POLSTARTDATE', 'Checks that a start date has been entered', 'spCustomTransitionRule_CheckPolicyStartDate',1,4 UNION ALL 
        SELECT 16,NULL, 'Check for Opp. Campaign Type', 'OPPCAMPAIGNTYPE', 'Checks that the most recent opportunity for the plan owners (and related clients) has a campaign type', 'spCustomTransitionRule_LatestOpportunityCampaignType',1,1 UNION ALL 
        SELECT 17,NULL, 'Check for Opp. Introducer', 'OPPINTRO', 'Checks that the most recent opportunity for the plan owners (and related clients) has an Introducer', 'spCustomTransitionRule_LatestOpportunityIntroducerName',1,3 UNION ALL 
        SELECT 18,NULL, 'Check for Opp. Identifier (Outlet Id)', 'OPPIDENTIFIER', 'Checks that the most recent opportunity for the plan owners (and related clients) has an Identifier (Outlet Id)', 'spCustomTransitionRule_LatestOpportunityOutletId',1,3 UNION ALL 
        SELECT 19,NULL, 'Check for Address', 'ADDRESS', 'Checks that all owners have an Address', 'spCustomTransitionRule_CheckAddress',1,1 UNION ALL 
        SELECT 20,NULL, 'Check Mortgage Fields', 'MORTGAGEFIELDS', 'Checks that the required mortage fields have been completed (for mortgage-type plans)', 'spCustomTransitionRule_CheckMortgageFields',1,4 UNION ALL 
        SELECT 21,NULL, 'Check for Default Address Postcode', 'POSTCODE', 'Checks that all owners have an address with a postcode', 'spCustomTransitionRule_CheckPostcode',1,1 UNION ALL 
        SELECT 22,NULL, 'Check for Scheme Members', 'SCHEMEMEMBERS', 'Checks that all members have been removed from a Scheme', 'spCustomTransitionRule_CheckSchemeMembers',1,4 UNION ALL 
        SELECT 23,NULL, 'Check for Introducer Split', 'SPLIT', 'Checks that an Introducer Split has been added to the plan', 'spCustomTransitionRule_IntroducerSplit',1,4 UNION ALL 
        SELECT 24,NULL, 'Check for client Service Status', 'CLIENTSERVICESTATUS', 'Checks that owner one of a plan has a Service Status', 'spCustomTransitionRule_CheckClientServiceStatus',1,1 UNION ALL 
        SELECT 25,NULL, 'Check for Open Plan Service Case', 'SERVICECASE', 'Checks that the plan is linked to a Service Case that is not in auto-close status', 'spCustomTransitionRule_AdviceCase',1,4 UNION ALL 
        SELECT 26,NULL, 'Check for Associated Fee', 'ASSOCIATEDFEE', 'Checks that the Fee is linked to the Plan', 'spCustomTransitionRule_CheckAssociatedFee',1,4 UNION ALL 
        SELECT 27,NULL, 'Check for National Insurance Number', 'NINUMBER', 'Checks that all owners have a National Insurance Number', 'spCustomTransitionRule_CheckNationalInsurance',1,1 UNION ALL 
        SELECT 29,NULL, 'Check for All Opportunities closed', 'OPPNOTCLOSED', 'Checks that all opportunities for all plan owners and related clients are closed', 'spCustomTransitionRule_AllOpportunitiesClosed',1,3 UNION ALL 
        SELECT 30,NULL, 'Check for Opp. Linked', 'OPPORTUNITY', 'Checks that the Opportunity is linked to the Plan', 'spCustomTransitionRule_CheckAssociatedOpportunity',1,3 UNION ALL 
        SELECT 32,NULL, 'Check for service case with binder having a final version of fact find', 'BINDERFINALDOCUMENT', 'Plan must be linked to a service case with a binder having a final version of the fact find', 'spCustomTransitionRule_CheckServiceCaseFinalDocument',1,1 UNION ALL 
        SELECT 33,NULL, 'Check for Residency Status', 'RESIDENCYSTATUS', 'Checks whether Residency Status has been selected for the plan owners', 'spCustomTransitionRule_CheckResidencyStatus',1,2 UNION ALL 
        SELECT 34,NULL, 'Check for service case with binder in ‘Ready’ or ‘Sent To Client’ status', 'BINDERREADYORSENTTOCLIENT', 'Plan must be linked to a service case with a binder in ‘Ready’ or ‘Sent To Client’ status', 'spCustomTransitionRule_CheckBinderStatuses',1,1 UNION ALL 
        SELECT 37,NULL, 'Check for fact find Adverse Credit History  fields', 'ADVERSECREDITHISTORY', 'Checks for fact find "Do you have an adverse Credit History?" response, and that Discharged Date has been populated on Bankruptcy records', 'spCustomTransitionRule_CheckAdverseCreditHistory',1,1 UNION ALL 
        SELECT 38,NULL, 'Check that mortgage plan "Income Evidenced?" checkbox is ticked', 'MORTGAGEINCOMEEVIDENCED', 'Checks that "Income Evidenced?" checkbox is ticked on the mortgage plan summary screen', 'spCustomTransitionRule_CheckIncomeEvidenced',1,4 UNION ALL 
        SELECT 39,NULL, 'Check for plan Linked Solicitor/Lenders Solicitor Used', 'MORTGAGESOLICITOR', 'Checks that there is either a linked solicitor record, OR that the Lender Solicitor Used checkbox is ticked, on the Solicitors tab of the mortgage plan', 'spCustomTransitionRule_CheckSolicitor',1,4 UNION ALL 
        SELECT 40,NULL, 'Check for Client Category', 'CLIENTCATEGORY', 'Checks whether the client category has been selected for the plan', 'spCustomTransitionRule_CheckClientType',1,1 UNION ALL 
        SELECT 41,NULL, 'Check for Plan Proposition', 'PLANPROPOSITION', 'Checks if the plan has a Proposition', 'spCustomTransitionRule_CheckPlanProposition',1,4 UNION ALL 
        SELECT 42,NULL, 'Check for Nationality', 'NATIONALITY', 'Checks whether a Nationality has been selected for the plan owners', 'spCustomTransitionRule_CheckNationality',1,1 UNION ALL 
        SELECT 45,NULL, 'Check for Title', 'TITLE', 'Checks whether a title has been added for the plan owners', 'spCustomTransitionRule_CheckTitle',1,1 UNION ALL 
        SELECT 46,NULL, 'Check for Telephone Number', 'TELEPHONE', 'Checks whether a Telephone or Mobile number has been added for the plan owners', 'spCustomTransitionRule_CheckTelephoneNumber',1,1 UNION ALL 
        SELECT 47,NULL, 'Check for Smoker Status', 'SMOKERSTATUS', 'Checks whether a Smoker Status has been selected for the plan owners', 'spCustomTransitionRule_CheckSmokerStatus',1,1 UNION ALL 
        SELECT 48,NULL, 'Check for Marital Status', 'MARITALSTATUS', 'Checks whether a Marital Status has been selected for the plan owners', 'spCustomTransitionRule_CheckMaritalStatus',1,2 UNION ALL 
        SELECT 49,NULL, 'Check for client Campaign Type and Source', 'CLIENTCAMPAIGNTYPEANDSOURCE', 'Checks  that the Campaign Type and Source fields in AWP>Clients>Details are populated, for the owner/s of the plan', 'spCustomTransitionRule_CheckClientCampaignTypeAndSource',1,1 UNION ALL 
        SELECT 51,NULL, 'Check for Plan Scheduled Valuation', 'SCHEDULEDVALUATION', 'Checks that a scheduled valuation for a plan exists where applicable', 'spCustomTransitionRule_CheckPolicyScheduledValuation',1,4 UNION ALL 
        SELECT 52,NULL, 'Check for client marketing consent', 'MARKETING', 'Checks that "Do you wish to be contacted for marketing purposes?" is answered', 'spCustomTransitionRule_CheckMarketingQuestions',1,1 UNION ALL 
        SELECT 53,NULL, 'Check for Email Address', 'EMAILADDRESS', 'Checks that the client/s has an email address', 'SpCustomTransitionRule_CheckEmailAddressExists',1,1 UNION ALL 
        SELECT 65,NULL, 'Check ID Verification Expiry Date', 'IDVERIFICATIONEXPIRYDATE', 'Checks if ID Verification has expired', 'SpCustomTransitionRule_CheckIdVerificationdHasExpired',1,1 UNION ALL 
        SELECT 66,NULL, 'Check if client is inline with the target market', 'TARGETMARKET', 'Check if client is inline with the target market', 'SpCustomTransitionRule_CheckTargetMarket',1,4 UNION ALL 
        SELECT 93,NULL, 'Check for client marketing consent date', 'CONSENTDATE', 'Check for client marketing consent date', 'SpCustomTransitionRule_CheckConsentDate',1,4 UNION ALL 
        SELECT 94,NULL, 'Check for client DPA policy', 'CLIENTPOLICYAGREEMENTEXISTS', 'Check for client Data Protection Agreement', 'SpCustomTransitionRule_CheckClientPolicyAgreementExists',1,1 UNION ALL 
        SELECT 210,NULL, 'Check for Term', 'MORTGAGETERM', 'Check for Term in mortgage plans/equity release', 'spCustomTransitionRule_CheckMortgageTerm',1,4 
 
        SET IDENTITY_INSERT TLifeCycleTransitionRule OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'B927AFC7-0AE7-477C-A9FC-15ADD510ABE1', 
         'Initial load (49 total rows, file 1 of 1) for table TLifeCycleTransitionRule',
         null, 
         getdate() )
 
   IF @starttrancount = 0
    COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH
 
 SET XACT_ABORT OFF
 SET NOCOUNT OFF
-----------------------------------------------------------------------------
-- #Rows Exported: 49
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
