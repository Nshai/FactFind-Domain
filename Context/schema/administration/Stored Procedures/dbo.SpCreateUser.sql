SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateUser]  
 @StampUser varchar (255),  
 @Identifier varchar(64) ,   
 @Password varchar(24) ,   
 @PasswordHistory varchar(512)  = NULL,   
 @Email varchar(128) ,   
 @Telephone varchar(16)  = NULL,   
 @Status varchar(50) ,   
 @GroupId bigint,   
 @SyncPassword bit = 0,   
 @ExpirePasswordOn datetime = NULL,   
 @SuperUser bit = 0,   
 @SuperViewer bit = 0,   
 @FinancialPlanningAccess bit = 0,   
 @FailedAccessAttempts tinyint = 0,   
 @WelcomePage varchar(64)  = 'goto,news,links',   
 @Reference varchar(64)  = NULL,   
 @CRMContactId bigint = NULL,   
 @SearchData text = NULL,   
 @RecentData text = NULL,   
 @RecentWork text = NULL,   
 @IndigoClientId bigint = NULL,   
 @SupportUserFg bit = 0,   
 @ActiveRole bigint = NULL,   
 @CanLogCases bit = 0,   
 @RefUserTypeId bigint = 1,   
 @Guid uniqueidentifier = NULL,   
 @IsMortgageBenchEnabled bit = 0,
 @Timezone varchar(32) = 'Europe/London' 
AS  
  
SET NOCOUNT ON  
  
DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX  
  
BEGIN  
 IF @Guid IS NULL SET @Guid =[dbo].[NewCombGuid]()
   
 DECLARE @UserId bigint  
     
   
 INSERT INTO TUser (  
  Identifier,   
  Password,   
  PasswordHistory,   
  Email,   
  Telephone,   
  Status,   
  GroupId,   
  SyncPassword,   
  ExpirePasswordOn,   
  SuperUser,   
  SuperViewer,   
  FinancialPlanningAccess,   
  FailedAccessAttempts,   
  WelcomePage,   
  Reference,   
  CRMContactId,   
  SearchData,   
  RecentData,   
  RecentWork,   
  IndigoClientId,   
  SupportUserFg,   
  ActiveRole,   
  CanLogCases,   
  RefUserTypeId,   
  Guid,   
  IsMortgageBenchEnabled,   
  ConcurrencyId,
  Timezone)  
    
 VALUES(  
  @Identifier,   
  Null, --@Password,   
  Null, --@PasswordHistory,   
  @Email,   
  @Telephone,   
  @Status,   
  @GroupId,   
  @SyncPassword,   
  @ExpirePasswordOn,   
  @SuperUser,   
  @SuperViewer,   
  @FinancialPlanningAccess,   
  @FailedAccessAttempts,   
  @WelcomePage,   
  @Reference,   
  @CRMContactId,   
  @SearchData,   
  @RecentData,   
  @RecentWork,   
  @IndigoClientId,   
  @SupportUserFg,   
  @ActiveRole,   
  @CanLogCases,   
  @RefUserTypeId,   
  @Guid,   
  @IsMortgageBenchEnabled,  
  1,
  @Timezone)  
  
 SELECT @UserId = SCOPE_IDENTITY()  
   
 INSERT INTO TUserAudit (  
  Identifier,   
  Password,   
  PasswordHistory,   
  Email,   
  Telephone,   
  Status,   
  GroupId,   
  SyncPassword,   
  ExpirePasswordOn,   
  SuperUser,   
  SuperViewer,   
  FinancialPlanningAccess,   
  FailedAccessAttempts,   
  WelcomePage,   
  Reference,   
  CRMContactId,   
  SearchData,   
  RecentData,   
  RecentWork,   
  IndigoClientId,   
  SupportUserFg,   
  ActiveRole,   
  CanLogCases,   
  RefUserTypeId,   
  Guid,   
  IsMortgageBenchEnabled,   
  ConcurrencyId,  
  UserId,  
  StampAction,  
  StampDateTime,  
  StampUser,
  Timezone)  
 SELECT    
  Identifier,   
  Password,   
  PasswordHistory,   
  Email,   
  Telephone,   
  Status,   
  GroupId,   
  SyncPassword,   
  ExpirePasswordOn,   
  SuperUser,   
  SuperViewer,   
  FinancialPlanningAccess,   
  FailedAccessAttempts,   
  WelcomePage,   
  Reference,   
  CRMContactId,   
  SearchData,   
  RecentData,   
  RecentWork,   
  IndigoClientId,   
  SupportUserFg,   
  ActiveRole,   
  CanLogCases,   
  RefUserTypeId,   
  Guid,   
  IsMortgageBenchEnabled,   
  ConcurrencyId,  
  UserId,  
  'C',  
  GetDate(),  
  @StampUser,
  Timezone	 
 FROM TUser  
 WHERE UserId = @UserId  
 EXEC SpRetrieveUserById @UserId  
  
IF @@ERROR != 0 GOTO errh  
IF @tx = 0 COMMIT TRANSACTION TX  
  
END  
RETURN (0)  
  
errh:  
  IF @tx = 0 ROLLBACK TRANSACTION TX  
  RETURN (100)  
GO
