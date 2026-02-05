SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIncomeProtection]
	@StampUser varchar (255),
	@IncomeProtectionId bigint,
	@StampAction char(1)
AS

INSERT INTO TIncomeProtectionAudit 
(ConcurrencyId, CRMContactId, IsDebtMaintainable, IsLifestyleMaintainable, ImpactOnYou, ImpactOnDependants, 
	HowToAddress, NotReviewingReason,
	IncomeProtectionId, StampAction, StampDateTime, StampUser)
SELECT  ConcurrencyId, CRMContactId, IsDebtMaintainable, IsLifestyleMaintainable, ImpactOnYou, ImpactOnDependants, 
	HowToAddress, NotReviewingReason,
	IncomeProtectionId, @StampAction, GetDate(), @StampUser
FROM TIncomeProtection
WHERE IncomeProtectionId = @IncomeProtectionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
