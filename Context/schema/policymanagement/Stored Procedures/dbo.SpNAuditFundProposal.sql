SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditFundProposal]
	@StampUser varchar (255),
	@FundProposalId bigint,
	@StampAction char(1)
AS

INSERT INTO TFundProposalAudit 
( PolicyBusinessId, FundUnitId, IsFromSeed, Percentage, 
		TenantId, ConcurrencyId, RegularContributionPercentage,
	FundProposalId, StampAction, StampDateTime, StampUser) 
Select PolicyBusinessId, FundUnitId, IsFromSeed, Percentage, 
		TenantId, ConcurrencyId, RegularContributionPercentage,
	FundProposalId, @StampAction, GetDate(), @StampUser
FROM TFundProposal WITH (NOLOCK)
WHERE FundProposalId = @FundProposalId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
