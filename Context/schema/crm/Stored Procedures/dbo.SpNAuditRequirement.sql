SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRequirement]
	@StampUser varchar (255),
	@RequirementId bigint,
	@StampAction char(1)
AS

INSERT INTO TRequirementAudit 
	 ([Type], PrimaryPartyId, SecondaryPartyId, TenantId, MortgageOpportunityId, ObjectiveId, RequirementId, StampAction, StampDateTime, StampUser) 
Select 
	  [Type], PrimaryPartyId, SecondaryPartyId, TenantId, MortgageOpportunityId, ObjectiveId, RequirementId, @StampAction, GetDate(), @StampUser
FROM  TRequirement
WHERE RequirementId = @RequirementId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
