 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TLifeCycleStep
--    Join: join TLifecycle l on l.LifeCycleId = TLifeCycleStep.LifeCycleId
--   Where: WHERE l.IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '762D0AF0-FDE9-4AE7-8FD0-103618EA14DD'
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
        SET IDENTITY_INSERT TLifeCycleStep ON; 
 
        INSERT INTO TLifeCycleStep([LifeCycleStepId], [StatusId], [LifeCycleId], [ConcurrencyId], [IsSystem])
        SELECT 370382,40212,45793,1,0 UNION ALL 
        SELECT 370383,40209,45793,1,0 UNION ALL 
        SELECT 370384,40214,45793,1,0 UNION ALL 
        SELECT 370385,40216,45793,1,0 UNION ALL 
        SELECT 370386,40210,45794,1,0 UNION ALL 
        SELECT 370387,40209,45794,1,0 UNION ALL 
        SELECT 370388,40218,45794,1,0 UNION ALL 
        SELECT 370389,40213,45794,1,0 UNION ALL 
        SELECT 370390,40212,45794,1,0 UNION ALL 
        SELECT 370391,40214,45794,1,0 UNION ALL 
        SELECT 370392,40216,45794,1,0 UNION ALL 
        SELECT 370393,40210,45795,1,0 UNION ALL 
        SELECT 370394,40209,45795,1,0 UNION ALL 
        SELECT 370395,40218,45795,1,0 UNION ALL 
        SELECT 370396,40213,45795,1,0 UNION ALL 
        SELECT 370397,40212,45795,1,0 UNION ALL 
        SELECT 370398,40220,45795,1,0 UNION ALL 
        SELECT 370399,40214,45795,1,0 UNION ALL 
        SELECT 370400,40216,45795,1,0 UNION ALL 
        SELECT 370401,40210,45796,1,0 UNION ALL 
        SELECT 370402,40217,45796,1,0 UNION ALL 
        SELECT 370403,40209,45796,1,0 UNION ALL 
        SELECT 370404,40218,45796,1,0 UNION ALL 
        SELECT 370405,40213,45796,1,0 UNION ALL 
        SELECT 370406,40212,45796,1,0 UNION ALL 
        SELECT 370407,40215,45796,1,0 UNION ALL 
        SELECT 370408,40214,45796,1,0 UNION ALL 
        SELECT 370409,40216,45796,1,0 UNION ALL 
        SELECT 370410,40210,45797,1,0 UNION ALL 
        SELECT 370411,40209,45797,1,0 UNION ALL 
        SELECT 370412,40218,45797,1,0 UNION ALL 
        SELECT 370413,40213,45797,1,0 UNION ALL 
        SELECT 370414,40212,45797,1,0 UNION ALL 
        SELECT 370415,40214,45797,1,0 UNION ALL 
        SELECT 370416,40216,45797,1,0 UNION ALL 
        SELECT 370417,40210,45798,1,0 UNION ALL 
        SELECT 370418,40209,45798,1,0 UNION ALL 
        SELECT 370419,40218,45798,1,0 UNION ALL 
        SELECT 370420,40213,45798,1,0 UNION ALL 
        SELECT 370421,40212,45798,1,0 UNION ALL 
        SELECT 370422,40214,45798,1,0 UNION ALL 
        SELECT 370423,40216,45798,1,0 UNION ALL 
        SELECT 391899,40210,48407,1,0 UNION ALL 
        SELECT 391900,40209,48407,1,0 UNION ALL 
        SELECT 391901,40218,48407,1,0 UNION ALL 
        SELECT 391902,40213,48407,1,0 UNION ALL 
        SELECT 391903,40212,48407,1,0 UNION ALL 
        SELECT 391904,40214,48407,1,0 UNION ALL 
        SELECT 391905,40216,48407,1,0 UNION ALL 
        SELECT 391906,40210,48408,1,0 UNION ALL 
        SELECT 391907,40209,48408,1,0 UNION ALL 
        SELECT 391908,40218,48408,1,0 UNION ALL 
        SELECT 391909,40213,48408,1,0 UNION ALL 
        SELECT 391910,40212,48408,1,0 UNION ALL 
        SELECT 391911,40214,48408,1,0 UNION ALL 
        SELECT 391912,40216,48408,1,0 
 
        SET IDENTITY_INSERT TLifeCycleStep OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '762D0AF0-FDE9-4AE7-8FD0-103618EA14DD', 
         'Initial load (56 total rows, file 1 of 1) for table TLifeCycleStep',
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
-- #Rows Exported: 56
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
