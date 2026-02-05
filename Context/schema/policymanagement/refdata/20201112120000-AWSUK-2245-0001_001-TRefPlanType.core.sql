 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefPlanType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '79355563-37AF-4EA7-8DC7-87D7229AFFA0'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefPlanType ON; 
 
        INSERT INTO TRefPlanType([RefPlanTypeId], [PlanTypeName], [WebPage], [OrigoRef], [QuoteRef], [NBRef], [RetireFg], [RetireDate], [FindFg], [SchemeType], [IsWrapperFg], [AdditionalOwnersFg], [Extensible], [ConcurrencyId])
        SELECT 1, 'SIPP', NULL, NULL, NULL, NULL,0,NULL,NULL,1,1,0,NULL,3 UNION ALL 
        SELECT 2, 's226 RAC', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 3, 'Personal Pension Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 4, 'Appropriate Personal Pension', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 5, 'Stakeholder Individual', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 6, 'Executive Pension Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 7, 'SSAS', NULL, NULL, NULL, NULL,0,NULL,NULL,1,1,0,NULL,2 UNION ALL 
        SELECT 8, 's32 Buyout Bond', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 9, 'Trustee Investment Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 10, 'Group Personal Pension', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 11, 'CIMP & COMP', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 12, 'Group Stakeholder Pension', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 13, 'AVC', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 14, 'FSAVC', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 15, 'FURBS', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 16, 'UURBS', NULL, NULL, NULL, NULL,0,NULL,NULL,2,0,0,NULL,1 UNION ALL 
        SELECT 17, 'Final Salary Scheme', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 18, 'Pension Term Assurance', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 19, 'Group Death In Service', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 20, 'Offshore Pension', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 21, 'Phased Retirement', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 22, 'Pension Fund Withdrawal', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 23, 'Pension Annuity', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 24, 'Hancock Annuity', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 25, 'Cash Deposit', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 26, 'OEIC / Unit Trust', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 27, 'Investment Trust', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 28, 'Insurance / Investment Bond', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 29, 'National Savings', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 30, 'TESSA', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 31, 'ISA', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,3 UNION ALL 
        SELECT 32, 'Personal Equity Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 33, 'Venture Capital Trust', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 34, 'Enterprise Investment Scheme', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 35, 'Film Partnership', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 36, 'BES', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 37, 'Employee Benefit Trust', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 38, 'Enterprise Investment Zone Trust', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 39, 'Maximum Investment Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 40, 'Friendly Society Savings', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 41, 'Offshore Regular Savings', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 42, 'Offshore OEIC / Fund', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 43, 'Offshore Deposit', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 44, 'Offshore Bond', NULL, NULL, NULL, NULL,0,NULL,NULL,0,1,0,NULL,1 UNION ALL 
        SELECT 45, 'Traded Endowment Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 46, 'Discretionary Managed Service', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 47, 'Geared Investments', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 48, 'Guaranteed Growth Bond', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 49, 'Guaranteed Income Bond', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 50, 'Whole Of Life', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 51, 'Term Protection', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 52, 'Income Protection', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 53, 'Long Term Care', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 54, 'Accident Sickness & Unemployment Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 55, 'General Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 56, 'Annuity (Non-Pension)', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 57, 'CPB', NULL, NULL, NULL, NULL,1,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 58, 'Private Medical Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 59, 'Group PMI', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,2 UNION ALL 
        SELECT 60, 'Group Income Protection', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 61, 'Group Term', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 62, 'Endowment', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 63, 'Mortgage', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 64, 'Equity Release', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 65, 'Introducer', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 66, 'Renewal', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 70, 'Third party mortgage', NULL, NULL, NULL, NULL,1,NULL,NULL,0,0,0,NULL,2 UNION ALL 
        SELECT 71, 'Pension Contribution Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 72, 'Money Purchase Contracted', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 74, 'Group Critical Illness', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 75, 'Savings Account', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 77, 'Undetermined', NULL, NULL, NULL, NULL,1,'Apr 19 2004  3:07PM',NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 78, 'Capital Redemption Policy', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 79, 'Commercial Property Purchase Scheme', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 81, 'Residential Property Development', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 82, 'Equity Holdings', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 83, 'Personal Loan', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 84, 'Conveyancing Servicing Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 85, 'Structured Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 86, 'Non-Discretionary Managed Service', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 87, 'Offshore Savings Plan', NULL, NULL, NULL, NULL,1,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 88, 'Child Trust Fund', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 89, 'Alternatively Secured Pension Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 90, 'CIMP', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 91, 'COMP', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 92, 'Bridging Loan', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 93, 'Group Accident and Sickness', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 94, 'Accident and Sickness Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 95, 'Unemployment Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 96, 'Gift Inter Vivos', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 97, 'Dental Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 98, 'Hedge Fund', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 99, 'Unsecured Pension', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 100, 'Unregulated Collective Investments', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 101, 'Debenture', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 102, 'Commercial Finance', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 103, 'Property Partnership', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 104, 'Redundancy Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 105, 'Cash Account', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 106, 'Employee Assistance Scheme', NULL, NULL, NULL, NULL,0,NULL,NULL,2,0,0,NULL,1 UNION ALL 
        SELECT 107, 'Group CIMP', NULL, NULL, NULL, NULL,0,NULL,NULL,2,0,0,NULL,1 UNION ALL 
        SELECT 108, 'Group COMP', NULL, NULL, NULL, NULL,0,NULL,NULL,2,0,0,NULL,1 UNION ALL 
        SELECT 109, 'Group Final Salary', NULL, NULL, NULL, NULL,0,NULL,NULL,2,0,0,NULL,1 UNION ALL 
        SELECT 110, 'Group S32 Buyout Bond', NULL, NULL, NULL, NULL,0,NULL,NULL,2,0,0,NULL,1 UNION ALL 
        SELECT 111, 'Healthcare Cash Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 112, 'Will', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 113, 'Wrap', NULL, NULL, NULL, NULL,0,NULL,NULL,0,1,0,NULL,1 UNION ALL 
        SELECT 114, 'General Investment Account', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 115, 'QROPS', NULL, NULL, NULL, NULL,0,NULL,NULL,0,1,0,NULL,1 UNION ALL 
        SELECT 116, 'Group Dental Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 117, 'Group Healthcare Cash Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,2,0,0,NULL,1 UNION ALL 
        SELECT 1000, 'PIA', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1001, 'Deferred Annuity', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1002, 'Lifetime Annuity', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1003, 'Immediate Vesting Personal Pension (IVPP)', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1004, 'Deferred SIPP', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1005, 'Group SIPP', NULL, NULL, NULL, NULL,0,NULL,NULL,1,1,0,NULL,1 UNION ALL 
        SELECT 1006, 'Flexible Benefits', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1007, 'Collective Investment Account', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1008, 'Third Way Pensions', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1009, 'Share Save Scheme', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1010, 'Share Incentive Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1011, 'Regular Savings Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1012, 'Property Syndicate', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1013, 'Pre-Paid Funeral Plan', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1014, 'Enterprise Zone Syndicate', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1015, 'SICAV', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1016, 'Exempt Property Unit Trust', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1017, 'Impaired Life Annuity', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1018, 'Business Premises Renovation Allowance', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1019, 'Discounted Gift Scheme', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1020, 'EFRBS', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1021, 'Locum Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1022, 'Group Dependants Pension', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1023, 'Life Settlement Fund', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1024, 'Purchased Life Annuity', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1025, 'Property Holdings', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1026, 'Scheme Pension', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1027, 'Group Offshore Pension Scheme', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1028, 'Group Travel Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1029, 'Enhanced Pension Annuity', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1030, 'Income Drawdown', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1032, 'Relevant Life Policy', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1033, 'Junior ISA', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1034, 'Loan Note', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1035, 'Accidental Death Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1036, 'Exchange Traded Fund', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1037, 'Inheritance Tax Scheme', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1038, 'Tax Planning', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1039, 'Mortgage - Non-Regulated', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1040, 'Health Assessment', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1041, 'Individual Retirement Account', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1042, 'Equivalent Pension Benefits', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1043, 'QNUPS', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1044, 'Seed Enterprise Investment Scheme', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1048, 'Power of Attorney', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1049, 'Trust', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1050, 'Family SIPP', NULL, NULL, NULL, NULL,0,NULL,NULL,0,1,0,NULL,1 UNION ALL 
        SELECT 1051, 'Master Trust Pension', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1052, 'Defined Benefit Trustee Buy In', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1053, 'Credit Card', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1054, 'Fixed Term Annuity', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1055, 'Group Life', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1056, 'Peer to Peer Loan', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1058, 'Dependants Pension', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1060, 'Multi-benefit Protection', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1062, 'Lifetime ISA', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1064, 'Workplace Pension Scheme', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1065, 'Purchase Life Annuity', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1066, 'Retirement Trust Scheme', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1067, 'Business Property Relief Scheme', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1068, 'Personal Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1069, 'Severity Based Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1070, 'Business Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1071, 'Medical Insurance', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1072, 'Super', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1073, 'Self Managed Super Fund', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1074, 'Pension', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1075, 'Annuity', NULL, NULL, NULL, NULL,0,NULL,NULL,0,0,0,NULL,1 UNION ALL 
        SELECT 1076, 'Investment Account', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1077, 'SMA', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1081, 'Defined Benefit', NULL, NULL, NULL, NULL,0,NULL,NULL,1,0,0,NULL,1 UNION ALL 
        SELECT 1084, 'Super (Wrap)', NULL, NULL, NULL, NULL,0,NULL,NULL,1,1,0,NULL,1 
 
        SET IDENTITY_INSERT TRefPlanType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '79355563-37AF-4EA7-8DC7-87D7229AFFA0', 
         'Initial load (183 total rows, file 1 of 1) for table TRefPlanType',
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
-- #Rows Exported: 183
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
