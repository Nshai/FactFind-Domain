SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomSetSystemKey]
	@TenantId int,
	@StampUserId int,
	@SystemId int,
	@RightMask int,
	@UserId int = 0,
	@RoleId int = 0,
	@Propogate bit=0
AS
BEGIN
DECLARE @Sql nvarchar(4000), @Systems nvarchar(4000), @RefLicenceTypeId int = 1
IF @RoleId = 0 SET @RoleId = NULL
IF @UserId = 0 SET @UserId = NULL

-- A role or user should be specified.
IF ISNULL(@RoleId, @UserId) IS NULL
	GOTO errh

IF @RoleId IS NOT NULL
BEGIN
	SELECT @RefLicenceTypeId=RefLicenseTypeId FROM TRole WHERE RoleId=@RoleId AND IndigoClientId = @TenantId
END
ELSE IF @UserId IS NOT NULL
BEGIN
	SELECT @RefLicenceTypeId=B.RefLicenseTypeId FROM TUser A JOIN TRole B ON A.ActiveRole=B.RoleId
	WHERE A.UserId=@UserId AND A.IndigoClientId = @TenantId
END

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
                     ' FROM TSystem T1 '

    SET @SubLevel=0

    WHILE (@SubLevel!=(@Level+1))
    BEGIN
      SET @Systems = @Systems + 
                       ' INNER JOIN TSystem T' + CAST((@SubLevel+2) AS nvarchar(2)) + 
                       ' ON T' + CAST((@SubLevel+2) AS nvarchar(2)) + '.ParentId =' +
                       ' T' + CAST((@SubLevel+1) AS nvarchar(2)) + '.SystemId ' + 
                       ' INNER JOIN TRefLicenseTypeToSystem Lic' + CAST((@SubLevel+2) AS nvarchar(2)) +
                       ' ON Lic' + CAST((@SubLevel+2) AS nvarchar(2)) + 
                       '.SystemId=T' + CAST((@SubLevel+2) AS nvarchar(2)) + 
                       '.SystemId AND Lic' + CAST((@SubLevel+2) AS nvarchar(2)) +
                       '.RefLicenseTypeId=' + CAST((@RefLicenceTypeId) as nvarchar(4))
    
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


Create Table #TempSystems(SystemId int)

Select @Systems = 'Insert Into #TempSystems (SystemId) ' + @Systems

EXEC sp_executesql @Systems, N'@SystemId int', @SystemId

IF (SELECT COUNT(1) FROM #TempSystems) = 0
	GOTO errh

INSERT INTO TFunctionalSecurityChangeLog (TenantId, StampUserId, StampDateTime, SystemId, RoleId, UserId, Propagate, RightMask)
VALUES (@TenantId, @StampUserId, GETDATE(), @SystemId, @RoleId, @UserId, @Propogate, @RightMask)

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
		' @StampUserId             ' +
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
		' @StampUserId              ' +
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
        'INNER JOIN administration..TMembership T3 ON T2.UserId=T3.UserId AND T3.RoleId=@RoleId '        
        

	+
	' INSERT INTO administration..TKey (  ' +
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
		' @StampUserId              ' +
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
                           N'@RightMask int, @SystemId int, @RoleId int, @StampUserId int', 
                           @RightMask, @SystemId, @RoleId, @StampUserId
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
		' @StampUserId             ' +
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
		' @StampUserId              ' +
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
                           N'@RightMask int, @SystemId int, @UserId int, @StampUserId int', 
                           @RightMask, @SystemId, @UserId, @StampUserId
END

IF @@ERROR != 0 
	GOTO errh

END
SELECT 0

errh:
	SELECT 1
GO