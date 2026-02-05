 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefMortgageRepaymentMethod
--    Join: 
--   Where: WHERE IndigoClientId = 466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'A86C6342-2527-4FD9-BFD8-7705C6C5A993'
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
        SET IDENTITY_INSERT TRefMortgageRepaymentMethod ON; 
 
        INSERT INTO TRefMortgageRepaymentMethod([RefMortgageRepaymentMethodId], [MortgageRepaymentMethod], [IndigoClientId], [ConcurrencyId])
        SELECT 2059, 'Capital and Interest',466,1 UNION ALL 
        SELECT 2060, 'Interest Only/Endowment',466,2 UNION ALL 
        SELECT 2061, 'Interest Only/ISA',466,2 UNION ALL 
        SELECT 2062, 'Interest Only/Pension',466,2 UNION ALL 
        SELECT 2063, 'Interest Only/Other',466,2 UNION ALL 
        SELECT 2064, 'Split Repayment',466,2 UNION ALL 
        SELECT 3186, 'Interest Only/No Investment Vehicle',466,2 UNION ALL 
        SELECT 4422, 'Interest Only',466,1 UNION ALL 
        SELECT 14929, 'Interest Only/Downsizing',466,1 UNION ALL 
        SELECT 17698, 'Interest Roll-up/Sale Of Property',466,1 UNION ALL 
        SELECT 19675, 'Interest Only/Sale Of Property',466,1 
 
        SET IDENTITY_INSERT TRefMortgageRepaymentMethod OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'A86C6342-2527-4FD9-BFD8-7705C6C5A993', 
         'Initial load (11 total rows, file 1 of 1) for table TRefMortgageRepaymentMethod',
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
-- #Rows Exported: 11
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
