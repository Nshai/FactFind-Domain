SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveFeeRetainerOwnerByRetainerId]
@RetainerId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.FeeRetainerOwnerId AS [FeeRetainerOwner!1!FeeRetainerOwnerId], 
    ISNULL(T1.FeeId, '') AS [FeeRetainerOwner!1!FeeId], 
    ISNULL(T1.RetainerId, '') AS [FeeRetainerOwner!1!RetainerId], 
    ISNULL(T1.CRMContactId, '') AS [FeeRetainerOwner!1!CRMContactId], 
    ISNULL(T1.TnCCoachId, '') AS [FeeRetainerOwner!1!TnCCoachId], 
    ISNULL(T1.PractitionerId, '') AS [FeeRetainerOwner!1!PractitionerId], 
    ISNULL(T1.IndigoClientId, '') AS [FeeRetainerOwner!1!IndigoClientId], 
    ISNULL(T1.ConcurrencyId, '') AS [FeeRetainerOwner!1!ConcurrencyId]
  FROM TFeeRetainerOwner T1

  WHERE (T1.RetainerId = @RetainerId)

  ORDER BY [FeeRetainerOwner!1!FeeRetainerOwnerId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
