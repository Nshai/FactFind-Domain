SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--drop PROCEDURE [dbo].[spCustomConfigureSIP]       
CREATE PROCEDURE [dbo].[spCustomConfigureSIP]       
/*parameters to help with defining the tenant*/      
@TenantName varchar(255), @PrimaryContact varchar(255), @TelephoneNumber varchar(255), @EmailAddress varchar(255), @FSANumber varchar(255),@MCCBNumber varchar(255)='',      
@AddressLine1 varchar(255),@AddressLine2 varchar(255) ,@AddressLine3 varchar(255), @AddressLine4 varchar(255), @CityTown varchar(255), @County varchar(255)='', @Postcode varchar(255), @MaxUsersWithLoginAccess bigint      
AS      
      
-- lets create the tenant account      
Select 'Validating Inputs'      
Declare @SimplyBizNetworkAccountTenantId bigint      
Declare @RefEnvironmentId bigint, @ExpiryDate datetime, @TenantSeviceLevelId bigint, @NewTenantGUID varchar(255),@NewTenantId bigint      
Declare @ParentGroupingID bigint, @CountyId bigint      
DECLARE @StampActionCreate CHAR(1) = 'C', @StampDateTime DATETIME = GETDATE(), @StampUserSystem CHAR(1) = '0'
      
Set @SimplyBizNetworkAccountTenantId = 747 -- tenantid      
Set @RefEnvironmentId=1  --site 10      
Set @ExpiryDate=DATEADD(yyyy,1,GetDate()) -- we add a year on      
Set @TenantSeviceLevelId =6      
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
      
Insert Into TIndigoClient       
(Identifier,Status,PrimaryContact,PhoneNumber,EmailAddress,NetworkId,FSA,IOProductType,ExpiryDate,AddressLine1,AddressLine2,AddressLine3,AddressLine4,      
CityTown,County,Postcode,Country,IsNetwork, FirmSize,Specialism,SupportLevel,EmailSupOptn,SupportEmail,TelSupOptn,SupportTelephone,      
AllowPasswordEmail, SessionTimeout,LicenceType,  MaxULAGCount, IsIndependent, ServiceLevel, CaseLoggingOption, [Guid], RefEnvironmentId, IsPortfolioConstructionProvider, IsAuthorProvider,IsAtrProvider, ConcurrencyId, UADRestriction, AdviserCountRestrict) 
  
    
Values       
(@TenantName, 'active', @PrimaryContact, @TelephoneNumber, @EmailAddress,@SimplyBizNetworkAccountTenantId,@FSANumber,'enterprise',@ExpiryDate,@AddressLine1,@AddressLine2,@AddressLine3,@AddressLine4,      
@CityTown,@CountyId,@Postcode, 1,0,'4-10 registered individuals','generalist','silver','standard','iosupport@intelliflo.com', 'standard','0330 102 8400',      
1,60,'standard',@MaxUsersWithLoginAccess,1,@TenantSeviceLevelId,1,@NewTenantGUID,@RefEnvironmentId,0,0,0,1,0,0       --ALM - 02/10/2014 - REMOVED ADDITION OF EXTRA LICENCE AGAINST @MaxUsersWithLoginAccess
)      
      
Select @NewTenantId=SCOPE_IDENTITY()      
      
-- To Assign the Modern Skin to Tenant added.      
Declare @parentThemeId uniqueidentifier      
Declare @themeId uniqueidentifier      
--For Simply Biz Children, Need to take the Active Theme for Simply Biz parent and use that Theme Id.      
--select @themeId = ThemeId from TTheme where ThemeId = '00000000-0000-0000-0000-000000000002'      
      
select @parentThemeId = ThemeId from TAllocatedTheme where TenantId = 747 and IsActive = 1      
      
if (@parentThemeId is not null)      
BEGIN      
-- 1. Create a copy of the Simply Biz Parent Theme      
Select @themeId=NEWID()      
      
INSERT INTO [Administration].[dbo].[TTheme]      
           ([ThemeId]      
           ,[Name]      
           ,[Skin]      
           ,[ColourPrimary]      
           ,[ColourSecondary]      
           ,[ColourHighlight])      
     SELECT @themeId,      
            case      
    when len(@TenantName) > 30 then left(@TenantName, 30) + '... Default Theme'       
    else @TenantName + ' Default Theme'      
     end,      
   Skin,      
   ColourPrimary,      
   ColourSecondary,      
   ColourHighlight      
     FROM  [Administration].[dbo].[TTheme]      
  where Themeid = @parentThemeId      
      
-- Audit the Theme      
INSERT INTO [Administration].[dbo].[TThemeAudit]      
           ([Name]      
           ,[Skin]      
           ,[ColourPrimary]      
           ,[ColourSecondary]      
           ,[ColourHighlight]      
           ,[ThemeId]      
           ,[StampAction]      
           ,[StampDateTime]      
           ,[StampUser])      
     SELECT Name,      
            Skin,                  
            ColourPrimary,      
      ColourSecondary,      
            ColourHighlight,      
   ThemeId,      
            'C',      
   GetDate(),     '0'      
  FROM TTheme       
  where Themeid = @themeId                   
      
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
      
-- Audit the Allocated Theme      
      
INSERT INTO [Administration].[dbo].[TAllocatedThemeAudit]      
           ([ThemeId]      
           ,[TenantId]      
           ,[IsActive]      
           ,[AllocatedThemeId]      
           ,[StampAction]      
           ,[StampDateTime]      
           ,[StampUser])      
      SELECT ThemeId,      
             TenantId,      
    IsActive,      
    AllocatedThemeId,      
    'C',      
    GetDate(),      
    '0'      
      FROM TAllocatedTheme      
   WHERE ThemeId = @themeId      
      
END      
      
-- lets create the combined recrord      
exec administration..SpCustomCreateIndigoClientCombined @NewTenantId, '0'      
      
-- lets copy the password policy from base account      
Insert into administration..TPasswordPolicy (Expires,ExpiryDays,UniquePasswords,MaxFailedLogins,ChangePasswordOnFirstUse,AutoPasswordGeneration,AllowExpireAllPasswords,      
AllowAutoUserNameGeneration,IndigoClientId,ConcurrencyId)      
SELECT Expires,ExpiryDays,UniquePasswords,MaxFailedLogins,ChangePasswordOnFirstUse,AutoPasswordGeneration,AllowExpireAllPasswords,      
AllowAutoUserNameGeneration,@NewTenantId,ConcurrencyId from administration..TPasswordPolicy WHERE indigoclientid=@SimplyBizNetworkAccountTenantId      
      
