SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Drop FUNCTION [dbo].[FnCustomEncryptPortalPassword]

Create FUNCTION [dbo].[FnCustomEncryptPortalPassword]  (@StringToEncrypt varchar(4000))
RETURNS varbinary(4000)
AS
BEGIN
	Declare @Result varbinary(4000)
	
	If @StringToEncrypt is null or LTrim(RTrim(@StringToEncrypt)) = ''
		Select @Result = null
	Else
		Select @Result = EncryptByKey(Key_GUID('SymmetricKeyForPasswordEncryption'), @StringToEncrypt )
	
	Return @Result
End
	