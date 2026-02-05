USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @MiReportsSystemId INT
      , @MiReportsSystemPath VARCHAR(256) = 'mi'
      , @DataSharingSystemPath VARCHAR(256) = 'mi.datasharing'
      , @SystemType VARCHAR(10) = '-system'
      , @StampDateTime DATETIME = GETUTCDATE()
      , @StampAction CHAR(1) = 'C'
      , @StampUser INT = 0
      , @ConcurrencyId INT = 1

SELECT @ScriptGUID = '880C2331-F435-4AC2-85DF-86D05D4929D6'
      ,@Comments = 'IOSMI-1218 TSystem Add new security items by functional area for Data Sharing'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

/*
Expected row counts:

DatabaseName        TableName                       Expected Rows
=================================================================
administration      TSystem                         1
administration      TSystemAudit                    1
*/

SET NOCOUNT ON
SET XACT_ABORT ON

SET @MiReportsSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = @MiReportsSystemPath)

BEGIN TRY

    BEGIN TRANSACTION

        -- Insert Data Sharing node under MI Reports node.
        IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @DataSharingSystemPath)
        BEGIN
            INSERT INTO [dbo].[TSystem]
                ([Identifier]
                ,[Description]
                ,[SystemPath]
                ,[SystemType]
                ,[ParentId]
                ,[ConcurrencyId])
            OUTPUT 
                 INSERTED.[SystemId]
                ,INSERTED.[Identifier]
                ,INSERTED.[Description]
                ,INSERTED.[SystemPath]
                ,INSERTED.[SystemType]
                ,INSERTED.[ParentId]
                ,INSERTED.[Url]
                ,INSERTED.[EntityId]
                ,INSERTED.[ConcurrencyId]
                ,INSERTED.[Order]
                ,@StampAction
                ,@StampDateTime
                ,@StampUser
            INTO TSystemAudit
                ([SystemId]
                ,[Identifier]
                ,[Description]
                ,[SystemPath]
                ,[SystemType]
                ,[ParentId]
                ,[Url]
                ,[EntityId]
                ,[ConcurrencyId]
                ,[Order]
                ,[StampAction]
                ,[StampDateTime]
                ,[StampUser])
            VALUES
                ('datasharing'
                ,'Data Sharing'
                ,@DataSharingSystemPath
                ,@SystemType
                ,@MiReportsSystemId
                ,@ConcurrencyId)
        END

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;