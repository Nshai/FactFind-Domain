SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrievePolicyBusinessWithAdviceTypeById]
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
    ISNULL(T1.SequentialRef, '') AS [PolicyBusiness!1!SequentialRef], 
    T1.ConcurrencyId AS [PolicyBusiness!1!ConcurrencyId], 
    ISNULL(TNote.Note, '') AS [PolicyBusiness!1!_note], 
    NULL AS [AdviceType!2!AdviceTypeId], 
    NULL AS [AdviceType!2!Description], 
    NULL AS [AdviceType!2!IntelligentOfficeAdviceType], 
    NULL AS [AdviceType!2!ArchiveFg], 
    NULL AS [AdviceType!2!IndigoClientId], 
    NULL AS [AdviceType!2!ConcurrencyId]
  FROM TPolicyBusiness T1
  -- Note clause
/*  LEFT JOIN 
      (SELECT
          PolicyBusinessId,
          Note
      FROM TPolicyBusinessNote T1
      WHERE T1.PolicyBusinessNoteId = 
          (SELECT MAX(PolicyBusinessNoteId) FROM TPolicyBusinessNote
           WHERE PolicyBusinessId = T1.PolicyBusinessId)) AS TNote
  ON TNote.PolicyBusinessId = T1.PolicyBusinessId
*/
  LEFT JOIN
	( SELECT T1.Note, TNote1.PolicyBusinessId
		FROM TPolicyBusinessNote T1 
    		JOIN 
		( SELECT MAX(PolicyBusinessNoteId) AS PolicyBusinessNoteId, PolicyBusinessId
			FROM TPolicyBusinessNote 
			WHERE PolicyBusinessId  = @PolicyBusinessId 
			GROUP BY PolicyBusinessId
		) AS TNote1 
		ON TNote1.PolicyBusinessNoteId = T1.PolicyBusinessNoteId
	) As TNote 
	ON TNote.PolicyBusinessId = T1.PolicyBusinessId


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
    ISNULL(T1.SequentialRef, ''), 
    T1.ConcurrencyId, 
    NULL,
    T2.AdviceTypeId, 
    T2.Description, 
    T2.IntelligentOfficeAdviceType, 
    T2.ArchiveFg, 
    T2.IndigoClientId, 
    T2.ConcurrencyId
  FROM TAdviceType T2
  INNER JOIN TPolicyBusiness T1
  ON T2.AdviceTypeId = T1.AdviceTypeId

  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)

  ORDER BY [PolicyBusiness!1!PolicyBusinessId], [AdviceType!2!AdviceTypeId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
