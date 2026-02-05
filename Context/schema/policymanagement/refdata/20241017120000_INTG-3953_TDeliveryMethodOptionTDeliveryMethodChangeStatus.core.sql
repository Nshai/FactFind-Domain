USE PolicyManagement;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
        , @Comments VARCHAR(255)

/*
Summary
INTG-3953: add reference values to tables
DATABASENAME        TABLENAME                       EXPECTED ROWS
policymanagement    TDeliveryMethodOption           3
policymanagement    TDeliveryMethodChangeStatus     3
*/


SELECT 
    @ScriptGUID = '40DA9882-0CD6-4AB7-A379-1E3A702BA85C',
    @Comments = 'INTG-3953 add reference values to tables'


IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

        INSERT INTO TDeliveryMethodOption (DeliveryMethodOptionId, Name) VALUES (0, 'No Preference')
        INSERT INTO TDeliveryMethodOption (DeliveryMethodOptionId, Name) VALUES (1, 'Electronic')
        INSERT INTO TDeliveryMethodOption (DeliveryMethodOptionId, Name) VALUES (2, 'Post')

        INSERT INTO TDeliveryMethodChangeStatus (DeliveryMethodChangeStatusId, Name) VALUES (0, 'Rejected')
        INSERT INTO TDeliveryMethodChangeStatus (DeliveryMethodChangeStatusId, Name) VALUES (1, 'Ready')
        INSERT INTO TDeliveryMethodChangeStatus (DeliveryMethodChangeStatusId, Name) VALUES (2, 'Accepted')

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