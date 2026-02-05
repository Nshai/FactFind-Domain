SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditDetailedincomebreakdown]
	@StampUser varchar (255),
	@DetailedincomebreakdownId bigint,
	@StampAction char(1)
AS

INSERT INTO TDetailedincomebreakdownAudit 
( CRMContactId, CRMContactId2, Owner, Description, 
		Amount, Frequency,HasIncludeInAffordability, GrossOrNet, GrossAmountDescription, IncomeType, ConcurrencyId, 
		
	DetailedincomebreakdownId,EmploymentDetailIdValue, StampAction, StampDateTime, StampUser,NetAmount, StartDate, EndDate, PolicyBusinessId, WithdrawalId, LastUpdatedDate) 
Select CRMContactId, CRMContactId2, Owner, Description, 
		Amount, Frequency,HasIncludeInAffordability, GrossOrNet, GrossAmountDescription, IncomeType, ConcurrencyId, 
		
	DetailedincomebreakdownId,EmploymentDetailIdValue, @StampAction, GetDate(), @StampUser, NetAmount, StartDate, EndDate, PolicyBusinessId, WithdrawalId, LastUpdatedDate
FROM TDetailedincomebreakdown
WHERE DetailedincomebreakdownId = @DetailedincomebreakdownId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
