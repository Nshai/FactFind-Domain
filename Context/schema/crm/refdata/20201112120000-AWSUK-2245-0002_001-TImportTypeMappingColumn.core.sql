 
-----------------------------------------------------------------------------
-- Table: CRM.TImportTypeMappingColumn
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '409E593A-050B-41F0-B4DC-2F9ACBD2AE5C'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TImportTypeMappingColumn ON; 
 
        INSERT INTO TImportTypeMappingColumn([ImportTypeMappingColumnId], [ImportTypeId], [ColumnName], [DisplayName], [PropertyName], [IsRequired], [ConcurrencyId])
        SELECT 31,1, 'PolicyNumber', 'Policy Number', 'PolicyNumber',0,1 UNION ALL 
        SELECT 30,2, 'PlanStatusReason', 'Plan Status Reason', 'PlanStatusReason',0,1 UNION ALL 
        SELECT 29,2, 'PlanStatusDate', 'Plan Status Date', 'PlanStatusDate',0,1 UNION ALL 
        SELECT 28,2, 'SalaryDate', 'Date of Salary Change', 'SalaryDate',0,1 UNION ALL 
        SELECT 27,2, 'PensionableSalary', 'Pensionable Salary', 'PensionableSalary',0,1 UNION ALL 
        SELECT 26,2, 'PlanStatus', 'Plan Status', 'PlanStatus',0,1 UNION ALL 
        SELECT 25,2, 'CategoryName', 'Category Name', 'CategoryName',0,1 UNION ALL 
        SELECT 24,2, 'PlanRef', 'Plan Ref', 'PlanRef',1,1 UNION ALL 
        SELECT 23,2, 'ClientRef', 'Client Ref', 'ClientRef',1,1 UNION ALL 
        SELECT 22,1, 'DateJoinedScheme', 'Date Joined Scheme', 'DateJoinedScheme',1,8 UNION ALL 
        SELECT 21,1, 'DateOfBirth', 'Date of Birth', 'DateOfBirth',1,8 UNION ALL 
        SELECT 20,1, 'Gender', 'Gender', 'Gender',0,7 UNION ALL 
        SELECT 19,1, 'AdviceType', 'Advice Type', 'AdviceType',1,8 UNION ALL 
        SELECT 15,1, 'PensionableSalary', 'Pensionable Salary', 'PensionableSalary',0,4 UNION ALL 
        SELECT 14,1, 'NINumber', 'NI Number', 'NINumber',0,7 UNION ALL 
        SELECT 13,1, 'CategoryName', 'Category Name', 'CategoryName',0,6 UNION ALL 
        SELECT 12,1, 'HomeNumber', 'Home Number', 'HomeNumber',0,2 UNION ALL 
        SELECT 11,1, 'MobileNumber', 'Mobile Number', 'MobileNumber',0,2 UNION ALL 
        SELECT 10,1, 'EmailAddress', 'Email Address', 'EmailAddress',0,2 UNION ALL 
        SELECT 9,1, 'PostCode', 'PostCode', 'PostCode',0,6 UNION ALL 
        SELECT 8,1, 'CityTown', 'City/Town', 'CityTown',0,4 UNION ALL 
        SELECT 7,1, 'AddressLine3', 'Address 3', 'AddressLine3',0,5 UNION ALL 
        SELECT 6,1, 'AddressLine2', 'Address 2', 'AddressLine2',0,6 UNION ALL 
        SELECT 5,1, 'AddressLine1', 'Address 1', 'AddressLine1',0,6 UNION ALL 
        SELECT 3,1, 'Title', 'Title', 'Title',0,7 UNION ALL 
        SELECT 2,1, 'Surname', 'Surname', 'Surname',1,8 UNION ALL 
        SELECT 1,1, 'FirstName', 'First Name', 'FirstName',1,8 UNION ALL 
        SELECT 32,1, 'SchemeRef', 'Scheme Ref', 'SchemeRef',1,1 UNION ALL 
        SELECT 33,1, 'AddressLine4', 'Address 4', 'AddressLine4',0,1 UNION ALL 
        SELECT 34,1, 'County', 'County', 'County',0,1 UNION ALL 
        SELECT 35,1, 'Country', 'Country', 'Country',0,1 UNION ALL 
        SELECT 36,1, 'SellingAdviserId', 'Selling Adviser Id', 'SellingAdviserId',1,1 
 
        SET IDENTITY_INSERT TImportTypeMappingColumn OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '409E593A-050B-41F0-B4DC-2F9ACBD2AE5C', 
         'Initial load (32 total rows, file 1 of 1) for table TImportTypeMappingColumn',
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
-- #Rows Exported: 32
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
