SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpGetIncomeExpenditureTotalsQuery]	
	@CRMContactId bigint,
	@RegionalCurrency VARCHAR(3)
AS

SET NOCOUNT ON

DECLARE @Today date = CAST(GETUTCDATE() AS date),
		@Annually varchar(50) = 'Annually'

IF OBJECT_ID('tempdb.dbo.#PlanInForce') IS NOT NULL
	DROP TABLE #PlanInForce

CREATE TABLE #PlanInForce (PolicyBusinessId BIGINT, BaseCurrency VARCHAR(3))
INSERT INTO 
	#PlanInForce
SELECT 
	pb.PolicyBusinessId,	pb.BaseCurrency
FROM 	PolicyManagement.dbo.TPolicyBusiness pb 
INNER JOIN PolicyManagement.dbo.TStatusHistory pbStatus  ON pb.PolicyBusinessId=pbStatus.PolicyBusinessId  AND pbStatus.CurrentStatusFG =1
INNER JOIN  PolicyManagement.dbo.TStatus st ON pbStatus.StatusId=st.StatusId AND st.[Name] ='In force'
INNER JOIN PolicyManagement.dbo.TPolicyOwner own ON own.PolicyDetailId=pb.PolicyDetailId AND own.CRMContactId=@CRMContactId


IF OBJECT_ID('tempdb.dbo.#Rate') IS NOT NULL
	DROP TABLE #Rate

CREATE TABLE #Rate (SourceCurrency VARCHAR(3) PRIMARY KEY, ExRate DECIMAL(18,10))
INSERT INTO 
	#Rate
SELECT 
	T.BaseCurrency,
	ISNULL(policymanagement.dbo.FnGetCurrencyRate(T.BaseCurrency, @RegionalCurrency),1.0)
FROM( SELECT DISTINCT BaseCurrency  FROM #PlanInForce  ) as T


DECLARE @TotalAnnualIncome MONEY
SELECT  @TotalAnnualIncome =SUM(Amount)
FROM 
(
	SELECT
		policymanagement.dbo.FnConvertFrequency(@Annually,Frequency,NetAmount) as Amount
	FROM FactFind.dbo.TDetailedIncomeBreakdown 
	WHERE (CRMContactId = @CRMContactId OR CRMContactId2 = @CRMContactId) AND 
		(StartDate is NULL OR StartDate<= @Today)  AND
		(EndDate is NULL OR EndDate>= @Today) 
   UNION ALL
	SELECT 	
		policymanagement.dbo.FnConvertFrequency(@Annually,FrequencyName,Amount * rate.ExRate) as Amount
	FROM PolicyManagement.dbo.TPolicyMoneyOut withdrawal
	INNER JOIN  #PlanInForce pb ON pb.PolicyBusinessId=withdrawal.PolicyBusinessId
	INNER JOIN  PolicyManagement.dbo.TRefFrequency fr ON withdrawal.RefFrequencyId=fr.RefFrequencyId AND fr.FrequencyName!='Single'
	INNER JOIN #Rate rate ON rate.SourceCurrency=pb.BaseCurrency
	WHERE  (withdrawal.PaymentStartDate IS NULL OR withdrawal.PaymentStartDate <=@Today) AND(withdrawal.PaymentStopDate IS NULL OR withdrawal.PaymentStopDate >=@Today)
) as T

DECLARE @TotalAnnualExpenditure MONEY
SELECT @TotalAnnualExpenditure=SUM(Amount)
FROM 
(
	SELECT
		policymanagement.dbo.FnConvertFrequency(@Annually,Frequency,NetAmount) as Amount
	FROM FactFind.dbo.TExpenditureDetail 
	WHERE (CRMContactId = @CRMContactId OR CRMContactId2 = @CRMContactId) 
   UNION ALL
	SELECT 	
		policymanagement.dbo.FnConvertFrequency(@Annually,FrequencyName,Amount * rate.ExRate) as Amount
	FROM PolicyManagement.dbo.TPolicyMoneyIn contr
	INNER JOIN  #PlanInForce pb ON pb.PolicyBusinessId=contr.PolicyBusinessId
	INNER JOIN  PolicyManagement.dbo.TRefFrequency fr ON contr.RefFrequencyId=fr.RefFrequencyId AND fr.FrequencyName!='Single'
	INNER JOIN  PolicyManagement.dbo.TRefContributionType contrType ON contr.RefContributionTypeId=contrType.RefContributionTypeId AND contrType.RefContributionTypeName='Regular'
	INNER JOIN  PolicyManagement.dbo.TRefContributorType contributorType ON contr.RefContributorTypeId=contributorType.RefContributorTypeId AND contributorType.RefContributorTypeName='Self'
	INNER JOIN #Rate rate ON rate.SourceCurrency=pb.BaseCurrency
	WHERE  (contr.StartDate IS NULL OR contr.StartDate <=@Today ) AND (contr.StopDate IS NULL OR contr.StopDate >=@Today) 
) as T

SELECT @TotalAnnualIncome as TotalAnnualIncome,@TotalAnnualExpenditure as TotalAnnualExpenditure

DROP TABLE #Rate
DROP TABLE #PlanInForce
GO
