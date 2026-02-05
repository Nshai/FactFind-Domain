 
-----------------------------------------------------------------------------
-- Table: CRM.TLeadStatusToRole
--    Join: 
--   Where: WHERE TenantId=12498
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '6E83E5BE-C9D3-4689-A099-375F5B256A5C'
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
        SET IDENTITY_INSERT TLeadStatusToRole ON; 
 
        INSERT INTO TLeadStatusToRole([LeadStatusToRoleId], [LeadStatusId], [RoleId], [TenantId], [ConcurrencyId])
        SELECT 100675,14746,34609,12498,0 UNION ALL 
        SELECT 100676,14746,34610,12498,0 UNION ALL 
        SELECT 100677,14746,34611,12498,0 UNION ALL 
        SELECT 100678,14746,34612,12498,0 UNION ALL 
        SELECT 100679,14746,34614,12498,0 UNION ALL 
        SELECT 100680,14746,34615,12498,0 UNION ALL 
        SELECT 100681,14747,34609,12498,0 UNION ALL 
        SELECT 100682,14747,34610,12498,0 UNION ALL 
        SELECT 100683,14747,34611,12498,0 UNION ALL 
        SELECT 100684,14747,34612,12498,0 UNION ALL 
        SELECT 100685,14747,34614,12498,0 UNION ALL 
        SELECT 100686,14747,34615,12498,0 UNION ALL 
        SELECT 100687,14748,34609,12498,0 UNION ALL 
        SELECT 100688,14748,34610,12498,0 UNION ALL 
        SELECT 100689,14748,34611,12498,0 UNION ALL 
        SELECT 100690,14748,34612,12498,0 UNION ALL 
        SELECT 100691,14748,34614,12498,0 UNION ALL 
        SELECT 100692,14748,34615,12498,0 UNION ALL 
        SELECT 100693,14749,34609,12498,0 UNION ALL 
        SELECT 100694,14749,34610,12498,0 UNION ALL 
        SELECT 100695,14749,34611,12498,0 UNION ALL 
        SELECT 100696,14749,34612,12498,0 UNION ALL 
        SELECT 100697,14749,34614,12498,0 UNION ALL 
        SELECT 100698,14749,34615,12498,0 
 
        SET IDENTITY_INSERT TLeadStatusToRole OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '6E83E5BE-C9D3-4689-A099-375F5B256A5C', 
         'Initial load (24 total rows, file 1 of 1) for table TLeadStatusToRole',
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
-- #Rows Exported: 24
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
