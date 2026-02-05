 
-----------------------------------------------------------------------------
-- Table: Administration.TRefLicenseTypeToSystem
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'B2896F00-7C7B-4700-87BD-C47B9F60F1A8'
) RETURN 
 
-- Expected row counts: - if you know this
--(6 row(s) affected)

SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        DECLARE @SystemId1 INT, @SystemId2 INT, @ParentId INT

		SELECT @ParentId = SystemId
			FROM [administration].[dbo].[TSystem]
			WHERE SystemPath = 'recommendationactions.add'

		SELECT @SystemId1 = SystemId
			FROM [administration].[dbo].[TSystem]
			WHERE Identifier = 'actionrecommendation'
			AND SystemPath = 'recommendationactions.add.actionrecommendation'
			AND ParentId = @ParentId

		SELECT @SystemId2 = SystemId
			FROM [administration].[dbo].[TSystem]
			WHERE Identifier = 'actionproposal'
			AND SystemPath = 'recommendationactions.add.actionproposal'
			AND ParentId = @ParentId


		INSERT [administration].[dbo].[TRefLicenseTypeToSystem]
			OUTPUT
				inserted.[RefLicenseTypeId]
				,inserted.[SystemId]
				,inserted.[ConcurrencyId]
				,inserted.[RefLicenseTypeToSystemId]
				,'C'
				,GETDATE()
				,0
			INTO [administration].[dbo].[TRefLicenseTypeToSystemAudit]

		VALUES 
		 (1, @SystemId1, 1) -- RefLicenseType: Full
		,(2, @SystemId1, 1) -- RefLicenseType: Mortgage
		,(4, @SystemId1, 1) -- RefLicenseType: MortgageAdmin
		
		,(1, @SystemId2, 1) -- RefLicenseType: Full
		,(2, @SystemId2, 1) -- RefLicenseType: Mortgage
		,(4, @SystemId2, 1) -- RefLicenseType: MortgageAdmin			
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'B2896F00-7C7B-4700-87BD-C47B9F60F1A8', 
         'AP-474 Add Recommendations and Proposals permissions',
         null, 
         getdate() )
 
   IF @starttrancount = 0
    COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH
 
 SET XACT_ABORT OFF
 SET NOCOUNT OFF

