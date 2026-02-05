-----------------------------------------------------------------------------
--
-- Purpose : Addition of trust and corporate expenditure types for AU.
--
-----------------------------------------------------------------------------

USE FactFind
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = '52979D23-FC33-4652-8AFD-83E7F5624F4D'
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
 
        INSERT [dbo].[TRefExpenditureType] ([RefExpenditureTypeId], [ConcurrencyId], [RefExpenditureGroupId], [Name], [Ordinal], [Attributes]) 
		VALUES	
				(  1, 1, 3,                                                              N'Mortgage',  22, N'{\"party_types\":\"Person\"}'),		
				(  2, 1, 1,                                                                  N'Rent',   2, N'{\"party_types\":\"Person\"}'),
				(  4, 1, 1,                                                                   N'Gas',   4, N'{\"party_types\":\"Person\"}'),
				(  5, 1, 1,                                                           N'Electricity',   5, N'{\"party_types\":\"Person\"}'),
				(  6, 1, 1,                                                                 N'Water',   6, N'{\"party_types\":\"Person\"}'),
				(  7, 1, 1,                                                      N'Telephone/Mobile',   7, N'{\"party_types\":\"Person\"}'),
				(  8, 1, 4,                                N'TV/Satellite/Internet/Basic Recreation',   4, N'{\"party_types\":\"Person\"}'),
				(  9, 1, 1,                                                   N'Maintenance/Alimony',  23, N'{\"party_types\":\"Person\"}'),
				( 10, 1, 1,                                                  N'Food & Personal Care',  10, N'{\"party_types\":\"Person\"}'),
				( 11, 1, 1,                                               N'Car/Travelling Expenses',  11, N'{\"party_types\":\"Person\"}'),
				( 12, 1, 2,                                        N'Life/General Assurance Premium',  19, N'{\"party_types\":\"Person\"}'),
				( 14, 1, 1,                                                          N'Housekeeping',  14, N'{\"party_types\":\"Person\"}'),
				( 16, 1, 1,                                               N'Other (Basic Essential)', 101, N'{\"party_types\":\"Person\"}'),
				( 18, 1, 2,                                                              N'Holidays',  17, N'{\"party_types\":\"Person\"}'),	
				( 19, 1, 2,                                                         N'Entertainment',  18, N'{\"party_types\":\"Person\"}'),
				( 20, 1, 2,                                                 N'Other (Non-Essential)', 103, N'{\"party_types\":\"Person\"}'),
				( 21, 1, 3,                                                        N'Personal Loans',  20, N'{\"party_types\":\"Person\"}'),
				( 22, 1, 3,                                                          N'Credit Cards',  21, N'{\"party_types\":\"Person\"}'),
				( 23, 1, 1,                                            N'Ground Rent/Service charge',  15, N'{\"party_types\":\"Person\"}'),
				( 24, 1, 1,                                                    N'Building Insurance',  16, N'{\"party_types\":\"Person\"}'),
				( 25, 1, 4,                                                              N'Clothing',   1, N'{\"party_types\":\"Person\"}'),
				( 26, 1, 4,                                          N'Furniture/Appliances/Repairs',   2, N'{\"party_types\":\"Person\"}'),				
				( 30, 1, 3,                                                     N'Other (Liability)', 102, N'{\"party_types\":\"Person\"}'),
				( 31, 1, 4,                                       N'Other (Basic Quality of Living)', 105, N'{\"party_types\":\"Person\"}'),
				( 32, 1, 1,                                                    N'Combined Utilities',  17, N'{\"party_types\":\"Person\"}'),				
				( 36, 1, 4,                                                               N'Pension',   7, N'{\"party_types\":\"Person\"}'),
				( 37, 1, 2,                                                           N'Investments',  20, N'{\"party_types\":\"Person\"}'),
				( 38, 1, 2,                                                   N'Protection Products',  21, N'{\"party_types\":\"Person\"}'),
				( 39, 1, 2,                                                          N'Other Assets',  22, N'{\"party_types\":\"Person\"}'),																															
				( 40, 1, 5,                                                              N'Business',  40, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 41, 1, 5,                                                        N'Partner Payout',  41, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 42, 1, 5,                                                         N'Client Payout',  42, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 43, 1, 5,                                                                 N'Other', 100, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 44, 1, 5,                                                    N'Operating Expenses',  44, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 45, 1, 5,                                           N'Investment Related Expenses',  45, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 46, 1, 5,                                                  N'Tax-related Expenses',  46, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 47, 1, 5,                                                        N'Legal Expenses',  47, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 48, 1, 5,                                             N'Statutory fees and levies',  48, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 49, 1, 5, N'Death, TPD, Terminal Illness and Income Protection Insurance Premiums',  49, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 66, 1, 5,                                               N'Collectables or Artwork',  65, N'{\"party_types\":\"Trust\"}'),
				( 50, 1, 5,                                                N'Anti Detriment Payment',  50, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 51, 1, 5,                                    N'Management and Administration Fees',  51, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 52, 1, 5,                                                            N'Audit Fees',  52, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 53, 1, 5,                                                     N'Interest Expenses',  53, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 54, 1, 5,      N'Ongoing Management Fees or Retainers paid to Investment Advisers',  54, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 55, 1, 5,                                                             N'Bank Fees',  55, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 56, 1, 5,                                              N'Rental Property Expenses',  56, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 57, 1, 5,                                                        N'Brokerage Fees',  57, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 58, 1, 5,                                           N'Financial Planning Expenses',  58, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 59, 1, 5,                                                    N'Borrowing Expenses',  59, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 60, 1, 5,                                            N'Lenders Mortgage Insurance',  60, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 67, 1, 5,                                                 N'Trust Deed Amendments',  66, N'{\"party_types\":\"Trust\"}'),
				( 61, 1, 5,                                                       N'Accountant Fees',  61, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 62, 1, 5,                                                         N'Property Cost',  62, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 68, 1, 5,                                  N'Reimbursement Of Expenses To Trustee',  67, N'{\"party_types\":\"Trust\"}'),
				( 69, 1, 5,                               N'Travel And Subsistence Costs Of Trustee',  68, N'{\"party_types\":\"Trust\"}'),
				( 63, 1, 5,                                                        N'Loan Repayment',  63, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 64, 1, 5,                                                         N'Council Rates',  64, N'{\"party_types\":\"Trust,Corporate\"}'),				
				( 70, 1, 5,                                                              N'Salaries',  69, N'{\"party_types\":\"Corporate\"}'),
				( 71, 1, 5,                                               N'Travel And Accomodation',  70, N'{\"party_types\":\"Corporate\"}'),
				(101, 1, 1,                                                     N'Medical insurance', 101, N'{\"party_types\":\"Person\"}'),
				(102, 1, 1,                                                           N'Maintenance', 101, N'{\"party_types\":\"Person\"}'),				
				(103, 1, 4,                                                          N'Primary Fees',   1, N'{\"party_types\":\"Person\"}'),
				(104, 1, 4,                                                        N'Secondary Fees',   1, N'{\"party_types\":\"Person\"}'),
				(105, 1, 4,                                                         N'Tertiary Fees',   1, N'{\"party_types\":\"Person\"}'),
				(106, 1, 4,                                            N'Concessional Contributions',   1, N'{\"party_types\":\"Person\"}'),
				(107, 1, 4,                                        N'Non Concessional Contributions',   1, N'{\"party_types\":\"Person\"}'),
				(108, 1, 4,                                                              N'Business',   1, N'{\"party_types\":\"Person\"}'),
				(109, 1, 4,                                                            N'Technology',   1, N'{\"party_types\":\"Person\"}'),
				(110, 1, 2,                                                             N'Donations', 103, N'{\"party_types\":\"Person\"}'),
				(111, 1, 2,                                                 N'Sports and Recreation', 103, N'{\"party_types\":\"Person\"}'),
				(112, 1, 2,                                                               N'Hobbies', 103, N'{\"party_types\":\"Person\"}'),
				(113, 1, 2,                                                  N'Books and Stationary', 103, N'{\"party_types\":\"Person\"}'),
				(114, 1, 2,                                                                N'Travel', 103, N'{\"party_types\":\"Person\"}'),
				(115, 1, 5,                                                          N'Client Super',  64, N'{\"party_types\":\"Trust,Corporate\"}'),
				(116, 1, 5,                                                         N'Super Partner',  64, N'{\"party_types\":\"Trust,Corporate\"}'),
				(117, 1, 5,                                                       N'ASIC Annual Fee',  64, N'{\"party_types\":\"Trust,Corporate\"}'),
				(118, 1, 5,                                                 N'SMSF Supervisory Levy',  64, N'{\"party_types\":\"Trust,Corporate\"}')

        SET IDENTITY_INSERT TRefExpenditureType OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         '52979D23-FC33-4652-8AFD-83E7F5624F4D', 
         'Initial load of trust and corporate data for table TRefExpenditureType',
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
-----------------------------------------------------------------------------