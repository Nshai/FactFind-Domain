USE factfind ;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
       ,@Comments VARCHAR(255)


/*
Summary
------------------------------
Changes ExpenditureType nmae Gym to Sports and Recreation
DatabaseName        TableName				 Expected Rows
-----------------------------------------------------------
Factfind	TRefExpenditureType		 1(modified)
*/


SELECT 
	@ScriptGUID = 'c69202c3-6c54-4cc5-b44a-4958dc00dcd5', 
	@Comments = 'Changes ExpenditureType name Gym to Sports and Recreation'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

    BEGIN TRANSACTION


	IF NOT EXISTS (SELECT 1 FROM factfind..TRefExpenditureType WHERE Name = 'Sports and Recreation')
	BEGIN
		update factfind..TRefExpenditureType
		set Name = 'Sports and Recreation'
		where Name = 'Gym'
	END

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