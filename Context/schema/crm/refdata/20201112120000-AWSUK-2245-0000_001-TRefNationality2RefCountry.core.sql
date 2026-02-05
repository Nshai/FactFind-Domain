 
-----------------------------------------------------------------------------
-- Table: CRM.TRefNationality2RefCountry
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '647A5ED7-FC3F-49BD-BCF1-942BF8A49F85'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefNationality2RefCountry ON; 
 
        INSERT INTO TRefNationality2RefCountry([RefNationality2RefCountryId], [RefNationalityId], [RefCountryId], [Descriptor], [ISOAlpha2Code], [ISOAlpha3Code], [ConcurrencyId])
        SELECT 1,1,3, 'Afghanistan', 'AF', 'AFG',1 UNION ALL 
        SELECT 2,3,5, 'Algeria (El Djazaïr)', 'DZ', 'DZA',1 UNION ALL 
        SELECT 3,2,4, 'Albania', 'AL', 'ALB',1 UNION ALL 
        SELECT 4,5,7, 'Andorra', 'AD', 'AND',1 UNION ALL 
        SELECT 5,6,8, 'Angola', 'AO', 'AGO',1 UNION ALL 
        SELECT 6,7,11, 'Antigua and Barbuda', 'AG', 'ATG',1 UNION ALL 
        SELECT 7,17,11, 'Antigua and Barbuda', 'AG', 'ATG',1 UNION ALL 
        SELECT 8,8,12, 'Argentina', 'AR', 'ARG',1 UNION ALL 
        SELECT 9,9,13, 'Armenia', 'AM', 'ARM',1 UNION ALL 
        SELECT 10,10,15, 'Australia', 'AU', 'AUS',1 UNION ALL 
        SELECT 11,11,16, 'Austria', 'AT', 'AUT',1 UNION ALL 
        SELECT 12,12,17, 'Azerbaijan', 'AZ', 'AZE',1 UNION ALL 
        SELECT 13,13,18, 'Bahamas', 'BS', 'BHS',1 UNION ALL 
        SELECT 14,14,19, 'Bahrain', 'BH', 'BHR',1 UNION ALL 
        SELECT 15,15,20, 'Bangladesh', 'BD', 'BGD',1 UNION ALL 
        SELECT 16,16,21, 'Barbados', 'BB', 'BRB',1 UNION ALL 
        SELECT 17,19,22, 'Belarus', 'BY', 'BLR',1 UNION ALL 
        SELECT 18,20,23, 'Belgium', 'BE', 'BEL',1 UNION ALL 
        SELECT 19,21,24, 'Belize', 'BZ', 'BLZ',1 UNION ALL 
        SELECT 20,22,25, 'Benin', 'BJ', 'BEN',1 UNION ALL 
        SELECT 21,23,27, 'Bhutan', 'BT', 'BTN',1 UNION ALL 
        SELECT 22,24,28, 'Bolivia', 'BO', 'BOL',1 UNION ALL 
        SELECT 23,25,29, 'Bosnia and Herzegovina', 'BA', 'BIH',1 UNION ALL 
        SELECT 24,78,29, 'Bosnia and Herzegovina', 'BA', 'BIH',1 UNION ALL 
        SELECT 25,124,30, 'Botswana', 'BW', 'BWA',1 UNION ALL 
        SELECT 26,18,30, 'Botswana', 'BW', 'BWA',1 UNION ALL 
        SELECT 27,26,32, 'Brazil', 'BR', 'BRA',1 UNION ALL 
        SELECT 28,28,34, 'Brunei Darussalam', 'BN', 'BRN',1 UNION ALL 
        SELECT 29,29,35, 'Bulgaria', 'BG', 'BGR',1 UNION ALL 
        SELECT 30,36,30, 'Burkina Faso', 'BF', 'BFA',1 UNION ALL 
        SELECT 31,32,37, 'Burundi', 'BI', 'BDI',1 UNION ALL 
        SELECT 32,33,39, 'Cambodia', 'KH', 'KHM',1 UNION ALL 
        SELECT 33,34,39, 'Cameroon', 'CM', 'CMR',1 UNION ALL 
        SELECT 34,35,40, 'Canada', 'CA', 'CAN',1 UNION ALL 
        SELECT 35,36,41, 'Cape Verde', 'CV', 'CPV',1 UNION ALL 
        SELECT 36,37,43, 'Central African Republic', 'CF', 'CAF',1 UNION ALL 
        SELECT 37,38,44, 'Chad (T''Chad)', 'TD', 'TCD',1 UNION ALL 
        SELECT 38,39,45, 'Chile', 'CL', 'CHL',1 UNION ALL 
        SELECT 39,40,46, 'China', 'CN', 'CHN',1 UNION ALL 
        SELECT 40,41,49, 'Colombia', 'CO', 'COL',1 UNION ALL 
        SELECT 41,42,50, 'Comoros', 'KM', 'COM',1 UNION ALL 
        SELECT 42,43,51, 'Congo, Republic Of', 'CG', 'COG',1 UNION ALL 
        SELECT 43,44,53, 'Costa Rica', 'CR', 'CRI',1 UNION ALL 
        SELECT 44,90,54, 'CÔte D''Ivoire (Ivory Coast)', 'CI', 'CIV',1 UNION ALL 
        SELECT 45,45,55, 'Croatia (hrvatska)', 'HR', 'HRV',1 UNION ALL 
        SELECT 46,46,56, 'Cuba', 'CU', 'CUB',1 UNION ALL 
        SELECT 47,47,57, 'Cyprus', 'CY', 'CYP',1 UNION ALL 
        SELECT 48,48,58, 'Czech Republic', 'CZ', 'CZE',1 UNION ALL 
        SELECT 49,49,59, 'Denmark', 'DK', 'DNK',1 UNION ALL 
        SELECT 50,50,60, 'Djibouti', 'DJ', 'DJI',1 UNION ALL 
        SELECT 51,51,61, 'Dominica', 'DM', 'DMA',1 UNION ALL 
        SELECT 52,51,62, 'Dominican Republic', 'DO', 'DOM',1 UNION ALL 
        SELECT 53,54,64, 'Ecuador', 'EC', 'ECU',1 UNION ALL 
        SELECT 54,55,65, 'Egypt', 'EG', 'EGY',1 UNION ALL 
        SELECT 55,150,66, 'El Salvador', 'SV', 'SLV',1 UNION ALL 
        SELECT 56,58,67, 'Equatorial Guinea', 'GQ', 'GNQ',1 UNION ALL 
        SELECT 57,59,68, 'Eritrea', 'ER', 'ERI',1 UNION ALL 
        SELECT 58,60,69, 'Estonia', 'EE', 'EST',1 UNION ALL 
        SELECT 59,61,70, 'Ethiopia', 'ET', 'ETH',1 UNION ALL 
        SELECT 60,62,73, 'Fiji', 'FJ', 'FJI',1 UNION ALL 
        SELECT 61,64,74, 'Finland', 'FI', 'FIN',1 UNION ALL 
        SELECT 62,65,75, 'France', 'FR', 'FRA',1 UNION ALL 
        SELECT 63,66,81, 'Gabon', 'GA', 'GAB',1 UNION ALL 
        SELECT 64,67,82, 'Gambia, The', 'GM', 'GMB',1 UNION ALL 
        SELECT 65,68,83, 'Georgia', 'GE', 'GEO',1 UNION ALL 
        SELECT 66,69,84, 'Germany (Deutschland)', 'DE', 'DEU',1 UNION ALL 
        SELECT 67,70,85, 'Ghana', 'GH', 'GHA',1 UNION ALL 
        SELECT 68,71,87, 'Greece', 'GR', 'GRC',1 UNION ALL 
        SELECT 69,72,89, 'Grenada', 'GD', 'GRD',1 UNION ALL 
        SELECT 70,73,92, 'Guatemala', 'GT', 'GTM',1 UNION ALL 
        SELECT 71,75,93, 'Guinea', 'GN', 'GIN',1 UNION ALL 
        SELECT 72,74,94, 'Guinea-bissau', 'GW', 'GNB',1 UNION ALL 
        SELECT 73,76,95, 'Guyana', 'GY', 'GUY',1 UNION ALL 
        SELECT 74,77,96, 'Haiti', 'HT', 'HTI',1 UNION ALL 
        SELECT 75,79,98, 'Honduras', 'HN', 'HND',1 UNION ALL 
        SELECT 76,40,99, 'Hong Kong (Special Administrative Region of China)', 'HK', 'HKG',1 UNION ALL 
        SELECT 77,80,100, 'Hungary', 'HU', 'HUN',1 UNION ALL 
        SELECT 78,82,101, 'Iceland', 'IS', 'ISL',1 UNION ALL 
        SELECT 79,83,102, 'India', 'IN', 'IND',1 UNION ALL 
        SELECT 80,84,103, 'Indonesia', 'ID', 'IDN',1 UNION ALL 
        SELECT 81,85,104, 'Iran (Islamic Republic of Iran)', 'IR', 'IRN',1 UNION ALL 
        SELECT 82,86,105, 'Iraq', 'IQ', 'IRQ',1 UNION ALL 
        SELECT 83,87,106, 'Ireland', 'IE', 'IRL',1 UNION ALL 
        SELECT 84,88,107, 'Israel', 'IL', 'ISR',1 UNION ALL 
        SELECT 85,89,108, 'Italy', 'IT', 'ITA',1 UNION ALL 
        SELECT 86,91,109, 'Jamaica', 'JM', 'JAM',1 UNION ALL 
        SELECT 87,92,110, 'Japan', 'JP', 'JPN',1 UNION ALL 
        SELECT 88,93,111, 'Jordan (Hashemite Kingdom of Jordan)', 'JO', 'JOR',1 UNION ALL 
        SELECT 89,94,112, 'Kazakhstan', 'KZ', 'KAZ',1 UNION ALL 
        SELECT 90,95,113, 'Kenya', 'KE', 'KEN',1 UNION ALL 
        SELECT 91,81,114, 'Kiribati', 'KI', 'KIR',1 UNION ALL 
        SELECT 92,133,115, 'Korea (Democratic Peoples Republic pf [North] Korea)', 'KP', 'PRK',1 UNION ALL 
        SELECT 93,166,116, 'Korea (Republic of [South] Korea)', 'KR', 'KOR',1 UNION ALL 
        SELECT 94,97,117, 'Kuwait', 'KW', 'KWT',1 UNION ALL 
        SELECT 95,98,118, 'Kyrgyzstan', 'KG', 'KGZ',1 UNION ALL 
        SELECT 96,99,119, 'Lao People''s Democratic Republic', 'LA', 'LAO',1 UNION ALL 
        SELECT 97,100,120, 'Latvia', 'LV', 'LVA',1 UNION ALL 
        SELECT 98,101,121, 'Lebanon', 'LB', 'LBN',1 UNION ALL 
        SELECT 99,102,123, 'Liberia', 'LR', 'LBR',1 UNION ALL 
        SELECT 100,103,124, 'Libya (Libyan Arab Jamahirya)', 'LY', 'LBY',1 UNION ALL 
        SELECT 101,104,125, 'Liechtenstein (Fürstentum Liechtenstein)', 'LI', 'LIE',1 UNION ALL 
        SELECT 102,105,126, 'Lithuania', 'LT', 'LTU',1 UNION ALL 
        SELECT 103,106,127, 'Luxembourg', 'LU', 'LUX',1 UNION ALL 
        SELECT 104,40,128, 'Macao (Special Administrative Region of China)', 'MO', 'MAC',1 UNION ALL 
        SELECT 105,108,129, 'Madagascar', 'MG', 'MDG',1 UNION ALL 
        SELECT 106,109,130, 'Malawi', 'MW', 'MWI',1 UNION ALL 
        SELECT 107,110,131, 'Malaysia', 'MY', 'MYS',1 UNION ALL 
        SELECT 108,111,132, 'Maldives', 'MV', 'MDV',1 UNION ALL 
        SELECT 109,112,133, 'Mali', 'ML', 'MLI',1 UNION ALL 
        SELECT 110,113,134, 'Malta', 'MT', 'MLT',1 UNION ALL 
        SELECT 111,114,135, 'Marshall Islands', 'MH', 'MHL',1 UNION ALL 
        SELECT 112,115,137, 'Mauritania', 'MR', 'MRT',1 UNION ALL 
        SELECT 113,116,138, 'Mauritius', 'MU', 'MUS',1 UNION ALL 
        SELECT 114,117,140, 'Mexico', 'MX', 'MEX',1 UNION ALL 
        SELECT 115,118,141, 'Micronesia (Federated States of Micronesia)', 'FM', 'FSM',1 UNION ALL 
        SELECT 116,119,142, 'Moldova', 'MD', 'MDA',1 UNION ALL 
        SELECT 117,120,143, 'Monaco', 'MC', 'MCO',1 UNION ALL 
        SELECT 118,121,144, 'Mongolia', 'MN', 'MNG',1 UNION ALL 
        SELECT 119,122,146, 'Morocco', 'MA', 'MAR',1 UNION ALL 
        SELECT 120,125,147, 'Mozambique (Moçambique)', 'MZ', 'MOZ',1 UNION ALL 
        SELECT 121,31,148, 'Myanmar (formerly Burma)', 'MM', 'MMR',1 UNION ALL 
        SELECT 122,126,149, 'Namibia', 'NA', 'NAM',1 UNION ALL 
        SELECT 123,127,150, 'Nauru', 'NR', 'NRU',1 UNION ALL 
        SELECT 124,128,151, 'Nepal', 'NP', 'NPL',1 UNION ALL 
        SELECT 125,52,152, 'Netherlands', 'NL', 'NLD',1 UNION ALL 
        SELECT 126,129,155, 'New Zealand', 'NZ', 'NZL',1 UNION ALL 
        SELECT 127,132,157, 'Niger', 'NE', 'NER',1 UNION ALL 
        SELECT 128,131,158, 'Nigeria', 'NG', 'NGA',1 UNION ALL 
        SELECT 129,135,162, 'Norway', 'NO', 'NOR',1 UNION ALL 
        SELECT 130,136,163, 'Oman', 'OM', 'OMN',1 UNION ALL 
        SELECT 131,137,164, 'Pakistan', 'PK', 'PAK',1 UNION ALL 
        SELECT 132,138,165, 'Palau', 'PW', 'PLW',1 UNION ALL 
        SELECT 133,139,166, 'Panama', 'PA', 'PAN',1 UNION ALL 
        SELECT 134,140,167, 'Papua New Guinea', 'PG', 'PNG',1 UNION ALL 
        SELECT 135,141,168, 'Paraguay', 'PY', 'PRY',1 UNION ALL 
        SELECT 136,142,169, 'Peru', 'PE', 'PER',1 UNION ALL 
        SELECT 137,63,170, 'Philippines', 'PH', 'PHL',1 UNION ALL 
        SELECT 138,143,172, 'Poland', 'PL', 'POL',1 UNION ALL 
        SELECT 139,144,173, 'Portugal', 'PT', 'PRT',1 UNION ALL 
        SELECT 140,145,175, 'Qatar', 'QA', 'QAT',1 UNION ALL 
        SELECT 141,146,177, 'Romania', 'RO', 'ROU',1 UNION ALL 
        SELECT 142,147,178, 'Russian Federation', 'RU', 'RUS',1 UNION ALL 
        SELECT 143,148,179, 'Rwanda', 'RW', 'RWA',1 UNION ALL 
        SELECT 144,151,185, 'Samoa (formerly Western Samoa)', 'WS', 'WSM',1 UNION ALL 
        SELECT 145,152,186, 'San Marino (Republic of)', 'SM', 'SMR',1 UNION ALL 
        SELECT 146,153,187, 'Sao Tome and Principe', 'ST', 'STP',1 UNION ALL 
        SELECT 147,154,188, 'Saudi Arabia (Kingdom of Saudi Arabia)', 'SA', 'SAU',1 UNION ALL 
        SELECT 148,156,189, 'Senegal', 'SN', 'SEN',1 UNION ALL 
        SELECT 149,157,241, 'Serbia and Montenegro (formerly Yugoslavia)', 'CS', 'SCG',1 UNION ALL 
        SELECT 150,158,190, 'Seychelles', 'SC', 'SYC',1 UNION ALL 
        SELECT 151,159,191, 'Sierra Leone', 'SL', 'SLE',1 UNION ALL 
        SELECT 152,160,192, 'Singapore', 'SG', 'SGP',1 UNION ALL 
        SELECT 153,161,193, 'Slovakia (Slovak Republic)', 'SK', 'SVK',1 UNION ALL 
        SELECT 154,162,194, 'Slovenia', 'SI', 'SVN',1 UNION ALL 
        SELECT 155,163,195, 'Solomon Islands', 'SB', 'SLB',1 UNION ALL 
        SELECT 156,164,196, 'Somalia', 'SO', 'SOM',1 UNION ALL 
        SELECT 157,165,197, 'South Africa (zuid Afrika)', 'ZA', 'ZAF',1 UNION ALL 
        SELECT 158,167,199, 'Spain (españa)', 'ES', 'ESP',1 UNION ALL 
        SELECT 159,168,200, 'Sri Lanka', 'LK', 'LKA',1 UNION ALL 
        SELECT 160,169,201, 'Sudan', 'SD', 'SDN',1 UNION ALL 
        SELECT 161,170,202, 'Suriname', 'SR', 'SUR',1 UNION ALL 
        SELECT 162,171,204, 'Swaziland', 'SZ', 'SWZ',1 UNION ALL 
        SELECT 163,172,205, 'Sweden', 'SE', 'SWE',1 UNION ALL 
        SELECT 164,173,206, 'Switzerland (Confederation of Helvetia)', 'CH', 'CHE',1 UNION ALL 
        SELECT 165,174,207, 'Syrian Arab Republic', 'SY', 'SYR',1 UNION ALL 
        SELECT 166,175,208, 'Taiwan ("Chinese Taipei" for IOC)', 'TW', 'TWN',1 UNION ALL 
        SELECT 167,176,209, 'Tajikistan', 'TJ', 'TJK',1 UNION ALL 
        SELECT 168,177,210, 'Tanzania', 'TZ', 'TZA',1 UNION ALL 
        SELECT 169,178,211, 'Thailand', 'TH', 'THA',1 UNION ALL 
        SELECT 170,53,63, 'Timor-Leste (formerly East Timor)', 'TL', 'TLS',1 UNION ALL 
        SELECT 171,180,212, 'Togo', 'TG', 'TGO',1 UNION ALL 
        SELECT 172,181,215, 'Trinidad and Tobago', 'TT', 'TTO',1 UNION ALL 
        SELECT 173,182,215, 'Trinidad and Tobago', 'TT', 'TTO',1 UNION ALL 
        SELECT 174,183,216, 'Tunisia', 'TN', 'TUN',1 UNION ALL 
        SELECT 175,184,217, 'Turkey', 'TR', 'TUR',1 UNION ALL 
        SELECT 176,185,220, 'Tuvalu', 'TV', 'TUV',1 UNION ALL 
        SELECT 177,186,221, 'Uganda', 'UG', 'UGA',1 UNION ALL 
        SELECT 178,187,222, 'Ukraine', 'UA', 'UKR',1 UNION ALL 
        SELECT 179,56,223, 'United Arab Emirates', 'AE', 'ARE',1 UNION ALL 
        SELECT 180,134,1, 'United Kingdom (Great Britain)', 'GB', 'GBR',1 UNION ALL 
        SELECT 181,192,1, 'United Kingdom (Great Britain)', 'GB', 'GBR',1 UNION ALL 
        SELECT 182,155,1, 'United Kingdom (Great Britain)', 'GB', 'GBR',1 UNION ALL 
        SELECT 183,57,1, 'United Kingdom (Great Britain)', 'GB', 'GBR',1 UNION ALL 
        SELECT 184,27,1, 'United Kingdom (Great Britain)', 'GB', 'GBR',1 UNION ALL 
        SELECT 185,4,2, 'United States', 'US', 'USA',1 UNION ALL 
        SELECT 186,188,225, 'Uruguay', 'UY', 'URY',1 UNION ALL 
        SELECT 187,189,226, 'Uzbekistan', 'UZ', 'UZB',1 UNION ALL 
        SELECT 188,190,229, 'Venezuela', 'VE', 'VEN',1 UNION ALL 
        SELECT 189,191,230, 'Viet Nam', 'VN', 'VNM',1 UNION ALL 
        SELECT 190,193,235, 'Yemen (Arab Republic)', 'YE', 'YEM',1 UNION ALL 
        SELECT 191,194,238, 'Zambia', 'ZM', 'ZMB',1 UNION ALL 
        SELECT 192,195,239, 'Zimbabwe', 'ZW', 'ZWE',1 
 
        SET IDENTITY_INSERT TRefNationality2RefCountry OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '647A5ED7-FC3F-49BD-BCF1-942BF8A49F85', 
         'Initial load (192 total rows, file 1 of 1) for table TRefNationality2RefCountry',
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
-- #Rows Exported: 192
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
