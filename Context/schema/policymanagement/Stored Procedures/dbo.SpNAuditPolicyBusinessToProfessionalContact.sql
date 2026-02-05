SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPolicyBusinessToProfessionalContact]
	@StampUser varchar (255),
	@PolicyBusinessToProfessionalContactId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyBusinessToProfessionalContactAudit 
( PolicyBusinessToProfessionalContactId, ProfessionalContactId, PolicyBusinessId, TenantId, 
		ConcurrencyId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessToProfessionalContactId, ProfessionalContactId, PolicyBusinessId, TenantId, 
		ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM TPolicyBusinessToProfessionalContact
WHERE PolicyBusinessToProfessionalContactId = @PolicyBusinessToProfessionalContactId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)



GO
