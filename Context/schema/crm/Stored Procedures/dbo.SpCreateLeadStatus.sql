SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateLeadStatus]
@StampUser varchar (255),
@Descriptor varchar (255),
@CanConvertToClientFG bit = 0,
@OrderNumber bigint,
@IndigoClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @LeadStatusId bigint

  INSERT INTO TLeadStatus (
    Descriptor, 
    CanConvertToClientFG, 
    OrderNumber, 
    IndigoClientId, 
    ConcurrencyId ) 
  VALUES (
    @Descriptor, 
    @CanConvertToClientFG, 
    @OrderNumber, 
    @IndigoClientId, 
    1) 

  SELECT @LeadStatusId = SCOPE_IDENTITY()
  INSERT INTO TLeadStatusAudit (
    Descriptor, 
    CanConvertToClientFG, 
    OrderNumber, 
    IndigoClientId, 
    ConcurrencyId,
    LeadStatusId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.Descriptor, 
    T1.CanConvertToClientFG, 
    T1.OrderNumber, 
    T1.IndigoClientId, 
    T1.ConcurrencyId,
    T1.LeadStatusId,
    'C',
    GetDate(),
    @StampUser

  FROM TLeadStatus T1
 WHERE T1.LeadStatusId=@LeadStatusId
  EXEC SpRetrieveLeadStatusById @LeadStatusId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
