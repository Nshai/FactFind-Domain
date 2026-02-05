 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefEvalueAgreementType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '41B91208-88D6-405E-8F3E-52791881AA62'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefEvalueAgreementType ON; 
 
        INSERT INTO TRefEvalueAgreementType([RefEvalueAgreementTypeId], [EvalueAgreementClass], [EvalueAgreementTypeName], [EvalueAgreementProductName], [ConcurrencyId])
        SELECT 1, 'Investment', 'PCCash', 'Cash',1 UNION ALL 
        SELECT 2, 'Investment', 'CASHISA', 'Cash ISA',1 UNION ALL 
        SELECT 3, 'Investment', 'PCOffshoreBond', 'Offshore Bond',1 UNION ALL 
        SELECT 4, 'Investment', 'PCOnshoreBond', 'Onshore Bond',1 UNION ALL 
        SELECT 5, 'Investment', 'PCUTOEIC', 'UT/OEIC',1 UNION ALL 
        SELECT 6, 'Investment', 'Investment_trust', 'Investment trust',1 UNION ALL 
        SELECT 7, 'Investment', 'Shares', 'Shares',1 UNION ALL 
        SELECT 8, 'Investment', 'Offshore_Funds', 'Offshore Funds',1 UNION ALL 
        SELECT 9, 'Investment', 'Other_investment', 'Other investment',1 UNION ALL 
        SELECT 10, 'Investment', 'Maximum_Investment_Plan', 'Maximum Investment Plan',1 UNION ALL 
        SELECT 11, 'Investment', 'exchangeTradedFunds', 'Exchange Traded Funds',1 UNION ALL 
        SELECT 12, 'Investment', 'PlatformUTsOEICs', 'Platform funds',1 UNION ALL 
        SELECT 13, 'DefinedContribution', 'PCPension', 'Personal pension',1 UNION ALL 
        SELECT 14, 'DefinedContribution', 'PCSIPP', 'SIPP',1 UNION ALL 
        SELECT 15, 'DefinedContribution', 'Income_drawdown', 'Income drawdown',1 UNION ALL 
        SELECT 16, 'Valuable', 'PCProperty', 'Property',1 UNION ALL 
        SELECT 17, 'Liability', 'mortgage', 'Mortgage',1 UNION ALL 
        SELECT 18, 'Liability', 'personalDebt', 'Personal debt',1 UNION ALL 
        SELECT 19, 'Insurance', 'critical_illness_insurance', 'Critical Illness Insurance',1 UNION ALL 
        SELECT 20, 'Insurance', 'employer_provided_critical_illness_cover', 'Employer Provided Critical Illness Cover',1 UNION ALL 
        SELECT 21, 'Insurance', 'employer_provided_death_service', 'Employer Provided Death in Service',1 UNION ALL 
        SELECT 22, 'Insurance', 'employer_provided_income_protection', 'Employer Provided Income Protection',1 UNION ALL 
        SELECT 23, 'Insurance', 'family_income_benefit', 'Family Income Benefit',1 UNION ALL 
        SELECT 24, 'Insurance', 'income_protection_insurance', 'Income Protection Insurance',1 UNION ALL 
        SELECT 25, 'Insurance', 'lump_sum_life', 'Lump Sum Life Insurance',1 UNION ALL 
        SELECT 26, 'Insurance', 'sickPay', 'Sick pay',1 UNION ALL 
        SELECT 27, 'Investment', 'PCISA', 'ISA',1 UNION ALL 
        SELECT 29, 'Insurance', 'WholeofLifeInsurance', 'Whole of Life Insurance',1 
 
        SET IDENTITY_INSERT TRefEvalueAgreementType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '41B91208-88D6-405E-8F3E-52791881AA62', 
         'Initial load (28 total rows, file 1 of 1) for table TRefEvalueAgreementType',
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
-- #Rows Exported: 28
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
