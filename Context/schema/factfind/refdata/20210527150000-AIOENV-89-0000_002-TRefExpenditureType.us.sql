USE [FactFind]

DECLARE @ScriptGUID UNIQUEIDENTIFIER
      , @Comments VARCHAR(255)
      , @ErrorMessage VARCHAR(MAX)

SELECT @ScriptGUID = '08D1404E-19FD-4BF1-AC48-CADABC156D8E',
       @Comments = 'AIOENV-89 initial load for table TRefExpenditureType for us environments'

 -- check if this script has already run     
IF EXISTS (SELECT 1 FROM TExecutedDataScript WHERE ScriptGUID = @ScriptGUID)
	RETURN; 

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
				(  1, 1, 1,                                                    N'Building Insurance',   1, N'{\"party_types\":\"Person\"}'),
				(  2, 1, 1,                                             N'Auto / Transport Expenses',   2, N'{\"party_types\":\"Person\"}'),
				(  3, 1, 1,                                                    N'Combined Utilities',   3, N'{\"party_types\":\"Person\"}'),
				(  4, 1, 1,                                                          N'Property Tax',   4, N'{\"party_types\":\"Person\"}'),
				(  5, 1, 1,                                                           N'Electricity',   5, N'{\"party_types\":\"Person\"}'),
				(  6, 1, 1,                                                  N'Food & Personal Care',   6, N'{\"party_types\":\"Person\"}'),
				(  7, 1, 1,                                                            N'Gas & Fuel',   7, N'{\"party_types\":\"Person\"}'),
				(  8, 1, 1,                                                          N'Housekeeping',   8, N'{\"party_types\":\"Person\"}'),
				(  9, 1, 1,                                                           N'Maintenance',   9, N'{\"party_types\":\"Person\"}'),
				( 10, 1, 1,                                                     N'Medical insurance',  10, N'{\"party_types\":\"Person\"}'),
				( 11, 1, 1,                                               N'Other (Basic Essential)',  11, N'{\"party_types\":\"Person\"}'),
				( 12, 1, 1,                                                                  N'Rent',  12, N'{\"party_types\":\"Person\"}'),
				( 13, 1, 1,                                                      N'Telephone/Mobile',  13, N'{\"party_types\":\"Person\"}'),
				( 14, 1, 1,                                                                 N'Water',  14, N'{\"party_types\":\"Person\"}'),

				( 15, 1, 4,                                                              N'Business',  15, N'{\"party_types\":\"Person\"}'),
				( 16, 1, 4,                                                              N'Clothing',  16, N'{\"party_types\":\"Person\"}'),
				( 17, 1, 4,                                   N'Deductible Retirement Contributions',  17, N'{\"party_types\":\"Person\"}'),
				( 18, 1, 4,                                          N'Furniture/Appliances/Repairs',  18, N'{\"party_types\":\"Person\"}'),
				( 19, 1, 4,                               N'Non-deductible Retirement Contributions',  19, N'{\"party_types\":\"Person\"}'),
				( 20, 1, 4,                                       N'Other (Basic Quality of Living)',  20, N'{\"party_types\":\"Person\"}'),
				( 21, 1, 4,                                                               N'Pension',  21, N'{\"party_types\":\"Person\"}'),
				( 22, 1, 4,                                                  N'School Fee/Childcare',  22, N'{\"party_types\":\"Person\"}'),
				( 23, 1, 4,                                N'TV/Satellite/Internet/Basic Recreation',  23, N'{\"party_types\":\"Person\"}'),

				( 24, 1, 5,                                                       N'Accountant Fees',  24, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 25, 1, 5,                                                            N'Audit Fees',  25, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 26, 1, 5,                                                             N'Bank Fees',  26, N'{\"party_types\":\"Trust,Corporate\"}'),				
				( 27, 1, 5,                                                    N'Borrowing Expenses',  27, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 28, 1, 5,                                                        N'Brokerage Fees',  28, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 29, 1, 5,                                                              N'Business',  29, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 30, 1, 5,                                               N'Collectables or Artwork',  30, N'{\"party_types\":\"Trust\"}'),
				( 31, 1, 5,                   N'Life, Disability, Long Term Care Insurance Premiums',  31, N'{\"party_types\":\"Trust\"}'),
				( 32, 1, 5,                                           N'Financial Planning Expenses',  32, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 33, 1, 5,                                                     N'Interest Expenses',  33, N'{\"party_types\":\"Trust,Corporate\"}'),				
				( 34, 1, 5,                                           N'Investment Related Expenses',  34, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 35, 1, 5,                                                        N'Legal Expenses',  35, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 36, 1, 5,                                            N'Lenders Mortgage Insurance',  36, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 37, 1, 5,                                                        N'Loan Repayment',  37, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 38, 1, 5,                                    N'Management and Administration Fees',  38, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 39, 1, 5,                                              N'Investment Advisory Fees',  39, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 40, 1, 5,                                                    N'Operating Expenses',  40, N'{\"party_types\":\"Trust,Corporate\"}'),				
				( 41, 1, 5,                                                                 N'Other',  41, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 42, 1, 5,                                              N'Rental Property Expenses',  42, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 43, 1, 5,                                                              N'Salaries',  43, N'{\"party_types\":\"Corporate\"}'),
				( 44, 1, 5,                                                  N'Tax-related Expenses',  44, N'{\"party_types\":\"Trust,Corporate\"}'),
				( 45, 1, 5,                                               N'Travel And Accomodation',  45, N'{\"party_types\":\"Corporate\"}'),

				( 46, 1, 3,                                                          N'Credit Cards',  46, N'{\"party_types\":\"Person\"}'),
				( 47, 1, 3,                                                   N'Maintenance/Alimony',  47, N'{\"party_types\":\"Person\"}'),
				( 48, 1, 3,                                                              N'Mortgage',  48, N'{\"party_types\":\"Person\"}'),	
				( 49, 1, 3,                                                     N'Other (Liability)',  49, N'{\"party_types\":\"Person\"}'),
				( 50, 1, 3,                                                        N'Personal Loans',  50, N'{\"party_types\":\"Person\"}'),

				( 51, 1, 6,                                                  N'Books and Stationary',  51, N'{\"party_types\":\"Person\"}'),
				( 52, 1, 6,                                                             N'Donations',  52, N'{\"party_types\":\"Person\"}'),
				( 53, 1, 6,                                                         N'Entertainment',  53, N'{\"party_types\":\"Person\"}'),
				( 54, 1, 6,                                                               N'Hobbies',  54, N'{\"party_types\":\"Person\"}'),
				( 55, 1, 6,                                                                   N'Gym',  55, N'{\"party_types\":\"Person\"}'),
				( 56, 1, 6,                                                              N'Holidays',  56, N'{\"party_types\":\"Person\"}'),	
				( 57, 1, 6,                                                           N'Investments',  57, N'{\"party_types\":\"Person\"}'),				
				( 58, 1, 6,                                                 N'Other (Non-Essential)',  58, N'{\"party_types\":\"Person\"}'),
				( 59, 1, 6,                                                          N'Other Assets',  59, N'{\"party_types\":\"Person\"}'),
				( 60, 1, 6,                                                    N'Insurance Products',  60, N'{\"party_types\":\"Person\"}'),							
				( 61, 1, 6,                                                 N'Sports and Recreation',  61, N'{\"party_types\":\"Person\"}'),				
				( 62, 1, 6,                                                                N'Travel',  62, N'{\"party_types\":\"Person\"}')

        SET IDENTITY_INSERT TRefExpenditureType OFF

        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (@ScriptGUID, @Comments, null, getdate() )

   IF @starttrancount = 0
    COMMIT TRANSACTION

END TRY
BEGIN CATCH
    DECLARE @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorNumber INT
    SELECT @ErrorMessage = ERROR_MESSAGE() , @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER(), @ErrorLine = ERROR_LINE()
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorNumber, @ErrorLine)
END CATCH

 SET XACT_ABORT OFF
 SET NOCOUNT OFF  