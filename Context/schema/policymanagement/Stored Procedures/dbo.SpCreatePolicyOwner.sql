SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreatePolicyOwner]
@StampUser varchar (255),
@CRMContactId bigint,
@PolicyDetailId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @PolicyOwnerId bigint

  INSERT INTO TPolicyOwner (
    CRMContactId, 
    PolicyDetailId, 
    ConcurrencyId ) 
  VALUES (
    @CRMContactId, 
    @PolicyDetailId, 
    1) 

  SELECT @PolicyOwnerId = SCOPE_IDENTITY()
  INSERT INTO TPolicyOwnerAudit (
    CRMContactId, 
    PolicyDetailId, 
    ConcurrencyId,
    PolicyOwnerId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.CRMContactId, 
    T1.PolicyDetailId, 
    T1.ConcurrencyId,
    T1.PolicyOwnerId,
    'C',
    GetDate(),
    @StampUser

  FROM TPolicyOwner T1
 WHERE T1.PolicyOwnerId=@PolicyOwnerId
  EXEC SpRetrievePolicyOwnerById @PolicyOwnerId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
