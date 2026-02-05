SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefBenefitPeriod]
	@StampUser varchar (255),
	@RefBenefitPeriodId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefBenefitPeriodAudit 
( Descriptor, ArchiveFG, IndigoClientId, ConcurrencyId, 
		
	RefBenefitPeriodId, StampAction, StampDateTime, StampUser) 
Select Descriptor, ArchiveFG, IndigoClientId, ConcurrencyId, 
		
	RefBenefitPeriodId, @StampAction, GetDate(), @StampUser
FROM TRefBenefitPeriod
WHERE RefBenefitPeriodId = @RefBenefitPeriodId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
