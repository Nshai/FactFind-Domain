 
-----------------------------------------------------------------------------
-- Table: FactFind.TAssetCategory
--    Join: 
--   Where: WHERE IndigoClientId=0
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'B56494E9-8204-4DC2-9C42-0554C71652B9'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAssetCategory ON; 
 
        INSERT INTO TAssetCategory([AssetCategoryId], [CategoryName], [SectorName], [IndigoClientId], [ConcurrencyId])
        SELECT 12, 'Second Home', 'Property',0,1 UNION ALL 
        SELECT 11, 'Rental Property/ Other Property', 'Property',0,1 UNION ALL 
        SELECT 10, 'Own Business', 'Own Business',0,1 UNION ALL 
        SELECT 9, 'Overseas Property', 'Property',0,1 UNION ALL 
        SELECT 8, 'Non-Income Producing Real Estate', 'Non-Income Producing Real Estate',0,1 UNION ALL 
        SELECT 7, 'Motor Vehicles', 'Motor Vehicles',0,1 UNION ALL 
        SELECT 6, 'Main Residence', 'Property',0,1 UNION ALL 
        SELECT 5, 'Investment Property', 'Property',0,1 UNION ALL 
        SELECT 4, 'Home Contents', 'Home Contents',0,1 UNION ALL 
        SELECT 3, 'Holiday Home', 'Property',0,1 UNION ALL 
        SELECT 2, 'Collectibles/ Art/ Other Valuables', 'Collectibles/Art/Other Valuables',0,1 UNION ALL 
        SELECT 1, 'Cash', 'Cash',0,1 UNION ALL 
        SELECT 13, 'Investments', 'Investments',0,1 UNION ALL 
        SELECT 14, 'Other', 'Other',0,1 UNION ALL 
        SELECT 15, 'Boat', 'Boat',0,1 UNION ALL 
        SELECT 16, 'Buy to Let Property', 'Buy to Let Property',0,1 
 
        SET IDENTITY_INSERT TAssetCategory OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'B56494E9-8204-4DC2-9C42-0554C71652B9', 
         'Initial load (16 total rows, file 1 of 1) for table TAssetCategory',
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
-----------------------------------------------------------------------------
-- #Rows Exported: 16
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
