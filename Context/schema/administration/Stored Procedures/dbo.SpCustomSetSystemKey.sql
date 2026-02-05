SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSetSystemKey]
@SystemId bigint,
@RightMask int,
@UserId bigint = 0,
@RoleId bigint = 0,
@Propogate bit=0
AS
BEGIN

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

DECLARE @Sql nvarchar(4000)
DECLARE @Systems nvarchar(4000)

SET @Systems='SELECT T1.SystemId FROM TSystem T1 WHERE T1.SystemId = @SystemId '

-- Propogate key to child systems?
IF (@Propogate=1)
BEGIN
  DECLARE @Level tinyint
  DECLARE @SubLevel tinyint

  -- Initialise
  SET @Level = 0
  
  -- Build clause(s)
  WHILE (@Level!=5)
  BEGIN
    
    SET @Systems = @Systems + 
                     ' UNION SELECT T' + CAST((@Level+2) AS nvarchar(2)) + '.SystemId ' + 
                     ' FROM TSystem T1'

    SET @SubLevel=0

    WHILE (@SubLevel!=(@Level+1))
    BEGIN
      SET @Systems = @Systems + 
                       ' INNER JOIN TSystem T' + CAST((@SubLevel+2) AS nvarchar(2)) + 
                       ' ON T' + CAST((@SubLevel+2) AS nvarchar(2)) + '.ParentId =' +
                       ' T' + CAST((@SubLevel+1) AS nvarchar(2)) + '.SystemId '
    
      SET @SubLevel = @SubLevel+1
    END

    SET @Systems = @Systems + 
                     ' WHERE T1.SystemId=@SystemId '  

    -- Next level down
    SET @Level = @Level + 1
  END
END

If Object_Id('tempdb..#TempSystems') Is Not Null
	Drop Table #TempSystems


Create Table #TempSystems(SystemId bigint)

Select @Systems = 'Insert Into #TempSystems (SystemId) ' + @Systems

EXEC sp_executesql @Systems, N'@SystemId bigint', @SystemId



-- Set role keys
IF (@RoleId>0)
BEGIN
	-- Now build dynamic SQL
	SET @Sql = 
	' DELETE FROM administration..TKey ' +
	' OUTPUT ' +
		' deleted.[RightMask],     ' +
		' deleted.[SystemId],      ' + 
		' deleted.[UserId],        ' +
		' deleted.[RoleId],        ' +
		' deleted.[ConcurrencyId], ' +
		' deleted.[KeyId],         ' +
		' ''D'',                   ' +
		' GETUTCDATE(),            ' +
		' ''0''                    ' +
	' INTO ' +
		' administration..TKeyAudit ( ' +
		' [RightMask],     ' +
		' [SystemId],      ' + 
		' [UserId],        ' + 
		' [RoleId],        ' +
		' [ConcurrencyId], ' + 
		' [KeyId],         ' + 
		' [StampAction],   ' + 
		' [StampDateTime], ' +
		' [StampUser])     ' +
	'WHERE RoleId = @RoleId AND SystemId IN (Select SystemId From #TempSystems) 
' +

	'INSERT INTO administration..TKey (  ' +
	'  RightMask,    ' +
	'  SystemId,     ' +
	'  UserId,       ' +
	'  RoleId        ' +
	')               ' +
	' OUTPUT ' +
		' inserted.[RightMask],     ' +
		' inserted.[SystemId],      ' + 
		' inserted.[UserId],        ' +
		' inserted.[RoleId],        ' +
		' inserted.[ConcurrencyId], ' +
		' inserted.[KeyId],         ' +
		' ''C'',                    ' +
		' GETUTCDATE(),             ' +
		' ''0''                     ' +
	' INTO ' +
		' administration..TKeyAudit ( ' +
		' [RightMask],     ' +
		' [SystemId],      ' + 
		' [UserId],        ' + 
		' [RoleId],        ' +
		' [ConcurrencyId], ' + 
		' [KeyId],         ' + 
		' [StampAction],   ' + 
		' [StampDateTime], ' +
		' [StampUser])     ' +
	'SELECT DISTINCT ' + 
        '  @RightMask,   ' +
        '  T1.SystemId,  ' +
        '  T2.UserId,    ' +
        '  @RoleId       ' +
        'FROM (Select SystemId From #TempSystems) AS T1, administration..TUser T2 ' + 
        'INNER JOIN administration..TMembership T3 ON T2.UserId=T3.UserId AND T3.RoleId=@RoleId 
