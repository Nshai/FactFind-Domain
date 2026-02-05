SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
drop Function FnGetSafeSql
go
Create Function FnGetSafeSql
(
	@ReplacePercent bit,
	@Text varchar(2000)
)
Returns varchar(200)
As

Begin
	If ISNULL(@Text, '') = '' Return(@Text)

	Select @Text = REPLACE(@Text, ';' , '')
	Select @Text = REPLACE(@Text, '''' , '')
	Select @Text = REPLACE(@Text, '--' , '')
	Select @Text = REPLACE(@Text, 'xp[_]' , '')
	Select @Text = REPLACE(@Text, '/*' , '')
	Select @Text = REPLACE(@Text, '*/' , '')
	if @ReplacePercent = 1 Select @Text = REPLACE(@Text, '%' , '[%]')
	Select @Text = REPLACE(@Text, '[' , '[[]')
	Select @Text = REPLACE(@Text, '_' , '[_]')

	return(@Text)
End

