CREATE PROCEDURE [dbo].[SpCustomCreateChangeLogTriggers] 
@dbname sysname,@TableName varchar(100),@Execute bit = 1
As 

SET NOCOUNT ON 

if (@TableName like 'TChangeLog%' or @TableName like '%Audit' or @TableName like '%Key') return

If Object_Id('tempdb.dbo.#Script') is not null Drop Table #Script
Create Table #Script(Id bigint Identity(1,1), Script varchar(2000))

declare @StartSql nvarchar(4000), @EndSql nvarchar(4000), @DropSql nvarchar(4000),@PKColumnName varchar(100), @PKColumnName2 varchar(100), @Action varchar(100), @SqlToExecute varchar(8000), @migrationref_column sysname, @bulk tinyint
declare @sqltext0 nvarchar(4000), @sqltext0_params sysname, @PolicyBusinessFundCustomTriggerPostfix nvarchar(2000), @ChangeLogSql nvarchar(2000), @ChangeLogSql1 nvarchar(2000), @FireEvent varchar(1000)=''
declare @TempSql nvarchar(4000), @SqlToRun nvarchar(4000), @NewLine varchar(10), @GoStatement varchar(10), @sqltext1 nvarchar(4000)

declare @table0 table (tablename sysname)
insert into @table0 values ('TPlanValuation')
insert into @table0 values ('TPolicyBusinessFundTransaction')
insert into @table0 values ('TPolicyBusinessFund')
insert into @table0 values ('TGroupScheme')
insert into @table0 values ('TGroupSchemeMember')
insert into @table0 values ('TGroupSchemeCategory')

declare @sqltext2 nvarchar(1000)
declare @table1 table (migrationref_column sysname)

if exists (select top 1 1 from @table0 where tablename = @TableName) select @bulk = 1

