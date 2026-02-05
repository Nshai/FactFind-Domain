CREATE PROCEDURE [dbo].[SpNCustomRetrieveMortgagePreferences]
(
	@CRMContactId BIGINT,
	@CRMContactId2 BIGINT = NULL,
	@TenantId BIGINT
)
As
BEGIN
	DECLARE @IsContact2MainClient BIT = 0

	SELECT @IsContact2MainClient = 1
	WHERE EXISTS(
		SELECT * FROM factfind..TFactFind
		WHERE IndigoClientId = @TenantID
		AND CRMContactId1 = @CRMContactId2
		AND CRMContactId2 = @CRMContactId)

	SELECT
		c.CRMContactId,
		risk.RiskMortgRepaid,
		risk.RiskInvestVehicle,
		pref.RedeemFg,
		pref.LikelyToMove,
		pref.ExpectedMoveDate,
		pref.AvoidUncertainty,
		pref.MinPaymEarly,
		risk.RiskMaxYears,
		pref.VaryNoPenalty,
		pref.LinkToAccount,
		pref.AddFeeFg,
		pref.ClubFeeMortgageAdvance,
		pref.FreeLegalFees,
		pref.NoValFee,
		pref.BookingFeeFg,
		pref.Cashback,
		risk.RiskInterestChange,
		risk.RiskCharge,
		risk.RiskOverhang,
		pref.HighLendingCharge,
		pref.DailyInterestRates,
		risknotes.RiskComment
	FROM crm..TCRMContact c
	LEFT JOIN FactFind.dbo.TMortgagePreferences pref ON c.CRMContactId = pref.CRMContactId
	LEFT JOIN FactFind.dbo.TMortgageRisk risk ON c.CRMContactId = risk.CRMContactId
	LEFT JOIN FactFind.dbo.TMortgageRiskNotes risknotes ON c.CRMContactId = risknotes.CRMContactId
	WHERE c.IndClientId = @TenantId
	AND c.CRMContactId = CASE @IsContact2MainClient WHEN 1 THEN @CRMContactId2 ELSE @CRMContactId END

END
