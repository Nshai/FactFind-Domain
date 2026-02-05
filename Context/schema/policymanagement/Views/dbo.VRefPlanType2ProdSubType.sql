CREATE VIEW VRefPlanType2ProdSubType 
AS

SELECT
    plan2ProdType.RefPlanType2ProdSubTypeId,
    (CASE WHEN prodType.ProdSubTypeName IS NOT NULL THEN CONCAT(planType.PlanTypeName, ' (', prodType.ProdSubTypeName,')') ELSE planType.PlanTypeName END) as RefPlanType2ProdSubTypeName,
    category.PortfolioCategoryName,
    category.PortfolioCategoryDisplayText,
    discriminator.PlanDiscriminatorName,
    planType.PlanTypeName,
    prodType.ProdSubTypeName,
    plan2ProdType.RefPlanTypeId,
    plan2ProdType.ProdSubTypeId,
    plan2ProdType.RefPortfolioCategoryId,
    plan2ProdType.RefPlanDiscriminatorId,
    plan2ProdType.IsArchived,
    plan2ProdType.IsConsumerFriendly,
	plan2ProdType.RegionCode,
	planType.IsWrapperFg,
	planType.IsTaxQualifying
FROM
    dbo.TRefPlanType2ProdSubType AS plan2ProdType
    LEFT OUTER JOIN dbo.TRefPlanType AS planType
        ON plan2ProdType.RefPlanTypeId = planType .RefPlanTypeId
    LEFT OUTER JOIN dbo.TProdSubType AS prodType
        ON plan2ProdType.ProdSubTypeId = prodType .ProdSubTypeId
    LEFT OUTER JOIN dbo.TRefPortfolioCategory AS category
        ON plan2ProdType.RefPortfolioCategoryId = category.RefPortfolioCategoryId
    LEFT OUTER JOIN dbo.TRefPlanDiscriminator AS discriminator
        ON plan2ProdType.RefPlanDiscriminatorId = discriminator.RefPlanDiscriminatorId
