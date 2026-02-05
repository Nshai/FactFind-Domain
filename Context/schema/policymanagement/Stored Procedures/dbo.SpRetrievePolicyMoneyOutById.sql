SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePolicyMoneyOutById]
@PolicyMoneyOutId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.PolicyMoneyOutId AS [PolicyMoneyOut!1!PolicyMoneyOutId], 
    ISNULL(T1.PolicyOwnerId, '') AS [PolicyMoneyOut!1!PolicyOwnerId], 
    T1.PolicyBusinessId AS [PolicyMoneyOut!1!PolicyBusinessId], 
    ISNULL(T1.BeneficiaryCRMContactId, '') AS [PolicyMoneyOut!1!BeneficiaryCRMContactId], 
    ISNULL(CONVERT(varchar(24), T1.BeneficiaryPercentage), '') AS [PolicyMoneyOut!1!BeneficiaryPercentage], 
    ISNULL(CONVERT(varchar(24), T1.Amount), '') AS [PolicyMoneyOut!1!Amount], 
    ISNULL(T1.RefBenefitPaymentTypeId, '') AS [PolicyMoneyOut!1!RefBenefitPaymentTypeId], 
    ISNULL(T1.SalaryMultiple, '') AS [PolicyMoneyOut!1!SalaryMultiple], 
    ISNULL(T1.RefRiskEventTypeId, '') AS [PolicyMoneyOut!1!RefRiskEventTypeId], 
    ISNULL(CONVERT(varchar(24), T1.PaymentStartDate, 120),'') AS [PolicyMoneyOut!1!PaymentStartDate], 
    ISNULL(CONVERT(varchar(24), T1.PaymentStopDate, 120),'') AS [PolicyMoneyOut!1!PaymentStopDate], 
    ISNULL(T1.RefFrequencyId, '') AS [PolicyMoneyOut!1!RefFrequencyId], 
    ISNULL(T1.RefIndexationTypeId, '') AS [PolicyMoneyOut!1!RefIndexationTypeId], 
    ISNULL(CONVERT(varchar(24), T1.EscalationPercentage), '') AS [PolicyMoneyOut!1!EscalationPercentage], 
    ISNULL(T1.AssuredCRMContactId1, '') AS [PolicyMoneyOut!1!AssuredCRMContactId1], 
    ISNULL(T1.AssuredCRMContactId2, '') AS [PolicyMoneyOut!1!AssuredCRMContactId2], 
    ISNULL(T1.DeferredWeeks, '') AS [PolicyMoneyOut!1!DeferredWeeks], 
    ISNULL(T1.AssignedCRMContactId, '') AS [PolicyMoneyOut!1!AssignedCRMContactId], 
    ISNULL(T1.RefPaymentBasisTypeId, '') AS [PolicyMoneyOut!1!RefPaymentBasisTypeId], 
    ISNULL(CONVERT(varchar(24), T1.PaymentBasisPercentage), '') AS [PolicyMoneyOut!1!PaymentBasisPercentage], 
    ISNULL(T1.GuaranteedPeriodMonths, '') AS [PolicyMoneyOut!1!GuaranteedPeriodMonths], 
    ISNULL(T1.RefWithdrawalBasisTypeId, '') AS [PolicyMoneyOut!1!RefWithdrawalBasisTypeId], 
    ISNULL(T1.RefWithdrawalTypeId, '') AS [PolicyMoneyOut!1!RefWithdrawalTypeId], 
    ISNULL(T1.RefEscalationTypeId, '') AS [PolicyMoneyOut!1!RefEscalationTypeId], 
    T1.ConcurrencyId AS [PolicyMoneyOut!1!ConcurrencyId]
  FROM TPolicyMoneyOut T1

  WHERE (T1.PolicyMoneyOutId = @PolicyMoneyOutId)

  ORDER BY [PolicyMoneyOut!1!PolicyMoneyOutId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
