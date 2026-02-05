USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @IncomeDrawdownPlanTypeId int = 1030
        , @PhasedRetirementPlanTypeId int = 21
/*
Summary
Set IsWrapperFg for Personal Pension Plan type GB

DatabaseName        TableName      Expected Rows
PolicyManagement    TRefPlanType   2
*/


SELECT 
    @ScriptGUID = '590D2ABB-3550-49CF-AFCE-861BDE809FEE',
    @Comments = 'SE-7741 Income Drawdown plans to be wrappers'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

    BEGIN TRANSACTION

    EXEC SpNAuditRefPlanType 0, @IncomeDrawdownPlanTypeId, 'U'
    EXEC SpNAuditRefPlanType 0, @PhasedRetirementPlanTypeId, 'U'

    UPDATE TRefPlanType
    SET IsWrapperFg = 1
    WHERE RefPlanTypeId IN (@IncomeDrawdownPlanTypeId, @PhasedRetirementPlanTypeId)

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