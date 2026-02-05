 
-----------------------------------------------------------------------------
-- Table: FactFind.TAtrRefAssetClass
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '92826DBC-0A0C-4FBC-80A1-4D5F5D5F8A36'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TAtrRefAssetClass ON; 
 
        INSERT INTO TAtrRefAssetClass([AtrRefAssetClassId], [Identifier], [ShortName], [Ordering], [ConcurrencyId])
        SELECT 51, 'Private Equity', 'Private Equity',4,1 UNION ALL 
        SELECT 50, 'Other', 'Other',4,1 UNION ALL 
        SELECT 49, 'Hedge Funds', 'Hedge Funds',4,1 UNION ALL 
        SELECT 48, 'Commodities', 'Commodities',4,1 UNION ALL 
        SELECT 47, 'US Equity', 'US Equity',4,1 UNION ALL 
        SELECT 46, 'UK Equity', 'UK Equity',4,1 UNION ALL 
        SELECT 45, 'Japan Equity', 'Japan Equity',4,1 UNION ALL 
        SELECT 44, 'Index Linked Bonds', 'Index Linked Bonds',4,1 UNION ALL 
        SELECT 43, 'Government Bonds', 'Gov. Bonds',4,1 UNION ALL 
        SELECT 42, 'Global Emerging Market Equity (GEM)', 'GEM',4,1 UNION ALL 
        SELECT 41, 'European Equities', 'European Equities',4,1 UNION ALL 
        SELECT 40, 'Corporate Bonds (Inv Grade)', 'Inv Grade',4,1 UNION ALL 
        SELECT 39, 'Corporate Bonds (High Yield)', 'High Yield',4,1 UNION ALL 
        SELECT 38, 'Asia Ex Japan', 'Asia Ex Japan',4,1 UNION ALL 
        SELECT 37, 'UK Equities', 'UK Equities',3,1 UNION ALL 
        SELECT 36, 'Specialist equity', 'Specialist equity',3,1 UNION ALL 
        SELECT 35, 'Overseas equity', 'Overseas equity',3,1 UNION ALL 
        SELECT 34, 'Fixed interest', 'Fixed interest',3,1 UNION ALL 
        SELECT 33, 'Equities', 'Equities',3,1 UNION ALL 
        SELECT 32, 'Bonds', 'Bonds',3,1 UNION ALL 
        SELECT 31, 'UK Zeros', 'UK Zeros',3,1 UNION ALL 
        SELECT 30, 'UK Smaller Companies', 'UK Smaller Companies',3,1 UNION ALL 
        SELECT 29, 'UK Other Bond', 'UK Other Bond',3,1 UNION ALL 
        SELECT 28, 'UK Index Linked Gilts', 'UK Index Linked Gilts',3,1 UNION ALL 
        SELECT 27, 'UK Gilts', 'UK Gilts',3,1 UNION ALL 
        SELECT 26, 'UK Equity Income', 'UK Equity Income',3,1 UNION ALL 
        SELECT 25, 'UK Equity & Bond Income', 'UK Equity & Bond Income',3,1 UNION ALL 
        SELECT 24, 'UK Corporate Bond', 'UK Corporate Bond',3,1 UNION ALL 
        SELECT 23, 'UK All Companies', 'UK All Companies',3,1 UNION ALL 
        SELECT 22, 'Technology & Telecommunications', 'Technology & Telecommunications',3,1 UNION ALL 
        SELECT 21, 'Specialist', 'Specialist',3,1 UNION ALL 
        SELECT 20, 'Protected/Guaranteed', 'Protected/Guaranteed',3,1 UNION ALL 
        SELECT 19, 'Personal Pensions', 'Personal Pensions',3,1 UNION ALL 
        SELECT 18, 'North American Smaller Companies', 'North American Smaller Companies',3,1 UNION ALL 
        SELECT 17, 'North America', 'North America',3,1 UNION ALL 
        SELECT 16, 'Money Market', 'Money Market',3,1 UNION ALL 
        SELECT 15, 'Japanese Smaller Companies', 'Japanese Smaller Companies',3,1 UNION ALL 
        SELECT 14, 'Japan', 'Japan',3,1 UNION ALL 
        SELECT 13, 'Global Growth', 'Global Growth',3,1 UNION ALL 
        SELECT 12, 'Global Emerging Markets', 'Global Emerging Markets',3,1 UNION ALL 
        SELECT 11, 'Global Bonds', 'Global Bonds',3,1 UNION ALL 
        SELECT 10, 'European Smaller Companies', 'European Smaller Companies',3,1 UNION ALL 
        SELECT 9, 'Europe including UK', 'Europe including UK',3,1 UNION ALL 
        SELECT 8, 'Europe excluding UK', 'Europe excluding UK',3,1 UNION ALL 
        SELECT 7, 'Cautious Managed', 'Cautious Managed',3,1 UNION ALL 
        SELECT 6, 'Balanced Managed', 'Balanced Managed',3,1 UNION ALL 
        SELECT 5, 'Asia Pacific including Japan', 'Asia Pacific including Japan',3,1 UNION ALL 
        SELECT 4, 'Asia Pacific excluding Japan', 'Asia Pacific excluding Japan',3,1 UNION ALL 
        SELECT 3, 'Active Managed', 'Active Managed',3,1 UNION ALL 
        SELECT 2, 'Property', 'Property',2,1 UNION ALL 
        SELECT 1, 'Cash', 'Cash',1,1 
 
        SET IDENTITY_INSERT TAtrRefAssetClass OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '92826DBC-0A0C-4FBC-80A1-4D5F5D5F8A36', 
         'Initial load (51 total rows, file 1 of 1) for table TAtrRefAssetClass',
         null, 
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
-- #Rows Exported: 51
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
