 
-----------------------------------------------------------------------------
-- Table: Administration.TIndigoClient
--    Join: 
--   Where: WHERE IndigoClientId=466
-----------------------------------------------------------------------------
 
 
USE Administration
 
 
-- check if this script has already run
IF EXISTS (
   SELECT 1 FROM TExecutedDataScript 
   WHERE ScriptGuid = 'ACCAA50A-E80A-40FC-AF9C-433C6BB90C8A'
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
        SET IDENTITY_INSERT TIndigoClient ON; 
 
        ALTER TABLE TIndigoClient DROP CONSTRAINT [FK_TIndigoClient_PrimaryGroupId_GroupId]
 
        INSERT INTO TIndigoClient([IndigoClientId], [Identifier], [Status], [PrimaryContact], [ContactId], [PhoneNumber], [EmailAddress], [PrimaryGroupId], [NetworkId], [SIB], [MCCB], [FSA], [IOProductType], [ExpiryDate], [AddressLine1], [AddressLine2], [AddressLine3], [AddressLine4], [CityTown], [County], [Postcode], [Country], [IsNetwork], [SupportServiceId], [FirmSize], [Specialism], [OtherSpecialism], [SupportLevel], [EmailSupOptn], [SupportEmail], [TelSupOptn], [SupportTelephone], [AllowPasswordEmail], [SessionTimeout], [LicenceType], [MaxConUsers], [MaxULAGCount], [UADRestriction], [MaxULADCount], [AdviserCountRestrict], [MaxAdviserCount], [MaxFinancialPlanningUsers], [EmailFormat], [UserNameFormat], [NTDomain], [IsIndependent], [BrandDescriptor], [ServiceLevel], [HostingFg], [CaseLoggingOption], [Guid], [RefEnvironmentId], [IsPortfolioConstructionProvider], [IsAuthorProvider], [IsAtrProvider], [MortgageBenchLicenceCount], [ConcurrencyId], [MaxOutlookExtensionUsers], [MaxAdvisaCentaCoreUsers], [MaxAdvisaCentaCorePlusLifetimePlannerUsers], [MaxFeAnalyticsCoreUsers], [MaxVoyantUsers], [MaxAdvisaCentaFullUsers], [MaxAdvisaCentaFullPlusLifetimePlannerUsers], [MaxPensionFreedomPlannerUsers], [MaxSolutionBuilderUsers], [AdminEmail], [LEI], [RefTenantTypeId])
        SELECT 466, 'eValue', 'active', 'Simon Reeve',1567553, '0845 230 3700', 'iosupport@intelliflo.com',1756,NULL, '', '', '', 'enterprise','Nov 21 2008 12:00AM', 'IntelliFlo Ltd', '31-35 High Street', NULL, NULL, 'Kingston Upon Thames', '65', 'KT1 1TQ', '1',0,NULL, '1-3 registered individuals', 'generalist', NULL, 'silver', 'standard', 'Please create a new case via the Community', 'standard', '0330 102 8400',1,60, 'standard',0,2,0,0,0,NULL,NULL, NULL, NULL, NULL,1, NULL,NULL,0,0,'9D7C163A-1166-45E9-B9E7-712388CE038E',1,0,0,1,NULL,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, 'iosupport@intelliflo.com', NULL,3 
 
        ALTER TABLE TIndigoClient WITH NOCHECK ADD CONSTRAINT [FK_TIndigoClient_PrimaryGroupId_GroupId] FOREIGN KEY ([PrimaryGroupId]) REFERENCES dbo.TGroup([GroupId])
 
        SET IDENTITY_INSERT TIndigoClient OFF
 
        -- record execution so the script won't run again
        INSERT INTO TExecutedDataScript (ScriptGuid, Comments, TenantId, Timestamp) 
        VALUES (
         'ACCAA50A-E80A-40FC-AF9C-433C6BB90C8A', 
         'Initial load (1 total rows, file 1 of 1) for table TIndigoClient',
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
-- #Rows Exported: 1
-- Created by AndyF's RefDataExtractor, Nov 12 2020  3:47PM
-----------------------------------------------------------------------------
