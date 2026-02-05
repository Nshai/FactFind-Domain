USE [administration]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = 'B3931566-D351-4B46-B94B-66AB5F3CFF80'
      , @Comments = 'SM-806 TSystem Add new security items by functional area for quicksight reports'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

-- Expected row counts:
--(5 row(s) affected)

BEGIN TRANSACTION
    
    BEGIN TRY
---------- BEGIN DATA INSERT/UPDATE ----------------------------------------------------

DECLARE @AdministrationSystemId INT,
@ReportsSystemId INT,
@ReportsSystemPath VARCHAR(256) = 'administration.reports',
@ReportsReportGroupsSystemPath VARCHAR(256) = 'administration.reports.reportgroups',
@ReportsFoldersSystemPath VARCHAR(256) = 'administration.reports.folders',
@ReportsReportsSystemPath VARCHAR(256) = 'administration.reports.reports',
@ReportsAddNewGroupSystemPath VARCHAR(256) = 'administration.reports.addnewgroup'

SET @AdministrationSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = 'administration')

-- Insert Reports node under Administration node.
IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @ReportsSystemPath)
BEGIN
INSERT INTO [dbo].[TSystem]
           ([Identifier]
           ,[Description]
           ,[SystemPath]
           ,[SystemType]
           ,[ParentId])
                OUTPUT 
                    INSERTED.[SystemId],
                    INSERTED.[Identifier],
                    INSERTED.[Description],
                    INSERTED.[SystemPath],
                    INSERTED.[SystemType],
                    INSERTED.[ParentId],
                    INSERTED.[Url],
                    INSERTED.[EntityId],
                    INSERTED.[ConcurrencyId],
                    'C',
                    GETUTCDATE(),
                    0
                INTO TSystemAudit
                (
                    [SystemId],
                    [Identifier],
                    [Description],
                    [SystemPath],
                    [SystemType],
                    [ParentId],
                    [Url],
                    [EntityId],
                    [ConcurrencyId],
                    [StampAction],
                    [StampDateTime],
                    [StampUser]
                )
     VALUES
           ('reports'
           ,'Reports'
           ,@ReportsSystemPath
           ,'-system'
           ,@AdministrationSystemId)
END

SET @ReportsSystemId = (SELECT SystemId FROM TSystem WHERE SystemPath = @ReportsSystemPath)

-- Insert Report Groups node under Reports node.
IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @ReportsReportGroupsSystemPath)
BEGIN
INSERT INTO [dbo].[TSystem]
           ([Identifier]
           ,[Description]
           ,[SystemPath]
           ,[SystemType]
           ,[ParentId])
           OUTPUT 
                    INSERTED.[SystemId],
                    INSERTED.[Identifier],
                    INSERTED.[Description],
                    INSERTED.[SystemPath],
                    INSERTED.[SystemType],
                    INSERTED.[ParentId],
                    INSERTED.[Url],
                    INSERTED.[EntityId],
                    INSERTED.[ConcurrencyId],
                    'C',
                    GETUTCDATE(),
                    0
                INTO TSystemAudit
                (
                    [SystemId],
                    [Identifier],
                    [Description],
                    [SystemPath],
                    [SystemType],
                    [ParentId],
                    [Url],
                    [EntityId],
                    [ConcurrencyId],
                    [StampAction],
                    [StampDateTime],
                    [StampUser]
                )
     VALUES
           ('reportgroups'
           ,'Report Groups'
           ,@ReportsReportGroupsSystemPath
           ,'-function'
           ,@ReportsSystemId)
END

-- Insert Folders node under Reports node.
IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @ReportsFoldersSystemPath)
BEGIN
INSERT INTO [dbo].[TSystem]
           ([Identifier]
           ,[Description]
           ,[SystemPath]
           ,[SystemType]
           ,[ParentId])
           OUTPUT 
                    INSERTED.[SystemId],
                    INSERTED.[Identifier],
                    INSERTED.[Description],
                    INSERTED.[SystemPath],
                    INSERTED.[SystemType],
                    INSERTED.[ParentId],
                    INSERTED.[Url],
                    INSERTED.[EntityId],
                    INSERTED.[ConcurrencyId],
                    'C',
                    GETUTCDATE(),
                    0
                INTO TSystemAudit
                (
                    [SystemId],
                    [Identifier],
                    [Description],
                    [SystemPath],
                    [SystemType],
                    [ParentId],
                    [Url],
                    [EntityId],
                    [ConcurrencyId],
                    [StampAction],
                    [StampDateTime],
                    [StampUser]
                )
     VALUES
           ('folders'
           ,'Folders'
           ,@ReportsFoldersSystemPath
           ,'-function'
           ,@ReportsSystemId)
END

-- Insert Reports node under Reports node.
IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @ReportsReportsSystemPath)
BEGIN
INSERT INTO [dbo].[TSystem]
           ([Identifier]
           ,[Description]
           ,[SystemPath]
           ,[SystemType]
           ,[ParentId])
           OUTPUT 
                    INSERTED.[SystemId],
                    INSERTED.[Identifier],
                    INSERTED.[Description],
                    INSERTED.[SystemPath],
                    INSERTED.[SystemType],
                    INSERTED.[ParentId],
                    INSERTED.[Url],
                    INSERTED.[EntityId],
                    INSERTED.[ConcurrencyId],
                    'C',
                    GETUTCDATE(),
                    0
                INTO TSystemAudit
                (
                    [SystemId],
                    [Identifier],
                    [Description],
                    [SystemPath],
                    [SystemType],
                    [ParentId],
                    [Url],
                    [EntityId],
                    [ConcurrencyId],
                    [StampAction],
                    [StampDateTime],
                    [StampUser]
                )
     VALUES
           ('reports'
           ,'Reports'
           ,@ReportsReportsSystemPath
           ,'-function'
           ,@ReportsSystemId)
END

-- Insert Add New Group node under Reports node.
IF NOT EXISTS (SELECT 1 FROM TSystem WHERE SystemPath = @ReportsAddNewGroupSystemPath)
BEGIN
INSERT INTO [dbo].[TSystem]
           ([Identifier]
           ,[Description]
           ,[SystemPath]
           ,[SystemType]
           ,[ParentId])
           OUTPUT 
                    INSERTED.[SystemId],
                    INSERTED.[Identifier],
                    INSERTED.[Description],
                    INSERTED.[SystemPath],
                    INSERTED.[SystemType],
                    INSERTED.[ParentId],
                    INSERTED.[Url],
                    INSERTED.[EntityId],
                    INSERTED.[ConcurrencyId],
                    'C',
                    GETUTCDATE(),
                    0
                INTO TSystemAudit
                (
                    [SystemId],
                    [Identifier],
                    [Description],
                    [SystemPath],
                    [SystemType],
                    [ParentId],
                    [Url],
                    [EntityId],
                    [ConcurrencyId],
                    [StampAction],
                    [StampDateTime],
                    [StampUser]
                )
     VALUES
           ('addnewgroup'
           ,'Add New Group'
           ,@ReportsAddNewGroupSystemPath
           ,'-action'
           ,@ReportsSystemId)
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
