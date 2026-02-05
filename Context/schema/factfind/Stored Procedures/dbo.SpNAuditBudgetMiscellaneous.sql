SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditBudgetMiscellaneous]
	@StampUser varchar (255),
	@BudgetMiscellaneousId bigint,
	@StampAction char(1)
AS

INSERT INTO TBudgetMiscellaneousAudit 
( CRMContactId, TotalEarnings, Tax, AnyAssets, 
		AssetsNonDisclosure, AnyLiabilities, LiabilitiesRepayment, LiabilitiesWhyNot, 
		RepaymentDetails, LiabilitiesNonDisclosure, BudgetNotes, AssetLiabilityNotes, ConcurrencyId, 		
	BudgetMiscellaneousId, StampAction, StampDateTime, StampUser, [LiabilityNotes]) 
SELECT CRMContactId, TotalEarnings, Tax, AnyAssets, 
		AssetsNonDisclosure, AnyLiabilities, LiabilitiesRepayment, LiabilitiesWhyNot, 
		RepaymentDetails, LiabilitiesNonDisclosure, BudgetNotes, AssetLiabilityNotes, ConcurrencyId, 		
	BudgetMiscellaneousId, @StampAction, GetDate(), @StampUser, [LiabilityNotes]
FROM TBudgetMiscellaneous
WHERE BudgetMiscellaneousId = @BudgetMiscellaneousId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
