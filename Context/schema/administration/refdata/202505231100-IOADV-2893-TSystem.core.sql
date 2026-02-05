USE Administration

DECLARE @ScriptGUID uniqueidentifier,
        @Comments varchar(255),
        @ErrorMessage varchar(max), 
        @StampDateTime DATETIME,
        @StampActionCreate CHAR(1),
        @StampUser INT,
        @ProposalSystemPath varchar(max),
        @TenantId INT

SELECT
    @ScriptGUID = '39A6F549-6A38-4999-A286-CAFD58432C8C',
    @Comments = 'IOADV-2893 - Plan Servicing action and permissions',
    @StampDateTime = GETUTCDATE(),
    @StampActionCreate = 'C',
    @StampUser = 0,
    @ProposalSystemPath = 'plan.actions.planservicing'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT
        @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

        DECLARE 
			@ClientActionSystemId int,
			@ProposalSystemId int,
			@RefLicenseTypeIdFull int

        SET @ClientActionSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = 'plan.actions')
		
        IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @ProposalSystemPath)
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
                    VALUES ('planservicing', 'Plan Servicing', @ProposalSystemPath, '+subaction', @ClientActionSystemId, NULL, NULL, 1)
            END

        SELECT @ProposalSystemId = SystemID
        FROM TSystem
        WHERE SystemPath = @ProposalSystemPath

        IF NOT EXISTS(SELECT 1 FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @ProposalSystemId)
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
                       @ProposalSystemId,
                       1
                FROM TRefLicenseType WHERE LicenseTypeName IN ('full', 'mortgage')
		END

INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

IF @starttrancount = 0
	COMMIT TRANSACTION
END TRY
BEGIN CATCH

    DECLARE @ErrorSeverity int
    DECLARE @ErrorState int
    DECLARE @ErrorLine int
    DECLARE @ErrorNumber int

    SELECT
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE(),
        @ErrorNumber = ERROR_NUMBER(),
        @ErrorLine = ERROR_LINE()

    /*Insert into logging table - IF ANY    */

    IF XACT_STATE() <> 0
        AND @starttrancount = 0
        ROLLBACK TRANSACTION

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN; 