-- lets copy the groupings from master account      
Insert into administration..TGrouping (Identifier,ParentId,IsPayable,IndigoClientId,ConcurrencyId)      
Select Identifier,ParentId,IsPayable,@NewTenantId,1 from administration..TGrouping       
where indigoclientid=@SimplyBizNetworkAccountTenantId order by groupingid asc      
      
-- do we have a hierarchy      
if exists(select * from administration..TGrouping where indigoclientid=@SimplyBizNetworkAccountTenantId and ISNULL(parentid,0)=0)      
begin      
 -- lets copy the hierarchy      
 --for each group check the name and find the parent, update the record with the parent      
 Declare @SimplyBizGroupingId bigint, @SimplyBizParentGroupingId bigint, @NewTenantGroupingId bigint, @NewTenantParentGroupingId bigint      
      
 DECLARE grouping_cursor CURSOR      
    FOR SELECT GroupingId, ParentId FROM TGrouping A where indigoclientid=@SimplyBizNetworkAccountTenantId and ISNULL(parentid,0)>0      
 OPEN grouping_cursor      
      
 FETCH NEXT FROM grouping_cursor Into @SimplyBizGroupingId ,@SimplyBizParentGroupingId       
      
 WHILE @@FETCH_STATUS = 0      
    BEGIN      
  -- we know this group has a parent      
  SELECT @NewTenantGroupingId=GroupingId FROM TGrouping where identifier in (Select Identifier from administration..TGrouping where groupingid=@SimplyBizGroupingId) and IndigoClientId=@NewTenantId      
  SELECT @NewTenantParentGroupingId=GroupingId FROM TGrouping where identifier in (Select Identifier from administration..TGRouping where groupingid=@SimplyBizParentGroupingId) and IndigoClientId=@NEwTenantId      
        
  Update TGrouping Set ParentId=@NewTenantParentGroupingId where GroupingId=@NewTenantGroupingId      
      
  FETCH NEXT FROM grouping_cursor Into @SimplyBizGroupingId ,@SimplyBizParentGroupingId       
    END      
       
 CLOSE grouping_cursor       
    DEALLOCATE grouping_cursor      
end      
      
-- we need to do something similar with groups      
      
-- for each group create a corporate, crmcontact, group and associate to the right grouping      
      
-- lets copy the hierarchy      
 --for each group check the name and find the parent, update the record with the parent      
 Declare @SimplyBizGroupId bigint, @CorporateId bigint, @GRoupCRMContactId bigint, @NewGroupId bigint, @GroupingIdentifier varchar(255), @NewGroupingID bigint      
      
 DECLARE group_cursor CURSOR      
    FOR SELECT GroupId, GroupingId FROM TGroup A where indigoclientid=@SimplyBizNetworkAccountTenantId      
 OPEN group_cursor      
      
 FETCH NEXT FROM group_cursor Into @SimplyBizGroupId, @SimplyBizGroupingID       
      
 WHILE @@FETCH_STATUS = 0      
    BEGIN      
        
  --lets create the corporate      
  Insert into CRM..TCorporate (IndClientId, CorporateName, ConcurrencyId)      
  select @NewTenantId, A.CorporateName, 1 from CRM..TCorporate A      
  inner join CRM..TCRMContact b on a.corporateid=b.corporateId      
  inner join administration..tgroup c on c.crmcontactid=b.crmcontactid      
  where c.groupid=@SimplyBizGroupId      
      
  Set @CorporateId=SCOPE_IDENTITY()      
      
  Insert into CRM..TCRMContact (RefCRMContactStatusId, CorporateId, ArchiveFG, CorporateName,       
  originaladviserCRMID, CurrentAdviserCRMId, CRMContactType, IndClientId, InternalContactFG, CreatedDate, externalreference, concurrencyid)      
  select 1,@CorporateId,0, A.CorporateName,       
  0,0,3,@NewTenantId, 1,getDate(),null,1  from CRM..TCorporate A      
  inner join CRM..TCRMContact b on a.corporateid=b.corporateId      
  inner join administration..tgroup c on c.crmcontactid=b.crmcontactid      
  where c.groupid=@SimplyBizGroupId      
      
  Set @GRoupCRMContactId =SCOPE_IDENTITY()      
      
  Insert into administration..TGroup (      
    Identifier,GroupingId,ParentId,CRMContactId,IndigoClientId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,      
    FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,AuthorisationText,ConcurrencyId)      
  Select Identifier,GroupingId,null,@GRoupCRMContactId,@NewTenantId,LegalEntity,GroupImageLocation,AcknowledgementsLocation,      
    FinancialYearEnd,ApplyFactFindBranding,VatRegNbr,AuthorisationText,ConcurrencyId       
  from administration..tgroup where groupid=@SimplyBizGroupId      
      
  Set @NewGroupId=SCOPE_IDENTITY()      
      
  -- we need to know who the grouping is for the group added so we can update thr groupingid      
  select @GroupingIdentifier =Identifier from administration..tgrouping where groupingid=@SimplyBizGroupingID      
  select @NewGroupingID=GRoupingId from administration..TGrouping where identifier=@GroupingIdentifier  and IndigoClientId=@NEwTenantId      
      
  Update administration..TGroup set GRoupingid=@NewGroupingId where GRoupId=@NewGroupId      
      
  FETCH NEXT FROM group_cursor Into @SimplyBizGroupId, @SimplyBizGroupingID       
       
    END      
       
 CLOSE group_cursor       
    DEALLOCATE group_cursor      
      
-- for each group set the hierarchy      
      
if exists(select * from administration..TGroup where indigoclientid=@SimplyBizNetworkAccountTenantId and ISNULL(parentid,0)=0)      
begin      
      
 -- some variable helpers       
 DECLARE @NewTenantGroupId bigint, @NewTenantParentGroupId bigint, @SimplyBizParentGroupId bigint      
      
 -- lets copy the hierarchy      
 DECLARE group_cursor CURSOR      
    FOR SELECT GroupId, ParentId FROM TGroup A where indigoclientid=@SimplyBizNetworkAccountTenantId and ISNULL(parentid,0)>0 order by GroupId asc      
 OPEN group_cursor      
      
 FETCH NEXT FROM group_cursor Into @SimplyBizGroupId ,@SimplyBizParentGroupId       
      
 WHILE @@FETCH_STATUS = 0      
    BEGIN      
  -- we know this group has a parent      
  SELECT @NewTenantGroupId=GroupId FROM TGroup where identifier in (Select Identifier from administration..TGroup where groupid=@SimplyBizGroupId) and IndigoClientId=@NewTenantId      
  SELECT @NewTenantParentGroupId=GroupId FROM TGroup where identifier in (Select Identifier from administration..TGRoup where groupid=@SimplyBizParentGroupId) and IndigoClientId=@NEwTenantId      
      
  Update TGroup Set ParentId=@NewTenantParentGroupId where GroupId=@NewTenantGroupId      
      
  FETCH NEXT FROM group_cursor Into @SimplyBizGroupId ,@SimplyBizParentGroupId       
    END      
       
      
 CLOSE group_cursor       
    DEALLOCATE group_cursor      
