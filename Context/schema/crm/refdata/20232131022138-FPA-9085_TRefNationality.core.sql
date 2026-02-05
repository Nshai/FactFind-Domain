USE CRM;

DECLARE @ScriptGUID UNIQUEIDENTIFIER,
        @Comments   VARCHAR(255)

/*
Summary
FPA-9085 - Replace direct database calls to TRefNationality and TRefNationality2RefCountry with API from IO application

DatabaseName        TableName                		Expected Rows
CRM          		TRefNationality2RefCountry    	8
*/
SELECT @ScriptGUID = 'AB93B71A-A7E0-4E94-A469-F711DB65CA6E',
	@Comments = 'FPA-9085 - Replace direct database calls to TRefNationality and TRefNationality2RefCountry with API from IO application'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

SET NOCOUNT ON
SET XACT_ABORT ON

INSERT INTO [TRefNationality2RefCountry]
	([RefNationalityId]
	,[RefCountryId]
	,[Descriptor]
	,[ISOAlpha2Code]
	,[ISOAlpha3Code]
	,[ConcurrencyId])
OUTPUT      inserted.ConcurrencyId,
			inserted.Descriptor,
			inserted.ISOAlpha2Code,
			inserted.ISOAlpha3Code,
			inserted.RefCountryId,
			inserted.RefNationality2RefCountryId,
			inserted.RefNationalityId,
			'C',
			GETUTCDATE(),
			0
INTO TRefNationality2RefCountryAudit
	(ConcurrencyId
	,Descriptor
	,ISOAlpha2Code
	,ISOAlpha3Code
	,RefCountryId
	,RefNationality2RefCountryId
	,RefNationalityId
	,StampAction
	,StampDateTime
	,StampUser)
VALUES
	(30, 36, 'Burkinabe', 'BF', 'BFA', 1),
	(96, 181, 'Kittian and Nevisian', 'KN', 'KNA', 1),
	(107, 80, 'Macedonian', 'MK', 'MKD', 1),
	(130, 156, 'Nicaragua (Republic of)', 'NI', 'NIC', 1),
	(149, 182, 'Saint Lucia', 'LC', 'LCA', 1),
	(196, 253, 'Isle of Mann', 'IM', 'IMN', 1),
	(123, 122, 'Lesotho', 'LS', 'LSO', 1)


INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;