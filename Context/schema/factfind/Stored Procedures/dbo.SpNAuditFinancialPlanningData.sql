SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningData]
	@StampUser varchar (255),
	@FinancialPlanningDataId int,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningDataAudit 
(
	 FinancialPlanningDataId
	, DataKey
	, DataValue
	, FinancialPlanningOutputId
	, ConcurrencyId
	, StampAction
	, StampDateTime
	, StampUser
) 
Select FinancialPlanningDataId
	, DataKey
	, DataValue
	, FinancialPlanningOutputId
	, ConcurrencyId
	, @StampAction
	, GetDate()
	, @StampUser

FROM TFinancialPlanningData
WHERE FinancialPlanningDataId = @FinancialPlanningDataId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
