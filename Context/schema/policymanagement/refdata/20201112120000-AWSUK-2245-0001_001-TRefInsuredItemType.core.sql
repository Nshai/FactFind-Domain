 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefInsuredItemType
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '4615B46F-F85C-49B6-9515-6CA46476BC11'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefInsuredItemType ON; 
 
        INSERT INTO TRefInsuredItemType([RefInsuredItemTypeId], [Name], [ConcurrencyId])
        SELECT 1, 'Angling Equipment',1 UNION ALL 
        SELECT 2, 'Antique Furniture',1 UNION ALL 
        SELECT 3, 'Antique or Rare Books',1 UNION ALL 
        SELECT 4, 'Archery Equipment',1 UNION ALL 
        SELECT 5, 'Articles Made of Precious Stones',1 UNION ALL 
        SELECT 6, 'Camcorders',1 UNION ALL 
        SELECT 7, 'Camping Equipment',1 UNION ALL 
        SELECT 8, 'China',1 UNION ALL 
        SELECT 9, 'Clocks',1 UNION ALL 
        SELECT 10, 'Clothing',1 UNION ALL 
        SELECT 11, 'Coin Collection',1 UNION ALL 
        SELECT 12, 'Computer Equipment',1 UNION ALL 
        SELECT 13, 'Cups Shields Trophies and Masonic Regalia',1 UNION ALL 
        SELECT 14, 'Curios',1 UNION ALL 
        SELECT 15, 'Furniture',1 UNION ALL 
        SELECT 16, 'Furs',1 UNION ALL 
        SELECT 17, 'Gold Items',1 UNION ALL 
        SELECT 18, 'Golfing Equipment',1 UNION ALL 
        SELECT 19, 'Guns',1 UNION ALL 
        SELECT 20, 'Hearing Aids',1 UNION ALL 
        SELECT 21, 'Jewellery or Watches',1 UNION ALL 
        SELECT 22, 'Medal Collection',1 UNION ALL 
        SELECT 23, 'Mobile Phone',1 UNION ALL 
        SELECT 24, 'Musical Instruments Amateur',1 UNION ALL 
        SELECT 25, 'Musical Instruments Professional',1 UNION ALL 
        SELECT 26, 'Pedal Cycle',1 UNION ALL 
        SELECT 27, 'Paintings',1 UNION ALL 
        SELECT 28, 'Photographic Equipment Amateur',1 UNION ALL 
        SELECT 29, 'Photographic Equipment Professional',1 UNION ALL 
        SELECT 30, 'Pictures',1 UNION ALL 
        SELECT 31, 'RidingTack',1 UNION ALL 
        SELECT 32, 'Rugs',1 UNION ALL 
        SELECT 33, 'Sailboards',1 UNION ALL 
        SELECT 34, 'Silver Items',1 UNION ALL 
        SELECT 35, 'Skis Including WaterSkis',1 UNION ALL 
        SELECT 36, 'Spectacles',1 UNION ALL 
        SELECT 37, 'Sporting Equipment',1 UNION ALL 
        SELECT 38, 'Stamp Collection',1 UNION ALL 
        SELECT 39, 'TVs Videos HiFi Radios',1 UNION ALL 
        SELECT 40, 'Works of Art, etc',1 
 
        SET IDENTITY_INSERT TRefInsuredItemType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '4615B46F-F85C-49B6-9515-6CA46476BC11', 
         'Initial load (40 total rows, file 1 of 1) for table TRefInsuredItemType',
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
-- #Rows Exported: 40
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
