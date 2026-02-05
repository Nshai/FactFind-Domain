SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditGroupPersonalPensionSchemeCategory]
	@StampUser varchar (255),
	@GroupPersonalPensionSchemeCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TGroupPersonalPensionSchemeCategoryAudit 
(	GroupSchemeCategoryId, RefCoverToId, AccrualRate, RefSalaryExchangeforEmployerId, 
	EmployerPercentagetoPension, RefSalaryExchangeforEmployeeId, IsEarlyRetirementOption, 
	IsLateRetirementOption, EarliestRetirementAge, LatestRetirementAge, 
	IsSchemeLinkedtoGroupLife, MSRtoEmployerContribution, RefMinimumServiceRequirementTypeId, 
	RefChangesTakeEffectId, TenantId, ConcurrencyId, GroupPersonalPensionSchemeCategoryId, 
	StampAction, StampDateTime, StampUser) 
Select  GroupSchemeCategoryId, RefCoverToId, AccrualRate, RefSalaryExchangeforEmployerId, 
		EmployerPercentagetoPension, RefSalaryExchangeforEmployeeId, IsEarlyRetirementOption, 
		IsLateRetirementOption, EarliestRetirementAge, LatestRetirementAge, 
		IsSchemeLinkedtoGroupLife, MSRtoEmployerContribution, RefMinimumServiceRequirementTypeId, 
		RefChangesTakeEffectId, TenantId, ConcurrencyId, GroupPersonalPensionSchemeCategoryId, 
		@StampAction, GetDate(), @StampUser
FROM TGroupPersonalPensionSchemeCategory
WHERE GroupPersonalPensionSchemeCategoryId = @GroupPersonalPensionSchemeCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
