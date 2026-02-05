SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveFeeModelByActionPlanId] 

@ActionPlanId BIGINT

AS

SELECT ActionPlanFeeModelId
      , FA.ActionPlanId
      ,FeeModelId
      ,InitialFeeModelTemplateId
      ,InitialAdviseFeeChargingDetailsId
      ,DiscountId
      ,OngoingFeeModelTemplateId
      ,OngoingAdviseFeeChargingDetailsId

  FROM TActionPlanFeeModel FA
  INNER JOIN TActionPlan AP ON AP.ActionPlanId = FA.ActionPlanId
  WHERE  FA.ActionPlanId = @ActionPlanId
GO
