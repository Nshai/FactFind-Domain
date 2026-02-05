-----------------------------------------------------------------------------
-- Table: FactFind.TRefExpenditureGroup
-----------------------------------------------------------------------------
 
USE FactFind

DECLARE @ScriptId UNIQUEIDENTIFIER 
SET  @ScriptId = '99408CCA-6D12-48A9-AA46-35348B4A9C65'

-- Check that this script has not already been run
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGuid = @ScriptId) 
	RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int

BEGIN TRY
    
	SELECT @starttrancount = @@TRANCOUNT
    
	IF (@starttrancount = 0)
		BEGIN TRANSACTION

		-- Populate TRefExpenditureType2ExpenditureGroup 
		-- with correct Expenditure Type to Group associations after 
		-- TRefExpenditureGroup has been modified to include tenant specific Expenditure groups
		INSERT INTO 
			TRefExpenditureType2ExpenditureGroup (ExpenditureTypeId, ExpenditureGroupId)
		SELECT e.TypeId, eg.RefExpenditureGroupId
		FROM TRefExpenditureGroup eg
		INNER JOIN 
		(
			SELECT t.RefExpenditureTypeId as TypeId, t.Name as typeName, g.Name as GroupName
			FROM TRefExpenditureType t
			INNER JOIN TRefExpenditureGroup g on t.RefExpenditureGroupId = g.RefExpenditureGroupId 
		) e --Get Group Name
		ON e.GroupName = eg.Name 
		WHERE eg.TenantId IS NOT NULL
		ORDER BY e.TypeId, eg.RefExpenditureGroupId


    -- record execution so the script won't run again
    INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
    VALUES (@ScriptId, 'GFF-928 Add Correct Expenditure type to expenditure group associations in TRefExpenditureType2ExpenditureGroup', NULL, GETDATE() )
 
	IF (@starttrancount = 0)
		COMMIT TRANSACTION
 
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH
 
 SET XACT_ABORT OFF
 SET NOCOUNT OFF

