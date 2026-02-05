SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateValRequest]
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
  DECLARE @ValRequestId bigint

  INSERT INTO TValRequest (
    PractitionerId, 
    CRMContactId, 
    PolicyBusinessId, 
    PlanValuationId, 
    ValuationType, 
    RequestXML, 
    RequestedUserId, 
    RequestedDate, 
    RequestStatus, 
    ConcurrencyId ) 
  VALUES (
    @PractitionerId, 
    @CRMContactId, 
    @PolicyBusinessId, 
    @PlanValuationId, 
    @ValuationType, 
    @RequestXML, 
    @RequestedUserId, 
    @RequestedDate, 
    @RequestStatus, 
    1) 

  SELECT @ValRequestId = SCOPE_IDENTITY()
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
    'C',
    GetDate(),
    @StampUser

  FROM TValRequest T1
 WHERE T1.ValRequestId=@ValRequestId
  EXEC SpRetrieveValRequestById @ValRequestId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
