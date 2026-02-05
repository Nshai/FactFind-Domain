SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditLeadStatusToRole]
	@StampUser varchar (255),
	@LeadStatusToRoleId bigint,
	@StampAction char(1)
AS

INSERT INTO TLeadStatusToRoleAudit 
( LeadStatusId, RoleId, TenantId, ConcurrencyId, 
		
	LeadStatusToRoleId, StampAction, StampDateTime, StampUser) 
Select LeadStatusId, RoleId, TenantId, ConcurrencyId, 
		
	LeadStatusToRoleId, @StampAction, GetDate(), @StampUser
FROM TLeadStatusToRole
WHERE LeadStatusToRoleId = @LeadStatusToRoleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
