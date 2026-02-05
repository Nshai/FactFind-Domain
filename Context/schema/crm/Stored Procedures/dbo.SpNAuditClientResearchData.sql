SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditClientResearchData]
	@StampUser varchar (255),
	@ClientResearchDataId bigint,
	@StampAction char(1)
AS

INSERT INTO TClientResearchDataAudit 
( ClientResearchId, Data, ConcurrencyId, 
	ClientResearchDataId, StampAction, StampDateTime, StampUser) 
Select ClientResearchId, Data, ConcurrencyId, 
	ClientResearchDataId, @StampAction, GetDate(), @StampUser
FROM TClientResearchData
WHERE ClientResearchDataId = @ClientResearchDataId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
