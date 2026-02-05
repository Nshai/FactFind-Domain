SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditExpenditureDetail]
	@StampUser varchar (255),
	@ExpenditureDetailId bigint,
	@StampAction char(1)
AS

INSERT INTO TExpenditureDetailAudit 
(ConcurrencyId, CRMContactId, RefExpenditureTypeId, NetMonthlyAmount, UserDescription, IsConsolidated, IsLiabilityToBeRepaid,
	ExpenditureDetailId, StampAction, StampDateTime, StampUser,Frequency, ExpenditureId, CRMContactId2, PolicyBusinessId, ContributionId, StartDate, EndDate,
	NetAmount)
SELECT  ConcurrencyId, CRMContactId, RefExpenditureTypeId, NetMonthlyAmount, UserDescription, IsConsolidated, IsLiabilityToBeRepaid,
	ExpenditureDetailId, @StampAction, GetDate(), @StampUser,Frequency, ExpenditureId, CRMContactId2, PolicyBusinessId, ContributionId, StartDate, EndDate,
	NetAmount
FROM TExpenditureDetail
WHERE ExpenditureDetailId = @ExpenditureDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
