USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = '86F2F13F-C1B4-40D2-B2F9-135E9FF12487'
      , @Comments = 'SM-806 TRefLicenseTypeToSystem Add new security items by functional area for quicksight reports to specified license types'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

-- Expected row counts:
--(25 row(s) affected)

BEGIN TRANSACTION
    
    BEGIN TRY
---------- BEGIN DATA INSERT/UPDATE ----------------------------------------------------

DECLARE @ReportsSystemId INT,
@AdministrationSystemId INT,
@ReportsReportGroupsSystemId INT,
@ReportsFoldersSystemId INT,
@ReportsReportsSystemId INT,
@ReportsAddNewGroupSystemId INT,
@ReportsSystemPath VARCHAR(256) = 'administration.reports',
@ReportsReportGroupsSystemPath VARCHAR(256) = 'administration.reports.reportgroups',
@ReportsFoldersSystemPath VARCHAR(256) = 'administration.reports.folders',
@ReportsReportsSystemPath VARCHAR(256) = 'administration.reports.reports',
@ReportsAddNewGroupSystemPath VARCHAR(256) = 'administration.reports.addnewgroup'

SET @ReportsSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = @ReportsSystemPath)
SET @ReportsReportGroupsSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = @ReportsReportGroupsSystemPath)
SET @ReportsFoldersSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = @ReportsFoldersSystemPath)
SET @ReportsReportsSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = @ReportsReportsSystemPath)
SET @ReportsAddNewGroupSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = @ReportsAddNewGroupSystemPath)
SET @AdministrationSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = 'administration')

-- Add Reports node to license types
IF EXISTS(SELECT * FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @AdministrationSystemId) AND
   NOT EXISTS (SELECT * FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @ReportsSystemId)
BEGIN
        INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                         ([RefLicenseTypeId]
                         ,[SystemId])
        OUTPUT inserted.[RefLicenseTypeId]
               ,inserted.[SystemId]
               ,inserted.[ConcurrencyId]
               ,inserted.[RefLicenseTypeToSystemId]
               ,'C'
               ,GETDATE()
               ,0
        INTO [dbo].[TRefLicenseTypeToSystemAudit]
                  ([RefLicenseTypeId]
                   ,[SystemId]
                   ,[ConcurrencyId]
                   ,[RefLicenseTypeToSystemId]
                   ,[StampAction]
                   ,[StampDateTime]
                   ,[StampUser])
        (SELECT [RefLicenseTypeId]
               ,@ReportsSystemId
         FROM [dbo].[TRefLicenseTypeToSystem]
         WHERE SystemId = @AdministrationSystemId)
END

-- Add Report Groups node to license types
IF EXISTS(SELECT * FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @AdministrationSystemId) AND
   NOT EXISTS (SELECT * FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @ReportsReportGroupsSystemId)
BEGIN
        INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                         ([RefLicenseTypeId]
                         ,[SystemId])
        OUTPUT inserted.[RefLicenseTypeId]
               ,inserted.[SystemId]
               ,inserted.[ConcurrencyId]
               ,inserted.[RefLicenseTypeToSystemId]
               ,'C'
               ,GETDATE()
               ,0
        INTO [dbo].[TRefLicenseTypeToSystemAudit]
                  ([RefLicenseTypeId]
                   ,[SystemId]
                   ,[ConcurrencyId]
                   ,[RefLicenseTypeToSystemId]
                   ,[StampAction]
                   ,[StampDateTime]
                   ,[StampUser])
        (SELECT [RefLicenseTypeId]
               ,@ReportsReportGroupsSystemId
         FROM [dbo].[TRefLicenseTypeToSystem]
         WHERE SystemId = @AdministrationSystemId)
END

-- Add Folders node to license types
IF EXISTS(SELECT * FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @AdministrationSystemId) AND
   NOT EXISTS (SELECT * FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @ReportsFoldersSystemId)
