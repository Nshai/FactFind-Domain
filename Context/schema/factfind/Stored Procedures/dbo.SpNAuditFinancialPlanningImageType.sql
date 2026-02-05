SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningImageType]
	@StampUser varchar (255),
	@FinancialPlanningImageTypeId int,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningImageTypeAudit 
( 
	ImageTypeName
	, FinancialPlanningImageTypeId
	, ImageTypeDisplayName
	, ConcurrencyId
	, StampAction
	, StampDateTime
	, StampUser
) 
Select ImageTypeName
	, FinancialPlanningImageTypeId
	, ImageTypeDisplayName
	, ConcurrencyId
	, @StampAction
	, GetDate()
	, @StampUser
FROM TFinancialPlanningImageType
WHERE FinancialPlanningImageTypeId = @FinancialPlanningImageTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
