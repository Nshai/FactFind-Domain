SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCustomConfigureTenant_AdvancedV2]
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
	,@Country varchar(255)='' --Added Country Checks - 19/02/2019
	,@Postcode varchar(255)
	,@SourceIndigoClientId bigint
	,@IsCloneOf bigint
	,@MaxUsersWithLoginAccess bigint
	,@RefTenantTypeId BIGINT -- 23/01/2019 - ALM - DM1615 - ADDED REFTENANTTYPEID
	,@RegionCode nvarchar(max) null
	,@AdminEmail varchar(255) = NULL
	,@SupportEmail varchar(255) = 'Please create a new case via the Community'
	,@StampUser varchar(255) = '-1010'
AS
BEGIN
-------------------
/*
	29/03/2018 - V1.0
	ALM - CREATED NEW SCRIPT TO ACCOMODATE WEALTH AND MORTAGE TENANTS AS WELL AS HAVING THE ABILITY TO CLONE FROM ANOTHER ACCOUNT IF REQUIRED
	ADDED VALIDATION CHECKS TO ENSURE ALL CLONED ACCOUNTS EXISTS BEFORE RUNNING THROUGH THE IMPLMENTATION

	23/01/2019 - ALM - DM1615 - ADDED REFTENANTTYPEID

 28/06/2019: IP-55689
 RUI - Added @NewTenantID, @SourceIndigoClientId to spCustomMegaConfigScript

 09/08/2019
 RUI - Check for multiple top level TGroup: Raise error to fix data

 26/06/2020 - ALM - Updated support email to point clients to communities - DM-2457
*/
-------------------
set @TenantName = nullif(ltrim(rtrim(@TenantName)),'')

declare @ProcName sysname = OBJECT_NAME(@@PROCID)

if @TenantName is null begin
	Raiserror('Tenant name cannot be blank!',16,1) with nowait
	return
end

-- lets create the tenant account
Declare @RefEnvironmentId bigint, @ExpiryDate datetime, @NewTenantGUID uniqueidentifier,@NewTenantID bigint
Declare @ParentGroupingID bigint, @CountyId bigint, @CountryId bigint	--, @SourceIndigoClientId bigint -ALM - DECLARED UP TOP - 29/03/2018
Declare @CloneAccountName VARCHAR(250)	--ALM - ADDED FOR CHECKS BELOW - 29/03/2018

declare
		@NumRecs int, -- Check for multiple top level Groups
		@msg varchar(max) -- To display error messages

declare @NewGUID uniqueidentifier -- To be used later

declare @ModuleName sysname = '', @procResult int


--select @SourceIndigoClientId=IndigoClientId from administration.dbo.TSourceIndigoClient --ALM - COMMENTED OUT AS NEW IMP S/S PASSES IN VARIABLE

