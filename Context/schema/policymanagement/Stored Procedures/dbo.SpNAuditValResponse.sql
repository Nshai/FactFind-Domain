SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValResponse]
	@StampUser varchar (255),
	@ValResponseId bigint,
	@StampAction char(1)
AS

INSERT INTO TValResponseAudit 
( ValRequestId, ResponseXML, ResponseDate, ResponseStatus, 
		ErrorDescription, IsAnalysed, ConcurrencyId, ImplementationCode, ProviderErrorCode, ProviderErrorDescription,
	ValResponseId, StampAction, StampDateTime, StampUser) 
Select ValRequestId, ResponseXML, ResponseDate, ResponseStatus, 
		ErrorDescription, IsAnalysed, ConcurrencyId, ImplementationCode, ProviderErrorCode, ProviderErrorDescription,
	ValResponseId, @StampAction, GetDate(), @StampUser
FROM TValResponse
WHERE ValResponseId = @ValResponseId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
