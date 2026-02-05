 
-----------------------------------------------------------------------------
-- Table: CRM.TRefBank
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '66D1F81E-7289-41E0-A424-5A1FC493C305'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefBank ON; 
 
        INSERT INTO TRefBank([RefBankId], [Name], [ConcurrencyId])
        SELECT 89, 'Islamic Bank of Britain plc ',1 UNION ALL 
        SELECT 88, 'Investec Bank (UK) Ltd ',1 UNION ALL 
        SELECT 87, 'ICICI Bank UK Ltd ',1 UNION ALL 
        SELECT 86, 'ICBC (London) Ltd ',1 UNION ALL 
        SELECT 85, 'HSBC Trust Company (UK) Ltd ',1 UNION ALL 
        SELECT 84, 'HSBC Private Bank (UK) Ltd ',1 UNION ALL 
        SELECT 83, 'HSBC Bank plc ',1 UNION ALL 
        SELECT 82, 'HFC Bank plc ',1 UNION ALL 
        SELECT 81, 'Heritable Bank Ltd ',1 UNION ALL 
        SELECT 80, 'HBOS Treasury Services plc ',1 UNION ALL 
        SELECT 79, 'Havin Bank Ltd ',1 UNION ALL 
        SELECT 78, 'Harrods Bank Ltd ',1 UNION ALL 
        SELECT 77, 'Hardware Federation Finance Co Ltd',1 UNION ALL 
        SELECT 76, 'Hampshire Trust plc ',1 UNION ALL 
        SELECT 75, 'Halifax plc ',1 UNION ALL 
        SELECT 74, 'Habibsons Bank Ltd ',1 UNION ALL 
        SELECT 73, 'Habib Allied International Bank plc ',1 UNION ALL 
        SELECT 72, 'Gulf International Bank (UK) Ltd ',1 UNION ALL 
        SELECT 71, 'Goldman Sachs International Bank ',1 UNION ALL 
        SELECT 70, 'Goldfish Bank Limited ',1 UNION ALL 
        SELECT 69, 'Ghana International Bank plc ',1 UNION ALL 
        SELECT 68, 'GE Capital Bank Ltd ',1 UNION ALL 
        SELECT 67, 'FIBI Bank (UK) plc ',1 UNION ALL 
        SELECT 190, 'Danske Bank',1 UNION ALL 
        SELECT 191, 'Kingdom Bank',1 UNION ALL 
        SELECT 192, 'Lloyds Bank plc',1 UNION ALL 
        SELECT 193, 'TSB Bank plc',1 UNION ALL 
        SELECT 194, 'Metro Bank plc',1 UNION ALL 
        SELECT 195, 'Royal Bank of Scotland International',1 UNION ALL 
        SELECT 196, 'The Bank of Bahrain & Kuwait',1 UNION ALL 
        SELECT 197, 'Starling Bank',1 UNION ALL 
        SELECT 198, 'ThinkMoney',1 UNION ALL 
        SELECT 199, 'Nedbank Private Wealth',1 UNION ALL 
        SELECT 200, 'Hampden & Co Bank',1 UNION ALL 
        SELECT 201, 'Coventry Building Society',1 UNION ALL 
        SELECT 202, 'The one account',1 UNION ALL 
        SELECT 189, 'Cahoot',1 UNION ALL 
        SELECT 188, 'St James''s Place Bank',1 UNION ALL 
        SELECT 187, 'Isle Of Man Bank',1 UNION ALL 
        SELECT 186, 'Intelligent Finance',1 UNION ALL 
        SELECT 185, 'Smile',1 UNION ALL 
        SELECT 184, 'The Charity Bank Limited',1 UNION ALL 
        SELECT 183, 'Saxo Bank AS',1 UNION ALL 
        SELECT 182, 'Fairbairn Private Bank Limited',1 UNION ALL 
        SELECT 181, 'Santander',1 UNION ALL 
        SELECT 180, 'ING Direct',1 UNION ALL 
        SELECT 179, 'Cumberland Building Society',1 UNION ALL 
        SELECT 178, 'Handelsbanken',2 UNION ALL 
        SELECT 177, '',1 UNION ALL 
        SELECT 176, 'Close Wealth Management Group',1 UNION ALL 
        SELECT 175, 'Norwich and Peterborough Building Society',1 UNION ALL 
        SELECT 174, 'Anglo Irish Bank',1 UNION ALL 
        SELECT 173, 'Hinckley & Rugby Building Society',1 UNION ALL 
        SELECT 172, 'Yorkshire Building Society',1 UNION ALL 
        SELECT 171, 'Yorkshire Bank',1 UNION ALL 
        SELECT 170, 'Bank of Ireland',1 UNION ALL 
        SELECT 168, 'Bank Of Cyprus',1 UNION ALL 
        SELECT 167, 'Virgin One',1 UNION ALL 
        SELECT 166, 'First Direct',1 UNION ALL 
        SELECT 165, 'Woolwich',1 UNION ALL 
        SELECT 163, 'First Trust Bank',1 UNION ALL 
        SELECT 162, 'Nationwide',1 UNION ALL 
        SELECT 161, 'Zenith Bank (UK) Limited ',1 UNION ALL 
        SELECT 160, 'Whiteaway Laidlaw Bank Ltd ',1 UNION ALL 
        SELECT 159, 'Westpac Europe Limited ',1 UNION ALL 
        SELECT 158, 'West Merchant Bank Ltd ',1 UNION ALL 
        SELECT 157, 'Wesleyan Savings Bank Ltd ',1 UNION ALL 
        SELECT 156, 'Weatherbys Bank Ltd ',1 UNION ALL 
        SELECT 155, 'VTB Bank Europe Plc ',1 UNION ALL 
        SELECT 154, 'Vanquis Bank Ltd ',1 UNION ALL 
        SELECT 66, 'FCE Bank plc ',1 UNION ALL 
        SELECT 65, 'FBN (UK) Ltd ',1 UNION ALL 
        SELECT 64, 'European Islamic Investment Bank Plc ',1 UNION ALL 
        SELECT 63, 'Europe Arab Bank Plc ',1 UNION ALL 
        SELECT 62, 'Egg Banking plc ',1 UNION ALL 
        SELECT 61, 'EFG Private Bank Ltd ',1 UNION ALL 
        SELECT 60, 'Duncan Lawrie Ltd ',1 UNION ALL 
        SELECT 59, 'Dunbar Bank plc ',1 UNION ALL 
        SELECT 58, 'Dresdner Kleinwort Limited ',1 UNION ALL 
        SELECT 57, 'DB UK Bank Limited ',1 UNION ALL 
        SELECT 56, 'Crown Agents Bank Ltd ',1 UNION ALL 
        SELECT 55, 'Credit Suisse International ',1 UNION ALL 
        SELECT 54, 'Credit Suisse (UK) Ltd ',1 UNION ALL 
        SELECT 53, 'Coutts & Co ',1 UNION ALL 
        SELECT 52, 'Co-operative Bank plc ',1 UNION ALL 
        SELECT 51, 'Conversbank (UK) Limited ',1 UNION ALL 
        SELECT 50, 'Consolidated Credits Bank Ltd ',1 UNION ALL 
        SELECT 49, 'Clydesdale Bank plc ',1 UNION ALL 
        SELECT 48, 'Close Brothers Ltd ',1 UNION ALL 
        SELECT 47, 'Citibank International plc ',1 UNION ALL 
        SELECT 46, 'Citi Financial Europe plc ',1 UNION ALL 
        SELECT 45, 'CIT Bank Limited ',1 UNION ALL 
        SELECT 44, 'CIBC World Markets plc ',1 UNION ALL 
        SELECT 43, 'Church House Trust plc ',1 UNION ALL 
        SELECT 42, 'Cheltenham & Gloucester plc ',1 UNION ALL 
        SELECT 41, 'Charity Bank Ltd ',1 UNION ALL 
        SELECT 40, 'Cater Allen Ltd ',1 UNION ALL 
        SELECT 39, 'Capital One Bank (Europe) plc ',1 UNION ALL 
        SELECT 38, 'Capital Bank plc ',1 UNION ALL 
        SELECT 37, 'CAF Bank Ltd ',1 UNION ALL 
        SELECT 36, 'C Hoare & Co ',1 UNION ALL 
        SELECT 35, 'Butterfield Bank (UK) Ltd ',1 UNION ALL 
        SELECT 34, 'Brown Shipley & Co. Ltd ',1 UNION ALL 
        SELECT 33, 'Broadcastle Bank ltd ',1 UNION ALL 
        SELECT 32, 'British Arab Commercial Bank Ltd ',1 UNION ALL 
        SELECT 31, 'Bristol & West plc ',1 UNION ALL 
        SELECT 30, 'Bradford & Bingley plc ',1 UNION ALL 
        SELECT 29, 'Barclays Bank Trust Company Ltd ',1 UNION ALL 
        SELECT 28, 'Barclays Bank plc ',1 UNION ALL 
        SELECT 27, 'Bankers Trust International plc ',1 UNION ALL 
        SELECT 26, 'Bank Sepah International plc ',1 UNION ALL 
        SELECT 25, 'Bank Saderat plc ',1 UNION ALL 
        SELECT 24, 'Bank of Scotland (Governor and Company of the Bank of Scotland) ',1 UNION ALL 
        SELECT 23, 'Bank of Philippine Islands (Europe) PLC ',1 UNION ALL 
        SELECT 22, 'Bank of New York Europe Ltd ',1 UNION ALL 
        SELECT 21, 'Bank of London and The Middle East plc ',1 UNION ALL 
        SELECT 20, 'Bank of Beirut (UK) Ltd ',1 UNION ALL 
        SELECT 19, 'Bank Mandiri (Europe) Ltd ',1 UNION ALL 
        SELECT 18, 'Bank Leumi (UK) plc ',1 UNION ALL 
        SELECT 17, 'Banc of America Securities Ltd ',1 UNION ALL 
        SELECT 16, 'Arbuthnot Latham & Co Ltd ',1 UNION ALL 
        SELECT 15, 'ANZ Bank (Europe) Ltd ',1 UNION ALL 
        SELECT 14, 'Ansbacher & Co Ltd ',1 UNION ALL 
        SELECT 13, 'Anglo-Romanian Bank Ltd ',1 UNION ALL 
        SELECT 12, 'AMC Bank Ltd ',1 UNION ALL 
        SELECT 11, 'Alpha Bank London Ltd ',1 UNION ALL 
        SELECT 10, 'Allied Irish Bank',2 UNION ALL 
        SELECT 9, 'Allied Bank Philippines (UK) plc ',1 UNION ALL 
        SELECT 8, 'Alliance Trust Savings Ltd ',1 UNION ALL 
        SELECT 7, 'Alliance & Leicester plc ',1 UNION ALL 
        SELECT 6, 'Airdrie Savings Bank ',1 UNION ALL 
        SELECT 5, 'Ahli United Bank (UK) plc ',1 UNION ALL 
        SELECT 4, 'Adam & Company plc ',1 UNION ALL 
        SELECT 3, 'ABC International Bank plc ',1 UNION ALL 
        SELECT 2, 'Abbey National Treasury Services plc ',1 UNION ALL 
        SELECT 1, 'Abbey National plc ',1 UNION ALL 
        SELECT 164, 'Britannia Building Society',1 UNION ALL 
        SELECT 153, 'Unity Trust Bank plc ',1 UNION ALL 
        SELECT 152, 'United Trust Bank Ltd ',1 UNION ALL 
        SELECT 151, 'United National Bank Ltd ',1 UNION ALL 
        SELECT 150, 'Union Bank UK plc ',1 UNION ALL 
        SELECT 149, 'Ulster Bank Ltd ',1 UNION ALL 
        SELECT 148, 'UBS Ltd ',1 UNION ALL 
        SELECT 147, 'Turkish Bank (UK) Ltd ',1 UNION ALL 
        SELECT 146, 'Tesco Personal Finance Ltd ',1 UNION ALL 
        SELECT 145, 'TD Bank Europe Ltd ',1 UNION ALL 
        SELECT 144, 'Sumitomo Mitsui Banking Corporation Europe Ltd ',1 UNION ALL 
        SELECT 143, 'State Street Bank Europe Ltd ',1 UNION ALL 
        SELECT 142, 'Standard Life Bank Ltd ',1 UNION ALL 
        SELECT 141, 'Standard Chartered Bank ',1 UNION ALL 
        SELECT 140, 'Standard Bank Plc ',1 UNION ALL 
        SELECT 139, 'Southsea Mortgage & Investment Co Ltd ',1 UNION ALL 
        SELECT 138, 'Sonali Bank (UK) Ltd ',1 UNION ALL 
        SELECT 137, 'Smith & Williamson Investment Management Ltd ',1 UNION ALL 
        SELECT 136, 'Siemens Financial Services Ltd ',1 UNION ALL 
        SELECT 135, 'SG Hambros Bank Limited ',1 UNION ALL 
        SELECT 134, 'Secure Trust Bank plc ',1 UNION ALL 
        SELECT 133, 'Scottish Widows Bank plc ',1 UNION ALL 
        SELECT 132, 'Scotiabank Europe plc ',1 UNION ALL 
        SELECT 131, 'Schroder & Co Ltd ',1 UNION ALL 
        SELECT 130, 'Sainsburys Bank plc ',1 UNION ALL 
        SELECT 129, 'Sabanci Bank Limited ',1 UNION ALL 
        SELECT 128, 'Ruffler Bank plc ',1 UNION ALL 
        SELECT 127, 'Royal Bank of Scotland plc',1 UNION ALL 
        SELECT 126, 'Royal Bank of Canada Europe Ltd ',1 UNION ALL 
        SELECT 125, 'Reliance Bank Ltd ',1 UNION ALL 
        SELECT 124, 'Rathbone Investment Management Ltd ',1 UNION ALL 
        SELECT 123, 'R Raphael & Sons plc ',1 UNION ALL 
        SELECT 122, 'Punjab National Bank (International) Ltd ',1 UNION ALL 
        SELECT 121, 'Philippine National Bank (Europe) plc ',1 UNION ALL 
        SELECT 120, 'Persia International Bank Ltd ',1 UNION ALL 
        SELECT 119, 'Northern Trust Global Services Limited ',1 UNION ALL 
        SELECT 118, 'Northern Rock plc ',1 UNION ALL 
        SELECT 117, 'Northern Bank Ltd ',1 UNION ALL 
        SELECT 116, 'Northern Bank Executor & Trustee Company Ltd ',1 UNION ALL 
        SELECT 115, 'Nomura Bank International plc ',1 UNION ALL 
        SELECT 114, 'National Westminster Bank plc ',1 UNION ALL 
        SELECT 113, 'National Bank of Kuwait (International) plc ',1 UNION ALL 
        SELECT 112, 'National Bank of Egypt International Ltd ',1 UNION ALL 
        SELECT 111, 'N M Rothschild & Sons Ltd ',1 UNION ALL 
        SELECT 110, 'Morgan Stanley Bank International Ltd ',1 UNION ALL 
        SELECT 109, 'Mizuho International plc ',1 UNION ALL 
        SELECT 108, 'Methodist Chapel Aid Ltd ',1 UNION ALL 
        SELECT 107, 'Melli Bank plc ',1 UNION ALL 
        SELECT 106, 'MediCapital Bank plc ',1 UNION ALL 
        SELECT 105, 'MBNA Europe Bank Ltd ',1 UNION ALL 
        SELECT 104, 'Marks and Spencer Financial Services plc ',1 UNION ALL 
        SELECT 103, 'London Scottish Bank plc ',1 UNION ALL 
        SELECT 102, 'Lloyds TSB Scotland plc ',1 UNION ALL 
        SELECT 101, 'Lloyds TSB Private Banking Ltd ',1 UNION ALL 
        SELECT 100, 'Lloyds TSB Bank plc ',1 UNION ALL 
        SELECT 99, 'Liverpool Victoria Banking Services Ltd ',1 UNION ALL 
        SELECT 98, 'Kookmin Bank International Ltd ',1 UNION ALL 
        SELECT 97, 'Kleinwort Benson Private Bank Ltd ',1 UNION ALL 
        SELECT 96, 'Kingdom Bank Ltd ',1 UNION ALL 
        SELECT 95, 'Kexim Bank (UK) Ltd ',1 UNION ALL 
        SELECT 94, 'Kaupthing Singer & Friedlander Limited ',1 UNION ALL 
        SELECT 93, 'Julian Hodge Bank Ltd ',1 UNION ALL 
        SELECT 92, 'Jordan International Bank plc ',1 UNION ALL 
        SELECT 91, 'J P Morgan International Bank Ltd ',1 UNION ALL 
        SELECT 90, 'J P Morgan Europe Ltd ',1 
 
        SET IDENTITY_INSERT TRefBank OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '66D1F81E-7289-41E0-A424-5A1FC493C305', 
         'Initial load (201 total rows, file 1 of 1) for table TRefBank',
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
-- #Rows Exported: 201
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
