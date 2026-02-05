SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPolicyBeneficary]
	@StampUser varchar (255),
	@PolicyBeneficaryId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyBeneficaryAudit 
( BeneficaryCRMContactId, BeneficiaryPersonalContactId, BeneficaryPercentage, Amount, PolicyDetailId, ConcurrencyId, 
	PolicyBeneficaryId, RelationshipType, IsPerStirpes, Type, CrmContactId, SubjectType, StampAction, StampDateTime, StampUser, MigrationRef, ExternalReference,
	OwnerClientId, BindingLapsingDate) 
Select BeneficaryCRMContactId, BeneficiaryPersonalContactId, BeneficaryPercentage, Amount, PolicyDetailId, ConcurrencyId, 
	PolicyBeneficaryId, RelationshipType, IsPerStirpes, Type, CrmContactId, SubjectType, @StampAction, GetDate(), @StampUser, MigrationRef, ExternalReference,
	OwnerClientId, BindingLapsingDate
FROM TPolicyBeneficary
WHERE PolicyBeneficaryId = @PolicyBeneficaryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
