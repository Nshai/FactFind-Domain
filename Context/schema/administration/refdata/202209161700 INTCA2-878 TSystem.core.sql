USE [administration];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)
        , @SystemID VARCHAR(MAX)
        , @ParentSystemID VARCHAR(MAX)
        , @StampDateTime DATETIME
        , @StampUser INT
        , @StampActionCreate CHAR(1)
        , @IntConnectSystemPath varchar(max)

SELECT 
    @ScriptGUID = '0FEEDD69-9630-4ABE-8109-A71A67ACE52C',
    @Comments = 'INTCA2-878 Manage visibility of Intelliflo Connect button in ByFunctionalArea',
    @StampDateTime = GETUTCDATE(),
    @StampUser = 0,
    @StampActionCreate = 'C',
    @IntConnectSystemPath = 'toplevelnavigation.connect'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Manage visibility of Intelliflo Connect button in ByFunctionalArea

-- Expected row counts: - if you know this
-- TSystem (1 row(s) affected)
-- TRefLicenseTypeToSystem (1 row(s) affected)
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

        DECLARE 
            @ToplevelnavigationSystemId int,
            @IntConnectSystemId int

        SET @ToplevelnavigationSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = 'toplevelnavigation')


        IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @IntConnectSystemPath)
            BEGIN
                INSERT INTO TSystem ([Identifier], [Description], [SystemPath], [SystemType], [ParentId], [Url], [EntityId], [ConcurrencyId])
                OUTPUT 
                    INSERTED.[SystemId],
                    INSERTED.[Identifier],
                    INSERTED.[Description],
                    INSERTED.[SystemPath],
                    INSERTED.[SystemType],
                    INSERTED.[ParentId],
                    INSERTED.[Url],
                    INSERTED.[EntityId],
                    INSERTED.[ConcurrencyId],
                    @StampActionCreate,
                    @StampDateTime,
                    @StampUser
                INTO TSystemAudit
                (
                    [SystemId],
                    [Identifier],
                    [Description],
                    [SystemPath],
                    [SystemType],
                    [ParentId],
                    [Url],
                    [EntityId],
                    [ConcurrencyId],
                    [StampAction],
                    [StampDateTime],
                    [StampUser]
                )
                    VALUES ('intellifloconnect', 'Intelliflo connect', @IntConnectSystemPath, '-action', @ToplevelnavigationSystemId, NULL, NULL, 1)
            END

        SELECT @IntConnectSystemId = SystemID FROM TSystem WHERE SystemPath = @IntConnectSystemPath

        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @IntConnectSystemId)
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
            SELECT RefLicenseTypeId,
                    @IntConnectSystemId,
                    1
            FROM TRefLicenseType
        END

    IF @starttrancount = 0
        COMMIT TRANSACTION

    IF @starttrancount = 0
        BEGIN TRANSACTION

    INSERT INTO administration..TKey ([RightMask],[SystemId],[UserId],[RoleId],[ConcurrencyId])
    OUTPUT inserted.KeyId, inserted.RightMask, inserted.SystemId, inserted.UserId, inserted.RoleId, inserted.ConcurrencyId, 'C', @StampDateTime, @StampUser
    INTO administration..TKeyAudit (KeyId, RightMask, SystemId, UserId, RoleId, ConcurrencyId, StampAction, StampDateTime, StampUser)
    SELECT 1, @IntConnectSystemId, NULL, RoleId, 1
    FROM TRole

    INSERT administration..TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

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

       /*Insert into logging table - IF ANY	*/

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION

       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;