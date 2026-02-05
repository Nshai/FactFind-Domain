 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TAttribute
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '94A1B76C-FB75-4D5D-B192-08A4A3ED30E8'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAttribute ON; 
 
        INSERT INTO TAttribute([AttributeId], [Value], [ConcurrencyId])
        SELECT 101, '25300.00',1 UNION ALL 
        SELECT 91, '20000.00',1 UNION ALL 
        SELECT 88, '49500.00',1 UNION ALL 
        SELECT 87, '87000.00',1 UNION ALL 
        SELECT 80, '£25391',1 UNION ALL 
        SELECT 77, '22000',1 UNION ALL 
        SELECT 66, '35200.00',1 UNION ALL 
        SELECT 43, '25575',1 UNION ALL 
        SELECT 45, '36100.00',1 UNION ALL 
        SELECT 47, '47500.00',1 UNION ALL 
        SELECT 48, '75000',1 UNION ALL 
        SELECT 50, '50000.00',1 UNION ALL 
        SELECT 54, '47000.00',1 UNION ALL 
        SELECT 55, '40000.00',1 UNION ALL 
        SELECT 86, '52000.00',1 UNION ALL 
        SELECT 100, '130000',1 UNION ALL 
        SELECT 135, 'DataFixForAttributeListId16',1 UNION ALL 
        SELECT 134, 'DataFixForAttributeListId15',1 UNION ALL 
        SELECT 133, 'DataFixForAttributeListId13',1 UNION ALL 
        SELECT 132, 'Non Profit',1 UNION ALL 
        SELECT 131, 'Growth',1 UNION ALL 
        SELECT 130, 'Income',1 UNION ALL 
        SELECT 103, '20295',1 UNION ALL 
        SELECT 128, '50700',1 UNION ALL 
        SELECT 124, '66600',1 UNION ALL 
        SELECT 121, 'No',1 UNION ALL 
        SELECT 120, 'Yes',1 UNION ALL 
        SELECT 116, '99960',1 UNION ALL 
        SELECT 118, '47600.00',1 UNION ALL 
        SELECT 123, '65800.00',1 UNION ALL 
        SELECT 113, '161000.00',1 UNION ALL 
        SELECT 111, '31000.00',1 UNION ALL 
        SELECT 110, '66250.00',1 UNION ALL 
        SELECT 109, '70000.00',1 UNION ALL 
        SELECT 108, '85,000',1 UNION ALL 
        SELECT 106, '22000.00',1 UNION ALL 
        SELECT 105, '37800.00',1 UNION ALL 
        SELECT 104, '27300.00',1 UNION ALL 
        SELECT 102, '84600.00',1 UNION ALL 
        SELECT 99, '82500',1 UNION ALL 
        SELECT 125, '50000.00',1 UNION ALL 
        SELECT 95, '36000',1 UNION ALL 
        SELECT 94, '52000',1 UNION ALL 
        SELECT 93, '150000',1 UNION ALL 
        SELECT 92, '37000.00',1 UNION ALL 
        SELECT 126, '66000',1 UNION ALL 
        SELECT 82, '25500',1 UNION ALL 
        SELECT 81, '100000',1 UNION ALL 
        SELECT 76, '100000',1 UNION ALL 
        SELECT 71, '30000.00',1 UNION ALL 
        SELECT 70, '35400.00',1 UNION ALL 
        SELECT 69, '82500',1 UNION ALL 
        SELECT 67, '68200.00',1 UNION ALL 
        SELECT 65, '34220.00',1 UNION ALL 
        SELECT 90, '46200.00',1 UNION ALL 
        SELECT 117, '45600.00',1 UNION ALL 
        SELECT 60, '35000',1 UNION ALL 
        SELECT 59, '72000',1 UNION ALL 
        SELECT 58, '42000.00',1 UNION ALL 
        SELECT 57, '£40,250',1 UNION ALL 
        SELECT 53, '18000',1 UNION ALL 
        SELECT 49, '0',1 UNION ALL 
        SELECT 44, '31500',1 UNION ALL 
        SELECT 41, '24000',1 UNION ALL 
        SELECT 39, '103500.00',1 UNION ALL 
        SELECT 38, '88800.00',1 UNION ALL 
        SELECT 98, '54400.00',1 UNION ALL 
        SELECT 52, '39000',1 UNION ALL 
        SELECT 35, '0.00',1 UNION ALL 
        SELECT 34, '12',1 UNION ALL 
        SELECT 30, 'Has unemployment cover',1 UNION ALL 
        SELECT 29, 'Level',1 UNION ALL 
        SELECT 28, 'Increasing',1 UNION ALL 
        SELECT 27, 'Decreasing',1 UNION ALL 
        SELECT 136, 'MVR Free Date',1 UNION ALL 
        SELECT 25, 'Both',1 UNION ALL 
        SELECT 24, 'Capital Repayment',1 UNION ALL 
        SELECT 23, 'Interest Only',1 UNION ALL 
        SELECT 22, 'Family Income benefit',1 UNION ALL 
        SELECT 21, 'Unemployment',1 UNION ALL 
        SELECT 20, 'Accident',1 UNION ALL 
        SELECT 19, 'Sickness',1 UNION ALL 
        SELECT 18, 'Income Protection',1 UNION ALL 
        SELECT 17, 'Life and CIC',1 UNION ALL 
        SELECT 16, 'CIC',1 UNION ALL 
        SELECT 15, 'Life',1 UNION ALL 
        SELECT 14, 'Transfer',1 UNION ALL 
        SELECT 13, 'Traditional',1 UNION ALL 
        SELECT 12, 'With Profits',1 UNION ALL 
        SELECT 11, 'Unit Linked',1 UNION ALL 
        SELECT 10, 'Flexible',1 UNION ALL 
        SELECT 9, 'No',1 UNION ALL 
        SELECT 8, 'Yes',1 UNION ALL 
        SELECT 7, 'External Fund Managers',1 UNION ALL 
        SELECT 6, 'Multiple Fund Choice',1 UNION ALL 
        SELECT 5, 'Capital Protected',1 UNION ALL 
        SELECT 4, 'Split Capital or Derivative',1 UNION ALL 
        SELECT 3, 'Property',1 UNION ALL 
        SELECT 2, 'With Profits',1 UNION ALL 
        SELECT 1, 'Unit Linked',1 
 
        SET IDENTITY_INSERT TAttribute OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '94A1B76C-FB75-4D5D-B192-08A4A3ED30E8', 
         'Initial load (100 total rows, file 1 of 1) for table TAttribute',
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
-- #Rows Exported: 100
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
