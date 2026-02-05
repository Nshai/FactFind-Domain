SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveTrustById]
@TrustId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.TrustId AS [Trust!1!TrustId], 
    T1.RefTrustTypeId AS [Trust!1!RefTrustTypeId], 
    T1.IndClientId AS [Trust!1!IndClientId], 
    T1.TrustName AS [Trust!1!TrustName], 
    ISNULL(CONVERT(varchar(24), T1.EstDate, 120),'') AS [Trust!1!EstDate], 
    T1.ArchiveFG AS [Trust!1!ArchiveFG], 
    T1.ConcurrencyId AS [Trust!1!ConcurrencyId]
  FROM TTrust T1

  WHERE (T1.TrustId = @TrustId)

  ORDER BY [Trust!1!TrustId]

  FOR XML EXPLICIT

END
RETURN (0)









GO
