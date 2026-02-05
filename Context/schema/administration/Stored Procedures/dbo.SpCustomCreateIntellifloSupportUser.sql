SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure SpCustomCreateIntellifloSupportUser
@TenantId int

as

/*
SpCustomCreateIntellifloSupportUser
USAGE: exec administration..SpCustomCreateIntellifloSupportUser 99
Creates a RefUserType=6 user. User name is of the pattern "intelliflo {tenantId} support user {number}"
Where {number} is based on the number of existing support users. So if there is already 1, the new one will be 2.

*/


-- Fill up some role and group related variables to make the following script work
DECLARE @GroupId BIGINT, @RoleId BIGINT
DECLARE @SupportUserNumber tinyint, @SupportUserFirstName varchar(255), @SupportUserLastName varchar(255)
DECLARE @SupportUserEmail varchar(255)


SET @SupportUserNumber = (SELECT COUNT(1) FROM TUser WHERE IndigoClientId = @TenantId AND RefUserTypeId = 6) + 1

SET @SupportUserFirstName = 'Intelliflo ' + CAST(@TenantId as varchar(10))
SET @SupportUserLastName = 'Support User ' + CAST(@SupportUserNumber as varchar(10))
SET @SupportUserEmail = @SupportUserFirstName + '.' + @SupportUserLastName

SELECT @GroupId=MIN(GroupId) FROM Administration..TGroup WHERE IndigoClientid=@TenantId AND ParentId IS NULL -- assume the first one if there are more than one
SELECT @RoleId = RoleId FROM Administration..TRole WHERE IndigoClientid=@TenantId AND Identifier = 'System Administrator'
IF @RoleId IS NULL
BEGIN
	SELECT @RoleId = Min(RoleId) FROM Administration..TRole WHERE IndigoClientid=@TenantId	  
END

--PERSON      
    
exec crm..spCreatePerson @StampUser='0',@Title=NULL,@FirstName=@SupportUserFirstName, @MiddleName=NULL,@LastName=@SupportUserLastName,      
   @MaidenName=NULL,@DOB=NULL,@GenderType=NULL,@NINumber=NULL,@IsSmoker=NULL,@UKResident=NULL,@ResidentIn=NULL,@Salutation=NULL,      
   @RefSourceTypeId=NULL,@IntroducerSource=NULL,@MaritalStatus=NULL,@MarriedOn=NULL,@Residency=NULL,@UKDomicile=NULL,@Domicile=NULL,      
   @TaxCode=NULL,@Nationality=NULL,@ArchiveFG=default,@IndClientId=@TenantId      
      
Declare @AdministratorUserPersonId  bigint      
      
Select @AdministratorUserPersonId=PersonId from CRm..TPerson where IndClientId=@TenantId AND FirstName = @SupportUserFirstName AND LastName = @SupportUserLastName
      
DECLARE @AdministratorUserCRMcontactId bigint, @UserGUID varchar(255), @AdminstratorUserId bigint      
      
Select @UserGUID=[dbo].[NewCombGuid]()      
      
exec CRM..spCreateCRMContact @StampUser='0',@RefCRMContactStatusId=NULL,@PersonId=@AdministratorUserPersonId,@CorporateId=NULL,@TrustId=NULL,@AdvisorRef=NULL,      
@Notes='internal',@ArchiveFg=0,@LastName=@SupportUserLastName, @FirstName=@SupportUserFirstName, @CorporateName=NULL,@DOB=NULL,@Postcode=NULL,@OriginalAdviserCRMId=default,      
@CurrentAdviserCRMId=0,@CurrentAdviserName=NULL,@CRMContactType=1,@IndClientId=@TenantId,@FactFindId=NULL,@InternalContactFG=1,@RefServiceStatusId=NULL,      
@MigrationRef=NULL,@CreatedDate=NULL,@ExternalReference=NULL,@CampaignDataId=NULL,@AdditionalRef=NULL      
      
Select @AdministratorUserCRMContactId=CRMContactId from CRM..TCRMContact where PersonId=@AdministratorUserPersonId AND FirstName = @SupportUserFirstName and LastName = @SupportUserLastName
     
      
Declare @Identifier varchar(255)      
      
Set @Identifier=@SupportUserFirstName + ' ' + @SupportUserLastName   
      
exec administration..spCreateUser @StampUser='0',@Identifier = @Identifier,@Password = Null, @PasswordHistory = Null,@Email=@SupportUserEmail,@Telephone=NULL,@Status='Access Granted - Not Logged In',      
@GroupId=@GroupId,@SyncPassword=0,@ExpirePasswordOn='15 Dec 1976',@SuperUser=1,@SuperViewer=1,@FinancialPlanningAccess=default,@FailedAccessAttempts=0,      
@WelcomePage=default,@Reference=default,@CRMContactId=@AdministratorUserCRMContactId,@SearchData=default,@RecentData=default,@RecentWork=default,@IndigoClientId=@TenantId,      
@SupportUserFg=0,@ActiveRole=@RoleId,@CanLogCases=1,@RefUserTypeId=6,@Guid=@UserGUID,@IsMortgageBenchEnabled=0      
      
Select @AdminstratorUserId=UserId from Administration..Tuser where IndigoClientID=@TenantId AND Identifier = @Identifier  
      
-- membership and usercombined and session      
exec administration..spCreateMembership @StampUser='0',@UserId=@AdminstratorUserId,@RoleId=@RoleId      
      
-- lets deal with TUser Combined      
insert into TUserCombined ( Guid, UserId, Identifier, IndigoclientId, IndigoClientGuid,ConcurrencyId)     
SELECT u.Guid, u.UserId, u.Identifier, i.IndigoClientId, i.Guid, 1
FROM TUser u
JOIN TIndigoClient i on i.IndigoClientId = u.IndigoClientId
WHERE u.UserId = @AdminstratorUserId

-- lets deal with the session record      
insert into administration..tusersession (userid, sequence)      
values (@AdminstratorUserId,0)      
      
SELECT * FROM TUser WHERE UserId = @AdminstratorUserId

