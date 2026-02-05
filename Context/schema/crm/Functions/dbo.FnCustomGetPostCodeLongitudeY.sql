SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnCustomGetPostCodeLongitudeY]
	(@PostCode varchar (20))
	RETURNS Decimal (18,8)
AS
BEGIN
	Declare @ReturnValue decimal (18,8)
	
	If @PostCode Is Not Null And LEN(@PostCode)>=3
	Begin
		Select Top 1 @ReturnValue = p.LongitudeY
		From crm..TPostCode p
		Where ltrim(rtrim(@PostCode)) is not null 
		And ltrim(rtrim(@PostCode)) != ''
		And len(ltrim(rtrim(@PostCode))) >= 3
		And @PostCode not like '--%'
		And @PostCode not like '-%-'
		And replace(@PostCode,char(32),'') != ''
		And replace(@PostCode,char(32),'') is not null
		And p.PostCodeShortName = RTrim(LTrim(SUBSTRING(@PostCode,1,LEN(@PostCode)-3)))
	End 
	RETURN @ReturnValue
END
GO
