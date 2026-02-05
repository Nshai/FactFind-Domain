USE [administration];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)
        , @StampActionDelete CHAR(1) = 'D'
        , @StampDateTime DATETIME = GETUTCDATE()
        , @StampUser VARCHAR(255) = '0'
        , @CreateAcatTransferSystemId INT
        , @CreateTransferPlanActionSystemId INT
        , @TransfersSystemId INT
        , @CreateTransferClientActionSystemId INT
        , @TransfersFullListSystemId INT
        , @PeriodicOrdersSystemId INT
        , @TransferExceptionsSystemId INT
        , @PortfolioAccountsUnderManagementSystemId INT

SELECT 
    @ScriptGUID = 'B4A4C617-C877-4057-BDC0-1402FE89AE7A', 
    @Comments = 'IOTD-59 - Remove Transfers (MM) and Orders (SWPs & PIPs) permissions'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;
/*
Summary
IOTD-59 - Remove Transfers (MM) and Orders (SWPs & PIPs) permissions
DatabaseName        TableName      Expected Rows
administration    [TRefLicenseTypeToSystem]     8
administration    [TSystem]                     8
administration	  [TKey]						depends on env
*/

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

    SELECT @CreateAcatTransferSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'plan.actions.createacattransfer'

    SELECT @CreateTransferPlanActionSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'plan.actions.createtransfer'

    SELECT @TransfersSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'adviserworkplace.clients.plans.transfers'

    SELECT @CreateTransferClientActionSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'client.actions.createtransfer'

    SELECT @TransfersFullListSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'adviserworkplace.clients.plans.transfersfulllist'

    SELECT @PeriodicOrdersSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'adviserworkplace.clients.plans.periodicorders'

    SET @TransferExceptionsSystemId = (
        SELECT TOP 1
            [SystemId]
        FROM
            [dbo].[TSystem]
        WHERE
            SystemPath = 'portfolioreporting.reports.transferexceptions' AND SystemType = '-function'
    );

    Set @PortfolioAccountsUnderManagementSystemId = (
        SELECT TOP 1
            [SystemId]
        FROM
            [dbo].[TSystem]
        WHERE SystemPath = 'portfolioreporting.reports.accountsundermanagement' and SystemType = '-function'
    );

    DELETE FROM TKey
    OUTPUT DELETED.[KeyId]
      ,DELETED.[RightMask]
      ,DELETED.[SystemId]
      ,DELETED.[UserId]
      ,DELETED.[RoleId]
      ,DELETED.[ConcurrencyId]
      ,@StampActionDelete
      ,@StampDateTime
      ,@StampUser
    INTO TKeyAudit(KeyId
      ,[RightMask]
      ,[SystemId]
      ,[UserId]
      ,[RoleId]
      ,[ConcurrencyId]
      ,[StampAction]
      ,[StampDateTime]
      ,[StampUser])
    WHERE SystemId in (@CreateAcatTransferSystemId, @CreateTransferPlanActionSystemId, @TransfersSystemId, 
    @CreateTransferClientActionSystemId, @TransfersFullListSystemId, @PeriodicOrdersSystemId, @TransferExceptionsSystemId, @PortfolioAccountsUnderManagementSystemId)

    DELETE FROM TRefLicenseTypeToSystem
        OUTPUT DELETED.[RefLicenseTypeToSystemId],
        DELETED.[RefLicenseTypeId],
        DELETED.[SystemId],
        DELETED.[ConcurrencyId],
        @StampActionDelete,
        @StampDateTime,
        @StampUser
    INTO [dbo].[TRefLicenseTypeToSystemAudit]([RefLicenseTypeToSystemId], [RefLicenseTypeId], [SystemId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
    WHERE SystemId in (@CreateAcatTransferSystemId, @CreateTransferPlanActionSystemId, @TransfersSystemId, 
    @CreateTransferClientActionSystemId, @TransfersFullListSystemId, @PeriodicOrdersSystemId, @TransferExceptionsSystemId, @PortfolioAccountsUnderManagementSystemId)

    DELETE FROM TSystem
        OUTPUT  DELETED.[SystemId],
        DELETED.[Identifier],
        DELETED.[Description],
        DELETED.[SystemPath],
        DELETED.[SystemType],
        DELETED.[ParentId],
        DELETED.[Url],
        DELETED.[EntityId],
        DELETED.[ConcurrencyId],
        @StampActionDelete,
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
    WHERE SystemId in (@CreateAcatTransferSystemId, @CreateTransferPlanActionSystemId, @TransfersSystemId, 
    @CreateTransferClientActionSystemId, @TransfersFullListSystemId, @PeriodicOrdersSystemId, @TransferExceptionsSystemId, @PortfolioAccountsUnderManagementSystemId)

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