USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @PersonalPensionPlanTypeId int = 3
/*
Summary
Set IsWrapperFg for Personal Pension Plan type GB

DatabaseName        TableName      Expected Rows
PolicyManagement    TRefPlanType   1
*/


SELECT 
    @ScriptGUID = 'A986557F-BDD6-4B76-965C-76A1A94F31A2',
    @Comments = 'IOSE22-2592 Allow Subplans for Personal Pension Plan'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

    BEGIN TRANSACTION

    EXEC SpNAuditRefPlanType 0,  @PersonalPensionPlanTypeId, 'U'

    UPDATE TRefPlanType
    SET IsWrapperFg = 1
    WHERE RefPlanTypeId = @PersonalPensionPlanTypeId

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