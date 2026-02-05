 
-----------------------------------------------------------------------------
-- Table: FactFind.TRefData
-----------------------------------------------------------------------------
 
USE FactFind

DECLARE @ScriptGUID UNIQUEIDENTIFIER = '8389c025-29de-4ede-8fc3-0e769cbfa631'

-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = @ScriptGUID
) RETURN 
 
------------------------------------------------------------------------------
-- Summary: INTTFF-93 SQL - Add Income category ref data based on region
-- Expected records added: 23
-------------------------------------------------------------------------------
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
       -- insert the records
       SET IDENTITY_INSERT [TRefData] ON
 
       INSERT INTO [TRefData]([RefDataId],[Name],[Type],[Property],[RegionCode],[Attributes])
	   VALUES (1,'Capital Gains','income','category','GB','{\"party_types\":\"Trust,Corporate\"}'), 
        (2,'Foreign Income','income','category','GB','{\"party_types\":\"Trust,Corporate\"}'),
		(3,'Franking Credits','income','category','GB','{\"party_types\":\"Trust,Corporate\"}'),
		(4,'Share of Net Income','income','category','GB','{\"party_types\":\"Trust,Corporate\"}'),
		(5,'Exempt Current Pension Income','income','category','GB','{\"party_types\":\"Trust,Corporate\"}'),
		(6,'Franked Dividends','income','category','GB','{\"party_types\":\"Trust,Corporate\"}'),
		(7,'General Income','income','category','GB','{\"party_types\":\"Trust,Corporate\"}'),
		(8,'Interest','income','category','GB','{\"party_types\":\"Trust,Corporate\"}'),
		(9,'Rent','income','category','GB','{\"party_types\":\"Trust,Corporate\"}'),
		(10,'Other','income','category','GB','{\"party_types\":\"Trust,Corporate\"}'),
		(11,'Net Profit','income','category','AU','{\"party_types\":\"Trust\"}'),
		(12,'Capital Gains','income','category','AU','{\"party_types\":\"Trust,Corporate\"}'), 
        (13,'Foreign Income','income','category','AU','{\"party_types\":\"Trust,Corporate\"}'),
		(14,'Franking Credits','income','category','AU','{\"party_types\":\"Trust,Corporate\"}'),
		(15,'Share of Net Income','income','category','AU','{\"party_types\":\"Trust,Corporate\"}'),
		(16,'Exempt Current Pension Income','income','category','AU','{\"party_types\":\"Trust,Corporate\"}'),
		(17,'Franked Dividends','income','category','AU','{\"party_types\":\"Trust,Corporate\"}'),
		(18,'General Income','income','category','AU','{\"party_types\":\"Trust,Corporate\"}'),
		(19,'Interest','income','category','AU','{\"party_types\":\"Trust,Corporate\"}'),
		(20,'Rent','income','category','AU','{\"party_types\":\"Trust,Corporate\"}'),
		(21,'Other','income','category','AU','{\"party_types\":\"Trust,Corporate\"}'),
		(22,'Net Profit','income','category','AU','{\"party_types\":\"Trust\"}'),
		(23,'Non-arms-length Income of a Complying SMSF','income','category','AU','{\"party_types\":\"Trust,Corporate\"}')

        SET IDENTITY_INSERT [TRefData] OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments) 
        VALUES (
         @ScriptGUID, 
         'INTTFF-93 SQL - Add Income category ref data based on region')
 
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