BEGIN
        INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                         ([RefLicenseTypeId]
                         ,[SystemId])
        OUTPUT inserted.[RefLicenseTypeId]
               ,inserted.[SystemId]
               ,inserted.[ConcurrencyId]
               ,inserted.[RefLicenseTypeToSystemId]
               ,'C'
               ,GETDATE()
               ,0
        INTO [dbo].[TRefLicenseTypeToSystemAudit]
                  ([RefLicenseTypeId]
                   ,[SystemId]
                   ,[ConcurrencyId]
                   ,[RefLicenseTypeToSystemId]
                   ,[StampAction]
                   ,[StampDateTime]
                   ,[StampUser])
        (SELECT [RefLicenseTypeId]
               ,@ReportsFoldersSystemId
         FROM [dbo].[TRefLicenseTypeToSystem]
         WHERE SystemId = @AdministrationSystemId)
END

-- Add Reports-Reports node to license types
IF EXISTS(SELECT * FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @AdministrationSystemId) AND
   NOT EXISTS (SELECT * FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @ReportsReportsSystemId)
BEGIN
        INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                         ([RefLicenseTypeId]
                         ,[SystemId])
        OUTPUT inserted.[RefLicenseTypeId]
               ,inserted.[SystemId]
               ,inserted.[ConcurrencyId]
               ,inserted.[RefLicenseTypeToSystemId]
               ,'C'
               ,GETDATE()
               ,0
        INTO [dbo].[TRefLicenseTypeToSystemAudit]
                  ([RefLicenseTypeId]
                   ,[SystemId]
                   ,[ConcurrencyId]
                   ,[RefLicenseTypeToSystemId]
                   ,[StampAction]
                   ,[StampDateTime]
                   ,[StampUser])
        (SELECT [RefLicenseTypeId]
               ,@ReportsReportsSystemId
         FROM [dbo].[TRefLicenseTypeToSystem]
         WHERE SystemId = @AdministrationSystemId)
END

-- Add Add New Group node to license types
IF EXISTS(SELECT * FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @AdministrationSystemId) AND
   NOT EXISTS (SELECT * FROM [dbo].[TRefLicenseTypeToSystem] WHERE SystemId = @ReportsAddNewGroupSystemId)
BEGIN
        INSERT INTO [dbo].[TRefLicenseTypeToSystem]
                         ([RefLicenseTypeId]
                         ,[SystemId])
        OUTPUT inserted.[RefLicenseTypeId]
               ,inserted.[SystemId]
               ,inserted.[ConcurrencyId]
               ,inserted.[RefLicenseTypeToSystemId]
               ,'C'
               ,GETDATE()
               ,0
        INTO [dbo].[TRefLicenseTypeToSystemAudit]
                  ([RefLicenseTypeId]
                   ,[SystemId]
                   ,[ConcurrencyId]
                   ,[RefLicenseTypeToSystemId]
                   ,[StampAction]
                   ,[StampDateTime]
                   ,[StampUser])
        (SELECT [RefLicenseTypeId]
               ,@ReportsAddNewGroupSystemId
         FROM [dbo].[TRefLicenseTypeToSystem]
         WHERE SystemId = @AdministrationSystemId)
END

---------- END DATA INSERT/UPDATE ------------------------------------------------------
    END TRY
    BEGIN CATCH
    
        SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
        WHILE(@@TRANCOUNT > 0)ROLLBACK
        RETURN
    
    END CATCH

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)
    
COMMIT TRANSACTION

-- Drop any temptables explicitly
--IF (SELECT OBJECT_ID('tempdb..#temptable1')) IS NOT NULL
--       DROP TABLE #temptable1


-- Check for ANY open transactions
-- This applies not only to THIS script but will rollback any open transactions in any scripts that have been run before this one.
IF @@TRANCOUNT > 0
BEGIN
       ROLLBACK
       RETURN
       PRINT 'Open transaction found, aborting'
END

RETURN;
