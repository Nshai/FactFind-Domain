 
-----------------------------------------------------------------------------
-- Table: CRM.TFactFindSearchPlanType
--    Join: JOIN TFactFindSearch s on s.FactFindSearchId = TFactFindSearchPlanType.FactFindSearchId
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'A6EF638F-A9C6-48FC-8BF4-2A0B787F330E'
     AND TenantId = 12498
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TFactFindSearchPlanType ON; 
 
        INSERT INTO TFactFindSearchPlanType([FactFindSearchPlanTypeId], [FactFindSearchId], [RefPlanTypeId], [ConcurrencyId])
        SELECT 222779,9897,25,1 UNION ALL 
        SELECT 222780,9897,26,1 UNION ALL 
        SELECT 222781,9897,27,1 UNION ALL 
        SELECT 222782,9897,28,1 UNION ALL 
        SELECT 222783,9897,29,1 UNION ALL 
        SELECT 222784,9897,30,1 UNION ALL 
        SELECT 222785,9897,31,1 UNION ALL 
        SELECT 222786,9897,32,1 UNION ALL 
        SELECT 222787,9897,33,1 UNION ALL 
        SELECT 222788,9897,34,1 UNION ALL 
        SELECT 222789,9897,35,1 UNION ALL 
        SELECT 222790,9897,36,1 UNION ALL 
        SELECT 222791,9897,38,1 UNION ALL 
        SELECT 222792,9897,39,1 UNION ALL 
        SELECT 222793,9897,40,1 UNION ALL 
        SELECT 222794,9897,41,1 UNION ALL 
        SELECT 222795,9897,42,1 UNION ALL 
        SELECT 222796,9897,43,1 UNION ALL 
        SELECT 222797,9897,44,1 UNION ALL 
        SELECT 222798,9897,46,1 UNION ALL 
        SELECT 222799,9897,47,1 UNION ALL 
        SELECT 222800,9897,48,1 UNION ALL 
        SELECT 222801,9897,49,1 UNION ALL 
        SELECT 222802,9897,53,1 UNION ALL 
        SELECT 222803,9897,56,1 UNION ALL 
        SELECT 222804,9897,57,1 UNION ALL 
        SELECT 222805,9897,62,1 UNION ALL 
        SELECT 222806,9897,75,1 UNION ALL 
        SELECT 222807,9897,79,1 UNION ALL 
        SELECT 222808,9897,81,1 UNION ALL 
        SELECT 222809,9897,82,1 UNION ALL 
        SELECT 222810,9898,19,1 UNION ALL 
        SELECT 222811,9898,50,1 UNION ALL 
        SELECT 222812,9898,51,1 UNION ALL 
        SELECT 222813,9898,52,1 UNION ALL 
        SELECT 222814,9898,54,1 UNION ALL 
        SELECT 222815,9898,55,1 UNION ALL 
        SELECT 222816,9898,58,1 UNION ALL 
        SELECT 222817,9898,59,1 UNION ALL 
        SELECT 222818,9898,60,1 UNION ALL 
        SELECT 222819,9898,61,1 UNION ALL 
        SELECT 222820,9898,74,1 UNION ALL 
        SELECT 222821,9899,1,1 UNION ALL 
        SELECT 222822,9899,2,1 UNION ALL 
        SELECT 222823,9899,3,1 UNION ALL 
        SELECT 222824,9899,4,1 UNION ALL 
        SELECT 222825,9899,5,1 UNION ALL 
        SELECT 222826,9899,6,1 UNION ALL 
        SELECT 222827,9899,7,1 UNION ALL 
        SELECT 222828,9899,8,1 UNION ALL 
        SELECT 222829,9899,9,1 UNION ALL 
        SELECT 222830,9899,10,1 UNION ALL 
        SELECT 222831,9899,11,1 UNION ALL 
        SELECT 222832,9899,12,1 UNION ALL 
        SELECT 222833,9899,13,1 UNION ALL 
        SELECT 222834,9899,14,1 UNION ALL 
        SELECT 222835,9899,15,1 UNION ALL 
        SELECT 222836,9899,16,1 UNION ALL 
        SELECT 222837,9899,17,1 UNION ALL 
        SELECT 222838,9899,18,1 UNION ALL 
        SELECT 222839,9899,20,1 UNION ALL 
        SELECT 222840,9899,21,1 UNION ALL 
        SELECT 222841,9899,22,1 UNION ALL 
        SELECT 222842,9899,23,1 UNION ALL 
        SELECT 222843,9899,24,1 UNION ALL 
        SELECT 222844,9899,71,1 UNION ALL 
        SELECT 222845,9899,72,1 
 
        SET IDENTITY_INSERT TFactFindSearchPlanType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'A6EF638F-A9C6-48FC-8BF4-2A0B787F330E', 
         'Initial load (67 total rows, file 1 of 1) for table TFactFindSearchPlanType',
         12498, 
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
-- #Rows Exported: 67
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
