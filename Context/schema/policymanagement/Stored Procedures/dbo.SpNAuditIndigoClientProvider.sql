SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditIndigoClientProvider]
	@StampUser varchar (255),
	@IndigoClientProviderId bigint,
	@StampAction char(1)
AS

INSERT INTO TIndigoClientProviderAudit 
( RefProdProviderId, IndigoClientId, ConcurrencyId, 
	IndigoClientProviderId, StampAction, StampDateTime, StampUser) 
Select RefProdProviderId, IndigoClientId, ConcurrencyId, 
	IndigoClientProviderId, @StampAction, GetDate(), @StampUser
FROM TIndigoClientProvider
WHERE IndigoClientProviderId = @IndigoClientProviderId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
