SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditFeeContributionBreakup]
	@StampUser varchar (255),
	@FeeContributionBreakupId bigint,
	@StampAction char(1)
AS

INSERT INTO TFeeContributionBreakupAudit 
( FeeId, PolicyBusinessId, NetAmount, DiscountAmount, 
		VATAmount, TotalRegularContribution, TotalLumpsumContribution, TotalFeeAmount, 
		DateOnFeeCalculated, TenantId, ConcurrencyId, 
	FeeContributionBreakupId, StampAction, StampDateTime, StampUser) 
Select FeeId, PolicyBusinessId, NetAmount, DiscountAmount, 
		VATAmount, TotalRegularContribution, TotalLumpsumContribution, TotalFeeAmount, 
		DateOnFeeCalculated, TenantId, ConcurrencyId, 
	FeeContributionBreakupId, @StampAction, GetDate(), @StampUser
FROM TFeeContributionBreakup
WHERE FeeContributionBreakupId = @FeeContributionBreakupId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
