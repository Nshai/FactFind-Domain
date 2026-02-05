USE [Administration]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SpCustomMegaConfigScript] 
		@IndigoClientId BIGINT = NULL
	, @SourceIndigoClientId BIGINT = NULL
    
As                      
BEGIN   
-------------------
/*
ALM - UPDATES MADE TO REMOVE CALL TO SpCustomConfigureAtrForIndigoClient WHICH CALLED SpCustomCreateIndigoClientPreference.  THIS IS NOW CALLED DIRECT FROM THIS SP AS PER REQUEST - IP-43205  
ALM - ADDED DEFAULT CATEGORY THAT WAS MISSING FROM ATR - IP-43868
28/06/2019: IP-55689
RUI - Added  @NewTenantId, @SourceIndigoClientId to spCustomMegaConfigScript
18/07/2019: IP-56983
RUI - Step 24: Clone remaining TIndigoClientPreference
*/
-------------------
-- Mega Script                      
                      
PRINT 'Step 1'                      
                      
DECLARE 
			@ActivityCategoryParent BIGINT
		, @SourceDatabase VARCHAR(50) = '' -- Required for spCustomConfigureDefaultOrganisationData
		, @StampActionCreate CHAR(1)
		, @StampDateTime DATETIME
		, @StampUserSystem CHAR(1) 
		, @TillinghastGuid uniqueidentifier  -- MOVED FROM SpCustomConfigureAtrForIndigoClient AS PER REQUEST - IP-43205
		, @IndigoClientGuid uniqueidentifier  -- MOVED FROM SpCustomConfigureAtrForIndigoClient AS PER REQUEST - IP-43205
		, @NewAtrCategoryGuid uniqueidentifier -- ADDED DEFAULT CATEGORY THAT WAS MISSING FROM IP-43205 CHANGE - ALM - IP-43868
		, @AtrCategoryId bigint -- ADDED DEFAULT CATEGORY THAT WAS MISSING FROM IP-43205 CHANGE - ALM - IP-43868
SELECT
	@StampActionCreate = 'C'
	, @StampDateTime = GETDATE()
	, @StampUserSystem = '0'
	, @TillinghastGuid = '9D7C163A-1166-45E9-B9E7-712388CE038E' -- MOVED FROM SpCustomConfigureAtrForIndigoClient AS PER REQUEST - ALM - IP-43205 
	, @NewAtrCategoryGuid = NEWID() -- ADDED DEFAULT CATEGORY THAT WAS MISSING FROM IP-43205 CHANGE - ALM - IP-43868

if @SourceIndigoClientId is null         
	SELECT @SourceIndigoClientId = IndigoClientId, @SourceDatabase = SourceDatabase FROM TSourceIndigoClient    

if @IndigoClientId is null               
	SELECT @IndigoClientId = max(indigoCLientId) from administration..TIndigoClient                      

-- Get Guid for our new indigoclient  -- MOVED FROM SpCustomConfigureAtrForIndigoClient AS PER REQUEST - IP-43205
SELECT @IndigoClientGuid = [Guid] FROM TIndigoClient WHERE IndigoClientId = @IndigoClientId  
                      
--check if this has already been run. Assume that it has if there are records in TRefPriority    
IF EXISTS (SELECT 1 FROM CRM..TRefPriority WHERE IndClientId = @IndigoClientId)    
begin    
 print 'Looks like MegaConfig has already been run for tenant ' + cast(@indigoclientid as varchar(10)) + ', aborted!'    
 return    
end    
    
-- Create Activity
exec spCustomCreateActivityForNewTenant @IndigoClientId, @SourceIndigoClientId
                      
exec crm..spcreaterefpriority 0,'High',@IndigoClientId                      
exec crm..spcreaterefpriority 0,'Medium',@IndigoClientId                      
exec crm..spcreaterefpriority 0,'Low',@IndigoClientId                      
                      
