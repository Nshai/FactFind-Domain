 
-----------------------------------------------------------------------------
-- Table: CRM.TRefCountry
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '8F40F200-CA4D-4932-ADB2-71171995FBE6'
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
        SELECT 241, 'Serbia, Republic of',0,NULL,1, 'RS' UNION ALL 
        SELECT 240, 'Scotland',1,NULL,1, 'GB-SCT' UNION ALL 
        SELECT 193, 'Slovakia',0,NULL,1, 'SK' UNION ALL 
        SELECT 192, 'Singapore',0,NULL,1, 'SG' UNION ALL 
        SELECT 191, 'Sierra Leone',0,NULL,1, 'SL' UNION ALL 
        SELECT 190, 'Seychelles',0,NULL,1, 'SC' UNION ALL 
        SELECT 189, 'Senegal',0,NULL,1, 'SN' UNION ALL 
        SELECT 188, 'Saudi Arabia',0,NULL,1, 'SA' UNION ALL 
        SELECT 187, 'Sao Tome and Principe',0,NULL,1, 'ST' UNION ALL 
        SELECT 186, 'San Marino',0,NULL,1, 'SM' UNION ALL 
        SELECT 185, 'Samoa',0,NULL,1, 'WS' UNION ALL 
        SELECT 184, 'St Vincent and Grenadines',0,NULL,1, 'VC' UNION ALL 
        SELECT 183, 'Saint Pierre and Miquelon',0,NULL,1, 'PM' UNION ALL 
        SELECT 182, 'Saint Lucia',0,NULL,1, 'LC' UNION ALL 
        SELECT 181, 'Saint Kitts and Nevis',0,NULL,1, 'KN' UNION ALL 
        SELECT 180, 'Saint Helena',0,NULL,1, 'SH' UNION ALL 
        SELECT 179, 'Rwanda',0,NULL,1, 'RW' UNION ALL 
        SELECT 178, 'Russian Federation',0,NULL,1, 'RU' UNION ALL 
        SELECT 177, 'Romania',0,NULL,1, 'RO' UNION ALL 
        SELECT 176, 'Reunion',0,NULL,1, 'RE' UNION ALL 
        SELECT 175, 'Qatar',0,NULL,1, 'QA' UNION ALL 
        SELECT 174, 'Puerto Rico',0,NULL,1, 'PR' UNION ALL 
        SELECT 173, 'Portugal',0,NULL,1, 'PT' UNION ALL 
        SELECT 172, 'Poland',0,NULL,1, 'PL' UNION ALL 
        SELECT 171, 'Pitcairn',0,NULL,1, 'PN' UNION ALL 
        SELECT 170, 'Philippines',0,NULL,1, 'PH' UNION ALL 
        SELECT 169, 'Peru',0,NULL,1, 'PE' UNION ALL 
        SELECT 168, 'Paraguay',0,NULL,1, 'PY' UNION ALL 
        SELECT 167, 'Papua New Guinea',0,NULL,1, 'PG' UNION ALL 
        SELECT 166, 'Panama',0,NULL,1, 'PA' UNION ALL 
        SELECT 165, 'Palau',0,NULL,1, 'PW' UNION ALL 
        SELECT 164, 'Pakistan',0,NULL,1, 'PK' UNION ALL 
        SELECT 163, 'Oman',0,NULL,1, 'OM' UNION ALL 
        SELECT 162, 'Norway',0,NULL,1, 'NO' UNION ALL 
        SELECT 161, 'Northern Mariana Islands',0,NULL,1, 'MP' UNION ALL 
        SELECT 160, 'Norfolk Island',0,NULL,1, 'NF' UNION ALL 
        SELECT 159, 'Niue',0,NULL,1, 'NU' UNION ALL 
        SELECT 158, 'Nigeria',0,NULL,1, 'NG' UNION ALL 
        SELECT 157, 'Niger',0,NULL,1, 'NE' UNION ALL 
        SELECT 156, 'Nicaragua',0,NULL,1, 'NI' UNION ALL 
        SELECT 155, 'New Zealand',0,NULL,1, 'NZ' UNION ALL 
        SELECT 154, 'New Caledonia',0,NULL,1, 'NC' UNION ALL 
        SELECT 153, 'Netherlands Antilles',1,NULL,2, 'AN' UNION ALL 
        SELECT 152, 'Netherlands',0,NULL,1, 'NL' UNION ALL 
        SELECT 250, 'Congo, the Democratic Republic of the',0,NULL,1, 'CD' UNION ALL 
        SELECT 251, 'Curaçao',0,NULL,1, 'CW' UNION ALL 
        SELECT 252, 'Guernsey',0,NULL,1, 'GG' UNION ALL 
        SELECT 253, 'Isle of Man',0,NULL,1, 'IM' UNION ALL 
        SELECT 254, 'Jersey',0,NULL,1, 'JE' UNION ALL 
        SELECT 255, 'Palestine',0,NULL,1, 'PS' UNION ALL 
        SELECT 256, 'Saint Martin (French Part)',0,NULL,1, 'MF' UNION ALL 
        SELECT 257, 'Sint Maarten (Dutch Part)',0,NULL,1, 'SX' UNION ALL 
        SELECT 258, 'Saint Barthelemy',0,NULL,1, 'BL' UNION ALL 
        SELECT 259, 'South Sudan',0,NULL,1, 'SS' UNION ALL 
        SELECT 260, 'Bonaire, Sint Eustatius and Saba',0,NULL,1, 'BQ' UNION ALL 
        SELECT 261, 'Åland Islands',0,NULL,1, 'AX' UNION ALL 
        SELECT 244, 'Montenegro',0,NULL,1, 'ME' UNION ALL 
        SELECT 243, 'British Isles',1,NULL,1, NULL UNION ALL 
        SELECT 242, 'The Channel Islands',1,NULL,1, 'GB-CHL' UNION ALL 
        SELECT 239, 'Zimbabwe',0,NULL,1, 'ZW' UNION ALL 
        SELECT 238, 'Zambia',0,NULL,1, 'ZM' UNION ALL 
        SELECT 237, 'Zaire',1,NULL,1, 'ZR' UNION ALL 
        SELECT 236, 'Yugoslavia',1,NULL,1, 'YU' UNION ALL 
        SELECT 235, 'Yemen',0,NULL,1, 'YE' UNION ALL 
        SELECT 234, 'Western Sahara',0,NULL,1, 'EH' UNION ALL 
        SELECT 233, 'Wallis And Futuna Islands',0,NULL,1, 'WF' UNION ALL 
        SELECT 232, 'Virgin Islands (U.S.)',0,NULL,1, 'VI' UNION ALL 
        SELECT 231, 'Virgin Islands (British)',0,NULL,1, 'VG' UNION ALL 
        SELECT 230, 'Vietnam',0,NULL,1, 'VN' UNION ALL 
        SELECT 229, 'Venezuela',0,NULL,1, 'VE' UNION ALL 
        SELECT 228, 'Vatican City State',0,NULL,1, 'VA' UNION ALL 
        SELECT 227, 'Vanuatu',0,NULL,1, 'VU' UNION ALL 
        SELECT 226, 'Uzbekistan',0,NULL,1, 'UZ' UNION ALL 
        SELECT 225, 'Uruguay',0,NULL,1, 'UY' UNION ALL 
        SELECT 224, 'US Minor Outlying Islands',0,NULL,1, 'UM' UNION ALL 
        SELECT 223, 'United Arab Emirates',0,NULL,1, 'AE' UNION ALL 
        SELECT 222, 'Ukraine',0,NULL,1, 'UA' UNION ALL 
        SELECT 221, 'Uganda',0,NULL,1, 'UG' UNION ALL 
        SELECT 220, 'Tuvalu',0,NULL,1, 'TV' UNION ALL 
        SELECT 219, 'Turks and Caicos Islands',0,NULL,1, 'TC' UNION ALL 
        SELECT 218, 'Turkmenistan',0,NULL,1, 'TM' UNION ALL 
        SELECT 217, 'Turkey',0,NULL,1, 'TR' UNION ALL 
        SELECT 216, 'Tunisia',0,NULL,1, 'TN' UNION ALL 
        SELECT 215, 'Trinidad and Tobago',0,NULL,1, 'TT' UNION ALL 
        SELECT 214, 'Tonga',0,NULL,1, 'TO' UNION ALL 
        SELECT 213, 'Tokelau',0,NULL,1, 'TK' UNION ALL 
        SELECT 212, 'Togo',0,NULL,1, 'TG' UNION ALL 
        SELECT 211, 'Thailand',0,NULL,1, 'TH' UNION ALL 
        SELECT 210, 'Tanzania',0,NULL,1, 'TZ' UNION ALL 
        SELECT 209, 'Tajikistan',0,NULL,1, 'TJ' UNION ALL 
        SELECT 208, 'Taiwan',0,NULL,1, 'TW' UNION ALL 
        SELECT 207, 'Syrian Arab Republic',0,NULL,1, 'SY' UNION ALL 
        SELECT 206, 'Switzerland',0,NULL,1, 'CH' UNION ALL 
        SELECT 205, 'Sweden',0,NULL,1, 'SE' UNION ALL 
        SELECT 204, 'Swaziland',0,NULL,1, 'SZ' UNION ALL 
        SELECT 203, 'Svalbard and Jan Mayen',0,NULL,1, 'SJ' UNION ALL 
        SELECT 202, 'Suriname',0,NULL,1, 'SR' UNION ALL 
        SELECT 201, 'Sudan',0,NULL,1, 'SD' UNION ALL 
        SELECT 200, 'Sri Lanka',0,NULL,1, 'LK' UNION ALL 
        SELECT 199, 'Spain',0,NULL,1, 'ES' UNION ALL 
        SELECT 198, 'S. Georgia / S''wich Island',0,NULL,1, 'GS' UNION ALL 
        SELECT 197, 'South Africa',0,NULL,1, 'ZA' UNION ALL 
        SELECT 196, 'Somalia',0,NULL,1, 'SO' UNION ALL 
        SELECT 195, 'Solomon Islands',0,NULL,1, 'SB' UNION ALL 
        SELECT 194, 'Slovenia',0,NULL,1, 'SI' UNION ALL 
        SELECT 51, 'Congo',0,NULL,1, 'CG' UNION ALL 
        SELECT 50, 'Comoros',0,NULL,1, 'KM' UNION ALL 
        SELECT 49, 'Colombia',0,NULL,1, 'CO' UNION ALL 
        SELECT 48, 'Cocos Islands',0,NULL,1, 'CC' UNION ALL 
        SELECT 47, 'Christmas Island',0,NULL,1, 'CX' UNION ALL 
        SELECT 46, 'Peoples Republic of China',0,NULL,1, 'CN' UNION ALL 
        SELECT 45, 'Chile',0,NULL,1, 'CL' UNION ALL 
        SELECT 44, 'Chad',0,NULL,1, 'TD' UNION ALL 
        SELECT 43, 'Central African Republic',0,NULL,1, 'CF' UNION ALL 
        SELECT 42, 'Cayman Islands',0,NULL,1, 'KY' UNION ALL 
        SELECT 41, 'Cape Verde',0,NULL,1, 'CV' UNION ALL 
        SELECT 40, 'Canada',0,NULL,1, 'CA' UNION ALL 
        SELECT 39, 'Cameroon',0,NULL,1, 'CM' UNION ALL 
        SELECT 38, 'Cambodia',0,NULL,1, 'KH' UNION ALL 
        SELECT 37, 'Burundi',0,NULL,1, 'BI' UNION ALL 
        SELECT 36, 'Burkina Faso',0,NULL,1, 'BF' UNION ALL 
        SELECT 35, 'Bulgaria',0,NULL,1, 'BG' UNION ALL 
        SELECT 34, 'Brunei Darussalam',0,NULL,1, 'BN' UNION ALL 
        SELECT 33, 'British Indian Ocean Terr.',0,NULL,1, 'IO' UNION ALL 
        SELECT 32, 'Brazil',0,NULL,1, 'BR' UNION ALL 
        SELECT 31, 'Bouvet Island',0,NULL,1, 'BV' UNION ALL 
        SELECT 30, 'Botswana',0,NULL,1, 'BW' UNION ALL 
        SELECT 29, 'Bosnia and Herzegovina',0,NULL,1, 'BA' UNION ALL 
        SELECT 28, 'Bolivia',0,NULL,1, 'BO' UNION ALL 
        SELECT 27, 'Bhutan',0,NULL,1, 'BT' UNION ALL 
        SELECT 26, 'Bermuda',0,NULL,1, 'BM' UNION ALL 
        SELECT 25, 'Benin',0,NULL,1, 'BJ' UNION ALL 
        SELECT 24, 'Belize',0,NULL,1, 'BZ' UNION ALL 
        SELECT 23, 'Belgium',0,NULL,1, 'BE' UNION ALL 
        SELECT 22, 'Belarus',0,NULL,1, 'BY' UNION ALL 
        SELECT 21, 'Barbados',0,NULL,1, 'BB' UNION ALL 
        SELECT 20, 'Bangladesh',0,NULL,1, 'BD' UNION ALL 
        SELECT 19, 'Bahrain',0,NULL,1, 'BH' UNION ALL 
        SELECT 18, 'Bahamas',0,NULL,1, 'BS' UNION ALL 
        SELECT 17, 'Azerbaijan',0,NULL,1, 'AZ' UNION ALL 
        SELECT 16, 'Austria',0,NULL,1, 'AT' UNION ALL 
        SELECT 15, 'Australia',0,NULL,1, 'AU' UNION ALL 
        SELECT 14, 'Aruba',0,NULL,1, 'AW' UNION ALL 
        SELECT 13, 'Armenia',0,NULL,1, 'AM' UNION ALL 
        SELECT 12, 'Argentina',0,NULL,1, 'AR' UNION ALL 
        SELECT 11, 'Antigua and Barbuda',0,NULL,1, 'AG' UNION ALL 
        SELECT 10, 'Antarctica',0,NULL,1, 'AQ' UNION ALL 
        SELECT 9, 'Anguilla',0,NULL,1, 'AI' UNION ALL 
        SELECT 8, 'Angola',0,NULL,1, 'AO' UNION ALL 
        SELECT 7, 'Andorra',0,NULL,1, 'AD' UNION ALL 
        SELECT 6, 'American Samoa',0,NULL,1, 'AS' UNION ALL 
        SELECT 5, 'Algeria',0,NULL,1, 'DZ' UNION ALL 
        SELECT 4, 'Albania',0,NULL,1, 'AL' UNION ALL 
        SELECT 3, 'Afghanistan',0,NULL,1, 'AF' UNION ALL 
        SELECT 2, 'United States of America',0,NULL,1, 'US' UNION ALL 
        SELECT 1, 'United Kingdom',0,NULL,1, 'GB' UNION ALL 
        SELECT 151, 'Nepal',0,NULL,1, 'NP' UNION ALL 
        SELECT 150, 'Nauru',0,NULL,1, 'NR' UNION ALL 
        SELECT 149, 'Namibia',0,NULL,1, 'NA' UNION ALL 
        SELECT 148, 'Myanmar',0,NULL,1, 'MM' UNION ALL 
        SELECT 147, 'Mozambique',0,NULL,1, 'MZ' UNION ALL 
        SELECT 146, 'Morocco',0,NULL,1, 'MA' UNION ALL 
        SELECT 145, 'Montserrat',0,NULL,1, 'MS' UNION ALL 
        SELECT 144, 'Mongolia',0,NULL,1, 'MN' UNION ALL 
        SELECT 143, 'Monaco',0,NULL,1, 'MC' UNION ALL 
        SELECT 142, 'Moldova',0,NULL,1, 'MD' UNION ALL 
        SELECT 141, 'Micronesia',0,NULL,1, 'FM' UNION ALL 
        SELECT 140, 'Mexico',0,NULL,1, 'MX' UNION ALL 
        SELECT 139, 'Mayotte',0,NULL,1, 'YT' UNION ALL 
        SELECT 138, 'Mauritius',0,NULL,1, 'MU' UNION ALL 
        SELECT 137, 'Mauritania',0,NULL,1, 'MR' UNION ALL 
        SELECT 136, 'Martinique',0,NULL,1, 'MQ' UNION ALL 
        SELECT 135, 'Marshall Islands',0,NULL,1, 'MH' UNION ALL 
        SELECT 134, 'Malta',0,NULL,1, 'MT' UNION ALL 
        SELECT 133, 'Mali',0,NULL,1, 'ML' UNION ALL 
        SELECT 132, 'Maldives',0,NULL,1, 'MV' UNION ALL 
        SELECT 131, 'Malaysia',0,NULL,1, 'MY' UNION ALL 
        SELECT 130, 'Malawi',0,NULL,1, 'MW' UNION ALL 
        SELECT 129, 'Madagascar',0,NULL,1, 'MG' UNION ALL 
        SELECT 128, 'Macau',0,NULL,1, 'MO' UNION ALL 
        SELECT 127, 'Luxembourg',0,NULL,1, 'LU' UNION ALL 
        SELECT 126, 'Lithuania',0,NULL,1, 'LT' UNION ALL 
        SELECT 125, 'Liechtenstein',0,NULL,1, 'LI' UNION ALL 
        SELECT 124, 'Libyan Arab Jamahiriya',0,NULL,1, 'LY' UNION ALL 
        SELECT 123, 'Liberia',0,NULL,1, 'LR' UNION ALL 
        SELECT 122, 'Lesotho',0,NULL,1, 'LS' UNION ALL 
        SELECT 121, 'Lebanon',0,NULL,1, 'LB' UNION ALL 
        SELECT 120, 'Latvia',0,NULL,1, 'LV' UNION ALL 
        SELECT 119, 'Lao',0,NULL,1, 'LA' UNION ALL 
        SELECT 118, 'Kyrgyzstan',0,NULL,1, 'KG' UNION ALL 
        SELECT 117, 'Kuwait',0,NULL,1, 'KW' UNION ALL 
        SELECT 116, 'Korea, Republic of',0,NULL,1, 'KR' UNION ALL 
        SELECT 115, 'Korea, DPR',0,NULL,1, 'KP' UNION ALL 
        SELECT 114, 'Kiribati',0,NULL,1, 'KI' UNION ALL 
        SELECT 113, 'Kenya',0,NULL,1, 'KE' UNION ALL 
        SELECT 112, 'Kazakhstan',0,NULL,1, 'KZ' UNION ALL 
        SELECT 111, 'Jordan',0,NULL,1, 'JO' UNION ALL 
        SELECT 110, 'Japan',0,NULL,1, 'JP' UNION ALL 
        SELECT 109, 'Jamaica',0,NULL,1, 'JM' UNION ALL 
        SELECT 108, 'Italy',0,NULL,1, 'IT' UNION ALL 
        SELECT 107, 'Israel',0,NULL,1, 'IL' UNION ALL 
        SELECT 106, 'Ireland',0,NULL,1, 'IE' UNION ALL 
        SELECT 105, 'Iraq',0,NULL,1, 'IQ' UNION ALL 
        SELECT 104, 'Iran',0,NULL,1, 'IR' UNION ALL 
        SELECT 103, 'Indonesia',0,NULL,1, 'ID' UNION ALL 
        SELECT 102, 'India',0,NULL,1, 'IN' UNION ALL 
        SELECT 101, 'Iceland',0,NULL,1, 'IS' UNION ALL 
        SELECT 100, 'Hungary',0,NULL,1, 'HU' UNION ALL 
        SELECT 99, 'Hong Kong',0,NULL,1, 'HK' UNION ALL 
        SELECT 98, 'Honduras',0,NULL,1, 'HN' UNION ALL 
        SELECT 97, 'Heard and Mcdonald Islands',0,NULL,1, 'HM' UNION ALL 
        SELECT 96, 'Haiti',0,NULL,1, 'HT' UNION ALL 
        SELECT 95, 'Guyana',0,NULL,1, 'GY' UNION ALL 
        SELECT 94, 'Guinea-Bissau',0,NULL,1, 'GW' UNION ALL 
        SELECT 93, 'Guinea',0,NULL,1, 'GN' UNION ALL 
        SELECT 92, 'Guatemala',0,NULL,1, 'GT' UNION ALL 
        SELECT 91, 'Guam',0,NULL,1, 'GU' UNION ALL 
        SELECT 90, 'Guadeloupe',0,NULL,1, 'GP' UNION ALL 
        SELECT 89, 'Grenada',0,NULL,1, 'GD' UNION ALL 
        SELECT 88, 'Greenland',0,NULL,1, 'GL' UNION ALL 
        SELECT 87, 'Greece',0,NULL,1, 'GR' UNION ALL 
        SELECT 86, 'Gibraltar',0,NULL,1, 'GI' UNION ALL 
        SELECT 85, 'Ghana',0,NULL,1, 'GH' UNION ALL 
        SELECT 84, 'Germany',0,NULL,1, 'DE' UNION ALL 
        SELECT 83, 'Georgia',0,NULL,1, 'GE' UNION ALL 
        SELECT 82, 'Gambia',0,NULL,1, 'GM' UNION ALL 
        SELECT 81, 'Gabon',0,NULL,1, 'GA' UNION ALL 
        SELECT 80, 'North Macedonia',0,NULL,1, 'MK' UNION ALL 
        SELECT 79, 'French Southern Territories',0,NULL,1, 'TF' UNION ALL 
        SELECT 78, 'French Polynesia',0,NULL,1, 'PF' UNION ALL 
        SELECT 77, 'French Guiana',0,NULL,1, 'GF' UNION ALL 
        SELECT 76, 'France, Metropolitan',1,NULL,1, 'FX' UNION ALL 
        SELECT 75, 'France',0,NULL,1, 'FR' UNION ALL 
        SELECT 74, 'Finland',0,NULL,1, 'FI' UNION ALL 
        SELECT 73, 'Fiji',0,NULL,1, 'FJ' UNION ALL 
        SELECT 72, 'Faroe Islands',0,NULL,1, 'FO' UNION ALL 
        SELECT 71, 'Falkland Islands',0,NULL,1, 'FK' UNION ALL 
        SELECT 70, 'Ethiopia',0,NULL,1, 'ET' UNION ALL 
        SELECT 69, 'Estonia',0,NULL,1, 'EE' UNION ALL 
        SELECT 68, 'Eritrea',0,NULL,1, 'ER' UNION ALL 
        SELECT 67, 'Equatorial Guinea',0,NULL,1, 'GQ' UNION ALL 
        SELECT 66, 'El Salvador',0,NULL,1, 'SV' UNION ALL 
        SELECT 65, 'Egypt',0,NULL,1, 'EG' UNION ALL 
        SELECT 64, 'Ecuador',0,NULL,1, 'EC' UNION ALL 
        SELECT 63, 'East Timor',0,NULL,1, 'TL' UNION ALL 
        SELECT 62, 'Dominican Republic',0,NULL,1, 'DO' UNION ALL 
        SELECT 61, 'Dominica',0,NULL,1, 'DM' UNION ALL 
        SELECT 60, 'Djibouti',0,NULL,1, 'DJ' UNION ALL 
        SELECT 59, 'Denmark',0,NULL,1, 'DK' UNION ALL 
        SELECT 58, 'Czech Republic',0,NULL,1, 'CZ' UNION ALL 
        SELECT 57, 'Cyprus',0,NULL,1, 'CY' UNION ALL 
        SELECT 56, 'Cuba',0,NULL,1, 'CU' UNION ALL 
        SELECT 55, 'Croatia',0,NULL,1, 'HR' UNION ALL 
        SELECT 54, 'Cote D''ivoire',0,NULL,1, 'CI' UNION ALL 
        SELECT 53, 'Costa Rica',0,NULL,1, 'CR' UNION ALL 
        SELECT 52, 'Cook Islands',0,NULL,1, 'CK' 
 
        SET IDENTITY_INSERT TRefCountry OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '8F40F200-CA4D-4932-ADB2-71171995FBE6', 
         'Initial load (256 total rows, file 1 of 1) for table TRefCountry',
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
-- #Rows Exported: 256
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
