SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveAdviceTypeByIndigoClientIdAndArchiveFg]
@IndigoClientId bigint,
@ArchiveFg bit
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.AdviceTypeId AS [AdviceType!1!AdviceTypeId], 
    T1.Description AS [AdviceType!1!Description], 
    T1.IntelligentOfficeAdviceType AS [AdviceType!1!IntelligentOfficeAdviceType], 
    T1.ArchiveFg AS [AdviceType!1!ArchiveFg], 
    T1.IndigoClientId AS [AdviceType!1!IndigoClientId], 
    T1.ConcurrencyId AS [AdviceType!1!ConcurrencyId]
  FROM TAdviceType T1

  WHERE (T1.IndigoClientId = @IndigoClientId) AND 
        (T1.ArchiveFg = @ArchiveFg)

  ORDER BY [AdviceType!1!AdviceTypeId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
