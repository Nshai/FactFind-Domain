SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[spMICustomGenerateTableChanges]
	@TableName varchar(255),
	@PK varchar(255),
	@TenantIds varchar(255) = '',
	@TenantColumName varchar(255) = '',
	@CustomANDClause varchar(500) = '',
	@TopClause varchar(255) = '',
	@Execute bit = 0
AS

/*
Declare @TableName varchar(255)
Set @TableName = 'TUser'
Declare @PK varchar(255)
Set @PK = 'UserId'

Declare @TenantIds varchar(255)
Set @TenantIds = ''

Declare @TenantColumName varchar(255)
Set @TenantColumName = ''

Declare @CustomANDClause varchar(255)
Set @CustomANDClause = ''


Declare @TopClause varchar(255)
Set @TopClause = ''

declare @Execute bit
set @Execute = 1
*/




declare @TenantClause varchar(255)
set @TenantClause = ''
if @TenantColumName <> ''
begin
	set @TenantClause = ' AND ' + @TenantColumName + ' IN (' + @TenantIds + ')'
end

Declare @SQL varchar(3000)
Set @SQL = '
Declare @Id bigint
DECLARE vendor_cursor CURSOR FOR 
SELECT  
' + @TopClause + '
' + @PK + ' 
FROM MIRDB..' + @TableName + '
WHERE 1=1
' + @tenantclause + '
' + @CustomANDClause + '

OPEN vendor_cursor

FETCH NEXT FROM vendor_cursor 
INTO @Id

WHILE @@FETCH_STATUS = 0
BEGIN
	print @Id
	Begin tran
		update MIRDB..' + @Tablename + ' set concurrencyId = concurrencyId +1
		where ' + @PK + '  = @Id 
	Commit Tran

	FETCH NEXT FROM vendor_cursor 
    INTO @Id

END 
CLOSE vendor_cursor
DEALLOCATE vendor_cursor
'

Select @SQL
print @SQL


if @Execute = 1
begin
	EXECUTE (@SQL) 
end 

GO
