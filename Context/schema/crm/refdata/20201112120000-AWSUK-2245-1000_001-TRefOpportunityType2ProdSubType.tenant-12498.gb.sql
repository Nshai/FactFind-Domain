 
-----------------------------------------------------------------------------
-- Table: CRM.TRefOpportunityType2ProdSubType
--    Join: join TOpportunityType t on t.OpportunityTypeId = TRefOpportunityType2ProdSubType.OpportunityTypeId
--   Where: WHERE t.IndigoClientId = 12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '87C649E4-539A-48C0-836F-9B9DB935A7BF'
     AND TenantId = 12498
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefOpportunityType2ProdSubType ON; 
 
        INSERT INTO TRefOpportunityType2ProdSubType([RefOpportunityType2ProdSubTypeId], [ProdSubTypeId], [OpportunityTypeId], [ConcurrencyId], [IsArchived])
        SELECT 65240,NULL,31456,1,0 UNION ALL 
        SELECT 65242,1046,31456,1,0 UNION ALL 
        SELECT 65243,33,31456,1,0 UNION ALL 
        SELECT 65246,1047,31456,1,0 UNION ALL 
        SELECT 65247,1003,31456,1,0 UNION ALL 
        SELECT 65248,1051,31456,1,0 UNION ALL 
        SELECT 65249,35,31456,1,0 UNION ALL 
        SELECT 65250,34,31456,1,0 UNION ALL 
        SELECT 65253,1002,31456,1,0 UNION ALL 
        SELECT 65254,1050,31456,1,0 UNION ALL 
        SELECT 65255,1048,31456,1,0 UNION ALL 
        SELECT 65256,1054,31456,1,0 UNION ALL 
        SELECT 65257,1052,31456,1,0 UNION ALL 
        SELECT 65258,1053,31456,1,0 UNION ALL 
        SELECT 65241,NULL,31457,1,0 UNION ALL 
        SELECT 65244,33,31457,1,0 UNION ALL 
        SELECT 65245,1057,31457,1,0 UNION ALL 
        SELECT 65251,1055,31457,1,0 UNION ALL 
        SELECT 65252,1056,31457,1,0 
 
        SET IDENTITY_INSERT TRefOpportunityType2ProdSubType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '87C649E4-539A-48C0-836F-9B9DB935A7BF', 
         'Initial load (19 total rows, file 1 of 1) for table TRefOpportunityType2ProdSubType',
         12498, 
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
-----------------------------------------------------------------------------
-- #Rows Exported: 19
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
