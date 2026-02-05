SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPolicyBusinessPurpose]
	@StampUser varchar (255),
	@PolicyBusinessPurposeId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyBusinessPurposeAudit 
( PlanPurposeId, PolicyBusinessId, ConcurrencyId, 
	PolicyBusinessPurposeId, StampAction, StampDateTime, StampUser) 
Select PlanPurposeId, PolicyBusinessId, ConcurrencyId, 
	PolicyBusinessPurposeId, @StampAction, GetDate(), @StampUser
FROM TPolicyBusinessPurpose
WHERE PolicyBusinessPurposeId = @PolicyBusinessPurposeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