update administration..tindigoclient set supportemail='iosupport@intelliflo.com', supporttelephone='0330 102 8400' where indigoclientid=@IndigoClientId                      
                      
PRINT 'Step 2 : Fact Find to Library'                      
                      
EXEC DocumentManagement..SpCustomCreateFactFindFolder @IndigoClientId                      
                      
PRINT 'STEP 3 : Configure Script'                      
                      
Exec administration..spCustomConfigureDefaultOrganisationData @IndigoClientId, @SourceIndigoClientId , @SourceDatabase                    
                      
PRINT 'Step 4 : AssetCategories'                      
-- No longer required. Asset Categories are no longer tenant specific.    
--exec FactFind..SpCreateAssetCategoryForNewClients @IndigoClientId                      
                      
PRINT 'Step 5: ASsureweb'                      
-- Assureweb now being configured in SpCustomSetupThirdPartyIntegrationConfigurationData which is called from spCustomConfigureTenant                   
                    
PRINT 'Step 6: Document Statuses'                    
                    
EXEC DocumentManagement..spCustomGenerateDocumentStatusOrder @IndigoClientId                    
EXEC DocumentManagement..spCustomGenerateDocumentStatusToRole @IndigoClientId                    
EXEC DocumentManagement..spCustomGenerateBinderStatusToRole @IndigoClientId                    
EXEC DocumentManagement..spCustomGenerateDocumentDeleteRights @IndigoClientId                    
                          
PRINT 'Step 7: Mortgage Opportunity'                    
-- Logic for this step moved into [SpCustomInsertDefaultDataForIndigoClient]

IF DataImport2.dbo.fnGetSystemSetting('RegionCode') = 'GB' -- AWSUK-5739
BEGIN
PRINT 'Step 8: ATR'                  
--EXEC SpCustomConfigureAtrForIndigoClient @IndigoClientId  --REMOVED AS PER REQUEST - ALM - IP-43205            
--BEGIN >> MOVED FROM SpCustomConfigureAtrForIndigoClient AS PER REQUEST - ALM - IP-43205
	IF NOT EXISTS (SELECT 1 FROM TIndigoClientPreference WHERE IndigoClientId = @IndigoClientId AND PreferenceName = 'AtrProfileProvider')  
	BEGIN  
	 EXEC SpCustomCreateIndigoClientPreference 0, @IndigoClientId, @IndigoClientGuid, 'AtrProfileProvider', @TillinghastGuid, 0  
	END    
--END >> MOVED FROM SpCustomConfigureAtrForIndigoClient AS PER REQUEST - ALM - IP-43205

---------------------------------------------------------------------  
-- Add Default Question Category 
-- ADDED DEFAULT CATEGORY THAT WAS MISSING FROM IP-43205 CHANGE - ALM - IP-43868
---------------------------------------------------------------------  
	PRINT 'Step 8a: Adding ATR Category' 
	IF NOT EXISTS (SELECT 1 FROM FactFind..TAtrCategory WHERE TenantId = @IndigoClientId) 
	BEGIN  
	-- Create Default Category  
		INSERT FactFind..TAtrCategory([Guid], TenantId, TenantGuid, Name, IsArchived, ConcurrencyId)  
		SELECT @NewAtrCategoryGuid, @IndigoClientId, @IndigoClientGuid, 'Default', 0, 1  
		-- Get Id  
		SET @AtrCategoryId = SCOPE_IDENTITY()  
	-- Audit   
		EXEC FactFind..SpNAuditAtrCategory '0', @AtrCategoryId, 'C'  
		EXEC FactFind..SpCustomCreateAtrCategoryCombined '0', @NewAtrCategoryGuid  
	END
	END
	IF DataImport2.dbo.fnGetSystemSetting('RegionCode') != 'GB'
	BEGIN
	PRINT 'Step 8: No ATR setup for non-GB region'
	END --END AWSUK-5739

---------------------------------------------------------------------  

