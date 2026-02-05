SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveFeeStatusById]
@FeeStatusId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.FeeStatusId AS [FeeStatus!1!FeeStatusId], 
    T1.FeeId AS [FeeStatus!1!FeeId], 
    T1.Status AS [FeeStatus!1!Status], 
    ISNULL(T1.StatusNotes, '') AS [FeeStatus!1!StatusNotes], 
    CONVERT(varchar(24), T1.StatusDate, 120) AS [FeeStatus!1!StatusDate], 
    T1.UpdatedUserId AS [FeeStatus!1!UpdatedUserId], 
    T1.ConcurrencyId AS [FeeStatus!1!ConcurrencyId]
  FROM TFeeStatus T1

  WHERE (T1.FeeStatusId = @FeeStatusId)

  ORDER BY [FeeStatus!1!FeeStatusId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
