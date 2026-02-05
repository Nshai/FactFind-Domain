USE [policymanagement]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = 'BCC48E7F-1D56-4464-9FDE-5FC44E89EFDB'
      , @Comments = 'PA-17961 - Change PortfolioCategory for some US plan types'
      
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN; 

CREATE TABLE #planTypesToUpdate (
    RefPlanType2ProdSubTypeId INT
);

BEGIN TRANSACTION
    
    BEGIN TRY
        -- Please be aware all names in brackets {} should be replaced with the actual names

		INSERT INTO #planTypesToUpdate
		VALUES (1232), (1233), (1246), (1247), (1248), (1249)

		UPDATE rpt
		SET 
			RefPortfolioCategoryId = 4, 
			RefPlanDiscriminatorId = 6
		OUTPUT
			  deleted.[RefPlanType2ProdSubTypeId]
			  ,deleted.[RefPlanTypeId]
			  ,deleted.[ProdSubTypeId]
			  ,deleted.[RefPortfolioCategoryId]
			  ,deleted.[RefPlanDiscriminatorId]
			  ,deleted.[DefaultCategory]
			  ,deleted.[ConcurrencyId]
			  ,deleted.[IsArchived]
			  ,deleted.[IsConsumerFriendly]
			  ,deleted.[RegionCode]
			  ,'U'
			  ,GETDATE()
			  ,0
			INTO TRefPlanType2ProdSubTypeAudit(
			  [RefPlanType2ProdSubTypeId]
			  ,[RefPlanTypeId]
			  ,[ProdSubTypeId]
			  ,[RefPortfolioCategoryId]
			  ,[RefPlanDiscriminatorId]
			  ,[DefaultCategory]
			  ,[ConcurrencyId]
			  ,[IsArchived]
			  ,[IsConsumerFriendly]
			  ,[RegionCode]
			  ,StampAction
			  ,StampDateTime
			  ,StampUser
			)
		FROM TRefPlanType2ProdSubType rpt
		INNER JOIN #planTypesToUpdate pu ON pu.RefPlanType2ProdSubTypeId = rpt.RefPlanType2ProdSubTypeId

        -- END DATA INSERT/UPDATE
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
IF (SELECT OBJECT_ID('tempdb..#planTypesToUpdate')) IS NOT NULL
       DROP TABLE #planTypesToUpdate


-- Check for ANY open transactions
-- This applies not only to THIS script but will rollback any open transactions in any scripts that have been run before this one.
IF @@TRANCOUNT > 0
BEGIN
       ROLLBACK
       RETURN
       PRINT 'Open transaction found, aborting'
END

RETURN;
