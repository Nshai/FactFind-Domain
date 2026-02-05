SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomScriptObject] 
	@ObjectName varChar(255) , 
	@ObjectType varChar(255),
	@ScriptDropFG bit = 1,
	@ScriptCreateFG bit = 1,
	@IncludeIdentityFG bit = 0
As

Declare @NewLine varChar(255), @SqlString varChar(8000), @SqlString2 varChar(8000), @SqlDefString varChar(8000)
Declare @Dit varChar(4), @TypeCheck varChar(255), @SqlTrigString varChar(8000)


Select @NewLine = char(13), @Dit = ''''

If @ObjectType = 'Table'
Begin
	Select @TypeCheck = 'IsUserTable'
End
Else If @ObjectType = 'Procedure'
Begin
	Select @TypeCheck = 'IsProcedure'
End
Else If @ObjectType = 'UserDataType'
Begin
	Select @TypeCheck = ''
End

Set @SqlString = ''

If @ScriptDropFG = 1
	Begin

	If @ObjectType In ( 'Table' , 'Procedure' )
	Begin
		Set @SqlString = @SqlString + 'If exists (select * from dbo.sysobjects where id = object_id(N' + @Dit + '[dbo].[' + @ObjectName + ']' + @Dit + ') '
		Set @SqlString = @SqlString  + ' and OBJECTPROPERTY(id, N' + @Dit + @TypeCheck + @Dit + ') = 1)' + @NewLine
		Set @SqlString = @SqlString  + 'Drop ' + @ObjectType + ' [dbo].[' + @ObjectName + ']' + @NewLine
	End
	Else If @ObjectType = 'UserDataType'
	Begin
		Set @SqlString = @SqlString + 'if exists (select * from dbo.systypes where name = N' + @Dit + @ObjectName + @Dit +')' + @NewLine
		Set @SqlString = @SqlString + @NewLine + 'exec sp_droptype N' + @Dit + @ObjectName + @Dit + @NewLine
	End
	--Set @SqlString = @SqlString  + 'GO' + @NewLine
End

If @ObjectType = 'Table'
Begin
	Create Table #FieldInfo(
		Fieldname varChar(255) ,
		datatype varChar(255) ,
		length int ,
		defaults varChar(255) ,
		CollName varChar(255) ,
		IsNullable bit,
		DefaultName varChar(255),
		TableId bigint ,
		IndexId bigint,
		PK_Name varChar(255)
	)
	
	Set @SqlString2 = 'Insert Into #FieldInfo(Fieldname , datatype, length, defaults, CollName, IsNullable, DefaultName, TableId , IndexId , PK_Name) ' + @NewLine
	Set @SqlString2 = @SqlString2 + 'SELECT A.name, C.name, A.length, D.text, A.collation, A.isnullable , E.name, B.id , F.indid , F.name' + @NewLine
	Set @SqlString2 = @SqlString2 + 'FROM syscolumns A INNER JOIN sysobjects B ON A.id = B.id INNER JOIN systypes C ON A.xusertype = C.xusertype ' + @NewLine
	Set @SqlString2 = @SqlString2 + 'LEFT OUTER JOIN syscomments D ON A.cdefault = D.id ' + @NewLine
	Set @SqlString2 = @SqlString2 + 'LEFT OUTER JOIN sysobjects E ON A.cdefault = E.id And A.cdefault > 0 ' + @NewLine
	--Set @SqlString2 = @SqlString2 + 'Left Outer Join sysobjects G On B.id = G.parent_obj And G.xtype = ' + @Dit + 'PK' + @Dit + @NewLine
	Set @SqlString2 = @SqlString2 + 'LEFT OUTER JOIN sysindexes F ON B.parent_obj = F.id And B.xtype = ' + @Dit + 'PK' + @Dit + @NewLine
	Set @SqlString2 = @SqlString2 + 'WHERE     (B.name = N' + @Dit + @ObjectName + @Dit + ') Order By A.ColId'
	
	exec(@SqlString2)

	--TRIGGERS
--N.B. This only deals with 1 trigger
	Declare @TableId bigint, @TrigName varChar(255),@TrigId bigint
	Select @TableId = TableId From #FieldInfo
	Select @TrigName = name ,@TrigId = id from sysobjects where parent_obj = @TableId  And xtype = 'TR'

	If IsNull(@TrigName,'') <> '' And @ScriptDropFG = 1
	Begin
		Set @SqlTrigString = 'if exists (select * from dbo.sysobjects where id = object_id(N' + @Dit + '[dbo].[' + @TrigName + ']' + @Dit +') and OBJECTPROPERTY(id, N' + @Dit + 'IsTrigger' + @Dit + ') = 1)' + @NewLine
		Set @SqlTrigString = @SqlTrigString + 'drop trigger [dbo].[' + @TrigName + ']' + @NewLine --+ 'GO' + @NewLine
		Set @SqlString = @SqlTrigString + @NewLine + @SqlString
	End

	If @ScriptCreateFG = 0
	Begin
		goto finish
	End

	--PRIMARY KEYS
	Create Table #Pkeys(
		Column_Name varChar(255),
		Col_Seq varChar(255),
		PK_Name varChar(255)
	)

	--FIELDS
	Declare @Fieldname varChar(255) , @datatype varChar(255) , @length int , @defaults varChar(255) , @CollName varChar(255) , @IsNullable bit, @DefaultName varChar(255)
	Declare @IsIdentity bit, @IdentitySeed varChar(255) , @IdentityIncrement varChar(255) , @IndexId bigint, @PKeyCounter tinyint, @PKeyTest varChar(255), @PK_Name varChar(255)

	Create Table #IdentityInfo(
		IdentityFG bit,
		Seed bigint,
		Increment bigint
	)

	Set @SqlDefString = ''
	Set @SqlString = @SqlString  + 'CREATE TABLE ' + @ObjectName + '(' + @NewLine

	DECLARE Fields_Cursor CURSOR
	FOR 
		SELECT Fieldname , datatype, length, defaults, CollName, IsNullable, DefaultName , IndexId , PK_Name FROM #FieldInfo
	
	OPEN Fields_Cursor	FETCH NEXT FROM Fields_Cursor INTO @Fieldname, @datatype, @length, @defaults, @CollName, @IsNullable, @DefaultName , @IndexId , @PK_Name
	
	While @@FETCH_STATUS <> -1
	Begin

		Set @SqlString = @SqlString + '	[' + @Fieldname + '] ' + '[' + @datatype + '] ' 

		If @datatype In ('varchar' , 'nvarchar' , 'char' , 'nchar')
		Begin
			Set @SqlString = @SqlString + '(' + convert(varChar(255), IsNull(@length,0)) + ') COLLATE ' + IsNull(@CollName,'') + Space(1)
		End
		Else If @datatype In ('text' , 'ntext')
		Begin
			Set @SqlString = @SqlString + ' COLLATE ' + IsNull(@CollName,'') + Space(1)
		End

		If @IncludeIdentityFG = 1
		Begin
			-- We had problem with bulk importing data into the identity field even using SET IDENTITY
			Set @SqlString2 = 'Insert Into #IdentityInfo(IdentityFG) ' + @NewLine
			Set @SqlString2 = @SqlString2 +  'SELECT COLUMNPROPERTY(OBJECT_ID(' + @Dit + @ObjectName + @Dit + '),' + @Dit + @Fieldname + @Dit + ',' + @Dit + 'IsIdentity' + @Dit + ')'
	
			Exec(@SqlString2)
			SELECT @IsIdentity = IdentityFG From #IdentityInfo
	
			If @IsIdentity = 1 --Identity
			Begin
				Set @SqlString2 = 'Update #IdentityInfo ' + @NewLine
				Set @SqlString2 = @SqlString2 + 'Set Seed = IDENT_SEED(' + @Dit + @ObjectName + @Dit + ') , Increment = IDENT_INCR ( '+ @Dit + @ObjectName + @Dit + ' ) '
	
				Execute(@SqlString2)
				Select @IdentitySeed = Seed, @IdentityIncrement = Increment From #IdentityInfo
				Set @SqlString = @SqlString + 'IDENTITY (' + @IdentitySeed + ', ' + @IdentityIncrement + ') '
			End
			Truncate Table #IdentityInfo
		End

		If @IsNullable = 1 --Nullable
		Begin
			Set @SqlString = @SqlString + 'NULL '
		End
		Else
		Begin
			Set @SqlString = @SqlString + 'NOT NULL '
		End

		If IsNull(@DefaultName,'') <> '' --Default
		Begin
			Set @SqlDefString = @SqlDefString + '	CONSTRAINT [' + @DefaultName + '] DEFAULT ' + @defaults + ' FOR [' + @Fieldname + '] ,' + @NewLine
		End
		Set @SqlString = @SqlString + ' ,' + @NewLine

		FETCH NEXT FROM Fields_Cursor INTO @Fieldname, @datatype, @length, @defaults, @CollName, @IsNullable, @DefaultName , @IndexId , @PK_Name
	End
	
	CLOSE Fields_Cursor	
	DEALLOCATE Fields_Cursor

	-- take out the last comma
	Set @SqlString = left(@SqlString,Len(@SqlString) - 3) + @NewLine + ') ON [PRIMARY] ' + @NewLine --+ 'GO' + @NewLine 



	INSERT INTO #PKeys 
    	SELECT
		COLUMN_NAME = convert(sysname,c.name),
		KEY_SEQ =
			case
				when c.name = index_col (quotename(@ObjectName), i.indid,  1) then convert (smallint,1)
				when c.name = index_col (quotename(@ObjectName), i.indid,  2) then convert (smallint,2)
				when c.name = index_col (quotename(@ObjectName), i.indid,  3) then convert (smallint,3)
				when c.name = index_col (quotename(@ObjectName), i.indid,  4) then convert (smallint,4)
				when c.name = index_col (quotename(@ObjectName), i.indid,  5) then convert (smallint,5)
				when c.name = index_col (quotename(@ObjectName), i.indid,  6) then convert (smallint,6)
				when c.name = index_col (quotename(@ObjectName), i.indid,  7) then convert (smallint,7)
				when c.name = index_col (quotename(@ObjectName), i.indid,  8) then convert (smallint,8)
				when c.name = index_col (quotename(@ObjectName), i.indid,  9) then convert (smallint,9)
				when c.name = index_col (quotename(@ObjectName), i.indid, 10) then convert (smallint,10)
				when c.name = index_col (quotename(@ObjectName), i.indid, 11) then convert (smallint,11)
				when c.name = index_col (quotename(@ObjectName), i.indid, 12) then convert (smallint,12)
				when c.name = index_col (quotename(@ObjectName), i.indid, 13) then convert (smallint,13)
				when c.name = index_col (quotename(@ObjectName), i.indid, 14) then convert (smallint,14)
				when c.name = index_col (quotename(@ObjectName), i.indid, 15) then convert (smallint,15)
				when c.name = index_col (quotename(@ObjectName), i.indid, 16) then convert (smallint,16)
			end,
		PK_NAME = convert(sysname,i.name)
	FROM
		sysindexes i, syscolumns c, sysobjects o 
	WHERE
		o.id = object_id(quotename(@ObjectName))
		and o.id = c.id
		and o.id = i.id
		and (i.status & 0x800) = 0x800
		and (c.name = index_col (quotename(@ObjectName), i.indid,  1) or
		     c.name = index_col (quotename(@ObjectName), i.indid,  2) or
		     c.name = index_col (quotename(@ObjectName), i.indid,  3) or
		     c.name = index_col (quotename(@ObjectName), i.indid,  4) or
		     c.name = index_col (quotename(@ObjectName), i.indid,  5) or
		     c.name = index_col (quotename(@ObjectName), i.indid,  6) or
		     c.name = index_col (quotename(@ObjectName), i.indid,  7) or
		     c.name = index_col (quotename(@ObjectName), i.indid,  8) or
		     c.name = index_col (quotename(@ObjectName), i.indid,  9) or
		     c.name = index_col (quotename(@ObjectName), i.indid, 10) or
		     c.name = index_col (quotename(@ObjectName), i.indid, 11) or
		     c.name = index_col (quotename(@ObjectName), i.indid, 12) or
		     c.name = index_col (quotename(@ObjectName), i.indid, 13) or
		     c.name = index_col (quotename(@ObjectName), i.indid, 14) or
		     c.name = index_col (quotename(@ObjectName), i.indid, 15) or
		     c.name = index_col (quotename(@ObjectName), i.indid, 16))
	order by 1, 2


	--PRIMARY KEYS
	If Exists(Select * From #Pkeys)
	Begin
		Declare @Counter int, @Count int
		Select @PK_Name = Max(PK_Name) From #Pkeys
		Select @Count= Count(*) From #Pkeys
		Set @SqlString = @SqlString + 'ALTER TABLE [dbo].[' + @ObjectName + '] WITH NOCHECK ADD ' + @NewLine
		Set @SqlString = @SqlString + '	CONSTRAINT [' + @PK_Name  + '] PRIMARY KEY  CLUSTERED ' + @NewLine
		Set @SqlString = @SqlString + '	( ' + @NewLine
		
		Select @Counter = 1
		While (@Counter <= @Count)
		Begin
			Select @Fieldname = Column_Name From #Pkeys Where Col_Seq = @Counter
			Set @SqlString = @SqlString + '		[' + @Fieldname + '] ,' + @NewLine
			Select @Counter = @Counter + 1
		End

		-- take out the last comma
		Set @SqlString = Left(@SqlString,Len(@SqlString) - 2) + @NewLine + '	) ON [PRIMARY] ' + @NewLine --+ 'GO' + @NewLine 

		Drop Table #Pkeys
	End

	--DEFAULTS
	If IsNull(@SqlDefString,'') <> ''
	Begin
		Set @SqlString = @SqlString + 'ALTER TABLE [dbo].[' + @ObjectName + '] WITH NOCHECK ADD ' + @NewLine
		Set @SqlString = @SqlString + Left(@SqlDefString,Len(@SqlDefString) - 2) + @NewLine
		--Set @SqlString = @SqlString + 'GO' + @NewLine
	End

	--TRIGGERS
	If IsNull(@TrigName,'') <> '' And IsNull(@TrigId,0) <> 0
	Begin
		Select @SqlTrigString = text from syscomments Where id = @TrigId
		--Set @SqlString = @SqlString + ' ' + @NewLine + 'GO' + @NewLine + ' ' + @NewLIne + 'GO' + @NewLine
		Set @SqlString = @SqlString + ' ' + @NewLine  + ' ' + @NewLine
		Set @SqlString = @SqlString + @SqlTrigString + @NewLine + 'GO' + @NewLine
		--Set @SqlString = @SqlString + ' ' + @NewLine + 'GO' + @NewLine + ' ' + @NewLIne + 'GO' + @NewLine
		Set @SqlString = @SqlString + ' ' + @NewLine + ' ' + @NewLine 

	End

	Drop Table #FieldInfo
	Drop Table #IdentityInfo

End
Else If @ScriptCreateFG = 0
Begin
	goto finish
End
Else If @ObjectType = 'Procedure'
Begin
	--The sp is stored in syscoments across multiple records
	Create Table #Procedure(
		mId bigint Identity ( 1 , 1 ) ,
		mtext varChar(4000)
	)

	Declare @ProcCount bigint, @ProcCounter bigint, @ProcText varChar(4000)

	Set @SqlString = @SqlString  + ' ' + @NewLine --+ 'GO' + @NewLine
--	Set @SqlString = @SqlString + Select
	Set @SqlString = @SqlString  + ' ' + @NewLine --+ 'GO' + @NewLine

	Insert Into #Procedure
	(mtext)
	Select b.text 
	From dbo.sysobjects A
	Inner Join dbo.syscomments B
		On A.id = B.id
	Where A.id = object_id(@ObjectName) and OBJECTPROPERTY(A.id, N'IsProcedure') = 1

	Select @ProcCount  = count(*) , @ProcCounter = 1 from #Procedure

	While ( @ProcCounter <= @ProcCount )
	Begin
		Select @ProcText =  mtext From #Procedure Where mId = @ProcCounter
		Set @SqlString = @SqlString  + @ProcText 
		Select @ProcCounter = @ProcCounter + 1
	End

	Set @SqlString = @SqlString  + @NewLine + 'GO' + @NewLine + ' ' + @NewLine --+ 'GO' + @NewLine
	Set @SqlString = @SqlString  + ' ' + @NewLine --+ 'GO'

	Drop Table #Procedure
End
Else If @ObjectType = 'UserDataType'
Begin
	Declare @Length2 bigint, @XType2 bigint, @DataType2 varChar(255), @AllowNulls2 bit
	Create Table #DataType(
		length bigint ,
		xtype bigint ,
		allownulls bit
	)
	
	Select @SqlString2 = 'Insert Into #DataType(length , xtype, allownulls)'
	Select @SqlString2 = @SqlString2 + 'Select length, xtype, allownulls From systypes Where (name = N' + @Dit + @ObjectName + @Dit + ')'
	Exec(@SqlString2)
	Select @Length2 = length, @XType2 = xtype, @AllowNulls2 = allownulls From #DataType
	Select @DataType2 = name from systypes Where xtype = @XType2 and xtype = xusertype

	Set @SqlString = @SqlString + 'setuser' + @NewLine --+ 'GO' + @NewLine
	Set @SqlString = @SqlString + 'EXEC sp_addtype N' + @Dit + @ObjectName + @Dit + ', N' + @Dit + @DataType2
	
	If @DataType2 In ('varchar' , 'nvarchar' , 'text' , 'ntext' , 'char' , 'nchar')
	Begin
		Set @SqlString = @SqlString + ' (' + convert(varChar(255), IsNull(@Length2,0)) + ')'
	End

	Set @SqlString = @SqlString + @Dit + ', N' + @Dit 
	If @AllowNulls2 = 0
	Begin
	Set @SqlString = @SqlString + 'not '
	End
	Set @SqlString = @SqlString + 'null' + @Dit + @NewLine

	Set @SqlString = @SqlString + 'setuser' + @NewLine --+ 'GO' + @NewLine

	Drop Table #DataType
End

finish:
	Select SpCustomScriptObject = @SqlString --, Len(@SqlString + @SqlString)

GO
