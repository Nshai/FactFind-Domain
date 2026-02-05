USE CRM
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '4C93C585-5379-4889-A109-1C16E7890786'
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
        SELECT  1, 'Charitable',0,NULL,1 UNION ALL  
        SELECT  2, 'Family',0,NULL,1 UNION ALL 
        SELECT  3, 'Generation skipping',0,NULL,1 UNION ALL 
        SELECT  4, 'Irrevocable',0,NULL,1 UNION ALL 
        SELECT  5, 'Living (default)',0,NULL,1 UNION ALL 
        SELECT  6, 'Qualified Terminable Interest Property (QTIP)',0,NULL,1 UNION ALL 
        SELECT  7, 'Qualified Domestic Trust (QDOT)',0,NULL,1 UNION ALL 
        SELECT  8, 'Revocable',0,NULL,1 UNION ALL 
        SELECT  9, 'Statutory',0,NULL,1 UNION ALL 
        SELECT 10, 'Testamentary',0,NULL,1 UNION ALL 
        SELECT 11, 'Irrevocable living',0,NULL,1 UNION ALL 
        SELECT 12, 'Defective',0,NULL,1 UNION ALL 
        SELECT 13, 'Insurance',0,NULL,1 UNION ALL 
        SELECT 14, 'Special needs',0,NULL,1 UNION ALL 
        SELECT 15, 'Qualified domestic',0,NULL,1 UNION ALL 
        SELECT 16, 'Other',0,NULL,1 
 
        SET IDENTITY_INSERT TRefTrustType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '4C93C585-5379-4889-A109-1C16E7890786', 
         'Initial load (16 total rows, file 1 of 1) for table TRefTrustType',
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