SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCriticalIllnessDetail]
	@StampUser varchar (255),
	@CriticalIllnessDetailId bigint,
	@StampAction char(1)
AS

INSERT INTO TCriticalIllnessDetailAudit 
( TotalPermanentDisability, CriticalIllnessCondition, CoverType, CriticalIllnessTPDAmount, 
		TenantId, ConcurrencyId, 
	CriticalIllnessDetailId, StampAction, StampDateTime, StampUser) 
Select TotalPermanentDisability, CriticalIllnessCondition, CoverType, CriticalIllnessTPDAmount, 
		TenantId, ConcurrencyId, 
	CriticalIllnessDetailId, @StampAction, GetDate(), @StampUser
FROM TCriticalIllnessDetail
WHERE CriticalIllnessDetailId = @CriticalIllnessDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
