USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @FundRefPlanTypeId int = 1043
/*
Summary
Set IsWrapperFg for QNUPS plan type GB

DatabaseName        TableName      Expected Rows
PolicyManagement    TRefPlanType   1
*/


SELECT 
    @ScriptGUID = '3FF2078A-150C-4084-B250-DB3C996EA758', 
    @Comments = 'IOSE22-2182 QNUPS has to have sub-plans in GB'


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