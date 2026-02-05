SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefAddressStatus]
	@StampUser varchar (255),
	@RefAddressStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefAddressStatusAudit 
(AddressStatus,
	RefAddressStatusId, StampAction, StampDateTime, StampUser)
SELECT  AddressStatus,
	RefAddressStatusId, @StampAction, GetDate(), @StampUser
FROM TRefAddressStatus
WHERE RefAddressStatusId = @RefAddressStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
