SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefTrustType]
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefTrustTypeId AS [RefTrustType!1!RefTrustTypeId], 
    T1.TrustTypeName AS [RefTrustType!1!TrustTypeName], 
    T1.ArchiveFG AS [RefTrustType!1!ArchiveFG], 
    T1.ConcurrencyId AS [RefTrustType!1!ConcurrencyId]
  FROM TRefTrustType T1

  ORDER BY [RefTrustType!1!RefTrustTypeId]

  FOR XML EXPLICIT

END
RETURN (0)









GO
