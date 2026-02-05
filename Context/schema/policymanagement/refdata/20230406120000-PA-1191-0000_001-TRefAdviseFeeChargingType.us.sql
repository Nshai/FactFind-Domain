USE [PolicyManagement]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = '8246EFB7-75B6-436C-9A22-E0DC0EC71087'
      , @Comments = 'PA-1191 Tiered fee creation within Fee Charging Type'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

DECLARE @StampAction CHAR(1) = 'C'
	, @StampDateTime AS DATETIME = GETUTCDATE()
	, @StampUser AS VARCHAR(255) = '0'

BEGIN TRANSACTION
    
    BEGIN TRY
        SET IDENTITY_INSERT TRefAdviseFeeChargingType ON
        
        INSERT INTO TRefAdviseFeeChargingType([RefAdviseFeeChargingTypeId], [Name], [IsUsedAsInitialFee], [IsUsedAsRecurringFee], [IsUsedAsOneOffFee], [IsPercentageBased])
        OUTPUT inserted.[RefAdviseFeeChargingTypeId]
			, inserted.[Name]
			, inserted.[IsUsedAsInitialFee]
			, inserted.[IsUsedAsRecurringFee]
			, inserted.[IsUsedAsOneOffFee]
			, inserted.[IsPercentageBased]
			, @StampAction
			, @StampDateTime
			, @StampUser
        INTO TRefAdviseFeeChargingTypeAudit([RefAdviseFeeChargingTypeId], [Name], [IsUsedAsInitialFee], [IsUsedAsRecurringFee], [IsUsedAsOneOffFee], [IsPercentageBased], [StampAction], [StampDateTime], [StampUser])
        SELECT 11, 'Tiered Fee, % of AUM, Blended Arrears',0,1,0,1 UNION ALL 
        SELECT 12, 'Tiered Fee, % of AUM, Blended Advanced',0,1,0,1 UNION ALL 
        SELECT 13, 'Tiered Fee, % of AUM, Cliff Arrears',0,1,0,1 UNION ALL 
        SELECT 14, 'Tiered Fee, % of AUM, Cliff Advanced',0,1,0,1 
                    
        SET IDENTITY_INSERT TRefAdviseFeeChargingType OFF
    END TRY
    BEGIN CATCH
    
        SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
        WHILE(@@TRANCOUNT > 0)ROLLBACK
        RETURN
    
    END CATCH

    INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)
    
COMMIT TRANSACTION

IF @@TRANCOUNT > 0
BEGIN
       ROLLBACK
       RETURN
       PRINT 'Open transaction found, aborting'
END

RETURN;
