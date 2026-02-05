SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditRiskGrouping]
	@StampUser varchar (255),
	@RiskGroupingId bigint,
	@StampAction char(1)
AS

INSERT INTO TRiskGroupingAudit 
		(ConcurrencyId, Name,[Description],Tolerance, IsArchived, 
		IndigoClientId, RiskGroupingId,RiskGroupingSyncId, StampAction, StampDateTime, StampUser)
		
SELECT  ConcurrencyId, Name,[Description],Tolerance, IsArchived, 
		IndigoClientId, RiskGroupingId,RiskGroupingSyncId, @StampAction, GetDate(), @StampUser
		
FROM	TRiskGrouping		
	
WHERE 
		RiskGroupingId = @RiskGroupingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
