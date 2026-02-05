-- SEE NOTE below this should have been policymanagement
USE [crm];

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT 
    @ScriptGUID = '385b0810-a5c2-4137-939d-c1f104489084',
    @Comments = 'AIOENV-107 Reference Data for US - Additional Providers'

IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
    RETURN;

-----------------------------------------------------------------------------------------------
-- Summary: Add additional US providers

-- Expected records added: 3354 rows
-- IMPORTANT NOTE: This script was originally implemented as CRM refdata. This is wrong!!!!
--                 It needs to be run a policymanagement refdata because there are existing
--                 Product provider ref data scri[pts with hard-coded Ids that need to be inserted
--                 first!!!!
--                 If you copy this scrip to add more providers, please change USE statement to 
--                 to policymanagment!!!     
-----------------------------------------------------------------------------------------------

SET NOCOUNT ON
SET XACT_ABORT ON

DECLARE @starttrancount int
       ,@StampAction char(1) = 'C'
       ,@StampDateTime AS DATETIME = GETUTCDATE()
       ,@StampUser AS VARCHAR(255) = '0'
       ,@RegionCode varchar(2) = 'US'	   

BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT

    IF @starttrancount = 0
        BEGIN TRANSACTION

        IF OBJECT_ID('tempdb..#TCRMContact') IS NOT NULL
        DROP TABLE #TCRMContact
        CREATE TABLE #TCRMContact(IndClientId INT, CorporateId INT, CorporateName varchar(250))

        -- TCorporate
        INSERT INTO TCorporate (IndClientId, CorporateName, RefCorporateTypeId) 
        OUTPUT inserted.IndClientId, inserted.CorporateId, inserted.CorporateName
        INTO #TCRMContact
		VALUES
		(0, '1st Security Bank of Washington', 1),
		(0, '1st Source Bank', 1),
		(0, 'Academy Bank', 1),
		(0, 'ACNB Bank', 1),
		(0, 'Alerus Financial', 1),
		(0, 'Allegiance Bank', 1),
		(0, 'Ally Bank', 1),
		(0, 'Alpine Bank', 1),
		(0, 'Altabank', 1),
		(0, 'Amalgamated Bank', 1),
		(0, 'Amarillo National Bank', 1),
		(0, 'Amboy Bank', 1),
		(0, 'Amerant Bank', 1),
		(0, 'American Business Bank', 1),
		(0, 'American Express National Bank', 1),
		(0, 'American First National Bank', 1),
		(0, 'American Momentum Bank', 1),
		(0, 'American National Bank', 1),
		(0, 'American National Bank and Trust Company', 1),
		(0, 'American Savings Bank', 1),
		(0, 'AMERIPRISE BANK', 1),
		(0, 'Ameris Bank', 1),
		(0, 'ANB Bank', 1),
		(0, 'Apple Bank for Savings', 1),
		(0, 'Armstrong Bank', 1),
		(0, 'Arvest Bank', 1),
		(0, 'Associated Bank', 1),
		(0, 'Atlantic Capital Bank', 1),
		(0, 'Atlantic Union Bank', 1),
		(0, 'Austin Bank', 1),
		(0, 'Avidia Bank', 1),
		(0, 'Axos Bank', 1),
		(0, 'b1BANK', 1),
		(0, 'Banc of California', 1),
		(0, 'BancFirst', 1),
		(0, 'Banco Popular de Puerto Rico', 1),
		(0, 'BancorpSouth Bank', 1),
		(0, 'Bangor Savings Bank', 1),
		(0, 'Bank First', 1),
		(0, 'Bank Hapoalim B.M.', 1),
		(0, 'Bank Independent', 1),
		(0, 'Bank Leumi USA', 1),
		(0, 'Bank of America', 1),
		(0, 'Bank of Ann Arbor', 1),
		(0, 'Bank of Baroda', 1),
		(0, 'Bank of China', 1),
		(0, 'Bank of Colorado', 1),
		(0, 'Bank of Guam', 1),
		(0, 'Bank of Hawaii', 1),
		(0, 'Bank of Hope', 1),
		(0, 'Bank of India', 1),
		(0, 'Bank of Marin', 1),
		(0, 'Bank of New Hampshire', 1),
		(0, 'Bank of Stockton', 1),
		(0, 'Bank of the Sierra', 1),
		(0, 'Bank of the West', 1),
		(0, 'Bank OZK', 1),
		(0, 'Bank Rhode Island', 1),
		(0, 'Bankers Trust Company', 1),
		(0, 'BankNewport', 1),
		(0, 'BankPlus', 1),
		(0, 'BankUnited', 1),
		(0, 'Bankwell Bank', 1),
		(0, 'Banner Bank', 1),
		(0, 'Banterra Bank', 1),
		(0, 'Bar Harbor Bank & Trust', 1),
		(0, 'Barclays Bank Delaware', 1),
		(0, 'Barrington Bank & Trust Company', 1),
		(0, 'BayCoast Bank', 1),
		(0, 'BBVA USA', 1),
		(0, 'BCB Community Bank', 1),
		(0, 'Beal Bank USA', 1),
		(0, 'Bell Bank', 1),
		(0, 'Berkshire Bank', 1),
		(0, 'Bessemer Trust Company', 1),
		(0, 'BMO Harris Bank', 1),
		(0, 'BMW Bank of North America', 1),
		(0, 'BNY Mellon', 1),
        (0, 'BOKF', 1),
		(0, 'Boston Private Bank & Trust Company', 1),
		(0, 'Bradesco BAC Florida Bank', 1),
		(0, 'Bremer Bank', 1),
		(0, 'Bridgewater Bank', 1),
		(0, 'Bristol County Savings Bank', 1),
		(0, 'Broadway National Bank', 1),
		(0, 'Brookline Bank', 1),
		(0, 'Bryant Bank', 1),
		(0, 'BTH Bank', 1),
		(0, 'Burke & Herbert Bank & Trust Company', 1),
		(0, 'Busey Bank', 1),
		(0, 'Byline Bank', 1),
		(0, 'Cache Valley Bank', 1),
		(0, 'Cadence Bank', 1),
		(0, 'Cambridge Savings Bank', 1),
		(0, 'Cambridge Trust Company', 1),
		(0, 'Capital City Bank', 1),
		(0, 'Capital One', 1),
		(0, 'Capitol Federal Savings Bank', 1),
		(0, 'CapStar Bank', 1),
		(0, 'Carrollton Bank', 1),
		(0, 'Carter Bank & Trust', 1),
		(0, 'Cashmere Valley Bank', 1),
		(0, 'Cathay Bank', 1),
		(0, 'CB&S Bank', 1),
		(0, 'Centennial Bank', 1),
		(0, 'Centier Bank', 1),
		(0, 'Central Bank & Trust Company', 1),
		(0, 'Central Bank of Boone County', 1),
		(0, 'Central Bank of the Midwest', 1),
		(0, 'Central Pacific Bank', 1),
		(0, 'Central Valley Community Bank', 1),
		(0, 'Century Bank and Trust Company', 1),
		(0, 'Charles Schwab Bank', 1),
		(0, 'Charles Schwab Premier Bank', 1),
		(0, 'Charles Schwab Trust Bank', 1),
		(0, 'Chemung Canal Trust Company', 1),
		(0, 'Choice Financial Group', 1),
		(0, 'ChoiceOne Bank', 1),
		(0, 'CIBC Bank USA', 1),
		(0, 'CIT Bank', 1),
		(0, 'Citibank', 1),
		(0, 'Citizens & Northern Bank', 1),
		(0, 'Citizens and Farmers Bank', 1),
		(0, 'Citizens Bank', 1),
		(0, 'Citizens Business Bank', 1),
		(0, 'Citizens First Bank', 1),
		(0, 'City Bank', 1),
		(0, 'City National Bank', 1),
		(0, 'City National Bank of Florida', 1),
		(0, 'City National Bank of West Virginia', 1),
		(0, 'Citywide Banks', 1),
		(0, 'Civista Bank', 1),
		(0, 'CNB Bank', 1),
		(0, 'Colorado Federal Savings Bank', 1),
		(0, 'Columbia Bank', 1),
		(0, 'Columbia State Bank', 1),
		(0, 'Comenity Bank', 1),
		(0, 'Comenity Capital Bank', 1),
		(0, 'Comerica Bank', 1),
		(0, 'Commerce Bank', 1),
		(0, 'Community Bank', 1),
		(0, 'Community Bank of Mississippi', 1),
		(0, 'Community Bank of the Chesapeake', 1),
		(0, 'Community Trust Bank', 1),
		(0, 'CommunityBank of Texas', 1),
		(0, 'ConnectOne Bank', 1),
		(0, 'Country Club Bank', 1),
		(0, 'Cross River Bank', 1),
		(0, 'CrossFirst Bank', 1),
		(0, 'CTBC Bank Corp', 1),
		(0, 'Customers Bank', 1),
		(0, 'D. L. Evans Bank', 1),
		(0, 'Dacotah Bank', 1),
		(0, 'Deutsche Bank Trust Company', 1),
		(0, 'Dime Community Bank', 1),
		(0, 'Discover Bank', 1),
		(0, 'Dollar Bank', 1),
		(0, 'E*TRADE Bank', 1),
		(0, 'EagleBank', 1),
		(0, 'East Boston Savings Bank', 1),
		(0, 'East West Bank', 1),
		(0, 'Eastern Bank', 1),
		(0, 'El Dorado Savings Bank', 1),
		(0, 'Emigrant Bank', 1),
		(0, 'Emprise Bank', 1),
		(0, 'EnerBank USA', 1),
		(0, 'Enterprise Bank & Trust', 1),
		(0, 'Equity Bank', 1),
		(0, 'Evans Bank', 1),
		(0, 'Exchange Bank', 1),
		(0, 'Farmers and Merchants Bank of Central California', 1),
		(0, 'Farmers and Merchants Bank of Long Beach', 1),
		(0, 'Fidelity Bank', 1),
		(0, 'Fifth Third Bank', 1),
		(0, 'FineMark National Bank & Trust', 1),
		(0, 'First American Bank', 1),
		(0, 'First American Trust', 1),
		(0, 'First Bank', 1),
		(0, 'First Bank & Trust', 1),
		(0, 'First Business Bank', 1),
		(0, 'First Citizens National Bank', 1),
		(0, 'First Commonwealth Bank', 1),
		(0, 'First Community Bank', 1),
		(0, 'First Dakota National Bank', 1),
		(0, 'First Farmers Bank & Trust', 1),
		(0, 'First Federal Bank', 1),
		(0, 'First Federal Savings and Loan Association of Lakewood', 1),
		(0, 'First Fidelity Bank', 1),
		(0, 'First Financial Bank', 1),
		(0, 'First Foundation Bank', 1),
		(0, 'First Guaranty Bank', 1),
		(0, 'First Hawaiian Bank', 1),
		(0, 'First Horizon Bank', 1),
		(0, 'First International Bank & Trust', 1),
		(0, 'First Internet Bank of Indiana', 1),
		(0, 'First Interstate Bank', 1),
		(0, 'First Merchants Bank', 1),
		(0, 'First Mid Bank & Trust', 1),
		(0, 'First Midwest Bank', 1),
		(0, 'First National Bank', 1),
		(0, 'First National Bank Alaska', 1),
		(0, 'First National Bank of America', 1),
		(0, 'First National Bank of Omaha', 1),
		(0, 'First National Bank of Pennsylvania', 1),
		(0, 'First National Bank Texas', 1),
		(0, 'First PREMIER Bank', 1),
		(0, 'First Republic Bank', 1),
		(0, 'First Security Bank', 1),
		(0, 'First State Community Bank', 1),
		(0, 'First United Bank and Trust Company', 1),
		(0, 'FirstBank', 1),
		(0, 'FirstBank Puerto Rico', 1),
		(0, 'First-Citizens Bank & Trust Company', 1),
		(0, 'Firstrust Savings Bank', 1),
		(0, 'Five Star Bank', 1),
		(0, 'Flagstar Bank', 1),
		(0, 'Flushing Bank', 1),
		(0, 'Frandsen Bank & Trust', 1),
		(0, 'Fremont Bank', 1),
		(0, 'Frost Bank', 1),
		(0, 'Fulton Bank', 1),
		(0, 'Gate City Bank', 1),
		(0, 'German American Bank', 1),
		(0, 'Glacier Bank', 1),
		(0, 'Glens Falls National Bank and Trust Company', 1),
		(0, 'Goldman Sachs Bank USA', 1),
		(0, 'Great Southern Bank', 1),
		(0, 'Great Western Bank', 1),
		(0, 'Green Dot Bank DBA Bonneville Bank', 1),
		(0, 'Guaranty Bank & Trust', 1),
		(0, 'Gulf Coast Bank and Trust Company', 1),
		(0, 'Hancock Whitney Bank', 1),
		(0, 'Hanmi Bank', 1),
		(0, 'Happy State Bank', 1),
		(0, 'HarborOne Bank', 1),
		(0, 'Heartland Bank and Trust Company', 1),
		(0, 'Heritage Bank', 1),
		(0, 'Heritage Bank of Commerce', 1),
		(0, 'Hills Bank and Trust Company', 1),
		(0, 'Hingham Institution for Savings', 1),
		(0, 'Hinsdale Bank & Trust Company', 1),
		(0, 'Home Bank', 1),
		(0, 'Home Federal Bank of Tennessee', 1),
		(0, 'HomeStreet Bank', 1),
		(0, 'HomeTrust Bank', 1),
		(0, 'Horizon Bank', 1),
		(0, 'Howard Bank', 1),
		(0, 'HSBC Bank USA', 1),
		(0, 'Independence Bank of Kentucky', 1),
		(0, 'Independent Bank', 1),
		(0, 'Industrial and Commercial Bank of China', 1),
		(0, 'Institution for Savings in Newburyport and Its Vicinity', 1),
		(0, 'Interaudi Bank', 1),
		(0, 'InterBank', 1),
		(0, 'International Bank of Commerce', 1),
		(0, 'Intrust Bank', 1),
		(0, 'Investar Bank', 1),
		(0, 'Investors Bank', 1),
		(0, 'Inwood National Bank', 1),
		(0, 'Israel Discount Bank of New York', 1),
		(0, 'Jefferson Bank', 1),
		(0, 'Johnson Bank', 1),
		(0, 'JPMorgan Chase Bank', 1),
		(0, 'Kearny Bank', 1),
		(0, 'KeyBank', 1),
		(0, 'KS StateBank', 1),
		(0, 'Lake City Bank', 1),
		(0, 'Lake Forest Bank & Trust Company', 1),
		(0, 'Lakeland Bank', 1),
		(0, 'Lakeside Bank', 1),
		(0, 'Leader Bank', 1),
		(0, 'LendingClub Bank', 1),
		(0, 'Level One Bank', 1),
		(0, 'Liberty Bank', 1),
		(0, 'Live Oak Banking Company', 1),
		(0, 'Lone Star National Bank', 1),
		(0, 'Luther Burbank Savings', 1),
		(0, 'Macatawa Bank', 1),
		(0, 'Manasquan Bank', 1),
		(0, 'Manufacturers and Traders Trust Company', 1),
		(0, 'Manufacturers Bank', 1),
		(0, 'Mascoma Bank', 1),
		(0, 'Mechanics Bank', 1),
		(0, 'Mercantile Bank of Michigan', 1),
		(0, 'Merchants Bank', 1),
		(0, 'Merchants Bank of Indiana', 1),
		(0, 'Merrick Bank', 1),
		(0, 'Metabank', 1),
		(0, 'Metropolitan Commercial Bank', 1),
		(0, 'Mid Penn Bank', 1),
		(0, 'Middlesex Savings Bank', 1),
		(0, 'MidFirst Bank', 1),
		(0, 'Midland States Bank', 1),
		(0, 'Midwest BankCentre', 1),
		(0, 'MidWestOne Bank', 1),
		(0, 'Minnwest Bank', 1),
		(0, 'Mizuho Bank (USA)', 1),
		(0, 'Montecito Bank & Trust', 1),
		(0, 'Morgan Stanley Bank', 1),
		(0, 'Morgan Stanley Private Bank', 1),
		(0, 'Morton Community Bank', 1),
		(0, 'MUFG Union Bank', 1),
		(0, 'MVB Bank', 1),
		(0, 'National Cooperative Bank', 1),
		(0, 'National Exchange Bank and Trust', 1),
		(0, 'NBH Bank', 1),
		(0, 'NBT Bank', 1),
		(0, 'Needham Bank', 1),
		(0, 'New Mexico Bank & Trust', 1),
		(0, 'New York Community Bank', 1),
		(0, 'NexBank', 1),
		(0, 'Nicolet National Bank', 1),
		(0, 'North American Savings Bank', 1),
		(0, 'North Shore Bank', 1),
		(0, 'Northbrook Bank and Trust Company', 1),
		(0, 'Northern Bank & Trust Company', 1),
		(0, 'Northfield Bank', 1),
		(0, 'Northrim Bank', 1),
		(0, 'Northwest Bank', 1),
		(0, 'Ocean Bank', 1),
		(0, 'OceanFirst Bank', 1),
		(0, 'Old National Bank', 1),
		(0, 'Old Plank Trail Community Bank', 1),
		(0, 'Old Second National Bank', 1),
		(0, 'Optum Bank', 1),
		(0, 'Oriental Bank', 1),
		(0, 'Origin Bank', 1),
		(0, 'Orrstown Bank', 1),
		(0, 'Pacific Premier Bank', 1),
		(0, 'Pacific Western Bank', 1),
		(0, 'Parkway Bank and Trust Company', 1),
		(0, 'Peapack-Gladstone Bank', 1),
		(0, 'Penn Community Bank', 1),
		(0, 'Peoples Bank', 1),
		(0, 'Peoples Security Bank and Trust Company', 1),
		(0, 'Peoples United Bank', 1),
		(0, 'PeoplesBank', 1),
		(0, 'PeoplesBank, a Codorus Valley Company', 1),
		(0, 'Pinnacle Bank', 1),
		(0, 'PlainsCapital Bank', 1),
		(0, 'PNC Bank', 1),
		(0, 'Poppy Bank', 1),
		(0, 'Popular Bank', 1),
		(0, 'Preferred Bank', 1),
		(0, 'Premier Bank', 1),
		(0, 'Primis Bank', 1),
		(0, 'Principal Bank', 1),
		(0, 'Professional Bank', 1),
		(0, 'Prosperity Bank', 1),
		(0, 'Provident Bank', 1),
		(0, 'Quad City Bank and Trust Company', 1),
		(0, 'Raymond James Bank', 1),
		(0, 'RBC Bank', 1),
		(0, 'RCB Bank', 1),
		(0, 'Red River Bank', 1),
		(0, 'Regions Bank', 1),
		(0, 'Reliant Bank', 1),
		(0, 'Renasant Bank', 1),
		(0, 'Republic Bank', 1),
		(0, 'Republic Bank & Trust Company', 1),
		(0, 'Republic Bank of Chicago', 1),
		(0, 'Ridgewood Savings Bank', 1),
		(0, 'River City Bank', 1),
		(0, 'Rockland Trust Company', 1),
		(0, 'Royal Business Bank', 1),
		(0, 'S&T Bank', 1),
		(0, 'Safra National Bank of New York', 1),
		(0, 'Salem Five Cents Savings Bank', 1),
		(0, 'Sallie Mae Bank', 1),
		(0, 'Sandy Spring Bank', 1),
		(0, 'Santander Bank', 1),
		(0, 'Seacoast National Bank', 1),
		(0, 'Security Bank of Kansas City', 1),
		(0, 'ServisFirst Bank', 1),
		(0, 'Shore United Bank', 1),
		(0, 'Signature Bank', 1),
		(0, 'Silicon Valley Bank', 1),
		(0, 'Silvergate Bank', 1),
		(0, 'Simmons Bank', 1),
		(0, 'SmartBank', 1),
		(0, 'South State Bank', 1),
		(0, 'SouthEast Bank', 1),
		(0, 'Southern Bank', 1),
		(0, 'Southern Bank and Trust Company', 1),
		(0, 'Southern First Bank', 1),
		(0, 'Southside Bank', 1),
		(0, 'Spencer Savings Bank', 1),
		(0, 'Spirit of Texas Bank', 1),
		(0, 'STAR Financial Bank', 1),
		(0, 'State Bank of India', 1),
		(0, 'State Street Bank and Trust Company', 1),
		(0, 'Sterling Bank & Trust', 1),
		(0, 'Sterling National Bank', 1),
		(0, 'Stifel Bank', 1),
		(0, 'Stifel Bank and Trust', 1),
		(0, 'Stock Yards Bank & Trust Company', 1),
		(0, 'Stockman Bank of Montana', 1),
		(0, 'Sumitomo Mitsui Trust Bank', 1),
		(0, 'Summit Community Bank', 1),
		(0, 'Sunflower Bank', 1),
		(0, 'Synchrony Bank', 1),
		(0, 'Synovus Bank', 1),
		(0, 'TBK BANK', 1),
		(0, 'TCF National Bank', 1),
		(0, 'TD Bank', 1),
		(0, 'TD Bank USA', 1),
		(0, 'Territorial Savings Bank', 1),
		(0, 'Texas Bank and Trust Company', 1),
		(0, 'Texas Capital Bank', 1),
		(0, 'The American National Bank of Texas', 1),
		(0, 'The Bancorp Bank', 1),
		(0, 'The Bank of East Asia', 1),
		(0, 'The Bank of Greene County', 1),
		(0, 'The Bank of Missouri', 1),
		(0, 'The Bank of Tampa', 1),
		(0, 'The Bryn Mawr Trust Company', 1),
		(0, 'The Camden National Bank', 1),
		(0, 'The Canandaigua National Bank and Trust Company', 1),
		(0, 'The Cape Cod Five Cents Savings Bank', 1),
		(0, 'The Central Trust Bank', 1),
		(0, 'The Farmers National Bank of Canfield', 1),
		(0, 'The First - A National Banking Association', 1),
		(0, 'The First National Bank of Long Island', 1),
		(0, 'The Huntington National Bank', 1),
		(0, 'The National Bank of Indianapolis', 1),
		(0, 'The Northern Trust Company', 1),
		(0, 'The Park National Bank', 1),
		(0, 'The Washington Trust Company', 1),
		(0, 'Third Federal Savings and Loan Association of Cleveland', 1),
		(0, 'TIAA', 1),
		(0, 'TIB The Independent Bankersbank', 1),
		(0, 'Tompkins Trust Company', 1),
		(0, 'Town Bank', 1),
		(0, 'Towne Bank', 1),
		(0, 'Traditional Bank', 1),
		(0, 'Tri Counties Bank', 1),
		(0, 'Tristate Capital Bank', 1),
		(0, 'Truist Bank', 1),
		(0, 'TrustCo Bank', 1),
		(0, 'Trustmark National Bank', 1),
		(0, 'U.S. Bank', 1),
		(0, 'UBS Bank USA', 1),
		(0, 'UMB Bank', 1),
		(0, 'Umpqua Bank', 1),
		(0, 'UniBank for Savings', 1),
		(0, 'Union Bank and Trust Company', 1),
		(0, 'Union Savings Bank', 1),
		(0, 'United Bank', 1),
		(0, 'United Business Bank', 1),
		(0, 'United Community Bank', 1),
		(0, 'Univest Bank and Trust', 1),
		(0, 'USAA Federal Savings Bank', 1),
		(0, 'Valley National Bank', 1),
		(0, 'Vantage Bank Texas', 1),
		(0, 'VeraBank', 1),
		(0, 'Veritex Community Bank', 1),
		(0, 'Village Bank and Trust', 1),
		(0, 'Washington Federal Bank', 1),
		(0, 'Washington Trust Bank', 1),
		(0, 'Webster Bank', 1),
		(0, 'Wells Fargo Bank', 1),
		(0, 'Wells Fargo Bank South Central', 1),
		(0, 'Wells Fargo National Bank West', 1),
		(0, 'WesBanco Bank', 1),
		(0, 'West Bank', 1),
		(0, 'West Suburban Bank', 1),
		(0, 'Westamerica Bank', 1),
		(0, 'Western Alliance Bank', 1),
		(0, 'Westfield Bank', 1),
		(0, 'WestStar Bank', 1),
		(0, 'WEX Bank', 1),
		(0, 'Wheaton Bank & Trust', 1),
		(0, 'Wilmington Savings Fund Society', 1),
		(0, 'Wilmington Trust', 1),
		(0, 'Wilson Bank and Trust', 1),
		(0, 'Wintrust Bank', 1),
		(0, 'Woodforest National Bank', 1),
		(0, 'Woori America Bank', 1),
		(0, 'Zions Bancorporation', 1)

        -- TCorporateAudit
        INSERT INTO TCorporateAudit  
              ([IndClientId],[CorporateName],[ArchiveFG],[BusinessType],[RefCorporateTypeId],[CompanyRegNo],[EstIncorpDate],[YearEnd],[VatRegFg]
              ,[Extensible],[VatRegNo],[ConcurrencyId],[CorporateId],[StampAction],[StampDateTime],[StampUser],[MigrationRef],[LEI],[LEIExpiryDate])
        SELECT [IndClientId],[CorporateName],[ArchiveFG],[BusinessType],[RefCorporateTypeId],[CompanyRegNo],[EstIncorpDate],[YearEnd],[VatRegFg]
              ,[Extensible],[VatRegNo],[ConcurrencyId],[CorporateId],@StampAction, @StampDateTime, @StampUser,[MigrationRef],[LEI],[LEIExpiryDate]
        FROM  TCorporate
        WHERE CorporateId IN (SELECT CorporateId FROM #TCRMContact) 

        IF OBJECT_ID('tempdb..#TRefProdProviders') IS NOT NULL
        DROP TABLE #TRefProdProviders
        CREATE TABLE #TRefProdProviders(CrmContactId INT)

        -- TCRMContact
        INSERT INTO TCRMContact (CorporateId, CorporateName, IndClientId)
        OUTPUT inserted.CRMContactId
        INTO #TRefProdProviders
        SELECT CorporateId, CorporateName, 0 
        FROM #TCRMContact

        -- TCRMContactAudit
        INSERT INTO TCRMContactAudit
        ([RefCRMContactStatusId],[PersonId],[CorporateId],[TrustId],[AdvisorRef],[RefSourceOfClientId],[SourceValue],[Notes],[ArchiveFg],[LastName]
              ,[FirstName],[CorporateName],[DOB],[Postcode],[OriginalAdviserCRMId],[CurrentAdviserCRMId],[CurrentAdviserName],[CRMContactType],[IndClientId]
              ,[FactFindId],[InternalContactFG],[RefServiceStatusId],[AdviserAssignedByUserId],[_ParentId],[_ParentTable],[_ParentDb],[_OwnerId],[MigrationRef]
              ,[CreatedDate],[ExternalReference],[AdditionalRef],[CampaignDataId],[FeeModelId],[ConcurrencyId],[CRMContactId],[StampAction],[StampDateTime],[StampUser]
              ,[ServiceStatusStartDate],[ClientTypeId],[IsHeadOfFamilyGroup],[FamilyGroupCreationDate],[IsDeleted])
        SELECT 
        [RefCRMContactStatusId],[PersonId],[CorporateId],[TrustId],[AdvisorRef],[RefSourceOfClientId],[SourceValue],[Notes],[ArchiveFg],[LastName]
              ,[FirstName],[CorporateName],[DOB],[Postcode],[OriginalAdviserCRMId],[CurrentAdviserCRMId],[CurrentAdviserName],[CRMContactType],[IndClientId]
              ,[FactFindId],[InternalContactFG],[RefServiceStatusId],[AdviserAssignedByUserId],[_ParentId],[_ParentTable],[_ParentDb],[_OwnerId],[MigrationRef]
              ,[CreatedDate],[ExternalReference],[AdditionalRef],[CampaignDataId],[FeeModelId],[ConcurrencyId],[CRMContactId],@StampAction,@StampDateTime,@StampUser
              ,[ServiceStatusStartDate],[ClientTypeId],[IsHeadOfFamilyGroup],[FamilyGroupCreationDate],[IsDeleted]
        FROM TCRMContact
        WHERE CRMContactId IN (SELECT CRMContactId FROM #TRefProdProviders)

        IF OBJECT_ID('tempdb..#TRefLicenseType_ToProviders') IS NOT NULL
        DROP TABLE #TRefLicenseType_ToProviders
        CREATE TABLE #TRefLicenseType_ToProviders(RefProviderId INT)

        -- TRefProdProvider
        INSERT INTO policymanagement..TRefProdProvider (CRMContactId, RegionCode, IsConsumerFriendly)
        OUTPUT inserted.RefProdProviderId
        INTO #TRefLicenseType_ToProviders
        SELECT CRMContactId, @RegionCode, 1
        FROM #TRefProdProviders

        -- TRefProdProviderAudit
        INSERT INTO policymanagement..TRefProdProviderAudit
        ([CRMContactId],[FundProviderId],[NewProdProviderId],[RetireFg],[ConcurrencyId],[RefProdProviderId],[StampAction],[StampDateTime],[StampUser],[IsTransactionFeedSupported]
              ,[IsConsumerFriendly],[RegionCode],[IsBankAccountTransactionFeed])
        SELECT 
        [CRMContactId],[FundProviderId],[NewProdProviderId],[RetireFg],[ConcurrencyId],[RefProdProviderId] ,@StampAction,@StampDateTime,@StampUser,[IsTransactionFeedSupported]
              ,[IsConsumerFriendly],[RegionCode],[IsBankAccountTransactionFeed]
        FROM policymanagement..TRefProdProvider
        WHERE RefProdProviderId IN (SELECT RefProviderId FROM #TRefLicenseType_ToProviders)

        -- TRefLicenseTypeToRefProdProvider
        INSERT INTO policymanagement..TRefLicenseTypeToRefProdProvider (RefProdproviderId, RefLicenseTypeId)
        OUTPUT inserted.RefLicenseTypeToRefProdProviderId,
               inserted.RefProdproviderId,
               inserted.RefLicenseTypeId, 
               inserted.ConcurrencyId,
               @StampAction,
               @StampDateTime,
               @StampUser
        INTO policymanagement..TRefLicenseTypeToRefProdProviderAudit
        SELECT RefProviderId, 1
        FROM #TRefLicenseType_ToProviders           

        INSERT TExecutedDataScript (ScriptGUID, Comments) VALUES (@ScriptGUID, @Comments)

    IF @starttrancount = 0 
        COMMIT TRANSACTION

END TRY
BEGIN CATCH

       DECLARE @ErrorSeverity INT
       DECLARE @ErrorState INT
       DECLARE @ErrorLine INT
       DECLARE @ErrorNumber INT

       SELECT @ErrorMessage = ERROR_MESSAGE(),
       @ErrorSeverity = ERROR_SEVERITY(),
       @ErrorState = ERROR_STATE(),
       @ErrorNumber = ERROR_NUMBER(),
       @ErrorLine = ERROR_LINE()

    IF XACT_STATE() <> 0 AND @starttrancount = 0 
        ROLLBACK TRANSACTION

       RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)

END CATCH


SET XACT_ABORT OFF
SET NOCOUNT OFF

RETURN;