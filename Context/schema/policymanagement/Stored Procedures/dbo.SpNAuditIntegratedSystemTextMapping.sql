Create PROCEDURE [dbo].[SpNAuditIntegratedSystemTextMapping]
	@StampUser varchar (255),
	@IntegratedSystemTextMappingId bigint,
	@StampAction char(1)
AS

INSERT INTO TIntegratedSystemTextMappingAudit 
( ApplicationLinkId, DisplayAsReadOnly, DeclarationText, ConcurrencyId, 
	IntegratedSystemTextMappingId, StampAction, StampDateTime, StampUser) 
Select ApplicationLinkId, DisplayAsReadOnly, DeclarationText, ConcurrencyId, 
	IntegratedSystemTextMappingId, @StampAction, GetDate(), @StampUser
FROM TIntegratedSystemTextMapping
WHERE IntegratedSystemTextMappingId = @IntegratedSystemTextMappingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
