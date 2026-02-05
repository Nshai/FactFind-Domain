SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveLifeCycleById]
@LifeCycleId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.LifeCycleId AS [LifeCycle!1!LifeCycleId], 
    T1.Name AS [LifeCycle!1!Name], 
    ISNULL(T1.Descriptor, '') AS [LifeCycle!1!Descriptor], 
    T1.Status AS [LifeCycle!1!Status], 
    ISNULL(T1.PreQueueBehaviour, '') AS [LifeCycle!1!PreQueueBehaviour], 
    ISNULL(T1.PostQueueBehaviour, '') AS [LifeCycle!1!PostQueueBehaviour], 
    ISNULL(CONVERT(varchar(24), T1.CreatedDate, 120),'') AS [LifeCycle!1!CreatedDate], 
    ISNULL(T1.CreatedUser, '') AS [LifeCycle!1!CreatedUser], 
    T1.IndigoClientId AS [LifeCycle!1!IndigoClientId], 
    T1.ConcurrencyId AS [LifeCycle!1!ConcurrencyId]
  FROM TLifeCycle T1

  WHERE (T1.LifeCycleId = @LifeCycleId)

  ORDER BY [LifeCycle!1!LifeCycleId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
