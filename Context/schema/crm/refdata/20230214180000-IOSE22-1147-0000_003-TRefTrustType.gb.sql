USE CRM
 
DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)

SELECT
    @ScriptGUID = '05611CB6-44C5-4733-8CAC-36C226CEDD9E',
    @Comments = 'IOSE22-1147 - New Trust Types for GB region'

IF EXISTS (
   SELECT 1 FROM TExecutedDataScript
   WHERE ScriptGuid = @ScriptGUID
) RETURN

SET NOCOUNT ON 
SET XACT_ABORT ON

DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
    SET IDENTITY_INSERT TRefTrustType ON; 

    INSERT INTO dbo.TRefTrustType([RefTrustTypeId], [TrustTypeName], [ArchiveFG], [Extensible], [ConcurrencyId])
        OUTPUT                                   
            inserted.TrustTypeName
            ,inserted.ArchiveFG
            ,inserted.ConcurrencyId
            ,inserted.RefTrustTypeId
            ,'C'
            ,GETUTCDATE()
            ,'0'
            INTO
            dbo.TRefTrustTypeAudit
            (
                [TrustTypeName],
                [ArchiveFG],
                [ConcurrencyId],
                [RefTrustTypeId],
                [StampAction],
                [StampDateTime],
                [StampUser]
            )
        SELECT  9, 'Personal Injury',0,NULL,1 UNION ALL  
        SELECT  10, 'Pension',0,NULL,1 UNION ALL 
        SELECT  11, 'Loan',0,NULL,1 UNION ALL 
        SELECT  12, 'Charitable',0,NULL,1 
 
        SET IDENTITY_INSERT TRefTrustType OFF
 
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         @ScriptGUID, 
         @Comments,
         null, 
         GETUTCDATE() )
 
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

