SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomListUserKeysByUserId]
@UserId bigint
AS

Declare @UserId_Int bigint
Select @UserId_Int = @UserId

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.UserId AS [User!1!UserId], 
    T1.SuperUser AS [User!1!SuperUser], 
    NULL AS [Key!2!KeyId], 
    NULL AS [Key!2!RightMask], 
    NULL AS [Key!2!SystemId], 
    NULL AS [Key!2!UserId], 
    NULL AS [System!3!SystemId], 
    NULL AS [System!3!SystemPath]
  FROM TUser T1

  WHERE (T1.UserId = @UserId_Int)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.UserId, 
    T1.SuperUser, 
    T2.KeyId, 
    T2.RightMask, 
    T2.SystemId, 
    ISNULL(T2.UserId, ''), 
    NULL, 
    NULL
  FROM TKey T2
  INNER JOIN TUser T1
  ON T2.UserId = T1.UserId

  WHERE (T1.UserId = @UserId_Int)
  AND (T2.RoleId = T1.ActiveRole)

  UNION ALL

  SELECT
    3 AS Tag,
    2 AS Parent,
    T1.UserId, 
    NULL, 
    T2.KeyId, 
    T2.RightMask, 
    T2.SystemId, 
    ISNULL(T2.UserId, ''), 
    T3.SystemId, 
    ISNULL(T3.SystemPath, '') 
  FROM TSystem T3
  INNER JOIN TKey T2
  ON T3.SystemId = T2.SystemId
  INNER JOIN TUser T1
  ON T2.UserId = T1.UserId

  WHERE (T1.UserId = @UserId_Int)
  AND (T2.RoleId = T1.ActiveRole)

  ORDER BY [User!1!UserId], [Key!2!KeyId], [System!3!SystemId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
