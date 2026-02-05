SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAudiTRefAnnuityPaymentType]
	@StampUser varchar (255),
	@RefAnnuityPaymentTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefAnnuityPaymentTypeAudit 
(RefAnnuityPaymentTypeId, RefAnnuityPaymentTypeName, ConcurrencyId, StampAction, StampDateTime, StampUser) 
Select RefAnnuityPaymentTypeId, RefAnnuityPaymentTypeName, ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM TRefAnnuityPaymentType
WHERE RefAnnuityPaymentTypeId = @RefAnnuityPaymentTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
