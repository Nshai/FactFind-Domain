 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefProductType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '34FA3226-3806-4E1E-9486-9E3BF5762F09'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefProductType ON; 
 
        INSERT INTO TRefProductType([RefProductTypeId], [ProductTypeName], [RefProductGroupId], [RefPlanType2ProdSubTypeId], [IsArchived], [ConcurrencyId], [IntellifloCode])
        SELECT 1, 'Term',1,55,0,1, 'Trm' UNION ALL 
        SELECT 2, 'Convertible Term',1,55,0,1, 'ConTrm' UNION ALL 
        SELECT 3, 'Pension Term',1,23,0,1, 'PenTrm' UNION ALL 
        SELECT 4, 'Mortgage Protection',1,96,0,1, 'MortProt' UNION ALL 
        SELECT 5, 'Pension Mortgage Protection',1,96,0,1, 'PensMortProt' UNION ALL 
        SELECT 6, 'Family Income Benefit',1,94,0,1, 'FamInBen' UNION ALL 
        SELECT 7, 'Income Protection - Own Life',2,56,0,1, 'InProtOwnLfe' UNION ALL 
        SELECT 8, 'Income Protection - Life of Another',2,56,0,1, 'InProtLfeOther' UNION ALL 
        SELECT 9, 'Income Protection - Professional Expenses',2,56,0,1, 'InProtProExp' UNION ALL 
        SELECT 10, 'Income Protection - Key Person',2,56,0,1, 'InProtKeyPer' UNION ALL 
        SELECT 11, 'Critical Illness',3,54,0,1, 'CritIll' UNION ALL 
        SELECT 12, 'Whole of Life',3,54,0,1, 'WOL' UNION ALL 
        SELECT 13, 'Critical Illness with Whole of Life',3,54,0,1, 'CritIllWOL' UNION ALL 
        SELECT 14, 'Self employed personal pension plan',4,8,0,1, 'SlfEmpPerPen' UNION ALL 
        SELECT 15, 'Employed Personal Pension Plan',4,15,0,1, 'EmpPerPen' UNION ALL 
        SELECT 16, 'With Profits Bonds',5,33,0,1, 'WProfBnd' UNION ALL 
        SELECT 17, 'Unit Linked Bond',5,33,0,1, 'UntLinkBnd' UNION ALL 
        SELECT 18, 'Insurance / Investment Bond',5,33,0,1, 'DistBnd' UNION ALL 
        SELECT 19, 'Unit Linked And With Profit Bond',5,33,0,1, 'UntLnkProfitBnd' UNION ALL 
        SELECT 21, 'Landlord Buildings & Contents',8,98,0,1, 'LandBuildCont' UNION ALL 
        SELECT 22, 'Household Buildings & Contents',8,98,0,1, 'HseBuildCont' UNION ALL 
        SELECT 23, 'MortgageProtector',8,58,0,1, 'Mortgage Protector' UNION ALL 
        SELECT 24, 'IncomeShield',8,58,0,1, 'InShld' UNION ALL 
        SELECT 25, 'Mortgage',7,67,0,1, 'Mort' UNION ALL 
        SELECT 26, 'ISA (Cash)',9,142,0,1, 'IsaCash' UNION ALL 
        SELECT 27, 'ISA (Stocks And Shares)',9,141,0,1, 'IsaStockShares' UNION ALL 
        SELECT 28, 'General Investment Account',9,144,0,1, 'GIA' UNION ALL 
        SELECT 29, 'Term Protection - Critical Illness',10,91,0,1, 'TermProt-CritIll' UNION ALL 
        SELECT 30, 'Term Protection - Decreasing Term',10,92,0,1, 'TermProt-DecTerm' UNION ALL 
        SELECT 31, 'Term Protection - Family Income Benefit',10,94,0,1, 'TermProt-FamilyIncBen' UNION ALL 
        SELECT 34, 'Protection',10,1,0,1, '' UNION ALL 
        SELECT 35, 'OEIC / Unit Trust',9,31,0,1, 'OEIC' UNION ALL 
        SELECT 37, 'Permanent Health Insurance',10,56,0,1, 'PermHealthIns' UNION ALL 
        SELECT 38, 'Term Protection - Level',10,104,0,1, 'TermProt-Lev' UNION ALL 
        SELECT 39, 'Term Protection - Decreasing Term - CI',10,1062,0,1, 'TermProt-Dt-CI' UNION ALL 
        SELECT 40, 'Term Protection - Decreasing Term - Life & CI',10,1069,0,1, 'TermProt-DT-CI-Life' UNION ALL 
        SELECT 41, 'Term Protection - Family Income Benefit - CI',10,1070,0,1, 'TermProt-FIB-CI' UNION ALL 
        SELECT 42, 'Term Protection - Family Income Benefit - Life & CI',10,1071,0,1, 'TermProt-FIB-CI-Life' UNION ALL 
        SELECT 43, 'Term Protection - Level - Life & CI',10,1072,0,1, 'TermProt-Lev-CI-Life' UNION ALL 
        SELECT 44, 'Pensions',4,8,0,1, 'Pension' UNION ALL 
        SELECT 45, 'Bonds',5,33,0,1, 'Bond' UNION ALL 
        SELECT 46, 'Annuities',6,60,0,1, 'Annuity' UNION ALL 
        SELECT 47, 'SIPP',4,6,0,1, 'SIPP' UNION ALL 
        SELECT 48, 'Home Insurance Choices',8,59,0,1, 'HomeInsurance' UNION ALL 
        SELECT 49, 'Landlords Cover',8,59,0,1, 'LandlordsCover' UNION ALL 
        SELECT 50, 'Lifestyle Cover',8,59,0,1, 'LifestyleCover' UNION ALL 
        SELECT 51, 'General Insurance Building',8,99,0,1, 'GeneralInsuranceBuilding' UNION ALL 
        SELECT 52, 'General Insurance Contents',8,100,0,1, 'GeneralInsuranceContents' UNION ALL 
        SELECT 53, 'General Insurance Building and Contents',8,98,0,1, 'GeneralInsuranceBuildingandContents' UNION ALL 
        SELECT 54, 'General Insurance Let Property',8,1058,0,1, 'GeneralInsuranceLetProperty' UNION ALL 
        SELECT 55, 'Accident and Sickness Insurance',8,110,0,1, 'AccidentandSicknessInsurance' UNION ALL 
        SELECT 56, 'Accident Sickness and Unemployment Insurance',8,58,0,1, 'AccidentSicknessandUnemploymentInsurance' UNION ALL 
        SELECT 57, 'Unemployment Insurance',8,111,0,1, 'UnemploymentInsurance' UNION ALL 
        SELECT 58, 'Mortgage - Full Status',7,148,0,1, 'MortFull' UNION ALL 
        SELECT 59, 'Mortgage - Non Status',7,149,0,1, 'MortNonS' UNION ALL 
        SELECT 60, 'Mortgage - Self Cert',7,150,0,1, 'MortSelf' UNION ALL 
        SELECT 61, 'Mortgage - Buy To Let',7,151,0,1, 'MortBuyT' UNION ALL 
        SELECT 62, 'Mortgage - Let To Buy',7,152,0,1, 'MortLetT' UNION ALL 
        SELECT 63, 'Mortgage - Home Purchase Plan',7,153,0,1, 'MortHome' UNION ALL 
        SELECT 64, 'Mortgage - Remortgage',7,1007,0,1, 'MortRemo' UNION ALL 
        SELECT 65, 'Mortgage - Further Advance',7,1008,0,1, 'MortFurt' UNION ALL 
        SELECT 66, 'Mortgage - Lifetime',7,1053,0,1, 'MortLife' UNION ALL 
        SELECT 67, 'Mortgage - Bridging Loan',7,1081,0,1, 'MortBrid' UNION ALL 
        SELECT 68, 'Mortgage - Council/Tenant to Buy',7,1082,0,1, 'MortCoun' UNION ALL 
        SELECT 69, 'Mortgage - Second Home',7,1083,0,1, 'MortSeco' UNION ALL 
        SELECT 70, 'Mortgage - Right to Buy',7,1085,0,1, 'MortRigh' UNION ALL 
        SELECT 71, 'Mortgage - Government Home Ownership Scheme',7,1086,0,1, 'MortGove' UNION ALL 
        SELECT 72, 'Mortgage - Shared Ownership',7,1087,0,1, 'MortShar' UNION ALL 
        SELECT 73, 'Mortgage - Standard Residential',7,1088,0,1, 'MortStan' UNION ALL 
        SELECT 74, 'Mortgage - Self-Build',7,1089,0,1, 'MortSelf' UNION ALL 
        SELECT 75, 'Mortgage - Non-Regulated - Offshore',7,1090,0,1, 'MortOffs' UNION ALL 
        SELECT 76, 'Mortgage - Non-Regulated - Overseas',7,1091,0,1, 'MortOver' UNION ALL 
        SELECT 77, 'Mortgage - Non-Regulated - Buy To Let',7,1093,0,1, 'MortBuyT' UNION ALL 
        SELECT 78, 'Mortgage - Non-Regulated - Commercial',7,1095,0,1, 'MortComm' UNION ALL 
        SELECT 79, 'Offshore Bond',5,48,0,1, 'OffshoreBond' UNION ALL 
        SELECT 80, 'Cash Account',9,125,0,1, 'CashAcc' UNION ALL 
        SELECT 81, 'Income Drawdown (Capped)',4,1056,0,1, 'IncomeDrawdownCapped' UNION ALL 
        SELECT 82, 'Income Drawdown (Flexible)',4,1055,0,1, 'IncomeDrawdownFlexible' UNION ALL 
        SELECT 83, 'Income Drawdown (Flexi-Access)',4,1111,0,1, 'IncomeDrawdownFlexiAccess' UNION ALL 
        SELECT 84, 'Multi-Benefit',19,0,0,1, 'MultiBenefit' UNION ALL 
        SELECT 104, 'Income Protection - Own Life',20,56,0,1, 'InProtOwnLfe' UNION ALL 
        SELECT 105, 'Income Protection - Life of Another',20,56,0,1, 'InProtLfeOther' UNION ALL 
        SELECT 106, 'Income Protection - Professional Expenses',20,56,0,1, 'InProtProExp' UNION ALL 
        SELECT 107, 'Income Protection - Key Person',20,56,0,1, 'InProtKeyPer' UNION ALL 
        SELECT 108, 'Cash Account',16,125,0,1, 'CashAcc' 
 
        SET IDENTITY_INSERT TRefProductType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '34FA3226-3806-4E1E-9486-9E3BF5762F09', 
         'Initial load (85 total rows, file 1 of 1) for table TRefProductType',
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
-- #Rows Exported: 85
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
