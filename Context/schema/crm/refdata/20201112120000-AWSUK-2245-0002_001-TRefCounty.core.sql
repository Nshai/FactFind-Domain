 
-----------------------------------------------------------------------------
-- Table: CRM.TRefCounty
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '05728530-1276-4593-B99F-73790EDD6136'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefCounty ON; 
 
        INSERT INTO TRefCounty([RefCountyId], [CountyName], [RefCountryId], [ArchiveFG], [Extensible], [ConcurrencyId], [CountyCode], [ParentCountyCode])
        SELECT 1, 'Alderney',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 2, 'County Antrim',1,0,NULL,1, 'GB-ANT', 'GB-NIR' UNION ALL 
        SELECT 3, 'County Armagh',1,0,NULL,1, 'GB-ARM', 'GB-NIR' UNION ALL 
        SELECT 4, 'Avon',1,1,NULL,1, 'GB-004', 'GB-ENG' UNION ALL 
        SELECT 5, 'Bedfordshire',1,0,NULL,1, 'GB-CBF', 'GB-ENG' UNION ALL 
        SELECT 6, 'Berkshire',1,0,NULL,1, 'GB-WBK', 'GB-ENG' UNION ALL 
        SELECT 7, 'Borders',1,0,NULL,1, 'GB-SCB', 'GB-SCT' UNION ALL 
        SELECT 8, 'Buckinghamshire',1,0,NULL,1, 'GB-BKM', 'GB-ENG' UNION ALL 
        SELECT 9, 'Cambridgeshire',1,0,NULL,1, 'GB-CAM', 'GB-ENG' UNION ALL 
        SELECT 10, 'Central',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 11, 'Cheshire',1,0,NULL,1, 'GB-CHE', 'GB-ENG' UNION ALL 
        SELECT 12, 'Cleveland',1,0,NULL,1, 'GB-RCC', 'GB-ENG' UNION ALL 
        SELECT 13, 'Clwyd',1,1,NULL,1, 'GB-013', 'GB-WLS' UNION ALL 
        SELECT 14, 'Cornwall',1,0,NULL,1, 'GB-CON', 'GB-ENG' UNION ALL 
        SELECT 15, 'Cumbria',1,0,NULL,1, 'GB-CMA', 'GB-ENG' UNION ALL 
        SELECT 16, 'Derbyshire',1,0,NULL,1, 'GB-DBY', 'GB-ENG' UNION ALL 
        SELECT 17, 'Devon',1,0,NULL,1, 'GB-DEV', 'GB-ENG' UNION ALL 
        SELECT 18, 'Dorset',1,0,NULL,1, 'GB-DOR', 'GB-ENG' UNION ALL 
        SELECT 19, 'County Down',1,0,NULL,1, 'GB-DOW', 'GB-NIR' UNION ALL 
        SELECT 20, 'Dumfries and Galloway',1,0,NULL,1, 'GB-DGY', 'GB-SCT' UNION ALL 
        SELECT 21, 'County Durham',1,0,NULL,1, 'GB-DUR', 'GB-ENG' UNION ALL 
        SELECT 22, 'Dyfed',1,1,NULL,1, 'GB-022', 'GB-WLS' UNION ALL 
        SELECT 23, 'Essex',1,0,NULL,1, 'GB-ESS', 'GB-ENG' UNION ALL 
        SELECT 24, 'County Fermanagh',1,0,NULL,1, 'GB-FER', 'GB-NIR' UNION ALL 
        SELECT 25, 'Fife',1,0,NULL,1, 'GB-FIF', 'GB-SCT' UNION ALL 
        SELECT 26, 'Mid Glamorgan',1,1,NULL,1, 'GB-026', 'GB-WLS' UNION ALL 
        SELECT 27, 'South Glamorgan',1,1,NULL,1, 'GB-027', 'GB-WLS' UNION ALL 
        SELECT 28, 'West Glamorgan',1,1,NULL,1, 'GB-028', 'GB-WLS' UNION ALL 
        SELECT 29, 'Gloucestershire',1,0,NULL,1, 'GB-GLS', 'GB-ENG' UNION ALL 
        SELECT 30, 'Grampian',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 31, 'Guernsey',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 32, 'Gwent',1,0,NULL,1, 'GB-BGW', 'GB-WLS' UNION ALL 
        SELECT 33, 'Gwynedd',1,0,NULL,1, 'GB-GWN', 'GB-WLS' UNION ALL 
        SELECT 34, 'Hampshire',1,0,NULL,1, 'GB-HAM', 'GB-ENG' UNION ALL 
        SELECT 35, 'Hereford and Worcester',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 36, 'Hertfordshire',1,0,NULL,1, 'GB-HRT', 'GB-ENG' UNION ALL 
        SELECT 37, 'Highlands',1,0,NULL,1, 'GB-HLD', 'GB-SCT' UNION ALL 
        SELECT 38, 'Humberside',1,1,NULL,1, 'GB-038', 'GB-ENG' UNION ALL 
        SELECT 40, 'Isle of Wight',1,0,NULL,1, 'GB-IOW', 'GB-ENG' UNION ALL 
        SELECT 41, 'Jersey',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 42, 'Kent',1,0,NULL,1, 'GB-KEN', 'GB-ENG' UNION ALL 
        SELECT 43, 'Lancashire',1,0,NULL,1, 'GB-LAN', 'GB-ENG' UNION ALL 
        SELECT 44, 'Leicestershire',1,0,NULL,1, 'GB-LEC', 'GB-ENG' UNION ALL 
        SELECT 45, 'Lincolnshire',1,0,NULL,1, 'GB-LIN', 'GB-ENG' UNION ALL 
        SELECT 46, 'Greater London',1,0,NULL,1, 'GB-046', 'GB-ENG' UNION ALL 
        SELECT 47, 'County Londonderry',1,0,NULL,1, 'GB-DRY', 'GB-NIR' UNION ALL 
        SELECT 48, 'Lothian',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 49, 'Greater Manchester',1,0,NULL,1, 'GB-049', 'GB-ENG' UNION ALL 
        SELECT 50, 'Merseyside',1,0,NULL,1, 'GB-LIV', 'GB-ENG' UNION ALL 
        SELECT 51, 'Norfolk',1,0,NULL,1, 'GB-NFK', 'GB-ENG' UNION ALL 
        SELECT 52, 'Northamptonshire',1,0,NULL,1, 'GB-NTH', 'GB-ENG' UNION ALL 
        SELECT 53, 'Northumberland',1,0,NULL,1, 'GB-NBL', 'GB-ENG' UNION ALL 
        SELECT 54, 'Nottinghamshire',1,0,NULL,1, 'GB-NTT', 'GB-ENG' UNION ALL 
        SELECT 55, 'Orkney',1,0,NULL,1, 'GB-ORK', 'GB-SCT' UNION ALL 
        SELECT 56, 'Oxfordshire',1,0,NULL,1, 'GB-OXF', 'GB-ENG' UNION ALL 
        SELECT 57, 'Powys',1,0,NULL,1, 'GB-POW', 'GB-WLS' UNION ALL 
        SELECT 58, 'Shropshire',1,0,NULL,1, 'GB-SHR', 'GB-ENG' UNION ALL 
        SELECT 59, 'Sark',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 60, 'Shetland',1,0,NULL,1, 'GB-ZET', 'GB-SCT' UNION ALL 
        SELECT 61, 'Somerset',1,0,NULL,1, 'GB-SOM', 'GB-ENG' UNION ALL 
        SELECT 62, 'Staffordshire',1,0,NULL,1, 'GB-STS', 'GB-ENG' UNION ALL 
        SELECT 63, 'Strathclyde',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 64, 'Suffolk',1,0,NULL,1, 'GB-SFK', 'GB-ENG' UNION ALL 
        SELECT 65, 'Surrey',1,0,NULL,1, 'GB-SRY', 'GB-ENG' UNION ALL 
        SELECT 66, 'East Sussex',1,0,NULL,1, 'GB-ESX', 'GB-ENG' UNION ALL 
        SELECT 67, 'West Sussex',1,0,NULL,1, 'GB-WSX', 'GB-ENG' UNION ALL 
        SELECT 68, 'Tayside',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 69, 'Tyne and Wear',1,0,NULL,1, 'GB-NET', 'GB-ENG' UNION ALL 
        SELECT 70, 'County Tyrone',1,0,NULL,1, 'GB-DGN', 'GB-NIR' UNION ALL 
        SELECT 71, 'Warwickshire',1,0,NULL,1, 'GB-WAR', 'GB-ENG' UNION ALL 
        SELECT 72, 'Western Isles',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 73, 'West Midlands',1,0,NULL,1, 'GB-073', 'GB-ENG' UNION ALL 
        SELECT 74, 'Wiltshire',1,0,NULL,1, 'GB-WIL', 'GB-ENG' UNION ALL 
        SELECT 75, 'North Yorkshire',1,0,NULL,1, 'GB-NYK', 'GB-ENG' UNION ALL 
        SELECT 76, 'South Yorkshire',1,0,NULL,1, 'GB-076', 'GB-ENG' UNION ALL 
        SELECT 77, 'West Yorkshire',1,0,NULL,1, 'GB-077', 'GB-ENG' UNION ALL 
        SELECT 78, 'Galloway',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 79, 'Middlesex',1,0,NULL,1, 'GB-079', 'GB-ENG' UNION ALL 
        SELECT 80, 'Carmarthenshire',1,0,NULL,1, 'GB-CMN', 'GB-WLS' UNION ALL 
        SELECT 81, 'East Yorkshire',1,0,NULL,1, 'GB-ERY', 'GB-ENG' UNION ALL 
        SELECT 82, 'Lanarkshire',1,0,NULL,1, 'GB-NLK', 'GB-SCT' UNION ALL 
        SELECT 83, 'Aberdeenshire',1,0,NULL,1, 'GB-ABD', 'GB-SCT' UNION ALL 
        SELECT 84, 'Angus',1,0,NULL,1, 'GB-ANS', 'GB-SCT' UNION ALL 
        SELECT 85, 'Argyll',1,0,NULL,1, 'GB-AGB', 'GB-SCT' UNION ALL 
        SELECT 86, 'Ayrshire',1,0,NULL,1, 'GB-EAY', 'GB-SCT' UNION ALL 
        SELECT 87, 'Banffshire',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 88, 'Berwickshire',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 89, 'Caithness',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 90, 'Clackmannanshire',1,0,NULL,1, 'GB-CLK', 'GB-SCT' UNION ALL 
        SELECT 91, 'Dunbartonshire',1,0,NULL,1, 'GB-EDU', 'GB-SCT' UNION ALL 
        SELECT 92, 'Inverness-shire',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 93, 'Isle Of Arran',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 94, 'Isle Of Barra',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 95, 'Isle Of Bute',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 96, 'Isle Of Cumbrae',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 97, 'Isle Of Harris',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 98, 'Isle Of Islay',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 99, 'Isle Of Jura',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 100, 'Isle Of Lewis',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 101, 'Isle Of North Uist',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 102, 'Isle Of Skye',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 103, 'Isle Of South Uist',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 104, 'Isle Of Tiree',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 105, 'Kincardineshire',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 106, 'Kirkcudbrightshire',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 107, 'Morayshire',1,0,NULL,1, 'GB-MRY', 'GB-SCT' UNION ALL 
        SELECT 108, 'Peeblesshire',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 109, 'Perthshire',1,0,NULL,1, 'GB-PKN', 'GB-SCT' UNION ALL 
        SELECT 110, 'Renfrewshire',1,0,NULL,1, 'GB-RFW', 'GB-SCT' UNION ALL 
        SELECT 111, 'Ross-shire',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 112, 'Roxburghshire',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 113, 'Selkirkshire',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 114, 'Stirlingshire',1,0,NULL,1, 'GB-STG', 'GB-SCT' UNION ALL 
        SELECT 115, 'Sutherland',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 116, 'Wigtownshire',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 117, 'Bristol',1,0,NULL,1, 'GB-BST', 'GB-ENG' UNION ALL 
        SELECT 118, 'Central London',1,0,NULL,1, 'GB-LND', 'GB-ENG' UNION ALL 
        SELECT 119, 'Yorkshire',1,0,NULL,1, 'GB-119', 'GB-ENG' UNION ALL 
        SELECT 120, 'Sussex',1,1,NULL,1, 'GB-120', 'GB-ENG' UNION ALL 
        SELECT 121, 'Worcestershire',1,0,NULL,1, 'GB-WOR', 'GB-ENG' UNION ALL 
        SELECT 122, 'Herefordshire',1,0,NULL,1, 'GB-HEF', 'GB-ENG' UNION ALL 
        SELECT 123, 'Conwy County',1,0,NULL,1, 'GB-CWY', 'GB-WLS' UNION ALL 
        SELECT 124, 'Flintshire',1,0,NULL,1, 'GB-FLN', 'GB-WLS' UNION ALL 
        SELECT 125, 'Denbighshire',1,0,NULL,1, 'GB-DEN', 'GB-WLS' UNION ALL 
        SELECT 126, 'East Lothian',1,0,NULL,1, 'GB-ELN', 'GB-SCT' UNION ALL 
        SELECT 127, 'Midlothian',1,0,NULL,1, 'GB-MLN', 'GB-SCT' UNION ALL 
        SELECT 128, 'West Lothian',1,0,NULL,1, 'GB-WLN', 'GB-SCT' UNION ALL 
        SELECT 129, 'Isle Of Mull',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 130, 'Anglesey',1,1,NULL,1, 'GB-AGY', 'GB-WLS' UNION ALL 
        SELECT 131, 'Ceredigion',1,0,NULL,1, 'GB-CGN', 'GB-WLS' UNION ALL 
        SELECT 132, 'Pembrokeshire',1,0,NULL,1, 'GB-PEM', 'GB-WLS' UNION ALL 
        SELECT 133, 'Monmouthshire',1,0,NULL,1, 'GB-MON', 'GB-WLS' UNION ALL 
        SELECT 135, 'Rutland',1,0,NULL,1, 'GB-RUT', 'GB-ENG' UNION ALL 
        SELECT 136, 'South Glos',1,0,NULL,1, 'GB-SGC', 'GB-ENG' UNION ALL 
        SELECT 137, 'Kinross-shire',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 138, 'Swansea',1,0,NULL,1, 'GB-SWA', 'GB-WLS' UNION ALL 
        SELECT 139, 'Rhondda Cynon Taff',1,0,NULL,1, 'GB-RCT', 'GB-WLS' UNION ALL 
        SELECT 140, 'Cardiff',1,0,NULL,1, 'GB-CRF', 'GB-WLS' UNION ALL 
        SELECT 141, 'Caerphilly',1,1,NULL,1, 'GB-CAY', 'GB-WLS' UNION ALL 
        SELECT 142, 'Nairnshire',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 143, 'Newport',1,0,NULL,1, 'GB-NWP', 'GB-WLS' UNION ALL 
        SELECT 144, 'Torfaen',1,0,NULL,1, 'GB-TOF', 'GB-WLS' UNION ALL 
        SELECT 145, 'Monmouth',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 146, 'Isle of Anglesey',1,0,NULL,1, 'GB-AGY', 'GB-WLS' UNION ALL 
        SELECT 147, 'Wrexham',1,0,NULL,1, 'GB-WRX', 'GB-WLS' UNION ALL 
        SELECT 148, 'Neath Port Talbot',1,0,NULL,1, 'GB-NTL', 'GB-WLS' UNION ALL 
        SELECT 149, 'Bridgend',1,0,NULL,1, 'GB-BGE', 'GB-WLS' UNION ALL 
        SELECT 150, 'The Vale of Glamorgan',1,0,NULL,1, 'GB-VGL', 'GB-WLS' UNION ALL 
        SELECT 151, 'Merthyr Tydfil',1,0,NULL,1, 'GB-MTY', 'GB-WLS' UNION ALL 
        SELECT 157, 'Ards',1,0,NULL,1, 'GB-ARD', 'GB-NIR' UNION ALL 
        SELECT 158, 'Belfast',1,0,NULL,1, 'GB-BFS', 'GB-NIR' UNION ALL 
        SELECT 159, 'Ballymena',1,0,NULL,1, 'GB-BLA', 'GB-NIR' UNION ALL 
        SELECT 160, 'Ballymoney',1,0,NULL,1, 'GB-BLY', 'GB-NIR' UNION ALL 
        SELECT 161, 'Banbridge',1,0,NULL,1, 'GB-BNB', 'GB-NIR' UNION ALL 
        SELECT 162, 'Craigavon',1,0,NULL,1, 'GB-CGV', 'GB-NIR' UNION ALL 
        SELECT 163, 'Carrickfergus',1,0,NULL,1, 'GB-CKF', 'GB-NIR' UNION ALL 
        SELECT 164, 'Cookstown',1,0,NULL,1, 'GB-CKT', 'GB-NIR' UNION ALL 
        SELECT 165, 'Coleraine',1,0,NULL,1, 'GB-CLR', 'GB-NIR' UNION ALL 
        SELECT 166, 'Castlereagh',1,0,NULL,1, 'GB-CSR', 'GB-NIR' UNION ALL 
        SELECT 167, 'Limavady',1,0,NULL,1, 'GB-LMV', 'GB-NIR' UNION ALL 
        SELECT 168, 'Larne',1,0,NULL,1, 'GB-LRN', 'GB-NIR' UNION ALL 
        SELECT 169, 'Lisburn',1,0,NULL,1, 'GB-LSB', 'GB-NIR' UNION ALL 
        SELECT 170, 'Magherafelt',1,0,NULL,1, 'GB-MFT', 'GB-NIR' UNION ALL 
        SELECT 171, 'Moyle',1,0,NULL,1, 'GB-MYL', 'GB-NIR' UNION ALL 
        SELECT 172, 'North Down',1,0,NULL,1, 'GB-NDN', 'GB-NIR' UNION ALL 
        SELECT 173, 'Newtownabbey',1,0,NULL,1, 'GB-NTA', 'GB-NIR' UNION ALL 
        SELECT 174, 'Newry and Mourne',1,0,NULL,1, 'GB-NYM', 'GB-NIR' UNION ALL 
        SELECT 175, 'Omagh',1,0,NULL,1, 'GB-OMH', 'GB-NIR' UNION ALL 
        SELECT 176, 'Strabane',1,0,NULL,1, 'GB-STB', 'GB-NIR' UNION ALL 
        SELECT 177, 'Aberdeen City',1,0,NULL,1, 'GB-ABE', 'GB-SCT' UNION ALL 
        SELECT 178, 'Dundee City',1,0,NULL,1, 'GB-DND', 'GB-SCT' UNION ALL 
        SELECT 179, 'Edinburgh, City of',1,0,NULL,1, 'GB-EDH', 'GB-SCT' UNION ALL 
        SELECT 180, 'Eilean Siar',1,0,NULL,1, 'GB-ELS', 'GB-SCT' UNION ALL 
        SELECT 181, 'East Renfrewshire',1,0,NULL,1, 'GB-ERW', 'GB-SCT' UNION ALL 
        SELECT 182, 'Falkirk',1,0,NULL,1, 'GB-FAL', 'GB-SCT' UNION ALL 
        SELECT 183, 'Glasgow City',1,0,NULL,1, 'GB-GLG', 'GB-SCT' UNION ALL 
        SELECT 184, 'Inverclyde',1,0,NULL,1, 'GB-IVC', 'GB-SCT' UNION ALL 
        SELECT 185, 'North Ayrshire',1,0,NULL,1, 'GB-NAY', 'GB-SCT' UNION ALL 
        SELECT 186, 'South Ayrshire',1,0,NULL,1, 'GB-SAY', 'GB-SCT' UNION ALL 
        SELECT 187, 'South Lanarkshire',1,0,NULL,1, 'GB-SLK', 'GB-SCT' UNION ALL 
        SELECT 189, 'West Dunbartonshire',1,0,NULL,1, 'GB-WDU', 'GB-SCT' UNION ALL 
        SELECT 190, 'Bath and North East Somerset',1,0,NULL,1, 'GB-BAS', 'GB-ENG' UNION ALL 
        SELECT 191, 'Blackburn with Darwen',1,0,NULL,1, 'GB-BBD', 'GB-ENG' UNION ALL 
        SELECT 192, 'Bedford',1,0,NULL,1, 'GB-BDF', 'GB-ENG' UNION ALL 
        SELECT 193, 'Barking and Dagenham',1,0,NULL,1, 'GB-BDG', 'GB-ENG' UNION ALL 
        SELECT 194, 'Brent',1,0,NULL,1, 'GB-BEN', 'GB-ENG' UNION ALL 
        SELECT 195, 'Bexley',1,0,NULL,1, 'GB-BEX', 'GB-ENG' UNION ALL 
        SELECT 196, 'Birmingham',1,0,NULL,1, 'GB-BIR', 'GB-ENG' UNION ALL 
        SELECT 197, 'Bournemouth',1,0,NULL,1, 'GB-BMH', 'GB-ENG' UNION ALL 
        SELECT 198, 'Barnet',1,0,NULL,1, 'GB-BNE', 'GB-ENG' UNION ALL 
        SELECT 199, 'Brighton and Hove',1,0,NULL,1, 'GB-BNH', 'GB-ENG' UNION ALL 
        SELECT 200, 'Barnsley',1,0,NULL,1, 'GB-BNS', 'GB-ENG' UNION ALL 
        SELECT 201, 'Bolton',1,0,NULL,1, 'GB-BOL', 'GB-ENG' UNION ALL 
        SELECT 202, 'Blackpool',1,0,NULL,1, 'GB-BPL', 'GB-ENG' UNION ALL 
        SELECT 203, 'Bracknell Forest',1,0,NULL,1, 'GB-BRC', 'GB-ENG' UNION ALL 
        SELECT 204, 'Bradford',1,0,NULL,1, 'GB-BRD', 'GB-ENG' UNION ALL 
        SELECT 205, 'Bromley',1,0,NULL,1, 'GB-BRY', 'GB-ENG' UNION ALL 
        SELECT 206, 'Bury',1,0,NULL,1, 'GB-BUR', 'GB-ENG' UNION ALL 
        SELECT 207, 'Cheshire West and Chester',1,0,NULL,1, 'GB-CHW', 'GB-ENG' UNION ALL 
        SELECT 208, 'Calderdale',1,0,NULL,1, 'GB-CLD', 'GB-ENG' UNION ALL 
        SELECT 209, 'Camden',1,0,NULL,1, 'GB-CMD', 'GB-ENG' UNION ALL 
        SELECT 210, 'Coventry',1,0,NULL,1, 'GB-COV', 'GB-ENG' UNION ALL 
        SELECT 211, 'Croydon',1,0,NULL,1, 'GB-CRY', 'GB-ENG' UNION ALL 
        SELECT 212, 'Darlington',1,0,NULL,1, 'GB-DAL', 'GB-ENG' UNION ALL 
        SELECT 213, 'Derby',1,0,NULL,1, 'GB-DER', 'GB-ENG' UNION ALL 
        SELECT 214, 'Doncaster',1,0,NULL,1, 'GB-DNC', 'GB-ENG' UNION ALL 
        SELECT 215, 'Dudley',1,0,NULL,1, 'GB-DUD', 'GB-ENG' UNION ALL 
        SELECT 216, 'Ealing',1,0,NULL,1, 'GB-EAL', 'GB-ENG' UNION ALL 
        SELECT 217, 'Enfield',1,0,NULL,1, 'GB-ENF', 'GB-ENG' UNION ALL 
        SELECT 218, 'Gateshead',1,0,NULL,1, 'GB-GAT', 'GB-ENG' UNION ALL 
        SELECT 219, 'Greenwich',1,0,NULL,1, 'GB-GRE', 'GB-ENG' UNION ALL 
        SELECT 220, 'Halton',1,0,NULL,1, 'GB-HAL', 'GB-ENG' UNION ALL 
        SELECT 221, 'Havering',1,0,NULL,1, 'GB-HAV', 'GB-ENG' UNION ALL 
        SELECT 222, 'Hackney',1,0,NULL,1, 'GB-HCK', 'GB-ENG' UNION ALL 
        SELECT 223, 'Hillingdon',1,0,NULL,1, 'GB-HIL', 'GB-ENG' UNION ALL 
        SELECT 224, 'Hammersmith and Fulham',1,0,NULL,1, 'GB-HMF', 'GB-ENG' UNION ALL 
        SELECT 225, 'Hounslow',1,0,NULL,1, 'GB-HNS', 'GB-ENG' UNION ALL 
        SELECT 226, 'Hartlepool',1,0,NULL,1, 'GB-HPL', 'GB-ENG' UNION ALL 
        SELECT 227, 'Harrow',1,0,NULL,1, 'GB-HRW', 'GB-ENG' UNION ALL 
        SELECT 228, 'Haringey',1,0,NULL,1, 'GB-HRY', 'GB-ENG' UNION ALL 
        SELECT 229, 'Isles of Scilly',1,0,NULL,1, 'GB-IOS', 'GB-ENG' UNION ALL 
        SELECT 230, 'Islington',1,0,NULL,1, 'GB-ISL', 'GB-ENG' UNION ALL 
        SELECT 231, 'Kensington and Chelsea',1,0,NULL,1, 'GB-KEC', 'GB-ENG' UNION ALL 
        SELECT 232, 'Kingston upon Hull',1,0,NULL,1, 'GB-KHL', 'GB-ENG' UNION ALL 
        SELECT 233, 'Kirklees',1,0,NULL,1, 'GB-KIR', 'GB-ENG' UNION ALL 
        SELECT 234, 'Kingston upon Thames',1,0,NULL,1, 'GB-KTT', 'GB-ENG' UNION ALL 
        SELECT 235, 'Knowsley',1,0,NULL,1, 'GB-KWL', 'GB-ENG' UNION ALL 
        SELECT 236, 'Lambeth',1,0,NULL,1, 'GB-LBH', 'GB-ENG' UNION ALL 
        SELECT 237, 'Leicester',1,0,NULL,1, 'GB-LCE', 'GB-ENG' UNION ALL 
        SELECT 238, 'Leeds',1,0,NULL,1, 'GB-LDS', 'GB-ENG' UNION ALL 
        SELECT 239, 'Lewisham',1,0,NULL,1, 'GB-LEW', 'GB-ENG' UNION ALL 
        SELECT 240, 'Luton',1,0,NULL,1, 'GB-LUT', 'GB-ENG' UNION ALL 
        SELECT 241, 'Manchester',1,0,NULL,1, 'GB-MAN', 'GB-ENG' UNION ALL 
        SELECT 242, 'Middlesbrough',1,0,NULL,1, 'GB-MDB', 'GB-ENG' UNION ALL 
        SELECT 243, 'Medway',1,0,NULL,1, 'GB-MDW', 'GB-ENG' UNION ALL 
        SELECT 244, 'Milton Keynes',1,0,NULL,1, 'GB-MIK', 'GB-ENG' UNION ALL 
        SELECT 245, 'Merton',1,0,NULL,1, 'GB-MRT', 'GB-ENG' UNION ALL 
        SELECT 246, 'North East Lincolnshire',1,0,NULL,1, 'GB-NEL', 'GB-ENG' UNION ALL 
        SELECT 247, 'Nottingham',1,0,NULL,1, 'GB-NGM', 'GB-ENG' UNION ALL 
        SELECT 248, 'North Lincolnshire',1,0,NULL,1, 'GB-NLN', 'GB-ENG' UNION ALL 
        SELECT 249, 'North Somerset',1,0,NULL,1, 'GB-NSM', 'GB-ENG' UNION ALL 
        SELECT 250, 'North Tyneside',1,0,NULL,1, 'GB-NTY', 'GB-ENG' UNION ALL 
        SELECT 251, 'Newham',1,0,NULL,1, 'GB-NWM', 'GB-ENG' UNION ALL 
        SELECT 252, 'Oldham',1,0,NULL,1, 'GB-OLD', 'GB-ENG' UNION ALL 
        SELECT 253, 'Plymouth',1,0,NULL,1, 'GB-PLY', 'GB-ENG' UNION ALL 
        SELECT 254, 'Poole',1,0,NULL,1, 'GB-POL', 'GB-ENG' UNION ALL 
        SELECT 255, 'Portsmouth',1,0,NULL,1, 'GB-POR', 'GB-ENG' UNION ALL 
        SELECT 256, 'Peterborough',1,0,NULL,1, 'GB-PTE', 'GB-ENG' UNION ALL 
        SELECT 257, 'Rochdale',1,0,NULL,1, 'GB-RCH', 'GB-ENG' UNION ALL 
        SELECT 258, 'Redbridge',1,0,NULL,1, 'GB-RDB', 'GB-ENG' UNION ALL 
        SELECT 259, 'Reading',1,0,NULL,1, 'GB-RDG', 'GB-ENG' UNION ALL 
        SELECT 260, 'Richmond upon Thames',1,0,NULL,1, 'GB-RIC', 'GB-ENG' UNION ALL 
        SELECT 261, 'Rotherham',1,0,NULL,1, 'GB-ROT', 'GB-ENG' UNION ALL 
        SELECT 262, 'Sandwell',1,0,NULL,1, 'GB-SAW', 'GB-ENG' UNION ALL 
        SELECT 263, 'Sefton',1,0,NULL,1, 'GB-SFT', 'GB-ENG' UNION ALL 
        SELECT 264, 'Sheffield',1,0,NULL,1, 'GB-SHF', 'GB-ENG' UNION ALL 
        SELECT 265, 'St. Helens',1,0,NULL,1, 'GB-SHN', 'GB-ENG' UNION ALL 
        SELECT 266, 'Stockport',1,0,NULL,1, 'GB-SKP', 'GB-ENG' UNION ALL 
        SELECT 267, 'Salford',1,0,NULL,1, 'GB-SLF', 'GB-ENG' UNION ALL 
        SELECT 268, 'Slough',1,0,NULL,1, 'GB-SLG', 'GB-ENG' UNION ALL 
        SELECT 269, 'Sunderland',1,0,NULL,1, 'GB-SND', 'GB-ENG' UNION ALL 
        SELECT 270, 'Solihull',1,0,NULL,1, 'GB-SOL', 'GB-ENG' UNION ALL 
        SELECT 271, 'Southend-on-Sea',1,0,NULL,1, 'GB-SOS', 'GB-ENG' UNION ALL 
        SELECT 272, 'Stoke-on-Trent',1,0,NULL,1, 'GB-STE', 'GB-ENG' UNION ALL 
        SELECT 273, 'Southampton',1,0,NULL,1, 'GB-STH', 'GB-ENG' UNION ALL 
        SELECT 274, 'Sutton',1,0,NULL,1, 'GB-STN', 'GB-ENG' UNION ALL 
        SELECT 275, 'Stockton-on-Tees',1,0,NULL,1, 'GB-STT', 'GB-ENG' UNION ALL 
        SELECT 276, 'South Tyneside',1,0,NULL,1, 'GB-STY', 'GB-ENG' UNION ALL 
        SELECT 277, 'Swindon',1,0,NULL,1, 'GB-SWD', 'GB-ENG' UNION ALL 
        SELECT 278, 'Southwark',1,0,NULL,1, 'GB-SWK', 'GB-ENG' UNION ALL 
        SELECT 279, 'Tameside',1,0,NULL,1, 'GB-TAM', 'GB-ENG' UNION ALL 
        SELECT 280, 'Telford and Wrekin',1,0,NULL,1, 'GB-TFW', 'GB-ENG' UNION ALL 
        SELECT 281, 'Thurrock',1,0,NULL,1, 'GB-THR', 'GB-ENG' UNION ALL 
        SELECT 282, 'Torbay',1,0,NULL,1, 'GB-TOB', 'GB-ENG' UNION ALL 
        SELECT 283, 'Trafford',1,0,NULL,1, 'GB-TRF', 'GB-ENG' UNION ALL 
        SELECT 284, 'Tower Hamlets',1,0,NULL,1, 'GB-TWH', 'GB-ENG' UNION ALL 
        SELECT 285, 'Waltham Forest',1,0,NULL,1, 'GB-WFT', 'GB-ENG' UNION ALL 
        SELECT 286, 'Wigan',1,0,NULL,1, 'GB-WGN', 'GB-ENG' UNION ALL 
        SELECT 287, 'Wakefield',1,0,NULL,1, 'GB-WKF', 'GB-ENG' UNION ALL 
        SELECT 288, 'Walsall',1,0,NULL,1, 'GB-WLL', 'GB-ENG' UNION ALL 
        SELECT 289, 'Wolverhampton',1,0,NULL,1, 'GB-WLV', 'GB-ENG' UNION ALL 
        SELECT 290, 'Wandsworth',1,0,NULL,1, 'GB-WND', 'GB-ENG' UNION ALL 
        SELECT 291, 'Windsor and Maidenhead',1,0,NULL,1, 'GB-WNM', 'GB-ENG' UNION ALL 
        SELECT 292, 'Wokingham',1,0,NULL,1, 'GB-WOK', 'GB-ENG' UNION ALL 
        SELECT 293, 'Wirral',1,0,NULL,1, 'GB-WRL', 'GB-ENG' UNION ALL 
        SELECT 294, 'Warrington',1,0,NULL,1, 'GB-WRT', 'GB-ENG' UNION ALL 
        SELECT 295, 'Westminster',1,0,NULL,1, 'GB-WSM', 'GB-ENG' UNION ALL 
        SELECT 296, 'York',1,0,NULL,1, 'GB-YOR', 'GB-ENG' UNION ALL 
        SELECT 298, 'Isle of Man',1,1,NULL,1, NULL, NULL UNION ALL 
        SELECT 299, 'Alabama',2,0,NULL,1, 'US-AL', NULL UNION ALL 
        SELECT 300, 'Alaska',2,0,NULL,1, 'US-AK', NULL UNION ALL 
        SELECT 301, 'American Samoa',2,0,NULL,1, 'US-AS', NULL UNION ALL 
        SELECT 302, 'Arizona',2,0,NULL,1, 'US-AZ', NULL UNION ALL 
        SELECT 303, 'Arkansas',2,0,NULL,1, 'US-AR', NULL UNION ALL 
        SELECT 304, 'California',2,0,NULL,1, 'US-CA', NULL UNION ALL 
        SELECT 305, 'Colorado',2,0,NULL,1, 'US-CO', NULL UNION ALL 
        SELECT 306, 'Connecticut',2,0,NULL,1, 'US-CT', NULL UNION ALL 
        SELECT 307, 'Delaware',2,0,NULL,1, 'US-DE', NULL UNION ALL 
        SELECT 308, 'District of Columbia',2,0,NULL,1, 'US-DC', NULL UNION ALL 
        SELECT 309, 'Florida',2,0,NULL,1, 'US-FL', NULL UNION ALL 
        SELECT 310, 'Georgia',2,0,NULL,1, 'US-GA', NULL UNION ALL 
        SELECT 311, 'Guam',2,0,NULL,1, 'US-GU', NULL UNION ALL 
        SELECT 312, 'Hawaii',2,0,NULL,1, 'US-HI', NULL UNION ALL 
        SELECT 313, 'Idaho',2,0,NULL,1, 'US-ID', NULL UNION ALL 
        SELECT 314, 'Illinois',2,0,NULL,1, 'US-IL', NULL UNION ALL 
        SELECT 315, 'Indiana',2,0,NULL,1, 'US-IN', NULL UNION ALL 
        SELECT 316, 'Iowa',2,0,NULL,1, 'US-IA', NULL UNION ALL 
        SELECT 317, 'Kansas',2,0,NULL,1, 'US-KS', NULL UNION ALL 
        SELECT 318, 'Kentucky',2,0,NULL,1, 'US-KY', NULL UNION ALL 
        SELECT 319, 'Louisiana',2,0,NULL,1, 'US-LA', NULL UNION ALL 
        SELECT 320, 'Maine',2,0,NULL,1, 'US-ME', NULL UNION ALL 
        SELECT 321, 'Maryland',2,0,NULL,1, 'US-MD', NULL UNION ALL 
        SELECT 322, 'Massachusetts',2,0,NULL,1, 'US-MA', NULL UNION ALL 
        SELECT 323, 'Michigan',2,0,NULL,1, 'US-MI', NULL UNION ALL 
        SELECT 324, 'Minnesota',2,0,NULL,1, 'US-MN', NULL UNION ALL 
        SELECT 325, 'Mississippi',2,0,NULL,1, 'US-MS', NULL UNION ALL 
        SELECT 326, 'Missouri',2,0,NULL,1, 'US-MO', NULL UNION ALL 
        SELECT 327, 'Montana',2,0,NULL,1, 'US-MT', NULL UNION ALL 
        SELECT 328, 'Nebraska',2,0,NULL,1, 'US-NE', NULL UNION ALL 
        SELECT 329, 'Nevada',2,0,NULL,1, 'US-NV', NULL UNION ALL 
        SELECT 330, 'New Hampshire',2,0,NULL,1, 'US-NH', NULL UNION ALL 
        SELECT 331, 'New Jersey',2,0,NULL,1, 'US-NJ', NULL UNION ALL 
        SELECT 332, 'New Mexico',2,0,NULL,1, 'US-NM', NULL UNION ALL 
        SELECT 333, 'New York',2,0,NULL,1, 'US-NY', NULL UNION ALL 
        SELECT 334, 'North Carolina',2,0,NULL,1, 'US-NC', NULL UNION ALL 
        SELECT 335, 'North Dakota',2,0,NULL,1, 'US-ND', NULL UNION ALL 
        SELECT 336, 'Northern Mariana Islands',2,0,NULL,1, 'US-MP', NULL UNION ALL 
        SELECT 337, 'Ohio',2,0,NULL,1, 'US-OH', NULL UNION ALL 
        SELECT 338, 'Oklahoma',2,0,NULL,1, 'US-OK', NULL UNION ALL 
        SELECT 339, 'Oregon',2,0,NULL,1, 'US-OR', NULL UNION ALL 
        SELECT 340, 'Pennsylvania',2,0,NULL,1, 'US-PA', NULL UNION ALL 
        SELECT 341, 'Puerto Rico',2,0,NULL,1, 'US-PR', NULL UNION ALL 
        SELECT 342, 'Rhode Island',2,0,NULL,1, 'US-RI', NULL UNION ALL 
        SELECT 343, 'South Carolina',2,0,NULL,1, 'US-SC', NULL UNION ALL 
        SELECT 344, 'South Dakota',2,0,NULL,1, 'US-SD', NULL UNION ALL 
        SELECT 345, 'Tennessee',2,0,NULL,1, 'US-TN', NULL UNION ALL 
        SELECT 346, 'Texas',2,0,NULL,1, 'US-TX', NULL UNION ALL 
        SELECT 347, 'United States Minor Outlying Islands',2,0,NULL,1, 'US-UM', NULL UNION ALL 
        SELECT 348, 'Utah',2,0,NULL,1, 'US-UT', NULL UNION ALL 
        SELECT 349, 'Vermont',2,0,NULL,1, 'US-VT', NULL UNION ALL 
        SELECT 350, 'Virgin Islands, U.S.',2,0,NULL,1, 'US-VI', NULL UNION ALL 
        SELECT 351, 'Virginia',2,0,NULL,1, 'US-VA', NULL UNION ALL 
        SELECT 352, 'Washington',2,0,NULL,1, 'US-WA', NULL UNION ALL 
        SELECT 353, 'West Virginia',2,0,NULL,1, 'US-WV', NULL UNION ALL 
        SELECT 354, 'Wisconsin',2,0,NULL,1, 'US-WI', NULL UNION ALL 
        SELECT 355, 'Wyoming',2,0,NULL,1, 'US-WY', NULL UNION ALL 
        SELECT 356, 'Berat',4,0,NULL,1, 'AL-01', NULL UNION ALL 
        SELECT 357, 'Dibër',4,0,NULL,1, 'AL-09', NULL UNION ALL 
        SELECT 358, 'Durrës',4,0,NULL,1, 'AL-02', NULL UNION ALL 
        SELECT 359, 'Elbasan',4,0,NULL,1, 'AL-03', NULL UNION ALL 
        SELECT 360, 'Fier',4,0,NULL,1, 'AL-04', NULL UNION ALL 
        SELECT 361, 'Gjirokastër',4,0,NULL,1, 'AL-05', NULL UNION ALL 
        SELECT 362, 'Korçë',4,0,NULL,1, 'AL-06', NULL UNION ALL 
        SELECT 363, 'Kukës',4,0,NULL,1, 'AL-07', NULL UNION ALL 
        SELECT 364, 'Lezhë',4,0,NULL,1, 'AL-08', NULL UNION ALL 
        SELECT 365, 'Shkodër',4,0,NULL,1, 'AL-10', NULL UNION ALL 
        SELECT 366, 'Tiranë',4,0,NULL,1, 'AL-11', NULL UNION ALL 
        SELECT 367, 'Vlorë',4,0,NULL,1, 'AL-12', NULL UNION ALL 
        SELECT 368, 'Adrar',5,0,NULL,1, 'DZ-01', NULL UNION ALL 
        SELECT 369, 'Alger',5,0,NULL,1, 'DZ-16', NULL UNION ALL 
        SELECT 370, 'Annaba',5,0,NULL,1, 'DZ-23', NULL UNION ALL 
        SELECT 371, 'Aïn Defla',5,0,NULL,1, 'DZ-44', NULL UNION ALL 
        SELECT 372, 'Aïn Témouchent',5,0,NULL,1, 'DZ-46', NULL UNION ALL 
        SELECT 373, 'Batna',5,0,NULL,1, 'DZ-05', NULL UNION ALL 
        SELECT 374, 'Biskra',5,0,NULL,1, 'DZ-07', NULL UNION ALL 
        SELECT 375, 'Blida',5,0,NULL,1, 'DZ-09', NULL UNION ALL 
        SELECT 376, 'Bordj Bou Arréridj',5,0,NULL,1, 'DZ-34', NULL UNION ALL 
        SELECT 377, 'Bouira',5,0,NULL,1, 'DZ-10', NULL UNION ALL 
        SELECT 378, 'Boumerdès',5,0,NULL,1, 'DZ-35', NULL UNION ALL 
        SELECT 379, 'Béchar',5,0,NULL,1, 'DZ-08', NULL UNION ALL 
        SELECT 380, 'Béjaïa',5,0,NULL,1, 'DZ-06', NULL UNION ALL 
        SELECT 381, 'Chlef',5,0,NULL,1, 'DZ-02', NULL UNION ALL 
        SELECT 382, 'Constantine',5,0,NULL,1, 'DZ-25', NULL UNION ALL 
        SELECT 383, 'Djelfa',5,0,NULL,1, 'DZ-17', NULL UNION ALL 
        SELECT 384, 'El Bayadh',5,0,NULL,1, 'DZ-32', NULL UNION ALL 
        SELECT 385, 'El Oued',5,0,NULL,1, 'DZ-39', NULL UNION ALL 
        SELECT 386, 'El Tarf',5,0,NULL,1, 'DZ-36', NULL UNION ALL 
        SELECT 387, 'Ghardaïa',5,0,NULL,1, 'DZ-47', NULL UNION ALL 
        SELECT 388, 'Guelma',5,0,NULL,1, 'DZ-24', NULL UNION ALL 
        SELECT 389, 'Illizi',5,0,NULL,1, 'DZ-33', NULL UNION ALL 
        SELECT 390, 'Jijel',5,0,NULL,1, 'DZ-18', NULL UNION ALL 
        SELECT 391, 'Khenchela',5,0,NULL,1, 'DZ-40', NULL UNION ALL 
        SELECT 392, 'Laghouat',5,0,NULL,1, 'DZ-03', NULL UNION ALL 
        SELECT 393, 'M''sila',5,0,NULL,1, 'DZ-28', NULL UNION ALL 
        SELECT 394, 'Mascara',5,0,NULL,1, 'DZ-29', NULL UNION ALL 
        SELECT 395, 'Mila',5,0,NULL,1, 'DZ-43', NULL UNION ALL 
        SELECT 396, 'Mostaganem',5,0,NULL,1, 'DZ-27', NULL UNION ALL 
        SELECT 397, 'Médéa',5,0,NULL,1, 'DZ-26', NULL UNION ALL 
        SELECT 398, 'Naama',5,0,NULL,1, 'DZ-45', NULL UNION ALL 
        SELECT 399, 'Oran',5,0,NULL,1, 'DZ-31', NULL UNION ALL 
        SELECT 400, 'Ouargla',5,0,NULL,1, 'DZ-30', NULL UNION ALL 
        SELECT 401, 'Oum el Bouaghi',5,0,NULL,1, 'DZ-04', NULL UNION ALL 
        SELECT 402, 'Relizane',5,0,NULL,1, 'DZ-48', NULL UNION ALL 
        SELECT 403, 'Saïda',5,0,NULL,1, 'DZ-20', NULL UNION ALL 
        SELECT 404, 'Sidi Bel Abbès',5,0,NULL,1, 'DZ-22', NULL UNION ALL 
        SELECT 405, 'Skikda',5,0,NULL,1, 'DZ-21', NULL UNION ALL 
        SELECT 406, 'Souk Ahras',5,0,NULL,1, 'DZ-41', NULL UNION ALL 
        SELECT 407, 'Sétif',5,0,NULL,1, 'DZ-19', NULL UNION ALL 
        SELECT 408, 'Tamanrasset',5,0,NULL,1, 'DZ-11', NULL UNION ALL 
        SELECT 409, 'Tiaret',5,0,NULL,1, 'DZ-14', NULL UNION ALL 
        SELECT 410, 'Tindouf',5,0,NULL,1, 'DZ-37', NULL UNION ALL 
        SELECT 411, 'Tipaza',5,0,NULL,1, 'DZ-42', NULL UNION ALL 
        SELECT 412, 'Tissemsilt',5,0,NULL,1, 'DZ-38', NULL UNION ALL 
        SELECT 413, 'Tizi Ouzou',5,0,NULL,1, 'DZ-15', NULL UNION ALL 
        SELECT 414, 'Tlemcen',5,0,NULL,1, 'DZ-13', NULL UNION ALL 
        SELECT 415, 'Tébessa',5,0,NULL,1, 'DZ-12', NULL UNION ALL 
        SELECT 416, 'Andorra la Vella',7,0,NULL,1, 'AD-07', NULL UNION ALL 
        SELECT 417, 'Canillo',7,0,NULL,1, 'AD-02', NULL UNION ALL 
        SELECT 418, 'Encamp',7,0,NULL,1, 'AD-03', NULL UNION ALL 
        SELECT 419, 'Escaldes-Engordany',7,0,NULL,1, 'AD-08', NULL UNION ALL 
        SELECT 420, 'La Massana',7,0,NULL,1, 'AD-04', NULL UNION ALL 
        SELECT 421, 'Ordino',7,0,NULL,1, 'AD-05', NULL UNION ALL 
        SELECT 422, 'Sant Julià de Lòria',7,0,NULL,1, 'AD-06', NULL UNION ALL 
        SELECT 423, 'Bengo',8,0,NULL,1, 'AO-BGO', NULL UNION ALL 
        SELECT 424, 'Benguela',8,0,NULL,1, 'AO-BGU', NULL UNION ALL 
        SELECT 425, 'Bié',8,0,NULL,1, 'AO-BIE', NULL UNION ALL 
        SELECT 426, 'Cabinda',8,0,NULL,1, 'AO-CAB', NULL UNION ALL 
        SELECT 427, 'Cunene',8,0,NULL,1, 'AO-CNN', NULL UNION ALL 
        SELECT 428, 'Huambo',8,0,NULL,1, 'AO-HUA', NULL UNION ALL 
        SELECT 429, 'Huíla',8,0,NULL,1, 'AO-HUI', NULL UNION ALL 
        SELECT 430, 'Kuando Kubango',8,0,NULL,1, 'AO-CCU', NULL UNION ALL 
        SELECT 431, 'Kwanza Norte',8,0,NULL,1, 'AO-CNO', NULL UNION ALL 
        SELECT 432, 'Kwanza Sul',8,0,NULL,1, 'AO-CUS', NULL UNION ALL 
        SELECT 433, 'Luanda',8,0,NULL,1, 'AO-LUA', NULL UNION ALL 
        SELECT 434, 'Lunda Norte',8,0,NULL,1, 'AO-LNO', NULL UNION ALL 
        SELECT 435, 'Lunda Sul',8,0,NULL,1, 'AO-LSU', NULL UNION ALL 
        SELECT 436, 'Malange',8,0,NULL,1, 'AO-MAL', NULL UNION ALL 
        SELECT 437, 'Moxico',8,0,NULL,1, 'AO-MOX', NULL UNION ALL 
        SELECT 438, 'Namibe',8,0,NULL,1, 'AO-NAM', NULL UNION ALL 
        SELECT 439, 'Uíge',8,0,NULL,1, 'AO-UIG', NULL UNION ALL 
        SELECT 440, 'Zaire',8,0,NULL,1, 'AO-ZAI', NULL UNION ALL 
        SELECT 441, 'Barbuda',11,0,NULL,1, 'AG-10', NULL UNION ALL 
        SELECT 442, 'Redonda',11,0,NULL,1, 'AG-11', NULL UNION ALL 
        SELECT 443, 'Saint George',11,0,NULL,1, 'AG-03', NULL UNION ALL 
        SELECT 444, 'Saint John',11,0,NULL,1, 'AG-04', NULL UNION ALL 
        SELECT 445, 'Saint Mary',11,0,NULL,1, 'AG-05', NULL UNION ALL 
        SELECT 446, 'Saint Paul',11,0,NULL,1, 'AG-06', NULL UNION ALL 
        SELECT 447, 'Saint Peter',11,0,NULL,1, 'AG-07', NULL UNION ALL 
        SELECT 448, 'Saint Philip',11,0,NULL,1, 'AG-08', NULL UNION ALL 
        SELECT 449, 'Buenos Aires',12,0,NULL,1, 'AR-B', NULL UNION ALL 
        SELECT 450, 'Catamarca',12,0,NULL,1, 'AR-K', NULL UNION ALL 
        SELECT 451, 'Chaco',12,0,NULL,1, 'AR-H', NULL UNION ALL 
        SELECT 452, 'Chubut',12,0,NULL,1, 'AR-U', NULL UNION ALL 
        SELECT 453, 'Ciudad Autónoma de Buenos Aires',12,0,NULL,1, 'AR-C', NULL UNION ALL 
        SELECT 454, 'Corrientes',12,0,NULL,1, 'AR-W', NULL UNION ALL 
        SELECT 455, 'Córdoba',12,0,NULL,1, 'AR-X', NULL UNION ALL 
        SELECT 456, 'Entre Ríos',12,0,NULL,1, 'AR-E', NULL UNION ALL 
        SELECT 457, 'Formosa',12,0,NULL,1, 'AR-P', NULL UNION ALL 
        SELECT 458, 'Jujuy',12,0,NULL,1, 'AR-Y', NULL UNION ALL 
        SELECT 459, 'La Pampa',12,0,NULL,1, 'AR-L', NULL UNION ALL 
        SELECT 460, 'La Rioja',12,0,NULL,1, 'AR-F', NULL UNION ALL 
        SELECT 461, 'Mendoza',12,0,NULL,1, 'AR-M', NULL UNION ALL 
        SELECT 462, 'Misiones',12,0,NULL,1, 'AR-N', NULL UNION ALL 
        SELECT 463, 'Neuquén',12,0,NULL,1, 'AR-Q', NULL UNION ALL 
        SELECT 464, 'Río Negro',12,0,NULL,1, 'AR-R', NULL UNION ALL 
        SELECT 465, 'Salta',12,0,NULL,1, 'AR-A', NULL UNION ALL 
        SELECT 466, 'San Juan',12,0,NULL,1, 'AR-J', NULL UNION ALL 
        SELECT 467, 'San Luis',12,0,NULL,1, 'AR-D', NULL UNION ALL 
        SELECT 468, 'Santa Cruz',12,0,NULL,1, 'AR-Z', NULL UNION ALL 
        SELECT 469, 'Santa Fe',12,0,NULL,1, 'AR-S', NULL UNION ALL 
        SELECT 470, 'Santiago del Estero',12,0,NULL,1, 'AR-G', NULL UNION ALL 
        SELECT 471, 'Tierra del Fuego',12,0,NULL,1, 'AR-V', NULL UNION ALL 
        SELECT 472, 'Tucumán',12,0,NULL,1, 'AR-T', NULL UNION ALL 
        SELECT 473, 'Aragac?otn',13,0,NULL,1, 'AM-AG', NULL UNION ALL 
        SELECT 474, 'Ararat',13,0,NULL,1, 'AM-AR', NULL UNION ALL 
        SELECT 475, 'Armavir',13,0,NULL,1, 'AM-AV', NULL UNION ALL 
        SELECT 476, 'Erevan',13,0,NULL,1, 'AM-ER', NULL UNION ALL 
        SELECT 477, 'Gegark''unik''',13,0,NULL,1, 'AM-GR', NULL UNION ALL 
        SELECT 478, 'Kotayk''',13,0,NULL,1, 'AM-KT', NULL UNION ALL 
        SELECT 479, 'Lo?i',13,0,NULL,1, 'AM-LO', NULL UNION ALL 
        SELECT 480, 'Syunik''',13,0,NULL,1, 'AM-SU', NULL UNION ALL 
        SELECT 481, 'Tavuš',13,0,NULL,1, 'AM-TV', NULL UNION ALL 
        SELECT 482, 'Vayoc Jor',13,0,NULL,1, 'AM-VD', NULL UNION ALL 
        SELECT 483, 'Širak',13,0,NULL,1, 'AM-SH', NULL UNION ALL 
        SELECT 484, 'Australian Capital Territory',15,0,NULL,1, 'AU-ACT', NULL UNION ALL 
        SELECT 485, 'New South Wales',15,0,NULL,1, 'AU-NSW', NULL UNION ALL 
        SELECT 486, 'Northern Territory',15,0,NULL,1, 'AU-NT', NULL UNION ALL 
        SELECT 487, 'Queensland',15,0,NULL,1, 'AU-QLD', NULL UNION ALL 
        SELECT 488, 'South Australia',15,0,NULL,1, 'AU-SA', NULL UNION ALL 
        SELECT 489, 'Tasmania',15,0,NULL,1, 'AU-TAS', NULL UNION ALL 
        SELECT 490, 'Victoria',15,0,NULL,1, 'AU-VIC', NULL UNION ALL 
        SELECT 491, 'Western Australia',15,0,NULL,1, 'AU-WA', NULL UNION ALL 
        SELECT 492, 'Burgenland',16,0,NULL,1, 'AT-1', NULL UNION ALL 
        SELECT 493, 'Kärnten',16,0,NULL,1, 'AT-2', NULL UNION ALL 
        SELECT 494, 'Niederösterreich',16,0,NULL,1, 'AT-3', NULL UNION ALL 
        SELECT 495, 'Oberösterreich',16,0,NULL,1, 'AT-4', NULL UNION ALL 
        SELECT 496, 'Salzburg',16,0,NULL,1, 'AT-5', NULL UNION ALL 
        SELECT 497, 'Steiermark',16,0,NULL,1, 'AT-6', NULL UNION ALL 
        SELECT 498, 'Tirol',16,0,NULL,1, 'AT-7', NULL UNION ALL 
        SELECT 499, 'Vorarlberg',16,0,NULL,1, 'AT-8', NULL UNION ALL 
        SELECT 500, 'Wien',16,0,NULL,1, 'AT-9', NULL UNION ALL 
        SELECT 501, 'Abseron',17,0,NULL,1, 'AZ-ABS', NULL UNION ALL 
        SELECT 502, 'Astara',17,0,NULL,1, 'AZ-AST', NULL UNION ALL 
        SELECT 503, 'Agcab?di',17,0,NULL,1, 'AZ-AGC', NULL UNION ALL 
        SELECT 504, 'Agdam',17,0,NULL,1, 'AZ-AGM', NULL UNION ALL 
        SELECT 505, 'Agdas',17,0,NULL,1, 'AZ-AGS', NULL UNION ALL 
        SELECT 506, 'Agstafa',17,0,NULL,1, 'AZ-AGA', NULL UNION ALL 
        SELECT 507, 'Agsu',17,0,NULL,1, 'AZ-AGU', NULL UNION ALL 
        SELECT 508, 'Bab?k',17,0,NULL,1, 'AZ-BAB', 'AZ-NX' UNION ALL 
        SELECT 509, 'Baki',17,0,NULL,1, 'AZ-BA', NULL UNION ALL 
        SELECT 510, 'Balak?n',17,0,NULL,1, 'AZ-BAL', NULL UNION ALL 
        SELECT 511, 'Beyl?qan',17,0,NULL,1, 'AZ-BEY', NULL UNION ALL 
        SELECT 512, 'Bil?suvar',17,0,NULL,1, 'AZ-BIL', NULL UNION ALL 
        SELECT 513, 'B?rd?',17,0,NULL,1, 'AZ-BAR', NULL UNION ALL 
        SELECT 514, 'Culfa',17,0,NULL,1, 'AZ-CUL', 'AZ-NX' UNION ALL 
        SELECT 515, 'C?brayil',17,0,NULL,1, 'AZ-CAB', NULL UNION ALL 
        SELECT 516, 'C?lilabad',17,0,NULL,1, 'AZ-CAL', NULL UNION ALL 
        SELECT 517, 'Dask?s?n',17,0,NULL,1, 'AZ-DAS', NULL UNION ALL 
        SELECT 518, 'Füzuli',17,0,NULL,1, 'AZ-FUZ', NULL UNION ALL 
        SELECT 519, 'Goranboy',17,0,NULL,1, 'AZ-GOR', NULL UNION ALL 
        SELECT 520, 'Göygöl',17,0,NULL,1, 'AZ-GYG', NULL UNION ALL 
        SELECT 521, 'Göyçay',17,0,NULL,1, 'AZ-GOY', NULL UNION ALL 
        SELECT 522, 'G?d?b?y',17,0,NULL,1, 'AZ-GAD', NULL UNION ALL 
        SELECT 523, 'G?nc?',17,0,NULL,1, 'AZ-GA', NULL UNION ALL 
        SELECT 524, 'Haciqabul',17,0,NULL,1, 'AZ-HAC', NULL UNION ALL 
        SELECT 525, 'Kürd?mir',17,0,NULL,1, 'AZ-KUR', NULL UNION ALL 
        SELECT 526, 'K?ng?rli',17,0,NULL,1, 'AZ-KAN', 'AZ-NX' UNION ALL 
        SELECT 527, 'K?lb?c?r',17,0,NULL,1, 'AZ-KAL', NULL UNION ALL 
        SELECT 528, 'Laçin',17,0,NULL,1, 'AZ-LAC', NULL UNION ALL 
        SELECT 529, 'Lerik',17,0,NULL,1, 'AZ-LER', NULL UNION ALL 
        SELECT 530, 'L?nk?ran',17,0,NULL,1, 'AZ-LA', NULL UNION ALL 
        SELECT 531, 'L?nk?ran',17,0,NULL,1, 'AZ-LAN', NULL UNION ALL 
        SELECT 532, 'Masalli',17,0,NULL,1, 'AZ-MAS', NULL UNION ALL 
        SELECT 533, 'Ming?çevir',17,0,NULL,1, 'AZ-MI', NULL UNION ALL 
        SELECT 534, 'Naftalan',17,0,NULL,1, 'AZ-NA', NULL UNION ALL 
        SELECT 535, 'Naxçivan',17,0,NULL,1, 'AZ-NX', NULL UNION ALL 
        SELECT 536, 'Naxçivan',17,0,NULL,1, 'AZ-NV', 'AZ-NX' UNION ALL 
        SELECT 537, 'Neftçala',17,0,NULL,1, 'AZ-NEF', NULL UNION ALL 
        SELECT 538, 'Ordubad',17,0,NULL,1, 'AZ-ORD', 'AZ-NX' UNION ALL 
        SELECT 539, 'Oguz',17,0,NULL,1, 'AZ-OGU', NULL UNION ALL 
        SELECT 540, 'Qax',17,0,NULL,1, 'AZ-QAX', NULL UNION ALL 
        SELECT 541, 'Qazax',17,0,NULL,1, 'AZ-QAZ', NULL UNION ALL 
        SELECT 542, 'Qobustan',17,0,NULL,1, 'AZ-QOB', NULL UNION ALL 
        SELECT 543, 'Quba',17,0,NULL,1, 'AZ-QBA', NULL UNION ALL 
        SELECT 544, 'Qubadli',17,0,NULL,1, 'AZ-QBI', NULL UNION ALL 
        SELECT 545, 'Qusar',17,0,NULL,1, 'AZ-QUS', NULL UNION ALL 
        SELECT 546, 'Q?b?l?',17,0,NULL,1, 'AZ-QAB', NULL UNION ALL 
        SELECT 547, 'Saatli',17,0,NULL,1, 'AZ-SAT', NULL UNION ALL 
        SELECT 548, 'Sabirabad',17,0,NULL,1, 'AZ-SAB', NULL UNION ALL 
        SELECT 549, 'Salyan',17,0,NULL,1, 'AZ-SAL', NULL UNION ALL 
        SELECT 550, 'Samux',17,0,NULL,1, 'AZ-SMX', NULL UNION ALL 
        SELECT 551, 'Siy?z?n',17,0,NULL,1, 'AZ-SIY', NULL UNION ALL 
        SELECT 552, 'Sumqayit',17,0,NULL,1, 'AZ-SM', NULL UNION ALL 
        SELECT 553, 'S?d?r?k',17,0,NULL,1, 'AZ-SAD', 'AZ-NX' UNION ALL 
        SELECT 554, 'Tovuz',17,0,NULL,1, 'AZ-TOV', NULL UNION ALL 
        SELECT 555, 'T?rt?r',17,0,NULL,1, 'AZ-TAR', NULL UNION ALL 
        SELECT 556, 'Ucar',17,0,NULL,1, 'AZ-UCA', NULL UNION ALL 
        SELECT 557, 'Xank?ndi',17,0,NULL,1, 'AZ-XA', NULL UNION ALL 
        SELECT 558, 'Xaçmaz',17,0,NULL,1, 'AZ-XAC', NULL UNION ALL 
        SELECT 559, 'Xocali',17,0,NULL,1, 'AZ-XCI', NULL UNION ALL 
        SELECT 560, 'Xocav?nd',17,0,NULL,1, 'AZ-XVD', NULL UNION ALL 
        SELECT 561, 'Xizi',17,0,NULL,1, 'AZ-XIZ', NULL UNION ALL 
        SELECT 562, 'Yardimli',17,0,NULL,1, 'AZ-YAR', NULL UNION ALL 
        SELECT 563, 'Yevlax',17,0,NULL,1, 'AZ-YE', NULL UNION ALL 
        SELECT 564, 'Yevlax',17,0,NULL,1, 'AZ-YEV', NULL UNION ALL 
        SELECT 565, 'Zaqatala',17,0,NULL,1, 'AZ-ZAQ', NULL UNION ALL 
        SELECT 566, 'Z?ngilan',17,0,NULL,1, 'AZ-ZAN', NULL UNION ALL 
        SELECT 567, 'Z?rdab',17,0,NULL,1, 'AZ-ZAR', NULL UNION ALL 
        SELECT 568, 'Imisli',17,0,NULL,1, 'AZ-IMI', NULL UNION ALL 
        SELECT 569, 'Ismayilli',17,0,NULL,1, 'AZ-ISM', NULL UNION ALL 
        SELECT 570, 'Sabran',17,0,NULL,1, 'AZ-SBN', NULL UNION ALL 
        SELECT 571, 'Sahbuz',17,0,NULL,1, 'AZ-SAH', 'AZ-NX' UNION ALL 
        SELECT 572, 'Samaxi',17,0,NULL,1, 'AZ-SMI', NULL UNION ALL 
        SELECT 573, 'Sirvan',17,0,NULL,1, 'AZ-SR', NULL UNION ALL 
        SELECT 574, 'Susa',17,0,NULL,1, 'AZ-SUS', NULL UNION ALL 
        SELECT 575, 'S?ki',17,0,NULL,1, 'AZ-SA', NULL UNION ALL 
        SELECT 576, 'S?ki',17,0,NULL,1, 'AZ-SAK', NULL UNION ALL 
        SELECT 577, 'S?mkir',17,0,NULL,1, 'AZ-SKR', NULL UNION ALL 
        SELECT 578, 'S?rur',17,0,NULL,1, 'AZ-SAR', 'AZ-NX' UNION ALL 
        SELECT 579, 'Acklins',18,0,NULL,1, 'BS-AK', NULL UNION ALL 
        SELECT 580, 'Berry Islands',18,0,NULL,1, 'BS-BY', NULL UNION ALL 
        SELECT 581, 'Bimini',18,0,NULL,1, 'BS-BI', NULL UNION ALL 
        SELECT 582, 'Black Point',18,0,NULL,1, 'BS-BP', NULL UNION ALL 
        SELECT 583, 'Cat Island',18,0,NULL,1, 'BS-CI', NULL UNION ALL 
        SELECT 584, 'Central Abaco',18,0,NULL,1, 'BS-CO', NULL UNION ALL 
        SELECT 585, 'Central Andros',18,0,NULL,1, 'BS-CS', NULL UNION ALL 
        SELECT 586, 'Central Eleuthera',18,0,NULL,1, 'BS-CE', NULL UNION ALL 
        SELECT 587, 'City of Freeport',18,0,NULL,1, 'BS-FP', NULL UNION ALL 
        SELECT 588, 'Crooked Island and Long Cay',18,0,NULL,1, 'BS-CK', NULL UNION ALL 
        SELECT 589, 'East Grand Bahama',18,0,NULL,1, 'BS-EG', NULL UNION ALL 
        SELECT 590, 'Exuma',18,0,NULL,1, 'BS-EX', NULL UNION ALL 
        SELECT 591, 'Grand Cay',18,0,NULL,1, 'BS-GC', NULL UNION ALL 
        SELECT 592, 'Harbour Island',18,0,NULL,1, 'BS-HI', NULL UNION ALL 
        SELECT 593, 'Hope Town',18,0,NULL,1, 'BS-HT', NULL UNION ALL 
        SELECT 594, 'Inagua',18,0,NULL,1, 'BS-IN', NULL UNION ALL 
        SELECT 595, 'Long Island',18,0,NULL,1, 'BS-LI', NULL UNION ALL 
        SELECT 596, 'Mangrove Cay',18,0,NULL,1, 'BS-MC', NULL UNION ALL 
        SELECT 597, 'Mayaguana',18,0,NULL,1, 'BS-MG', NULL UNION ALL 
        SELECT 598, 'Moore''s Island',18,0,NULL,1, 'BS-MI', NULL UNION ALL 
        SELECT 599, 'New Providence',18,0,NULL,1, 'BS-NP', NULL UNION ALL 
        SELECT 600, 'North Abaco',18,0,NULL,1, 'BS-NO', NULL UNION ALL 
        SELECT 601, 'North Andros',18,0,NULL,1, 'BS-NS', NULL UNION ALL 
        SELECT 602, 'North Eleuthera',18,0,NULL,1, 'BS-NE', NULL UNION ALL 
        SELECT 603, 'Ragged Island',18,0,NULL,1, 'BS-RI', NULL UNION ALL 
        SELECT 604, 'Rum Cay',18,0,NULL,1, 'BS-RC', NULL UNION ALL 
        SELECT 605, 'San Salvador',18,0,NULL,1, 'BS-SS', NULL UNION ALL 
        SELECT 606, 'South Abaco',18,0,NULL,1, 'BS-SO', NULL UNION ALL 
        SELECT 607, 'South Andros',18,0,NULL,1, 'BS-SA', NULL UNION ALL 
        SELECT 608, 'South Eleuthera',18,0,NULL,1, 'BS-SE', NULL UNION ALL 
        SELECT 609, 'Spanish Wells',18,0,NULL,1, 'BS-SW', NULL UNION ALL 
        SELECT 610, 'West Grand Bahama',18,0,NULL,1, 'BS-WG', NULL UNION ALL 
        SELECT 611, 'Al Janubiyah',19,0,NULL,1, 'BH-14', NULL UNION ALL 
        SELECT 612, 'Al Mu?arraq',19,0,NULL,1, 'BH-15', NULL UNION ALL 
        SELECT 613, 'Al ‘Asimah',19,0,NULL,1, 'BH-13', NULL UNION ALL 
        SELECT 614, 'Ash Shamaliyah',19,0,NULL,1, 'BH-17', NULL UNION ALL 
        SELECT 615, 'Bagerhat',20,0,NULL,1, 'BD-05', 'BD-D' UNION ALL 
        SELECT 616, 'Bandarban',20,0,NULL,1, 'BD-01', 'BD-B' UNION ALL 
        SELECT 617, 'Barguna',20,0,NULL,1, 'BD-02', 'BD-A' UNION ALL 
        SELECT 618, 'Barisal',20,0,NULL,1, 'BD-A', NULL UNION ALL 
        SELECT 619, 'Barisal',20,0,NULL,1, 'BD-06', 'BD-A' UNION ALL 
        SELECT 620, 'Bhola',20,0,NULL,1, 'BD-07', 'BD-A' UNION ALL 
        SELECT 621, 'Bogra',20,0,NULL,1, 'BD-03', 'BD-E' UNION ALL 
        SELECT 622, 'Brahmanbaria',20,0,NULL,1, 'BD-04', 'BD-B' UNION ALL 
        SELECT 623, 'Chandpur',20,0,NULL,1, 'BD-09', 'BD-B' UNION ALL 
        SELECT 624, 'Chapai Nawabganj',20,0,NULL,1, 'BD-45', 'BD-E' UNION ALL 
        SELECT 625, 'Chittagong',20,0,NULL,1, 'BD-B', NULL UNION ALL 
        SELECT 626, 'Chittagong',20,0,NULL,1, 'BD-10', 'BD-B' UNION ALL 
        SELECT 627, 'Chuadanga',20,0,NULL,1, 'BD-12', 'BD-D' UNION ALL 
        SELECT 628, 'Comilla',20,0,NULL,1, 'BD-08', 'BD-B' UNION ALL 
        SELECT 629, 'Cox''s Bazar',20,0,NULL,1, 'BD-11', 'BD-B' UNION ALL 
        SELECT 630, 'Dhaka',20,0,NULL,1, 'BD-C', NULL UNION ALL 
        SELECT 631, 'Dhaka',20,0,NULL,1, 'BD-13', 'BD-C' UNION ALL 
        SELECT 632, 'Dinajpur',20,0,NULL,1, 'BD-14', 'BD-F' UNION ALL 
        SELECT 633, 'Faridpur',20,0,NULL,1, 'BD-15', 'BD-C' UNION ALL 
        SELECT 634, 'Feni',20,0,NULL,1, 'BD-16', 'BD-B' UNION ALL 
        SELECT 635, 'Gaibandha',20,0,NULL,1, 'BD-19', 'BD-F' UNION ALL 
        SELECT 636, 'Gazipur',20,0,NULL,1, 'BD-18', 'BD-C' UNION ALL 
        SELECT 637, 'Gopalganj',20,0,NULL,1, 'BD-17', 'BD-C' UNION ALL 
        SELECT 638, 'Habiganj',20,0,NULL,1, 'BD-20', 'BD-G' UNION ALL 
        SELECT 639, 'Jamalpur',20,0,NULL,1, 'BD-21', 'BD-H' UNION ALL 
        SELECT 640, 'Jessore',20,0,NULL,1, 'BD-22', 'BD-D' UNION ALL 
        SELECT 641, 'Jhalakathi',20,0,NULL,1, 'BD-25', 'BD-A' UNION ALL 
        SELECT 642, 'Jhenaidah',20,0,NULL,1, 'BD-23', 'BD-D' UNION ALL 
        SELECT 643, 'Joypurhat',20,0,NULL,1, 'BD-24', 'BD-E' UNION ALL 
        SELECT 644, 'Khagrachhari',20,0,NULL,1, 'BD-29', 'BD-B' UNION ALL 
        SELECT 645, 'Khulna',20,0,NULL,1, 'BD-D', NULL UNION ALL 
        SELECT 646, 'Khulna',20,0,NULL,1, 'BD-27', 'BD-D' UNION ALL 
        SELECT 647, 'Kishoreganj',20,0,NULL,1, 'BD-26', 'BD-C' UNION ALL 
        SELECT 648, 'Kurigram',20,0,NULL,1, 'BD-28', 'BD-F' UNION ALL 
        SELECT 649, 'Kushtia',20,0,NULL,1, 'BD-30', 'BD-D' UNION ALL 
        SELECT 650, 'Lakshmipur',20,0,NULL,1, 'BD-31', 'BD-B' UNION ALL 
        SELECT 651, 'Lalmonirhat',20,0,NULL,1, 'BD-32', 'BD-F' UNION ALL 
        SELECT 652, 'Madaripur',20,0,NULL,1, 'BD-36', 'BD-C' UNION ALL 
        SELECT 653, 'Magura',20,0,NULL,1, 'BD-37', 'BD-D' UNION ALL 
        SELECT 654, 'Manikganj',20,0,NULL,1, 'BD-33', 'BD-C' UNION ALL 
        SELECT 655, 'Meherpur',20,0,NULL,1, 'BD-39', 'BD-D' UNION ALL 
        SELECT 656, 'Moulvibazar',20,0,NULL,1, 'BD-38', 'BD-G' UNION ALL 
        SELECT 657, 'Munshiganj',20,0,NULL,1, 'BD-35', 'BD-C' UNION ALL 
        SELECT 658, 'Mymensingh',20,0,NULL,1, 'BD-H', NULL UNION ALL 
        SELECT 659, 'Mymensingh',20,0,NULL,1, 'BD-34', 'BD-H' UNION ALL 
        SELECT 660, 'Naogaon',20,0,NULL,1, 'BD-48', 'BD-E' UNION ALL 
        SELECT 661, 'Narail',20,0,NULL,1, 'BD-43', 'BD-D' UNION ALL 
        SELECT 662, 'Narayanganj',20,0,NULL,1, 'BD-40', 'BD-C' UNION ALL 
        SELECT 663, 'Narsingdi',20,0,NULL,1, 'BD-42', 'BD-C' UNION ALL 
        SELECT 664, 'Natore',20,0,NULL,1, 'BD-44', 'BD-E' UNION ALL 
        SELECT 665, 'Netrakona',20,0,NULL,1, 'BD-41', 'BD-H' UNION ALL 
        SELECT 666, 'Nilphamari',20,0,NULL,1, 'BD-46', 'BD-F' UNION ALL 
        SELECT 667, 'Noakhali',20,0,NULL,1, 'BD-47', 'BD-B' UNION ALL 
        SELECT 668, 'Pabna',20,0,NULL,1, 'BD-49', 'BD-E' UNION ALL 
        SELECT 669, 'Panchagarh',20,0,NULL,1, 'BD-52', 'BD-F' UNION ALL 
        SELECT 670, 'Patuakhali',20,0,NULL,1, 'BD-51', 'BD-A' UNION ALL 
        SELECT 671, 'Pirojpur',20,0,NULL,1, 'BD-50', 'BD-A' UNION ALL 
        SELECT 672, 'Rajbari',20,0,NULL,1, 'BD-53', 'BD-C' UNION ALL 
        SELECT 673, 'Rajshahi',20,0,NULL,1, 'BD-E', NULL UNION ALL 
        SELECT 674, 'Rajshahi',20,0,NULL,1, 'BD-54', 'BD-E' UNION ALL 
        SELECT 675, 'Rangamati',20,0,NULL,1, 'BD-56', 'BD-B' UNION ALL 
        SELECT 676, 'Rangpur',20,0,NULL,1, 'BD-F', NULL UNION ALL 
        SELECT 677, 'Rangpur',20,0,NULL,1, 'BD-55', 'BD-F' UNION ALL 
        SELECT 678, 'Satkhira',20,0,NULL,1, 'BD-58', 'BD-D' UNION ALL 
        SELECT 679, 'Shariatpur',20,0,NULL,1, 'BD-62', 'BD-C' UNION ALL 
        SELECT 680, 'Sherpur',20,0,NULL,1, 'BD-57', 'BD-H' UNION ALL 
        SELECT 681, 'Sirajganj',20,0,NULL,1, 'BD-59', 'BD-E' UNION ALL 
        SELECT 682, 'Sunamganj',20,0,NULL,1, 'BD-61', 'BD-G' UNION ALL 
        SELECT 683, 'Sylhet',20,0,NULL,1, 'BD-G', NULL UNION ALL 
        SELECT 684, 'Sylhet',20,0,NULL,1, 'BD-60', 'BD-G' UNION ALL 
        SELECT 685, 'Tangail',20,0,NULL,1, 'BD-63', 'BD-C' UNION ALL 
        SELECT 686, 'Thakurgaon',20,0,NULL,1, 'BD-64', 'BD-F' UNION ALL 
        SELECT 687, 'Christ Church',21,0,NULL,1, 'BB-01', NULL UNION ALL 
        SELECT 688, 'Saint Andrew',21,0,NULL,1, 'BB-02', NULL UNION ALL 
        SELECT 689, 'Saint George',21,0,NULL,1, 'BB-03', NULL UNION ALL 
        SELECT 690, 'Saint James',21,0,NULL,1, 'BB-04', NULL UNION ALL 
        SELECT 691, 'Saint John',21,0,NULL,1, 'BB-05', NULL UNION ALL 
        SELECT 692, 'Saint Joseph',21,0,NULL,1, 'BB-06', NULL UNION ALL 
        SELECT 693, 'Saint Lucy',21,0,NULL,1, 'BB-07', NULL UNION ALL 
        SELECT 694, 'Saint Michael',21,0,NULL,1, 'BB-08', NULL UNION ALL 
        SELECT 695, 'Saint Peter',21,0,NULL,1, 'BB-09', NULL UNION ALL 
        SELECT 696, 'Saint Philip',21,0,NULL,1, 'BB-10', NULL UNION ALL 
        SELECT 697, 'Saint Thomas',21,0,NULL,1, 'BB-11', NULL UNION ALL 
        SELECT 698, 'Belize',24,0,NULL,1, 'BZ-BZ', NULL UNION ALL 
        SELECT 699, 'Cayo',24,0,NULL,1, 'BZ-CY', NULL UNION ALL 
        SELECT 700, 'Corozal',24,0,NULL,1, 'BZ-CZL', NULL UNION ALL 
        SELECT 701, 'Orange Walk',24,0,NULL,1, 'BZ-OW', NULL UNION ALL 
        SELECT 702, 'Stann Creek',24,0,NULL,1, 'BZ-SC', NULL UNION ALL 
        SELECT 703, 'Toledo',24,0,NULL,1, 'BZ-TOL', NULL UNION ALL 
        SELECT 704, 'Alibori',25,0,NULL,1, 'BJ-AL', NULL UNION ALL 
        SELECT 705, 'Atacora',25,0,NULL,1, 'BJ-AK', NULL UNION ALL 
        SELECT 706, 'Atlantique',25,0,NULL,1, 'BJ-AQ', NULL UNION ALL 
        SELECT 707, 'Borgou',25,0,NULL,1, 'BJ-BO', NULL UNION ALL 
        SELECT 708, 'Collines',25,0,NULL,1, 'BJ-CO', NULL UNION ALL 
        SELECT 709, 'Couffo',25,0,NULL,1, 'BJ-KO', NULL UNION ALL 
        SELECT 710, 'Donga',25,0,NULL,1, 'BJ-DO', NULL UNION ALL 
        SELECT 711, 'Littoral',25,0,NULL,1, 'BJ-LI', NULL UNION ALL 
        SELECT 712, 'Mono',25,0,NULL,1, 'BJ-MO', NULL UNION ALL 
        SELECT 713, 'Ouémé',25,0,NULL,1, 'BJ-OU', NULL UNION ALL 
        SELECT 714, 'Plateau',25,0,NULL,1, 'BJ-PL', NULL UNION ALL 
        SELECT 715, 'Zou',25,0,NULL,1, 'BJ-ZO', NULL UNION ALL 
        SELECT 716, 'Bumthang',27,0,NULL,1, 'BT-33', NULL UNION ALL 
        SELECT 717, 'Chhukha',27,0,NULL,1, 'BT-12', NULL UNION ALL 
        SELECT 718, 'Dagana',27,0,NULL,1, 'BT-22', NULL UNION ALL 
        SELECT 719, 'Gasa',27,0,NULL,1, 'BT-GA', NULL UNION ALL 
        SELECT 720, 'Haa',27,0,NULL,1, 'BT-13', NULL UNION ALL 
        SELECT 721, 'Lhuentse',27,0,NULL,1, 'BT-44', NULL UNION ALL 
        SELECT 722, 'Monggar',27,0,NULL,1, 'BT-42', NULL UNION ALL 
        SELECT 723, 'Paro',27,0,NULL,1, 'BT-11', NULL UNION ALL 
        SELECT 724, 'Pemagatshel',27,0,NULL,1, 'BT-43', NULL UNION ALL 
        SELECT 725, 'Punakha',27,0,NULL,1, 'BT-23', NULL UNION ALL 
        SELECT 726, 'Samdrup Jongkhar',27,0,NULL,1, 'BT-45', NULL UNION ALL 
        SELECT 727, 'Samtse',27,0,NULL,1, 'BT-14', NULL UNION ALL 
        SELECT 728, 'Sarpang',27,0,NULL,1, 'BT-31', NULL UNION ALL 
        SELECT 729, 'Thimphu',27,0,NULL,1, 'BT-15', NULL UNION ALL 
        SELECT 730, 'Trashi Yangtse',27,0,NULL,1, 'BT-TY', NULL UNION ALL 
        SELECT 731, 'Trashigang',27,0,NULL,1, 'BT-41', NULL UNION ALL 
        SELECT 732, 'Trongsa',27,0,NULL,1, 'BT-32', NULL UNION ALL 
        SELECT 733, 'Tsirang',27,0,NULL,1, 'BT-21', NULL UNION ALL 
        SELECT 734, 'Wangdue Phodrang',27,0,NULL,1, 'BT-24', NULL UNION ALL 
        SELECT 735, 'Zhemgang',27,0,NULL,1, 'BT-34', NULL UNION ALL 
        SELECT 736, 'Chuquisaca',28,0,NULL,1, 'BO-H', NULL UNION ALL 
        SELECT 737, 'Cochabamba',28,0,NULL,1, 'BO-C', NULL UNION ALL 
        SELECT 738, 'El Beni',28,0,NULL,1, 'BO-B', NULL UNION ALL 
        SELECT 739, 'La Paz',28,0,NULL,1, 'BO-L', NULL UNION ALL 
        SELECT 740, 'Oruro',28,0,NULL,1, 'BO-O', NULL UNION ALL 
        SELECT 741, 'Pando',28,0,NULL,1, 'BO-N', NULL UNION ALL 
        SELECT 742, 'Potosí',28,0,NULL,1, 'BO-P', NULL UNION ALL 
        SELECT 743, 'Santa Cruz',28,0,NULL,1, 'BO-S', NULL UNION ALL 
        SELECT 744, 'Tarija',28,0,NULL,1, 'BO-T', NULL UNION ALL 
        SELECT 745, 'Central',30,0,NULL,1, 'BW-CE', NULL UNION ALL 
        SELECT 746, 'Chobe',30,0,NULL,1, 'BW-CH', NULL UNION ALL 
        SELECT 747, 'Francistown',30,0,NULL,1, 'BW-FR', NULL UNION ALL 
        SELECT 748, 'Gaborone',30,0,NULL,1, 'BW-GA', NULL UNION ALL 
        SELECT 749, 'Ghanzi',30,0,NULL,1, 'BW-GH', NULL UNION ALL 
        SELECT 750, 'Jwaneng',30,0,NULL,1, 'BW-JW', NULL UNION ALL 
        SELECT 751, 'Kgalagadi',30,0,NULL,1, 'BW-KG', NULL UNION ALL 
        SELECT 752, 'Kgatleng',30,0,NULL,1, 'BW-KL', NULL UNION ALL 
        SELECT 753, 'Kweneng',30,0,NULL,1, 'BW-KW', NULL UNION ALL 
        SELECT 754, 'Lobatse',30,0,NULL,1, 'BW-LO', NULL UNION ALL 
        SELECT 755, 'North East',30,0,NULL,1, 'BW-NE', NULL UNION ALL 
        SELECT 756, 'North West',30,0,NULL,1, 'BW-NW', NULL UNION ALL 
        SELECT 757, 'Selibe Phikwe',30,0,NULL,1, 'BW-SP', NULL UNION ALL 
        SELECT 758, 'South East',30,0,NULL,1, 'BW-SE', NULL UNION ALL 
        SELECT 759, 'Southern',30,0,NULL,1, 'BW-SO', NULL UNION ALL 
        SELECT 760, 'Sowa Town',30,0,NULL,1, 'BW-ST', NULL UNION ALL 
        SELECT 761, 'Acre',32,0,NULL,1, 'BR-AC', NULL UNION ALL 
        SELECT 762, 'Alagoas',32,0,NULL,1, 'BR-AL', NULL UNION ALL 
        SELECT 763, 'Amapá',32,0,NULL,1, 'BR-AP', NULL UNION ALL 
        SELECT 764, 'Amazonas',32,0,NULL,1, 'BR-AM', NULL UNION ALL 
        SELECT 765, 'Bahia',32,0,NULL,1, 'BR-BA', NULL UNION ALL 
        SELECT 766, 'Ceará',32,0,NULL,1, 'BR-CE', NULL UNION ALL 
        SELECT 767, 'Distrito Federal',32,0,NULL,1, 'BR-DF', NULL UNION ALL 
        SELECT 768, 'Espírito Santo',32,0,NULL,1, 'BR-ES', NULL UNION ALL 
        SELECT 769, 'Goiás',32,0,NULL,1, 'BR-GO', NULL UNION ALL 
        SELECT 770, 'Maranhão',32,0,NULL,1, 'BR-MA', NULL UNION ALL 
        SELECT 771, 'Mato Grosso',32,0,NULL,1, 'BR-MT', NULL UNION ALL 
        SELECT 772, 'Mato Grosso do Sul',32,0,NULL,1, 'BR-MS', NULL UNION ALL 
        SELECT 773, 'Minas Gerais',32,0,NULL,1, 'BR-MG', NULL UNION ALL 
        SELECT 774, 'Paraná',32,0,NULL,1, 'BR-PR', NULL UNION ALL 
        SELECT 775, 'Paraíba',32,0,NULL,1, 'BR-PB', NULL UNION ALL 
        SELECT 776, 'Pará',32,0,NULL,1, 'BR-PA', NULL UNION ALL 
        SELECT 777, 'Pernambuco',32,0,NULL,1, 'BR-PE', NULL UNION ALL 
        SELECT 778, 'Piauí',32,0,NULL,1, 'BR-PI', NULL UNION ALL 
        SELECT 779, 'Rio Grande do Norte',32,0,NULL,1, 'BR-RN', NULL UNION ALL 
        SELECT 780, 'Rio Grande do Sul',32,0,NULL,1, 'BR-RS', NULL UNION ALL 
        SELECT 781, 'Rio de Janeiro',32,0,NULL,1, 'BR-RJ', NULL UNION ALL 
        SELECT 782, 'Rondônia',32,0,NULL,1, 'BR-RO', NULL UNION ALL 
        SELECT 783, 'Roraima',32,0,NULL,1, 'BR-RR', NULL UNION ALL 
        SELECT 784, 'Santa Catarina',32,0,NULL,1, 'BR-SC', NULL UNION ALL 
        SELECT 785, 'Sergipe',32,0,NULL,1, 'BR-SE', NULL UNION ALL 
        SELECT 786, 'São Paulo',32,0,NULL,1, 'BR-SP', NULL UNION ALL 
        SELECT 787, 'Tocantins',32,0,NULL,1, 'BR-TO', NULL UNION ALL 
        SELECT 788, 'Blagoevgrad',35,0,NULL,1, 'BG-01', NULL UNION ALL 
        SELECT 789, 'Burgas',35,0,NULL,1, 'BG-02', NULL UNION ALL 
        SELECT 790, 'Dobrich',35,0,NULL,1, 'BG-08', NULL UNION ALL 
        SELECT 791, 'Gabrovo',35,0,NULL,1, 'BG-07', NULL UNION ALL 
        SELECT 792, 'Haskovo',35,0,NULL,1, 'BG-26', NULL UNION ALL 
        SELECT 793, 'Kardzhali',35,0,NULL,1, 'BG-09', NULL UNION ALL 
        SELECT 794, 'Kyustendil',35,0,NULL,1, 'BG-10', NULL UNION ALL 
        SELECT 795, 'Lovech',35,0,NULL,1, 'BG-11', NULL UNION ALL 
        SELECT 796, 'Montana',35,0,NULL,1, 'BG-12', NULL UNION ALL 
        SELECT 797, 'Pazardzhik',35,0,NULL,1, 'BG-13', NULL UNION ALL 
        SELECT 798, 'Pernik',35,0,NULL,1, 'BG-14', NULL UNION ALL 
        SELECT 799, 'Pleven',35,0,NULL,1, 'BG-15', NULL UNION ALL 
        SELECT 800, 'Plovdiv',35,0,NULL,1, 'BG-16', NULL UNION ALL 
        SELECT 801, 'Razgrad',35,0,NULL,1, 'BG-17', NULL UNION ALL 
        SELECT 802, 'Ruse',35,0,NULL,1, 'BG-18', NULL UNION ALL 
        SELECT 803, 'Shumen',35,0,NULL,1, 'BG-27', NULL UNION ALL 
        SELECT 804, 'Silistra',35,0,NULL,1, 'BG-19', NULL UNION ALL 
        SELECT 805, 'Sliven',35,0,NULL,1, 'BG-20', NULL UNION ALL 
        SELECT 806, 'Smolyan',35,0,NULL,1, 'BG-21', NULL UNION ALL 
        SELECT 807, 'Sofia',35,0,NULL,1, 'BG-23', NULL UNION ALL 
        SELECT 808, 'Sofia (stolitsa)',35,0,NULL,1, 'BG-22', NULL UNION ALL 
        SELECT 809, 'Stara Zagora',35,0,NULL,1, 'BG-24', NULL UNION ALL 
        SELECT 810, 'Targovishte',35,0,NULL,1, 'BG-25', NULL UNION ALL 
        SELECT 811, 'Varna',35,0,NULL,1, 'BG-03', NULL UNION ALL 
        SELECT 812, 'Veliko Tarnovo',35,0,NULL,1, 'BG-04', NULL UNION ALL 
        SELECT 813, 'Vidin',35,0,NULL,1, 'BG-05', NULL UNION ALL 
        SELECT 814, 'Vratsa',35,0,NULL,1, 'BG-06', NULL UNION ALL 
        SELECT 815, 'Yambol',35,0,NULL,1, 'BG-28', NULL UNION ALL 
        SELECT 816, 'Balé',36,0,NULL,1, 'BF-BAL', 'BF-01' UNION ALL 
        SELECT 817, 'Bam',36,0,NULL,1, 'BF-BAM', 'BF-05' UNION ALL 
        SELECT 818, 'Banwa',36,0,NULL,1, 'BF-BAN', 'BF-01' UNION ALL 
        SELECT 819, 'Bazèga',36,0,NULL,1, 'BF-BAZ', 'BF-07' UNION ALL 
        SELECT 820, 'Boucle du Mouhoun',36,0,NULL,1, 'BF-01', NULL UNION ALL 
        SELECT 821, 'Bougouriba',36,0,NULL,1, 'BF-BGR', 'BF-13' UNION ALL 
        SELECT 822, 'Boulgou',36,0,NULL,1, 'BF-BLG', 'BF-04' UNION ALL 
        SELECT 823, 'Boulkiemdé',36,0,NULL,1, 'BF-BLK', 'BF-06' UNION ALL 
        SELECT 824, 'Cascades',36,0,NULL,1, 'BF-02', NULL UNION ALL 
        SELECT 825, 'Centre',36,0,NULL,1, 'BF-03', NULL UNION ALL 
        SELECT 826, 'Centre-Est',36,0,NULL,1, 'BF-04', NULL UNION ALL 
        SELECT 827, 'Centre-Nord',36,0,NULL,1, 'BF-05', NULL UNION ALL 
        SELECT 828, 'Centre-Ouest',36,0,NULL,1, 'BF-06', NULL UNION ALL 
        SELECT 829, 'Centre-Sud',36,0,NULL,1, 'BF-07', NULL UNION ALL 
        SELECT 830, 'Comoé',36,0,NULL,1, 'BF-COM', 'BF-02' UNION ALL 
        SELECT 831, 'Est',36,0,NULL,1, 'BF-08', NULL UNION ALL 
        SELECT 832, 'Ganzourgou',36,0,NULL,1, 'BF-GAN', 'BF-11' UNION ALL 
        SELECT 833, 'Gnagna',36,0,NULL,1, 'BF-GNA', 'BF-08' UNION ALL 
        SELECT 834, 'Gourma',36,0,NULL,1, 'BF-GOU', 'BF-08' UNION ALL 
        SELECT 835, 'Hauts-Bassins',36,0,NULL,1, 'BF-09', NULL UNION ALL 
        SELECT 836, 'Houet',36,0,NULL,1, 'BF-HOU', 'BF-09' UNION ALL 
        SELECT 837, 'Ioba',36,0,NULL,1, 'BF-IOB', 'BF-13' UNION ALL 
        SELECT 838, 'Kadiogo',36,0,NULL,1, 'BF-KAD', 'BF-03' UNION ALL 
        SELECT 839, 'Komondjari',36,0,NULL,1, 'BF-KMD', 'BF-08' UNION ALL 
        SELECT 840, 'Kompienga',36,0,NULL,1, 'BF-KMP', 'BF-08' UNION ALL 
        SELECT 841, 'Kossi',36,0,NULL,1, 'BF-KOS', 'BF-01' UNION ALL 
        SELECT 842, 'Koulpélogo',36,0,NULL,1, 'BF-KOP', 'BF-04' UNION ALL 
        SELECT 843, 'Kouritenga',36,0,NULL,1, 'BF-KOT', 'BF-04' UNION ALL 
        SELECT 844, 'Kourwéogo',36,0,NULL,1, 'BF-KOW', 'BF-11' UNION ALL 
        SELECT 845, 'Kénédougou',36,0,NULL,1, 'BF-KEN', 'BF-09' UNION ALL 
        SELECT 846, 'Loroum',36,0,NULL,1, 'BF-LOR', 'BF-10' UNION ALL 
        SELECT 847, 'Léraba',36,0,NULL,1, 'BF-LER', 'BF-02' UNION ALL 
        SELECT 848, 'Mouhoun',36,0,NULL,1, 'BF-MOU', 'BF-01' UNION ALL 
        SELECT 849, 'Nahouri',36,0,NULL,1, 'BF-NAO', 'BF-07' UNION ALL 
        SELECT 850, 'Namentenga',36,0,NULL,1, 'BF-NAM', 'BF-05' UNION ALL 
        SELECT 851, 'Nayala',36,0,NULL,1, 'BF-NAY', 'BF-01' UNION ALL 
        SELECT 852, 'Nord',36,0,NULL,1, 'BF-10', NULL UNION ALL 
        SELECT 853, 'Noumbiel',36,0,NULL,1, 'BF-NOU', 'BF-13' UNION ALL 
        SELECT 854, 'Oubritenga',36,0,NULL,1, 'BF-OUB', 'BF-11' UNION ALL 
        SELECT 855, 'Oudalan',36,0,NULL,1, 'BF-OUD', 'BF-12' UNION ALL 
        SELECT 856, 'Passoré',36,0,NULL,1, 'BF-PAS', 'BF-10' UNION ALL 
        SELECT 857, 'Plateau-Central',36,0,NULL,1, 'BF-11', NULL UNION ALL 
        SELECT 858, 'Poni',36,0,NULL,1, 'BF-PON', 'BF-13' UNION ALL 
        SELECT 859, 'Sahel',36,0,NULL,1, 'BF-12', NULL UNION ALL 
        SELECT 860, 'Sanguié',36,0,NULL,1, 'BF-SNG', 'BF-06' UNION ALL 
        SELECT 861, 'Sanmatenga',36,0,NULL,1, 'BF-SMT', 'BF-05' UNION ALL 
        SELECT 862, 'Sissili',36,0,NULL,1, 'BF-SIS', 'BF-06' UNION ALL 
        SELECT 863, 'Soum',36,0,NULL,1, 'BF-SOM', 'BF-12' UNION ALL 
        SELECT 864, 'Sourou',36,0,NULL,1, 'BF-SOR', 'BF-01' UNION ALL 
        SELECT 865, 'Sud-Ouest',36,0,NULL,1, 'BF-13', NULL UNION ALL 
        SELECT 866, 'Séno',36,0,NULL,1, 'BF-SEN', 'BF-12' UNION ALL 
        SELECT 867, 'Tapoa',36,0,NULL,1, 'BF-TAP', 'BF-08' UNION ALL 
        SELECT 868, 'Tuy',36,0,NULL,1, 'BF-TUI', 'BF-09' UNION ALL 
        SELECT 869, 'Yagha',36,0,NULL,1, 'BF-YAG', 'BF-12' UNION ALL 
        SELECT 870, 'Yatenga',36,0,NULL,1, 'BF-YAT', 'BF-10' UNION ALL 
        SELECT 871, 'Ziro',36,0,NULL,1, 'BF-ZIR', 'BF-06' UNION ALL 
        SELECT 872, 'Zondoma',36,0,NULL,1, 'BF-ZON', 'BF-10' UNION ALL 
        SELECT 873, 'Zoundwéogo',36,0,NULL,1, 'BF-ZOU', 'BF-07' UNION ALL 
        SELECT 874, 'Boa Vista',41,0,NULL,1, 'CV-BV', 'CV-B' UNION ALL 
        SELECT 875, 'Brava',41,0,NULL,1, 'CV-BR', 'CV-S' UNION ALL 
        SELECT 876, 'Ilhas de Barlavento',41,0,NULL,1, 'CV-B', NULL UNION ALL 
        SELECT 877, 'Ilhas de Sotavento',41,0,NULL,1, 'CV-S', NULL UNION ALL 
        SELECT 878, 'Maio',41,0,NULL,1, 'CV-MA', 'CV-S' UNION ALL 
        SELECT 879, 'Mosteiros',41,0,NULL,1, 'CV-MO', 'CV-S' UNION ALL 
        SELECT 880, 'Paul',41,0,NULL,1, 'CV-PA', 'CV-B' UNION ALL 
        SELECT 881, 'Porto Novo',41,0,NULL,1, 'CV-PN', 'CV-B' UNION ALL 
        SELECT 882, 'Praia',41,0,NULL,1, 'CV-PR', 'CV-S' UNION ALL 
        SELECT 883, 'Ribeira Brava',41,0,NULL,1, 'CV-RB', 'CV-B' UNION ALL 
        SELECT 884, 'Ribeira Grande',41,0,NULL,1, 'CV-RG', 'CV-B' UNION ALL 
        SELECT 885, 'Ribeira Grande de Santiago',41,0,NULL,1, 'CV-RS', 'CV-S' UNION ALL 
        SELECT 886, 'Sal',41,0,NULL,1, 'CV-SL', 'CV-B' UNION ALL 
        SELECT 887, 'Santa Catarina',41,0,NULL,1, 'CV-CA', 'CV-S' UNION ALL 
        SELECT 888, 'Santa Catarina do Fogo',41,0,NULL,1, 'CV-CF', 'CV-S' UNION ALL 
        SELECT 889, 'Santa Cruz',41,0,NULL,1, 'CV-CR', 'CV-S' UNION ALL 
        SELECT 890, 'São Domingos',41,0,NULL,1, 'CV-SD', 'CV-S' UNION ALL 
        SELECT 891, 'São Filipe',41,0,NULL,1, 'CV-SF', 'CV-S' UNION ALL 
        SELECT 892, 'São Lourenço dos Órgãos',41,0,NULL,1, 'CV-SO', 'CV-S' UNION ALL 
        SELECT 893, 'São Miguel',41,0,NULL,1, 'CV-SM', 'CV-S' UNION ALL 
        SELECT 894, 'São Salvador do Mundo',41,0,NULL,1, 'CV-SS', 'CV-S' UNION ALL 
        SELECT 895, 'São Vicente',41,0,NULL,1, 'CV-SV', 'CV-B' UNION ALL 
        SELECT 896, 'Tarrafal',41,0,NULL,1, 'CV-TA', 'CV-S' UNION ALL 
        SELECT 897, 'Tarrafal de São Nicolau',41,0,NULL,1, 'CV-TS', 'CV-B' UNION ALL 
        SELECT 898, 'Aisén del General Carlos Ibañez del Campo',45,0,NULL,1, 'CL-AI', NULL UNION ALL 
        SELECT 899, 'Antofagasta',45,0,NULL,1, 'CL-AN', NULL UNION ALL 
        SELECT 900, 'Arica y Parinacota',45,0,NULL,1, 'CL-AP', NULL UNION ALL 
        SELECT 901, 'Atacama',45,0,NULL,1, 'CL-AT', NULL UNION ALL 
        SELECT 902, 'Biobío',45,0,NULL,1, 'CL-BI', NULL UNION ALL 
        SELECT 903, 'Coquimbo',45,0,NULL,1, 'CL-CO', NULL UNION ALL 
        SELECT 904, 'La Araucanía',45,0,NULL,1, 'CL-AR', NULL UNION ALL 
        SELECT 905, 'Libertador General Bernardo O''Higgins',45,0,NULL,1, 'CL-LI', NULL UNION ALL 
        SELECT 906, 'Los Lagos',45,0,NULL,1, 'CL-LL', NULL UNION ALL 
        SELECT 907, 'Los Ríos',45,0,NULL,1, 'CL-LR', NULL UNION ALL 
        SELECT 908, 'Magallanes',45,0,NULL,1, 'CL-MA', NULL UNION ALL 
        SELECT 909, 'Maule',45,0,NULL,1, 'CL-ML', NULL UNION ALL 
        SELECT 910, 'Región Metropolitana de Santiago',45,0,NULL,1, 'CL-RM', NULL UNION ALL 
        SELECT 911, 'Tarapacá',45,0,NULL,1, 'CL-TA', NULL UNION ALL 
        SELECT 912, 'Valparaíso',45,0,NULL,1, 'CL-VS', NULL UNION ALL 
        SELECT 913, 'Ñuble',45,0,NULL,1, 'CL-NB', NULL UNION ALL 
        SELECT 914, 'Amazonas',49,0,NULL,1, 'CO-AMA', NULL UNION ALL 
        SELECT 915, 'Antioquia',49,0,NULL,1, 'CO-ANT', NULL UNION ALL 
        SELECT 916, 'Arauca',49,0,NULL,1, 'CO-ARA', NULL UNION ALL 
        SELECT 917, 'Atlántico',49,0,NULL,1, 'CO-ATL', NULL UNION ALL 
        SELECT 918, 'Bolívar',49,0,NULL,1, 'CO-BOL', NULL UNION ALL 
        SELECT 919, 'Boyacá',49,0,NULL,1, 'CO-BOY', NULL UNION ALL 
        SELECT 920, 'Caldas',49,0,NULL,1, 'CO-CAL', NULL UNION ALL 
        SELECT 921, 'Caquetá',49,0,NULL,1, 'CO-CAQ', NULL UNION ALL 
        SELECT 922, 'Casanare',49,0,NULL,1, 'CO-CAS', NULL UNION ALL 
        SELECT 923, 'Cauca',49,0,NULL,1, 'CO-CAU', NULL UNION ALL 
        SELECT 924, 'Cesar',49,0,NULL,1, 'CO-CES', NULL UNION ALL 
        SELECT 925, 'Chocó',49,0,NULL,1, 'CO-CHO', NULL UNION ALL 
        SELECT 926, 'Cundinamarca',49,0,NULL,1, 'CO-CUN', NULL UNION ALL 
        SELECT 927, 'Córdoba',49,0,NULL,1, 'CO-COR', NULL UNION ALL 
        SELECT 928, 'Distrito Capital de Bogotá',49,0,NULL,1, 'CO-DC', NULL UNION ALL 
        SELECT 929, 'Guainía',49,0,NULL,1, 'CO-GUA', NULL UNION ALL 
        SELECT 930, 'Guaviare',49,0,NULL,1, 'CO-GUV', NULL UNION ALL 
        SELECT 931, 'Huila',49,0,NULL,1, 'CO-HUI', NULL UNION ALL 
        SELECT 932, 'La Guajira',49,0,NULL,1, 'CO-LAG', NULL UNION ALL 
        SELECT 933, 'Magdalena',49,0,NULL,1, 'CO-MAG', NULL UNION ALL 
        SELECT 934, 'Meta',49,0,NULL,1, 'CO-MET', NULL UNION ALL 
        SELECT 935, 'Nariño',49,0,NULL,1, 'CO-NAR', NULL UNION ALL 
        SELECT 936, 'Norte de Santander',49,0,NULL,1, 'CO-NSA', NULL UNION ALL 
        SELECT 937, 'Putumayo',49,0,NULL,1, 'CO-PUT', NULL UNION ALL 
        SELECT 938, 'Quindío',49,0,NULL,1, 'CO-QUI', NULL UNION ALL 
        SELECT 939, 'Risaralda',49,0,NULL,1, 'CO-RIS', NULL UNION ALL 
        SELECT 940, 'San Andrés, Providencia y Santa Catalina',49,0,NULL,1, 'CO-SAP', NULL UNION ALL 
        SELECT 941, 'Santander',49,0,NULL,1, 'CO-SAN', NULL UNION ALL 
        SELECT 942, 'Sucre',49,0,NULL,1, 'CO-SUC', NULL UNION ALL 
        SELECT 943, 'Tolima',49,0,NULL,1, 'CO-TOL', NULL UNION ALL 
        SELECT 944, 'Valle del Cauca',49,0,NULL,1, 'CO-VAC', NULL UNION ALL 
        SELECT 945, 'Vaupés',49,0,NULL,1, 'CO-VAU', NULL UNION ALL 
        SELECT 946, 'Vichada',49,0,NULL,1, 'CO-VID', NULL UNION ALL 
        SELECT 947, 'Bouenza',51,0,NULL,1, 'CG-11', NULL UNION ALL 
        SELECT 948, 'Brazzaville',51,0,NULL,1, 'CG-BZV', NULL UNION ALL 
        SELECT 949, 'Cuvette',51,0,NULL,1, 'CG-8', NULL UNION ALL 
        SELECT 950, 'Cuvette-Ouest',51,0,NULL,1, 'CG-15', NULL UNION ALL 
        SELECT 951, 'Kouilou',51,0,NULL,1, 'CG-5', NULL UNION ALL 
        SELECT 952, 'Likouala',51,0,NULL,1, 'CG-7', NULL UNION ALL 
        SELECT 953, 'Lékoumou',51,0,NULL,1, 'CG-2', NULL UNION ALL 
        SELECT 954, 'Niari',51,0,NULL,1, 'CG-9', NULL UNION ALL 
        SELECT 955, 'Plateaux',51,0,NULL,1, 'CG-14', NULL UNION ALL 
        SELECT 956, 'Pointe-Noire',51,0,NULL,1, 'CG-16', NULL UNION ALL 
        SELECT 957, 'Pool',51,0,NULL,1, 'CG-12', NULL UNION ALL 
        SELECT 958, 'Sangha',51,0,NULL,1, 'CG-13', NULL UNION ALL 
        SELECT 959, 'Alajuela',53,0,NULL,1, 'CR-A', NULL UNION ALL 
        SELECT 960, 'Cartago',53,0,NULL,1, 'CR-C', NULL UNION ALL 
        SELECT 961, 'Guanacaste',53,0,NULL,1, 'CR-G', NULL UNION ALL 
        SELECT 962, 'Heredia',53,0,NULL,1, 'CR-H', NULL UNION ALL 
        SELECT 963, 'Limón',53,0,NULL,1, 'CR-L', NULL UNION ALL 
        SELECT 964, 'Puntarenas',53,0,NULL,1, 'CR-P', NULL UNION ALL 
        SELECT 965, 'San José',53,0,NULL,1, 'CR-SJ', NULL UNION ALL 
        SELECT 966, 'Abidjan',54,0,NULL,1, 'CI-AB', NULL UNION ALL 
        SELECT 967, 'Bas-Sassandra',54,0,NULL,1, 'CI-BS', NULL UNION ALL 
        SELECT 968, 'Comoé',54,0,NULL,1, 'CI-CM', NULL UNION ALL 
        SELECT 969, 'Denguélé',54,0,NULL,1, 'CI-DN', NULL UNION ALL 
        SELECT 970, 'Gôh-Djiboua',54,0,NULL,1, 'CI-GD', NULL UNION ALL 
        SELECT 971, 'Lacs',54,0,NULL,1, 'CI-LC', NULL UNION ALL 
        SELECT 972, 'Lagunes',54,0,NULL,1, 'CI-LG', NULL UNION ALL 
        SELECT 973, 'Montagnes',54,0,NULL,1, 'CI-MG', NULL UNION ALL 
        SELECT 974, 'Sassandra-Marahoué',54,0,NULL,1, 'CI-SM', NULL UNION ALL 
        SELECT 975, 'Savanes',54,0,NULL,1, 'CI-SV', NULL UNION ALL 
        SELECT 976, 'Vallée du Bandama',54,0,NULL,1, 'CI-VB', NULL UNION ALL 
        SELECT 977, 'Woroba',54,0,NULL,1, 'CI-WR', NULL UNION ALL 
        SELECT 978, 'Yamoussoukro',54,0,NULL,1, 'CI-YM', NULL UNION ALL 
        SELECT 979, 'Zanzan',54,0,NULL,1, 'CI-ZZ', NULL UNION ALL 
        SELECT 980, 'Bjelovarsko-bilogorska županija',55,0,NULL,1, 'HR-07', NULL UNION ALL 
        SELECT 981, 'Brodsko-posavska županija',55,0,NULL,1, 'HR-12', NULL UNION ALL 
        SELECT 982, 'Dubrovacko-neretvanska županija',55,0,NULL,1, 'HR-19', NULL UNION ALL 
        SELECT 983, 'Grad Zagreb',55,0,NULL,1, 'HR-21', NULL UNION ALL 
        SELECT 984, 'Istarska županija',55,0,NULL,1, 'HR-18', NULL UNION ALL 
        SELECT 985, 'Karlovacka županija',55,0,NULL,1, 'HR-04', NULL UNION ALL 
        SELECT 986, 'Koprivnicko-križevacka županija',55,0,NULL,1, 'HR-06', NULL UNION ALL 
        SELECT 987, 'Krapinsko-zagorska županija',55,0,NULL,1, 'HR-02', NULL UNION ALL 
        SELECT 988, 'Licko-senjska županija',55,0,NULL,1, 'HR-09', NULL UNION ALL 
        SELECT 989, 'Medimurska županija',55,0,NULL,1, 'HR-20', NULL UNION ALL 
        SELECT 990, 'Osjecko-baranjska županija',55,0,NULL,1, 'HR-14', NULL UNION ALL 
        SELECT 991, 'Požeško-slavonska županija',55,0,NULL,1, 'HR-11', NULL UNION ALL 
        SELECT 992, 'Primorsko-goranska županija',55,0,NULL,1, 'HR-08', NULL UNION ALL 
        SELECT 993, 'Sisacko-moslavacka županija',55,0,NULL,1, 'HR-03', NULL UNION ALL 
        SELECT 994, 'Splitsko-dalmatinska županija',55,0,NULL,1, 'HR-17', NULL UNION ALL 
        SELECT 995, 'Varaždinska županija',55,0,NULL,1, 'HR-05', NULL UNION ALL 
        SELECT 996, 'Viroviticko-podravska županija',55,0,NULL,1, 'HR-10', NULL UNION ALL 
        SELECT 997, 'Vukovarsko-srijemska županija',55,0,NULL,1, 'HR-16', NULL UNION ALL 
        SELECT 998, 'Zadarska županija',55,0,NULL,1, 'HR-13', NULL UNION ALL 
        SELECT 999, 'Zagrebacka županija',55,0,NULL,1, 'HR-01', NULL UNION ALL 
        SELECT 1000, 'Šibensko-kninska županija',55,0,NULL,1, 'HR-15', NULL UNION ALL 
        SELECT 1001, 'Artemisa',56,0,NULL,1, 'CU-15', NULL UNION ALL 
        SELECT 1002, 'Camagüey',56,0,NULL,1, 'CU-09', NULL UNION ALL 
        SELECT 1003, 'Ciego de Ávila',56,0,NULL,1, 'CU-08', NULL UNION ALL 
        SELECT 1004, 'Cienfuegos',56,0,NULL,1, 'CU-06', NULL UNION ALL 
        SELECT 1005, 'Granma',56,0,NULL,1, 'CU-12', NULL UNION ALL 
        SELECT 1006, 'Guantánamo',56,0,NULL,1, 'CU-14', NULL UNION ALL 
        SELECT 1007, 'Holguín',56,0,NULL,1, 'CU-11', NULL UNION ALL 
        SELECT 1008, 'Isla de la Juventud',56,0,NULL,1, 'CU-99', NULL UNION ALL 
        SELECT 1009, 'La Habana',56,0,NULL,1, 'CU-03', NULL UNION ALL 
        SELECT 1010, 'Las Tunas',56,0,NULL,1, 'CU-10', NULL UNION ALL 
        SELECT 1011, 'Matanzas',56,0,NULL,1, 'CU-04', NULL UNION ALL 
        SELECT 1012, 'Mayabeque',56,0,NULL,1, 'CU-16', NULL UNION ALL 
        SELECT 1013, 'Pinar del Río',56,0,NULL,1, 'CU-01', NULL UNION ALL 
        SELECT 1014, 'Sancti Spíritus',56,0,NULL,1, 'CU-07', NULL UNION ALL 
        SELECT 1015, 'Santiago de Cuba',56,0,NULL,1, 'CU-13', NULL UNION ALL 
        SELECT 1016, 'Villa Clara',56,0,NULL,1, 'CU-05', NULL UNION ALL 
        SELECT 1017, 'Benešov',58,0,NULL,1, 'CZ-201', 'CZ-20' UNION ALL 
        SELECT 1018, 'Beroun',58,0,NULL,1, 'CZ-202', 'CZ-20' UNION ALL 
        SELECT 1019, 'Blansko',58,0,NULL,1, 'CZ-641', 'CZ-64' UNION ALL 
        SELECT 1020, 'Brno-mesto',58,0,NULL,1, 'CZ-642', 'CZ-64' UNION ALL 
        SELECT 1021, 'Brno-venkov',58,0,NULL,1, 'CZ-643', 'CZ-64' UNION ALL 
        SELECT 1022, 'Bruntál',58,0,NULL,1, 'CZ-801', 'CZ-80' UNION ALL 
        SELECT 1023, 'Breclav',58,0,NULL,1, 'CZ-644', 'CZ-64' UNION ALL 
        SELECT 1024, 'Cheb',58,0,NULL,1, 'CZ-411', 'CZ-41' UNION ALL 
        SELECT 1025, 'Chomutov',58,0,NULL,1, 'CZ-422', 'CZ-42' UNION ALL 
        SELECT 1026, 'Chrudim',58,0,NULL,1, 'CZ-531', 'CZ-53' UNION ALL 
        SELECT 1027, 'Domažlice',58,0,NULL,1, 'CZ-321', 'CZ-32' UNION ALL 
        SELECT 1028, 'Decín',58,0,NULL,1, 'CZ-421', 'CZ-42' UNION ALL 
        SELECT 1029, 'Frýdek-Místek',58,0,NULL,1, 'CZ-802', 'CZ-80' UNION ALL 
        SELECT 1030, 'Havlíckuv Brod',58,0,NULL,1, 'CZ-631', 'CZ-63' UNION ALL 
        SELECT 1031, 'Hodonín',58,0,NULL,1, 'CZ-645', 'CZ-64' UNION ALL 
        SELECT 1032, 'Hradec Králové',58,0,NULL,1, 'CZ-521', 'CZ-52' UNION ALL 
        SELECT 1033, 'Jablonec nad Nisou',58,0,NULL,1, 'CZ-512', 'CZ-51' UNION ALL 
        SELECT 1034, 'Jeseník',58,0,NULL,1, 'CZ-711', 'CZ-71' UNION ALL 
        SELECT 1035, 'Jihlava',58,0,NULL,1, 'CZ-632', 'CZ-63' UNION ALL 
        SELECT 1036, 'Jihomoravský kraj',58,0,NULL,1, 'CZ-64', NULL UNION ALL 
        SELECT 1037, 'Jihoceský kraj',58,0,NULL,1, 'CZ-31', NULL UNION ALL 
        SELECT 1038, 'Jindrichuv Hradec',58,0,NULL,1, 'CZ-313', 'CZ-31' UNION ALL 
        SELECT 1039, 'Jicín',58,0,NULL,1, 'CZ-522', 'CZ-52' UNION ALL 
        SELECT 1040, 'Karlovarský kraj',58,0,NULL,1, 'CZ-41', NULL UNION ALL 
        SELECT 1041, 'Karlovy Vary',58,0,NULL,1, 'CZ-412', 'CZ-41' UNION ALL 
        SELECT 1042, 'Karviná',58,0,NULL,1, 'CZ-803', 'CZ-80' UNION ALL 
        SELECT 1043, 'Kladno',58,0,NULL,1, 'CZ-203', 'CZ-20' UNION ALL 
        SELECT 1044, 'Klatovy',58,0,NULL,1, 'CZ-322', 'CZ-32' UNION ALL 
        SELECT 1045, 'Kolín',58,0,NULL,1, 'CZ-204', 'CZ-20' UNION ALL 
        SELECT 1046, 'Kraj Vysocina',58,0,NULL,1, 'CZ-63', NULL UNION ALL 
        SELECT 1047, 'Kromeríž',58,0,NULL,1, 'CZ-721', 'CZ-72' UNION ALL 
        SELECT 1048, 'Královéhradecký kraj',58,0,NULL,1, 'CZ-52', NULL UNION ALL 
        SELECT 1049, 'Kutná Hora',58,0,NULL,1, 'CZ-205', 'CZ-20' UNION ALL 
        SELECT 1050, 'Liberec',58,0,NULL,1, 'CZ-513', 'CZ-51' UNION ALL 
        SELECT 1051, 'Liberecký kraj',58,0,NULL,1, 'CZ-51', NULL UNION ALL 
        SELECT 1052, 'Litomerice',58,0,NULL,1, 'CZ-423', 'CZ-42' UNION ALL 
        SELECT 1053, 'Louny',58,0,NULL,1, 'CZ-424', 'CZ-42' UNION ALL 
        SELECT 1054, 'Mladá Boleslav',58,0,NULL,1, 'CZ-207', 'CZ-20' UNION ALL 
        SELECT 1055, 'Moravskoslezský kraj',58,0,NULL,1, 'CZ-80', NULL UNION ALL 
        SELECT 1056, 'Most',58,0,NULL,1, 'CZ-425', 'CZ-42' UNION ALL 
        SELECT 1057, 'Melník',58,0,NULL,1, 'CZ-206', 'CZ-20' UNION ALL 
        SELECT 1058, 'Nový Jicín',58,0,NULL,1, 'CZ-804', 'CZ-80' UNION ALL 
        SELECT 1059, 'Nymburk',58,0,NULL,1, 'CZ-208', 'CZ-20' UNION ALL 
        SELECT 1060, 'Náchod',58,0,NULL,1, 'CZ-523', 'CZ-52' UNION ALL 
        SELECT 1061, 'Olomouc',58,0,NULL,1, 'CZ-712', 'CZ-71' UNION ALL 
        SELECT 1062, 'Olomoucký kraj',58,0,NULL,1, 'CZ-71', NULL UNION ALL 
        SELECT 1063, 'Opava',58,0,NULL,1, 'CZ-805', 'CZ-80' UNION ALL 
        SELECT 1064, 'Ostrava-mesto',58,0,NULL,1, 'CZ-806', 'CZ-80' UNION ALL 
        SELECT 1065, 'Pardubice',58,0,NULL,1, 'CZ-532', 'CZ-53' UNION ALL 
        SELECT 1066, 'Pardubický kraj',58,0,NULL,1, 'CZ-53', NULL UNION ALL 
        SELECT 1067, 'Pelhrimov',58,0,NULL,1, 'CZ-633', 'CZ-63' UNION ALL 
        SELECT 1068, 'Plzen-jih',58,0,NULL,1, 'CZ-324', 'CZ-32' UNION ALL 
        SELECT 1069, 'Plzen-mesto',58,0,NULL,1, 'CZ-323', 'CZ-32' UNION ALL 
        SELECT 1070, 'Plzen-sever',58,0,NULL,1, 'CZ-325', 'CZ-32' UNION ALL 
        SELECT 1071, 'Plzenský kraj',58,0,NULL,1, 'CZ-32', NULL UNION ALL 
        SELECT 1072, 'Prachatice',58,0,NULL,1, 'CZ-315', 'CZ-31' UNION ALL 
        SELECT 1073, 'Praha, Hlavní mesto',58,0,NULL,1, 'CZ-10', NULL UNION ALL 
        SELECT 1074, 'Praha-východ',58,0,NULL,1, 'CZ-209', 'CZ-20' UNION ALL 
        SELECT 1075, 'Praha-západ',58,0,NULL,1, 'CZ-20A', 'CZ-20' UNION ALL 
        SELECT 1076, 'Prostejov',58,0,NULL,1, 'CZ-713', 'CZ-71' UNION ALL 
        SELECT 1077, 'Písek',58,0,NULL,1, 'CZ-314', 'CZ-31' UNION ALL 
        SELECT 1078, 'Prerov',58,0,NULL,1, 'CZ-714', 'CZ-71' UNION ALL 
        SELECT 1079, 'Príbram',58,0,NULL,1, 'CZ-20B', 'CZ-20' UNION ALL 
        SELECT 1080, 'Rakovník',58,0,NULL,1, 'CZ-20C', 'CZ-20' UNION ALL 
        SELECT 1081, 'Rokycany',58,0,NULL,1, 'CZ-326', 'CZ-32' UNION ALL 
        SELECT 1082, 'Rychnov nad Knežnou',58,0,NULL,1, 'CZ-524', 'CZ-52' UNION ALL 
        SELECT 1083, 'Semily',58,0,NULL,1, 'CZ-514', 'CZ-51' UNION ALL 
        SELECT 1084, 'Sokolov',58,0,NULL,1, 'CZ-413', 'CZ-41' UNION ALL 
        SELECT 1085, 'Strakonice',58,0,NULL,1, 'CZ-316', 'CZ-31' UNION ALL 
        SELECT 1086, 'Stredoceský kraj',58,0,NULL,1, 'CZ-20', NULL UNION ALL 
        SELECT 1087, 'Svitavy',58,0,NULL,1, 'CZ-533', 'CZ-53' UNION ALL 
        SELECT 1088, 'Tachov',58,0,NULL,1, 'CZ-327', 'CZ-32' UNION ALL 
        SELECT 1089, 'Teplice',58,0,NULL,1, 'CZ-426', 'CZ-42' UNION ALL 
        SELECT 1090, 'Trutnov',58,0,NULL,1, 'CZ-525', 'CZ-52' UNION ALL 
        SELECT 1091, 'Tábor',58,0,NULL,1, 'CZ-317', 'CZ-31' UNION ALL 
        SELECT 1092, 'Trebíc',58,0,NULL,1, 'CZ-634', 'CZ-63' UNION ALL 
        SELECT 1093, 'Uherské Hradište',58,0,NULL,1, 'CZ-722', 'CZ-72' UNION ALL 
        SELECT 1094, 'Vsetín',58,0,NULL,1, 'CZ-723', 'CZ-72' UNION ALL 
        SELECT 1095, 'Vyškov',58,0,NULL,1, 'CZ-646', 'CZ-64' UNION ALL 
        SELECT 1096, 'Zlín',58,0,NULL,1, 'CZ-724', 'CZ-72' UNION ALL 
        SELECT 1097, 'Zlínský kraj',58,0,NULL,1, 'CZ-72', NULL UNION ALL 
        SELECT 1098, 'Znojmo',58,0,NULL,1, 'CZ-647', 'CZ-64' UNION ALL 
        SELECT 1099, 'Ústecký kraj',58,0,NULL,1, 'CZ-42', NULL UNION ALL 
        SELECT 1100, 'Ústí nad Labem',58,0,NULL,1, 'CZ-427', 'CZ-42' UNION ALL 
        SELECT 1101, 'Ústí nad Orlicí',58,0,NULL,1, 'CZ-534', 'CZ-53' UNION ALL 
        SELECT 1102, 'Ceská Lípa',58,0,NULL,1, 'CZ-511', 'CZ-51' UNION ALL 
        SELECT 1103, 'Ceské Budejovice',58,0,NULL,1, 'CZ-311', 'CZ-31' UNION ALL 
        SELECT 1104, 'Ceský Krumlov',58,0,NULL,1, 'CZ-312', 'CZ-31' UNION ALL 
        SELECT 1105, 'Šumperk',58,0,NULL,1, 'CZ-715', 'CZ-71' UNION ALL 
        SELECT 1106, 'Ždár nad Sázavou',58,0,NULL,1, 'CZ-635', 'CZ-63' UNION ALL 
        SELECT 1107, 'Hovedstaden',59,0,NULL,1, 'DK-84', NULL UNION ALL 
        SELECT 1108, 'Midtjylland',59,0,NULL,1, 'DK-82', NULL UNION ALL 
        SELECT 1109, 'Nordjylland',59,0,NULL,1, 'DK-81', NULL UNION ALL 
        SELECT 1110, 'Sjælland',59,0,NULL,1, 'DK-85', NULL UNION ALL 
        SELECT 1111, 'Syddanmark',59,0,NULL,1, 'DK-83', NULL UNION ALL 
        SELECT 1112, 'Saint Andrew',61,0,NULL,1, 'DM-02', NULL UNION ALL 
        SELECT 1113, 'Saint David',61,0,NULL,1, 'DM-03', NULL UNION ALL 
        SELECT 1114, 'Saint George',61,0,NULL,1, 'DM-04', NULL UNION ALL 
        SELECT 1115, 'Saint John',61,0,NULL,1, 'DM-05', NULL UNION ALL 
        SELECT 1116, 'Saint Joseph',61,0,NULL,1, 'DM-06', NULL UNION ALL 
        SELECT 1117, 'Saint Luke',61,0,NULL,1, 'DM-07', NULL UNION ALL 
        SELECT 1118, 'Saint Mark',61,0,NULL,1, 'DM-08', NULL UNION ALL 
        SELECT 1119, 'Saint Patrick',61,0,NULL,1, 'DM-09', NULL UNION ALL 
        SELECT 1120, 'Saint Paul',61,0,NULL,1, 'DM-10', NULL UNION ALL 
        SELECT 1121, 'Saint Peter',61,0,NULL,1, 'DM-11', NULL UNION ALL 
        SELECT 1122, 'Azua',62,0,NULL,1, 'DO-02', 'DO-41' UNION ALL 
        SELECT 1123, 'Baoruco',62,0,NULL,1, 'DO-03', 'DO-38' UNION ALL 
        SELECT 1124, 'Barahona',62,0,NULL,1, 'DO-04', 'DO-38' UNION ALL 
        SELECT 1125, 'Cibao Nordeste',62,0,NULL,1, 'DO-33', NULL UNION ALL 
        SELECT 1126, 'Cibao Noroeste',62,0,NULL,1, 'DO-34', NULL UNION ALL 
        SELECT 1127, 'Cibao Norte',62,0,NULL,1, 'DO-35', NULL UNION ALL 
        SELECT 1128, 'Cibao Sur',62,0,NULL,1, 'DO-36', NULL UNION ALL 
        SELECT 1129, 'Dajabón',62,0,NULL,1, 'DO-05', 'DO-34' UNION ALL 
        SELECT 1130, 'Distrito Nacional (Santo Domingo)',62,0,NULL,1, 'DO-01', 'DO-40' UNION ALL 
        SELECT 1131, 'Duarte',62,0,NULL,1, 'DO-06', 'DO-33' UNION ALL 
        SELECT 1132, 'El Seibo',62,0,NULL,1, 'DO-08', 'DO-42' UNION ALL 
        SELECT 1133, 'El Valle',62,0,NULL,1, 'DO-37', NULL UNION ALL 
        SELECT 1134, 'Elías Piña',62,0,NULL,1, 'DO-07', 'DO-37' UNION ALL 
        SELECT 1135, 'Enriquillo',62,0,NULL,1, 'DO-38', NULL UNION ALL 
        SELECT 1136, 'Espaillat',62,0,NULL,1, 'DO-09', 'DO-35' UNION ALL 
        SELECT 1137, 'Hato Mayor',62,0,NULL,1, 'DO-30', 'DO-39' UNION ALL 
        SELECT 1138, 'Hermanas Mirabal',62,0,NULL,1, 'DO-19', 'DO-33' UNION ALL 
        SELECT 1139, 'Higuamo',62,0,NULL,1, 'DO-39', NULL UNION ALL 
        SELECT 1140, 'Independencia',62,0,NULL,1, 'DO-10', 'DO-38' UNION ALL 
        SELECT 1141, 'La Altagracia',62,0,NULL,1, 'DO-11', 'DO-42' UNION ALL 
        SELECT 1142, 'La Romana',62,0,NULL,1, 'DO-12', 'DO-42' UNION ALL 
        SELECT 1143, 'La Vega',62,0,NULL,1, 'DO-13', 'DO-36' UNION ALL 
        SELECT 1144, 'María Trinidad Sánchez',62,0,NULL,1, 'DO-14', 'DO-33' UNION ALL 
        SELECT 1145, 'Monseñor Nouel',62,0,NULL,1, 'DO-28', 'DO-36' UNION ALL 
        SELECT 1146, 'Monte Cristi',62,0,NULL,1, 'DO-15', 'DO-34' UNION ALL 
        SELECT 1147, 'Monte Plata',62,0,NULL,1, 'DO-29', 'DO-39' UNION ALL 
        SELECT 1148, 'Ozama',62,0,NULL,1, 'DO-40', NULL UNION ALL 
        SELECT 1149, 'Pedernales',62,0,NULL,1, 'DO-16', 'DO-38' UNION ALL 
        SELECT 1150, 'Peravia',62,0,NULL,1, 'DO-17', 'DO-41' UNION ALL 
        SELECT 1151, 'Puerto Plata',62,0,NULL,1, 'DO-18', 'DO-35' UNION ALL 
        SELECT 1152, 'Samaná',62,0,NULL,1, 'DO-20', 'DO-33' UNION ALL 
        SELECT 1153, 'San Cristóbal',62,0,NULL,1, 'DO-21', 'DO-41' UNION ALL 
        SELECT 1154, 'San José de Ocoa',62,0,NULL,1, 'DO-31', 'DO-41' UNION ALL 
        SELECT 1155, 'San Juan',62,0,NULL,1, 'DO-22', 'DO-37' UNION ALL 
        SELECT 1156, 'San Pedro de Macorís',62,0,NULL,1, 'DO-23', 'DO-39' UNION ALL 
        SELECT 1157, 'Santiago',62,0,NULL,1, 'DO-25', 'DO-35' UNION ALL 
        SELECT 1158, 'Santiago Rodríguez',62,0,NULL,1, 'DO-26', 'DO-34' UNION ALL 
        SELECT 1159, 'Santo Domingo',62,0,NULL,1, 'DO-32', 'DO-40' UNION ALL 
        SELECT 1160, 'Sánchez Ramírez',62,0,NULL,1, 'DO-24', 'DO-36' UNION ALL 
        SELECT 1161, 'Valdesia',62,0,NULL,1, 'DO-41', NULL UNION ALL 
        SELECT 1162, 'Valverde',62,0,NULL,1, 'DO-27', 'DO-34' UNION ALL 
        SELECT 1163, 'Yuma',62,0,NULL,1, 'DO-42', NULL UNION ALL 
        SELECT 1164, 'Azuay',64,0,NULL,1, 'EC-A', NULL UNION ALL 
        SELECT 1165, 'Bolívar',64,0,NULL,1, 'EC-B', NULL UNION ALL 
        SELECT 1166, 'Carchi',64,0,NULL,1, 'EC-C', NULL UNION ALL 
        SELECT 1167, 'Cañar',64,0,NULL,1, 'EC-F', NULL UNION ALL 
        SELECT 1168, 'Chimborazo',64,0,NULL,1, 'EC-H', NULL UNION ALL 
        SELECT 1169, 'Cotopaxi',64,0,NULL,1, 'EC-X', NULL UNION ALL 
        SELECT 1170, 'El Oro',64,0,NULL,1, 'EC-O', NULL UNION ALL 
        SELECT 1171, 'Esmeraldas',64,0,NULL,1, 'EC-E', NULL UNION ALL 
        SELECT 1172, 'Galápagos',64,0,NULL,1, 'EC-W', NULL UNION ALL 
        SELECT 1173, 'Guayas',64,0,NULL,1, 'EC-G', NULL UNION ALL 
        SELECT 1174, 'Imbabura',64,0,NULL,1, 'EC-I', NULL UNION ALL 
        SELECT 1175, 'Loja',64,0,NULL,1, 'EC-L', NULL UNION ALL 
        SELECT 1176, 'Los Ríos',64,0,NULL,1, 'EC-R', NULL UNION ALL 
        SELECT 1177, 'Manabí',64,0,NULL,1, 'EC-M', NULL UNION ALL 
        SELECT 1178, 'Morona Santiago',64,0,NULL,1, 'EC-S', NULL UNION ALL 
        SELECT 1179, 'Napo',64,0,NULL,1, 'EC-N', NULL UNION ALL 
        SELECT 1180, 'Orellana',64,0,NULL,1, 'EC-D', NULL UNION ALL 
        SELECT 1181, 'Pastaza',64,0,NULL,1, 'EC-Y', NULL UNION ALL 
        SELECT 1182, 'Pichincha',64,0,NULL,1, 'EC-P', NULL UNION ALL 
        SELECT 1183, 'Santa Elena',64,0,NULL,1, 'EC-SE', NULL UNION ALL 
        SELECT 1184, 'Santo Domingo de los Tsáchilas',64,0,NULL,1, 'EC-SD', NULL UNION ALL 
        SELECT 1185, 'Sucumbíos',64,0,NULL,1, 'EC-U', NULL UNION ALL 
        SELECT 1186, 'Tungurahua',64,0,NULL,1, 'EC-T', NULL UNION ALL 
        SELECT 1187, 'Zamora Chinchipe',64,0,NULL,1, 'EC-Z', NULL UNION ALL 
        SELECT 1188, 'Ad Daqahliyah',65,0,NULL,1, 'EG-DK', NULL UNION ALL 
        SELECT 1189, 'Al Ba?r al A?mar',65,0,NULL,1, 'EG-BA', NULL UNION ALL 
        SELECT 1190, 'Al Bu?ayrah',65,0,NULL,1, 'EG-BH', NULL UNION ALL 
        SELECT 1191, 'Al Fayyum',65,0,NULL,1, 'EG-FYM', NULL UNION ALL 
        SELECT 1192, 'Al Gharbiyah',65,0,NULL,1, 'EG-GH', NULL UNION ALL 
        SELECT 1193, 'Al Iskandariyah',65,0,NULL,1, 'EG-ALX', NULL UNION ALL 
        SELECT 1194, 'Al Isma''iliyah',65,0,NULL,1, 'EG-IS', NULL UNION ALL 
        SELECT 1195, 'Al Jizah',65,0,NULL,1, 'EG-GZ', NULL UNION ALL 
        SELECT 1196, 'Al Minya',65,0,NULL,1, 'EG-MN', NULL UNION ALL 
        SELECT 1197, 'Al Minufiyah',65,0,NULL,1, 'EG-MNF', NULL UNION ALL 
        SELECT 1198, 'Al Qalyubiyah',65,0,NULL,1, 'EG-KB', NULL UNION ALL 
        SELECT 1199, 'Al Qahirah',65,0,NULL,1, 'EG-C', NULL UNION ALL 
        SELECT 1200, 'Al Uqsur',65,0,NULL,1, 'EG-LX', NULL UNION ALL 
        SELECT 1201, 'Al Wadi al Jadid',65,0,NULL,1, 'EG-WAD', NULL UNION ALL 
        SELECT 1202, 'As Suways',65,0,NULL,1, 'EG-SUZ', NULL UNION ALL 
        SELECT 1203, 'Ash Sharqiyah',65,0,NULL,1, 'EG-SHR', NULL UNION ALL 
        SELECT 1204, 'Aswan',65,0,NULL,1, 'EG-ASN', NULL UNION ALL 
        SELECT 1205, 'Asyut',65,0,NULL,1, 'EG-AST', NULL UNION ALL 
        SELECT 1206, 'Bani Suwayf',65,0,NULL,1, 'EG-BNS', NULL UNION ALL 
        SELECT 1207, 'Bur Sa‘id',65,0,NULL,1, 'EG-PTS', NULL UNION ALL 
        SELECT 1208, 'Dumyat',65,0,NULL,1, 'EG-DT', NULL UNION ALL 
        SELECT 1209, 'Janub Sina''',65,0,NULL,1, 'EG-JS', NULL UNION ALL 
        SELECT 1210, 'Kafr ash Shaykh',65,0,NULL,1, 'EG-KFS', NULL UNION ALL 
        SELECT 1211, 'Matru?',65,0,NULL,1, 'EG-MT', NULL UNION ALL 
        SELECT 1212, 'Qina',65,0,NULL,1, 'EG-KN', NULL UNION ALL 
        SELECT 1213, 'Shamal Sina''',65,0,NULL,1, 'EG-SIN', NULL UNION ALL 
        SELECT 1214, 'Suhaj',65,0,NULL,1, 'EG-SHG', NULL UNION ALL 
        SELECT 1215, 'Ahuachapán',66,0,NULL,1, 'SV-AH', NULL UNION ALL 
        SELECT 1216, 'Cabañas',66,0,NULL,1, 'SV-CA', NULL UNION ALL 
        SELECT 1217, 'Chalatenango',66,0,NULL,1, 'SV-CH', NULL UNION ALL 
        SELECT 1218, 'Cuscatlán',66,0,NULL,1, 'SV-CU', NULL UNION ALL 
        SELECT 1219, 'La Libertad',66,0,NULL,1, 'SV-LI', NULL UNION ALL 
        SELECT 1220, 'La Paz',66,0,NULL,1, 'SV-PA', NULL UNION ALL 
        SELECT 1221, 'La Unión',66,0,NULL,1, 'SV-UN', NULL UNION ALL 
        SELECT 1222, 'Morazán',66,0,NULL,1, 'SV-MO', NULL UNION ALL 
        SELECT 1223, 'San Miguel',66,0,NULL,1, 'SV-SM', NULL UNION ALL 
        SELECT 1224, 'San Salvador',66,0,NULL,1, 'SV-SS', NULL UNION ALL 
        SELECT 1225, 'San Vicente',66,0,NULL,1, 'SV-SV', NULL UNION ALL 
        SELECT 1226, 'Santa Ana',66,0,NULL,1, 'SV-SA', NULL UNION ALL 
        SELECT 1227, 'Sonsonate',66,0,NULL,1, 'SV-SO', NULL UNION ALL 
        SELECT 1228, 'Usulután',66,0,NULL,1, 'SV-US', NULL UNION ALL 
        SELECT 1229, 'Harjumaa',69,0,NULL,1, 'EE-37', NULL UNION ALL 
        SELECT 1230, 'Hiiumaa',69,0,NULL,1, 'EE-39', NULL UNION ALL 
        SELECT 1231, 'Ida-Virumaa',69,0,NULL,1, 'EE-44', NULL UNION ALL 
        SELECT 1232, 'Järvamaa',69,0,NULL,1, 'EE-51', NULL UNION ALL 
        SELECT 1233, 'Jõgevamaa',69,0,NULL,1, 'EE-49', NULL UNION ALL 
        SELECT 1234, 'Lääne-Virumaa',69,0,NULL,1, 'EE-59', NULL UNION ALL 
        SELECT 1235, 'Läänemaa',69,0,NULL,1, 'EE-57', NULL UNION ALL 
        SELECT 1236, 'Pärnumaa',69,0,NULL,1, 'EE-67', NULL UNION ALL 
        SELECT 1237, 'Põlvamaa',69,0,NULL,1, 'EE-65', NULL UNION ALL 
        SELECT 1238, 'Raplamaa',69,0,NULL,1, 'EE-70', NULL UNION ALL 
        SELECT 1239, 'Saaremaa',69,0,NULL,1, 'EE-74', NULL UNION ALL 
        SELECT 1240, 'Tartumaa',69,0,NULL,1, 'EE-78', NULL UNION ALL 
        SELECT 1241, 'Valgamaa',69,0,NULL,1, 'EE-82', NULL UNION ALL 
        SELECT 1242, 'Viljandimaa',69,0,NULL,1, 'EE-84', NULL UNION ALL 
        SELECT 1243, 'Võrumaa',69,0,NULL,1, 'EE-86', NULL UNION ALL 
        SELECT 1244, 'Ba',73,0,NULL,1, 'FJ-01', 'FJ-W' UNION ALL 
        SELECT 1245, 'Bua',73,0,NULL,1, 'FJ-02', 'FJ-N' UNION ALL 
        SELECT 1246, 'Cakaudrove',73,0,NULL,1, 'FJ-03', 'FJ-N' UNION ALL 
        SELECT 1247, 'Central',73,0,NULL,1, 'FJ-C', NULL UNION ALL 
        SELECT 1248, 'Eastern',73,0,NULL,1, 'FJ-E', NULL UNION ALL 
        SELECT 1249, 'Kadavu',73,0,NULL,1, 'FJ-04', 'FJ-E' UNION ALL 
        SELECT 1250, 'Lau',73,0,NULL,1, 'FJ-05', 'FJ-E' UNION ALL 
        SELECT 1251, 'Lomaiviti',73,0,NULL,1, 'FJ-06', 'FJ-E' UNION ALL 
        SELECT 1252, 'Macuata',73,0,NULL,1, 'FJ-07', 'FJ-N' UNION ALL 
        SELECT 1253, 'Nadroga and Navosa',73,0,NULL,1, 'FJ-08', 'FJ-W' UNION ALL 
        SELECT 1254, 'Naitasiri',73,0,NULL,1, 'FJ-09', 'FJ-C' UNION ALL 
        SELECT 1255, 'Namosi',73,0,NULL,1, 'FJ-10', 'FJ-C' UNION ALL 
        SELECT 1256, 'Northern',73,0,NULL,1, 'FJ-N', NULL UNION ALL 
        SELECT 1257, 'Ra',73,0,NULL,1, 'FJ-11', 'FJ-W' UNION ALL 
        SELECT 1258, 'Rewa',73,0,NULL,1, 'FJ-12', 'FJ-C' UNION ALL 
        SELECT 1259, 'Rotuma',73,0,NULL,1, 'FJ-R', NULL UNION ALL 
        SELECT 1260, 'Serua',73,0,NULL,1, 'FJ-13', 'FJ-C' UNION ALL 
        SELECT 1261, 'Tailevu',73,0,NULL,1, 'FJ-14', 'FJ-C' UNION ALL 
        SELECT 1262, 'Western',73,0,NULL,1, 'FJ-W', NULL UNION ALL 
        SELECT 1263, 'Ain',75,0,NULL,1, 'FR-01', 'FR-ARA' UNION ALL 
        SELECT 1264, 'Aisne',75,0,NULL,1, 'FR-02', 'FR-HDF' UNION ALL 
        SELECT 1265, 'Allier',75,0,NULL,1, 'FR-03', 'FR-ARA' UNION ALL 
        SELECT 1266, 'Alpes-Maritimes',75,0,NULL,1, 'FR-06', 'FR-PAC' UNION ALL 
        SELECT 1267, 'Alpes-de-Haute-Provence',75,0,NULL,1, 'FR-04', 'FR-PAC' UNION ALL 
        SELECT 1268, 'Ardennes',75,0,NULL,1, 'FR-08', 'FR-GES' UNION ALL 
        SELECT 1269, 'Ardèche',75,0,NULL,1, 'FR-07', 'FR-ARA' UNION ALL 
        SELECT 1270, 'Ariège',75,0,NULL,1, 'FR-09', 'FR-OCC' UNION ALL 
        SELECT 1271, 'Aube',75,0,NULL,1, 'FR-10', 'FR-GES' UNION ALL 
        SELECT 1272, 'Aude',75,0,NULL,1, 'FR-11', 'FR-OCC' UNION ALL 
        SELECT 1273, 'Auvergne-Rhône-Alpes',75,0,NULL,1, 'FR-ARA', NULL UNION ALL 
        SELECT 1274, 'Aveyron',75,0,NULL,1, 'FR-12', 'FR-OCC' UNION ALL 
        SELECT 1275, 'Bas-Rhin',75,0,NULL,1, 'FR-67', 'FR-GES' UNION ALL 
        SELECT 1276, 'Bouches-du-Rhône',75,0,NULL,1, 'FR-13', 'FR-PAC' UNION ALL 
        SELECT 1277, 'Bourgogne-Franche-Comté',75,0,NULL,1, 'FR-BFC', NULL UNION ALL 
        SELECT 1278, 'Bretagne',75,0,NULL,1, 'FR-BRE', NULL UNION ALL 
        SELECT 1279, 'Calvados',75,0,NULL,1, 'FR-14', 'FR-NOR' UNION ALL 
        SELECT 1280, 'Cantal',75,0,NULL,1, 'FR-15', 'FR-ARA' UNION ALL 
        SELECT 1281, 'Centre-Val de Loire',75,0,NULL,1, 'FR-CVL', NULL UNION ALL 
        SELECT 1282, 'Charente',75,0,NULL,1, 'FR-16', 'FR-NAQ' UNION ALL 
        SELECT 1283, 'Charente-Maritime',75,0,NULL,1, 'FR-17', 'FR-NAQ' UNION ALL 
        SELECT 1284, 'Cher',75,0,NULL,1, 'FR-18', 'FR-CVL' UNION ALL 
        SELECT 1285, 'Clipperton',75,0,NULL,1, 'FR-CP', NULL UNION ALL 
        SELECT 1286, 'Corrèze',75,0,NULL,1, 'FR-19', 'FR-NAQ' UNION ALL 
        SELECT 1287, 'Corse',75,0,NULL,1, 'FR-COR', NULL UNION ALL 
        SELECT 1288, 'Corse-du-Sud',75,0,NULL,1, 'FR-2A', 'FR-COR' UNION ALL 
        SELECT 1289, 'Creuse',75,0,NULL,1, 'FR-23', 'FR-NAQ' UNION ALL 
        SELECT 1290, 'Côte-d''Or',75,0,NULL,1, 'FR-21', 'FR-BFC' UNION ALL 
        SELECT 1291, 'Côtes-d''Armor',75,0,NULL,1, 'FR-22', 'FR-BRE' UNION ALL 
        SELECT 1292, 'Deux-Sèvres',75,0,NULL,1, 'FR-79', 'FR-NAQ' UNION ALL 
        SELECT 1293, 'Dordogne',75,0,NULL,1, 'FR-24', 'FR-NAQ' UNION ALL 
        SELECT 1294, 'Doubs',75,0,NULL,1, 'FR-25', 'FR-BFC' UNION ALL 
        SELECT 1295, 'Drôme',75,0,NULL,1, 'FR-26', 'FR-ARA' UNION ALL 
        SELECT 1296, 'Essonne',75,0,NULL,1, 'FR-91', 'FR-IDF' UNION ALL 
        SELECT 1297, 'Eure',75,0,NULL,1, 'FR-27', 'FR-NOR' UNION ALL 
        SELECT 1298, 'Eure-et-Loir',75,0,NULL,1, 'FR-28', 'FR-CVL' UNION ALL 
        SELECT 1299, 'Finistère',75,0,NULL,1, 'FR-29', 'FR-BRE' UNION ALL 
        SELECT 1300, 'Gard',75,0,NULL,1, 'FR-30', 'FR-OCC' UNION ALL 
        SELECT 1301, 'Gers',75,0,NULL,1, 'FR-32', 'FR-OCC' UNION ALL 
        SELECT 1302, 'Gironde',75,0,NULL,1, 'FR-33', 'FR-NAQ' UNION ALL 
        SELECT 1303, 'Grand-Est',75,0,NULL,1, 'FR-GES', NULL UNION ALL 
        SELECT 1304, 'Guadeloupe',75,0,NULL,1, 'FR-GUA', NULL UNION ALL 
        SELECT 1305, 'Guadeloupe',75,0,NULL,1, 'FR-GP', 'FR-GUA' UNION ALL 
        SELECT 1306, 'Guyane (française)',75,0,NULL,1, 'FR-GF', NULL UNION ALL 
        SELECT 1307, 'Haut-Rhin',75,0,NULL,1, 'FR-68', 'FR-GES' UNION ALL 
        SELECT 1308, 'Haute-Corse',75,0,NULL,1, 'FR-2B', 'FR-COR' UNION ALL 
        SELECT 1309, 'Haute-Garonne',75,0,NULL,1, 'FR-31', 'FR-OCC' UNION ALL 
        SELECT 1310, 'Haute-Loire',75,0,NULL,1, 'FR-43', 'FR-ARA' UNION ALL 
        SELECT 1311, 'Haute-Marne',75,0,NULL,1, 'FR-52', 'FR-GES' UNION ALL 
        SELECT 1312, 'Haute-Savoie',75,0,NULL,1, 'FR-74', 'FR-ARA' UNION ALL 
        SELECT 1313, 'Haute-Saône',75,0,NULL,1, 'FR-70', 'FR-BFC' UNION ALL 
        SELECT 1314, 'Haute-Vienne',75,0,NULL,1, 'FR-87', 'FR-NAQ' UNION ALL 
        SELECT 1315, 'Hautes-Alpes',75,0,NULL,1, 'FR-05', 'FR-PAC' UNION ALL 
        SELECT 1316, 'Hautes-Pyrénées',75,0,NULL,1, 'FR-65', 'FR-OCC' UNION ALL 
        SELECT 1317, 'Hauts-de-France',75,0,NULL,1, 'FR-HDF', NULL UNION ALL 
        SELECT 1318, 'Hauts-de-Seine',75,0,NULL,1, 'FR-92', 'FR-IDF' UNION ALL 
        SELECT 1319, 'Hérault',75,0,NULL,1, 'FR-34', 'FR-OCC' UNION ALL 
        SELECT 1320, 'Ille-et-Vilaine',75,0,NULL,1, 'FR-35', 'FR-BRE' UNION ALL 
        SELECT 1321, 'Indre',75,0,NULL,1, 'FR-36', 'FR-CVL' UNION ALL 
        SELECT 1322, 'Indre-et-Loire',75,0,NULL,1, 'FR-37', 'FR-CVL' UNION ALL 
        SELECT 1323, 'Isère',75,0,NULL,1, 'FR-38', 'FR-ARA' UNION ALL 
        SELECT 1324, 'Jura',75,0,NULL,1, 'FR-39', 'FR-BFC' UNION ALL 
        SELECT 1325, 'La Réunion',75,0,NULL,1, 'FR-LRE', NULL UNION ALL 
        SELECT 1326, 'La Réunion',75,0,NULL,1, 'FR-RE', 'FR-LRE' UNION ALL 
        SELECT 1327, 'Landes',75,0,NULL,1, 'FR-40', 'FR-NAQ' UNION ALL 
        SELECT 1328, 'Loir-et-Cher',75,0,NULL,1, 'FR-41', 'FR-CVL' UNION ALL 
        SELECT 1329, 'Loire',75,0,NULL,1, 'FR-42', 'FR-ARA' UNION ALL 
        SELECT 1330, 'Loire-Atlantique',75,0,NULL,1, 'FR-44', 'FR-PDL' UNION ALL 
        SELECT 1331, 'Loiret',75,0,NULL,1, 'FR-45', 'FR-CVL' UNION ALL 
        SELECT 1332, 'Lot',75,0,NULL,1, 'FR-46', 'FR-OCC' UNION ALL 
        SELECT 1333, 'Lot-et-Garonne',75,0,NULL,1, 'FR-47', 'FR-NAQ' UNION ALL 
        SELECT 1334, 'Lozère',75,0,NULL,1, 'FR-48', 'FR-OCC' UNION ALL 
        SELECT 1335, 'Maine-et-Loire',75,0,NULL,1, 'FR-49', 'FR-PDL' UNION ALL 
        SELECT 1336, 'Manche',75,0,NULL,1, 'FR-50', 'FR-NOR' UNION ALL 
        SELECT 1337, 'Marne',75,0,NULL,1, 'FR-51', 'FR-GES' UNION ALL 
        SELECT 1338, 'Martinique',75,0,NULL,1, 'FR-MQ', NULL UNION ALL 
        SELECT 1339, 'Mayenne',75,0,NULL,1, 'FR-53', 'FR-PDL' UNION ALL 
        SELECT 1340, 'Mayotte',75,0,NULL,1, 'FR-MAY', NULL UNION ALL 
        SELECT 1341, 'Mayotte',75,0,NULL,1, 'FR-YT', 'FR-MAY' UNION ALL 
        SELECT 1342, 'Meurthe-et-Moselle',75,0,NULL,1, 'FR-54', 'FR-GES' UNION ALL 
        SELECT 1343, 'Meuse',75,0,NULL,1, 'FR-55', 'FR-GES' UNION ALL 
        SELECT 1344, 'Morbihan',75,0,NULL,1, 'FR-56', 'FR-BRE' UNION ALL 
        SELECT 1345, 'Moselle',75,0,NULL,1, 'FR-57', 'FR-GES' UNION ALL 
        SELECT 1346, 'Nièvre',75,0,NULL,1, 'FR-58', 'FR-BFC' UNION ALL 
        SELECT 1347, 'Nord',75,0,NULL,1, 'FR-59', 'FR-HDF' UNION ALL 
        SELECT 1348, 'Normandie',75,0,NULL,1, 'FR-NOR', NULL UNION ALL 
        SELECT 1349, 'Nouvelle-Aquitaine',75,0,NULL,1, 'FR-NAQ', NULL UNION ALL 
        SELECT 1350, 'Nouvelle-Calédonie',75,0,NULL,1, 'FR-NC', NULL UNION ALL 
        SELECT 1351, 'Occitanie',75,0,NULL,1, 'FR-OCC', NULL UNION ALL 
        SELECT 1352, 'Oise',75,0,NULL,1, 'FR-60', 'FR-HDF' UNION ALL 
        SELECT 1353, 'Orne',75,0,NULL,1, 'FR-61', 'FR-NOR' UNION ALL 
        SELECT 1354, 'Paris',75,0,NULL,1, 'FR-75', 'FR-IDF' UNION ALL 
        SELECT 1355, 'Pas-de-Calais',75,0,NULL,1, 'FR-62', 'FR-HDF' UNION ALL 
        SELECT 1356, 'Pays-de-la-Loire',75,0,NULL,1, 'FR-PDL', NULL UNION ALL 
        SELECT 1357, 'Polynésie française',75,0,NULL,1, 'FR-PF', NULL UNION ALL 
        SELECT 1358, 'Provence-Alpes-Côte-d’Azur',75,0,NULL,1, 'FR-PAC', NULL UNION ALL 
        SELECT 1359, 'Puy-de-Dôme',75,0,NULL,1, 'FR-63', 'FR-ARA' UNION ALL 
        SELECT 1360, 'Pyrénées-Atlantiques',75,0,NULL,1, 'FR-64', 'FR-NAQ' UNION ALL 
        SELECT 1361, 'Pyrénées-Orientales',75,0,NULL,1, 'FR-66', 'FR-OCC' UNION ALL 
        SELECT 1362, 'Rhône',75,0,NULL,1, 'FR-69', 'FR-ARA' UNION ALL 
        SELECT 1363, 'Saint-Barthélemy',75,0,NULL,1, 'FR-BL', NULL UNION ALL 
        SELECT 1364, 'Saint-Martin',75,0,NULL,1, 'FR-MF', NULL UNION ALL 
        SELECT 1365, 'Saint-Pierre-et-Miquelon',75,0,NULL,1, 'FR-PM', NULL UNION ALL 
        SELECT 1366, 'Sarthe',75,0,NULL,1, 'FR-72', 'FR-PDL' UNION ALL 
        SELECT 1367, 'Savoie',75,0,NULL,1, 'FR-73', 'FR-ARA' UNION ALL 
        SELECT 1368, 'Saône-et-Loire',75,0,NULL,1, 'FR-71', 'FR-BFC' UNION ALL 
        SELECT 1369, 'Seine-Maritime',75,0,NULL,1, 'FR-76', 'FR-NOR' UNION ALL 
        SELECT 1370, 'Seine-Saint-Denis',75,0,NULL,1, 'FR-93', 'FR-IDF' UNION ALL 
        SELECT 1371, 'Seine-et-Marne',75,0,NULL,1, 'FR-77', 'FR-IDF' UNION ALL 
        SELECT 1372, 'Somme',75,0,NULL,1, 'FR-80', 'FR-HDF' UNION ALL 
        SELECT 1373, 'Tarn',75,0,NULL,1, 'FR-81', 'FR-OCC' UNION ALL 
        SELECT 1374, 'Tarn-et-Garonne',75,0,NULL,1, 'FR-82', 'FR-OCC' UNION ALL 
        SELECT 1375, 'Terres australes françaises',75,0,NULL,1, 'FR-TF', NULL UNION ALL 
        SELECT 1376, 'Territoire de Belfort',75,0,NULL,1, 'FR-90', 'FR-BFC' UNION ALL 
        SELECT 1377, 'Val-d''Oise',75,0,NULL,1, 'FR-95', 'FR-IDF' UNION ALL 
        SELECT 1378, 'Val-de-Marne',75,0,NULL,1, 'FR-94', 'FR-IDF' UNION ALL 
        SELECT 1379, 'Var',75,0,NULL,1, 'FR-83', 'FR-PAC' UNION ALL 
        SELECT 1380, 'Vaucluse',75,0,NULL,1, 'FR-84', 'FR-PAC' UNION ALL 
        SELECT 1381, 'Vendée',75,0,NULL,1, 'FR-85', 'FR-PDL' UNION ALL 
        SELECT 1382, 'Vienne',75,0,NULL,1, 'FR-86', 'FR-NAQ' UNION ALL 
        SELECT 1383, 'Vosges',75,0,NULL,1, 'FR-88', 'FR-GES' UNION ALL 
        SELECT 1384, 'Wallis-et-Futuna',75,0,NULL,1, 'FR-WF', NULL UNION ALL 
        SELECT 1385, 'Yonne',75,0,NULL,1, 'FR-89', 'FR-BFC' UNION ALL 
        SELECT 1386, 'Yvelines',75,0,NULL,1, 'FR-78', 'FR-IDF' UNION ALL 
        SELECT 1387, 'Île-de-France',75,0,NULL,1, 'FR-IDF', NULL UNION ALL 
        SELECT 1388, 'Aerodrom †',80,0,NULL,1, 'MK-801', NULL UNION ALL 
        SELECT 1389, 'Aracinovo',80,0,NULL,1, 'MK-802', NULL UNION ALL 
        SELECT 1390, 'Berovo',80,0,NULL,1, 'MK-201', NULL UNION ALL 
        SELECT 1391, 'Bitola',80,0,NULL,1, 'MK-501', NULL UNION ALL 
        SELECT 1392, 'Bogdanci',80,0,NULL,1, 'MK-401', NULL UNION ALL 
        SELECT 1393, 'Bogovinje',80,0,NULL,1, 'MK-601', NULL UNION ALL 
        SELECT 1394, 'Bosilovo',80,0,NULL,1, 'MK-402', NULL UNION ALL 
        SELECT 1395, 'Brvenica',80,0,NULL,1, 'MK-602', NULL UNION ALL 
        SELECT 1396, 'Butel †',80,0,NULL,1, 'MK-803', NULL UNION ALL 
        SELECT 1397, 'Centar Župa',80,0,NULL,1, 'MK-313', NULL UNION ALL 
        SELECT 1398, 'Centar †',80,0,NULL,1, 'MK-814', NULL UNION ALL 
        SELECT 1399, 'Debar',80,0,NULL,1, 'MK-303', NULL UNION ALL 
        SELECT 1400, 'Debrca',80,0,NULL,1, 'MK-304', NULL UNION ALL 
        SELECT 1401, 'Delcevo',80,0,NULL,1, 'MK-203', NULL UNION ALL 
        SELECT 1402, 'Demir Hisar',80,0,NULL,1, 'MK-502', NULL UNION ALL 
        SELECT 1403, 'Demir Kapija',80,0,NULL,1, 'MK-103', NULL UNION ALL 
        SELECT 1404, 'Dojran',80,0,NULL,1, 'MK-406', NULL UNION ALL 
        SELECT 1405, 'Dolneni',80,0,NULL,1, 'MK-503', NULL UNION ALL 
        SELECT 1406, 'Gazi Baba †',80,0,NULL,1, 'MK-804', NULL UNION ALL 
        SELECT 1407, 'Gevgelija',80,0,NULL,1, 'MK-405', NULL UNION ALL 
        SELECT 1408, 'Gjorce Petrov †',80,0,NULL,1, 'MK-805', NULL UNION ALL 
        SELECT 1409, 'Gostivar',80,0,NULL,1, 'MK-604', NULL UNION ALL 
        SELECT 1410, 'Gradsko',80,0,NULL,1, 'MK-102', NULL UNION ALL 
        SELECT 1411, 'Ilinden',80,0,NULL,1, 'MK-807', NULL UNION ALL 
        SELECT 1412, 'Jegunovce',80,0,NULL,1, 'MK-606', NULL UNION ALL 
        SELECT 1413, 'Karbinci',80,0,NULL,1, 'MK-205', NULL UNION ALL 
        SELECT 1414, 'Karpoš †',80,0,NULL,1, 'MK-808', NULL UNION ALL 
        SELECT 1415, 'Kavadarci',80,0,NULL,1, 'MK-104', NULL UNION ALL 
        SELECT 1416, 'Kisela Voda †',80,0,NULL,1, 'MK-809', NULL UNION ALL 
        SELECT 1417, 'Kicevo',80,0,NULL,1, 'MK-307', NULL UNION ALL 
        SELECT 1418, 'Konce',80,0,NULL,1, 'MK-407', NULL UNION ALL 
        SELECT 1419, 'Kocani',80,0,NULL,1, 'MK-206', NULL UNION ALL 
        SELECT 1420, 'Kratovo',80,0,NULL,1, 'MK-701', NULL UNION ALL 
        SELECT 1421, 'Kriva Palanka',80,0,NULL,1, 'MK-702', NULL UNION ALL 
        SELECT 1422, 'Krivogaštani',80,0,NULL,1, 'MK-504', NULL UNION ALL 
        SELECT 1423, 'Kruševo',80,0,NULL,1, 'MK-505', NULL UNION ALL 
        SELECT 1424, 'Kumanovo',80,0,NULL,1, 'MK-703', NULL UNION ALL 
        SELECT 1425, 'Lipkovo',80,0,NULL,1, 'MK-704', NULL UNION ALL 
        SELECT 1426, 'Lozovo',80,0,NULL,1, 'MK-105', NULL UNION ALL 
        SELECT 1427, 'Makedonska Kamenica',80,0,NULL,1, 'MK-207', NULL UNION ALL 
        SELECT 1428, 'Makedonski Brod',80,0,NULL,1, 'MK-308', NULL UNION ALL 
        SELECT 1429, 'Mavrovo i Rostuše',80,0,NULL,1, 'MK-607', NULL UNION ALL 
        SELECT 1430, 'Mogila',80,0,NULL,1, 'MK-506', NULL UNION ALL 
        SELECT 1431, 'Negotino',80,0,NULL,1, 'MK-106', NULL UNION ALL 
        SELECT 1432, 'Novaci',80,0,NULL,1, 'MK-507', NULL UNION ALL 
        SELECT 1433, 'Novo Selo',80,0,NULL,1, 'MK-408', NULL UNION ALL 
        SELECT 1434, 'Ohrid',80,0,NULL,1, 'MK-310', NULL UNION ALL 
        SELECT 1435, 'Pehcevo',80,0,NULL,1, 'MK-208', NULL UNION ALL 
        SELECT 1436, 'Petrovec',80,0,NULL,1, 'MK-810', NULL UNION ALL 
        SELECT 1437, 'Plasnica',80,0,NULL,1, 'MK-311', NULL UNION ALL 
        SELECT 1438, 'Prilep',80,0,NULL,1, 'MK-508', NULL UNION ALL 
        SELECT 1439, 'Probištip',80,0,NULL,1, 'MK-209', NULL UNION ALL 
        SELECT 1440, 'Radoviš',80,0,NULL,1, 'MK-409', NULL UNION ALL 
        SELECT 1441, 'Rankovce',80,0,NULL,1, 'MK-705', NULL UNION ALL 
        SELECT 1442, 'Resen',80,0,NULL,1, 'MK-509', NULL UNION ALL 
        SELECT 1443, 'Rosoman',80,0,NULL,1, 'MK-107', NULL UNION ALL 
        SELECT 1444, 'Saraj †',80,0,NULL,1, 'MK-811', NULL UNION ALL 
        SELECT 1445, 'Sopište',80,0,NULL,1, 'MK-812', NULL UNION ALL 
        SELECT 1446, 'Staro Nagoricane',80,0,NULL,1, 'MK-706', NULL UNION ALL 
        SELECT 1447, 'Struga',80,0,NULL,1, 'MK-312', NULL UNION ALL 
        SELECT 1448, 'Strumica',80,0,NULL,1, 'MK-410', NULL UNION ALL 
        SELECT 1449, 'Studenicani',80,0,NULL,1, 'MK-813', NULL UNION ALL 
        SELECT 1450, 'Sveti Nikole',80,0,NULL,1, 'MK-108', NULL UNION ALL 
        SELECT 1451, 'Tearce',80,0,NULL,1, 'MK-608', NULL UNION ALL 
        SELECT 1452, 'Tetovo',80,0,NULL,1, 'MK-609', NULL UNION ALL 
        SELECT 1453, 'Valandovo',80,0,NULL,1, 'MK-403', NULL UNION ALL 
        SELECT 1454, 'Vasilevo',80,0,NULL,1, 'MK-404', NULL UNION ALL 
        SELECT 1455, 'Veles',80,0,NULL,1, 'MK-101', NULL UNION ALL 
        SELECT 1456, 'Vevcani',80,0,NULL,1, 'MK-301', NULL UNION ALL 
        SELECT 1457, 'Vinica',80,0,NULL,1, 'MK-202', NULL UNION ALL 
        SELECT 1458, 'Vrapcište',80,0,NULL,1, 'MK-603', NULL UNION ALL 
        SELECT 1459, 'Zelenikovo',80,0,NULL,1, 'MK-806', NULL UNION ALL 
        SELECT 1460, 'Zrnovci',80,0,NULL,1, 'MK-204', NULL UNION ALL 
        SELECT 1461, 'Cair †',80,0,NULL,1, 'MK-815', NULL UNION ALL 
        SELECT 1462, 'Caška',80,0,NULL,1, 'MK-109', NULL UNION ALL 
        SELECT 1463, 'Cešinovo-Obleševo',80,0,NULL,1, 'MK-210', NULL UNION ALL 
        SELECT 1464, 'Cucer-Sandevo',80,0,NULL,1, 'MK-816', NULL UNION ALL 
        SELECT 1465, 'Štip',80,0,NULL,1, 'MK-211', NULL UNION ALL 
        SELECT 1466, 'Šuto Orizari †',80,0,NULL,1, 'MK-817', NULL UNION ALL 
        SELECT 1467, 'Želino',80,0,NULL,1, 'MK-605', NULL UNION ALL 
        SELECT 1468, 'Estuaire',81,0,NULL,1, 'GA-1', NULL UNION ALL 
        SELECT 1469, 'Haut-Ogooué',81,0,NULL,1, 'GA-2', NULL UNION ALL 
        SELECT 1470, 'Moyen-Ogooué',81,0,NULL,1, 'GA-3', NULL UNION ALL 
        SELECT 1471, 'Ngounié',81,0,NULL,1, 'GA-4', NULL UNION ALL 
        SELECT 1472, 'Nyanga',81,0,NULL,1, 'GA-5', NULL UNION ALL 
        SELECT 1473, 'Ogooué-Ivindo',81,0,NULL,1, 'GA-6', NULL UNION ALL 
        SELECT 1474, 'Ogooué-Lolo',81,0,NULL,1, 'GA-7', NULL UNION ALL 
        SELECT 1475, 'Ogooué-Maritime',81,0,NULL,1, 'GA-8', NULL UNION ALL 
        SELECT 1476, 'Woleu-Ntem',81,0,NULL,1, 'GA-9', NULL UNION ALL 
        SELECT 1477, 'Banjul',82,0,NULL,1, 'GM-B', NULL UNION ALL 
        SELECT 1478, 'Central River',82,0,NULL,1, 'GM-M', NULL UNION ALL 
        SELECT 1479, 'Lower River',82,0,NULL,1, 'GM-L', NULL UNION ALL 
        SELECT 1480, 'North Bank',82,0,NULL,1, 'GM-N', NULL UNION ALL 
        SELECT 1481, 'Upper River',82,0,NULL,1, 'GM-U', NULL UNION ALL 
        SELECT 1482, 'Western',82,0,NULL,1, 'GM-W', NULL UNION ALL 
        SELECT 1483, 'Abkhazia',83,0,NULL,1, 'GE-AB', NULL UNION ALL 
        SELECT 1484, 'Ajaria',83,0,NULL,1, 'GE-AJ', NULL UNION ALL 
        SELECT 1485, 'Guria',83,0,NULL,1, 'GE-GU', NULL UNION ALL 
        SELECT 1486, 'Imereti',83,0,NULL,1, 'GE-IM', NULL UNION ALL 
        SELECT 1487, 'K''akheti',83,0,NULL,1, 'GE-KA', NULL UNION ALL 
        SELECT 1488, 'Kvemo Kartli',83,0,NULL,1, 'GE-KK', NULL UNION ALL 
        SELECT 1489, 'Mtskheta-Mtianeti',83,0,NULL,1, 'GE-MM', NULL UNION ALL 
        SELECT 1490, 'Rach''a-Lechkhumi-Kvemo Svaneti',83,0,NULL,1, 'GE-RL', NULL UNION ALL 
        SELECT 1491, 'Samegrelo-Zemo Svaneti',83,0,NULL,1, 'GE-SZ', NULL UNION ALL 
        SELECT 1492, 'Samtskhe-Javakheti',83,0,NULL,1, 'GE-SJ', NULL UNION ALL 
        SELECT 1493, 'Shida Kartli',83,0,NULL,1, 'GE-SK', NULL UNION ALL 
        SELECT 1494, 'Tbilisi',83,0,NULL,1, 'GE-TB', NULL UNION ALL 
        SELECT 1495, 'Baden-Württemberg',84,0,NULL,1, 'DE-BW', NULL UNION ALL 
        SELECT 1496, 'Bayern',84,0,NULL,1, 'DE-BY', NULL UNION ALL 
        SELECT 1497, 'Berlin',84,0,NULL,1, 'DE-BE', NULL UNION ALL 
        SELECT 1498, 'Brandenburg',84,0,NULL,1, 'DE-BB', NULL UNION ALL 
        SELECT 1499, 'Bremen',84,0,NULL,1, 'DE-HB', NULL UNION ALL 
        SELECT 1500, 'Hamburg',84,0,NULL,1, 'DE-HH', NULL UNION ALL 
        SELECT 1501, 'Hessen',84,0,NULL,1, 'DE-HE', NULL UNION ALL 
        SELECT 1502, 'Mecklenburg-Vorpommern',84,0,NULL,1, 'DE-MV', NULL UNION ALL 
        SELECT 1503, 'Niedersachsen',84,0,NULL,1, 'DE-NI', NULL UNION ALL 
        SELECT 1504, 'Nordrhein-Westfalen',84,0,NULL,1, 'DE-NW', NULL UNION ALL 
        SELECT 1505, 'Rheinland-Pfalz',84,0,NULL,1, 'DE-RP', NULL UNION ALL 
        SELECT 1506, 'Saarland',84,0,NULL,1, 'DE-SL', NULL UNION ALL 
        SELECT 1507, 'Sachsen',84,0,NULL,1, 'DE-SN', NULL UNION ALL 
        SELECT 1508, 'Sachsen-Anhalt',84,0,NULL,1, 'DE-ST', NULL UNION ALL 
        SELECT 1509, 'Schleswig-Holstein',84,0,NULL,1, 'DE-SH', NULL UNION ALL 
        SELECT 1510, 'Thüringen',84,0,NULL,1, 'DE-TH', NULL UNION ALL 
        SELECT 1511, 'Ahafo',85,0,NULL,1, 'GH-AF', NULL UNION ALL 
        SELECT 1512, 'Ashanti',85,0,NULL,1, 'GH-AH', NULL UNION ALL 
        SELECT 1513, 'Bono',85,0,NULL,1, 'GH-BO', NULL UNION ALL 
        SELECT 1514, 'Bono East',85,0,NULL,1, 'GH-BE', NULL UNION ALL 
        SELECT 1515, 'Central',85,0,NULL,1, 'GH-CP', NULL UNION ALL 
        SELECT 1516, 'Eastern',85,0,NULL,1, 'GH-EP', NULL UNION ALL 
        SELECT 1517, 'Greater Accra',85,0,NULL,1, 'GH-AA', NULL UNION ALL 
        SELECT 1518, 'North East',85,0,NULL,1, 'GH-NE', NULL UNION ALL 
        SELECT 1519, 'Northern',85,0,NULL,1, 'GH-NP', NULL UNION ALL 
        SELECT 1520, 'Oti',85,0,NULL,1, 'GH-OT', NULL UNION ALL 
        SELECT 1521, 'Savannah',85,0,NULL,1, 'GH-SV', NULL UNION ALL 
        SELECT 1522, 'Upper East',85,0,NULL,1, 'GH-UE', NULL UNION ALL 
        SELECT 1523, 'Upper West',85,0,NULL,1, 'GH-UW', NULL UNION ALL 
        SELECT 1524, 'Volta',85,0,NULL,1, 'GH-TV', NULL UNION ALL 
        SELECT 1525, 'Western',85,0,NULL,1, 'GH-WP', NULL UNION ALL 
        SELECT 1526, 'Western North',85,0,NULL,1, 'GH-WN', NULL UNION ALL 
        SELECT 1527, 'Anatolikí Makedonía kai Thráki',87,0,NULL,1, 'GR-A', NULL UNION ALL 
        SELECT 1528, 'Attikí',87,0,NULL,1, 'GR-I', NULL UNION ALL 
        SELECT 1529, 'Dytikí Elláda',87,0,NULL,1, 'GR-G', NULL UNION ALL 
        SELECT 1530, 'Dytikí Makedonía',87,0,NULL,1, 'GR-C', NULL UNION ALL 
        SELECT 1531, 'Ionía Nísia',87,0,NULL,1, 'GR-F', NULL UNION ALL 
        SELECT 1532, 'Kentrikí Makedonía',87,0,NULL,1, 'GR-B', NULL UNION ALL 
        SELECT 1533, 'Kríti',87,0,NULL,1, 'GR-M', NULL UNION ALL 
        SELECT 1534, 'Nótio Aigaío',87,0,NULL,1, 'GR-L', NULL UNION ALL 
        SELECT 1535, 'Pelopónnisos',87,0,NULL,1, 'GR-J', NULL UNION ALL 
        SELECT 1536, 'Stereá Elláda',87,0,NULL,1, 'GR-H', NULL UNION ALL 
        SELECT 1537, 'Thessalía',87,0,NULL,1, 'GR-E', NULL UNION ALL 
        SELECT 1538, 'Vóreio Aigaío',87,0,NULL,1, 'GR-K', NULL UNION ALL 
        SELECT 1539, 'Ágion Óros',87,0,NULL,1, 'GR-69', NULL UNION ALL 
        SELECT 1540, 'Ípeiros',87,0,NULL,1, 'GR-D', NULL UNION ALL 
        SELECT 1541, 'Avannaata Kommunia',88,0,NULL,1, 'GL-AV', NULL UNION ALL 
        SELECT 1542, 'Kommune Kujalleq',88,0,NULL,1, 'GL-KU', NULL UNION ALL 
        SELECT 1543, 'Kommune Qeqertalik',88,0,NULL,1, 'GL-QT', NULL UNION ALL 
        SELECT 1544, 'Kommuneqarfik Sermersooq',88,0,NULL,1, 'GL-SM', NULL UNION ALL 
        SELECT 1545, 'Qeqqata Kommunia',88,0,NULL,1, 'GL-QE', NULL UNION ALL 
        SELECT 1546, 'Saint Andrew',89,0,NULL,1, 'GD-01', NULL UNION ALL 
        SELECT 1547, 'Saint David',89,0,NULL,1, 'GD-02', NULL UNION ALL 
        SELECT 1548, 'Saint George',89,0,NULL,1, 'GD-03', NULL UNION ALL 
        SELECT 1549, 'Saint John',89,0,NULL,1, 'GD-04', NULL UNION ALL 
        SELECT 1550, 'Saint Mark',89,0,NULL,1, 'GD-05', NULL UNION ALL 
        SELECT 1551, 'Saint Patrick',89,0,NULL,1, 'GD-06', NULL UNION ALL 
        SELECT 1552, 'Southern Grenadine Islands',89,0,NULL,1, 'GD-10', NULL UNION ALL 
        SELECT 1553, 'Alta Verapaz',92,0,NULL,1, 'GT-AV', NULL UNION ALL 
        SELECT 1554, 'Baja Verapaz',92,0,NULL,1, 'GT-BV', NULL UNION ALL 
        SELECT 1555, 'Chimaltenango',92,0,NULL,1, 'GT-CM', NULL UNION ALL 
        SELECT 1556, 'Chiquimula',92,0,NULL,1, 'GT-CQ', NULL UNION ALL 
        SELECT 1557, 'El Progreso',92,0,NULL,1, 'GT-PR', NULL UNION ALL 
        SELECT 1558, 'Escuintla',92,0,NULL,1, 'GT-ES', NULL UNION ALL 
        SELECT 1559, 'Guatemala',92,0,NULL,1, 'GT-GU', NULL UNION ALL 
        SELECT 1560, 'Huehuetenango',92,0,NULL,1, 'GT-HU', NULL UNION ALL 
        SELECT 1561, 'Izabal',92,0,NULL,1, 'GT-IZ', NULL UNION ALL 
        SELECT 1562, 'Jalapa',92,0,NULL,1, 'GT-JA', NULL UNION ALL 
        SELECT 1563, 'Jutiapa',92,0,NULL,1, 'GT-JU', NULL UNION ALL 
        SELECT 1564, 'Petén',92,0,NULL,1, 'GT-PE', NULL UNION ALL 
        SELECT 1565, 'Quetzaltenango',92,0,NULL,1, 'GT-QZ', NULL UNION ALL 
        SELECT 1566, 'Quiché',92,0,NULL,1, 'GT-QC', NULL UNION ALL 
        SELECT 1567, 'Retalhuleu',92,0,NULL,1, 'GT-RE', NULL UNION ALL 
        SELECT 1568, 'Sacatepéquez',92,0,NULL,1, 'GT-SA', NULL UNION ALL 
        SELECT 1569, 'San Marcos',92,0,NULL,1, 'GT-SM', NULL UNION ALL 
        SELECT 1570, 'Santa Rosa',92,0,NULL,1, 'GT-SR', NULL UNION ALL 
        SELECT 1571, 'Sololá',92,0,NULL,1, 'GT-SO', NULL UNION ALL 
        SELECT 1572, 'Suchitepéquez',92,0,NULL,1, 'GT-SU', NULL UNION ALL 
        SELECT 1573, 'Totonicapán',92,0,NULL,1, 'GT-TO', NULL UNION ALL 
        SELECT 1574, 'Zacapa',92,0,NULL,1, 'GT-ZA', NULL UNION ALL 
        SELECT 1575, 'Beyla',93,0,NULL,1, 'GN-BE', 'GN-N' UNION ALL 
        SELECT 1576, 'Boffa',93,0,NULL,1, 'GN-BF', 'GN-B' UNION ALL 
        SELECT 1577, 'Boké',93,0,NULL,1, 'GN-B', NULL UNION ALL 
        SELECT 1578, 'Boké',93,0,NULL,1, 'GN-BK', 'GN-B' UNION ALL 
        SELECT 1579, 'Conakry',93,0,NULL,1, 'GN-C', NULL UNION ALL 
        SELECT 1580, 'Coyah',93,0,NULL,1, 'GN-CO', 'GN-D' UNION ALL 
        SELECT 1581, 'Dabola',93,0,NULL,1, 'GN-DB', 'GN-F' UNION ALL 
        SELECT 1582, 'Dalaba',93,0,NULL,1, 'GN-DL', 'GN-M' UNION ALL 
        SELECT 1583, 'Dinguiraye',93,0,NULL,1, 'GN-DI', 'GN-F' UNION ALL 
        SELECT 1584, 'Dubréka',93,0,NULL,1, 'GN-DU', 'GN-D' UNION ALL 
        SELECT 1585, 'Faranah',93,0,NULL,1, 'GN-F', NULL UNION ALL 
        SELECT 1586, 'Faranah',93,0,NULL,1, 'GN-FA', 'GN-F' UNION ALL 
        SELECT 1587, 'Forécariah',93,0,NULL,1, 'GN-FO', 'GN-D' UNION ALL 
        SELECT 1588, 'Fria',93,0,NULL,1, 'GN-FR', 'GN-B' UNION ALL 
        SELECT 1589, 'Gaoual',93,0,NULL,1, 'GN-GA', 'GN-B' UNION ALL 
        SELECT 1590, 'Guékédou',93,0,NULL,1, 'GN-GU', 'GN-N' UNION ALL 
        SELECT 1591, 'Kankan',93,0,NULL,1, 'GN-K', NULL UNION ALL 
        SELECT 1592, 'Kankan',93,0,NULL,1, 'GN-KA', 'GN-K' UNION ALL 
        SELECT 1593, 'Kindia',93,0,NULL,1, 'GN-D', NULL UNION ALL 
        SELECT 1594, 'Kindia',93,0,NULL,1, 'GN-KD', 'GN-D' UNION ALL 
        SELECT 1595, 'Kissidougou',93,0,NULL,1, 'GN-KS', 'GN-F' UNION ALL 
        SELECT 1596, 'Koubia',93,0,NULL,1, 'GN-KB', 'GN-L' UNION ALL 
        SELECT 1597, 'Koundara',93,0,NULL,1, 'GN-KN', 'GN-B' UNION ALL 
        SELECT 1598, 'Kouroussa',93,0,NULL,1, 'GN-KO', 'GN-K' UNION ALL 
        SELECT 1599, 'Kérouané',93,0,NULL,1, 'GN-KE', 'GN-K' UNION ALL 
        SELECT 1600, 'Labé',93,0,NULL,1, 'GN-L', NULL UNION ALL 
        SELECT 1601, 'Labé',93,0,NULL,1, 'GN-LA', 'GN-L' UNION ALL 
        SELECT 1602, 'Lola',93,0,NULL,1, 'GN-LO', 'GN-N' UNION ALL 
        SELECT 1603, 'Lélouma',93,0,NULL,1, 'GN-LE', 'GN-L' UNION ALL 
        SELECT 1604, 'Macenta',93,0,NULL,1, 'GN-MC', 'GN-N' UNION ALL 
        SELECT 1605, 'Mali',93,0,NULL,1, 'GN-ML', 'GN-L' UNION ALL 
        SELECT 1606, 'Mamou',93,0,NULL,1, 'GN-M', NULL UNION ALL 
        SELECT 1607, 'Mamou',93,0,NULL,1, 'GN-MM', 'GN-M' UNION ALL 
        SELECT 1608, 'Mandiana',93,0,NULL,1, 'GN-MD', 'GN-K' UNION ALL 
        SELECT 1609, 'Nzérékoré',93,0,NULL,1, 'GN-N', NULL UNION ALL 
        SELECT 1610, 'Nzérékoré',93,0,NULL,1, 'GN-NZ', 'GN-N' UNION ALL 
        SELECT 1611, 'Pita',93,0,NULL,1, 'GN-PI', 'GN-M' UNION ALL 
        SELECT 1612, 'Siguiri',93,0,NULL,1, 'GN-SI', 'GN-K' UNION ALL 
        SELECT 1613, 'Tougué',93,0,NULL,1, 'GN-TO', 'GN-L' UNION ALL 
        SELECT 1614, 'Télimélé',93,0,NULL,1, 'GN-TE', 'GN-D' UNION ALL 
        SELECT 1615, 'Yomou',93,0,NULL,1, 'GN-YO', 'GN-N' UNION ALL 
        SELECT 1616, 'Bafatá',94,0,NULL,1, 'GW-BA', 'GW-L' UNION ALL 
        SELECT 1617, 'Biombo',94,0,NULL,1, 'GW-BM', 'GW-N' UNION ALL 
        SELECT 1618, 'Bissau',94,0,NULL,1, 'GW-BS', NULL UNION ALL 
        SELECT 1619, 'Bolama',94,0,NULL,1, 'GW-BL', 'GW-S' UNION ALL 
        SELECT 1620, 'Cacheu',94,0,NULL,1, 'GW-CA', 'GW-N' UNION ALL 
        SELECT 1621, 'Gabú',94,0,NULL,1, 'GW-GA', 'GW-L' UNION ALL 
        SELECT 1622, 'Leste',94,0,NULL,1, 'GW-L', NULL UNION ALL 
        SELECT 1623, 'Norte',94,0,NULL,1, 'GW-N', NULL UNION ALL 
        SELECT 1624, 'Oio',94,0,NULL,1, 'GW-OI', 'GW-N' UNION ALL 
        SELECT 1625, 'Quinara',94,0,NULL,1, 'GW-QU', 'GW-S' UNION ALL 
        SELECT 1626, 'Sul',94,0,NULL,1, 'GW-S', NULL UNION ALL 
        SELECT 1627, 'Tombali',94,0,NULL,1, 'GW-TO', 'GW-S' UNION ALL 
        SELECT 1628, 'Barima-Waini',95,0,NULL,1, 'GY-BA', NULL UNION ALL 
        SELECT 1629, 'Cuyuni-Mazaruni',95,0,NULL,1, 'GY-CU', NULL UNION ALL 
        SELECT 1630, 'Demerara-Mahaica',95,0,NULL,1, 'GY-DE', NULL UNION ALL 
        SELECT 1631, 'East Berbice-Corentyne',95,0,NULL,1, 'GY-EB', NULL UNION ALL 
        SELECT 1632, 'Essequibo Islands-West Demerara',95,0,NULL,1, 'GY-ES', NULL UNION ALL 
        SELECT 1633, 'Mahaica-Berbice',95,0,NULL,1, 'GY-MA', NULL UNION ALL 
        SELECT 1634, 'Pomeroon-Supenaam',95,0,NULL,1, 'GY-PM', NULL UNION ALL 
        SELECT 1635, 'Potaro-Siparuni',95,0,NULL,1, 'GY-PT', NULL UNION ALL 
        SELECT 1636, 'Upper Demerara-Berbice',95,0,NULL,1, 'GY-UD', NULL UNION ALL 
        SELECT 1637, 'Upper Takutu-Upper Essequibo',95,0,NULL,1, 'GY-UT', NULL UNION ALL 
        SELECT 1638, 'Atlántida',98,0,NULL,1, 'HN-AT', NULL UNION ALL 
        SELECT 1639, 'Choluteca',98,0,NULL,1, 'HN-CH', NULL UNION ALL 
        SELECT 1640, 'Colón',98,0,NULL,1, 'HN-CL', NULL UNION ALL 
        SELECT 1641, 'Comayagua',98,0,NULL,1, 'HN-CM', NULL UNION ALL 
        SELECT 1642, 'Copán',98,0,NULL,1, 'HN-CP', NULL UNION ALL 
        SELECT 1643, 'Cortés',98,0,NULL,1, 'HN-CR', NULL UNION ALL 
        SELECT 1644, 'El Paraíso',98,0,NULL,1, 'HN-EP', NULL UNION ALL 
        SELECT 1645, 'Francisco Morazán',98,0,NULL,1, 'HN-FM', NULL UNION ALL 
        SELECT 1646, 'Gracias a Dios',98,0,NULL,1, 'HN-GD', NULL UNION ALL 
        SELECT 1647, 'Intibucá',98,0,NULL,1, 'HN-IN', NULL UNION ALL 
        SELECT 1648, 'Islas de la Bahía',98,0,NULL,1, 'HN-IB', NULL UNION ALL 
        SELECT 1649, 'La Paz',98,0,NULL,1, 'HN-LP', NULL UNION ALL 
        SELECT 1650, 'Lempira',98,0,NULL,1, 'HN-LE', NULL UNION ALL 
        SELECT 1651, 'Ocotepeque',98,0,NULL,1, 'HN-OC', NULL UNION ALL 
        SELECT 1652, 'Olancho',98,0,NULL,1, 'HN-OL', NULL UNION ALL 
        SELECT 1653, 'Santa Bárbara',98,0,NULL,1, 'HN-SB', NULL UNION ALL 
        SELECT 1654, 'Valle',98,0,NULL,1, 'HN-VA', NULL UNION ALL 
        SELECT 1655, 'Yoro',98,0,NULL,1, 'HN-YO', NULL UNION ALL 
        SELECT 1656, 'Baranya',100,0,NULL,1, 'HU-BA', NULL UNION ALL 
        SELECT 1657, 'Borsod-Abaúj-Zemplén',100,0,NULL,1, 'HU-BZ', NULL UNION ALL 
        SELECT 1658, 'Budapest',100,0,NULL,1, 'HU-BU', NULL UNION ALL 
        SELECT 1659, 'Bács-Kiskun',100,0,NULL,1, 'HU-BK', NULL UNION ALL 
        SELECT 1660, 'Békés',100,0,NULL,1, 'HU-BE', NULL UNION ALL 
        SELECT 1661, 'Békéscsaba',100,0,NULL,1, 'HU-BC', NULL UNION ALL 
        SELECT 1662, 'Csongrád',100,0,NULL,1, 'HU-CS', NULL UNION ALL 
        SELECT 1663, 'Debrecen',100,0,NULL,1, 'HU-DE', NULL UNION ALL 
        SELECT 1664, 'Dunaújváros',100,0,NULL,1, 'HU-DU', NULL UNION ALL 
        SELECT 1665, 'Eger',100,0,NULL,1, 'HU-EG', NULL UNION ALL 
        SELECT 1666, 'Fejér',100,0,NULL,1, 'HU-FE', NULL UNION ALL 
        SELECT 1667, 'Gyor',100,0,NULL,1, 'HU-GY', NULL UNION ALL 
        SELECT 1668, 'Gyor-Moson-Sopron',100,0,NULL,1, 'HU-GS', NULL UNION ALL 
        SELECT 1669, 'Hajdú-Bihar',100,0,NULL,1, 'HU-HB', NULL UNION ALL 
        SELECT 1670, 'Heves',100,0,NULL,1, 'HU-HE', NULL UNION ALL 
        SELECT 1671, 'Hódmezovásárhely',100,0,NULL,1, 'HU-HV', NULL UNION ALL 
        SELECT 1672, 'Jász-Nagykun-Szolnok',100,0,NULL,1, 'HU-JN', NULL UNION ALL 
        SELECT 1673, 'Kaposvár',100,0,NULL,1, 'HU-KV', NULL UNION ALL 
        SELECT 1674, 'Kecskemét',100,0,NULL,1, 'HU-KM', NULL UNION ALL 
        SELECT 1675, 'Komárom-Esztergom',100,0,NULL,1, 'HU-KE', NULL UNION ALL 
        SELECT 1676, 'Miskolc',100,0,NULL,1, 'HU-MI', NULL UNION ALL 
        SELECT 1677, 'Nagykanizsa',100,0,NULL,1, 'HU-NK', NULL UNION ALL 
        SELECT 1678, 'Nyíregyháza',100,0,NULL,1, 'HU-NY', NULL UNION ALL 
        SELECT 1679, 'Nógrád',100,0,NULL,1, 'HU-NO', NULL UNION ALL 
        SELECT 1680, 'Pest',100,0,NULL,1, 'HU-PE', NULL UNION ALL 
        SELECT 1681, 'Pécs',100,0,NULL,1, 'HU-PS', NULL UNION ALL 
        SELECT 1682, 'Salgótarján',100,0,NULL,1, 'HU-ST', NULL UNION ALL 
        SELECT 1683, 'Somogy',100,0,NULL,1, 'HU-SO', NULL UNION ALL 
        SELECT 1684, 'Sopron',100,0,NULL,1, 'HU-SN', NULL UNION ALL 
        SELECT 1685, 'Szabolcs-Szatmár-Bereg',100,0,NULL,1, 'HU-SZ', NULL UNION ALL 
        SELECT 1686, 'Szeged',100,0,NULL,1, 'HU-SD', NULL UNION ALL 
        SELECT 1687, 'Szekszárd',100,0,NULL,1, 'HU-SS', NULL UNION ALL 
        SELECT 1688, 'Szolnok',100,0,NULL,1, 'HU-SK', NULL UNION ALL 
        SELECT 1689, 'Szombathely',100,0,NULL,1, 'HU-SH', NULL UNION ALL 
        SELECT 1690, 'Székesfehérvár',100,0,NULL,1, 'HU-SF', NULL UNION ALL 
        SELECT 1691, 'Tatabánya',100,0,NULL,1, 'HU-TB', NULL UNION ALL 
        SELECT 1692, 'Tolna',100,0,NULL,1, 'HU-TO', NULL UNION ALL 
        SELECT 1693, 'Vas',100,0,NULL,1, 'HU-VA', NULL UNION ALL 
        SELECT 1694, 'Veszprém',100,0,NULL,1, 'HU-VE', NULL UNION ALL 
        SELECT 1695, 'Veszprém',100,0,NULL,1, 'HU-VM', NULL UNION ALL 
        SELECT 1696, 'Zala',100,0,NULL,1, 'HU-ZA', NULL UNION ALL 
        SELECT 1697, 'Zalaegerszeg',100,0,NULL,1, 'HU-ZE', NULL UNION ALL 
        SELECT 1698, 'Érd',100,0,NULL,1, 'HU-ER', NULL UNION ALL 
        SELECT 1699, 'Austurland',101,0,NULL,1, 'IS-7', NULL UNION ALL 
        SELECT 1700, 'Höfuðborgarsvæði',101,0,NULL,1, 'IS-1', NULL UNION ALL 
        SELECT 1701, 'Norðurland eystra',101,0,NULL,1, 'IS-6', NULL UNION ALL 
        SELECT 1702, 'Norðurland vestra',101,0,NULL,1, 'IS-5', NULL UNION ALL 
        SELECT 1703, 'Suðurland',101,0,NULL,1, 'IS-8', NULL UNION ALL 
        SELECT 1704, 'Suðurnes',101,0,NULL,1, 'IS-2', NULL UNION ALL 
        SELECT 1705, 'Vestfirðir',101,0,NULL,1, 'IS-4', NULL UNION ALL 
        SELECT 1706, 'Vesturland',101,0,NULL,1, 'IS-3', NULL UNION ALL 
        SELECT 1707, 'Andaman and Nicobar Islands',102,0,NULL,1, 'IN-AN', NULL UNION ALL 
        SELECT 1708, 'Andhra Pradesh',102,0,NULL,1, 'IN-AP', NULL UNION ALL 
        SELECT 1709, 'Arunachal Pradesh',102,0,NULL,1, 'IN-AR', NULL UNION ALL 
        SELECT 1710, 'Assam',102,0,NULL,1, 'IN-AS', NULL UNION ALL 
        SELECT 1711, 'Bihar',102,0,NULL,1, 'IN-BR', NULL UNION ALL 
        SELECT 1712, 'Chandigarh',102,0,NULL,1, 'IN-CH', NULL UNION ALL 
        SELECT 1713, 'Chhattisgarh',102,0,NULL,1, 'IN-CT', NULL UNION ALL 
        SELECT 1714, 'Dadra and Nagar Haveli',102,0,NULL,1, 'IN-DN', NULL UNION ALL 
        SELECT 1715, 'Daman and Diu',102,0,NULL,1, 'IN-DD', NULL UNION ALL 
        SELECT 1716, 'Delhi',102,0,NULL,1, 'IN-DL', NULL UNION ALL 
        SELECT 1717, 'Goa',102,0,NULL,1, 'IN-GA', NULL UNION ALL 
        SELECT 1718, 'Gujarat',102,0,NULL,1, 'IN-GJ', NULL UNION ALL 
        SELECT 1719, 'Haryana',102,0,NULL,1, 'IN-HR', NULL UNION ALL 
        SELECT 1720, 'Himachal Pradesh',102,0,NULL,1, 'IN-HP', NULL UNION ALL 
        SELECT 1721, 'Jammu and Kashmir',102,0,NULL,1, 'IN-JK', NULL UNION ALL 
        SELECT 1722, 'Jharkhand',102,0,NULL,1, 'IN-JH', NULL UNION ALL 
        SELECT 1723, 'Karnataka',102,0,NULL,1, 'IN-KA', NULL UNION ALL 
        SELECT 1724, 'Kerala',102,0,NULL,1, 'IN-KL', NULL UNION ALL 
        SELECT 1725, 'Ladakh',102,0,NULL,1, 'IN-LA', NULL UNION ALL 
        SELECT 1726, 'Lakshadweep',102,0,NULL,1, 'IN-LD', NULL UNION ALL 
        SELECT 1727, 'Madhya Pradesh',102,0,NULL,1, 'IN-MP', NULL UNION ALL 
        SELECT 1728, 'Maharashtra',102,0,NULL,1, 'IN-MH', NULL UNION ALL 
        SELECT 1729, 'Manipur',102,0,NULL,1, 'IN-MN', NULL UNION ALL 
        SELECT 1730, 'Meghalaya',102,0,NULL,1, 'IN-ML', NULL UNION ALL 
        SELECT 1731, 'Mizoram',102,0,NULL,1, 'IN-MZ', NULL UNION ALL 
        SELECT 1732, 'Nagaland',102,0,NULL,1, 'IN-NL', NULL UNION ALL 
        SELECT 1733, 'Odisha',102,0,NULL,1, 'IN-OR', NULL UNION ALL 
        SELECT 1734, 'Puducherry',102,0,NULL,1, 'IN-PY', NULL UNION ALL 
        SELECT 1735, 'Punjab',102,0,NULL,1, 'IN-PB', NULL UNION ALL 
        SELECT 1736, 'Rajasthan',102,0,NULL,1, 'IN-RJ', NULL UNION ALL 
        SELECT 1737, 'Sikkim',102,0,NULL,1, 'IN-SK', NULL UNION ALL 
        SELECT 1738, 'Tamil Nadu',102,0,NULL,1, 'IN-TN', NULL UNION ALL 
        SELECT 1739, 'Telangana',102,0,NULL,1, 'IN-TG', NULL UNION ALL 
        SELECT 1740, 'Tripura',102,0,NULL,1, 'IN-TR', NULL UNION ALL 
        SELECT 1741, 'Uttar Pradesh',102,0,NULL,1, 'IN-UP', NULL UNION ALL 
        SELECT 1742, 'Uttarakhand',102,0,NULL,1, 'IN-UT', NULL UNION ALL 
        SELECT 1743, 'West Bengal',102,0,NULL,1, 'IN-WB', NULL UNION ALL 
        SELECT 1744, 'Aceh',103,0,NULL,1, 'ID-AC', 'ID-SM' UNION ALL 
        SELECT 1745, 'Bali',103,0,NULL,1, 'ID-BA', 'ID-NU' UNION ALL 
        SELECT 1746, 'Banten',103,0,NULL,1, 'ID-BT', 'ID-JW' UNION ALL 
        SELECT 1747, 'Bengkulu',103,0,NULL,1, 'ID-BE', 'ID-SM' UNION ALL 
        SELECT 1748, 'Gorontalo',103,0,NULL,1, 'ID-GO', 'ID-SL' UNION ALL 
        SELECT 1749, 'Jakarta Raya',103,0,NULL,1, 'ID-JK', 'ID-JW' UNION ALL 
        SELECT 1750, 'Jambi',103,0,NULL,1, 'ID-JA', 'ID-SM' UNION ALL 
        SELECT 1751, 'Jawa',103,0,NULL,1, 'ID-JW', NULL UNION ALL 
        SELECT 1752, 'Jawa Barat',103,0,NULL,1, 'ID-JB', 'ID-JW' UNION ALL 
        SELECT 1753, 'Jawa Tengah',103,0,NULL,1, 'ID-JT', 'ID-JW' UNION ALL 
        SELECT 1754, 'Jawa Timur',103,0,NULL,1, 'ID-JI', 'ID-JW' UNION ALL 
        SELECT 1755, 'Kalimantan',103,0,NULL,1, 'ID-KA', NULL UNION ALL 
        SELECT 1756, 'Kalimantan Barat',103,0,NULL,1, 'ID-KB', 'ID-KA' UNION ALL 
        SELECT 1757, 'Kalimantan Selatan',103,0,NULL,1, 'ID-KS', 'ID-KA' UNION ALL 
        SELECT 1758, 'Kalimantan Tengah',103,0,NULL,1, 'ID-KT', 'ID-KA' UNION ALL 
        SELECT 1759, 'Kalimantan Timur',103,0,NULL,1, 'ID-KI', 'ID-KA' UNION ALL 
        SELECT 1760, 'Kalimantan Utara',103,0,NULL,1, 'ID-KU', 'ID-KA' UNION ALL 
        SELECT 1761, 'Kepulauan Bangka Belitung',103,0,NULL,1, 'ID-BB', 'ID-SM' UNION ALL 
        SELECT 1762, 'Kepulauan Riau',103,0,NULL,1, 'ID-KR', 'ID-SM' UNION ALL 
        SELECT 1763, 'Lampung',103,0,NULL,1, 'ID-LA', 'ID-SM' UNION ALL 
        SELECT 1764, 'Maluku',103,0,NULL,1, 'ID-ML', NULL UNION ALL 
        SELECT 1765, 'Maluku',103,0,NULL,1, 'ID-MA', 'ID-ML' UNION ALL 
        SELECT 1766, 'Maluku Utara',103,0,NULL,1, 'ID-MU', 'ID-ML' UNION ALL 
        SELECT 1767, 'Nusa Tenggara',103,0,NULL,1, 'ID-NU', NULL UNION ALL 
        SELECT 1768, 'Nusa Tenggara Barat',103,0,NULL,1, 'ID-NB', 'ID-NU' UNION ALL 
        SELECT 1769, 'Nusa Tenggara Timur',103,0,NULL,1, 'ID-NT', 'ID-NU' UNION ALL 
        SELECT 1770, 'Papua',103,0,NULL,1, 'ID-PP', NULL UNION ALL 
        SELECT 1771, 'Papua',103,0,NULL,1, 'ID-PA', 'ID-PP' UNION ALL 
        SELECT 1772, 'Papua Barat',103,0,NULL,1, 'ID-PB', 'ID-PP' UNION ALL 
        SELECT 1773, 'Riau',103,0,NULL,1, 'ID-RI', 'ID-SM' UNION ALL 
        SELECT 1774, 'Sulawesi',103,0,NULL,1, 'ID-SL', NULL UNION ALL 
        SELECT 1775, 'Sulawesi Barat',103,0,NULL,1, 'ID-SR', 'ID-SL' UNION ALL 
        SELECT 1776, 'Sulawesi Selatan',103,0,NULL,1, 'ID-SN', 'ID-SL' UNION ALL 
        SELECT 1777, 'Sulawesi Tengah',103,0,NULL,1, 'ID-ST', 'ID-SL' UNION ALL 
        SELECT 1778, 'Sulawesi Tenggara',103,0,NULL,1, 'ID-SG', 'ID-SL' UNION ALL 
        SELECT 1779, 'Sulawesi Utara',103,0,NULL,1, 'ID-SA', 'ID-SL' UNION ALL 
        SELECT 1780, 'Sumatera',103,0,NULL,1, 'ID-SM', NULL UNION ALL 
        SELECT 1781, 'Sumatera Barat',103,0,NULL,1, 'ID-SB', 'ID-SM' UNION ALL 
        SELECT 1782, 'Sumatera Selatan',103,0,NULL,1, 'ID-SS', 'ID-SM' UNION ALL 
        SELECT 1783, 'Sumatera Utara',103,0,NULL,1, 'ID-SU', 'ID-SM' UNION ALL 
        SELECT 1784, 'Yogyakarta',103,0,NULL,1, 'ID-YO', 'ID-JW' UNION ALL 
        SELECT 1785, 'Alborz',104,0,NULL,1, 'IR-32', NULL UNION ALL 
        SELECT 1786, 'Ardabil',104,0,NULL,1, 'IR-03', NULL UNION ALL 
        SELECT 1787, 'Bushehr',104,0,NULL,1, 'IR-06', NULL UNION ALL 
        SELECT 1788, 'Chahar Ma?al va Bakhtiari',104,0,NULL,1, 'IR-08', NULL UNION ALL 
        SELECT 1789, 'Esfahan',104,0,NULL,1, 'IR-04', NULL UNION ALL 
        SELECT 1790, 'Fars',104,0,NULL,1, 'IR-14', NULL UNION ALL 
        SELECT 1791, 'Golestan',104,0,NULL,1, 'IR-27', NULL UNION ALL 
        SELECT 1792, 'Gilan',104,0,NULL,1, 'IR-19', NULL UNION ALL 
        SELECT 1793, 'Hamadan',104,0,NULL,1, 'IR-24', NULL UNION ALL 
        SELECT 1794, 'Hormozgan',104,0,NULL,1, 'IR-23', NULL UNION ALL 
        SELECT 1795, 'Kerman',104,0,NULL,1, 'IR-15', NULL UNION ALL 
        SELECT 1796, 'Kermanshah',104,0,NULL,1, 'IR-17', NULL UNION ALL 
        SELECT 1797, 'Khorasan-e Jonubi',104,0,NULL,1, 'IR-29', NULL UNION ALL 
        SELECT 1798, 'Khorasan-e Ra?avi',104,0,NULL,1, 'IR-30', NULL UNION ALL 
        SELECT 1799, 'Khorasan-e Shomali',104,0,NULL,1, 'IR-31', NULL UNION ALL 
        SELECT 1800, 'Khuzestan',104,0,NULL,1, 'IR-10', NULL UNION ALL 
        SELECT 1801, 'Kohgiluyeh va Bowyer A?mad',104,0,NULL,1, 'IR-18', NULL UNION ALL 
        SELECT 1802, 'Kordestan',104,0,NULL,1, 'IR-16', NULL UNION ALL 
        SELECT 1803, 'Lorestan',104,0,NULL,1, 'IR-20', NULL UNION ALL 
        SELECT 1804, 'Markazi',104,0,NULL,1, 'IR-22', NULL UNION ALL 
        SELECT 1805, 'Mazandaran',104,0,NULL,1, 'IR-21', NULL UNION ALL 
        SELECT 1806, 'Qazvin',104,0,NULL,1, 'IR-28', NULL UNION ALL 
        SELECT 1807, 'Qom',104,0,NULL,1, 'IR-26', NULL UNION ALL 
        SELECT 1808, 'Semnan',104,0,NULL,1, 'IR-12', NULL UNION ALL 
        SELECT 1809, 'Sistan va Baluchestan',104,0,NULL,1, 'IR-13', NULL UNION ALL 
        SELECT 1810, 'Tehran',104,0,NULL,1, 'IR-07', NULL UNION ALL 
        SELECT 1811, 'Yazd',104,0,NULL,1, 'IR-25', NULL UNION ALL 
        SELECT 1812, 'Zanjan',104,0,NULL,1, 'IR-11', NULL UNION ALL 
        SELECT 1813, 'Az¯arbayjan-e Gharbi',104,0,NULL,1, 'IR-02', NULL UNION ALL 
        SELECT 1814, 'Az¯arbayjan-e Sharqi',104,0,NULL,1, 'IR-01', NULL UNION ALL 
        SELECT 1815, 'Ilam',104,0,NULL,1, 'IR-05', NULL UNION ALL 
        SELECT 1816, 'Clarendon',109,0,NULL,1, 'JM-13', NULL UNION ALL 
        SELECT 1817, 'Hanover',109,0,NULL,1, 'JM-09', NULL UNION ALL 
        SELECT 1818, 'Kingston',109,0,NULL,1, 'JM-01', NULL UNION ALL 
        SELECT 1819, 'Manchester',109,0,NULL,1, 'JM-12', NULL UNION ALL 
        SELECT 1820, 'Portland',109,0,NULL,1, 'JM-04', NULL UNION ALL 
        SELECT 1821, 'Saint Andrew',109,0,NULL,1, 'JM-02', NULL UNION ALL 
        SELECT 1822, 'Saint Ann',109,0,NULL,1, 'JM-06', NULL UNION ALL 
        SELECT 1823, 'Saint Catherine',109,0,NULL,1, 'JM-14', NULL UNION ALL 
        SELECT 1824, 'Saint Elizabeth',109,0,NULL,1, 'JM-11', NULL UNION ALL 
        SELECT 1825, 'Saint James',109,0,NULL,1, 'JM-08', NULL UNION ALL 
        SELECT 1826, 'Saint Mary',109,0,NULL,1, 'JM-05', NULL UNION ALL 
        SELECT 1827, 'Saint Thomas',109,0,NULL,1, 'JM-03', NULL UNION ALL 
        SELECT 1828, 'Trelawny',109,0,NULL,1, 'JM-07', NULL UNION ALL 
        SELECT 1829, 'Westmoreland',109,0,NULL,1, 'JM-10', NULL UNION ALL 
        SELECT 1830, 'Al Balqa’',111,0,NULL,1, 'JO-BA', NULL UNION ALL 
        SELECT 1831, 'Al Karak',111,0,NULL,1, 'JO-KA', NULL UNION ALL 
        SELECT 1832, 'Al Mafraq',111,0,NULL,1, 'JO-MA', NULL UNION ALL 
        SELECT 1833, 'Al ‘Aqabah',111,0,NULL,1, 'JO-AQ', NULL UNION ALL 
        SELECT 1834, 'Al ‘A¯simah',111,0,NULL,1, 'JO-AM', NULL UNION ALL 
        SELECT 1835, 'Az Zarqa’',111,0,NULL,1, 'JO-AZ', NULL UNION ALL 
        SELECT 1836, 'At Tafilah',111,0,NULL,1, 'JO-AT', NULL UNION ALL 
        SELECT 1837, 'Irbid',111,0,NULL,1, 'JO-IR', NULL UNION ALL 
        SELECT 1838, 'Jarash',111,0,NULL,1, 'JO-JA', NULL UNION ALL 
        SELECT 1839, 'Ma‘an',111,0,NULL,1, 'JO-MN', NULL UNION ALL 
        SELECT 1840, 'Madaba',111,0,NULL,1, 'JO-MD', NULL UNION ALL 
        SELECT 1841, '‘Ajlun',111,0,NULL,1, 'JO-AJ', NULL UNION ALL 
        SELECT 1842, 'Baringo',113,0,NULL,1, 'KE-01', NULL UNION ALL 
        SELECT 1843, 'Bomet',113,0,NULL,1, 'KE-02', NULL UNION ALL 
        SELECT 1844, 'Bungoma',113,0,NULL,1, 'KE-03', NULL UNION ALL 
        SELECT 1845, 'Busia',113,0,NULL,1, 'KE-04', NULL UNION ALL 
        SELECT 1846, 'Elgeyo/Marakwet',113,0,NULL,1, 'KE-05', NULL UNION ALL 
        SELECT 1847, 'Embu',113,0,NULL,1, 'KE-06', NULL UNION ALL 
        SELECT 1848, 'Garissa',113,0,NULL,1, 'KE-07', NULL UNION ALL 
        SELECT 1849, 'Homa Bay',113,0,NULL,1, 'KE-08', NULL UNION ALL 
        SELECT 1850, 'Isiolo',113,0,NULL,1, 'KE-09', NULL UNION ALL 
        SELECT 1851, 'Kajiado',113,0,NULL,1, 'KE-10', NULL UNION ALL 
        SELECT 1852, 'Kakamega',113,0,NULL,1, 'KE-11', NULL UNION ALL 
        SELECT 1853, 'Kericho',113,0,NULL,1, 'KE-12', NULL UNION ALL 
        SELECT 1854, 'Kiambu',113,0,NULL,1, 'KE-13', NULL UNION ALL 
        SELECT 1855, 'Kilifi',113,0,NULL,1, 'KE-14', NULL UNION ALL 
        SELECT 1856, 'Kirinyaga',113,0,NULL,1, 'KE-15', NULL UNION ALL 
        SELECT 1857, 'Kisii',113,0,NULL,1, 'KE-16', NULL UNION ALL 
        SELECT 1858, 'Kisumu',113,0,NULL,1, 'KE-17', NULL UNION ALL 
        SELECT 1859, 'Kitui',113,0,NULL,1, 'KE-18', NULL UNION ALL 
        SELECT 1860, 'Kwale',113,0,NULL,1, 'KE-19', NULL UNION ALL 
        SELECT 1861, 'Laikipia',113,0,NULL,1, 'KE-20', NULL UNION ALL 
        SELECT 1862, 'Lamu',113,0,NULL,1, 'KE-21', NULL UNION ALL 
        SELECT 1863, 'Machakos',113,0,NULL,1, 'KE-22', NULL UNION ALL 
        SELECT 1864, 'Makueni',113,0,NULL,1, 'KE-23', NULL UNION ALL 
        SELECT 1865, 'Mandera',113,0,NULL,1, 'KE-24', NULL UNION ALL 
        SELECT 1866, 'Marsabit',113,0,NULL,1, 'KE-25', NULL UNION ALL 
        SELECT 1867, 'Meru',113,0,NULL,1, 'KE-26', NULL UNION ALL 
        SELECT 1868, 'Migori',113,0,NULL,1, 'KE-27', NULL UNION ALL 
        SELECT 1869, 'Mombasa',113,0,NULL,1, 'KE-28', NULL UNION ALL 
        SELECT 1870, 'Murang''a',113,0,NULL,1, 'KE-29', NULL UNION ALL 
        SELECT 1871, 'Nairobi City',113,0,NULL,1, 'KE-30', NULL UNION ALL 
        SELECT 1872, 'Nakuru',113,0,NULL,1, 'KE-31', NULL UNION ALL 
        SELECT 1873, 'Nandi',113,0,NULL,1, 'KE-32', NULL UNION ALL 
        SELECT 1874, 'Narok',113,0,NULL,1, 'KE-33', NULL UNION ALL 
        SELECT 1875, 'Nyamira',113,0,NULL,1, 'KE-34', NULL UNION ALL 
        SELECT 1876, 'Nyandarua',113,0,NULL,1, 'KE-35', NULL UNION ALL 
        SELECT 1877, 'Nyeri',113,0,NULL,1, 'KE-36', NULL UNION ALL 
        SELECT 1878, 'Samburu',113,0,NULL,1, 'KE-37', NULL UNION ALL 
        SELECT 1879, 'Siaya',113,0,NULL,1, 'KE-38', NULL UNION ALL 
        SELECT 1880, 'Taita/Taveta',113,0,NULL,1, 'KE-39', NULL UNION ALL 
        SELECT 1881, 'Tana River',113,0,NULL,1, 'KE-40', NULL UNION ALL 
        SELECT 1882, 'Tharaka-Nithi',113,0,NULL,1, 'KE-41', NULL UNION ALL 
        SELECT 1883, 'Trans Nzoia',113,0,NULL,1, 'KE-42', NULL UNION ALL 
        SELECT 1884, 'Turkana',113,0,NULL,1, 'KE-43', NULL UNION ALL 
        SELECT 1885, 'Uasin Gishu',113,0,NULL,1, 'KE-44', NULL UNION ALL 
        SELECT 1886, 'Vihiga',113,0,NULL,1, 'KE-45', NULL UNION ALL 
        SELECT 1887, 'Wajir',113,0,NULL,1, 'KE-46', NULL UNION ALL 
        SELECT 1888, 'West Pokot',113,0,NULL,1, 'KE-47', NULL UNION ALL 
        SELECT 1889, 'Gilbert Islands',114,0,NULL,1, 'KI-G', NULL UNION ALL 
        SELECT 1890, 'Line Islands',114,0,NULL,1, 'KI-L', NULL UNION ALL 
        SELECT 1891, 'Phoenix Islands',114,0,NULL,1, 'KI-P', NULL UNION ALL 
        SELECT 1892, 'Busan-gwangyeoksi',116,0,NULL,1, 'KR-26', NULL UNION ALL 
        SELECT 1893, 'Chungcheongbuk-do',116,0,NULL,1, 'KR-43', NULL UNION ALL 
        SELECT 1894, 'Chungcheongnam-do',116,0,NULL,1, 'KR-44', NULL UNION ALL 
        SELECT 1895, 'Daegu-gwangyeoksi',116,0,NULL,1, 'KR-27', NULL UNION ALL 
        SELECT 1896, 'Daejeon-gwangyeoksi',116,0,NULL,1, 'KR-30', NULL UNION ALL 
        SELECT 1897, 'Gangwon-do',116,0,NULL,1, 'KR-42', NULL UNION ALL 
        SELECT 1898, 'Gwangju-gwangyeoksi',116,0,NULL,1, 'KR-29', NULL UNION ALL 
        SELECT 1899, 'Gyeonggi-do',116,0,NULL,1, 'KR-41', NULL UNION ALL 
        SELECT 1900, 'Gyeongsangbuk-do',116,0,NULL,1, 'KR-47', NULL UNION ALL 
        SELECT 1901, 'Gyeongsangnam-do',116,0,NULL,1, 'KR-48', NULL UNION ALL 
        SELECT 1902, 'Incheon-gwangyeoksi',116,0,NULL,1, 'KR-28', NULL UNION ALL 
        SELECT 1903, 'Jeju-teukbyeoljachido',116,0,NULL,1, 'KR-49', NULL UNION ALL 
        SELECT 1904, 'Jeollabuk-do',116,0,NULL,1, 'KR-45', NULL UNION ALL 
        SELECT 1905, 'Jeollanam-do',116,0,NULL,1, 'KR-46', NULL UNION ALL 
        SELECT 1906, 'Sejong',116,0,NULL,1, 'KR-50', NULL UNION ALL 
        SELECT 1907, 'Seoul-teukbyeolsi',116,0,NULL,1, 'KR-11', NULL UNION ALL 
        SELECT 1908, 'Ulsan-gwangyeoksi',116,0,NULL,1, 'KR-31', NULL UNION ALL 
        SELECT 1909, 'Al A?madi',117,0,NULL,1, 'KW-AH', NULL UNION ALL 
        SELECT 1910, 'Al Farwaniyah',117,0,NULL,1, 'KW-FA', NULL UNION ALL 
        SELECT 1911, 'Al Jahra’',117,0,NULL,1, 'KW-JA', NULL UNION ALL 
        SELECT 1912, 'Al ‘Asimah',117,0,NULL,1, 'KW-KU', NULL UNION ALL 
        SELECT 1913, 'Mubarak al Kabir',117,0,NULL,1, 'KW-MU', NULL UNION ALL 
        SELECT 1914, '?awalli',117,0,NULL,1, 'KW-HA', NULL UNION ALL 
        SELECT 1915, 'Attapu',119,0,NULL,1, 'LA-AT', NULL UNION ALL 
        SELECT 1916, 'Bokèo',119,0,NULL,1, 'LA-BK', NULL UNION ALL 
        SELECT 1917, 'Bolikhamxai',119,0,NULL,1, 'LA-BL', NULL UNION ALL 
        SELECT 1918, 'Champasak',119,0,NULL,1, 'LA-CH', NULL UNION ALL 
        SELECT 1919, 'Houaphan',119,0,NULL,1, 'LA-HO', NULL UNION ALL 
        SELECT 1920, 'Khammouan',119,0,NULL,1, 'LA-KH', NULL UNION ALL 
        SELECT 1921, 'Louang Namtha',119,0,NULL,1, 'LA-LM', NULL UNION ALL 
        SELECT 1922, 'Louangphabang',119,0,NULL,1, 'LA-LP', NULL UNION ALL 
        SELECT 1923, 'Oudômxai',119,0,NULL,1, 'LA-OU', NULL UNION ALL 
        SELECT 1924, 'Phôngsali',119,0,NULL,1, 'LA-PH', NULL UNION ALL 
        SELECT 1925, 'Salavan',119,0,NULL,1, 'LA-SL', NULL UNION ALL 
        SELECT 1926, 'Savannakhét',119,0,NULL,1, 'LA-SV', NULL UNION ALL 
        SELECT 1927, 'Viangchan',119,0,NULL,1, 'LA-VT', NULL UNION ALL 
        SELECT 1928, 'Viangchan',119,0,NULL,1, 'LA-VI', NULL UNION ALL 
        SELECT 1929, 'Xaignabouli',119,0,NULL,1, 'LA-XA', NULL UNION ALL 
        SELECT 1930, 'Xaisômboun',119,0,NULL,1, 'LA-XS', NULL UNION ALL 
        SELECT 1931, 'Xiangkhouang',119,0,NULL,1, 'LA-XI', NULL UNION ALL 
        SELECT 1932, 'Xékong',119,0,NULL,1, 'LA-XE', NULL UNION ALL 
        SELECT 1933, 'Aglonas novads',120,0,NULL,1, 'LV-001', NULL UNION ALL 
        SELECT 1934, 'Aizkraukles novads',120,0,NULL,1, 'LV-002', NULL UNION ALL 
        SELECT 1935, 'Aizputes novads',120,0,NULL,1, 'LV-003', NULL UNION ALL 
        SELECT 1936, 'Aknistes novads',120,0,NULL,1, 'LV-004', NULL UNION ALL 
        SELECT 1937, 'Alojas novads',120,0,NULL,1, 'LV-005', NULL UNION ALL 
        SELECT 1938, 'Alsungas novads',120,0,NULL,1, 'LV-006', NULL UNION ALL 
        SELECT 1939, 'Aluksnes novads',120,0,NULL,1, 'LV-007', NULL UNION ALL 
        SELECT 1940, 'Amatas novads',120,0,NULL,1, 'LV-008', NULL UNION ALL 
        SELECT 1941, 'Apes novads',120,0,NULL,1, 'LV-009', NULL UNION ALL 
        SELECT 1942, 'Auces novads',120,0,NULL,1, 'LV-010', NULL UNION ALL 
        SELECT 1943, 'Babites novads',120,0,NULL,1, 'LV-012', NULL UNION ALL 
        SELECT 1944, 'Baldones novads',120,0,NULL,1, 'LV-013', NULL UNION ALL 
        SELECT 1945, 'Baltinavas novads',120,0,NULL,1, 'LV-014', NULL UNION ALL 
        SELECT 1946, 'Balvu novads',120,0,NULL,1, 'LV-015', NULL UNION ALL 
        SELECT 1947, 'Bauskas novads',120,0,NULL,1, 'LV-016', NULL UNION ALL 
        SELECT 1948, 'Beverinas novads',120,0,NULL,1, 'LV-017', NULL UNION ALL 
        SELECT 1949, 'Brocenu novads',120,0,NULL,1, 'LV-018', NULL UNION ALL 
        SELECT 1950, 'Burtnieku novads',120,0,NULL,1, 'LV-019', NULL UNION ALL 
        SELECT 1951, 'Carnikavas novads',120,0,NULL,1, 'LV-020', NULL UNION ALL 
        SELECT 1952, 'Cesvaines novads',120,0,NULL,1, 'LV-021', NULL UNION ALL 
        SELECT 1953, 'Ciblas novads',120,0,NULL,1, 'LV-023', NULL UNION ALL 
        SELECT 1954, 'Cesu novads',120,0,NULL,1, 'LV-022', NULL UNION ALL 
        SELECT 1955, 'Dagdas novads',120,0,NULL,1, 'LV-024', NULL UNION ALL 
        SELECT 1956, 'Daugavpils',120,0,NULL,1, 'LV-DGV', NULL UNION ALL 
        SELECT 1957, 'Daugavpils novads',120,0,NULL,1, 'LV-025', NULL UNION ALL 
        SELECT 1958, 'Dobeles novads',120,0,NULL,1, 'LV-026', NULL UNION ALL 
        SELECT 1959, 'Dundagas novads',120,0,NULL,1, 'LV-027', NULL UNION ALL 
        SELECT 1960, 'Durbes novads',120,0,NULL,1, 'LV-028', NULL UNION ALL 
        SELECT 1961, 'Engures novads',120,0,NULL,1, 'LV-029', NULL UNION ALL 
        SELECT 1962, 'Garkalnes novads',120,0,NULL,1, 'LV-031', NULL UNION ALL 
        SELECT 1963, 'Grobinas novads',120,0,NULL,1, 'LV-032', NULL UNION ALL 
        SELECT 1964, 'Gulbenes novads',120,0,NULL,1, 'LV-033', NULL UNION ALL 
        SELECT 1965, 'Iecavas novads',120,0,NULL,1, 'LV-034', NULL UNION ALL 
        SELECT 1966, 'Ikškiles novads',120,0,NULL,1, 'LV-035', NULL UNION ALL 
        SELECT 1967, 'Ilukstes novads',120,0,NULL,1, 'LV-036', NULL UNION ALL 
        SELECT 1968, 'Incukalna novads',120,0,NULL,1, 'LV-037', NULL UNION ALL 
        SELECT 1969, 'Jaunjelgavas novads',120,0,NULL,1, 'LV-038', NULL UNION ALL 
        SELECT 1970, 'Jaunpiebalgas novads',120,0,NULL,1, 'LV-039', NULL UNION ALL 
        SELECT 1971, 'Jaunpils novads',120,0,NULL,1, 'LV-040', NULL UNION ALL 
        SELECT 1972, 'Jelgava',120,0,NULL,1, 'LV-JEL', NULL UNION ALL 
        SELECT 1973, 'Jelgavas novads',120,0,NULL,1, 'LV-041', NULL UNION ALL 
        SELECT 1974, 'Jekabpils',120,0,NULL,1, 'LV-JKB', NULL UNION ALL 
        SELECT 1975, 'Jekabpils novads',120,0,NULL,1, 'LV-042', NULL UNION ALL 
        SELECT 1976, 'Jurmala',120,0,NULL,1, 'LV-JUR', NULL UNION ALL 
        SELECT 1977, 'Kandavas novads',120,0,NULL,1, 'LV-043', NULL UNION ALL 
        SELECT 1978, 'Kocenu novads',120,0,NULL,1, 'LV-045', NULL UNION ALL 
        SELECT 1979, 'Kokneses novads',120,0,NULL,1, 'LV-046', NULL UNION ALL 
        SELECT 1980, 'Krimuldas novads',120,0,NULL,1, 'LV-048', NULL UNION ALL 
        SELECT 1981, 'Krustpils novads',120,0,NULL,1, 'LV-049', NULL UNION ALL 
        SELECT 1982, 'Kraslavas novads',120,0,NULL,1, 'LV-047', NULL UNION ALL 
        SELECT 1983, 'Kuldigas novads',120,0,NULL,1, 'LV-050', NULL UNION ALL 
        SELECT 1984, 'Karsavas novads',120,0,NULL,1, 'LV-044', NULL UNION ALL 
        SELECT 1985, 'Lielvardes novads',120,0,NULL,1, 'LV-053', NULL UNION ALL 
        SELECT 1986, 'Liepaja',120,0,NULL,1, 'LV-LPX', NULL UNION ALL 
        SELECT 1987, 'Limbažu novads',120,0,NULL,1, 'LV-054', NULL UNION ALL 
        SELECT 1988, 'Lubanas novads',120,0,NULL,1, 'LV-057', NULL UNION ALL 
        SELECT 1989, 'Ludzas novads',120,0,NULL,1, 'LV-058', NULL UNION ALL 
        SELECT 1990, 'Ligatnes novads',120,0,NULL,1, 'LV-055', NULL UNION ALL 
        SELECT 1991, 'Livanu novads',120,0,NULL,1, 'LV-056', NULL UNION ALL 
        SELECT 1992, 'Madonas novads',120,0,NULL,1, 'LV-059', NULL UNION ALL 
        SELECT 1993, 'Mazsalacas novads',120,0,NULL,1, 'LV-060', NULL UNION ALL 
        SELECT 1994, 'Malpils novads',120,0,NULL,1, 'LV-061', NULL UNION ALL 
        SELECT 1995, 'Marupes novads',120,0,NULL,1, 'LV-062', NULL UNION ALL 
        SELECT 1996, 'Mersraga novads',120,0,NULL,1, 'LV-063', NULL UNION ALL 
        SELECT 1997, 'Naukšenu novads',120,0,NULL,1, 'LV-064', NULL UNION ALL 
        SELECT 1998, 'Neretas novads',120,0,NULL,1, 'LV-065', NULL UNION ALL 
        SELECT 1999, 'Nicas novads',120,0,NULL,1, 'LV-066', NULL UNION ALL 
        SELECT 2000, 'Ogres novads',120,0,NULL,1, 'LV-067', NULL UNION ALL 
        SELECT 2001, 'Olaines novads',120,0,NULL,1, 'LV-068', NULL UNION ALL 
        SELECT 2002, 'Ozolnieku novads',120,0,NULL,1, 'LV-069', NULL UNION ALL 
        SELECT 2003, 'Preilu novads',120,0,NULL,1, 'LV-073', NULL UNION ALL 
        SELECT 2004, 'Priekules novads',120,0,NULL,1, 'LV-074', NULL UNION ALL 
        SELECT 2005, 'Priekulu novads',120,0,NULL,1, 'LV-075', NULL UNION ALL 
        SELECT 2006, 'Pargaujas novads',120,0,NULL,1, 'LV-070', NULL UNION ALL 
        SELECT 2007, 'Pavilostas novads',120,0,NULL,1, 'LV-071', NULL UNION ALL 
        SELECT 2008, 'Plavinu novads',120,0,NULL,1, 'LV-072', NULL UNION ALL 
        SELECT 2009, 'Raunas novads',120,0,NULL,1, 'LV-076', NULL UNION ALL 
        SELECT 2010, 'Riebinu novads',120,0,NULL,1, 'LV-078', NULL UNION ALL 
        SELECT 2011, 'Rojas novads',120,0,NULL,1, 'LV-079', NULL UNION ALL 
        SELECT 2012, 'Ropažu novads',120,0,NULL,1, 'LV-080', NULL UNION ALL 
        SELECT 2013, 'Rucavas novads',120,0,NULL,1, 'LV-081', NULL UNION ALL 
        SELECT 2014, 'Rugaju novads',120,0,NULL,1, 'LV-082', NULL UNION ALL 
        SELECT 2015, 'Rundales novads',120,0,NULL,1, 'LV-083', NULL UNION ALL 
        SELECT 2016, 'Rezekne',120,0,NULL,1, 'LV-REZ', NULL UNION ALL 
        SELECT 2017, 'Rezeknes novads',120,0,NULL,1, 'LV-077', NULL UNION ALL 
        SELECT 2018, 'Riga',120,0,NULL,1, 'LV-RIX', NULL UNION ALL 
        SELECT 2019, 'Rujienas novads',120,0,NULL,1, 'LV-084', NULL UNION ALL 
        SELECT 2020, 'Salacgrivas novads',120,0,NULL,1, 'LV-086', NULL UNION ALL 
        SELECT 2021, 'Salas novads',120,0,NULL,1, 'LV-085', NULL UNION ALL 
        SELECT 2022, 'Salaspils novads',120,0,NULL,1, 'LV-087', NULL UNION ALL 
        SELECT 2023, 'Saldus novads',120,0,NULL,1, 'LV-088', NULL UNION ALL 
        SELECT 2024, 'Saulkrastu novads',120,0,NULL,1, 'LV-089', NULL UNION ALL 
        SELECT 2025, 'Siguldas novads',120,0,NULL,1, 'LV-091', NULL UNION ALL 
        SELECT 2026, 'Skrundas novads',120,0,NULL,1, 'LV-093', NULL UNION ALL 
        SELECT 2027, 'Skriveru novads',120,0,NULL,1, 'LV-092', NULL UNION ALL 
        SELECT 2028, 'Smiltenes novads',120,0,NULL,1, 'LV-094', NULL UNION ALL 
        SELECT 2029, 'Stopinu novads',120,0,NULL,1, 'LV-095', NULL UNION ALL 
        SELECT 2030, 'Strencu novads',120,0,NULL,1, 'LV-096', NULL UNION ALL 
        SELECT 2031, 'Sejas novads',120,0,NULL,1, 'LV-090', NULL UNION ALL 
        SELECT 2032, 'Talsu novads',120,0,NULL,1, 'LV-097', NULL UNION ALL 
        SELECT 2033, 'Tukuma novads',120,0,NULL,1, 'LV-099', NULL UNION ALL 
        SELECT 2034, 'Tervetes novads',120,0,NULL,1, 'LV-098', NULL UNION ALL 
        SELECT 2035, 'Vainodes novads',120,0,NULL,1, 'LV-100', NULL UNION ALL 
        SELECT 2036, 'Valkas novads',120,0,NULL,1, 'LV-101', NULL UNION ALL 
        SELECT 2037, 'Valmiera',120,0,NULL,1, 'LV-VMR', NULL UNION ALL 
        SELECT 2038, 'Varaklanu novads',120,0,NULL,1, 'LV-102', NULL UNION ALL 
        SELECT 2039, 'Vecpiebalgas novads',120,0,NULL,1, 'LV-104', NULL UNION ALL 
        SELECT 2040, 'Vecumnieku novads',120,0,NULL,1, 'LV-105', NULL UNION ALL 
        SELECT 2041, 'Ventspils',120,0,NULL,1, 'LV-VEN', NULL UNION ALL 
        SELECT 2042, 'Ventspils novads',120,0,NULL,1, 'LV-106', NULL UNION ALL 
        SELECT 2043, 'Viesites novads',120,0,NULL,1, 'LV-107', NULL UNION ALL 
        SELECT 2044, 'Vilakas novads',120,0,NULL,1, 'LV-108', NULL UNION ALL 
        SELECT 2045, 'Vilanu novads',120,0,NULL,1, 'LV-109', NULL UNION ALL 
        SELECT 2046, 'Varkavas novads',120,0,NULL,1, 'LV-103', NULL UNION ALL 
        SELECT 2047, 'Zilupes novads',120,0,NULL,1, 'LV-110', NULL UNION ALL 
        SELECT 2048, 'Adažu novads',120,0,NULL,1, 'LV-011', NULL UNION ALL 
        SELECT 2049, 'Erglu novads',120,0,NULL,1, 'LV-030', NULL UNION ALL 
        SELECT 2050, 'Keguma novads',120,0,NULL,1, 'LV-051', NULL UNION ALL 
        SELECT 2051, 'Kekavas novads',120,0,NULL,1, 'LV-052', NULL UNION ALL 
        SELECT 2052, 'Bomi',123,0,NULL,1, 'LR-BM', NULL UNION ALL 
        SELECT 2053, 'Bong',123,0,NULL,1, 'LR-BG', NULL UNION ALL 
        SELECT 2054, 'Gbarpolu',123,0,NULL,1, 'LR-GP', NULL UNION ALL 
        SELECT 2055, 'Grand Bassa',123,0,NULL,1, 'LR-GB', NULL UNION ALL 
        SELECT 2056, 'Grand Cape Mount',123,0,NULL,1, 'LR-CM', NULL UNION ALL 
        SELECT 2057, 'Grand Gedeh',123,0,NULL,1, 'LR-GG', NULL UNION ALL 
        SELECT 2058, 'Grand Kru',123,0,NULL,1, 'LR-GK', NULL UNION ALL 
        SELECT 2059, 'Lofa',123,0,NULL,1, 'LR-LO', NULL UNION ALL 
        SELECT 2060, 'Margibi',123,0,NULL,1, 'LR-MG', NULL UNION ALL 
        SELECT 2061, 'Maryland',123,0,NULL,1, 'LR-MY', NULL UNION ALL 
        SELECT 2062, 'Montserrado',123,0,NULL,1, 'LR-MO', NULL UNION ALL 
        SELECT 2063, 'Nimba',123,0,NULL,1, 'LR-NI', NULL UNION ALL 
        SELECT 2064, 'River Cess',123,0,NULL,1, 'LR-RI', NULL UNION ALL 
        SELECT 2065, 'River Gee',123,0,NULL,1, 'LR-RG', NULL UNION ALL 
        SELECT 2066, 'Sinoe',123,0,NULL,1, 'LR-SI', NULL UNION ALL 
        SELECT 2067, 'Al Butnan',124,0,NULL,1, 'LY-BU', NULL UNION ALL 
        SELECT 2068, 'Al Jabal al Akh?ar',124,0,NULL,1, 'LY-JA', NULL UNION ALL 
        SELECT 2069, 'Al Jabal al Gharbi',124,0,NULL,1, 'LY-JG', NULL UNION ALL 
        SELECT 2070, 'Al Jafarah',124,0,NULL,1, 'LY-JI', NULL UNION ALL 
        SELECT 2071, 'Al Jufrah',124,0,NULL,1, 'LY-JU', NULL UNION ALL 
        SELECT 2072, 'Al Kufrah',124,0,NULL,1, 'LY-KF', NULL UNION ALL 
        SELECT 2073, 'Al Marj',124,0,NULL,1, 'LY-MJ', NULL UNION ALL 
        SELECT 2074, 'Al Marqab',124,0,NULL,1, 'LY-MB', NULL UNION ALL 
        SELECT 2075, 'Al Wa?at',124,0,NULL,1, 'LY-WA', NULL UNION ALL 
        SELECT 2076, 'An Nuqat al Khams',124,0,NULL,1, 'LY-NQ', NULL UNION ALL 
        SELECT 2077, 'Az Zawiyah',124,0,NULL,1, 'LY-ZA', NULL UNION ALL 
        SELECT 2078, 'Banghazi',124,0,NULL,1, 'LY-BA', NULL UNION ALL 
        SELECT 2079, 'Darnah',124,0,NULL,1, 'LY-DR', NULL UNION ALL 
        SELECT 2080, 'Ghat',124,0,NULL,1, 'LY-GT', NULL UNION ALL 
        SELECT 2081, 'Misratah',124,0,NULL,1, 'LY-MI', NULL UNION ALL 
        SELECT 2082, 'Murzuq',124,0,NULL,1, 'LY-MQ', NULL UNION ALL 
        SELECT 2083, 'Nalut',124,0,NULL,1, 'LY-NL', NULL UNION ALL 
        SELECT 2084, 'Sabha',124,0,NULL,1, 'LY-SB', NULL UNION ALL 
        SELECT 2085, 'Surt',124,0,NULL,1, 'LY-SR', NULL UNION ALL 
        SELECT 2086, 'Wadi al ?ayat',124,0,NULL,1, 'LY-WD', NULL UNION ALL 
        SELECT 2087, 'Wadi ash Shati’',124,0,NULL,1, 'LY-WS', NULL UNION ALL 
        SELECT 2088, 'Tarabulus',124,0,NULL,1, 'LY-TB', NULL UNION ALL 
        SELECT 2089, 'Balzers',125,0,NULL,1, 'LI-01', NULL UNION ALL 
        SELECT 2090, 'Eschen',125,0,NULL,1, 'LI-02', NULL UNION ALL 
        SELECT 2091, 'Gamprin',125,0,NULL,1, 'LI-03', NULL UNION ALL 
        SELECT 2092, 'Mauren',125,0,NULL,1, 'LI-04', NULL UNION ALL 
        SELECT 2093, 'Planken',125,0,NULL,1, 'LI-05', NULL UNION ALL 
        SELECT 2094, 'Ruggell',125,0,NULL,1, 'LI-06', NULL UNION ALL 
        SELECT 2095, 'Schaan',125,0,NULL,1, 'LI-07', NULL UNION ALL 
        SELECT 2096, 'Schellenberg',125,0,NULL,1, 'LI-08', NULL UNION ALL 
        SELECT 2097, 'Triesen',125,0,NULL,1, 'LI-09', NULL UNION ALL 
        SELECT 2098, 'Triesenberg',125,0,NULL,1, 'LI-10', NULL UNION ALL 
        SELECT 2099, 'Vaduz',125,0,NULL,1, 'LI-11', NULL UNION ALL 
        SELECT 2100, 'Akmene',126,0,NULL,1, 'LT-01', NULL UNION ALL 
        SELECT 2101, 'Alytaus apskritis',126,0,NULL,1, 'LT-AL', NULL UNION ALL 
        SELECT 2102, 'Alytaus miestas',126,0,NULL,1, 'LT-02', NULL UNION ALL 
        SELECT 2103, 'Alytus',126,0,NULL,1, 'LT-03', NULL UNION ALL 
        SELECT 2104, 'Anykšciai',126,0,NULL,1, 'LT-04', NULL UNION ALL 
        SELECT 2105, 'Birštono',126,0,NULL,1, 'LT-05', NULL UNION ALL 
        SELECT 2106, 'Biržai',126,0,NULL,1, 'LT-06', NULL UNION ALL 
        SELECT 2107, 'Druskininkai',126,0,NULL,1, 'LT-07', NULL UNION ALL 
        SELECT 2108, 'Elektrenai',126,0,NULL,1, 'LT-08', NULL UNION ALL 
        SELECT 2109, 'Ignalina',126,0,NULL,1, 'LT-09', NULL UNION ALL 
        SELECT 2110, 'Jonava',126,0,NULL,1, 'LT-10', NULL UNION ALL 
        SELECT 2111, 'Joniškis',126,0,NULL,1, 'LT-11', NULL UNION ALL 
        SELECT 2112, 'Jurbarkas',126,0,NULL,1, 'LT-12', NULL UNION ALL 
        SELECT 2113, 'Kaišiadorys',126,0,NULL,1, 'LT-13', NULL UNION ALL 
        SELECT 2114, 'Kalvarijos',126,0,NULL,1, 'LT-14', NULL UNION ALL 
        SELECT 2115, 'Kaunas',126,0,NULL,1, 'LT-16', NULL UNION ALL 
        SELECT 2116, 'Kauno apskritis',126,0,NULL,1, 'LT-KU', NULL UNION ALL 
        SELECT 2117, 'Kauno miestas',126,0,NULL,1, 'LT-15', NULL UNION ALL 
        SELECT 2118, 'Kazlu Rudos',126,0,NULL,1, 'LT-17', NULL UNION ALL 
        SELECT 2119, 'Kelme',126,0,NULL,1, 'LT-19', NULL UNION ALL 
        SELECT 2120, 'Klaipeda',126,0,NULL,1, 'LT-21', NULL UNION ALL 
        SELECT 2121, 'Klaipedos apskritis',126,0,NULL,1, 'LT-KL', NULL UNION ALL 
        SELECT 2122, 'Klaipedos miestas',126,0,NULL,1, 'LT-20', NULL UNION ALL 
        SELECT 2123, 'Kretinga',126,0,NULL,1, 'LT-22', NULL UNION ALL 
        SELECT 2124, 'Kupiškis',126,0,NULL,1, 'LT-23', NULL UNION ALL 
        SELECT 2125, 'Kedainiai',126,0,NULL,1, 'LT-18', NULL UNION ALL 
        SELECT 2126, 'Lazdijai',126,0,NULL,1, 'LT-24', NULL UNION ALL 
        SELECT 2127, 'Marijampole',126,0,NULL,1, 'LT-25', NULL UNION ALL 
        SELECT 2128, 'Marijampoles apskritis',126,0,NULL,1, 'LT-MR', NULL UNION ALL 
        SELECT 2129, 'Mažeikiai',126,0,NULL,1, 'LT-26', NULL UNION ALL 
        SELECT 2130, 'Moletai',126,0,NULL,1, 'LT-27', NULL UNION ALL 
        SELECT 2131, 'Neringa',126,0,NULL,1, 'LT-28', NULL UNION ALL 
        SELECT 2132, 'Pagegiai',126,0,NULL,1, 'LT-29', NULL UNION ALL 
        SELECT 2133, 'Pakruojis',126,0,NULL,1, 'LT-30', NULL UNION ALL 
        SELECT 2134, 'Palangos miestas',126,0,NULL,1, 'LT-31', NULL UNION ALL 
        SELECT 2135, 'Panevežio apskritis',126,0,NULL,1, 'LT-PN', NULL UNION ALL 
        SELECT 2136, 'Panevežio miestas',126,0,NULL,1, 'LT-32', NULL UNION ALL 
        SELECT 2137, 'Panevežys',126,0,NULL,1, 'LT-33', NULL UNION ALL 
        SELECT 2138, 'Pasvalys',126,0,NULL,1, 'LT-34', NULL UNION ALL 
        SELECT 2139, 'Plunge',126,0,NULL,1, 'LT-35', NULL UNION ALL 
        SELECT 2140, 'Prienai',126,0,NULL,1, 'LT-36', NULL UNION ALL 
        SELECT 2141, 'Radviliškis',126,0,NULL,1, 'LT-37', NULL UNION ALL 
        SELECT 2142, 'Raseiniai',126,0,NULL,1, 'LT-38', NULL UNION ALL 
        SELECT 2143, 'Rietavo',126,0,NULL,1, 'LT-39', NULL UNION ALL 
        SELECT 2144, 'Rokiškis',126,0,NULL,1, 'LT-40', NULL UNION ALL 
        SELECT 2145, 'Skuodas',126,0,NULL,1, 'LT-48', NULL UNION ALL 
        SELECT 2146, 'Taurage',126,0,NULL,1, 'LT-50', NULL UNION ALL 
        SELECT 2147, 'Taurages apskritis',126,0,NULL,1, 'LT-TA', NULL UNION ALL 
        SELECT 2148, 'Telšiai',126,0,NULL,1, 'LT-51', NULL UNION ALL 
        SELECT 2149, 'Telšiu apskritis',126,0,NULL,1, 'LT-TE', NULL UNION ALL 
        SELECT 2150, 'Trakai',126,0,NULL,1, 'LT-52', NULL UNION ALL 
        SELECT 2151, 'Ukmerge',126,0,NULL,1, 'LT-53', NULL UNION ALL 
        SELECT 2152, 'Utena',126,0,NULL,1, 'LT-54', NULL UNION ALL 
        SELECT 2153, 'Utenos apskritis',126,0,NULL,1, 'LT-UT', NULL UNION ALL 
        SELECT 2154, 'Varena',126,0,NULL,1, 'LT-55', NULL UNION ALL 
        SELECT 2155, 'Vilkaviškis',126,0,NULL,1, 'LT-56', NULL UNION ALL 
        SELECT 2156, 'Vilniaus apskritis',126,0,NULL,1, 'LT-VL', NULL UNION ALL 
        SELECT 2157, 'Vilniaus miestas',126,0,NULL,1, 'LT-57', NULL UNION ALL 
        SELECT 2158, 'Vilnius',126,0,NULL,1, 'LT-58', NULL UNION ALL 
        SELECT 2159, 'Visaginas',126,0,NULL,1, 'LT-59', NULL UNION ALL 
        SELECT 2160, 'Zarasai',126,0,NULL,1, 'LT-60', NULL UNION ALL 
        SELECT 2161, 'Šakiai',126,0,NULL,1, 'LT-41', NULL UNION ALL 
        SELECT 2162, 'Šalcininkai',126,0,NULL,1, 'LT-42', NULL UNION ALL 
        SELECT 2163, 'Šiauliai',126,0,NULL,1, 'LT-44', NULL UNION ALL 
        SELECT 2164, 'Šiauliu apskritis',126,0,NULL,1, 'LT-SA', NULL UNION ALL 
        SELECT 2165, 'Šiauliu miestas',126,0,NULL,1, 'LT-43', NULL UNION ALL 
        SELECT 2166, 'Šilale',126,0,NULL,1, 'LT-45', NULL UNION ALL 
        SELECT 2167, 'Šilute',126,0,NULL,1, 'LT-46', NULL UNION ALL 
        SELECT 2168, 'Širvintos',126,0,NULL,1, 'LT-47', NULL UNION ALL 
        SELECT 2169, 'Švencionys',126,0,NULL,1, 'LT-49', NULL UNION ALL 
        SELECT 2170, 'Antananarivo',129,0,NULL,1, 'MG-T', NULL UNION ALL 
        SELECT 2171, 'Antsiranana',129,0,NULL,1, 'MG-D', NULL UNION ALL 
        SELECT 2172, 'Fianarantsoa',129,0,NULL,1, 'MG-F', NULL UNION ALL 
        SELECT 2173, 'Mahajanga',129,0,NULL,1, 'MG-M', NULL UNION ALL 
        SELECT 2174, 'Toamasina',129,0,NULL,1, 'MG-A', NULL UNION ALL 
        SELECT 2175, 'Toliara',129,0,NULL,1, 'MG-U', NULL UNION ALL 
        SELECT 2176, 'Johor',131,0,NULL,1, 'MY-01', NULL UNION ALL 
        SELECT 2177, 'Kedah',131,0,NULL,1, 'MY-02', NULL UNION ALL 
        SELECT 2178, 'Kelantan',131,0,NULL,1, 'MY-03', NULL UNION ALL 
        SELECT 2179, 'Melaka',131,0,NULL,1, 'MY-04', NULL UNION ALL 
        SELECT 2180, 'Negeri Sembilan',131,0,NULL,1, 'MY-05', NULL UNION ALL 
        SELECT 2181, 'Pahang',131,0,NULL,1, 'MY-06', NULL UNION ALL 
        SELECT 2182, 'Perak',131,0,NULL,1, 'MY-08', NULL UNION ALL 
        SELECT 2183, 'Perlis',131,0,NULL,1, 'MY-09', NULL UNION ALL 
        SELECT 2184, 'Pulau Pinang',131,0,NULL,1, 'MY-07', NULL UNION ALL 
        SELECT 2185, 'Sabah',131,0,NULL,1, 'MY-12', NULL UNION ALL 
        SELECT 2186, 'Sarawak',131,0,NULL,1, 'MY-13', NULL UNION ALL 
        SELECT 2187, 'Selangor',131,0,NULL,1, 'MY-10', NULL UNION ALL 
        SELECT 2188, 'Terengganu',131,0,NULL,1, 'MY-11', NULL UNION ALL 
        SELECT 2189, 'Wilayah Persekutuan Kuala Lumpur',131,0,NULL,1, 'MY-14', NULL UNION ALL 
        SELECT 2190, 'Wilayah Persekutuan Labuan',131,0,NULL,1, 'MY-15', NULL UNION ALL 
        SELECT 2191, 'Wilayah Persekutuan Putrajaya',131,0,NULL,1, 'MY-16', NULL UNION ALL 
        SELECT 2192, 'Bamako',133,0,NULL,1, 'ML-BKO', NULL UNION ALL 
        SELECT 2193, 'Gao',133,0,NULL,1, 'ML-7', NULL UNION ALL 
        SELECT 2194, 'Kayes',133,0,NULL,1, 'ML-1', NULL UNION ALL 
        SELECT 2195, 'Kidal',133,0,NULL,1, 'ML-8', NULL UNION ALL 
        SELECT 2196, 'Koulikoro',133,0,NULL,1, 'ML-2', NULL UNION ALL 
        SELECT 2197, 'Mopti',133,0,NULL,1, 'ML-5', NULL UNION ALL 
        SELECT 2198, 'Ménaka',133,0,NULL,1, 'ML-9', NULL UNION ALL 
        SELECT 2199, 'Sikasso',133,0,NULL,1, 'ML-3', NULL UNION ALL 
        SELECT 2200, 'Ségou',133,0,NULL,1, 'ML-4', NULL UNION ALL 
        SELECT 2201, 'Taoudénit',133,0,NULL,1, 'ML-10', NULL UNION ALL 
        SELECT 2202, 'Tombouctou',133,0,NULL,1, 'ML-6', NULL UNION ALL 
        SELECT 2203, 'Agalega Islands',138,0,NULL,1, 'MU-AG', NULL UNION ALL 
        SELECT 2204, 'Beau Bassin-Rose Hill',138,0,NULL,1, 'MU-BR', NULL UNION ALL 
        SELECT 2205, 'Black River',138,0,NULL,1, 'MU-BL', NULL UNION ALL 
        SELECT 2206, 'Cargados Carajos Shoals',138,0,NULL,1, 'MU-CC', NULL UNION ALL 
        SELECT 2207, 'Curepipe',138,0,NULL,1, 'MU-CU', NULL UNION ALL 
        SELECT 2208, 'Flacq',138,0,NULL,1, 'MU-FL', NULL UNION ALL 
        SELECT 2209, 'Grand Port',138,0,NULL,1, 'MU-GP', NULL UNION ALL 
        SELECT 2210, 'Moka',138,0,NULL,1, 'MU-MO', NULL UNION ALL 
        SELECT 2211, 'Pamplemousses',138,0,NULL,1, 'MU-PA', NULL UNION ALL 
        SELECT 2212, 'Plaines Wilhems',138,0,NULL,1, 'MU-PW', NULL UNION ALL 
        SELECT 2213, 'Port Louis',138,0,NULL,1, 'MU-PU', NULL UNION ALL 
        SELECT 2214, 'Port Louis',138,0,NULL,1, 'MU-PL', NULL UNION ALL 
        SELECT 2215, 'Quatre Bornes',138,0,NULL,1, 'MU-QB', NULL UNION ALL 
        SELECT 2216, 'Rivière du Rempart',138,0,NULL,1, 'MU-RR', NULL UNION ALL 
        SELECT 2217, 'Rodrigues Island',138,0,NULL,1, 'MU-RO', NULL UNION ALL 
        SELECT 2218, 'Savanne',138,0,NULL,1, 'MU-SA', NULL UNION ALL 
        SELECT 2219, 'Vacoas-Phoenix',138,0,NULL,1, 'MU-VP', NULL UNION ALL 
        SELECT 2220, 'Aguascalientes',140,0,NULL,1, 'MX-AGU', NULL UNION ALL 
        SELECT 2221, 'Baja California',140,0,NULL,1, 'MX-BCN', NULL UNION ALL 
        SELECT 2222, 'Baja California Sur',140,0,NULL,1, 'MX-BCS', NULL UNION ALL 
        SELECT 2223, 'Campeche',140,0,NULL,1, 'MX-CAM', NULL UNION ALL 
        SELECT 2224, 'Chiapas',140,0,NULL,1, 'MX-CHP', NULL UNION ALL 
        SELECT 2225, 'Chihuahua',140,0,NULL,1, 'MX-CHH', NULL UNION ALL 
        SELECT 2226, 'Ciudad de México',140,0,NULL,1, 'MX-CMX', NULL UNION ALL 
        SELECT 2227, 'Coahuila de Zaragoza',140,0,NULL,1, 'MX-COA', NULL UNION ALL 
        SELECT 2228, 'Colima',140,0,NULL,1, 'MX-COL', NULL UNION ALL 
        SELECT 2229, 'Durango',140,0,NULL,1, 'MX-DUR', NULL UNION ALL 
        SELECT 2230, 'Guanajuato',140,0,NULL,1, 'MX-GUA', NULL UNION ALL 
        SELECT 2231, 'Guerrero',140,0,NULL,1, 'MX-GRO', NULL UNION ALL 
        SELECT 2232, 'Hidalgo',140,0,NULL,1, 'MX-HID', NULL UNION ALL 
        SELECT 2233, 'Jalisco',140,0,NULL,1, 'MX-JAL', NULL UNION ALL 
        SELECT 2234, 'Michoacán de Ocampo',140,0,NULL,1, 'MX-MIC', NULL UNION ALL 
        SELECT 2235, 'Morelos',140,0,NULL,1, 'MX-MOR', NULL UNION ALL 
        SELECT 2236, 'México',140,0,NULL,1, 'MX-MEX', NULL UNION ALL 
        SELECT 2237, 'Nayarit',140,0,NULL,1, 'MX-NAY', NULL UNION ALL 
        SELECT 2238, 'Nuevo León',140,0,NULL,1, 'MX-NLE', NULL UNION ALL 
        SELECT 2239, 'Oaxaca',140,0,NULL,1, 'MX-OAX', NULL UNION ALL 
        SELECT 2240, 'Puebla',140,0,NULL,1, 'MX-PUE', NULL UNION ALL 
        SELECT 2241, 'Querétaro',140,0,NULL,1, 'MX-QUE', NULL UNION ALL 
        SELECT 2242, 'Quintana Roo',140,0,NULL,1, 'MX-ROO', NULL UNION ALL 
        SELECT 2243, 'San Luis Potosí',140,0,NULL,1, 'MX-SLP', NULL UNION ALL 
        SELECT 2244, 'Sinaloa',140,0,NULL,1, 'MX-SIN', NULL UNION ALL 
        SELECT 2245, 'Sonora',140,0,NULL,1, 'MX-SON', NULL UNION ALL 
        SELECT 2246, 'Tabasco',140,0,NULL,1, 'MX-TAB', NULL UNION ALL 
        SELECT 2247, 'Tamaulipas',140,0,NULL,1, 'MX-TAM', NULL UNION ALL 
        SELECT 2248, 'Tlaxcala',140,0,NULL,1, 'MX-TLA', NULL UNION ALL 
        SELECT 2249, 'Veracruz de Ignacio de la Llave',140,0,NULL,1, 'MX-VER', NULL UNION ALL 
        SELECT 2250, 'Yucatán',140,0,NULL,1, 'MX-YUC', NULL UNION ALL 
        SELECT 2251, 'Zacatecas',140,0,NULL,1, 'MX-ZAC', NULL UNION ALL 
        SELECT 2252, 'Chuuk',141,0,NULL,1, 'FM-TRK', NULL UNION ALL 
        SELECT 2253, 'Kosrae',141,0,NULL,1, 'FM-KSA', NULL UNION ALL 
        SELECT 2254, 'Pohnpei',141,0,NULL,1, 'FM-PNI', NULL UNION ALL 
        SELECT 2255, 'Yap',141,0,NULL,1, 'FM-YAP', NULL UNION ALL 
        SELECT 2256, 'Anenii Noi',142,0,NULL,1, 'MD-AN', NULL UNION ALL 
        SELECT 2257, 'Basarabeasca',142,0,NULL,1, 'MD-BS', NULL UNION ALL 
        SELECT 2258, 'Bender [Tighina]',142,0,NULL,1, 'MD-BD', NULL UNION ALL 
        SELECT 2259, 'Briceni',142,0,NULL,1, 'MD-BR', NULL UNION ALL 
        SELECT 2260, 'Bal?i',142,0,NULL,1, 'MD-BA', NULL UNION ALL 
        SELECT 2261, 'Cahul',142,0,NULL,1, 'MD-CA', NULL UNION ALL 
        SELECT 2262, 'Cantemir',142,0,NULL,1, 'MD-CT', NULL UNION ALL 
        SELECT 2263, 'Chi?inau',142,0,NULL,1, 'MD-CU', NULL UNION ALL 
        SELECT 2264, 'Cimi?lia',142,0,NULL,1, 'MD-CM', NULL UNION ALL 
        SELECT 2265, 'Criuleni',142,0,NULL,1, 'MD-CR', NULL UNION ALL 
        SELECT 2266, 'Calara?i',142,0,NULL,1, 'MD-CL', NULL UNION ALL 
        SELECT 2267, 'Cau?eni',142,0,NULL,1, 'MD-CS', NULL UNION ALL 
        SELECT 2268, 'Dondu?eni',142,0,NULL,1, 'MD-DO', NULL UNION ALL 
        SELECT 2269, 'Drochia',142,0,NULL,1, 'MD-DR', NULL UNION ALL 
        SELECT 2270, 'Dubasari',142,0,NULL,1, 'MD-DU', NULL UNION ALL 
        SELECT 2271, 'Edine?',142,0,NULL,1, 'MD-ED', NULL UNION ALL 
        SELECT 2272, 'Flore?ti',142,0,NULL,1, 'MD-FL', NULL UNION ALL 
        SELECT 2273, 'Fale?ti',142,0,NULL,1, 'MD-FA', NULL UNION ALL 
        SELECT 2274, 'Glodeni',142,0,NULL,1, 'MD-GL', NULL UNION ALL 
        SELECT 2275, 'Gagauzia, Unitatea teritoriala autonoma (UTAG)',142,0,NULL,1, 'MD-GA', NULL UNION ALL 
        SELECT 2276, 'Hînce?ti',142,0,NULL,1, 'MD-HI', NULL UNION ALL 
        SELECT 2277, 'Ialoveni',142,0,NULL,1, 'MD-IA', NULL UNION ALL 
        SELECT 2278, 'Leova',142,0,NULL,1, 'MD-LE', NULL UNION ALL 
        SELECT 2279, 'Nisporeni',142,0,NULL,1, 'MD-NI', NULL UNION ALL 
        SELECT 2280, 'Ocni?a',142,0,NULL,1, 'MD-OC', NULL UNION ALL 
        SELECT 2281, 'Orhei',142,0,NULL,1, 'MD-OR', NULL UNION ALL 
        SELECT 2282, 'Rezina',142,0,NULL,1, 'MD-RE', NULL UNION ALL 
        SELECT 2283, 'Rî?cani',142,0,NULL,1, 'MD-RI', NULL UNION ALL 
        SELECT 2284, 'Soroca',142,0,NULL,1, 'MD-SO', NULL UNION ALL 
        SELECT 2285, 'Stra?eni',142,0,NULL,1, 'MD-ST', NULL UNION ALL 
        SELECT 2286, 'Stînga Nistrului, unitatea teritoriala din',142,0,NULL,1, 'MD-SN', NULL UNION ALL 
        SELECT 2287, 'Sîngerei',142,0,NULL,1, 'MD-SI', NULL UNION ALL 
        SELECT 2288, 'Taraclia',142,0,NULL,1, 'MD-TA', NULL UNION ALL 
        SELECT 2289, 'Telene?ti',142,0,NULL,1, 'MD-TE', NULL UNION ALL 
        SELECT 2290, 'Ungheni',142,0,NULL,1, 'MD-UN', NULL UNION ALL 
        SELECT 2291, '?oldane?ti',142,0,NULL,1, 'MD-SD', NULL UNION ALL 
        SELECT 2292, '?tefan Voda',142,0,NULL,1, 'MD-SV', NULL UNION ALL 
        SELECT 2293, 'Fontvieille',143,0,NULL,1, 'MC-FO', NULL UNION ALL 
        SELECT 2294, 'Jardin Exotique',143,0,NULL,1, 'MC-JE', NULL UNION ALL 
        SELECT 2295, 'La Colle',143,0,NULL,1, 'MC-CL', NULL UNION ALL 
        SELECT 2296, 'La Condamine',143,0,NULL,1, 'MC-CO', NULL UNION ALL 
        SELECT 2297, 'La Gare',143,0,NULL,1, 'MC-GA', NULL UNION ALL 
        SELECT 2298, 'La Source',143,0,NULL,1, 'MC-SO', NULL UNION ALL 
        SELECT 2299, 'Larvotto',143,0,NULL,1, 'MC-LA', NULL UNION ALL 
        SELECT 2300, 'Malbousquet',143,0,NULL,1, 'MC-MA', NULL UNION ALL 
        SELECT 2301, 'Monaco-Ville',143,0,NULL,1, 'MC-MO', NULL UNION ALL 
        SELECT 2302, 'Moneghetti',143,0,NULL,1, 'MC-MG', NULL UNION ALL 
        SELECT 2303, 'Monte-Carlo',143,0,NULL,1, 'MC-MC', NULL UNION ALL 
        SELECT 2304, 'Moulins',143,0,NULL,1, 'MC-MU', NULL UNION ALL 
        SELECT 2305, 'Port-Hercule',143,0,NULL,1, 'MC-PH', NULL UNION ALL 
        SELECT 2306, 'Saint-Roman',143,0,NULL,1, 'MC-SR', NULL UNION ALL 
        SELECT 2307, 'Sainte-Dévote',143,0,NULL,1, 'MC-SD', NULL UNION ALL 
        SELECT 2308, 'Spélugues',143,0,NULL,1, 'MC-SP', NULL UNION ALL 
        SELECT 2309, 'Vallon de la Rousse',143,0,NULL,1, 'MC-VR', NULL UNION ALL 
        SELECT 2310, 'Arhangay',144,0,NULL,1, 'MN-073', NULL UNION ALL 
        SELECT 2311, 'Bayan-Ölgiy',144,0,NULL,1, 'MN-071', NULL UNION ALL 
        SELECT 2312, 'Bayanhongor',144,0,NULL,1, 'MN-069', NULL UNION ALL 
        SELECT 2313, 'Bulgan',144,0,NULL,1, 'MN-067', NULL UNION ALL 
        SELECT 2314, 'Darhan uul',144,0,NULL,1, 'MN-037', NULL UNION ALL 
        SELECT 2315, 'Dornod',144,0,NULL,1, 'MN-061', NULL UNION ALL 
        SELECT 2316, 'Dornogovi',144,0,NULL,1, 'MN-063', NULL UNION ALL 
        SELECT 2317, 'Dundgovi',144,0,NULL,1, 'MN-059', NULL UNION ALL 
        SELECT 2318, 'Dzavhan',144,0,NULL,1, 'MN-057', NULL UNION ALL 
        SELECT 2319, 'Govi-Altay',144,0,NULL,1, 'MN-065', NULL UNION ALL 
        SELECT 2320, 'Govi-Sümber',144,0,NULL,1, 'MN-064', NULL UNION ALL 
        SELECT 2321, 'Hentiy',144,0,NULL,1, 'MN-039', NULL UNION ALL 
        SELECT 2322, 'Hovd',144,0,NULL,1, 'MN-043', NULL UNION ALL 
        SELECT 2323, 'Hövsgöl',144,0,NULL,1, 'MN-041', NULL UNION ALL 
        SELECT 2324, 'Orhon',144,0,NULL,1, 'MN-035', NULL UNION ALL 
        SELECT 2325, 'Selenge',144,0,NULL,1, 'MN-049', NULL UNION ALL 
        SELECT 2326, 'Sühbaatar',144,0,NULL,1, 'MN-051', NULL UNION ALL 
        SELECT 2327, 'Töv',144,0,NULL,1, 'MN-047', NULL UNION ALL 
        SELECT 2328, 'Ulaanbaatar',144,0,NULL,1, 'MN-1', NULL UNION ALL 
        SELECT 2329, 'Uvs',144,0,NULL,1, 'MN-046', NULL UNION ALL 
        SELECT 2330, 'Ömnögovi',144,0,NULL,1, 'MN-053', NULL UNION ALL 
        SELECT 2331, 'Övörhangay',144,0,NULL,1, 'MN-055', NULL UNION ALL 
        SELECT 2332, 'Agadir-Ida-Ou-Tanane',146,0,NULL,1, 'MA-AGD', 'MA-09' UNION ALL 
        SELECT 2333, 'Al Haouz',146,0,NULL,1, 'MA-HAO', 'MA-07' UNION ALL 
        SELECT 2334, 'Al Hoceïma',146,0,NULL,1, 'MA-HOC', 'MA-01' UNION ALL 
        SELECT 2335, 'Aousserd (EH)',146,0,NULL,1, 'MA-AOU', 'MA-12' UNION ALL 
        SELECT 2336, 'Assa-Zag (EH-partial)',146,0,NULL,1, 'MA-ASZ', 'MA-10' UNION ALL 
        SELECT 2337, 'Azilal',146,0,NULL,1, 'MA-AZI', 'MA-05' UNION ALL 
        SELECT 2338, 'Benslimane',146,0,NULL,1, 'MA-BES', 'MA-06' UNION ALL 
        SELECT 2339, 'Berkane',146,0,NULL,1, 'MA-BER', 'MA-02' UNION ALL 
        SELECT 2340, 'Berrechid',146,0,NULL,1, 'MA-BRR', 'MA-06' UNION ALL 
        SELECT 2341, 'Boujdour (EH)',146,0,NULL,1, 'MA-BOD', 'MA-11' UNION ALL 
        SELECT 2342, 'Boulemane',146,0,NULL,1, 'MA-BOM', 'MA-03' UNION ALL 
        SELECT 2343, 'Béni Mellal',146,0,NULL,1, 'MA-BEM', 'MA-05' UNION ALL 
        SELECT 2344, 'Béni Mellal-Khénifra',146,0,NULL,1, 'MA-05', NULL UNION ALL 
        SELECT 2345, 'Casablanca',146,0,NULL,1, 'MA-CAS', 'MA-06' UNION ALL 
        SELECT 2346, 'Casablanca-Settat',146,0,NULL,1, 'MA-06', NULL UNION ALL 
        SELECT 2347, 'Chefchaouen',146,0,NULL,1, 'MA-CHE', 'MA-01' UNION ALL 
        SELECT 2348, 'Chichaoua',146,0,NULL,1, 'MA-CHI', 'MA-07' UNION ALL 
        SELECT 2349, 'Chtouka-Ait Baha',146,0,NULL,1, 'MA-CHT', 'MA-06' UNION ALL 
        SELECT 2350, 'Dakhla-Oued Ed-Dahab (EH)',146,0,NULL,1, 'MA-12', NULL UNION ALL 
        SELECT 2351, 'Driouch',146,0,NULL,1, 'MA-DRI', 'MA-02' UNION ALL 
        SELECT 2352, 'Drâa-Tafilalet',146,0,NULL,1, 'MA-08', NULL UNION ALL 
        SELECT 2353, 'El Hajeb',146,0,NULL,1, 'MA-HAJ', 'MA-03' UNION ALL 
        SELECT 2354, 'El Jadida',146,0,NULL,1, 'MA-JDI', 'MA-06' UNION ALL 
        SELECT 2355, 'El Kelâa des Sraghna',146,0,NULL,1, 'MA-KES', 'MA-07' UNION ALL 
        SELECT 2356, 'Errachidia',146,0,NULL,1, 'MA-ERR', 'MA-08' UNION ALL 
        SELECT 2357, 'Es-Semara (EH-partial)',146,0,NULL,1, 'MA-ESM', 'MA-11' UNION ALL 
        SELECT 2358, 'Essaouira',146,0,NULL,1, 'MA-ESI', 'MA-07' UNION ALL 
        SELECT 2359, 'Fahs-Anjra',146,0,NULL,1, 'MA-FAH', 'MA-01' UNION ALL 
        SELECT 2360, 'Figuig',146,0,NULL,1, 'MA-FIG', 'MA-02' UNION ALL 
        SELECT 2361, 'Fquih Ben Salah',146,0,NULL,1, 'MA-FQH', 'MA-05' UNION ALL 
        SELECT 2362, 'Fès',146,0,NULL,1, 'MA-FES', 'MA-03' UNION ALL 
        SELECT 2363, 'Fès-Meknès',146,0,NULL,1, 'MA-03', NULL UNION ALL 
        SELECT 2364, 'Guelmim',146,0,NULL,1, 'MA-GUE', 'MA-10' UNION ALL 
        SELECT 2365, 'Guelmim-Oued Noun (EH-partial)',146,0,NULL,1, 'MA-10', NULL UNION ALL 
        SELECT 2366, 'Guercif',146,0,NULL,1, 'MA-GUF', 'MA-02' UNION ALL 
        SELECT 2367, 'Ifrane',146,0,NULL,1, 'MA-IFR', 'MA-03' UNION ALL 
        SELECT 2368, 'Inezgane-Ait Melloul',146,0,NULL,1, 'MA-INE', 'MA-09' UNION ALL 
        SELECT 2369, 'Jerada',146,0,NULL,1, 'MA-JRA', 'MA-02' UNION ALL 
        SELECT 2370, 'Khemisset',146,0,NULL,1, 'MA-KHE', 'MA-04' UNION ALL 
        SELECT 2371, 'Khenifra',146,0,NULL,1, 'MA-KHN', 'MA-05' UNION ALL 
        SELECT 2372, 'Khouribga',146,0,NULL,1, 'MA-KHO', 'MA-05' UNION ALL 
        SELECT 2373, 'Kénitra',146,0,NULL,1, 'MA-KEN', 'MA-04' UNION ALL 
        SELECT 2374, 'L''Oriental',146,0,NULL,1, 'MA-02', NULL UNION ALL 
        SELECT 2375, 'Larache',146,0,NULL,1, 'MA-LAR', 'MA-01' UNION ALL 
        SELECT 2376, 'Laâyoune (EH)',146,0,NULL,1, 'MA-LAA', 'MA-11' UNION ALL 
        SELECT 2377, 'Laâyoune-Sakia El Hamra (EH-partial)',146,0,NULL,1, 'MA-11', NULL UNION ALL 
        SELECT 2378, 'Marrakech',146,0,NULL,1, 'MA-MAR', 'MA-07' UNION ALL 
        SELECT 2379, 'Marrakech-Safi',146,0,NULL,1, 'MA-07', NULL UNION ALL 
        SELECT 2380, 'Meknès',146,0,NULL,1, 'MA-MEK', 'MA-03' UNION ALL 
        SELECT 2381, 'Midelt',146,0,NULL,1, 'MA-MID', 'MA-08' UNION ALL 
        SELECT 2382, 'Mohammadia',146,0,NULL,1, 'MA-MOH', 'MA-06' UNION ALL 
        SELECT 2383, 'Moulay Yacoub',146,0,NULL,1, 'MA-MOU', 'MA-03' UNION ALL 
        SELECT 2384, 'Médiouna',146,0,NULL,1, 'MA-MED', 'MA-06' UNION ALL 
        SELECT 2385, 'M’diq-Fnideq',146,0,NULL,1, 'MA-MDF', 'MA-01' UNION ALL 
        SELECT 2386, 'Nador',146,0,NULL,1, 'MA-NAD', 'MA-02' UNION ALL 
        SELECT 2387, 'Nouaceur',146,0,NULL,1, 'MA-NOU', 'MA-04' UNION ALL 
        SELECT 2388, 'Ouarzazate',146,0,NULL,1, 'MA-OUA', 'MA-08' UNION ALL 
        SELECT 2389, 'Oued Ed-Dahab (EH)',146,0,NULL,1, 'MA-OUD', 'MA-12' UNION ALL 
        SELECT 2390, 'Ouezzane',146,0,NULL,1, 'MA-OUZ', 'MA-01' UNION ALL 
        SELECT 2391, 'Oujda-Angad',146,0,NULL,1, 'MA-OUJ', 'MA-02' UNION ALL 
        SELECT 2392, 'Rabat',146,0,NULL,1, 'MA-RAB', 'MA-04' UNION ALL 
        SELECT 2393, 'Rabat-Salé-Kénitra',146,0,NULL,1, 'MA-04', NULL UNION ALL 
        SELECT 2394, 'Rehamna',146,0,NULL,1, 'MA-REH', 'MA-07' UNION ALL 
        SELECT 2395, 'Safi',146,0,NULL,1, 'MA-SAF', 'MA-07' UNION ALL 
        SELECT 2396, 'Salé',146,0,NULL,1, 'MA-SAL', 'MA-04' UNION ALL 
        SELECT 2397, 'Sefrou',146,0,NULL,1, 'MA-SEF', 'MA-03' UNION ALL 
        SELECT 2398, 'Settat',146,0,NULL,1, 'MA-SET', 'MA-06' UNION ALL 
        SELECT 2399, 'Sidi Bennour',146,0,NULL,1, 'MA-SIB', 'MA-06' UNION ALL 
        SELECT 2400, 'Sidi Ifni',146,0,NULL,1, 'MA-SIF', 'MA-10' UNION ALL 
        SELECT 2401, 'Sidi Kacem',146,0,NULL,1, 'MA-SIK', 'MA-04' UNION ALL 
        SELECT 2402, 'Sidi Slimane',146,0,NULL,1, 'MA-SIL', 'MA-04' UNION ALL 
        SELECT 2403, 'Skhirate-Témara',146,0,NULL,1, 'MA-SKH', 'MA-04' UNION ALL 
        SELECT 2404, 'Souss-Massa',146,0,NULL,1, 'MA-09', NULL UNION ALL 
        SELECT 2405, 'Tan-Tan (EH-partial)',146,0,NULL,1, 'MA-TNT', 'MA-10' UNION ALL 
        SELECT 2406, 'Tanger-Assilah',146,0,NULL,1, 'MA-TNG', 'MA-01' UNION ALL 
        SELECT 2407, 'Tanger-Tétouan-Al Hoceïma',146,0,NULL,1, 'MA-01', NULL UNION ALL 
        SELECT 2408, 'Taounate',146,0,NULL,1, 'MA-TAO', 'MA-03' UNION ALL 
        SELECT 2409, 'Taourirt',146,0,NULL,1, 'MA-TAI', 'MA-02' UNION ALL 
        SELECT 2410, 'Tarfaya (EH-partial)',146,0,NULL,1, 'MA-TAF', 'MA-11' UNION ALL 
        SELECT 2411, 'Taroudant',146,0,NULL,1, 'MA-TAR', 'MA-09' UNION ALL 
        SELECT 2412, 'Tata',146,0,NULL,1, 'MA-TAT', 'MA-09' UNION ALL 
        SELECT 2413, 'Taza',146,0,NULL,1, 'MA-TAZ', 'MA-03' UNION ALL 
        SELECT 2414, 'Tinghir',146,0,NULL,1, 'MA-TIN', 'MA-08' UNION ALL 
        SELECT 2415, 'Tiznit',146,0,NULL,1, 'MA-TIZ', 'MA-09' UNION ALL 
        SELECT 2416, 'Tétouan',146,0,NULL,1, 'MA-TET', 'MA-01' UNION ALL 
        SELECT 2417, 'Youssoufia',146,0,NULL,1, 'MA-YUS', 'MA-07' UNION ALL 
        SELECT 2418, 'Zagora',146,0,NULL,1, 'MA-ZAG', 'MA-08' UNION ALL 
        SELECT 2419, 'Cabo Delgado',147,0,NULL,1, 'MZ-P', NULL UNION ALL 
        SELECT 2420, 'Gaza',147,0,NULL,1, 'MZ-G', NULL UNION ALL 
        SELECT 2421, 'Inhambane',147,0,NULL,1, 'MZ-I', NULL UNION ALL 
        SELECT 2422, 'Manica',147,0,NULL,1, 'MZ-B', NULL UNION ALL 
        SELECT 2423, 'Maputo',147,0,NULL,1, 'MZ-MPM', NULL UNION ALL 
        SELECT 2424, 'Maputo',147,0,NULL,1, 'MZ-L', NULL UNION ALL 
        SELECT 2425, 'Nampula',147,0,NULL,1, 'MZ-N', NULL UNION ALL 
        SELECT 2426, 'Niassa',147,0,NULL,1, 'MZ-A', NULL UNION ALL 
        SELECT 2427, 'Sofala',147,0,NULL,1, 'MZ-S', NULL UNION ALL 
        SELECT 2428, 'Tete',147,0,NULL,1, 'MZ-T', NULL UNION ALL 
        SELECT 2429, 'Zambézia',147,0,NULL,1, 'MZ-Q', NULL UNION ALL 
        SELECT 2430, 'Ayeyarwady',148,0,NULL,1, 'MM-07', NULL UNION ALL 
        SELECT 2431, 'Bago',148,0,NULL,1, 'MM-02', NULL UNION ALL 
        SELECT 2432, 'Chin',148,0,NULL,1, 'MM-14', NULL UNION ALL 
        SELECT 2433, 'Kachin',148,0,NULL,1, 'MM-11', NULL UNION ALL 
        SELECT 2434, 'Kayah',148,0,NULL,1, 'MM-12', NULL UNION ALL 
        SELECT 2435, 'Kayin',148,0,NULL,1, 'MM-13', NULL UNION ALL 
        SELECT 2436, 'Magway',148,0,NULL,1, 'MM-03', NULL UNION ALL 
        SELECT 2437, 'Mandalay',148,0,NULL,1, 'MM-04', NULL UNION ALL 
        SELECT 2438, 'Mon',148,0,NULL,1, 'MM-15', NULL UNION ALL 
        SELECT 2439, 'Nay Pyi Taw',148,0,NULL,1, 'MM-18', NULL UNION ALL 
        SELECT 2440, 'Rakhine',148,0,NULL,1, 'MM-16', NULL UNION ALL 
        SELECT 2441, 'Sagaing',148,0,NULL,1, 'MM-01', NULL UNION ALL 
        SELECT 2442, 'Shan',148,0,NULL,1, 'MM-17', NULL UNION ALL 
        SELECT 2443, 'Tanintharyi',148,0,NULL,1, 'MM-05', NULL UNION ALL 
        SELECT 2444, 'Yangon',148,0,NULL,1, 'MM-06', NULL UNION ALL 
        SELECT 2445, 'Erongo',149,0,NULL,1, 'NA-ER', NULL UNION ALL 
        SELECT 2446, 'Hardap',149,0,NULL,1, 'NA-HA', NULL UNION ALL 
        SELECT 2447, 'Karas',149,0,NULL,1, 'NA-KA', NULL UNION ALL 
        SELECT 2448, 'Kavango East',149,0,NULL,1, 'NA-KE', NULL UNION ALL 
        SELECT 2449, 'Kavango West',149,0,NULL,1, 'NA-KW', NULL UNION ALL 
        SELECT 2450, 'Khomas',149,0,NULL,1, 'NA-KH', NULL UNION ALL 
        SELECT 2451, 'Kunene',149,0,NULL,1, 'NA-KU', NULL UNION ALL 
        SELECT 2452, 'Ohangwena',149,0,NULL,1, 'NA-OW', NULL UNION ALL 
        SELECT 2453, 'Omaheke',149,0,NULL,1, 'NA-OH', NULL UNION ALL 
        SELECT 2454, 'Omusati',149,0,NULL,1, 'NA-OS', NULL UNION ALL 
        SELECT 2455, 'Oshana',149,0,NULL,1, 'NA-ON', NULL UNION ALL 
        SELECT 2456, 'Oshikoto',149,0,NULL,1, 'NA-OT', NULL UNION ALL 
        SELECT 2457, 'Otjozondjupa',149,0,NULL,1, 'NA-OD', NULL UNION ALL 
        SELECT 2458, 'Zambezi',149,0,NULL,1, 'NA-CA', NULL UNION ALL 
        SELECT 2459, 'Fryslân',152,0,NULL,1, 'NL-FR', NULL UNION ALL 
        SELECT 2460, 'Aruba',152,0,NULL,1, 'NL-AW', NULL UNION ALL 
        SELECT 2461, 'Bonaire',152,0,NULL,1, 'NL-BQ1', NULL UNION ALL 
        SELECT 2462, 'Curaçao',152,0,NULL,1, 'NL-CW', NULL UNION ALL 
        SELECT 2463, 'Drenthe',152,0,NULL,1, 'NL-DR', NULL UNION ALL 
        SELECT 2464, 'Flevoland',152,0,NULL,1, 'NL-FL', NULL UNION ALL 
        SELECT 2465, 'Gelderland',152,0,NULL,1, 'NL-GE', NULL UNION ALL 
        SELECT 2466, 'Groningen',152,0,NULL,1, 'NL-GR', NULL UNION ALL 
        SELECT 2467, 'Limburg',152,0,NULL,1, 'NL-LI', NULL UNION ALL 
        SELECT 2468, 'Noord-Brabant',152,0,NULL,1, 'NL-NB', NULL UNION ALL 
        SELECT 2469, 'Noord-Holland',152,0,NULL,1, 'NL-NH', NULL UNION ALL 
        SELECT 2470, 'Overijssel',152,0,NULL,1, 'NL-OV', NULL UNION ALL 
        SELECT 2471, 'Saba',152,0,NULL,1, 'NL-BQ2', NULL UNION ALL 
        SELECT 2472, 'Sint Eustatius',152,0,NULL,1, 'NL-BQ3', NULL UNION ALL 
        SELECT 2473, 'Sint Maarten',152,0,NULL,1, 'NL-SX', NULL UNION ALL 
        SELECT 2474, 'Utrecht',152,0,NULL,1, 'NL-UT', NULL UNION ALL 
        SELECT 2475, 'Zeeland',152,0,NULL,1, 'NL-ZE', NULL UNION ALL 
        SELECT 2476, 'Zuid-Holland',152,0,NULL,1, 'NL-ZH', NULL UNION ALL 
        SELECT 2477, 'Boaco',156,0,NULL,1, 'NI-BO', NULL UNION ALL 
        SELECT 2478, 'Carazo',156,0,NULL,1, 'NI-CA', NULL UNION ALL 
        SELECT 2479, 'Chinandega',156,0,NULL,1, 'NI-CI', NULL UNION ALL 
        SELECT 2480, 'Chontales',156,0,NULL,1, 'NI-CO', NULL UNION ALL 
        SELECT 2481, 'Costa Caribe Norte',156,0,NULL,1, 'NI-AN', NULL UNION ALL 
        SELECT 2482, 'Costa Caribe Sur',156,0,NULL,1, 'NI-AS', NULL UNION ALL 
        SELECT 2483, 'Estelí',156,0,NULL,1, 'NI-ES', NULL UNION ALL 
        SELECT 2484, 'Granada',156,0,NULL,1, 'NI-GR', NULL UNION ALL 
        SELECT 2485, 'Jinotega',156,0,NULL,1, 'NI-JI', NULL UNION ALL 
        SELECT 2486, 'León',156,0,NULL,1, 'NI-LE', NULL UNION ALL 
        SELECT 2487, 'Madriz',156,0,NULL,1, 'NI-MD', NULL UNION ALL 
        SELECT 2488, 'Managua',156,0,NULL,1, 'NI-MN', NULL UNION ALL 
        SELECT 2489, 'Masaya',156,0,NULL,1, 'NI-MS', NULL UNION ALL 
        SELECT 2490, 'Matagalpa',156,0,NULL,1, 'NI-MT', NULL UNION ALL 
        SELECT 2491, 'Nueva Segovia',156,0,NULL,1, 'NI-NS', NULL UNION ALL 
        SELECT 2492, 'Rivas',156,0,NULL,1, 'NI-RI', NULL UNION ALL 
        SELECT 2493, 'Río San Juan',156,0,NULL,1, 'NI-SJ', NULL UNION ALL 
        SELECT 2494, 'Agadez',157,0,NULL,1, 'NE-1', NULL UNION ALL 
        SELECT 2495, 'Diffa',157,0,NULL,1, 'NE-2', NULL UNION ALL 
        SELECT 2496, 'Dosso',157,0,NULL,1, 'NE-3', NULL UNION ALL 
        SELECT 2497, 'Maradi',157,0,NULL,1, 'NE-4', NULL UNION ALL 
        SELECT 2498, 'Niamey',157,0,NULL,1, 'NE-8', NULL UNION ALL 
        SELECT 2499, 'Tahoua',157,0,NULL,1, 'NE-5', NULL UNION ALL 
        SELECT 2500, 'Tillabéri',157,0,NULL,1, 'NE-6', NULL UNION ALL 
        SELECT 2501, 'Zinder',157,0,NULL,1, 'NE-7', NULL UNION ALL 
        SELECT 2502, 'Abia',158,0,NULL,1, 'NG-AB', NULL UNION ALL 
        SELECT 2503, 'Abuja Federal Capital Territory',158,0,NULL,1, 'NG-FC', NULL UNION ALL 
        SELECT 2504, 'Adamawa',158,0,NULL,1, 'NG-AD', NULL UNION ALL 
        SELECT 2505, 'Akwa Ibom',158,0,NULL,1, 'NG-AK', NULL UNION ALL 
        SELECT 2506, 'Anambra',158,0,NULL,1, 'NG-AN', NULL UNION ALL 
        SELECT 2507, 'Bauchi',158,0,NULL,1, 'NG-BA', NULL UNION ALL 
        SELECT 2508, 'Bayelsa',158,0,NULL,1, 'NG-BY', NULL UNION ALL 
        SELECT 2509, 'Benue',158,0,NULL,1, 'NG-BE', NULL UNION ALL 
        SELECT 2510, 'Borno',158,0,NULL,1, 'NG-BO', NULL UNION ALL 
        SELECT 2511, 'Cross River',158,0,NULL,1, 'NG-CR', NULL UNION ALL 
        SELECT 2512, 'Delta',158,0,NULL,1, 'NG-DE', NULL UNION ALL 
        SELECT 2513, 'Ebonyi',158,0,NULL,1, 'NG-EB', NULL UNION ALL 
        SELECT 2514, 'Edo',158,0,NULL,1, 'NG-ED', NULL UNION ALL 
        SELECT 2515, 'Ekiti',158,0,NULL,1, 'NG-EK', NULL UNION ALL 
        SELECT 2516, 'Enugu',158,0,NULL,1, 'NG-EN', NULL UNION ALL 
        SELECT 2517, 'Gombe',158,0,NULL,1, 'NG-GO', NULL UNION ALL 
        SELECT 2518, 'Imo',158,0,NULL,1, 'NG-IM', NULL UNION ALL 
        SELECT 2519, 'Jigawa',158,0,NULL,1, 'NG-JI', NULL UNION ALL 
        SELECT 2520, 'Kaduna',158,0,NULL,1, 'NG-KD', NULL UNION ALL 
        SELECT 2521, 'Kano',158,0,NULL,1, 'NG-KN', NULL UNION ALL 
        SELECT 2522, 'Katsina',158,0,NULL,1, 'NG-KT', NULL UNION ALL 
        SELECT 2523, 'Kebbi',158,0,NULL,1, 'NG-KE', NULL UNION ALL 
        SELECT 2524, 'Kogi',158,0,NULL,1, 'NG-KO', NULL UNION ALL 
        SELECT 2525, 'Kwara',158,0,NULL,1, 'NG-KW', NULL UNION ALL 
        SELECT 2526, 'Lagos',158,0,NULL,1, 'NG-LA', NULL UNION ALL 
        SELECT 2527, 'Nasarawa',158,0,NULL,1, 'NG-NA', NULL UNION ALL 
        SELECT 2528, 'Niger',158,0,NULL,1, 'NG-NI', NULL UNION ALL 
        SELECT 2529, 'Ogun',158,0,NULL,1, 'NG-OG', NULL UNION ALL 
        SELECT 2530, 'Ondo',158,0,NULL,1, 'NG-ON', NULL UNION ALL 
        SELECT 2531, 'Osun',158,0,NULL,1, 'NG-OS', NULL UNION ALL 
        SELECT 2532, 'Oyo',158,0,NULL,1, 'NG-OY', NULL UNION ALL 
        SELECT 2533, 'Plateau',158,0,NULL,1, 'NG-PL', NULL UNION ALL 
        SELECT 2534, 'Rivers',158,0,NULL,1, 'NG-RI', NULL UNION ALL 
        SELECT 2535, 'Sokoto',158,0,NULL,1, 'NG-SO', NULL UNION ALL 
        SELECT 2536, 'Taraba',158,0,NULL,1, 'NG-TA', NULL UNION ALL 
        SELECT 2537, 'Yobe',158,0,NULL,1, 'NG-YO', NULL UNION ALL 
        SELECT 2538, 'Zamfara',158,0,NULL,1, 'NG-ZA', NULL UNION ALL 
        SELECT 2539, 'Ad Dakhiliyah',163,0,NULL,1, 'OM-DA', NULL UNION ALL 
        SELECT 2540, 'Al Buraymi',163,0,NULL,1, 'OM-BU', NULL UNION ALL 
        SELECT 2541, 'Al Wustá',163,0,NULL,1, 'OM-WU', NULL UNION ALL 
        SELECT 2542, 'Az¸ Z¸ahirah',163,0,NULL,1, 'OM-ZA', NULL UNION ALL 
        SELECT 2543, 'Janub al Batinah',163,0,NULL,1, 'OM-BJ', NULL UNION ALL 
        SELECT 2544, 'Janub ash Sharqiyah',163,0,NULL,1, 'OM-SJ', NULL UNION ALL 
        SELECT 2545, 'Masqat',163,0,NULL,1, 'OM-MA', NULL UNION ALL 
        SELECT 2546, 'Musandam',163,0,NULL,1, 'OM-MU', NULL UNION ALL 
        SELECT 2547, 'Shamal al Batinah',163,0,NULL,1, 'OM-BS', NULL UNION ALL 
        SELECT 2548, 'Shamal ash Sharqiyah',163,0,NULL,1, 'OM-SS', NULL UNION ALL 
        SELECT 2549, 'Z¸ufar',163,0,NULL,1, 'OM-ZU', NULL UNION ALL 
        SELECT 2550, 'Bocas del Toro',166,0,NULL,1, 'PA-1', NULL UNION ALL 
        SELECT 2551, 'Chiriquí',166,0,NULL,1, 'PA-4', NULL UNION ALL 
        SELECT 2552, 'Coclé',166,0,NULL,1, 'PA-2', NULL UNION ALL 
        SELECT 2553, 'Colón',166,0,NULL,1, 'PA-3', NULL UNION ALL 
        SELECT 2554, 'Darién',166,0,NULL,1, 'PA-5', NULL UNION ALL 
        SELECT 2555, 'Emberá',166,0,NULL,1, 'PA-EM', NULL UNION ALL 
        SELECT 2556, 'Guna Yala',166,0,NULL,1, 'PA-KY', NULL UNION ALL 
        SELECT 2557, 'Herrera',166,0,NULL,1, 'PA-6', NULL UNION ALL 
        SELECT 2558, 'Los Santos',166,0,NULL,1, 'PA-7', NULL UNION ALL 
        SELECT 2559, 'Ngöbe-Buglé',166,0,NULL,1, 'PA-NB', NULL UNION ALL 
        SELECT 2560, 'Panamá',166,0,NULL,1, 'PA-8', NULL UNION ALL 
        SELECT 2561, 'Panamá Oeste',166,0,NULL,1, 'PA-10', NULL UNION ALL 
        SELECT 2562, 'Veraguas',166,0,NULL,1, 'PA-9', NULL UNION ALL 
        SELECT 2563, 'Bougainville',167,0,NULL,1, 'PG-NSB', NULL UNION ALL 
        SELECT 2564, 'Central',167,0,NULL,1, 'PG-CPM', NULL UNION ALL 
        SELECT 2565, 'Chimbu',167,0,NULL,1, 'PG-CPK', NULL UNION ALL 
        SELECT 2566, 'East New Britain',167,0,NULL,1, 'PG-EBR', NULL UNION ALL 
        SELECT 2567, 'East Sepik',167,0,NULL,1, 'PG-ESW', NULL UNION ALL 
        SELECT 2568, 'Eastern Highlands',167,0,NULL,1, 'PG-EHG', NULL UNION ALL 
        SELECT 2569, 'Enga',167,0,NULL,1, 'PG-EPW', NULL UNION ALL 
        SELECT 2570, 'Gulf',167,0,NULL,1, 'PG-GPK', NULL UNION ALL 
        SELECT 2571, 'Hela',167,0,NULL,1, 'PG-HLA', NULL UNION ALL 
        SELECT 2572, 'Jiwaka',167,0,NULL,1, 'PG-JWK', NULL UNION ALL 
        SELECT 2573, 'Madang',167,0,NULL,1, 'PG-MPM', NULL UNION ALL 
        SELECT 2574, 'Manus',167,0,NULL,1, 'PG-MRL', NULL UNION ALL 
        SELECT 2575, 'Milne Bay',167,0,NULL,1, 'PG-MBA', NULL UNION ALL 
        SELECT 2576, 'Morobe',167,0,NULL,1, 'PG-MPL', NULL UNION ALL 
        SELECT 2577, 'National Capital District (Port Moresby)',167,0,NULL,1, 'PG-NCD', NULL UNION ALL 
        SELECT 2578, 'New Ireland',167,0,NULL,1, 'PG-NIK', NULL UNION ALL 
        SELECT 2579, 'Northern',167,0,NULL,1, 'PG-NPP', NULL UNION ALL 
        SELECT 2580, 'Southern Highlands',167,0,NULL,1, 'PG-SHM', NULL UNION ALL 
        SELECT 2581, 'West New Britain',167,0,NULL,1, 'PG-WBK', NULL UNION ALL 
        SELECT 2582, 'West Sepik',167,0,NULL,1, 'PG-SAN', NULL UNION ALL 
        SELECT 2583, 'Western',167,0,NULL,1, 'PG-WPD', NULL UNION ALL 
        SELECT 2584, 'Western Highlands',167,0,NULL,1, 'PG-WHM', NULL UNION ALL 
        SELECT 2585, 'Alto Paraguay',168,0,NULL,1, 'PY-16', NULL UNION ALL 
        SELECT 2586, 'Alto Paraná',168,0,NULL,1, 'PY-10', NULL UNION ALL 
        SELECT 2587, 'Amambay',168,0,NULL,1, 'PY-13', NULL UNION ALL 
        SELECT 2588, 'Asunción',168,0,NULL,1, 'PY-ASU', NULL UNION ALL 
        SELECT 2589, 'Boquerón',168,0,NULL,1, 'PY-19', NULL UNION ALL 
        SELECT 2590, 'Caaguazú',168,0,NULL,1, 'PY-5', NULL UNION ALL 
        SELECT 2591, 'Caazapá',168,0,NULL,1, 'PY-6', NULL UNION ALL 
        SELECT 2592, 'Canindeyú',168,0,NULL,1, 'PY-14', NULL UNION ALL 
        SELECT 2593, 'Central',168,0,NULL,1, 'PY-11', NULL UNION ALL 
        SELECT 2594, 'Concepción',168,0,NULL,1, 'PY-1', NULL UNION ALL 
        SELECT 2595, 'Cordillera',168,0,NULL,1, 'PY-3', NULL UNION ALL 
        SELECT 2596, 'Guairá',168,0,NULL,1, 'PY-4', NULL UNION ALL 
        SELECT 2597, 'Itapúa',168,0,NULL,1, 'PY-7', NULL UNION ALL 
        SELECT 2598, 'Misiones',168,0,NULL,1, 'PY-8', NULL UNION ALL 
        SELECT 2599, 'Paraguarí',168,0,NULL,1, 'PY-9', NULL UNION ALL 
        SELECT 2600, 'Presidente Hayes',168,0,NULL,1, 'PY-15', NULL UNION ALL 
        SELECT 2601, 'San Pedro',168,0,NULL,1, 'PY-2', NULL UNION ALL 
        SELECT 2602, 'Ñeembucú',168,0,NULL,1, 'PY-12', NULL UNION ALL 
        SELECT 2603, 'Dolnoslaskie',172,0,NULL,1, 'PL-02', NULL UNION ALL 
        SELECT 2604, 'Kujawsko-pomorskie',172,0,NULL,1, 'PL-04', NULL UNION ALL 
        SELECT 2605, 'Lubelskie',172,0,NULL,1, 'PL-06', NULL UNION ALL 
        SELECT 2606, 'Lubuskie',172,0,NULL,1, 'PL-08', NULL UNION ALL 
        SELECT 2607, 'Mazowieckie',172,0,NULL,1, 'PL-14', NULL UNION ALL 
        SELECT 2608, 'Malopolskie',172,0,NULL,1, 'PL-12', NULL UNION ALL 
        SELECT 2609, 'Opolskie',172,0,NULL,1, 'PL-16', NULL UNION ALL 
        SELECT 2610, 'Podkarpackie',172,0,NULL,1, 'PL-18', NULL UNION ALL 
        SELECT 2611, 'Podlaskie',172,0,NULL,1, 'PL-20', NULL UNION ALL 
        SELECT 2612, 'Pomorskie',172,0,NULL,1, 'PL-22', NULL UNION ALL 
        SELECT 2613, 'Warminsko-mazurskie',172,0,NULL,1, 'PL-28', NULL UNION ALL 
        SELECT 2614, 'Wielkopolskie',172,0,NULL,1, 'PL-30', NULL UNION ALL 
        SELECT 2615, 'Zachodniopomorskie',172,0,NULL,1, 'PL-32', NULL UNION ALL 
        SELECT 2616, 'Lódzkie',172,0,NULL,1, 'PL-10', NULL UNION ALL 
        SELECT 2617, 'Slaskie',172,0,NULL,1, 'PL-24', NULL UNION ALL 
        SELECT 2618, 'Swietokrzyskie',172,0,NULL,1, 'PL-26', NULL UNION ALL 
        SELECT 2619, 'Aveiro',173,0,NULL,1, 'PT-01', NULL UNION ALL 
        SELECT 2620, 'Beja',173,0,NULL,1, 'PT-02', NULL UNION ALL 
        SELECT 2621, 'Braga',173,0,NULL,1, 'PT-03', NULL UNION ALL 
        SELECT 2622, 'Bragança',173,0,NULL,1, 'PT-04', NULL UNION ALL 
        SELECT 2623, 'Castelo Branco',173,0,NULL,1, 'PT-05', NULL UNION ALL 
        SELECT 2624, 'Coimbra',173,0,NULL,1, 'PT-06', NULL UNION ALL 
        SELECT 2625, 'Faro',173,0,NULL,1, 'PT-08', NULL UNION ALL 
        SELECT 2626, 'Guarda',173,0,NULL,1, 'PT-09', NULL UNION ALL 
        SELECT 2627, 'Leiria',173,0,NULL,1, 'PT-10', NULL UNION ALL 
        SELECT 2628, 'Lisboa',173,0,NULL,1, 'PT-11', NULL UNION ALL 
        SELECT 2629, 'Portalegre',173,0,NULL,1, 'PT-12', NULL UNION ALL 
        SELECT 2630, 'Porto',173,0,NULL,1, 'PT-13', NULL UNION ALL 
        SELECT 2631, 'Região Autónoma da Madeira',173,0,NULL,1, 'PT-30', NULL UNION ALL 
        SELECT 2632, 'Região Autónoma dos Açores',173,0,NULL,1, 'PT-20', NULL UNION ALL 
        SELECT 2633, 'Santarém',173,0,NULL,1, 'PT-14', NULL UNION ALL 
        SELECT 2634, 'Setúbal',173,0,NULL,1, 'PT-15', NULL UNION ALL 
        SELECT 2635, 'Viana do Castelo',173,0,NULL,1, 'PT-16', NULL UNION ALL 
        SELECT 2636, 'Vila Real',173,0,NULL,1, 'PT-17', NULL UNION ALL 
        SELECT 2637, 'Viseu',173,0,NULL,1, 'PT-18', NULL UNION ALL 
        SELECT 2638, 'Évora',173,0,NULL,1, 'PT-07', NULL UNION ALL 
        SELECT 2639, 'Ad Daw?ah',175,0,NULL,1, 'QA-DA', NULL UNION ALL 
        SELECT 2640, 'Al Khawr wa adh Dhakhirah',175,0,NULL,1, 'QA-KH', NULL UNION ALL 
        SELECT 2641, 'Al Wakrah',175,0,NULL,1, 'QA-WA', NULL UNION ALL 
        SELECT 2642, 'Ar Rayyan',175,0,NULL,1, 'QA-RA', NULL UNION ALL 
        SELECT 2643, 'Ash Shamal',175,0,NULL,1, 'QA-MS', NULL UNION ALL 
        SELECT 2644, 'Ash Shi?aniyah',175,0,NULL,1, 'QA-SH', NULL UNION ALL 
        SELECT 2645, 'Az¸ Z¸a‘ayin',175,0,NULL,1, 'QA-ZA', NULL UNION ALL 
        SELECT 2646, 'Umm Salal',175,0,NULL,1, 'QA-US', NULL UNION ALL 
        SELECT 2647, 'Alba',177,0,NULL,1, 'RO-AB', NULL UNION ALL 
        SELECT 2648, 'Arad',177,0,NULL,1, 'RO-AR', NULL UNION ALL 
        SELECT 2649, 'Arge?',177,0,NULL,1, 'RO-AG', NULL UNION ALL 
        SELECT 2650, 'Bacau',177,0,NULL,1, 'RO-BC', NULL UNION ALL 
        SELECT 2651, 'Bihor',177,0,NULL,1, 'RO-BH', NULL UNION ALL 
        SELECT 2652, 'Bistri?a-Nasaud',177,0,NULL,1, 'RO-BN', NULL UNION ALL 
        SELECT 2653, 'Boto?ani',177,0,NULL,1, 'RO-BT', NULL UNION ALL 
        SELECT 2654, 'Bra?ov',177,0,NULL,1, 'RO-BV', NULL UNION ALL 
        SELECT 2655, 'Braila',177,0,NULL,1, 'RO-BR', NULL UNION ALL 
        SELECT 2656, 'Bucure?ti',177,0,NULL,1, 'RO-B', NULL UNION ALL 
        SELECT 2657, 'Buzau',177,0,NULL,1, 'RO-BZ', NULL UNION ALL 
        SELECT 2658, 'Cara?-Severin',177,0,NULL,1, 'RO-CS', NULL UNION ALL 
        SELECT 2659, 'Cluj',177,0,NULL,1, 'RO-CJ', NULL UNION ALL 
        SELECT 2660, 'Constan?a',177,0,NULL,1, 'RO-CT', NULL UNION ALL 
        SELECT 2661, 'Covasna',177,0,NULL,1, 'RO-CV', NULL UNION ALL 
        SELECT 2662, 'Calara?i',177,0,NULL,1, 'RO-CL', NULL UNION ALL 
        SELECT 2663, 'Dolj',177,0,NULL,1, 'RO-DJ', NULL UNION ALL 
        SELECT 2664, 'Dâmbovi?a',177,0,NULL,1, 'RO-DB', NULL UNION ALL 
        SELECT 2665, 'Gala?i',177,0,NULL,1, 'RO-GL', NULL UNION ALL 
        SELECT 2666, 'Giurgiu',177,0,NULL,1, 'RO-GR', NULL UNION ALL 
        SELECT 2667, 'Gorj',177,0,NULL,1, 'RO-GJ', NULL UNION ALL 
        SELECT 2668, 'Harghita',177,0,NULL,1, 'RO-HR', NULL UNION ALL 
        SELECT 2669, 'Hunedoara',177,0,NULL,1, 'RO-HD', NULL UNION ALL 
        SELECT 2670, 'Ialomi?a',177,0,NULL,1, 'RO-IL', NULL UNION ALL 
        SELECT 2671, 'Ia?i',177,0,NULL,1, 'RO-IS', NULL UNION ALL 
        SELECT 2672, 'Ilfov',177,0,NULL,1, 'RO-IF', NULL UNION ALL 
        SELECT 2673, 'Maramure?',177,0,NULL,1, 'RO-MM', NULL UNION ALL 
        SELECT 2674, 'Mehedin?i',177,0,NULL,1, 'RO-MH', NULL UNION ALL 
        SELECT 2675, 'Mure?',177,0,NULL,1, 'RO-MS', NULL UNION ALL 
        SELECT 2676, 'Neam?',177,0,NULL,1, 'RO-NT', NULL UNION ALL 
        SELECT 2677, 'Olt',177,0,NULL,1, 'RO-OT', NULL UNION ALL 
        SELECT 2678, 'Prahova',177,0,NULL,1, 'RO-PH', NULL UNION ALL 
        SELECT 2679, 'Satu Mare',177,0,NULL,1, 'RO-SM', NULL UNION ALL 
        SELECT 2680, 'Sibiu',177,0,NULL,1, 'RO-SB', NULL UNION ALL 
        SELECT 2681, 'Suceava',177,0,NULL,1, 'RO-SV', NULL UNION ALL 
        SELECT 2682, 'Salaj',177,0,NULL,1, 'RO-SJ', NULL UNION ALL 
        SELECT 2683, 'Teleorman',177,0,NULL,1, 'RO-TR', NULL UNION ALL 
        SELECT 2684, 'Timi?',177,0,NULL,1, 'RO-TM', NULL UNION ALL 
        SELECT 2685, 'Tulcea',177,0,NULL,1, 'RO-TL', NULL UNION ALL 
        SELECT 2686, 'Vaslui',177,0,NULL,1, 'RO-VS', NULL UNION ALL 
        SELECT 2687, 'Vrancea',177,0,NULL,1, 'RO-VN', NULL UNION ALL 
        SELECT 2688, 'Vâlcea',177,0,NULL,1, 'RO-VL', NULL UNION ALL 
        SELECT 2689, 'Ascension',180,0,NULL,1, 'SH-AC', NULL UNION ALL 
        SELECT 2690, 'Saint Helena',180,0,NULL,1, 'SH-HL', NULL UNION ALL 
        SELECT 2691, 'Tristan da Cunha',180,0,NULL,1, 'SH-TA', NULL UNION ALL 
        SELECT 2692, 'Christ Church Nichola Town',181,0,NULL,1, 'KN-01', 'KN-K' UNION ALL 
        SELECT 2693, 'Nevis',181,0,NULL,1, 'KN-N', NULL UNION ALL 
        SELECT 2694, 'Saint Anne Sandy Point',181,0,NULL,1, 'KN-02', 'KN-K' UNION ALL 
        SELECT 2695, 'Saint George Basseterre',181,0,NULL,1, 'KN-03', 'KN-K' UNION ALL 
        SELECT 2696, 'Saint George Gingerland',181,0,NULL,1, 'KN-04', 'KN-N' UNION ALL 
        SELECT 2697, 'Saint James Windward',181,0,NULL,1, 'KN-05', 'KN-N' UNION ALL 
        SELECT 2698, 'Saint John Capisterre',181,0,NULL,1, 'KN-06', 'KN-K' UNION ALL 
        SELECT 2699, 'Saint John Figtree',181,0,NULL,1, 'KN-07', 'KN-N' UNION ALL 
        SELECT 2700, 'Saint Kitts',181,0,NULL,1, 'KN-K', NULL UNION ALL 
        SELECT 2701, 'Saint Mary Cayon',181,0,NULL,1, 'KN-08', 'KN-K' UNION ALL 
        SELECT 2702, 'Saint Paul Capisterre',181,0,NULL,1, 'KN-09', 'KN-K' UNION ALL 
        SELECT 2703, 'Saint Paul Charlestown',181,0,NULL,1, 'KN-10', 'KN-N' UNION ALL 
        SELECT 2704, 'Saint Peter Basseterre',181,0,NULL,1, 'KN-11', 'KN-K' UNION ALL 
        SELECT 2705, 'Saint Thomas Lowland',181,0,NULL,1, 'KN-12', 'KN-N' UNION ALL 
        SELECT 2706, 'Saint Thomas Middle Island',181,0,NULL,1, 'KN-13', 'KN-K' UNION ALL 
        SELECT 2707, 'Trinity Palmetto Point',181,0,NULL,1, 'KN-15', 'KN-K' UNION ALL 
        SELECT 2708, 'Anse la Raye',182,0,NULL,1, 'LC-01', NULL UNION ALL 
        SELECT 2709, 'Canaries',182,0,NULL,1, 'LC-12', NULL UNION ALL 
        SELECT 2710, 'Castries',182,0,NULL,1, 'LC-02', NULL UNION ALL 
        SELECT 2711, 'Choiseul',182,0,NULL,1, 'LC-03', NULL UNION ALL 
        SELECT 2712, 'Dennery',182,0,NULL,1, 'LC-05', NULL UNION ALL 
        SELECT 2713, 'Gros Islet',182,0,NULL,1, 'LC-06', NULL UNION ALL 
        SELECT 2714, 'Laborie',182,0,NULL,1, 'LC-07', NULL UNION ALL 
        SELECT 2715, 'Micoud',182,0,NULL,1, 'LC-08', NULL UNION ALL 
        SELECT 2716, 'Soufrière',182,0,NULL,1, 'LC-10', NULL UNION ALL 
        SELECT 2717, 'Vieux Fort',182,0,NULL,1, 'LC-11', NULL UNION ALL 
        SELECT 2718, 'Charlotte',184,0,NULL,1, 'VC-01', NULL UNION ALL 
        SELECT 2719, 'Grenadines',184,0,NULL,1, 'VC-06', NULL UNION ALL 
        SELECT 2720, 'Saint Andrew',184,0,NULL,1, 'VC-02', NULL UNION ALL 
        SELECT 2721, 'Saint David',184,0,NULL,1, 'VC-03', NULL UNION ALL 
        SELECT 2722, 'Saint George',184,0,NULL,1, 'VC-04', NULL UNION ALL 
        SELECT 2723, 'Saint Patrick',184,0,NULL,1, 'VC-05', NULL UNION ALL 
        SELECT 2724, 'Acquaviva',186,0,NULL,1, 'SM-01', NULL UNION ALL 
        SELECT 2725, 'Borgo Maggiore',186,0,NULL,1, 'SM-06', NULL UNION ALL 
        SELECT 2726, 'Chiesanuova',186,0,NULL,1, 'SM-02', NULL UNION ALL 
        SELECT 2727, 'Domagnano',186,0,NULL,1, 'SM-03', NULL UNION ALL 
        SELECT 2728, 'Faetano',186,0,NULL,1, 'SM-04', NULL UNION ALL 
        SELECT 2729, 'Fiorentino',186,0,NULL,1, 'SM-05', NULL UNION ALL 
        SELECT 2730, 'Montegiardino',186,0,NULL,1, 'SM-08', NULL UNION ALL 
        SELECT 2731, 'San Marino',186,0,NULL,1, 'SM-07', NULL UNION ALL 
        SELECT 2732, 'Serravalle',186,0,NULL,1, 'SM-09', NULL UNION ALL 
        SELECT 2733, 'Príncipe',187,0,NULL,1, 'ST-P', NULL UNION ALL 
        SELECT 2734, 'São Tomé',187,0,NULL,1, 'ST-S', NULL UNION ALL 
        SELECT 2735, '''Asir',188,0,NULL,1, 'SA-14', NULL UNION ALL 
        SELECT 2736, 'Al Ba?ah',188,0,NULL,1, 'SA-11', NULL UNION ALL 
        SELECT 2737, 'Al Jawf',188,0,NULL,1, 'SA-12', NULL UNION ALL 
        SELECT 2738, 'Al Madinah al Munawwarah',188,0,NULL,1, 'SA-03', NULL UNION ALL 
        SELECT 2739, 'Al Qasim',188,0,NULL,1, 'SA-05', NULL UNION ALL 
        SELECT 2740, 'Al ?udud ash Shamaliyah',188,0,NULL,1, 'SA-08', NULL UNION ALL 
        SELECT 2741, 'Ar Riya?',188,0,NULL,1, 'SA-01', NULL UNION ALL 
        SELECT 2742, 'Ash Sharqiyah',188,0,NULL,1, 'SA-04', NULL UNION ALL 
        SELECT 2743, 'Jazan',188,0,NULL,1, 'SA-09', NULL UNION ALL 
        SELECT 2744, 'Makkah al Mukarramah',188,0,NULL,1, 'SA-02', NULL UNION ALL 
        SELECT 2745, 'Najran',188,0,NULL,1, 'SA-10', NULL UNION ALL 
        SELECT 2746, 'Tabuk',188,0,NULL,1, 'SA-07', NULL UNION ALL 
        SELECT 2747, '?a''il',188,0,NULL,1, 'SA-06', NULL UNION ALL 
        SELECT 2748, 'Dakar',189,0,NULL,1, 'SN-DK', NULL UNION ALL 
        SELECT 2749, 'Diourbel',189,0,NULL,1, 'SN-DB', NULL UNION ALL 
        SELECT 2750, 'Fatick',189,0,NULL,1, 'SN-FK', NULL UNION ALL 
        SELECT 2751, 'Kaffrine',189,0,NULL,1, 'SN-KA', NULL UNION ALL 
        SELECT 2752, 'Kaolack',189,0,NULL,1, 'SN-KL', NULL UNION ALL 
        SELECT 2753, 'Kolda',189,0,NULL,1, 'SN-KD', NULL UNION ALL 
        SELECT 2754, 'Kédougou',189,0,NULL,1, 'SN-KE', NULL UNION ALL 
        SELECT 2755, 'Louga',189,0,NULL,1, 'SN-LG', NULL UNION ALL 
        SELECT 2756, 'Matam',189,0,NULL,1, 'SN-MT', NULL UNION ALL 
        SELECT 2757, 'Saint-Louis',189,0,NULL,1, 'SN-SL', NULL UNION ALL 
        SELECT 2758, 'Sédhiou',189,0,NULL,1, 'SN-SE', NULL UNION ALL 
        SELECT 2759, 'Tambacounda',189,0,NULL,1, 'SN-TC', NULL UNION ALL 
        SELECT 2760, 'Thiès',189,0,NULL,1, 'SN-TH', NULL UNION ALL 
        SELECT 2761, 'Ziguinchor',189,0,NULL,1, 'SN-ZG', NULL UNION ALL 
        SELECT 2762, 'Eastern',191,0,NULL,1, 'SL-E', NULL UNION ALL 
        SELECT 2763, 'North Western',191,0,NULL,1, 'SL-NW', NULL UNION ALL 
        SELECT 2764, 'Northern',191,0,NULL,1, 'SL-N', NULL UNION ALL 
        SELECT 2765, 'Southern',191,0,NULL,1, 'SL-S', NULL UNION ALL 
        SELECT 2766, 'Western Area (Freetown)',191,0,NULL,1, 'SL-W', NULL UNION ALL 
        SELECT 2767, 'Central Singapore',192,0,NULL,1, 'SG-01', NULL UNION ALL 
        SELECT 2768, 'North East',192,0,NULL,1, 'SG-02', NULL UNION ALL 
        SELECT 2769, 'North West',192,0,NULL,1, 'SG-03', NULL UNION ALL 
        SELECT 2770, 'South East',192,0,NULL,1, 'SG-04', NULL UNION ALL 
        SELECT 2771, 'South West',192,0,NULL,1, 'SG-05', NULL UNION ALL 
        SELECT 2772, 'Banskobystrický kraj',193,0,NULL,1, 'SK-BC', NULL UNION ALL 
        SELECT 2773, 'Bratislavský kraj',193,0,NULL,1, 'SK-BL', NULL UNION ALL 
        SELECT 2774, 'Košický kraj',193,0,NULL,1, 'SK-KI', NULL UNION ALL 
        SELECT 2775, 'Nitriansky kraj',193,0,NULL,1, 'SK-NI', NULL UNION ALL 
        SELECT 2776, 'Prešovský kraj',193,0,NULL,1, 'SK-PV', NULL UNION ALL 
        SELECT 2777, 'Trenciansky kraj',193,0,NULL,1, 'SK-TC', NULL UNION ALL 
        SELECT 2778, 'Trnavský kraj',193,0,NULL,1, 'SK-TA', NULL UNION ALL 
        SELECT 2779, 'Žilinský kraj',193,0,NULL,1, 'SK-ZI', NULL UNION ALL 
        SELECT 2780, 'Ajdovšcina',194,0,NULL,1, 'SI-001', NULL UNION ALL 
        SELECT 2781, 'Ankaran',194,0,NULL,1, 'SI-213', NULL UNION ALL 
        SELECT 2782, 'Apace',194,0,NULL,1, 'SI-195', NULL UNION ALL 
        SELECT 2783, 'Beltinci',194,0,NULL,1, 'SI-002', NULL UNION ALL 
        SELECT 2784, 'Benedikt',194,0,NULL,1, 'SI-148', NULL UNION ALL 
        SELECT 2785, 'Bistrica ob Sotli',194,0,NULL,1, 'SI-149', NULL UNION ALL 
        SELECT 2786, 'Bled',194,0,NULL,1, 'SI-003', NULL UNION ALL 
        SELECT 2787, 'Bloke',194,0,NULL,1, 'SI-150', NULL UNION ALL 
        SELECT 2788, 'Bohinj',194,0,NULL,1, 'SI-004', NULL UNION ALL 
        SELECT 2789, 'Borovnica',194,0,NULL,1, 'SI-005', NULL UNION ALL 
        SELECT 2790, 'Bovec',194,0,NULL,1, 'SI-006', NULL UNION ALL 
        SELECT 2791, 'Braslovce',194,0,NULL,1, 'SI-151', NULL UNION ALL 
        SELECT 2792, 'Brda',194,0,NULL,1, 'SI-007', NULL UNION ALL 
        SELECT 2793, 'Brezovica',194,0,NULL,1, 'SI-008', NULL UNION ALL 
        SELECT 2794, 'Brežice',194,0,NULL,1, 'SI-009', NULL UNION ALL 
        SELECT 2795, 'Cankova',194,0,NULL,1, 'SI-152', NULL UNION ALL 
        SELECT 2796, 'Celje',194,0,NULL,1, 'SI-011', NULL UNION ALL 
        SELECT 2797, 'Cerklje na Gorenjskem',194,0,NULL,1, 'SI-012', NULL UNION ALL 
        SELECT 2798, 'Cerknica',194,0,NULL,1, 'SI-013', NULL UNION ALL 
        SELECT 2799, 'Cerkno',194,0,NULL,1, 'SI-014', NULL UNION ALL 
        SELECT 2800, 'Cerkvenjak',194,0,NULL,1, 'SI-153', NULL UNION ALL 
        SELECT 2801, 'Cirkulane',194,0,NULL,1, 'SI-196', NULL UNION ALL 
        SELECT 2802, 'Destrnik',194,0,NULL,1, 'SI-018', NULL UNION ALL 
        SELECT 2803, 'Divaca',194,0,NULL,1, 'SI-019', NULL UNION ALL 
        SELECT 2804, 'Dobje',194,0,NULL,1, 'SI-154', NULL UNION ALL 
        SELECT 2805, 'Dobrepolje',194,0,NULL,1, 'SI-020', NULL UNION ALL 
        SELECT 2806, 'Dobrna',194,0,NULL,1, 'SI-155', NULL UNION ALL 
        SELECT 2807, 'Dobrova-Polhov Gradec',194,0,NULL,1, 'SI-021', NULL UNION ALL 
        SELECT 2808, 'Dobrovnik',194,0,NULL,1, 'SI-156', NULL UNION ALL 
        SELECT 2809, 'Dol pri Ljubljani',194,0,NULL,1, 'SI-022', NULL UNION ALL 
        SELECT 2810, 'Dolenjske Toplice',194,0,NULL,1, 'SI-157', NULL UNION ALL 
        SELECT 2811, 'Domžale',194,0,NULL,1, 'SI-023', NULL UNION ALL 
        SELECT 2812, 'Dornava',194,0,NULL,1, 'SI-024', NULL UNION ALL 
        SELECT 2813, 'Dravograd',194,0,NULL,1, 'SI-025', NULL UNION ALL 
        SELECT 2814, 'Duplek',194,0,NULL,1, 'SI-026', NULL UNION ALL 
        SELECT 2815, 'Gorenja vas-Poljane',194,0,NULL,1, 'SI-027', NULL UNION ALL 
        SELECT 2816, 'Gorišnica',194,0,NULL,1, 'SI-028', NULL UNION ALL 
        SELECT 2817, 'Gorje',194,0,NULL,1, 'SI-207', NULL UNION ALL 
        SELECT 2818, 'Gornja Radgona',194,0,NULL,1, 'SI-029', NULL UNION ALL 
        SELECT 2819, 'Gornji Grad',194,0,NULL,1, 'SI-030', NULL UNION ALL 
        SELECT 2820, 'Gornji Petrovci',194,0,NULL,1, 'SI-031', NULL UNION ALL 
        SELECT 2821, 'Grad',194,0,NULL,1, 'SI-158', NULL UNION ALL 
        SELECT 2822, 'Grosuplje',194,0,NULL,1, 'SI-032', NULL UNION ALL 
        SELECT 2823, 'Hajdina',194,0,NULL,1, 'SI-159', NULL UNION ALL 
        SELECT 2824, 'Hodoš',194,0,NULL,1, 'SI-161', NULL UNION ALL 
        SELECT 2825, 'Horjul',194,0,NULL,1, 'SI-162', NULL UNION ALL 
        SELECT 2826, 'Hoce-Slivnica',194,0,NULL,1, 'SI-160', NULL UNION ALL 
        SELECT 2827, 'Hrastnik',194,0,NULL,1, 'SI-034', NULL UNION ALL 
        SELECT 2828, 'Hrpelje-Kozina',194,0,NULL,1, 'SI-035', NULL UNION ALL 
        SELECT 2829, 'Idrija',194,0,NULL,1, 'SI-036', NULL UNION ALL 
        SELECT 2830, 'Ig',194,0,NULL,1, 'SI-037', NULL UNION ALL 
        SELECT 2831, 'Ilirska Bistrica',194,0,NULL,1, 'SI-038', NULL UNION ALL 
        SELECT 2832, 'Ivancna Gorica',194,0,NULL,1, 'SI-039', NULL UNION ALL 
        SELECT 2833, 'Izola',194,0,NULL,1, 'SI-040', NULL UNION ALL 
        SELECT 2834, 'Jesenice',194,0,NULL,1, 'SI-041', NULL UNION ALL 
        SELECT 2835, 'Jezersko',194,0,NULL,1, 'SI-163', NULL UNION ALL 
        SELECT 2836, 'Juršinci',194,0,NULL,1, 'SI-042', NULL UNION ALL 
        SELECT 2837, 'Kamnik',194,0,NULL,1, 'SI-043', NULL UNION ALL 
        SELECT 2838, 'Kanal',194,0,NULL,1, 'SI-044', NULL UNION ALL 
        SELECT 2839, 'Kidricevo',194,0,NULL,1, 'SI-045', NULL UNION ALL 
        SELECT 2840, 'Kobarid',194,0,NULL,1, 'SI-046', NULL UNION ALL 
        SELECT 2841, 'Kobilje',194,0,NULL,1, 'SI-047', NULL UNION ALL 
        SELECT 2842, 'Komen',194,0,NULL,1, 'SI-049', NULL UNION ALL 
        SELECT 2843, 'Komenda',194,0,NULL,1, 'SI-164', NULL UNION ALL 
        SELECT 2844, 'Koper',194,0,NULL,1, 'SI-050', NULL UNION ALL 
        SELECT 2845, 'Kosanjevica na Krki',194,0,NULL,1, 'SI-197', NULL UNION ALL 
        SELECT 2846, 'Kostel',194,0,NULL,1, 'SI-165', NULL UNION ALL 
        SELECT 2847, 'Kozje',194,0,NULL,1, 'SI-051', NULL UNION ALL 
        SELECT 2848, 'Kocevje',194,0,NULL,1, 'SI-048', NULL UNION ALL 
        SELECT 2849, 'Kranj',194,0,NULL,1, 'SI-052', NULL UNION ALL 
        SELECT 2850, 'Kranjska Gora',194,0,NULL,1, 'SI-053', NULL UNION ALL 
        SELECT 2851, 'Križevci',194,0,NULL,1, 'SI-166', NULL UNION ALL 
        SELECT 2852, 'Krško',194,0,NULL,1, 'SI-054', NULL UNION ALL 
        SELECT 2853, 'Kungota',194,0,NULL,1, 'SI-055', NULL UNION ALL 
        SELECT 2854, 'Kuzma',194,0,NULL,1, 'SI-056', NULL UNION ALL 
        SELECT 2855, 'Laško',194,0,NULL,1, 'SI-057', NULL UNION ALL 
        SELECT 2856, 'Lenart',194,0,NULL,1, 'SI-058', NULL UNION ALL 
        SELECT 2857, 'Lendava',194,0,NULL,1, 'SI-059', NULL UNION ALL 
        SELECT 2858, 'Litija',194,0,NULL,1, 'SI-060', NULL UNION ALL 
        SELECT 2859, 'Ljubljana',194,0,NULL,1, 'SI-061', NULL UNION ALL 
        SELECT 2860, 'Ljubno',194,0,NULL,1, 'SI-062', NULL UNION ALL 
        SELECT 2861, 'Ljutomer',194,0,NULL,1, 'SI-063', NULL UNION ALL 
        SELECT 2862, 'Log-Dragomer',194,0,NULL,1, 'SI-208', NULL UNION ALL 
        SELECT 2863, 'Logatec',194,0,NULL,1, 'SI-064', NULL UNION ALL 
        SELECT 2864, 'Lovrenc na Pohorju',194,0,NULL,1, 'SI-167', NULL UNION ALL 
        SELECT 2865, 'Loška Dolina',194,0,NULL,1, 'SI-065', NULL UNION ALL 
        SELECT 2866, 'Loški Potok',194,0,NULL,1, 'SI-066', NULL UNION ALL 
        SELECT 2867, 'Lukovica',194,0,NULL,1, 'SI-068', NULL UNION ALL 
        SELECT 2868, 'Luce',194,0,NULL,1, 'SI-067', NULL UNION ALL 
        SELECT 2869, 'Majšperk',194,0,NULL,1, 'SI-069', NULL UNION ALL 
        SELECT 2870, 'Makole',194,0,NULL,1, 'SI-198', NULL UNION ALL 
        SELECT 2871, 'Maribor',194,0,NULL,1, 'SI-070', NULL UNION ALL 
        SELECT 2872, 'Markovci',194,0,NULL,1, 'SI-168', NULL UNION ALL 
        SELECT 2873, 'Medvode',194,0,NULL,1, 'SI-071', NULL UNION ALL 
        SELECT 2874, 'Mengeš',194,0,NULL,1, 'SI-072', NULL UNION ALL 
        SELECT 2875, 'Metlika',194,0,NULL,1, 'SI-073', NULL UNION ALL 
        SELECT 2876, 'Mežica',194,0,NULL,1, 'SI-074', NULL UNION ALL 
        SELECT 2877, 'Miklavž na Dravskem Polju',194,0,NULL,1, 'SI-169', NULL UNION ALL 
        SELECT 2878, 'Miren-Kostanjevica',194,0,NULL,1, 'SI-075', NULL UNION ALL 
        SELECT 2879, 'Mirna',194,0,NULL,1, 'SI-212', NULL UNION ALL 
        SELECT 2880, 'Mirna Pec',194,0,NULL,1, 'SI-170', NULL UNION ALL 
        SELECT 2881, 'Mislinja',194,0,NULL,1, 'SI-076', NULL UNION ALL 
        SELECT 2882, 'Mokronog-Trebelno',194,0,NULL,1, 'SI-199', NULL UNION ALL 
        SELECT 2883, 'Moravske Toplice',194,0,NULL,1, 'SI-078', NULL UNION ALL 
        SELECT 2884, 'Moravce',194,0,NULL,1, 'SI-077', NULL UNION ALL 
        SELECT 2885, 'Mozirje',194,0,NULL,1, 'SI-079', NULL UNION ALL 
        SELECT 2886, 'Murska Sobota',194,0,NULL,1, 'SI-080', NULL UNION ALL 
        SELECT 2887, 'Muta',194,0,NULL,1, 'SI-081', NULL UNION ALL 
        SELECT 2888, 'Naklo',194,0,NULL,1, 'SI-082', NULL UNION ALL 
        SELECT 2889, 'Nazarje',194,0,NULL,1, 'SI-083', NULL UNION ALL 
        SELECT 2890, 'Nova Gorica',194,0,NULL,1, 'SI-084', NULL UNION ALL 
        SELECT 2891, 'Novo Mesto',194,0,NULL,1, 'SI-085', NULL UNION ALL 
        SELECT 2892, 'Odranci',194,0,NULL,1, 'SI-086', NULL UNION ALL 
        SELECT 2893, 'Oplotnica',194,0,NULL,1, 'SI-171', NULL UNION ALL 
        SELECT 2894, 'Ormož',194,0,NULL,1, 'SI-087', NULL UNION ALL 
        SELECT 2895, 'Osilnica',194,0,NULL,1, 'SI-088', NULL UNION ALL 
        SELECT 2896, 'Pesnica',194,0,NULL,1, 'SI-089', NULL UNION ALL 
        SELECT 2897, 'Piran',194,0,NULL,1, 'SI-090', NULL UNION ALL 
        SELECT 2898, 'Pivka',194,0,NULL,1, 'SI-091', NULL UNION ALL 
        SELECT 2899, 'Podlehnik',194,0,NULL,1, 'SI-172', NULL UNION ALL 
        SELECT 2900, 'Podvelka',194,0,NULL,1, 'SI-093', NULL UNION ALL 
        SELECT 2901, 'Podcetrtek',194,0,NULL,1, 'SI-092', NULL UNION ALL 
        SELECT 2902, 'Poljcane',194,0,NULL,1, 'SI-200', NULL UNION ALL 
        SELECT 2903, 'Polzela',194,0,NULL,1, 'SI-173', NULL UNION ALL 
        SELECT 2904, 'Postojna',194,0,NULL,1, 'SI-094', NULL UNION ALL 
        SELECT 2905, 'Prebold',194,0,NULL,1, 'SI-174', NULL UNION ALL 
        SELECT 2906, 'Preddvor',194,0,NULL,1, 'SI-095', NULL UNION ALL 
        SELECT 2907, 'Prevalje',194,0,NULL,1, 'SI-175', NULL UNION ALL 
        SELECT 2908, 'Ptuj',194,0,NULL,1, 'SI-096', NULL UNION ALL 
        SELECT 2909, 'Puconci',194,0,NULL,1, 'SI-097', NULL UNION ALL 
        SELECT 2910, 'Radenci',194,0,NULL,1, 'SI-100', NULL UNION ALL 
        SELECT 2911, 'Radece',194,0,NULL,1, 'SI-099', NULL UNION ALL 
        SELECT 2912, 'Radlje ob Dravi',194,0,NULL,1, 'SI-101', NULL UNION ALL 
        SELECT 2913, 'Radovljica',194,0,NULL,1, 'SI-102', NULL UNION ALL 
        SELECT 2914, 'Ravne na Koroškem',194,0,NULL,1, 'SI-103', NULL UNION ALL 
        SELECT 2915, 'Razkrižje',194,0,NULL,1, 'SI-176', NULL UNION ALL 
        SELECT 2916, 'Race-Fram',194,0,NULL,1, 'SI-098', NULL UNION ALL 
        SELECT 2917, 'Rence-Vogrsko',194,0,NULL,1, 'SI-201', NULL UNION ALL 
        SELECT 2918, 'Recica ob Savinji',194,0,NULL,1, 'SI-209', NULL UNION ALL 
        SELECT 2919, 'Ribnica',194,0,NULL,1, 'SI-104', NULL UNION ALL 
        SELECT 2920, 'Ribnica na Pohorju',194,0,NULL,1, 'SI-177', NULL UNION ALL 
        SELECT 2921, 'Rogatec',194,0,NULL,1, 'SI-107', NULL UNION ALL 
        SELECT 2922, 'Rogaška Slatina',194,0,NULL,1, 'SI-106', NULL UNION ALL 
        SELECT 2923, 'Rogašovci',194,0,NULL,1, 'SI-105', NULL UNION ALL 
        SELECT 2924, 'Ruše',194,0,NULL,1, 'SI-108', NULL UNION ALL 
        SELECT 2925, 'Selnica ob Dravi',194,0,NULL,1, 'SI-178', NULL UNION ALL 
        SELECT 2926, 'Semic',194,0,NULL,1, 'SI-109', NULL UNION ALL 
        SELECT 2927, 'Sevnica',194,0,NULL,1, 'SI-110', NULL UNION ALL 
        SELECT 2928, 'Sežana',194,0,NULL,1, 'SI-111', NULL UNION ALL 
        SELECT 2929, 'Slovenj Gradec',194,0,NULL,1, 'SI-112', NULL UNION ALL 
        SELECT 2930, 'Slovenska Bistrica',194,0,NULL,1, 'SI-113', NULL UNION ALL 
        SELECT 2931, 'Slovenske Konjice',194,0,NULL,1, 'SI-114', NULL UNION ALL 
        SELECT 2932, 'Sodražica',194,0,NULL,1, 'SI-179', NULL UNION ALL 
        SELECT 2933, 'Solcava',194,0,NULL,1, 'SI-180', NULL UNION ALL 
        SELECT 2934, 'Središce ob Dravi',194,0,NULL,1, 'SI-202', NULL UNION ALL 
        SELECT 2935, 'Starše',194,0,NULL,1, 'SI-115', NULL UNION ALL 
        SELECT 2936, 'Straža',194,0,NULL,1, 'SI-203', NULL UNION ALL 
        SELECT 2937, 'Sveta Ana',194,0,NULL,1, 'SI-181', NULL UNION ALL 
        SELECT 2938, 'Sveta Trojica v Slovenskih Goricah',194,0,NULL,1, 'SI-204', NULL UNION ALL 
        SELECT 2939, 'Sveti Andraž v Slovenskih Goricah',194,0,NULL,1, 'SI-182', NULL UNION ALL 
        SELECT 2940, 'Sveti Jurij',194,0,NULL,1, 'SI-116', NULL UNION ALL 
        SELECT 2941, 'Sveti Jurij v Slovenskih Goricah',194,0,NULL,1, 'SI-210', NULL UNION ALL 
        SELECT 2942, 'Sveti Tomaž',194,0,NULL,1, 'SI-205', NULL UNION ALL 
        SELECT 2943, 'Tabor',194,0,NULL,1, 'SI-184', NULL UNION ALL 
        SELECT 2944, 'Tišina',194,0,NULL,1, 'SI-010', NULL UNION ALL 
        SELECT 2945, 'Tolmin',194,0,NULL,1, 'SI-128', NULL UNION ALL 
        SELECT 2946, 'Trbovlje',194,0,NULL,1, 'SI-129', NULL UNION ALL 
        SELECT 2947, 'Trebnje',194,0,NULL,1, 'SI-130', NULL UNION ALL 
        SELECT 2948, 'Trnovska Vas',194,0,NULL,1, 'SI-185', NULL UNION ALL 
        SELECT 2949, 'Trzin',194,0,NULL,1, 'SI-186', NULL UNION ALL 
        SELECT 2950, 'Tržic',194,0,NULL,1, 'SI-131', NULL UNION ALL 
        SELECT 2951, 'Turnišce',194,0,NULL,1, 'SI-132', NULL UNION ALL 
        SELECT 2952, 'Velenje',194,0,NULL,1, 'SI-133', NULL UNION ALL 
        SELECT 2953, 'Velika Polana',194,0,NULL,1, 'SI-187', NULL UNION ALL 
        SELECT 2954, 'Velike Lašce',194,0,NULL,1, 'SI-134', NULL UNION ALL 
        SELECT 2955, 'Veržej',194,0,NULL,1, 'SI-188', NULL UNION ALL 
        SELECT 2956, 'Videm',194,0,NULL,1, 'SI-135', NULL UNION ALL 
        SELECT 2957, 'Vipava',194,0,NULL,1, 'SI-136', NULL UNION ALL 
        SELECT 2958, 'Vitanje',194,0,NULL,1, 'SI-137', NULL UNION ALL 
        SELECT 2959, 'Vodice',194,0,NULL,1, 'SI-138', NULL UNION ALL 
        SELECT 2960, 'Vojnik',194,0,NULL,1, 'SI-139', NULL UNION ALL 
        SELECT 2961, 'Vransko',194,0,NULL,1, 'SI-189', NULL UNION ALL 
        SELECT 2962, 'Vrhnika',194,0,NULL,1, 'SI-140', NULL UNION ALL 
        SELECT 2963, 'Vuzenica',194,0,NULL,1, 'SI-141', NULL UNION ALL 
        SELECT 2964, 'Zagorje ob Savi',194,0,NULL,1, 'SI-142', NULL UNION ALL 
        SELECT 2965, 'Zavrc',194,0,NULL,1, 'SI-143', NULL UNION ALL 
        SELECT 2966, 'Zrece',194,0,NULL,1, 'SI-144', NULL UNION ALL 
        SELECT 2967, 'Crenšovci',194,0,NULL,1, 'SI-015', NULL UNION ALL 
        SELECT 2968, 'Crna na Koroškem',194,0,NULL,1, 'SI-016', NULL UNION ALL 
        SELECT 2969, 'Crnomelj',194,0,NULL,1, 'SI-017', NULL UNION ALL 
        SELECT 2970, 'Šalovci',194,0,NULL,1, 'SI-033', NULL UNION ALL 
        SELECT 2971, 'Šempeter-Vrtojba',194,0,NULL,1, 'SI-183', NULL UNION ALL 
        SELECT 2972, 'Šentilj',194,0,NULL,1, 'SI-118', NULL UNION ALL 
        SELECT 2973, 'Šentjernej',194,0,NULL,1, 'SI-119', NULL UNION ALL 
        SELECT 2974, 'Šentjur',194,0,NULL,1, 'SI-120', NULL UNION ALL 
        SELECT 2975, 'Šentrupert',194,0,NULL,1, 'SI-211', NULL UNION ALL 
        SELECT 2976, 'Šencur',194,0,NULL,1, 'SI-117', NULL UNION ALL 
        SELECT 2977, 'Škocjan',194,0,NULL,1, 'SI-121', NULL UNION ALL 
        SELECT 2978, 'Škofja Loka',194,0,NULL,1, 'SI-122', NULL UNION ALL 
        SELECT 2979, 'Škofljica',194,0,NULL,1, 'SI-123', NULL UNION ALL 
        SELECT 2980, 'Šmarje pri Jelšah',194,0,NULL,1, 'SI-124', NULL UNION ALL 
        SELECT 2981, 'Šmarješke Toplice',194,0,NULL,1, 'SI-206', NULL UNION ALL 
        SELECT 2982, 'Šmartno ob Paki',194,0,NULL,1, 'SI-125', NULL UNION ALL 
        SELECT 2983, 'Šmartno pri Litiji',194,0,NULL,1, 'SI-194', NULL UNION ALL 
        SELECT 2984, 'Šoštanj',194,0,NULL,1, 'SI-126', NULL UNION ALL 
        SELECT 2985, 'Štore',194,0,NULL,1, 'SI-127', NULL UNION ALL 
        SELECT 2986, 'Žalec',194,0,NULL,1, 'SI-190', NULL UNION ALL 
        SELECT 2987, 'Železniki',194,0,NULL,1, 'SI-146', NULL UNION ALL 
        SELECT 2988, 'Žetale',194,0,NULL,1, 'SI-191', NULL UNION ALL 
        SELECT 2989, 'Žiri',194,0,NULL,1, 'SI-147', NULL UNION ALL 
        SELECT 2990, 'Žirovnica',194,0,NULL,1, 'SI-192', NULL UNION ALL 
        SELECT 2991, 'Žužemberk',194,0,NULL,1, 'SI-193', NULL UNION ALL 
        SELECT 2992, 'Capital Territory (Honiara)',195,0,NULL,1, 'SB-CT', NULL UNION ALL 
        SELECT 2993, 'Central',195,0,NULL,1, 'SB-CE', NULL UNION ALL 
        SELECT 2994, 'Choiseul',195,0,NULL,1, 'SB-CH', NULL UNION ALL 
        SELECT 2995, 'Guadalcanal',195,0,NULL,1, 'SB-GU', NULL UNION ALL 
        SELECT 2996, 'Isabel',195,0,NULL,1, 'SB-IS', NULL UNION ALL 
        SELECT 2997, 'Makira-Ulawa',195,0,NULL,1, 'SB-MK', NULL UNION ALL 
        SELECT 2998, 'Malaita',195,0,NULL,1, 'SB-ML', NULL UNION ALL 
        SELECT 2999, 'Rennell and Bellona',195,0,NULL,1, 'SB-RB', NULL UNION ALL 
        SELECT 3000, 'Temotu',195,0,NULL,1, 'SB-TE', NULL UNION ALL 
        SELECT 3001, 'Western',195,0,NULL,1, 'SB-WE', NULL UNION ALL 
        SELECT 3002, 'Awdal',196,0,NULL,1, 'SO-AW', NULL UNION ALL 
        SELECT 3003, 'Bakool',196,0,NULL,1, 'SO-BK', NULL UNION ALL 
        SELECT 3004, 'Banaadir',196,0,NULL,1, 'SO-BN', NULL UNION ALL 
        SELECT 3005, 'Bari',196,0,NULL,1, 'SO-BR', NULL UNION ALL 
        SELECT 3006, 'Bay',196,0,NULL,1, 'SO-BY', NULL UNION ALL 
        SELECT 3007, 'Galguduud',196,0,NULL,1, 'SO-GA', NULL UNION ALL 
        SELECT 3008, 'Gedo',196,0,NULL,1, 'SO-GE', NULL UNION ALL 
        SELECT 3009, 'Hiiraan',196,0,NULL,1, 'SO-HI', NULL UNION ALL 
        SELECT 3010, 'Jubbada Dhexe',196,0,NULL,1, 'SO-JD', NULL UNION ALL 
        SELECT 3011, 'Jubbada Hoose',196,0,NULL,1, 'SO-JH', NULL UNION ALL 
        SELECT 3012, 'Mudug',196,0,NULL,1, 'SO-MU', NULL UNION ALL 
        SELECT 3013, 'Nugaal',196,0,NULL,1, 'SO-NU', NULL UNION ALL 
        SELECT 3014, 'Sanaag',196,0,NULL,1, 'SO-SA', NULL UNION ALL 
        SELECT 3015, 'Shabeellaha Dhexe',196,0,NULL,1, 'SO-SD', NULL UNION ALL 
        SELECT 3016, 'Shabeellaha Hoose',196,0,NULL,1, 'SO-SH', NULL UNION ALL 
        SELECT 3017, 'Sool',196,0,NULL,1, 'SO-SO', NULL UNION ALL 
        SELECT 3018, 'Togdheer',196,0,NULL,1, 'SO-TO', NULL UNION ALL 
        SELECT 3019, 'Woqooyi Galbeed',196,0,NULL,1, 'SO-WO', NULL UNION ALL 
        SELECT 3020, 'Brokopondo',202,0,NULL,1, 'SR-BR', NULL UNION ALL 
        SELECT 3021, 'Commewijne',202,0,NULL,1, 'SR-CM', NULL UNION ALL 
        SELECT 3022, 'Coronie',202,0,NULL,1, 'SR-CR', NULL UNION ALL 
        SELECT 3023, 'Marowijne',202,0,NULL,1, 'SR-MA', NULL UNION ALL 
        SELECT 3024, 'Nickerie',202,0,NULL,1, 'SR-NI', NULL UNION ALL 
        SELECT 3025, 'Para',202,0,NULL,1, 'SR-PR', NULL UNION ALL 
        SELECT 3026, 'Paramaribo',202,0,NULL,1, 'SR-PM', NULL UNION ALL 
        SELECT 3027, 'Saramacca',202,0,NULL,1, 'SR-SA', NULL UNION ALL 
        SELECT 3028, 'Sipaliwini',202,0,NULL,1, 'SR-SI', NULL UNION ALL 
        SELECT 3029, 'Wanica',202,0,NULL,1, 'SR-WA', NULL UNION ALL 
        SELECT 3030, 'Blekinge län [SE-10]',205,0,NULL,1, 'SE-K', NULL UNION ALL 
        SELECT 3031, 'Dalarnas län [SE-20]',205,0,NULL,1, 'SE-W', NULL UNION ALL 
        SELECT 3032, 'Gotlands län [SE-09]',205,0,NULL,1, 'SE-I', NULL UNION ALL 
        SELECT 3033, 'Gävleborgs län [SE-21]',205,0,NULL,1, 'SE-X', NULL UNION ALL 
        SELECT 3034, 'Hallands län [SE-13]',205,0,NULL,1, 'SE-N', NULL UNION ALL 
        SELECT 3035, 'Jämtlands län [SE-23]',205,0,NULL,1, 'SE-Z', NULL UNION ALL 
        SELECT 3036, 'Jönköpings län [SE-06]',205,0,NULL,1, 'SE-F', NULL UNION ALL 
        SELECT 3037, 'Kalmar län [SE-08]',205,0,NULL,1, 'SE-H', NULL UNION ALL 
        SELECT 3038, 'Kronobergs län [SE-07]',205,0,NULL,1, 'SE-G', NULL UNION ALL 
        SELECT 3039, 'Norrbottens län [SE-25]',205,0,NULL,1, 'SE-BD', NULL UNION ALL 
        SELECT 3040, 'Skåne län [SE-12]',205,0,NULL,1, 'SE-M', NULL UNION ALL 
        SELECT 3041, 'Stockholms län [SE-01]',205,0,NULL,1, 'SE-AB', NULL UNION ALL 
        SELECT 3042, 'Södermanlands län [SE-04]',205,0,NULL,1, 'SE-D', NULL UNION ALL 
        SELECT 3043, 'Uppsala län [SE-03]',205,0,NULL,1, 'SE-C', NULL UNION ALL 
        SELECT 3044, 'Värmlands län [SE-17]',205,0,NULL,1, 'SE-S', NULL UNION ALL 
        SELECT 3045, 'Västerbottens län [SE-24]',205,0,NULL,1, 'SE-AC', NULL UNION ALL 
        SELECT 3046, 'Västernorrlands län [SE-22]',205,0,NULL,1, 'SE-Y', NULL UNION ALL 
        SELECT 3047, 'Västmanlands län [SE-19]',205,0,NULL,1, 'SE-U', NULL UNION ALL 
        SELECT 3048, 'Västra Götalands län [SE-14]',205,0,NULL,1, 'SE-O', NULL UNION ALL 
        SELECT 3049, 'Örebro län [SE-18]',205,0,NULL,1, 'SE-T', NULL UNION ALL 
        SELECT 3050, 'Östergötlands län [SE-05]',205,0,NULL,1, 'SE-E', NULL UNION ALL 
        SELECT 3051, 'Al Ladhiqiyah',207,0,NULL,1, 'SY-LA', NULL UNION ALL 
        SELECT 3052, 'Al Qunaytirah',207,0,NULL,1, 'SY-QU', NULL UNION ALL 
        SELECT 3053, 'Al ?asakah',207,0,NULL,1, 'SY-HA', NULL UNION ALL 
        SELECT 3054, 'Ar Raqqah',207,0,NULL,1, 'SY-RA', NULL UNION ALL 
        SELECT 3055, 'As Suwayda''',207,0,NULL,1, 'SY-SU', NULL UNION ALL 
        SELECT 3056, 'Dar''a',207,0,NULL,1, 'SY-DR', NULL UNION ALL 
        SELECT 3057, 'Dayr az Zawr',207,0,NULL,1, 'SY-DY', NULL UNION ALL 
        SELECT 3058, 'Dimashq',207,0,NULL,1, 'SY-DI', NULL UNION ALL 
        SELECT 3059, 'Idlib',207,0,NULL,1, 'SY-ID', NULL UNION ALL 
        SELECT 3060, 'Rif Dimashq',207,0,NULL,1, 'SY-RD', NULL UNION ALL 
        SELECT 3061, 'Tartus',207,0,NULL,1, 'SY-TA', NULL UNION ALL 
        SELECT 3062, '?alab',207,0,NULL,1, 'SY-HL', NULL UNION ALL 
        SELECT 3063, '?amah',207,0,NULL,1, 'SY-HM', NULL UNION ALL 
        SELECT 3064, '?ims',207,0,NULL,1, 'SY-HI', NULL UNION ALL 
        SELECT 3065, 'Changhua',208,0,NULL,1, 'TW-CHA', NULL UNION ALL 
        SELECT 3066, 'Chiayi',208,0,NULL,1, 'TW-CYI', NULL UNION ALL 
        SELECT 3067, 'Chiayi',208,0,NULL,1, 'TW-CYQ', NULL UNION ALL 
        SELECT 3068, 'Hsinchu',208,0,NULL,1, 'TW-HSZ', NULL UNION ALL 
        SELECT 3069, 'Hsinchu',208,0,NULL,1, 'TW-HSQ', NULL UNION ALL 
        SELECT 3070, 'Hualien',208,0,NULL,1, 'TW-HUA', NULL UNION ALL 
        SELECT 3071, 'Kaohsiung',208,0,NULL,1, 'TW-KHH', NULL UNION ALL 
        SELECT 3072, 'Keelung',208,0,NULL,1, 'TW-KEE', NULL UNION ALL 
        SELECT 3073, 'Kinmen',208,0,NULL,1, 'TW-KIN', NULL UNION ALL 
        SELECT 3074, 'Lienchiang',208,0,NULL,1, 'TW-LIE', NULL UNION ALL 
        SELECT 3075, 'Miaoli',208,0,NULL,1, 'TW-MIA', NULL UNION ALL 
        SELECT 3076, 'Nantou',208,0,NULL,1, 'TW-NAN', NULL UNION ALL 
        SELECT 3077, 'New Taipei',208,0,NULL,1, 'TW-NWT', NULL UNION ALL 
        SELECT 3078, 'Penghu',208,0,NULL,1, 'TW-PEN', NULL UNION ALL 
        SELECT 3079, 'Pingtung',208,0,NULL,1, 'TW-PIF', NULL UNION ALL 
        SELECT 3080, 'Taichung',208,0,NULL,1, 'TW-TXG', NULL UNION ALL 
        SELECT 3081, 'Tainan',208,0,NULL,1, 'TW-TNN', NULL UNION ALL 
        SELECT 3082, 'Taipei',208,0,NULL,1, 'TW-TPE', NULL UNION ALL 
        SELECT 3083, 'Taitung',208,0,NULL,1, 'TW-TTT', NULL UNION ALL 
        SELECT 3084, 'Taoyuan',208,0,NULL,1, 'TW-TAO', NULL UNION ALL 
        SELECT 3085, 'Yilan',208,0,NULL,1, 'TW-ILA', NULL UNION ALL 
        SELECT 3086, 'Yunlin',208,0,NULL,1, 'TW-YUN', NULL UNION ALL 
        SELECT 3087, 'Dushanbe',209,0,NULL,1, 'TJ-DU', NULL UNION ALL 
        SELECT 3088, 'Khatlon',209,0,NULL,1, 'TJ-KT', NULL UNION ALL 
        SELECT 3089, 'Kuhistoni Badakhshon',209,0,NULL,1, 'TJ-GB', NULL UNION ALL 
        SELECT 3090, 'Sughd',209,0,NULL,1, 'TJ-SU', NULL UNION ALL 
        SELECT 3091, 'nohiyahoi tobei jumhurí',209,0,NULL,1, 'TJ-RA', NULL UNION ALL 
        SELECT 3092, 'Amnat Charoen',211,0,NULL,1, 'TH-37', NULL UNION ALL 
        SELECT 3093, 'Ang Thong',211,0,NULL,1, 'TH-15', NULL UNION ALL 
        SELECT 3094, 'Bueng Kan',211,0,NULL,1, 'TH-38', NULL UNION ALL 
        SELECT 3095, 'Buri Ram',211,0,NULL,1, 'TH-31', NULL UNION ALL 
        SELECT 3096, 'Chachoengsao',211,0,NULL,1, 'TH-24', NULL UNION ALL 
        SELECT 3097, 'Chai Nat',211,0,NULL,1, 'TH-18', NULL UNION ALL 
        SELECT 3098, 'Chaiyaphum',211,0,NULL,1, 'TH-36', NULL UNION ALL 
        SELECT 3099, 'Chanthaburi',211,0,NULL,1, 'TH-22', NULL UNION ALL 
        SELECT 3100, 'Chiang Mai',211,0,NULL,1, 'TH-50', NULL UNION ALL 
        SELECT 3101, 'Chiang Rai',211,0,NULL,1, 'TH-57', NULL UNION ALL 
        SELECT 3102, 'Chon Buri',211,0,NULL,1, 'TH-20', NULL UNION ALL 
        SELECT 3103, 'Chumphon',211,0,NULL,1, 'TH-86', NULL UNION ALL 
        SELECT 3104, 'Kalasin',211,0,NULL,1, 'TH-46', NULL UNION ALL 
        SELECT 3105, 'Kamphaeng Phet',211,0,NULL,1, 'TH-62', NULL UNION ALL 
        SELECT 3106, 'Kanchanaburi',211,0,NULL,1, 'TH-71', NULL UNION ALL 
        SELECT 3107, 'Khon Kaen',211,0,NULL,1, 'TH-40', NULL UNION ALL 
        SELECT 3108, 'Krabi',211,0,NULL,1, 'TH-81', NULL UNION ALL 
        SELECT 3109, 'Krung Thep Maha Nakhon',211,0,NULL,1, 'TH-10', NULL UNION ALL 
        SELECT 3110, 'Lampang',211,0,NULL,1, 'TH-52', NULL UNION ALL 
        SELECT 3111, 'Lamphun',211,0,NULL,1, 'TH-51', NULL UNION ALL 
        SELECT 3112, 'Loei',211,0,NULL,1, 'TH-42', NULL UNION ALL 
        SELECT 3113, 'Lop Buri',211,0,NULL,1, 'TH-16', NULL UNION ALL 
        SELECT 3114, 'Mae Hong Son',211,0,NULL,1, 'TH-58', NULL UNION ALL 
        SELECT 3115, 'Maha Sarakham',211,0,NULL,1, 'TH-44', NULL UNION ALL 
        SELECT 3116, 'Mukdahan',211,0,NULL,1, 'TH-49', NULL UNION ALL 
        SELECT 3117, 'Nakhon Nayok',211,0,NULL,1, 'TH-26', NULL UNION ALL 
        SELECT 3118, 'Nakhon Pathom',211,0,NULL,1, 'TH-73', NULL UNION ALL 
        SELECT 3119, 'Nakhon Phanom',211,0,NULL,1, 'TH-48', NULL UNION ALL 
        SELECT 3120, 'Nakhon Ratchasima',211,0,NULL,1, 'TH-30', NULL UNION ALL 
        SELECT 3121, 'Nakhon Sawan',211,0,NULL,1, 'TH-60', NULL UNION ALL 
        SELECT 3122, 'Nakhon Si Thammarat',211,0,NULL,1, 'TH-80', NULL UNION ALL 
        SELECT 3123, 'Nan',211,0,NULL,1, 'TH-55', NULL UNION ALL 
        SELECT 3124, 'Narathiwat',211,0,NULL,1, 'TH-96', NULL UNION ALL 
        SELECT 3125, 'Nong Bua Lam Phu',211,0,NULL,1, 'TH-39', NULL UNION ALL 
        SELECT 3126, 'Nong Khai',211,0,NULL,1, 'TH-43', NULL UNION ALL 
        SELECT 3127, 'Nonthaburi',211,0,NULL,1, 'TH-12', NULL UNION ALL 
        SELECT 3128, 'Pathum Thani',211,0,NULL,1, 'TH-13', NULL UNION ALL 
        SELECT 3129, 'Pattani',211,0,NULL,1, 'TH-94', NULL UNION ALL 
        SELECT 3130, 'Phangnga',211,0,NULL,1, 'TH-82', NULL UNION ALL 
        SELECT 3131, 'Phatthalung',211,0,NULL,1, 'TH-93', NULL UNION ALL 
        SELECT 3132, 'Phatthaya',211,0,NULL,1, 'TH-S', NULL UNION ALL 
        SELECT 3133, 'Phayao',211,0,NULL,1, 'TH-56', NULL UNION ALL 
        SELECT 3134, 'Phetchabun',211,0,NULL,1, 'TH-67', NULL UNION ALL 
        SELECT 3135, 'Phetchaburi',211,0,NULL,1, 'TH-76', NULL UNION ALL 
        SELECT 3136, 'Phichit',211,0,NULL,1, 'TH-66', NULL UNION ALL 
        SELECT 3137, 'Phitsanulok',211,0,NULL,1, 'TH-65', NULL UNION ALL 
        SELECT 3138, 'Phra Nakhon Si Ayutthaya',211,0,NULL,1, 'TH-14', NULL UNION ALL 
        SELECT 3139, 'Phrae',211,0,NULL,1, 'TH-54', NULL UNION ALL 
        SELECT 3140, 'Phuket',211,0,NULL,1, 'TH-83', NULL UNION ALL 
        SELECT 3141, 'Prachin Buri',211,0,NULL,1, 'TH-25', NULL UNION ALL 
        SELECT 3142, 'Prachuap Khiri Khan',211,0,NULL,1, 'TH-77', NULL UNION ALL 
        SELECT 3143, 'Ranong',211,0,NULL,1, 'TH-85', NULL UNION ALL 
        SELECT 3144, 'Ratchaburi',211,0,NULL,1, 'TH-70', NULL UNION ALL 
        SELECT 3145, 'Rayong',211,0,NULL,1, 'TH-21', NULL UNION ALL 
        SELECT 3146, 'Roi Et',211,0,NULL,1, 'TH-45', NULL UNION ALL 
        SELECT 3147, 'Sa Kaeo',211,0,NULL,1, 'TH-27', NULL UNION ALL 
        SELECT 3148, 'Sakon Nakhon',211,0,NULL,1, 'TH-47', NULL UNION ALL 
        SELECT 3149, 'Samut Prakan',211,0,NULL,1, 'TH-11', NULL UNION ALL 
        SELECT 3150, 'Samut Sakhon',211,0,NULL,1, 'TH-74', NULL UNION ALL 
        SELECT 3151, 'Samut Songkhram',211,0,NULL,1, 'TH-75', NULL UNION ALL 
        SELECT 3152, 'Saraburi',211,0,NULL,1, 'TH-19', NULL UNION ALL 
        SELECT 3153, 'Satun',211,0,NULL,1, 'TH-91', NULL UNION ALL 
        SELECT 3154, 'Si Sa Ket',211,0,NULL,1, 'TH-33', NULL UNION ALL 
        SELECT 3155, 'Sing Buri',211,0,NULL,1, 'TH-17', NULL UNION ALL 
        SELECT 3156, 'Songkhla',211,0,NULL,1, 'TH-90', NULL UNION ALL 
        SELECT 3157, 'Sukhothai',211,0,NULL,1, 'TH-64', NULL UNION ALL 
        SELECT 3158, 'Suphan Buri',211,0,NULL,1, 'TH-72', NULL UNION ALL 
        SELECT 3159, 'Surat Thani',211,0,NULL,1, 'TH-84', NULL UNION ALL 
        SELECT 3160, 'Surin',211,0,NULL,1, 'TH-32', NULL UNION ALL 
        SELECT 3161, 'Tak',211,0,NULL,1, 'TH-63', NULL UNION ALL 
        SELECT 3162, 'Trang',211,0,NULL,1, 'TH-92', NULL UNION ALL 
        SELECT 3163, 'Trat',211,0,NULL,1, 'TH-23', NULL UNION ALL 
        SELECT 3164, 'Ubon Ratchathani',211,0,NULL,1, 'TH-34', NULL UNION ALL 
        SELECT 3165, 'Udon Thani',211,0,NULL,1, 'TH-41', NULL UNION ALL 
        SELECT 3166, 'Uthai Thani',211,0,NULL,1, 'TH-61', NULL UNION ALL 
        SELECT 3167, 'Uttaradit',211,0,NULL,1, 'TH-53', NULL UNION ALL 
        SELECT 3168, 'Yala',211,0,NULL,1, 'TH-95', NULL UNION ALL 
        SELECT 3169, 'Yasothon',211,0,NULL,1, 'TH-35', NULL UNION ALL 
        SELECT 3170, 'Centrale',212,0,NULL,1, 'TG-C', NULL UNION ALL 
        SELECT 3171, 'Kara',212,0,NULL,1, 'TG-K', NULL UNION ALL 
        SELECT 3172, 'Maritime (Région)',212,0,NULL,1, 'TG-M', NULL UNION ALL 
        SELECT 3173, 'Plateaux',212,0,NULL,1, 'TG-P', NULL UNION ALL 
        SELECT 3174, 'Savanes',212,0,NULL,1, 'TG-S', NULL UNION ALL 
        SELECT 3175, 'Arima',215,0,NULL,1, 'TT-ARI', NULL UNION ALL 
        SELECT 3176, 'Chaguanas',215,0,NULL,1, 'TT-CHA', NULL UNION ALL 
        SELECT 3177, 'Couva-Tabaquite-Talparo',215,0,NULL,1, 'TT-CTT', NULL UNION ALL 
        SELECT 3178, 'Diego Martin',215,0,NULL,1, 'TT-DMN', NULL UNION ALL 
        SELECT 3179, 'Mayaro-Rio Claro',215,0,NULL,1, 'TT-MRC', NULL UNION ALL 
        SELECT 3180, 'Penal-Debe',215,0,NULL,1, 'TT-PED', NULL UNION ALL 
        SELECT 3181, 'Point Fortin',215,0,NULL,1, 'TT-PTF', NULL UNION ALL 
        SELECT 3182, 'Port of Spain',215,0,NULL,1, 'TT-POS', NULL UNION ALL 
        SELECT 3183, 'Princes Town',215,0,NULL,1, 'TT-PRT', NULL UNION ALL 
        SELECT 3184, 'San Fernando',215,0,NULL,1, 'TT-SFO', NULL UNION ALL 
        SELECT 3185, 'San Juan-Laventille',215,0,NULL,1, 'TT-SJL', NULL UNION ALL 
        SELECT 3186, 'Sangre Grande',215,0,NULL,1, 'TT-SGE', NULL UNION ALL 
        SELECT 3187, 'Siparia',215,0,NULL,1, 'TT-SIP', NULL UNION ALL 
        SELECT 3188, 'Tobago',215,0,NULL,1, 'TT-TOB', NULL UNION ALL 
        SELECT 3189, 'Tunapuna-Piarco',215,0,NULL,1, 'TT-TUP', NULL UNION ALL 
        SELECT 3190, 'Ben Arous',216,0,NULL,1, 'TN-13', NULL UNION ALL 
        SELECT 3191, 'Bizerte',216,0,NULL,1, 'TN-23', NULL UNION ALL 
        SELECT 3192, 'Béja',216,0,NULL,1, 'TN-31', NULL UNION ALL 
        SELECT 3193, 'Gabès',216,0,NULL,1, 'TN-81', NULL UNION ALL 
        SELECT 3194, 'Gafsa',216,0,NULL,1, 'TN-71', NULL UNION ALL 
        SELECT 3195, 'Jendouba',216,0,NULL,1, 'TN-32', NULL UNION ALL 
        SELECT 3196, 'Kairouan',216,0,NULL,1, 'TN-41', NULL UNION ALL 
        SELECT 3197, 'Kasserine',216,0,NULL,1, 'TN-42', NULL UNION ALL 
        SELECT 3198, 'Kébili',216,0,NULL,1, 'TN-73', NULL UNION ALL 
        SELECT 3199, 'L''Ariana',216,0,NULL,1, 'TN-12', NULL UNION ALL 
        SELECT 3200, 'La Manouba',216,0,NULL,1, 'TN-14', NULL UNION ALL 
        SELECT 3201, 'Le Kef',216,0,NULL,1, 'TN-33', NULL UNION ALL 
        SELECT 3202, 'Mahdia',216,0,NULL,1, 'TN-53', NULL UNION ALL 
        SELECT 3203, 'Monastir',216,0,NULL,1, 'TN-52', NULL UNION ALL 
        SELECT 3204, 'Médenine',216,0,NULL,1, 'TN-82', NULL UNION ALL 
        SELECT 3205, 'Nabeul',216,0,NULL,1, 'TN-21', NULL UNION ALL 
        SELECT 3206, 'Sfax',216,0,NULL,1, 'TN-61', NULL UNION ALL 
        SELECT 3207, 'Sidi Bouzid',216,0,NULL,1, 'TN-43', NULL UNION ALL 
        SELECT 3208, 'Siliana',216,0,NULL,1, 'TN-34', NULL UNION ALL 
        SELECT 3209, 'Sousse',216,0,NULL,1, 'TN-51', NULL UNION ALL 
        SELECT 3210, 'Tataouine',216,0,NULL,1, 'TN-83', NULL UNION ALL 
        SELECT 3211, 'Tozeur',216,0,NULL,1, 'TN-72', NULL UNION ALL 
        SELECT 3212, 'Tunis',216,0,NULL,1, 'TN-11', NULL UNION ALL 
        SELECT 3213, 'Zaghouan',216,0,NULL,1, 'TN-22', NULL UNION ALL 
        SELECT 3214, 'Adana',217,0,NULL,1, 'TR-01', NULL UNION ALL 
        SELECT 3215, 'Adiyaman',217,0,NULL,1, 'TR-02', NULL UNION ALL 
        SELECT 3216, 'Afyonkarahisar',217,0,NULL,1, 'TR-03', NULL UNION ALL 
        SELECT 3217, 'Aksaray',217,0,NULL,1, 'TR-68', NULL UNION ALL 
        SELECT 3218, 'Amasya',217,0,NULL,1, 'TR-05', NULL UNION ALL 
        SELECT 3219, 'Ankara',217,0,NULL,1, 'TR-06', NULL UNION ALL 
        SELECT 3220, 'Antalya',217,0,NULL,1, 'TR-07', NULL UNION ALL 
        SELECT 3221, 'Ardahan',217,0,NULL,1, 'TR-75', NULL UNION ALL 
        SELECT 3222, 'Artvin',217,0,NULL,1, 'TR-08', NULL UNION ALL 
        SELECT 3223, 'Aydin',217,0,NULL,1, 'TR-09', NULL UNION ALL 
        SELECT 3224, 'Agri',217,0,NULL,1, 'TR-04', NULL UNION ALL 
        SELECT 3225, 'Balikesir',217,0,NULL,1, 'TR-10', NULL UNION ALL 
        SELECT 3226, 'Bartin',217,0,NULL,1, 'TR-74', NULL UNION ALL 
        SELECT 3227, 'Batman',217,0,NULL,1, 'TR-72', NULL UNION ALL 
        SELECT 3228, 'Bayburt',217,0,NULL,1, 'TR-69', NULL UNION ALL 
        SELECT 3229, 'Bilecik',217,0,NULL,1, 'TR-11', NULL UNION ALL 
        SELECT 3230, 'Bingöl',217,0,NULL,1, 'TR-12', NULL UNION ALL 
        SELECT 3231, 'Bitlis',217,0,NULL,1, 'TR-13', NULL UNION ALL 
        SELECT 3232, 'Bolu',217,0,NULL,1, 'TR-14', NULL UNION ALL 
        SELECT 3233, 'Burdur',217,0,NULL,1, 'TR-15', NULL UNION ALL 
        SELECT 3234, 'Bursa',217,0,NULL,1, 'TR-16', NULL UNION ALL 
        SELECT 3235, 'Denizli',217,0,NULL,1, 'TR-20', NULL UNION ALL 
        SELECT 3236, 'Diyarbakir',217,0,NULL,1, 'TR-21', NULL UNION ALL 
        SELECT 3237, 'Düzce',217,0,NULL,1, 'TR-81', NULL UNION ALL 
        SELECT 3238, 'Edirne',217,0,NULL,1, 'TR-22', NULL UNION ALL 
        SELECT 3239, 'Elazig',217,0,NULL,1, 'TR-23', NULL UNION ALL 
        SELECT 3240, 'Erzincan',217,0,NULL,1, 'TR-24', NULL UNION ALL 
        SELECT 3241, 'Erzurum',217,0,NULL,1, 'TR-25', NULL UNION ALL 
        SELECT 3242, 'Eskisehir',217,0,NULL,1, 'TR-26', NULL UNION ALL 
        SELECT 3243, 'Gaziantep',217,0,NULL,1, 'TR-27', NULL UNION ALL 
        SELECT 3244, 'Giresun',217,0,NULL,1, 'TR-28', NULL UNION ALL 
        SELECT 3245, 'Gümüshane',217,0,NULL,1, 'TR-29', NULL UNION ALL 
        SELECT 3246, 'Hakkâri',217,0,NULL,1, 'TR-30', NULL UNION ALL 
        SELECT 3247, 'Hatay',217,0,NULL,1, 'TR-31', NULL UNION ALL 
        SELECT 3248, 'Isparta',217,0,NULL,1, 'TR-32', NULL UNION ALL 
        SELECT 3249, 'Igdir',217,0,NULL,1, 'TR-76', NULL UNION ALL 
        SELECT 3250, 'Kahramanmaras',217,0,NULL,1, 'TR-46', NULL UNION ALL 
        SELECT 3251, 'Karabük',217,0,NULL,1, 'TR-78', NULL UNION ALL 
        SELECT 3252, 'Karaman',217,0,NULL,1, 'TR-70', NULL UNION ALL 
        SELECT 3253, 'Kars',217,0,NULL,1, 'TR-36', NULL UNION ALL 
        SELECT 3254, 'Kastamonu',217,0,NULL,1, 'TR-37', NULL UNION ALL 
        SELECT 3255, 'Kayseri',217,0,NULL,1, 'TR-38', NULL UNION ALL 
        SELECT 3256, 'Kilis',217,0,NULL,1, 'TR-79', NULL UNION ALL 
        SELECT 3257, 'Kocaeli',217,0,NULL,1, 'TR-41', NULL UNION ALL 
        SELECT 3258, 'Konya',217,0,NULL,1, 'TR-42', NULL UNION ALL 
        SELECT 3259, 'Kütahya',217,0,NULL,1, 'TR-43', NULL UNION ALL 
        SELECT 3260, 'Kirklareli',217,0,NULL,1, 'TR-39', NULL UNION ALL 
        SELECT 3261, 'Kirikkale',217,0,NULL,1, 'TR-71', NULL UNION ALL 
        SELECT 3262, 'Kirsehir',217,0,NULL,1, 'TR-40', NULL UNION ALL 
        SELECT 3263, 'Malatya',217,0,NULL,1, 'TR-44', NULL UNION ALL 
        SELECT 3264, 'Manisa',217,0,NULL,1, 'TR-45', NULL UNION ALL 
        SELECT 3265, 'Mardin',217,0,NULL,1, 'TR-47', NULL UNION ALL 
        SELECT 3266, 'Mersin',217,0,NULL,1, 'TR-33', NULL UNION ALL 
        SELECT 3267, 'Mugla',217,0,NULL,1, 'TR-48', NULL UNION ALL 
        SELECT 3268, 'Mus',217,0,NULL,1, 'TR-49', NULL UNION ALL 
        SELECT 3269, 'Nevsehir',217,0,NULL,1, 'TR-50', NULL UNION ALL 
        SELECT 3270, 'Nigde',217,0,NULL,1, 'TR-51', NULL UNION ALL 
        SELECT 3271, 'Ordu',217,0,NULL,1, 'TR-52', NULL UNION ALL 
        SELECT 3272, 'Osmaniye',217,0,NULL,1, 'TR-80', NULL UNION ALL 
        SELECT 3273, 'Rize',217,0,NULL,1, 'TR-53', NULL UNION ALL 
        SELECT 3274, 'Sakarya',217,0,NULL,1, 'TR-54', NULL UNION ALL 
        SELECT 3275, 'Samsun',217,0,NULL,1, 'TR-55', NULL UNION ALL 
        SELECT 3276, 'Siirt',217,0,NULL,1, 'TR-56', NULL UNION ALL 
        SELECT 3277, 'Sinop',217,0,NULL,1, 'TR-57', NULL UNION ALL 
        SELECT 3278, 'Sivas',217,0,NULL,1, 'TR-58', NULL UNION ALL 
        SELECT 3279, 'Tekirdag',217,0,NULL,1, 'TR-59', NULL UNION ALL 
        SELECT 3280, 'Tokat',217,0,NULL,1, 'TR-60', NULL UNION ALL 
        SELECT 3281, 'Trabzon',217,0,NULL,1, 'TR-61', NULL UNION ALL 
        SELECT 3282, 'Tunceli',217,0,NULL,1, 'TR-62', NULL UNION ALL 
        SELECT 3283, 'Usak',217,0,NULL,1, 'TR-64', NULL UNION ALL 
        SELECT 3284, 'Van',217,0,NULL,1, 'TR-65', NULL UNION ALL 
        SELECT 3285, 'Yalova',217,0,NULL,1, 'TR-77', NULL UNION ALL 
        SELECT 3286, 'Yozgat',217,0,NULL,1, 'TR-66', NULL UNION ALL 
        SELECT 3287, 'Zonguldak',217,0,NULL,1, 'TR-67', NULL UNION ALL 
        SELECT 3288, 'Çanakkale',217,0,NULL,1, 'TR-17', NULL UNION ALL 
        SELECT 3289, 'Çankiri',217,0,NULL,1, 'TR-18', NULL UNION ALL 
        SELECT 3290, 'Çorum',217,0,NULL,1, 'TR-19', NULL UNION ALL 
        SELECT 3291, 'Istanbul',217,0,NULL,1, 'TR-34', NULL UNION ALL 
        SELECT 3292, 'Izmir',217,0,NULL,1, 'TR-35', NULL UNION ALL 
        SELECT 3293, 'Sanliurfa',217,0,NULL,1, 'TR-63', NULL UNION ALL 
        SELECT 3294, 'Sirnak',217,0,NULL,1, 'TR-73', NULL UNION ALL 
        SELECT 3295, 'Ahal',218,0,NULL,1, 'TM-A', NULL UNION ALL 
        SELECT 3296, 'Asgabat',218,0,NULL,1, 'TM-S', NULL UNION ALL 
        SELECT 3297, 'Balkan',218,0,NULL,1, 'TM-B', NULL UNION ALL 
        SELECT 3298, 'Dasoguz',218,0,NULL,1, 'TM-D', NULL UNION ALL 
        SELECT 3299, 'Lebap',218,0,NULL,1, 'TM-L', NULL UNION ALL 
        SELECT 3300, 'Mary',218,0,NULL,1, 'TM-M', NULL UNION ALL 
        SELECT 3301, 'Funafuti',220,0,NULL,1, 'TV-FUN', NULL UNION ALL 
        SELECT 3302, 'Nanumaga',220,0,NULL,1, 'TV-NMG', NULL UNION ALL 
        SELECT 3303, 'Nanumea',220,0,NULL,1, 'TV-NMA', NULL UNION ALL 
        SELECT 3304, 'Niutao',220,0,NULL,1, 'TV-NIT', NULL UNION ALL 
        SELECT 3305, 'Nui',220,0,NULL,1, 'TV-NUI', NULL UNION ALL 
        SELECT 3306, 'Nukufetau',220,0,NULL,1, 'TV-NKF', NULL UNION ALL 
        SELECT 3307, 'Nukulaelae',220,0,NULL,1, 'TV-NKL', NULL UNION ALL 
        SELECT 3308, 'Vaitupu',220,0,NULL,1, 'TV-VAI', NULL UNION ALL 
        SELECT 3309, 'Abim',221,0,NULL,1, 'UG-314', 'UG-N' UNION ALL 
        SELECT 3310, 'Adjumani',221,0,NULL,1, 'UG-301', 'UG-N' UNION ALL 
        SELECT 3311, 'Agago',221,0,NULL,1, 'UG-322', 'UG-N' UNION ALL 
        SELECT 3312, 'Alebtong',221,0,NULL,1, 'UG-323', 'UG-N' UNION ALL 
        SELECT 3313, 'Amolatar',221,0,NULL,1, 'UG-315', 'UG-N' UNION ALL 
        SELECT 3314, 'Amudat',221,0,NULL,1, 'UG-324', 'UG-N' UNION ALL 
        SELECT 3315, 'Amuria',221,0,NULL,1, 'UG-216', 'UG-E' UNION ALL 
        SELECT 3316, 'Amuru',221,0,NULL,1, 'UG-316', 'UG-N' UNION ALL 
        SELECT 3317, 'Apac',221,0,NULL,1, 'UG-302', 'UG-N' UNION ALL 
        SELECT 3318, 'Arua',221,0,NULL,1, 'UG-303', 'UG-N' UNION ALL 
        SELECT 3319, 'Budaka',221,0,NULL,1, 'UG-217', 'UG-E' UNION ALL 
        SELECT 3320, 'Bududa',221,0,NULL,1, 'UG-218', 'UG-E' UNION ALL 
        SELECT 3321, 'Bugiri',221,0,NULL,1, 'UG-201', 'UG-E' UNION ALL 
        SELECT 3322, 'Bugweri',221,0,NULL,1, 'UG-235', 'UG-E' UNION ALL 
        SELECT 3323, 'Buhweju',221,0,NULL,1, 'UG-420', 'UG-W' UNION ALL 
        SELECT 3324, 'Buikwe',221,0,NULL,1, 'UG-117', 'UG-C' UNION ALL 
        SELECT 3325, 'Bukedea',221,0,NULL,1, 'UG-219', 'UG-E' UNION ALL 
        SELECT 3326, 'Bukomansibi',221,0,NULL,1, 'UG-118', 'UG-C' UNION ALL 
        SELECT 3327, 'Bukwa',221,0,NULL,1, 'UG-220', 'UG-E' UNION ALL 
        SELECT 3328, 'Bulambuli',221,0,NULL,1, 'UG-225', 'UG-E' UNION ALL 
        SELECT 3329, 'Buliisa',221,0,NULL,1, 'UG-416', 'UG-W' UNION ALL 
        SELECT 3330, 'Bundibugyo',221,0,NULL,1, 'UG-401', 'UG-W' UNION ALL 
        SELECT 3331, 'Bunyangabu',221,0,NULL,1, 'UG-430', 'UG-W' UNION ALL 
        SELECT 3332, 'Bushenyi',221,0,NULL,1, 'UG-402', 'UG-W' UNION ALL 
        SELECT 3333, 'Busia',221,0,NULL,1, 'UG-202', 'UG-E' UNION ALL 
        SELECT 3334, 'Butaleja',221,0,NULL,1, 'UG-221', 'UG-E' UNION ALL 
        SELECT 3335, 'Butambala',221,0,NULL,1, 'UG-119', 'UG-C' UNION ALL 
        SELECT 3336, 'Butebo',221,0,NULL,1, 'UG-233', 'UG-E' UNION ALL 
        SELECT 3337, 'Buvuma',221,0,NULL,1, 'UG-120', 'UG-C' UNION ALL 
        SELECT 3338, 'Buyende',221,0,NULL,1, 'UG-226', 'UG-E' UNION ALL 
        SELECT 3339, 'Central',221,0,NULL,1, 'UG-C', NULL UNION ALL 
        SELECT 3340, 'Dokolo',221,0,NULL,1, 'UG-317', 'UG-N' UNION ALL 
        SELECT 3341, 'Eastern',221,0,NULL,1, 'UG-E', NULL UNION ALL 
        SELECT 3342, 'Gomba',221,0,NULL,1, 'UG-121', 'UG-C' UNION ALL 
        SELECT 3343, 'Gulu',221,0,NULL,1, 'UG-304', 'UG-N' UNION ALL 
        SELECT 3344, 'Hoima',221,0,NULL,1, 'UG-403', 'UG-W' UNION ALL 
        SELECT 3345, 'Ibanda',221,0,NULL,1, 'UG-417', 'UG-W' UNION ALL 
        SELECT 3346, 'Iganga',221,0,NULL,1, 'UG-203', 'UG-E' UNION ALL 
        SELECT 3347, 'Isingiro',221,0,NULL,1, 'UG-418', 'UG-W' UNION ALL 
        SELECT 3348, 'Jinja',221,0,NULL,1, 'UG-204', 'UG-E' UNION ALL 
        SELECT 3349, 'Kaabong',221,0,NULL,1, 'UG-318', 'UG-N' UNION ALL 
        SELECT 3350, 'Kabale',221,0,NULL,1, 'UG-404', 'UG-W' UNION ALL 
        SELECT 3351, 'Kabarole',221,0,NULL,1, 'UG-405', 'UG-W' UNION ALL 
        SELECT 3352, 'Kaberamaido',221,0,NULL,1, 'UG-213', 'UG-E' UNION ALL 
        SELECT 3353, 'Kagadi',221,0,NULL,1, 'UG-427', 'UG-W' UNION ALL 
        SELECT 3354, 'Kakumiro',221,0,NULL,1, 'UG-428', 'UG-W' UNION ALL 
        SELECT 3355, 'Kalangala',221,0,NULL,1, 'UG-101', 'UG-C' UNION ALL 
        SELECT 3356, 'Kaliro',221,0,NULL,1, 'UG-222', 'UG-E' UNION ALL 
        SELECT 3357, 'Kalungu',221,0,NULL,1, 'UG-122', 'UG-C' UNION ALL 
        SELECT 3358, 'Kampala',221,0,NULL,1, 'UG-102', 'UG-C' UNION ALL 
        SELECT 3359, 'Kamuli',221,0,NULL,1, 'UG-205', 'UG-E' UNION ALL 
        SELECT 3360, 'Kamwenge',221,0,NULL,1, 'UG-413', 'UG-W' UNION ALL 
        SELECT 3361, 'Kanungu',221,0,NULL,1, 'UG-414', 'UG-W' UNION ALL 
        SELECT 3362, 'Kapchorwa',221,0,NULL,1, 'UG-206', 'UG-E' UNION ALL 
        SELECT 3363, 'Kapelebyong',221,0,NULL,1, 'UG-236', 'UG-E' UNION ALL 
        SELECT 3364, 'Kasanda',221,0,NULL,1, 'UG-126', 'UG-C' UNION ALL 
        SELECT 3365, 'Kasese',221,0,NULL,1, 'UG-406', 'UG-W' UNION ALL 
        SELECT 3366, 'Katakwi',221,0,NULL,1, 'UG-207', 'UG-E' UNION ALL 
        SELECT 3367, 'Kayunga',221,0,NULL,1, 'UG-112', 'UG-C' UNION ALL 
        SELECT 3368, 'Kibaale',221,0,NULL,1, 'UG-407', 'UG-W' UNION ALL 
        SELECT 3369, 'Kiboga',221,0,NULL,1, 'UG-103', 'UG-C' UNION ALL 
        SELECT 3370, 'Kibuku',221,0,NULL,1, 'UG-227', 'UG-E' UNION ALL 
        SELECT 3371, 'Kikuube',221,0,NULL,1, 'UG-432', 'UG-W' UNION ALL 
        SELECT 3372, 'Kiruhura',221,0,NULL,1, 'UG-419', 'UG-W' UNION ALL 
        SELECT 3373, 'Kiryandongo',221,0,NULL,1, 'UG-421', 'UG-W' UNION ALL 
        SELECT 3374, 'Kisoro',221,0,NULL,1, 'UG-408', 'UG-W' UNION ALL 
        SELECT 3375, 'Kitgum',221,0,NULL,1, 'UG-305', 'UG-N' UNION ALL 
        SELECT 3376, 'Koboko',221,0,NULL,1, 'UG-319', 'UG-N' UNION ALL 
        SELECT 3377, 'Kole',221,0,NULL,1, 'UG-325', 'UG-N' UNION ALL 
        SELECT 3378, 'Kotido',221,0,NULL,1, 'UG-306', 'UG-N' UNION ALL 
        SELECT 3379, 'Kumi',221,0,NULL,1, 'UG-208', 'UG-E' UNION ALL 
        SELECT 3380, 'Kwania',221,0,NULL,1, 'UG-333', 'UG-N' UNION ALL 
        SELECT 3381, 'Kween',221,0,NULL,1, 'UG-228', 'UG-E' UNION ALL 
        SELECT 3382, 'Kyankwanzi',221,0,NULL,1, 'UG-123', 'UG-C' UNION ALL 
        SELECT 3383, 'Kyegegwa',221,0,NULL,1, 'UG-422', 'UG-W' UNION ALL 
        SELECT 3384, 'Kyenjojo',221,0,NULL,1, 'UG-415', 'UG-W' UNION ALL 
        SELECT 3385, 'Kyotera',221,0,NULL,1, 'UG-125', 'UG-C' UNION ALL 
        SELECT 3386, 'Lamwo',221,0,NULL,1, 'UG-326', 'UG-N' UNION ALL 
        SELECT 3387, 'Lira',221,0,NULL,1, 'UG-307', 'UG-N' UNION ALL 
        SELECT 3388, 'Luuka',221,0,NULL,1, 'UG-229', 'UG-E' UNION ALL 
        SELECT 3389, 'Luwero',221,0,NULL,1, 'UG-104', 'UG-C' UNION ALL 
        SELECT 3390, 'Lwengo',221,0,NULL,1, 'UG-124', 'UG-C' UNION ALL 
        SELECT 3391, 'Lyantonde',221,0,NULL,1, 'UG-114', 'UG-C' UNION ALL 
        SELECT 3392, 'Manafwa',221,0,NULL,1, 'UG-223', 'UG-E' UNION ALL 
        SELECT 3393, 'Maracha',221,0,NULL,1, 'UG-320', 'UG-N' UNION ALL 
        SELECT 3394, 'Masaka',221,0,NULL,1, 'UG-105', 'UG-C' UNION ALL 
        SELECT 3395, 'Masindi',221,0,NULL,1, 'UG-409', 'UG-W' UNION ALL 
        SELECT 3396, 'Mayuge',221,0,NULL,1, 'UG-214', 'UG-E' UNION ALL 
        SELECT 3397, 'Mbale',221,0,NULL,1, 'UG-209', 'UG-E' UNION ALL 
        SELECT 3398, 'Mbarara',221,0,NULL,1, 'UG-410', 'UG-W' UNION ALL 
        SELECT 3399, 'Mitooma',221,0,NULL,1, 'UG-423', 'UG-W' UNION ALL 
        SELECT 3400, 'Mityana',221,0,NULL,1, 'UG-115', 'UG-C' UNION ALL 
        SELECT 3401, 'Moroto',221,0,NULL,1, 'UG-308', 'UG-N' UNION ALL 
        SELECT 3402, 'Moyo',221,0,NULL,1, 'UG-309', 'UG-N' UNION ALL 
        SELECT 3403, 'Mpigi',221,0,NULL,1, 'UG-106', 'UG-C' UNION ALL 
        SELECT 3404, 'Mubende',221,0,NULL,1, 'UG-107', 'UG-C' UNION ALL 
        SELECT 3405, 'Mukono',221,0,NULL,1, 'UG-108', 'UG-C' UNION ALL 
        SELECT 3406, 'Nabilatuk',221,0,NULL,1, 'UG-334', 'UG-N' UNION ALL 
        SELECT 3407, 'Nakapiripirit',221,0,NULL,1, 'UG-311', 'UG-N' UNION ALL 
        SELECT 3408, 'Nakaseke',221,0,NULL,1, 'UG-116', 'UG-C' UNION ALL 
        SELECT 3409, 'Nakasongola',221,0,NULL,1, 'UG-109', 'UG-C' UNION ALL 
        SELECT 3410, 'Namayingo',221,0,NULL,1, 'UG-230', 'UG-E' UNION ALL 
        SELECT 3411, 'Namisindwa',221,0,NULL,1, 'UG-234', 'UG-E' UNION ALL 
        SELECT 3412, 'Namutumba',221,0,NULL,1, 'UG-224', 'UG-E' UNION ALL 
        SELECT 3413, 'Napak',221,0,NULL,1, 'UG-327', 'UG-N' UNION ALL 
        SELECT 3414, 'Nebbi',221,0,NULL,1, 'UG-310', 'UG-N' UNION ALL 
        SELECT 3415, 'Ngora',221,0,NULL,1, 'UG-231', 'UG-E' UNION ALL 
        SELECT 3416, 'Northern',221,0,NULL,1, 'UG-N', NULL UNION ALL 
        SELECT 3417, 'Ntoroko',221,0,NULL,1, 'UG-424', 'UG-W' UNION ALL 
        SELECT 3418, 'Ntungamo',221,0,NULL,1, 'UG-411', 'UG-W' UNION ALL 
        SELECT 3419, 'Nwoya',221,0,NULL,1, 'UG-328', 'UG-N' UNION ALL 
        SELECT 3420, 'Omoro',221,0,NULL,1, 'UG-331', 'UG-N' UNION ALL 
        SELECT 3421, 'Otuke',221,0,NULL,1, 'UG-329', 'UG-N' UNION ALL 
        SELECT 3422, 'Oyam',221,0,NULL,1, 'UG-321', 'UG-N' UNION ALL 
        SELECT 3423, 'Pader',221,0,NULL,1, 'UG-312', 'UG-N' UNION ALL 
        SELECT 3424, 'Pakwach',221,0,NULL,1, 'UG-332', 'UG-N' UNION ALL 
        SELECT 3425, 'Pallisa',221,0,NULL,1, 'UG-210', 'UG-E' UNION ALL 
        SELECT 3426, 'Rakai',221,0,NULL,1, 'UG-110', 'UG-C' UNION ALL 
        SELECT 3427, 'Rubanda',221,0,NULL,1, 'UG-429', 'UG-W' UNION ALL 
        SELECT 3428, 'Rubirizi',221,0,NULL,1, 'UG-425', 'UG-W' UNION ALL 
        SELECT 3429, 'Rukiga',221,0,NULL,1, 'UG-431', 'UG-W' UNION ALL 
        SELECT 3430, 'Rukungiri',221,0,NULL,1, 'UG-412', 'UG-W' UNION ALL 
        SELECT 3431, 'Sembabule',221,0,NULL,1, 'UG-111', 'UG-C' UNION ALL 
        SELECT 3432, 'Serere',221,0,NULL,1, 'UG-232', 'UG-E' UNION ALL 
        SELECT 3433, 'Sheema',221,0,NULL,1, 'UG-426', 'UG-W' UNION ALL 
        SELECT 3434, 'Sironko',221,0,NULL,1, 'UG-215', 'UG-E' UNION ALL 
        SELECT 3435, 'Soroti',221,0,NULL,1, 'UG-211', 'UG-E' UNION ALL 
        SELECT 3436, 'Tororo',221,0,NULL,1, 'UG-212', 'UG-E' UNION ALL 
        SELECT 3437, 'Wakiso',221,0,NULL,1, 'UG-113', 'UG-C' UNION ALL 
        SELECT 3438, 'Western',221,0,NULL,1, 'UG-W', NULL UNION ALL 
        SELECT 3439, 'Yumbe',221,0,NULL,1, 'UG-313', 'UG-N' UNION ALL 
        SELECT 3440, 'Zombo',221,0,NULL,1, 'UG-330', 'UG-N' UNION ALL 
        SELECT 3441, 'Avtonomna Respublika Krym',222,0,NULL,1, 'UA-43', NULL UNION ALL 
        SELECT 3442, 'Cherkaska oblast',222,0,NULL,1, 'UA-71', NULL UNION ALL 
        SELECT 3443, 'Chernihivska oblast',222,0,NULL,1, 'UA-74', NULL UNION ALL 
        SELECT 3444, 'Chernivetska oblast',222,0,NULL,1, 'UA-77', NULL UNION ALL 
        SELECT 3445, 'Dnipropetrovska oblast',222,0,NULL,1, 'UA-12', NULL UNION ALL 
        SELECT 3446, 'Donetska oblast',222,0,NULL,1, 'UA-14', NULL UNION ALL 
        SELECT 3447, 'Ivano-Frankivska oblast',222,0,NULL,1, 'UA-26', NULL UNION ALL 
        SELECT 3448, 'Kharkivska oblast',222,0,NULL,1, 'UA-63', NULL UNION ALL 
        SELECT 3449, 'Khersonska oblast',222,0,NULL,1, 'UA-65', NULL UNION ALL 
        SELECT 3450, 'Khmelnytska oblast',222,0,NULL,1, 'UA-68', NULL UNION ALL 
        SELECT 3451, 'Kirovohradska oblast',222,0,NULL,1, 'UA-35', NULL UNION ALL 
        SELECT 3452, 'Kyiv',222,0,NULL,1, 'UA-30', NULL UNION ALL 
        SELECT 3453, 'Kyivska oblast',222,0,NULL,1, 'UA-32', NULL UNION ALL 
        SELECT 3454, 'Luhanska oblast',222,0,NULL,1, 'UA-09', NULL UNION ALL 
        SELECT 3455, 'Lvivska oblast',222,0,NULL,1, 'UA-46', NULL UNION ALL 
        SELECT 3456, 'Mykolaivska oblast',222,0,NULL,1, 'UA-48', NULL UNION ALL 
        SELECT 3457, 'Odeska oblast',222,0,NULL,1, 'UA-51', NULL UNION ALL 
        SELECT 3458, 'Poltavska oblast',222,0,NULL,1, 'UA-53', NULL UNION ALL 
        SELECT 3459, 'Rivnenska oblast',222,0,NULL,1, 'UA-56', NULL UNION ALL 
        SELECT 3460, 'Sevastopol',222,0,NULL,1, 'UA-40', NULL UNION ALL 
        SELECT 3461, 'Sumska oblast',222,0,NULL,1, 'UA-59', NULL UNION ALL 
        SELECT 3462, 'Ternopilska oblast',222,0,NULL,1, 'UA-61', NULL UNION ALL 
        SELECT 3463, 'Vinnytska oblast',222,0,NULL,1, 'UA-05', NULL UNION ALL 
        SELECT 3464, 'Volynska oblast',222,0,NULL,1, 'UA-07', NULL UNION ALL 
        SELECT 3465, 'Zakarpatska oblast',222,0,NULL,1, 'UA-21', NULL UNION ALL 
        SELECT 3466, 'Zaporizka oblast',222,0,NULL,1, 'UA-23', NULL UNION ALL 
        SELECT 3467, 'Zhytomyrska oblast',222,0,NULL,1, 'UA-18', NULL UNION ALL 
        SELECT 3468, 'Abu Z¸aby',223,0,NULL,1, 'AE-AZ', NULL UNION ALL 
        SELECT 3469, 'Al Fujayrah',223,0,NULL,1, 'AE-FU', NULL UNION ALL 
        SELECT 3470, 'Ash Shariqah',223,0,NULL,1, 'AE-SH', NULL UNION ALL 
        SELECT 3471, 'Dubayy',223,0,NULL,1, 'AE-DU', NULL UNION ALL 
        SELECT 3472, 'Ra’s al Khaymah',223,0,NULL,1, 'AE-RK', NULL UNION ALL 
        SELECT 3473, 'Umm al Qaywayn',223,0,NULL,1, 'AE-UQ', NULL UNION ALL 
        SELECT 3474, '‘Ajman',223,0,NULL,1, 'AE-AJ', NULL UNION ALL 
        SELECT 3475, 'Baker Island',224,0,NULL,1, 'UM-81', NULL UNION ALL 
        SELECT 3476, 'Howland Island',224,0,NULL,1, 'UM-84', NULL UNION ALL 
        SELECT 3477, 'Jarvis Island',224,0,NULL,1, 'UM-86', NULL UNION ALL 
        SELECT 3478, 'Johnston Atoll',224,0,NULL,1, 'UM-67', NULL UNION ALL 
        SELECT 3479, 'Kingman Reef',224,0,NULL,1, 'UM-89', NULL UNION ALL 
        SELECT 3480, 'Midway Islands',224,0,NULL,1, 'UM-71', NULL UNION ALL 
        SELECT 3481, 'Navassa Island',224,0,NULL,1, 'UM-76', NULL UNION ALL 
        SELECT 3482, 'Palmyra Atoll',224,0,NULL,1, 'UM-95', NULL UNION ALL 
        SELECT 3483, 'Wake Island',224,0,NULL,1, 'UM-79', NULL UNION ALL 
        SELECT 3484, 'Artigas',225,0,NULL,1, 'UY-AR', NULL UNION ALL 
        SELECT 3485, 'Canelones',225,0,NULL,1, 'UY-CA', NULL UNION ALL 
        SELECT 3486, 'Cerro Largo',225,0,NULL,1, 'UY-CL', NULL UNION ALL 
        SELECT 3487, 'Colonia',225,0,NULL,1, 'UY-CO', NULL UNION ALL 
        SELECT 3488, 'Durazno',225,0,NULL,1, 'UY-DU', NULL UNION ALL 
        SELECT 3489, 'Flores',225,0,NULL,1, 'UY-FS', NULL UNION ALL 
        SELECT 3490, 'Florida',225,0,NULL,1, 'UY-FD', NULL UNION ALL 
        SELECT 3491, 'Lavalleja',225,0,NULL,1, 'UY-LA', NULL UNION ALL 
        SELECT 3492, 'Maldonado',225,0,NULL,1, 'UY-MA', NULL UNION ALL 
        SELECT 3493, 'Montevideo',225,0,NULL,1, 'UY-MO', NULL UNION ALL 
        SELECT 3494, 'Paysandú',225,0,NULL,1, 'UY-PA', NULL UNION ALL 
        SELECT 3495, 'Rivera',225,0,NULL,1, 'UY-RV', NULL UNION ALL 
        SELECT 3496, 'Rocha',225,0,NULL,1, 'UY-RO', NULL UNION ALL 
        SELECT 3497, 'Río Negro',225,0,NULL,1, 'UY-RN', NULL UNION ALL 
        SELECT 3498, 'Salto',225,0,NULL,1, 'UY-SA', NULL UNION ALL 
        SELECT 3499, 'San José',225,0,NULL,1, 'UY-SJ', NULL UNION ALL 
        SELECT 3500, 'Soriano',225,0,NULL,1, 'UY-SO', NULL UNION ALL 
        SELECT 3501, 'Tacuarembó',225,0,NULL,1, 'UY-TA', NULL UNION ALL 
        SELECT 3502, 'Treinta y Tres',225,0,NULL,1, 'UY-TT', NULL UNION ALL 
        SELECT 3503, 'Andijon',226,0,NULL,1, 'UZ-AN', NULL UNION ALL 
        SELECT 3504, 'Buxoro',226,0,NULL,1, 'UZ-BU', NULL UNION ALL 
        SELECT 3505, 'Farg‘ona',226,0,NULL,1, 'UZ-FA', NULL UNION ALL 
        SELECT 3506, 'Jizzax',226,0,NULL,1, 'UZ-JI', NULL UNION ALL 
        SELECT 3507, 'Namangan',226,0,NULL,1, 'UZ-NG', NULL UNION ALL 
        SELECT 3508, 'Navoiy',226,0,NULL,1, 'UZ-NW', NULL UNION ALL 
        SELECT 3509, 'Qashqadaryo',226,0,NULL,1, 'UZ-QA', NULL UNION ALL 
        SELECT 3510, 'Qoraqalpog‘iston Respublikasi',226,0,NULL,1, 'UZ-QR', NULL UNION ALL 
        SELECT 3511, 'Samarqand',226,0,NULL,1, 'UZ-SA', NULL UNION ALL 
        SELECT 3512, 'Sirdaryo',226,0,NULL,1, 'UZ-SI', NULL UNION ALL 
        SELECT 3513, 'Surxondaryo',226,0,NULL,1, 'UZ-SU', NULL UNION ALL 
        SELECT 3514, 'Toshkent',226,0,NULL,1, 'UZ-TO', NULL UNION ALL 
        SELECT 3515, 'Toshkent',226,0,NULL,1, 'UZ-TK', NULL UNION ALL 
        SELECT 3516, 'Xorazm',226,0,NULL,1, 'UZ-XO', NULL UNION ALL 
        SELECT 3517, 'Amazonas',229,0,NULL,1, 'VE-Z', NULL UNION ALL 
        SELECT 3518, 'Anzoátegui',229,0,NULL,1, 'VE-B', NULL UNION ALL 
        SELECT 3519, 'Apure',229,0,NULL,1, 'VE-C', NULL UNION ALL 
        SELECT 3520, 'Aragua',229,0,NULL,1, 'VE-D', NULL UNION ALL 
        SELECT 3521, 'Barinas',229,0,NULL,1, 'VE-E', NULL UNION ALL 
        SELECT 3522, 'Bolívar',229,0,NULL,1, 'VE-F', NULL UNION ALL 
        SELECT 3523, 'Carabobo',229,0,NULL,1, 'VE-G', NULL UNION ALL 
        SELECT 3524, 'Cojedes',229,0,NULL,1, 'VE-H', NULL UNION ALL 
        SELECT 3525, 'Delta Amacuro',229,0,NULL,1, 'VE-Y', NULL UNION ALL 
        SELECT 3526, 'Dependencias Federales',229,0,NULL,1, 'VE-W', NULL UNION ALL 
        SELECT 3527, 'Distrito Capital',229,0,NULL,1, 'VE-A', NULL UNION ALL 
        SELECT 3528, 'Falcón',229,0,NULL,1, 'VE-I', NULL UNION ALL 
        SELECT 3529, 'Guárico',229,0,NULL,1, 'VE-J', NULL UNION ALL 
        SELECT 3530, 'Lara',229,0,NULL,1, 'VE-K', NULL UNION ALL 
        SELECT 3531, 'Miranda',229,0,NULL,1, 'VE-M', NULL UNION ALL 
        SELECT 3532, 'Monagas',229,0,NULL,1, 'VE-N', NULL UNION ALL 
        SELECT 3533, 'Mérida',229,0,NULL,1, 'VE-L', NULL UNION ALL 
        SELECT 3534, 'Nueva Esparta',229,0,NULL,1, 'VE-O', NULL UNION ALL 
        SELECT 3535, 'Portuguesa',229,0,NULL,1, 'VE-P', NULL UNION ALL 
        SELECT 3536, 'Sucre',229,0,NULL,1, 'VE-R', NULL UNION ALL 
        SELECT 3537, 'Trujillo',229,0,NULL,1, 'VE-T', NULL UNION ALL 
        SELECT 3538, 'Táchira',229,0,NULL,1, 'VE-S', NULL UNION ALL 
        SELECT 3539, 'Vargas',229,0,NULL,1, 'VE-X', NULL UNION ALL 
        SELECT 3540, 'Yaracuy',229,0,NULL,1, 'VE-U', NULL UNION ALL 
        SELECT 3541, 'Zulia',229,0,NULL,1, 'VE-V', NULL UNION ALL 
        SELECT 3542, 'An Giang',230,0,NULL,1, 'VN-44', NULL UNION ALL 
        SELECT 3543, 'Bà R?a - Vung Tàu',230,0,NULL,1, 'VN-43', NULL UNION ALL 
        SELECT 3544, 'Bình Duong',230,0,NULL,1, 'VN-57', NULL UNION ALL 
        SELECT 3545, 'Bình Phu?c',230,0,NULL,1, 'VN-58', NULL UNION ALL 
        SELECT 3546, 'Bình Thu?n',230,0,NULL,1, 'VN-40', NULL UNION ALL 
        SELECT 3547, 'Bình Ð?nh',230,0,NULL,1, 'VN-31', NULL UNION ALL 
        SELECT 3548, 'B?c Liêu',230,0,NULL,1, 'VN-55', NULL UNION ALL 
        SELECT 3549, 'B?c Giang',230,0,NULL,1, 'VN-54', NULL UNION ALL 
        SELECT 3550, 'B?c K?n',230,0,NULL,1, 'VN-53', NULL UNION ALL 
        SELECT 3551, 'B?c Ninh',230,0,NULL,1, 'VN-56', NULL UNION ALL 
        SELECT 3552, 'B?n Tre',230,0,NULL,1, 'VN-50', NULL UNION ALL 
        SELECT 3553, 'Can Tho',230,0,NULL,1, 'VN-CT', NULL UNION ALL 
        SELECT 3554, 'Cao B?ng',230,0,NULL,1, 'VN-04', NULL UNION ALL 
        SELECT 3555, 'Cà Mau',230,0,NULL,1, 'VN-59', NULL UNION ALL 
        SELECT 3556, 'Da Nang',230,0,NULL,1, 'VN-DN', NULL UNION ALL 
        SELECT 3557, 'Gia Lai',230,0,NULL,1, 'VN-30', NULL UNION ALL 
        SELECT 3558, 'Ha Noi',230,0,NULL,1, 'VN-HN', NULL UNION ALL 
        SELECT 3559, 'Hai Phong',230,0,NULL,1, 'VN-HP', NULL UNION ALL 
        SELECT 3560, 'Ho Chi Minh',230,0,NULL,1, 'VN-SG', NULL UNION ALL 
        SELECT 3561, 'Hà Giang',230,0,NULL,1, 'VN-03', NULL UNION ALL 
        SELECT 3562, 'Hà Nam',230,0,NULL,1, 'VN-63', NULL UNION ALL 
        SELECT 3563, 'Hà Tinh',230,0,NULL,1, 'VN-23', NULL UNION ALL 
        SELECT 3564, 'Hòa Bình',230,0,NULL,1, 'VN-14', NULL UNION ALL 
        SELECT 3565, 'Hung Yên',230,0,NULL,1, 'VN-66', NULL UNION ALL 
        SELECT 3566, 'H?i Duong',230,0,NULL,1, 'VN-61', NULL UNION ALL 
        SELECT 3567, 'H?u Giang',230,0,NULL,1, 'VN-73', NULL UNION ALL 
        SELECT 3568, 'Khánh Hòa',230,0,NULL,1, 'VN-34', NULL UNION ALL 
        SELECT 3569, 'Ki?n Giang',230,0,NULL,1, 'VN-47', NULL UNION ALL 
        SELECT 3570, 'Kon Tum',230,0,NULL,1, 'VN-28', NULL UNION ALL 
        SELECT 3571, 'Lai Châu',230,0,NULL,1, 'VN-01', NULL UNION ALL 
        SELECT 3572, 'Long An',230,0,NULL,1, 'VN-41', NULL UNION ALL 
        SELECT 3573, 'Lào Cai',230,0,NULL,1, 'VN-02', NULL UNION ALL 
        SELECT 3574, 'Lâm Ð?ng',230,0,NULL,1, 'VN-35', NULL UNION ALL 
        SELECT 3575, 'L?ng Son',230,0,NULL,1, 'VN-09', NULL UNION ALL 
        SELECT 3576, 'Nam Ð?nh',230,0,NULL,1, 'VN-67', NULL UNION ALL 
        SELECT 3577, 'Ngh? An',230,0,NULL,1, 'VN-22', NULL UNION ALL 
        SELECT 3578, 'Ninh Bình',230,0,NULL,1, 'VN-18', NULL UNION ALL 
        SELECT 3579, 'Ninh Thu?n',230,0,NULL,1, 'VN-36', NULL UNION ALL 
        SELECT 3580, 'Phú Th?',230,0,NULL,1, 'VN-68', NULL UNION ALL 
        SELECT 3581, 'Phú Yên',230,0,NULL,1, 'VN-32', NULL UNION ALL 
        SELECT 3582, 'Qu?ng Bình',230,0,NULL,1, 'VN-24', NULL UNION ALL 
        SELECT 3583, 'Qu?ng Nam',230,0,NULL,1, 'VN-27', NULL UNION ALL 
        SELECT 3584, 'Qu?ng Ngãi',230,0,NULL,1, 'VN-29', NULL UNION ALL 
        SELECT 3585, 'Qu?ng Ninh',230,0,NULL,1, 'VN-13', NULL UNION ALL 
        SELECT 3586, 'Qu?ng Tr?',230,0,NULL,1, 'VN-25', NULL UNION ALL 
        SELECT 3587, 'Sóc Trang',230,0,NULL,1, 'VN-52', NULL UNION ALL 
        SELECT 3588, 'Son La',230,0,NULL,1, 'VN-05', NULL UNION ALL 
        SELECT 3589, 'Thanh Hóa',230,0,NULL,1, 'VN-21', NULL UNION ALL 
        SELECT 3590, 'Thái Bình',230,0,NULL,1, 'VN-20', NULL UNION ALL 
        SELECT 3591, 'Thái Nguyên',230,0,NULL,1, 'VN-69', NULL UNION ALL 
        SELECT 3592, 'Th?a Thiên-Hu?',230,0,NULL,1, 'VN-26', NULL UNION ALL 
        SELECT 3593, 'Ti?n Giang',230,0,NULL,1, 'VN-46', NULL UNION ALL 
        SELECT 3594, 'Trà Vinh',230,0,NULL,1, 'VN-51', NULL UNION ALL 
        SELECT 3595, 'Tuyên Quang',230,0,NULL,1, 'VN-07', NULL UNION ALL 
        SELECT 3596, 'Tây Ninh',230,0,NULL,1, 'VN-37', NULL UNION ALL 
        SELECT 3597, 'Vinh Long',230,0,NULL,1, 'VN-49', NULL UNION ALL 
        SELECT 3598, 'Vinh Phúc',230,0,NULL,1, 'VN-70', NULL UNION ALL 
        SELECT 3599, 'Yên Bái',230,0,NULL,1, 'VN-06', NULL UNION ALL 
        SELECT 3600, 'Ði?n Biên',230,0,NULL,1, 'VN-71', NULL UNION ALL 
        SELECT 3601, 'Ð?k L?k',230,0,NULL,1, 'VN-33', NULL UNION ALL 
        SELECT 3602, 'Ð?k Nông',230,0,NULL,1, 'VN-72', NULL UNION ALL 
        SELECT 3603, 'Ð?ng Nai',230,0,NULL,1, 'VN-39', NULL UNION ALL 
        SELECT 3604, 'Ð?ng Tháp',230,0,NULL,1, 'VN-45', NULL UNION ALL 
        SELECT 3605, 'Alo',233,0,NULL,1, 'WF-AL', NULL UNION ALL 
        SELECT 3606, 'Sigave',233,0,NULL,1, 'WF-SG', NULL UNION ALL 
        SELECT 3607, 'Uvea',233,0,NULL,1, 'WF-UV', NULL UNION ALL 
        SELECT 3608, 'Abyan',235,0,NULL,1, 'YE-AB', NULL UNION ALL 
        SELECT 3609, 'Al Bay?a’',235,0,NULL,1, 'YE-BA', NULL UNION ALL 
        SELECT 3610, 'Al Jawf',235,0,NULL,1, 'YE-JA', NULL UNION ALL 
        SELECT 3611, 'Al Mahrah',235,0,NULL,1, 'YE-MR', NULL UNION ALL 
        SELECT 3612, 'Al Ma?wit',235,0,NULL,1, 'YE-MW', NULL UNION ALL 
        SELECT 3613, 'Al ?udaydah',235,0,NULL,1, 'YE-HU', NULL UNION ALL 
        SELECT 3614, 'Amanat al ‘Asimah [city]',235,0,NULL,1, 'YE-SA', NULL UNION ALL 
        SELECT 3615, 'Arkhabil Suqutrá',235,0,NULL,1, 'YE-SU', NULL UNION ALL 
        SELECT 3616, 'A? ?ali‘',235,0,NULL,1, 'YE-DA', NULL UNION ALL 
        SELECT 3617, 'Dhamar',235,0,NULL,1, 'YE-DH', NULL UNION ALL 
        SELECT 3618, 'Ibb',235,0,NULL,1, 'YE-IB', NULL UNION ALL 
        SELECT 3619, 'La?ij',235,0,NULL,1, 'YE-LA', NULL UNION ALL 
        SELECT 3620, 'Ma’rib',235,0,NULL,1, 'YE-MA', NULL UNION ALL 
        SELECT 3621, 'Raymah',235,0,NULL,1, 'YE-RA', NULL UNION ALL 
        SELECT 3622, 'Shabwah',235,0,NULL,1, 'YE-SH', NULL UNION ALL 
        SELECT 3623, 'Ta?izz',235,0,NULL,1, 'YE-TA', NULL UNION ALL 
        SELECT 3624, 'San?a’',235,0,NULL,1, 'YE-SN', NULL UNION ALL 
        SELECT 3625, 'Sa?dah',235,0,NULL,1, 'YE-SD', NULL UNION ALL 
        SELECT 3626, '?ajjah',235,0,NULL,1, 'YE-HJ', NULL UNION ALL 
        SELECT 3627, '?a?ramawt',235,0,NULL,1, 'YE-HD', NULL UNION ALL 
        SELECT 3628, '‘Adan',235,0,NULL,1, 'YE-AD', NULL UNION ALL 
        SELECT 3629, '‘Amran',235,0,NULL,1, 'YE-AM', NULL UNION ALL 
        SELECT 3630, 'Central',238,0,NULL,1, 'ZM-02', NULL UNION ALL 
        SELECT 3631, 'Copperbelt',238,0,NULL,1, 'ZM-08', NULL UNION ALL 
        SELECT 3632, 'Eastern',238,0,NULL,1, 'ZM-03', NULL UNION ALL 
        SELECT 3633, 'Luapula',238,0,NULL,1, 'ZM-04', NULL UNION ALL 
        SELECT 3634, 'Lusaka',238,0,NULL,1, 'ZM-09', NULL UNION ALL 
        SELECT 3635, 'Muchinga',238,0,NULL,1, 'ZM-10', NULL UNION ALL 
        SELECT 3636, 'North-Western',238,0,NULL,1, 'ZM-06', NULL UNION ALL 
        SELECT 3637, 'Northern',238,0,NULL,1, 'ZM-05', NULL UNION ALL 
        SELECT 3638, 'Southern',238,0,NULL,1, 'ZM-07', NULL UNION ALL 
        SELECT 3639, 'Western',238,0,NULL,1, 'ZM-01', NULL UNION ALL 
        SELECT 3640, 'Bulawayo',239,0,NULL,1, 'ZW-BU', NULL UNION ALL 
        SELECT 3641, 'Harare',239,0,NULL,1, 'ZW-HA', NULL UNION ALL 
        SELECT 3642, 'Manicaland',239,0,NULL,1, 'ZW-MA', NULL UNION ALL 
        SELECT 3643, 'Mashonaland Central',239,0,NULL,1, 'ZW-MC', NULL UNION ALL 
        SELECT 3644, 'Mashonaland East',239,0,NULL,1, 'ZW-ME', NULL UNION ALL 
        SELECT 3645, 'Mashonaland West',239,0,NULL,1, 'ZW-MW', NULL UNION ALL 
        SELECT 3646, 'Masvingo',239,0,NULL,1, 'ZW-MV', NULL UNION ALL 
        SELECT 3647, 'Matabeleland North',239,0,NULL,1, 'ZW-MN', NULL UNION ALL 
        SELECT 3648, 'Matabeleland South',239,0,NULL,1, 'ZW-MS', NULL UNION ALL 
        SELECT 3649, 'Midlands',239,0,NULL,1, 'ZW-MI', NULL UNION ALL 
        SELECT 3650, 'Beograd',241,0,NULL,1, 'RS-00', NULL UNION ALL 
        SELECT 3651, 'Borski okrug',241,0,NULL,1, 'RS-14', NULL UNION ALL 
        SELECT 3652, 'Branicevski okrug',241,0,NULL,1, 'RS-11', NULL UNION ALL 
        SELECT 3653, 'Jablanicki okrug',241,0,NULL,1, 'RS-23', NULL UNION ALL 
        SELECT 3654, 'Južnobanatski okrug',241,0,NULL,1, 'RS-04', 'RS-VO' UNION ALL 
        SELECT 3655, 'Južnobacki okrug',241,0,NULL,1, 'RS-06', 'RS-VO' UNION ALL 
        SELECT 3656, 'Kolubarski okrug',241,0,NULL,1, 'RS-09', NULL UNION ALL 
        SELECT 3657, 'Kosovo-Metohija',241,0,NULL,1, 'RS-KM', NULL UNION ALL 
        SELECT 3658, 'Kosovski okrug',241,0,NULL,1, 'RS-25', 'RS-KM' UNION ALL 
        SELECT 3659, 'Kosovsko-Mitrovacki okrug',241,0,NULL,1, 'RS-28', 'RS-KM' UNION ALL 
        SELECT 3660, 'Kosovsko-Pomoravski okrug',241,0,NULL,1, 'RS-29', 'RS-KM' UNION ALL 
        SELECT 3661, 'Macvanski okrug',241,0,NULL,1, 'RS-08', NULL UNION ALL 
        SELECT 3662, 'Moravicki okrug',241,0,NULL,1, 'RS-17', NULL UNION ALL 
        SELECT 3663, 'Nišavski okrug',241,0,NULL,1, 'RS-20', NULL UNION ALL 
        SELECT 3664, 'Pecki okrug',241,0,NULL,1, 'RS-26', 'RS-KM' UNION ALL 
        SELECT 3665, 'Pirotski okrug',241,0,NULL,1, 'RS-22', NULL UNION ALL 
        SELECT 3666, 'Podunavski okrug',241,0,NULL,1, 'RS-10', NULL UNION ALL 
        SELECT 3667, 'Pomoravski okrug',241,0,NULL,1, 'RS-13', NULL UNION ALL 
        SELECT 3668, 'Prizrenski okrug',241,0,NULL,1, 'RS-27', 'RS-KM' UNION ALL 
        SELECT 3669, 'Pcinjski okrug',241,0,NULL,1, 'RS-24', NULL UNION ALL 
        SELECT 3670, 'Rasinski okrug',241,0,NULL,1, 'RS-19', NULL UNION ALL 
        SELECT 3671, 'Raški okrug',241,0,NULL,1, 'RS-18', NULL UNION ALL 
        SELECT 3672, 'Severnobanatski okrug',241,0,NULL,1, 'RS-03', 'RS-VO' UNION ALL 
        SELECT 3673, 'Severnobacki okrug',241,0,NULL,1, 'RS-01', 'RS-VO' UNION ALL 
        SELECT 3674, 'Srednjebanatski okrug',241,0,NULL,1, 'RS-02', 'RS-VO' UNION ALL 
        SELECT 3675, 'Sremski okrug',241,0,NULL,1, 'RS-07', 'RS-VO' UNION ALL 
        SELECT 3676, 'Toplicki okrug',241,0,NULL,1, 'RS-21', NULL UNION ALL 
        SELECT 3677, 'Vojvodina',241,0,NULL,1, 'RS-VO', NULL UNION ALL 
        SELECT 3678, 'Zajecarski okrug',241,0,NULL,1, 'RS-15', NULL UNION ALL 
        SELECT 3679, 'Zapadnobacki okrug',241,0,NULL,1, 'RS-05', 'RS-VO' UNION ALL 
        SELECT 3680, 'Zlatiborski okrug',241,0,NULL,1, 'RS-16', NULL UNION ALL 
        SELECT 3681, 'Šumadijski okrug',241,0,NULL,1, 'RS-12', NULL UNION ALL 
        SELECT 3682, 'Andrijevica',244,0,NULL,1, 'ME-01', NULL UNION ALL 
        SELECT 3683, 'Bar',244,0,NULL,1, 'ME-02', NULL UNION ALL 
        SELECT 3684, 'Berane',244,0,NULL,1, 'ME-03', NULL UNION ALL 
        SELECT 3685, 'Bijelo Polje',244,0,NULL,1, 'ME-04', NULL UNION ALL 
        SELECT 3686, 'Budva',244,0,NULL,1, 'ME-05', NULL UNION ALL 
        SELECT 3687, 'Cetinje',244,0,NULL,1, 'ME-06', NULL UNION ALL 
        SELECT 3688, 'Danilovgrad',244,0,NULL,1, 'ME-07', NULL UNION ALL 
        SELECT 3689, 'Gusinje',244,0,NULL,1, 'ME-22', NULL UNION ALL 
        SELECT 3690, 'Herceg-Novi',244,0,NULL,1, 'ME-08', NULL UNION ALL 
        SELECT 3691, 'Kolašin',244,0,NULL,1, 'ME-09', NULL UNION ALL 
        SELECT 3692, 'Kotor',244,0,NULL,1, 'ME-10', NULL UNION ALL 
        SELECT 3693, 'Mojkovac',244,0,NULL,1, 'ME-11', NULL UNION ALL 
        SELECT 3694, 'Nikšic',244,0,NULL,1, 'ME-12', NULL UNION ALL 
        SELECT 3695, 'Petnjica',244,0,NULL,1, 'ME-23', NULL UNION ALL 
        SELECT 3696, 'Plav',244,0,NULL,1, 'ME-13', NULL UNION ALL 
        SELECT 3697, 'Pljevlja',244,0,NULL,1, 'ME-14', NULL UNION ALL 
        SELECT 3698, 'Plužine',244,0,NULL,1, 'ME-15', NULL UNION ALL 
        SELECT 3699, 'Podgorica',244,0,NULL,1, 'ME-16', NULL UNION ALL 
        SELECT 3700, 'Rožaje',244,0,NULL,1, 'ME-17', NULL UNION ALL 
        SELECT 3701, 'Tivat',244,0,NULL,1, 'ME-19', NULL UNION ALL 
        SELECT 3702, 'Tuzi',244,0,NULL,1, 'ME-24', NULL UNION ALL 
        SELECT 3703, 'Ulcinj',244,0,NULL,1, 'ME-20', NULL UNION ALL 
        SELECT 3704, 'Šavnik',244,0,NULL,1, 'ME-18', NULL UNION ALL 
        SELECT 3705, 'Žabljak',244,0,NULL,1, 'ME-21', NULL UNION ALL 
        SELECT 3706, 'Bas-Uélé',250,0,NULL,1, 'CD-BU', NULL UNION ALL 
        SELECT 3707, 'Haut-Katanga',250,0,NULL,1, 'CD-HK', NULL UNION ALL 
        SELECT 3708, 'Haut-Lomami',250,0,NULL,1, 'CD-HL', NULL UNION ALL 
        SELECT 3709, 'Haut-Uélé',250,0,NULL,1, 'CD-HU', NULL UNION ALL 
        SELECT 3710, 'Ituri',250,0,NULL,1, 'CD-IT', NULL UNION ALL 
        SELECT 3711, 'Kasaï',250,0,NULL,1, 'CD-KS', NULL UNION ALL 
        SELECT 3712, 'Kasaï Central',250,0,NULL,1, 'CD-KC', NULL UNION ALL 
        SELECT 3713, 'Kasaï Oriental',250,0,NULL,1, 'CD-KE', NULL UNION ALL 
        SELECT 3714, 'Kinshasa',250,0,NULL,1, 'CD-KN', NULL UNION ALL 
        SELECT 3715, 'Kongo Central',250,0,NULL,1, 'CD-BC', NULL UNION ALL 
        SELECT 3716, 'Kwango',250,0,NULL,1, 'CD-KG', NULL UNION ALL 
        SELECT 3717, 'Kwilu',250,0,NULL,1, 'CD-KL', NULL UNION ALL 
        SELECT 3718, 'Lomami',250,0,NULL,1, 'CD-LO', NULL UNION ALL 
        SELECT 3719, 'Lualaba',250,0,NULL,1, 'CD-LU', NULL UNION ALL 
        SELECT 3720, 'Mai-Ndombe',250,0,NULL,1, 'CD-MN', NULL UNION ALL 
        SELECT 3721, 'Maniema',250,0,NULL,1, 'CD-MA', NULL UNION ALL 
        SELECT 3722, 'Mongala',250,0,NULL,1, 'CD-MO', NULL UNION ALL 
        SELECT 3723, 'Nord-Kivu',250,0,NULL,1, 'CD-NK', NULL UNION ALL 
        SELECT 3724, 'Nord-Ubangi',250,0,NULL,1, 'CD-NU', NULL UNION ALL 
        SELECT 3725, 'Sankuru',250,0,NULL,1, 'CD-SA', NULL UNION ALL 
        SELECT 3726, 'Sud-Kivu',250,0,NULL,1, 'CD-SK', NULL UNION ALL 
        SELECT 3727, 'Sud-Ubangi',250,0,NULL,1, 'CD-SU', NULL UNION ALL 
        SELECT 3728, 'Tanganyika',250,0,NULL,1, 'CD-TA', NULL UNION ALL 
        SELECT 3729, 'Tshopo',250,0,NULL,1, 'CD-TO', NULL UNION ALL 
        SELECT 3730, 'Tshuapa',250,0,NULL,1, 'CD-TU', NULL UNION ALL 
        SELECT 3731, 'Équateur',250,0,NULL,1, 'CD-EQ', NULL UNION ALL 
        SELECT 3732, 'Central Equatoria',259,0,NULL,1, 'SS-EC', NULL UNION ALL 
        SELECT 3733, 'Eastern Equatoria',259,0,NULL,1, 'SS-EE', NULL UNION ALL 
        SELECT 3734, 'Jonglei',259,0,NULL,1, 'SS-JG', NULL UNION ALL 
        SELECT 3735, 'Lakes',259,0,NULL,1, 'SS-LK', NULL UNION ALL 
        SELECT 3736, 'Northern Bahr el Ghazal',259,0,NULL,1, 'SS-BN', NULL UNION ALL 
        SELECT 3737, 'Unity',259,0,NULL,1, 'SS-UY', NULL UNION ALL 
        SELECT 3738, 'Upper Nile',259,0,NULL,1, 'SS-NU', NULL UNION ALL 
        SELECT 3739, 'Warrap',259,0,NULL,1, 'SS-WR', NULL UNION ALL 
        SELECT 3740, 'Western Bahr el Ghazal',259,0,NULL,1, 'SS-BW', NULL UNION ALL 
        SELECT 3741, 'Western Equatoria',259,0,NULL,1, 'SS-EW', NULL UNION ALL 
        SELECT 3742, 'Badakhshan',3,0,NULL,1, 'AF-BDS', NULL UNION ALL 
        SELECT 3743, 'Baghlan',3,0,NULL,1, 'AF-BGL', NULL UNION ALL 
        SELECT 3744, 'Balkh',3,0,NULL,1, 'AF-BAL', NULL UNION ALL 
        SELECT 3745, 'Badghis',3,0,NULL,1, 'AF-BDG', NULL UNION ALL 
        SELECT 3746, 'Bamyan',3,0,NULL,1, 'AF-BAM', NULL UNION ALL 
        SELECT 3747, 'Daykundi',3,0,NULL,1, 'AF-DAY', NULL UNION ALL 
        SELECT 3748, 'Farah',3,0,NULL,1, 'AF-FRA', NULL UNION ALL 
        SELECT 3749, 'Faryab',3,0,NULL,1, 'AF-FYB', NULL UNION ALL 
        SELECT 3750, 'Ghazni',3,0,NULL,1, 'AF-GHA', NULL UNION ALL 
        SELECT 3751, 'Ghor',3,0,NULL,1, 'AF-GHO', NULL UNION ALL 
        SELECT 3752, 'Helmand',3,0,NULL,1, 'AF-HEL', NULL UNION ALL 
        SELECT 3753, 'Herat',3,0,NULL,1, 'AF-HER', NULL UNION ALL 
        SELECT 3754, 'Jowzjan',3,0,NULL,1, 'AF-JOW', NULL UNION ALL 
        SELECT 3755, 'Kandahar',3,0,NULL,1, 'AF-KAN', NULL UNION ALL 
        SELECT 3756, 'Khost',3,0,NULL,1, 'AF-KHO', NULL UNION ALL 
        SELECT 3757, 'Kuna?',3,0,NULL,1, 'AF-KNR', NULL UNION ALL 
        SELECT 3758, 'Kunduz',3,0,NULL,1, 'AF-KDZ', NULL UNION ALL 
        SELECT 3759, 'Kabul',3,0,NULL,1, 'AF-KAB', NULL UNION ALL 
        SELECT 3760, 'Kapisa',3,0,NULL,1, 'AF-KAP', NULL UNION ALL 
        SELECT 3761, 'Laghman',3,0,NULL,1, 'AF-LAG', NULL UNION ALL 
        SELECT 3762, 'Logar',3,0,NULL,1, 'AF-LOG', NULL UNION ALL 
        SELECT 3763, 'Nangarhar',3,0,NULL,1, 'AF-NAN', NULL UNION ALL 
        SELECT 3764, 'Nimroz',3,0,NULL,1, 'AF-NIM', NULL UNION ALL 
        SELECT 3765, 'Nuristan',3,0,NULL,1, 'AF-NUR', NULL UNION ALL 
        SELECT 3766, 'Paktiya',3,0,NULL,1, 'AF-PIA', NULL UNION ALL 
        SELECT 3767, 'Paktika',3,0,NULL,1, 'AF-PKA', NULL UNION ALL 
        SELECT 3768, 'Panjshayr',3,0,NULL,1, 'AF-PAN', NULL UNION ALL 
        SELECT 3769, 'Parwan',3,0,NULL,1, 'AF-PAR', NULL UNION ALL 
        SELECT 3770, 'Samangan',3,0,NULL,1, 'AF-SAM', NULL UNION ALL 
        SELECT 3771, 'Sar-e Pul',3,0,NULL,1, 'AF-SAR', NULL UNION ALL 
        SELECT 3772, 'Takhar',3,0,NULL,1, 'AF-TAK', NULL UNION ALL 
        SELECT 3773, 'Uruzgan',3,0,NULL,1, 'AF-URU', NULL UNION ALL 
        SELECT 3774, 'Wardak',3,0,NULL,1, 'AF-WAR', NULL UNION ALL 
        SELECT 3775, 'Zabul',3,0,NULL,1, 'AF-ZAB', NULL UNION ALL 
        SELECT 3776, 'Brcko distrikt',29,0,NULL,1, 'BA-BRC', NULL UNION ALL 
        SELECT 3777, 'Federacija Bosne i Hercegovine',29,0,NULL,1, 'BA-BIH', NULL UNION ALL 
        SELECT 3778, 'Republika Srpska',29,0,NULL,1, 'BA-SRP', NULL UNION ALL 
        SELECT 3779, 'Belait',34,0,NULL,1, 'BN-BE', NULL UNION ALL 
        SELECT 3780, 'Brunei-Muara',34,0,NULL,1, 'BN-BM', NULL UNION ALL 
        SELECT 3781, 'Temburong',34,0,NULL,1, 'BN-TE', NULL UNION ALL 
        SELECT 3782, 'Tutong',34,0,NULL,1, 'BN-TU', NULL UNION ALL 
        SELECT 3783, 'Bubanza',37,0,NULL,1, 'BI-BB', NULL UNION ALL 
        SELECT 3784, 'Bujumbura Mairie',37,0,NULL,1, 'BI-BM', NULL UNION ALL 
        SELECT 3785, 'Bujumbura Rural',37,0,NULL,1, 'BI-BL', NULL UNION ALL 
        SELECT 3786, 'Bururi',37,0,NULL,1, 'BI-BR', NULL UNION ALL 
        SELECT 3787, 'Cankuzo',37,0,NULL,1, 'BI-CA', NULL UNION ALL 
        SELECT 3788, 'Cibitoke',37,0,NULL,1, 'BI-CI', NULL UNION ALL 
        SELECT 3789, 'Gitega',37,0,NULL,1, 'BI-GI', NULL UNION ALL 
        SELECT 3790, 'Karuzi',37,0,NULL,1, 'BI-KR', NULL UNION ALL 
        SELECT 3791, 'Kayanza',37,0,NULL,1, 'BI-KY', NULL UNION ALL 
        SELECT 3792, 'Kirundo',37,0,NULL,1, 'BI-KI', NULL UNION ALL 
        SELECT 3793, 'Makamba',37,0,NULL,1, 'BI-MA', NULL UNION ALL 
        SELECT 3794, 'Muramvya',37,0,NULL,1, 'BI-MU', NULL UNION ALL 
        SELECT 3795, 'Muyinga',37,0,NULL,1, 'BI-MY', NULL UNION ALL 
        SELECT 3796, 'Mwaro',37,0,NULL,1, 'BI-MW', NULL UNION ALL 
        SELECT 3797, 'Ngozi',37,0,NULL,1, 'BI-NG', NULL UNION ALL 
        SELECT 3798, 'Rumonge',37,0,NULL,1, 'BI-RM', NULL UNION ALL 
        SELECT 3799, 'Rutana',37,0,NULL,1, 'BI-RT', NULL UNION ALL 
        SELECT 3800, 'Ruyigi',37,0,NULL,1, 'BI-RY', NULL UNION ALL 
        SELECT 3801, 'Adamaoua',39,0,NULL,1, 'CM-AD', NULL UNION ALL 
        SELECT 3802, 'Centre',39,0,NULL,1, 'CM-CE', NULL UNION ALL 
        SELECT 3803, 'East',39,0,NULL,1, 'CM-ES', NULL UNION ALL 
        SELECT 3804, 'Far North',39,0,NULL,1, 'CM-EN', NULL UNION ALL 
        SELECT 3805, 'Littoral',39,0,NULL,1, 'CM-LT', NULL UNION ALL 
        SELECT 3806, 'North',39,0,NULL,1, 'CM-NO', NULL UNION ALL 
        SELECT 3807, 'North-West',39,0,NULL,1, 'CM-NW', NULL UNION ALL 
        SELECT 3808, 'South',39,0,NULL,1, 'CM-SU', NULL UNION ALL 
        SELECT 3809, 'South-West',39,0,NULL,1, 'CM-SW', NULL UNION ALL 
        SELECT 3810, 'West',39,0,NULL,1, 'CM-OU', NULL UNION ALL 
        SELECT 3811, 'Alberta',40,0,NULL,1, 'CA-AB', NULL UNION ALL 
        SELECT 3812, 'British Columbia',40,0,NULL,1, 'CA-BC', NULL UNION ALL 
        SELECT 3813, 'Manitoba',40,0,NULL,1, 'CA-MB', NULL UNION ALL 
        SELECT 3814, 'New Brunswick',40,0,NULL,1, 'CA-NB', NULL UNION ALL 
        SELECT 3815, 'Newfoundland and Labrador',40,0,NULL,1, 'CA-NL', NULL UNION ALL 
        SELECT 3816, 'Northwest Territories',40,0,NULL,1, 'CA-NT', NULL UNION ALL 
        SELECT 3817, 'Nova Scotia',40,0,NULL,1, 'CA-NS', NULL UNION ALL 
        SELECT 3818, 'Nunavut',40,0,NULL,1, 'CA-NU', NULL UNION ALL 
        SELECT 3819, 'Ontario',40,0,NULL,1, 'CA-ON', NULL UNION ALL 
        SELECT 3820, 'Prince Edward Island',40,0,NULL,1, 'CA-PE', NULL UNION ALL 
        SELECT 3821, 'Quebec',40,0,NULL,1, 'CA-QC', NULL UNION ALL 
        SELECT 3822, 'Saskatchewan',40,0,NULL,1, 'CA-SK', NULL UNION ALL 
        SELECT 3823, 'Yukon',40,0,NULL,1, 'CA-YT', NULL UNION ALL 
        SELECT 3824, 'Bamïngï-Bangoran',43,0,NULL,1, 'CF-BB', NULL UNION ALL 
        SELECT 3825, 'Bangî',43,0,NULL,1, 'CF-BGF', NULL UNION ALL 
        SELECT 3826, 'Do-Kötö',43,0,NULL,1, 'CF-BK', NULL UNION ALL 
        SELECT 3827, 'Gïrïbïngï',43,0,NULL,1, 'CF-KB', NULL UNION ALL 
        SELECT 3828, 'Kemö-Gïrïbïngï',43,0,NULL,1, 'CF-KG', NULL UNION ALL 
        SELECT 3829, 'Lobâye',43,0,NULL,1, 'CF-LB', NULL UNION ALL 
        SELECT 3830, 'Mbömü',43,0,NULL,1, 'CF-MB', NULL UNION ALL 
        SELECT 3831, 'Nanä-Mbaere',43,0,NULL,1, 'CF-NM', NULL UNION ALL 
        SELECT 3832, 'Sangä',43,0,NULL,1, 'CF-SE', NULL UNION ALL 
        SELECT 3833, 'Tö-Kötö',43,0,NULL,1, 'CF-HK', NULL UNION ALL 
        SELECT 3834, 'Tö-Mbömü',43,0,NULL,1, 'CF-HM', NULL UNION ALL 
        SELECT 3835, 'Tö-Sangä / Mbaere-Kadeï',43,0,NULL,1, 'CF-HS', NULL UNION ALL 
        SELECT 3836, 'Vakaga',43,0,NULL,1, 'CF-VK', NULL UNION ALL 
        SELECT 3837, 'Wâmo',43,0,NULL,1, 'CF-AC', NULL UNION ALL 
        SELECT 3838, 'Wâmo-Pendë',43,0,NULL,1, 'CF-OP', NULL UNION ALL 
        SELECT 3839, 'Wäkä',43,0,NULL,1, 'CF-UK', NULL UNION ALL 
        SELECT 3840, 'Ömbëlä-Pökö',43,0,NULL,1, 'CF-MP', NULL UNION ALL 
        SELECT 3841, 'Bahr el Ghazal',44,0,NULL,1, 'TD-BG', NULL UNION ALL 
        SELECT 3842, 'Batha',44,0,NULL,1, 'TD-BA', NULL UNION ALL 
        SELECT 3843, 'Borkou',44,0,NULL,1, 'TD-BO', NULL UNION ALL 
        SELECT 3844, 'Chari-Baguirmi',44,0,NULL,1, 'TD-CB', NULL UNION ALL 
        SELECT 3845, 'Ennedi-Est',44,0,NULL,1, 'TD-EE', NULL UNION ALL 
        SELECT 3846, 'Ennedi-Ouest',44,0,NULL,1, 'TD-EO', NULL UNION ALL 
        SELECT 3847, 'Guéra',44,0,NULL,1, 'TD-GR', NULL UNION ALL 
        SELECT 3848, 'Hadjer Lamis',44,0,NULL,1, 'TD-HL', NULL UNION ALL 
        SELECT 3849, 'Kanem',44,0,NULL,1, 'TD-KA', NULL UNION ALL 
        SELECT 3850, 'Lac',44,0,NULL,1, 'TD-LC', NULL UNION ALL 
        SELECT 3851, 'Logone-Occidental',44,0,NULL,1, 'TD-LO', NULL UNION ALL 
        SELECT 3852, 'Logone-Oriental',44,0,NULL,1, 'TD-LR', NULL UNION ALL 
        SELECT 3853, 'Mandoul',44,0,NULL,1, 'TD-MA', NULL UNION ALL 
        SELECT 3854, 'Mayo-Kebbi-Est',44,0,NULL,1, 'TD-ME', NULL UNION ALL 
        SELECT 3855, 'Mayo-Kebbi-Ouest',44,0,NULL,1, 'TD-MO', NULL UNION ALL 
        SELECT 3856, 'Moyen-Chari',44,0,NULL,1, 'TD-MC', NULL UNION ALL 
        SELECT 3857, 'Ouaddaï',44,0,NULL,1, 'TD-OD', NULL UNION ALL 
        SELECT 3858, 'Salamat',44,0,NULL,1, 'TD-SA', NULL UNION ALL 
        SELECT 3859, 'Sila',44,0,NULL,1, 'TD-SI', NULL UNION ALL 
        SELECT 3860, 'Tandjilé',44,0,NULL,1, 'TD-TA', NULL UNION ALL 
        SELECT 3861, 'Tibesti',44,0,NULL,1, 'TD-TI', NULL UNION ALL 
        SELECT 3862, 'Ville de Ndjamena',44,0,NULL,1, 'TD-ND', NULL UNION ALL 
        SELECT 3863, 'Wadi Fira',44,0,NULL,1, 'TD-WF', NULL UNION ALL 
        SELECT 3864, 'Anhui Sheng',46,0,NULL,1, 'CN-AH', NULL UNION ALL 
        SELECT 3865, 'Aomen Tebiexingzhengqu',46,0,NULL,1, 'CN-MO', NULL UNION ALL 
        SELECT 3866, 'Beijing Shi',46,0,NULL,1, 'CN-BJ', NULL UNION ALL 
        SELECT 3867, 'Chongqing Shi',46,0,NULL,1, 'CN-CQ', NULL UNION ALL 
        SELECT 3868, 'Fujian Sheng',46,0,NULL,1, 'CN-FJ', NULL UNION ALL 
        SELECT 3869, 'Gansu Sheng',46,0,NULL,1, 'CN-GS', NULL UNION ALL 
        SELECT 3870, 'Guangdong Sheng',46,0,NULL,1, 'CN-GD', NULL UNION ALL 
        SELECT 3871, 'Guangxi Zhuangzu Zizhiqu',46,0,NULL,1, 'CN-GX', NULL UNION ALL 
        SELECT 3872, 'Guizhou Sheng',46,0,NULL,1, 'CN-GZ', NULL UNION ALL 
        SELECT 3873, 'Hainan Sheng',46,0,NULL,1, 'CN-HI', NULL UNION ALL 
        SELECT 3874, 'Hebei Sheng',46,0,NULL,1, 'CN-HE', NULL UNION ALL 
        SELECT 3875, 'Heilongjiang Sheng',46,0,NULL,1, 'CN-HL', NULL UNION ALL 
        SELECT 3876, 'Henan Sheng',46,0,NULL,1, 'CN-HA', NULL UNION ALL 
        SELECT 3877, 'Hubei Sheng',46,0,NULL,1, 'CN-HB', NULL UNION ALL 
        SELECT 3878, 'Hunan Sheng',46,0,NULL,1, 'CN-HN', NULL UNION ALL 
        SELECT 3879, 'Jiangsu Sheng',46,0,NULL,1, 'CN-JS', NULL UNION ALL 
        SELECT 3880, 'Jiangxi Sheng',46,0,NULL,1, 'CN-JX', NULL UNION ALL 
        SELECT 3881, 'Jilin Sheng',46,0,NULL,1, 'CN-JL', NULL UNION ALL 
        SELECT 3882, 'Liaoning Sheng',46,0,NULL,1, 'CN-LN', NULL UNION ALL 
        SELECT 3883, 'Nei Mongol Zizhiqu',46,0,NULL,1, 'CN-NM', NULL UNION ALL 
        SELECT 3884, 'Ningxia Huizi Zizhiqu',46,0,NULL,1, 'CN-NX', NULL UNION ALL 
        SELECT 3885, 'Qinghai Sheng',46,0,NULL,1, 'CN-QH', NULL UNION ALL 
        SELECT 3886, 'Shaanxi Sheng',46,0,NULL,1, 'CN-SN', NULL UNION ALL 
        SELECT 3887, 'Shandong Sheng',46,0,NULL,1, 'CN-SD', NULL UNION ALL 
        SELECT 3888, 'Shanghai Shi',46,0,NULL,1, 'CN-SH', NULL UNION ALL 
        SELECT 3889, 'Shanxi Sheng',46,0,NULL,1, 'CN-SX', NULL UNION ALL 
        SELECT 3890, 'Sichuan Sheng',46,0,NULL,1, 'CN-SC', NULL UNION ALL 
        SELECT 3891, 'Taiwan Sheng',46,0,NULL,1, 'CN-TW', NULL UNION ALL 
        SELECT 3892, 'Tianjin Shi',46,0,NULL,1, 'CN-TJ', NULL UNION ALL 
        SELECT 3893, 'Xianggang Tebiexingzhengqu',46,0,NULL,1, 'CN-HK', NULL UNION ALL 
        SELECT 3894, 'Xinjiang Uygur Zizhiqu',46,0,NULL,1, 'CN-XJ', NULL UNION ALL 
        SELECT 3895, 'Xizang Zizhiqu',46,0,NULL,1, 'CN-XZ', NULL UNION ALL 
        SELECT 3896, 'Yunnan Sheng',46,0,NULL,1, 'CN-YN', NULL UNION ALL 
        SELECT 3897, 'Zhejiang Sheng',46,0,NULL,1, 'CN-ZJ', NULL UNION ALL 
        SELECT 3898, 'Ammochostos',57,0,NULL,1, 'CY-04', NULL UNION ALL 
        SELECT 3899, 'Keryneia',57,0,NULL,1, 'CY-06', NULL UNION ALL 
        SELECT 3900, 'Larnaka',57,0,NULL,1, 'CY-03', NULL UNION ALL 
        SELECT 3901, 'Lefkosia',57,0,NULL,1, 'CY-01', NULL UNION ALL 
        SELECT 3902, 'Lemesos',57,0,NULL,1, 'CY-02', NULL UNION ALL 
        SELECT 3903, 'Pafos',57,0,NULL,1, 'CY-05', NULL UNION ALL 
        SELECT 3904, 'Aileu',63,0,NULL,1, 'TL-AL', NULL UNION ALL 
        SELECT 3905, 'Ainaro',63,0,NULL,1, 'TL-AN', NULL UNION ALL 
        SELECT 3906, 'Baucau',63,0,NULL,1, 'TL-BA', NULL UNION ALL 
        SELECT 3907, 'Bobonaro',63,0,NULL,1, 'TL-BO', NULL UNION ALL 
        SELECT 3908, 'Cova Lima',63,0,NULL,1, 'TL-CO', NULL UNION ALL 
        SELECT 3909, 'Díli',63,0,NULL,1, 'TL-DI', NULL UNION ALL 
        SELECT 3910, 'Ermera',63,0,NULL,1, 'TL-ER', NULL UNION ALL 
        SELECT 3911, 'Lautém',63,0,NULL,1, 'TL-LA', NULL UNION ALL 
        SELECT 3912, 'Liquiça',63,0,NULL,1, 'TL-LI', NULL UNION ALL 
        SELECT 3913, 'Manatuto',63,0,NULL,1, 'TL-MT', NULL UNION ALL 
        SELECT 3914, 'Manufahi',63,0,NULL,1, 'TL-MF', NULL UNION ALL 
        SELECT 3915, 'Oé-Cusse Ambeno',63,0,NULL,1, 'TL-OE', NULL UNION ALL 
        SELECT 3916, 'Viqueque',63,0,NULL,1, 'TL-VI', NULL UNION ALL 
        SELECT 3917, 'Annobón',67,0,NULL,1, 'GQ-AN', 'GQ-I' UNION ALL 
        SELECT 3918, 'Bioko Norte',67,0,NULL,1, 'GQ-BN', 'GQ-I' UNION ALL 
        SELECT 3919, 'Bioko Sur',67,0,NULL,1, 'GQ-BS', 'GQ-I' UNION ALL 
        SELECT 3920, 'Centro Sur',67,0,NULL,1, 'GQ-CS', 'GQ-C' UNION ALL 
        SELECT 3921, 'Kié-Ntem',67,0,NULL,1, 'GQ-KN', 'GQ-C' UNION ALL 
        SELECT 3922, 'Litoral',67,0,NULL,1, 'GQ-LI', 'GQ-C' UNION ALL 
        SELECT 3923, 'Región Continental',67,0,NULL,1, 'GQ-C', NULL UNION ALL 
        SELECT 3924, 'Región Insular',67,0,NULL,1, 'GQ-I', NULL UNION ALL 
        SELECT 3925, 'Wele-Nzas',67,0,NULL,1, 'GQ-WN', 'GQ-C' UNION ALL 
        SELECT 3926, 'Debub',68,0,NULL,1, 'ER-DU', NULL UNION ALL 
        SELECT 3927, 'Debubawi K’eyyi? Ba?ri',68,0,NULL,1, 'ER-DK', NULL UNION ALL 
        SELECT 3928, 'Gash-Barka',68,0,NULL,1, 'ER-GB', NULL UNION ALL 
        SELECT 3929, 'Ma’ikel',68,0,NULL,1, 'ER-MA', NULL UNION ALL 
        SELECT 3930, 'Semienawi K’eyyi? Ba?ri',68,0,NULL,1, 'ER-SK', NULL UNION ALL 
        SELECT 3931, '‘Anseba',68,0,NULL,1, 'ER-AN', NULL UNION ALL 
        SELECT 3932, 'Addis Ababa',70,0,NULL,1, 'ET-AA', NULL UNION ALL 
        SELECT 3933, 'Afar',70,0,NULL,1, 'ET-AF', NULL UNION ALL 
        SELECT 3934, 'Amara',70,0,NULL,1, 'ET-AM', NULL UNION ALL 
        SELECT 3935, 'Benshangul-Gumaz',70,0,NULL,1, 'ET-BE', NULL UNION ALL 
        SELECT 3936, 'Dire Dawa',70,0,NULL,1, 'ET-DD', NULL UNION ALL 
        SELECT 3937, 'Gambela Peoples',70,0,NULL,1, 'ET-GA', NULL UNION ALL 
        SELECT 3938, 'Harari People',70,0,NULL,1, 'ET-HA', NULL UNION ALL 
        SELECT 3939, 'Oromia',70,0,NULL,1, 'ET-OR', NULL UNION ALL 
        SELECT 3940, 'Somali',70,0,NULL,1, 'ET-SO', NULL UNION ALL 
        SELECT 3941, 'Southern Nations, Nationalities and Peoples',70,0,NULL,1, 'ET-SN', NULL UNION ALL 
        SELECT 3942, 'Tigrai',70,0,NULL,1, 'ET-TI', NULL UNION ALL 
        SELECT 3943, 'Ahvenanmaan maakunta',74,0,NULL,1, 'FI-01', NULL UNION ALL 
        SELECT 3944, 'Etelä-Karjala',74,0,NULL,1, 'FI-02', NULL UNION ALL 
        SELECT 3945, 'Etelä-Pohjanmaa',74,0,NULL,1, 'FI-03', NULL UNION ALL 
        SELECT 3946, 'Etelä-Savo',74,0,NULL,1, 'FI-04', NULL UNION ALL 
        SELECT 3947, 'Kainuu',74,0,NULL,1, 'FI-05', NULL UNION ALL 
        SELECT 3948, 'Kanta-Häme',74,0,NULL,1, 'FI-06', NULL UNION ALL 
        SELECT 3949, 'Keski-Pohjanmaa',74,0,NULL,1, 'FI-07', NULL UNION ALL 
        SELECT 3950, 'Keski-Suomi',74,0,NULL,1, 'FI-08', NULL UNION ALL 
        SELECT 3951, 'Kymenlaakso',74,0,NULL,1, 'FI-09', NULL UNION ALL 
        SELECT 3952, 'Lappi',74,0,NULL,1, 'FI-10', NULL UNION ALL 
        SELECT 3953, 'Pirkanmaa',74,0,NULL,1, 'FI-11', NULL UNION ALL 
        SELECT 3954, 'Pohjanmaa',74,0,NULL,1, 'FI-12', NULL UNION ALL 
        SELECT 3955, 'Pohjois-Karjala',74,0,NULL,1, 'FI-13', NULL UNION ALL 
        SELECT 3956, 'Pohjois-Pohjanmaa',74,0,NULL,1, 'FI-14', NULL UNION ALL 
        SELECT 3957, 'Pohjois-Savo',74,0,NULL,1, 'FI-15', NULL UNION ALL 
        SELECT 3958, 'Päijät-Häme',74,0,NULL,1, 'FI-16', NULL UNION ALL 
        SELECT 3959, 'Satakunta',74,0,NULL,1, 'FI-17', NULL UNION ALL 
        SELECT 3960, 'Uusimaa',74,0,NULL,1, 'FI-18', NULL UNION ALL 
        SELECT 3961, 'Varsinais-Suomi',74,0,NULL,1, 'FI-19', NULL UNION ALL 
        SELECT 3962, 'Artibonite',96,0,NULL,1, 'HT-AR', NULL UNION ALL 
        SELECT 3963, 'Centre',96,0,NULL,1, 'HT-CE', NULL UNION ALL 
        SELECT 3964, 'Grande’Anse',96,0,NULL,1, 'HT-GA', NULL UNION ALL 
        SELECT 3965, 'Nippes',96,0,NULL,1, 'HT-NI', NULL UNION ALL 
        SELECT 3966, 'Nord',96,0,NULL,1, 'HT-ND', NULL UNION ALL 
        SELECT 3967, 'Nord-Est',96,0,NULL,1, 'HT-NE', NULL UNION ALL 
        SELECT 3968, 'Nord-Ouest',96,0,NULL,1, 'HT-NO', NULL UNION ALL 
        SELECT 3969, 'Ouest',96,0,NULL,1, 'HT-OU', NULL UNION ALL 
        SELECT 3970, 'Sud',96,0,NULL,1, 'HT-SD', NULL UNION ALL 
        SELECT 3971, 'Sud-Est',96,0,NULL,1, 'HT-SE', NULL UNION ALL 
        SELECT 3972, 'Al Anbar',105,0,NULL,1, 'IQ-AN', NULL UNION ALL 
        SELECT 3973, 'Al Basrah',105,0,NULL,1, 'IQ-BA', NULL UNION ALL 
        SELECT 3974, 'Al Muthanná',105,0,NULL,1, 'IQ-MU', NULL UNION ALL 
        SELECT 3975, 'Al Qadisiyah',105,0,NULL,1, 'IQ-QA', NULL UNION ALL 
        SELECT 3976, 'An Najaf',105,0,NULL,1, 'IQ-NA', NULL UNION ALL 
        SELECT 3977, 'Arbil',105,0,NULL,1, 'IQ-AR', NULL UNION ALL 
        SELECT 3978, 'As Sulaymaniyah',105,0,NULL,1, 'IQ-SU', NULL UNION ALL 
        SELECT 3979, 'Baghdad',105,0,NULL,1, 'IQ-BG', NULL UNION ALL 
        SELECT 3980, 'Babil',105,0,NULL,1, 'IQ-BB', NULL UNION ALL 
        SELECT 3981, 'Dahuk',105,0,NULL,1, 'IQ-DA', NULL UNION ALL 
        SELECT 3982, 'Dhi Qar',105,0,NULL,1, 'IQ-DQ', NULL UNION ALL 
        SELECT 3983, 'Diyalá',105,0,NULL,1, 'IQ-DI', NULL UNION ALL 
        SELECT 3984, 'Karbala’',105,0,NULL,1, 'IQ-KA', NULL UNION ALL 
        SELECT 3985, 'Kirkuk',105,0,NULL,1, 'IQ-KI', NULL UNION ALL 
        SELECT 3986, 'Maysan',105,0,NULL,1, 'IQ-MA', NULL UNION ALL 
        SELECT 3987, 'Ninawá',105,0,NULL,1, 'IQ-NI', NULL UNION ALL 
        SELECT 3988, 'Wasit',105,0,NULL,1, 'IQ-WA', NULL UNION ALL 
        SELECT 3989, 'Sala? ad Din',105,0,NULL,1, 'IQ-SD', NULL UNION ALL 
        SELECT 3990, 'Carlow',106,0,NULL,1, 'IE-CW', 'IE-L' UNION ALL 
        SELECT 3991, 'Cavan',106,0,NULL,1, 'IE-CN', 'IE-U' UNION ALL 
        SELECT 3992, 'Clare',106,0,NULL,1, 'IE-CE', 'IE-M' UNION ALL 
        SELECT 3993, 'Connaught',106,0,NULL,1, 'IE-C', NULL UNION ALL 
        SELECT 3994, 'Cork',106,0,NULL,1, 'IE-CO', 'IE-M' UNION ALL 
        SELECT 3995, 'Donegal',106,0,NULL,1, 'IE-DL', 'IE-U' UNION ALL 
        SELECT 3996, 'Dublin',106,0,NULL,1, 'IE-D', 'IE-L' UNION ALL 
        SELECT 3997, 'Galway',106,0,NULL,1, 'IE-G', 'IE-C' UNION ALL 
        SELECT 3998, 'Kerry',106,0,NULL,1, 'IE-KY', 'IE-M' UNION ALL 
        SELECT 3999, 'Kildare',106,0,NULL,1, 'IE-KE', 'IE-L' UNION ALL 
        SELECT 4000, 'Kilkenny',106,0,NULL,1, 'IE-KK', 'IE-L' UNION ALL 
        SELECT 4001, 'Laois',106,0,NULL,1, 'IE-LS', 'IE-L' UNION ALL 
        SELECT 4002, 'Leinster',106,0,NULL,1, 'IE-L', NULL UNION ALL 
        SELECT 4003, 'Leitrim',106,0,NULL,1, 'IE-LM', 'IE-C' UNION ALL 
        SELECT 4004, 'Limerick',106,0,NULL,1, 'IE-LK', 'IE-M' UNION ALL 
        SELECT 4005, 'Longford',106,0,NULL,1, 'IE-LD', 'IE-L' UNION ALL 
        SELECT 4006, 'Louth',106,0,NULL,1, 'IE-LH', 'IE-L' UNION ALL 
        SELECT 4007, 'Mayo',106,0,NULL,1, 'IE-MO', 'IE-C' UNION ALL 
        SELECT 4008, 'Meath',106,0,NULL,1, 'IE-MH', 'IE-L' UNION ALL 
        SELECT 4009, 'Monaghan',106,0,NULL,1, 'IE-MN', 'IE-U' UNION ALL 
        SELECT 4010, 'Munster',106,0,NULL,1, 'IE-M', NULL UNION ALL 
        SELECT 4011, 'Offaly',106,0,NULL,1, 'IE-OY', 'IE-L' UNION ALL 
        SELECT 4012, 'Roscommon',106,0,NULL,1, 'IE-RN', 'IE-C' UNION ALL 
        SELECT 4013, 'Sligo',106,0,NULL,1, 'IE-SO', 'IE-C' UNION ALL 
        SELECT 4014, 'Tipperary',106,0,NULL,1, 'IE-TA', 'IE-M' UNION ALL 
        SELECT 4015, 'Ulster',106,0,NULL,1, 'IE-U', NULL UNION ALL 
        SELECT 4016, 'Waterford',106,0,NULL,1, 'IE-WD', 'IE-M' UNION ALL 
        SELECT 4017, 'Westmeath',106,0,NULL,1, 'IE-WH', 'IE-L' UNION ALL 
        SELECT 4018, 'Wexford',106,0,NULL,1, 'IE-WX', 'IE-L' UNION ALL 
        SELECT 4019, 'Wicklow',106,0,NULL,1, 'IE-WW', 'IE-L' UNION ALL 
        SELECT 4020, 'HaDarom',107,0,NULL,1, 'IL-D', NULL UNION ALL 
        SELECT 4021, 'HaMerkaz',107,0,NULL,1, 'IL-M', NULL UNION ALL 
        SELECT 4022, 'HaTsafon',107,0,NULL,1, 'IL-Z', NULL UNION ALL 
        SELECT 4023, 'H_efa',107,0,NULL,1, 'IL-HA', NULL UNION ALL 
        SELECT 4024, 'Tel Aviv',107,0,NULL,1, 'IL-TA', NULL UNION ALL 
        SELECT 4025, 'Yerushalayim',107,0,NULL,1, 'IL-JM', NULL UNION ALL 
        SELECT 4026, 'Abruzzo',108,0,NULL,1, 'IT-65', NULL UNION ALL 
        SELECT 4027, 'Agrigento',108,0,NULL,1, 'IT-AG', 'IT-82' UNION ALL 
        SELECT 4028, 'Alessandria',108,0,NULL,1, 'IT-AL', 'IT-21' UNION ALL 
        SELECT 4029, 'Ancona',108,0,NULL,1, 'IT-AN', 'IT-57' UNION ALL 
        SELECT 4030, 'Arezzo',108,0,NULL,1, 'IT-AR', 'IT-52' UNION ALL 
        SELECT 4031, 'Ascoli Piceno',108,0,NULL,1, 'IT-AP', 'IT-57' UNION ALL 
        SELECT 4032, 'Asti',108,0,NULL,1, 'IT-AT', 'IT-21' UNION ALL 
        SELECT 4033, 'Avellino',108,0,NULL,1, 'IT-AV', 'IT-72' UNION ALL 
        SELECT 4034, 'Bari',108,0,NULL,1, 'IT-BA', 'IT-75' UNION ALL 
        SELECT 4035, 'Barletta-Andria-Trani',108,0,NULL,1, 'IT-BT', 'IT-75' UNION ALL 
        SELECT 4036, 'Basilicata',108,0,NULL,1, 'IT-77', NULL UNION ALL 
        SELECT 4037, 'Belluno',108,0,NULL,1, 'IT-BL', 'IT-34' UNION ALL 
        SELECT 4038, 'Benevento',108,0,NULL,1, 'IT-BN', 'IT-72' UNION ALL 
        SELECT 4039, 'Bergamo',108,0,NULL,1, 'IT-BG', 'IT-25' UNION ALL 
        SELECT 4040, 'Biella',108,0,NULL,1, 'IT-BI', 'IT-21' UNION ALL 
        SELECT 4041, 'Bologna',108,0,NULL,1, 'IT-BO', 'IT-45' UNION ALL 
        SELECT 4042, 'Bolzano',108,0,NULL,1, 'IT-BZ', 'IT-32' UNION ALL 
        SELECT 4043, 'Brescia',108,0,NULL,1, 'IT-BS', 'IT-25' UNION ALL 
        SELECT 4044, 'Brindisi',108,0,NULL,1, 'IT-BR', 'IT-75' UNION ALL 
        SELECT 4045, 'Cagliari',108,0,NULL,1, 'IT-CA', 'IT-88' UNION ALL 
        SELECT 4046, 'Calabria',108,0,NULL,1, 'IT-78', NULL UNION ALL 
        SELECT 4047, 'Caltanissetta',108,0,NULL,1, 'IT-CL', 'IT-82' UNION ALL 
        SELECT 4048, 'Campania',108,0,NULL,1, 'IT-72', NULL UNION ALL 
        SELECT 4049, 'Campobasso',108,0,NULL,1, 'IT-CB', 'IT-67' UNION ALL 
        SELECT 4050, 'Caserta',108,0,NULL,1, 'IT-CE', 'IT-72' UNION ALL 
        SELECT 4051, 'Catania',108,0,NULL,1, 'IT-CT', 'IT-82' UNION ALL 
        SELECT 4052, 'Catanzaro',108,0,NULL,1, 'IT-CZ', 'IT-78' UNION ALL 
        SELECT 4053, 'Chieti',108,0,NULL,1, 'IT-CH', 'IT-65' UNION ALL 
        SELECT 4054, 'Como',108,0,NULL,1, 'IT-CO', 'IT-25' UNION ALL 
        SELECT 4055, 'Cosenza',108,0,NULL,1, 'IT-CS', 'IT-78' UNION ALL 
        SELECT 4056, 'Cremona',108,0,NULL,1, 'IT-CR', 'IT-25' UNION ALL 
        SELECT 4057, 'Crotone',108,0,NULL,1, 'IT-KR', 'IT-78' UNION ALL 
        SELECT 4058, 'Cuneo',108,0,NULL,1, 'IT-CN', 'IT-21' UNION ALL 
        SELECT 4059, 'Emilia-Romagna',108,0,NULL,1, 'IT-45', NULL UNION ALL 
        SELECT 4060, 'Enna',108,0,NULL,1, 'IT-EN', 'IT-82' UNION ALL 
        SELECT 4061, 'Fermo',108,0,NULL,1, 'IT-FM', 'IT-57' UNION ALL 
        SELECT 4062, 'Ferrara',108,0,NULL,1, 'IT-FE', 'IT-45' UNION ALL 
        SELECT 4063, 'Firenze',108,0,NULL,1, 'IT-FI', 'IT-52' UNION ALL 
        SELECT 4064, 'Foggia',108,0,NULL,1, 'IT-FG', 'IT-75' UNION ALL 
        SELECT 4065, 'Forlì-Cesena',108,0,NULL,1, 'IT-FC', 'IT-45' UNION ALL 
        SELECT 4066, 'Friuli Venezia Giulia',108,0,NULL,1, 'IT-36', NULL UNION ALL 
        SELECT 4067, 'Frosinone',108,0,NULL,1, 'IT-FR', 'IT-62' UNION ALL 
        SELECT 4068, 'Genova',108,0,NULL,1, 'IT-GE', 'IT-42' UNION ALL 
        SELECT 4069, 'Grosseto',108,0,NULL,1, 'IT-GR', 'IT-52' UNION ALL 
        SELECT 4070, 'Imperia',108,0,NULL,1, 'IT-IM', 'IT-42' UNION ALL 
        SELECT 4071, 'Isernia',108,0,NULL,1, 'IT-IS', 'IT-67' UNION ALL 
        SELECT 4072, 'L''Aquila',108,0,NULL,1, 'IT-AQ', 'IT-65' UNION ALL 
        SELECT 4073, 'La Spezia',108,0,NULL,1, 'IT-SP', 'IT-42' UNION ALL 
        SELECT 4074, 'Latina',108,0,NULL,1, 'IT-LT', 'IT-62' UNION ALL 
        SELECT 4075, 'Lazio',108,0,NULL,1, 'IT-62', NULL UNION ALL 
        SELECT 4076, 'Lecce',108,0,NULL,1, 'IT-LE', 'IT-75' UNION ALL 
        SELECT 4077, 'Lecco',108,0,NULL,1, 'IT-LC', 'IT-25' UNION ALL 
        SELECT 4078, 'Liguria',108,0,NULL,1, 'IT-42', NULL UNION ALL 
        SELECT 4079, 'Livorno',108,0,NULL,1, 'IT-LI', 'IT-52' UNION ALL 
        SELECT 4080, 'Lodi',108,0,NULL,1, 'IT-LO', 'IT-25' UNION ALL 
        SELECT 4081, 'Lombardia',108,0,NULL,1, 'IT-25', NULL UNION ALL 
        SELECT 4082, 'Lucca',108,0,NULL,1, 'IT-LU', 'IT-52' UNION ALL 
        SELECT 4083, 'Macerata',108,0,NULL,1, 'IT-MC', 'IT-57' UNION ALL 
        SELECT 4084, 'Mantova',108,0,NULL,1, 'IT-MN', 'IT-25' UNION ALL 
        SELECT 4085, 'Marche',108,0,NULL,1, 'IT-57', NULL UNION ALL 
        SELECT 4086, 'Massa-Carrara',108,0,NULL,1, 'IT-MS', 'IT-52' UNION ALL 
        SELECT 4087, 'Matera',108,0,NULL,1, 'IT-MT', 'IT-77' UNION ALL 
        SELECT 4088, 'Messina',108,0,NULL,1, 'IT-ME', 'IT-82' UNION ALL 
        SELECT 4089, 'Milano',108,0,NULL,1, 'IT-MI', 'IT-25' UNION ALL 
        SELECT 4090, 'Modena',108,0,NULL,1, 'IT-MO', 'IT-45' UNION ALL 
        SELECT 4091, 'Molise',108,0,NULL,1, 'IT-67', NULL UNION ALL 
        SELECT 4092, 'Monza e Brianza',108,0,NULL,1, 'IT-MB', 'IT-25' UNION ALL 
        SELECT 4093, 'Napoli',108,0,NULL,1, 'IT-NA', 'IT-72' UNION ALL 
        SELECT 4094, 'Novara',108,0,NULL,1, 'IT-NO', 'IT-21' UNION ALL 
        SELECT 4095, 'Nuoro',108,0,NULL,1, 'IT-NU', 'IT-88' UNION ALL 
        SELECT 4096, 'Oristano',108,0,NULL,1, 'IT-OR', 'IT-88' UNION ALL 
        SELECT 4097, 'Padova',108,0,NULL,1, 'IT-PD', 'IT-34' UNION ALL 
        SELECT 4098, 'Palermo',108,0,NULL,1, 'IT-PA', 'IT-82' UNION ALL 
        SELECT 4099, 'Parma',108,0,NULL,1, 'IT-PR', 'IT-45' UNION ALL 
        SELECT 4100, 'Pavia',108,0,NULL,1, 'IT-PV', 'IT-25' UNION ALL 
        SELECT 4101, 'Perugia',108,0,NULL,1, 'IT-PG', 'IT-55' UNION ALL 
        SELECT 4102, 'Pesaro e Urbino',108,0,NULL,1, 'IT-PU', 'IT-57' UNION ALL 
        SELECT 4103, 'Pescara',108,0,NULL,1, 'IT-PE', 'IT-65' UNION ALL 
        SELECT 4104, 'Piacenza',108,0,NULL,1, 'IT-PC', 'IT-45' UNION ALL 
        SELECT 4105, 'Piemonte',108,0,NULL,1, 'IT-21', NULL UNION ALL 
        SELECT 4106, 'Pisa',108,0,NULL,1, 'IT-PI', 'IT-52' UNION ALL 
        SELECT 4107, 'Pistoia',108,0,NULL,1, 'IT-PT', 'IT-52' UNION ALL 
        SELECT 4108, 'Potenza',108,0,NULL,1, 'IT-PZ', 'IT-77' UNION ALL 
        SELECT 4109, 'Prato',108,0,NULL,1, 'IT-PO', 'IT-52' UNION ALL 
        SELECT 4110, 'Puglia',108,0,NULL,1, 'IT-75', NULL UNION ALL 
        SELECT 4111, 'Ragusa',108,0,NULL,1, 'IT-RG', 'IT-82' UNION ALL 
        SELECT 4112, 'Ravenna',108,0,NULL,1, 'IT-RA', 'IT-45' UNION ALL 
        SELECT 4113, 'Reggio Calabria',108,0,NULL,1, 'IT-RC', 'IT-78' UNION ALL 
        SELECT 4114, 'Reggio Emilia',108,0,NULL,1, 'IT-RE', 'IT-45' UNION ALL 
        SELECT 4115, 'Rieti',108,0,NULL,1, 'IT-RI', 'IT-62' UNION ALL 
        SELECT 4116, 'Rimini',108,0,NULL,1, 'IT-RN', 'IT-45' UNION ALL 
        SELECT 4117, 'Roma',108,0,NULL,1, 'IT-RM', 'IT-62' UNION ALL 
        SELECT 4118, 'Rovigo',108,0,NULL,1, 'IT-RO', 'IT-34' UNION ALL 
        SELECT 4119, 'Salerno',108,0,NULL,1, 'IT-SA', 'IT-72' UNION ALL 
        SELECT 4120, 'Sardegna',108,0,NULL,1, 'IT-88', NULL UNION ALL 
        SELECT 4121, 'Sassari',108,0,NULL,1, 'IT-SS', 'IT-88' UNION ALL 
        SELECT 4122, 'Savona',108,0,NULL,1, 'IT-SV', 'IT-42' UNION ALL 
        SELECT 4123, 'Sicilia',108,0,NULL,1, 'IT-82', NULL UNION ALL 
        SELECT 4124, 'Siena',108,0,NULL,1, 'IT-SI', 'IT-52' UNION ALL 
        SELECT 4125, 'Siracusa',108,0,NULL,1, 'IT-SR', 'IT-82' UNION ALL 
        SELECT 4126, 'Sondrio',108,0,NULL,1, 'IT-SO', 'IT-25' UNION ALL 
        SELECT 4127, 'Sud Sardegna',108,0,NULL,1, 'IT-SD', 'IT-88' UNION ALL 
        SELECT 4128, 'Taranto',108,0,NULL,1, 'IT-TA', 'IT-75' UNION ALL 
        SELECT 4129, 'Teramo',108,0,NULL,1, 'IT-TE', 'IT-65' UNION ALL 
        SELECT 4130, 'Terni',108,0,NULL,1, 'IT-TR', 'IT-55' UNION ALL 
        SELECT 4131, 'Torino',108,0,NULL,1, 'IT-TO', 'IT-21' UNION ALL 
        SELECT 4132, 'Toscana',108,0,NULL,1, 'IT-52', NULL UNION ALL 
        SELECT 4133, 'Trapani',108,0,NULL,1, 'IT-TP', 'IT-82' UNION ALL 
        SELECT 4134, 'Trentino-Alto Adige',108,0,NULL,1, 'IT-32', NULL UNION ALL 
        SELECT 4135, 'Trento',108,0,NULL,1, 'IT-TN', 'IT-32' UNION ALL 
        SELECT 4136, 'Treviso',108,0,NULL,1, 'IT-TV', 'IT-34' UNION ALL 
        SELECT 4137, 'Umbria',108,0,NULL,1, 'IT-55', NULL UNION ALL 
        SELECT 4138, 'Valle d''Aosta',108,0,NULL,1, 'IT-23', NULL UNION ALL 
        SELECT 4139, 'Varese',108,0,NULL,1, 'IT-VA', 'IT-25' UNION ALL 
        SELECT 4140, 'Veneto',108,0,NULL,1, 'IT-34', NULL UNION ALL 
        SELECT 4141, 'Venezia',108,0,NULL,1, 'IT-VE', 'IT-34' UNION ALL 
        SELECT 4142, 'Verbano-Cusio-Ossola',108,0,NULL,1, 'IT-VB', 'IT-21' UNION ALL 
        SELECT 4143, 'Vercelli',108,0,NULL,1, 'IT-VC', 'IT-21' UNION ALL 
        SELECT 4144, 'Verona',108,0,NULL,1, 'IT-VR', 'IT-34' UNION ALL 
        SELECT 4145, 'Vibo Valentia',108,0,NULL,1, 'IT-VV', 'IT-78' UNION ALL 
        SELECT 4146, 'Vicenza',108,0,NULL,1, 'IT-VI', 'IT-34' UNION ALL 
        SELECT 4147, 'Viterbo',108,0,NULL,1, 'IT-VT', 'IT-62' UNION ALL 
        SELECT 4148, 'Aiti',110,0,NULL,1, 'JP-23', NULL UNION ALL 
        SELECT 4149, 'Akita',110,0,NULL,1, 'JP-05', NULL UNION ALL 
        SELECT 4150, 'Aomori',110,0,NULL,1, 'JP-02', NULL UNION ALL 
        SELECT 4151, 'Ehime',110,0,NULL,1, 'JP-38', NULL UNION ALL 
        SELECT 4152, 'Gihu',110,0,NULL,1, 'JP-21', NULL UNION ALL 
        SELECT 4153, 'Gunma',110,0,NULL,1, 'JP-10', NULL UNION ALL 
        SELECT 4154, 'Hirosima',110,0,NULL,1, 'JP-34', NULL UNION ALL 
        SELECT 4155, 'Hokkaidô',110,0,NULL,1, 'JP-01', NULL UNION ALL 
        SELECT 4156, 'Hukui',110,0,NULL,1, 'JP-18', NULL UNION ALL 
        SELECT 4157, 'Hukuoka',110,0,NULL,1, 'JP-40', NULL UNION ALL 
        SELECT 4158, 'Hukusima',110,0,NULL,1, 'JP-07', NULL UNION ALL 
        SELECT 4159, 'Hyôgo',110,0,NULL,1, 'JP-28', NULL UNION ALL 
        SELECT 4160, 'Ibaraki',110,0,NULL,1, 'JP-08', NULL UNION ALL 
        SELECT 4161, 'Isikawa',110,0,NULL,1, 'JP-17', NULL UNION ALL 
        SELECT 4162, 'Iwate',110,0,NULL,1, 'JP-03', NULL UNION ALL 
        SELECT 4163, 'Kagawa',110,0,NULL,1, 'JP-37', NULL UNION ALL 
        SELECT 4164, 'Kagosima',110,0,NULL,1, 'JP-46', NULL UNION ALL 
        SELECT 4165, 'Kanagawa',110,0,NULL,1, 'JP-14', NULL UNION ALL 
        SELECT 4166, 'Kumamoto',110,0,NULL,1, 'JP-43', NULL UNION ALL 
        SELECT 4167, 'Kyôto',110,0,NULL,1, 'JP-26', NULL UNION ALL 
        SELECT 4168, 'Kôti',110,0,NULL,1, 'JP-39', NULL UNION ALL 
        SELECT 4169, 'Mie',110,0,NULL,1, 'JP-24', NULL UNION ALL 
        SELECT 4170, 'Miyagi',110,0,NULL,1, 'JP-04', NULL UNION ALL 
        SELECT 4171, 'Miyazaki',110,0,NULL,1, 'JP-45', NULL UNION ALL 
        SELECT 4172, 'Nagano',110,0,NULL,1, 'JP-20', NULL UNION ALL 
        SELECT 4173, 'Nagasaki',110,0,NULL,1, 'JP-42', NULL UNION ALL 
        SELECT 4174, 'Nara',110,0,NULL,1, 'JP-29', NULL UNION ALL 
        SELECT 4175, 'Niigata',110,0,NULL,1, 'JP-15', NULL UNION ALL 
        SELECT 4176, 'Okayama',110,0,NULL,1, 'JP-33', NULL UNION ALL 
        SELECT 4177, 'Okinawa',110,0,NULL,1, 'JP-47', NULL UNION ALL 
        SELECT 4178, 'Saga',110,0,NULL,1, 'JP-41', NULL UNION ALL 
        SELECT 4179, 'Saitama',110,0,NULL,1, 'JP-11', NULL UNION ALL 
        SELECT 4180, 'Siga',110,0,NULL,1, 'JP-25', NULL UNION ALL 
        SELECT 4181, 'Simane',110,0,NULL,1, 'JP-32', NULL UNION ALL 
        SELECT 4182, 'Sizuoka',110,0,NULL,1, 'JP-22', NULL UNION ALL 
        SELECT 4183, 'Tiba',110,0,NULL,1, 'JP-12', NULL UNION ALL 
        SELECT 4184, 'Tokusima',110,0,NULL,1, 'JP-36', NULL UNION ALL 
        SELECT 4185, 'Totigi',110,0,NULL,1, 'JP-09', NULL UNION ALL 
        SELECT 4186, 'Tottori',110,0,NULL,1, 'JP-31', NULL UNION ALL 
        SELECT 4187, 'Toyama',110,0,NULL,1, 'JP-16', NULL UNION ALL 
        SELECT 4188, 'Tôkyô',110,0,NULL,1, 'JP-13', NULL UNION ALL 
        SELECT 4189, 'Wakayama',110,0,NULL,1, 'JP-30', NULL UNION ALL 
        SELECT 4190, 'Yamagata',110,0,NULL,1, 'JP-06', NULL UNION ALL 
        SELECT 4191, 'Yamaguti',110,0,NULL,1, 'JP-35', NULL UNION ALL 
        SELECT 4192, 'Yamanasi',110,0,NULL,1, 'JP-19', NULL UNION ALL 
        SELECT 4193, 'Ôita',110,0,NULL,1, 'JP-44', NULL UNION ALL 
        SELECT 4194, 'Ôsaka',110,0,NULL,1, 'JP-27', NULL UNION ALL 
        SELECT 4195, 'Batken',118,0,NULL,1, 'KG-B', NULL UNION ALL 
        SELECT 4196, 'Bishkek',118,0,NULL,1, 'KG-GB', NULL UNION ALL 
        SELECT 4197, 'Chüy',118,0,NULL,1, 'KG-C', NULL UNION ALL 
        SELECT 4198, 'Jalal-Abad',118,0,NULL,1, 'KG-J', NULL UNION ALL 
        SELECT 4199, 'Naryn',118,0,NULL,1, 'KG-N', NULL UNION ALL 
        SELECT 4200, 'Osh',118,0,NULL,1, 'KG-GO', NULL UNION ALL 
        SELECT 4201, 'Osh',118,0,NULL,1, 'KG-O', NULL UNION ALL 
        SELECT 4202, 'Talas',118,0,NULL,1, 'KG-T', NULL UNION ALL 
        SELECT 4203, 'Ysyk-Köl',118,0,NULL,1, 'KG-Y', NULL UNION ALL 
        SELECT 4204, 'Berea',122,0,NULL,1, 'LS-D', NULL UNION ALL 
        SELECT 4205, 'Butha-Buthe',122,0,NULL,1, 'LS-B', NULL UNION ALL 
        SELECT 4206, 'Leribe',122,0,NULL,1, 'LS-C', NULL UNION ALL 
        SELECT 4207, 'Mafeteng',122,0,NULL,1, 'LS-E', NULL UNION ALL 
        SELECT 4208, 'Maseru',122,0,NULL,1, 'LS-A', NULL UNION ALL 
        SELECT 4209, 'Mohale''s Hoek',122,0,NULL,1, 'LS-F', NULL UNION ALL 
        SELECT 4210, 'Mokhotlong',122,0,NULL,1, 'LS-J', NULL UNION ALL 
        SELECT 4211, 'Qacha''s Nek',122,0,NULL,1, 'LS-H', NULL UNION ALL 
        SELECT 4212, 'Quthing',122,0,NULL,1, 'LS-G', NULL UNION ALL 
        SELECT 4213, 'Thaba-Tseka',122,0,NULL,1, 'LS-K', NULL UNION ALL 
        SELECT 4214, 'Diekrech',127,0,NULL,1, 'LU-DI', NULL UNION ALL 
        SELECT 4215, 'Esch-Uelzecht',127,0,NULL,1, 'LU-ES', NULL UNION ALL 
        SELECT 4216, 'Gréivemaacher',127,0,NULL,1, 'LU-GR', NULL UNION ALL 
        SELECT 4217, 'Iechternach',127,0,NULL,1, 'LU-EC', NULL UNION ALL 
        SELECT 4218, 'Kapellen',127,0,NULL,1, 'LU-CA', NULL UNION ALL 
        SELECT 4219, 'Klierf',127,0,NULL,1, 'LU-CL', NULL UNION ALL 
        SELECT 4220, 'Lëtzebuerg',127,0,NULL,1, 'LU-LU', NULL UNION ALL 
        SELECT 4221, 'Miersch',127,0,NULL,1, 'LU-ME', NULL UNION ALL 
        SELECT 4222, 'Réiden-Atert',127,0,NULL,1, 'LU-RD', NULL UNION ALL 
        SELECT 4223, 'Réimech',127,0,NULL,1, 'LU-RM', NULL UNION ALL 
        SELECT 4224, 'Veianen',127,0,NULL,1, 'LU-VD', NULL UNION ALL 
        SELECT 4225, 'Wolz',127,0,NULL,1, 'LU-WI', NULL UNION ALL 
        SELECT 4226, 'Balaka',130,0,NULL,1, 'MW-BA', 'MW-S' UNION ALL 
        SELECT 4227, 'Blantyre',130,0,NULL,1, 'MW-BL', 'MW-S' UNION ALL 
        SELECT 4228, 'Central Region',130,0,NULL,1, 'MW-C', NULL UNION ALL 
        SELECT 4229, 'Chikwawa',130,0,NULL,1, 'MW-CK', 'MW-S' UNION ALL 
        SELECT 4230, 'Chiradzulu',130,0,NULL,1, 'MW-CR', 'MW-S' UNION ALL 
        SELECT 4231, 'Chitipa',130,0,NULL,1, 'MW-CT', 'MW-N' UNION ALL 
        SELECT 4232, 'Dedza',130,0,NULL,1, 'MW-DE', 'MW-C' UNION ALL 
        SELECT 4233, 'Dowa',130,0,NULL,1, 'MW-DO', 'MW-C' UNION ALL 
        SELECT 4234, 'Karonga',130,0,NULL,1, 'MW-KR', 'MW-N' UNION ALL 
        SELECT 4235, 'Kasungu',130,0,NULL,1, 'MW-KS', 'MW-C' UNION ALL 
        SELECT 4236, 'Likoma',130,0,NULL,1, 'MW-LK', 'MW-N' UNION ALL 
        SELECT 4237, 'Lilongwe',130,0,NULL,1, 'MW-LI', 'MW-C' UNION ALL 
        SELECT 4238, 'Machinga',130,0,NULL,1, 'MW-MH', 'MW-S' UNION ALL 
        SELECT 4239, 'Mangochi',130,0,NULL,1, 'MW-MG', 'MW-S' UNION ALL 
        SELECT 4240, 'Mchinji',130,0,NULL,1, 'MW-MC', 'MW-C' UNION ALL 
        SELECT 4241, 'Mulanje',130,0,NULL,1, 'MW-MU', 'MW-S' UNION ALL 
        SELECT 4242, 'Mwanza',130,0,NULL,1, 'MW-MW', 'MW-S' UNION ALL 
        SELECT 4243, 'Mzimba',130,0,NULL,1, 'MW-MZ', 'MW-N' UNION ALL 
        SELECT 4244, 'Neno',130,0,NULL,1, 'MW-NE', 'MW-S' UNION ALL 
        SELECT 4245, 'Nkhata Bay',130,0,NULL,1, 'MW-NB', 'MW-N' UNION ALL 
        SELECT 4246, 'Nkhotakota',130,0,NULL,1, 'MW-NK', 'MW-C' UNION ALL 
        SELECT 4247, 'Northern Region',130,0,NULL,1, 'MW-N', NULL UNION ALL 
        SELECT 4248, 'Nsanje',130,0,NULL,1, 'MW-NS', 'MW-S' UNION ALL 
        SELECT 4249, 'Ntcheu',130,0,NULL,1, 'MW-NU', 'MW-C' UNION ALL 
        SELECT 4250, 'Ntchisi',130,0,NULL,1, 'MW-NI', 'MW-C' UNION ALL 
        SELECT 4251, 'Phalombe',130,0,NULL,1, 'MW-PH', 'MW-S' UNION ALL 
        SELECT 4252, 'Rumphi',130,0,NULL,1, 'MW-RU', 'MW-N' UNION ALL 
        SELECT 4253, 'Salima',130,0,NULL,1, 'MW-SA', 'MW-C' UNION ALL 
        SELECT 4254, 'Southern Region',130,0,NULL,1, 'MW-S', NULL UNION ALL 
        SELECT 4255, 'Thyolo',130,0,NULL,1, 'MW-TH', 'MW-S' UNION ALL 
        SELECT 4256, 'Zomba',130,0,NULL,1, 'MW-ZO', 'MW-S' UNION ALL 
        SELECT 4257, 'Addu City',132,0,NULL,1, 'MV-01', NULL UNION ALL 
        SELECT 4258, 'Faadhippolhu',132,0,NULL,1, 'MV-03', NULL UNION ALL 
        SELECT 4259, 'Felidhu Atoll',132,0,NULL,1, 'MV-04', NULL UNION ALL 
        SELECT 4260, 'Fuvammulah',132,0,NULL,1, 'MV-29', NULL UNION ALL 
        SELECT 4261, 'Hahdhunmathi',132,0,NULL,1, 'MV-05', NULL UNION ALL 
        SELECT 4262, 'Kolhumadulu',132,0,NULL,1, 'MV-08', NULL UNION ALL 
        SELECT 4263, 'Male',132,0,NULL,1, 'MV-MLE', NULL UNION ALL 
        SELECT 4264, 'Male Atoll',132,0,NULL,1, 'MV-26', NULL UNION ALL 
        SELECT 4265, 'Mulaku Atoll',132,0,NULL,1, 'MV-12', NULL UNION ALL 
        SELECT 4266, 'North Ari Atoll',132,0,NULL,1, 'MV-02', NULL UNION ALL 
        SELECT 4267, 'North Huvadhu Atoll',132,0,NULL,1, 'MV-27', NULL UNION ALL 
        SELECT 4268, 'North Maalhosmadulu',132,0,NULL,1, 'MV-13', NULL UNION ALL 
        SELECT 4269, 'North Miladhunmadulu',132,0,NULL,1, 'MV-24', NULL UNION ALL 
        SELECT 4270, 'North Nilandhe Atoll',132,0,NULL,1, 'MV-14', NULL UNION ALL 
        SELECT 4271, 'North Thiladhunmathi',132,0,NULL,1, 'MV-07', NULL UNION ALL 
        SELECT 4272, 'South Ari Atoll',132,0,NULL,1, 'MV-00', NULL UNION ALL 
        SELECT 4273, 'South Huvadhu Atoll',132,0,NULL,1, 'MV-28', NULL UNION ALL 
        SELECT 4274, 'South Maalhosmadulu',132,0,NULL,1, 'MV-20', NULL UNION ALL 
        SELECT 4275, 'South Miladhunmadulu',132,0,NULL,1, 'MV-25', NULL UNION ALL 
        SELECT 4276, 'South Nilandhe Atoll',132,0,NULL,1, 'MV-17', NULL UNION ALL 
        SELECT 4277, 'South Thiladhunmathi',132,0,NULL,1, 'MV-23', NULL UNION ALL 
        SELECT 4278, 'Attard',134,0,NULL,1, 'MT-01', NULL UNION ALL 
        SELECT 4279, 'Balzan',134,0,NULL,1, 'MT-02', NULL UNION ALL 
        SELECT 4280, 'Birgu',134,0,NULL,1, 'MT-03', NULL UNION ALL 
        SELECT 4281, 'Birkirkara',134,0,NULL,1, 'MT-04', NULL UNION ALL 
        SELECT 4282, 'Birzebbuga',134,0,NULL,1, 'MT-05', NULL UNION ALL 
        SELECT 4283, 'Bormla',134,0,NULL,1, 'MT-06', NULL UNION ALL 
        SELECT 4284, 'Dingli',134,0,NULL,1, 'MT-07', NULL UNION ALL 
        SELECT 4285, 'Fgura',134,0,NULL,1, 'MT-08', NULL UNION ALL 
        SELECT 4286, 'Floriana',134,0,NULL,1, 'MT-09', NULL UNION ALL 
        SELECT 4287, 'Fontana',134,0,NULL,1, 'MT-10', NULL UNION ALL 
        SELECT 4288, 'Gudja',134,0,NULL,1, 'MT-11', NULL UNION ALL 
        SELECT 4289, 'Ghajnsielem',134,0,NULL,1, 'MT-13', NULL UNION ALL 
        SELECT 4290, 'Gharb',134,0,NULL,1, 'MT-14', NULL UNION ALL 
        SELECT 4291, 'Gharghur',134,0,NULL,1, 'MT-15', NULL UNION ALL 
        SELECT 4292, 'Ghasri',134,0,NULL,1, 'MT-16', NULL UNION ALL 
        SELECT 4293, 'Ghaxaq',134,0,NULL,1, 'MT-17', NULL UNION ALL 
        SELECT 4294, 'Gzira',134,0,NULL,1, 'MT-12', NULL UNION ALL 
        SELECT 4295, 'Iklin',134,0,NULL,1, 'MT-19', NULL UNION ALL 
        SELECT 4296, 'Isla',134,0,NULL,1, 'MT-20', NULL UNION ALL 
        SELECT 4297, 'Kalkara',134,0,NULL,1, 'MT-21', NULL UNION ALL 
        SELECT 4298, 'Kercem',134,0,NULL,1, 'MT-22', NULL UNION ALL 
        SELECT 4299, 'Kirkop',134,0,NULL,1, 'MT-23', NULL UNION ALL 
        SELECT 4300, 'Lija',134,0,NULL,1, 'MT-24', NULL UNION ALL 
        SELECT 4301, 'Luqa',134,0,NULL,1, 'MT-25', NULL UNION ALL 
        SELECT 4302, 'Marsa',134,0,NULL,1, 'MT-26', NULL UNION ALL 
        SELECT 4303, 'Marsaskala',134,0,NULL,1, 'MT-27', NULL UNION ALL 
        SELECT 4304, 'Marsaxlokk',134,0,NULL,1, 'MT-28', NULL UNION ALL 
        SELECT 4305, 'Mdina',134,0,NULL,1, 'MT-29', NULL UNION ALL 
        SELECT 4306, 'Mellieha',134,0,NULL,1, 'MT-30', NULL UNION ALL 
        SELECT 4307, 'Mosta',134,0,NULL,1, 'MT-32', NULL UNION ALL 
        SELECT 4308, 'Mqabba',134,0,NULL,1, 'MT-33', NULL UNION ALL 
        SELECT 4309, 'Msida',134,0,NULL,1, 'MT-34', NULL UNION ALL 
        SELECT 4310, 'Mtarfa',134,0,NULL,1, 'MT-35', NULL UNION ALL 
        SELECT 4311, 'Munxar',134,0,NULL,1, 'MT-36', NULL UNION ALL 
        SELECT 4312, 'Mgarr',134,0,NULL,1, 'MT-31', NULL UNION ALL 
        SELECT 4313, 'Nadur',134,0,NULL,1, 'MT-37', NULL UNION ALL 
        SELECT 4314, 'Naxxar',134,0,NULL,1, 'MT-38', NULL UNION ALL 
        SELECT 4315, 'Paola',134,0,NULL,1, 'MT-39', NULL UNION ALL 
        SELECT 4316, 'Pembroke',134,0,NULL,1, 'MT-40', NULL UNION ALL 
        SELECT 4317, 'Pietà',134,0,NULL,1, 'MT-41', NULL UNION ALL 
        SELECT 4318, 'Qala',134,0,NULL,1, 'MT-42', NULL UNION ALL 
        SELECT 4319, 'Qormi',134,0,NULL,1, 'MT-43', NULL UNION ALL 
        SELECT 4320, 'Qrendi',134,0,NULL,1, 'MT-44', NULL UNION ALL 
        SELECT 4321, 'Rabat Gozo',134,0,NULL,1, 'MT-45', NULL UNION ALL 
        SELECT 4322, 'Rabat Malta',134,0,NULL,1, 'MT-46', NULL UNION ALL 
        SELECT 4323, 'Safi',134,0,NULL,1, 'MT-47', NULL UNION ALL 
        SELECT 4324, 'Saint John',134,0,NULL,1, 'MT-49', NULL UNION ALL 
        SELECT 4325, 'Saint Julian''s',134,0,NULL,1, 'MT-48', NULL UNION ALL 
        SELECT 4326, 'Saint Lawrence',134,0,NULL,1, 'MT-50', NULL UNION ALL 
        SELECT 4327, 'Saint Lucia''s',134,0,NULL,1, 'MT-53', NULL UNION ALL 
        SELECT 4328, 'Saint Paul''s Bay',134,0,NULL,1, 'MT-51', NULL UNION ALL 
        SELECT 4329, 'Sannat',134,0,NULL,1, 'MT-52', NULL UNION ALL 
        SELECT 4330, 'Santa Venera',134,0,NULL,1, 'MT-54', NULL UNION ALL 
        SELECT 4331, 'Siggiewi',134,0,NULL,1, 'MT-55', NULL UNION ALL 
        SELECT 4332, 'Sliema',134,0,NULL,1, 'MT-56', NULL UNION ALL 
        SELECT 4333, 'Swieqi',134,0,NULL,1, 'MT-57', NULL UNION ALL 
        SELECT 4334, 'Ta'' Xbiex',134,0,NULL,1, 'MT-58', NULL UNION ALL 
        SELECT 4335, 'Tarxien',134,0,NULL,1, 'MT-59', NULL UNION ALL 
        SELECT 4336, 'Valletta',134,0,NULL,1, 'MT-60', NULL UNION ALL 
        SELECT 4337, 'Xaghra',134,0,NULL,1, 'MT-61', NULL UNION ALL 
        SELECT 4338, 'Xewkija',134,0,NULL,1, 'MT-62', NULL UNION ALL 
        SELECT 4339, 'Xghajra',134,0,NULL,1, 'MT-63', NULL UNION ALL 
        SELECT 4340, 'Hamrun',134,0,NULL,1, 'MT-18', NULL UNION ALL 
        SELECT 4341, 'Zabbar',134,0,NULL,1, 'MT-64', NULL UNION ALL 
        SELECT 4342, 'Zebbug Gozo',134,0,NULL,1, 'MT-65', NULL UNION ALL 
        SELECT 4343, 'Zebbug Malta',134,0,NULL,1, 'MT-66', NULL UNION ALL 
        SELECT 4344, 'Zejtun',134,0,NULL,1, 'MT-67', NULL UNION ALL 
        SELECT 4345, 'Zurrieq',134,0,NULL,1, 'MT-68', NULL UNION ALL 
        SELECT 4346, 'Ailinglaplap',135,0,NULL,1, 'MH-ALL', 'MH-L' UNION ALL 
        SELECT 4347, 'Ailuk',135,0,NULL,1, 'MH-ALK', 'MH-T' UNION ALL 
        SELECT 4348, 'Arno',135,0,NULL,1, 'MH-ARN', 'MH-T' UNION ALL 
        SELECT 4349, 'Aur',135,0,NULL,1, 'MH-AUR', 'MH-T' UNION ALL 
        SELECT 4350, 'Bikini & Kili',135,0,NULL,1, 'MH-KIL', 'MH-L' UNION ALL 
        SELECT 4351, 'Ebon',135,0,NULL,1, 'MH-EBO', 'MH-L' UNION ALL 
        SELECT 4352, 'Enewetak & Ujelang',135,0,NULL,1, 'MH-ENI', 'MH-L' UNION ALL 
        SELECT 4353, 'Jabat',135,0,NULL,1, 'MH-JAB', 'MH-L' UNION ALL 
        SELECT 4354, 'Jaluit',135,0,NULL,1, 'MH-JAL', 'MH-L' UNION ALL 
        SELECT 4355, 'Kwajalein',135,0,NULL,1, 'MH-KWA', 'MH-L' UNION ALL 
        SELECT 4356, 'Lae',135,0,NULL,1, 'MH-LAE', 'MH-L' UNION ALL 
        SELECT 4357, 'Lib',135,0,NULL,1, 'MH-LIB', 'MH-L' UNION ALL 
        SELECT 4358, 'Likiep',135,0,NULL,1, 'MH-LIK', 'MH-T' UNION ALL 
        SELECT 4359, 'Majuro',135,0,NULL,1, 'MH-MAJ', 'MH-T' UNION ALL 
        SELECT 4360, 'Maloelap',135,0,NULL,1, 'MH-MAL', 'MH-T' UNION ALL 
        SELECT 4361, 'Mejit',135,0,NULL,1, 'MH-MEJ', 'MH-T' UNION ALL 
        SELECT 4362, 'Mili',135,0,NULL,1, 'MH-MIL', 'MH-T' UNION ALL 
        SELECT 4363, 'Namdrik',135,0,NULL,1, 'MH-NMK', 'MH-L' UNION ALL 
        SELECT 4364, 'Namu',135,0,NULL,1, 'MH-NMU', 'MH-L' UNION ALL 
        SELECT 4365, 'Ralik chain',135,0,NULL,1, 'MH-L', NULL UNION ALL 
        SELECT 4366, 'Ratak chain',135,0,NULL,1, 'MH-T', NULL UNION ALL 
        SELECT 4367, 'Rongelap',135,0,NULL,1, 'MH-RON', 'MH-L' UNION ALL 
        SELECT 4368, 'Ujae',135,0,NULL,1, 'MH-UJA', 'MH-L' UNION ALL 
        SELECT 4369, 'Utrik',135,0,NULL,1, 'MH-UTI', 'MH-T' UNION ALL 
        SELECT 4370, 'Wotho',135,0,NULL,1, 'MH-WTH', 'MH-L' UNION ALL 
        SELECT 4371, 'Wotje',135,0,NULL,1, 'MH-WTJ', 'MH-T' UNION ALL 
        SELECT 4372, 'Adrar',137,0,NULL,1, 'MR-07', NULL UNION ALL 
        SELECT 4373, 'Assaba',137,0,NULL,1, 'MR-03', NULL UNION ALL 
        SELECT 4374, 'Brakna',137,0,NULL,1, 'MR-05', NULL UNION ALL 
        SELECT 4375, 'Dakhlet Nouâdhibou',137,0,NULL,1, 'MR-08', NULL UNION ALL 
        SELECT 4376, 'Gorgol',137,0,NULL,1, 'MR-04', NULL UNION ALL 
        SELECT 4377, 'Guidimaka',137,0,NULL,1, 'MR-10', NULL UNION ALL 
        SELECT 4378, 'Hodh ech Chargui',137,0,NULL,1, 'MR-01', NULL UNION ALL 
        SELECT 4379, 'Hodh el Gharbi',137,0,NULL,1, 'MR-02', NULL UNION ALL 
        SELECT 4380, 'Inchiri',137,0,NULL,1, 'MR-12', NULL UNION ALL 
        SELECT 4381, 'Nuwakshut al Gharbiyah',137,0,NULL,1, 'MR-13', NULL UNION ALL 
        SELECT 4382, 'Nuwakshut al Janubiyah',137,0,NULL,1, 'MR-15', NULL UNION ALL 
        SELECT 4383, 'Nuwakshut ash Shamaliyah',137,0,NULL,1, 'MR-14', NULL UNION ALL 
        SELECT 4384, 'Tagant',137,0,NULL,1, 'MR-09', NULL UNION ALL 
        SELECT 4385, 'Tiris Zemmour',137,0,NULL,1, 'MR-11', NULL UNION ALL 
        SELECT 4386, 'Trarza',137,0,NULL,1, 'MR-06', NULL UNION ALL 
        SELECT 4387, 'Aiwo',150,0,NULL,1, 'NR-01', NULL UNION ALL 
        SELECT 4388, 'Anabar',150,0,NULL,1, 'NR-02', NULL UNION ALL 
        SELECT 4389, 'Anetan',150,0,NULL,1, 'NR-03', NULL UNION ALL 
        SELECT 4390, 'Anibare',150,0,NULL,1, 'NR-04', NULL UNION ALL 
        SELECT 4391, 'Baitsi',150,0,NULL,1, 'NR-05', NULL UNION ALL 
        SELECT 4392, 'Boe',150,0,NULL,1, 'NR-06', NULL UNION ALL 
        SELECT 4393, 'Buada',150,0,NULL,1, 'NR-07', NULL UNION ALL 
        SELECT 4394, 'Denigomodu',150,0,NULL,1, 'NR-08', NULL UNION ALL 
        SELECT 4395, 'Ewa',150,0,NULL,1, 'NR-09', NULL UNION ALL 
        SELECT 4396, 'Ijuw',150,0,NULL,1, 'NR-10', NULL UNION ALL 
        SELECT 4397, 'Meneng',150,0,NULL,1, 'NR-11', NULL UNION ALL 
        SELECT 4398, 'Nibok',150,0,NULL,1, 'NR-12', NULL UNION ALL 
        SELECT 4399, 'Uaboe',150,0,NULL,1, 'NR-13', NULL UNION ALL 
        SELECT 4400, 'Yaren',150,0,NULL,1, 'NR-14', NULL UNION ALL 
        SELECT 4401, 'Bagmati',151,0,NULL,1, 'NP-BA', 'NP-1' UNION ALL 
        SELECT 4402, 'Bheri',151,0,NULL,1, 'NP-BH', 'NP-2' UNION ALL 
        SELECT 4403, 'Dhawalagiri',151,0,NULL,1, 'NP-DH', 'NP-3' UNION ALL 
        SELECT 4404, 'Gandaki',151,0,NULL,1, 'NP-GA', 'NP-3' UNION ALL 
        SELECT 4405, 'Gandaki',151,0,NULL,1, 'NP-P4', NULL UNION ALL 
        SELECT 4406, 'Janakpur',151,0,NULL,1, 'NP-JA', 'NP-1' UNION ALL 
        SELECT 4407, 'Karnali',151,0,NULL,1, 'NP-KA', 'NP-2' UNION ALL 
        SELECT 4408, 'Karnali',151,0,NULL,1, 'NP-P6', NULL UNION ALL 
        SELECT 4409, 'Kosi',151,0,NULL,1, 'NP-KO', 'NP-4' UNION ALL 
        SELECT 4410, 'Lumbini',151,0,NULL,1, 'NP-LU', 'NP-3' UNION ALL 
        SELECT 4411, 'Madhya Pashchimanchal',151,0,NULL,1, 'NP-2', NULL UNION ALL 
        SELECT 4412, 'Madhyamanchal',151,0,NULL,1, 'NP-1', NULL UNION ALL 
        SELECT 4413, 'Mahakali',151,0,NULL,1, 'NP-MA', 'NP-5' UNION ALL 
        SELECT 4414, 'Mechi',151,0,NULL,1, 'NP-ME', 'NP-4' UNION ALL 
        SELECT 4415, 'Narayani',151,0,NULL,1, 'NP-NA', 'NP-1' UNION ALL 
        SELECT 4416, 'Pashchimanchal',151,0,NULL,1, 'NP-3', NULL UNION ALL 
        SELECT 4417, 'Pradesh 1',151,0,NULL,1, 'NP-P1', NULL UNION ALL 
        SELECT 4418, 'Pradesh 2',151,0,NULL,1, 'NP-P2', NULL UNION ALL 
        SELECT 4419, 'Pradesh 3',151,0,NULL,1, 'NP-P3', NULL UNION ALL 
        SELECT 4420, 'Pradesh 5',151,0,NULL,1, 'NP-P5', NULL UNION ALL 
        SELECT 4421, 'Pradesh 7',151,0,NULL,1, 'NP-P7', NULL UNION ALL 
        SELECT 4422, 'Purwanchal',151,0,NULL,1, 'NP-4', NULL UNION ALL 
        SELECT 4423, 'Rapti',151,0,NULL,1, 'NP-RA', 'NP-2' UNION ALL 
        SELECT 4424, 'Sagarmatha',151,0,NULL,1, 'NP-SA', 'NP-4' UNION ALL 
        SELECT 4425, 'Seti',151,0,NULL,1, 'NP-SE', 'NP-5' UNION ALL 
        SELECT 4426, 'Sudur Pashchimanchal',151,0,NULL,1, 'NP-5', NULL UNION ALL 
        SELECT 4427, 'Akershus',162,0,NULL,1, 'NO-02', NULL UNION ALL 
        SELECT 4428, 'Aust-Agder',162,0,NULL,1, 'NO-09', NULL UNION ALL 
        SELECT 4429, 'Buskerud',162,0,NULL,1, 'NO-06', NULL UNION ALL 
        SELECT 4430, 'Finnmark',162,0,NULL,1, 'NO-20', NULL UNION ALL 
        SELECT 4431, 'Hedmark',162,0,NULL,1, 'NO-04', NULL UNION ALL 
        SELECT 4432, 'Hordaland',162,0,NULL,1, 'NO-12', NULL UNION ALL 
        SELECT 4433, 'Jan Mayen (Arctic Region)',162,0,NULL,1, 'NO-22', NULL UNION ALL 
        SELECT 4434, 'Møre og Romsdal',162,0,NULL,1, 'NO-15', NULL UNION ALL 
        SELECT 4435, 'Nordland',162,0,NULL,1, 'NO-18', NULL UNION ALL 
        SELECT 4436, 'Oppland',162,0,NULL,1, 'NO-05', NULL UNION ALL 
        SELECT 4437, 'Oslo',162,0,NULL,1, 'NO-03', NULL UNION ALL 
        SELECT 4438, 'Rogaland',162,0,NULL,1, 'NO-11', NULL UNION ALL 
        SELECT 4439, 'Sogn og Fjordane',162,0,NULL,1, 'NO-14', NULL UNION ALL 
        SELECT 4440, 'Svalbard (Arctic Region)',162,0,NULL,1, 'NO-21', NULL UNION ALL 
        SELECT 4441, 'Telemark',162,0,NULL,1, 'NO-08', NULL UNION ALL 
        SELECT 4442, 'Troms',162,0,NULL,1, 'NO-19', NULL UNION ALL 
        SELECT 4443, 'Trøndelag',162,0,NULL,1, 'NO-50', NULL UNION ALL 
        SELECT 4444, 'Vest-Agder',162,0,NULL,1, 'NO-10', NULL UNION ALL 
        SELECT 4445, 'Vestfold',162,0,NULL,1, 'NO-07', NULL UNION ALL 
        SELECT 4446, 'Østfold',162,0,NULL,1, 'NO-01', NULL UNION ALL 
        SELECT 4447, 'Azad Jammu and Kashmir',164,0,NULL,1, 'PK-JK', NULL UNION ALL 
        SELECT 4448, 'Balochistan',164,0,NULL,1, 'PK-BA', NULL UNION ALL 
        SELECT 4449, 'Gilgit-Baltistan',164,0,NULL,1, 'PK-GB', NULL UNION ALL 
        SELECT 4450, 'Islamabad',164,0,NULL,1, 'PK-IS', NULL UNION ALL 
        SELECT 4451, 'Khyber Pakhtunkhwa',164,0,NULL,1, 'PK-KP', NULL UNION ALL 
        SELECT 4452, 'Punjab',164,0,NULL,1, 'PK-PB', NULL UNION ALL 
        SELECT 4453, 'Sindh',164,0,NULL,1, 'PK-SD', NULL UNION ALL 
        SELECT 4454, 'Aimeliik',165,0,NULL,1, 'PW-002', NULL UNION ALL 
        SELECT 4455, 'Airai',165,0,NULL,1, 'PW-004', NULL UNION ALL 
        SELECT 4456, 'Angaur',165,0,NULL,1, 'PW-010', NULL UNION ALL 
        SELECT 4457, 'Hatohobei',165,0,NULL,1, 'PW-050', NULL UNION ALL 
        SELECT 4458, 'Kayangel',165,0,NULL,1, 'PW-100', NULL UNION ALL 
        SELECT 4459, 'Koror',165,0,NULL,1, 'PW-150', NULL UNION ALL 
        SELECT 4460, 'Melekeok',165,0,NULL,1, 'PW-212', NULL UNION ALL 
        SELECT 4461, 'Ngaraard',165,0,NULL,1, 'PW-214', NULL UNION ALL 
        SELECT 4462, 'Ngarchelong',165,0,NULL,1, 'PW-218', NULL UNION ALL 
        SELECT 4463, 'Ngardmau',165,0,NULL,1, 'PW-222', NULL UNION ALL 
        SELECT 4464, 'Ngatpang',165,0,NULL,1, 'PW-224', NULL UNION ALL 
        SELECT 4465, 'Ngchesar',165,0,NULL,1, 'PW-226', NULL UNION ALL 
        SELECT 4466, 'Ngeremlengui',165,0,NULL,1, 'PW-227', NULL UNION ALL 
        SELECT 4467, 'Ngiwal',165,0,NULL,1, 'PW-228', NULL UNION ALL 
        SELECT 4468, 'Peleliu',165,0,NULL,1, 'PW-350', NULL UNION ALL 
        SELECT 4469, 'Sonsorol',165,0,NULL,1, 'PW-370', NULL UNION ALL 
        SELECT 4470, 'Amazonas',169,0,NULL,1, 'PE-AMA', NULL UNION ALL 
        SELECT 4471, 'Ancash',169,0,NULL,1, 'PE-ANC', NULL UNION ALL 
        SELECT 4472, 'Apurímac',169,0,NULL,1, 'PE-APU', NULL UNION ALL 
        SELECT 4473, 'Arequipa',169,0,NULL,1, 'PE-ARE', NULL UNION ALL 
        SELECT 4474, 'Ayacucho',169,0,NULL,1, 'PE-AYA', NULL UNION ALL 
        SELECT 4475, 'Cajamarca',169,0,NULL,1, 'PE-CAJ', NULL UNION ALL 
        SELECT 4476, 'Cusco',169,0,NULL,1, 'PE-CUS', NULL UNION ALL 
        SELECT 4477, 'El Callao',169,0,NULL,1, 'PE-CAL', NULL UNION ALL 
        SELECT 4478, 'Huancavelica',169,0,NULL,1, 'PE-HUV', NULL UNION ALL 
        SELECT 4479, 'Huánuco',169,0,NULL,1, 'PE-HUC', NULL UNION ALL 
        SELECT 4480, 'Ica',169,0,NULL,1, 'PE-ICA', NULL UNION ALL 
        SELECT 4481, 'Junín',169,0,NULL,1, 'PE-JUN', NULL UNION ALL 
        SELECT 4482, 'La Libertad',169,0,NULL,1, 'PE-LAL', NULL UNION ALL 
        SELECT 4483, 'Lambayeque',169,0,NULL,1, 'PE-LAM', NULL UNION ALL 
        SELECT 4484, 'Lima',169,0,NULL,1, 'PE-LIM', NULL UNION ALL 
        SELECT 4485, 'Loreto',169,0,NULL,1, 'PE-LOR', NULL UNION ALL 
        SELECT 4486, 'Madre de Dios',169,0,NULL,1, 'PE-MDD', NULL UNION ALL 
        SELECT 4487, 'Moquegua',169,0,NULL,1, 'PE-MOQ', NULL UNION ALL 
        SELECT 4488, 'Municipalidad Metropolitana de Lima',169,0,NULL,1, 'PE-LMA', NULL UNION ALL 
        SELECT 4489, 'Pasco',169,0,NULL,1, 'PE-PAS', NULL UNION ALL 
        SELECT 4490, 'Piura',169,0,NULL,1, 'PE-PIU', NULL UNION ALL 
        SELECT 4491, 'Puno',169,0,NULL,1, 'PE-PUN', NULL UNION ALL 
        SELECT 4492, 'San Martín',169,0,NULL,1, 'PE-SAM', NULL UNION ALL 
        SELECT 4493, 'Tacna',169,0,NULL,1, 'PE-TAC', NULL UNION ALL 
        SELECT 4494, 'Tumbes',169,0,NULL,1, 'PE-TUM', NULL UNION ALL 
        SELECT 4495, 'Ucayali',169,0,NULL,1, 'PE-UCA', NULL UNION ALL 
        SELECT 4496, 'Abra',170,0,NULL,1, 'PH-ABR', 'PH-15' UNION ALL 
        SELECT 4497, 'Agusan del Norte',170,0,NULL,1, 'PH-AGN', 'PH-13' UNION ALL 
        SELECT 4498, 'Agusan del Sur',170,0,NULL,1, 'PH-AGS', 'PH-13' UNION ALL 
        SELECT 4499, 'Aklan',170,0,NULL,1, 'PH-AKL', 'PH-06' UNION ALL 
        SELECT 4500, 'Albay',170,0,NULL,1, 'PH-ALB', 'PH-05' UNION ALL 
        SELECT 4501, 'Antique',170,0,NULL,1, 'PH-ANT', 'PH-06' UNION ALL 
        SELECT 4502, 'Apayao',170,0,NULL,1, 'PH-APA', 'PH-15' UNION ALL 
        SELECT 4503, 'Aurora',170,0,NULL,1, 'PH-AUR', 'PH-03' UNION ALL 
        SELECT 4504, 'Autonomous Region in Muslim Mindanao (ARMM)',170,0,NULL,1, 'PH-14', NULL UNION ALL 
        SELECT 4505, 'Basilan',170,0,NULL,1, 'PH-BAS', 'PH-09' UNION ALL 
        SELECT 4506, 'Bataan',170,0,NULL,1, 'PH-BAN', 'PH-03' UNION ALL 
        SELECT 4507, 'Batanes',170,0,NULL,1, 'PH-BTN', 'PH-02' UNION ALL 
        SELECT 4508, 'Batangas',170,0,NULL,1, 'PH-BTG', 'PH-40' UNION ALL 
        SELECT 4509, 'Benguet',170,0,NULL,1, 'PH-BEN', 'PH-15' UNION ALL 
        SELECT 4510, 'Bicol (Region V)',170,0,NULL,1, 'PH-05', NULL UNION ALL 
        SELECT 4511, 'Biliran',170,0,NULL,1, 'PH-BIL', 'PH-08' UNION ALL 
        SELECT 4512, 'Bohol',170,0,NULL,1, 'PH-BOH', 'PH-07' UNION ALL 
        SELECT 4513, 'Bukidnon',170,0,NULL,1, 'PH-BUK', 'PH-10' UNION ALL 
        SELECT 4514, 'Bulacan',170,0,NULL,1, 'PH-BUL', 'PH-03' UNION ALL 
        SELECT 4515, 'Cagayan',170,0,NULL,1, 'PH-CAG', 'PH-02' UNION ALL 
        SELECT 4516, 'Cagayan Valley (Region II)',170,0,NULL,1, 'PH-02', NULL UNION ALL 
        SELECT 4517, 'Calabarzon (Region IV-A)',170,0,NULL,1, 'PH-40', NULL UNION ALL 
        SELECT 4518, 'Camarines Norte',170,0,NULL,1, 'PH-CAN', 'PH-05' UNION ALL 
        SELECT 4519, 'Camarines Sur',170,0,NULL,1, 'PH-CAS', 'PH-05' UNION ALL 
        SELECT 4520, 'Camiguin',170,0,NULL,1, 'PH-CAM', 'PH-10' UNION ALL 
        SELECT 4521, 'Capiz',170,0,NULL,1, 'PH-CAP', 'PH-06' UNION ALL 
        SELECT 4522, 'Caraga (Region XIII)',170,0,NULL,1, 'PH-13', NULL UNION ALL 
        SELECT 4523, 'Catanduanes',170,0,NULL,1, 'PH-CAT', 'PH-05' UNION ALL 
        SELECT 4524, 'Cavite',170,0,NULL,1, 'PH-CAV', 'PH-40' UNION ALL 
        SELECT 4525, 'Cebu',170,0,NULL,1, 'PH-CEB', 'PH-07' UNION ALL 
        SELECT 4526, 'Central Luzon (Region III)',170,0,NULL,1, 'PH-03', NULL UNION ALL 
        SELECT 4527, 'Central Visayas (Region VII)',170,0,NULL,1, 'PH-07', NULL UNION ALL 
        SELECT 4528, 'Compostela Valley',170,0,NULL,1, 'PH-COM', 'PH-11' UNION ALL 
        SELECT 4529, 'Cordillera Administrative Region (CAR)',170,0,NULL,1, 'PH-15', NULL UNION ALL 
        SELECT 4530, 'Cotabato',170,0,NULL,1, 'PH-NCO', 'PH-12' UNION ALL 
        SELECT 4531, 'Davao (Region XI)',170,0,NULL,1, 'PH-11', NULL UNION ALL 
        SELECT 4532, 'Davao Occidental',170,0,NULL,1, 'PH-DVO', 'PH-11' UNION ALL 
        SELECT 4533, 'Davao Oriental',170,0,NULL,1, 'PH-DAO', 'PH-11' UNION ALL 
        SELECT 4534, 'Davao del Norte',170,0,NULL,1, 'PH-DAV', 'PH-11' UNION ALL 
        SELECT 4535, 'Davao del Sur',170,0,NULL,1, 'PH-DAS', 'PH-11' UNION ALL 
        SELECT 4536, 'Dinagat Islands',170,0,NULL,1, 'PH-DIN', 'PH-13' UNION ALL 
        SELECT 4537, 'Eastern Samar',170,0,NULL,1, 'PH-EAS', 'PH-08' UNION ALL 
        SELECT 4538, 'Eastern Visayas (Region VIII)',170,0,NULL,1, 'PH-08', NULL UNION ALL 
        SELECT 4539, 'Guimaras',170,0,NULL,1, 'PH-GUI', 'PH-06' UNION ALL 
        SELECT 4540, 'Ifugao',170,0,NULL,1, 'PH-IFU', 'PH-15' UNION ALL 
        SELECT 4541, 'Ilocos (Region I)',170,0,NULL,1, 'PH-01', NULL UNION ALL 
        SELECT 4542, 'Ilocos Norte',170,0,NULL,1, 'PH-ILN', 'PH-01' UNION ALL 
        SELECT 4543, 'Ilocos Sur',170,0,NULL,1, 'PH-ILS', 'PH-01' UNION ALL 
        SELECT 4544, 'Iloilo',170,0,NULL,1, 'PH-ILI', 'PH-06' UNION ALL 
        SELECT 4545, 'Isabela',170,0,NULL,1, 'PH-ISA', 'PH-02' UNION ALL 
        SELECT 4546, 'Kalinga',170,0,NULL,1, 'PH-KAL', 'PH-15' UNION ALL 
        SELECT 4547, 'La Union',170,0,NULL,1, 'PH-LUN', 'PH-01' UNION ALL 
        SELECT 4548, 'Laguna',170,0,NULL,1, 'PH-LAG', 'PH-40' UNION ALL 
        SELECT 4549, 'Lanao del Norte',170,0,NULL,1, 'PH-LAN', 'PH-12' UNION ALL 
        SELECT 4550, 'Lanao del Sur',170,0,NULL,1, 'PH-LAS', 'PH-14' UNION ALL 
        SELECT 4551, 'Leyte',170,0,NULL,1, 'PH-LEY', 'PH-08' UNION ALL 
        SELECT 4552, 'Maguindanao',170,0,NULL,1, 'PH-MAG', 'PH-14' UNION ALL 
        SELECT 4553, 'Marinduque',170,0,NULL,1, 'PH-MAD', 'PH-41' UNION ALL 
        SELECT 4554, 'Masbate',170,0,NULL,1, 'PH-MAS', 'PH-05' UNION ALL 
        SELECT 4555, 'Mimaropa (Region IV-B)',170,0,NULL,1, 'PH-41', NULL UNION ALL 
        SELECT 4556, 'Mindoro Occidental',170,0,NULL,1, 'PH-MDC', 'PH-41' UNION ALL 
        SELECT 4557, 'Mindoro Oriental',170,0,NULL,1, 'PH-MDR', 'PH-41' UNION ALL 
        SELECT 4558, 'Misamis Occidental',170,0,NULL,1, 'PH-MSC', 'PH-10' UNION ALL 
        SELECT 4559, 'Misamis Oriental',170,0,NULL,1, 'PH-MSR', 'PH-10' UNION ALL 
        SELECT 4560, 'Mountain Province',170,0,NULL,1, 'PH-MOU', 'PH-15' UNION ALL 
        SELECT 4561, 'National Capital Region',170,0,NULL,1, 'PH-00', NULL UNION ALL 
        SELECT 4562, 'Negros Occidental',170,0,NULL,1, 'PH-NEC', 'PH-06' UNION ALL 
        SELECT 4563, 'Negros Oriental',170,0,NULL,1, 'PH-NER', 'PH-07' UNION ALL 
        SELECT 4564, 'Northern Mindanao (Region X)',170,0,NULL,1, 'PH-10', NULL UNION ALL 
        SELECT 4565, 'Northern Samar',170,0,NULL,1, 'PH-NSA', 'PH-08' UNION ALL 
        SELECT 4566, 'Nueva Ecija',170,0,NULL,1, 'PH-NUE', 'PH-03' UNION ALL 
        SELECT 4567, 'Nueva Vizcaya',170,0,NULL,1, 'PH-NUV', 'PH-02' UNION ALL 
        SELECT 4568, 'Palawan',170,0,NULL,1, 'PH-PLW', 'PH-41' UNION ALL 
        SELECT 4569, 'Pampanga',170,0,NULL,1, 'PH-PAM', 'PH-03' UNION ALL 
        SELECT 4570, 'Pangasinan',170,0,NULL,1, 'PH-PAN', 'PH-01' UNION ALL 
        SELECT 4571, 'Quezon',170,0,NULL,1, 'PH-QUE', 'PH-40' UNION ALL 
        SELECT 4572, 'Quirino',170,0,NULL,1, 'PH-QUI', 'PH-02' UNION ALL 
        SELECT 4573, 'Rizal',170,0,NULL,1, 'PH-RIZ', 'PH-40' UNION ALL 
        SELECT 4574, 'Romblon',170,0,NULL,1, 'PH-ROM', 'PH-41' UNION ALL 
        SELECT 4575, 'Samar',170,0,NULL,1, 'PH-WSA', 'PH-08' UNION ALL 
        SELECT 4576, 'Sarangani',170,0,NULL,1, 'PH-SAR', 'PH-11' UNION ALL 
        SELECT 4577, 'Siquijor',170,0,NULL,1, 'PH-SIG', 'PH-07' UNION ALL 
        SELECT 4578, 'Soccsksargen (Region XII)',170,0,NULL,1, 'PH-12', NULL UNION ALL 
        SELECT 4579, 'Sorsogon',170,0,NULL,1, 'PH-SOR', 'PH-05' UNION ALL 
        SELECT 4580, 'South Cotabato',170,0,NULL,1, 'PH-SCO', 'PH-11' UNION ALL 
        SELECT 4581, 'Southern Leyte',170,0,NULL,1, 'PH-SLE', 'PH-08' UNION ALL 
        SELECT 4582, 'Sultan Kudarat',170,0,NULL,1, 'PH-SUK', 'PH-12' UNION ALL 
        SELECT 4583, 'Sulu',170,0,NULL,1, 'PH-SLU', 'PH-14' UNION ALL 
        SELECT 4584, 'Surigao del Norte',170,0,NULL,1, 'PH-SUN', 'PH-13' UNION ALL 
        SELECT 4585, 'Surigao del Sur',170,0,NULL,1, 'PH-SUR', 'PH-13' UNION ALL 
        SELECT 4586, 'Tarlac',170,0,NULL,1, 'PH-TAR', 'PH-03' UNION ALL 
        SELECT 4587, 'Tawi-Tawi',170,0,NULL,1, 'PH-TAW', 'PH-14' UNION ALL 
        SELECT 4588, 'Western Visayas (Region VI)',170,0,NULL,1, 'PH-06', NULL UNION ALL 
        SELECT 4589, 'Zambales',170,0,NULL,1, 'PH-ZMB', 'PH-03' UNION ALL 
        SELECT 4590, 'Zamboanga Peninsula (Region IX)',170,0,NULL,1, 'PH-09', NULL UNION ALL 
        SELECT 4591, 'Zamboanga Sibugay',170,0,NULL,1, 'PH-ZSI', 'PH-09' UNION ALL 
        SELECT 4592, 'Zamboanga del Norte',170,0,NULL,1, 'PH-ZAN', 'PH-09' UNION ALL 
        SELECT 4593, 'Zamboanga del Sur',170,0,NULL,1, 'PH-ZAS', 'PH-09' UNION ALL 
        SELECT 4594, 'City of Kigali',179,0,NULL,1, 'RW-01', NULL UNION ALL 
        SELECT 4595, 'Eastern',179,0,NULL,1, 'RW-02', NULL UNION ALL 
        SELECT 4596, 'Northern',179,0,NULL,1, 'RW-03', NULL UNION ALL 
        SELECT 4597, 'Southern',179,0,NULL,1, 'RW-05', NULL UNION ALL 
        SELECT 4598, 'Western',179,0,NULL,1, 'RW-04', NULL UNION ALL 
        SELECT 4599, 'A''ana',185,0,NULL,1, 'WS-AA', NULL UNION ALL 
        SELECT 4600, 'Aiga-i-le-Tai',185,0,NULL,1, 'WS-AL', NULL UNION ALL 
        SELECT 4601, 'Atua',185,0,NULL,1, 'WS-AT', NULL UNION ALL 
        SELECT 4602, 'Fa''asaleleaga',185,0,NULL,1, 'WS-FA', NULL UNION ALL 
        SELECT 4603, 'Gaga''emauga',185,0,NULL,1, 'WS-GE', NULL UNION ALL 
        SELECT 4604, 'Gagaifomauga',185,0,NULL,1, 'WS-GI', NULL UNION ALL 
        SELECT 4605, 'Palauli',185,0,NULL,1, 'WS-PA', NULL UNION ALL 
        SELECT 4606, 'Satupa''itea',185,0,NULL,1, 'WS-SA', NULL UNION ALL 
        SELECT 4607, 'Tuamasaga',185,0,NULL,1, 'WS-TU', NULL UNION ALL 
        SELECT 4608, 'Va''a-o-Fonoti',185,0,NULL,1, 'WS-VF', NULL UNION ALL 
        SELECT 4609, 'Vaisigano',185,0,NULL,1, 'WS-VS', NULL UNION ALL 
        SELECT 4610, 'Anse Boileau',190,0,NULL,1, 'SC-02', NULL UNION ALL 
        SELECT 4611, 'Anse Etoile',190,0,NULL,1, 'SC-03', NULL UNION ALL 
        SELECT 4612, 'Anse Royale',190,0,NULL,1, 'SC-05', NULL UNION ALL 
        SELECT 4613, 'Anse aux Pins',190,0,NULL,1, 'SC-01', NULL UNION ALL 
        SELECT 4614, 'Au Cap',190,0,NULL,1, 'SC-04', NULL UNION ALL 
        SELECT 4615, 'Baie Lazare',190,0,NULL,1, 'SC-06', NULL UNION ALL 
        SELECT 4616, 'Baie Sainte Anne',190,0,NULL,1, 'SC-07', NULL UNION ALL 
        SELECT 4617, 'Beau Vallon',190,0,NULL,1, 'SC-08', NULL UNION ALL 
        SELECT 4618, 'Bel Air',190,0,NULL,1, 'SC-09', NULL UNION ALL 
        SELECT 4619, 'Bel Ombre',190,0,NULL,1, 'SC-10', NULL UNION ALL 
        SELECT 4620, 'Cascade',190,0,NULL,1, 'SC-11', NULL UNION ALL 
        SELECT 4621, 'English River',190,0,NULL,1, 'SC-16', NULL UNION ALL 
        SELECT 4622, 'Glacis',190,0,NULL,1, 'SC-12', NULL UNION ALL 
        SELECT 4623, 'Grand Anse Mahe',190,0,NULL,1, 'SC-13', NULL UNION ALL 
        SELECT 4624, 'Grand Anse Praslin',190,0,NULL,1, 'SC-14', NULL UNION ALL 
        SELECT 4625, 'La Digue',190,0,NULL,1, 'SC-15', NULL UNION ALL 
        SELECT 4626, 'Les Mamelles',190,0,NULL,1, 'SC-24', NULL UNION ALL 
        SELECT 4627, 'Mont Buxton',190,0,NULL,1, 'SC-17', NULL UNION ALL 
        SELECT 4628, 'Mont Fleuri',190,0,NULL,1, 'SC-18', NULL UNION ALL 
        SELECT 4629, 'Plaisance',190,0,NULL,1, 'SC-19', NULL UNION ALL 
        SELECT 4630, 'Pointe Larue',190,0,NULL,1, 'SC-20', NULL UNION ALL 
        SELECT 4631, 'Port Glaud',190,0,NULL,1, 'SC-21', NULL UNION ALL 
        SELECT 4632, 'Roche Caiman',190,0,NULL,1, 'SC-25', NULL UNION ALL 
        SELECT 4633, 'Saint Louis',190,0,NULL,1, 'SC-22', NULL UNION ALL 
        SELECT 4634, 'Takamaka',190,0,NULL,1, 'SC-23', NULL UNION ALL 
        SELECT 4635, 'Eastern Cape',197,0,NULL,1, 'ZA-EC', NULL UNION ALL 
        SELECT 4636, 'Free State',197,0,NULL,1, 'ZA-FS', NULL UNION ALL 
        SELECT 4637, 'Gauteng',197,0,NULL,1, 'ZA-GP', NULL UNION ALL 
        SELECT 4638, 'Kwazulu-Natal',197,0,NULL,1, 'ZA-KZN', NULL UNION ALL 
        SELECT 4639, 'Limpopo',197,0,NULL,1, 'ZA-LP', NULL UNION ALL 
        SELECT 4640, 'Mpumalanga',197,0,NULL,1, 'ZA-MP', NULL UNION ALL 
        SELECT 4641, 'North-West',197,0,NULL,1, 'ZA-NW', NULL UNION ALL 
        SELECT 4642, 'Northern Cape',197,0,NULL,1, 'ZA-NC', NULL UNION ALL 
        SELECT 4643, 'Western Cape',197,0,NULL,1, 'ZA-WC', NULL UNION ALL 
        SELECT 4644, 'Ampara',200,0,NULL,1, 'LK-52', 'LK-5' UNION ALL 
        SELECT 4645, 'Anuradhapura',200,0,NULL,1, 'LK-71', 'LK-7' UNION ALL 
        SELECT 4646, 'Badulla',200,0,NULL,1, 'LK-81', 'LK-8' UNION ALL 
        SELECT 4647, 'Batticaloa',200,0,NULL,1, 'LK-51', 'LK-5' UNION ALL 
        SELECT 4648, 'Central Province',200,0,NULL,1, 'LK-2', NULL UNION ALL 
        SELECT 4649, 'Colombo',200,0,NULL,1, 'LK-11', 'LK-1' UNION ALL 
        SELECT 4650, 'Eastern Province',200,0,NULL,1, 'LK-5', NULL UNION ALL 
        SELECT 4651, 'Galle',200,0,NULL,1, 'LK-31', 'LK-3' UNION ALL 
        SELECT 4652, 'Gampaha',200,0,NULL,1, 'LK-12', 'LK-1' UNION ALL 
        SELECT 4653, 'Hambantota',200,0,NULL,1, 'LK-33', 'LK-3' UNION ALL 
        SELECT 4654, 'Jaffna',200,0,NULL,1, 'LK-41', 'LK-4' UNION ALL 
        SELECT 4655, 'Kalutara',200,0,NULL,1, 'LK-13', 'LK-1' UNION ALL 
        SELECT 4656, 'Kandy',200,0,NULL,1, 'LK-21', 'LK-2' UNION ALL 
        SELECT 4657, 'Kegalla',200,0,NULL,1, 'LK-92', 'LK-9' UNION ALL 
        SELECT 4658, 'Kilinochchi',200,0,NULL,1, 'LK-42', 'LK-4' UNION ALL 
        SELECT 4659, 'Kurunegala',200,0,NULL,1, 'LK-61', 'LK-6' UNION ALL 
        SELECT 4660, 'Mannar',200,0,NULL,1, 'LK-43', 'LK-4' UNION ALL 
        SELECT 4661, 'Matale',200,0,NULL,1, 'LK-22', 'LK-2' UNION ALL 
        SELECT 4662, 'Matara',200,0,NULL,1, 'LK-32', 'LK-3' UNION ALL 
        SELECT 4663, 'Monaragala',200,0,NULL,1, 'LK-82', 'LK-8' UNION ALL 
        SELECT 4664, 'Mullaittivu',200,0,NULL,1, 'LK-45', 'LK-4' UNION ALL 
        SELECT 4665, 'North Central Province',200,0,NULL,1, 'LK-7', NULL UNION ALL 
        SELECT 4666, 'North Western Province',200,0,NULL,1, 'LK-6', NULL UNION ALL 
        SELECT 4667, 'Northern Province',200,0,NULL,1, 'LK-4', NULL UNION ALL 
        SELECT 4668, 'Nuwara Eliya',200,0,NULL,1, 'LK-23', 'LK-2' UNION ALL 
        SELECT 4669, 'Polonnaruwa',200,0,NULL,1, 'LK-72', 'LK-7' UNION ALL 
        SELECT 4670, 'Puttalam',200,0,NULL,1, 'LK-62', 'LK-6' UNION ALL 
        SELECT 4671, 'Ratnapura',200,0,NULL,1, 'LK-91', 'LK-9' UNION ALL 
        SELECT 4672, 'Sabaragamuwa Province',200,0,NULL,1, 'LK-9', NULL UNION ALL 
        SELECT 4673, 'Southern Province',200,0,NULL,1, 'LK-3', NULL UNION ALL 
        SELECT 4674, 'Trincomalee',200,0,NULL,1, 'LK-53', 'LK-5' UNION ALL 
        SELECT 4675, 'Uva Province',200,0,NULL,1, 'LK-8', NULL UNION ALL 
        SELECT 4676, 'Vavuniya',200,0,NULL,1, 'LK-44', 'LK-4' UNION ALL 
        SELECT 4677, 'Western Province',200,0,NULL,1, 'LK-1', NULL UNION ALL 
        SELECT 4678, 'Blue Nile',201,0,NULL,1, 'SD-NB', NULL UNION ALL 
        SELECT 4679, 'Central Darfur',201,0,NULL,1, 'SD-DC', NULL UNION ALL 
        SELECT 4680, 'East Darfur',201,0,NULL,1, 'SD-DE', NULL UNION ALL 
        SELECT 4681, 'Gedaref',201,0,NULL,1, 'SD-GD', NULL UNION ALL 
        SELECT 4682, 'Gezira',201,0,NULL,1, 'SD-GZ', NULL UNION ALL 
        SELECT 4683, 'Kassala',201,0,NULL,1, 'SD-KA', NULL UNION ALL 
        SELECT 4684, 'Khartoum',201,0,NULL,1, 'SD-KH', NULL UNION ALL 
        SELECT 4685, 'North Darfur',201,0,NULL,1, 'SD-DN', NULL UNION ALL 
        SELECT 4686, 'North Kordofan',201,0,NULL,1, 'SD-KN', NULL UNION ALL 
        SELECT 4687, 'Northern',201,0,NULL,1, 'SD-NO', NULL UNION ALL 
        SELECT 4688, 'Red Sea',201,0,NULL,1, 'SD-RS', NULL UNION ALL 
        SELECT 4689, 'River Nile',201,0,NULL,1, 'SD-NR', NULL UNION ALL 
        SELECT 4690, 'Sennar',201,0,NULL,1, 'SD-SI', NULL UNION ALL 
        SELECT 4691, 'South Darfur',201,0,NULL,1, 'SD-DS', NULL UNION ALL 
        SELECT 4692, 'South Kordofan',201,0,NULL,1, 'SD-KS', NULL UNION ALL 
        SELECT 4693, 'West Darfur',201,0,NULL,1, 'SD-DW', NULL UNION ALL 
        SELECT 4694, 'West Kordofan',201,0,NULL,1, 'SD-GK', NULL UNION ALL 
        SELECT 4695, 'White Nile',201,0,NULL,1, 'SD-NW', NULL UNION ALL 
        SELECT 4696, 'Hhohho',204,0,NULL,1, 'SZ-HH', NULL UNION ALL 
        SELECT 4697, 'Lubombo',204,0,NULL,1, 'SZ-LU', NULL UNION ALL 
        SELECT 4698, 'Manzini',204,0,NULL,1, 'SZ-MA', NULL UNION ALL 
        SELECT 4699, 'Shiselweni',204,0,NULL,1, 'SZ-SH', NULL UNION ALL 
        SELECT 4700, 'Arusha',210,0,NULL,1, 'TZ-01', NULL UNION ALL 
        SELECT 4701, 'Dar es Salaam',210,0,NULL,1, 'TZ-02', NULL UNION ALL 
        SELECT 4702, 'Dodoma',210,0,NULL,1, 'TZ-03', NULL UNION ALL 
        SELECT 4703, 'Geita',210,0,NULL,1, 'TZ-27', NULL UNION ALL 
        SELECT 4704, 'Iringa',210,0,NULL,1, 'TZ-04', NULL UNION ALL 
        SELECT 4705, 'Kagera',210,0,NULL,1, 'TZ-05', NULL UNION ALL 
        SELECT 4706, 'Kaskazini Pemba',210,0,NULL,1, 'TZ-06', NULL UNION ALL 
        SELECT 4707, 'Kaskazini Unguja',210,0,NULL,1, 'TZ-07', NULL UNION ALL 
        SELECT 4708, 'Katavi',210,0,NULL,1, 'TZ-28', NULL UNION ALL 
        SELECT 4709, 'Kigoma',210,0,NULL,1, 'TZ-08', NULL UNION ALL 
        SELECT 4710, 'Kilimanjaro',210,0,NULL,1, 'TZ-09', NULL UNION ALL 
        SELECT 4711, 'Kusini Pemba',210,0,NULL,1, 'TZ-10', NULL UNION ALL 
        SELECT 4712, 'Kusini Unguja',210,0,NULL,1, 'TZ-11', NULL UNION ALL 
        SELECT 4713, 'Lindi',210,0,NULL,1, 'TZ-12', NULL UNION ALL 
        SELECT 4714, 'Manyara',210,0,NULL,1, 'TZ-26', NULL UNION ALL 
        SELECT 4715, 'Mara',210,0,NULL,1, 'TZ-13', NULL UNION ALL 
        SELECT 4716, 'Mbeya',210,0,NULL,1, 'TZ-14', NULL UNION ALL 
        SELECT 4717, 'Mjini Magharibi',210,0,NULL,1, 'TZ-15', NULL UNION ALL 
        SELECT 4718, 'Morogoro',210,0,NULL,1, 'TZ-16', NULL UNION ALL 
        SELECT 4719, 'Mtwara',210,0,NULL,1, 'TZ-17', NULL UNION ALL 
        SELECT 4720, 'Mwanza',210,0,NULL,1, 'TZ-18', NULL UNION ALL 
        SELECT 4721, 'Njombe',210,0,NULL,1, 'TZ-29', NULL UNION ALL 
        SELECT 4722, 'Pwani',210,0,NULL,1, 'TZ-19', NULL UNION ALL 
        SELECT 4723, 'Rukwa',210,0,NULL,1, 'TZ-20', NULL UNION ALL 
        SELECT 4724, 'Ruvuma',210,0,NULL,1, 'TZ-21', NULL UNION ALL 
        SELECT 4725, 'Shinyanga',210,0,NULL,1, 'TZ-22', NULL UNION ALL 
        SELECT 4726, 'Simiyu',210,0,NULL,1, 'TZ-30', NULL UNION ALL 
        SELECT 4727, 'Singida',210,0,NULL,1, 'TZ-23', NULL UNION ALL 
        SELECT 4728, 'Songwe',210,0,NULL,1, 'TZ-31', NULL UNION ALL 
        SELECT 4729, 'Tabora',210,0,NULL,1, 'TZ-24', NULL UNION ALL 
        SELECT 4730, 'Tanga',210,0,NULL,1, 'TZ-25', NULL UNION ALL 
        SELECT 4731, '''Eua',214,0,NULL,1, 'TO-01', NULL UNION ALL 
        SELECT 4732, 'Ha''apai',214,0,NULL,1, 'TO-02', NULL UNION ALL 
        SELECT 4733, 'Niuas',214,0,NULL,1, 'TO-03', NULL UNION ALL 
        SELECT 4734, 'Tongatapu',214,0,NULL,1, 'TO-04', NULL UNION ALL 
        SELECT 4735, 'Vava''u',214,0,NULL,1, 'TO-05', NULL UNION ALL 
        SELECT 4736, 'Malampa',227,0,NULL,1, 'VU-MAP', NULL UNION ALL 
        SELECT 4737, 'Pénama',227,0,NULL,1, 'VU-PAM', NULL UNION ALL 
        SELECT 4738, 'Sanma',227,0,NULL,1, 'VU-SAM', NULL UNION ALL 
        SELECT 4739, 'Shéfa',227,0,NULL,1, 'VU-SEE', NULL UNION ALL 
        SELECT 4740, 'Taféa',227,0,NULL,1, 'VU-TAE', NULL UNION ALL 
        SELECT 4741, 'Torba',227,0,NULL,1, 'VU-TOB', NULL UNION ALL 
        SELECT 4742, 'Bethlehem',255,0,NULL,1, 'PS-BTH', NULL UNION ALL 
        SELECT 4743, 'Deir El Balah',255,0,NULL,1, 'PS-DEB', NULL UNION ALL 
        SELECT 4744, 'Gaza',255,0,NULL,1, 'PS-GZA', NULL UNION ALL 
        SELECT 4745, 'Hebron',255,0,NULL,1, 'PS-HBN', NULL UNION ALL 
        SELECT 4746, 'Jenin',255,0,NULL,1, 'PS-JEN', NULL UNION ALL 
        SELECT 4747, 'Jericho and Al Aghwar',255,0,NULL,1, 'PS-JRH', NULL UNION ALL 
        SELECT 4748, 'Jerusalem',255,0,NULL,1, 'PS-JEM', NULL UNION ALL 
        SELECT 4749, 'Khan Yunis',255,0,NULL,1, 'PS-KYS', NULL UNION ALL 
        SELECT 4750, 'Nablus',255,0,NULL,1, 'PS-NBS', NULL UNION ALL 
        SELECT 4751, 'North Gaza',255,0,NULL,1, 'PS-NGZ', NULL UNION ALL 
        SELECT 4752, 'Qalqilya',255,0,NULL,1, 'PS-QQA', NULL UNION ALL 
        SELECT 4753, 'Rafah',255,0,NULL,1, 'PS-RFH', NULL UNION ALL 
        SELECT 4754, 'Ramallah',255,0,NULL,1, 'PS-RBH', NULL UNION ALL 
        SELECT 4755, 'Salfit',255,0,NULL,1, 'PS-SLT', NULL UNION ALL 
        SELECT 4756, 'Tubas',255,0,NULL,1, 'PS-TBS', NULL UNION ALL 
        SELECT 4757, 'Tulkarm',255,0,NULL,1, 'PS-TKM', NULL UNION ALL 
        SELECT 4758, 'Bonaire',260,0,NULL,1, 'BQ-BO', NULL UNION ALL 
        SELECT 4759, 'Saba',260,0,NULL,1, 'BQ-SA', NULL UNION ALL 
        SELECT 4760, 'Sint Eustatius',260,0,NULL,1, 'BQ-SE', NULL UNION ALL 
        SELECT 4761, 'Brestskaya oblast''',22,0,NULL,1, 'BY-BR', NULL UNION ALL 
        SELECT 4762, 'Gomel''skaya oblast''',22,0,NULL,1, 'BY-HO', NULL UNION ALL 
        SELECT 4763, 'Gorod Minsk',22,0,NULL,1, 'BY-HM', NULL UNION ALL 
        SELECT 4764, 'Grodnenskaya oblast''',22,0,NULL,1, 'BY-HR', NULL UNION ALL 
        SELECT 4765, 'Minskaya oblast''',22,0,NULL,1, 'BY-MI', NULL UNION ALL 
        SELECT 4766, 'Mogilevskaya oblast''',22,0,NULL,1, 'BY-MA', NULL UNION ALL 
        SELECT 4767, 'Vitebskaya oblast''',22,0,NULL,1, 'BY-VI', NULL UNION ALL 
        SELECT 4768, 'Bruxelles-Capitale, Région de',23,0,NULL,1, 'BE-BRU', NULL UNION ALL 
        SELECT 4769, 'Antwerpen',23,0,NULL,1, 'BE-VAN', 'BE-VLG' UNION ALL 
        SELECT 4770, 'Vlaams-Brabant',23,0,NULL,1, 'BE-VBR', 'BE-VLG' UNION ALL 
        SELECT 4771, 'Vlaams Gewest',23,0,NULL,1, 'BE-VLG', NULL UNION ALL 
        SELECT 4772, 'Limburg',23,0,NULL,1, 'BE-VLI', 'BE-VLG' UNION ALL 
        SELECT 4773, 'Oost-Vlaanderen',23,0,NULL,1, 'BE-VOV', 'BE-VLG' UNION ALL 
        SELECT 4774, 'West-Vlaanderen',23,0,NULL,1, 'BE-VWV', 'BE-VLG' UNION ALL 
        SELECT 4775, 'wallonne, Région',23,0,NULL,1, 'BE-WAL', NULL UNION ALL 
        SELECT 4776, 'Brabant wallon',23,0,NULL,1, 'BE-WBR', 'BE-WAL' UNION ALL 
        SELECT 4777, 'Hainaut',23,0,NULL,1, 'BE-WHT', 'BE-WAL' UNION ALL 
        SELECT 4778, 'Liège',23,0,NULL,1, 'BE-WLG', 'BE-WAL' UNION ALL 
        SELECT 4779, 'Luxembourg',23,0,NULL,1, 'BE-WLX', 'BE-WAL' UNION ALL 
        SELECT 4780, 'Namur',23,0,NULL,1, 'BE-WNA', 'BE-WAL' UNION ALL 
        SELECT 4781, 'Bântéay Méanchey',38,0,NULL,1, 'KH-1', NULL UNION ALL 
        SELECT 4782, 'Batdâmbâng',38,0,NULL,1, 'KH-2', NULL UNION ALL 
        SELECT 4783, 'Kaôh Kong',38,0,NULL,1, 'KH-9', NULL UNION ALL 
        SELECT 4784, 'Krâchéh',38,0,NULL,1, 'KH-10', NULL UNION ALL 
        SELECT 4785, 'Kâmpóng Cham',38,0,NULL,1, 'KH-3', NULL UNION ALL 
        SELECT 4786, 'Kâmpóng Chhnang',38,0,NULL,1, 'KH-4', NULL UNION ALL 
        SELECT 4787, 'Kâmpóng Spœ',38,0,NULL,1, 'KH-5', NULL UNION ALL 
        SELECT 4788, 'Kâmpóng Thum',38,0,NULL,1, 'KH-6', NULL UNION ALL 
        SELECT 4789, 'Kâmpôt',38,0,NULL,1, 'KH-7', NULL UNION ALL 
        SELECT 4790, 'Kândal',38,0,NULL,1, 'KH-8', NULL UNION ALL 
        SELECT 4791, 'Kêb',38,0,NULL,1, 'KH-23', NULL UNION ALL 
        SELECT 4792, 'Môndól Kiri',38,0,NULL,1, 'KH-11', NULL UNION ALL 
        SELECT 4793, 'Pailin',38,0,NULL,1, 'KH-24', NULL UNION ALL 
        SELECT 4794, 'Phnum Pénh',38,0,NULL,1, 'KH-12', NULL UNION ALL 
        SELECT 4795, 'Pouthisat',38,0,NULL,1, 'KH-15', NULL UNION ALL 
        SELECT 4796, 'Prey Vêng',38,0,NULL,1, 'KH-14', NULL UNION ALL 
        SELECT 4797, 'Preah Sihanouk',38,0,NULL,1, 'KH-18', NULL UNION ALL 
        SELECT 4798, 'Preah Vihéar',38,0,NULL,1, 'KH-13', NULL UNION ALL 
        SELECT 4799, 'Rôtânôkiri',38,0,NULL,1, 'KH-16', NULL UNION ALL 
        SELECT 4800, 'Siemréab',38,0,NULL,1, 'KH-17', NULL UNION ALL 
        SELECT 4801, 'Stoeng Trêng',38,0,NULL,1, 'KH-19', NULL UNION ALL 
        SELECT 4802, 'Svay Rieng',38,0,NULL,1, 'KH-20', NULL UNION ALL 
        SELECT 4803, 'Takêv',38,0,NULL,1, 'KH-21', NULL UNION ALL 
        SELECT 4804, 'Tbong Khmum',38,0,NULL,1, 'KH-25', NULL UNION ALL 
        SELECT 4805, 'Otdâr Méanchey',38,0,NULL,1, 'KH-22', NULL UNION ALL 
        SELECT 4806, 'Andjazîdja',50,0,NULL,1, 'KM-G', NULL UNION ALL 
        SELECT 4807, 'Moûhîlî',50,0,NULL,1, 'KM-M', NULL UNION ALL 
        SELECT 4808, 'Andjouân',50,0,NULL,1, 'KM-A', NULL UNION ALL 
        SELECT 4809, 'Awbuk',60,0,NULL,1, 'DJ-OB', NULL UNION ALL 
        SELECT 4810, 'Dikhil',60,0,NULL,1, 'DJ-DI', NULL UNION ALL 
        SELECT 4811, 'Jibuti',60,0,NULL,1, 'DJ-DJ', NULL UNION ALL 
        SELECT 4812, 'Tajurah',60,0,NULL,1, 'DJ-TA', NULL UNION ALL 
        SELECT 4813, '‘Ali Sabi?',60,0,NULL,1, 'DJ-AS', NULL UNION ALL 
        SELECT 4814, '‘Arta',60,0,NULL,1, 'DJ-AR', NULL UNION ALL 
        SELECT 4815, 'Akmolinskaya oblast''',112,0,NULL,1, 'KZ-AKM', NULL UNION ALL 
        SELECT 4816, 'Aktyubinskaya oblast''',112,0,NULL,1, 'KZ-AKT', NULL UNION ALL 
        SELECT 4817, 'Almatinskaya oblast''',112,0,NULL,1, 'KZ-ALM', NULL UNION ALL 
        SELECT 4818, 'Almaty',112,0,NULL,1, 'KZ-ALA', NULL UNION ALL 
        SELECT 4819, 'Astana',112,0,NULL,1, 'KZ-AST', NULL UNION ALL 
        SELECT 4820, 'Atyrauskaya oblast''',112,0,NULL,1, 'KZ-ATY', NULL UNION ALL 
        SELECT 4821, 'Baykonyr',112,0,NULL,1, 'KZ-BAY', NULL UNION ALL 
        SELECT 4822, 'Karagandinskaya oblast''',112,0,NULL,1, 'KZ-KAR', NULL UNION ALL 
        SELECT 4823, 'Kostanayskaya oblast''',112,0,NULL,1, 'KZ-KUS', NULL UNION ALL 
        SELECT 4824, 'Kyzylordinskaya oblast''',112,0,NULL,1, 'KZ-KZY', NULL UNION ALL 
        SELECT 4825, 'Mangistauskaya oblast''',112,0,NULL,1, 'KZ-MAN', NULL UNION ALL 
        SELECT 4826, 'Pavlodarskaya oblast''',112,0,NULL,1, 'KZ-PAV', NULL UNION ALL 
        SELECT 4827, 'Severo-Kazakhstanskaya oblast''',112,0,NULL,1, 'KZ-SEV', NULL UNION ALL 
        SELECT 4828, 'Shymkent',112,0,NULL,1, 'KZ-SHY', NULL UNION ALL 
        SELECT 4829, 'Turkestankaya oblast''',112,0,NULL,1, 'KZ-YUZ', NULL UNION ALL 
        SELECT 4830, 'Vostochno-Kazakhstanskaya oblast''',112,0,NULL,1, 'KZ-VOS', NULL UNION ALL 
        SELECT 4831, 'Zapadno-Kazakhstanskaya oblast''',112,0,NULL,1, 'KZ-ZAP', NULL UNION ALL 
        SELECT 4832, 'Zhambylskaya oblast''',112,0,NULL,1, 'KZ-ZHA', NULL UNION ALL 
        SELECT 4833, 'Hamkyeongnamto',115,0,NULL,1, 'KP-08', NULL UNION ALL 
        SELECT 4834, 'Hamkyeongpukto',115,0,NULL,1, 'KP-09', NULL UNION ALL 
        SELECT 4835, 'Hwanghainamto',115,0,NULL,1, 'KP-05', NULL UNION ALL 
        SELECT 4836, 'Hwanghaipukto',115,0,NULL,1, 'KP-06', NULL UNION ALL 
        SELECT 4837, 'Jakangto',115,0,NULL,1, 'KP-04', NULL UNION ALL 
        SELECT 4838, 'Kangweonto',115,0,NULL,1, 'KP-07', NULL UNION ALL 
        SELECT 4839, 'Nampho',115,0,NULL,1, 'KP-14', NULL UNION ALL 
        SELECT 4840, 'Phyeongannamto',115,0,NULL,1, 'KP-02', NULL UNION ALL 
        SELECT 4841, 'Phyeonganpukto',115,0,NULL,1, 'KP-03', NULL UNION ALL 
        SELECT 4842, 'Phyeongyang',115,0,NULL,1, 'KP-01', NULL UNION ALL 
        SELECT 4843, 'Raseon',115,0,NULL,1, 'KP-13', NULL UNION ALL 
        SELECT 4844, 'Ryangkangto',115,0,NULL,1, 'KP-10', NULL UNION ALL 
        SELECT 4845, 'Al Biqa‘',121,0,NULL,1, 'LB-BI', NULL UNION ALL 
        SELECT 4846, 'Al Janub',121,0,NULL,1, 'LB-JA', NULL UNION ALL 
        SELECT 4847, 'An Nabatiyah',121,0,NULL,1, 'LB-NA', NULL UNION ALL 
        SELECT 4848, 'Ash Shimal',121,0,NULL,1, 'LB-AS', NULL UNION ALL 
        SELECT 4849, 'Bayrut',121,0,NULL,1, 'LB-BA', NULL UNION ALL 
        SELECT 4850, 'B‘alabak-Al Hirmil',121,0,NULL,1, 'LB-BH', NULL UNION ALL 
        SELECT 4851, 'Jabal Lubnan',121,0,NULL,1, 'LB-JL', NULL UNION ALL 
        SELECT 4852, '‘Akkar',121,0,NULL,1, 'LB-AK', NULL UNION ALL 
        SELECT 4853, 'Auckland',155,0,NULL,1, 'NZ-AUK', NULL UNION ALL 
        SELECT 4854, 'Bay of Plenty',155,0,NULL,1, 'NZ-BOP', NULL UNION ALL 
        SELECT 4855, 'Canterbury',155,0,NULL,1, 'NZ-CAN', NULL UNION ALL 
        SELECT 4856, 'Chatham Islands Territory',155,0,NULL,1, 'NZ-CIT', NULL UNION ALL 
        SELECT 4857, 'Gisborne',155,0,NULL,1, 'NZ-GIS', NULL UNION ALL 
        SELECT 4858, 'Hawke''s Bay',155,0,NULL,1, 'NZ-HKB', NULL UNION ALL 
        SELECT 4859, 'Manawatu-Wanganui',155,0,NULL,1, 'NZ-MWT', NULL UNION ALL 
        SELECT 4860, 'Marlborough',155,0,NULL,1, 'NZ-MBH', NULL UNION ALL 
        SELECT 4861, 'Nelson',155,0,NULL,1, 'NZ-NSN', NULL UNION ALL 
        SELECT 4862, 'Northland',155,0,NULL,1, 'NZ-NTL', NULL UNION ALL 
        SELECT 4863, 'Otago',155,0,NULL,1, 'NZ-OTA', NULL UNION ALL 
        SELECT 4864, 'Southland',155,0,NULL,1, 'NZ-STL', NULL UNION ALL 
        SELECT 4865, 'Taranaki',155,0,NULL,1, 'NZ-TKI', NULL UNION ALL 
        SELECT 4866, 'Tasman',155,0,NULL,1, 'NZ-TAS', NULL UNION ALL 
        SELECT 4867, 'Wellington',155,0,NULL,1, 'NZ-WGN', NULL UNION ALL 
        SELECT 4868, 'West Coast',155,0,NULL,1, 'NZ-WTC', NULL UNION ALL 
        SELECT 4869, 'Waikato',155,0,NULL,1, 'NZ-WKO', NULL UNION ALL 
        SELECT 4870, 'Adygeya, Respublika',178,0,NULL,1, 'RU-AD', NULL UNION ALL 
        SELECT 4871, 'Altay, Respublika',178,0,NULL,1, 'RU-AL', NULL UNION ALL 
        SELECT 4872, 'Altayskiy kray',178,0,NULL,1, 'RU-ALT', NULL UNION ALL 
        SELECT 4873, 'Amurskaya oblast''',178,0,NULL,1, 'RU-AMU', NULL UNION ALL 
        SELECT 4874, 'Arkhangel''skaya oblast''',178,0,NULL,1, 'RU-ARK', NULL UNION ALL 
        SELECT 4875, 'Astrakhanskaya oblast''',178,0,NULL,1, 'RU-AST', NULL UNION ALL 
        SELECT 4876, 'Bashkortostan, Respublika',178,0,NULL,1, 'RU-BA', NULL UNION ALL 
        SELECT 4877, 'Belgorodskaya oblast''',178,0,NULL,1, 'RU-BEL', NULL UNION ALL 
        SELECT 4878, 'Bryanskaya oblast''',178,0,NULL,1, 'RU-BRY', NULL UNION ALL 
        SELECT 4879, 'Buryatiya, Respublika',178,0,NULL,1, 'RU-BU', NULL UNION ALL 
        SELECT 4880, 'Chechenskaya Respublika',178,0,NULL,1, 'RU-CE', NULL UNION ALL 
        SELECT 4881, 'Chelyabinskaya oblast''',178,0,NULL,1, 'RU-CHE', NULL UNION ALL 
        SELECT 4882, 'Chukotskiy avtonomnyy okrug',178,0,NULL,1, 'RU-CHU', NULL UNION ALL 
        SELECT 4883, 'Chuvashskaya Respublika',178,0,NULL,1, 'RU-CU', NULL UNION ALL 
        SELECT 4884, 'Dagestan, Respublika',178,0,NULL,1, 'RU-DA', NULL UNION ALL 
        SELECT 4885, 'Ingushetiya, Respublika',178,0,NULL,1, 'RU-IN', NULL UNION ALL 
        SELECT 4886, 'Irkutskaya oblast''',178,0,NULL,1, 'RU-IRK', NULL UNION ALL 
        SELECT 4887, 'Ivanovskaya oblast''',178,0,NULL,1, 'RU-IVA', NULL UNION ALL 
        SELECT 4888, 'Kabardino-Balkarskaya Respublika',178,0,NULL,1, 'RU-KB', NULL UNION ALL 
        SELECT 4889, 'Kaliningradskaya oblast''',178,0,NULL,1, 'RU-KGD', NULL UNION ALL 
        SELECT 4890, 'Kalmykiya, Respublika',178,0,NULL,1, 'RU-KL', NULL UNION ALL 
        SELECT 4891, 'Kaluzhskaya oblast''',178,0,NULL,1, 'RU-KLU', NULL UNION ALL 
        SELECT 4892, 'Kamchatskiy kray',178,0,NULL,1, 'RU-KAM', NULL UNION ALL 
        SELECT 4893, 'Karachayevo-Cherkesskaya Respublika',178,0,NULL,1, 'RU-KC', NULL UNION ALL 
        SELECT 4894, 'Kareliya, Respublika',178,0,NULL,1, 'RU-KR', NULL UNION ALL 
        SELECT 4895, 'Kemerovskaya oblast''',178,0,NULL,1, 'RU-KEM', NULL UNION ALL 
        SELECT 4896, 'Khabarovskiy kray',178,0,NULL,1, 'RU-KHA', NULL UNION ALL 
        SELECT 4897, 'Khakasiya, Respublika',178,0,NULL,1, 'RU-KK', NULL UNION ALL 
        SELECT 4898, 'Khanty-Mansiyskiy avtonomnyy okrug',178,0,NULL,1, 'RU-KHM', NULL UNION ALL 
        SELECT 4899, 'Kirovskaya oblast''',178,0,NULL,1, 'RU-KIR', NULL UNION ALL 
        SELECT 4900, 'Komi, Respublika',178,0,NULL,1, 'RU-KO', NULL UNION ALL 
        SELECT 4901, 'Kostromskaya oblast''',178,0,NULL,1, 'RU-KOS', NULL UNION ALL 
        SELECT 4902, 'Krasnodarskiy kray',178,0,NULL,1, 'RU-KDA', NULL UNION ALL 
        SELECT 4903, 'Krasnoyarskiy kray',178,0,NULL,1, 'RU-KYA', NULL UNION ALL 
        SELECT 4904, 'Kurganskaya oblast''',178,0,NULL,1, 'RU-KGN', NULL UNION ALL 
        SELECT 4905, 'Kurskaya oblast''',178,0,NULL,1, 'RU-KRS', NULL UNION ALL 
        SELECT 4906, 'Leningradskaya oblast''',178,0,NULL,1, 'RU-LEN', NULL UNION ALL 
        SELECT 4907, 'Lipetskaya oblast''',178,0,NULL,1, 'RU-LIP', NULL UNION ALL 
        SELECT 4908, 'Magadanskaya oblast''',178,0,NULL,1, 'RU-MAG', NULL UNION ALL 
        SELECT 4909, 'Mariy El, Respublika',178,0,NULL,1, 'RU-ME', NULL UNION ALL 
        SELECT 4910, 'Mordoviya, Respublika',178,0,NULL,1, 'RU-MO', NULL UNION ALL 
        SELECT 4911, 'Moskovskaya oblast''',178,0,NULL,1, 'RU-MOS', NULL UNION ALL 
        SELECT 4912, 'Moskva',178,0,NULL,1, 'RU-MOW', NULL UNION ALL 
        SELECT 4913, 'Murmanskaya oblast''',178,0,NULL,1, 'RU-MUR', NULL UNION ALL 
        SELECT 4914, 'Nenetskiy avtonomnyy okrug',178,0,NULL,1, 'RU-NEN', NULL UNION ALL 
        SELECT 4915, 'Nizhegorodskaya oblast''',178,0,NULL,1, 'RU-NIZ', NULL UNION ALL 
        SELECT 4916, 'Novgorodskaya oblast''',178,0,NULL,1, 'RU-NGR', NULL UNION ALL 
        SELECT 4917, 'Novosibirskaya oblast''',178,0,NULL,1, 'RU-NVS', NULL UNION ALL 
        SELECT 4918, 'Omskaya oblast''',178,0,NULL,1, 'RU-OMS', NULL UNION ALL 
        SELECT 4919, 'Orenburgskaya oblast''',178,0,NULL,1, 'RU-ORE', NULL UNION ALL 
        SELECT 4920, 'Orlovskaya oblast''',178,0,NULL,1, 'RU-ORL', NULL UNION ALL 
        SELECT 4921, 'Penzenskaya oblast''',178,0,NULL,1, 'RU-PNZ', NULL UNION ALL 
        SELECT 4922, 'Permskiy kray',178,0,NULL,1, 'RU-PER', NULL UNION ALL 
        SELECT 4923, 'Primorskiy kray',178,0,NULL,1, 'RU-PRI', NULL UNION ALL 
        SELECT 4924, 'Pskovskaya oblast''',178,0,NULL,1, 'RU-PSK', NULL UNION ALL 
        SELECT 4925, 'Rostovskaya oblast''',178,0,NULL,1, 'RU-ROS', NULL UNION ALL 
        SELECT 4926, 'Ryazanskaya oblast''',178,0,NULL,1, 'RU-RYA', NULL UNION ALL 
        SELECT 4927, 'Saha, Respublika',178,0,NULL,1, 'RU-SA', NULL UNION ALL 
        SELECT 4928, 'Sakhalinskaya oblast''',178,0,NULL,1, 'RU-SAK', NULL UNION ALL 
        SELECT 4929, 'Samarskaya oblast''',178,0,NULL,1, 'RU-SAM', NULL UNION ALL 
        SELECT 4930, 'Sankt-Peterburg',178,0,NULL,1, 'RU-SPE', NULL UNION ALL 
        SELECT 4931, 'Saratovskaya oblast''',178,0,NULL,1, 'RU-SAR', NULL UNION ALL 
        SELECT 4932, 'Severnaya Osetiya, Respublika',178,0,NULL,1, 'RU-SE', NULL UNION ALL 
        SELECT 4933, 'Smolenskaya oblast''',178,0,NULL,1, 'RU-SMO', NULL UNION ALL 
        SELECT 4934, 'Stavropol''skiy kray',178,0,NULL,1, 'RU-STA', NULL UNION ALL 
        SELECT 4935, 'Sverdlovskaya oblast''',178,0,NULL,1, 'RU-SVE', NULL UNION ALL 
        SELECT 4936, 'Tambovskaya oblast''',178,0,NULL,1, 'RU-TAM', NULL UNION ALL 
        SELECT 4937, 'Tatarstan, Respublika',178,0,NULL,1, 'RU-TA', NULL UNION ALL 
        SELECT 4938, 'Tomskaya oblast''',178,0,NULL,1, 'RU-TOM', NULL UNION ALL 
        SELECT 4939, 'Tul''skaya oblast''',178,0,NULL,1, 'RU-TUL', NULL UNION ALL 
        SELECT 4940, 'Tverskaya oblast''',178,0,NULL,1, 'RU-TVE', NULL UNION ALL 
        SELECT 4941, 'Tyumenskaya oblast''',178,0,NULL,1, 'RU-TYU', NULL UNION ALL 
        SELECT 4942, 'Tyva, Respublika',178,0,NULL,1, 'RU-TY', NULL UNION ALL 
        SELECT 4943, 'Udmurtskaya Respublika',178,0,NULL,1, 'RU-UD', NULL UNION ALL 
        SELECT 4944, 'Ul''yanovskaya oblast''',178,0,NULL,1, 'RU-ULY', NULL UNION ALL 
        SELECT 4945, 'Vladimirskaya oblast''',178,0,NULL,1, 'RU-VLA', NULL UNION ALL 
        SELECT 4946, 'Volgogradskaya oblast''',178,0,NULL,1, 'RU-VGG', NULL UNION ALL 
        SELECT 4947, 'Vologodskaya oblast''',178,0,NULL,1, 'RU-VLG', NULL UNION ALL 
        SELECT 4948, 'Voronezhskaya oblast''',178,0,NULL,1, 'RU-VOR', NULL UNION ALL 
        SELECT 4949, 'Yamalo-Nenetskiy avtonomnyy okrug',178,0,NULL,1, 'RU-YAN', NULL UNION ALL 
        SELECT 4950, 'Yaroslavskaya oblast''',178,0,NULL,1, 'RU-YAR', NULL UNION ALL 
        SELECT 4951, 'Yevreyskaya avtonomnaya oblast''',178,0,NULL,1, 'RU-YEV', NULL UNION ALL 
        SELECT 4952, 'Zabaykal''skiy kray',178,0,NULL,1, 'RU-ZAB', NULL UNION ALL 
        SELECT 4953, 'Alicante',199,0,NULL,1, 'ES-A', 'ES-VC' UNION ALL 
        SELECT 4954, 'Albacete',199,0,NULL,1, 'ES-AB', 'ES-CM' UNION ALL 
        SELECT 4955, 'Almería',199,0,NULL,1, 'ES-AL', 'ES-AN' UNION ALL 
        SELECT 4956, 'Andalucía',199,0,NULL,1, 'ES-AN', NULL UNION ALL 
        SELECT 4957, 'Aragón',199,0,NULL,1, 'ES-AR', NULL UNION ALL 
        SELECT 4958, 'Asturias, Principado de',199,0,NULL,1, 'ES-AS', NULL UNION ALL 
        SELECT 4959, 'Ávila',199,0,NULL,1, 'ES-AV', 'ES-CL' UNION ALL 
        SELECT 4960, 'Barcelona [Barcelona]',199,0,NULL,1, 'ES-B', 'ES-CT' UNION ALL 
        SELECT 4961, 'Badajoz',199,0,NULL,1, 'ES-BA', 'ES-EX' UNION ALL 
        SELECT 4962, 'Bizkaia',199,0,NULL,1, 'ES-BI', 'ES-PV' UNION ALL 
        SELECT 4963, 'Burgos',199,0,NULL,1, 'ES-BU', 'ES-CL' UNION ALL 
        SELECT 4964, 'A Coruña [La Coruña]',199,0,NULL,1, 'ES-C', 'ES-GA' UNION ALL 
        SELECT 4965, 'Cádiz',199,0,NULL,1, 'ES-CA', 'ES-AN' UNION ALL 
        SELECT 4966, 'Cantabria',199,0,NULL,1, 'ES-CB', NULL UNION ALL 
        SELECT 4967, 'Cáceres',199,0,NULL,1, 'ES-CC', 'ES-EX' UNION ALL 
        SELECT 4968, 'Ceuta',199,0,NULL,1, 'ES-CE', NULL UNION ALL 
        SELECT 4969, 'Castilla y León',199,0,NULL,1, 'ES-CL', NULL UNION ALL 
        SELECT 4970, 'Castilla-La Mancha',199,0,NULL,1, 'ES-CM', NULL UNION ALL 
        SELECT 4971, 'Canarias',199,0,NULL,1, 'ES-CN', NULL UNION ALL 
        SELECT 4972, 'Córdoba',199,0,NULL,1, 'ES-CO', 'ES-AN' UNION ALL 
        SELECT 4973, 'Ciudad Real',199,0,NULL,1, 'ES-CR', 'ES-CM' UNION ALL 
        SELECT 4974, 'Castellón',199,0,NULL,1, 'ES-CS', 'ES-VC' UNION ALL 
        SELECT 4975, 'Catalunya [Cataluña]',199,0,NULL,1, 'ES-CT', NULL UNION ALL 
        SELECT 4976, 'Cuenca',199,0,NULL,1, 'ES-CU', 'ES-CM' UNION ALL 
        SELECT 4977, 'Extremadura',199,0,NULL,1, 'ES-EX', NULL UNION ALL 
        SELECT 4978, 'Galicia [Galicia]',199,0,NULL,1, 'ES-GA', NULL UNION ALL 
        SELECT 4979, 'Las Palmas',199,0,NULL,1, 'ES-GC', 'ES-CN' UNION ALL 
        SELECT 4980, 'Girona [Gerona]',199,0,NULL,1, 'ES-GI', 'ES-CT' UNION ALL 
        SELECT 4981, 'Granada',199,0,NULL,1, 'ES-GR', 'ES-AN' UNION ALL 
        SELECT 4982, 'Guadalajara',199,0,NULL,1, 'ES-GU', 'ES-CM' UNION ALL 
        SELECT 4983, 'Huelva',199,0,NULL,1, 'ES-H', 'ES-AN' UNION ALL 
        SELECT 4984, 'Huesca',199,0,NULL,1, 'ES-HU', 'ES-AR' UNION ALL 
        SELECT 4985, 'Illes Balears [Islas Baleares]',199,0,NULL,1, 'ES-IB', NULL UNION ALL 
        SELECT 4986, 'Jaén',199,0,NULL,1, 'ES-J', 'ES-AN' UNION ALL 
        SELECT 4987, 'Lleida [Lérida]',199,0,NULL,1, 'ES-L', 'ES-CT' UNION ALL 
        SELECT 4988, 'León',199,0,NULL,1, 'ES-LE', 'ES-CL' UNION ALL 
        SELECT 4989, 'La Rioja',199,0,NULL,1, 'ES-LO', 'ES-RI' UNION ALL 
        SELECT 4990, 'Lugo [Lugo]',199,0,NULL,1, 'ES-LU', 'ES-GA' UNION ALL 
        SELECT 4991, 'Madrid',199,0,NULL,1, 'ES-M', 'ES-MD' UNION ALL 
        SELECT 4992, 'Málaga',199,0,NULL,1, 'ES-MA', 'ES-AN' UNION ALL 
        SELECT 4993, 'Murcia, Región de',199,0,NULL,1, 'ES-MC', NULL UNION ALL 
        SELECT 4994, 'Madrid, Comunidad de',199,0,NULL,1, 'ES-MD', NULL UNION ALL 
        SELECT 4995, 'Melilla',199,0,NULL,1, 'ES-ML', NULL UNION ALL 
        SELECT 4996, 'Murcia',199,0,NULL,1, 'ES-MU', 'ES-MC' UNION ALL 
        SELECT 4997, 'Navarra',199,0,NULL,1, 'ES-NA', 'ES-NC' UNION ALL 
        SELECT 4998, 'Navarra, Comunidad Foral de',199,0,NULL,1, 'ES-NC', NULL UNION ALL 
        SELECT 4999, 'Asturias',199,0,NULL,1, 'ES-O', 'ES-AS' UNION ALL 
        SELECT 5000, 'Ourense [Orense]',199,0,NULL,1, 'ES-OR', 'ES-GA' UNION ALL 
        SELECT 5001, 'Palencia',199,0,NULL,1, 'ES-P', 'ES-CL' UNION ALL 
        SELECT 5002, 'Balears [Baleares]',199,0,NULL,1, 'ES-PM', 'ES-IB' UNION ALL 
        SELECT 5003, 'Pontevedra [Pontevedra]',199,0,NULL,1, 'ES-PO', 'ES-GA' UNION ALL 
        SELECT 5004, 'País Vasco',199,0,NULL,1, 'ES-PV', NULL UNION ALL 
        SELECT 5005, 'La Rioja',199,0,NULL,1, 'ES-RI', NULL UNION ALL 
        SELECT 5006, 'Cantabria',199,0,NULL,1, 'ES-S', 'ES-CB' UNION ALL 
        SELECT 5007, 'Salamanca',199,0,NULL,1, 'ES-SA', 'ES-CL' UNION ALL 
        SELECT 5008, 'Sevilla',199,0,NULL,1, 'ES-SE', 'ES-AN' UNION ALL 
        SELECT 5009, 'Segovia',199,0,NULL,1, 'ES-SG', 'ES-CL' UNION ALL 
        SELECT 5010, 'Soria',199,0,NULL,1, 'ES-SO', 'ES-CL' UNION ALL 
        SELECT 5011, 'Gipuzkoa',199,0,NULL,1, 'ES-SS', 'ES-PV' UNION ALL 
        SELECT 5012, 'Tarragona [Tarragona]',199,0,NULL,1, 'ES-T', 'ES-CT' UNION ALL 
        SELECT 5013, 'Teruel',199,0,NULL,1, 'ES-TE', 'ES-AR' UNION ALL 
        SELECT 5014, 'Santa Cruz de Tenerife',199,0,NULL,1, 'ES-TF', 'ES-CN' UNION ALL 
        SELECT 5015, 'Toledo',199,0,NULL,1, 'ES-TO', 'ES-CM' UNION ALL 
        SELECT 5016, 'Valencia',199,0,NULL,1, 'ES-V', 'ES-VC' UNION ALL 
        SELECT 5017, 'Valladolid',199,0,NULL,1, 'ES-VA', 'ES-CL' UNION ALL 
        SELECT 5018, 'Valenciana, Comunidad',199,0,NULL,1, 'ES-VC', NULL UNION ALL 
        SELECT 5019, 'Álava',199,0,NULL,1, 'ES-VI', 'ES-PV' UNION ALL 
        SELECT 5020, 'Zaragoza',199,0,NULL,1, 'ES-Z', 'ES-AR' UNION ALL 
        SELECT 5021, 'Zamora',199,0,NULL,1, 'ES-ZA', 'ES-CL' UNION ALL 
        SELECT 5022, 'Aargau',206,0,NULL,1, 'CH-AG', NULL UNION ALL 
        SELECT 5023, 'Appenzell Innerrhoden',206,0,NULL,1, 'CH-AI', NULL UNION ALL 
        SELECT 5024, 'Appenzell Ausserrhoden',206,0,NULL,1, 'CH-AR', NULL UNION ALL 
        SELECT 5025, 'Bern',206,0,NULL,1, 'CH-BE', NULL UNION ALL 
        SELECT 5026, 'Basel-Landschaft',206,0,NULL,1, 'CH-BL', NULL UNION ALL 
        SELECT 5027, 'Basel-Stadt',206,0,NULL,1, 'CH-BS', NULL UNION ALL 
        SELECT 5028, 'Freiburg',206,0,NULL,1, 'CH-FR', NULL UNION ALL 
        SELECT 5029, 'Genève',206,0,NULL,1, 'CH-GE', NULL UNION ALL 
        SELECT 5030, 'Glarus',206,0,NULL,1, 'CH-GL', NULL UNION ALL 
        SELECT 5031, 'Graubünden',206,0,NULL,1, 'CH-GR', NULL UNION ALL 
        SELECT 5032, 'Jura',206,0,NULL,1, 'CH-JU', NULL UNION ALL 
        SELECT 5033, 'Luzern',206,0,NULL,1, 'CH-LU', NULL UNION ALL 
        SELECT 5034, 'Neuchâtel',206,0,NULL,1, 'CH-NE', NULL UNION ALL 
        SELECT 5035, 'Nidwalden',206,0,NULL,1, 'CH-NW', NULL UNION ALL 
        SELECT 5036, 'Obwalden',206,0,NULL,1, 'CH-OW', NULL UNION ALL 
        SELECT 5037, 'Sankt Gallen',206,0,NULL,1, 'CH-SG', NULL UNION ALL 
        SELECT 5038, 'Schaffhausen',206,0,NULL,1, 'CH-SH', NULL UNION ALL 
        SELECT 5039, 'Solothurn',206,0,NULL,1, 'CH-SO', NULL UNION ALL 
        SELECT 5040, 'Schwyz',206,0,NULL,1, 'CH-SZ', NULL UNION ALL 
        SELECT 5041, 'Thurgau',206,0,NULL,1, 'CH-TG', NULL UNION ALL 
        SELECT 5042, 'Ticino',206,0,NULL,1, 'CH-TI', NULL UNION ALL 
        SELECT 5043, 'Uri',206,0,NULL,1, 'CH-UR', NULL UNION ALL 
        SELECT 5044, 'Vaud',206,0,NULL,1, 'CH-VD', NULL UNION ALL 
        SELECT 5045, 'Wallis',206,0,NULL,1, 'CH-VS', NULL UNION ALL 
        SELECT 5046, 'Zug',206,0,NULL,1, 'CH-ZG', NULL UNION ALL 
        SELECT 5047, 'Zürich',206,0,NULL,1, 'CH-ZH', NULL 
 
        SET IDENTITY_INSERT TRefCounty OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '05728530-1276-4593-B99F-73790EDD6136', 
         'Initial load (5038 total rows, file 1 of 1) for table TRefCounty',
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
-- #Rows Exported: 5038
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
