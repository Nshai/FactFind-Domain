 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefApplication
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'DE019F56-1CEB-41AA-8C43-25590FB04D64'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefApplication ON; 
 
        INSERT INTO TRefApplication([RefApplicationId], [ApplicationName], [ApplicationShortName], [RefApplicationTypeId], [ImageName], [IsArchived], [ConcurrencyId], [AuthenticationMode])
        SELECT 1, 'Assureweb', 'AW',1, 'quotebroker_assureweb_130x32.png',0,1,1 UNION ALL 
        SELECT 2, 'Avelo Exchange', 'EW',1, 'quotebroker_aveloexchange_130x32.png',0,1,1 UNION ALL 
        SELECT 3, 'Webline', 'WL',1, 'webline.gif',1,1,1 UNION ALL 
        SELECT 4, 'Trigold', 'TG',3, 'quotebroker_trigoldcrystal_130x32.png',0,1,1 UNION ALL 
        SELECT 5, 'Axa', 'AX',2, 'quotebroker_axa_130x32.png',1,1,1 UNION ALL 
        SELECT 6, 'Mortgage Bench', 'MB',3, 'mortgagebench.gif',1,1,1 UNION ALL 
        SELECT 7, 'Third-Party Email Apps', 'EM',4, NULL,0,1,0 UNION ALL 
        SELECT 8, 'Mortgage Brain', 'MBR',3, 'quotebroker_mortgagebrain_130x32.png',0,1,1 UNION ALL 
        SELECT 9, 'Paymentshield', 'PMS',1, 'quotebroker_paymentshield_130x32.png',1,1,1 UNION ALL 
        SELECT 10, 'MTE', 'MTE',5, 'quotebroker_mortgagetradingexchange_130x32.png',0,1,1 UNION ALL 
        SELECT 13, 'Text Marketer', 'TM',7, NULL,0,1,0 UNION ALL 
        SELECT 14, 'Legal and General Bond Application', 'OLWA',6, 'quotebroker_legalandgeneral_bond_130x32.png',1,1,2 UNION ALL 
        SELECT 15, 'Legal and General Bond Illustration', 'OLWI',1, 'quotebroker_legalandgeneral_bond_130x32.png',1,1,2 UNION ALL 
        SELECT 16, 'Experian QAS', 'QAS',8, NULL,0,1,0 UNION ALL 
        SELECT 19, 'Zurich Intermediary Platform', 'ZIP',2, NULL,1,1,1 UNION ALL 
        SELECT 20, 'Legal and General Protection Application', 'CNBS',6, 'quotebroker_legalandgeneral_protection_130x32.png',0,1,2 UNION ALL 
        SELECT 21, 'Legal and General Protection Quote', 'AQSQ',1, 'quotebroker_legalandgeneral_protection_130x32.png',0,1,2 UNION ALL 
        SELECT 23, 'Gcd Online Call', 'GCD',11, NULL,0,1,0 UNION ALL 
        SELECT 24, 'Legal and General ISA/OEIC Application', 'LNGAF',6, 'quotebroker_legalandgeneral_130x32.png',1,1,3 UNION ALL 
        SELECT 25, 'GCD Batch', 'GCDBatch',12, 'quotebroker_legalandgeneral_fpf_130x32.png',1,1,0 UNION ALL 
        SELECT 26, 'FPF Batch', 'FPFBatch',12, 'quotebroker_legalandgeneral_fpf_130x32.png',1,1,0 UNION ALL 
        SELECT 27, 'Legal and General Protection Platform', 'CNBS Platform',10, 'quotebroker_legalandgeneral_protection_130x32.png',0,1,0 UNION ALL 
        SELECT 28, 'Dynamic Planner', 'DynamicPlanner',6, '',1,1,1 UNION ALL 
        SELECT 35, 'Mortgage Apply Direct', 'MORTGAGEDIRECT',5, NULL,0,1,3 UNION ALL 
        SELECT 36, 'Openwork CRM', 'OWS',13, 'crm_openwork_sync_130x32.png',0,1,0 UNION ALL 
        SELECT 38, 'Advisa Centa', 'AC',6, NULL,0,1,1 UNION ALL 
        SELECT 41, 'Dynamic Planner (SimplyBiz)', 'DynamicPlannerSB',6, '',1,1,0 UNION ALL 
        SELECT 43, 'FE Analytics', 'FE',14, NULL,0,1,1 UNION ALL 
        SELECT 44, 'Elevate', 'Elevate',6, 'quotebroker_elevate_wealth_130x32.png',0,1,1 UNION ALL 
        SELECT 45, 'Mortgage Brain Anywhere', 'MBA',3, 'quotebroker_mortgagebrainanywhere_130x32.png',0,1,1 UNION ALL 
        SELECT 46, 'Aegon Retirement Choices', 'ARC',6, 'provider_aegon_arc_100x39.png',1,1,2 UNION ALL 
        SELECT 47, 'Aegon One Retirement', 'AOR',6, 'provider_aegon_aor_100x39.png',1,1,2 UNION ALL 
        SELECT 1000, 'Standard Life', 'SLWRAP',6, 'quotebroker_standardlife_130x32.png',0,1,2 UNION ALL 
        SELECT 1110, 'Prudential', 'PruAdv',15, 'quotebroker_prudential_130x32.png',1,1,2 UNION ALL 
        SELECT 2000, 'AJ Bell Income Statement', 'AJBELLINCSTMT',15, NULL,0,1,2 UNION ALL 
        SELECT 2001, 'Cofunds Income Statement', 'COFUNDSINCSTMT',15, NULL,0,1,2 UNION ALL 
        SELECT 10135, 'Solution Builder', 'SB',1, 'quotebroker_solutionbuilder_130x32.png',1,1,1 UNION ALL 
        SELECT 10139, 'Contributions and Withdrawals Batch', 'CAW',12, NULL,0,1,0 UNION ALL 
        SELECT 10140, 'GIology', 'GIOLOGY',6, 'quotebroker_giology_130x32.png',0,1,3 UNION ALL 
        SELECT 10141, 'Annual Customer Report Batch', 'ACR',12, NULL,0,1,0 UNION ALL 
        SELECT 10142, 'AXA Wealth Elevate', 'Elevate',6, 'quotebroker_axa_wealth_130x32.png',0,1,1 UNION ALL 
        SELECT 10199, 'Aegon Cofunds', 'AR',1, 'provider_aegon_arc2_100x39.png',0,1,2 UNION ALL 
        SELECT 10200, 'Aegon AFP', 'AFP',1, 'provider_aegon_arc2_100x39.png',0,1,2 UNION ALL 
        SELECT 10201, 'Mortgage Trading Exchange', 'MTE',5, 'quotebroker_mortgagetradingexchange_130x32.png',0,1,1 
 
        SET IDENTITY_INSERT TRefApplication OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'DE019F56-1CEB-41AA-8C43-25590FB04D64', 
         'Initial load (44 total rows, file 1 of 1) for table TRefApplication',
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
-- #Rows Exported: 44
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
