SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveSystemBySystemTypeLike]
@SystemType varchar (16)
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.SystemId AS [System!1!SystemId], 
    T1.Identifier AS [System!1!Identifier], 
    ISNULL(T1.Description, '') AS [System!1!Description], 
    ISNULL(T1.SystemPath, '') AS [System!1!SystemPath], 
    ISNULL(T1.SystemType, '') AS [System!1!SystemType], 
    ISNULL(T1.ParentId, '') AS [System!1!ParentId], 
    ISNULL(T1.Url, '') AS [System!1!Url], 
    ISNULL(T1.EntityId, '') AS [System!1!EntityId], 
    T1.ConcurrencyId AS [System!1!ConcurrencyId]
  FROM TSystem T1

  WHERE (T1.SystemType LIKE '%' + @SystemType + '%')

  ORDER BY [System!1!SystemId]

  FOR XML EXPLICIT

END
RETURN (0)






GO
