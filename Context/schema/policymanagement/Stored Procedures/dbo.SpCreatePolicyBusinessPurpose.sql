SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreatePolicyBusinessPurpose]
@StampUser varchar (255),
@PlanPurposeId bigint,
@PolicyBusinessId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @PolicyBusinessPurposeId bigint

  INSERT INTO TPolicyBusinessPurpose (
    PlanPurposeId, 
    PolicyBusinessId, 
    ConcurrencyId ) 
  VALUES (
    @PlanPurposeId, 
    @PolicyBusinessId, 
    1) 

  SELECT @PolicyBusinessPurposeId = SCOPE_IDENTITY()
  INSERT INTO TPolicyBusinessPurposeAudit (
    PlanPurposeId, 
    PolicyBusinessId, 
    ConcurrencyId,
    PolicyBusinessPurposeId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.PlanPurposeId, 
    T1.PolicyBusinessId, 
    T1.ConcurrencyId,
    T1.PolicyBusinessPurposeId,
    'C',
    GetDate(),
    @StampUser

  FROM TPolicyBusinessPurpose T1
 WHERE T1.PolicyBusinessPurposeId=@PolicyBusinessPurposeId
  EXEC SpRetrievePolicyBusinessPurposeById @PolicyBusinessPurposeId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)



GO
