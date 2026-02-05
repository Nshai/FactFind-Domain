SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpUpdateFundProposals]
	@TenantId BIGINT,
	@PolicyBusinessId BIGINT,
	@FundProposalsInJson VARCHAR(MAX),
	@StampUser VARCHAR(255),
	@ModelPortfolioId BIGINT = NULL
AS

SET NOCOUNT ON;

DROP TABLE IF EXISTS #NewFundProposals;

CREATE TABLE #NewFundProposals (
	FundUnitId BIGINT,
	IsFromSeed BIT,
	IsEquity BIT,
	[Percentage] DECIMAL(18, 5),
	RegularContributionPercentage DECIMAL(18, 5)
);

INSERT INTO #NewFundProposals(FundUnitId, IsFromSeed, IsEquity, [Percentage], RegularContributionPercentage)
SELECT FundUnitId, IsFromSeed, COALESCE(IsEquity, 0), [Percentage], RegularContributionPercentage
FROM OPENJSON (@FundProposalsInJson)
WITH (
	FundUnitId BIGINT,
	IsFromSeed BIT,
	IsEquity BIT,
	[Percentage] DECIMAL(18, 5),
	RegularContributionPercentage DECIMAL(18, 5)
);

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX
BEGIN

-- Update TPolicyBusinessExt if ModelPortfolioId is found
IF @ModelPortfolioId IS NOT NULL
BEGIN
	UPDATE policymanagement.dbo.TPolicyBusinessExt
	SET ModelId = @ModelPortfolioId,
		HasModelPortfolio = 1
	WHERE PolicyBusinessId = @PolicyBusinessId;
END

DELETE FP
OUTPUT
	DELETED.FundUnitId,
	DELETED.IsFromSeed,
	DELETED.[Percentage],
	DELETED.RegularContributionPercentage,
	DELETED.PolicyBusinessId,
	DELETED.TenantId,
	DELETED.FundProposalId,
	DELETED.ConcurrencyId,
	'D',
	GETDATE(),
	@StampUser
INTO policymanagement.dbo.TFundProposalAudit(
	FundUnitId,
	IsFromSeed,
	[Percentage],
	RegularContributionPercentage,
	PolicyBusinessId,
	TenantId,
	FundProposalId,
	ConcurrencyId,
	StampAction,
	StampDateTime,
	StampUser
)
FROM policymanagement.dbo.TFundProposal FP
LEFT JOIN #NewFundProposals NFP
	ON FP.FundUnitId = NFP.FundUnitId
	AND FP.IsFromSeed = NFP.IsFromSeed
WHERE FP.PolicyBusinessId = @PolicyBusinessId AND FP.TenantId = @TenantId AND NFP.FundUnitId IS NULL;

UPDATE FP
SET
	[Percentage] = NFP.[Percentage],
	RegularContributionPercentage = NFP.RegularContributionPercentage,
	ConcurrencyId = ConcurrencyId + 1
OUTPUT
	DELETED.FundUnitId,
	DELETED.IsFromSeed,
	DELETED.[Percentage],
	DELETED.RegularContributionPercentage,
	DELETED.PolicyBusinessId,
	DELETED.TenantId,
	DELETED.FundProposalId,
	DELETED.ConcurrencyId,
	'U',
	GETDATE(),
	@StampUser
INTO policymanagement.dbo.TFundProposalAudit(
	FundUnitId,
	IsFromSeed,
	[Percentage],
	RegularContributionPercentage,
	PolicyBusinessId,
	TenantId,
	FundProposalId,
	ConcurrencyId,
	StampAction,
	StampDateTime,
	StampUser
)
FROM policymanagement.dbo.TFundProposal FP
INNER JOIN #NewFundProposals NFP
	ON FP.FundUnitId = NFP.FundUnitId
	AND FP.IsFromSeed = NFP.IsFromSeed
	AND FP.PolicyBusinessId = @PolicyBusinessId
	AND FP.TenantId = @TenantId
WHERE
	FP.[Percentage] <> NFP.[Percentage] OR FP.RegularContributionPercentage <> NFP.RegularContributionPercentage;

INSERT INTO policymanagement.dbo.TFundProposal(
	FundUnitId,
	IsFromSeed,
	[Percentage],
	RegularContributionPercentage,
	IsEquity,
	PolicyBusinessId,
	TenantId,
	ConcurrencyId)
OUTPUT
	INSERTED.FundUnitId,
	INSERTED.IsFromSeed,
	INSERTED.[Percentage],
	INSERTED.RegularContributionPercentage,
	INSERTED.PolicyBusinessId,
	INSERTED.TenantId,
	INSERTED.FundProposalId,
	INSERTED.ConcurrencyId,
	'C',
	GETDATE(),
	@StampUser
INTO policymanagement.dbo.TFundProposalAudit(
	FundUnitId,
	IsFromSeed,
	[Percentage],
	RegularContributionPercentage,
	PolicyBusinessId,
	TenantId,
	FundProposalId,
	ConcurrencyId,
	StampAction,
	StampDateTime,
	StampUser
)
SELECT
	NFP.FundUnitId,
	NFP.IsFromSeed,
	NFP.[Percentage],
	NFP.RegularContributionPercentage,
	NFP.IsEquity,
	@PolicyBusinessId,
	@TenantId,
	1
FROM #NewFundProposals NFP
LEFT JOIN policymanagement.dbo.TFundProposal FP
	ON FP.FundUnitId = NFP.FundUnitId
	AND FP.IsFromSeed = NFP.IsFromSeed
	AND FP.PolicyBusinessId = @PolicyBusinessId
	AND FP.TenantId = @TenantId
WHERE FP.FundUnitId IS NULL;


IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO