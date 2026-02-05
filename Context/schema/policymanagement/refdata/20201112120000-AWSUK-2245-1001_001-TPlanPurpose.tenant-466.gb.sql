 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TPlanPurpose
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '0E3D74CB-2743-46F6-B4FB-19BEC99A36D5'
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
        SET IDENTITY_INSERT TPlanPurpose ON; 
 
        INSERT INTO TPlanPurpose([PlanPurposeId], [Descriptor], [MortgageRelatedfg], [IndigoClientId], [ConcurrencyId])
        SELECT 6944, 'Retirement Planning',NULL,466,1 UNION ALL 
        SELECT 6945, 'Mortgage Repayment',NULL,466,1 UNION ALL 
        SELECT 6946, 'Concurrancy',NULL,466,1 UNION ALL 
        SELECT 6947, 'Property Purchase',NULL,466,1 UNION ALL 
        SELECT 6948, 'Pension Fund Withdrawl',NULL,466,1 UNION ALL 
        SELECT 6949, 'External Fund Management',NULL,466,1 UNION ALL 
        SELECT 6950, 'Growth',NULL,466,1 UNION ALL 
        SELECT 6951, 'Income',NULL,466,1 UNION ALL 
        SELECT 6952, 'Growth and Income',NULL,466,1 UNION ALL 
        SELECT 6953, 'Savings',NULL,466,1 UNION ALL 
        SELECT 6954, 'Protection',NULL,466,1 UNION ALL 
        SELECT 6955, 'IHT  Planning',NULL,466,1 UNION ALL 
        SELECT 6956, 'Residential',NULL,466,1 UNION ALL 
        SELECT 6957, 'Commercial',NULL,466,1 UNION ALL 
        SELECT 6958, 'Buy to Let',NULL,466,1 UNION ALL 
        SELECT 6959, 'School Fees',NULL,466,1 
 
        SET IDENTITY_INSERT TPlanPurpose OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '0E3D74CB-2743-46F6-B4FB-19BEC99A36D5', 
         'Initial load (16 total rows, file 1 of 1) for table TPlanPurpose',
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
-- #Rows Exported: 16
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
