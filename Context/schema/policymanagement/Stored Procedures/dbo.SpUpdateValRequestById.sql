SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpUpdateValRequestById]
@KeyValRequestId bigint,
@StampUser varchar (255),
@PractitionerId bigint,
@CRMContactId bigint = NULL,
@PolicyBusinessId bigint = NULL,
@PlanValuationId bigint = NULL,
@ValuationType varchar (50),
@RequestXML varchar (6000),
@RequestedUserId bigint,
@RequestedDate datetime,
@RequestStatus varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TValRequestAudit (
    PractitionerId, 
    CRMContactId, 
    PolicyBusinessId, 
    PlanValuationId, 
    ValuationType, 
    RequestXML, 
    RequestedUserId, 
    RequestedDate, 
    RequestStatus, 
    ConcurrencyId,
    ValRequestId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.PractitionerId, 
    T1.CRMContactId, 
    T1.PolicyBusinessId, 
    T1.PlanValuationId, 
    T1.ValuationType, 
    T1.RequestXML, 
    T1.RequestedUserId, 
    T1.RequestedDate, 
    T1.RequestStatus, 
    T1.ConcurrencyId,
    T1.ValRequestId,
    'U',
    GetDate(),
    @StampUser

  FROM TValRequest T1

  WHERE (T1.ValRequestId = @KeyValRequestId)
  UPDATE T1
  SET 
    T1.PractitionerId = @PractitionerId,
    T1.CRMContactId = @CRMContactId,
    T1.PolicyBusinessId = @PolicyBusinessId,
    T1.PlanValuationId = @PlanValuationId,
    T1.ValuationType = @ValuationType,
    T1.RequestXML = @RequestXML,
    T1.RequestedUserId = @RequestedUserId,
    T1.RequestedDate = @RequestedDate,
    T1.RequestStatus = @RequestStatus,
    T1.ConcurrencyId = T1.ConcurrencyId + 1
  FROM TValRequest T1

  WHERE (T1.ValRequestId = @KeyValRequestId)

SELECT * FROM TValRequest [ValRequest]
  WHERE ([ValRequest].ValRequestId = @KeyValRequestId)
 FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