end      
      
-- ok lets now do the roles      
      
INSERT INTO administration..trole (Identifier,RefLicenseTypeId, GroupingId, SuperUser, IndigoClientId, DashBoard, ShowGRoupDashBoard, concurrencyId)      
SELECT Identifier, RefLicenseTypeId,GroupingId, SuperUser,@NEwTenantId, DashBoard, ShowGRoupDashBoard, concurrencyId FROM administration..trole WHERE indigoclientid=@SimplyBizNetworkAccountTenantId      
      
-- ok lets do the grouping for the roles      
      
      
-- some variable helpers       
DECLARE @SimplyBizGroupingIdentifier varchar(255), @RoleIdentifier varchar(255)      
      
-- lets copy the hierarchy      
DECLARE role_cursor CURSOR      
FOR SELECT A.Identifier, B.Identifier FROM TRole A       
 INNER JOIN administration..TGrouping B on a.groupingid=b.groupingid      
 where A.indigoclientid=@SimplyBizNetworkAccountTenantId      
 order by a.roleid asc      
 OPEN role_cursor      
      
 FETCH NEXT FROM role_cursor Into @RoleIdentifier,@SimplyBizGroupingIdentifier      
      
 WHILE @@FETCH_STATUS = 0      
 BEGIN      
 -- get the grouping id from our new tenant for this role      
  SELECT @NewTenantGroupingId=GroupingId from TGrouping where Identifier = @SimplyBizGroupingIdentifier and Indigoclientid=@NewTenantId      
  UPDATE TRole Set GroupingId=@NewTenantGroupingId where Identifier=@RoleIdentifier and Indigoclientid=@NewTenantId      
      
  FETCH NEXT FROM role_cursor Into @RoleIdentifier,@SimplyBizGroupingIdentifier      
    END      
       
       
CLOSE role_cursor       
DEALLOCATE role_cursor      
      
-- lets do our entity security, create a policy table      
Create table ##PolicyDefinition(      
 EntityId bigint,      
 RightMask bigint,       
 ADvancedMask bigint,      
 RoleId bigint,      
 RoleIdentifier varchar(255),      
 MappedToRoleID bigint      
)      
      
-- get the roles and do some mapping      
Insert into ##PolicyDefinition (EntityId, RightMask, AdvancedMask, RoleId, RoleIdentifier)      
select a.EntityId, a.RightMask, a.AdvancedMask, b.RoleId, b.Identifier from administration..tpolicy a      
inner join administration..trole b on a.roleid=b.roleid      
where a.indigoclientid=@SimplyBizNetworkAccountTenantId      
order by a.RoleId desc      
      
-- do the insert      
      
insert into administration..tpolicy (EntityId, RightMask, AdvancedMask, RoleId, Propogate, applied, IndigoclientId, ConcurrencyId)      
select a.EntityId, a.RightMask, a.AdvancedMask, b.RoleId, 0, 'yes', c.IndigoclientId, 1 from ##PolicyDefinition a      
inner join administration..trole b on a.roleidentifier=b.identifier      
inner join administration..tindigoclient c on c.indigoclientid=b.indigoclientid      
left join administration..tpolicy d on d.roleid=b.roleid      
where c.indigoclientid=@NewTenantId and d.roleid is null      
      
      
-- drop the table init      
      
DROP TABLE ##PolicyDefinition      
      
-- lets create our default user      
      
-- lets get our default group, role      
Declare @DefaultGroupId bigint, @DefaultRoleId bigint      
      
Select top 1 @DefaultGroupId = GroupId from administration..TGroup where IndigoClientId=@NewTenantId      
order by GroupId asc      
      
      
Select top 1 @DefaultRoleId = RoleId from administration..TRole where IndigoClientId=@NewTenantId      
order by RoleId asc      
      
declare @AdministratorUserId int      
Exec SpCustomCreateIntellifloSupportUser @NewTenantId 
set @AdministratorUserId = (select MIN(userid) from TUser where IndigoClientId = @NewTenantId AND RefUserTypeId = 6)    
-- create a second support user
Exec SpCustomCreateIntellifloSupportUser @NewTenantId 
      
-- lets create the corporate client for the tennant contact      
Declare @NewTenantCRMContactId bigint      
      
INSERT INTO CRM..TCorporate (IndClientId, CorporateName)      
VALUES (@NewTenantId, @TenantName)      
      
SET @CorporateId=SCOPE_IDENTITY()      
      
INSERT INTO CRM..TCRMContact (RefCRMContactStatusId, CorporateId, ArchiveFG, CorporateName,       
originaladviserCRMID, CurrentAdviserCRMId, CRMContactType, IndClientId, InternalContactFG, CreatedDate, externalreference, concurrencyid)      
Values (1,@CorporateId,0, @TenantName, 0,0,3,@NewTenantId, 1,getDate(),null,1)      
      
SET @NewTenantCRMContactId=SCOPE_IDENTITY()      
      
UPDATE administration..TindigoClient SET PrimaryGroupId=@DEfaultGroupId,contactid=@NewTenantCRMContactId WHERE indigoclientid=@NEwTenantId      
      
-- letss do the statushistory      
Insert into administration..TOrganisationStatusHistory(IndigoClientId, Identifier, changedatetime, changeuser)      
values (@NewTenantId, 'active',getdate(),@AdministratorUserId)      
      
      
-- lets do the full licencse type      
Insert into administration..TIndigoClientLicense(IndigoClientId,LicenseTypeId,Status,MaxConUsers,MaxULAGCount,      
 UADRestriction,MaxULADCount,AdviserCountRestrict,MaxAdviserCount,MaxFinancialPlanningUsers, ConcurrencyId)      
