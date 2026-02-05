SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

Create PROCEDURE [dbo].[SpNAuditPropositionType]
	@StampUser varchar (255),
	@PropositionTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TPropositionTypeAudit 
( 
	PropositionTypeName, TenantId, IsArchived, ConcurrencyId, 		
	PropositionTypeId, StampAction, StampDateTime, StampUser
) 
Select PropositionTypeName, TenantId, IsArchived, ConcurrencyId, 
	PropositionTypeId, @StampAction, GetDate(), @StampUser
FROM TPropositionType
WHERE PropositionTypeId = @PropositionTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO


