USE Administration

DECLARE @tblSystem TABLE (SystemId int)
declare @parentId bigint,
		@systemPath VARCHAR(255),    
		@maxSystemId bigint,
        @ScriptGUID UNIQUEIDENTIFIER,
        @Comments VARCHAR(255),
		@systemId bigint

SELECT @ScriptGUID = 'B3733FB0-50B8-41E8-ABBF-37947DD437D7', 
       @Comments = 'IOSE22-1186 Add new Security permission for Tasks Due date' 

IF NOT EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)        
BEGIN		
	SET @systemPath = 'task.actions.assignduedate'	

	IF NOT EXISTS (SELECT 1 FROM dbo.TSystem WHERE SystemPath = @systemPath)
	BEGIN
		BEGIN TRAN				

		--SELECT @maxSystemId = Max(SystemId) FROM dbo.TSystem

		SELECT @parentId = SystemId FROM dbo.TSystem WHERE SystemPath = 'task.actions'

		INSERT INTO dbo.TSystem(Identifier,	Description,	SystemPath,	SystemType,	ParentId,	Url,	EntityId,	ConcurrencyId)
		OUTPUT 
			inserted.SystemId
		INTO @tblSystem
			(
				SystemId
			)
                VALUES ('assignduedate', 'Assign Due Date', @systemPath,	'+subaction',	@parentId,	'dialog:/organiser/tasks/assignduedate.asp',	NULL,	1)
		
		SELECT @systemId = SystemId FROM @tblSystem

		INSERT INTO TSystemAudit(Identifier, Description, SystemPath, SystemType, ParentId, Url, EntityId, ConcurrencyId, SystemId, StampAction, StampDateTime, StampUser)
						  SELECT Identifier, Description, SystemPath, SystemType, ParentId, Url, EntityId, ConcurrencyId, SystemId, 'C', GETUTCDATE(), 0 
                FROM TSystem
                WHERE SystemId = @systemId
				
		INSERT INTO TRefLicenseTypeToSystem (RefLicenseTypeId, SystemId, ConcurrencyId)
        OUTPUT 
			inserted.RefLicenseTypeId,
			inserted.SystemId,
			1,
			inserted.RefLicenseTypeToSystemId,
			'C',
			GETUTCDATE(),
			0
        INTO 
			TRefLicenseTypeToSystemAudit 
				(
					RefLicenseTypeId,
					SystemId, 
					ConcurrencyId, 
					RefLicenseTypeToSystemId,
					StampAction,
					StampDateTime, 
					StampUser
				)
		VALUES
			(1,@systemId,1),
			(2,@systemId,1),
			(4,@systemId,1),
			(6,@systemId,1)
		-- record execution so the script won't run again
		INSERT TExecutedDataScript (ScriptGUID, Comments,TenantId,TimeStamp) VALUES (@ScriptGUID, @Comments,null,GETUTCDATE())
		COMMIT TRAN  					   
	END	
END
-----------------------------------------------------------------------------
-- #Rows Exported: 1
-- Created by Arun Sivan, Mar 28 2023  06:00PM
-----------------------------------------------------------------------------