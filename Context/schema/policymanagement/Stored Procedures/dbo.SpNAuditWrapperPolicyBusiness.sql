SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditWrapperPolicyBusiness]
	@StampUser varchar (255),
	@WrapperPolicyBusinessId bigint,
	@StampAction char(1)
AS

INSERT INTO TWrapperPolicyBusinessAudit 
( ParentPolicyBusinessId, PolicyBusinessId, ConcurrencyId, 
	WrapperPolicyBusinessId, StampAction, StampDateTime, StampUser) 
Select ParentPolicyBusinessId, PolicyBusinessId, ConcurrencyId, 
	WrapperPolicyBusinessId, @StampAction, GetDate(), @StampUser
FROM TWrapperPolicyBusiness
WHERE WrapperPolicyBusinessId = @WrapperPolicyBusinessId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
