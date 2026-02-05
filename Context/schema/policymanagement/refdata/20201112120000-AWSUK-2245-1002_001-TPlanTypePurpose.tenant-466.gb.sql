 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TPlanTypePurpose
--    Join: join TPlanPurpose p on p.PlanPurposeId = TPlanTypePurpose.PlanPurposeId
--   Where: WHERE p.IndigoClientId = 466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '3F98D72A-18EF-41DF-93E8-1CBFC11BB03B'
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
        SET IDENTITY_INSERT TPlanTypePurpose ON; 
 
        INSERT INTO TPlanTypePurpose([PlanTypePurposeId], [RefPlanTypeId], [PlanPurposeId], [DefaultFg], [ConcurrencyId], [RefPlanType2ProdSubTypeId])
        SELECT 345201,6,6944,0,1,11 UNION ALL 
        SELECT 345202,1,6944,0,1,6 UNION ALL 
        SELECT 345203,2,6944,0,1,7 UNION ALL 
        SELECT 345204,5,6944,0,1,10 UNION ALL 
        SELECT 345205,8,6944,0,1,13 UNION ALL 
        SELECT 345206,7,6944,0,1,12 UNION ALL 
        SELECT 345207,18,6944,0,1,23 UNION ALL 
        SELECT 345208,3,6944,0,1,8 UNION ALL 
        SELECT 345209,31,6945,0,1,2 UNION ALL 
        SELECT 345210,5,6945,0,1,10 UNION ALL 
        SELECT 345211,8,6945,0,1,13 UNION ALL 
        SELECT 345212,41,6945,0,1,45 UNION ALL 
        SELECT 345213,31,6945,0,1,4 UNION ALL 
        SELECT 345214,2,6945,0,1,7 UNION ALL 
        SELECT 345215,31,6945,0,1,3 UNION ALL 
        SELECT 345216,44,6945,0,1,48 UNION ALL 
        SELECT 345217,31,6945,0,1,1 UNION ALL 
        SELECT 345218,18,6945,0,1,23 UNION ALL 
        SELECT 345219,31,6945,0,1,142 UNION ALL 
        SELECT 345220,26,6945,0,1,31 UNION ALL 
        SELECT 345221,31,6945,0,1,118 UNION ALL 
        SELECT 345222,3,6945,0,1,8 UNION ALL 
        SELECT 345223,6,6945,0,1,11 UNION ALL 
        SELECT 345224,39,6945,0,1,43 UNION ALL 
        SELECT 345225,46,6945,0,1,50 UNION ALL 
        SELECT 345226,27,6945,0,1,32 UNION ALL 
        SELECT 345227,31,6945,0,1,141 UNION ALL 
        SELECT 345228,32,6945,0,1,36 UNION ALL 
        SELECT 345229,42,6945,0,1,46 UNION ALL 
        SELECT 345230,31,6945,0,1,5 UNION ALL 
        SELECT 345231,62,6945,0,1,66 UNION ALL 
        SELECT 345232,6,6946,0,1,11 UNION ALL 
        SELECT 345233,5,6946,0,1,10 UNION ALL 
        SELECT 345234,2,6946,0,1,7 UNION ALL 
        SELECT 345235,18,6946,0,1,23 UNION ALL 
        SELECT 345236,8,6946,0,1,13 UNION ALL 
        SELECT 345237,3,6946,0,1,8 UNION ALL 
        SELECT 345238,7,6947,0,1,12 UNION ALL 
        SELECT 345239,1,6947,0,1,6 UNION ALL 
        SELECT 345240,6,6947,0,1,11 UNION ALL 
        SELECT 345241,1,6948,0,1,6 UNION ALL 
        SELECT 345242,7,6948,0,1,12 UNION ALL 
        SELECT 345243,6,6948,0,1,11 UNION ALL 
        SELECT 345244,6,6949,0,1,11 UNION ALL 
        SELECT 345245,7,6949,0,1,12 UNION ALL 
        SELECT 345246,1,6949,0,1,6 UNION ALL 
        SELECT 345247,31,6950,0,1,2 UNION ALL 
        SELECT 345248,31,6950,0,1,118 UNION ALL 
        SELECT 345249,31,6950,0,1,3 UNION ALL 
        SELECT 345250,26,6950,0,1,31 UNION ALL 
        SELECT 345251,31,6950,0,1,5 UNION ALL 
        SELECT 345252,31,6950,0,1,1 UNION ALL 
        SELECT 345253,31,6950,0,1,4 UNION ALL 
        SELECT 345254,31,6950,0,1,141 UNION ALL 
        SELECT 345255,31,6950,0,1,142 UNION ALL 
        SELECT 345256,31,6951,0,1,142 UNION ALL 
        SELECT 345257,31,6951,0,1,1 UNION ALL 
        SELECT 345258,31,6951,0,1,118 UNION ALL 
        SELECT 345259,31,6951,0,1,141 UNION ALL 
        SELECT 345260,31,6951,0,1,3 UNION ALL 
        SELECT 345261,31,6951,0,1,5 UNION ALL 
        SELECT 345262,31,6951,0,1,4 UNION ALL 
        SELECT 345263,31,6951,0,1,2 UNION ALL 
        SELECT 345264,31,6952,0,1,4 UNION ALL 
        SELECT 345265,31,6952,0,1,142 UNION ALL 
        SELECT 345266,31,6952,0,1,1 UNION ALL 
        SELECT 345267,31,6952,0,1,3 UNION ALL 
        SELECT 345268,31,6952,0,1,2 UNION ALL 
        SELECT 345269,31,6952,0,1,5 UNION ALL 
        SELECT 345270,31,6952,0,1,118 UNION ALL 
        SELECT 345271,31,6952,0,1,141 
 
        SET IDENTITY_INSERT TPlanTypePurpose OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '3F98D72A-18EF-41DF-93E8-1CBFC11BB03B', 
         'Initial load (71 total rows, file 1 of 1) for table TPlanTypePurpose',
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
-- #Rows Exported: 71
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
