SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValGating]
	@StampUser varchar (255),
	@ValGatingId bigint,
	@StampAction char(1)
AS

INSERT INTO TValGatingAudit 
( RefProdProviderId, RefPlanTypeId, ProdSubTypeId, OrigoProductType, 
		OrigoProductVersion, ValuationXSLId, ProviderPlanTypeName, ConcurrencyId, 
		
	ValGatingId, StampAction, StampDateTime, StampUser) 
Select RefProdProviderId, RefPlanTypeId, ProdSubTypeId, OrigoProductType, 
		OrigoProductVersion, ValuationXSLId, ProviderPlanTypeName, ConcurrencyId, 
		
	ValGatingId, @StampAction, GetDate(), @StampUser
FROM TValGating
WHERE ValGatingId = @ValGatingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
