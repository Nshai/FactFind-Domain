 
-----------------------------------------------------------------------------
-- Table: CRM.TRefOpportunityType2ProdSubType
--    Join: join TOpportunityType t on t.OpportunityTypeId = TRefOpportunityType2ProdSubType.OpportunityTypeId
--   Where: WHERE t.IndigoClientId = 466
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '87C649E4-539A-48C0-836F-9B9DB935A7BF'
     AND TenantId = 466
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
        SELECT 93802,1089,3922,1,0 UNION ALL 
        SELECT 52235,38,3922,1,0 UNION ALL 
        SELECT 5707,NULL,3922,1,0 UNION ALL 
        SELECT 5709,1046,3922,1,0 UNION ALL 
        SELECT 5710,33,3922,1,0 UNION ALL 
        SELECT 5712,1047,3922,1,0 UNION ALL 
        SELECT 5713,1003,3922,1,0 UNION ALL 
        SELECT 5714,1051,3922,1,0 UNION ALL 
        SELECT 5715,35,3922,1,0 UNION ALL 
        SELECT 5716,34,3922,1,0 UNION ALL 
        SELECT 5719,1002,3922,1,0 UNION ALL 
        SELECT 5720,1050,3922,1,0 UNION ALL 
        SELECT 5721,1048,3922,1,0 UNION ALL 
        SELECT 5722,1054,3922,1,0 UNION ALL 
        SELECT 5723,1052,3922,1,0 UNION ALL 
        SELECT 5724,1053,3922,1,0 UNION ALL 
        SELECT 35994,1057,15570,1,0 UNION ALL 
        SELECT 5708,NULL,15570,1,0 UNION ALL 
        SELECT 5711,33,15570,1,0 UNION ALL 
        SELECT 5717,1055,15570,1,0 UNION ALL 
        SELECT 5718,1056,15570,1,0 
 
        SET IDENTITY_INSERT TRefOpportunityType2ProdSubType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '87C649E4-539A-48C0-836F-9B9DB935A7BF', 
         'Initial load (21 total rows, file 1 of 1) for table TRefOpportunityType2ProdSubType',
         466, 
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
-- #Rows Exported: 21
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