Values(@NewTenantId, 1,1,NULL,@MaxUsersWithLoginAccess, 0,0,0,0,0,1)       --ALM - 02/10/2014 - REMOVED ADDITION OF EXTRA LICENCE AGAINST @MaxUsersWithLoginAccess
      
      
-- lets do administration standing data      
INSERT INTO administration..TIndClientCommissionDef (IndigoClientId,AllowClawbackFG,DateOrder,PayCurrentGroupFG,RecalcIntroducerSplitFG,RecalcPractPercentFG,DefaultPayeeEntityId,PMMaxDiffAmount,PMUseLinkProviderFG,      
PMUseLookupFG,PMMatchSurnameFirstFG,PMMatchSurnameLastFG,PMMatchCompanyNameFG,CMUseLinkProviderFG,CMProvDescLength,CMDateRangeUpper,      
CMDateRangeLower,MinBACSAmount,ConcurrencyId)      
SELECT @NewTenantId,AllowClawbackFG,DateOrder,PayCurrentGroupFG,RecalcIntroducerSplitFG,RecalcPractPercentFG,DefaultPayeeEntityId,PMMaxDiffAmount,PMUseLinkProviderFG,      
PMUseLookupFG,PMMatchSurnameFirstFG,PMMatchSurnameLastFG,PMMatchCompanyNameFG,CMUseLinkProviderFG,CMProvDescLength,CMDateRangeUpper,      
CMDateRangeLower,MinBACSAmount,ConcurrencyId FROM administration..TIndClientCommissionDef  WHERE IndigoClientId=@SimplyBizNetworkAccountTenantId       
      
INSERT INTO administration..trunning(RebuildKeys,IndigoClientId,ConcurrencyId)      
SELECT RebuildKeys,@NewTenantId,ConcurrencyId FROM TRunning WHERE IndigoClientId=@SimplyBizNetworkAccountTenantId      
      
-- Author      
Insert into Author..TParagraphType (Identifier,IndigoClientId,Extensible,ConcurrencyId)      
select Identifier,@NewTenantId,Extensible,ConcurrencyId from Author..TParagraphType where indigoclientid=@SimplyBizNetworkAccountTenantId      
      
-- commissions      
      
insert into commissions..TPotMatchTimetable (IndClientId,RepeatCount,RefPotMatchTimetableTypeId,Extensible,ConcurrencyId)      
select @NewTenantId,RepeatCount,RefPotMatchTimetableTypeId,Extensible,ConcurrencyId from commissions..TPotMatchTimetable where indclientid=@SimplyBizNetworkAccountTenantId      
      
insert into commissions..TPeriodComHist (IndClientId,StartDatetime,EndDatetime,RunDatetime,UserId,Extensible,ConcurrencyId)      
Values (@NewTenantID, GetDate(), null, null, null, null, 1)      
      
-- compliance      
      
-- we need some role specific data here      
-- Declaring var's
--1. @ComplianceGradeRoleId
--2. @ComplianceGradeRoleIdentifier
-- for Compliance Grade Role (new column in TComplianceSetup)
Declare @PractitionerRoleId bigint, @TnCRoleId bigint,@FileCheckRoleId bigint, @ComplianceGradeRoleId bigint      
Declare @PractitionerRoleIdentifier varchar(255), @TnCRoleIdentifier varchar(255),@FileCheckRoleIdentifier varchar(255), @ComplianceGradeRoleIdentifier varchar(255)      
      
Select @PractitionerRoleIdentifier=b.identifier , @TnCRoleIdentifier=c.identifier ,@FileCheckRoleIdentifier=d.identifier,
--fetching compliance grade role identifier
@ComplianceGradeRoleIdentifier = e.identifier
from compliance..tcompliancesetup a      
Left join administration..TRole b on a.PractitionerRoleId=b.roleId      
Left join administration..TRole c on a.TnCRoleId=c.roleId      
Left join administration..TRole d on a.FileCheckRoleId=d.roleId
--left join to fetch compliance grade role identifier
Left join administration..TRole e on a.ComplianceGradeRoleId=e.roleId        
where a.indclientid=@SimplyBizNetworkAccountTenantId      
      
select @PractitionerRoleId = RoleId from administration..TRole where identifier like @PractitionerRoleIdentifier and indigoclientid=@NewTenantId      
select @TnCRoleId = RoleId from administration..TRole where identifier like @TnCRoleIdentifier and indigoclientid=@NewTenantId      
select @FileCheckRoleId= RoleId from administration..TRole where identifier like @FileCheckRoleIdentifier and indigoclientid=@NewTenantId 
--selecting compliance grade role id     
select @ComplianceGradeRoleId= RoleId from administration..TRole where identifier like @ComplianceGradeRoleIdentifier and indigoclientid=@NewTenantId  
      
--insert also includes the new complianceGradeRoleId column value also      
insert into compliance..tcompliancesetup(IndClientId,AcknolwdgeComplaintDays,ShdComplaintsNotifyUsersByEmail,ShdDocumentPredateSubmission,      
 ShdQuotePredateSubmission,CanBeOwnTnCCoach,RequireTnCCoach,TnCCoachControlSpan,PractitionerRoleId,      
 TnCRoleId,FileCheckRoleId,PassThroughTnCCheckingForFees,PassThroughTnCCheckingForRetainers,AdviceCaseCheckingEnabled,ConcurrencyId,ComplianceGradeRoleId)      
select @NewTenantID,AcknolwdgeComplaintDays,ShdComplaintsNotifyUsersByEmail,ShdDocumentPredateSubmission,      
 ShdQuotePredateSubmission,CanBeOwnTnCCoach,RequireTnCCoach,TnCCoachControlSpan,@PractitionerRoleId,      
 @TnCRoleId,@FileCheckRoleId,PassThroughTnCCheckingForFees,PassThroughTnCCheckingForRetainers,AdviceCaseCheckingEnabled,ConcurrencyId,@ComplianceGradeRoleId       
from compliance..tcompliancesetup where IndClientId=@SimplyBizNetworkAccountTenantId      
      
      
insert into compliance..TRefCorrespondenceType (CorrespondenceType,IndClientId,ConcurrencyId)      
select CorrespondenceType,@NewTenantID,ConcurrencyId from compliance..TRefCorrespondenceType where IndClientId=@SimplyBizNetworkAccountTenantId      
      
insert into compliance..TRefFileCheckFailStatus(FileCheckFailStatus,IndClientId,ConcurrencyId)         
select FileCheckFailStatus,@NewTenantID ,ConcurrencyId from compliance..TRefFileCheckFailStatus where IndClientId=@SimplyBizNetworkAccountTenantId      
      
