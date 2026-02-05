SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPlanDescription]
	@StampUser varchar (255),
	@PlanDescriptionId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanDescriptionAudit 
( RefPlanType2ProdSubTypeId, RefProdProviderId, SchemeOwnerCRMContactId, SchemeStatus, 
		SchemeNumber, SchemeName, SchemeStatusDate, SchemeSellingAdvisorPractitionerId, 
		MaturityDate, ConcurrencyId, 
	PlanDescriptionId, StampAction, StampDateTime, StampUser) 
Select RefPlanType2ProdSubTypeId, RefProdProviderId, SchemeOwnerCRMContactId, SchemeStatus, 
		SchemeNumber, SchemeName, SchemeStatusDate, SchemeSellingAdvisorPractitionerId, 
		MaturityDate, ConcurrencyId, 
	PlanDescriptionId, @StampAction, GetDate(), @StampUser
FROM TPlanDescription
WHERE PlanDescriptionId = @PlanDescriptionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
