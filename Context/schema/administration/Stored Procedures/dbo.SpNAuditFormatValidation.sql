SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFormatValidation]
	@StampUser varchar (255),
	@FormatValidationId bigint,
	@StampAction char(1)
AS

INSERT INTO TFormatValidationAudit 
( IndigoClientId, Entity, RuleType, ValidationExpression, 
		ErrorMessage, ConcurrencyId, 
	FormatValidationId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, Entity, RuleType, ValidationExpression, 
		ErrorMessage, ConcurrencyId, 
	FormatValidationId, @StampAction, GetDate(), @StampUser
FROM TFormatValidation
WHERE FormatValidationId = @FormatValidationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