insert into compliance..TRefRiskStatus (RiskStatusDescription,RefRiskCategoryId,IsDisabled,IndClientId,ConcurrencyId)      
select RiskStatusDescription,RefRiskCategoryId,IsDisabled,@NewTenantID,ConcurrencyId from compliance..TRefRiskStatus where IndClientId=@SimplyBizNetworkAccountTenantId      
      
insert into compliance..TRefTrainingCourse (IndClientId,CourseName,CPDHours,IsProductRelated,RefPlanTypeId,      
 RefCourseCategoryId,CourseAvailableDate,CourseExpiryDate,CourseNotes,ConcurrencyId)      
Select @NewTenantId,CourseName,CPDHours,IsProductRelated,RefPlanTypeId,      
 RefCourseCategoryId,CourseAvailableDate,CourseExpiryDate,CourseNotes,ConcurrencyId from compliance..TRefTrainingCourse      
where IndClientId=@SimplyBizNetworkAccountTenantId      
      
      
-- CRM      
      
insert into CRM..TRefAccType(IndClientId,Name,Description,ActiveFG,ConcurrencyId)      
select @NEwTenantId,Name,Description,ActiveFG,ConcurrencyId from CRM..TRefAccType where IndClientId=@SimplyBizNetworkAccountTenantId      
      
insert into crm..TRefAccUse(IndClientId,AccountUseDesc,ConcurrencyId)      
select @NEwTenantId,AccountUseDesc,ConcurrencyId from crm..TRefAccUse where IndClientId=@SimplyBizNetworkAccountTenantId      
      
insert into CRM..TRefCategoryAM(Description,ArchiveFG,IndClientId,ConcurrencyId)      
select Description,ArchiveFG,@NEwTenantId,ConcurrencyId from CRM..TRefCategoryAM where IndClientId=@SimplyBizNetworkAccountTenantId      
      
insert into CRM..TRefIntroducerType (IndClientId,ShortName,LongName,MinSplitRange,MaxSplitRange,      
DefaultSplit,RenewalsFG,ArchiveFG,ConcurrencyId)      
select @NewTenantID,ShortName,LongName,MinSplitRange,MaxSplitRange,      
DefaultSplit,RenewalsFG,ArchiveFG,ConcurrencyId from CRM..TRefIntroducerType where IndClientId=@SimplyBizNetworkAccountTenantId      
      
insert into CRM..TRefOpportunityStage (IndClientId,Description,Probability,OpenFG,ClosedFG,      
WonFG,ConcurrencyId)      
select @NewTenantID,Description,Probability,OpenFG,ClosedFG,      
WonFG,ConcurrencyId from CRM..TRefOpportunityStage where IndClientId=@SimplyBizNetworkAccountTenantId      
      
insert into CRM..TRefPaymentType (IndClientId,Name,Description,ActiveFG,ConcurrencyId)      
select @NewTenantId, Name,Description,ActiveFG,ConcurrencyId from CRM..TRefPaymentType where IndClientId=@SimplyBizNetworkAccountTenantId      
      
insert into CRM..TRefShowTimeAs (Description,Color,FreeFG,IndClientId,ConcurrencyId)      
select Description,Color,FreeFG, @NEwTenantId, ConcurrencyId from CRM..TRefShowTimeAs where IndClientId=@SimplyBizNetworkAccountTenantId      
      
insert into CRM..TRefServiceStatus (ServiceStatusName,IndigoClientId,ConcurrencyId)      
select ServiceStatusName,@NewTenantId,ConcurrencyId from CRM..TRefServiceStatus where IndigoClientId=@SimplyBizNetworkAccountTenantId      
      
insert into CRM..TPostCodeAllocation (IndigoClientId,MaxDistance,AllocationTypeId)       
select @NEwTenantID, MaxDistance,AllocationTypeId from CRM..TPostCodeAllocation where IndigoClientId=@SimplyBizNetworkAccountTenantId   

--Mortgage Checklist Question and Mortgage checklist Category data
EXEC administration..SpCreateMortgageChecklist @SimplyBizNetworkAccountTenantId, @NewTenantId   
      
-- lets do the fact find search stuff
     
insert into CRM..TFactFindSearch(RefFactFindSearchTypeId,IndigoClientId, concurrencyid)      
select RefFactFindSearchTypeId,@NEwTenantId, concurrencyid from CRM..TFactFindSearch where indigoclientid=@SimplyBizNetworkAccountTenantId      
      
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
  where IndigoClientId=@SimplyBizNetworkAccountTenantId and b.RefFactFindSearchTypeId=@RefFactFindSearchTypeId      
      
  FETCH NEXT FROM factfindsearch_cursor Into @FactFindSearchId, @RefFactFindSearchTypeId      
    END      
       
       
CLOSE factfindsearch_cursor      
DEALLOCATE factfindsearch_cursor      
      
-- documentmanagement      
insert into documentmanagement..TCategory (Identifier,Descriptor,Notes,IndigoClientId,Archived,ConcurrencyId)      
select Identifier,Descriptor,Notes,@NewTenantId,Archived,ConcurrencyId from documentmanagement..TCategory where IndigoClientId=@SimplyBizNetworkAccountTenantId       
      
insert into documentmanagement..TSubCategory (Identifier,Descriptor,Notes,IndigoClientId,Archived,ConcurrencyId)      
select Identifier,Descriptor,Notes,@NewTenantId,Archived,ConcurrencyId from documentmanagement..TSubCategory where IndigoClientId=@SimplyBizNetworkAccountTenantId       
      
/* LETS DEAL WITH THE MEGA SCRIPT */      
      
-- Activity Categories and parents      
      
Insert into CRM..TActivityCategoryParent (Name, IndigoClientId, ConcurrencyId)      
select DISTINCT a.Name, @NewTenantId, a.ConcurrencyId from CRM..TActivityCategoryParent A      
Inner Join crm..tactivitycategory b on a.activitycategoryparentid=b.activitycategoryparentid      
where a.indigoclientid=@SimplyBizNetworkAccountTenantId and b.ActivityEvent='Task' AND b.GroupId IS NULL      
      
-- now lets associate all of the activity categories to their parents      
      
DECLARE @ActivityCategoryParentId bigint, @ActivityCategoryParentIdentifier varchar(255)      
      
