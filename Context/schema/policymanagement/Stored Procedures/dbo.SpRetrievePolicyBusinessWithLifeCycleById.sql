SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrievePolicyBusinessWithLifeCycleById]
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
    T1.SequentialRef AS [PolicyBusiness!1!SequentialRef], 
    T1.ConcurrencyId AS [PolicyBusiness!1!ConcurrencyId], 
    ISNULL(TNote.Note, '') AS [PolicyBusiness!1!_note], 
    NULL AS [LifeCycle!2!LifeCycleId], 
    NULL AS [LifeCycle!2!Name], 
    NULL AS [LifeCycle!2!Descriptor], 
    NULL AS [LifeCycle!2!Status], 
    NULL AS [LifeCycle!2!CreatedDate], 
    NULL AS [LifeCycle!2!CreatedUser], 
    NULL AS [LifeCycle!2!IndigoClientId], 
    NULL AS [LifeCycle!2!ConcurrencyId]
  FROM TPolicyBusiness T1
  -- Note clause
  LEFT JOIN TPolicyBusinessNote TNote
  ON TNote.PolicyBusinessId = T1.PolicyBusinessId AND TNote.IsLatest=1

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
    ISNULL(CONVERT(varchar(24), T1.TotalRegularPremium), ''), 
    ISNULL(CONVERT(varchar(24), T1.TotalLumpSum), ''), 
    ISNULL(CONVERT(varchar(24), T1.MaturityDate, 120),''), 
    ISNULL(T1.LifeCycleId, ''), 
    T1.SequentialRef, 
    T1.ConcurrencyId, 
    NULL,
    T2.LifeCycleId, 
    T2.Name, 
    ISNULL(T2.Descriptor, ''), 
    T2.Status, 
    ISNULL(CONVERT(varchar(24), T2.CreatedDate, 120),''), 
    ISNULL(T2.CreatedUser, ''), 
    T2.IndigoClientId, 
    T2.ConcurrencyId
  FROM TLifeCycle T2
  INNER JOIN TPolicyBusiness T1
  ON T2.LifeCycleId = T1.LifeCycleId

  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)

  ORDER BY [PolicyBusiness!1!PolicyBusinessId], [LifeCycle!2!LifeCycleId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
