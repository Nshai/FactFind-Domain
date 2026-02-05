SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPlanPurpose]
	@StampUser varchar (255),
	@PlanPurposeId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanPurposeAudit 
( Descriptor, MortgageRelatedfg, IndigoClientId, ConcurrencyId, 
		
	PlanPurposeId, StampAction, StampDateTime, StampUser) 
Select Descriptor, MortgageRelatedfg, IndigoClientId, ConcurrencyId, 
		
	PlanPurposeId, @StampAction, GetDate(), @StampUser
FROM TPlanPurpose
WHERE PlanPurposeId = @PlanPurposeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
