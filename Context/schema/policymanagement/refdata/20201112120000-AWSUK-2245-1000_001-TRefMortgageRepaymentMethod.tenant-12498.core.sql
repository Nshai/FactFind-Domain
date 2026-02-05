 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefMortgageRepaymentMethod
--    Join: 
--   Where: WHERE IndigoClientId = 12498
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'A86C6342-2527-4FD9-BFD8-7705C6C5A993'
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
        SET IDENTITY_INSERT TRefMortgageRepaymentMethod ON; 
 
        INSERT INTO TRefMortgageRepaymentMethod([RefMortgageRepaymentMethodId], [MortgageRepaymentMethod], [IndigoClientId], [ConcurrencyId])
        SELECT 35761, 'Capital and Interest',12498,1 UNION ALL 
        SELECT 35762, 'Interest Only/Endowment',12498,1 UNION ALL 
        SELECT 35763, 'Interest Only/ISA',12498,1 UNION ALL 
        SELECT 35764, 'Interest Only/Pension',12498,1 UNION ALL 
        SELECT 35765, 'Interest Only/Other',12498,1 UNION ALL 
        SELECT 35766, 'Split Repayment',12498,1 UNION ALL 
        SELECT 35767, 'Interest Only/No Investment Vehicle',12498,1 UNION ALL 
        SELECT 35768, 'Interest Only',12498,1 UNION ALL 
        SELECT 35769, 'Interest Only/Downsizing',12498,1 UNION ALL 
        SELECT 35770, 'Interest Roll-up/Sale Of Property',12498,1 UNION ALL 
        SELECT 35771, 'Interest Only/Sale Of Property',12498,1 
 
        SET IDENTITY_INSERT TRefMortgageRepaymentMethod OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'A86C6342-2527-4FD9-BFD8-7705C6C5A993', 
         'Initial load (11 total rows, file 1 of 1) for table TRefMortgageRepaymentMethod',
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
-- #Rows Exported: 11
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
