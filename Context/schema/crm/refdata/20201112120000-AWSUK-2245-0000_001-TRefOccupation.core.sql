 
-----------------------------------------------------------------------------
-- Table: CRM.TRefOccupation
--    Join: 
--   Where: 
-----------------------------------------------------------------------------
 
 
USE CRM
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'AB7CC541-186E-483F-B82B-958A89700FCD'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefOccupation ON; 
 
        INSERT INTO TRefOccupation([RefOccupationId], [Description], [OrigoCode], [IsArchived], [ConcurrencyId])
        SELECT 1, 'Abattoir Inspector', 'AAB00001',0,1 UNION ALL 
        SELECT 2, 'Abattoir Worker', 'AAC02588',0,2 UNION ALL 
        SELECT 3, 'Abrasive Paper Goods Maker', 'AAB00002',1,2 UNION ALL 
        SELECT 4, 'Abrasive Wheels - Balancer', 'AAB00003',1,2 UNION ALL 
        SELECT 5, 'Abrasive Wheels - Grinder', 'AAB00004',1,2 UNION ALL 
        SELECT 6, 'Abrasive Wheels - Moulder', 'AAB00005',1,2 UNION ALL 
        SELECT 7, 'Abrasive Wheels - Presser', 'AAB00006',1,2 UNION ALL 
        SELECT 8, 'Abrasive Wheels - Steel Shot Surfacer', 'AAB00007',1,2 UNION ALL 
        SELECT 9, 'Abrasive Wheels - Tester', 'AAB00008',1,2 UNION ALL 
        SELECT 10, 'Abrasive Wheels - Turner', 'AAB00009',1,2 UNION ALL 
        SELECT 11, 'Account Executive', 'AAB00010',0,1 UNION ALL 
        SELECT 12, 'Account Settlement Officer  ', 'AAC02589',1,2 UNION ALL 
        SELECT 13, 'Accountant', 'AAB00011',0,1 UNION ALL 
        SELECT 14, 'Accumulator Repairer', 'AAB00012',1,2 UNION ALL 
        SELECT 15, 'Acidifier Operator', 'AAB00013',0,1 UNION ALL 
        SELECT 16, 'Acrobat - Aerialist', 'AAB00014',1,2 UNION ALL 
        SELECT 17, 'Acrobat - ground level', 'AAB00015',1,2 UNION ALL 
        SELECT 18, 'Acrobat - heights', 'AAB00016',1,2 UNION ALL 
        SELECT 19, 'Acrobat - Tightrope Artiste', 'AAB00017',1,2 UNION ALL 
        SELECT 20, 'Acrobat - Trapeze Artiste', 'AAB00018',1,2 UNION ALL 
        SELECT 21, 'Acrobat - Tumbler', 'AAB00019',1,2 UNION ALL 
        SELECT 22, 'Actor/Actress (no stunt work)', 'AAB00020',0,2 UNION ALL 
        SELECT 23, 'Actuary', 'AAB00021',0,1 UNION ALL 
        SELECT 24, 'Acupuncturist', 'AAB00022',0,1 UNION ALL 
        SELECT 25, 'Administration Manager  ', 'AAC02590',0,1 UNION ALL 
        SELECT 26, 'Advertising executive   ', 'AAC02591',0,1 UNION ALL 
        SELECT 27, 'Advertising Manager', 'AAB00023',0,1 UNION ALL 
        SELECT 28, 'Aerial Erector (40'' up)', 'AAB00024',0,1 UNION ALL 
        SELECT 29, 'Aerial Erector (up to 40'')', 'AAB00025',0,1 UNION ALL 
        SELECT 30, 'Aerial Photography', 'AAB00026',0,1 UNION ALL 
        SELECT 31, 'Aerobics Instructor', 'AAC02592',0,2 UNION ALL 
        SELECT 32, 'Agent', 'AAB00027',0,1 UNION ALL 
        SELECT 33, 'Agricultural Engineer', 'AAB00028',0,1 UNION ALL 
        SELECT 34, 'Agricultural Engineering Technician', 'AAB00029',1,2 UNION ALL 
        SELECT 35, 'Agricultural Worker', 'AAB00030',0,1 UNION ALL 
        SELECT 36, 'Agronomist', 'AAB00031',0,1 UNION ALL 
        SELECT 37, 'Air Compressor Operator - Construction Industry', 'AAB00032',1,2 UNION ALL 
        SELECT 38, 'Air Compressor Operator - Road Maintenance & Construction', 'AAB00033',1,2 UNION ALL 
        SELECT 39, 'Air Compressor Operator - Stoneworking', 'AAB00034',1,2 UNION ALL 
        SELECT 40, 'Air Compressor Operator - Surface', 'AAB00035',1,2 UNION ALL 
        SELECT 41, 'Air Frame Service Fitter', 'AAB00036',0,1 UNION ALL 
        SELECT 42, 'Air Pump Attendant -Coastal etc', 'AAB00037',0,1 UNION ALL 
        SELECT 43, 'Air Pump Attendant -Deep Sea', 'AAB00038',0,1 UNION ALL 
        SELECT 44, 'Air Traffic Control Assistant', 'AAB00039',0,1 UNION ALL 
        SELECT 45, 'Air Traffic Control Clerk', 'AAB00040',1,2 UNION ALL 
        SELECT 46, 'Air Traffic Controller', 'AAB00041',0,1 UNION ALL 
        SELECT 47, 'Air Traffic Planner ', 'AAC02593',0,1 UNION ALL 
        SELECT 48, 'Aircraft Electronics Service Fitter', 'AAB00042',0,1 UNION ALL 
        SELECT 49, 'Aircraft Engine Service Fitter', 'AAB00043',0,1 UNION ALL 
        SELECT 50, 'Aircraft Finisher', 'AAB00044',0,1 UNION ALL 
        SELECT 51, 'Aircraft Inspector', 'AAB00045',0,1 UNION ALL 
        SELECT 52, 'Aircraft Instrument Mechanic', 'AAB00046',0,1 UNION ALL 
        SELECT 53, 'Aircraft Joiner', 'AAB00047',0,1 UNION ALL 
        SELECT 54, 'Aircraft Maintenance Technician', 'AAB00048',0,1 UNION ALL 
        SELECT 55, 'Aircraft Marshaller', 'AAB00049',0,1 UNION ALL 
        SELECT 56, 'Aircraft Refueller', 'AAB00050',0,1 UNION ALL 
        SELECT 57, 'Aircrew (including Flight Engineer)', 'AAB00051',0,1 UNION ALL 
        SELECT 58, 'Airline Cabin Staff', 'AAB00052',0,1 UNION ALL 
        SELECT 59, 'Airline Pilots', 'AAB00053',0,1 UNION ALL 
        SELECT 60, 'Airport Manager', 'AAB00054',0,1 UNION ALL 
        SELECT 61, 'Airport Superintendent', 'AAB00055',0,1 UNION ALL 
        SELECT 62, 'Airships', 'AAB00056',1,2 UNION ALL 
        SELECT 63, 'Ambassador  ', 'AAC02594',0,1 UNION ALL 
        SELECT 64, 'Ambulance Driver', 'AAB00057',0,1 UNION ALL 
        SELECT 65, 'Ambulanceman (No driving)', 'AAB00058',0,1 UNION ALL 
        SELECT 66, 'Ambulanceman (office duties only)   ', 'AAC02595',1,2 UNION ALL 
        SELECT 67, 'American Football', 'AAB00059',1,2 UNION ALL 
        SELECT 68, 'Anaesthetist', 'AAB00060',0,1 UNION ALL 
        SELECT 69, 'Analyst', 'AAB00061',1,2 UNION ALL 
        SELECT 70, 'Analytical Chemist  ', 'AAC02596',0,1 UNION ALL 
        SELECT 71, 'Ancient Monuments Inspector', 'AAB00062',0,1 UNION ALL 
        SELECT 72, 'Animal Nursing Auxiliary', 'AAB00063',0,1 UNION ALL 
        SELECT 73, 'Animal Trainer/Keeper', 'AAB00064',0,1 UNION ALL 
        SELECT 74, 'Animator', 'AAB00065',0,1 UNION ALL 
        SELECT 75, 'Annealer', 'AAB00066',0,1 UNION ALL 
        SELECT 76, 'Announcer - Radio & TV - Entertainment', 'AAB00067',0,1 UNION ALL 
        SELECT 77, 'Announcer - Station Personnel - Railways', 'AAB00068',0,1 UNION ALL 
        SELECT 78, 'Anodiser', 'AAB00069',0,1 UNION ALL 
        SELECT 79, 'Antique Dealer', 'AAB00070',0,1 UNION ALL 
        SELECT 80, 'Antique Restorer', 'AAB00071',0,1 UNION ALL 
        SELECT 81, 'Approved School Matron', 'AAB00072',1,2 UNION ALL 
        SELECT 82, 'Arc Welder', 'AAB00073',0,1 UNION ALL 
        SELECT 83, 'Archaeologist', 'AAB00074',0,1 UNION ALL 
        SELECT 84, 'Archaeologist (other countries) ', 'AAC02597',0,1 UNION ALL 
        SELECT 85, 'Architect', 'AAB00075',0,1 UNION ALL 
        SELECT 86, 'Architect (office)  ', 'AAC02598',0,1 UNION ALL 
        SELECT 87, 'Archivist', 'AAB00076',0,1 UNION ALL 
        SELECT 88, 'Army', 'AAB00077',1,2 UNION ALL 
        SELECT 89, 'Army Divers', 'AAB00078',1,2 UNION ALL 
        SELECT 90, 'Aromatherapist', 'AAB00079',0,1 UNION ALL 
        SELECT 91, 'Arranger', 'AAB00080',0,1 UNION ALL 
        SELECT 92, 'Art Director', 'AAB00081',0,1 UNION ALL 
        SELECT 93, 'Art Gallery Attendant', 'AAB00082',0,1 UNION ALL 
        SELECT 94, 'Art Gallery Curator', 'AAB00083',0,1 UNION ALL 
        SELECT 95, 'Art Gallery Guide', 'AAB00084',0,1 UNION ALL 
        SELECT 96, 'Art Gallery Manager - Commercial    ', 'AAC02599',0,1 UNION ALL 
        SELECT 97, 'Artexer', 'AAB00085',0,1 UNION ALL 
        SELECT 98, 'Artist - Freelance Painter', 'AAB00086',0,1 UNION ALL 
        SELECT 99, 'Artist Commercial', 'AAB00087',0,1 UNION ALL 
        SELECT 100, 'Artist''s Model', 'AAB00088',0,1 UNION ALL 
        SELECT 101, 'Asbestos Worker', 'AAB00089',0,2 UNION ALL 
        SELECT 102, 'Asphalt Maker - Construction Industry', 'AAB00090',1,2 UNION ALL 
        SELECT 103, 'Asphalt Maker - Road Maintenance & Construction', 'AAB00091',1,2 UNION ALL 
        SELECT 104, 'Asphalt Mixer - Construction Industry', 'AAB00092',1,2 UNION ALL 
        SELECT 105, 'Asphalt Mixer - Road Maintenance & Construction', 'AAB00093',1,2 UNION ALL 
        SELECT 106, 'Asphalt Spreading Driver', 'AAB00094',1,2 UNION ALL 
        SELECT 107, 'Asphalter', 'AAB00095',0,1 UNION ALL 
        SELECT 108, 'Asphalter (hand)', 'AAB00096',1,2 UNION ALL 
        SELECT 109, 'Assembler - Aircraft/Aerospace', 'AAB00097',1,2 UNION ALL 
        SELECT 110, 'Assembler - Asbestos', 'AAB00098',1,2 UNION ALL 
        SELECT 111, 'Assembler - Electronic Goods Manufacture', 'AAB00099',1,2 UNION ALL 
        SELECT 112, 'Assembler - Leather & Fur Industries', 'AAB00100',1,2 UNION ALL 
        SELECT 113, 'Assembler - Minerals', 'AAB00101',1,2 UNION ALL 
        SELECT 114, 'Assembler - Motor Vehicle & Cycle Industry', 'AAB00102',1,2 UNION ALL 
        SELECT 115, 'Assembler - Musical Instrument Making & Repair', 'AAB00103',1,2 UNION ALL 
        SELECT 116, 'Assembler - Paper & Board Manufacture', 'AAB00104',1,2 UNION ALL 
        SELECT 117, 'Assembler - Pottery Industry', 'AAB00105',1,2 UNION ALL 
        SELECT 118, 'Assembler - Rubber Industry - Natural', 'AAB00106',1,2 UNION ALL 
        SELECT 119, 'Assembler - Textile & Clothing Industry', 'AAB00107',1,2 UNION ALL 
        SELECT 120, 'Assembler - Woodworking Industry', 'AAB00108',0,1 UNION ALL 
        SELECT 121, 'Assembly Inspector', 'AAB00109',0,1 UNION ALL 
        SELECT 122, 'Assessor (claims/insurance)   ', 'AAC02600',0,1 UNION ALL 
        SELECT 123, 'Assistant Cameraman', 'AAB00110',0,1 UNION ALL 
        SELECT 124, 'Assistant Director', 'AAB00111',0,1 UNION ALL 
        SELECT 125, 'Assistant Editor', 'AAB00112',0,1 UNION ALL 
        SELECT 126, 'Assistant Superintendent', 'AAB00113',0,1 UNION ALL 
        SELECT 127, 'Assistant Tool Pusher', 'AAB00114',0,1 UNION ALL 
        SELECT 128, 'Associate Producer', 'AAB00115',0,1 UNION ALL 
        SELECT 129, 'Assumed Non-Hazardous (for quotation only)', 'AAC02601',0,1 UNION ALL 
        SELECT 130, 'Astrologer', 'AAB00116',0,1 UNION ALL 
        SELECT 131, 'Astronomer', 'AAB00117',0,1 UNION ALL 
        SELECT 132, 'Athletics', 'AAB00118',1,2 UNION ALL 
        SELECT 133, 'Atomic Energy Worker    ', 'AAC02602',0,1 UNION ALL 
        SELECT 134, 'Amusement Arcade Worker', 'AAB00119',0,2 UNION ALL 
        SELECT 135, 'Attendant - Bingo - Entertainment', 'AAB00120',0,1 UNION ALL 
        SELECT 136, 'Attendant - Fairground etc - Entertainment', 'AAB00121',0,1 UNION ALL 
        SELECT 137, 'Auctioneer', 'AAB00122',0,1 UNION ALL 
        SELECT 138, 'Audiometrician', 'AAB00123',0,1 UNION ALL 
        SELECT 139, 'Auditor', 'AAB00124',0,1 UNION ALL 
        SELECT 140, 'Author', 'AAB00125',0,1 UNION ALL 
        SELECT 141, 'Autoclave Operator', 'AAB00126',0,1 UNION ALL 
        SELECT 142, 'Autolysis Man', 'AAB00127',0,1 UNION ALL 
        SELECT 143, 'Automatic Train Attendant', 'AAB00128',0,1 UNION ALL 
        SELECT 144, 'Average Adjuster', 'AAB00129',1,2 UNION ALL 
        SELECT 145, 'Aviation Engineer (supervisor)  ', 'AAC02603',1,2 UNION ALL 
        SELECT 146, 'Baggage Handler', 'BAB00130',0,1 UNION ALL 
        SELECT 147, 'Baggage Manager - Airport', 'BAB00131',1,2 UNION ALL 
        SELECT 148, 'Baggage Manager - Docks', 'BAB00132',1,2 UNION ALL 
        SELECT 149, 'Baggage Master', 'BAB00133',0,1 UNION ALL 
        SELECT 150, 'Baggage Porter', 'BAB00134',0,2 UNION ALL 
        SELECT 151, 'Bailiff (admin. only)   ', 'BAC02604',1,2 UNION ALL 
        SELECT 152, 'Bailiff (some site work)    ', 'BAC02605',1,2 UNION ALL 
        SELECT 153, 'Baker   ', 'BAC02606',0,1 UNION ALL 
        SELECT 154, 'Bakery Equipment Operator', 'BAB00135',0,1 UNION ALL 
        SELECT 155, 'Bakery Manager - Usually...', 'BAB00136',1,2 UNION ALL 
        SELECT 156, 'Bakery Shop Manager ', 'BAC02607',0,1 UNION ALL 
        SELECT 157, 'Baler', 'BAB00137',0,1 UNION ALL 
        SELECT 158, 'Band Leader', 'BAB00138',0,1 UNION ALL 
        SELECT 159, 'Band Mill Sawyer', 'BAB00139',0,1 UNION ALL 
        SELECT 160, 'Bank Cashier', 'BAB00140',1,2 UNION ALL 
        SELECT 161, 'Bank Clerk  ', 'BAC02608',1,2 UNION ALL 
        SELECT 162, 'Bank Staff', 'BAB00141',0,1 UNION ALL 
        SELECT 163, 'Banksman - Aircraft/Aerospace', 'BAB00142',1,2 UNION ALL 
        SELECT 164, 'Banksman - Coal Yard', 'BAB00143',1,2 UNION ALL 
        SELECT 165, 'Banksman - Construction Industry', 'BAB00144',1,2 UNION ALL 
        SELECT 166, 'Banksman - Docks', 'BAB00145',1,2 UNION ALL 
        SELECT 167, 'Banksman - Misc. Workers - Metal Manufacture', 'BAB00146',1,2 UNION ALL 
        SELECT 168, 'Banksman - Motor Vehicle & Cycle Industry', 'BAB00147',1,2 UNION ALL 
        SELECT 169, 'Banksman - Quarrying', 'BAB00148',1,2 UNION ALL 
        SELECT 170, 'Banksman - Ship Building, Ship Repair & Marine Engineering', 'BAB00149',1,2 UNION ALL 
        SELECT 171, 'Banksman - Woodworking Industry', 'BAB00150',1,2 UNION ALL 
        SELECT 172, 'Banksman (Cageman)', 'BAB00151',1,2 UNION ALL 
        SELECT 173, 'Banksman''s Assistant', 'BAB00152',0,1 UNION ALL 
        SELECT 174, 'Bar Manager/Proprietor    ', 'BAC02609',0,1 UNION ALL 
        SELECT 175, 'Bar Steward', 'BAB00153',0,1 UNION ALL 
        SELECT 176, 'Barber  ', 'BAC02610',0,1 UNION ALL 
        SELECT 177, 'Barber - Shop Manager/Proprietor  ', 'BAC02611',0,1 UNION ALL 
        SELECT 178, 'Bargeman - Merchant Marine', 'BAB00154',0,1 UNION ALL 
        SELECT 179, 'Bargeman - Quarrying', 'BAB00155',0,1 UNION ALL 
        SELECT 180, 'Bargemaster', 'BAB00156',0,1 UNION ALL 
        SELECT 181, 'Barley Roaster', 'BAB00157',0,1 UNION ALL 
        SELECT 182, 'Barmaid', 'BAB00158',0,1 UNION ALL 
        SELECT 183, 'Barman', 'BAB00159',0,1 UNION ALL 
        SELECT 184, 'Barrelman', 'BAB00160',0,1 UNION ALL 
        SELECT 185, 'Barrister   ', 'BAC02612',0,1 UNION ALL 
        SELECT 186, 'Barrister, Advocate', 'BAB00161',0,1 UNION ALL 
        SELECT 187, 'Basketball', 'BAB00162',1,2 UNION ALL 
        SELECT 188, 'Batman', 'BAB00163',0,1 UNION ALL 
        SELECT 189, 'Battery Assembler', 'BAB00164',0,1 UNION ALL 
        SELECT 190, 'Battery Repairer', 'BAB00165',0,1 UNION ALL 
        SELECT 191, 'Bear Trainer/Keeper', 'BAB00166',1,2 UNION ALL 
        SELECT 192, 'Beautician', 'BAB00167',0,1 UNION ALL 
        SELECT 193, 'Beautician Shop Manager/Proprietor    ', 'BAC02613',0,1 UNION ALL 
        SELECT 194, 'Bed & Breakfast Proprietor  ', 'BAC02614',0,1 UNION ALL 
        SELECT 195, 'Beekeeper, Apiarist', 'BAB00168',0,1 UNION ALL 
        SELECT 196, 'Belt Maker', 'BAB00169',0,1 UNION ALL 
        SELECT 197, 'Belt Patrol Man', 'BAB00170',0,1 UNION ALL 
        SELECT 198, 'Bench Hand - Production Fitting - Metal Manufacture', 'BAB00171',0,1 UNION ALL 
        SELECT 199, 'Bench Hand - Rubber Industry - Natural', 'BAB00172',0,1 UNION ALL 
        SELECT 200, 'Berthing Superintendent', 'BAB00173',0,1 UNION ALL 
        SELECT 201, 'Betting shop manager (on course)    ', 'BAC02615',0,1 UNION ALL 
        SELECT 202, 'Betting shop manager (shop based) ', 'BAC02616',0,1 UNION ALL 
        SELECT 203, 'Bicycle Repairman   ', 'BAC02617',1,2 UNION ALL 
        SELECT 204, 'Bill Poster/Sticker', 'BAB00174',0,1 UNION ALL 
        SELECT 205, 'Billiards', 'BAB00175',1,2 UNION ALL 
        SELECT 206, 'Bindery Assistant', 'BAB00176',0,1 UNION ALL 
        SELECT 207, 'Binding Machine Attendant', 'BAB00177',0,1 UNION ALL 
        SELECT 208, 'Biochemist  ', 'BAC02618',0,1 UNION ALL 
        SELECT 209, 'Biochemist - Lecturing and research', 'BAC02619',0,1 UNION ALL 
        SELECT 210, 'Biological scientist    ', 'BAC02620',0,1 UNION ALL 
        SELECT 211, 'Biologist (No travel/ underwater)', 'BAB00178',0,1 UNION ALL 
        SELECT 212, 'Biologist (Overseas travel)', 'BAB00179',0,1 UNION ALL 
        SELECT 213, 'Biologist (Underwater work)', 'BAB00180',0,1 UNION ALL 
        SELECT 214, 'Biscuit Baker', 'BAB00181',0,1 UNION ALL 
        SELECT 215, 'Blacksmith', 'BAB00182',0,1 UNION ALL 
        SELECT 216, 'Blancher', 'BAB00183',0,1 UNION ALL 
        SELECT 217, 'Bleacher - Paper & Board Manufacture', 'BAB00184',0,1 UNION ALL 
        SELECT 218, 'Bleacher - Textile & Clothing Industry', 'BAB00185',0,1 UNION ALL 
        SELECT 219, 'Blender', 'BAB00186',0,1 UNION ALL 
        SELECT 220, 'Block Cutter', 'BAB00187',0,1 UNION ALL 
        SELECT 221, 'Boarding School Matron', 'BAB00188',0,1 UNION ALL 
        SELECT 222, 'Boat Builder', 'BAB00189',0,1 UNION ALL 
        SELECT 223, 'Boatswain - Fishing Industry', 'BAB00190',0,1 UNION ALL 
        SELECT 224, 'Boatswain - Merchant Marine', 'BAB00191',0,1 UNION ALL 
        SELECT 225, 'Boatswain''s Mate', 'BAB00192',0,1 UNION ALL 
        SELECT 226, 'Bodyguard', 'BAB00193',0,2 UNION ALL 
        SELECT 227, 'Boiler - Confectionery etc - Food & Drink', 'BAB00194',0,1 UNION ALL 
        SELECT 228, 'Boiler - Fruit & Veg. - Food & Drink', 'BAB00195',0,1 UNION ALL 
        SELECT 229, 'Boiler - Meat, Fish etc - Food & Drink', 'BAB00196',0,1 UNION ALL 
        SELECT 230, 'Boiler Cleaner', 'BAB00197',0,1 UNION ALL 
        SELECT 231, 'Boiler Operator - Electrical Supply', 'BAB00198',0,1 UNION ALL 
        SELECT 232, 'Boiler Operator - Water Supply Industry', 'BAB00199',0,1 UNION ALL 
        SELECT 233, 'Boiler Operator/Fireman', 'BAB00200',0,1 UNION ALL 
        SELECT 234, 'Bomb Disposal - Elsewhere', 'BAB00201',0,1 UNION ALL 
        SELECT 235, 'Bomb Disposal - Mainland Britain', 'BAB00202',0,1 UNION ALL 
        SELECT 236, 'Book Illustrator', 'BAB00203',0,1 UNION ALL 
        SELECT 237, 'Bookbinder', 'BAB00205',0,1 UNION ALL 
        SELECT 238, 'Book-Keeper', 'BAB00204',0,1 UNION ALL 
        SELECT 239, 'Bookmaker - On course', 'BAB00206',0,1 UNION ALL 
        SELECT 240, 'Bookmaker - Shop Manager', 'BAB00207',0,1 UNION ALL 
        SELECT 241, 'Bookmaker - Shop Owner', 'BAB00208',0,1 UNION ALL 
        SELECT 242, 'Bookmaker - Shop Staff', 'BAB00209',0,1 UNION ALL 
        SELECT 243, 'Boom Operator', 'BAB00210',0,1 UNION ALL 
        SELECT 244, 'Borer - Mining', 'BAB00212',0,1 UNION ALL 
        SELECT 245, 'Borer - Tunnelling', 'BAB00211',0,1 UNION ALL 
        SELECT 246, 'Borstal Matron', 'BAB00213',0,1 UNION ALL 
        SELECT 247, 'Bosun (Third Hand)', 'BAB00214',0,1 UNION ALL 
        SELECT 248, 'Botanist (No overseas field work)', 'BAB00215',0,1 UNION ALL 
        SELECT 249, 'Bottle Washer (hand or machine)', 'BAB00216',0,1 UNION ALL 
        SELECT 250, 'Bottling Machine Attendant', 'BAB00217',0,1 UNION ALL 
        SELECT 251, 'Box Maker', 'BAB00218',0,1 UNION ALL 
        SELECT 252, 'Box Office Cashier - Cinema - Entertainment', 'BAB00219',1,2 UNION ALL 
        SELECT 253, 'Box Office Cashier - Circus - Entertainment', 'BAB00220',1,2 UNION ALL 
        SELECT 254, 'Box Office Clerk - Cinema - Entertainment', 'BAB00221',1,2 UNION ALL 
        SELECT 255, 'Box Office Clerk - Circus - Entertainment', 'BAB00222',1,2 UNION ALL 
        SELECT 256, 'Box Office Clerk - Theatre, Ballet etc - Entertainment', 'BAB00223',1,2 UNION ALL 
        SELECT 257, 'Box Office Manager', 'BAB00224',0,1 UNION ALL 
        SELECT 258, 'Boxing', 'BAB00225',1,2 UNION ALL 
        SELECT 259, 'Brakesman', 'BAB00226',0,1 UNION ALL 
        SELECT 260, 'Brazer', 'BAB00227',0,1 UNION ALL 
        SELECT 261, 'Bread Baker', 'BAB00228',0,1 UNION ALL 
        SELECT 262, 'Bread Roundsman', 'BAB00229',0,1 UNION ALL 
        SELECT 263, 'Brewer', 'BAB00230',0,1 UNION ALL 
        SELECT 264, 'Brewery Manager', 'BAB00231',0,1 UNION ALL 
        SELECT 265, 'Bricklayer', 'BAB00232',0,1 UNION ALL 
        SELECT 266, 'Bridge Man', 'BAB00233',0,1 UNION ALL 
        SELECT 267, 'Briner - Fruit & Veg. - Food & Drink', 'BAB00234',1,2 UNION ALL 
        SELECT 268, 'Briner - Meat, Fish etc - Food & Drink', 'BAB00235',1,2 UNION ALL 
        SELECT 269, 'Bronzer', 'BAB00236',0,1 UNION ALL 
        SELECT 270, 'Broom/Brush Maker', 'BAB00237',0,1 UNION ALL 
        SELECT 271, 'Buffet Car Attendant', 'BAB00238',0,1 UNION ALL 
        SELECT 272, 'Builder ', 'BAC02621',0,1 UNION ALL 
        SELECT 273, 'Builder - Building and construction    ', 'BAC02622',1,2 UNION ALL 
        SELECT 274, 'Building Inspector', 'BAB00239',0,1 UNION ALL 
        SELECT 275, 'Building Site Agent - Building and construction   ', 'BAC02623',0,1 UNION ALL 
        SELECT 276, 'Building Society Cashier', 'BAB00240',1,2 UNION ALL 
        SELECT 277, 'Building Society Supervisor ', 'BAC02624',1,2 UNION ALL 
        SELECT 278, 'Building Surveyor', 'BAB00241',0,1 UNION ALL 
        SELECT 279, 'Building Technician', 'BAB00242',1,2 UNION ALL 
        SELECT 280, 'Bulldozer Driver', 'BAB00243',0,1 UNION ALL 
        SELECT 281, 'Bunker Control Man - Marshalling/Goods Yard - Railways', 'BAB00245',1,2 UNION ALL 
        SELECT 282, 'Bunker Control Man - Quarrying', 'BAB00244',1,2 UNION ALL 
        SELECT 283, 'Bunker Control Man (automatic)', 'BAB00246',1,2 UNION ALL 
        SELECT 284, 'Bunker Control Man (semi-auto/manual)', 'BAB00247',1,2 UNION ALL 
        SELECT 285, 'Burglar Alarm Fitter    ', 'BAC02625',0,1 UNION ALL 
        SELECT 286, 'Burner', 'BAB00248',1,2 UNION ALL 
        SELECT 287, 'Burster', 'BAB00249',1,2 UNION ALL 
        SELECT 288, 'Bus Conductor (No driving)', 'BAB00250',0,1 UNION ALL 
        SELECT 289, 'Bus Driver', 'BAB00251',0,1 UNION ALL 
        SELECT 290, 'Bus Inspector', 'BAB00252',0,1 UNION ALL 
        SELECT 291, 'Business Consultant', 'BAB00253',0,2 UNION ALL 
        SELECT 292, 'Business Premises Cleaner', 'BAB00254',1,2 UNION ALL 
        SELECT 293, 'Butcher', 'BAB00255',0,1 UNION ALL 
        SELECT 294, 'Butcher Shop Manager    ', 'BAC02626',1,2 UNION ALL 
        SELECT 295, 'Butcher Shop Proprietor ', 'BAC02627',0,1 UNION ALL 
        SELECT 296, 'Butler', 'BAB00256',0,1 UNION ALL 
        SELECT 297, 'Butter Blender', 'BAB00257',0,1 UNION ALL 
        SELECT 298, 'Butter Maker', 'BAB00258',0,1 UNION ALL 
        SELECT 299, 'Buyer - retail', 'BAC02628',0,2 UNION ALL 
        SELECT 300, 'Cabin Boy', 'CAB00259',0,1 UNION ALL 
        SELECT 301, 'Cabinet Maker', 'CAB00260',0,1 UNION ALL 
        SELECT 302, 'Cable Former', 'CAB00261',0,1 UNION ALL 
        SELECT 303, 'Cable Hand', 'CAB00262',0,1 UNION ALL 
        SELECT 304, 'Cable Jointer', 'CAB00263',0,1 UNION ALL 
        SELECT 305, 'Cable Laying Diver', 'CAB00264',0,1 UNION ALL 
        SELECT 306, 'Cable Tester', 'CAB00265',0,1 UNION ALL 
        SELECT 307, 'Cafe Cashier', 'CAB00266',0,1 UNION ALL 
        SELECT 308, 'Cafe Manager    ', 'CAC02629',0,1 UNION ALL 
        SELECT 309, 'Cafe Proprietor (Licensed)', 'CAB00267',0,1 UNION ALL 
        SELECT 310, 'Cafe Proprietor (Unlicensed)', 'CAB00268',0,1 UNION ALL 
        SELECT 311, 'Calender Hand', 'CAB00269',1,2 UNION ALL 
        SELECT 312, 'Calibrator', 'CAB00270',0,1 UNION ALL 
        SELECT 313, 'Caller', 'CAB00271',0,1 UNION ALL 
        SELECT 314, 'Calligrapher    ', 'CAC02630',0,1 UNION ALL 
        SELECT 315, 'Camera Repair Technician    ', 'CAC02631',0,1 UNION ALL 
        SELECT 316, 'Cameraman', 'CAB00272',1,2 UNION ALL 
        SELECT 317, 'Cameraman Studio', 'CAB00273',0,2 UNION ALL 
        SELECT 318, 'Cameraman - otherwise', 'CAB00274',1,2 UNION ALL 
        SELECT 319, 'Candle Maker', 'CAB00275',0,1 UNION ALL 
        SELECT 320, 'Canine Beautician', 'CAB00276',0,1 UNION ALL 
        SELECT 321, 'Canine Behaviourist ', 'CAC02632',0,1 UNION ALL 
        SELECT 322, 'Canning Machine Attendant', 'CAB00277',0,1 UNION ALL 
        SELECT 323, 'Canteen Assistant', 'CAB00278',0,1 UNION ALL 
        SELECT 324, 'Canteen Manager', 'CAB00279',0,1 UNION ALL 
        SELECT 325, 'Canvasser', 'CAB00280',0,1 UNION ALL 
        SELECT 326, 'Captain - Merchant Marine', 'CAB00282',0,1 UNION ALL 
        SELECT 327, 'Captain - Oil & Natural Gas Industries', 'CAB00281',0,2 UNION ALL 
        SELECT 328, 'Captain/Commander', 'CAB00283',1,2 UNION ALL 
        SELECT 329, 'Car Delivery Driver', 'CAB00284',0,1 UNION ALL 
        SELECT 330, 'Car Hire Company Proprietor (admin. and driving)    ', 'CAC02633',0,1 UNION ALL 
        SELECT 331, 'Car Lasher', 'CAB00285',0,1 UNION ALL 
        SELECT 332, 'Car Park Attendant', 'CAB00286',0,1 UNION ALL 
        SELECT 333, 'Car Rental Company Manager  ', 'CAC02634',0,1 UNION ALL 
        SELECT 334, 'Car Salesman (S/E or commission)', 'CAB00287',0,1 UNION ALL 
        SELECT 335, 'Car Salesman (Salaried)', 'CAB00288',0,1 UNION ALL 
        SELECT 336, 'Car Valeter', 'CAB00289',0,1 UNION ALL 
        SELECT 337, 'Carbon Printer', 'CAB00290',0,1 UNION ALL 
        SELECT 338, 'Carbonation Man', 'CAB00291',0,1 UNION ALL 
        SELECT 339, 'Carboniser', 'CAB00292',0,1 UNION ALL 
        SELECT 340, 'Care Assistant', 'CAB00293',0,1 UNION ALL 
        SELECT 341, 'Care Worker - Residential ', 'CAC02635',0,1 UNION ALL 
        SELECT 342, 'Careers Advisor ', 'CAC02636',0,1 UNION ALL 
        SELECT 343, 'Caretaker, Janitor', 'CAB00294',0,1 UNION ALL 
        SELECT 344, 'Cargo Clerk', 'CAB00295',0,1 UNION ALL 
        SELECT 345, 'Cargo Superintendent', 'CAB00296',0,1 UNION ALL 
        SELECT 346, 'Carpenter - Construction Industry', 'CAB00297',0,1 UNION ALL 
        SELECT 347, 'Carpenter - Film Industry - Entertainment', 'CAB00298',0,1 UNION ALL 
        SELECT 348, 'Carpenter & Joiner', 'CAB00299',0,1 UNION ALL 
        SELECT 349, 'Carpet Cleaner  ', 'CAC02637',0,1 UNION ALL 
        SELECT 350, 'Carpet Company director (office based admin. only)   ', 'CAC02638',0,1 UNION ALL 
        SELECT 351, 'Carpet Designer ', 'CAC02639',0,1 UNION ALL 
        SELECT 352, 'Carpet Fitter', 'CAB00300',0,1 UNION ALL 
        SELECT 353, 'Carpet Salesman ', 'CAC02640',0,1 UNION ALL 
        SELECT 354, 'Carpet Salesman & Remming   ', 'CAC02641',1,2 UNION ALL 
        SELECT 355, 'Carpet Shop Assistant   ', 'CAC02642',0,1 UNION ALL 
        SELECT 356, 'Carpet Shop Manager (admin.) ', 'CAC02643',0,1 UNION ALL 
        SELECT 357, 'Carpet Shop Owner (no manual duties) ', 'CAC02644',0,1 UNION ALL 
        SELECT 358, 'Carriage Examiner', 'CAB00301',0,1 UNION ALL 
        SELECT 359, 'Carriage Cleaner', 'CAB00302',0,2 UNION ALL 
        SELECT 360, 'Cartographer', 'CAB00303',0,1 UNION ALL 
        SELECT 361, 'Cartoonist', 'CAB00304',0,1 UNION ALL 
        SELECT 362, 'Cartridge Filler', 'CAB00305',0,1 UNION ALL 
        SELECT 363, 'Car Wash Attendant', 'CAB00306',0,2 UNION ALL 
        SELECT 364, 'Cashier - Bank, building society    ', 'CAC02645',0,1 UNION ALL 
        SELECT 365, 'Cashier - Bingo - Entertainment', 'CAB00307',1,2 UNION ALL 
        SELECT 366, 'Cashier - Dance Hall, Disco etc - Entertainment', 'CAB00308',1,2 UNION ALL 
        SELECT 367, 'Cashier - Shop, cafe, supermarket, bingo', 'CAC02646',0,2 UNION ALL 
        SELECT 368, 'Casino Cashier', 'CAB00309',0,1 UNION ALL 
        SELECT 369, 'Caster', 'CAB00310',0,1 UNION ALL 
        SELECT 370, 'Casting Director', 'CAB00311',0,1 UNION ALL 
        SELECT 371, 'Casting Machine Operator', 'CAB00312',0,1 UNION ALL 
        SELECT 372, 'Caterer - offshore/at sea', 'CAC02647',0,2 UNION ALL 
        SELECT 373, 'Caterer, Catering Manager', 'CAB00313',1,2 UNION ALL 
        SELECT 374, 'Catering Assistant  ', 'CAC02648',0,1 UNION ALL 
        SELECT 375, 'Catering Boy', 'CAB00314',1,2 UNION ALL 
        SELECT 376, 'Catering Manager    ', 'CAC02649',0,1 UNION ALL 
        SELECT 377, 'Catering Officer', 'CAB00315',1,2 UNION ALL 
        SELECT 378, 'Catering Staff', 'CAB00316',1,2 UNION ALL 
        SELECT 379, 'Catering Supervisor ', 'CAC02650',1,2 UNION ALL 
        SELECT 380, 'Cathead Man', 'CAB00317',0,1 UNION ALL 
        SELECT 381, 'Cattle Market Auctioneer (handles livestock) ', 'CAC02651',1,2 UNION ALL 
        SELECT 382, 'Caulker - Aircraft/Aerospace', 'CAB00318',1,2 UNION ALL 
        SELECT 383, 'Caulker - Construction Industry', 'CAB00319',1,2 UNION ALL 
        SELECT 384, 'Caulker - Motor Vehicle & Cycle Industry', 'CAB00321',1,2 UNION ALL 
        SELECT 385, 'Caulker - Pipe, Sheet, Wire etc - Metal Manufacture', 'CAB00320',1,2 UNION ALL 
        SELECT 386, 'Caulker - Ship Building, Ship Repair & Marine Engineering', 'CAB00322',1,2 UNION ALL 
        SELECT 387, 'Ceiling Fixer', 'CAB00323',0,1 UNION ALL 
        SELECT 388, 'Cell Tester', 'CAB00324',0,1 UNION ALL 
        SELECT 389, 'Cementer', 'CAB00325',0,1 UNION ALL 
        SELECT 390, 'Cementer (oil rig industry) ', 'CAC02652',1,2 UNION ALL 
        SELECT 391, 'Ceramicist', 'CAB00326',0,1 UNION ALL 
        SELECT 392, 'Ceramics Technologist', 'CAB00327',1,2 UNION ALL 
        SELECT 393, 'Chain Maker', 'CAB00328',0,1 UNION ALL 
        SELECT 394, 'Chair Maker', 'CAB00329',0,1 UNION ALL 
        SELECT 395, 'Chambermaid - Housekeeper   ', 'CAC02653',0,1 UNION ALL 
        SELECT 396, 'Charge Nurse', 'CAB00330',0,1 UNION ALL 
        SELECT 397, 'Chartered Engineer (some site duties)   ', 'CAC02654',0,1 UNION ALL 
        SELECT 398, 'Chartered Engineered (admin. only)  ', 'CAC02655',0,1 UNION ALL 
        SELECT 399, 'Chartered Surveyor (admin only) ', 'CAC02656',0,1 UNION ALL 
        SELECT 400, 'Chartered Surveyor (some site duties)   ', 'CAC02657',0,1 UNION ALL 
        SELECT 401, 'Chaser', 'CAB00331',1,2 UNION ALL 
        SELECT 402, 'Chassis Builder', 'CAB00332',0,1 UNION ALL 
        SELECT 403, 'Chauffeur', 'CAB00333',0,1 UNION ALL 
        SELECT 404, 'Check Weighman', 'CAB00334',1,2 UNION ALL 
        SELECT 405, 'Cheese Cook', 'CAB00335',1,2 UNION ALL 
        SELECT 406, 'Chef', 'CAB00336',0,1 UNION ALL 
        SELECT 407, 'Chef/Cook - Head', 'CAB00337',1,2 UNION ALL 
        SELECT 408, 'Chef/Cook - Not Head', 'CAB00338',1,2 UNION ALL 
        SELECT 409, 'Chemical Engineer - Adhesives Manufacture', 'CAB00339',1,2 UNION ALL 
        SELECT 410, 'Chemical engineer - offshore', 'CAB00340',0,2 UNION ALL 
        SELECT 411, 'Chemical Engineer -inc. testing', 'CAB00341',1,2 UNION ALL 
        SELECT 412, 'Chemical Engineer -no testing etc', 'CAB00342',1,2 UNION ALL 
        SELECT 413, 'Chemical Engineering Technician', 'CAB00343',1,2 UNION ALL 
        SELECT 414, 'Chemical Plumber', 'CAB00344',0,1 UNION ALL 
        SELECT 415, 'Chemical Plumber''s Mate', 'CAB00345',0,1 UNION ALL 
        SELECT 416, 'Chemist - Adhesives Manufacture', 'CAB00346',1,2 UNION ALL 
        SELECT 417, 'Chemist - Chemical & Plastics Industry', 'CAB00347',1,2 UNION ALL 
        SELECT 418, 'Chemist - Explosives Manufacture', 'CAB00348',1,2 UNION ALL 
        SELECT 419, 'Chemist - Food & Drink - General', 'CAB00349',1,2 UNION ALL 
        SELECT 420, 'Chemist - Glass/Glass Fibre Manufacture', 'CAB00350',1,2 UNION ALL 
        SELECT 421, 'Chemist - Minerals', 'CAB00352',1,2 UNION ALL 
        SELECT 422, 'Chemist - Mining', 'CAB00353',1,2 UNION ALL 
        SELECT 423, 'Chemist - Misc. Workers - Metal Manufacture', 'CAB00351',1,2 UNION ALL 
        SELECT 424, 'Chemist - Oil Refining', 'CAB00354',1,2 UNION ALL 
        SELECT 425, 'Chemist - Paper & Board Manufacture', 'CAB00355',1,2 UNION ALL 
        SELECT 426, 'Chemist - Photographic Processing Industry', 'CAB00356',1,2 UNION ALL 
        SELECT 427, 'Chemist - Printing Industry', 'CAB00357',1,2 UNION ALL 
        SELECT 428, 'Chemist - Rubber Industry - Natural', 'CAB00358',1,2 UNION ALL 
        SELECT 429, 'Chemist - Textile & Clothing Industry', 'CAB00359',1,2 UNION ALL 
        SELECT 430, 'Chemist - Tobacco Industry', 'CAB00360',1,2 UNION ALL 
        SELECT 431, 'Chief Cameraman', 'CAB00361',1,2 UNION ALL 
        SELECT 432, 'Chief Engineer', 'CAB00362',1,2 UNION ALL 
        SELECT 433, 'Chief Officer', 'CAB00363',1,2 UNION ALL 
        SELECT 434, 'Chief Operator', 'CAB00364',1,2 UNION ALL 
        SELECT 435, 'Chief Security Officer', 'CAB00365',1,2 UNION ALL 
        SELECT 436, 'Chief/First Officer etc', 'CAB00366',1,2 UNION ALL 
        SELECT 437, 'Chief/Second Steward', 'CAB00367',1,2 UNION ALL 
        SELECT 438, 'Child Protection Co-ordinator   ', 'CAC02658',0,1 UNION ALL 
        SELECT 439, 'Child Welfare Officer   ', 'CAC02659',0,1 UNION ALL 
        SELECT 440, 'Childminder', 'CAB00368',0,2 UNION ALL 
        SELECT 441, 'Childminder (Part time)', 'CAB00369',1,2 UNION ALL 
        SELECT 442, 'Children''s Inspector', 'CAB00370',0,1 UNION ALL 
        SELECT 443, 'Children''s Matron', 'CAB00371',0,1 UNION ALL 
        SELECT 444, 'Children''s Nursery Proprietor   ', 'CAC02660',0,1 UNION ALL 
        SELECT 445, 'Children''s Play-group Leader    ', 'CAC02661',0,1 UNION ALL 
        SELECT 446, 'Chimney Sweep', 'CAB00372',0,1 UNION ALL 
        SELECT 447, 'Chip Shop Owner ', 'CAC02662',0,1 UNION ALL 
        SELECT 448, 'Chip/Money Changer', 'CAB00373',0,1 UNION ALL 
        SELECT 449, 'Chipper & Painter', 'CAB00374',0,1 UNION ALL 
        SELECT 450, 'Chipper (hand)', 'CAB00375',0,1 UNION ALL 
        SELECT 451, 'Chipping Driver', 'CAB00376',0,1 UNION ALL 
        SELECT 452, 'Chiropodist', 'CAB00377',0,1 UNION ALL 
        SELECT 453, 'Chiropracter', 'CAB00378',0,1 UNION ALL 
        SELECT 454, 'Choreographer', 'CAB00379',1,2 UNION ALL 
        SELECT 455, 'Christian Education Preacher    ', 'CAC02663',1,2 UNION ALL 
        SELECT 456, 'Christian Scientist', 'CAB00380',1,2 UNION ALL 
        SELECT 457, 'Chromium Plater', 'CAB00381',1,2 UNION ALL 
        SELECT 458, 'Church Organist ', 'CAC02664',0,1 UNION ALL 
        SELECT 459, 'Circular Sawyer', 'CAB00382',1,2 UNION ALL 
        SELECT 460, 'Circus Hand', 'CAB00383',0,1 UNION ALL 
        SELECT 461, 'Civil Aircraft Ground Crew Member   ', 'CAC02665',1,2 UNION ALL 
        SELECT 462, 'Civil Engineer - Construction Industry', 'CAB00384',1,2 UNION ALL 
        SELECT 463, 'Civil Engineer - Tunnelling', 'CAB00385',1,2 UNION ALL 
        SELECT 464, 'Civil Servant - Administrative Grade', 'CAB00386',1,2 UNION ALL 
        SELECT 465, 'Civil Servant - Clerical Grade', 'CAB00387',1,2 UNION ALL 
        SELECT 466, 'Civil Servant - Executive Grade', 'CAB00388',1,2 UNION ALL 
        SELECT 467, 'Civil Servant - Other', 'CAB00389',1,2 UNION ALL 
        SELECT 468, 'Claims Adjuster', 'CAB00390',0,1 UNION ALL 
        SELECT 469, 'Claims Assessor', 'CAB00391',0,1 UNION ALL 
        SELECT 470, 'Clammer', 'CAB00392',1,2 UNION ALL 
        SELECT 471, 'Clapper Boy', 'CAB00393',1,2 UNION ALL 
        SELECT 472, 'Classical Musician', 'CAB00394',1,2 UNION ALL 
        SELECT 473, 'Clay Getter', 'CAB00395',1,2 UNION ALL 
        SELECT 474, 'Cleaner - Asbestos', 'CAB00396',1,2 UNION ALL 
        SELECT 475, 'Cleaner - Beer, Wine etc - Food & Drink', 'CAB00397',1,2 UNION ALL 
        SELECT 476, 'Cleaner - domestic premises', 'CAC02666',0,2 UNION ALL 
        SELECT 477, 'Cleaner - Stoneworking', 'CAB00398',1,2 UNION ALL 
        SELECT 478, 'Cleaner (Boilers,Machinery,Pipes)', 'CAB00399',1,2 UNION ALL 
        SELECT 479, 'Cleaner (hand)', 'CAB00400',1,2 UNION ALL 
        SELECT 480, 'Cleaner (machines)', 'CAB00401',1,2 UNION ALL 
        SELECT 481, 'Cleaner (Machines)', 'CAB00402',1,2 UNION ALL 
        SELECT 482, 'Cleaner (Stone, Brickwork)', 'CAB00403',1,2 UNION ALL 
        SELECT 483, 'Cleaning Contractor (company owner, all aspects) ', 'CAC02667',1,2 UNION ALL 
        SELECT 484, 'Cleaning Contractors Manager    ', 'CAC02668',1,2 UNION ALL 
        SELECT 485, 'Cleaning Plant Operator', 'CAB00404',1,2 UNION ALL 
        SELECT 486, 'Clergy', 'CAB00405',0,2 UNION ALL 
        SELECT 487, 'Clerical Staff', 'CAB00406',0,1 UNION ALL 
        SELECT 488, 'Clerical Worker', 'CAB00407',0,1 UNION ALL 
        SELECT 489, 'Clerical Worker - Oil Rig Industry  ', 'CAC02669',1,2 UNION ALL 
        SELECT 490, 'Clerk   ', 'CAC02670',1,2 UNION ALL 
        SELECT 491, 'Clerk (Ticket, Freight)', 'CAB00408',1,2 UNION ALL 
        SELECT 492, 'Clerk of Works', 'CAB00409',0,1 UNION ALL 
        SELECT 493, 'Clinic Nurse', 'CAB00410',1,2 UNION ALL 
        SELECT 494, 'Clipper', 'CAB00411',1,2 UNION ALL 
        SELECT 495, 'Cloakroom Attendant - Club/Nightclub - Entertainment', 'CAB00412',0,1 UNION ALL 
        SELECT 496, 'Cloakroom Attendant - Theatre, Ballet etc - Entertainment', 'CAB00413',0,1 UNION ALL 
        SELECT 497, 'Clock & Watch Assembler', 'CAB00414',0,1 UNION ALL 
        SELECT 498, 'Clock/Watch Maker', 'CAB00415',0,1 UNION ALL 
        SELECT 499, 'Clock/Watch Repairer', 'CAB00416',0,1 UNION ALL 
        SELECT 500, 'Cloth Cutter', 'CAB00417',0,1 UNION ALL 
        SELECT 501, 'Clothing Designer   ', 'CAC02671',0,1 UNION ALL 
        SELECT 502, 'Clothing Worker ', 'CAC02672',1,2 UNION ALL 
        SELECT 503, 'Clown', 'CAB00418',0,1 UNION ALL 
        SELECT 504, 'Club Manager', 'CAB00419',0,1 UNION ALL 
        SELECT 505, 'Club Proprietor', 'CAB00420',0,1 UNION ALL 
        SELECT 506, 'Club Steward', 'CAB00421',0,1 UNION ALL 
        SELECT 507, 'CNC Lathe Operator', 'CAB00422',1,2 UNION ALL 
        SELECT 508, 'Coach - Sports - Full time', 'CAB00423',1,2 UNION ALL 
        SELECT 509, 'Coach - Sports - Part time', 'CAB00424',1,2 UNION ALL 
        SELECT 510, 'Coach Body Maker', 'CAB00425',1,2 UNION ALL 
        SELECT 511, 'Coach Builder', 'CAB00426',1,2 UNION ALL 
        SELECT 512, 'Coach Driver', 'CAB00427',0,1 UNION ALL 
        SELECT 513, 'Coach Painter', 'CAB00428',0,1 UNION ALL 
        SELECT 514, 'Coach Trimmer (Vehicles)', 'CAB00429',1,2 UNION ALL 
        SELECT 515, 'Coachman', 'CAB00430',1,2 UNION ALL 
        SELECT 516, 'Coal Cutter Mover', 'CAB00431',0,1 UNION ALL 
        SELECT 517, 'Coal Cutterman', 'CAB00432',0,1 UNION ALL 
        SELECT 518, 'Coal Dry Cleaning Plant Operator', 'CAB00433',0,1 UNION ALL 
        SELECT 519, 'Coal Face Workers', 'CAB00434',0,1 UNION ALL 
        SELECT 520, 'Coal Melter', 'CAB00435',0,1 UNION ALL 
        SELECT 521, 'Coal Merchant - admin only', 'CAB00436',0,1 UNION ALL 
        SELECT 522, 'Coal Merchant - some delivery', 'CAB00437',0,1 UNION ALL 
        SELECT 523, 'Coal Trimmer', 'CAB00438',0,1 UNION ALL 
        SELECT 524, 'Coal Washery Operator', 'CAB00439',0,1 UNION ALL 
        SELECT 525, 'Coal Yard Foreman', 'CAB00440',0,1 UNION ALL 
        SELECT 526, 'Coal Yard Man', 'CAB00441',0,1 UNION ALL 
        SELECT 527, 'Coastguard (Office based)', 'CAB00442',0,1 UNION ALL 
        SELECT 528, 'Coastguard (Otherwise)', 'CAB00443',0,1 UNION ALL 
        SELECT 529, 'Coffin Maker', 'CAB00444',0,1 UNION ALL 
        SELECT 530, 'Coil Former', 'CAB00445',0,1 UNION ALL 
        SELECT 531, 'Coil Winder', 'CAB00446',0,1 UNION ALL 
        SELECT 532, 'Collector Salesman  ', 'CAC02673',1,2 UNION ALL 
        SELECT 533, 'College Lecturer', 'CAB00447',0,2 UNION ALL 
        SELECT 534, 'Collier', 'CAB00448',1,2 UNION ALL 
        SELECT 535, 'Colour Calculator', 'CAB00449',0,1 UNION ALL 
        SELECT 536, 'Colour Matcher', 'CAB00450',0,1 UNION ALL 
        SELECT 537, 'Colour Mixer', 'CAB00451',0,1 UNION ALL 
        SELECT 538, 'Columnist', 'CAB00452',0,1 UNION ALL 
        SELECT 539, 'Comedian', 'CAB00453',0,1 UNION ALL 
        SELECT 540, 'Commentator - no overseas travel etc', 'CAB00454',0,2 UNION ALL 
        SELECT 541, 'Commentator - otherwise', 'CAB00455',0,1 UNION ALL 
        SELECT 542, 'Commercial Diving', 'CAB00456',0,1 UNION ALL 
        SELECT 543, 'Commercial Manager (office sales)   ', 'CAC02674',0,1 UNION ALL 
        SELECT 544, 'Commercial Pilots', 'CAB00457',0,1 UNION ALL 
        SELECT 545, 'Commercial Traveller    ', 'CAC02675',0,1 UNION ALL 
        SELECT 546, 'Commissionaire', 'CAB00458',0,1 UNION ALL 
        SELECT 547, 'Commodity Broker', 'CAB00459',1,2 UNION ALL 
        SELECT 548, 'Community Nurse', 'CAB00460',0,1 UNION ALL 
        SELECT 549, 'Community Worker    ', 'CAC02676',1,2 UNION ALL 
        SELECT 550, 'Company Director    ', 'CAC02677',1,2 UNION ALL 
        SELECT 551, 'Company Director - Usually...', 'CAB00461',1,2 UNION ALL 
        SELECT 552, 'Company Director (admin. duties only)   ', 'CAC02678',0,1 UNION ALL 
        SELECT 553, 'Company Secretary   ', 'CAC02679',0,1 UNION ALL 
        SELECT 554, 'Compass Adjuster', 'CAB00462',0,1 UNION ALL 
        SELECT 555, 'Compliance Manager', 'CAC02680',0,1 UNION ALL 
        SELECT 556, 'Composer', 'CAB00463',0,1 UNION ALL 
        SELECT 557, 'Compositor', 'CAB00464',0,1 UNION ALL 
        SELECT 558, 'Compounder', 'CAB00465',0,1 UNION ALL 
        SELECT 559, 'Computer Analyst    ', 'CAC02681',0,1 UNION ALL 
        SELECT 560, 'Computer Company Technical Support Manager  ', 'CAC02682',0,1 UNION ALL 
        SELECT 561, 'Computer Operator', 'CAB00466',0,1 UNION ALL 
        SELECT 562, 'Computer Programmer ', 'CAC02683',0,1 UNION ALL 
        SELECT 563, 'Computer Programmer/Analyst', 'CAB00467',0,1 UNION ALL 
        SELECT 564, 'Computer Salesman (office based) ', 'CAC02684',0,1 UNION ALL 
        SELECT 565, 'Computer Software Manager   ', 'CAC02685',0,1 UNION ALL 
        SELECT 566, 'Computer Software Salesman (includes travelling) ', 'CAC02686',0,1 UNION ALL 
        SELECT 567, 'Computer Systems Installer  ', 'CAC02687',0,1 UNION ALL 
        SELECT 568, 'Computer Wirer  ', 'CAC02688',0,1 UNION ALL 
        SELECT 569, 'Computer Workshop Technical Engineer    ', 'CAC02689',0,1 UNION ALL 
        SELECT 570, 'Concert Promoter    ', 'CAC02690',0,1 UNION ALL 
        SELECT 571, 'Concrete Erector - 40'' up', 'CAB00468',0,1 UNION ALL 
        SELECT 572, 'Concrete Erector - up to 40''', 'CAB00469',0,1 UNION ALL 
        SELECT 573, 'Concrete Finisher', 'CAB00470',0,1 UNION ALL 
        SELECT 574, 'Concrete Paving Driver', 'CAB00471',0,1 UNION ALL 
        SELECT 575, 'Concrete Shutterer', 'CAB00472',0,1 UNION ALL 
        SELECT 576, 'Concreter', 'CAB00473',0,1 UNION ALL 
        SELECT 577, 'Conductor - Music Industry - Entertainment', 'CAB00474',0,1 UNION ALL 
        SELECT 578, 'Conductor - Train Crew - Railways', 'CAB00475',0,1 UNION ALL 
        SELECT 579, 'Confectioner    ', 'CAC02691',0,1 UNION ALL 
        SELECT 580, 'Conference Organising Assistant ', 'CAC02692',0,1 UNION ALL 
        SELECT 581, 'Conference Organising Manager   ', 'CAC02693',0,1 UNION ALL 
        SELECT 582, 'Conjurer', 'CAB00476',0,1 UNION ALL 
        SELECT 583, 'Construction Superintendent', 'CAB00477',1,2 UNION ALL 
        SELECT 584, 'Construction Superintendent (oil rig industry)  ', 'CAC02694',1,2 UNION ALL 
        SELECT 585, 'Construction Work', 'CAB00478',0,1 UNION ALL 
        SELECT 586, 'Constructional Plater', 'CAB00479',1,2 UNION ALL 
        SELECT 587, 'Contact Lens Technician', 'CAB00480',0,1 UNION ALL 
        SELECT 588, 'Continuity Clerk', 'CAB00481',0,1 UNION ALL 
        SELECT 589, 'Control Engineer', 'CAB00482',0,1 UNION ALL 
        SELECT 590, 'Control Room Operator - Gas Supply Industry', 'CAB00483',1,2 UNION ALL 
        SELECT 591, 'Control Room Operator - Oil & Natural Gas Industries (Exploration & Production)', 'CAB00484',1,2 UNION ALL 
        SELECT 592, 'Conveyor Mover', 'CAB00485',1,2 UNION ALL 
        SELECT 593, 'Conveyor Operator - Airport', 'CAB00486',1,2 UNION ALL 
        SELECT 594, 'Conveyor Operator - Brick, Pipe & Tile Manufacture', 'CAB00487',1,2 UNION ALL 
        SELECT 595, 'Conveyor Operator - Cement Works', 'CAB00488',1,2 UNION ALL 
        SELECT 596, 'Conveyor Operator - Chemical & Plastics Industry', 'CAB00489',1,2 UNION ALL 
        SELECT 597, 'Conveyor Operator - Cork Goods Manufacture', 'CAB00490',1,2 UNION ALL 
        SELECT 598, 'Conveyor Operator - Docks', 'CAB00491',1,2 UNION ALL 
        SELECT 599, 'Conveyor Operator - Electronic Goods Manufacture', 'CAB00492',1,2 UNION ALL 
        SELECT 600, 'Conveyor Operator - Explosives Manufacture', 'CAB00493',1,2 UNION ALL 
        SELECT 601, 'Conveyor Operator - Food & Drink - General', 'CAB00494',1,2 UNION ALL 
        SELECT 602, 'Conveyor Operator - Gas Supply Industry', 'CAB00495',1,2 UNION ALL 
        SELECT 603, 'Conveyor Operator - Minerals', 'CAB00497',1,2 UNION ALL 
        SELECT 604, 'Conveyor Operator - Misc. Workers - Metal Manufacture', 'CAB00496',1,2 UNION ALL 
        SELECT 605, 'Conveyor Operator - Motor Vehicle & Cycle Industry', 'CAB00498',1,2 UNION ALL 
        SELECT 606, 'Conveyor Operator - Pottery Industry', 'CAB00499',1,2 UNION ALL 
        SELECT 607, 'Conveyor Operator - Precision Instrument Making & Repair', 'CAB00500',1,2 UNION ALL 
        SELECT 608, 'Conveyor Operator - Quarrying', 'CAB00501',1,2 UNION ALL 
        SELECT 609, 'Conveyor Operator - Tobacco Industry', 'CAB00502',1,2 UNION ALL 
        SELECT 610, 'Conveyor Operator - Tunnelling', 'CAB00503',1,2 UNION ALL 
        SELECT 611, 'Conveyor Operator - Woodworking Industry', 'CAB00504',1,2 UNION ALL 
        SELECT 612, 'Conveyor Operator (Surface)', 'CAB00505',1,2 UNION ALL 
        SELECT 613, 'Conveyor Patrolman', 'CAB00506',1,2 UNION ALL 
        SELECT 614, 'Conveyor/Slusher Operator', 'CAB00507',1,2 UNION ALL 
        SELECT 615, 'Cook', 'CAB00508',0,1 UNION ALL 
        SELECT 616, 'Cook - Head', 'CAB00509',1,2 UNION ALL 
        SELECT 617, 'Cook - Not Head', 'CAB00510',1,2 UNION ALL 
        SELECT 618, 'Cooker - Food & Drink - Other Processes', 'CAB00513',1,2 UNION ALL 
        SELECT 619, 'Cooker - Fruit & Veg. - Food & Drink', 'CAB00511',1,2 UNION ALL 
        SELECT 620, 'Cooker - Meat, Fish etc - Food & Drink', 'CAB00512',1,2 UNION ALL 
        SELECT 621, 'Cooper', 'CAB00514',0,1 UNION ALL 
        SELECT 622, 'Coppersmith', 'CAB00515',0,1 UNION ALL 
        SELECT 623, 'Copyholder', 'CAB00516',0,1 UNION ALL 
        SELECT 624, 'Copyholder (Newspapers etc)', 'CAB00517',0,1 UNION ALL 
        SELECT 625, 'Copytaster', 'CAB00518',0,1 UNION ALL 
        SELECT 626, 'Copywriter  ', 'CAC02695',0,1 UNION ALL 
        SELECT 627, 'Core Borer', 'CAB00519',0,1 UNION ALL 
        SELECT 628, 'Core Builder', 'CAB00520',0,1 UNION ALL 
        SELECT 629, 'Coremaker', 'CAB00521',0,1 UNION ALL 
        SELECT 630, 'Coroner', 'CAB00522',0,1 UNION ALL 
        SELECT 631, 'Correspondent - no overseas travel etc - Journalism', 'CAB00524',0,2 UNION ALL 
        SELECT 632, 'Correspondent - no overseas travel etc - Radio & TV - Entertainment', 'CAB00523',0,2 UNION ALL 
        SELECT 633, 'Correspondent - otherwise - Journalism', 'CAB00526',0,1 UNION ALL 
        SELECT 634, 'Correspondent - otherwise - Radio & TV - Entertainment', 'CAB00525',0,1 UNION ALL 
        SELECT 635, 'Costermonger', 'CAB00527',0,1 UNION ALL 
        SELECT 636, 'Costume Designer', 'CAB00528',0,1 UNION ALL 
        SELECT 637, 'Costumier   ', 'CAC02696',0,1 UNION ALL 
        SELECT 638, 'Counsellor', 'CAB00529',0,1 UNION ALL 
        SELECT 639, 'Counter Staff - Dry Cleaning', 'CAB00530',0,1 UNION ALL 
        SELECT 640, 'Counter Staff - Laundry', 'CAB00531',0,1 UNION ALL 
        SELECT 641, 'Counter Staff - Post Office/Telecommunications', 'CAB00532',0,1 UNION ALL 
        SELECT 642, 'Couriers    ', 'CAC02697',0,1 UNION ALL 
        SELECT 643, 'Court Bailiff', 'CAB00533',0,1 UNION ALL 
        SELECT 644, 'Court Usher', 'CAB00534',0,1 UNION ALL 
        SELECT 645, 'Crab Fisherman', 'CAB00535',0,1 UNION ALL 
        SELECT 646, 'Crane Driver', 'CAB00536',1,2 UNION ALL 
        SELECT 647, 'Crane Driver - Derrick', 'CAB00538',1,2 UNION ALL 
        SELECT 648, 'Crane Driver - Jib', 'CAB00539',1,2 UNION ALL 
        SELECT 649, 'Crane Driver - Mobile', 'CAB00540',1,2 UNION ALL 
        SELECT 650, 'Crane Driver - Tower', 'CAB00541',1,2 UNION ALL 
        SELECT 651, 'Crane Driver (Overhead)', 'CAB00537',1,2 UNION ALL 
        SELECT 652, 'Crane Erector', 'CAB00542',0,1 UNION ALL 
        SELECT 653, 'Crane Operator - Jib', 'CAB00545',1,2 UNION ALL 
        SELECT 654, 'Crane Operator - Mobile - Ship Building, Ship Repair & Marine Engineering', 'CAB00546',1,2 UNION ALL 
        SELECT 655, 'Crane Operator - Mobile - Woodworking Industry', 'CAB00547',1,2 UNION ALL 
        SELECT 656, 'Crane Operator - Oil & Natural Gas Industries (Exploration & Production)', 'CAB00543',1,2 UNION ALL 
        SELECT 657, 'Crane Operator - Overhead', 'CAB00548',1,2 UNION ALL 
        SELECT 658, 'Crane Operator - Quarrying', 'CAB00544',1,2 UNION ALL 
        SELECT 659, 'Crane Operator - Tower', 'CAB00549',1,2 UNION ALL 
        SELECT 660, 'Crane Slinger - Aircraft/Aerospace', 'CAB00550',1,2 UNION ALL 
        SELECT 661, 'Crane Slinger - Construction Industry', 'CAB00551',1,2 UNION ALL 
        SELECT 662, 'Crane Slinger - Docks', 'CAB00552',1,2 UNION ALL 
        SELECT 663, 'Crane Slinger - Misc. Workers - Metal Manufacture', 'CAB00553',1,2 UNION ALL 
        SELECT 664, 'Crane Slinger - Motor Vehicle & Cycle Industry', 'CAB00554',1,2 UNION ALL 
        SELECT 665, 'Crane Slinger - Quarrying', 'CAB00555',1,2 UNION ALL 
        SELECT 666, 'Crane Slinger - Ship Building, Ship Repair & Marine Engineering', 'CAB00556',1,2 UNION ALL 
        SELECT 667, 'Crane Slinger - Woodworking Industry', 'CAB00557',1,2 UNION ALL 
        SELECT 668, 'Credit Agent    ', 'CAC02698',0,1 UNION ALL 
        SELECT 669, 'Credit Controller   ', 'CAC02699',0,1 UNION ALL 
        SELECT 670, 'Cricket', 'CAB00558',1,2 UNION ALL 
        SELECT 671, 'Critic', 'CAB00559',0,1 UNION ALL 
        SELECT 672, 'Crofter', 'CAB00560',1,2 UNION ALL 
        SELECT 673, 'Crop Spraying/Loaders/Flagmen', 'CAB00561',1,2 UNION ALL 
        SELECT 674, 'Crossing Keeper', 'CAB00562',0,1 UNION ALL 
        SELECT 675, 'Croupier', 'CAB00563',0,1 UNION ALL 
        SELECT 676, 'Crushing Plant Operator - Quarrying', 'CAB00564',1,2 UNION ALL 
        SELECT 677, 'Crushing Plant Operator - Stoneworking', 'CAB00565',1,2 UNION ALL 
        SELECT 678, 'Crushing Worker', 'CAB00566',0,1 UNION ALL 
        SELECT 679, 'Curator - Zoo', 'CAB00567',0,1 UNION ALL 
        SELECT 680, 'Curator (museum) ', 'CAC02700',0,1 UNION ALL 
        SELECT 681, 'Curer', 'CAB00568',0,1 UNION ALL 
        SELECT 682, 'Customer Care Officer   ', 'CAC02701',0,1 UNION ALL 
        SELECT 683, 'Customs/Excise - Immigration', 'CAB00569',1,2 UNION ALL 
        SELECT 684, 'Customs/Excise - Investigative', 'CAB00570',1,2 UNION ALL 
        SELECT 685, 'Customs/Excise - Port Control', 'CAB00571',1,2 UNION ALL 
        SELECT 686, 'Cutter - Leather & Fur Industries', 'CAB00573',1,2 UNION ALL 
        SELECT 687, 'Cutter - Meat, Fish etc - Food & Drink', 'CAB00572',1,2 UNION ALL 
        SELECT 688, 'Cutter - Optical Goods Industry', 'CAB00574',1,2 UNION ALL 
        SELECT 689, 'Cutter - Paper & Board Manufacture', 'CAB00575',1,2 UNION ALL 
        SELECT 690, 'Cutter & Booker', 'CAB00576',1,2 UNION ALL 
        SELECT 691, 'Cutting Machine Operator - Battery/Accumulator Manufacture', 'CAB00577',1,2 UNION ALL 
        SELECT 692, 'Cutting Machine Operator - Quarrying', 'CAB00578',1,2 UNION ALL 
        SELECT 693, 'Cutting/Loading Machine Assistant', 'CAB00579',1,2 UNION ALL 
        SELECT 694, 'Cycle Racing (Road & Track)', 'CAB00580',1,2 UNION ALL 
        SELECT 695, 'Dairyman    ', 'DAC02702',0,1 UNION ALL 
        SELECT 696, 'Dairyman (Margarine)', 'DAB00581',1,2 UNION ALL 
        SELECT 697, 'Dancer', 'DAB00582',0,1 UNION ALL 
        SELECT 698, 'Dancing Teacher ', 'DAC02703',0,1 UNION ALL 
        SELECT 699, 'Dancing Teacher (Private)', 'DAB00583',1,2 UNION ALL 
        SELECT 700, 'Darts', 'DAB00584',1,2 UNION ALL 
        SELECT 701, 'Debt Collection Manager (some site work) ', 'DAC02704',1,2 UNION ALL 
        SELECT 702, 'Debt Collector', 'DAB00585',0,1 UNION ALL 
        SELECT 703, 'Debt Collector (office based)    ', 'DAC02705',1,2 UNION ALL 
        SELECT 704, 'Deck Chair Attendant', 'DAB00586',0,1 UNION ALL 
        SELECT 705, 'Deck Hand', 'DAB00587',0,1 UNION ALL 
        SELECT 706, 'Deck Hand/Rating/Boy', 'DAB00588',1,2 UNION ALL 
        SELECT 707, 'Deck Officer', 'DAB00589',0,1 UNION ALL 
        SELECT 708, 'Decorator   ', 'DAC02706',0,1 UNION ALL 
        SELECT 709, 'Decorator (hand)', 'DAB00590',1,2 UNION ALL 
        SELECT 710, 'Decorator (machine)', 'DAB00591',1,2 UNION ALL 
        SELECT 711, 'Degreaser', 'DAB00592',1,2 UNION ALL 
        SELECT 712, 'Delivery Driver', 'DAB00593',0,1 UNION ALL 
        SELECT 713, 'Demolition Worker-no explosives', 'DAB00594',0,1 UNION ALL 
        SELECT 714, 'Demolition Worker-using explosives', 'DAB00595',0,1 UNION ALL 
        SELECT 715, 'Demonstrator (Products) - Usually..', 'DAB00596',1,2 UNION ALL 
        SELECT 716, 'Demonstrators, Salesmen', 'DAB00597',1,2 UNION ALL 
        SELECT 717, 'Dental Assistant', 'DAB00598',0,1 UNION ALL 
        SELECT 718, 'Dental Auxiliary    ', 'DAC02707',0,1 UNION ALL 
        SELECT 719, 'Dental Consultant', 'DAB00599',0,1 UNION ALL 
        SELECT 720, 'Dental Hygienist', 'DAB00600',0,1 UNION ALL 
        SELECT 721, 'Dental Nurse', 'DAB00601',0,1 UNION ALL 
        SELECT 722, 'Dental Practitioner', 'DAB00602',0,1 UNION ALL 
        SELECT 723, 'Dental Technician', 'DAB00603',0,1 UNION ALL 
        SELECT 724, 'Dental Therapist', 'DAB00604',0,1 UNION ALL 
        SELECT 725, 'Dentist', 'DAB00605',0,1 UNION ALL 
        SELECT 726, 'Deputy Fireman', 'DAB00606',1,2 UNION ALL 
        SELECT 727, 'Dermatologist   ', 'DAC02708',0,1 UNION ALL 
        SELECT 728, 'Derrick Crane Driver', 'DAB00607',1,2 UNION ALL 
        SELECT 729, 'Derrickman', 'DAB00608',1,2 UNION ALL 
        SELECT 730, 'Descaling Plant Operator', 'DAB00609',1,2 UNION ALL 
        SELECT 731, 'Design Cutter - Printing Industry', 'DAB00610',1,2 UNION ALL 
        SELECT 732, 'Design Cutter - Textile & Clothing Industry', 'DAB00611',1,2 UNION ALL 
        SELECT 733, 'Designer', 'DAB00612',0,1 UNION ALL 
        SELECT 734, 'Designer - salaried', 'DAB00614',1,2 UNION ALL 
        SELECT 735, 'Designer - self-employed', 'DAB00615',1,2 UNION ALL 
        SELECT 736, 'Designer (Clothing)', 'DAB00613',1,2 UNION ALL 
        SELECT 737, 'Detention Centre Warden', 'DAB00616',0,1 UNION ALL 
        SELECT 738, 'Detonator Filler', 'DAB00617',1,2 UNION ALL 
        SELECT 739, 'Dial Painter - hand', 'DAB00618',1,2 UNION ALL 
        SELECT 740, 'Dial Painter - machine', 'DAB00619',1,2 UNION ALL 
        SELECT 741, 'Diamond Cleaner', 'DAB00620',1,2 UNION ALL 
        SELECT 742, 'Diamond Cutter', 'DAB00621',1,2 UNION ALL 
        SELECT 743, 'Diamond Dealer', 'DAB00622',1,2 UNION ALL 
        SELECT 744, 'Diamond Polisher', 'DAB00623',1,2 UNION ALL 
        SELECT 745, 'Diamond Sawyer', 'DAB00624',1,2 UNION ALL 
        SELECT 746, 'Diamond Setter', 'DAB00625',1,2 UNION ALL 
        SELECT 747, 'Die Cutter', 'DAB00626',0,1 UNION ALL 
        SELECT 748, 'Die Setter', 'DAB00627',0,1 UNION ALL 
        SELECT 749, 'Die Sinker', 'DAB00628',1,2 UNION ALL 
        SELECT 750, 'Diesel Locomotive Fitter', 'DAB00629',0,1 UNION ALL 
        SELECT 751, 'Dietician', 'DAC02709',0,2 UNION ALL 
        SELECT 752, 'Digesterman', 'DAB00630',1,2 UNION ALL 
        SELECT 753, 'Dining Car Attendant', 'DAB00631',0,1 UNION ALL 
        SELECT 754, 'Dip Enameller', 'DAB00632',1,2 UNION ALL 
        SELECT 755, 'Dip Painter', 'DAB00633',1,2 UNION ALL 
        SELECT 756, 'Director', 'DAB00634',1,2 UNION ALL 
        SELECT 757, 'Director - Zoo', 'DAB00635',1,2 UNION ALL 
        SELECT 758, 'Director & Medical Consultant   ', 'DAC02710',0,1 UNION ALL 
        SELECT 759, 'Director of Photography', 'DAB00636',1,2 UNION ALL 
        SELECT 760, 'Disc Jockey', 'DAB00637',0,1 UNION ALL 
        SELECT 761, 'Disinfecting Officer', 'DAB00638',0,1 UNION ALL 
        SELECT 762, 'Disinfestor', 'DAB00639',0,1 UNION ALL 
        SELECT 763, 'Dispatch Rider  ', 'DAC02711',0,1 UNION ALL 
        SELECT 764, 'Dispatcher', 'DAB00640',0,1 UNION ALL 
        SELECT 765, 'Distiller   ', 'DAC02712',0,1 UNION ALL 
        SELECT 766, 'Distillery Manager', 'DAB00641',0,1 UNION ALL 
        SELECT 767, 'District Nurse', 'DAB00642',0,1 UNION ALL 
        SELECT 768, 'Diver   ', 'DAC02713',0,1 UNION ALL 
        SELECT 769, 'Diver (North Sea)    ', 'DAC02714',0,1 UNION ALL 
        SELECT 770, 'Diver''s Linesman -Coastal etc', 'DAB00643',0,1 UNION ALL 
        SELECT 771, 'Diver''s Linesman -Deep Sea', 'DAB00644',0,1 UNION ALL 
        SELECT 772, 'Divider', 'DAB00645',1,2 UNION ALL 
        SELECT 773, 'Divisional Officer', 'DAB00646',1,2 UNION ALL 
        SELECT 774, 'Dock Foreman', 'DAB00647',0,1 UNION ALL 
        SELECT 775, 'Dock Master', 'DAB00648',0,1 UNION ALL 
        SELECT 776, 'Dock Superintendent', 'DAB00649',0,1 UNION ALL 
        SELECT 777, 'Docker', 'DAB00650',0,1 UNION ALL 
        SELECT 778, 'Doctor - Health', 'DAB00651',0,1 UNION ALL 
        SELECT 779, 'Doctor - Merchant Marine', 'DAB00652',0,1 UNION ALL 
        SELECT 780, 'Dog Breeder', 'DAB00653',1,2 UNION ALL 
        SELECT 781, 'Dog Catcher ', 'DAC02715',0,1 UNION ALL 
        SELECT 782, 'Dog, Horse Trainer/Keeper', 'DAB00654',1,2 UNION ALL 
        SELECT 783, 'Dogger', 'DAB00655',0,1 UNION ALL 
        SELECT 784, 'Domestic Electrician', 'DAB00656',0,1 UNION ALL 
        SELECT 785, 'Domestic Premises Cleaner', 'DAB00657',0,1 UNION ALL 
        SELECT 786, 'Domestic Supervisor (Hospital)', 'DAB00658',0,1 UNION ALL 
        SELECT 787, 'Domestic Tiler  ', 'DAC02716',0,1 UNION ALL 
        SELECT 788, 'Donkeyman', 'DAB00659',0,1 UNION ALL 
        SELECT 789, 'Door to Door Salesman', 'DAB00660',0,2 UNION ALL 
        SELECT 790, 'Doorman - Club/Nightclub - Entertainment', 'DAB00661',1,2 UNION ALL 
        SELECT 791, 'Doorman - Dance Hall, Disco etc - Entertainment', 'DAB00662',1,2 UNION ALL 
        SELECT 792, 'Double Glazing - Installer/fitter ', 'DAC02717',0,1 UNION ALL 
        SELECT 793, 'Double Glazing Fitter   ', 'DAC02718',1,2 UNION ALL 
        SELECT 794, 'Double Glazing Surveyor ', 'DAC02719',0,1 UNION ALL 
        SELECT 795, 'Dragline Driver', 'DAB00663',1,2 UNION ALL 
        SELECT 796, 'Drama Teacher (Private)', 'DAB00664',1,2 UNION ALL 
        SELECT 797, 'Draper  ', 'DAC02720',0,1 UNION ALL 
        SELECT 798, 'Draughtsman', 'DAB00665',0,1 UNION ALL 
        SELECT 799, 'Drawer (Bar, Plate, Rod, etc)', 'DAB00666',0,1 UNION ALL 
        SELECT 800, 'Drayman', 'DAB00667',0,1 UNION ALL 
        SELECT 801, 'Dredger Driver', 'DAB00668',0,1 UNION ALL 
        SELECT 802, 'Dredgerman', 'DAB00669',0,1 UNION ALL 
        SELECT 803, 'Dredgermaster', 'DAB00670',1,2 UNION ALL 
        SELECT 804, 'Dredging Superintendent', 'DAB00671',1,2 UNION ALL 
        SELECT 805, 'Dresser', 'DAB00672',0,1 UNION ALL 
        SELECT 806, 'Dressmaker', 'DAB00673',0,1 UNION ALL 
        SELECT 807, 'Drier - Cork Goods Manufacture', 'DAB00674',1,2 UNION ALL 
        SELECT 808, 'Drier - Dry Cleaning', 'DAB00675',1,2 UNION ALL 
        SELECT 809, 'Drier - Laundry', 'DAB00677',1,2 UNION ALL 
        SELECT 810, 'Drier - Meat, Fish etc - Food & Drink', 'DAB00676',1,2 UNION ALL 
        SELECT 811, 'Drier Attendant', 'DAB00678',1,2 UNION ALL 
        SELECT 812, 'Drier Operator', 'DAB00679',1,2 UNION ALL 
        SELECT 813, 'Drier/Kiln Operator', 'DAB00680',1,2 UNION ALL 
        SELECT 814, 'Driller - Asbestos', 'DAB00681',1,2 UNION ALL 
        SELECT 815, 'Driller - constructional metal work', 'DAB00690',1,2 UNION ALL 
        SELECT 816, 'Driller - Machining, Shaping etc - Metal Manufacture', 'DAB00682',1,2 UNION ALL 
        SELECT 817, 'Driller - Mining', 'DAB00686',1,2 UNION ALL 
        SELECT 818, 'Driller - Motor Vehicle & Cycle Industry', 'DAB00683',1,2 UNION ALL 
        SELECT 819, 'Driller - Oil & Natural Gas Industries (Exploration & Production)', 'DAB00688',1,2 UNION ALL 
        SELECT 820, 'Driller - Quarrying', 'DAB00687',1,2 UNION ALL 
        SELECT 821, 'Driller - Ship Building, Ship Repair & Marine Engineering', 'DAB00684',1,2 UNION ALL 
        SELECT 822, 'Driller - Tunnelling', 'DAB00685',1,2 UNION ALL 
        SELECT 823, 'Driller (Pipes)', 'DAB00689',1,2 UNION ALL 
        SELECT 824, 'Drilling Supervisor', 'DAB00691',1,2 UNION ALL 
        SELECT 825, 'Driver', 'DAB00692',1,2 UNION ALL 
        SELECT 826, 'Driver - Bulldozer', 'DAB00693',1,2 UNION ALL 
        SELECT 827, 'Driver - Concrete Mixer', 'DAB00694',1,2 UNION ALL 
        SELECT 828, 'Driver - Digger', 'DAB00695',1,2 UNION ALL 
        SELECT 829, 'Driver - Dumper', 'DAB00696',1,2 UNION ALL 
        SELECT 830, 'Driver - Excavator', 'DAB00697',1,2 UNION ALL 
        SELECT 831, 'Driver - Grader', 'DAB00698',1,2 UNION ALL 
        SELECT 832, 'Driver - Grass cutting machine driver', 'DAC02721',1,2 UNION ALL 
        SELECT 833, 'Driver - Mechanical plant   ', 'DAC02722',1,2 UNION ALL 
        SELECT 834, 'Driver - Oil tanker driver  ', 'DAC02723',1,2 UNION ALL 
        SELECT 835, 'Driver - refuse', 'DAC02724',0,2 UNION ALL 
        SELECT 836, 'Driver - tractor', 'DAC02725',0,2 UNION ALL 
        SELECT 837, 'Driving Examiner', 'DAB00699',0,1 UNION ALL 
        SELECT 838, 'Driving Instructor', 'DAB00700',0,1 UNION ALL 
        SELECT 839, 'Driving Instructor (not HGV)    ', 'DAC02726',1,2 UNION ALL 
        SELECT 840, 'Driving instructor manager (no instructing)  ', 'DAC02727',1,2 UNION ALL 
        SELECT 841, 'Drop Ball Operator', 'DAB00701',0,1 UNION ALL 
        SELECT 842, 'Dry Cleaning Machine Operator', 'DAB00702',0,1 UNION ALL 
        SELECT 843, 'Dry Salter', 'DAB00703',0,1 UNION ALL 
        SELECT 844, 'Dubbing Mixer', 'DAB00704',1,2 UNION ALL 
        SELECT 845, 'Dumper Driver', 'DAB00705',1,2 UNION ALL 
        SELECT 846, 'Dumper Shovel Driver', 'DAB00706',1,2 UNION ALL 
        SELECT 847, 'Dumper Truck Driver', 'DAB00707',1,2 UNION ALL 
        SELECT 848, 'Dustman/Refuse Collector', 'DAB00708',0,1 UNION ALL 
        SELECT 849, 'Duty Officer', 'DAB00709',1,2 UNION ALL 
        SELECT 850, 'Dyer', 'DAB00710',0,1 UNION ALL 
        SELECT 851, 'Ecologist - Usually ...', 'EAB00711',1,2 UNION ALL 
        SELECT 852, 'Economist', 'EAB00712',0,1 UNION ALL 
        SELECT 853, 'Editor - Film Industry - Entertainment', 'EAB00713',1,2 UNION ALL 
        SELECT 854, 'Editor - Journalism', 'EAB00714',1,2 UNION ALL 
        SELECT 855, 'Education Officer   ', 'EAC02728',1,2 UNION ALL 
        SELECT 856, 'Educational Advisor ', 'EAC02729',0,1 UNION ALL 
        SELECT 857, 'Effluent Inspector', 'EAB00715',0,1 UNION ALL 
        SELECT 858, 'Electric Logger', 'EAB00716',0,1 UNION ALL 
        SELECT 859, 'Electrical Contractor', 'EAB00717',0,1 UNION ALL 
        SELECT 860, 'Electrical Engineer (no testing)', 'EAB00718',1,2 UNION ALL 
        SELECT 861, 'Electrical Engineer (others)', 'EAB00719',1,2 UNION ALL 
        SELECT 862, 'Electrical Engineer (testing)', 'EAB00720',1,2 UNION ALL 
        SELECT 863, 'Electrical Engineer(Professional)', 'EAB00721',1,2 UNION ALL 
        SELECT 864, 'Electrical Fitter', 'EAB00722',0,1 UNION ALL 
        SELECT 865, 'Electrical Goods Manufacturer   ', 'EAC02730',1,2 UNION ALL 
        SELECT 866, 'Electrical Installations Inspector', 'EAB00723',1,2 UNION ALL 
        SELECT 867, 'Electrical Retailer - shop work only    ', 'EAC02731',1,2 UNION ALL 
        SELECT 868, 'Electrical Wireman', 'EAB00724',0,1 UNION ALL 
        SELECT 869, 'Electrical/Refrigerating Engineer', 'EAB00725',1,2 UNION ALL 
        SELECT 870, 'Electrician - Aircraft/Aerospace', 'EAB00726',1,2 UNION ALL 
        SELECT 871, 'Electrician - Circus - Entertainment', 'EAB00727',1,2 UNION ALL 
        SELECT 872, 'Electrician - Domestic  ', 'EAC02733',1,2 UNION ALL 
        SELECT 873, 'Electrician - Film Industry - Entertainment', 'EAB00728',1,2 UNION ALL 
        SELECT 874, 'Electrician - Mining', 'EAB00732',1,2 UNION ALL 
        SELECT 875, 'Electrician - Motor Vehicle & Cycle Industry', 'EAB00729',1,2 UNION ALL 
        SELECT 876, 'Electrician - Oil Rig Industry  ', 'EAC02732',1,2 UNION ALL 
        SELECT 877, 'Electrician - Quarrying', 'EAB00730',1,2 UNION ALL 
        SELECT 878, 'Electrician - Ship Building, Ship Repair & Marine Engineering', 'EAB00731',1,2 UNION ALL 
        SELECT 879, 'Electrician (Installation)', 'EAB00733',1,2 UNION ALL 
        SELECT 880, 'Electricity Installation Site Surveyor  ', 'EAC02734',1,2 UNION ALL 
        SELECT 881, 'Electricity Power Plant Operator    ', 'EAC02735',1,2 UNION ALL 
        SELECT 882, 'Electronic Engineer (others)', 'EAB00734',1,2 UNION ALL 
        SELECT 883, 'Electronic Engineer( Professional)', 'EAB00735',1,2 UNION ALL 
        SELECT 884, 'Electronic Maintenance Fitter   ', 'EAC02736',1,2 UNION ALL 
        SELECT 885, 'Electronic Mechanic - Installer/repair    ', 'EAC02737',1,2 UNION ALL 
        SELECT 886, 'Electronics Design Engineer (admin. only)    ', 'EAC02738',1,2 UNION ALL 
        SELECT 887, 'Electronics engineer (office based)  ', 'EAC02739',1,2 UNION ALL 
        SELECT 888, 'Electronics Fitter', 'EAB00736',0,1 UNION ALL 
        SELECT 889, 'Electronics Installer', 'EAB00737',0,1 UNION ALL 
        SELECT 890, 'Electronics Mechanic', 'EAB00738',0,1 UNION ALL 
        SELECT 891, 'Electronics Repairer', 'EAB00739',0,1 UNION ALL 
        SELECT 892, 'Electronics Service Mechanic', 'EAB00740',0,1 UNION ALL 
        SELECT 893, 'Electronics Wireman', 'EAB00741',0,1 UNION ALL 
        SELECT 894, 'Electroplater', 'EAB00742',0,1 UNION ALL 
        SELECT 895, 'Electrotyper', 'EAB00743',0,1 UNION ALL 
        SELECT 896, 'Embalmer', 'EAB00744',0,1 UNION ALL 
        SELECT 897, 'Embroiderer', 'EAB00745',0,1 UNION ALL 
        SELECT 898, 'Employment Agency Owner (admin. only)    ', 'EAC02740',0,1 UNION ALL 
        SELECT 899, 'Enameller', 'EAB00746',0,1 UNION ALL 
        SELECT 900, 'Engine Driver', 'EAB00747',0,1 UNION ALL 
        SELECT 901, 'Engine Tester', 'EAB00748',0,1 UNION ALL 
        SELECT 902, 'Engine Tester-Rectifier', 'EAB00749',1,2 UNION ALL 
        SELECT 903, 'Engine Turner', 'EAB00750',1,2 UNION ALL 
        SELECT 904, 'Engineer - Civil, Construction, etc', 'EAB00756',1,2 UNION ALL 
        SELECT 905, 'Engineer - Fishing Industry', 'EAB00753',1,2 UNION ALL 
        SELECT 906, 'Engineer - fully qualified usually..', 'EAB00757',1,2 UNION ALL 
        SELECT 907, 'Engineer - Merchant Marine  ', 'EAC02741',1,2 UNION ALL 
        SELECT 908, 'Engineer - no test work', 'EAB00758',1,2 UNION ALL 
        SELECT 909, 'Engineer - offshore', 'EAC02742',0,2 UNION ALL 
        SELECT 910, 'Engineer - Post Office/Telecommunications', 'EAB00751',1,2 UNION ALL 
        SELECT 911, 'Engineer - Ship Building, Ship Repair & Marine Engineering', 'EAB00752',1,2 UNION ALL 
        SELECT 912, 'Engineer - test work', 'EAB00759',1,2 UNION ALL 
        SELECT 913, 'Engineer (no testing)', 'EAB00754',1,2 UNION ALL 
        SELECT 914, 'Engineer (testing)', 'EAB00755',1,2 UNION ALL 
        SELECT 915, 'Engineer Officer', 'EAB00760',1,2 UNION ALL 
        SELECT 916, 'Engineer/First Officer', 'EAB00761',1,2 UNION ALL 
        SELECT 917, 'Engineering Company Director (some manual duties)    ', 'EAC02743',1,2 UNION ALL 
        SELECT 918, 'Engineering Fitter', 'EAB00762',0,1 UNION ALL 
        SELECT 919, 'Engineering Geologist', 'EAB00763',1,2 UNION ALL 
        SELECT 920, 'Engineering inspector (office based) ', 'EAC02744',1,2 UNION ALL 
        SELECT 921, 'Engineering Technical Director  ', 'EAC02745',1,2 UNION ALL 
        SELECT 922, 'Engineering Technician', 'EAB00764',0,1 UNION ALL 
        SELECT 923, 'Engineroom Rating', 'EAB00765',1,2 UNION ALL 
        SELECT 924, 'Engineroom Storekeeper', 'EAB00766',1,2 UNION ALL 
        SELECT 925, 'Engraver - Precious Metals, Engraving etc - Metal Manufacture', 'EAB00767',1,2 UNION ALL 
        SELECT 926, 'Engraver - Printing Industry', 'EAB00768',1,2 UNION ALL 
        SELECT 927, 'Engraver (creative)', 'EAB00769',1,2 UNION ALL 
        SELECT 928, 'Enrolled Nurse', 'EAB00770',0,1 UNION ALL 
        SELECT 929, 'Entertainer - Entertainment industry    ', 'EAC02746',0,1 UNION ALL 
        SELECT 930, 'Entertainment Agent - Entertainment industry    ', 'EAC02747',0,1 UNION ALL 
        SELECT 931, 'Entertainment Manager - Entertainment industry  ', 'EAC02748',0,1 UNION ALL 
        SELECT 932, 'Entertainments Officer', 'EAB00771',0,1 UNION ALL 
        SELECT 933, 'Environmental Health Officer    ', 'EAC02749',0,1 UNION ALL 
        SELECT 934, 'Equestrian Artiste', 'EAB00772',0,1 UNION ALL 
        SELECT 935, 'Equestrianism - Riding Instructor', 'EAB00773',0,1 UNION ALL 
        SELECT 936, 'Equestrianism - Show Jumping', 'EAB00774',0,1 UNION ALL 
        SELECT 937, 'Equipment Cleaner', 'EAB00775',0,1 UNION ALL 
        SELECT 938, 'Erector - Aircraft/Aerospace', 'EAB00776',0,1 UNION ALL 
        SELECT 939, 'Erector - Production Fitting - Metal Manufacture', 'EAB00777',0,1 UNION ALL 
        SELECT 940, 'Escapologist', 'EAB00778',0,1 UNION ALL 
        SELECT 941, 'Estate Agent', 'EAB00779',0,1 UNION ALL 
        SELECT 942, 'Estate Manager - all aspects (no manual work)    ', 'EAC02750',0,1 UNION ALL 
        SELECT 943, 'Estate Ranger', 'EAB00780',0,1 UNION ALL 
        SELECT 944, 'Estimator', 'EAB00781',0,1 UNION ALL 
        SELECT 945, 'Estimator (mainly office duties) ', 'EAC02751',0,1 UNION ALL 
        SELECT 946, 'Etcher - Pottery Industry', 'EAB00783',0,1 UNION ALL 
        SELECT 947, 'Etcher - Precious Metals, Engraving etc - Metal Manufacture', 'EAB00782',0,1 UNION ALL 
        SELECT 948, 'Etcher - Printing Industry', 'EAB00784',0,1 UNION ALL 
        SELECT 949, 'Etcher (creative)', 'EAB00785',0,1 UNION ALL 
        SELECT 950, 'Examiner - Brick, Pipe & Tile Manufacture', 'EAB00786',1,2 UNION ALL 
        SELECT 951, 'Examiner - Dry Cleaning', 'EAB00787',1,2 UNION ALL 
        SELECT 952, 'Examiner - Food & Drink - General', 'EAB00788',1,2 UNION ALL 
        SELECT 953, 'Examiner - Laundry', 'EAB00789',1,2 UNION ALL 
        SELECT 954, 'Examiner - Misc. Workers - Metal Manufacture', 'EAB00790',1,2 UNION ALL 
        SELECT 955, 'Examiner - Motor Vehicle & Cycle Industry', 'EAB00791',1,2 UNION ALL 
        SELECT 956, 'Examiner - Optical Goods Industry', 'EAB00792',1,2 UNION ALL 
        SELECT 957, 'Examiner - Paper & Board Manufacture', 'EAB00793',1,2 UNION ALL 
        SELECT 958, 'Examiner - Rubber Industry - Natural', 'EAB00794',1,2 UNION ALL 
        SELECT 959, 'Excavator Driver', 'EAB00795',0,1 UNION ALL 
        SELECT 960, 'Exhausterman', 'EAB00796',0,1 UNION ALL 
        SELECT 961, 'Exhibition Foreman  ', 'EAC02752',0,1 UNION ALL 
        SELECT 962, 'Exhibition Space Sales Manager  ', 'EAC02753',0,1 UNION ALL 
        SELECT 963, 'Exhibition Stand Fitter', 'EAB00797',0,1 UNION ALL 
        SELECT 964, 'Explosives Inspector', 'EAB00798',0,1 UNION ALL 
        SELECT 965, 'Export Agent    ', 'EAC02754',0,1 UNION ALL 
        SELECT 966, 'Exporter. - Usually ...', 'EAB00799',1,2 UNION ALL 
        SELECT 967, 'Extruder', 'EAB00800',0,1 UNION ALL 
        SELECT 968, 'Face Console Operator', 'FAB00801',1,2 UNION ALL 
        SELECT 969, 'Face Workers', 'FAB00802',1,2 UNION ALL 
        SELECT 970, 'Facilities Procurement Officer', 'FAB00803',0,1 UNION ALL 
        SELECT 971, 'Factory (worker)    ', 'FAC02755',0,1 UNION ALL 
        SELECT 972, 'Factory Clerk', 'FAB00804',1,2 UNION ALL 
        SELECT 973, 'Factory Electrician', 'FAB00805',1,2 UNION ALL 
        SELECT 974, 'Factory Inspector', 'FAB00806',0,1 UNION ALL 
        SELECT 975, 'Factory Manager (mainly admin.)  ', 'FAC02756',0,1 UNION ALL 
        SELECT 976, 'Factory Nurse', 'FAB00807',1,2 UNION ALL 
        SELECT 977, 'Factory Ships', 'FAB00808',1,2 UNION ALL 
        SELECT 978, 'Fairground Worker   ', 'FAC02757',0,1 UNION ALL 
        SELECT 979, 'Faith Healer', 'FAB00809',1,2 UNION ALL 
        SELECT 980, 'Fanman', 'FAB00810',1,2 UNION ALL 
        SELECT 981, 'Farm Engineer   ', 'FAC02758',1,2 UNION ALL 
        SELECT 982, 'Farm Machinery Driver   ', 'FAC02759',1,2 UNION ALL 
        SELECT 983, 'Farm Manager (manual duties)    ', 'FAC02760',0,1 UNION ALL 
        SELECT 984, 'Farm Manager (no manual duties) ', 'FAC02761',0,1 UNION ALL 
        SELECT 985, 'Farm Owner (manual duties)  ', 'FAC02762',0,1 UNION ALL 
        SELECT 986, 'Farm Owner (no manual duties)   ', 'FAC02763',0,1 UNION ALL 
        SELECT 987, 'Farm Worker/Labourer  ', 'FAC02764',0,1 UNION ALL 
        SELECT 988, 'Farrier', 'FAB00811',0,1 UNION ALL 
        SELECT 989, 'Fashion Designer    ', 'FAC02765',1,2 UNION ALL 
        SELECT 990, 'Fashion Model', 'FAB00812',0,1 UNION ALL 
        SELECT 991, 'Fashion Photographer', 'FAB00813',0,1 UNION ALL 
        SELECT 992, 'Fast Food Restaurant Assistant Manager (incl. servicing) ', 'FAC02766',1,2 UNION ALL 
        SELECT 993, 'Fast Food Restaurant Manager (admin. only)  ', 'FAC02767',0,1 UNION ALL 
        SELECT 994, 'Fat Extractor Man', 'FAB00814',0,1 UNION ALL 
        SELECT 995, 'Fence Erector', 'FAB00815',1,2 UNION ALL 
        SELECT 996, 'Fencing Contractor  ', 'FAC02768',0,1 UNION ALL 
        SELECT 997, 'Ferryman', 'FAB00816',0,1 UNION ALL 
        SELECT 998, 'Fettler', 'FAB00817',1,2 UNION ALL 
        SELECT 999, 'Fibre Preparation Worker', 'FAB00818',1,2 UNION ALL 
        SELECT 1000, 'Field Man', 'FAB00819',1,2 UNION ALL 
        SELECT 1001, 'Field Superintendent', 'FAB00820',1,2 UNION ALL 
        SELECT 1002, 'Field Training Executive - Beauty Products  ', 'FAC02769',1,2 UNION ALL 
        SELECT 1003, 'Fieldman - Oil Rig Industry ', 'FAC02770',1,2 UNION ALL 
        SELECT 1004, 'Fight Arranger', 'FAB00821',0,1 UNION ALL 
        SELECT 1005, 'File Cutter', 'FAB00822',1,2 UNION ALL 
        SELECT 1006, 'Film Developer', 'FAB00823',0,1 UNION ALL 
        SELECT 1007, 'Director - TV and film', 'FAC02771',0,2 UNION ALL 
        SELECT 1008, 'Film Joiner', 'FAB00824',0,1 UNION ALL 
        SELECT 1009, 'Film Processor', 'FAB00825',0,1 UNION ALL 
        SELECT 1010, 'Film Producer', 'FAC02772',1,2 UNION ALL 
        SELECT 1011, 'Film Recorder Operator', 'FAB00826',1,2 UNION ALL 
        SELECT 1012, 'Filmsetting Machine Operator', 'FAB00827',0,1 UNION ALL 
        SELECT 1013, 'Finance Arranger    ', 'FAC02773',1,2 UNION ALL 
        SELECT 1014, 'Financial Adviser  ', 'FAC02774',0,1 UNION ALL 
        SELECT 1015, 'Financial Manager   ', 'FAC02775',1,2 UNION ALL 
        SELECT 1016, 'Finisher - Stoneworking', 'FAB00828',1,2 UNION ALL 
        SELECT 1017, 'Finisher - Toy Goods Manufacture', 'FAB00829',1,2 UNION ALL 
        SELECT 1018, 'Finishing Worker - Pottery Industry', 'FAB00830',1,2 UNION ALL 
        SELECT 1019, 'Finishing Worker - Textile & Clothing Industry', 'FAB00831',1,2 UNION ALL 
        SELECT 1020, 'Fire Brigade Photographer   ', 'FAC02776',1,2 UNION ALL 
        SELECT 1021, 'Fire Eater', 'FAB00832',0,1 UNION ALL 
        SELECT 1022, 'Fire Officer (office duties only)  ', 'FAC02777',1,2 UNION ALL 
        SELECT 1023, 'Fire Prevention Officer', 'FAB00833',0,1 UNION ALL 
        SELECT 1024, 'Fire Protection Researcher', 'FAB00834',1,2 UNION ALL 
        SELECT 1025, 'Firefighter - Fire Service', 'FAB00835',0,2 UNION ALL 
        SELECT 1026, 'Fireman - Fishing Industry', 'FAB00836',1,2 UNION ALL 
        SELECT 1027, 'Fireman - Merchant Marine', 'FAB00837',1,2 UNION ALL 
        SELECT 1028, 'Firework Filler', 'FAB00838',1,2 UNION ALL 
        SELECT 1029, 'Fireworks Finisher', 'FAB00839',1,2 UNION ALL 
        SELECT 1030, 'First Engineer', 'FAB00840',1,2 UNION ALL 
        SELECT 1031, 'Fish and Chip Owner/worker    ', 'FAC02778',1,2 UNION ALL 
        SELECT 1032, 'Fish Boiler', 'FAB00841',1,2 UNION ALL 
        SELECT 1033, 'Fish Cooker', 'FAB00842',1,2 UNION ALL 
        SELECT 1034, 'Fish Farmer', 'FAB00843',0,1 UNION ALL 
        SELECT 1035, 'Fish Freezer Operator', 'FAB00844',1,2 UNION ALL 
        SELECT 1036, 'Fish Grader-Sorter', 'FAB00845',1,2 UNION ALL 
        SELECT 1037, 'Fish Gutter', 'FAB00846',1,2 UNION ALL 
        SELECT 1038, 'Fish Hatchery Worker', 'FAB00847',1,2 UNION ALL 
        SELECT 1039, 'Fish Preparer', 'FAB00848',0,1 UNION ALL 
        SELECT 1040, 'Fisherman', 'FAB00849',0,1 UNION ALL 
        SELECT 1041, 'Fishery Officer/Warden', 'FAB00850',0,1 UNION ALL 
        SELECT 1042, 'Fishing Industry', 'FAB00851',1,2 UNION ALL 
        SELECT 1043, 'Fishmonger  ', 'FAC02779',0,1 UNION ALL 
        SELECT 1044, 'Fishmonger Manager    ', 'FAC02780',1,2 UNION ALL 
        SELECT 1045, 'Fishmonger Proprietor ', 'FAC02781',1,2 UNION ALL 
        SELECT 1046, 'Fitness instructor  ', 'FAC02782',0,1 UNION ALL 
        SELECT 1047, 'Fitter  ', 'FAC02783',1,2 UNION ALL 
        SELECT 1048, 'Fitter - Motor Vehicle & Cycle Industry', 'FAB00852',0,1 UNION ALL 
        SELECT 1049, 'Fitter - Nuclear Energy', 'FAB00853',1,2 UNION ALL 
        SELECT 1050, 'Fitter - Oil Rig Industry   ', 'FAC02784',1,2 UNION ALL 
        SELECT 1051, 'Fitter - Ship Building, Ship Repair & Marine Engineering', 'FAB00854',1,2 UNION ALL 
        SELECT 1052, 'Fitter-Assembler', 'FAB00855',0,1 UNION ALL 
        SELECT 1053, 'Fitter-Assembler (Doors, Windows)', 'FAB00856',1,2 UNION ALL 
        SELECT 1054, 'Fitter-Welder', 'FAB00857',1,2 UNION ALL 
        SELECT 1055, 'Fixer Mason', 'FAB00858',0,1 UNION ALL 
        SELECT 1056, 'Flaking Millman', 'FAB00859',1,2 UNION ALL 
        SELECT 1057, 'Flame Burner', 'FAB00860',1,2 UNION ALL 
        SELECT 1058, 'Flame cutter - 40 ft +', 'FAB00864',0,2 UNION ALL 
        SELECT 1059, 'Flame Cutter - Ship Building, Ship Repair & Marine Engineering', 'FAB00861',1,2 UNION ALL 
        SELECT 1060, 'Flame cutter - under 40 ft', 'FAB00865',0,2 UNION ALL 
        SELECT 1061, 'Flame Cutter - Welding & Flame Cutting', 'FAB00862',1,2 UNION ALL 
        SELECT 1062, 'Flame Cutter (no underwater work)', 'FAB00863',1,2 UNION ALL 
        SELECT 1063, 'Flatter', 'FAB00866',1,2 UNION ALL 
        SELECT 1064, 'Flight Dispatcher', 'FAB00867',0,1 UNION ALL 
        SELECT 1065, 'Flight Operations Inspector', 'FAB00868',1,2 UNION ALL 
        SELECT 1066, 'Flight Planner', 'FAB00869',0,1 UNION ALL 
        SELECT 1067, 'Floor Layer', 'FAB00870',0,1 UNION ALL 
        SELECT 1068, 'Floor Manager', 'FAB00871',0,1 UNION ALL 
        SELECT 1069, 'Floor Tiler', 'FAB00872',0,1 UNION ALL 
        SELECT 1070, 'Floorman', 'FAB00873',0,1 UNION ALL 
        SELECT 1071, 'Floorman - Oil Rig Industry ', 'FAC02785',0,1 UNION ALL 
        SELECT 1072, 'Florist ', 'FAC02786',0,1 UNION ALL 
        SELECT 1073, 'Flour Confectioner', 'FAB00874',0,1 UNION ALL 
        SELECT 1074, 'Flour Mill Manager', 'FAB00875',1,2 UNION ALL 
        SELECT 1075, 'Food Technologist', 'FAB00876',0,1 UNION ALL 
        SELECT 1076, 'Football Manager - Professional players', 'FAC02787',0,1 UNION ALL 
        SELECT 1077, 'Forecourt Attendant ', 'FAC02788',0,1 UNION ALL 
        SELECT 1078, 'Foreign Exchange Dealer/Broker    ', 'FAC02789',1,2 UNION ALL 
        SELECT 1079, 'Foreman - above ground', 'FAB00924',1,2 UNION ALL 
        SELECT 1080, 'Foreman - Agriculture', 'FAB00879',1,2 UNION ALL 
        SELECT 1081, 'Foreman - Aircraft/Aerospace', 'FAB00878',1,2 UNION ALL 
        SELECT 1082, 'Foreman - Battery/Accumulator Manufacture', 'FAB00918',1,2 UNION ALL 
        SELECT 1083, 'Foreman - below ground', 'FAB00925',1,2 UNION ALL 
        SELECT 1084, 'Foreman - Bookbinding', 'FAB00877',1,2 UNION ALL 
        SELECT 1085, 'Foreman - Brick, Pipe & Tile Manufacture', 'FAB00880',1,2 UNION ALL 
        SELECT 1086, 'Foreman - Cement Works', 'FAB00881',1,2 UNION ALL 
        SELECT 1087, 'Foreman - Cemetery, Crematorium', 'FAB00882',1,2 UNION ALL 
        SELECT 1088, 'Foreman - Construction Industry', 'FAB00883',1,2 UNION ALL 
        SELECT 1089, 'Foreman - Electrical Supply', 'FAB00885',1,2 UNION ALL 
        SELECT 1090, 'Foreman - Electronic Goods Manufacture', 'FAB00884',1,2 UNION ALL 
        SELECT 1091, 'Foreman - Food & Drink - General', 'FAB00886',1,2 UNION ALL 
        SELECT 1092, 'Foreman - Forestry', 'FAB00888',1,2 UNION ALL 
        SELECT 1093, 'Foreman - Forging - Metal Manufacture', 'FAB00889',1,2 UNION ALL 
        SELECT 1094, 'Foreman - Furnace - Metal Manufacture', 'FAB00890',1,2 UNION ALL 
        SELECT 1095, 'Foreman - Machining, Shaping etc - Metal Manufacture', 'FAB00919',1,2 UNION ALL 
        SELECT 1096, 'Foreman - Marshalling/Goods Yard - Railways', 'FAB00907',1,2 UNION ALL 
        SELECT 1097, 'Foreman - Meat, Fish etc - Food & Drink', 'FAB00887',1,2 UNION ALL 
        SELECT 1098, 'Foreman - Metal Heat Treating - Metal Manufacture', 'FAB00920',1,2 UNION ALL 
        SELECT 1099, 'Foreman - Metal Plating & Coating - Metal Manufacture', 'FAB00891',1,2 UNION ALL 
        SELECT 1100, 'Foreman - Minerals', 'FAB00896',1,2 UNION ALL 
        SELECT 1101, 'Foreman - Motor Vehicle & Cycle Industry', 'FAB00897',1,2 UNION ALL 
        SELECT 1102, 'Foreman - Moulders, etc - Metal Manufacture', 'FAB00921',1,2 UNION ALL 
        SELECT 1103, 'Foreman - Musical Instrument Making & Repair', 'FAB00898',1,2 UNION ALL 
        SELECT 1104, 'Foreman - Oil & Natural Gas Industries (Exploration & Production)', 'FAB00899',1,2 UNION ALL 
        SELECT 1105, 'Foreman - Optical Goods Industry', 'FAB00900',1,2 UNION ALL 
        SELECT 1106, 'Foreman - Paper & Board Manufacture', 'FAB00922',1,2 UNION ALL 
        SELECT 1107, 'Foreman - Photographic Processing Industry', 'FAB00901',1,2 UNION ALL 
        SELECT 1108, 'Foreman - Pipe, Sheet, Wire etc - Metal Manufacture', 'FAB00892',1,2 UNION ALL 
        SELECT 1109, 'Foreman - Plasterboard Making Industry', 'FAB00902',1,2 UNION ALL 
        SELECT 1110, 'Foreman - Pottery Industry', 'FAB00903',1,2 UNION ALL 
        SELECT 1111, 'Foreman - Precious Metals, Engraving etc - Metal Manufacture', 'FAB00893',1,2 UNION ALL 
        SELECT 1112, 'Foreman - Precision Instrument Making & Repair', 'FAB00904',1,2 UNION ALL 
        SELECT 1113, 'Foreman - Printing Industry', 'FAB00905',1,2 UNION ALL 
        SELECT 1114, 'Foreman - Production Fitting - Metal Manufacture', 'FAB00894',1,2 UNION ALL 
        SELECT 1115, 'Foreman - Quarrying', 'FAB00906',1,2 UNION ALL 
        SELECT 1116, 'Foreman - Road Maintenance & Construction', 'FAB00909',1,2 UNION ALL 
        SELECT 1117, 'Foreman - Rolling, Extruding etc - Metal Manufacture', 'FAB00895',1,2 UNION ALL 
        SELECT 1118, 'Foreman - Rubber Industry - Natural', 'FAB00910',1,2 UNION ALL 
        SELECT 1119, 'Foreman - Ship Building, Ship Repair & Marine Engineering', 'FAB00911',1,2 UNION ALL 
        SELECT 1120, 'Foreman - Stoneworking', 'FAB00912',1,2 UNION ALL 
        SELECT 1121, 'Foreman - Textile & Clothing Industry', 'FAB00913',1,2 UNION ALL 
        SELECT 1122, 'Foreman - Tobacco Industry', 'FAB00914',1,2 UNION ALL 
        SELECT 1123, 'Foreman - Track Maintenance - Railways', 'FAB00908',1,2 UNION ALL 
        SELECT 1124, 'Foreman - Umbrella Making', 'FAB00915',1,2 UNION ALL 
        SELECT 1125, 'Foreman - Upholstery, Soft Furnishings, Mattress Making & Repair', 'FAB00916',1,2 UNION ALL 
        SELECT 1126, 'Foreman - Woodworking Industry', 'FAB00917',1,2 UNION ALL 
        SELECT 1127, 'Foreman (depending on degree of manual duties) - Oil Rig Industry   ', 'FAC02790',1,2 UNION ALL 
        SELECT 1128, 'Foreman (Surface)', 'FAB00923',1,2 UNION ALL 
        SELECT 1129, 'Foreman Lighterman', 'FAB00926',1,2 UNION ALL 
        SELECT 1130, 'Foreman Sewerman', 'FAB00927',1,2 UNION ALL 
        SELECT 1131, 'Foreman, Supervisor - Adhesives Manufacture', 'FAB00928',1,2 UNION ALL 
        SELECT 1132, 'Foreman, Supervisor - Asbestos', 'FAB00929',1,2 UNION ALL 
        SELECT 1133, 'Foreman, Supervisor - Chemical & Plastics Industry', 'FAB00930',1,2 UNION ALL 
        SELECT 1134, 'Foreman, Supervisor - Explosives Manufacture', 'FAB00931',1,2 UNION ALL 
        SELECT 1135, 'Foreman, Supervisor - Gas Supply Industry', 'FAB00932',1,2 UNION ALL 
        SELECT 1136, 'Foreman, Supervisor - Glass/Glass Fibre Manufacture', 'FAB00933',1,2 UNION ALL 
        SELECT 1137, 'Foreman, Supervisor - Leather & Fur Industries', 'FAB00934',1,2 UNION ALL 
        SELECT 1138, 'Foreman, Supervisor - Oil Refining', 'FAB00935',1,2 UNION ALL 
        SELECT 1139, 'Foreman/Supervisor', 'FAB00936',1,2 UNION ALL 
        SELECT 1140, 'Forest Ranger', 'FAB00937',0,1 UNION ALL 
        SELECT 1141, 'Forest Worker', 'FAB00938',0,1 UNION ALL 
        SELECT 1142, 'Forester', 'FAB00939',1,2 UNION ALL 
        SELECT 1143, 'Forestry Consultant ', 'FAC02791',1,2 UNION ALL 
        SELECT 1144, 'Forestry Officer', 'FAB00940',0,1 UNION ALL 
        SELECT 1145, 'Forestry Worker ', 'FAC02792',1,2 UNION ALL 
        SELECT 1146, 'Forge Hammerman', 'FAB00941',0,1 UNION ALL 
        SELECT 1147, 'Forge Pressman', 'FAB00942',0,1 UNION ALL 
        SELECT 1148, 'Forger', 'FAB00943',0,1 UNION ALL 
        SELECT 1149, 'Fork Lift Truck Driver', 'FAB00944',0,1 UNION ALL 
        SELECT 1150, 'Fortune Teller', 'FAB00945',0,1 UNION ALL 
        SELECT 1151, 'Frame Finisher', 'FAB00946',0,1 UNION ALL 
        SELECT 1152, 'Freezer Operator', 'FAB00947',0,1 UNION ALL 
        SELECT 1153, 'Freight Clerk', 'FAB00948',0,1 UNION ALL 
        SELECT 1154, 'Freight Manager - Airport', 'FAB00949',0,1 UNION ALL 
        SELECT 1155, 'Freight Manager - Docks', 'FAB00950',0,1 UNION ALL 
        SELECT 1156, 'French Polisher', 'FAB00951',0,1 UNION ALL 
        SELECT 1157, 'Fruitier    ', 'FAC02793',0,1 UNION ALL 
        SELECT 1158, 'Fuel Technologist', 'FAB00952',0,1 UNION ALL 
        SELECT 1159, 'Funeral Director', 'FAB00953',0,1 UNION ALL 
        SELECT 1160, 'Funeral Director''s Assistant', 'FAB00954',0,1 UNION ALL 
        SELECT 1161, 'Furnace Control Room Operator', 'FAB00955',0,1 UNION ALL 
        SELECT 1162, 'Furnace Operator - Cemetery, Crematorium', 'FAB00956',0,1 UNION ALL 
        SELECT 1163, 'Furnace Operator - Furnace - Metal Manufacture', 'FAB00957',1,2 UNION ALL 
        SELECT 1164, 'Furnaceman - Cement Works', 'FAB00958',1,2 UNION ALL 
        SELECT 1165, 'Furnaceman - Furnace - Metal Manufacture', 'FAB00960',1,2 UNION ALL 
        SELECT 1166, 'Furnaceman - Gas Supply Industry', 'FAB00959',1,2 UNION ALL 
        SELECT 1167, 'Furniture Designer', 'FAB00961',0,1 UNION ALL 
        SELECT 1168, 'Furniture Maker ', 'FAC02794',0,1 UNION ALL 
        SELECT 1169, 'Furniture Remover', 'FAB00962',0,1 UNION ALL 
        SELECT 1170, 'Furniture Restorer  ', 'FAC02795',0,1 UNION ALL 
        SELECT 1171, 'Furniture Retailer  ', 'FAC02796',0,1 UNION ALL 
        SELECT 1172, 'Gallery Owner (admin. only) ', 'GAC02797',0,1 UNION ALL 
        SELECT 1173, 'Gallery Owner (including manual work)    ', 'GAC02798',0,1 UNION ALL 
        SELECT 1174, 'Galley Hand - Fishing Industry', 'GAB00963',1,2 UNION ALL 
        SELECT 1175, 'Galley Hand - Merchant Marine', 'GAB00964',1,2 UNION ALL 
        SELECT 1176, 'Galvaniser', 'GAB00965',0,1 UNION ALL 
        SELECT 1177, 'Gamekeeper', 'GAB00966',0,1 UNION ALL 
        SELECT 1178, 'Gang Pusher', 'GAB00967',1,2 UNION ALL 
        SELECT 1179, 'Ganger', 'GAB00968',0,1 UNION ALL 
        SELECT 1180, 'Gantry Crane Driver - Docks', 'GAB00969',1,2 UNION ALL 
        SELECT 1181, 'Gantry Crane Driver - Motor Vehicle & Cycle Industry', 'GAB00970',1,2 UNION ALL 
        SELECT 1182, 'Garage - Managing Director  ', 'GAC02799',1,2 UNION ALL 
        SELECT 1183, 'Garage - Mechanic   ', 'GAC02800',0,1 UNION ALL 
        SELECT 1184, 'Garage - Petrol Pump Attendant  ', 'GAC02801',0,1 UNION ALL 
        SELECT 1185, 'Garage Proprietor - admin only', 'GAC02802',0,2 UNION ALL 
        SELECT 1186, 'Garage Repair Shop Supervisor (including manual duties)  ', 'GAC02803',0,1 UNION ALL 
        SELECT 1187, 'Gardener    ', 'GAC02804',0,1 UNION ALL 
        SELECT 1188, 'Gas Appliance Mechanic', 'GAB00971',0,1 UNION ALL 
        SELECT 1189, 'Gas Compressor Operator', 'GAB00972',0,1 UNION ALL 
        SELECT 1190, 'Gas Cylinder Filler', 'GAB00973',1,2 UNION ALL 
        SELECT 1191, 'Gas Cylinder Preparer', 'GAB00974',1,2 UNION ALL 
        SELECT 1192, 'Gas Cylinder Tester', 'GAB00975',1,2 UNION ALL 
        SELECT 1193, 'Gas Fitter', 'GAB00976',0,1 UNION ALL 
        SELECT 1194, 'Gas Fittings Tester', 'GAB00977',1,2 UNION ALL 
        SELECT 1195, 'Gas Holder Attendant', 'GAB00978',1,2 UNION ALL 
        SELECT 1196, 'Gas Meter Tester', 'GAB00979',0,1 UNION ALL 
        SELECT 1197, 'Gas Production Superintendent', 'GAB00980',1,2 UNION ALL 
        SELECT 1198, 'Gas Works Superintendent', 'GAB00981',1,2 UNION ALL 
        SELECT 1199, 'Gate-Keeper (eg Factory)', 'GAB00982',1,2 UNION ALL 
        SELECT 1200, 'Gauger', 'GAB00983',1,2 UNION ALL 
        SELECT 1201, 'Gem Cutter', 'GAB00984',0,1 UNION ALL 
        SELECT 1202, 'Gem Polisher', 'GAB00985',0,1 UNION ALL 
        SELECT 1203, 'Gem Setter', 'GAB00986',0,1 UNION ALL 
        SELECT 1204, 'Geological Scientist    ', 'GAC02805',1,2 UNION ALL 
        SELECT 1205, 'Geologist - Mining', 'GAB00987',0,1 UNION ALL 
        SELECT 1206, 'Geologist - no aerial/offshore etc', 'GAB00989',0,1 UNION ALL 
        SELECT 1207, 'Geologist - Oil & Natural Gas Industries', 'GAB00988',0,2 UNION ALL 
        SELECT 1208, 'Geophysicist - Mining', 'GAB00990',0,1 UNION ALL 
        SELECT 1209, 'Geophysicist - Oil & Natural Gas Industries', 'GAB00991',0,2 UNION ALL 
        SELECT 1210, 'Glass Blower    ', 'GAC02806',0,1 UNION ALL 
        SELECT 1211, 'Glass Workers - Cutting', 'GAB00992',1,2 UNION ALL 
        SELECT 1212, 'Glass Workers - Decorating', 'GAB00993',1,2 UNION ALL 
        SELECT 1213, 'Glass Workers - Finishing', 'GAB00994',1,2 UNION ALL 
        SELECT 1214, 'Glass Workers - Heat Treating', 'GAB00995',1,2 UNION ALL 
        SELECT 1215, 'Glazer', 'GAB00996',0,1 UNION ALL 
        SELECT 1216, 'Glazier - Aircraft/Aerospace', 'GAB00997',1,2 UNION ALL 
        SELECT 1217, 'Glazier - Construction Industry', 'GAB00998',1,2 UNION ALL 
        SELECT 1218, 'Glazier - Motor Vehicle & Cycle Industry', 'GAB00999',1,2 UNION ALL 
        SELECT 1219, 'Gold Beater', 'GAB01000',0,1 UNION ALL 
        SELECT 1220, 'Goldsmith   ', 'GAC02807',0,1 UNION ALL 
        SELECT 1221, 'Golf - Caddie', 'GAB01001',0,1 UNION ALL 
        SELECT 1222, 'Golf - Professional', 'GAB01002',1,2 UNION ALL 
        SELECT 1223, 'Governor', 'GAB01003',0,1 UNION ALL 
        SELECT 1224, 'Grader', 'GAB01004',0,1 UNION ALL 
        SELECT 1225, 'Grader (scrap metal)', 'GAB01005',1,2 UNION ALL 
        SELECT 1226, 'Graduator', 'GAB01006',1,2 UNION ALL 
        SELECT 1227, 'Grain Merchant (office based)    ', 'GAC02808',0,1 UNION ALL 
        SELECT 1228, 'Graphic Designer    ', 'GAC02809',0,1 UNION ALL 
        SELECT 1229, 'Grave Digger', 'GAB01007',0,1 UNION ALL 
        SELECT 1230, 'Greaser - Fishing Industry', 'GAB01008',1,2 UNION ALL 
        SELECT 1231, 'Greaser - Merchant Marine', 'GAB01009',1,2 UNION ALL 
        SELECT 1232, 'Greengrocer ', 'GAC02810',1,2 UNION ALL 
        SELECT 1233, 'Greenkeeper', 'GAB01010',0,1 UNION ALL 
        SELECT 1234, 'Greyhound Breeder   ', 'GAC02811',1,2 UNION ALL 
        SELECT 1235, 'Grinder - Machining, Shaping etc - Metal Manufacture', 'GAB01012',1,2 UNION ALL 
        SELECT 1236, 'Grinder - Steel Cutter   ', 'GAC02812',1,2 UNION ALL 
        SELECT 1237, 'Grinder - Stoneworking', 'GAB01013',1,2 UNION ALL 
        SELECT 1238, 'Grinder - Tea & Coffee - Food & Drink', 'GAB01011',1,2 UNION ALL 
        SELECT 1239, 'Grinder (Milling)', 'GAB01014',1,2 UNION ALL 
        SELECT 1240, 'Grinder/Roller Operator (cheese)', 'GAB01015',1,2 UNION ALL 
        SELECT 1241, 'Grinderman', 'GAB01016',1,2 UNION ALL 
        SELECT 1242, 'Grinding Machine Operator', 'GAB01017',1,2 UNION ALL 
        SELECT 1243, 'Grindstone Maker', 'GAB01018',1,2 UNION ALL 
        SELECT 1244, 'Grocer  ', 'GAC02813',0,1 UNION ALL 
        SELECT 1245, 'Groom', 'GAB01019',0,1 UNION ALL 
        SELECT 1246, 'Ground Equipment Service Mechanic', 'GAB01020',0,1 UNION ALL 
        SELECT 1247, 'Ground Hostess/Steward', 'GAB01021',0,1 UNION ALL 
        SELECT 1248, 'Ground Movement Controller', 'GAB01022',0,1 UNION ALL 
        SELECT 1249, 'Groundsman', 'GAB01023',0,1 UNION ALL 
        SELECT 1250, 'Grouter - Oil Rig Industry  ', 'GAC02814',1,2 UNION ALL 
        SELECT 1251, 'Guard', 'GAB01024',1,2 UNION ALL 
        SELECT 1252, 'Guest House Proprietor  ', 'GAC02815',0,1 UNION ALL 
        SELECT 1253, 'Guest House Proprietor (admin. only) ', 'GAC02816',0,1 UNION ALL 
        SELECT 1254, 'Guillotine Operator', 'GAB01025',0,1 UNION ALL 
        SELECT 1255, 'Gummer', 'GAB01026',0,1 UNION ALL 
        SELECT 1256, 'Gymnastics', 'GAB01027',1,2 UNION ALL 
        SELECT 1257, 'Haberdasher ', 'HAC02817',0,1 UNION ALL 
        SELECT 1258, 'Hairdresser - Mobile', 'HAB01028',0,1 UNION ALL 
        SELECT 1259, 'Hairdresser - Salon', 'HAB01029',0,1 UNION ALL 
        SELECT 1260, 'Hairdresser Shop Manager - admin only', 'HAC02818',0,2 UNION ALL 
        SELECT 1261, 'Hairdresser Shop Proprietor ', 'HAC02819',0,1 UNION ALL 
        SELECT 1262, 'Hammerman - Construction Industry', 'HAB01030',1,2 UNION ALL 
        SELECT 1263, 'Hammerman - Precious Metals, Engraving etc - Metal Manufacture', 'HAB01031',1,2 UNION ALL 
        SELECT 1264, 'Hand Coverer', 'HAB01032',1,2 UNION ALL 
        SELECT 1265, 'Hand Decorator', 'HAB01033',1,2 UNION ALL 
        SELECT 1266, 'Hand Dipper', 'HAB01034',1,2 UNION ALL 
        SELECT 1267, 'Hand Finisher', 'HAB01035',1,2 UNION ALL 
        SELECT 1268, 'Handle Mounter', 'HAB01036',1,2 UNION ALL 
        SELECT 1269, 'Handyman', 'HAB01037',0,1 UNION ALL 
        SELECT 1270, 'Harbour Master', 'HAB01038',0,1 UNION ALL 
        SELECT 1271, 'Harbour Pilot   ', 'HAC02820',0,1 UNION ALL 
        SELECT 1272, 'Hard Ground Man', 'HAB01039',1,2 UNION ALL 
        SELECT 1273, 'Hardener', 'HAB01040',1,2 UNION ALL 
        SELECT 1274, 'Hardware Dealer ', 'HAC02821',1,2 UNION ALL 
        SELECT 1275, 'Harness Maker', 'HAB01041',0,1 UNION ALL 
        SELECT 1276, 'Harpooner', 'HAB01042',1,2 UNION ALL 
        SELECT 1277, 'Hat Maker', 'HAB01043',0,1 UNION ALL 
        SELECT 1278, 'Hatchery Worker', 'HAB01044',0,1 UNION ALL 
        SELECT 1279, 'Haulage Contractor  ', 'HAC02822',0,1 UNION ALL 
        SELECT 1280, 'Haulage Electrician', 'HAB01045',1,2 UNION ALL 
        SELECT 1281, 'Haulier (no driving)', 'HAB01046',0,1 UNION ALL 
        SELECT 1282, 'Head Gardener', 'HAB01047',0,1 UNION ALL 
        SELECT 1283, 'Head Groundsman', 'HAB01048',0,1 UNION ALL 
        SELECT 1284, 'Head Keeper - Zoo', 'HAB01049',0,1 UNION ALL 
        SELECT 1285, 'Head Roustabout', 'HAB01050',0,1 UNION ALL 
        SELECT 1286, 'Head Shunter', 'HAB01051',1,2 UNION ALL 
        SELECT 1287, 'Headteacher   ', 'HAC02823',0,1 UNION ALL 
        SELECT 1288, 'Health & Safety Officer ', 'HAC02824',0,1 UNION ALL 
        SELECT 1289, 'Health and Fitness Club Manager (admin. only)    ', 'HAC02825',0,1 UNION ALL 
        SELECT 1290, 'Health and Fitness Club Trainer ', 'HAC02826',0,1 UNION ALL 
        SELECT 1291, 'Health Counsellor   ', 'HAC02827',0,1 UNION ALL 
        SELECT 1292, 'Health Physics Monitor', 'HAB01052',1,2 UNION ALL 
        SELECT 1293, 'Health Radiation Monitor', 'HAB01053',0,1 UNION ALL 
        SELECT 1294, 'Health Visitor  ', 'HAC02828',0,1 UNION ALL 
        SELECT 1295, 'Heat Treating', 'HAB01054',1,2 UNION ALL 
        SELECT 1296, 'Heat Treating - Cooker Operator', 'HAB01055',1,2 UNION ALL 
        SELECT 1297, 'Heat Treating - Drier Attendant', 'HAB01056',1,2 UNION ALL 
        SELECT 1298, 'Heat Treating - Kiln Attendant', 'HAB01057',1,2 UNION ALL 
        SELECT 1299, 'Heat Treating - Melter', 'HAB01058',1,2 UNION ALL 
        SELECT 1300, 'Heat Treating - Oven Attendant', 'HAB01059',1,2 UNION ALL 
        SELECT 1301, 'Heat Treating Worker - Minerals', 'HAB01060',1,2 UNION ALL 
        SELECT 1302, 'Heat Treating Worker - Optical Goods Industry', 'HAB01061',1,2 UNION ALL 
        SELECT 1303, 'Heat Treating: - Furnaceman', 'HAB01062',1,2 UNION ALL 
        SELECT 1304, 'Heater', 'HAB01063',1,2 UNION ALL 
        SELECT 1305, 'Heating and Ventilating Fitter  ', 'HAC02829',0,1 UNION ALL 
        SELECT 1306, 'Heavy Goods Driver (no loading) UK only ', 'HAC02830',0,1 UNION ALL 
        SELECT 1307, 'Heavy Goods Vehicle Driver', 'HAB01064',0,1 UNION ALL 
        SELECT 1308, 'Helicopter Aviation', 'HAB01065',1,2 UNION ALL 
        SELECT 1309, 'Helicopter Engineer ', 'HAC02831',0,1 UNION ALL 
        SELECT 1310, 'Helicopter Pilot - Oil Rig Industry ', 'HAC02832',0,1 UNION ALL 
        SELECT 1311, 'Helicopter Pilot - Onshore  ', 'HAC02833',0,1 UNION ALL 
        SELECT 1312, 'Historic Building Guide', 'HAB01066',0,1 UNION ALL 
        SELECT 1313, 'Hoist Driver', 'HAB01067',0,1 UNION ALL 
        SELECT 1314, 'Hoist Operator - Construction Industry', 'HAB01068',1,2 UNION ALL 
        SELECT 1315, 'Hoist Operator - Quarrying', 'HAB01069',1,2 UNION ALL 
        SELECT 1316, 'Hoist Operator - Ship Building, Ship Repair & Marine Engineering', 'HAB01070',1,2 UNION ALL 
        SELECT 1317, 'Hoist Operator -Coastal etc', 'HAB01071',1,2 UNION ALL 
        SELECT 1318, 'Hoist Operator -Deep Sea', 'HAB01072',1,2 UNION ALL 
        SELECT 1319, 'Hoistman', 'HAB01073',1,2 UNION ALL 
        SELECT 1320, 'Home Help   ', 'HAC02834',0,1 UNION ALL 
        SELECT 1321, 'Home Service Adviser', 'HAB01074',1,2 UNION ALL 
        SELECT 1322, 'Homeless Centre Manager (admin. only) ', 'HAC02835',0,1 UNION ALL 
        SELECT 1323, 'Homeopath   ', 'HAC02836',0,1 UNION ALL 
        SELECT 1324, 'Homogeniser', 'HAB01075',1,2 UNION ALL 
        SELECT 1325, 'Horse Breeder', 'HAB01076',0,1 UNION ALL 
        SELECT 1326, 'Horse Racing - Flat Jockey', 'HAB01077',0,1 UNION ALL 
        SELECT 1327, 'Horse racing - National Hunt', 'HAB01078',0,1 UNION ALL 
        SELECT 1328, 'Horse Racing Race Horse Trainer', 'HAB01079',1,2 UNION ALL 
        SELECT 1329, 'Horse-drawn Vehicle Driver', 'HAB01080',1,2 UNION ALL 
        SELECT 1330, 'Horticulturist  ', 'HAC02837',0,1 UNION ALL 
        SELECT 1331, 'Hoseman', 'HAB01081',1,2 UNION ALL 
        SELECT 1332, 'Hospital Matron', 'HAB01082',0,1 UNION ALL 
        SELECT 1333, 'Hospital Porter - Health', 'HAB01084',0,1 UNION ALL 
        SELECT 1334, 'Hospital Porter - N/A', 'HAB01083',1,2 UNION ALL 
        SELECT 1335, 'Hospital Storeman', 'HAB01085',0,1 UNION ALL 
        SELECT 1336, 'Hospital Ward Orderly', 'HAB01086',0,1 UNION ALL 
        SELECT 1337, 'Hostel Matron', 'HAB01087',0,1 UNION ALL 
        SELECT 1338, 'Hostel Warden', 'HAB01088',0,1 UNION ALL 
        SELECT 1339, 'Hostess', 'HAB01089',0,1 UNION ALL 
        SELECT 1340, 'Hotel Detective', 'HAB01090',0,1 UNION ALL 
        SELECT 1341, 'Hotel Doorman', 'HAB01091',0,1 UNION ALL 
        SELECT 1342, 'Hotel Maid', 'HAB01092',0,1 UNION ALL 
        SELECT 1343, 'Hotel Manager (office based) ', 'HAC02838',0,1 UNION ALL 
        SELECT 1344, 'Hotel Manager (salaried)', 'HAB01093',1,2 UNION ALL 
        SELECT 1345, 'Hotel Porter', 'HAB01094',0,1 UNION ALL 
        SELECT 1346, 'Hotel Proprietor', 'HAB01095',0,1 UNION ALL 
        SELECT 1347, 'Hotel Receptionist', 'HAB01096',0,1 UNION ALL 
        SELECT 1348, 'House Maid', 'HAB01097',0,1 UNION ALL 
        SELECT 1349, 'Housekeeper', 'HAB01098',0,1 UNION ALL 
        SELECT 1350, 'Housewife/House-Husband', 'HAB01099',0,1 UNION ALL 
        SELECT 1351, 'Housing Association Development Manager (inc. site visits)  ', 'HAC02839',0,1 UNION ALL 
        SELECT 1352, 'Housing Inspector', 'HAB01100',0,1 UNION ALL 
        SELECT 1353, 'Housing Manager ', 'HAC02840',0,1 UNION ALL 
        SELECT 1354, 'Hydro-Extractor Operator - Dry Cleaning', 'HAB01101',1,2 UNION ALL 
        SELECT 1355, 'Hydro-Extractor Operator - Laundry', 'HAB01102',1,2 UNION ALL 
        SELECT 1356, 'Hydrographic Engineer/Surveyor', 'HAC02841',0,2 UNION ALL 
        SELECT 1357, 'Hydrographic Surveyor', 'HAB01103',1,2 UNION ALL 
        SELECT 1358, 'Hygienist   ', 'HAC02842',0,1 UNION ALL 
        SELECT 1359, 'Hypnotherapist', 'HAB01104',0,1 UNION ALL 
        SELECT 1360, 'Hypnotist', 'HAB01105',0,1 UNION ALL 
        SELECT 1361, 'Ice Cream Manufacturer  ', 'IAC02844',1,2 UNION ALL 
        SELECT 1362, 'Ice Cream Manufacturer (supervisory)  ', 'IAC02845',1,2 UNION ALL 
        SELECT 1363, 'Ice Cream Van Driver', 'IAB01106',0,1 UNION ALL 
        SELECT 1364, 'Ice Cream Vendor (mobile)  ', 'IAC02843',1,2 UNION ALL 
        SELECT 1365, 'Ice Hockey', 'IAB01107',1,2 UNION ALL 
        SELECT 1366, 'Ice Room Attendant', 'IAB01108',1,2 UNION ALL 
        SELECT 1367, 'Ice Skating', 'IAB01109',1,2 UNION ALL 
        SELECT 1368, 'Illusionist', 'IAB01110',0,1 UNION ALL 
        SELECT 1369, 'Illustrator ', 'IAC02846',0,1 UNION ALL 
        SELECT 1370, 'Impersonator', 'IAB01111',0,1 UNION ALL 
        SELECT 1371, 'Importer', 'IAB01112',0,2 UNION ALL 
        SELECT 1372, 'Impresario', 'IAB01113',1,2 UNION ALL 
        SELECT 1373, 'Incinerator Operator', 'IAB01114',0,1 UNION ALL 
        SELECT 1374, 'Industrial Designer', 'IAC02847',0,2 UNION ALL 
        SELECT 1375, 'Industrial Photographer', 'IAB01115',1,2 UNION ALL 
        SELECT 1376, 'Industrial Relations Officer    ', 'IAC02848',0,1 UNION ALL 
        SELECT 1377, 'Industrial Safety Officer - Usually ..', 'IAB01116',1,2 UNION ALL 
        SELECT 1378, 'Industrial Trainer  ', 'IAC02849',0,1 UNION ALL 
        SELECT 1379, 'Industrial/Commercial Storeman', 'IAB01117',1,2 UNION ALL 
        SELECT 1380, 'Inseminator', 'IAB01118',0,1 UNION ALL 
        SELECT 1381, 'Inspector - Asbestos', 'IAB01141',1,2 UNION ALL 
        SELECT 1382, 'Inspector - Brick, Pipe & Tile Manufacture', 'IAB01119',1,2 UNION ALL 
        SELECT 1383, 'Inspector - Chemical & Plastics Industry', 'IAB01120',1,2 UNION ALL 
        SELECT 1384, 'Inspector - Cork Goods Manufacture', 'IAB01121',1,2 UNION ALL 
        SELECT 1385, 'Inspector - Dry Cleaning', 'IAB01122',1,2 UNION ALL 
        SELECT 1386, 'Inspector - Electronic Goods Manufacture', 'IAB01123',1,2 UNION ALL 
        SELECT 1387, 'Inspector - Food & Drink - General', 'IAB01124',1,2 UNION ALL 
        SELECT 1388, 'Inspector - Glass/Glass Fibre Manufacture', 'IAB01125',1,2 UNION ALL 
        SELECT 1389, 'Inspector - Laundry', 'IAB01126',1,2 UNION ALL 
        SELECT 1390, 'Inspector - Leather & Fur Industries', 'IAB01127',1,2 UNION ALL 
        SELECT 1391, 'Inspector - Minerals', 'IAB01129',1,2 UNION ALL 
        SELECT 1392, 'Inspector - Misc. Workers - Metal Manufacture', 'IAB01128',1,2 UNION ALL 
        SELECT 1393, 'Inspector - Motor Vehicle & Cycle Industry', 'IAB01130',1,2 UNION ALL 
        SELECT 1394, 'Inspector - Oil & Natural Gas Industries (Exploration & Production)', 'IAB01131',1,2 UNION ALL 
        SELECT 1395, 'Inspector - Optical Goods Industry', 'IAB01132',1,2 UNION ALL 
        SELECT 1396, 'Inspector - Paper & Board Manufacture', 'IAB01133',1,2 UNION ALL 
        SELECT 1397, 'Inspector - Plasterboard Making Industry', 'IAB01134',1,2 UNION ALL 
        SELECT 1398, 'Inspector - Pottery Industry', 'IAB01135',1,2 UNION ALL 
        SELECT 1399, 'Inspector - Rubber Industry - Natural', 'IAB01137',1,2 UNION ALL 
        SELECT 1400, 'Inspector - Statutory   ', 'IAC02850',1,2 UNION ALL 
        SELECT 1401, 'Inspector - Textile & Clothing Industry', 'IAB01138',1,2 UNION ALL 
        SELECT 1402, 'Inspector - Tobacco Industry', 'IAB01139',1,2 UNION ALL 
        SELECT 1403, 'Inspector - Track Maintenance - Railways', 'IAB01136',1,2 UNION ALL 
        SELECT 1404, 'Inspector - Water Supply Industry', 'IAB01140',1,2 UNION ALL 
        SELECT 1405, 'Inspector (Electrical Installations)', 'IAB01142',1,2 UNION ALL 
        SELECT 1406, 'Inspector (Gas Installations)', 'IAB01143',1,2 UNION ALL 
        SELECT 1407, 'Inspector of Mines', 'IAB01144',1,2 UNION ALL 
        SELECT 1408, 'Inspector-Rectifier', 'IAB01145',1,2 UNION ALL 
        SELECT 1409, 'Installation Electrician', 'IAB01146',1,2 UNION ALL 
        SELECT 1410, 'Installation Fitter', 'IAB01147',1,2 UNION ALL 
        SELECT 1411, 'Installer (Track Equipment)', 'IAB01148',1,2 UNION ALL 
        SELECT 1412, 'Instructor Diver', 'IAB01149',1,2 UNION ALL 
        SELECT 1413, 'Instructors', 'IAB01150',1,2 UNION ALL 
        SELECT 1414, 'Instrument Maker    ', 'IAC02851',0,1 UNION ALL 
        SELECT 1415, 'Instrument Repairer ', 'IAC02852',0,1 UNION ALL 
        SELECT 1416, 'Insulator', 'IAB01151',1,2 UNION ALL 
        SELECT 1417, 'Insulator - no asbestos work - Construction Industry', 'IAB01152',1,2 UNION ALL 
        SELECT 1418, 'Insulator - no asbestos work - Ship Building, Ship Repair & Marine Engineering', 'IAB01153',1,2 UNION ALL 
        SELECT 1419, 'Insurance Agent', 'IAB01154',0,1 UNION ALL 
        SELECT 1420, 'Insurance Assessor', 'IAB01155',0,1 UNION ALL 
        SELECT 1421, 'Insurance Broker', 'IAB01156',0,1 UNION ALL 
        SELECT 1422, 'Insurance Inspector', 'IAB01157',0,1 UNION ALL 
        SELECT 1423, 'Interior Designer   ', 'IAC02853',0,1 UNION ALL 
        SELECT 1424, 'Interpreter', 'IAB01158',0,1 UNION ALL 
        SELECT 1425, 'Intertype Operator', 'IAB01159',1,2 UNION ALL 
        SELECT 1426, 'Interviewer - no travel etc', 'IAB01160',1,2 UNION ALL 
        SELECT 1427, 'Interviewer - otherwise', 'IAB01161',1,2 UNION ALL 
        SELECT 1428, 'Inversion Attendant', 'IAB01162',1,2 UNION ALL 
        SELECT 1429, 'Investment Analyst  ', 'IAC02854',0,1 UNION ALL 
        SELECT 1430, 'Ironer', 'IAB01163',0,1 UNION ALL 
        SELECT 1431, 'Janitor ', 'JAC02855',0,1 UNION ALL 
        SELECT 1432, 'Jazz Musician', 'JAB01164',1,2 UNION ALL 
        SELECT 1433, 'Jazz Singer', 'JAB01165',1,2 UNION ALL 
        SELECT 1434, 'Jehovah''s Witness', 'JAB01166',1,2 UNION ALL 
        SELECT 1435, 'Jetty Hand', 'JAB01167',0,1 UNION ALL 
        SELECT 1436, 'Jeweller    ', 'JAC02856',0,1 UNION ALL 
        SELECT 1437, 'Jewellery Enameller', 'JAB01168',0,1 UNION ALL 
        SELECT 1438, 'Jewellery Making & Repair', 'JAB01169',0,1 UNION ALL 
        SELECT 1439, 'Jewellery Mounter', 'JAB01170',0,1 UNION ALL 
        SELECT 1440, 'Jib Crane Driver', 'JAB01171',1,2 UNION ALL 
        SELECT 1441, 'Jig Loader', 'JAB01172',1,2 UNION ALL 
        SELECT 1442, 'Joiner - Construction Industry', 'JAB01173',0,1 UNION ALL 
        SELECT 1443, 'Joiner - Ship Building, Ship Repair & Marine Engineering', 'JAB01174',0,1 UNION ALL 
        SELECT 1444, 'Jointer', 'JAB01175',0,1 UNION ALL 
        SELECT 1445, 'Journalist - no overseas travel etc', 'JAB01176',0,2 UNION ALL 
        SELECT 1446, 'Journalist - otherwise', 'JAB01177',0,1 UNION ALL 
        SELECT 1447, 'Judge', 'JAB01178',0,1 UNION ALL 
        SELECT 1448, 'Judge''s Clerk', 'JAB01179',0,1 UNION ALL 
        SELECT 1449, 'Juggler', 'JAB01180',0,1 UNION ALL 
        SELECT 1450, 'Keeper - Zoo', 'KAB01181',0,1 UNION ALL 
        SELECT 1451, 'Kennel Hand ', 'KAC02857',0,1 UNION ALL 
        SELECT 1452, 'Kennelmaid', 'KAB01182',1,2 UNION ALL 
        SELECT 1453, 'Kennelman', 'KAB01183',1,2 UNION ALL 
        SELECT 1454, 'Kerb Layer', 'KAB01184',0,1 UNION ALL 
        SELECT 1455, 'Keyboard Operator (type setting)', 'KAB01185',0,1 UNION ALL 
        SELECT 1456, 'Kiln Attendant', 'KAB01186',0,1 UNION ALL 
        SELECT 1457, 'Kiln Operator', 'KAB01187',0,1 UNION ALL 
        SELECT 1458, 'Kiln Worker - Cement Works', 'KAB01188',1,2 UNION ALL 
        SELECT 1459, 'Kiln Worker - Pottery Industry', 'KAB01189',1,2 UNION ALL 
        SELECT 1460, 'Kilnman Maltster', 'KAB01190',1,2 UNION ALL 
        SELECT 1461, 'Kitchen Hand', 'KAB01191',1,2 UNION ALL 
        SELECT 1462, 'Kitchen Porter', 'KAB01192',0,1 UNION ALL 
        SELECT 1463, 'Kitchen Staff   ', 'KAC02858',0,1 UNION ALL 
        SELECT 1464, 'Kitchen Superintendent', 'KAB01193',1,2 UNION ALL 
        SELECT 1465, 'Knife Thrower', 'KAB01194',0,1 UNION ALL 
        SELECT 1466, 'Knitter', 'KAB01195',0,1 UNION ALL 
        SELECT 1467, 'Labeller', 'LAB01196',0,1 UNION ALL 
        SELECT 1468, 'Labelling Machine Attendant', 'LAB01197',1,2 UNION ALL 
        SELECT 1469, 'Laboratory Manager (supervisory and some testing)    ', 'LAC02859',0,1 UNION ALL 
        SELECT 1470, 'Laboratory Technician   ', 'LAC02860',0,1 UNION ALL 
        SELECT 1471, 'Laboratory Technician - Adhesives Manufacture', 'LAB01198',1,2 UNION ALL 
        SELECT 1472, 'Laboratory Technician - Chemical & Plastics Industry', 'LAB01199',1,2 UNION ALL 
        SELECT 1473, 'Laboratory Technician - Glass/Glass Fibre Manufacture', 'LAB01200',1,2 UNION ALL 
        SELECT 1474, 'Laboratory Worker - Oil Rig Industry    ', 'LAC02861',1,2 UNION ALL 
        SELECT 1475, 'Labourer - Adhesives Manufacture', 'LAB01202',1,2 UNION ALL 
        SELECT 1476, 'Labourer - Aircraft/Aerospace', 'LAB01201',1,2 UNION ALL 
        SELECT 1477, 'Labourer - Asbestos', 'LAB01203',1,2 UNION ALL 
        SELECT 1478, 'Labourer - Battery/Accumulator Manufacture', 'LAB01241',1,2 UNION ALL 
        SELECT 1479, 'Labourer - Beer, Wine etc - Food & Drink', 'LAB01210',1,2 UNION ALL 
        SELECT 1480, 'Labourer - Brick, Pipe & Tile Manufacture', 'LAB01204',1,2 UNION ALL 
        SELECT 1481, 'Labourer - Building and Construction   ', 'LAC02862',1,2 UNION ALL 
        SELECT 1482, 'Labourer - Cement Works', 'LAB01205',1,2 UNION ALL 
        SELECT 1483, 'Labourer - Chemical & Plastics Industry', 'LAB01206',1,2 UNION ALL 
        SELECT 1484, 'Labourer - Circus - Entertainment', 'LAB01209',1,2 UNION ALL 
        SELECT 1485, 'Labourer - Confectionery etc - Food & Drink', 'LAB01211',1,2 UNION ALL 
        SELECT 1486, 'Labourer - Electrical Supply', 'LAB01208',1,2 UNION ALL 
        SELECT 1487, 'Labourer - Electronic Goods Manufacture', 'LAB01207',1,2 UNION ALL 
        SELECT 1488, 'Labourer - Food & Drink - General', 'LAB01213',1,2 UNION ALL 
        SELECT 1489, 'Labourer - Forging - Metal Manufacture', 'LAB01219',1,2 UNION ALL 
        SELECT 1490, 'Labourer - Fruit & Veg. - Food & Drink', 'LAB01212',1,2 UNION ALL 
        SELECT 1491, 'Labourer - Furnace - Metal Manufacture', 'LAB01220',1,2 UNION ALL 
        SELECT 1492, 'Labourer - Gas Supply Industry', 'LAB01216',1,2 UNION ALL 
        SELECT 1493, 'Labourer - Glass/Glass Fibre Manufacture', 'LAB01217',1,2 UNION ALL 
        SELECT 1494, 'Labourer - Leather & Fur Industries', 'LAB01218',1,2 UNION ALL 
        SELECT 1495, 'Labourer - Meat, Fish etc - Food & Drink', 'LAB01214',1,2 UNION ALL 
        SELECT 1496, 'Labourer - Metal Plating & Coating - Metal Manufacture', 'LAB01221',1,2 UNION ALL 
        SELECT 1497, 'Labourer - Minerals', 'LAB01227',1,2 UNION ALL 
        SELECT 1498, 'Labourer - Misc. Workers - Metal Manufacture', 'LAB01222',1,2 UNION ALL 
        SELECT 1499, 'Labourer - Motor Vehicle & Cycle Industry', 'LAB01228',1,2 UNION ALL 
        SELECT 1500, 'Labourer - Moulders, etc - Metal Manufacture', 'LAB01223',1,2 UNION ALL 
        SELECT 1501, 'Labourer - Musical Instrument Making & Repair', 'LAB01229',1,2 UNION ALL 
        SELECT 1502, 'Labourer - Nuclear Energy', 'LAB01230',1,2 UNION ALL 
        SELECT 1503, 'Labourer - Oil Rig Industry ', 'LAC02863',1,2 UNION ALL 
        SELECT 1504, 'Labourer - Optical Goods Industry', 'LAB01231',1,2 UNION ALL 
        SELECT 1505, 'Labourer - Pipe, Sheet, Wire etc - Metal Manufacture', 'LAB01224',1,2 UNION ALL 
        SELECT 1506, 'Labourer - Pottery Industry', 'LAB01232',1,2 UNION ALL 
        SELECT 1507, 'Labourer - Production Fitting - Metal Manufacture', 'LAB01225',1,2 UNION ALL 
        SELECT 1508, 'Labourer - Quarrying', 'LAB01233',1,2 UNION ALL 
        SELECT 1509, 'Labourer - Road Maintenance & Construction', 'LAB01234',1,2 UNION ALL 
        SELECT 1510, 'Labourer - Rolling, Extruding etc - Metal Manufacture', 'LAB01226',1,2 UNION ALL 
        SELECT 1511, 'Labourer - Rubber Industry - Natural', 'LAB01235',1,2 UNION ALL 
        SELECT 1512, 'Labourer - Ship Building, Ship Repair & Marine Engineering', 'LAB01236',1,2 UNION ALL 
        SELECT 1513, 'Labourer - Sugar Production - Food & Drink', 'LAB01215',1,2 UNION ALL 
        SELECT 1514, 'Labourer - Textile & Clothing Industry', 'LAB01242',1,2 UNION ALL 
        SELECT 1515, 'Labourer - Tobacco Industry', 'LAB01237',1,2 UNION ALL 
        SELECT 1516, 'Labourer - Upholstery, Soft Furnishings, Mattress Making & Repair', 'LAB01238',1,2 UNION ALL 
        SELECT 1517, 'Labourer - Water Supply Industry', 'LAB01239',1,2 UNION ALL 
        SELECT 1518, 'Labourer - Woodworking Industry', 'LAB01240',1,2 UNION ALL 
        SELECT 1519, 'Labourer, Mate', 'LAB01243',1,2 UNION ALL 
        SELECT 1520, 'Ladle Engineman', 'LAB01244',1,2 UNION ALL 
        SELECT 1521, 'Lady''s Maid', 'LAB01245',1,2 UNION ALL 
        SELECT 1522, 'Lagger', 'LAB01246',0,1 UNION ALL 
        SELECT 1523, 'Lagger - no asbestos work - Construction Industry', 'LAB01247',1,2 UNION ALL 
        SELECT 1524, 'Lagger - no asbestos work - Ship Building, Ship Repair & Marine Engineering', 'LAB01248',1,2 UNION ALL 
        SELECT 1525, 'Laminator', 'LAB01249',0,2 UNION ALL 
        SELECT 1526, 'Lampman', 'LAB01250',1,2 UNION ALL 
        SELECT 1527, 'Land Agent', 'LAB01251',0,1 UNION ALL 
        SELECT 1528, 'Land Drainage Worker', 'LAB01252',0,1 UNION ALL 
        SELECT 1529, 'Land Surveyor', 'LAB01253',0,1 UNION ALL 
        SELECT 1530, 'Landlord (Property -no manual work )', 'LAC02864',0,2 UNION ALL 
        SELECT 1531, 'Landscape Gardener', 'LAB01254',0,1 UNION ALL 
        SELECT 1532, 'Landscape Painter', 'LAB01255',0,1 UNION ALL 
        SELECT 1533, 'Lapidary', 'LAB01256',1,2 UNION ALL 
        SELECT 1534, 'Lathe Operator - Machining, Shaping etc - Metal Manufacture', 'LAB01257',1,2 UNION ALL 
        SELECT 1535, 'Lathe Operator - Woodworking Industry', 'LAB01258',1,2 UNION ALL 
        SELECT 1536, 'Lathe Turner    ', 'LAC02865',1,2 UNION ALL 
        SELECT 1537, 'Launderer   ', 'LAC02866',1,2 UNION ALL 
        SELECT 1538, 'Launderette Assistant', 'LAB01259',0,1 UNION ALL 
        SELECT 1539, 'Laundry Roundsman', 'LAB01260',1,2 UNION ALL 
        SELECT 1540, 'Laundryman', 'LAB01261',0,1 UNION ALL 
        SELECT 1541, 'Lavatory Attendant', 'LAB01262',0,1 UNION ALL 
        SELECT 1542, 'Law Shop Advisor    ', 'LAC02867',1,2 UNION ALL 
        SELECT 1543, 'Lawn Tennis', 'LAB01263',1,2 UNION ALL 
        SELECT 1544, 'Lawyer  ', 'LAC02868',0,1 UNION ALL 
        SELECT 1545, 'Lead Paster', 'LAB01264',1,2 UNION ALL 
        SELECT 1546, 'Leading Fireman', 'LAB01265',0,1 UNION ALL 
        SELECT 1547, 'Leading Hand', 'LAB01266',1,2 UNION ALL 
        SELECT 1548, 'Leadsman', 'LAB01267',1,2 UNION ALL 
        SELECT 1549, 'Leather Technologist', 'LAB01268',0,1 UNION ALL 
        SELECT 1550, 'Lecturer', 'LAB01269',0,2 UNION ALL 
        SELECT 1551, 'Lecturer (part time)', 'LAB01270',1,2 UNION ALL 
        SELECT 1552, 'Left Luggage Attendant', 'LAB01271',0,1 UNION ALL 
        SELECT 1553, 'Legal Adviser   ', 'LAC02869',0,1 UNION ALL 
        SELECT 1554, 'Legal Executive ', 'LAC02870',0,1 UNION ALL 
        SELECT 1555, 'Leisure Centre Instructor   ', 'LAC02871',1,2 UNION ALL 
        SELECT 1556, 'Lengthman', 'LAB01272',1,2 UNION ALL 
        SELECT 1557, 'Letter Cutter', 'LAB01273',1,2 UNION ALL 
        SELECT 1558, 'Letting Agent - Holiday homes    ', 'LAC02872',0,1 UNION ALL 
        SELECT 1559, 'Leveller', 'LAB01274',1,2 UNION ALL 
        SELECT 1560, 'Lexicographer   ', 'LAC02873',1,2 UNION ALL 
        SELECT 1561, 'Librarian', 'LAB01275',0,1 UNION ALL 
        SELECT 1562, 'Library Assistant   ', 'LAC02874',0,1 UNION ALL 
        SELECT 1563, 'Lifeboatman - Crew', 'LAC02875',0,2 UNION ALL 
        SELECT 1564, 'Lifeboatman (enrolled crew)', 'LAB01276',0,1 UNION ALL 
        SELECT 1565, 'Lifeguard', 'LAB01277',0,2 UNION ALL 
        SELECT 1566, 'Lift Attendant', 'LAB01278',0,1 UNION ALL 
        SELECT 1567, 'Lift Engineer   ', 'LAC02876',0,1 UNION ALL 
        SELECT 1568, 'Lift Erector    ', 'LAC02877',0,1 UNION ALL 
        SELECT 1569, 'Lift/Escalator Erector', 'LAB01279',1,2 UNION ALL 
        SELECT 1570, 'Light Goods Vehicle Driver', 'LAB01280',0,1 UNION ALL 
        SELECT 1571, 'Lighterman - Merchant Marine', 'LAB01281',1,2 UNION ALL 
        SELECT 1572, 'Lighterman - Quarrying', 'LAB01282',1,2 UNION ALL 
        SELECT 1573, 'Lighthouse Keeper', 'LAB01283',1,2 UNION ALL 
        SELECT 1574, 'Lighting Manager', 'LAB01284',0,1 UNION ALL 
        SELECT 1575, 'Lighting Technician', 'LAB01285',0,1 UNION ALL 
        SELECT 1576, 'Lightkeeper (Docks, Harbours)', 'LAB01286',1,2 UNION ALL 
        SELECT 1577, 'Linesman - Electrical Supply', 'LAB01287',1,2 UNION ALL 
        SELECT 1578, 'Linesman - Post Office/Telecommunications', 'LAB01288',1,2 UNION ALL 
        SELECT 1579, 'Linesman-Measurer', 'LAB01290',1,2 UNION ALL 
        SELECT 1580, 'Linesman''s Mate', 'LAB01289',0,1 UNION ALL 
        SELECT 1581, 'Linotype Operator', 'LAB01291',1,2 UNION ALL 
        SELECT 1582, 'Lion, Tiger Trainer/Keeper', 'LAB01292',1,2 UNION ALL 
        SELECT 1583, 'Liquidator  ', 'LAC02878',0,1 UNION ALL 
        SELECT 1584, 'Literary Agent', 'LAB01293',0,1 UNION ALL 
        SELECT 1585, 'Lithographer    ', 'LAC02879',0,1 UNION ALL 
        SELECT 1586, 'Lithographic Assistant', 'LAB01294',0,1 UNION ALL 
        SELECT 1587, 'Lithographic Plate Grainer', 'LAB01295',0,1 UNION ALL 
        SELECT 1588, 'Lithographic Plate Preparer', 'LAB01296',0,1 UNION ALL 
        SELECT 1589, 'Lithographic Preparer', 'LAB01297',1,2 UNION ALL 
        SELECT 1590, 'Loader - Airport', 'LAB01298',1,2 UNION ALL 
        SELECT 1591, 'Loader - Flour Milling - Food & Drink', 'LAB01299',1,2 UNION ALL 
        SELECT 1592, 'Loader - Quarrying', 'LAB01300',1,2 UNION ALL 
        SELECT 1593, 'Loader (Goods Vehicle)', 'LAB01301',1,2 UNION ALL 
        SELECT 1594, 'Loader (Surface)', 'LAB01302',1,2 UNION ALL 
        SELECT 1595, 'Loader Operator - Cement Works', 'LAB01303',1,2 UNION ALL 
        SELECT 1596, 'Loader Operator - Docks', 'LAB01304',1,2 UNION ALL 
        SELECT 1597, 'Loader Operator - Gas Supply Industry', 'LAB01305',1,2 UNION ALL 
        SELECT 1598, 'Lobster Fisherman', 'LAB01306',0,1 UNION ALL 
        SELECT 1599, 'Local Government Officer', 'LAB01307',0,1 UNION ALL 
        SELECT 1600, 'Local Newspaper Editor  ', 'LAC02880',0,1 UNION ALL 
        SELECT 1601, 'Lock Gateman', 'LAB01308',1,2 UNION ALL 
        SELECT 1602, 'Lock Keeper', 'LAB01309',0,1 UNION ALL 
        SELECT 1603, 'Lockmaster', 'LAB01310',1,2 UNION ALL 
        SELECT 1604, 'Locksmith', 'LAB01311',0,1 UNION ALL 
        SELECT 1605, 'Locomotive Driver', 'LAB01312',0,1 UNION ALL 
        SELECT 1606, 'Locomotive Guard', 'LAB01313',0,1 UNION ALL 
        SELECT 1607, 'Loom Former', 'LAB01314',1,2 UNION ALL 
        SELECT 1608, 'Loss Adjuster', 'LAB01315',0,1 UNION ALL 
        SELECT 1609, 'Lubricating Bay Attendant', 'LAB01316',1,2 UNION ALL 
        SELECT 1610, 'Lumberjack', 'LAB01317',0,1 UNION ALL 
        SELECT 1611, 'Machine Attendant', 'MAB01318',0,1 UNION ALL 
        SELECT 1612, 'Machine Maintenance Worker', 'MAB01319',0,1 UNION ALL 
        SELECT 1613, 'Machine Operator - Adhesives Manufacture', 'MAB01321',1,2 UNION ALL 
        SELECT 1614, 'Machine Operator - Aircraft/Aerospace', 'MAB01320',1,2 UNION ALL 
        SELECT 1615, 'Machine Operator - Asbestos', 'MAB01322',1,2 UNION ALL 
        SELECT 1616, 'Machine Operator - Battery/Accumulator Manufacture', 'MAB01323',1,2 UNION ALL 
        SELECT 1617, 'Machine Operator - Beer, Wine etc - Food & Drink', 'MAB01330',1,2 UNION ALL 
        SELECT 1618, 'Machine Operator - Brick, Pipe & Tile Manufacture', 'MAB01324',1,2 UNION ALL 
        SELECT 1619, 'Machine Operator - Cement Works', 'MAB01325',1,2 UNION ALL 
        SELECT 1620, 'Machine Operator - Chemical & Plastics Industry', 'MAB01326',1,2 UNION ALL 
        SELECT 1621, 'Machine Operator - Confectionery etc - Food & Drink', 'MAB01331',1,2 UNION ALL 
        SELECT 1622, 'Machine Operator - Cork Goods Manufacture', 'MAB01327',1,2 UNION ALL 
        SELECT 1623, 'Machine Operator - Electronic Goods Manufacture', 'MAB01328',1,2 UNION ALL 
        SELECT 1624, 'Machine Operator - Explosives Manufacture', 'MAB01329',1,2 UNION ALL 
        SELECT 1625, 'Machine Operator - Food & Drink - General', 'MAB01333',1,2 UNION ALL 
        SELECT 1626, 'Machine Operator - Fruit & Veg. - Food & Drink', 'MAB01332',1,2 UNION ALL 
        SELECT 1627, 'Machine Operator - Glass/Glass Fibre Manufacture', 'MAB01336',1,2 UNION ALL 
        SELECT 1628, 'Machine Operator - Leather & Fur Industries', 'MAB01337',1,2 UNION ALL 
        SELECT 1629, 'Machine Operator - Machining, Shaping etc - Metal Manufacture', 'MAB01338',1,2 UNION ALL 
        SELECT 1630, 'Machine Operator - Meat, Fish etc - Food & Drink', 'MAB01334',1,2 UNION ALL 
        SELECT 1631, 'Machine Operator - Minerals', 'MAB01339',1,2 UNION ALL 
        SELECT 1632, 'Machine Operator - Motor Vehicle & Cycle Industry', 'MAB01340',1,2 UNION ALL 
        SELECT 1633, 'Machine Operator - Musical Instrument Making & Repair', 'MAB01341',1,2 UNION ALL 
        SELECT 1634, 'Machine Operator - Optical Goods Industry', 'MAB01342',1,2 UNION ALL 
        SELECT 1635, 'Machine Operator - Paper & Board Manufacture', 'MAB01343',1,2 UNION ALL 
        SELECT 1636, 'Machine Operator - Photographic Processing Industry', 'MAB01344',1,2 UNION ALL 
        SELECT 1637, 'Machine Operator - Plasterboard Making Industry', 'MAB01345',1,2 UNION ALL 
        SELECT 1638, 'Machine Operator - Pottery Industry', 'MAB01346',1,2 UNION ALL 
        SELECT 1639, 'Machine Operator - Printing Industry', 'MAB01347',1,2 UNION ALL 
        SELECT 1640, 'Machine Operator - Rubber Industry - Natural', 'MAB01348',1,2 UNION ALL 
        SELECT 1641, 'Machine Operator - Stone Planing', 'MAB01354',1,2 UNION ALL 
        SELECT 1642, 'Machine Operator - Stone Sawing', 'MAB01355',1,2 UNION ALL 
        SELECT 1643, 'Machine Operator - Stone Splitting', 'MAB01356',1,2 UNION ALL 
        SELECT 1644, 'Machine Operator - Stoneworking', 'MAB01349',1,2 UNION ALL 
        SELECT 1645, 'Machine Operator - Sugar Production - Food & Drink', 'MAB01335',1,2 UNION ALL 
        SELECT 1646, 'Machine Operator - Textile & Clothing Industry', 'MAB01350',1,2 UNION ALL 
        SELECT 1647, 'Machine Operator - Tobacco Industry', 'MAB01351',1,2 UNION ALL 
        SELECT 1648, 'Machine Operator - Upholstery, Soft Furnishings, Mattress Making & Repair', 'MAB01352',1,2 UNION ALL 
        SELECT 1649, 'Machine Operator - Woodworking Industry', 'MAB01353',1,2 UNION ALL 
        SELECT 1650, 'Machine Tool Operator', 'MAB01357',1,2 UNION ALL 
        SELECT 1651, 'Machine Tool Setter-Operator', 'MAB01358',0,1 UNION ALL 
        SELECT 1652, 'Machine/Block Printer', 'MAB01359',1,2 UNION ALL 
        SELECT 1653, 'Machineman (Milling)', 'MAB01360',1,2 UNION ALL 
        SELECT 1654, 'Machinery Cleaner - Electrical Supply', 'MAB01362',1,2 UNION ALL 
        SELECT 1655, 'Machinery Cleaner - N/A', 'MAB01361',1,2 UNION ALL 
        SELECT 1656, 'Machinery Electrician', 'MAB01363',0,1 UNION ALL 
        SELECT 1657, 'Machinist - Production Fitting - Metal Manufacture', 'MAB01364',1,2 UNION ALL 
        SELECT 1658, 'Machinist - Toy Goods Manufacture', 'MAB01365',1,2 UNION ALL 
        SELECT 1659, 'Machinist - Umbrella Making', 'MAB01366',1,2 UNION ALL 
        SELECT 1660, 'Magician', 'MAB01367',0,1 UNION ALL 
        SELECT 1661, 'Magistrate - Stipendiary    ', 'MAC02881',0,1 UNION ALL 
        SELECT 1662, 'Mail Sorter ', 'MAC02882',0,1 UNION ALL 
        SELECT 1663, 'Maintenance - Domestic  ', 'MAC02883',1,2 UNION ALL 
        SELECT 1664, 'Maintenance Electrician - Electrical Supply', 'MAB01368',1,2 UNION ALL 
        SELECT 1665, 'Maintenance Electrician - Garage Trade', 'MAB01369',1,2 UNION ALL 
        SELECT 1666, 'Maintenance Engineer', 'MAB01370',1,2 UNION ALL 
        SELECT 1667, 'Maintenance Fitter - Radio & TV - Entertainment', 'MAB01371',1,2 UNION ALL 
        SELECT 1668, 'Maintenance Fitter - Train Maintenance - Railways', 'MAB01372',1,2 UNION ALL 
        SELECT 1669, 'Maintenance Fitter-Plant/Machinery', 'MAB01374',1,2 UNION ALL 
        SELECT 1670, 'Maintenance Fitter''s Mate-Plant etc', 'MAB01373',1,2 UNION ALL 
        SELECT 1671, 'Maintenance Manager - Airlines', 'MAB01375',1,2 UNION ALL 
        SELECT 1672, 'Maintenance Manager - Train Maintenance - Railways', 'MAB01376',1,2 UNION ALL 
        SELECT 1673, 'Maintenance Repairer', 'MAB01377',0,1 UNION ALL 
        SELECT 1674, 'Maintenance Technician - Adhesives Manufacture', 'MAB01379',1,2 UNION ALL 
        SELECT 1675, 'Maintenance Technician - Aircraft/Aerospace', 'MAB01378',1,2 UNION ALL 
        SELECT 1676, 'Maintenance Technician - Airlines', 'MAB01380',1,2 UNION ALL 
        SELECT 1677, 'Maintenance Technician - Chemical & Plastics Industry', 'MAB01381',1,2 UNION ALL 
        SELECT 1678, 'Maintenance Technician - Electronic Goods Manufacture', 'MAB01382',1,2 UNION ALL 
        SELECT 1679, 'Maintenance Technician - Minerals', 'MAB01384',1,2 UNION ALL 
        SELECT 1680, 'Maintenance Technician - Misc. Workers - Metal Manufacture', 'MAB01383',1,2 UNION ALL 
        SELECT 1681, 'Maintenance Technician - Motor Vehicle & Cycle Industry', 'MAB01385',1,2 UNION ALL 
        SELECT 1682, 'Maintenance Technician - Nuclear Energy', 'MAB01386',1,2 UNION ALL 
        SELECT 1683, 'Maintenance Technician - Oil Refining', 'MAB01387',1,2 UNION ALL 
        SELECT 1684, 'Maintenance Technician - Post Office/Telecommunications', 'MAB01388',1,2 UNION ALL 
        SELECT 1685, 'Maintenance Technician - Ship Building, Ship Repair & Marine Engineering', 'MAB01389',1,2 UNION ALL 
        SELECT 1686, 'Maker-up', 'MAB01392',1,2 UNION ALL 
        SELECT 1687, 'Make-up Artist', 'MAB01390',0,1 UNION ALL 
        SELECT 1688, 'Make-up Hand (filmset material)', 'MAB01391',1,2 UNION ALL 
        SELECT 1689, 'Malt Roaster', 'MAB01393',0,1 UNION ALL 
        SELECT 1690, 'Maltster', 'MAB01394',0,1 UNION ALL 
        SELECT 1691, 'Management Consultant - Usually', 'MAB01395',0,1 UNION ALL 
        SELECT 1692, 'Manager - Amusement Arcade - Entertainment', 'MAB01404',1,2 UNION ALL 
        SELECT 1693, 'Manager - Bingo - Entertainment', 'MAB01405',1,2 UNION ALL 
        SELECT 1694, 'Manager - Brick, Pipe & Tile Manufacture', 'MAB01402',1,2 UNION ALL 
        SELECT 1695, 'Manager - Cannery', 'MAB01438',1,2 UNION ALL 
        SELECT 1696, 'Manager - Cement Works', 'MAB01403',1,2 UNION ALL 
        SELECT 1697, 'Manager - Circus - Entertainment', 'MAB01406',1,2 UNION ALL 
        SELECT 1698, 'Manager - Club/Nightclub - Entertainment', 'MAB01407',1,2 UNION ALL 
        SELECT 1699, 'Manager - Dance Hall, Disco etc - Entertainment', 'MAB01408',1,2 UNION ALL 
        SELECT 1700, 'Manager - Factory - Food & Drink - General', 'MAB01439',1,2 UNION ALL 
        SELECT 1701, 'Manager - Factory - Misc. Workers - Metal Manufacture', 'MAB01440',1,2 UNION ALL 
        SELECT 1702, 'Manager - Fairground etc - Entertainment', 'MAB01409',1,2 UNION ALL 
        SELECT 1703, 'Manager - Foundry', 'MAB01441',1,2 UNION ALL 
        SELECT 1704, 'Manager - Garage Trade', 'MAB01396',1,2 UNION ALL 
        SELECT 1705, 'Manager - Gas Supply Industry', 'MAB01397',1,2 UNION ALL 
        SELECT 1706, 'Manager - Mining', 'MAB01398',1,2 UNION ALL 
        SELECT 1707, 'Manager - Post Office/Telecommunications', 'MAB01399',1,2 UNION ALL 
        SELECT 1708, 'Manager - Rolling Mill', 'MAB01442',1,2 UNION ALL 
        SELECT 1709, 'Manager - Security', 'MAB01400',1,2 UNION ALL 
        SELECT 1710, 'Manager - Sports Team - Full time', 'MAB01443',1,2 UNION ALL 
        SELECT 1711, 'Manager - Sports Team - Part time', 'MAB01444',1,2 UNION ALL 
        SELECT 1712, 'Manager - Stoneworking', 'MAB01401',1,2 UNION ALL 
        SELECT 1713, 'Manager - Usually ...', 'MAB01445',1,2 UNION ALL 
        SELECT 1714, 'Manager - Works - Food & Drink - General', 'MAB01446',1,2 UNION ALL 
        SELECT 1715, 'Manager - Works - Misc. Workers - Metal Manufacture', 'MAB01447',1,2 UNION ALL 
        SELECT 1716, 'Manager (including Box Office)', 'MAB01410',1,2 UNION ALL 
        SELECT 1717, 'Manager (including Sawmill)', 'MAB01411',1,2 UNION ALL 
        SELECT 1718, 'Manager (including Shipyard)', 'MAB01412',1,2 UNION ALL 
        SELECT 1719, 'Manager (including Works) - Adhesives Manufacture', 'MAB01421',1,2 UNION ALL 
        SELECT 1720, 'Manager (including Works) - Aircraft/Aerospace', 'MAB01423',1,2 UNION ALL 
        SELECT 1721, 'Manager (including Works) - Battery/Accumulator Manufacture', 'MAB01424',1,2 UNION ALL 
        SELECT 1722, 'Manager (including Works) - Chemical & Plastics Industry', 'MAB01425',1,2 UNION ALL 
        SELECT 1723, 'Manager (including Works) - Electronic Goods Manufacture', 'MAB01426',1,2 UNION ALL 
        SELECT 1724, 'Manager (including Works) - Explosives Manufacture', 'MAB01427',1,2 UNION ALL 
        SELECT 1725, 'Manager (including Works) - Glass/Glass Fibre Manufacture', 'MAB01428',1,2 UNION ALL 
        SELECT 1726, 'Manager (including Works) - Leather & Fur Industries', 'MAB01429',1,2 UNION ALL 
        SELECT 1727, 'Manager (including Works) - Minerals', 'MAB01430',1,2 UNION ALL 
        SELECT 1728, 'Manager (including Works) - Motor Vehicle & Cycle Industry', 'MAB01431',1,2 UNION ALL 
        SELECT 1729, 'Manager (including Works) - Musical Instrument Making & Repair', 'MAB01432',1,2 UNION ALL 
        SELECT 1730, 'Manager (including Works) - Oil Refining', 'MAB01433',1,2 UNION ALL 
        SELECT 1731, 'Manager (including Works) - Optical Goods Industry', 'MAB01434',1,2 UNION ALL 
        SELECT 1732, 'Manager (including Works) - Paper & Board Manufacture', 'MAB01435',1,2 UNION ALL 
        SELECT 1733, 'Manager (including Works) - Photographic Processing Industry', 'MAB01413',1,2 UNION ALL 
        SELECT 1734, 'Manager (including Works) - Plasterboard Making Industry', 'MAB01414',1,2 UNION ALL 
        SELECT 1735, 'Manager (including Works) - Pottery Industry', 'MAB01422',1,2 UNION ALL 
        SELECT 1736, 'Manager (including Works) - Precision Instrument Making & Repair', 'MAB01415',1,2 UNION ALL 
        SELECT 1737, 'Manager (including Works) - Rubber Industry - Natural', 'MAB01416',1,2 UNION ALL 
        SELECT 1738, 'Manager (including Works) - Textile & Clothing Industry', 'MAB01417',1,2 UNION ALL 
        SELECT 1739, 'Manager (including Works) - Tobacco Industry', 'MAB01418',1,2 UNION ALL 
        SELECT 1740, 'Manager (including Works) - Umbrella Making', 'MAB01419',1,2 UNION ALL 
        SELECT 1741, 'Manager (including Works) - Upholstery, Soft Furnishings, Mattress Making & Repair', 'MAB01420',1,2 UNION ALL 
        SELECT 1742, 'Manager (off site)', 'MAB01436',0,1 UNION ALL 
        SELECT 1743, 'Manager (salaried)', 'MAB01437',1,2 UNION ALL 
        SELECT 1744, 'Manager, construction contract - Building and construct ', 'MAC02884',1,2 UNION ALL 
        SELECT 1745, 'Manager/Owner', 'MAB01448',1,2 UNION ALL 
        SELECT 1746, 'Manhole Maker - Mining', 'MAB01450',1,2 UNION ALL 
        SELECT 1747, 'Manhole Maker - Tunnelling', 'MAB01449',1,2 UNION ALL 
        SELECT 1748, 'Manicurist', 'MAB01451',0,1 UNION ALL 
        SELECT 1749, 'Mannequin Model', 'MAB01452',1,2 UNION ALL 
        SELECT 1750, 'Marine Engineer', 'MAB01453',0,1 UNION ALL 
        SELECT 1751, 'Marine Installation Fitter', 'MAB01454',0,1 UNION ALL 
        SELECT 1752, 'Marine Superintendent', 'MAB01455',1,2 UNION ALL 
        SELECT 1753, 'Marine Surveyor', 'MAB01456',0,1 UNION ALL 
        SELECT 1754, 'Marker-out - Pipe, Sheet, Wire etc - Metal Manufacture', 'MAB01457',1,2 UNION ALL 
        SELECT 1755, 'Marker-out - Production Fitting - Metal Manufacture', 'MAB01458',1,2 UNION ALL 
        SELECT 1756, 'Market Gardener', 'MAB01459',0,1 UNION ALL 
        SELECT 1757, 'Market or Street Traders Assistant  ', 'MAC02885',0,1 UNION ALL 
        SELECT 1758, 'Market Porter - Usually', 'MAB01460',0,1 UNION ALL 
        SELECT 1759, 'Market Research Analyst', 'MAB01461',0,1 UNION ALL 
        SELECT 1760, 'Market Research Interviewer', 'MAB01462',0,1 UNION ALL 
        SELECT 1761, 'Market Researcher - Street research', 'MAC02887',0,1 UNION ALL 
        SELECT 1762, 'Market Researcher (office based) ', 'MAC02886',0,1 UNION ALL 
        SELECT 1763, 'Market Trader', 'MAB01463',1,2 UNION ALL 
        SELECT 1764, 'Marketing Consultant - International ', 'MAC02888',0,1 UNION ALL 
        SELECT 1765, 'Marketing Manager', 'MAC02889',0,1 UNION ALL 
        SELECT 1766, 'Marketing Research Manager (office based)    ', 'MAC02890',0,1 UNION ALL 
        SELECT 1767, 'Martial Arts Instructor', 'MAB01464',0,1 UNION ALL 
        SELECT 1768, 'Mason', 'MAB01465',0,1 UNION ALL 
        SELECT 1769, 'Mason Bricklayer', 'MAB01466',0,1 UNION ALL 
        SELECT 1770, 'Mason''s Labourer', 'MAB01467',0,1 UNION ALL 
        SELECT 1771, 'Masseur', 'MAB01468',0,1 UNION ALL 
        SELECT 1772, 'Masseuse', 'MAB01469',0,1 UNION ALL 
        SELECT 1773, 'Master', 'MAB01470',1,2 UNION ALL 
        SELECT 1774, 'Master Porter', 'MAB01471',1,2 UNION ALL 
        SELECT 1775, 'Mate - Electronic Goods Manufacture', 'MAB01472',1,2 UNION ALL 
        SELECT 1776, 'Mate - Fishing Industry', 'MAB01473',1,2 UNION ALL 
        SELECT 1777, 'Mate - Merchant Marine', 'MAB01474',1,2 UNION ALL 
        SELECT 1778, 'Mate (Goods Vehicle)', 'MAB01475',1,2 UNION ALL 
        SELECT 1779, 'Mate, Second Hand', 'MAB01476',0,1 UNION ALL 
        SELECT 1780, 'Materials Planner', 'MAB01477',1,2 UNION ALL 
        SELECT 1781, 'Mathematician   ', 'MAC02891',0,1 UNION ALL 
        SELECT 1782, 'Mattress Maker', 'MAB01478',0,1 UNION ALL 
        SELECT 1783, 'Measurer - Mining', 'MAB01479',1,2 UNION ALL 
        SELECT 1784, 'Measurer - Textile & Clothing Industry', 'MAB01480',1,2 UNION ALL 
        SELECT 1785, 'Measurer Coiler & Cutter', 'MAB01481',1,2 UNION ALL 
        SELECT 1786, 'Meat Cutter', 'MAB01482',0,1 UNION ALL 
        SELECT 1787, 'Meat Inspector', 'MAB01483',0,1 UNION ALL 
        SELECT 1788, 'Meat Trimmer', 'MAB01484',0,1 UNION ALL 
        SELECT 1789, 'Mechanic - Aircraft/Aerospace', 'MAB01485',1,2 UNION ALL 
        SELECT 1790, 'Mechanic - Fishing Industry', 'MAB01488',1,2 UNION ALL 
        SELECT 1791, 'Mechanic - Lifeboatman', 'MAB01486',1,2 UNION ALL 
        SELECT 1792, 'Mechanic - Merchant Marine', 'MAB01489',1,2 UNION ALL 
        SELECT 1793, 'Mechanic - Motor Vehicle & Cycle Industry', 'MAB01487',1,2 UNION ALL 
        SELECT 1794, 'Mechanic - Oil Rig Industry ', 'MAC02892',1,2 UNION ALL 
        SELECT 1795, 'Mechanic/Fitter', 'MAB01491',1,2 UNION ALL 
        SELECT 1796, 'Mechanical Engineer ', 'MAC02893',1,2 UNION ALL 
        SELECT 1797, 'Mechanical Engineer - Misc. Workers - Metal Manufacture', 'MAB01492',1,2 UNION ALL 
        SELECT 1798, 'Mechanical Engineer - office based  ', 'MAC02894',1,2 UNION ALL 
        SELECT 1799, 'Mechanical Engineer - Ship Building, Ship Repair & Marine Engineering', 'MAB01493',1,2 UNION ALL 
        SELECT 1800, 'Mechanical Road Sweeper Driver', 'MAB01494',1,2 UNION ALL 
        SELECT 1801, 'Mechanical Shovel Driver', 'MAB01495',1,2 UNION ALL 
        SELECT 1802, 'Mechanic''s Mate', 'MAB01490',1,2 UNION ALL 
        SELECT 1803, 'Medical Practitioner', 'MAB01496',0,1 UNION ALL 
        SELECT 1804, 'Medium', 'MAB01497',0,1 UNION ALL 
        SELECT 1805, 'Melter', 'MAB01498',1,2 UNION ALL 
        SELECT 1806, 'Member of Parliament, Politician', 'MAB01499',0,1 UNION ALL 
        SELECT 1807, 'Mender', 'MAB01500',1,2 UNION ALL 
        SELECT 1808, 'Merchandiser', 'MAB01501',1,2 UNION ALL 
        SELECT 1809, 'Merchant Marine ', 'MAC02895',1,2 UNION ALL 
        SELECT 1810, 'Messenger - Motorcycle  ', 'MAC02896',0,1 UNION ALL 
        SELECT 1811, 'Messenger - Not motorcycle  ', 'MAC02897',0,1 UNION ALL 
        SELECT 1812, 'Metal Designer (making metal objects)   ', 'MAC02898',1,2 UNION ALL 
        SELECT 1813, 'Metal Polisher  ', 'MAC02899',1,2 UNION ALL 
        SELECT 1814, 'Metal Working Production Fitter ', 'MAC02900',1,2 UNION ALL 
        SELECT 1815, 'Metallisation Plant Operator', 'MAB01502',1,2 UNION ALL 
        SELECT 1816, 'Metallographer', 'MAB01503',0,1 UNION ALL 
        SELECT 1817, 'Metallurgist', 'MAB01504',0,1 UNION ALL 
        SELECT 1818, 'Meteorologist', 'MAB01505',0,1 UNION ALL 
        SELECT 1819, 'Meter Collector - Electrical Supply', 'MAB01506',1,2 UNION ALL 
        SELECT 1820, 'Meter Collector - Gas Supply Industry', 'MAB01507',1,2 UNION ALL 
        SELECT 1821, 'Meter Fixer', 'MAB01508',1,2 UNION ALL 
        SELECT 1822, 'Meter Reader - Electrical Supply', 'MAB01509',1,2 UNION ALL 
        SELECT 1823, 'Meter Reader - Gas Supply Industry', 'MAB01510',1,2 UNION ALL 
        SELECT 1824, 'Meter Reader - Water Supply Industry', 'MAB01511',1,2 UNION ALL 
        SELECT 1825, 'Meter Tester - Electrical Supply', 'MAB01512',1,2 UNION ALL 
        SELECT 1826, 'Meter Tester - Water Supply Industry', 'MAB01513',1,2 UNION ALL 
        SELECT 1827, 'Meter/Coin Collector', 'MAB01514',1,2 UNION ALL 
        SELECT 1828, 'Microfilm Operator', 'MAB01515',0,1 UNION ALL 
        SELECT 1829, 'Midwife ', 'MAC02901',0,1 UNION ALL 
        SELECT 1830, 'Milk Roundsman', 'MAB01516',0,1 UNION ALL 
        SELECT 1831, 'Milker', 'MAB01517',0,1 UNION ALL 
        SELECT 1832, 'Miller - Flour Milling - Food & Drink', 'MAB01518',1,2 UNION ALL 
        SELECT 1833, 'Miller - Machining, Shaping etc - Metal Manufacture', 'MAB01519',1,2 UNION ALL 
        SELECT 1834, 'Miller - Stoneworking', 'MAB01520',1,2 UNION ALL 
        SELECT 1835, 'Millhand', 'MAB01521',1,2 UNION ALL 
        SELECT 1836, 'Milliner - Leather & Fur Industries', 'MAB01522',1,2 UNION ALL 
        SELECT 1837, 'Milliner - Textile & Clothing Industry', 'MAB01523',1,2 UNION ALL 
        SELECT 1838, 'Milling Worker', 'MAB01524',1,2 UNION ALL 
        SELECT 1839, 'Millman', 'MAB01525',1,2 UNION ALL 
        SELECT 1840, 'Millwright Maintenance Fitter', 'MAB01526',1,2 UNION ALL 
        SELECT 1841, 'Miner   ', 'MAC02902',0,1 UNION ALL 
        SELECT 1842, 'Mineralogist - Minerals', 'MAB01527',1,2 UNION ALL 
        SELECT 1843, 'Mineralogist - Mining', 'MAB01528',1,2 UNION ALL 
        SELECT 1844, 'Mini Cab Driver ', 'MAC02903',0,1 UNION ALL 
        SELECT 1845, 'Mining Engineer', 'MAB01529',0,1 UNION ALL 
        SELECT 1846, 'Mining Officer', 'MAB01530',0,1 UNION ALL 
        SELECT 1847, 'Mining Surveyor', 'MAB01531',0,1 UNION ALL 
        SELECT 1848, 'Minister of Religion    ', 'MAC02904',0,1 UNION ALL 
        SELECT 1849, 'Missionary', 'MAB01532',0,1 UNION ALL 
        SELECT 1850, 'Mixer - Bakeries - Food & Drink', 'MAB01534',1,2 UNION ALL 
        SELECT 1851, 'Mixer - Cork Goods Manufacture', 'MAB01533',1,2 UNION ALL 
        SELECT 1852, 'Mixer - Dairy Products - Food & Drink', 'MAB01535',1,2 UNION ALL 
        SELECT 1853, 'Mixer - Food & Drink - Other Processes', 'MAB01538',1,2 UNION ALL 
        SELECT 1854, 'Mixer - Fruit & Veg. - Food & Drink', 'MAB01536',1,2 UNION ALL 
        SELECT 1855, 'Mixer - Furnace - Metal Manufacture', 'MAB01541',1,2 UNION ALL 
        SELECT 1856, 'Mixer - Meat, Fish etc - Food & Drink', 'MAB01537',1,2 UNION ALL 
        SELECT 1857, 'Mixer - Soft Drinks - Food & Drink', 'MAB01539',1,2 UNION ALL 
        SELECT 1858, 'Mixer - Tea & Coffee - Food & Drink', 'MAB01540',1,2 UNION ALL 
        SELECT 1859, 'Mixing Worker', 'MAB01542',1,2 UNION ALL 
        SELECT 1860, 'Mobile Crane Driver - Docks', 'MAB01543',1,2 UNION ALL 
        SELECT 1861, 'Mobile Crane Driver - Film Industry - Entertainment', 'MAB01544',1,2 UNION ALL 
        SELECT 1862, 'Mobile Shop Driver', 'MAB01545',1,2 UNION ALL 
        SELECT 1863, 'Model Maker ', 'MAC02905',0,1 UNION ALL 
        SELECT 1864, 'Money Broker', 'MAB01546',0,1 UNION ALL 
        SELECT 1865, 'Monotype Operator', 'MAB01547',1,2 UNION ALL 
        SELECT 1866, 'Mortuary Attendant', 'MAB01548',0,1 UNION ALL 
        SELECT 1867, 'Mortuary Technician', 'MAB01549',1,2 UNION ALL 
        SELECT 1868, 'Motive Power Superintendent', 'MAB01550',1,2 UNION ALL 
        SELECT 1869, 'Motor Bike Instructor   ', 'MAC02906',0,1 UNION ALL 
        SELECT 1870, 'Motor Cycle Courier', 'MAB01551',0,2 UNION ALL 
        SELECT 1871, 'Motor Cycle Courier (Royal Mail)', 'MAB01552',1,2 UNION ALL 
        SELECT 1872, 'Motor Cycle Messenger', 'MAC02907',0,2 UNION ALL 
        SELECT 1873, 'Motor Cycle Sport', 'MAB01553',1,2 UNION ALL 
        SELECT 1874, 'Motor Fleet Manager ', 'MAC02908',0,1 UNION ALL 
        SELECT 1875, 'Motor Service Manager - admin only', 'MAC02909',0,2 UNION ALL 
        SELECT 1876, 'Motor Sport', 'MAB01554',1,2 UNION ALL 
        SELECT 1877, 'Motor Vehicle Mechanic  ', 'MAC02810',1,2 UNION ALL 
        SELECT 1878, 'Motorman - Oil & Natural Gas Industries (Exploration & Production)', 'MAB01555',1,2 UNION ALL 
        SELECT 1879, 'Motorman - Train Crew - Railways', 'MAB01556',1,2 UNION ALL 
        SELECT 1880, 'Mould Maker - Moulders, etc - Metal Manufacture', 'MAB01557',1,2 UNION ALL 
        SELECT 1881, 'Mould Maker - Rubber Industry - Natural', 'MAB01558',1,2 UNION ALL 
        SELECT 1882, 'Moulder - Moulders, etc - Metal Manufacture', 'MAB01559',1,2 UNION ALL 
        SELECT 1883, 'Moulder - Rubber Industry - Natural', 'MAB01560',1,2 UNION ALL 
        SELECT 1884, 'Mountaineering', 'MAB01561',1,2 UNION ALL 
        SELECT 1885, 'Movements Inspector', 'MAB01562',1,2 UNION ALL 
        SELECT 1886, 'Movements Supervisor', 'MAB01563',1,2 UNION ALL 
        SELECT 1887, 'Mud Engineer', 'MAB01564',0,1 UNION ALL 
        SELECT 1888, 'Mud Logger', 'MAB01565',0,1 UNION ALL 
        SELECT 1889, 'Mud Man', 'MAB01566',0,1 UNION ALL 
        SELECT 1890, 'Multishot Exploder Cleaner/Tester', 'MAB01567',1,2 UNION ALL 
        SELECT 1891, 'Museum Attendant', 'MAB01568',0,1 UNION ALL 
        SELECT 1892, 'Museum Curator', 'MAB01569',0,1 UNION ALL 
        SELECT 1893, 'Museum Guide', 'MAB01570',0,1 UNION ALL 
        SELECT 1894, 'Music Teacher (Private)', 'MAB01571',0,1 UNION ALL 
        SELECT 1895, 'Musical Director', 'MAB01572',1,2 UNION ALL 
        SELECT 1896, 'Musical Instrument Maker', 'MAB01573',0,1 UNION ALL 
        SELECT 1897, 'Musical Instrument Repairer', 'MAB01574',0,1 UNION ALL 
        SELECT 1898, 'Nanny   ', 'NAC01811',0,1 UNION ALL 
        SELECT 1899, 'Navigator', 'NAB01575',0,1 UNION ALL 
        SELECT 1900, 'Negative Assembler', 'NAB01576',1,2 UNION ALL 
        SELECT 1901, 'Negative Cutter', 'NAB01577',1,2 UNION ALL 
        SELECT 1902, 'News Photographer - no overseas travel etc', 'NAB01578',0,2 UNION ALL 
        SELECT 1903, 'News Photographer - otherwise', 'NAB01579',0,1 UNION ALL 
        SELECT 1904, 'Newsagent (not delivering papers)   ', 'NAC01812',0,1 UNION ALL 
        SELECT 1905, 'Newspaper Printer   ', 'NAC01813',1,2 UNION ALL 
        SELECT 1906, 'Newspaper Reporter - Freelance  ', 'NAC01814',0,1 UNION ALL 
        SELECT 1907, 'Newsreader', 'NAB01580',0,1 UNION ALL 
        SELECT 1908, 'Newsvendor', 'NAB01581',0,1 UNION ALL 
        SELECT 1909, 'Night Watchman - Building Site', 'NAB01582',1,2 UNION ALL 
        SELECT 1910, 'Night Watchman - Road Works', 'NAB01583',1,2 UNION ALL 
        SELECT 1911, 'Nitrider', 'NAB01584',1,2 UNION ALL 
        SELECT 1912, 'Normaliser', 'NAB01585',1,2 UNION ALL 
        SELECT 1913, 'Notary Public', 'NAB01586',1,2 UNION ALL 
        SELECT 1914, 'Nuclear Engineer', 'NAB01587',0,1 UNION ALL 
        SELECT 1915, 'Nuclear Engineering Technician', 'NAB01588',1,2 UNION ALL 
        SELECT 1916, 'Nuclear Plant Att. - contamination', 'NAB01589',1,2 UNION ALL 
        SELECT 1917, 'Nuclear Plant Att. - radiation', 'NAB01590',1,2 UNION ALL 
        SELECT 1918, 'Nuclear Scientist', 'NAB01591',0,1 UNION ALL 
        SELECT 1919, 'Nurse', 'NAB01592',0,1 UNION ALL 
        SELECT 1920, 'Nurse - Admin duties only   ', 'NAC01815',1,2 UNION ALL 
        SELECT 1921, 'Nurse - Admin duties only', 'NAB01594',1,2 UNION ALL 
        SELECT 1922, 'Nurse - Advisory duties only', 'NAB01595',1,2 UNION ALL 
        SELECT 1923, 'Nurse - Matron', 'NAB01596',1,2 UNION ALL 
        SELECT 1924, 'Nurse - Midwife', 'NAB01597',0,1 UNION ALL 
        SELECT 1925, 'Nurse - Teaching duties only', 'NAB01598',0,1 UNION ALL 
        SELECT 1926, 'Nurse (Registered)', 'NAB01593',1,2 UNION ALL 
        SELECT 1927, 'Nursery Assistant (hospital based)  ', 'NAC01816',1,2 UNION ALL 
        SELECT 1928, 'Nurseryman', 'NAB01599',0,1 UNION ALL 
        SELECT 1929, 'Nursing Auxiliary', 'NAB01600',0,1 UNION ALL 
        SELECT 1930, 'Nursing Home Proprietor (admin. only)   ', 'NAC01817',0,1 UNION ALL 
        SELECT 1931, 'Obstetrician    ', 'OAC01818',0,1 UNION ALL 
        SELECT 1932, 'Occupational Therapist', 'OAB01601',0,1 UNION ALL 
        SELECT 1933, 'Office Cashier', 'OAB01603',1,2 UNION ALL 
        SELECT 1934, 'Office Clerk', 'OAB01604',0,1 UNION ALL 
        SELECT 1935, 'Office Fitter', 'OAB01605',0,1 UNION ALL 
        SELECT 1936, 'Office Machinery Mechanic   ', 'OAC01819',1,2 UNION ALL 
        SELECT 1937, 'Office Manager  ', 'OAC01820',1,2 UNION ALL 
        SELECT 1938, 'Office Messenger', 'OAB01606',0,1 UNION ALL 
        SELECT 1939, 'Office Plant Mechanic   ', 'OAC01821',1,2 UNION ALL 
        SELECT 1940, 'Office Premises Electrician', 'OAB01607',1,2 UNION ALL 
        SELECT 1941, 'Office Receptionist', 'OAB01608',0,1 UNION ALL 
        SELECT 1942, 'Off-Licence Manager', 'OAB01602',0,1 UNION ALL 
        SELECT 1943, 'Oil Broker  ', 'OAC01822',1,2 UNION ALL 
        SELECT 1944, 'Oil Extractor', 'OAB01609',1,2 UNION ALL 
        SELECT 1945, 'Oiler', 'OAB01610',1,2 UNION ALL 
        SELECT 1946, 'Oiler & Greaser (Ind. Machinery)', 'OAB01611',1,2 UNION ALL 
        SELECT 1947, 'Old People''s Home Matron', 'OAB01612',0,1 UNION ALL 
        SELECT 1948, 'Old People''s Home Warden', 'OAB01613',0,1 UNION ALL 
        SELECT 1949, 'Onsetter (Cageman)', 'OAB01614',1,2 UNION ALL 
        SELECT 1950, 'Opera Singer', 'OAB01615',1,2 UNION ALL 
        SELECT 1951, 'Operations Manager - Light engineering company', 'OAC08123',0,2 UNION ALL 
        SELECT 1952, 'Operations Officer', 'OAB01616',0,1 UNION ALL 
        SELECT 1953, 'Operators Representative - Oil Rig Industry ', 'OAC01824',1,2 UNION ALL 
        SELECT 1954, 'Operators Toolpusher - Oil Rig Industry ', 'OAC01825',1,2 UNION ALL 
        SELECT 1955, 'Optical Instrument Fitter', 'OAB01617',0,1 UNION ALL 
        SELECT 1956, 'Optical Instrument Maker', 'OAB01618',0,1 UNION ALL 
        SELECT 1957, 'Optical Instrument Mechanic', 'OAB01619',0,1 UNION ALL 
        SELECT 1958, 'Optical Instrument Repairer', 'OAB01620',0,1 UNION ALL 
        SELECT 1959, 'Optical Printer', 'OAB01621',0,1 UNION ALL 
        SELECT 1960, 'Optician', 'OAB01622',0,1 UNION ALL 
        SELECT 1961, 'Opticians Assistant ', 'OAC01826',0,1 UNION ALL 
        SELECT 1962, 'Orchard Worker', 'OAB01623',1,2 UNION ALL 
        SELECT 1963, 'Orchestra Musician', 'OAB01624',1,2 UNION ALL 
        SELECT 1964, 'Orchestrator', 'OAB01625',0,1 UNION ALL 
        SELECT 1965, 'Organisation & Methods Officer', 'OAB01626',1,2 UNION ALL 
        SELECT 1966, 'Ornamental Metal Worker', 'OAB01627',1,2 UNION ALL 
        SELECT 1967, 'Orthodontic Technician', 'OAB01628',0,1 UNION ALL 
        SELECT 1968, 'Orthodontist', 'OAB01629',0,1 UNION ALL 
        SELECT 1969, 'Orthopaedic Surgeon ', 'OAC01827',0,1 UNION ALL 
        SELECT 1970, 'Orthoptist', 'OAB01630',0,1 UNION ALL 
        SELECT 1971, 'Osteopath', 'OAB01631',0,1 UNION ALL 
        SELECT 1972, 'Other - Nil Abnormally Hazardous', 'OAB01632',1,2 UNION ALL 
        SELECT 1973, 'Other Underground Workers', 'OAB01633',1,2 UNION ALL 
        SELECT 1974, 'Oven Feeder/Taker-off', 'OAB01634',1,2 UNION ALL 
        SELECT 1975, 'Ovensman - Bakeries - Food & Drink', 'OAB01635',1,2 UNION ALL 
        SELECT 1976, 'Ovensman - Fruit & Veg. - Food & Drink', 'OAB01636',1,2 UNION ALL 
        SELECT 1977, 'Overhead Crane Driver', 'OAB01637',0,1 UNION ALL 
        SELECT 1978, 'Overhead Linesman', 'OAB01638',0,1 UNION ALL 
        SELECT 1979, 'Overhead Linesman''s Mate', 'OAB01639',0,1 UNION ALL 
        SELECT 1980, 'Owner - Circus - Entertainment', 'OAB01640',1,2 UNION ALL 
        SELECT 1981, 'Owner - Garage Trade', 'OAB01641',1,2 UNION ALL 
        SELECT 1982, 'Owner - Travel Agency', 'OAB01642',1,2 UNION ALL 
        SELECT 1983, 'Oyster Fisherman', 'OAB01643',0,1 UNION ALL 
        SELECT 1984, 'Packaging Machine Attendant', 'PAB01644',0,1 UNION ALL 
        SELECT 1985, 'Packer - Asbestos', 'PAB01645',1,2 UNION ALL 
        SELECT 1986, 'Packer - Chemical & Plastics Industry', 'PAB01646',1,2 UNION ALL 
        SELECT 1987, 'Packer - Explosives Manufacture', 'PAB01647',1,2 UNION ALL 
        SELECT 1988, 'Packer - Food & Drink - General', 'PAB01649',1,2 UNION ALL 
        SELECT 1989, 'Packer - Fruit & Veg. - Food & Drink', 'PAB01648',1,2 UNION ALL 
        SELECT 1990, 'Packer - Glass/Glass Fibre Manufacture', 'PAB01652',1,2 UNION ALL 
        SELECT 1991, 'Packer - Laundry', 'PAB01653',1,2 UNION ALL 
        SELECT 1992, 'Packer - Leather & Fur Industries', 'PAB01654',1,2 UNION ALL 
        SELECT 1993, 'Packer - Meat, Fish etc - Food & Drink', 'PAB01650',1,2 UNION ALL 
        SELECT 1994, 'Packer - Mining', 'PAB01661',1,2 UNION ALL 
        SELECT 1995, 'Packer - Pottery Industry', 'PAB01655',1,2 UNION ALL 
        SELECT 1996, 'Packer - Precision Instrument Making & Repair', 'PAB01656',1,2 UNION ALL 
        SELECT 1997, 'Packer - Sugar Production - Food & Drink', 'PAB01651',1,2 UNION ALL 
        SELECT 1998, 'Packer - Textile & Clothing Industry', 'PAB01657',1,2 UNION ALL 
        SELECT 1999, 'Packer - Tobacco Industry', 'PAB01658',1,2 UNION ALL 
        SELECT 2000, 'Packer - Upholstery, Soft Furnishings, Mattress Making & Repair', 'PAB01659',1,2 UNION ALL 
        SELECT 2001, 'Packer - Woodworking Industry', 'PAB01660',1,2 UNION ALL 
        SELECT 2002, 'Packer (eg car engines)', 'PAB01662',1,2 UNION ALL 
        SELECT 2003, 'Page Boy - Hotel', 'PAB01663',1,2 UNION ALL 
        SELECT 2004, 'Painter ', 'PAC01828',0,1 UNION ALL 
        SELECT 2005, 'Painter - Oil Rig Industry  ', 'PAC01829',1,2 UNION ALL 
        SELECT 2006, 'Painter - Ship Building, Ship Repair & Marine Engineering', 'PAB01664',1,2 UNION ALL 
        SELECT 2007, 'Painter - Woodworking Industry', 'PAB01665',0,1 UNION ALL 
        SELECT 2008, 'Painter & Decorator (Interior)', 'PAB01666',0,1 UNION ALL 
        SELECT 2009, 'Painter (Coach/Spray)', 'PAB01667',1,2 UNION ALL 
        SELECT 2010, 'Painter (Exterior) - 40'' up', 'PAB01668',0,1 UNION ALL 
        SELECT 2011, 'Painter (Exterior) - up to 40''', 'PAB01669',0,1 UNION ALL 
        SELECT 2012, 'Painting Plant Operator', 'PAB01670',1,2 UNION ALL 
        SELECT 2013, 'Panel Beater - Garage Trade', 'PAB01671',1,2 UNION ALL 
        SELECT 2014, 'Panel Beater - Pipe, Sheet, Wire etc - Metal Manufacture', 'PAB01672',1,2 UNION ALL 
        SELECT 2015, 'Paper & Board Manufacturing Worker  ', 'PAC01830',1,2 UNION ALL 
        SELECT 2016, 'Paper Maker (hand)', 'PAB01673',0,1 UNION ALL 
        SELECT 2017, 'Paper Merchant', 'PAB01674',0,1 UNION ALL 
        SELECT 2018, 'Paper Technologist', 'PAB01675',1,2 UNION ALL 
        SELECT 2019, 'Paramedic (Driver)', 'PAB01676',0,1 UNION ALL 
        SELECT 2020, 'Paramedic (No driving)', 'PAB01677',0,1 UNION ALL 
        SELECT 2021, 'Park Keeper', 'PAB01678',0,1 UNION ALL 
        SELECT 2022, 'Park Ranger', 'PAB01679',0,1 UNION ALL 
        SELECT 2023, 'Parks Superintendent', 'PAB01680',0,1 UNION ALL 
        SELECT 2024, 'Parliamentary Agent', 'PAB01681',0,1 UNION ALL 
        SELECT 2025, 'Part Time Worker (under 20 hrs per week)    ', 'PAC01831',1,2 UNION ALL 
        SELECT 2026, 'Party Organiser ', 'PAC01832',0,1 UNION ALL 
        SELECT 2027, 'Passenger Officer', 'PAB01682',0,1 UNION ALL 
        SELECT 2028, 'Passengers', 'PAB01683',1,2 UNION ALL 
        SELECT 2029, 'Paste Maker', 'PAB01684',1,2 UNION ALL 
        SELECT 2030, 'Pasteuriser', 'PAB01685',0,1 UNION ALL 
        SELECT 2031, 'Pasteurising Tank Attendant', 'PAB01686',1,2 UNION ALL 
        SELECT 2032, 'Patent Agent', 'PAB01687',0,1 UNION ALL 
        SELECT 2033, 'Pathologist', 'PAB01688',0,1 UNION ALL 
        SELECT 2034, 'Patrol Man (AA/RAC) ', 'PAC01833',1,2 UNION ALL 
        SELECT 2035, 'Patrolman (security purposes)', 'PAB01689',1,2 UNION ALL 
        SELECT 2036, 'Pattern Card Cutter', 'PAB01690',1,2 UNION ALL 
        SELECT 2037, 'Pattern Maker - Metal, Plastic etc', 'PAB01691',0,1 UNION ALL 
        SELECT 2038, 'Pavior', 'PAB01692',0,1 UNION ALL 
        SELECT 2039, 'Pawnbroker  ', 'PAC01834',0,1 UNION ALL 
        SELECT 2040, 'Pebble Pusher - Oil Rig Industry    ', 'PAC01835',1,2 UNION ALL 
        SELECT 2041, 'Pedicurist', 'PAB01693',0,1 UNION ALL 
        SELECT 2042, 'Peeler (hand)', 'PAB01694',1,2 UNION ALL 
        SELECT 2043, 'Pension Legal Officer (office based) ', 'PAC01836',1,2 UNION ALL 
        SELECT 2044, 'Pensions Manager    ', 'PAC01837',1,2 UNION ALL 
        SELECT 2045, 'Perfumery Consultant (site based)   ', 'PAC01838',1,2 UNION ALL 
        SELECT 2046, 'Periodontist', 'PAB01695',1,2 UNION ALL 
        SELECT 2047, 'Personal Assistant - Property company    ', 'PAC01839',1,2 UNION ALL 
        SELECT 2048, 'Personnel Consultant    ', 'PAC01840',1,2 UNION ALL 
        SELECT 2049, 'Personnel Officer   ', 'PAC01841',1,2 UNION ALL 
        SELECT 2050, 'Pest Control Manager', 'PAB01696',0,1 UNION ALL 
        SELECT 2051, 'Pest Control Operator', 'PAB01697',0,1 UNION ALL 
        SELECT 2052, 'Pest Control Surveyor', 'PAB01698',1,2 UNION ALL 
        SELECT 2053, 'Pest Controller ', 'PAC01842',1,2 UNION ALL 
        SELECT 2054, 'Petrol Pump Attendant   ', 'PAC01843',1,2 UNION ALL 
        SELECT 2055, 'Petrol Pump Attendant', 'PAB01699',0,1 UNION ALL 
        SELECT 2056, 'Pharmaceutical Officer', 'PAB01700',1,2 UNION ALL 
        SELECT 2057, 'Pharmacist', 'PAB01701',0,1 UNION ALL 
        SELECT 2058, 'Pharmacologist', 'PAB01702',0,1 UNION ALL 
        SELECT 2059, 'Pharmacy Assistant', 'PAB01703',0,1 UNION ALL 
        SELECT 2060, 'Phlebotomist    ', 'PAC01844',0,1 UNION ALL 
        SELECT 2061, 'Photocopying Machine Operator', 'PAB01704',0,1 UNION ALL 
        SELECT 2062, 'Photographer    ', 'PAC01845',0,1 UNION ALL 
        SELECT 2063, 'Photographer - Aerial   ', 'PAC01846',0,1 UNION ALL 
        SELECT 2064, 'Photographer - Portrait ', 'PAC01847',1,2 UNION ALL 
        SELECT 2065, 'Photographic Finisher', 'PAB01705',0,1 UNION ALL 
        SELECT 2066, 'Photographic Model', 'PAB01706',0,1 UNION ALL 
        SELECT 2067, 'Photographic Mounter', 'PAB01707',0,1 UNION ALL 
        SELECT 2068, 'Physician', 'PAB01708',0,1 UNION ALL 
        SELECT 2069, 'Physicist', 'PAB01709',0,1 UNION ALL 
        SELECT 2070, 'Physiotherapist', 'PAB01710',0,1 UNION ALL 
        SELECT 2071, 'Piano/Organ Tuner', 'PAB01711',0,1 UNION ALL 
        SELECT 2072, 'Pickler', 'PAB01712',0,1 UNION ALL 
        SELECT 2073, 'Picture Framer  ', 'PAC01848',0,1 UNION ALL 
        SELECT 2074, 'Pier Master', 'PAB01713',0,1 UNION ALL 
        SELECT 2075, 'Pile Driver', 'PAB01714',0,1 UNION ALL 
        SELECT 2076, 'Pilot', 'PAB01715',0,1 UNION ALL 
        SELECT 2077, 'Pilot Superintendent', 'PAB01716',1,2 UNION ALL 
        SELECT 2078, 'Pipe Fitter - Construction Industry', 'PAB01717',1,2 UNION ALL 
        SELECT 2079, 'Pipe Fitter - Gas Supply Industry', 'PAB01718',1,2 UNION ALL 
        SELECT 2080, 'Pipe Fitter - Oil & Natural Gas Industries (Exploration & Production)', 'PAB01720',1,2 UNION ALL 
        SELECT 2081, 'Pipe Fitter - Pipe, Sheet, Wire etc - Metal Manufacture', 'PAB01719',1,2 UNION ALL 
        SELECT 2082, 'Pipe Fitter - Ship Building, Ship Repair & Marine Engineering', 'PAB01721',1,2 UNION ALL 
        SELECT 2083, 'Pipe Fitter - Water Supply Industry', 'PAB01722',1,2 UNION ALL 
        SELECT 2084, 'Pipe Jointer - Construction Industry', 'PAB01723',1,2 UNION ALL 
        SELECT 2085, 'Pipe Jointer - Water Supply Industry', 'PAB01724',1,2 UNION ALL 
        SELECT 2086, 'Pipe Layer - Construction Industry', 'PAB01725',1,2 UNION ALL 
        SELECT 2087, 'Pipe Layer - Gas Supply Industry', 'PAB01726',1,2 UNION ALL 
        SELECT 2088, 'Pipe Layer - Water Supply Industry', 'PAB01727',1,2 UNION ALL 
        SELECT 2089, 'Pipe Laying Diver', 'PAB01728',1,2 UNION ALL 
        SELECT 2090, 'Pipe/Powerline Survey Work', 'PAB01729',0,1 UNION ALL 
        SELECT 2091, 'Piper (Chocolate, Confectionery)', 'PAB01730',1,2 UNION ALL 
        SELECT 2092, 'Pitch Melter', 'PAB01731',0,1 UNION ALL 
        SELECT 2093, 'Planning Engineer - Construction Industry', 'PAB01732',1,2 UNION ALL 
        SELECT 2094, 'Planning Engineer - Misc. Workers - Metal Manufacture', 'PAB01733',1,2 UNION ALL 
        SELECT 2095, 'Planning Engineer - Ship Building, Ship Repair & Marine Engineering', 'PAB01734',1,2 UNION ALL 
        SELECT 2096, 'Planning Inspector', 'PAB01735',0,1 UNION ALL 
        SELECT 2097, 'Plant Attendant', 'PAB01736',0,1 UNION ALL 
        SELECT 2098, 'Plant Electrician', 'PAB01737',1,2 UNION ALL 
        SELECT 2099, 'Plant Hire Manager (some manual work)   ', 'PAC01849',0,1 UNION ALL 
        SELECT 2100, 'Plant Hire Owner (some manual work) ', 'PAC01850',0,1 UNION ALL 
        SELECT 2101, 'Plant Hire Proprietor (admin. only) ', 'PAC01851',0,1 UNION ALL 
        SELECT 2102, 'Plant Operator - Chemical & Plastics Industry', 'PAB01738',1,2 UNION ALL 
        SELECT 2103, 'Plant Operator - Explosives Manufacture', 'PAB01739',1,2 UNION ALL 
        SELECT 2104, 'Plant Operator - Glass/Glass Fibre Manufacture', 'PAB01740',1,2 UNION ALL 
        SELECT 2105, 'Plant Operator - Minerals', 'PAB01742',1,2 UNION ALL 
        SELECT 2106, 'Plant Operator - Oil Refining', 'PAB01743',1,2 UNION ALL 
        SELECT 2107, 'Plant Operator - Other Processing, Forming etc - Metal Manufacture', 'PAB01741',1,2 UNION ALL 
        SELECT 2108, 'Plant Operator - Pottery Industry', 'PAB01744',1,2 UNION ALL 
        SELECT 2109, 'Plant Operator - Water Supply Industry', 'PAB01745',1,2 UNION ALL 
        SELECT 2110, 'Plaster Cast Process Operator', 'PAB01746',1,2 UNION ALL 
        SELECT 2111, 'Plasterer', 'PAB01747',0,1 UNION ALL 
        SELECT 2112, 'Plastic Coating Operator', 'PAB01748',0,1 UNION ALL 
        SELECT 2113, 'Plastic Spectacle Frame Maker', 'PAB01749',1,2 UNION ALL 
        SELECT 2114, 'Plastic Spectacle Frame Repairer', 'PAB01750',1,2 UNION ALL 
        SELECT 2115, 'Plastics Technologist', 'PAB01751',1,2 UNION ALL 
        SELECT 2116, 'Plate Cutter', 'PAB01752',0,1 UNION ALL 
        SELECT 2117, 'Plate Moulder', 'PAB01753',0,1 UNION ALL 
        SELECT 2118, 'Plate Separator', 'PAB01754',0,1 UNION ALL 
        SELECT 2119, 'Platelayer', 'PAB01755',0,1 UNION ALL 
        SELECT 2120, 'Plateman', 'PAB01756',0,1 UNION ALL 
        SELECT 2121, 'Plater - Aircraft/Aerospace', 'PAB01757',0,1 UNION ALL 
        SELECT 2122, 'Plater - Motor Vehicle & Cycle Industry', 'PAB01758',0,1 UNION ALL 
        SELECT 2123, 'Plater - Ship Building, Ship Repair & Marine Engineering', 'PAB01759',0,1 UNION ALL 
        SELECT 2124, 'Plater (including Boiler)', 'PAB01760',0,1 UNION ALL 
        SELECT 2125, 'Playwright', 'PAB01761',0,1 UNION ALL 
        SELECT 2126, 'Plumber - Construction/Industrial', 'PAB01762',0,2 UNION ALL 
        SELECT 2127, 'Plumber - Domestic  ', 'PAC01852',0,1 UNION ALL 
        SELECT 2128, 'Plumber - Ship Building, Ship Repair & Marine Engineering', 'PAB01763',1,2 UNION ALL 
        SELECT 2129, 'Plumber - Water Supply Industry', 'PAB01764',1,2 UNION ALL 
        SELECT 2130, 'Pneumatic Drill Operator', 'PAB01765',0,1 UNION ALL 
        SELECT 2131, 'Poet', 'PAB01766',0,1 UNION ALL 
        SELECT 2132, 'Pointsman', 'PAB01767',0,1 UNION ALL 
        SELECT 2133, 'Police', 'PAB01768',0,1 UNION ALL 
        SELECT 2134, 'Police - Full or part-time RUC', 'PAB01769',1,2 UNION ALL 
        SELECT 2135, 'Police - Inspectors & above', 'PAB01770',1,2 UNION ALL 
        SELECT 2136, 'Police Constables - clerical', 'PAB01771',1,2 UNION ALL 
        SELECT 2137, 'Police Constables - other', 'PAB01772',1,2 UNION ALL 
        SELECT 2138, 'Police Frogman', 'PAB01773',0,1 UNION ALL 
        SELECT 2139, 'Police Sergeants - clerical', 'PAB01774',1,2 UNION ALL 
        SELECT 2140, 'Police Sergeants - other', 'PAB01775',1,2 UNION ALL 
        SELECT 2141, 'Polisher', 'PAB01776',1,2 UNION ALL 
        SELECT 2142, 'Pollution Inspector', 'PAB01777',0,1 UNION ALL 
        SELECT 2143, 'Polo', 'PAB01778',1,2 UNION ALL 
        SELECT 2144, 'Pool', 'PAB01779',1,2 UNION ALL 
        SELECT 2145, 'Pop Musician', 'PAB01780',0,1 UNION ALL 
        SELECT 2146, 'Pop Singer', 'PAB01781',0,1 UNION ALL 
        SELECT 2147, 'Port Control Signalman', 'PAB01782',0,1 UNION ALL 
        SELECT 2148, 'Port Health Inspector', 'PAB01783',0,1 UNION ALL 
        SELECT 2149, 'Portainer Crane Driver', 'PAB01784',1,2 UNION ALL 
        SELECT 2150, 'Porter - Meat, Fish etc - Food & Drink', 'PAB01785',0,1 UNION ALL 
        SELECT 2151, 'Porter - Station Personnel - Railways', 'PAB01786',0,1 UNION ALL 
        SELECT 2152, 'Portrait Painter', 'PAB01787',0,1 UNION ALL 
        SELECT 2153, 'Portrait Photographer', 'PAB01788',0,1 UNION ALL 
        SELECT 2154, 'Postal Courier Driver   ', 'PAC01853',0,1 UNION ALL 
        SELECT 2155, 'Postal Courier Manager ', 'PAC01854',0,1 UNION ALL 
        SELECT 2156, 'Postman (no driving)', 'PAB01789',0,1 UNION ALL 
        SELECT 2157, 'Postman', 'PAB01790',0,2 UNION ALL 
        SELECT 2158, 'Postmaster - Main Post Office    ', 'PAC01855',1,2 UNION ALL 
        SELECT 2159, 'Postmaster - Sub office/shop assistant ', 'PAC01856',1,2 UNION ALL 
        SELECT 2160, 'Pot Fisherman', 'PAB01791',0,1 UNION ALL 
        SELECT 2161, 'Potman', 'PAB01792',0,1 UNION ALL 
        SELECT 2162, 'Potter', 'PAB01793',0,1 UNION ALL 
        SELECT 2163, 'Poultry Dresser', 'PAB01794',0,1 UNION ALL 
        SELECT 2164, 'Poultry Plucker', 'PAB01795',0,1 UNION ALL 
        SELECT 2165, 'Poultry Sticker', 'PAB01796',1,2 UNION ALL 
        SELECT 2166, 'Poultryman', 'PAB01797',0,1 UNION ALL 
        SELECT 2167, 'Power Loader Man', 'PAB01798',0,1 UNION ALL 
        SELECT 2168, 'Power Loader Operator', 'PAB01799',0,1 UNION ALL 
        SELECT 2169, 'Power Station Charge Engineer', 'PAB01800',0,1 UNION ALL 
        SELECT 2170, 'Power Station Manager', 'PAB01801',0,1 UNION ALL 
        SELECT 2171, 'Power Station Superintendent', 'PAB01802',0,1 UNION ALL 
        SELECT 2172, 'Power Stower', 'PAB01803',1,2 UNION ALL 
        SELECT 2173, 'Powerboat Racing', 'PAB01804',1,2 UNION ALL 
        SELECT 2174, 'Powered Supports Maintenance', 'PAB01805',1,2 UNION ALL 
        SELECT 2175, 'PR Executive    ', 'PAC01857',0,1 UNION ALL 
        SELECT 2176, 'Practice Manager    ', 'PAC01858',0,1 UNION ALL 
        SELECT 2177, 'Precious Stone Worker   ', 'PAC01859',1,2 UNION ALL 
        SELECT 2178, 'Precision Instrument Fitter', 'PAB01806',0,1 UNION ALL 
        SELECT 2179, 'Precision Instrument Maker', 'PAB01807',0,1 UNION ALL 
        SELECT 2180, 'Precision Instrument Repairer', 'PAB01808',0,1 UNION ALL 
        SELECT 2181, 'Preparer', 'PAB01809',0,1 UNION ALL 
        SELECT 2182, 'Press Cutter', 'PAB01810',0,1 UNION ALL 
        SELECT 2183, 'Press Officer', 'PAB01811',0,1 UNION ALL 
        SELECT 2184, 'Press Operator - Machining, Shaping etc - Metal Manufacture', 'PAB01812',1,2 UNION ALL 
        SELECT 2185, 'Press Operator - Other Processing, Forming etc - Metal Manufacture', 'PAB01813',1,2 UNION ALL 
        SELECT 2186, 'Press Tool Setter', 'PAB01814',0,1 UNION ALL 
        SELECT 2187, 'Presser - Dry Cleaning', 'PAB01815',1,2 UNION ALL 
        SELECT 2188, 'Presser - Flour Milling - Food & Drink', 'PAB01816',1,2 UNION ALL 
        SELECT 2189, 'Presser - Fruit & Veg. - Food & Drink', 'PAB01817',0,1 UNION ALL 
        SELECT 2190, 'Presser - Laundry', 'PAB01818',0,1 UNION ALL 
        SELECT 2191, 'Priest', 'PAB01819',0,1 UNION ALL 
        SELECT 2192, 'Principal Officer', 'PAB01820',1,2 UNION ALL 
        SELECT 2193, 'Printer', 'PAB01821',0,2 UNION ALL 
        SELECT 2194, 'Printer''s Assistant', 'PAB01822',1,2 UNION ALL 
        SELECT 2195, 'Printing - Textiles', 'PAB01823',1,2 UNION ALL 
        SELECT 2196, 'Printing Director (purely admin.)   ', 'PAC01860',0,1 UNION ALL 
        SELECT 2197, 'Printing Pressman', 'PAB01824',1,2 UNION ALL 
        SELECT 2198, 'Printing Proprietor ', 'PAC01861',1,2 UNION ALL 
        SELECT 2199, 'Printing Technologist', 'PAB01825',1,2 UNION ALL 
        SELECT 2200, 'Prison Officer', 'PAB01826',0,1 UNION ALL 
        SELECT 2201, 'Prison Officer (not in Northern Ireland) - Senior Officer and above ', 'PAC01862',1,2 UNION ALL 
        SELECT 2202, 'Private Detective', 'PAB01827',0,1 UNION ALL 
        SELECT 2203, 'Private Gardener', 'PAB01828',1,2 UNION ALL 
        SELECT 2204, 'Private Nurse', 'PAB01829',1,2 UNION ALL 
        SELECT 2205, 'Private Pilots', 'PAB01830',1,2 UNION ALL 
        SELECT 2206, 'Probation Officer', 'PAB01831',0,1 UNION ALL 
        SELECT 2207, 'Process Camera Operator', 'PAB01832',1,2 UNION ALL 
        SELECT 2208, 'Process Engraver', 'PAB01833',1,2 UNION ALL 
        SELECT 2209, 'Process Worker - Adhesives Manufacture', 'PAB01835',1,2 UNION ALL 
        SELECT 2210, 'Process Worker - Aircraft/Aerospace', 'PAB01834',1,2 UNION ALL 
        SELECT 2211, 'Process Worker - Asbestos', 'PAB01836',1,2 UNION ALL 
        SELECT 2212, 'Process Worker - Battery/Accumulator Manufacture', 'PAB01837',1,2 UNION ALL 
        SELECT 2213, 'Process Worker - Beer, Wine etc - Food & Drink', 'PAB01844',1,2 UNION ALL 
        SELECT 2214, 'Process Worker - Brick, Pipe & Tile Manufacture', 'PAB01838',1,2 UNION ALL 
        SELECT 2215, 'Process Worker - Cement Works', 'PAB01839',1,2 UNION ALL 
        SELECT 2216, 'Process Worker - Chemical & Plastics Industry', 'PAB01840',1,2 UNION ALL 
        SELECT 2217, 'Process Worker - Clothing', 'PAB01863',1,2 UNION ALL 
        SELECT 2218, 'Process Worker - Confectionery etc - Food & Drink', 'PAB01845',1,2 UNION ALL 
        SELECT 2219, 'Process Worker - Cork Goods Manufacture', 'PAB01841',1,2 UNION ALL 
        SELECT 2220, 'Process Worker - Electrical Supply', 'PAB01842',1,2 UNION ALL 
        SELECT 2221, 'Process Worker - Explosives Manufacture', 'PAB01843',1,2 UNION ALL 
        SELECT 2222, 'Process Worker - Flour Milling - Food & Drink', 'PAB01846',1,2 UNION ALL 
        SELECT 2223, 'Process Worker - Food & Drink - General', 'PAB01848',1,2 UNION ALL 
        SELECT 2224, 'Process Worker - Fruit & Veg. - Food & Drink', 'PAB01847',1,2 UNION ALL 
        SELECT 2225, 'Process Worker - Furnace - Metal Manufacture', 'PAB01853',1,2 UNION ALL 
        SELECT 2226, 'Process Worker - Glass/Glass Fibre Manufacture', 'PAB01851',1,2 UNION ALL 
        SELECT 2227, 'Process Worker - Leather & Fur Industries', 'PAB01852',1,2 UNION ALL 
        SELECT 2228, 'Process Worker - Meat, Fish etc - Food & Drink', 'PAB01849',1,2 UNION ALL 
        SELECT 2229, 'Process Worker - Minerals', 'PAB01855',1,2 UNION ALL 
        SELECT 2230, 'Process Worker - Optical Goods Industry', 'PAB01856',1,2 UNION ALL 
        SELECT 2231, 'Process Worker - Paper & Board Manufacture', 'PAB01857',1,2 UNION ALL 
        SELECT 2232, 'Process Worker - Plasterboard Making Industry', 'PAB01858',1,2 UNION ALL 
        SELECT 2233, 'Process Worker - Pottery Industry', 'PAB01859',1,2 UNION ALL 
        SELECT 2234, 'Process Worker - Rolling, Extruding etc - Metal Manufacture', 'PAB01854',1,2 UNION ALL 
        SELECT 2235, 'Process Worker - Rubber Industry - Natural', 'PAB01860',1,2 UNION ALL 
        SELECT 2236, 'Process Worker - Sugar Production - Food & Drink', 'PAB01850',1,2 UNION ALL 
        SELECT 2237, 'Process Worker - Textiles', 'PAB01864',1,2 UNION ALL 
        SELECT 2238, 'Process Worker - Tobacco Industry', 'PAB01861',1,2 UNION ALL 
        SELECT 2239, 'Process Worker - Upholstery, Soft Furnishings, Mattress Making & Repair', 'PAB01862',1,2 UNION ALL 
        SELECT 2240, 'Producer', 'PAB01865',1,2 UNION ALL 
        SELECT 2241, 'Product Controller of Tourism   ', 'PAC01863',1,2 UNION ALL 
        SELECT 2242, 'Production Engineer - Misc. Workers - Metal Manufacture', 'PAB01866',1,2 UNION ALL 
        SELECT 2243, 'Production Engineer - Ship Building, Ship Repair & Marine Engineering', 'PAB01867',1,2 UNION ALL 
        SELECT 2244, 'Production Fitter - Electrical Industry ', 'PAC01864',1,2 UNION ALL 
        SELECT 2245, 'Production Manager', 'PAB01868',0,1 UNION ALL 
        SELECT 2246, 'Production Superintendent - Adhesives Manufacture', 'PAB01870',1,2 UNION ALL 
        SELECT 2247, 'Production Superintendent - Aircraft/Aerospace', 'PAB01869',1,2 UNION ALL 
        SELECT 2248, 'Production Superintendent - Battery/Accumulator Manufacture', 'PAB01871',1,2 UNION ALL 
        SELECT 2249, 'Production Superintendent - Brick, Pipe & Tile Manufacture', 'PAB01872',1,2 UNION ALL 
        SELECT 2250, 'Production Superintendent - Cement Works', 'PAB01873',1,2 UNION ALL 
        SELECT 2251, 'Production Superintendent - Chemical & Plastics Industry', 'PAB01874',1,2 UNION ALL 
        SELECT 2252, 'Production Superintendent - Electronic Goods Manufacture', 'PAB01875',1,2 UNION ALL 
        SELECT 2253, 'Production Superintendent - Explosives Manufacture', 'PAB01876',1,2 UNION ALL 
        SELECT 2254, 'Production Superintendent - Food & Drink - General', 'PAB01877',1,2 UNION ALL 
        SELECT 2255, 'Production Superintendent - Glass/Glass Fibre Manufacture', 'PAB01878',1,2 UNION ALL 
        SELECT 2256, 'Production Superintendent - Leather & Fur Industries', 'PAB01879',1,2 UNION ALL 
        SELECT 2257, 'Production Superintendent - Minerals', 'PAB01881',1,2 UNION ALL 
        SELECT 2258, 'Production Superintendent - Misc. Workers - Metal Manufacture', 'PAB01880',1,2 UNION ALL 
        SELECT 2259, 'Production Superintendent - Motor Vehicle & Cycle Industry', 'PAB01882',1,2 UNION ALL 
        SELECT 2260, 'Production Superintendent - Musical Instrument Making & Repair', 'PAB01883',1,2 UNION ALL 
        SELECT 2261, 'Production Superintendent - Oil Refining', 'PAB01884',1,2 UNION ALL 
        SELECT 2262, 'Production Superintendent - Optical Goods Industry', 'PAB01885',1,2 UNION ALL 
        SELECT 2263, 'Production Superintendent - Paper & Board Manufacture', 'PAB01886',1,2 UNION ALL 
        SELECT 2264, 'Production Superintendent - Photographic Processing Industry', 'PAB01887',1,2 UNION ALL 
        SELECT 2265, 'Production Superintendent - Plasterboard Making Industry', 'PAB01888',1,2 UNION ALL 
        SELECT 2266, 'Production Superintendent - Pottery Industry', 'PAB01889',1,2 UNION ALL 
        SELECT 2267, 'Production Superintendent - Printing Industry', 'PAB01890',1,2 UNION ALL 
        SELECT 2268, 'Production Superintendent - Rubber Industry - Natural', 'PAB01891',1,2 UNION ALL 
        SELECT 2269, 'Production Superintendent - Ship Building, Ship Repair & Marine Engineering', 'PAB01892',1,2 UNION ALL 
        SELECT 2270, 'Production Superintendent - Stoneworking', 'PAB01893',1,2 UNION ALL 
        SELECT 2271, 'Production Superintendent - Textile & Clothing Industry', 'PAB01894',1,2 UNION ALL 
        SELECT 2272, 'Production Superintendent - Tobacco Industry', 'PAB01895',1,2 UNION ALL 
        SELECT 2273, 'Production Superintendent - Upholstery, Soft Furnishings, Mattress Making & Repair', 'PAB01896',1,2 UNION ALL 
        SELECT 2274, 'Production Superintendent - Woodworking Industry', 'PAB01897',1,2 UNION ALL 
        SELECT 2275, 'Professional Sportsperson   ', 'PAC01865',0,1 UNION ALL 
        SELECT 2276, 'Programme Operation Assistant', 'PAB01898',1,2 UNION ALL 
        SELECT 2277, 'Project Co-ordinator    ', 'PAC01866',0,1 UNION ALL 
        SELECT 2278, 'Projectionist', 'PAB01899',0,1 UNION ALL 
        SELECT 2279, 'Prompter', 'PAB01900',0,1 UNION ALL 
        SELECT 2280, 'Proofer', 'PAB01901',0,1 UNION ALL 
        SELECT 2281, 'Property & Estate Manager   ', 'PAC01867',0,1 UNION ALL 
        SELECT 2282, 'Property Developer  ', 'PAC01868',1,2 UNION ALL 
        SELECT 2283, 'Property Investment Company Director    ', 'PAC01869',1,2 UNION ALL 
        SELECT 2284, 'Property Manager', 'PAB01902',0,2 UNION ALL 
        SELECT 2285, 'Property Master - Circus - Entertainment', 'PAB01903',1,2 UNION ALL 
        SELECT 2286, 'Property Master - Film Industry - Entertainment', 'PAB01904',1,2 UNION ALL 
        SELECT 2287, 'Proprietor', 'PAB01905',0,1 UNION ALL 
        SELECT 2288, 'Psychiatrist', 'PAB01906',0,1 UNION ALL 
        SELECT 2289, 'Psychologist', 'PAB01907',0,1 UNION ALL 
        SELECT 2290, 'Psychotherapist ', 'PAC01870',0,1 UNION ALL 
        SELECT 2291, 'Public Gardener', 'PAB01908',1,2 UNION ALL 
        SELECT 2292, 'Public Hall Bookings Office Manager ', 'PAC01871',0,1 UNION ALL 
        SELECT 2293, 'Public Health Inspector', 'PAB01909',0,1 UNION ALL 
        SELECT 2294, 'Public House Manager (salaried)', 'PAB01910',0,1 UNION ALL 
        SELECT 2295, 'Public Lighting Fitter-Erector', 'PAB01911',0,1 UNION ALL 
        SELECT 2296, 'Public Premises Cleaner', 'PAB01912',1,2 UNION ALL 
        SELECT 2297, 'Public Relations Officer', 'PAB01913',0,1 UNION ALL 
        SELECT 2298, 'Public Transport Depot Cleaner', 'PAB01914',1,2 UNION ALL 
        SELECT 2299, 'Publican', 'PAB01915',0,1 UNION ALL 
        SELECT 2300, 'Publisher', 'PAB01916',0,1 UNION ALL 
        SELECT 2301, 'Pumpman - Gas Supply Industry', 'PAB01917',1,2 UNION ALL 
        SELECT 2302, 'Pumpman - Merchant Marine', 'PAB01920',1,2 UNION ALL 
        SELECT 2303, 'Pumpman - Oil & Natural Gas Industries (Exploration & Production)', 'PAB01918',1,2 UNION ALL 
        SELECT 2304, 'Pumpman - Quarrying', 'PAB01919',1,2 UNION ALL 
        SELECT 2305, 'Punched Card Operator', 'PAB01921',1,2 UNION ALL 
        SELECT 2306, 'Punched Tape Operator', 'PAB01922',1,2 UNION ALL 
        SELECT 2307, 'Puppeteer', 'PAB01923',0,1 UNION ALL 
        SELECT 2308, 'Purchasing Officer/Manager (not retail)   ', 'PAC01872',0,1 UNION ALL 
        SELECT 2309, 'Purifier Man', 'PAB01924',0,1 UNION ALL 
        SELECT 2310, 'Purser', 'PAB01925',0,1 UNION ALL 
        SELECT 2311, 'Purserette', 'PAB01926',1,2 UNION ALL 
        SELECT 2312, 'Pusherman', 'PAB01927',0,1 UNION ALL 
        SELECT 2313, 'Quality Control Engineer - Textile & Clothing Industry', 'QAB01928',1,2 UNION ALL 
        SELECT 2314, 'Quality Control Engineer - Tobacco Industry', 'QAB01929',1,2 UNION ALL 
        SELECT 2315, 'Quality Control Supervisor  ', 'QAC01873',1,2 UNION ALL 
        SELECT 2316, 'Quantity Surveyor', 'QAB01930',0,1 UNION ALL 
        SELECT 2317, 'Quarry Manager', 'QAB01931',0,1 UNION ALL 
        SELECT 2318, 'Quarrying Engineer - Usually', 'QAB01932',1,2 UNION ALL 
        SELECT 2319, 'Quarryman   ', 'QAC01874',0,1 UNION ALL 
        SELECT 2320, 'Quartermaster', 'QAB01933',0,1 UNION ALL 
        SELECT 2321, 'Queen''s Counsel', 'QAB01934',0,1 UNION ALL 
        SELECT 2322, 'Rabbi', 'RAB01935',0,1 UNION ALL 
        SELECT 2323, 'Radar Controller/Operator', 'RAB01936',0,2 UNION ALL 
        SELECT 2324, 'Radar Observer', 'RAB01937',0,1 UNION ALL 
        SELECT 2325, 'Radio & Television Repairman', 'RAB01938',1,2 UNION ALL 
        SELECT 2326, 'Radio Officer - Fishing Industry', 'RAB01939',1,2 UNION ALL 
        SELECT 2327, 'Radio Officer - Merchant Marine', 'RAB01940',1,2 UNION ALL 
        SELECT 2328, 'Radio Operator', 'RAB01941',1,2 UNION ALL 
        SELECT 2329, 'Radio Operator - Oil Rig Industry   ', 'RAC01878',1,2 UNION ALL 
        SELECT 2330, 'Radio Station Manager', 'RAB01942',0,1 UNION ALL 
        SELECT 2331, 'Radio/Radar Operator', 'RAB01943',0,1 UNION ALL 
        SELECT 2332, 'Radio/Radio Telephone Operator', 'RAB01944',1,2 UNION ALL 
        SELECT 2333, 'Radio/TV Announcer/Presenter    ', 'RAC01875',0,1 UNION ALL 
        SELECT 2334, 'Radio/TV Director/Producer  ', 'RAC01876',0,1 UNION ALL 
        SELECT 2335, 'Radio and TV Repairer', 'RAC01877',0,2 UNION ALL 
        SELECT 2336, 'Radiographer - Health', 'RAB01947',0,1 UNION ALL 
        SELECT 2337, 'Radiographer - Oil & Natural Gas Industries (Exploration & Production)', 'RAB01945',1,2 UNION ALL 
        SELECT 2338, 'Radiographer - Ship Building, Ship Repair & Marine Engineering', 'RAB01946',1,2 UNION ALL 
        SELECT 2339, 'Radiologist', 'RAB01948',0,1 UNION ALL 
        SELECT 2340, 'RAF - Trainee Pilots, Navigators', 'RAB01949',1,2 UNION ALL 
        SELECT 2341, 'Rag & Bone Dealer', 'RAB01950',0,1 UNION ALL 
        SELECT 2342, 'Rail Tanker Filler', 'RAB01951',1,2 UNION ALL 
        SELECT 2343, 'Railman', 'RAB01952',1,2 UNION ALL 
        SELECT 2344, 'Railway Signal Fitter', 'RAB01953',1,2 UNION ALL 
        SELECT 2345, 'Railway Station-man ', 'RAC01879',1,2 UNION ALL 
        SELECT 2346, 'Railway Wagon Fitter', 'RAB01954',1,2 UNION ALL 
        SELECT 2347, 'Raker', 'RAB01955',1,2 UNION ALL 
        SELECT 2348, 'Raw Materials Sampler', 'RAB01956',1,2 UNION ALL 
        SELECT 2349, 'Reader', 'RAB01957',1,2 UNION ALL 
        SELECT 2350, 'Receiver    ', 'RAC01880',1,2 UNION ALL 
        SELECT 2351, 'Reception Mechanic', 'RAB01958',1,2 UNION ALL 
        SELECT 2352, 'Receptionist', 'RAB01959',0,1 UNION ALL 
        SELECT 2353, 'Record Producer - Entertainment Industry    ', 'RAC01881',0,1 UNION ALL 
        SELECT 2354, 'Recording Engineer', 'RAB01960',0,1 UNION ALL 
        SELECT 2355, 'Rector', 'RAB01961',0,1 UNION ALL 
        SELECT 2356, 'Red Leader', 'RAB01962',1,2 UNION ALL 
        SELECT 2357, 'Reflexologist', 'RAB01963',0,1 UNION ALL 
        SELECT 2358, 'Refuse Collector    ', 'RAC01882',0,1 UNION ALL 
        SELECT 2359, 'Registrar', 'RAB01964',0,1 UNION ALL 
        SELECT 2360, 'Reinsurance Broker  ', 'RAC01883',0,1 UNION ALL 
        SELECT 2361, 'Remedial Gymnast', 'RAB01965',1,2 UNION ALL 
        SELECT 2362, 'Rennet Process Worker', 'RAB01966',1,2 UNION ALL 
        SELECT 2363, 'Rent Collector', 'RAB01967',0,1 UNION ALL 
        SELECT 2364, 'Rent Officer', 'RAB01968',1,2 UNION ALL 
        SELECT 2365, 'Repair Electrician', 'RAB01969',1,2 UNION ALL 
        SELECT 2366, 'Repairer', 'RAB01970',1,2 UNION ALL 
        SELECT 2367, 'Repetitive Assembler - Metal & Electrical Goods ', 'RAC01884',1,2 UNION ALL 
        SELECT 2368, 'Reporter - no travel etc', 'RAB01971',1,2 UNION ALL 
        SELECT 2369, 'Reporter - otherwise', 'RAB01972',1,2 UNION ALL 
        SELECT 2370, 'Reporter/Writer - no overseas travel etc', 'RAB01973',0,2 UNION ALL 
        SELECT 2371, 'Reporter/Writer - otherwise', 'RAB01974',0,1 UNION ALL 
        SELECT 2372, 'Rescue Diver', 'RAB01975',0,1 UNION ALL 
        SELECT 2373, 'Research Chemist (Managerial)   ', 'RAC01885',0,1 UNION ALL 
        SELECT 2374, 'Research Information Officer (Office based) ', 'RAC01886',0,1 UNION ALL 
        SELECT 2375, 'Research Projects Manager (Deals with hazardous substances) ', 'RAC01887',0,1 UNION ALL 
        SELECT 2376, 'Research Survey Clerk', 'RAB01976',0,1 UNION ALL 
        SELECT 2377, 'Researcher - Journalism', 'RAB01978',0,1 UNION ALL 
        SELECT 2378, 'Researcher - Radio & TV - Entertainment', 'RAB01977',0,1 UNION ALL 
        SELECT 2379, 'Reservations Clerk', 'RAB01979',0,1 UNION ALL 
        SELECT 2380, 'Reservoir Attendant', 'RAB01980',0,1 UNION ALL 
        SELECT 2381, 'Residential Care Worker', 'RAC01888',0,2 UNION ALL 
        SELECT 2382, 'Residential Club Manager    ', 'RAC01889',1,2 UNION ALL 
        SELECT 2383, 'Residential Home Proprietor (Admin. only)   ', 'RAC01890',0,1 UNION ALL 
        SELECT 2384, 'Residential Home Proprietor (full involvement in caring)    ', 'RAC01891',0,1 UNION ALL 
        SELECT 2385, 'Restaurant Manager (salaried)', 'RAB01981',1,2 UNION ALL 
        SELECT 2386, 'Restaurant Proprietor - no cooking', 'RAC01892',0,2 UNION ALL 
        SELECT 2387, 'Restauranteur   ', 'RAC01893',1,2 UNION ALL 
        SELECT 2388, 'Restaurateur', 'RAB01982',1,2 UNION ALL 
        SELECT 2389, 'Restorer (Paintings)', 'RAB01983',0,1 UNION ALL 
        SELECT 2390, 'Restorer (Stone, Brickwork)', 'RAB01984',0,1 UNION ALL 
        SELECT 2391, 'Retail Shop Manager ', 'RAC01894',0,1 UNION ALL 
        SELECT 2392, 'Retail Shop Manager - admin only', 'RAC01895',0,2 UNION ALL 
        SELECT 2393, 'Retired ', 'RAC01896',0,1 UNION ALL 
        SELECT 2394, 'Riding Instructor   ', 'RAC01897',0,1 UNION ALL 
        SELECT 2395, 'Rig Electrician', 'RAB01985',0,1 UNION ALL 
        SELECT 2396, 'Rig Maintenance Diver', 'RAB01986',0,1 UNION ALL 
        SELECT 2397, 'Rig Mechanic', 'RAB01987',0,1 UNION ALL 
        SELECT 2398, 'Rig Medic', 'RAB01988',0,1 UNION ALL 
        SELECT 2399, 'Rigger - Docks', 'RAB01989',0,1 UNION ALL 
        SELECT 2400, 'Rigger - Film Industry - Entertainment', 'RAB01990',0,1 UNION ALL 
        SELECT 2401, 'Rigger - Gas Supply Industry', 'RAB01991',0,1 UNION ALL 
        SELECT 2402, 'Rigger - Industrial/Plant Machinery', 'RAB01994',0,1 UNION ALL 
        SELECT 2403, 'Rigger - Oil & Natural Gas Industries', 'RAB01992',0,2 UNION ALL 
        SELECT 2404, 'Rigger - Ship Building, Ship Repair & Marine Engineering', 'RAB01993',0,1 UNION ALL 
        SELECT 2405, 'Rigmaster   ', 'RAC01898',1,2 UNION ALL 
        SELECT 2406, 'Rigmaster - Oil Rig Industry    ', 'RAC01899',1,2 UNION ALL 
        SELECT 2407, 'Ripper', 'RAB01995',0,1 UNION ALL 
        SELECT 2408, 'River Inspector', 'RAB01996',0,1 UNION ALL 
        SELECT 2409, 'Rivet Catcher - Pipe, Sheet, Wire etc - Metal Manufacture', 'RAB01998',1,2 UNION ALL 
        SELECT 2410, 'Rivet Catcher - Ship Building, Ship Repair & Marine Engineering', 'RAB01997',1,2 UNION ALL 
        SELECT 2411, 'Rivet Heater - Pipe, Sheet, Wire etc - Metal Manufacture', 'RAB01999',1,2 UNION ALL 
        SELECT 2412, 'Rivet Heater - Ship Building, Ship Repair & Marine Engineering', 'RAB02000',1,2 UNION ALL 
        SELECT 2413, 'Riveter - Aircraft/Aerospace', 'RAB02001',1,2 UNION ALL 
        SELECT 2414, 'Riveter - Construction Industry', 'RAB02002',1,2 UNION ALL 
        SELECT 2415, 'Riveter - Motor Vehicle & Cycle Industry', 'RAB02004',1,2 UNION ALL 
        SELECT 2416, 'Riveter - Pipe, Sheet, Wire etc - Metal Manufacture', 'RAB02003',1,2 UNION ALL 
        SELECT 2417, 'Riveter - Ship Building, Ship Repair & Marine Engineering', 'RAB02005',1,2 UNION ALL 
        SELECT 2418, 'Riveter - Toy Goods Manufacture', 'RAB02006',1,2 UNION ALL 
        SELECT 2419, 'Riveting Machine Operator', 'RAB02007',1,2 UNION ALL 
        SELECT 2420, 'Road Crew Member - ''Roadie''', 'RAB02008',0,1 UNION ALL 
        SELECT 2421, 'Road Lengthsman', 'RAB02009',1,2 UNION ALL 
        SELECT 2422, 'Road Manager - Rock band    ', 'RAC01900',0,1 UNION ALL 
        SELECT 2423, 'Road Marker', 'RAB02010',0,1 UNION ALL 
        SELECT 2424, 'Road Patrolman (AA, RAC)', 'RAB02011',1,2 UNION ALL 
        SELECT 2425, 'Road Rolling Driver', 'RAB02012',1,2 UNION ALL 
        SELECT 2426, 'Road Safety Officer', 'RAB02013',0,1 UNION ALL 
        SELECT 2427, 'Road Section Man', 'RAB02014',1,2 UNION ALL 
        SELECT 2428, 'Road Surfacer   ', 'RAC01901',1,2 UNION ALL 
        SELECT 2429, 'Road Sweeper - Mechanical   ', 'RAC01902',0,1 UNION ALL 
        SELECT 2430, 'Road Sweeper (hand)', 'RAB02015',0,1 UNION ALL 
        SELECT 2431, 'Road Tester - Garage Trade', 'RAB02016',0,1 UNION ALL 
        SELECT 2432, 'Road Tester - Motor Vehicle & Cycle Industry', 'RAB02017',0,1 UNION ALL 
        SELECT 2433, 'Roadman', 'RAB02018',1,2 UNION ALL 
        SELECT 2434, 'Roaster', 'RAB02019',0,1 UNION ALL 
        SELECT 2435, 'Rodent Destroyer', 'RAB02020',0,1 UNION ALL 
        SELECT 2436, 'Roller', 'RAB02021',1,2 UNION ALL 
        SELECT 2437, 'Roller Blind Maker', 'RAB02022',0,1 UNION ALL 
        SELECT 2438, 'Rollerman - Flour Milling - Food & Drink', 'RAB02023',1,2 UNION ALL 
        SELECT 2439, 'Rollerman - Food & Drink - Other Processes', 'RAB02025',1,2 UNION ALL 
        SELECT 2440, 'Rollerman - Fruit & Veg. - Food & Drink', 'RAB02024',1,2 UNION ALL 
        SELECT 2441, 'Rollerman - Mining', 'RAB02028',1,2 UNION ALL 
        SELECT 2442, 'Rollerman - Soft Drinks - Food & Drink', 'RAB02026',1,2 UNION ALL 
        SELECT 2443, 'Rollerman - Tea & Coffee - Food & Drink', 'RAB02027',1,2 UNION ALL 
        SELECT 2444, 'Rolling Mill Assistant', 'RAB02029',1,2 UNION ALL 
        SELECT 2445, 'Roof Bolter', 'RAB02030',1,2 UNION ALL 
        SELECT 2446, 'Roofbolter', 'RAB02031',1,2 UNION ALL 
        SELECT 2447, 'Roofer - 40'' up', 'RAB02032',0,1 UNION ALL 
        SELECT 2448, 'Roofer - up to 40''', 'RAB02033',0,1 UNION ALL 
        SELECT 2449, 'Roofing Inspector (Mostly office based - some estimating)   ', 'RAC01903',0,1 UNION ALL 
        SELECT 2450, 'Rope Changer/Runner', 'RAB02034',1,2 UNION ALL 
        SELECT 2451, 'Rope Maker', 'RAB02035',0,1 UNION ALL 
        SELECT 2452, 'Ropeman', 'RAB02036',1,2 UNION ALL 
        SELECT 2453, 'Roughneck', 'RAB02037',0,1 UNION ALL 
        SELECT 2454, 'Roundsman   ', 'RAC01904',1,2 UNION ALL 
        SELECT 2455, 'Rouser', 'RAB02038',1,2 UNION ALL 
        SELECT 2456, 'Roustabout', 'RAB02039',0,1 UNION ALL 
        SELECT 2457, 'Roustabout Pusher - Oil Rig Industry    ', 'RAC01905',0,1 UNION ALL 
        SELECT 2458, 'Royal Air Force', 'RAB02040',1,2 UNION ALL 
        SELECT 2459, 'Royal Navy - Fleet Air Arm', 'RAB02041',1,2 UNION ALL 
        SELECT 2460, 'Royal Navy Divers', 'RAB02042',1,2 UNION ALL 
        SELECT 2461, 'RSPCA Inspector', 'RAB02043',0,1 UNION ALL 
        SELECT 2462, 'Rubber & Plastics Worker    ', 'RAC01906',0,1 UNION ALL 
        SELECT 2463, 'Rubber Technologist', 'RAB02044',0,1 UNION ALL 
        SELECT 2464, 'Rugby League', 'RAB02045',1,2 UNION ALL 
        SELECT 2465, 'Rugby Union', 'RAB02046',1,2 UNION ALL 
        SELECT 2466, 'Saddler', 'SAB02047',0,1 UNION ALL 
        SELECT 2467, 'Safety Officer', 'SAB02048',0,1 UNION ALL 
        SELECT 2468, 'Safety Officer - Oil Rig Industry   ', 'SAC01907',0,1 UNION ALL 
        SELECT 2469, 'Sales & Marketing Manager', 'SAC01908',0,1 UNION ALL 
        SELECT 2470, 'Sales Representative', 'SAB02049',1,3 UNION ALL 
        SELECT 2471, 'Sales Representative (shop or office based)', 'SAC01909',1,3 UNION ALL 
        SELECT 2472, 'Salter', 'SAB02050',0,1 UNION ALL 
        SELECT 2473, 'Salvage Diver', 'SAB02051',0,1 UNION ALL 
        SELECT 2474, 'Salvage Man', 'SAB02052',0,1 UNION ALL 
        SELECT 2475, 'Sandblaster - Brick, Pipe & Tile Manufacture', 'SAB02053',1,2 UNION ALL 
        SELECT 2476, 'Sandblaster - Machining, Shaping etc - Metal Manufacture', 'SAB02054',1,2 UNION ALL 
        SELECT 2477, 'Sandblaster - Pottery Industry', 'SAB02055',1,2 UNION ALL 
        SELECT 2478, 'Satellite Aerial Fixer (domestic only)  ', 'SAC01910',0,1 UNION ALL 
        SELECT 2479, 'Saturation Tank Attendant', 'SAB02056',0,1 UNION ALL 
        SELECT 2480, 'Saw Doctor', 'SAB02057',1,2 UNION ALL 
        SELECT 2481, 'Saw Maker', 'SAB02058',1,2 UNION ALL 
        SELECT 2482, 'Saw Piercer', 'SAB02059',1,2 UNION ALL 
        SELECT 2483, 'Saw Repairer & Sharpener', 'SAB02060',1,2 UNION ALL 
        SELECT 2484, 'Saw Smith', 'SAB02061',1,2 UNION ALL 
        SELECT 2485, 'Sawyer - Meat, Fish etc - Food & Drink', 'SAB02062',1,2 UNION ALL 
        SELECT 2486, 'Sawyer - Woodworking Industry', 'SAB02063',1,2 UNION ALL 
        SELECT 2487, 'Scaffold - Oil Rig Industry   ', 'SAC01911',1,2 UNION ALL 
        SELECT 2488, 'Scaffolder', 'SAB02064',0,1 UNION ALL 
        SELECT 2489, 'Scaffolder - 40'' up', 'SAB02065',1,2 UNION ALL 
        SELECT 2490, 'Scaffolder - up to 40''', 'SAB02066',1,2 UNION ALL 
        SELECT 2491, 'Scaffolder''s Labourer', 'SAB02067',1,2 UNION ALL 
        SELECT 2492, 'Scene Shifter', 'SAB02068',0,1 UNION ALL 
        SELECT 2493, 'Scenery Painter', 'SAB02069',0,1 UNION ALL 
        SELECT 2494, 'School Bursar   ', 'SAC01912',0,1 UNION ALL 
        SELECT 2495, 'School Inspector    ', 'SAC01913',0,1 UNION ALL 
        SELECT 2496, 'School Janitor  ', 'SAC01914',1,2 UNION ALL 
        SELECT 2497, 'School Maid', 'SAB02070',1,2 UNION ALL 
        SELECT 2498, 'School Nurse    ', 'SAC01915',1,2 UNION ALL 
        SELECT 2499, 'School Secretary    ', 'SAC01916',1,2 UNION ALL 
        SELECT 2500, 'School Teacher (Full Time)', 'SAB02071',1,2 UNION ALL 
        SELECT 2501, 'Schools Inspector', 'SAB02072',1,2 UNION ALL 
        SELECT 2502, 'Scrap Baler', 'SAB02073',1,2 UNION ALL 
        SELECT 2503, 'Scrap Breaker', 'SAB02074',0,1 UNION ALL 
        SELECT 2504, 'Scrap Cutter', 'SAB02075',1,2 UNION ALL 
        SELECT 2505, 'Scrap Dealer', 'SAB02076',0,1 UNION ALL 
        SELECT 2506, 'Scraper Driver', 'SAB02077',1,2 UNION ALL 
        SELECT 2507, 'Screen Glazier', 'SAB02078',1,2 UNION ALL 
        SELECT 2508, 'Screen Printer', 'SAB02079',0,1 UNION ALL 
        SELECT 2509, 'Screener - Cement Works', 'SAB02080',1,2 UNION ALL 
        SELECT 2510, 'Screener - Quarrying', 'SAB02081',0,1 UNION ALL 
        SELECT 2511, 'Screenmaker', 'SAB02082',0,1 UNION ALL 
        SELECT 2512, 'Screensman Conditioner', 'SAB02083',1,2 UNION ALL 
        SELECT 2513, 'Screwman', 'SAB02084',0,1 UNION ALL 
        SELECT 2514, 'Script Writer', 'SAB02085',0,1 UNION ALL 
        SELECT 2515, 'Sculleryman', 'SAB02086',1,2 UNION ALL 
        SELECT 2516, 'Sculptor', 'SAB02087',0,1 UNION ALL 
        SELECT 2517, 'Seaman', 'SAB02088',0,1 UNION ALL 
        SELECT 2518, 'Second Man - Driller', 'SAB02089',1,2 UNION ALL 
        SELECT 2519, 'Secondman', 'SAB02090',1,2 UNION ALL 
        SELECT 2520, 'Secretary (Blue collar industries)', 'SAB02091',1,2 UNION ALL 
        SELECT 2521, 'Secretary (White collar industries)', 'SAB02092',1,2 UNION ALL 
        SELECT 2522, 'Security Guard', 'SAB02093',0,2 UNION ALL 
        SELECT 2523, 'Security Officer (Premises)', 'SAB02094',1,2 UNION ALL 
        SELECT 2524, 'Seed Tank Man', 'SAB02095',1,2 UNION ALL 
        SELECT 2525, 'Seismologist', 'SAB02096',0,1 UNION ALL 
        SELECT 2526, 'Seismologist (land based)', 'SAB02097',1,2 UNION ALL 
        SELECT 2527, 'Senior Nurse    ', 'SAC01917',1,2 UNION ALL 
        SELECT 2528, 'Senior Officer - Fire Service', 'SAB02098',1,2 UNION ALL 
        SELECT 2529, 'Senior Officer - Salvage Corps', 'SAB02099',1,2 UNION ALL 
        SELECT 2530, 'Senior Railman', 'SAB02100',1,2 UNION ALL 
        SELECT 2531, 'Senior Theatre Executive    ', 'SAC01918',1,2 UNION ALL 
        SELECT 2532, 'Service Aviation', 'SAB02101',1,2 UNION ALL 
        SELECT 2533, 'Service Electrician', 'SAB02102',1,2 UNION ALL 
        SELECT 2534, 'Services Diving', 'SAB02103',1,2 UNION ALL 
        SELECT 2535, 'Set Designer - Radio & TV - Entertainment', 'SAB02104',1,2 UNION ALL 
        SELECT 2536, 'Set Designer - Theatre, Ballet etc - Entertainment', 'SAB02105',1,2 UNION ALL 
        SELECT 2537, 'Sewage Works Attendant', 'SAB02106',0,1 UNION ALL 
        SELECT 2538, 'Sewage Works Manager', 'SAB02107',0,1 UNION ALL 
        SELECT 2539, 'Sewerman', 'SAB02108',0,1 UNION ALL 
        SELECT 2540, 'Sewing Machine Mechanic ', 'SAC01919',0,1 UNION ALL 
        SELECT 2541, 'Sewing Machinist - Leather & Fur Industries', 'SAB02109',1,2 UNION ALL 
        SELECT 2542, 'Sewing Machinist - Textile & Clothing Industry', 'SAB02110',1,2 UNION ALL 
        SELECT 2543, 'Sewing Machinist - Upholstery, Soft Furnishings, Mattress Making & Repair', 'SAB02111',1,2 UNION ALL 
        SELECT 2544, 'Shackler', 'SAB02112',1,2 UNION ALL 
        SELECT 2545, 'Shaftsman', 'SAB02113',0,1 UNION ALL 
        SELECT 2546, 'Sheep Shearer', 'SAB02114',0,1 UNION ALL 
        SELECT 2547, 'Sheet Fixer', 'SAB02115',0,2 UNION ALL 
        SELECT 2548, 'Sheet Metal Worker - Aircraft/Aerospace', 'SAB02116',1,2 UNION ALL 
        SELECT 2549, 'Sheet Metal Worker - Motor Vehicle & Cycle Industry', 'SAB02118',1,2 UNION ALL 
        SELECT 2550, 'Sheet Metal Worker - Pipe, Sheet, Wire etc - Metal Manufacture', 'SAB02117',1,2 UNION ALL 
        SELECT 2551, 'Shelf Filler    ', 'SAC01920',0,1 UNION ALL 
        SELECT 2552, 'Shepherd', 'SAB02119',0,1 UNION ALL 
        SELECT 2553, 'Sheriff Officer''s Clerk', 'SAB02120',1,2 UNION ALL 
        SELECT 2554, 'Shipping Clerk', 'SAB02123',0,1 UNION ALL 
        SELECT 2555, 'Ships Agent', 'SAB02124',1,2 UNION ALL 
        SELECT 2556, 'Ship''s Broker', 'SAB02121',0,1 UNION ALL 
        SELECT 2557, 'Ship''s Engineer', 'SAB02122',1,2 UNION ALL 
        SELECT 2558, 'Shipwright - Metal', 'SAB02125',1,2 UNION ALL 
        SELECT 2559, 'Shipwright - Wood', 'SAB02126',1,2 UNION ALL 
        SELECT 2560, 'Shoe Maker', 'SAB02127',0,1 UNION ALL 
        SELECT 2561, 'Shoe Repairer', 'SAB02128',0,1 UNION ALL 
        SELECT 2562, 'Shop Assistant', 'SAB02129',0,1 UNION ALL 
        SELECT 2563, 'Shop Cashier', 'SAB02130',1,2 UNION ALL 
        SELECT 2564, 'Shop Clerk', 'SAB02131',1,2 UNION ALL 
        SELECT 2565, 'Shop Doorman', 'SAB02132',1,2 UNION ALL 
        SELECT 2566, 'Shop Fitter', 'SAB02133',0,1 UNION ALL 
        SELECT 2567, 'Shop Porter - Usually', 'SAB02134',1,2 UNION ALL 
        SELECT 2568, 'Shop Receptionist', 'SAB02135',1,2 UNION ALL 
        SELECT 2569, 'Shop Salesman', 'SAB02136',1,2 UNION ALL 
        SELECT 2570, 'Shopkeeper', 'SAB02137',1,2 UNION ALL 
        SELECT 2571, 'Shore-based personnel', 'SAB02138',1,2 UNION ALL 
        SELECT 2572, 'Shorthand Writer    ', 'SAC01921',1,2 UNION ALL 
        SELECT 2573, 'Shotblaster - Machining, Shaping etc - Metal Manufacture', 'SAB02139',1,2 UNION ALL 
        SELECT 2574, 'Shotblaster - Ship Building, Ship Repair & Marine Engineering', 'SAB02140',1,2 UNION ALL 
        SELECT 2575, 'Shotfirer - Construction Industry', 'SAB02141',1,2 UNION ALL 
        SELECT 2576, 'Shotfirer - Mining', 'SAB02144',1,2 UNION ALL 
        SELECT 2577, 'Shotfirer - Quarrying', 'SAB02142',1,2 UNION ALL 
        SELECT 2578, 'Shotfirer - Tunnelling', 'SAB02143',1,2 UNION ALL 
        SELECT 2579, 'Shredding Machine Operator', 'SAB02145',0,1 UNION ALL 
        SELECT 2580, 'Shunter - Marshalling/Goods Yard - Railways', 'SAB02146',0,1 UNION ALL 
        SELECT 2581, 'Shunter - Mining', 'SAB02147',0,1 UNION ALL 
        SELECT 2582, 'Sieve Operator - Bakeries - Food & Drink', 'SAB02148',1,2 UNION ALL 
        SELECT 2583, 'Sieve Operator - Flour Milling - Food & Drink', 'SAB02149',1,2 UNION ALL 
        SELECT 2584, 'Sieve Operator - Food & Drink - Other Processes', 'SAB02151',1,2 UNION ALL 
        SELECT 2585, 'Sieve Operator - Fruit & Veg. - Food & Drink', 'SAB02150',1,2 UNION ALL 
        SELECT 2586, 'Sieve Operator - Sugar Production - Food & Drink', 'SAB02152',1,2 UNION ALL 
        SELECT 2587, 'Siever - Cement Works', 'SAB02153',1,2 UNION ALL 
        SELECT 2588, 'Siever - Quarrying', 'SAB02154',1,2 UNION ALL 
        SELECT 2589, 'Sifter - Cement Works', 'SAB02155',1,2 UNION ALL 
        SELECT 2590, 'Sifter - Quarrying', 'SAB02158',1,2 UNION ALL 
        SELECT 2591, 'Sifter - Sugar Production - Food & Drink', 'SAB02156',1,2 UNION ALL 
        SELECT 2592, 'Sifter - Tea & Coffee - Food & Drink', 'SAB02157',1,2 UNION ALL 
        SELECT 2593, 'Sign Writer (40'' up)', 'SAB02159',0,1 UNION ALL 
        SELECT 2594, 'Sign Writer (no work at heights)', 'SAB02160',0,1 UNION ALL 
        SELECT 2595, 'Sign Writer (up to 40'')', 'SAB02161',1,2 UNION ALL 
        SELECT 2596, 'Signalling Supervisor', 'SAB02162',1,2 UNION ALL 
        SELECT 2597, 'Signalman', 'SAB02163',0,1 UNION ALL 
        SELECT 2598, 'Silksman', 'SAB02164',1,2 UNION ALL 
        SELECT 2599, 'Siloman - Cement Works', 'SAB02165',1,2 UNION ALL 
        SELECT 2600, 'Siloman - Cork Goods Manufacture', 'SAB02166',1,2 UNION ALL 
        SELECT 2601, 'Siloman - Docks', 'SAB02167',0,1 UNION ALL 
        SELECT 2602, 'Siloman - Food & Drink - General', 'SAB02168',1,2 UNION ALL 
        SELECT 2603, 'Siloman - quarry', 'SAB02169',0,2 UNION ALL 
        SELECT 2604, 'Silversmith ', 'SAC01922',0,1 UNION ALL 
        SELECT 2605, 'Sinker', 'SAB02170',1,2 UNION ALL 
        SELECT 2606, 'Sister (Hospital)', 'SAB02171',0,1 UNION ALL 
        SELECT 2607, 'Site Agent', 'SAB02172',0,1 UNION ALL 
        SELECT 2608, 'Site Engineer', 'SAB02173',1,2 UNION ALL 
        SELECT 2609, 'Site Foreman', 'SAB02174',1,2 UNION ALL 
        SELECT 2610, 'Skiing - Snow - Prof Competitor', 'SAB02175',1,2 UNION ALL 
        SELECT 2611, 'Skiing - Snow - Prof Instructor', 'SAB02176',0,1 UNION ALL 
        SELECT 2612, 'Skipper', 'SAB02177',0,1 UNION ALL 
        SELECT 2613, 'Skipper/Officer', 'SAB02178',1,2 UNION ALL 
        SELECT 2614, 'Slab Hand', 'SAB02179',1,2 UNION ALL 
        SELECT 2615, 'Slab Roller', 'SAB02180',1,2 UNION ALL 
        SELECT 2616, 'Slate Cutter', 'SAB02181',0,1 UNION ALL 
        SELECT 2617, 'Slate Dresser', 'SAB02182',0,1 UNION ALL 
        SELECT 2618, 'Slate Splitter', 'SAB02183',0,1 UNION ALL 
        SELECT 2619, 'Slater - 40'' up', 'SAB02184',0,1 UNION ALL 
        SELECT 2620, 'Slater - up to 40''', 'SAB02185',0,1 UNION ALL 
        SELECT 2621, 'Slaughterer', 'SAB02186',0,1 UNION ALL 
        SELECT 2622, 'Slaughterhouse Manager', 'SAB02187',0,1 UNION ALL 
        SELECT 2623, 'Sleeping Car Attendant', 'SAB02188',0,1 UNION ALL 
        SELECT 2624, 'Sleeve Designer', 'SAB02189',0,1 UNION ALL 
        SELECT 2625, 'Smeller', 'SAB02190',0,1 UNION ALL 
        SELECT 2626, 'Smelting Plant Worker   ', 'SAC01923',1,2 UNION ALL 
        SELECT 2627, 'Smith - Gold, Silver etc', 'SAB02191',0,1 UNION ALL 
        SELECT 2628, 'Smoker', 'SAB02192',0,1 UNION ALL 
        SELECT 2629, 'Smoother', 'SAB02193',1,2 UNION ALL 
        SELECT 2630, 'Snooker', 'SAB02194',1,2 UNION ALL 
        SELECT 2631, 'Snuff Maker', 'SAB02195',1,2 UNION ALL 
        SELECT 2632, 'Soccer (Association Football)', 'SAB02196',1,2 UNION ALL 
        SELECT 2633, 'Social and Behavioural Scientist    ', 'SAC01924',1,2 UNION ALL 
        SELECT 2634, 'Social Worker', 'SAB02197',0,1 UNION ALL 
        SELECT 2635, 'Sociologist', 'SAB02198',0,1 UNION ALL 
        SELECT 2636, 'Solderer', 'SAB02199',0,1 UNION ALL 
        SELECT 2637, 'Solicitor', 'SAB02200',0,1 UNION ALL 
        SELECT 2638, 'Song Writer', 'SAB02201',0,1 UNION ALL 
        SELECT 2639, 'Sorter - Dry Cleaning', 'SAB02202',0,1 UNION ALL 
        SELECT 2640, 'Sorter - Laundry', 'SAB02203',0,1 UNION ALL 
        SELECT 2641, 'Sorter - Post Office/Telecommunications', 'SAB02204',0,1 UNION ALL 
        SELECT 2642, 'Sorter (scrap metal)', 'SAB02205',0,1 UNION ALL 
        SELECT 2643, 'Sound Balancer - Film Industry - Entertainment', 'SAB02206',1,2 UNION ALL 
        SELECT 2644, 'Sound Balancer - Music Industry - Entertainment', 'SAB02207',1,2 UNION ALL 
        SELECT 2645, 'Sound Mixer - Film Industry - Entertainment', 'SAB02208',1,2 UNION ALL 
        SELECT 2646, 'Sound Mixer - Music Industry - Entertainment', 'SAB02209',1,2 UNION ALL 
        SELECT 2647, 'Sound Recordist - Film Industry - Entertainment', 'SAB02210',1,2 UNION ALL 
        SELECT 2648, 'Sound Recordist - Music Industry - Entertainment', 'SAB02211',1,2 UNION ALL 
        SELECT 2649, 'Sound Technician', 'SAB02212',0,1 UNION ALL 
        SELECT 2650, 'Spare Hand', 'SAB02213',1,2 UNION ALL 
        SELECT 2651, 'Special Air Service (SAS)', 'SAB02214',0,1 UNION ALL 
        SELECT 2652, 'Special Boat Service (SBS)', 'SAB02215',0,1 UNION ALL 
        SELECT 2653, 'Special Effects Man', 'SAB02216',1,2 UNION ALL 
        SELECT 2654, 'Special Effects Technician', 'SAB02217',0,1 UNION ALL 
        SELECT 2655, 'Speech Therapist', 'SAB02218',0,1 UNION ALL 
        SELECT 2656, 'Spiderman', 'SAB02219',0,1 UNION ALL 
        SELECT 2657, 'Spinner', 'SAB02220',0,1 UNION ALL 
        SELECT 2658, 'Spiritualist', 'SAB02221',1,2 UNION ALL 
        SELECT 2659, 'Sponge Cutter', 'SAB02222',1,2 UNION ALL 
        SELECT 2660, 'Sponge Dresser', 'SAB02223',1,2 UNION ALL 
        SELECT 2661, 'Sports Equipment Maker', 'SAB02224',0,1 UNION ALL 
        SELECT 2662, 'Sports Equipment Repairer', 'SAB02225',0,1 UNION ALL 
        SELECT 2663, 'Sports Official ', 'SAC01925',1,2 UNION ALL 
        SELECT 2664, 'Sports Tennis coach ', 'SAC01926',1,2 UNION ALL 
        SELECT 2665, 'Spotter', 'SAB02227',1,2 UNION ALL 
        SELECT 2666, 'Spot-Welder', 'SAB02226',0,1 UNION ALL 
        SELECT 2667, 'Spragger', 'SAB02228',1,2 UNION ALL 
        SELECT 2668, 'Spray Enameller', 'SAB02229',1,2 UNION ALL 
        SELECT 2669, 'Spray Painter - Aircraft/Aerospace', 'SAB02230',1,2 UNION ALL 
        SELECT 2670, 'Spray Painter - Metal Plating & Coating - Metal Manufacture', 'SAB02231',1,2 UNION ALL 
        SELECT 2671, 'Spray Painter - Rolling Stock Manuf. - Railways', 'SAB02232',1,2 UNION ALL 
        SELECT 2672, 'Sprayer', 'SAB02233',1,2 UNION ALL 
        SELECT 2673, 'Squash', 'SAB02234',1,2 UNION ALL 
        SELECT 2674, 'Stablehand', 'SAB02235',0,1 UNION ALL 
        SELECT 2675, 'Staff Nurse', 'SAB02236',0,1 UNION ALL 
        SELECT 2676, 'Stage Doorkeeper', 'SAB02237',0,1 UNION ALL 
        SELECT 2677, 'Stage Hand', 'SAB02238',0,1 UNION ALL 
        SELECT 2678, 'Stage manager - Entertainment industry  ', 'SAC01927',1,2 UNION ALL 
        SELECT 2679, 'Stage Manager - Radio & TV - Entertainment', 'SAB02239',1,2 UNION ALL 
        SELECT 2680, 'Stage Manager - Theatre, Ballet etc - Entertainment', 'SAB02240',1,2 UNION ALL 
        SELECT 2681, 'Stage Technician    ', 'SAC01928',0,1 UNION ALL 
        SELECT 2682, 'Stager', 'SAB02241',1,2 UNION ALL 
        SELECT 2683, 'Stamper (identification markings)', 'SAB02242',0,1 UNION ALL 
        SELECT 2684, 'Station Chargeman', 'SAB02243',1,2 UNION ALL 
        SELECT 2685, 'Station Foreman', 'SAB02244',1,2 UNION ALL 
        SELECT 2686, 'Station Manager - Airlines', 'SAB02245',1,2 UNION ALL 
        SELECT 2687, 'Station Manager - Station Personnel - Railways', 'SAB02246',1,2 UNION ALL 
        SELECT 2688, 'Station Master', 'SAB02247',1,2 UNION ALL 
        SELECT 2689, 'Station Officer - Fire Service', 'SAB02248',1,2 UNION ALL 
        SELECT 2690, 'Station Officer - Salvage Corps', 'SAB02249',1,2 UNION ALL 
        SELECT 2691, 'Station Superintendent (Ambulance)', 'SAB02250',1,2 UNION ALL 
        SELECT 2692, 'Station Supervisor', 'SAB02251',1,2 UNION ALL 
        SELECT 2693, 'Stationer   ', 'SAC01929',0,1 UNION ALL 
        SELECT 2694, 'Stationman', 'SAB02252',1,2 UNION ALL 
        SELECT 2695, 'Statistician', 'SAB02253',0,1 UNION ALL 
        SELECT 2696, 'Steel Erector - 40'' up', 'SAB02254',0,1 UNION ALL 
        SELECT 2697, 'Steel Erector - up to 40''', 'SAB02255',0,1 UNION ALL 
        SELECT 2698, 'Steel Erector''s Labourer', 'SAB02256',1,2 UNION ALL 
        SELECT 2699, 'Steel Straightener', 'SAB02257',1,2 UNION ALL 
        SELECT 2700, 'Steeplejack', 'SAB02258',0,1 UNION ALL 
        SELECT 2701, 'Steeplejack''s Labourer', 'SAB02259',1,2 UNION ALL 
        SELECT 2702, 'Steerer', 'SAB02260',1,2 UNION ALL 
        SELECT 2703, 'Stencil Cutter', 'SAB02261',1,2 UNION ALL 
        SELECT 2704, 'Stencil Plate Maker', 'SAB02262',1,2 UNION ALL 
        SELECT 2705, 'Stenographer', 'SAB02263',0,1 UNION ALL 
        SELECT 2706, 'Stereotyper', 'SAB02264',1,2 UNION ALL 
        SELECT 2707, 'Steriliser - Dairy Products - Food & Drink', 'SAB02265',1,2 UNION ALL 
        SELECT 2708, 'Steriliser - Food & Drink - General', 'SAB02266',1,2 UNION ALL 
        SELECT 2709, 'Stevedore', 'SAB02267',0,1 UNION ALL 
        SELECT 2710, 'Steward (except Chief/Second)', 'SAB02268',1,2 UNION ALL 
        SELECT 2711, 'Stitcher', 'SAB02269',0,1 UNION ALL 
        SELECT 2712, 'Stockbroker', 'SAB02270',0,1 UNION ALL 
        SELECT 2713, 'Stockman', 'SAB02271',1,2 UNION ALL 
        SELECT 2714, 'Stockman for Veterinary College ', 'SAC01930',1,2 UNION ALL 
        SELECT 2715, 'Stockroom Storeman', 'SAB02272',0,1 UNION ALL 
        SELECT 2716, 'Stocktaker', 'SAB02273',0,1 UNION ALL 
        SELECT 2717, 'Stoker - Fishing Industry', 'SAB02274',1,2 UNION ALL 
        SELECT 2718, 'Stoker - Merchant Marine', 'SAB02275',1,2 UNION ALL 
        SELECT 2719, 'Stone Breaker - Quarrying', 'SAB02276',1,2 UNION ALL 
        SELECT 2720, 'Stone Breaker - Stoneworking', 'SAB02277',1,2 UNION ALL 
        SELECT 2721, 'Stone Carver', 'SAB02278',1,2 UNION ALL 
        SELECT 2722, 'Stone Dresser', 'SAB02279',1,2 UNION ALL 
        SELECT 2723, 'Stone Sawyer', 'SAB02280',1,2 UNION ALL 
        SELECT 2724, 'Stone Turner', 'SAB02281',1,2 UNION ALL 
        SELECT 2725, 'Stone/Slate Polisher - hand', 'SAB02282',1,2 UNION ALL 
        SELECT 2726, 'Stone/Slate Polisher - machine', 'SAB02283',1,2 UNION ALL 
        SELECT 2727, 'Stonemason', 'SAB02284',0,1 UNION ALL 
        SELECT 2728, 'Store Detective', 'SAB02285',0,1 UNION ALL 
        SELECT 2729, 'Storekeeper', 'SAB02286',0,1 UNION ALL 
        SELECT 2730, 'Storekeeper - Oil Rig Industry  ', 'SAC01931',1,2 UNION ALL 
        SELECT 2731, 'Storeman - Chemical & Plastics Industry', 'SAB02287',1,2 UNION ALL 
        SELECT 2732, 'Storeman - Minerals', 'SAB02288',1,2 UNION ALL 
        SELECT 2733, 'Storeman - Rubber Industry - Natural', 'SAB02289',1,2 UNION ALL 
        SELECT 2734, 'Stores Controller   ', 'SAC01932',1,2 UNION ALL 
        SELECT 2735, 'Straddle Carrier Driver - Docks', 'SAB02290',1,2 UNION ALL 
        SELECT 2736, 'Straddle Carrier Driver - Marshalling/Goods Yard - Railways', 'SAB02291',1,2 UNION ALL 
        SELECT 2737, 'Street Cleaner (hand)', 'SAB02292',1,2 UNION ALL 
        SELECT 2738, 'Lollipop Man/Lady', 'SAB02293',0,2 UNION ALL 
        SELECT 2739, 'Street Mason', 'SAB02294',1,2 UNION ALL 
        SELECT 2740, 'Street Photographer', 'SAB02295',1,2 UNION ALL 
        SELECT 2741, 'Street Vendor   ', 'SAC01933',1,2 UNION ALL 
        SELECT 2742, 'Structural Engineer - Construction Industry', 'SAB02296',1,2 UNION ALL 
        SELECT 2743, 'Structural Engineer - Tunnelling', 'SAB02297',1,2 UNION ALL 
        SELECT 2744, 'Structural Engineer (Office based)  ', 'SAC01934',1,2 UNION ALL 
        SELECT 2745, 'Student', 'SAB02298',0,1 UNION ALL 
        SELECT 2746, 'Student Pilots', 'SAB02299',1,2 UNION ALL 
        SELECT 2747, 'Studio Layout Artist', 'SAB02300',1,2 UNION ALL 
        SELECT 2748, 'Stunt Man', 'SAB02301',0,1 UNION ALL 
        SELECT 2749, 'Sub Officer', 'SAB02302',1,2 UNION ALL 
        SELECT 2750, 'Submariner', 'SAB02305',0,2 UNION ALL 
        SELECT 2751, 'Sub-Officer', 'SAB02303',1,2 UNION ALL 
        SELECT 2752, 'Sub-sea Engineer', 'SAB02304',1,2 UNION ALL 
        SELECT 2753, 'Sugar Beet Cutter/Slicer', 'SAB02306',0,1 UNION ALL 
        SELECT 2754, 'Sugar Boiler', 'SAB02307',0,1 UNION ALL 
        SELECT 2755, 'Superintendent - Airlines', 'SAB02308',1,2 UNION ALL 
        SELECT 2756, 'Superintendent - Cemetery, Crematorium', 'SAB02309',1,2 UNION ALL 
        SELECT 2757, 'Supermarket Cashier', 'SAB02310',0,1 UNION ALL 
        SELECT 2758, 'Supermarket Deputy Manager  ', 'SAC01935',1,2 UNION ALL 
        SELECT 2759, 'Supervisor - Dry Cleaning', 'SAB02311',1,2 UNION ALL 
        SELECT 2760, 'Supervisor - Laundry', 'SAB02312',1,2 UNION ALL 
        SELECT 2761, 'Supplies Transporter', 'SAB02313',1,2 UNION ALL 
        SELECT 2762, 'Supports Checker', 'SAB02314',1,2 UNION ALL 
        SELECT 2763, 'Surface Laying Machine Driver', 'SAB02315',1,2 UNION ALL 
        SELECT 2764, 'Surface Workers', 'SAB02316',1,2 UNION ALL 
        SELECT 2765, 'Surgeon', 'SAB02317',0,1 UNION ALL 
        SELECT 2766, 'Surgery Nurse', 'SAB02318',0,1 UNION ALL 
        SELECT 2767, 'Surgery Receptionist', 'SAB02319',0,1 UNION ALL 
        SELECT 2768, 'Surgical Appliance Maker', 'SAB02320',0,1 UNION ALL 
        SELECT 2769, 'Surgical Shoe Maker ', 'SAC01936',0,1 UNION ALL 
        SELECT 2770, 'Survey Sounder', 'SAB02321',1,2 UNION ALL 
        SELECT 2771, 'Surveyor - Oil & Natural Gas Industries (Exploration & Production)', 'SAB02322',0,1 UNION ALL 
        SELECT 2772, 'Surveyor - Ship Building, Ship Repair & Marine Engineering', 'SAB02323',0,1 UNION ALL 
        SELECT 2773, 'Swimming', 'SAB02324',1,2 UNION ALL 
        SELECT 2774, 'Swimming Instructor ', 'SAC01937',0,1 UNION ALL 
        SELECT 2775, 'Swimming Pool Attendant', 'SAB02325',0,1 UNION ALL 
        SELECT 2776, 'Switchboard Operator', 'SAB02326',0,1 UNION ALL 
        SELECT 2777, 'Sword Swallower', 'SAB02327',0,1 UNION ALL 
        SELECT 2778, 'Systems Analyst ', 'SAC01938',1,2 UNION ALL 
        SELECT 2779, 'Table Tennis', 'TAB02328',1,2 UNION ALL 
        SELECT 2780, 'Tailor - Retail Bespoke', 'TAB02329',1,2 UNION ALL 
        SELECT 2781, 'Tailor - Wholesale', 'TAB02330',1,2 UNION ALL 
        SELECT 2782, 'Tallow Maker', 'TAB02331',1,2 UNION ALL 
        SELECT 2783, 'Tally Clerk', 'TAB02332',1,2 UNION ALL 
        SELECT 2784, 'Tamperman', 'TAB02333',0,1 UNION ALL 
        SELECT 2785, 'Tank Room Attendant', 'TAB02334',0,1 UNION ALL 
        SELECT 2786, 'Tanker Filler - Gas Supply Industry', 'TAB02336',1,2 UNION ALL 
        SELECT 2787, 'Tanker Filler - N/A', 'TAB02335',1,2 UNION ALL 
        SELECT 2788, 'Tannery Production Worker   ', 'TAC01939',1,2 UNION ALL 
        SELECT 2789, 'Tar Melter', 'TAB02337',1,2 UNION ALL 
        SELECT 2790, 'Tarmac Layer - Construction Industry', 'TAB02338',0,1 UNION ALL 
        SELECT 2791, 'Tarmac Layer - Road Maintenance & Construction', 'TAB02339',0,1 UNION ALL 
        SELECT 2792, 'Tax Consultant', 'TAB02340',0,1 UNION ALL 
        SELECT 2793, 'Tax Inspector', 'TAB02341',0,1 UNION ALL 
        SELECT 2794, 'Taxation Expert ', 'TAC01940',1,2 UNION ALL 
        SELECT 2795, 'Taxi Business Administrator ', 'TAC01941',0,1 UNION ALL 
        SELECT 2796, 'Taxi Business Manager (admin. only)    ', 'TAC01942',1,2 UNION ALL 
        SELECT 2797, 'Taxi Business Proprietor (no driving)   ', 'TAC01943',0,1 UNION ALL 
        SELECT 2798, 'Taxi Driver', 'TAB02342',0,1 UNION ALL 
        SELECT 2799, 'Taxidermist', 'TAB02343',0,1 UNION ALL 
        SELECT 2800, 'Teacher (Full Time)', 'TAB02344',1,2 UNION ALL 
        SELECT 2801, 'Teacher (Part Time)', 'TAB02345',1,2 UNION ALL 
        SELECT 2802, 'Teaching Assistant', 'TAC01944',0,2 UNION ALL 
        SELECT 2803, 'Technical Assistant - Adhesives Manufacture', 'TAB02347',1,2 UNION ALL 
        SELECT 2804, 'Technical Assistant - Aircraft/Aerospace', 'TAB02346',1,2 UNION ALL 
        SELECT 2805, 'Technical Assistant - Misc. Workers - Metal Manufacture', 'TAB02348',1,2 UNION ALL 
        SELECT 2806, 'Technical Assistant - Motor Vehicle & Cycle Industry', 'TAB02349',1,2 UNION ALL 
        SELECT 2807, 'Technical Assistant - Oil Refining', 'TAB02350',1,2 UNION ALL 
        SELECT 2808, 'Technical Assistant - Ship Building, Ship Repair & Marine Engineering', 'TAB02351',1,2 UNION ALL 
        SELECT 2809, 'Technical Controller - Aircraft/Aerospace', 'TAB02352',1,2 UNION ALL 
        SELECT 2810, 'Technical Controller - Misc. Workers - Metal Manufacture', 'TAB02353',1,2 UNION ALL 
        SELECT 2811, 'Technical Controller - Oil Refining', 'TAB02354',1,2 UNION ALL 
        SELECT 2812, 'Technical Controller - Ship Building, Ship Repair & Marine Engineering', 'TAB02355',1,2 UNION ALL 
        SELECT 2813, 'Technical Controller (Installation)', 'TAB02356',1,2 UNION ALL 
        SELECT 2814, 'Technical Observers', 'TAB02357',1,2 UNION ALL 
        SELECT 2815, 'Technician', 'TAB02358',1,2 UNION ALL 
        SELECT 2816, 'Technician - Engineering Usually ...', 'TAB02361',1,2 UNION ALL 
        SELECT 2817, 'Technician - Laboratory Usually ...', 'TAB02362',1,2 UNION ALL 
        SELECT 2818, 'Technician - Medical', 'TAB02363',1,2 UNION ALL 
        SELECT 2819, 'Technician - Research Usually ...', 'TAB02364',1,2 UNION ALL 
        SELECT 2820, 'Technician (Maintenance)', 'TAB02359',1,2 UNION ALL 
        SELECT 2821, 'Technician - other', 'TAB02360',0,2 UNION ALL 
        SELECT 2822, 'Telecommunication Technical Officer    ', 'TAC01945',0,1 UNION ALL 
        SELECT 2823, 'Telegraphist', 'TAB02365',0,1 UNION ALL 
        SELECT 2824, 'Telephone Customer Advisor  ', 'TAC01946',0,1 UNION ALL 
        SELECT 2825, 'Telephone Exchange Superintendent', 'TAB02366',0,1 UNION ALL 
        SELECT 2826, 'Telephone Fitter', 'TAB02367',0,1 UNION ALL 
        SELECT 2827, 'Telephone Operator', 'TAB02368',0,1 UNION ALL 
        SELECT 2828, 'Telephone Repairer', 'TAB02369',0,1 UNION ALL 
        SELECT 2829, 'Telephone Supervisor', 'TAB02370',0,1 UNION ALL 
        SELECT 2830, 'Telephone Systems Sales Director    ', 'TAC01947',0,1 UNION ALL 
        SELECT 2831, 'Telephonist', 'TAB02371',0,1 UNION ALL 
        SELECT 2832, 'Teleprinter Operator', 'TAB02372',1,2 UNION ALL 
        SELECT 2833, 'Television Engineer ', 'TAC01948',0,1 UNION ALL 
        SELECT 2834, 'Telex Operator', 'TAB02373',1,2 UNION ALL 
        SELECT 2835, 'Temperer', 'TAB02374',1,2 UNION ALL 
        SELECT 2836, 'Template Maker', 'TAB02375',1,2 UNION ALL 
        SELECT 2837, 'Test Engineer - Misc. Workers - Metal Manufacture', 'TAB02376',1,2 UNION ALL 
        SELECT 2838, 'Test Engineer - Nuclear Energy', 'TAB02377',1,2 UNION ALL 
        SELECT 2839, 'Test Engineer - Oil Refining', 'TAB02378',1,2 UNION ALL 
        SELECT 2840, 'Test Engineer - Ship Building, Ship Repair & Marine Engineering', 'TAB02379',1,2 UNION ALL 
        SELECT 2841, 'Test Pilots', 'TAB02380',0,1 UNION ALL 
        SELECT 2842, 'Tester - Asbestos', 'TAB02381',1,2 UNION ALL 
        SELECT 2843, 'Tester - Chemical & Plastics Industry', 'TAB02382',1,2 UNION ALL 
        SELECT 2844, 'Tester - Electronic Goods Manufacture', 'TAB02383',1,2 UNION ALL 
        SELECT 2845, 'Tester - Food & Drink - General', 'TAB02384',1,2 UNION ALL 
        SELECT 2846, 'Tester - Misc. Workers - Metal Manufacture', 'TAB02385',1,2 UNION ALL 
        SELECT 2847, 'Tester - Musical Instrument Making & Repair', 'TAB02386',1,2 UNION ALL 
        SELECT 2848, 'Tester - Optical Goods Industry', 'TAB02387',1,2 UNION ALL 
        SELECT 2849, 'Tester - Precision Instrument Making & Repair', 'TAB02388',1,2 UNION ALL 
        SELECT 2850, 'Tester (Chemical composition)', 'TAB02389',1,2 UNION ALL 
        SELECT 2851, 'Tester (Machinery, Plant)', 'TAB02390',1,2 UNION ALL 
        SELECT 2852, 'Tester (Matches)', 'TAB02391',1,2 UNION ALL 
        SELECT 2853, 'Textile Technologist', 'TAB02392',1,2 UNION ALL 
        SELECT 2854, 'Textile Worker  ', 'TAC01949',0,1 UNION ALL 
        SELECT 2855, 'Thatcher', 'TAB02393',0,1 UNION ALL 
        SELECT 2856, 'Theatre Sound Engineer  ', 'TAC01950',0,1 UNION ALL 
        SELECT 2857, 'Third Hand', 'TAB02394',1,2 UNION ALL 
        SELECT 2858, 'Thrower', 'TAB02395',1,2 UNION ALL 
        SELECT 2859, 'Tic Tac Man', 'TAB02396',1,2 UNION ALL 
        SELECT 2860, 'Ticket Collector', 'TAB02397',1,2 UNION ALL 
        SELECT 2861, 'Ticket Inspector', 'TAB02398',0,1 UNION ALL 
        SELECT 2862, 'Ticketer', 'TAB02399',1,2 UNION ALL 
        SELECT 2863, 'Tiler - 40'' up', 'TAB02400',0,1 UNION ALL 
        SELECT 2864, 'Tiler - up to 40''', 'TAB02401',0,1 UNION ALL 
        SELECT 2865, 'Timber Merchant (no manual work)', 'TAB02402',0,1 UNION ALL 
        SELECT 2866, 'Timber Technologist', 'TAB02403',1,2 UNION ALL 
        SELECT 2867, 'Timberer, Timberman', 'TAB02404',1,2 UNION ALL 
        SELECT 2868, 'Timberman', 'TAB02405',0,1 UNION ALL 
        SELECT 2869, 'Timberman - Surface Excavations', 'TAB02406',1,2 UNION ALL 
        SELECT 2870, 'Time & Motion Study Officer', 'TAB02407',1,2 UNION ALL 
        SELECT 2871, 'Tip & Die Cutter', 'TAB02408',1,2 UNION ALL 
        SELECT 2872, 'Tippler Operator - Marshalling/Goods Yard - Railways', 'TAB02409',1,2 UNION ALL 
        SELECT 2873, 'Tippler Operator - Mining', 'TAB02410',1,2 UNION ALL 
        SELECT 2874, 'Tobacconist ', 'TAC01951',0,1 UNION ALL 
        SELECT 2875, 'Tool Designer (office based)    ', 'TAC01952',1,2 UNION ALL 
        SELECT 2876, 'Tool Dresser - Driller', 'TAB02411',1,2 UNION ALL 
        SELECT 2877, 'Tool Fitter', 'TAB02412',0,1 UNION ALL 
        SELECT 2878, 'Tool Maker', 'TAB02413',0,1 UNION ALL 
        SELECT 2879, 'Tool Pusher', 'TAB02414',0,1 UNION ALL 
        SELECT 2880, 'Topman - Construction Industry', 'TAB02415',1,2 UNION ALL 
        SELECT 2881, 'Topman - Oil & Natural Gas Industries (Exploration & Production)', 'TAB02416',1,2 UNION ALL 
        SELECT 2882, 'Tour Guide', 'TAB02417',0,1 UNION ALL 
        SELECT 2883, 'Tour Manager', 'TAB02418',0,1 UNION ALL 
        SELECT 2884, 'Tower Crane Driver', 'TAB02419',0,1 UNION ALL 
        SELECT 2885, 'Town Planner', 'TAB02420',0,1 UNION ALL 
        SELECT 2886, 'Toxicologist', 'TAB02421',0,1 UNION ALL 
        SELECT 2887, 'Track Chargeman', 'TAB02422',1,2 UNION ALL 
        SELECT 2888, 'Track Layer', 'TAB02423',1,2 UNION ALL 
        SELECT 2889, 'Track Laying Machine Operator', 'TAB02424',1,2 UNION ALL 
        SELECT 2890, 'Tracker', 'TAB02425',1,2 UNION ALL 
        SELECT 2891, 'Trackman', 'TAB02426',0,1 UNION ALL 
        SELECT 2892, 'Traffic Warden', 'TAB02427',0,1 UNION ALL 
        SELECT 2893, 'Train Crew Inspector', 'TAB02428',0,1 UNION ALL 
        SELECT 2894, 'Train Crew Supervisor', 'TAB02429',0,1 UNION ALL 
        SELECT 2895, 'Train Driver    ', 'TAC01953',0,1 UNION ALL 
        SELECT 2896, 'Trainee Fisherman/Deckhand', 'TAB02430',1,2 UNION ALL 
        SELECT 2897, 'Trammer (Mine Car)', 'TAB02431',1,2 UNION ALL 
        SELECT 2898, 'Translator', 'TAB02432',0,1 UNION ALL 
        SELECT 2899, 'Transport Company Operations Manager (Office based) ', 'TAC01954',0,1 UNION ALL 
        SELECT 2900, 'Transport Control Operator', 'TAB02433',1,2 UNION ALL 
        SELECT 2901, 'Transport Manager   ', 'TAC01955',0,1 UNION ALL 
        SELECT 2902, 'Travel Agent (office based) ', 'TAC01956',0,1 UNION ALL 
        SELECT 2903, 'Travel Courier', 'TAB02434',0,1 UNION ALL 
        SELECT 2904, 'Trawlerman', 'TAB02435',0,1 UNION ALL 
        SELECT 2905, 'Tree Feller', 'TAB02436',0,1 UNION ALL 
        SELECT 2906, 'Tree Surgeon', 'TAB02437',0,1 UNION ALL 
        SELECT 2907, 'Trenchman', 'TAB02438',0,1 UNION ALL 
        SELECT 2908, 'Troubled Areas - NI (incl. RIR)', 'TAB02439',1,2 UNION ALL 
        SELECT 2909, 'Troubled Areas - Not NI', 'TAB02440',1,2 UNION ALL 
        SELECT 2910, 'Trowel Worker', 'TAB02441',1,2 UNION ALL 
        SELECT 2911, 'Tugboatman', 'TAB02442',1,2 UNION ALL 
        SELECT 2912, 'Tugman', 'TAB02443',0,1 UNION ALL 
        SELECT 2913, 'Tumbler Operator - Dry Cleaning', 'TAB02444',1,2 UNION ALL 
        SELECT 2914, 'Tumbler Operator - Laundry', 'TAB02445',1,2 UNION ALL 
        SELECT 2915, 'Tunnel Miner - no explosives etc', 'TAB02446',1,2 UNION ALL 
        SELECT 2916, 'Tunnel Miner - using explosives etc', 'TAB02447',1,2 UNION ALL 
        SELECT 2917, 'Tunnel Miner''s Labourer', 'TAB02448',1,2 UNION ALL 
        SELECT 2918, 'Tunneller - no explosives etc', 'TAB02449',0,1 UNION ALL 
        SELECT 2919, 'Tunneller - using explosives etc', 'TAB02450',0,1 UNION ALL 
        SELECT 2920, 'Turf Accountant (on course) ', 'TAC01957',0,1 UNION ALL 
        SELECT 2921, 'Turf Accountant (shop)  ', 'TAC01958',0,1 UNION ALL 
        SELECT 2922, 'Turner - Machining, Shaping etc - Metal Manufacture', 'TAB02451',0,1 UNION ALL 
        SELECT 2923, 'Turner - Pottery Industry', 'TAB02452',0,1 UNION ALL 
        SELECT 2924, 'Turnstile Operator', 'TAB02453',0,1 UNION ALL 
        SELECT 2925, 'Tutor (salaried)', 'TAB02454',0,1 UNION ALL 
        SELECT 2926, 'Tutor (self-employed)', 'TAB02455',0,1 UNION ALL 
        SELECT 2927, 'Twister', 'TAB02456',1,2 UNION ALL 
        SELECT 2928, 'Type Caster', 'TAB02457',0,1 UNION ALL 
        SELECT 2929, 'Typesetter  ', 'TAC01959',0,1 UNION ALL 
        SELECT 2930, 'Typist', 'TAB02458',1,2 UNION ALL 
        SELECT 2931, 'Typograph Operator', 'TAB02459',0,1 UNION ALL 
        SELECT 2932, 'Typographical Designer', 'TAB02460',0,1 UNION ALL 
        SELECT 2933, 'Tyre Fitter', 'TAB02461',1,2 UNION ALL 
        SELECT 2934, 'Under Manager', 'UAB02462',1,2 UNION ALL 
        SELECT 2935, 'Undertaker', 'UAB02463',0,1 UNION ALL 
        SELECT 2936, 'Undertaker''s Directors Assistant', 'UAB02464',0,1 UNION ALL 
        SELECT 2937, 'Underwriter', 'UAB02465',0,1 UNION ALL 
        SELECT 2938, 'Unemployed  ', 'UAC01960',0,1 UNION ALL 
        SELECT 2939, 'Unknown', 'UAC01961',0,2 UNION ALL 
        SELECT 2940, 'Unskilled Workers', 'UAB02466',1,2 UNION ALL 
        SELECT 2941, 'Upholsterer', 'UAB02467',0,1 UNION ALL 
        SELECT 2942, 'Usher, Usherette', 'UAB02468',1,2 UNION ALL 
        SELECT 2943, 'Usher/Usherette', 'UAB02469',0,1 UNION ALL 
        SELECT 2944, 'Valet/Valeter', 'VAB02470',0,2 UNION ALL 
        SELECT 2945, 'Valuer', 'VAB02471',0,1 UNION ALL 
        SELECT 2946, 'Valveman - Gas Supply Industry', 'VAB02472',1,2 UNION ALL 
        SELECT 2947, 'Valveman - Oil & Natural Gas Industries (Exploration & Production)', 'VAB02473',1,2 UNION ALL 
        SELECT 2948, 'Valveman - Quarrying', 'VAB02474',1,2 UNION ALL 
        SELECT 2949, 'Van Driver', 'VAB02475',0,1 UNION ALL 
        SELECT 2950, 'Varnisher', 'VAB02476',0,1 UNION ALL 
        SELECT 2951, 'Vatman', 'VAB02477',0,1 UNION ALL 
        SELECT 2952, 'Vehicle Body Builder', 'VAB02478',0,1 UNION ALL 
        SELECT 2953, 'Vehicle Body Fitter', 'VAB02479',0,1 UNION ALL 
        SELECT 2954, 'Vending Machine Engineer    ', 'VAC01962',0,1 UNION ALL 
        SELECT 2955, 'Venetian Blind Maker', 'VAB02480',0,1 UNION ALL 
        SELECT 2956, 'Ventriloquist', 'VAB02481',0,1 UNION ALL 
        SELECT 2957, 'Verger', 'VAB02482',0,1 UNION ALL 
        SELECT 2958, 'Veterinarian', 'VAB02483',0,1 UNION ALL 
        SELECT 2959, 'Veterinarian - Domestic Only', 'VAB02484',1,2 UNION ALL 
        SELECT 2960, 'Veterinary Assistant', 'VAB02485',0,1 UNION ALL 
        SELECT 2961, 'Veterinary Officer', 'VAB02486',1,2 UNION ALL 
        SELECT 2962, 'Veterinary Officer - Domestic Only', 'VAB02487',1,2 UNION ALL 
        SELECT 2963, 'Veterinary Practitioner', 'VAB02488',1,2 UNION ALL 
        SELECT 2964, 'Veterinary Practitioner - Domestic Only', 'VAB02489',1,2 UNION ALL 
        SELECT 2965, 'Veterinary Surgeon', 'VAB02490',1,2 UNION ALL 
        SELECT 2966, 'Veterinary Surgeon - Domestic Only', 'VAB02491',1,2 UNION ALL 
        SELECT 2967, 'Vicar', 'VAB02492',0,1 UNION ALL 
        SELECT 2968, 'Video Conference Engineer   ', 'VAC01963',0,1 UNION ALL 
        SELECT 2969, 'Video Recorder Operator', 'VAB02493',0,1 UNION ALL 
        SELECT 2970, 'Viscoliser Operator', 'VAB02494',1,2 UNION ALL 
        SELECT 2971, 'Vision Mixer', 'VAB02495',0,1 UNION ALL 
        SELECT 2972, 'Vocational Training Instructor', 'VAB02496',0,1 UNION ALL 
        SELECT 2973, 'Volleyball', 'VAB02497',1,2 UNION ALL 
        SELECT 2974, 'Votator Operator', 'VAB02498',1,2 UNION ALL 
        SELECT 2975, 'Wages Inspector', 'WAB02499',0,1 UNION ALL 
        SELECT 2976, 'Wagon Lifter', 'WAB02500',1,2 UNION ALL 
        SELECT 2977, 'Wagon Traverser Operator - Marshalling/Goods Yard - Railways', 'WAB02501',1,2 UNION ALL 
        SELECT 2978, 'Wagon Traverser Operator - Mining', 'WAB02502',1,2 UNION ALL 
        SELECT 2979, 'Waiter, Waitress', 'WAB02503',0,1 UNION ALL 
        SELECT 2980, 'Wall of Death Rider', 'WAB02504',1,2 UNION ALL 
        SELECT 2981, 'Walling Mason', 'WAB02505',1,2 UNION ALL 
        SELECT 2982, 'Wallpaper Printer', 'WAB02506',0,1 UNION ALL 
        SELECT 2983, 'Warden', 'WAB02507',0,1 UNION ALL 
        SELECT 2984, 'Wardrobe Mistress', 'WAB02508',0,1 UNION ALL 
        SELECT 2985, 'Warehouse Keeper', 'WAB02509',1,2 UNION ALL 
        SELECT 2986, 'Warehouse Manager', 'WAB02510',0,1 UNION ALL 
        SELECT 2987, 'Warehouse Porter - Usually', 'WAB02511',1,2 UNION ALL 
        SELECT 2988, 'Warehouse Superintendent', 'WAB02512',1,2 UNION ALL 
        SELECT 2989, 'Warehouseman', 'WAB02513',0,1 UNION ALL 
        SELECT 2990, 'Washer - Laundry', 'WAB02516',1,2 UNION ALL 
        SELECT 2991, 'Washer - Meat, Fish etc - Food & Drink', 'WAB02514',1,2 UNION ALL 
        SELECT 2992, 'Washer - Sugar Production - Food & Drink', 'WAB02515',1,2 UNION ALL 
        SELECT 2993, 'Washerman', 'WAB02517',1,2 UNION ALL 
        SELECT 2994, 'Wasteman, Salvage Man', 'WAB02518',0,1 UNION ALL 
        SELECT 2995, 'Watch & Clock Maker ', 'WAC01964',0,1 UNION ALL 
        SELECT 2996, 'Watch & Clock Repairer  ', 'WAC01965',0,1 UNION ALL 
        SELECT 2997, 'Watchman (inland waterways)', 'WAB02519',0,1 UNION ALL 
        SELECT 2998, 'Watchstander', 'WAB02520',0,1 UNION ALL 
        SELECT 2999, 'Water Bailiff', 'WAB02521',0,1 UNION ALL 
        SELECT 3000, 'Water Infusion Man', 'WAB02522',0,1 UNION ALL 
        SELECT 3001, 'Water Skiing - Prof. Competitor', 'WAB02523',1,2 UNION ALL 
        SELECT 3002, 'Water Skiing - Prof. Instructor', 'WAB02524',0,1 UNION ALL 
        SELECT 3003, 'Water Works Superintendent', 'WAB02525',1,2 UNION ALL 
        SELECT 3004, 'Weaver - Carpet', 'WAB02526',1,2 UNION ALL 
        SELECT 3005, 'Weaver - Handloom', 'WAB02527',1,2 UNION ALL 
        SELECT 3006, 'Weaver - Other', 'WAB02528',1,2 UNION ALL 
        SELECT 3007, 'Wedding Photographer', 'WAB02529',0,1 UNION ALL 
        SELECT 3008, 'Weighbridge Clerk', 'WAB02530',0,1 UNION ALL 
        SELECT 3009, 'Weighbridgeman - Docks', 'WAB02532',1,2 UNION ALL 
        SELECT 3010, 'Weighbridgeman - N/A', 'WAB02531',1,2 UNION ALL 
        SELECT 3011, 'Weigher - Explosives Manufacture', 'WAB02533',1,2 UNION ALL 
        SELECT 3012, 'Weigher - Food & Drink - General', 'WAB02534',1,2 UNION ALL 
        SELECT 3013, 'Weigher - Marshalling/Goods Yard - Railways', 'WAB02536',1,2 UNION ALL 
        SELECT 3014, 'Weigher - Minerals', 'WAB02535',1,2 UNION ALL 
        SELECT 3015, 'Weight Lifting', 'WAB02537',1,2 UNION ALL 
        SELECT 3016, 'Weights & Measures Inspector', 'WAB02538',0,1 UNION ALL 
        SELECT 3017, 'Welder', 'WAB02539',1,2 UNION ALL 
        SELECT 3018, 'Welder - 40'' up', 'WAB02541',0,1 UNION ALL 
        SELECT 3019, 'Welder - up to 40''', 'WAB02542',0,1 UNION ALL 
        SELECT 3020, 'Welder (no underwater work)', 'WAB02540',1,2 UNION ALL 
        SELECT 3021, 'Welder Cutter', 'WAB02543',1,2 UNION ALL 
        SELECT 3022, 'Welding Machine Operator - Ship Building, Ship Repair & Marine Engineering', 'WAB02544',1,2 UNION ALL 
        SELECT 3023, 'Welding Machine Operator - Welding & Flame Cutting', 'WAB02545',1,2 UNION ALL 
        SELECT 3024, 'Welfare Officer', 'WAB02546',0,1 UNION ALL 
        SELECT 3025, 'Welfare Worker', 'WAB02547',0,1 UNION ALL 
        SELECT 3026, 'Well Driller', 'WAB02548',1,2 UNION ALL 
        SELECT 3027, 'Well Logger', 'WAB02549',1,2 UNION ALL 
        SELECT 3028, 'Well Pusher', 'WAB02550',1,2 UNION ALL 
        SELECT 3029, 'Well Sinker', 'WAB02551',1,2 UNION ALL 
        SELECT 3030, 'Well Tester', 'WAB02552',1,2 UNION ALL 
        SELECT 3031, 'Wet Char Man', 'WAB02553',1,2 UNION ALL 
        SELECT 3032, 'Wet Cleaner', 'WAB02554',1,2 UNION ALL 
        SELECT 3033, 'Wharf Manager', 'WAB02555',1,2 UNION ALL 
        SELECT 3034, 'Wicker Worker', 'WAB02556',0,1 UNION ALL 
        SELECT 3035, 'Wig Dresser', 'WAB02557',1,2 UNION ALL 
        SELECT 3036, 'Wig Maker', 'WAB02558',0,1 UNION ALL 
        SELECT 3037, 'Winch Driver - Docks', 'WAB02560',1,2 UNION ALL 
        SELECT 3038, 'Winch Driver - Tunnelling', 'WAB02559',1,2 UNION ALL 
        SELECT 3039, 'Winch Operator', 'WAB02561',0,1 UNION ALL 
        SELECT 3040, 'Winchman', 'WAB02562',0,1 UNION ALL 
        SELECT 3041, 'Winding Engineman', 'WAB02563',1,2 UNION ALL 
        SELECT 3042, 'Window Cleaner (40'' up)', 'WAB02564',0,1 UNION ALL 
        SELECT 3043, 'Window Cleaner (up to 40'')', 'WAB02565',0,1 UNION ALL 
        SELECT 3044, 'Window Dresser', 'WAB02566',0,1 UNION ALL 
        SELECT 3045, 'Wire Winder', 'WAB02567',0,1 UNION ALL 
        SELECT 3046, 'Wireline Operator', 'WAB02568',1,2 UNION ALL 
        SELECT 3047, 'Wireworker (bench hand)', 'WAB02569',1,2 UNION ALL 
        SELECT 3048, 'Wood Carver', 'WAB02570',0,1 UNION ALL 
        SELECT 3049, 'Wood Veneer Worker', 'WAB02571',1,2 UNION ALL 
        SELECT 3050, 'Wood Worker - Aircraft/Aerospace', 'WAB02572',1,2 UNION ALL 
        SELECT 3051, 'Wood Worker - Woodworking Industry', 'WAB02573',1,2 UNION ALL 
        SELECT 3052, 'Woodcutter', 'WAB02574',0,1 UNION ALL 
        SELECT 3053, 'Woodman', 'WAB02575',0,1 UNION ALL 
        SELECT 3054, 'Work Study Consultant', 'WAB02576',1,2 UNION ALL 
        SELECT 3055, 'Working Partner ', 'WAC01966',0,1 UNION ALL 
        SELECT 3056, 'Works Clerk', 'WAB02577',1,2 UNION ALL 
        SELECT 3057, 'Works Manager', 'WAB02578',1,2 UNION ALL 
        SELECT 3058, 'Works Receptionist', 'WAB02579',1,2 UNION ALL 
        SELECT 3059, 'Workshop Cleaner', 'WAB02580',1,2 UNION ALL 
        SELECT 3060, 'Wrapping Machine Attendant', 'WAB02581',0,1 UNION ALL 
        SELECT 3061, 'Wrestling', 'WAB02582',1,2 UNION ALL 
        SELECT 3062, 'Writer', 'WAB02583',0,1 UNION ALL 
        SELECT 3063, 'Yachting', 'YAB02584',1,2 UNION ALL 
        SELECT 3064, 'Yard Cleaner', 'YAB02585',0,1 UNION ALL 
        SELECT 3065, 'Youth Hostel Assistant and Cook ', 'YAC01967',0,1 UNION ALL 
        SELECT 3066, 'Youth Hostel Manager (some manual work) ', 'YAC01968',0,1 UNION ALL 
        SELECT 3067, 'Youth Leader (Full time)', 'YAB02586',0,1 UNION ALL 
        SELECT 3068, 'Zoologist (no overseas field work)', 'ZAB02587',0,1 UNION ALL 
        SELECT 3069, 'Magazine Editor', 'MAD03204',0,1 UNION ALL 
        SELECT 3070, 'Engineer - admin and site visits only', 'EAD03115',0,1 UNION ALL 
        SELECT 3071, 'Manager - Sales', 'MAD03230',0,1 UNION ALL 
        SELECT 3072, 'Riveter', 'RAD03279',0,1 UNION ALL 
        SELECT 3073, 'Tester', 'TAD03321',0,1 UNION ALL 
        SELECT 3074, 'Holiday Representative', 'HAD03165',0,1 UNION ALL 
        SELECT 3075, 'Analyst - City', 'AAD03007',0,1 UNION ALL 
        SELECT 3076, 'Internal Auditor', 'IAD03169',0,1 UNION ALL 
        SELECT 3077, 'Analyst - Systems', 'AAD03009',0,1 UNION ALL 
        SELECT 3078, 'Book Seller', 'BAD03032',0,1 UNION ALL 
        SELECT 3079, 'Building Society worker', 'BAD03041',0,1 UNION ALL 
        SELECT 3080, 'NHS Manager', 'NAD03241',0,1 UNION ALL 
        SELECT 3081, 'Yacht & Boat Builder', 'YAD03363',0,1 UNION ALL 
        SELECT 3082, 'Director - Managing - other', 'DAD03378',0,1 UNION ALL 
        SELECT 3083, 'Gallery Assistant', 'GAD03150',0,1 UNION ALL 
        SELECT 3084, 'Miller', 'MAD03220',0,1 UNION ALL 
        SELECT 3085, 'Foster Parent', 'FAD03136',0,1 UNION ALL 
        SELECT 3086, 'Glazier', 'GAD03152',0,1 UNION ALL 
        SELECT 3087, 'Ovensman', 'OAD03250',0,1 UNION ALL 
        SELECT 3088, 'Zoo Keeper', 'ZAD03368',0,1 UNION ALL 
        SELECT 3089, 'Under Secretary', 'UAD03344',0,1 UNION ALL 
        SELECT 3090, 'Amusement Park Worker', 'AAD03005',0,1 UNION ALL 
        SELECT 3091, 'Embassy Employee', 'EAD03113',0,1 UNION ALL 
        SELECT 3092, 'Broker - Other', 'BAD03040',0,1 UNION ALL 
        SELECT 3093, 'Driver - delivery', 'DAD03100',0,1 UNION ALL 
        SELECT 3094, 'Hotel Concierge', 'HAD03166',0,1 UNION ALL 
        SELECT 3095, 'Box Office Clerk', 'BAD03034',0,1 UNION ALL 
        SELECT 3096, 'Café Worker', 'CAD03046',0,1 UNION ALL 
        SELECT 3097, 'Sound Mixer', 'SAD03297',0,1 UNION ALL 
        SELECT 3098, 'Linesman', 'LAD03192',0,1 UNION ALL 
        SELECT 3099, 'Maintenance Technician', 'MAD03216',0,1 UNION ALL 
        SELECT 3100, 'Racetrack Steward', 'RAD03278',0,1 UNION ALL 
        SELECT 3101, 'Analyst - Investment', 'AAD03008',0,1 UNION ALL 
        SELECT 3102, 'Administrator - office', 'AAD03003',0,1 UNION ALL 
        SELECT 3103, 'Machinist', 'MAD03201',0,1 UNION ALL 
        SELECT 3104, 'Shotfirer', 'SAD03292',0,1 UNION ALL 
        SELECT 3105, 'Supermarket Manager', 'SAD03282',0,1 UNION ALL 
        SELECT 3106, 'Telesales Manager', 'TAD03324',0,1 UNION ALL 
        SELECT 3107, 'Managing Director - admin/office based only', 'MAD03232',0,1 UNION ALL 
        SELECT 3108, 'Civil Servant', 'CAD03067',0,1 UNION ALL 
        SELECT 3109, 'Cleaner - commercial premises', 'CAD03068',0,1 UNION ALL 
        SELECT 3110, 'Spray Painter', 'SAD03298',0,1 UNION ALL 
        SELECT 3111, 'Market or Street Trader', 'MAD03226',0,1 UNION ALL 
        SELECT 3112, 'Tanker Filler', 'TAD03330',0,1 UNION ALL 
        SELECT 3113, 'Pipe Jointer', 'PAD03264',0,1 UNION ALL 
        SELECT 3114, 'Acrobat', 'AAD03002',0,1 UNION ALL 
        SELECT 3115, 'Bingo Hall Manager', 'BAD03030',0,1 UNION ALL 
        SELECT 3116, 'Human Resources Assistant', 'HAD03161',0,1 UNION ALL 
        SELECT 3117, 'Medical Receptionist', 'MAD03214',0,1 UNION ALL 
        SELECT 3118, 'Systems Programmer', 'SAD03311',0,1 UNION ALL 
        SELECT 3119, 'Crop Sprayer - pilot', 'CAD03078',0,1 UNION ALL 
        SELECT 3120, 'Kebab van vendor', 'KAD03182',0,1 UNION ALL 
        SELECT 3121, 'Electrician UK based - industrial', 'EAD03112',0,1 UNION ALL 
        SELECT 3122, 'Life Coach', 'LAD03190',0,1 UNION ALL 
        SELECT 3123, 'Caravan Site Staff', 'CAD03053',0,1 UNION ALL 
        SELECT 3124, 'Flight Attendant', 'FAD03135',0,1 UNION ALL 
        SELECT 3125, 'Justice of the Peace', 'JAD03181',0,1 UNION ALL 
        SELECT 3126, 'Managing Director - Retail', 'MAD03236',0,1 UNION ALL 
        SELECT 3127, 'Mixer - processing', 'MAD03200',0,1 UNION ALL 
        SELECT 3128, 'Independent Financial Adviser - IFA', 'IAD03171',0,1 UNION ALL 
        SELECT 3129, 'Community Development Worker', 'CAD03071',0,1 UNION ALL 
        SELECT 3130, 'Planning Engineer', 'PAD03253',0,1 UNION ALL 
        SELECT 3131, 'Customer Service Staff', 'CAD03079',0,1 UNION ALL 
        SELECT 3132, 'Siloman', 'SAD03287',0,1 UNION ALL 
        SELECT 3133, 'Politician', 'PAD03260',0,1 UNION ALL 
        SELECT 3134, 'Armed Forces - Army - SAS', 'AAD03014',0,1 UNION ALL 
        SELECT 3135, 'Examiner - process', 'EAD03124',0,1 UNION ALL 
        SELECT 3136, 'Managing Director - heavy manual duties', 'MAD03233',0,1 UNION ALL 
        SELECT 3137, 'Cameraman Outside Work', 'CAD03049',0,1 UNION ALL 
        SELECT 3138, 'Relationship Manager', 'RAD03277',0,1 UNION ALL 
        SELECT 3139, 'Umpire', 'UAD03343',0,1 UNION ALL 
        SELECT 3140, 'Greaser', 'GAD03154',0,1 UNION ALL 
        SELECT 3141, 'Buyer - stocks and shares', 'BAD03044',0,1 UNION ALL 
        SELECT 3142, 'Data Controller', 'DAD03084',0,1 UNION ALL 
        SELECT 3143, 'Hammerman', 'HAD03164',0,1 UNION ALL 
        SELECT 3144, 'Washer', 'WAD03352',0,1 UNION ALL 
        SELECT 3145, 'Industrial Chemist', 'IAD03173',0,1 UNION ALL 
        SELECT 3146, 'Driller - onshore', 'DAD03098',0,1 UNION ALL 
        SELECT 3147, 'Engraver', 'EAD03122',0,1 UNION ALL 
        SELECT 3148, 'Bailiff', 'BAD03026',0,1 UNION ALL 
        SELECT 3149, 'Armed Forces - Army - no bomb disposal', 'AAD03013',0,1 UNION ALL 
        SELECT 3150, 'Call Centre Manager', 'CAD03047',0,1 UNION ALL 
        SELECT 3151, 'IT Manager - admin only', 'IAD03172',0,1 UNION ALL 
        SELECT 3152, 'Driver - industrial plant', 'DAD03102',0,1 UNION ALL 
        SELECT 3153, 'Packer', 'PAD03261',0,1 UNION ALL 
        SELECT 3154, 'Armed Forces - RAF - aircrew', 'AAD03389',0,2 UNION ALL 
        SELECT 3155, 'Driller - offshore', 'DAD03097',0,1 UNION ALL 
        SELECT 3156, 'Fabricator - welder/fitter', 'FAD03127',0,1 UNION ALL 
        SELECT 3157, 'Playschool/Group Worker/Leader', 'PAD03252',0,1 UNION ALL 
        SELECT 3158, 'Mould Maker', 'MAD03229',0,1 UNION ALL 
        SELECT 3159, 'Armed Forces - RAF - no flying', 'AAD03020',0,1 UNION ALL 
        SELECT 3160, 'Caulker', 'CAD03054',0,1 UNION ALL 
        SELECT 3161, 'Bin man', 'BAD03029',0,1 UNION ALL 
        SELECT 3162, 'Key Cutter', 'KAD03183',0,1 UNION ALL 
        SELECT 3163, 'Nurse - Sister', 'NAD03245',0,1 UNION ALL 
        SELECT 3164, 'Station Manager', 'SAD03284',0,1 UNION ALL 
        SELECT 3165, 'Engineer - sales', 'EAD03120',0,1 UNION ALL 
        SELECT 3166, 'Zoo Curator', 'ZAD03370',0,1 UNION ALL 
        SELECT 3167, 'Immigration Officer - admin only', 'IAD03175',0,1 UNION ALL 
        SELECT 3168, 'Engineer - light manual', 'EAD03118',0,1 UNION ALL 
        SELECT 3169, 'Flight Operations Manager', 'FAD03138',0,1 UNION ALL 
        SELECT 3170, 'Glass Worker', 'GAD03151',0,1 UNION ALL 
        SELECT 3171, 'Nursery School Assistant', 'NAD03246',0,1 UNION ALL 
        SELECT 3172, 'Trainer - education/office based', 'TAD03326',0,1 UNION ALL 
        SELECT 3173, 'Armed Forces - Army - aircrew', 'AAD03011',0,1 UNION ALL 
        SELECT 3174, 'Child Support Agency (CSA) worker', 'CAD03062',0,1 UNION ALL 
        SELECT 3175, 'Managing Director - Other', 'MAD03235',0,1 UNION ALL 
        SELECT 3176, 'Foreman - no manual', 'FAD03141',0,1 UNION ALL 
        SELECT 3177, 'Driver - construction', 'DAD03099',0,1 UNION ALL 
        SELECT 3178, 'IT Programmer', 'IAD03174',0,1 UNION ALL 
        SELECT 3179, 'Zoo Keeper - small zoos', 'ZAD03371',0,1 UNION ALL 
        SELECT 3180, 'Cutting Machine Operator', 'CAD03082',0,1 UNION ALL 
        SELECT 3181, 'Motorman', 'MAD03227',0,1 UNION ALL 
        SELECT 3182, 'Producer - TV/film/theatre', 'PAD03257',0,1 UNION ALL 
        SELECT 3183, 'Zoo Keeper - large zoos', 'ZAD03369',0,1 UNION ALL 
        SELECT 3184, 'Ecological Consultant UK', 'EAD03105',0,1 UNION ALL 
        SELECT 3185, 'Foreman - heavy manual', 'FAD03139',0,1 UNION ALL 
        SELECT 3186, 'Water Treatment Plant Operator', 'WAD03354',0,1 UNION ALL 
        SELECT 3187, 'Stage Manager', 'SAD03309',0,1 UNION ALL 
        SELECT 3188, 'Blaster - quarry', 'BAD03031',0,1 UNION ALL 
        SELECT 3189, 'Chemist - retail', 'CAD03061',0,1 UNION ALL 
        SELECT 3190, 'Financial Planner/Paraplanner', 'FAD03131',0,1 UNION ALL 
        SELECT 3191, 'Drier', 'DAD03096',0,1 UNION ALL 
        SELECT 3192, 'Quality Control Engineer', 'QAD03273',0,1 UNION ALL 
        SELECT 3193, 'Banksman', 'BAD03027',0,1 UNION ALL 
        SELECT 3194, 'Galley Hand', 'GAD03155',0,1 UNION ALL 
        SELECT 3195, 'Armed Forces - Army - bomb disposal', 'AAD03012',0,1 UNION ALL 
        SELECT 3196, 'Foreman - other', 'FAD03143',0,1 UNION ALL 
        SELECT 3197, 'Groundworker', 'GAD03147',0,1 UNION ALL 
        SELECT 3198, 'Hardware Shop Retailer', 'HAD03157',0,1 UNION ALL 
        SELECT 3199, 'Education Assistant', 'EAD03108',0,1 UNION ALL 
        SELECT 3200, 'Sales Support Administrator', 'SAD03319',0,1 UNION ALL 
        SELECT 3201, 'Chemical engineer - UK', 'CAD03059',0,1 UNION ALL 
        SELECT 3202, 'Analyst- Other', 'AAD03010',0,1 UNION ALL 
        SELECT 3203, 'Manager - light manual work', 'MAD03217',0,1 UNION ALL 
        SELECT 3204, 'Meter Fixer/Tester', 'MAD03215',0,1 UNION ALL 
        SELECT 3205, 'Yarn Worker', 'YAD03364',0,1 UNION ALL 
        SELECT 3206, 'Medical Secretary', 'MAD03218',0,1 UNION ALL 
        SELECT 3207, 'Rollerman', 'RAD03276',0,1 UNION ALL 
        SELECT 3208, 'Sound Recordist', 'SAD03303',0,1 UNION ALL 
        SELECT 3209, 'Labourer', 'LAD03184',0,1 UNION ALL 
        SELECT 3210, 'Recruitment Consultant', 'RAD03275',0,1 UNION ALL 
        SELECT 3211, 'Road Worker/Labourer', 'RAD03280',0,1 UNION ALL 
        SELECT 3212, 'Armed Forces - Navy - no diving', 'AAD03018',0,1 UNION ALL 
        SELECT 3213, 'Fast Food Restaurant Assistant', 'FAD03130',0,1 UNION ALL 
        SELECT 3214, 'Managing Director - Selling', 'MAD03238',0,1 UNION ALL 
        SELECT 3215, 'Weighbridgeman', 'WAD03349',0,1 UNION ALL 
        SELECT 3216, 'Car Rental Company Worker', 'CAD03051',0,1 UNION ALL 
        SELECT 3217, 'Lathe Operator', 'LAD03191',0,1 UNION ALL 
        SELECT 3218, 'Vintner', 'VAD03347',0,1 UNION ALL 
        SELECT 3219, 'Manager - other', 'MAD03225',0,1 UNION ALL 
        SELECT 3220, 'Loader Operator', 'LAD03194',0,1 UNION ALL 
        SELECT 3221, 'Takeaway Food Shop Manager - no serving', 'TAD03341',0,1 UNION ALL 
        SELECT 3222, 'Sales Assistant - retail', 'SAD03306',0,1 UNION ALL 
        SELECT 3223, 'Magazine Writer', 'MAD03211',0,1 UNION ALL 
        SELECT 3224, 'Milliner', 'MAD03223',0,1 UNION ALL 
        SELECT 3225, 'Drainage Layer/Clearer', 'DAD03095',0,1 UNION ALL 
        SELECT 3226, 'Hydro-Extractor Operator', 'HAD03160',0,1 UNION ALL 
        SELECT 3227, 'Cameraman War or Disaster reporting', 'CAD03050',0,1 UNION ALL 
        SELECT 3228, 'Manhole Maker', 'MAD03239',0,1 UNION ALL 
        SELECT 3229, 'Moulder', 'MAD03231',0,1 UNION ALL 
        SELECT 3230, 'Grinder', 'GAD03144',0,1 UNION ALL 
        SELECT 3231, 'Technician - heavy manual', 'TAD03333',0,1 UNION ALL 
        SELECT 3232, 'Conveyancer', 'CAD03073',0,1 UNION ALL 
        SELECT 3233, 'Director - Sales - some selling', 'DAD03386',0,1 UNION ALL 
        SELECT 3234, 'Human Resources Advisor', 'HAD03158',0,1 UNION ALL 
        SELECT 3235, 'Oiler and Greaser', 'OAD03248',0,1 UNION ALL 
        SELECT 3236, 'Crane Operator', 'CAD03075',0,1 UNION ALL 
        SELECT 3237, 'Engineer - heavy manual', 'EAD03117',0,1 UNION ALL 
        SELECT 3238, 'Sound Balancer', 'SAD03295',0,1 UNION ALL 
        SELECT 3239, 'Sifter - quarry', 'SAD03318',0,1 UNION ALL 
        SELECT 3240, 'Air Compressor Operator', 'AAD03004',0,1 UNION ALL 
        SELECT 3241, 'Engineer - works at heights over 40 ft', 'EAD03121',0,1 UNION ALL 
        SELECT 3242, 'P E Teacher', 'PAD03258',0,1 UNION ALL 
        SELECT 3243, 'Stone Breaker', 'SAD03290',0,1 UNION ALL 
        SELECT 3244, 'Armed Forces - Navy - aircrew', 'AAD03017',0,1 UNION ALL 
        SELECT 3245, 'Editor', 'EAD03106',0,1 UNION ALL 
        SELECT 3246, 'Human Resources Analyst', 'HAD03159',0,1 UNION ALL 
        SELECT 3247, 'Tram Driver/Conductor', 'TAD03329',0,1 UNION ALL 
        SELECT 3248, 'Photocopier Engineer', 'PAD03383',0,1 UNION ALL 
        SELECT 3249, 'Pipe Fitter', 'PAD03263',0,1 UNION ALL 
        SELECT 3250, 'Technician - admin and site visits', 'TAD03328',0,1 UNION ALL 
        SELECT 3251, 'Water Meter Reader/Fitter/Tester', 'WAD03351',0,1 UNION ALL 
        SELECT 3252, 'Safety Inspector', 'SAD03299',0,1 UNION ALL 
        SELECT 3253, 'Circus Manager', 'CAD03065',0,1 UNION ALL 
        SELECT 3254, 'Crane Slinger', 'CAD03076',0,1 UNION ALL 
        SELECT 3255, 'Cemetery Worker', 'CAD03057',0,1 UNION ALL 
        SELECT 3256, 'Director - Musical', 'DAD03379',0,1 UNION ALL 
        SELECT 3257, 'Director - Sales - management only', 'DAD03381',0,1 UNION ALL 
        SELECT 3258, 'Sales Executive', 'SAD03312',0,1 UNION ALL 
        SELECT 3259, 'Insulator - asbestos work inc', 'IAD03167',0,1 UNION ALL 
        SELECT 3260, 'Trade Union Official (full time)', 'TAD03334',0,1 UNION ALL 
        SELECT 3261, 'Dental Receptionist', 'DAD03088',0,1 UNION ALL 
        SELECT 3262, 'Broker - Money/investments', 'BAD03039',0,1 UNION ALL 
        SELECT 3263, 'Asbestos Inspector', 'AAD03021',0,1 UNION ALL 
        SELECT 3264, 'Conveyer Operator', 'CAD03074',0,1 UNION ALL 
        SELECT 3265, 'Stone/Slate Polisher', 'SAD03293',0,1 UNION ALL 
        SELECT 3266, 'Marriage Guidance Counsellor', 'MAD03196',0,1 UNION ALL 
        SELECT 3267, 'Engineer - admin only', 'EAD03116',0,1 UNION ALL 
        SELECT 3268, 'Manager - Retail', 'MAD03228',0,1 UNION ALL 
        SELECT 3269, 'Baggage Manager', 'BAD03025',0,1 UNION ALL 
        SELECT 3270, 'Test Engineer', 'TAD03336',0,1 UNION ALL 
        SELECT 3271, 'Alternative Therapist/Complimentary Therapist', 'AAD03392',0,1 UNION ALL 
        SELECT 3272, 'Project Manager/Programme Manager', 'PAD03266',0,1 UNION ALL 
        SELECT 3273, 'Accounts Administrator/Assistant', 'AAD03001',0,1 UNION ALL 
        SELECT 3274, 'Marine Biologist', 'MAD03197',0,1 UNION ALL 
        SELECT 3275, 'Night Watchman', 'NAD03242',0,1 UNION ALL 
        SELECT 3276, 'Sales Manager', 'SAD03317',0,1 UNION ALL 
        SELECT 3277, 'Turf Cutter/Layer', 'TAD03337',0,1 UNION ALL 
        SELECT 3278, 'Editorial Assistant', 'EAD03107',0,1 UNION ALL 
        SELECT 3279, 'Hoist Operator', 'HAD03163',0,1 UNION ALL 
        SELECT 3280, 'Process worker', 'PAD03256',0,1 UNION ALL 
        SELECT 3281, 'Weaver', 'WAD03357',0,1 UNION ALL 
        SELECT 3282, 'Finisher - toys and textiles', 'FAD03132',0,1 UNION ALL 
        SELECT 3283, 'Director - Company - other', 'DAD03376',0,1 UNION ALL 
        SELECT 3284, 'Tanker Driver', 'TAD03327',0,1 UNION ALL 
        SELECT 3285, 'GP - general practitioner - Doctor', 'GAD03146',0,1 UNION ALL 
        SELECT 3286, 'Saw Doctor or Repairer or Sharpener', 'SAD03296',0,1 UNION ALL 
        SELECT 3287, 'School Assistant', 'SAD03313',0,1 UNION ALL 
        SELECT 3288, 'Broker - Insurance Non IFA', 'BAD03038',0,1 UNION ALL 
        SELECT 3289, 'Doorman', 'DAD03094',0,1 UNION ALL 
        SELECT 3290, 'Driver - HGV', 'DAD03101',0,1 UNION ALL 
        SELECT 3291, 'Vacuum Plant Operator', 'VAD03348',0,1 UNION ALL 
        SELECT 3292, 'Glamour Model', 'GAD03145',0,1 UNION ALL 
        SELECT 3293, 'Mechanic', 'MAD03205',0,1 UNION ALL 
        SELECT 3294, 'Charity Worker - UK Work', 'CAD03390',0,1 UNION ALL 
        SELECT 3295, 'Manager - admin only', 'MAD03208',0,1 UNION ALL 
        SELECT 3296, 'Sieve Operator - quarry', 'SAD03308',0,1 UNION ALL 
        SELECT 3297, 'Sifter - food', 'SAD03316',0,1 UNION ALL 
        SELECT 3298, 'Maitre d''Hotel', 'MAD03221',0,1 UNION ALL 
        SELECT 3299, 'Road Patrol Man', 'RAD03384',0,1 UNION ALL 
        SELECT 3300, 'Waste Disposal/Recycling Operative', 'WAD03353',0,1 UNION ALL 
        SELECT 3301, 'Design cutter', 'DAD03091',0,1 UNION ALL 
        SELECT 3302, 'Director - Company - admin only', 'DAD03375',0,1 UNION ALL 
        SELECT 3303, 'Valveman', 'VAD03345',0,1 UNION ALL 
        SELECT 3304, 'Coach - Sports', 'CAD03070',0,1 UNION ALL 
        SELECT 3305, 'Sheet Metal Worker', 'SAD03294',0,1 UNION ALL 
        SELECT 3306, 'Nail Technician/Beautician', 'NAD03243',0,1 UNION ALL 
        SELECT 3307, 'Guard - railway', 'GAD03148',0,1 UNION ALL 
        SELECT 3308, 'Dealer - money/shares/investment', 'DAD03086',0,1 UNION ALL 
        SELECT 3309, 'Scaffolder Offshore Oil or Gas', 'SAD03291',0,1 UNION ALL 
        SELECT 3310, 'Fish and chip shop worker', 'FAD03134',0,1 UNION ALL 
        SELECT 3311, 'Maintenance Fitter', 'MAD03198',0,1 UNION ALL 
        SELECT 3312, 'Au Pair', 'AAD03022',0,1 UNION ALL 
        SELECT 3313, 'Employment Agency worker', 'EAD03114',0,1 UNION ALL 
        SELECT 3314, 'Wood Worker', 'WAD03350',0,1 UNION ALL 
        SELECT 3315, 'Charity Worker - Overseas Work', 'CAD03391',0,1 UNION ALL 
        SELECT 3316, 'Customs and Excise', 'CAD03080',0,1 UNION ALL 
        SELECT 3317, 'Mobile Crane Driver', 'MAD03203',0,1 UNION ALL 
        SELECT 3318, 'Lighterman', 'LAD03188',0,1 UNION ALL 
        SELECT 3319, 'Machine Operator - processing', 'MAD03224',0,1 UNION ALL 
        SELECT 3320, 'Control Room Operator', 'CAD03072',0,1 UNION ALL 
        SELECT 3321, 'Zoological Researcher', 'ZAD03373',0,1 UNION ALL 
        SELECT 3322, 'Manager - Offshore', 'MAD03222',0,1 UNION ALL 
        SELECT 3323, 'Foreman - offshore', 'FAD03142',0,1 UNION ALL 
        SELECT 3324, 'Plant Operator', 'PAD03254',0,1 UNION ALL 
        SELECT 3325, 'Manager - heavy manual work', 'MAD03212',0,1 UNION ALL 
        SELECT 3326, 'Magazine Illustrator', 'MAD03207',0,1 UNION ALL 
        SELECT 3327, 'Managing Director - Sales Management', 'MAD03237',0,1 UNION ALL 
        SELECT 3328, 'Mineralogist', 'MAD03199',0,1 UNION ALL 
        SELECT 3329, 'Yoga Teacher', 'YAD03366',0,1 UNION ALL 
        SELECT 3330, 'Website/Webpage Designer', 'WAD03359',0,1 UNION ALL 
        SELECT 3331, 'Windscreen Fitter/Repairer', 'WAD03360',0,1 UNION ALL 
        SELECT 3332, 'Auxiliary Nurse', 'AAD03023',0,1 UNION ALL 
        SELECT 3333, 'Pipe Layer', 'PAD03268',0,1 UNION ALL 
        SELECT 3334, 'Press Operator - processing', 'PAD03255',0,1 UNION ALL 
        SELECT 3335, 'Sewing Machinist', 'SAD03315',0,1 UNION ALL 
        SELECT 3336, 'Steriliser', 'SAD03289',0,1 UNION ALL 
        SELECT 3337, 'Cleaner - industrial', 'CAD03069',0,1 UNION ALL 
        SELECT 3338, 'Dinner Lady', 'DAD03093',0,1 UNION ALL 
        SELECT 3339, 'Inspector (not police)', 'IAD03178',0,1 UNION ALL 
        SELECT 3340, 'Salary Administrator', 'SAD03305',0,1 UNION ALL 
        SELECT 3341, 'Demonstrator', 'DAD03087',0,1 UNION ALL 
        SELECT 3342, 'Station Officer - Fire', 'SAD03288',0,1 UNION ALL 
        SELECT 3343, 'Director - Managing - admin only', 'DAD03377',0,1 UNION ALL 
        SELECT 3344, 'Electrician - offshore', 'EAD03110',0,1 UNION ALL 
        SELECT 3345, 'Facilities Assistant', 'FAD03128',0,1 UNION ALL 
        SELECT 3346, 'Sieve Operator - food', 'SAD03302',0,1 UNION ALL 
        SELECT 3347, 'Fish and chip shop owner', 'FAD03133',0,1 UNION ALL 
        SELECT 3348, 'Exhaust Fitter', 'EAD03125',0,1 UNION ALL 
        SELECT 3349, 'Breakdown Recovery Man', 'BAD03035',0,1 UNION ALL 
        SELECT 3350, 'Loader', 'LAD03193',0,1 UNION ALL 
        SELECT 3351, 'Oceanographer', 'OAD03247',0,1 UNION ALL 
        SELECT 3352, 'Charity Worker - Admin Only', 'CAD03058',0,1 UNION ALL 
        SELECT 3353, 'Other - Occupation not listed', 'OAD03382',0,1 UNION ALL 
        SELECT 3354, 'Armed Forces - Navy - diving', 'AAD3390',0,2 UNION ALL 
        SELECT 3355, 'Technician - admin only', 'TAD03331',0,1 UNION ALL 
        SELECT 3356, 'X-ray Technician - Radiologist', 'XAD03362',0,1 UNION ALL 
        SELECT 3357, 'Gunsmith', 'GAD03153',0,1 UNION ALL 
        SELECT 3358, 'Managing Director - light manual duties', 'MAD03234',0,1 UNION ALL 
        SELECT 3359, 'Mechanical Engineer', 'MAD03213',0,1 UNION ALL 
        SELECT 3360, 'Youth Worker (full time)', 'YAD03367',0,1 UNION ALL 
        SELECT 3361, 'Director - Other', 'DAD03380',0,1 UNION ALL 
        SELECT 3362, 'Set Designer', 'SAD03301',0,1 UNION ALL 
        SELECT 3363, 'Abrasive Wheels Worker', 'AAD03000',0,1 UNION ALL 
        SELECT 3364, 'CC TV Installer/Maintenance - 40 ft and over', 'CAD03055',0,1 UNION ALL 
        SELECT 3365, 'Cutter', 'CAD03081',0,1 UNION ALL 
        SELECT 3366, 'Quality Control Inspector', 'QAD03274',0,1 UNION ALL 
        SELECT 3367, 'Tailor', 'TAD03338',0,1 UNION ALL 
        SELECT 3368, 'Shotblaster', 'SAD03286',0,1 UNION ALL 
        SELECT 3369, 'Electrical Engineer', 'EAD03109',0,1 UNION ALL 
        SELECT 3370, 'Tanner', 'TAD03332',0,1 UNION ALL 
        SELECT 3371, 'Armed Forces - Full time reservist - special duties', 'AAD03016',0,1 UNION ALL 
        SELECT 3372, 'Wages Clerk', 'WAD03356',0,1 UNION ALL 
        SELECT 3373, 'Yard Assistant', 'YAD03365',0,1 UNION ALL 
        SELECT 3374, 'Cinema Projectionist', 'CAD03064',0,1 UNION ALL 
        SELECT 3375, 'Maintenance Manager', 'MAD03202',0,1 UNION ALL 
        SELECT 3376, 'Structural Engineer', 'SAD03310',0,1 UNION ALL 
        SELECT 3377, 'Outdoor Pursuits Centre Instructor', 'OAD03249',0,1 UNION ALL 
        SELECT 3378, 'Electrician UK based - domestic', 'EAD03111',0,1 UNION ALL 
        SELECT 3379, 'Nature Reserve Worker/Warden', 'NAD03240',0,1 UNION ALL 
        SELECT 3380, 'Takeaway Food Shop Assistant', 'TAD03340',0,1 UNION ALL 
        SELECT 3381, 'Meter Collector', 'MAD03210',0,1 UNION ALL 
        SELECT 3382, 'Department Store worker', 'DAD03090',0,1 UNION ALL 
        SELECT 3383, 'Guard - security', 'GAD03149',0,1 UNION ALL 
        SELECT 3384, 'Insulator - no asbestos work', 'IAD03168',0,1 UNION ALL 
        SELECT 3385, 'Meter Reader', 'MAD03219',0,1 UNION ALL 
        SELECT 3386, 'Zoologist', 'ZAD03374',0,1 UNION ALL 
        SELECT 3387, 'Storeman', 'SAD03304',0,1 UNION ALL 
        SELECT 3388, 'Data Inputter', 'DAD03085',0,1 UNION ALL 
        SELECT 3389, 'Crop Sprayer - on ground', 'CAD03077',0,1 UNION ALL 
        SELECT 3390, 'Panel Beater', 'PAD03272',0,1 UNION ALL 
        SELECT 3391, 'Personal Assistant (PA)', 'PAD03259',0,1 UNION ALL 
        SELECT 3392, 'Telesales Caller', 'TAD03323',0,1 UNION ALL 
        SELECT 3393, 'Armed Forces - Navy - SBS', 'AAD03019',0,1 UNION ALL 
        SELECT 3394, 'Bunker Control man', 'BAD03042',0,1 UNION ALL 
        SELECT 3395, 'Call Centre Worker', 'CAD03048',0,1 UNION ALL 
        SELECT 3396, 'Instructor - aviation, diving, etc', 'IAD03179',0,1 UNION ALL 
        SELECT 3397, 'Zoological Research Associate', 'ZAD03372',0,1 UNION ALL 
        SELECT 3398, 'Fashion Stylist', 'FAD03129',0,1 UNION ALL 
        SELECT 3399, 'Musician - Professional', 'MAD03206',0,1 UNION ALL 
        SELECT 3400, 'Nuclear Plant Attendant', 'NAD03244',0,1 UNION ALL 
        SELECT 3401, 'Radiotherapist', 'RAD03281',0,1 UNION ALL 
        SELECT 3402, 'Ecological Consultant Outside UK', 'EAD03104',0,1 UNION ALL 
        SELECT 3403, 'Box Office Cashier', 'BAD03033',0,1 UNION ALL 
        SELECT 3404, 'Civil Engineer', 'CAD03066',0,1 UNION ALL 
        SELECT 3405, 'Legal Secretary', 'LAD03187',0,1 UNION ALL 
        SELECT 3406, 'Foreman - light manual', 'FAD03140',0,1 UNION ALL 
        SELECT 3407, 'Leather worker', 'LAD03195',0,1 UNION ALL 
        SELECT 3408, 'Secretary', 'SAD03307',0,1 UNION ALL 
        SELECT 3409, 'Diamond workers', 'DAD03092',0,1 UNION ALL 
        SELECT 3410, 'Instructor - no special risks', 'IAD03180',0,1 UNION ALL 
        SELECT 3411, 'Landlord (Property -inc manual work)', 'LAD03189',0,1 UNION ALL 
        SELECT 3412, 'Pumpman', 'PAD03267',0,1 UNION ALL 
        SELECT 3413, 'Immigration Officer - otherwise', 'IAD03177',0,1 UNION ALL 
        SELECT 3414, 'Chemist - industrial', 'CAD03060',0,1 UNION ALL 
        SELECT 3415, 'Caravan Site Manager', 'CAD03052',0,1 UNION ALL 
        SELECT 3416, 'Security Manager', 'SAD03285',0,1 UNION ALL 
        SELECT 3417, 'Technician - light manual', 'TAD03335',0,1 UNION ALL 
        SELECT 3418, 'Analyst - Business', 'AAD03006',0,1 UNION ALL 
        SELECT 3419, 'Fabric Designer', 'FAD03126',0,1 UNION ALL 
        SELECT 3420, 'IT Technician', 'IAD03176',0,1 UNION ALL 
        SELECT 3421, 'Tattoo Artist', 'TAD03339',0,1 UNION ALL 
        SELECT 3422, 'Hod carrier - construction', 'HAD03162',0,1 UNION ALL 
        SELECT 3423, 'CC TV Installer/Maintenance - under 40 ft', 'CAD03056',0,1 UNION ALL 
        SELECT 3424, 'Furnace Operator - Other', 'FAD03137',0,1 UNION ALL 
        SELECT 3425, 'Mechanic - Oil Rig', 'MAD03209',0,1 UNION ALL 
        SELECT 3426, 'Armed Forces - Full time reservist - no special duties', 'AAD03015',0,1 UNION ALL 
        SELECT 3427, 'Briner', 'BAD03036',0,1 UNION ALL 
        SELECT 3428, 'Sailing Instructor', 'SAD03300',0,1 UNION ALL 
        SELECT 3429, 'Off-Licence Employee', 'OAD03251',0,1 UNION ALL 
        SELECT 3430, 'Venture Capitalist', 'VAD03346',0,1 UNION ALL 
        SELECT 3431, 'University lecturer', 'UAD03342',0,1 UNION ALL 
        SELECT 3432, 'Teacher', 'TAD03325',0,1 UNION ALL 
        SELECT 3433, 'Window/Conservatory Fitter', 'WAD03358',0,1 UNION ALL 
        SELECT 3434, 'Department Store Manager', 'DAD03089',0,1 UNION ALL 
        SELECT 3435, 'IT Analyst', 'IAD03170',0,1 UNION ALL 
        SELECT 3436, 'Security Consultant', 'SAD03314',0,1 UNION ALL 
        SELECT 3437, 'Chip Shop Worker', 'CAD03063',0,1 UNION ALL 
        SELECT 3438, 'Driver - PSV', 'DAD03103',0,1 UNION ALL 
        SELECT 3439, 'Sandblaster', 'SAD03283',0,1 UNION ALL 
        SELECT 3440, 'Legal Practice Manager', 'LAD03185',0,1 UNION ALL 
        SELECT 3441, 'Broker - Insurance IFA', 'BAD03037',0,1 UNION ALL 
        SELECT 3442, 'Gantry Crane Driver', 'GAD03156',0,1 UNION ALL 
        SELECT 3443, 'Zoo Director', 'ZAD03385',0,2 UNION ALL 
        SELECT 3444, 'Tyre/Exhaust Fitter', 'TAD03322',0,2 UNION ALL 
        SELECT 3445, 'Property Developer(no manual work)', 'PAD03271',0,2 UNION ALL 
        SELECT 3446, 'Waterworks Manager', 'WAD03355',0,2 UNION ALL 
        SELECT 3447, 'Human Resources Officer', 'HAD03387',0,2 UNION ALL 
        SELECT 3448, 'Broker - Oil', 'BAD03388',0,2 UNION ALL 
        SELECT 3449, 'Human Resources Consultant', 'HAD03386',0,2 
 
        SET IDENTITY_INSERT TRefOccupation OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'AB7CC541-186E-483F-B82B-958A89700FCD', 
         'Initial load (3449 total rows, file 1 of 1) for table TRefOccupation',
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
-- #Rows Exported: 3449
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
