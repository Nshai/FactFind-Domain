USE [policymanagement];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)
/*
Summary
Add a new lifecycle rule to check vulnerability review date of the client for the related plans in GB/AU/US regions.
DatabaseName        TableName                       Expected Rows
policymanagement    dbo.TLifeCycleTransitionRule		1
*/

SELECT 
    @ScriptGUID = '46EF889C-09F4-4B7F-85BD-A90B103CF31B', 
    @Comments = 'SE-3353 Vulnerability Review Date lifecycle rule' 


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @LifeCycleRuleCategoryId INT
        ,@CategoryName VARCHAR(10) = 'Plan'
        ,@Code VARCHAR(150) = 'VULNERABILITYREVIEWDATE'
        ,@SP VARCHAR(150) = 'spCustomTransitionRule_CheckVulnerabilityReviewDate'
        ,@TimeStamp DATETIME = GETUTCDATE()
        ,@Name VARCHAR(50) = 'Check for Vulnerability Review Date'
        ,@Description VARCHAR (100) = 'Check that Vulnerability Review Date is null or past date'
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