USE CRM;

DECLARE @ScriptGUID UNIQUEIDENTIFIER
	, @Comments VARCHAR(255)
	, @Name VARCHAR(50) = 'Bermudian'
	, @RefCountryId int = 26
	, @RefNationalityId int
	, @ISOAlpha3Code VARCHAR(50) = 'BMU'

/*
Summary
DEF-13496 - Add nationality Bermudian

DatabaseName        TableName      Expected Rows
CRM	TRefNationality	1
CRM	TRefNationality2RefCountry	1
*/

SELECT 
	@ScriptGUID = 'CBEBCE7C-91D0-4F59-BED9-A08D9DD5812B', 
	@Comments = 'DEF-13496 - Add nationality Bermudian' 

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

    INSERT INTO TRefNationality (ConcurrencyId, IsArchived, [Name])
	OUTPUT inserted.ConcurrencyId, inserted.IsArchived, inserted.[Name], inserted.RefNationalityId, 'C', GETUTCDATE(), 0
	INTO TRefNationalityAudit(ConcurrencyId, IsArchived, [Name], RefNationalityId, StampAction, StampDateTime, StampUser)
	VALUES (1, 0, @Name)

	SET @RefNationalityId = (SELECT TOP 1 RefNationalityId FROM TRefNationality WHERE [Name] = @Name)

	IF @RefNationalityId IS NOT NULL
	BEGIN
		INSERT INTO TRefNationality2RefCountry (ConcurrencyId, Descriptor, ISOAlpha2Code, ISOAlpha3Code, RefCountryId, RefNationalityId)
		OUTPUT inserted.ConcurrencyId, inserted.Descriptor, inserted.ISOAlpha2Code, inserted.ISOAlpha3Code, inserted.RefCountryId, inserted.RefNationality2RefCountryId, inserted.RefNationalityId, 'C', GETUTCDATE(), 0
		INTO TRefNationality2RefCountryAudit(ConcurrencyId, Descriptor, ISOAlpha2Code, ISOAlpha3Code, RefCountryId, RefNationality2RefCountryId, RefNationalityId, StampAction, StampDateTime, StampUser)
		SELECT 1, CountryName, CountryCode, @ISOAlpha3Code, RefCountryId, @RefNationalityId
		FROM TRefCountry
		WHERE RefCountryId = @RefCountryId
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