-- lets copy task configuration      
DECLARE activitycategory_cursor CURSOR      
FOR SELECT ActivityCategoryParentId, Name FROM CRM..TActivityCategoryParent      
 where indigoclientid=@NewTenantId      
 OPEN activitycategory_cursor      
      
 FETCH NEXT FROM activitycategory_cursor Into @ActivityCategoryParentId, @ActivityCategoryParentIdentifier       
      
 WHILE @@FETCH_STATUS = 0      
 BEGIN      
  Insert Into CRM..TActivityCategory (Name,ActivityCategoryParentId,LifeCycleTransitionId,IndigoClientId,ClientRelatedFG,      
   PlanRelatedFG,FeeRelatedFG,RetainerRelatedFG,OpportunityRelatedFG,AdviserRelatedFg,ActivityEvent,RefSystemEventId,ConcurrencyId)      
  Select A.Name,@ActivityCategoryParentId,LifeCycleTransitionId,@NewTenantID,ClientRelatedFG,      
   PlanRelatedFG,FeeRelatedFG,RetainerRelatedFG,OpportunityRelatedFG,AdviserRelatedFg,ActivityEvent,RefSystemEventId,A.ConcurrencyId       
  from CRM..TActivityCategory A      
  Inner join CRM..TActivityCategoryParent B on A.ActivityCategoryParentId=B.ActivityCategoryParentId      
  where B.Name=@ActivityCategoryParentIdentifier and B.IndigoClientId=@SimplyBizNetworkAccountTenantId AND A.GroupId IS NULL     
      
  FETCH NEXT FROM activitycategory_cursor Into @ActivityCategoryParentId, @ActivityCategoryParentIdentifier       
    END      
       
       
CLOSE activitycategory_cursor      
DEALLOCATE activitycategory_cursor      
      
-- lets do the priorities      
INSERT INTO CRM..TRefPriority (PriorityName, IndClientId, COncurrencyId)      
SELECT PriorityName, @NEwTenantId, ConcurrencyId FROM CRM..TRefPriority where indclientid=@SimplyBizNetworkAccountTenantId      
      
-- Add Factfind to the library      
EXEC DocumentManagement..SpCustomCreateFactFindFolder @NewTenantId                        
      
      
-- configure functional roles and lifecycles etc      
      
EXEC SpCustomConfigureNewOrganisation @NewTenantId, @SimplyBizNetworkAccountTenantId      
      
EXEC commissions..spCustomCommissionsConfig @NewTenantId      
        
-- Campaign Management & Opportunity Management        
EXEC CRM..SpCustomInsertDefaultDataForIndigoClient @NewTenantId
--Add mapping for Sub PlanTypes to Opportunity type entries in the mapping table for the new tenant
EXEC Administration..SpNCreateOpportunityToPlanTypeMapping @NewTenantId
      
-- create asset categories      
-- Not required anymore - asset categories are no longer tenant specific.    
--Insert into FactFind..TAssetCategory (CategoryName,SectorName,IndigoClientId,ConcurrencyId)    
--select CategoryName,SectorName,@NewTenantId,ConcurrencyId from FactFind..TAssetCategory where indigoclientid=@SimplyBizNetworkAccountTenantId    
   
-- document status      
      
EXEC DocumentManagement..spCustomGenerateDocumentStatusOrder @NewTenantId      
EXEC DocumentManagement..spCustomGenerateDocumentStatusToRole @NewTenantId      
EXEC DocumentManagement..spCustomGenerateBinderStatusToRole @NewTenantId      
EXEC DocumentManagement..spCustomGenerateDocumentDeleteRights @NewTenantId      
      
---------------------------------------------------------------------------
-- ATR - this will add a default ATR Template based on the Network's current
-- active ATR Template, and also add a Default question category.
---------------------------------------------------------------------------
PRINT 'Adding ATR Configuration...'      
EXEC SpCustomConfigureAtrForNewNetworkedTenant @NewTenantId, @SimplyBizNetworkAccountTenantId

---------------------------------------------------------------------------
-- Add Fact Find Type information.      
---------------------------------------------------------------------------
PRINT 'Adding FactFind Types...'      
IF NOT EXISTS (SELECT 1 FROM FactFind..TFactFindType WHERE IndigoClientId = @NewTenantId AND CRMContactType = 1)      
 EXEC FactFind..SpNCreateFactFindTypeReturnId 0, 'Personal', 'Personal', 1, @NewTenantId      
      
IF NOT EXISTS (SELECT 1 FROM FactFind..TFactFindType WHERE IndigoClientId = @NewTenantId AND CRMContactType = 3)      
 EXEC FactFind..SpNCreateFactFindTypeReturnId 0, 'Corporate', 'Corporate', 3, @NewTenantId      
      
PRINT 'Add Event List template from Source to New Tenant.'                
EXEC CRM..spCustomCreateEventListTemplatesForNewTenant @NewTenantId, @SimplyBizNetworkAccountTenantId

PRINT 'Add Event List template activities from Source to New Tenant.'                
EXEC CRM..spCustomCreateEventListTemplateActivitiesForNewTenant @NewTenantId, @SimplyBizNetworkAccountTenantId

PRINT 'Add Plan Purpose and its related plan types'                
EXEC PolicyManagement..spCustomCreatePlanPurposeForNewTenant @NewTenantId, @SimplyBizNetworkAccountTenantId

PRINT 'Add Plan Settings'                
EXEC Reporter..spCustomCreatePlanSettingsForNewTenant @NewTenantId, @SimplyBizNetworkAccountTenantId
      
-- PDF Templates      
EXEC Reporter..SpCustomCreatePDFTemplatesForIndigoClientId @NewTenantId        
EXEC Reporter..SpCustomCopyPDFTemplateChartStyleForIndigoClientId @NewTenantId, @SimplyBizNetworkAccountTenantId         
EXEC Reporter..SpCustomCopyPDFTemplateStyleForIndigoClientId @NewTenantId, @SimplyBizNetworkAccountTenantId  
EXEC Reporter..SpCustomCreatePDFTemplateTypeSettingForIndigoClientId @NewTenantId                
EXEC Reporter..SpCustomCopyPDFTemplateTypeForIndigoClientId  @NewTenantId, @SimplyBizNetworkAccountTenantId          
      
-- glossary data          
IF NOT EXISTS (SELECT 1 FROM Reporter..TPdfTemplateGlossary WHERE IndigoClientId = @NEwTenantID)          
 INSERT INTO Reporter..TPDFTemplateGlossary (          
  RefPDFTemplateGlossaryId, IndigoClientId, [Description], GlossaryText, UseDefaultTextFg, Ordinal)          
 SELECT           
  RefPDFTemplateGlossaryId, @NEwTenantID, [Description], GlossaryText, 1, 0          
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
EXEC CRM..SpCustomConfigureAdviceCaseStatusChanges @NewTenantId      
      