--ADDED CONDITION TO CHECK IF ACCOUNT IS TO BE CLONED FROM ANOTHER ACCOUNT OTHER THAN THE WEALTH OR MORTGAGE ACCOUNTS - ALM - 29/03/2018
	--VALIDATE IF CLONE TENANT CAN BE FOUND
	IF (@IsCloneOf > 0)
	BEGIN
		Set @SourceIndigoClientId = 0
		select @SourceIndigoClientId = IndigoClientId
		FROM Administration.dbo.TIndigoClient WHERE IndigoClientId = @IsCloneOf

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
		select @CloneAccountName = Identifier
		FROM Administration.dbo.TIndigoClient WHERE IndigoClientId = @SourceIndigoClientId

		IF @CloneAccountName = 'NOT_FOUND'
		Begin
			PRINT 'Base Tenant not found. Check Tenant ID'
			RETURN (0)
		END
	END


	select @CloneAccountName = Identifier from Administration.dbo.TIndigoClient WHERE IndigoClientId = @SourceIndigoClientId
	PRINT 'Cloning your new Tenant based off of ' + @CloneAccountName + '''s Account. Tenant ' + CONVERT(VARCHAR(250),@SourceIndigoClientId)
--END OF CHECKS - ALM - 29/03/2018

-- RUI 09/08/2019 - Check for multiple top level TGroup: Raise error to fix data
-- RUI 09/08/2019 - Check for multiple top level TGroup: Raise error to fix data
declare @RetCode int = 0

exec @RetCode = dbo.spValidateTenantCloning @SourceIndigoClientId, @msg OUTPUT

if @RetCode!=0 begin
	raiserror(@msg,16,1) with nowait
	RETURN
end

--VALIDATE IF REFTENANTTYPE POPULATED ELSE SET TO 1 FOR LIVE -- 23/01/2019 - ALM - DM1615 - ADDED REFTENANTTYPEID
	IF (@RefTenantTypeId NOT IN (1,2,3,4))
	BEGIN
		PRINT 'Tenant type not specified, defaulting to LIVE account'
		SET @RefTenantTypeId = 1
	END
--END OF CHECKS -- 23/01/2019 - ALM - DM1615 - ADDED REFTENANTTYPEID

Set @RefEnvironmentId=1 --site 10
Set @ExpiryDate=DATEADD(yyyy,1,GetDate()) -- we add a year on

select @NewTenantGUID=NEWID()

if (@County!='')
Begin
	select @CountyId=RefCountyId from CRM.dbo.TRefCounty where CountyName=@County

	if (isnull(@CountyId,0)=0)
	Begin
		Print 'County not recognised'
	Return (0)
	End
End

If LEN(@TenantName)<1 OR LEN(@PrimaryContact)<1
Begin
	select 'No tenant [Name] specified or primary contact not provided'
End

--Added Country Checks - 19/02/2019
	IF (@Country = '')
	BEGIN
		SET @Country = 'United Kingdom'
	END

	IF (@Country!='')
	BEGIN
		select @CountryId=RefCountryId FROM CRM.dbo.TRefCountry WHERE CountryName=@Country

		IF (isnull(@CountryId,0)=0)
		BEGIN
			PRINT 'Country not recognised'
			RETURN (0)
		END
	END
--End of Country Checks - 19/02/2019


BEGIN TRY
	if not exists (select 1 from Administration.dbo.TIndigoClient
		where Identifier = @TenantName
			and PrimaryContact = @PrimaryContact
			and isnull(PhoneNumber,'') = isnull(@TelephoneNumber,'')
			and isnull(EmailAddress,'') = isnull(@EmailAddress,'')
			and isnull(FSA,'') = isnull(@FSANumber,'')
			and MaxULAGCount = @MaxUsersWithLoginAccess
			) begin
		insert into Administration.dbo.TIndigoClient
			(Identifier,Status,PrimaryContact,PhoneNumber,EmailAddress,NetworkId,FSA,IOProductType,ExpiryDate,AddressLine1,AddressLine2,AddressLine3,AddressLine4,
			CityTown,County,Postcode,Country,IsNetwork, FirmSize,Specialism,SupportLevel,EmailSupOptn,AdminEmail,SupportEmail,TelSupOptn,SupportTelephone,
			SessionTimeout,LicenceType, MaxULAGCount, IsIndependent, ServiceLevel, CaseLoggingOption, [Guid], RefEnvironmentId, IsPortfolioConstructionProvider, IsAuthorProvider,IsAtrProvider, ConcurrencyId, UADRestriction, AdviserCountRestrict, RefTenantTypeId) -- 23/01/2019 - ALM - DM1615 - ADDED REFTENANTTYPEID
		Values
			(@TenantName, 'active', @PrimaryContact, @TelephoneNumber, @EmailAddress,NULL,@FSANumber,'enterprise',@ExpiryDate,@AddressLine1,@AddressLine2,@AddressLine3,@AddressLine4,
			@CityTown,@CountyId,@Postcode, @CountryId, 0,'4-10 registered individuals','generalist','silver','standard', @AdminEmail, @SupportEmail, 'standard','Live chat is available via the community',
			60,'standard',@MaxUsersWithLoginAccess, 1,NULL,1,@NewTenantGUID,@RefEnvironmentId,0,0,0,1,0,0,@RefTenantTypeId) -- 23/01/2019 - ALM - DM1615 - ADDED REFTENANTTYPEID

		select @NewTenantID=SCOPE_IDENTITY()
	end else begin
		select @NewTenantID=IndigoClientId,
			@NewTenantGUID = [Guid]
		from Administration.dbo.TIndigoClient
		where Identifier = @TenantName
			and PrimaryContact = @PrimaryContact
			and isnull(PhoneNumber,'') = isnull(@TelephoneNumber,'')
			and isnull(EmailAddress,'') = isnull(@EmailAddress,'')
			and isnull(FSA,'') = isnull(@FSANumber,'')
			and MaxULAGCount = @MaxUsersWithLoginAccess

			set @msg = 'Reusing Tenant ID: '+Convert(varchar(10),isnull(@NewTenantID,0))
			print Replicate('-',len(@msg))
			print @msg
			print Replicate('-',len(@msg))
	end

	declare @serializedParameters nvarchar(max) = ''
	set @ModuleName = 'administration.dbo.spCustomConfigureTenant_AdvancedV2'
	select @serializedParameters = (select @TenantName as TenantName
	,@PrimaryContact as PrimaryContact
	,@TelephoneNumber as TelephoneNumber
	,@EmailAddress as EmailAddress
	,@FSANumber as FSANumber
	,@MCCBNumber as MCCBNumber
	,@AddressLine1 as AddressLine1
	,@AddressLine2 as AddressLine2
	,@AddressLine3 as AddressLine3
	,@AddressLine4 as AddressLine4
	,@CityTown as CityTown
	,@County as County
	,@Country as Country
	,@Postcode as Postcode
	,@SourceIndigoClientId as SourceIndigoClientId
	,@IsCloneOf as IsCloneOf
	,@MaxUsersWithLoginAccess as MaxUsersWithLoginAccess
	,@RefTenantTypeId as RefTenantTypeId
	,@RegionCode as RegionCode
	,@AdminEmail as AdminEmail
	,@SupportEmail as SupportEmail
	,@StampUser as StampUser
	FOR JSON PATH)
	exec dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	

	-- To Assign the Modern Skin to Tenant added.
	Declare @themeId uniqueidentifier
	select @themeId = ThemeId from administration.dbo.TTheme where ThemeId = '00000000-0000-0000-0000-000000000002'

	if (@themeId is not null)
	BEGIN
	-- Create an Entry in TAllocatedTheme

	-------------------------------------------------------------------
	set @ModuleName = 'insert into Administration.dbo.TAllocatedTheme'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

		insert into Administration.dbo.TAllocatedTheme(AllocatedThemeId,ThemeId,TenantId,IsActive)
		output
			inserted.AllocatedThemeId, inserted.ThemeId, inserted.TenantId, inserted.IsActive
			,'C', getdate(), @StampUser
		into Administration.dbo.TAllocatedThemeAudit(
			AllocatedThemeId, ThemeId, TenantId, IsActive
			, StampAction, StampDateTime, StampUser)
		VALUES (NEWID(),@themeId,@NewTenantID,1)


		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	END


	-------------------------------------------------------------------
	set @ModuleName = 'insert into administration.dbo.TIndigoClientLicense'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

	-- lets do the full license type
		insert into administration.dbo.TIndigoClientLicense(IndigoClientId,LicenseTypeId,Status,MaxConUsers,MaxULAGCount,
			UADRestriction,MaxULADCount,AdviserCountRestrict,MaxAdviserCount,MaxFinancialPlanningUsers, ConcurrencyId)
		output
			inserted.IndigoClientLicenseId, inserted.IndigoClientId, inserted.LicenseTypeId, inserted.[Status], inserted.MaxConUsers
			, inserted.MaxULAGCount, inserted.UADRestriction, inserted.MaxULADCount, inserted.AdviserCountRestrict, inserted.MaxAdviserCount
			, inserted.MaxFinancialPlanningUsers, inserted.ConcurrencyId, inserted.MaxAdvisaCentaCoreUsers, inserted.MaxAdvisaCentaCorePlusLifetimePlannerUsers
			,'C', getdate(), @StampUser
		into administration.dbo.TIndigoClientLicenseAudit(
			IndigoClientLicenseId, IndigoClientId, LicenseTypeId, [Status], MaxConUsers
			, MaxULAGCount, UADRestriction, MaxULADCount, AdviserCountRestrict, MaxAdviserCount
			, MaxFinancialPlanningUsers, ConcurrencyId, MaxAdvisaCentaCoreUsers, MaxAdvisaCentaCorePlusLifetimePlannerUsers
			, StampAction, StampDateTime, StampUser)
		Values(@NewTenantID, 1,1,NULL,@MaxUsersWithLoginAccess, 0,0,0,0,0,1) --ALM - 02/10/2014 - REMOVED ADDITION OF EXTRA LICENCE AGAINST @MaxUsersWithLoginAccess


		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	set @ModuleName = 'administration.dbo.SpCustomCreateIndigoClientCombined'
	declare @stampIndigoClient as varchar(50) = '0'
	select @serializedParameters = (select @NewTenantID as NewTenantID,
		@stampIndigoClient as StampIndigoClient
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

	-- lets create the combined record
		if not exists(select top 1 1 from administration.dbo.TIndigoClientCombined where IndigoClientId = @NewTenantID)
			exec administration.dbo.SpCustomCreateIndigoClientCombined @NewTenantID, @stampIndigoClient

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	-------------------------------------------------------------------
	set @ModuleName = 'insert into administration.dbo.TPasswordPolicy'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

		-- lets copy the password policy from base account
		if not exists(select top 1 1 from administration.dbo.TPasswordPolicy where IndigoClientId = @NewTenantID)
		insert into administration.dbo.TPasswordPolicy(Expires,ExpiryDays,UniquePasswords,MaxFailedLogins,AllowExpireAllPasswords,
			AllowAutoUserNameGeneration,IndigoClientId,ConcurrencyId)
		output
			inserted.PasswordPolicyId, inserted.Expires, inserted.ExpiryDays, inserted.UniquePasswords, inserted.MaxFailedLogins, inserted.ChangePasswordOnFirstUse, inserted.AutoPasswordGeneration
			, inserted.AllowExpireAllPasswords, inserted.AllowAutoUserNameGeneration, inserted.IndigoClientId, inserted.ConcurrencyId, inserted.LockoutPeriodMinutes, inserted.NumberOfMonthsBeforePasswordReuse
			,'C', getdate(), @StampUser
		into administration.dbo.TPasswordPolicyAudit(
			PasswordPolicyId, Expires, ExpiryDays, UniquePasswords, MaxFailedLogins, ChangePasswordOnFirstUse, AutoPasswordGeneration
			, AllowExpireAllPasswords, AllowAutoUserNameGeneration, IndigoClientId, ConcurrencyId, LockoutPeriodMinutes, NumberOfMonthsBeforePasswordReuse
			, StampAction, StampDateTime, StampUser)
		select Expires,ExpiryDays,UniquePasswords,MaxFailedLogins,AllowExpireAllPasswords,
			AllowAutoUserNameGeneration,@NewTenantID,1
		from administration.dbo.TPasswordPolicy WHERE indigoclientid=@SourceIndigoClientId


		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	-------------------------------------------------------------------
	set @ModuleName = 'administration.dbo.spCustomCreateGroupingForNewTenant'
	select @serializedParameters = (select @NewTenantID as NewTenantID,
		@SourceIndigoClientId as SourceIndigoClientId
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

	-- Create the Grouping
		exec administration.dbo.spCustomCreateGroupingForNewTenant @NewTenantID, @SourceIndigoClientId

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	-------------------------------------------------------------------
	set @ModuleName = 'administration.dbo.spCustomCreateGroupForNewTenant'
	select @serializedParameters = (select @NewTenantID as NewTenantID,
		@SourceIndigoClientId as SourceIndigoClientId
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

	-- create the Group
		exec administration.dbo.spCustomCreateGroupForNewTenant @NewTenantID, @SourceIndigoClientId

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	-------------------------------------------------------------------
	set @ModuleName = 'administration.dbo.spCustomCreateRolesForNewTenant'
	select @serializedParameters = (select @NewTenantID as NewTenantID,
		@SourceIndigoClientId as SourceIndigoClientId
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

	-- ok lets now do the roles
		exec administration.dbo.spCustomCreateRolesForNewTenant @NewTenantID, @SourceIndigoClientId

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end



	-- Fill up some role and group related variables to make the following script work
	DECLARE @NewGroupId BIGINT, @RoleId BIGINT, @CorporateId BIGINT, @AdministratorUserId bigint

	select @NewGroupId = GroupId FROM Administration.dbo.TGroup WHERE IndigoClientid=@NewTenantID AND ParentId is null
	select @RoleId = RoleId FROM Administration.dbo.TRole WHERE IndigoClientid=@NewTenantID AND Identifier LIKE 'System Administrator'
	select top 1 @CorporateId = CorporateId FROM CRM.dbo.TCorporate WHERE IndClientid=@NewTenantID --AND CorporateName LIKE 'Organisation'
	order by CorporateId

	-------------------------------------------------------------------
	set @ModuleName = 'administration.dbo.SpCustomCreateIntellifloSupportUser 1'
	select @serializedParameters = (select @NewTenantID as NewTenantID
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

		exec administration.dbo.SpCustomCreateIntellifloSupportUser @NewTenantID
		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	set @AdministratorUserId = (select MIN(userid) from administration.dbo.TUser where IndigoClientId = @NewTenantID AND RefUserTypeId = 6)

	-------------------------------------------------------------------
	set @ModuleName = 'administration.dbo.SpCustomCreateIntellifloSupportUser 2'
	select @serializedParameters = (select @NewTenantID as NewTenantID
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

	-- create a second support user
		exec administration.dbo.SpCustomCreateIntellifloSupportUser @NewTenantID

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	set @ModuleName = 'lets create the corporate client for the tenant contact'
	-- lets create the corporate client for the tenant contact
	Declare @NewTenantCRMContactId bigint

	select @CorporateId = CorporateId
	from CRM.dbo.TCorporate
	where IndClientId = @NewTenantID
		and CorporateName = @TenantName

	if @CorporateId is null begin
		insert into CRM.dbo.TCorporate (IndClientId, CorporateName)
		VALUES (@NewTenantID, @TenantName)

		SET @CorporateId=SCOPE_IDENTITY()
	end

	set @ModuleName = 'Creating CrmContact for '+isnull(@TenantName,'EMPTY')

	select @NewTenantCRMContactId = CRMContactId
	from CRM.dbo.TCRMContact
	where IndClientId = @NewTenantID
		and RefCRMContactStatusId = 1
		and CorporateId = @CorporateId
		and CorporateName = @TenantName

	if @NewTenantCRMContactId is null begin
		insert into CRM.dbo.TCRMContact (RefCRMContactStatusId, CorporateId, ArchiveFG, CorporateName,
		originaladviserCRMID, CurrentAdviserCRMId, CRMContactType, IndClientId, InternalContactFG, CreatedDate, externalreference, concurrencyid)
		Values (1,@CorporateId,0, @TenantName, 0,0,3,@NewTenantID, 1,getDate(),null,1)

		SET @NewTenantCRMContactId=SCOPE_IDENTITY()
	end


	UPDATE administration.dbo.TindigoClient SET PrimaryGroupId=@NewGroupId,contactid=@NewTenantCRMContactId WHERE indigoclientid=@NewTenantID

	-------------------------------------------------------------------
	set @ModuleName = 'insert into Administration tables'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

	-- lets do the statushistory
		insert into administration.dbo.TOrganisationStatusHistory(IndigoClientId, Identifier, changedatetime, changeuser)
		output
			inserted.OrganisationStatusHistoryId, inserted.IndigoClientId, inserted.Identifier, inserted.ChangeDateTime, inserted.ChangeUser, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into administration.dbo.TOrganisationStatusHistoryAudit(
			OrganisationStatusHistoryId, IndigoClientId, Identifier, ChangeDateTime, ChangeUser, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		values (@NewTenantID, 'active',getdate(),@AdministratorUserId)

	-- lets do administration standing data
		insert into administration.dbo.TIndClientCommissionDef (IndigoClientId,AllowClawbackFG,DateOrder,PayCurrentGroupFG,RecalcIntroducerSplitFG,RecalcPractPercentFG,DefaultPayeeEntityId,PMMaxDiffAmount,PMUseLinkProviderFG,
		PMUseLookupFG,PMMatchSurnameFirstFG,PMMatchSurnameLastFG,PMMatchCompanyNameFG,CMUseLinkProviderFG,CMProvDescLength,CMDateRangeUpper,
		CMDateRangeLower,MinBACSAmount,ConcurrencyId)
		output
			inserted.IndClientCommissionDefId, inserted.IndigoClientId, inserted.AllowClawbackFG, inserted.DateOrder, inserted.PayCurrentGroupFG, inserted.RecalcIntroducerSplitFG, inserted.RecalcPractPercentFG
			, inserted.DefaultPayeeEntityId, inserted.PMMaxDiffAmount, inserted.PMUseLinkProviderFG, inserted.PMUseLookupFG, inserted.PMMatchSurnameFirstFG, inserted.PMMatchSurnameLastFG, inserted.PMMatchCompanyNameFG
			, inserted.CMUseLinkProviderFG, inserted.CMProvDescLength, inserted.CMDateRangeUpper, inserted.CMDateRangeLower, inserted.MinBACSAmount, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into administration.dbo.TIndClientCommissionDefAudit(
			IndClientCommissionDefId, IndigoClientId, AllowClawbackFG, DateOrder, PayCurrentGroupFG, RecalcIntroducerSplitFG, RecalcPractPercentFG
			, DefaultPayeeEntityId, PMMaxDiffAmount, PMUseLinkProviderFG, PMUseLookupFG, PMMatchSurnameFirstFG, PMMatchSurnameLastFG, PMMatchCompanyNameFG
			, CMUseLinkProviderFG, CMProvDescLength, CMDateRangeUpper, CMDateRangeLower, MinBACSAmount, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @NewTenantID,AllowClawbackFG,DateOrder,PayCurrentGroupFG,RecalcIntroducerSplitFG,RecalcPractPercentFG,DefaultPayeeEntityId,PMMaxDiffAmount,PMUseLinkProviderFG,
			PMUseLookupFG,PMMatchSurnameFirstFG,PMMatchSurnameLastFG,PMMatchCompanyNameFG,CMUseLinkProviderFG,CMProvDescLength,CMDateRangeUpper,
			CMDateRangeLower,MinBACSAmount,1
		FROM administration.dbo.TIndClientCommissionDef WHERE IndigoClientId=@SourceIndigoClientId

		insert into administration.dbo.TRunning(RebuildKeys,IndigoClientId,ConcurrencyId)
		output
			inserted.RunningId, inserted.RebuildKeys, inserted.IndigoClientId, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into Administration.dbo.TRunningAudit(
			RunningId, RebuildKeys, IndigoClientId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select RebuildKeys,@NewTenantID,1
		FROM Administration.dbo.TRunning WHERE IndigoClientId=@SourceIndigoClientId
		except -- Avoid duplicates!
		select RebuildKeys,IndigoClientId,1
		FROM Administration.dbo.TRunning WHERE IndigoClientId=@NewTenantID


		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-- Author
	-------------------------------------------------------------------
	set @ModuleName = 'insert into Author.dbo.TParagraphType'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

		insert into Author.dbo.TParagraphType(Identifier,IndigoClientId,Extensible,ConcurrencyId)
		output
			inserted.ParagraphTypeId, inserted.Identifier, inserted.IndigoClientId, inserted.Extensible, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into Author.dbo.TParagraphTypeAudit(
			ParagraphTypeId, Identifier, IndigoClientId, Extensible, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select Identifier,@NewTenantID,Extensible,1
		from Author.dbo.TParagraphType where indigoclientid=@SourceIndigoClientId

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-- commissions
	-------------------------------------------------------------------
	set @ModuleName = 'insert into Commissions.dbo.TRef tables'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

		insert into commissions.dbo.TPotMatchTimetable (IndClientId,RepeatCount,RefPotMatchTimetableTypeId,Extensible,ConcurrencyId)
		output
			inserted.PotMatchTimetableId, inserted.IndClientId, inserted.RepeatCount, inserted.RefPotMatchTimetableTypeId, inserted.Extensible, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into commissions.dbo.TPotMatchTimetableAudit(
			PotMatchTimetableId, IndClientId, RepeatCount, RefPotMatchTimetableTypeId, Extensible, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @NewTenantID,RepeatCount,RefPotMatchTimetableTypeId,Extensible,1
		from commissions.dbo.TPotMatchTimetable where indclientid=@SourceIndigoClientId

		insert into commissions.dbo.TPeriodComHist(IndClientId,StartDatetime,EndDatetime,RunDatetime,UserId,Extensible,ConcurrencyId)
		output
			inserted.PeriodComHistId, inserted.IndClientId, inserted.StartDatetime, inserted.EndDatetime, inserted.RunDatetime
			, inserted.UserId, inserted.Extensible, inserted.ConcurrencyId, inserted.[Description]
			,'C', getdate(), @StampUser
		into commissions.dbo.TPeriodComHistAudit(
			PeriodComHistId, IndClientId, StartDatetime, EndDatetime, RunDatetime
			, UserId, Extensible, ConcurrencyId, [Description]
			, StampAction, StampDateTime, StampUser)
		Values (@NewTenantID, GetDate(), null, null, null, null, 1)

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-- compliance
	-------------------------------------------------------------------
	set @ModuleName = 'insert into Compliance.dbo.TRef tables'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

		insert into compliance.dbo.TRefCorrespondenceType (CorrespondenceType,IndClientId,ConcurrencyId)
		output
			inserted.RefCorrespondenceTypeId, inserted.CorrespondenceType, inserted.IndClientId, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into compliance.dbo.TRefCorrespondenceTypeAudit(
			RefCorrespondenceTypeId, CorrespondenceType, IndClientId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select CorrespondenceType,@NewTenantID,1
		from compliance.dbo.TRefCorrespondenceType where IndClientId=@SourceIndigoClientId

		insert into compliance.dbo.TRefFileCheckFailStatus(FileCheckFailStatus,IndClientId,ConcurrencyId)
		output
			inserted.RefFileCheckFailStatusId, inserted.FileCheckFailStatus, inserted.IndClientId, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into compliance.dbo.TRefFileCheckFailStatusAudit(
			RefFileCheckFailStatusId, FileCheckFailStatus, IndClientId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select FileCheckFailStatus,@NewTenantID ,ConcurrencyId
		from compliance.dbo.TRefFileCheckFailStatus where IndClientId=@SourceIndigoClientId

		insert into compliance.dbo.TRefRiskStatus (RiskStatusDescription,RefRiskCategoryId,IsDisabled,IndClientId,ConcurrencyId)
		output
			inserted.RefRiskStatusId, inserted.RiskStatusDescription, inserted.RefRiskCategoryId, inserted.IsDisabled, inserted.IndClientId, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into compliance.dbo.TRefRiskStatusAudit(
			RefRiskStatusId, RiskStatusDescription, RefRiskCategoryId, IsDisabled, IndClientId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select RiskStatusDescription,RefRiskCategoryId,IsDisabled,@NewTenantID,1
		from compliance.dbo.TRefRiskStatus where IndClientId=@SourceIndigoClientId

		insert into compliance.dbo.TRefTrainingCourse (IndClientId,CourseName,CPDHours,IsProductRelated,RefPlanTypeId,
			RefCourseCategoryId,CourseAvailableDate,CourseExpiryDate,CourseNotes,ConcurrencyId)
		output
			inserted.RefTrainingCourseId, inserted.IndClientId, inserted.CourseName, inserted.CPDHours, inserted.IsProductRelated, inserted.RefPlanTypeId
			, inserted.RefCourseCategoryId, inserted.CourseAvailableDate, inserted.CourseExpiryDate, inserted.CourseNotes, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into compliance.dbo.TRefTrainingCourseAudit(
			RefTrainingCourseId, IndClientId, CourseName, CPDHours, IsProductRelated, RefPlanTypeId
			, RefCourseCategoryId, CourseAvailableDate, CourseExpiryDate, CourseNotes, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @NewTenantID,CourseName,CPDHours,IsProductRelated,RefPlanTypeId,
			RefCourseCategoryId,CourseAvailableDate,CourseExpiryDate,CourseNotes,1
		from compliance.dbo.TRefTrainingCourse
		where IndClientId=@SourceIndigoClientId

	-- Tcompliance Set up is dealt with later
		insert into Compliance.dbo.TComplianceSetup (IndClientId)
		output
			inserted.ComplianceSetupId, inserted.IndClientId, inserted.AcknolwdgeComplaintDays, inserted.ShdComplaintsNotifyUsersByEmail, inserted.ShdDocumentPredateSubmission
			, inserted.ShdQuotePredateSubmission, inserted.CanBeOwnTnCCoach, inserted.RequireTnCCoach, inserted.TnCCoachControlSpan, inserted.PractitionerRoleId, inserted.TnCRoleId
			, inserted.FileCheckRoleId, inserted.PassThroughTnCCheckingForFees, inserted.PassThroughTnCCheckingForRetainers, inserted.AdviceCaseCheckingEnabled, inserted.ConcurrencyId
			, inserted.AssignToTncCoachForPreSale, inserted.AssignToTncCoachForPostSale, inserted.ComplianceGradeRoleId, inserted.DefaultServicingAdministratorToLoggedInUser
			,'C', getdate(), @StampUser
		into Compliance.dbo.TComplianceSetupAudit(
			ComplianceSetupId, IndClientId, AcknolwdgeComplaintDays, ShdComplaintsNotifyUsersByEmail, ShdDocumentPredateSubmission
			, ShdQuotePredateSubmission, CanBeOwnTnCCoach, RequireTnCCoach, TnCCoachControlSpan, PractitionerRoleId, TnCRoleId
			, FileCheckRoleId, PassThroughTnCCheckingForFees, PassThroughTnCCheckingForRetainers, AdviceCaseCheckingEnabled, ConcurrencyId
			, AssignToTncCoachForPreSale, AssignToTncCoachForPostSale, ComplianceGradeRoleId, DefaultServicingAdministratorToLoggedInUser
			, StampAction, StampDateTime, StampUser)
		Values(@NewTenantID)

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-- CRM
	-------------------------------------------------------------------
	set @ModuleName = 'insert into CRM.dbo.TRef tables'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

		insert into CRM.dbo.TRefAccType(IndClientId,[Name],[Description],ActiveFG,ConcurrencyId)
		output
			inserted.RefAccTypeId, inserted.IndClientId, inserted.[Name], inserted.[Description], inserted.ActiveFG, inserted.Extensible, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into CRM.dbo.TRefAccTypeAudit(
			RefAccTypeId, IndClientId, [Name], [Description], ActiveFG, Extensible, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @NewTenantID,[Name],[Description],ActiveFG,1
		from CRM.dbo.TRefAccType where IndClientId=@SourceIndigoClientId

		insert into crm.dbo.TRefAccUse(IndClientId,AccountUseDesc,ConcurrencyId)
		output
			inserted.RefAccUseId, inserted.IndClientId, inserted.AccountUseDesc, inserted.Extensible, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into crm.dbo.TRefAccUseAudit(
			RefAccUseId, IndClientId, AccountUseDesc, Extensible, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @NewTenantID,AccountUseDesc,1
		from crm.dbo.TRefAccUse where IndClientId=@SourceIndigoClientId

		insert into CRM.dbo.TRefCategoryAM([Description],ArchiveFG,IndClientId,ConcurrencyId)
		output
			inserted.RefCategoryAMId, inserted.[Description], inserted.ArchiveFG, inserted.IndClientId, inserted.Extensible, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into CRM.dbo.TRefCategoryAMAudit(
			RefCategoryAMId, [Description], ArchiveFG, IndClientId, Extensible, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select [Description],ArchiveFG,@NewTenantID,1
		from CRM.dbo.TRefCategoryAM where IndClientId=@SourceIndigoClientId

		insert into CRM.dbo.TRefIntroducerType (IndClientId,ShortName,LongName,MinSplitRange,MaxSplitRange,
			DefaultSplit,RenewalsFG,ArchiveFG,ConcurrencyId)
		output
			inserted.RefIntroducerTypeId, inserted.IndClientId, inserted.ShortName, inserted.LongName, inserted.MinSplitRange, inserted.MaxSplitRange
			, inserted.DefaultSplit, inserted.RenewalsFG, inserted.ArchiveFG, inserted.Extensible, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into CRM.dbo.TRefIntroducerTypeAudit(
			RefIntroducerTypeId, IndClientId, ShortName, LongName, MinSplitRange, MaxSplitRange
			, DefaultSplit, RenewalsFG, ArchiveFG, Extensible, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @NewTenantID,ShortName,LongName,MinSplitRange,MaxSplitRange,
			DefaultSplit,RenewalsFG,ArchiveFG,1
			from CRM.dbo.TRefIntroducerType where IndClientId=@SourceIndigoClientId

	-------------------------------------------------------------------

		insert into CRM.dbo.TRefOpportunityStage(IndClientId,[Description],Probability,OpenFG,ClosedFG,WonFG,ConcurrencyId)
		output
			inserted.RefOpportunityStageId, inserted.IndClientId, inserted.[Description], inserted.Probability, inserted.OpenFG, inserted.ClosedFG, inserted.WonFG, inserted.Extensible, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into CRM.dbo.TRefOpportunityStageAudit(
			RefOpportunityStageId, IndClientId, [Description], Probability, OpenFG, ClosedFG, WonFG, Extensible, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @NewTenantID,[Description],Probability,OpenFG,ClosedFG,WonFG,1
		from CRM.dbo.TRefOpportunityStage where IndClientId=@SourceIndigoClientId

	-------------------------------------------------------------------

		insert into CRM.dbo.TRefPaymentType(IndClientId,[Name],[Description],ActiveFG,ConcurrencyId)
		output
			inserted.RefPaymentTypeId, inserted.IndClientId, inserted.[Name], inserted.[Description], inserted.ActiveFG, inserted.Extensible, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into CRM.dbo.TRefPaymentTypeAudit(
			RefPaymentTypeId, IndClientId, [Name], [Description], ActiveFG, Extensible, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @NewTenantID, [Name],[Description],ActiveFG,1
		from CRM.dbo.TRefPaymentType where IndClientId=@SourceIndigoClientId

	-------------------------------------------------------------------

		insert into CRM.dbo.TRefShowTimeAs([Description],Color,FreeFG,IndClientId,ConcurrencyId)
		output
			inserted.RefShowTimeAsId, inserted.[Description], inserted.Color, inserted.FreeFG, inserted.IndClientId, inserted.Extensible, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into CRM.dbo.TRefShowTimeAsAudit(
			RefShowTimeAsId, [Description], Color, FreeFG, IndClientId, Extensible, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select [Description],Color,FreeFG, @NewTenantID, 1
		from CRM.dbo.TRefShowTimeAs where IndClientId=@SourceIndigoClientId

	-------------------------------------------------------------------

		insert into CRM.dbo.TRefServiceStatus(ServiceStatusName,IndigoClientId,IsArchived,IsPropagated,ReportFrequency,ReportStartDateType,ConcurrencyId)
		output
			inserted.RefServiceStatusId, inserted.ServiceStatusName, inserted.IndigoClientId, inserted.ConcurrencyId, inserted.IsArchived, inserted.GroupId
			, inserted.IsPropagated, inserted.ReportFrequency, inserted.ReportStartDateType, inserted.ReportStartDate
			,'C', getdate(), @StampUser
		into CRM.dbo.TRefServiceStatusAudit(
			RefServiceStatusId, ServiceStatusName, IndigoClientId, ConcurrencyId, IsArchived, GroupId, IsPropagated, ReportFrequency, ReportStartDateType, ReportStartDate
			, StampAction, StampDateTime, StampUser)
		select ServiceStatusName,@NewTenantID,IsArchived,IsPropagated,ReportFrequency,ReportStartDateType,1
		from CRM.dbo.TRefServiceStatus where IndigoClientId=@SourceIndigoClientId

	-------------------------------------------------------------------

		insert into CRM.dbo.TPostCodeAllocation(IndigoClientId,MaxDistance,AllocationTypeId,CanAssignPostCodeMoreThanOne,CanAssignAdviserMoreThanOne,ConcurrencyId)
		output
			inserted.PostCodeAllocationId, inserted.IndigoClientId, inserted.MaxDistance, inserted.AllocationTypeId, inserted.ConcurrencyId, inserted.SecondaryAllocationTypeId, inserted.CanAssignPostCodeMoreThanOne, inserted.CanAssignAdviserMoreThanOne
			,'C', getdate(), @StampUser
		into CRM.dbo.TPostCodeAllocationAudit(
			PostCodeAllocationId, IndigoClientId, MaxDistance, AllocationTypeId, ConcurrencyId, SecondaryAllocationTypeId, CanAssignPostCodeMoreThanOne, CanAssignAdviserMoreThanOne
			, StampAction, StampDateTime, StampUser)
		select @NewTenantID, MaxDistance,AllocationTypeId,CanAssignPostCodeMoreThanOne,CanAssignAdviserMoreThanOne,1
		from CRM.dbo.TPostCodeAllocation where IndigoClientId=@SourceIndigoClientId

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	-- Activity category stuff is moved to SpCustomMegaConfigScript (AME-424)

	-------------------------------------------------------------------
	set @ModuleName = 'insert into CRM.dbo.TFactFindSearch'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin
	-- lets do the fact find search stuff
		insert into CRM.dbo.TFactFindSearch(RefFactFindSearchTypeId,IndigoClientId, concurrencyid)
		output
			inserted.FactFindSearchId, inserted.RefFactFindSearchTypeId, inserted.IndigoClientId, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into CRM.dbo.TFactFindSearchAudit(
			FactFindSearchId, RefFactFindSearchTypeId, IndigoClientId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select RefFactFindSearchTypeId,@NewTenantID, concurrencyid
		from CRM.dbo.TFactFindSearch
		where indigoclientid=@SourceIndigoClientId

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	-------------------------------------------------------------------
	set @ModuleName = 'insert into FactFind.dbo.TAtrCategory'
	declare @NewAtrCategoryGuid uniqueidentifier = NEWID()
	select @serializedParameters = (select @StampUser as StampUser,
		@NewAtrCategoryGuid as NewAtrCategoryGuid
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

		if not exists(select 1 from FactFind.dbo.TAtrCategory where TenantId = @NewTenantID and TenantGuid = @NewTenantGuid and [Name]='Default') begin

	--lets add a default atr risk category
			insert into FactFind.dbo.TAtrCategory([Guid],TenantId,TenantGuid,[Name],IsArchived,ConcurrencyId)
			output
				inserted.AtrCategoryId, inserted.[Guid], inserted.TenantId, inserted.TenantGuid, inserted.[Name], inserted.IsArchived, inserted.ConcurrencyId
				,'C', getdate(), @StampUser
			into FactFind.dbo.TAtrCategoryAudit(
				AtrCategoryId, [Guid], TenantId, TenantGuid, [Name], IsArchived, ConcurrencyId
				,StampAction, StampDateTime, StampUser)
			values(@NewAtrCategoryGuid, @NewTenantID, @NewTenantGuid, 'Default',0,1)

			exec FactFind.dbo.SpCustomCreateAtrCategoryCombined @StampUser, @NewAtrCategoryGuid
		end

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end



	-------------------------------------------------------------------
	set @ModuleName = 'administration.dbo.SpCreateMortgageChecklist'
		select @serializedParameters = (select @NewTenantID as NewTenantID,
		@SourceIndigoClientId as SourceIndigoClientId
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

	--Mortgage Checklist Question and Mortgage checklist Category data
		exec administration.dbo.SpCreateMortgageChecklist @SourceIndigoClientId, @NewTenantID

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	-- lets do the types
	Declare @FactFindSearchId bigint, @RefFactFindSearchTypeId bigint

	-------------------------------------------------------------------
	set @ModuleName = 'insert into CRM.dbo.TFactFindSearchPlanType'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

	-- lets copy the hierarchy
		DECLARE factfindsearch_cursor CURSOR
		FOR select FactFindSearchId, RefFactFindSearchTypeId FROM CRM.dbo.TFactFindSearch
		where indigoclientid=@NewTenantID
		OPEN factfindsearch_cursor

		FETCH NEXT FROM factfindsearch_cursor Into @FactFindSearchId, @RefFactFindSearchTypeId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			insert into CRM.dbo.TFactFindSearchPlanType (FactFindSearchId,RefPlanTypeId,ConcurrencyId)
			select @FactFindSearchId,RefPlanTypeId,A.ConcurrencyId from CRM.dbo.TFactFindSearchPlanType A
			Inner Join CRM.dbo.TFactFindSearch B on a.factfindsearchid=b.factfindsearchid
			where IndigoClientId=@SourceIndigoClientId and b.RefFactFindSearchTypeId=@RefFactFindSearchTypeId

			FETCH NEXT FROM factfindsearch_cursor Into @FactFindSearchId, @RefFactFindSearchTypeId
		END

		CLOSE factfindsearch_cursor
		DEALLOCATE factfindsearch_cursor

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-- documentmanagement
	-------------------------------------------------------------------
	set @ModuleName = 'insert into documentmanagement.dbo.TCategory'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

		insert into documentmanagement.dbo.TCategory(Identifier,Descriptor,Notes,IndigoClientId,Archived,ConcurrencyId)
		output
			inserted.CategoryId, inserted.Identifier, inserted.Descriptor, inserted.Notes, inserted.IndigoClientId, inserted.Archived, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into documentmanagement.dbo.TCategoryAudit(
			CategoryId, Identifier, Descriptor, Notes, IndigoClientId, Archived, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select Identifier,Descriptor,Notes,@NewTenantID,Archived,1
		from documentmanagement.dbo.TCategory where IndigoClientId=@SourceIndigoClientId

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	set @ModuleName = 'insert into documentmanagement.dbo.TSubCategory'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

		insert into documentmanagement.dbo.TSubCategory (Identifier,Descriptor,Notes,IndigoClientId,Archived,ConcurrencyId)
		output
			inserted.SubCategoryId, inserted.Identifier, inserted.Descriptor, inserted.Notes, inserted.IndigoClientId, inserted.Archived, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into documentmanagement.dbo.TSubCategoryAudit(
			SubCategoryId, Identifier, Descriptor, Notes, IndigoClientId, Archived, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select Identifier,Descriptor,Notes,@NewTenantID,Archived,1
		from documentmanagement.dbo.TSubCategory where IndigoClientId=@SourceIndigoClientId

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	-------------------------------------------------------------------
	set @ModuleName = 'administration.dbo.spCustomMegaConfigScriptV2'
		select @serializedParameters = (select @NewTenantID as NewTenantID,
		@SourceIndigoClientId as SourceIndigoClientId,
		@RegionCode as RegionCode
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

	-- lets mega escript this bad boy
	-- RUI 28/06/2019: IP-55689 - Added @NewTenantID, @SourceIndigoClientId
		exec administration.dbo.spCustomMegaConfigScriptV2 @NewTenantID, @SourceIndigoClientId, @RegionCode

		update administration..TindigoClient set SupportEmail = @SupportEmail, supporttelephone='0330 102 8400' where indigoclientid = @NewTenantId--26/06/2020 - ALM - Updated support email to point clients to communities - DM-2457

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	--ALM - ADDED AUTO DOC STORAGE ALLOCATION (02/09/2015)
	declare @DocStorageValue bigint

	--ALM - Increased Storage from 200MB to 400MB per licence (03/02/2016)
	Set @DocStorageValue = (419430400 * @MaxUsersWithLoginAccess)

	-------------------------------------------------------------------
	set @ModuleName = 'insert into Documentmanagement.dbo.TDocStorage'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

		insert into Documentmanagement.dbo.TDocStorage(IndigoClientId, SpaceAllocated, SpaceUsed, ConcurrencyId)
		output
			inserted.DocStorageId, inserted.IndigoClientId, inserted.SpaceAllocated, inserted.SpaceUsed, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into Documentmanagement.dbo.TDocStorageAudit(
			DocStorageId, IndigoClientId, SpaceAllocated, SpaceUsed, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select @NewTenantID, @DocStorageValue, 0,1

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	--ALM - REMOVED AND REPLACED WITH SCRIPT ABOVE (02/09/2015)
	/*
	insert into documentmanagement.dbo.tdocstorage(indigoclientid, spaceallocated, spaceused)
	values (@NewTenantID, '10000','0')
	*/

	-------------------------------------------------------------------
	set @ModuleName = 'insert into CRM.dbo.TAccountType'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

	-- lets do the account type
		insert into CRM.dbo.TAccountType(AccountTypeName, IsForCorporate, IsForIndividual, IsNotModifiable, IsArchived, IndigoClientId, ConcurrencyId)
		output
			inserted.AccountTypeId, inserted.AccountTypeName, inserted.IsForCorporate, inserted.IsForIndividual, inserted.IsNotModifiable, inserted.IsArchived, inserted.IndigoClientId, inserted.ConcurrencyId
			,'C', getdate(), @StampUser
		into CRM.dbo.TAccountTypeAudit(
			AccountTypeId, AccountTypeName, IsForCorporate, IsForIndividual, IsNotModifiable, IsArchived, IndigoClientId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select AccountTypeName, IsForCorporate, IsForIndividual, IsNotModifiable, IsArchived, @NewTenantID, 1
		From CRM.dbo.TAccountType
		Where indigoclientid=@SourceIndigoClientId

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	set @ModuleName = 'insert into policymanagement.dbo.TAdvisePaymentType'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

	-- INSERT - data for system defined advise payment types into TAdvisePaymentType
	--(exclude 'By Provider')
		insert into policymanagement.dbo.TAdvisePaymentType(TenantId,IsArchived,[Name],IsSystemDefined)
		output
			inserted.AdvisePaymentTypeId, inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId, inserted.[Name], inserted.IsSystemDefined, inserted.GroupId, inserted.RefAdvisePaidById, inserted.PaymentProviderId
			,'C', getdate(), @StampUser
		into policymanagement.dbo.TAdvisePaymentTypeAudit (
			AdvisePaymentTypeId, TenantId, IsArchived, ConcurrencyId, [Name], IsSystemDefined, GroupId, RefAdvisePaidById, PaymentProviderId
			, StampAction, StampDateTime, StampUser)
		select @NewTenantID, 0, [Name], 1
		FROM policymanagement.dbo.TRefAdvisePaymentType WHERE [Name] NOT IN ('By Provider')

	--(include 'By Provider')
		DECLARE @RefAdvisePaidById bigint
		select @RefAdvisePaidById = RefAdvisePaidById FROM policymanagement.dbo.TRefAdvisePaidBy WHERE [Name] = 'Provider'

		insert into policymanagement.dbo.TAdvisePaymentType(TenantId,IsArchived,[Name],IsSystemDefined, RefAdvisePaidById)
		output
			inserted.AdvisePaymentTypeId, inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId, inserted.[Name], inserted.IsSystemDefined, inserted.GroupId, inserted.RefAdvisePaidById, inserted.PaymentProviderId
			,'C', getdate(), @StampUser
		into policymanagement.dbo.TAdvisePaymentTypeAudit (
			AdvisePaymentTypeId, TenantId, IsArchived, ConcurrencyId, [Name], IsSystemDefined, GroupId, RefAdvisePaidById, PaymentProviderId
			, StampAction, StampDateTime, StampUser)
		select @NewTenantID, 0, [Name], 1, @RefAdvisePaidById
		FROM policymanagement.dbo.TRefAdvisePaymentType WHERE [Name] IN ('By Provider')

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	-------------------------------------------------------------------
	set @ModuleName = 'insert into policymanagement.dbo.TAdviseFeeChargingType'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

	-- INSERT - data for system defined rules into TAdviseFeeChargingType
		insert into policymanagement.dbo.TAdviseFeeChargingType (RefAdviseFeeChargingTypeId, TenantId, IsArchived, ConcurrencyId, GroupId)
		output
			inserted.AdviseFeeChargingTypeId, inserted.RefAdviseFeeChargingTypeId, inserted.TenantId, inserted.IsArchived, inserted.ConcurrencyId, inserted.GroupId
			,'C', GETDATE(), @StampUser
		into policymanagement.dbo.TAdviseFeeChargingTypeAudit(
			AdviseFeeChargingTypeId, RefAdviseFeeChargingTypeId, TenantId, IsArchived, ConcurrencyId, GroupId
			,StampAction, StampDateTime, StampUser)
		select RefAdviseFeeChargingTypeId, @NewTenantID, 0, 1,NULL
		FROM policymanagement.dbo.TRefAdviseFeeChargingType

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	-------------------------------------------------------------------
	set @ModuleName = 'administration.dbo.nio_SpCustomAddSystemUserForTenant'
	select @serializedParameters = (select @NewTenantID as NewTenantID
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

		PRINT 'Step 17: Insert A System User for this tenant'
		exec administration.dbo.nio_SpCustomAddSystemUserForTenant @NewTenantID

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	set @ModuleName = 'insert into policymanagement.dbo.TTenantRuleConfiguration'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

	-- INSERT - data for system defined rules into TTenantRuleConfiguration
		insert into policymanagement.dbo.TTenantRuleConfiguration(RefRuleConfigurationId,IsConfigured,TenantId,ConcurrencyId)
		output
			inserted.TenantRuleConfigurationId, inserted.RefRuleConfigurationId, inserted.IsConfigured, inserted.TenantId, inserted.ConcurrencyId
			, 'C', getdate(), @StampUser
		into policymanagement.dbo.TTenantRuleConfigurationAudit(
			TenantRuleConfigurationId, RefRuleConfigurationId, IsConfigured, TenantId, ConcurrencyId
			, StampAction, StampDateTime, StampUser)
		select TRefRuleConfiguration.RefRuleConfigurationId, DefaultConfiguration, @NewTenantID, 1
		FROM policymanagement.dbo.TRefRuleConfiguration

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	-------------------------------------------------------------------
	set @ModuleName = 'PolicyManagement.dbo.SpCustomSetupThirdPartyIntegrationConfigurationData'
		select @serializedParameters = (select @NewTenantID as NewTenantID,
		@SourceIndigoClientId as SourceIndigoClientId
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

		PRINT 'Step 17: Safely insert any missing Third Party Integration Configuration data'
		exec PolicyManagement.dbo.SpCustomSetupThirdPartyIntegrationConfigurationData @SourceIndigoClientId, @NewTenantID

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	set @ModuleName = 'insert into crm.dbo.TIntegrationType'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

	-- TIntegrationType table is populated which is required for the OBP export functionality to work
		insert into crm.dbo.TIntegrationType(ConcurrencyId,TenantId,IntegrationTypeName,IsEnabled)
		select 1,@NewTenantID,'OBPExport',1

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end


	-------------------------------------------------------------------
	set @ModuleName = 'Administration.dbo.SpNCreateUpdateUIDomainFieldAttribute'
	declare @DomainName as varchar(100) = 'Opportunity'
	declare @FieldName as varchar(100) = 'PropositionType'
	declare @AttributeName as varchar(100) = 'IsRequired'
	declare @AttributeValue as varchar(100) = 'false'
		select @serializedParameters = (select @NewTenantID as NewTenantID,
		@DomainName as DomainName,
		@FieldName as FieldName,
		@AttributeName as AttributeName,
		@AttributeValue as AttributeValue,
		@StampUser as StampUser
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

	-- Inserting UIDomainFieldAttribute config defaults values
		exec Administration.dbo.SpNCreateUpdateUIDomainFieldAttribute @NewTenantID, @DomainName, @FieldName, @AttributeName, @AttributeValue, @StampUser

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	set @ModuleName = 'administration.dbo.spCustomResetDefaultDashboards'
		select @serializedParameters = (select @NewTenantID as NewTenantID,
		@SourceIndigoClientId as SourceIndigoClientId
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

		exec administration.dbo.spCustomResetDefaultDashboards @NewTenantID, @SourceIndigoClientId
		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	set @ModuleName = 'Administration.dbo.SpNCreateOpportunityToPlanTypeMapping'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin

	--Add mapping for Sub PlanTypes to Opportunity type entries in the mapping table for the new tenant
		exec Administration.dbo.SpNCreateOpportunityToPlanTypeMapping @NewTenantID

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	set @ModuleName = 'administration.dbo.spCustomDefaultAdviseFeeType'
		select @serializedParameters = (select @NewTenantID as NewTenantID,
		@SourceIndigoClientId as SourceIndigoClientId
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin

	-- Inserting default data into TAdviseFeeType for new tenant from base account (SourceIndigoClientId)
		exec administration.dbo.spCustomDefaultAdviseFeeType @NewTenantID, @SourceIndigoClientId

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	-- DM-2192
	set @ModuleName = 'administration.dbo.SpAdminCreateTenantPreference'
	declare @TenantPreferenceName as varchar(255) = 'SubscribedToPriceFeed'
	declare @TenantPreferenceValue as varchar(255) = '1'
		select @serializedParameters = (select @NewTenantID as NewTenantID,
		@SourceIndigoClientId as SourceIndigoClientId,
		@TenantPreferenceName as PreferenceName,
		@TenantPreferenceValue as PreferenceValue
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin
	-- DM-2192: Creation of new tenants - price feed option
		exec Administration.dbo.SpAdminCreateTenantPreference @NewTenantID, @TenantPreferenceName, @TenantPreferenceValue
		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	-- DM-2191
	set @ModuleName = 'dbo.spSetAdditionalRiskQuestions'
	select @serializedParameters = (select @NewTenantID as NewTenantID,
		@StampUser as StampUser
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	if @procResult = 0 begin
	-- DM-2191: Add Risk Profile Questions to all New Implementations
		exec dbo.spSetAdditionalRiskQuestions @NewTenantID, @StampUser
		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-- 05/09/2019
	set @ModuleName = 'dbo.spCloneConfigPCRItems'
	if @SourceIndigoClientId is not null
			exec dbo.spCloneConfigPCRItems @NewTenantID, @SourceIndigoClientId, @RegionCode, @StampUser
	declare
		@PreferenceName varchar(255),
		@Value varchar(255)

	-------------------------------------------------------------------
	-- DM-2911: Enable InAppSupport
	set @ModuleName = 'EnableInAppSupport'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin
		set @NewGUID = NEWID()
		set @PreferenceName = 'EnableInAppSupport'
		set @Value = 'True'

		/*
		-- Reset existing value (if cloned)
		update Administration.dbo.TIndigoClientPreference
		set [Value]=@Value,
			[Disabled]=0
		where IndigoClientId = @NewTenantID
			and PreferenceName = @PreferenceName

		if @@rowcount=0
		*/
		if not exists(select top 1 1 from administration..TIndigoClientPreference where PreferenceName=@PreferenceName
			and IndigoClientId = @NewTenantID)

			insert into Administration.dbo.TIndigoClientPreference(IndigoClientId, IndigoClientGuid, PreferenceName, [Value], [Disabled], [Guid], ConcurrencyId)
			values (@NewTenantID, @NewTenantGUID, @PreferenceName, @Value, 0, @NewGUID, 1)

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	-- DM-2915 - IODESIGN-1515: Disable feature_ioreskin
	-- DM-3010 - Post Live Release 17th March: Enable feature_ioreskin
	set @ModuleName = 'feature_ioreskin'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin
	-- DM-2915 - IODESIGN-1515: Disable feature_ioreskin
		set @NewGUID = NEWID()
		set @PreferenceName = 'feature_ioreskin'
		set @Value = 'Yes'

		/*
		-- Reset existing value (if cloned)
		update Administration.dbo.TIndigoClientPreference
		set [Value]=@Value,
			[Disabled]=0
		where IndigoClientId = @NewTenantID
			and PreferenceName = @PreferenceName

		if @@rowcount=0
		*/
		if not exists(select top 1 1 from administration..TIndigoClientPreference where PreferenceName=@PreferenceName
			and IndigoClientId = @NewTenantID)
		BEGIN
			IF @RegionCode != 'AU'
			insert into Administration.dbo.TIndigoClientPreference(IndigoClientId, IndigoClientGuid, PreferenceName, [Value], [Disabled], [Guid], ConcurrencyId)
			values (@NewTenantID, @NewTenantGUID, @PreferenceName, @Value, 0, @NewGUID, 1)

			IF @RegionCode = 'AU'
			insert into Administration.dbo.TIndigoClientPreference(IndigoClientId, IndigoClientGuid, PreferenceName, [Disabled], [Guid], ConcurrencyId)
			values (@NewTenantID, @NewTenantGUID, @PreferenceName, 0, @NewGUID, 1)
		END
		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	-- DM-3010: UserTheme
	set @ModuleName = 'UserTheme'
	select @serializedParameters = (select @NewTenantID as NewTenantID
	FOR JSON PATH)
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName, @serializedParameters
	
	if @procResult = 0 begin
			exec dbo.spSetUserTheme @NewTenantID
		
	exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end

	-------------------------------------------------------------------
	--DM-3020: Aus Updates
	IF @RegionCode = 'AU' 
	BEGIN

		--ACCRUALS
		set @ModuleName = 'EnableExpectation'
		exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
		if @procResult = 0 begin
		
			set @NewGUID = NEWID()
			set @PreferenceName = @ModuleName
			/*
			-- Reset existing value (if cloned)
				update Administration.dbo.TIndigoClientPreference
				set [Value]=GETDATE(),
					[Disabled]=0
				where IndigoClientId = @NewTenantID
					and PreferenceName = @PreferenceName

				if @@rowcount=0
			*/
			if not exists(select top 1 1 from administration..TIndigoClientPreference where PreferenceName=@PreferenceName
				and IndigoClientId = @NewTenantID)

				insert into Administration.dbo.TIndigoClientPreference(IndigoClientId, IndigoClientGuid, PreferenceName, [Value], [Disabled], [Guid], ConcurrencyId)
				values (@NewTenantID, @NewTenantGUID, @PreferenceName, GETDATE(), 0, @NewGUID, 1)

			exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName

		end
	END --END AUS UPDATES (DM-3020)




	-------------------------------------------------------------------
	-- DM-3190 - New Advice Process
	set @ModuleName = 'Feature_HasOldAdviceProcess'
	exec @procResult = dbo.spStartCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	if @procResult = 0 begin
		set @NewGUID = NEWID()
		set @PreferenceName = @ModuleName
		set @Value = 'Yes'

		/*
		-- Reset existing value (if cloned)
		update Administration.dbo.TIndigoClientPreference
		set [Value]=@Value,
			[Disabled]=0
		where IndigoClientId = @NewTenantID
			and PreferenceName = @PreferenceName

		if @@rowcount=0
		*/		
		if not exists(select top 1 1 from administration..TIndigoClientPreference where PreferenceName=@PreferenceName
			and IndigoClientId = @NewTenantID)
				
			insert into Administration.dbo.TIndigoClientPreference(IndigoClientId, IndigoClientGuid, PreferenceName, [Value], [Disabled], [Guid], ConcurrencyId)
			values (@NewTenantID, @NewTenantGUID, @PreferenceName, @Value, 0, @NewGUID, 1)

		exec dbo.spStopCreateTenantModule @NewTenantID, @SourceIndigoClientId, @ModuleName
	end
	set @Msg = 'Tenant created successfully: '+convert(varchar(10), @NewTenantID)
	raiserror(@Msg,0,1) with nowait
END TRY
BEGIN CATCH
	declare @ErrorState INT;
	declare @ErrorLine INT;
 
	SELECT @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(); 

	declare @tenantIdString varchar(max) = 'NewTenantId='+ CAST(COALESCE(@NewTenantId, 0) as varchar(255))+', SourceTenantId='+CAST(COALESCE(@SourceIndigoClientId, 0) as varchar(255)) + ', IsCloneOf='+CAST(COALESCE(@IsCloneOf, 0) as varchar(255)) +' - ['+ @TenantName +']'

	set @Msg = @ProcName + ': ' + @tenantIdString +'. ' + error_message()+'
	Create tenant has failed on module: '+@ModuleName
	+', ErrorState = %d, ErrorLine = %d'

	if @Msg not like '%ErrorState%'
		set @Msg += ', ErrorState = %d, ErrorLine = %d'

	raiserror(@Msg,16,1,@ErrorState, @ErrorLine)
END CATCH

END

GO
