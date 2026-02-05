SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefFeeRetainerFrequency]
	@StampUser varchar (255),
	@RefFeeRetainerFrequencyId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefFeeRetainerFrequencyAudit 
( PeriodName, NumMonths, ConcurrencyId, 
	RefFeeRetainerFrequencyId, StampAction, StampDateTime, StampUser) 
Select PeriodName, NumMonths, ConcurrencyId, 
	RefFeeRetainerFrequencyId, @StampAction, GetDate(), @StampUser
FROM TRefFeeRetainerFrequency
WHERE RefFeeRetainerFrequencyId = @RefFeeRetainerFrequencyId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
