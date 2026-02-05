USE [Administration];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @ErrorMessage VARCHAR(MAX)
	, @StampDateTime DATETIME
    , @StampUser INT
    , @StampActionCreate CHAR(1)
	, @SystemId INT
	, @RefLicenseTypeId INT

SELECT @ScriptGUID = 'A46DBAA4-16F2-4897-8E03-1A3A329BE74C'
    , @Comments = '202211051530_DEF-10030-0000_001-TRefLicenseTypeToSystem'
	, @StampDateTime = GETUTCDATE()
	, @StampUser = 0
	, @StampActionCreate = 'C'
	, @SystemId = 891
	, @RefLicenseTypeId = 5

-----------------------------------------------------------------------------------------------
-- Summary: DEF-9969 Insert necessary row into TRefLicenseTypeToSystem

-- Expected row counts: - if you know this
-- TRefLicenseTypeToSystem      (1 row(s) affected)
-- TRefLicenseTypeToSystemAudit (1 row(s) affected)
-----------------------------------------------------------------------------------------------

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
    BEGIN TRANSACTION
		   
        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] 
		WHERE SystemId = @SystemId AND RefLicenseTypeId = @RefLicenseTypeId)
        BEGIN
            INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                                ([RefLicenseTypeId]
                                ,[SystemId]
                                ,[ConcurrencyId])
            OUTPUT inserted.[RefLicenseTypeId]
                    ,inserted.[SystemId]
                    ,inserted.[ConcurrencyId]
                    ,inserted.[RefLicenseTypeToSystemId]
                    ,@StampActionCreate
                    ,@StampDateTime
                    ,@StampUser
            INTO [dbo].[TRefLicenseTypeToSystemAudit]
                    ([RefLicenseTypeId]
                    ,[SystemId]
                    ,[ConcurrencyId]
                    ,[RefLicenseTypeToSystemId]
                    ,[StampAction]
                    ,[StampDateTime]
                    ,[StampUser])
            SELECT 5
                    ,891
                    ,1
        END
        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)
    COMMIT TRANSACTION
END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

SET NOCOUNT OFF
SET XACT_ABORT OFF

RETURN; 