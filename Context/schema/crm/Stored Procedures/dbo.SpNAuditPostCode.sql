SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPostCode]
	@StampUser varchar (255),
	@PostCodeId bigint,
	@StampAction char(1)
AS

INSERT INTO TPostCodeAudit 
(IndigoClientId, PostCodeShortName, LatitudeX, 
		LongitudeY,IsSystemAdded, ConcurrencyId, 
	PostCodeId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, PostCodeShortName, LatitudeX, 
		LongitudeY,IsSystemAdded, ConcurrencyId, 
	PostCodeId, @StampAction, GetDate(), @StampUser
FROM TPostCode
WHERE PostCodeId = @PostCodeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
