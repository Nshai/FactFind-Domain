SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPropositionToRefPlanTypeProductSubType]
	@StampUser varchar (255),
	@PropositionToRefPlanTypeProductSubTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TPropositionToRefPlanTypeProductSubTypeAudit 
( TenantId, PropositionToRefPlanTypeProductSubTypeId, PropositionTypeId, RefPlanType2ProdSubTypeId,
	ConcurrencyId, StampAction, StampDateTime, StampUser) 
Select TenantId, PropositionToRefPlanTypeProductSubTypeId, PropositionTypeId, RefPlanType2ProdSubTypeId,
	ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM TPropositionToRefPlanTypeProductSubType
WHERE PropositionToRefPlanTypeProductSubTypeId = @PropositionToRefPlanTypeProductSubTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
