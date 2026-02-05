SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpDeleteValuations]
  @PolicyBusinessId INT,
  @ValuationIds VARCHAR(MAX),
  @StampUser VARCHAR(255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DELETE PV
  OUTPUT
    DELETED.ConcurrencyId,
    DELETED.PlanValuationId,
    DELETED.PlanValue,
    DELETED.PlanValueDate,
    DELETED.PolicyBusinessId,
    DELETED.RefPlanValueTypeId,
    'D',
    GETUTCDATE(),
    @StampUser,
    DELETED.SurrenderTransferValue,
    DELETED.ValuationMigrationRef,
    DELETED.WhoUpdatedDateTime,
    DELETED.WhoUpdatedValue
  INTO PolicyManagement.dbo.TPlanValuationAudit(
    ConcurrencyId,
    PlanValuationId,
    PlanValue,
    PlanValueDate,
    PolicyBusinessId,
    RefPlanValueTypeId,
    StampAction,
    StampDateTime,
    StampUser,
    SurrenderTransferValue,
    ValuationMigrationRef,
    WhoUpdatedDateTime,
    WhoUpdatedValue
  )
  FROM PolicyManagement.dbo.TPlanValuation PV
  INNER JOIN policymanagement.dbo.FnSplit(@ValuationIds, ',') VI ON PV.PlanValuationId = VI.Value
  WHERE PV.PolicyBusinessId = @PolicyBusinessId;

  IF @@ERROR != 0 GOTO errh
  IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
