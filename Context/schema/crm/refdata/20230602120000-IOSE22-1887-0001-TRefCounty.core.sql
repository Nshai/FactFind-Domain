 
-----------------------------------------------------------------------------
-- Table: CRM.TRefCounty
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE crm
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '565334E1-B30D-4DAC-9AD3-BEF66724544D'
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
		OUTPUT                                   
			  -- specify the inserted RefData columns for audit puporses
				inserted.CountyName,
				inserted.RefCountryId,
				inserted.Extensible,
				inserted.ArchiveFG,
				inserted.ConcurrencyId,
				inserted.RefCountyId,
				inserted.CountyCode,
				inserted.ParentCountyCode,
				'C',
				GETUTCDATE(),
				'0'
		INTO
			  [dbo].[TRefCountyAudit]
			(
				-- specify the audit columns
				CountyName,
				RefCountryId,
				Extensible,
				ArchiveFG,
				ConcurrencyId,
				RefCountyId,
				CountyCode,
				ParentCountyCode,
				StampAction,
				StampDateTime,
				StampUser
			)
        VALUES
		 (5048,'Borders',262,0,NULL,1,'XS-SCB','GB-SCT')
		,(5049,'Dumfries and Galloway',262,0,NULL,1,'XS-DGY','GB-SCT')
		,(5050,'Fife',262,0,NULL,1,'XS-FIF','GB-SCT')
		,(5051,'Highlands',262,0,NULL,1,'XS-HLD','GB-SCT')
		,(5052,'Orkney',262,0,NULL,1,'XS-ORK','GB-SCT')
		,(5053,'Shetland',262,0,NULL,1,'XS-ZET','GB-SCT')
		,(5054,'Lanarkshire',262,0,NULL,1,'XS-NLK','GB-SCT')
		,(5055,'Aberdeenshire',262,0,NULL,1,'XS-ABD','GB-SCT')
		,(5056,'Angus',262,0,NULL,1,'XS-ANS','GB-SCT')
		,(5057,'Argyll',262,0,NULL,1,'XS-AGB','GB-SCT')
		,(5058,'Ayrshire',262,0,NULL,1,'XS-EAY','GB-SCT')
		,(5059,'Clackmannanshire',262,0,NULL,1,'XS-CLK','GB-SCT')
		,(5060,'Dunbartonshire',262,0,NULL,1,'XS-EDU','GB-SCT')
		,(5061,'Morayshire',262,0,NULL,1,'XS-MRY','GB-SCT')
		,(5062,'Perthshire',262,0,NULL,1,'XS-PKN','GB-SCT')
		,(5063,'Renfrewshire',262,0,NULL,1,'XS-RFW','GB-SCT')
		,(5064,'Stirlingshire',262,0,NULL,1,'XS-STG','GB-SCT')
		,(5065,'East Lothian',262,0,NULL,1,'XS-ELN','GB-SCT')
		,(5066,'Midlothian',262,0,NULL,1,'XS-MLN','GB-SCT')
		,(5067,'West Lothian',262,0,NULL,1,'XS-WLN','GB-SCT')
		,(5068,'Aberdeen City',262,0,NULL,1,'XS-ABE','GB-SCT')
		,(5069,'Dundee City',262,0,NULL,1,'XS-DND','GB-SCT')
		,(5070,'Edinburgh, City of',262,0,NULL,1,'XS-EDH','GB-SCT')
		,(5071,'Eilean Siar',262,0,NULL,1,'XS-ELS','GB-SCT')
		,(5072,'East Renfrewshire',262,0,NULL,1,'XS-ERW','GB-SCT')
		,(5073,'Falkirk',262,0,NULL,1,'XS-FAL','GB-SCT')
		,(5074,'Glasgow City',262,0,NULL,1,'XS-GLG','GB-SCT')
		,(5075,'Inverclyde',262,0,NULL,1,'XS-IVC','GB-SCT')
		,(5076,'North Ayrshire',262,0,NULL,1,'XS-NAY','GB-SCT')
		,(5077,'South Ayrshire',262,0,NULL,1,'XS-SAY','GB-SCT')
		,(5078,'South Lanarkshire',262,0,NULL,1,'XS-SLK','GB-SCT')
		,(5079,'West Dunbartonshire',262,0,NULL,1,'XS-WDU','GB-SCT')
		,(5080,'Gwent',263,0,NULL,1,'XW-BGW','GB-WLS')
		,(5081,'Gwynedd',263,0,NULL,1,'XW-GWN','GB-WLS')
		,(5082,'Powys',263,0,NULL,1,'XW-POW','GB-WLS')
		,(5083,'Carmarthenshire',263,0,NULL,1,'XW-CMN','GB-WLS')
		,(5084,'Conwy County',263,0,NULL,1,'XW-CWY','GB-WLS')
		,(5085,'Flintshire',263,0,NULL,1,'XW-FLN','GB-WLS')
		,(5086,'Denbighshire',263,0,NULL,1,'XW-DEN','GB-WLS')
		,(5087,'Ceredigion',263,0,NULL,1,'XW-CGN','GB-WLS')
		,(5088,'Pembrokeshire',263,0,NULL,1,'XW-PEM','GB-WLS')
		,(5089,'Monmouthshire',263,0,NULL,1,'XW-MON','GB-WLS')
		,(5090,'Swansea',263,0,NULL,1,'XW-SWA','GB-WLS')
		,(5091,'Rhondda Cynon Taff',263,0,NULL,1,'XW-RCT','GB-WLS')
		,(5092,'Cardiff',263,0,NULL,1,'XW-CRF','GB-WLS')
		,(5093,'Newport',263,0,NULL,1,'XW-NWP','GB-WLS')
		,(5094,'Torfaen',263,0,NULL,1,'XW-TOF','GB-WLS')
		,(5095,'Isle of Anglesey',263,0,NULL,1,'XW-AGY','GB-WLS')
		,(5096,'Wrexham',263,0,NULL,1,'XW-WRX','GB-WLS')
		,(5097,'Neath Port Talbot',263,0,NULL,1,'XW-NTL','GB-WLS')
		,(5098,'Bridgend',263,0,NULL,1,'XW-BGE','GB-WLS')
		,(5099,'The Vale of Glamorgan',263,0,NULL,1,'XW-VGL','GB-WLS')
		,(5100,'Merthyr Tydfil',263,0,NULL,1,'XW-MTY','GB-WLS')
		,(5101,'Cambridgeshire',264,0,NULL,1,'XE-CAM','GB-ENG')
		,(5102,'Cumbria',264,0,NULL,1,'XE-CMA','GB-ENG')
		,(5103,'Derbyshire',264,0,NULL,1,'XE-DBY','GB-ENG')
		,(5104,'Devon',264,0,NULL,1,'XE-DEV','GB-ENG')
		,(5105,'Dorset',264,0,NULL,1,'XE-DOR','GB-ENG')
		,(5106,'East Sussex',264,0,NULL,1,'XE-ESX','GB-ENG')
		,(5107,'Essex',264,0,NULL,1,'XE-ESS','GB-ENG')
		,(5108,'Gloucestershire',264,0,NULL,1,'XE-GLS','GB-ENG')
		,(5109,'Hampshire',264,0,NULL,1,'XE-HAM','GB-ENG')
		,(5110,'Hertfordshire',264,0,NULL,1,'XE-HRT','GB-ENG')
		,(5111,'Kent',264,0,NULL,1,'XE-KEN','GB-ENG')
		,(5112,'Lancashire',264,0,NULL,1,'XE-LAN','GB-ENG')
		,(5113,'Leicestershire',264,0,NULL,1,'XE-LEC','GB-ENG')
		,(5114,'Lincolnshire',264,0,NULL,1,'XE-LIN','GB-ENG')
		,(5115,'Norfolk',264,0,NULL,1,'XE-NFK','GB-ENG')
		,(5116,'North Yorkshire',264,0,NULL,1,'XE-NYK','GB-ENG')
		,(5117,'Nottinghamshire',264,0,NULL,1,'XE-NTT','GB-ENG')
		,(5118,'Oxfordshire',264,0,NULL,1,'XE-OXF','GB-ENG')
		,(5119,'Somerset',264,0,NULL,1,'XE-SOM','GB-ENG')
		,(5120,'Staffordshire',264,0,NULL,1,'XE-STS','GB-ENG')
		,(5121,'Suffolk',264,0,NULL,1,'XE-SFK','GB-ENG')
		,(5122,'Surrey',264,0,NULL,1,'XE-SRY','GB-ENG')
		,(5123,'Warwickshire',264,0,NULL,1,'XE-WAR','GB-ENG')
		,(5124,'West Sussex',264,0,NULL,1,'XE-WSX','GB-ENG')
		,(5125,'Worcestershire',264,0,NULL,1,'XE-WOR','GB-ENG')
		,(5126,'Greater London',264,0,NULL,1,'XE-046','GB-ENG')
		,(5127,'Central london',264,0,NULL,1,'XE-LND','GB-ENG')
		,(5128,'Barking and Dagenham',264,0,NULL,1,'XE-BDG','GB-ENG')
		,(5129,'Barnet',264,0,NULL,1,'XE-BNE','GB-ENG')
		,(5130,'Bexley',264,0,NULL,1,'XE-BEX','GB-ENG')
		,(5131,'Brent',264,0,NULL,1,'XE-BEN','GB-ENG')
		,(5132,'Bromley',264,0,NULL,1,'XE-BRY','GB-ENG')
		,(5133,'Camden',264,0,NULL,1,'XE-CMD','GB-ENG')
		,(5134,'Croydon',264,0,NULL,1,'XE-CRY','GB-ENG')
		,(5135,'Ealing',264,0,NULL,1,'XE-EAL','GB-ENG')
		,(5136,'Enfield',264,0,NULL,1,'XE-ENF','GB-ENG')
		,(5137,'Greenwich',264,0,NULL,1,'XE-GRE','GB-ENG')
		,(5138,'Hackney',264,0,NULL,1,'XE-HCK','GB-ENG')
		,(5139,'Hammersmith and Fulham',264,0,NULL,1,'XE-HMF','GB-ENG')
		,(5140,'Haringey',264,0,NULL,1,'XE-HRY','GB-ENG')
		,(5141,'Harrow',264,0,NULL,1,'XE-HRW','GB-ENG')
		,(5142,'Havering',264,0,NULL,1,'XE-HAV','GB-ENG')
		,(5143,'Hillingdon',264,0,NULL,1,'XE-HIL','GB-ENG')
		,(5144,'Hounslow',264,0,NULL,1,'XE-HNS','GB-ENG')
		,(5145,'Islington',264,0,NULL,1,'XE-ISL','GB-ENG')
		,(5146,'Kensington and Chelsea',264,0,NULL,1,'XE-KEC','GB-ENG')
		,(5147,'Kingston upon Thames',264,0,NULL,1,'XE-KTT','GB-ENG')
		,(5148,'Lambeth',264,0,NULL,1,'XE-LBH','GB-ENG')
		,(5149,'Lewisham',264,0,NULL,1,'XE-LEW','GB-ENG')
		,(5150,'Merton',264,0,NULL,1,'XE-MRT','GB-ENG')
		,(5151,'Newham',264,0,NULL,1,'XE-NWM','GB-ENG')
		,(5152,'Redbridge',264,0,NULL,1,'XE-RDB','GB-ENG')
		,(5153,'Richmond upon Thames',264,0,NULL,1,'XE-RIC','GB-ENG')
		,(5154,'Southwark',264,0,NULL,1,'XE-SWK','GB-ENG')
		,(5155,'Sutton',264,0,NULL,1,'XE-STN','GB-ENG')
		,(5156,'Tower Hamlets',264,0,NULL,1,'XE-TWH','GB-ENG')
		,(5157,'Waltham Forest',264,0,NULL,1,'XE-WFT','GB-ENG')
		,(5158,'Wandsworth',264,0,NULL,1,'XE-WND','GB-ENG')
		,(5159,'Westminster',264,0,NULL,1,'XE-WSM','GB-ENG')
		,(5160,'Barnsley',264,0,NULL,1,'XE-BNS','GB-ENG')
		,(5161,'Birmingham',264,0,NULL,1,'XE-BIR','GB-ENG')
		,(5162,'Bolton',264,0,NULL,1,'XE-BOL','GB-ENG')
		,(5163,'Bradford',264,0,NULL,1,'XE-BRD','GB-ENG')
		,(5164,'Bury',264,0,NULL,1,'XE-BUR','GB-ENG')
		,(5165,'Calderdale',264,0,NULL,1,'XE-CLD','GB-ENG')
		,(5166,'Coventry',264,0,NULL,1,'XE-COV','GB-ENG')
		,(5167,'Doncaster',264,0,NULL,1,'XE-DNC','GB-ENG')
		,(5168,'Dudley',264,0,NULL,1,'XE-DUD','GB-ENG')
		,(5169,'Gateshead',264,0,NULL,1,'XE-GAT','GB-ENG')
		,(5170,'Kirklees',264,0,NULL,1,'XE-KIR','GB-ENG')
		,(5171,'Knowsley',264,0,NULL,1,'XE-KWL','GB-ENG')
		,(5172,'Leeds',264,0,NULL,1,'XE-LDS','GB-ENG')
		,(5173,'Merseyside',264,0,NULL,1,'XE-LIV','GB-ENG')
		,(5174,'Manchester',264,0,NULL,1,'XE-MAN','GB-ENG')
		,(5175,'Greater Manchester',264,0,NULL,1,'XE-049','GB-ENG')
		,(5176,'Tyne and Wear',264,0,NULL,1,'XE-NET','GB-ENG')
		,(5177,'North Tyneside',264,0,NULL,1,'XE-NTY','GB-ENG')
		,(5178,'Oldham',264,0,NULL,1,'XE-OLD','GB-ENG')
		,(5179,'Rochdale',264,0,NULL,1,'XE-RCH','GB-ENG')
		,(5180,'Rotherham',264,0,NULL,1,'XE-ROT','GB-ENG')
		,(5181,'St. Helens',264,0,NULL,1,'XE-SHN','GB-ENG')
		,(5182,'Salford',264,0,NULL,1,'XE-SLF','GB-ENG')
		,(5183,'Sandwell',264,0,NULL,1,'XE-SAW','GB-ENG')
		,(5184,'Sefton',264,0,NULL,1,'XE-SFT','GB-ENG')
		,(5185,'Sheffield',264,0,NULL,1,'XE-SHF','GB-ENG')
		,(5186,'Solihull',264,0,NULL,1,'XE-SOL','GB-ENG')
		,(5187,'South Tyneside',264,0,NULL,1,'XE-STY','GB-ENG')
		,(5188,'Stockport',264,0,NULL,1,'XE-SKP','GB-ENG')
		,(5189,'Sunderland',264,0,NULL,1,'XE-SND','GB-ENG')
		,(5190,'Tameside',264,0,NULL,1,'XE-TAM','GB-ENG')
		,(5191,'Trafford',264,0,NULL,1,'XE-TRF','GB-ENG')
		,(5192,'Wakefield',264,0,NULL,1,'XE-WKF','GB-ENG')
		,(5193,'Walsall',264,0,NULL,1,'XE-WLL','GB-ENG')
		,(5194,'Wigan',264,0,NULL,1,'XE-WGN','GB-ENG')
		,(5195,'Wirral',264,0,NULL,1,'XE-WRL','GB-ENG')
		,(5196,'Wolverhampton',264,0,NULL,1,'XE-WLV','GB-ENG')
		,(5197,'Bath and North East Somerset',264,0,NULL,1,'XE-BAS','GB-ENG')
		,(5198,'Bedford',264,0,NULL,1,'XE-BDF','GB-ENG')
		,(5199,'Blackburn with Darwen',264,0,NULL,1,'XE-BBD','GB-ENG')
		,(5200,'Blackpool',264,0,NULL,1,'XE-BPL','GB-ENG')
		,(5201,'Bournemouth',264,0,NULL,1,'XE-BMH','GB-ENG')
		,(5202,'Poole',264,0,NULL,1,'XE-POL','GB-ENG')
		,(5203,'Bracknell Forest',264,0,NULL,1,'XE-BRC','GB-ENG')
		,(5204,'Brighton and Hove',264,0,NULL,1,'XE-BNH','GB-ENG')
		,(5205,'Bristol',264,0,NULL,1,'XE-BST','GB-ENG')
		,(5206,'Buckinghamshire',264,0,NULL,1,'XE-BKM','GB-ENG')
		,(5207,'Bedfordshire',264,0,NULL,1,'XE-CBF','GB-ENG')
		,(5208,'Cheshire',264,0,NULL,1,'XE-CHE','GB-ENG')
		,(5209,'Cheshire West and Chester',264,0,NULL,1,'XE-CHW','GB-ENG')
		,(5210,'Cornwall',264,0,NULL,1,'XE-CON','GB-ENG')
		,(5211,'Darlington',264,0,NULL,1,'XE-DAL','GB-ENG')
		,(5212,'Derby',264,0,NULL,1,'XE-DER','GB-ENG')
		,(5213,'County Durham',264,0,NULL,1,'XE-DUR','GB-ENG')
		,(5214,'South Yorkshire',264,0,NULL,1,'XE-076','GB-ENG')
		,(5215,'West Yorkshire',264,0,NULL,1,'XE-077','GB-ENG')
		,(5216,'East Yorkshire',264,0,NULL,1,'XE-ERY','GB-ENG')
		,(5217,'Yorkshire',264,0,NULL,1,'XE-119','GB-ENG')
		,(5218,'Halton',264,0,NULL,1,'XE-HAL','GB-ENG')
		,(5219,'Hartlepool',264,0,NULL,1,'XE-HPL','GB-ENG')
		,(5220,'Herefordshire',264,0,NULL,1,'XE-HEF','GB-ENG')
		,(5221,'Isle of Wight',264,0,NULL,1,'XE-IOW','GB-ENG')
		,(5222,'Isles of Scilly',264,0,NULL,1,'XE-IOS','GB-ENG')
		,(5223,'Kingston upon Hull',264,0,NULL,1,'XE-KHL','GB-ENG')
		,(5224,'Leicester',264,0,NULL,1,'XE-LCE','GB-ENG')
		,(5225,'Luton',264,0,NULL,1,'XE-LUT','GB-ENG')
		,(5226,'Medway',264,0,NULL,1,'XE-MDW','GB-ENG')
		,(5227,'Middlesbrough',264,0,NULL,1,'XE-MDB','GB-ENG')
		,(5228,'Milton Keynes',264,0,NULL,1,'XE-MIK','GB-ENG')
		,(5229,'North East Lincolnshire',264,0,NULL,1,'XE-NEL','GB-ENG')
		,(5230,'North Lincolnshire',264,0,NULL,1,'XE-NLN','GB-ENG')
		,(5231,'Northamptonshire',264,0,NULL,1,'XE-NTH','GB-ENG')
		,(5232,'North Somerset',264,0,NULL,1,'XE-NSM','GB-ENG')
		,(5233,'Northumberland',264,0,NULL,1,'XE-NBL','GB-ENG')
		,(5234,'Nottingham',264,0,NULL,1,'XE-NGM','GB-ENG')
		,(5235,'Peterborough',264,0,NULL,1,'XE-PTE','GB-ENG')
		,(5236,'Plymouth',264,0,NULL,1,'XE-PLY','GB-ENG')
		,(5237,'Portsmouth',264,0,NULL,1,'XE-POR','GB-ENG')
		,(5238,'Reading',264,0,NULL,1,'XE-RDG','GB-ENG')
		,(5239,'Cleveland',264,0,NULL,1,'XE-RCC','GB-ENG')
		,(5240,'Rutland',264,0,NULL,1,'XE-RUT','GB-ENG')
		,(5241,'Shropshire',264,0,NULL,1,'XE-SHR','GB-ENG')
		,(5242,'Slough',264,0,NULL,1,'XE-SLG','GB-ENG')
		,(5243,'Southampton',264,0,NULL,1,'XE-STH','GB-ENG')
		,(5244,'Southend-on-Sea',264,0,NULL,1,'XE-SOS','GB-ENG')
		,(5245,'Stockton-on-Tees',264,0,NULL,1,'XE-STT','GB-ENG')
		,(5246,'Stoke-on-Trent',264,0,NULL,1,'XE-STE','GB-ENG')
		,(5247,'Swindon',264,0,NULL,1,'XE-SWD','GB-ENG')
		,(5248,'Telford and Wrekin',264,0,NULL,1,'XE-TFW','GB-ENG')
		,(5249,'Thurrock',264,0,NULL,1,'XE-THR','GB-ENG')
		,(5250,'Torbay',264,0,NULL,1,'XE-TOB','GB-ENG')
		,(5251,'Warrington',264,0,NULL,1,'XE-WRT','GB-ENG')
		,(5252,'Berkshire',264,0,NULL,1,'XE-WBK','GB-ENG')
		,(5253,'Wiltshire',264,0,NULL,1,'XE-WIL','GB-ENG')
		,(5254,'Windsor and Maidenhead',264,0,NULL,1,'XE-WNM','GB-ENG')
		,(5255,'Wokingham',264,0,NULL,1,'XE-WOK','GB-ENG')
		,(5256,'York',264,0,NULL,1,'XE-YOR','GB-ENG')
		,(5257,'West Midlands',264,0,NULL,1,'XE-073','GB-ENG')
		,(5258,'Middlesex',264,0,NULL,1,'XE-079','GB-ENG')
		,(5259,'South Glos',264,0,NULL,1,'XE-SGC','GB-ENG')
		,(5260,'County Antrim',265,0,NULL,1,'XN-ANT','GB-NIR')
		,(5261,'Newtownabbey',265,0,NULL,1,'XN-NTA','GB-NIR')
		,(5262,'Ards',265,0,NULL,1,'XN-ARD','GB-NIR')
		,(5263,'North Down',265,0,NULL,1,'XN-NDN','GB-NIR')
		,(5264,'County Armagh',265,0,NULL,1,'XN-ARM','GB-NIR')
		,(5265,'Banbridge',265,0,NULL,1,'XN-BNB','GB-NIR')
		,(5266,'Craigavon',265,0,NULL,1,'XN-CGV','GB-NIR')
		,(5267,'Belfast',265,0,NULL,1,'XN-BFS','GB-NIR')
		,(5268,'County Londonderry',265,0,NULL,1,'XN-DRY','GB-NIR')
		,(5269,'Strabane',265,0,NULL,1,'XN-STB','GB-NIR')
		,(5270,'County Fermanagh',265,0,NULL,1,'XN-FER','GB-NIR')
		,(5271,'Omagh',265,0,NULL,1,'XN-OMH','GB-NIR')
		,(5272,'Lisburn',265,0,NULL,1,'XN-LSB','GB-NIR')
		,(5273,'Castlereagh',265,0,NULL,1,'XN-CSR','GB-NIR')
		,(5274,'Newry and Mourne',265,0,NULL,1,'XN-NYM','GB-NIR')
		,(5275,'County Down',265,0,NULL,1,'XN-DOW','GB-NIR')
		,(5276,'County Tyrone',265,0,NULL,1,'XN-DGN','GB-NIR')
		,(5277,'Ballymena',265,0,NULL,1,'XN-BLA','GB-NIR')
		,(5278,'Ballymoney',265,0,NULL,1,'XN-BLY','GB-NIR')
		,(5279,'Carrickfergus',265,0,NULL,1,'XN-CKF','GB-NIR')
		,(5280,'Cookstown',265,0,NULL,1,'XN-CKT','GB-NIR')
		,(5281,'Coleraine',265,0,NULL,1,'XN-CLR','GB-NIR')
		,(5282,'Limavady',265,0,NULL,1,'XN-LMV','GB-NIR')
		,(5283,'Larne',265,0,NULL,1,'XN-LRN','GB-NIR')
		,(5284,'Magherafelt',265,0,NULL,1,'XN-MFT','GB-NIR')
		,(5285,'Moyle',265,0,NULL,1,'XN-MYL','GB-NIR')
 
        SET IDENTITY_INSERT TRefCounty OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp)

        VALUES (
         '565334E1-B30D-4DAC-9AD3-BEF66724544D', 
         'Adding new Counties as part of the ticket IOSE22-1887',
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
-- #Rows Exported: 1
-- Created by Arun Sivan, Jun 02 2023  01:00PM
-----------------------------------------------------------------------------
