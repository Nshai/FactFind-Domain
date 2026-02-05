 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefTaxYear
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'C094407F-CB42-4EA6-942C-B54E2B5DAC59'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefTaxYear ON; 
 
        INSERT INTO TRefTaxYear([RefTaxYearId], [RefTaxYearName], [RetireFg], [ConcurrencyId])
        SELECT 19, '14/15',0,1 UNION ALL 
        SELECT 18, '13/14',0,1 UNION ALL 
        SELECT 17, '12/13',0,1 UNION ALL 
        SELECT 16, '11/12',0,1 UNION ALL 
        SELECT 15, '10/11',0,1 UNION ALL 
        SELECT 14, '09/10',0,1 UNION ALL 
        SELECT 13, '08/09',0,1 UNION ALL 
        SELECT 12, '07/08',0,1 UNION ALL 
        SELECT 11, '06/07',0,1 UNION ALL 
        SELECT 10, '05/06',0,1 UNION ALL 
        SELECT 9, '04/05',0,1 UNION ALL 
        SELECT 8, '03/04',0,1 UNION ALL 
        SELECT 7, '02/03',0,1 UNION ALL 
        SELECT 6, '01/02',0,1 UNION ALL 
        SELECT 5, '00/01',0,1 UNION ALL 
        SELECT 4, '99/00',0,1 UNION ALL 
        SELECT 3, '98/99',0,1 UNION ALL 
        SELECT 2, '97/98',0,1 UNION ALL 
        SELECT 1, '96/97',0,1 UNION ALL 
        SELECT 20, '15/16',0,1 UNION ALL 
        SELECT 21, '16/17',0,1 UNION ALL 
        SELECT 22, '17/18',0,1 UNION ALL 
        SELECT 23, '18/19',0,1 UNION ALL 
        SELECT 24, '19/20',0,1 UNION ALL 
        SELECT 25, '20/21',0,1 UNION ALL 
        SELECT 26, '21/22',0,1 UNION ALL 
        SELECT 27, '22/23',0,1 UNION ALL 
        SELECT 28, '23/24',0,1 UNION ALL 
        SELECT 29, '24/25',0,1 
 
        SET IDENTITY_INSERT TRefTaxYear OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'C094407F-CB42-4EA6-942C-B54E2B5DAC59', 
         'Initial load (29 total rows, file 1 of 1) for table TRefTaxYear',
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
-- #Rows Exported: 29
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
