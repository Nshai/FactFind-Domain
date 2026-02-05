 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TValGating
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '50F0EA74-1BDE-4136-982C-DBCFEF2D02D3'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TValGating ON; 
 
        INSERT INTO TValGating([ValGatingId], [RefProdProviderId], [RefPlanTypeId], [ProdSubTypeId], [OrigoProductType], [OrigoProductVersion], [ValuationXSLId], [ProviderPlanTypeName], [ConcurrencyId], [ImplementationCode])
        SELECT 1460,2269,1033,1030, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',28, 'ISA',2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 1461,2269,1033,1031, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',28, 'ISA',2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 1462,1509,3,NULL, 'Pensions', NULL,NULL, 'PP',4, NULL UNION ALL 
        SELECT 1463,1509,1,NULL, 'Pensions', NULL,NULL, 'SIPP',4, NULL UNION ALL 
        SELECT 1464,1509,7,NULL, 'Pensions', NULL,NULL, 'SSAS',4, NULL UNION ALL 
        SELECT 1465,1509,22,NULL, 'Pensions', NULL,NULL, 'SSAS',4, NULL UNION ALL 
        SELECT 1466,1509,1033,1030, 'Collective Investments', NULL,NULL, 'JISA',4, NULL UNION ALL 
        SELECT 1467,1509,1033,1031, 'Collective Investments', NULL,NULL, 'JISA',4, NULL UNION ALL 
        SELECT 1468,1509,114,NULL, 'Collective Investments', NULL,NULL, 'GENERAL',4, NULL UNION ALL 
        SELECT 1469,1509,46,NULL, 'Collective Investments', NULL,NULL, 'GENERAL',4, NULL UNION ALL 
        SELECT 1470,1509,27,NULL, 'Collective Investments', NULL,NULL, 'GENERAL',4, NULL UNION ALL 
        SELECT 1471,1509,86,NULL, 'Collective Investments', NULL,NULL, 'GENERAL',4, NULL UNION ALL 
        SELECT 1472,1509,26,NULL, 'Collective Investments', NULL,NULL, 'GENERAL',4, NULL UNION ALL 
        SELECT 1473,1509,85,NULL, 'Collective Investments', NULL,NULL, 'GENERAL',4, NULL UNION ALL 
        SELECT 1474,1509,85,1024, 'Collective Investments', NULL,NULL, 'GENERAL',4, NULL UNION ALL 
        SELECT 1475,1509,85,1023, 'Collective Investments', NULL,NULL, 'GENERAL',4, NULL UNION ALL 
        SELECT 1476,1509,31,29, 'Collective Investments', NULL,NULL, 'ISA',4, NULL UNION ALL 
        SELECT 1477,1509,31,18, 'Collective Investments', NULL,NULL, 'ISA',4, NULL UNION ALL 
        SELECT 1478,1509,31,28, 'Collective Investments', NULL,NULL, 'ISA',4, NULL UNION ALL 
        SELECT 1479,1509,44,NULL, 'Bond', NULL,NULL, 'OFFSHORE',4, NULL UNION ALL 
        SELECT 1480,1509,28,NULL, 'Bond', NULL,NULL, 'OFFSHORE',4, NULL UNION ALL 
        SELECT 1481,1509,28,1012, 'Bond', NULL,NULL, 'ONSHORE',4, NULL UNION ALL 
        SELECT 1482,1509,28,1011, 'Bond', NULL,NULL, 'OFFSHORE',4, NULL UNION ALL 
        SELECT 1483,576,99,NULL, 'Pension', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 2177,2215,49,NULL, 'Bond', NULL,NULL, 'Offshore Bond',1, NULL UNION ALL 
        SELECT 2963,62,1041,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,0, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 1646,2215,89,NULL, 'Pensions', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 1648,2215,1007,NULL, 'Pensions', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1691,2482,113,NULL, 'Collective Investments', '/origo/1.3/CECIVValuationRequest.xsd',41, 'PCB',4, 'STANDARDLIFEFUNDZONE_WRAP_UP' UNION ALL 
        SELECT 2307,558,105,NULL, 'Collective Investments', 'v001.00',7, 'COFINV',2, 'COFUNDS_NU' UNION ALL 
        SELECT 181,808,3,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',8, NULL,3, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 180,558,31,4, 'ISAMini', 'v001.00',7, 'COFISA',3, 'COFUNDS_NU' UNION ALL 
        SELECT 179,558,31,1, 'ISAMaxi', 'v001.00',7, 'COFISA',3, 'COFUNDS_NU' UNION ALL 
        SELECT 178,558,32,NULL, 'PEP', 'v001.00',7, 'COFISA',3, 'COFUNDS_NU' UNION ALL 
        SELECT 176,567,42,NULL, 'Funds', '1.0',3, 'Offshore',4, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 175,567,32,NULL, 'PEP', '1.0',3, 'ConsolidatedISA',3, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 174,567,31,4, 'ISAMini', '1.0',3, 'ConsolidatedISA',3, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 173,567,31,1, 'ISAMaxi', '1.0',3, 'ConsolidatedISA',3, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 172,567,26,NULL, 'Funds', '1.0',3, 'Funds',4, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 171,2611,32,NULL, 'Other', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 169,347,28,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',4, NULL,2, 'STANDARDLIFE_BOND_UP_OG1.1' UNION ALL 
        SELECT 416,1555,28,NULL, 'Bond', NULL,NULL, 'ABBEYLIFEIB',1, NULL UNION ALL 
        SELECT 163,2611,62,NULL, 'Other', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 415,1555,75,NULL, '', NULL,NULL, 'AAFIXEDRATESAVING',1, NULL UNION ALL 
        SELECT 414,1555,114,NULL, '', NULL,NULL, '2NDGIA',1, NULL UNION ALL 
        SELECT 160,2611,50,NULL, 'Other', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 159,2611,49,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 158,2611,48,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 374,2610,26,NULL, 'OEIC / Unit Trust', '/origo/1.2/CECIVValuationRequest.xsd',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 373,2610,9,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',34, NULL,3, 'OLDMUTUALWEALTH_BOND_NU_OG1.2' UNION ALL 
        SELECT 155,2611,39,NULL, 'Other', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 153,2611,31,1, 'Other', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 152,2611,28,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 151,2611,27,NULL, 'Other', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 150,2611,26,NULL, 'Other', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 372,2610,1,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 147,2611,22,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 146,2611,21,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 289,326,28,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',24, NULL,2, 'SCOTTISHWIDOWS_BOND_UP_OG2.0' UNION ALL 
        SELECT 288,326,90,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,2, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 287,326,14,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,2, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 286,326,12,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,2, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 285,326,10,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,2, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 284,326,8,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,2, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 139,2611,14,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 138,2611,13,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 137,2611,12,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 283,326,6,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,2, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 135,2611,10,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 134,2611,9,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 133,2611,8,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 282,326,5,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,2, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 131,2611,6,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 130,2611,5,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 1443,2245,22,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',27, 'Pension Fund Withdrawal',3, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 1444,2245,21,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',27, 'Phased Retirement',3, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 1445,2245,89,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',27, 'Alternatively Secured Pension Plan',3, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 1446,2610,22,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',33, 'Pension Fund Withdrawal',4, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 1447,2610,21,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',33, 'Phased Retirement',4, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 1448,2610,89,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',33, 'Alternatively Secured Pension Plan',4, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 1449,347,22,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',15, 'Pension Fund Withdrawal',3, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 1450,347,21,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',15, 'Phased Retirement',3, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 1451,347,89,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',15, 'Alternatively Secured Pension Plan',3, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 1452,326,21,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, 'Phased Retirement',3, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 1453,326,89,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, 'Alternatively Secured Pension Plan',3, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 1454,2269,114,NULL, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',28, 'ISA',2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 1455,2269,31,29, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',28, 'ISA',2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 1456,2269,31,1, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',28, 'ISA',2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 1457,2269,31,18, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',28, 'ISA',2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 1458,2269,31,28, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',28, 'ISA',2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 1459,2269,31,4, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',28, 'ISA',2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 1826,576,22,NULL, 'Pension', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 2176,2288,34,NULL, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 2248,556,89,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2249,556,25,NULL, 'Bond', NULL,NULL, 'Dealing Account',2, NULL UNION ALL 
        SELECT 2250,556,1004,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2251,556,88,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2252,556,4,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2253,556,1007,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2254,556,46,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2255,556,82,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2256,556,6,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2257,556,114,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2258,556,10,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2259,556,1005,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2260,556,48,NULL, 'Bond', NULL,NULL, 'Dealing Account',2, NULL UNION ALL 
        SELECT 2261,556,1030,1006, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2262,556,1030,1026, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2263,556,1030,1027, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2264,556,28,NULL, 'Bond', NULL,NULL, 'Dealing Account',2, NULL UNION ALL 
        SELECT 2265,556,28,1012, 'Bond', NULL,NULL, 'Dealing Account',2, NULL UNION ALL 
        SELECT 2266,556,28,1004, 'Bond', NULL,NULL, 'Dealing Account',2, NULL UNION ALL 
        SELECT 2267,556,28,1011, 'Bond', NULL,NULL, 'Dealing Account',2, NULL UNION ALL 
        SELECT 2268,556,31,29, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2269,556,31,1030, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2270,556,31,1, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2271,556,31,18, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2272,556,31,4, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2273,556,31,28, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2274,556,31,1031, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2275,556,86,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2276,556,26,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2277,556,44,NULL, 'Bond', NULL,NULL, 'Dealing Account',2, NULL UNION ALL 
        SELECT 2278,556,20,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2280,556,22,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2281,556,32,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2282,556,3,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2283,556,21,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2284,556,8,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2285,556,1,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2286,556,7,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2287,556,85,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2288,556,85,1024, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2289,556,85,1023, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2290,556,85,28, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2291,556,85,1031, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2292,556,9,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2293,556,100,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2294,556,99,NULL, 'Pensions', NULL,NULL, 'SIPP',2, NULL UNION ALL 
        SELECT 2295,556,33,1044, 'Collective Investments', NULL,NULL, 'UT',2, NULL UNION ALL 
        SELECT 2296,556,33,1045, 'Collective Investments', NULL,NULL, 'UT',2, NULL UNION ALL 
        SELECT 2297,556,1033,29, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2298,556,1033,1030, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2299,556,1033,28, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2300,556,1033,1031, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2301,556,85,1036, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2302,556,113,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2303,556,42,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2304,556,105,NULL, 'Bond', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2305,556,47,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2306,556,27,NULL, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2308,2611,1030,1026, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2309,2611,1030,1027, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2310,941,28,NULL, 'Insurance / Investment Bond', '3',18, NULL,1, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 2311,941,114,NULL, 'General Investment Account', '3',18, NULL,1, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 2312,941,1007,NULL, 'Collective Investment', '3',18, NULL,1, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 2313,1405,113,NULL, 'Collectives', NULL,NULL, 'Junior ISA Cash',1, NULL UNION ALL 
        SELECT 2314,1405,1030,1026, 'Collectives', NULL,NULL, 'Junior ISA Cash',1, NULL UNION ALL 
        SELECT 2315,1405,1030,1027, 'Collectives', NULL,NULL, 'Junior ISA Cash',1, NULL UNION ALL 
        SELECT 2316,183,1050,NULL, 'Pension', 'JamesHay',42, 'Family SIPP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 2317,2245,1050,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',27, 'Family SIPP',2, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2347,558,4,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2348,558,5,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2349,558,6,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2350,558,7,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2351,558,10,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2352,558,11,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2353,558,12,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2354,558,14,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2355,558,21,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2356,558,22,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2357,558,28,1011, 'Bond', 'v001.00',NULL, 'LGBOND',2, 'COFUNDS_NU' UNION ALL 
        SELECT 2358,558,28,1012, 'Bond', 'v001.00',NULL, 'LGBOND',2, 'COFUNDS_NU' UNION ALL 
        SELECT 2359,558,31,18, 'Collective Investments', 'v001.00',NULL, 'COFISA',2, 'COFUNDS_NU' UNION ALL 
        SELECT 2360,558,48,NULL, 'Bond', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2361,558,49,NULL, 'Bond', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2362,558,72,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2363,558,75,NULL, 'Collective Investments', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2364,558,78,NULL, 'Bond', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2365,558,82,NULL, 'Collective Investments', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2366,558,89,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 226,347,26,NULL, 'OEIC / Unit Trust', '/origo/1.2/CECIVValuationRequest.xsd',16, NULL,2, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 227,347,27,NULL, 'Investment Trust', '/origo/1.2/CECIVValuationRequest.xsd',16, NULL,2, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 228,576,27,NULL, 'Collective Investments', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 229,576,3,NULL, 'Pension', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 230,576,10,NULL, 'Pension', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 231,576,32,NULL, 'PEP', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 232,576,31,1, 'ISAMaxi', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 233,576,31,4, 'ISAMini', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 234,567,31,18, 'ISAMaxiTransfer', '1.0',3, 'ConsolidatedISA',3, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 235,941,1,NULL, 'SIPP', '3',18, NULL,2, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 236,941,7,NULL, 'SSAS', '3',18, NULL,2, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 237,941,9,NULL, 'Trustee Investment Plan', '3',18, NULL,2, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 238,941,31,1, 'ISAMaxi', '3',18, NULL,2, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 239,941,32,NULL, 'PEP', '3',18, NULL,2, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 240,941,44,NULL, 'Offshore Bond', '3',18, NULL,2, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 241,941,48,NULL, 'Guaranteed Growth Bond', '3',18, NULL,2, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 242,941,49,NULL, 'Guaranteed Income Bond', '3',18, NULL,2, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 243,84,14,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,3, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 244,576,46,NULL, 'Collective Investments', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 245,576,86,NULL, 'Collective Investments', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 246,576,44,NULL, 'Offshore Bond', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 247,576,8,NULL, 'Section 32 Bond', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 248,576,6,NULL, 'Executive Pension', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 249,199,3,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',19, NULL,2, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 250,199,5,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',19, NULL,2, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 251,199,10,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',19, NULL,2, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 252,199,12,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',19, NULL,2, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 253,199,14,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',19, NULL,2, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 254,199,28,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',19, NULL,2, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 255,199,48,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',19, NULL,2, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 256,199,49,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',19, NULL,2, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 362,310,2,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',32, NULL,3, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 265,395,28,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.XSD',22, NULL,2, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 266,395,31,1, 'ISAMaxi', '/origo/1.2/CECIVValuationRequest.XSD',23, NULL,2, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 267,395,31,4, 'ISAMini', '/origo/1.2/CECIVValuationRequest.XSD',23, NULL,2, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 268,395,32,NULL, 'PEP', '/origo/1.2/CECIVValuationRequest.XSD',23, NULL,2, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 277,576,114,NULL, 'Collective Investments', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 270,558,25,NULL, 'Collective Investments', 'v001.00',7, 'COFINV',3, 'COFUNDS_NU' UNION ALL 
        SELECT 271,558,28,NULL, 'Bond', 'v001.00',7, 'LGBOND',3, 'COFUNDS_NU' UNION ALL 
        SELECT 272,558,44,NULL, 'Bond', 'v001.00',7, 'CLOFB',3, 'COFUNDS_NU' UNION ALL 
        SELECT 427,1555,1,NULL, 'Pensions', NULL,NULL, 'AJBELLSIPP',1, NULL UNION ALL 
        SELECT 766,1814,27,NULL, 'Collective Investments', NULL,NULL, 'Novia GIA Gross',1, NULL UNION ALL 
        SELECT 767,1814,113,NULL, 'Collective Investments', NULL,NULL, 'Novia GIA Gross',1, NULL UNION ALL 
        SELECT 279,576,28,NULL, 'Bond', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 294,321,22,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',14, NULL,2, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 295,395,26,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.XSD',23, NULL,2, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 361,558,31,2, 'ISAMiniCash', 'v001.00',7, 'COFISA',3, 'COFUNDS_NU' UNION ALL 
        SELECT 365,310,6,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',32, NULL,3, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 366,310,10,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',32, NULL,3, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 367,310,12,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',32, NULL,3, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 368,310,14,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',32, NULL,3, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 369,310,90,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',32, NULL,3, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 370,310,28,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',32, NULL,3, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 768,1814,44,NULL, 'Bonds', NULL,NULL, 'Novia Offshore Bond',1, NULL UNION ALL 
        SELECT 379,2610,32,NULL, 'PEP', '/origo/1.2/CECIVValuationRequest.xsd',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 380,2610,44,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',34, NULL,3, 'OLDMUTUALWEALTH_BOND_NU_OG1.2' UNION ALL 
        SELECT 381,2610,3,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 832,2269,7,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',28, NULL,2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 833,2269,10,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',28, NULL,2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 762,1814,31,1, 'Collective Investments', NULL,NULL, 'Novia ISA',1, NULL UNION ALL 
        SELECT 761,1814,31,29, 'Collective Investments', NULL,NULL, 'Novia Cash ISA',1, NULL UNION ALL 
        SELECT 760,1814,31,28, 'Collective Investments', NULL,NULL, 'Novia ISA',1, NULL UNION ALL 
        SELECT 759,1814,3,NULL, 'Pensions', NULL,NULL, 'Novia SIPP Uncrystallised',1, NULL UNION ALL 
        SELECT 758,1814,1,NULL, 'Pensions', NULL,NULL, 'Novia SIPP ASP, Novia SIPP USP, Novia SIPP Uncryst',1, NULL UNION ALL 
        SELECT 191,294,49,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',9, NULL,2, 'PRUDENTIAL_PENSION_BOND_UP_OG1.2' UNION ALL 
        SELECT 190,294,48,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',9, NULL,2, 'PRUDENTIAL_PENSION_BOND_UP_OG1.2' UNION ALL 
        SELECT 189,294,10,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',9, NULL,3, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 188,294,3,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',9, NULL,3, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 187,808,2,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',8, NULL,3, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 186,808,5,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',8, NULL,3, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 185,808,28,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',8, NULL,3, 'AVIVA_BOND_OG2.1' UNION ALL 
        SELECT 184,808,49,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',8, NULL,3, 'AVIVA_BOND_OG2.1' UNION ALL 
        SELECT 183,808,48,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',8, NULL,3, 'AVIVA_BOND_OG2.1' UNION ALL 
        SELECT 182,808,10,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',8, NULL,3, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 354,62,15,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 355,567,105,NULL, 'CMA', '1.0',3, NULL,2, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 356,395,3,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',22, NULL,2, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 357,395,6,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',22, NULL,2, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 358,395,10,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',22, NULL,2, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 359,395,14,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',22, NULL,2, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 360,62,44,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 437,1555,44,NULL, 'Bond', NULL,NULL, 'ASEIOFFBND',1, NULL UNION ALL 
        SELECT 785,1019,31,1, 'Collective Investments', NULL,NULL, 'ISA Account (Stocks & Shares)',1, NULL UNION ALL 
        SELECT 786,1019,46,NULL, 'Collective Investments', NULL,NULL, 'DEALING CAPITAL ACCOUNT',1, NULL UNION ALL 
        SELECT 787,1019,26,NULL, 'Collective Investments', NULL,NULL, 'Trust Account',1, NULL UNION ALL 
        SELECT 788,1019,1,NULL, 'Pensions', NULL,NULL, 'SIPP Account',1, NULL UNION ALL 
        SELECT 789,1019,44,NULL, 'Bonds', NULL,NULL, 'Offshore Portfolio Bond',1, NULL UNION ALL 
        SELECT 790,1019,7,NULL, 'Collective Investments', NULL,NULL, 'SSAS Account',1, NULL UNION ALL 
        SELECT 791,1019,28,NULL, 'Bonds', NULL,NULL, 'DVP Account',1, NULL UNION ALL 
        SELECT 792,1019,31,18, 'Collective Investments', NULL,NULL, 'ISA Account (Stocks & Shares)',1, NULL UNION ALL 
        SELECT 793,1019,86,NULL, 'Collective Investments', NULL,NULL, 'DEALING CAPITAL ACCOUNT',1, NULL UNION ALL 
        SELECT 794,1019,113,NULL, 'Collective Investments', NULL,NULL, 'Corporate Account',1, NULL UNION ALL 
        SELECT 795,1405,1,NULL, 'Pensions', NULL,NULL, 'Pension',1, NULL UNION ALL 
        SELECT 834,2269,14,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',28, NULL,2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 835,2269,28,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',28, NULL,2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 938,567,1033,1031, 'JuniorISA', '1.0',3, 'Junior ISA Stocks And Shares',4, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 838,1543,31,28, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 839,1543,31,29, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 840,1543,31,1, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 841,1543,31,18, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 842,1543,85,NULL, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 843,1543,85,1024, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 844,1543,85,1023, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 845,1543,44,NULL, 'Bond', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 846,1543,3,NULL, 'Pension', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 847,1543,32,NULL, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 848,1543,27,NULL, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 849,1543,1007,NULL, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 850,1543,86,NULL, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 851,1543,22,NULL, 'Pension', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 852,1543,105,NULL, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 853,1543,28,NULL, 'Bond', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 939,1019,1033,1030, 'Collectives', NULL,NULL, 'Junior ISA Cash',1, NULL UNION ALL 
        SELECT 469,1555,85,NULL, '', NULL,NULL, 'BLUESKYCEIC',1, NULL UNION ALL 
        SELECT 940,1019,1033,1031, 'Collectives', NULL,NULL, 'Junior ISA Stocks And Shares',1, NULL UNION ALL 
        SELECT 471,1555,46,NULL, '', NULL,NULL, 'BREWINDISCPORT',1, NULL UNION ALL 
        SELECT 941,1405,1033,1030, 'Collectives', NULL,NULL, 'Junior ISA Cash',1, NULL UNION ALL 
        SELECT 475,1555,9,NULL, 'Pensions', NULL,NULL, 'BUCKLEBPTL',1, NULL UNION ALL 
        SELECT 6,347,3,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',15, NULL,2, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 7,347,10,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',15, NULL,2, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 8,347,48,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',4, NULL,2, 'STANDARDLIFE_BOND_UP_OG1.1' UNION ALL 
        SELECT 9,347,49,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',4, NULL,2, 'STANDARDLIFE_BOND_UP_OG1.1' UNION ALL 
        SELECT 126,2611,1,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 280,326,3,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,2, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 128,2611,3,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',1, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 281,326,4,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,2, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 177,558,26,NULL, 'Collective Investments', 'v001.00',7, 'COFINV',3, 'COFUNDS_NU' UNION ALL 
        SELECT 765,1814,26,NULL, 'Collective Investments', NULL,NULL, 'Novia GIA Net',1, NULL UNION ALL 
        SELECT 205,84,3,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,3, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 206,84,5,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,3, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 207,84,28,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',24, NULL,3, 'CLERICALMEDICAL_BOND_UP_OG2.0' UNION ALL 
        SELECT 208,84,48,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',24, NULL,3, 'CLERICALMEDICAL_BOND_UP_OG2.0' UNION ALL 
        SELECT 209,84,49,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',24, NULL,3, 'CLERICALMEDICAL_BOND_UP_OG2.0' UNION ALL 
        SELECT 210,321,3,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',14, NULL,2, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 211,321,5,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',14, NULL,2, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 212,321,6,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',14, NULL,2, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 213,321,11,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',14, NULL,2, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 214,321,10,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',14, NULL,2, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 215,321,12,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',14, NULL,2, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 216,321,14,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',14, NULL,2, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 217,321,28,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',14, NULL,2, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 218,2611,31,4, 'Other', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 219,294,28,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',9, NULL,2, 'PRUDENTIAL_PENSION_BOND_UP_OG1.2' UNION ALL 
        SELECT 220,347,1,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',15, NULL,2, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 221,347,14,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',15, NULL,2, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 223,347,32,NULL, 'PEP', '/origo/1.2/CECIVValuationRequest.xsd',16, NULL,2, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 224,347,31,1, 'ISAMaxi', '/origo/1.2/CECIVValuationRequest.xsd',16, NULL,2, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 225,347,31,4, 'ISAMini', '/origo/1.2/CECIVValuationRequest.xsd',16, NULL,2, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 988,1145,85,1024, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 989,1145,85,1023, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 990,1145,100,NULL, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 992,1145,44,NULL, 'Bond', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 993,1145,28,NULL, 'Bond', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 994,1145,28,1012, 'Bond', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 995,1145,28,1011, 'Bond', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 996,1145,22,NULL, 'Pension', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 997,1145,3,NULL, 'Pension', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 998,1145,1,NULL, 'Pension', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 999,1145,7,NULL, 'Pension', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 556,1555,39,NULL, '', NULL,NULL, 'HSBCMIP',1, NULL UNION ALL 
        SELECT 2124,901,89,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2125,901,4,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2126,901,25,NULL, 'Bond', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2127,901,88,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2128,901,1007,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2129,901,1004,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2130,901,46,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 1059,2438,113,NULL, 'Collective Investments', 'ce/v1/CEWrapValuationRequest',43, 'Aviva Wrap',9, 'AVIVAPLATFORM_WRAP_UP' UNION ALL 
        SELECT 2131,901,82,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2132,901,6,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2133,901,114,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 377,2610,31,1, 'ISAMaxi', '/origo/1.2/CECIVValuationRequest.xsd',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 297,2611,31,28, 'ISAStocksAndShares', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 378,2610,31,4, 'ISAMini', '/origo/1.2/CECIVValuationRequest.xsd',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 299,567,31,28, 'ISA', '1.0',3, NULL,3, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 300,567,31,29, 'ISA', '1.0',3, NULL,3, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 301,558,31,28, 'ISAStocksAndShares', 'v001.00',7, 'COFISA',3, 'COFUNDS_NU' UNION ALL 
        SELECT 302,558,31,29, 'ISACash', 'v001.00',7, 'COFISA',3, 'COFUNDS_NU' UNION ALL 
        SELECT 430,1555,7,NULL, 'Pensions', NULL,NULL, 'ALLTRUSTSSAS',1, NULL UNION ALL 
        SELECT 431,1555,31,28, '', NULL,NULL, 'AMAXISA',1, NULL UNION ALL 
        SELECT 305,2611,31,29, 'ISACash', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 306,347,31,28, 'ISAStocksAndShares', '/origo/1.2/CECIVValuationRequest.xsd',16, NULL,2, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 307,347,31,29, 'ISACash', '/origo/1.2/CECIVValuationRequest.xsd',16, NULL,2, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 308,576,31,28, 'ISAStocksAndShares', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 309,576,31,29, 'ISACash', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 310,941,31,28, 'ISAStocksAndShares', '3',18, NULL,2, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 311,395,31,28, 'ISAStocksAndShares', '/origo/1.2/CECIVValuationRequest.XSD',23, NULL,2, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 312,395,31,29, 'ISACash', '/origo/1.2/CECIVValuationRequest.XSD',23, NULL,2, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 315,576,26,NULL, 'Collective Investments', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 316,2245,3,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',27, NULL,3, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 317,2245,5,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',27, NULL,3, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 318,2245,6,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',27, NULL,3, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 319,2245,8,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',27, NULL,3, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 320,2245,12,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',27, NULL,3, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 321,2245,9,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',27, NULL,4, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 322,2245,28,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',27, NULL,3, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 323,2245,48,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',27, NULL,3, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 324,2245,49,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',27, NULL,3, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 822,326,1,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, 'Pension',3, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 828,2269,1,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',28, NULL,2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 824,326,1030,1027, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, 'Pension',3, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 825,326,1030,1026, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, 'Pension',3, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 829,2269,2,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',28, NULL,2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 827,326,22,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, 'Pension',3, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 830,2269,3,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',28, NULL,2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 831,2269,6,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',28, NULL,2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 333,347,5,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',15, NULL,2, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 334,347,6,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',15, NULL,2, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 337,321,21,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',14, NULL,2, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 338,84,8,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',38, NULL,3, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 341,62,2,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 342,62,3,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 343,62,6,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 344,62,14,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 345,62,28,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 346,62,48,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 347,62,49,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 348,62,62,NULL, 'Other', '/origo/2.0/CEEndowmentSingleContractRequest.xsd',31, NULL,2, 'CANADALIFE_ENDOWMENT_UP_OG2.0' UNION ALL 
        SELECT 349,62,1,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 350,62,5,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 351,62,7,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 352,62,10,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 353,62,12,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',30, NULL,2, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 1368,2313,86,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1367,2313,27,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1366,2313,46,NULL, 'Collective Investments', NULL,NULL, 'DPN',3, NULL UNION ALL 
        SELECT 1365,2313,114,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 2134,901,10,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2135,901,1005,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 666,1555,8,NULL, 'Pensions', NULL,NULL, 'PHOENIXLIFES32',1, NULL UNION ALL 
        SELECT 2136,901,48,NULL, 'Bond', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2137,901,1030,1026, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2138,901,1030,1027, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 339,84,44,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',24, NULL,3, 'CLERICALMEDICAL_BOND_UP_OG2.0' UNION ALL 
        SELECT 363,310,3,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',32, NULL,3, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 364,310,5,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',32, NULL,3, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 375,2610,27,NULL, 'Investment Trust', '/origo/1.2/CECIVValuationRequest.xsd',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 376,2610,28,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',34, NULL,3, 'OLDMUTUALWEALTH_BOND_NU_OG1.2' UNION ALL 
        SELECT 382,2610,6,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 383,2610,10,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 384,2610,8,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 385,2610,31,28, 'ISAStocksAndShares', '/origo/1.2/CECIVValuationRequest.xsd',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 386,2610,31,29, 'ISACash', '/origo/1.2/CECIVValuationRequest.xsd',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 387,2610,35,NULL, 'FilmPartnership', '/origo/1.2/CECIVValuationRequest.xsd',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 388,2610,1007,NULL, 'CollectiveInvestmentAccount', '/origo/1.2/CECIVValuationRequest.xsd',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 389,204,3,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',35, NULL,3, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 390,204,8,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',35, NULL,3, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 391,204,9,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',35, NULL,3, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 392,204,89,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',35, NULL,3, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 393,204,1,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',35, NULL,3, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 394,1543,1,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 395,1543,46,NULL, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 396,1405,114,NULL, 'Collective Investments', NULL,NULL, 'General',1, NULL UNION ALL 
        SELECT 397,1405,31,28, 'Collective Investments', NULL,NULL, 'Isa stocks and shares',1, NULL UNION ALL 
        SELECT 398,1405,32,NULL, 'Collective Investments', NULL,NULL, 'PEP (ISA)',1, NULL UNION ALL 
        SELECT 399,1405,44,NULL, 'Bond', NULL,NULL, 'Offshore bond',1, NULL UNION ALL 
        SELECT 400,1405,28,NULL, 'Bond', NULL,NULL, 'Onshore bond',1, NULL UNION ALL 
        SELECT 401,1405,3,NULL, 'Pensions', NULL,NULL, 'Pension',1, NULL UNION ALL 
        SELECT 402,1405,4,NULL, 'Pensions', NULL,NULL, 'APP',1, NULL UNION ALL 
        SELECT 403,1405,99,NULL, 'Pensions', NULL,NULL, 'Unsecured Pension',1, NULL UNION ALL 
        SELECT 404,1405,31,29, 'Collective Investments', NULL,NULL, 'Isa stocks and shares',1, NULL UNION ALL 
        SELECT 405,1405,31,1, 'Collective Investments', NULL,NULL, 'Isa stocks and shares',1, NULL UNION ALL 
        SELECT 406,1405,31,18, 'Collective Investments', NULL,NULL, 'Isa stocks and shares',1, NULL UNION ALL 
        SELECT 407,1405,31,2, 'Collective Investments', NULL,NULL, 'Isa stocks and shares',1, NULL UNION ALL 
        SELECT 408,1405,31,4, 'Collective Investments', NULL,NULL, 'Isa stocks and shares',1, NULL UNION ALL 
        SELECT 409,1405,31,3, 'Collective Investments', NULL,NULL, 'Isa stocks and shares',1, NULL UNION ALL 
        SELECT 410,1405,31,5, 'Collective Investments', NULL,NULL, 'Isa stocks and shares',1, NULL UNION ALL 
        SELECT 935,558,1033,1030, 'Collectives', 'v001.00',7, 'COFISA',3, 'COFUNDS_NU' UNION ALL 
        SELECT 936,558,1033,1031, 'Collectives', 'v001.00',7, 'COFISA',3, 'COFUNDS_NU' UNION ALL 
        SELECT 937,567,1033,1030, 'JuniorISA', '1.0',3, 'Junior ISA Cash',4, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 763,1814,31,18, 'Collective Investments', NULL,NULL, 'Novia Cash ISA',1, NULL UNION ALL 
        SELECT 782,1019,114,NULL, 'Collective Investments', NULL,NULL, 'DEALING CAPITAL ACCOUNT',1, NULL UNION ALL 
        SELECT 433,1555,3,NULL, 'Pensions', NULL,NULL, 'APA',1, NULL UNION ALL 
        SELECT 783,1019,32,NULL, 'Collective Investments', NULL,NULL, 'PEP Account',1, NULL UNION ALL 
        SELECT 784,1019,31,28, 'Collective Investments', NULL,NULL, 'ISA Account (Stocks & Shares)',1, NULL UNION ALL 
        SELECT 436,1555,32,NULL, 'Pensions', NULL,NULL, 'APEP',1, NULL UNION ALL 
        SELECT 960,878,31,2, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 961,878,31,28, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 962,878,1033,1030, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 963,878,1033,1031, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 964,878,86,NULL, 'Collective Investments', NULL,NULL, 'Non-Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 965,878,26,NULL, 'Collective Investments', NULL,NULL, 'OEIC / Unit Trust',1, NULL UNION ALL 
        SELECT 966,878,32,NULL, 'Collective Investments', NULL,NULL, 'Personal Equity Plan',1, NULL UNION ALL 
        SELECT 2139,901,28,NULL, 'Bond', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 967,878,3,NULL, 'Pensions', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 969,878,1,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 523,1555,26,NULL, 'Collective Investments', NULL,NULL, 'FCUT',1, NULL UNION ALL 
        SELECT 972,878,113,NULL, 'Collective Investments', NULL,NULL, 'Wrap',1, NULL UNION ALL 
        SELECT 973,1145,1007,NULL, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 974,1145,46,NULL, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 2140,901,28,1012, 'Bond', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 976,1145,27,NULL, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 977,1145,31,28, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 978,1145,31,29, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 979,1145,31,1, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 534,1555,62,NULL, 'Bond', NULL,NULL, 'FRIPROVEND',1, NULL UNION ALL 
        SELECT 980,1145,31,18, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 981,1145,31,4, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 982,1145,1033,1030, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 983,1145,1033,1031, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 984,1145,86,NULL, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 985,1145,26,NULL, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 986,1145,32,NULL, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 987,1145,85,NULL, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 2141,901,28,1011, 'Bond', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2142,901,31,29, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2143,901,31,1, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2144,901,31,18, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2145,901,31,4, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2146,901,31,28, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2147,901,86,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2148,901,26,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2149,901,44,NULL, 'Bond', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2150,901,20,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2504,294,1019,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'PRUDENTIAL_PENSION_BOND_UP_OG1.2' UNION ALL 
        SELECT 2152,901,22,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2153,901,32,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2154,901,3,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2155,901,21,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2156,901,8,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2157,901,1,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 1333,302,114,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1334,302,46,NULL, 'Collective Investments', NULL,NULL, 'DPN',3, NULL UNION ALL 
        SELECT 1335,302,27,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1336,302,86,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1337,302,26,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 2437,808,78,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_BOND_OG2.1' UNION ALL 
        SELECT 2438,808,1019,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_BOND_OG2.1' UNION ALL 
        SELECT 2439,808,28,1012, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_BOND_OG2.1' UNION ALL 
        SELECT 2440,808,28,1011, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_BOND_OG2.1' UNION ALL 
        SELECT 2441,808,44,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_BOND_OG2.1' UNION ALL 
        SELECT 2444,808,89,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2473,294,89,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2474,294,4,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2475,294,90,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2476,294,11,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2477,294,91,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2478,294,6,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2479,294,1050,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2480,294,14,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2481,294,107,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2482,294,108,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2483,294,110,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2511,310,89,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2512,310,4,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2513,310,11,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2505,294,28,1012, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'PRUDENTIAL_PENSION_BOND_UP_OG1.2' UNION ALL 
        SELECT 2158,901,7,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 704,1555,10,NULL, 'Pensions', NULL,NULL, 'SCWGP',1, NULL UNION ALL 
        SELECT 705,1555,1005,NULL, 'Pensions', NULL,NULL, 'SEGSIPP',1, NULL UNION ALL 
        SELECT 1397,2247,113,NULL, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1398,2247,114,NULL, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1399,2247,46,NULL, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1400,2247,27,NULL, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1401,2247,86,NULL, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1402,2247,26,NULL, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 728,1555,12,NULL, 'Pensions', NULL,NULL, 'STDLIFESTHR',1, NULL UNION ALL 
        SELECT 1403,2247,85,NULL, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1404,2247,85,1024, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1405,2247,85,1023, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1406,2247,85,1036, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1407,2247,85,1033, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1408,2247,31,29, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1409,2247,31,1, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1410,2247,31,18, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1411,2247,31,28, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1412,2247,31,4, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1413,2247,1033,1030, 'Collective Investments', NULL,NULL, 'JISA',3, NULL UNION ALL 
        SELECT 1414,2247,1033,1031, 'Collective Investments', NULL,NULL, 'JISA',3, NULL UNION ALL 
        SELECT 1415,2247,1007,NULL, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1416,2247,32,NULL, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1417,2247,75,NULL, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 1418,2247,100,NULL, 'Collective Investments', NULL,NULL, 'PIP',3, NULL UNION ALL 
        SELECT 2159,901,85,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 1420,2247,44,NULL, 'Bond', NULL,NULL, 'OFB',3, NULL UNION ALL 
        SELECT 1421,2247,28,NULL, 'Bond', NULL,NULL, 'ONB',3, NULL UNION ALL 
        SELECT 1422,2247,28,1012, 'Bond', NULL,NULL, 'ONB',3, NULL UNION ALL 
        SELECT 1423,2247,28,1011, 'Bond', NULL,NULL, 'ONB',3, NULL UNION ALL 
        SELECT 1424,2247,3,NULL, 'Pensions', NULL,NULL, 'SIPP',3, NULL UNION ALL 
        SELECT 1425,2247,1,NULL, 'Pensions', NULL,NULL, 'SIPP',3, NULL UNION ALL 
        SELECT 1426,2247,7,NULL, 'Pensions', NULL,NULL, 'SIPP',3, NULL UNION ALL 
        SELECT 753,1555,2,NULL, 'Pensions', NULL,NULL, 'WINSLIFE',1, NULL UNION ALL 
        SELECT 1427,2247,22,NULL, 'Pensions', NULL,NULL, 'SIPP',3, NULL UNION ALL 
        SELECT 1428,2247,1030,1026, 'Pensions', NULL,NULL, 'SIPP',3, NULL UNION ALL 
        SELECT 1429,2247,1030,1027, 'Pensions', NULL,NULL, 'SIPP',3, NULL UNION ALL 
        SELECT 1430,2247,99,NULL, 'Pensions', NULL,NULL, 'SIPP',3, NULL UNION ALL 
        SELECT 340,1596,113,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.XSD',29, NULL,2, 'ELEVATE_WRAP_NU' UNION ALL 
        SELECT 764,1814,114,NULL, 'Collective Investments', NULL,NULL, 'Novia GIA Net',1, NULL UNION ALL 
        SELECT 942,1405,1033,1031, 'Collectives', NULL,NULL, 'Junior ISA Stocks And Shares',1, NULL UNION ALL 
        SELECT 854,1543,28,1012, 'Bond', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 855,1543,28,1011, 'Bond', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 820,347,113,NULL, 'Collective Investments', '/origo/1.0/GetWrapValuationMTGRequest.xsd',36, NULL,2, 'STANDARDLIFE_WRAP_UP' UNION ALL 
        SELECT 856,1543,26,NULL, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 858,1543,7,NULL, 'Pension', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 859,1543,4,NULL, 'Pension', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 860,558,3,NULL, 'Pension', 'v001.00',7, 'PORTPEN',3, 'COFUNDS_NU' UNION ALL 
        SELECT 861,558,1,NULL, 'Pension', 'v001.00',7, 'COFSIPP',3, 'COFUNDS_NU' UNION ALL 
        SELECT 943,1543,1033,1030, 'Collectives', NULL,NULL, 'Junior ISA Cash',1, NULL UNION ALL 
        SELECT 944,1543,1033,1031, 'Collectives', NULL,NULL, 'Junior ISA Stocks And Shares',1, NULL UNION ALL 
        SELECT 945,1555,1033,1030, 'Collectives', NULL,NULL, 'Junior ISA Cash',1, NULL UNION ALL 
        SELECT 946,1555,1033,1031, 'Collectives', NULL,NULL, 'Junior ISA Stocks And Shares',1, NULL UNION ALL 
        SELECT 947,1814,1033,1030, 'Collectives', NULL,NULL, 'Junior ISA Cash',1, NULL UNION ALL 
        SELECT 948,1814,1033,1031, 'Collectives', NULL,NULL, 'Junior ISA Stocks And Shares',1, NULL UNION ALL 
        SELECT 949,878,1007,NULL, 'Collective Investments', NULL,NULL, 'Collective Investment Account',1, NULL UNION ALL 
        SELECT 950,878,46,NULL, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 951,878,82,NULL, 'Collective Investments', NULL,NULL, 'Equity Holdings',1, NULL UNION ALL 
        SELECT 952,878,35,NULL, 'Collective Investments', NULL,NULL, 'Film Partnership',1, NULL UNION ALL 
        SELECT 504,1555,1007,NULL, 'Collective Investments', NULL,NULL, 'COFUNDS',1, NULL UNION ALL 
        SELECT 953,878,114,NULL, 'Collective Investments', NULL,NULL, 'General Investment Account',1, NULL UNION ALL 
        SELECT 954,878,28,NULL, 'Bond', NULL,NULL, 'Insurance / Investment Bond',1, NULL UNION ALL 
        SELECT 956,878,27,NULL, 'Collective Investments', NULL,NULL, 'Investment Trust',1, NULL UNION ALL 
        SELECT 957,878,31,29, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 958,878,31,1, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 959,878,31,18, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 1338,302,85,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1339,302,85,1024, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 602,1555,5,NULL, 'Pensions', NULL,NULL, 'LGSHPENS',1, NULL UNION ALL 
        SELECT 1340,302,85,1023, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1341,302,85,1036, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1342,302,85,1033, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1343,302,31,29, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1344,302,31,1, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1345,302,31,18, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 609,1555,115,NULL, '', NULL,NULL, 'MCQROPS',1, NULL UNION ALL 
        SELECT 1346,302,31,28, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1347,302,31,4, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1348,302,1033,1030, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1349,302,1033,1031, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1350,302,1007,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1351,302,32,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1352,302,75,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1353,302,100,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1355,302,44,NULL, 'Bond', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1356,302,28,NULL, 'Bond', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1357,302,28,1012, 'Bond', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1358,302,28,1011, 'Bond', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1359,302,3,NULL, 'Pensions', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1360,302,1,NULL, 'Pensions', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1361,302,7,NULL, 'Pensions', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1362,302,22,NULL, 'Pensions', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1363,302,1030,1026, 'Pensions', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1364,302,1030,1027, 'Pensions', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1438,2334,113,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest_ZIP.XSD',37, '',2, 'ZURICHINTERMEDIARYPLATFORM_WRAP_NU' UNION ALL 
        SELECT 1396,2313,1030,1027, 'Pensions', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1395,2313,1030,1026, 'Pensions', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1394,2313,22,NULL, 'Pensions', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1393,2313,7,NULL, 'Pensions', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1392,2313,1,NULL, 'Pensions', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1391,2313,3,NULL, 'Pensions', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1390,2313,28,1011, 'Bond', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1389,2313,28,1012, 'Bond', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1388,2313,28,NULL, 'Bond', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 1387,2313,44,NULL, 'Bond', NULL,NULL, 'PENSION',3, NULL UNION ALL 
        SELECT 641,1555,13,NULL, 'Pensions', NULL,NULL, 'NHSAVCP',1, NULL UNION ALL 
        SELECT 1385,2313,100,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1384,2313,75,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1383,2313,32,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1382,2313,1007,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1381,2313,1033,1031, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1380,2313,1033,1030, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1379,2313,31,4, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1378,2313,31,28, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1377,2313,31,18, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1376,2313,31,1, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1375,2313,31,29, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1374,2313,85,1033, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1373,2313,85,1036, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1372,2313,85,1023, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1371,2313,85,1024, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1370,2313,85,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1369,2313,26,NULL, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 1486,183,89,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1488,183,4,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1489,183,1007,NULL, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1490,183,1004,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1491,183,46,NULL, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1492,183,82,NULL, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1493,183,6,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1494,183,114,NULL, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1495,183,10,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1496,183,1005,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1497,183,48,NULL, 'Bond', 'JamesHay',42, 'OFB',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1498,183,1030,1027, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1499,183,1030,1026, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1500,183,28,NULL, 'Bond', 'JamesHay',42, 'OFB',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1501,183,28,1012, 'Bond', 'JamesHay',42, 'OFB',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1502,183,28,1011, 'Bond', 'JamesHay',42, 'OFB',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1503,183,27,NULL, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1504,183,31,29, 'Collective Investments', 'JamesHay',42, 'CISA',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1505,183,31,1, 'Collective Investments', 'JamesHay',42, 'CISA',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1506,183,31,18, 'Collective Investments', 'JamesHay',42, 'CISA',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1507,183,31,4, 'Collective Investments', 'JamesHay',42, 'CISA',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1508,183,31,28, 'Collective Investments', 'JamesHay',42, 'PEP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1509,183,1033,1030, 'Collective Investments', 'JamesHay',42, 'TESSA',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1510,183,1033,1031, 'Collective Investments', 'JamesHay',42, 'PEP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1511,183,86,NULL, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1512,183,26,NULL, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1513,183,44,NULL, 'Bond', 'JamesHay',42, 'OFB',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1514,183,20,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1516,183,22,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1517,183,32,NULL, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1518,183,3,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1519,183,21,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1520,183,8,NULL, 'Bond', 'JamesHay',42, 'OFB',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1521,183,1,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1522,183,7,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1523,183,85,NULL, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1524,183,85,1024, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1525,183,85,1023, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1526,183,85,1036, 'Collective Investments', 'JamesHay',42, 'PEP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1527,183,9,NULL, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1528,183,100,NULL, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1529,183,99,NULL, 'Pension', 'JamesHay',42, 'SIPP',3, 'JAMESHAY_NU' UNION ALL 
        SELECT 1946,183,33,1044, 'Collective Investments', 'JamesHay',42, 'UT',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1531,183,113,NULL, 'Collective Investments', 'JamesHay',42, 'IP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1532,2288,89,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1534,2288,4,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1535,2288,1007,NULL, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1536,2288,1004,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1537,2288,46,NULL, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1538,2288,82,NULL, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1539,2288,6,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1540,2288,114,NULL, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1541,2288,10,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1542,2288,1005,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1543,2288,48,NULL, 'Bond', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1544,2288,1030,1027, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1545,2288,1030,1026, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1546,2288,28,NULL, 'Bond', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1547,2288,28,1012, 'Bond', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1548,2288,28,1011, 'Bond', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1549,2288,27,NULL, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1550,2288,31,29, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 1551,2288,31,1, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 1552,2288,31,18, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 1553,2288,31,4, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 1554,2288,31,28, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 1555,2288,1033,1030, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 1556,2288,1033,1031, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 1557,2288,86,NULL, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1558,2288,26,NULL, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1559,2288,44,NULL, 'Bond', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1560,2288,20,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1562,2288,22,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1563,2288,32,NULL, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1564,2288,3,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1565,2288,21,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1566,2288,8,NULL, 'Bond', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1567,2288,1,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1568,2288,7,NULL, 'Pensions', NULL,NULL, 'SSAS',1, NULL UNION ALL 
        SELECT 1573,2288,9,NULL, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1574,2288,100,NULL, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 1575,2288,99,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1968,2288,33,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1577,2288,113,NULL, 'Collective Investments', NULL,NULL, 'Investment',1, NULL UNION ALL 
        SELECT 2160,901,85,1024, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2161,901,85,1023, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2162,901,9,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2163,901,100,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2164,901,99,NULL, 'Pensions', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 1650,2215,46,NULL, 'Collective Investments', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1651,2215,82,NULL, 'Collective Investments', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1652,2215,6,NULL, 'Pensions', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 1653,2215,114,NULL, 'Collective Investments', NULL,NULL, 'Cash Account',1, NULL UNION ALL 
        SELECT 1654,2215,10,NULL, 'Pensions', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 1655,2215,1005,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1656,2215,48,NULL, 'Collective Investments', NULL,NULL, 'Offshore Bond',1, NULL UNION ALL 
        SELECT 1657,2215,1030,1027, 'Pensions', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 1658,2215,1030,1026, 'Pensions', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 1659,2215,28,NULL, 'Bond', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1660,2215,28,1012, 'Bond', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1661,2215,28,1011, 'Bond', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1662,2215,27,NULL, 'Collective Investments', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1663,2215,31,29, 'Collective Investments', NULL,NULL, 'Cash ISA',1, NULL UNION ALL 
        SELECT 1664,2215,31,1, 'Collective Investments', NULL,NULL, 'Stocks & Shares ISA',1, NULL UNION ALL 
        SELECT 1665,2215,31,18, 'Collective Investments', NULL,NULL, 'Stocks & Shares ISA',1, NULL UNION ALL 
        SELECT 1666,2215,31,4, 'Collective Investments', NULL,NULL, 'Stocks & Shares ISA',1, NULL UNION ALL 
        SELECT 1667,2215,31,28, 'Collective Investments', NULL,NULL, 'Stocks & Shares ISA',1, NULL UNION ALL 
        SELECT 1668,2215,1033,1031, 'Collective Investments', NULL,NULL, 'Stocks & Shares ISA',1, NULL UNION ALL 
        SELECT 1669,2215,86,NULL, 'Collective Investments', NULL,NULL, 'Offshore Bond',1, NULL UNION ALL 
        SELECT 1670,2215,26,NULL, 'Collective Investments', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1671,2215,44,NULL, 'Bond', NULL,NULL, 'Offshore Bond',1, NULL UNION ALL 
        SELECT 1672,2215,42,NULL, 'Collective Investments', NULL,NULL, 'Offshore Bond',1, NULL UNION ALL 
        SELECT 1673,2215,20,NULL, 'Pensions', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 2506,294,28,1011, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'PRUDENTIAL_PENSION_BOND_UP_OG1.2' UNION ALL 
        SELECT 1675,2215,22,NULL, 'Pensions', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 1676,2215,32,NULL, 'Collective Investments', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1677,2215,3,NULL, 'Pensions', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 1678,2215,21,NULL, 'Pensions', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 1679,2215,8,NULL, 'Bond', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 1680,2215,1,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1681,2215,7,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 1682,2215,85,NULL, 'Collective Investments', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1683,2215,85,1024, 'Collective Investments', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1684,2215,85,1023, 'Collective Investments', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1685,2215,85,1036, 'Collective Investments', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1686,2215,9,NULL, 'Collective Investments', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1687,2215,100,NULL, 'Collective Investments', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1688,2215,99,NULL, 'Pensions', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 1964,2215,33,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1690,2215,113,NULL, 'Collective Investments', NULL,NULL, 'Investment Account',1, NULL UNION ALL 
        SELECT 1701,1377,89,NULL, 'Pensions', NULL,NULL, 'ADV',2, NULL UNION ALL 
        SELECT 2507,294,44,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'PRUDENTIAL_PENSION_BOND_UP_OG1.2' UNION ALL 
        SELECT 1703,1377,4,NULL, 'Pensions', NULL,NULL, 'ZO',2, NULL UNION ALL 
        SELECT 1704,1377,1007,NULL, 'Collective Investments', NULL,NULL, 'CO',2, NULL UNION ALL 
        SELECT 1705,1377,1004,NULL, 'Pensions', NULL,NULL, 'P',2, NULL UNION ALL 
        SELECT 1706,1377,46,NULL, 'Collective Investments', NULL,NULL, 'XP',2, NULL UNION ALL 
        SELECT 1707,1377,82,NULL, 'Collective Investments', NULL,NULL, 'CUST-ONLY',2, NULL UNION ALL 
        SELECT 1708,1377,6,NULL, 'Pensions', NULL,NULL, 'CUST-ONLYO',2, NULL UNION ALL 
        SELECT 1709,1377,114,NULL, 'Collective Investments', NULL,NULL, 'CUST-ROUTE',2, NULL UNION ALL 
        SELECT 1710,1377,10,NULL, 'Pensions', NULL,NULL, 'CUS',2, NULL UNION ALL 
        SELECT 1711,1377,1005,NULL, 'Pensions', NULL,NULL, 'DHADV',2, NULL UNION ALL 
        SELECT 1712,1377,48,NULL, 'Bond', NULL,NULL, 'DHDISC',2, NULL UNION ALL 
        SELECT 1713,1377,1030,1027, 'Collective Investments', NULL,NULL, 'D',2, NULL UNION ALL 
        SELECT 1714,1377,1030,1026, 'Collective Investments', NULL,NULL, 'Y',2, NULL UNION ALL 
        SELECT 1715,1377,28,NULL, 'Bond', NULL,NULL, 'DIS',2, NULL UNION ALL 
        SELECT 1716,1377,28,1012, 'Bond', NULL,NULL, 'EXONLY',2, NULL UNION ALL 
        SELECT 1717,1377,28,1011, 'Bond', NULL,NULL, 'EXE',2, NULL UNION ALL 
        SELECT 1718,1377,27,NULL, 'Collective Investments', NULL,NULL, 'INST-PO',2, NULL UNION ALL 
        SELECT 1719,1377,31,29, 'Collective Investments', NULL,NULL, 'LNS-NT',2, NULL UNION ALL 
        SELECT 1720,1377,31,1, 'Collective Investments', NULL,NULL, 'MP',2, NULL UNION ALL 
        SELECT 1721,1377,31,18, 'Collective Investments', NULL,NULL, 'MPO',2, NULL UNION ALL 
        SELECT 1722,1377,31,4, 'Collective Investments', NULL,NULL, 'N',2, NULL UNION ALL 
        SELECT 1723,1377,31,28, 'Collective Investments', NULL,NULL, 'OC',2, NULL UNION ALL 
        SELECT 1724,1377,1033,1030, 'Collective Investments', NULL,NULL, 'ORP',2, NULL UNION ALL 
        SELECT 1725,1377,1033,1031, 'Collective Investments', NULL,NULL, 'OWNP',2, NULL UNION ALL 
        SELECT 1726,1377,86,NULL, 'Collective Investments', NULL,NULL, 'O',2, NULL UNION ALL 
        SELECT 1727,1377,26,NULL, 'Collective Investments', NULL,NULL, 'OD',2, NULL UNION ALL 
        SELECT 1728,1377,44,NULL, 'Bond', NULL,NULL, 'OROUTE',2, NULL UNION ALL 
        SELECT 1729,1377,20,NULL, 'Pensions', NULL,NULL, 'OA',2, NULL UNION ALL 
        SELECT 2514,310,91,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 1731,1377,22,NULL, 'Pensions', NULL,NULL, 'YCA',2, NULL UNION ALL 
        SELECT 1732,1377,32,NULL, 'Collective Investments', NULL,NULL, 'YCB',2, NULL UNION ALL 
        SELECT 1733,1377,3,NULL, 'Pensions', NULL,NULL, 'YCH',2, NULL UNION ALL 
        SELECT 1734,1377,21,NULL, 'Pensions', NULL,NULL, 'YCC',2, NULL UNION ALL 
        SELECT 1735,1377,8,NULL, 'Bond', NULL,NULL, 'YCG',2, NULL UNION ALL 
        SELECT 1736,1377,1,NULL, 'Pensions', NULL,NULL, 'YCI',2, NULL UNION ALL 
        SELECT 1737,1377,7,NULL, 'Pensions', NULL,NULL, 'YC',2, NULL UNION ALL 
        SELECT 1738,1377,85,NULL, 'Collective Investments', NULL,NULL, 'YCE',2, NULL UNION ALL 
        SELECT 1739,1377,85,1024, 'Collective Investments', NULL,NULL, 'ICA',2, NULL UNION ALL 
        SELECT 1740,1377,85,1023, 'Collective Investments', NULL,NULL, 'ICB',2, NULL UNION ALL 
        SELECT 1741,1377,85,1036, 'Collective Investments', NULL,NULL, 'ICH',2, NULL UNION ALL 
        SELECT 1742,1377,9,NULL, 'Collective Investments', NULL,NULL, 'ICG',2, NULL UNION ALL 
        SELECT 1743,1377,100,NULL, 'Collective Investments', NULL,NULL, 'ICI',2, NULL UNION ALL 
        SELECT 1744,1377,99,NULL, 'Pensions', NULL,NULL, 'PC',2, NULL UNION ALL 
        SELECT 1958,1377,33,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1746,1377,113,NULL, 'Collective Investments', NULL,NULL, 'PCB',2, NULL UNION ALL 
        SELECT 1965,2215,33,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 2181,310,1030,1027, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',32, NULL,3, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2182,310,1030,1026, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',32, NULL,3, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2178,2215,105,NULL, 'Collective Investments', NULL,NULL, 'Cash Account',1, NULL UNION ALL 
        SELECT 2219,567,3,NULL, 'FNP', '1.0',3, 'FNP',2, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 2220,567,1030,1027, 'FNP', '1.0',3, 'FNP',2, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 2221,567,1030,1026, 'FNP', '1.0',3, 'FNP',2, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 2517,310,108,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2442,808,9,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2518,310,110,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2519,310,1005,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 1938,1145,34,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1939,1145,34,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1940,1555,34,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1941,1555,34,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1944,2288,34,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1945,2288,34,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1947,183,33,1045, 'Collective Investments', 'JamesHay',42, 'UT',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 1948,302,33,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1949,302,33,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1954,901,33,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1955,901,33,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1956,1145,33,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1957,1145,33,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1959,1377,33,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1960,1543,33,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1961,1543,33,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1962,1555,33,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1963,1555,33,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1966,2247,33,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1967,2247,33,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1969,2288,33,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1970,2313,33,1044, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 1971,2313,33,1045, 'Collective Investments', NULL,NULL, 'UT',1, NULL UNION ALL 
        SELECT 2318,1405,26,NULL, 'Collective Investment', NULL,NULL, 'Isa stocks and shares',1, NULL UNION ALL 
        SELECT 2367,558,90,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2368,558,91,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2165,901,33,NULL, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2369,558,99,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2166,901,1033,1030, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2167,901,1033,1031, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2168,901,85,1036, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2370,558,107,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2371,558,108,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2372,558,114,NULL, 'Collective Investments', 'v001.00',NULL, 'COFINV',2, 'COFUNDS_NU' UNION ALL 
        SELECT 2373,558,1000,1000, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2374,558,1000,1001, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2375,558,1003,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2376,558,1005,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2377,558,1007,NULL, 'Collective Investments', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2378,558,1008,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2379,558,1019,NULL, 'Bond', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2380,558,1030,1026, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2381,558,1030,1027, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2382,558,1036,NULL, 'Collective Investments', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2383,558,1050,NULL, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2384,2610,4,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2385,2610,5,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2386,2610,7,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2387,2610,11,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2388,2610,12,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2389,2610,14,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2390,2610,28,1011, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_BOND_NU_OG1.2' UNION ALL 
        SELECT 2391,2610,28,1012, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_BOND_NU_OG1.2' UNION ALL 
        SELECT 2392,2610,31,18, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.xsd',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2393,2610,48,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_BOND_NU_OG1.2' UNION ALL 
        SELECT 2394,2610,49,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_BOND_NU_OG1.2' UNION ALL 
        SELECT 2395,2610,72,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2396,2610,78,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_BOND_NU_OG1.2' UNION ALL 
        SELECT 2397,2610,82,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.xsd',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2398,2610,90,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2399,2610,91,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2400,2610,99,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2401,2610,100,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.xsd',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2402,2610,107,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2403,2610,108,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2404,2610,114,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.xsd',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2405,2610,1000,1000, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2406,2610,1000,1001, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2407,2610,1003,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2408,2610,1005,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2409,2610,1008,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2410,2610,1019,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_BOND_NU_OG1.2' UNION ALL 
        SELECT 2411,2610,1030,1026, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2412,2610,1030,1027, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2413,2610,1036,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.xsd',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2414,2610,1050,NULL, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2415,326,2,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2416,326,7,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2417,326,9,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_BOND_UP_OG2.0' UNION ALL 
        SELECT 2418,326,11,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2419,326,28,1011, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_BOND_UP_OG2.0' UNION ALL 
        SELECT 2420,326,28,1012, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_BOND_UP_OG2.0' UNION ALL 
        SELECT 2421,326,44,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_BOND_UP_OG2.0' UNION ALL 
        SELECT 2422,326,48,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_BOND_UP_OG2.0' UNION ALL 
        SELECT 2423,326,49,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_BOND_UP_OG2.0' UNION ALL 
        SELECT 2429,326,108,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2430,326,1000,1000, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2431,326,1000,1001, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2432,326,1003,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2433,326,1005,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2434,326,1008,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2435,326,1019,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_BOND_UP_OG2.0' UNION ALL 
        SELECT 2436,326,1050,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2445,808,4,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2446,808,90,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2447,808,11,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2448,808,91,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2449,808,6,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2450,808,1050,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2451,808,14,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2452,808,107,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2453,808,108,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2454,808,1005,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2455,808,110,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2456,808,12,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2457,808,1003,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2458,808,1030,1027, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2459,808,1030,1026, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2460,808,72,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2461,808,22,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2462,808,21,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2463,808,1000,1001, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2464,808,1000,1000, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2465,808,8,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2466,808,1,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2467,808,7,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2469,808,1008,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2470,808,99,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2471,808,16,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2472,808,15,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2485,294,1005,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2486,294,12,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2487,294,1003,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2490,294,72,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2491,294,22,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2492,294,21,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2493,294,1000,1001, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2494,294,1000,1000, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2495,294,2,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2496,294,8,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2497,294,1,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2498,294,7,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2499,294,5,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2500,294,1008,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2502,294,99,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2503,294,78,NULL, 'Bond', '/origo/1.2/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'PRUDENTIAL_PENSION_BOND_UP_OG1.2' UNION ALL 
        SELECT 2527,310,8,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2528,310,1,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2529,310,7,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2530,310,1008,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2531,310,9,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2532,310,99,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2533,310,78,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2534,310,1019,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2535,310,48,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2536,310,49,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2537,310,28,1012, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2538,310,28,1011, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2578,321,89,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2579,321,4,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2580,321,90,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2581,321,91,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2582,321,1050,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2583,321,107,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2584,321,108,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2585,321,110,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2586,321,1005,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2608,2640,1,NULL, 'Pensions', NULL,NULL, 'Pensions',1, NULL UNION ALL 
        SELECT 2609,2640,3,NULL, 'Pensions', NULL,NULL, 'Pensions',1, NULL UNION ALL 
        SELECT 2610,2640,25,NULL, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2611,2640,28,1011, 'Bond', NULL,NULL, 'Bond',1, NULL UNION ALL 
        SELECT 2612,2640,28,1012, 'Bond', NULL,NULL, 'Bond',1, NULL UNION ALL 
        SELECT 2613,2640,28,NULL, 'Bond', NULL,NULL, 'Bond',1, NULL UNION ALL 
        SELECT 2614,2640,31,28, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2630,2432,114,NULL, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2631,2432,1007,NULL, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2632,2432,1030,1026, 'Pensions', NULL,NULL, 'Pensions',1, NULL UNION ALL 
        SELECT 2633,2432,1030,1027, 'Pensions', NULL,NULL, 'Pensions',1, NULL UNION ALL 
        SELECT 2634,84,4,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2635,84,90,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2637,84,11,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2638,84,91,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2656,395,4,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2657,395,90,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2658,395,11,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2659,395,91,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2660,395,1050,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2661,395,107,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2662,395,108,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2663,395,110,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2664,395,1005,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2665,395,12,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2666,395,72,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2667,395,2,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2668,395,8,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2669,395,1,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2670,395,7,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2671,395,5,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2672,395,9,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2673,395,78,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2674,395,1019,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2676,395,48,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2677,395,49,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2678,395,28,1012, 'Bond', '/origo/2.0/CEBondSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2679,395,28,1011, 'Bond', '/origo/2.0/CEBondSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2680,395,44,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.XSD',NULL, NULL,1, 'ZURICH_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2683,395,82,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.XSD',NULL, NULL,1, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 2684,395,1036,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.XSD',NULL, NULL,1, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 2685,395,114,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.XSD',NULL, NULL,1, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 2686,395,27,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.XSD',NULL, NULL,1, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 2687,395,100,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.XSD',NULL, NULL,1, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 2688,199,4,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2689,199,90,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2690,199,11,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2691,199,91,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2692,199,6,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2693,199,1050,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2694,199,107,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2695,199,108,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2696,199,110,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2697,199,1005,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2698,199,72,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2699,199,2,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2700,199,8,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2701,199,1,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2702,199,7,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2703,199,9,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2704,199,78,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 1827,576,1030,1027, 'Pension', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 1828,576,1030,1026, 'Pension', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 1647,2215,4,NULL, 'Pensions', NULL,NULL, 'Personal Pension Plan',1, NULL UNION ALL 
        SELECT 1649,2215,1004,NULL, 'Pensions', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 2223,2313,31,1058, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 2224,2288,31,1058, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2225,2269,31,1058, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',28, 'ISA',2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2226,2247,31,1058, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 2227,2215,31,1058, 'Collective Investments', NULL,NULL, 'Cash ISA',1, NULL UNION ALL 
        SELECT 2228,2610,31,1058, 'ISACash', '/origo/1.2/CECIVValuationRequest.xsd',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2229,1814,31,1058, 'Collective Investments', NULL,NULL, 'Novia Cash ISA',1, NULL UNION ALL 
        SELECT 2230,1555,31,1058, '', NULL,NULL, 'AMAXISA',1, NULL UNION ALL 
        SELECT 2231,1543,31,1058, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 2232,1509,31,1058, 'Collective Investments', NULL,NULL, 'ISA',4, NULL UNION ALL 
        SELECT 2233,1405,31,1058, 'Collective Investments', NULL,NULL, 'Isa stocks and shares',1, NULL UNION ALL 
        SELECT 2234,1377,31,1058, 'Collective Investments', NULL,NULL, 'LNS-NT',2, NULL UNION ALL 
        SELECT 2235,1145,31,1058, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2236,1019,31,1058, 'Collective Investments', NULL,NULL, 'ISA Account (Stocks & Shares)',1, NULL UNION ALL 
        SELECT 2237,941,31,1058, 'ISAStocksAndShares', '3',18, NULL,2, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 2238,901,31,1058, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2239,878,31,1058, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2240,576,31,1058, 'ISACash', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 2241,567,31,1058, 'ISA', '1.0',3, NULL,3, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 2242,558,31,1058, 'ISACash', 'v001.00',7, 'COFISA',3, 'COFUNDS_NU' UNION ALL 
        SELECT 2243,395,31,1058, 'ISACash', '/origo/1.2/CECIVValuationRequest.XSD',23, NULL,2, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 2244,347,31,1058, 'ISACash', '/origo/1.2/CECIVValuationRequest.xsd',16, NULL,2, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 2245,2611,31,1058, 'ISACash', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 2246,302,31,1058, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 2247,183,31,1058, 'Collective Investments', 'JamesHay',42, 'CISA',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 2319,347,4,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2320,347,7,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2321,347,11,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2322,347,12,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2323,347,28,1011, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'STANDARDLIFE_BOND_UP_OG1.1' UNION ALL 
        SELECT 2324,347,28,1012, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'STANDARDLIFE_BOND_UP_OG1.1' UNION ALL 
        SELECT 2325,347,44,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'STANDARDLIFE_BOND_UP_OG1.1' UNION ALL 
        SELECT 2326,347,72,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2327,347,78,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'STANDARDLIFE_BOND_UP_OG1.1' UNION ALL 
        SELECT 2328,347,82,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 2329,347,90,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2330,347,91,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2331,347,99,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2332,347,100,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 2333,347,107,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2334,347,108,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2335,347,114,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 2336,347,1000,1000, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2337,347,1000,1001, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2338,347,1003,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2339,347,1005,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2340,347,1007,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 2341,347,1008,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2342,347,1019,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'STANDARDLIFE_BOND_UP_OG1.1' UNION ALL 
        SELECT 2343,347,1030,1026, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2344,347,1030,1027, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2345,347,1036,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 2346,347,1050,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2424,326,72,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2425,326,78,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_BOND_UP_OG2.0' UNION ALL 
        SELECT 2426,326,91,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2427,326,99,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2428,326,107,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2639,84,6,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2640,84,1050,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2641,84,107,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2642,84,108,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2643,84,10,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2644,84,110,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2645,84,1005,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2646,84,12,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2647,84,72,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2648,84,2,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2649,84,1,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2650,84,7,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2651,84,9,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2652,84,78,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_BOND_UP_OG2.0' UNION ALL 
        SELECT 2653,84,1019,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_BOND_UP_OG2.0' UNION ALL 
        SELECT 2654,84,28,1012, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_BOND_UP_OG2.0' UNION ALL 
        SELECT 2655,84,28,1011, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'CLERICALMEDICAL_BOND_UP_OG2.0' UNION ALL 
        SELECT 2705,199,1019,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2706,199,28,1012, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2707,199,28,1011, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2708,199,44,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'LEGALGENERAL_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2709,204,4,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2710,204,6,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2711,204,1050,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2712,204,14,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2713,204,2,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2714,204,7,NULL, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2715,576,1033,1031, 'Collective Investments', '6',NULL, NULL,1, 'TRANSACT_NU' UNION ALL 
        SELECT 2716,576,1,NULL, 'Pension', '6',NULL, NULL,1, 'TRANSACT_NU' UNION ALL 
        SELECT 2731,62,4,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2732,62,1050,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2733,62,1000,1001, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2734,62,1000,1000, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2735,62,8,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2736,62,9,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2744,183,78,NULL, 'Bond', 'JamesHay',NULL, NULL,1, 'JAMESHAY_NU' UNION ALL 
        SELECT 2779,2269,4,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2780,2269,1050,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2781,2269,110,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2782,2269,1005,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2783,2269,8,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2784,2269,78,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2785,2269,1019,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2786,2269,48,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2787,2269,49,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2817,2611,1030,1064, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2515,310,1050,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2819,310,1030,1064, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2516,310,107,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2746,183,1036,NULL, 'Collective Investments', 'JamesHay',NULL, NULL,1, 'JAMESHAY_NU' UNION ALL 
        SELECT 2748,2611,89,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2749,2611,4,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2750,2611,1050,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2751,2611,1000,1001, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2752,2611,1000,1000, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2753,2611,2,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2754,2611,7,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2755,2611,99,NULL, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2756,2611,78,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2757,2611,1019,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2758,2611,28,1012, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2759,2611,28,1011, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2760,2611,44,NULL, 'Bond', '/origo/1.1/CEBondRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_PENSION_BOND_NU_OG1.1' UNION ALL 
        SELECT 2761,2611,45,NULL, 'Collective Investments', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 2762,2611,50,1009, 'Collective Investments', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',NULL, NULL,1, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 2861,294,1030,1026, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, 'Income Drawdown',1, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2820,321,1030,1064, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2821,326,1030,1064, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHWIDOWS_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2822,347,1030,1064, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'STANDARDLIFE_PENSION_UP_OG2.0' UNION ALL 
        SELECT 2823,576,1030,1064, 'Pension', '6',NULL, NULL,1, 'TRANSACT_NU' UNION ALL 
        SELECT 2824,181,1,NULL, 'Pension', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 2825,181,7,NULL, 'Pension', NULL,NULL, 'SSAS',1, NULL UNION ALL 
        SELECT 2826,181,25,NULL, 'Collective Investment', NULL,NULL, 'Cash Deposit',1, NULL UNION ALL 
        SELECT 2827,181,31,1058, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2828,181,46,NULL, 'Collective Investment', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 2829,181,86,NULL, 'Collective Investment', NULL,NULL, 'Non-Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 2830,181,105,NULL, 'Collective Investment', NULL,NULL, 'Cash Account',1, NULL UNION ALL 
        SELECT 2831,181,1007,NULL, 'Collective Investment', NULL,NULL, 'Collective Investment Account',1, NULL UNION ALL 
        SELECT 2832,181,1033,1063, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2833,1984,1043,NULL, 'Pension', NULL,NULL, 'QNUPS',1, NULL UNION ALL 
        SELECT 2834,1984,1033,1031, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2835,1984,1033,1030, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2836,1984,1033,1063, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2837,1984,1020,NULL, 'Pension', NULL,NULL, 'EFRBS',1, NULL UNION ALL 
        SELECT 2838,1984,1007,NULL, 'Collective Investment', NULL,NULL, 'Collective Investment Account',1, NULL UNION ALL 
        SELECT 2839,1984,1005,NULL, 'Pension', NULL,NULL, 'Group SIPP',1, NULL UNION ALL 
        SELECT 2840,1984,115,NULL, 'Pension', NULL,NULL, 'QROPS',1, NULL UNION ALL 
        SELECT 2841,1984,114,NULL, 'Pension', NULL,NULL, 'General Investment Account',1, NULL UNION ALL 
        SELECT 2842,1984,110,NULL, 'Pension', NULL,NULL, 'Bond',1, NULL UNION ALL 
        SELECT 2843,1984,44,NULL, 'Pension', NULL,NULL, 'Bond',1, NULL UNION ALL 
        SELECT 2844,1984,31,29, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2845,1984,31,28, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2846,1984,31,5, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2847,1984,31,4, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2848,1984,31,3, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2849,1984,31,2, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2850,1984,31,1, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2851,1984,31,1058, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2852,1984,31,18, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2853,1984,28,NULL, 'Pension', NULL,NULL, 'Bond',1, NULL UNION ALL 
        SELECT 2854,1984,28,1012, 'Pension', NULL,NULL, 'Bond',1, NULL UNION ALL 
        SELECT 2855,1984,28,1011, 'Pension', NULL,NULL, 'Bond',1, NULL UNION ALL 
        SELECT 2856,1984,10,NULL, 'Pension', NULL,NULL, 'Pension',1, NULL UNION ALL 
        SELECT 2857,1984,8,NULL, 'Pension', NULL,NULL, 'Bond',1, NULL UNION ALL 
        SELECT 2858,1984,7,NULL, 'Pension', NULL,NULL, 'SSAS',1, NULL UNION ALL 
        SELECT 2859,1984,3,NULL, 'Pension', NULL,NULL, 'Pension',1, NULL UNION ALL 
        SELECT 2860,1984,1,NULL, 'Pension', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 2862,294,1030,1027, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, 'Income Drawdown',1, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2863,294,1030,1064, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, 'Income Drawdown',1, 'PRUDENTIAL_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2864,204,1030,1027, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2865,204,1030,1064, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2803,2377,1,NULL, 'Pension', NULL,NULL, 'Pension',1, NULL UNION ALL 
        SELECT 2804,2377,3,NULL, NULL, NULL,NULL, NULL,1, NULL UNION ALL 
        SELECT 2805,2377,10,NULL, NULL, NULL,NULL, NULL,1, NULL UNION ALL 
        SELECT 2806,2377,31,NULL, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2807,2377,44,NULL, 'Bond', NULL,NULL, 'Bond',1, NULL UNION ALL 
        SELECT 2808,2377,114,NULL, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2809,2377,1033,NULL, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2810,808,1030,1064, 'Pension', '/origo/1.1/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'AVIVA_PENSION_OG2.2' UNION ALL 
        SELECT 2811,2245,1030,1064, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2588,321,1003,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2589,321,1030,1027, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2590,321,1030,1026, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2591,321,72,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2592,321,1000,1001, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2593,321,1000,1000, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2594,321,2,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2595,321,8,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2596,321,1,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2597,321,7,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2598,321,1008,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2599,321,9,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2600,321,99,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2601,321,78,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2602,321,1019,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2603,321,48,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2604,321,49,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2605,321,28,1012, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2606,321,28,1011, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2607,321,44,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SCOTTISHEQUITABLE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2615,2640,105,NULL, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2616,2640,114,NULL, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2617,2640,1007,NULL, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2618,2640,1033,1031, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2619,2625,1,NULL, 'Pensions', NULL,NULL, 'Pensions',1, NULL UNION ALL 
        SELECT 2620,2625,3,NULL, 'Pensions', NULL,NULL, 'Pensions',1, NULL UNION ALL 
        SELECT 2621,2625,1030,1026, 'Pensions', NULL,NULL, 'Pensions',1, NULL UNION ALL 
        SELECT 2622,2625,1030,1027, 'Pensions', NULL,NULL, 'Pensions',1, NULL UNION ALL 
        SELECT 2623,2432,1,NULL, 'Pensions', NULL,NULL, 'Pensions',1, NULL UNION ALL 
        SELECT 2624,2432,3,NULL, 'Pensions', NULL,NULL, 'Pensions',1, NULL UNION ALL 
        SELECT 2625,2432,25,NULL, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2626,2432,26,NULL, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2627,2432,31,1058, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2628,2432,31,28, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2629,2432,105,NULL, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2866,204,1030,1026, 'Pension', '/origo/2.2/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'LIVERPOOLVICTORIA_PENSION_UP_OG2.2' UNION ALL 
        SELECT 2867,1796,1,NULL, 'Pension', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 2868,1796,3,NULL, 'Pension', NULL,NULL, 'Pension',1, NULL UNION ALL 
        SELECT 2869,1796,27,NULL, 'Pension', NULL,NULL, NULL,1, NULL UNION ALL 
        SELECT 2870,1796,31,18, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2871,1796,31,1058, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2872,1796,31,28, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2873,1796,31,29, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2874,1796,114,NULL, 'Pension', NULL,NULL, 'General Investment Account',1, NULL UNION ALL 
        SELECT 2875,1796,1007,NULL, 'Collective Investment', NULL,NULL, 'Collective Investment Account',1, NULL UNION ALL 
        SELECT 2876,1796,1033,1030, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2877,1796,1033,1031, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2878,1796,1033,1063, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2882,2825,113,NULL, 'Collective Investments', '/origo/1.2/CECIVValuationRequest_ZIP.XSD',NULL, '',1, NULL UNION ALL 
        SELECT 2522,310,22,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2523,310,21,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2524,310,1000,1001, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2525,310,1000,1000, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2539,310,44,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2883,1509,1062,1074, 'Collective Investments', NULL,NULL, 'ISA',4, NULL UNION ALL 
        SELECT 2884,2269,1062,1074, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',28, 'ISA',2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2885,556,1062,1074, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2886,1814,1062,1074, 'Collective Investments', NULL,NULL, 'Novia Cash ISA',1, NULL UNION ALL 
        SELECT 2887,1543,1062,1074, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 2888,567,1062,1074, 'ISA', '1.0',3, NULL,3, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 2889,558,1062,1074, 'ISACash', 'v001.00',7, 'COFISA',3, 'COFUNDS_NU' UNION ALL 
        SELECT 2890,2611,1062,1074, 'ISACash', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 2891,347,1062,1074, 'ISACash', '/origo/1.2/CECIVValuationRequest.xsd',16, NULL,2, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 2892,576,1062,1074, 'ISACash', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 2893,395,1062,1074, 'ISACash', '/origo/1.2/CECIVValuationRequest.XSD',23, NULL,2, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 2894,2610,1062,1074, 'ISACash', '/origo/1.2/CECIVValuationRequest.xsd',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2895,1405,1062,1074, 'Collective Investments', NULL,NULL, 'Isa stocks and shares',1, NULL UNION ALL 
        SELECT 2896,1145,1062,1074, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2897,901,1062,1074, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2898,2247,1062,1074, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 2899,878,1062,1074, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2900,302,1062,1074, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 2901,2313,1062,1074, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 2902,183,1062,1074, 'Collective Investments', 'JamesHay',42, 'CISA',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 2903,2288,1062,1074, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2904,2215,1062,1074, 'Collective Investments', NULL,NULL, 'Cash ISA',1, NULL UNION ALL 
        SELECT 2905,1377,1062,1074, 'Collective Investments', NULL,NULL, 'LNS-NT',2, NULL UNION ALL 
        SELECT 2906,1984,1062,1074, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2907,1796,1062,1074, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2908,1509,1062,1075, 'Collective Investments', NULL,NULL, 'ISA',4, NULL UNION ALL 
        SELECT 2909,2269,1062,1075, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',28, 'ISA',2, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2910,556,1062,1075, 'Collective Investments', NULL,NULL, 'ISA',2, NULL UNION ALL 
        SELECT 2911,1814,1062,1075, 'Collective Investments', NULL,NULL, 'Novia ISA',1, NULL UNION ALL 
        SELECT 2912,1543,1062,1075, 'Collective Investments', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 2913,2611,1062,1075, 'ISAStocksAndShares', '/origo/1.0DraftA/ContractEnquiryRequest.xsd',2, NULL,3, 'OLDMUTUALWEALTHLIFEASSURANCE_CI_NU_OG1.0' UNION ALL 
        SELECT 2914,567,1062,1075, 'ISA', '1.0',3, NULL,3, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 2915,558,1062,1075, 'ISAStocksAndShares', 'v001.00',7, 'COFISA',3, 'COFUNDS_NU' UNION ALL 
        SELECT 2916,1555,1062,1075, '', NULL,NULL, 'AMAXISA',1, NULL UNION ALL 
        SELECT 2917,347,1062,1075, 'ISAStocksAndShares', '/origo/1.2/CECIVValuationRequest.xsd',16, NULL,2, 'STANDARDLIFE_CI_UP_OG1.2' UNION ALL 
        SELECT 2918,576,1062,1075, 'ISAStocksAndShares', '6',17, NULL,2, 'TRANSACT_NU' UNION ALL 
        SELECT 2919,941,1062,1075, 'ISAStocksAndShares', '3',18, NULL,2, 'SEVENINVESTMENTMANAGEMENT_NU' UNION ALL 
        SELECT 2920,395,1062,1075, 'ISAStocksAndShares', '/origo/1.2/CECIVValuationRequest.XSD',23, NULL,2, 'ZURICH_CI_UP_OG1.2' UNION ALL 
        SELECT 2921,2610,1062,1075, 'ISAStocksAndShares', '/origo/1.2/CECIVValuationRequest.xsd',33, NULL,3, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2922,1405,1062,1075, 'Collective Investments', NULL,NULL, 'Isa stocks and shares',1, NULL UNION ALL 
        SELECT 2923,1019,1062,1075, 'Collective Investments', NULL,NULL, 'ISA Account (Stocks & Shares)',1, NULL UNION ALL 
        SELECT 2924,878,1062,1075, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2925,1145,1062,1075, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2926,901,1062,1075, 'Collective Investments', NULL,NULL, 'PORTFOLIO',2, NULL UNION ALL 
        SELECT 2927,2247,1062,1075, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 2928,302,1062,1075, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 2929,2313,1062,1075, 'Collective Investments', NULL,NULL, 'ISA',3, NULL UNION ALL 
        SELECT 2930,183,1062,1075, 'Collective Investments', 'JamesHay',42, 'PEP',2, 'JAMESHAY_NU' UNION ALL 
        SELECT 2931,2288,1062,1075, 'Collective Investments', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2932,2215,1062,1075, 'Collective Investments', NULL,NULL, 'Stocks & Shares ISA',1, NULL UNION ALL 
        SELECT 2933,1377,1062,1075, 'Collective Investments', NULL,NULL, 'OC',2, NULL UNION ALL 
        SELECT 2934,2640,1062,1075, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2935,1984,1062,1075, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2936,2432,1062,1075, 'Collective Investments', NULL,NULL, 'Collective Investments',1, NULL UNION ALL 
        SELECT 2937,1796,1062,1075, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2938,2604,1,NULL, 'Pension', NULL,NULL, 'SIPP',1, NULL UNION ALL 
        SELECT 2939,2604,3,NULL, 'Pension', NULL,NULL, 'Pensions',1, NULL UNION ALL 
        SELECT 2940,2604,26,NULL, 'Pension', NULL,NULL, NULL,1, NULL UNION ALL 
        SELECT 2941,2604,27,NULL, 'Pension', NULL,NULL, NULL,1, NULL UNION ALL 
        SELECT 2942,2604,28,NULL, 'Pension', NULL,NULL, 'Offshore Bonds',1, NULL UNION ALL 
        SELECT 2943,2604,31,18, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2879,2269,1030,1027, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2880,2269,1030,1064, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2881,2269,1030,1026, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2738,62,78,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2739,62,1019,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2740,62,28,1012, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2741,62,28,1011, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'CANADALIFE_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2742,62,39,NULL, 'Bond', '/origo/2.0/CEEndowmentSingleContractRequest.xsd',NULL, NULL,1, 'CANADALIFE_ENDOWMENT_UP_OG2.0' UNION ALL 
        SELECT 2743,62,45,NULL, 'Bond', '/origo/2.0/CEEndowmentSingleContractRequest.xsd',NULL, NULL,1, 'CANADALIFE_ENDOWMENT_UP_OG2.0' UNION ALL 
        SELECT 2745,183,1019,NULL, 'Bond', 'JamesHay',NULL, NULL,1, 'JAMESHAY_NU' UNION ALL 
        SELECT 2747,183,49,NULL, 'Bond', 'JamesHay',NULL, NULL,1, 'JAMESHAY_NU' UNION ALL 
        SELECT 2764,2245,78,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2765,2245,1019,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2766,2245,28,1012, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2767,2245,28,1011, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2768,2245,10,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2769,2245,110,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2770,2245,1005,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2771,2245,1030,1027, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2772,2245,1030,1026, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2773,2245,1000,1001, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2774,2245,1000,1000, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2775,2245,2,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2776,2245,1,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2777,2245,7,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2778,2245,99,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,1, 'AXAWEALTH_PENSION_BOND_NU_OG2.0' UNION ALL 
        SELECT 2790,2269,28,1012, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2791,2269,28,1011, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2792,2269,44,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2793,2269,62,NULL, 'Bond', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2794,2269,1007,NULL, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2795,2269,82,NULL, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2796,2269,1036,NULL, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2797,2269,27,NULL, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2798,2269,26,NULL, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2799,2269,32,NULL, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2800,2269,100,NULL, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2801,2269,46,NULL, 'Collective Investments', '/origo/2.0/CEBondSingleContractRequest.xsd',NULL, NULL,1, 'SANLAMINVESTMENTSANDPENSIONS_PENSION_BOND_CI_NU_OG2.0' UNION ALL 
        SELECT 2812,558,1030,1064, 'Pension', 'v001.00',NULL, NULL,1, 'COFUNDS_NU' UNION ALL 
        SELECT 2813,567,1030,1064, 'FNP', '1.0',NULL, NULL,1, 'FIDELITYFUNDSNETWORK_NU' UNION ALL 
        SELECT 2815,183,1030,1064, 'Pension', 'JamesHay',NULL, NULL,1, 'JAMESHAY_NU' UNION ALL 
        SELECT 2816,2610,1030,1064, 'Pension', '/origo/1.2/CEPensionRealTimeValuationRequest.XSD',NULL, NULL,1, 'OLDMUTUALWEALTH_PENSION_CI_NU_OG1.2' UNION ALL 
        SELECT 2520,310,1003,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2521,310,72,NULL, 'Pension', '/origo/2.0/CEPensionSingleContractRequest.xsd',NULL, NULL,2, 'ROYALLONDON_PENSION_BOND_UP_OG2.0' UNION ALL 
        SELECT 2944,2604,31,1058, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2945,2604,31,1071, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2946,2604,31,1, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2947,2604,31,4, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2948,2604,31,28, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2949,2604,31,29, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2950,2604,32,NULL, 'Pension', NULL,NULL, NULL,1, NULL UNION ALL 
        SELECT 2951,2604,39,NULL, 'Pension', NULL,NULL, NULL,1, NULL UNION ALL 
        SELECT 2952,2604,44,NULL, 'Pension', NULL,NULL, 'Offshore Bonds',1, NULL UNION ALL 
        SELECT 2953,2604,46,NULL, 'Collective Investment', NULL,NULL, 'Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 2954,2604,82,NULL, 'Pension', NULL,NULL, NULL,1, NULL UNION ALL 
        SELECT 2955,2604,86,NULL, 'Collective Investment', NULL,NULL, 'Non-Discretionary Managed Service',1, NULL UNION ALL 
        SELECT 2956,2604,105,NULL, 'Collective Investment', NULL,NULL, 'Cash Account',1, NULL UNION ALL 
        SELECT 2957,2604,113,NULL, 'Pension', NULL,NULL, NULL,1, NULL UNION ALL 
        SELECT 2958,2604,114,NULL, 'Pension', NULL,NULL, 'General Investment Account',1, NULL UNION ALL 
        SELECT 2959,2604,1007,NULL, 'Collective Investment', NULL,NULL, 'Collective Investment Account',1, NULL UNION ALL 
        SELECT 2960,2604,1033,1030, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2961,2604,1033,1031, 'Collective Investment', NULL,NULL, 'ISA',1, NULL UNION ALL 
        SELECT 2962,2604,1033,1063, 'Collective Investment', NULL,NULL, 'ISA',1, NULL 
 
        SET IDENTITY_INSERT TValGating OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '50F0EA74-1BDE-4136-982C-DBCFEF2D02D3', 
         'Initial load (1417 total rows, file 1 of 1) for table TValGating',
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
-- #Rows Exported: 1417
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
