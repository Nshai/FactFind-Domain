 
-----------------------------------------------------------------------------
-- Table: Administration.TPasswordPolicy
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'D3D2DF78-6AD3-4A92-8B55-55E43A39EB37'
     AND TenantId = 466
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TPasswordPolicy ON; 
 
        INSERT INTO TPasswordPolicy([PasswordPolicyId], [Expires], [ExpiryDays], [UniquePasswords], [MaxFailedLogins], [ChangePasswordOnFirstUse], [AutoPasswordGeneration], [AllowExpireAllPasswords], [AllowAutoUserNameGeneration], [IndigoClientId], [ConcurrencyId], [LockoutPeriodMinutes], [NumberOfMonthsBeforePasswordReuse])
        SELECT 466,1,30,5,3,0,1,0,1,466,1,5,0 
 
        SET IDENTITY_INSERT TPasswordPolicy OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'D3D2DF78-6AD3-4A92-8B55-55E43A39EB37', 
         'Initial load (1 total rows, file 1 of 1) for table TPasswordPolicy',
         466, 
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
-- #Rows Exported: 1
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
