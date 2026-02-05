SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefTotalPermanentDisabilityType]
	@StampUser varchar (255),
	@RefTotalPermanentDisabilityTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefTotalPermanentDisabilityTypeAudit
( TypeName,  ConcurrencyId, RefTotalPermanentDisabilityTypeId, StampAction, StampDateTime, StampUser) 
SELECT TypeName, ConcurrencyId, RefTotalPermanentDisabilityTypeId, @StampAction, GetDate(), @StampUser
FROM TRefTotalPermanentDisabilityType
WHERE RefTotalPermanentDisabilityTypeId = @RefTotalPermanentDisabilityTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
