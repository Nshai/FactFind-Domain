 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPlanDiscriminator
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6E2E1476-143B-4A82-91D2-87A6F4D5D4CB'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPlanDiscriminator ON; 
 
        INSERT INTO TRefPlanDiscriminator([RefPlanDiscriminatorId], [PlanDiscriminatorName], [ParentPlanDiscriminatorId])
        SELECT 1, 'Plan',NULL UNION ALL 
        SELECT 2, 'AssetPlan',1 UNION ALL 
        SELECT 3, 'ProtectionPlan',1 UNION ALL 
        SELECT 4, 'LiabilityPlan',1 UNION ALL 
        SELECT 5, 'PensionDefinedBenefitPlan',2 UNION ALL 
        SELECT 6, 'PensionContributionDrawdownPlan',2 UNION ALL 
        SELECT 7, 'AnnuityPlan',2 UNION ALL 
        SELECT 8, 'InvestmentPlan',2 UNION ALL 
        SELECT 9, 'CashBankAccountPlan',2 UNION ALL 
        SELECT 10, 'PersonalProtectionPlan',3 UNION ALL 
        SELECT 11, 'GeneralMedicalInsurancePlan',3 UNION ALL 
        SELECT 12, 'MortgagePlan',4 UNION ALL 
        SELECT 13, 'EquityReleasePlan',4 UNION ALL 
        SELECT 14, 'LoanCreditPlan',4 UNION ALL 
        SELECT 15, 'GroupProtectionPlan',3 UNION ALL 
        SELECT 16, 'LifeAssuredInvestmentPlan',2 
 
        SET IDENTITY_INSERT TRefPlanDiscriminator OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6E2E1476-143B-4A82-91D2-87A6F4D5D4CB', 
         'Initial load (16 total rows, file 1 of 1) for table TRefPlanDiscriminator',
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
-- #Rows Exported: 16
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
