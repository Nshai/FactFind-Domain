 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefSectionAdvice
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6B4E8B29-227E-4A8F-B253-CF552D98A854'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefSectionAdvice ON; 
 
        INSERT INTO TRefSectionAdvice([RefSectionAdviceId], [SectionIdentifier], [Mortgage], [Protection], [Retirement], [Investment], [Estate], [Always], [ConcurrencyId])
        SELECT 1, 'Person',1,1,1,1,1,1,1 UNION ALL 
        SELECT 2, 'Dependants',1,1,1,1,1,1,1 UNION ALL 
        SELECT 3, 'ID Verification',1,1,1,1,1,1,1 UNION ALL 
        SELECT 4, 'Address',1,1,1,1,1,1,1 UNION ALL 
        SELECT 5, 'Contacts',1,1,1,1,1,1,1 UNION ALL 
        SELECT 6, 'DataProtection',1,1,1,1,1,1,1 UNION ALL 
        SELECT 7, 'Adviceareas',1,1,1,1,1,1,1 UNION ALL 
        SELECT 8, 'ProfileNotes',1,1,1,1,1,1,1 UNION ALL 
        SELECT 9, 'ProfessionalContact',1,1,1,1,1,1,1 UNION ALL 
        SELECT 10, 'BudgetIncome',1,1,1,1,1,1,1 UNION ALL 
        SELECT 11, 'Detailedincomebreakdown',1,1,1,1,1,1,1 UNION ALL 
        SELECT 12, 'Yourexpendituredetails',1,1,1,1,1,1,1 UNION ALL 
        SELECT 13, 'Affordability',1,1,1,1,1,1,1 UNION ALL 
        SELECT 14, 'AssetsQuestion',1,1,1,1,1,1,1 UNION ALL 
        SELECT 15, 'Assets',1,1,1,1,1,1,1 UNION ALL 
        SELECT 16, 'AssetsNonDisclosure',1,1,1,1,1,1,1 UNION ALL 
        SELECT 17, 'LiabilitiesQuestion',1,1,1,1,1,1,1 UNION ALL 
        SELECT 18, 'Liabilities',1,1,1,1,1,1,1 UNION ALL 
        SELECT 19, 'LiabilitiesNonDisclosure',1,1,1,1,1,1,1 UNION ALL 
        SELECT 20, 'BudgetNotes',1,1,1,1,1,1,1 UNION ALL 
        SELECT 21, 'ProtectionGoalsNeeds',0,1,0,0,0,0,1 UNION ALL 
        SELECT 22, 'ProtectionGoalsNeedsQuestion',0,1,0,0,0,0,1 UNION ALL 
        SELECT 23, 'PreExistingProtectionPlansQuestions',0,1,0,0,0,0,1 UNION ALL 
        SELECT 24, 'ProtectionPlans',0,1,0,0,0,0,1 UNION ALL 
        SELECT 25, 'PostExistingProtectionPlansQuestions',0,1,0,0,0,0,1 UNION ALL 
        SELECT 26, 'ProtectionNextSteps',0,1,0,0,0,0,1 UNION ALL 
        SELECT 27, 'RequireAMortgage',1,0,0,0,0,0,1 UNION ALL 
        SELECT 28, 'MortgageRequirements',1,0,0,0,0,0,1 UNION ALL 
        SELECT 29, 'AdditionalExpenses',1,0,0,0,0,0,1 UNION ALL 
        SELECT 30, 'MortgageRequireStatus',1,0,0,0,0,0,1 UNION ALL 
        SELECT 31, 'CCJExt',1,0,0,0,0,0,1 UNION ALL 
        SELECT 32, 'CCJDefault',1,0,0,0,0,0,1 UNION ALL 
        SELECT 33, 'ArrearExt',1,0,0,0,0,0,1 UNION ALL 
        SELECT 34, 'Arrears',1,0,0,0,0,0,1 UNION ALL 
        SELECT 35, 'RepossessedExt',1,0,0,0,0,0,1 UNION ALL 
        SELECT 36, 'Repossession',1,0,0,0,0,0,1 UNION ALL 
        SELECT 37, 'IVAExt',1,0,0,0,0,0,1 UNION ALL 
        SELECT 38, 'Bankruptcy',1,0,0,0,0,0,1 UNION ALL 
        SELECT 39, 'IVA',1,0,0,0,0,0,1 UNION ALL 
        SELECT 40, 'MortgagePreferences',1,0,0,0,0,0,1 UNION ALL 
        SELECT 41, 'MortgagePrefNotes',1,0,0,0,0,0,1 UNION ALL 
        SELECT 42, 'MortgageRisk',1,0,0,0,0,0,1 UNION ALL 
        SELECT 43, 'MortgageRiskNotes',1,0,0,0,0,0,1 UNION ALL 
        SELECT 44, 'ExistingProvisionExt',1,0,0,0,0,0,1 UNION ALL 
        SELECT 45, 'ExistingMortgage',1,0,0,0,0,0,1 UNION ALL 
        SELECT 46, 'MortExProvAdNotes',1,0,0,0,0,0,1 UNION ALL 
        SELECT 47, 'EquityRelease',1,0,0,0,0,0,1 UNION ALL 
        SELECT 48, 'EquityReleasePlans',1,0,0,0,0,0,1 UNION ALL 
        SELECT 49, 'EquityReleaseNotes',1,0,0,0,0,0,1 UNION ALL 
        SELECT 50, 'PropertytobeMortgagedQuestion',1,0,0,0,0,0,1 UNION ALL 
        SELECT 51, 'PropertytobeMortgaged',1,0,0,0,0,0,1 UNION ALL 
        SELECT 52, 'BuildingandContents',1,0,0,0,0,0,1 UNION ALL 
        SELECT 53, 'InsurancePlans',1,0,0,0,0,0,1 UNION ALL 
        SELECT 54, 'Checklist',1,0,0,0,0,0,1 UNION ALL 
        SELECT 55, 'RetirementObjective',0,0,1,0,0,0,1 UNION ALL 
        SELECT 56, 'RetirementGoalsNeeds',0,0,1,0,0,0,1 UNION ALL 
        SELECT 57, 'RetirementGoalsNeedsQuestion',0,0,1,0,0,0,1 UNION ALL 
        SELECT 58, 'PreExistingFinalSalaryPensionPlansQuestions',0,0,1,0,0,0,1 UNION ALL 
        SELECT 59, 'PreExistingMoneyPurchasePlansQuestions',0,0,1,0,0,0,1 UNION ALL 
        SELECT 60, 'PostExistingMoneyPurchasePlansQuestions',0,0,1,0,0,0,1 UNION ALL 
        SELECT 61, 'FinalSalaryPensionPlans',0,0,1,0,0,0,1 UNION ALL 
        SELECT 62, 'PostExistingFinalSalaryPensionPlansQuestions',0,0,1,0,0,0,1 UNION ALL 
        SELECT 63, 'MoneyPurchasePensionPlans',0,0,1,0,0,0,1 UNION ALL 
        SELECT 64, 'PostExistingMoneyPurchasePlansQuestions2',0,0,1,0,0,0,1 UNION ALL 
        SELECT 65, 'RetirementRiskProfile',0,0,1,0,0,0,1 UNION ALL 
        SELECT 66, 'RetirementNextSteps',0,0,1,0,0,0,1 UNION ALL 
        SELECT 67, 'InvestmentObjective',0,0,0,1,0,0,1 UNION ALL 
        SELECT 68, 'SavingsGoalsNeeds',0,0,0,1,0,0,1 UNION ALL 
        SELECT 69, 'PreExistingCashDepositPlansQuestions',0,0,0,1,0,0,1 UNION ALL 
        SELECT 70, 'SavingsPlans',0,0,0,1,0,0,1 UNION ALL 
        SELECT 71, 'PostExistingCashDepositPlansQuestions',0,0,0,1,0,0,1 UNION ALL 
        SELECT 72, 'PreExistingOtherInvestmentPlansQuestions',0,0,0,1,0,0,1 UNION ALL 
        SELECT 73, 'OtherInvestmentsPlans',0,0,0,1,0,0,1 UNION ALL 
        SELECT 74, 'PostExistingOtherInvestmentPlansQuestions',0,0,0,1,0,0,1 UNION ALL 
        SELECT 75, 'InvestmentRiskProfile',0,0,0,1,0,0,1 UNION ALL 
        SELECT 76, 'SavingsNextSteps',0,0,0,1,0,0,1 UNION ALL 
        SELECT 77, 'EstateGoalsNeeds',0,0,0,0,1,0,1 UNION ALL 
        SELECT 78, 'EstateCurrentPosition',0,0,0,0,1,0,1 UNION ALL 
        SELECT 79, 'EstateNextSteps',0,0,0,0,1,0,1 UNION ALL 
        SELECT 80, 'Declaration',1,1,1,1,1,1,1 UNION ALL 
        SELECT 81, 'DeclarationNotes',1,1,1,1,1,1,1 
 
        SET IDENTITY_INSERT TRefSectionAdvice OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6B4E8B29-227E-4A8F-B253-CF552D98A854', 
         'Initial load (81 total rows, file 1 of 1) for table TRefSectionAdvice',
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
-- #Rows Exported: 81
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
