USE CRM

-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'D7B44794-F5D8-4D66-95F3-182951DEED4A'
) RETURN 

SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefTrustType ON; 
 
        INSERT INTO TRefTrustType([RefTrustTypeId], [TrustTypeName], [ArchiveFG], [Extensible], [ConcurrencyId])
        SELECT 6, 'Mixed',0,NULL,1 UNION ALL 
        SELECT 7, 'Settlor Interested',0,NULL,1 UNION ALL 
        SELECT 8, 'Non Resident',0,NULL,1 
 
        SET IDENTITY_INSERT TRefTrustType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'D7B44794-F5D8-4D66-95F3-182951DEED4A', 
         'INTTFF-72 Add 3 additional ref data rows (8 total rows, file 1 of 1) for table TRefTrustType',
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
