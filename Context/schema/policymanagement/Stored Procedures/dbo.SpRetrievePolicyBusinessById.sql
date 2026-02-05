SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePolicyBusinessById]
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
    ISNULL(CONVERT(varchar(24), T1.TotalRegularPremium), '') AS [PolicyBusiness!1!TotalRegularPremium], 
    ISNULL(CONVERT(varchar(24), T1.TotalLumpSum), '') AS [PolicyBusiness!1!TotalLumpSum], 
    ISNULL(CONVERT(varchar(24), T1.MaturityDate, 120),'') AS [PolicyBusiness!1!MaturityDate], 
    ISNULL(T1.LifeCycleId, '') AS [PolicyBusiness!1!LifeCycleId], 
    ISNULL(CONVERT(varchar(24), T1.PolicyStartDate, 120),'') AS [PolicyBusiness!1!PolicyStartDate], 
    ISNULL(T1.PremiumType, '') AS [PolicyBusiness!1!PremiumType], 
    ISNULL(T1.AgencyNumber, '') AS [PolicyBusiness!1!AgencyNumber], 
    ISNULL(T1.SequentialRef, '') AS [PolicyBusiness!1!SequentialRef], 
    ISNULL(T1.ProviderAddress, '') AS [PolicyBusiness!1!ProviderAddress], 
    T1.OffPanelFg AS [PolicyBusiness!1!OffPanelFg], 
    ISNULL(T1.BaseCurrency, '') AS [PolicyBusiness!1!BaseCurrency], 
    ISNULL(CONVERT(varchar(24), T1.ExpectedPaymentDate, 120),'') AS [PolicyBusiness!1!ExpectedPaymentDate], 
    ISNULL(T1.ProductName, '') AS [PolicyBusiness!1!ProductName], 
    ISNULL(T1.InvestmentTypeId, '') AS [PolicyBusiness!1!InvestmentTypeId], 
    ISNULL(T1.RiskRating, '') AS [PolicyBusiness!1!RiskRating], 
    T1.ConcurrencyId AS [PolicyBusiness!1!ConcurrencyId], 
    ISNULL(TNote.Note, '') AS [PolicyBusiness!1!_note]
  FROM TPolicyBusiness T1
  -- Note clause
  LEFT JOIN TPolicyBusinessNote TNote
  ON TNote.PolicyBusinessId = T1.PolicyBusinessId AND TNote.IsLatest=1

  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)

  ORDER BY [PolicyBusiness!1!PolicyBusinessId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
