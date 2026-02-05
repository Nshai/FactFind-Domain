SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditOnlineSourceData]
	@StampUser varchar (255),
	@OnlineSourceDataId bigint,
	@StampAction char(1)
	

AS

INSERT INTO TOnlineSourceDataAudit 
(OnlineSourceDataId, OpportunityId,IndigoClientId,SubmittedDate,
SubmittedTime,CallbackPreference,[Source],Keywords,RefferedURL,
LandingPageURL,SubmittedFromURL,SubmittedFromIP,ConcurrencyId,
 StampAction, StampDateTime, StampUser) 

Select OnlineSourceDataId, OpportunityId,IndigoClientId,SubmittedDate,
SubmittedTime,CallbackPreference, [Source],Keywords,RefferedURL,
LandingPageURL,SubmittedFromURL,SubmittedFromIP,ConcurrencyId,
 @StampAction, GetDate(), @StampUser
FROM TOnlineSourceData
WHERE OnlineSourceDataId = @OnlineSourceDataId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO


