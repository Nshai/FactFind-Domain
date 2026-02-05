SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditInvestmentType]
	@StampUser varchar (255),
	@InvestmentTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TInvestmentTypeAudit 
( Descriptor, IndigoClientId, InvestmentCategoryId, DefaultRiskRating, 
		Guid, ConcurrencyId, 
	InvestmentTypeId, StampAction, StampDateTime, StampUser) 
Select Descriptor, IndigoClientId, InvestmentCategoryId, DefaultRiskRating, 
		Guid, ConcurrencyId, 
	InvestmentTypeId, @StampAction, GetDate(), @StampUser
FROM TInvestmentType
WHERE InvestmentTypeId = @InvestmentTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
