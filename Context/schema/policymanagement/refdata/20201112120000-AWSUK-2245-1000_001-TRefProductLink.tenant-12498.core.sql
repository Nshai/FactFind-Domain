 
-----------------------------------------------------------------------------
-- Table: PolicyManagement.TRefProductLink
--    Join: join tapplicationlink l on l.ApplicationLinkId = TRefProductLink.ApplicationLinkId
--   Where: WHERE l.IndigoClientId = 12498
-----------------------------------------------------------------------------
 
 
USE PolicyManagement
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'B8A4F28E-5D84-4DC9-85E9-982D16665E54'
     AND TenantId = 12498
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
        SELECT 645367,105450,47, 'QuoteSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645397,105450,47, 'ApplicationSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645427,105450,47, 'PlatformSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645368,105450,81, 'QuoteIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645398,105450,81, 'ApplicationIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645428,105450,81, 'PlatformIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645369,105450,82, 'QuoteIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645399,105450,82, 'ApplicationIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645429,105450,82, 'PlatformIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645370,105450,83, 'QuoteIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645400,105450,83, 'ApplicationIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645430,105450,83, 'PlatformIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645383,105449,27, 'ApplicationISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645413,105449,27, 'PlatformISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645384,105449,28, 'ApplicationGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645414,105449,28, 'PlatformGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645355,105449,47, 'QuoteSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645385,105449,47, 'ApplicationSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645415,105449,47, 'PlatformSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645356,105449,81, 'QuoteIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645386,105449,81, 'ApplicationIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645416,105449,81, 'PlatformIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645357,105449,82, 'QuoteIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645387,105449,82, 'ApplicationIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645417,105449,82, 'PlatformIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645358,105449,83, 'QuoteIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645388,105449,83, 'ApplicationIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645418,105449,83, 'PlatformIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645363,105448,47, 'QuoteSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645393,105448,47, 'ApplicationSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645423,105448,47, 'PlatformSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645364,105448,81, 'QuoteIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645394,105448,81, 'ApplicationIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645424,105448,81, 'PlatformIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645365,105448,82, 'QuoteIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645395,105448,82, 'ApplicationIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645425,105448,82, 'PlatformIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645366,105448,83, 'QuoteIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645396,105448,83, 'ApplicationIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645426,105448,83, 'PlatformIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645377,105447,27, 'ApplicationISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645407,105447,27, 'PlatformISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645378,105447,28, 'ApplicationGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645408,105447,28, 'PlatformGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645351,105447,47, 'QuoteSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645379,105447,47, 'ApplicationSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645409,105447,47, 'PlatformSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645352,105447,81, 'QuoteIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645380,105447,81, 'ApplicationIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645410,105447,81, 'PlatformIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645353,105447,82, 'QuoteIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645381,105447,82, 'ApplicationIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645411,105447,82, 'PlatformIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645354,105447,83, 'QuoteIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645382,105447,83, 'ApplicationIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645412,105447,83, 'PlatformIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645359,105446,47, 'QuoteSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645389,105446,47, 'ApplicationSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645419,105446,47, 'PlatformSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645360,105446,81, 'QuoteIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645390,105446,81, 'ApplicationIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645420,105446,81, 'PlatformIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645361,105446,82, 'QuoteIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645391,105446,82, 'ApplicationIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645421,105446,82, 'PlatformIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645362,105446,83, 'QuoteIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645392,105446,83, 'ApplicationIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645422,105446,83, 'PlatformIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645371,105445,27, 'ApplicationISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645401,105445,27, 'PlatformISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645372,105445,28, 'ApplicationGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645402,105445,28, 'PlatformGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645347,105445,47, 'QuoteSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645373,105445,47, 'ApplicationSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645403,105445,47, 'PlatformSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645348,105445,81, 'QuoteIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645374,105445,81, 'ApplicationIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645404,105445,81, 'PlatformIncomeDrawdown(Capped)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645349,105445,82, 'QuoteIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645375,105445,82, 'ApplicationIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645405,105445,82, 'PlatformIncomeDrawdown(Flexible)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645350,105445,83, 'QuoteIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645376,105445,83, 'ApplicationIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645406,105445,83, 'PlatformIncomeDrawdown(Flexi-Access)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645342,105442,26, 'PlatformISA(Cash)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645328,105442,27, 'ApplicationISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645343,105442,27, 'PlatformISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645329,105442,28, 'ApplicationGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645344,105442,28, 'PlatformGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645319,105442,47, 'QuoteSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645330,105442,47, 'ApplicationSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645345,105442,47, 'PlatformSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645331,105442,80, 'ApplicationCashAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645346,105442,80, 'ApplicationCashAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645337,105441,26, 'PlatformISA(Cash)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645324,105441,27, 'ApplicationISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645338,105441,27, 'PlatformISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645325,105441,28, 'ApplicationGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645339,105441,28, 'PlatformGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645318,105441,47, 'QuoteSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645326,105441,47, 'ApplicationSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645340,105441,47, 'PlatformSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645327,105441,80, 'ApplicationCashAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645341,105441,80, 'ApplicationCashAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645332,105440,26, 'PlatformISA(Cash)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645320,105440,27, 'ApplicationISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645333,105440,27, 'PlatformISA(StocksAndShares)', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645321,105440,28, 'ApplicationGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645334,105440,28, 'PlatformGeneralInvestmentAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645317,105440,47, 'QuoteSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645322,105440,47, 'ApplicationSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645335,105440,47, 'PlatformSIPP', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645323,105440,80, 'ApplicationCashAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645336,105440,80, 'ApplicationCashAccount', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645252,105432,25, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645253,105432,58, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645254,105432,59, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645255,105432,60, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645256,105432,61, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645257,105432,62, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645258,105432,63, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645259,105432,64, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645260,105432,65, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645261,105432,66, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645262,105432,67, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645263,105432,68, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645264,105432,69, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645265,105432,70, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645266,105432,71, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645267,105432,72, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645268,105432,73, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645269,105432,74, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645270,105432,75, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645271,105432,76, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645272,105432,77, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645273,105432,78, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645179,105426,58, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645180,105426,59, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645181,105426,60, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645182,105426,61, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645183,105426,62, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645184,105426,63, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645185,105426,64, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645186,105426,65, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645187,105426,66, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645188,105426,67, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645189,105426,68, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645190,105426,69, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645191,105426,70, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645192,105426,71, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645193,105426,72, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645194,105426,73, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645195,105426,74, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645196,105426,75, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645197,105426,76, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645198,105426,77, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645199,105426,78, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645161,105425,1, 'QuotesTermAssurance', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645162,105425,2, 'QuotesConvertibleTerm', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645163,105425,3, 'QuotesPensionTermAssurance', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645164,105425,4, 'QuotesMortgageProtection', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645165,105425,6, 'QuotesFamilyIncomeBenefit', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645166,105425,7, 'QuotesIncomeProtection-OwnLife', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645167,105425,8, 'QuotesIncomeProtection-LifeOfAnother', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645168,105425,9, 'QuotesIncomeProtection-ProfessionalExpenses', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645169,105425,10, 'QuotesIncomeProtection-KeyPerson', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645170,105425,11, 'QuotesCriticalIllness', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645171,105425,12, 'QuotesWholeOfLife', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645172,105425,13, 'QuotesCriticalIllnessWithWholeOfLife', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645173,105425,14, 'QuotesSelfEmployedPersonalPensionPlan', '/origo/3.2/QNBRetirementIndividualQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645174,105425,15, 'QuotesEmployedPersonalPensionPlan', '/origo/3.2/QNBRetirementIndividualQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645175,105425,16, 'QuotesWithProfitsBond', '/origo/3.1/QNBInvestmentBondQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645176,105425,17, 'QuotesUnitLinkedBond', '/origo/3.1/QNBInvestmentBondQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645177,105425,18, 'QuotesDistributionBond', '/origo/3.1/QNBInvestmentBondQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645178,105425,19, 'QuotesUnitLinkedAndWithProfitBond', '/origo/3.1/QNBInvestmentBondQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645153,105424,1, 'QuotesTermAssurance', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645154,105424,2, 'QuotesConvertibleTerm', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645155,105424,4, 'QuotesMortgageProtection', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645156,105424,6, 'QuotesFamilyIncomeBenefit', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645157,105424,7, 'QuotesIncomeProtection-OwnLife', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645158,105424,8, 'QuotesIncomeProtection-LifeOfAnother', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645159,105424,9, 'QuotesIncomeProtection-ProfessionalExpenses', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645160,105424,10, 'QuotesIncomeProtection-KeyPerson', '/origo/3.2/QNBProtectionQuoteRequest.xsd',0,1 UNION ALL 
        SELECT 645243,105423,21, 'Quote LandlordBuildings&Contents', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645244,105423,22, 'Quote HouseholdBuildings&Contents', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645245,105423,23, 'Quote MortgageProtector', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645246,105423,24, 'Quote IncomeShield', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645221,105421,25, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645222,105421,58, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645223,105421,59, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645224,105421,60, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645225,105421,61, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645226,105421,62, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645227,105421,63, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645228,105421,64, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645229,105421,65, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645230,105421,66, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645231,105421,67, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645232,105421,68, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645233,105421,69, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645234,105421,70, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645235,105421,71, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645236,105421,72, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645237,105421,73, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645238,105421,74, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645239,105421,75, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645240,105421,76, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645241,105421,77, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645242,105421,78, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645200,105420,58, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645201,105420,59, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645202,105420,60, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645203,105420,61, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645204,105420,62, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645205,105420,63, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645206,105420,64, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645207,105420,65, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645208,105420,66, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645209,105420,67, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645210,105420,68, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645211,105420,69, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645212,105420,70, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645213,105420,71, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645214,105420,72, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645215,105420,73, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645216,105420,74, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645217,105420,75, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645218,105420,76, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645219,105420,77, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 UNION ALL 
        SELECT 645220,105420,78, 'ApplicationMortgage', '/origo/3.2/?.xsd',0,1 
 
        SET IDENTITY_INSERT TRefProductLink OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'B8A4F28E-5D84-4DC9-85E9-982D16665E54', 
         'Initial load (230 total rows, file 1 of 1) for table TRefProductLink',
         12498, 
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
-- #Rows Exported: 230
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:48PM
-----------------------------------------------------------------------------