PRINT 'Step 13: Configure Compliance'                
EXEC Compliance.dbo.SpConfigureComplianceAdmin @NewTenantId, @SimplyBizNetworkAccountTenantId    
          
PRINT 'Step 14: Configure CE Frequency for Active ICs'                
EXEC PolicyManagement.dbo.SpCustomConfigureCEFrequencyForActiveICs @NewTenantId      
         
PRINT 'Step 15: Configure Axa Integration for Active ICs'           
declare @WrapperProviderId bigint, @RefApplicationId bigint          
          
select @WrapperProviderId = a.WrapperProviderId from policymanagement..tWrapperProvider a          
inner join policymanagement..trefprodprovider b on a.refprodproviderId = b.refprodproviderId          
inner join crm..tcrmcontact c on c.crmcontactid = b.crmcontactid          
inner join policymanagement..trefplantype d on a.refplantypeid = d.refplantypeid          
where c.corporatename ='elevate' and d.PlanTypeName = 'Wrap'          
          
-- add Dynamic Planner (SimplyBiz)
select @RefApplicationId = IsNull(RefApplicationId,0)      
from policymanagement..trefapplication        
where ApplicationName = 'Dynamic Planner (SimplyBiz)'        
    
INSERT INTO PolicyManagement..TApplicationLink (IndigoClientId, RefApplicationId, MaxLicenceCount, CurrentLicenceCount, AllowAccess, ExtranetURL, ReferenceCode, ConcurrencyId, IntegratedSystemConfigRole)
VALUES (@NewTenantId, @RefApplicationId, null, null, 1, null, null, 1, 7)

    
-- deal with storage limits      
declare @DocStorageValue bigint      
      
Set @DocStorageValue = (209715200 * @MaxUsersWithLoginAccess) + 536870912      
      
insert into Documentmanagement..tdocstorage (IndigoClientId, SpaceAllocated, SpaceUsed, ConcurrencyId)      
Select @NewTenantId, @DocStorageValue, 0,1      
      
      
-- lets do the themes      
      
INSERT INTO TLegacyTheme (IndigoClientId,DefaultFont,DefaultSize,AlternateFont,AlternateSize,Colour1,Colour2,Colour3,Colour4,Colour5,Colour6)       
select @NewTenantId,DefaultFont,DefaultSize,AlternateFont,AlternateSize,Colour1,Colour2,Colour3,Colour4,Colour5,Colour6 from TLegacyTheme where IndigoClientId=@SimplyBizNetworkAccountTenantId       
      
-- lets set up author      
exec SpCustomCreateIndigoClientPreference '0', @NewTenantId, @NewTenantGuid, 'AuthorContentProvider',  '20360B65-8615-43CB-B387-46F181676C40', 0      
      
declare @subcategoryid bigint      
      
--Use a cursor to loop through all indigoclients and add sub categories for each      
declare c_IndigoClients cursor for      
select indigoclientid from administration..tindigoclient where IndigoClientid=@NewTenantId      
open c_IndigoClients      
fetch next from c_IndigoClients into @NewTenantId      
while @@fetch_status=0      
begin      
      
                if not exists(      
                select subcategoryid from documentmanagement..tsubcategory where identifier='Key Features' and indigoclientid=@NewTenantId)      
                begin      
                                insert documentmanagement..tsubcategory(Identifier,IndigoClientId,ConcurrencyId)      
                                select 'Key Features',@NewTenantId,1      
                                select @subcategoryid=SCOPE_IDENTITY()      
                      
                                insert documentmanagement..tsubcategoryaudit(Identifier, Descriptor,  Notes, IndigoClientId,  ConcurrencyId, SubCategoryId, StampAction, StampDateTime, StampUser)      
                                select Identifier, Descriptor,  Notes, IndigoClientId,  ConcurrencyId, SubCategoryId, 'C', getdate(), '0'      
                                From documentmanagement..tsubcategory      
                                Where subcategoryId = @subcategoryid      
                end      
      
                if not exists(      
                select subcategoryid from documentmanagement..tsubcategory where identifier='Illustration' and indigoclientid=@NewTenantId)      
                begin      
                                insert documentmanagement..tsubcategory(Identifier,IndigoClientId,ConcurrencyId)      
                                select 'Illustration',@NewTenantId,1      
                                select @subcategoryid=SCOPE_IDENTITY()      
      
                                insert documentmanagement..tsubcategoryaudit(Identifier, Descriptor,  Notes, IndigoClientId,  ConcurrencyId, SubCategoryId, StampAction, StampDateTime, StampUser)      
                                select Identifier, Descriptor,  Notes, IndigoClientId,  ConcurrencyId, SubCategoryId, 'C', getdate(), '0'      
                                From documentmanagement..tsubcategory      
                                Where subcategoryId = @subcategoryid      
                end      
      
                if not exists(      
                select subcategoryid from documentmanagement..tsubcategory where identifier='Quote Xml' and indigoclientid=@NewTenantId)      
                begin      
                                insert documentmanagement..tsubcategory(Identifier,IndigoClientId,ConcurrencyId)      
                                select 'Quote Xml',@NewTenantId,1      
                                select @subcategoryid=SCOPE_IDENTITY()      
      
                                insert documentmanagement..tsubcategoryaudit(Identifier, Descriptor,  Notes, IndigoClientId,  ConcurrencyId, SubCategoryId, StampAction, StampDateTime, StampUser)      
                                select Identifier, Descriptor,  Notes, IndigoClientId,  ConcurrencyId, SubCategoryId, 'C', getdate(), '0'      
                                From documentmanagement..tsubcategory      
     Where subcategoryId = @subcategoryid      
                end      
      
                if not exists(      
                select subcategoryid from documentmanagement..tsubcategory where identifier='App Form' and indigoclientid=@NewTenantId)      
                begin      
                            insert documentmanagement..tsubcategory(Identifier,IndigoClientId,ConcurrencyId)      
                                select 'App Form',@NewTenantId,1      
                                select @subcategoryid=SCOPE_IDENTITY()      
      
                                insert documentmanagement..tsubcategoryaudit(Identifier, Descriptor,  Notes, IndigoClientId,  ConcurrencyId, SubCategoryId, StampAction, StampDateTime, StampUser)      
                        select Identifier, Descriptor,  Notes, IndigoClientId,  ConcurrencyId, SubCategoryId, 'C', getdate(), '0'      
                                From documentmanagement..tsubcategory      
                                Where subcategoryId = @subcategoryid      
                end      
      