Select @DropSql = 'IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = 
	OBJECT_ID(N''[dbo].[trg_' + @TableName + '_CL_#LongActionName#]''))
DROP TRIGGER [dbo].[trg_' + @TableName + '_CL_#LongActionName#]
'

Select @StartSql = 'Create TRIGGER [dbo].[trg_' + @TableName + '_CL_#LongActionName#] 
   ON  [dbo].' + @TableName + ' 
   AFTER #LongActionName#
AS 
BEGIN
set nocount on
'
select @Sqltext0 = 'Select @pkey=c1.COLUMN_NAME, @pkey2=c2.COLUMN_NAME From '+@dbname+'.INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ' +
					'Join '+@dbname+'.INFORMATION_SCHEMA.KEY_COLUMN_USAGE c1 On c1.TABLE_NAME = pk.TABLE_NAME And c1.CONSTRAINT_NAME = pk.CONSTRAINT_NAME And c1.ORDINAL_POSITION=1 ' + 
					'Left Join '+@dbname+'.INFORMATION_SCHEMA.KEY_COLUMN_USAGE c2 On c2.TABLE_NAME = pk.TABLE_NAME And c2.CONSTRAINT_NAME = pk.CONSTRAINT_NAME And c2.ORDINAL_POSITION=2 ' + 
					'where pk.TABLE_NAME = @tablename And pk.CONSTRAINT_TYPE = ''PRIMARY KEY'''
select @sqltext0_params = '@dbname sysname, @tablename sysname, @pkey sysname OUTPUT, @pkey2 sysname OUTPUT'
exec sp_executesql @sqltext0, @sqltext0_params, @dbname=@dbname, @tablename=@TableName, @pkey=@PKColumnName OUTPUT, @pkey2=@PKColumnName2 OUTPUT

--'#ShortActionName#'

--select top 1 @migrationref_column = name from syscolumns  where name in ('MigrationRef','PlanMigrationRef','CommissionMigrationRef') and object_name(id) = @TableName

select @sqltext2 = 'select name from '+@dbname+'.dbo.syscolumns  where name in (''MigrationRef'',''PlanMigrationRef'',''CommissionMigrationRef'') and object_name(id,DB_ID('''+@dbname+''')) = '''+@TableName+CHAR(39)
insert @table1 exec (@sqltext2)

select @migrationref_column = migrationref_column from @table1
delete @table1

DECLARE @columnNames VARCHAR(100)
DECLARE @columnSources VARCHAR(256)

if @PKColumnName2 is null
begin 
	SET @columnNames = '(Action, TableName, PKColumn, PKValue) '
	SET @columnSources = '''#ShortActionName#'' , ''' + @TableName + ''',''' + @PKColumnName + ''',T1.' + @PKColumnName	
end
else
begin
	SET @columnNames = '(Action, TableName, PKColumn, PKValue, PKColumn2, PKValue2) '
	SET @columnSources = '''#ShortActionName#'' , ''' + @TableName + ''',''' + @PKColumnName + ''',T1.' + @PKColumnName	+ ',''' + @PKColumnName2 + ''',T1.' + @PKColumnName2	
end


select @ChangeLogSql = N'Insert SDB.dbo.TChangeLog'+case when @bulk = 1 then 'Bulk' else '' end+'
		' + @columnNames + ' 
		Select ' + @columnSources + '
		From #Source# AS T1 
		'

if @migrationref_column is not null
begin
	select @ChangeLogSql1 = N'
			if exists (select top 1 1 from inserted where '+@migrationref_column+' is not null)
			begin  
				Insert SDB.dbo.TChangeLogBulk ' + @columnNames + '
				Select  ' + @columnSources + ' 
				From #Source# As T1 
			end
			else
			begin
				Insert SDB.dbo.TChangeLog ' + @columnNames + '
				Select  ' + @columnSources + '
				From #Source# As T1 
			end
		'
end

if @migrationref_column is null
	select @ChangeLogSql1 = @ChangeLogSql

select @PolicyBusinessFundCustomTriggerPostfix = '
join deleted d on d.PolicyBusinessFundId = T1.PolicyBusinessFundId
WHERE
	T1.FundName != d.FundName
	OR T1.FundId != d.FundId
	OR T1.CategoryId != d.CategoryId
	OR T1.CurrentUnitQuantity != d.CurrentUnitQuantity 
	OR T1.LastUnitChangeDate != d.LastUnitChangeDate
	OR (T1.CurrentPrice != d.CurrentPrice AND T1.PriceUpdatedByUser != ''Price Feed'')
	OR (T1.LastPriceChangeDate != d.LastPriceChangeDate AND T1.PriceUpdatedByUser != ''Price Feed'')
'

Select @EndSql = 'End
'
------------------------------

Select @NewLine = '
'
Select @GoStatement = 'GO' + @NewLine

--- Creates
Insert Into #Script Select Replace(@DropSql, '#LongActionName#', 'Insert')
Insert Into #Script Select @GoStatement
Insert Into #Script Select Replace(@StartSql, '#LongActionName#', 'Insert')

Select @TempSql = Replace(@ChangeLogSql1, '#Source#', 'inserted' )
Select @TempSql = Replace(@TempSql, '#ShortActionName#', 'C' )
Insert Into #Script Select @TempSql 

Insert Into #Script Select @FireEvent 
Insert Into #Script Select @EndSql
Insert Into #Script Select @GoStatement

--- Update
Insert Into #Script Select Replace(@DropSql, '#LongActionName#', 'Update')
Insert Into #Script Select @GoStatement
Insert Into #Script Select Replace(@StartSql, '#LongActionName#', 'Update')


Select @TempSql = Replace(@ChangeLogSql, '#Source#', 'inserted' )
Select @TempSql = Replace(@TempSql, '#ShortActionName#', 'U' )

if @TableName = 'TIndigoClient'
	Insert Into #Script Select 'if (select status from inserted) != (select status from deleted) '

Insert Into #Script Select @TempSql 

If @TableName = 'TPolicyBusinessFund'
begin
	Insert Into #Script Select @PolicyBusinessFundCustomTriggerPostfix
end

Insert Into #Script Select @FireEvent 
Insert Into #Script Select @EndSql
Insert Into #Script Select @GoStatement

--- Delete
Insert Into #Script Select Replace(@DropSql, '#LongActionName#', 'Delete')
Insert Into #Script Select @GoStatement
Insert Into #Script Select Replace(@StartSql, '#LongActionName#', 'Delete')

Select @TempSql = Replace(@ChangeLogSql, '#Source#', 'deleted' )
Select @TempSql = Replace(@TempSql, '#ShortActionName#', 'D' )

-- remove TenantId reference because TPolicyBusinessFundTransactionAudit doesn't have a TenantId field
If @TableName = 'TPolicyBusinessFundTransaction'
begin
	Select @TempSql = Replace(@TempSql, ', PKColumn2, PKValue2', '')
	Select @TempSql = Replace(@TempSql, ',''TenantId'',T1.TenantId', '')
end

Insert Into #Script Select @TempSql 

Insert Into #Script Select @FireEvent 
Insert Into #Script Select @EndSql
Insert Into #Script Select @GoStatement

--Select @SqlToExecute = 'Use '+@dbname+ char(13)+ 'GO' + char(13)

DECLARE ScriptCursor CURSOR 
FOR 
	SELECT Script
	From #Script
	Order By Id 

OPEN ScriptCursor
FETCH NEXT FROM ScriptCursor INTO @TempSql

WHILE (@@fetch_status <> -1)
BEGIN
	Select @SqlToExecute = @SqlToExecute + @TempSql + @NewLine
		
	If @Execute = 1 And @TempSql <> @GoStatement
		Select @SqlToRun = IsNull(@SqlToRun, '') + @TempSql

	If @TempSql = @GoStatement
	Begin

		select @sqltext1 = 'exec '+@dbname+'.dbo.sp_executesql N'''+replace(@SqlToRun,char(39),char(39)+char(39))+char(39)
		Execute (@sqltext1)
		Select @SqlToRun = ''
		select @sqltext1 = ''
	End

	FETCH NEXT FROM ScriptCursor INTO @TempSql
END

CLOSE ScriptCursor
DEALLOCATE ScriptCursor

