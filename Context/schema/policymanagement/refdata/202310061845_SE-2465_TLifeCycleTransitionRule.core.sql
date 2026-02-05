USE [policymanagement];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
/*
Summary
Add a new lifecycle rule to check policy end date for plans in GB/AU/US regions.

DatabaseName        TableName                       Expected Rows
Policymanagement    dbo.TLifeCycleTransitionRule        1
*/

SELECT 
    @ScriptGUID = '5ED7EF90-B1D4-403D-869C-41C16C9F287A', 
    @Comments = 'SE-2465 Adding new life cycle rule - Policy End Date' 


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT
        ,@LifeCycleRuleCategoryId INT
        ,@CategoryName VARCHAR(10) = 'Plan'
        ,@Code VARCHAR(150) = 'POLICYENDDATE'
        ,@SP VARCHAR(150) = 'spCustomTransitionRule_CheckPolicyEndDate'
        ,@TimeStamp DATETIME = GETUTCDATE()
        ,@Name VARCHAR(50) = 'Check for Policy End Date'
        ,@Description VARCHAR (50) = 'Checks that Policy End Date has been added'
        ,@TenantId INT = null
        ,@ConcurrencyId INT = 1

BEGIN TRY

    SELECT @starttrancount = @@TRANCOUNT

    SELECT @LifeCycleRuleCategoryId = RefLifecycleRuleCategoryId 
    FROM TRefLifecycleRuleCategory
    WHERE CategoryName = @CategoryName;

    IF @starttrancount = 0
        BEGIN TRANSACTION

            /* BEGIN DATA INSERT*/

            INSERT dbo.TLifeCycleTransitionRule
                    ([TenantId]
                    ,[Name]
                    ,[Code]
                    ,[Description]
                    ,[SpName]
                    ,[ConcurrencyId]
                    ,[RefLifecycleRuleCategoryId])
           OUTPUT
                     inserted.[TenantId]
                    ,inserted.[Name]
                    ,inserted.[Code]
                    ,inserted.[Description]
                    ,inserted.[SpName]
                    ,inserted.[ConcurrencyId]
                    ,inserted.[LifeCycleTransitionRuleId]
                    ,'C'
                    ,@TimeStamp
                    ,'0'
                    ,inserted.[RefLifecycleRuleCategoryId]
           INTO [dbo].[TLifeCycleTransitionRuleAudit]
                    ([TenantId]
                    ,[Name]
                    ,[Code]
                    ,[Description]
                    ,[SpName]
                    ,[ConcurrencyId]
                    ,[LifeCycleTransitionRuleId]
                    ,[StampAction]
                    ,[StampDateTime]
                    ,[StampUser]
                    ,[RefLifecycleRuleCategoryId])    
           VALUES  (@TenantId
                    ,@Name
                    ,@Code
                    ,@Description
                    ,@SP
                    ,@ConcurrencyId
                    ,@LifeCycleRuleCategoryId);

           /* END DATA INSERT */

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

    /*Insert into logging table - IF ANY	*/

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;
 