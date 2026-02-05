SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditMortgageMiscellaneous]
	@StampUser varchar (255),
	@MortgageMiscellaneousId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageMiscellaneousAudit (
	ConcurrencyId, CRMContactId, [HasExistingProvision], HasAdverseCreditHistory, [NumberOfExistingMortgages], Notes,
	MortgageMiscellaneousId, StampAction, StampDateTime, StampUser, HasRefusedCredit, RefusedCredit, HasEquityRelease)
SELECT  ConcurrencyId, CRMContactId, [HasExistingProvision], HasAdverseCreditHistory, [NumberOfExistingMortgages], Notes,
	MortgageMiscellaneousId, @StampAction, GetDate(), @StampUser, HasRefusedCredit, RefusedCredit, HasEquityRelease
FROM TMortgageMiscellaneous
WHERE MortgageMiscellaneousId = @MortgageMiscellaneousId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
