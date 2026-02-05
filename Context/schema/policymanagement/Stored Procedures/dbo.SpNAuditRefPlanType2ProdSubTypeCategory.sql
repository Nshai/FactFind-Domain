SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefPlanType2ProdSubTypeCategory]
	@StampUser varchar (255),
	@RefPlanType2ProdSubTypeCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefPlanType2ProdSubTypeCategoryAudit 
( IndigoClientId, RefPlanType2ProdSubTypeId, PlanCategoryId, ConcurrencyId, 
		
	RefPlanType2ProdSubTypeCategoryId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, RefPlanType2ProdSubTypeId, PlanCategoryId, ConcurrencyId, 
		
	RefPlanType2ProdSubTypeCategoryId, @StampAction, GetDate(), @StampUser
FROM TRefPlanType2ProdSubTypeCategory
WHERE RefPlanType2ProdSubTypeCategoryId = @RefPlanType2ProdSubTypeCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
