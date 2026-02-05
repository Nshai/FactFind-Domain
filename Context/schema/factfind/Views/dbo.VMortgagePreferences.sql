SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VMortgagePreferences]
AS
SELECT     
	MP.MortgagePreferencesId, 
	MP.CRMContactId, 	
	MP.redeemFg,
	MP.avoidUncertainty,	
	MP.minPaymEarly,		
	MP.addFeeFg,	
	MP.varyNoPenalty,			
	MP.linkToAccount,
	MP.freeLegalFees,
	MP.noValFee,	
	MP.bookingFeeFg,
	MP.cashback,											
	MP.ConcurrencyId,
	MP.LikelyToMove,
	MP.ExpectedMoveDate,
	MP.HighLendingCharge,
	MP.DailyInterestRates,
	MP.ClubFeeMortgageAdvance,
	MPN.notes,
	MR.riskMortgRepaid,
	MR.riskInvestVehicle,
	MR.riskInterestChange,
	MR.riskCharge,
	MR.riskOverhang,
	MR.riskMaxYears
FROM
	dbo.TMortgagePreferences AS MP 
	LEFT OUTER JOIN FactFind.dbo.TMortgagePrefNotes MPN ON MP.CRMContactId= MPN.CRMContactId
	LEFT OUTER JOIN FactFind.dbo.TMortgageRisk MR ON MP.CRMContactId=MR.CRMContactId

 
GO
