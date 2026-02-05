
USE [crm]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)

SELECT @ScriptGUID = '00713FE6-D857-4279-A256-68B0811C2739', -- use guid for GB script in order not to run it for SYS_IE_03
       @Comments = 'AIOENV-87 initial load for table TRefContactType for us environments'
      
 -- check if this script has already run     
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN; 

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefContactType ON; 
 
        INSERT INTO TRefContactType([RefContactTypeId], [ContactTypeName], [ArchiveFG], [Extensible], [ConcurrencyId])
        SELECT 1,  'Telephone',0,NULL,1 UNION ALL 
        SELECT 2,  'Fax',0,NULL,1 UNION ALL 
        SELECT 3,  'E-Mail',0,NULL,2 UNION ALL 
        SELECT 5,  'Business',0,NULL,1 UNION ALL 
        SELECT 12, 'Mobile',0,NULL,1 UNION ALL 
        SELECT 20, 'Web Site',0,NULL,1 UNION ALL 
        SELECT 21, 'Social Media',0,NULL,1

        SET IDENTITY_INSERT TRefContactType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (@ScriptGUID, @Comments, null, getdate() )
 
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