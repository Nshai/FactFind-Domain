SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefApplicationProviderCode]
	@StampUser varchar (255),
	@RefApplicationProviderCodeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefApplicationProviderCodeAudit 
( RefApplicationId, RefProdProviderId, CodeName, ConcurrencyId, 
		
	RefApplicationProviderCodeId, StampAction, StampDateTime, StampUser) 
Select RefApplicationId, RefProdProviderId, CodeName, ConcurrencyId, 
		
	RefApplicationProviderCodeId, @StampAction, GetDate(), @StampUser
FROM TRefApplicationProviderCode
WHERE RefApplicationProviderCodeId = @RefApplicationProviderCodeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
