SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateCreditNote]
@StampUser varchar (255),
@FeeId bigint = NULL,
@ProvBreakId bigint = NULL,
@NetAmount money = NULL,
@VATAmount money = NULL,
@DateRaised datetime = NULL,
@Description varchar (255) = NULL,
@IndigoClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @CreditNoteId bigint

  INSERT INTO TCreditNote (
    FeeId, 
    ProvBreakId, 
    NetAmount, 
    VATAmount, 
    DateRaised, 
    SentToClientDate, 
    Description, 
    IndigoClientId, 
    ConcurrencyId ) 
  VALUES (
    @FeeId, 
    @ProvBreakId, 
    @NetAmount, 
    @VATAmount, 
    @DateRaised, 
    NULL, 
    @Description, 
    @IndigoClientId, 
    1) 

  SELECT @CreditNoteId = SCOPE_IDENTITY()
  INSERT INTO TCreditNoteAudit (
    FeeId, 
    ProvBreakId, 
    NetAmount, 
    VATAmount, 
    DateRaised, 
    SentToClientDate, 
    Description, 
    IndigoClientId, 
    SequentialRef, 
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
    T1.SequentialRef, 
    T1.ConcurrencyId,
    T1.CreditNoteId,
    'C',
    GetDate(),
    @StampUser

  FROM TCreditNote T1
 WHERE T1.CreditNoteId=@CreditNoteId
  EXEC SpRetrieveCreditNoteById @CreditNoteId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
