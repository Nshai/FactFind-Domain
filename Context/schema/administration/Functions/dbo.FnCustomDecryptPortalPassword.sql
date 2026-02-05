SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Drop FUNCTION [dbo].[FnCustomDecryptPortalPassword]

Create FUNCTION [dbo].[FnCustomDecryptPortalPassword]  (@EncrypedString varbinary(4000))
RETURNS varchar(4000)
AS
BEGIN
	Declare @Result varchar(4000)
	
	If @EncrypedString is null or LTrim(RTrim(@EncrypedString)) = ''
		Select @Result = ''
	Else
		Select @Result = CONVERT(varchar(100), DecryptByKey(@EncrypedString))
	
	Return @Result
End
	