fetch next from c_IndigoClients into @NewTenantId      
end      
close c_IndigoClients      
deallocate c_IndigoClients      
      
-- lets do accounts      
      
INSERT INTO crm..taccounttype(AccountTypeName, IsForCorporate, IsForIndividual, IsNotModifiable, IsArchived, IndigoClientId)       
select AccountTypeName, IsForCorporate, IsForIndividual, IsNotModifiable, IsArchived, @NewTenantId      
From administration..TIndigoClient a      
inner join crm..taccounttype b on a.indigoclientid=b.indigoclientid      
Where a.indigoclientid=@SimplyBizNetworkAccountTenantId       
      
-- INSERT - data for system defined advise payment types into TAdvisePaymentType  
IF  EXISTS (SELECT * FROM policymanagement.sys.objects WHERE object_id = OBJECT_ID(N'[policymanagement].[dbo].[TAdvisePaymentType]') AND type in (N'U'))  
BEGIN  
 --(exclude 'By Provider')
INSERT INTO policymanagement..TAdvisePaymentType(TenantId,IsArchived,Name,IsSystemDefined)  
SELECT @NewTenantId, 0, TRefAdvisePaymentType.Name, 1  
FROM policymanagement..TRefAdvisePaymentType WHERE TRefAdvisePaymentType.Name NOT IN ('By Provider')
	 
--(include 'By Provider')
DECLARE @RefAdvisePaidById bigint
SELECT @RefAdvisePaidById = RefAdvisePaidById  FROM policymanagement..TRefAdvisePaidBy WHERE Name = 'Provider'
	 
INSERT INTO policymanagement..TAdvisePaymentType(TenantId,IsArchived,Name,IsSystemDefined, RefAdvisePaidById)  
SELECT @NewTenantId, 0, TRefAdvisePaymentType.Name, 1, @RefAdvisePaidById
FROM policymanagement..TRefAdvisePaymentType WHERE TRefAdvisePaymentType.Name IN ('By Provider')
END  
-- END OF INSERT into TAdvisePaymentType  
  
-- INSERT - INTO Audit table:TAdvisePaymentTypeAudit for the above inserted data  
IF  EXISTS (SELECT * FROM policymanagement.sys.objects WHERE object_id = OBJECT_ID(N'[policymanagement].[dbo].[TAdvisePaymentTypeAudit]') AND type in (N'U')) BEGIN  
INSERT INTO [policymanagement]..TAdvisePaymentTypeAudit     
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
  FROM [policymanagement]..TAdvisePaymentType  
  WHERE [policymanagement]..TAdvisePaymentType.TenantId = @NewTenantId AND [policymanagement]..TAdvisePaymentType.GroupId IS NULL 
END  
 -- END OF INSERT - INTO Audit table  

-- INSERT - data for system defined rules into TRefAdviseFeeChargingType      
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
-- END OF INSERT into TRefAdviseFeeChargingType  

-- INSERT - INTO Audit table:TAdviseFeeChargingTypeAudit for the above inserted data     
IF EXISTS (
		SELECT *
		FROM policymanagement.sys.objects
		WHERE object_id = OBJECT_ID(N'[policymanagement].[dbo].[TAdviseFeeChargingTypeAudit]')
			AND type IN (N'U')
		)
BEGIN
	INSERT INTO [policymanagement]..TAdviseFeeChargingTypeAudit (
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
	FROM [policymanagement]..TAdviseFeeChargingType
	WHERE [policymanagement]..TAdviseFeeChargingType.TenantId = @NewTenantId
END
-- END OF INSERT - INTO Audit table TAdviseFeeChargingTypeAudit

-- INSERT - data for system defined rules into TTenantRuleConfiguration    
IF  EXISTS (SELECT * FROM policymanagement.sys.objects WHERE object_id = OBJECT_ID(N'[policymanagement].[dbo].[TTenantRuleConfiguration]') AND type in (N'U'))    
BEGIN    
 INSERT INTO policymanagement..TTenantRuleConfiguration(RefRuleConfigurationId,IsConfigured,TenantId)    
 SELECT TRefRuleConfiguration.RefRuleConfigurationId, DefaultConfiguration, @NewTenantId    
 FROM policymanagement..TRefRuleConfiguration               
END    
-- END OF INSERT into TTenantRuleConfiguration    
    
-- INSERT - INTO Audit table:TTenantRuleConfigurationAudit for the above inserted data   
 IF  EXISTS (SELECT * FROM policymanagement.sys.objects WHERE object_id = OBJECT_ID(N'[policymanagement].[dbo].[TTenantRuleConfigurationAudit]') AND type in (N'U'))  
  BEGIN  INSERT   
  INTO [policymanagement]..TTenantRuleConfigurationAudit       
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
FROM [policymanagement]..TTenantRuleConfiguration    
	WHERE [policymanagement]..TTenantRuleConfiguration.TenantId = @NewTenantId    
END    
 -- END OF INSERT - INTO Audit table
 
PRINT 'Step 17: Safely insert any missing Third Party Integration Configuration data'
EXEC PolicyManagement..SpCustomSetupThirdPartyIntegrationConfigurationData @SimplyBizNetworkAccountTenantId, @NewTenantId 

PRINT 'Step 18: Insert A System User for this tenant'                
EXEC nio_SpCustomAddSystemUserForTenant @NewTenantId

-- TIntegrationType table is populated which is required for the OBP export functionality to work
PRINT 'Step 19: Populate TIntegrationType for OBP export functionality '
insert crm..TIntegrationType(ConcurrencyId,TenantId,IntegrationTypeName,IsEnabled)
select 1,@NewTenantId,'OBPExport',1

-- Inserting UIDomainFieldAttribute config  defaults values
EXEC Administration..SpNCreateUpdateUIDomainFieldAttribute @NewTenantID, 'Opportunity', 'PropositionType', 'IsRequired', 'false', 0

exec administration..spCustomResetDefaultDashboards @NewTenantId, @SimplyBizNetworkAccountTenantId

Print 'Step 20: Make sure the tenant has a DocumentGeneratorVersion specified in TIndigoClientExtended'
EXEC [SpAdminCheckDocumentGeneratorVersion] @NewTenantId

Print 'Step 21: Populating default data into TAdviseFeeType for new tenant from master account (Simply Biz Parent Account)'
EXEC administration..spCustomDefaultAdviseFeeType @NewTenantID, @SimplyBizNetworkAccountTenantId

