SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpUpdatePortalUserSettingsByUserId]
@KeyUserId bigint,
@StampUser varchar (255),
@IndigoClientId bigint,
@CRMContactId bigint,
@UserId bigint = NULL,
@EnablePortalFg bit = 0,
@SendEmailNotificationFg bit = 0,
@AccountLockedFg bit = 0,
@AllowFactFindFg bit = 1,
@AllowValuationsFg bit = 1,
@AllowPortfolioReportFg bit = 1
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TPortalUserSettingsAudit (
    IndigoClientId, 
    CRMContactId, 
    UserId, 
    EnablePortalFg, 
    SendEmailNotificationFg, 
    AccountLockedFg, 
    AllowFactFindFg, 
    AllowValuationsFg, 
    AllowPortfolioReportFg, 
    ConcurrencyId,
    PortalUserSettingsId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.IndigoClientId, 
    T1.CRMContactId, 
    T1.UserId, 
    T1.EnablePortalFg, 
    T1.SendEmailNotificationFg, 
    T1.AccountLockedFg, 
    T1.AllowFactFindFg, 
    T1.AllowValuationsFg, 
    T1.AllowPortfolioReportFg, 
    T1.ConcurrencyId,
    T1.PortalUserSettingsId,
    'U',
    GetDate(),
    @StampUser

  FROM TPortalUserSettings T1

  WHERE (T1.UserId = @KeyUserId)
  UPDATE T1
  SET 
    T1.IndigoClientId = @IndigoClientId,
    T1.CRMContactId = @CRMContactId,
    T1.UserId = @UserId,
    T1.EnablePortalFg = @EnablePortalFg,
    T1.SendEmailNotificationFg = @SendEmailNotificationFg,
    T1.AccountLockedFg = @AccountLockedFg,
    T1.AllowFactFindFg = @AllowFactFindFg,
    T1.AllowValuationsFg = @AllowValuationsFg,
    T1.AllowPortfolioReportFg = @AllowPortfolioReportFg,
    T1.ConcurrencyId = T1.ConcurrencyId + 1
  FROM TPortalUserSettings T1

  WHERE (T1.UserId = @KeyUserId)

SELECT * FROM TPortalUserSettings [PortalUserSettings]
  WHERE ([PortalUserSettings].UserId = @KeyUserId)
 FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
