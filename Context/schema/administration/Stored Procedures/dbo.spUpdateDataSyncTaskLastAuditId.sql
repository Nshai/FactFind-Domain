SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************************
This is used to update LastAuditId for specific data synchronization task.
It is expected to be used in recovery scenarios only.
******************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spUpdateDataSyncTaskLastAuditId]
    @dataSyncTaskId INT,
    @lastAuditId INT
AS
BEGIN

    UPDATE [dbo].[TEntitlementDataSyncTask]
    SET 
        LastAuditId = @lastAuditId
        ,LastUpdatedAt = GETUTCDATE()
    OUTPUT
        inserted.[EntitlementDataSyncTaskId]
        ,inserted.[SourceTable]
        ,inserted.[LastAuditId]
        ,inserted.[Status]
        ,inserted.[LastUpdatedAt]
        ,'U'
        ,GETUTCDATE()
        ,0
    INTO [dbo].[TEntitlementDataSyncTaskAudit]
    ( 
        [EntitlementDataSyncTaskId]
        ,[SourceTable]
        ,[LastAuditId]
        ,[Status]
        ,[LastUpdatedAt]
        ,[StampAction]
        ,[StampDateTime]
        ,[StampUser]
    )
    OUTPUT
        inserted.[EntitlementDataSyncTaskId]
        ,inserted.[SourceTable]
        ,inserted.[LastAuditId]
        ,inserted.[Status]
        ,inserted.[LastUpdatedAt]
    WHERE EntitlementDataSyncTaskId = @dataSyncTaskId;

END
GO