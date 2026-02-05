SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCoverBasis]
	@StampUser varchar (255),
	@CoverBasisId bigint,
	@StampAction char(1)
AS

INSERT INTO TCoverBasisAudit 
( QuoteId, BasisType, CriticalIllnessDetailId, TenantId, 
		ConcurrencyId, 
	CoverBasisId, StampAction, StampDateTime, StampUser) 
Select QuoteId, BasisType, CriticalIllnessDetailId, TenantId, 
		ConcurrencyId, 
	CoverBasisId, @StampAction, GetDate(), @StampUser
FROM TCoverBasis
WHERE CoverBasisId = @CoverBasisId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
