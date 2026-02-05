SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditSupportWhiteIPAddress]
	@StampUser VARCHAR (255),
	@SupportWhiteIPAddressId BIGINT,
	@StampAction CHAR(1)
AS

INSERT INTO TSupportWhiteIPAddressAudit 
(SupportWhiteIPAddressId, IPAddressRangeStart, IPAddressRangeEnd, ConcurrencyId, StampAction, StampDateTime, StampUser) 

SELECT SupportWhiteIPAddressId, IPAddressRangeStart, IPAddressRangeEnd, ConcurrencyId,
 @StampAction, GETDATE(), @StampUser
 
FROM TSupportWhiteIPAddress
WHERE SupportWhiteIPAddressId = @SupportWhiteIPAddressId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
