SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPolicyBusinessExt]
    @StampUser varchar (255),
    @PolicyBusinessExtId bigint,
    @StampAction char(1)
AS

INSERT INTO TPolicyBusinessExtAudit
(
    PolicyBusinessId,
    BandingTemplateId,
    MigrationRef,
    PortalReference,
    PlatformReference,
    ReportNotes,
    AnnualCharges,
    WrapperCharge,
    InitialAdviceCharge,
    OngoingAdviceCharge,
    PensionIncrease,
    ReservedValue,
    ConcurrencyId,
    QuoteResultId,
    ApplicationReference,
    MortgageRepayPercentage,
    MortgageRepayAmount,
    PolicyBusinessExtId,
    StampAction,
    StampDateTime,
    StampUser,
    IsLendersSolicitorsUsed,
    SystemPortalReference,
    FundIncome,
    IsVisibleToClient,
    IsVisibilityUpdatedByStatusChange,
    hasdfm,
    HasModelPortfolio,
    AgencyStatus,
    AgencyStatusDate,
    AdditionalNotes,
    [InterestRate],
    [IsPlanValueVisibleToClient],
    IsTargetMarket,
    TargetMarketExplanation,
	[ModelId],
    ForwardIncomeToAdviserId,
	ForwardIncomeToUseAdviserBanding,
	SortCode,
	WhoCreatedUserId,
	IsProviderManaged,
	DocumentDeliveryMethod,
    CreatedAt,
    QuoteId
)
SELECT
    PolicyBusinessId,
    BandingTemplateId,
    MigrationRef,
    PortalReference,
    PlatformReference,
    ReportNotes,
    AnnualCharges,
    WrapperCharge,
    InitialAdviceCharge,
    OngoingAdviceCharge,
    PensionIncrease,
    ReservedValue,
    ConcurrencyId,
    QuoteResultId,
    ApplicationReference,
    MortgageRepayPercentage,
    MortgageRepayAmount,
    PolicyBusinessExtId,
    @StampAction,
    GETDATE(),
    @StampUser,
    IsLendersSolicitorsUsed,
    SystemPortalReference,
    FundIncome,
    IsVisibleToClient,
    IsVisibilityUpdatedByStatusChange,
    HasDfm,
    HasModelportfolio,
    AgencyStatus,
    AgencyStatusDate,
    AdditionalNotes,
    [InterestRate],
    [IsPlanValueVisibleToClient],
    IsTargetMarket,
    TargetMarketExplanation,
	[ModelId],
	ForwardIncomeToAdviserId,
	ForwardIncomeToUseAdviserBanding,
	SortCode,
	WhoCreatedUserId,
	IsProviderManaged,
	DocumentDeliveryMethod,
    CreatedAt,
    QuoteId
FROM TPolicyBusinessExt
WHERE PolicyBusinessExtId = @PolicyBusinessExtId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
