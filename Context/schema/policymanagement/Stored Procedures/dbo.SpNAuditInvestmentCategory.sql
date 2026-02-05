SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditInvestmentCategory]
	@StampUser varchar (255),
	@InvestmentCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TInvestmentCategoryAudit 
( Descriptor, IndigoClientId, OrderNbr, ChartSeriesColour, 
		Guid, ConcurrencyId, 
	InvestmentCategoryId, StampAction, StampDateTime, StampUser) 
Select Descriptor, IndigoClientId, OrderNbr, ChartSeriesColour, 
		Guid, ConcurrencyId, 
	InvestmentCategoryId, @StampAction, GetDate(), @StampUser
FROM TInvestmentCategory
WHERE InvestmentCategoryId = @InvestmentCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
