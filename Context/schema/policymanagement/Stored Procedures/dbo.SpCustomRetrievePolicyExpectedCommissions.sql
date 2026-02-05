SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrievePolicyExpectedCommissions]
	@PolicyBusinessId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.PolicyBusinessId AS [PolicyBusiness!1!PolicyBusinessId], 
    T1.PolicyDetailId AS [PolicyBusiness!1!PolicyDetailId], 
    ISNULL(T1.PolicyNumber, '') AS [PolicyBusiness!1!PolicyNumber], 
    T1.PractitionerId AS [PolicyBusiness!1!PractitionerId], 
    ISNULL(T1.ReplaceNotes, '') AS [PolicyBusiness!1!ReplaceNotes], 
    ISNULL(T1.TnCCoachId, '') AS [PolicyBusiness!1!TnCCoachId], 
    T1.AdviceTypeId AS [PolicyBusiness!1!AdviceTypeId], 
    T1.BestAdvicePanelUsedFG AS [PolicyBusiness!1!BestAdvicePanelUsedFG], 
    T1.WaiverDefermentPeriod AS [PolicyBusiness!1!WaiverDefermentPeriod], 
    T1.IndigoClientId AS [PolicyBusiness!1!IndigoClientId], 
    T1.SwitchFG AS [PolicyBusiness!1!SwitchFG], 
    ISNULL(CONVERT(varchar(12), T1.TotalRegularPremium), '') AS [PolicyBusiness!1!TotalRegularPremium], 
    ISNULL(CONVERT(varchar(12), T1.TotalLumpSum), '') AS [PolicyBusiness!1!TotalLumpSum], 
    T1.ConcurrencyId AS [PolicyBusiness!1!ConcurrencyId],
    NULL AS [PolicyExpectedCommission!2!PolicyExpectedCommissionId], 
    NULL AS [PolicyExpectedCommission!2!PolicyBusinessId], 
    NULL AS [PolicyExpectedCommission!2!RefCommissionTypeId], 
    NULL AS [PolicyExpectedCommission!2!RefPaymentDueTypeId], 
    NULL AS [PolicyExpectedCommission!2!RefFrequencyId], 
    NULL AS [PolicyExpectedCommission!2!ChargingPeriodMonths], 
    NULL AS [PolicyExpectedCommission!2!ExpectedAmount], 
    NULL AS [PolicyExpectedCommission!2!ExpectedStartDate], 
    NULL AS [PolicyExpectedCommission!2!ExpectedCommissionType], 
    NULL AS [PolicyExpectedCommission!2!ParentPolicyExpectedCommissionId], 
    NULL AS [PolicyExpectedCommission!2!PreDiscountAmount], 
	NULL AS [PolicyExpectedCommission!2!DiscountReasonId], 
	NULL AS [PolicyExpectedCommission!2!DiscountReason], 
    NULL AS [PolicyExpectedCommission!2!ConcurrencyId], 
    NULL AS [RefFrequency!3!RefFrequencyId], 
    NULL AS [RefFrequency!3!FrequencyName], 
    NULL AS [RefFrequency!3!OrigoRef], 
    NULL AS [RefFrequency!3!RetireFg], 
    NULL AS [RefFrequency!3!ConcurrencyId], 
    NULL AS [RefCommissionType!4!RefCommissionTypeId], 
    NULL AS [RefCommissionType!4!CommissionTypeName], 
    NULL AS [RefCommissionType!4!OrigoRef], 
    NULL AS [RefCommissionType!4!InitialCommissionFg], 
    NULL AS [RefCommissionType!4!RecurringCommissionFg], 
    NULL AS [RefCommissionType!4!RetireFg], 
    NULL AS [RefCommissionType!4!ConcurrencyId], 
    NULL AS [RefPaymentDueType!5!RefPaymentDueTypeId], 
    NULL AS [RefPaymentDueType!5!PaymentDueType], 
    NULL AS [RefPaymentDueType!5!RetireFg], 
    NULL AS [RefPaymentDueType!5!ConcurrencyId]
  FROM TPolicyBusiness T1
  -- Note clause
/*
  LEFT JOIN 
      (SELECT
          PolicyBusinessId,
          Note
      FROM TPolicyBusinessNote T1
      WHERE T1.PolicyBusinessNoteId = 
          (SELECT MAX(PolicyBusinessNoteId) FROM TPolicyBusinessNote
           WHERE PolicyBusinessId = @PolicyBusinessId)) AS TNote
  ON TNote.PolicyBusinessId = T1.PolicyBusinessId
*/
  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)
  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.PolicyBusinessId, 
    T1.PolicyDetailId, 
    ISNULL(T1.PolicyNumber, ''), 
    T1.PractitionerId, 
    ISNULL(T1.ReplaceNotes, ''), 
    ISNULL(T1.TnCCoachId, ''), 
    T1.AdviceTypeId, 
    T1.BestAdvicePanelUsedFG, 
    T1.WaiverDefermentPeriod, 
    T1.IndigoClientId, 
    T1.SwitchFG, 
    ISNULL(CONVERT(varchar(12), T1.TotalRegularPremium), ''), 
    ISNULL(CONVERT(varchar(12), T1.TotalLumpSum), ''), 
    T1.ConcurrencyId, 
