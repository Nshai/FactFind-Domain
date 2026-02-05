SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreatePlanValuation]  
@StampUser varchar (255),  
@PolicyBusinessId bigint,  
@PlanValue money = NULL,  
@PlanValueDate datetime = NULL,  
@RefPlanValueTypeId bigint = NULL,  
@WhoUpdatedValue bigint = NULL,  
@WhoUpdatedDateTime datetime = NULL,  
@SurrenderTransferValue money = NULL
AS  
  
SET NOCOUNT ON  
  
DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX  
  
BEGIN  
  
  Declare @PlanValuationId bigint
  
  INSERT INTO TPlanValuation (  
    PolicyBusinessId,   
    PlanValue,   
    PlanValueDate,   
    RefPlanValueTypeId,   
    WhoUpdatedValue,   
    WhoUpdatedDateTime,   
    SurrenderTransferValue,   
    ConcurrencyId )   
  VALUES (  
    @PolicyBusinessId,   
    @PlanValue,   
    @PlanValueDate,   
    @RefPlanValueTypeId,   
    @WhoUpdatedValue,   
    @WhoUpdatedDateTime,   
    @SurrenderTransferValue,   
    1)   
  
  SELECT @PlanValuationId = scope_identity()
  INSERT INTO TPlanValuationAudit (  
    PolicyBusinessId,   
    PlanValue,   
    PlanValueDate,   
    RefPlanValueTypeId,   
    WhoUpdatedValue,   
    WhoUpdatedDateTime,   
    SurrenderTransferValue,   
    ConcurrencyId,  
    PlanValuationId,  
    StampAction,  
    StampDateTime,  
    StampUser)  
  SELECT  
    T1.PolicyBusinessId,   
    T1.PlanValue,   
    T1.PlanValueDate,   
    T1.RefPlanValueTypeId,   
    T1.WhoUpdatedValue,   
    T1.WhoUpdatedDateTime,   
    T1.SurrenderTransferValue,   
    T1.ConcurrencyId,  
    T1.PlanValuationId,  
    'C',  
    GetDate(),  
    @StampUser  
  
  FROM TPlanValuation T1  
 WHERE T1.PlanValuationId=@PlanValuationId  
 
 EXEC SpRetrievePlanValuationById @PlanValuationId  
  
IF @@ERROR != 0 GOTO errh  
IF @tx = 0 COMMIT TRANSACTION TX  
  
END  
RETURN (0)  
  
errh:  
  IF @tx = 0 ROLLBACK TRANSACTION TX  
  RETURN (100)  
GO
