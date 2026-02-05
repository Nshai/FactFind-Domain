-----------------------------------------------------------------------------
--
-- Summary: INTTFF-541 SQL - Income data updates
--
-----------------------------------------------------------------------------
USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER = '3870FA22-CB95-4388-957F-49E348164F60'
DECLARE @StartTranCount int

-- Check if this script has already run
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGuid = @ScriptGUID) 
    RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
BEGIN TRY

	SELECT @StartTranCount = @@TRANCOUNT

	IF (@StartTranCount = 0)
        BEGIN TRANSACTION

	-- Remove duplicate Other Income for GB
	DELETE FROM TRefData
	WHERE RefDataId = 10

	-- Update the AU 'Other' to 'Other Income'
	UPDATE TRefData
	SET [Name] = 'Other Income'
	WHERE RefDataId = 21

	-- Add Other Irregular Income to AU
	SET IDENTITY_INSERT TRefData ON
	
	-- Add Basic income to AU
	INSERT INTO TRefData (RefDataId, [Name],[Type],[Property],[RegionCode],[Attributes],[TenantId])
	SELECT 100, [Name], [Type], Property, 'AU', '{\"party_types\":\"Person\",\"ordinal\":\"42\"}', NULL
	FROM TRefData
	WHERE RefDataId = 30

	INSERT INTO TRefData (RefDataId, [Name],[Type],[Property],[RegionCode],[Attributes],[TenantId])
	SELECT 99, [Name], [Type], Property, 'AU', '{\"party_types\":\"Person,Trust,Corporate\",\"ordinal\":\"42\"}', NULL
	FROM TRefData
	WHERE RefDataId = 65	

	SET IDENTITY_INSERT TRefData OFF

	-- Update ordinal for Rent,AU
	UPDATE TRefData
	SET Attributes = '{\"party_types\":\"Trust,Corporate\",\"ordinal\":\"44\"}'
	WHERE RefDataId = 20

	-- Update ordinal for Widow Allowance,AU
	UPDATE TRefData
	SET Attributes = '{\"party_types\":\"Person\",\"ordinal\":\"45\"}'
	WHERE RefDataId = 93

	-- Update ordinal for Youth Allowance,AU
	UPDATE TRefData
	SET Attributes = '{\"party_types\":\"Person\",\"ordinal\":\"46\"}'
	WHERE RefDataId = 96

    -- Record execution so the script won't run again
    INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
    VALUES (@ScriptGUID, 'Add Ordinal attribute to Income category ref data')
 
    IF (@StartTranCount = 0)
        COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF