SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditMortgageRisk]
	@StampUser varchar (255),
	@MortgageRiskId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageRiskAudit 
( CRMContactId, riskInterestChange, riskMortgRepaid, riskInvestVehicle, 
		riskCharge, riskOverhang, riskMaxYears, ConcurrencyId, 
		
	MortgageRiskId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, riskInterestChange, riskMortgRepaid, riskInvestVehicle, 
		riskCharge, riskOverhang, riskMaxYears, ConcurrencyId, 
		
	MortgageRiskId, @StampAction, GetDate(), @StampUser
FROM TMortgageRisk
WHERE MortgageRiskId = @MortgageRiskId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
