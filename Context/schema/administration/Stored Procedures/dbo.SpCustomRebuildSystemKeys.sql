SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SpCustomRebuildSystemKeys]
	(
		@UserId bigint,
		@RoleId bigint
	)

AS

BEGIN

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

DECLARE @Sql nvarchar(4000)

-- Build dynamic SQL to create new user keys
SET @Sql = 
'INSERT INTO administration..TKey ( ' +
'  RightMask,    ' +
'  SystemId,     ' +
'  UserId,       ' +
'  RoleId        ' +
')               ' +
'SELECT DISTINCT ' + 
'  T1.RightMask,   ' +
'  T1.SystemId,    ' +
'  @UserId,        ' +
'  T1.RoleId         ' +
'FROM administration..TKey T1 ' +
'WHERE T1.RoleId = @RoleId '

EXEC sp_executesql @Sql, 
                   N'@UserId bigint, @RoleId bigint', 
                   @UserId, @RoleId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)


errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