PRINT 'Step 9: ExWeb DocumentManagement Sub Categories'                
EXEC DocumentManagement..SpNCustomExWebDocumentCategories @IndigoClientId                    
                
PRINT 'Step 10: PreExisting Adviser'                
-- No longer required.
                
PRINT 'Step 11: PDF Templates (Portfolio Report)'                
EXEC Reporter..SpCustomCreatePDFTemplatesForIndigoClientId @IndigoClientId        
EXEC Reporter..SpCustomCopyPDFTemplateChartStyleForIndigoClientId @IndigoClientId, @SourceIndigoClientId         
EXEC Reporter..SpCustomCopyPDFTemplateStyleForIndigoClientId @IndigoClientId, @SourceIndigoClientId  
EXEC Reporter..SpCustomCreatePDFTemplateTypeSettingForIndigoClientId @IndigoClientId                
EXEC Reporter..SpCustomCopyPDFTemplateTypeForIndigoClientId  @IndigoClientId, @SourceIndigoClientId                 
        
-- glossary data        
IF NOT EXISTS (SELECT 1 FROM Reporter..TPdfTemplateGlossary WHERE IndigoClientId = @IndigoClientId)        
 INSERT INTO Reporter..TPDFTemplateGlossary (        
  RefPDFTemplateGlossaryId, IndigoClientId, [Description], GlossaryText, UseDefaultTextFg, Ordinal)        
 SELECT         
  RefPDFTemplateGlossaryId, @IndigoClientId, [Description], GlossaryText, 1, 0        
 FROM         
  Reporter..TRefPDFTemplateGlossary        
          
INSERT INTO Reporter..TRiskRange (IndigoClientId, RefRiskRangeTypeId, L1Operator, L1, L2Operator, L2)          
SELECT i.IndigoClientId, RefRiskRangeTypeId, L1Operator, L1, L2Operator, L2          
FROM TindigoClient i, Reporter..TRiskRange r          
WHERE r.IndigoClientId = 0          
AND i.IndigoClientId NOT IN (select indigoclientid from Reporter..triskrange group by indigoclientid)          
          
INSERT INTO Reporter..TRiskRangeLabel (IndigoClientId, BetterThanL1Label, BetterThanL1Colour, BetweenL1AndL2Label, BetweenL1AndL2Colour, WorseThanL2Label, WorseThanL2Colour)          
SELECT i.IndigoClientId, BetterThanL1Label, BetterThanL1Colour, BetweenL1AndL2Label, BetweenL1AndL2Colour, WorseThanL2Label, WorseThanL2Colour          
FROM TindigoClient i, Reporter..TRiskRangeLabel r          
WHERE r.IndigoClientId = 0          
AND i.IndigoClientId NOT IN (select indigoclientid from Reporter..TRiskRangeLabel group by indigoclientid)          
          
          PRINT 'Step 12:Configure advice case status changes'              
EXEC CRM..SpCustomConfigureAdviceCaseStatusChanges @IndigoClientId        
        
PRINT 'Step 13: Configure Compliance'              
EXEC Compliance.dbo.SpConfigureComplianceAdmin @IndigoClientId, @SourceIndigoClientId
        
PRINT 'Step 14: Configure CE Frequency for Active ICs'            
EXEC PolicyManagement.dbo.SpCustomConfigureCEFrequencyForActiveICs @IndigoClientId    
        
        
PRINT 'Step 15: Configure Axa Integration for Active ICs'         
declare @WrapperProviderId bigint, @RefApplicationId bigint        
        
select @WrapperProviderId = a.WrapperProviderId from policymanagement..tWrapperProvider a        
inner join policymanagement..trefprodprovider b on a.refprodproviderId = b.refprodproviderId        
inner join crm..tcrmcontact c on c.crmcontactid = b.crmcontactid        
inner join policymanagement..trefplantype d on a.refplantypeid = d.refplantypeid        
where c.corporatename ='elevate' and d.PlanTypeName = 'Wrap'        
        
