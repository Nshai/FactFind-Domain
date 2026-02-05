USE [PolicyManagement]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = 'BCB3D404-8F83-451E-84EC-8A8EE72B3E58'
      , @Comments = 'PA-1197 Update existing TRefAdviseFeeChargingType'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

DECLARE @StampAction CHAR(1) = 'U'
	, @StampDateTime AS DATETIME = GETUTCDATE()
	, @StampUser AS VARCHAR(255) = '0'

BEGIN TRANSACTION
    
    BEGIN TRY

        if object_id('tempdb..#AdviseFeeChargingTypeIds') is not null drop table #AdviseFeeChargingTypeIds
	        create table #AdviseFeeChargingTypeIds (RefAdviseFeeChargingTypeId int primary key)

        insert into #AdviseFeeChargingTypeIds(RefAdviseFeeChargingTypeId)
        values (11), (12), (13), (14)

        UPDATE TRefAdviseFeeChargingType
        SET [IsTieredPercentage] = 1
        OUTPUT inserted.[RefAdviseFeeChargingTypeId]
			, inserted.[Name]
			, inserted.[IsUsedAsInitialFee]
			, inserted.[IsUsedAsRecurringFee]
			, inserted.[IsUsedAsOneOffFee]
			, inserted.[IsPercentageBased]
            , inserted.[IsTieredPercentage]
			, @StampAction
			, @StampDateTime
			, @StampUser
        INTO TRefAdviseFeeChargingTypeAudit([RefAdviseFeeChargingTypeId], [Name], [IsUsedAsInitialFee], [IsUsedAsRecurringFee], [IsUsedAsOneOffFee], [IsPercentageBased], [IsTieredPercentage], [StampAction], [StampDateTime], [StampUser])
        WHERE [RefAdviseFeeChargingTypeId] IN (SELECT [RefAdviseFeeChargingTypeId] FROM #AdviseFeeChargingTypeIds)

    END TRY
    BEGIN CATCH
    
        SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
        WHILE(@@TRANCOUNT > 0)ROLLBACK
        RETURN
    
    END CATCH

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)
    
COMMIT TRANSACTION

if object_id('tempdb..#AdviseFeeChargingTypeIds') is not null drop table #AdviseFeeChargingTypeIds

IF @@TRANCOUNT > 0
BEGIN
       ROLLBACK
       RETURN
       PRINT 'Open transaction found, aborting'
END

RETURN;
