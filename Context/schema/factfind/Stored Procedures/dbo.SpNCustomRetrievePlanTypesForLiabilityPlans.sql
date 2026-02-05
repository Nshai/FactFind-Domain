SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrievePlanTypesForLiabilityPlans]
    @IndigoClientId bigint = null,
    @RegionCode varchar(2)
AS 
    DECLARE @MortgageDiscriminator VARCHAR(100) = 'MortgagePlan'
    DECLARE @EquityReleaseDiscriminator VARCHAR(100) = 'EquityReleasePlan'
    DECLARE @LoanCreditDiscriminator VARCHAR(100) = 'LoanCreditPlan'
    DECLARE @Select VARCHAR(100) = 'Select...'

    SELECT TAG, Parent, [LiabilityPlanType!1!LiabilityPlanTypeId], [LiabilityPlanType!1!LiabilityPlanTypeName], [LiabilityPlanType!1!PlanDiscriminatorName] 
    FROM (SELECT 1 AS TAG, 
        NULL AS Parent, 
        NULL AS [LiabilityPlanType!1!LiabilityPlanTypeId], 
        @Select AS [LiabilityPlanType!1!LiabilityPlanTypeName],
        NULL AS [LiabilityPlanType!1!PlanDiscriminatorName]
    UNION
    SELECT 1 AS TAG,  
        NULL AS Parent,  
        vrpt.RefPlanType2ProdSubTypeId  AS [LiabilityPlanType!1!LiabilityPlanTypeId],
        vrpt.RefPlanType2ProdSubTypeName AS [LiabilityPlanType!1!LiabilityPlanTypeName],
        vrpt.PlanDiscriminatorName AS [LiabilityPlanType!1!PlanDiscriminatorName]
    FROM [policymanagement].[dbo].[VRefPlanType2ProdSubType] vrpt
    WHERE 
    vrpt.PlanDiscriminatorName IN (@MortgageDiscriminator, @EquityReleaseDiscriminator, @LoanCreditDiscriminator)
        AND vrpt.IsArchived = 0
        AND vrpt.RegionCode = @RegionCode
        AND vrpt.PlanTypeName <> 'Conveyancing Servicing Plan') x
    ORDER BY 
        CASE WHEN [LiabilityPlanType!1!PlanDiscriminatorName] IS NULL THEN 1
        WHEN [LiabilityPlanType!1!PlanDiscriminatorName] = @MortgageDiscriminator THEN 3 
        ELSE 2 END,
        [LiabilityPlanType!1!LiabilityPlanTypeName]
FOR XML EXPLICIT
GO
