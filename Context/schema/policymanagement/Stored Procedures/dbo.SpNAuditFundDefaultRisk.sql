SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFundDefaultRisk]
	@StampUser varchar (255),
	@FundDefaultRiskId bigint,
	@StampAction char(1)
AS

INSERT INTO TFundDefaultRiskAudit 
( FundId, RefFundTypeId, FromFeedFg, IndigoClientId, 
		RiskLockedFg, RiskProfileId, InvestmentTypeId, ConcurrencyId, 
		
	FundDefaultRiskId, StampAction, StampDateTime, StampUser) 
Select FundId, RefFundTypeId, FromFeedFg, IndigoClientId, 
		RiskLockedFg, RiskProfileId, InvestmentTypeId, ConcurrencyId, 
		
	FundDefaultRiskId, @StampAction, GetDate(), @StampUser
FROM TFundDefaultRisk
WHERE FundDefaultRiskId = @FundDefaultRiskId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
