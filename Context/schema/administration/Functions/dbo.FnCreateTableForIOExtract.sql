SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnCreateTableForIOExtract] (@TableName varchar(255), @NoofColumns tinyint)  
RETURNS int AS  
BEGIN 

--## This is used with the SPs to create global tables for the IO Extract
--## Column naming convention is Col_x where x is a number- I.e. Col_1, Col_2 etc...


--## Test lines
--Set @TableName = '##IODataExtract_Group'
--Set @NoofColumns = 3

Declare @Cnt tinyint, @NSQL nvarchar(4000), @Result int

--Drop table if it exists
Set @NSQL = 'if object_id(N''tempdb..' + @TableName +''') is not null
drop table ' + @TableName

exec sp_executesql @NSQL


Select @Cnt = 0, @NSQL = ''


While @Cnt < @NoofColumns
Begin

	Set @NSQL = @NSQL + Case When Len(@NSQL)> 0 Then ', ' Else '' End + 'Col_' + Convert(varchar(20),@Cnt + 1) + ' varchar(8000)'

	Set @Cnt = @Cnt + 1

	If @Cnt < @NoofColumns
		Continue
	else
		Break

End

Set @NSQL = 'Create Table ' + @TableName + ' ( ' + @NSQL + ' )'

--## Test line
--Select a = @NSQL

Exec @Result = sp_executesql @NSQL

Return @Result

END
GO
