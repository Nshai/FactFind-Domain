SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPortfolio]
    @StampUser varchar (255),
    @PortfolioId bigint,
    @StampAction char(1)
AS

INSERT INTO TPortfolioAudit 
( Title, Description, IsPublic, IsGroupRestricted, 
        GroupId, IsIncludeSubGroups, IsReadOnly, IsActive, 
        IsLocked, BenchmarkId, IsClientPortal, AtrPortfolioGuid, 
        CreatedBy, CreatedDate, Client, ConcurrencyId, Code, Provider, ChangeDescription, 
        MarketCommentaryHref, IsPrivate, TenantId, AppId, AllowRebalance,
        PortfolioId, FactSheetLink, TaxQualified, InvestmentManagementStyle,
        PlatformProvider, IsDiscretionaryFundManaged, ChargeRate, ChargeCurrencyCode,
        ChargeVATRule, IsExternallyManaged, IsIMPS, StampAction, StampDateTime, StampUser, RiskReference)
Select Title, Description, IsPublic, IsGroupRestricted, 
        GroupId, IsIncludeSubGroups, IsReadOnly, IsActive, 
        IsLocked, BenchmarkId, IsClientPortal, AtrPortfolioGuid, 
        CreatedBy, CreatedDate, Client, ConcurrencyId, Code, Provider, ChangeDescription, 
        MarketCommentaryHref, IsPrivate, TenantId, AppId, AllowRebalance,
        PortfolioId, FactSheetLink, TaxQualified, InvestmentManagementStyle,
        PlatformProvider, IsDiscretionaryFundManaged, ChargeRate, ChargeCurrencyCode,
        ChargeVATRule, IsExternallyManaged, IsIMPS, @StampAction, GetDate(), @StampUser, RiskReference
FROM TPortfolio
WHERE PortfolioId = @PortfolioId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
