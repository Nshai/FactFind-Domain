USE [administration];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @ErrorMessage VARCHAR(MAX)
        , @StampActionDelete CHAR(1) = 'D'
        , @StampDateTime DATETIME = GETUTCDATE()
        , @StampUser VARCHAR(255) = '0'
        , @ModelPortfolioUSSystemId INT
        , @PublishedTabUSSystemId INT
        , @DraftTabUSSystemId INT
		, @starttrancount INT

SELECT 
    @ScriptGUID = '19B1E3E3-E1A7-4621-8B6F-3FE7B5BC6C54', 
    @Comments = 'IOTD-39 - Remove redundant model porfolio permissions'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;
/*
Summary
IOTD-38 - Remove redundant model porfolio permissions
DatabaseName        TableName      Expected Rows
administration    [TRefLicenseTypeToSystem]     3
administration    [TSystem]                     3
administration	  [TKey]						0-7 (depends on env)
*/

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION
    SELECT @ModelPortfolioUSSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'portfolioreporting.modelportfolio'

    SELECT @PublishedTabUSSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'portfolioreporting.modelportfolio.publishedmodels'

    SELECT @DraftTabUSSystemId = [SystemId]
    FROM [dbo].[TSystem]
    WHERE SystemPath = 'portfolioreporting.modelportfolio.draftmodels'

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
    WHERE SystemId in (@ModelPortfolioUSSystemId, @PublishedTabUSSystemId, @DraftTabUSSystemId)

    DELETE FROM TRefLicenseTypeToSystem
        OUTPUT DELETED.[RefLicenseTypeToSystemId],
        DELETED.[RefLicenseTypeId],
        DELETED.[SystemId],
        DELETED.[ConcurrencyId],
        @StampActionDelete,
        @StampDateTime,
        @StampUser
    INTO [dbo].[TRefLicenseTypeToSystemAudit]([RefLicenseTypeToSystemId], [RefLicenseTypeId], [SystemId], [ConcurrencyId], [StampAction], [StampDateTime], [StampUser])
    WHERE SystemId in (@ModelPortfolioUSSystemId, @PublishedTabUSSystemId, @DraftTabUSSystemId)

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
    WHERE SystemId in (@ModelPortfolioUSSystemId, @PublishedTabUSSystemId, @DraftTabUSSystemId)

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

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

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;