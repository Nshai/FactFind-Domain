SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePolicyExpectedCommissionById]
	@PolicyExpectedCommissionId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.PolicyExpectedCommissionId AS [PolicyExpectedCommission!1!PolicyExpectedCommissionId], 
	T1.PolicyBusinessId AS [PolicyExpectedCommission!1!PolicyBusinessId], 
	T1.RefCommissionTypeId AS [PolicyExpectedCommission!1!RefCommissionTypeId], 
	T1.RefPaymentDueTypeId AS [PolicyExpectedCommission!1!RefPaymentDueTypeId], 
	ISNULL(T1.RefFrequencyId, '') AS [PolicyExpectedCommission!1!RefFrequencyId], 
	ISNULL(T1.ChargingPeriodMonths, '') AS [PolicyExpectedCommission!1!ChargingPeriodMonths], 
	CONVERT(varchar(24), T1.ExpectedAmount) AS [PolicyExpectedCommission!1!ExpectedAmount], 
	ISNULL(CONVERT(varchar(24), T1.ExpectedStartDate, 120), '') AS [PolicyExpectedCommission!1!ExpectedStartDate], 
	T1.ExpectedCommissionType AS [PolicyExpectedCommission!1!ExpectedCommissionType], 
	ISNULL(T1.ParentPolicyExpectedCommissionId, '') AS [PolicyExpectedCommission!1!ParentPolicyExpectedCommissionId], 
	ISNULL(CONVERT(varchar(24), T1.PercentageFund), '') AS [PolicyExpectedCommission!1!PercentageFund], 
	ISNULL(T1.Notes, '') AS [PolicyExpectedCommission!1!Notes], 
	ISNULL(T1.ChangedByUser, '') AS [PolicyExpectedCommission!1!ChangedByUser], 
	ISNULL(CONVERT(varchar(24), T1.PreDiscountAmount), '') AS [PolicyExpectedCommission!1!PreDiscountAmount], 
	ISNULL(T1.DiscountReasonId, '') AS [PolicyExpectedCommission!1!DiscountReasonId], 
	T1.ConcurrencyId AS [PolicyExpectedCommission!1!ConcurrencyId]
	FROM TPolicyExpectedCommission T1
	
	WHERE T1.PolicyExpectedCommissionId = @PolicyExpectedCommissionId
	ORDER BY [PolicyExpectedCommission!1!PolicyExpectedCommissionId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
