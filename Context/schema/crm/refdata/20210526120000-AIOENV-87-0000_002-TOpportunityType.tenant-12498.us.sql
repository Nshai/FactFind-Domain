USE [crm]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)

SELECT @ScriptGUID = 'C3D4BBDA-3F07-4D3A-A597-3C2E37AAE8A2',  -- use guid for GB script in order not to run it for SYS_IE_03
       @Comments = 'AIOENV-87 initial load for table TOpportunityType.tenant-12498 for us environments'
      
 -- check if this script has already run     
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN; 

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TOpportunityType ON; 
 
        INSERT INTO TOpportunityType([OpportunityTypeId], [OpportunityTypeName], [IndigoClientId], [ArchiveFG], [SystemFG], [InvestmentDefault], [RetirementDefault], [ConcurrencyId], [ObjectiveType])
        SELECT 34088, 'Advice - New',12498,0,0,0,0,1, NULL UNION ALL 
        SELECT 34089, 'Advice - Client Review',12498,0,0,0,0,1, NULL 
 
        SET IDENTITY_INSERT TOpportunityType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (@ScriptGUID, @Comments, 12498, getdate() )
 
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