SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditClientResearch]
	@StampUser varchar (255),
	@ClientResearchId bigint,
	@StampAction char(1)
AS

INSERT INTO TClientResearchAudit 
( CalculatorId, CRMContactId, UserId, Date, 
		Description, ConcurrencyId, 
	ClientResearchId, StampAction, StampDateTime, StampUser) 
Select CalculatorId, CRMContactId, UserId, Date, 
		Description, ConcurrencyId, 
	ClientResearchId, @StampAction, GetDate(), @StampUser
FROM TClientResearch
WHERE ClientResearchId = @ClientResearchId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
