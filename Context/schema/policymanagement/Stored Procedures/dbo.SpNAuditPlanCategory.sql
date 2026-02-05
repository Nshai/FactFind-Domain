SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPlanCategory]
	@StampUser varchar (255),
	@PlanCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TPlanCategoryAudit 
( PlanCategoryName, RetireFg, IndigoClientId, ConcurrencyId, 
		
	PlanCategoryId, StampAction, StampDateTime, StampUser) 
Select PlanCategoryName, RetireFg, IndigoClientId, ConcurrencyId, 
		
	PlanCategoryId, @StampAction, GetDate(), @StampUser
FROM TPlanCategory
WHERE PlanCategoryId = @PlanCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
