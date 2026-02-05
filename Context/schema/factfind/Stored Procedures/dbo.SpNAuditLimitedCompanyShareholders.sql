SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLimitedCompanyShareholders]
	@StampUser varchar (255),
	@LimitedCompanyShareholdersId bigint,
	@StampAction char(1)
AS

INSERT INTO TLimitedCompanyShareholdersAudit 
( CRMContactId, ShareHolderName, ShareHolderRole, DOB, 
		Smoker, DateJoinedCompany, CurrentValue, PercentageInterest, 
		CurrentYear, LastYear, TwoYearsAgo, InGoodHealth, 
		ConcurrencyId, 
	LimitedCompanyShareholdersId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, ShareHolderName, ShareHolderRole, DOB, 
		Smoker, DateJoinedCompany, CurrentValue, PercentageInterest, 
		CurrentYear, LastYear, TwoYearsAgo, InGoodHealth, 
		ConcurrencyId, 
	LimitedCompanyShareholdersId, @StampAction, GetDate(), @StampUser
FROM TLimitedCompanyShareholders
WHERE LimitedCompanyShareholdersId = @LimitedCompanyShareholdersId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
