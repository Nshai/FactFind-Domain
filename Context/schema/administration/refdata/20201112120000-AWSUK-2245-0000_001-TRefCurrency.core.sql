 
-----------------------------------------------------------------------------
-- Table: Administration.TRefCurrency
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '73096E35-9EDF-4FF0-8E69-77777C06605C'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefCurrency ON; 
 
        INSERT INTO TRefCurrency([RefCurrencyId], [CurrencyCode], [Description], [Symbol], [ConcurrencyId])
        SELECT 11, 'ADP', 'Andorran Peseta', 'ADP',1 UNION ALL 
        SELECT 12, 'AED', 'UAE Dirham', 'AED',1 UNION ALL 
        SELECT 13, 'AFA', 'Afghani', 'AFA',1 UNION ALL 
        SELECT 14, 'ALL', 'Albanian Lek', 'ALL',1 UNION ALL 
        SELECT 15, 'ANG', 'Antilles Guilder', 'ANG',1 UNION ALL 
        SELECT 16, 'AON', 'New Kwanza', 'AON',1 UNION ALL 
        SELECT 17, 'ARS', 'Argentine Peso', 'ARS',1 UNION ALL 
        SELECT 18, 'AUD', 'Australian Dollar', 'AUD',1 UNION ALL 
        SELECT 19, 'AWG', 'Aruban Guilder', 'AWG',1 UNION ALL 
        SELECT 20, 'BBD', 'Barbados Dollar', 'BBD',1 UNION ALL 
        SELECT 21, 'BDT', 'Taka', 'BDT',1 UNION ALL 
        SELECT 22, 'BGL', 'Lev', 'BGL',1 UNION ALL 
        SELECT 23, 'BHD', 'Bahraini Dinar', 'BHD',1 UNION ALL 
        SELECT 24, 'BIF', 'Burundi Franc', 'BIF',1 UNION ALL 
        SELECT 25, 'BMD', 'Bermudian Dollar', 'BMD',1 UNION ALL 
        SELECT 26, 'BND', 'Brunei Dollar', 'BND',1 UNION ALL 
        SELECT 27, 'BOB', 'Boliviano', 'BOB',1 UNION ALL 
        SELECT 28, 'BRE', 'Cruzeiro', 'BRE',1 UNION ALL 
        SELECT 29, 'BSD', 'Bahamian Dollar', 'BSD',1 UNION ALL 
        SELECT 30, 'BTN', 'Ngultrum', 'BTN',1 UNION ALL 
        SELECT 31, 'BWP', 'Pula', 'BWP',1 UNION ALL 
        SELECT 32, 'BZD', 'Belize Dollar', 'BZD',1 UNION ALL 
        SELECT 33, 'CAD', 'Canadian Dollar', 'CAD',1 UNION ALL 
        SELECT 34, 'CHF', 'Swiss Franc', 'CHF',1 UNION ALL 
        SELECT 35, 'CLF', 'Chilean Peso', 'CLF',1 UNION ALL 
        SELECT 36, 'CNY', 'Yuan Renminbi', 'CNY',1 UNION ALL 
        SELECT 37, 'COP', 'Colombian Peso', 'COP',1 UNION ALL 
        SELECT 38, 'CRC', 'Costa Rican Colon', 'CRC',1 UNION ALL 
        SELECT 39, 'CSK', 'Koruna', 'CSK',1 UNION ALL 
        SELECT 40, 'CUP', 'Cuban Peso', 'CUP',1 UNION ALL 
        SELECT 41, 'CVE', 'Verda Escudo', 'CVE',1 UNION ALL 
        SELECT 42, 'CYP', 'Cyprus Pound', 'CYP',1 UNION ALL 
        SELECT 43, 'DJF', 'Djibouti Franc', 'DJF',1 UNION ALL 
        SELECT 44, 'DKK', 'Danish Krone', 'DKK',1 UNION ALL 
        SELECT 45, 'DOP', 'Dominican Peso', 'DOP',1 UNION ALL 
        SELECT 46, 'DZD', 'Algerian Dinar', 'DZD',1 UNION ALL 
        SELECT 47, 'ECS', 'Sucre', 'ECS',1 UNION ALL 
        SELECT 48, 'EGP', 'Egyptian Found', 'EGP',1 UNION ALL 
        SELECT 49, 'ETB', 'Ethiopian Birr', 'ETB',1 UNION ALL 
        SELECT 50, 'EUR', 'Euro', 'EUR',1 UNION ALL 
        SELECT 51, 'FJD', 'Fiji Dollar', 'FJD',1 UNION ALL 
        SELECT 52, 'FKP', 'Falkland Islands Pound', 'FKP',1 UNION ALL 
        SELECT 53, 'GBP', 'Sterling', '£',1 UNION ALL 
        SELECT 54, 'GHC', 'Cedi', 'GHC',1 UNION ALL 
        SELECT 55, 'GIP', 'Gibraltar Pound', 'GIP',1 UNION ALL 
        SELECT 56, 'GMD', 'Dalasi', 'GMD',1 UNION ALL 
        SELECT 57, 'GNF', 'Guinea Franc', 'GNF',1 UNION ALL 
        SELECT 58, 'GRD', 'Drachma', 'GRD',1 UNION ALL 
        SELECT 59, 'GTQ', 'Quetzal', 'GTQ',1 UNION ALL 
        SELECT 60, 'GWP', 'Guinea-Bissau Peso', 'GWP',1 UNION ALL 
        SELECT 61, 'GYD', 'Guyana Dollar', 'GYD',1 UNION ALL 
        SELECT 62, 'HKD', 'Hong Kong Dollar', 'HKD',1 UNION ALL 
        SELECT 63, 'HNL', 'Lempira', 'HNL',1 UNION ALL 
        SELECT 64, 'HTG', 'Gourde', 'HTG',1 UNION ALL 
        SELECT 65, 'HUF', 'Forint', 'HUF',1 UNION ALL 
        SELECT 66, 'IDR', 'Rupiah', 'IDR',1 UNION ALL 
        SELECT 67, 'ILS', 'Shekel', 'ILS',1 UNION ALL 
        SELECT 68, 'INR', 'Indian Rupee', 'INR',1 UNION ALL 
        SELECT 69, 'IQD', 'Iraqi Dinar', 'IQD',1 UNION ALL 
        SELECT 70, 'IRR', 'Iranian Rial', 'IRR',1 UNION ALL 
        SELECT 71, 'ISK', 'Iceland Krona', 'ISK',1 UNION ALL 
        SELECT 72, 'JMD', 'Jamaican Dollar', 'JMD',1 UNION ALL 
        SELECT 73, 'JOD', 'Jordanian Dinar', 'JOD',1 UNION ALL 
        SELECT 74, 'JPY', 'Yen', 'JPY',1 UNION ALL 
        SELECT 75, 'KES', 'Kenyan Shilling', 'KES',1 UNION ALL 
        SELECT 76, 'KHR', 'Riel', 'KHR',1 UNION ALL 
        SELECT 77, 'KPW', 'North Korean Won', 'KPW',1 UNION ALL 
        SELECT 78, 'KRW', 'South Korean Won', 'KRW',1 UNION ALL 
        SELECT 79, 'KWD', 'Kuwaiti Dinar', 'KWD',1 UNION ALL 
        SELECT 80, 'KYD', 'Cayman Islands Dollar', 'KYD',1 UNION ALL 
        SELECT 81, 'Laos', 'Kip LAK', 'Laos',1 UNION ALL 
        SELECT 82, 'LBP', 'Lebanese Pound', 'LBP',1 UNION ALL 
        SELECT 83, 'LKR', 'Sri Lanka Rupee', 'LKR',1 UNION ALL 
        SELECT 84, 'LRD', 'Liberian Dollar', 'LRD',1 UNION ALL 
        SELECT 85, 'LSL', 'Loti', 'LSL',1 UNION ALL 
        SELECT 86, 'LYD', 'Libyan Dinar', 'LYD',1 UNION ALL 
        SELECT 87, 'MAD', 'Moroccan Dirham', 'MAD',1 UNION ALL 
        SELECT 88, 'MGF', 'Malagasy Franc', 'MGF',1 UNION ALL 
        SELECT 89, 'MMK', 'Kyat', 'MMK',1 UNION ALL 
        SELECT 90, 'MNT', 'Tugrik', 'MNT',1 UNION ALL 
        SELECT 91, 'MOP', 'Pataca', 'MOP',1 UNION ALL 
        SELECT 92, 'MRO', 'Ouguiya', 'MRO',1 UNION ALL 
        SELECT 93, 'MTL', 'Maltese Lira', 'MTL',1 UNION ALL 
        SELECT 94, 'MUR', 'Mauritius Rupee', 'MUR',1 UNION ALL 
        SELECT 95, 'MVR', 'Rufiyaa', 'MVR',1 UNION ALL 
        SELECT 96, 'MWK', 'Kwacha', 'MWK',1 UNION ALL 
        SELECT 97, 'MXP', 'Mexican Peso', 'MXP',1 UNION ALL 
        SELECT 98, 'MYR', 'Malaysian Ringgit', 'MYR',1 UNION ALL 
        SELECT 99, 'MZM', 'Metical', 'MZM',1 UNION ALL 
        SELECT 100, 'NGN', 'Naira', 'NGN',1 UNION ALL 
        SELECT 101, 'NIO', 'Cordoba Oro', 'NIO',1 UNION ALL 
        SELECT 102, 'NOK', 'Norweigan Krone', 'NOK',1 UNION ALL 
        SELECT 103, 'NPR', 'Nepalese Rupee', 'NPR',1 UNION ALL 
        SELECT 104, 'NZD', 'New Zealand Dollar', 'NZD',1 UNION ALL 
        SELECT 105, 'OMR', 'Rial Omani', 'OMR',1 UNION ALL 
        SELECT 106, 'PAB', 'Balboa', 'PAB',1 UNION ALL 
        SELECT 107, 'PEN', 'Pennuevo Sol', 'PEN',1 UNION ALL 
        SELECT 108, 'PGK', 'Kina', 'PGK',1 UNION ALL 
        SELECT 109, 'PHP', 'Philippine Peso', 'PHP',1 UNION ALL 
        SELECT 110, 'PKR', 'Pakistan Rupee', 'PKR',1 UNION ALL 
        SELECT 111, 'PLZ', 'Zloty', 'PLZ',1 UNION ALL 
        SELECT 112, 'PYG', 'Guarani', 'PYG',1 UNION ALL 
        SELECT 113, 'QAR', 'Qatar Rial', 'QAR',1 UNION ALL 
        SELECT 114, 'ROL', 'Leu', 'ROL',1 UNION ALL 
        SELECT 115, 'RWF', 'Rwanda Franc', 'RWF',1 UNION ALL 
        SELECT 116, 'Sao', 'Dobra STD', 'Sao',1 UNION ALL 
        SELECT 117, 'SAR', 'Saudi Riyal', 'SAR',1 UNION ALL 
        SELECT 118, 'SBD', 'Solomon Islands Dollar', 'SBD',1 UNION ALL 
        SELECT 119, 'SCR', 'Seychelles Rupee', 'SCR',1 UNION ALL 
        SELECT 120, 'SDP', 'Sudanese Pound', 'SDP',1 UNION ALL 
        SELECT 121, 'SEK', 'Swedish Krona', 'SEK',1 UNION ALL 
        SELECT 122, 'SGD', 'Singapore Dollar', 'SGD',1 UNION ALL 
        SELECT 123, 'SHP', 'St Helena Pound', 'SHP',1 UNION ALL 
        SELECT 124, 'SLL', 'Leone', 'SLL',1 UNION ALL 
        SELECT 125, 'SOS', 'Somali Shilling', 'SOS',1 UNION ALL 
        SELECT 126, 'SRG', 'Surinam Guilder', 'SRG',1 UNION ALL 
        SELECT 127, 'SUR', 'Rouble', 'SUR',1 UNION ALL 
        SELECT 128, 'SVC', 'El Salvador Colon', 'SVC',1 UNION ALL 
        SELECT 129, 'SYP', 'Syrian Pound', 'SYP',1 UNION ALL 
        SELECT 130, 'SZL', 'Lilangeni', 'SZL',1 UNION ALL 
        SELECT 131, 'THB', 'Baht', 'THB',1 UNION ALL 
        SELECT 132, 'TND', 'Tunisian Dinar', 'TND',1 UNION ALL 
        SELECT 133, 'TOP', 'PaAnga', 'TOP',1 UNION ALL 
        SELECT 134, 'TRL', 'Turkish Lira', 'TRL',1 UNION ALL 
        SELECT 135, 'TTD', 'Trinidad and Tobago Dollar', 'TTD',1 UNION ALL 
        SELECT 136, 'TWD', 'New Taiwan Dollar', 'TWD',1 UNION ALL 
        SELECT 137, 'TZS', 'Tanzanian Shilling', 'TZS',1 UNION ALL 
        SELECT 138, 'UGX', 'Uganda Shilling', 'UGX',1 UNION ALL 
        SELECT 139, 'USD', 'US Dollar', '$',1 UNION ALL 
        SELECT 140, 'UYP', 'Uruguayan Peso', 'UYP',1 UNION ALL 
        SELECT 141, 'VEB', 'Bolivar', 'VEB',1 UNION ALL 
        SELECT 142, 'VND', 'Dong', 'VND',1 UNION ALL 
        SELECT 143, 'VUV', 'Vatu', 'VUV',1 UNION ALL 
        SELECT 144, 'WST', 'Tala', 'WST',1 UNION ALL 
        SELECT 145, 'XAF', 'CFA Franc Beac', 'XAF',1 UNION ALL 
        SELECT 146, 'XCD', 'East Caribbean Dollar', 'XCD',1 UNION ALL 
        SELECT 147, 'XOF', 'Franc Bceao', 'XOF',1 UNION ALL 
        SELECT 148, 'XPF', 'CPF Franc', 'XPF',1 UNION ALL 
        SELECT 149, 'YAR', 'Yemeni Rial', 'YAR',1 UNION ALL 
        SELECT 150, 'YUN', 'Yugoslavian Dinar', 'YUN',1 UNION ALL 
        SELECT 151, 'ZAL', 'South African Financial Rand', 'ZAL',1 UNION ALL 
        SELECT 152, 'ZAR', 'Rand', 'ZAR',1 UNION ALL 
        SELECT 153, 'ZMK', 'Kwacha', 'ZMK',1 UNION ALL 
        SELECT 154, 'ZRZ', 'Zaire', 'ZRZ',1 UNION ALL 
        SELECT 155, 'ZWD', 'Zimbabwe Dollar', 'ZWD',1 
 
        SET IDENTITY_INSERT TRefCurrency OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '73096E35-9EDF-4FF0-8E69-77777C06605C', 
         'Initial load (145 total rows, file 1 of 1) for table TRefCurrency',
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
-- #Rows Exported: 145
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
