USE administration;

DECLARE 
	@DashboardComponentId INT,
	@DashboardIdentifier VARCHAR(255),
	@DefaultAssigneValue VARCHAR(10),
	@ScriptGUID uniqueidentifier,
	@Comments VARCHAR(255),
	@ErrorMessage VARCHAR(MAX),
	@StampDateTime DATETIME,
    @StampActionCreate CHAR(1),
    @StampUser INT
			   
SELECT 
	@ScriptGUID = 'A2ACFD13-70E8-44C4-895E-04CE6584C614',
	@Comments = 'AIOPB-886 All existing roles are assigned to the "Advices" dashboard widget by default',
	@DashboardIdentifier = 'advice',
	@DefaultAssigneValue = 'false',
    @StampDateTime = GETUTCDATE(),
    @StampActionCreate = 'U',
    @StampUser = 0

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: AIOPB-886 All existing roles are assigned to the "Advices" dashboard widget by default 
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @Starttrancount int

BEGIN TRY

	SELECT
        @Starttrancount = @@TRANCOUNT
		IF @Starttrancount = 0

        BEGIN TRANSACTION

		SET @DashboardComponentId = (SELECT TOP 1 DashboardComponentId 
								 FROM TDashboardComponent 
								 WHERE Identifier = @DashboardIdentifier);

		UPDATE TDashboardComponentPermissions
			SET isAllowed = @DefaultAssigneValue
			OUTPUT 
				INSERTED.[ConcurrencyId],
				INSERTED.[DashboardComponentId],
				INSERTED.[DashboardComponentPermissionsId],
				INSERTED.[isAllowed],
				INSERTED.[RoleId],
				@StampActionCreate,
				@StampDateTime,
				@StampUser
			INTO TDashboardComponentPermissionsAudit
                (
				[ConcurrencyId],
				[DashboardComponentId],
				[DashboardComponentPermissionsId],
				[isAllowed],
				[RoleId],
				[StampAction],
				[StampDateTime],
				[StampUser]
                )
			WHERE DashboardComponentId = @DashboardComponentId;

		INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

	IF @Starttrancount = 0
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

       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;