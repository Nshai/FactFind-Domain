SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditSavingsFFExt]
	@StampUser varchar (255),
	@SavingsFFExtId bigint,
	@StampAction char(1)
AS

INSERT INTO TSavingsFFExtAudit 
( CRMContactId, ExistingDeposits, NonDisclosureCash, OtherInvestments, 
		GoalsAndNeeds, NextSteps, NonDisclosureOther, Client1Total, 
		Client2Total, JointTotal, ConcurrencyId, 
	SavingsFFExtId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, ExistingDeposits, NonDisclosureCash, OtherInvestments, 
		GoalsAndNeeds, NextSteps, NonDisclosureOther, Client1Total, 
		Client2Total, JointTotal, ConcurrencyId, 
	SavingsFFExtId, @StampAction, GetDate(), @StampUser
FROM TSavingsFFExt
WHERE SavingsFFExtId = @SavingsFFExtId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
