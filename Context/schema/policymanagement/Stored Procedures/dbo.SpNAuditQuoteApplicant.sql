SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditQuoteApplicant]
	@StampUser varchar (255),
	@QuoteApplicantId bigint,
	@StampAction char(1)
AS

INSERT INTO TQuoteApplicantAudit
( 
	RefEmploymentStatusId,EmployerName,EmploymentMonths,JobRole,JobIndustry,EmployerAddressId,ProductApplicationId,PartyId,PropertyDetailId,
	ConcurrencyId, QuoteApplicantId, StampAction, StampDateTime, StampUser
) 
SELECT  
	RefEmploymentStatusId,EmployerName,EmploymentMonths,JobRole,JobIndustry,EmployerAddressId,ProductApplicationId,PartyId,PropertyDetailId,
	ConcurrencyId, QuoteApplicantId, @StampAction, GetDate(), @StampUser

FROM TQuoteApplicant
WHERE QuoteApplicantId = @QuoteApplicantId 

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
