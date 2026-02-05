SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningOutputType]
	@StampUser varchar (255),
	@FinancialPlanningOutputTypeId int,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningOutputTypeAudit 
( 
	Name
	, ToolName
	, ConcurrencyId
	, OutputIdentifier
	, FinancialPlanningOutputTypeId	
	, StampAction
	, StampDateTime
	, StampUser
) 
Select Name
	, ToolName	
	, ConcurrencyId
	, OutputIdentifier
	, FinancialPlanningOutputTypeId
	, @StampAction
	, GetDate()
	, @StampUser
FROM TFinancialPlanningOutputType
WHERE FinancialPlanningOutputTypeId = @FinancialPlanningOutputTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
