SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateValResponse]
@StampUser varchar (255),
@ValRequestId bigint,
@ResponseXML text = NULL,
@ResponseDate datetime = NULL,
@ResponseStatus varchar (255) = NULL,
@ErrorDescription varchar (4000) = NULL,
@IsAnalysed bit = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @ValResponseId bigint

  INSERT INTO TValResponse (
    ValRequestId, 
    ResponseXML, 
    ResponseDate, 
    ResponseStatus, 
    ErrorDescription, 
    IsAnalysed, 
    ConcurrencyId ) 
  VALUES (
    @ValRequestId, 
    @ResponseXML, 
    @ResponseDate, 
    @ResponseStatus, 
    @ErrorDescription, 
    @IsAnalysed, 
    1) 

  SELECT @ValResponseId = SCOPE_IDENTITY()
  INSERT INTO TValResponseAudit (
    ValRequestId, 
    ResponseXML, 
    ResponseDate, 
    ResponseStatus, 
    ErrorDescription, 
    IsAnalysed, 
    ConcurrencyId,
    ValResponseId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.ValRequestId, 
    T1.ResponseXML, 
    T1.ResponseDate, 
    T1.ResponseStatus, 
    T1.ErrorDescription, 
    T1.IsAnalysed, 
    T1.ConcurrencyId,
    T1.ValResponseId,
    'C',
    GetDate(),
    @StampUser

  FROM TValResponse T1
 WHERE T1.ValResponseId=@ValResponseId
  EXEC SpRetrieveValResponseById @ValResponseId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
