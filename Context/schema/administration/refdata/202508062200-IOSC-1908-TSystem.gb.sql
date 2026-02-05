USE administration;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)

/*
Summary
****************************************************
Update security flag on application tab

DatabaseName        TableName               Expected Rows
************************************************************
Administration      TSystem                     3
*/

SELECT 
    @ScriptGUID = 'DC7999AB-209A-463A-B47D-4007B69D02C2', 
    @Comments = 'IOSC: 1897 Update security flag on application tab'  

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION
       
        UPDATE [dbo].[TSystem]
        SET [Description] = 'Applications'
        OUTPUT
            deleted.Identifier,
            deleted.[Description],
            deleted.SystemPath,
            deleted.SystemType,
            deleted.ParentId,
            deleted.[Url],
            deleted.EntityId,
            deleted.ConcurrencyId,
            deleted.SystemId,
            deleted.[Order],
            'U',
            GETUTCDATE(),
            0
        INTO [dbo].[TSystemAudit] (
            [Identifier],
            [Description],
            [SystemPath],
            [SystemType],
            [ParentId],
            [Url],
            [EntityId],
            [ConcurrencyId],
            [SystemId],
            [Order],
            [StampAction],
            [StampDateTime],
            [StampUser]
        )
        WHERE SystemPath = 'portfolio' and SystemType = '+entity'

        UPDATE [dbo].[TSystem]
        SET [Description] = 'Create/Update/Delete Applications'
        OUTPUT
            deleted.Identifier,
            deleted.[Description],
            deleted.SystemPath,
            deleted.SystemType,
            deleted.ParentId,
            deleted.[Url],
            deleted.EntityId,
            deleted.ConcurrencyId,
            deleted.SystemId,
            deleted.[Order],
            'U',
            GETUTCDATE(),
            0
        INTO [dbo].[TSystemAudit] (
            [Identifier],
            [Description],
            [SystemPath],
            [SystemType],
            [ParentId],
            [Url],
            [EntityId],
            [ConcurrencyId],
            [SystemId],
            [Order],
            [StampAction],
            [StampDateTime],
            [StampUser]
        )
        WHERE SystemPath = 'adviserworkplace.fundanalysis.actions.manageportfolio' and SystemType = '+subaction'

        UPDATE [dbo].[TSystem]
        SET [Description] = 'Applications'
        OUTPUT
            deleted.Identifier,
            deleted.[Description],
            deleted.SystemPath,
            deleted.SystemType,
            deleted.ParentId,
            deleted.[Url],
            deleted.EntityId,
            deleted.ConcurrencyId,
            deleted.SystemId,
            deleted.[Order],
            'U',
            GETUTCDATE(),
            0
        INTO [dbo].[TSystemAudit] (
            [Identifier],
            [Description],
            [SystemPath],
            [SystemType],
            [ParentId],
            [Url],
            [EntityId],
            [ConcurrencyId],
            [SystemId],
            [Order],
            [StampAction],
            [StampDateTime],
            [StampUser]
        )
        WHERE SystemPath = 'portfolioreporting' and SystemType = '-application'	    
        
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