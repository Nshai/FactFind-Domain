-----------------------------------------------------------------------------
--
-- Summary: DEF-14055 update section for 2 annuity plan types on all regions.
--
-----------------------------------------------------------------------------
USE [FactFind]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @StartTranCount int


SELECT @ScriptGUID = '7061DF4F-1179-4B93-AE83-6B9D1482E7FA',
       @Comments = 'DEF-14055 visibility of annuity products in FF compared to Products section.'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGuid = @ScriptGUID)
    RETURN

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    SELECT @StartTranCount = @@TRANCOUNT

    IF (@StartTranCount = 0)
    BEGIN TRANSACTION

        DECLARE @RefPlanTypeToSectionId1 INT = 350,
        @RefPlanTypeToSectionId2 INT = 351

        UPDATE [factfind].[dbo].[TRefPlanTypeToSection]
        SET Section = 'Annuities'
        OUTPUT
             DELETED.[RefPlanType2ProdSubTypeId]
            ,DELETED.[Section]
            ,DELETED.[ConcurrencyId]
            ,DELETED.[RefPlanTypeToSectionId]
            ,'U'
            ,GETUTCDATE()
            ,0
        INTO
            [TRefPlanTypeToSectionAudit]
            (
             [RefPlanType2ProdSubTypeId]
            ,[Section]
            ,[ConcurrencyId]
            ,[RefPlanTypeToSectionId]
            ,[StampAction]
            ,[StampDateTime]
            ,[StampUser]
            )
        WHERE RefPlanTypeToSectionId in (@RefPlanTypeToSectionId1, @RefPlanTypeToSectionId2)
            AND Section = 'Pension Plans'

        INSERT INTO TExecutedDataScript (ScriptGuid, Comments)
        VALUES (@ScriptGUID, @Comments)

    IF (@StartTranCount = 0)
        COMMIT TRANSACTION

END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF