SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditGroupLifeSchemeCategory]
	@StampUser varchar (255),
	@GroupLifeSchemeCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TGroupLifeSchemeCategoryAudit 
( GroupSchemeCategoryId, RefRegisteredId, RefBenefitBasisId, RefCoverToId, 
		IsCopyOfTrustHeld, IsEarningsCapApply, SingleEventLimit, UnitRate, 
		IsSchemeLinkedToDependent, IsSchemeLinkedToGroup, TenantId, ConcurrencyId, 
		
	GroupLifeSchemeCategoryId, StampAction, StampDateTime, StampUser) 
Select GroupSchemeCategoryId, RefRegisteredId, RefBenefitBasisId, RefCoverToId, 
		IsCopyOfTrustHeld, IsEarningsCapApply, SingleEventLimit, UnitRate, 
		IsSchemeLinkedToDependent, IsSchemeLinkedToGroup, TenantId, ConcurrencyId, 
		
	GroupLifeSchemeCategoryId, @StampAction, GetDate(), @StampUser
FROM TGroupLifeSchemeCategory
WHERE GroupLifeSchemeCategoryId = @GroupLifeSchemeCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
