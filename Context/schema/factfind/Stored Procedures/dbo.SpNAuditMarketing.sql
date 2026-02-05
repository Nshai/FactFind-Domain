SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditMarketing]
	@StampUser varchar (255),
	@MarketingId bigint,
	@StampAction char(1)
AS

INSERT INTO TMarketingAudit (
	ConcurrencyId, CRMContactId, Phone, Letter, Email, Sms, PictureMessage, 
	PhoneAnniverary, LetterAnniverary, EmailAnniverary, SmsAnniverary, PictureMessageAnniverary,
	MarketingId, StampAction, StampDateTime, StampUser)
SELECT  
	ConcurrencyId, CRMContactId, Phone, Letter, Email, Sms, PictureMessage, 
	PhoneAnniverary, LetterAnniverary, EmailAnniverary, SmsAnniverary, PictureMessageAnniverary,
	MarketingId, @StampAction, GetDate(), @StampUser
FROM TMarketing
WHERE MarketingId = @MarketingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
