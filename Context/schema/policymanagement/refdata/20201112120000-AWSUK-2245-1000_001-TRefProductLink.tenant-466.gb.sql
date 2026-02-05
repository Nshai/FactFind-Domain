 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefProductLink
--    Join: join tapplicationlink l on l.ApplicationLinkId = TRefProductLink.ApplicationLinkId
--   Where: WHERE l.IndigoClientId = 466
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'B8A4F28E-5D84-4DC9-85E9-982D16665E54'
     AND TenantId = 466
) RETURN 
 
SET NOCOUNT ON 
SET XACT_ABORT ON
 
DECLARE @starttrancount int
BEGIN TRY
    SELECT @starttrancount = @@TRANCOUNT
    IF @starttrancount = 0
    BEGIN TRANSACTION
 
        -- insert the records
        SET IDENTITY_INSERT TRefProductLink ON; 
 
        INSERT INTO TRefProductLink([RefProductLinkId], [ApplicationLinkId], [RefProductTypeId], [ProductGroupData], [ProductTypeData], [IsArchived], [ConcurrencyId])
        SELECT 12855,557,1, 'QuotesTermAssurance', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 12856,557,2, 'QuotesConvertibleTerm', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 12857,557,4, 'QuotesMortgageProtection', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 12858,557,6, 'QuotesFamilyIncomeBenefit', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 19214,557,7, 'QuotesIncomeProtection-OwnLife', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 17120,557,8, 'QuotesIncomeProtection-LifeOfAnother', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 18536,557,9, 'QuotesIncomeProtection-ProfessionalExpenses', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 19466,557,10, 'QuotesIncomeProtection-KeyPerson', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 12859,558,1, 'QuotesTermAssurance', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 12860,558,2, 'QuotesConvertibleTerm', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3897,558,3, 'QuotesPensionTermAssurance', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 12861,558,4, 'QuotesMortgageProtection', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 12862,558,6, 'QuotesFamilyIncomeBenefit', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3898,558,7, 'QuotesIncomeProtection-OwnLife', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3899,558,8, 'QuotesIncomeProtection-LifeOfAnother', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3900,558,9, 'QuotesIncomeProtection-ProfessionalExpenses', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3901,558,10, 'QuotesIncomeProtection-KeyPerson', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3908,558,11, 'QuotesCriticalIllness', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3909,558,12, 'QuotesWholeOfLife', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3910,558,13, 'QuotesCriticalIllnessWithWholeOfLife', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3906,558,14, 'QuotesSelfEmployedPersonalPensionPlan', '/origo/3.2/QNBRetirementIndividualQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3907,558,15, 'QuotesEmployedPersonalPensionPlan', '/origo/3.2/QNBRetirementIndividualQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3902,558,16, 'QuotesWithProfitsBond', '/origo/3.1/QNBInvestmentBondQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3903,558,17, 'QuotesUnitLinkedBond', '/origo/3.1/QNBInvestmentBondQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3904,558,18, 'QuotesDistributionBond', '/origo/3.1/QNBInvestmentBondQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 3905,558,19, 'QuotesUnitLinkedAndWithProfitBond', '/origo/3.1/QNBInvestmentBondQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 82001,898,58, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 87611,898,59, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 83021,898,60, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 167622,898,61, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 82511,898,62, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 83786,898,63, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 80981,898,64, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 81491,898,65, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 81746,898,66, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 82766,898,67, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 81236,898,68, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 82256,898,69, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 184250,898,70, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 147138,898,71, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 131499,898,72, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 187820,898,73, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 138723,898,74, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 142038,898,75, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 153003,898,76, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 130224,898,77, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 135097,898,78, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 119837,8046,58, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 116522,8046,59, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 98672,8046,60, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 177974,8046,61, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 99437,8046,62, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 100202,8046,63, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 111167,8046,64, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 97652,8046,65, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 103007,8046,66, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 101732,8046,67, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 99947,8046,68, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 100967,8046,69, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 188171,8046,70, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 160239,8046,71, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 143664,8046,72, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 191486,8046,73, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 152589,8046,74, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 156924,8046,75, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 164319,8046,76, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 146724,8046,77, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 144939,8046,78, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 64685,8917,25, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 178404,8917,58, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 134830,8917,59, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 112362,8917,60, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 183672,8917,61, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 117972,8917,62, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 123582,8917,63, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 135850,8917,64, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 111342,8917,65, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 118227,8917,66, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 120777,8917,67, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 116697,8917,68, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 117717,8917,69, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 191661,8917,70, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 177157,8917,71, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 154804,8917,72, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 194976,8917,73, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 165881,8917,74, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 168176,8917,75, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 172312,8917,76, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 159394,8917,77, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 155314,8917,78, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 61305,11988,21, 'Quote LandlordBuildings&Contents', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 61306,11988,22, 'Quote HouseholdBuildings&Contents', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 61307,11988,23, 'Quote MortgageProtector', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 61308,11988,24, 'Quote IncomeShield', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 66496,27961,25, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201638,27961,58, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201639,27961,59, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201640,27961,60, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201641,27961,61, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201642,27961,62, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201643,27961,63, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201644,27961,64, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201645,27961,65, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201646,27961,66, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201647,27961,67, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201648,27961,68, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201649,27961,69, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201650,27961,70, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201651,27961,71, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201652,27961,72, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201653,27961,73, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201654,27961,74, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201655,27961,75, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201656,27961,76, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201657,27961,77, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 201658,27961,78, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 320215,53199,47, 'QuoteSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 322054,54786,27, 'ApplicationISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 322055,54786,28, 'ApplicationGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 322056,54786,47, 'ApplicationSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 332911,54786,80, 'ApplicationCashAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 326941,56373,26, 'PlatformISA(Cash)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 326942,56373,27, 'PlatformISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 326943,56373,28, 'PlatformGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 326944,56373,47, 'PlatformSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 334498,56373,80, 'ApplicationCashAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 380000,66790,47, 'QuoteSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 379999,66790,81, 'QuoteIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 379997,66790,82, 'QuoteIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 379998,66790,83, 'QuoteIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 387012,68543,47, 'QuoteSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 387009,68543,81, 'QuoteIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 387010,68543,82, 'QuoteIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 387011,68543,83, 'QuoteIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 394124,70296,27, 'ApplicationISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 394125,70296,28, 'ApplicationGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 394123,70296,47, 'ApplicationSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 394127,70296,81, 'ApplicationIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 394126,70296,82, 'ApplicationIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 394128,70296,83, 'ApplicationIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 404539,72049,47, 'ApplicationSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 404541,72049,81, 'ApplicationIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 404540,72049,82, 'ApplicationIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 404542,72049,83, 'ApplicationIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 411653,73802,27, 'PlatformISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 411654,73802,28, 'PlatformGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 411655,73802,47, 'PlatformSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 411657,73802,81, 'PlatformIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 411656,73802,82, 'PlatformIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 411658,73802,83, 'PlatformIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 422071,75555,47, 'PlatformSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 422069,75555,81, 'PlatformIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 422072,75555,82, 'PlatformIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 422070,75555,83, 'PlatformIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 
 
        SET IDENTITY_INSERT TRefProductLink OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'B8A4F28E-5D84-4DC9-85E9-982D16665E54', 
         'Initial load (154 total rows, file 1 of 1) for table TRefProductLink',
         466, 
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
-- #Rows Exported: 154
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
