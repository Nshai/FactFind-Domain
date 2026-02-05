-----------------------------------------------------------------------------
-- Table: Administration.TThirdParty
-- Join: 
-- Where: WHERE IndigoClientId=0
-----------------------------------------------------------------------------
  
USE Administration
  
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'ac54eab9-a6be-40fd-85b5-a5650d784cda'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
	-- check that there are no rows inserted already
	IF NOT EXISTS(SELECT 1 FROM TThirdParty where [ThirdPartyDescription] = 'URU / EIDV') --only one in table
	BEGIN

    -- insert the new record 
    INSERT INTO TThirdParty ([ThirdPartyDescription],[ConcurrencyId]) VALUES ('URU / EIDV', 1)  
     -- record execution so the script won't run again
    INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
    VALUES (
    'ac54eab9-a6be-40fd-85b5-a5650d784cda', 
    'Initial load (1 total rows, file 1 of 1) for table TThirdParty',
    null, 
    getdate() )
 
	IF @starttrancount = 0
	COMMIT TRANSACTION
   END
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH
 
 SET XACT_ABORT OFF
 SET NOCOUNT OFF
-----------------------------------------------------------------------------
-- #Rows Imported: 1
-----------------------------------------------------------------------------