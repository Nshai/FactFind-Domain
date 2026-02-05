 
-----------------------------------------------------------------------------
-- Table: CRM.TRefNationality2RefCountry 
-----------------------------------------------------------------------------
 
USE crm

DECLARE @ScriptGUID UNIQUEIDENTIFIER = '2d19ce96-1b67-44dc-8964-fbd8291c4f17'

-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = @ScriptGUID
) RETURN 
 
------------------------------------------------------------------------------
-- Summary: GFF-983 SQL - Updates Cambodian, Cape Verdean nationalities under table 
-- TRefNationality2RefCountry with correct country codes.
-- Expected records updated: 2
-------------------------------------------------------------------------------
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
    -- update the records
    UPDATE TRefNationality2RefCountry
    SET RefCountryId = 41,
        Descriptor = 'Cape Verde',
        ISOAlpha2Code = 'CV',
        ISOAlpha3Code = 'CPV'
    WHERE RefNationalityId =36
       
    UPDATE TRefNationality2RefCountry
    SET RefCountryId = 38
    WHERE RefNationalityId =33

     -- record execution so the script won't run again
     INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
     VALUES (
     @ScriptGUID, 
     'GFF-983 SQL - Updates Cambodian, Cape Verdean nationalities under TRefNationality2RefCountry with correct country codes.')
 
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