--    NULL,
    T2.PolicyExpectedCommissionId, 
    T2.PolicyBusinessId, 
    T2.RefCommissionTypeId, 
    T2.RefPaymentDueTypeId, 
    ISNULL(T2.RefFrequencyId, ''), 
    ISNULL(T2.ChargingPeriodMonths, ''), 
    T2.ExpectedAmount, 
    ISNULL(CONVERT(varchar(24), T2.ExpectedStartDate, 120),''), 
    T2.ExpectedCommissionType, 
    ISNULL(T2.ParentPolicyExpectedCommissionId, ''), 
    ISNULL(CONVERT(varchar(20), T2.PreDiscountAmount),'') AS [PolicyExpectedCommission!2!PreDiscountAmount], 
	T2.DiscountReasonId AS [PolicyExpectedCommission!2!DiscountReasonId], 
	T3.Identifier AS [PolicyExpectedCommission!2!DiscountReason], 
    T2.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
  FROM TPolicyExpectedCommission T2
  INNER JOIN TPolicyBusiness T1
  ON T2.PolicyBusinessId = T1.PolicyBusinessId
	LEFT JOIN TDiscountReason T3 ON T3.DiscountReasonId = T2.DiscountReasonId

  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)

  UNION ALL

  SELECT
    3 AS Tag,
    2 AS Parent,
    T1.PolicyBusinessId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
--    NULL,
    T2.PolicyExpectedCommissionId, 
    T2.PolicyBusinessId, 
    T2.RefCommissionTypeId, 
    T2.RefPaymentDueTypeId, 
    ISNULL(T2.RefFrequencyId, ''), 
    ISNULL(T2.ChargingPeriodMonths, ''), 
    T2.ExpectedAmount, 
    ISNULL(CONVERT(varchar(24), T2.ExpectedStartDate, 120),''), 
    T2.ExpectedCommissionType, 
    ISNULL(T2.ParentPolicyExpectedCommissionId, ''), 
	NULL, NULL, NULL,
    T2.ConcurrencyId, 
    T3.RefFrequencyId, 
    ISNULL(T3.FrequencyName, ''), 
    ISNULL(T3.OrigoRef, ''), 
    ISNULL(T3.RetireFg, ''), 
    T3.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
  FROM TRefFrequency T3
  INNER JOIN TPolicyExpectedCommission T2
  ON T3.RefFrequencyId = T2.RefFrequencyId
  INNER JOIN TPolicyBusiness T1
  ON T2.PolicyBusinessId = T1.PolicyBusinessId

  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)

  UNION ALL

  SELECT
    4 AS Tag,
    2 AS Parent,
    T1.PolicyBusinessId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
--    NULL,
    T2.PolicyExpectedCommissionId, 
    T2.PolicyBusinessId, 
    T2.RefCommissionTypeId, 
    T2.RefPaymentDueTypeId, 
    ISNULL(T2.RefFrequencyId, ''), 
    ISNULL(T2.ChargingPeriodMonths, ''), 
    T2.ExpectedAmount, 
    ISNULL(CONVERT(varchar(24), T2.ExpectedStartDate, 120),''), 
    T2.ExpectedCommissionType, 
    ISNULL(T2.ParentPolicyExpectedCommissionId, ''), 
	NULL, NULL, NULL,
    T2.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T4.RefCommissionTypeId, 
    ISNULL(T4.CommissionTypeName, ''), 
    ISNULL(T4.OrigoRef, ''), 
    ISNULL(T4.InitialCommissionFg, ''), 
    ISNULL(T4.RecurringCommissionFg, ''), 
    ISNULL(T4.RetireFg, ''), 
    T4.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL
  FROM TRefCommissionType T4
  INNER JOIN TPolicyExpectedCommission T2
  ON T4.RefCommissionTypeId = T2.RefCommissionTypeId
  INNER JOIN TPolicyBusiness T1
  ON T2.PolicyBusinessId = T1.PolicyBusinessId

  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)

  UNION ALL

  SELECT
    5 AS Tag,
    2 AS Parent,
    T1.PolicyBusinessId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
--    NULL,
    T2.PolicyExpectedCommissionId, 
    T2.PolicyBusinessId, 
    T2.RefCommissionTypeId, 
    T2.RefPaymentDueTypeId, 
    ISNULL(T2.RefFrequencyId, ''), 
    ISNULL(T2.ChargingPeriodMonths, ''), 
    T2.ExpectedAmount, 
    ISNULL(CONVERT(varchar(24), T2.ExpectedStartDate, 120),''), 
    T2.ExpectedCommissionType, 
    ISNULL(T2.ParentPolicyExpectedCommissionId, ''), 
	NULL, NULL, NULL,
    T2.ConcurrencyId, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    T5.RefPaymentDueTypeId, 
    ISNULL(T5.PaymentDueType, ''), 
    ISNULL(T5.RetireFg, ''), 
    T5.ConcurrencyId
  FROM TRefPaymentDueType T5
  INNER JOIN TPolicyExpectedCommission T2
  ON T5.RefPaymentDueTypeId = T2.RefPaymentDueTypeId
  INNER JOIN TPolicyBusiness T1
  ON T2.PolicyBusinessId = T1.PolicyBusinessId



  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)

  ORDER BY [PolicyBusiness!1!PolicyBusinessId], [PolicyExpectedCommission!2!PolicyExpectedCommissionId], [RefPaymentDueType!5!RefPaymentDueTypeId], [RefCommissionType!4!RefCommissionTypeId], [RefFrequency!3!RefFrequencyId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
