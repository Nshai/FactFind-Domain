SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefIntroducerTypeByIndClientIdAndArchiveFG]
@IndClientId bigint,
@ArchiveFG bit
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefIntroducerTypeId AS [RefIntroducerType!1!RefIntroducerTypeId], 
    T1.IndClientId AS [RefIntroducerType!1!IndClientId], 
    ISNULL(T1.ShortName, '') AS [RefIntroducerType!1!ShortName], 
    T1.LongName AS [RefIntroducerType!1!LongName], 
    T1.MinSplitRange AS [RefIntroducerType!1!MinSplitRange], 
    T1.MaxSplitRange AS [RefIntroducerType!1!MaxSplitRange], 
    ISNULL(CONVERT(varchar(24), T1.DefaultSplit), '') AS [RefIntroducerType!1!DefaultSplit], 
    ISNULL(T1.RenewalsFG, '') AS [RefIntroducerType!1!RenewalsFG], 
    T1.ArchiveFG AS [RefIntroducerType!1!ArchiveFG], 
    T1.ConcurrencyId AS [RefIntroducerType!1!ConcurrencyId]
  FROM TRefIntroducerType T1

  WHERE (T1.IndClientId = @IndClientId) AND 
        (T1.ArchiveFG = @ArchiveFG)

  ORDER BY [RefIntroducerType!1!RefIntroducerTypeId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
