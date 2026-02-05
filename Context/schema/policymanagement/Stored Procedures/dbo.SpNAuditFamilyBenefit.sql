SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFamilyBenefit]
	@StampUser varchar (255),
	@FamilyBenefitId bigint,
	@StampAction char(1)
AS

INSERT INTO TFamilyBenefitAudit 
( IncomeBenefitFG, Amount, RefFrequencyId, UntilDate, 
		ConcurrencyId, 
	FamilyBenefitId, StampAction, StampDateTime, StampUser) 
Select IncomeBenefitFG, Amount, RefFrequencyId, UntilDate, 
		ConcurrencyId, 
	FamilyBenefitId, @StampAction, GetDate(), @StampUser
FROM TFamilyBenefit
WHERE FamilyBenefitId = @FamilyBenefitId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
