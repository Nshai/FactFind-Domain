 
-----------------------------------------------------------------------------
-- Table: Administration.TIndigoClient
--    Join: 
--   Where: WHERE IndigoClientId=12498
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'ACCAA50A-E80A-40FC-AF9C-433C6BB90C8A'
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
        SET IDENTITY_INSERT TIndigoClient ON; 
 
        ALTER TABLE TIndigoClient DROP CONSTRAINT [FK_TIndigoClient_PrimaryGroupId_GroupId]
 
        INSERT INTO TIndigoClient([IndigoClientId], [Identifier], [Status], [PrimaryContact], [ContactId], [PhoneNumber], [EmailAddress], [PrimaryGroupId], [NetworkId], [SIB], [MCCB], [FSA], [IOProductType], [ExpiryDate], [AddressLine1], [AddressLine2], [AddressLine3], [AddressLine4], [CityTown], [County], [Postcode], [Country], [IsNetwork], [SupportServiceId], [FirmSize], [Specialism], [OtherSpecialism], [SupportLevel], [EmailSupOptn], [SupportEmail], [TelSupOptn], [SupportTelephone], [AllowPasswordEmail], [SessionTimeout], [LicenceType], [MaxConUsers], [MaxULAGCount], [UADRestriction], [MaxULADCount], [AdviserCountRestrict], [MaxAdviserCount], [MaxFinancialPlanningUsers], [EmailFormat], [UserNameFormat], [NTDomain], [IsIndependent], [BrandDescriptor], [ServiceLevel], [HostingFg], [CaseLoggingOption], [Guid], [RefEnvironmentId], [IsPortfolioConstructionProvider], [IsAuthorProvider], [IsAtrProvider], [MortgageBenchLicenceCount], [ConcurrencyId], [MaxOutlookExtensionUsers], [MaxAdvisaCentaCoreUsers], [MaxAdvisaCentaCorePlusLifetimePlannerUsers], [MaxFeAnalyticsCoreUsers], [MaxVoyantUsers], [MaxAdvisaCentaFullUsers], [MaxAdvisaCentaFullPlusLifetimePlannerUsers], [MaxPensionFreedomPlannerUsers], [MaxSolutionBuilderUsers], [AdminEmail], [LEI], [RefTenantTypeId])
        SELECT 12498, 'Intelliflo Ltd (Wealth Account)', 'active', 'Emily Chapman',20210843, '', 'emily.chapman@intelliflo.com',13187,NULL, NULL, NULL, '123456', 'enterprise','Jul 24 2018  4:27PM', 'Intelliflo Ltd', '3rd Floor Drapers Court', '', '', 'Kingston', '65', 'KT1 2BQ', '1',0,NULL, '4-10 registered individuals', 'generalist', NULL, 'silver', 'standard', 'Please create a new case via the Community', 'standard', '0330 102 8400',1,60, 'standard',0,10,0,0,0,NULL,10, NULL, NULL, NULL,1, NULL,NULL,0,1,'14015FB2-5EDC-497E-ACD7-91925877F8DC',1,0,0,0,NULL,4,10,10,10,10,10,10,10,10,10, 'emily.chapman@intelliflo.com', NULL,3 
 
        ALTER TABLE TIndigoClient WITH NOCHECK ADD CONSTRAINT [FK_TIndigoClient_PrimaryGroupId_GroupId] FOREIGN KEY ([PrimaryGroupId]) REFERENCES dbo.TGroup([GroupId])
 
        SET IDENTITY_INSERT TIndigoClient OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'ACCAA50A-E80A-40FC-AF9C-433C6BB90C8A', 
         'Initial load (1 total rows, file 1 of 1) for table TIndigoClient',
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
-- #Rows Exported: 1
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
