USE Administration

declare @parentId bigint,
		@systemPath VARCHAR(255),    
		@maxSystemId bigint,
        @ScriptGUID UNIQUEIDENTIFIER,
        @Comments VARCHAR(255)

SELECT @ScriptGUID = 'DCDF61DF-A63D-4639-B2F0-F4F280A758AD', 
       @Comments = 'INTDD2-183 Add new Security permission for Document Designer' 

IF NOT EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)        
BEGIN		
	SET @systemPath = 'documentdesigner.actions.edittemplatesecuritysettings'	

	IF NOT EXISTS (SELECT 1 FROM dbo.TSystem WHERE SystemPath = @systemPath)
	BEGIN
		BEGIN TRAN				

		SELECT @maxSystemId = Max(SystemId) FROM dbo.TSystem

		SELECT @parentId = SystemId FROM dbo.TSystem WHERE SystemPath = 'documentdesigner.actions'

		INSERT INTO dbo.TSystem(Identifier,	[Description],	SystemPath,	SystemType,	ParentId,	Url,	EntityId,	ConcurrencyId)
		SELECT 'edittemplatesecuritysettings', 'Edit Template Security Settings',	'documentdesigner.actions.edittemplatesecuritysettings',	'+subaction',	@parentId,	NULL,	NULL,	1

		INSERT INTO	dbo.TSystemAudit
					([Identifier], [Description], [SystemPath], [SystemType], [ParentId], [Url], 
					[EntityId], [ConcurrencyId], [SystemId], [StampAction], [StampDateTime], [StampUser])
		SELECT [Identifier], [Description], [SystemPath], [SystemType], [ParentId], [Url], 
					[EntityId], [ConcurrencyId], [SystemId], 'C', GETDATE(), '0000'
		FROM dbo.TSystem
		WHERE SystemId > @maxSystemId


		INSERT INTO [dbo].[TRefLicenseTypeToSystem]
			   ([RefLicenseTypeId]
			   ,[SystemId]
			   ,[ConcurrencyId])

		   OUTPUT INSERTED.RefLicenseTypeToSystemId, INSERTED.RefLicenseTypeId, INSERTED.SystemId,  INSERTED.ConcurrencyId,'C', GetDate(), '0'		
		   INTO [dbo].[TRefLicenseTypeToSystemAudit]
					 ([RefLicenseTypeToSystemId]
					 ,[RefLicenseTypeId]
					 ,[SystemId]
					 ,[ConcurrencyId]					
					 ,[StampAction]
					 ,[StampDateTime]
					 ,[StampUser])

		  SELECT 1, SystemId, 1 
		  FROM TSystem 
		  WHERE SystemId > @maxSystemId		

		  INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)
		COMMIT TRAN  					   
	END	
END