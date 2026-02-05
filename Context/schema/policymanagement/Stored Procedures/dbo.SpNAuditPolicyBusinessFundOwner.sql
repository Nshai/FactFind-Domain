SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPolicyBusinessFundOwner]
	@StampUser varchar (255),
	@PolicyBusinessFundOwnerId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyBusinessFundOwnerAudit 
( PolicyBusinessFundId, PolicyBusinessId, CRMContactId, PercentageHeld, 
		FundType, ConcurrencyId, 
	PolicyBusinessFundOwnerId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessFundId, PolicyBusinessId, CRMContactId, PercentageHeld, 
		FundType, ConcurrencyId, 
	PolicyBusinessFundOwnerId, @StampAction, GetDate(), @StampUser
FROM TPolicyBusinessFundOwner
WHERE PolicyBusinessFundOwnerId = @PolicyBusinessFundOwnerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
