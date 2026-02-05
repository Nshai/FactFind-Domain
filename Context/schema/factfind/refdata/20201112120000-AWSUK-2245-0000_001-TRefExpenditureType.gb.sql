-----------------------------------------------------------------------------
--
-- Purpose : Addition of updates for personal expenditure types for the UK
--
-----------------------------------------------------------------------------
 
USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'AD15FBB1-7869-420C-B9E0-A68259510E4B'
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefExpenditureType ON; 
 
        INSERT INTO TRefExpenditureType([RefExpenditureTypeId], [ConcurrencyId], [RefExpenditureGroupId], [Name], [Ordinal], [Attributes])

		-- Basic essential expenditure
        SELECT  1, 1, 3,                                                              'Mortgage',  22, '{\"party_types\":\"Person\"}' UNION ALL
		SELECT  2, 1, 1,                                                                  'Rent',   2, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT  3, 1, 1,                                                           'Council Tax',   3, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT  4, 1, 1,                                                                   'Gas',   4, '{\"party_types\":\"Person\"}' UNION ALL        
        SELECT  5, 1, 1,                                                           'Electricity',   5, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT  6, 1, 1,                                                                 'Water',   6, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT  7, 1, 1,                                                      'Telephone/Mobile',   7, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT  8, 1, 4,                                'TV/Satellite/Internet/Basic Recreation',   4, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT  9, 1, 1,                                                   'Maintenance/Alimony',  23, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 10, 1, 1,                                                  'Food & Personal Care',  10, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 11, 1, 1,                                               'Car/Travelling Expenses',  11, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 12, 1, 2,                                        'Life/General Assurance Premium',  19, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 13, 1, 4,                                                  'School Fee/Childcare', 104, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 14, 1, 1,                                                          'Housekeeping',  14, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 16, 1, 1,                                               'Other (Basic Essential)', 101, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 17, 1, 2,                                                                   'Gym',  16, '{\"party_types\":\"Person\"}' UNION ALL			   	  
		SELECT 18, 1, 2,                                                              'Holidays',  17, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 19, 1, 2,                                                         'Entertainment',  18, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 20, 1, 2,                                                 'Other (Non-Essential)', 103, '{\"party_types\":\"Person\"}' UNION ALL        
        SELECT 21, 1, 3,                                                        'Personal Loans',  20, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 22, 1, 3,                                                          'Credit Cards',  21, '{\"party_types\":\"Person\"}' UNION ALL        
        SELECT 23, 1, 1,                                            'Ground Rent/Service charge',  15, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 24, 1, 1,                                                    'Building Insurance',  16, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 25, 1, 4,                                                              'Clothing',   1, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 26, 1, 4,                                          'Furniture/Appliances/Repairs',   2, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 30, 1, 3,                                                     'Other (Liability)', 102, '{\"party_types\":\"Person\"}' UNION ALL
       	SELECT 31, 1, 4,                                       'Other (Basic Quality of Living)', 105, '{\"party_types\":\"Person\"}' UNION ALL		   	  
        SELECT 32, 1, 1,                                                    'Combined Utilities',  17, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 36, 1, 4,                                                               'Pension',   7, '{\"party_types\":\"Person\"}' UNION ALL
		SELECT 37, 1, 2,                                                           'Investments',  20, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 38, 1, 2,                                                   'Protection Products',  21, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 39, 1, 2,                                                          'Other Assets',  22, '{\"party_types\":\"Person\"}' UNION ALL
        SELECT 40, 1, 5,                                                              'Business',  40, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 41, 1, 5,                                                        'Partner Payout',  41, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 42, 1, 5,                                                         'Client Payout',  42, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 43, 1, 5,                                                                 'Other', 100, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 44, 1, 5,                                                    'Operating Expenses',  44, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 45, 1, 5,                                           'Investment Related Expenses',  45, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 46, 1, 5,                                                  'Tax-related Expenses',  46, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 47, 1, 5,                                                        'Legal Expenses',  47, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 48, 1, 5,                                             'Statutory fees and levies',  48, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 49, 1, 5, 'Death, TPD, Terminal Illness and Income Protection Insurance Premiums',  49, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 50, 1, 5,                                                'Anti Detriment Payment',  50, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 51, 1, 5,                                    'Management and Administration Fees',  51, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 52, 1, 5,                                                            'Audit Fees',  52, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 53, 1, 5,                                                     'Interest Expenses',  53, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 54, 1, 5,      'Ongoing Management Fees or Retainers paid to Investment Advisers',  54, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 55, 1, 5,                                                             'Bank Fees',  55, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 56, 1, 5,                                              'Rental Property Expenses',  56, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 57, 1, 5,                                                        'Brokerage Fees',  57, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 58, 1, 5,                                           'Financial Planning Expenses',  58, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 59, 1, 5,                                                    'Borrowing Expenses',  59, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 60, 1, 5,                                            'Lenders Mortgage Insurance',  60, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 61, 1, 5,                                                       'Accountant Fees',  61, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 62, 1, 5,                                                         'Property Cost',  62, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 63, 1, 5,                                                        'Loan Repayment',  63, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 64, 1, 5,                                                         'Council Rates',  64, '{\"party_types\":\"Trust,Corporate\"}' UNION ALL	
		SELECT 66, 1, 5,                                               'Collectables or Artwork',  65, '{\"party_types\":\"Trust\"}' UNION ALL
		SELECT 67, 1, 5,                                                 'Trust Deed Amendments',  66, '{\"party_types\":\"Trust\"}' UNION ALL
		SELECT 68, 1, 5,                                  'Reimbursement Of Expenses To Trustee',  67, '{\"party_types\":\"Trust\"}' UNION ALL
		SELECT 69, 1, 5,                               'Travel And Subsistence Costs Of Trustee',  68, '{\"party_types\":\"Trust\"}' UNION ALL
		SELECT 70, 1, 5,                                                              'Salaries',  69, '{\"party_types\":\"Corporate\"}' UNION ALL
		SELECT 71, 1, 5,                                               'Travel And Accomodation',  70, '{\"party_types\":\"Corporate\"}'  		

        SET IDENTITY_INSERT TRefExpenditureType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'AD15FBB1-7869-420C-B9E0-A68259510E4B', 
         'Initial load or Persaonal data for table TRefExpenditureType',
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
-- #Rows Exported: 32
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM