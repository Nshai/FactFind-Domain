SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPolicyBusinessAttribute]
	@StampUser varchar (255),
	@PolicyBusinessAttributeId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyBusinessAttributeAudit 
( PolicyBusinessId, AttributeList2AttributeId, AttributeValue, ConcurrencyId, 
		
	PolicyBusinessAttributeId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, AttributeList2AttributeId, AttributeValue, ConcurrencyId, 
		
	PolicyBusinessAttributeId, @StampAction, GetDate(), @StampUser
FROM TPolicyBusinessAttribute
WHERE PolicyBusinessAttributeId = @PolicyBusinessAttributeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
