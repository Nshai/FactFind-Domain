SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteCreditNoteByProvBreakId]
@ProvBreakId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TCreditNoteAudit (
    FeeId, 
    ProvBreakId, 
    NetAmount, 
    VATAmount, 
    DateRaised, 
    SentToClientDate, 
    Description, 
    IndigoClientId, 
    ConcurrencyId,
    CreditNoteId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.FeeId, 
    T1.ProvBreakId, 
    T1.NetAmount, 
    T1.VATAmount, 
    T1.DateRaised, 
    T1.SentToClientDate, 
    T1.Description, 
    T1.IndigoClientId, 
    T1.ConcurrencyId,
    T1.CreditNoteId,
    'D',
    GetDate(),
    @StampUser

  FROM TCreditNote T1

  WHERE (T1.ProvBreakId = @ProvBreakId)
  DELETE T1 FROM TCreditNote T1

  WHERE (T1.ProvBreakId = @ProvBreakId)


  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
