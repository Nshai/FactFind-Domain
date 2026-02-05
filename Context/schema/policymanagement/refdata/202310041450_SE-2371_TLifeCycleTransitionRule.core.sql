USE [policymanagement];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
/*
Summary
Add a new lifecycle rule to check expected payment date for plans in GB/AU/US regions.

DatabaseName        TableName                       Expected Rows
policymanagement    dbo.TLifeCycleTransitionRule        1
*/

SELECT 
    @ScriptGUID = '2273E053-658A-4C21-ACFA-C411CF5A4A40', 
    @Comments = 'SE-2371 Adding new life cycle rule - Expected Payment Date' 


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount INT
        ,@LifeCycleRuleCategoryId INT
        ,@CategoryName VARCHAR(10) = 'Plan'
        ,@Code VARCHAR(150) = 'EXPECTEDPAYMENTDATE'
        ,@SP VARCHAR(150) = 'spCustomTransitionRule_CheckPlanExpectedPaymentDate'
        ,@TimeStamp DATETIME = GETUTCDATE()
        ,@Name VARCHAR(50) = 'Check for Expected Payment Date'
        ,@Description VARCHAR (50) = 'Checks that Expected Payment Date has been added'
        ,@TenantId INT = null
        ,@ConcurrencyId INT = 1

BEGIN TRY

    SELECT @starttrancount = @@TRANCOUNT

    SELECT @LifeCycleRuleCategoryId = RefLifecycleRuleCategoryId 
    FROM TRefLifecycleRuleCategory
    WHERE CategoryName = @CategoryName;

    IF @starttrancount = 0
        BEGIN TRANSACTION

            -- BEGIN DATA INSERT

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

           -- END DATA INSERT

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
 