SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveUserCombinedByUnipassSerialNbr]
@UnipassSerialNbr varchar (255)
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.Guid AS [UserCombined!1!Guid], 
    T1.UserId AS [UserCombined!1!UserId], 
    T1.Identifier AS [UserCombined!1!Identifier], 
    T1.IndigoClientId AS [UserCombined!1!IndigoClientId], 
    T1.IndigoClientGuid AS [UserCombined!1!IndigoClientGuid], 
    ISNULL(T1.UnipassSerialNbr, '') AS [UserCombined!1!UnipassSerialNbr], 
    T1.ConcurrencyId AS [UserCombined!1!ConcurrencyId]
  FROM TUserCombined T1

  WHERE (T1.UnipassSerialNbr = @UnipassSerialNbr)

  ORDER BY [UserCombined!1!Guid]

  FOR XML EXPLICIT

END
RETURN (0)

GO
