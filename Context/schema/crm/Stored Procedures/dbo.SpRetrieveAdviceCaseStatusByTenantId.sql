SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveAdviceCaseStatusByTenantId]
@TenantId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.AdviceCaseStatusId AS [AdviceCaseStatus!1!AdviceCaseStatusId], 
    T1.TenantId AS [AdviceCaseStatus!1!TenantId], 
    T1.Descriptor AS [AdviceCaseStatus!1!Descriptor], 
    T1.IsDefault AS [AdviceCaseStatus!1!IsDefault], 
    T1.IsComplete AS [AdviceCaseStatus!1!IsComplete], 
    T1.ConcurrencyId AS [AdviceCaseStatus!1!ConcurrencyId]
  FROM TAdviceCaseStatus T1

  WHERE (T1.TenantId = @TenantId)

  ORDER BY [AdviceCaseStatus!1!AdviceCaseStatusId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
