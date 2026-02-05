 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPlanType2WrapperCategory
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '43B36C7A-321E-454F-91A3-8B64F023ABFB'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPlanType2WrapperCategory ON; 
 
        INSERT INTO TRefPlanType2WrapperCategory([RefPlanType2WrapperCategoryId], [RefPlanType2ProdSubTypeId], [PlanName], [WrapperCategory])
        SELECT 1,142, 'ISA Cash', 'ISA' UNION ALL 
        SELECT 2,1, 'ISA Maxi', 'ISA' UNION ALL 
        SELECT 3,118, 'ISA Maxi/Mini Transfer', 'ISA' UNION ALL 
        SELECT 4,2, 'ISA Mini Cash', 'ISA' UNION ALL 
        SELECT 5,4, 'ISA Mini Equity', 'ISA' UNION ALL 
        SELECT 6,3, 'ISA Mini Insurance', 'ISA' UNION ALL 
        SELECT 7,141, 'ISA Stocks And Shares', 'ISA' UNION ALL 
        SELECT 8,5, 'ISA Tessa Only', 'ISA' UNION ALL 
        SELECT 9,125, 'Cash Account ', 'Cash and Savings' UNION ALL 
        SELECT 10,30, 'Cash Deposit ', 'Cash and Savings' UNION ALL 
        SELECT 11,79, 'Savings Account ', 'Cash and Savings' UNION ALL 
        SELECT 12,102, 'Child Trust Fund ', 'Investments' UNION ALL 
        SELECT 13,1017, 'Collective Investment Account ', 'Investments' UNION ALL 
        SELECT 14,120, 'Debenture ', 'Investments' UNION ALL 
        SELECT 15,50, 'Discretionary Managed Service ', 'Investments' UNION ALL 
        SELECT 16,66, 'Endowment ', 'Investments' UNION ALL 
        SELECT 17,86, 'Equity Holdings ', 'Investments' UNION ALL 
        SELECT 18,1031, 'Exempt Property Unit Trust ', 'Investments' UNION ALL 
        SELECT 19,44, 'Friendly Society Savings ', 'Investments' UNION ALL 
        SELECT 20,51, 'Geared Investments ', 'Investments' UNION ALL 
        SELECT 21,144, 'General Investment Account ', 'Investments' UNION ALL 
        SELECT 22,52, 'Guaranteed Growth Bond ', 'Investments' UNION ALL 
        SELECT 23,53, 'Guaranteed Income Bond ', 'Investments' UNION ALL 
        SELECT 24,116, 'Hedge Fund ', 'Investments' UNION ALL 
        SELECT 25,33, 'Insurance / Investment Bond ', 'Investments' UNION ALL 
        SELECT 26,1020, 'Insurance / Investment Bond Distribution', 'Investments' UNION ALL 
        SELECT 27,1019, 'Insurance / Investment Bond With Profits', 'Investments' UNION ALL 
        SELECT 28,32, 'Investment Trust ', 'Investments' UNION ALL 
        SELECT 29,1045, 'Life Settlement Fund ', 'Investments' UNION ALL 
        SELECT 30,43, 'Maximum Investment Plan ', 'Investments' UNION ALL 
        SELECT 31,34, 'National Savings ', 'Investments' UNION ALL 
        SELECT 32,1044, 'National Savings Child Bonus Bond', 'Investments' UNION ALL 
        SELECT 33,1043, 'National Savings Fixed Interest Certificate', 'Investments' UNION ALL 
        SELECT 34,1041, 'National Savings Guaranteed Equity Bond', 'Investments' UNION ALL 
        SELECT 35,1042, 'National Savings Index Linked Certificate', 'Investments' UNION ALL 
        SELECT 36,1040, 'National Savings National Savings Certificate', 'Investments' UNION ALL 
        SELECT 37,1039, 'National Savings Premium Bonds', 'Investments' UNION ALL 
        SELECT 38,90, 'Non-Discretionary Managed Service ', 'Investments' UNION ALL 
        SELECT 39,31, 'OEIC / Unit Trust ', 'Investments' UNION ALL 
        SELECT 40,48, 'Offshore Bond ', 'Investments' UNION ALL 
        SELECT 41,47, 'Offshore Deposit ', 'Investments' UNION ALL 
        SELECT 42,46, 'Offshore OEIC / Fund ', 'Investments' UNION ALL 
        SELECT 43,45, 'Offshore Regular Savings ', 'Investments' UNION ALL 
        SELECT 44,101, 'Offshore Savings Plan ', 'Investments' UNION ALL 
        SELECT 45,36, 'Personal Equity Plan ', 'Investments' UNION ALL 
        SELECT 46,1026, 'Regular Savings Plan ', 'Investments' UNION ALL 
        SELECT 47,1025, 'Share Incentive Plan ', 'Investments' UNION ALL 
        SELECT 48,1024, 'Share Save Scheme ', 'Investments' UNION ALL 
        SELECT 49,1030, 'SICAV ', 'Investments' UNION ALL 
        SELECT 50,89, 'Structured Plan ', 'Investments' UNION ALL 
        SELECT 51,1047, 'Structured Plan Deposit', 'Investments' UNION ALL 
        SELECT 52,1046, 'Structured Plan Medium Term Note', 'Investments' UNION ALL 
        SELECT 53,35, 'TESSA ', 'Investments' UNION ALL 
        SELECT 54,49, 'Traded Endowment Plan ', 'Investments' UNION ALL 
        SELECT 55,119, 'Unregulated Collective Investments ', 'Investments' UNION ALL 
        SELECT 56,37, 'Venture Capital Trust ', 'Investments' UNION ALL 
        SELECT 57,143, 'Wrap ', 'Investments' UNION ALL 
        SELECT 58,105, 'Alternatively Secured Pension Plan ', 'Pension' UNION ALL 
        SELECT 59,9, 'Appropriate Personal Pension ', 'Pension' UNION ALL 
        SELECT 60,18, 'AVC ', 'Pension' UNION ALL 
        SELECT 61,16, 'CIMP & COMP ', 'Pension' UNION ALL 
        SELECT 62,107, 'COMP ', 'Pension' UNION ALL 
        SELECT 63,1005, 'Deferred SIPP ', 'Pension' UNION ALL 
        SELECT 64,1036, 'EFRBS ', 'Pension' UNION ALL 
        SELECT 65,11, 'Executive Pension Plan ', 'Pension' UNION ALL 
        SELECT 66,22, 'Final Salary Scheme ', 'Pension' UNION ALL 
        SELECT 67,19, 'FSAVC ', 'Pension' UNION ALL 
        SELECT 68,20, 'FURBS ', 'Pension' UNION ALL 
        SELECT 69,129, 'Group CIMP ', 'Pension' UNION ALL 
        SELECT 70,130, 'Group COMP ', 'Pension' UNION ALL 
        SELECT 71,1038, 'Group Dependants Pension ', 'Pension' UNION ALL 
        SELECT 72,131, 'Group Final Salary ', 'Pension' UNION ALL 
        SELECT 73,1051, 'Group Offshore Pension Scheme ', 'Pension' UNION ALL 
        SELECT 74,15, 'Group Personal Pension ', 'Pension' UNION ALL 
        SELECT 75,132, 'Group S32 Buyout Bond ', 'Pension' UNION ALL 
        SELECT 76,1006, 'Group SIPP ', 'Pension' UNION ALL 
        SELECT 77,1004, 'Immediate Vesting Personal Pension (IVPP) ', 'Pension' UNION ALL 
        SELECT 78,76, 'Money Purchase Contracted ', 'Pension' UNION ALL 
        SELECT 79,25, 'Offshore Pension ', 'Pension' UNION ALL 
        SELECT 80,28, 'Pension Annuity ', 'Pension' UNION ALL 
        SELECT 81,1012, 'Pension Annuity Conventional', 'Pension' UNION ALL 
        SELECT 82,1011, 'Pension Annuity Flexible', 'Pension' UNION ALL 
        SELECT 83,1033, 'Pension Annuity Impaired Life', 'Pension' UNION ALL 
        SELECT 84,1013, 'Pension Annuity Temporary', 'Pension' UNION ALL 
        SELECT 85,1010, 'Pension Annuity Unit Linked', 'Pension' UNION ALL 
        SELECT 86,1009, 'Pension Annuity With Profits', 'Pension' UNION ALL 
        SELECT 87,27, 'Pension Fund Withdrawal ', 'Pension' UNION ALL 
        SELECT 88,8, 'Personal Pension Plan ', 'Pension' UNION ALL 
        SELECT 89,26, 'Phased Retirement ', 'Pension' UNION ALL 
        SELECT 90,1001, 'PIA Non Protected Rights', 'Pension' UNION ALL 
        SELECT 91,1000, 'PIA Protected Rights', 'Pension' UNION ALL 
        SELECT 92,145, 'QROPS ', 'Pension' UNION ALL 
        SELECT 93,7, 's226 RAC ', 'Pension' UNION ALL 
        SELECT 94,13, 's32 Buyout Bond ', 'Pension' UNION ALL 
        SELECT 95,6, 'SIPP ', 'Pension' UNION ALL 
        SELECT 96,12, 'SSAS ', 'Pension' UNION ALL 
        SELECT 97,10, 'Stakeholder Individual ', 'Pension' UNION ALL 
        SELECT 98,17, 'Stakeholder Pension Group ', 'Pension' UNION ALL 
        SELECT 99,14, 'Trustee Investment Plan ', 'Pension' UNION ALL 
        SELECT 100,117, 'Unsecured Pension ', 'Pension' UNION ALL 
        SELECT 101,21, 'UURBS ', 'Pension' UNION ALL 
        SELECT 104,1019, 'Insurance / Investment Bond With Profits', 'Investments' UNION ALL 
        SELECT 105,37, 'Venture Capital Trust ', 'Investments' 
 
        SET IDENTITY_INSERT TRefPlanType2WrapperCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '43B36C7A-321E-454F-91A3-8B64F023ABFB', 
         'Initial load (103 total rows, file 1 of 1) for table TRefPlanType2WrapperCategory',
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
-- #Rows Exported: 103
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
