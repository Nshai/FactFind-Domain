SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningImage]
	@StampUser varchar (255),
	@FinancialPlanningImageId int,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningImageAudit 
( 
	FinancialPlanningImageId
	, ImageData
	, FinancialPlanningOutputId
	, FinancialPlanningImageTypeId
	, ConcurrencyId
	, StampAction
	, StampDateTime
	, StampUser
	) 
Select FinancialPlanningImageId
	, ImageData
	, FinancialPlanningOutputId
	, FinancialPlanningImageTypeId
	, ConcurrencyId
	, @StampAction
	, GetDate()
	, @StampUser
FROM TFinancialPlanningImage
WHERE FinancialPlanningImageId = @FinancialPlanningImageId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
