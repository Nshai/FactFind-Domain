SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditGroupSchemeCommission]
	@StampUser varchar (255),
	@GroupSchemeCommissionId bigint,
	@StampAction char(1)
AS

INSERT INTO TGroupSchemeCommissionAudit 
( GroupSchemeId, TenantId, PolicyExpectedCommissionId, SchemeCommissionRate, 
		SchemeCommissionType, IsCalculateCommissionDue, ConcurrencyId, 
	GroupSchemeCommissionId, StampAction, StampDateTime, StampUser) 
Select GroupSchemeId, TenantId, PolicyExpectedCommissionId, SchemeCommissionRate, 
		SchemeCommissionType, IsCalculateCommissionDue, ConcurrencyId, 
	GroupSchemeCommissionId, @StampAction, GetDate(), @StampUser
FROM TGroupSchemeCommission
WHERE GroupSchemeCommissionId = @GroupSchemeCommissionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