--Setting STL Wrap begins here    
 PRINT 'Step 16: Configure STL Integration for Active ICs'         
    
 select @WrapperProviderId = a.WrapperProviderId from policymanagement..tWrapperProvider a        
 inner join policymanagement..trefprodprovider b on a.refprodproviderId = b.refprodproviderId        
 inner join crm..tcrmcontact c on c.crmcontactid = b.crmcontactid        
 inner join policymanagement..trefplantype d on a.refplantypeid = d.refplantypeid        
 where c.corporatename ='Standard Life' and d.PlanTypeName = 'Wrap'        
         
 select @RefApplicationId = IsNull(RefApplicationId,0)        
 from policymanagement..trefapplication        
 where ApplicationName = 'Standard Life'        
         
 --show Elevate as an integration
IF @RefApplicationId IS NOT NULL
BEGIN        
 exec PolicyManagement.dbo.spNCreateApplicationLink @StampUserSystem, @IndigoclientId, @RefApplicationId, 0,0,1, null        
END
            
PRINT 'Step 16: Valuation DocumentManagement Categories and SubCategories'                
EXEC DocumentManagement..SpCustomValuationDocumentCategories @IndigoClientId    
    
---------------------------------------------------------------------------    
--Step 17: Add Fact Find Type information.    
---------------------------------------------------------------------------    
print 'Step 17: Add Fact Find Type Details'
IF NOT EXISTS (SELECT 1 FROM FactFind..TFactFindType WHERE IndigoClientId = @IndigoClientId AND CRMContactType = 1)    
 EXEC FactFind..SpNCreateFactFindTypeReturnId 0, 'Personal', 'Personal', 1, @IndigoClientId    
     
IF NOT EXISTS (SELECT 1 FROM FactFind..TFactFindType WHERE IndigoClientId = @IndigoClientId AND CRMContactType = 3)    
 EXEC FactFind..SpNCreateFactFindTypeReturnId 0, 'Corporate', 'Corporate', 3, @IndigoClientId    
   
-- FF Document Disclosure Types     
IF NOT EXISTS (SELECT 1 FROM FactFind..TDocumentDisclosureType WHERE IndigoClientId = @IndigoClientId) BEGIN
	INSERT INTO FactFind..TDocumentDisclosureType (Name, IsArchived, IndigoClientId)
		-- Audit.
		OUTPUT inserted.ConcurrencyId, inserted.Name, inserted.IsArchived, inserted.IndigoClientId, inserted.DocumentDisclosureTypeId, @StampActionCreate, @StampDateTime, @StampUserSystem
		INTO FactFind..TDocumentDisclosureTypeAudit (ConcurrencyId, Name, IsArchived, IndigoClientId, DocumentDisclosureTypeId, StampAction, StampDateTime, StampUser)
	SELECT Name, 0, @IndigoClientId
	FROM FactFind..TDocumentDisclosureType 
	WHERE IndigoClientId = 0 AND IsArchived = 0	 	     
END     
         
PRINT 'Step 19: Add Event List template from Source to New Tenant.'                
EXEC CRM..spCustomCreateEventListTemplatesForNewTenant @IndigoClientId, @SourceIndigoClientId

PRINT 'Step 19.1: Add Event List template activities from Source to New Tenant.'                
EXEC CRM..spCustomCreateEventListTemplateActivitiesForNewTenant @IndigoClientId, @SourceIndigoClientId

PRINT 'Step 20: Add Plan Purpose and its related plan types'                
EXEC PolicyManagement..spCustomCreatePlanPurposeForNewTenant @IndigoClientId, @SourceIndigoClientId

PRINT 'Step 21: Add Plan Settings'                
EXEC Reporter..spCustomCreatePlanSettingsForNewTenant @IndigoClientId, @SourceIndigoClientId

Print 'Step 22: Make sure the tenant has a DocumentGeneratorVersion specified in TIndigoClientExtended'
EXEC [SpAdminCheckDocumentGeneratorVersion] @IndigoClientId

