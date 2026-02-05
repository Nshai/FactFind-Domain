 
-----------------------------------------------------------------------------
-- Table: CRM.TRefNationality
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'B2932D05-1AAF-41CF-A301-9015D6D3063B'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefNationality ON; 
 
        INSERT INTO TRefNationality([RefNationalityId], [ConcurrencyId], [Name], [IsArchived])
        SELECT 1,1, 'Afghan',0 UNION ALL 
        SELECT 2,1, 'Albanian',0 UNION ALL 
        SELECT 3,1, 'Algerian',0 UNION ALL 
        SELECT 4,1, 'American',0 UNION ALL 
        SELECT 5,1, 'Andorran',0 UNION ALL 
        SELECT 6,1, 'Angolan',0 UNION ALL 
        SELECT 7,1, 'Antiguans',0 UNION ALL 
        SELECT 8,1, 'Argentinean',0 UNION ALL 
        SELECT 9,1, 'Armenian',0 UNION ALL 
        SELECT 10,1, 'Australian',0 UNION ALL 
        SELECT 11,1, 'Austrian',0 UNION ALL 
        SELECT 12,1, 'Azerbaijani',0 UNION ALL 
        SELECT 13,1, 'Bahamian',0 UNION ALL 
        SELECT 14,1, 'Bahraini',0 UNION ALL 
        SELECT 15,1, 'Bangladeshi',0 UNION ALL 
        SELECT 16,1, 'Barbadian',0 UNION ALL 
        SELECT 17,1, 'Barbudans',0 UNION ALL 
        SELECT 18,1, 'Batswana',0 UNION ALL 
        SELECT 19,1, 'Belarusian',0 UNION ALL 
        SELECT 20,1, 'Belgian',0 UNION ALL 
        SELECT 21,1, 'Belizean',0 UNION ALL 
        SELECT 22,1, 'Beninese',0 UNION ALL 
        SELECT 23,1, 'Bhutanese',0 UNION ALL 
        SELECT 24,1, 'Bolivian',0 UNION ALL 
        SELECT 25,1, 'Bosnian',0 UNION ALL 
        SELECT 26,1, 'Brazilian',0 UNION ALL 
        SELECT 27,1, 'British',0 UNION ALL 
        SELECT 28,1, 'Bruneian',0 UNION ALL 
        SELECT 29,1, 'Bulgarian',0 UNION ALL 
        SELECT 30,1, 'Burkinabe',0 UNION ALL 
        SELECT 31,1, 'Burmese',0 UNION ALL 
        SELECT 32,1, 'Burundian',0 UNION ALL 
        SELECT 33,1, 'Cambodian',0 UNION ALL 
        SELECT 34,1, 'Cameroonian',0 UNION ALL 
        SELECT 35,1, 'Canadian',0 UNION ALL 
        SELECT 36,1, 'Cape Verdean',0 UNION ALL 
        SELECT 37,1, 'Central African',0 UNION ALL 
        SELECT 38,1, 'Chadian',0 UNION ALL 
        SELECT 39,1, 'Chilean',0 UNION ALL 
        SELECT 40,1, 'Chinese',0 UNION ALL 
        SELECT 41,1, 'Colombian',0 UNION ALL 
        SELECT 42,1, 'Comoran',0 UNION ALL 
        SELECT 43,1, 'Congolese',0 UNION ALL 
        SELECT 44,1, 'Costa Rican',0 UNION ALL 
        SELECT 45,1, 'Croatian',0 UNION ALL 
        SELECT 46,1, 'Cuban',0 UNION ALL 
        SELECT 47,1, 'Cypriot',0 UNION ALL 
        SELECT 48,1, 'Czech',0 UNION ALL 
        SELECT 49,1, 'Danish',0 UNION ALL 
        SELECT 50,1, 'Djibouti',0 UNION ALL 
        SELECT 51,1, 'Dominican',0 UNION ALL 
        SELECT 52,1, 'Dutch',0 UNION ALL 
        SELECT 53,1, 'East Timorese',0 UNION ALL 
        SELECT 54,1, 'Ecuadorean',0 UNION ALL 
        SELECT 55,1, 'Egyptian',0 UNION ALL 
        SELECT 56,1, 'Emirian',0 UNION ALL 
        SELECT 57,1, 'English',0 UNION ALL 
        SELECT 58,1, 'Equatorial Guinean',0 UNION ALL 
        SELECT 59,1, 'Eritrean',0 UNION ALL 
        SELECT 60,1, 'Estonian',0 UNION ALL 
        SELECT 61,1, 'Ethiopian',0 UNION ALL 
        SELECT 62,1, 'Fijian',0 UNION ALL 
        SELECT 63,1, 'Filipino',0 UNION ALL 
        SELECT 64,1, 'Finnish',0 UNION ALL 
        SELECT 65,1, 'French',0 UNION ALL 
        SELECT 66,1, 'Gabonese',0 UNION ALL 
        SELECT 67,1, 'Gambian',0 UNION ALL 
        SELECT 68,1, 'Georgian',0 UNION ALL 
        SELECT 69,1, 'German',0 UNION ALL 
        SELECT 70,1, 'Ghanaian',0 UNION ALL 
        SELECT 71,1, 'Greek',0 UNION ALL 
        SELECT 72,1, 'Grenadian',0 UNION ALL 
        SELECT 73,1, 'Guatemalan',0 UNION ALL 
        SELECT 74,1, 'Guinea-Bissauan',0 UNION ALL 
        SELECT 75,1, 'Guinean',0 UNION ALL 
        SELECT 76,1, 'Guyanese',0 UNION ALL 
        SELECT 77,1, 'Haitian',0 UNION ALL 
        SELECT 78,1, 'Herzegovinian',0 UNION ALL 
        SELECT 79,1, 'Honduran',0 UNION ALL 
        SELECT 80,1, 'Hungarian',0 UNION ALL 
        SELECT 81,1, 'I-Kiribati',0 UNION ALL 
        SELECT 82,1, 'Icelander',0 UNION ALL 
        SELECT 83,1, 'Indian',0 UNION ALL 
        SELECT 84,1, 'Indonesian',0 UNION ALL 
        SELECT 85,1, 'Iranian',0 UNION ALL 
        SELECT 86,1, 'Iraqi',0 UNION ALL 
        SELECT 87,1, 'Irish',0 UNION ALL 
        SELECT 88,1, 'Israeli',0 UNION ALL 
        SELECT 89,1, 'Italian',0 UNION ALL 
        SELECT 90,1, 'Ivorian',0 UNION ALL 
        SELECT 91,1, 'Jamaican',0 UNION ALL 
        SELECT 92,1, 'Japanese',0 UNION ALL 
        SELECT 93,1, 'Jordanian',0 UNION ALL 
        SELECT 94,1, 'Kazakhstani',0 UNION ALL 
        SELECT 95,1, 'Kenyan',0 UNION ALL 
        SELECT 96,1, 'Kittian and Nevisian',0 UNION ALL 
        SELECT 97,1, 'Kuwaiti',0 UNION ALL 
        SELECT 98,1, 'Kyrgyz',0 UNION ALL 
        SELECT 99,1, 'Laotian',0 UNION ALL 
        SELECT 100,1, 'Latvian',0 UNION ALL 
        SELECT 101,1, 'Lebanese',0 UNION ALL 
        SELECT 102,1, 'Liberian',0 UNION ALL 
        SELECT 103,1, 'Libyan',0 UNION ALL 
        SELECT 104,1, 'Liechtensteiner',0 UNION ALL 
        SELECT 105,1, 'Lithuanian',0 UNION ALL 
        SELECT 106,1, 'Luxembourger',0 UNION ALL 
        SELECT 107,1, 'Macedonian',0 UNION ALL 
        SELECT 108,1, 'Malagasy',0 UNION ALL 
        SELECT 109,1, 'Malawian',0 UNION ALL 
        SELECT 110,1, 'Malaysian',0 UNION ALL 
        SELECT 111,1, 'Maldivan',0 UNION ALL 
        SELECT 112,1, 'Malian',0 UNION ALL 
        SELECT 113,1, 'Maltese',0 UNION ALL 
        SELECT 114,1, 'Marshallese',0 UNION ALL 
        SELECT 115,1, 'Mauritanian',0 UNION ALL 
        SELECT 116,1, 'Mauritian',0 UNION ALL 
        SELECT 117,1, 'Mexican',0 UNION ALL 
        SELECT 118,1, 'Micronesian',0 UNION ALL 
        SELECT 119,1, 'Moldovan',0 UNION ALL 
        SELECT 120,1, 'Monacan',0 UNION ALL 
        SELECT 121,1, 'Mongolian',0 UNION ALL 
        SELECT 122,1, 'Moroccan',0 UNION ALL 
        SELECT 123,1, 'Mosotho',0 UNION ALL 
        SELECT 124,1, 'Motswana',0 UNION ALL 
        SELECT 125,1, 'Mozambican',0 UNION ALL 
        SELECT 126,1, 'Namibian',0 UNION ALL 
        SELECT 127,1, 'Nauruan',0 UNION ALL 
        SELECT 128,1, 'Nepalese',0 UNION ALL 
        SELECT 129,1, 'New Zealander',0 UNION ALL 
        SELECT 130,1, 'Nicaraguan',0 UNION ALL 
        SELECT 131,1, 'Nigerian',0 UNION ALL 
        SELECT 132,1, 'Nigerien',0 UNION ALL 
        SELECT 133,1, 'North Korean',0 UNION ALL 
        SELECT 134,1, 'Northern Irish',0 UNION ALL 
        SELECT 135,1, 'Norwegian',0 UNION ALL 
        SELECT 136,1, 'Omani',0 UNION ALL 
        SELECT 137,1, 'Pakistani',0 UNION ALL 
        SELECT 138,1, 'Palauan',0 UNION ALL 
        SELECT 139,1, 'Panamanian',0 UNION ALL 
        SELECT 140,1, 'Papua New Guinean',0 UNION ALL 
        SELECT 141,1, 'Paraguayan',0 UNION ALL 
        SELECT 142,1, 'Peruvian',0 UNION ALL 
        SELECT 143,1, 'Polish',0 UNION ALL 
        SELECT 144,1, 'Portuguese',0 UNION ALL 
        SELECT 145,1, 'Qatari',0 UNION ALL 
        SELECT 146,1, 'Romanian',0 UNION ALL 
        SELECT 147,1, 'Russian',0 UNION ALL 
        SELECT 148,1, 'Rwandan',0 UNION ALL 
        SELECT 149,1, 'Saint Lucian',0 UNION ALL 
        SELECT 150,1, 'Salvadoran',0 UNION ALL 
        SELECT 151,1, 'Samoan',0 UNION ALL 
        SELECT 152,1, 'San Marinese',0 UNION ALL 
        SELECT 153,1, 'Sao Tomean',0 UNION ALL 
        SELECT 154,1, 'Saudi',0 UNION ALL 
        SELECT 155,1, 'Scottish',0 UNION ALL 
        SELECT 156,1, 'Senegalese',0 UNION ALL 
        SELECT 157,1, 'Serbian',0 UNION ALL 
        SELECT 158,1, 'Seychellois',0 UNION ALL 
        SELECT 159,1, 'Sierra Leonean',0 UNION ALL 
        SELECT 160,1, 'Singaporean',0 UNION ALL 
        SELECT 161,1, 'Slovakian',0 UNION ALL 
        SELECT 162,1, 'Slovenian',0 UNION ALL 
        SELECT 163,1, 'Solomon Islander',0 UNION ALL 
        SELECT 164,1, 'Somali',0 UNION ALL 
        SELECT 165,1, 'South African',0 UNION ALL 
        SELECT 166,1, 'South Korean',0 UNION ALL 
        SELECT 167,1, 'Spanish',0 UNION ALL 
        SELECT 168,1, 'Sri Lankan',0 UNION ALL 
        SELECT 169,1, 'Sudanese',0 UNION ALL 
        SELECT 170,1, 'Surinamer',0 UNION ALL 
        SELECT 171,1, 'Swazi',0 UNION ALL 
        SELECT 172,1, 'Swedish',0 UNION ALL 
        SELECT 173,1, 'Swiss',0 UNION ALL 
        SELECT 174,1, 'Syrian',0 UNION ALL 
        SELECT 175,1, 'Taiwanese',0 UNION ALL 
        SELECT 176,1, 'Tajik',0 UNION ALL 
        SELECT 177,1, 'Tanzanian',0 UNION ALL 
        SELECT 178,1, 'Thai',0 UNION ALL 
        SELECT 179,1, 'Togolese',0 UNION ALL 
        SELECT 180,1, 'Tongan',0 UNION ALL 
        SELECT 181,1, 'Trinidadian',0 UNION ALL 
        SELECT 182,1, 'Tobagonian',0 UNION ALL 
        SELECT 183,1, 'Tunisian',0 UNION ALL 
        SELECT 184,1, 'Turkish',0 UNION ALL 
        SELECT 185,1, 'Tuvaluan',0 UNION ALL 
        SELECT 186,1, 'Ugandan',0 UNION ALL 
        SELECT 187,1, 'Ukrainian',0 UNION ALL 
        SELECT 188,1, 'Uruguayan',0 UNION ALL 
        SELECT 189,1, 'Uzbekistani',0 UNION ALL 
        SELECT 190,1, 'Venezuelan',0 UNION ALL 
        SELECT 191,1, 'Vietnamese',0 UNION ALL 
        SELECT 192,1, 'Welsh',0 UNION ALL 
        SELECT 193,1, 'Yemenite',0 UNION ALL 
        SELECT 194,1, 'Zambian',0 UNION ALL 
        SELECT 195,1, 'Zimbabwean',0 UNION ALL 
        SELECT 196,1, 'Manx',0 
 
        SET IDENTITY_INSERT TRefNationality OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'B2932D05-1AAF-41CF-A301-9015D6D3063B', 
         'Initial load (196 total rows, file 1 of 1) for table TRefNationality',
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
-- #Rows Exported: 196
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
