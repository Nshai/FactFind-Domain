 ----------------------------------------------------------------------------------------------
-- Table: FactFind.TAssetCategory
-- Summary: Fix Property Sector For AssetCategory 'Buy to Let Property'

-- Expected row counts:
-- (1 row affected)
-----------------------------------------------------------------------------------------------
 
USE FactFind
 
DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)
        , @StampActionCreate CHAR(1)
        , @StampDateTime DATETIME
        , @StampUser INT

SELECT 
    @ScriptGUID = '96667493-D80D-4C18-8229-9FB2AECCE8DC'
    , @Comments = 'TM-1805 Changed SectorName For AssetCategory Buy to Let Property on Property'
    , @StampActionCreate = 'U'
    , @StampDateTime = getdate()
    , @StampUser = 0

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

            UPDATE a
            SET [SectorName] = 'Property'
            OUTPUT   DELETED.[AssetCategoryId]
                    ,DELETED.[CategoryName]
                    ,DELETED.[SectorName]
                    ,DELETED.[IndigoClientId]
                    ,DELETED.[ConcurrencyId]
                    ,@StampActionCreate
                    ,@StampDateTime
                    ,@StampUser
            INTO [dbo].[TAssetCategoryAudit]
            (        [AssetCategoryId]
                    ,[CategoryName]
                    ,[SectorName]
                    ,[IndigoClientId]
                    ,[ConcurrencyId]
                    ,[StampAction]
                    ,[StampDateTime]
                    ,[StampUser]
            )
            FROM [dbo].[TAssetCategory] a
            WHERE a.[AssetCategoryId] = 16

            INSERT INTO TExecutedDataScript (ScriptGUID, Comments, TenantId, Timestamp) 
            VALUES (@ScriptGUID, @Comments, null, getdate())

    IF @starttrancount = 0 
        COMMIT TRANSACTION
END TRY
BEGIN CATCH

       DECLARE @ErrorSeverity INT
       DECLARE @ErrorState INT
       DECLARE @ErrorLine INT
       DECLARE @ErrorNumber INT

       SELECT @ErrorMessage = ERROR_MESSAGE(),
       @ErrorSeverity = ERROR_SEVERITY(),
       @ErrorState = ERROR_STATE(),
       @ErrorNumber = ERROR_NUMBER(),
       @ErrorLine = ERROR_LINE()

       /*Insert into logging table - IF ANY    */

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION

       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;