PRINT 'Step 23: Add default DPA Policy' 
 DECLARE @Statement1 VARCHAR(500) = 'I am aware of my/our rights under the data protection act and have given my express consent to be contacted in relation to my/our financial requirements.',
         @Statement2  VARCHAR(500) = 'I have given consent for you to hold my/our personal data as contained within this fact find and to share it with other companies for the express purpose of the arranging and administration of financial products.',
         @Statement3 VARCHAR(500) = 'I am aware that I have the right of access to information that the adviser holds on me/us. I am aware that the adviser reserves the right to charge an administration fee for the	provision of this information.'
 INSERT INTO DPA..TPolicy (TenantId, Identifier, CreationDate, Tag, Statement1, Statement2, Statement3, Statement4, Statement5, IsEditable)
 VALUES (@IndigoClientId, 'Default', GETDATE(), NULL, @Statement1, @Statement2, @Statement3, NULL, NULL, 0)
END

PRINT 'Step 24: Clone remaining TIndigoClientPreference - IP-56983' 

declare @SourceIndigoClientGuid uniqueidentifier
	-- Get Source GUID
	
	select @SourceIndigoClientGuid = [guid] from dbo.TIndigoClient where IndigoClientId = @SourceIndigoClientId

	-- Clone missing values
	insert into dbo.TIndigoClientPreference(IndigoClientId, IndigoClientGuid, PreferenceName, [Value], [Disabled], [Guid], ConcurrencyId)
	output 
		inserted.IndigoClientPreferenceId, inserted.IndigoClientId, inserted.IndigoClientGuid, inserted.PreferenceName, inserted.[Value], inserted.[Disabled], inserted.[Guid], inserted.ConcurrencyId
		, @StampActionCreate, @StampDateTime, @StampUserSystem
	into dbo.TIndigoClientPreferenceAudit(IndigoClientPreferenceId, IndigoClientId, IndigoClientGuid, PreferenceName, [Value], [Disabled], [Guid], ConcurrencyId
	, StampAction,StampDateTime,StampUser
	)
	select @IndigoClientId, @IndigoClientGuid, PreferenceName, [Value], 0, Newid(), 1
	from (
	select PreferenceName, Value from TIndigoClientPreference
	where IndigoClientId = @SourceIndigoClientId
	except
	select PreferenceName, Value from TIndigoClientPreference
	where IndigoClientId = @IndigoClientId)t

	-- Make sure TIndigoClientPreferenceCombined gets updated
	insert into TIndigoClientPreferenceCombined(IndigoClientPreferenceId, IndigoClientId, IndigoClientGuid, PreferenceName, [Value], [Disabled], [Guid], ConcurrencyId)
	output
		inserted.[Guid]
	, inserted.IndigoClientPreferenceId
	, inserted.IndigoClientId
	, inserted.IndigoClientGuid
	, inserted.PreferenceName
	, inserted.[Value]
	, inserted.[Disabled]
	, inserted.ConcurrencyId
	, @StampActionCreate, @StampDateTime, @StampUserSystem
	into TIndigoClientPreferenceCombinedAudit(
		[Guid]
	, IndigoClientPreferenceId
	, IndigoClientId
	, IndigoClientGuid
	, PreferenceName
	, [Value]
	, [Disabled]
	, ConcurrencyId
	, StampAction, StampDateTime, StampUser
	)
	select IndigoClientPreferenceId, IndigoClientId, IndigoClientGuid, PreferenceName, [Value], [Disabled], [Guid],1
	from TIndigoClientPreference
	where IndigoClientId = @IndigoClientId
	except
	select IndigoClientPreferenceId, IndigoClientId, IndigoClientGuid, PreferenceName, [Value], [Disabled], [Guid],1
	from TIndigoClientPreferenceCombined
	where IndigoClientId = @IndigoClientId

go
