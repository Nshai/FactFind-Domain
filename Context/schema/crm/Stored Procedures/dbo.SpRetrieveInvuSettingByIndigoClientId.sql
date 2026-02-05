SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveInvuSettingByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.InvuSettingId AS [InvuSetting!1!InvuSettingId], 
    T1.IndigoClientId AS [InvuSetting!1!IndigoClientId], 
    T1.FilePath AS [InvuSetting!1!FilePath], 
    T1.ConcurrencyId AS [InvuSetting!1!ConcurrencyId]
  FROM TInvuSetting T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [InvuSetting!1!InvuSettingId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
