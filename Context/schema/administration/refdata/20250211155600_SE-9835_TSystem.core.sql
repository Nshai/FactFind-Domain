USE Administration

DECLARE @ScriptGUID UNIQUEIDENTIFIER
    , @Comments VARCHAR(255)
    , @ErrorMessage VARCHAR(MAX)


SELECT @ScriptGUID = '977D996B-D970-49CD-9FDF-238867000F3C'
     , @Comments = 'SE-9835: Permission to link model porfolio to plan.'

IF EXISTS (SELECT 1
           FROM [administration]..TExecutedDataScript
           WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

    DECLARE @LinkToMPActionId INT;

    /* Add "Link To Model Portfolio" action access setting to admin area */
    DECLARE @ParentSystemId INT;

    SELECT @ParentSystemId = SystemID
    FROM [administration]..TSystem
    WHERE SystemPath = 'plan.actions'

    INSERT INTO [administration]..TSystem
    ([Identifier],
     [Description],
     [SystemPath],
     [SystemType],
     [ParentId],
     [Url],
     [EntityId],
     [ConcurrencyId])
    OUTPUT inserted.[Identifier],
           inserted.[Description],
           inserted.[SystemPath],
           inserted.[SystemType],
           inserted.[ParentId],
           inserted.[Url],
           inserted.[EntityId],
           inserted.[ConcurrencyId],
           inserted.[SystemId], 'C', GETDATE(), 0
        INTO [TSystemAudit]
        (
         [Identifier],
         [Description],
         [SystemPath],
         [SystemType],
         [ParentId],
         [Url],
         [EntityId],
         [ConcurrencyId],
         [SystemId],
         [StampAction],
         [StampDateTime],
         [StampUser]
            )
    VALUES ('linktomodelporfolio',
            'Link to Model Portfolio',
            'plan.actions.linktomodelporfolio',
            '+subaction',
            @ParentSystemId,
            NULL,
            NULL,
            1);

    SELECT @LinkToMPActionId = [SystemID]
    FROM [TSystem]
    WHERE [Identifier] = 'linktomodelporfolio'

    INSERT INTO [administration]..[TRefLicenseTypeToSystem]
    ([RefLicenseTypeId],
     [SystemId],
     [ConcurrencyId])
    OUTPUT inserted.[RefLicenseTypeId],
           inserted.[SystemId],
           inserted.[ConcurrencyId],
           inserted.[RefLicenseTypeToSystemId], 'C', GETDATE(), 0
        INTO [TRefLicenseTypeToSystemAudit]
        (
         [RefLicenseTypeId],
         [SystemId],
         [ConcurrencyId],
         [RefLicenseTypeToSystemId],
         [StampAction],
         [StampDateTime],
         [StampUser]
            )
    SELECT LTS.RefLicenseTypeId, @LinkToMPActionId, 1
    FROM [administration]..TRefLicenseType LT
             INNER JOIN [administration]..[TRefLicenseTypeToSystem] LTS ON LT.RefLicenseTypeId = LTS.RefLicenseTypeId
    WHERE LTS.SystemId = @ParentSystemId

    INSERT INTO [TKey]
    ([SystemId],
     [RightMask],
     [UserId],
     [RoleId],
     [ConcurrencyId])
    OUTPUT inserted.[RightMask],
           inserted.[SystemId],
           inserted.[UserId], NULL,
           inserted.[RoleId],
           inserted.[ConcurrencyId],
           inserted.[KeyId], 'C', GETDATE(), 0
        INTO [TKeyAudit]
        (
         [RightMask],
         [SystemId],
         [UserId],
         [Extensible],
         [RoleId],
         [ConcurrencyId],
         [KeyId],
         [StampAction],
         [StampDateTime],
         [StampUser]
            )
    SELECT @LinkToMPActionId AS [SystemId]
         , 0                 AS [RightMask]
         , m.[UserId]
         , r.[RoleId]
         , 1                 AS [ConcurrencyId]
    FROM [TRole] AS r WITH (NOLOCK)
             INNER JOIN [TMembership] AS m WITH (NOLOCK) ON m.RoleId = r.RoleId
    UNION ALL
    SELECT @LinkToMPActionId AS [SystemId]
         , 0                 AS [RightMask]
         , NULL              AS [UserId]
         , r.[RoleId]
         , 1                 AS [ConcurrencyId]
    FROM [TRole] AS r WITH (NOLOCK)

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

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

    ROLLBACK TRANSACTION

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;