SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditMarketing]
	@StampUser varchar (255),
	@MarketingId bigint,
	@StampAction char(1)
AS

INSERT INTO TMarketingAudit(
		ConcurrencyId, CRMContactId, Telephone, Mail, Email, Sms, 
		OtherTelephone, OtherMail, OtherEmail, OtherSms,
		SocialMedia, OtherSocialMedia, CanContactForMarketing,
		MarketingId, StampAction, StampDateTime, StampUser,AccessibleFormat, DeliveryMethod,MigrationRef,ConsentDate,AutomatedCalls,OtherAutomatedCalls,PFP,OtherPFP)
SELECT  ConcurrencyId, CRMContactId, Telephone, Mail, Email, Sms, 
		OtherTelephone, OtherMail, OtherEmail, OtherSms,
		SocialMedia, OtherSocialMedia, CanContactForMarketing,
		MarketingId, @StampAction, GetDate(), @StampUser,AccessibleFormat,DeliveryMethod,MigrationRef,ConsentDate,AutomatedCalls,OtherAutomatedCalls,PFP,OtherPFP
FROM TMarketing
WHERE MarketingId = @MarketingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
