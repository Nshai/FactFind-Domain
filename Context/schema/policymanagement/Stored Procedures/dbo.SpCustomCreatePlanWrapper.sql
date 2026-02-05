SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCreatePlanWrapper] @StampUser varchar (255), @RefPlanType2ProdSubTypeId bigint, @RefProdProviderId bigint,@IndigoClientId bigint, @CRMContactId bigint
AS
/** lets create the plan Description First  **/

  DECLARE @PlanDescriptionId bigint

  INSERT INTO TPlanDescription (
    RefPlanType2ProdSubTypeId, 
    RefProdProviderId, 
    ConcurrencyId ) 
  VALUES (
    @RefPlanType2ProdSubTypeId, 
    @RefProdProviderId, 
    1) 

  SELECT @PlanDescriptionId = SCOPE_IDENTITY()

  INSERT INTO TPlanDescriptionAudit (
    RefPlanType2ProdSubTypeId, 
    RefProdProviderId, 
    ConcurrencyId,
    PlanDescriptionId,
    StampAction,
    StampDateTime,
    StampUser)
  VALUES (
    @RefPlanType2ProdSubTypeId, 
    @RefProdProviderId, 
    1,
    @PlanDescriptionId,
    'C',
    GetDate(),
    @StampUser)

/** lets create the poicy detail First  **/


  DECLARE @PolicyDetailId bigint

  INSERT INTO TPolicyDetail (
    PlanDescriptionId, 
    IndigoClientId, 
    ConcurrencyId ) 
  VALUES (
    @PlanDescriptionId, 
    @IndigoClientId, 
    1) 

  SELECT @PolicyDetailId = SCOPE_IDENTITY()

  INSERT INTO TPolicyDetailAudit (
    PlanDescriptionId, 
    IndigoClientId, 
    ConcurrencyId,
    PolicyDetailId,
    StampAction,
    StampDateTime,
    StampUser)
  VALUES (
    @PlanDescriptionId, 
    @IndigoClientId, 
    1,
    @PolicyDetailId,
    'C',
    GetDate(),
    @StampUser
    )


/** lets create policy owner */


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
  VALUES (
    @CRMContactId, 
    @PolicyDetailId, 
    1,
    @PolicyOwnerId,
    'C',
    GetDate(),
    @StampUser
    )

	/*** Return a record ***/

    EXEC SpRetrievePolicyDetailById @PolicyDetailId



GO
