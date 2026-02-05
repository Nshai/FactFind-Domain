USE PolicyManagement;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)
        , @InvestmentBondPlanTypeId int = 28
/*
Summary
Set IsWrapperFg for Personal Pension Plan type GB
DatabaseName        TableName      Expected Rows
PolicyManagement    TRefPlanType   2
*/

SELECT
    @ScriptGUID = '255BAFC2-FD48-4D8F-A154-8378B5FAF00D',
    @Comments = 'SE-8902 Enable Investment Bonds have sub-plans'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

    EXEC SpNAuditRefPlanType 0, @InvestmentBondPlanTypeId, 'U'

    UPDATE TRefPlanType
    SET IsWrapperFg = 1
    WHERE RefPlanTypeId = @InvestmentBondPlanTypeId

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