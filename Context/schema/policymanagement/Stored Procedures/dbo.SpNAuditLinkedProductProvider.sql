CREATE PROCEDURE [dbo].[SpNAuditLinkedProductProvider]
	@StampUser varchar (255),
	@LinkedProductProviderId bigint,
	@StampAction char(1)
AS

INSERT INTO TLinkedProductProviderAudit (		
	[LinkedProductProviderId], [RefProdProviderId], [LinkedRefProdProviderId],
	StampAction, StampDateTime, StampUser
)
SELECT 
    [LinkedProductProviderId], [RefProdProviderId], [LinkedRefProdProviderId],
	@StampAction, GetDate(), @StampUser
FROM TLinkedProductProvider
WHERE [LinkedProductProviderId] = @LinkedProductProviderId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
	

GO