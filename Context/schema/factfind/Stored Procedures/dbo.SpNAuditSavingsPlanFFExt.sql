SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditSavingsPlanFFExt]
	@StampUser varchar (255),
	@SavingsPlanFFExtId bigint,
	@StampAction char(1)
AS

INSERT INTO TSavingsPlanFFExtAudit 
( PolicyBusinessId, InterestRate, ConcurrencyId, 
	SavingsPlanFFExtId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, InterestRate, ConcurrencyId, 
	SavingsPlanFFExtId, @StampAction, GetDate(), @StampUser
FROM TSavingsPlanFFExt
WHERE SavingsPlanFFExtId = @SavingsPlanFFExtId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
