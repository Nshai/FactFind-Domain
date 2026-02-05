USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @FundRefPlanTypeId int = 1072
/*
Summary
Set IsWrapperFg for plan type AU

DatabaseName        TableName      Expected Rows
PolicyManagement    TRefPlanType   1
*/


SELECT 
    @ScriptGUID = 'F8D16DA7-190B-4791-BDD5-E564DC232089', 
    @Comments = 'IOSE22-952 Superannuation products need to be wrapper-style products. iO side'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

    BEGIN TRANSACTION

    EXEC SpNAuditRefPlanType 0,  @FundRefPlanTypeId, 'U'

    UPDATE TRefPlanType
    SET IsWrapperFg = 1
    WHERE RefPlanTypeId = @FundRefPlanTypeId

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
