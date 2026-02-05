SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveContactById]
@ContactId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.ContactId AS [Contact!1!ContactId], 
    T1.IndClientId AS [Contact!1!IndClientId], 
    T1.CRMContactId AS [Contact!1!CRMContactId], 
    T1.RefContactType AS [Contact!1!RefContactType], 
    ISNULL(T1.Description, '') AS [Contact!1!Description], 
    T1.Value AS [Contact!1!Value], 
    T1.DefaultFg AS [Contact!1!DefaultFg], 
    T1.ConcurrencyId AS [Contact!1!ConcurrencyId]
  FROM TContact T1

  WHERE (T1.ContactId = @ContactId)

  ORDER BY [Contact!1!ContactId]

  FOR XML EXPLICIT

END
RETURN (0)









GO
