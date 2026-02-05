SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AuditHistory_Review]
	@TenantId int,
	@Id bigint,
	@Database varchar(32),
	@Table varchar(128)
AS
DECLARE @TableId int, @IdColumn varchar(255), @Sql nvarchar(1000), @TenantColumn varchar(16)
----------------------------------------------------------------
-- Data checks
----------------------------------------------------------------
SET @Database = REPLACE(@Database, '''', '')
SET @Table = REPLACE(@Table, '''', '')

IF LEN(ISNULL(@Database, '')) = 0
	THROW 50001, 'DB not specified', 1;

IF LEN(ISNULL(@Table, '')) = 0
	THROW 50001, 'Table not specified', 1;

----------------------------------------------------------------
-- Check DB is valid
----------------------------------------------------------------
IF DB_ID(@Database) IS NULL
	THROW 50001, 'Unknown DB', 1;

----------------------------------------------------------------
-- Set up DB, Table name and Id column information
----------------------------------------------------------------
SET @IdColumn = @Table + 'Id'
SET @Table = 'T' + @Table + 'Audit'

----------------------------------------------------------------
-- Check Table is valid
----------------------------------------------------------------
SET @TableId = OBJECT_ID(@Database + '.dbo.' + @Table, 'U');
IF @TableId IS NULL
	THROW 50001, 'Unknown Table', 1;

----------------------------------------------------------------
-- Try to find tenant column in audit table
----------------------------------------------------------------
SET @Sql = '
	SELECT TOP 1 @TenantColumn = Name 
	FROM ' + @Database + '.sys.columns 
	WHERE 
		[object_id] = @TableId 
		AND [name] IN (''IndClientId'', ''IndigoClientId'', ''TenantId'')'

EXEC sp_executesql @Sql, N'@TableId int, @TenantColumn varchar(16) OUTPUT', 
	@TableId = @TableId, @TenantColumn = @TenantColumn OUTPUT

----------------------------------------------------------------
-- Retrieve audit data
----------------------------------------------------------------
SET @Sql = '
SELECT
	A.AuditId AS Id,
	U.Identifier AS UserName,
	U.Email AS UserEmail,
	UPPER(A.StampAction) AS StampAction,
	A.StampDateTime
FROM ' + 
	@Database + '.dbo.' + @Table + ' A 
	JOIN TUser U ON U.UserId = CAST(A.StampUser AS BIGINT)
WHERE
	A.' + @IdColumn + ' = @Id
	AND U.IndigoClientId = @TenantId'

-- Restrict audit table data by tenant id if possible
IF @TenantColumn IS NOT NULL
	SET @Sql = @Sql + ' AND A.' + @TenantColumn + ' = @TenantId'

-- Retrieve data from audit table
EXEC sp_executesql @Sql, N'@Id bigint, @TenantId int',
	@Id = @Id, @TenantId = @TenantId
GO
