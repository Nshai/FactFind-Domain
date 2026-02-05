SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveFeeModelByFinancialPlanningId] 

@FinancialPlanningId BIGINT

AS

SELECT FinancialPlanningFeeModelForSessionId
      ,FM.FinancialPlanningId
      ,FeeModelId
      ,InitialFeeModelTemplateId
      ,InitialAdviseFeeChargingDetailsId
      ,DiscountId
      ,OngoingFeeModelTemplateId
      ,OngoingAdviseFeeChargingDetailsId

  FROM TFinancialPlanningFeeModelForSession FM
  INNER JOIN TFinancialPlanning FP ON FM.FinancialPlanningId = FP.FinancialPlanningId
  WHERE FM.FinancialPlanningId = @FinancialPlanningId
GO
