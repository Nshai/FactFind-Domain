-----------------------------------------------------------------------------
--
-- Summary: SE-8208 - Archive AU Income Categories
--
-----------------------------------------------------------------------------
USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER = '600EA026-4CEF-4C56-8F4F-9E1F74E0FC54',
 @Comments VARCHAR(255) = 'Change Attributes Data in FactFind.TrefData'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGuid = @ScriptGUID) 
    RETURN 

SET NOCOUNT ON 
SET XACT_ABORT ON

BEGIN TRY

    BEGIN TRANSACTION

     UPDATE [factfind].[dbo].[TRefData] 
         SET Archived = 1
     OUTPUT
        deleted.RefDataId,
        deleted.Name,
        deleted.Type,
        deleted.Property,
        deleted.RegionCode,
        deleted.Attributes,
        deleted.TenantId,
        'U',
        GETUTCDATE(),
        0
     INTO TRefDataAudit (
          RefDataId,
          Name,
          Type,
          Property,
          RegionCode,
          Attributes,
          TenantId,
          StampAction,
          StampDateTime,
          StampUser
          )
     WHERE [RegionCode]='AU' AND [Type]='income' AND [Property]='category'
     AND [Name] in ('State Pension','Company Pension','Private Pension','Taxable State Benefits','Non-Taxable State Benefits','Bedroom Rental','Maintenance Payments','Working Tax Credit')

     -- Record execution so the script won't run again
     INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
     VALUES (@ScriptGUID, @Comments)

    COMMIT TRANSACTION

END TRY
BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000), @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH

SET XACT_ABORT OFF
SET NOCOUNT OFF