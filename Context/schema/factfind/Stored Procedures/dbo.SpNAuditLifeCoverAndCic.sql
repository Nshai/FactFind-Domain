SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditLifeCoverAndCic]
	@StampUser varchar (255),
	@LifeCoverAndCicId bigint,
	@StampAction char(1)
AS

INSERT INTO TLifeCoverAndCicAudit 
(ConcurrencyId, CRMContactId, IsDebtCleared, IsCicMaintainable, IsLifeMaintainable, ImpactOnYou, 
	ImpactOnDependants, HowToAddress, NotReviewingReason,
	LifeCoverAndCicId, StampAction, StampDateTime, StampUser, IsFixedProtectionPremium)
SELECT  ConcurrencyId, CRMContactId, IsDebtCleared, IsCicMaintainable, IsLifeMaintainable, ImpactOnYou, 
	ImpactOnDependants, HowToAddress, NotReviewingReason,
	LifeCoverAndCicId, @StampAction, GetDate(), @StampUser, IsFixedProtectionPremium
FROM TLifeCoverAndCic
WHERE LifeCoverAndCicId = @LifeCoverAndCicId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
