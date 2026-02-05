SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditRefPCLSPaidBy]
	@StampUser varchar (255),
	@RefPCLSPaidById bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPCLSPaidByAudit 
(RefPCLSPaidById, RefPCLSPaidByName, ConcurrencyId, StampAction, StampDateTime, StampUser) 
Select RefPCLSPaidById, RefPCLSPaidByName, ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM TRefPCLSPaidBy
WHERE RefPCLSPaidById = @RefPCLSPaidById

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
