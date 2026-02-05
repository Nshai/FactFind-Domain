SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningToolsSession]
	@StampUser varchar (255),
	@FinancialPlanningToolsSessionId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningToolsSessionAudit 
( FinancialPlanningId, BaseTemplateGuid, AtrRefProfilePreferenceId, ConcurrencyId, 
	FinancialPlanningToolsSessionId, StampAction, StampDateTime, StampUser) 
Select FinancialPlanningId, BaseTemplateGuid, AtrRefProfilePreferenceId, ConcurrencyId, 
	FinancialPlanningToolsSessionId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningToolsSession
WHERE FinancialPlanningToolsSessionId = @FinancialPlanningToolsSessionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
