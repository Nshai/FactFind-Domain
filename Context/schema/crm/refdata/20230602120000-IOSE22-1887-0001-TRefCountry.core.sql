 
-----------------------------------------------------------------------------
-- Table: CRM.TRefCountry
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'CF92AF12-E310-4024-995D-4EDA0BECD6B3'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefCountry ON; 
 
        INSERT INTO TRefCountry([RefCountryId], [CountryName], [ArchiveFG], [Extensible], [ConcurrencyId], [CountryCode])

		OUTPUT 
			inserted.CountryName,
			inserted.ArchiveFG,
			inserted.Extensible,
			inserted.ConcurrencyId,
			inserted.RefCountryId,
			'C',
			GETUTCDATE(),
			0,
			inserted.CountryCode
        INTO 
			TRefCountryAudit 
				(
					CountryName,
					ArchiveFG,
					Extensible,
					ConcurrencyId,
					RefCountryId,
					StampAction,
					StampDateTime, 
					StampUser,
					CountryCode					
				)

        VALUES
			(262,'Scotland',0,NULL,1,'XS'),
			(263,'Wales',0,NULL,1,'XW'),
			(264,'England',0,NULL,1,'XE'),
			(265,'Northern Ireland',0,NULL,1,'XN')
        
 
        SET IDENTITY_INSERT TRefCountry OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'CF92AF12-E310-4024-995D-4EDA0BECD6B3', 
         'Adding new countries XS,XW,XE,XN to the table TRefCountry',
         null, 
         GETUTCDATE() )
 
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
-- #Rows Exported: 4
-- Created by Arun Sivan, Jun 2 2023  1:00PM
-----------------------------------------------------------------------------
