 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TLifeCycle2RefPlanType
--    Join: join TLifecycle l on l.LifeCycleId = TLifeCycle2RefPlanType.LifeCycleId
--   Where: WHERE l.IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'A80613AC-A9D7-46EB-8F39-102BD44E7E3C'
     AND TenantId = 466
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TLifeCycle2RefPlanType ON; 
 
        INSERT INTO TLifeCycle2RefPlanType([LifeCycle2RefPlanTypeId], [LifeCycleId], [RefPlanTypeId], [AdviceTypeId], [ConcurrencyId])
        SELECT 160443,6304,1,6304, '1         ' UNION ALL 
        SELECT 160444,6304,2,6304, '1         ' UNION ALL 
        SELECT 160445,6304,3,6304, '1         ' UNION ALL 
        SELECT 160446,6304,4,6304, '1         ' UNION ALL 
        SELECT 160447,6304,5,6304, '1         ' UNION ALL 
        SELECT 160448,6304,6,6304, '1         ' UNION ALL 
        SELECT 160449,6304,7,6304, '1         ' UNION ALL 
        SELECT 160450,6304,8,6304, '1         ' UNION ALL 
        SELECT 160451,6304,9,6304, '1         ' UNION ALL 
        SELECT 160452,6304,10,6304, '1         ' UNION ALL 
        SELECT 160453,6304,11,6304, '1         ' UNION ALL 
        SELECT 160454,6304,12,6304, '1         ' UNION ALL 
        SELECT 160455,6304,13,6304, '1         ' UNION ALL 
        SELECT 160456,6304,14,6304, '1         ' UNION ALL 
        SELECT 160457,6304,15,6304, '1         ' UNION ALL 
        SELECT 160458,6304,16,6304, '1         ' UNION ALL 
        SELECT 160459,6304,17,6304, '1         ' UNION ALL 
        SELECT 160460,6304,18,6304, '1         ' UNION ALL 
        SELECT 160461,6304,19,6304, '1         ' UNION ALL 
        SELECT 160462,6304,20,6304, '1         ' UNION ALL 
        SELECT 160463,6304,21,6304, '1         ' UNION ALL 
        SELECT 160464,6304,22,6304, '1         ' UNION ALL 
        SELECT 160465,6304,23,6304, '1         ' UNION ALL 
        SELECT 160466,6304,24,6304, '1         ' UNION ALL 
        SELECT 160467,6304,25,6304, '1         ' UNION ALL 
        SELECT 160468,6304,26,6304, '1         ' UNION ALL 
        SELECT 160469,6304,27,6304, '1         ' UNION ALL 
        SELECT 160470,6304,28,6304, '1         ' UNION ALL 
        SELECT 160471,6304,29,6304, '1         ' UNION ALL 
        SELECT 160472,6304,30,6304, '1         ' UNION ALL 
        SELECT 160473,6304,31,6304, '1         ' UNION ALL 
        SELECT 160474,6304,32,6304, '1         ' UNION ALL 
        SELECT 160475,6304,33,6304, '1         ' UNION ALL 
        SELECT 160476,6304,34,6304, '1         ' UNION ALL 
        SELECT 160477,6304,35,6304, '1         ' UNION ALL 
        SELECT 160478,6304,36,6304, '1         ' UNION ALL 
        SELECT 160479,6304,37,6304, '1         ' UNION ALL 
        SELECT 160480,6304,38,6304, '1         ' UNION ALL 
        SELECT 160481,6304,39,6304, '1         ' UNION ALL 
        SELECT 160482,6304,40,6304, '1         ' UNION ALL 
        SELECT 160483,6304,41,6304, '1         ' UNION ALL 
        SELECT 160484,6304,42,6304, '1         ' UNION ALL 
        SELECT 160485,6304,43,6304, '1         ' UNION ALL 
        SELECT 160486,6304,44,6304, '1         ' UNION ALL 
        SELECT 160487,6304,45,6304, '1         ' UNION ALL 
        SELECT 160488,6304,46,6304, '1         ' UNION ALL 
        SELECT 160489,6304,47,6304, '1         ' UNION ALL 
        SELECT 160490,6304,48,6304, '1         ' UNION ALL 
        SELECT 160491,6304,49,6304, '1         ' UNION ALL 
        SELECT 160492,6304,50,6304, '1         ' UNION ALL 
        SELECT 160493,6304,51,6304, '1         ' UNION ALL 
        SELECT 160494,6304,52,6304, '1         ' UNION ALL 
        SELECT 160495,6304,53,6304, '1         ' UNION ALL 
        SELECT 160496,6304,54,6304, '1         ' UNION ALL 
        SELECT 160497,6304,55,6304, '1         ' UNION ALL 
        SELECT 160498,6304,56,6304, '1         ' UNION ALL 
        SELECT 160499,6304,57,6304, '1         ' UNION ALL 
        SELECT 160500,6304,58,6304, '1         ' UNION ALL 
        SELECT 160501,6304,59,6304, '1         ' UNION ALL 
        SELECT 160502,6304,60,6304, '1         ' UNION ALL 
        SELECT 160503,6304,61,6304, '1         ' UNION ALL 
        SELECT 160504,6304,62,6304, '1         ' UNION ALL 
        SELECT 160505,6304,63,6304, '1         ' UNION ALL 
        SELECT 160506,6304,64,6304, '1         ' UNION ALL 
        SELECT 160507,6304,65,6304, '1         ' UNION ALL 
        SELECT 160508,6304,66,6304, '1         ' UNION ALL 
        SELECT 160509,6304,70,6304, '1         ' UNION ALL 
        SELECT 160510,6304,71,6304, '1         ' UNION ALL 
        SELECT 160511,6304,72,6304, '1         ' UNION ALL 
        SELECT 160512,6304,74,6304, '1         ' UNION ALL 
        SELECT 160513,6304,75,6304, '1         ' UNION ALL 
        SELECT 160514,6304,77,6304, '1         ' UNION ALL 
        SELECT 160515,6304,78,6304, '1         ' UNION ALL 
        SELECT 160516,6304,79,6304, '1         ' UNION ALL 
        SELECT 160517,6304,81,6304, '1         ' UNION ALL 
        SELECT 160518,6304,82,6304, '1         ' UNION ALL 
        SELECT 160519,6304,83,6304, '1         ' UNION ALL 
        SELECT 160520,6304,84,6304, '1         ' UNION ALL 
        SELECT 160521,6304,85,6304, '1         ' UNION ALL 
        SELECT 160522,6304,86,6304, '1         ' UNION ALL 
        SELECT 160523,6304,87,6304, '1         ' UNION ALL 
        SELECT 160524,6304,88,6304, '1         ' UNION ALL 
        SELECT 160525,6304,89,6304, '1         ' UNION ALL 
        SELECT 160526,6304,90,6304, '1         ' UNION ALL 
        SELECT 160527,6304,91,6304, '1         ' UNION ALL 
        SELECT 160528,6304,92,6304, '1         ' UNION ALL 
        SELECT 160529,6304,93,6304, '1         ' UNION ALL 
        SELECT 160530,6304,94,6304, '1         ' UNION ALL 
        SELECT 160531,6304,95,6304, '1         ' UNION ALL 
        SELECT 160532,6304,96,6304, '1         ' UNION ALL 
        SELECT 160533,6304,97,6304, '1         ' UNION ALL 
        SELECT 160534,6304,98,6304, '1         ' UNION ALL 
        SELECT 160535,6304,99,6304, '1         ' UNION ALL 
        SELECT 160536,6304,100,6304, '1         ' UNION ALL 
        SELECT 160537,6304,101,6304, '1         ' UNION ALL 
        SELECT 160538,6304,102,6304, '1         ' UNION ALL 
        SELECT 160539,6304,103,6304, '1         ' UNION ALL 
        SELECT 160540,6304,104,6304, '1         ' UNION ALL 
        SELECT 1007806,6304,105,6304, '1         ' UNION ALL 
        SELECT 1009432,6304,114,6304, '1         ' UNION ALL 
        SELECT 160541,6305,56,6305, '1         ' UNION ALL 
        SELECT 160542,6305,4,6305, '1         ' UNION ALL 
        SELECT 160543,6305,54,6305, '1         ' UNION ALL 
        SELECT 160544,6305,13,6305, '1         ' UNION ALL 
        SELECT 160545,6305,36,6305, '1         ' UNION ALL 
        SELECT 160546,6305,25,6305, '1         ' UNION ALL 
        SELECT 160547,6305,11,6305, '1         ' UNION ALL 
        SELECT 160548,6305,57,6305, '1         ' UNION ALL 
        SELECT 160549,6305,46,6305, '1         ' UNION ALL 
        SELECT 160550,6305,37,6305, '1         ' UNION ALL 
        SELECT 160551,6305,34,6305, '1         ' UNION ALL 
        SELECT 160552,6305,62,6305, '1         ' UNION ALL 
        SELECT 160553,6305,64,6305, '1         ' UNION ALL 
        SELECT 160554,6305,6,6305, '1         ' UNION ALL 
        SELECT 160555,6305,38,6305, '1         ' UNION ALL 
        SELECT 160556,6305,35,6305, '1         ' UNION ALL 
        SELECT 160557,6305,17,6305, '1         ' UNION ALL 
        SELECT 160558,6305,40,6305, '1         ' UNION ALL 
        SELECT 160559,6305,14,6305, '1         ' UNION ALL 
        SELECT 160560,6305,15,6305, '1         ' UNION ALL 
        SELECT 160561,6305,47,6305, '1         ' UNION ALL 
        SELECT 160562,6305,55,6305, '1         ' UNION ALL 
        SELECT 160563,6305,74,6305, '1         ' UNION ALL 
        SELECT 160564,6305,19,6305, '1         ' UNION ALL 
        SELECT 160565,6305,10,6305, '1         ' UNION ALL 
        SELECT 160566,6305,60,6305, '1         ' UNION ALL 
        SELECT 160567,6305,59,6305, '1         ' UNION ALL 
        SELECT 160568,6305,61,6305, '1         ' UNION ALL 
        SELECT 160569,6305,48,6305, '1         ' UNION ALL 
        SELECT 160570,6305,49,6305, '1         ' UNION ALL 
        SELECT 160571,6305,24,6305, '1         ' UNION ALL 
        SELECT 160572,6305,18,6305, '1         ' UNION ALL 
        SELECT 160573,6305,65,6305, '1         ' UNION ALL 
        SELECT 160574,6305,27,6305, '1         ' UNION ALL 
        SELECT 160575,6305,31,6305, '1         ' UNION ALL 
        SELECT 160576,6305,53,6305, '1         ' UNION ALL 
        SELECT 160577,6305,39,6305, '1         ' UNION ALL 
        SELECT 160578,6305,72,6305, '1         ' UNION ALL 
        SELECT 160579,6305,63,6305, '1         ' UNION ALL 
        SELECT 160580,6305,29,6305, '1         ' UNION ALL 
        SELECT 160581,6305,26,6305, '1         ' UNION ALL 
        SELECT 160582,6305,44,6305, '1         ' UNION ALL 
        SELECT 160583,6305,43,6305, '1         ' UNION ALL 
        SELECT 160584,6305,42,6305, '1         ' UNION ALL 
        SELECT 160585,6305,20,6305, '1         ' UNION ALL 
        SELECT 160586,6305,41,6305, '1         ' UNION ALL 
        SELECT 160587,6305,28,6305, '1         ' UNION ALL 
        SELECT 160588,6305,23,6305, '1         ' UNION ALL 
        SELECT 160589,6305,71,6305, '1         ' UNION ALL 
        SELECT 160590,6305,22,6305, '1         ' UNION ALL 
        SELECT 160591,6305,32,6305, '1         ' UNION ALL 
        SELECT 160592,6305,3,6305, '1         ' UNION ALL 
        SELECT 160593,6305,21,6305, '1         ' UNION ALL 
        SELECT 160594,6305,52,6305, '1         ' UNION ALL 
        SELECT 160595,6305,58,6305, '1         ' UNION ALL 
        SELECT 160596,6305,2,6305, '1         ' UNION ALL 
        SELECT 160597,6305,8,6305, '1         ' UNION ALL 
        SELECT 160598,6305,1,6305, '1         ' UNION ALL 
        SELECT 160599,6305,7,6305, '1         ' UNION ALL 
        SELECT 160600,6305,12,6305, '1         ' UNION ALL 
        SELECT 160601,6305,5,6305, '1         ' UNION ALL 
        SELECT 160602,6305,51,6305, '1         ' UNION ALL 
        SELECT 160603,6305,30,6305, '1         ' UNION ALL 
        SELECT 160604,6305,70,6305, '1         ' UNION ALL 
        SELECT 160605,6305,45,6305, '1         ' UNION ALL 
        SELECT 160606,6305,9,6305, '1         ' UNION ALL 
        SELECT 160607,6305,16,6305, '1         ' UNION ALL 
        SELECT 160608,6305,33,6305, '1         ' UNION ALL 
        SELECT 160609,6305,50,6305, '1         ' UNION ALL 
        SELECT 160610,6306,56,6306, '1         ' UNION ALL 
        SELECT 160611,6306,4,6306, '1         ' UNION ALL 
        SELECT 160612,6306,54,6306, '1         ' UNION ALL 
        SELECT 160613,6306,13,6306, '1         ' UNION ALL 
        SELECT 160614,6306,36,6306, '1         ' UNION ALL 
        SELECT 160615,6306,25,6306, '1         ' UNION ALL 
        SELECT 160616,6306,11,6306, '1         ' UNION ALL 
        SELECT 160617,6306,57,6306, '1         ' UNION ALL 
        SELECT 160618,6306,46,6306, '1         ' UNION ALL 
        SELECT 160619,6306,37,6306, '1         ' UNION ALL 
        SELECT 160620,6306,34,6306, '1         ' UNION ALL 
        SELECT 160621,6306,62,6306, '1         ' UNION ALL 
        SELECT 160622,6306,64,6306, '1         ' UNION ALL 
        SELECT 160623,6306,6,6306, '1         ' UNION ALL 
        SELECT 160624,6306,38,6306, '1         ' UNION ALL 
        SELECT 160625,6306,35,6306, '1         ' UNION ALL 
        SELECT 160626,6306,17,6306, '1         ' UNION ALL 
        SELECT 160627,6306,40,6306, '1         ' UNION ALL 
        SELECT 160628,6306,14,6306, '1         ' UNION ALL 
        SELECT 160629,6306,15,6306, '1         ' UNION ALL 
        SELECT 160630,6306,47,6306, '1         ' UNION ALL 
        SELECT 160631,6306,55,6306, '1         ' UNION ALL 
        SELECT 160632,6306,74,6306, '1         ' UNION ALL 
        SELECT 160633,6306,19,6306, '1         ' UNION ALL 
        SELECT 160634,6306,10,6306, '1         ' UNION ALL 
        SELECT 160635,6306,60,6306, '1         ' UNION ALL 
        SELECT 160636,6306,59,6306, '1         ' UNION ALL 
        SELECT 160637,6306,61,6306, '1         ' UNION ALL 
        SELECT 160638,6306,48,6306, '1         ' UNION ALL 
        SELECT 160639,6306,49,6306, '1         ' UNION ALL 
        SELECT 160640,6306,24,6306, '1         ' UNION ALL 
        SELECT 160641,6306,18,6306, '1         ' UNION ALL 
        SELECT 160642,6306,65,6306, '1         ' UNION ALL 
        SELECT 160643,6306,27,6306, '1         ' UNION ALL 
        SELECT 160644,6306,31,6306, '1         ' UNION ALL 
        SELECT 160645,6306,53,6306, '1         ' UNION ALL 
        SELECT 160646,6306,39,6306, '1         ' UNION ALL 
        SELECT 160647,6306,72,6306, '1         ' UNION ALL 
        SELECT 160648,6306,63,6306, '1         ' UNION ALL 
        SELECT 160649,6306,29,6306, '1         ' UNION ALL 
        SELECT 160650,6306,26,6306, '1         ' UNION ALL 
        SELECT 160651,6306,44,6306, '1         ' UNION ALL 
        SELECT 160652,6306,43,6306, '1         ' UNION ALL 
        SELECT 160653,6306,42,6306, '1         ' UNION ALL 
        SELECT 160654,6306,20,6306, '1         ' UNION ALL 
        SELECT 160655,6306,41,6306, '1         ' UNION ALL 
        SELECT 160656,6306,28,6306, '1         ' UNION ALL 
        SELECT 160657,6306,23,6306, '1         ' UNION ALL 
        SELECT 160658,6306,71,6306, '1         ' UNION ALL 
        SELECT 160659,6306,22,6306, '1         ' UNION ALL 
        SELECT 160660,6306,32,6306, '1         ' UNION ALL 
        SELECT 160661,6306,3,6306, '1         ' UNION ALL 
        SELECT 160662,6306,21,6306, '1         ' UNION ALL 
        SELECT 160663,6306,52,6306, '1         ' UNION ALL 
        SELECT 160664,6306,58,6306, '1         ' UNION ALL 
        SELECT 160665,6306,2,6306, '1         ' UNION ALL 
        SELECT 160666,6306,8,6306, '1         ' UNION ALL 
        SELECT 160667,6306,1,6306, '1         ' UNION ALL 
        SELECT 160668,6306,7,6306, '1         ' UNION ALL 
        SELECT 160669,6306,12,6306, '1         ' UNION ALL 
        SELECT 160670,6306,5,6306, '1         ' UNION ALL 
        SELECT 160671,6306,51,6306, '1         ' UNION ALL 
        SELECT 160672,6306,30,6306, '1         ' UNION ALL 
        SELECT 160673,6306,70,6306, '1         ' UNION ALL 
        SELECT 160674,6306,45,6306, '1         ' UNION ALL 
        SELECT 160675,6306,9,6306, '1         ' UNION ALL 
        SELECT 160676,6306,16,6306, '1         ' UNION ALL 
        SELECT 160677,6306,33,6306, '1         ' UNION ALL 
        SELECT 160678,6306,50,6306, '1         ' UNION ALL 
        SELECT 160679,6307,56,6307, '1         ' UNION ALL 
        SELECT 160680,6307,4,6307, '1         ' UNION ALL 
        SELECT 160681,6307,54,6307, '1         ' UNION ALL 
        SELECT 160682,6307,13,6307, '1         ' UNION ALL 
        SELECT 160683,6307,36,6307, '1         ' UNION ALL 
        SELECT 160684,6307,25,6307, '1         ' UNION ALL 
        SELECT 160685,6307,11,6307, '1         ' UNION ALL 
        SELECT 160686,6307,57,6307, '1         ' UNION ALL 
        SELECT 160687,6307,46,6307, '1         ' UNION ALL 
        SELECT 160688,6307,37,6307, '1         ' UNION ALL 
        SELECT 160689,6307,34,6307, '1         ' UNION ALL 
        SELECT 160690,6307,62,6307, '1         ' UNION ALL 
        SELECT 160691,6307,64,6307, '1         ' UNION ALL 
        SELECT 160692,6307,6,6307, '1         ' UNION ALL 
        SELECT 160693,6307,38,6307, '1         ' UNION ALL 
        SELECT 160694,6307,35,6307, '1         ' UNION ALL 
        SELECT 160695,6307,17,6307, '1         ' UNION ALL 
        SELECT 160696,6307,40,6307, '1         ' UNION ALL 
        SELECT 160697,6307,14,6307, '1         ' UNION ALL 
        SELECT 160698,6307,15,6307, '1         ' UNION ALL 
        SELECT 160699,6307,47,6307, '1         ' UNION ALL 
        SELECT 160700,6307,55,6307, '1         ' UNION ALL 
        SELECT 160701,6307,74,6307, '1         ' UNION ALL 
        SELECT 160702,6307,19,6307, '1         ' UNION ALL 
        SELECT 160703,6307,10,6307, '1         ' UNION ALL 
        SELECT 160704,6307,60,6307, '1         ' UNION ALL 
        SELECT 160705,6307,59,6307, '1         ' UNION ALL 
        SELECT 160706,6307,61,6307, '1         ' UNION ALL 
        SELECT 160707,6307,48,6307, '1         ' UNION ALL 
        SELECT 160708,6307,49,6307, '1         ' UNION ALL 
        SELECT 160709,6307,24,6307, '1         ' UNION ALL 
        SELECT 160710,6307,18,6307, '1         ' UNION ALL 
        SELECT 160711,6307,65,6307, '1         ' UNION ALL 
        SELECT 160712,6307,27,6307, '1         ' UNION ALL 
        SELECT 160713,6307,31,6307, '1         ' UNION ALL 
        SELECT 160714,6307,53,6307, '1         ' UNION ALL 
        SELECT 160715,6307,39,6307, '1         ' UNION ALL 
        SELECT 160716,6307,72,6307, '1         ' UNION ALL 
        SELECT 160717,6307,63,6307, '1         ' UNION ALL 
        SELECT 160718,6307,29,6307, '1         ' UNION ALL 
        SELECT 160719,6307,26,6307, '1         ' UNION ALL 
        SELECT 160720,6307,44,6307, '1         ' UNION ALL 
        SELECT 160721,6307,43,6307, '1         ' UNION ALL 
        SELECT 160722,6307,42,6307, '1         ' UNION ALL 
        SELECT 160723,6307,20,6307, '1         ' UNION ALL 
        SELECT 160724,6307,41,6307, '1         ' UNION ALL 
        SELECT 160725,6307,28,6307, '1         ' UNION ALL 
        SELECT 160726,6307,23,6307, '1         ' UNION ALL 
        SELECT 160727,6307,71,6307, '1         ' UNION ALL 
        SELECT 160728,6307,22,6307, '1         ' UNION ALL 
        SELECT 160729,6307,32,6307, '1         ' UNION ALL 
        SELECT 160730,6307,3,6307, '1         ' UNION ALL 
        SELECT 160731,6307,21,6307, '1         ' UNION ALL 
        SELECT 160732,6307,52,6307, '1         ' UNION ALL 
        SELECT 160733,6307,58,6307, '1         ' UNION ALL 
        SELECT 160734,6307,2,6307, '1         ' UNION ALL 
        SELECT 160735,6307,8,6307, '1         ' UNION ALL 
        SELECT 160736,6307,1,6307, '1         ' UNION ALL 
        SELECT 160737,6307,7,6307, '1         ' UNION ALL 
        SELECT 160738,6307,12,6307, '1         ' UNION ALL 
        SELECT 160739,6307,5,6307, '1         ' UNION ALL 
        SELECT 160740,6307,51,6307, '1         ' UNION ALL 
        SELECT 160741,6307,30,6307, '1         ' UNION ALL 
        SELECT 160742,6307,70,6307, '1         ' UNION ALL 
        SELECT 160743,6307,45,6307, '1         ' UNION ALL 
        SELECT 160744,6307,9,6307, '1         ' UNION ALL 
        SELECT 160745,6307,16,6307, '1         ' UNION ALL 
        SELECT 160746,6307,33,6307, '1         ' UNION ALL 
        SELECT 160747,6307,50,6307, '1         ' UNION ALL 
        SELECT 160748,6308,56,6308, '1         ' UNION ALL 
        SELECT 160749,6308,4,6308, '1         ' UNION ALL 
        SELECT 160750,6308,54,6308, '1         ' UNION ALL 
        SELECT 160751,6308,13,6308, '1         ' UNION ALL 
        SELECT 160752,6308,36,6308, '1         ' UNION ALL 
        SELECT 160753,6308,25,6308, '1         ' UNION ALL 
        SELECT 160754,6308,11,6308, '1         ' UNION ALL 
        SELECT 160755,6308,57,6308, '1         ' UNION ALL 
        SELECT 160756,6308,46,6308, '1         ' UNION ALL 
        SELECT 160757,6308,37,6308, '1         ' UNION ALL 
        SELECT 160758,6308,34,6308, '1         ' UNION ALL 
        SELECT 160759,6308,62,6308, '1         ' UNION ALL 
        SELECT 160760,6308,64,6308, '1         ' UNION ALL 
        SELECT 160761,6308,6,6308, '1         ' UNION ALL 
        SELECT 160762,6308,38,6308, '1         ' UNION ALL 
        SELECT 160763,6308,35,6308, '1         ' UNION ALL 
        SELECT 160764,6308,17,6308, '1         ' UNION ALL 
        SELECT 160765,6308,40,6308, '1         ' UNION ALL 
        SELECT 160766,6308,14,6308, '1         ' UNION ALL 
        SELECT 160767,6308,15,6308, '1         ' UNION ALL 
        SELECT 160768,6308,47,6308, '1         ' UNION ALL 
        SELECT 160769,6308,55,6308, '1         ' UNION ALL 
        SELECT 160770,6308,74,6308, '1         ' UNION ALL 
        SELECT 160771,6308,19,6308, '1         ' UNION ALL 
        SELECT 160772,6308,10,6308, '1         ' UNION ALL 
        SELECT 160773,6308,60,6308, '1         ' UNION ALL 
        SELECT 160774,6308,59,6308, '1         ' UNION ALL 
        SELECT 160775,6308,61,6308, '1         ' UNION ALL 
        SELECT 160776,6308,48,6308, '1         ' UNION ALL 
        SELECT 160777,6308,49,6308, '1         ' UNION ALL 
        SELECT 160778,6308,24,6308, '1         ' UNION ALL 
        SELECT 160779,6308,18,6308, '1         ' UNION ALL 
        SELECT 160780,6308,65,6308, '1         ' UNION ALL 
        SELECT 160781,6308,27,6308, '1         ' UNION ALL 
        SELECT 160782,6308,31,6308, '1         ' UNION ALL 
        SELECT 160783,6308,53,6308, '1         ' UNION ALL 
        SELECT 160784,6308,39,6308, '1         ' UNION ALL 
        SELECT 160785,6308,72,6308, '1         ' UNION ALL 
        SELECT 160786,6308,63,6308, '1         ' UNION ALL 
        SELECT 160787,6308,29,6308, '1         ' UNION ALL 
        SELECT 160788,6308,26,6308, '1         ' UNION ALL 
        SELECT 160789,6308,44,6308, '1         ' UNION ALL 
        SELECT 160790,6308,43,6308, '1         ' UNION ALL 
        SELECT 160791,6308,42,6308, '1         ' UNION ALL 
        SELECT 160792,6308,20,6308, '1         ' UNION ALL 
        SELECT 160793,6308,41,6308, '1         ' UNION ALL 
        SELECT 160794,6308,28,6308, '1         ' UNION ALL 
        SELECT 160795,6308,23,6308, '1         ' UNION ALL 
        SELECT 160796,6308,71,6308, '1         ' UNION ALL 
        SELECT 160797,6308,22,6308, '1         ' UNION ALL 
        SELECT 160798,6308,32,6308, '1         ' UNION ALL 
        SELECT 160799,6308,3,6308, '1         ' UNION ALL 
        SELECT 160800,6308,21,6308, '1         ' UNION ALL 
        SELECT 160801,6308,52,6308, '1         ' UNION ALL 
        SELECT 160802,6308,58,6308, '1         ' UNION ALL 
        SELECT 160803,6308,2,6308, '1         ' UNION ALL 
        SELECT 160804,6308,8,6308, '1         ' UNION ALL 
        SELECT 160805,6308,1,6308, '1         ' UNION ALL 
        SELECT 160806,6308,7,6308, '1         ' UNION ALL 
        SELECT 160807,6308,12,6308, '1         ' UNION ALL 
        SELECT 160808,6308,5,6308, '1         ' UNION ALL 
        SELECT 160809,6308,51,6308, '1         ' UNION ALL 
        SELECT 160810,6308,30,6308, '1         ' UNION ALL 
        SELECT 160811,6308,70,6308, '1         ' UNION ALL 
        SELECT 160812,6308,45,6308, '1         ' UNION ALL 
        SELECT 160813,6308,9,6308, '1         ' UNION ALL 
        SELECT 160814,6308,16,6308, '1         ' UNION ALL 
        SELECT 160815,6308,33,6308, '1         ' UNION ALL 
        SELECT 160816,6308,50,6308, '1         ' UNION ALL 
        SELECT 160817,6308,99,6308, '1         ' UNION ALL 
        SELECT 704118,22437,51,22437, '1         ' UNION ALL 
        SELECT 981075,32779,1,32779, '1         ' UNION ALL 
        SELECT 981076,32779,3,32779, '1         ' UNION ALL 
        SELECT 981077,32779,4,32779, '1         ' UNION ALL 
        SELECT 981078,32779,8,32779, '1         ' UNION ALL 
        SELECT 981079,32779,22,32779, '1         ' UNION ALL 
        SELECT 981080,32779,28,32779, '1         ' UNION ALL 
        SELECT 981081,32779,31,32779, '1         ' UNION ALL 
        SELECT 981082,32779,39,32779, '1         ' UNION ALL 
        SELECT 981083,32779,44,32779, '1         ' UNION ALL 
        SELECT 981084,32779,72,32779, '1         ' UNION ALL 
        SELECT 981085,32779,105,32779, '1         ' UNION ALL 
        SELECT 981086,32779,114,32779, '1         ' 
 
        SET IDENTITY_INSERT TLifeCycle2RefPlanType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'A80613AC-A9D7-46EB-8F39-102BD44E7E3C', 
         'Initial load (390 total rows, file 1 of 1) for table TLifeCycle2RefPlanType',
         466, 
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
-- #Rows Exported: 390
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
