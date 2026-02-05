
USE documentmanagement
GO
--SELECT NEWID()
DECLARE @ScriptGUID uniqueidentifier, @Comments VARCHAR(255)
SELECT @ScriptGUID = '0B43F6E9-FA0E-4EE3-B1F2-933F65385D95', @Comments = '3.5-0035010 IO-13885 Author Fact Find Field Changes'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN;

begin tran

	Declare @EntityId bigint
	
	SELECT @EntityId = (SELECT EntityId FROM TEntity WHERE Identifier = 'Fact Find' AND IndigoClientId = 0)
	
	-- update the existing client 2 field names
	UPDATE TEntityField
	SET Descriptor = replace(descriptor, 'Partner', 'Client 2')
	WHERE EntityId = @EntityId
	AND Descriptor LIKE 'Partner%'
	
	
	
	-- ADD TEntityField records	
	
	IF NOT EXISTS (SELECT 1 FROM TEntityField WHERE EntityId = @EntityId AND Identifier = 'client1reference')
	BEGIN
		Insert into TEntityField (IndigoClientId, EntityId, Identifier, Descriptor, XPath, IsChartFg, Format, ConcurrencyId)
		Select 0, @EntityId, 'client1reference', 'Client 1 Reference Number', '@Client1Reference', 0, '', 1
	END
	
	IF NOT EXISTS (SELECT 1 FROM TEntityField WHERE EntityId = @EntityId AND Identifier = 'client1firstname')
	BEGIN
		Insert into TEntityField (IndigoClientId, EntityId, Identifier, Descriptor, XPath, IsChartFg, Format, ConcurrencyId)
		Select 0, @EntityId, 'client1firstname', 'Client 1 First Name', '@Client1FirstName', 0, '', 1
	END
	
	IF NOT EXISTS (SELECT 1 FROM TEntityField WHERE EntityId = @EntityId AND Identifier = 'client1lastname')
	BEGIN
		Insert into TEntityField (IndigoClientId, EntityId, Identifier, Descriptor, XPath, IsChartFg, Format, ConcurrencyId)
		Select 0, @EntityId, 'client1lastname', 'Client 1 Last Name', '@Client1LastName', 0, '', 1
	END

	IF @@ERROR != 0 GOTO exit_on_error  
			
	-- END DATA UPDATE
	INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)
	
	If @@TRANCOUNT > 0 
		commit Tran
		
	Select 'Success'
	
	Return
	
exit_on_error:
	
If @@TRANCOUNT > 0 
	Rollback Tran

Select 'FAILED'