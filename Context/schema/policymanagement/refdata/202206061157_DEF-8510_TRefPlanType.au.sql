USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @RefPlanTypeId int = 1073

/*
Summary
Set IsWrapperFg for plan type AU

DatabaseName        TableName      Expected Rows
PolicyManagement    TRefPlanType   1
*/


SELECT 
    @ScriptGUID = 'AB322899-ECC6-4AEB-A1EB-7F024C722AF7', 
    @Comments = 'DEF-8510 Set IsWrapperFg for plan type AU'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

    BEGIN TRANSACTION

    EXEC SpNAuditRefPlanType 0, @RefPlanTypeId, 'U'

    UPDATE TRefPlanType
    SET IsWrapperFg = 1
    WHERE RefPlanTypeId = @RefPlanTypeId

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
