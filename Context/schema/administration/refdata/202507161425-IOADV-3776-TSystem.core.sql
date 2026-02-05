USE Administration

DECLARE @ScriptGUID uniqueidentifier,
        @Comments varchar(255),
        @ErrorMessage varchar(max), 
        @StampDateTime DATETIME,
        @StampActionUpdate CHAR(1),
        @StampUser INT,
        @ProposalSystemPath varchar(max),
        @TenantId INT

SELECT
    @ScriptGUID = '09EF0899-638D-4F18-AF1A-E9DAF75713AD',
    @Comments = 'IOADV-3776 - Rename Plan Servicing to Account Servicing',
    @StampDateTime = GETUTCDATE(),
    @StampActionUpdate = 'U',
    @StampUser = 0,
    @ProposalSystemPath = 'plan.actions.accountservicing'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY
        BEGIN TRANSACTION
      
        DECLARE 
			@ClientActionSystemId int,
			@ProposalSystemId int

        SET @ClientActionSystemId = (SELECT TOP 1 SystemId FROM [dbo].[TSystem] WHERE SystemPath = 'plan.actions.planservicing')
		
            BEGIN
                UPDATE TSystem
                SET 
                [Identifier] = 'accountservicing',
                [Description] = 'Account Servicing',
                [SystemPath] = @ProposalSystemPath
                WHERE SystemId=@ClientActionSystemId
               INSERT INTO TSystemAudit
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
               SELECT
                  [SystemId],
                  [Identifier],
                  [Description],
                  [SystemPath],
                  [SystemType],
                  [ParentId],
                  [Url],
                  [EntityId],
                  [ConcurrencyId],
                  @StampActionUpdate,
                  @StampDateTime,
                  @StampUser
              FROM TSystem
              WHERE [SystemId]=@ClientActionSystemId;
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