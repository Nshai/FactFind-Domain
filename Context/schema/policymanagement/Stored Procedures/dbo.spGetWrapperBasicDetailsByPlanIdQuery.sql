SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================
-- Description: Gets Wrapper basic details
-- =========================================

CREATE PROCEDURE [dbo].[spGetWrapperBasicDetailsByPlanIdQuery]
    @PlanId INT,
    @TenantId INT
AS
BEGIN
    SELECT
        pt2pst.RefPlanType2ProdSubTypeId,
        pt2pst.RefPlanTypeId,
        pt2pst.ProdSubTypeId,
        provider.RefProdProviderId,
        provider.Name,
        wrapperprovider.WrapAllowOtherProvidersFg AS WrapAllowOtherProviders,
        wrapperprovider.SippAllowOtherProvidersFg AS SippAllowOtherProviders,
        wrapperprovider.SsasAllowOtherProvidersFg AS SsasAllowOtherProviders,
        wrapperprovider.OffshoreBondAllowOtherProvidersFg AS OffshoreBondAllowOtherProviders,
        wrapperprovider.GroupSippAllowOtherProvidersFg AS GroupSippAllowOtherProviders,
        wrapperprovider.QropsAllowOtherProvidersFg AS QropsAllowOtherProviders,
        wrapperprovider.FamilySippAllowOtherProvidersFg AS FamilySippAllowOtherProviders,
        wrapperprovider.SuperAllowOtherProvidersFg AS SuperAllowOtherProviders,
        wrapperprovider.QnupsAllowOtherProvidersFg AS QnupsAllowOtherProviders,
        wrapperprovider.JuniorSIPPAllowOtherProvidersFg AS JuniorSIPPAllowOtherProviders,
        wrapperprovider.OpenAnnuityAllowOtherProvidersFg AS OpenAnnuityAllowOtherProviders,
        wrapperprovider.PersonalPensionAllowOtherProvidersFg AS PersonalPensionAllowOtherProviders,
        wrapperprovider.WrapInvestmentAllowOtherProvidersFg AS WrapInvestmentAllowOtherProviders,
        wrapperprovider.IncomeDrawdownAllowOtherProvidersFg AS IncomeDrawdownAllowOtherProviders,
        wrapperprovider.PhasedRetirementAllowOtherProvidersFg AS PhasedRetirementAllowOtherProviders,
        wrapperprovider.RopsAllowOtherProvidersFg AS RopsAllowOtherProviders,
        wrapperprovider.InvestmentBondAllowOtherProvidersFg AS InvestmentBondAllowOtherProviders,
        wrapperprovider.PensionAllowOtherProvidersFg AS PensionAllowOtherProviders,
        wrapperprovider.SuperWrapAllowOtherProvidersFg AS SuperWrapAllowOtherProvidersFg,
        wrapperprovider.SelfManagedSuperFundAllowOtherProvidersFg AS SelfManagedSuperFundAllowOtherProvidersFg
    FROM
        PolicyManagement.dbo.TPolicyBusiness policy
        INNER JOIN PolicyManagement.dbo.[TPolicyDetail] policydetail ON policy.PolicyDetailId = policydetail.PolicyDetailId
        INNER JOIN PolicyManagement.dbo.[TPlanDescription] plandescription ON policydetail.PlanDescriptionId = plandescription.PlanDescriptionId
        INNER JOIN PolicyManagement.dbo.TRefPlanType2ProdSubType pt2pst ON plandescription.RefPlanType2ProdSubTypeId = pt2pst.RefPlanType2ProdSubTypeId
        INNER JOIN PolicyManagement.dbo.[VProvider] provider ON plandescription.RefProdProviderId = provider.RefProdProviderId
        INNER JOIN PolicyManagement.dbo.TWrapperProvider wrapperprovider ON provider.RefProdProviderId = wrapperprovider.RefProdProviderId
    WHERE
        policy.PolicyBusinessId = @PlanId
        AND policy.IndigoClientId = @TenantId
        AND wrapperprovider.RefPlanTypeId = pt2pst.RefPlanTypeId
END
GO
