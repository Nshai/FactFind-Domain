SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAdviceCase]
	@StampUser varchar (255),
	@AdviceCaseId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCaseAudit 
( 
	CRMContactId,
	PractitionerId,
	StatusId,
	StartDate,
	CaseName,
	CaseRef,
	BinderId,
	BinderDescription,
	BinderOwnerId,
	ConcurrencyId,
	AdviseCategoryId, 	
	AdviceCaseId, 
	StampAction, 
	StampDateTime,
	StampUser,
	Owner2PartyId,
	IsJoint,
	SequentialRef,
	ReopenDate,Owner1Vulnerability,
	Owner2Vulnerability,
	Owner1VulnerabilityNotes,
	Owner2VulnerabilityNotes,	
	ServicingAdminUserId,
	ParaplannerUserId,
	RecommendationId,
	Owner1VulnerabilityId,
	Owner2VulnerabilityId,
	HasRisk,
	ComplianceCompletedBy,
	PropertiesJson
) 
Select 
	CRMContactId,
	PractitionerId, 
	StatusId,
	StartDate, 
	CaseName,
	CaseRef,  
	BinderId,
	BinderDescription,
	BinderOwnerId, 
	ConcurrencyId,
	AdviseCategoryId,  
	AdviceCaseId,
	@StampAction, 
	GetDate(), 
	@StampUser,
	Owner2PartyId,
	IsJoint,
	SequentialRef,
	ReopenDate, 
	Owner1Vulnerability, 
	Owner2Vulnerability,
	Owner1VulnerabilityNotes,
	Owner2VulnerabilityNotes,
	ServicingAdminUserId,
	ParaplannerUserId,
	RecommendationId,
	Owner1VulnerabilityId,
	Owner2VulnerabilityId,
	HasRisk,
	ComplianceCompletedBy,
	PropertiesJson
FROM TAdviceCase
WHERE AdviceCaseId = @AdviceCaseId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO