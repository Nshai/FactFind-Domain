 
-----------------------------------------------------------------------------
-- Table: Administration.TSystem
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '7544F88B-DC0E-44E7-AFB0-C511AAE05D8C'
) RETURN 
 
-- Expected row counts: - if you know this
--(2 row(s) affected)

SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        DECLARE @ParentId INT

			SELECT @ParentId = SystemId
			FROM [administration].[dbo].[TSystem]
			WHERE SystemPath = 'recommendationactions.add'

			INSERT [administration].[dbo].[TSystem]
			OUTPUT
				inserted.[Identifier]
				,inserted.[Description]
				,inserted.[SystemPath]
				,inserted.[SystemType]
				,inserted.[ParentId]
				,inserted.[Url]
				,inserted.[EntityId]
				,inserted.[ConcurrencyId]
				,inserted.[SystemId]
				,'C'
				,GETDATE()
				,0
				,NULL
			INTO [administration].[dbo].[TSystemAudit]
			VALUES 
			('actionrecommendation', 'Action Recommendation', 'recommendationactions.add.actionrecommendation', '+subaction', @ParentId, NULL, NULL, 1 ,0),
			('actionproposal', 'Action Proposal', 'recommendationactions.add.actionproposal', '+subaction', @ParentId, '', NULL, 1, 0)
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '7544F88B-DC0E-44E7-AFB0-C511AAE05D8C', 
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


