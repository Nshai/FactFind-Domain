USE [Administration]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------
/*
29/03/2018 - V1.0
ALM - CREATED NEW SCRIPT TO ACCOMODATE WEALTH AND MORTAGE TENANTS AS WELL AS HAVING THE ABILITY TO CLONE FROM ANOTHER ACCOUNT IF REQUIRED
ADDED VALIDATION CHECKS TO ENSURE ALL CLONED ACCOUNTS EXISTS BEFORE RUNNING THROUGH THE IMPLMENTATION
28/06/2019: IP-55689
RUI - Added  @NewTenantId, @SourceIndigoClientId to spCustomMegaConfigScript
*/
-------------------

CREATE PROCEDURE [dbo].[spCustomConfigureTenant_Advanced] 
/*parameters to help with defining the tenants*/ 
@TenantName varchar(255)
,@PrimaryContact varchar(255)
,@TelephoneNumber varchar(255)
,@EmailAddress varchar(255)
,@FSANumber varchar(255)
,@MCCBNumber varchar(255)=''
,@AddressLine1 varchar(255)
,@AddressLine2 varchar(255)
,@AddressLine3 varchar(255)
,@AddressLine4 varchar(255)
,@CityTown varchar(255)
,@County varchar(255)=''
,@Postcode varchar(255) 
,@SourceIndigoClientId bigint
,@IsCloneOf bigint
,@MaxUsersWithLoginAccess bigint

AS 
BEGIN

RAISERROR('This proc is DEPRECATED. Please use DataImport2..spCustomConfigureTenant_Advanced',16,1)
RETURN

