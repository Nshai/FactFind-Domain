USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @PensionPlanTypeId int = 1074
/*
Summary
Set IsWrapperFg for AU Pension Plan type on GB database
DatabaseName        TableName      Expected Rows
PolicyManagement    TRefPlanType   1
*/

SELECT
    @ScriptGUID = 'EA1B15CC-1DAC-4405-8EA7-9DC0079BE1E6',
    @Comments = 'SE-9832 Make AU Pensions be able to hold sub-plans'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

    EXEC SpNAuditRefPlanType 0, @PensionPlanTypeId, 'U'

    UPDATE TRefPlanType
    SET IsWrapperFg = 1
    WHERE RefPlanTypeId = @PensionPlanTypeId

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