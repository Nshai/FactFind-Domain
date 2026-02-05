SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveStatusHistoryWithStatusByPolicyBusinessIdAndLifeCycleStepFGAndCurrentStatusFG]
@PolicyBusinessId bigint,
@LifeCycleStepFG bit,
@CurrentStatusFG bit
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.StatusHistoryId AS [StatusHistory!1!StatusHistoryId], 
    T1.PolicyBusinessId AS [StatusHistory!1!PolicyBusinessId], 
    T1.StatusId AS [StatusHistory!1!StatusId], 
    ISNULL(T1.StatusReasonId, '') AS [StatusHistory!1!StatusReasonId], 
    CONVERT(varchar(24), T1.ChangedToDate, 120) AS [StatusHistory!1!ChangedToDate], 
    T1.ChangedByUserId AS [StatusHistory!1!ChangedByUserId], 
    ISNULL(CONVERT(varchar(24), T1.DateOfChange, 120),'') AS [StatusHistory!1!DateOfChange], 
    T1.LifeCycleStepFG AS [StatusHistory!1!LifeCycleStepFG], 
    T1.CurrentStatusFG AS [StatusHistory!1!CurrentStatusFG], 
    T1.ConcurrencyId AS [StatusHistory!1!ConcurrencyId], 
    NULL AS [Status!2!StatusId], 
    NULL AS [Status!2!Name], 
    NULL AS [Status!2!OrigoStatusId], 
    NULL AS [Status!2!IntelligentOfficeStatusType], 
    NULL AS [Status!2!PreComplianceCheck], 
    NULL AS [Status!2!PostComplianceCheck], 
    NULL AS [Status!2!SystemSubmitFg], 
    NULL AS [Status!2!IndigoClientId], 
    NULL AS [Status!2!ConcurrencyId]
  FROM TStatusHistory T1

  WHERE (T1.PolicyBusinessId = @PolicyBusinessId) AND 
        (T1.LifeCycleStepFG = @LifeCycleStepFG) AND 
        (T1.CurrentStatusFG = @CurrentStatusFG)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.StatusHistoryId, 
    T1.PolicyBusinessId, 
    T1.StatusId, 
    ISNULL(T1.StatusReasonId, ''), 
    CONVERT(varchar(24), T1.ChangedToDate, 120), 
    T1.ChangedByUserId, 
    ISNULL(CONVERT(varchar(24), T1.DateOfChange, 120),''), 
    T1.LifeCycleStepFG, 
    T1.CurrentStatusFG, 
    T1.ConcurrencyId, 
    T2.StatusId, 
    T2.Name, 
    ISNULL(T2.OrigoStatusId, ''), 
    ISNULL(T2.IntelligentOfficeStatusType, ''), 
    T2.PreComplianceCheck, 
    T2.PostComplianceCheck, 
    T2.SystemSubmitFg, 
    T2.IndigoClientId, 
    T2.ConcurrencyId
  FROM TStatus T2
  INNER JOIN TStatusHistory T1
  ON T2.StatusId = T1.StatusId

  WHERE (T1.PolicyBusinessId = @PolicyBusinessId) AND 
        (T1.LifeCycleStepFG = @LifeCycleStepFG) AND 
        (T1.CurrentStatusFG = @CurrentStatusFG)

  ORDER BY [StatusHistory!1!StatusHistoryId], [Status!2!StatusId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
