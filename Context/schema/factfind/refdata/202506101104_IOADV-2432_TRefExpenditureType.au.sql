USE factfind ;


DECLARE @ScriptGUID UNIQUEIDENTIFIER
       ,@Comments VARCHAR(255)

/*
Summary
------------------------------
Changes ExpenditureType name Maintenance/Alimony to Child Support, Life/General Assurance Premium to Life/General Insurance Premium, Adds School Fee/Childcare to TRefexpendituretype
DatabaseName        TableName				 Expected Rows
-----------------------------------------------------------
Factfind	TRefExpenditureType		 2(modified)
Factfind	TRefExpenditureType		 1(modified)
Factfind	TRefExpenditureType2ExpenditureGroup Multiple(added)
*/


SELECT 
	@ScriptGUID = '0a092a54-fa5c-425d-9a14-f2713a87950e', 
	@Comments = 'Changes ExpenditureType name Maintenance/Alimony to Child Support, Life/General Assurance Premium to Life/General Insurance Premium, Adds School Fee/Childcare to TRefexpendituretype'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRY

    BEGIN TRANSACTION

	
	IF NOT EXISTS (SELECT 1 FROM factfind..TRefExpenditureType WHERE Name = 'Child Support')
	BEGIN
	update factfind..TRefExpenditureType 
	set Name = 'Child Support'
	where Name = 'Maintenance/Alimony'
	END

	IF NOT EXISTS (SELECT 1 FROM factfind..TRefExpenditureType WHERE Name = 'Life/General Insurance Premium')
	BEGIN
	update factfind..TRefExpenditureType 
	set Name = 'Life/General Insurance Premium'
	where Name = 'Life/General Assurance Premium'
	END

	declare @ExpenditureGroupid as int
	select @ExpenditureGroupid = RefExpenditureGroupId from factfind..TRefExpenditureGroup where Name = 'Basic Quality of Living' AND TenantId IS NULL;
	IF NOT EXISTS (SELECT 1 FROM factfind..TRefExpenditureType WHERE Name = 'School Fee/Child Care')
	BEGIN
	INSERT INTO factfind..TRefExpenditureType (ConcurrencyId, RefExpenditureGroupId, Name, Ordinal, Attributes)
	VALUES (1, @ExpenditureGroupid, 'School Fee/Child Care', 1, '{"party_types":"Person"}')
	declare @SchoolFeeId as int
	select  @SchoolFeeId = RefExpenditureTypeId from factfind..TRefExpenditureType where Name = 'School Fee/Child Care'
	declare @expendituretenant as int
	INSERT INTO factfind..TRefExpenditureType2ExpenditureGroup (ExpenditureTypeId, ExpenditureGroupId)
	SELECT @SchoolFeeId, RefExpenditureGroupId FROM factfind..TRefExpenditureGroup WHERE Name = 'Basic Quality of Living';
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