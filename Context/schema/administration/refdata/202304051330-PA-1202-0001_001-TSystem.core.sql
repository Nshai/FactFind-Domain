USE Administration


DECLARE @ScriptGUID UNIQUEIDENTIFIER,
    @Comments VARCHAR(255),
    @ErrorMessage VARCHAR(MAX),
    @StampDateTime DATETIME,
    @StampActionCreate CHAR(1),
    @StampUser INT,
    @PortfolioSystemPath VARCHAR(MAX),
    @ModelPortfolioSystemPath VARCHAR(MAX),
    @PublishedModelsSystemPath VARCHAR(MAX),
    @DraftModelsSystemPath VARCHAR(MAX),
    @PortfolioSystemId INT,
    @ModelPortfolioSystemId INT,
    @ApplicationType VARCHAR(MAX),
    @SystemType VARCHAR(MAX)

SELECT @ScriptGUID = 'DDF946E9-E5D7-40EF-AEAD-A3724D30238F'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SELECT
    @Comments = 'PA-1202 - Create portfolio models permissions tree',
    @StampDateTime = GETUTCDATE(),
    @StampActionCreate = 'C',
    @StampUser = 0,
    @PortfolioSystemPath = 'portfolioreporting',
    @ModelPortfolioSystemPath = 'portfolioreporting.modelportfolio',
    @PublishedModelsSystemPath = 'portfolioreporting.modelportfolio.publishedmodels',
    @DraftModelsSystemPath = 'portfolioreporting.modelportfolio.draftmodels',
    @ApplicationType = '-application',
    @SystemType = '-system'

-----------------------------------------------------------------------------------------------
-- Summary: Add portfolio models permissions tree

-- Expected row counts:
-- TSystem (3 row(s) affected)
-----------------------------------------------------------------------------------------------


SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT

BEGIN TRY
    SELECT
        @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

    SELECT @PortfolioSystemId = SystemId
    FROM TSystem
    WHERE SystemPath = @PortfolioSystemPath AND SystemType = @ApplicationType

    ------ Add Model Portfolio permission (portfolioreporting.modelportfolio) ------
    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @ModelPortfolioSystemPath AND SystemType = @SystemType)
    BEGIN
        INSERT INTO TSystem (
            [Identifier],
            [Description],
            [SystemPath],
            [SystemType],
            [ParentId],
            [Url],
            [EntityId],
            [ConcurrencyId]
        )
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
        VALUES (
            'modelportfolio',
            'Model Portfolio',
            @ModelPortfolioSystemPath,
            @SystemType,
            @PortfolioSystemId,
            NULL,
            NULL,
            1
        )
    END

    SELECT @ModelPortfolioSystemId = SystemId
    FROM TSystem
    WHERE SystemPath = @ModelPortfolioSystemPath AND SystemType = @SystemType

    ------ Add Draft Models permission (portfolioreporting.modelportfolio.draftmodels) ------
    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @DraftModelsSystemPath AND SystemType = @SystemType)
    BEGIN
        INSERT INTO TSystem (
            [Identifier],
            [Description],
            [SystemPath],
            [SystemType],
            [ParentId],
            [Url],
            [EntityId],
            [ConcurrencyId]
        )
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
        VALUES (
            'draftmodels',
            'Draft Models',
            @DraftModelsSystemPath,
            @SystemType,
            @ModelPortfolioSystemId,
            NULL,
            NULL,
            1
        )
    END

	------ Add Published Models permission (portfolioreporting.modelportfolio.publishedmodels) ------
    IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @PublishedModelsSystemPath AND SystemType = @SystemType)
    BEGIN
        INSERT INTO TSystem (
            [Identifier],
            [Description],
            [SystemPath],
            [SystemType],
            [ParentId],
            [Url],
            [EntityId],
            [ConcurrencyId]
        )
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
        VALUES (
            'publishedmodels',
            'Published Models',
            @PublishedModelsSystemPath,
            @SystemType,
            @ModelPortfolioSystemId,
            NULL,
            NULL,
            1
        )
    END


    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

IF @starttrancount = 0
    COMMIT TRANSACTION
END TRY
BEGIN CATCH

    DECLARE @ErrorSeverity INT
    DECLARE @ErrorState INT
    DECLARE @ErrorLine INT
    DECLARE @ErrorNumber INT

    SELECT
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorLine = ERROR_LINE()

    /* Insert into logging table - IF ANY */

    IF XACT_STATE() <> 0
        AND @starttrancount = 0
        ROLLBACK TRANSACTION

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN; 