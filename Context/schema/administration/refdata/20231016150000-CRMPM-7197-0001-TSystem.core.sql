USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
      , @StampDateTime DATETIME = GETUTCDATE()
      , @StampAction CHAR(1) = 'U'
      , @StampUser INT = 0

SELECT @ScriptGUID = '34AE4B0A-EF3D-4A8F-B271-7044E65901F1'
      , @Comments = 'CRMPM-6538 Rename Mi Reports everywhere'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

BEGIN TRANSACTION

    BEGIN TRY

        UPDATE TSystem
        SET Description = 'Business Intelligence'
          , ConcurrencyId = ConcurrencyId + 1
        OUTPUT
            DELETED.[Identifier]
          , DELETED.[Description]
          , DELETED.[SystemPath]
          , DELETED.[SystemType]
          , DELETED.[ParentId]
          , DELETED.[Url]
          , DELETED.[EntityId]
          , DELETED.[ConcurrencyId]
          , DELETED.[SystemId]
          , DELETED.[Order]
          , @StampAction
          , @StampDateTime
          , @StampUser
        INTO TSystemAudit
            ([Identifier]
          , [Description]
          , [SystemPath]
          , [SystemType]
          , [ParentId]
          , [Url]
          , [EntityId]
          , [ConcurrencyId]
          , [SystemId]
          , [Order]
          , [StampAction]
          , [StampDateTime]
          , [StampUser])
        WHERE SystemPath = 'mi'

        UPDATE TSystem
        SET Description = 'MI Reports'
          , ConcurrencyId = ConcurrencyId + 1
        OUTPUT
            DELETED.[Identifier]
          , DELETED.[Description]
          , DELETED.[SystemPath]
          , DELETED.[SystemType]
          , DELETED.[ParentId]
          , DELETED.[Url]
          , DELETED.[EntityId]
          , DELETED.[ConcurrencyId]
          , DELETED.[SystemId]
          , DELETED.[Order]
          , @StampAction
          , @StampDateTime
          , @StampUser
        INTO TSystemAudit
            ([Identifier]
          , [Description]
          , [SystemPath]
          , [SystemType]
          , [ParentId]
          , [Url]
          , [EntityId]
          , [ConcurrencyId]
          , [SystemId]
          , [Order]
          , [StampAction]
          , [StampDateTime]
          , [StampUser])
        WHERE SystemPath = 'mi.reportlist'

    END TRY
    BEGIN CATCH

        SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
        WHILE(@@TRANCOUNT > 0)ROLLBACK
        RETURN

    END CATCH

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

COMMIT TRANSACTION

-- Check for ANY open transactions
-- This applies not only to THIS script but will rollback any open transactions in any scripts that have been run before this one.
IF @@TRANCOUNT > 0
BEGIN
       ROLLBACK
       RETURN
       PRINT 'Open transaction found, aborting'
END

RETURN;