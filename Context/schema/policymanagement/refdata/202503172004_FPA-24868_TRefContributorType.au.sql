USE policymanagement ;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
       ,@Comments VARCHAR(255)
	   ,@StampDateTime DATETIME = GETUTCDATE()
	   ,@StampUser int = 0

/*
Summary
------------------------------
Inserts a new row into TRefcontributortype and TrefcontributortypeAudit tables
DatabaseName        TableName				 Expected Rows
-----------------------------------------------------------
Policymanagement	TRefContributorType		 1(add row)
*/


SELECT 
	@ScriptGUID = '0c8a863b-8679-4edc-b0b6-5521389dbc2f', 
	@Comments = 'Insert HeldInSuper enum type in Trefcontributortype table'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

    BEGIN TRANSACTION

    insert into policymanagement..TRefContributorType (RefContributorTypeName, RetireFg,ConcurrencyId)
output inserted.RefContributorTypeId,
inserted.RefContributorTypeName,
	inserted.RetireFg,
	inserted.ConcurrencyId,
	'C',
	@StampDateTime,
	@StampUser
	INTO policymanagement..TRefContributorTypeAudit(RefContributorTypeId,RefContributorTypeName,RetireFg,ConcurrencyId,StampAction,StampDateTime,StampUser)
	values('Held In Super','0','1')

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