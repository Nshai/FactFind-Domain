-----------------------------------------------------------------------------
--
-- IOSC-512 visibility of annuity products in FF compared to Investment section.
--
-----------------------------------------------------------------------------
USE [FactFind]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @StartTranCount int


SELECT @ScriptGUID = '8237F185-6D90-4D30-9B1A-299015A45491',
       @Comments = 'IOSC-512 visibility of annuity products in FF compared to Investment section.'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGuid = @ScriptGUID)
    RETURN

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

        DECLARE @RefPlanTypeToProdSubTypeId1 INT = 1181,
        @RefPlanTypeToProdSubTypeId2 INT = 1180

             INSERT INTO [factfind].[dbo].[TRefPlanTypeToSection]
             (RefPlanType2ProdSubTypeId, Section)
             OUTPUT
             INSERTED.[RefPlanType2ProdSubTypeId],
             INSERTED.[Section],
             INSERTED.[RefPlanTypeToSectionId],
             'C',
             GetDate(),
             '0'
             INTO [factfind].[dbo].[TRefPlanTypeToSectionAudit]
            ([RefPlanType2ProdSubTypeId],
             [Section],
             [RefPlanTypeToSectionId],
             [StampAction],
             [StampDateTime],
             [StampUser])
             VALUES(@RefPlanTypeToProdSubTypeId1, 'Other Investments'),
             (@RefPlanTypeToProdSubTypeId2, 'Other Investments')

        INSERT INTO TExecutedDataScript (ScriptGuid, Comments)
        VALUES (@ScriptGUID, @Comments)

        COMMIT TRANSACTION

END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF