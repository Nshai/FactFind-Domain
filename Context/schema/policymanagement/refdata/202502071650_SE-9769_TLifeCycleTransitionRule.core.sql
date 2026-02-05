USE [policymanagement];


DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

/*
Summary
Add a new lifecycle rule to check mortgage completion date for the related plans in GB/AU regions.
DatabaseName        TableName                       Expected Rows
policymanagement    dbo.TLifeCycleTransitionRule    1
*/

SELECT 
    @ScriptGUID = 'E4710759-EBDB-4F43-B0C3-BB1471008E1E',
    @Comments = 'SE-9987 Mortgage completion date lifecycle rule'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @LifeCycleRuleCategoryId INT
        ,@CategoryName VARCHAR(10) = 'Plan'
        ,@Code VARCHAR(150) = 'MORTGAGEPLANCOMPLETIONDATE'
        ,@SP VARCHAR(150) = 'SpCustomTransitionRule_CheckMortgageCompletionDate'
        ,@TimeStamp DATETIME = GETUTCDATE()
        ,@Name VARCHAR(50) = 'Check for Mortgage Completion Date'
        ,@Description VARCHAR (100) = 'Check that mortgage have the completion date'
        ,@TenantId INT = null
        ,@ConcurrencyId INT = 1

BEGIN TRY

    SELECT @LifeCycleRuleCategoryId = RefLifecycleRuleCategoryId 
    FROM TRefLifecycleRuleCategory
    WHERE CategoryName = @CategoryName;

        BEGIN TRANSACTION


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