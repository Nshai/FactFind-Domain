SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPolicyOwner]
	@StampUser varchar (255),
	@PolicyOwnerId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyOwnerAudit 
( 
	 PolicyOwnerId
	,CRMContactId
	,PolicyDetailId
	,ConcurrencyId
	,OwnerOrder
	,PlanMigrationRef
	,StampAction
	,StampDateTime
	,StampUser
) 
Select 
	PolicyOwnerId
	,CRMContactId
	,PolicyDetailId
	,ConcurrencyId
	,OwnerOrder
	,PlanMigrationRef
	,@StampAction
	,GetDate()
	,@StampUser
FROM TPolicyOwner
WHERE PolicyOwnerId = @PolicyOwnerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
