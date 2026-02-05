 
-----------------------------------------------------------------------------
-- Table: CRM.TRefServiceStatus
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '676D84D3-AE56-49EA-88FD-A7E87A0B985C'
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
        SET IDENTITY_INSERT TRefServiceStatus ON; 
 
        INSERT INTO TRefServiceStatus([RefServiceStatusId], [ServiceStatusName], [IndigoClientId], [ConcurrencyId], [IsArchived], [GroupId], [IsPropagated], [ReportFrequency], [ReportStartDateType], [ReportStartDate])
        SELECT 1619, 'High',466,1,0,NULL,1,1,1,NULL UNION ALL 
        SELECT 1620, 'Medium',466,1,0,NULL,1,1,1,NULL UNION ALL 
        SELECT 1621, 'Low',466,1,0,NULL,1,1,1,NULL UNION ALL 
        SELECT 1622, 'Deceased',466,1,0,NULL,1,1,1,NULL 
 
        SET IDENTITY_INSERT TRefServiceStatus OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '676D84D3-AE56-49EA-88FD-A7E87A0B985C', 
         'Initial load (4 total rows, file 1 of 1) for table TRefServiceStatus',
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
-- #Rows Exported: 4
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
