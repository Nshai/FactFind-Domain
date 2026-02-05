SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpNAuditRetainer]
	@StampUser varchar (255),
	@RetainerId bigint,
	@StampAction char(1)
AS

INSERT INTO TRetainerAudit 
( NetAmount, VATAmount, RefFeeRetainerFrequencyId, StartDate, 
		ReviewDate, EndDate, SentToClientDate, ReceivedFromClientDate, 
		SentToBankDate, Description, IndigoClientId, isVatExempt, 
		RefVATId, SequentialRef, ConcurrencyId,
		RetainerId, StampAction, StampDateTime, StampUser) 
		
Select NetAmount, VATAmount, RefFeeRetainerFrequencyId, StartDate, 
		ReviewDate, EndDate, SentToClientDate, ReceivedFromClientDate, 
		SentToBankDate, Description, IndigoClientId, isVatExempt, 
		RefVATId, SequentialRef, ConcurrencyId, 
		RetainerId, @StampAction, GetDate(), @StampUser
FROM TRetainer
WHERE RetainerId = @RetainerId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