'
	+
	'INSERT INTO administration..TKey (  ' +
	'  RightMask,    ' +
	'  SystemId,     ' +
	'  UserId,       ' +
	'  RoleId        ' +
	')               ' +
	' OUTPUT ' +
		' inserted.[RightMask],     ' +
		' inserted.[SystemId],      ' + 
		' inserted.[UserId],        ' +
		' inserted.[RoleId],        ' +
		' inserted.[ConcurrencyId], ' +
		' inserted.[KeyId],         ' +
		' ''C'',                    ' +
		' GETUTCDATE(),             ' +
		' ''0''                     ' +
	' INTO ' +
		' administration..TKeyAudit ( ' +
		' [RightMask],     ' +
		' [SystemId],      ' + 
		' [UserId],        ' + 
		' [RoleId],        ' +
		' [ConcurrencyId], ' + 
		' [KeyId],         ' + 
		' [StampAction],   ' + 
		' [StampDateTime], ' +
		' [StampUser])     ' +
	'SELECT DISTINCT ' + 
        '  @RightMask,   ' +
        '  T1.SystemId,  ' +
        '  Null,    ' +
        '  @RoleId       ' +
        'FROM (Select SystemId From #TempSystems) AS T1, administration..TMembership T3 
'



	EXEC sp_executesql @Sql, 
                           N'@RightMask int, @SystemId bigint, @RoleId bigint', 
                           @RightMask, @SystemId, @RoleId
END

-- Set user keys
IF (@UserId>0)
BEGIN	
	-- Now build dynamic SQL
	SET @Sql = 
	'DELETE FROM administration..TKey ' +
	' OUTPUT ' +
		' deleted.[RightMask],     ' +
		' deleted.[SystemId],      ' + 
		' deleted.[UserId],        ' +
		' deleted.[RoleId],        ' +
		' deleted.[ConcurrencyId], ' +
		' deleted.[KeyId],         ' +
		' ''D'',                   ' +
		' GETUTCDATE(),            ' +
		' ''0''                    ' +
	' INTO ' +
		' administration..TKeyAudit ( ' +
		' [RightMask],     ' +
		' [SystemId],      ' + 
		' [UserId],        ' + 
		' [RoleId],        ' +
		' [ConcurrencyId], ' + 
		' [KeyId],         ' + 
		' [StampAction],   ' + 
		' [StampDateTime], ' +
		' [StampUser])     ' +
	'WHERE UserId = @UserId AND SystemId IN (Select SystemId From #TempSystems) ' +
	'INSERT INTO administration..TKey ( ' +
	'  RightMask,    ' +
	'  SystemId,     ' +
	'  UserId,       ' +
	'  RoleId        ' +
	')               ' +
	' OUTPUT ' +
		' inserted.[RightMask],     ' +
		' inserted.[SystemId],      ' + 
		' inserted.[UserId],        ' +
		' inserted.[RoleId],        ' +
		' inserted.[ConcurrencyId], ' +
		' inserted.[KeyId],         ' +
		' ''C'',                    ' +
		' GETUTCDATE(),             ' +
		' ''0''                     ' +
	' INTO ' +
		' administration..TKeyAudit ( ' +
		' [RightMask],     ' +
		' [SystemId],      ' + 
		' [UserId],        ' + 
		' [RoleId],        ' +
		' [ConcurrencyId], ' + 
		' [KeyId],         ' + 
		' [StampAction],   ' + 
		' [StampDateTime], ' +
		' [StampUser])     ' +
	'SELECT DISTINCT ' + 
        '  @RightMask,   ' +
        '  T1.SystemId,    ' +
        '  @UserId,      ' +
        '  NULL          ' +
        'FROM (Select SystemId From #TempSystems) AS T1, administration..TUser T2 '

	EXEC sp_executesql @Sql, 
                           N'@RightMask int, @SystemId bigint, @UserId bigint', 
                           @RightMask, @SystemId, @UserId
END

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO