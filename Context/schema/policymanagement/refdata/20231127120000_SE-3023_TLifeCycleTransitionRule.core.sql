USE [policymanagement];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
/*
Summary
Add a new lifecycle rule to check contribution start date for plans in GB/AU/US regions.

DatabaseName        TableName                       Expected Rows
policymanagement    dbo.TPolicyMoneyIn					1
*/

SELECT 
    @ScriptGUID = '14CD21BB-C4CE-4364-AFC7-7C684D512928', 
    @Comments = 'SE-3023 New Lifecycle rule - Check contribution start date' 


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @LifeCycleRuleCategoryId INT
        ,@CategoryName VARCHAR(10) = 'Plan'
        ,@Code VARCHAR(150) = 'CONTRIBUTIONSTARTDATE'
        ,@SP VARCHAR(150) = 'spCustomTransitionRule_CheckContributionStartDate'
        ,@TimeStamp DATETIME = GETUTCDATE()
        ,@Name VARCHAR(50) = 'Check for Contribution Start Date'
        ,@Description VARCHAR (100) = 'Check that Contribution Start Date has been added'
        ,@TenantId INT = null
        ,@ConcurrencyId INT = 1

BEGIN TRY

    SELECT @LifeCycleRuleCategoryId = RefLifecycleRuleCategoryId 
    FROM TRefLifecycleRuleCategory
    WHERE CategoryName = @CategoryName;

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

        COMMIT TRANSACTION

END TRY
BEGIN CATCH
    
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    ;THROW

END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;
 