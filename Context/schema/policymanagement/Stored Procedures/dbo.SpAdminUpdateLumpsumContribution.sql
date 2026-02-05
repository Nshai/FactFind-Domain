SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpAdminUpdateLumpsumContribution]
AS

BEGIN

DECLARE @StampDateTime DATETIME = GETDATE()

UPDATE PB
SET TotalLumpSum = PMISummary.TotalLumpSum,
	ConcurrencyId = PB.ConcurrencyId + 1
	
	-- Auditing -------------------------------------
    OUTPUT 
        DELETED.[PolicyDetailId]
		,DELETED.[PolicyNumber]
		,DELETED.[PractitionerId]
		,DELETED.[ReplaceNotes]
		,DELETED.[TnCCoachId]
		,DELETED.[AdviceTypeId]
		,DELETED.[BestAdvicePanelUsedFG]
		,DELETED.[WaiverDefermentPeriod]
		,DELETED.[IndigoClientId]
		,DELETED.[SwitchFG]
		,DELETED.[TotalRegularPremium]
		,DELETED.[TotalLumpSum]
		,DELETED.[MaturityDate]
		,DELETED.[LifeCycleId]
		,DELETED.[PolicyStartDate]
		,DELETED.[PremiumType]
		,DELETED.[AgencyNumber]
		,DELETED.[ProviderAddress]
		,DELETED.[OffPanelFg]
		,DELETED.[BaseCurrency]
		,DELETED.[ExpectedPaymentDate]
		,DELETED.[ProductName]
		,DELETED.[InvestmentTypeId]
		,DELETED.[RiskRating]
		,DELETED.[SequentialRef]
		,DELETED.[ConcurrencyId]
		,DELETED.[PolicyBusinessId]
        ,'U'
        ,@StampDateTime
        ,'0'
    INTO [PolicyManagement]..[TPolicyBusinessAudit]
        ([PolicyDetailId]
		,[PolicyNumber]
		,[PractitionerId]
		,[ReplaceNotes]
		,[TnCCoachId]
		,[AdviceTypeId]
		,[BestAdvicePanelUsedFG]
		,[WaiverDefermentPeriod]
		,[IndigoClientId]
		,[SwitchFG]
		,[TotalRegularPremium]
		,[TotalLumpSum]
		,[MaturityDate]
		,[LifeCycleId]
		,[PolicyStartDate]
		,[PremiumType]
		,[AgencyNumber]
		,[ProviderAddress]
		,[OffPanelFg]
		,[BaseCurrency]
		,[ExpectedPaymentDate]
		,[ProductName]
		,[InvestmentTypeId]
		,[RiskRating]
		,[SequentialRef]
		,[ConcurrencyId]
		,[PolicyBusinessId]
        ,[StampAction]
        ,[StampDateTime]
        ,[StampUser])
    -------------------------------------------------
	
FROM PolicyManagement..TPolicyBusiness PB
JOIN
(
	SELECT
	PolicyBusinessId, SUM(Amount) AS TotalLumpSum
	FROM PolicyManagement..TPolicyMoneyIn
	WHERE StartDate <= @StampDateTime AND
			(RefContributionTypeId = 2 OR RefFrequencyId = 10) -- Lumpsum Contribution OR Single Frequency		   
	GROUP BY PolicyBusinessId
) 
PMISummary ON PB.PolicyBusinessId = PMISummary.PolicyBusinessId AND PB.TotalLumpSum != PMISummary.TotalLumpSum

END

GO
