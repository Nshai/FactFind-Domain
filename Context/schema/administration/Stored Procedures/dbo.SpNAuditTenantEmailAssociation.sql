SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditTenantEmailAssociation]
	@StampUser varchar (255),
	@TenantEmailAssociationId bigint,
	@StampAction char(1)
AS

INSERT INTO TTenantEmailAssociationAudit 
( EmailAssociationTypeId, TenantEmailConfigId, IsActive, ConcurrencyId, 
		
	TenantEmailAssociationId, StampAction, StampDateTime, StampUser) 
Select EmailAssociationTypeId, TenantEmailConfigId, IsActive, ConcurrencyId, 
		
	TenantEmailAssociationId, @StampAction, GetDate(), @StampUser
FROM TTenantEmailAssociation
WHERE TenantEmailAssociationId = @TenantEmailAssociationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
