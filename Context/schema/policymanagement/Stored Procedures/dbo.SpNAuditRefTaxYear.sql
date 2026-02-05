SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefTaxYear]
	@StampUser varchar (255),
	@RefTaxYearId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefTaxYearAudit 
( RefTaxYearName, RetireFg, ConcurrencyId, 
	RefTaxYearId, StampAction, StampDateTime, StampUser) 
Select RefTaxYearName, RetireFg, ConcurrencyId, 
	RefTaxYearId, @StampAction, GetDate(), @StampUser
FROM TRefTaxYear
WHERE RefTaxYearId = @RefTaxYearId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