/*
-- lets create the tenant account 
Declare @RefEnvironmentId bigint, @ExpiryDate datetime, @NewTenantGUID varchar(255),@NewTenantId bigint 
Declare @ParentGroupingID bigint, @CountyId bigint --, @SourceIndigoClientId bigint -ALM - DECLARED UP TOP - 29/03/2018
Declare @CloneAccountName VARCHAR(250) --ALM - ADDED FOR CHECKS BELOW - 29/03/2018

--Select @SourceIndigoClientId=IndigoClientId from administration..TSourceIndigoClient --ALM - COMMENTED OUT AS NEW IMP S/S PASSES IN VARIABLE

--ADDED CONDITION TO CHECK IF ACCOUNT IS TO BE CLONED FROM ANOTHER ACCOUNT OTHER THAN THE WEALTH OR MORTGAGE ACCOUNTS - ALM - 29/03/2018
--VALIDATE IF CLONE TENANT CAN BE FOUND
IF (@IsCloneOf > 0)
BEGIN
Set @SourceIndigoClientId = 0
Select @SourceIndigoClientId = IndigoClientId 
FROM Administration..TIndigoClient WHERE IndigoClientId = @IsCloneOf

IF (isnull(@SourceIndigoClientId,0)=0) 
Begin 
PRINT 'Clone Tenant not found. Check Tenant ID' 
RETURN (0) 
END
END

--VALIDATE IF BASE TENANT CAN BE FOUND
IF (@IsCloneOf = 0)
BEGIN
SET @CloneAccountName = 'NOT_FOUND'
SELECT @CloneAccountName = Identifier
FROM Administration..TIndigoClient WHERE IndigoClientId = @SourceIndigoClientId

IF @CloneAccountName = 'NOT_FOUND' 
Begin 
PRINT 'Base Tenant not found. Check Tenant ID' 
RETURN (0) 
END
END


SELECT @CloneAccountName = Identifier from Administration..TIndigoClient WHERE IndigoClientId = @SourceIndigoClientId
PRINT 'Cloning your new Tenant based off of ' + @CloneAccountName + '''s Account. Tenant ' + CONVERT(VARCHAR(250),@SourceIndigoClientId)
--END OF CHECKS - ALM - 29/03/2018


Set @RefEnvironmentId=1 --site 10 
Set @ExpiryDate=DATEADD(yyyy,1,GetDate()) -- we add a year on 

Select @NewTenantGUID=NEWID() 

if (@County!='') 
Begin 
Select @CountyId=RefCountyId from CRM..TRefCounty where CountyName=@County 

if (isnull(@CountyId,0)=0) 
Begin 
Print 'County not recognised' 
Return (0) 
End 
End 

If LEN(@TenantName)<1 OR LEN(@PrimaryContact)<1 
Begin 
Select 'No tenant name specified or primary contact not provided' 
End 


Insert Into Administration..TIndigoClient 
(Identifier,Status,PrimaryContact,PhoneNumber,EmailAddress,NetworkId,FSA,IOProductType,ExpiryDate,AddressLine1,AddressLine2,AddressLine3,AddressLine4, 
CityTown,County,Postcode,Country,IsNetwork, FirmSize,Specialism,SupportLevel,EmailSupOptn,SupportEmail,TelSupOptn,SupportTelephone, 
SessionTimeout,LicenceType, MaxULAGCount, IsIndependent, ServiceLevel, CaseLoggingOption, [Guid], RefEnvironmentId, IsPortfolioConstructionProvider, IsAuthorProvider,IsAtrProvider, ConcurrencyId, UADRestriction, AdviserCountRestrict) 




Values 
(@TenantName, 'active', @PrimaryContact, @TelephoneNumber, @EmailAddress,NULL,@FSANumber,'enterprise',@ExpiryDate,@AddressLine1,@AddressLine2,@AddressLine3,@AddressLine4, 
@CityTown,@CountyId,@Postcode, 1,0,'4-10 registered individuals','generalist','silver','standard','iosupport@intelliflo.com', 'standard','0330 102 8400', 
60,'standard',@MaxUsersWithLoginAccess,1,NULL,1,@NewTenantGUID,@RefEnvironmentId,0,0,0,1,0,0 --ALM - 02/10/2014 - REMOVED ADDITION OF EXTRA LICENCE AGAINST @MaxUsersWithLoginAccess
) 

Select @NewTenantId=SCOPE_IDENTITY() 

-- To Assign the Modern Skin to Tenant added. 
Declare @themeId uniqueidentifier 
select @themeId = ThemeId from administration..TTheme where ThemeId = '00000000-0000-0000-0000-000000000002' 

if (@themeId is not null) 
BEGIN 
-- Create an Entry in TAllocatedTheme 

INSERT INTO [Administration].[dbo].[TAllocatedTheme] 
([AllocatedThemeId] 
,[ThemeId] 
,[TenantId] 
,[IsActive]) 
VALUES 
(NEWID() 
,@themeId 
,@NewTenantId 
,1) 
END 

-- lets do the full licencse type 

Insert into administration..TIndigoClientLicense(IndigoClientId,LicenseTypeId,Status,MaxConUsers,MaxULAGCount, 
UADRestriction,MaxULADCount,AdviserCountRestrict,MaxAdviserCount,MaxFinancialPlanningUsers, ConcurrencyId) 
Values(@NewTenantId, 1,1,NULL,@MaxUsersWithLoginAccess, 0,0,0,0,0,1) --ALM - 02/10/2014 - REMOVED ADDITION OF EXTRA LICENCE AGAINST @MaxUsersWithLoginAccess

-- lets create the combined recrord 
exec administration..SpCustomCreateIndigoClientCombined @NewTenantId, '0' 

-- lets copy the password policy from base account 
Insert into administration..TPasswordPolicy (Expires,ExpiryDays,UniquePasswords,MaxFailedLogins,AllowExpireAllPasswords, 
AllowAutoUserNameGeneration,IndigoClientId,ConcurrencyId) 
SELECT Expires,ExpiryDays,UniquePasswords,MaxFailedLogins,AllowExpireAllPasswords, 
AllowAutoUserNameGeneration,@NewTenantId,ConcurrencyId from administration..TPasswordPolicy WHERE indigoclientid=@SourceIndigoClientId 


-- Create the Grouping 
EXEC administration..spCustomCreateGroupingForNewTenant @NewTenantId, @SourceIndigoClientId

-- create the Group 
EXEC administration..spCustomCreateGroupForNewTenant @NewTenantId, @SourceIndigoClientId

-- ok lets now do the roles 
EXEC administration..spCustomCreateRolesForNewTenant @NewTenantId, @SourceIndigoClientId

-- Fill up some role and group related variables to make the following script work
DECLARE @NewGroupId BIGINT, @RoleId BIGINT, @CorporateId BIGINT, @AdministratorUserId bigint

SELECT @NewGroupId=GroupId FROM Administration..TGroup WHERE IndigoClientid=@NewTenantId AND Identifier LIKE 'Organisation'
SELECT @RoleId = RoleId FROM Administration..TRole WHERE IndigoClientid=@NewTenantId AND Identifier LIKE 'System Administrator'
SELECT @CorporateId = CorporateId FROM CRM..TCorporate WHERE IndClientid=@NewTenantId AND CorporateName LIKE 'Organisation'

Exec administration..SpCustomCreateIntellifloSupportUser @NewTenantId 
set @AdministratorUserId = (select MIN(userid) from administration..TUser where IndigoClientId = @NewTenantId AND RefUserTypeId = 6)
-- create a second support user
Exec administration..SpCustomCreateIntellifloSupportUser @NewTenantId 

-- lets create the corporate client for the tennant contact 
Declare @NewTenantCRMContactId bigint 

INSERT INTO CRM..TCorporate (IndClientId, CorporateName) 
VALUES (@NewTenantId, @TenantName) 

SET @CorporateId=SCOPE_IDENTITY() 

INSERT INTO CRM..TCRMContact (RefCRMContactStatusId, CorporateId, ArchiveFG, CorporateName, 
originaladviserCRMID, CurrentAdviserCRMId, CRMContactType, IndClientId, InternalContactFG, CreatedDate, externalreference, concurrencyid) 
Values (1,@CorporateId,0, @TenantName, 0,0,3,@NewTenantId, 1,getDate(),null,1) 

SET @NewTenantCRMContactId=SCOPE_IDENTITY() 

UPDATE administration..TindigoClient SET PrimaryGroupId=@NewGroupId,contactid=@NewTenantCRMContactId WHERE indigoclientid=@NEwTenantId 

-- letss do the statushistory 
Insert into administration..TOrganisationStatusHistory(IndigoClientId, Identifier, changedatetime, changeuser) 
values (@NewTenantId, 'active',getdate(),@AdministratorUserId) 

-- lets do administration standing data 
INSERT INTO administration..TIndClientCommissionDef (IndigoClientId,AllowClawbackFG,DateOrder,PayCurrentGroupFG,RecalcIntroducerSplitFG,RecalcPractPercentFG,DefaultPayeeEntityId,PMMaxDiffAmount,PMUseLinkProviderFG, 
PMUseLookupFG,PMMatchSurnameFirstFG,PMMatchSurnameLastFG,PMMatchCompanyNameFG,CMUseLinkProviderFG,CMProvDescLength,CMDateRangeUpper, 
CMDateRangeLower,MinBACSAmount,ConcurrencyId) 
SELECT @NewTenantId,AllowClawbackFG,DateOrder,PayCurrentGroupFG,RecalcIntroducerSplitFG,RecalcPractPercentFG,DefaultPayeeEntityId,PMMaxDiffAmount,PMUseLinkProviderFG, 
PMUseLookupFG,PMMatchSurnameFirstFG,PMMatchSurnameLastFG,PMMatchCompanyNameFG,CMUseLinkProviderFG,CMProvDescLength,CMDateRangeUpper, 
CMDateRangeLower,MinBACSAmount,ConcurrencyId FROM administration..TIndClientCommissionDef WHERE IndigoClientId=@SourceIndigoClientId 

INSERT INTO administration..trunning(RebuildKeys,IndigoClientId,ConcurrencyId) 
SELECT RebuildKeys,@NewTenantId,ConcurrencyId FROM Administration..TRunning WHERE IndigoClientId=@SourceIndigoClientId 

-- Author 
Insert into Author..TParagraphType (Identifier,IndigoClientId,Extensible,ConcurrencyId) 
select Identifier,@NewTenantId,Extensible,ConcurrencyId from Author..TParagraphType where indigoclientid=@SourceIndigoClientId 

-- commissions 

insert into commissions..TPotMatchTimetable (IndClientId,RepeatCount,RefPotMatchTimetableTypeId,Extensible,ConcurrencyId) 
select @NewTenantId,RepeatCount,RefPotMatchTimetableTypeId,Extensible,ConcurrencyId from commissions..TPotMatchTimetable where indclientid=@SourceIndigoClientId 

insert into commissions..TPeriodComHist (IndClientId,StartDatetime,EndDatetime,RunDatetime,UserId,Extensible,ConcurrencyId) 
Values (@NewTenantID, GetDate(), null, null, null, null, 1) 

-- compliance 

insert into compliance..TRefCorrespondenceType (CorrespondenceType,IndClientId,ConcurrencyId) 
select CorrespondenceType,@NewTenantID,ConcurrencyId from compliance..TRefCorrespondenceType where IndClientId=@SourceIndigoClientId 

insert into compliance..TRefFileCheckFailStatus(FileCheckFailStatus,IndClientId,ConcurrencyId) 
select FileCheckFailStatus,@NewTenantID ,ConcurrencyId from compliance..TRefFileCheckFailStatus where IndClientId=@SourceIndigoClientId 

insert into compliance..TRefRiskStatus (RiskStatusDescription,RefRiskCategoryId,IsDisabled,IndClientId,ConcurrencyId) 
select RiskStatusDescription,RefRiskCategoryId,IsDisabled,@NewTenantID,ConcurrencyId from compliance..TRefRiskStatus where IndClientId=@SourceIndigoClientId 

insert into compliance..TRefTrainingCourse (IndClientId,CourseName,CPDHours,IsProductRelated,RefPlanTypeId, 
RefCourseCategoryId,CourseAvailableDate,CourseExpiryDate,CourseNotes,ConcurrencyId) 
Select @NewTenantId,CourseName,CPDHours,IsProductRelated,RefPlanTypeId, 
RefCourseCategoryId,CourseAvailableDate,CourseExpiryDate,CourseNotes,ConcurrencyId from compliance..TRefTrainingCourse 
where IndClientId=@SourceIndigoClientId 

-- Tcompliance Set up is dealt with later 
Insert into Compliance..TComplianceSetup (IndClientId) 
Values(@NEwTenantID) 

-- CRM 

insert into CRM..TRefAccType(IndClientId,Name,Description,ActiveFG,ConcurrencyId) 
select @NEwTenantId,Name,Description,ActiveFG,ConcurrencyId from CRM..TRefAccType where IndClientId=@SourceIndigoClientId 

insert into crm..TRefAccUse(IndClientId,AccountUseDesc,ConcurrencyId) 
select @NEwTenantId,AccountUseDesc,ConcurrencyId from crm..TRefAccUse where IndClientId=@SourceIndigoClientId 

insert into CRM..TRefCategoryAM(Description,ArchiveFG,IndClientId,ConcurrencyId) 
select Description,ArchiveFG,@NEwTenantId,ConcurrencyId from CRM..TRefCategoryAM where IndClientId=@SourceIndigoClientId 

insert into CRM..TRefIntroducerType (IndClientId,ShortName,LongName,MinSplitRange,MaxSplitRange, 
DefaultSplit,RenewalsFG,ArchiveFG,ConcurrencyId) 
select @NewTenantID,ShortName,LongName,MinSplitRange,MaxSplitRange, 
DefaultSplit,RenewalsFG,ArchiveFG,ConcurrencyId from CRM..TRefIntroducerType where IndClientId=@SourceIndigoClientId 

insert into CRM..TRefOpportunityStage (IndClientId,Description,Probability,OpenFG,ClosedFG,WonFG,ConcurrencyId) 
select @NewTenantID,Description,Probability,OpenFG,ClosedFG,WonFG,ConcurrencyId from CRM..TRefOpportunityStage where IndClientId=@SourceIndigoClientId 

insert into CRM..TRefPaymentType (IndClientId,Name,Description,ActiveFG,ConcurrencyId) 
select @NewTenantId, Name,Description,ActiveFG,ConcurrencyId from CRM..TRefPaymentType where IndClientId=@SourceIndigoClientId 

insert into CRM..TRefShowTimeAs (Description,Color,FreeFG,IndClientId,ConcurrencyId) 
select Description,Color,FreeFG, @NEwTenantId, ConcurrencyId from CRM..TRefShowTimeAs where IndClientId=@SourceIndigoClientId 

insert into CRM..TRefServiceStatus (ServiceStatusName,IndigoClientId,ConcurrencyId) 
select ServiceStatusName,@NewTenantId,ConcurrencyId from CRM..TRefServiceStatus where IndigoClientId=@SourceIndigoClientId 

insert into CRM..TPostCodeAllocation (IndigoClientId,MaxDistance,AllocationTypeId) 
select @NEwTenantID, MaxDistance,AllocationTypeId from CRM..TPostCodeAllocation where IndigoClientId=@SourceIndigoClientId 

Declare @ActivityCategoryParentId bigint 

-- Activity category stuff is moved to SpCustomMegaConfigScript (AME-424)

-- lets do the fact find search stuff 

insert into CRM..TFactFindSearch(RefFactFindSearchTypeId,IndigoClientId, concurrencyid) 
select RefFactFindSearchTypeId,@NEwTenantId, concurrencyid from CRM..TFactFindSearch where indigoclientid=@SourceIndigoClientId 

--lets add a default atr risk category 
INSERT into FactFind..TAtrCategory(Guid,TenantId,TenantGuid,Name,IsArchived,ConcurrencyId) 
SELECT newid(),@SourceIndigoClientId,Guid,'Default',0,1 
FROM Administration..TIndigoClient 
WHERE IndigoClientId=@SourceIndigoClientId

--Mortgage Checklist Question and Mortgage checklist Category data
EXEC administration..SpCreateMortgageChecklist @SourceIndigoClientId, @NewTenantId
-- lets do the types 
Declare @FactFindSearchId bigint, @RefFactFindSearchTypeId bigint 

-- lets copy the hierarchy 
DECLARE factfindsearch_cursor CURSOR 
FOR SELECT FactFindSearchId, RefFactFindSearchTypeId FROM CRM..TFactFindSearch 
where indigoclientid=@NewTenantId 
OPEN factfindsearch_cursor 

FETCH NEXT FROM factfindsearch_cursor Into @FactFindSearchId, @RefFactFindSearchTypeId 

WHILE @@FETCH_STATUS = 0 
BEGIN 
Insert into CRM..TFactFindSearchPlanType (FactFindSearchId,RefPlanTypeId,ConcurrencyId) 
Select @FactFindSearchId,RefPlanTypeId,A.ConcurrencyId from CRM..TFactFindSearchPlanType A 
Inner Join CRM..TFactFindSearch B on a.factfindsearchid=b.factfindsearchid 
where IndigoClientId=@SourceIndigoClientId and b.RefFactFindSearchTypeId=@RefFactFindSearchTypeId 

FETCH NEXT FROM factfindsearch_cursor Into @FactFindSearchId, @RefFactFindSearchTypeId 
END 

CLOSE factfindsearch_cursor 
DEALLOCATE factfindsearch_cursor 

-- documentmanagement 
insert into documentmanagement..TCategory (Identifier,Descriptor,Notes,IndigoClientId,Archived,ConcurrencyId) 
select Identifier,Descriptor,Notes,@NewTenantId,Archived,ConcurrencyId from documentmanagement..TCategory where IndigoClientId=@SourceIndigoClientId 

insert into documentmanagement..TSubCategory (Identifier,Descriptor,Notes,IndigoClientId,Archived,ConcurrencyId) 
select Identifier,Descriptor,Notes,@NewTenantId,Archived,ConcurrencyId from documentmanagement..TSubCategory where IndigoClientId=@SourceIndigoClientId 

-- lets mega escript this bad boy 
-- RUI 28/06/2019: IP-55689 - Added  @NewTenantId, @SourceIndigoClientId
exec administration..spCustomMegaConfigScript @NewTenantId, @SourceIndigoClientId


--ALM - ADDED AUTO DOC STORAGE ALLOCATION (02/09/2015)
declare @DocStorageValue bigint 

--ALM - Increased Storage from 200MB to 400MB per licence (03/02/2016)
Set @DocStorageValue = (419430400 * @MaxUsersWithLoginAccess)

insert into Documentmanagement..tdocstorage (IndigoClientId, SpaceAllocated, SpaceUsed, ConcurrencyId) 
Select @NewTenantId, @DocStorageValue, 0,1

--ALM - REMOVED AND REPLACED WITH SCRIPT ABOVE (02/09/2015)
-- insert into documentmanagement..tdocstorage(indigoclientid, spaceallocated, spaceused) 
-- values (@NewTenantId, '10000','0') 

-- lets do the account type 

INSERT INTO crm..taccounttype(AccountTypeName, IsForCorporate, IsForIndividual, IsNotModifiable, IsArchived, IndigoClientId) 
select AccountTypeName, IsForCorporate, IsForIndividual, IsNotModifiable, IsArchived, @NewTenantId 
From administration..TIndigoClient a 
inner join crm..taccounttype b on a.indigoclientid=b.indigoclientid 
Where a.indigoclientid=@SourceIndigoClientId 

-- INSERT - data for system defined advise payment types into TAdvisePaymentType 
IF EXISTS (SELECT * FROM policymanagement.sys.objects WHERE object_id = OBJECT_ID(N'[policymanagement].[dbo].[TAdvisePaymentType]') AND type in (N'U')) 
BEGIN 
--(exclude 'By Provider')
INSERT INTO policymanagement..TAdvisePaymentType(TenantId,IsArchived,Name,IsSystemDefined) 
SELECT @NewTenantId, 0, TRefAdvisePaymentType.Name, 1 
FROM policymanagement..TRefAdvisePaymentType WHERE TRefAdvisePaymentType.Name NOT IN ('By Provider')

--(include 'By Provider')
DECLARE @RefAdvisePaidById bigint
SELECT @RefAdvisePaidById = RefAdvisePaidById FROM policymanagement..TRefAdvisePaidBy WHERE Name = 'Provider'

INSERT INTO policymanagement..TAdvisePaymentType(TenantId,IsArchived,Name,IsSystemDefined, RefAdvisePaidById) 
SELECT @NewTenantId, 0, TRefAdvisePaymentType.Name, 1, @RefAdvisePaidById
FROM policymanagement..TRefAdvisePaymentType WHERE TRefAdvisePaymentType.Name IN ('By Provider')

END 
-- END OF INSERT into TAdvisePaymentType 

-- INSERT - INTO Audit table:TAdvisePaymentTypeAudit for the above inserted data 
IF EXISTS (SELECT * FROM policymanagement.sys.objects WHERE object_id = OBJECT_ID(N'[policymanagement].[dbo].[TAdvisePaymentTypeAudit]') AND type in (N'U')) 
BEGIN 
INSERT INTO policymanagement..TAdvisePaymentTypeAudit 
( 
TenantId, 
IsArchived, 
ConcurrencyId, 
AdvisePaymentTypeId, 
StampAction, 
StampDateTime, 
StampUser, 
Name, 
IsSystemDefined, 
RefAdvisePaidById
) 
SELECT 
TenantId 
,IsArchived 
,ConcurrencyId 
,AdvisePaymentTypeId 
,'C' 
,getdate() 
,0 
,Name 
,IsSystemDefined
,RefAdvisePaidById 
FROM policymanagement..TAdvisePaymentType 
WHERE policymanagement..TAdvisePaymentType.TenantId = @NewTenantId 
END 
-- END OF INSERT - INTO Audit table

-- INSERT - data for system defined rules into TAdviseFeeChargingType 
IF EXISTS (
SELECT *
FROM policymanagement.sys.objects
WHERE object_id = OBJECT_ID(N'[policymanagement].[dbo].[TAdviseFeeChargingType]')
AND type IN (N'U')
)
BEGIN
INSERT INTO policymanagement..TAdviseFeeChargingType (
RefAdviseFeeChargingTypeId
,TenantId
,IsArchived
,ConcurrencyId
,GroupId
)
SELECT RefAdviseFeeChargingTypeId
,@NewTenantId
,0
,0
,NULL
FROM policymanagement..TRefAdviseFeeChargingType
END
-- END OF INSERT into TAdviseFeeChargingType

-- INSERT - INTO Audit table:TAdviseFeeChargingTypeAudit for the above inserted data 
IF EXISTS (
SELECT *
FROM policymanagement.sys.objects
WHERE object_id = OBJECT_ID(N'[policymanagement].[dbo].[TAdviseFeeChargingTypeAudit]')
AND type IN (N'U')
)
BEGIN
INSERT INTO policymanagement..TAdviseFeeChargingTypeAudit (
RefAdviseFeeChargingTypeId
,TenantId
,IsArchived
,ConcurrencyId
,AdviseFeeChargingTypeId
,StampAction
,StampDateTime
,StampUser
,GroupId
)
SELECT RefAdviseFeeChargingTypeId
,TenantId
,IsArchived
,ConcurrencyId
,AdviseFeeChargingTypeId
,'C'
,GETDATE()
,0
,GroupId
FROM policymanagement..TAdviseFeeChargingType
WHERE policymanagement..TAdviseFeeChargingType.TenantId = @NewTenantId
END
-- END OF INSERT - INTO Audit table TAdviseFeeChargingTypeAudit


PRINT 'Step 17: Insert A System User for this tenant' 
EXEC administration..nio_SpCustomAddSystemUserForTenant @NewTenantId
-- INSERT - data for system defined rules into TTenantRuleConfiguration 
IF EXISTS (SELECT * FROM policymanagement.sys.objects WHERE object_id = OBJECT_ID(N'[policymanagement].[dbo].[TTenantRuleConfiguration]') AND type in (N'U')) 
BEGIN 
INSERT INTO policymanagement..TTenantRuleConfiguration(RefRuleConfigurationId,IsConfigured,TenantId) 
SELECT TRefRuleConfiguration.RefRuleConfigurationId, DefaultConfiguration, @NewTenantId 
FROM policymanagement..TRefRuleConfiguration 
END 
-- END OF INSERT into TTenantRuleConfiguration 

-- INSERT - INTO Audit table:TTenantRuleConfigurationAudit for the above inserted data 
IF EXISTS (SELECT * FROM policymanagement.sys.objects WHERE object_id = OBJECT_ID(N'[policymanagement].[dbo].[TTenantRuleConfigurationAudit]') AND type in (N'U')) 
BEGIN 
INSERT INTO policymanagement..TTenantRuleConfigurationAudit 
( 
TenantRuleConfigurationId, 
RefRuleConfigurationId, 
IsConfigured, 
TenantId,
ConcurrencyId, 
StampAction, 
StampDateTime, 
StampUser
) 
SELECT 
TenantRuleConfigurationId, 
RefRuleConfigurationId,
0, 
TenantId,
ConcurrencyId , 
'C' , 
getdate() , 
0 
FROM policymanagement..TTenantRuleConfiguration 
WHERE policymanagement..TTenantRuleConfiguration.TenantId = @NewTenantId 
END 
-- END OF INSERT - INTO Audit table

PRINT 'Step 17: Safely insert any missing Third Party Integration Configuration data'
EXEC PolicyManagement..SpCustomSetupThirdPartyIntegrationConfigurationData @SourceIndigoClientId, @NewTenantId

-- TIntegrationType table is populated which is required for the OBP export functionality to work
insert into crm..TIntegrationType(ConcurrencyId,TenantId,IntegrationTypeName,IsEnabled)
select 1,@NewTenantId,'OBPExport',1

-- Inserting UIDomainFieldAttribute config defaults values
EXEC Administration..SpNCreateUpdateUIDomainFieldAttribute @NewTenantID, 'Opportunity', 'PropositionType', 'IsRequired', 'false', 0

exec administration..spCustomResetDefaultDashboards @NewTenantID, @SourceIndigoClientId

--Add mapping for Sub PlanTypes to Opportunity type entries in the mapping table for the new tenant
EXEC Administration..SpNCreateOpportunityToPlanTypeMapping @NewTenantID

-- Inserting default data into TAdviseFeeType for new tenant from base account (SourceIndigoClientId)
EXEC administration..spCustomDefaultAdviseFeeType @NewTenantID, @SourceIndigoClientId
*/

END
GO