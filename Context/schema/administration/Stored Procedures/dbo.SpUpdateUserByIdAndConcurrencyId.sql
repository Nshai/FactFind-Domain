SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* 
sp_helptext SpUpdateUserByIdAndConcurrencyId

[dbo].[NewCombGuid]()
*/

CREATE PROCEDURE [dbo].[SpUpdateUserByIdAndConcurrencyId]  
@KeyUserId bigint,  
@KeyConcurrencyId int,  
@StampUser varchar (255),  
@Identifier varchar (64),  
@Password varchar (max),  
@PasswordHistory varchar (512) = NULL,  
@Email varchar (128),  
@Telephone varchar (16) = NULL,  
@Status varchar (50),  
@GroupId bigint,  
@SyncPassword bit = 0,  
@ExpirePasswordOn datetime = NULL,  
@SuperUser bit = 0,  
@SuperViewer bit = 0,  
@FinancialPlanningAccess bit = 0,  
@FailedAccessAttempts tinyint = 0,  
@WelcomePage varchar (64) = 'goto,news,links',  
@Reference varchar (64) = NULL,  
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
@IsMortgageBenchEnabled bit = 0  
AS  
  
SET NOCOUNT ON  
  
DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX  
  
BEGIN  
  IF @Guid IS NULL SET @Guid = [dbo].[NewCombGuid]()
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
    Timezone,  
    StampAction,  
    StampDateTime,  
    StampUser)  
  SELECT  
    T1.Identifier,   
    T1.Password,   
    T1.PasswordHistory,   
    T1.Email,   
    T1.Telephone,   
    T1.Status,   
    T1.GroupId,   
    T1.SyncPassword,   
    T1.ExpirePasswordOn,   
    T1.SuperUser,   
    T1.SuperViewer,   
    T1.FinancialPlanningAccess,   
    T1.FailedAccessAttempts,   
    T1.WelcomePage,   
    T1.Reference,   
    T1.CRMContactId,   
    T1.SearchData,   
    T1.RecentData,   
    T1.RecentWork,   
    T1.IndigoClientId,   
    T1.SupportUserFg,   
    T1.ActiveRole,   
    T1.CanLogCases,   
    T1.RefUserTypeId,   
    T1.Guid,   
    T1.IsMortgageBenchEnabled,   
    T1.ConcurrencyId,  
    T1.UserId,  
    T1.Timezone,  
    'U',  
    GetDate(),  
    @StampUser  
  
  FROM TUser T1  
  
  WHERE (T1.UserId = @KeyUserId) AND   
        (T1.ConcurrencyId = @KeyConcurrencyId)  
  UPDATE T1  
  SET   
    T1.Identifier = @Identifier,  
    T1.Password = @Password,  
    T1.PasswordHistory = @PasswordHistory,  
    T1.Email = @Email,  
    T1.Telephone = @Telephone,  
    T1.Status = @Status,  
    T1.GroupId = @GroupId,  
    T1.SyncPassword = @SyncPassword,  
    T1.ExpirePasswordOn = @ExpirePasswordOn,  
    T1.SuperUser = @SuperUser,  
    T1.SuperViewer = @SuperViewer,  
    T1.FinancialPlanningAccess = @FinancialPlanningAccess,  
    T1.FailedAccessAttempts = @FailedAccessAttempts,  
    T1.WelcomePage = @WelcomePage,  
    T1.Reference = @Reference,  
    T1.CRMContactId = @CRMContactId,  
    T1.SearchData = @SearchData,  
    T1.RecentData = @RecentData,  
    T1.RecentWork = @RecentWork,  
    T1.IndigoClientId = @IndigoClientId,  
    T1.SupportUserFg = @SupportUserFg,  
    T1.ActiveRole = @ActiveRole,  
    T1.CanLogCases = @CanLogCases,  
    T1.RefUserTypeId = @RefUserTypeId,  
    T1.Guid = @Guid,  
    T1.IsMortgageBenchEnabled = @IsMortgageBenchEnabled,  
    T1.ConcurrencyId = T1.ConcurrencyId + 1  
  FROM TUser T1  
  
  WHERE (T1.UserId = @KeyUserId) AND   
        (T1.ConcurrencyId = @KeyConcurrencyId)  
  
SELECT * FROM TUser [User]  
  WHERE ([User].UserId = @KeyUserId) AND   
        ([User].ConcurrencyId = @KeyConcurrencyId + 1)  
 FOR XML AUTO  
  
IF @@ERROR != 0 GOTO errh  
IF @tx = 0 COMMIT TRANSACTION TX  
  
END  
RETURN (0)  
  
errh:  
  IF @tx = 0 ROLLBACK TRANSACTION TX  
  RETURN (100)  
GO
