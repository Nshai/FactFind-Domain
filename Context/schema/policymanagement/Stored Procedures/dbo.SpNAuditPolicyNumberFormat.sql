SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPolicyNumberFormat]
	@StampUser varchar (255),
	@PolicyNumberFormatId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyNumberFormatAudit 
( UserFormat, Example, RegularExpression, RefProdProviderId, 
		RefPlanTypeId, IndigoClientId, ConcurrencyId, 
	PolicyNumberFormatId, StampAction, StampDateTime, StampUser) 
Select UserFormat, Example, RegularExpression, RefProdProviderId, 
		RefPlanTypeId, IndigoClientId, ConcurrencyId, 
	PolicyNumberFormatId, @StampAction, GetDate(), @StampUser
FROM TPolicyNumberFormat
WHERE PolicyNumberFormatId = @PolicyNumberFormatId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
