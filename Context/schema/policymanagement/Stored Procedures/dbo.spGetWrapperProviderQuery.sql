SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ====================================
-- Description: Gets Wrapper Provider
-- ====================================

CREATE PROCEDURE [dbo].[spGetWrapperProviderQuery]
    @ProviderId INT,
    @RefPlanTypeId INT
AS
BEGIN
    SELECT
        provider.RefProdProviderId AS ProductProviderId,
        provider.Name AS ProductProviderName,
        wrapperprovider.RefPlanTypeId AS RefPlanTypeId,
        planType.PlanTypeName AS RefPlanTypeName,
        wrapperprovider.WrapAllowOtherProvidersFg AS IsWrapAllowOtherProviders,
        wrapperprovider.SippAllowOtherProvidersFg AS IsSippAllowOtherProviders,
        wrapperprovider.SsasAllowOtherProvidersFg AS IsSsasAllowOtherProviders,
        wrapperprovider.OffshoreBondAllowOtherProvidersFg AS IsOffshoreBondAllowOtherProviders,
        wrapperprovider.GroupSippAllowOtherProvidersFg AS IsGroupSippAllowOtherProviders,
        wrapperprovider.QropsAllowOtherProvidersFg AS IsQropsAllowOtherProviders,
        wrapperprovider.FamilySippAllowOtherProvidersFg AS IsFamilySippAllowOtherProviders,
        wrapperprovider.SuperAllowOtherProvidersFg AS IsSuperAllowOtherProviders,
        wrapperprovider.JuniorSIPPAllowOtherProvidersFg AS IsJuniorSIPPAllowOtherProviders,
        wrapperprovider.QnupsAllowOtherProvidersFg AS QnupsAllowOtherProviders,
        wrapperprovider.WrapInvestmentAllowOtherProvidersFg AS WrapInvestmentAllowOtherProviders,
        wrapperprovider.PersonalPensionAllowOtherProvidersFg AS PersonalPensionAllowOtherProviders,
        wrapperprovider.OpenAnnuityAllowOtherProvidersFg AS OpenAnnuityAllowOtherProviders,
        wrapperprovider.IncomeDrawdownAllowOtherProvidersFg AS IncomeDrawdownAllowOtherProviders,
        wrapperprovider.PhasedRetirementAllowOtherProvidersFg AS PhasedRetirementAllowOtherProviders,
        wrapperprovider.RopsAllowOtherProvidersFg AS IsRopsAllowOtherProviders,
        wrapperprovider.InvestmentBondAllowOtherProvidersFg AS IsInvestmentBondAllowOtherProviders,
        wrapperprovider.PensionAllowOtherProvidersFg AS IsPensionAllowOtherProviders,
        wrapperprovider.SuperWrapAllowOtherProvidersFg AS SuperWrapAllowOtherProvidersFg,
        wrapperprovider.SelfManagedSuperFundAllowOtherProvidersFg AS SelfManagedSuperFundAllowOtherProvidersFg
    FROM
        PolicyManagement.dbo.TWrapperProvider wrapperprovider 
        INNER JOIN PolicyManagement.dbo.[VProvider] provider ON provider.RefProdProviderId = wrapperprovider.RefProdProviderId
        INNER JOIN PolicyManagement.dbo.TRefPlanType planType ON planType.RefPlanTypeId = wrapperprovider.RefPlanTypeId 
    WHERE
        wrapperprovider.RefProdProviderId =  @ProviderId
        AND wrapperprovider.RefPlanTypeId = @RefPlanTypeId

    SELECT
        wrapperPlanType.RefPlanType2ProdSubTypeId AS PlanTypeId
    FROM
        PolicyManagement.dbo.TWrapperProvider wrapperprovider 
        INNER JOIN PolicyManagement.dbo.TWrapperPlanType wrapperPlanType ON wrapperPlanType.WrapperProviderId = wrapperprovider.WrapperProviderId 
    WHERE
        wrapperprovider.RefProdProviderId =  @ProviderId
        AND wrapperprovider.RefPlanTypeId = @RefPlanTypeId
END
GO